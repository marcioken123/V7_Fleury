unit ufrmGraphicsBase;
//Renomeado unit ufrmSicsGraphicsBase;
interface

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  FMX.Grid, FMX.Controls, FMX.Forms, FMX.Graphics, DBClient, FMX.Dialogs,
  FMX.StdCtrls, FMX.ExtCtrls, FMX.Types, FMX.Layouts, FMX.ListView.Types,
  FMX.ListView, FMX.ListBox, untMainForm, Fmx.Bind.DBEngExt, Fmx.Bind.Grid,
  System.Bindings.Outputs, Fmx.Bind.Editors, FMX.Objects, FMX.Edit,
  FMX.TabControl, System.UITypes, System.Types, System.SysUtils, System.Classes,
  System.Variants, Data.DB, System.Rtti, Data.Bind.EngExt, Data.Bind.Components,
  Data.Bind.Grid, Data.Bind.DBScope, MyAspFuncoesUteis, untCommonFrameBase,
  System.IniFiles, Data.FMTBcd, System.Actions, FMX.Menus,
  FMX.Controls.Presentation, FMX.ActnList, FMXTee.Engine, FMXTee.Procs,
  FMXTee.DBChart, untCommonFormBase,  FMXTee.Series, FMXTee.Chart,
  Sics_Common_Parametros,
  {$IFDEF SuportaQuickRep}
  //QrTee,
  {$ENDIF SuportaQuickRep}
  FMX.ComboEdit, System.ImageList, FMX.ImgList, FMX.Effects,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, 
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, 
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.DBX.Migrate, uDataSetHelper;

type
  TExportarPara = (epArquivoImage, epClipboard, epArquivoExcel, epArquivoPDF);

  TfrmGraphicsBase = class(TFrameBase)
    lytRodape: TLayout;
    ToolBarPrincipal: TPanel;
    btnImprimir: TButton;
    btnFechar: TButton;
    btnExportarExcel: TButton;
    actlstMain: TActionList;
    btnExibirFiltro: TButton;
    btnOcultarFiltro: TButton;
    actImprimir: TAction;
    actFechar: TAction;
    qryEstatisticas: TFDQuery;
    lytLateral: TLayout;
    qryEstatisticasSla: TFDQuery;
    btnCopiarGrafico: TButton;
    btnSalvarGrafico: TButton;
    procedure dbChartSlaMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Single); Virtual;
    procedure btnImprimirClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure btnExportarExcelClick(Sender: TObject);
    procedure actFecharExecute(Sender: TObject);
    procedure actImprimirExecute(Sender: TObject);
   	procedure btnOcultarFiltroClick(Sender: TObject);
    procedure btnExibirFiltroClick(Sender: TObject);
  private
  protected
    LCID: Integer;
    FSqlEstatisticas: string;
    FSqlEstatisticasSla: string;
    FGraficoSla: Boolean;
    FPosXMouseChartSla,
    FPosYMouseChartSla: Single;
    FMultiUnidades: Boolean;

    {$IFNDEF IS_MOBILE}
    FSaveDialogExcel: TSaveDialog;
    FSaveDialogBMP: TSaveDialog;
    FSaveDialogPDF: TSaveDialog;
    procedure SetSaveDialogBMP(const Value: TSaveDialog);
    procedure SetSaveDialogExcel(const Value: TSaveDialog);
    procedure SetSaveDialogPDF(const Value: TSaveDialog);
    function GetSaveDialogExcel: TSaveDialog;
    function GetSaveDialogBMP: TSaveDialog;
    function GetSaveDialogPDF: TSaveDialog;
    {$ENDIF IS_MOBILE}

    procedure SetGraficoSla(const Value: Boolean); Virtual;

    procedure ConfiguraDBChart(const aDBChart: TDBChart; const aDS: TClientDataSet; const aFieldSource: String; aFieldLabel: String = '';
      const aLabelsAngle: Integer= 0); Overload;
    procedure ConfiguraDBChart(const aPieSeries: TPieSeries; const aDBChart: TDBChart; const aDS: TClientDataSet; const aFieldSource: String; aFieldLabel: String = '';
      const aLabelsAngle: Integer= 0); Overload;
    procedure ExportarGrafico(const ExportarPara: TExportarPara); Overload; Virtual;
    procedure ExportarGrafico(const ExportarPara: TExportarPara; Chart : TDBChart); Overload; Virtual;


    procedure OcultarFiltro(const aOcultar: Boolean); Virtual;
    procedure SetVisibleGraphics; Virtual; abstract;
    procedure ExportarDadosExcel; Virtual; abstract;
    procedure CalcularEstatisticas; Virtual; abstract;
    procedure CalcularEstatisticasSla; Virtual; abstract;

    procedure PrepararLkpsUnidades; Virtual; abstract;
    procedure RotacionarPie(const aPie: TPieSeries; const aEmDirecaoDireita: Boolean = True);
    function GetDataSetByTabControl(const aTabControl: TTabControl; const aBndList: TBindingsList): TDataSet;
    procedure SetDataSetForChart(const aDBChart: TDBChart; const aDataSet: TDataSet);
  	procedure SetVisible(const aValue: Boolean); Override;
    procedure DefineCorChart; Virtual; abstract;
  public
    {$IFNDEF IS_MOBILE}
    property SaveDialogExcel: TSaveDialog read GetSaveDialogExcel write SetSaveDialogExcel;
    property SaveDialogBMP: TSaveDialog read GetSaveDialogBMP write SetSaveDialogBMP;
    property SaveDialogPDF: TSaveDialog read GetSaveDialogPDF write SetSaveDialogPDF;
    {$ENDIF IS_MOBILE}

    procedure AtualizarColunasGrid; Override;
    property GraficoSla: Boolean read FGraficoSla write SetGraficoSla;
    function ValidacaoAtivaModoConectado: Boolean; Override;
    constructor Create(AOwner: TComponent); overload; override;

  end;

const
  DiaSmStrArray: array [1 .. 7] of string{$IFNDEF IS_MOBILE}[3]{$ENDIF IS_MOBILE} = ('Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb');
  MesStrArray: array [1 .. 12] of string{$IFNDEF IS_MOBILE}[3]{$ENDIF IS_MOBILE} = ('Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez');

  AGRUPADOR_MES             = 1;
  AGRUPADOR_DIA             = 2;
  AGRUPADOR_SEMANA          = 3;
  AGRUPADOR_HORA            = 4;
  AGRUPADOR_ATENDENTE       = 5;
  AGRUPADOR_GRUPO_ATENDENTE = 6;
  AGRUPADOR_PA              = 7;
  AGRUPADOR_GRUPO_PA        = 8;
  AGRUPADOR_FAIXADESENHA    = 9;
  AGRUPADOR_TAG             = 10;
  AGRUPADOR_FILAESPERA      = 11;
  AGRUPADOR_CLIENTE         = 12;
  AGRUPADOR_TOTAIS          = 99;

implementation
{$R *.fmx}

uses
  untCommonDMClient;

{ TfrmGraphicsBase }

procedure TfrmGraphicsBase.actFecharExecute(Sender: TObject);
begin
  Visible := False;
end;

procedure TfrmGraphicsBase.actImprimirExecute(Sender: TObject);
begin
  Exit;
end;

procedure TfrmGraphicsBase.AtualizarColunasGrid;
begin
  if Self.Visible then
    AspUpdateColunasGrid(Self, bndList, GetDataSetOfLinkGrid, True, not GraficoSla);
end;

procedure TfrmGraphicsBase.btnExportarExcelClick(Sender: TObject);
begin
  if Sender = btnExportarExcel then
    ExportarGrafico(epArquivoExcel)
  else if Sender = btnCopiarGrafico then
    ExportarGrafico(epClipboard)
  else if Sender = btnSalvarGrafico then
    ExportarGrafico(epArquivoImage);
end;

procedure TfrmGraphicsBase.btnFecharClick(Sender: TObject);
begin
  inherited;
  Visible := False;
end;

procedure TfrmGraphicsBase.btnImprimirClick(Sender: TObject);
begin
  inherited;
  actImprimir.Execute;
end;

procedure TfrmGraphicsBase.ConfiguraDBChart (const aDBChart: TDBChart; const aDS: TClientDataSet; const aFieldSource: String; aFieldLabel: String; const aLabelsAngle: Integer);
var
  iSerie: Integer;
begin
  if (aFieldLabel = '') then
    aFieldLabel := aFieldSource;

  for iSerie := 0 to aDBChart.SeriesList.Count - 1 do
  begin
      aDBChart.Series[iSerie].XLabelsSource := '';
      aDBChart.Series[iSerie].XValues.ValueSource := '';
      aDBChart.Series[iSerie].DataSource := ads;
      aDBChart.Series[iSerie].XLabelsSource := ads.FieldByName(aFieldLabel).FieldName;
      aDBChart.Series[iSerie].XValues.ValueSource := ads.FieldByName(aFieldSource).FieldName;
      aDBChart.Series[iSerie].XValues.Order := loAscending;
      aDBChart.BottomAxis.LabelsAngle := aLabelsAngle;
      aDBChart.BottomAxis.Title.Caption := ads.FieldByName(aFieldLabel).DisplayLabel;
   end;
end;

procedure TfrmGraphicsBase.ConfiguraDBChart (const aPieSeries: TPieSeries; const aDBChart: TDBChart; const aDS: TClientDataSet; const aFieldSource: String; aFieldLabel: String; const aLabelsAngle: Integer);
begin
   if (aFieldLabel = '') then
     aFieldLabel := aFieldSource;

   ConfiguraDBChart(aDBChart, aDS, aFieldSource, aFieldLabel, aLabelsAngle);

   aPieSeries.XLabelsSource := '';
   aPieSeries.DataSource := ads;
   aPieSeries.XLabelsSource := ads.FieldByName(aFieldLabel).FieldName;
end;

constructor TfrmGraphicsBase.Create(AOwner: TComponent);
var
  LDMClient: TDMClient;
begin
  inherited;

  LDMClient := DMClient(IDunidade, not CRIAR_SE_NAO_EXISTIR);
  qryEstatisticas.Connection := LDMClient.connRelatorio;
  qryEstatisticasSla.Connection := LDMClient.connRelatorio;
  FSqlEstatisticas := qryEstatisticas.Sql.Text;
  FSqlEstatisticasSla := qryEstatisticasSla.Sql.Text;

  {$IFNDEF IS_MOBILE}
  SaveDialogBMP := nil;
  SaveDialogExcel := nil;
  SaveDialogPDF := nil;
  {$ENDIF IS_MOBILE}
  DefineCorChart;
end;

procedure TfrmGraphicsBase.dbChartSlaMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
var
  c  : TChartClickedPart;
  Pos: TPointF;
  LdbChartSla: TDBChart;
begin
  FPosXMouseChartSla := X;
  FPosYMouseChartSla := Y;
  Pos.X := Trunc(X);
  Pos.Y := Trunc(Y);

  LdbChartSla := (Sender as TDBChart);

  LdbChartSla.ShowHint := False;
  if c.ASeries <> nil then
  begin

    LdbChartSla.ShowHint := True;
  end;
end;

procedure TfrmGraphicsBase.ExportarGrafico(const ExportarPara: TExportarPara);
begin

end;

procedure TfrmGraphicsBase.ExportarGrafico(const ExportarPara: TExportarPara; Chart: TDBChart);
begin
  try
    case ExportarPara of
      {$IFNDEF IS_MOBILE}
      epArquivoExcel: begin
                        ExportarDadosExcel;
                      end;

      epArquivoImage: begin
                         if (SaveDialogBMP.Execute)then
                          Chart.SaveToBitmapFile(SaveDialogBMP.FileName);

                          //V4 estava assim porém método SaveToMetaFile está bugado, conforme http://bugs.teechart.net/show_bug.cgi?id=1380
                          //begin
                          //  if SaveDialogBMP.FilterIndex = 1 then
                          //    Chart.SaveToBitmapFile(SaveDialogBMP.FileName)
                          //  else
                          //    Chart.SaveToMetafile(SaveDialogBMP.FileName);
                          //end;

                      end;

      epArquivoPDF  : begin
                        if (SaveDialogPDF.Execute) then
                          Chart.SaveToMetafile(SaveDialogPDF.FileName);
                      end;
      {$ENDIF IS_MOBILE}
      epClipboard   : begin
                        if Assigned(Chart) then
                          Chart.CopyToClipboardBitmap  // V4 era Chart.CopyToClipboardMetafile(true) porém este método está bugado, conforme http://bugs.teechart.net/show_bug.cgi?id=1380
                        else
                          raise exception.Create('Nenhum gráfico está ativo.');
                      end;
      else ShowMessage('Ação indisponível nesta versão.');
    end;
  finally
  end;
end;

procedure TfrmGraphicsBase.SetDataSetForChart(const aDBChart: TDBChart; const aDataSet: TDataSet);
var
  I: Integer;
begin

  for i := 0 to aDBChart.SeriesCount - 1 do
  begin
    if not Assigned(aDBChart.Series[i]) then
      Continue;

    aDBChart.Series[i].DataSource := aDataSet;
  end;
end;

procedure TfrmGraphicsBase.SetGraficoSla(const Value: Boolean);
begin
  FGraficoSla := Value;
  AspUpdateColunasGrid(Self, bndList, nil, True, not Value, True);
end;

function TfrmGraphicsBase.ValidacaoAtivaModoConectado: Boolean;
begin
  Result := cNaoPossuiConexaoDiretoDB;
end;

procedure TfrmGraphicsBase.RotacionarPie(const aPie: TPieSeries; const aEmDirecaoDireita: Boolean);
begin
  try
    if Assigned(aPie) then
    begin
      if aEmDirecaoDireita then
        aPie.Rotate(10)
      else
        aPie.Rotate(-10);
    end
    else
      Assert(False, 'Controles não foram criados.');
  except
  end;
end;

function TfrmGraphicsBase.GetDataSetByTabControl(const aTabControl: TTabControl; const aBndList: TBindingsList): TDataSet;
var
  LPaginaAtiva: TTabItem;
  i2: Integer;
  LBindItem: TContainedBindComponent;
  LLinkGrid: TLinkGridToDataSource;
begin
  Result := nil;
  LPaginaAtiva := aTabControl.ActiveTab;
  if not Assigned(LPaginaAtiva) then
    Exit;
  for i2 := 0 to aBndList.BindCompCount -1 do
  begin
    LBindItem := aBndList.BindComps[i2];
    if not (Assigned(LBindItem) and (LBindItem is TLinkGridToDataSource)) then
      Continue;

    LLinkGrid := TLinkGridToDataSource(LBindItem);
    if Assigned(LLinkGrid.GridControl) and (LLinkGrid.GridControl is TControl) and
      Assigned(TControl(LLinkGrid.GridControl).parent) and
      ((TControl(LLinkGrid.GridControl).parent).owner = LPaginaAtiva) then
    begin
      if ASsigned(LLinkGrid.DataSource) and (LLinkGrid.DataSource is TBindSourceDB) then
      begin
        Result := TBindSourceDB(LLinkGrid.DataSource).DataSet;
        Exit;
      end;
    end;
  end;
end;

{$IFNDEF IS_MOBILE}
function TfrmGraphicsBase.GetSaveDialogBMP: TSaveDialog;
begin
  if not Assigned(FSaveDialogBMP) then
  begin
    FSaveDialogBMP := TSaveDialog.Create(Self);
    FSaveDialogBMP.DefaultExt := '.bmp';
    FSaveDialogBMP.Filter := 'Bitmap|.bmp';
    FSaveDialogBMP.FilterIndex := 0;
    FSaveDialogBMP.Options := [TOpenOption.ofOverwritePrompt, TOpenOption.ofHideReadOnly, TOpenOption.ofEnableSizing];
  end;
  Result := FSaveDialogBMP;

//  V4 estava assim porém método SaveToMetaFile está bugado, conforme http://bugs.teechart.net/show_bug.cgi?id=1380
//  if not Assigned(FSaveDialogBMP) then
//  begin
//    FSaveDialogBMP := TAspSaveDialog.Create(Self);
//    FSaveDialogBMP.DefaultExt := '.wmf';
//    FSaveDialogBMP.Filter := 'Bitmap (.bmp)|.bmp|MetaFile (.wmf)|.wmf';
//    FSaveDialogBMP.FilterIndex := 2;
//    FSaveDialogBMP.Options := [TAspOpenOption.ofOverwritePrompt, TAspOpenOption.ofHideReadOnly, TAspOpenOption.ofEnableSizing];
//  end;
//  Result := FSaveDialogBMP;
end;

function TfrmGraphicsBase.GetSaveDialogExcel: TSaveDialog;
begin
  if not Assigned(FSaveDialogExcel) then
  begin
    FSaveDialogExcel := TSaveDialog.Create(Self);
    FSaveDialogExcel.DefaultExt := '.xls';
    FSaveDialogExcel.Filter := 'Excel|*.xls';
    FSaveDialogExcel.Options := [TOpenOption.ofOverwritePrompt, TOpenOption.ofHideReadOnly, TOpenOption.ofEnableSizing];
  end;

  Result := FSaveDialogExcel;
end;

function TfrmGraphicsBase.GetSaveDialogPDF: TSaveDialog;
begin
  if not Assigned(FSaveDialogPDF) then
  begin
    FSaveDialogPDF := TSaveDialog.Create(Self);
    FSaveDialogPDF.DefaultExt := '.pdf';
    FSaveDialogPDF.Filter := 'PDF (.pdf)|*.pdf';
    FSaveDialogPDF.Options := [TOpenOption.ofOverwritePrompt, TOpenOption.ofHideReadOnly, TOpenOption.ofEnableSizing];
  end;
  Result := FSaveDialogPDF;
end;

procedure TfrmGraphicsBase.SetSaveDialogBMP(const Value: TSaveDialog);
begin
  FSaveDialogBMP := Value;
end;

procedure TfrmGraphicsBase.SetSaveDialogExcel(const Value: TSaveDialog);
begin
  FSaveDialogExcel := Value;
end;

procedure TfrmGraphicsBase.SetSaveDialogPDF(const Value: TSaveDialog);
begin
  FSaveDialogPDF := Value;
end;
{$ENDIF IS_MOBILE}

procedure TfrmGraphicsBase.SetVisible(const aValue: Boolean);
begin
  inherited;

end;

procedure TfrmGraphicsBase.OcultarFiltro(const aOcultar: Boolean);
begin
  btnOcultarFiltro.Visible := not aOcultar;
  btnExibirFiltro.Visible := aOcultar;
  btnExibirFiltro.position.Y := btnOcultarFiltro.position.Y;
  lytLateral.Visible := not aOcultar;
end;


procedure TfrmGraphicsBase.btnExibirFiltroClick(Sender: TObject);
begin
  inherited;
  OcultarFiltro(False);
end;

procedure TfrmGraphicsBase.btnOcultarFiltroClick(Sender: TObject);
begin
  inherited;
  OcultarFiltro(True);
end;

end.
