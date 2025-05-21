unit AspectVCL;

interface

{$IFDEF CompilarPara_SCC}
  {$INCLUDE ..\..\AspDefineDiretivas.inc}
{$ELSE}
  {$INCLUDE ..\AspDefineDiretivas.inc}
{$ENDIF}


uses
  System.SysUtils, System.Classes, Data.DB, System.Types,
  System.UIConsts, System.UITypes, System.DateUtils, System.Generics.Defaults, System.Generics.Collections,
 
  MyDlls_DR,  MyAspFuncoesUteis_VCL,

  Vcl.Forms, VCL.Grids, Vcl.Controls,
  {$IFDEF SuportaPortaCom}
  VaComm,
  {$ENDIF SuportaPortaCom}
  System.Math, Data.SqlExpr;//, {untAspEncode,}{ AspFuncoesUteis};

const
  ID_UNIDADE_PRINCIPAL = 0;
  ID_UNIDADE_VAZIA = -1;
  CHAR_FALSO = 'F';
type
  TCastControl = Vcl.Controls.TWinControl;
  TCastForm = Vcl.Forms.TForm;
  TCastFrame = Vcl.Forms.TFrame;


  /// <summary>
  ///   Componente que permite ser notificado quando um parent é destruido.
  /// </summary>
  TComponentFreeNotify = class(TComponent{$IFDEF FIREMONKEY}, IFreeNotification, IFreeNotificationBehavior{$ENDIF FIREMONKEY})
  public
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure FreeNotification(AObject: TObject); Reintroduce; Overload; Virtual;
    procedure FreeNotification(AObject: TComponent); Overload; Virtual;

  end;

  TListaControl = TList<TCastControl>;


function GetDescProtoculo(const aProtocolo: Integer): String;

procedure ValidaAppMultiInstancia;
function valorPorExtenso(vlr: real): string;
function RemovePrefixoCor(const aCorExtensa: String): String;
function StrAlphaToColor(const aCorExtensa: String): TAlphaColor;

function GetApplication: Vcl.Forms.TApplication;
function ExtractStr(var aStr: String; const aIndex, aCount: Integer): string;
function SettingsFileNamePosition: String;


var
  TentativaLogException : integer;

implementation

uses untLog,
  {$IFNDEF IS_MOBILE}
  Winapi.PsAPI,
  Winapi.Windows, Winapi.ShellAPI, Winapi.TlHelp32,
  {$ENDIF IS_MOBILE}System.IniFiles;


function GetApplication: Vcl.Forms.TApplication;
begin
  Result := Vcl.Forms.Application;
end;

function ExtractStr(var aStr: String; const aIndex, aCount: Integer): string;
begin
  Result := Copy(aStr, 2, 4);
  Delete(aStr, 2, 4);
end;

{ TComponentFreeNotify }

procedure TComponentFreeNotify.FreeNotification(AObject: TObject);
begin
  if (Assigned(AObject) and (AObject is TComponent)) then
    Notification(TCOmponent(AObject), opRemove);
end;

procedure TComponentFreeNotify.FreeNotification(AObject: TComponent);
begin
  inherited FreeNotification(AObject);
end;

procedure TComponentFreeNotify.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
end;


function GetDescProtoculo(const aProtocolo: Integer): String;
begin
  case aProtocolo of
    $20: Result := 'Chamar proxima senha';
    $21: Result := 'Chamar senha especifica';
    $22: Result := 'Rechamar ultima senha';
    $23: Result := 'RE: Chamou senha especifica';
    $24: Result := 'RE: Nao chamou nenhuma senha';
    $25: Result := 'Finalizar atendimento';
    $26: Result := 'RE: Prioridades de atendimento redefinidas. Faça Refresh.';
    $27: Result := 'Solicitar mensagem institucional (paineis)';
    $28: Result := 'Solicitar início ou término de pausa';
    $29: Result := 'Solicitar situacao do atendimento por PAs';
    $2A: Result := 'Solicitar lista dos status das PAs';
    $2B: Result := 'RE: Mensagem institucional (paineis)';
    $2C: Result := 'RE: Mensagem dos bilhetes (rodape impressora de senha)';
    $2D: Result := 'RE: Lista dos status das PAs';
    $2E: Result := 'Redirecionar senha atendida para outra fila (pela PA que está atendendo)';
    $2F: Result := 'Redirecionar senha atendida para outra fila (pela PA que está atendendo) e chamar próximo cliente';
    $30: Result := 'Chamar senha especifica, esteja ela em qualquer fila ou em nenhuma (forcar chamada)';
    $31: Result := 'Redirecionar senha atendida para outra fila (pela PA que está atendendo) e chamar senha especifica, se estiver dentro das prioridades do ADR';
    $32: Result := 'Redirecionar senha atendida para outra fila (pela PA que está atendendo) e chamar senha especifica, esteja ela em qualquer fila ou em nenhuma (forcar chamada)';
    $33: Result := 'RE: Comando nao suportado pela versao';
    $34: Result := 'Solicitar situacao de filas';
    $35: Result := 'RE: Situacao das filas';
    $36: Result := 'Solicitar numero de pessoas em espera, de acordo com as prioridades das PAs';
//    $37 ='';
    $38: Result := 'Chamar proxima senha + Horario de retirada da senha';
    $39: Result := 'RE: Senha chamada + Horario de retirada da senha';
//    $3A ='';
    $3B: Result := 'RE: Numero de senhas em espera, por PA';
    $3C: Result := 'RE: Situacao do atendimento, por PAs';
    $3D: Result := 'Solicitar nomes das PAs';
    $3E: Result := 'RE: Nomes das PAs';
    $3F: Result := 'Solicitar tabela de PPs';
    $40: Result := 'RE: Tabela de PPs';
    $41: Result := 'Solicitar tabela de Motivos de Pausa';
    $42: Result := 'RE: Tabela de Motivos de Pausa';
    $50: Result := 'RE: Nao chamou nenhuma senha - SENHA NAO SE ENCONTRA EM NENHUMA FILA';
    $51: Result := 'RE: Nao chamou nenhuma senha - SENHA NAO SE ENCONTRA NAS PRIORIDADES DO ATENDENTE';
    $52: Result := 'Envio de texto';
    $53: Result := 'Finalizar atendimento de uma determinada senha';
    $54: Result := 'Solicitar login de atendente - NOVO FORMATO NA V5, COM LOGIN E HASH DA SENHA';
    $55: Result := 'Solicitar logout de atendente especifico';
    $56: Result := 'Solicitar nome de cliente para uma senha';
    $57: Result := 'RE: Definir nome de cliente para uma senha';
    $58: Result := 'Solicitar situação dos processos paralelos de uma senha ou de todas';
    $59: Result := 'RE: Situação dos processos paralelos';
    $5A: Result := 'Solicitar finalização de processos paralelos';
    $5B: Result := 'Solicita login de atendente e conferencia da senha  <= APENAS PARA TECLADO, POIS NÃO ENCRIPTA A SENHA !!!!';
    $5C: Result := 'RE: Nome do atendente logado';
    $5D: Result := 'Solicitar logout do atendente que estiver na PA';
    $5E: Result := 'Solicitar situacao total da PA';
    $5F: Result := 'RE: Situacao total de uma PA';
    $60: Result := 'RE: Teclado serial 1100 - Apaga Flash';
    $61: Result := 'RE: Teclado serial 1100 - Grava Bloco em Flash';
    $62: Result := 'RE: Teclado serial 1100 - Gravacao Completa de Bloco em Flash';
    $63: Result := 'Teclado serial - Erro de Gravacao de Bloco em Flash';
    $64: Result := 'Solicitar nomes dos PIs';
    $65: Result := 'RE: Nomes dos PIs';
    $66: Result := 'Solicitar situacao dos PIs';
    $67: Result := 'RE: Situacao dos PIs';
    $68: Result := 'Solicitar início de PP';
    $69: Result := 'Solicitar evento de marcar/desmarcar uma checkbox de fila prioritária ou bloqueada';
    $6A: Result := 'Solicitar exclusão de uma senha';
    $6B: Result := 'Solicitar inclusão de uma senha numa fila';
    $6C: Result := 'Solicitar situação detalhada de uma fila';
    $6D: Result := 'RE: Situação detalhada das senhas de uma ou mais filas';
$6E: Result := 'Solicitar situação detalhada dos status "prioritária" e "bloqueada" das filas';
$6F: Result := 'RE: Situação detalhada dos status "prioritária" e "bloqueada" das filas';
    $70: Result := 'Solicitar evento de clique de um botão de retirada de senha, informando em qual impressora imprimir a senha  (NOVO)';
$71: Result := 'Solicitar nome, login, grupo, senha e ativo dos atendentes';
$72: Result := 'RE: Nome, login, grupo, senha e ativo de atendentes, também utilizado para solicitar alteração de dados para um atendente => OBS: Servidor sempre envia somente os ativos';
    $73: Result := 'RE: Chamada de senhas em "painel" do tipo SicsTV';
    $74: Result := 'Solicitar inserção de atendente';
    $75: Result := 'RE: Novo atendente inserido';
    $76: Result := 'Solicitar impressão de código de barras de atendente';
    $77: Result := 'Redirecionar senha para outra fila, pela senha';
$78: Result := 'Solicitar nomes dos Grupos (PAs, Atds, Filas, Tags, PPs, etc)';
$79: Result := 'RE: Nomes das Grupos (PAs, Atds, Filas, Tags, PPs, etc)';
    $7A: Result := 'Tabela reconfigurada, solicitar Refresh';
$7B: Result := 'Solicitar nomes e cor das filas  (NOVO)';
$7C: Result := 'RE: Nomes e cores das filas      (NOVO)';
    $7D: Result := 'Definir TAG para uma determinada senha';
    $7E: Result := 'Re: TAG para uma determinada senha';
$7F: Result := 'Solicitar nomes das TAGs';
$AA: Result := 'Re: Nomes das TAGs';
    $AB: Result := 'Solicitar TAGs de uma senha específica';
    $AC: Result := 'Re: TAGs de uma senha específica';
    $AD: Result := 'Solicitar Desassociacao de TAGs';
    $AE: Result := 'Re: Desassociacao de TAGs';
$AF: Result := 'Solicitar nomes no totem e cores das filas';
$86: Result := 'RE: Nomes no totem e cores das filas ****REMOVIDO****';
    $B1: Result := 'Solicitar reimpressão de uma senha específica, informando em qual impressora imprimir a senha';
$88: Result := 'Solicitar lista de canais permissionados e canal padrão';
$89: Result := 'RE: Lista de canais permissionados';
    $8A: Result := 'Setar canal padrão';
    $8B: Result := 'RE: Canal padrão setado';
$8C: Result := 'Solicitar parâmetros do módulo SICS';
    $8D: Result := '--- (vago)';
    $8E: Result := '--- (vago)';
    $8F: Result := 'RE: Login efetuado ou acesso negado';
$B2: Result := 'RE: Parâmetros do módulo SICS';
    $B3: Result := 'Obter lista de conexões TCP/IP';
    $B4: Result := 'RE: Lista de conexões TCP/IP';
    $B5: Result := 'Informa que o servidor deverá solicitar lista de canais ao painel (TV)';
    $B6: Result := 'Envia canais permissionados';
    $B7: Result := 'Solicitar Log Erros do Servidor';
    $B8: Result := 'Re: Log Erros do Servidor';
    $0A: Result := 'Solita configuração gerais path update';
    $0B: Result := 'Re: Solita configuração gerais path update';
    $0C: Result := 'Re: Versão protocolo diferente';
    $0D: Result := 'Solicita dados SQL';
    $0E: Result := 'Re: Dados SQL';
    $F1: Result := 'Teclado serial - ERRO Timeout';
  else
	  Result := 'Não encontrado';
  end;
end;


function FieldValueToChar(const aField: TField; const aDefault: Char = CHAR_FALSO): Char;
begin
  Result := aDefault;
  if Assigned(aField) and (Length(aField.AsString) > 0) then
    Result := aField.AsString[1];
end;

function FieldsValueToChar(const aSQLDataSet: TSQLQuery; const aFieldNames: Array of String; const aDefault: Char = CHAR_FALSO): String;
var
  LFieldName: String;
begin
  Result := EmptyStr;
  for LFieldName in aFieldNames do
  begin
    Result := Result + FieldValueToChar(aSQLDataSet.FieldByName(LFieldName), aDefault);
  end;
end;

function FieldsValueToString(const aSQLDataSet: TSQLQuery; const aFieldNames: Array of String; const aDelimiter: String = ';'): String;
var
  LFieldName: String;
begin
  Result := aDelimiter;
  for LFieldName in aFieldNames do
  begin
    Result := Result + aSQLDataSet.FieldByName(LFieldName).AsString + aDelimiter;
  end;
end;

function FieldsValueToField(const aSQLDataSet: TSQLQuery; const aFieldNames: Array of String; const aDelimiter: String = '|'): String;
var
  LFieldName: String;
  LField: TField;
begin
  Result := EmptyStr;

  for LFieldName in aFieldNames do
  begin
    LField := aSQLDataSet.FieldByName(LFieldName);
    case LField.DataType of
      ftMemo, ftFixedChar, ftWideString, ftString:
        begin
          Result := Result + LField.AsString;
          if LField.Size > 1 then
            Result := Result + aDelimiter;
        end;
      ftByte, ftShortint, ftLargeint, ftAutoInc, ftSmallint, ftInteger: Result := Result + TAspEncode.AspIntToHex(LField.AsInteger, 4);
      ftSingle, ftLongWord, ftExtended, ftCurrency, ftBCD, ftWord, ftFloat: Result := Result + LField.AsString + aDelimiter;
      ftBoolean: Result := Result + FieldValueToChar(LField);
      ftDate: Result := Result + FormatDateTime('dd/mm/yyyy', LField.AsDateTime);
      ftTime: Result := Result + FormatDateTime('hh:mm:ss', LField.AsDateTime);
      ftDateTime: Result := Result + FormatDateTime('dd/mm/yyyy hh:mm:ss', LField.AsDateTime);
    else
      raise Exception.Create('Erro ao enviar parâmetros.');
    end;
  end;
end;
function SettingsFileNamePosition: String;
begin
  Result := GetAppPositionFileName;
end;

procedure ValidaAppMultiInstancia;
{$IFNDEF IS_MOBILE}
var
  LQtdeOutrosProcessos: Integer;
  LNomeApp: String;

  function UpperCaseFirst(Const aValue: String): String;
  begin
    Result := Trim(aValue);
    if Length(Result) > 0 then
      Result[1] := UpperCase(Result[1])[1];
  end;

  function IncluideInfinitive(const aValue: String; const aCount: Integer = 1): String;
  begin
    Result := aValue;
    if aCount > 1 then
      Result := aValue + 's';
  end;
const
  COUNT_CURRENT_APP =1;
{$ENDIF IS_MOBILE}
begin
  {$IFNDEF IS_MOBILE}
  LNomeApp := ApplicationName(True);
  LQtdeOutrosProcessos := ContaProcessos(LNomeApp) - COUNT_CURRENT_APP;
  if (LQtdeOutrosProcessos > 0) then
  begin
    ErrorMessage(
      Format('%s %s do aplicativo "%s" já está em execução. '+
       'Por favor feche-o antes de tentar rodar o programa novamente.', [UpperCaseFirst(valorPorExtenso(LQtdeOutrosProcessos)),
        IncluideInfinitive('processo', LQtdeOutrosProcessos), LNomeApp]));
    FinalizeApplication;
  end;
  {$ENDIF IS_MOBILE}
end;

function valorPorExtenso(vlr: real): string;
const
  unidade: array [1 .. 19] of string = ('um', 'dois', 'três', 'quatro', 'cinco', 'seis', 'sete', 'oito', 'nove', 'dez', 'onze', 'doze', 'treze',
    'quatorze', 'quinze', 'dezesseis', 'dezessete', 'dezoito', 'dezenove');
  centena: array [1 .. 9] of string = ('cento', 'duzentos', 'trezentos', 'quatrocentos', 'quinhentos', 'seiscentos', 'setecentos', 'oitocentos',
    'novecentos');
  dezena: array [2 .. 9] of string     = ('vinte', 'trinta', 'quarenta', 'cinquenta', 'sessenta', 'setenta', 'oitenta', 'noventa');
  qualificaS: array [0 .. 4] of string = ('', 'mil', 'milhão', 'bilhão', 'trilhão');
  qualificaP: array [0 .. 4] of string = ('', 'mil', 'milhões', 'bilhões', 'trilhões');
var
  inteiro                      : Int64;
  resto                        : real;
  vlrS, s, saux, vlrP, centavos: string;
  n, unid, dez, cent, tam, i   : integer;
begin
  if (vlr = 0) then
  begin
    valorPorExtenso := 'zero';
    exit;
  end;

  inteiro := trunc(vlr);    // parte inteira do valor
  resto   := vlr - inteiro; // parte fracionária do valor
  vlrS    := inttostr(inteiro);
  if (length(vlrS) > 15) then
  begin
    valorPorExtenso := 'Erro: valor superior a 999 trilhões.';
    exit;
  end;

  s        := '';
  centavos := inttostr(round(resto * 100));

  // definindo o extenso da parte inteira do valor
  i      := 0;
  while (vlrS <> '0') do
  begin
    tam := length(vlrS);
    // retira do valor a 1a. parte, 2a. parte, por exemplo, para 123456789:
    // 1a. parte = 789 (centena)
    // 2a. parte = 456 (mil)
    // 3a. parte = 123 (milhões)
    if (tam > 3) then
    begin
      vlrP := copy(vlrS, tam - 2, tam);
      vlrS := copy(vlrS, 1, tam - 3);
    end
    else
    begin // última parte do valor
      vlrP := vlrS;
      vlrS := '0';
    end;
    if (vlrP <> '000') then
    begin
      saux := '';
      if (vlrP = '100') then
        saux := 'cem'
      else
      begin
        n    := strtoint(vlrP);     // para n = 371, tem-se:
        cent := n div 100;          // cent = 3 (centena trezentos)
        dez  := (n mod 100) div 10; // dez  = 7 (dezena setenta)
        unid := (n mod 100) mod 10; // unid = 1 (unidade um)
        if (cent <> 0) then
          saux := centena[cent];
        if ((dez <> 0) or (unid <> 0)) then
        begin
          if ((n mod 100)<= 19) then
          begin
            if (length(saux)<> 0) then
              saux := saux + ' e ' + unidade[n mod 100]
            else
              saux := unidade[n mod 100];
          end
          else
          begin
            if (length(saux)<> 0) then
              saux := saux + ' e ' + dezena[dez]
            else
              saux := dezena[dez];
            if (unid <> 0) then
              if (length(saux)<> 0) then
                saux := saux + ' e ' + unidade[unid]
              else
                saux := unidade[unid];
          end;
        end;
      end;
      if ((vlrP = '1') or (vlrP = '001')) then
      begin
        if (i = 0) // 1a. parte do valor (um real)
        then
        else
          saux := saux + ' ' + qualificaS[i];
      end
      else if (i <> 0) then
        saux := saux + ' ' + qualificaP[i];
      if (length(s)<> 0) then
        s := saux + ', ' + s
      else
        s := saux;
    end;
    i     := i + 1; // próximo qualificador: 1- mil, 2- milhão, 3- bilhão, ...
  end;

  // definindo o extenso dos centavos do valor
  if (centavos <> '0') // valor com centavos
  then
  begin
    if (length(s)<> 0) // se não é valor somente com centavos
    then
      s := s + ' e ';
    if (centavos = '1') then
//      s := s + 'um centavo'
    else
    begin
      n := strtoint(centavos);
      if (n <= 19) then
        s := s + unidade[n]
      else
      begin               // para n = 37, tem-se:
        unid := n mod 10; // unid = 37 % 10 = 7 (unidade sete)
        dez  := n div 10; // dez  = 37 / 10 = 3 (dezena trinta)
        s    := s + dezena[dez];
        if (unid <> 0) then
          s := s + ' e ' + unidade[unid];
      end;
//      s := s + ' centavos';
    end;
  end;
  valorPorExtenso := s;
end;

function StrAlphaToColor(const aCorExtensa: String): TAlphaColor;
var
  LCorExtensa: String;
begin
  Result := claNull;

  LCorExtensa := Trim(UpperCase(aCorExtensa));

  if (LCorExtensa = UpperCase('Alpha')) then
    Result := TAlphaColorRec.Alpha
  else
  if (LCorExtensa = UpperCase('Aliceblue')) then
    Result := TAlphaColorRec.Aliceblue
  else
  if (LCorExtensa = UpperCase('Antiquewhite')) then
    Result := TAlphaColorRec.Antiquewhite
  else
  if (LCorExtensa = UpperCase('Aqua')) then
    Result := TAlphaColorRec.Aqua
  else
  if (LCorExtensa = UpperCase('Aquamarine')) then
    Result := TAlphaColorRec.Aquamarine
  else
  if (LCorExtensa = UpperCase('Azure')) then
    Result := TAlphaColorRec.Azure
  else
  if (LCorExtensa = UpperCase('Beige')) then
    Result := TAlphaColorRec.Beige
  else
  if (LCorExtensa = UpperCase('Bisque')) then
    Result := TAlphaColorRec.Bisque
  else
  if (LCorExtensa = UpperCase('Black')) then
    Result := TAlphaColorRec.Black
  else
  if (LCorExtensa = UpperCase('Blanchedalmond')) then
    Result := TAlphaColorRec.Blanchedalmond
  else
  if (LCorExtensa = UpperCase('Blue')) then
    Result := TAlphaColorRec.Blue
  else
  if (LCorExtensa = UpperCase('Blueviolet')) then
    Result := TAlphaColorRec.Blueviolet
  else
  if (LCorExtensa = UpperCase('Brown')) then
    Result := TAlphaColorRec.Brown
  else
  if (LCorExtensa = UpperCase('Burlywood')) then
    Result := TAlphaColorRec.Burlywood
  else
  if (LCorExtensa = UpperCase('Cadetblue')) then
    Result := TAlphaColorRec.Cadetblue
  else
  if (LCorExtensa = UpperCase('Chartreuse')) then
    Result := TAlphaColorRec.Chartreuse
  else
  if (LCorExtensa = UpperCase('Chocolate')) then
    Result := TAlphaColorRec.Chocolate
  else
  if (LCorExtensa = UpperCase('Coral')) then
    Result := TAlphaColorRec.Coral
  else
  if (LCorExtensa = UpperCase('Cornflowerblue')) then
    Result := TAlphaColorRec.Cornflowerblue
  else
  if (LCorExtensa = UpperCase('Cornsilk')) then
    Result := TAlphaColorRec.Cornsilk
  else
  if (LCorExtensa = UpperCase('Crimson')) then
    Result := TAlphaColorRec.Crimson
  else
  if (LCorExtensa = UpperCase('Cyan')) then
    Result := TAlphaColorRec.Cyan
  else
  if (LCorExtensa = UpperCase('Darkblue')) then
    Result := TAlphaColorRec.Darkblue
  else
  if (LCorExtensa = UpperCase('Darkcyan')) then
    Result := TAlphaColorRec.Darkcyan
  else
  if (LCorExtensa = UpperCase('Darkgoldenrod')) then
    Result := TAlphaColorRec.Darkgoldenrod
  else
  if (LCorExtensa = UpperCase('Darkgray')) then
    Result := TAlphaColorRec.Darkgray
  else
  if (LCorExtensa = UpperCase('Darkgreen')) then
    Result := TAlphaColorRec.Darkgreen
  else
  if (LCorExtensa = UpperCase('Darkgrey')) then
    Result := TAlphaColorRec.Darkgrey
  else
  if (LCorExtensa = UpperCase('Darkkhaki')) then
    Result := TAlphaColorRec.Darkkhaki
  else
  if (LCorExtensa = UpperCase('Darkmagenta')) then
    Result := TAlphaColorRec.Darkmagenta
  else
  if (LCorExtensa = UpperCase('Darkolivegreen')) then
    Result := TAlphaColorRec.Darkolivegreen
  else
  if (LCorExtensa = UpperCase('Darkorange')) then
    Result := TAlphaColorRec.Darkorange
  else
  if (LCorExtensa = UpperCase('Darkorchid')) then
    Result := TAlphaColorRec.Darkorchid
  else
  if (LCorExtensa = UpperCase('Darkred')) then
    Result := TAlphaColorRec.Darkred
  else
  if (LCorExtensa = UpperCase('Darksalmon')) then
    Result := TAlphaColorRec.Darksalmon
  else
  if (LCorExtensa = UpperCase('Darkseagreen')) then
    Result := TAlphaColorRec.Darkseagreen
  else
  if (LCorExtensa = UpperCase('Darkslateblue')) then
    Result := TAlphaColorRec.Darkslateblue
  else
  if (LCorExtensa = UpperCase('Darkslategray')) then
    Result := TAlphaColorRec.Darkslategray
  else
  if (LCorExtensa = UpperCase('Darkslategrey')) then
    Result := TAlphaColorRec.Darkslategrey
  else
  if (LCorExtensa = UpperCase('Darkturquoise')) then
    Result := TAlphaColorRec.Darkturquoise
  else
  if (LCorExtensa = UpperCase('Darkviolet')) then
    Result := TAlphaColorRec.Darkviolet
  else
  if (LCorExtensa = UpperCase('Deeppink')) then
    Result := TAlphaColorRec.Deeppink
  else
  if (LCorExtensa = UpperCase('Deepskyblue')) then
    Result := TAlphaColorRec.Deepskyblue
  else
  if (LCorExtensa = UpperCase('Dimgray')) then
    Result := TAlphaColorRec.Dimgray
  else
  if (LCorExtensa = UpperCase('Dimgrey')) then
    Result := TAlphaColorRec.Dimgrey
  else
  if (LCorExtensa = UpperCase('Dodgerblue')) then
    Result := TAlphaColorRec.Dodgerblue
  else
  if (LCorExtensa = UpperCase('Firebrick')) then
    Result := TAlphaColorRec.Firebrick
  else
  if (LCorExtensa = UpperCase('Floralwhite')) then
    Result := TAlphaColorRec.Floralwhite
  else
  if (LCorExtensa = UpperCase('Forestgreen')) then
    Result := TAlphaColorRec.Forestgreen
  else
  if (LCorExtensa = UpperCase('Fuchsia')) then
    Result := TAlphaColorRec.Fuchsia
  else
  if (LCorExtensa = UpperCase('Gainsboro')) then
    Result := TAlphaColorRec.Gainsboro
  else
  if (LCorExtensa = UpperCase('Ghostwhite')) then
    Result := TAlphaColorRec.Ghostwhite
  else
  if (LCorExtensa = UpperCase('Gold')) then
    Result := TAlphaColorRec.Gold
  else
  if (LCorExtensa = UpperCase('Goldenrod')) then
    Result := TAlphaColorRec.Goldenrod
  else
  if (LCorExtensa = UpperCase('Gray')) then
    Result := TAlphaColorRec.Gray
  else
  if (LCorExtensa = UpperCase('Green')) then
    Result := TAlphaColorRec.Green
  else
  if (LCorExtensa = UpperCase('Greenyellow')) then
    Result := TAlphaColorRec.Greenyellow
  else
  if (LCorExtensa = UpperCase('Grey')) then
    Result := TAlphaColorRec.Grey
  else
  if (LCorExtensa = UpperCase('Honeydew')) then
    Result := TAlphaColorRec.Honeydew
  else
  if (LCorExtensa = UpperCase('Hotpink')) then
    Result := TAlphaColorRec.Hotpink
  else
  if (LCorExtensa = UpperCase('Indianred')) then
    Result := TAlphaColorRec.Indianred
  else
  if (LCorExtensa = UpperCase('Indigo')) then
    Result := TAlphaColorRec.Indigo
  else
  if (LCorExtensa = UpperCase('Ivory')) then
    Result := TAlphaColorRec.Ivory
  else
  if (LCorExtensa = UpperCase('Khaki')) then
    Result := TAlphaColorRec.Khaki
  else
  if (LCorExtensa = UpperCase('Lavender')) then
    Result := TAlphaColorRec.Lavender
  else
  if (LCorExtensa = UpperCase('Lavenderblush')) then
    Result := TAlphaColorRec.Lavenderblush
  else
  if (LCorExtensa = UpperCase('Lawngreen')) then
    Result := TAlphaColorRec.Lawngreen
  else
  if (LCorExtensa = UpperCase('Lemonchiffon')) then
    Result := TAlphaColorRec.Lemonchiffon
  else
  if (LCorExtensa = UpperCase('Lightblue')) then
    Result := TAlphaColorRec.Lightblue
  else
  if (LCorExtensa = UpperCase('Lightcoral')) then
    Result := TAlphaColorRec.Lightcoral
  else
  if (LCorExtensa = UpperCase('Lightcyan')) then
    Result := TAlphaColorRec.Lightcyan
  else
  if (LCorExtensa = UpperCase('Lightgoldenrodyellow')) then
    Result := TAlphaColorRec.Lightgoldenrodyellow
  else
  if (LCorExtensa = UpperCase('Lightgray')) then
    Result := TAlphaColorRec.Lightgray
  else
  if (LCorExtensa = UpperCase('Lightgreen')) then
    Result := TAlphaColorRec.Lightgreen
  else
  if (LCorExtensa = UpperCase('Lightgrey')) then
    Result := TAlphaColorRec.Lightgrey
  else
  if (LCorExtensa = UpperCase('Lightpink')) then
    Result := TAlphaColorRec.Lightpink
  else
  if (LCorExtensa = UpperCase('Lightsalmon')) then
    Result := TAlphaColorRec.Lightsalmon
  else
  if (LCorExtensa = UpperCase('Lightseagreen')) then
    Result := TAlphaColorRec.Lightseagreen
  else
  if (LCorExtensa = UpperCase('Lightskyblue')) then
    Result := TAlphaColorRec.Lightskyblue
  else
  if (LCorExtensa = UpperCase('Lightslategray')) then
    Result := TAlphaColorRec.Lightslategray
  else
  if (LCorExtensa = UpperCase('Lightslategrey')) then
    Result := TAlphaColorRec.Lightslategrey
  else
  if (LCorExtensa = UpperCase('Lightsteelblue')) then
    Result := TAlphaColorRec.Lightsteelblue
  else
  if (LCorExtensa = UpperCase('Lightyellow')) then
    Result := TAlphaColorRec.Lightyellow
  else
  if (LCorExtensa = UpperCase('LtGray')) then
    Result := TAlphaColorRec.LtGray
  else
  if (LCorExtensa = UpperCase('MedGray')) then
    Result := TAlphaColorRec.MedGray
  else
  if (LCorExtensa = UpperCase('DkGray')) then
    Result := TAlphaColorRec.DkGray
  else
  if (LCorExtensa = UpperCase('MoneyGreen')) then
    Result := TAlphaColorRec.MoneyGreen
  else
  if (LCorExtensa = UpperCase('LegacySkyBlue')) then
    Result := TAlphaColorRec.LegacySkyBlue
  else
  if (LCorExtensa = UpperCase('Cream')) then
    Result := TAlphaColorRec.Cream
  else
  if (LCorExtensa = UpperCase('Lime')) then
    Result := TAlphaColorRec.Lime
  else
  if (LCorExtensa = UpperCase('Limegreen')) then
    Result := TAlphaColorRec.Limegreen
  else
  if (LCorExtensa = UpperCase('Linen')) then
    Result := TAlphaColorRec.Linen
  else
  if (LCorExtensa = UpperCase('Magenta')) then
    Result := TAlphaColorRec.Magenta
  else
  if (LCorExtensa = UpperCase('Maroon')) then
    Result := TAlphaColorRec.Maroon
  else
  if (LCorExtensa = UpperCase('Mediumaquamarine')) then
    Result := TAlphaColorRec.Mediumaquamarine
  else
  if (LCorExtensa = UpperCase('Mediumblue')) then
    Result := TAlphaColorRec.Mediumblue
  else
  if (LCorExtensa = UpperCase('Mediumorchid')) then
    Result := TAlphaColorRec.Mediumorchid
  else
  if (LCorExtensa = UpperCase('Mediumpurple')) then
    Result := TAlphaColorRec.Mediumpurple
  else
  if (LCorExtensa = UpperCase('Mediumseagreen')) then
    Result := TAlphaColorRec.Mediumseagreen
  else
  if (LCorExtensa = UpperCase('Mediumslateblue')) then
    Result := TAlphaColorRec.Mediumslateblue
  else
  if (LCorExtensa = UpperCase('Mediumspringgreen')) then
    Result := TAlphaColorRec.Mediumspringgreen
  else
  if (LCorExtensa = UpperCase('Mediumturquoise')) then
    Result := TAlphaColorRec.Mediumturquoise
  else
  if (LCorExtensa = UpperCase('Mediumvioletred')) then
    Result := TAlphaColorRec.Mediumvioletred
  else
  if (LCorExtensa = UpperCase('Midnightblue')) then
    Result := TAlphaColorRec.Midnightblue
  else
  if (LCorExtensa = UpperCase('Mintcream')) then
    Result := TAlphaColorRec.Mintcream
  else
  if (LCorExtensa = UpperCase('Mistyrose')) then
    Result := TAlphaColorRec.Mistyrose
  else
  if (LCorExtensa = UpperCase('Moccasin')) then
    Result := TAlphaColorRec.Moccasin
  else
  if (LCorExtensa = UpperCase('Navajowhite')) then
    Result := TAlphaColorRec.Navajowhite
  else
  if (LCorExtensa = UpperCase('Navy')) then
    Result := TAlphaColorRec.Navy
  else
  if (LCorExtensa = UpperCase('Oldlace')) then
    Result := TAlphaColorRec.Oldlace
  else
  if (LCorExtensa = UpperCase('Olive')) then
    Result := TAlphaColorRec.Olive
  else
  if (LCorExtensa = UpperCase('Olivedrab')) then
    Result := TAlphaColorRec.Olivedrab
  else
  if (LCorExtensa = UpperCase('Orange')) then
    Result := TAlphaColorRec.Orange
  else
  if (LCorExtensa = UpperCase('Orangered')) then
    Result := TAlphaColorRec.Orangered
  else
  if (LCorExtensa = UpperCase('Orchid')) then
    Result := TAlphaColorRec.Orchid
  else
  if (LCorExtensa = UpperCase('Palegoldenrod')) then
    Result := TAlphaColorRec.Palegoldenrod
  else
  if (LCorExtensa = UpperCase('Palegreen')) then
    Result := TAlphaColorRec.Palegreen
  else
  if (LCorExtensa = UpperCase('Paleturquoise')) then
    Result := TAlphaColorRec.Paleturquoise
  else
  if (LCorExtensa = UpperCase('Palevioletred')) then
    Result := TAlphaColorRec.Palevioletred
  else
  if (LCorExtensa = UpperCase('Papayawhip')) then
    Result := TAlphaColorRec.Papayawhip
  else
  if (LCorExtensa = UpperCase('Peachpuff')) then
    Result := TAlphaColorRec.Peachpuff
  else
  if (LCorExtensa = UpperCase('Peru')) then
    Result := TAlphaColorRec.Peru
  else
  if (LCorExtensa = UpperCase('Pink')) then
    Result := TAlphaColorRec.Pink
  else
  if (LCorExtensa = UpperCase('Plum')) then
    Result := TAlphaColorRec.Plum
  else
  if (LCorExtensa = UpperCase('Powderblue')) then
    Result := TAlphaColorRec.Powderblue
  else
  if (LCorExtensa = UpperCase('Purple')) then
    Result := TAlphaColorRec.Purple
  else
  if (LCorExtensa = UpperCase('Red')) then
    Result := TAlphaColorRec.Red
  else
  if (LCorExtensa = UpperCase('Rosybrown')) then
    Result := TAlphaColorRec.Rosybrown
  else
  if (LCorExtensa = UpperCase('Royalblue')) then
    Result := TAlphaColorRec.Royalblue
  else
  if (LCorExtensa = UpperCase('Saddlebrown')) then
    Result := TAlphaColorRec.Saddlebrown
  else
  if (LCorExtensa = UpperCase('Salmon')) then
    Result := TAlphaColorRec.Salmon
  else
  if (LCorExtensa = UpperCase('Sandybrown')) then
    Result := TAlphaColorRec.Sandybrown
  else
  if (LCorExtensa = UpperCase('Seagreen')) then
    Result := TAlphaColorRec.Seagreen
  else
  if (LCorExtensa = UpperCase('Seashell')) then
    Result := TAlphaColorRec.Seashell
  else
  if (LCorExtensa = UpperCase('Sienna')) then
    Result := TAlphaColorRec.Sienna
  else
  if (LCorExtensa = UpperCase('Silver')) then
    Result := TAlphaColorRec.Silver
  else
  if (LCorExtensa = UpperCase('Skyblue')) then
    Result := TAlphaColorRec.Skyblue
  else
  if (LCorExtensa = UpperCase('Slateblue')) then
    Result := TAlphaColorRec.Slateblue
  else
  if (LCorExtensa = UpperCase('Slategray')) then
    Result := TAlphaColorRec.Slategray
  else
  if (LCorExtensa = UpperCase('Slategrey')) then
    Result := TAlphaColorRec.Slategrey
  else
  if (LCorExtensa = UpperCase('Snow')) then
    Result := TAlphaColorRec.Snow
  else
  if (LCorExtensa = UpperCase('Springgreen')) then
    Result := TAlphaColorRec.Springgreen
  else
  if (LCorExtensa = UpperCase('Steelblue')) then
    Result := TAlphaColorRec.Steelblue
  else
  if (LCorExtensa = UpperCase('Tan')) then
    Result := TAlphaColorRec.Tan
  else
  if (LCorExtensa = UpperCase('Teal')) then
    Result := TAlphaColorRec.Teal
  else
  if (LCorExtensa = UpperCase('Thistle')) then
    Result := TAlphaColorRec.Thistle
  else
  if (LCorExtensa = UpperCase('Tomato')) then
    Result := TAlphaColorRec.Tomato
  else
  if (LCorExtensa = UpperCase('Turquoise')) then
    Result := TAlphaColorRec.Turquoise
  else
  if (LCorExtensa = UpperCase('Violet')) then
    Result := TAlphaColorRec.Violet
  else
  if (LCorExtensa = UpperCase('Wheat')) then
    Result := TAlphaColorRec.Wheat
  else
  if (LCorExtensa = UpperCase('White')) then
    Result := TAlphaColorRec.White
  else
  if (LCorExtensa = UpperCase('Whitesmoke')) then
    Result := TAlphaColorRec.Whitesmoke
  else
  if (LCorExtensa = UpperCase('Yellow')) then
    Result := TAlphaColorRec.Yellow
  else
  if (LCorExtensa = UpperCase('Yellowgreen')) then
    Result := TAlphaColorRec.Yellowgreen
  else
  if (LCorExtensa = UpperCase('Null')) then
    Result := TAlphaColorRec.Null;
end;


function RemovePrefixoCor(const aCorExtensa: String): String;
begin
  Result := aCorExtensa;
end;

end.

