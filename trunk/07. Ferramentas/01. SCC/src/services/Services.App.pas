unit Services.App;

interface

uses System.SysUtils, System.Classes,

  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Phys.FBDef, FireDAC.Phys.IBBase,
  FireDAC.Phys.FB, Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, Providers.Connection;

type
  TServiceApp = class(TProviderConnection)
    qryTotenVersion: TFDQuery;
    qryTotenVersionID_TOTEM: TIntegerField;
    qryTotenVersionID_TIPOEXECUTAVEL: TIntegerField;
    qryTotenVersionVERSAO_ANTERIOR_ID: TIntegerField;
    qryTotenVersionVERSAO_ANTERIOR_DEPLOYED_POR: TIntegerField;
    qryTotenVersionVERSAO_ANTERIOR_DEPLOYED_EM: TSQLTimeStampField;
    qryTotenVersionVERSAO_ATUAL_ID: TIntegerField;
    qryTotenVersionVERSAO_ATUAL_DEPLOYED_POR: TIntegerField;
    qryTotenVersionVERSAO_ATUAL_DEPLOYED_EM: TSQLTimeStampField;
    qryTotenVersionVERSAO_PROXIMA_ID: TIntegerField;
    qryTotenVersionVERSAO_PROXIMA_DEPLOYED_POR: TIntegerField;
    qryTotenVersionVERSAO_PROXIMA_DEPLOYED_EM: TSQLTimeStampField;
    qryTotenVersionID_STATUS_DEPLOY: TIntegerField;
    qryExecutavel: TFDQuery;
    qryExecutavelID: TIntegerField;
    qryExecutavelID_TIPO: TIntegerField;
    qryExecutavelORIGINAL_FILENAME: TStringField;
    qryExecutavelORIGINAL_FILESIZE: TIntegerField;
    qryExecutavelVERSAO: TStringField;
    qryExecutavelBINARIO: TBlobField;
    qryExecutavelBINARIO_HASH: TStringField;
    qryExecutavelUPLOADED_POR: TIntegerField;
    qryExecutavelUPLOADED_EM: TSQLTimeStampField;
    qryExecutavelULTIMOUSO_EM: TSQLTimeStampField;
    qryExecutavelDELETADO: TStringField;
  public
    //LConexao: TFDConnection;
    procedure SetStartedDeploy;
    procedure SetCurrentVersion(const AIdToten: Integer; const ACurrentVersion: string);
    function HasUpdate(const AIdToten: Integer; const ACurrentVersion: string): Boolean;
    function GetFileStream: TStream;
    function GetQryExecutavel: TFDQuery;
  end;

implementation

uses UConexaoBD, uSMTotem, SCC_m;

{$R *.dfm}

function TServiceApp.GetQryExecutavel: TFDQuery;
begin
  Result := qryExecutavel;
end;

function TServiceApp.GetFileStream: TStream;
var
  LConexao: TFDConnection;
begin
  try
  {$REGION 'Configurar objeto de conexão'}
  LConexao := TFDConnection.Create(nil);
    try
      LConexao.Close;
      LConexao.LoginPrompt := False;
      LConexao.ConnectionDefName := TConexaoBD.NomeBasePadrao(0);
      LConexao.Open;
    except
      on E: Exception do
      begin
        raise Exception.Create('Erro ao configurar objeto de conexão GetFileStream('+MainForm.CaminhoBDUnidades+'): ' + E.Message);
      end;
    end;
    {$ENDREGION}
    qryExecutavel.Connection := LConexao;

    MainForm.FID_versao := qryTotenVersion.FieldByName('versao_proxima_id').AsInteger;

    Result := TMemoryStream.Create;

    if (not qryTotenVersionVERSAO_PROXIMA_ID.IsNull) and (qryTotenVersionVERSAO_PROXIMA_ID.AsInteger > 0) then
      qryExecutavel.ParamByName('id').AsInteger := qryTotenVersionVERSAO_PROXIMA_ID.AsInteger
    else if (not qryTotenVersionVERSAO_ATUAL_ID.IsNull) and (qryTotenVersionVERSAO_ATUAL_ID.AsInteger > 0) then
      qryExecutavel.ParamByName('id').AsInteger := qryTotenVersionVERSAO_ATUAL_ID.AsInteger;

    if qryExecutavel.ParamByName('id').AsInteger > 0 then
    begin
      qryExecutavel.ParamByName('id').AsInteger := qryTotenVersionVERSAO_PROXIMA_ID.AsInteger;
      qryExecutavel.Open();
      qryExecutavelBINARIO.SaveToStream(Result);
    end;
  finally
    LConexao.Free;
  end;
end;

function TServiceApp.HasUpdate(const AIdToten: Integer; const ACurrentVersion: string): Boolean;
var
  LConexao: TFDConnection;
  LQuery: TFDQuery;
  LIdCurrentVersion: Integer;
begin
  LIdCurrentVersion := 0;
  LConexao := TFDConnection.Create(Self);
  LQuery := TFDQuery.Create(nil);
  try
    {$REGION 'Configurar objeto de conexão'}
    try
      LConexao.Close;
      LConexao.LoginPrompt := False;
      LConexao.ConnectionDefName := TConexaoBD.NomeBasePadrao(0);
      LConexao.Open;
    except
      on E: Exception do
      begin
        raise Exception.Create('Erro ao configurar objeto de conexão HasUpdate('+MainForm.CaminhoBDUnidades+'): ' + E.Message);
      end;
    end;
    {$ENDREGION}
    LQuery.Connection := LConexao;
    LQuery.SQL.Add('select id');
    LQuery.SQL.Add('from executaveis');
    LQuery.SQL.Add('where versao = :versao');
    LQuery.SQL.Add('  and deletado = ''F''');
    LQuery.ParamByName('versao').AsString := ACurrentVersion;
    LQuery.Open;
    if (not LQuery.Eof) and (not LQuery.FieldByName('id').IsNull) then
    begin
      LIdCurrentVersion := LQuery.FieldByName('id').AsInteger;
    end;
    if LIdCurrentVersion > 0 then
    begin
      qryTotenVersion.Connection := LConexao;
      qryTotenVersion.ParamByName('id_totem').AsInteger := AIdToten;
      qryTotenVersion.Open();
      if not qryTotenVersion.FieldByName('versao_proxima_id').IsNull then
      begin
        if qryTotenVersion.FieldByName('versao_proxima_id').AsInteger = LIdCurrentVersion then
        begin
          Result:=False;
        end
        else
          Result:=True;
      end
      else
      begin
        if not qryTotenVersion.FieldByName('versao_atual_id').IsNull then
        begin
          if qryTotenVersion.FieldByName('versao_atual_id').AsInteger = LIdCurrentVersion then
            Result:=False
          else
            Result:=True;
        end
        else
          Result:=False;
      end;

    end
    else
    begin
      qryTotenVersion.Connection := LConexao;
      qryTotenVersion.ParamByName('id_totem').AsInteger := AIdToten;
      qryTotenVersion.Open();
      if not qryTotenVersion.FieldByName('versao_proxima_id').IsNull then
        Result:=True
      else
        if not qryTotenVersion.FieldByName('versao_atual_id').IsNull then
          Result:=True
        else
          Result:=False;
    end;
  finally
    LQuery.Free;
    LConexao.Free;
  end;
end;

procedure TServiceApp.SetCurrentVersion(const AIdToten: Integer; const ACurrentVersion: string);
var
  LConexao: TFDConnection;
  LQuery: TFDQuery;
  LIdCurrentVersion: Integer;
begin
  LIdCurrentVersion := 0;
  LConexao := TFDConnection.Create(Self);
  LQuery := TFDQuery.Create(nil);
  try
    {$REGION 'Configurar objeto de conexão'}
    try
      LConexao.Close;
      LConexao.LoginPrompt := False;
      LConexao.ConnectionDefName := TConexaoBD.NomeBasePadrao(0);
      LConexao.Open;
    except
      on E: Exception do
      begin
        raise Exception.Create('Erro ao configurar objeto de conexão - SetCurrentVersion('+MainForm.CaminhoBDUnidades+'): ' + E.Message);
      end;
    end;
    {$ENDREGION}

    LQuery.Connection := LConexao;
    LQuery.SQL.Add('select id');
    LQuery.SQL.Add('from executaveis');
    LQuery.SQL.Add('where versao = :versao');
    LQuery.SQL.Add('  and deletado = ''F''');
    LQuery.ParamByName('versao').AsString := ACurrentVersion;
    LQuery.Open;
    if (not LQuery.Eof) and (not LQuery.FieldByName('id').IsNull) then
    begin
      LIdCurrentVersion := LQuery.FieldByName('id').AsInteger;
    end;
    if LIdCurrentVersion > 0 then
    begin
      LQuery.Connection := LConexao;
      LQuery.SQL.Clear;
      LQuery.SQL.Add('update totens_versoes');
      LQuery.SQL.Add('   set id_status_deploy = 2, versao_proxima_id = null,');
      LQuery.SQL.Add('   versao_atual_id = :versao');
      LQuery.SQL.Add(' where id_totem = :id_totem');
      LQuery.SQL.Add('   and id_status_deploy = 1');
      LQuery.SQL.Add('   and versao_proxima_id = :versao');
      LQuery.ParamByName('versao').AsInteger := LIdCurrentVersion;
      LQuery.ParamByName('id_totem').AsInteger := AIdToten;
      LQuery.ExecSQL;
    end;
  finally
    LQuery.Free;
    LConexao.Free;
  end;
end;

procedure TServiceApp.SetStartedDeploy;
begin
  qryTotenVersion.Edit;
  qryTotenVersionID_STATUS_DEPLOY.AsInteger := 1;
  qryTotenVersion.Post;
end;

initialization

finalization;

end.
