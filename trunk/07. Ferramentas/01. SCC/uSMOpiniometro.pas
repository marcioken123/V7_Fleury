unit uSMOpiniometro;

interface

uses System.SysUtils, System.Classes, System.JSON, Datasnap.DSServer,
  Datasnap.DSAuth, DataSnap.DSProviderDataModuleAdapter, Data.DBXPlatform,
  uDMSocket, uSMBase;

type
{$METHODINFO ON}
  TOpiniometro = class(TsmBase)
  private
  public
    function QuestoesVigentes(const aIdUnidade: String): TJSONObject;
    function updateRespostas(const aParams: TJSONObject): TJSONValue;
  end;

  //apenas para expor a URI sem o prefixo "T"
  Opiniometro = class(TOpiniometro);
{$METHODINFO OFF}

implementation

{$R *.dfm}

uses uLibDatasnap, uConsts;

{ TOpiniometro }

function TOpiniometro.QuestoesVigentes(const aIdUnidade: String): TJSONObject;
var
  LItens: TJSONArray;
//  LQuestao: TJSONObject;
begin
//****    \/   ****
//**** aTeNÁ√o **** - Para exemplo, veja: uSMFila.TFila.ListarQuaisGeramSenhas
//****   /\    ****

  IdUnidade := aIdUnidade;
  //LResp := EnviarComando(0, CMD_LISTAR_FILAS_GERAM_SENHAS, EmptyStr, [CMD_LISTAR_FILAS_GERAM_SENHAS_RES]);
  LItens := TJSONArray.Create;

  result := TJSONObject.Create;
  result.AddPair('Quantidade', TJSONNumber.Create(LItens.Count));
  result.AddPair('Questoes', LItens);
end;

function TOpiniometro.updateRespostas(const aParams: TJSONObject): TJSONValue;

//****    \/   ****
//**** aTeNÁ√o **** - OS C”DIGOS COMENTADOS ABAIXO S√O DE EXEMPLO
//****   /\    ****

//const
//  P_PA = 'PA';
//  P_FILA = 'Fila';
//  P_MOTIVOPAUSA = 'MotivoPausa';
//var
//  LAddr, LFila, LMoti: Integer;
//  LIdUnidade, LData, LResp: String;
//  LComandosEsperados: TIntegerDynArray;
begin
  Result := nil;
//  TLibDataSnap.ValidateInputParams(aParams, [P_PA, P_FILA, P_MOTIVOPAUSA]);
//  try
//    LComandosEsperados := [CMD_PAUSA_RES];
//
//    LAddr := StrToInt(aParams.Values[P_PA].Value);
//    LFila := StrToInt(aParams.Values[P_FILA].Value);
//    LMoti := StrToInt(aParams.Values[P_MOTIVOPAUSA].Value);
//    if aParams.TryGetValue(P_IDUNIDADE, LIdUnidade) then
//     IdUnidade := LIdUnidade;
//    LData := IntToHex(LMoti, 4) + IntToHex(LFila, 4);
//  except
//    raise Exception.Create('Error parsing input params');
//  end;
//
//  LResp := EnviarComando(LAddr,
//                         CMD_PAUSA,
//                         LData,
//                         LComandosEsperados);


end;

end.

