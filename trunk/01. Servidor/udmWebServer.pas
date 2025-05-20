unit udmWebServer;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}
uses
  SysUtils, Classes,
  IdCustomHTTPServer, IdHTTPServer, ExtCtrls, HTTPApp, HTTPProd, Forms,
  Dialogs, DB,
  MyDlls_DR,  ClassLibraryVCL,
  IniFiles, SyncObjs, IdContext, IdBaseComponent, IdComponent, IdCustomTCPServer;

type
  TCache = record
    ComboOptionsPAS: string;
  end;

  TThredTeste = class(TThread)
  protected
    procedure Execute; override;
  end;

  TdmSicsWebServer = class(TDataModule)
    IdHTTPServer1: TIdHTTPServer;
    TimerIniciarServer: TTimer;
    ppGlobal: TPageProducer;
    procedure TimerIniciarServerTimer(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
    procedure IdHTTPServer1CommandGet(AThread: TIdContext; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    procedure DataModuleDestroy(Sender: TObject);
  private
    FPathHttpDocs : string;
    FPathTemplates: string;
    FTeste        : String;
    FProcessando  : Boolean;
    FParams       : TStrings;
    FCache: TCache;

    procedure AddHtml(var Html: string; const Texto: string);
    procedure SetHtmlFilePageProducer(const HtmlFile: string; OnHtmlTag: THTMLTagEvent);
    function GetContentText(const HtmlFile: string; OnHtmlTag: THTMLTagEvent): string;
    procedure ReplaceDefaultTags(const Tag: string; var ReplaceText: string);
    function GetParamsDefault: string;

    function ValidarAtd(Login, Senha: string): Integer;
    function GetComboOptionsPAS: string;
    function GetIdPA: Integer;
    function GetNomePA(Id: Integer): string;
    function GetHTMLTableFilas: string;

    function GetParam(const Nome: string): string;

    procedure TratarRequisicao(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo; AThread: TIdContext);
    procedure ProcessarPagina(const Pagina: string; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);

    // pagina Index
    procedure OnHTMLTagPaginaIndex(Sender: TObject; Tag: TTag; const TagString: String; TagParams: TStrings; var ReplaceText: String);
    procedure ProcessarPaginaIndex(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);

    // pagina Login
    procedure OnHTMLTagPaginaLogin(Sender: TObject; Tag: TTag; const TagString: String; TagParams: TStrings; var ReplaceText: String);
    procedure ProcessarPaginaLogin(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);

    // pagina PA
    procedure OnHTMLTagPaginaPA(Sender: TObject; Tag: TTag; const TagString: String; TagParams: TStrings; var ReplaceText: String);
    procedure ProcessarPaginaPA(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);

    // pagina Logout
    procedure ProcessarPaginaLogout(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);

    // pagina Filas
    procedure OnHTMLTagPaginaFila(Sender: TObject; Tag: TTag; const TagString: String; TagParams: TStrings; var ReplaceText: String);
    procedure ProcessarPaginaFila(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);

    // pagina AlteraSenha
    procedure ProcessarPaginaAlteraSenha(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    procedure OnHTMLTagPaginaAlteraSenha(Sender: TObject; Tag: TTag; const TagString: String; TagParams: TStrings; var ReplaceText: String);
    procedure ProcessarPaginaAlteraSenhaOk(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);

    // pagina Ajax
    procedure ProcessarPaginaAjax(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);

  public
    procedure Iniciar(Port: Integer);
  end;

var
  dmSicsWebServer: TdmSicsWebServer;

implementation

uses sics_94, sics_91, sics_m, sics_2, uFuncoes;

{$R *.dfm}

var
  GlobalCriticalSection: TCriticalSection;

const
  SESSION_MINUTES_TIMEOUT = 1;
  NL                      = #13 + #10;

  VALIDACAO_ATD_OK                       = 0;
  VALIDACAO_ATD_LOGIN_NAO_LOCALIZADO     = 1;
  VALIDACAO_ATD_LOGIN_OU_SENHA_INVALIDO  = 2;
  VALIDACAO_ATD_JA_EXISTE_LOGIN_EFETUADO = 3;

procedure TdmSicsWebServer.ProcessarPagina(const Pagina: string; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
var
  sFileName: string;
begin
  AResponseInfo.ContentType := 'text/html';

  sFileName := LowerCase(ExtractFileName(Pagina));

  if (sFileName = '') or (sFileName = 'index.sics') then
    ProcessarPaginaIndex(ARequestInfo, AResponseInfo)
  else
  begin
    if sFileName = 'login.sics' then
      ProcessarPaginaLogin(ARequestInfo, AResponseInfo)
    else if sFileName = 'pa.sics' then
      ProcessarPaginaPA(ARequestInfo, AResponseInfo)
    else if sFileName = 'filas.sics' then
      ProcessarPaginaFila(ARequestInfo, AResponseInfo)
    else if sFileName = 'altera_senha.sics' then
      ProcessarPaginaAlteraSenha(ARequestInfo, AResponseInfo)
    else if sFileName = 'altera_senha_ok.sics' then
      ProcessarPaginaAlteraSenhaOk(ARequestInfo, AResponseInfo)
    else if sFileName = 'logout.sics' then
      ProcessarPaginaLogout(ARequestInfo, AResponseInfo)
    else if sFileName = 'ajax.sics' then
      ProcessarPaginaAjax(ARequestInfo, AResponseInfo);
  end;
end;


procedure TdmSicsWebServer.TratarRequisicao(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo; AThread: TIdContext);
var
  sPath, sExt: string;
begin
  FParams := ARequestInfo.Params;

  sPath := StringReplace(ARequestInfo.Document, '/', '\', [rfReplaceAll]);
  sExt  := LowerCase(ExtractFileExt(sPath));

  FTeste := ARequestInfo.Params.Values['sleep'];

  if ARequestInfo.Params.Values['sleep'] <> '' then
    Sleep(StrToInt(ARequestInfo.Params.Values['sleep']) * 1000);

  if (sPath <> '') and (sPath[1] = '\') then
    Delete(sPath, 1, 1);

  sPath := IncludeTrailingPathDelimiter(FPathHttpDocs) + sPath;

  // ********************************************************************************
  // IdHTTPServer.ServeFile foi retirado de Indy10
  // segundo pesquisa na web deve-se utilizar AResponseInfo.ServeFile
  // ********************************************************************************
  if (sExt = '.jpg') or (sExt = '.gif') then
    AResponseInfo.ServeFile(AThread, sPath)
  else if (sExt = '.css') then
    AResponseInfo.ServeFile(AThread, sPath)
  else if (sExt = '.js') then
    AResponseInfo.ServeFile(AThread, sPath)
  else
    ProcessarPagina(sPath, ARequestInfo, AResponseInfo);
end;

procedure TdmSicsWebServer.OnHTMLTagPaginaIndex(Sender: TObject; Tag: TTag; const TagString: String; TagParams: TStrings; var ReplaceText: String);
begin
  ReplaceDefaultTags(TagString, ReplaceText);
end;

procedure TdmSicsWebServer.ProcessarPaginaIndex(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
begin
  AResponseInfo.ContentText := GetContentText('index.html', OnHTMLTagPaginaIndex);
  AResponseInfo.WriteContent;
end;

procedure TdmSicsWebServer.OnHTMLTagPaginaLogin(Sender: TObject; Tag: TTag; const TagString: String; TagParams: TStrings; var ReplaceText: String);
begin
  ReplaceDefaultTags(TagString, ReplaceText);

  // <#msg> Msg de usuario ou senha invalida
  if TagString = 'msg' then
  begin
    try
      if GetParam('erro_login') <> '' then
      begin
        case StrToInt(GetParam('erro_login')) of
          VALIDACAO_ATD_LOGIN_NAO_LOCALIZADO:
            ReplaceText := 'Login não localizado';
          VALIDACAO_ATD_LOGIN_OU_SENHA_INVALIDO:
            ReplaceText := 'Login ou senha inválido';
          VALIDACAO_ATD_JA_EXISTE_LOGIN_EFETUADO:
            ReplaceText := 'Já existe um atendente logado';
        else
        end;
      end;
    except
      //
    end;
  end;

  // <#pas> Combo de PAS
  if TagString = 'pas' then
  begin
    // senao foi informado o id da PA
    if GetIdPA = 0 then
    begin
      AddHtml(ReplaceText, '<select name="pa">');
      AddHtml(ReplaceText, '<option value="">Selecione a PA</option>');
      AddHtml(ReplaceText, GetComboOptionsPAS);
      AddHtml(ReplaceText, '</select>');
    end
    else
    begin
      AddHtml(ReplaceText, '<span id="nome_pa">' + GetNomePA(GetIdPA) + '<span>');
      AddHtml(ReplaceText, Format('<input type="hidden" name="pa" value="%d"/>', [GetIdPA]));
    end;
  end;
end;

procedure TdmSicsWebServer.ProcessarPaginaLogin(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
var
  iResult    : Integer;
  bAutoRedir : Boolean;
  AtdId, iTmp: Integer;
  sTmp       : string;
  dTmp       : TDateTime;
  StatusPA   : TStatusPA;
  MotivoPausa: Integer;
begin
  // se estiver efetuando login
  if GetParam('login') <> '' then
  begin
    iResult := ValidarAtd(GetParam('login'), GetParam('senha'));
    if iResult = VALIDACAO_ATD_OK then
      AResponseInfo.Redirect('pa.sics?' + GetParamsDefault)
    else
      AResponseInfo.Redirect('login.sics?' + GetParamsDefault + '&erro_login=' + IntToStr(iResult));
  end
  // se estiver abrindo a index
  else
  begin
    bAutoRedir := False;
    if GetParam('pa') <> '' then
    begin
      // se a PA ja estiver logada, vou redirecionar ja pra tela principal
      frmSicsSituacaoAtendimento.GetPASituation(GetIdPA, StatusPA, AtdId, sTmp, iTmp, MotivoPausa, dTmp);
      if AtdId <> -1 then
        bAutoRedir := True;
    end;
    if bAutoRedir then
      AResponseInfo.Redirect('pa.sics?' + GetParamsDefault)
    else
    begin
      AResponseInfo.ContentText := GetContentText('login.html', OnHTMLTagPaginaLogin);
      AResponseInfo.WriteContent;
    end;
  end;
end;

procedure TdmSicsWebServer.OnHTMLTagPaginaPA(Sender: TObject; Tag: TTag; const TagString: String; TagParams: TStrings; var ReplaceText: String);
var
  AtdId, iTmp  : Integer;
  Senha        : string;
  dTmp         : TDateTime;
  sTmp, AtdNome, AtdRegFunc: string;
  AtdAtivo     : Boolean;
  StatusPA     : TStatusPA;
  MotivoPausa  : Integer;
begin
  ReplaceDefaultTags(TagString, ReplaceText);

  if TagString = 'atdnome' then
  begin
    frmSicsSituacaoAtendimento.GetPASituation(GetIdPA, StatusPA, AtdId, sTmp, iTmp, MotivoPausa, dTmp);
    if AtdId <> -1 then
    begin
      NGetAtdData(AtdId, AtdAtivo, iTmp, AtdNome, sTmp, sTmp, AtdRegFunc);
      ReplaceText := AtdNome;
    end;
  end;

  if TagString = 'emespera' then
    ReplaceText := IntToStr(frmSicsMain.GetWaitingTickets(GetIdPA));

  if (TagString = 'senhaatual') or (TagString = 'senhaatualjs') then
  begin
    frmSicsSituacaoAtendimento.GetPASituation(GetIdPA, StatusPA, iTmp, Senha, iTmp, MotivoPausa, dTmp);

    if (TagString = 'senhaatualjs') and (Senha = '---') then
      ReplaceText := 'null'
    else
      ReplaceText := Senha;
  end;
end;

procedure TdmSicsWebServer.ProcessarPaginaPA(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
begin
  AResponseInfo.ContentText := GetContentText('pa.html', OnHTMLTagPaginaPA);
  AResponseInfo.WriteContent;
end;

procedure TdmSicsWebServer.ProcessarPaginaLogout(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
begin
  frmSicsMain.LogoutPA(GetIdPA);
  AResponseInfo.Redirect('login.sics?' + GetParamsDefault);
end;

procedure TdmSicsWebServer.OnHTMLTagPaginaFila(Sender: TObject; Tag: TTag; const TagString: String; TagParams: TStrings; var ReplaceText: String);
begin
  if TagString = 'table' then
  begin
    ReplaceText := GetHTMLTableFilas;
  end;
end;

procedure TdmSicsWebServer.ProcessarPaginaFila(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
begin
  AResponseInfo.ContentText := GetContentText('filas.html', OnHTMLTagPaginaFila);
  AResponseInfo.WriteContent;
end;

procedure TdmSicsWebServer.ProcessarPaginaAlteraSenha(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
var
  iResult                          : Integer;
  AtdId, AtdGrupo, iTmp            : Integer;
  dTmp                             : TDateTime;
  AtdNome, AtdLogin, AtdSenha, AtdRegFunc, sTmp: string;
  AtdAtivo                         : Boolean;
  StatusPA                         : TStatusPA;
  MotivoPausa                      : Integer;
begin
  if GetParam('processar') <> '' then
  begin
    frmSicsSituacaoAtendimento.GetPASituation(GetIdPA, StatusPA, AtdId, sTmp, iTmp, MotivoPausa, dTmp);
    if NGetAtdData(AtdId, AtdAtivo, AtdGrupo, AtdNome, AtdLogin, AtdSenha, AtdRegFunc) then
    begin
      if ((AtdSenha = '') and (GetParam('senha_atual') = '')) or (AtdSenha = CriptLegivel(GetParam('senha_atual'))) then
      begin
        iResult := 1;
        frmSicsMain.AtualizaAtendente(AtdId, True, AtdNome, AtdLogin, CriptLegivel(GetParam('nova_senha')), AtdRegFunc, AtdGrupo);
      end
      else
        iResult := -1;
    end
    else
      iResult := -2;

    if iResult = 1 then
      AResponseInfo.Redirect('altera_senha_ok.sics?' + GetParamsDefault)
    else
      AResponseInfo.Redirect('altera_senha.sics?' + GetParamsDefault + '&erro=' + IntToStr(iResult));
  end
  else
  begin
    AResponseInfo.ContentText := GetContentText('altera_senha.html', OnHTMLTagPaginaAlteraSenha);
    AResponseInfo.WriteContent;
  end;
end;

procedure TdmSicsWebServer.OnHTMLTagPaginaAlteraSenha(Sender: TObject; Tag: TTag; const TagString: String; TagParams: TStrings;
  var ReplaceText: String);
begin
  if TagString = 'pa' then
    ReplaceText := IntToStr(GetIdPA);

  if TagString = 'erro' then
    if GetParam('erro') = '-1' then
      ReplaceText := 'Senha atual não confere'
    else if GetParam('erro') = '-2' then
      ReplaceText := 'Atendente não logado';

end;

procedure TdmSicsWebServer.ProcessarPaginaAlteraSenhaOk(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
begin
  AResponseInfo.ContentText := GetContentText('altera_senha_ok.html', OnHTMLTagPaginaFila);
  AResponseInfo.WriteContent;
end;

procedure TdmSicsWebServer.ProcessarPaginaAjax(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
var
  sOperacao, sResult: string;
  iSenha            : Integer;
  AuxIniTime        : TDateTime;
  IniTime           : TDateTime;
  IdFila            : integer;
  NomeFila          : string;
begin
  sResult := '';

  sOperacao := GetParam('op');

  if sOperacao = 'get_qtde_em_espera' then
  begin
    sResult := '{"qtde":' + IntToStr(frmSicsMain.GetWaitingTickets(GetIdPA)) + '}';
  end
  else
  begin
    if sOperacao = 'proximo' then
      iSenha := frmSicsMain.Proximo(GetIdPA,IniTime)
    else if sOperacao = 'rechama' then
      iSenha := frmSicsMain.Rechama(GetIdPA)
    else if sOperacao = 'chama_especifica' then
      iSenha := frmSicsMain.ChamaEspecifica(GetIdPA, StrToInt(GetParam('senha')), AuxIniTime)
    else if sOperacao = 'forca_chamada' then
      iSenha := frmSicsMain.ForcaChamada(GetIdPA, StrToInt(GetParam('senha')), AuxIniTime, IdFila, NomeFila)
    else if sOperacao = 'redireciona_e_especifica' then
      iSenha := frmSicsMain.RedirecionaEEspecifica(GetIdPA, StrToInt(GetParam('fila')), StrToInt(GetParam('senha')))
    else if sOperacao = 'redireciona_e_forca' then
      iSenha := frmSicsMain.RedirecionaEForca(GetIdPA, StrToInt(GetParam('fila')), StrToInt(GetParam('senha')))
    else if sOperacao = 'finaliza' then
      iSenha := frmSicsMain.Redireciona(GetIdPA, 0)
    else if sOperacao = 'encaminha' then
      iSenha := frmSicsMain.Redireciona(GetIdPA, 0)
    else if sOperacao = 'redireciona' then
      iSenha := frmSicsMain.Redireciona(GetIdPA, StrToInt(GetParam('fila')))
    else if sOperacao = 'redireciona_e_proximo' then
      iSenha := frmSicsMain.RedirecionaEProximo(GetIdPA, StrToInt(GetParam('fila')))
    else
      raise Exception.Create('operacao desconhecida');

    sResult := '{"senha":' + IntToStr(iSenha);
    if GetParam('senha') <> '' then
      sResult := sResult + ', "senha_original":' + GetParam('senha');
    sResult   := sResult + '}';
  end;

  AResponseInfo.ContentText := sResult;
  AResponseInfo.WriteContent;
end;

procedure TdmSicsWebServer.TimerIniciarServerTimer(Sender: TObject);
begin
  IdHTTPServer1.Active       := True;
  TimerIniciarServer.Enabled := False;
end;

procedure TdmSicsWebServer.DataModuleCreate(Sender: TObject);
begin
  GlobalCriticalSection := TCriticalSection.Create;
  FPathHttpDocs  := IncludeTrailingPathDelimiter(ExtractFileDir(ParamStr(0))) + 'web\';
  FPathTemplates := FPathHttpDocs;
  FProcessando   := False;
end;

procedure TdmSicsWebServer.IdHTTPServer1CommandGet(AThread: TIdContext; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
begin

  GlobalCriticalSection.Acquire;
  try

    try
      TratarRequisicao(ARequestInfo, AResponseInfo, AThread);
    finally
    end;

  finally
    GlobalCriticalSection.Release;
  end;
end;

function TdmSicsWebServer.GetIdPA: Integer;
var
  sPA: string;
begin
  Result := 0;

  try
    sPA := GetParam('pa');
    if sPA <> '' then
      Result := StrToInt(sPA)
  except
    //
  end;
end;

function TdmSicsWebServer.GetNomePA(Id: Integer): string;
begin
  Result := '';

  with dmSicsMain.cdsPAs do
    if Locate('ID', Id, []) then
      Result := FieldByName('NOME').AsString;
end;

function TdmSicsWebServer.GetHTMLTableFilas: string;
var
  Book           : TBookmark;
  FilasPermitidas: TIntArray;
  s              : string;
begin
  with TIniFile.Create(GetIniFileName) do
    try
      StrToIntArray(ReadString('WebServer', 'FilasPermitidas', ''), FilasPermitidas);

      IntArrayToStr(FilasPermitidas, s);
      WriteString('WebServer', 'FilasPermitidas', s);
    finally
      Free;
    end;

  Result := '';

  AddHtml(Result, '<table id="FilasEncaminhamento">');
  AddHtml(Result, '  <thead>');
  AddHtml(Result, '    <tr>');
  AddHtml(Result, '      <th class="ColunaID">ID</th>');
  AddHtml(Result, '      <th class="ColunaNome">Nome</th>');
  AddHtml(Result, '    </tr>');
  AddHtml(Result, '  </thead>');
  AddHtml(Result, '  <tbody>');

  with dmSicsMain.cdsFilas do
  begin
    Book := GetBookmark;
    try
      DisableControls;
      try
        First;
        while not Eof do
        begin
          if (FieldByName('Ativo').AsBoolean) and (ExisteNoIntArray(FieldByName('ID').AsInteger, FilasPermitidas)) then
          begin
            AddHtml(Result, '<tr>');
            AddHtml(Result, '  <td class="ColunaID">');
            AddHtml(Result, Format('<a href="javascript:escolher_fila(%d)">%s</a>', [FieldByName('ID').AsInteger, FieldByName('ID').AsString]));
            AddHtml(Result, '  </td>');
            AddHtml(Result, '  <td class="ColunaNome">');
            AddHtml(Result, Format('<a href="javascript:escolher_fila(%d)">%s</a>', [FieldByName('ID').AsInteger, FieldByName('NOME').AsString]));
            AddHtml(Result, '  </td>');
            AddHtml(Result, '</tr>');
          end;
          Next;
        end;
      finally
        EnableControls;
      end;
    finally
      try
        GotoBookmark(Book);
      finally
        FreeBookmark(Book);
      end;
    end;
  end;

  AddHtml(Result, '  </tbody>');
  AddHtml(Result, '</table>');
end;

function TdmSicsWebServer.GetParam(const Nome: string): string;
begin
  Result := FParams.Values[Nome];
end;


function TdmSicsWebServer.ValidarAtd(Login, Senha: string): Integer;
var
  AtdId, AtdId2, iTmp, IdPA: Integer;
  AtdAtivo                 : Boolean;
  sTmp, AtdRegFunc            : string;
  dTmp                     : TDateTime;
  StatusPA                 : TStatusPA;
  MotivoPausa              : Integer;
begin
  IdPA := GetIdPA;
  AtdId := 0;

  with dmSicsMain.cdsAtendentes do
    if not Locate('LOGIN', Login, [loCaseInsensitive]) then
      Result := VALIDACAO_ATD_LOGIN_NAO_LOCALIZADO
    else
    begin
      frmSicsMain.Login(0, IdPA, Login, Senha);

      frmSicsSituacaoAtendimento.GetPASituation(IdPA, StatusPA, AtdId2, sTmp, iTmp, MotivoPausa, dTmp);
      if AtdId2 = -1 then
        Result := VALIDACAO_ATD_LOGIN_OU_SENHA_INVALIDO
      else
      begin
        if AtdId2 <> AtdId then
        begin
          NGetAtdData(AtdId2, AtdAtivo, iTmp, sTmp, sTmp, sTmp, AtdRegFunc);
          Result := VALIDACAO_ATD_JA_EXISTE_LOGIN_EFETUADO;
        end
        else
          Result := VALIDACAO_ATD_OK;
      end;
    end;
end;

procedure TdmSicsWebServer.Iniciar(Port: Integer);
begin
  IdHTTPServer1.DefaultPort := Port;

  // tem que iniciar por um timer, senao fica lento o iniciar da aplicacao
  TimerIniciarServer.Enabled := True;
end;

function TdmSicsWebServer.GetComboOptionsPAS: string;
var
  BM: TBookmark;
begin
  Result := '';

  if FCache.ComboOptionsPAS <> '' then
    Result := FCache.ComboOptionsPAS
  else
  begin
    with dmSicsMain.cdsPAs do
    begin
      BM := GetBookmark;
      try
        DisableControls;
        try
          First;
          while not Eof do
          begin
            if FieldByName('Ativo').AsBoolean then
            begin
              if Result <> '' then
                Result := Result + #13 + #10;
              Result   := Result + Format('<option value="%s">%s</option>', [FieldByName('ID').AsString, FieldByName('NOME').AsString])
            end;
            Next;
          end;
        finally
          EnableControls;
        end;
      finally
        try
          GotoBookmark(BM);
        finally
          FreeBookmark(BM);
        end;
      end;
    end; { with cds }

    FCache.ComboOptionsPAS := Result;
  end;
end;

procedure TdmSicsWebServer.AddHtml(var Html: string; const Texto: string);
begin
  if Html <> '' then
    Html := Html + #13 + #10;
  Html   := Html + Texto;
end;

procedure TdmSicsWebServer.SetHtmlFilePageProducer(const HtmlFile: string; OnHtmlTag: THTMLTagEvent);
begin
  ppGlobal.HtmlFile  := FPathTemplates + HtmlFile;
  ppGlobal.OnHtmlTag := OnHtmlTag;
end;

function TdmSicsWebServer.GetContentText(const HtmlFile: string; OnHtmlTag: THTMLTagEvent): string;
begin
  SetHtmlFilePageProducer(HtmlFile, OnHtmlTag);
  Result := ppGlobal.Content;
end;

procedure TdmSicsWebServer.ReplaceDefaultTags(const Tag: string; var ReplaceText: string);
begin
  if Tag = 'paramsdef' then
    ReplaceText := GetParamsDefault;
  if Tag = 'panome' then
    ReplaceText := GetNomePA(GetIdPA);
end;

function TdmSicsWebServer.GetParamsDefault: string;
begin
  Result := 'pa=' + IntToStr(GetIdPA);
end;

{ TThredTeste }

procedure TThredTeste.Execute;
begin
  inherited;
  frmSicsMain.LogoutPA(1);
end;

procedure TdmSicsWebServer.DataModuleDestroy(Sender: TObject);
begin
  GlobalCriticalSection.Free;
end;

end.
