unit Sics_Common_AlteraSenha;

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
  
  System.UIConsts, System.Generics.Defaults, System.Generics.Collections,
  System.UITypes, System.Types, System.SysUtils, System.Classes, System.Variants, Data.DB, Datasnap.DBClient, System.Rtti, 
  Data.Bind.EngExt, Data.Bind.Components,
  Data.Bind.Grid, Data.Bind.DBScope, 
  AspFMXHelper, ClassLibrary, MyDlls_DX,  
  IniFiles, Sics_Common_DataModuleClientes;

type
  TfrmSicsCommon_AlteraSenha = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    Panel1: TPanel;
    Label5: TLabel;
    edConfirmaSenha: TEdit;
    Label4: TLabel;
    edNovaSenha: TEdit;
    Label3: TLabel;
    edSenhaAtual: TEdit;
    Label2: TLabel;
    lblAtdNome: TLabel;
    lblAtdId: TLabel;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ObtemNovaSenha (ATD : integer; var NovaSenha : string) : boolean;

implementation

{$R *.fmx}
{ %CLASSGROUP 'FMX.Controls.TControl' }

function ObtemNovaSenha (ATD : integer; var NovaSenha : string) : boolean;
var
  frmSicsCommon_AlteraSenha           : TfrmSicsCommon_AlteraSenha;
  IdGrupoAtend                        : integer;
  AtdNome, AtdRegFuncional, AtdSenha  : string;
  frmDataModuleClientes               : TfrmSicsCommon_DataModuleClientes;
begin
  frmDataModuleClientes := (Application.FindComponent('frmSicsCommon_DataModuleClientes' + inttostr(0)) as TfrmSicsCommon_DataModuleClientes);
  Result := false;

  if not frmDataModuleClientes.GetAtdData (Atd, IdGrupoAtend, AtdNome, AtdRegFuncional, AtdSenha) then
  begin
    Application.MessageBox('Atendente não existe ou está inativo.', 'Atenção', MB_ICONWARNING);
    Exit;
  end;

  frmSicsCommon_AlteraSenha := TfrmSicsCommon_AlteraSenha.Create(Application);
  with frmSicsCommon_AlteraSenha do
    try
      lblAtdId       .Caption := inttostr(ATD) ;
      lblAtdNome     .Caption := AtdNome       ;
      edSenhaAtual   .Text    := ''            ;
      edNovaSenha    .Text    := ''            ;
      edConfirmaSenha.Text    := ''            ;

      if ShowModal = mrOk then
      begin
        if (edSenhaAtual.Text <> AtdSenha) then
          Application.MessageBox('Senha atual errada.', 'Atenção', MB_ICONWARNING)
        else if (edNovaSenha.Text <> edConfirmaSenha.Text) then
          Application.MessageBox('Nova senha não confere.', 'Atenção', MB_ICONWARNING)
        else if (edSenhaAtual.Text = edNovaSenha.Text) then
          Application.MessageBox('Senha atual igual à nova senha.', 'Atenção', MB_ICONWARNING)
        else
        begin
          NovaSenha := edNovaSenha.Text;
          Result := true;
        end;
      end;
    finally
      Free;
    end;
end;


procedure TfrmSicsCommon_AlteraSenha.FormCreate(Sender: TObject);
begin
  LoadPosition (Sender as TForm);
end;


procedure TfrmSicsCommon_AlteraSenha.FormDestroy(Sender: TObject);
begin
  SavePosition (Sender as TForm);
end;

procedure TfrmSicsCommon_AlteraSenha.FormResize(Sender: TObject);
const
  OFF = 5;
begin
  Panel1.Left    := OFF;
  Panel1.Top     := OFF;
  btnOK.Left     := Panel1.Left + Panel1.Width  - btnCancel.Width - btnOK.Width - OFF;
  btnOK.Top      := Panel1.Top  + Panel1.Height + OFF;
  btnCancel.Left := btnOK .Left + btnOK .Width  + OFF;
  btnCancel.Top  := btnOK .Top;

  ClientWidth  := Panel1.Width  + 2*OFF;
  ClientHeight := Panel1.Height + btnOK.Height + 3*OFF;
end;

end.
