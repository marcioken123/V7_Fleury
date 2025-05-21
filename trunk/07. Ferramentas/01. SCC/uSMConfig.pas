unit uSMConfig;

interface

uses
  System.SysUtils, System.Classes, System.JSON, uSMBase, System.StrUtils;

type
{$METHODINFO ON}
  TSMConfig = class(TsmBase)
  private

  public
    function ReloadUnidades: TJSONObject;
  end;

  //apenas para expor a URI sem o prefixo "T"
  Config = class(TSMConfig);
{$METHODINFO OFF}

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses uLibDatasnap;

{$R *.dfm}

{ TSMConfig }

function TSMConfig.ReloadUnidades: TJSONObject;
const
  Sucesso = 'Sucesso';
var
  lRetorno: String;
begin
  lRetorno := IfThen(TLibDataSnap.CarregarParametrosUnidades(TLibDataSnap.DadosUnidades,
                                                             TLibDataSnap.DBHost,
                                                             TLibDataSnap.DBBanco,
                                                             TLibDataSnap.DBUsuario,
                                                             TLibDataSnap.DBSenha,
                                                             TLibDataSnap.DBOSAuthent,
                                                             TLibDataSnap.DiasDeviceOcioso), 'Sucesso', 'Falhou');

  Result := TJSONObject.Create;
  Result.AddPair('Status', lRetorno);

  if lRetorno = Sucesso then
    TLibDataSnap.UpdateStatus('*** Unidades recarregadas! ' + Result.ToString, IdUnidade);
end;

end.
