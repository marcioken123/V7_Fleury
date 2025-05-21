unit ufrmDadosPorUnidade;
//Renomeado unit SixTgs_Unidades;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  FMX.Grid, FMX.Controls, FMX.Forms, FMX.Graphics, System.UIConsts,
  FMX.Dialogs, FMX.StdCtrls, FMX.ExtCtrls, FMX.Types, FMX.Layouts, FMX.ListView.Types,
  FMX.ListView, FMX.ListBox, Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors,

  untCommonFrameSituacaoAtendimento, FMX.Objects, FMX.Edit, FMX.TabControl,


  System.UITypes, System.Types, System.SysUtils, System.Classes, System.Variants, Data.DB, Datasnap.DBClient, System.Rtti,
  Data.Bind.EngExt, Data.Bind.Components,
  Data.Bind.Grid, Data.Bind.DBScope,
  MyAspFuncoesUteis,
  untCommonFormBase, IniFiles, FMX.Controls.Presentation,
  System.ImageList, FMX.ImgList, untCommonDMClient, FMX.Effects, FMX.Grid.Style,
  FMX.ScrollBox;

type
  TfrmDadosPorUnidade = class(TFrmBase)
    btnAutoScroll: TSpeedButton;
    tmrScroll: TTimer;
    btnFechar: TButton;
    gridUnidades: TGrid;
    BindSourceDBUnidades: TBindSourceDB;
    LinkGridToDataSource1: TLinkGridToDataSource;
    ImageList1: TImageList;
    procedure FormShow(Sender: TObject);
    procedure btnAutoScrollClick(Sender: TObject);
    procedure tmrScrollTimer(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure gridUnidadesDrawColumnCell(Sender: TObject; const Canvas: TCanvas;
      const Column: TColumn; const Bounds: TRectF; const Row: Integer;
      const Value: TValue; const State: TGridDrawStates);
    procedure gridUnidadesCellClick(const Column: TColumn; const Row: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
    class procedure ExibirFormSituacaoUnidade(const aIDUnidade: Integer);
    class procedure OcultarFormSituacaoUnidade(const aIDUnidade: Integer);
  end;

var
  frmDadosPorUnidade: TfrmDadosPorUnidade;

implementation

uses
  untCommonFrameIndicadorPerformance, untCommonDMConnection,
  Sics_Common_Parametros, ufrmLines, untCommonFormProcessoParalelo, untMainForm,
  untCommonDMUnidades;

{$R *.fmx}

procedure TfrmDadosPorUnidade.FormShow(Sender: TObject);
begin
  if Assigned(BindSourceDBUnidades.DataSet) and BindSourceDBUnidades.DataSet.Active then
    BindSourceDBUnidades.DataSet.First;

  tmrScroll.Enabled := btnAutoScroll.IsPressed;
end;

procedure TfrmDadosPorUnidade.gridUnidadesCellClick(const Column: TColumn;
  const Row: Integer);
var
  i, Id : integer;
begin
  btnAutoScroll.IsPressed := false;
  tmrScroll.Enabled := false;

  for i := 0 to dmUnidades.cdsUnidadesClone.RecordCount -1 do
  begin
    OcultarFormSituacaoUnidade(i);
  end;

  if(gridUnidades.Selected <= -1) then
    Exit;
  BindSourceDBUnidades.DataSet.RecNo := gridUnidades.Selected + 1;
  Id := BindSourceDBUnidades.DataSet.FieldByName('ID').AsInteger;

  if BindSourceDBUnidades.DataSet.FieldByName('CONECTADA').AsBoolean then
    ExibirFormSituacaoUnidade(id);
end;

procedure TfrmDadosPorUnidade.gridUnidadesDrawColumnCell(Sender: TObject;
  const Canvas: TCanvas; const Column: TColumn; const Bounds: TRectF;
  const Row: Integer; const Value: TValue; const State: TGridDrawStates);
begin
  inherited;

  with Sender as TGrid Do
  begin
    if not((TGridDrawState.Selected in State) and (TGridDrawState.Focused in State)) then
    begin
      if not BindSourceDBUnidades.DataSet.FieldbyName('CONECTADA').AsBoolean then
      begin
        Canvas.Font.Style := [TFontStyle.fsItalic];
        Canvas.Fill.Color := System.UIConsts.claRed;
      end
      else
      begin
        Canvas.Font.Style := [];
        Canvas.Fill.Color := 0;
      end;
    end;
    OnDrawColumnCell(Sender, Canvas,Column, Bounds, Row, Value, State);
  end;
end;

procedure TfrmDadosPorUnidade.btnAutoScrollClick(Sender: TObject);
begin
  tmrScroll.Enabled := false;
end;

procedure TfrmDadosPorUnidade.tmrScrollTimer(Sender: TObject);
var
  i, Id : integer;
  OldEnabled: Boolean;
begin
  OldEnabled := tmrScroll.Enabled;
  try
    tmrScroll.Enabled := False;
    if not (Assigned(BindSourceDBUnidades.DataSet) and BindSourceDBUnidades.DataSet.Active) then
      Exit;
    with BindSourceDBUnidades.DataSet do
    begin
      Id := FieldByName('ID').AsInteger;
      repeat
        Next;
        if Eof then
          First;
      until (FieldByName('CONECTADA').AsBoolean = true) or (FieldByName('ID').AsInteger = Id);

      if(FieldByName('ID').AsInteger <> Id) or(not FieldByName('CONECTADA').AsBoolean) then
      begin
        for i := 0 to dmUnidades.cdsUnidadesClone.RecordCount do
        begin
          Id := i;
          OcultarFormSituacaoUnidade(id);
        end;
      end;

      if FieldByName('CONECTADA').AsBoolean then
      begin
        Id := FieldByName('ID').AsInteger;
        ExibirFormSituacaoUnidade(ID);
      end;
    end;
  finally
    tmrScroll.Enabled := OldEnabled;
  end;
end;

procedure TfrmDadosPorUnidade.btnFecharClick(Sender: TObject);
begin
  Close;
end;

class procedure TfrmDadosPorUnidade.ExibirFormSituacaoUnidade(const aIDUnidade: Integer);
//var
//  LFrmProcessoParalelo: TFrmProcessoParalelo;
begin
  if frmLines(aIDUnidade) <> nil then
    frmLines(aIDUnidade).Visible := True;

  if FraSituacaoAtendimento(aIDUnidade) <> nil then
    FraSituacaoAtendimento(aIDUnidade).Visible := True;

  if FraIndicadorPerformance(aIDUnidade) <> nil then
    FraIndicadorPerformance(aIDUnidade).Visible := True;

end;

class procedure TfrmDadosPorUnidade.OcultarFormSituacaoUnidade(const aIDUnidade: Integer);
var
  LFrmProcessoParalelo: TFrmProcessoParalelo;
begin
  if frmLines(aIDUnidade) <> nil then
    frmLines(aIDUnidade).Visible := False;

  if FraSituacaoAtendimento(aIDUnidade) <> nil then
    FraSituacaoAtendimento(aIDUnidade).Visible := False;

  MainForm.ExibeSomenteOFrame(nil);

  LFrmProcessoParalelo := FrmProcessoParalelo(aIDUnidade);
  if LFrmProcessoParalelo <> nil then
    LFrmProcessoParalelo.Close;
end;

procedure TfrmDadosPorUnidade.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  tmrScroll.Enabled := false;
end;

initialization
  frmDadosPorUnidade := nil;

end.
