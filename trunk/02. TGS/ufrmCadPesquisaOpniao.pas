unit ufrmCadPesquisaOpniao;

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
  FMX.Controls.Presentation, System.ImageList, FMX.ImgList,
  FMX.Effects, FMX.Grid.Style, FMX.ScrollBox, udmCadPesquisaOpniao;

type
  TfrmCadPesquisaOpniao = class(TfrmSicsCadBase)
    dtsCadPesquisaOpniao: TDataSource;
    btnExcluir: TButton;
    btnIncluir: TButton;
    dbgCadPesquisaOpniao: TGrid;
    LinkGridToDataSource1: TLinkGridToDataSource;
    bnd1: TBindSourceDB;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    procedure btnIncluirClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure dtsCadPesquisaOpniaoDataChange(Sender: TObject; Field: TField);
  private
    { Private declarations }
  protected
    function GetClassDM: TClassdmSicsCadBase; Override;
    procedure HabilitaBotoes; Override;
  public
    procedure Inicializar; Override;
    function dmCadPesquisaOpniao: TdmCadPesquisaOpniao;
  end;

function frmCadPesquisaOpniao(const aIDUnidade: integer; const aAllowNewInstance: Boolean = False; const aOwner: TComponent = nil): TfrmCadPesquisaOpniao;

implementation

{$R *.fmx}

function frmCadPesquisaOpniao(const aIDUnidade: integer; const aAllowNewInstance: Boolean = False; const aOwner: TComponent = nil): TfrmCadPesquisaOpniao;
begin
  Result := TfrmCadPesquisaOpniao(TfrmCadPesquisaOpniao.GetInstancia(aIDUnidade, aAllowNewInstance, aOwner));
end;

function TfrmCadPesquisaOpniao.GetClassDM: TClassdmSicsCadBase;
begin
  Result := TdmCadPesquisaOpniao;
end;

procedure TfrmCadPesquisaOpniao.HabilitaBotoes;
begin
  btnOK.Enabled := dmCadPesquisaOpniao.PossuiModificacoes;
  btnIncluir.Enabled := dtsCadPesquisaOpniao.DataSet.Active;
  btnExcluir.Enabled := btnIncluir.Enabled and ((not dtsCadPesquisaOpniao.DataSet.IsEmpty) or (dtsCadPesquisaOpniao.DataSet.State in[dsInsert, dsEdit]));
end;

procedure TfrmCadPesquisaOpniao.Inicializar;
begin
  inherited;
  dtsCadPesquisaOpniao.DataSet := dmCadPesquisaOpniao.cdsCadPesquisaOpniao;
  AspUpdateColunasGrid(Self, LinkGridToDataSource1);
end;

function TfrmCadPesquisaOpniao.dmCadPesquisaOpniao: TdmCadPesquisaOpniao;
begin
  Result := TdmCadPesquisaOpniao(dmSicsCadBase);
end;

procedure TfrmCadPesquisaOpniao.dtsCadPesquisaOpniaoDataChange(Sender: TObject;
  Field: TField);
begin
  inherited;
  HabilitaBotoes;
end;

procedure TfrmCadPesquisaOpniao.btnIncluirClick(Sender: TObject);
begin
	dmCadPesquisaOpniao.cdsCadPesquisaOpniao.Append;
  dbgCadPesquisaOpniao.SetFocus;
end;

procedure TfrmCadPesquisaOpniao.btnExcluirClick(Sender: TObject);
var
  LOldRecno: Integer;
begin
  LOldRecno := dmCadPesquisaOpniao.cdsCadPesquisaOpniao.RecNo;
	ConfirmationMessage('Confirma exclusão deste registro?',
    procedure (const aOK: Boolean)
    begin
      if aOK then
      begin
        if (LOldRecno = dmCadPesquisaOpniao.cdsCadPesquisaOpniao.RecNo) then
        	dmCadPesquisaOpniao.cdsCadPesquisaOpniao.Delete
        else
          ErrorMessage(Format('Contexto foi alterado. Registro de %d para %d.', [LOldRecno, dmCadPesquisaOpniao.cdsCadPesquisaOpniao.RecNo]));
      end;
    end);
end;

procedure TfrmCadPesquisaOpniao.btnOKClick(Sender: TObject);
begin
  if dmCadPesquisaOpniao.cdsCadPesquisaOpniao.ApplyUpdates(0) = 0 then
  begin
  end
  else
  begin
    dmCadPesquisaOpniao.cdsCadPesquisaOpniao.Cancel;
    dmCadPesquisaOpniao.cdsCadPesquisaOpniao.CancelUpdates;
  end;
end;

procedure TfrmCadPesquisaOpniao.btnCancelarClick(Sender: TObject);
begin
  if dmCadPesquisaOpniao.cdsCadPesquisaOpniao.State in dsEditModes Then
     dmCadPesquisaOpniao.cdsCadPesquisaOpniao.Cancel;
     dmCadPesquisaOpniao.cdsCadPesquisaOpniao.CancelUpdates;

  Visible := False;
end;

end.
