unit uSMTGSMobile;

interface

uses
  System.SysUtils, System.Classes, uSMBase, System.JSON, REST.JSON, System.StrUtils, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Phys,
  FireDAC.Comp.Client;

type
{$METHODINFO ON}
  TTGSMobile = class(TsmBase)
  private
    { Private declarations }
    function ConfigurarConexaoBD: String;
  public
    { Public declarations }
    function Device(pID, pNome: String): TJSONObject;
    function DeviceUnidades(pDevice: String): TJSONObject;
  end;

  //apenas para expor a URI sem o prefixo "T"
  TGSMobile = class(TTGSMobile);
{$METHODINFO OFF}

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses uDevice, uLibDatasnap, UConexaoBD;

{$R *.dfm}

{ TTGSMobile }

function TTGSMobile.ConfigurarConexaoBD: String;
begin
  Result := TConexaoBD.GetConnection(TLibDataSnap.DadosUnidades,
                                     TLibDataSnap.DBHost,
                                     TLibDataSnap.DBBanco,
                                     TLibDataSnap.DBUsuario,
                                     TLibDataSnap.DBSenha,
                                     TLibDataSnap.DBOSAuthent);
end;

function TTGSMobile.Device(pID, pNome: String): TJSONObject;
var
  LBool: Boolean;
  LNome, LId: String;
begin
  if pId.Trim.IsEmpty or pNome.Trim.IsEmpty then
    raise Exception.Create('Params values required.');

  Result := TDeviceManager.BuscarDeviceJSON(pID, pNome, ConfigurarConexaoBD, tiBanco, TLibDataSnap.DiasDeviceOcioso);

  if Result.TryGetValue('recem_incluido', LBool) and LBool then
  begin
    Result.TryGetValue('nome', LNome);
    Result.TryGetValue('id', LId);
    TLibDataSnap.UpdateStatus('Device registrado: ' + LNome + ' (' + LId + ')', IdUnidade);
  end;
end;

function TTGSMobile.DeviceUnidades(pDevice: String): TJSONObject;
begin
  Result := TDeviceManager.ListarUnidadesJSON(pDevice, ConfigurarConexaoBD, tiBanco);
end;

end.
