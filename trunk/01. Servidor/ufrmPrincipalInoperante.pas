unit ufrmPrincipalInoperante;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  MyDlls_DR,  ClassLibraryVCL,
  Dialogs, StdCtrls, Buttons, Menus, ExtCtrls;

type
  TfrmSicsPrincipalInoperante = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    BitBtn1: TBitBtn;
    MainMenu1: TMainMenu;
    Arquivo1: TMenuItem;
    Sair1: TMenuItem;
    N1: TMenuItem;
    Sobre1: TMenuItem;
    procedure BitBtn1Click(Sender: TObject);
    procedure Sair1Click(Sender: TObject);
    procedure Sobre1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSicsPrincipalInoperante: TfrmSicsPrincipalInoperante;

implementation

uses udmContingencia, sics_m, uFuncoes, sics_94;

{$R *.dfm}

procedure TfrmSicsPrincipalInoperante.BitBtn1Click(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  try
    frmSicsMain.TrayIcon1.visible := False;
    try
      dmSicsContingencia.SincronizarPrincipal;
    except
      frmSicsMain.TrayIcon1.visible := True;
      raise;
    end;
    FreeAndNil(frmSicsPrincipalInoperante);
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmSicsPrincipalInoperante.Sair1Click(Sender: TObject);
begin
  if Application.MessageBox('Deseja fechar o SICS?', 'Confirmação', MB_ICONQUESTION or MB_YESNOCANCEL) = mrYes then
  try
    Close;
  finally
    Halt;
  end;
end;

procedure TfrmSicsPrincipalInoperante.Sobre1Click(Sender: TObject);
begin
  AppMessageBox (VERSAO
{$IFNDEF IS_MOBILE} + #13#13 + GetExeVersion
{$ENDIF IS_MOBILE}, 'S I C S', MB_ICONINFORMATION);
end;

procedure TfrmSicsPrincipalInoperante.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not GetIsService then
    MyLogException(ERegistroDeOperacao.Create('Término do programa.'));

  if GetIsService then
  begin
    //ALTERADO POR: Jefferson Luis de Simone. - DATA: 22/11/2018.
    frmSicsMain.RestauraOuEscondeAplicacaoNaBandeja(false);
    Action := caNone;
    Exit;
  end;
end;

procedure TfrmSicsPrincipalInoperante.FormCreate(Sender: TObject);
begin
  inherited;
  LoadPosition(Sender as TForm);
  Caption := 'SICS Módulo Servidor - CONTINGÊNCIA';
  Application.Title := 'SICS Módulo Servidor - CONTINGÊNCIA';
  //ALTERADO POR: Jefferson Luis de Simone. - DATA: 22/11/2018.
  frmSicsMain.TrayIcon1.Hint := 'SICS Módulo Servidor - CONTINGÊNCIA';

  if vgParametrosModulo.NomeUnidade <> '' then
  begin
    Caption := Caption + ' - ' + vgParametrosModulo.NomeUnidade;
    Application.Title := Application.Title + ' - ' + vgParametrosModulo.NomeUnidade;
    //ALTERADO POR: Jefferson Luis de Simone. - DATA: 22/11/2018.
    frmSicsMain.TrayIcon1.Hint := frmSicsMain.TrayIcon1.Hint + ' - ' + vgParametrosModulo.NomeUnidade;
  end;

  if GetIsService then
    //ALTERADO POR: Jefferson Luis de Simone. - DATA: 22/11/2018.
    frmSicsMain.RestauraOuEscondeAplicacaoNaBandeja(false)
  else
    MyLogException(ERegistroDeOperacao.Create('Início do programa.'));
end;

procedure TfrmSicsPrincipalInoperante.FormDestroy(Sender: TObject);
begin
  SavePosition(Sender as TForm);
  inherited;
end;

end.
