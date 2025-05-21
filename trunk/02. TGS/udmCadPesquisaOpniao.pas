unit udmCadPesquisaOpniao;

interface
{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  udmCadBase, SysUtils, Classes, FMTBcd, Provider, DB, DBClient,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, 
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, 
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.DBX.Migrate;

type
  TdmCadPesquisaOpniao = class(TdmSicsCadBase)
    cdsCadPesquisaOpniao: TClientDataSet;
    dspCadPesquisaOpniao: TDataSetProvider;
    qryCadPesquisaOpniao: TFDQuery;
    cdsCadPesquisaOpniaoID_PINIVEL: TSmallintField;
    cdsCadPesquisaOpniaoNOME: TStringField;
    cdsCadPesquisaOpniaoCOR: TStringField;
    cdsCadPesquisaOpniaoCODIGOCOR: TIntegerField;
    procedure DataModuleCreate(Sender: TObject);
    procedure cdsCadPesquisaOpniaoReconcileError(DataSet: TCustomClientDataSet;
      E: EReconcileError; UpdateKind: TUpdateKind;
      var Action: TReconcileAction);
  private
    { Private declarations }
  public
    { Public declarations }
    function PossuiModificacoes: Boolean; Override;
  end;

implementation

uses MyAspFuncoesUteis;

{$R *.dfm}

procedure TdmCadPesquisaOpniao.cdsCadPesquisaOpniaoReconcileError(
  DataSet: TCustomClientDataSet; E: EReconcileError; UpdateKind: TUpdateKind;
  var Action: TReconcileAction);
begin
  inherited;
  MyLogException(E);
end;

procedure TdmCadPesquisaOpniao.DataModuleCreate(Sender: TObject);
begin
	cdsCadPesquisaOpniao.Open;
end;

function TdmCadPesquisaOpniao.PossuiModificacoes: Boolean;
begin
  Result := (inherited PossuiModificacoes) or ModificouDataSet(cdsCadPesquisaOpniao);
end;

end.
