unit ufrmPromptUnidade;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  FMX.Grid, FMX.Controls, FMX.Forms, FMX.Graphics,
  FMX.Dialogs, FMX.StdCtrls, FMX.ExtCtrls, FMX.Types, FMX.Layouts, FMX.ListView.Types,
  FMX.ListView, FMX.ListBox,
  Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors, FMX.Objects, FMX.Edit, FMX.TabControl,


  System.UITypes, System.Types, System.SysUtils, System.Classes, System.Variants, Data.DB, Datasnap.DBClient, System.Rtti,
  Data.Bind.EngExt, Data.Bind.Components,
  Data.Bind.Grid, Data.Bind.DBScope,

  IniFiles, MyAspFuncoesUteis,
  untCommonFormBase, FMX.Controls.Presentation;

type
  TfrmSicsPromptUnidade = class(TFrmBase)
    cdsUnidades: TClientDataSet;
    dtsUnidade: TDataSource;
    Label1: TLabel;
    cmbUnidade: TComboBox;
    btnOK: TButton;
    btnCancelar: TButton;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure cmbUnidadeChange(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure HabilitaBotoes;
    procedure ImportarUnidades;
    constructor Create(AOwner: TComponent); override;
    class procedure ExibeForm(aOwner: TComponent; const ResultProc: TProc<TModalResult, Integer>);
  end;

var
  frmSicsPromptUnidade: TfrmSicsPromptUnidade;

implementation

uses
 udmSicsMain, untCommonDMConnection, untCommonDMUnidades;

{$R *.fmx}

procedure TfrmSicsPromptUnidade.btnCancelarClick(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TfrmSicsPromptUnidade.cmbUnidadeChange(Sender: TObject);
begin
  inherited;
  HabilitaBotoes;
end;

constructor TfrmSicsPromptUnidade.Create(AOwner: TComponent);
begin
  inherited;

  cdsUnidades.CloneCursor(dmUnidades.cdsUnidades, True);
  cdsUnidades.Filter := 'CONECTADA=TRUE';
  cdsUnidades.Filtered := True;
  ImportarUnidades;
  HabilitaBotoes;
end;

class procedure TfrmSicsPromptUnidade.ExibeForm(aOwner: TComponent; const ResultProc: TProc<TModalResult, Integer>);
begin
  if not Assigned(frmSicsPromptUnidade) then
  begin
    frmSicsPromptUnidade := TfrmSicsPromptUnidade.Create(aOwner);
  end;

	frmSicsPromptUnidade.ShowModal(
	  procedure (aModalResult: TModalResult)
	  begin
      if Assigned(ResultProc) then
        ResultProc(aModalResult, frmSicsPromptUnidade.cmbUnidade.itemIndex);
	  end);
end;

procedure TfrmSicsPromptUnidade.HabilitaBotoes;
begin
  btnOK.Enabled := cmbUnidade.ItemIndex > -1;
end;

procedure TfrmSicsPromptUnidade.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if (ModalResult = mrOk) and (cmbUnidade.ItemIndex <= -1) then
  begin
    Canclose := False;
    InformationMessage('Unidade não selecionada');
  end
  else
    inherited;
end;

procedure TfrmSicsPromptUnidade.ImportarUnidades;
var
  LNomeUnidade: string;
begin
  cmbUnidade.Items.Clear;
  cdsUnidades.First;
  while not cdsUnidades.Eof do
  begin
    LNomeUnidade := cdsUnidades.FieldByName('NOME').AsString;
    if ((cdsUnidades.FieldByName('ID').AsInteger = 0) and (Trim(LNomeUnidade) = '')) then
      LNomeUnidade := 'Principal';
    cmbUnidade.Items.Add(LNomeUnidade);
    cdsUnidades.Next;
  end;
  if cmbUnidade.Count > 0 then
    cmbUnidade.ItemIndex := 0;
end;

initialization
  frmSicsPromptUnidade := nil;
  
end.
