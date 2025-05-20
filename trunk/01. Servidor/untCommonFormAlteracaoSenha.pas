unit untCommonFormAlteracaoSenha;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}
uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  untCommonFormBase, FMX.Objects, FMX.Layouts, AspLayout, FMX.Edit;

type
  TFrmAlteracaoSenha = class(TFrmBase)
    layLogin: TAspLayout;
    edtSenhaAtual: TEdit;
    edtNovaSenha: TEdit;
    btnCancelar: TButton;
    btnOK: TButton;
    edtConfirmacaoSenha: TEdit;
    lblAtendente: TLabel;
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
  private

  public

  var
    SenhaServidor: string;

  end;

var
  FrmAlteracaoSenha: TFrmAlteracaoSenha;

implementation

uses
  untCommonDMClient, ClassLibrary, untCommonDMConnection;

{$R *.fmx}

{ TFrmAlteracaoSenha }

procedure TFrmAlteracaoSenha.btnOKClick(Sender: TObject);
var
  Atual      : string;
  Nova       : string;
  Confirmacao: string;
begin
  inherited;
  Atual       := TextHash(edtSenhaAtual.Text);
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

procedure TFrmAlteracaoSenha.FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  inherited;
  if Key = vkReturn then
  begin
    Key := vkTab;
    KeyDown(Key, KeyChar, Shift);
  end;
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
