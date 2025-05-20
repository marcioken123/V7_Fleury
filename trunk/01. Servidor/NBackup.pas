unit NBackup;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask,
  Buttons, IniFiles, System.UITypes,
  MyDlls_DR,  ClassLibraryVCL,
  ExtCtrls, ShellApi, Sics_94, FileCtrl;

type
  TfrmSicsBackup = class(TForm)
    cbBackupAutomatico: TCheckBox;
    btnOK: TButton;
    btnCancel: TButton;
    btnFazerAgora: TButton;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    grBackupAutomatico: TGroupBox;
    Label1: TLabel;
    edPasta: TEdit;
    btnProcuraPasta: TBitBtn;
    Label2: TLabel;
    Label5: TLabel;
    edDias: TEdit;
    edHorario: TMaskEdit;
    tmrBackup: TTimer;
    edPastaUltimoBackup: TEdit;
    edDataUltimoBackup: TEdit;
    Memo1: TMemo;
    lbFolders: TListBox;
    dlgOpenFolder: TOpenDialog;
    procedure btnProcuraPastaClick(Sender: TObject);
    procedure cbBackupAutomaticoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnFazerAgoraClick(Sender: TObject);
    procedure tmrBackupTimer(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure edDiasChange(Sender: TObject);
    procedure edHorarioExit(Sender: TObject);
  private
    { Private declarations }
    function ExtractName(const Filename: String): String;
  public
    { Public declarations }
    function  FazerBackup: boolean;
    procedure ConfiguraBackup;
  end;

var
  frmSicsBackup: TfrmSicsBackup;

implementation

uses udmContingencia, uFuncoes, UConexaoBD;

{$R *.dfm}

type
  EBackup = class (Exception);

function CopyFolder(DirFonte,DirDest : String) : Boolean;
var
  ShFileOpStruct : TShFileOpStruct;
begin
  Result := False;
  if (DirFonte <> '') and (DirDest <> '') and SysUtils.DirectoryExists(DirFonte) then
  try
    DirFonte := DirFonte+#0;
    DirDest := DirDest+#0;
    FillChar(ShFileOpStruct,Sizeof(TShFileOpStruct),0);
    with ShFileOpStruct do
    begin
      Wnd := Application.Handle;
      wFunc := FO_COPY;
      pFrom := PChar(DirFonte);
      pTo := PChar(DirDest);
      fFlags := FOF_ALLOWUNDO or FOF_SIMPLEPROGRESS or FOF_NOCONFIRMATION;
    end;
    Result := (ShFileOperation(ShFileOpStruct) = 0);
  except
    Result := false;
  end;
end;

function DeleteFolder (Dir : String) : Boolean;
var
  ShFileOpStruct : TShFileOpStruct;
begin
  Result := False;
  if (Dir <> '') and SysUtils.DirectoryExists(Dir) then
  try
    Dir := Dir+#0;
    FillChar(ShFileOpStruct,Sizeof(TShFileOpStruct),0);
    with ShFileOpStruct do
    begin
      Wnd    := Application.Handle;
      wFunc  := FO_DELETE;
      pFrom  := PChar(Dir);
      fFlags := FOF_ALLOWUNDO or FOF_SIMPLEPROGRESS or FOF_NOCONFIRMATION;
    end;
    Result := (ShFileOperation(ShFileOpStruct) = 0);
  except
    Result := false;
  end;
end;

procedure TfrmSicsBackup.btnProcuraPastaClick(Sender: TObject);
var
  chosenDirectory : string;
begin
  chosenDirectory := '';
  if (SelectDirectory('Select a directory', '', chosenDirectory)) then
    edPasta.Text := chosenDirectory;
  //if dlgOpenFolder.Execute then
  //  edPasta.Text := ExtractFilePath(dlgOpenFolder.filename);
end;

procedure TfrmSicsBackup.cbBackupAutomaticoClick(Sender: TObject);
begin
  EnableDisableAllControls(grBackupAutomatico, cbBackupAutomatico.Checked, cbBackupAutomatico);
  btnOK.Enabled := (cbBackupAutomatico.Checked = false) or (edPasta.Text <> '');
end;

procedure TfrmSicsBackup.ConfiguraBackup;
var
  b          : boolean;
  s1, s2, s3 : string;
  IniFile    : TIniFile;
begin
  with frmSicsBackup do
  try
    tmrBackup.Enabled := false;
    b  := cbBackupAutomatico.Checked;
    s1 := edDias.Text;
    s2 := edHorario.Text;
    s3 := edPasta.Text;

    case ShowModal of
      mrCancel : begin
                   cbBackupAutomatico.Checked := b ;
                   edDias.Text                := s1;
                   edHorario.Text             := s2;
                   edPasta.Text               := s3;
                 end;
      mrOk     : begin
                   IniFile := TIniFile.Create(GetIniFileName);
                   with IniFile do
                   try
                     WriteBool   ('Backup', 'Automatico'       , cbBackupAutomatico.Checked );
                     WriteString ('Backup', 'Dias'             , edDias.Text                );
                     WriteString ('Backup', 'Horario'          , edHorario.Text             );
                     WriteString ('Backup', 'Pasta'            , edPasta.Text               );
                   finally
                     FreeAndNil(IniFile);
                     SavePosition(frmSicsBackup);
                   end;
                 end;
    end;
  finally
    tmrBackup.Enabled := true;
  end;
end;

procedure TfrmSicsBackup.edDiasChange(Sender: TObject);
begin
  btnOK.Enabled := false;
  //strtoint (edDias   .Text);
  //strtotime(edHorario.Text);
  btnOK.Enabled := (cbBackupAutomatico.Checked = false) or (edPasta.Text <> '');
end;

procedure TfrmSicsBackup.edHorarioExit(Sender: TObject);
var
  lHr: TDateTime;
begin
  if not TryStrToDateTime(edHorario.Text, lHr) then
  begin
    MessageDlg(edHorario.Text + ' não é um horário válido!', mtInformation, [mbOK], 0);
    edHorario.SetFocus;
    Exit;
  end;
end;

function TfrmSicsBackup.ExtractName(const Filename: String): String;
var
  aExt : String;
  aPos : Integer;
begin
  aExt := ExtractFileExt(Filename);
  Result := ExtractFileName(Filename);
  if aExt <> '' then
  begin
    aPos := Pos(aExt,Result);
    if aPos > 0 then
    begin
      Delete(Result,aPos,Length(aExt));
    end;
  end;
end;

procedure TfrmSicsBackup.btnFazerAgoraClick(Sender: TObject);
begin
  ConfirmationMessage('Fazer backup agora na pasta "' + edPasta.Text + '" ?',
  procedure (const aResult: Boolean)
  begin
    if AResult then
    begin
      if FazerBackup then
        InformationMessage('Backup efetuado.')
      else
        ErrorMessage('Erro ao efetuar backup.');
    end;
  end);
end;

procedure TfrmSicsBackup.tmrBackupTimer(Sender: TObject);
begin
  if cbBackupAutomatico.Checked then
  begin
    if ((edPastaUltimoBackup.Text = '---') or
        ((Time <  StrToTime(edHorario.Text)) and (Date - StrToInt(edDias.Text) + StrToTime(edHorario.Text) > StrToDateTime(edDataUltimoBackup.Text))) or
        ((Time >= StrToTime(edHorario.Text)) and (Date                         + StrToTime(edHorario.Text) > StrToDateTime(edDataUltimoBackup.Text))) ) then
      FazerBackup;
  end;
end;

function TfrmSicsBackup.FazerBackup: boolean;
var
  slIni         : TStringList;
  IniFile       : TIniFile;
  Diretoriobck  : String;
  ArquivoIni    : String;
  Arquivofbk    : String;
begin
//  Result := False;
  try
    tmrBackup.Enabled := False;

    if not FileExists(vgParametrosModulo.PathGBak) then
      raise Exception.Create('GBak não localizado em ' + vgParametrosModulo.PathGBak);

    Diretoriobck := IncludeTrailingPathDelimiter(edPasta.Text);
    try
      if not SysUtils.DirectoryExists(Diretoriobck) then
        if not SysUtils.ForceDirectories(Diretoriobck) then
          raise Exception.Create('Erro ao criar o diretório ' + Diretoriobck);

      // fazendo o backup do Arquivo .ini e do Banco de dados
      ArquivoIni := Diretoriobck + ExtractName(ExtractFileName(Application.ExeName)) + '.ini';
      Arquivofbk := Diretoriobck + ExtractName(ExtractFileName(Application.ExeName)) + '.fbk';

      slIni := TStringList.Create;
      try
        slIni.LoadFromFile(GetIniFileName);
        slIni.SaveToFile(ArquivoIni);
      finally
        FreeAndNil(slIni);
      end;

      ShellExecute(0, 'open', PChar(vgParametrosModulo.PathGBak),
        PChar(Format('-v -t -user SYSDBA -password masterkey "%s" "%s"', [TConexaoBD.Dir, Arquivofbk])), nil, SW_HIDE);

      if GetLastError > 0 then
        raise Exception.Create('Erro ao executar o GBak');

      edDataUltimoBackup .Text := DateTimeToStr(now);
      edPastaUltimoBackup.Text := Diretoriobck;

      IniFile := TIniFile.Create(GetIniFileName);
      try
        IniFile.WriteString ('Backup', 'DataUltimoBackup' , edDataUltimoBackup.Text );
        IniFile.WriteString ('Backup', 'PastaUltimoBackup', edPastaUltimoBackup.Text);
      finally
        FreeAndNil(IniFile);
      end;
    except
      on E: Exception do
      begin
        E.Message := 'Erro ao fazer backup' + #13 + E.Message;
      end;
    end;
    Result := True;
  finally
    tmrBackup.Enabled := False;
  end;
end;

procedure TfrmSicsBackup.FormCreate(Sender: TObject);
var
  IniFile : TIniFile;
begin
  if dmSicsContingencia.TipoFuncionamento = tfContingente then
  begin
    btnOk.Enabled := False;
    btnFazerAgora.Enabled := False;
  end;

  IniFile := TIniFile.Create(GetIniFileName);
  with IniFile do
  try
    cbBackupAutomatico.Checked := ReadBool   ('Backup', 'Automatico'       , false                                     );
    edDias.Text                := ReadString ('Backup', 'Dias'             , '1'                                       );
    edHorario.Text             := ReadString ('Backup', 'Horario'          , '00:00'                                   );
    edPasta.Text               := ReadString ('Backup', 'Pasta'            , 'c:\arquivos de programas\aspect\backups' );
    edDataUltimoBackup.Text    := ReadString ('Backup', 'DataUltimoBackup' , '---'                                     );
    edPastaUltimoBackup.Text   := ReadString ('Backup', 'PastaUltimoBackup', '---'                                     );
  finally
    FreeAndNil(IniFile);
  end;

  LoadPosition(Sender as TForm);
end;

procedure TfrmSicsBackup.FormResize(Sender: TObject);
begin
  ClientHeight := btnCancel.Top  + btnCancel.Height + 5;
  ClientWidth  := btnCancel.Left + btnCancel.Width  + 5;
end;

end.


