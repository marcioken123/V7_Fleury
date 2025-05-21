unit Controllers.App;

interface

procedure Registry;

implementation

uses System.SysUtils, System.StrUtils, Horse, Services.App, System.JSON, Providers.Consts,SCC_m, FireDAC.Comp.Client, uSMTotem,
  UConexaoBD;

procedure DoAppVersion(Req: THorseRequest; Res: THorseResponse);
var
  LIdToten: Integer;
  LService: TServiceApp;
  LVersaoAtualAplicativo: string;
  Lhasupdate:Boolean;
begin
  LService := TServiceApp.Create;
  try
    LIdToten := Req.Params.Field('id').AsInteger;
    LVersaoAtualAplicativo := Req.Body<TJSONObject>.GetValue('version').Value;
    MainForm.ShowStatus('Consultando Update para o Totem ' + LIdToten.ToString + ' na versão ' + LVersaoAtualAplicativo);
    Lhasupdate:= LService.HasUpdate(LIdToten,LVersaoAtualAplicativo);
    LService.SetCurrentVersion(LIdToten, LVersaoAtualAplicativo);
    Res.Send(TJSONObject.Create.AddPair('hasUpdate', TJSONBool.Create(Lhasupdate)));
    MainForm.ShowStatus('Update para o Totem ' + LIdToten.ToString + ': ' + IfThen(Lhasupdate,'SIM','NÃO'));
  finally
    LService.Free;
  end;
end;

procedure DoDownloadApp(Req: THorseRequest; Res: THorseResponse);
var
  LService: TServiceApp;
  LConexao: TFDConnection;
begin
  LService := TServiceApp.Create;
  LConexao := TFDConnection.Create(nil);
  try
    {$REGION 'Configurar objeto de conexão'}
    try
      LConexao.Close;
      LConexao.LoginPrompt := False;
      //LConexao.ConnectionDefName := LService.ConfigurarConexaoBDUnidade('0');
      LConexao.ConnectionDefName := TConexaoBD.NomeBasePadrao(0);
      LConexao.Open;
    except
      on E: Exception do
      begin
        raise Exception.Create('Erro ao configurar objeto de conexão DoDownloadApp('+MainForm.CaminhoBDUnidades+'): ' + E.Message);
      end;
    end;
    {$ENDREGION}
    LService.qryTotenVersion.Connection := LConexao;
    LService.qryTotenVersion.Close;
    LService.qryTotenVersion.ParamByName('id_totem').AsInteger := Req.Params.Field('id').AsInteger;
    LService.qryTotenVersion.Open();

    if LService.qryTotenVersion.eof then
      raise EHorseException.New.Error('Nenhuma versão disponível para download').Status(THTTPStatus.BadRequest);
    MainForm.ShowStatus('Iniciando o download do Update para o Totem ' + LService.qryTotenVersion.ParamByName('id_totem').AsString);
    LService.SetStartedDeploy;
    //Res.RawWebResponse.SetCustomHeader('x-hash', '1357130682739986173985613968');
    Res.ContentType('application/zip').Send(LService.GetFileStream);

    MainForm.ShowStatus('Download do Update para o Totem ' + LService.qryTotenVersion.ParamByName('id_totem').AsString + ' concluído');
  finally
    LService.Free;
    FreeAndNil(LConexao);
  end;
end;

procedure Registry;
begin
  THorse.Post('/aspect/horse/totem/versao/:id', DoAppVersion);
  THorse.Get('/aspect/horse/totem/download/:id', DoDownloadApp);
end;

initialization

finalization;

end.
