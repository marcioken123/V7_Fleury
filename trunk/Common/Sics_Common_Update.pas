unit Sics_Common_Update;

interface

uses
  System.SysUtils,
  System.Classes, System.UITypes, FMX.Dialogs;
type
  TInputCloseConfirmationMessage = reference to procedure(const aConfirmation: Boolean);
  {$IFNDEF FIREMONKEY}
  TInputCloseDialogProc = reference to procedure(const AResult: TModalResult);
  {$ENDIF FIREMONKEY}

  function  GetPathArquivoWorking: string;
  procedure GerarArquivoWorking;
  function  Gerar_Log(operacao: string): string;
  function  FullApplicationPath: string;
  function  SettingsPathName: string;
  function  ApplicationPath: string;
  function  GetApplicationPath: string;
  function  Verifica_dependencias(Lista_arqs_upt : TStrings; var Lista_EXE : TStrings): Boolean;
  function  Busca_DLL(ID_exe : Integer; nome_DLL, nome_exe : string): Boolean;
  procedure InformationMessage(AMessage: string);
  procedure CustomMessage(AMessage: string; AType: TMsgDlgType; aCloseDialogProc: TInputCloseDialogProc);
  function  NaoMostrarNomesRepetidos(Lista_EXE : TStrings) : TStrings;
  procedure Finalizar_programas(Lista_EXE : TStrings);
  procedure FinalizeApplication;
  function  AspUpd_GerarScriptUpdateAlternativo(ArqUpDir : string): Boolean;
  function  ExisteArquivoWorking: Boolean;
  function  Lista_arquivos(var Lista_arqs_upt : TStrings; const Path, Mascara : string): integer;
  procedure ConfirmationMessage(const AMessage: string; aCloseDialogProc: TInputCloseConfirmationMessage);
  function  AspUpd_FazerUpdate(ArqUpDir: string; const Lista_arqs_upt: TStrings): Boolean;
  function  AspUpd_ChecarUpdate(ArqUpDir: string; const Lista_arqs_upt: TStrings): Boolean;
  procedure AspUpd_ChecarEFazerUpdate(ArqUpDir: string);



implementation

uses
  Winapi.TlHelp32, Winapi.Windows, Winapi.ShellAPI;

procedure ConfirmationMessage(const AMessage: string; aCloseDialogProc: TInputCloseConfirmationMessage);
begin
  CustomMessage(AMessage, TMsgDlgType.mtConfirmation,
    procedure (const aModalResult: TModalResult)
    begin
      if Assigned(aCloseDialogProc) then
        aCloseDialogProc(aModalResult in [mrOk, mrYes, mrYesToAll, mrContinue, mrAll]);
    end);
end;

function Lista_arquivos(var Lista_arqs_upt : TStrings; const Path, Mascara : string): integer;
var
  Findresult : integer;
  SearchRec  : TSearchRec;

  function GetValueOfFile(const FileName: string): string;
  var
    oStream: TStringStream;
  begin
    Result := '';
    if (FileExists(FileName)) then
    begin
      oStream := TStringStream.Create;
      try
        oStream.LoadFromFile(FileName);
        Result := Trim(oStream.DataString);
      finally
        FreeAndNil(oStream);
      end;
    end;
  end;
begin
  try
    Findresult := FindFirst(Path + Mascara, faNormal, SearchRec);
    Lista_arqs_upt.Clear;
    Gerar_Log('Carregou a lista de arquivos disponíveis no local de publicação da nova versão.');

    while findresult = 0 Do
    begin
      if (SearchRec.Name <> '..') And (SearchRec.Name <> '.') then
      begin
        if (Fileexists(ExtractFilePath(FullApplicationPath)+'\'+SearchRec.Name)) And (Fileexists(Path+SearchRec.Name)) Then
        begin
          if (GetValueOfFile(Path+SearchRec.Name) <> GetValueOfFile(ExtractFilePath(FullApplicationPath)+'\'+SearchRec.Name)) Then
          begin
            Lista_arqs_upt.Add(SearchRec.Name);
            Gerar_Log('Verificou que o arquivo '+SearchRec.Name+' é uma versão diferente da atual.');
            Gerar_Log('Adicionou o arquivo '+SearchRec.Name+' à lista de atualização.');
          end;
        end
        else
        if (Fileexists(Path+SearchRec.Name)) Then
        begin
          Lista_arqs_upt.Add(SearchRec.Name);
          Gerar_Log('Verificou que o arquivo '+SearchRec.Name+' é um arquivo novo que não existe na versão atual, sendo considerado nova versão.');
          Gerar_Log('Adicionou o arquivo '+SearchRec.Name+' à lista de atualização.');
        end;
      end;
      Findresult := FindNext(SearchRec);
    end;
    System.SysUtils.FindClose(SearchRec);
    Gerar_Log('Terminou a verificação de disponibilidade da nova versão.');
  except
    Gerar_Log('Ocorreu um erro durante a verificação de uma possível atualização.');
  end;
  Result := 0;
end;

function ExisteArquivoWorking : Boolean;
begin
  Result := FileExists(GetPathArquivoWorking);
end;

procedure FinalizeApplication;
begin
  {$IFDEF ANDROID}
    MainActivity.finish;
  {$ELSE}
    Halt;
  {$ENDIF}
end;

procedure Finalizar_programas(Lista_EXE : TStrings);
const
  PROCESS_TERMINATE=$0001;
var
  i               : Integer;
  ContinueLoop    : BOOL;
  FSnapshotHandle : THandle;
  FProcessEntry32 : TProcessEntry32;
begin
  Gerar_Log('--------------------------------------------------------------------------------------------------');
  Gerar_Log('Fechamento dos módulos e DLLs abertas');
  Gerar_Log('');
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := Sizeof(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  while integer(ContinueLoop) <> 0 do
  begin
    for i := 0 To Lista_EXE.Count-1 Do
    begin
      if (StrIComp(PChar(ExtractFileName(FProcessEntry32.szExeFile)), PChar(Lista_EXE.Strings[i])) = 0) or (StrIComp(FProcessEntry32.szExeFile, PChar(Lista_EXE.Strings[i])) = 0) Then
      begin
        TerminateProcess(OpenProcess(PROCESS_TERMINATE, BOOL(0), FProcessEntry32.th32ProcessID), 0);
        Gerar_Log('Finalizou módulo ' + ExtractFileName(FProcessEntry32.szExeFile));
      end;
    end;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
  Gerar_Log('');
  Gerar_Log('Fim do fechamento dos módulos e DLLs abertas.');
  Gerar_Log('--------------------------------------------------------------------------------------------------');
end;

function NaoMostrarNomesRepetidos(Lista_EXE : TStrings): TStrings;
var
  i: Integer;
  ListaTemp: TStrings;
begin
  ListaTemp := TStringList.Create;
  ListaTemp.Clear;
  for i := 0 to Lista_EXE.Count-1 do
  begin
    if AnsiStrPos(pchar(ListaTemp.Text), pchar(Lista_EXE.Strings[i])) = nil then
      ListaTemp.Add(Lista_EXE.Strings[i]);
  end;
  Result := ListaTemp;
end;

procedure CustomMessage(AMessage: string; AType: TMsgDlgType;
  aCloseDialogProc: TInputCloseDialogProc);
var
  vButtons     : TMsgDlgButtons;
  {$IFNDEF FIREMONKEY}
  LResult: Integer;
  {$ENDIF FIREMONKEY}
begin
  case AType of
    TMsgDlgType.mtWarning, TMsgDlgType.mtError, TMsgDlgType.mtInformation:
      vButtons := [TMsgDlgBtn.mbOK];

    TMsgDlgType.mtConfirmation:
      vButtons := [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo];
  end;

//  {$IFDEF FIREMONKEY}FMX.Dialogs.{$ELSE}LResult := vcl.Dialogs.{$ENDIF}
//    MessageDlg(AMessage, AType, vButtons, 0{$IFDEF FIREMONKEY}, aCloseDialogProc{$ENDIF FIREMONKEY});

  {$IFNDEF FIREMONKEY}
  if Assigned(aCloseDialogProc) then
    aCloseDialogProc(LResult);
  {$ENDIF FIREMONKEY}
end;

procedure InformationMessage(AMessage: string);
begin
  CustomMessage(AMessage, TMsgDlgType.mtInformation,
    procedure (const AResult: TModalResult)
    begin

    end);
end;

function Busca_DLL(ID_exe : Integer; nome_DLL, nome_exe : string): Boolean;
var
  ModuleSnap    : THandle;
  ModuleEntry32 : TModuleEntry32;
  More          : Boolean;
begin
  ModuleSnap := 0;
  try
    Gerar_Log('Iniciou busca de DLL para o módulo '+nome_exe);
    Result := False;
    ModuleSnap := CreateToolhelp32Snapshot(TH32CS_SNAPMODULE, ID_exe);

    if (ModuleSnap <> 0) And (ModuleSnap < 1) then Exit;

    ModuleEntry32.dwSize := SizeOf(ModuleEntry32);
    More := Module32First(ModuleSnap, ModuleEntry32);
    while More do
    begin

      Result := (ExtractFileName(StrPas(ModuleEntry32.szExePath)) = nome_DLL);
      if (Result) Then
      begin
        Gerar_Log('Detectou que DLL ' + nome_DLL + ' era dependente do executável '+ExtractFileName(StrPas(ModuleEntry32.szExePath)));
        Break;
      end;

      More := Module32Next(ModuleSnap, ModuleEntry32);
    end;
  finally
    CloseHandle(ModuleSnap);
    Gerar_Log('Terminou busca de DLL para o módulo '+nome_exe);
  end;
end;

function Verifica_dependencias(Lista_arqs_upt : TStrings; var Lista_EXE : TStrings): Boolean;
const
  PROCESS_TERMINATE=$0001;
var
  i               : Integer;
  ContinueLoop    : BOOL;
  FSnapshotHandle : THandle;
  FProcessEntry32 : TProcessEntry32;
begin
  Gerar_Log('Iniciando verificação de dependências e módulos abertos.');
  result := False;
  Lista_EXE.Clear;

  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := Sizeof(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  while integer(ContinueLoop) <> 0 do
  begin
    For i := 0 to Lista_arqs_upt.Count - 1 Do
    begin
      if (Length(ExtractFileExt(FProcessEntry32.szExeFile)) <> 0) Then
      begin
        if ExtractFileExt(Lista_arqs_upt.Strings[i]) = '.dll' Then
        begin
          if Busca_DLL(FProcessEntry32.th32ProcessID, Lista_arqs_upt.Strings[i], ExtractFileName(FProcessEntry32.szExeFile)) Then
          begin
            Gerar_Log('Encontrou DLL '+Lista_arqs_upt.Strings[i]+' em execução e incluiu na lista de finalização.');
            Lista_EXE.Add(ExtractFileName(FProcessEntry32.szExeFile));
            Result := True;
          end;
        end
        else
        if FProcessEntry32.szExeFile = Lista_arqs_upt.Strings[i] Then
        begin
          Gerar_Log('Encontrou módulo da aplicação '+Lista_arqs_upt.Strings[i]+' em execução e incluiu na lista de finalização.');
          Lista_EXE.Add(ExtractFileName(FProcessEntry32.szExeFile));
          Result := True;
        end;
      end;
    end;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
  Gerar_Log('Fim da verificação de dependências e módulos abertos');
end;

function GetApplicationPath: string;
begin
  Result := ExcludeTrailingPathDelimiter(ApplicationPath);
end;

function ApplicationPath: string;
begin
  Result := IncludeTrailingPathDelimiter(ExtractFilePath(FullApplicationPath));
end;

function SettingsPathName: string;
begin
  {$IFDEF IS_MOBILE}
  Result := GetDiretorioAsp;
  {$ELSE}
  Result := ApplicationPath;
  {$ENDIF}
end;

function FullApplicationPath: string;
begin
  {$IFDEF ANDROID}
  Result := GetDiretorioAsp + TAndroidHelper.ApplicationTitle + '.apk' //mirrai
  {$ELSE}
    {$IFDEF IOS}
    raise Exception.Create('Full Application Path not Allowed on iOS'); //***IOS
    {$ELSE}
    Result := ParamStr(0);
    {$ENDIF}
  {$ENDIF ANDROID}
end;

function GetPathArquivoWorking : string;
const
  NomeArquivoWorking = 'updating.tmp';
begin
  Result := IncludeTrailingPathDelimiter(ExtractFilePath(FullApplicationPath)) + NomeArquivoWorking;
end;

procedure GerarArquivoWorking;
var
  LStringList: TStringList;
begin
  LStringList := TStringList.Create;
  try
    LStringList.SaveToFile(GetPathArquivoWorking);
  finally
    FreeAndNil(LStringList);
  end;
end;

function Gerar_Log(operacao : string): string;
var
  LogFile : TextFile;
begin
  AssignFile (LogFile, IncludeTrailingPathDelimiter(SettingsPathName) + 'AspUpdate.log');
  if FileExists(IncludeTrailingPathDelimiter(SettingsPathName) + 'AspUpdate.log') Then
    Append(LogFile)
  else
    Rewrite(LogFile);

  try
    Writeln(LogFile, DateToStr(Date)+' - '+TimeToStr(Time)+' - '+operacao);
  finally
    CloseFile(LogFile);
  end;
end;

function AspUpd_GerarScriptUpdateAlternativo(ArqUpDir : String) : Boolean;
var
  arqscript: TStrings;
const
  NomeScriptUpdateAlternativo = 'UpdateManual.bat';
begin
  Result := True;
  arqscript := TStringList.Create;
  try
    arqscript.Clear;
    Gerar_Log('--------------------------------------------------------------------------------------------------');
    Gerar_Log('Iniciou a geração do script do atualizador alternativo (se ocorrer falha grave, todos os arquivos da atualização serão copiados diretamente.)');

    arqscript.Add('REM FAZ CÓPIA TOTAL E DIRETA DE TODOS OS ARQUIVOS DA ATUALIZAÇÃO DISPONÍVEL NO LOCAL DE UPDATE,');
    arqscript.Add('REM CASO OCORRA UMA FALHA GRAVE QUE IMPEÇA A INICIALIZAÇÃO NORMAL DA APLICAÇÃO.');
    arqscript.Add('copy /y "'+IncludeTrailingPathDelimiter(ArqUpDir)+'*.*" "'+ExtractFilePath(FullApplicationPath)+'*.*"');
    Gerar_Log('Copiou todos os arquivos do local de update "'+IncludeTrailingPathDelimiter(ArqUpDir)+'" para a pasta da aplicação em "'+ExtractFilePath(FullApplicationPath)+'"');
    arqscript.SaveToFile(ExtractFilePath(FullApplicationPath)+'\'+ NomeScriptUpdateAlternativo);
    Gerar_Log('Terminou de gerar o script do atualizador alternativo.');
  finally
    arqscript.Free;
  end;
end;

function AspUpd_FazerUpdate(ArqUpDir: string; const Lista_arqs_upt: TStrings): Boolean; export;
var
  i, j                                             : Integer;
  Lista_EXE, arqscript, arqrestore : TStrings;
  FinalizaProgs                                    : Boolean;
  bPrecisaAtualizarEXE                             : Boolean;
  bExecutouBat                                     : Boolean;
const
  NomeScriptUpdate            = 'UpdateTemp.bat'    ;
  NomeScriptRestore           = 'RollbackManual.bat'     ;
  NomeArquivoWorking          = 'updating.tmp'          ;
begin
  if ((Length(ArqUpDir) > 0) and (ArqUpDir[Length(ArqUpDir)] <> '\')) then
    ArqUpDir := ArqUpDir + '\';
  bExecutouBat := False;

  GerarArquivoWorking;
  try
    Result        := false;
    FinalizaProgs := false;
    bPrecisaAtualizarEXE := False;

    try
      Gerar_Log('--------------------------------------------------------------------------------------------------');
      Gerar_Log('Início do processo de atualização dos arquivos (Download)');

      if (ArqUpDir = '') then
      begin
        Gerar_Log('Configuração da atualização automática não está configurada no INI');
        Gerar_Log('--------------------------------------------------------------------------------------------------');
        Exit;
      end;

      Gerar_Log('Local de publicação das atualizações: '+ArqUpDir);
      Gerar_Log('Local atual da aplicação: '+ ExtractFilePath(FullApplicationPath));

      Lista_EXE         := TStringList.Create;

      try

        if Lista_arqs_upt.count = 0 then
        begin
          Gerar_Log('Nenhuma atualização foi encontrada pelo módulo '+ExtractFileName(FullApplicationPath)+'. Provavelmente foi feita anteriormente por outro módulo do sistema.');
          Result := True;
          exit;
        end;

        //Verifica se existem módulos DLLs ou executáveis da aplicação, que estejam abertos antes de atualizar.
        Gerar_Log('--------------------------------------------------------------------------------------------------');
        Gerar_Log('Verificação de módulos abertos e dependências de DLLs antes de fechar');
        Gerar_Log('');

        if Verifica_dependencias(Lista_arqs_upt, Lista_EXE) Then
        begin
          if Lista_EXE.Count > 1 then
            InformationMessage('O(s) seguinte(s) programa(s) precisa(m) ser fechado(s) antes da atualização:' + #13 + #10 +
            TStringList(NaoMostrarNomesRepetidos(Lista_EXE)).CommaText);

          FinalizaProgs := true;
        end;

        Gerar_Log('');
        Gerar_Log('Fim verificação de módulos abertos e dependências');
        Gerar_Log('--------------------------------------------------------------------------------------------------');

        if (Lista_arqs_upt.Count > 0) Then
        begin
          For i := Lista_arqs_upt.Count-1 downto 0 Do
          begin
            try
              SetFileAttributes(PChar(FullApplicationPath), FILE_ATTRIBUTE_NORMAL);
              Gerar_Log('Retirou os atributos de proteção do arquivo '+ExtractFileName(FullApplicationPath)+' localizado na pasta da aplicação.');
              if fileexists(ExtractFilePath(FullApplicationPath)+'\'+Lista_arqs_upt.Strings[i]) then
              begin
                SetFileAttributes(PChar(ExtractFilePath(FullApplicationPath)+'\'+Lista_arqs_upt.Strings[i]), FILE_ATTRIBUTE_NORMAL);
                Gerar_Log('Retirou os atributos de proteção do arquivo '+Lista_arqs_upt.Strings[i]+' localizado na pasta da aplicação.');
              end;
            except
              Gerar_Log('Erro ao retirar os atributos de proteção do arquivo '+Lista_arqs_upt.Strings[i]+' localizado na pasta da aplicação.');
              exit;
            end;

            try
              CopyFile(PChar(ArqUpDir+Lista_arqs_upt.Strings[i]),PChar(ExtractFilePath(FullApplicationPath)+'\'+Lista_arqs_upt.Strings[i]+'.upt'),True);
              Gerar_Log('Baixou o arquivo '+Lista_arqs_upt.Strings[i]+' e gravou como '+Lista_arqs_upt.Strings[i]+'.upt');
            except
              Gerar_Log('Erro ao baixar o arquivo '+Lista_arqs_upt.Strings[i]+' e gravar como '+Lista_arqs_upt.Strings[i]+'.upt');
            end;

            if (not fileexists(ExtractFilePath(FullApplicationPath)+'\'+Lista_arqs_upt.Strings[i]+'.upt')) then
            begin
              For j := 0 To Lista_arqs_upt.Count-1 Do
                Deletefile(PChar(ExtractFilePath(FullApplicationPath)+'\'+Lista_arqs_upt.Strings[j]+'.upt'));

              Gerar_Log('Ocorreu uma falha de conexão com o servidor. Processo abortado.');
              Result := false;
              Exit;
            end;
            if Lista_arqs_upt.Strings[i] = ExtractFileName(FullApplicationPath) then
            begin
              Lista_arqs_upt.Delete(i);
              bPrecisaAtualizarEXE := True;
            end;
          end;

          Result := True;

          //Gravar script temporário em formato .BAT que substitui os arquivos atuais pelos arquivos baixados
          Gerar_Log('Gerando script de atualização.');
          arqscript  := TStringList.Create;
          arqrestore := TStringList.Create;
          arqrestore.Add('REM MÓDULO RESTAURADOR DE BACKUPS DA APLICAÇÃO PARA RECUPERAR A APLICAÇÃO SE OCORRER FALHA DURANTE O PROCESSO DE UPDATE.');
          try
            if bPrecisaAtualizarEXE then
            begin
              arqscript.Add('REM FAZ NOVO BACKUP DO PROGRAMA ".EXE" SUBSTITUINDO A CÓPIA ANTERIOR.');
              arqscript.Add('if exist "'+FullApplicationPath+'.bak" del "'+FullApplicationPath+'.bak"');
              arqscript.Add('if exist "'+FullApplicationPath+'" copy /y "'+FullApplicationPath+'" "'+FullApplicationPath+'.bak"');
              arqrestore.Add('REM ADICIONA INSTRUÇÃO NO SCRIPT DE RESTORE, PARA RESTAURAÇÃO DO MÓDULO PRINCIPAL DA APLICAÇÃO.');
              arqrestore.Add('if exist "'+FullApplicationPath+'.bak" del "'+FullApplicationPath+'"');
              arqrestore.Add('if not exist "'+FullApplicationPath+'" copy /y "'+FullApplicationPath+'.bak" "'+FullApplicationPath+'"');
            end;

            arqscript.Add('REM FAZ NOVO BACKUP DOS DEMAIS ARQUIVOS DA APLICAÇÃO SUBSTITUINDO AS CÓPIAS ANTERIORES.');
            For i := 0 To Lista_arqs_upt.Count-1 Do
            begin
              arqscript.Add('if exist "'+ExtractFilePath(FullApplicationPath)+Lista_arqs_upt.Strings[i]+'.bak" del "'+ExtractFilePath(FullApplicationPath)+Lista_arqs_upt.Strings[i]+'.bak"');
              arqscript.Add('if exist "' +ExtractFilePath(FullApplicationPath)+Lista_arqs_upt.Strings[i]+'" copy /y "'+ExtractFilePath(FullApplicationPath)+Lista_arqs_upt.Strings[i]+'" "'+ExtractFilePath(FullApplicationPath)+Lista_arqs_upt.Strings[i]+'.bak"');
              arqrestore.Add('REM ADICIONA INSTRUÇÃO NO SCRIPT DE RESTORE, PARA RESTAURAÇÃO DO ARQUIVO DA APLICAÇÃO.');
              arqrestore.Add('if exist "'+ExtractFilePath(FullApplicationPath)+Lista_arqs_upt.Strings[i]+'.bak" del "'+ExtractFilePath(FullApplicationPath)+Lista_arqs_upt.Strings[i]+'"');
              arqrestore.Add('if not exist "'+ExtractFilePath(FullApplicationPath)+Lista_arqs_upt.Strings[i]+'" copy /y "'+ExtractFilePath(FullApplicationPath)+Lista_arqs_upt.Strings[i]+'.bak" "'+ExtractFilePath(FullApplicationPath)+Lista_arqs_upt.Strings[i]+'"');
            end;
            arqscript.Add ('REM TERMINOU DE FAZER O NOVO BACKUP DOS DEMAIS ARQUIVOS DA APLICAÇÃO. ');
            arqrestore.Add('REM TERMINOU DE PREPARAR O SCRIPT RESTAURADOR DE BACKUPS DA APLICAÇÃO.');

            if bPrecisaAtualizarEXE then
            begin
              arqscript.Add('REM QUANDO O ARQUIVO PRINCIPAL .EXE NÃO POSSUIR ATUALIZAÇÃO');
              arqscript.Add('REM DISPONÍVEL, DEVERÁ SER CRIADA UMA FALSA ATUALIZAÇÃO');
              arqscript.Add('REM A PARTIR DO ARQUIVO PRINCIPAL .EXE ATUAL. MAIS ADIANTE,');
              arqscript.Add('REM O ARQUIVO ".UPT" SERÁ NECESSÁRIO PARA QUE O EXECUTÁVEL');
              arqscript.Add('REM ORIGINAL, SEJA RESTAURADO.');
              arqscript.Add('if not exist "'+FullApplicationPath+'.upt" copy /y "'+FullApplicationPath+'" "'+FullApplicationPath+'.upt"');

              arqscript.Add('REM ROLLBACK - SE A FALSA ATUALIZAÇÃO DO EXECUTÁVEL NÃO FOR CRIADA POR ALGUM MOTIVO, SERÁ FEITO O ROLLBACK DA APLICAÇÃO.');
              arqscript.Add('if not exist "'+FullApplicationPath+'.upt" goto INICIO_ROLLBACK' );
            end;

            For i := 0 To Lista_arqs_upt.Count-1 Do
            begin
              arqscript.Add('REM BLOCO QUE DETECTARÁ QUANDO O ARQUIVO A SER');
              arqscript.Add('REM ATUALIZADO, FOR FECHADO. SE O ARQUIVO PUDER SER DELETADO,');
              arqscript.Add('REM SIGNIFICARÁ QUE O MESMO NÃO ESTARÁ MAIS CARREGADO OU');
              arqscript.Add('REM EM EXECUÇÃO.');
              arqscript.Add('REM CASO O ARQUIVO A SER ATUALIZADO NÃO SEJA FECHADO/DELETADO EM APROXIMADAMENTE 5 seg.,');
              arqscript.Add('REM O LOOPING DETECTOR SERÁ ABORTADO E SERÁ FEITO O ROOLBACK DA APLICAÇÃO.');
              arqscript.Add('set i=1');
              arqscript.Add(':Repete'+IntToStr(i));
              arqscript.Add('if exist "'+ExtractFilePath(FullApplicationPath)+Lista_arqs_upt.Strings[i]+'" DEL "'+ExtractFilePath(FullApplicationPath)+Lista_arqs_upt.Strings[i]+'"');
              arqscript.Add('set /a i=%i%+1');
              arqscript.Add('REM ROLLBACK - POR TEMPO');
              arqscript.Add('if /I %i% equ 2500 goto INICIO_ROLLBACK');
              arqscript.Add('if exist "'+ExtractFilePath(FullApplicationPath)+Lista_arqs_upt.Strings[i]+'" goto Repete'+IntToStr(i));

              arqscript.Add('REM APÓS DETECTAR QUE O ARQUIVO ESTÁ FECHADO E TER REMOVIDO O');
              arqscript.Add('REM ORIGINAL, RESTAURA O MESMO A PARTIR DA CÓPIA DE ATUALIZAÇÃO');
              arqscript.Add('REM BAIXADA.');
              arqscript.Add('if exist "'+ExtractFilePath(FullApplicationPath)+Lista_arqs_upt.Strings[i]+'.upt" ' + 'move "'+ExtractFilePath(FullApplicationPath)+Lista_arqs_upt.Strings[i]+'.upt" "'+ExtractFilePath(FullApplicationPath)+Lista_arqs_upt.Strings[i]+'"');
              arqscript.Add('REM ');

              arqscript.Add('REM ROLLBACK - SE O ARQUIVO ATUAL NÃO FOR ATUALIZADO A PARTIR DE SUA VERSÃO ".UPT" POR ALGUM MOTIVO, SERÁ FEITO O ROLLBACK DA APLICAÇÃO.');
              arqscript.Add('if not exist "'+ExtractFilePath(FullApplicationPath)+Lista_arqs_upt.Strings[i]+'" goto INICIO_ROLLBACK');
            end;


            if bPrecisaAtualizarEXE then
            begin
              arqscript.Add('REM BLOCO QUE DETECTARÁ QUANDO O PROGRAMA PRINCIPAL');
              arqscript.Add('REM FOR FECHADO. SE O ARQUIVO PUDER SER DELETADO,');
              arqscript.Add('REM SIGNIFICARÁ QUE O MESMO NÃO ESTARÁ MAIS CARREGADO OU');
              arqscript.Add('REM EM EXECUÇÃO.');
              arqscript.Add('REM CASO O PROGRAMA PRINCIPAL NÃO SEJA FECHADO/DELETADO EM APROXIMADAMENTE 5 seg.,');
              arqscript.Add('REM O LOOPING DETECTOR SERÁ ABORTADO E SERÁ FEITO O ROOLBACK DA APLICAÇÃO.');
              arqscript.Add('set i=1');
              arqscript.Add(':REP');
              arqscript.Add('if exist "'+FullApplicationPath+'" del "'+FullApplicationPath+'"');
              arqscript.Add('set /a i=%i%+1');
              arqscript.Add('REM ROLLBACK - POR TEMPO');
              arqscript.Add('if /I %i% equ 2500 goto INICIO_ROLLBACK');
              arqscript.Add('if exist "'+FullApplicationPath+'" goto REP');

              arqscript.Add('REM FINALMENTE RESTAURA O PROGRAMA PRINCIPAL A PARTIR DA');
              arqscript.Add('REM VERSÃO DE ATUALIZAÇÃO.');
              arqscript.Add('if exist "'+FullApplicationPath+'.upt" move "'+FullApplicationPath+'.upt'+'" "'+FullApplicationPath+'"');
            end;

            arqscript.Add('REM ROLLBACK - SE O EXECUTÁVEL PRINCIPAL NÃO FOR ATUALIZADO POR ALGUM MOTIVO, SERÁ FEITO O ROLLBACK DA APLICAÇÃO.');
            arqscript.Add('if not exist "'+FullApplicationPath+'" goto INICIO_ROLLBACK');

            arqscript.Add('REM VAI DIRETO AO PONTO ONDE COMEÇA A ATUALIZAÇÃO DA APLICAÇÃO.');
            arqscript.Add('goto ATUALIZAÇÃO');

            arqscript.Add('REM ROTINA DE RESTAURAÇÃO (ROLLBACK) DE TODOS OS ARQUIVOS DA APLICAÇÃO, CASO TENHA OCORRIDO ALGUMA FALHA DURANTE A ATUALIZAÇÃO.');
            arqscript.Add('REM CASO O ARQUIVO EXECUTÁVEL DA APLICAÇÃO NÃO TENHA SIDO RESTAURADO DEVIDO A ALGUMA FALHA, TODOS OS BACKUPS SERÃO RESTAURADOS.');
            arqscript.Add('REM RESTAURA O BACKUP DO EXECUTÁVEL PRINCIPAL DA APLICAÇÃO.');
            arqscript.Add(':INICIO_ROLLBACK');
            arqscript.Add('if exist "'+FullApplicationPath+'.bak" copy /y "'+FullApplicationPath+'.bak" "'+FullApplicationPath+'"');

            arqscript.Add('REM RESTAURA OS BACKUPS DE TODOS OS ARQUIVOS DA APLICAÇÃO.');
            For i := 0 To Lista_arqs_upt.Count-1 Do
            begin
              arqscript.Add('if exist "'+ExtractFilePath(FullApplicationPath)+Lista_arqs_upt.Strings[i]+'.bak" '+'copy /y "'+ExtractFilePath(FullApplicationPath)+Lista_arqs_upt.Strings[i]+'.bak" "'+ExtractFilePath(FullApplicationPath)+Lista_arqs_upt.Strings[i]+'"');
            end;
            arqscript.Add('REM FIM DA ROTINA DE RESTAURAÇÃO (ROLLBACK).');

            arqscript.Add('ECHO Não foi possível executar a atualização dos arquivos, porque ocorreu uma falha ao baixar o pacote de atualização.');
            arqscript.Add('REM DEFINE A PASTA DE ORIGEM DA APLICAÇÃO COMO ATUAL, ANTES DE REINICIAR O MÓDULO PRINCIPAL.');
            arqscript.Add('Cd "' + ExtractFilePath(FullApplicationPath)+'"');
            arqscript.Add('REM REINICIA O MÓDULO PRINCIPAL DA APLICAÇÃO APÓS O ROLLBACK.');
            arqscript.Add('Start ' + ExtractFileName(FullApplicationPath));
            arqscript.Add('EXIT');

            arqscript.Add('REM A ATUALIZAÇÃO COMEÇA NESTE PONTO.');
            arqscript.Add(':ATUALIZAÇÃO');

            arqscript.Add('REM DEFINE A PASTA DE ORIGEM DA APLICAÇÃO COMO ATUAL, ANTES DE REINICIAR O MÓDULO PRINCIPAL.');
            arqscript.Add('Cd "' + ExtractFilePath(FullApplicationPath)+'"');

            arqscript.Add('REM REINICIA O MÓDULO PRINCIPAL DA APLICAÇÃO APÓS A ATUALIZAÇÃO E EXLUIR O BAT DE SCRIPT.');
            //arqscript.Add('PAUSE');
            arqscript.Add('del '+ExtractFileName(GetPathArquivoWorking));
            arqscript.Add('Start ' + ExtractFileName(FullApplicationPath));
            arqscript.Add('del '+NomeScriptUpdate);

            arqscript.SaveToFile (ExtractFilePath(FullApplicationPath)+NomeScriptUpdate );
            arqrestore.SaveToFile(ExtractFilePath(FullApplicationPath)+NomeScriptRestore);
          finally
            arqscript.Free;
          end;
          Gerar_Log('Terminou de gerar o script de atualização.');

          Gerar_Log('Chamando o arquivo de script.');
          bExecutouBat := True;
          WinExec(PAnsiChar(AnsiString(ExtractFilePath(FullApplicationPath) + '\' + NomeScriptUpdate)), SW_NORMAL);
          Gerar_Log('Chamou o arquivo de Script para que fosse executado.');

          if FinalizaProgs then
            Finalizar_programas(Lista_EXE);

          Gerar_Log('Fechando a aplicação para permitir a substituição dos arquivos atuais pelos da nova versão.');
          FinalizeApplication;

          ShellExecute(0, 'open', PChar(ApplicationPath), nil, nil, SW_SHOWNORMAL);
          Gerar_Log('Fechou a aplicação para permitir a substituição dos arquivos atuais pelos da nova versão.');

        end;
      finally
        Lista_EXE.Free;
      end;
      Gerar_Log('Finalizou o processo de atualização.');
      Gerar_Log('--------------------------------------------------------------------------------------------------');
    except
      Gerar_Log('Ocorreu um erro durante o processo de atualização.');
      Gerar_Log('--------------------------------------------------------------------------------------------------');
      Result := False;
    end;
  except
    if not bExecutouBat then
      DeleteFile(Pchar(GetPathArquivoWorking));
    raise;
  end;
end;

function AspUpd_ChecarUpdate(ArqUpDir: string; const Lista_arqs_upt: TStrings): Boolean; export;
begin
  if ((Length(ArqUpDir) > 0) and (ArqUpDir[Length(ArqUpDir)] <> '\')) then
    ArqUpDir := ArqUpDir + '\';
  Result := false;
  Gerar_Log('--------------------------------------------------------------------------------------------------');
  Gerar_Log('Verificação de nova versão da aplicação');

  if (ArqUpDir = '') then
  begin
    Gerar_Log('Configuração da atualização automática não está configurada no INI');
    Gerar_Log('--------------------------------------------------------------------------------------------------');
    Exit;
  end;

  AspUpd_GerarScriptUpdateAlternativo(ArqUpDir);

  Gerar_Log('Local de publicação das atualizações: '+ArqUpDir);
  Result := (Lista_arqs_upt.Count > 0);
  if Result then
  begin
    Gerar_Log('Existe atualização disponível.');
  end
  else
  begin
    Gerar_Log('Não existe atualização disponível.');
    Gerar_Log('--------------------------------------------------------------------------------------------------');
  end;
end;

procedure AspUpd_ChecarEFazerUpdate(ArqUpDir: string); export;
var
  Lista_arqs_upt: TStrings;
begin
  if ((Length(ArqUpDir) > 0) and (ArqUpDir[Length(ArqUpDir)] <> '\')) then
    ArqUpDir := ArqUpDir + '\';

  try
    if (ArqUpDir = '') then
    begin
      Gerar_Log('Configuração da atualização automática não está configurada no INI');
      Gerar_Log('--------------------------------------------------------------------------------------------------');
      Exit;
    end;

    if ExisteArquivoWorking then
    begin
      InformationMessage('Já existe uma atualização ocorrendo neste momento ou houve uma falha na última atualização. Favor tentar novamente.' +
        #13 + 'Arquivo: ' + GetPathArquivoWorking);
      FinalizeApplication;
    end;

    Lista_arqs_upt := TStringList.Create;
    try
      Lista_arquivos(Lista_arqs_upt, ArqUpDir,'*.*');
      if ASPUPD_ChecarUpdate(ArqUpDir, Lista_arqs_upt) then
      begin
        ConfirmationMessage('Existe uma atualização disponível. Clique em Ok para aplicar esta atualização agora.',
          procedure(const aConfirmation: Boolean)
          begin
            if aConfirmation and (not ASPUPD_FazerUpdate(ArqUpDir, Lista_arqs_upt)) Then
            begin
              InformationMessage('Não foi possível atualizar o sistema. Pode ter ocorrido algum problema de conexão com o servidor de dados. Por favor feche todos os aplicativos e tente novamente. Caso ainda não seja possível, por favor entre em contato com o suporte técnico.');
            end;
          end);
      end;
    finally
      FreeAndNil(Lista_arqs_upt);
    end;
  except
    raise;
  end;
end;


end.
