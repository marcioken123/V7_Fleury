unit udmCadNiveis;

interface
{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  udmCadBase, SysUtils, Classes, FMTBcd, Provider, DB, DBClient,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, 
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, 
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.DBX.Migrate;

type
  TdmSicsCadNiveis = class(TdmSicsCadBase)
    cdsCadNiveis: TClientDataSet;
    dspCadNiveis: TDataSetProvider;
    qryCadNiveis: TFDQuery;
    cdsCadNiveisID_PINIVEL: TSmallintField;
    cdsCadNiveisNOME: TStringField;
    cdsCadNiveisCOR: TStringField;
    cdsCadNiveisCODIGOCOR: TIntegerField;
    procedure DataModuleCreate(Sender: TObject);
    procedure cdsCadNiveisReconcileError(DataSet: TCustomClientDataSet;
      E: EReconcileError; UpdateKind: TUpdateKind;
      var Action: TReconcileAction);
  private
    { Private declarations }
  public
    { Public declarations }
    function PossuiModificacoes: Boolean; Override;
  end;

implementation

uses MyAspFuncoesUteis, uDataSetHelper;

{$R *.dfm}

procedure TdmSicsCadNiveis.cdsCadNiveisReconcileError(
  DataSet: TCustomClientDataSet; E: EReconcileError; UpdateKind: TUpdateKind;
  var Action: TReconcileAction);
begin
  inherited;

  MyLogException(E);
end;

procedure TdmSicsCadNiveis.DataModuleCreate(Sender: TObject);
begin
	cdsCadNiveis.Open;
end;

function TdmSicsCadNiveis.PossuiModificacoes: Boolean;
begin
  Result := (inherited PossuiModificacoes) or ModificouDataSet(cdsCadNiveis);
end;

end.
