unit uDMSocket;

interface

uses
  System.SysUtils, System.Classes, System.Win.ScktComp, Vcl.ExtCtrls, uTypes,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,System.JSON;

type
  TdmSocket = class(TDataModule)
    tmrReconnectToServer: TTimer;
    ClientSocket: TClientSocket;
    IdHTTP1: TIdHTTP;
    procedure tmrReconnectToServerTimer(Sender: TObject);
    procedure ClientSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure ClientSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
  private
    FOnConnect: TProc;
    FOnDisconnect: TProc;
    FOnError: TProc<Integer>;
    FOnReadException: TProc<Exception>;
    FTipoInterface: TTipoDaInterface;
    FOnStatusChange: TProc<string>;
    FSalvarRespostasArquivos: Boolean;
    FProcSalvaArquivoResposta: TProc<string>;
    FProcGetRESTResponse: TProc<string>;
    FRestAdr: Integer;
    FRestCmd: Integer;
    FUrlEnviaSenha : string;
    UltimoProtocolo3C :string;
    function DecifraProtocoloV5(s: string): string;
    function DecifraProtocoloREST(s: string): string;
    procedure EnviaSenha(PA : Integer; Senha, Nome: string);
  public
    property OnConnect: TProc read FOnConnect write FOnConnect;
    property OnDisconnect: TProc read FOnDisconnect write FOnDisconnect;
    property OnError: TProc<Integer> read FOnError write FOnError;
    property OnReadException: TProc<Exception> read FOnReadException write FOnReadException;
    property OnStatusChange: TProc<string> read FOnStatusChange write FOnStatusChange;
    property ProcGetRESTResponse: TProc<string> read FProcGetRESTResponse write FProcGetRESTResponse;
    property ProcSalvaArquivoResposta: TProc<string> read FProcSalvaArquivoResposta write FProcSalvaArquivoResposta;
    property TipoInterface: TTipoDaInterface read FTipoInterface write FTIpoInterface;
    property SalvarRespostasArquivos: Boolean read FSalvarRespostasArquivos write FSalvarRespostasArquivos;
    property RestAdr: Integer read FRestAdr write FRestAdr;
    property RestCmd: Integer read FRestCmd write FRestCmd;
    property UrlEnviaSenha: string read FUrlEnviaSenha write FUrlEnviaSenha;
  end;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses uConsts, MyDlls_DR, uLibDatasnap;

{$R *.dfm}

procedure TdmSocket.ClientSocketConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  if Assigned(FOnConnect) then
    FOnConnect();
end;

procedure TdmSocket.ClientSocketDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  if Assigned(FOnDisconnect) then
    FOnDisconnect();
end;

procedure TdmSocket.ClientSocketError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  if Assigned(FOnError) then
    FOnError(ErrorCode);

  if ((ErrorCode = 10061) or (ErrorCode = 10053)) then
    ErrorCode := 0;
  ClientSocket.Close;
end;

procedure TdmSocket.ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
const
  {$WriteableConst On}
  ReceivingProtocol : boolean = false;
  Protocol          : string = '';
  {$WriteableConst Off}
var
  i : word;
  s : string;
begin
  try
    s := Socket.ReceiveText;

    for i := 1 to length(s) do
    begin
      if s[i] = STX then
      begin
        ReceivingProtocol := true;
        Protocol := '';
      end
      else if s[i] = ETX then
      begin
        ReceivingProtocol := false;

        Protocol := STX + Protocol + ETX;

        case (TipoInterface) of
           tiSilab : begin
                       if(FSalvarRespostasArquivos)then
                         DecifraProtocoloV5(Protocol);
                     end;
           tiREST  : begin
                       DecifraProtocoloREST(Protocol);
                     end;
        end;

        Protocol := '';
      end
      else if ReceivingProtocol then
        Protocol := Protocol + s[i];
    end;
  except
    on E: Exception do
    begin
      if Assigned(FOnReadException) then
        FOnReadException(E);
    end;
  end;  { try .. except }
end;

procedure TdmSocket.tmrReconnectToServerTimer(Sender: TObject);
begin
  if not ClientSocket.Active then
  begin
    if Assigned(FOnDisconnect) then
      FOnDisconnect();

    if ( ((ClientSocket.Address <> '') or (ClientSocket.Host <> '')) and (ClientSocket.Port <> 0)) then
      ClientSocket.Open;
  end;
end;
 //OBS: Para a função abaixo funcionar, necessário que mesmo o 1o bloco seja precedido de TAB.
//     Como não venha assim do servidor, isto deve ser ajustado após o recebimento, em DecifraProtocolo
function AlterouStatusPA (PA : integer; Anterior, Atual : string) : boolean;
var
  BlocoAnterior, BlocoAtual : string;
  i                         : integer;
begin
  try
    BlocoAnterior := '';
    BlocoAtual    := '';

    i := Pos(TAB+IntToHex(PA, 4), Anterior) + 1;
    if i >= 2 then
      while Anterior[i] <> TAB do
      begin
        BlocoAnterior := BlocoAnterior + Anterior[i];
        i := i + 1;
      end;

    i := Pos(TAB+IntToHex(PA, 4), Atual) + 1;
    if i >= 2 then
      while Atual[i] <> TAB do
      begin
        BlocoAtual := BlocoAtual + Atual[i];
        i := i + 1;
      end;

    Result := BlocoAnterior <> BlocoAtual;
  except
    Result := true;
  end;
end;

function TdmSocket.DecifraProtocoloREST(s: string): string;

var
  VersaoProtocolo : integer;
  Adr             : integer;
  CMD             : byte;
  ProtData        : string;
  PSWD            : string;
  Aux,aux2        : string;
  PA,i            : Integer;
  StatusPA        : Integer;
  ATD             : Integer;
  MotivoPausa     : Integer;
  Nome            : string;
  Fila            : Integer;
  TIM             : TDateTime;

begin
  Result := '';
  if ((s <> '') and (s[1] = STX) and (s[Length(s)] = ETX) and (Length(s) >= 11)) then
  begin
    VersaoProtocolo := StrToInt('$' + Copy(s, 2, 4));
    Adr             := StrToInt('$' + Copy(s, 6, 4));
    CMD             := Ord(s[10]);
    ProtData        := Copy(s, 11, length(s) - 11);

    case CMD of

      $3C : begin
              Aux := ProtData;
              Aux := TAB + Copy(Aux, 5, Length(Aux) - 4);  //CORTA OS PRIMEIROS 4 BYTES QUE SÃO A QTD DE PAS E COLOCA ESTE TAB PARA FUNCIONAR A "AlterouStatusPA"

              if aux <> UltimoProtocolo3C then
              begin
                aux2 := '';
                for i := 2 to length (aux) do  // COMEÇAR DE 2 PARA CORTAR O TAB COLOCADO ACIMA, QUE AINDA SERÁ ÚTIL MAIS À FRENTE
                begin
                  if aux[i] = TAB then
                  begin
                    PA   := StrToInt('$'+Copy(aux2,1,4));
                    if AlterouStatusPA (PA, UltimoProtocolo3C, aux) then
                    begin
                      if Copy(aux2,19,4) = '----' then
                        StatusPA := -1
                      else
                        StatusPA := StrToInt('$'+Copy(aux2,19,4));
                      if Copy(aux2,23,4) = '----' then
                        ATD := -1
                      else
                        ATD := StrToInt('$'+Copy(aux2,23,4));
                      if Copy(aux2,31,4) = '----' then
                        MotivoPausa := -1
                      else
                        MotivoPausa := StrToInt('$'+Copy(aux2,31,4));
                      PSWD := Copy(aux2, 35, Pos (';', aux2) - 35);
                      Nome := Copy(aux2, Pos (';', aux2) + 1, length(aux2) - Pos (';', aux2));

                      if Copy(aux2,27,4) = '----' then
                        Fila := -1
                      else
                        Fila := StrToInt('$'+Copy(aux2,27,4));
                      TIM := EncodeDate(strtoint(aux2[9]+aux2[10]+aux2[11]+aux2[12]),strtoint(aux2[7]+aux2[8]),strtoint(aux2[5]+aux2[6])) +
                             EncodeTime(strtoint(aux2[13]+aux2[14]),strtoint(aux2[15]+aux2[16]),strtoint(aux2[17]+aux2[18]),0);

                      if StatusPA = Ord(spEmAtendimento) then
                      begin
                       // SalvaArquivoResposta(inttostr(PA) + ';' + '39' + ';' + PSWD + ';' + 'ddmmyyyyhhnnss');
                        //ShowStatus(Format('PA %d chamou senha %s, que estava em espera desde as ddmmyyyyhhnnss.', [PA, PSWD]));
//                        TLibDataSnap.UpdateStatus(Format('Comando $3C - PA %d senha %s', [PA, PSWD]));
                        EnviaSenha(PA, PSWD, Nome);
                      end;
                    end;
                    aux2 := '';
                  end
                  else if aux[i] <> ETX then
                    aux2 := aux2 + aux[i];
                end;

                UltimoProtocolo3C := aux;
              end;  { if aux <> UltimoProtocolo3C }
            end;

    end;  //case
  end;

end;

function TdmSocket.DecifraProtocoloV5(s: string): string;
const
  UltimoProtocolo3C : string = '';
var
  VersaoProtocolo : integer;
  Adr             : integer;
  CMD             : byte;
  ProtData        : string;
  DataHora        : string;
  PSWD            : string;
begin
  Result := '';
  if ((s <> '') and (s[1] = STX) and (s[Length(s)] = ETX) and (Length(s) >= 11)) then
  begin
    VersaoProtocolo := StrToInt('$' + Copy(s, 2, 4));
    Adr             := StrToInt('$' + Copy(s, 6, 4));
    CMD             := Ord(s[10]);
    ProtData        := Copy(s, 11, length(s) - 11);

    case CMD of
      $39 : begin
              SeparaStrings(ProtData, ';', PSWD, DataHora);
              Result := IntToStr(Adr) + ';' + IntToHex(CMD, 2) + ';' + ProtData;
              if Assigned(FOnStatusChange) then
                FOnStatusChange(Format('PA %d chamou senha %s, que estava em espera desde as %s.', [Adr, PSWD, DataHora]));
            end;

//      $3C : begin
//              Aux := ProtData;
//              Aux := TAB + Copy(Aux, 5, Length(Aux) - 4);  //CORTA OS PRIMEIROS 4 BYTES QUE SÃO A QTD DE PAS E COLOCA ESTE TAB PARA FUNCIONAR A "AlterouStatusPA"
//
//              if aux <> UltimoProtocolo3C then
//              begin
//                aux2 := '';
//                for i := 2 to length (aux) do  // COMEÇAR DE 2 PARA CORTAR O TAB COLOCADO ACIMA, QUE AINDA SERÁ ÚTIL MAIS À FRENTE
//                begin
//                  if aux[i] = TAB then
//                  begin
//                    PA   := StrToInt('$'+Copy(aux2,1,4));
//                    if AlterouStatusPA (PA, UltimoProtocolo3C, aux) then
//                    begin
//                      if Copy(aux2,19,4) = '----' then
//                        StatusPA := -1
//                      else
//                        StatusPA := StrToInt('$'+Copy(aux2,19,4));
//                      if Copy(aux2,23,4) = '----' then
//                        ATD := -1
//                      else
//                        ATD := StrToInt('$'+Copy(aux2,23,4));
//                      if Copy(aux2,31,4) = '----' then
//                        MotivoPausa := -1
//                      else
//                        MotivoPausa := StrToInt('$'+Copy(aux2,31,4));
//                      PSWD := Copy(aux2, 35, Pos (';', aux2) - 35);
//                      Nome := Copy(aux2, Pos (';', aux2) + 1, length(aux2) - Pos (';', aux2));
//
//                      if Copy(aux2,27,4) = '----' then
//                        Fila := -1
//                      else
//                        Fila := StrToInt('$'+Copy(aux2,27,4));
//                      TIM := EncodeDate(strtoint(aux2[9]+aux2[10]+aux2[11]+aux2[12]),strtoint(aux2[7]+aux2[8]),strtoint(aux2[5]+aux2[6])) +
//                             EncodeTime(strtoint(aux2[13]+aux2[14]),strtoint(aux2[15]+aux2[16]),strtoint(aux2[17]+aux2[18]),0);
//
////                      if StatusPA = Ord(spEmAtendimento) then
////                      begin
////                        SalvaArquivoResposta(inttostr(PA) + ';' + '39' + ';' + PSWD + ';' + 'ddmmyyyyhhnnss');
////                        ShowStatus(Format('PA %d chamou senha %s, que estava em espera desde as ddmmyyyyhhnnss.', [PA, PSWD]));
////                      end;
//                    end;
//                    aux2 := '';
//                  end
//                  else if aux[i] <> ETX then
//                    aux2 := aux2 + aux[i];
//                end;
//
//                UltimoProtocolo3C := aux;
//              end;  { if aux <> UltimoProtocolo3C }
//            end;

      $42 : begin
              Result := IntToStr(Adr) + ';' + IntToHex(CMD, 2) + ';' + ProtData;
              if Assigned(FOnStatusChange) then
                FOnStatusChange('Lista de motivos de pausa para a PA ' + inttostr(ADR) + ': "' + ProtData + '"');
            end;

      $7C : begin
              Result := IntToStr(Adr) + ';' + IntToHex(CMD, 2) + ';' + ProtData;
              if Assigned(FOnStatusChange) then
                FOnStatusChange('Lista de filas para a PA ' + inttostr(ADR) + ': "' + ProtData + '"');
            end;
    end;  //case
  end;

  if (Result <> '') and Assigned(FProcSalvaArquivoResposta) then
    FProcSalvaArquivoResposta(Result);
end;

procedure TdmSocket.EnviaSenha(PA : Integer; Senha, Nome :string);
const
  KEY_STATUS = 'status';
  KEY_MESSAGE = 'message';
var
  JsonToSend : TStringStream;
  retorno  : string;
  jsonObject : TJSONObject;
begin
  if Trim(FUrlEnviaSenha) = EmptyStr then
  begin
    if Assigned(OnStatusChange) then
      OnStatusChange('Não enviou senha '+ Senha+' para PA '+ PA.ToString +
                     ' via WebService: URL não configurada no INI');
    exit;
  end;

  JsonToSend := TStringStream.Create(TEncoding.UTF8.GetBytes ('{"PA": ' + PA.ToString +
                                     ', "Senha": ' + Senha +
                                                              ', "Nome": "' + Nome + '"}'));
  try
   retorno :=  IdHTTP1.Post(FUrlEnviaSenha,JsonToSend);
   jsonObject := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(retorno),0) as TJSONObject ;

    if(jsonObject.TryGetValue(KEY_STATUS,retorno))then
    begin
      if(jsonObject.Values[KEY_STATUS].value = TJSONTrue.Create.ToString)then
        retorno := 'Senha '+ Senha + '(Nome: "' + Nome + '") enviada para PA '+ PA.ToString
      else
      begin
        if(jsonObject.TryGetValue(KEY_MESSAGE,retorno))then
          retorno := 'Falha ao enviar a senha '+ Senha + '(Nome: "' + Nome + '") para a PA '+ PA.ToString +' : '+ retorno
        else
          retorno := 'Falha ao enviar a senha '+ Senha + '(Nome: "' + Nome + '") para a PA '+ PA.ToString;
      end;
    end;

    if(Assigned(OnStatusChange))then
      OnStatusChange(retorno);

  finally
     JsonToSend.Free;
  end;

end;

end.
