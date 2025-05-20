unit untCommonFormAlteracaoSenha;

interface
{$INCLUDE ..\AspDefineDiretivas.inc}
uses
  {$IFNDEF IS_MOBILE}
  Windows, Messages, ScktComp,
  {$ENDIF}
  FMX.Grid, FMX.Controls, FMX.Forms, FMX.Graphics,
  FMX.Dialogs, FMX.StdCtrls, FMX.ExtCtrls, FMX.Types, FMX.Layouts, FMX.ListView.Types,
  FMX.ListView, FMX.ListBox,
  Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors, FMX.Objects, FMX.Edit, FMX.TabControl,


  System.UITypes, System.Types, System.SysUtils, System.Classes, System.Variants, Data.DB, System.Rtti,
  Data.Bind.EngExt, Data.Bind.Components,
  Data.Bind.Grid, Data.Bind.DBScope,
  MyAspFuncoesUteis,
  untCommonFormBase, FMX.Controls.Presentation, FMX.Effects;

type
  TFrmAlteracaoSenha = class(TFrmBase)
    layLogin: TLayout;
    edtSenhaAtual: TEdit;
    edtNovaSenha: TEdit;
    btnCancelar: TButton;
    btnOK: TButton;
    edtConfirmacaoSenha: TEdit;
    lblNumAtend: TLabel;
    lblNumAtendValor: TLabel;
    lbllNomeAtendValor: TLabel;
    lbllNomeAtend: TLabel;
    rectCima: TRectangle;
    rectCampos: TRectangle;
    lytCampos: TLayout;
    lytBotoes: TLayout;
    pnlBottom: TPanel;
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure edtConfirmacaoSenhaKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
  private

  public
    procedure AtualizaDadosAtendente(const pCod: Integer; const pNome: String);
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; Override;

  var
    SenhaServidor: string;

  end;

implementation

uses
  untCommonDMConnection;

{$R *.fmx}
{ %CLASSGROUP 'FMX.Controls.TControl' }

{ TFrmAlteracaoSenha }

procedure TFrmAlteracaoSenha.AtualizaDadosAtendente(const pCod: Integer; const pNome: String);
begin
  lblNumAtendValor.Text := IntToStr(pCod);
  lbllNomeAtendValor.Text := pNome;

  {$IFDEF CompilarPara_CALLCENTER}
  lblNumAtendValor.Text   := EmptyStr;
  lbllNomeAtendValor.Text := EmptyStr;
  lblNumAtend.Text        := EmptyStr;
  lbllNomeAtend.Text      := EmptyStr;
  lblNumAtend.Text    := 'Mesa: ' + IntToStr(pCod);
  lbllNomeAtend.Width := 300;
  lbllNomeAtend.Text  := pNome;
  {$ENDIF CompilarPara_CALLCENTER}
end;

procedure TFrmAlteracaoSenha.btnOKClick(Sender: TObject);
var
  Atual      : string;
  Nova       : string;
  Confirmacao: string;
begin
  inherited;
  Atual     := TextHash(edtSenhaAtual.Text);
  Nova        := TextHash(edtNovaSenha.Text);
  Confirmacao := TextHash(edtConfirmacaoSenha.Text);

  if (Atual <> SenhaServidor) then
  begin
    WarningMessage('Senha atual errada.');
    edtSenhaAtual.SetFocus;
    Abort;
  end
  else if (Nova <> Confirmacao) then
  begin
    WarningMessage('Nova senha não confere.');
    edtNovaSenha.SetFocus;
    Abort;
  end
  else if (Atual = Nova) then
  begin
    WarningMessage('Senha atual igual à nova senha.');
    edtSenhaAtual.SetFocus;
    Abort;
  end;

  SenhaServidor := Nova;
end;

constructor TFrmAlteracaoSenha.Create(AOwner: TComponent);
begin
  inherited;
  SenhaServidor := '';
end;

destructor TFrmAlteracaoSenha.Destroy;
begin

  inherited;
end;

procedure TFrmAlteracaoSenha.edtConfirmacaoSenhaKeyDown(Sender: TObject;
  var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
if(Key = vkTab)then
  begin
    btnOK.SetFocus;
  end;
  inherited;

end;

procedure TFrmAlteracaoSenha.FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkReturn then
  begin
    Key := vkTab;
    KeyDown(Key, KeyChar, Shift);
  end;
  inherited;
end;

procedure TFrmAlteracaoSenha.FormShow(Sender: TObject);
begin
  inherited;
  edtSenhaAtual.Text       := '';
  edtNovaSenha.Text        := '';
  edtConfirmacaoSenha.Text := '';

  edtSenhaAtual.SetFocus;
end;

end.
