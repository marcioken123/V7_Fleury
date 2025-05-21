unit SicsTV_2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, MyDlls_DR, StdCtrls, JvColorCombo, JvExStdCtrls, JvCombobox,
  JvExControls, JvComponent, JvSpeedButton, JvPanel, CheckLst, ExtCtrls,
  JvExExtCtrls, JvOfficeColorButton, ComCtrls, System.JSON,
  MyAspFuncoesUteis_VCL, JvExMask, JvToolEdit, JvExtComponent,
  Buttons, DB, DBCtrls, Vcl.Mask;

type
  TfrmSicsProperties = class(TForm)
    PageControlConfigs: TPageControl;
    tbsGeral: TTabSheet;
    groupPosicao: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    edLeft: TEdit;
    edTop: TEdit;
    groupBackground: TGroupBox;
    rbBackgroundImage: TRadioButton;
    rbBackGroundColor: TRadioButton;
    cmbBackgroundColor: TJvOfficeColorButton;
    tbsChamadaSenhas: TTabSheet;
    edBackgroundImage: TJvFilenameEdit;
    pnlListaPanels: TPanel;
    lstQuadros: TListBox;
    Label26: TLabel;
    tbsTV: TTabSheet;
    tbsImagem: TTabSheet;
    tbsUltimasChamadas: TTabSheet;
    tbsDataHora: TTabSheet;
    tbsVideo: TTabSheet;
    Label6: TLabel;
    pnlImagem: TGroupBox;
    pnlDataHora: TGroupBox;
    groupDataHoraFonte: TGroupBox;
    btnDataHoraNegrito: TJvSpeedButton;
    btnDataHoraItalico: TJvSpeedButton;
    btnDataHoraSublinhado: TJvSpeedButton;
    cmbDataHoraFonte: TJvFontComboBox;
    cmbDataHoraFontSize: TComboBox;
    cmbDataHoraFontColor: TJvOfficeColorButton;
    groupDataHoraOutras: TGroupBox;
    Label8: TLabel;
    edDataHoraFormato: TEdit;
    groupDataHoraMargens: TGroupBox;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    edDataHoraMargemSuperior: TEdit;
    edDataHoraMargemInferior: TEdit;
    edDataHoraMargemEsquerda: TEdit;
    edDataHoraMargemDireita: TEdit;
    pnlUltimasChamadas: TGroupBox;
    grpUltimasChamadasFonte: TGroupBox;
    btnUltimasChamadasNegrito: TJvSpeedButton;
    btnUltimasChamadasItalico: TJvSpeedButton;
    btnUltimasChamadasSublinhado: TJvSpeedButton;
    cmbUltimasChamadasFonte: TJvFontComboBox;
    cmbUltimasChamadasFontSize: TComboBox;
    cmbUltimasChamadasFontColor: TJvOfficeColorButton;
    OLDpnlTV: TGroupBox;
    pnlVideo: TGroupBox;
    tbsFlash: TTabSheet;
    pnlFlash: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    edFlashRefresh: TEdit;
    edFlashFileName: TJvFilenameEdit;
    pnlChamadaSenhas: TGroupBox;
    groupChamadaDeSenhasFonte: TGroupBox;
    btnChamadaSenhasNegrito: TJvSpeedButton;
    btnChamadaSenhasItalico: TJvSpeedButton;
    btnChamadaSenhasSublinhado: TJvSpeedButton;
    cmbChamadaSenhasFonte: TJvFontComboBox;
    cmbChamadaSenhasFontSize: TComboBox;
    cmbChamadaSenhasFontColor: TJvOfficeColorButton;
    groupChamadaDeSenhasSom: TGroupBox;
    edChamadaSenhasSoundFileName: TJvFilenameEdit;
    Panel1: TPanel;
    btnAplicar: TButton;
    Label24: TLabel;
    grbVsVideoCaptureDevice: TGroupBox;
    Label25: TLabel;
    Label104: TLabel;
    cboVideoInputs: TComboBox;
    cboVideoDevices: TComboBox;
    cboVideoSubtypes: TComboBox;
    cboVideoSizes: TComboBox;
    grbPreview: TGroupBox;
    btnStartPreview: TBitBtn;
    grbAudioCaptureDevice: TGroupBox;
    Label27: TLabel;
    Label49: TLabel;
    Label36: TLabel;
    cboAudioDevices: TComboBox;
    cboAudioInputs: TComboBox;
    tbrAudioInputLevel: TTrackBar;
    tbrAudioInputBalance: TTrackBar;
    grbAudioRendering: TGroupBox;
    Label28: TLabel;
    Label29: TLabel;
    tbrAudioVolume: TTrackBar;
    tbrAudioBalance: TTrackBar;
    cboAudioRenderers: TComboBox;
    dtsCanalPadrao: TDataSource;
    dblkpCanalPadrao: TDBLookupComboBox;
    tbsJornalEletronico: TTabSheet;
    GroupBox3: TGroupBox;
    groupJornalEletronicoFonte: TGroupBox;
    btnJornalEletronicoNegrito: TJvSpeedButton;
    btnJornalEletronicoItalico: TJvSpeedButton;
    btnJornalEletronicoSublinhado: TJvSpeedButton;
    cmbJornalEletronicoFonte: TJvFontComboBox;
    cmbJornalEletronicoFontSize: TComboBox;
    cmbJornalEletronicoFontColor: TJvOfficeColorButton;
    Label30: TLabel;
    edtJornalEletronicoInterval: TEdit;
    groupChamadaDeSenhasPAsPermitidas: TGroupBox;
    edChamadaSenhasPASPermitidas: TEdit;
    groupUltimasChamadasPAsPermitidas: TGroupBox;
    edUltimasChamadasPASPermitidas: TEdit;
    Label31: TLabel;
    edtIdTV: TEdit;
    lstVideoFileNames: TListBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    OpenDialogVideos: TOpenDialog;
    btnSubir: TBitBtn;
    btnDescer: TBitBtn;
    tbsIndicadoresDePerformance: TTabSheet;
    GroupBox7: TGroupBox;
    Label22: TLabel;
    edHTMLFileName: TJvFilenameEdit;
    chkCorDaFonteAcompanhaNivelPI: TCheckBox;
    groupChamadaDeSenhasLayout: TGroupBox;
    groupChamadaDeSenhasLayoutSenha: TGroupBox;
    Label32: TLabel;
    edChamadaDeSenhasLayoutSenhaX: TEdit;
    Label33: TLabel;
    edChamadaDeSenhasLayoutSenhaY: TEdit;
    Label23: TLabel;
    edChamadaDeSenhasLayoutSenhaLarg: TEdit;
    Label35: TLabel;
    edChamadaDeSenhasLayoutSenhaAlt: TEdit;
    chkChamadaDeSenhasLayoutMostrarSenha: TCheckBox;
    groupChamadaDeSenhasLayoutPA: TGroupBox;
    Label34: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    edChamadaDeSenhasLayoutPAX: TEdit;
    edChamadaDeSenhasLayoutPAY: TEdit;
    edChamadaDeSenhasLayoutPALarg: TEdit;
    edChamadaDeSenhasLayoutPAAlt: TEdit;
    chkChamadaDeSenhasLayoutMostrarPA: TCheckBox;
    groupChamadaDeSenhasLayoutNomeCliente: TGroupBox;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    edChamadaDeSenhasLayoutNomeClienteX: TEdit;
    edChamadaDeSenhasLayoutNomeClienteY: TEdit;
    edChamadaDeSenhasLayoutNomeClienteLarg: TEdit;
    edChamadaDeSenhasLayoutNomeClienteAlt: TEdit;
    chkChamadaDeSenhasLayoutMostrarNomeCliente: TCheckBox;
    groupUltimasChamadasLayout: TGroupBox;
    groupUltimasChamadasLayoutSenha: TGroupBox;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    edUltimasChamadasLayoutSenhaX: TEdit;
    edUltimasChamadasLayoutSenhaY: TEdit;
    edUltimasChamadasLayoutSenhaLarg: TEdit;
    edUltimasChamadasLayoutSenhaAlt: TEdit;
    chkUltimasChamadasLayoutMostrarSenha: TCheckBox;
    groupUltimasChamadasLayoutPA: TGroupBox;
    Label13: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    edUltimasChamadasLayoutPAX: TEdit;
    edUltimasChamadasLayoutPAY: TEdit;
    edUltimasChamadasLayoutPALarg: TEdit;
    edUltimasChamadasLayoutPAAlt: TEdit;
    chkUltimasChamadasLayoutMostrarPA: TCheckBox;
    groupUltimasChamadasLayoutNomeCliente: TGroupBox;
    Label47: TLabel;
    Label48: TLabel;
    Label50: TLabel;
    Label51: TLabel;
    edUltimasChamadasLayoutNomeClienteX: TEdit;
    edUltimasChamadasLayoutNomeClienteY: TEdit;
    edUltimasChamadasLayoutNomeClienteLarg: TEdit;
    edUltimasChamadasLayoutNomeClienteAlt: TEdit;
    chkUltimasChamadasLayoutMostrarNomeCliente: TCheckBox;
    groupUltimasChamadasLayoutDisposicao: TGroupBox;
    rbUltimasChamadasDisposicaoEmLinhas: TRadioButton;
    rbUltimasChamadasDisposicaoEmColunas: TRadioButton;
    Label7: TLabel;
    edUltimasChamadasQuantidade: TEdit;
    Label52: TLabel;
    edUltimasChamadasEspacamento: TEdit;
    btnUltimasChamadasLayoutSenhaAlinhaEsquerda: TSpeedButton;
    btnUltimasChamadasLayoutSenhaAlinhaCentro: TSpeedButton;
    btnUltimasChamadasLayoutSenhaAlinhaDireita: TSpeedButton;
    btnUltimasChamadasLayoutPAAlinhaEsquerda: TSpeedButton;
    btnUltimasChamadasLayoutPAAlinhaCentro: TSpeedButton;
    btnUltimasChamadasLayoutPAAlinhaDireita: TSpeedButton;
    btnUltimasChamadasLayoutNomeClienteAlinhaEsquerda: TSpeedButton;
    btnUltimasChamadasLayoutNomeClienteAlinhaCentro: TSpeedButton;
    btnUltimasChamadasLayoutNomeClienteAlinhaDireita: TSpeedButton;
    btnChamadaDeSenhasLayoutSenhaAlinhaEsquerda: TSpeedButton;
    btnChamadaDeSenhasLayoutSenhaAlinhaCentro: TSpeedButton;
    btnChamadaDeSenhasLayoutSenhaAlinhaDireita: TSpeedButton;
    btnChamadaDeSenhasLayoutPAAlinhaEsquerda: TSpeedButton;
    btnChamadaDeSenhasLayoutPAAlinhaCentro: TSpeedButton;
    btnChamadaDeSenhasLayoutPAAlinhaDireita: TSpeedButton;
    btnChamadaDeSenhasLayoutNomeClienteAlinhaEsquerda: TSpeedButton;
    btnChamadaDeSenhasLayoutNomeClienteAlinhaCentro: TSpeedButton;
    btnChamadaDeSenhasLayoutNomeClienteAlinhaDireita: TSpeedButton;
    Label14: TLabel;
    cboAnalogVideoStandard: TComboBox;
    Label15: TLabel;
    btnStopPreview: TBitBtn;
    edWidth: TEdit;
    edHeight: TEdit;
    Label16: TLabel;
    Label17: TLabel;
    lstVozChamada: TCheckListBox;
    btnSubirChamada: TBitBtn;
    btnDescerChamada: TBitBtn;
    chkArquivo: TCheckBox;
    chkVoz: TCheckBox;
    GroupBox1: TGroupBox;
    lblIndicador: TLabel;
    edtIndicador: TEdit;
    edtSomPI: TJvFilenameEdit;
    lblArquivoSomPI: TLabel;
    pnlTV: TGroupBox;
    Label3: TLabel;
    cboSoftwaresHomologados: TComboBox;
    Label53: TLabel;
    Label54: TLabel;
    edCaminhoExecutavel: TEdit;
    edNomeJanela: TEdit;
    lblNome: TLabel;
    cbxDispositivo: TComboBox;
    lblResolucao: TLabel;
    cbxResolucao: TComboBox;
    lblResolucaoPadrao: TLabel;
    edResolucaoPadrao: TEdit;
    lblTempoAlternancia: TLabel;
    edtTempoAlternancia: TEdit;
    trckVolume: TTrackBar;
    lblVolume: TLabel;
    tbsPlayListManager: TTabSheet;
    GroupBox2: TGroupBox;
    edtIDTVPlayListManager: TEdit;
    Label55: TLabel;
    cbTipoBancoPlayList: TComboBox;
    Label56: TLabel;
    Label57: TLabel;
    edtHostBancoPlayList: TEdit;
    edtPortaBancoPlayList: TEdit;
    Label58: TLabel;
    lblBancoDados: TLabel;
    edtNomeArquivoBancoPlayList: TEdit;
    Label60: TLabel;
    edtUsuarioBancoPlayList: TEdit;
    Label61: TLabel;
    edtSenhaBancoPlayList: TEdit;
    Label62: TLabel;
    edtDiretorioLocalPlayList: TEdit;
    Label63: TLabel;
    edtIntervaloVerificacaoPlayList: TEdit;
    Label59: TLabel;
    edUltimasChamadasAtraso: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure rbBackgroundImageClick(Sender: TObject);
    procedure btnAplicarClick(Sender: TObject);
    procedure cmbUltimasChamadasFonteChange(Sender: TObject);
    procedure lstQuadrosClick(Sender: TObject);
    procedure cboVideoInputsChange(Sender: TObject);
    procedure cboVideoSizesChange(Sender: TObject);
    procedure cboVideoSubtypesChange(Sender: TObject);
    procedure cboAudioDevicesChange(Sender: TObject);
    procedure cboAudioInputsChange(Sender: TObject);
    procedure tbrAudioInputLevelChange(Sender: TObject);
    procedure tbrAudioInputBalanceChange(Sender: TObject);
    procedure cboAudioRenderersChange(Sender: TObject);
    procedure lstQuadrosKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure btnSubirClick(Sender: TObject);
    procedure btnDescerClick(Sender: TObject);
    procedure chkChamadaDeSenhasLayoutMostrarSenhaClick(Sender: TObject);
    procedure lstVideoFileNamesClick(Sender: TObject);
    procedure btnSubirChamadaClick(Sender: TObject);
    procedure btnDescerChamadaClick(Sender: TObject);
    procedure cboSoftwaresHomologadosChange(Sender: TObject);
    procedure cbxDispositivoChange(Sender: TObject);
    procedure cbxResolucaoChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cbTipoBancoPlayListSelect(Sender: TObject);
  private
    { Private declarations }


    procedure buscarResolucoes(numResolucao : Integer);
  public
     vPanel: TjvPanel;
    procedure AdicionarPanelNaLista(Panel: TJvPanel);
    procedure RemoverPainleDaLista(Panel: TJvPanel);
    procedure IdentificarPlacaDeCaptura(numPlaca : Integer = -1);
    procedure CriarObjetoDeCapturaPopularResolucao(numResolucao : Integer;panelHandle : THandle);
    procedure StartStreaming;
    procedure StopStreaming;
    procedure DeleteCapture;
    procedure SetWindowPosition(panel : TJvPanel);
  end;

var
  frmSicsProperties: TfrmSicsProperties;
  captureObject : THandle;
  streamStarted : Boolean;
  resolucoes    : TStringList;

implementation

uses
  SicsTV_m,
  untAVerCapAPI,
  VideoCaptureMain,
  VideoCapturetypes,
  SicsTV_Parametros,
  Sics_Common_Parametros,
  Sics_Common_DataModuleClientConnection;

{$R *.dfm}

procedure TfrmSicsProperties.rbBackgroundImageClick(Sender: TObject);
begin
  edBackgroundImage .Enabled := rbBackgroundImage.Checked;
  cmbBackgroundColor.Enabled := rbBackGroundColor.Checked;
end;

procedure TfrmSicsProperties.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  //frmSicsTVPrincipal.FormStyle := fsStayOnTop;
end;

procedure TfrmSicsProperties.FormCreate(Sender: TObject);
begin
  LoadPosition (Sender as TForm);
  resolucoes := TStringList.Create;
  streamStarted := False;
end;

procedure TfrmSicsProperties.FormDestroy(Sender: TObject);
begin
  SavePosition (Sender as TForm);
  DeleteCapture;
end;

procedure TfrmSicsProperties.FormResize(Sender: TObject);
begin
//  ClientWidth := PageControl1.Width + pnlListaPanels.Width + 10;
//  ClientHeight := btnAplicar.Top + btnAplicar.Height + 2;
end;


procedure TfrmSicsProperties.btnAplicarClick(Sender: TObject);
var
  LJSONPainel : TJSONObject;
  LJSONArray  : TJSONArray;
begin
  if frmSicsTVPrincipal.vgTVComponent.SoftwareHomologado = 4 then
  begin
    frmSicsTVPrincipal.SetVolumeIni(frmSicsProperties.trckVolume.Position);
  end
  else
  begin
    if not Assigned(frmSicsTVPrincipal.VFVideoCapture) then
      frmSicsTVPrincipal.VFVideoCapture  := TVFVideoCapture.Create(Self);

    frmSicsTVPrincipal.VFVideoCapture.Audio_OutputDevice_SetVolume(frmSicsProperties.trckVolume.Position);
  end;

  Screen.Cursor := crHourGlass;
  try
    frmSicsTVPrincipal.SetPanelProperties(frmSicsTVPrincipal.FindComponent('Panel'+inttostr(vgPainelSelecionado)) as TJvPanel);
    SicsTV_Parametros.SalvarParametrosTVPaineis(vgParametrosModulo.Paineis[vgPainelSelecionado]);

    LJSONPainel := SicsTV_Parametros.SalvarParametrosTVPaineis(vgParametrosModulo.Paineis[vgPainelSelecionado]);

    LJSONArray := TJSONArray.Create;
    LJSONArray.AddElement(LJSONPainel);

    dmSicsClientConnection.SendCommandToHost (0, $8D, Chr($46) + TAspEncode.AspIntToHex(vgParametrosModulo.IdModulo, 4) + LJSONArray.ToJSON, 0);
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmSicsProperties.cmbUltimasChamadasFonteChange(Sender: TObject);
begin
  if (Sender is TjvFontComboBox) then
    (Sender as TjvFontComboBox).Hint := (Sender as TjvFontComboBox).FontName;
end;

procedure TfrmSicsProperties.CriarObjetoDeCapturaPopularResolucao(
  numResolucao: Integer;panelHandle : THandle);
begin
  if(captureObject = 0) and (cbxDispositivo.ItemIndex <> -1) and (panelHandle <> 0)then
  begin
    if(AVerCreateCaptureObjectEx(cbxDispositivo.ItemIndex,CAPTURETYPE_HD,panelHandle,captureObject) <> CAP_EC_SUCCESS)then
    begin
      MessageDlg('Não foi possivel criar o objeto de captura', mtError, [mbOk], 0);
      Exit;
    end;
    buscarResolucoes(numResolucao);
  end;
end;

procedure TfrmSicsProperties.DeleteCapture;
begin
  StopStreaming;
  AVerDeleteCaptureObject(captureObject);
  captureObject := 0;
end;

procedure TfrmSicsProperties.AdicionarPanelNaLista(Panel: TJvPanel);
begin
  lstQuadros.Items.Add(TTipoDePainelStr[TTipoDePainel(strtoint(Panel.Hint))] + ' - ' + Panel.Name);
end;

procedure TfrmSicsProperties.lstQuadrosClick(Sender: TObject);
var
  sName: string;
begin
  sName := lstQuadros.Items[lstQuadros.ItemIndex];
  with TStringList.Create do
  try
    Text := StringReplace(sName, '-', #13 + #10, []);
    sName := Trim(Strings[1]);
  finally
    Free;
  end;
  vPanel := TjvPanel(frmSicsTVPrincipal.FindComponent(sName));
  vgPainelSelecionado := vPanel.Tag;

  frmSicsTVPrincipal.GetPanelProperties(vPanel);
end;                                                       

procedure TfrmSicsProperties.cboVideoInputsChange(Sender: TObject);
begin
  //LBC VERIFICAR COMPONENTE frmSicsTVPrincipal.vgTVComponent.VideoInput := cboVideoInputs.ItemIndex;
end;

procedure TfrmSicsProperties.cboVideoSizesChange(Sender: TObject);
begin
  //LBC VERIFICAR COMPONENTE frmSicsTVPrincipal.vgTVComponent.VideoSize := cboVideoSizes.ItemIndex;
end;

procedure TfrmSicsProperties.cboVideoSubtypesChange(Sender: TObject);
begin
  //LBC VERIFICAR COMPONENTE frmSicsTVPrincipal.vgTVComponent.VideoSubtype := cboVideoSubtypes.ItemIndex;
end;

procedure TfrmSicsProperties.cbTipoBancoPlayListSelect(Sender: TObject);
begin
  case cbTipoBancoPlayList.ItemIndex of
    0: lblBancoDados.Caption := 'Caminho do Banco';
    1: lblBancoDados.Caption := 'Nome do Banco';
  end;
end;

procedure TfrmSicsProperties.cbxDispositivoChange(Sender: TObject);
begin
  CriarObjetoDeCapturaPopularResolucao(-1,vPanel.Handle);
end;

procedure TfrmSicsProperties.cbxResolucaoChange(Sender: TObject);
var
  videoresolution : VIDEO_RESOLUTION;
begin
  StopStreaming;
  VideoResolution.dwVersion := 1;
  VideoResolution.dwVideoResolution := StrToInt(resolucoes.Strings[cbxResolucao.ItemIndex]);
  VideoResolution.bCustom := False;
  VideoResolution.dwWidth := 0;
  VideoResolution.dwHeight := 0;
  AVerSetVideoResolutionEx(captureObject, VideoResolution);
  StartStreaming;
end;

procedure TfrmSicsProperties.cboAudioDevicesChange(Sender: TObject);
begin
  //LBC VERIFICAR COMPONENTE frmSicsTVPrincipal.vgTVComponent.AudioDevice := cboAudioDevices.ItemIndex;
end;

procedure TfrmSicsProperties.cboAudioInputsChange(Sender: TObject);
begin
  //LBC VERIFICAR COMPONENTE frmSicsTVPrincipal.vgTVComponent.AudioInput := cboAudioInputs.ItemIndex;
end;

procedure TfrmSicsProperties.tbrAudioInputLevelChange(Sender: TObject);
begin
  //LBC VERIFICAR COMPONENTE frmSicsTVPrincipal.vgTVComponent.AudioInputLevel := tbrAudioInputLevel.Position;
end;

procedure TfrmSicsProperties.tbrAudioInputBalanceChange(Sender: TObject);
begin
  //LBC VERIFICAR COMPONENTE frmSicsTVPrincipal.vgTVComponent.AudioInputBalance := tbrAudioInputBalance.Position;
end;

procedure TfrmSicsProperties.cboAudioRenderersChange(Sender: TObject);
begin
  //LBC VERIFICAR COMPONENTE frmSicsTVPrincipal.vgTVComponent.AudioRenderer := cboAudioRenderers.ItemIndex;
end;

procedure TfrmSicsProperties.cboSoftwaresHomologadosChange (Sender: TObject);

begin
  case (Sender as TComboBox).ItemIndex of
    0 : begin
          edCaminhoExecutavel.Clear;
          edNomeJanela       .Clear;
          edResolucaoPadrao  .Clear;
          edCaminhoExecutavel.Enabled := true;
          edNomeJanela       .Enabled := true;
          cbxResolucao       .Enabled := False;
          cbxDispositivo     .Enabled := False;
          cbxResolucao       .ItemIndex := -1;
          cbxDispositivo     .ItemIndex := -1;
          edResolucaoPadrao  .Enabled := False;
          lblVolume          .Visible := False;
          trckVolume         .Visible := False;
          DeleteCapture;
          vPanel.Refresh;
        end;
    1 : begin
          edCaminhoExecutavel.Text := 'C:\Program Files (x86)\AVerMedia\AVerTV 3D\AVerTV.exe';
          edNomeJanela       .Text := 'AverTV - Vídeo';
          edResolucaoPadrao  .Text := '0x0';
          DeleteCapture;
        end;

    2 : begin
          edCaminhoExecutavel.Text := 'C:\Program Files (x86)\VideoLAN\VLC\vlc.exe';
          edNomeJanela       .Text := 'Reprodutor de Mídias VLC';
          edResolucaoPadrao  .Clear;
        end;
    3 : begin
          IdentificarPlacaDeCaptura;
          edCaminhoExecutavel.Clear;
          edNomeJanela       .Clear;
          edCaminhoExecutavel.Enabled := False;
          edNomeJanela       .Enabled := False;
          cbxDispositivo     .Enabled := True;
          cbxResolucao       .ItemIndex := -1;
          cbxDispositivo     .ItemIndex := -1;
          edResolucaoPadrao  .Enabled := False;
          lblVolume          .Visible := False;
          trckVolume         .Visible := False;
          edResolucaoPadrao  .Clear;
        end;
    4,6 : begin
          edCaminhoExecutavel.Clear;
          edNomeJanela       .Clear;
          edCaminhoExecutavel.Enabled := False;
          edNomeJanela       .Enabled := False;
          cbxDispositivo     .Enabled := True;
          cbxResolucao       .ItemIndex := -1;
          cbxDispositivo     .ItemIndex := -1;
          edResolucaoPadrao  .Enabled := False;
          lblVolume          .Visible := True;
          trckVolume         .Visible := True;
          edResolucaoPadrao  .Clear;
        end;
    5 : begin
          edCaminhoExecutavel.Text    := 'SicsLiveTV.exe';
          edNomeJanela       .Text    := 'SICS LIVETV';
          edResolucaoPadrao  .Clear;
        end;
  end;

  if (frmSicsTVPrincipal.SoftwarePadraoTV((Sender as TComboBox).ItemIndex) or ((Sender as TComboBox).ItemIndex = 2)) then
  begin
    edCaminhoExecutavel.Enabled   := true;
    edNomeJanela       .Enabled   := true;
    cbxResolucao       .Enabled   := False;
    cbxDispositivo     .Enabled   := False;
    cbxResolucao       .ItemIndex := -1;
    cbxDispositivo     .ItemIndex := -1;
    edResolucaoPadrao  .Enabled   := False;
    lblVolume          .Visible   := False;
    trckVolume         .Visible   := False;
    vPanel.Refresh;
  end;
end;

procedure TfrmSicsProperties.IdentificarPlacaDeCaptura(numPlaca : Integer = -1);
var
  vTotalDevice : DWORD;
  I: Integer;
  vDeviceName : LPWSTR;
begin
    if(cbxDispositivo.Items.Count = 0)then
    begin
      if(AVerGetDeviceNum(vTotalDevice) <> CAP_EC_SUCCESS)then
       begin
          MessageDlg('Não foi possivel obter o número dos dispositivos', mtError, [mbOk], 0);
          Exit;
       end;
       if(vTotalDevice = 0)then
       begin
         MessageDlg('Não foi encontrado dispositivo conectado', mtError, [mbOk], 0);
         Exit;
       end;

      vDeviceName := StrAlloc(100);
      cbxDispositivo.Items.Clear;
      for I := 0 to vTotalDevice -1 do
      begin
        if(AVerGetDeviceName(I,vDeviceName) <> CAP_EC_SUCCESS)then
        begin
          MessageDlg('Não foi possível obter o nome da placa de captura', mtError, [mbOk], 0);
          Exit;
        end;
        cbxDispositivo.Items.Add(vDeviceName);

      end;
    end;

    if(numPlaca <> -1)then
    begin
      cbxDispositivo.ItemIndex := numPlaca;
    end;
end;

procedure TfrmSicsProperties.lstQuadrosKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_DELETE then
    frmSicsTVPrincipal.ExcluirPainel;
end;

procedure TfrmSicsProperties.RemoverPainleDaLista(Panel: TJvPanel);
var
  iIndex: Integer;
begin
  iIndex := lstQuadros.Items.IndexOf(TTipoDePainelStr[TTipoDePainel(strtoint(Panel.Hint))] + ' - ' + Panel.Name);
  if iIndex >= 0 then
    lstQuadros.Items.Delete(iIndex);
end;

procedure TfrmSicsProperties.SetWindowPosition(panel: TJvPanel);
var
  rectan : TRect;
  width : Integer;
begin
  if(streamStarted)then
  begin
    rectan := Rect(0,0,panel.Width,panel.Height);
    AVerSetVideoWindowPosition(captureObject,rectan);
  end;
end;

procedure TfrmSicsProperties.StartStreaming;
begin
  AVerSetVideoRenderer(captureObject, VIDEORENDERER_EVR);
  AVerSetVideoInputFrameRate(captureObject,2997);
  if(not  streamStarted)then
  begin
    if(AVerStartStreaming(captureObject) <> CAP_EC_SUCCESS)then
    begin
      streamStarted := false;
    end
    else
      streamStarted := True;
  end;
end;

procedure TfrmSicsProperties.StopStreaming;
begin
  if(streamStarted)then
  begin
    if(AVerStopStreaming(captureObject) <> CAP_EC_SUCCESS)then
    begin
      streamStarted := True;
    end
    else
    begin
      streamStarted := False;
      //vPanel.Refresh;
    end;
  end;
end;

procedure TfrmSicsProperties.BitBtn1Click(Sender: TObject);
begin
  if OpenDialogVideos.Execute then
    if lstVideoFileNames.Items.IndexOf(OpenDialogVideos.FileName) >= 0 then
      MessageDlg('Este vídeo já está na lista', mtError, [mbOk], 0)
    else
      lstVideoFileNames.Items.Add(OpenDialogVideos.FileName);
end;

procedure TfrmSicsProperties.BitBtn2Click(Sender: TObject);
begin
  if lstVideoFileNames.ItemIndex >= 0 then
    if MessageDlg('Confirma a exlcusão deste item?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      lstVideoFileNames.DeleteSelected;
end;

procedure TfrmSicsProperties.btnSubirClick(Sender: TObject);
var
  NewIndex: Integer;
begin
  if lstVideoFileNames.ItemIndex >= 1 then
  begin
    NewIndex := lstVideoFileNames.ItemIndex - 1;
    lstVideoFileNames.Items.Move(lstVideoFileNames.ItemIndex, NewIndex);
    lstVideoFileNames.ItemIndex := NewIndex;
  end;
end;

procedure TfrmSicsProperties.buscarResolucoes(numResolucao : Integer);

var
  pdwVideoSource : DWORD;
  pdwVideoFormat : DWORD;
  num            : DWORD;
  pdwSupported   : TIntegerDynArray;
  i,index        : Integer;
  VideoResolution : VIDEO_RESOLUTION;

begin
  cbxResolucao.Enabled := True;
  pdwVideoSource := 0;
  pdwVideoFormat := 0;
  AVerGetVideoSource(captureObject,pdwVideoSource);
  AVerGetVideoFormat(captureObject,pdwVideoFormat);

  num := 0;
  pdwSupported := nil;
  AVerGetVideoResolutionSupported(captureObject,pdwVideoSource,pdwVideoFormat,pdwSupported,num);
  SetLength(pdwSupported,num);
  AVerGetVideoResolutionSupported(captureObject,pdwVideoSource,pdwVideoFormat,pdwSupported,num);
  if(numResolucao = -1)then
  begin
    VideoResolution.dwVersion := 1;
    AVerGetVideoResolutionEx (captureObject,  VideoResolution);
  end
  else
  begin
    VideoResolution.dwVersion := 1;
    VideoResolution.dwVideoResolution := numResolucao;
    VideoResolution.bCustom := False;
    AVerSetVideoResolutionEx(captureObject,VideoResolution)
  end;

  index := 0;
  for I in pdwSupported do
  begin

      resolucoes.Add(IntToStr(i));


      case (i)  of
        VIDEORESOLUTION_640X480:
        begin
          cbxResolucao.Items.Add('640 X 480');
          if(VideoResolution.dwVideoResolution = i)then
          begin
            cbxResolucao.ItemIndex := index;
          end;
          Inc(index);
        end;
        VIDEORESOLUTION_704X576:
        begin
          cbxResolucao.Items.Add('704 X 576');
          if(VideoResolution.dwVideoResolution = i)then
          begin
            cbxResolucao.ItemIndex := index;
          end;
          Inc(index);
        end;
        VIDEORESOLUTION_720X480 :
        begin
          cbxResolucao.Items.Add('720 X 480');
          if(VideoResolution.dwVideoResolution = i)then
          begin
            cbxResolucao.ItemIndex := index;
          end;
          Inc(index);
        end;
        VIDEORESOLUTION_720X576:
        begin
          cbxResolucao.Items.Add('720 X 576');
          if(VideoResolution.dwVideoResolution = i)then
          begin
            cbxResolucao.ItemIndex := index;
          end;
          Inc(index);
        end;
        VIDEORESOLUTION_1920X1080 :
        begin
          cbxResolucao.Items.Add('1920 X 1080');
          if(VideoResolution.dwVideoResolution = i)then
          begin
            cbxResolucao.ItemIndex := index;
          end;
          Inc(index);
        end;
        VIDEORESOLUTION_160X120 :
        begin
          cbxResolucao.Items.Add('160 X 120');
          if(VideoResolution.dwVideoResolution = i)then
          begin
            cbxResolucao.ItemIndex := index;
          end;
          Inc(index);
        end;
        VIDEORESOLUTION_176X144 :
        begin
          cbxResolucao.Items.Add('176 X 144');
          if(VideoResolution.dwVideoResolution = i)then
          begin
            cbxResolucao.ItemIndex := index;
          end;
          Inc(index);
        end;
        VIDEORESOLUTION_240X176 :
        begin
          cbxResolucao.Items.Add('240 X 176');
          if(VideoResolution.dwVideoResolution = i)then
          begin
            cbxResolucao.ItemIndex := index;
          end;
          Inc(index);
        end;
        VIDEORESOLUTION_240X180 :
        begin
          cbxResolucao.Items.Add('240 X 180');
          if(VideoResolution.dwVideoResolution = i)then
          begin
            cbxResolucao.ItemIndex := index;
          end;
          Inc(index);
        end;
        VIDEORESOLUTION_320X240 :
        begin
          cbxResolucao.Items.Add('320 X 240');
          if(VideoResolution.dwVideoResolution = i)then
          begin
            cbxResolucao.ItemIndex := index;
          end;
          Inc(index);
        end;
        VIDEORESOLUTION_352X240 :
        begin
          cbxResolucao.Items.Add('352 X 240');
          if(VideoResolution.dwVideoResolution = i)then
          begin
            cbxResolucao.ItemIndex := index;
          end;
          Inc(index);
        end;
        VIDEORESOLUTION_352X288 :
        begin
          cbxResolucao.Items.Add('352 X 288');
          if(VideoResolution.dwVideoResolution = i)then
          begin
            cbxResolucao.ItemIndex := index;
          end;
          Inc(index);
        end;
        VIDEORESOLUTION_640X240 :
        begin
          cbxResolucao.Items.Add('640 X 240');
          if(VideoResolution.dwVideoResolution = i)then
          begin
            cbxResolucao.ItemIndex := index;
          end;
          Inc(index);
        end;
        VIDEORESOLUTION_640X288 :
        begin
          cbxResolucao.Items.Add('640 X 288');
          if(VideoResolution.dwVideoResolution = i)then
          begin
            cbxResolucao.ItemIndex := index;
          end;
          Inc(index);
        end;
        VIDEORESOLUTION_720X240 :
        begin
          cbxResolucao.Items.Add('720 X 240');
          if(VideoResolution.dwVideoResolution = i)then
          begin
            cbxResolucao.ItemIndex := index;
          end;
          Inc(index);
        end;
        VIDEORESOLUTION_720X288 :
        begin
          cbxResolucao.Items.Add('720 X 288');
          if(VideoResolution.dwVideoResolution = i)then
          begin
            cbxResolucao.ItemIndex := index;
          end;
          Inc(index);
        end;
        VIDEORESOLUTION_80X60   :
        begin
          cbxResolucao.Items.Add('80 X 60  ');
          if(VideoResolution.dwVideoResolution = i)then
          begin
            cbxResolucao.ItemIndex := index;
          end;
          Inc(index);
        end;
        VIDEORESOLUTION_88X72   :
        begin
          cbxResolucao.Items.Add('88 X 72  ');
          if(VideoResolution.dwVideoResolution = i)then
          begin
            cbxResolucao.ItemIndex := index;
          end;
          Inc(index);
        end;
        VIDEORESOLUTION_128X96  :
        begin
          cbxResolucao.Items.Add('128 X 96 ');
          if(VideoResolution.dwVideoResolution = i)then
          begin
            cbxResolucao.ItemIndex := index;
          end;
          Inc(index);
        end;
        VIDEORESOLUTION_640X576 :
        begin
          cbxResolucao.Items.Add('640 X 576');
          if(VideoResolution.dwVideoResolution = i)then
          begin
            cbxResolucao.ItemIndex := index;
          end;
          Inc(index);
        end;
        VIDEORESOLUTION_180X120 :
        begin
          cbxResolucao.Items.Add('180 X 120');
          if(VideoResolution.dwVideoResolution = i)then
          begin
            cbxResolucao.ItemIndex := index;
          end;
          Inc(index);
        end;
        VIDEORESOLUTION_180X144 :
        begin
          cbxResolucao.Items.Add('180 X 144');
          if(VideoResolution.dwVideoResolution = i)then
          begin
            cbxResolucao.ItemIndex := index;
          end;
          Inc(index);
        end;
        VIDEORESOLUTION_360X240 :
        begin
          cbxResolucao.Items.Add('360 X 240');
          if(VideoResolution.dwVideoResolution = i)then
          begin
            cbxResolucao.ItemIndex := index;
          end;
          Inc(index);
        end;
        VIDEORESOLUTION_360X288 :
        begin
          cbxResolucao.Items.Add('360 X 288');
          if(VideoResolution.dwVideoResolution = i)then
          begin
            cbxResolucao.ItemIndex := index;
          end;
          Inc(index);
        end;
        VIDEORESOLUTION_768X576 :
        begin
          cbxResolucao.Items.Add('768 X 576');
          if(VideoResolution.dwVideoResolution = i)then
          begin
            cbxResolucao.ItemIndex := index;
          end;
          Inc(index);
        end;
        VIDEORESOLUTION_384x288 :
        begin
          cbxResolucao.Items.Add('384 X 288');
          if(VideoResolution.dwVideoResolution = i)then
          begin
            cbxResolucao.ItemIndex := index;
          end;
          Inc(index);
        end;
        VIDEORESOLUTION_192x144 :
        begin
          cbxResolucao.Items.Add('192 X 144 ');
          if(VideoResolution.dwVideoResolution = i)then
          begin
            cbxResolucao.ItemIndex := index;
          end;
          Inc(index);
        end;
        VIDEORESOLUTION_1280X720 :
        begin
          cbxResolucao.Items.Add('1280 X 720');
          if(VideoResolution.dwVideoResolution = i)then
          begin
            cbxResolucao.ItemIndex := index;
          end;
          Inc(index);
        end;
        VIDEORESOLUTION_1024X768 :
        begin
          cbxResolucao.Items.Add('1024 X 768');
          if(VideoResolution.dwVideoResolution = i)then
          begin
            cbxResolucao.ItemIndex := index;
          end;
          Inc(index);
        end;
        VIDEORESOLUTION_1280X800 :
        begin
          cbxResolucao.Items.Add('1280 X 800');
          if(VideoResolution.dwVideoResolution = i)then
          begin
            cbxResolucao.ItemIndex := index;
          end;
          Inc(index);
        end;
        VIDEORESOLUTION_1280X1024 :
        begin
          cbxResolucao.Items.Add('1280 X 1024');
          if(VideoResolution.dwVideoResolution = i)then
          begin
            cbxResolucao.ItemIndex := index;
          end;
          Inc(index);
        end;
        VIDEORESOLUTION_1440X900 :
        begin
          cbxResolucao.Items.Add('1440 X 900');
          if(VideoResolution.dwVideoResolution = i)then
           begin
             cbxResolucao.ItemIndex := index;
           end;
          Inc(index);
         end;
        VIDEORESOLUTION_1600X1200 :
        begin
          cbxResolucao.Items.Add('1600 X 1200');
          if(VideoResolution.dwVideoResolution = i)then
          begin
            cbxResolucao.ItemIndex := index;
          end;
          Inc(index);
         end;
        VIDEORESOLUTION_1680X1050 :
        begin
          cbxResolucao.Items.Add('1680 X 1050');
          if(VideoResolution.dwVideoResolution = i)then
          begin
            cbxResolucao.ItemIndex := index;
          end;
          Inc(index);
        end;
        VIDEORESOLUTION_800X600 :
        begin
          cbxResolucao.Items.Add('800 X 600');
          if(VideoResolution.dwVideoResolution = i)then
          begin
            cbxResolucao.ItemIndex := index;
          end;
          Inc(index);
        end;
        VIDEORESOLUTION_1280X768 :
        begin
          cbxResolucao.Items.Add('1280 X 768');
          if(VideoResolution.dwVideoResolution = i)then
          begin
            cbxResolucao.ItemIndex := index;
          end;
          Inc(index);
         end;
        VIDEORESOLUTION_1360X768 :
        begin
          cbxResolucao.Items.Add('1360 X 768');
          if(VideoResolution.dwVideoResolution = i)then
          begin
            cbxResolucao.ItemIndex := index;
          end;
          Inc(index);
         end;
        VIDEORESOLUTION_1152X864 :
        begin
          cbxResolucao.Items.Add('1152 X 864');
          if(VideoResolution.dwVideoResolution = i)then
          begin
            cbxResolucao.ItemIndex := index;
          end;
          Inc(index);
         end;
        VIDEORESOLUTION_1280X960 :
        begin
          cbxResolucao.Items.Add('1280 X 960');
          if(VideoResolution.dwVideoResolution = i)then
          begin
            cbxResolucao.ItemIndex := index;
          end;
          Inc(index);
         end;
        VIDEORESOLUTION_702X576 :
        begin
          cbxResolucao.Items.Add('702 X 576');
          if(VideoResolution.dwVideoResolution = i)then
          begin
            cbxResolucao.ItemIndex := index;
          end;
          Inc(index);
        end;
        VIDEORESOLUTION_720X400 :
        begin
          cbxResolucao.Items.Add('720 X 400');
          if(VideoResolution.dwVideoResolution = i)then
          begin
            cbxResolucao.ItemIndex := index;
          end;
          Inc(index);
         end;
        VIDEORESOLUTION_1152X900 :
        begin
          cbxResolucao.Items.Add('1152 X 900');
          if(VideoResolution.dwVideoResolution = i)then
          begin
            cbxResolucao.ItemIndex := index;
          end;
          Inc(index);
         end;
        VIDEORESOLUTION_1360X1024 :
        begin
          cbxResolucao.Items.Add('1360 X 1024');
          if(VideoResolution.dwVideoResolution = i)then
          begin
            cbxResolucao.ItemIndex := index;
          end;
          Inc(index);
        end;
        VIDEORESOLUTION_1366X768 :
        begin
          cbxResolucao.Items.Add('1366 X 768');
          if(VideoResolution.dwVideoResolution = i)then
          begin
            cbxResolucao.ItemIndex := index;
          end;
          Inc(index);
        end;
        VIDEORESOLUTION_1400X1050 :
        begin
          cbxResolucao.Items.Add('1400 X 1050');
          if(VideoResolution.dwVideoResolution = i)then
          begin
            cbxResolucao.ItemIndex := index;
          end;
          Inc(index);
        end;
        VIDEORESOLUTION_1440X480 :
        begin
          cbxResolucao.Items.Add('1440 X 480');
          if(VideoResolution.dwVideoResolution = i)then
          begin
            cbxResolucao.ItemIndex := index;
          end;
          Inc(index);
        end;
        VIDEORESOLUTION_1440X576 :
        begin
          cbxResolucao.Items.Add('1440 X 576');
          if(VideoResolution.dwVideoResolution = i)then
          begin
            cbxResolucao.ItemIndex := index;
          end;
          Inc(index);
        end;
        VIDEORESOLUTION_1600X900 :
        begin
          cbxResolucao.Items.Add('1600 X 900');
          if(VideoResolution.dwVideoResolution = i)then
          begin
            cbxResolucao.ItemIndex := index;
          end;
          Inc(index);
        end;
        VIDEORESOLUTION_1920X1200 :
        begin
          cbxResolucao.Items.Add('1920 X 1200');
          if(VideoResolution.dwVideoResolution = i)then
          begin
            cbxResolucao.ItemIndex := index;
          end;
          Inc(index);
        end;
        VIDEORESOLUTION_1440X1080 :
        begin
          cbxResolucao.Items.Add('1440 X 1080');
          if(VideoResolution.dwVideoResolution = i)then
          begin
            cbxResolucao.ItemIndex := index;
          end;
          Inc(index);
        end;
        VIDEORESOLUTION_1600X1024 :
        begin
          cbxResolucao.Items.Add('1600 X 1024');
          if(VideoResolution.dwVideoResolution = i)then
          begin
            cbxResolucao.ItemIndex := index;
          end;
          Inc(index);
        end;
        VIDEORESOLUTION_3840X2160:
        begin
          cbxResolucao.Items.Add('3840 X 2160');
          if(VideoResolution.dwVideoResolution = i)then
          begin
            cbxResolucao.ItemIndex := index;
          end;
          Inc(index);
        end;
      end;
  end;


end;

procedure TfrmSicsProperties.btnDescerClick(Sender: TObject);
var
  NewIndex: Integer;
begin
  if lstVideoFileNames.ItemIndex < lstVideoFileNames.Count -1 then
  begin
    NewIndex := lstVideoFileNames.ItemIndex + 1;
    lstVideoFileNames.Items.Move(lstVideoFileNames.ItemIndex, NewIndex);
    lstVideoFileNames.ItemIndex := NewIndex;
  end;
end;

procedure TfrmSicsProperties.chkChamadaDeSenhasLayoutMostrarSenhaClick(Sender: TObject);
begin
  EnableDisableAllControls(groupChamadaDeSenhasLayoutSenha      , chkChamadaDeSenhasLayoutMostrarSenha      .Checked );
  EnableDisableAllControls(groupChamadaDeSenhasLayoutPA         , chkChamadaDeSenhasLayoutMostrarPA         .Checked );
  EnableDisableAllControls(groupChamadaDeSenhasLayoutNomeCliente, chkChamadaDeSenhasLayoutMostrarNomeCliente.Checked );

  EnableDisableAllControls(groupUltimasChamadasLayoutSenha      , chkUltimasChamadasLayoutMostrarSenha      .Checked );
  EnableDisableAllControls(groupUltimasChamadasLayoutPA         , chkUltimasChamadasLayoutMostrarPA         .Checked );
  EnableDisableAllControls(groupUltimasChamadasLayoutNomeCliente, chkUltimasChamadasLayoutMostrarNomeCliente.Checked );
end;

procedure TfrmSicsProperties.lstVideoFileNamesClick(Sender: TObject);
begin
  if(lstVideoFileNames.ItemIndex > -1)then
    lstVideoFileNames.Hint := lstVideoFileNames.Items[lstVideoFileNames.ItemIndex];
end;

procedure TfrmSicsProperties.btnSubirChamadaClick(Sender: TObject);
var
  NewIndex: Integer;
begin
  if lstVozChamada.ItemIndex >= 1 then
  begin
    NewIndex := lstVozChamada.ItemIndex - 1;
    lstVozChamada.Items.Move(lstVozChamada.ItemIndex, NewIndex);
    lstVozChamada.ItemIndex := NewIndex;
  end;
end;

procedure TfrmSicsProperties.btnDescerChamadaClick(Sender: TObject);
var
  NewIndex: Integer;
begin
  if lstVozChamada.ItemIndex < lstVozChamada.Count -1 then
  begin
    NewIndex := lstVozChamada.ItemIndex + 1;
    lstVozChamada.Items.Move(lstVozChamada.ItemIndex, NewIndex);
    lstVozChamada.ItemIndex := NewIndex;
  end;
end;

end.
