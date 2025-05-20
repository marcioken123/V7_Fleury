unit uPI;

interface

uses
  System.Classes, System.SysUtils, System.StrUtils, Datasnap.DBClient,
  System.JSON, REST.JSON, Data.DB,
  FireDAC.Comp.Client, FireDAC.Stan.Def, FireDAC.Stan.Async;

type
  TPIManager      = class;
  TPI             = class;
  TArrayPI        = Array of TPI;
  TListaPI        = class;
  TArrayListaPI   = Array of TListaPI;
  TMultiPI        = class;
  TTipoIntegracao = (tiAPI, tiBanco, tiSocket);

  TPIManager = class
  private
    class procedure ValidateURL(var AUrl: String; ASufix: String);
  public
    class procedure IntegrarPIs(pID: Integer; pTipoIntegracao: TTipoIntegracao; pCds: TClientDataSet; pPath: String = '');

    class function BuscarPIs(pUnidades, pPath: String; pTipoIntegracao: TTipoIntegracao): TJSONObject; overload;
    class function BuscarPIs(pUnidades, pPath: String; pCds: TClientDataSet): String; overload;
    class function GetMultiPIFromAPI(pUnidades, pURL: String): TJSONObject;
    class function BuscarPIsPossiveis(pPath: String; pTipoIntegracao: TTipoIntegracao): TJSONObject;
    class function GetPIsPossiveisFromAPI(pURL: String): TJSONObject;
  end;

  TPI = class
  private
    Fpinome: String;
    Fvalor: String;
    Fposicaonivel: Integer;
    Fnomenivel: String;
    Fcodigocor: Integer;
    Fid_pinivel: Integer;
    Fvalor_numerico: Integer;
    Fflag_valor_em_segundos: String;
    Fcreatedat: TDateTime;

    procedure Setpinome(const Value: String);
    procedure Setvalor(const Value: String);
    procedure Setposicaonivel(const Value: Integer);
    procedure Setnomenivel(const Value: String);
    procedure Setcodigocor(const Value: Integer);
    procedure Setid_pinivel(const Value: Integer);
    procedure Setvalor_numerico(const Value: Integer);
    procedure Setflag_valor_em_segundos(const Value: String);
    procedure Setcreatedat(const Value: TDateTime);
  public
    property pinome                : String     read Fpinome                 write Setpinome;
    property valor                 : String     read Fvalor                  write Setvalor;
    property posicaonivel          : Integer    read Fposicaonivel           write Setposicaonivel;
    property nomenivel             : String     read Fnomenivel              write Setnomenivel;
    property codigocor             : Integer    read Fcodigocor              write Setcodigocor;
    property id_pinivel            : Integer    read Fid_pinivel             write Setid_pinivel;
    property valor_numerico        : Integer    read Fvalor_numerico         write Setvalor_numerico;
    property flag_valor_em_segundos: String     read Fflag_valor_em_segundos write Setflag_valor_em_segundos;
    property createdat             : TDateTime  read Fcreatedat              write Setcreatedat;
  end;

  TListaPI = class
  private
    Fid: Integer;
    Fitems: TArrayPI;
    procedure Setid(const Value: Integer);
    procedure Setitems(const Value: TArrayPI);
  public
    destructor Destroy; override;

    procedure Add(pPI: TPI);
    procedure LoadFromCds(pCds: TClientDataSet);

    procedure SendToBD(pBaseUnidades: String);
    procedure SendToAPI(pURL: String);

    function ToJSON: TJSONObject;

    property id   : Integer  read Fid          write Setid;
    property items: TArrayPI read Fitems       write Setitems;
  end;

  TMultiPI = class
  private
    Fitems: TArrayListaPI;
    procedure Setitems(const Value: TArrayListaPI);
  public
    destructor Destroy; override;

    procedure Add(pListaPI: TListaPI);

    procedure GetFromBD(pUnidades, pBaseUnidades: String);
    procedure GetFromSocket(pProtocolo: String; lIDUnidade: Integer);
    procedure SaveToCds(pCds: TClientDataSet);

    function ToJSON: TJSONObject;

    property items: TArrayListaPI read Fitems write Setitems;
  end;

  TPIsPossiveis = class
  public
    class function GetFromBD(pBaseUnidades: String): TJSONArray;
    class function GetFromSocket(pProtocolo: String): TJSONArray;
  end;

implementation

{ TPIManager }

uses   {$IFNDEF CompilarPara_TGSMOBILE} ASPGenerator, {$ENDIF}  ASPHTTPRequest,
  System.Types, MyDlls_DR;

class procedure TPIManager.IntegrarPIs(pID: Integer; pTipoIntegracao: TTipoIntegracao;
  pCds: TClientDataSet; pPath: String = '');
begin
  if pPath.IsEmpty then
  begin
    Exit;
  end;

  TThread.CreateAnonymousThread(
    procedure
    var
      lListaPI: TListaPI;
    begin
      lListaPI := TListaPI.Create;

      try
        lListaPI.id := pID;

        lListaPI.LoadFromCds(pCds);

        case pTipoIntegracao of
          tiAPI    : lListaPI.SendToAPI(pPath);
          tiBanco  : lListaPI.SendToBD(pPath);
          tiSocket : lListaPI.SendToBD(pPath);
        end;
      finally
        FreeAndNil(lListaPI);
      end;
    end).Start;
end;

class procedure TPIManager.ValidateURL(var AUrl: String; ASufix: String);

  procedure SlashAtEnd(var AStr: String);
  begin
    if RightStr(AStr, 1) <> '/' then
      AStr := AStr + '/';
  end;

begin
  if not AUrl.StartsWith('http://', True) then
  begin
    AURL := 'http://' + AURL;
  end;

  SlashAtEnd(AUrl);

  SlashAtEnd(ASufix);

  AUrl := AUrl + ASufix;
end;

class function TPIManager.BuscarPIs(pUnidades, pPath: String; pTipoIntegracao: TTipoIntegracao): TJSONObject;
var
  lMultiPI: TMultiPI;
begin
  case pTipoIntegracao of
    tiBanco, tiSocket:
    begin
      lMultiPI := TMultiPI.Create;

      try
        lMultiPI.GetFromSocket(pPath, StrToInt(pUnidades));
        Result := TJson.ObjectToJsonObject(lMultiPI);
      finally
        FreeAndNil(lMultiPI);
      end;
    end;
    tiAPI:
    begin
      Result := GetMultiPIFromAPI(pUnidades, pPath);
    end;
  else Result := nil;
  end;
end;

class function TPIManager.BuscarPIs(pUnidades, pPath: String; pCds: TClientDataSet): String;
var
  lMultiPI: TMultiPI;
  obj: TJSONObject;
begin
  obj := TPIManager.BuscarPIs(pUnidades, pPath, tiAPI);
  try
    lMultiPI := TJson.JsonToObject<TMultiPI>(obj);

    try
      lMultiPI.SaveToCds(pCds);
      Result := pCds.XMLData;
    finally
      FreeAndNil(lMultiPI);
    end;
  finally
    obj.Free;
  end;
end;

class function TPIManager.BuscarPIsPossiveis(pPath: String; pTipoIntegracao: TTipoIntegracao): TJSONObject;
begin
  case pTipoIntegracao of
    tiBanco:
    begin
      Result := TJSONObject(TPIsPossiveis.GetFromBD(pPath));
    end;
    tiAPI:
    begin
      Result := GetPIsPossiveisFromAPI(pPath);
    end;
    tiSocket:
    begin
      Result := TJSONObject(TPIsPossiveis.GetFromSocket(pPath));
    end;
  else Result := nil;
  end;
end;

class function TPIManager.GetMultiPIFromAPI(pUnidades, pURL: String): TJSONObject;
var
  lResponse: String;
  lStreamRes: TStringStream;
  lMultiPI: TMultiPI;
begin
  ValidateUrl(pUrl, 'Indicador/Indicadores/');

  if pUnidades.Trim = EmptyStr then
  begin
    pUnidades := '-1';
  end;

  lStreamRes := TStringStream.Create;
  try
    THTTPRequest.Get(pURL + pUnidades, lStreamRes);

    lResponse := lStreamRes.DataString;

    lResponse := ReplaceStr(lResponse, '{"result":', '');
    lResponse := Copy(lResponse, 1, Length(lResponse) - 1);

    lMultiPI := TJson.JsonToObject<TMultiPI>(lResponse);
    try
      Result := lMultiPI.ToJSON;
    finally
      FreeAndNil(lMultiPI);
    end;
  finally
    FreeAndNil(lStreamRes);
  end;
end;

class function TPIManager.GetPIsPossiveisFromAPI(pURL: String): TJSONObject;
var
  lResponse: String;
  lStreamRes: TStringStream;
begin
  ValidateUrl(pUrl, 'Indicador/IndicadoresPossiveis/');

  lStreamRes := TStringStream.Create;
  try
    THTTPRequest.Get(pURL, lStreamRes);

    lResponse := lStreamRes.DataString;
    lResponse := ReplaceStr(lResponse, '{"result":', '');
    lResponse := Copy(lResponse, 1, Length(lResponse) - 1);

    Result := TJSONObject(TJSONObject.ParseJSONValue(lResponse));
  finally
    FreeAndNil(lStreamRes);
  end;
end;

{ TPI }

procedure TPI.Setcodigocor(const Value: Integer);
begin
  Fcodigocor := Value;
end;

procedure TPI.Setcreatedat(const Value: TDateTime);
begin
  Fcreatedat := Value;
end;

procedure TPI.Setflag_valor_em_segundos(const Value: String);
begin
  Fflag_valor_em_segundos := Value;
end;

procedure TPI.Setid_pinivel(const Value: Integer);
begin
  Fid_pinivel := Value;
end;

procedure TPI.Setnomenivel(const Value: String);
begin
  Fnomenivel := Value;
end;

procedure TPI.Setpinome(const Value: String);
begin
  Fpinome := Value;
end;

procedure TPI.Setposicaonivel(const Value: Integer);
begin
  Fposicaonivel := Value;
end;

procedure TPI.Setvalor(const Value: String);
begin
  Fvalor := Value;
end;

procedure TPI.Setvalor_numerico(const Value: Integer);
begin
  Fvalor_numerico := Value;
end;

{ TListaPI }

procedure TListaPI.Add(pPI: TPI);
begin
  SetLength(Fitems, Length(Fitems) + 1);
  items[Length(Fitems) - 1] := pPI;
end;

procedure TListaPI.LoadFromCds(pCds: TClientDataSet);
var
  lPI: TPI;
  lCds: TClientDataSet;
begin
  lCds := TClientDataSet.Create(nil);

  try
    TThread.Synchronize(nil,
      procedure
      begin
        lCds.Data := pCds.Data;
      end);

    lCds.First;

    while not lCds.Eof do
    begin
      lPI := TPI.Create;

      lPI.pinome                 := lCds.FieldByName('PINOME'                       ).AsString;
      lPI.valor                  := lCds.FieldByName('VALOR'                        ).AsString;
      lPI.posicaonivel           := lCds.FieldByName('POSICAONIVEL'                 ).AsInteger;
      lPI.nomenivel              := lCds.FieldByName('NOMENIVEL'                    ).AsString;
      lPI.codigocor              := lCds.FieldByName('CODIGOCOR'                    ).AsInteger;
      lPI.id_pinivel             := lCds.FieldByName('ID_PINIVEL'                   ).AsInteger;
      lPI.valor_numerico         := lCds.FieldByName('VALOR_NUMERICO'               ).AsInteger;
      lPI.flag_valor_em_segundos := IfThen(lCds.FieldByName('FLAG_VALOR_EM_SEGUNDOS').AsBoolean, 'S', 'N');

      Add(lPI);

      lCds.Next;
    end;
  finally
    FreeAndNil(lCds);
  end;
end;

destructor TListaPI.Destroy;
var
  i: Integer;
begin
  for i := 0 to High(items) - 1 do
  begin
    if Assigned(items[i]) then
    begin
      FreeAndNil(items[i]);
    end;
  end;

  inherited;
end;

procedure TListaPI.SendToAPI(pURL: String);
var
  lJSONListaPI: TJSONObject;
  lJSONStream: TStringStream;
begin
  TPIManager.ValidateUrl(pURL, 'Indicador/Indicadores/');

  try
    lJSONListaPI := TJson.ObjectToJsonObject(Self);

    lJSONStream := TStringStream.Create(lJSONListaPI.ToJSON);

    try
      THTTPRequest.Post(pURL, lJSONStream);
    finally
      FreeAndNil(lJSONStream);
    end;
  except
    on E: Exception do
    begin
      // Levantar Exception?
    end;
  end;
end;

procedure TListaPI.SendToBD(pBaseUnidades: String);
var
  i: Integer;
  lConn: TFDConnection;

  lNow: TDateTime;
begin
  {$IFNDEF CompilarPara_TGSMOBILE}
  lConn := TFDConnection.Create(nil);

  try
    {$REGION 'Configurar objeto de conexão'}
    try
      lConn.Close;
      lConn.ConnectionDefName := pBaseUnidades;
      lConn.Open;
    except
      on E: Exception do
      begin
        // Levantar Exception de erro de conexão?
      end;
    end;
    {$ENDREGION}

    {$REGION 'Persiste na base de dados de unidades'}
    try
      lConn.StartTransaction;

      lConn.ExecSQL('DELETE FROM INDICADORES WHERE ID_UNIDADE = ' + Self.id.ToString);

      lNow := Now;

      for i := 0 to High(Self.items) do
      begin
        lConn.ExecSQL('INSERT INTO INDICADORES                                 ' + sLineBreak +
                      '  (ID, ID_UNIDADE, PINOME, VALOR, ID_PINIVEL,           ' + sLineBreak +
                      '   CODIGOCOR, NOMENIVEL, POSICAONIVEL, VALOR_NUMERICO,  ' + sLineBreak +
                      '   FLAG_VALOR_EM_SEGUNDOS, CREATEDAT)'                    + sLineBreak +
                      'VALUES ('                                                 + sLineBreak +
                      TGenerator.NGetNextGenerator('GEN_INDICADORES_ID', lConn).ToString + ', ' +
                      Self.id.ToString                                           + ', ' +
                      Self.items[i].pinome.QuotedString                          + ', ' +
                      Self.items[i].valor.QuotedString                           + ', ' +
                      Self.items[i].id_pinivel.ToString                          + ', ' +
                      Self.items[i].codigocor.ToString                           + ', ' +
                      Self.items[i].nomenivel.QuotedString                       + ', ' +
                      Self.items[i].posicaonivel.ToString                        + ', ' +
                      Self.items[i].valor_numerico.ToString                      + ', ' +
                      Self.items[i].flag_valor_em_segundos.QuotedString          + ', ' +
                      FormatDateTime('YYYY-MM-DD HH:NN:SS', lNow).QuotedString   + ') ');
      end;

      lConn.Commit;
    except
      on E: Exception do
      begin
        // Levantar Exception de erro de persistência?
        lConn.Rollback;
      end;
    end;
{$ENDREGION}
  finally
    FreeAndNil(lConn);
  end;
  {$ENDIF}
end;

procedure TListaPI.Setid(const Value: Integer);
begin
  Fid := Value;
end;

procedure TListaPI.Setitems(const Value: TArrayPI);
begin
  Fitems := Value;
end;

function TListaPI.ToJSON: TJSONObject;
begin
  Result := TJson.ObjectToJsonObject(Self);
end;

{ TMultiPI }

procedure TMultiPI.Add(pListaPI: TListaPI);
begin
  SetLength(Fitems, Length(Fitems) + 1);
  items[Length(Fitems) - 1] := pListaPI;
end;

destructor TMultiPI.Destroy;
var
  i: Integer;
begin
  for i := 0 to High(items) - 1 do
  begin
    if Assigned(items[i]) then
    begin
      FreeAndNil(items[i]);
    end;
  end;

  inherited;
end;

procedure TMultiPI.GetFromBD(pUnidades, pBaseUnidades: String);
var
  lConn: TFDConnection;
  lDsPI: TDataSet;

  lIDUnidade: Integer;

  lListaPI: TListaPI;
  lPI: TPI;
begin
  lConn := TFDConnection.Create(nil);

  if pUnidades.Trim = EmptyStr then
  begin
    pUnidades := '-1';
  end;

  try
    {$REGION 'Configurar objeto de conexão'}
    try
      lConn.Close;
      lConn.ConnectionDefName := pBaseUnidades;
      lConn.Open;
    except
      on E: Exception do
      begin
        //*** Levantar Exception de erro de conexão?
      end;
    end;
    {$ENDREGION}

    {$REGION 'Criar Lista MultiPI'}
    lConn.ExecSQL('SELECT                              ' + sLineBreak +
                  '  *                                 ' + sLineBreak +
                  'FROM                                ' + sLineBreak +
                  '  INDICADORES                       ' + sLineBreak +
                  'WHERE                               ' + sLineBreak +
                  '  ID_UNIDADE IN ('+ pUnidades + ')  ' + sLineBreak +
                  'ORDER BY                            ' + sLineBreak +
                  '  ID_UNIDADE', lDsPI);

    try
      lDsPI.First;

      while not lDsPI.Eof do
      begin
        lIDUnidade := lDsPI.FieldByName('ID_UNIDADE').AsInteger;

        lListaPI := TListaPI.Create;

        repeat
          lListaPI.Fid := lDsPI.FieldByName('ID_UNIDADE'  ).AsInteger;

          lPI := TPI.Create;

          lPI.pinome                 := lDsPI.FieldByName('PINOME'                       ).AsString;
          lPI.valor                  := lDsPI.FieldByName('VALOR'                        ).AsString;
          lPI.posicaonivel           := lDsPI.FieldByName('POSICAONIVEL'                 ).AsInteger;
          lPI.nomenivel              := lDsPI.FieldByName('NOMENIVEL'                    ).AsString;
          lPI.codigocor              := lDsPI.FieldByName('CODIGOCOR'                    ).AsInteger;
          lPI.id_pinivel             := lDsPI.FieldByName('ID_PINIVEL'                   ).AsInteger;
          lPI.valor_numerico         := lDsPI.FieldByName('VALOR_NUMERICO'               ).AsInteger;
          lPI.flag_valor_em_segundos := IfThen(lDsPI.FieldByName('FLAG_VALOR_EM_SEGUNDOS').AsBoolean, 'S', 'N');
          lPI.createdat              := lDsPI.FieldByName('CREATEDAT'                    ).AsDateTime;

          lListaPI.Add(lPI);

          lDsPI.Next;
        until (lIDUnidade <> lDsPI.FieldByName('ID_UNIDADE').AsInteger) or
              (lDsPI.Eof);

        Add(lListaPI);
      end; // while
    finally
      FreeAndNil(lDsPI);
    end;
{$ENDREGION}
  finally
    FreeAndNil(lConn);
  end;
end;

procedure TMultiPI.GetFromSocket(pProtocolo: String; lIDUnidade: Integer);
var
  lListaPI: TListaPI;
  lPI: TPI;

  lInfoPIs, lInfoPI, Aux1, Aux2: string;
begin
  try
    try
      lInfoPIs := pProtocolo;

      repeat
        SeparaStrings(lInfoPIs, ';', lInfoPI, lInfoPIs);
        //00030001Tempo Máximo de Espera'#9'2'#9'Crítico'#9'3'#9'25h15'#9'90942'#9'True'#9'255;
        //0002Fila Espera'#9'2'#9'Crítico'#9'3'#9'15'#9'15'#9'False'#9'255;
        //0003TEE'#9'0'#9'Normal'#9'1'#9'01h31'#9'5518'#9'True'#9'65280;
        lListaPI := TListaPI.Create;

        lListaPI.Fid := lIDUnidade;

        lPI := TPI.Create;

        SeparaStrings(Copy(lInfoPI, 5, Length(lInfoPI)), Tabulator, lInfoPI, Aux2);
        lPI.pinome                 := lInfoPI;

        SeparaStrings(Aux2, Tabulator, lInfoPI, Aux2);
        lPI.id_pinivel             := StrToIntDef(lInfoPI, -1);

        SeparaStrings(Aux2, Tabulator, lInfoPI, Aux2);
        lPI.nomenivel              := lInfoPI;

        SeparaStrings(Aux2, Tabulator, lInfoPI, Aux2);
        lPI.posicaonivel           := StrToIntDef(lInfoPI, -1);

        SeparaStrings(Aux2, Tabulator, lInfoPI, Aux2);
        lPI.valor                  := lInfoPI;

        SeparaStrings(Aux2, Tabulator, lInfoPI, Aux2);
        lPI.valor_numerico         := StrToIntDef(lInfoPI, -1);

        SeparaStrings(Aux2, Tabulator, lInfoPI, Aux2);
        lPI.flag_valor_em_segundos := IfThen(lInfoPI = 'True', 'S', 'N');

        SeparaStrings(Aux2, Tabulator, lInfoPI, Aux2);
        lPI.codigocor              := StrToIntDef(lInfoPI, -1);

        lPI.createdat              := Now;

        //IdPI := FieldByName('ID_PI').AsInteger;
        //Nome := FieldByName('PINOME').AsString;
        //Detalhes := FieldByName('ID_PINIVEL').AsString;
        //Detalhes := Detalhes + TAB + FieldByName('NOMENIVEL').AsString;
        //Detalhes := Detalhes + TAB + FieldByName('POSICAONIVEL').AsString;
        //Detalhes := Detalhes + TAB + FieldByName('VALOR').AsString;
        //Detalhes := Detalhes + TAB + FieldByName('VALOR_NUMERICO').AsString;
        //Detalhes := Detalhes + TAB + FieldByName('FLAG_VALOR_EM_SEGUNDOS').AsString;
        //Detalhes := Detalhes + TAB + FieldByName('CODIGOCOR').AsString;

        if (lPI.id_pinivel>-1) and (lPI.posicaonivel>-1) and (lPI.valor_numerico>-1) then
        begin
          lListaPI.Add(lPI);

          Add(lListaPI);
        end;
      until lInfoPIs = ''; // while
    except
      raise;
    end;
  finally

  end;
end;

procedure TMultiPI.SaveToCds(pCds: TClientDataSet);
var
  i,
  j: Integer;
begin
  pCds.Close;
  pCds.CreateDataSet;
  pCds.LogChanges := False;

  for i := 0 to Length(Self.items) - 1 do
  begin
    for j := 0 to Length(Self.items[i].items) - 1 do
    begin
      pCds.Append;

      pCds.FieldByName('ID'            ).AsInteger := Self.items[i].ID;
      pCds.FieldByName('PI'            ).AsString  := Self.items[i].items[j].PINOME;
      pCds.FieldByName('VALOR_NUMERICO').AsInteger := Self.items[i].items[j].VALOR_NUMERICO;
      pCds.FieldByName('ESTADO'        ).AsString  := Self.items[i].items[j].NOMENIVEL;
      pCds.FieldByName('CREATEDAT'     ).AsFloat   := Self.items[i].items[j].CREATEDAT;

      pCds.Post;
    end;
  end;
end;

procedure TMultiPI.Setitems(const Value: TArrayListaPI);
begin
  Fitems := Value;
end;

function TMultiPI.ToJSON: TJSONObject;
begin
  Result := TJson.ObjectToJsonObject(Self);
end;

{ TPIsPossiveis }

class function TPIsPossiveis.GetFromBD(pBaseUnidades: String): TJSONArray;
var
  lConn: TFDConnection;
  lDsPIsPossiveis: TDataSet;
  lPI: TJSONObject;
  LFlag: String;
  LBool: Boolean;
begin
  lConn := TFDConnection.Create(nil);
  try
    {$REGION 'Configurar objeto de conexão'}
    try
      lConn.Close;
      lConn.ConnectionDefName := pBaseUnidades;
      lConn.Open;
    except
      on E: Exception do
      begin
        //*** Levantar Exception de erro de conexão?
      end;
    end;
    {$ENDREGION}

    {$REGION 'Criar Lista de PIs Possíveis'}
    lConn.ExecSQL('select distinct ' +
                  ' T1.NOME PINOME, T2.FORMATOHORARIO FLAG_VALOR_EM_SEGUNDOS ' +
                  ' from PIS T1'+
                  ' left Join PIS_TIPOS T2 on T1.ID_PITIPO=T2.ID_PITIPO',
                  lDsPIsPossiveis);
    try
      result := TJSONArray.Create;

      lDsPIsPossiveis.First;
      while not lDsPIsPossiveis.Eof do
      begin
        LFlag := lDsPIsPossiveis.FieldByName('FLAG_VALOR_EM_SEGUNDOS').AsString;
        LBool := (LFlag = 'S') or (LFlag = 'T');

        lPI := TJSONObject.Create;
        lPI.AddPair('pi', lDsPIsPossiveis.FieldByName('PINOME').AsString);
        lPI.AddPair('flag_valor_em_segundos',  TJSONBool.Create(LBool));

        result.Add(lPI);
        lDsPIsPossiveis.Next;
      end;
    finally
      FreeAndNil(lDsPIsPossiveis);
    end;
{$ENDREGION}
  finally
    FreeAndNil(lConn);
  end;
end;

class function TPIsPossiveis.GetFromSocket(pProtocolo: String): TJSONArray;
//var
  //lPI: TJSONObject;
  //LFlag: String;
  //LBool: Boolean;
begin
  try
    try
      result := TJSONArray.Create;

      {lDsPIsPossiveis.First;
      while not lDsPIsPossiveis.Eof do
      begin
        LFlag := lDsPIsPossiveis.FieldByName('FLAG_VALOR_EM_SEGUNDOS').AsString;
        LBool := (LFlag = 'S') or (LFlag = 'T');

        lPI := TJSONObject.Create;
        lPI.AddPair('pi', lDsPIsPossiveis.FieldByName('PINOME').AsString);
        lPI.AddPair('flag_valor_em_segundos',  TJSONBool.Create(LBool));

        result.Add(lPI);
        lDsPIsPossiveis.Next;
      end;}
    finally

    end;
  finally

  end;
end;

end.
