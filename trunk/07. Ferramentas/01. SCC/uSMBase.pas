unit uSMBase;

{$J+}

interface

uses
  System.SysUtils, System.Classes, uDMSocket, System.Types, System.SyncObjs;

type
  TsmBase = class(TDataModule)
  private
    FIdUnidade: String;
    function Contem(const AValue: Integer; const AArray: TIntegerDynArray): Boolean;
    function RecebeuRetornoEsperado(aResp: String; const aAddr: Integer; aCmdsEsperados: TIntegerDynArray; var AData: String): Boolean;
  protected
    const P_IDUNIDADE = 'IdUnidade';
    function EnviarComando(const aAdr, aCmd: Integer; const aDat: String; const aCmdsRespostaEsperados: TIntegerDynArray): String; virtual; final;
  public
    property IdUnidade: String read FIdUnidade write FIdUnidade;
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses
  uLibDatasnap, uTypes, System.DateUtils, uConsts, Winapi.ActiveX, System.Win.ScktComp, SCC_m;

var
  LCrit: TCriticalSection;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

function TsmBase.Contem(const AValue: Integer; const AArray: TIntegerDynArray): Boolean;
var
  i: Integer;
begin
  for i := Low(AArray) to High(AArray) do
    if AArray[i] = AValue then
      exit(true);
  result := False;
end;

constructor TsmBase.Create(AOwner: TComponent);
begin
  inherited;

end;

function TsmBase.EnviarComando(const aAdr, aCmd: Integer; const aDat: String; const aCmdsRespostaEsperados: TIntegerDynArray): String;
const
  BUFFER_SIZE = 1024;
  SOCKET_TIMEOUT = {$IFDEF DEBUG}300000{$ELSE}10000{$ENDIF};

//LBCDEBUG  DEBUGNUMBER : integer = 0;
var
  LBuffer: TBytes;
  s, LResp, LData: String;
  LClientSocket: TClientSocket;
  LSocketStream: TWinSocketStream ;
  LReturnSize: Integer;
  LDadosConexaoUnidade: TDadosConexaoUnidade;
  Timeout : TDatetime;
begin
//LBCDEBUG  if DEBUGNUMBER = 9999 then
//LBCDEBUG    DEBUGNUMBER := 0;
//LBCDEBUG  DEBUGNUMBER := DEBUGNUMBER + 1;

  result := EmptyStr;
  LCrit.Enter;
  try
    LDadosConexaoUnidade := TLibDataSnap.ConexaoUnidade[IdUnidade];
  finally
    LCrit.Leave;
  end;

//LBCDEBUG  MainForm.ShowStatus('DEBUG ' + Format('%.4d', [DEBUGNUMBER]) + ': CoInitialize antes');
  CoInitialize(nil);
//LBCDEBUG  MainForm.ShowStatus('DEBUG ' + Format('%.4d', [DEBUGNUMBER]) + ': CoInitialize depois');
  try
    LClientSocket := TClientSocket.Create(nil);
    try
      LClientSocket.ClientType := ctBlocking;
      LClientSocket.Host       := LDadosConexaoUnidade.Address;
      LClientSocket.Port       := LDadosConexaoUnidade.Port;
      LClientSocket.Open;
      try
        SetLength(LBuffer, BUFFER_SIZE);
        LResp := EmptyStr;
        s := STX +
             IntToHex(cgVERSAOPROTOCOLO, 4) +
             IntToHex(aAdr, 4) +
             string(AnsiChar(aCmd)) +   //ESTAVA:  Char(aCmd) +
             aDat +
             ETX;

        LSocketStream := TWinSocketStream.Create(LClientSocket.Socket, SOCKET_TIMEOUT);
        try
          LSocketStream.Write(TEncoding.ANSI.GetBytes(s), Length(s));
          Timeout := now;
          repeat
            if LSocketStream.WaitForData(SOCKET_TIMEOUT) then
              LReturnSize := LSocketStream.Read(LBuffer, BUFFER_SIZE)
            else
              LReturnSize := 0;

            if LReturnSize > 0 then
            begin
              LResp := LResp + TEncoding.ANSI.GetString(LBuffer);
              if ((LResp[Length(LResp)] = #0) and (Pos(ETX, LResp) > 0)) then
              begin
                if RecebeuRetornoEsperado(LResp, aAdr, aCmdsRespostaEsperados, LData) then
                  LReturnSize := 0
                else
                  LResp := EmptyStr;
              end
              else
              begin
                if ((LResp[Length(LResp)] = #0) and (Pos(ETX, LResp) <= 0)) then
                  MainForm.ShowStatus('Pacote socket veio incompleto, retomando leitura do socket para tentar completar pacote...');

                while LResp[Length(LResp)] = #0 do
                  LResp := Copy(LResp, 1, length(LResp) - 1);

                SetLength(LBuffer, 0);
                SetLength(LBuffer, BUFFER_SIZE);
              end;
            end;

            if Now >= Timeout + EncodeTime(0, 0, 20, 0) then
              raise Exception.Create('Timeout sem obter resposta válida do servidor do SICS');

          until (LReturnSize = 0) or (not LClientSocket.Active);

          if LResp = EmptyStr then
            raise Exception.Create('Servidor do SICS não respondeu');
          result := LData;
        finally
          LSocketStream.Free;
        end;
      finally
        LClientSocket.Close;
      end;
    finally
      LClientSocket.Free;
    end;

    //LBCDEBUG    MainForm.ShowStatus('DEBUG ' + Format('%.4d', [DEBUGNUMBER]) + ': CoUninitialize antes');
    CoUninitialize;
    //LBCDEBUG    MainForm.ShowStatus('DEBUG ' + Format('%.4d', [DEBUGNUMBER]) + ': CoUninitialize depois');
  except
    raise;
  end;
end;

function TsmBase.RecebeuRetornoEsperado(aResp: String; const aAddr: Integer; aCmdsEsperados: TIntegerDynArray; var AData: String): Boolean;
var
  LPosS, LPosE, LAddr, LCmd: Integer;
  LProt: String;
  Timeout : TDateTime;
begin
  AData := EmptyStr;
  result := False;

  if (aResp = EmptyStr) and Contem(0, aCmdsEsperados) then
  begin
    result := True;
  end
  else
  begin
    Timeout := now;
    repeat
      LPosS := Pos(STX, aResp);
      LPosE := Pos(ETX, aResp);
      LProt := Copy(aResp, LPosS+1, LPosE-LPosS-1);
      if length(LProt) >= 9 then //PPPPAAAAC - P=Protocol;A=Address;C=Command
      begin
        LAddr := StrToIntDef('$' + Copy(LProt, 5, 4), -1);
        LCmd  := Ord(LProt[9]);
        if (LAddr = aAddr) and Contem(LCmd, aCmdsEsperados) then
        begin
          if Length(aCmdsEsperados) > 1 then
            AData := Copy(LProt, 9)
          else
            AData := Copy(LProt, 10);
          result := True;
        end
        else
          //Delete(aResp, LPosS, LPosE);
          aResp := Copy(aResp, LPosE+1);
      end;

      if Now >= Timeout + EncodeTime(0, 0, 3, 0) then
      begin
        MainForm.ShowStatus('DEBUG: Saindo por timeout em RecebeuRetornoEsperado');
        break;
      end;

    until result or (LPosS = 0);
  end;
end;

initialization

  LCrit := TCriticalSection.Create;

finalization

  LCrit.Free;

end.
