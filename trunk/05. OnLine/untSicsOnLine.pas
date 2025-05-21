unit untSicsOnLine;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, FMX.Objects, FMX.Layouts,
  MyAspFuncoesUteis, FMX.Edit, FMX.Grid, System.Rtti, untCommonFormBaseOnLineTGS, FMX.Platform,
  untCommonFrameSituacaoEspera, untCommonFrameSituacaoAtendimento,
  FMX.Menus, FMX.ListBox, FMX.Controls.Presentation, untLog, System.Json,
  Data.Bind.EngExt, FMX.Bind.DBEngExt, Data.Bind.Components, System.ImageList, Sics_Common_Parametros,
  FMX.ImgList, System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.DBScope, Data.DB, Datasnap.DBClient,
  FMX.Effects, Sics_Commom_Splash_Fmx, FMX.Ani,System.IniFiles, FMX.Media, System.IOUtils;

{$INCLUDE ..\AspDefineDiretivas.inc}

{$INCLUDE ..\SicsVersoes.pas}

type
  TFrmSicsOnLine = class(TFrmBase_OnLine_TGS)
    ManagePswdPopMenu: TPopupMenu;
    PopUpMenuExcluir: TMenuItem;
    PopUpMenuReimprimir: TMenuItem;
    MainMenu1: TMainMenu;
    menuArquivo: TMenuItem;
    menuSair: TMenuItem;
    menuVisualizar: TMenuItem;
    menuSituacaoDoAtendimento: TMenuItem;
    menuIndicadoresDePerformance: TMenuItem;
    menuModoTotemTouchScreen: TMenuItem;
    menuProcessosParalelos: TMenuItem;
    menuHelp: TMenuItem;
    menuSobre: TMenuItem;
    Shortcuts1: TMenuItem;
    But11: TMenuItem;
    But21: TMenuItem;
    But31: TMenuItem;
    But41: TMenuItem;
    But51: TMenuItem;
    But61: TMenuItem;
    But71: TMenuItem;
    But81: TMenuItem;
    But91: TMenuItem;
    But101: TMenuItem;
    But111: TMenuItem;
    But121: TMenuItem;
    PopUpMenuExcluirTodos: TMenuItem;
    rectBarraTop: TRectangle;
    lblSics: TLabel;
    lblSistemaInteligente: TLabel;
    scrollMenu: TVertScrollBox;
    rectMenu: TRectangle;
    rectLogo: TRectangle;
    imgLogo: TImage;
    btnSituacaoAtendimento: TButton;
    imgIconSituacaoAtendimento: TImage;
    lblSituacaoAtendimento: TLabel;
    btnSituacaoEspera: TButton;
    imgSituacaoEspera: TImage;
    lblSituacaoEspera: TLabel;
    btnIndicadorPerformance: TButton;
    imgIndicadorPerformance: TImage;
    lblIndicadorPerformance: TLabel;
    imgSetaSituacaoAtendimento: TImage;
    imgSetaSituacaoEspera: TImage;
    imgSetaIndicadorPerformance: TImage;
    FloatAnimation2: TFloatAnimation;
    MenuItem1: TMenuItem;
    MediaPlayer: TMediaPlayer;
    PopUpMenuRenomear: TMenuItem;

    procedure InsertSenhaButton1Click(Sender: TObject);
    procedure SenhaEdit1Change(Sender: TObject);

    procedure BitBtn1Click(Sender: TObject);
    procedure PrioritaryList1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure menuSituacaoDoAtendimentoClick(Sender: TObject);
    procedure menuIndicadoresDePerformanceClick(Sender: TObject);
    procedure menuProcessosParalelosClick(Sender: TObject);
    procedure PopUpmenuEnviaTriagemClick(Sender: TObject);
    procedure menuSairClick(Sender: TObject);
    procedure menuSobreClick(Sender: TObject);
    procedure PopUpMenuExcluirClick(Sender: TObject);
    procedure PopUpMenuReimprimirClick(Sender: TObject);
    procedure menuTraySairClick(Sender: TObject);
    procedure lstMenuClick(Sender: TObject);
    procedure PopUpMenuExcluirTodosClick(Sender: TObject);
    procedure ManagePswdPopMenuPopup(Sender: TObject);
    procedure btnSituacaoAtendimentoClick(Sender: TObject);
    procedure btnSituacaoEsperaClick(Sender: TObject);
    procedure btnIndicadorPerformanceClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure PopUpMenuRenomearClick(Sender: TObject);
  private

  protected
    function GetIsIndexOfFrame(const aCurrentIndex: Integer; const aClass: TClass): Boolean; Override;

  public
    existeTelaAberta : Boolean;
    procedure ExibirFrame(const aIndexItem: Integer); Override;
    procedure AlinhaComponentesNaTela;
   	function GetSituacaoAtualPA(Const aPA: Integer): String; Override;
    procedure CarregarParametrosDB; Overload; Override;
    procedure CarregarParametrosDB(const aIDUnidade: Integer); Overload; Override;
    procedure CarregarParametrosINI; Override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; Override;
    procedure desabilitaBotoes(desabilita : Boolean);
    procedure AbrirTelaPadrao;
    procedure Fechar;
    procedure TocaSomNovaSenha;
    procedure GetFilaTriagemPorId(const LIdTriagem: integer; var LFilaTriagem: Integer; var LNomeTriagem: string);
  end;

var
  FrmSicsOnLine: TFrmSicsOnLine;
  filaSelecionada : Integer;

implementation
{$R *.fmx}

uses
  untCommonDMConnection,
  untCommonFrameBase,
  untCommonFrameIndicadorPerformance,
  untCommonFormProcessoParalelo,
  untCommonDMClient,
  untCommonDMUnidades,
  untCommonControleInstanciaAplicacao,
  APIs.Aspect.Sics.BuscarParametro, APIs.Common;

const
  INDEX_SITUACAO_ESPERA = 1;
  INDEX_SITUACAO_ATEND = INDEX_SITUACAO_ESPERA +1;
  INDEX_IND_PERF = INDEX_SITUACAO_ATEND +1;

procedure TFrmSicsOnLine.GetFilaTriagemPorId(const LIdTriagem: integer;
  var LFilaTriagem: Integer; var LNomeTriagem: string);
var
  LJson : TjsonObject;
  LArrayObjeto: TJSONArray;
  LIdJson   : integer;
  LFilaJson : integer;
  LNomeJson : String;
  LNomeImpressoraEtiquetaJSON: string;
  LQtdeImpressaoJSON: integer;
  LModeloImpressoraJSON: string;
  LCount:integer;
begin
  try
    LFilaTriagem := 0;
    LNomeTriagem := '';
    LJson := TJSONObject.ParseJSONValue(vgParametrosModulo.ListaTriagemJson) as TJSONObject;
    if LJson.TryGetValue('Triagens', LArrayObjeto) then
    begin
      for LCount := 0 to Pred(LArrayObjeto.Count) do
      begin
        LJson := (LArrayObjeto.Items[LCount] as TJSONObject);
        LJson.TryGetValue('ID', LIdJson);

        if LIdTriagem =  LIdJson then
        begin
          LJson.TryGetValue('Fila', LFilaJson);
          LJson.TryGetValue('Nome', LNomeJson);
          LJson.TryGetValue('NomeImpressoraEtiqueta', vgParametrosModulo.NomeImpressoraEtiqueta);
          LJson.TryGetValue('QtdeImpressao', vgParametrosModulo.QtdeImpressao);
          LJson.TryGetValue('ModeloImpressora', vgParametrosModulo.ModeloImpressora);

          LFilaTriagem := LFilaJson;
          LNomeTriagem := LNomeJson;
        end;
      end;
    end;
  finally
    LJson.Free;
  end;
end;

function GetSendClicarBotaoGerarSenhaText(const aFila, aIDUnidade: Integer): string;
begin
  if vgParametrosModulo.ImpressoraComandada >= 0 then
    Result := IntToHex(aFila, 4) + IntToHex(vgParametrosModulo.ImpressoraComandada, 4)
  else
    Result := '';
end;

function GetSendExcluirSenhaText(Senha: Integer): string;
begin
  Result := IntToStr(Senha);
end;

function GetSendInserirSenhaText(Fila, Senha: Integer): string;
begin
  Result := IntToHex(Fila, 4) + IntToStr(Senha);
end;

function GetSendReimprimirSenhaText(const aSenha, aIDUnidade: Integer): string;
begin
  Result := IntToStr(aSenha) + ';' + IntToHex(vgParametrosModulo.ImpressoraComandada, 4);
end;

function GetSendClicarCheckBoxPrioritariaOuBloquearText(Fila: Integer; TipoCheckBox: string; Estado: Boolean): string;
begin
  Result := IntToHex(Fila, 4);
  if Pos('Block', TipoCheckBox) > 0 then
    Result := Result + 'B'
  else
    Result := Result + 'P';

  if Estado then
    Result := Result + '1'
  else
    Result := Result + '0';
end;

procedure TFrmSicsOnLine.AbrirTelaPadrao;
begin
  if existeTelaAberta then
    Exit;

  case vgParametrosModulo.TelaPadrao of
      1:
         begin
          btnSituacaoEspera.Pressed := True;
          ExibirFrame(btnSituacaoEspera.Tag);
         end;
      2 :
         begin
          btnSituacaoAtendimento.Pressed := True;
          ExibirFrame(btnSituacaoAtendimento.Tag);
         end;
      3 :
        begin
          btnIndicadorPerformance.Pressed := True;
          ExibirFrame(btnIndicadorPerformance.Tag);
        end;
  end;
end;

procedure TFrmSicsOnLine.AlinhaComponentesNaTela;
begin
  FormResize(Self);
end;

procedure TFrmSicsOnLine.BitBtn1Click(Sender: TObject);
var
  aux: string;
begin
  if Assigned(Sender) and (Sender is TControl) then
  begin
    aux := GetSendClicarBotaoGerarSenhaText(TControl(Sender).Tag, IDUnidade);
    DMConnection(IdUnidade, not CRIAR_SE_NAO_EXISTIR).EnviarComando(cProtocoloPAVazia + Chr($70) + aux, IdUnidade);
  end;
end;

procedure TFrmSicsOnLine.btnIndicadorPerformanceClick(Sender: TObject);
begin
  inherited;
  ExibirFrame(btnIndicadorPerformance.Tag);
end;

procedure TFrmSicsOnLine.btnSituacaoAtendimentoClick(Sender: TObject);
begin
  inherited;
  ExibirFrame(btnSituacaoAtendimento.Tag);
end;

procedure TFrmSicsOnLine.btnSituacaoEsperaClick(Sender: TObject);
begin
  inherited;
  ExibirFrame(btnSituacaoEspera.Tag);
end;

procedure TFrmSicsOnLine.CarregarParametrosDB;
begin
  menuSair.Enabled := vgParametrosModulo.PodeFecharPrograma;
  inherited;
end;

procedure TFrmSicsOnLine.CarregarParametrosDB(const aIDUnidade: Integer);
begin
  inherited;
  if (aIDUnidade <> IDUnidade) then
    Exit;

    //Código que esta em CarregarParametrosDB, estava aqui

end;

procedure TFrmSicsOnLine.CarregarParametrosINI;
begin
  inherited;

 { if (lstMenu.ItemIndex = -1) then
    lstMenu.ItemIndex := lstSituacaoEspera.Index;  }
end;

constructor TFrmSicsOnLine.Create(AOwner: TComponent);
begin
  inherited;
  Self.Caption := 'SICS - Módulo OnLine';
  with(TdmControleInstanciaAplicacao.Create(Self)) do
  begin
    Tela := Self;
  end;
end;

procedure TFrmSicsOnLine.desabilitaBotoes(desabilita: Boolean);
begin
  btnSituacaoAtendimento.Enabled := desabilita;
  btnSituacaoEspera.Enabled := desabilita;
  btnIndicadorPerformance.Enabled := desabilita;
end;

destructor TFrmSicsOnLine.Destroy;
begin
  inherited;
end;

procedure TFrmSicsOnLine.ExibirFrame(const aIndexItem: Integer);
var
  LFraSituacaoEspera: TFraSituacaoEspera;
  LFraIndicadorPerformance: TFraIndicadorPerformance;
  LFraSituacaoAtendimento: TFraSituacaoAtendimento;
  LListBoxItem: TListBoxItem;
begin
  inherited;
  btnSituacaoAtendimento.StaysPressed := false;
  btnSituacaoEspera.StaysPressed := false;
  btnIndicadorPerformance.StaysPressed := false;

  imgSetaSituacaoAtendimento.Visible := False;
  imgSetaSituacaoEspera.Visible := False;
  imgSetaIndicadorPerformance.Visible := False;

  case aIndexItem of
    INDEX_SITUACAO_ATEND  : begin
                              LFraSituacaoAtendimento := FraSituacaoAtendimento(IdUnidade,True);
                              ExibeSomenteOFrame(LFraSituacaoAtendimento);
                              btnSituacaoAtendimento.StaysPressed := true;
                              imgSetaSituacaoAtendimento.Visible := True;
                              LFraSituacaoAtendimento.botaoMenu := btnSituacaoAtendimento;
                              LFraSituacaoAtendimento.imgSeta := imgSetaSituacaoAtendimento;
                            end;

    INDEX_SITUACAO_ESPERA : begin
                              LFraSituacaoEspera := FraSituacaoEspera(IdUnidade,true);
                              ExibeSomenteOFrame(LFraSituacaoEspera);
                              LFraSituacaoEspera.AtualizarColunasGrid;
                              btnSituacaoEspera.IsPressed := True;
                              btnSituacaoEspera.StaysPressed := true;
                              imgSetaSituacaoEspera.Visible := True;
                              LFraSituacaoEspera.botaoMenu := btnSituacaoEspera;
                              LFraSituacaoEspera.imgSeta := imgSetaSituacaoEspera;
                              LFraSituacaoEspera.tmrAtualizaHorario.Enabled := vgParametrosModulo.MostrarTempoDecorridoEspera;
                              if(vgParametrosModulo.MostrarTempoDecorridoEspera)then
                                LFraSituacaoEspera.tmrAtualizaHorarioTimer(LFraSituacaoEspera.tmrAtualizaHorario);
                            end;

    INDEX_IND_PERF        : begin
                              LFraIndicadorPerformance := FraIndicadorPerformance(IdUnidade,true);
                              ExibeSomenteOFrame(LFraIndicadorPerformance);
                              btnIndicadorPerformance.StaysPressed := true;
                              imgSetaIndicadorPerformance.Visible := True;
                              LFraIndicadorPerformance.botaoMenu := btnIndicadorPerformance;
                              LFraIndicadorPerformance.imgSeta := imgSetaIndicadorPerformance;
                            end;
    else                    Exit;

  end;

  {LListBoxItem := lstMenu.ItemByIndex(aIndexItem);
  if Assigned(LListBoxItem) then
  begin
    LListBoxItem.Selectable := true;
    LListBoxItem.IsSelected := True;
  end;   }
end;

procedure TFrmSicsOnLine.Fechar;
begin
  Application.Terminate;
end;

procedure TFrmSicsOnLine.FormActivate(Sender: TObject);
begin
  inherited;
  dmUnidades.FormClient := Self;
end;

procedure TFrmSicsOnLine.FormShow(Sender: TObject);
var
  LJson : TJsonObject;
  LArrayObjeto: TJSONArray;
  LIDTriagem, LCount: integer;
  LFilaJson:integer;
  LNomeJson:String;
  mnuitem : TMenuItem;
  LParametroSaida: APIs.Aspect.Sics.BuscarParametro.TParametrosSaidaAPI;
  LErroAPI: APIs.Common.TErroAPI;
begin
  inherited;
  TfrmSICSSplashFMX.Hide;
  try
    if APIs.Aspect.Sics.BuscarParametro.TAPIAspectSicsBuscarParametro.URL<>'' then
      if APIs.Aspect.Sics.BuscarParametro.TAPIAspectSicsBuscarParametro.Execute(LParametroSaida, LErroAPI) = TTipoRetornoApi.raOK then
        vgParametrosModulo.ListaTriagemJson := LParametroSaida.Valor;

    LJson := TJSONObject.ParseJSONValue(vgParametrosModulo.ListaTriagemJson) as TJSONObject;
    if LJson.TryGetValue('Triagens', LArrayObjeto) then
    begin
      for LCount := 0 to Pred(LArrayObjeto.Count) do
      begin
        LJson := (LArrayObjeto.Items[LCount] as TJSONObject);
        LJson.TryGetValue('Fila', LFilaJson);
        LJson.TryGetValue('Nome', LNomeJson);
        LJson.TryGetValue('ID', LIDTriagem);
        LJson.TryGetValue('NomeImpressoraEtiqueta', vgParametrosModulo.NomeImpressoraEtiqueta);
        LJson.TryGetValue('QtdeImpressao', vgParametrosModulo.QtdeImpressao);
        LJson.TryGetValue('ModeloImpressora', vgParametrosModulo.ModeloImpressora);

        mnuitem := TMenuItem.Create(ManagePswdPopMenu);
        mnuitem.Text      := LNomeJson;
        mnuitem.Tag       := LFilaJson;
        mnuitem.TagString := vgParametrosModulo.NomeImpressoraEtiqueta;
        mnuitem.TagFloat  := LIDTriagem;
        mnuitem.TagObject := TObject(vgParametrosModulo.ModeloImpressora);
        mnuitem.OnClick   := PopUpmenuEnviaTriagemClick;
        ManagePswdPopMenu.AddObject(mnuitem);
      end;
    end;
  finally
    LJson.Free;
  end;
end;

function TFrmSicsOnLine.GetIsIndexOfFrame(const aCurrentIndex: Integer; const aClass: TClass): Boolean;
begin
  result := INDEX_VAZIO = aCurrentIndex;
  if (aClass = TFraIndicadorPerformance) then
    Result := INDEX_IND_PERF = aCurrentIndex
  else
  if (aClass = TFraSituacaoEspera) then
    Result := INDEX_SITUACAO_ESPERA = aCurrentIndex
  else
  if (aClass = TFraSituacaoAtendimento) then
    Result := INDEX_SITUACAO_ATEND = aCurrentIndex;
end;

function TFrmSicsOnLine.GetSituacaoAtualPA(const aPA: Integer): String;
begin
  Result := 'IdUnidade: ' + IntToStr(IdUnidade) + '  | Senha: ' + IntToStr(ManagePswdPopMenu.Tag) + ' ' +
  inherited GetSituacaoAtualPA(aPA);
end;

procedure TFrmSicsOnLine.InsertSenhaButton1Click(Sender: TObject);
var
  aux                  : string;
  btnInsertSenhaButton1: FMX.StdCtrls.TButton;
  edtSenhaEdit         : TEdit;
begin
  if Sender is FMX.StdCtrls.TButton then
  begin
    btnInsertSenhaButton1 := FMX.StdCtrls.TButton(Sender);
    edtSenhaEdit          := (FindComponent(StrSenhaEdit + IntToStr(btnInsertSenhaButton1.Tag)) as TEdit);
    aux := GetSendInserirSenhaText(btnInsertSenhaButton1.Tag, StrToInt(edtSenhaEdit.Text));
    DMConnection(IdUnidade, not CRIAR_SE_NAO_EXISTIR).EnviarComando(cProtocoloPAVazia + Chr($6B) + aux, IdUnidade);

    edtSenhaEdit.Text := '';
  end;
end;

procedure TFrmSicsOnLine.lstMenuClick(Sender: TObject);
begin
  inherited;

 // ExibirFrame(lstMenu.ItemIndex);
end;

procedure TFrmSicsOnLine.ManagePswdPopMenuPopup(Sender: TObject);
begin
  inherited;
  if not (PopUpMenuExcluir.Visible or PopUpMenuReimprimir.Visible or PopUpMenuExcluirTodos.Visible)then
    Abort;
end;

procedure TFrmSicsOnLine.PopUpmenuEnviaTriagemClick(Sender: TObject);
var
  aux : string;
  LFilaTriagem: integer;
  LNomeTriagem: string;
begin
  if ((sender as TMenuItem).Tag > 0) and (ManagePswdPopMenu.Tag > 0)  then
  begin
    GetFilaTriagemPorId(Trunc((sender as TMenuItem).TagFloat), LFilaTriagem, LNomeTriagem);
    EncaminharSenhaFilaTriagem(ManagePswdPopMenu.Tag,
                              (sender as TMenuItem).Tag,
                              (sender as TMenuItem).Text,
                              (sender as TMenuItem).TagString,
                              Trunc((sender as TMenuItem).TagFloat),
                              string((sender as TMenuItem).TagObject));
  end;
end;

procedure TFrmSicsOnLine.menuIndicadoresDePerformanceClick(Sender: TObject);
begin
  inherited;

  ExibirFrame(btnIndicadorPerformance.Tag);
end;

procedure TFrmSicsOnLine.MenuItem1Click(Sender: TObject);
begin
  inherited;
  ExibirFrame(btnSituacaoEspera.Tag);
end;

procedure TFrmSicsOnLine.menuProcessosParalelosClick(Sender: TObject);
var
  LfrmSicsCommon_VisualizaManipulaPPs: TFrmProcessoParalelo;
begin
  inherited;
  ExibeSomenteOFrame(nil);
  LfrmSicsCommon_VisualizaManipulaPPs := FrmProcessoParalelo(0);

  if Assigned(LfrmSicsCommon_VisualizaManipulaPPs) then
    LfrmSicsCommon_VisualizaManipulaPPs.Show;
end;

procedure TFrmSicsOnLine.menuSairClick(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TFrmSicsOnLine.menuSituacaoDoAtendimentoClick(Sender: TObject);
begin
  inherited;
  ExibirFrame(btnSituacaoAtendimento.tag);
end;

procedure TFrmSicsOnLine.menuSobreClick(Sender: TObject);
begin
  inherited;
  InformationMessage(VERSAO {$IFNDEF IS_MOBILE} + #13#13 + GetExeVersion{$ENDIF IS_MOBILE});
end;

procedure TFrmSicsOnLine.menuTraySairClick(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TFrmSicsOnLine.PopUpMenuExcluirClick(Sender: TObject);
var
  LSituacaoFrm, aux : string;
begin
  LSituacaoFrm := GetSituacaoAtual;
  ConfirmationMessage('Excluir senha ' + inttostr(ManagePswdPopMenu.Tag) + '?',
    procedure(const aConfirmation: Boolean)
    begin
      if aConfirmation then
      begin
        if (LSituacaoFrm = GetSituacaoAtual) then
        begin
          aux := GetSendExcluirSenhaText(ManagePswdPopMenu.Tag);
          DMConnection(IdUnidade, not CRIAR_SE_NAO_EXISTIR).EnviarComando('FFFF' + Chr($6A) + aux, 0);
        end
        else
          ErrorMessage(Format('A situação foi alterada de "%s" para "%s"',
            [LSituacaoFrm, GetSituacaoAtual]));
      end;
    end);
end;

procedure TFrmSicsOnLine.PopUpMenuExcluirTodosClick(Sender: TObject);
var
  LSituacaoFrm, aux : string;
begin
  LSituacaoFrm := GetSituacaoAtual;
  ConfirmationMessage('Excluir todas as senhas?',
    procedure(const aConfirmation: Boolean)
    begin
      if aConfirmation then
      begin
        if (LSituacaoFrm = GetSituacaoAtual) then
        begin
          aux :=  inttohex(filaSelecionada,4);
          DMConnection(IdUnidade, not CRIAR_SE_NAO_EXISTIR).EnviarComando('FFFF' + Chr($3A) + aux, 0);
        end
        else
          ErrorMessage(Format('A situação foi alterada de "%s" para "%s"',
            [LSituacaoFrm, GetSituacaoAtual]));
      end;
    end);
end;

procedure TFrmSicsOnLine.PopUpMenuReimprimirClick(Sender: TObject);
var
  LSituacaoFrm, aux : string;
begin
  LSituacaoFrm := GetSituacaoAtual;
  ConfirmationMessage('Reimprimir senha ' + inttostr(ManagePswdPopMenu.Tag) + '?',
    procedure(const aConfirmation: Boolean)
    begin
      if aConfirmation then
      begin
        if (LSituacaoFrm = GetSituacaoAtual) then
        begin
          aux := GetSendReimprimirSenhaText(ManagePswdPopMenu.Tag, IDUnidade);
          DMConnection(IdUnidade, not CRIAR_SE_NAO_EXISTIR).EnviarComando('FFFF' + Chr($B1) + aux, 0); //antes o comando era 87
        end
        else
          ErrorMessage(Format('A situação foi alterada de "%s" para "%s"',
            [LSituacaoFrm, GetSituacaoAtual]));
      end;
    end);
end;

procedure TFrmSicsOnLine.PopUpMenuRenomearClick(Sender: TObject);
begin
  InputQuery(PChar(('Senha: ' + InttoStr(ManagePswdPopMenu.Tag))), ['Digite o nome do paciente:'], [ManagePswdPopMenu.TagString],
    procedure(const AResult: TModalResult; const AValues: array of string)
    begin
      if AResult = mrOk then
      begin
        ManagePswdPopMenu.TagString := AValues[0];
        with DMConnection(IdUnidade, not CRIAR_SE_NAO_EXISTIR) do //, DMClient(IdUnidade, not CRIAR_SE_NAO_EXISTIR)
        begin
          DefinirDadoAdicionalNomeCliente(0, ManagePswdPopMenu.Tag, ManagePswdPopMenu.TagString, IdUnidade);
          DefinirNomeCliente(0, ManagePswdPopMenu.Tag, ManagePswdPopMenu.TagString, IdUnidade);
        end;
      end;
    end);
end;

procedure TFrmSicsOnLine.PrioritaryList1Click(Sender: TObject);
var
  aux               : string;
  chkPrioritaryList1: TCheckBox;
begin
  if (Sender is TCheckBox) then
  begin
    chkPrioritaryList1 := TCheckBox(Sender);
    aux := GetSendClicarCheckBoxPrioritariaOuBloquearText(chkPrioritaryList1.Tag, chkPrioritaryList1.Name, chkPrioritaryList1.IsChecked);
    DMConnection(IdUnidade, not CRIAR_SE_NAO_EXISTIR).EnviarComando(cProtocoloPAVazia + Chr($69) + aux, IdUnidade);
  end;
end;

procedure TFrmSicsOnLine.SenhaEdit1Change(Sender: TObject);
var
  I                   : Integer;
  edtSenhaEdit        : TEdit;
  btnInsertSenhaButton: FMX.StdCtrls.TButton;
begin
  if Sender is TEdit then
  begin
    edtSenhaEdit         := TEdit(Sender);
    I                    := edtSenhaEdit.Tag;
    btnInsertSenhaButton := (FindComponent(StrInsertSenhaButton + IntToStr(I)) as FMX.StdCtrls.TButton);
    try
      btnInsertSenhaButton.Enabled := True;
      if edtSenhaEdit.Text <> '' then
        StrToInt(edtSenhaEdit.Text)
      else
        btnInsertSenhaButton.Enabled := False;
    except
      btnInsertSenhaButton.Enabled := False;
      Exit;
    end
  end;
end;

procedure TFrmSicsOnLine.TocaSomNovaSenha;
var
  LArquivo : String;
begin
  LArquivo := TPath.Combine(ExtractFilePath(ParamStr(0)),'NovaSenha.wav');
  if FileExists(LArquivo) then
  begin
    MediaPlayer.FileName := LArquivo;
    MediaPlayer.CurrentTime := 0;
    MediaPlayer.Play;
  end;
end;

initialization

FrmSicsOnLine := nil;

end.
