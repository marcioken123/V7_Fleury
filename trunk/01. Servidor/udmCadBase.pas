unit udmCadBase;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  {$IFNDEF IS_MOBILE}

  {$ENDIF IS_MOBILE}
  SysUtils, Data.DB, Classes, Datasnap.DBClient,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Comp.Client, uDataSetHelper;

type
  TdmSicsCadBase = class(TDataModule)
  private
  {$IFNDEF IS_MOBILE}
    FSqlConnUnidade: TFDConnection;
  {$ENDIF IS_MOBILE}
    FIDUnidade: Integer;
  protected
    {$IFNDEF IS_MOBILE}
    procedure SetSqlConnUnidade(const Value: TFDConnection); Virtual;
    function GetSqlConnUnidade: TFDConnection; Virtual;
    {$ENDIF IS_MOBILE}
    procedure SetIDUnidade(const Value: Integer); Virtual;
  public
    procedure Inicializar; Virtual;
    property IDUnidade: Integer read FIDUnidade write SetIDUnidade;
    destructor Destroy; Override;
    constructor Create(aOwner: TComponent); Override;
    function GetNextGenerator(GeneratorName: string): integer; Virtual;
    procedure AtualizarTabelasPis;
  published
    {$IFNDEF IS_MOBILE}
    property SqlConnUnidade: TFDConnection read GetSqlConnUnidade write SetSqlConnUnidade;
    {$ENDIF IS_MOBILE}
    procedure OnReconcileError(DataSet: TCustomClientDataSet; E: EReconcileError; UpdateKind: TUpdateKind; var Action: TReconcileAction);
  end;

  TClassdmSicsCadBase = class of TdmSicsCadBase;

implementation

uses sics_94, UConexaoBD,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt,
  ASPGenerator;

{$R *.dfm}

procedure TdmSicsCadBase.AtualizarTabelasPis;
begin
  dmSicsMain.AtualizarTabelasPis;
end;

constructor TdmSicsCadBase.Create;
begin
  inherited;
  {$IFNDEF IS_MOBILE}
  FSqlConnUnidade := nil;
  TConexaoBD.DefinirQueriesComoUnidirectional(Self);
  {$ENDIF IS_MOBILE}
  FIdUnidade := 0;
end;

destructor TdmSicsCadBase.Destroy;
begin
  {$IFNDEF IS_MOBILE}
  if Assigned(SqlConnUnidade) then
    SqlConnUnidade.Connected := False;
  {$ENDIF IS_MOBILE}
  inherited;
end;

function TdmSicsCadBase.GetNextGenerator(GeneratorName: string): integer;
begin
  {$IFNDEF IS_MOBILE}
  Result := TGenerator.NGetNextGenerator(GeneratorName, SqlConnUnidade);
  {$ELSE}
  Result := 0; //FMXMobile
  {$ENDIF IS_MOBILE}
end;

procedure TdmSicsCadBase.Inicializar;
begin
  {$IFNDEF IS_MOBILE}
  if IdUnidade > 0 then
    SqlConnUnidade := dmSicsMain.CreateSqlConnUnidade(Self, IdUnidade)
  else
    SqlConnUnidade := dmSicsMain.connOnLine;

  dmSicsMain.SetNewSqlConnectionForSQLDataSet(Self, SqlConnUnidade);
  {$ENDIF  IS_MOBILE}
end;

procedure TdmSicsCadBase.OnReconcileError(DataSet: TCustomClientDataSet; E: EReconcileError; UpdateKind: TUpdateKind; var Action: TReconcileAction);
begin
	//MyLogException(E);
end;

procedure TdmSicsCadBase.SetIDUnidade(const Value: Integer);
begin
  FIDUnidade := Value;
  Inicializar;
end;

{$IFNDEF IS_MOBILE}
function TdmSicsCadBase.GetSqlConnUnidade: TFDConnection;
begin
  Result := FSqlConnUnidade;
end;

procedure TdmSicsCadBase.SetSqlConnUnidade(const Value: TFDConnection);
var
  I: Integer;
begin
  if (FSqlConnUnidade = Value) then
    Exit;
  FSqlConnUnidade := Value;

  for I := 0 to Self.ComponentCount -1 do
  begin
    if (Self.Components[i] is TFDQuery) then
      TFDQuery(Self.Components[i]).Connection := FSqlConnUnidade;
  end;
end;
{$ENDIF IS_MOBILE}

end.
