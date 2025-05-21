unit ufrmCadHor;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  Fmx.Bind.DBEngExt, Fmx.Bind.Grid, Fmx.Bind.Editors, FMX.Layouts, FMX.Grid, FMX.Types,
  FMX.Controls, FMX.StdCtrls,
  FMX.Forms, FMX.Graphics, untMainForm,
  FMX.Dialogs, FMX.ExtCtrls, FMX.ListView.Types,
  FMX.ListView, FMX.ListBox,
  FMX.Objects, FMX.Edit, FMX.TabControl,


  MyAspFuncoesUteis, System.UITypes, System.Types, System.SysUtils, System.Classes, System.Variants, Data.DB, Datasnap.DBClient, System.Rtti,
  Data.Bind.EngExt, Data.Bind.Components,
  Data.Bind.Grid, Data.Bind.DBScope,
  udmCadHor, udmCadBase, ufrmCadBase, System.Bindings.Outputs, FMX.Controls.Presentation,
  System.ImageList, FMX.ImgList, FMX.Effects, FMX.Grid.Style, FMX.ScrollBox, uDataSetHelper;

type
  TfrmSicsCadHor = class(TfrmSicsCadBase)
    dtsCadHor: TDataSource;
    btnIncluir: TButton;
    btnExcluir: TButton;
    dbgCadHor: TGrid;
    LinkGridToDataSource1: TLinkGridToDataSource;
    bnd1: TBindSourceDB;
    procedure btnCancelarClick(Sender: TObject);
    procedure btnIncluirClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure dtsCadHorDataChange(Sender: TObject; Field: TField);
  private
    { Private declarations }
  protected
    function GetClassDM: TClassdmSicsCadBase; Override;
    procedure HabilitaBotoes; Override;
  public
    procedure Inicializar; Override;
    function dmSicsCadHor: TdmSicsCadHor;
    destructor Destroy; Override;
  end;

function FrmSicsCadHor(const aIDUnidade: integer; const aAllowNewInstance: Boolean = False; const aOwner: TComponent = nil): TFrmSicsCadHor;

implementation

{$R *.fmx}

function FrmSicsCadHor(const aIDUnidade: integer; const aAllowNewInstance: Boolean = False; const aOwner: TComponent = nil): TFrmSicsCadHor;
begin
  Result := TfrmSicsCadHor(TfrmSicsCadHor.GetInstancia(aIDUnidade, aAllowNewInstance, aOwner));
end;

function TfrmSicsCadHor.GetClassDM: TClassdmSicsCadBase;
begin
  Result := TdmSicsCadHor;
end;

procedure TfrmSicsCadHor.HabilitaBotoes;
begin
  //inherited;
  btnOK.Enabled := dmSicsCadHor.PossuiModificacoes;
  btnIncluir.Enabled := dtsCadHor.DataSet.Active;
  btnExcluir.Enabled := btnIncluir.Enabled and ((not dtsCadHor.DataSet.IsEmpty) or (dtsCadHor.DataSet.State in[dsInsert, dsEdit]));
end;

procedure TfrmSicsCadHor.Inicializar;
begin
  inherited;
  dtsCadHor.DataSet := dmSicsCadHor.cdsCadHor;
  bnd1.DataSet := dmSicsCadHor.cdsCadHor;
  AspUpdateColunasGrid(Self, LinkGridToDataSource1);
end;

function TfrmSicsCadHor.dmSicsCadHor: TdmSicsCadHor;
begin
  Result := TdmSicsCadHor(dmSicsCadBase);
end;

procedure TfrmSicsCadHor.dtsCadHorDataChange(Sender: TObject; Field: TField);
begin
  inherited;

  HabilitaBotoes;
end;

procedure TfrmSicsCadHor.btnCancelarClick(Sender: TObject);
begin
  with dmSicsCadHor.cdsCadHor do
  begin
  	if State in dsEditModes then
    begin
    	Cancel;
      CancelUpdates;
    end;
  end;
  Visible := False;
end;

procedure TfrmSicsCadHor.btnIncluirClick(Sender: TObject);
begin
	dmSicsCadHor.cdsCadHor.Append;
  dbgCadHor.SetFocus;
end;

procedure TfrmSicsCadHor.btnExcluirClick(Sender: TObject);
begin
  with dmSicsCadHor do
  begin
    cdsMonitoramentos.Open;
    if(cdsMonitoramentos.Locate('ID_PIHORARIO',cdsCadHor.FieldByName('ID_PIHORARIO').AsString,[]))then
    begin
      ErrorMessage('Este horário não pode ser excluído pois está relacionado a um alarme.');
      Exit;
    end;
    cdsMonitoramentos.Close;
  end;
  dmSicsCadHor.ExcluirComConfirmacao;
end;

procedure TfrmSicsCadHor.btnOKClick(Sender: TObject);
begin
  dmSicsCadHor.Save;
  Visible := False;
end;


destructor TfrmSicsCadHor.Destroy;
begin

  inherited;
end;

end.

