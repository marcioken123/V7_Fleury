unit ufrmCadNiveis;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  FMX.Grid, FMX.Controls, FMX.Forms, FMX.Graphics,
  FMX.Dialogs, FMX.StdCtrls,FMX.ExtCtrls, FMX.Types, FMX.Layouts, FMX.ListView.Types,
  FMX.ListView, FMX.ListBox,
   Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors, FMX.Objects, FMX.Edit, FMX.TabControl,


  MyAspFuncoesUteis, System.UITypes, System.Types, System.SysUtils, System.Classes, System.Variants, Data.DB, Datasnap.DBClient, System.Rtti,
  Data.Bind.EngExt, Data.Bind.Components,
  udmCadBase, ufrmCadBase, Data.Bind.Grid, Data.Bind.DBScope,
  udmCadNiveis, FMX.Controls.Presentation, System.ImageList, FMX.ImgList,
  FMX.Effects, FMX.Grid.Style, FMX.ScrollBox;

type
  TfrmSicsCadNiveis = class(TfrmSicsCadBase)
    dtsCadNiveis: TDataSource;
    btnExcluir: TButton;
    btnIncluir: TButton;
    dbgCadNiveis: TGrid;
    LinkGridToDataSource1: TLinkGridToDataSource;
    bnd1: TBindSourceDB;
    procedure btnIncluirClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure dtsCadNiveisDataChange(Sender: TObject; Field: TField);
  private
    { Private declarations }
  protected
    function GetClassDM: TClassdmSicsCadBase; Override;
    procedure HabilitaBotoes; Override;
  public
    procedure Inicializar; Override;
    function dmSicsCadNiveis: TdmSicsCadNiveis;
  end;

function frmSicsCadNiveis(const aIDUnidade: integer; const aAllowNewInstance: Boolean = False; const aOwner: TComponent = nil): TFrmSicsCadNiveis;

implementation

{$R *.fmx}

function frmSicsCadNiveis(const aIDUnidade: integer; const aAllowNewInstance: Boolean = False; const aOwner: TComponent = nil): TFrmSicsCadNiveis;
begin
  Result := TfrmSicsCadNiveis(TfrmSicsCadNiveis.GetInstancia(aIDUnidade, aAllowNewInstance, aOwner));
end;

function TfrmSicsCadNiveis.GetClassDM: TClassdmSicsCadBase;
begin
  Result := TdmSicsCadNiveis;
end;

procedure TfrmSicsCadNiveis.HabilitaBotoes;
begin
  btnOK.Enabled := dmSicsCadNiveis.PossuiModificacoes;
  btnIncluir.Enabled := dtsCadNiveis.DataSet.Active;
  btnExcluir.Enabled := btnIncluir.Enabled and ((not dtsCadNiveis.DataSet.IsEmpty) or (dtsCadNiveis.DataSet.State in[dsInsert, dsEdit]));
end;

procedure TfrmSicsCadNiveis.Inicializar;
begin
  inherited;
  dtsCadNiveis.DataSet := dmSicsCadNiveis.cdsCadNiveis;
  AspUpdateColunasGrid(Self, LinkGridToDataSource1);
end;

function TfrmSicsCadNiveis.dmSicsCadNiveis: TdmSicsCadNiveis;
begin
  Result := TdmSicsCadNiveis(dmSicsCadBase);
end;

procedure TfrmSicsCadNiveis.dtsCadNiveisDataChange(Sender: TObject;
  Field: TField);
begin
  inherited;
  HabilitaBotoes;
end;

procedure TfrmSicsCadNiveis.btnIncluirClick(Sender: TObject);
begin
	dmSicsCadNiveis.cdsCadNiveis.Append;
  dbgCadNiveis.SetFocus;
end;

procedure TfrmSicsCadNiveis.btnExcluirClick(Sender: TObject);
var
  LOldRecno: Integer;
begin
  LOldRecno := dmSicsCadNiveis.cdsCadNiveis.RecNo;
	ConfirmationMessage('Confirma exclusão deste registro?',
    procedure (const aOK: Boolean)
    begin
      if aOK then
      begin
        if (LOldRecno = dmSicsCadNiveis.cdsCadNiveis.RecNo) then
        	dmSicsCadNiveis.cdsCadNiveis.Delete
        else
          ErrorMessage(Format('Contexto foi alterado. Registro de %d para %d.', [LOldRecno, dmSicsCadNiveis.cdsCadNiveis.RecNo]));
      end;
    end);
end;

procedure TfrmSicsCadNiveis.btnOKClick(Sender: TObject);
begin
  if dmSicsCadNiveis.cdsCadNiveis.ApplyUpdates(0) = 0 then
  begin
  end
  else
  begin
    dmSicsCadNiveis.cdsCadNiveis.Cancel;
    dmSicsCadNiveis.cdsCadNiveis.CancelUpdates;
  end;
end;

procedure TfrmSicsCadNiveis.btnCancelarClick(Sender: TObject);
begin
  if dmSicsCadNiveis.cdsCadNiveis.State in dsEditModes Then
     dmSicsCadNiveis.cdsCadNiveis.Cancel;
     dmSicsCadNiveis.cdsCadNiveis.CancelUpdates;

  Visible := False;
end;

end.
