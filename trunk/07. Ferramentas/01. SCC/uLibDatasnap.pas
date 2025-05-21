unit uLibDatasnap;

interface

uses System.JSON, System.SysUtils, untDmUnidadesScc, untDmTabelasScc,
     Data.DB, MyDlls_DR;

type
  TDadosConexaoUnidade = record
    Address: String;
    Port: Integer;
  end;

type
  TLibDataSnap = class
  private

    class var FProcStatusChange: TProc<string>;
    class var FSocketAdress: String;
    class var FSocketPort: Integer;
    class var FDBOSAuthent: Boolean;
    class var FDBSenha: String;
    class var FDBHost: String;
    class var FDBUsuario: String;
    class var FDBBanco: String;
    class function GetConexaoUnidade(const AId: String): TDadosConexaoUnidade; static;
    class var FDadosUnidades: String;
    class var FDiasDeviceOcioso: Integer;
    class procedure SetDadosUnidades(const Value: String); static;
    class procedure SetDiasDeviceOcioso(const Value: Integer); static;
    class procedure SetDBBanco(const Value: String); static;
    class procedure SetDBHost(const Value: String); static;
    class procedure SetDBOSAuthent(const Value: Boolean); static;
    class procedure SetDBSenha(const Value: String); static;
    class procedure SetDBUsuario(const Value: String); static;
  public
    class var dmUnidades: TdmUnidadesScc;
    class var dmTabelas: TdmTabelasScc;
    class property SocketAdress: String read FSocketAdress write FSocketAdress;
    class property SocketPort: Integer read FSocketPort write FSocketPort;
    class property ProcStatusChange: TProc<string> read FProcStatusChange write FProcStatusChange;
    class property ConexaoUnidade[const AId: String]: TDadosConexaoUnidade read GetConexaoUnidade;

    class property DadosUnidades: String read FDadosUnidades write SetDadosUnidades;
    class property DBHost: String read FDBHost write SetDBHost;
    class property DBBanco: String read FDBBanco write SetDBBanco;
    class property DBUsuario: String read FDBUsuario write SetDBUsuario;
    class property DBSenha: String read FDBSenha write SetDBSenha;
    class property DBOSAuthent: Boolean read FDBOSAuthent write SetDBOSAuthent;
    class property DiasDeviceOcioso: Integer read FDiasDeviceOcioso write SetDiasDeviceOcioso;

    class procedure AbortWithInvalidRequest(AMsg: String);
    class function ValidateInputParams(const aParams: TJSONObject; const aExpectedNames: array of string): Boolean;
    class procedure UpdateStatus(aMsg: String; const AIdUnidade: String);
    class function GetSortableDateTimeString(aDateTime: TDateTime): String;
    class function CarregarParametrosUnidades(const CaminhoBD, DBHost, DBBanco, DBUsuario, DBSenha: String;
      DBOSAuthent: Boolean; DiasDeviceOcioso: Integer): Boolean;
  end;

implementation

uses
  Data.DBXPlatform, System.Classes, VCL.SvcMgr, VCL.Forms, uFuncoes,
  UConexaoBD;

class procedure TLibDataSnap.AbortWithInvalidRequest(AMsg: String);
var
  LJObj: TJSONObject;
begin
  GetInvocationMetadata.ResponseCode := 400;
  GetInvocationMetadata.ResponseMessage := AMsg;
  LJObj := TJSONObject.Create;
  try
    LJObj.AddPair('error', AMsg);
    GetInvocationMetadata.ResponseContent := LJObj.ToString;
  finally
    LJObj.Free;
  end;
  abort;
end;

class function TLibDataSnap.CarregarParametrosUnidades(const CaminhoBD, DBHost, DBBanco, DBUsuario, DBSenha: String;
  DBOSAuthent: Boolean; DiasDeviceOcioso: Integer): Boolean;
begin
  result := False;
  try
    if not Assigned(TLibDataSnap.dmUnidades) then
    begin
      if GetIsService then
        TLibDataSnap.dmUnidades := TdmUnidadesScc.Create(Vcl.SvcMgr.Application)
      else
        TLibDataSnap.dmUnidades := TdmUnidadesScc.Create(Vcl.Forms.Application);
    end;

    if not Assigned(TLibDataSnap.dmTabelas) then
    begin
      if GetIsService then
        TLibDataSnap.dmTabelas := TdmTabelasScc.Create(Vcl.SvcMgr.Application)
      else
        TLibDataSnap.dmTabelas := TdmTabelasScc.Create(Vcl.Forms.Application);
    end;

    FDadosUnidades    := CaminhoBD;
    FDBHost           := DBHost;
    FDBBanco          := DBBanco;
    FDBUsuario        := DBUsuario;
    FDBSenha          := DBSenha;
    FDBOSAuthent      := DBOSAuthent;
    FDiasDeviceOcioso := DiasDeviceOcioso;

    System.TMonitor.Enter(TLibDataSnap.dmUnidades);
    try
      //RA
      //TLibDataSnap.dmUnidades.CarregarDados(CaminhoBD);
      TLibDataSnap.dmUnidades.CarregarDados(CaminhoBD,
                                            DBHost,
                                            DBBanco,
                                            DBUsuario,
                                            DBSenha,
                                            DBOSAuthent);
    finally
      System.TMonitor.Exit(TLibDataSnap.dmUnidades);
    end;

    System.TMonitor.Enter(TLibDataSnap.dmTabelas);
    try
      //WOS
      TLibDataSnap.dmTabelas.CarregarDados(CaminhoBD,
                                           DBHost,
                                           DBBanco,
                                           DBUsuario,
                                           DBSenha,
                                           DBOSAuthent);
    finally
      System.TMonitor.Exit(TLibDataSnap.dmTabelas);
    end;

    with TLibDataSnap.dmTabelas.ConsultarDados('SELECT ID, DBDIR, HOST, BANCO, USUARIO, SENHA, OSAUTHENT, ID_UNID_CLI FROM UNIDADES') do
    begin
      while not Eof do
      begin
        TConexaoBD.GetConnection(FieldByName('DBDIR').AsString,
                                 FieldByName('HOST').AsString,
                                 FieldByName('BANCO').AsString,
                                 FieldByName('USUARIO').AsString,
                                 FieldByName('SENHA').AsString,
                                 FieldByName('OSAUTHENT').AsString='T',
                                 FieldByName('ID').AsInteger);

        TConexaoBD.GetConnection(FieldByName('DBDIR').AsString,
                                 FieldByName('HOST').AsString,
                                 FieldByName('BANCO').AsString,
                                 FieldByName('USUARIO').AsString,
                                 FieldByName('SENHA').AsString,
                                 FieldByName('OSAUTHENT').AsString='T',
                                 FieldByName('ID_UNID_CLI').AsInteger);
        Next;
      end;
    end;

    result := True;
  except
    on E: Exception do
    begin
      MyLogException(Exception.Create(
        FormatDateTime('dd/mm/yy  hh:nn:ss', now) + ' - ' +
        'Classe: ' + E.ClassName + ' - ' + '  Erro: ' + E.Message ));
      result := False;
    end;
  end;
end;

class function TLibDataSnap.GetConexaoUnidade(const AId: String): TDadosConexaoUnidade;
begin
  if not Assigned(TLibDataSnap.dmUnidades) then
  begin
    result.address := FSocketAdress;
    result.port    := FSocketPort;
  end
  else
  begin
    System.TMonitor.Enter(TLibDataSnap.dmUnidades);
    try
      if AId <> EmptyStr then
      begin
        if dmUnidades.cdsUn.Active and
           dmUnidades.cdsUn.Locate('ID_UNID_CLI', AId, [loCaseInsensitive]) then
        begin
          result.Address := TLibDataSnap.dmUnidades.cdsUn.FieldByName('IP').AsString;
          result.Port    := TLibDataSnap.dmUnidades.cdsUn.FieldByName('PORTA').AsInteger;
        end
        else
          raise Exception.Create('Unidade não localizada');
      end
      else
        raise Exception.Create('Unidade não informada');
    finally
      System.TMonitor.Exit(TLibDataSnap.dmUnidades);
    end;
  end;
end;

class function TLibDataSnap.GetSortableDateTimeString(aDateTime: TDateTime): String;
begin
  result := FormatDateTime('yyyy"-"mm"-"dd"T"hh":"mm":"ss"."ZZZ"Z"', aDateTime);
end;

class procedure TLibDataSnap.SetDadosUnidades(const Value: String);
begin
  FDadosUnidades := Value;
end;

class procedure TLibDataSnap.SetDBBanco(const Value: String);
begin
  FDBBanco := Value;
end;

class procedure TLibDataSnap.SetDBHost(const Value: String);
begin
  FDBHost := Value;
end;

class procedure TLibDataSnap.SetDBOSAuthent(const Value: Boolean);
begin
  FDBOSAuthent := Value;
end;

class procedure TLibDataSnap.SetDBSenha(const Value: String);
begin
  FDBSenha := Value;
end;

class procedure TLibDataSnap.SetDBUsuario(const Value: String);
begin
  FDBUsuario := Value;
end;

class procedure TLibDataSnap.SetDiasDeviceOcioso(const Value: Integer);
begin
  FDiasDeviceOcioso := Value;
end;

class procedure TLibDataSnap.UpdateStatus(aMsg: String; const AIdUnidade: String);
begin
  if Assigned(FProcStatusChange) then
  begin
    if AIdUnidade <> EmptyStr then
      AMsg := '[' + AIdUnidade + '] ' + AMsg;
    TThread.Queue (nil, procedure
                        begin
                          FProcStatusChange(aMsg);
                        end
                  );
  end;
end;

class function TLibDataSnap.ValidateInputParams(const aParams: TJSONObject; const aExpectedNames: array of string): Boolean;

  procedure Abortar;
  const
    MSG = 'Invalid input params. Expecting: %s';
  var
    LMsg, LParamsStr : String;
    c                : Integer;
  begin
    LParamsStr := EmptyStr;
    for c := Low(aExpectedNames) to High(aExpectedNames) do
    begin
      if (c = High(aExpectedNames)) and (c > 0) then
        LParamsStr := LParamsStr + ' and ' + '''' + aExpectedNames[c]  + ''''
      else
        LParamsStr := LParamsStr + ', ' + '''' + aExpectedNames[c]  + '''';
    end;
    Delete(LParamsStr, 1, 2);
    LMsg := Format(MSG, [LParamsStr]);

    AbortWithInvalidRequest(LMsg);
  end;

var
  i: Integer;
begin
  if not Assigned(aParams) then
    Abortar;

  try
    if aParams.Count < Length(aExpectedNames) then
      Abortar;
  except
    Abortar;
  end;

  for i := Low(aExpectedNames) to High(aExpectedNames) do
    if aParams.Values[aExpectedNames[i]] = nil then
      Abortar;

  result := True;
end;

end.
