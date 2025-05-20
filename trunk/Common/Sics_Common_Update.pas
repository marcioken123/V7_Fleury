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
    Gerar_Log('Carregou a lista de arquivos dispon�veis no local de publica��o da nova vers�o.');

    while findresult = 0 Do
    begin
      if (SearchRec.Name <> '..') And (SearchRec.Name <> '.') then
      begin
        if (Fileexists(ExtractFilePath(FullApplicationPath)+'\'+SearchRec.Name)) And (Fileexists(Path+SearchRec.Name)) Then
        begin
          if (GetValueOfFile(Path+SearchRec.Name) <> GetValueOfFile(ExtractFilePath(FullApplicationPath)+'\'+SearchRec.Name)) Then
          begin
            Lista_arqs_upt.Add(SearchRec.Name);
            Gerar_Log('Verificou que o arquivo '+SearchRec.Name+' � uma vers�o diferente da atual.');
            Gerar_Log('Adicionou o arquivo '+SearchRec.Name+' � lista de atualiza��o.');
          end;
        end
        else
        if (Fileexists(Path+SearchRec.Name)) Then
        begin
          Lista_arqs_upt.Add(SearchRec.Name);
          Gerar_Log('Verificou que o arquivo '+SearchRec.Name+' � um arquivo novo que n�o existe na vers�o atual, sendo considerado nova vers�o.');
          Gerar_Log('Adicionou o arquivo '+SearchRec.Name+' � lista de atualiza��o.');
        end;
      end;
      Findresult := FindNext(SearchRec);
    end;
    System.SysUtils.FindClose(SearchRec);
    Gerar_Log('Terminou a verifica��o de disponibilidade da nova vers�o.');
  except
    Gerar_Log('Ocorreu um erro durante a verifica��o de uma poss�vel atualiza��o.');
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
  Gerar_Log('Fechamento dos m�dulos e DLLs abertas');
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
        Gerar_Log('Finalizou m�dulo ' + ExtractFileName(FProcessEntry32.szExeFile));
      end;
    end;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
  Gerar_Log('');
  Gerar_Log('Fim do fechamento dos m�dulos e DLLs abertas.');
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
    Gerar_Log('Iniciou busca de DLL para o m�dulo '+nome_exe);
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
        Gerar_Log('Detectou que DLL ' + nome_DLL + ' era dependente do execut�vel '+ExtractFileName(StrPas(ModuleEntry32.szExePath)));
        Break;
      end;

      More := Module32Next(ModuleSnap, ModuleEntry32);
    end;
  finally
    CloseHandle(ModuleSnap);
    Gerar_Log('Terminou busca de DLL para o m�dulo '+nome_exe);
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
  Gerar_Log('Iniciando verifica��o de depend�ncias e m�dulos abertos.');
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
            Gerar_Log('Encontrou DLL '+Lista_arqs_upt.Strings[i]+' em execu��o e incluiu na lista de finaliza��o.');
            Lista_EXE.Add(ExtractFileName(FProcessEntry32.szExeFile));
            Result := True;
          end;
        end
        else
        if FProcessEntry32.szExeFile = Lista_arqs_upt.Strings[i] Then
        begin
          Gerar_Log('Encontrou m�dulo da aplica��o '+Lista_arqs_upt.Strings[i]+' em execu��o e incluiu na lista de finaliza��o.');
          Lista_EXE.Add(ExtractFileName(FProcessEntry32.szExeFile));
          Result := True;
        end;
      end;
    end;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
  Gerar_Log('Fim da verifica��o de depend�ncias e m�dulos abertos');
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
    Gerar_Log('Iniciou a gera��o do script do atualizador alternativo (se ocorrer falha grave, todos os arquivos da atualiza��o ser�o copiados diretamente.)');

    arqscript.Add('REM FAZ C�PIA TOTAL E DIRETA DE TODOS OS ARQUIVOS DA ATUALIZA��O DISPON�VEL NO LOCAL DE UPDATE,');
    arqscript.Add('REM CASO OCORRA UMA FALHA GRAVE QUE IMPE�A A INICIALIZA��O NORMAL DA APLICA��O.');
    arqscript.Add('copy /y "'+IncludeTrailingPathDelimiter(ArqUpDir)+'*.*" "'+ExtractFilePath(FullApplicationPath)+'*.*"');
    Gerar_Log('Copiou todos os arquivos do local de update "'+IncludeTrailingPathDelimiter(ArqUpDir)+'" para a pasta da aplica��o em "'+ExtractFilePath(FullApplicationPath)+'"');
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
      Gerar_Log('In�cio do processo de atualiza��o dos arquivos (Download)');

      if (ArqUpDir = '') then
      begin
        Gerar_Log('Configura��o da atualiza��o autom�tica n�o est� configurada no INI');
        Gerar_Log('--------------------------------------------------------------------------------------------------');
        Exit;
      end;

      Gerar_Log('Local de publica��o das atualiza��es: '+ArqUpDir);
      Gerar_Log('Local atual da aplica��o: '+ ExtractFilePath(FullApplicationPath));

      Lista_EXE         := TStringList.Create;

      try

        if Lista_arqs_upt.count = 0 then
        begin
          Gerar_Log('Nenhuma atualiza��o foi encontrada pelo m�dulo '+ExtractFileName(FullApplicationPath)+'. Provavelmente foi feita anteriormente por outro m�dulo do sistema.');
          Result := True;
          exit;
        end;

        //Verifica se existem m�dulos DLLs ou execut�veis da aplica��o, que estejam abertos antes de atualizar.
        Gerar_Log('--------------------------------------------------------------------------------------------------');
        Gerar_Log('Verifica��o de m�dulos abertos e depend�ncias de DLLs antes de fechar');
        Gerar_Log('');

        if Verifica_dependencias(Lista_arqs_upt, Lista_EXE) Then
        begin
          if Lista_EXE.Count > 1 then
            InformationMessage('O(s) seguinte(s) programa(s) precisa(m) ser fechado(s) antes da atualiza��o:' + #13 + #10 +
            TStringList(NaoMostrarNomesRepetidos(Lista_EXE)).CommaText);

          FinalizaProgs := true;
        end;

        Gerar_Log('');
        Gerar_Log('Fim verifica��o de m�dulos abertos e depend�ncias');
        Gerar_Log('--------------------------------------------------------------------------------------------------');

        if (Lista_arqs_upt.Count > 0) Then
        begin
          For i := Lista_arqs_upt.Count-1 downto 0 Do
          begin
            try
              SetFileAttributes(PChar(FullApplicationPath), FILE_ATTRIBUTE_NORMAL);
              Gerar_Log('Retirou os atributos de prote��o do arquivo '+ExtractFileName(FullApplicationPath)+' localizado na pasta da aplica��o.');
              if fileexists(ExtractFilePath(FullApplicationPath)+'\'+Lista_arqs_upt.Strings[i]) then
              begin
                SetFileAttributes(PChar(ExtractFilePath(FullApplicationPath)+'\'+Lista_arqs_upt.Strings[i]), FILE_ATTRIBUTE_NORMAL);
                Gerar_Log('Retirou os atributos de prote��o do arquivo '+Lista_arqs_upt.Strings[i]+' localizado na pasta da aplica��o.');
              end;
            except
              Gerar_Log('Erro ao retirar os atributos de prote��o do arquivo '+Lista_arqs_upt.Strings[i]+' localizado na pasta da aplica��o.');
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

              Gerar_Log('Ocorreu uma falha de conex�o com o servidor. Processo abortado.');
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

          //Gravar script tempor�rio em formato .BAT que substitui os arquivos atuais pelos arquivos baixados
          Gerar_Log('Gerando script de atualiza��o.');
          arqscript  := TStringList.Create;
          arqrestore := TStringList.Create;
          arqrestore.Add('REM M�DULO RESTAURADOR DE BACKUPS DA APLICA��O PARA RECUPERAR A APLICA��O SE OCORRER FALHA DURANTE O PROCESSO DE UPDATE.');
          try
            if bPrecisaAtualizarEXE then
            begin
              arqscript.Add('REM FAZ NOVO BACKUP DO PROGRAMA ".EXE" SUBSTITUINDO A C�PIA ANTERIOR.');
              arqscript.Add('if exist "'+FullApplicationPath+'.bak" del "'+FullApplicationPath+'.bak"');
              arqscript.Add('if exist "'+FullApplicationPath+'" copy /y "'+FullApplicationPath+'" "'+FullApplicationPath+'.bak"');
              arqrestore.Add('REM ADICIONA INSTRU��O NO SCRIPT DE RESTORE, PARA RESTAURA��O DO M�DULO PRINCIPAL DA APLICA��O.');
              arqrestore.Add('if exist "'+FullApplicationPath+'.bak" del "'+FullApplicationPath+'"');
              arqrestore.Add('if not exist "'+FullApplicationPath+'" copy /y "'+FullApplicationPath+'.bak" "'+FullApplicationPath+'"');
            end;

            arqscript.Add('REM FAZ NOVO BACKUP DOS DEMAIS ARQUIVOS DA APLICA��O SUBSTITUINDO AS C�PIAS ANTERIORES.');
            For i := 0 To Lista_arqs_upt.Count-1 Do
            begin
              arqscript.Add('if exist "'+ExtractFilePath(FullApplicationPath)+Lista_arqs_upt.Strings[i]+'.bak" del "'+ExtractFilePath(FullApplicationPath)+Lista_arqs_upt.Strings[i]+'.bak"');
              arqscript.Add('if exist "' +ExtractFilePath(FullApplicationPath)+Lista_arqs_upt.Strings[i]+'" copy /y "'+ExtractFilePath(FullApplicationPath)+Lista_arqs_upt.Strings[i]+'" "'+ExtractFilePath(FullApplicationPath)+Lista_arqs_upt.Strings[i]+'.bak"');
              arqrestore.Add('REM ADICIONA INSTRU��O NO SCRIPT DE RESTORE, PARA RESTAURA��O DO ARQUIVO DA APLICA��O.');
              arqrestore.Add('if exist "'+ExtractFilePath(FullApplicationPath)+Lista_arqs_upt.Strings[i]+'.bak" del "'+ExtractFilePath(FullApplicationPath)+Lista_arqs_upt.Strings[i]+'"');
              arqrestore.Add('if not exist "'+ExtractFilePath(FullApplicationPath)+Lista_arqs_upt.Strings[i]+'" copy /y "'+ExtractFilePath(FullApplicationPath)+Lista_arqs_upt.Strings[i]+'.bak" "'+ExtractFilePath(FullApplicationPath)+Lista_arqs_upt.Strings[i]+'"');
            end;
            arqscript.Add ('REM TERMINOU DE FAZER O NOVO BACKUP DOS DEMAIS ARQUIVOS DA APLICA��O. ');
            arqrestore.Add('REM TERMINOU DE PREPARAR O SCRIPT RESTAURADOR DE BACKUPS DA APLICA��O.');

            if bPrecisaAtualizarEXE then
            begin
              arqscript.Add('REM QUANDO O ARQUIVO PRINCIPAL .EXE N�O POSSUIR ATUALIZA��O');
              arqscript.Add('REM DISPON�VEL, DEVER� SER CRIADA UMA FALSA ATUALIZA��O');
              arqscript.Add('REM A PARTIR DO ARQUIVO PRINCIPAL .EXE ATUAL. MAIS ADIANTE,');
              arqscript.Add('REM O ARQUIVO ".UPT" SER� NECESS�RIO PARA QUE O EXECUT�VEL');
              arqscript.Add('REM ORIGINAL, SEJA RESTAURADO.');
              arqscript.Add('if not exist "'+FullApplicationPath+'.upt" copy /y "'+FullApplicationPath+'" "'+FullApplicationPath+'.upt"');

              arqscript.Add('REM ROLLBACK - SE A FALSA ATUALIZA��O DO EXECUT�VEL N�O FOR CRIADA POR ALGUM MOTIVO, SER� FEITO O ROLLBACK DA APLICA��O.');
              arqscript.Add('if not exist "'+FullApplicationPath+'.upt" goto INICIO_ROLLBACK' );
            end;

            For i := 0 To Lista_arqs_upt.Count-1 Do
            begin
              arqscript.Add('REM BLOCO QUE DETECTAR� QUANDO O ARQUIVO A SER');
              arqscript.Add('REM ATUALIZADO, FOR FECHADO. SE O ARQUIVO PUDER SER DELETADO,');
              arqscript.Add('REM SIGNIFICAR� QUE O MESMO N�O ESTAR� MAIS CARREGADO OU');
              arqscript.Add('REM EM EXECU��O.');
              arqscript.Add('REM CASO O ARQUIVO A SER ATUALIZADO N�O SEJA FECHADO/DELETADO EM APROXIMADAMENTE 5 seg.,');
              arqscript.Add('REM O LOOPING DETECTOR SER� ABORTADO E SER� FEITO O ROOLBACK DA APLICA��O.');
              arqscript.Add('set i=1');
              arqscript.Add(':Repete'+IntToStr(i));
              arqscript.Add('if exist "'+ExtractFilePath(FullApplicationPath)+Lista_arqs_upt.Strings[i]+'" DEL "'+ExtractFilePath(FullApplicationPath)+Lista_arqs_upt.Strings[i]+'"');
              arqscript.Add('set /a i=%i%+1');
              arqscript.Add('REM ROLLBACK - POR TEMPO');
              arqscript.Add('if /I %i% equ 2500 goto INICIO_ROLLBACK');
              arqscript.Add('if exist "'+ExtractFilePath(FullApplicationPath)+Lista_arqs_upt.Strings[i]+'" goto Repete'+IntToStr(i));

              arqscript.Add('REM AP�S DETECTAR QUE O ARQUIVO EST� FECHADO E TER REMOVIDO O');
              arqscript.Add('REM ORIGINAL, RESTAURA O MESMO A PARTIR DA C�PIA DE ATUALIZA��O');
              arqscript.Add('REM BAIXADA.');
              arqscript.Add('if exist "'+ExtractFilePath(FullApplicationPath)+Lista_arqs_upt.Strings[i]+'.upt" ' + 'move "'+ExtractFilePath(FullApplicationPath)+Lista_arqs_upt.Strings[i]+'.upt" "'+ExtractFilePath(FullApplicationPath)+Lista_arqs_upt.Strings[i]+'"');
              arqscript.Add('REM ');

              arqscript.Add('REM ROLLBACK - SE O ARQUIVO ATUAL N�O FOR ATUALIZADO A PARTIR DE SUA VERS�O ".UPT" POR ALGUM MOTIVO, SER� FEITO O ROLLBACK DA APLICA��O.');
              arqscript.Add('if not exist "'+ExtractFilePath(FullApplicationPath)+Lista_arqs_upt.Strings[i]+'" goto INICIO_ROLLBACK');
            end;


            if bPrecisaAtualizarEXE then
            begin
              arqscript.Add('REM BLOCO QUE DETECTAR� QUANDO O PROGRAMA PRINCIPAL');
              arqscript.Add('REM FOR FECHADO. SE O ARQUIVO PUDER SER DELETADO,');
              arqscript.Add('REM SIGNIFICAR� QUE O MESMO N�O ESTAR� MAIS CARREGADO OU');
              arqscript.Add('REM EM EXECU��O.');
              arqscript.Add('REM CASO O PROGRAMA PRINCIPAL N�O SEJA FECHADO/DELETADO EM APROXIMADAMENTE 5 seg.,');
              arqscript.Add('REM O LOOPING DETECTOR SER� ABORTADO E SER� FEITO O ROOLBACK DA APLICA��O.');
              arqscript.Add('set i=1');
              arqscript.Add(':REP');
              arqscript.Add('if exist "'+FullApplicationPath+'" del "'+FullApplicationPath+'"');
              arqscript.Add('set /a i=%i%+1');
              arqscript.Add('REM ROLLBACK - POR TEMPO');
              arqscript.Add('if /I %i% equ 2500 goto INICIO_ROLLBACK');
              arqscript.Add('if exist "'+FullApplicationPath+'" goto REP');

              arqscript.Add('REM FINALMENTE RESTAURA O PROGRAMA PRINCIPAL A PARTIR DA');
              arqscript.Add('REM VERS�O DE ATUALIZA��O.');
              arqscript.Add('if exist "'+FullApplicationPath+'.upt" move "'+FullApplicationPath+'.upt'+'" "'+FullApplicationPath+'"');
            end;

            arqscript.Add('REM ROLLBACK - SE O EXECUT�VEL PRINCIPAL N�O FOR ATUALIZADO POR ALGUM MOTIVO, SER� FEITO O ROLLBACK DA APLICA��O.');
            arqscript.Add('if not exist "'+FullApplicationPath+'" goto INICIO_ROLLBACK');

            arqscript.Add('REM VAI DIRETO AO PONTO ONDE COME�A A ATUALIZA��O DA APLICA��O.');
            arqscript.Add('goto ATUALIZA��O');

            arqscript.Add('REM ROTINA DE RESTAURA��O (ROLLBACK) DE TODOS OS ARQUIVOS DA APLICA��O, CASO TENHA OCORRIDO ALGUMA FALHA DURANTE A ATUALIZA��O.');
            arqscript.Add('REM CASO O ARQUIVO EXECUT�VEL DA APLICA��O N�O TENHA SIDO RESTAURADO DEVIDO A ALGUMA FALHA, TODOS OS BACKUPS SER�O RESTAURADOS.');
            arqscript.Add('REM RESTAURA O BACKUP DO EXECUT�VEL PRINCIPAL DA APLICA��O.');
            arqscript.Add(':INICIO_ROLLBACK');
            arqscript.Add('if exist "'+FullApplicationPath+'.bak" copy /y "'+FullApplicationPath+'.bak" "'+FullApplicationPath+'"');

            arqscript.Add('REM RESTAURA OS BACKUPS DE TODOS OS ARQUIVOS DA APLICA��O.');
            For i := 0 To Lista_arqs_upt.Count-1 Do
            begin
              arqscript.Add('if exist "'+ExtractFilePath(FullApplicationPath)+Lista_arqs_upt.Strings[i]+'.bak" '+'copy /y "'+ExtractFilePath(FullApplicationPath)+Lista_arqs_upt.Strings[i]+'.bak" "'+ExtractFilePath(FullApplicationPath)+Lista_arqs_upt.Strings[i]+'"');
            end;
            arqscript.Add('REM FIM DA ROTINA DE RESTAURA��O (ROLLBACK).');

            arqscript.Add('ECHO N�o foi poss�vel executar a atualiza��o dos arquivos, porque ocorreu uma falha ao baixar o pacote de atualiza��o.');
            arqscript.Add('REM DEFINE A PASTA DE ORIGEM DA APLICA��O COMO ATUAL, ANTES DE REINICIAR O M�DULO PRINCIPAL.');
            arqscript.Add('Cd "' + ExtractFilePath(FullApplicationPath)+'"');
            arqscript.Add('REM REINICIA O M�DULO PRINCIPAL DA APLICA��O AP�S O ROLLBACK.');
            arqscript.Add('Start ' + ExtractFileName(FullApplicationPath));
            arqscript.Add('EXIT');

            arqscript.Add('REM A ATUALIZA��O COME�A NESTE PONTO.');
            arqscript.Add(':ATUALIZA��O');

            arqscript.Add('REM DEFINE A PASTA DE ORIGEM DA APLICA��O COMO ATUAL, ANTES DE REINICIAR O M�DULO PRINCIPAL.');
            arqscript.Add('Cd "' + ExtractFilePath(FullApplicationPath)+'"');

            arqscript.Add('REM REINICIA O M�DULO PRINCIPAL DA APLICA��O AP�S A ATUALIZA��O E EXLUIR O BAT DE SCRIPT.');
            //arqscript.Add('PAUSE');
            arqscript.Add('del '+ExtractFileName(GetPathArquivoWorking));
            arqscript.Add('Start ' + ExtractFileName(FullApplicationPath));
            arqscript.Add('del '+NomeScriptUpdate);

            arqscript.SaveToFile (ExtractFilePath(FullApplicationPath)+NomeScriptUpdate );
            arqrestore.SaveToFile(ExtractFilePath(FullApplicationPath)+NomeScriptRestore);
          finally
            arqscript.Free;
          end;
          Gerar_Log('Terminou de gerar o script de atualiza��o.');

          Gerar_Log('Chamando o arquivo de script.');
          bExecutouBat := True;
          WinExec(PAnsiChar(AnsiString(ExtractFilePath(FullApplicationPath) + '\' + NomeScriptUpdate)), SW_NORMAL);
          Gerar_Log('Chamou o arquivo de Script para que fosse executado.');

          if FinalizaProgs then
            Finalizar_programas(Lista_EXE);

          Gerar_Log('Fechando a aplica��o para permitir a substitui��o dos arquivos atuais pelos da nova vers�o.');
          FinalizeApplication;

          ShellExecute(0, 'open', PChar(ApplicationPath), nil, nil, SW_SHOWNORMAL);
          Gerar_Log('Fechou a aplica��o para permitir a substitui��o dos arquivos atuais pelos da nova vers�o.');

        end;
      finally
        Lista_EXE.Free;
      end;
      Gerar_Log('Finalizou o processo de atualiza��o.');
      Gerar_Log('--------------------------------------------------------------------------------------------------');
    except
      Gerar_Log('Ocorreu um erro durante o processo de atualiza��o.');
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
  Gerar_Log('Verifica��o de nova vers�o da aplica��o');

  if (ArqUpDir = '') then
  begin
    Gerar_Log('Configura��o da atualiza��o autom�tica n�o est� configurada no INI');
    Gerar_Log('--------------------------------------------------------------------------------------------------');
    Exit;
  end;

  AspUpd_GerarScriptUpdateAlternativo(ArqUpDir);

  Gerar_Log('Local de publica��o das atualiza��es: '+ArqUpDir);
  Result := (Lista_arqs_upt.Count > 0);
  if Result then
  begin
    Gerar_Log('Existe atualiza��o dispon�vel.');
  end
  else
  begin
    Gerar_Log('N�o existe atualiza��o dispon�vel.');
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
      Gerar_Log('Configura��o da atualiza��o autom�tica n�o est� configurada no INI');
      Gerar_Log('--------------------------------------------------------------------------------------------------');
      Exit;
    end;

    if ExisteArquivoWorking then
    begin
      InformationMessage('J� existe uma atualiza��o ocorrendo neste momento ou houve uma falha na �ltima atualiza��o. Favor tentar novamente.' +
        #13 + 'Arquivo: ' + GetPathArquivoWorking);
      FinalizeApplication;
    end;

    Lista_arqs_upt := TStringList.Create;
    try
      Lista_arquivos(Lista_arqs_upt, ArqUpDir,'*.*');
      if ASPUPD_ChecarUpdate(ArqUpDir, Lista_arqs_upt) then
      begin
        ConfirmationMessage('Existe uma atualiza��o dispon�vel. Clique em Ok para aplicar esta atualiza��o agora.',
          procedure(const aConfirmation: Boolean)
          begin
            if aConfirmation and (not ASPUPD_FazerUpdate(ArqUpDir, Lista_arqs_upt)) Then
            begin
              InformationMessage('N�o foi poss�vel atualizar o sistema. Pode ter ocorrido algum problema de conex�o com o servidor de dados. Por favor feche todos os aplicativos e tente novamente. Caso ainda n�o seja poss�vel, por favor entre em contato com o suporte t�cnico.');
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
