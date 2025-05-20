unit untCommonFormLogin;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  {$IFNDEF IS_MOBILE}
  Windows, Messages, ScktComp,
  {$ENDIF}
  FMX.Grid, FMX.Controls, FMX.Forms, FMX.Graphics,
  FMX.Dialogs, FMX.StdCtrls, FMX.ExtCtrls, FMX.Types, FMX.Layouts, FMX.ListView.Types,
  FMX.ListView, FMX.ListBox,
   Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors, FMX.Objects, FMX.Edit,

  System.UITypes, System.Types, System.SysUtils, System.Classes, System.Variants, DB, DBClient, System.Rtti,
  Data.Bind.EngExt, Data.Bind.Components,
  Data.Bind.Grid, Data.Bind.DBScope,
  MyAspFuncoesUteis, untCommonFormBase, FMX.Controls.Presentation,
  System.ImageList, FMX.ImgList,untCommonFormStyleBook,untCommonTEdit,untCommonTCombobox,
  FMX.Effects;

type
  TTipoLogin = (tlOperador, tlGestor);

  TFrmLogin = class(TFrmBase)
    edtAtendente: TEdit;
    edtSenha: TEdit;
    btnCancelar: TButton;
    btnOK: TButton;
    cboPA: TComboBox;
    layLogin: TLayout;
    lytCampos: TLayout;
    rectCampos: TRectangle;
    lytBotoes: TLayout;
    pnlBottom: TPanel;
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure cboPAChange(Sender: TObject);
    procedure lytFundoResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormVirtualKeyboardShown(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormVirtualKeyboardHidden(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
  private
    FTipoLogin: TTipoLogin;
    function GetPA: Integer;
    procedure SetPA(const Value: Integer);
  protected
    {$IFDEF IS_MOBILE}
    procedure SetKeyboradVisivel(const Value: Boolean); Override;
    {$ENDIF IS_MOBILE}
  public
    property PA       : Integer read GetPA write SetPA;
    property TipoLogin: TTipoLogin read FTipoLogin write FTipoLogin;

    procedure AtualizarComboPA;
    function ValidacaoAtivaModoConectado: Boolean; Override;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; Override;
    procedure CarregarParametrosDB; Override;
  end;

function FrmLogin(const aIDUnidade: integer; const aAllowNewInstance: Boolean = False; const aOwner: TComponent = nil): TFrmLogin;

implementation

uses

untCommonDMClient,
untCommonDMConnection, Sics_Common_Parametros;

{$R *.fmx}
{ %CLASSGROUP 'FMX.Controls.TControl' }

{ TFrmLogin }

function FrmLogin(const aIDUnidade: integer; const aAllowNewInstance: Boolean = False; const aOwner: TComponent = nil): TFrmLogin;
begin
  Result := TFrmLogin(TFrmLogin.GetInstancia(aIDUnidade, aAllowNewInstance, aOwner));
end;

procedure TFrmLogin.AtualizarComboPA;
var
  LOldItemIndex: Integer;
begin
  LOldItemIndex := cboPA.ItemIndex;
  try
    cboPA.Items.Clear;

    with DMClient(IdUnidade, not CRIAR_SE_NAO_EXISTIR).cdsPAs do
    begin
      First;
      while not Eof do
      begin
        cboPA.Items.Add(FieldByName('Nome').AsString);
        Next;
      end;
    end;
  finally
    if (cboPA.items.count > LOldItemIndex) then
      cboPA.ItemIndex := LOldItemIndex
    else
      cboPA.ItemIndex := cboPA.items.count -1;
  end;
end;

procedure TFrmLogin.btnOKClick(Sender: TObject);
var
  IdOuLogin, Senha : string;
begin
  IdOuLogin  := edtAtendente.Text;
  Senha      := TextHash(edtSenha.Text);

  edtAtendente.Enabled := False;
  edtSenha.Enabled     := False;
  {$IFDEF CompilarPara_PA}
  PA := vgParametrosModulo.IdPA;
  DMClient(IdUnidade, not CRIAR_SE_NAO_EXISTIR).FCurrentPA := vgParametrosModulo.IdPA;
  {$ENDIF}

  {$IFDEF CompilarPara_CALLCENTER}
  if TipoLogin = tlOperador then
  begin
    DMConnection(IDUnidade, not CRIAR_SE_NAO_EXISTIR)
      .EnviarComando(IntToHex(vgParametrosModulo.IdModulo, 4) +
                     Chr($E0) +
                     edtAtendente.Text + #9 +
                     Senha + #9 +
                     vgParametrosModulo.NumeroMesa.ToString,
                     IDUnidade)
  end
  else if TipoLogin = tlGestor then
  begin
    DMConnection(IDUnidade, not CRIAR_SE_NAO_EXISTIR)
      .EnviarComando(IntToHex(vgParametrosModulo.IdModulo, 4) +
                     Chr($D3) + edtAtendente.Text + #9 +
                     Senha + #9 +
                     vgParametrosModulo.NumeroMesa.ToString,
                     IDUnidade)
  end;

  {$ELSE}
  DMConnection(IDUnidade, not CRIAR_SE_NAO_EXISTIR)
    .VerificarLogin(PA, IdOuLogin, Senha, IdUnidade);
  {$ENDIF}
end;


procedure TFrmLogin.CarregarParametrosDB;
begin
  inherited;
  {$IFDEF CompilarPara_PA_MULTIPA}
  cboPA.Enabled := vgParametrosModulo.ModoTerminalServer;
  {$ELSE}
  cboPA.Enabled := False;
  {$ENDIF}
end;

procedure TFrmLogin.cboPAChange(Sender: TObject);
{$IFDEF CompilarPara_PA}
var
  LDMClient: TdmClient;
{$ENDIF}
begin
  inherited;
  {$IFDEF CompilarPara_PA}
  LDMClient := DMClient(IdUnidade, not CRIAR_SE_NAO_EXISTIR);
  if (cboPA.ItemIndex <> -1) then
  begin
    LDMClient.cdsPAs.RecNo := cboPA.ItemIndex + 1;
    vgParametrosModulo.IdPA := LDMClient.cdsPAsID.AsInteger;
  end;
  {$ENDIF CompilarPara_PA}
end;

constructor TFrmLogin.Create(AOwner: TComponent);
begin
  inherited;
  FTipoLogin := tlOperador;
end;

destructor TFrmLogin.Destroy;
begin

  inherited;
end;

procedure TFrmLogin.FormCreate(Sender: TObject);
{$IFDEF IS_MOBILE}
var
  Altura, Largura, TamanhoFonte: Integer;
{$ENDIF IS_MOBILE}
begin
  inherited;

  {$IFDEF CompilarPara_CALLCENTER}
   btnok.Anchors := [];
   btnCancelar.Anchors := [];
  {$ENDIF}

  {$IFDEF IS_MOBILE}
    Altura := 70;
    Largura := 250;
    TamanhoFonte := 18;
    recCaption.Height := 75;
    self.lblCaption.TextSettings.Font.Size := 42;

    cboPA.Position.Y := 50;
    cboPA.Height := 60;
    edtAtendente.Position.Y := cboPA.Position.Y + 20 + cboPA.Height;
    edtAtendente.Height := 60;
    edtAtendente.Font.Size := 25;
    edtSenha.Position.Y := edtAtendente.Position.Y + 20 + edtAtendente.Height;
    edtSenha.Height := 60;
    edtSenha.Font.Size := 25;
    pnlBottom.Height := 100;

    btnOk.TextSettings.Font.Size := TamanhoFonte;
    btnOk.Height := Altura;
    btnOk.Width := Largura;
    btnOk.Position.Y := 15;
    btnOk.Position.X := 15;

    btnCancelar.TextSettings.Font.Size := TamanhoFonte;
    btnCancelar.Height := Altura;
    btnCancelar.Width := Largura;
    btnCancelar.Position.Y := 15;
    btnCancelar.Position.X := (Screen.Width - btnCancelar.Width - 15);
    rectCampos.Align := TAlignLayout.Top;
    pnlBottom.Align := TAlignLayout.None;
  {$ENDIF IS_MOBILE}
end;

procedure TFrmLogin.FormResize(Sender: TObject);
const
  Scale_OriginalFormClientWidth = 345;
  Scale_OriginalLayoutWidth     = 315;
//var
//  Scale_NewFormClientWidth, Scale_NewLayoutWidth, ScaleFactor : Single;
begin
  inherited;


  {$IFDEF CompilarPara_CALLCENTER}
    exit;
  {$ENDIF}

  if recCaption.Visible then
    layLogin.Position.Y := recCaption.Height + 15
  else
    layLogin.Position.Y := 15;

  //Scale_NewFormClientWidth := ClientWidth;
 // Scale_NewLayoutWidth := Scale_OriginalLayoutWidth * Scale_NewFormClientWidth / Scale_OriginalFormClientWidth;

 // ScaleFactor := Scale_NewLayoutWidth / Scale_OriginalLayoutWidth;

  //layLogin.Scale.X := ScaleFactor;
  //layLogin.Scale.Y := ScaleFactor;

   {$IFNDEF IS_MOBILE}
    {btnOk.Position.Y := 5;
    btnCancelar.Position.Y := 5;
    rectBotoes.Height := 60;
    btnOk.Position.X := ((rectBotoes.Width/2) - btnOk.Width) - 20;
    btnCancelar.Position.X := ((rectBotoes.Width) - btnCancelar.Width - 20);}
    lytBotoes.Align := TAlignLayout.Center;
    pnlBottom.Padding.Bottom  := 15;
  {$ENDIF}
end;

procedure TFrmLogin.FormShow(Sender: TObject);
begin
  inherited;
  {$IFDEF CompilarPara_CALLCENTER}
  cboPa.Items.Clear;
  cboPa.Items.Add('Mesa: ' + vgParametrosModulo.NumeroMesa.ToString);
  cboPa.ItemIndex := 0;

  if TipoLogin = tlGestor then
  begin
    lblCaption.Text := 'Login de Gestor';
    Self.Caption    := lblCaption.Text;
    edtAtendente.TextPrompt := 'Gestor';
  end;
  {$ENDIF}

  edtAtendente.Enabled := True;
  edtSenha.Enabled     := True;
  edtAtendente.Text    := '';
  edtSenha.Text        := '';

  if edtAtendente.CanFocus then
    edtAtendente.SetFocus;
  if (cboPA.Items.Count = 0) then
    AtualizarComboPA;
end;

 
procedure TFrmLogin.FormVirtualKeyboardHidden(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
  inherited;
    pnlBottom.Position.Y := rectCampos.Position.Y + rectCampos.Height;
end;

procedure TFrmLogin.FormVirtualKeyboardShown(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
  inherited;

  pnlBottom.Position.Y := edtSenha.Position.Y + edtSenha.Height + 100;

end;

function TFrmLogin.GetPA: Integer;
var
  LDMClient: TDMClient;
begin
  Result := -1;

  LDMClient := DMClient(IdUnidade, not CRIAR_SE_NAO_EXISTIR);
  if (cboPA.ItemIndex >= 0) and (cboPA.ItemIndex < LDMClient.cdsPAs.RecordCount) then
  begin
    LDMClient.cdsPAs.RecNo := cboPA.ItemIndex + 1;
    Result := LDMClient.cdsPAs.FieldByName('ID').AsInteger;
  end;
end;

procedure TFrmLogin.lytFundoResize(Sender: TObject);
begin
  inherited;

end;

{$IFDEF IS_MOBILE}
procedure TFrmLogin.SetKeyboradVisivel(const Value: Boolean);
begin
  inherited;

end;
{$ENDIF IS_MOBILE}

procedure TFrmLogin.SetPA(const Value: Integer);
var
  LDMClient: TDMClient;
begin
  AtualizarComboPA;
  LDMClient := DMClient(IdUnidade, not CRIAR_SE_NAO_EXISTIR);
  if LDMClient.cdsPAs.Locate('ID', Value, []) then
    cboPA.ItemIndex := cboPA.Items.IndexOf(LDMClient.cdsPAs.FieldByName('Nome').AsString);
end;

function TFrmLogin.ValidacaoAtivaModoConectado: Boolean;
begin
  Result := False;
end;


end.
