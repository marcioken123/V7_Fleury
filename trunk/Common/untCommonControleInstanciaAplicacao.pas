unit untCommonControleInstanciaAplicacao;

{$INCLUDE ..\AspDefineDiretivas.inc}

interface

uses
  System.SysUtils, System.Classes, IdCustomTCPServer, IdTCPServer,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, MyAspFuncoesUteis,
  FMX.Dialogs, IdSync,
  {$IFDEF CompilarPara_PA}         untSicsPA,                          {$ENDIF}
  {$IFDEF CompilarPara_Online}     untSicsOnLine,                      {$ENDIF}
  {$IFDEF CompilarPara_TGS}        untMainForm,                        {$ENDIF}
  {$IFDEF CompilarPara_MULTIPA}    untSicsMultiPA,                     {$ENDIF}
  {$IFDEF CompilarPara_CALLCENTER} untSicsCallCenter,                  {$ENDIF}
  {$IFDEF CompilarPara_TotemAA}    ufrmSplash, UfrmSicsTotemAA,        {$ENDIF}
  IdContext,IniFiles;
type
  {$IFDEF CompilarPara_PA}         TTipoGenerico = TFrmSicsPA;         {$ENDIF}
  {$IFDEF CompilarPara_Online}     TTipoGenerico = TFrmSicsOnLine;     {$ENDIF}
  {$IFDEF CompilarPara_TGS}        TTipoGenerico = TMainForm;          {$ENDIF}
  {$IFDEF CompilarPara_MULTIPA}    TTipoGenerico = TFrmSicsMultiPA;    {$ENDIF}
  {$IFDEF CompilarPara_CALLCENTER} TTipoGenerico = TFrmSicsCallCenter; {$ENDIF}
  {$IFDEF CompilarPara_TotemAA}    TTipoGenerico = TfrmSicsTotemAA;    {$ENDIF}
  TdmControleInstanciaAplicacao = class(TDataModule)
    client: TIdTCPClient;
    server: TIdTCPServer;
    procedure DataModuleCreate(Sender: TObject);
    procedure serverExecute(AContext: TIdContext);
  private
    { Private declarations }
        FTela : TTipoGenerico;

    function GetSelfPort :  integer;
  public
    { Public declarations }
        property Tela : TTipoGenerico read FTela write FTela;
  end;

var
  dmControleInstanciaAplicacao: TdmControleInstanciaAplicacao;

implementation


{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

type
  TMySync = class(TIdSync)
  protected
    procedure DoSynchronize; override;
  public
    data: string;
    tela : TTipoGenerico;
  end;

procedure TdmControleInstanciaAplicacao.DataModuleCreate(Sender: TObject);
begin
  {$IF defined(IS_MOBILE)}
  //faz nada caso mobile, pois nunca será possível abrir 2 instâncias da App
  {$ELSE}
  client.Port := GetSelfPort;
  server.DefaultPort := Client.Port;
  if (ContaProcessos(ApplicationName(true)) > 1) then
  begin
    client.Connect;

    if client.Connected then
    begin
      client.IOHandler.WriteLn('Fecha');
      client.Disconnect;
      Sleep(1000);
    end;
  end;

  try
    server.Active := true;
  except
    ShowMessage('Já existe uma instância escutando na porta '+inttostr(client.Port));
    Halt;
  end;
  {$ENDIF}
end;


function TdmControleInstanciaAplicacao.GetSelfPort: integer;
  {$IFDEF CompilarPara_Online}     const PORTA_PADRAO = 6030; {$ENDIF}
  {$IFDEF CompilarPara_TGS}        const PORTA_PADRAO = 6031; {$ENDIF}
  {$IFDEF CompilarPara_MULTIPA}    const PORTA_PADRAO = 6032; {$ENDIF}
  {$IFDEF CompilarPara_PA}         const PORTA_PADRAO = 6033; {$ENDIF}
  {$IFDEF CompilarPara_CALLCENTER} const PORTA_PADRAO = 6034; {$ENDIF}
  {$IFDEF CompilarPara_TotemAA}    const PORTA_PADRAO = 6035; {$ENDIF}
begin
  with TIniFile.Create(AspLib_GetAppIniFileName) do
  try
    Result := ReadInteger ('Conexoes','TCPSelfPort', PORTA_PADRAO);
    WriteInteger ('Conexoes', 'TCPSelfPort' , Result);
  finally
    Free;
  end;
end;


procedure TdmControleInstanciaAplicacao.serverExecute(AContext: TIdContext);
var
//  s    : string;
  sync : TMySync;
begin
  if (AContext.Connection.IOHandler.ReadLn = 'Fecha') then
  begin
    sync := TMySync.Create;
    try
      sync.data := 'Fecha';
      sync.tela := FTela;
      sync.Synchronize;
    finally
      Sync.Free;
    end;
  end;
end;

{ TMySync }

procedure TMySync.DoSynchronize;
begin
  inherited;
  if(data = 'Fecha')then
  begin
   Tela.Fechar;     // Halt(0); //
  end
end;

end.
