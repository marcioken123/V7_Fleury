unit udmCadNiveis;

interface

uses
  SysUtils, Classes, FMTBcd, Provider, DB, DBClient,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, uDataSetHelper,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf;

{$INCLUDE ..\AspDefineDiretivas.inc}

type
  TdmSicsCadNiveis = class(TDataModule)
    cdsCadNiveis: TClientDataSet;
    dspCadNiveis: TDataSetProvider;
    qryCadNiveis: TFDQuery;
    cdsCadNiveisID_PINIVEL: TSmallintField;
    cdsCadNiveisNOME: TStringField;
    cdsCadNiveisCOR: TStringField;
    cdsCadNiveisCODIGOCOR: TIntegerField;
    cdsCadNiveisID_UNIDADE: TIntegerField;
    cdsCadNiveisPOSICAO: TIntegerField;
    cdsCadNiveisCOR_PAINELELETRONICO: TStringField;
    procedure DataModuleCreate(Sender: TObject);
    procedure cdsCadNiveisReconcileError(DataSet: TCustomClientDataSet;
      E: EReconcileError; UpdateKind: TUpdateKind;
      var Action: TReconcileAction);
    procedure cdsCadNiveisAfterApplyUpdates(Sender: TObject;
      var OwnerData: OleVariant);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmSicsCadNiveis: TdmSicsCadNiveis;

implementation

uses
sics_94, UConexaoBD;

{$R *.dfm}

procedure TdmSicsCadNiveis.DataModuleCreate(Sender: TObject);
begin
  TConexaoBD.DefinirQueriesComoUnidirectional(Self);
  cdsCadNiveis.Open;
end;

procedure TdmSicsCadNiveis.cdsCadNiveisReconcileError(
  DataSet: TCustomClientDataSet; E: EReconcileError;
  UpdateKind: TUpdateKind; var Action: TReconcileAction);
begin
	//MyLogException(E);
end;

procedure TdmSicsCadNiveis.cdsCadNiveisAfterApplyUpdates(Sender: TObject;
  var OwnerData: OleVariant);
begin
  dmSicsMain.AtualizarTabelasPis;
end;

end.
