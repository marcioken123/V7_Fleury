unit uSMDispositivo;

interface

uses
  System.SysUtils, System.Classes, uSMBase, System.JSON;

type
{$METHODINFO ON}
  TDispositivo = class(TsmBase)
  private
    { Private declarations }
  public
    { Public declarations }
    function Status(AUnidade: Integer): TJSONArray;
  end;

  //apenas para expor a URI sem o prefixo "T"
  Dispositivo = class(TDispositivo);
{$METHODINFO OFF}

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses uLibDatasnap, UConexaoBD, uDispositivo;

{$R *.dfm}

{ TDevice }

function TDispositivo.Status(AUnidade: Integer): TJSONArray;
begin
  Result := TDispositivoManager.StatusPorUnidade(AUnidade, TConexaoBD.NomeBasePadrao(AUnidade));

  TLibDataSnap.UpdateStatus('Recuperou Status dos Dispositivos: ' + Result.ToString, AUnidade.ToString);
end;

end.
