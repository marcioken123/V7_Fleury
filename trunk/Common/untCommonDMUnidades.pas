unit untCommonDMUnidades;

{$INCLUDE ..\AspDefineDiretivas.inc}

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.FMTBcd, Datasnap.DBClient,
  {$IFNDEF CompilarPara_TGSMOBILE} MyAspFuncoesUteis, {$ENDIF} System.StrUtils, IdStack,

  {$IFDEF CompilarPara_PA_MULTIPA}
  untCommonFormBasePA, UConexaoBD,
  {$ENDIF CompilarPara_PA_MULTIPA}

  {$IFDEF CompilarPara_TGS}
  untMainForm, UConexaoBD,
  {$ENDIF}

  {$IFDEF CompilarPara_TV}
  SicsTV_m,
  {$ENDIF}

  {$IFDEF CompilarPara_ONLINE}
  untSicsOnLine, UConexaoBD,
  {$ENDIF CompilarPara_ONLINE}

  {$IFDEF CompilarPara_CALLCENTER}
  untCommonFormBase, untSicsCallCenter, UConexaoBD,
  {$ENDIF CompilarPara_CALLCENTER}

  {$IFDEF CompilarPara_TOTEMTOUCH}
  untFormTotemTouch, UConexaoBD,
  {$ENDIF}

  {$IFDEF CompilarPara_TotemAA}
  UfrmSicsTotemAA,
  {$ENDIF}

  {$IFDEF CompilarPara_TGSMOBILE}
  ufrmSicsTGSMobile,
  {$ENDIF}

  {$IFNDEF IS_MOBILE}
   FireDAC.Phys.FB,
  {$ENDIF}

  Sics_Common_Parametros,

  {$IF not Defined(CompilarPara_TOTEMTOUCH) and not Defined(CompilarPara_TotemAA) and not Defined(CompilarPara_TGSMOBILE)}
  untFrmConfigParametros,
  {$ENDIF}

  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, 
  FireDAC.Phys, FireDAC.Comp.Client, FireDAC.DBX.Migrate, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.FMXUI.Wait, FireDAC.Phys.FBDef, Datasnap.Provider;

type
  TMetodo                = procedure of object;
  TMetodoUnidade         = procedure(const aIdUnidade: Integer) of object;
  TFuncao                = function: Boolean of object;
  TFuncaoUnidade         = function(const aIdUnidade: Integer): Boolean of object;
  TFuncFormUnidade       = function(const aIdUnidade: integer; const aAllowNewInstance: Boolean = False; const aOwner: TComponent = nil): TObject;
  TOnChangeStatusConexao = procedure(const aIdUnidade: Integer; const aConectada: Boolean) of object;


  {$IFDEF CompilarPara_PA_MULTIPA}TTipoFormClient = TFrmBase_PA_MPA;{$ELSE}
  {$IFDEF CompilarPara_TGS}       TTipoFormClient = TMainForm;{$ELSE}
  {$IFDEF CompilarPara_Online}    TTipoFormClient = TFrmSicsOnLine;{$ELSE}
  {$IFDEF CompilarPara_TV}        TTipoFormClient = TfrmSicsTVPrincipal;{$ELSE}
  {$IFDEF CompilarPara_SICSTV}    TTipoFormClient = TfrmSicsPrincipal;{$ELSE}
  {$IFDEF CompilarPara_CALLCENTER}TTipoFormClient = TfrmSicsCallCenter;{$ELSE}
  {$IFDEF CompilarPara_TOTEMTOUCH}TTipoFormClient = TfrmSicsTotemTouch;{$ELSE}
  {$IFDEF CompilarPara_TGSMOBILE} TTipoFormClient = TfrmSicsTGSMobile;{$ELSE}
                                  TTipoFormClient = TFrmBase;
  {$ENDIF}{$ENDIF}{$ENDIF}{$ENDIF}{$ENDIF}{$ENDIF}{$ENDIF}{$ENDIF}

  TdmUnidades = class(TDataModule)
    conn: TFDConnection;
    qryUnidades: TFDQuery;
    qryUnidadesID: TIntegerField;
    qryUnidadesNOME: TStringField;
    qryUnidadesDBDIR: TStringField;
    qryUnidadesIP: TStringField;
    qryUnidadesPORTA: TIntegerField;
    qryUnidadesPORTA_TGS: TIntegerField;
    cdsUnidades: TClientDataSet;
    cdsUnidadesID: TIntegerField;
    cdsUnidadesNOME: TStringField;
    cdsUnidadesPATH_BASE: TStringField;
    cdsUnidadesIP_ENDERECO: TStringField;
    cdsUnidadesIP_PORTA: TIntegerField;
    cdsUnidadesCONECTADA: TBooleanField;
    cdsUnidadesIDMODULO: TIntegerField;
    qryUnidadesID_UNID_CLI: TStringField;
    qryUnidadesIDGRUPO: TIntegerField;
    qryUnidadesHOST: TStringField;
    qryUnidadesBANCO: TStringField;
    qryUnidadesUSUARIO: TStringField;
    qryUnidadesSENHA: TStringField;
    qryUnidadesOSAUTHENT: TStringField;
    cdsUnidadesID_UNID_CLI: TStringField;
    cdsUnidadesIDGRUPO: TIntegerField;
    cdsUnidadesHOST: TStringField;
    cdsUnidadesBANCO: TStringField;
    cdsUnidadesUSUARIO: TStringField;
    cdsUnidadesSENHA: TStringField;
    cdsUnidadesOSAUTHENT: TStringField;
    FDManager: TFDManager;
    procedure cdsUnidadesAfterOpen(DataSet: TDataSet);
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    FIniciouAtualizacao: Boolean;
    FUnidadeAtiva: Integer;
    FOnChangeStatusConexao: TOnChangeStatusConexao;
    FFormClient: TTipoFormClient;

    procedure CarregarParametrosDoIni;
    procedure CadastrarUnidadePadrao;
    procedure CadastrarUnidadesBD;
    function GetNomeUnidade(aIdUnidade: Integer): String;
    function GetIdModulo(aIdUnidade: Integer): Integer;
    //function GetDBDir(aIdUnidade: Integer): String;
    function GetConectada(aIdUnidade: Integer): Boolean;
    function GetIP(aIdUnidade: Integer): String;
    function GetPorta(aIdUnidade: Integer): Integer;
    procedure SetUnidadeConectada(const aIDUnidade: integer; const aConectada: Boolean);
    procedure SetConectada(aIdUnidade: Integer; const Value: Boolean);
    function GetQuantidade: Integer;
    procedure SetUnidadeAtiva(const Value: Integer);
    procedure CriarFormsAutoCreate;
    procedure SetFormClient(const Value: TTipoFormClient);
    function GetQuantidadeConectadas: Integer;
    function GetAlgumaConectada: Boolean;
    function GetNenhumaConectada: Boolean;
    function GetTodasConectadas: Boolean;

  public
    cdsUnidadesClone: TClientDataSet;

    function ConfiguradoParaMultiUnidades: Boolean;

    function FoiConfiguradoConexao: Boolean;
    procedure ExecutaParaTodasUnidades(const aMetodo: TMetodo); Overload; Virtual;
    procedure ExecutaParaTodasUnidades(const aMetodoUnidade: TMetodoUnidade); Overload; Virtual;
    function  ExecutaParaTodasUnidades(const aFuncao: TFuncao): Boolean; Overload; Virtual;
    procedure InsereUnidade(AId: integer; const ANome, APathBase,
      AEnderecoIP: string; const APortaIP, AIdModulo, AIdGrupoUnidade: integer;
      AIdUnidadeCliente, AHost, ABanco, AUsuario, ASenha, AOSAuthent: String);
    procedure PreencherListaUnidades(aLista: TStrings; const aField: String);
    function IdUnidadeConformePosicaoNaLista(const aPosicao: Integer): Integer;
    function PosicaoNaLista(const aIdUnidade: Integer): Integer; overload;
    function PosicaoNaLista(const aNomeUnidade: String): Integer; overload;
    procedure ExecutaAtualizacaoAPP;
    procedure VerificaParametrosConexao;
    property UnidadeAtiva: Integer read FUnidadeAtiva write SetUnidadeAtiva;
    property Nome[aIdUnidade: Integer]: String read GetNomeUnidade;
    property IDModulo[aIdUnidade: Integer]: Integer read GetIdModulo;
    //property DBDir[aIdUnidade: Integer]: String read GetDBDir;
    property Conectada[aIdUnidade: Integer]: Boolean read GetConectada write SetConectada;
    property IP[aIdUnidade: Integer]: String read GetIP;
    property Porta[aIdUnidade: Integer]: Integer read GetPorta;
    property Quantidade: Integer read GetQuantidade;
    property QuantidadeConectada: Integer read GetQuantidadeConectadas;
    property TodasConectadas: Boolean read GetTodasConectadas;
    property NenhumaConectada: Boolean read GetNenhumaConectada;
    property AlgumaConectada: Boolean read GetAlgumaConectada;
    property OnChangeStatusConexao: TOnChangeStatusConexao read FOnChangeStatusConexao write FOnChangeStatusConexao;
    property FormClient: TTipoFormClient read FFormClient write SetFormClient;
  end;

const
  ID_UNIDADE_PADRAO = 0;
  ID_UNIDADE_VAZIA = -1;

var
  dmUnidades: TdmUnidades;
  vgParametrosSicsClient: TParametrosSicsClients;
  CriticalEnviaComando: TMultiReadExclusiveWriteSynchronizer;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses
  System.IniFiles,
  untCommonDMClient,
  untCommonDMConnection,
  untCommonFormStyleBook

  {$IF ( (not Defined(CompilarPara_CALLCENTER)) and
         (not Defined(CompilarPara_TOTEMTOUCH)) )},
  untCommonFormProcessoParalelo,
  untCommonFormSelecaoPP,
  untCommonFormSelecaoMotivoPausa
  {$ENDIF}

  {$IFDEF CompilarPara_TGS},
  ufrmMonitorUnidades,
  untCommonFormSelecaoGrupoAtendente,
  ufrmLines
  {$ENDIF}

  {$IFDEF CompilarPara_ONLINE},
  untCommonFrameSituacaoEspera,
  APIs.Aspect.Sics.ImprimirEtiqueta,
  APIs.Aspect.Sics.BuscarParametro
  {$ENDIF}

  {$IFDEF CompilarPara_TGS_ONLINE},
  untCommonFrameSituacaoAtendimento,
  untCommonFrameIndicadorPerformance
  {$ENDIF}

  {$IFDEF CompilarPara_PA_MULTIPA},
  untCommonFormLogin,
  untCommonFormSelecaoFila,
  APIs.Aspect.Sics.ImprimirEtiqueta,
  APIs.Aspect.Sics.BuscarParametro
  {$ENDIF}
  ;

{$R *.dfm}

procedure TdmUnidades.SetFormClient(const Value: TTipoFormClient);
begin
  if (FFormClient <> Value) then
  begin
    if Assigned(FFormClient) and Assigned(Value) then
      raise TAspException.create(Self, 'Formulário principal já foi definido');

    FFormClient := TTipoFormClient(GetComponenteFreeNotify(Self, FFormClient, Value));

    if Assigned(FFormClient) then
    begin
      VerificaParametrosConexao;
      //***
      //
      //dmUnidades.ExecutaParaTodasUnidades(ClienteValidaModoConexao);
    end;
  end;
end;

procedure TdmUnidades.cdsUnidadesAfterOpen(DataSet: TDataSet);
begin
  cdsUnidadesClone.CloneCursor(cdsUnidades, true);
end;

procedure TdmUnidades.CarregarParametrosDoIni;
const
  PortaPadrao = {$IFDEF CompilarPara_PA_MULTIPA} 6601 {$ELSE} 6602 {$ENDIF};
var
  LIni: TIniFile;
  LUnidadesPermitidas: string;
  //LHostLido: String;
begin
  LIni := TIniFile.Create(AspLib_GetAppIniFileName);
  try
    vgParametrosModulo.IdModulo                    := LIni.ReadInteger('Settings', 'IdModulo'               , 0          );

    {$IFDEF CompilarPara_PA}
    vgParametrosModulo.MenuEscondido               := LIni.ReadBool('Settings', 'MenuEscondido', false);
    //vgParametrosModulo.ListaTriagemJson            := LIni.ReadString ('Settings', 'ListaTriagemJson' , '{"Triagens": [{"ID": 1,"Fila": 0,"Nome":"Triagem 1","NomeImpressoraEtiqueta":"","QtdeImpressao":0,"ModeloImpressora":""},{"ID": 2,"Fila": 0,"Nome":"Triagem 2","NomeImpressoraEtiqueta":"","QtdeImpressao":0, "ModeloImpressora":""}]}');
    LIni.DeleteKey('Settings', 'ListaTriagemJson');
    //vgParametrosModulo.NomeImpressoraEtiqueta      := LIni.ReadString('Settings', 'NomeImpressoraEtiqueta', '');
    LIni.DeleteKey('Settings', 'NomeImpressoraEtiqueta');
    //vgParametrosModulo.QtdeImpressao               := LIni.ReadInteger('Settings', 'QtdeImpressao', 0);
    LIni.DeleteKey('Settings', 'QtdeImpressao');
    LIni.EraseSection('APIs.Aspect.Sics.DadosAdicionais');
    LIni.EraseSection('APIs.Einstein.ImprimirEtiqueta');
    LIni.EraseSection('APIs.Einstein.ConsultarPaciente');
    LIni.EraseSection('APIs.Aspect.Sics.Atendente');
    LIni.EraseSection('APIs.Einstein.ConsultarPassagem');
    LIni.EraseSection('APIs.Aspect.Sics');
    LIni.DeleteKey('Settings', 'ListaIDsTriagem');

    vgParametrosModulo.EnviaEtiqueta               := LIni.ReadBool('Settings', 'EnviaEtiqueta', false);
    vgParametrosModulo.URL_BuscarParametro         := LIni.ReadString('APIs.Aspect.Sics.BuscarParametro', 'URL', 'http://10.32.10.21:80/aspect/backend/BuscarParametro/Settings/ListaTriagemJson');
    APIs.Aspect.Sics.ImprimirEtiqueta.TAPIAspectSicsImprimirEtiqueta.URL := LIni.ReadString('APIs.Aspect.Sics.ImprimirEtiqueta', 'URL', 'http://10.32.10.21:80/aspect/backend/ImprimirEtiqueta');
    APIs.Aspect.Sics.BuscarParametro.TAPIAspectSicsBuscarParametro.URL := LIni.ReadString('APIs.Aspect.Sics.BuscarParametro', 'URL', '');
    {$ENDIF}

    {$IFDEF CompilarPara_TOTEMTOUCH}
    vgParametrosModulo.IdModulo                    := LIni.ReadInteger('Settings', 'IdTotem'                , 0          );
    vgParametrosModulo.IdTotem                     := LIni.ReadInteger('Settings', 'IdTotem'                , 0          );
    {$ENDIF}

    {$IF Defined(CompilarPara_TGS)}
    //RA
    vgParametrosModulo.CaminhoAPI                  := LIni.ReadString ('Settings', 'CaminhoAPI'             , 'http://localhost:80/aspect/rest');
    //LM
    vgParametrosModulo.DBHostUnidades              := LIni.ReadString ('MultiUnidades', 'DBHost'            , ''         );
    vgParametrosModulo.DBBancoUnidades             := LIni.ReadString ('MultiUnidades', 'DBBanco'           , ''         );
    vgParametrosModulo.DBUsuarioUnidades           := LIni.ReadString ('MultiUnidades', 'DBUsuario'         , ''         );
    vgParametrosModulo.DBSenhaUnidades             := LIni.ReadString ('MultiUnidades', 'DBSenha'           , ''         );
    vgParametrosModulo.DBOSAuthentUnidades         := LIni.ReadBool   ('MultiUnidades', 'DBOSAuthent'       , False      );
    {$ENDIF}

//    {$IF Defined(CompilarPara_PA)}
    {$IF Defined(CompilarPara_ONLINE)}
    vgParametrosModulo.MenuEscondido              := LIni.ReadBool   ('Settings', 'MenuEscondido'           , false      );
    vgParametrosModulo.FontePadrao                := LIni.ReadBool   ('Settings', 'FontePadrao'             , false      );
    vgParametrosModulo.TamanhoFonteFile           := LIni.ReadInteger('Settings', 'TamanhoFonteFile'        , 0          );
    vgParametrosModulo.ExibirImagem               := LIni.ReadBool   ('Settings', 'ExibirImagem'            , false      );

    LIni.DeleteKey('Settings', 'ListaTriagemJson');
    //vgParametrosModulo.NomeImpressoraEtiqueta      := LIni.ReadString('Settings', 'NomeImpressoraEtiqueta', '');
    LIni.DeleteKey('Settings', 'NomeImpressoraEtiqueta');
    //vgParametrosModulo.QtdeImpressao               := LIni.ReadInteger('Settings', 'QtdeImpressao', 0);
    LIni.DeleteKey('Settings', 'QtdeImpressao');

    LIni.EraseSection('APIs.Aspect.Sics.DadosAdicionais');
    LIni.EraseSection('APIs.Einstein.ImprimirEtiqueta');
    LIni.DeleteKey('Settings', 'ListaIDsTriagem');

    vgParametrosModulo.EnviaEtiqueta               := LIni.ReadBool   ('Settings', 'EnviaEtiqueta'           , false      );
    vgParametrosModulo.URL_BuscarParametro         := LIni.ReadString('APIs.Aspect.Sics.BuscarParametro', 'URL', 'http://10.32.10.21:80/aspect/backend/BuscarParametro/Settings/ListaTriagemJson');
    APIs.Aspect.Sics.ImprimirEtiqueta.TAPIAspectSicsImprimirEtiqueta.URL := LIni.ReadString('APIs.Aspect.Sics.ImprimirEtiqueta', 'URL', 'http://10.32.10.21:80/aspect/backend/ImprimirEtiqueta');
    APIs.Aspect.Sics.BuscarParametro.TAPIAspectSicsBuscarParametro.URL := LIni.ReadString('APIs.Aspect.Sics.BuscarParametro', 'URL', '');
    {$ENDIF}

    vgParametrosModulo.DBDirMultiUnidades          := LIni.ReadString ('MultiUnidades', 'BaseDeDados'       , ''         );
    vgParametrosModulo.DBHostUnidades              := LIni.ReadString ('MultiUnidades', 'DBHost'            , ''         );
    vgParametrosModulo.DBBancoUnidades             := LIni.ReadString ('MultiUnidades', 'DBBanco'           , ''         );
    vgParametrosModulo.DBUsuarioUnidades           := LIni.ReadString ('MultiUnidades', 'DBUsuario'         , ''         );
    vgParametrosModulo.DBSenhaUnidades             := LIni.ReadString ('MultiUnidades', 'DBSenha'           , ''         );
    vgParametrosModulo.DBOSAuthentUnidades         := LIni.ReadBool   ('MultiUnidades', 'DBOSAuthent'       , False      );
    vgParametrosModulo.UnidadePadrao               := LIni.ReadInteger('MultiUnidades', 'UnidadePadrao'     , 0          );
    LUnidadesPermitidas                            := LIni.ReadString ('MultiUnidades', 'UnidadesPermitidas', ''         );

    StrToIntArray(LUnidadesPermitidas, vgParametrosModulo.UnidadesPermitidas);

    vgParametrosSicsClient.TCPSrvAdr               := LIni.ReadString ('Conexoes', 'TCPSrvAdr'              , ''         );
    vgParametrosSicsClient.TCPSrvPort              := LIni.ReadInteger('Conexoes', 'TCPSrvPort'             , PortaPadrao);
    vgParametrosSicsClient.TCPSrvAdrContingencia   := LIni.ReadString ('Conexoes', 'TCPSrvAdrContingencia'  , ''         );
    vgParametrosSicsClient.TCPSrvPortContingencia  := LIni.ReadInteger('Conexoes', 'TCPSrvPortContingencia' , PortaPadrao);
    vgParametrosSicsClient.IntervaloReceberComando := LIni.ReadInteger('Conexoes', 'IntervaloReceberComando', 300        );
    vgParametrosSicsClient.IntervaloReconectar     := LIni.ReadInteger('Conexoes', 'IntervaloReconectar'    , 5000       );


    {$IFDEF CompilarPara_PA}
    LIni.WriteBool    ('Settings', 'MenuEscondido' ,         vgParametrosModulo.MenuEscondido   );
    //LIni.WriteString  ('Settings', 'ListaIDsTriagem' ,       vgParametrosModulo.ListaIDsTriagem   );
    //LIni.WriteString  ('Settings', 'NomeImpressoraEtiqueta', vgParametrosModulo.NomeImpressoraEtiqueta);
    //LIni.WriteInteger ('Settings', 'QtdeImpressao',          vgParametrosModulo.QtdeImpressao);
    LIni.WriteBool    ('Settings', 'EnviaEtiqueta',          vgParametrosModulo.EnviaEtiqueta);
    LIni.WriteString('APIs.Aspect.Sics.BuscarParametro', 'URL', vgParametrosModulo.URL_BuscarParametro);
    {$ENDIF}

    {$IFNDEF CompilarPara_TOTEMTOUCH}
    LIni.WriteInteger('Settings', 'IdModulo'   , vgParametrosModulo.IdModulo      );
    {$ENDIF}

    {$IFDEF CompilarPara_TOTEMTOUCH}
    LIni.WriteInteger('Settings', 'IdTotem'    , vgParametrosModulo.IdTotem       );
    {$ENDIF}

    {$IF Defined(CompilarPara_TGS)}
    LIni.WriteString ('Settings', 'CaminhoAPI' , vgParametrosModulo.CaminhoAPI    );
    {$ENDIF}

    {$IF Defined(CompilarPara_ONLINE)}
    LIni.WriteBool   ('Settings', 'MenuEscondido',    vgParametrosModulo.MenuEscondido   );
    LIni.WriteBool   ('Settings', 'FontePadrao' ,     vgParametrosModulo.FontePadrao     );
    LIni.WriteInteger('Settings', 'TamanhoFonteFile', vgParametrosModulo.TamanhoFonteFile);
    LIni.WriteBool   ('Settings', 'ExibirImagem',     vgParametrosModulo.ExibirImagem    );
    //LIni.WriteString ('Settings', 'ListaTriagemJson'        , vgParametrosModulo.ListaTriagemJson);
    //LIni.WriteString ('Settings', 'NomeImpressoraEtiqueta', vgParametrosModulo.NomeImpressoraEtiqueta);
    //LIni.WriteInteger('Settings', 'QtdeImpressao',          vgParametrosModulo.QtdeImpressao);
    //LIni.WriteBool   ('Settings', 'EnviaEtiqueta',          vgParametrosModulo.EnviaEtiqueta);
    LIni.WriteString('APIs.Aspect.Sics.BuscarParametro', 'URL', vgParametrosModulo.URL_BuscarParametro);
    {$ENDIF}

    LIni.WriteString ('Conexoes', 'TCPSrvAdr'  , vgParametrosSicsClient.TCPSrvAdr );
    LIni.WriteInteger('Conexoes', 'TCPSrvPort' , vgParametrosSicsClient.TCPSrvPort);

    {$IF Defined(CompilarPara_TGS)}
    if not LIni.SectionExists('MultiUnidades') then
    begin
      LIni.WriteString('MultiUnidades', 'BaseDeDados' , '');
      //LM
      LIni.WriteString('MultiUnidades', 'DBHost'            , ''  );
      LIni.WriteString('MultiUnidades', 'DBBanco'           , ''  );
      LIni.WriteString('MultiUnidades', 'DBUsuario'         , ''  );
      LIni.WriteString('MultiUnidades', 'DBSenha'           , ''  );
      LIni.WriteString('MultiUnidades', 'DBOSAuthent'     , ''    );

      LIni.WriteString('MultiUnidades', 'UnidadePadrao' , '');
      LIni.WriteString('MultiUnidades', 'UnidadesPermitidas' , '');
      LIni.WriteString('MultiUnidades_IDsModulosTGS', 'Unidade1' , '');
      LIni.WriteString('MultiUnidades_IDsModulosTGS', 'Unidade2' , '');
    end;
    {$ENDIF}
  finally
    LIni.Free;
  end;
end;

procedure TdmUnidades.CadastrarUnidadePadrao;
begin
  if cdsUnidades.Active and (not cdsUnidades.IsEmpty) then
    Exit;

  InsereUnidade(0,
                vgParametrosModulo.Unidade,
                vgParametrosModulo.DBDir,
                vgParametrosSicsClient.TCPSrvAdr,
                vgParametrosSicsClient.TCPSrvPort,
                vgParametrosModulo.IdModulo,
                0,
                EmptyStr,
                vgParametrosModulo.DBHostUnidades,
                vgParametrosModulo.DBBancoUnidades,
                vgParametrosModulo.DBUsuarioUnidades,
                vgParametrosModulo.DBSenhaUnidades,
                IfThen(vgParametrosModulo.DBOSAuthentUnidades, 'T', 'F'));
end;

function TdmUnidades.ConfiguradoParaMultiUnidades:Boolean;
begin
  Result:= (Trim(vgParametrosModulo.DBDirMultiUnidades) <> EmptyStr) or
    (Trim(vgParametrosModulo.DBBancoUnidades) <> EmptyStr);
end;

procedure TdmUnidades.DataModuleCreate(Sender: TObject);

  procedure LInicializaUnidade(AID: Integer);
  var
    LDMConnection: TDMConnection;
  begin
    LDMConnection := DMConnection(AID, CRIAR_SE_NAO_EXISTIR);
    if Assigned(LDMConnection) then
      if AID = vgParametrosModulo.UnidadePadrao then
        LDMConnection.tmrReconnect.Enabled := True;
  end;

begin
  FIniciouAtualizacao    := False;
  FOnChangeStatusConexao := nil;
  FFormClient            := nil;

  cdsUnidadesClone := TClientDataSet.Create(Self);
  cdsUnidades.CreateDataSet;
  cdsUnidades.LogChanges := False;
  cdsUnidadesClone.LogChanges := False;
  CriticalEnviaComando := TMultiReadExclusiveWriteSynchronizer.Create;

  CarregarParametrosDoIni;

  if not ConfiguradoParaMultiUnidades then
  begin
    CadastrarUnidadePadrao;
    vgParametrosModulo.UnidadePadrao := ID_UNIDADE_PADRAO;
  end
  else
    CadastrarUnidadesBD;

  //garantir que a classe estará "limpa" após o carregamento das unidades
  TConexaoBD.Reset;

  {$IF Defined(CompilarPara_TGS) and Defined(DEBUG)}
  frmMonitorUnidades := TfrmMonitorUnidades.Create(Self);
  frmMonitorUnidades.Show;
  {$ENDIF}

  UnidadeAtiva := vgParametrosModulo.UnidadePadrao;

  //inicializa os DMs das demais unidades
  cdsUnidades.First;
  while not cdsUnidades.Eof do
  begin
    if cdsUnidadesID.Value <> vgParametrosModulo.UnidadePadrao then
      LInicializaUnidade(cdsUnidadesID.Value);
    cdsUnidades.Next;
  end;

  //inicializa o DM da Unidade Padrão primeiro
  LInicializaUnidade(UnidadeAtiva);

  CriarFormsAutoCreate;
end;

procedure TdmUnidades.CriarFormsAutoCreate;
var
  LDMClient    : TDMClient;
  {$IF ( (not Defined(CompilarPara_CALLCENTER)) and
         (not Defined(CompilarPara_TOTEMTOUCH)) )}
  LfrmPPs      : TFrmProcessoParalelo;
  {$ENDIF}

  {$IFDEF CompilarPara_TGS_ONLINE}
  LFraSituacaoAtendimento : TFraSituacaoAtendimento;
  LfrmSicsCommom_PIShow   : TFraIndicadorPerformance;
  {$ENDIF}
begin
  frmStyleBook := TfrmStyleBook.Create(nil);

  LDMClient := DMClient(UnidadeAtiva, not CRIAR_SE_NAO_EXISTIR);

  {$REGION '//CompilarPara_PA_MULTIPA'}
  {$IFDEF CompilarPara_PA_MULTIPA}
  // frmLogin
  FrmLogin(UnidadeAtiva, CRIAR_SE_NAO_EXISTIR);

  // frmSelecaoFila
  FrmSelecaoFila(UnidadeAtiva, CRIAR_SE_NAO_EXISTIR);
  {$ENDIF CompilarPara_PA_MULTIPA}
  {$ENDREGION}

  {$REGION '//CompilarPara_TGS'}
  {$IFDEF CompilarPara_TGS}
  frmLines(UnidadeAtiva, CRIAR_SE_NAO_EXISTIR);
    // frmSelecaoGrupoAtendente
  FrmSelecaoGrupoAtendente(UnidadeAtiva, CRIAR_SE_NAO_EXISTIR);
  {$ENDIF CompilarPara_TGS}
  {$ENDREGION}

  {$REGION '//CompilarPara_ONLINE'}
  {$IFDEF CompilarPara_ONLINE}
  fraSituacaoEspera(UnidadeAtiva, CRIAR_SE_NAO_EXISTIR);

  // fraIndicadorPerformance
  LfrmSicsCommom_PIShow := FraIndicadorPerformance(UnidadeAtiva, CRIAR_SE_NAO_EXISTIR);
  //adicionado para que o Timer que busca a atualização dos PI não seja executado
  //enquanto o frame não estiver visível
  LfrmSicsCommom_PIShow.Visible := False;
  {$ENDIF CompilarPara_ONLINE}
  {$ENDREGION}

  {$REGION '//CompilarPara_TGS_ONLINE'}
  {$IFDEF CompilarPara_TGS_ONLINE}
  // fraSituacaoAtendimento
  LFraSituacaoAtendimento := FraSituacaoAtendimento(UnidadeAtiva, CRIAR_SE_NAO_EXISTIR);
  {$ENDIF CompilarPara_TGS_ONLINE}
  {$ENDREGION}

  {$REGION '//Todos menos CompilarPara_SICSTV'}
  {$IF ((not Defined(CompilarPara_SICSTV)) and
        (not Defined(CompilarPara_CALLCENTER)) and
        (not Defined(CompilarPara_TOTEMTOUCH))) }
  // frmSelecaoPP
  FrmSelecaoPP(UnidadeAtiva, CRIAR_SE_NAO_EXISTIR);

  // frmSelecaoMotivoPausa
  FrmSelecaoMotivoPausa(UnidadeAtiva, CRIAR_SE_NAO_EXISTIR);



  //frmProcessoParalelo
  LfrmPPs := FrmProcessoParalelo(UnidadeAtiva, CRIAR_SE_NAO_EXISTIR);

  if (Nome[UnidadeAtiva] <> '') then
    LfrmPPs.Caption := LfrmPPs.Caption + ' - ' + Nome[UnidadeAtiva];

  LfrmPPs.cdsPPslkp_TipoPP_Nome.LookupDataSet := LDMClient.cdsPPs;
  LfrmPPs.cdsPPslkp_PA_Nome.LookupDataSet     := LDMClient.cdsPAs;
  LfrmPPs.cdsPPslkp_ATD_Nome.LookupDataSet    := LDMClient.cdsAtendentes;

  LfrmPPs.cdsPPs.CreateDataSet;
  LfrmPPs.cdsPPs.LogChanges := False;
  {$ENDIF}
  {$ENDREGION}

  ExecutaAtualizacaoAPP;
end;

procedure TdmUnidades.ExecutaAtualizacaoAPP;
begin
  {$IFNDEF IS_MOBILE}
  if (not FIniciouAtualizacao) then
  begin
    FIniciouAtualizacao := True;
    try
      AspUpd_ChecarEFazerUpdate(vgParametrosSicsClient.ArqUpdateDir);
    finally
      FIniciouAtualizacao := False;
    end;
  end;
  {$ENDIF}
end;

procedure TdmUnidades.DataModuleDestroy(Sender: TObject);
begin
  FreeAndNil(cdsUnidadesClone);
  FreeAndNil(CriticalEnviaComando);
  FormClient := nil;
end;

function TdmUnidades.GetAlgumaConectada: Boolean;
begin
  result := QuantidadeConectada > 0;
end;

function TdmUnidades.GetConectada(aIdUnidade: Integer): Boolean;
begin
  if cdsUnidadesID.Value <> aIdUnidade then
  begin
    if not cdsUnidades.Locate('ID', aIdUnidade, []) then
      Exit(False);
  end;

  result := cdsUnidadesCONECTADA.Value;
end;

//function TdmUnidades.GetDBDir(aIdUnidade: Integer): String;
//begin
//  if cdsUnidadesID.Value <> aIdUnidade then
//  begin
//    if not cdsUnidades.Locate('ID', aIdUnidade, []) then
//      Exit(EmptyStr);
//  end;
//
//  result := cdsUnidadesPATH_BASE.AsString;
//end;

function TdmUnidades.GetIdModulo(aIdUnidade: Integer): Integer;
begin
  if cdsUnidadesID.Value <> aIdUnidade then
  begin
    if not cdsUnidades.Locate('ID', aIdUnidade, []) then
      Exit(0);
  end;

  result := cdsUnidadesIDMODULO.Value;
end;

function TdmUnidades.GetIP(aIdUnidade: Integer): String;
begin
  if cdsUnidadesID.Value <> aIdUnidade then
  begin
    if not cdsUnidades.Locate('ID', aIdUnidade, []) then
      Exit(EmptyStr);
  end;

  result := cdsUnidadesIP_ENDERECO.AsString;
end;

function TdmUnidades.GetNenhumaConectada: Boolean;
begin
  result := QuantidadeConectada = 0;
end;

function TdmUnidades.GetNomeUnidade(aIdUnidade: Integer): String;
begin
  if cdsUnidadesID.Value <> aIdUnidade then
  begin
    if not cdsUnidades.Locate('ID', aIdUnidade, []) then
      Exit('IdUnidade: ' + aIdUnidade.ToString);
  end;

  result := cdsUnidadesNOME.AsString;
end;

function TdmUnidades.GetPorta(aIdUnidade: Integer): Integer;
begin
  if cdsUnidadesID.Value <> aIdUnidade then
  begin
    if not cdsUnidades.Locate('ID', aIdUnidade, []) then
      Exit(0);
  end;

  result := cdsUnidadesIP_PORTA.Value;
end;

function TdmUnidades.GetQuantidade: Integer;
begin
  if cdsUnidades.Active then
    result := cdsUnidades.RecordCount
  else
    result := 0;
end;

function TdmUnidades.GetQuantidadeConectadas: Integer;
begin
  result := 0;
  if cdsUnidades.Active then
  begin
    cdsUnidades.First;
    while not cdsUnidades.Eof do
    begin
      if cdsUnidadesCONECTADA.Value then
        Inc(result);
      cdsUnidades.Next;
    end;
  end;
end;

function TdmUnidades.GetTodasConectadas: Boolean;
begin
  result := QuantidadeConectada > Quantidade;
end;

procedure TdmUnidades.ExecutaParaTodasUnidades(const aMetodo: TMetodo);
begin
  if not Assigned(aMetodo) then
    Exit;

  if cdsUnidadesClone.Active then
  begin
    cdsUnidadesClone.First;
    while not cdsUnidadesClone.Eof do
    begin
      aMetodo;
      cdsUnidadesClone.Next;
    end;
  end;
end;

procedure TdmUnidades.ExecutaParaTodasUnidades(const aMetodoUnidade: TMetodoUnidade);
begin
  if not Assigned(aMetodoUnidade) then
    Exit;

  if cdsUnidadesclone.Active then
  begin
    cdsUnidadesclone.First;
    while not cdsUnidadesclone.Eof do
    begin
      aMetodoUnidade(cdsUnidadesClone.FieldByName('ID').Value);
      cdsUnidadesclone.Next;
    end;
  end;
end;

function TdmUnidades.ExecutaParaTodasUnidades(const aFuncao: TFuncao): Boolean;
begin
  Result := False;
  if not Assigned(aFuncao) then
    Exit;

  if cdsUnidadesclone.Active then
  begin
    cdsUnidadesclone.First;
    while not cdsUnidadesclone.Eof do
    begin
        try
          if aFuncao then
            Result := True;
        except
          on E: Exception do
          begin
            ErrorMessage(Format('Erro ao executar para a unidade %n. %s',
              [cdsUnidadesclone.FieldByName('ID').AsInteger,
               sLineBreak + 'Erro: ' + E.Message]));
            cdsUnidadesclone.Next;
            Continue;
          end;
        end;
      cdsUnidadesclone.Next;
    end;
  end;
end;

procedure TdmUnidades.SetConectada(aIdUnidade: Integer; const Value: Boolean);
begin
  SetUnidadeConectada(aIdUnidade, Value);
end;

procedure TdmUnidades.SetUnidadeAtiva(const Value: Integer);
begin
  FUnidadeAtiva := Value;
  cdsUnidades.Locate('ID', Value, []);
end;

procedure TdmUnidades.SetUnidadeConectada(const aIDUnidade: integer; const aConectada: Boolean);
var
  LField: TBooleanField;
begin
  LField := TBooleanField(cdsUnidadesClone.FieldByName('CONECTADA'));

  if cdsUnidadesClone.Active and
     cdsUnidadesClone.Locate('ID', aIdUnidade, []) and
     (LField.Value <> aConectada) then
  begin
    cdsUnidadesClone.Edit;
    LField.Value := aConectada;
    cdsUnidadesClone.Post;

    if Assigned(FOnChangeStatusConexao) then
      FOnChangeStatusConexao(aIDUnidade, aConectada);
  end;
end;

function TdmUnidades.FoiConfiguradoConexao: Boolean;
var
  LDMConnection : TDMConnection;
  IdModulo : integer;
begin
  IdModulo := 0;

  LDMConnection := DMConnection(FUnidadeAtiva, CRIAR_SE_NAO_EXISTIR);
  if Assigned(LDMConnection) then
      IdModulo := LDMConnection.IdModulo;

  if ConfiguradoParaMultiUnidades then
  begin
    Result := True;
  end
  else
  begin
    Result := (vgParametrosSicsClient.TCPSrvAdr <> '') and
              (vgParametrosSicsClient.TCPSrvPort <> 0) and
              (idModulo <> 0);
  end;
end;


procedure TdmUnidades.VerificaParametrosConexao;
begin
  if not FoiConfiguradoConexao then
  begin
    {$IFNDEF CompilarPara_TOTEMTOUCH}
    TFrmConfigParametros.ConfiguraParametrosConexao({$IFDEF  IS_MOBILE}
      procedure
      begin
        if not FoiConfiguradoConexao then
        FinalizeApplication; //exit;
      end
    {$ENDIF});
    {$ENDIF}

    {$IFNDEF IS_MOBILE}
    if not FoiConfiguradoConexao then
      FinalizeApplication; //exit;
    {$ENDIF}
  end;
end;

function TdmUnidades.IdUnidadeConformePosicaoNaLista(
  const aPosicao: Integer): Integer;
begin
  cdsUnidadesClone.RecNo := aPosicao;
  result := cdsUnidadesClone.FieldByName(cdsUnidadesID.FieldName).AsInteger;
end;

procedure TdmUnidades.InsereUnidade(AId: integer; const ANome, APathBase,
  AEnderecoIP: string; const APortaIP, AIdModulo, AIdGrupoUnidade: integer;
  AIdUnidadeCliente, AHost, ABanco, AUsuario, ASenha,
  AOSAuthent: String);
begin
  if not cdsUnidades.Active then
    cdsUnidades.CreateDataSet;

  cdsUnidades.Append;
  cdsUnidadesID.AsInteger         := AId;
  cdsUnidadesNOME.AsString        := ANome;
  cdsUnidadesPATH_BASE.AsString   := APathBase;
  cdsUnidadesIP_ENDERECO.AsString := AEnderecoIP;
  cdsUnidadesIP_PORTA.AsInteger   := APortaIP;
  cdsUnidadesCONECTADA.AsBoolean  := False;
  cdsUnidadesIDMODULO.Value       := AIdModulo;
  cdsUnidadesID_UNID_CLI.AsString := AIdUnidadeCliente;
  cdsUnidadesIDGRUPO.Value        := AIdGrupoUnidade;
  cdsUnidadesHOST.AsString        := AHost;
  cdsUnidadesBANCO.AsString       := ABanco;
  cdsUnidadesUSUARIO.AsString     := AUsuario;
  cdsUnidadesSENHA.AsString       := ASenha;
  cdsUnidadesOSAUTHENT.AsString   := AOSAuthent;
  cdsUnidades.Post;

  TConexaoBD.Reset;
  TConexaoBD.IdUnidade := AId;
  TConexaoBD.Dir       := APathBase;
  TConexaoBD.Host      := AHost;
  TConexaoBD.Banco     := ABanco;
  TConexaoBD.Usuario   := AUsuario;
  TConexaoBD.Senha     := ASenha;
  TConexaoBD.OSAuthent := AOSAuthent = 'T';
  TConexaoBD.CheckFirebirdLocalHost(AEnderecoIP);
  TConexaoBD.Configurar(FDManager);
end;

procedure TdmUnidades.CadastrarUnidadesBD;
const
  SESSAO = 'MultiUnidades_IDsModulosTGS';
  CHAVE  = 'Unidade%d';
var
  LIni: TIniFile;
  LChave: String;
  LIdModulo: Integer;
begin
  LIni := TIniFile.Create(AspLib_GetAppIniFileName);
  try
    TConexaoBD.Reset;
    TConexaoBD.IdUnidade := vgParametrosModulo.UnidadePadrao;
    TConexaoBD.Dir       := vgParametrosModulo.DBDirMultiUnidades;
    TConexaoBD.Host      := vgParametrosModulo.DBHostUnidades;
    TConexaoBD.Banco     := vgParametrosModulo.DBBancoUnidades;
    TConexaoBD.Usuario   := vgParametrosModulo.DBUsuarioUnidades;
    TConexaoBD.Senha     := vgParametrosModulo.DBSenhaUnidades;
    TConexaoBD.OSAuthent := StrToBoolDef(IfThen(vgParametrosModulo.DBOSAuthentUnidades, 'T', 'F'),False);
//    TConexaoBD.CheckFirebirdLocalHost(vgParametrosModulo.DBDirMultiUnidades);
    TConexaoBD.Configurar(FDManager);

    dmUnidades.conn.Params.Clear;
    dmUnidades.conn.ConnectionDefName := TConexaoBD.NomeBasePadrao(vgParametrosModulo.UnidadePadrao);

    dmUnidades.qryUnidades.Open;
    try
      while not dmUnidades.qryUnidades.Eof do
      begin
        if ExisteNoIntArray(dmUnidades.qryUnidadesID.Value,
                            vgParametrosModulo.UnidadesPermitidas) then
        begin
          LChave := Format(CHAVE, [dmUnidades.qryUnidadesID.Value]);
          LIdModulo := LIni.ReadInteger(SESSAO, LChave, -1);

          InsereUnidade(dmUnidades.qryUnidadesID.Value,
                        dmUnidades.qryUnidadesNOME.AsString,
                        dmUnidades.qryUnidadesDBDIR.AsString,
                        dmUnidades.qryUnidadesIP.AsString,
                        dmUnidades.qryUnidadesPORTA_TGS.Value,
                        LIdModulo,
                        0,
                        EmptyStr,
                        dmUnidades.qryUnidadesHOST.AsString,
                        dmUnidades.qryUnidadesBANCO.AsString,
                        dmUnidades.qryUnidadesUSUARIO.AsString,
                        dmUnidades.qryUnidadesSENHA.AsString,
                        dmUnidades.qryUnidadesOSAUTHENT.AsString);
        end;

        dmUnidades.qryUnidades.Next;
      end;
    finally
      dmUnidades.conn.Close;
    end;

  finally
    LIni.Free;
  end;
end;

function TdmUnidades.PosicaoNaLista(const aIdUnidade: Integer): Integer;
begin
  if cdsUnidadesClone.Locate('ID', aIdUnidade, []) then
    result := cdsUnidadesClone.RecNo
  else
    result := -1;
end;

function TdmUnidades.PosicaoNaLista(const aNomeUnidade: String): Integer;
begin
  if cdsUnidadesClone.Locate('NOME', aNomeUnidade, []) then
    result := cdsUnidadesClone.RecNo
  else
    result := -1;
end;

procedure TdmUnidades.PreencherListaUnidades(aLista: TStrings; const aField: String);
begin
  cdsUnidadesClone.First;
  while not cdsUnidadesClone.Eof do
  begin
    aLista.Add(cdsUnidadesClone.FieldByName(aField).AsString);
    cdsUnidadesClone.Next;
  end;
end;

end.
