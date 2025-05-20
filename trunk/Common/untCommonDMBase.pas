unit untCommonDMBase;

interface
{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  Aspect, SysUtils, Data.DB, Classes, Datasnap.DBClient, ClassLibrary;

type
  TdmBase = class(TDataModule)
    dtsMain: TDataSource;
    procedure OnReconcileError(DataSet: TCustomClientDataSet; E: EReconcileError; UpdateKind: TUpdateKind; var Action: TReconcileAction);
  protected
    FIDUnidade: Integer;
    function GetIdUnidade: Integer; virtual;
    procedure SetIdUnidade(const Value: Integer); virtual;
  public
    destructor Destroy; Override;
    class function GetInstancia(const aIDUnidade: integer; const aAllowNewInstance: Boolean = True; const aOwner: TComponent = nil): TdmBase;
    constructor Create(AOwner: TComponent); overload; Override;
    constructor Create(AOwner: TComponent; const aIdUnidade: Integer); reintroduce; overload; virtual;

    function PossuiModificacoes: Boolean; virtual;
    function Save: Boolean;
    function Excluir: Boolean;
    procedure ExcluirComConfirmacao;
    class function ModificouDataSet(aDataset: TClientDataSet): Boolean;
    procedure AfterConstruction; override;
    property IdUnidade: Integer read GetIdUnidade write SetIdUnidade;
  end;


implementation


{$R *.dfm}
uses
   untCommonDMConnection;


constructor TdmBase.Create(AOwner: TComponent);
begin
  inherited;
  FidUnidade := ID_UNIDADE_VAZIA;
end;

procedure TdmBase.AfterConstruction;
begin
  inherited;

  if (IdUnidade = ID_UNIDADE_VAZIA) then
    IdUnidade := ID_UNIDADE_PRINCIPAL;
end;

constructor TdmBase.Create(AOwner: TComponent; const aIdUnidade: Integer);
begin
  Create(AOwner);
  IdUnidade := aIdUnidade;
end;

destructor TdmBase.Destroy;
begin
  if assigned(dtsMain.DataSet) and dtsMain.DataSet.active then
  begin
    if dtsMain.DataSet.State in dsEditModes Then
       dtsMain.DataSet.Cancel;

    if (dtsMain.DataSet is TClientDataSet) then
      TClientDataSet(dtsMain.DataSet).CancelUpdates;
  end;

  inherited;
end;

function TdmBase.Excluir: Boolean;
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

procedure TdmBase.ExcluirComConfirmacao;
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

function TdmBase.GetIdUnidade: Integer;
begin
  Result := FIDUnidade;
end;

class function TdmBase.GetInstancia(const aIDUnidade: integer; const aAllowNewInstance: Boolean; const aOwner: TComponent): TdmBase;
var
  LOwner: TComponent;
begin
  Result := TdmBase(GetApplication.FindComponent(ClassName + inttostr(aIDUnidade)));
  if ((not Assigned(Result)) and (aIDUnidade >= 0) ) then //and aAllowNewInstance  BAH retirado pois nunca criava instancia do datamodule
  begin
    LOwner := aOwner;
    if not Assigned(LOwner) then
      LOwner := GetApplication;
    Result := Self.Create(LOwner, aIDUnidade);
    Result.Name := ClassName + inttostr(aIdUnidade);
  end;
end;

class function TdmBase.ModificouDataSet(aDataset: TClientDataSet): Boolean;
begin
  Result := (Assigned(aDataset) and aDataset.Active and
    ((aDataset.ChangeCount > 0) or (aDataset.State in[dsInsert, dsEdit])));
end;

procedure TdmBase.OnReconcileError(DataSet: TCustomClientDataSet; E: EReconcileError; UpdateKind: TUpdateKind; var Action: TReconcileAction);
begin
  MyLogException(E);
end;

function TdmBase.PossuiModificacoes: Boolean;
begin
  Result := False;
end;

function TdmBase.Save: BOolean;
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

procedure TdmBase.SetIdUnidade(const Value: Integer);
begin
  if (IDUnidade <> Value) then
    FIDUnidade := Value;
end;

end.
