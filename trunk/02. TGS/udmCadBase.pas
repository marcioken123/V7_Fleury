unit udmCadBase;

interface
{$INCLUDE ..\AspDefineDiretivas.inc}



uses
  {$IFNDEF IS_MOBILE}
  
  {$ENDIF IS_MOBILE}
  SysUtils, Data.DB, Classes, Datasnap.DBClient, MyAspFuncoesUteis,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, 
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, 
  FireDAC.Phys, FireDAC.Comp.Client, FireDAC.DBX.Migrate;

type
  TdmSicsCadBase = class(TDataModule)
  dtsMain: TDataSource;
  private
  protected
    FIDUnidade: Integer;
    function GetIdUnidade: Integer;
    procedure SetIdUnidade(const Value: Integer);
  {$IFNDEF IS_MOBILE}
    procedure SetSqlConnUnidade(const Value: TFDConnection);
    function GetSqlConnUnidade: TFDConnection;
  {$ENDIF IS_MOBILE}

  public
    class function ModificouDataSet(aDataset: TClientDataSet): Boolean;
    procedure Inicializar; Virtual;
    destructor Destroy; Override;
    constructor Create(aOwner: TComponent); overload;
    constructor Create(AOwner: TComponent; const aIdUnidade: Integer); overload; virtual;
    function GetNextGenerator(GeneratorName: string): integer; Virtual;
    property IdUnidade: Integer read GetIdUnidade write SetIdUnidade;
    function PossuiModificacoes: Boolean; virtual;
    procedure ExcluirComConfirmacao;
    function Excluir: Boolean;
    function Save: Boolean;
    //class function GetInstancia(const aIDUnidade: integer; const aAllowNewInstance: Boolean = True; const aOwner: TComponent = nil): TdmSicsCadBase;
  end;

  TClassdmSicsCadBase = class of TdmSicsCadBase;

implementation


{$R *.dfm}
uses
  untCommonDMConnection, udmCadHor, untCommonDMClient, untCommonDMUnidades,
  Sics_Common_Parametros,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, 
  FireDAC.Comp.DataSet, ASPGenerator;

constructor TdmSicsCadBase.Create(aOwner: TComponent);
begin
  inherited;
  FIDUnidade := ID_UNIDADE_VAZIA;
end;

constructor TdmSicsCadBase.Create(AOwner: TComponent;
  const aIdUnidade: Integer);
begin
  Create(AOwner);
  IdUnidade := aIdUnidade;
end;

destructor TdmSicsCadBase.Destroy;
begin
  inherited;
end;

function TdmSicsCadBase.Excluir: Boolean;
begin
  Result := False;
  if Assigned(dtsMain.DataSet) and dtsMain.DataSet.Active then
  begin
    Result := True;
    if (dsInsert = dtsMain.DataSet.State) then
    begin
      dtsMain.DataSet.Cancel;
      Exit;
    end;

    if (dtsMain.DataSet.State = dsEdit) then
      dtsMain.DataSet.Cancel;

    dtsMain.DataSet.Delete;
  end;
end;

procedure TdmSicsCadBase.ExcluirComConfirmacao;
var
  LOldRecno: Integer;
begin
  LOldRecno := dtsMain.DataSet.RecNo;
	ConfirmationMessage('Confirma exclusão deste registro?',
    procedure (const aOK: Boolean)
    begin
      if aOK then
      begin
        if (LOldRecno = dtsMain.DataSet.RecNo) then
        begin
        	Excluir;
        end
        else
          ErrorMessage(Format('Contexto foi alterado. Registro de %d para %d.', [LOldRecno, dtsMain.DataSet.RecNo]));
      end;
    end);
end;

function TdmSicsCadBase.GetNextGenerator(GeneratorName: string): integer;
begin
  {$IFNDEF IS_MOBILE}
  Result := TGenerator.NGetNextGenerator(GeneratorName, DMClient(IDUnidade, not CRIAR_SE_NAO_EXISTIR).connDMClient);
  {$ELSE}
  Result := 0; //FMXMobile
  {$ENDIF IS_MOBILE}
end;

procedure TdmSicsCadBase.Inicializar;
begin
  {$IFNDEF IS_MOBILE}
  DMClient(IDUnidade, not CRIAR_SE_NAO_EXISTIR)
    .SetNewSqlConnectionForSQLDataSet(Self);
  {$ENDIF  IS_MOBILE}
end;

class function TdmSicsCadBase.ModificouDataSet(
  aDataset: TClientDataSet): Boolean;
begin
  Result := (Assigned(aDataset) and aDataset.Active and
    ((aDataset.ChangeCount > 0) or (aDataset.State in[dsInsert, dsEdit])));
end;

function TdmSicsCadBase.PossuiModificacoes: Boolean;
begin
  Result := False;
end;

function TdmSicsCadBase.Save: Boolean;
begin
  Result := False;
  if ASsigned(dtsMain.DataSet) and dtsMain.DataSet.Active then
  begin
    if (dtsMain.DataSet.State in dsEditModes) then
      dtsMain.DataSet.Post;
    if (dtsMain.DataSet is TClientDataSet) then
      Result := (TClientDataSet(dtsMain.DataSet).ApplyUpdates(0) = 0);
  end;
end;

procedure TdmSicsCadBase.SetIdUnidade(const Value: Integer);
begin
  if (IdUnidade <> Value) then
  begin
    FIDUnidade := Value;
    Inicializar;
  end;
end;
function TdmSicsCadBase.GetIdUnidade: Integer;
begin
  Result := FIDUnidade;
end;

//class function TdmSicsCadBase.GetInstancia(const aIDUnidade: integer;
//  const aAllowNewInstance: Boolean; const aOwner: TComponent): TdmSicsCadBase;
//var
//  LOwner: TComponent;
//begin
//  Result := TdmSicsCadBase(GetApplication.FindComponent(ClassName + inttostr(aIDUnidade)));
//  if ((not Assigned(Result)) and (aIDUnidade >= 0) and aAllowNewInstance) then
//  begin
//    LOwner := aOwner;
//    if not Assigned(LOwner) then
//      LOwner := GetApplication;
//    Result := Self.Create(LOwner, aIDUnidade);
//    Result.Name := ClassName + inttostr(aIdUnidade);
//  end;
//end;

{$IFNDEF IS_MOBILE}
function TdmSicsCadBase.GetSqlConnUnidade: TFDConnection;
begin
  Result := DMClient(IdUnidade, not CRIAR_SE_NAO_EXISTIR).connDMClient;
end;

procedure TdmSicsCadBase.SetSqlConnUnidade(const Value: TFDConnection);
var
  I: Integer;
begin
  for I := 0 to Self.ComponentCount -1 do
  begin
    if (Self.Components[i] is TFDQuery) then
      TFDQuery(Self.Components[i]).Connection := Value;
  end;
end;
{$ENDIF IS_MOBILE}

end.
