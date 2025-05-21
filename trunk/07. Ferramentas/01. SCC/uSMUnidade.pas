unit uSMUnidade;

interface

uses System.SysUtils, System.Classes, System.JSON, Datasnap.DSServer,
  Datasnap.DSAuth, DataSnap.DSProviderDataModuleAdapter, Data.DBXPlatform,
  uDMSocket, uSMBase;

type
{$METHODINFO ON}
  TUnidade = class(TsmBase)
  private
    //private statements
  public
    function Listar: TJSONArray;
  end;

  //apenas para expor a URI sem o prefixo "T"
  Unidade = class(TUnidade);
{$METHODINFO OFF}

implementation

{$R *.dfm}

uses uLibDatasnap, uConsts, udmControleDeTokens, FireDAC.Comp.Client, Data.DB,
  Datasnap.DSHTTPWebBroker, UConexaoBD,SCC_m;

{ TUnidade }

function TUnidade.Listar: TJSONArray;
const
  LSQL_UNIDADES   = 'SELECT ID, NOME FROM UNIDADES ORDER BY ID';
var
  LConexao:     TFDConnection;
  LQuery:       TFDQuery;
  Lunidade:     TJSONObject;
begin
  try

    LConexao := TFDConnection.Create(Self);
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
          raise Exception.Create('Erro ao configurar objeto de conexão');
        end;
      end;
      {$ENDREGION}

      {$REGION 'Get dados Unidade'}
      LQuery := TFDQuery.Create(nil);
      try
        LQuery.Connection := LConexao;
        try
          LQuery.Close;
          LQuery.SQL.Text := LSQL_UNIDADES;
          LQuery.Open;
          result := TJSONArray.Create;
          while not LQuery.Eof do
          begin
            Lunidade := TJSONObject.Create;
            Lunidade.AddPair('IdUnidade', LQuery.FieldByName('ID').AsString);
            Lunidade.AddPair('NomeUnidade', LQuery.FieldByName('NOME').AsString);
            result.Add(Lunidade);
            LQuery.Next;
          end;
          except
          on E: Exception do
          begin
            raise Exception.Create('Erro ao executar comando SQL');
          end;
        end;
      finally
        FreeAndNil(LQuery);
      end;
      {$ENDREGION}
    finally
      FreeAndNil(LConexao);
    end;
  except on E: Exception do
    raise Exception.Create('Error parsing input params');
  end;

  TLibDataSnap.UpdateStatus('Unidade.Listar. Dados: TODOS', IdUnidade);
end;

end.

