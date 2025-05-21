unit udmControleDeTokens;

interface

uses
  System.SysUtils, System.Classes, System.DateUtils, System.Variants,
  Winapi.Windows, MyDlls_DR,
  uLibDatasnap,
  Web.HTTPApp, Datasnap.DSHTTPWebBroker,
  FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, Vcl.ExtCtrls, FireDAC.Comp.Client, FireDAC.Comp.DataSet,
  FireDAC.Phys.SQLiteVDataSet;

type
  TdmControleDeTokens = class(TDataModule)
    connControleDeTokens: TFDConnection;
    localsqlControleDeTokens: TFDLocalSQL;
    memtabControleDeTokens: TFDMemTable;
    memtabControleDeTokensToken: TStringField;
    memtabControleDeTokensDataHora: TDateTimeField;
    qryControleDeTokens: TFDQuery;
    tmrLimpaTokensAntigos: TTimer;
    memtabControleDeTokensDescEndpoint: TStringField;
    procedure DataModuleCreate(Sender: TObject);
    procedure tmrLimpaTokensAntigosTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure LimparTokensAntigos (Minutos : integer);
    function  ChecarComandoDuplicado (ADescEndpoint : string; AUnidade : string): Boolean;
    procedure LimparMemoria;
  end;

var
  dmControleDeTokens: TdmControleDeTokens;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TdmControleDeTokens.DataModuleCreate(Sender: TObject);
begin
  memtabControleDeTokens.LogChanges := false;
end;

procedure TdmControleDeTokens.LimparMemoria;
begin
  TThread.Synchronize(nil,
    procedure
    var
      MainHandle: THandle;
      DeuErro   : boolean;
    begin
      try
        DeuErro := false;
        MainHandle := OpenProcess(PROCESS_ALL_ACCESS, false, GetCurrentProcessID);
        if MainHandle <= 0 then
          TLibDataSnap.UpdateStatus('Erro ao obter o handle no processo de limpeza de memória.', '')
        else
        begin
          if not SetProcessWorkingSetSize(MainHandle, $FFFFFFFF, $FFFFFFFF) then
          begin
            DeuErro := true;
            TLibDataSnap.UpdateStatus('Erro ao setar o espaço de trabalho no processo de limpeza de memória.', '');
          end;

          if not CloseHandle(MainHandle) then
          begin
            DeuErro := true;
            TLibDataSnap.UpdateStatus('Erro ao fechar o handle no processo de limpeza de memória.', '');
          end;

          if not DeuErro then
            TLibDataSnap.UpdateStatus('Feito o processo de limpeza de memória.', '');
        end;
      except
        on E : Exception do
        begin
          TLibDataSnap.UpdateStatus('Erro no processo de limpeza de memória! Erro: [' + E.ClassName + '] ' + E.Message, '');
          MyLogException(E);
        end;
      end;
    end);
end;

procedure TdmControleDeTokens.LimparTokensAntigos (Minutos : integer);
var
  Inicio : TDateTime;
begin
  Inicio := now;
  qryControleDeTokens.Close;
  qryControleDeTokens.ParamByName('LimiteHorario').AsDateTime := IncMinute(now, -Minutos);
  qryControleDeTokens.Execute;
  TLibDataSnap.UpdateStatus(Format('Tokens anteriores a %d minutos foram excluídos (quantidade = %d, tempo = %s).',
                                   [Minutos, qryControleDeTokens.RowsAffected, FormatDateTime ('s,zzz', now - inicio)]), '');
end;

procedure TdmControleDeTokens.tmrLimpaTokensAntigosTimer(Sender: TObject);
begin
  LimparTokensAntigos(5);
  LimparMemoria;
end;

function TdmControleDeTokens.ChecarComandoDuplicado (ADescEndpoint : string; AUnidade : string): Boolean;
var
  LWebModule    : TWebModule;
  LToken        : String;
begin
  Result := false;

  try
    LWebModule := GetDataSnapWebModule;
    LToken     := LWebModule.Request.GetFieldByName('access_token');

    if LToken <> '' then
      with TFDMemTable.Create(Self) do
      try
        CloneCursor(memtabControleDeTokens);

        if Locate ('Token;DescEndpoint', VarArrayOf([LToken, ADescEndpoint]), []) then
        begin
          if SecondsBetween(now, FieldByName('DataHora').AsDateTime) < 30 then
          begin
            TLibDataSnap.UpdateStatus(Format('Token duplicado: "%s", endpoint "%s". Requisição ignorada.', [LToken, ADescEndpoint]), AUnidade);
            Result := true;
          end
          else
          begin
            Edit;
            FieldByName('DataHora').AsDateTime := now;
            Post;
          end;
        end
        else
        begin
          Append;
          FieldByName('Token'       ).AsString   := LToken       ;
          FieldByName('DescEndpoint').AsString   := ADescEndpoint;
          FieldByName('DataHora'    ).AsDateTime := now          ;
          Post;
        end;
      finally
        Free;
      end;
  except
    Result := false;
  end;
end;

end.
