unit untParametrosTGSDB;

interface
uses
  System.Generics.Collections, SysUtils, System.Types, Classes, IniFiles, Datasnap.DBClient, ClassLibrary, System.Generics.defaults,
  {$IFDEF FIREMONKEY}
  FMX.Types, FMX.StdCtrls, AspPanel,  AspLabelFMX, AspGroupBox,  AspButton,
  {$ENDIF}
  untParametroBaseDB,System.UITypes, Aspect, System.IOUtils, AspComponenteUnidade, AspFuncoesUteis;

{$INCLUDE ..\AspDefineDiretivas.inc}
type
  {$IFDEF CompilarPara_TGS}

  TParametrosModuloTGSDBPorUnidade = class(TParametrosModuloBase_PA_MPA_TGSDB, IInterfaceUnidade)
  private
  protected
    FIDUnidade: Integer;
    function GetIDUnidade: Integer;
    procedure SetIDUnidade(const Value: Integer);
  public
    WebserverAtivo: Boolean;
    VisualizarTagsNasFilas: TIntegerDynArray;
    VisualizarPausa: Boolean;
    VisualizarNomeClientes: Boolean;
    VisualizarGrupos: Boolean;
    SmtpNomeRemetente: String;
    SmtpEmailRemetente: String;
    SegundosParaAutoScrollUnidades: Integer;
    ReportarTemposMaximos: Boolean;
    PodeConfigPrioridadesAtend: Boolean;
    PodeConfigIndDePerformance: Boolean;
    PodeConfigAtendentes: Boolean;
    GruposIndicadoresPermitidos: TIntegerDynArray;
    GruposDeMotivosDePausaPerm: TIntegerDynArray;
    FaltaPapel: String;
    ExportarGrafico: Boolean;
    Contingencia: String;
    ConexaoEquipamentos: String;
    AberturaMedianteLogin: Boolean;
    property IDUnidade: Integer read GetIDUnidade write SetIDUnidade;
    constructor Create(aOwner: TComponent); Overload; Override;
    constructor Create(aOwner: TComponent; const aIDUnidade: Integer); Reintroduce; Overload; virtual;
    destructor Destroy; Override;
    procedure SetValoresDefault; Override;
//    procedure CarregarOuSalvarParametrosPorIni(const aSalvar: Boolean); Override;
  end;
  {$ENDIF CompilarPara_TGS}
implementation


{$IFDEF CompilarPara_TGS}
constructor TParametrosModuloTGSDBPorUnidade.Create(aOwner: TComponent; const aIDUnidade: Integer);
begin
  Create(aOwner);
  IDUnidade := aIDUnidade;
end;
constructor TParametrosModuloTGSDBPorUnidade.Create(aOwner: TComponent);
begin
  inherited;
  FIDUnidade := ID_UNIDADE_VAZIA;
end;

procedure TParametrosModuloTGSDBPorUnidade.SetIDUnidade(const Value: Integer);
begin
  FIDUnidade := Value;
  if GetTipoTela <> TTipoTela.tcNenhum then
    FGerenciadorUnidades.Add(GetTipoTela, Self);
end;

procedure TParametrosModuloTGSDBPorUnidade.SetValoresDefault;
begin
  inherited;
  WebserverAtivo := False;
  SetLength(VisualizarTagsNasFilas, 0);
  if (IDUnidade = ID_UNIDADE_VAZIA) then
    IDUnidade := ID_UNIDADE_PRINCIPAL;
  VisualizarPausa := False;
  VisualizarNomeClientes := False;
  VisualizarGrupos := False;
  SmtpNomeRemetente := 'SICS - Sistema Inteligente de Chamada de Senhas';
  SmtpEmailRemetente := 'suporte_sw@aspect.com.br';
  SegundosParaAutoScrollUnidades := 0;
  ReportarTemposMaximos := False;
  PodeConfigPrioridadesAtend := False;
  PodeConfigIndDePerformance := False;
  PodeConfigAtendentes := False;
  SetLength(GruposIndicadoresPermitidos, 0);
  SetLength(GruposDeMotivosDePausaPerm, 0);
  FaltaPapel := '';
  ExportarGrafico := False;
  Contingencia := '';
  ConexaoEquipamentos := '';
  AberturaMedianteLogin := False;
  SegundosParaAutoScrollUnidades := 7;
end;

destructor TParametrosModuloTGSDBPorUnidade.Destroy;
begin
  FGerenciadorUnidades.Remove(GetTipoTela, Self);
  inherited;
end;

function TParametrosModuloTGSDBPorUnidade.GetIDUnidade: Integer;
begin
  Result := FIDUnidade;
end;
{$ENDIF CompilarPara_TGS}
end.