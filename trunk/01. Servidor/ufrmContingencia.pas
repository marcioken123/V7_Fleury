unit ufrmContingencia;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  MyDlls_DR,  ClassLibraryVCL, ExtCtrls,
  Dialogs, StdCtrls, Menus;

type
  TfrmSicsContingencia = class(TForm)
    Label1: TLabel;
    Button1: TButton;
    Label2: TLabel;
    lblUltimaAtualizacaoRTFile: TLabel;
    btnAtivar: TButton;
    Label3: TLabel;
    lblUltimaAtualizacaoRTId: TLabel;
    MainMenu1: TMainMenu;
    Arquivo1: TMenuItem;
    Sair1: TMenuItem;
    N1: TMenuItem;
    Sobre1: TMenuItem;
    procedure Button1Click(Sender: TObject);
    procedure btnAtivarClick(Sender: TObject);
    procedure Sobre1Click(Sender: TObject);
    procedure Sair1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FForceClose: Boolean;
  public
    procedure AtualizarUltimaDataHoraRTId;
    procedure AtualizarUltimaDataHoraRTFile;
  end;

var
  frmSicsContingencia: TfrmSicsContingencia;

implementation

uses
  udmContingencia, sics_m,
  sics_94, uFuncoes;

{$R *.dfm}

procedure TfrmSicsContingencia.AtualizarUltimaDataHoraRTFile;
begin
  lblUltimaAtualizacaoRTFile.Caption := FormatDateTime('dd/mm/yy hh:nn:ss', Now);
end;

procedure TfrmSicsContingencia.AtualizarUltimaDataHoraRTId;
begin
  lblUltimaAtualizacaoRTId.Caption := FormatDateTime('dd/mm/yy hh:nn:ss', Now);
end;

procedure TfrmSicsContingencia.Button1Click(Sender: TObject);
var
  iRtId: Integer;
begin
  if dmSicsContingencia.AvaliarContingente(iRTId) then
  begin
    ShowMessage('Servidor provavelmente sincronizado');
    btnAtivar.Enabled := True;
  end
  else
    ShowMessage('Servidor desatualizado');
end;

procedure TfrmSicsContingencia.btnAtivarClick(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  try
    //ALTERADO POR: Jefferson Luis de Simone. - DATA: 22/11/2018.
    frmSicsMain.TrayIcon1.visible := False;
    try
      dmSicsContingencia.AtivarContingente;
    except
      //ALTERADO POR: Jefferson Luis de Simone. - DATA: 22/11/2018.
      frmSicsMain.TrayIcon1.visible := True;
      raise;
    end;
    FreeAndNil(frmSicsContingencia);
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmSicsContingencia.Sobre1Click(Sender: TObject);
begin
  InformationMessage(VERSAO
{$IFNDEF IS_MOBILE}+ #13#13 + GetExeVersion
{$ENDIF IS_MOBILE});
end;

procedure TfrmSicsContingencia.Sair1Click(Sender: TObject);
begin
  if Application.MessageBox('Deseja fechar o SICS Contingencia?',
    'Confirmação', MB_ICONQUESTION or MB_YESNOCANCEL) = mrYes then
  try
    Close;
  finally
    Halt;
  end;
end;

procedure TfrmSicsContingencia.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if not GetIsService then
    MyLogException(ERegistroDeOperacao.Create('Término do programa.'));

  if not frmSicsMain.TrayIcon1.visible then
    Action := caFree
  else
    if GetIsService then
    begin
      //ALTERADO POR: Jefferson Luis de Simone. - DATA: 22/11/2018.
      frmSicsMain.RestauraOuEscondeAplicacaoNaBandeja(false);
      Action := caNone;
      Exit;
    end;
end;

procedure TfrmSicsContingencia.FormCreate(Sender: TObject);
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

  FForceClose := False;
  if GetIsService then
    //ALTERADO POR: Jefferson Luis de Simone. - DATA: 22/11/2018.
    frmSicsMain.RestauraOuEscondeAplicacaoNaBandeja(false);
  if not GetIsService then
    MyLogException(ERegistroDeOperacao.Create('Início do programa.'));
end;

procedure TfrmSicsContingencia.FormDestroy(Sender: TObject);
begin
  SavePosition(Sender as TForm);
  inherited;
end;

end.
