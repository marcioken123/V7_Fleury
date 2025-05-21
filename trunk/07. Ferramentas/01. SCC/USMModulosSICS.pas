unit USMModulosSICS;

interface

uses
  System.SysUtils, System.Classes, uSMBase, System.JSON, Datasnap.DSServer,
  Datasnap.DSAuth, DataSnap.DSProviderDataModuleAdapter, Data.DBXPlatform,
  uDMSocket, System.Generics.Collections;

type
{$METHODINFO ON}
  TModulosSICS = class(TsmBase)
  private
    { Private declarations }
  public
    { Public declarations }
    function ObterConfiguracoesOnLine(AIDModulo, AIdUnidade: String): TJSONObject;
  end;

  //apenas para expor a URI sem o prefixo "T"
  ModulosSICS = class(TModulosSICS);
{$METHODINFO OFF}

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses udmControleDeTokens, uConsts, uLibDatasnap;

{$R *.dfm}

{ TModulosSICS }

function TModulosSICS.ObterConfiguracoesOnLine(AIDModulo, AIdUnidade: String): TJSONObject;
var
  LIDUnidade: Integer;
  LIDModulo : Integer;
  LResp     : String;
  LAux      : String;
  LPos      : Integer;
  LJSONArray: TJSONArray;
begin
  LIDModulo    := StrToIntDef(AIDModulo,  0);
  LIDUnidade   := StrToIntDef(AIdUnidade, 0);
  IdUnidade    := LIDUnidade.ToString;
  LAux         := Chr($4F) + IntToHex(LIDModulo, 4);

  if dmControleDeTokens.ChecarComandoDuplicado('get ModulosSICS/ObterConfiguracoesOnLine', IdUnidade) then
    raise Exception.Create('Token duplicado');

  if LIDModulo <> 0 then
  begin
    LResp := EnviarComando(0, CMD_OBTER_CONFIGURACAO_MODULO, LAux , [CMD_OBTER_CONFIGURACAO_MODULO_RES]);
  end;
  LPos  := Pos('[', LResp);
  LResp := Copy(LResp,LPos);

  LJSONArray := TJSONArray(TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(LResp), 0));
  Result     := TJSONObject(LJSONArray.Items[0]);

  TLibDataSnap.UpdateStatus('ModulosSICS.ObterConfiguracoesOnLine', IdUnidade);
end;

end.



