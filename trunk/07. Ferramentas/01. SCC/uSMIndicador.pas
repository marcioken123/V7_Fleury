unit uSMIndicador;

interface

uses
  System.SysUtils, System.Classes, uSMBase, System.JSON, REST.JSON, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Phys, FireDAC.Comp.Client;

type
{$METHODINFO ON}
  TIndicador = class(TsmBase)
  private
    { Private declarations }
    function ConfigurarConexaoBD: String;
  public
    { Public declarations }
    function Indicadores(pUnidades: String): TJSONObject;
    function updateIndicadores(pIndicadores: TJSONObject): TJSONObject;
    function IndicadoresPossiveis: TJSONObject;
  end;

  //apenas para expor a URI sem o prefixo "T"
  Indicador = class(TIndicador);
{$METHODINFO OFF}

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses uPI, uLibDatasnap, MyDlls_DR, UConexaoBD, System.Types;

{$R *.dfm}

{ TIndicador }

function TIndicador.ConfigurarConexaoBD: String;
begin
  Result := TConexaoBD.GetConnection(TLibDataSnap.DadosUnidades,
                                     TLibDataSnap.DBHost,
                                     TLibDataSnap.DBBanco,
                                     TLibDataSnap.DBUsuario,
                                     TLibDataSnap.DBSenha,
                                     TLibDataSnap.DBOSAuthent);
end;

function TIndicador.Indicadores(pUnidades: String): TJSONObject;
var
  LComandosEsperados: TIntegerDynArray;
  LResp, LData: string;

const
  CMD_NOMES_PIS_RES         = $65; // RE: $64 Solicitar nomes PIs
  CMD_SITUACAO_PIS_RES      = $67; // RE: $66 Solicitar situação PIs
  CMD_ALARMES_ATIVOS_RES    = $D2; // RE: $D1 Solicitar Alarmes Ativos
begin
  try
    //try
      IdUnidade := pUnidades;

      LComandosEsperados := [CMD_ALARMES_ATIVOS_RES];

      LResp := EnviarComando(1,
                             $D1,
                             LData,
                             LComandosEsperados);
    //finally
      Result := TPIManager.BuscarPIs(pUnidades, LResp, tiSocket);
      TLibDataSnap.UpdateStatus('Indicador.Indicadores ' + Result.ToString, pUnidades);
    //end;
  except
     on E: Exception do
     begin
       Result := TJSONObject.Create;
       Result.AddPair('Sucesso', TJSONFalse.Create);
       Result.AddPair('Erro', E.Message);

       TLibDataSnap.UpdateStatus('Indicador.Indicadores ' + E.Message, pUnidades);
     end;
  end;
end;

function TIndicador.IndicadoresPossiveis: TJSONObject;
var
  LComandosEsperados: TIntegerDynArray;

const
  CMD_NOMES_PIS_RES         = $65; // RE: $64 Solicitar nomes PIs
  CMD_SITUACAO_PIS_RES      = $67; // RE: $66 Solicitar situação PIs
  CMD_ALARMES_ATIVOS_RES    = $D2; // RE: $D1 Solicitar Alarmes Ativos
begin
     //IdUnidade := pUnidades;

    LComandosEsperados := [CMD_NOMES_PIS_RES];

    //LResp := EnviarComando(0, $D1, LData, LComandosEsperados);

  Result := TPIManager.BuscarPIsPossiveis(ConfigurarConexaoBD, tiBanco);

  TLibDataSnap.UpdateStatus('Indicador.IndicadoresPossiveis' + Result.ToString, '0');
end;

function TIndicador.updateIndicadores(pIndicadores: TJSONObject): TJSONObject;
var
  lListaPI: TListaPI;
begin
  try
    lListaPI := TJson.JsonToObject<TListaPI>(pIndicadores);

    try
      lListaPI.SendToBD(ConfigurarConexaoBD);
    finally
      lListaPI.Free;
    end;

    Result := TJSONObject.Create;
    Result.AddPair('Status', 'Sucesso');
  except
    on E: Exception do
    begin
      MyLogException(Exception.Create(
        FormatDateTime('dd/mm/yy  hh:nn:ss', now) + ' - ' +
        'Classe: ' + E.ClassName + ' - ' + '  Erro: ' + E.Message ));

      raise;
    end;
  end;

  TLibDataSnap.UpdateStatus('Indicador.updateIndicadores' + Result.ToString, '0');
end;

end.
