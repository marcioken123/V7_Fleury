unit ufrmDashboard;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  untCommonFrameBase, Data.Bind.EngExt, Fmx.Bind.DBEngExt, System.ImageList,
  FMX.ImgList, Data.Bind.Components, FMX.Effects, FMX.Objects,
  FMX.Controls.Presentation, FMX.Layouts, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client, System.Rtti, FMX.Grid,
  FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Phys.SQLiteVDataSet, FMX.TabControl,
  Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.Grid,
  Data.Bind.DBScope, FMX.Edit, FMX.ListBox, FMXTee.Engine, FMXTee.Procs,
  FMXTee.Chart, FMXTee.Series, FMXTee.Animations.Tools, FMX.Grid.Style,
  FMX.ScrollBox, Datasnap.DBClient;

type
  TfraDashboard = class(TFrameBase)
    Grid1: TGrid;
    tcDashboard: TTabControl;
    tiDados: TTabItem;
    tiGrafico: TTabItem;
    bAtualizar: TButton;
    BindSourceDB1: TBindSourceDB;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    ToolBar1: TToolBar;
    Label1: TLabel;
    lblSoma: TLabel;
    Label2: TLabel;
    lblMedia: TLabel;
    Label4: TLabel;
    lblMinimo: TLabel;
    Label6: TLabel;
    lblMaximo: TLabel;
    memIndicadores: TFDMemTable;
    memIndicadoresNomeIndicador: TStringField;
    memIndicadoresSelecionado: TBooleanField;
    memIndicadoresFlagValorEmSegundos: TBooleanField;
    memIndicadoresTipoGrafico: TByteField;
    Layout1: TLayout;
    pnlUnidades: TRectangle;
    Rectangle8: TRectangle;
    Label18: TLabel;
    lbUnidades: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    cmbIndicadores: TComboBox;
    Chart: TChart;
    Series1: TBarSeries;
    Series2: TPieSeries;
    TimerAutoRefresh: TTimer;
    Rectangle1: TRectangle;
    cdsPIs: TClientDataSet;
    cdsPIsSOMA: TAggregateField;
    cdsPIsID: TIntegerField;
    cdsPIsUNIDADE: TStringField;
    cdsPIsPI: TStringField;
    cdsPIsVALOR_NUMERICO: TIntegerField;
    cdsPIsESTADO: TStringField;
    cdsPIsCREATEDAT: TFloatField;
    cdsPIsMEDIA: TAggregateField;
    cdsPIsMINIMO: TAggregateField;
    cdsPIsMAXIMO: TAggregateField;
    procedure lbUnidadesChangeCheck(Sender: TObject);
    procedure cmbIndicadoresChange(Sender: TObject);
    procedure ChartGetAxisLabel(Sender: TChartAxis; Series: TChartSeries;
      ValueIndex: Integer; var LabelText: string);
    procedure TimerAutoRefreshTimer(Sender: TObject);
    procedure bAtualizarClick(Sender: TObject);
    procedure Grid1DrawColumnCell(Sender: TObject; const Canvas: TCanvas;
      const Column: TColumn; const Bounds: TRectF; const Row: Integer;
      const Value: TValue; const State: TGridDrawStates);
    procedure SeriesGetMarkText(Sender: TChartSeries; ValueIndex: Integer;
      var MarkText: string);
    procedure VALOR_NUMERICO_GetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure CRIADO_GetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure cdsPIsAfterClose(DataSet: TDataSet);
    procedure cdsPIsAfterOpen(DataSet: TDataSet);
  private
    PIsUpdateTimer: TTimer;
    procedure AtualizaRodape;

    const TEXTO_BOTAO_ATUALIZAR = 'Atualizar (%ds)';
    const SEGUNDOS_AUTO_REFRESH = 30;

    procedure AtualizarDados;
    constructor Create(AOwner: TComponent); override;
    procedure CarregarUnidades;
    procedure CarregarIndicadores;
    procedure AtualizarGrid;
    procedure AtualizarGrafico;
    function GetDiasHorasMinSeg(const AQtdSecs: Integer): String;
    procedure PIsUpdateTimerTimer(Sender: TObject);
  public
    procedure RecarregarConfiguracoes;
  end;

function FraDashboard (const aIDUnidade: integer;
  const aAllowNewInstance: Boolean = False;
  const aOwner: TComponent = nil): TFraDashboard;

implementation

{$R *.fmx}

uses untCommonDMUnidades, untCommonDMClient, Sics_Common_Parametros,
  System.DateUtils, Winapi.Windows, System.UIConsts, untLog, uPI;

function FraDashboard (const aIDUnidade: integer;
  const aAllowNewInstance: Boolean = False;
  const aOwner: TComponent = nil): TFraDashboard;
begin
  Result := TFraDashboard(TFraDashboard.GetInstancia(aIDUnidade, aAllowNewInstance, aOwner));
end;

constructor TfraDashboard.Create(AOwner: TComponent);
begin
  inherited;
  tcDashboard.ActiveTab := tiGrafico;

  CarregarUnidades;
  CarregarIndicadores;

  PIsUpdateTimer := TTimer.Create(Self);
  PIsUpdateTimer.Interval := 15000;
  PIsUpdateTimer.OnTimer := PIsUpdateTimerTimer;
  PIsUpdateTimer.Enabled := True;

  TimerAutoRefresh.Tag := 1;
  TimerAutoRefreshTimer(TimerAutoRefresh);
end;

procedure TfraDashboard.CRIADO_GetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  Text := FormatDateTime('DD/MM HH:NN:SS', Sender.AsFloat);
end;

procedure TfraDashboard.PIsUpdateTimerTimer(Sender: TObject);
begin
  PIsUpdateTimer.Enabled := False;
  try
    if Self.Visible then
    begin
      dmUnidades.cdsUnidadesclone.First;
      while not dmUnidades.cdsUnidadesclone.Eof do
      begin
        DMClient(IDUnidade, not CRIAR_SE_NAO_EXISTIR).SolicitarAtualizacaoPIs(
          dmUnidades.cdsUnidadesClone.FieldByName('ID').Value, False);

        dmUnidades.cdsUnidadesclone.Next;
      end;
    end;
  finally
    PIsUpdateTimer.Enabled := True;
  end;
end;

function TfraDashboard.GetDiasHorasMinSeg(const AQtdSecs: Integer): String;
const
  SecPerMinute = 60;
  SecPerHour   = SecPerMinute * 60;
  SecPerDay    = SecPerHour   * 24;
var
  {ms, }ss, mm, hh, dd: Cardinal;
begin
  result := EmptyStr;

  dd := AQtdSecs div SecPerDay;
  hh := (AQtdSecs mod SecPerDay) div SecPerHour;
  mm := ((AQtdSecs mod SecPerDay) mod SecPerHour) div SecPerMinute;
  ss := ((AQtdSecs mod SecPerDay) mod SecPerHour) mod SecPerMinute;

  result := FormatFloat('00', ss) + 's';

  if (mm > 0) or (hh > 0) or (dd > 0) then
  begin
    result := FormatFloat('00', mm) + 'm' + result;

    if (hh > 0) or (dd > 0) then
    begin
      result := FormatFloat('00', hh) + 'h' + result;

      if (dd > 0) then
        result := dd.ToString + 'd' + result;
    end;
  end;
end;

procedure TfraDashboard.Grid1DrawColumnCell(Sender: TObject;
  const Canvas: TCanvas; const Column: TColumn; const Bounds: TRectF;
  const Row: Integer; const Value: TValue; const State: TGridDrawStates);
var
  LColor: TAlphaColor;
  RowColor : TBrush;
  sValue: String;
begin
  sValue := '';

  if (Column.Index <> 2) then
    Exit;
  sValue := Value.AsString;
  {else sValue := grdPIs.Cells[2, Row];     }//Descomentar para pintar a linha toda

  if sValue = 'Normal' then
    LColor := claLime
  else if sValue = 'Atenção' then
    LColor := claYellow
  else if sValue = 'Crítico' then
    LColor := claRed
  else
    Exit;

  RowColor := TBrush.Create(TBrushKind.Solid, Canvas.Fill.Color {TAlphaColors.Alpha});
  RowColor.Color := LColor;
  Canvas.FillRect(Bounds, 0, 0, [], 1, RowColor);

  Column.DefaultDrawCell(Canvas, Bounds, Row, Value, State);
end;

procedure TfraDashboard.CarregarUnidades;
begin
  lbUnidades.BeginUpdate;
  try
    lbUnidades.Clear;
    dmUnidades.cdsUnidadesClone.First;
    while not dmUnidades.cdsUnidadesClone.Eof do
    begin
      lbUnidades.Items.Add(dmUnidades.cdsUnidadesClone.FieldByName('NOME').AsString);
      if dmUnidades.cdsUnidadesClone.FieldByName('CONECTADA').AsBoolean then
        lbUnidades.ItemByIndex(lbUnidades.Count - 1).IsChecked := True;
      dmUnidades.cdsUnidadesClone.Next;
    end;
  finally
    lbUnidades.EndUpdate;
  end;
end;

procedure TfraDashboard.ChartGetAxisLabel(Sender: TChartAxis;
  Series: TChartSeries; ValueIndex: Integer; var LabelText: string);
var
  LSecs: Integer;
begin
  inherited;

  if memIndicadoresFlagValorEmSegundos.Value then
    if TryStrToInt(LabelText, LSecs) then
      LabelText := GetDiasHorasMinSeg(LSecs);

//  if memIndicadoresFlagValorEmSegundos.Value then
//    MarkText := GetDiasHorasMinSeg(Round(Sender.XValue[ValueIndex]));
end;

procedure TfraDashboard.cdsPIsAfterClose(DataSet: TDataSet);
begin
  lblSoma.Text   := '-';
  lblMedia.Text  := '-';
  lblMinimo.Text := '-';
  lblMaximo.Text := '-';
end;

procedure TfraDashboard.cdsPIsAfterOpen(DataSet: TDataSet);
begin
  Dataset.FieldByName('UNIDADE').DisplayLabel := 'Unidade';
  Dataset.FieldByName('ESTADO').DisplayLabel  := 'Estado';
  with Dataset.FieldByName('VALOR_NUMERICO') do
  begin
    DisplayLabel := 'Valor';
    OnGetText    := VALOR_NUMERICO_GetText;
  end;

  TFloatField(Dataset.FieldByName('CREATEDAT')).OnGetText := CRIADO_GetText;
  Dataset.FieldByName('CREATEDAT').DisplayLabel := 'Última Atualização';
  AtualizaRodape;
end;

procedure TfraDashboard.cmbIndicadoresChange(Sender: TObject);
begin
  inherited;

  if not cmbIndicadores.IsUpdating then
  begin
    memIndicadores.RecNo := cmbIndicadores.ItemIndex+1;
    bAtualizarClick(Sender);
  end;
end;

procedure TfraDashboard.CarregarIndicadores;
begin
  cmbIndicadores.BeginUpdate;
  try
    cmbIndicadores.Clear;

    memIndicadores.Close;
    memIndicadores.Filtered := False;

    try
      memIndicadores.LoadFromFile(FDashboardConfigFileName);
    except
      on E: Exception do
      begin
        TLog.MyLog(E.Message, nil);
        memIndicadores.Open;
      end;
    end;

    memIndicadores.Filter := 'SELECIONADO';
    memIndicadores.Filtered := True;
    if memIndicadores.IsEmpty then
    begin
      cmbIndicadores.Clear;
      exit;
    end;

    memIndicadores.First;
    while not memIndicadores.Eof do
    begin
      if memIndicadoresSelecionado.Value then
        cmbIndicadores.Items.Add(memIndicadoresNomeIndicador.AsString);
      memIndicadores.Next;
    end;

    cmbIndicadores.ItemIndex := 0;
    memIndicadores.First;
  finally
    cmbIndicadores.EndUpdate;
  end;
end;

procedure TfraDashboard.AtualizarGrid;
var
  i: Integer;
begin
  for i := 0 to LinkGridToDataSourceBindSourceDB1.Columns.Count - 1 do
    LinkGridToDataSourceBindSourceDB1.Columns[i].Width := 200;
end;

procedure TfraDashboard.bAtualizarClick(Sender: TObject);
begin
  inherited;

  bAtualizar.Enabled := False;
  try
    AtualizarDados;
  finally
    TimerAutoRefresh.Tag := SEGUNDOS_AUTO_REFRESH;
    if Sender <> TimerAutoRefresh then
      bAtualizar.Text := Format(TEXTO_BOTAO_ATUALIZAR, [TimerAutoRefresh.Tag]);
    bAtualizar.Enabled := True;
  end;
end;

procedure TfraDashboard.AtualizarGrafico;
var
  LCor: TAlphaColor;
  LTipoGrafico: TTipoGrafico;
begin
  Series1.Clear;
  Series2.Clear;

  if not cdsPIs.Active then
    exit;

  cdsPIs.First;
  while not cdsPIs.Eof do
  begin
    if cdsPIs.FieldByName('ESTADO').AsString = 'Crítico' then
      LCor := TAlphaColor($FFFF5050) //Alpha, Red, Green e Blue
    else if cdsPIs.FieldByName('ESTADO').AsString = 'Atenção' then
      LCor := TAlphaColor($FFFFFF50) //Alpha, Red, Green e Blue
    else
      LCor := TAlphaColor($FF50FF50);//Alpha, Red, Green e Blue;

    Series1.Add(cdsPIs.FieldByName('VALOR_NUMERICO').AsFloat,
                cdsPIs.FieldByName('UNIDADE').AsString,
                LCor);

    Series2.Add(cdsPIs.FieldByName('VALOR_NUMERICO').AsFloat,
                cdsPIs.FieldByName('UNIDADE').AsString,
                LCor);

    cdsPIs.Next;
  end;
  cdsPIs.First;

  LTipoGrafico := TTipoGrafico(memIndicadoresTipoGrafico.Value);
  Series1.Visible := (LTipoGrafico = tgBarras);
  Series2.Visible := (LTipoGrafico = tgPizza);

  if memIndicadoresFlagValorEmSegundos.AsBoolean then
    Chart.Tag := 1
  else
    Chart.Tag := 0;
end;

procedure TfraDashboard.lbUnidadesChangeCheck(Sender: TObject);
//var
//  lbi: TListBoxItem;
//  LId: Integer;
begin
  inherited;

  if not lbUnidades.IsUpdating then //IsUpdating=true quando chama BeginUpdate
  begin
//    lbi := (Sender as TListBoxItem);
//    LId := dmUnidades.IdUnidadeConformePosicaoNaLista(lbi.Index+1);

//    RA
//    if not dmUnidades.Conectada[LId] then
//    begin
//      ShowMessage('Unidade desconectada!');
//      abort;
//    end;

    bAtualizarClick(Sender);
  end;
end;

procedure TfraDashboard.VALOR_NUMERICO_GetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  inherited;

  if not memIndicadores.Active or memIndicadores.IsEmpty then
    Text := ''
  else if  memIndicadoresFlagValorEmSegundos.AsBoolean then
    Text := GetDiasHorasMinSeg(Sender.AsInteger)
  else
    Text := Sender.AsString;
end;

procedure TfraDashboard.RecarregarConfiguracoes;
var
  LOldSel, LPosicaoIndicador: Integer;
  LOldSelStr: String;
  LJaAtualizou: Boolean;
begin
  LJaAtualizou := False;

  LOldSel := cmbIndicadores.ItemIndex;
  if LOldSel >= 0 then
    LOldSelStr := cmbIndicadores.Selected.Text;

  CarregarIndicadores;

  if LOldSel > 0 then
  begin
    LPosicaoIndicador := cmbIndicadores.Items.IndexOf(LOldSelStr);
    if LPosicaoIndicador <> LOldSel then
    begin
      cmbIndicadores.ItemIndex := LPosicaoIndicador;
      LJaAtualizou := True; //pois o onChange do cmbIndicadores será disparado
    end;
  end;

  if not LJaAtualizou then
    bAtualizarClick(Self);
end;

procedure TfraDashboard.SeriesGetMarkText(Sender: TChartSeries;
  ValueIndex: Integer; var MarkText: string);
begin
  inherited;

  if Sender is TPieSeries then
  begin
    MarkText := Series1.XLabel[ValueIndex] + sLineBreak;
    if memIndicadoresFlagValorEmSegundos.Value then
      MarkText := MarkText + GetDiasHorasMinSeg(Round(Sender.YValue[ValueIndex]))
    else
      MarkText := MarkText + Sender.YValue[ValueIndex].ToString
  end
  else if Sender is TBarSeries then
  begin
    if memIndicadoresFlagValorEmSegundos.Value then
      MarkText := GetDiasHorasMinSeg(Round(Sender.YValue[ValueIndex]))
  end;
end;

procedure TfraDashboard.TimerAutoRefreshTimer(Sender: TObject);
begin
  inherited;
  TimerAutoRefresh.Enabled := False;
  try
    TimerAutoRefresh.Tag := TimerAutoRefresh.Tag-1;
    if TimerAutoRefresh.Tag = 0 then
    begin
      bAtualizar.Text := 'Atualizando...';
      bAtualizarClick(Sender);
      TimerAutoRefresh.Tag := SEGUNDOS_AUTO_REFRESH;
    end;

    bAtualizar.Text := Format(TEXTO_BOTAO_ATUALIZAR, [TimerAutoRefresh.Tag]);
  finally
    TimerAutoRefresh.Enabled := True;
  end;
end;

procedure TfraDashboard.AtualizarDados;

  procedure RemoverSelecaoUnidadeDesconectada(const AListBoxItem: TListBoxItem);
  begin
    //usa o BeginUpdate para que a mudança do IsChecked não dispare o
    //evento onChangeCheck do ListBox
    lbUnidades.BeginUpdate;
    try
      AListBoxItem.IsChecked := False;
    finally
      lbUnidades.EndUpdate;
    end;
  end;

var
//  LDMClient: TDMClient;
  LId: Integer;
  LIndicador: String;
  i: Integer;
  lbi: TListBoxItem;

  LUnidades: TStrings;
begin
  if cmbIndicadores.Count = 0 then
    exit;

  if cmbIndicadores.ItemIndex < 0 then
  begin
    ShowMessage('Nenhum indicador selecionado!');
    abort;
  end;
  LIndicador := cmbIndicadores.Selected.Text;

  LUnidades := TStringList.Create;
  try
    for i := 0 to lbUnidades.Count-1 do
    begin
      lbi := lbUnidades.ItemByIndex(i);
      if lbi.IsChecked then
      begin
        LId := dmUnidades.IdUnidadeConformePosicaoNaLista(i+1);
        LUnidades.Add(LId.ToString);
      end;
    end;

    if LUnidades.Count = 0 then
    begin
      ShowMessage('Nenhuma unidade selecionada!');
      abort;
    end;

    TPIManager.BuscarPIs(LUnidades.CommaText,
                         vgParametrosModulo.CaminhoAPI,
                         cdsPIs);

    cdsPIs.Filtered := False;
    cdsPIs.Filter   := 'PI = ' + QuotedStr(cmbIndicadores.Selected.Text);
    cdsPIs.Filtered := True;

    AtualizaRodape;
  finally
    FreeAndNil(LUnidades);
  end;

  AtualizarGrid;
  AtualizarGrafico;
end;

procedure TfraDashboard.AtualizaRodape;

  procedure SetLabelText(ALabel: TLabel; AField: TAggregateField; InSecs: Boolean);
  begin
    if VarIsNull(AField.Value) then
      ALabel.Text := '-'
    else
    begin
      if InSecs then
        ALabel.Text := GetDiasHorasMinSeg(Round(StrToFloatDef(AField.AsString,0)))
      else
        ALabel.Text := AField.AsString
    end;
  end;

begin
  SetLabelText(lblSoma,   cdsPIsSOMA,   memIndicadoresFlagValorEmSegundos.Value);
  SetLabelText(lblMedia,  cdsPIsMEDIA,  memIndicadoresFlagValorEmSegundos.Value);
  SetLabelText(lblMinimo, cdsPIsMINIMO, memIndicadoresFlagValorEmSegundos.Value);
  SetLabelText(lblMaximo, cdsPIsMAXIMO, memIndicadoresFlagValorEmSegundos.Value);
end;

end.
