unit uSMMotivoDePausa;

interface

uses System.SysUtils, System.Classes, System.JSON, Datasnap.DSServer,
  Datasnap.DSAuth, DataSnap.DSProviderDataModuleAdapter, Data.DBXPlatform,
  uDMSocket, uSMBase;

type
{$METHODINFO ON}
  TMotivoDePausa = class(TsmBase)
  private
  public
    function ListarPorPA(const aIdPA: Integer; const aIdUnidade: String): TJSONObject;
  end;

  //apenas para expor a URI sem o prefixo "T"
  MotivoDePausa = class(TMotivoDePausa);
{$METHODINFO OFF}

implementation

{$R *.dfm}

uses
  uLibDatasnap, uConsts, udmControleDeTokens;

{ TMotivoDePausa }

function TMotivoDePausa.ListarPorPA(const aIdPA: Integer; const aIdUnidade: String): TJSONObject;
var
  LItens: TJSONArray;
  LFila: TJSONObject;
  LResp: String;
  i, LQtdRecebida: Integer;
  LStrLst: TStringList;
  LItem, LId, LNome: String;
begin
  if aIdPA <= 0 then
    TLibDataSnap.AbortWithInvalidRequest('PA não informado');

  IdUnidade := aIdUnidade;

  if dmControleDeTokens.ChecarComandoDuplicado('get MotivoDePausa/ListarPorPA', IdUnidade) then
    raise Exception.Create('Token duplicado');

  LResp := EnviarComando(aIdPA, CMD_LISTAR_MOTIVOS_PAUSA, EmptyStr, [CMD_LISTAR_MOTIVOS_PAUSA_RES]);
  LItens := TJSONArray.Create;
  LQtdRecebida := StrToIntDef('$' + Copy(LResp, 1, 4), 0);
  Delete(LResp, 1, 4);

  LStrLst := TStringList.Create;
  try
    LStrLst.Delimiter := TAB;
    LStrLst.StrictDelimiter := True;
    LStrLst.DelimitedText := LResp;
    for i := 0 to LStrLst.Count-1 do
    begin
      LItem := Trim(LStrLst[i]);
      if LItem = EmptyStr then
        continue;

      LId   := Copy(LItem, 1, 4);
      LNome := Copy(LItem, Pos(';', LItem)+1);

      LFila := TJSONObject.Create;
      LFila.AddPair('ID', TJSONNumber.Create(StrToInt('$' + LId)));
      LFila.AddPair('Nome', LNome);
      LItens.Add(LFila);
    end;
  finally
    LStrLst.Free;
  end;

  if LQtdRecebida <> LItens.Count then
    raise Exception.Create('Checksum error. Got ' + LQtdRecebida.ToString +
                           ', sending ' + LItens.Count.ToString);

  result := TJSONObject.Create;
  result.AddPair('Quantidade', TJSONNumber.Create(LItens.Count));
  result.AddPair('Itens', LItens);

  TLibDataSnap.UpdateStatus(Format('Recuperou Lista de Motivos de Pausa para' +
                                   ' o PA "%d"', [aIdPA]),
                            IdUnidade);
end;

end.

