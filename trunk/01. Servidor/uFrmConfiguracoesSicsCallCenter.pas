unit uFrmConfiguracoesSicsCallCenter;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, DBCtrls, Buttons, DB, FMTBcd, Provider, Sics_91,
  uFrmBaseConfiguracoesSics, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.Comp.Client, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, Vcl.Mask, Datasnap.DBClient, uDataSetHelper,
  Vcl.Grids, Vcl.DBGrids;

type

  TFrmConfiguracoesSicsCallCenter = class(TFrmBaseConfiguracoesSics)
    qryNomePA: TFDQuery;
    cdsNomePA: TClientDataSet;
    cdsNomePAID: TIntegerField;
    cdsNomePANOME: TStringField;
    dspNomePA: TDataSetProvider;
    dscNomePA: TDataSource;
    lblID_PA: TLabel;
    edtID_Mesa: TDBEdit;
    chkModoTerminalServer: TDBCheckBox;
    procedure cboNomePAClick(Sender: TObject);
    procedure chkModoTerminalServerClick(Sender: TObject);
    procedure edtPAsPermitidasKeyPress(Sender: TObject; var Key: Char);
    procedure edtPAsPermitidasExit(Sender: TObject);
    procedure chkManualRedirectClick(Sender: TObject);
    procedure chkVisualizarProcessosParalelosClick(Sender: TObject);
    procedure chkUtilizarLeitorCodigoBarrasClick(Sender: TObject);
  protected
    function PermiteCopiarField(const aField: TField): Boolean; Override;
    procedure SetDefaultConfig; Override;
    procedure PrepareDataSet; Override;
    function GetTipoModulo: TModuloSics; Override;
    function GetDataSetFormPrincipal: TClientDataSet; Override;
    procedure HabilitaBotoes; Override;
  public
    { Public declarations }
  end;

var
  FrmConfiguracoesSicsCallCenter: TFrmConfiguracoesSicsCallCenter;

implementation

uses sics_94;

{$R *.dfm}

function TFrmConfiguracoesSicsCallCenter.GetDataSetFormPrincipal: TClientDataSet;
begin
  Result := dmSicsMain.cdsSicsCallCenter;
end;

function TFrmConfiguracoesSicsCallCenter.GetTipoModulo: TModuloSics;
begin
  Result := TModuloSics.msCallCenter;
end;

procedure TFrmConfiguracoesSicsCallCenter.cboNomePAClick(Sender: TObject);
begin
  ModoEdicaoDataSet;

end;

procedure TFrmConfiguracoesSicsCallCenter.chkManualRedirectClick(Sender: TObject);
begin
  inherited;
  HabilitaBotoes;
end;

procedure TFrmConfiguracoesSicsCallCenter.chkModoTerminalServerClick(Sender: TObject);
begin
  inherited;
  HabilitaBotoes;
end;

procedure TFrmConfiguracoesSicsCallCenter.chkUtilizarLeitorCodigoBarrasClick(Sender: TObject);
begin
  inherited;
  HabilitaBotoes;
end;

procedure TFrmConfiguracoesSicsCallCenter.chkVisualizarProcessosParalelosClick (Sender: TObject);
begin
  inherited;
  HabilitaBotoes;
end;

procedure TFrmConfiguracoesSicsCallCenter.HabilitaBotoes;
begin
  inherited;

 { lblFilasPermitidas.Enabled := chkManualRedirect.Checked;
  edtFilasPermitidas.Enabled := lblFilasPermitidas.Enabled;
  btnFilasPermitidas.Enabled := lblFilasPermitidas.Enabled;

  lblGruposProcessosParalelosPermitidos.Enabled := chkVisualizarProcessosParalelos.Checked;
  edtGruposProcessosParalelosPermitidos.Enabled := lblGruposProcessosParalelosPermitidos.Enabled;
  btnGruposProcessosParalelosPermitidos.Enabled := lblGruposProcessosParalelosPermitidos.Enabled;

  lblPortaLCDB.Enabled := chkUtilizarLeitorCodigoBarras.Checked;
  edtPortaLCDB.Enabled := lblPortaLCDB.Enabled;

  lblPAsPermitidas.Enabled := chkModoTerminalServer.Checked;
  edtPAsPermitidas.Enabled := lblPAsPermitidas.Enabled;
  btnPasPermitidas.Enabled := lblPAsPermitidas.Enabled;

  lblID_PA.Enabled  := not lblPAsPermitidas.Enabled;
  edtID_PA.Enabled  := lblID_PA.Enabled;
  Label2.Enabled    := lblID_PA.Enabled;
  cboNomePA.Enabled := lblID_PA.Enabled;    }

//  if((not chkModoTerminalServer.Checked) and (dtsConfig.DataSet.State in [dsEdit,dsInsert]))then
//    dtsConfig.DataSet.FieldByName('PAS_PERMITIDAS').Value := '';
end;

function TFrmConfiguracoesSicsCallCenter.PermiteCopiarField(const aField: TField): Boolean;
begin
  Result := inherited PermiteCopiarField(aField) and (aField.FieldName <> 'ID');
end;

procedure TFrmConfiguracoesSicsCallCenter.PrepareDataSet;
begin
  qryNomePA.Open;
  cdsNomePA.Open;
  inherited;
end;

procedure TFrmConfiguracoesSicsCallCenter.edtPAsPermitidasExit(Sender: TObject);
begin
  inherited;
  VerificaSequenciaNumeros(Sender);
end;

procedure TFrmConfiguracoesSicsCallCenter.edtPAsPermitidasKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  SomenteNumeros(Key);
end;

procedure TFrmConfiguracoesSicsCallCenter.SetDefaultConfig;
begin
  inherited;
//  cboNomePA.KeyValue := CDSConfig.FieldByName('ID').Value;
end;

end.
