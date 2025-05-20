unit uSelecaoGrupos;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, Menus, MyDlls_DR,  MyAspFuncoesUteis_VCL,
  DBGrids, ASPDbGrid, FMTBcd, DB, Provider,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.Comp.Client, uDataSetHelper,
  Datasnap.DBClient, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet,
  Vcl.Grids, Vcl.StdCtrls;

type
  TFrmSelecaoGrupos = class(TForm)
    btnGravar: TBitBtn;
    btnCancelar: TBitBtn;
    PopupMenu: TPopupMenu;
    SelecionarTodos1: TMenuItem;
    InverterSeleo1: TMenuItem;
    ASPDbGrid: TASPDbGrid;
    qryGrupos: TFDQuery;
    dspGrupos: TDataSetProvider;
    cdsGrupos: TClientDataSet;
    dscGrupos: TDataSource;
    cdsGruposID: TIntegerField;
    cdsGruposNOME: TStringField;
    cdsGruposSelecionado: TBooleanField;
    DesmarcarTodos1: TMenuItem;
    procedure btnCancelarClick(Sender: TObject);
    procedure SelecionarTodos1Click(Sender: TObject);
    procedure InverterSeleo1Click(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DesmarcarTodos1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ASPDbGridCheckFieldClick(Field: TField);
  private

  public
    Grupos: string;
    FMultiSelect:boolean;
  end;

  var
  FrmSelecaoGrupos: TFrmSelecaoGrupos;

implementation

{$R *.dfm}

procedure TFrmSelecaoGrupos.ASPDbGridCheckFieldClick(Field: TField);
var
  LSelecionado: integer;
begin
  if not FMultiSelect then
  begin
    LSelecionado:= cdsGrupos.Recno;
    ASPDbGrid.DataSource := nil;
    cdsGrupos.First;
    while not cdsGrupos.Eof do
    begin
      if LSelecionado<> cdsGrupos.Recno then
      begin
        cdsGrupos.Edit;
        cdsGruposSelecionado.Value := False;
        cdsGrupos.Post;
      end;
      cdsGrupos.Next;
    end;
    cdsGrupos.Recno := LSelecionado;
    ASPDbGrid.DataSource := dscGrupos;
  end;
end;

procedure TFrmSelecaoGrupos.btnCancelarClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TFrmSelecaoGrupos.SelecionarTodos1Click(Sender: TObject);
begin
  cdsGrupos.First;

  while not cdsGrupos.Eof do
  begin
    cdsGrupos.Edit;
    cdsGruposSelecionado.Value := True;
    cdsGrupos.Post;
    cdsGrupos.Next;
  end;
  
end;

procedure TFrmSelecaoGrupos.InverterSeleo1Click(Sender: TObject);
begin
  cdsGrupos.First;

  while not cdsGrupos.Eof do
  begin
    cdsGrupos.Edit;
    cdsGruposSelecionado.Value := not cdsGruposSelecionado.Value;
    cdsGrupos.Post;
    cdsGrupos.Next;
  end;
end;

procedure TFrmSelecaoGrupos.btnGravarClick(Sender: TObject);
var
  vIDs: TIntArray;
  X: Integer;
begin

  X := 0;
  cdsGrupos.First;
  while not cdsGrupos.Eof do
  begin
    if cdsGruposSelecionado.Value then
    begin
      Inc(X);
      SetLength(vIDs,X);

      vIDs[Pred(X)] := cdsGruposID.AsInteger;;
    end;
    cdsGrupos.Next;
  end;

  IntArrayToStr(vIDs, Grupos);
end;

procedure TFrmSelecaoGrupos.FormCreate(Sender: TObject);
begin
  inherited;
  LoadPosition(Sender as TForm);
end;

procedure TFrmSelecaoGrupos.FormDestroy(Sender: TObject);
begin
  SavePosition(Sender as TForm);
  inherited;
end;

procedure TFrmSelecaoGrupos.FormShow(Sender: TObject);
var
  vIDs: TIntArray;
  vID: Integer;
  I: Integer;
begin
  
StrToIntArray(Grupos,vIDs);


  for I := 0 to High(vIDs) do
  begin
    vID := vIDs[I];

    if cdsGrupos.Locate('ID',vID,[]) then
    begin
      cdsGrupos.Edit;
      cdsGruposSelecionado.Value := True;
      cdsGrupos.Post;
    end;
  end;

end;

procedure TFrmSelecaoGrupos.DesmarcarTodos1Click(Sender: TObject);
begin
  cdsGrupos.First;

  while not cdsGrupos.Eof do
  begin
    cdsGrupos.Edit;
    cdsGruposSelecionado.Value := False;
    cdsGrupos.Post;
    cdsGrupos.Next;
  end;
end;

initialization
  FrmSelecaoGrupos := nil;
end.
