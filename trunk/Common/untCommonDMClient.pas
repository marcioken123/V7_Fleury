unit untCommonDMClient;

{$INCLUDE ..\AspDefineDiretivas.inc}

interface

uses
  System.Generics.Collections,
  System.SysUtils, System.Classes, Data.DB, Datasnap.DBClient, System.Types,
  {$IFNDEF IS_MOBILE}FireDAC.Phys.FB, FireDAC.Phys.MSSQLDef, FireDAC.VCLUI.Wait,
  FireDAC.Phys.FBDef, FireDAC.Phys.ODBCBase, FireDAC.Phys.MSSQL,{$ENDIF IS_MOBILE}
  Data.FMTBcd, Datasnap.Provider, FMX.ExtCtrls, FMX.Types, FMX.Objects, FMX.StdCtrls,  System.UITypes,

  {$IFDEF SuportaCodigoBarras}
  VaComm, VaClasses, VaPrst,
  {$ENDIF SuportaCodigoBarras}
  {$IFDEF CompilarPara_SICS_CONFIG}
  uFuncoes,
  {$ENDIF CompilarPara_SICS_CONFIG}
  System.Variants, System.UIConsts, System.Math,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Comp.Client, FireDAC.DBX.Migrate, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet
 {$IF not Defined(CompilarPara_TV) AND not Defined(CompilarPara_TotemAA) AND not Defined(CompilarPara_ONLINE) AND not Defined(CompilarPara_TGSMOBILE)}
  , uDataSetHelper
  {$ENDIF};
type
  TProcIDUnidade = TProc<Integer>;

  TParamsNiveisSla = record
    Amarelo: integer;
    Vermelho: integer;
  end;

  TDMClient = class(TDataModule)
    cdsFilas: TClientDataSet;
    cdsFilasID: TIntegerField;
    cdsFilasNome: TStringField;
    cdsPAs: TClientDataSet;
    cdsPAsID: TIntegerField;
    cdsPAsNome: TStringField;
    cdsPAsIdGrupo: TIntegerField;
    cdsAtendentes: TClientDataSet;
    cdsAtendentesID: TIntegerField;
    cdsAtendentesNome: TStringField;
    cdsAtendentesRegistroFuncional: TStringField;
    cdsAtendentesSenhaLogin: TStringField;
    cdsAtendentesIdGrupo: TIntegerField;
    cdsGruposDeAtendentes: TClientDataSet;
    cdsGruposDeAtendentesID: TIntegerField;
    cdsGruposDeAtendentesNome: TStringField;
    cdsGruposDePAs: TClientDataSet;
    cdsGruposDePAsID: TIntegerField;
    cdsGruposDePAsNome: TStringField;
    cdsGruposDeTAGs: TClientDataSet;
    cdsGruposDeTAGsID: TIntegerField;
    cdsGruposDeTAGsNOME: TStringField;
    cdsTags: TClientDataSet;
    cdsTagsID: TIntegerField;
    cdsTagsNOME: TStringField;
    cdsTagsIdGrupo: TIntegerField;
    cdsTagsCODIGOCOR: TIntegerField;
    cdsPPs: TClientDataSet;
    cdsPPsID: TIntegerField;
    cdsPPsNOME: TStringField;
    cdsPPsIdGrupo: TIntegerField;
    cdsPPsCODIGOCOR: TIntegerField;
    cdsGruposDePPs: TClientDataSet;
    cdsGruposDePPsID: TIntegerField;
    cdsGruposDePPsNOME: TStringField;
    cdsMotivosPausa: TClientDataSet;
    IntegerField1: TIntegerField;
    StringField1: TStringField;
    IntegerField2: TIntegerField;
    cdsMotivosPausaCodigoCor: TIntegerField;
    cdsGruposDeMotivosPausa: TClientDataSet;
    IntegerField3: TIntegerField;
    StringField2: TStringField;
    cdsStatusPAs: TClientDataSet;
    IntegerField4: TIntegerField;
    StringField3: TStringField;
    connDMClient: TFDConnection;
    qryPAs: TFDQuery;
    dspPAs: TDataSetProvider;
    dspAtendentes: TDataSetProvider;
    qryAtendentes: TFDQuery;
    CDSSenhas: TClientDataSet;
    CDSSenhasIDFILA: TIntegerField;
    CDSSenhasSENHA: TIntegerField;
    CDSSenhasNOMECLIENTE: TStringField;
    CDSSenhasHORA: TTimeField;
    CDSSenhasDATAHORA: TDateTimeField;
    CDSPIs: TClientDataSet;
    CDSPIsPI: TStringField;
    CDSPIsVALOR: TStringField;
    CDSPIsESTADO: TStringField;
    CDSPIsIDPI: TIntegerField;
    CDSPIsIDESTADO: TStringField;
    cdsUnidadesClone: TClientDataSet;
    cdsUnidades: TClientDataSet;
    cdsUnidadesID: TIntegerField;
    cdsUnidadesNOME: TStringField;
    cdsUnidadesPATH_BASE_ONLINE: TStringField;
    cdsUnidadesPATH_BASE_RELATORIOS: TStringField;
    cdsUnidadesIDX_CONN_RELATORIO: TIntegerField;
    cdsUnidadesIP_ENDERECO: TStringField;
    cdsUnidadesIP_PORTA: TIntegerField;
    cdsUnidadesCONECTADA: TBooleanField;
    cdsEmails: TClientDataSet;
    cdsPaineis: TClientDataSet;
    cdsGruposDePaineis: TClientDataSet;
    cdsMotivosDePausa: TClientDataSet;
    cdsCelulares: TClientDataSet;
    dspGenerico: TDataSetProvider;
    tblGenerica: TFDTable;
    cdsNN_PAs_Filas: TClientDataSet;
    connRelatorio: TFDConnection;
    cdsAtendenteslogin: TStringField;
    cdsAgendamentosSenhasPorFila: TClientDataSet;
    cdsAgendamentosSenhasPorFilaIdPA: TIntegerField;
    cdsAgendamentosSenhasPorFilaSenha: TIntegerField;
    cdsAgendamentosSenhasPorFilaIdFila: TIntegerField;
    cdsAgendamentosSenhasPorFilaDataHora: TDateTimeField;
    cdsFilasCor: TIntegerField;
    CDSSenhasCOR_LINHA: TIntegerField;
    qryImagemFila: TFDQuery;
    dspImagemFila: TDataSetProvider;
    cdsImagemFila: TClientDataSet;
    cdsImagemFilaIMAGEM_FILA: TBlobField;
    cdsImagemFilaALINHAMENTO_IMAGEM: TIntegerField;
    CDSPIsVALOR_NUMERICO: TIntegerField;
    CDSPIsFLAG_VALOR_EM_SEGUNDOS: TBooleanField;
    qryQtdePIsSemFormatoHorario: TFDQuery;
    qryPIsPermitidos: TFDQuery;
    cdsPessoasFilaEsperaPA: TClientDataSet;
    cdsPessoasFilaEsperaPASenha: TIntegerField;
    cdsPessoasFilaEsperaPANome: TStringField;
    cdsPessoasFilaEsperaPAHorario: TTimeField;
    dsPessoasNasFilas: TDataSource;
    cdsPessoasFilaEsperaPAFila: TStringField;
    CDSPIsID: TIntegerField;
    CDSPIsUNIDADE: TStringField;
    CDSPIsCREATEDAT: TFloatField;
    cdsPessoasFilaEsperaPAProntuario: TStringField;
    CDSSenhasPRONTUARIO: TIntegerField;
    CDSSenhasTEMPO_ESPERA: TStringField;
    cdsPessoasFilaEsperaPAccIdObservacao: TIntegerField;
    cdsPessoasFilaEsperaPAObservacao: TStringField;
    procedure DataModuleDestroy(Sender: TObject);
    procedure cdsAtendentesReconcileError(DataSet: TCustomClientDataSet; E: EReconcileError; UpdateKind: TUpdateKind; var Action: TReconcileAction);
    procedure cdsUnidadesAfterOpen(DataSet: TDataSet);
    procedure CriarIndicesParaCadaColunaDoDataset(DataSet: TDataSet);
    procedure cdsPessoasFilaEsperaPAAfterPost(DataSet: TDataSet);
    procedure cdsPessoasFilaEsperaPACalcFields(DataSet: TDataSet);
  private
    FIDUnidade: Integer;
    {$IFDEF SuportaCodigoBarras}
    ReceivingCodeBar     : boolean;
    ValueCodeBarReceiving: string;
    procedure CodeBarPortRxChar(Sender: TObject; Count: Integer);
    {$ENDIF SuportaCodigoBarras}
    {$IFDEF CompilarPara_MULTIPA}
    procedure tmrClearAtdTimer(Sender: TObject);
    {$ENDIF CompilarPara_MULTIPA}

    procedure SetIdUnidade(const Value: Integer);
    function GetIdUnidade: Integer;

    class function GetInstancia(const aIDUnidade: integer; const aAllowNewInstance: Boolean; const aOwner: TComponent = nil): TDMClient;
  public
    {$IFDEF CompilarPara_MULTIPA}
    tmrClearAtd: TTimer;
    {$ENDIF CompilarPara_MULTIPA}
    {$IFDEF SuportaCodigoBarras}
    CodeBarPort: TVaComm;
    {$ENDIF SuportaCodigoBarras}
    MaxTAGs: Integer;
    // ****************************************************************************************************
    // Analisar melhor sobre essas 2 variáveis durante o desenvolvimento no MultiPA
    // pois não serão necessárias.
    // ****************************************************************************************************
    FCurrentPA      : integer; // No módulo PA, é o Id da PA definido nas configurações do módulo. No módulo MPA, é a PA selecionada por 7 segundos
    FCurrentAtd     : integer; // No módulo PA, é o Id do atendente logado na PA definida nas configurações do módulo. No módulo MPA, é o Id selecionado por 7 segundos
    FCurrentFila    : integer;
    ConfiguradoGrupoMotivoPausa: Boolean;
    ConfiguradoGrupoPP         : Boolean;
    ConfiguradoGrupoTAG        : Boolean;
    ConfiguradoMotivoPausa     : Boolean;
    ConfiguradoPA              : Boolean;
    ConfiguradoPP              : Boolean;
    ConfiguradoStatusPA        : Boolean;
    ConfiguradoTAG             : Boolean;
    FCarregouParametroDB, FCarregouParametroINI: Boolean;


    property IdUnidade: Integer read GetIdUnidade write SetIdUnidade;
    procedure CarregarParametrosINI; Virtual;
    procedure ClearCurrentAtd;
    procedure ConnectarDB;
    procedure CarregaTabelasPAsEFilas;
    function ExistePA      (IdPA : integer) : boolean;
    function ExisteGrupoPA (IdGrupo : integer) : boolean;

    procedure InsertPA(PA: Integer; Nome: string; Grupo: Integer);
    procedure InsertAtd(Atd: Integer; Nome, RegFuncional, SenhaLogin, aLogin: string; Grupo: Integer);
    procedure InsertFila(Fila: Integer; Nome: string; Cor : integer);
    procedure InsertTAG(IdTAG: Integer; Nome: string; Grupo, Cor: Integer);
    procedure InsertPP(IdPP: Integer; Nome: string; Grupo, Cor: Integer);
    procedure InsertMotivoPausa(Motivo: Integer; Nome: string; Grupo, Cor: Integer);
    procedure InsertGrupoAtd(Grupo: Integer; Nome: string);
    procedure InsertGrupoPA(Grupo: Integer; Nome: string);
    procedure InsertGrupoTAG(Grupo: Integer; Nome: string);
    procedure InsertGrupoPP(Grupo: Integer; Nome: string);
    procedure InsertGrupoMotivoPausa(Grupo: Integer; Nome: string);
    procedure InsertStatusPA(ID: Integer; Nome: string);
    procedure InsertPessoasFilaEsperaPA(AFila: String; ASenha : Integer; ANome: String; AProntuario: string; AHorario: TTime; AObservacao: string);

    function GetAtdData(IdAtd: Integer; var IdGrupoAtend: Integer; var AtdNome, AtdRegFuncional, AtdSenha, AtdLogin: string): boolean;
    function CheckAtdPswd(IdAtd: Integer; pswd: string): boolean;
    function GetPANome(IdPA: Integer): string;
    function GetPINome(IdPI: Integer): string;
    function GetAtdNome(IdAtd: Integer): string;
    function GetFilaNome(IdFila: Integer): string;
    function GetIdPA(Nome: string): Integer;
    function GetIdAtd(Nome: string): Integer;
    function GetIdAtdFromRegistroFuncional(RegFuncional: string): Integer;
    function GetMotivoPausaNome(IdMotivo: Integer): string;
    function GetMotivoPausaCor(IdMotivo: Integer): TAlphaColor;
    {$IFDEF CompilarPara_MULTIPA}
    procedure ClearAtdCasoNecessario(const PA: Integer);
    {$ENDIF CompilarPara_MULTIPA}
    function UpdateNomeCliente(const aFila, aSenha: Integer; const aNovoNome: String): boolean;

    procedure SetNewSqlConnectionForSQLDataSet(AOwner: TComponent);
    procedure LimparNNPASFilasInativas;

    procedure CarregarParametrosViaDB;
    constructor Create(AOwner: TComponent); overload; override;
    procedure AfterConstruction; override;

    procedure LimparAgendamentos    (PA : integer);
    procedure InsertAgendamentoFila (PA, Senha, Fila : integer; DataHora : TDateTime);
    function  ExisteAgendamento     (PA, Senha, Fila : integer; var DataHora : TDateTime) : boolean;

    function IsAllowedPI(const PI: integer): boolean;
    procedure AssociaNomePI(const IdPI: integer; const NomePI: string);
    function AtualizaStatusPI(const TotalPIs, IndexPI, IdPI: integer;
      const EstadoPI: char; const ValorPI: string;
      const ValorNumericoPI: Integer;
      const IsValorEmSegundos: Boolean): boolean;
    procedure SolicitarAtualizacaoPIs(const aIdUnidade: Integer;
      const aAguardarRetorno: Boolean);

    function PICompostoSomentePorIndicadoresComFormatoHorario(AIdPI: Integer): Boolean;

    function ClientConectarViaDB : boolean;

    function GetIndexName(AField: TField; const ADesc: Boolean): string;
    constructor Create(AOwner: TComponent; const aIdUnidade: Integer); overload;
  end;

const
  NaoIdentificado          = '???';
  COR_DEFAULT_MOTIVO_PAUSA = claRed;

function DMClient(const aIDUnidade: integer; const aAllowNewInstance: Boolean; const aOwner: TComponent = nil): TDMClient;
function NGetNextGenerator(GeneratorName: string; ANewSqlConnection: TFDConnection = nil; const aIdUnidade: Integer = 0): Integer; deprecated 'Use TGenerator.NGetNextGenerator'

implementation

uses
  {$IFDEF CompilarPara_PA_MULTIPA}
  Sics_Common_LCDBInput,
  untCommonFormBasePA,

  {$ENDIF CompilarPara_PA_MULTIPA}
  untCommonDMConnection,
  untLog,
  MyAspFuncoesUteis,
  Sics_Common_Parametros,
  untCommonDMUnidades,
  System.StrUtils,
  ASPGenerator,
  UConexaoBD,
  FMX.Dialogs,
  untCommonFormDadosAdicionais;

{$IFDEF FIREMONKEY}
{ %CLASSGROUP 'FMX.Controls.TControl' }
{$ENDIF FIREMONKEY}
{$R *.dfm}

function DMClient(const aIDUnidade: integer; const aAllowNewInstance: Boolean; const aOwner: TComponent): TDMClient;
begin
  Result := TDMClient(TDMClient.GetInstancia(aIDUnidade, aAllowNewInstance, aOwner));
end;

function NGetNextGenerator(GeneratorName: string; ANewSqlConnection: TFDConnection; const aIdUnidade: Integer): Integer;
//var
//  LSQLQuery: TFDQuery;
begin
  // edu - tive que criar o objeto ao inves de aproveitar o qryGeneratorGenerico
  // pois agora pode passar como parametro outro sqlconnection,
  // e em alguns momentos quando trocava de sqlconnection dava Access Violation
  (* RA
  LSQLQuery := TFDQuery.Create(nil);
  with LSQLQuery do
    try
      if ANewSqlConnection <> nil then
        Connection := ANewSqlConnection
      else
        Connection := DMClient(aIdUnidade, not CRIAR_SE_NAO_EXISTIR).connDMClient;
      SQL.Text     := 'SELECT CAST(GEN_ID (GEN_ID_' + GeneratorName + ', 1) AS INTEGER) AS ID FROM RDB$DATABASE';
      Open;
      try
        Result := FieldByName('ID').AsInteger;
      finally
        Close;
      end;
    finally
      FreeAndNil(LSQLQuery);
    end;
  *)

  if ANewSqlConnection = nil then
  begin
    ANewSqlConnection := DMClient(aIdUnidade, not CRIAR_SE_NAO_EXISTIR).connDMClient;
  end;

  Result := TGenerator.NGetNextGenerator(GeneratorName, ANewSqlConnection);
end;

procedure TDMClient.SolicitarAtualizacaoPIs(const aIdUnidade: Integer; const aAguardarRetorno: Boolean);
begin
  DMConnection(aIdUnidade, not CRIAR_SE_NAO_EXISTIR).EnviarComando(cProtocoloPAVazia + Chr($66),
                   aIdUnidade,
                   'Solicitando atualização dos PIs',
                   aAguardarRetorno);
end;

function TDMClient.IsAllowedPI(const PI: integer): boolean;
begin
  {$IFDEF CompilarPara_TGS_ONLINE}
  Result := ( ExisteNoIntArray(PI, vgParametrosModulo.IndicadoresPermitidos) or
              ExisteNoIntArray(0,  vgParametrosModulo.IndicadoresPermitidos)
            );
  {$ENDIF}
end;

procedure TDMClient.AssociaNomePI(const IdPI: integer; const NomePI: string);
begin
  if CDSPIs.Active and CDSPIs.Locate(CDSPIsIDPI.FieldName,
                                     VarArrayOf([idPI]),
                                     [TLocateOption.loCaseInsensitive]) then
  begin
    CDSPIs.Edit;
    CDSPIs.FieldByName('PI').AsString := NomePI;
    CDSPIs.Post;
  end;
end;

function TDMClient.AtualizaStatusPI(const TotalPIs, IndexPI, IdPI: integer; const EstadoPI: char; const ValorPI: string;
  const ValorNumericoPI: Integer; const IsValorEmSegundos: Boolean): boolean;
begin
  if not CDSPIs.Active then
    CDSPIs.CreateDataSet;

  if IndexPI > (CDSPIs.RecordCount + 1) then
  begin
    // algo deu errado...
    Result := false;
    Exit;
  end;

  Result := CDSPIs.FindKey([idPI]);
  if Result then
    CDSPIs.Edit
  else
  begin
    CDSPIs.Insert;
    CDSPIs.FieldByName('PI').AsString := '???';
    CDSPIs.FieldByName('IDPI').AsInteger := idPI;
  end;

  CDSPIs.FieldByName('VALOR').AsString := ValorPI;

  case EstadoPI of
    'N' : CDSPIs.FieldByName('ESTADO').AsString := 'Normal';
    'A' : CDSPIs.FieldByName('ESTADO').AsString := 'Atenção';
    'C' : CDSPIs.FieldByName('ESTADO').AsString := 'Crítico';
  else
    CDSPIs.FieldByName('ESTADO').AsString:= '';
  end;
  CDSPIs.FieldByName('IDESTADO').AsString := EstadoPI;

  CDSPIs.FieldByName('VALOR_NUMERICO').AsInteger := ValorNumericoPI;
  CDSPIs.FieldByName('FLAG_VALOR_EM_SEGUNDOS').AsBoolean := IsValorEmSegundos;

  CDSPIs.Post;
end;

procedure TDMClient.ClearCurrentAtd;
begin
  FCurrentPA       := -1;
  FCurrentAtd      := -1;
  FCurrentFila     := -1;
end;

function TDMClient.ClientConectarViaDB: boolean;
begin
  Result:= (vgParametrosModulo.DBDir <> '') and (IdUnidade = vgParametrosModulo.UnidadePadrao);
end;

procedure TDMClient.ConnectarDB;
begin
  try
    if not connDMClient.Connected then
      connDMClient.Open;
  except
    on E: Exception do
    begin
      MyLogException(E);

      {$IFNDEF CompilarPara_TGS}
      ErrorMessage('Erro ao abrir base de dados!');
      {$ENDIF CompilarPara_TGS}
    end;
  end;

  try
    if not connRelatorio.Connected then
      connRelatorio.Open;
  except
    on E: Exception do
    begin
      MyLogException(E);

      {$IFNDEF CompilarPara_TGS}
      ErrorMessage('Erro ao abrir base de dados de relatórios!');
      {$ENDIF CompilarPara_TGS}
    end;
  end;
end;

constructor TDMClient.Create(AOwner: TComponent; const aIdUnidade: Integer);
begin
  Create(AOwner);
  IdUnidade := aIdUnidade;
end;

procedure TDMClient.AfterConstruction;
begin
  inherited;
  if (not FCarregouParametroINI) and (not vgParametrosModulo.JaEstaConfigurado) then
    CarregarParametrosINI;
end;

procedure TDMClient.CarregarParametrosViaDB;
  function GetListaIDPermitidosDoGrupo(AConexao: TFDConnection; const aNomeTabela, aNomeCampo: String; const AIdModulo: Integer): TIntArray;
  var
    aQuery: TFDQuery;
  begin
    SetLength(Result, 0);
    aQuery := TFDQuery.Create(nil);
    try
      aQuery.Connection := AConexao;
      aQuery.SQL.Text := Format('SELECT %s FROM %s WHERE ID_UNIDADE = :ID_UNIDADE AND ID = %d', [aNomeCampo, aNomeTabela, AIdModulo]);
      aQuery.Open;
      StrToIntArray(aQuery.Fields[0].AsString, Result);
    finally
      FreeAndNil(aQuery);
    end;
  end;

  function GetFilterPorRangerID(const aRangeIDs: TIntArray): string;
    var
      i: Integer;
   begin
     if length(aRangeIDs) = 0 then
     begin
       Result := '';
     end
     else
     begin
       Result := EmptyStr;

       for i := 0 to High(aRangeIDs) do
       begin
         if Result <> '' then
           Result := Result + ' , ';
         Result   := Result + IntToStr(aRangeIDs[i]);//'(' + aColuna + ' = ' + IntToStr(aRangeIDs[i]) + ')';
       end;
     end;
   end;

var
  RangeAtendentes, RangePAs, vNomeTabela: string;
  LAbriuDB: BOolean;
  LGruposAtendentes, LPAs : TIntArray;
begin
  try
    vNomeTabela := '';
    connDMClient.Params.Clear;
    connDMClient.ConnectionDefName  := TConexaoBD.NomeBasePadrao(Self.IdUnidade);
//    connDMClient.DriverName := 'FB';
//    connDMClient.Params.Values['database'] := vgParametrosModulo.DBDir;

    LAbriuDB := not connDMClient.Connected;

    if LAbriuDB then
      connDMClient.Open;

    try
      {$IFDEF CompilarPara_PA}
      vNomeTabela := 'MODULOS_PAS';
      {$ENDIF}
      {$IFDEF CompilarPara_MULTIPA}
      vNomeTabela := 'MODULOS_MULTIPAS';
      {$ENDIF}
      if(vNomeTabela = '')then
        exit;

      LGruposAtendentes := GetListaIDPermitidosDoGrupo(connDMClient,vNomeTabela,'GRUPOS_ATENDENTES_PERMITIDOS',vgParametrosModulo.IdModulo);
      RangeAtendentes := GetFilterPorRangerID(LGruposAtendentes);

      cdsAtendentes.Close;
      with qryAtendentes do
      begin
        SQL.Clear;
        SQL.Add('SELECT');
        SQL.Add(' ID');
        SQL.Add(',Nome, Login');
        SQL.Add(',RegistroFuncional');
        SQL.Add(',SenhaLogin');
        SQL.Add(',ID_GrupoAtendente IdGrupo');
        SQL.Add('FROM ATENDENTES');
        SQL.Add('WHERE ID_UNIDADE = :ID_UNIDADE');

        if Trim(RangeAtendentes) <> '' then
          SQL.Add('AND ID_GRUPOATENDENTE IN (' + RangeAtendentes + ')');
      end;

      cdsAtendentes.Open;
      DMConnection(IdUnidade, not CRIAR_SE_NAO_EXISTIR)
        .ConfiguraClienteAposCarregarAtend(IdUnidade);

      {$IFDEF CompilarPara_PA}
      vNomeTabela := '(SELECT ID,(CASE WHEN MODO_TERMINAL_SERVER = '+QuotedStr('T')+' THEN PAS_PERMITIDAS ELSE ID_PA END) PAS_PERMITIDAS FROM MODULOS_PAS WHERE ID_UNIDADE = :ID_UNIDADE)';
      {$ENDIF}

      {$IFDEF CompilarPara_MULTIPA}
      vNomeTabela := 'MODULOS_MULTIPAS';
      {$ENDIF}
      LPAs := GetListaIDPermitidosDoGrupo(connDMClient,vNomeTabela,'PAS_PERMITIDAS',vgParametrosModulo.IdModulo);
      RangePAs := GetFilterPorRangerID(LPAs);
      cdsPAs.Close;
      with qryPAs do
      begin
        SQL.Clear;
        SQL.Add('SELECT');
        SQL.Add(' ID');
        SQL.Add(',Nome');
        SQL.Add(',ID_GrupoPA IdGrupo');
        SQL.Add('FROM PAS');
        SQL.Add('WHERE ID_UNIDADE = :ID_UNIDADE');
        if(RangePAs <> '')then
          SQL.Add('AND ID IN (' + RangePAs + ')');
        SQL.Add('ORDER BY POSICAO');
      end;
      cdsPAs.Open;
      DMConnection(IdUnidade, not CRIAR_SE_NAO_EXISTIR)
        .ConfiguraClienteAposCarregarPA(IdUnidade);
    finally
      if LAbriuDB then
        connDMClient.Close;
    end;
  except
    on E: Exception do
    begin
      ErrorMessage('Erro ao carregar lista de atendentes e PAs!' + #13 + 'Erro: ' + E.Message);
      FinalizeApplication;
    end;
  end;
end;

procedure TDMClient.CarregarParametrosINI;
begin
  FCarregouParametroINI := True;
  {$IFDEF SuportaCodigoBarras}
  CodeBarPort.DeviceName := vgParametrosModulo.CodeBarPort;
  {$ENDIF SuportaCodigoBarras}
  connDMClient.Params.Clear;
  connDMClient.ConnectionDefName  := TConexaoBD.NomeBasePadrao(Self.IdUnidade);
  connRelatorio.Params.Clear;
  connRelatorio.ConnectionDefName := TConexaoBD.NomeBasePadrao(Self.IdUnidade);
end;

procedure TDMClient.CarregaTabelasPAsEFilas;
begin
  tblGenerica.TableName := 'FILAS';
  AbrirCDS(cdsFilas);

  tblGenerica.TableName := 'PAS';
  AbrirCDS(cdsPAs);

  tblGenerica.TableName := 'NN_PAS_FILAS';
  AbrirCDS(cdsNN_PAs_Filas);
end;

procedure TDMClient.cdsAtendentesReconcileError(DataSet: TCustomClientDataSet; E: EReconcileError; UpdateKind: TUpdateKind;
  var Action: TReconcileAction);
begin
  MyLogException(E);
end;

procedure TDMClient.cdsPessoasFilaEsperaPAAfterPost(DataSet: TDataSet);
begin
  if cdsPessoasFilaEsperaPA.State in [dsEdit] then
    ShowMessage(cdsPessoasFilaEsperaPANome.AsString);
end;

procedure TDMClient.cdsPessoasFilaEsperaPACalcFields(DataSet: TDataSet);
begin
  cdsPessoasFilaEsperaPAccIdObservacao.AsInteger := IfThen(cdsPessoasFilaEsperaPAObservacao.AsString<>'', 1, -1);
  //Randomize; Randomize; Randomize;
  //cdsPessoasFilaEsperaPAccIdObservacao.AsInteger := RandomRange( 0, 2);
end;

function TDMClient.GetIndexName(AField: TField; const ADesc: Boolean): string;
begin
  result := 'Idx' + AField.FieldName + IfThen(ADesc, 'Desc', 'Asc');
end;

procedure TDMClient.CriarIndicesParaCadaColunaDoDataset(DataSet: TDataSet);
var
  LCds: TClientDataset;
  LIdx: TIndexDef;
  i: Integer;
begin
  LCds := TClientDataset(DataSet);
  LCds.IndexDefs.Clear;
  for i := 0 to LCds.FieldCount-1 do
  begin
    LIdx := LCds.IndexDefs.AddIndexDef;
    LIdx.Name := GetIndexName(LCds.Fields[i], False);
    LIdx.Options := LIdx.Options + [ixCaseInsensitive];
    LIdx.Fields := LCds.Fields[i].FieldName;

    LIdx := LCds.IndexDefs.AddIndexDef;
    LIdx.Name := GetIndexName(LCds.Fields[i], True);
    LIdx.Options := LIdx.Options + [ixCaseInsensitive, ixDescending];
    LIdx.Fields := LCds.Fields[i].FieldName;
  end;
end;

procedure TDMClient.cdsUnidadesAfterOpen(DataSet: TDataSet);
begin
  cdsUnidadesClone.CloneCursor(cdsUnidades, true);
end;

function TDMClient.CheckAtdPswd(IdAtd: Integer; pswd: string): boolean;
begin
  with cdsAtendentes do
    Result := (Locate('ID', IdAtd, [])) and (FieldByName('SenhaLogin').AsString = pswd);
end;

{ ============================================================================= }
{ procedures do leitor de código de barras }

{$IFDEF SuportaCodigoBarras}

procedure TDMClient.CodeBarPortRxChar(Sender: TObject; Count: Integer);
var
  x: AnsiChar;
  I: Integer;

  procedure DecifrarCodigoBarra;
  begin
    if not ReceivingCodeBar then
      Exit;
    if (Trim(ValueCodeBarReceiving) <> '') then
    begin
      ValueCodeBarReceiving := '/' + ValueCodeBarReceiving + '\';
      DMConnection(IdUnidade, not CRIAR_SE_NAO_EXISTIR).DecifrarCodigoBarra(ValueCodeBarReceiving, IdUnidade);
    end;

    ValueCodeBarReceiving := '';
    ReceivingCodeBar      := False;
  end;

begin
  for I := 1 to Count do
  begin
    CodeBarPort.ReadChar(x);
    {$IFDEF CompilarPara_PA_MULTIPA}
    if not Assigned(frmSicsCommon_LCDBInput) then
      frmSicsCommon_LCDBInput := TfrmSicsCommon_LCDBInput.Create(self,IdUnidade);

    if frmSicsCommon_LCDBInput.Visible then
      frmSicsCommon_LCDBInput.memoLCDBInput.Text := frmSicsCommon_LCDBInput.memoLCDBInput.Text + AspAnsiCharToString(x);
    {$ENDIF CompilarPara_PA_MULTIPA}
    if ((x = '/') or (x = '%')) then
    begin
      ValueCodeBarReceiving := '';
      ReceivingCodeBar      := true;
    end
    else if ((x = '\') or (x = '$')) then
    begin
      DecifrarCodigoBarra;
    end
    else if ReceivingCodeBar then
      ValueCodeBarReceiving := ValueCodeBarReceiving + AspAnsiCharToString(x);
  end;
end;

{$ENDIF SuportaCodigoBarras}

procedure TDMClient.DataModuleDestroy(Sender: TObject);
begin
  {$IFDEF SuportaCodigoBarras}
  if CodeBarPort.active then
    CodeBarPort.Close;
  {$ENDIF SuportaCodigoBarras}
  inherited;
end;

function TDMClient.GetAtdData(IdAtd: Integer; var IdGrupoAtend: Integer; var AtdNome, AtdRegFuncional, AtdSenha, AtdLogin: string): boolean;
begin
  Result          := False;
  IdGrupoAtend    := -1;
  AtdNome         := '';
  AtdRegFuncional := '';
  AtdSenha        := '';
  AtdLogin        := '';

  with cdsAtendentes do
  begin
    if Locate('ID', IdAtd, []) then
    begin
      IdGrupoAtend    := FieldByName('IdGrupo').AsInteger;
      AtdNome         := FieldByName('Nome').AsString;
      AtdRegFuncional := FieldByName('RegistroFuncional').AsString;
      AtdSenha        := FieldByName('SenhaLogin').AsString;
      AtdLogin        := FieldByName('Login').AsString;
      Result          := true;
    end;
  end;
end;

function TDMClient.GetAtdNome(IdAtd: Integer): string;
begin
  Result := NaoIdentificado;

  with cdsAtendentes do
    if Locate('ID', IdAtd, []) then
      Result := FieldByName('Nome').AsString;
end;

function TDMClient.GetFilaNome(IdFila: Integer): string;
begin
  Result := NaoIdentificado;

  with cdsFilas do
    if Locate('ID', IdFila, []) then
      Result := FieldByName('Nome').AsString;
end;

function TDMClient.GetIdAtd(Nome: string): Integer;
begin
  Result := -1;

  with cdsAtendentes do
    if Locate('Nome', Nome, []) then
      Result := FieldByName('ID').AsInteger;
end;

function TDMClient.GetIdAtdFromRegistroFuncional(RegFuncional: string): Integer;
begin
  Result := -1;

  with cdsAtendentes do
    if Locate('RegistroFuncional', RegFuncional, []) then
      Result := FieldByName('ID').AsInteger;
end;

function TDMClient.GetIdPA(Nome: string): Integer;
begin
  Result := -1;

  with cdsPAs do
    if Locate('Nome', Nome, []) then
      Result := FieldByName('ID').AsInteger;
end;

function TDMClient.GetIdUnidade: Integer;
begin
   Result := FIDUnidade;
end;

class function TDMClient.GetInstancia(const aIDUnidade: integer; const aAllowNewInstance: Boolean; const aOwner: TComponent): TDMClient;
var
  LOwner: TComponent;
begin
  Result := TDMClient(GetApplication.FindComponent(ClassName + inttostr(aIDUnidade)));
  if ((not Assigned(Result)) and (aIDUnidade >= 0) and aAllowNewInstance ) then
  begin
    LOwner := aOwner;
    if not Assigned(LOwner) then
      LOwner := GetApplication;
    Result := Self.Create(LOwner, aIDUnidade);
    Result.Name := ClassName + inttostr(aIdUnidade);
  end;
end;

function TDMClient.GetMotivoPausaCor(IdMotivo: Integer): TAlphaColor;
begin
  Result := COR_DEFAULT_MOTIVO_PAUSA;

  if (IdMotivo <> -1) and cdsMotivosPausa.Locate('ID', IdMotivo, []) then
    Result := TAlphaColor(RGBtoBGR(cdsMotivosPausaCodigoCor.AsInteger) or $FF000000);
end;

function TDMClient.GetMotivoPausaNome(IdMotivo: Integer): string;
begin
  Result := NaoIdentificado;

  with cdsMotivosPausa do
    if Locate('ID', IdMotivo, []) then
      Result := FieldByName('Nome').AsString;
end;

function TDMClient.GetPANome(IdPA: Integer): string;
begin
  Result := NaoIdentificado;

  with cdsPAs do
    if Active and Locate('ID', IdPA, []) then
      Result := FieldByName('Nome').AsString;
end;

function TDMClient.GetPINome(IdPI: Integer): string;
begin
  Result := NaoIdentificado;

  with cdsPIs do
    if Active and Locate('ID_PI', IdPI, []) then
      Result := FieldByName('Nome').AsString;
end;

procedure TDMClient.InsertAtd(Atd: Integer; Nome, RegFuncional, SenhaLogin, aLogin: string; Grupo: Integer);
begin
  with cdsAtendentes do
  begin
    if Locate('ID', Atd, []) then
      Edit
    else
    begin
      Append;
      FieldByName('ID').AsInteger := Atd;
    end;

    FieldByName('Nome').AsString              := Nome;
    FieldByName('RegistroFuncional').AsString := RegFuncional;
    FieldByName('SenhaLogin').AsString        := SenhaLogin;
    cdsAtendenteslogin.AsString               := aLogin;

    if Grupo = -1 then
      FieldByName('IdGrupo').Clear
    else
      FieldByName('IdGrupo').AsInteger := Grupo;

    Post;
  end;
end;

procedure TDMClient.InsertPessoasFilaEsperaPA(AFila: String; ASenha: Integer; ANome: String; AProntuario: string; AHorario: TTime; AObservacao: string);
begin
  cdsPessoasFilaEsperaPA.Append;
  cdsPessoasFilaEsperaPA.FieldByName('Fila').AsString       := AFila;
  cdsPessoasFilaEsperaPA.FieldByName('Senha').AsInteger     := ASenha;
  cdsPessoasFilaEsperaPA.FieldByName('Nome').AsString       := ANome;
  cdsPessoasFilaEsperaPA.FieldByName('Horario').AsDateTime  := AHorario;
  {$IFDEF CompilarPara_PA_MULTIPA}
  if (Trim(ANome)<>'') and (AProntuario<>'0') then
    cdsPessoasFilaEsperaPA.FieldByName('Prontuario').AsString := AProntuario;

  cdsPessoasFilaEsperaPA.FieldByName('Observacao').AsString := AObservacao;
  {$ENDIF CompilarPara_PA_MULTIPA}
  cdsPessoasFilaEsperaPA.Post;
end;

procedure TDMClient.InsertFila(Fila: Integer; Nome: string; Cor : integer);
begin
  with cdsFilas do
  begin
    if Locate('ID', Fila, []) then
      Edit
    else
    begin
      Append;
      FieldByName('ID').AsInteger := Fila;
    end;

    FieldByName('Nome').AsString := Nome;
    FieldByName('Cor' ).AsInteger := Cor;

    Post;
  end;
end;

procedure TDMClient.InsertGrupoAtd(Grupo: Integer; Nome: string);
begin
  with cdsGruposDeAtendentes do
  begin
    if Locate('ID', Grupo, []) then
      Edit
    else
    begin
      Append;
      FieldByName('ID').AsInteger := Grupo;
    end;

    FieldByName('Nome').AsString := Nome;
    Post;
  end;
end;

procedure TDMClient.InsertGrupoMotivoPausa(Grupo: Integer; Nome: string);
begin
  begin
    with cdsGruposDeMotivosPausa do
    begin
      if Locate('ID', Grupo, []) then
        Edit
      else
      begin
        Append;
        FieldByName('ID').AsInteger := Grupo;
      end;

      FieldByName('Nome').AsString := Nome;
      Post;
    end;
  end;
end;

procedure TDMClient.InsertGrupoPA(Grupo: Integer; Nome: string);
begin
  with cdsGruposDePAs do
  begin
    if Locate('ID', Grupo, []) then
      Edit
    else
    begin
      Append;
      FieldByName('ID').AsInteger := Grupo;
    end;

    FieldByName('Nome').AsString := Nome;
    Post;
  end;
end;

procedure TDMClient.InsertGrupoPP(Grupo: Integer; Nome: string);
begin
  with cdsGruposDePPs do
  begin
    if Locate('ID', Grupo, []) then
      Edit
    else
    begin
      Append;
      FieldByName('ID').AsInteger := Grupo;
    end;

    FieldByName('Nome').AsString := Nome;
    Post;
  end;
end;

procedure TDMClient.InsertGrupoTAG(Grupo: Integer; Nome: string);
begin
  with cdsGruposDeTAGs do
  begin
    if Locate('ID', Grupo, []) then
      Edit
    else
    begin
      Append;
      FieldByName('ID').AsInteger := Grupo;
    end;

    FieldByName('Nome').AsString := Nome;
    Post;

    MaxTAGs := RecordCount;
  end;
end;

procedure TDMClient.InsertMotivoPausa(Motivo: Integer; Nome: string; Grupo, Cor: Integer);
begin
  with cdsMotivosPausa do
  begin
    if Locate('ID', Motivo, []) then
      Edit
    else
    begin
      Append;
      FieldByName('ID').AsInteger := Motivo;
    end;

    FieldByName('Nome').AsString       := Nome;
    FieldByName('CodigoCor').AsInteger := Cor;
    if Grupo = -1 then
      FieldByName('IdGrupo').Clear
    else
      FieldByName('IdGrupo').AsInteger := Grupo;

    Post;
  end;
end;

procedure TDMClient.InsertPA(PA: Integer; Nome: string; Grupo: Integer);
begin
  with cdsPAs do
  begin
    if Locate('ID', PA, []) then
      Edit
    else
    begin
      Append;
      FieldByName('ID').AsInteger := PA;
    end;

    FieldByName('Nome').AsString := Nome;

    if Grupo = -1 then
      FieldByName('IdGrupo').Clear
    else
      FieldByName('IdGrupo').AsInteger := Grupo;

    Post;
  end;
end;

procedure TDMClient.InsertPP(IdPP: Integer; Nome: string; Grupo, Cor: Integer);
begin
  with cdsPPs do
  begin
    if Locate('ID', IdPP, []) then
      Edit
    else
    begin
      Append;
      FieldByName('ID').AsInteger := IdPP;
    end;

    FieldByName('Nome').AsString       := Nome;
    FieldByName('CodigoCor').AsInteger := Cor;
    if Grupo = -1 then
      FieldByName('IdGrupo').Clear
    else
      FieldByName('IdGrupo').AsInteger := Grupo;

    Post;
  end;
end;

procedure TDMClient.InsertStatusPA(ID: Integer; Nome: string);
begin
  with cdsStatusPAs do
  begin
    if Locate('ID', ID, []) then
      Edit
    else
    begin
      Append;
      FieldByName('ID').AsInteger := ID;
    end;

    FieldByName('Nome').AsString := Nome;
    Post;
  end;
end;

procedure TDMClient.InsertTAG(IdTAG: Integer; Nome: string; Grupo, Cor: Integer);
begin
  with cdsTags do
  begin
    if Locate('ID', IdTAG, []) then
      Edit
    else
    begin
      Append;
      FieldByName('ID').AsInteger := IdTAG;
    end;

    FieldByName('Nome').AsString       := Nome;
    FieldByName('CodigoCor').AsInteger := Cor;
    if Grupo = -1 then
      FieldByName('IdGrupo').Clear
    else
      FieldByName('IdGrupo').AsInteger := Grupo;

    Post;
  end;
end;

function TDMClient.ExistePA (IdPA : integer) : boolean;
begin
  Result := cdsPAs.Locate('ID', IdPA, []);
end;

procedure TDMClient.LimparAgendamentos(PA: integer);
begin
  with cdsAgendamentosSenhasPorFila do
  begin
    Filter   := 'IdPA=' + inttostr(PA);
    Filtered := True;
    try
      while not IsEmpty do
        Delete;
    finally
      Filtered := false;
    end;
  end;
end;

procedure TDMClient.InsertAgendamentoFila(PA, Senha, Fila: integer; DataHora: TDateTime);
begin
  with cdsAgendamentosSenhasPorFila do
  begin
    Append;
    FieldByName('IdPa'    ).AsInteger  := PA;
    FieldByName('Senha'   ).AsInteger  := Senha;
    FieldByName('IdFila'  ).AsInteger  := Fila;
    FieldByName('DataHora').AsDateTime := DataHora;
    Post;
  end;
end;

function TDMClient.ExisteAgendamento(PA, Senha, Fila: integer; var DataHora: TDateTime): boolean;
begin
  Result := false;

  if cdsAgendamentosSenhasPorFila.Locate('IdPA;Senha;IdFila', VarArrayOf([PA, Senha, Fila]), []) then
  begin
    DataHora := cdsAgendamentosSenhasPorFila.FieldByName('DataHora').AsDateTime;
    Result := true;
  end;
end;

function TDMClient.ExisteGrupoPA(IdGrupo: integer): boolean;
begin
  Result := cdsGruposDePAs.Locate('ID', IdGrupo, []);
end;

procedure TDMClient.LimparNNPASFilasInativas;
var
  LUnidade: Integer;
begin
  LUnidade := IfThen(dmUnidades.ConfiguradoParaMultiUnidades, dmUnidades.UnidadeAtiva, 1);
  connDMClient.ExecSQL('delete from nn_pas_filas where ID_UNIDADE = :ID_UNIDADE AND id_pa in (select id from pas where ID_UNIDADE = :ID_UNIDADE AND ativo = ''F'')', [LUnidade]);
  connDMClient.ExecSQL('delete from nn_pas_filas where ID_UNIDADE = :ID_UNIDADE AND id_fila in (select id from filas where ID_UNIDADE = :ID_UNIDADE AND ativo = ''F'')', [LUnidade]);
end;

procedure TDMClient.SetIdUnidade(const Value: Integer);
begin
  if (IDUnidade <> Value) then
    FIDUnidade := Value;

  if (not FCarregouParametroINI) and (not vgParametrosModulo.JaEstaConfigurado) then
    CarregarParametrosINI;
end;

procedure TDMClient.SetNewSqlConnectionForSQLDataSet(AOwner: TComponent);
var
  I: Integer;
  LListaConexoesFechadas: TList<string>;
  LSQLDataset: TFDCustomQuery;
begin
  if not Assigned(AOwner) then
    Exit;

  LListaConexoesFechadas := TList<String>.Create;
  try
    for I := 0 to AOwner.ComponentCount - 1 do
    begin
      if AOwner.Components[I] is TFDCustomQuery then
      begin
        LSQLDataset := TFDCustomQuery(AOwner.Components[I]);

        if Assigned(LSQLDataset.Connection) then
        begin
          if not LListaConexoesFechadas.Contains(LSQLDataset.Connection.Name) then
          begin
            //necessário para que o DBX entenda que o SQLConnection foi alterado
            //em runtime, isto é, SQLDataset.SQLConnection agora aponta para uma
            //nova conexão. Se não forçar o "CloseDatasets" antes de trocar o
            //valor desta propriedade, a conexão anterior é mantida!
            LSQLDataset.Connection.ReleaseClients(rmClose);
            LListaConexoesFechadas.Add(LSQLDataset.Connection.Name);
          end;
        end;

        LSQLDataset.Connection := connDMClient;
      end;
    end;
  finally
    LListaConexoesFechadas.Free;
  end;
end;

function TDMClient.UpdateNomeCliente(const aFila, aSenha: Integer; const aNovoNome: String): boolean;
var
  LBM: TBookmark;
begin
  LBM := CDSSenhas.GetBookmark;
  try
    Result := CDSSenhas.active and CDSSenhas.Locate(CDSSenhasIDFILA.FieldName + ';' + CDSSenhasSENHA.FieldName, VarArrayOf([aFila, aSenha]), []);

    if Result then
    begin
      CDSSenhas.Edit;
      CDSSenhasNOMECLIENTE.AsString := aNovoNome;
      CDSSenhas.Post;
    end;
    if CDSSenhas.BookmarkValid(LBM) then
      CDSSenhas.GotoBookmark(LBM);
  finally
    CDSSenhas.FreeBookmark(LBM);
  end;
end;

{$IFDEF CompilarPara_MULTIPA}

procedure TDMClient.tmrClearAtdTimer(Sender: TObject);
var
  I: Integer;
  LComponent: TComponent;
  rec: TRectangle;
begin
  if Assigned(dmUnidades.FormClient) then
  begin
    rec := dmUnidades.FormClient.GetRecCodigoBarras(FCurrentPA);
    if Assigned(rec) then
      rec.Visible := False;
  end;

  ClearCurrentAtd;

  tmrClearAtd.Enabled := False;
end;
{$ENDIF CompilarPara_MULTIPA}
{$IFDEF CompilarPara_MULTIPA}

procedure TDMClient.ClearAtdCasoNecessario(const PA: Integer);
begin
  if (PA = FCurrentPA) and Assigned(tmrClearAtd) and Assigned(tmrClearAtd.OnTimer) then
  begin
    Delay(1500);
    tmrClearAtd.OnTimer(tmrClearAtd);
  end;
end;
{$ENDIF CompilarPara_MULTIPA}

constructor TDMClient.Create(AOwner: TComponent);
begin
  inherited;
  FidUnidade := ID_UNIDADE_VAZIA;
  FCarregouParametroDB := False;
  FCarregouParametroINI := False;
  ConfiguradoGrupoMotivoPausa := False;
  ConfiguradoGrupoPP          := False;
  ConfiguradoGrupoTAG         := False;
  ConfiguradoMotivoPausa      := False;
  ConfiguradoPP               := False;
  ConfiguradoStatusPA         := False;
  ConfiguradoTAG              := False;
  FCurrentPA := -1;
  FCurrentAtd := -1;
  FCurrentFila := -1;

  ClearCurrentAtd;

  qryPAs.Connection                      := connDMClient;
  qryAtendentes.Connection               := connDMClient;
  qryQtdePIsSemFormatoHorario.Connection := connDMClient;

  {$IFDEF CompilarPara_MULTIPA}
  tmrClearAtd          := TTimer.Create(self);
  tmrClearAtd.Enabled  := False;
  tmrClearAtd.Interval := 7000;
  tmrClearAtd.OnTimer  := tmrClearAtdTimer;
  {$ENDIF CompilarPara_MULTIPA}
  {$IFDEF SuportaCodigoBarras}
  ReceivingCodeBar                         := False;
  ValueCodeBarReceiving                    := '';
  CodeBarPort                              := TVaComm.Create(self);
  CodeBarPort.Baudrate                     := br9600;
  CodeBarPort.EventPriority                := tpNormal;
  CodeBarPort.WritePriority                := tpHighest;
  CodeBarPort.FlowControl.OutCtsFlow       := False;
  CodeBarPort.FlowControl.OutDsrFlow       := False;
  CodeBarPort.FlowControl.ControlDtr       := TVaControlDtr.dtrDisabled;
  CodeBarPort.FlowControl.ControlRts       := TVaControlRts.rtsDisabled;
  CodeBarPort.FlowControl.XonXoffOut       := False;
  CodeBarPort.FlowControl.XonXoffIn        := False;
  CodeBarPort.FlowControl.DsrSensitivity   := False;
  CodeBarPort.FlowControl.TxContinueOnXoff := False;
  CodeBarPort.DeviceName                   := 'COM%d';
  CodeBarPort.MonitorEvents                := [ceError, ceRxChar, ceTxEmpty];
  CodeBarPort.OnRxChar                     := CodeBarPortRxChar;
  CodeBarPort.PortNum                      := 1;
  CodeBarPort.Databits                     := db8;
  CodeBarPort.Stopbits                     := TVaStopbits.sb1;
  CodeBarPort.Parity                       := paNone;
  CodeBarPort.Options                      := [coErrorChar, coNullStrip, coParityCheck];
  {$ENDIF SuportaCodigoBarras}
  cdsStatusPAs.CreateDataSet;
  cdsFilas.CreateDataSet;
  cdsGruposDeAtendentes.CreateDataSet;
  cdsGruposDePAs.CreateDataSet;
  cdsGruposDeTAGs.CreateDataSet;
  cdsTags.CreateDataSet;
  cdsGruposDePPs.CreateDataSet;
  cdsPPs.CreateDataSet;
  cdsGruposDeMotivosPausa.CreateDataSet;
  cdsMotivosPausa.CreateDataSet;

  cdsAtendentes.CreateDataSet;
  cdsPAs.CreateDataSet;

  cdsAgendamentosSenhasPorFila.CreateDataSet;
  cdsAgendamentosSenhasPorFila.LogChanges := false;

  cdsPessoasFilaEsperaPA.CreateDataSet;
  cdsPessoasFilaEsperaPA.LogChanges := False;
end;

function TDMClient.PICompostoSomentePorIndicadoresComFormatoHorario(AIdPI: Integer): Boolean;
begin
  if not Assigned(qryQtdePIsSemFormatoHorario.Connection) then
    exit(False);

  try
    qryQtdePIsSemFormatoHorario.Close;
    try
      qryQtdePIsSemFormatoHorario.Params[0].AsInteger := AIdPI;
      qryQtdePIsSemFormatoHorario.Open;
      result := qryQtdePIsSemFormatoHorario.Fields[0].AsInteger = 0;
    finally
      qryQtdePIsSemFormatoHorario.Close;
    end;
  except
    result := False;
  end;
end;

end.



