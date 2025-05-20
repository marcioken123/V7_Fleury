unit uDevice;

interface

uses
  System.SysUtils, System.Classes, System.StrUtils, System.JSON, REST.JSON, FireDAC.Comp.Client, FireDAC.Stan.Def,
  FireDAC.Stan.Async, Data.DB;


type
  TDeviceManager      = class;
  TDevice             = class;
  TDeviceUnidade      = class;
  TArrayDeviceUnidade = Array of TDeviceUnidade;
  TListaDeviceUnidade = class;
  TTipoIntegracao     = (tiAPI, tiBanco);


  TDeviceManager = class
  private
    class procedure ValidateURL(var pURL: String; pSufix: String);
  public
    class function BuscarDeviceJSON(pID, pNome, pPath: String; pTipoIntegracao: TTipoIntegracao; pDiasOcioso: Integer = 7): TJSONObject;
    class function BuscarDevice(pID, pNome, pPath: String; pTipoIntegracao: TTIpoIntegracao; pDiasOcioso: Integer = 7): TDevice;
    class function ListarUnidadesJSON(pID, pPath: String; pTipoIntegracao: TTipoIntegracao): TJSONObject;
    class function ListarUnidades(pID, pPath: String; pTipoIntegracao: TTipoIntegracao): TListaDeviceUnidade;
  end;

  TDevice = class
  private
    Fid: String;
    Fstatus: String;
    Fultimo_acesso: TDateTime;
    Fnome: String;
    Frecem_incluido: Boolean;
    procedure Setid(const Value: String);
    procedure Setnome(const Value: String);
    procedure Setstatus(const Value: String);
    procedure Setultimo_acesso(const Value: TDateTime);
    procedure Setrecem_incluido(const Value: Boolean);
  public
    function ToJSON: TJSONObject;

    procedure SendToBD(pBaseUnidades: String; pConnection: TFDConnection);

    procedure LoadFromBD(pID, pNome, pPath: String; pDiasOcioso: Integer = 7);
    procedure LoadFromAPI(pID, pNome, pURL: String);

    property id            : String    read Fid             write Setid;
    property nome          : String    read Fnome           write Setnome;
    property status        : String    read Fstatus         write Setstatus;
    property ultimo_acesso : TDateTime read Fultimo_acesso  write Setultimo_acesso;
    property recem_incluido: Boolean   read Frecem_incluido write Setrecem_incluido;

    constructor Create;
  end;

  TDeviceUnidade = class
  private
    Fid_device: String;
    Fid_unidade: Integer;
    Fnome_unidade: String;
    procedure Setid_device(const Value: String);
    procedure Setid_unidade(const Value: Integer);
    procedure Setnome_unidade(const Value: String);
  public
    property id_device   : String  read Fid_device    write Setid_device;
    property id_unidade  : Integer read Fid_unidade   write Setid_unidade;
    property nome_unidade: String  read Fnome_unidade write Setnome_unidade;
  end;

  TListaDeviceUnidade = class
  private
    FItems: TArrayDeviceUnidade;
    procedure SetItems(const Value: TArrayDeviceUnidade);
  public
    destructor Destroy; override;

    function ToJSON: TJSONObject;

    procedure Add(pDeviceUnidade: TDeviceUnidade);
    procedure Clear;

    procedure LoadFromBD(pID, pPath: String);
    procedure LoadFromAPI(pID, pURL: String);

    property Items: TArrayDeviceUnidade read FItems write SetItems;
  end;

implementation

{ TDevice }

uses ASPHTTPRequest;

constructor TDevice.Create;
begin
  inherited;

  Frecem_incluido := False;
end;

procedure TDevice.LoadFromAPI(pID, pNome, pURL: String);
var
  lResponse: String;
  lStreamRes: TStringStream;
  lDevice: TDevice;
begin
  TDeviceManager.ValidateUrl(pURL, 'tgsmobile/device/');

  lStreamRes := TStringStream.Create;

  try
    THTTPRequest.Get(pURL + pID + '/' + pNome, lStreamRes);

    lResponse := lStreamRes.DataString;

    lResponse := ReplaceStr(lResponse, '{"result":', '');
    lResponse := Copy(lResponse, 1, Length(lResponse) - 1);

    lDevice := TJson.JsonToObject<TDevice>(lResponse);

    try
      Fid            := lDevice.Fid;
      Fnome          := lDevice.nome;
      Fstatus        := lDevice.status;
      Fultimo_acesso := lDevice.ultimo_acesso;
    finally
      lDevice.Free;
    end;
  finally
    FreeAndNil(lStreamRes);
  end;
end;

procedure TDevice.LoadFromBD(pID, pNome, pPath: String; pDiasOcioso: Integer = 7);
const
  SELECT_DEVICE = 'SELECT * FROM DEVICES WHERE ID = ''%s''';
  UPDATE_DEVICE = 'UPDATE DEVICES SET STATUS = ''A'', ULTIMO_ACESSO = :ULTIMO_ACESSO WHERE ID = :ID';

var
  lConn: TFDConnection;
  lDs  : TDataSet;
  lNow : TDateTime;
  lID  : String;
begin
  lConn := TFDConnection.Create(nil);

  try
    {$REGION 'Configurar objeto de conexão'}
    try
      lConn.Close;
      lConn.ConnectionDefName := pPath;
      lConn.Open;
    except
      on E: Exception do
      begin
        raise Exception.Create('Erro ao conectar no banco de dados: ' + E.Message);
      end;
    end;
    {$ENDREGION}

    {$REGION 'Select para buscar device do banco'}
    //Retira chaves e limita a 36 caracteres para gravar no banco
    //Não retirar, pois o request pode ser feito com as chaves no parâmetro do Guid
    lID := Copy(ReplaceStr(ReplaceStr(pID, '{', EmptyStr), '}', EmptyStr).Trim, 1, 36);

    lConn.ExecSQL(Format(SELECT_DEVICE,[lID]), lDs);

    try
      lNow := Now;

      if not lDs.IsEmpty then
      begin
        Fid            := lDs.FieldByName('ID'           ).AsString;
        Fnome          := lDs.FieldByName('NOME'         ).AsString;
        Fultimo_acesso := lDs.FieldByName('ULTIMO_ACESSO').AsDateTime;
        Fstatus        := lDs.FieldByName('STATUS'       ).AsString;

        if (Fstatus = 'A') or
           (Fstatus = 'O') then
        begin
          {$REGION 'Atualiza Data/Hora do último acesso'}
          lConn.ExecSQL(UPDATE_DEVICE, [lNow, pID]);

          Fstatus := IfThen(Fultimo_acesso < Now - pDiasOcioso, 'O', Fstatus);
          {$ENDREGION}
        end;
      end
      else
      begin
        Fid             := lID;
        Fnome           := pNome;
        Frecem_incluido := True;
        Fultimo_acesso  := Now;
        Fstatus         := 'P';

        SendToBD(pPath, lConn);
      end;
    finally
      FreeAndNil(lDs);
    end;
    {$ENDREGION}
  finally
    FreeAndNil(lConn);
  end;
end;

procedure TDevice.SendToBD(pBaseUnidades: String; pConnection: TFDConnection);
const
  INSERT_DEVICE = 'INSERT INTO DEVICES (ID, NOME, STATUS, ULTIMO_ACESSO) VALUES (:ID, :NOME, :STATUS, :ULTIMO_ACESSO)';

var
  sID,
  sNome: String;
begin
  {$REGION 'Persiste na base de dados de unidades'}
  try
    pConnection.StartTransaction;

    //Retira chaves e limita a 36 caracteres para gravar no banco
    sID   := Copy(ReplaceStr(ReplaceStr(Fid, '{', EmptyStr), '}', EmptyStr).Trim, 1, 36);
    sNome := Copy(Fnome, 1, 50);

    pConnection.ExecSQL(INSERT_DEVICE, [sID, sNome, 'P', Now]);

    pConnection.Commit;
  except
    on E: Exception do
    begin
      pConnection.Rollback;
      raise Exception.Create('Erro ao gravar device no banco: ' + E.Message);
    end;
  end;
  {$ENDREGION}
end;

procedure TDevice.Setid(const Value: String);
begin
  Fid := Value;
end;

procedure TDevice.Setnome(const Value: String);
begin
  Fnome := Value;
end;

procedure TDevice.Setrecem_incluido(const Value: Boolean);
begin
  Frecem_incluido := Value;
end;

procedure TDevice.Setstatus(const Value: String);
begin
  Fstatus := Value;
end;

procedure TDevice.Setultimo_acesso(const Value: TDateTime);
begin
  Fultimo_acesso := Value;
end;

function TDevice.ToJSON: TJSONObject;
begin
  Result := TJson.ObjectToJsonObject(Self);
end;

{ TDeviceManager }

class function TDeviceManager.BuscarDeviceJSON(pID, pNome, pPath: String; pTipoIntegracao: TTipoIntegracao;
  pDiasOcioso: Integer = 7): TJSONObject;
var
  lDevice: TDevice;
begin
  lDevice := BuscarDevice(pId, pNome, pPath, pTipoIntegracao, pDiasOcioso);

  try
    Result := lDevice.ToJSON;
  finally
    lDevice.Free;
  end;
end;

class function TDeviceManager.BuscarDevice(pID, pNome, pPath: String; pTipoIntegracao: TTIpoIntegracao;
  pDiasOcioso: Integer = 7): TDevice;
var
  lDevice: TDevice;
begin
  lDevice := TDevice.Create;

  case pTipoIntegracao of
    tiAPI  : {$REGION 'API'}
    begin
      lDevice.LoadFromAPI(pID, pNome, pPath);
    end;
    {$ENDREGION}
    tiBanco: {$REGION 'Banco'}
    begin
      lDevice.LoadFromBD(pID, pNome, pPath, pDiasOcioso);
    end;
    {$ENDREGION}
  end;

  Result := lDevice;
end;


class function TDeviceManager.ListarUnidades(pID, pPath: String; pTipoIntegracao: TTipoIntegracao): TListaDeviceUnidade;
var
  lListaDeviceUnidade: TListaDeviceUnidade;
begin
  lListaDeviceUnidade := TListaDeviceUnidade.Create;

  case pTipoIntegracao of
    tiAPI  : {$REGION 'API'}
    begin
      lListaDeviceUnidade.LoadFromAPI(pID, pPath);
    end;
    {$ENDREGION}
    tiBanco: {$REGION 'Banco'}
    begin
      lListaDeviceUnidade.LoadFromBD(pID, pPath);
    end;
    {$ENDREGION}
  end;

  Result := lListaDeviceUnidade
end;

class function TDeviceManager.ListarUnidadesJSON(pID, pPath: String; pTipoIntegracao: TTipoIntegracao): TJSONObject;
var
  lListaDeviceUnidade: TListaDeviceUnidade;
begin
  lListaDeviceUnidade := ListarUnidades(pId, pPath, pTipoIntegracao);

  try
    Result := lListaDeviceUnidade.ToJSON;
  finally
    lListaDeviceUnidade.Free;
  end;
end;

class procedure TDeviceManager.ValidateURL(var pURL: String; pSufix: String);
  procedure SlashAtEnd(var AStr: String);
  begin
    if RightStr(AStr, 1) <> '/' then
    begin
      AStr := AStr + '/';
    end;
  end;
begin
  if not pURL.StartsWith('http://', True) then
  begin
    pURL := 'http://' + pURL;
  end;

  SlashAtEnd(pURL);

  SlashAtEnd(pSufix);

  pURL := pURL + pSufix;
end;

{ TDeviceUnidade }

procedure TDeviceUnidade.Setid_device(const Value: String);
begin
  Fid_device := Value;
end;

procedure TDeviceUnidade.Setid_unidade(const Value: Integer);
begin
  Fid_unidade := Value;
end;

procedure TDeviceUnidade.Setnome_unidade(const Value: String);
begin
  Fnome_unidade := Value;
end;

{ TListaDeviceUnidade }

procedure TListaDeviceUnidade.Add(pDeviceUnidade: TDeviceUnidade);
begin
  SetLength(FItems, Length(FItems) + 1);
  FItems[High(FItems)] := pDeviceUnidade;
end;

procedure TListaDeviceUnidade.Clear;
var
  i: Integer;
begin
  for i := 0 to High(FItems) do
  begin
    if Assigned(FItems[i]) then
    begin
      FreeAndNil(FItems[i]);
    end;
  end;

  SetLength(FItems, 0);
end;

destructor TListaDeviceUnidade.Destroy;
begin
  Clear;

  inherited;
end;

procedure TListaDeviceUnidade.LoadFromAPI(pID, pURL: String);
var
  lResponse: String;
  lStreamRes: TStringStream;
  lListaDeviceUnidade: TListaDeviceUnidade;
  lDeviceUnidade: TDeviceUnidade;
  i: Integer;
begin
  TDeviceManager.ValidateUrl(pURL, 'tgsmobile/deviceunidades/');

  lStreamRes := TStringStream.Create;

  try
    THTTPRequest.Get(pURL + pID, lStreamRes);

    lResponse := lStreamRes.DataString;

    lResponse := ReplaceStr(lResponse, '{"result":', '');
    lResponse := Copy(lResponse, 1, Length(lResponse) - 1);

    lListaDeviceUnidade := TJson.JsonToObject<TListaDeviceUnidade>(lResponse);

    try
      Clear;
      
      for i := 0 to High(lListaDeviceUnidade.Items) do
      begin
        lDeviceUnidade := TDeviceUnidade.Create;

        lDeviceUnidade.id_device    := lListaDeviceUnidade.Items[i].id_device;
        lDeviceUnidade.id_unidade   := lListaDeviceUnidade.Items[i].id_unidade;
        lDeviceUnidade.nome_unidade := lListaDeviceUnidade.Items[i].nome_unidade;

        Add(lDeviceUnidade);
      end;
    finally
      lListaDeviceUnidade.Free;
    end;
  finally
    FreeAndNil(lStreamRes);
  end;
end;

procedure TListaDeviceUnidade.LoadFromBD(pID, pPath: String);
const
  SELECT_DEVICE_UNIDADE = 'SELECT                                           ' + sLineBreak +
                          '  DU.ID_DEVICE,                                  ' + sLineBreak +
                          '  DU.ID_UNIDADE,                                 ' + sLineBreak +
                          '  U.NOME                                         ' + sLineBreak +
                          'FROM                                             ' + sLineBreak +
                          '  DEVICES_UNIDADES DU                            ' + sLineBreak +
                          '  INNER JOIN UNIDADES U ON (U.ID = DU.ID_UNIDADE)' + sLineBreak +
                          'WHERE                                            ' + sLineBreak +
                          '  DU.ID_DEVICE = ''%s''                          ' + sLineBreak +
                          'ORDER BY                                         ' + sLineBreak +
                          '  DU.ID_UNIDADE';

var
  lConn: TFDConnection;
  lDs  : TDataSet;
  lDeviceUnidade: TDeviceUnidade;
begin
  lConn := TFDConnection.Create(nil);

  try
    {$REGION 'Configurar objeto de conexão'}
    try
      lConn.Close;
      lConn.ConnectionDefName := pPath;
      lConn.Open;
    except
      on E: Exception do
      begin
        raise Exception.Create('Erro ao conectar no banco de dados: ' + E.Message);
      end;
    end;
    {$ENDREGION}

    {$REGION 'Select para buscar unidades do device do banco'}
    lConn.ExecSQL(Format(SELECT_DEVICE_UNIDADE,[pID]), lDs);

    try
      lDs.First;

      while not lDs.Eof do
      begin
        lDeviceUnidade := TDeviceUnidade.Create;
        lDeviceUnidade.id_device    := lDs.FieldByName('ID_DEVICE' ).AsString;
        lDeviceUnidade.id_unidade   := lDs.FieldByName('ID_UNIDADE').AsInteger;
        lDeviceUnidade.nome_unidade := lDs.FieldByName('NOME'      ).AsString;

        Add(lDeviceUnidade);

        lDs.Next;
      end;
    finally
      FreeAndNil(lDs);
    end;
    {$ENDREGION}
  finally
    FreeAndNil(lConn);
  end;
end;

procedure TListaDeviceUnidade.SetItems(const Value: TArrayDeviceUnidade);
begin
  FItems := Value;
end;

function TListaDeviceUnidade.ToJSON: TJSONObject;
begin
  Result := TJson.ObjectToJsonObject(Self);
end;

end.
