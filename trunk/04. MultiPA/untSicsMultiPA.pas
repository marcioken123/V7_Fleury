unit untSicsMultiPA;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
{$IFNDEF IS_MOBILE}
  Windows, Messages, ScktComp, FMX.Platform.Win,
{$ENDIF}
{$IFDEF ANDROID}
  FMX.Platform.Android,
{$ENDIF}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  untCommonFormBasePA, FMX.Objects, FMX.Layouts, FMX.Menus, MyAspFuncoesUteis,
  FMX.Edit, System.Math, FMX.Controls.Presentation, Data.Bind.EngExt,
  FMX.Bind.DBEngExt, Data.Bind.Components, System.ImageList, FMX.ImgList,
  Datasnap.DBClient, FMX.Effects, Data.Bind.DBScope;

{$INCLUDE ..\SicsVersoes.pas}

const
  MaxIdPAs = 999;
  cPanelWidth = 200; //168;

type
  TDragKind = (dkNenhum, dkSenha, dkAtendente);

  TComponentesPA = class(TComponent)
  public
    PA: Integer;
    Grupo: Integer;
    btnProximo: TButton;
    BtnRechamar: TButton;
    BtnEspecifica: TButton;
    BtnEncaminhar: TButton;
    BtnFinalizar: TButton;
    BtnProcessos: TButton;
    BtnPausar: TButton;
    BtnSeguirAtendimento: TButton;
    BtnLogin: TButton;
    BtnLogout: TButton;
    edtNomeCliente: TEdit;
    RecFundo: TRectangle;
    pnlTAGs: TPanel;
    RecTAGs: TRectangle;
    LblNomeCliente: TLabel;
    LblDescNomeCliente: TLabel;
    LblSenha: TLabel;
    LblDescSenha: TLabel;
    LblNomePA: TLabel;
    LblAtendente: TLabel;
    LblCodAtendente: TLabel;
    LblSenhaAtendente: TLabel;
    LblEspera: TLabel;
    LblMotivoPausa: TLabel;
    lblDescEspera, lblVoltarParaProximo: TLabel;
    pnl: TPanel;
    MenuAtendente: TPopupMenu;
    recPA: TRectangle;
    recSenha: TRectangle;
    recLogin: TRectangle;
    recBotoes: TRectangle;
    pnlPA: TPanel;
    pnlSenha: TPanel;
    pnlBotoes: TPanel;
    pnlLogin: TPanel;
    recCodBarras: TRectangle;
    imgDadosAdicionais: TImage;
    pnlObservacao: TPanel;
    recObservacao: TRectangle;
    lblObservacao: TLabel;

    constructor Create(AOwner: TComponent); override;
  end;

  TMultiPAComponentes = array of TComponentesPA;

  TFrmSicsMultiPA = class(TFrmBase_PA_MPA)
    Menu: TMenuBar;
    tmrCursor: TTimer;
    mnuArquivo: TMenuItem;
    mnuSair: TMenuItem;
    mnuInterrogacao: TMenuItem;
    mnuSobre: TMenuItem;
    FramedScroll: TFramedScrollBox;
    AniIndicator: TAniIndicator;
    menuHidden: TMenuItem;
    menuVisualizaInputLCDB: TMenuItem;
    menuForcaFecharPrograma: TMenuItem;
    RecFundo: TRectangle;
    tmrAtualizaForm: TTimer;
    PopupMenu1: TPopupMenu;
    FramedScrollGrupos: TFramedScrollBox;
    AniIndicator1: TAniIndicator;
    rectButtons: TRectangle;
    lytFramedScrolls: TLayout;
    imgBotaoDadosAdicionais: TImage;
    rectLogo: TRectangle;
    imgLogo: TImage;
    Timer1: TTimer;
    procedure FormResize(Sender: TObject);
    procedure tmrCursorTimer(Sender: TObject);

    procedure AtendenteMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure MenuBotoesMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure MenuBotoesMouseClick(Sender: TObject);
    procedure PADragEnter(Sender: TObject; const Data: TDragObject;
      const Point: TPointF);
    procedure PADragEnd(Sender: TObject);
    procedure PADragDrop(Sender: TObject; const Data: TDragObject;
      const Point: TPointF);
    procedure PADragOver(Sender: TObject; const Data: TDragObject;
      const Point: TPointF; var Operation: TDragOperation);
    procedure mnuSobreClick(Sender: TObject);
    procedure menuVisualizaInputLCDBClick(Sender: TObject);
    procedure menuForcaFecharProgramaClick(Sender: TObject);
    procedure tmrAtualizaFormTimer(Sender: TObject);
    procedure RecFundoClick(Sender: TObject);
    procedure MenuClick(Sender: TObject);
    procedure btnGrupoPAClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    fgDragKind: TDragKind;
    vOrigemID: Integer;
    vDestinoID: Integer;
    vAccept: Boolean;

    function CriaComponentePA(const PANo, GrupoPANo: Integer): Boolean;
    function CriaComponenteGrupoPA(const GrupoPANo: Integer; GrupoPANome: string): Boolean;
    procedure AlteraPADoUsuarioLogado(const vDestinoEstaLogado: Boolean;
      const vDestinoAtendenteID, vOrigemAtendenteID: Integer;
      const vOrigemAtendenteSenha: string);
    procedure AbortarSeNenhumItemVisivel(Sender: TObject);
    procedure MostraGrupoPA(const ACodGrupoPA: Integer);
  protected
    procedure AtendenteMouseClick(Sender: TObject); Override;
    function FormataNomeComponente(const aNomeComponente: String;
      const aPA: Integer): String; Override;
    function GetCodGrupoPA(const Sender: TObject): Integer; Override;
    function GetCodPA(const Sender: TObject): Integer; Override;
    function GetCodAtend(const aPA: Integer): Integer; Override;
    function GetSenhaAtend(const aCodAtend: Integer): String; Override;
    function FindTarget(P: TPointF; const Data: TDragObject): IControl; Override;

    procedure ExibePAs;
    procedure SetModoConexaoAtual(const aIdUnidade: Integer; const Value: Boolean); Override;
  public
    FMultiPAComponentes: TMultiPAComponentes;
    //FAlturaMinima: Integer;
  const
    cMenuAtendente = 'menuAtendente';
    cSufMenuAtend = 'mnuAtend';

    procedure ClienteConfigurado; Override;
    procedure ApplyChanges(const aPA: Integer); Override;

    function BeginUpdatePA(var aListaPa: TIntegerDynArray;
      const aCanClearArray: Boolean = True): Boolean; Override;

    function InUpdatePA: Boolean; Override;
    function InChanges: Boolean; Override;
    procedure BeginChangesForPAInUpdate;

    procedure DefinirCor(const aIdUnidade: Integer; const ACor, aCorOld: TAlphaColor;
      const aPintarRetangulo: Boolean); override;
    procedure AtualizarSenha(PA: Integer; Senha: string); Override;
    function GetSituacaoAtual: String; override;
    procedure AtualizarPropriedade(const NomePropriedade, NomeComponente
      : string; const ValorPropriedade: Variant; const PA: Integer;
      const aReplicarMenuTray: Boolean = True); Override;

{$REGION 'Get botões por PA'}
    function GetpnlTAGs(const aCodPA: Integer): TPanel; Override;
    function GetbtnProximo(const aCodPA: Integer): TButton; override;
    function GetBtnRechamar(const aCodPA: Integer): TButton; Override;
    function GetBtnEspecifica(const aCodPA: Integer): TButton; Override;
    function GetBtnEncaminhar(const aCodPA: Integer): TButton; Override;
    function GetBtnFinalizar(const aCodPA: Integer): TButton; Override;
    function GetBtnProcessos(const aCodPA: Integer): TButton; Override;
    function GetBtnPausar(const aCodPA: Integer): TButton; Override;
    function GetBtnSeguirAtendimento(const aCodPA: Integer): TButton; Override;
    function GetBtnLogin(const aCodPA: Integer): TButton; Override;

    function GetLblNomeCliente(const aCodPA: Integer): TLabel; Override;
    function GetLblDescNomeCliente(const aCodPA: Integer): TLabel; Override;
    function GetLblSenha(const aCodPA: Integer): TLabel; Override;
    function GetLblDescSenha(const aCodPA: Integer): TLabel; Override;
    function GetLblNomePA(const aCodPA: Integer): TLabel; Override;
    function GetLblAtendente(const aCodPA: Integer): TLabel; Override;
    function GetLblCodAtendente(const aCodPA: Integer): TLabel; Override;
    function GetLblSenhaAtendente(const aCodPA: Integer): TLabel; Override;
    function GetLblEspera(const aCodPA: Integer): TLabel; Override;
    function GetLblMotivoPausa(const aCodPA: Integer): TLabel; Override;
    function GetedtNomeCliente(const aCodPA: Integer): TEdit; Override;
    function GetRecFundo(const aCodPA: Integer): TRectangle; Override;
    function GetRecTAGs(const aCodPA: Integer): TRectangle; Override;
    function GetPNL(const aCodPA: Integer): TPanel; Override;
    function GetRecPA(const aCodPA: Integer): TRectangle; override;
    function GetRecSenha(const aCodPA: Integer): TRectangle; override;
    function GetRecLogin(const aCodPA: Integer): TRectangle; override;
    function GetRecBotoes(const aCodPA: Integer): TRectangle; override;
    function GetRecCodigoBarras(const aCodPA: Integer): TRectangle; override;
    function GetLblObservacao(const aCodPA: Integer): TLabel; override;
{$ENDREGION}
    procedure CriarTAGs; Override;
    procedure AtualizarAtendente(const NomeAtendente: string; const PA, aCodAtend: Integer); Override;
    procedure AtualizarEspera(const PA, Qtde: Integer; const aPodeChamarProximo: Boolean = False); Override;

    procedure AtualizarMotivoPausa(const ACor: TAlphaColor;
      const Motivo: string; const PA: Integer); Override;
    procedure AtualizarObservacaoPA(PA: Integer); override;
    procedure CriarPAs; override;
    procedure CriarGruposPAs; override;

    // LBC VERIFICAR    function GetListCurrentPA: TIntegerDynArray; override;
    function FiltrarPA: Boolean; overload;
    function FiltrarPA(const aExecutarResize: Boolean; const aCodPA: Integer): Boolean; Overload;

    procedure CarregarParametrosDB(const aPA, IdUnidade: Integer); Overload; Override;
    procedure CarregarParametrosDB; Overload; Override;
    function GetPaJaFoiCriada(const aPA: Integer): Boolean; Override;
    function GetpnlGrupos: TFramedScrollBox; Override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; Override;
    procedure OrganizaPosicaoBotoes(const aPA: Integer);
    procedure OrganizaPAs; override;
    procedure Fechar;
  end;

var
  FrmSicsMultiPA: TFrmSicsMultiPA;
  LCodGrupoPA: SmallInt;

implementation

uses
  untLog,
  System.UIConsts,
  untCommonDMClient,
  untCommonDMConnection,
  untCommonFormSelecaoFila,
  Sics_Common_LCDBInput,
  Sics_Common_Parametros,
  untCommonDMUnidades,
  untCommonControleInstanciaAplicacao,
  untCommonFormDadosAdicionais;

{$R *.fmx}

procedure TFrmSicsMultiPA.ApplyChanges(const aPA: Integer);
begin
  if not InChanges then
    ExibePAs;

  inherited;
end;

procedure TFrmSicsMultiPA.AtendenteMouseClick(Sender: TObject);
var
  PA: Integer;
  MenuAtendente: TPopupMenu;
  i: Integer;
begin
  inherited;
  PA := GetCodPA(Sender);

  MenuAtendente := Self.GetComponentePA(cMenuAtendente, PA) as TPopupMenu;
  for i := 0 to MenuAtendente.ItemsCount - 1 do
  begin
    MenuAtendente.Items[i].Tag := PA;
  end;

  UpdateButtons(PA);

  // if AoMenosUmItemDeMenuVisivel then
  MenuAtendente.Popup(Screen.MousePos.X, Screen.MousePos.Y);
end;

procedure TFrmSicsMultiPA.AtendenteMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  if Button = TMouseButton.mbRight then
  begin
    AtendenteMouseClick(Sender);
  end;
end;

procedure TFrmSicsMultiPA.AtualizarAtendente(const NomeAtendente: string;
  const PA, aCodAtend: Integer);
var
  LLblCodAtendente, lLblSenhaAtendente: TLabel;
begin
  inherited;

  LLblCodAtendente := GetLblCodAtendente(PA);

  if Assigned(LLblCodAtendente) then
    LLblCodAtendente.Text := IntToStr(aCodAtend);

  FiltrarPA(True, PA);
end;

procedure TFrmSicsMultiPA.AtualizarEspera(const PA, Qtde: Integer;
  const aPodeChamarProximo: Boolean);
begin
  inherited;

  FiltrarPA(True, PA);
end;

procedure TFrmSicsMultiPA.AtualizarMotivoPausa(const ACor: TAlphaColor;
  const Motivo: string; const PA: Integer);
var
  LNovoHeightPanel: Single;
  LOldMotivoPausa: String;
  LLblMotivoPausa: TLabel;
  LPnl: TPanel;
begin
  LLblMotivoPausa := GetLblMotivoPausa(PA);

  if Assigned(LLblMotivoPausa) then
    LOldMotivoPausa := LLblMotivoPausa.Text;

  inherited;

  if vgParametrosModulo.MostrarNomeCliente then
    Exit;

  LNovoHeightPanel := 0;

  if (LOldMotivoPausa <> EmptyStr) xor (Motivo <> EmptyStr) then
  begin
    if Motivo <> EmptyStr then
      LNovoHeightPanel := 18;

    if (LOldMotivoPausa <> EmptyStr) then
      LNovoHeightPanel := -18;
  end;

  LPnl := GetPNL(PA);

  if Assigned(LPnl) then
  begin
    LNovoHeightPanel := LNovoHeightPanel + LPnl.Height;
    LPnl.Height := LNovoHeightPanel;
  end;
end;

procedure TFrmSicsMultiPA.AtualizarObservacaoPA(PA: Integer);
var
  LObservacao: string;
begin
  if not Assigned(GetlblObservacao(PA)) then Exit;
  GetlblObservacao(PA).Text := EmptyStr;

  if Assigned(FJSONDadosAdicionais) and (FJSONDadosAdicionais.TryGetValue('OBSERVACAO', LObservacao)) then
    GetlblObservacao(PA).Text := ' Obs.: '+LObservacao
  else
    GetlblObservacao(PA).Text := ' Obs.: ';

end;

procedure TFrmSicsMultiPA.AtualizarPropriedade(const NomePropriedade,
  NomeComponente: string; const ValorPropriedade: Variant; const PA: Integer;
  const aReplicarMenuTray: Boolean);
begin
  inherited;

  if aReplicarMenuTray then
    AtualizarPropriedade(NomePropriedade, NomeComponente + cSufMenuAtend, ValorPropriedade, PA, False);
end;

procedure TFrmSicsMultiPA.AtualizarSenha(PA: Integer; Senha: string);
begin
  inherited;

  FiltrarPA(True, PA);
end;

procedure TFrmSicsMultiPA.BeginChangesForPAInUpdate;
var
  i: Integer;
begin
  // LBC VERIFICAR  if vgParametrosModulo.JaEstaConfigurado then
  // LBC VERIFICAR  begin
  // LBC VERIFICAR    for I := Low(vgParametrosModulo.GruposDePAsPermitidas) to High(vgParametrosModulo.GruposDePAsPermitidas) do
  // LBC VERIFICAR    begin
  // LBC VERIFICAR      if (
  // LBC VERIFICAR//        GetPaJaFoiCriada(vgParametrosModulo.GruposDePAsPermitidas[I]) and
  // LBC VERIFICAR        InUpdatePA(vgParametrosModulo.GruposDePAsPermitidas[I])) then
  // LBC VERIFICAR      begin
  // LBC VERIFICAR        BeginChanges(vgParametrosModulo.GruposDePAsPermitidas[I]);
  // LBC VERIFICAR        Break;
  // LBC VERIFICAR      end;
  // LBC VERIFICAR    end;
  // LBC VERIFICAR  end;
end;

function TFrmSicsMultiPA.BeginUpdatePA(var aListaPa: TIntegerDynArray;
  const aCanClearArray: Boolean): Boolean;
var
  i: Integer;
begin
  Result := False;

  if aCanClearArray then
  begin
    Setlength(aListaPa, 0);
  end;

  if BeginUpdatePA(PA_VAZIA, False) then
  begin
    Setlength(aListaPa, Length(aListaPa) + 1);
    aListaPa[Length(aListaPa) - 1] := PA_VAZIA;
    Result := True;
  end;
end;

procedure TFrmSicsMultiPA.CarregarParametrosDB(const aPA, IdUnidade: Integer);
begin
  if GetPaJaFoiCriada(aPA) then
  begin
    inherited;
  end;
end;

procedure TFrmSicsMultiPA.CarregarParametrosDB;
begin
  inherited;
end;

procedure TFrmSicsMultiPA.ClienteConfigurado;
begin
  inherited;
  Application.ProcessMessages;
  OrganizaPAs;
  //btnGrupoPAClick(nil);
  Beep;
end;

constructor TFrmSicsMultiPA.Create(AOwner: TComponent);
begin
  Setlength(FMultiPAComponentes, 0);
  inherited;
  Self.Caption := 'SICS - Módulo MultiPA';
{$IFNDEF IS_MOBILE}
  Menu.Visible := True;
{$ELSE}
  Menu.Visible := False;
{$ENDIF IS_MOBILE}
  fgDragKind := dkNenhum;
  vOrigemID := 0;
  vDestinoID := 0;
  vAccept := False;

  with TdmControleInstanciaAplicacao.Create(Self) do
  begin
    Tela := Self;
  end;
end;

procedure TFrmSicsMultiPA.AbortarSeNenhumItemVisivel(Sender: TObject);
var
  i: Integer;
  LAbortar: Boolean;
  LPopUpMenu: TPopupMenu;
begin
  LPopUpMenu := (Sender as TPopupMenu);

  LAbortar := True;

  for i := 0 to LPopUpMenu.ItemsCount - 1 do
    if LPopUpMenu.Items[i].Visible then
    begin
      LAbortar := False;
      break;
    end;

  if LAbortar then
    abort;
end;

function TFrmSicsMultiPA.CriaComponenteGrupoPA(const GrupoPANo: Integer;
  GrupoPANome: string): Boolean;
var
  btnGrupoPA: TButton;

const
  cBtnGrupoPA = 'btnGrupoPA';
begin
  Result := True;

  try
    btnGrupoPA := TButton.Create(Self);

    with btnGrupoPA do
    begin
      Align := TAlignLayout.Top;
      Margins.Top := 5;
      Margins.Left := 5;
      Margins.Right := 5;
      Parent := rectButtons;
      Cursor := crHandPoint;
      Name := cBtnGrupoPA + IntToStr(GrupoPANo);
      StyledSettings := [TStyledSetting.Style, TStyledSetting.Size,
        TStyledSetting.Family, TStyledSetting.FontColor, TStyledSetting.Other];
      Text := GrupoPANome;
      Visible := True;
      Enabled := True;
      OnClick := btnGrupoPAClick;
      Size.PlatformDefault := False;

      if GrupoPANo = 0 then
      begin
        StyleLookup := 'btAzulEscuro';
      end
      else
      begin
        StyleLookup := 'btAzulClaro';
      end;

      Height := 36;
      Width := 140;
      Tag := GrupoPANo;
    end;
  except
    on e: exception do
      Result := False;
  end;
end;

function TFrmSicsMultiPA.CriaComponentePA(const PANo, GrupoPANo: Integer): Boolean;
const
  OFF = 4;
  EspacamentoBotao = 2;
  TamanhoMinimoLblMotivoPausa = 80;
  cMaximoBotoesPorLinha = 4;

  cPNL = 'pnl';
  cRecFundo = 'rec';
  cBtnProximo = 'btnProximo';
  cBtnRechamar = 'btnRechamar';
  cBtnEspecifica = 'btnEspecifica';
  cBtnEncaminhar = 'btnEncaminhar';
  cBtnFinalizar = 'btnFinalizar';
  cBtnProcessos = 'btnProcessos';
  cBtnPausar = 'btnPausar';
  cBtnSeguirAtendimento = 'btnSeguirAtendimento';
  cBtnLogin = 'btnLogin';
  cBtnLogout = 'btnLogout';
  cEdtNomeCliente = 'edtNomeCliente';

  cLblNomeCliente = 'lblNomeCliente';
  cLblDescNomeCliente = 'lblDescNomeCliente';
  cLblSenha = 'lblSenha';
  cLblDescSenha = 'lblDescSenha';
  cLblNomePA = 'lblNomePA';
  cLblAtendente = 'lblAtendente';
  cLblSenhaAtendente = 'lblSenhaAtendente';
  cLblEspera = 'lblEspera';
  cLblMotivoPausa = 'lblMotivoPausa';

var
  LmnuItem: TMenuItem;
  ComponentesPA, ComponentesPAAnterior: TComponentesPA;
  FUltimoBotao: TButton;
  tamanhoPanel: Integer;

  procedure AddBotaoVisivel(aBotao: TButton);
  var
    LWidthBotao: Single;
  begin
    aBotao.Parent := ComponentesPA.pnl;

    if vgParametrosModulo.JaEstaConfigurado then
      ConfiguraBotaoModuloMPA(aBotao);

    aBotao.Tag := PANo;

    if not aBotao.Visible then
      Exit;

    LWidthBotao := (aBotao.Width + aBotao.Position.X);

    if (ComponentesPA.pnl.Width < LWidthBotao) then
      ComponentesPA.pnl.Width := LWidthBotao + 4;
  end;

  function GetNewButton: TButton;
  begin
    Result := TButton.Create(Self);
    Result.Margins.Left := 2;
    Result.Margins.Top := 2;
    Result.Cursor := crHandPoint;
    FUltimoBotao := Result;
  end;

  function GetNewLabel(Parent: TComponent): TLabel;
  begin
    Result := TLabel.Create(Self);
    Result.TextSettings.WordWrap := False;
    Result.Margins.Left := 5;
    Result.Margins.Top := 2;
    Result.AutoSize := True;
  end;

  procedure ConfiguraLabels;
  begin
    ComponentesPA.LblNomePA := GetNewLabel(ComponentesPA.recPA);

    with ComponentesPA.LblNomePA do
    begin
      Parent := ComponentesPA.recPA;
      DragMode := TDragMode.dmAutomatic;
      Position.X := 4;
      Position.Y := 2;
      Font.Size := 14;
      StyledSettings := StyledSettings - [TStyledSetting.Style,
        TStyledSetting.Size];
      Name := cLblNomePA + IntToStr(PANo);
      Text := SemSenha;
      AutoSize := False;
      Height := 14;
      Width := 128;
      Margins.Top := 2;
      OnClick := EscondeEdtNomeCliente;
      OnDragEnter := PADragEnter;
      OnDragOver := PADragOver;
      OnDragDrop := PADragDrop;
      OnDragEnd := PADragEnd;
      Tag := PANo;
    end;

    ComponentesPA.LblAtendente := GetNewLabel(ComponentesPA.recPA);

    with ComponentesPA.LblAtendente do
    begin
      Parent := ComponentesPA.recPA;
      HitTest := True;
      DragMode := TDragMode.dmAutomatic;
      Position.X := 4;
      Position.Y := 15;
      Font.Size := 14;
      StyledSettings := StyledSettings - [TStyledSetting.Size];
      Name := cLblAtendente + IntToStr(PANo);
      Text := '';
      AutoSize := False;
      TextSettings.WordWrap := False;
{$IFNDEF IS_MOBILE}
      OnClick := EscondeEdtNomeCliente;
      OnMouseUp := AtendenteMouseUp;
{$ENDIF IS_MOBILE}
      OnDragEnter := PADragEnter;
      OnDragOver := PADragOver;
      OnDragDrop := PADragDrop;
      OnDragEnd := PADragEnd;
      Tag := PANo;
      Width := ComponentesPA.recPA.Width;
    end;

    ComponentesPA.LblCodAtendente := GetNewLabel(ComponentesPA.recPA);

    with ComponentesPA.LblCodAtendente do
    begin
      Parent := ComponentesPA.recPA;
      DragMode := TDragMode.dmAutomatic;
      Position.X := 4;
      Position.Y := 22;
      Name := cLblCodAtendente + IntToStr(PANo);
      Text := '-1';
      Visible := False;
      OnDragEnter := PADragEnter;
      OnDragOver := PADragOver;
      OnDragDrop := PADragDrop;
      OnDragEnd := PADragEnd;
      Tag := PANo;
    end;

    ComponentesPA.LblSenhaAtendente := GetNewLabel(ComponentesPA.recSenha);

    with ComponentesPA.LblSenhaAtendente do
    begin
      Name := cLblSenhaAtendente + IntToStr(PANo);
      Parent := ComponentesPA.recSenha;
      DragMode := TDragMode.dmManual;
      Text := '';
      Font.Size := 14;
      StyledSettings := StyledSettings - [TStyledSetting.Size];
      Tag := PANo;
      Visible := False;
      OnClick := EscondeEdtNomeCliente;
    end;

    ComponentesPA.LblDescSenha := GetNewLabel(ComponentesPA.recSenha);

    with ComponentesPA.LblDescSenha do
    begin
      Parent := ComponentesPA.recSenha;
      DragMode := TDragMode.dmAutomatic;
      Font.Size := 14;
      StyledSettings := StyledSettings - [TStyledSetting.Size];
      Position.X := 4;
      Position.Y := 0;
      Name := cLblDescSenha + IntToStr(PANo);
      Text := 'Senha:';
      AutoSize := True;
      TextSettings.WordWrap := False;
      StyledSettings := [];
      TextSettings.FontColor := TAlphaColorRec.White;
      OnDblClick := lblSenhaDblClick;
      HitTest := True;
      OnClick := EscondeEdtNomeCliente;
      OnDragEnter := PADragEnter;
      OnDragOver := PADragOver;
      OnDragDrop := PADragDrop;
      OnDragEnd := PADragEnd;
      Tag := PANo;
      Visible := True;
    end;

    ComponentesPA.LblSenha := GetNewLabel(ComponentesPA.recSenha);

    with ComponentesPA.LblSenha do
    begin
      Margins.Left := 2;
      AutoSize := True;
      TextSettings.WordWrap := False;
      Parent := ComponentesPA.recSenha;
      HitTest := True;
      DragMode := TDragMode.dmAutomatic;
      Font.Size := 14;
      StyledSettings := StyledSettings - [TStyledSetting.Size];
      Position.X := 46;
      Position.Y := 0;
      Name := cLblSenha + IntToStr(PANo);
      OnDblClick := lblSenhaDblClick;
      Text := '';
      OnDragEnter := PADragEnter;
      OnDragOver := PADragOver;
      OnDragDrop := PADragDrop;
      OnDragEnd := PADragEnd;
      Tag := PANo;
      StyledSettings := [];
      TextSettings.WordWrap := False;
      TextSettings.FontColor := TAlphaColorRec.White;
      TextSettings.Font.Style := [TFontStyle.fsBold];
      OnClick := EscondeEdtNomeCliente;
    end;

    ComponentesPA.lblDescEspera := GetNewLabel(ComponentesPA.recPA);

    with ComponentesPA.lblDescEspera do
    begin
      Parent := ComponentesPA.recPA;
      DragMode := TDragMode.dmAutomatic;
      Font.Size := 14;
      StyledSettings := StyledSettings - [TStyledSetting.Size];
      Position.X := 41;
      Position.Y := 30;
      Name := 'lblDescEspera' + IntToStr(PANo);
      Text := 'Esp.:';
      AutoSize := True;
      TextSettings.WordWrap := False;
      OnClick := EscondeEdtNomeCliente;
      OnDragEnter := PADragEnter;
      OnDragOver := PADragOver;
      OnDragDrop := PADragDrop;
      OnDragEnd := PADragEnd;
      Tag := PANo;
      Visible := False;
    end;

    ComponentesPA.LblEspera := GetNewLabel(ComponentesPA.recPA);

    with ComponentesPA.LblEspera do
    begin
      Margins.Left := 2;
      Parent := ComponentesPA.recPA;
      DragMode := TDragMode.dmAutomatic;
      Font.Size := 14;
      StyledSettings := StyledSettings - [TStyledSetting.Size];
      Position.X := 4;
      Position.Y := 30;
      Name := cLblEspera + IntToStr(PANo);
      AutoSize := True;
      TextSettings.WordWrap := False;

      OnClick := EscondeEdtNomeCliente;
      OnDragEnter := PADragEnter;
      OnDragOver := PADragOver;
      OnDragDrop := PADragDrop;
      OnDragEnd := PADragEnd;
      Tag := PANo;
    end;

    ComponentesPA.lblVoltarParaProximo := GetNewLabel(ComponentesPA.recSenha);

    with ComponentesPA.lblVoltarParaProximo do
    begin
      Parent := ComponentesPA.recSenha;
      DragMode := TDragMode.dmAutomatic;
      Position.X := 145;
      Position.Y := 41;
      Name := 'lblVoltarParaProximo' + IntToStr(PANo);
      Text := EmptyStr;
      Visible := False;
      OnDragEnter := PADragEnter;
      OnDragOver := PADragOver;
      OnDragDrop := PADragDrop;
      OnDragEnd := PADragEnd;
      Tag := PANo;
      OnClick := EscondeEdtNomeCliente;
    end;

    ComponentesPA.LblDescNomeCliente := GetNewLabel(ComponentesPA.recSenha);

    with ComponentesPA.LblDescNomeCliente do
    begin
      Parent := ComponentesPA.recSenha;
      DragMode := TDragMode.dmManual;
      Position.X := 4;
      Position.Y := 15;
      Font.Size := 14;
      StyledSettings := StyledSettings - [TStyledSetting.Size];
      Name := cLblDescNomeCliente + IntToStr(PANo);
      Text := 'Nome:';
      StyledSettings := [];
      TextSettings.FontColor := TAlphaColorRec.White;
      AutoSize := True;
      TextSettings.WordWrap := False;
      Height := 14;
      Enabled := True;
      Visible := vgParametrosModulo.MostrarNomeCliente;
      OnClick := lblNomeClienteClick;
      HitTest := True;
      Tag := PANo;
    end;

    ComponentesPA.LblNomeCliente := GetNewLabel(ComponentesPA.recSenha);

    with ComponentesPA.LblNomeCliente do
    begin
      Margins.Left            := 2;
      Parent                  := ComponentesPA.recSenha;
      DragMode                := TDragMode.dmManual;
      Font.Size               := 14;
      StyledSettings          := StyledSettings - [TStyledSetting.Size];
      Position.X              := 46;
      Position.Y              := 16;
      Name                    := cLblNomeCliente + IntToStr(PANo);
      Text                    := EmptyStr;
      StyledSettings          := [];
      TextSettings.FontColor  := TAlphaColorRec.White;
      AutoSize                := False;
      HitTest                 := True;
      Height                  := 14;
      Width                   := 128;
      Enabled                 := True;
      Visible                 := vgParametrosModulo.MostrarNomeCliente;
      OnClick                 := lblNomeClienteClick;
      Tag                     := PANo;
      TextSettings.Font.Style := [TFontStyle.fsBold];
    end;

    ComponentesPA.imgDadosAdicionais := TImage.Create(ComponentesPA);

    with ComponentesPA.imgDadosAdicionais do
    begin
      Parent         := ComponentesPA.recSenha;
      Align          := TAlignLayout.Right;
      DragMode       := TDragMode.dmManual;
      Name           := cLblNomeCliente + IntToStr(PANo);
      HitTest        := True;
      Width          := Height;
      Enabled        := True;
      Cursor         := crHandPoint;
      Margins.Top    := 5;
      WrapMode       := TImageWrapMode.Fit;
      Bitmap         := imgBotaoDadosAdicionais.Bitmap;
      Visible        := vgParametrosModulo.MostrarDadosAdicionais;
      OnClick        := imgDadosAdicionaisClick;
      Tag            := PANo;
    end;
  end;

  function BuscaComponenteAnterior(num: Integer): TComponentesPA;
  var
    i: Integer;
  begin
    Result := nil;

    if (Length(FMultiPAComponentes) >= 2) then
      for i := num - 1 downto 1 do
      begin
        if (FMultiPAComponentes[i] <> nil) then
        begin
          Result := FMultiPAComponentes[i];
          break;
        end;
      end;
  end;

var
  LBeginUpdatePA: Boolean;
begin
  Result := True;
  tamanhoPanel := 20;
  LBeginUpdatePA := BeginUpdatePA(PANo);

  try
    while (Length(FMultiPAComponentes) <= PANo) do
    begin
      Setlength(FMultiPAComponentes, Length(FMultiPAComponentes) + 1);
      FMultiPAComponentes[Length(FMultiPAComponentes) - 1] := nil;
    end;

    ComponentesPA := TComponentesPA.Create(Self);

    {
      if FMultiPAComponentes[Length(FMultiPAComponentes) -1] <> nil then
      FMultiPAComponentes[Length(FMultiPAComponentes) -1].Free;
      FMultiPAComponentes[Length(FMultiPAComponentes) -1] := ComponentesPA;
    }

    if FMultiPAComponentes[PANo] <> nil then
      FMultiPAComponentes[PANo].Free;

    FMultiPAComponentes[PANo] := ComponentesPA;

    ComponentesPAAnterior := BuscaComponenteAnterior(PANo);

    FUltimoBotao := nil;

    try
      ComponentesPA.PA := PANo;
      ComponentesPA.Grupo := GrupoPANo;

      try
        ComponentesPA.pnl := TPanel.Create(FramedScroll);
        ComponentesPA.pnl.Margins.Top := 4;
        ComponentesPA.pnl.Margins.Left := 4;
        ComponentesPA.pnl.Hint := IntToStr(PANo);
        ComponentesPA.pnl.ShowHint := True;

        with ComponentesPA.pnl do
        begin
          ComponentesPA.pnl.Parent := FramedScroll;
          ComponentesPA.pnl.Height := 164;
          // LM
          // ComponentesPA.pnl.Height := 564;
          ComponentesPA.pnl.Height     := ComponentesPA.pnl.Height;
          ComponentesPA.pnl.Name       := cPNL + IntToStr(PANo);
          ComponentesPA.pnl.Tag        := PANo;
          ComponentesPA.pnl.Visible    := False;
          ComponentesPA.pnl.Width      := cPanelWidth;
          ComponentesPA.pnl.Position.Y := 10;
          ComponentesPA.pnl.Position.X := 10;
        end;

        ComponentesPA.MenuAtendente := TPopupMenu.Create(Self);
        ComponentesPA.MenuAtendente.Name := cMenuAtendente + IntToStr(PANo);
        ComponentesPA.MenuAtendente.Parent := ComponentesPA.pnl;
        ComponentesPA.MenuAtendente.Tag := PANo;
        ComponentesPA.MenuAtendente.OnPopup := AbortarSeNenhumItemVisivel;

        Self.InsertComponent(ComponentesPA.MenuAtendente);

        LmnuItem := TMenuItem.Create(ComponentesPA.MenuAtendente);
        LmnuItem.Text := 'Login';
        LmnuItem.OnClick := mnuLoginClick;
        LmnuItem.Name := cMnuLogin + cSufMenuAtend + IntToStr(PANo);
        LmnuItem.Parent := ComponentesPA.MenuAtendente;
        LmnuItem.Tag := PANo;

        ComponentesPA.MenuAtendente.AddObject(LmnuItem);

        LmnuItem := TMenuItem.Create(ComponentesPA.MenuAtendente);
        LmnuItem.Text := 'Logout';
        LmnuItem.OnClick := mnuLogoutClick;
        LmnuItem.Name := cMnuLogout + cSufMenuAtend + IntToStr(PANo);
        LmnuItem.Parent := ComponentesPA.MenuAtendente;
        LmnuItem.Tag := PANo;

        ComponentesPA.MenuAtendente.AddObject(LmnuItem);

        LmnuItem := TMenuItem.Create(ComponentesPA.MenuAtendente);
        LmnuItem.Text := 'Alterar Senha';
        LmnuItem.OnClick := mnuAlterarSenhaClick;
        LmnuItem.Name := cMnuAlterarSenha + cSufMenuAtend + IntToStr(PANo);
        LmnuItem.Parent := ComponentesPA.MenuAtendente;
        LmnuItem.Tag := PANo;

        ComponentesPA.MenuAtendente.AddObject(LmnuItem);

        ComponentesPA.RecFundo                := TRectangle.Create(Self);
        ComponentesPA.RecFundo.Parent         := ComponentesPA.pnl;
        ComponentesPA.RecFundo.Align          := TAlignLayout.Client;
        ComponentesPA.RecFundo.Name           := cRecFundo + IntToStr(PANo);
        ComponentesPA.RecFundo.Tag            := PANo;
        ComponentesPA.RecFundo.HitTest        := True;
        ComponentesPA.RecFundo.OnClick        := EscondeEdtNomeCliente;
        ComponentesPA.RecFundo.Stroke.Color := $FFC3C3C3;
        //ComponentesPA.RecFundo.Stroke.Color   := TAlphaColorRec.Brown;
        ComponentesPA.RecFundo.Padding.Top    := 1;
        ComponentesPA.RecFundo.Padding.Bottom := 1;
        ComponentesPA.RecFundo.Padding.Left   := 1;
        ComponentesPA.RecFundo.Padding.Right  := 1;
        ComponentesPA.RecFundo.Fill.Color     := TAlphaColorRec.White;

{$IFNDEF IS_MOBILE}
        ComponentesPA.RecFundo.OnMouseUp      := MenuBotoesMouseUp;

        CriarMenu(PANo, ComponentesPA.RecFundo);
{$ENDIF IS_MOBILE}
        ComponentesPA.pnlPA := TPanel.Create(Self);

        with (ComponentesPA.pnlPA) do
        begin
          Parent := ComponentesPA.RecFundo;
          Align := TAlignLayout.MostTop;
          Name := 'pnlPA' + IntToStr(PANo);
          Tag := PANo;
          Height := 50;
          tamanhoPanel := tamanhoPanel + 50;
        end;

        ComponentesPA.recPA := TRectangle.Create(Self);

        with (ComponentesPA.recPA) do
        begin
          Parent := ComponentesPA.pnlPA;
          Align := TAlignLayout.Client;
          Name := 'recPA' + IntToStr(PANo);
          Tag := PANo;
          Fill.Color := TAlphaColorRec.White;
          Stroke.Kind := TBrushKind.None;
          Fill.Color := $FFEFEFEF;
          OnClick := EscondeEdtNomeCliente;
        end;

        ComponentesPA.pnlSenha := TPanel.Create(Self);

        with (ComponentesPA.pnlSenha) do
        begin
          Parent := ComponentesPA.RecFundo;
          Align := TAlignLayout.Top;
          Name := 'pnlSenha' + IntToStr(PANo);
          Tag := PANo;
          Height := 32;
          tamanhoPanel := tamanhoPanel + 32;
          OnClick := EscondeEdtNomeCliente;
        end;

        ComponentesPA.recSenha := TRectangle.Create(Self);

        with (ComponentesPA.recSenha) do
        begin
          Parent := ComponentesPA.pnlSenha;
          Align := TAlignLayout.Client;
          Name := 'recSenha' + IntToStr(PANo);
          Tag := PANo;
          Fill.Color := $FF005E8D;
          Stroke.Kind := TBrushKind.None;
          Stroke.Color  := TAlphaColorRec.Cyan;
          OnClick := EscondeEdtNomeCliente;
        end;

        ConfiguraLabels;

        ComponentesPA.pnlBotoes := TPanel.Create(Self);

        with (ComponentesPA.pnlBotoes) do
        begin
          Parent := ComponentesPA.RecFundo;
          Align := TAlignLayout.Client;
          Name := 'pnlBotoes' + IntToStr(PANo);
          Tag := PANo;
        end;

        ComponentesPA.recBotoes := TRectangle.Create(Self);

        with (ComponentesPA.recBotoes) do
        begin
          Parent := ComponentesPA.pnlBotoes;
          Align := TAlignLayout.Client;
          Name := 'recBotoes' + IntToStr(PANo);
          Tag := PANo;
          Fill.Color := TAlphaColorRec.White;
          Stroke.Kind := TBrushKind.none;
          OnClick := EscondeEdtNomeCliente;
{$IFNDEF IS_MOBILE}
          OnMouseUp := MenuBotoesMouseUp;
{$ENDIF IS_MOBILE}
        end;

        ComponentesPA.pnlTAGs := TPanel.Create(Self);

        with ComponentesPA.pnlTAGs do
        begin
          Align := TAlignLayout.Bottom;
          // Position.Y := 488.000000000000000000;
          // Size.Width := 281.000000000000000000;
          Size.Height := 44.000000000000000000;
          Size.PlatformDefault := False;
          Visible := False;
          TabOrder := 5;
          Parent := ComponentesPA.RecFundo;
          DragMode := TDragMode.dmManual;
          Name := 'pnlTAGs' + IntToStr(PANo);
          OnClick := EscondeEdtNomeCliente;
          Tag := PANo;
          Visible := False;
          StyleLookup := 'panelstyle';
        end;

        ComponentesPA.RecTAGs := TRectangle.Create(Self);

        with ComponentesPA.RecTAGs do
        begin
          Parent               := ComponentesPA.pnlTAGs;
          Align                := TAlignLayout.Client;
          Anchors              := [TAnchorKind.akTop];
          Size.Width           := 59.000000000000000000;
          Size.Height          := 50.000000000000000000;
          Size.PlatformDefault := False;
          Position.X           := 0;
          Position.Y           := 0;
          DragMode             := TDragMode.dmManual;
          Name                 := 'RecTAGs' + IntToStr(PANo);
          OnClick              := EscondeEdtNomeCliente;
          Tag                  := PANo;
          Visible              := True;
          Fill.Color           := $FFEFEFEF;
          Stroke.Kind          := TBrushKind.None;
        end;

        ComponentesPA.edtNomeCliente := TEdit.Create(Self);

        with ComponentesPA.edtNomeCliente do
        begin
          Parent := ComponentesPA.recSenha;
          DragMode := TDragMode.dmAutomatic;
          Name := cEdtNomeCliente + IntToStr(PANo);
          Text := EmptyStr;
          Height := 16;
          // Width       := 128;
          Width := 100;
          OnDragEnter := PADragEnter;
          OnDragOver := PADragOver;
          OnDragDrop := PADragDrop;
          OnDragEnd := PADragEnd;
          Tag := PANo;
          Touch.InteractiveGestures := [TInteractiveGesture.LongTap, TInteractiveGesture.DoubleTap];
          TabOrder := 2;
          Visible := False;
          OnKeyDown := edtNomeClienteKeyDown;
          OnExit := edtNomeClienteExit;
        end;

        ComponentesPA.btnProximo := GetNewButton;

        with ComponentesPA.btnProximo do
        begin
          Parent := ComponentesPA.recBotoes;
          Name := cBtnProximo + IntToStr(PANo);
          StyledSettings := StyledSettings - [TStyledSetting.Style,
            TStyledSetting.Size, TStyledSetting.Family] +
            [TStyledSetting.FontColor, TStyledSetting.Other];
          Text := 'Próximo';
          Visible := vgParametrosModulo.MostrarBotaoProximo;
          Enabled := False;
          OnClick := btnProximoClick;
          Margins.Top := 6;
          StyleLookup := 'Btseta';
          AddBotaoVisivel(ComponentesPA.btnProximo);
          Height := 26;
          Width := 100;

          if (Visible) then
            tamanhoPanel := tamanhoPanel + 30;
        end;

        ComponentesPA.BtnRechamar := GetNewButton;

        with ComponentesPA.BtnRechamar do
        begin
          Parent := ComponentesPA.recBotoes;
          Name := cBtnRechamar + IntToStr(PANo);
          StyledSettings := StyledSettings - [TStyledSetting.Style,
            TStyledSetting.Size, TStyledSetting.Family] +
            [TStyledSetting.FontColor, TStyledSetting.Other];
          Text := 'Rechamar';
          Visible := vgParametrosModulo.MostrarBotaoRechama;
          Enabled := False;
          OnClick := btnRechamarClick;
          StyleLookup := 'BtRechamar';
          AddBotaoVisivel(ComponentesPA.BtnRechamar);
          Height := 26;
          Width := 100;
          if (Visible) then
            tamanhoPanel := tamanhoPanel + 30;
        end;

        ComponentesPA.BtnEspecifica := GetNewButton;

        with ComponentesPA.BtnEspecifica do
        begin
          Parent := ComponentesPA.recBotoes;
          Name := cBtnEspecifica + IntToStr(PANo);
          Text := 'Específica';
          StyledSettings := StyledSettings - [TStyledSetting.Style,
            TStyledSetting.Size, TStyledSetting.Family] +
            [TStyledSetting.FontColor, TStyledSetting.Other];
          Visible := vgParametrosModulo.MostrarBotaoEspecifica;
          Enabled := False;
          OnClick := btnEspecificaClick;
          AddBotaoVisivel(ComponentesPA.BtnEspecifica);
          StyleLookup := 'BtApagarSenha';
          Height := 26;
          Width := 100;

          if (Visible) then tamanhoPanel := tamanhoPanel + 30;
        end;

        ComponentesPA.BtnEncaminhar := GetNewButton;

        with ComponentesPA.BtnEncaminhar do
        begin
          Parent := ComponentesPA.recBotoes;
          Name := cBtnEncaminhar + IntToStr(PANo);
          Text := 'Encaminhar';
          StyledSettings := StyledSettings - [TStyledSetting.Style,
            TStyledSetting.Size, TStyledSetting.Family] +
            [TStyledSetting.FontColor, TStyledSetting.Other];
          Visible := vgParametrosModulo.MostrarBotaoEncaminha;
          Enabled := False;
          OnClick := btnEncaminharClick;
          AddBotaoVisivel(ComponentesPA.BtnEncaminhar);
          StyleLookup := 'BtEncaminhar';
          Height := 26;
          Width := 100;
          if (Visible) then tamanhoPanel := tamanhoPanel + 30;
        end;

        ComponentesPA.BtnFinalizar := GetNewButton;

        with ComponentesPA.BtnFinalizar do
        begin
          Parent := ComponentesPA.recBotoes;
          Name := cBtnFinalizar + IntToStr(PANo);
          Text := 'Finalizar';
          Visible := vgParametrosModulo.MostrarBotaoFinaliza;
          Enabled := False;
          OnClick := btnFinalizarClick;
          AddBotaoVisivel(ComponentesPA.BtnFinalizar);
          StyleLookup := 'BtFinalizar';
          StyledSettings := StyledSettings - [TStyledSetting.Style,
            TStyledSetting.Size, TStyledSetting.Family] +
            [TStyledSetting.FontColor, TStyledSetting.Other];
          Height := 26;
          Width := 100;

          if (Visible) then tamanhoPanel := tamanhoPanel + 30;
        end;

        ComponentesPA.BtnProcessos := GetNewButton;

        with ComponentesPA.BtnProcessos do
        begin
          Parent := ComponentesPA.recBotoes;
          Name := cBtnProcessos + IntToStr(PANo);
          Text := 'Processos Paralelos';
          StyledSettings := StyledSettings - [TStyledSetting.Style, TStyledSetting.Size, TStyledSetting.Family] +
            [TStyledSetting.FontColor, TStyledSetting.Other];
          Visible := vgParametrosModulo.VisualizarProcessosParalelos and vgParametrosModulo.MostrarBotaoProcessos;
          Enabled := False;
          OnClick := btnProcessosClick;
          StyleLookup := 'BtProcessos';
          AddBotaoVisivel(ComponentesPA.BtnProcessos);
          Height := 26;
          Width := 100;

          if (Visible) then tamanhoPanel := tamanhoPanel + 30;
        end;

        ComponentesPA.BtnPausar := GetNewButton;

        with ComponentesPA.BtnPausar do
        begin
          Parent         := ComponentesPA.recBotoes;
          StaysPressed   := True;
          Name           := cBtnPausar + IntToStr(PANo);
          Text           := 'Pausa';
          StyledSettings := StyledSettings - [TStyledSetting.Style,
            TStyledSetting.Size, TStyledSetting.Family] +
            [TStyledSetting.FontColor, TStyledSetting.Other];
          Visible        := vgParametrosModulo.MostrarBotaoPausa;
          Enabled        := False;
          OnClick        := btnPausarClick;
          AddBotaoVisivel(ComponentesPA.BtnPausar);
          StyleLookup    := 'BtPausar';
          Height         := 26;
          Width          := 100;

          if (Visible) then tamanhoPanel := tamanhoPanel + 30;
        end;

        ComponentesPA.BtnSeguirAtendimento := GetNewButton;

        with ComponentesPA.BtnSeguirAtendimento do
        begin
          Parent := ComponentesPA.recBotoes;
          StaysPressed := True;
          Name := cBtnSeguirAtendimento + IntToStr(PANo);
          Text := 'Seguir Atendimento';
          StyledSettings := StyledSettings - [TStyledSetting.Style,
            TStyledSetting.Size, TStyledSetting.Family] +
            [TStyledSetting.FontColor, TStyledSetting.Other];
          Visible := vgParametrosModulo.MostrarBotaoSeguirAtendimento;
          Enabled := False;
          OnClick := btnSeguirAtendimentoClick;
          AddBotaoVisivel(ComponentesPA.BtnSeguirAtendimento);
          StyleLookup := 'BtSeta';
          Height := 26;
          Width := 100;
          if (Visible) then
            tamanhoPanel := tamanhoPanel + 30;
        end;

        ComponentesPA.pnlBotoes.Height := tamanhoPanel - 102;
        { ComponentesPA.BtnLogout        := GetNewButton;
          with ComponentesPA.BtnLogout do
          begin
          Parent  := ComponentesPA.recFundo;
          Name    := cBtnLogout + IntToStr(PANo);
          Text    := 'Logout';
          Visible := vgParametrosModulo.MostrarBotaoLogout;
          Enabled := False;
          OnClick := BtnLogoutClick;
          AddBotaoVisivel(ComponentesPA.BtnLogout);
          end; }

        ComponentesPA.pnlLogin := TPanel.Create(Self);

        with (ComponentesPA.pnlLogin) do
        begin
          Parent := ComponentesPA.RecFundo;
          Align := TAlignLayout.MostBottom;
          Name := 'pnlLogin' + IntToStr(PANo);
          Tag := PANo;
          Height := 42;
          Visible := vgParametrosModulo.MostrarBotaoLogin;

          if (Visible) then tamanhoPanel := tamanhoPanel + 42;
        end;

        ComponentesPA.recLogin := TRectangle.Create(Self);

        with (ComponentesPA.recLogin) do
        begin
          Parent := ComponentesPA.pnlLogin;
          Align := TAlignLayout.Client;
          Name := 'recLogin' + IntToStr(PANo);
          Tag := PANo;
          Fill.Color := TAlphaColorRec.Null;
          Stroke.Kind := TBrushKind.None;
          OnClick := EscondeEdtNomeCliente;
        end;

        ComponentesPA.BtnLogin := GetNewButton;

        with ComponentesPA.BtnLogin do
        begin
          Parent := ComponentesPA.recLogin;

          Name    := cBtnLogin + IntToStr(PANo);
          Anchors := [TAnchorKind.akBottom];
          Text    := 'Login';
          Visible := vgParametrosModulo.MostrarBotaoLogin;
          Enabled := False;
          OnClick := btnLoginClick;
          Height  := 26;
          Width   := 100;
          AddBotaoVisivel(ComponentesPA.BtnLogin);
        end;

        ComponentesPA.LblMotivoPausa := GetNewLabel(ComponentesPA.recBotoes);

        with ComponentesPA.LblMotivoPausa do
        begin
          Parent                  := ComponentesPA.recBotoes;
          Align                   := TAlignLayout.Bottom;
          Margins.Bottom          := 5;
          Margins.Right           := 5;
          StyledSettings          := [];
          Name                    := cLblMotivoPausa + IntToStr(PANo);
          Text                    := EmptyStr;
          StyledSettings          := [];
          TextSettings.FontColor  := COR_DEFAULT_MOTIVO_PAUSA;
          TextSettings.WordWrap   := False;
          TextSettings.Font.Size  := 14;
          TextSettings.Font.Style := [TFontStyle.fsBold];
          TextSettings.HorzAlign  := TTextAlign.Center;
          Height                  := 26;
          AutoSize                := False;
          Position.X              := ComponentesPA.LblAtendente.Position.X + ComponentesPA.LblAtendente.Width + OFF;
          Position.Y              := ComponentesPA.LblNomeCliente.Position.Y + 6;
          Width                   := 100;
          Visible                 := vgParametrosModulo.MostrarBotaoPausa;
          Tag                     := PANo;
        end;

        ComponentesPA.recCodBarras := TRectangle.Create(Self);

        with ComponentesPA.recCodBarras do
        begin
          Parent      := ComponentesPA.pnl;
          Fill.Color  := TAlphaColorRec.Lime;
          Opacity     := 0.5;
          Stroke.Kind := TBrushKind.None;
          Visible     := False;

          BringToFront;
        end;

         ComponentesPA.pnlObservacao := TPanel.Create(Self);

        with (ComponentesPA.pnlObservacao) do
        begin
          Parent := ComponentesPA.RecFundo;
          Align := TAlignLayout.MostBottom;
          Name := 'pnlObservacao' + IntToStr(PANo);
          Margins.Top    := 5;
          Margins.Bottom := 5;
          Tag := PANo;
          Height := 42;
          Visible := vgParametrosModulo.MostrarDadosAdicionais;

          if (Visible) then tamanhoPanel := tamanhoPanel + 42;
        end;

        ComponentesPA.recObservacao := TRectangle.Create(Self);

        with (ComponentesPA.recObservacao) do
        begin
          Parent      := ComponentesPA.pnlObservacao;
          Align       := TAlignLayout.Client;
          Name        := 'recObservacao' + IntToStr(PANo);
          Tag         := PANo;
          Stroke.Kind := TBrushKind.None;
          Fill.Color  := $FFEFEFEF;
          OnClick     := imgDadosAdicionaisClick;
        end;

        ComponentesPA.lblObservacao := TLabel.Create(Self);

        with (ComponentesPA.lblObservacao) do
        begin
          Parent := ComponentesPA.recObservacao;
          Align := TAlignLayout.Client;
          Name := 'lblObservacao' + IntToStr(PANo);
          Tag := PANo;
          Fill.Color := TAlphaColorRec.Null;
          TextSettings.Font.Family := 'Montserrat';
          TextSettings.Font.Style :=  [TFontStyle.fsBold];
          TextSettings.Font.Size := 16;
          TextSettings.WordWrap := False;
          OnClick := imgDadosAdicionaisClick;
        end;

        ComponentesPA.pnl.Height := tamanhoPanel;
        FAlturaMinima := tamanhoPanel;

        if (ComponentesPA.pnl.Width < ComponentesPA.LblEspera.Position.X + 50) then
          ComponentesPA.pnl.Width := ComponentesPA.LblEspera.Position.X + 50;

        ComponentesPA.recCodBarras.Align := TAlignLayout.Contents;
      except
        Result := False;
        TLog.MyLog('Erro ao criar PA ' + IntToStr(PANo), Self);
        Exit;
      end;

      try
        AtualizarNomePA(SemPA, PANo);
      except
        Result := False;
        TLog.MyLog('Erro ao atualizar "AtualizarNomePA" info PA ' + IntToStr(PANo), Self);
      end;
      try
        AtualizarMotivoPausa(COR_DEFAULT_MOTIVO_PAUSA, '', PANo);
      except
        Result := False;
        TLog.MyLog('Erro ao atualizar "AtualizarMotivoPausa" info PA ' + IntToStr(PANo), Self);
      end;
      try
        AtualizarNomeCliente(SemNomeCliente, PANo);
      except
        Result := False;
        TLog.MyLog('Erro ao atualizar "AtualizarNomeCliente" info PA ' + IntToStr(PANo), Self);
      end;
      try
        AtualizarAtendente(SemAtendente, PANo, -1);
      except
        Result := False;
        TLog.MyLog('Erro ao atualizar "AtualizarAtendente" info PA ' + IntToStr(PANo), Self);
      end;
      try
        AtualizarSenha(PANo, SemSenha);
      except
        Result := False;
        TLog.MyLog('Erro ao atualizar "AtualizarSenha" info PA ' + IntToStr(PANo), Self);
      end;
      try
        AtualizarEspera(PANo, 0);
      except
        Result := False;
        TLog.MyLog('Erro ao atualizar "AtualizarEspera" info PA ' + IntToStr(PANo), Self);
      end;
      try
        AtualizarObservacaoPA(PANo);
      except
        Result := False;
        TLog.MyLog('Erro ao atualizar "Observações" info PA ' + IntToStr(PANo), Self);
      end;
      try
        UpdatePAStatus(PANo);
      except
        Result := False;
        TLog.MyLog('Erro ao atualizar "UpdatePAStatus" info PA ' + IntToStr(PANo), Self);
      end;
    finally
      if vgParametrosModulo.JaEstaConfigurado then
        CarregarParametrosDB(PANo, IdUnidade);

      AjustarTopBotoes(False);
    end;
  finally
    if LBeginUpdatePA then
      EndUpdatePA(PANo);

    if vgParametrosModulo.JaEstaConfigurado then
      CarregarParametrosDB(PANo, IdUnidade);
  end;
end;

procedure TFrmSicsMultiPA.CriarGruposPAs;
var
  i { , LCodGrupoPA } : Integer;
  LNomeGrupoPA: String;
  cdsClone: TClientDataSet;
begin
  inherited;
{$IFNDEF IS_MOBILE}
  LockWindowUpdate(WindowHandleToPlatform(Self.Handle).Wnd);
{$ENDIF IS_MOBILE}
  try
    try
      try
        TLog.MyLog('CriarGruposPAs: Início.', Self, 0, False, tlDEBUG);
        OnResize := nil;

        try
          cdsClone := TClientDataSet.Create(nil);

          try
            cdsClone.CloneCursor(DMClient(0, not CRIAR_SE_NAO_EXISTIR)
              .cdsGruposDePAs, True);
            cdsClone.First;

            while not cdsClone.eof do
            begin
              LCodGrupoPA := cdsClone.FieldByName('ID').AsInteger;
              LNomeGrupoPA := cdsClone.FieldByName('NOME').AsString;

              if not CriaComponenteGrupoPA(LCodGrupoPA, LNomeGrupoPA) then
              begin
                ErrorMessage('Erro ao criar Grupo de PA ' + LNomeGrupoPA);
                cdsClone.Next;
                Continue;
              end
              else
                cdsClone.Next;
            end;

            CriaComponenteGrupoPA(0, 'Todos');
          finally
            cdsClone.Free;
          end;
        finally
          OnResize := FormResize;
        end;

      except
        TLog.MyLog('Erro ao criar lista PAs.', Self);
      end;
    finally
      FormResize(Self);
      TLog.MyLog('CriarGruposPAs: Fim.', Self, 0, False, tlDEBUG);
    end;
  finally
{$IFNDEF IS_MOBILE}
    LockWindowUpdate(0);
{$ENDIF IS_MOBILE}
  end;
end;

procedure TFrmSicsMultiPA.CriarPAs;
var
  i, LCodPA { , LCodGrupoPA } : Integer;
  LBeginUpdatePA: Boolean;
  LListaPa: TIntegerDynArray;
  cdsClone: TClientDataSet;
begin
  inherited;
{$IFNDEF IS_MOBILE}
  // KM - Teste Performance Delboni TLog.MyLog('               INI LockWindowUpdate(Handle)', nil, 0, false, TCriticalLog.tlINFO); //xxx
  LockWindowUpdate(WindowHandleToPlatform(Self.Handle).Wnd);
  // KM - Teste Performance Delboni TLog.MyLog('               FIM LockWindowUpdate(Handle)', nil, 0, false, TCriticalLog.tlINFO); //xxx
{$ENDIF IS_MOBILE}
  try
    // KM - Teste Performance Delboni TLog.MyLog('               INI BeginUpdatePA', nil, 0, false, TCriticalLog.tlINFO); //xxx
    TLog.MyLog('CriarPAs: Início.', Self);
    LBeginUpdatePA := BeginUpdatePA(LListaPa);
    try
      // KM - REMOVIDO O ANIINDICATOR, pois estava causando travamento da aplicação ao ser ocultado/desativado, no final deste procedimento (somente em algumas máquinas)
      // AniIndicator.Visible := true;
      // AniIndicator.Enabled := True;
      // KM - Teste Performance Delboni TLog.MyLog('               Ativou AniIndicator', nil, 0, false, TCriticalLog.tlINFO); //xxx
      try
        OnResize := nil;

        try
          cdsClone := TClientDataSet.Create(nil);

          try
            cdsClone.CloneCursor(DMClient(0, not CRIAR_SE_NAO_EXISTIR).cdsPAs, True);
            cdsClone.First;

            while not cdsClone.eof do
            begin
              // KM - Teste Performance Delboni TLog.MyLog('               Inserindo PA ' + cdsClone.RecNo.ToString + ' de ' + cdsClone.RecordCount.ToString, nil, 0, false, TCriticalLog.tlINFO); //xxx
              LCodPA := cdsClone.FieldByName('ID').AsInteger;
              LCodGrupoPA := cdsClone.FieldByName('IdGrupo').AsInteger;
              if (not GetPaJaFoiCriada(LCodPA)) then
              { pois no restore do trayicon chama o FormShow e causa erro ao tentar criar uma PA já existente. Ideal = mover o codigo de criar as PAs para o Create do Form mas dá erro pois depende de outro form ainda nao criado. Sera possivel qdo aquele form virar DM }
              begin
                // KM - Teste Performance Delboni TLog.MyLog('               INI CriaComponentePA(' + LCodPA.ToString + ')', nil, 0, false, TCriticalLog.tlINFO); //xxx
                if not CriaComponentePA(LCodPA, LCodGrupoPA) then
                begin
                  ErrorMessage('Erro ao criar PA ' + IntToStr(LCodPA));
                  Continue;
                end;
                // KM - Teste Performance Delboni TLog.MyLog('               FIM CriaComponentePA(' + LCodPA.ToString + ')', nil, 0, false, TCriticalLog.tlINFO); //xxx
              end;
              cdsClone.Next;
            end;
          finally
            cdsClone.Free;
          end;
        finally
          OnResize := FormResize;
        end;

      except
        on e: exception do
          TLog.MyLog('Erro ao criar lista PAs. ' + e.Message, Self);
      end;
    finally
      FormResize(Self);
      if LBeginUpdatePA then
      begin
        EndUpdatePA(LListaPa);
        // KM - Teste Performance Delboni TLog.MyLog('               FIM EndUpdatePA', nil, 0, false, TCriticalLog.tlINFO); //xxx
      end;

      TLog.MyLog('CriarPAs: Fim.', Self);
    end;
  finally
{$IFNDEF IS_MOBILE}
    // KM - Teste Performance Delboni TLog.MyLog('               INI LockWindowUpdate(0)', nil, 0, false, TCriticalLog.tlINFO); //xxx
    LockWindowUpdate(0);
    // KM - Teste Performance Delboni TLog.MyLog('               FIM LockWindowUpdate(0)', nil, 0, false, TCriticalLog.tlINFO); //xxx
{$ENDIF IS_MOBILE}
    // KM - Teste Performance Delboni TLog.MyLog('               INI ProcessMessages', nil, 0, false, TCriticalLog.tlINFO); //xxx
    // Application.ProcessMessages;
    // KM - Teste Performance Delboni TLog.MyLog('               FIM ProcessMessages', nil, 0, false, TCriticalLog.tlINFO); //xxx
    // KM - REMOVIDO O ANIINDICATOR, pois causa travamento em algumas máquinas
    // AniIndicator.Visible := False;
    // AniIndicator.Enabled := False;
    // KM - Teste Performance Delboni TLog.MyLog('               Desativou AniIndicator', nil, 0, false, TCriticalLog.tlINFO); //xxx
  end;
end;

procedure TFrmSicsMultiPA.CriarTAGs;
var
  i: Integer;
  TAGs: TIntegerDynArray;
begin
{$IFNDEF IS_MOBILE}
  LockWindowUpdate(WindowHandleToPlatform(Self.Handle).Wnd);
{$ENDIF IS_MOBILE}
  try
    try
      for i := 1 to MaxIdPAs do
      begin
        //inherited CriarTAGs(i);
        inherited SelecionarTAGs(i, TAGs);
      end;
    finally
    end;
  finally
{$IFNDEF IS_MOBILE}
    LockWindowUpdate(0);
{$ENDIF IS_MOBILE}
  end;
  OrganizaPAs;
end;

procedure TFrmSicsMultiPA.DefinirCor(const aIdUnidade: Integer;
  const ACor, aCorOld: TAlphaColor; const aPintarRetangulo: Boolean);
begin
  inherited;
end;

destructor TFrmSicsMultiPA.Destroy;
var
  i: Integer;
begin
  for i := Low(FMultiPAComponentes) to High(FMultiPAComponentes) do
  begin
    FMultiPAComponentes[i].Free;
    FMultiPAComponentes[i] := nil;
  end;

  Setlength(FMultiPAComponentes, 0);
  inherited;
end;

procedure TFrmSicsMultiPA.ExibePAs;
begin
  FiltrarPA;
end;

function TFrmSicsMultiPA.GetCodGrupoPA(const Sender: TObject): Integer;
begin
  Result := -1;
  if Assigned(Sender) and (Sender is TComponent) then
    Result := TComponent(Sender).Tag;
end;

function TFrmSicsMultiPA.GetCodPA(const Sender: TObject): Integer;
begin
  Result := -1;
  if Assigned(Sender) and (Sender is TComponent) then
    Result := TComponent(Sender).Tag;
end;

function TFrmSicsMultiPA.GetPaJaFoiCriada(const aPA: Integer): Boolean;
begin
  Result := ((aPA > -1) and (Length(FMultiPAComponentes) > aPA) and
    (FMultiPAComponentes[aPA] <> nil));
end;

function TFrmSicsMultiPA.GetpnlGrupos: TFramedScrollBox;
begin
  Result := FramedScrollGrupos;
end;

function TFrmSicsMultiPA.GetSenhaAtend(const aCodAtend: Integer): String;
var
  i: Integer;
begin
  Result := EmptyStr;
  for i := 1 to MaxIdPAs do
  begin
    if (GetCodAtend(i) = aCodAtend) then
    begin
      Result := GetLblSenhaAtendente(i).Text;
      break;
    end;
  end;
end;

function TFrmSicsMultiPA.GetSituacaoAtual: String;
var
  i, LCodPA: Integer;
  LdmClient: TDMClient;
begin
  Result := '';
  LdmClient := DMClient(0, not CRIAR_SE_NAO_EXISTIR);
  LdmClient.cdsPAs.First;

  while not LdmClient.cdsPAs.eof do
  begin
    LCodPA := LdmClient.cdsPAs.FieldByName('ID').AsInteger;
    if (GetPaJaFoiCriada(LCodPA)) then
    begin
      if (Result <> '') then
        Result := Result + ' | ';

      Result := Result + GetSituacaoAtualPA(LCodPA);
    end;

    LdmClient.cdsPAs.Next;
  end;
end;

function TFrmSicsMultiPA.InChanges: Boolean;
var
  i: Integer;
  LdmClient: TDMClient;
begin
  Result := False;
  LdmClient := DMClient(0, not CRIAR_SE_NAO_EXISTIR);

  if vgParametrosModulo.JaEstaConfigurado then
  begin
    LdmClient.cdsPAs.First;
    while not LdmClient.cdsPAs.eof do
    begin
      if (InChanges(LdmClient.cdsPAs.FieldByName('ID').AsInteger)) then
        Result := True;

      LdmClient.cdsPAs.Next;
    end;
  end;
end;

function TFrmSicsMultiPA.InUpdatePA: Boolean;
var
  i: Integer;
  LdmClient: TDMClient;
begin
  Result := False;
  LdmClient := DMClient(0, not CRIAR_SE_NAO_EXISTIR);

  if vgParametrosModulo.JaEstaConfigurado then
  begin
    LdmClient.cdsPAs.First;
    while not LdmClient.cdsPAs.eof do
    begin
      if (inherited InUpdatePA(LdmClient.cdsPAs.FieldByName('ID').AsInteger))
      then
      begin
        Result := True;
        break;
      end;

      LdmClient.cdsPAs.Next;
    end;
  end;
end;

procedure TFrmSicsMultiPA.MenuBotoesMouseClick(Sender: TObject);
var
  PA: Integer;
  menuBar: TPopupMenu;
begin
  PA := GetCodPA(Sender);
  if (PA <= 0) then
    Exit;

  menuBar := Self.GetComponentePA(cmnuBar, PA) as TPopupMenu;

  if Assigned(menuBar) then
  begin
    UpdateButtons(PA);
    menuBar.Popup(Screen.MousePos.X, Screen.MousePos.Y);
  end;
end;

procedure TFrmSicsMultiPA.MenuBotoesMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  if Button = TMouseButton.mbRight then
  begin
    MenuBotoesMouseClick(Sender);
  end;
end;

procedure TFrmSicsMultiPA.MenuClick(Sender: TObject);
begin
  inherited;
  EscondeEdtNomeCliente(Sender);
end;

procedure TFrmSicsMultiPA.btnGrupoPAClick(Sender: TObject);
var
  // LCodGrupoPA: SmallInt;
  LCountBtnGrupos: Integer;
begin
  inherited;

  for LCountBtnGrupos := 0 to Pred(rectButtons.ChildrenCount) do
  begin
    if (rectButtons.Children[LCountBtnGrupos] is TButton) then
    begin
      (rectButtons.Children[LCountBtnGrupos] as TButton).StyleLookup :=
        'btAzulClaro';
    end;
  end;

  (Sender as TButton).StyleLookup := 'btAzulEscuro';
  LCodGrupoPA := GetCodGrupoPA((Sender as TControl));
  MostraGrupoPA(LCodGrupoPA);
end;

procedure TFrmSicsMultiPA.menuForcaFecharProgramaClick(Sender: TObject);
begin
  inherited;

  vgParametrosModulo.PodeFecharPrograma := True;
  Close;
end;

procedure TFrmSicsMultiPA.menuVisualizaInputLCDBClick(Sender: TObject);
begin
  inherited;

  frmSicsCommon_LCDBInput.Show;
end;

procedure TFrmSicsMultiPA.mnuSobreClick(Sender: TObject);
begin
  inherited;
  InformationMessage(VERSAO + #13#13 + GetExeVersion);
end;

procedure TFrmSicsMultiPA.OrganizaPAs;
const
  OFF = 4;

var
  ComponentePA: TComponentesPA;
  i, Alinhados, ScreenWidth, ScreenHeight, IdPA: Integer;
  LarguraPainel, AlturaPainel, AlturaPainelTAGS, tamanho: Single;
  LcdsPAs: TClientDataSet;
  FMaxPanelHeight, FMaxTAGsHeight: Integer;
begin
  try
    ScreenWidth := Self.Width;
    rectFundo.Visible := False;
    Alinhados := 0;
    AlturaPainelTAGS := 0;

    LcdsPAs := DMClient(0, not CRIAR_SE_NAO_EXISTIR).cdsPAs;

    if Assigned(LcdsPAs) then
    begin
      LcdsPAs.First;

      while not LcdsPAs.eof do
      begin
        IdPA := LcdsPAs.FieldByName('ID').AsInteger;

        ComponentePA := nil;

        for i := Low(FMultiPAComponentes) to High(FMultiPAComponentes) do
        begin
          if (Assigned(FMultiPAComponentes[i])) and (FMultiPAComponentes[i].pnl.Tag = IdPA) then
          begin
            ComponentePA := FMultiPAComponentes[i];
            break;
          end;
        end;

        if Assigned(ComponentePA) then
        begin
          if ComponentePA.pnl.Visible then
          begin
            //ComponentePA.pnlTAGs.Height := FAlturaTAGs;
            ComponentePA.pnl.Width := cPanelWidth;

            LarguraPainel := ComponentePA.pnl.Width;

            if AlturaPainel < ComponentePA.pnl.Height then
              AlturaPainel := ComponentePA.pnl.Height;

            ComponentePA.pnl.Position.X := OFF + (OFF + LarguraPainel) * (Alinhados mod vgParametrosModulo.ColunasPAs);
            ComponentePA.pnl.Position.Y := OFF + (OFF + AlturaPainel) * (Alinhados div vgParametrosModulo.ColunasPAs);

            Alinhados := Alinhados + 1;

            OrganizaPosicaoBotoes(ComponentePA.pnl.Tag);
          end;
        end;

        LcdsPAs.Next;
      end;
    end;

    FMaxPanelHeight := 0;
    FMaxTAGsHeight  := 0;

    for var iCont := Low(FMultiPAComponentes) to High(FMultiPAComponentes) do
    begin
      if (Assigned(FMultiPAComponentes[iCont]))  then
      begin
        if FMaxPanelHeight < FMultiPAComponentes[iCont].pnl.Height then
          FMaxPanelHeight := Trunc(FMultiPAComponentes[iCont].pnl.Height);

        if FMaxTAGsHeight < FMultiPAComponentes[iCont].pnlTAGs.Height then
          FMaxTAGsHeight := Trunc(FMultiPAComponentes[iCont].pnlTAGs.Height);
      end;
    end;

    for var iCont := Low(FMultiPAComponentes) to High(FMultiPAComponentes) do
    begin
      if (Assigned(FMultiPAComponentes[iCont]))  then
      begin
        FMultiPAComponentes[iCont].pnl.Height := FMaxPanelHeight;
        FMultiPAComponentes[iCont].pnlTAGs.Height := FMaxTAGsHeight;
      end;
    end;
  finally
    rectFundo.Visible := True;
  end;
end;

procedure TFrmSicsMultiPA.OrganizaPosicaoBotoes(const aPA: Integer);
const
  OFF_LEFT = 5;
  OFF_TOP = 5;

var
  // LeftPosition : Integer;
  // LeftFirst    : Integer;
  // linha        : Integer;
  // HeightFirst  : Single;
  TopPosition: Single;
  // HeightLast  : Single;
  pnl: TPanel;
  // recTags : TRectangle;
  // somaAlturas : Single;
  metadeTamanhoParent, tamBotao, metadeTamanhoBotao, posX, tamanhoAltura: Single;
  recBotoes: TRectangle;
begin
  tamanhoAltura := 30;
  tamBotao := 142;
  metadeTamanhoParent := GetRecFundo(aPA).Width / 2;
  // btnLogout.Position.X := (recLogin.Width /2) + 5;

  metadeTamanhoBotao                      := tamBotao / 2;
  posX                                    := metadeTamanhoParent - metadeTamanhoBotao;
  GetbtnProximo(aPA).Position.X           := posX;
  GetBtnRechamar(aPA).Position.X          := posX;
  GetBtnEncaminhar(aPA).Position.X        := posX;
  GetBtnEspecifica(aPA).Position.X        := posX;
  GetBtnRechamar(aPA).Position.X          := posX;
  GetBtnFinalizar(aPA).Position.X         := posX;
  GetBtnProcessos(aPA).Position.X         := posX;
  GetBtnPausar(aPA).Position.X            := posX;
  GetBtnSeguirAtendimento(aPA).Position.X := posX;

  TopPosition := (GetRecBotoes(aPA).Parent as TPanel).Position.Y + 11;

  with GetbtnProximo(aPA) do
  begin
    if Visible then
    begin
      Position.Y := TopPosition;
      TopPosition := TopPosition + Height + OFF_TOP;
      tamanhoAltura := tamanhoAltura + Height;
    end;
  end;

  with GetBtnRechamar(aPA) do
  begin
    if Visible then
    begin
      Position.Y := TopPosition;
      TopPosition := TopPosition + Height + OFF_TOP;
      tamanhoAltura := tamanhoAltura + Height;
    end;
  end;

  with GetBtnEspecifica(aPA) do
  begin
    if Visible then
    begin
      Position.Y := TopPosition;
      TopPosition := TopPosition + Height + OFF_TOP;
      tamanhoAltura := tamanhoAltura + Height;
    end;
  end;

  with GetBtnEncaminhar(aPA) do
  begin
    if Visible then
    begin
      Position.Y := TopPosition;
      TopPosition := TopPosition + Height + OFF_TOP;
      tamanhoAltura := tamanhoAltura + Height;
    end;
  end;

  with GetBtnFinalizar(aPA) do
  begin
    if Visible then
    begin
      Position.Y := TopPosition;
      TopPosition := TopPosition + Height + OFF_TOP;
      tamanhoAltura := tamanhoAltura + Height;
    end;
  end;

  with GetBtnProcessos(aPA) do
  begin
    if Visible then
    begin
      Position.Y := TopPosition;
      TopPosition := TopPosition + Height + OFF_TOP;
      tamanhoAltura := tamanhoAltura + Height;
    end;
  end;

  with GetBtnSeguirAtendimento(aPA) do
  begin
    if Visible then
    begin
      Position.Y := TopPosition;
      TopPosition := TopPosition + Height + OFF_TOP;
      tamanhoAltura := tamanhoAltura + Height;
    end;
  end;

  with GetBtnPausar(aPA) do
  begin
    if Visible then
    begin
      Position.Y := TopPosition;
      TopPosition := TopPosition + Height + OFF_TOP;
      tamanhoAltura := tamanhoAltura + Height + GetLblMotivoPausa(aPA).Height + 20;
    end;
  end;

  with GetLblMotivoPausa(aPA) do
  begin
    // Position.Y := TopPosition;
    // tamanhoAltura := tamanhoAltura + Height;
  end;

  GetbtnProximo(aPA).Width           := tamBotao;
  GetBtnRechamar(aPA).Width          := tamBotao;
  GetBtnEspecifica(aPA).Width        := tamBotao;
  GetBtnEncaminhar(aPA).Width        := tamBotao;
  GetBtnFinalizar(aPA).Width         := tamBotao;
  GetBtnProcessos(aPA).Width         := tamBotao;
  GetBtnPausar(aPA).Width            := tamBotao;
  GetBtnSeguirAtendimento(aPA).Width := tamBotao;

  recBotoes := GetRecBotoes(aPA);
  pnl := GetPNL(aPA);
  pnl.Height := pnl.Height + (tamanhoAltura - TPanel(recBotoes.Parent).Height);

  GetBtnLogin(aPA).Width := tamBotao;
  GetBtnLogin(aPA).Position.X := (GetRecLogin(aPA).Width - GetBtnLogin(aPA).Width) / 2;
  GetBtnLogin(aPA).Position.Y := (GetRecLogin(aPA).Parent as TPanel).Position.Y + ((GetRecLogin(aPA).Height - GetBtnLogin(aPA).Height) / 2);
end;

function TFrmSicsMultiPA.FindTarget(P: TPointF; const Data: TDragObject): IControl;
  function RemoveNumeroNoFinal(const aValue: String): String;
  var
    i: SmallInt;
  begin
    Result := aValue;
    for i := Length(Result) downto 0 do
    begin
      if CharInSet(Result[i], ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'])
      then
        Delete(Result, i, 1)
      else
        break;
    end;
  end;

  procedure FindComponentAndSubComp(const AOwner: TComponent;
    const AName: string; const aFindInSubComponent: Boolean);

    function IsComponentFinder(const aComponent: TComponent): Boolean;
    begin
      Result := Assigned(aComponent) and
        (Pos(UpperCase(AName), UpperCase(aComponent.Name)) = 1);
    end;

    procedure InternalFindComponentSub(const aComponent: TComponent);
    var
      i: Integer;
      LSubComponent: TComponent;
      NewObj: IControl;
    begin
      Result := nil;
      if not Assigned(aComponent) then
        Exit;

      if Assigned(aComponent) and Supports(aComponent, IControl, NewObj) then
        Result := NewObj.FindTarget(P, Data);

      if (aFindInSubComponent and (not Assigned(Result))) then
      begin
        for i := 0 to aComponent.ComponentCount - 1 do
        begin
          LSubComponent := AOwner.Components[i];
          if not(Assigned(LSubComponent) and (LSubComponent <> aComponent)) then
            Continue;
          if Assigned(aComponent) and Supports(aComponent, IControl, NewObj)
          then
            Result := NewObj.FindTarget(P, Data);

          if Assigned(Result) then
            Exit;

          InternalFindComponentSub(LSubComponent);
          if Assigned(Result) then
            Exit;
        end;
      end;
    end;

  begin
    if (AName <> '') then
      InternalFindComponentSub(AOwner);
  end;

var
  NameComponent: string;
begin
  Result := inherited;
  if not Assigned(Result) then
  begin
    NameComponent := (Data.Source as TControl).Name;
    NameComponent := RemoveNumeroNoFinal(NameComponent);
    FindComponentAndSubComp(Self, NameComponent, True);
  end;
end;

function TFrmSicsMultiPA.FormataNomeComponente(const aNomeComponente: String;
  const aPA: Integer): String;
begin
  Result := inherited FormataNomeComponente(aNomeComponente, aPA);
  if (aPA > 0) then
    Result := Result + IntToStr(aPA);
end;

procedure TFrmSicsMultiPA.FormResize(Sender: TObject);
var
  i: Integer;
begin
  if not vgParametrosModulo.JaEstaConfigurado then
    Exit;

  if InUpdatePA then
  begin
    if not InChanges then
      BeginChangesForPAInUpdate;
    Exit;
  end;

  for i := 1 to Length(FMultiPAComponentes) - 1 do
  begin
    if (FMultiPAComponentes[i] <> nil) then
      OrganizaPosicaoBotoes(i);
  end;

  tmrAtualizaForm.Enabled := False;

  OrganizaPAs;

  if (Self.Width < 240) then
  begin
    Self.Width := 240;
  end;
  if (Self.Height < (FAlturaMinima + 100)) then
  begin
    Self.Height := FAlturaMinima + 100;
  end;

  inherited;
end;

function TFrmSicsMultiPA.GetCodAtend(const aPA: Integer): Integer;
var
  LLblCodAtendente: TLabel;
begin
  LLblCodAtendente := GetLblCodAtendente(aPA);
  Result := -1;
  if Assigned(LLblCodAtendente) then
    Result := StrToIntDef(LLblCodAtendente.Text, -1);
end;

procedure TFrmSicsMultiPA.PADragDrop(Sender: TObject; const Data: TDragObject;
  const Point: TPointF);
begin
  PADragEnd(Sender);
end;

procedure TFrmSicsMultiPA.AlteraPADoUsuarioLogado(const vDestinoEstaLogado
  : Boolean; const vDestinoAtendenteID, vOrigemAtendenteID: Integer;
  const vOrigemAtendenteSenha: string);
begin
  Logout(vOrigemID, vOrigemAtendenteID, True, True, vOrigemAtendenteSenha,
    vDestinoID, True);
end;

procedure TFrmSicsMultiPA.PADragEnd(Sender: TObject);
var
  vDestinoAtendenteNome: string;
  vDestinoEstaAtendendo: Boolean;
  vDestinoEstaLogado: Boolean;
  vDestinoNomePA: string;
  vDestinoSenha: string;
  vOrigemAtendenteSenha: string;
  vOrigemAtendenteID: Integer;
  vDestinoAtendenteID: Integer;
  vOrigemAtendenteNome: string;
  vOrigemEstaAtendendo: Boolean;
  vOrigemNomePA: string;
  vOrigemSenha: string;
  vMsg: string;
  vFila: Integer;
  LSituacaoPAAoExibirFormOrigem, LSituacaoPAAoExibirFormDestino: string;
begin
  try
    if not(vAccept and Assigned(Sender)) then
      Exit;

    if (vOrigemID > 0) and (vDestinoID > 0) then
    begin
      case fgDragKind of
        dkAtendente:
          begin
            vDestinoNomePA := NomePA(vDestinoID);
            vOrigemAtendenteNome := NomeAtendente(vOrigemID);
            vOrigemAtendenteID := DMClient(IdUnidade, not CRIAR_SE_NAO_EXISTIR).GetIdAtd(vOrigemAtendenteNome);

            if vOrigemAtendenteID <> -1 then
            begin
              vOrigemSenha          := SenhaAtual(vOrigemID);
              vDestinoSenha         := SenhaAtual(vDestinoID);
              vOrigemEstaAtendendo  := EstaEmAtendimento(vOrigemID);
              vDestinoEstaAtendendo := EstaEmAtendimento(vDestinoID);
              vDestinoEstaLogado    := AtendenteLogado(vDestinoID);
              vOrigemAtendenteSenha := TextHash(GetSenhaAtend(vOrigemAtendenteID));
              vDestinoAtendenteNome := '';
              vDestinoAtendenteID   := -1;

              if vDestinoEstaLogado then
              begin
                vDestinoAtendenteNome := NomeAtendente(vDestinoID);
                vDestinoAtendenteID := DMClient(IdUnidade, not CRIAR_SE_NAO_EXISTIR).GetIdAtd(vDestinoAtendenteNome);
              end;

              if not(vOrigemEstaAtendendo or vDestinoEstaAtendendo or vDestinoEstaLogado) then
              begin
                LSituacaoPAAoExibirFormOrigem := GetSituacaoAtualPA(vOrigemID);
                LSituacaoPAAoExibirFormDestino := GetSituacaoAtualPA(vDestinoID);

                ConfirmationMessage
                  (Format('Deseja fazer login do atendente "%s" na PA "%s"?',
                  [vOrigemAtendenteNome, vDestinoNomePA]),
                  procedure(const aOK: Boolean)
                  begin
                    if aOK then
                    begin
                      if ((LSituacaoPAAoExibirFormOrigem = GetSituacaoAtualPA
                        (vOrigemID)) and
                        (LSituacaoPAAoExibirFormDestino = GetSituacaoAtualPA
                        (vDestinoID))) then
                        AlteraPADoUsuarioLogado(vDestinoEstaLogado,
                          vDestinoAtendenteID, vOrigemAtendenteID,
                          vOrigemAtendenteSenha)
                      else
                        ErrorMessage(Format('Situação da PA foi modificada. ' +
                          #13 + 'Situação Anterior: "%s", Senha: %s, Atual: %s. Situação Atual: "%s", Senha: %s, Atual: %s.',
                          [SenhaAtual(vOrigemID), LSituacaoPAAoExibirFormOrigem,
                          GetSituacaoAtualPA(vOrigemID), SenhaAtual(vDestinoID),
                          LSituacaoPAAoExibirFormDestino,
                          GetSituacaoAtualPA(vDestinoID)]));
                    end;
                  end);
              end
              else
              begin
                vOrigemNomePA := NomePA(vOrigemID);

                vMsg := 'Deseja fazer login do atendente "' +
                  vOrigemAtendenteNome + '" na PA "' + vDestinoNomePA +
                  '"?'#13#13'Com isto:';

                if vOrigemEstaAtendendo then
                  vMsg := vMsg + #13'* O atendimento da senha "' + vOrigemSenha
                    + '" na PA "' + vOrigemNomePA + '" será finalizado';

                if vDestinoEstaLogado then
                  vMsg := vMsg + #13'* O atendente "' + vDestinoAtendenteNome +
                    '" será desalocado da PA "' + vDestinoNomePA + '"';

                if vDestinoEstaAtendendo then
                  vMsg := vMsg + #13'* O atendimento da senha "' + vDestinoSenha
                    + '" na PA "' + vDestinoNomePA + '" será finalizado';

                LSituacaoPAAoExibirFormOrigem := GetSituacaoAtualPA(vOrigemID);
                LSituacaoPAAoExibirFormDestino := GetSituacaoAtualPA(vDestinoID);

                ConfirmationMessage(vMsg,
                  procedure(const aOK: Boolean)
                  begin
                    if aOK then
                    begin
                      if ((LSituacaoPAAoExibirFormOrigem = GetSituacaoAtualPA(vOrigemID)) and
                        (LSituacaoPAAoExibirFormDestino = GetSituacaoAtualPA(vDestinoID))) then
                        AlteraPADoUsuarioLogado(vDestinoEstaLogado,
                          vDestinoAtendenteID, vOrigemAtendenteID, vOrigemAtendenteSenha)
                      else
                        ErrorMessage(Format('Situação da PA foi modificada. ' +
                          #13 + 'Situação Anterior: "%s", Senha: %s, Atual: %s. Situação Atual: "%s", Senha: %s, Atual: %s.',
                          [SenhaAtual(vOrigemID), LSituacaoPAAoExibirFormOrigem,
                          GetSituacaoAtualPA(vOrigemID), SenhaAtual(vDestinoID),
                          LSituacaoPAAoExibirFormDestino, GetSituacaoAtualPA(vDestinoID)]));
                    end;
                  end);
              end;
            end;
          end;

        dkSenha:
          begin
            LSituacaoPAAoExibirFormOrigem := GetSituacaoAtualPA(vOrigemID);
            LSituacaoPAAoExibirFormDestino := GetSituacaoAtualPA(vDestinoID);
            vOrigemSenha := SenhaAtual(vOrigemID);
            vDestinoSenha := SenhaAtual(vDestinoID);
            vFila := 0;

            if EstaEmAtendimento(vDestinoID) then
            begin
              FrmSelecaoFila(IdUnidade).PermiteFinalizar := not TAGsObrigatorias(vDestinoID);

              FrmSelecaoFila(IdUnidade).ShowModal(
                procedure(aModalResult: TModalResult)
                begin
                  if (aModalResult = mrOk) then
                  begin
                    if ((LSituacaoPAAoExibirFormOrigem = GetSituacaoAtualPA(vOrigemID)) and
                      (LSituacaoPAAoExibirFormDestino = GetSituacaoAtualPA(vDestinoID))) then
                    begin
                      vFila := FrmSelecaoFila(IdUnidade).IdSelecionado;

                      DMConnection(IdUnidade, not CRIAR_SE_NAO_EXISTIR)
                        .Redirecionar_ForcarChamada(vDestinoID, vFila, StrToInt(vOrigemSenha), IdUnidade);
                    end
                    else
                      ErrorMessage(Format('Situação da PA foi modificada. ' +
                        #13 + 'Situação Anterior: "%s", Senha: %s, Atual: %s. Situação Atual: "%s", Senha: %s, Atual: %s.',
                        [SenhaAtual(vOrigemID), LSituacaoPAAoExibirFormOrigem,
                        GetSituacaoAtualPA(vOrigemID), SenhaAtual(vDestinoID),
                        LSituacaoPAAoExibirFormDestino, GetSituacaoAtualPA(vDestinoID)]));
                  end;
                end);
            end
            else
            begin
              DMConnection(IdUnidade, not CRIAR_SE_NAO_EXISTIR)
                .Redirecionar_ForcarChamada(vDestinoID, vFila, StrToInt(vOrigemSenha), IdUnidade);
            end;
          end;
      end;
    end;
  finally
    fgDragKind := TDragKind.dkNenhum;
    vOrigemID := -1;
    vDestinoID := -1;
    vAccept := False;
  end;
end;

procedure TFrmSicsMultiPA.PADragEnter(Sender: TObject; const Data: TDragObject;
const Point: TPointF);
var
  vLabelOrigem: TLabel;
  vLabelDestino: TLabel;
  LCodPA: Integer;

  function PodeEncerarSenha(const aIDPA: Integer): Boolean;
  begin
    Result := (not((vgParametrosModulo.TAGsObrigatorias) and
      (SenhaAtual(aIDPA) <> '') and TAGsObrigatorias(aIDPA)));
  end;
begin
  if not Assigned(Sender) then
    Exit;

  LCodPA := (Sender as TControl).Tag;

  if not GetPaJaFoiCriada(LCodPA) then
    Exit;

  edtNomeClienteExit(GetedtNomeCliente(LCodPA));
  // MARCOS -- verificar se está certo!!

  vLabelOrigem := TLabel(Data.Source);
  vLabelDestino := TLabel(Sender);
  vOrigemID := 0;
  vDestinoID := 0;

  if Assigned(vLabelOrigem) then
    vOrigemID := vLabelOrigem.Tag;

  if Assigned(vLabelDestino) then
    vDestinoID := vLabelDestino.Tag;

  if (GetLblAtendente(vLabelDestino.Tag) = vLabelDestino) then
    fgDragKind := dkAtendente
  else if (GetLblSenha(vLabelDestino.Tag) = vLabelDestino) then
  begin
    fgDragKind := dkSenha
  end
  else
    fgDragKind := dkNenhum;

  vAccept := (vOrigemID <> vDestinoID) and AtendenteLogado(vOrigemID) and
    PodeEncerarSenha(vOrigemID) and
    (((fgDragKind = dkAtendente)) or ((fgDragKind = dkSenha) and
    AtendenteLogado(vDestinoID) and PodeEncerarSenha(vDestinoID)));
end;

procedure TFrmSicsMultiPA.PADragOver(Sender: TObject; const Data: TDragObject;
const Point: TPointF; var Operation: TDragOperation);
var
  PASource, PADest: Integer;
  PSWD: String; // RAP
begin
  if not Assigned(Sender) then
    Exit;

  PADragEnter(Sender, Data, Point);
  PASource := (Data.Source as TComponent).Tag;
  PADest := (Sender as TComponent).Tag;

  if (vgParametrosModulo.TAGsObrigatorias) then
  begin
    PSWD := SenhaAtual(PASource); // RAP
    if (PSWD <> '') and TAGsObrigatorias(PASource) then // RAP
    begin // RAP
      Operation := TDragOperation.none; // RAP
      Exit; // RAP
    end; // RAP

    PSWD := SenhaAtual(PADest); // RAP
    if (PSWD <> '') and TAGsObrigatorias(PADest) then // RAP
    begin // RAP
      Operation := TDragOperation.none; // RAP
      Exit; // RAP
    end;
  end;

  case fgDragKind of
    dkSenha:
      begin
        if ((PASource <> PADest) and EstaEmAtendimento(PASource) and
          AtendenteLogado(PADest)) then
          Operation := TDragOperation.Move
        else
          Operation := TDragOperation.none;
      end;
    dkAtendente:
      begin
        if ((PASource <> PADest) and AtendenteLogado(PASource) and
          EstaPreenchidoCampo(GetLblNomePA(PASource).Text) and
          EstaPreenchidoCampo(GetLblNomePA(PADest).Text)) then
          Operation := TDragOperation.Move
        else
          Operation := TDragOperation.none;
      end;
  end; { case }
end;

procedure TFrmSicsMultiPA.RecFundoClick(Sender: TObject);
begin
  inherited;
  EscondeEdtNomeCliente(Sender);
end;

procedure TFrmSicsMultiPA.SetModoConexaoAtual(const aIdUnidade: Integer;
const Value: Boolean);
begin
  inherited;
end;

procedure TFrmSicsMultiPA.Timer1Timer(Sender: TObject);
begin
  inherited;
  OrganizaPAs;
end;

procedure TFrmSicsMultiPA.tmrAtualizaFormTimer(Sender: TObject);
var
  i: Integer;
begin
  inherited;
  // BAH adicionado para solucionar o problema dos componentes bagunçados na tela,
  // BAH a cada 5 segundos "atualiza" o form para dar um resize e orgazinar os componentes na tela
  Self.Width := Self.Width + 1;
  Self.Width := Self.Width - 1;
end;

procedure TFrmSicsMultiPA.tmrCursorTimer(Sender: TObject);
begin
  inherited;

  if vAccept then
    Cursor := crDefault
  else
    Cursor := crNoDrop;
end;

procedure TFrmSicsMultiPA.Fechar;
begin
  Application.Terminate;
end;

function TFrmSicsMultiPA.FiltrarPA(const aExecutarResize: Boolean;
const aCodPA: Integer): Boolean;
var
  LComponentesPA: TComponentesPA;
  LExibirPA: Boolean;
begin
  Result := False;

  if InUpdatePA(aCodPA) then
  begin
    BeginChanges(aCodPA);
    Exit;
  end;

  if ((not GetPaJaFoiCriada(aCodPA))) then
    Exit;

  LComponentesPA := FMultiPAComponentes[aCodPA];

  if Assigned(LComponentesPA) then
  begin
    LExibirPA := vgParametrosModulo.JaEstaConfigurado and
      (((not vgParametrosModulo.OcultarPADeslogada) or
      (AtendenteLogado(LComponentesPA.PA))) and
      ((not vgParametrosModulo.OcultarPASemEspera) or
      ((QtdeSenhaEspera(LComponentesPA.PA) > 0) or
      EstaEmAtendimento(LComponentesPA.PA))) and
      ((not vgParametrosModulo.OcultarPASemAtendimento) or
      (EstaEmAtendimento(LComponentesPA.PA))));

    Result := (LComponentesPA.pnl.Visible <> LExibirPA);

    if Result then
      LComponentesPA.pnl.Visible := LExibirPA and (LComponentesPA.Grupo = LCodGrupoPA);
  end;

  if Result and aExecutarResize then
    FormResize(Self);
end;

function TFrmSicsMultiPA.FiltrarPA: Boolean;
var
  i: Integer;
begin
  Result := False;
  if InUpdatePA then
  begin
    BeginChangesForPAInUpdate;
    Exit;
  end;

  for i := 0 to Length(FMultiPAComponentes) - 1 do
  begin
    if FiltrarPA(False, i) then
      Result := True;
  end;

  if Result then
    FormResize(Self);
end;

function TFrmSicsMultiPA.GetBtnEncaminhar(const aCodPA: Integer): TButton;
begin
  Result := nil;
  if GetPaJaFoiCriada(aCodPA) then
    Result := FMultiPAComponentes[aCodPA].BtnEncaminhar;
end;

function TFrmSicsMultiPA.GetBtnEspecifica(const aCodPA: Integer): TButton;
begin
  Result := nil;
  if GetPaJaFoiCriada(aCodPA) then
    Result := FMultiPAComponentes[aCodPA].BtnEspecifica;
end;

function TFrmSicsMultiPA.GetBtnFinalizar(const aCodPA: Integer): TButton;
begin
  Result := nil;
  if GetPaJaFoiCriada(aCodPA) then
    Result := FMultiPAComponentes[aCodPA].BtnFinalizar;
end;

function TFrmSicsMultiPA.GetBtnLogin(const aCodPA: Integer): TButton;
begin
  Result := nil;
  if GetPaJaFoiCriada(aCodPA) then
    Result := FMultiPAComponentes[aCodPA].BtnLogin;
end;

function TFrmSicsMultiPA.GetBtnPausar(const aCodPA: Integer): TButton;
begin
  Result := nil;
  if GetPaJaFoiCriada(aCodPA) then
    Result := FMultiPAComponentes[aCodPA].BtnPausar;
end;

function TFrmSicsMultiPA.GetBtnSeguirAtendimento(const aCodPA: Integer)
  : TButton;
begin
  Result := nil;
  if GetPaJaFoiCriada(aCodPA) then
    Result := FMultiPAComponentes[aCodPA].BtnSeguirAtendimento;
end;

function TFrmSicsMultiPA.GetBtnProcessos(const aCodPA: Integer): TButton;
begin
  Result := nil;
  if GetPaJaFoiCriada(aCodPA) then
    Result := FMultiPAComponentes[aCodPA].BtnProcessos;
end;

function TFrmSicsMultiPA.GetbtnProximo(const aCodPA: Integer): TButton;
begin
  Result := nil;
  if GetPaJaFoiCriada(aCodPA) then
    Result := FMultiPAComponentes[aCodPA].btnProximo;
end;

function TFrmSicsMultiPA.GetBtnRechamar(const aCodPA: Integer): TButton;
begin
  Result := nil;
  if GetPaJaFoiCriada(aCodPA) then
    Result := FMultiPAComponentes[aCodPA].BtnRechamar;
end;

function TFrmSicsMultiPA.GetedtNomeCliente(const aCodPA: Integer): TEdit;
begin
  Result := nil;
  if GetPaJaFoiCriada(aCodPA) then
    Result := FMultiPAComponentes[aCodPA].edtNomeCliente;
end;

function TFrmSicsMultiPA.GetLblAtendente(const aCodPA: Integer): TLabel;
begin
  Result := nil;
  if GetPaJaFoiCriada(aCodPA) then
    Result := FMultiPAComponentes[aCodPA].LblAtendente;
end;

function TFrmSicsMultiPA.GetLblCodAtendente(const aCodPA: Integer): TLabel;
begin
  Result := nil;
  if GetPaJaFoiCriada(aCodPA) then
    Result := FMultiPAComponentes[aCodPA].LblCodAtendente;
end;

function TFrmSicsMultiPA.GetLblDescNomeCliente(const aCodPA: Integer): TLabel;
begin
  Result := nil;
  if GetPaJaFoiCriada(aCodPA) then
    Result := FMultiPAComponentes[aCodPA].LblDescNomeCliente;
end;

function TFrmSicsMultiPA.GetLblDescSenha(const aCodPA: Integer): TLabel;
begin
  Result := nil;
  if GetPaJaFoiCriada(aCodPA) then
    Result := FMultiPAComponentes[aCodPA].LblDescSenha;
end;

function TFrmSicsMultiPA.GetLblEspera(const aCodPA: Integer): TLabel;
begin
  Result := nil;
  if GetPaJaFoiCriada(aCodPA) then
    Result := FMultiPAComponentes[aCodPA].LblEspera;
end;

function TFrmSicsMultiPA.GetLblMotivoPausa(const aCodPA: Integer): TLabel;
begin
  Result := nil;
  if GetPaJaFoiCriada(aCodPA) then
    Result := FMultiPAComponentes[aCodPA].LblMotivoPausa;
end;

function TFrmSicsMultiPA.GetLblNomeCliente(const aCodPA: Integer): TLabel;
begin
  Result := nil;
  if GetPaJaFoiCriada(aCodPA) then
    Result := FMultiPAComponentes[aCodPA].LblNomeCliente;
end;

function TFrmSicsMultiPA.GetLblNomePA(const aCodPA: Integer): TLabel;
begin
  Result := nil;
  if GetPaJaFoiCriada(aCodPA) then
    Result := FMultiPAComponentes[aCodPA].LblNomePA;
end;

function TFrmSicsMultiPA.GetLblObservacao(const aCodPA: Integer): TLabel;
begin
  Result := nil;
  if GetPaJaFoiCriada(aCodPA) then
    Result := FMultiPAComponentes[aCodPA].lblObservacao;
end;

function TFrmSicsMultiPA.GetLblSenha(const aCodPA: Integer): TLabel;
begin
  Result := nil;
  if GetPaJaFoiCriada(aCodPA) then
    Result := FMultiPAComponentes[aCodPA].LblSenha;
end;

function TFrmSicsMultiPA.GetLblSenhaAtendente(const aCodPA: Integer): TLabel;
begin
  Result := nil;
  if (FMultiPAComponentes[aCodPA] <> nil) then
    Result := FMultiPAComponentes[aCodPA].LblSenhaAtendente;
end;

function TFrmSicsMultiPA.GetPNL(const aCodPA: Integer): TPanel;
begin
  Result := nil;
  if GetPaJaFoiCriada(aCodPA) then
    Result := FMultiPAComponentes[aCodPA].pnl;
end;

function TFrmSicsMultiPA.GetpnlTAGs(const aCodPA: Integer): TPanel;
begin
  Result := nil;
  if GetPaJaFoiCriada(aCodPA) then
    Result := FMultiPAComponentes[aCodPA].pnlTAGs;
end;

function TFrmSicsMultiPA.GetRecBotoes(const aCodPA: Integer): TRectangle;
begin
  Result := nil;
  if GetPaJaFoiCriada(aCodPA) then
    Result := FMultiPAComponentes[aCodPA].recBotoes;
end;

function TFrmSicsMultiPA.GetRecCodigoBarras(const aCodPA: Integer): TRectangle;
begin
  Result := nil;
  if GetPaJaFoiCriada(aCodPA) then
    Result := FMultiPAComponentes[aCodPA].recCodBarras;
end;

function TFrmSicsMultiPA.GetRecFundo(const aCodPA: Integer): TRectangle;
begin
  Result := nil;
  if GetPaJaFoiCriada(aCodPA) then
    Result := FMultiPAComponentes[aCodPA].RecFundo;
end;

function TFrmSicsMultiPA.GetRecLogin(const aCodPA: Integer): TRectangle;
begin
  Result := nil;
  if GetPaJaFoiCriada(aCodPA) then
    Result := FMultiPAComponentes[aCodPA].recLogin;
end;

function TFrmSicsMultiPA.GetRecPA(const aCodPA: Integer): TRectangle;
begin
  Result := nil;
  if GetPaJaFoiCriada(aCodPA) then
    Result := FMultiPAComponentes[aCodPA].recPA;
end;

function TFrmSicsMultiPA.GetRecSenha(const aCodPA: Integer): TRectangle;
begin
  Result := nil;
  if GetPaJaFoiCriada(aCodPA) then
    Result := FMultiPAComponentes[aCodPA].recSenha;
end;

function TFrmSicsMultiPA.GetRecTAGs(const aCodPA: Integer): TRectangle;
begin
  Result := nil;
  if GetPaJaFoiCriada(aCodPA) then
    Result := FMultiPAComponentes[aCodPA].RecTAGs;
end;
{ TComponentesPA }

constructor TComponentesPA.Create(AOwner: TComponent);
begin
  inherited;

  pnlTAGs              := nil;
  PA                   := 0;
  btnProximo           := nil;
  BtnRechamar          := nil;
  BtnEspecifica        := nil;
  BtnEncaminhar        := nil;
  BtnFinalizar         := nil;
  BtnProcessos         := nil;
  BtnPausar            := nil;
  BtnSeguirAtendimento := nil;
  BtnLogin             := nil;
  BtnLogout            := nil;
  LblNomeCliente       := nil;
  LblDescNomeCliente   := nil;
  LblSenha             := nil;
  LblDescSenha         := nil;
  LblNomePA            := nil;
  LblAtendente         := nil;
  LblCodAtendente      := nil;
  LblSenhaAtendente    := nil;
  LblEspera            := nil;
  LblMotivoPausa       := nil;
  edtNomeCliente       := nil;
  RecFundo             := nil;
  RecTAGs              := nil;
  recPA                := nil;
  recSenha             := nil;
  recLogin             := nil;
  recBotoes            := nil;
  pnlPA                := nil;
  pnlBotoes            := nil;
  pnlSenha             := nil;
  pnlLogin             := nil;
  recCodBarras         := nil;
end;

procedure TFrmSicsMultiPA.MostraGrupoPA(const ACodGrupoPA: Integer);
var
  LCountMultiComponente: Integer;
begin
  for LCountMultiComponente := 0 to Pred(ComponentCount) do
  begin
    if (Components[LCountMultiComponente] is TComponentesPA) then
      TComponentesPA(Components[LCountMultiComponente]).pnl.Visible :=
        (TComponentesPA(Components[LCountMultiComponente]).Grupo = ACodGrupoPA)
        or (ACodGrupoPA = 0);
  end;

  OrganizaPAs;
end;

end.
