unit SicsTV_m;

{$J+}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Winapi.ShellAPI, Winapi.TlHelp32, System.UITypes, Data.DB, Dialogs, ExtCtrls,
  StdCtrls, JvPanel, Menus, IniFiles, JvImage, jpeg, MyDlls_DR, Buttons,
  JvExExtCtrls, JvComponent, JvComponentBase, JvTrayIcon, DateUtils, ScktComp,
  MPlayer, JvGIF, JvExControls, JvImageTransform, JvSecretPanel, JvBackgrounds,
  JvExStdCtrls, JvBehaviorLabel, JvExtComponent, OleCtrls, ShDocVw, ActiveX,
  mshtml, QuickRpt, DBClient, ComCtrls, AppEvnts, RealTimeMarquee,
  ShockwaveFlashObjects_TLB, Sics_Common_PIShow, Grids, ASPLabel,
  ComObj, untConstsWM, SHFolder, VideoCaptureMain, VideoCapturetypes,
  WMPLib_TLB, Vcl.Imaging.pngimage, DSUtil, DSPack, DirectShow9, System.JSON,
  Winapi.WinSock, StrUtils, Math, System.Types, Winapi.MMSystem,
  untLog;

{$INCLUDE ..\SicsVersoes.pas}

const
  cgMaxPanels    = 999;
  cgMaxChamadas  = 20;

type
  TTipoChamadaPorVoz = (cvSenha, cvNomePA, cvNomeCliente);
  EEnvioDeEmail = class (Exception);
  THorarioDeFuncionamento = record
                              DesdeHoras, AteHoras : TTime;
                              FuncionaSabado, FuncionaDomingo : boolean;
                            end;
  TTipoDePainel = (tpTela, tpChamadaSenha, tpUltimasSenhas, tpImagem, tpFlash, tpDataHora, tpVideo, tpTV, tpJornalEletronico, tpIndicadorPerformance, tpPlayListManager);

  TTipoAjuste  = (taCanal, taVolume, taClosedCaption);

  TValorAjuste = (vaSubir, vaDescer);

  TArrString = array of string;

  TTipoPlanoDeFundo = (pfImagem, pfCorSolida, pfTransparente);

  TPlanoDeFundo = record
                    Tipo   : TTipoPlanoDeFundo;
                    Cor    : TColor;
                    Imagem : string;
                  end;

  TParametrosQuadrosGerais = record
                               X, Y, Larg, Alt : integer;
                               PlanoDeFundo : TPlanoDeFundo;
                             end;

  TParametrosQuadroTV = record
                          Gerais                  : TParametrosQuadrosGerais;
                          ParentHandle, AppHandle : DWORD;
                          SoftwareHomologado      : integer; //0 = outro (editavel), 1 em diante = parâmetros frequentes de softwares homologados, ex: 1 = AverTV, 2 = VLC, etc
                          CaminhoDoExecutavel     : string;
                          NomeDaJanela            : string;
                          Dispositivo             : Integer;
                          Resolucao               : Integer;
                          TempoAlternancia        : Integer;
                          PanelVideo              : TJvPanel;
                          Panel                   : TJvPanel;
                        end;


  TParametrosQuadroPlayListManager = record
                                       Gerais                  : TParametrosQuadrosGerais;
                                       ParentHandle, AppHandle : DWORD;
                                       NomeDaJanela            : string;
                                       IDTV                    : Integer;
                                       TipoBanco               : Integer;
                                       HostBanco               : string;
                                       PortaBanco              : string;
                                       NomeArquivoBanco        : string;
                                       UsuarioBanco            : string;
                                       SenhaBanco              : string;
                                       IntervaloVerificacao    : Integer;
                                       AtualizacaoPlayList     : TDateTime;
                                       DiretorioLocal          : string;
                                       PanelVideo              : TJvPanel;
                                       Panel                   : TJvPanel;
                                     end;


  TResolucaoMonitor = record
    Width: Integer;
    Height: Integer;
    class operator Implicit(AValue: TResolucaoMonitor): String;
    class operator Implicit(AValue: String): TResolucaoMonitor;
    procedure Reset;
    function Valida: Boolean;
  end;

  TfrmSicsTVPrincipal = class(TForm)
    menuPopup: TPopupMenu;
    menuPropriedades: TMenuItem;
    menuNovo: TMenuItem;
    menuTela: TMenuItem;
    menuQuadroChamadaSenhas: TMenuItem;
    menuQuadroUltimasChamadas: TMenuItem;
    menuImagem: TMenuItem;
    menuFlash: TMenuItem;
    menuSobre: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    menuSair: TMenuItem;
    menuExcluir: TMenuItem;
    menuConfigurar: TMenuItem;
    OneSecondTimer: TTimer;
    Logo: TJvPanel;
    LogoAspect: TImage;
    menuTrazerParaFrente: TMenuItem;
    menuEnviarParaTras: TMenuItem;
    menuMaximizar: TMenuItem;
    menuMonitor1: TMenuItem;
    menuMonitor2: TMenuItem;
    pnlScreenSaver: TPanel;
    menuHorarioDeFuncionamento: TMenuItem;
    JvTrayIcon1: TJvTrayIcon;
    tmrReconnect: TTimer;
    menuDataHora: TMenuItem;
    menuVideo: TMenuItem;
    V1: TMenuItem;
    cdsTVCanais: TClientDataSet;
    cdsTVCanaisCANAL: TIntegerField;
    cdsTVCanaisFREQUENCIA: TIntegerField;
    cdsTVCanaisNOME: TStringField;
    JornalEletrnico1: TMenuItem;
    ServerSocket1: TServerSocket;
    cdsUltimasChamadas: TClientDataSet;
    cdsUltimasChamadasID_PAINEL: TIntegerField;
    cdsUltimasChamadasSENHA: TStringField;
    cdsUltimasChamadasNOME_PA: TStringField;
    cdsUltimasChamadasDATA_HORA: TDateTimeField;
    cdsUltimasChamadasID_PA: TIntegerField;
    DataSource1: TDataSource;
    TimerCheckArquivoFlash: TTimer;
    Indicadordeperformance1: TMenuItem;
    cdsUltimasChamadasNOME_CLIENTE: TStringField;
    tmrTrazerFormParaFrente: TTimer;
    Visualizar1: TMenuItem;
    N3: TMenuItem;
    IndicadoresdePerformance1: TMenuItem;
    timerPosicionarAppTV: TTimer;
    tmrAlternaTVVideo: TTimer;
    MmPlaylistManager: TMenuItem;
    timerTrocaCanalTV: TTimer;
    FilterGraph: TFilterGraph;
    Filter: TFilter;
    SampleGrabber: TSampleGrabber;
    ApplicationEvents1: TApplicationEvents;
    procedure menuPropriedadesClick(Sender: TObject);
    procedure menuNovoClick(Sender: TObject);
    procedure PanelMouseLeave(Sender: TObject);
    procedure menuSobreClick(Sender: TObject);
    procedure menuSairClick(Sender: TObject);
    procedure menuPopupPopup(Sender: TObject);
    procedure PanelAfterMove(Sender: TObject);
    procedure menuExcluirClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PanelResize(Sender: TObject);
    procedure PanelDblClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure OneSecondTimerTimer(Sender: TObject);
    procedure menuTrazerParaFrenteClick(Sender: TObject);
    procedure menuEnviarParaTrasClick(Sender: TObject);
    procedure menuMonitorClick(Sender: TObject);
    procedure menuHorarioDeFuncionamentoClick(Sender: TObject);
    procedure tmrReconnectTimer(Sender: TObject);
    procedure MediaPlayerNotify(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ServerSocket1ClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocket1ClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocket1ClientError(Sender: TObject;
      Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer);
    procedure ServerSocket1ClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure TimerCheckArquivoFlashTimer(Sender: TObject);

    procedure FecharSoftwareTV;

    procedure tmrTrazerFormParaFrenteTimer(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure IndicadoresdePerformance1Click(Sender: TObject);
    procedure timerPosicionarAppTVTimer(Sender: TObject);
    procedure tmrAlternaTVVideoTimer(Sender: TObject);
    procedure tmrVerificaTerminoVideoTimer(Sender: TObject);
    procedure VideoWindowClick(Sender: TObject);
  private
    { Private declarations }

    procedure MyExceptionHandler (Sender: TObject; E: Exception);
    procedure ChamaSenha (IdPA: Integer; NomePA, Senha, NomeCliente, TextoVozPA : string);

    function  ArrayOfByte_AnsiStringToString (a : AnsiString) : String;
    function  ArrayOfByte_StringToAnsiString (s : string) : AnsiString;
    function  EnviaComando(const ASocket: TCustomWinSocket; const AComando: string): Integer;

    procedure EnviarServidorNovoCanalPadrao;
    procedure EnviarServidorCanaisCapturados;
    procedure GetServidorCanaisHabilitados;

    procedure WebBrowserOnDocumentComplete(ASender: TObject; const pDisp: IDispatch; const URL: OleVariant); //Para remover ScrollBars após carregar HTML
    procedure WebBrowserLoadHTML          (WebBrowser: TWebBrowser; HTMLCode: string) ;
    procedure EventoTimePlayList(Sender : TObject);

    procedure MudarCanalVolumeSichboPVR(AAjuste:TTipoAjuste; AValorAjuste: TValorAjuste);

    /// <summary>
    ///  Responde à mensagem do SicsTVGuardian.exe, que monitora o SicsTV
    ///  para reativa-lo caso ele trave.
    /// </summary>
    procedure ResponderQueryIfAliveMsg(var Message: TMessage); message QUERY_IF_ALIVE_MSG;

    /// <summary>
    ///   Dispara sempre que a resolução do monitor for alterada;
    /// </summary>
    procedure WMDisplayChange(var Msg: TWMDisplayChange); message WM_DISPLAYCHANGE;

    function AbrirAplicativoTV: Boolean;
    function ResolucaoEstaCorreta: Boolean;
    function ProcessoEmExecucao(const ANomeProcesso: String;
      var AProcessEntry32: TProcessEntry32): Boolean;
    procedure AjustarTVVolumeOuCanal(pTipoAjuste: TTipoAjuste; pValorAjuste: TValorAjuste);
    procedure CarregarImagemNoPlayListManager(const APanel: TJvPanel; const APath: String);
    function  BuscaHorarioUltimaAtualizacaoPlayList: String;
    //LM
    function  StatusLiveTv: String;

  public
    gfInitializing, vgChamadaInterrompeVideo,
      gfConfigurandoHorarioDeFuncionamento                   : boolean;
    vlAddress, gfMouseTimeout                                : integer;
    vgResolucaoPadrao                                        : TResolucaoMonitor;
    VoiceIndex: Integer;
    LVolume : Integer;
    FIniciouAtualizacao: Boolean;

    FPathSicsLiveTV: String;

    VFVideoCapture                       : TVFVideoCapture;
    VideoWindow                          : TVideoWindow;
    vgTVComponent                        : TParametrosQuadroTV;
    vgTVCanalPadrao                      : Integer;
    vgTVChannelList                      : TStringList;
    vgJornalEletronico                   : TRealTimeMarquee;
    vgIdTV                               : Integer;
    vgTVPlayListManager                  : TParametrosQuadroPlayListManager;
    Voice                                : OLEVariant;
    TextoOriginalJornalEletronico        : string;
    FItemAtualPlayListManager            : Integer;
    IDUnidade                            : Integer;
    vgHorarioDeFuncionamento             : THorarioDeFuncionamento;

    function  CreatePanel (no : integer; Tipo : TTipoDePainel;criarPainelVideoTV : boolean = false) : boolean;
    function CriaVideoCaptura(LPanel: TPanel): Boolean;
    function AbrirTVTestandoResolucao(LPanel: TPanel): Boolean;
    procedure IniciarAtualizacaoPlaylistManager(const APanel: TJvPanel; const APath: String);
    procedure FinalizarAtualizacaoPlaylistManager(const APanel: TJvPanel);
    function  ExecutarVideo(No : Integer) : boolean;

    function  ExecutarPlayList(Panel : TJvPanel; No : integer) : boolean;
    procedure WMPlayStateChange(ASender: TObject;  NewState: Integer);

    procedure InicializarForm;
    function  DecifraProtocolo (s : string; Socket : TCustomWinSocket): String;
    function  EstaNoHorarioDeFuncionamento : boolean;

    procedure SetConnectedMode    (IdUnidade : integer);
    procedure SetDisconnectedMode (IdUnidade : integer);
    procedure DisplayMessage (s : string);

    function  ValidarPA (PA : integer) : boolean;
    procedure SetVolumeIni(aVolume: Integer);
    procedure LoadPanel (no : integer);
    procedure SavePanel (no : integer);
    function  GetPanelProperties   (Panel : TJvPanel) : boolean;
    function  SetPanelProperties   (Panel : TJvPanel) : boolean;
    procedure CreateLabelsChamada         (Panel : TJvPanel);
    procedure CreateLabelsUltimasChamadas (Panel : TJvPanel; Numero : integer);
    procedure CreateLabelsDataHora        (Panel : TJvPanel; Formato : string);
    procedure AlinhaLabelsChamada         (Panel : TJvPanel);
    procedure AlinhaLabelsUltimasChamadas (Panel : TJvPanel);
    procedure AlinhaLabelsDataHora        (Panel : TJvPanel);
    procedure AtualizaPanelsUltimasChamadas(const Senha, NomePA, NomeCliente: string; IdPA: Integer);
    procedure AtualizaPanelsIndicadoresDesempenho;

//    procedure MudarCanalTV(Canal: Integer);

    procedure ExcluirPainel;
    procedure LimparPainelTV;
    function SoftwarePadraoTV(AID: Integer): Boolean;

    function DefinirNomeParaSenha(IdUnidade: Integer; Senha : integer; Nome : string) : boolean;

    procedure CheckArquivoFlashModificado;

    procedure TextToVoice(AText: string);
    procedure AtivarDesativarSomAverTV;
    procedure SetarVolumePadraoAverTV;
    procedure MinimizarRestaurarAverTV(Acao : NativeUInt);
    procedure ExecutaAtualizacaoAPP;

    procedure ModoConectado(const aIdUnidade: Integer);
    procedure ModoDesconectado(const aIdUnidade: Integer);
  end;

const
  TTipoDePainelStr: array[TTipoDePainel] of string = (
    'Tela',
    'Chamada de Senhas',
    'Últimas Chamadas',
    'Imagem',
    'Flash',
    'Data e Hora',
    'Video',
    'TV',
    'Jornal Eletrônico',
    'Indicador de Performance',
    'Playlist Manager');

  TTipoChamadaPorVozStr : array[TTipoChamadaPorVoz] of string = (
    'Número da senha',
    'Nome da PA',
    'Nome do cliente');

var
  frmSicsTVPrincipal: TfrmSicsTVPrincipal;
  vgPainelSelecionado: integer;
  SysDev: TSysDevEnum;

implementation

uses
  SicsTV_2,
  SicsTV_3,
  SicsTV_4,
  Sics_Common_Splash,
  Sics_Common_DataModuleClientConnection,
  udmPlayListManager,
  Sics_Common_Parametros,
  MyAspFuncoesUteis_VCL, SicsTV_Parametros;

{$R *.dfm}

const
  STX = Chr(02);
  ETX = Chr(03);
  TAB = Chr(09);

procedure TfrmSicsTVPrincipal.ModoConectado(const aIdUnidade: Integer);
begin
  //ModoConexaoAtual[aIdUnidade] := true;
end;

procedure TfrmSicsTVPrincipal.ModoDesconectado(const aIdUnidade: Integer);
begin
  //ModoConexaoAtual[aIdUnidade] := false;
end;

function Explode(const Delim, Str: string): TArrString;
var
  i: Integer;
begin
  SetLength(Result, 0);
  with TStringList.Create do
  try
    Text := StringReplace(Str, Delim, #13 + #10, [rfReplaceAll]);
    for i := 0 to Count -1 do
    begin
      SetLength(Result, Length(Result) + 1);
      Result[High(Result)] := Strings[i];
    end;
  finally
    Free;
  end;
end;

{=======================================================}
{ procedures de Mensagens do Windows }
procedure TfrmSicsTVPrincipal.ResponderQueryIfAliveMsg(var Message: TMessage);
begin
  PostMessage(Message.WParam, REPLY_IM_ALIVE_MSG, Handle, 0);
end;

procedure TfrmSicsTVPrincipal.WMDisplayChange(var Msg: TWMDisplayChange);
var
  LWinControl: TWinControl;
  LPanelTV: TPanel;
begin
  if not SoftwarePadraoTV(vgTVComponent.SoftwareHomologado) then
    exit;

  //recupera o Panel em que o software está embutido
  LPanelTV := nil;
  LWinControl := FindControl(vgTVComponent.ParentHandle);
  if Assigned(LWinControl) and (LWinControl is TPanel) then
    LPanelTV := TPanel(LWinControl);

  if not AbrirTVTestandoResolucao(LPanelTV) then
  begin
    FecharSoftwareTV;

    //Reativa o timer que pode ter sido desligado pelo método FecharSoftwareTV;
    tmrTrazerFormParaFrente.Enabled := True;
  end;
end;

procedure TfrmSicsTVPrincipal.WMPlayStateChange(ASender: TObject; NewState: Integer);
var LTimer: TTimer;
    LPanel: TJvPanel;
begin
  if (NewState = 3) then
  begin
    LPanel := TJvPanel(TControl(ASender).Parent);
    LTimer := TTimer(LPanel.FindComponent('TimerPlayList'+ TComponent(ASender).Tag.ToString));
    LTimer.Enabled := True;

    LPanel.Width := LPanel.Width+1;
    LPanel.Width := LPanel.Width-1;
  end;
end;

{=======================================================}

procedure TfrmSicsTVPrincipal.MyExceptionHandler (Sender: TObject; E: Exception);
begin
  MyLogException(E);
end;  { proc MyExceptionHandler }

{=======================================================}
{ procedures de manipulação do HTML }

procedure TfrmSicsTVPrincipal.WebBrowserLoadHTML(WebBrowser: TWebBrowser; HTMLCode: string) ;
var
   sl : TStringList;
   ms : TMemoryStream;
begin
  WebBrowser.Navigate('about:blank') ;
  while WebBrowser.ReadyState < READYSTATE_INTERACTIVE do
    Application.ProcessMessages;

  if Assigned(WebBrowser.Document) then
  begin
    sl := TStringList.Create;
    try
      ms := TMemoryStream.Create;
      try
        sl.Text := HTMLCode;
        sl.SaveToStream(ms) ;
        ms.Seek(0, 0) ;
        (WebBrowser.Document as IPersistStreamInit).Load(TStreamAdapter.Create(ms)) ;
      finally
        ms.Free;
      end;
    finally
      sl.Free;
    end;
  end;
end;

procedure TfrmSicsTVPrincipal.WebBrowserOnDocumentComplete(ASender: TObject; const pDisp: IDispatch; const URL: OleVariant); //Para remover ScrollBars após carregar HTML
var
  Doc: IHTMLDocument2;
  body: OleVariant;
begin
  Doc := IHTMLDocument2((ASender as TWebBrowser).Document);
  body := Doc.Body;

  {hide scrollbars}
  body.Style.BorderStyle := 'none';
  body.Scroll := 'no';
end;

{=======================================================}

function TfrmSicsTVPrincipal.EstaNoHorarioDeFuncionamento : boolean;
begin
  Result := True;

  if (vgParametrosModulo.JaEstaConfigurado) and (MinutesBetween(vgHorarioDeFuncionamento.DesdeHoras, vgHorarioDeFuncionamento.AteHoras)>0) then
    Result := ((Time >= vgHorarioDeFuncionamento.DesdeHoras)                        and
               (Time <= vgHorarioDeFuncionamento.AteHoras  )                        and
               (vgHorarioDeFuncionamento.FuncionaSabado  or (DayOfWeek(now) <> 7))  and
               (vgHorarioDeFuncionamento.FuncionaDomingo or (DayOfWeek(now) <> 1)));
end;

procedure TfrmSicsTVPrincipal.EventoTimePlayList(Sender: TObject);
begin
  TTimer(Sender).Enabled := False;
  ExecutarPlayList(vgTVPlayListManager.Panel, TComponent(Sender).Tag);
end;

function TfrmSicsTVPrincipal.ResolucaoEstaCorreta: Boolean;
begin
  if not vgResolucaoPadrao.Valida then
    exit(True);

  result := (vgResolucaoPadrao.Width = Screen.Width) and

            (vgResolucaoPadrao.Height = Screen.Height);
end;

function TfrmSicsTVPrincipal.AbrirAplicativoTV: Boolean;
var
  SEInfo: TShellExecuteInfo;
begin
  vgTVComponent.AppHandle := FindWindowEx(vgTVComponent.ParentHandle, 0, nil, PChar(vgTVComponent.NomeDaJanela));
  if (vgTVComponent.AppHandle = 0) then
  begin
    if vgTVComponent.SoftwareHomologado = 1 then
      SetarVolumePadraoAverTV;

    FillChar(SEInfo, SizeOf(SEInfo), 0) ;
    SEInfo.cbSize := SizeOf(TShellExecuteInfo) ;
    with SEInfo do
    begin
      fMask := SEE_MASK_NOCLOSEPROCESS;
      Wnd := vgTVComponent.ParentHandle;

      if vgTVComponent.SoftwareHomologado <> 5 then
        lpFile := PChar(vgTVComponent.CaminhoDoExecutavel)
      else
        lpFile := PChar( FPathSicsLiveTV + vgTVComponent.CaminhoDoExecutavel);

      nShow := SW_SHOW;
    end;
    result := ShellExecuteEx(@SEInfo);
  end;
end;

function TfrmSicsTVPrincipal.AbrirTVTestandoResolucao(LPanel: TPanel): Boolean;
begin
  result := False;
  if ResolucaoEstaCorreta then
  begin
    if AbrirAplicativoTV then
      result := True
    else
    begin
      if Assigned(LPanel) then
        LPanel.Caption := 'Falha ao abrir aplicação de TV';
    end;
  end
  else
    if Assigned(LPanel) then
      LPanel.Caption := 'A resolução deve ser "' + vgResolucaoPadrao + '" para iniciar a TV.';
end;

procedure TfrmSicsTVPrincipal.AjustarTVVolumeOuCanal(pTipoAjuste: TTipoAjuste;  pValorAjuste: TValorAjuste);
begin
  if vgTVComponent.ParentHandle > 0 then
  begin
    vgTVComponent.AppHandle := FindWindowEx(vgTVComponent.ParentHandle, 0, nil, PChar(vgTVComponent.NomeDaJanela));
    if (vgTVComponent.AppHandle > 0) then
    begin
      if vgTVComponent.SoftwareHomologado <> 4 then
      begin
        case pTipoAjuste of
          taCanal:  begin
                      if vgTVComponent.SoftwareHomologado = 5 then
                      begin
                        SetForegroundWindow(vgTVComponent.AppHandle);
                        MudarCanalVolumeSichboPVR(pTipoAjuste,pValorAjuste);
                      end
                      else
                      begin
                        case pValorAjuste of
                          vaSubir:  PostMessage(vgTVComponent.AppHandle,WM_KEYDOWN,VK_UP,0);   //Tecla Seta para Cima
                          vaDescer: PostMessage(vgTVComponent.AppHandle,WM_KEYDOWN,VK_DOWN,0); //Tecla Seta para Baixo
                        end;
                      end;
                    end;

          taVolume: begin
                      if vgTVComponent.SoftwareHomologado <> 5 then
                      begin
                        case pValorAjuste of
                          vaSubir:  PostMessage(vgTVComponent.AppHandle,WM_KEYDOWN,VK_ADD,0);      //Tecla +
                          vaDescer: PostMessage(vgTVComponent.AppHandle,WM_KEYDOWN,VK_SUBTRACT,0); //Tecla -
                        end;
                      end
                      else
                      begin
                        SetForegroundWindow(vgTVComponent.AppHandle);
                        MudarCanalVolumeSichboPVR(pTipoAjuste,pValorAjuste);
                      end;
                    end;
          taClosedCaption: begin
                             if vgTVComponent.SoftwareHomologado = 5 then
                             begin
                               keybd_event(VK_F2, 0, 0, 0);
                               keybd_event(VK_F2, 0, KEYEVENTF_KEYUP, 0);
                             end;
                           end;
        end;
      end
      else
      begin
        if pTipoAjuste = taVolume then
        begin
          if Assigned(VFVideoCapture) then
          begin
            case pValorAjuste of
              vaSubir:  LVolume := LVolume + 100;
              vaDescer: LVolume := LVolume - 100;
            end;
            VFVideoCapture.Audio_OutputDevice_SetVolume((LVolume));
            SetVolumeIni(LVolume);
          end;
        end;
      end;
    end;
  end;
end;

{=======================================================}
{ procedures de carregamento e salvamento em arquivo }

procedure TfrmSicsTVPrincipal.LimparPainelTV;
begin
  FecharSoftwareTV;
  vgTVComponent.ParentHandle       := 0;
  vgTVComponent.SoftwareHomologado := -1;
  vgTVComponent.PanelVideo         := nil;
  vgTVComponent.Panel              := nil;
end;

procedure TfrmSicsTVPrincipal.LoadPanel (no : integer);
var
  IniFile              : TIniFile        ;
  Panel,PanelVideo     : TJvPanel        ;
  Image                : TJvImage        ;
  Flash                : TShockwaveFlash ;
  MediaPlayer          : TMediaPlayer    ;
  ArrDados             : TArrString      ;
  ListaVideos          : TListBox        ;
  i                    : Integer         ;
  LTimer               : TTimer;
begin
  SetLength(ArrDados, 0);

  IniFile := TIniFile.Create(GetAppIniFileName);
  with IniFile do
  try
    Panel   := FindComponent('Panel'+inttostr(no)) as TJvPanel;
    if Panel <> nil then
    begin

      with Panel do
      begin
        Hint        :=        IntToStr(vgParametrosModulo.Paineis[no].Tipo); //ReadString ('Panel'+inttostr(no), 'Tipo'        , '1'   );
        Left        :=        vgParametrosModulo.Paineis[no].Left; //ReadInteger('Panel'+inttostr(no), 'Left'        , 0     );
        Top         :=        vgParametrosModulo.Paineis[no].Top; //ReadInteger('Panel'+inttostr(no), 'Top'         , 0     );
        Height      :=        vgParametrosModulo.Paineis[no].Height; //ReadInteger('Panel'+inttostr(no), 'Height'      , 0     );
        Width       :=        vgParametrosModulo.Paineis[no].Width; //ReadInteger('Panel'+inttostr(no), 'Width'       , 0     );
        Color       := TColor(vgParametrosModulo.Paineis[no].Color); // ReadInteger('Panel'+inttostr(no), 'Color'       , 0     )
        Transparent :=        vgParametrosModulo.Paineis[no].Transparente; //ReadBool   ('Panel'+inttostr(no), 'Transparent' , false );
      end;

      Image := (Panel.FindComponent('BackgroundImage'+inttostr(no))) as TJvImage;
      if Image <> nil then
        with Image do
        begin
          Hint := vgParametrosModulo.Paineis[no].BackgroundFile; //ReadString('Panel'+inttostr(no), 'BackgroundFile' , '');
          if Hint <> '' then
          begin
            if FileExists (Hint) then
              Picture.LoadFromFile(Hint);
          end
          else
            Visible := false;
        end;

      case TTipoDePainel(strtoint(Panel.Hint)) of
        tpChamadaSenha        : begin
                                   Panel.Font.Name  :=        vgParametrosModulo.Paineis[no].Fonte; //ReadString  ('Panel'+inttostr(no), 'Fonte'     , 'Arial'     ) ;
                                   Panel.Font.Size  :=        vgParametrosModulo.Paineis[no].FonteSize; // ReadInteger ('Panel'+inttostr(no), 'FonteSize' , 12          ) ;
                                   Panel.Font.Color := TColor(vgParametrosModulo.Paineis[no].FonteColor); //ReadInteger ('Panel'+inttostr(no), 'FonteColor', ord(clBlack))
                                   Panel.Font.Style := [];
                                   if vgParametrosModulo.Paineis[no].Negrito then //ReadBool ('Panel'+inttostr(no), 'Negrito'    , false    )
                                     Panel.Font.Style := Panel.Font.Style + [fsBold];
                                   if vgParametrosModulo.Paineis[no].Italico then //ReadBool ('Panel'+inttostr(no), 'Italico'    , false    )
                                     Panel.Font.Style := Panel.Font.Style + [fsItalic];
                                   if vgParametrosModulo.Paineis[no].Sublinhado then //ReadBool ('Panel'+inttostr(no), 'Sublinhado' , false    )
                                     Panel.Font.Style := Panel.Font.Style + [fsUnderline];

                                   MediaPlayer := (Panel.FindComponent ('MediaPlayer'+inttostr(no))) as TMediaPlayer;
                                   if ((MediaPlayer <> nil) and (waveOutGetNumDevs > 0)) then
                                   begin
                                     if FileExists(vgParametrosModulo.Paineis[no].ArquivoSom) then //ReadString('Panel'+inttostr(no), 'ArquivoSom' , '')
                                       MediaPlayer.FileName := vgParametrosModulo.Paineis[no].ArquivoSom; //ReadString('Panel'+inttostr(no), 'ArquivoSom' , '')
                                   end;
                                 end;

        tpUltimasSenhas        : begin
                                   Panel.Font.Name  :=        vgParametrosModulo.Paineis[no].Fonte; //ReadString  ('Panel'+inttostr(no), 'Fonte'     , 'Arial'     ) ;
                                   Panel.Font.Size  :=        vgParametrosModulo.Paineis[no].FonteSize; //ReadInteger ('Panel'+inttostr(no), 'FonteSize' , 12          ) ;
                                   Panel.Font.Color := TColor(vgParametrosModulo.Paineis[no].FonteColor); //ReadInteger ('Panel'+inttostr(no), 'FonteColor', ord(clBlack))
                                   Panel.Font.Style := [];
                                   if vgParametrosModulo.Paineis[no].Negrito then //ReadBool ('Panel'+inttostr(no), 'Negrito'    , false    )
                                     Panel.Font.Style := Panel.Font.Style + [fsBold];
                                   if vgParametrosModulo.Paineis[no].Italico then //ReadBool ('Panel'+inttostr(no), 'Italico'    , false    )
                                     Panel.Font.Style := Panel.Font.Style + [fsItalic];
                                   if vgParametrosModulo.Paineis[no].Sublinhado then //ReadBool ('Panel'+inttostr(no), 'Sublinhado' , false    )
                                     Panel.Font.Style := Panel.Font.Style + [fsUnderline];
                                 end;

        tpFlash                : begin
                                   Flash := (Panel.FindComponent ('Flash'+inttostr(no))) as TShockwaveFlash;
                                   if Flash <> nil then
                                   begin
                                     if FileExists(vgParametrosModulo.Paineis[no].FlashFile) then  //ReadString('Panel'+inttostr(no), 'FlashFile' , '')
                                     begin
                                       Flash.BGColor := '';
                                       Flash.Movie := vgParametrosModulo.Paineis[no].FlashFile; // ReadString('Panel'+inttostr(no), 'FlashFile' , '');
                                       Flash.Play;
                                     end;
                                     Flash.SetFocus;
                                   end;
                                 end;

        tpDataHora             : begin
                                   Panel.Font.Name  :=        vgParametrosModulo.Paineis[no].Fonte; //ReadString  ('Panel'+inttostr(no), 'Fonte'     , 'Arial'     ) ;
                                   Panel.Font.Size  :=        vgParametrosModulo.Paineis[no].FonteSize; //ReadInteger ('Panel'+inttostr(no), 'FonteSize' , 12          ) ;
                                   Panel.Font.Color := TColor(vgParametrosModulo.Paineis[no].FonteColor); //ReadInteger ('Panel'+inttostr(no), 'FonteColor', ord(clBlack))
                                   Panel.Font.Style := [];
                                   if vgParametrosModulo.Paineis[no].Negrito then //ReadBool ('Panel'+inttostr(no), 'Negrito'    , false    )
                                     Panel.Font.Style := Panel.Font.Style + [fsBold];
                                   if vgParametrosModulo.Paineis[no].Italico then //ReadBool ('Panel'+inttostr(no), 'Italico'    , false    )
                                     Panel.Font.Style := Panel.Font.Style + [fsItalic];
                                   if vgParametrosModulo.Paineis[no].Sublinhado then //ReadBool ('Panel'+inttostr(no), 'Sublinhado' , false    )
                                     Panel.Font.Style := Panel.Font.Style + [fsUnderline];
                                 end;

        tpJornalEletronico     : begin
                                   if vgJornalEletronico <> nil then
                                     vgJornalEletronico.Interval := vgParametrosModulo.Paineis[no].IntervaloVerificacao; //ReadInteger ('Panel'+inttostr(no), 'Interval', 15);
                                   Panel.Font.Name  := vgParametrosModulo.Paineis[no].Fonte; //ReadString('Panel'+inttostr(no), 'Fonte', 'Arial');
                                   Panel.Font.Size  := vgParametrosModulo.Paineis[no].FonteSize; //ReadInteger ('Panel'+inttostr(no), 'FonteSize', 12);
                                   Panel.Font.Color := TColor(vgParametrosModulo.Paineis[no].FonteColor); //ReadInteger ('Panel'+inttostr(no), 'FonteColor', ord(clBlack))
                                   Panel.Font.Style := [];
                                   if vgParametrosModulo.Paineis[no].Negrito then //ReadBool ('Panel'+inttostr(no), 'Negrito', false)
                                     Panel.Font.Style := Panel.Font.Style + [fsBold];
                                   if vgParametrosModulo.Paineis[no].Italico then //ReadBool('Panel'+inttostr(no), 'Italico', false)
                                     Panel.Font.Style := Panel.Font.Style + [fsItalic];
                                   if vgParametrosModulo.Paineis[no].Sublinhado then //ReadBool('Panel'+inttostr(no), 'Sublinhado', false)
                                     Panel.Font.Style := Panel.Font.Style + [fsUnderline];
                                 end;

        tpTV,tpVideo           : begin
                                   if(TTipoDePainel(strtoint(Panel.Hint)) <> tpVideo)then
                                   begin
                                     PanelVideo := FindComponent('PanelVideo'+inttostr(no)) as TJvPanel;
                                     PanelVideo.Hint        := Panel.Hint;
                                     PanelVideo.Left        := Panel.Left;
                                     PanelVideo.Top         := Panel.Top;
                                     PanelVideo.Height      := Panel.Height;
                                     PanelVideo.Width       := Panel.Width;
                                     PanelVideo.Color       := Panel.Color;
                                     PanelVideo.Transparent := Panel.Transparent;
                                     PanelVideo.Visible     := false;

                                     vgTVComponent.SoftwareHomologado  := vgParametrosModulo.Paineis[no].SoftwareHomologado;  //ReadInteger('Panel'+inttostr(no), 'SoftwareHomologado' , -1);
                                     vgTVComponent.CaminhoDoExecutavel := vgParametrosModulo.Paineis[no].CaminhoDoExecutavel; //ReadString ('Panel'+inttostr(no), 'CaminhoDoExecutavel', '');
                                     vgTVComponent.NomeDaJanela        := vgParametrosModulo.Paineis[no].NomeDaJanela;        //ReadString ('Panel'+inttostr(no), 'NomeDaJanela'       , '');
                                     vgTVComponent.Dispositivo         := vgParametrosModulo.Paineis[no].Dispositivo;         //ReadInteger('Panel'+inttostr(no), 'Dispositivo'        , -1);
                                     vgTVComponent.Resolucao           := vgParametrosModulo.Paineis[no].Resolucao;           //ReadInteger('Panel'+inttostr(no), 'Resolucao'          , -1);
                                     vgResolucaoPadrao                 := vgParametrosModulo.Paineis[no].ResolucaoPadrao;     //ReadString ('Panel'+inttostr(no), 'ResolucaoPadrao'    , '0x0');
                                     vgTVComponent.TempoAlternancia    := vgParametrosModulo.Paineis[no].TempoAlternancia;    //ReadInteger('Panel'+inttostr(no), 'TempoAlternancia'   ,  0);
                                     vgTVComponent.PanelVideo          := PanelVideo;
                                     vgTVComponent.Panel               := Panel;

                                     if vgTVComponent.SoftwareHomologado = 4 then
                                     begin
                                       CriaVideoCaptura(TPanel(Panel));
                                       with TIniFile.Create(GetAppIniFileName) do
                                       try
                                         //if SectionExists('VisioForge') then
                                           frmSicsProperties.trckVolume.Position := vgParametrosModulo.Volume; // ReadInteger('VisioForge', 'Volume', 800);
                                       finally
                                         Free;
                                       end;
                                     end;

                                     if vgTVComponent.SoftwareHomologado = 6 then
                                     begin
                                       if not Assigned(VideoWindow) then
                                       begin
                                         VideoWindow := TVideoWindow.Create(Panel);

                                         VideoWindow.Parent := Panel;
                                         VideoWindow.Align := alClient;
                                         VideoWindow.FilterGraph := FilterGraph;

                                         SysDev:= TSysDevEnum.Create(CLSID_VideoInputDeviceCategory);

                                         if SysDev.CountFilters > 0 then
                                           for i := 0 to SysDev.CountFilters - 1 do
                                           begin
                                             if Pos('USB', UpperCase(SysDev.Filters[i].FriendlyName)) > 0 then
                                             begin
                                               FilterGraph.ClearGraph;
                                               FilterGraph.Active := false;
                                               Filter.BaseFilter.Moniker := SysDev.GetMoniker(i);
                                               FilterGraph.Active := true;

                                               with FilterGraph as ICaptureGraphBuilder2 do
                                                 RenderStream(@PIN_CATEGORY_PREVIEW, nil, Filter as IBaseFilter, SampleGrabber as IBaseFilter, VideoWindow as IbaseFilter);

                                               Application.ProcessMessages;
                                               FilterGraph.Stop;
                                               FilterGraph.Play;

                                               Break;
                                             end;
                                           end;
                                       end;
                                     end;

                                     if SoftwarePadraoTV(vgTVComponent.SoftwareHomologado) then
                                       AbrirTVTestandoResolucao(TPanel(Panel));
                                   end;

                                   ListaVideos := TListBox(Panel.FindComponent('lstVideos' + IntToStr(No)));
                                   if((not Assigned(ListaVideos)) and Assigned(PanelVideo) )then
                                    ListaVideos := TListBox(PanelVideo.FindComponent('lstVideos' + IntToStr(No)));
                                   if(ListaVideos <> nil)then
                                   begin                                     //ReadString('Panel'+inttostr(No), 'ArquivosVideo' , '')
                                     ListaVideos.Items.Text := StringReplace(vgParametrosModulo.Paineis[no].ArquivosVideo, '|', #13 + #10, [rfReplaceAll]);

                                     if( ListaVideos.Items.Count > 0 )then
                                     begin
                                       ListaVideos.ItemIndex := 0;
                                       if(TTipoDePainel(strtoint(Panel.Hint)) = tpVideo)then
                                         ExecutarVideo(No)
                                       else if(vgTVComponent.TempoAlternancia <> 0)then
                                       begin
                                         tmrAlternaTVVideo.Interval := vgTVComponent.TempoAlternancia * 60000;
                                         tmrAlternaTVVideo.Enabled := true;
                                       end;
                                     end;

                                   end;
                                 end;

        tpIndicadorPerformance : begin
                                   //nenhuma configuração a carregar. Opções são
                                   //carregadas quando renderiza o HTML de acordo com os PIs
                                 end;

             tpPlayListManager : begin
                                   if(TTipoDePainel(strtoint(Panel.Hint)) = tpPlayListManager)then
                                   begin
                                     vgTVPlayListManager.IDTV                 := vgParametrosModulo.Paineis[no].IDTVPlayListManager;  //IniFile.ReadInteger ('Panel'+inttostr(no), 'IDTVPlayListManager', 0);
                                     vgTVPlayListManager.TipoBanco            := vgParametrosModulo.Paineis[no].TipoBanco;            //IniFile.ReadInteger ('Panel'+inttostr(no), 'TipoBanco', 0);
                                     vgTVPlayListManager.HostBanco            := vgParametrosModulo.Paineis[no].HostBanco;            //IniFile.ReadString  ('Panel'+inttostr(no), 'HostBanco', '');
                                     vgTVPlayListManager.PortaBanco           := vgParametrosModulo.Paineis[no].PortaBanco;           //IniFile.ReadString  ('Panel'+inttostr(no), 'PortaBanco', '');
                                     vgTVPlayListManager.NomeArquivoBanco     := vgParametrosModulo.Paineis[no].NomeArquivoBanco;     //IniFile.ReadString  ('Panel'+inttostr(no), 'NomeArquivoBanco', '');
                                     vgTVPlayListManager.UsuarioBanco         := vgParametrosModulo.Paineis[no].UsuarioBanco;         //IniFile.ReadString  ('Panel'+inttostr(no), 'UsuarioBanco', '');
                                     vgTVPlayListManager.SenhaBanco           := vgParametrosModulo.Paineis[no].SenhaBanco;           //IniFile.ReadString  ('Panel'+inttostr(no), 'SenhaBanco', '');
                                     vgTVPlayListManager.DiretorioLocal       := vgParametrosModulo.Paineis[no].DiretorioLocal;       //IniFile.ReadString  ('Panel'+inttostr(no), 'DiretorioLocal', '');
                                     vgTVPlayListManager.IntervaloVerificacao := vgParametrosModulo.Paineis[no].IntervaloVerificacao; //IniFile.ReadInteger ('Panel'+inttostr(no), 'IntervaloVerificacao', 60000);
                                     vgTVPlayListManager.AtualizacaoPlayList  := vgParametrosModulo.Paineis[no].AtualizacaoPlaylist;  //IniFile.ReadDateTime('Panel'+inttostr(no), 'AtualizacaoPlayList', Now);
                                     vgTVPlayListManager.PanelVideo           := PanelVideo;
                                     vgTVPlayListManager.Panel                := Panel;

                                     if ( ((vgTVPlayListManager.NomeArquivoBanco <> EmptyStr) ) and (vgTVPlayListManager.UsuarioBanco <> EmptyStr)) then
                                     begin
                                       if not Assigned(DMPlayListManager) then
                                       begin
                                         DMPlayListManager := TDMPlayListManager.Create(Self);
                                         DMPlayListManager.ProcSetImageAtualizandoPlaylist := IniciarAtualizacaoPlaylistManager;
                                         DMPlayListManager.ProcFinalizarAtualizacaoPlaylist := FinalizarAtualizacaoPlaylistManager;
                                         if Assigned(Panel) then
                                           DMPlayListManager.FPanel := Panel;
                                       end;

                                       if DMPlayListManager.ConectarDBPlaylist then
                                       begin
                                         LTimer := TTimer(Panel.FindComponent('TimerPlayList'+IntToStr(No)));
                                         LTimer.Interval := 1000;
                                         LTimer.Enabled := True;
                                       end;
                                     end;
                                   end;
                                 end;
      end;  { case }

    end;
  finally
    Free;
  end;  { try .. finally }
end;

procedure TfrmSicsTVPrincipal.SavePanel (no : integer);
var
  IniFile : TIniFile;
  Panel   : TJvPanel;
  Image   : TJvImage;
  Flash   : TShockwaveFlash;
  sArquivos: string;
  i        : Integer;
  ChamadaPorVoz : TTipoChamadaPorVoz;
begin
  IniFile := TIniFile.Create(GetAppIniFileName);
  Panel   := FindComponent('Panel'+inttostr(no)) as TJvPanel;
  if Panel <> nil then
    with IniFile do
    try
      //EraseSection('Panel'+inttostr(no));
      with Panel do
      begin
        vgParametrosModulo.Paineis[no].Tipo           := StrToIntDef(Hint, 0); //WriteString ('Panel'+inttostr(no), 'Tipo'        , Hint        );
        vgParametrosModulo.Paineis[no].Left           := Left;                 //WriteInteger('Panel'+inttostr(no), 'Left'        , Left        );
        vgParametrosModulo.Paineis[no].Top            := Top;                  //WriteInteger('Panel'+inttostr(no), 'Top'         , Top         );
        vgParametrosModulo.Paineis[no].Height         := Height;               //WriteInteger('Panel'+inttostr(no), 'Height'      , Height      );
        vgParametrosModulo.Paineis[no].Width          := Width;                //WriteInteger('Panel'+inttostr(no), 'Width'       , Width       );
        vgParametrosModulo.Paineis[no].Color          := ord(Color);           //WriteInteger('Panel'+inttostr(no), 'Color'       , ord(Color)  );
        vgParametrosModulo.Paineis[no].Transparente   := Transparent;          //WriteBool   ('Panel'+inttostr(no), 'Transparent' , Transparent );
        vgParametrosModulo.Paineis[no].BackgroundFile := frmSicsProperties.edBackgroundImage.FileName;
      end;

      Image := (Panel.FindComponent('BackgroundImage'+inttostr(no))) as TJvImage;
      if Image <> nil then
        with Image do
        begin
          //WriteString('Panel'+inttostr(no), 'BackgroundFile', Hint);
        end;

      case TTipoDePainel(strtoint(Panel.Hint)) of
        tpChamadaSenha         : begin
                                   vgParametrosModulo.Paineis[no].Fonte                 := Panel.Font.Name;                                                      //WriteString  ('Panel'+inttostr(no), 'Fonte'                 , Panel.Font.Name                                                       );
                                   vgParametrosModulo.Paineis[no].FonteSize             := Panel.Font.Size;                                                      //WriteInteger ('Panel'+inttostr(no), 'FonteSize'             , Panel.Font.Size                                                       );
                                   vgParametrosModulo.Paineis[no].FonteColor            := ord(Panel.Font.Color);                                                //WriteInteger ('Panel'+inttostr(no), 'FonteColor'            , ord(Panel.Font.Color)                                                 );
                                   vgParametrosModulo.Paineis[no].Negrito               := fsBold      in Panel.Font.Style;                                      //WriteBool    ('Panel'+inttostr(no), 'Negrito'               , fsBold      in Panel.Font.Style                                       );
                                   vgParametrosModulo.Paineis[no].Italico               := fsItalic    in Panel.Font.Style;                                      //WriteBool    ('Panel'+inttostr(no), 'Italico'               , fsItalic    in Panel.Font.Style                                       );
                                   vgParametrosModulo.Paineis[no].Sublinhado            := fsUnderline in Panel.Font.Style;                                      //WriteBool    ('Panel'+inttostr(no), 'Sublinhado'            , fsUnderline in Panel.Font.Style                                       );
                                   vgParametrosModulo.Paineis[no].MostrarSenha          := frmSicsProperties.chkChamadaDeSenhasLayoutMostrarSenha.Checked;       //WriteBool    ('Panel'+inttostr(no), 'MostrarSenha'          , frmSicsProperties.chkChamadaDeSenhasLayoutMostrarSenha       .Checked );
                                   vgParametrosModulo.Paineis[no].LayoutSenhaX          := StrToIntDef(frmSicsProperties.edChamadaDeSenhasLayoutSenhaX.Text, 0); //WriteString  ('Panel'+inttostr(no), 'LayoutSenhaX'          , frmSicsProperties.edChamadaDeSenhasLayoutSenhaX              .Text    );
                                   vgParametrosModulo.Paineis[no].LayoutSenhaY          := StrToIntDef(frmSicsProperties.edChamadaDeSenhasLayoutSenhaY.Text, 0);                 //WriteString  ('Panel'+inttostr(no), 'LayoutSenhaY'          , frmSicsProperties.edChamadaDeSenhasLayoutSenhaY              .Text    );
                                   vgParametrosModulo.Paineis[no].LayoutSenhaLARG       := StrToIntDef(frmSicsProperties.edChamadaDeSenhasLayoutSenhaLarg.Text, 0);              //WriteString  ('Panel'+inttostr(no), 'LayoutSenhaLarg'       , frmSicsProperties.edChamadaDeSenhasLayoutSenhaLarg           .Text    );
                                   vgParametrosModulo.Paineis[no].LayoutSenhaAlt        := StrToIntDef(frmSicsProperties.edChamadaDeSenhasLayoutSenhaAlt.Text, 0);               //WriteString  ('Panel'+inttostr(no), 'LayoutSenhaAlt'        , frmSicsProperties.edChamadaDeSenhasLayoutSenhaAlt            .Text    );
                                   vgParametrosModulo.Paineis[no].MostrarPA             := frmSicsProperties.chkChamadaDeSenhasLayoutMostrarPA.Checked;          //WriteBool    ('Panel'+inttostr(no), 'MostrarPA'             , frmSicsProperties.chkChamadaDeSenhasLayoutMostrarPA          .Checked );
                                   vgParametrosModulo.Paineis[no].LayoutPAX             := StrToIntDef(frmSicsProperties.edChamadaDeSenhasLayoutPAX.Text, 0);                    //WriteString  ('Panel'+inttostr(no), 'LayoutPAX'             , frmSicsProperties.edChamadaDeSenhasLayoutPAX                 .Text    );
                                   vgParametrosModulo.Paineis[no].LayoutPAY             := StrToIntDef(frmSicsProperties.edChamadaDeSenhasLayoutPAY.Text, 0);                    //WriteString  ('Panel'+inttostr(no), 'LayoutPAY'             , frmSicsProperties.edChamadaDeSenhasLayoutPAY                 .Text    );
                                   vgParametrosModulo.Paineis[no].LayoutPALarg          := StrToIntDef(frmSicsProperties.edChamadaDeSenhasLayoutPALarg.Text, 0);                 //WriteString  ('Panel'+inttostr(no), 'LayoutPALarg'          , frmSicsProperties.edChamadaDeSenhasLayoutPALarg              .Text    );
                                   vgParametrosModulo.Paineis[no].LayoutPAAlt           := StrToIntDef(frmSicsProperties.edChamadaDeSenhasLayoutPAAlt.Text, 0);                  //WriteString  ('Panel'+inttostr(no), 'LayoutPAAlt'           , frmSicsProperties.edChamadaDeSenhasLayoutPAAlt               .Text    );
                                   vgParametrosModulo.Paineis[no].MostrarNomeCliente    := frmSicsProperties.chkChamadaDeSenhasLayoutMostrarNomeCliente.Checked; //WriteBool    ('Panel'+inttostr(no), 'MostrarNomeCliente'    , frmSicsProperties.chkChamadaDeSenhasLayoutMostrarNomeCliente .Checked );
                                   vgParametrosModulo.Paineis[no].LayoutNomeClienteX    := StrToIntDef(frmSicsProperties.edChamadaDeSenhasLayoutNomeClienteX.Text, 0);           //WriteString  ('Panel'+inttostr(no), 'LayoutNomeClienteX'    , frmSicsProperties.edChamadaDeSenhasLayoutNomeClienteX        .Text    );
                                   vgParametrosModulo.Paineis[no].LayoutNomeClienteY    := StrToIntDef(frmSicsProperties.edChamadaDeSenhasLayoutNomeClienteY.Text, 0);           //WriteString  ('Panel'+inttostr(no), 'LayoutNomeClienteY'    , frmSicsProperties.edChamadaDeSenhasLayoutNomeClienteY        .Text    );
                                   vgParametrosModulo.Paineis[no].LayoutNomeClienteLarg := StrToIntDef(frmSicsProperties.edChamadaDeSenhasLayoutNomeClienteLarg.Text, 0);        //WriteString  ('Panel'+inttostr(no), 'LayoutNomeClienteLarg' , frmSicsProperties.edChamadaDeSenhasLayoutNomeClienteLarg     .Text    );
                                   vgParametrosModulo.Paineis[no].LayoutNomeClienteAlt  := StrToIntDef(frmSicsProperties.edChamadaDeSenhasLayoutNomeClienteAlt.Text, 0);         //WriteString  ('Panel'+inttostr(no), 'LayoutNomeClienteAlt'  , frmSicsProperties.edChamadaDeSenhasLayoutNomeClienteAlt      .Text    );
                                   vgParametrosModulo.Paineis[no].ArquivoSom            := frmSicsProperties.edChamadaSenhasSoundFileName.Text;                  //WriteString  ('Panel'+inttostr(no), 'ArquivoSom'            , frmSicsProperties.edChamadaSenhasSoundFileName               .Text    );
                                   vgParametrosModulo.Paineis[no].PASPermitidas         := frmSicsProperties.edChamadaSenhasPASPermitidas.Text;                  //WriteString  ('Panel'+inttostr(no), 'PASPermitidas'         , frmSicsProperties.edChamadaSenhasPASPermitidas               .Text    );

                                   //GOT inicio
                                   vgParametrosModulo.Paineis[no].SomArquivo            := frmSicsProperties.chkArquivo.Checked;                                 //WriteBool    ('Panel'+inttostr(no), 'SomArquivo'            , frmSicsProperties.chkArquivo                                 .Checked );
                                   vgParametrosModulo.Paineis[no].SomVoz                := frmSicsProperties.chkVoz.Checked;                                     //WriteBool    ('Panel'+inttostr(no), 'SomVoz'                , frmSicsProperties.chkVoz                                     .Checked );

                                   //for ChamadaPorVoz := low(TTipoChamadaPorVoz) to high(TTipoChamadaPorVoz) do
                                     vgParametrosModulo.Paineis[no].SomVozChamada0      := ord (ChamadaPorVoz); //WriteInteger ('Panel'+inttostr(no), 'SomVozChamada' + inttostr(frmSicsProperties.lstVozChamada.Items.IndexOf(TTipoChamadaPorVozStr[ChamadaPorVoz])) , ord (ChamadaPorVoz));
                                     vgParametrosModulo.Paineis[no].SomVozChamada1      := ord (ChamadaPorVoz); //WriteInteger ('Panel'+inttostr(no), 'SomVozChamada' + inttostr(frmSicsProperties.lstVozChamada.Items.IndexOf(TTipoChamadaPorVozStr[ChamadaPorVoz])) , ord (ChamadaPorVoz));
                                     vgParametrosModulo.Paineis[no].SomVozChamada2      := ord (ChamadaPorVoz); //WriteInteger ('Panel'+inttostr(no), 'SomVozChamada' + inttostr(frmSicsProperties.lstVozChamada.Items.IndexOf(TTipoChamadaPorVozStr[ChamadaPorVoz])) , ord (ChamadaPorVoz));

                                   vgParametrosModulo.Paineis[no].SomVozChamada1Marcado := frmSicsProperties.lstVozChamada.Checked[0]; //WriteBool    ('Panel'+inttostr(no), 'SomVozChamada1Marcado' , frmSicsProperties.lstVozChamada.Checked[0]);
                                   vgParametrosModulo.Paineis[no].SomVozChamada2Marcado := frmSicsProperties.lstVozChamada.Checked[1]; //WriteBool    ('Panel'+inttostr(no), 'SomVozChamada2Marcado' , frmSicsProperties.lstVozChamada.Checked[1]);
                                   vgParametrosModulo.Paineis[no].SomVozChamada3Marcado := frmSicsProperties.lstVozChamada.Checked[2]; //WriteBool    ('Panel'+inttostr(no), 'SomVozChamada3Marcado' , frmSicsProperties.lstVozChamada.Checked[2]);

                                   if not ValueExists('Panel'+inttostr(no),'VoiceIndex') then
                                     vgParametrosModulo.Paineis[no].VoiceIndex := 0;//WriteInteger    ('Panel'+inttostr(no), 'VoiceIndex' , 0);

                                   //GOT fim

                                   if frmSicsProperties.btnChamadaDeSenhasLayoutSenhaAlinhaEsquerda.Down then
                                     vgParametrosModulo.Paineis[no].LayoutSenhaAlinhamento := 0 //WriteInteger  ('Panel'+inttostr(no), 'LayoutSenhaAlinhamento', 0)
                                   else if frmSicsProperties.btnChamadaDeSenhasLayoutSenhaAlinhaCentro.Down then
                                     vgParametrosModulo.Paineis[no].LayoutSenhaAlinhamento := 1//WriteInteger  ('Panel'+inttostr(no), 'LayoutSenhaAlinhamento', 1)
                                   else
                                     vgParametrosModulo.Paineis[no].LayoutSenhaAlinhamento := 2;//WriteInteger  ('Panel'+inttostr(no), 'LayoutSenhaAlinhamento', 2);

                                   if frmSicsProperties.btnChamadaDeSenhasLayoutPAAlinhaEsquerda.Down then
                                     vgParametrosModulo.Paineis[no].LayoutPAAlinhamento := 0  //WriteInteger  ('Panel'+inttostr(no), 'LayoutPAAlinhamento', 0)
                                   else if frmSicsProperties.btnChamadaDeSenhasLayoutPAAlinhaCentro.Down then
                                     vgParametrosModulo.Paineis[no].LayoutPAAlinhamento := 1  //WriteInteger  ('Panel'+inttostr(no), 'LayoutPAAlinhamento', 1)
                                   else
                                     vgParametrosModulo.Paineis[no].LayoutPAAlinhamento := 2; //WriteInteger  ('Panel'+inttostr(no), 'LayoutPAAlinhamento', 2);

                                   if frmSicsProperties.btnChamadaDeSenhasLayoutNomeClienteAlinhaEsquerda.Down then
                                     vgParametrosModulo.Paineis[no].LayoutNomeClienteAlinhamento := 0  //WriteInteger  ('Panel'+inttostr(no), 'LayoutNomeClienteAlinhamento', 0)
                                   else if frmSicsProperties.btnChamadaDeSenhasLayoutNomeClienteAlinhaCentro.Down then
                                     vgParametrosModulo.Paineis[no].LayoutNomeClienteAlinhamento := 1  //WriteInteger  ('Panel'+inttostr(no), 'LayoutNomeClienteAlinhamento', 1)
                                   else
                                     vgParametrosModulo.Paineis[no].LayoutNomeClienteAlinhamento := 2; //WriteInteger  ('Panel'+inttostr(no), 'LayoutNomeClienteAlinhamento', 2);
                                 end;

        tpUltimasSenhas        : begin
                                   vgParametrosModulo.Paineis[no].Fonte                 := Panel.Font.Name; //WriteString  ('Panel'+inttostr(no), 'Fonte'                 , Panel.Font.Name                                                       );
                                   vgParametrosModulo.Paineis[no].FonteSize             := Panel.Font.Size; //WriteInteger ('Panel'+inttostr(no), 'FonteSize'             , Panel.Font.Size                                                       );
                                   vgParametrosModulo.Paineis[no].FonteColor            := ord(Panel.Font.Color); //WriteInteger ('Panel'+inttostr(no), 'FonteColor'            , ord(Panel.Font.Color)                                                 );
                                   vgParametrosModulo.Paineis[no].Negrito               := fsBold      in Panel.Font.Style; //WriteBool    ('Panel'+inttostr(no), 'Negrito'               , fsBold      in Panel.Font.Style                                       );
                                   vgParametrosModulo.Paineis[no].Italico               := fsItalic    in Panel.Font.Style;//WriteBool    ('Panel'+inttostr(no), 'Italico'               , fsItalic    in Panel.Font.Style                                       );
                                   vgParametrosModulo.Paineis[no].Sublinhado            := fsUnderline in Panel.Font.Style;//WriteBool    ('Panel'+inttostr(no), 'Sublinhado'            , fsUnderline in Panel.Font.Style                                       );
                                   vgParametrosModulo.Paineis[no].MostrarSenha          := frmSicsProperties.chkUltimasChamadasLayoutMostrarSenha.Checked;//WriteBool    ('Panel'+inttostr(no), 'MostrarSenha'          , frmSicsProperties.chkUltimasChamadasLayoutMostrarSenha       .Checked );
                                   vgParametrosModulo.Paineis[no].LayoutSenhaX          := StrToIntDef(frmSicsProperties.edUltimasChamadasLayoutSenhaX.Text, 0);//WriteString  ('Panel'+inttostr(no), 'LayoutSenhaX'          , frmSicsProperties.edUltimasChamadasLayoutSenhaX              .Text    );
                                   vgParametrosModulo.Paineis[no].LayoutSenhaY          := StrToIntDef(frmSicsProperties.edUltimasChamadasLayoutSenhaY.Text, 0);//WriteString  ('Panel'+inttostr(no), 'LayoutSenhaY'          , frmSicsProperties.edUltimasChamadasLayoutSenhaY              .Text    );
                                   vgParametrosModulo.Paineis[no].LayoutSenhaLarg       := StrToIntDef(frmSicsProperties.edUltimasChamadasLayoutSenhaLarg.Text, 0);//WriteString  ('Panel'+inttostr(no), 'LayoutSenhaLarg'       , frmSicsProperties.edUltimasChamadasLayoutSenhaLarg           .Text    );
                                   vgParametrosModulo.Paineis[no].LayoutSenhaAlt        := StrToIntDef(frmSicsProperties.edUltimasChamadasLayoutSenhaAlt.Text, 0);//WriteString  ('Panel'+inttostr(no), 'LayoutSenhaAlt'        , frmSicsProperties.edUltimasChamadasLayoutSenhaAlt            .Text    );
                                   vgParametrosModulo.Paineis[no].MostrarPA             := frmSicsProperties.chkUltimasChamadasLayoutMostrarPA.Checked; //WriteBool    ('Panel'+inttostr(no), 'MostrarPA'             , frmSicsProperties.chkUltimasChamadasLayoutMostrarPA          .Checked );
                                   vgParametrosModulo.Paineis[no].LayoutPAX             := StrToIntDef(frmSicsProperties.edUltimasChamadasLayoutPAX.Text, 0);    //WriteString  ('Panel'+inttostr(no), 'LayoutPAX'             , frmSicsProperties.edUltimasChamadasLayoutPAX                 .Text    );
                                   vgParametrosModulo.Paineis[no].LayoutPAY             := StrToIntDef(frmSicsProperties.edUltimasChamadasLayoutPAY.Text, 0);    //WriteString  ('Panel'+inttostr(no), 'LayoutPAY'             , frmSicsProperties.edUltimasChamadasLayoutPAY                 .Text    );
                                   vgParametrosModulo.Paineis[no].LayoutPALarg          := StrToIntDef(frmSicsProperties.edUltimasChamadasLayoutPALarg.Text, 0); //WriteString  ('Panel'+inttostr(no), 'LayoutPALarg'          , frmSicsProperties.edUltimasChamadasLayoutPALarg              .Text    );
                                   vgParametrosModulo.Paineis[no].LayoutPAAlt           := StrToIntDef(frmSicsProperties.edUltimasChamadasLayoutPAAlt.Text, 0);     //WriteString  ('Panel'+inttostr(no), 'LayoutPAAlt'           , frmSicsProperties.edUltimasChamadasLayoutPAAlt               .Text    );
                                   vgParametrosModulo.Paineis[no].MostrarNomeCliente    := frmSicsProperties.chkUltimasChamadasLayoutMostrarNomeCliente.Checked;//WriteBool    ('Panel'+inttostr(no), 'MostrarNomeCliente'    , frmSicsProperties.chkUltimasChamadasLayoutMostrarNomeCliente .Checked );
                                   vgParametrosModulo.Paineis[no].LayoutNomeClienteX    := StrToIntDef(frmSicsProperties.edUltimasChamadasLayoutNomeClienteX.Text, 0); //WriteString  ('Panel'+inttostr(no), 'LayoutNomeClienteX'    , frmSicsProperties.edUltimasChamadasLayoutNomeClienteX        .Text    );
                                   vgParametrosModulo.Paineis[no].LayoutNomeClienteY    := StrToIntDef(frmSicsProperties.edUltimasChamadasLayoutNomeClienteY.Text, 0); //WriteString  ('Panel'+inttostr(no), 'LayoutNomeClienteY'    , frmSicsProperties.edUltimasChamadasLayoutNomeClienteY        .Text    );
                                   vgParametrosModulo.Paineis[no].LayoutNomeClienteLarg := StrToIntDef(frmSicsProperties.edUltimasChamadasLayoutNomeClienteLarg.Text, 0); //WriteString  ('Panel'+inttostr(no), 'LayoutNomeClienteLarg' , frmSicsProperties.edUltimasChamadasLayoutNomeClienteLarg     .Text    );
                                   vgParametrosModulo.Paineis[no].LayoutNomeClienteAlt  := StrToIntDef(frmSicsProperties.edUltimasChamadasLayoutNomeClienteAlt.Text, 0); //WriteString  ('Panel'+inttostr(no), 'LayoutNomeClienteAlt'  , frmSicsProperties.edUltimasChamadasLayoutNomeClienteAlt      .Text    );
                                   vgParametrosModulo.Paineis[no].Quantidade            := frmSicsProperties.edUltimasChamadasQuantidade.Text; //WriteString  ('Panel'+inttostr(no), 'Quantidade'            , frmSicsProperties.edUltimasChamadasQuantidade                .Text    );
                                   vgParametrosModulo.Paineis[no].Atraso                := frmSicsProperties.edUltimasChamadasAtraso.Text; //WriteString  ('Panel'+inttostr(no), 'Atraso'                , frmSicsProperties.edUltimasChamadasAtraso                    .Text    );
                                   vgParametrosModulo.Paineis[no].Espacamento           := frmSicsProperties.edUltimasChamadasEspacamento.Text; //WriteString  ('Panel'+inttostr(no), 'Espacamento'           , frmSicsProperties.edUltimasChamadasEspacamento               .Text    );
                                   vgParametrosModulo.Paineis[no].DisposicaoLinhas      := frmSicsProperties.rbUltimasChamadasDisposicaoEmLinhas.Checked;//WriteBool    ('Panel'+inttostr(no), 'DisposicaoLinhas'      , frmSicsProperties.rbUltimasChamadasDisposicaoEmLinhas        .Checked );
                                   vgParametrosModulo.Paineis[no].PASPermitidas         := frmSicsProperties.edUltimasChamadasPASPermitidas.Text; //WriteString  ('Panel'+inttostr(no), 'PASPermitidas'         , frmSicsProperties.edUltimasChamadasPASPermitidas             .Text    );

                                   if frmSicsProperties.btnUltimasChamadasLayoutSenhaAlinhaEsquerda.Down then
                                     vgParametrosModulo.Paineis[no].LayoutSenhaAlinhamento := 0 //WriteInteger  ('Panel'+inttostr(no), 'LayoutSenhaAlinhamento', 0)
                                   else if frmSicsProperties.btnUltimasChamadasLayoutSenhaAlinhaCentro.Down then
                                     vgParametrosModulo.Paineis[no].LayoutSenhaAlinhamento := 1 //WriteInteger  ('Panel'+inttostr(no), 'LayoutSenhaAlinhamento', 1)
                                   else
                                     vgParametrosModulo.Paineis[no].LayoutSenhaAlinhamento := 2; //WriteInteger  ('Panel'+inttostr(no), 'LayoutSenhaAlinhamento', 2);

                                   if frmSicsProperties.btnUltimasChamadasLayoutPAAlinhaEsquerda.Down then
                                     vgParametrosModulo.Paineis[no].LayoutPAAlinhamento := 0//WriteInteger  ('Panel'+inttostr(no), 'LayoutPAAlinhamento', 0)
                                   else if frmSicsProperties.btnUltimasChamadasLayoutPAAlinhaCentro.Down then
                                     vgParametrosModulo.Paineis[no].LayoutPAAlinhamento := 1//WriteInteger  ('Panel'+inttostr(no), 'LayoutPAAlinhamento', 1)
                                   else
                                     vgParametrosModulo.Paineis[no].LayoutPAAlinhamento := 2;//WriteInteger  ('Panel'+inttostr(no), 'LayoutPAAlinhamento', 2);

                                   if frmSicsProperties.btnUltimasChamadasLayoutNomeClienteAlinhaEsquerda.Down then
                                     vgParametrosModulo.Paineis[no].LayoutNomeClienteAlinhamento := 0//WriteInteger  ('Panel'+inttostr(no), 'LayoutNomeClienteAlinhamento', 0)
                                   else if frmSicsProperties.btnUltimasChamadasLayoutNomeClienteAlinhaCentro.Down then
                                     vgParametrosModulo.Paineis[no].LayoutNomeClienteAlinhamento := 1//WriteInteger  ('Panel'+inttostr(no), 'LayoutNomeClienteAlinhamento', 1)
                                   else
                                     vgParametrosModulo.Paineis[no].LayoutNomeClienteAlinhamento := 2;//WriteInteger  ('Panel'+inttostr(no), 'LayoutNomeClienteAlinhamento', 2);
                                 end;

        tpFlash                : begin
                                   Flash := (Panel.FindComponent ('Flash'+IntToStr(no))) as TShockwaveFlash;
                                   if Flash <> nil then
                                     vgParametrosModulo.Paineis[no].FlashFile := Flash.Movie;//WriteString ('Panel'+inttostr(no), 'FlashFile', Flash.Movie);
                                 end;

        tpDataHora             : begin
                                   vgParametrosModulo.Paineis[no].Fonte          := Panel.Font.Name; //WriteString  ('Panel'+inttostr(no), 'Fonte'          , Panel.Font.Name                              );
                                   vgParametrosModulo.Paineis[no].FonteSize      := Panel.Font.Size; //WriteInteger ('Panel'+inttostr(no), 'FonteSize'      , Panel.Font.Size                              );
                                   vgParametrosModulo.Paineis[no].FonteColor     := ord(Panel.Font.Color); //WriteInteger ('Panel'+inttostr(no), 'FonteColor'     , ord(Panel.Font.Color)                        );
                                   vgParametrosModulo.Paineis[no].Negrito        := fsBold      in Panel.Font.Style; //WriteBool    ('Panel'+inttostr(no), 'Negrito'        , fsBold      in Panel.Font.Style              );
                                   vgParametrosModulo.Paineis[no].Italico        := fsItalic    in Panel.Font.Style; //WriteBool    ('Panel'+inttostr(no), 'Italico'        , fsItalic    in Panel.Font.Style              );
                                   vgParametrosModulo.Paineis[no].Sublinhado     := fsUnderline in Panel.Font.Style; //WriteBool    ('Panel'+inttostr(no), 'Sublinhado'     , fsUnderline in Panel.Font.Style              );
                                   vgParametrosModulo.Paineis[no].MargemSuperior := StrToIntDef(frmSicsProperties.edDataHoraMargemSuperior.Text, 0); //WriteString  ('Panel'+inttostr(no), 'MargemSuperior' , frmSicsProperties.edDataHoraMargemSuperior.Text );
                                   vgParametrosModulo.Paineis[no].MargemInferior := StrToIntDef(frmSicsProperties.edDataHoraMargemInferior.Text, 0); //WriteString  ('Panel'+inttostr(no), 'MargemInferior' , frmSicsProperties.edDataHoraMargemInferior.Text );
                                   vgParametrosModulo.Paineis[no].MargemEsquerda := StrToIntDef(frmSicsProperties.edDataHoraMargemEsquerda.Text, 0); //WriteString  ('Panel'+inttostr(no), 'MargemEsquerda' , frmSicsProperties.edDataHoraMargemEsquerda.Text );
                                   vgParametrosModulo.Paineis[no].MargemDireita  := StrToIntDef(frmSicsProperties.edDataHoraMargemDireita.Text, 0); //WriteString  ('Panel'+inttostr(no), 'MargemDireita'  , frmSicsProperties.edDataHoraMargemDireita .Text );
                                   vgParametrosModulo.Paineis[no].Formato        := frmSicsProperties.edDataHoraFormato.Text;        //WriteString  ('Panel'+inttostr(no), 'Formato'        , frmSicsProperties.edDataHoraFormato.Text        );
                                 end;

        tpJornalEletronico     : begin
                                   if vgJornalEletronico <> nil then
                                     vgParametrosModulo.Paineis[no].IntervaloVerificacao := vgJornalEletronico.Interval; //WriteInteger('Panel'+inttostr(no), 'Interval', vgJornalEletronico.Interval);

                                   vgParametrosModulo.Paineis[no].Fonte      := Panel.Font.Name; //WriteString  ('Panel'+inttostr(no), 'Fonte'           , Panel.Font.Name                                           );
                                   vgParametrosModulo.Paineis[no].FonteSize  := Panel.Font.Size; //WriteInteger ('Panel'+inttostr(no), 'FonteSize'       , Panel.Font.Size                                           );
                                   vgParametrosModulo.Paineis[no].FonteColor := ord(Panel.Font.Color); //WriteInteger ('Panel'+inttostr(no), 'FonteColor'      , ord(Panel.Font.Color)                                     );
                                   vgParametrosModulo.Paineis[no].Negrito    := fsBold      in Panel.Font.Style; //WriteBool    ('Panel'+inttostr(no), 'Negrito'         , fsBold      in Panel.Font.Style                           );
                                   vgParametrosModulo.Paineis[no].Italico    := fsItalic    in Panel.Font.Style; //WriteBool    ('Panel'+inttostr(no), 'Italico'         , fsItalic    in Panel.Font.Style                           );
                                   vgParametrosModulo.Paineis[no].Sublinhado := fsUnderline in Panel.Font.Style; //WriteBool    ('Panel'+inttostr(no), 'Sublinhado'      , fsUnderline in Panel.Font.Style                           );
                                 end;

        tpTV,tpVideo           : begin
                                   if(TTipoDePainel(strtoint(Panel.Hint)) <> tpVideo)then
                                   begin
                                     vgParametrosModulo.Paineis[no].SoftwareHomologado  := vgTVComponent.SoftwareHomologado; //WriteInteger('Panel'+inttostr(no), 'SoftwareHomologado' , vgTVComponent.SoftwareHomologado );
                                     vgParametrosModulo.Paineis[no].CaminhoDoExecutavel := vgTVComponent.CaminhoDoExecutavel; //WriteString ('Panel'+inttostr(no), 'CaminhoDoExecutavel', vgTVComponent.CaminhoDoExecutavel);
                                     vgParametrosModulo.Paineis[no].NomeDaJanela        := vgTVComponent.NomeDaJanela;//WriteString ('Panel'+inttostr(no), 'NomeDaJanela'       , vgTVComponent.NomeDaJanela       );
                                     vgParametrosModulo.Paineis[no].Dispositivo         := vgTVComponent.Dispositivo; //WriteInteger('Panel'+inttostr(no), 'Dispositivo'        , vgTVComponent.Dispositivo        );
                                     vgParametrosModulo.Paineis[no].Resolucao           := vgTVComponent.Resolucao; //WriteInteger('Panel'+inttostr(no), 'Resolucao'          , vgTVComponent.Resolucao          );
                                     vgParametrosModulo.Paineis[no].ResolucaoPadrao     := vgResolucaoPadrao; //WriteString ('Panel'+inttostr(no), 'ResolucaoPadrao'    , vgResolucaoPadrao                );
                                     vgParametrosModulo.Paineis[no].TempoAlternancia    := vgTVComponent.TempoAlternancia; //WriteInteger('Panel'+inttostr(no), 'TempoAlternancia'   , vgTVComponent.TempoAlternancia);
                                   end;

                                   sArquivos := '';
                                   for i := 0 to frmSicsProperties.lstVideoFileNames.Items.Count -1 do
                                   begin
                                     if sArquivos <> '' then
                                       sArquivos := sArquivos + '|';
                                     sArquivos := sArquivos + frmSicsProperties.lstVideoFileNames.Items[i];
                                   end;

                                   vgParametrosModulo.Paineis[no].ArquivosVideo := sArquivos; //WriteString  ('Panel'+inttostr(no), 'ArquivosVideo', sArquivos);
                                 end;

        tpIndicadorPerformance : begin
                                   vgParametrosModulo.Paineis[no].NomeArquivoHTML := frmSicsProperties.edHTMLFileName.FileName; //WriteString ('Panel'+inttostr(no), 'NomeArquivoHTML'         , frmSicsProperties.edHTMLFileName               .FileName );
                                   vgParametrosModulo.Paineis[no].ValorAcompanhaCorDoNivel := frmSicsProperties.chkCorDaFonteAcompanhaNivelPI.Checked; //WriteBool   ('Panel'+inttostr(no), 'ValorAcompanhaCorDoNivel', frmSicsProperties.chkCorDaFonteAcompanhaNivelPI.Checked  );

                                   vgParametrosModulo.Paineis[no].IndicadorSomPI := frmSicsProperties.edtIndicador.Text; //WriteString('Panel'+inttostr(no), 'IndicadorSomPI'            , frmSicsProperties.edtIndicador.Text);
                                   vgParametrosModulo.Paineis[no].ArquivoSomPI := frmSicsProperties.edtSomPI.Text; //WriteString('Panel'+inttostr(no), 'ArquivoSomPI'            , frmSicsProperties.edtSomPI.Text);
                                 end;

             tpPlayListManager : begin
                                   vgParametrosModulo.Paineis[no].IDTVPlayListManager  := StrToIntDef(frmSicsProperties.edtIDTVPlayListManager.Text, 0); //WriteInteger('Panel'+inttostr(no), 'IDTVPlayListManager', StrToIntDef(frmSicsProperties.edtIDTVPlayListManager.Text, 0));
                                   vgParametrosModulo.Paineis[no].TipoBanco            := frmSicsProperties.cbTipoBancoPlayList.ItemIndex; //WriteInteger('Panel'+inttostr(no), 'TipoBanco', frmSicsProperties.cbTipoBancoPlayList.ItemIndex);
                                   vgParametrosModulo.Paineis[no].HostBanco            := frmSicsProperties.edtHostBancoPlayList.Text; //WriteString('Panel'+inttostr(no),  'HostBanco', frmSicsProperties.edtHostBancoPlayList.Text);
                                   vgParametrosModulo.Paineis[no].PortaBanco           := frmSicsProperties.edtPortaBancoPlayList.Text; //WriteString('Panel'+inttostr(no),  'PortaBanco', frmSicsProperties.edtPortaBancoPlayList.Text);
                                   vgParametrosModulo.Paineis[no].NomeArquivoBanco     := frmSicsProperties.edtNomeArquivoBancoPlayList.Text; //WriteString('Panel'+inttostr(no),  'NomeArquivoBanco', frmSicsProperties.edtNomeArquivoBancoPlayList.Text);
                                   vgParametrosModulo.Paineis[no].UsuarioBanco         := frmSicsProperties.edtUsuarioBancoPlayList.Text; //WriteString('Panel'+inttostr(no),  'UsuarioBanco', frmSicsProperties.edtUsuarioBancoPlayList.Text);
                                   vgParametrosModulo.Paineis[no].SenhaBanco           := frmSicsProperties.edtSenhaBancoPlayList.Text; //WriteString('Panel'+inttostr(no),  'SenhaBanco', frmSicsProperties.edtSenhaBancoPlayList.Text);
                                   vgParametrosModulo.Paineis[no].DiretorioLocal       := frmSicsProperties.edtDiretorioLocalPlayList.Text;//WriteString('Panel'+inttostr(no),  'DiretorioLocal', frmSicsProperties.edtDiretorioLocalPlayList.Text);
                                   vgParametrosModulo.Paineis[no].IntervaloVerificacao := StrToIntDef(frmSicsProperties.edtIntervaloVerificacaoPlayList.Text,1);//WriteInteger('Panel'+inttostr(no), 'IntervaloVerificacao', StrToIntDef(frmSicsProperties.edtIntervaloVerificacaoPlayList.Text,1));
                                 end;
      end;  { case }
    finally
      Free;
    end;  { try .. finally }
end;

{=======================================================}
{ procedures de Apresentação das Informações na Tela }

procedure TfrmSicsTVPrincipal.ChamaSenha (IdPA: Integer; NomePA, Senha, NomeCliente, TextoVozPA: string);
var
  i, x: integer;
  MediaPlayer, MediaPlayerSom: TMediaPlayer;
  ArrayIdsPas: TIntArray;
  vTextoVoz: string;

  vNotify, vVoice: Boolean;
  vID: TTipoChamadaPorVoz;
begin
  MediaPlayer := nil;
  if vgParametrosModulo.ChamadaInterrompeVideo then
    for i := 0 to ComponentCount - 1 do
      if (Components[i] is TJvPanel) and ((Components[i] as TJvPanel).Hint = inttostr(ord(tpVideo))) then
        MediaPlayer := ((Components[i] as TJvPanel).FindComponent ('MediaPlayer'+inttostr((Components[i] as TJvPanel).Tag))) as TMediaPlayer;

  if ((Senha <> '') and (NomePA <> '')) then
  begin
    for i := 0 to ComponentCount - 1 do
      if (Components[i] is TJvPanel) and ((Components[i] as TJvPanel).Hint = inttostr(ord(tpChamadaSenha))) then
      begin
        if ( ((Components[i] as TJvPanel).FindComponent('lblPA'         +inttostr((Components[i] as TJvPanel).Tag)) <> nil) and
             ((Components[i] as TJvPanel).FindComponent('lblSenha'      +inttostr((Components[i] as TJvPanel).Tag)) <> nil) and
             ((Components[i] as TJvPanel).FindComponent('lblNomeCliente'+inttostr((Components[i] as TJvPanel).Tag)) <> nil) and
             ((Components[i] as TJvPanel).FindComponent('MediaPlayer'   +inttostr((Components[i] as TJvPanel).Tag)) <> nil)     ) then
        begin
          if GetPanelProperties(Components[i] as TJvPanel) then
          begin

            //GOT
            vNotify     := frmSicsProperties.chkArquivo.Checked;
            vVoice      := frmSicsProperties.chkVoz.Checked;

            StrToIntArray(frmSicsProperties.edChamadaSenhasPASPermitidas.Text, ArrayIdsPas);
            if ExisteNoIntArray(IdPa, ArrayIdsPas) then
            begin
              ((Components[i] as TJvPanel).FindComponent('lblPA'      +inttostr((Components[i] as TJvPanel).Tag)) as TLabel).Caption := NomePA   ;
              with ((Components[i] as TJvPanel).FindComponent('lblSenha'   +inttostr((Components[i] as TJvPanel).Tag)) as TASPLabel) do
              begin
                Caption := Senha;
                Blink;
              end;

              with ((Components[i] as TJvPanel).FindComponent('lblNomeCliente'+inttostr((Components[i] as TJvPanel).Tag)) as TASPLabel) do
              begin
                Caption := NomeCliente;
                Blink;
              end;

              if MediaPlayer <> nil then
              begin
                MediaPlayer.Notify := false;
                MediaPlayer.PauseOnly;
              end;

              if not (Components[i] as TJvPanel).Visible then
              begin
                (Components[i] as TJvPanel).Visible := true;
                (Components[i] as TJvPanel).BringToFront;
              end;

              try
                Delay(500);

                if vNotify then
                begin
                  try
                    MediaPlayerSom := ((Components[i] as TJvPanel).FindComponent('MediaPlayer'+inttostr((Components[i] as TJvPanel).Tag)) as TMediaPlayer);
                    if MediaPlayerSom.FileName <> '' then
                      MediaPlayerSom.Play;
                  except
                    Assert(False);
                  end;
                end;

                Delay(800);

                if vVoice then
                begin
                  vTextoVoz := EmptyStr;
                  for x := 0 to Pred(frmSicsProperties.lstVozChamada.Count) do
                  begin
                    if frmSicsProperties.lstVozChamada.Items.IndexOf(TTipoChamadaPorVozStr[cvSenha]) = x then
                      vID := cvSenha
                    else if frmSicsProperties.lstVozChamada.Items.IndexOf(TTipoChamadaPorVozStr[cvNomePA]) = x then
                      vID := cvNomePA
                    else
                      vID := cvNomeCliente;

                    if frmSicsProperties.lstVozChamada.Checked[x] then
                    begin
                      case vID of
                        cvSenha       : vTextoVoz := vTextoVoz + ' Senha ' + Senha + ' ... ' ;
                        cvNomePA      : vTextoVoz := vTextoVoz + TextoVozPA        + ' ... ' ;
                        cvNomeCliente : vTextoVoz := vTextoVoz + NomeCliente       + ' ... ' ;
                      end;
                    end;
                  end;

                  if vTextoVoz <> EmptyStr then
                  begin
                    TextToVoice(vTextoVoz);
                  end;
                end;

              finally
              end;
            end;
          end;  // if GetPanelProperties
        end;
      end;

    AtualizaPanelsUltimasChamadas(Senha, NomePA, NomeCliente, IdPA);
  end
  else
  begin
    for i := 0 to ComponentCount - 1 do
      if (Components[i] is TJvPanel) and ((Components[i] as TJvPanel).Hint = inttostr(ord(tpChamadaSenha))) then
      begin
        if MediaPlayer <> nil then
        begin
          MediaPlayer.Notify := false;
          MediaPlayer.Resume;
        end;
        //Eduardo Rocha - Luciano, comentei este codigo, pois quando chamava uma senha em
        // branco (quando gerava um erro de protocolo, por exemplo), o painel sumia
        //(Components[i] as TJvPanel).Visible := false;
      end;
  end;
end;  { proc ChamaSenha }


{=======================================================}
{ procedures de criacao e propriedades dos painéis }

function TfrmSicsTVPrincipal.GetPanelProperties (Panel : TJvPanel) : boolean;  //GOT
var
  No          : integer;
  Image       : TJvImage;
  Flash       : TShockwaveFlash;
  IniFile     : TIniFile;
  ActivePage  : TTabSheet;
  MediaPlayer : TMediaPlayer;
  i           : Integer;
  PanelVideo  : TJvPanel;
begin
  if Panel = nil then
  begin
    frmSicsProperties.Caption                                   := 'Propriedades';
    frmSicsProperties.edLeft                     .Text          := '---';
    frmSicsProperties.edTop                      .Text          := '---';
    frmSicsProperties.edHeight                   .Text          := '---';
    frmSicsProperties.edWidth                    .Text          := '---';
    frmSicsProperties.edBackgroundImage          .Text          := '---';
    frmSicsProperties.cmbBackgroundColor         .SelectedColor := clGray;
    frmSicsProperties.btnAplicar                 .Enabled       := false;
    frmSicsProperties.tbsChamadaSenhas           .TabVisible    := false;
    frmSicsProperties.tbsDataHora                .TabVisible    := false;
    frmSicsProperties.tbsUltimasChamadas         .TabVisible    := false;
    frmSicsProperties.tbsImagem                  .TabVisible    := false;
    frmSicsProperties.tbsFlash                   .TabVisible    := false;
    frmSicsProperties.tbsVideo                   .TabVisible    := false;
    frmSicsProperties.tbsTV                      .TabVisible    := false;
    frmSicsProperties.tbsIndicadoresDePerformance.TabVisible    := false;

    frmSicsProperties.lstQuadros.ItemIndex := -1;

    Result := false;
    exit;
  end;

  No    := Panel.Tag;
  Image := (Panel.FindComponent('BackgroundImage'+inttostr(no))) as TJvImage;

  frmSicsProperties.btnAplicar.Enabled := true;

  frmSicsProperties.lstQuadros.ItemIndex := frmSicsProperties.lstQuadros.Items.IndexOf(TTipoDePainelStr[TTipoDePainel(strtoint(Panel.Hint))] + ' - ' + Panel.Name);

  frmSicsProperties.edLeft  .Text := inttostr(Panel.Left  );
  frmSicsProperties.edTop   .Text := inttostr(Panel.Top   );
  frmSicsProperties.edHeight.Text := inttostr(Panel.Height);
  frmSicsProperties.edWidth .Text := inttostr(Panel.Width );
  frmSicsProperties.vPanel        := Panel;

  if Image <> nil then
  begin
    if Image.Hint <> '' then
    begin
      frmSicsProperties.rbBackgroundImage .Checked       := true      ;
      frmSicsProperties.edBackgroundImage .FileName      := Image.Hint;
      frmSicsProperties.cmbBackgroundColor.SelectedColor := clGray    ;
    end
    else
    begin
      frmSicsProperties.edBackgroundImage.FileName       := '';
      frmSicsProperties.rbBackGroundColor.Checked        := true;
      frmSicsProperties.cmbBackgroundColor.SelectedColor := Panel.Color;
    end;
  end;  { if Image <> nil }

  ActivePage := frmSicsProperties.PageControlConfigs.ActivePage;

  frmSicsProperties.tbsChamadaSenhas           .TabVisible := (TTipoDePainel(strtoint(Panel.Hint)) = tpChamadaSenha        );
  frmSicsProperties.tbsUltimasChamadas         .TabVisible := (TTipoDePainel(strtoint(Panel.Hint)) = tpUltimasSenhas       );
  frmSicsProperties.tbsImagem                  .TabVisible := (TTipoDePainel(strtoint(Panel.Hint)) = tpImagem              );
  frmSicsProperties.tbsFlash                   .TabVisible := (TTipoDePainel(strtoint(Panel.Hint)) = tpFlash               );
  frmSicsProperties.tbsDataHora                .TabVisible := (TTipoDePainel(strtoint(Panel.Hint)) = tpDataHora            );
  frmSicsProperties.tbsVideo                   .TabVisible := (TTipoDePainel(strtoint(Panel.Hint)) = tpVideo               ) or (TTipoDePainel(strtoint(Panel.Hint)) = tpTV);
  frmSicsProperties.tbsJornalEletronico        .TabVisible := (TTipoDePainel(strtoint(Panel.Hint)) = tpJornalEletronico    );
  frmSicsProperties.tbsTV                      .TabVisible := (TTipoDePainel(strtoint(Panel.Hint)) = tpTV                  );
  frmSicsProperties.tbsIndicadoresDePerformance.TabVisible := (TTipoDePainel(strtoint(Panel.Hint)) = tpIndicadorPerformance);
  frmSicsProperties.tbsPlayListManager.TabVisible          := (TTipoDePainel(strtoint(Panel.Hint)) = tpPlayListManager);

  // mantendo na "ultima" aba caso nao esteja vendo a aba geral
  if ActivePage <> frmSicsProperties.tbsGeral then
  begin
    for i := 0 to frmSicsProperties.PageControlConfigs.PageCount - 1 do
      if (frmSicsProperties.PageControlConfigs.Pages[i] <> frmSicsProperties.tbsGeral) and
        (frmSicsProperties.PageControlConfigs.Pages[i].TabVisible) then
      begin
        frmSicsProperties.PageControlConfigs.ActivePage := frmSicsProperties.PageControlConfigs.Pages[i];
        Break;
      end;
  end;

  frmSicsProperties.Caption := 'Propriedades - Quadro de ' + TTipoDePainelStr[TTipoDePainel(strtoint(Panel.Hint))];

  case TTipoDePainel(strtoint(Panel.Hint)) of
    tpChamadaSenha         : begin
                               IniFile := TIniFile.Create(GetAppIniFileName);
                               with IniFile do
                                 try
                                   frmSicsProperties.chkChamadaDeSenhasLayoutMostrarSenha       .Checked := vgParametrosModulo.Paineis[no].MostrarSenha;          //ReadBool    ('Panel'+inttostr(no), 'MostrarSenha'          , true );
                                   frmSicsProperties.edChamadaDeSenhasLayoutSenhaX              .Text    := vgParametrosModulo.Paineis[no].LayoutSenhaX.ToString;          //ReadString  ('Panel'+inttostr(no), 'LayoutSenhaX'          , '0'  );
                                   frmSicsProperties.edChamadaDeSenhasLayoutSenhaY              .Text    := vgParametrosModulo.Paineis[no].LayoutSenhaY.ToString;          //ReadString  ('Panel'+inttostr(no), 'LayoutSenhaY'          , '0'  );
                                   frmSicsProperties.edChamadaDeSenhasLayoutSenhaLarg           .Text    := vgParametrosModulo.Paineis[no].LayoutSenhaLARG.ToString;       //ReadString  ('Panel'+inttostr(no), 'LayoutSenhaLarg'       , '0'  );
                                   frmSicsProperties.edChamadaDeSenhasLayoutSenhaAlt            .Text    := vgParametrosModulo.Paineis[no].LayoutSenhaALT.ToString;        //ReadString  ('Panel'+inttostr(no), 'LayoutSenhaAlt'        , '0'  );
                                   frmSicsProperties.chkChamadaDeSenhasLayoutMostrarPA          .Checked := vgParametrosModulo.Paineis[no].MostrarPA;             //ReadBool    ('Panel'+inttostr(no), 'MostrarPA'             , true );
                                   frmSicsProperties.edChamadaDeSenhasLayoutPAX                 .Text    := vgParametrosModulo.Paineis[no].LayoutPAX.ToString;             //ReadString  ('Panel'+inttostr(no), 'LayoutPAX'             , '0'  );
                                   frmSicsProperties.edChamadaDeSenhasLayoutPAY                 .Text    := vgParametrosModulo.Paineis[no].LayoutPAY.ToString;             //ReadString  ('Panel'+inttostr(no), 'LayoutPAY'             , '0'  );
                                   frmSicsProperties.edChamadaDeSenhasLayoutPALarg              .Text    := vgParametrosModulo.Paineis[no].LayoutPALARG.ToString;          //ReadString  ('Panel'+inttostr(no), 'LayoutPALarg'          , '0'  );
                                   frmSicsProperties.edChamadaDeSenhasLayoutPAAlt               .Text    := vgParametrosModulo.Paineis[no].LayoutPAALT.ToString;           //ReadString  ('Panel'+inttostr(no), 'LayoutPAAlt'           , '0'  );
                                   frmSicsProperties.chkChamadaDeSenhasLayoutMostrarNomeCliente .Checked := vgParametrosModulo.Paineis[no].MostrarNomeCliente;    //ReadBool    ('Panel'+inttostr(no), 'MostrarNomeCliente'    , true );
                                   frmSicsProperties.edChamadaDeSenhasLayoutNomeClienteX        .Text    := vgParametrosModulo.Paineis[no].LayoutNomeClienteX.ToString;    //ReadString  ('Panel'+inttostr(no), 'LayoutNomeClienteX'    , '0'  );
                                   frmSicsProperties.edChamadaDeSenhasLayoutNomeClienteY        .Text    := vgParametrosModulo.Paineis[no].LayoutNomeClienteY.ToString;    //ReadString  ('Panel'+inttostr(no), 'LayoutNomeClienteY'    , '0'  );
                                   frmSicsProperties.edChamadaDeSenhasLayoutNomeClienteLarg     .Text    := vgParametrosModulo.Paineis[no].LayoutNomeClienteLARG.ToString; //ReadString  ('Panel'+inttostr(no), 'LayoutNomeClienteLarg' , '0'  );
                                   frmSicsProperties.edChamadaDeSenhasLayoutNomeClienteAlt      .Text    := vgParametrosModulo.Paineis[no].LayoutNomeClienteALT.ToString;  //ReadString  ('Panel'+inttostr(no), 'LayoutNomeClienteAlt'  , '0'  );

                                   case vgParametrosModulo.Paineis[no].LayoutSenhaAlinhamento of //ReadInteger  ('Panel'+inttostr(no), 'LayoutSenhaAlinhamento', 0)
                                     1  : frmSicsProperties.btnChamadaDeSenhasLayoutSenhaAlinhaCentro  .Down := true;
                                     2  : frmSicsProperties.btnChamadaDeSenhasLayoutSenhaAlinhaDireita .Down := true;
                                     else frmSicsProperties.btnChamadaDeSenhasLayoutSenhaAlinhaEsquerda.Down := true;
                                   end;
                                   case vgParametrosModulo.Paineis[no].LayoutPAAlinhamento of //ReadInteger  ('Panel'+inttostr(no), 'LayoutPAAlinhamento', 0)
                                     1  : frmSicsProperties.btnChamadaDeSenhasLayoutPAAlinhaCentro  .Down := true;
                                     2  : frmSicsProperties.btnChamadaDeSenhasLayoutPAAlinhaDireita .Down := true;
                                     else frmSicsProperties.btnChamadaDeSenhasLayoutPAAlinhaEsquerda.Down := true;
                                   end;
                                   case vgParametrosModulo.Paineis[no].LayoutNomeClienteAlinhamento of //ReadInteger  ('Panel'+inttostr(no), 'LayoutNomeClienteAlinhamento', 0)
                                     1  : frmSicsProperties.btnChamadaDeSenhasLayoutNomeClienteAlinhaCentro  .Down := true;
                                     2  : frmSicsProperties.btnChamadaDeSenhasLayoutNomeClienteAlinhaDireita .Down := true;
                                     else frmSicsProperties.btnChamadaDeSenhasLayoutNomeClienteAlinhaEsquerda.Down := true;
                                   end;

                                   frmSicsProperties.edChamadaSenhasPASPermitidas.Text    := vgParametrosModulo.Paineis[no].PASPermitidas; //ReadString  ('Panel'+inttostr(no), 'PASPermitidas'         , ''   );
                                   frmSicsProperties.chkArquivo.Checked                   := vgParametrosModulo.Paineis[no].SomArquivo; //ReadBool    ('Panel'+inttostr(no), 'SomArquivo'          , False );
                                   frmSicsProperties.chkVoz.Checked                       := vgParametrosModulo.Paineis[no].SomVoz;     //ReadBool    ('Panel'+inttostr(no), 'SomVoz'              , False );
                                   frmSicsProperties.lstVozChamada.Items.Clear;
                                   frmSicsProperties.lstVozChamada.Items.Add(TTipoChamadaPorVozStr[TTipoChamadaPorVoz(vgParametrosModulo.Paineis[no].SomVozChamada0)]); //ReadInteger  ('Panel'+inttostr(no), 'SomVozChamada0' , 0 )
                                   frmSicsProperties.lstVozChamada.Items.Add(TTipoChamadaPorVozStr[TTipoChamadaPorVoz(vgParametrosModulo.Paineis[no].SomVozChamada1)]); //ReadInteger  ('Panel'+inttostr(no), 'SomVozChamada1' , 1 )
                                   frmSicsProperties.lstVozChamada.Items.Add(TTipoChamadaPorVozStr[TTipoChamadaPorVoz(vgParametrosModulo.Paineis[no].SomVozChamada2)]); //
                                   frmSicsProperties.lstVozChamada.Checked[0] := vgParametrosModulo.Paineis[no].SomVozChamada1Marcado; //ReadBool    ('Panel'+inttostr(no), 'SomVozChamada1Marcado'              , False );
                                   frmSicsProperties.lstVozChamada.Checked[1] := vgParametrosModulo.Paineis[no].SomVozChamada2Marcado; //ReadBool    ('Panel'+inttostr(no), 'SomVozChamada2Marcado'              , False );
                                   frmSicsProperties.lstVozChamada.Checked[2] := vgParametrosModulo.Paineis[no].SomVozChamada3Marcado; //ReadBool    ('Panel'+inttostr(no), 'SomVozChamada3Marcado'              , False );
                                   VoiceIndex                                 := vgParametrosModulo.Paineis[no].VoiceIndex; //ReadInteger ('Panel'+inttostr(no),'VoiceIndex',0);
                                 finally
                                   Free;
                                 end;  { try .. finally }

                               frmSicsProperties.cmbChamadaSenhasFonte     .FontName      := Panel.Font.Name;
                               frmSicsProperties.cmbChamadaSenhasFontSize  .Text          := inttostr(Panel.Font.Size);
                               frmSicsProperties.cmbChamadaSenhasFontColor .SelectedColor := Panel.Font.Color;
                               frmSicsProperties.btnChamadaSenhasNegrito   .Down          := (fsBold      in Panel.Font.Style);
                               frmSicsProperties.btnChamadaSenhasItalico   .Down          := (fsItalic    in Panel.Font.Style);
                               frmSicsProperties.btnChamadaSenhasSublinhado.Down          := (fsUnderline in Panel.Font.Style);

                               MediaPlayer := (Panel.FindComponent ('MediaPlayer'+inttostr(no))) as TMediaPlayer;
                               if MediaPlayer <> nil then
                                 frmSicsProperties.edChamadaSenhasSoundFileName.Text := MediaPlayer.FileName;

                               // 27/06 - Aqui pegar a lista de videos do Ini ou Variavel Global
                             end;

    tpUltimasSenhas        : begin
                               IniFile := TIniFile.Create(GetAppIniFileName);
                               with IniFile do
                                 try
                                   frmSicsProperties.chkUltimasChamadasLayoutMostrarSenha       .Checked := vgParametrosModulo.Paineis[no].MostrarSenha;          //ReadBool    ('Panel'+inttostr(no), 'MostrarSenha'          , true );
                                   frmSicsProperties.edUltimasChamadasLayoutSenhaX              .Text    := vgParametrosModulo.Paineis[no].LayoutSenhaX.ToString;          //ReadString  ('Panel'+inttostr(no), 'LayoutSenhaX'          , '0'  );
                                   frmSicsProperties.edUltimasChamadasLayoutSenhaY              .Text    := vgParametrosModulo.Paineis[no].LayoutSenhaY.ToString;          //ReadString  ('Panel'+inttostr(no), 'LayoutSenhaY'          , '0'  );
                                   frmSicsProperties.edUltimasChamadasLayoutSenhaLarg           .Text    := vgParametrosModulo.Paineis[no].LayoutSenhaLARG.ToString;       //ReadString  ('Panel'+inttostr(no), 'LayoutSenhaLarg'       , '0'  );
                                   frmSicsProperties.edUltimasChamadasLayoutSenhaAlt            .Text    := vgParametrosModulo.Paineis[no].LayoutSenhaALT.ToString;        //ReadString  ('Panel'+inttostr(no), 'LayoutSenhaAlt'        , '0'  );
                                   frmSicsProperties.chkUltimasChamadasLayoutMostrarPA          .Checked := vgParametrosModulo.Paineis[no].MostrarPA;             //ReadBool    ('Panel'+inttostr(no), 'MostrarPA'             , true );
                                   frmSicsProperties.edUltimasChamadasLayoutPAX                 .Text    := vgParametrosModulo.Paineis[no].LayoutPAX.ToString;             //ReadString  ('Panel'+inttostr(no), 'LayoutPAX'             , '0'  );
                                   frmSicsProperties.edUltimasChamadasLayoutPAY                 .Text    := vgParametrosModulo.Paineis[no].LayoutPAY.ToString;             //ReadString  ('Panel'+inttostr(no), 'LayoutPAY'             , '0'  );
                                   frmSicsProperties.edUltimasChamadasLayoutPALarg              .Text    := vgParametrosModulo.Paineis[no].LayoutPALARG.ToString;          //ReadString  ('Panel'+inttostr(no), 'LayoutPALarg'          , '0'  );
                                   frmSicsProperties.edUltimasChamadasLayoutPAAlt               .Text    := vgParametrosModulo.Paineis[no].LayoutPAALT.ToString;           //ReadString  ('Panel'+inttostr(no), 'LayoutPAAlt'           , '0'  );
                                   frmSicsProperties.chkUltimasChamadasLayoutMostrarNomeCliente .Checked := vgParametrosModulo.Paineis[no].MostrarNomeCliente;    //ReadBool    ('Panel'+inttostr(no), 'MostrarNomeCliente'    , true );
                                   frmSicsProperties.edUltimasChamadasLayoutNomeClienteX        .Text    := vgParametrosModulo.Paineis[no].LayoutNomeClienteX.ToString;    //ReadString  ('Panel'+inttostr(no), 'LayoutNomeClienteX'    , '0'  );
                                   frmSicsProperties.edUltimasChamadasLayoutNomeClienteY        .Text    := vgParametrosModulo.Paineis[no].LayoutNomeClienteY.ToString;    //ReadString  ('Panel'+inttostr(no), 'LayoutNomeClienteY'    , '0'  );
                                   frmSicsProperties.edUltimasChamadasLayoutNomeClienteLarg     .Text    := vgParametrosModulo.Paineis[no].LayoutNomeClienteLARG.ToString; //ReadString  ('Panel'+inttostr(no), 'LayoutNomeClienteLarg' , '0'  );
                                   frmSicsProperties.edUltimasChamadasLayoutNomeClienteAlt      .Text    := vgParametrosModulo.Paineis[no].LayoutNomeClienteALT.ToString;  //ReadString  ('Panel'+inttostr(no), 'LayoutNomeClienteAlt'  , '0'  );

                                   case vgParametrosModulo.Paineis[no].LayoutSenhaAlinhamento of //ReadInteger  ('Panel'+inttostr(no), 'LayoutSenhaAlinhamento', 0)
                                     1  : frmSicsProperties.btnUltimasChamadasLayoutSenhaAlinhaCentro  .Down := true;
                                     2  : frmSicsProperties.btnUltimasChamadasLayoutSenhaAlinhaDireita .Down := true;
                                     else frmSicsProperties.btnUltimasChamadasLayoutSenhaAlinhaEsquerda.Down := true;
                                   end;
                                   case vgParametrosModulo.Paineis[no].LayoutPAAlinhamento of //ReadInteger  ('Panel'+inttostr(no), 'LayoutPAAlinhamento', 0)
                                     1  : frmSicsProperties.btnUltimasChamadasLayoutPAAlinhaCentro  .Down := true;
                                     2  : frmSicsProperties.btnUltimasChamadasLayoutPAAlinhaDireita .Down := true;
                                     else frmSicsProperties.btnUltimasChamadasLayoutPAAlinhaEsquerda.Down := true;
                                   end;
                                   case vgParametrosModulo.Paineis[no].LayoutNomeClienteAlinhamento of //ReadInteger  ('Panel'+inttostr(no), 'LayoutNomeClienteAlinhamento', 0)
                                     1  : frmSicsProperties.btnUltimasChamadasLayoutNomeClienteAlinhaCentro  .Down := true;
                                     2  : frmSicsProperties.btnUltimasChamadasLayoutNomeClienteAlinhaDireita .Down := true;
                                     else frmSicsProperties.btnUltimasChamadasLayoutNomeClienteAlinhaEsquerda.Down := true;
                                   end;

                                   frmSicsProperties.edUltimasChamadasQuantidade                .Text    := vgParametrosModulo.Paineis[no].Quantidade;       //ReadString  ('Panel'+inttostr(no), 'Quantidade'            , '0'  );
                                   frmSicsProperties.edUltimasChamadasAtraso                    .Text    := vgParametrosModulo.Paineis[no].Atraso;           //ReadString  ('Panel'+inttostr(no), 'Atraso'                , '0'  );
                                   frmSicsProperties.edUltimasChamadasEspacamento               .Text    := vgParametrosModulo.Paineis[no].Espacamento;      //ReadString  ('Panel'+inttostr(no), 'Espacamento'           , '0'  );
                                   frmSicsProperties.rbUltimasChamadasDisposicaoEmLinhas        .Checked := vgParametrosModulo.Paineis[no].DisposicaoLinhas; //ReadBool    ('Panel'+inttostr(no), 'DisposicaoLinhas'      , true );
                                   frmSicsProperties.rbUltimasChamadasDisposicaoEmColunas       .Checked := not frmSicsProperties.rbUltimasChamadasDisposicaoEmLinhas .Checked;  //precisa?
                                   frmSicsProperties.edUltimasChamadasPASPermitidas             .Text    := vgParametrosModulo.Paineis[no].PASPermitidas;    //ReadString  ('Panel'+inttostr(no), 'PASPermitidas'         , ''   );
                                 finally
                                   Free;
                                 end;  { try .. finally }

                               frmSicsProperties.cmbUltimasChamadasFonte     .FontName      := Panel.Font.Name;
                               frmSicsProperties.cmbUltimasChamadasFontSize  .Text          := inttostr(Panel.Font.Size);
                               frmSicsProperties.cmbUltimasChamadasFontColor .SelectedColor := Panel.Font.Color;
                               frmSicsProperties.btnUltimasChamadasNegrito   .Down          := (fsBold      in Panel.Font.Style);
                               frmSicsProperties.btnUltimasChamadasItalico   .Down          := (fsItalic    in Panel.Font.Style);
                               frmSicsProperties.btnUltimasChamadasSublinhado.Down          := (fsUnderline in Panel.Font.Style);
                             end;

    tpImagem               : begin
                               //
                             end;

    tpFlash                : begin
                               Flash := (Panel.FindComponent ('Flash'+inttostr(no))) as TShockwaveFlash;
                               if ((Flash <> nil) and (Flash.Movie <> '')) then
                                 frmSicsProperties.edFlashFileName.FileName := Flash.Movie
                               else
                                 frmSicsProperties.edFlashFileName.FileName := '';
                             end;

    tpDataHora             : begin
                               IniFile := TIniFile.Create(GetAppIniFileName);
                               with IniFile do
                                 try
                                   frmSicsProperties.edDataHoraMargemSuperior.Text := vgParametrosModulo.Paineis[no].MargemSuperior.ToString; //ReadString ('Panel'+inttostr(no), 'MargemSuperior' , '0'                          );
                                   frmSicsProperties.edDataHoraMargemInferior.Text := vgParametrosModulo.Paineis[no].MargemInferior.ToString; //ReadString ('Panel'+inttostr(no), 'MargemInferior' , '0'                          );
                                   frmSicsProperties.edDataHoraMargemEsquerda.Text := vgParametrosModulo.Paineis[no].MargemEsquerda.ToString; //ReadString ('Panel'+inttostr(no), 'MargemEsquerda' , '0'                          );
                                   frmSicsProperties.edDataHoraMargemDireita .Text := vgParametrosModulo.Paineis[no].MargemDireita.ToString;  //ReadString ('Panel'+inttostr(no), 'MargemDireita'  , '0'                          );
                                   frmSicsProperties.edDataHoraFormato       .Text := vgParametrosModulo.Paineis[no].Formato;        //ReadString ('Panel'+inttostr(no), 'Formato'        , 'ddd, dd "de" mmm "de" yyyy' );
                                 finally
                                   Free;
                                 end;  { try .. finally }

                               frmSicsProperties.cmbDataHoraFonte     .FontName      := Panel.Font.Name;
                               frmSicsProperties.cmbDataHoraFontSize  .Text          := inttostr(Panel.Font.Size);
                               frmSicsProperties.cmbDataHoraFontColor .SelectedColor := Panel.Font.Color;
                               frmSicsProperties.btnDataHoraNegrito   .Down          := (fsBold      in Panel.Font.Style);
                               frmSicsProperties.btnDataHoraItalico   .Down          := (fsItalic    in Panel.Font.Style);
                               frmSicsProperties.btnDataHoraSublinhado.Down          := (fsUnderline in Panel.Font.Style);
                             end;

    tpJornalEletronico     : begin
                               if vgJornalEletronico <> nil then
                                 frmSicsProperties.edtJornalEletronicoInterval.Text := IntToStr(vgJornalEletronico.Interval);
                               frmSicsProperties.cmbJornalEletronicoFonte     .FontName      := Panel.Font.Name;
                               frmSicsProperties.cmbJornalEletronicoFontSize  .Text          := inttostr(Panel.Font.Size);
                               frmSicsProperties.cmbJornalEletronicoFontColor .SelectedColor := Panel.Font.Color;
                               frmSicsProperties.btnJornalEletronicoNegrito   .Down          := (fsBold      in Panel.Font.Style);
                               frmSicsProperties.btnJornalEletronicoItalico   .Down          := (fsItalic    in Panel.Font.Style);
                               frmSicsProperties.btnJornalEletronicoSublinhado.Down          := (fsUnderline in Panel.Font.Style);
                             end;

    tpVideo                : begin
                               frmSicsProperties.lstVideoFileNames.Items.Text := TListBox(Panel.FindComponent('lstVideos' + IntToStr(No))).Items.Text;
                               frmSicsProperties.edtTempoAlternancia.Visible := false;
                               frmSicsProperties.lblTempoAlternancia.Visible := false;
                             end;

    tpTV                   : begin
                               PanelVideo := TJvPanel(Self.FindComponent('PanelVideo'+inttostr(No)));
                               frmSicsProperties.cboSoftwaresHomologados.ItemIndex := vgTVComponent.SoftwareHomologado ;
                               frmSicsProperties.edCaminhoExecutavel.Text          := vgTVComponent.CaminhoDoExecutavel;
                               frmSicsProperties.edNomeJanela.Text                 := vgTVComponent.NomeDaJanela       ;
                               frmSicsProperties.edResolucaoPadrao.Text            := vgResolucaoPadrao;
                               frmSicsProperties.edtTempoAlternancia.Visible := true;
                               frmSicsProperties.edtTempoAlternancia.Text := inttostr(vgTVComponent.TempoAlternancia);
                               frmSicsProperties.lblTempoAlternancia.Visible := true;
                               if(Assigned(PanelVideo))then
                                 frmSicsProperties.lstVideoFileNames.Items.Text := TListBox(PanelVideo.FindComponent('lstVideos' + IntToStr(No))).Items.Text;
                               if vgTVComponent.SoftwareHomologado = -1 then
                               begin
                                 frmSicsProperties.edCaminhoExecutavel.Enabled := false;
                                 frmSicsProperties.edNomeJanela       .Enabled := false;
                                 frmSicsProperties.cbxDispositivo     .Enabled := False;
                                 frmSicsProperties.cbxResolucao       .Enabled := False;

                                 frmSicsProperties.edCaminhoExecutavel.Text    := '';
                                 frmSicsProperties.edNomeJanela       .Text    := '';
                                 frmSicsProperties.cbxDispositivo     .ItemIndex := -1;
                                 frmSicsProperties.cbxResolucao       .ItemIndex := -1;
                                 frmSicsProperties.edResolucaoPadrao  .Text := '';
                                 frmSicsProperties.edResolucaoPadrao  .Enabled := False;
                               end

                               else if (SoftwarePadraoTV(vgTVComponent.SoftwareHomologado) or (vgTVComponent.SoftwareHomologado = 2)) then
                               begin
                                 frmSicsProperties.edCaminhoExecutavel.Enabled := true;
                                 frmSicsProperties.edNomeJanela       .Enabled := true;
                                 if SoftwarePadraoTV(vgTVComponent.SoftwareHomologado) then
                                  frmSicsProperties.edResolucaoPadrao  .Enabled := True;
                               end
                               else if(vgTVComponent.SoftwareHomologado = 3)then
                               begin
                                 frmSicsProperties.cbxDispositivo     .Enabled := True;
                                 frmSicsProperties.IdentificarPlacaDeCaptura(vgTVComponent.Dispositivo);
                                 frmSicsProperties.CriarObjetoDeCapturaPopularResolucao(vgTVComponent.Resolucao,vgTVComponent.ParentHandle);
                                 //Sleep(1000);
                                 frmSicsProperties.StartStreaming;
                                 frmSicsProperties.edResolucaoPadrao  .Text := '';
                                 frmSicsProperties.edResolucaoPadrao  .Enabled := False;
                               end
                               else if(vgTVComponent.SoftwareHomologado = 0)then
                               begin
                                 frmSicsProperties.edCaminhoExecutavel.Enabled := true;
                                 frmSicsProperties.edNomeJanela       .Enabled := true;
                                 frmSicsProperties.cbxDispositivo     .Enabled := False;
                                 frmSicsProperties.cbxResolucao       .Enabled := False;

                                 frmSicsProperties.cbxDispositivo     .ItemIndex := -1;
                                 frmSicsProperties.cbxResolucao       .ItemIndex := -1;
                                 frmSicsProperties.edResolucaoPadrao  .Enabled := False;
                                 frmSicsProperties.edResolucaoPadrao  .Text := '';
                               end;
                             end;

    tpIndicadorPerformance : begin
                               IniFile := TIniFile.Create(GetAppIniFileName);
                               with IniFile do
                                 try
                                   frmSicsProperties.edHTMLFileName               .FileName := vgParametrosModulo.Paineis[no].NomeArquivoHTML; //ReadString ('Panel'+inttostr(no), 'NomeArquivoHTML'         , ''   );
                                   frmSicsProperties.chkCorDaFonteAcompanhaNivelPI.Checked  := vgParametrosModulo.Paineis[no].ValorAcompanhaCorDoNivel;  //ReadBool   ('Panel'+inttostr(no), 'ValorAcompanhaCorDoNivel', false);


                                   frmSicsProperties.edtIndicador.Text                      := vgParametrosModulo.Paineis[no].IndicadorSomPI; //ReadString  ('Panel'+inttostr(no), 'IndicadorSomPI','');
                                   frmSicsProperties.edtSomPI.Text                          := vgParametrosModulo.Paineis[no].ArquivoSomPI;   //ReadString  ('Panel'+inttostr(no), 'ArquivoSomPI','');
                                 finally
                                   Free;
                                 end;  { try .. finally }
                             end;

    tpPlayListManager      : begin
                               IniFile := TIniFile.Create(GetAppIniFileName);
                               try
                                 frmSicsProperties.edtIDTVPlayListManager.Text          := IntToStr(vgParametrosModulo.Paineis[no].IDTVPlayListManager);  //IntToStr(IniFile.ReadInteger('Panel'+inttostr(no), 'IDTVPlayListManager', 0));
                                 frmSicsProperties.cbTipoBancoPlayList.ItemIndex        := vgParametrosModulo.Paineis[no].TipoBanco;                      //IniFile.ReadInteger('Panel'+inttostr(no), 'TipoBanco', 0);
                                 frmSicsProperties.edtHostBancoPlayList.Text            := vgParametrosModulo.Paineis[no].HostBanco;                      //IniFile.ReadString('Panel'+inttostr(no), 'HostBanco', '');
                                 frmSicsProperties.edtPortaBancoPlayList.Text           := vgParametrosModulo.Paineis[no].PortaBanco;                     //IniFile.ReadString('Panel'+inttostr(no), 'PortaBanco', '');
                                 frmSicsProperties.edtNomeArquivoBancoPlayList.Text     := vgParametrosModulo.Paineis[no].NomeArquivoBanco;               //IniFile.ReadString('Panel'+inttostr(no), 'NomeArquivoBanco', '');
                                 frmSicsProperties.edtUsuarioBancoPlayList.Text         := vgParametrosModulo.Paineis[no].UsuarioBanco;                   //IniFile.ReadString('Panel'+inttostr(no), 'UsuarioBanco', '');
                                 frmSicsProperties.edtSenhaBancoPlayList.Text           := vgParametrosModulo.Paineis[no].SenhaBanco;                     //IniFile.ReadString('Panel'+inttostr(no), 'SenhaBanco', '');
                                 frmSicsProperties.edtDiretorioLocalPlayList.Text       := vgParametrosModulo.Paineis[no].DiretorioLocal;                 //IniFile.ReadString('Panel'+inttostr(no), 'DiretorioLocal', '');
                                 frmSicsProperties.edtIntervaloVerificacaoPlayList.Text := IntToStr(vgParametrosModulo.Paineis[no].IntervaloVerificacao); //IntToStr(IniFile.ReadInteger('Panel'+inttostr(no), 'IntervaloVerificacao', 1));
                               finally
                                 FreeAndNil(IniFile);
                               end;
                             end;

  end;  { case }
  Result := true;
end;  { func GetPanelProperties }


function TfrmSicsTVPrincipal.SetPanelProperties (Panel : TJvPanel) : boolean; //GOT
var
  No          : integer;
  Image       : TJvImage;
  Flash       : TShockwaveFlash;
  MediaPlayer : TMediaPlayer;
  ListaVideos : TListBox;
  i: Integer;
  PanelVideo  : TJvPanel;
begin
  if Panel = nil then
  begin
    Result := false;
    exit;
  end;

  No    := Panel.Tag;
  Image := (Panel.FindComponent('BackgroundImage'+inttostr(no))) as TJvImage;

  TLog.MyLog('SetPanelProperties: ' + TTipoDePainelStr[TTipoDePainel(StrToInt(Panel.Hint))], Panel, 0, false, TCriticalLog.tlINFO);

  Panel.Left   := strtoint(frmSicsProperties.edLeft  .Text);
  Panel.Top    := strtoint(frmSicsProperties.edTop   .Text);

  if Image <> nil then
  begin
    if frmSicsProperties.rbBackgroundImage.Checked then
    begin
      if FileExists(frmSicsProperties.edBackgroundImage.FileName) then
        Image.Picture.LoadFromFile(frmSicsProperties.edBackgroundImage.FileName);
      Image.Hint := frmSicsProperties.edBackgroundImage.FileName;
      Image.Visible := true;
    end
    else if frmSicsProperties.rbBackGroundColor.Checked then
    begin
      Image.Visible := false;
      Image.Hint := '';
      Panel.Color := frmSicsProperties.cmbBackgroundColor.SelectedColor;
      Panel.Transparent := (frmSicsProperties.cmbBackgroundColor.SelectedColor = frmSicsProperties.cmbBackgroundColor.Properties.NoneColorColor);
    end;

    Image.Stretch  := true;
    Panel.Height   := strtoint(frmSicsProperties.edHeight.Text);
    Panel.Width    := strtoint(frmSicsProperties.edWidth .Text);
  end;  { if Image <> nil }

  case TTipoDePainel(StrToInt(Panel.Hint)) of
    tpChamadaSenha         : begin
                               Panel.Font.Name  := frmSicsProperties.cmbChamadaSenhasFonte.FontName;
                               Panel.Font.Size  := strtoint(frmSicsProperties.cmbChamadaSenhasFontSize.Text);
                               Panel.Font.Color := frmSicsProperties.cmbChamadaSenhasFontColor.SelectedColor;
                               Panel.Font.Style := [];
                               if frmSicsProperties.btnChamadaSenhasNegrito.Down then
                                 Panel.Font.Style := Panel.Font.Style + [fsBold];
                               if frmSicsProperties.btnChamadaSenhasItalico.Down then
                                 Panel.Font.Style := Panel.Font.Style + [fsItalic];
                               if frmSicsProperties.btnChamadaSenhasSublinhado.Down then
                                 Panel.Font.Style := Panel.Font.Style + [fsUnderline];

                               MediaPlayer := (Panel.FindComponent ('MediaPlayer'+inttostr(no))) as TMediaPlayer;
                               if MediaPlayer <> nil then
                               begin
                                 if FileExists(frmSicsProperties.edChamadaSenhasSoundFileName.FileName) then
                                 begin
                                   MediaPlayer.FileName := frmSicsProperties.edChamadaSenhasSoundFileName.FileName;
                                   MediaPlayer.Open;
                                   try
                                     MediaPlayer.Play;
                                   except
                                     Assert(False);
                                   end;
                                 end;
                               end;

                               CreateLabelsChamada (Panel);
                             end;

    tpUltimasSenhas        : begin
                               Panel.Font.Name  := frmSicsProperties.cmbUltimasChamadasFonte.FontName;
                               Panel.Font.Size  := strtoint(frmSicsProperties.cmbUltimasChamadasFontSize.Text);
                               Panel.Font.Color := frmSicsProperties.cmbUltimasChamadasFontColor.SelectedColor;
                               Panel.Font.Style := [];
                               if frmSicsProperties.btnUltimasChamadasNegrito.Down then
                                 Panel.Font.Style := Panel.Font.Style + [fsBold];
                               if frmSicsProperties.btnUltimasChamadasItalico.Down then
                                 Panel.Font.Style := Panel.Font.Style + [fsItalic];
                               if frmSicsProperties.btnUltimasChamadasSublinhado.Down then
                                 Panel.Font.Style := Panel.Font.Style + [fsUnderline];

                               CreateLabelsUltimasChamadas(Panel, StrToIntDef(frmSicsProperties.edUltimasChamadasQuantidade.Text, 0))
                             end;

    tpImagem               : begin
                             end;

    tpFlash                : begin
                               Flash := (Panel.FindComponent ('Flash'+inttostr(no))) as TShockwaveFlash;
                               if Flash <> nil then
                               begin
                                 if FileExists(frmSicsProperties.edFlashFileName.FileName) then
                                 begin
                                   Flash.BGColor := '';
                                   Flash.Movie := frmSicsProperties.edFlashFileName.FileName;
                                   Flash.Play;
                                 end;
                                 Flash.SetFocus;
                               end;
                             end;

    tpDataHora             : begin
                               Panel.Font.Name  := frmSicsProperties.cmbDataHoraFonte.FontName;
                               Panel.Font.Size  := strtoint(frmSicsProperties.cmbDataHoraFontSize.Text);
                               Panel.Font.Color := frmSicsProperties.cmbDataHoraFontColor.SelectedColor;
                               Panel.Font.Style := [];
                               if frmSicsProperties.btnDataHoraNegrito.Down then
                                 Panel.Font.Style := Panel.Font.Style + [fsBold];
                               if frmSicsProperties.btnDataHoraItalico.Down then
                                 Panel.Font.Style := Panel.Font.Style + [fsItalic];
                               if frmSicsProperties.btnDataHoraSublinhado.Down then
                                 Panel.Font.Style := Panel.Font.Style + [fsUnderline];

                               CreateLabelsDataHora(Panel, frmSicsProperties.edDataHoraFormato.Text);
                             end;

    tpJornalEletronico     : begin
                               Panel.Font.Name  := frmSicsProperties.cmbJornalEletronicoFonte.FontName;
                               Panel.Font.Size  := strtoint(frmSicsProperties.cmbJornalEletronicoFontSize.Text);
                               Panel.Font.Color := frmSicsProperties.cmbJornalEletronicoFontColor.SelectedColor;
                               Panel.Font.Style := [];
                               if frmSicsProperties.btnJornalEletronicoNegrito.Down then
                                 Panel.Font.Style := Panel.Font.Style + [fsBold];
                               if frmSicsProperties.btnJornalEletronicoItalico.Down then
                                 Panel.Font.Style := Panel.Font.Style + [fsItalic];
                               if frmSicsProperties.btnJornalEletronicoSublinhado.Down then
                                 Panel.Font.Style := Panel.Font.Style + [fsUnderline];

                               if vgJornalEletronico <> nil then
                                 vgJornalEletronico.Interval := StrToInt(frmSicsProperties.edtJornalEletronicoInterval.Text);

                               dmSicsClientConnection.SendCommandToHost (vlAddress, $27, FormatNumber(4, vlAddress), 0);
                             end;

    tpTV,tpVideo           : begin
                               if(TTipoDePainel(strtoint(Panel.Hint)) <> tpVideo)then
                               begin
                                 PanelVideo := TJvPanel(Self.FindComponent('PanelVideo'+inttostr(No)));
                                 vgTVComponent.SoftwareHomologado  := frmSicsProperties.cboSoftwaresHomologados.ItemIndex;
                                 vgTVComponent.CaminhoDoExecutavel := frmSicsProperties.edCaminhoExecutavel.Text         ;
                                 vgTVComponent.NomeDaJanela        := frmSicsProperties.edNomeJanela.Text                ;
                                 vgTVComponent.Dispositivo         := frmSicsProperties.cbxDispositivo.ItemIndex;
                                 if(StrToIntDef(frmSicsProperties.edtTempoAlternancia.Text,0) <> 0)then
                                 begin
                                  tmrAlternaTVVideo.Enabled := False;
                                  tmrAlternaTVVideo.Interval := StrToIntDef(frmSicsProperties.edtTempoAlternancia.Text,0)*60000;
                                  if(not PanelVideo.Visible)then
                                    tmrAlternaTVVideo.Enabled := true;
                                 end
                                 else
                                 begin
                                  tmrAlternaTVVideo.Enabled := false;
                                  if(vgTVComponent.TempoAlternancia = 0)then
                                    PanelVideo.Visible := false;
                                 end;

                                 vgTVComponent.TempoAlternancia    := StrToIntDef(frmSicsProperties.edtTempoAlternancia.Text,0);
                                 if(frmSicsProperties.edResolucaoPadrao.Text <> '')then
                                  vgResolucaoPadrao                 := frmSicsProperties.edResolucaoPadrao.Text
                                 else
                                  vgResolucaoPadrao                 := '0x0';

                                 if(frmSicsProperties.cbxResolucao.ItemIndex <> -1)then
                                   vgTVComponent.Resolucao           := StrToInt(resolucoes.Strings[frmSicsProperties.cbxResolucao.ItemIndex])
                                 else
                                   vgTVComponent.Resolucao           := -1;

                                 vgTVComponent.PanelVideo := PanelVideo;
                                 vgTVComponent.Panel := Panel;
                                 with Panel do
                                 begin
                                   PanelVideo.Width  := Width;
                                   PanelVideo.Height := Height;
                                   PanelVideo.Left   := Left;
                                   PanelVideo.Top    := Top;
                                 end;
                                 if(vgTVComponent.SoftwareHomologado = 3)then
                                 begin
                                   frmSicsProperties.SetWindowPosition(Panel);
                                 end;

                                 if vgTVComponent.SoftwareHomologado = 6 then
                                 begin
                                   if not Assigned(VideoWindow) then
                                     VideoWindow := TVideoWindow.Create(Panel);

                                   VideoWindow.Parent := Panel;
                                   VideoWindow.Align := alClient;
                                   VideoWindow.FilterGraph := FilterGraph;
                                   VideoWindow.Visible := False;

                                   SysDev:= TSysDevEnum.Create(CLSID_VideoInputDeviceCategory);

                                   if SysDev.CountFilters > 0 then
                                     for i := 0 to SysDev.CountFilters - 1 do
                                     begin
                                       if Pos('USB', SysDev.Filters[i].FriendlyName) > 0 then
                                       begin
                                         FilterGraph.ClearGraph;
                                         FilterGraph.Active := false;
                                         Filter.BaseFilter.Moniker := SysDev.GetMoniker(i);
                                         FilterGraph.Active := true;

                                         with FilterGraph as ICaptureGraphBuilder2 do
                                           RenderStream(@PIN_CATEGORY_PREVIEW, nil, Filter as IBaseFilter, SampleGrabber as IBaseFilter, VideoWindow as IbaseFilter);

                                         Application.ProcessMessages;
                                         FilterGraph.Stop;
                                         FilterGraph.Play;
                                         VideoWindow.Visible := True;
                                         Break;
                                       end;
                                     end;
                                 end;
                               end;

                               ListaVideos            :=  TListBox(Panel.FindComponent('lstVideos' + Inttostr(Panel.Tag)));
                               if((not Assigned(ListaVideos)) and Assigned(PanelVideo))then
                                ListaVideos := TListBox(PanelVideo.FindComponent('lstVideos' + Inttostr(PanelVideo.Tag)));
                               ListaVideos.Items.Text :=  frmSicsProperties.lstVideoFileNames.Items.Text;
                               ListaVideos.ItemIndex  :=  0;
                               if(frmSicsProperties.lstVideoFileNames.Items.Count > 0)then
                               begin
                                 if(TTipoDePainel(strtoint(Panel.Hint)) = tpVideo)then
                                   ExecutarVideo(Panel.Tag);
                               end;

                             end;

    tpIndicadorPerformance : begin
                                 // nao precisa setar neste painel as definicoes feitas no form de configuracoes
                                 // pois para este caso especifico, isto é feito ao renderizar o HTML de acordo com os dados dos PIs
                             end;

         tpPlayListManager : begin
                               vgTVPlayListManager.IDTV                 := StrToInt(frmSicsProperties.edtIDTVPlayListManager.Text);
                               vgTVPlayListManager.TipoBanco            := frmSicsProperties.cbTipoBancoPlayList.ItemIndex;
                               vgTVPlayListManager.HostBanco            := frmSicsProperties.edtHostBancoPlayList.Text;
                               vgTVPlayListManager.PortaBanco           := frmSicsProperties.edtPortaBancoPlayList.Text;
                               vgTVPlayListManager.NomeArquivoBanco     := frmSicsProperties.edtNomeArquivoBancoPlayList.Text;
                               vgTVPlayListManager.UsuarioBanco         := frmSicsProperties.edtUsuarioBancoPlayList.Text;
                               vgTVPlayListManager.SenhaBanco           := frmSicsProperties.edtSenhaBancoPlayList.Text;
                               vgTVPlayListManager.DiretorioLocal       := frmSicsProperties.edtDiretorioLocalPlayList.Text;
                               vgTVPlayListManager.IntervaloVerificacao := StrToIntDef(frmSicsProperties.edtIntervaloVerificacaoPlayList.Text,1);
                             end;
  end;  { case }

  SavePanel (Panel.Tag);

  AlinhaLabelsChamada(Panel);
  AlinhaLabelsUltimasChamadas(Panel);
  AlinhaLabelsDataHora(Panel);

  Result := true;
end;

procedure TfrmSicsTVPrincipal.SetVolumeIni(aVolume: Integer);
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(GetAppIniFileName);
  if IniFile.SectionExists('VisioForge') then
    IniFile.WriteInteger('VisioForge', 'Volume', aVolume);
end;

function TfrmSicsTVPrincipal.SoftwarePadraoTV(AID: Integer): Boolean;
const //1- AverTV, 5-SichboPVR
  IDS_SOFTWAREPADRAO = [1, 5];
begin
  Result := AID in IDS_SOFTWAREPADRAO;
end;

function TfrmSicsTVPrincipal.StatusLiveTv: String;
var LSLStatus          : TStringList;
    LPathArq           : String;
    LTunerPresent      : String;
    LVideoState        : String;
    LVideoError        : String;
    LCurrentUI         : String;
    LLastSubtitleStream: String;
    LCount             : Integer;
begin
  //
  Result   := EmptyStr;
  LPathArq := IncludeTrailingPathDelimiter(ExtractFileDir(Application.ExeName)) + 'Status.txt';
  if FileExists(LPathArq) then
  begin
    LSLStatus := TStringList.Create;
    try
      LSLStatus.LoadFromFile(LPathArq);
      for LCount := 0 to LSLStatus.Count -1 do
      begin
        if LSLStatus.Strings[LCount].Contains('IsTunerPresent') then
          LTunerPresent := Trim(Copy(LSLStatus.Strings[LCount], Pos(':', LSLStatus.Strings[LCount]) + 1))
        else
        if LSLStatus.Strings[LCount].Contains('CurrentVideo.State') then
          LVideoState := Trim(Copy(LSLStatus.Strings[LCount], Pos(':', LSLStatus.Strings[LCount]) + 1))
        else
        if LSLStatus.Strings[LCount].Contains('CurrentVideo.Error') then
          LVideoError := Trim(Copy(LSLStatus.Strings[LCount], Pos(':', LSLStatus.Strings[LCount]) + 1))
        else
        if LSLStatus.Strings[LCount].Contains('CurrentUI') then
          LCurrentUI := Trim(Copy(LSLStatus.Strings[LCount], Pos(':', LSLStatus.Strings[LCount]) + 1))
        else
        if LSLStatus.Strings[LCount].Contains('LastSubtitleStream') then
          LLastSubtitleStream := Trim(Copy(LSLStatus.Strings[LCount], Pos(':', LSLStatus.Strings[LCount]) + 1))

      end;
    finally
      FreeAndNil(LSLStatus);
    end;
  end;
  Result := LTunerPresent + TAB + LVideoState + TAB + LVideoError + TAB + LCurrentUI + TAB + LLastSubtitleStream;
end;

{ func SetPanelProperties }
function TfrmSicsTVPrincipal.CreatePanel (no : integer; Tipo : TTipoDePainel;criarPainelVideoTV : boolean) : boolean;
var
  Panel                : TJvPanel;
  Image                : TJvImage;
  WebBrowser           : TWebBrowser;
  MediaPlayer          : TMediaPlayer;
  Flash                : TShockwaveFlash;
  MediaPlayerVideo     : TMediaPlayer;
  ListaVideo           : TListBox;
  TimerMonitoraVideo   : TTimer;
  MediaPlayList        : TWindowsMediaPlayer;
  ImagePlayList        : TJvImage;
  TimerPlayList        : TTimer;
begin
  // se for TV permito apenas uma instancia
  if (Tipo = tpTV) and (vgTVComponent.ParentHandle > 0) then
  begin
    MessageDlg('Já existe um quadro para TV', mtInformation, [mbOk], 0);
    Result := False;
    Exit;
  end;

  // se for Jornal Eletronico permito apenas uma instancia
  if (Tipo = tpJornalEletronico) and (vgJornalEletronico <> nil) then
  begin
    MessageDlg('Já existe um quadro para Jornal Eletrônico', mtInformation, [mbOk], 0);
    Result := False;
    Exit;
  end;

  try
    Panel := TJvPanel.Create(Self);
    with Panel do
    begin
      Parent       := Self;
      Left         := 10;
      Top          := 10;
      if(criarPainelVideoTV)then
        Name         := 'PanelVideo' + inttostr(No)
      else
        Name         := 'Panel' + inttostr(No);
      BevelOuter   := bvNone;
      Caption      := '';
      Tag          := No;
      Movable      := false;
      Sizeable     := false;
      Hint         := inttostr(ord(Tipo));
      if Tipo = tpFlash then
        BorderWidth  := 1;
      if (((Tipo = tpChamadaSenha) and (vgParametrosModulo.ChamadaInterrompeVideo) and (gfInitializing))) then
        Visible := false;
      OnDblClick   := PanelDblClick;
      OnMouseLeave := PanelMouseLeave;
      OnMouseMove  := FormMouseMove;
      PopupMenu    := menuPopup;
      OnAfterMove  := PanelAfterMove;
    end;

    if(not criarPainelVideoTV)then
      frmSicsProperties.AdicionarPanelNaLista(Panel);

    if Tipo = tpFlash then
    begin
      Flash := TShockwaveFlash.Create(Panel);
      with Flash do
      begin
        Parent       := Panel;
        Align        := alClient;
        Loop         := true;
        Name         := 'Flash' + inttostr(No);
        Tag          := No;
        OnMouseMove  := FormMouseMove;
      end;
    end;

    if Tipo = tpIndicadorPerformance then
    begin
      WebBrowser := TWebBrowser.Create(Panel);
      with TWinControl(WebBrowser) do
      begin
        Parent             := Panel;
        Align              := alClient;
        Name               := 'WebBrowser' + inttostr(No);
        Tag                := No;
        OnMouseMove        := FormMouseMove;
      end;
      with WebBrowser do
      begin
        OnDocumentComplete := WebBrowserOnDocumentComplete;
      end;
    end;

    if Tipo = tpChamadaSenha then
    begin
      MediaPlayer := TMediaPlayer.Create(Panel);
      with MediaPlayer do
      begin
        Parent     := Panel;
        AutoOpen   := True ;
        Visible    := False;
        Name       := 'MediaPlayer' + inttostr(No);
        Tag        := No;
      end;
    end;

    if Tipo = tpVideo then
    begin
      MediaPlayerVideo := TMediaPlayer.Create(Panel);
      with MediaPlayerVideo do
      begin
        Parent      := Panel;
        AutoOpen    := True ;
        Visible     := False;
        Name        := 'MediaPlayerVideos' + inttostr(No);
        Tag         := No;
        Display     := Panel;
        DisplayRect := Panel.ClientRect;
        Notify      := True;
        DeviceType  := dtAutoSelect;
      end;

      ListaVideo := TListBox.Create(Panel);
      with ListaVideo do
      begin
        Parent := Panel;
        Name   := 'lstVideos' + Inttostr(No);
        Tag    := No;
        Visible:= False;
      end;
      TimerMonitoraVideo :=  TTimer.Create(Panel);
      with TimerMonitoraVideo do
      begin
        Name := 'tmrVerificaTerminoVideo'+IntToStr(No);
        Tag := No;
        OnTimer := tmrVerificaTerminoVideoTimer;
        Enabled := false;
      end;
    end;

    if Tipo = tpTV then
    begin
      vgTVComponent.ParentHandle := Panel.Handle;
    end;

    if Tipo = tpJornalEletronico then
    begin
      vgJornalEletronico := TRealTimeMarquee.Create(Panel);
      with vgJornalEletronico do
      begin
        Parent      := Panel;
        Align       := alClient;
        AutoSize    := False;
        Name        := 'JornalEletronico' + inttostr(No);
        Tag         := No;
        OnMouseMove := FormMouseMove;
        PopupMenu   := menuPopup;
      end;
    end;

    if Tipo = tpPlayListManager then
    begin
      MediaPlayList             := TWindowsMediaPlayer.Create(Panel);
      MediaPlayList.Parent      := Panel;
      MediaPlayList.Align       := alClient;
      MediaPlayList.Visible     := False;
      MediaPlayList.Name        := 'MediaPlayList' + inttostr(No);
      MediaPlayList.Tag         := No;
      MediaPlayList.enableContextMenu := False;
      MediaPlayList.uiMode      := 'None';
      MediaPlayList.OnPlayStateChange := WMPlayStateChange;

      ImagePlayList             := TJvImage.Create(Panel);
      ImagePlayList.Parent      := Panel;
      ImagePlayList.Align       := TAlign.alClient;
      ImagePlayList.Stretch     := true;
      ImagePlayList.Visible     := False;
      ImagePlayList.Name        := 'ImagePlayList' + inttostr(No);
      ImagePlayList.Tag         := No;

      TimerPlayList             := TTimer.Create(Panel);
      TimerPlayList.Name        := 'TimerPlayList'+IntToStr(No);
      TimerPlayList.Tag         := No;
      TimerPlayList.OnTimer     := EventoTimePlayList;
      TimerPlayList.Enabled     := False;

      FItemAtualPlayListManager                := 0;
    end;

    Image := TJvImage.Create(Panel);
    with Image do
    begin
      Parent       := Panel;
      Align        := alClient;
      Name         := 'BackgroundImage' + inttostr(No);
      Tag          := No;
      Stretch      := true;
      OnDblClick   := PanelDblClick;
      OnMouseMove  := FormMouseMove;
      PopupMenu    := menuPopup;
    end;

    vgPainelSelecionado := No;
    GetPanelProperties(Panel);

    Result := true;
  except on E: Exception do
    begin
      Result := false;
      Assert(False);
    end;
  end;
end;

function TfrmSicsTVPrincipal.CriaVideoCaptura(LPanel: TPanel): Boolean;
var IniFile : TIniFile;
begin
  try
    if not Assigned(VFVideoCapture) then
      VFVideoCapture  := TVFVideoCapture.Create(Self);

    VFVideoCapture.Parent := LPanel;
    VFVideoCapture.Align  := TAlign.alClient;

    VFVideoCapture.Audio_CaptureDevice := 'LGPLite Stream Engine Audio';
    VFVideoCapture.Audio_CaptureDevice_Formats_Fill;
    VFVideoCapture.Audio_CaptureDevice_Lines_Fill;

    VFVideoCapture.Screen_Zoom_Ratio := 0;
    VFVideoCapture.Screen_Zoom_ShiftX := 0;
    VFVideoCapture.Screen_Zoom_ShiftY := 0;

    VFVideoCapture.Audio_PlayAudio := True;

    if VFVideoCapture.Filter_Supported_VMR9 then
      VFVideoCapture.Video_Renderer := VR_VMR9
    else
      VFVideoCapture.Video_Renderer := VR_VideoRenderer;

    VFVideoCapture.Video_CaptureDevice               := 'LGPLite Stream Engine';
    VFVideoCapture.Video_CaptureDevice_IsAudioSource := False;
    VFVideoCapture.Audio_OutputDevice                := 'Default DirectSound Device';
    VFVideoCapture.Audio_CaptureFormat_UseBest       := True;

    VFVideoCapture.Video_FrameRate := 30;

    VFVideoCapture.Mode := Mode_Video_Preview;

     VFVideoCapture.Video_Effects_Enabled := true;
    VFVideoCapture.Video_Effects_Clear;

    //Add deinterlace
    VFVideoCapture.Video_Effects_Deinterlace_CAVT(1, 0, 0, True, 20);

    //Audio processing
    VFVideoCapture.Audio_Effects_Clear;
    VFVideoCapture.Audio_Effects_Enabled := true;

    VFVideoCapture.Audio_Effects_Add(AE_Amplify, false);
    VFVideoCapture.Audio_Effects_Add(AE_Equalizer, false);
    VFVideoCapture.Audio_Effects_Add(AE_TrueBass, false);

    IniFile := TIniFile.Create(GetAppIniFileName);
    if not IniFile.SectionExists('VisioForge') then
      IniFile.WriteInteger('VisioForge', 'Volume' , 800)
    else
      LVolume := IniFile.ReadInteger('VisioForge', 'Volume' , 800);

    VFVideoCapture.Start;
    Delay(3000);
    VFVideoCapture.Audio_OutputDevice_SetVolume(LVolume);
  except on E: Exception do
    begin
      Assert(False);
      Result := False;
    end;
  end;
end;

{ proc CreatePanel }


{=============================================================================}
{ PROCEDURES DE DECIFRAR PROTOCOLOS                                           }

function TfrmSicsTVPrincipal.DecifraProtocolo (s : string; Socket : TCustomWinSocket): String;
var
  aux1, aux2, aux3, aux4, aux5, ProtData  : string;
  VersaoProtocolo, Adr, Id, i             : integer;
  Comando                                 : Char;
  TipoAjuste                              : TTipoAjuste;
  ValorAjuste                             : TValorAjuste;
begin
  Result := EmptyStr;
   try
    if ((s <> '') and (s[1] = STX) and (s[length(s)] = ETX)) then
    begin
      VersaoProtocolo := StrToInt('$'+s[2]+s[3]+s[4]+s[5]);
      Adr             := StrToInt('$'+s[6]+s[7]+s[8]+s[9]);
      Comando         := s[10];
      ProtData        := Copy(s,11,Length(s)-11);
      if ((Adr = vlAddress) or (Adr = 00)) then
      begin
        case Comando of
          Chr($2B) : begin
                       Beep;

                       aux1 := Copy(ProtData, 5, length(ProtData) - 4);

                       if vgJornalEletronico <> nil then
                       begin
                        if vgJornalEletronico.Items.Count = 0 then
                          vgJornalEletronico.Items.Add;
                        vgJornalEletronico.Items[0].Text := aux1;
                        vgJornalEletronico.Active := True;
                        TextoOriginalJornalEletronico := aux1;
                       end;
                     end;  { case Chr($2B) }
          Chr($33) : begin
                       MyLogException(Exception.Create('Comando não suportado pelo servidor.'));
                     end;  { case 33 }
          Chr($73) : begin
                       Beep;
                       Beep;
                       if ProtData = '' then
                         ChamaSenha(0, '', '', '','')
                       else
                       begin
                         aux1 := Copy (ProtData, 1, 4);
                         aux2 := Copy (ProtData, 5, length(ProtData)-4);
                         SeparaStrings(aux2, ';', aux2, aux3);
                         SeparaStrings(aux3, ';', aux3, aux4);
                         SeparaStrings(aux4, ';', aux4, aux5);

                         ChamaSenha(strtoint('$'+aux1), aux2, aux3, aux4, aux5);
                       end;
                     end;  { case 73 }
 		      Chr($88) : begin

                     end;  { case 88 }
 		      Chr($89) : begin
                       if strtoint('$' + Copy(ProtData, 1, 4)) = vgIdTV then
                       begin
                         with cdsTVCanais do
                         begin
                           if not Active then
                             CreateDataSet
                           else
                             EmptyDataSet;
                         end;

                         aux1 := Copy(ProtData, 5, length(ProtData) - 4);
                         aux2 := '';
                         for i := 1 to length (aux1) do
                         begin
                           if aux1[i] = TAB then
                           begin
                             Id   := StrToInt('$'+aux2[1]+aux2[2]+aux2[3]+aux2[4]);
                             SeparaStrings(Copy(aux2, 5, length(aux2)-4),';', aux2, aux3);

                             with cdsTVCanais do
                             begin
                               Append;
                               FieldByName('ID').AsInteger := Id;
                               FieldByName('NOME').AsString := aux2;
                               FieldByName('FREQUENCIA').AsString := Copy(aux3, 1, length(aux3)-1);
                               Post;
                             end;

                             if aux3[length(aux3)] = '1' then
                               vgTVCanalPadrao := Id;

                             aux2 := '';
                           end
                           else if aux1[i] <> ETX then
                             aux2 := aux2 + aux1[i];
                         end;
                       end;
                     end;  { case 89 }

// 		      Chr($8B) : begin
//                       if strtoint('$' + Copy(ProtData, 1, 4)) = vgIdTV then
//                       begin
//                         vgTVCanalPadrao := StrToInt('$'+Copy(ProtData, 5, 4));
//                         MudarCanalTV(vgTVCanalPadrao);
//                       end;
//                     end;  { case 8B }

          Chr($A4) : begin
                       case ProtData[1] of
                         'C' : TipoAjuste := taCanal;
                         'V' : TipoAjuste := taVolume;
                         'T' : TipoAjuste := taClosedCaption;
                       end;

                       case ProtData[2] of
                         '+' : ValorAjuste := vaSubir;
                         '-' : ValorAjuste := vaDescer;
                       end;

                       AjustarTVVolumeOuCanal(TipoAjuste,ValorAjuste);
                     end;

          Chr($A5) : begin
                       Result := '0000' + Chr($A6) + BuscaHorarioUltimaAtualizacaoPlayList;
                     end;

          Chr($A7) : begin
                       Result := '0000' + Chr($A8) + StatusLiveTv;
                     end;

         else begin
              end;  { case else }
        end;  { case }
      end;
    end;  { if s <> '' }
  except
    on E: Exception do
    begin
      //Application.MessageBox('Erro ao decifrar protocolo TCP/IP.', 'Erro', MB_ICONSTOP);
      MyLogException (Exception.Create ('Erro ao decifrar protocolo TCP/IP (serverport): "' +
                                        s + '" / Remote: "' + Socket.RemoteAddress + '" / Erro: "' + E.Message + '"'));
    end;
  end;  { try .. except }
end;  { proc DecifraProtocolo }

procedure TfrmSicsTVPrincipal.CreateLabelsChamada (Panel : TJvPanel);
var
  lbl1, lbl2, lbl3  : TASPLabel;
  i                 : integer;
begin
  for i := Panel.ComponentCount - 1 downto 0 do
    if ((Pos('lblSenha', Panel.Components[i].Name) = 1) or (Pos('lblPA', Panel.Components[i].Name) = 1) or (Pos('lblNomeCliente', Panel.Components[i].Name) = 1)) then
      Panel.Components[i].Destroy;

  lbl1 := TASPLabel.Create(Panel);
  with lbl1 do
  begin
    Parent       := Panel;
    AutoSize     := false;
    WordWrap     := false;
    Left         := 10;
    Top          := 10;
    Name         := 'lblSenha' + inttostr(Panel.Tag);
    Caption      := '---';
    Transparent  := true;
    PopupMenu    := menuPopup;
    OnMouseMove  := FormMouseMove;
    OnDblClick   := PanelDblClick;
    Tag          := Panel.Tag;

    // efeito piscante
    Interval   := 500;
    Delay      := 300;
    BlinkCount := 5;
  end;

  lbl2 := TASPLabel.Create(Panel);
  with lbl2 do
  begin
    Parent       := Panel;
    AutoSize     := false;
    WordWrap     := false;
    Left         := 10;
    Top          := 10;
    Name         := 'lblPA' + inttostr(Panel.Tag);
    Caption      := '---';
    Transparent  := true;
    PopupMenu    := menuPopup;
    OnMouseMove  := FormMouseMove;
    OnDblClick   := PanelDblClick;
    Tag          := Panel.Tag;
  end;

  lbl3 := TASPLabel.Create(Panel);
  with lbl3 do
  begin
    Parent       := Panel;
    AutoSize     := false;
    WordWrap     := false;
    Left         := 10;
    Top          := 10;
    Name         := 'lblNomeCliente' + inttostr(Panel.Tag);
    Caption      := '---';
    Transparent  := true;
    PopupMenu    := menuPopup;
    OnMouseMove  := FormMouseMove;
    OnDblClick   := PanelDblClick;
    Tag          := Panel.Tag;

    // efeito piscante
    Interval   := 500;
    Delay      := 300;
    BlinkCount := 5;
  end;
end;  { proc CreateLabelsChamada }


procedure TfrmSicsTVPrincipal.CreateLabelsUltimasChamadas (Panel : TJvPanel; Numero : integer);
var
  i : integer;
begin
  for i := Panel.ComponentCount - 1 downto 0 do
    if ((Pos('lblUltimaSenha', Panel.Components[i].Name) = 1) or (Pos('lblUltimaPA', Panel.Components[i].Name) = 1) or (Pos('lblUltimoNomeCliente', Panel.Components[i].Name) = 1)) then
      Panel.Components[i].Destroy;

  for i := 1 to Numero do
  begin
    with TLabel.Create(Panel) do
    begin
      Parent       := Panel;
      AutoSize     := false;
      WordWrap     := false;
      Left         := 10;
      Top          := 10;
      Name         := 'lblUltimaSenha' + FormatNumber(3,i) + inttostr(Panel.Tag);
      Caption      := '---';
      Transparent  := true;
      PopupMenu    := menuPopup;
      OnMouseMove  := FormMouseMove;
      OnDblClick   := PanelDblClick;
      Tag          := Panel.Tag;
    end;

    with TLabel.Create(Panel) do
    begin
      Parent       := Panel;
      AutoSize     := false;
      WordWrap     := false;
      Left         := 10;
      Top          := 10;
      Name         := 'lblUltimaPA' + FormatNumber(3,i) + inttostr(Panel.Tag);
      Caption      := '---';
      Transparent  := true;
      PopupMenu    := menuPopup;
      OnMouseMove  := FormMouseMove;
      OnDblClick   := PanelDblClick;
      Tag          := Panel.Tag;
    end;

    with TLabel.Create(Panel) do
    begin
      Parent       := Panel;
      AutoSize     := false;
      WordWrap     := false;
      Left         := 10;
      Top          := 10;
      Name         := 'lblUltimoNomeCliente' + FormatNumber(3,i) + inttostr(Panel.Tag);
      Caption      := '---';
      Transparent  := true;
      PopupMenu    := menuPopup;
      OnMouseMove  := FormMouseMove;
      OnDblClick   := PanelDblClick;
      Tag          := Panel.Tag;
    end;
  end;
end;  { proc CreateLabelsUltimasChamadas }


procedure TfrmSicsTVPrincipal.CreateLabelsDataHora (Panel : TJvPanel; Formato : string);
var
  lbl1  : TLabel;
  i     : integer;
begin
  for i := Panel.ComponentCount - 1 downto 0 do
    if Pos('lblDataHora', Panel.Components[i].Name) = 1 then
      Panel.Components[i].Destroy;

  lbl1 := TLabel.Create(Panel);
  with lbl1 do
  begin
    Parent       := Panel;
    Alignment    := taCenter;
    AutoSize     := false;
    Left         := 10;
    Top          := 10;
    Name         := 'lblDataHora' + inttostr(Panel.Tag);
    Caption      := '---';
    Hint         := Formato;
    Transparent  := true;
    PopupMenu    := menuPopup;
    OnMouseMove  := FormMouseMove;
    OnDblClick   := PanelDblClick;
    Tag          := Panel.Tag;
  end;
end;  { proc CreateLabelsDataHora }

procedure TfrmSicsTVPrincipal.AlinhaLabelsChamada (Panel : TJvPanel);
begin
  if ((GetPanelProperties(panel)) and (Panel.FindComponent('lblSenha'+inttostr(panel.Tag)) <> nil) and (Panel.FindComponent('lblPA'+inttostr(panel.Tag)) <> nil) and (Panel.FindComponent('lblNomeCliente'+inttostr(panel.Tag)) <> nil)) then
  begin
    (Panel.FindComponent('lblSenha'      +inttostr(panel.Tag)) as TLabel).Visible  := frmSicsProperties.chkChamadaDeSenhasLayoutMostrarSenha      .Checked;
    (Panel.FindComponent('lblPA'         +inttostr(panel.Tag)) as TLabel).Visible  := frmSicsProperties.chkChamadaDeSenhasLayoutMostrarPA         .Checked;
    (Panel.FindComponent('lblNomeCliente'+inttostr(panel.Tag)) as TLabel).Visible  := frmSicsProperties.chkChamadaDeSenhasLayoutMostrarNomeCliente.Checked;

    if frmSicsProperties.btnChamadaDeSenhasLayoutSenhaAlinhaEsquerda.Down then
      (Panel.FindComponent('lblSenha'      +inttostr(panel.Tag)) as TLabel).Alignment := taLeftJustify
    else if frmSicsProperties.btnChamadaDeSenhasLayoutSenhaAlinhaCentro.Down then
      (Panel.FindComponent('lblSenha'      +inttostr(panel.Tag)) as TLabel).Alignment := taCenter
    else
      (Panel.FindComponent('lblSenha'      +inttostr(panel.Tag)) as TLabel).Alignment := taRightJustify;

    if frmSicsProperties.btnChamadaDeSenhasLayoutPAAlinhaEsquerda.Down then
      (Panel.FindComponent('lblPA'      +inttostr(panel.Tag)) as TLabel).Alignment := taLeftJustify
    else if frmSicsProperties.btnChamadaDeSenhasLayoutPAAlinhaCentro.Down then
      (Panel.FindComponent('lblPA'      +inttostr(panel.Tag)) as TLabel).Alignment := taCenter
    else
      (Panel.FindComponent('lblPA'      +inttostr(panel.Tag)) as TLabel).Alignment := taRightJustify;

    if frmSicsProperties.btnChamadaDeSenhasLayoutNomeClienteAlinhaEsquerda.Down then
      (Panel.FindComponent('lblNomeCliente'      +inttostr(panel.Tag)) as TLabel).Alignment := taLeftJustify
    else if frmSicsProperties.btnChamadaDeSenhasLayoutNomeClienteAlinhaCentro.Down then
      (Panel.FindComponent('lblNomeCliente'      +inttostr(panel.Tag)) as TLabel).Alignment := taCenter
    else
      (Panel.FindComponent('lblNomeCliente'      +inttostr(panel.Tag)) as TLabel).Alignment := taRightJustify;

    (Panel.FindComponent('lblSenha'+inttostr(panel.Tag)) as TLabel).Left   := strtoint(frmSicsProperties.edChamadaDeSenhasLayoutSenhaX   .Text);
    (Panel.FindComponent('lblSenha'+inttostr(panel.Tag)) as TLabel).Top    := strtoint(frmSicsProperties.edChamadaDeSenhasLayoutSenhaY   .Text);
    (Panel.FindComponent('lblSenha'+inttostr(panel.Tag)) as TLabel).Width  := strtoint(frmSicsProperties.edChamadaDeSenhasLayoutSenhaLarg.Text);
    (Panel.FindComponent('lblSenha'+inttostr(panel.Tag)) as TLabel).Height := strtoint(frmSicsProperties.edChamadaDeSenhasLayoutSenhaAlt .Text);

    (Panel.FindComponent('lblPA'+inttostr(panel.Tag)) as TLabel).Left   := strtoint(frmSicsProperties.edChamadaDeSenhasLayoutPAX   .Text);
    (Panel.FindComponent('lblPA'+inttostr(panel.Tag)) as TLabel).Top    := strtoint(frmSicsProperties.edChamadaDeSenhasLayoutPAY   .Text);
    (Panel.FindComponent('lblPA'+inttostr(panel.Tag)) as TLabel).Width  := strtoint(frmSicsProperties.edChamadaDeSenhasLayoutPALarg.Text);
    (Panel.FindComponent('lblPA'+inttostr(panel.Tag)) as TLabel).Height := strtoint(frmSicsProperties.edChamadaDeSenhasLayoutPAAlt .Text);

    (Panel.FindComponent('lblNomeCliente'+inttostr(panel.Tag)) as TLabel).Left   := strtoint(frmSicsProperties.edChamadaDeSenhasLayoutNomeClienteX   .Text);
    (Panel.FindComponent('lblNomeCliente'+inttostr(panel.Tag)) as TLabel).Top    := strtoint(frmSicsProperties.edChamadaDeSenhasLayoutNomeClienteY   .Text);
    (Panel.FindComponent('lblNomeCliente'+inttostr(panel.Tag)) as TLabel).Width  := strtoint(frmSicsProperties.edChamadaDeSenhasLayoutNomeClienteLarg.Text);
    (Panel.FindComponent('lblNomeCliente'+inttostr(panel.Tag)) as TLabel).Height := strtoint(frmSicsProperties.edChamadaDeSenhasLayoutNomeClienteAlt .Text);

    (Panel.FindComponent('lblSenha'      +inttostr(panel.Tag)) as TLabel).Transparent := false;
    (Panel.FindComponent('lblPA'         +inttostr(panel.Tag)) as TLabel).Transparent := false;
    (Panel.FindComponent('lblNomeCliente'+inttostr(panel.Tag)) as TLabel).Transparent := false;
    (Panel.FindComponent('lblSenha'      +inttostr(panel.Tag)) as TLabel).Caption := '---';
    (Panel.FindComponent('lblPA'         +inttostr(panel.Tag)) as TLabel).Caption := '---';
    (Panel.FindComponent('lblNomeCliente'+inttostr(panel.Tag)) as TLabel).Caption := '---';
    Delay(3000);
    (Panel.FindComponent('lblSenha'      +inttostr(panel.Tag)) as TAspLabel).Transparent := true;
    (Panel.FindComponent('lblPA'         +inttostr(panel.Tag)) as TAspLabel).Transparent := true;
    (Panel.FindComponent('lblNomeCliente'+inttostr(panel.Tag)) as TAspLabel).Transparent := true;
  end;  { if get }
end;


procedure TfrmSicsTVPrincipal.AlinhaLabelsUltimasChamadas (Panel : TJvPanel);

  function MaxFrom3 (A, B, C : integer) : integer;
  begin
    Result := A;
    if B > A then
      Result := B;
    if C > Result then
      Result := C;
  end;

var
  i, XAtual, YAtual, NumeroDeChamadas  : integer;
  DisposicaoEmLinhas                   : boolean;
begin
  NumeroDeChamadas := 0;
  for i := 0 to Panel.ComponentCount - 1 do
    if Pos('lblUltimaSenha', Panel.Components[i].Name) = 1 then
      NumeroDeChamadas := NumeroDeChamadas + 1;

  if ((NumeroDeChamadas > 0) and (NumeroDeChamadas <= cgMaxChamadas)) then
  begin
    if GetPanelProperties(panel) then
    begin
      DisposicaoEmLinhas := frmSicsProperties.rbUltimasChamadasDisposicaoEmLinhas.Checked;
      XAtual := 0;
      YAtual := 0;

      for i := 1 to NumeroDeChamadas do
      begin
        (Panel.FindComponent('lblUltimaSenha'      +FormatNumber(3,i)+inttostr(panel.Tag)) as TLabel).Visible  := frmSicsProperties.chkUltimasChamadasLayoutMostrarSenha      .Checked;
        (Panel.FindComponent('lblUltimaPA'         +FormatNumber(3,i)+inttostr(panel.Tag)) as TLabel).Visible  := frmSicsProperties.chkUltimasChamadasLayoutMostrarPA         .Checked;
        (Panel.FindComponent('lblUltimoNomeCliente'+FormatNumber(3,i)+inttostr(panel.Tag)) as TLabel).Visible  := frmSicsProperties.chkUltimasChamadasLayoutMostrarNomeCliente.Checked;

        if frmSicsProperties.btnUltimasChamadasLayoutSenhaAlinhaEsquerda.Down then
          (Panel.FindComponent('lblUltimaSenha'      +FormatNumber(3,i)+inttostr(panel.Tag)) as TLabel).Alignment := taLeftJustify
        else if frmSicsProperties.btnUltimasChamadasLayoutSenhaAlinhaCentro.Down then
          (Panel.FindComponent('lblUltimaSenha'      +FormatNumber(3,i)+inttostr(panel.Tag)) as TLabel).Alignment := taCenter
        else
          (Panel.FindComponent('lblUltimaSenha'      +FormatNumber(3,i)+inttostr(panel.Tag)) as TLabel).Alignment := taRightJustify;

        if frmSicsProperties.btnUltimasChamadasLayoutPAAlinhaEsquerda.Down then
          (Panel.FindComponent('lblUltimaPA'         +FormatNumber(3,i)+inttostr(panel.Tag)) as TLabel).Alignment := taLeftJustify
        else if frmSicsProperties.btnUltimasChamadasLayoutPAAlinhaCentro.Down then
          (Panel.FindComponent('lblUltimaPA'         +FormatNumber(3,i)+inttostr(panel.Tag)) as TLabel).Alignment := taCenter
        else
          (Panel.FindComponent('lblUltimaPA'         +FormatNumber(3,i)+inttostr(panel.Tag)) as TLabel).Alignment := taRightJustify;

        if frmSicsProperties.btnUltimasChamadasLayoutNomeClienteAlinhaEsquerda.Down then
          (Panel.FindComponent('lblUltimoNomeCliente'+FormatNumber(3,i)+inttostr(panel.Tag)) as TLabel).Alignment := taLeftJustify
        else if frmSicsProperties.btnUltimasChamadasLayoutNomeClienteAlinhaCentro.Down then
          (Panel.FindComponent('lblUltimoNomeCliente'+FormatNumber(3,i)+inttostr(panel.Tag)) as TLabel).Alignment := taCenter
        else
          (Panel.FindComponent('lblUltimoNomeCliente'+FormatNumber(3,i)+inttostr(panel.Tag)) as TLabel).Alignment := taRightJustify;

        (Panel.FindComponent('lblUltimaSenha'+FormatNumber(3,i)+inttostr(panel.Tag)) as TLabel).Left   := XAtual + StrToIntDef(frmSicsProperties.edUltimasChamadasLayoutSenhaX   .Text, 0);
        (Panel.FindComponent('lblUltimaSenha'+FormatNumber(3,i)+inttostr(panel.Tag)) as TLabel).Top    := YAtual + StrToIntDef(frmSicsProperties.edUltimasChamadasLayoutSenhaY   .Text, 0);
        (Panel.FindComponent('lblUltimaSenha'+FormatNumber(3,i)+inttostr(panel.Tag)) as TLabel).Width  := StrToIntDef(frmSicsProperties.edUltimasChamadasLayoutSenhaLarg.Text, 0);
        (Panel.FindComponent('lblUltimaSenha'+FormatNumber(3,i)+inttostr(panel.Tag)) as TLabel).Height := StrToIntDef(frmSicsProperties.edUltimasChamadasLayoutSenhaAlt .Text, 0);

        (Panel.FindComponent('lblUltimaPA'+FormatNumber(3,i)+inttostr(panel.Tag)) as TLabel).Left   := XAtual + StrToIntDef(frmSicsProperties.edUltimasChamadasLayoutPAX   .Text, 0);
        (Panel.FindComponent('lblUltimaPA'+FormatNumber(3,i)+inttostr(panel.Tag)) as TLabel).Top    := YAtual + StrToIntDef(frmSicsProperties.edUltimasChamadasLayoutPAY   .Text, 0);
        (Panel.FindComponent('lblUltimaPA'+FormatNumber(3,i)+inttostr(panel.Tag)) as TLabel).Width  := StrToIntDef(frmSicsProperties.edUltimasChamadasLayoutPALarg.Text, 0);
        (Panel.FindComponent('lblUltimaPA'+FormatNumber(3,i)+inttostr(panel.Tag)) as TLabel).Height := StrToIntDef(frmSicsProperties.edUltimasChamadasLayoutPAAlt .Text, 0);

        (Panel.FindComponent('lblUltimoNomeCliente'+FormatNumber(3,i)+inttostr(panel.Tag)) as TLabel).Left   := XAtual + StrToIntDef(frmSicsProperties.edUltimasChamadasLayoutNomeClienteX   .Text, 0);
        (Panel.FindComponent('lblUltimoNomeCliente'+FormatNumber(3,i)+inttostr(panel.Tag)) as TLabel).Top    := YAtual + StrToIntDef(frmSicsProperties.edUltimasChamadasLayoutNomeClienteY   .Text, 0);
        (Panel.FindComponent('lblUltimoNomeCliente'+FormatNumber(3,i)+inttostr(panel.Tag)) as TLabel).Width  := StrToIntDef(frmSicsProperties.edUltimasChamadasLayoutNomeClienteLarg.Text, 0);
        (Panel.FindComponent('lblUltimoNomeCliente'+FormatNumber(3,i)+inttostr(panel.Tag)) as TLabel).Height := StrToIntDef(frmSicsProperties.edUltimasChamadasLayoutNomeClienteAlt .Text, 0);

        if DisposicaoEmLinhas then
          YAtual := MaxFrom3 ( (Panel.FindComponent('lblUltimaSenha'      +FormatNumber(3,i)+inttostr(panel.Tag)) as TLabel).Top + (Panel.FindComponent('lblUltimaSenha'      +FormatNumber(3,i)+inttostr(panel.Tag)) as TLabel).Height,
                               (Panel.FindComponent('lblUltimaPA'         +FormatNumber(3,i)+inttostr(panel.Tag)) as TLabel).Top + (Panel.FindComponent('lblUltimaPA'         +FormatNumber(3,i)+inttostr(panel.Tag)) as TLabel).Height,
                               (Panel.FindComponent('lblUltimoNomeCliente'+FormatNumber(3,i)+inttostr(panel.Tag)) as TLabel).Top + (Panel.FindComponent('lblUltimoNomeCliente'+FormatNumber(3,i)+inttostr(panel.Tag)) as TLabel).Height)
                    + StrToIntDef(frmSicsProperties.edUltimasChamadasEspacamento.Text, 0)
        else
          XAtual := MaxFrom3 ( (Panel.FindComponent('lblUltimaSenha'      +FormatNumber(3,i)+inttostr(panel.Tag)) as TLabel).Left + (Panel.FindComponent('lblUltimaSenha'      +FormatNumber(3,i)+inttostr(panel.Tag)) as TLabel).Width,
                               (Panel.FindComponent('lblUltimaPA'         +FormatNumber(3,i)+inttostr(panel.Tag)) as TLabel).Left + (Panel.FindComponent('lblUltimaPA'         +FormatNumber(3,i)+inttostr(panel.Tag)) as TLabel).Width,
                               (Panel.FindComponent('lblUltimoNomeCliente'+FormatNumber(3,i)+inttostr(panel.Tag)) as TLabel).Left + (Panel.FindComponent('lblUltimoNomeCliente'+FormatNumber(3,i)+inttostr(panel.Tag)) as TLabel).Width)
                    + StrToIntDef(frmSicsProperties.edUltimasChamadasEspacamento.Text, 0)

      end;  { for i }

      for i := 1 to NumeroDeChamadas do
      begin
        (Panel.FindComponent('lblUltimaSenha'      +FormatNumber(3,i)+inttostr(panel.Tag)) as TLabel).Transparent := false;
        (Panel.FindComponent('lblUltimaPA'         +FormatNumber(3,i)+inttostr(panel.Tag)) as TLabel).Transparent := false;
        (Panel.FindComponent('lblUltimoNomeCliente'+FormatNumber(3,i)+inttostr(panel.Tag)) as TLabel).Transparent := false;
        (Panel.FindComponent('lblUltimaSenha'      +FormatNumber(3,i)+inttostr(panel.Tag)) as TLabel).Caption := '888';
        (Panel.FindComponent('lblUltimaPA'         +FormatNumber(3,i)+inttostr(panel.Tag)) as TLabel).Caption := '88';
        (Panel.FindComponent('lblUltimoNomeCliente'+FormatNumber(3,i)+inttostr(panel.Tag)) as TLabel).Caption := 'NONONONO';
      end;
      Delay(3000);
      for i := 1 to NumeroDeChamadas do
      begin
        (Panel.FindComponent('lblUltimaSenha'      +FormatNumber(3,i)+inttostr(panel.Tag)) as TLabel).Transparent := true;
        (Panel.FindComponent('lblUltimaPA'         +FormatNumber(3,i)+inttostr(panel.Tag)) as TLabel).Transparent := true;
        (Panel.FindComponent('lblUltimoNomeCliente'+FormatNumber(3,i)+inttostr(panel.Tag)) as TLabel).Transparent := true;
      end;
    end;  { if get }
  end;

  AtualizaPanelsUltimasChamadas('', '', '', 0);
end;

function TfrmSicsTVPrincipal.ArrayOfByte_AnsiStringToString(
  a: AnsiString): String;
var
  i : integer;
begin
  Result := '';
  for i := 1 to length(a) do
    Result := Result + Chr(ord(a[i]));
end;

function TfrmSicsTVPrincipal.ArrayOfByte_StringToAnsiString(
  s: string): AnsiString;
var
  i : integer;
begin
  Result := '';
  for i := 1 to length(s) do
  begin
    if Ord(s[i]) <= 255 then
      Result := Result + AnsiChar(Ord(s[i]))
    else
      Result := Result + AnsiString(s[i]);
  end;
end;

procedure TfrmSicsTVPrincipal.AlinhaLabelsDataHora (Panel : TJvPanel);
begin
  if ((GetPanelProperties(panel)) and (Panel.FindComponent('lblDataHora'+inttostr(panel.Tag)) <> nil)) then
  begin
    with (Panel.FindComponent('lblDataHora'+inttostr(panel.Tag)) as TLabel) do
    begin
      AutoSize := false;

      Left   := StrToInt(frmSicsProperties.edDataHoraMargemEsquerda.Text);
      Top    := strtoint(frmSicsProperties.edDataHoraMargemSuperior.Text);
      Width  := Panel.ClientWidth  - strtoint(frmSicsProperties.edDataHoraMargemEsquerda.Text) - strtoint(frmSicsProperties.edDataHoraMargemDireita .Text);
      Height := Panel.ClientHeight - strtoint(frmSicsProperties.edDataHoraMargemSuperior.Text) - strtoint(frmSicsProperties.edDataHoraMargemInferior.Text);
    end;
  end;  { if get }
end;


procedure TfrmSicsTVPrincipal.AtualizaPanelsUltimasChamadas(const Senha, NomePA, NomeCliente: string; IdPA: Integer);
var
  i, j : integer;
  ArrayIdsPas: TIntArray;
  bAtualizarLabels: Boolean;
begin
  for i := 0 to ComponentCount - 1 do
  begin
    if (Components[i] is TJvPanel) and ((Components[i] as TJvPanel).Hint = inttostr(ord(tpUltimasSenhas))) then
    begin
      bAtualizarLabels := False;

      cdsUltimasChamadas.Filter := 'ID_PAINEL=' + IntToStr(Components[i].Tag);
      cdsUltimasChamadas.Filtered := True;
      try
        if (Senha <> '') and (NomePA <> '') and (IdPA > 0) then
        begin
          GetPanelProperties(Components[i] as TJvPanel);
          StrToIntArray(frmSicsProperties.edUltimasChamadasPASPermitidas.Text, ArrayIdsPas);
          if not ExisteNoIntArray(IdPa, ArrayIdsPas) then
          begin
            if cdsUltimasChamadas.Locate('SENHA', Senha, []) then
            begin
              cdsUltimasChamadas.Delete;
              bAtualizarLabels := True;
            end;
          end
          else
          begin
            if ((cdsUltimasChamadas.Locate('SENHA', Senha, [])) and (cdsUltimasChamadas.FieldByName('ID_PA').AsInteger = IdPA)) then
            begin
              cdsUltimasChamadas.Edit;
              cdsUltimasChamadas.FieldByName('ID_PAINEL'   ).AsInteger  := Components[i].Tag ;
              cdsUltimasChamadas.FieldByName('SENHA'       ).AsString   := Senha             ;
              cdsUltimasChamadas.FieldByName('NOME_PA'     ).AsString   := NomePA            ;
              cdsUltimasChamadas.FieldByName('NOME_CLIENTE').AsString   := NomeCliente       ;
              cdsUltimasChamadas.FieldByName('ID_PA'       ).AsInteger  := IdPA              ;
              cdsUltimasChamadas.FieldByName('DATA_HORA'   ).AsDateTime := Now               ;
              cdsUltimasChamadas.Post;

              bAtualizarLabels := True;
            end
            else
            begin
              if cdsUltimasChamadas.Locate('SENHA', Senha, []) then
                cdsUltimasChamadas.Delete;
                // se atingiu a qtde maxima de "ultimas senhas" (considerando 1 a mais que seria a chamada atual), excluo a mais antiga (primeiro registro)
              if cdsUltimasChamadas.RecordCount = StrToIntDef(frmSicsProperties.edUltimasChamadasQuantidade.Text, 0) + StrToIntDef(frmSicsProperties.edUltimasChamadasAtraso.Text, 0) + 1 then
              begin
                cdsUltimasChamadas.First;
                cdsUltimasChamadas.Delete;
              end;
              // inserindo a senha
              cdsUltimasChamadas.Append;
              cdsUltimasChamadas.FieldByName('ID_PAINEL'   ).AsInteger  := Components[i].Tag ;
              cdsUltimasChamadas.FieldByName('SENHA'       ).AsString   := Senha             ;
              cdsUltimasChamadas.FieldByName('NOME_PA'     ).AsString   := NomePA            ;
              cdsUltimasChamadas.FieldByName('NOME_CLIENTE').AsString   := NomeCliente       ;
              cdsUltimasChamadas.FieldByName('ID_PA'       ).AsInteger  := IdPA              ;
              cdsUltimasChamadas.FieldByName('DATA_HORA'   ).AsDateTime := Now               ;
              cdsUltimasChamadas.Post;

              bAtualizarLabels := True;
            end;
          end;
        end
        else
          // essa situacao ocorre quando mexe nas propriedades do painel
          // neste caso o metodo sera chamada com senha em branco
          bAtualizarLabels := True;

        // alimentando os labels com as ultimas chamadas
        if bAtualizarLabels then
        begin
          cdsUltimasChamadas.Last;
          cdsUltimasChamadas.Prior;  //para não aparecer a chamada atual

          //para não aparecer as senhas referentes ao parâmetro "atraso"
          for j := 1 to StrToIntDef(frmSicsProperties.edUltimasChamadasAtraso.Text, 0) do
            cdsUltimasChamadas.Prior;

          for j := 1 to cgMaxChamadas do
          begin
            if ( ((Components[i] as TJvPanel).FindComponent('lblUltimaSenha'       + FormatNumber(3,j) + inttostr((Components[i] as TJvPanel).Tag)) <> nil) and
                 ((Components[i] as TJvPanel).FindComponent('lblUltimaPA'          + FormatNumber(3,j) + inttostr((Components[i] as TJvPanel).Tag)) <> nil) and
                 ((Components[i] as TJvPanel).FindComponent('lblUltimoNomeCliente' + FormatNumber(3,j) + inttostr((Components[i] as TJvPanel).Tag)) <> nil)      ) then
            begin
              with (Components[i] as TJvPanel).FindComponent('lblUltimaSenha' + FormatNumber(3,j) + inttostr((Components[i] as TJvPanel).Tag)) as TLabel do
              begin
                if not cdsUltimasChamadas.Bof then
                  Caption := cdsUltimasChamadas.FieldByName('SENHA').AsString
                else
                  Caption := '';
              end;

              with (Components[i] as TJvPanel).FindComponent('lblUltimaPA' + FormatNumber(3,j) + inttostr((Components[i] as TJvPanel).Tag)) as TLabel do
              begin
                if not cdsUltimasChamadas.Bof then
                  Caption := cdsUltimasChamadas.FieldByName('NOME_PA').AsString
                else
                  Caption := '';
              end;

              with (Components[i] as TJvPanel).FindComponent('lblUltimoNomeCliente' + FormatNumber(3,j) + inttostr((Components[i] as TJvPanel).Tag)) as TLabel do
              begin
                if not cdsUltimasChamadas.Bof then
                  Caption := cdsUltimasChamadas.FieldByName('NOME_CLIENTE').AsString
                else
                  Caption := '';
              end;

              (Components[i] as TJvPanel).Visible := true;

              cdsUltimasChamadas.Prior;
            end;
          end;
        end;

      finally
        cdsUltimasChamadas.Filtered := False;
      end;

    end;
  end;
end;

function TfrmSicsTVPrincipal.BuscaHorarioUltimaAtualizacaoPlayList: String;
var
  IniFile:  TIniFile;
  InfoIni: String;
begin
  InfoIni := EmptyStr;

  IniFile := TIniFile.Create(GetAppIniFileName);
  if IniFile.SectionExists(vgTVPlayListManager.Panel.Name) then
  begin
    InfoIni := DateTimeToStr(IniFile.ReadDateTime(vgTVPlayListManager.Panel.Name, 'AtualizacaoPlayList' , Now));
    InfoIni := InfoIni + ';' + IniFile.ReadString(vgTVPlayListManager.Panel.Name, 'IDTVPlayListManager' , EmptyStr);
  end;

  Result := InfoIni;
end;

procedure TfrmSicsTVPrincipal.FecharSoftwareTV;
begin
  if (vgTVComponent.ParentHandle > 0) and (vgTVComponent.NomeDaJanela <> '') then
  begin
    vgTVComponent.AppHandle := FindWindowEx(vgTVComponent.ParentHandle, 0, nil, PChar(vgTVComponent.NomeDaJanela));
    if(vgTVComponent.AppHandle > 0)then
    begin
      case vgTVComponent.SoftwareHomologado of
        1: PostMessage(vgTVComponent.AppHandle,WM_QUIT,0,0);  //AverTV
        5:begin
            keybd_event(VK_ESCAPE, 0, 0, 0);
            keybd_event(VK_ESCAPE, 0, KEYEVENTF_KEYUP, 0);
          end;
      end;
    end;
  end;
end;

procedure TfrmSicsTVPrincipal.AtivarDesativarSomAverTV;
begin
  if (vgTVComponent.ParentHandle > 0) and (vgTVComponent.NomeDaJanela <> '') then
  begin
    //BAH - Localiza o Handle do AverTV que esta dentro de um panel
    vgTVComponent.AppHandle := FindWindowEx(vgTVComponent.ParentHandle, 0, nil, PChar(vgTVComponent.NomeDaJanela));
    //BAH Manda a tecla "M" para ativar ou desativar o som
    if(vgTVComponent.AppHandle > 0)then
      PostMessage(vgTVComponent.AppHandle,WM_KEYDOWN,$4D,0);
  end;
end;

procedure TfrmSicsTVPrincipal.AtualizaPanelsIndicadoresDesempenho;
var
  i, j, k            : integer;
  fn                 : string;
  sl                 : TStringList;
//  CorAcompanhaNivel  : boolean;
begin
  for i := 0 to ComponentCount - 1 do
  begin
    if (Components[i] is TJvPanel) and ((Components[i] as TJvPanel).Hint = inttostr(ord(tpIndicadorPerformance))) then
    begin
      GetPanelProperties(Components[i] as TJvPanel);
      fn                := frmSicsProperties.edHTMLFileName.FileName;

      if fn = '' then
        Exit;
//      CorAcompanhaNivel := frmSicsProperties.chkCorDaFonteAcompanhaNivelPI.Checked;

      sl := TStringList.Create;
      try
        if Application.FindComponent('frmSicsCommom_PIShow0') <> nil then
          with Application.FindComponent('frmSicsCommom_PIShow0') as TfrmSicsCommom_PIShow do
          begin
            sl.LoadFromFile(fn);
            for j := 0 to sgPIs.RowCount - 1 do
            begin
              for k := 0 to sl.Count - 1 do
              begin
                //ShowMessage(sgPIs.Cells[3,j]);
                sl.Strings[k] := AnsiReplaceStr(sl.Strings[k], '{{PI ' + sgPIs.Cells[3,j] + ' - Nome}}'  , sgPIs.Cells[0,j]);
                sl.Strings[k] := AnsiReplaceStr(sl.Strings[k], '{{PI ' + sgPIs.Cells[3,j] + ' - Valor}}' , sgPIs.Cells[1,j]);
                if sgPIs.Cells[2,j] = 'Normal' then
                  sl.Strings[k] := AnsiReplaceStr(sl.Strings[k], '{{PI ' + sgPIs.Cells[3,j] + ' - Imagem}}', ExtractFilePath(fn) + 'IMG_NORMAL.PNG' )
                else if sgPIs.Cells[2,j] = 'Atenção' then
                  sl.Strings[k] := AnsiReplaceStr(sl.Strings[k], '{{PI ' + sgPIs.Cells[3,j] + ' - Imagem}}', ExtractFilePath(fn) + 'IMG_ATENCAO.PNG')
                else if sgPIs.Cells[2,j] = 'Crítico' then
                  sl.Strings[k] := AnsiReplaceStr(sl.Strings[k], '{{PI ' + sgPIs.Cells[3,j] + ' - Imagem}}', ExtractFilePath(fn) + 'IMG_CRITICO.PNG')
                else
                  sl.Strings[k] := AnsiReplaceStr(sl.Strings[k], '{{PI ' + sgPIs.Cells[3,j] + ' - Imagem}}', '')
              end;
            end;
          end;

        if (Components[i] as TJvPanel).FindComponent('WebBrowser' + inttostr((Components[i] as TJvPanel).Tag)) <> nil then
          WebBrowserLoadHTML ((Components[i] as TJvPanel).FindComponent('WebBrowser' + inttostr((Components[i] as TJvPanel).Tag)) as TWebBrowser, sl.Text);
      finally
        sl.Free;
      end;
    end;
  end;
end;  // proc AtualizaPanelsIndicadoresDesempenho


{=======================================================}
{ procedures dos painéis }

procedure TfrmSicsTVPrincipal.PanelAfterMove(Sender: TObject);
var
  Panel : TJvPanel;
begin
  vgPainelSelecionado := (Sender as TComponent).Tag;
  Panel := FindComponent('Panel'+inttostr(vgPainelSelecionado)) as TJvPanel;
  if Panel <> nil then
  begin
    GetPanelProperties(Panel);
    Panel.Movable  := true;
  end;

  SavePanel(vgPainelSelecionado);
end;


procedure TfrmSicsTVPrincipal.PanelMouseLeave(Sender: TObject);
begin
  (Sender as TJvPanel).Movable  := false;
end;


procedure TfrmSicsTVPrincipal.PanelResize(Sender: TObject);
var
  Panel : TJvPanel;
begin
  vgPainelSelecionado := (Sender as TComponent).Tag;
  Panel := FindComponent('Panel'+inttostr(vgPainelSelecionado)) as TJvPanel;
  if Panel <> nil then
  begin
    GetPanelProperties(Panel);

    case TTipoDePainel(strtoint((Sender as TJvPanel).Hint)) of
      tpChamadaSenha  : AlinhaLabelsChamada         (Sender as TJvPanel);
      tpUltimasSenhas : AlinhaLabelsUltimasChamadas (Sender as TJvPanel);
      tpFlash         : begin
                          Logo.SetFocus;
                          ((Panel.FindComponent('Flash'+inttostr(vgPainelSelecionado))) as TShockwaveFlash).SetFocus;
                        end;
    end;
    Panel.BringToFront;
  end;
end;


procedure TfrmSicsTVPrincipal.PanelDblClick(Sender: TObject);
var
  Panel : TJvPanel;
begin
  vgPainelSelecionado := (Sender as TComponent).Tag;
  Panel := FindComponent('Panel'+inttostr(vgPainelSelecionado)) as TJvPanel;
  if Panel <> nil then
    Panel.Movable  := true;
  GetPanelProperties(Panel);
end;

{=======================================================}
{ procedures dos menus }

procedure TfrmSicsTVPrincipal.menuPopupPopup(Sender: TObject);
var
  Comp: TComponent;
  Panel: TJvPanel;
begin
  Comp := menuPopup.PopupComponent;
//  ShowMessage (Comp.Name);

  if (Comp = nil) or (Comp = Self) then
  begin
    vgPainelSelecionado := 0;
    Panel := nil;
  end
  else
  begin
    vgPainelSelecionado := Comp.Tag;
    Panel := FindComponent('Panel'+inttostr(vgPainelSelecionado)) as TJvPanel;
  end;
  GetPanelProperties(Panel);

  menuExcluir         .Enabled := (vgPainelSelecionado > 0);
  menuTrazerParaFrente.Enabled := menuExcluir.Enabled;
  menuEnviarParaTras  .Enabled := menuExcluir.Enabled;
end;

procedure TfrmSicsTVPrincipal.menuNovoClick(Sender: TObject);
var
  i : integer;
  LJSONPainel : TJSONObject;
  LJSONArray  : TJSONArray;
begin
  for i := 1 to cgMaxPanels do
    if FindComponent('Panel'+inttostr(i)) = nil then
      break;

  if i <= cgMaxPanels then
  begin
    CreatePanel (i, TTipoDePainel((Sender as TComponent).Tag));
    if(TTipoDePainel((Sender as TComponent).Tag) = tpTV)then
      CreatePanel (i, tpVideo, true);

    SetLength(vgParametrosModulo.Paineis, Length(vgParametrosModulo.Paineis) + 1);

    vgParametrosModulo.Paineis[High(vgParametrosModulo.Paineis)].Tipo := (Sender as TComponent).Tag;
    vgParametrosModulo.Paineis[High(vgParametrosModulo.Paineis)].Id_Modulo_TV := vgParametrosModulo.IdModulo;

    LJSONPainel := SicsTV_Parametros.SalvarParametrosTVPaineis(vgParametrosModulo.Paineis[High(vgParametrosModulo.Paineis)]);

    LJSONArray := TJSONArray.Create;
    LJSONArray.AddElement(LJSONPainel);

    dmSicsClientConnection.SendCommandToHost (0, $8D, Chr($46) + TAspEncode.AspIntToHex(vgParametrosModulo.IdModulo, 4) + LJSONArray.ToJSON, 0);
  end
  else
    AppMessageBox('Número máximo de quadros esgotado: ' + inttostr(cgMaxPanels), 'Erro', MB_ICONSTOP);

  SavePanel(i);
end;

procedure TfrmSicsTVPrincipal.menuTrazerParaFrenteClick(Sender: TObject);
begin
  if FindComponent('Panel'+inttostr(vgPainelSelecionado)) <> nil then
    (FindComponent('Panel'+inttostr(vgPainelSelecionado)) as TJvPanel).BringToFront;
end;

procedure TfrmSicsTVPrincipal.menuEnviarParaTrasClick(Sender: TObject);
begin
  if FindComponent('Panel'+inttostr(vgPainelSelecionado)) <> nil then
    (FindComponent('Panel'+inttostr(vgPainelSelecionado)) as TJvPanel).SendToBack;
end;

procedure TfrmSicsTVPrincipal.menuExcluirClick(Sender: TObject);
begin
  ExcluirPainel;
end;

procedure TfrmSicsTVPrincipal.ExcluirPainel;
var
  IniFile : TIniFile;
  pnl,PanelVideo: TjvPanel;
  TipoPainel: TTipoDePainel;
begin
  if Application.MessageBox('Excluir este quadro?', 'Confirmação', MB_YESNO or MB_ICONQUESTION) = mrYes then
  begin
    pnl := (FindComponent('Panel'+inttostr(vgPainelSelecionado)) as TJvPanel);

    if pnl <> nil then
    begin
      frmSicsProperties.RemoverPainleDaLista(pnl);
      TipoPainel := TTipoDePainel(StrToInt(pnl.Hint));

      case TipoPainel of
        tpTV               :
                            begin
                              case frmSicsProperties.cboSoftwaresHomologados.ItemIndex of
                                 1 :
                                    begin
                                      LimparPainelTV;
                                    end;
                                 3 :
                                    begin
                                      if(captureObject <> 0)then
                                      begin
                                        frmSicsProperties.DeleteCapture;
                                      end;
                                    end;
                                 5 :
                                    begin
                                      LimparPainelTV;
                                    end;
                                 6 :
                                    begin
                                      LimparPainelTV;
                                    end;
                              end;

                              PanelVideo :=(FindComponent('PanelVideo'+inttostr(vgPainelSelecionado)) as TJvPanel);

                            end;
        tpJornalEletronico : vgJornalEletronico := nil;
      end;
      pnl.Destroy;
      if(Assigned(PanelVideo))then
        PanelVideo.Destroy;
    end;

    IniFile := TIniFile.Create(GetAppIniFileName);
    try
      IniFile.EraseSection('Panel'+IntToStr(vgPainelSelecionado));
    finally
      IniFile.Free;
    end;

    with TJSONObject.Create do
    begin
      AddPair('ID', vgParametrosModulo.Paineis[vgPainelSelecionado].ID.ToString);
      AddPair('ID_MODULO_TV', vgParametrosModulo.Paineis[vgPainelSelecionado].Id_Modulo_TV.ToString);

      dmSicsClientConnection.SendCommandToHost (0, $8D, Chr($58) + TAspEncode.AspIntToHex(vgParametrosModulo.IdModulo, 4) + ToJSON, 0);
      Free;
    end;
    vgPainelSelecionado := 0;
    GetPanelProperties(nil);
  end;
end;

procedure TfrmSicsTVPrincipal.CarregarImagemNoPlayListManager(const APanel: TJvPanel; const APath: String);
var
  LMediaPlayer : TWindowsMediaPlayer;
  LImage       : TJvImage;
begin
  LMediaPlayer := TWindowsMediaPlayer(APanel.FindComponent('MediaPlayList' + Inttostr(APanel.Tag)));
  LImage       := TJvImage(APanel.FindComponent('ImagePlayList' + Inttostr(APanel.Tag)));

  if FileExists(APath) then
  begin
    LMediaPlayer.controls.stop;
    LImage.Picture.LoadFromFile(APath);
    LImage.Visible := True;
    LMediaPlayer.Visible := False;
  end
  else
    LImage.Picture.Assign(nil);
end;

procedure TfrmSicsTVPrincipal.ExecutaAtualizacaoAPP;
begin
  if (not FIniciouAtualizacao) then
  begin
    FIniciouAtualizacao := True;
    try
      AspUpd_ChecarEFazerUpdate(vgParametrosSicsClient.ArqUpdateDir);
    finally
      FIniciouAtualizacao := False;
    end;
  end;
end;

function TfrmSicsTVPrincipal.ExecutarPlayList(Panel : TJvPanel; No : integer): boolean;
var
  LMediaPlayer : TWindowsMediaPlayer;
  LImage       : TJvImage;
  LTimer       : TTimer;
begin
  LTimer := TTimer(Panel.FindComponent('TimerPlayList' + Inttostr(No)));

  if DMPlayListManager.AtualizandoPlaylist or
     DMPlayListManager.ClientDataSetPlayList.IsEmpty then
  begin
    LTimer.Enabled := True;
    exit;
  end;

  LMediaPlayer := TWindowsMediaPlayer(Panel.FindComponent('MediaPlayList' + Inttostr(No)));
  LImage       := TJvImage(Panel.FindComponent('ImagePlayList' + Inttostr(No)));

  Inc(FItemAtualPlayListManager);
  if FItemAtualPlayListManager > DMPlayListManager.ClientDataSetPlayList.RecordCount then
    FItemAtualPlayListManager := 1;

  DMPlayListManager.ClientDataSetPlayList.RecNo := FItemAtualPlayListManager;
  LTimer.Interval := DMPlayListManager.ClientDataSetPlayListARQUIVO_DURACAOSEGS.AsInteger;

  if (Assigned(LMediaPlayer) and Assigned(LImage) and Assigned(LTimer)) then
  begin
    if DMPlayListManager.ClientDataSetPlayListARQUIVO_TIPO.AsString = 'I' then
    begin
      CarregarImagemNoPlayListManager(Panel, DMPlayListManager.ClientDataSetPlayListARQUIVO_CAMINHO.AsString);
      Ltimer.Enabled := True;
    end
    else if DMPlayListManager.ClientDataSetPlayListARQUIVO_TIPO.AsString = 'V' then
    begin
      Limage.Visible            := False;
      LMediaPlayer.Visible      := True;

      LMediaPlayer.controls.pause;
      if FileExists(DMPlayListManager.ClientDataSetPlayListARQUIVO_CAMINHO.AsString) then
        LMediaPlayer.currentMedia := LMediaPlayer.NewMedia(DMPlayListManager.ClientDataSetPlayListARQUIVO_CAMINHO.AsString)
      else
        LMediaPlayer.controls.stop;
      LMediaPlayer.controls.play;
    end;
  end;
end;

function TfrmSicsTVPrincipal.ExecutarVideo(No : integer) :boolean;
var
  Panel       : TJvPanel;
  MediaPlayer : TMediaPlayer;
  ListaPlayer : TListBox;
  timer       : TTimer;
  arquivoExiste : Boolean;
  indexInicial : Integer;

begin
  Result := false;
  Panel       := TJvPanel(Self.FindComponent ('PanelVideo' + Inttostr(No)));
  if(Not Assigned(Panel))then
      Panel   :=  TJvPanel(Self.FindComponent ('Panel' + Inttostr(No)));
  MediaPlayer := TMediaPlayer(Panel.FindComponent('MediaPlayerVideos' + Inttostr(No)));
  ListaPlayer := TListBox(Panel.FindComponent('lstVideos' + Inttostr(No)));
  timer       := TTimer(Panel.FindComponent('tmrVerificaTerminoVideo'+Inttostr(No)));
  if(ListaPlayer.Items.Count > 0) then
  begin
    indexInicial := ListaPlayer.ItemIndex;
 
    repeat
      arquivoExiste := FileExists(ListaPlayer.Items.Strings[ListaPlayer.ItemIndex]);
      if(arquivoExiste)then
      begin
        MediaPlayer.FileName := ListaPlayer.Items.Strings[ListaPlayer.ItemIndex];

        try
          MediaPlayer.Open;
          timer.Interval := MediaPlayer.Length;
          timer.Tag := No;
          MediaPlayer.Play;
          timer.Enabled := true;
          MediaPlayer.DisplayRect := Panel.ClientRect;
          Result := true;
        except on E : Exception  do
          begin
            Result := false;
            Application.MessageBox( PWideChar('Não foi possível reproduzir o video: ' + ExtractFileName(MediaPlayer.FileName)), 'Erro', MB_ICONSTOP);
          end;
        end;
      end;

      if(ListaPlayer.ItemIndex = ListaPlayer.Items.Count-1)then
      begin
        ListaPlayer.ItemIndex := 0
      end
      else
      begin
        ListaPlayer.ItemIndex := ListaPlayer.ItemIndex + 1;
      end;

    until (arquivoExiste or (ListaPlayer.ItemIndex = indexInicial));
  end;
end;

procedure TfrmSicsTVPrincipal.menuPropriedadesClick(Sender: TObject);
begin
  FormStyle := fsNormal;
  frmSicsProperties.Show;
end;

procedure TfrmSicsTVPrincipal.menuMonitorClick(Sender: TObject);
begin
  if (Sender as TMenuItem).Checked then
  begin
    case (Sender as TMenuItem).Tag of
      1 : begin
            menuMonitor2.OnClick := nil;
            menuMonitor2.Checked := false;
            menuMonitor2.OnClick := menuMonitorClick;
            SavePosition(frmSicsTVPrincipal);
            BorderStyle := bsNone;
            WindowState := wsMaximized;
          end;
      2 : begin
            menuMonitor1.OnClick := nil;
            menuMonitor1.Checked := false;
            menuMonitor1.OnClick := menuMonitorClick;
            BorderStyle := bsNone;
            WindowState := wsMaximized;
            Left        := 1025;
          end;
    end;  { case }
  end
  else
  begin
    BorderStyle := bsSizeable;
    WindowState := wsNormal;
    Self.BringToFront;
    LoadPosition(frmSicsTVPrincipal);
  end;
end;

procedure TfrmSicsTVPrincipal.menuHorarioDeFuncionamentoClick(Sender: TObject);
begin
  gfConfigurandoHorarioDeFuncionamento := true;
  try
    if SetHorarioDeFuncionamento(vgHorarioDeFuncionamento) then
      SaveHorarioDeFuncionamento(vgHorarioDeFuncionamento);
  finally
    gfConfigurandoHorarioDeFuncionamento := false;
  end;
end;

procedure TfrmSicsTVPrincipal.menuSairClick(Sender: TObject);
begin
  FecharSoftwareTV;
  Close;
end;

procedure TfrmSicsTVPrincipal.menuSobreClick(Sender: TObject);
begin
  AppMessageBox (VERSAO + #13#13 + GetExeVersion, 'Sobre...', MB_ICONINFORMATION);
end;

{=======================================================}
{ procedures do formulário }

procedure TfrmSicsTVPrincipal.FormCreate(Sender: TObject);
var
  IniFile : TIniFile;
const
  rect: TRect = (Left:0; Top:0; Right:0; Bottom:0);
  ws : TWindowState = wsNormal;

var
  r : TRect;
begin
  ws := WindowState;
  rect := BoundsRect;
  BorderStyle := bsNone;
  r := Screen.MonitorFromWindow(Handle).BoundsRect;
  SetBounds(r.Left, r.Top, r.Right-r.Left, r.Bottom-r.Top) ;

  FPathSicsLiveTV := IncludeTrailingPathDelimiter(GetApplicationPath);

  {$IFDEF DEBUG}
  FormStyle := fsNormal;
  {$ENDIF}

  vgTVCanalPadrao      := 0;
  vgTVChannelList := TStringList.Create;

  vgTVComponent.ParentHandle       := 0;
  vgTVComponent.SoftwareHomologado := -1;

  vgResolucaoPadrao.Reset;

  Application.OnException              := MyExceptionHandler;
  vgPainelSelecionado                  := 0;
  gfInitializing                       := true;
  gfConfigurandoHorarioDeFuncionamento := false;

  cdsUltimasChamadas.CreateDataSet;

  SysUtils.FormatSettings.ShortDayNames[1] := 'DOM.';
  SysUtils.FormatSettings.ShortDayNames[2] := 'SEG.';
  SysUtils.FormatSettings.ShortDayNames[3] := 'TER.';
  SysUtils.FormatSettings.ShortDayNames[4] := 'QUA.';
  SysUtils.FormatSettings.ShortDayNames[5] := 'QUI.';
  SysUtils.FormatSettings.ShortDayNames[6] := 'SEX.';
  SysUtils.FormatSettings.ShortDayNames[7] := 'SÁB.';

  IniFile := TIniFile.Create(GetAppIniFileName);
  with IniFile do
    try
      vlAddress                   := ReadInteger ('Settings', 'IdPainel'               , 1      );
      //vgIdTV                      := ReadInteger ('Settings', 'IdTv'                   , 0      );
      ServerSocket1.Port          := ReadInteger ('Settings', 'PortaIPPainel'          , 3001   );
      //vgChamadaInterrompeVideo    := ReadBool    ('Settings', 'ChamadaInterrompeVideo' , false  );
      vgParametrosModulo.IdPainel := ReadInteger ('Settings', 'IdPainel'               , 1      );
      vgParametrosModulo.IdModulo := ReadInteger ('Settings', 'IdModulo'               , 0      );

      //if ReadBool ('Settings', 'MaximizarMonitor1', true ) then
      //  menuMonitor1.Click
      //else if ReadBool ('Settings', 'MaximizarMonitor2', false ) then
      //  menuMonitor2.Click
      //else
      //  LoadPosition (Sender as TForm);
    finally
      Free;
    end;  { try .. finally }

  gfMouseTimeout := 10;

  //LoadHorarioDeFuncionamento (vgHorarioDeFuncionamento);

  Voice := CreateOLEObject('SAPI.SpVoice');

  pnlScreenSaver.Align := alClient;

  //if not EstaNoHorarioDeFuncionamento then
    //Application.MessageBox('A tela ficará preta pois não está no horário de funcionamento do programa.', 'Aviso', MB_ICONWARNING);
end;

procedure TfrmSicsTVPrincipal.FormClick(Sender: TObject);
begin
  Self.Align := alNone;
  Self.WindowState := wsMaximized;
  Self.BringToFront;
end;

procedure TfrmSicsTVPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
var
  IniFile : TIniFile;
begin
  FreeAndNil(SysDev);
  FilterGraph.ClearGraph;
  FilterGraph.Active := false;

  FecharSoftwareTV;

  SavePosition (Sender as TForm);

  IniFile := TIniFile.Create(GetAppIniFileName);
  with IniFile do
    try
      WriteInteger ('Settings', 'IdModulo'               , vgParametrosModulo.IdModulo);
      //WriteInteger ('Settings', 'IdPainel'               , vlAddress                  );
      //WriteInteger ('Settings', 'IdTv'                   , vgIdTv                     );
      WriteInteger ('Settings', 'PortaIPPainel'          , ServerSocket1.Port         );
    finally
      Free;
    end;  { try .. finally }

  //LM
  if not Assigned(VFVideoCapture) then
    FreeAndNil(VFVideoCapture);
end;

procedure TfrmSicsTVPrincipal.FormResize(Sender: TObject);
begin
  Logo.Left := ClientWidth  - logo.Width;
  Logo.Top  := ClientHeight - logo.Height;
  Logo.BringToFront;
end;

{=======================================================}
{ procedures dos timers }

procedure TfrmSicsTVPrincipal.OneSecondTimerTimer(Sender: TObject);
const
  Timeout : integer = 60;
var
  i : integer;
begin
  if EstaNoHorarioDeFuncionamento then
  begin
    for i := 0 to ComponentCount - 1 do
      if ((Components[i] is TJvPanel) and ((Components[i] as TJvPanel).Hint <> '')) then
        case TTipoDePainel(strtoint((Components[i] as TJvPanel).Hint)) of
          tpDataHora  : begin
                          if (Components[i] as TJvPanel).FindComponent('lblDataHora'+ inttostr((Components[i] as TJvPanel).Tag)) <> nil then
                            with ((Components[i] as TJvPanel).FindComponent('lblDataHora'+ inttostr((Components[i] as TJvPanel).Tag)) as TLabel) do
                            begin
                              Caption := FormatDateTime (Hint, now);
                              BringToFront;
                            end;
                        end;
        end;  { case }

    Logo.Left    := ClientWidth  - logo.Width;
    Logo.Top     := ClientHeight - logo.Height;
    Logo.Visible := false;

    if pnlScreenSaver.Visible then
    begin
      pnlScreenSaver.Visible := false;

      for i := 0 to ComponentCount - 1 do
        if (Components[i] is TJvPanel) and ((Components[i] as TJvPanel).Hint = inttostr(ord(tpVideo))) then
          (((Components[i] as TJvPanel).FindComponent ('MediaPlayerVideos'+inttostr((Components[i] as TJvPanel).Tag))) as TMediaPlayer).Play; //BAH alterado o nome
    end;
  end
  else
  begin
    pnlScreenSaver.Visible := true;
    pnlScreenSaver.BringToFront;

    if ((not frmSicsProperties.Visible) and (Timeout <= 0)) then
    begin
      Randomize;
      Logo.Left    := Random(ClientWidth  - logo.Width);
      Logo.Top     := Random(ClientHeight - logo.Height);
      Logo.Visible := true;

      Timeout := 60;
    end
    else
      Timeout := Timeout - 1;

    for i := 0 to ComponentCount - 1 do
      if (Components[i] is TJvPanel) and ((Components[i] as TJvPanel).Hint = inttostr(ord(tpVideo))) then
        (((Components[i] as TJvPanel).FindComponent ('MediaPlayerVideos'+inttostr((Components[i] as TJvPanel).Tag))) as TMediaPlayer).Stop; //BAH alterado o nome
  end;

  Logo.BringToFront;

  if gfMouseTimeout <= 0 then
  begin
    if (EstaNoHorarioDeFuncionamento and (not frmSicsProperties.Visible)) then
    begin

      frmSicsLogo.Left := Left + ClientWidth  - frmSicsLogo.Width;
      frmSicsLogo.Top  := Top + ClientHeight - frmSicsLogo.Height;
      with frmSicsLogo do
      begin
        if not Visible then
        begin
          Show;
          Color := 0;
          TransparentColorValue := 0;
          TransparentColor := true;
        end;
        BringToFront;
        FormStyle := fsStayOnTop;
      end;
    end
    else
      frmSicsLogo.Close;

    Screen.Cursor := crNone;
    SetCursorPos(0, Screen.Height + 5);
  end
  else
  begin
    if ((frmSicsProperties.Visible) or (gfConfigurandoHorarioDeFuncionamento) or (Windows.GetCapture() <> 0) or ((not menuMonitor1.Checked) and (not menuMonitor2.Checked))) then  //Windows.GetCapture() <> 0 verifica se há qualquer menu aberto ou botão clicado. Usado aqui para verificar se o PopUpMenu está aberto.
      gfMouseTimeout := 15
    else
      gfMouseTimeout := gfMouseTimeout - 1;
  end;
end;

{=============================================================================}
{ PROCEDURES DOS SOCKETS                                                      }

procedure TfrmSicsTVPrincipal.ServerSocket1ClientConnect (Sender: TObject; Socket: TCustomWinSocket);
var
  i : integer;
begin
  Color := clBtnFace;

  for i := 0 to ServerSocket1.Socket.ActiveConnections - 1 do
    ServerSocket1.Socket.Connections[i].SendText(STX + IntToHex(cgVERSAOPROTOCOLO, 4) + FormatNumber(4, vlAddress) + Chr($27) + FormatNumber(4, vlAddress) + ETX);

  // como este evento pode ser chamado diversas vezes,
  // soh pego os canais habilitados caso o ClientDataSet não esteja ativo
  // isso indica que nao obtive ainda
  if not cdsTVCanais.Active then
    GetServidorCanaisHabilitados;
end;

procedure TfrmSicsTVPrincipal.ServerSocket1ClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  Color := clRed;
end;

procedure TfrmSicsTVPrincipal.ServerSocket1ClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  case ErrorCode of
    10053, 10065 : ErrorCode := 0;
    else begin
           if Sender is TServerSocket then
           begin
             MyLogException(ESocketError.Create('Erro ' + inttostr(ErrorCode) + ' no socket principal (' + (Sender as TServerSocket).Name + '). Reiniciando socket...'));

             (Sender as TServerSocket).Close;
           end;
         end;
  end;
end;

procedure TfrmSicsTVPrincipal.ServerSocket1ClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
const
  ReceivingProtocol : boolean = false;
  Protocol          : string = '';
var
  i   : word;
  s   : string;
  aux : string;
begin
  try
    s := Socket.ReceiveText;

    for i := 1 to length(s) do
    begin
      if s[i] = STX then
      begin
         ReceivingProtocol := true;
         Protocol := '';
      end
      else if s[i] = ETX then
      begin
         ReceivingProtocol := false;

         Protocol := STX + Protocol + ETX;

         aux := DecifraProtocolo(Protocol, Socket);
         if aux <> '' then
         begin
           EnviaComando(Socket, aux);
         end;

         Color := clBtnFace;

         Protocol := '';
      end
      else if ReceivingProtocol then
         Protocol := Protocol + s[i];
    end;  { for }
  except
    on E: Exception do
    begin
      //Application.MessageBox('Erro ao decifrar protocolo TCP/IP.', 'Erro', MB_ICONSTOP);
      MyLogException (Exception.Create ('Erro ao receber comandos TCP/IP (serverport): "' +
                                        s + '" / Remote: "' + Socket.RemoteAddress + '" / Erro: "' + E.Message + '"'));
    end;
  end;  { try .. except }
end;

procedure TfrmSicsTVPrincipal.tmrTrazerFormParaFrenteTimer(Sender: TObject);
begin
  if not Assigned(frmSicsProperties) then Exit;
  if (not ((frmSicsProperties.Visible) or (gfConfigurandoHorarioDeFuncionamento) or (Windows.GetCapture() <> 0) or (frmSicsLogo.Visible))) and
     ((menuMonitor1.Checked) or (menuMonitor2.Checked)) then
  begin
    Self.Align := alNone;
    Self.WindowState := wsMaximized;
    Self.BringToFront;
  end;
end;

procedure TfrmSicsTVPrincipal.tmrVerificaTerminoVideoTimer(
  Sender: TObject);
  var
    mediaPlayer : TMediaPlayer;
    panel : TJvPanel;
begin
  panel := TjvPanel(FindComponent('PanelVideo'+inttostr(TTimer(Sender).Tag)));
  if(not Assigned(panel))then
    panel := TjvPanel(FindComponent('Panel'+inttostr(TTimer(Sender).Tag)));

  mediaPlayer := TMediaPlayer(panel.FindComponent('MediaPlayerVideos'+inttostr(TTimer(Sender).Tag)));
  TTimer(Sender).Enabled := false;

  with mediaPlayer do
  begin
   Stop;
   DisplayRect := TRect.Empty;
   Close;
  end;

  if(not Assigned(FindComponent('PanelVideo'+inttostr(TTimer(Sender).Tag))))then
    ExecutarVideo(TTimer(Sender).Tag)
  else
  begin
    vgTVComponent.PanelVideo.Visible := false;
    if(vgTVComponent.TempoAlternancia <> 0)then
        tmrAlternaTVVideo.Enabled := true;

    MinimizarRestaurarAverTV(SC_RESTORE);
    AtivarDesativarSomAverTV;
  end;
end;

function TfrmSicsTVPrincipal.ProcessoEmExecucao(
  const ANomeProcesso: String; var AProcessEntry32: TProcessEntry32): Boolean;
var
  ContinueLoop   : Boolean;
  LSnapshotHandle: THandle;
  LProcessEntry32: TProcessEntry32;
begin
  LSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  try
    result := False;
    LProcessEntry32.dwSize := Sizeof(LProcessEntry32);
    ContinueLoop := Process32First(LSnapshotHandle, LProcessEntry32);
    while integer(ContinueLoop) <> 0 do
    begin
      if (StrIComp(PChar(ExtractFileName(LProcessEntry32.szExeFile)),
                   PChar(ANomeProcesso)) = 0) or
         (StrIComp(LProcessEntry32.szExeFile, PChar(ANomeProcesso)) = 0) Then
      begin
        AProcessEntry32 := LProcessEntry32;
        result := True;
        break;
      end;
      ContinueLoop := Process32Next(LSnapshotHandle, LProcessEntry32);
    end;
  finally
    CloseHandle(LSnapshotHandle);
  end;
end;

procedure TfrmSicsTVPrincipal.timerPosicionarAppTVTimer(Sender: TObject);
var
  LProcessEntry32: TProcessEntry32;
  LPanelTV: TPanel;
  LWinControl: TWinControl;
  LPathExecutavel: String;
begin
  if SoftwarePadraoTV(vgTVComponent.SoftwareHomologado) then
  begin
    if vgTVComponent.SoftwareHomologado <> 5 then
      LPathExecutavel := vgTVComponent.CaminhoDoExecutavel
    else
      LPathExecutavel := FPathSicsLiveTV + vgTVComponent.CaminhoDoExecutavel;

    //KM - faz o Sics monitorar se o processo do AverTV está em execução e, se não
    //estiver, o iniciará
    if not ProcessoEmExecucao(ExtractFileName(LPathExecutavel),
                              LProcessEntry32) then
    begin
      //recupera o Panel em que o AverTV está embutido
      LPanelTV := nil;
      LWinControl := FindControl(vgTVComponent.ParentHandle);
      if Assigned(LWinControl) and (LWinControl is TPanel) then
        LPanelTV := TPanel(LWinControl);

      AbrirTVTestandoResolucao(LPanelTV);
      exit;
    end;

    //coloca a janela da aplicação de TV como filha do TPanel do quadro de TV e
    //reposiciona-a na área do TPanel
    //OBS: reposicionar é necessário no timer pois ao desligar o monitor a
    //resolução de video muda e com isso o AverTV muda de posição e tamanho
    if (vgTVComponent.ParentHandle > 0) and (vgTVComponent.NomeDaJanela <> '') then
    begin
      //Tenta achar a janela, global. Se encontrar, coloca-a no seu pai TPanel
      vgTVComponent.AppHandle := FindWindow(nil, PChar(vgTVComponent.NomeDaJanela));
      if vgTVComponent.AppHandle <> 0 then
        Windows.SetParent(vgTVComponent.AppHandle, vgTVComponent.ParentHandle);

      //Tenta achar a janela como filha do TPanel. Se encontrar, redimensione
      vgTVComponent.AppHandle := FindWindowEx(vgTVComponent.ParentHandle, 0, nil, PChar(vgTVComponent.NomeDaJanela));
      if vgTVComponent.AppHandle <> 0 then
        SetWindowPos(vgTVComponent.AppHandle, 0, 0, 0, (FindControl(vgTVComponent.ParentHandle) as TJvPanel).ClientWidth, (FindControl(vgTVComponent.ParentHandle) as TJvPanel).ClientHeight, {SWP_FRAMECHANGED or }SWP_NOACTIVATE);
    end;
  end;
end;

procedure TfrmSicsTVPrincipal.tmrAlternaTVVideoTimer(Sender: TObject);
begin
  if(Assigned(vgTVComponent.PanelVideo))then
  begin
    if(ExecutarVideo(vgTVComponent.PanelVideo.Tag))then
    begin
      MinimizarRestaurarAverTV(SC_MINIMIZE);
      vgTVComponent.PanelVideo.Visible := true;
      tmrAlternaTVVideo.Enabled := false;
      AtivarDesativarSomAverTV;
    end;
  end;
end;

procedure TfrmSicsTVPrincipal.tmrReconnectTimer(Sender: TObject);
const
  Retries      : integer = 10;
  TVPreviewing : boolean = False;
begin
  if not ServerSocket1.Active then
  begin
    Color := clRed;
    ServerSocket1.Port := vgParametrosModulo.PortaIPPainel;
    ServerSocket1.Open;
  end;
end;

procedure TfrmSicsTVPrincipal.MediaPlayerNotify(Sender: TObject);
begin
  if (Sender as TMediaPlayer).NotifyValue = nvSuccessful then
  begin
    (Sender as TMediaPlayer).Play;
    (Sender as TMediaPlayer).Notify := True;
  end;
end;

procedure TfrmSicsTVPrincipal.FormMouseMove (Sender: TObject; Shift: TShiftState; X, Y: Integer);
const
  LastX : integer = 0;
  LastY : integer = 0;
begin
  if (X <> LastX) and (Y <> LastY) then
  begin
    Screen.Cursor  := crDefault;
    gfMouseTimeout := 15;
    LastX := X;
    LastY := Y;
  end;
  tmrTrazerFormParaFrente.Enabled := true;
end;

procedure TfrmSicsTVPrincipal.IndicadoresdePerformance1Click(
  Sender: TObject);
begin
  if Application.FindComponent('frmSicsCommom_PIShow0') <> nil then
    (Application.FindComponent('frmSicsCommom_PIShow0') as TfrmSicsCommom_PIShow).Show;
end;

procedure TfrmSicsTVPrincipal.InicializarForm;
var
  IniFile : TIniFile;
  i       : integer;
  Panel   : TJvPanel;
begin
  try
    if gfInitializing then
    begin
      IniFile := TIniFile.Create(GetAppIniFileName);
      LockWindowUpdate(Self.Handle);
      try
        for i := Low(vgParametrosModulo.Paineis) to High(vgParametrosModulo.Paineis) do //for i := 1 to cgMaxPanels do
          //if IniFile.SectionExists('Panel'+inttostr(i)) then
          begin
            CreatePanel(i, TTipoDePainel(vgParametrosModulo.Paineis[i].Tipo)); //IniFile.ReadInteger('Panel'+inttostr(i), 'Tipo', 1)

            if (TTipoDePainel(vgParametrosModulo.Paineis[i].Tipo) = tpTV) then  //IniFile.ReadInteger('Panel'+inttostr(i), 'Tipo', 1)
              CreatePanel(i, tpVideo,true);

            LoadPanel  (i);
            Panel := FindComponent('Panel'+inttostr(i)) as TJvPanel;

            if Panel <> nil then
            begin
              GetPanelProperties(Panel);
              SetPanelProperties(Panel);
            end;
          end;
      finally
        IniFile.Free;
        LockWindowUpdate(0);
      end;

      OneSecondTimer.Enabled := true;
      tmrReconnect  .Enabled := true;
      timerPosicionarAppTV.Enabled := True;

      SetForegroundWindow(Application.Handle);

      gfInitializing := false;
    end;
  except
    on E: Exception do
      MyLogException(Exception.Create ('Erro ao receber comandos TCP/IP (clientport): "" /  / Erro: "' + E.Message + '"'));
  end;
end;

procedure TfrmSicsTVPrincipal.FormDestroy(Sender: TObject);
begin
  vgTVChannelList.Free;
end;

procedure TfrmSicsTVPrincipal.FormShow(Sender: TObject);
begin
  try

  finally
    TfrmSicsSplash.Hide;
  end;
  //LM
  //ShowMessage(StatusLiveTv);
end;

procedure TfrmSicsTVPrincipal.EnviarServidorNovoCanalPadrao;
begin
  // OK luciano - enviar para o servidor o novo canal padrao que esta na variavel "vgTVCanalPadrao"
  try
    if ServerSocket1.Socket.ActiveConnections > 0 then
      ServerSocket1.Socket.Connections[0].SendText(STX + IntToHex(cgVERSAOPROTOCOLO, 4) + FormatNumber(4, vlAddress) + Chr($8B) + IntToHex(vgParametrosModulo.IdTV, 4) + IntToHex(vgTVCanalPadrao, 4) + ETX);
  except
    MyLogException(ESocketError.Create('Erro de socket. IP Remoto = ' + ServerSocket1.Socket.Connections[0].RemoteAddress + '. Fechando esta conexão.'));
    ServerSocket1.Socket.Connections[0].Close;
  end;
end;

procedure TfrmSicsTVPrincipal.GetServidorCanaisHabilitados;
begin
  try
    if ServerSocket1.Socket.ActiveConnections > 0 then
      ServerSocket1.Socket.Connections[0].SendText(STX + IntToHex(cgVERSAOPROTOCOLO, 4) + FormatNumber(4, vlAddress) + Chr($88) + IntToHex(vgParametrosModulo.IdTV, 4) + ETX);
  except
    MyLogException(ESocketError.Create('Erro de socket. IP Remoto = ' + ServerSocket1.Socket.Connections[0].RemoteAddress + '. Fechando esta conexão.'));
    ServerSocket1.Socket.Connections[0].Close;
  end;
end;

function TfrmSicsTVPrincipal.EnviaComando(const ASocket: TCustomWinSocket;
  const AComando: string): Integer;
begin
  Result := SOCKET_ERROR;
  if Assigned(ASocket) and ASocket.Connected then
    Result := ASocket.SendText(ArrayOfByte_StringToAnsiString(FormatarProtocolo(AComando)));
end;

procedure TfrmSicsTVPrincipal.EnviarServidorCanaisCapturados;
var
  i : integer;
  s : string;
begin
  s := IntToHex(vgParametrosModulo.IdTV, 4);
  for i := 0 to vgTVChannelList.Count - 1 do
  begin
    s := s + IntToHex(StrToInt(vgTVChannelList.Names[i]), 4) + ';' + vgTVChannelList.Values[vgTVChannelList.Names[i]];
    if vgTVCanalPadrao = StrToInt(vgTVChannelList.Names[i]) then
      s := s + '1' + TAB
    else
      s := s + '0' + TAB;
  end;

  try
    if ServerSocket1.Socket.ActiveConnections > 0 then
      ServerSocket1.Socket.Connections[0].SendText(STX + IntToHex(cgVERSAOPROTOCOLO, 4) + FormatNumber(4, vlAddress) + Chr($89) + s + ETX);
  except
    MyLogException(ESocketError.Create('Erro de socket. IP Remoto = ' + ServerSocket1.Socket.Connections[0].RemoteAddress + '. Fechando esta conexão.'));
    ServerSocket1.Socket.Connections[0].Close;
  end;
end;

procedure TfrmSicsTVPrincipal.MinimizarRestaurarAverTV(Acao : NativeUInt);
begin
  if (vgTVComponent.ParentHandle > 0) and (vgTVComponent.NomeDaJanela <> '') then
  begin
    vgTVComponent.AppHandle := FindWindowEx(vgTVComponent.ParentHandle, 0, nil, PChar(vgTVComponent.NomeDaJanela));

    if(vgTVComponent.AppHandle > 0)then
    begin
      PostMessage(vgTVComponent.AppHandle,WM_SYSCOMMAND,Acao,0);
    end;
  end;
end;

procedure TfrmSicsTVPrincipal.MudarCanalVolumeSichboPVR(AAjuste: TTipoAjuste;
  AValorAjuste: TValorAjuste);
begin
  case AAjuste of
    taCanal:begin
              case AValorAjuste of
                vaSubir:begin
                          keybd_event(VK_F4, 0, 0, 0);
                          keybd_event(VK_F4, 0, KEYEVENTF_KEYUP, 0);
                        end;

                vaDescer:begin
                           keybd_event(VK_F3, 0, 0, 0);
                           keybd_event(VK_F3, 0, KEYEVENTF_KEYUP, 0);
                         end;
              end;
            end;

    taVolume:begin
               case AValorAjuste of
                 vaSubir:begin
                           keybd_event(VK_F6, 0, 0, 0);
                           keybd_event(VK_F6, 0, KEYEVENTF_KEYUP, 0);
                         end;

                 vaDescer:begin
                            keybd_event(VK_F5, 0, 0, 0);
                            keybd_event(VK_F5, 0, KEYEVENTF_KEYUP, 0);
                          end;
               end;
             end;
  end;
end;

procedure TfrmSicsTVPrincipal.SetarVolumePadraoAverTV;
  function GetSpecialFolderPath(folder: integer): string;
  const
     SHGFP_TYPE_CURRENT = 0;
   var
     path: array [0..MAX_PATH] of char;
  begin
    if SUCCEEDED(SHGetFolderPath(0,folder,0,SHGFP_TYPE_CURRENT,@path[0])) then
      Result := path
    else
      Result := '';
  end;

  function WUserName: String;
  var
    nSize: DWord;
  begin
   nSize := 1024;
   SetLength(Result, nSize);
   if GetUserName(PChar(Result), nSize) then
     SetLength(Result, nSize-1)
   else
     RaiseLastOSError;
  end;

  var
    IniFile : TIniFile;
    caminhoIni : string;
    lastMute, I : integer;
    sections : TStringList;
begin
  sections := TStringList.Create;

  try
    caminhoIni := GetSpecialFolderPath(CSIDL_PERSONAL)+'\AVerTV\'+WUserName+'.ini';
    IniFile := TIniFile.Create(caminhoIni);
    lastMute := vgParametrosModulo.LastMute;
    if(lastMute = 1)then
      vgParametrosModulo.LastMute := lastMute;  //IniFile.WriteInteger('ACTIVE','LastMute',0);

    IniFile.ReadSections(sections);

    for I := 0 to sections.Count -1 do
    begin
      if vgParametrosModulo.Volume = 0 then //if(IniFile.ReadInteger(sections.Strings[I],'AP_VOLUME',-1) = 0)then
         vgParametrosModulo.Volume := 50;//IniFile.WriteInteger(sections.Strings[I],'AP_VOLUME', 50)
    end;
  except on E: Exception do
    begin
      FreeAndNil(sections);
      ShowMessage('Não foi possivel setar o volume padrão do AVerTV');
    end;
  end;
  FreeAndNil(sections);
end;

procedure TfrmSicsTVPrincipal.SetConnectedMode(IdUnidade: integer);
begin
  // LBC / EDU - Habilitar apresentação de indicadores de performance
end;

procedure TfrmSicsTVPrincipal.SetDisconnectedMode(IdUnidade: integer);
begin
  // LBC / EDU - Desabilitar apresentação de indicadores de performance
end;

function TfrmSicsTVPrincipal.ValidarPA(PA: integer): boolean;
begin
  Result := ((PA = vlAddress) or (PA = 0000) or (PA = $FFFF));
end;

procedure TfrmSicsTVPrincipal.VideoWindowClick(Sender: TObject);
begin
  beep;
  VideoWindow.FilterGraph.Stop;
  VideoWindow.FilterGraph.Play;
end;

procedure TfrmSicsTVPrincipal.IniciarAtualizacaoPlaylistManager(
  const APanel: TJvPanel; const APath: String);
var
  LPanel: TJvPanel;
  LMediaPlayer: TWindowsMediaPlayer;
  LTimer: TTimer;
begin
  LTimer := TTimer(APanel.FindComponent('TimerPlayList' + Inttostr(APanel.Tag)));
  LTimer.Enabled := False;
  LTimer.Interval := 500;

  LMediaPlayer := TWindowsMediaPlayer(DMPlayListManager.FPanel.FindComponent('MediaPlayList' + Inttostr(DMPlayListManager.FPanel.Tag)));
  LMediaPlayer.controls.stop;
  LMediaPlayer.close;

  FItemAtualPlayListManager := 0;

  CarregarImagemNoPlayListManager(APanel, APath);
end;

procedure TfrmSicsTVPrincipal.FinalizarAtualizacaoPlaylistManager(const APanel: TJvPanel);
var
  LTimer: TTimer;
  IniFile: TIniFile;
begin
  LTimer := TTimer(APanel.FindComponent('TimerPlayList' + Inttostr(APanel.Tag)));
  LTimer.Enabled := True;

  IniFile := TIniFile.Create(GetAppIniFileName);
  if IniFile.SectionExists(vgTVPlayListManager.Panel.Name) then
    IniFile.WriteDateTime(vgTVPlayListManager.Panel.Name, 'AtualizacaoPlayList' , Now);
end;

function TfrmSicsTVPrincipal.DefinirNomeParaSenha(IdUnidade: Integer; Senha: integer; Nome: string): boolean;
begin
  // Luciano, implementar
  Result := True;
end;

procedure TfrmSicsTVPrincipal.DisplayMessage(s: string);
begin

end;

procedure TfrmSicsTVPrincipal.TimerCheckArquivoFlashTimer(Sender: TObject);
begin
  CheckArquivoFlashModificado;
end;

procedure TfrmSicsTVPrincipal.CheckArquivoFlashModificado;
var
  i: Integer;
begin
  // analisar se o arquivo flash foi modificado, se sim, parar o flash e rodar novamente
  for i := 0 to ComponentCount -1 do
  begin
    if Components[i] is TShockwaveFlash then
    begin

    end;
  end;
end;

procedure TfrmSicsTVPrincipal.TextToVoice(AText: string);
begin
  Voice.Speak(AText,VoiceIndex);
end;

{ TResolucaoMonitor }

class operator TResolucaoMonitor.Implicit(AValue: TResolucaoMonitor): String;
begin
  result := Format('%dx%d', [AValue.Width, AValue.Height]);
end;

class operator TResolucaoMonitor.Implicit(AValue: String): TResolucaoMonitor;
var
  LArr: TStringDynArray;
begin
  LArr := SplitString(AValue, 'x');
  try
    if Length(LArr) > 2 then
    begin
      result.Width := StrToIntDef(LArr[0], 320);
      result.Height := StrToIntDef(LArr[1], 240);
    end;
  except
    raise EConvertError.Create(Format('"%s" não é uma resolução válida.' +
                                      sLineBreak + 'Utilize o formato' +
                                      ' LARGURAxALTURA. Exemplo: 1024x768',
                                      [AValue]));
  end;
end;

procedure TResolucaoMonitor.Reset;
begin
  Self.Width := 0;
  Self.Height := 0;
end;

function TResolucaoMonitor.Valida: Boolean;
begin
  result := (Self.Width > 0) and (Self.Height > 0);
end;

end.
