unit untCommonFrameIndicadorPerformance;

interface
{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  {$IFNDEF IS_MOBILE}
  Windows, Messages, ScktComp,
  {$ENDIF}
  FMX.Grid, FMX.Controls, FMX.Forms, FMX.Graphics,
  FMX.Dialogs, FMX.StdCtrls, FMX.ExtCtrls, FMX.Types, FMX.Layouts, FMX.ListView.Types,
  FMX.ListView, FMX.ListBox,
   Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors, FMX.Objects, FMX.Edit, FMX.TabControl,

  System.UIConsts,
  MyAspFuncoesUteis, System.UITypes, System.Types, System.SysUtils, System.Classes, System.Variants, Data.DB, Datasnap.DBClient, System.Rtti,
  Data.Bind.EngExt, Data.Bind.Components,
  Data.Bind.Grid, Data.Bind.DBScope,
  untCommonFrameBase, FMX.Controls.Presentation, System.ImageList,
  FMX.ImgList, FMX.Effects, FMX.Grid.Style, FMX.ScrollBox;

type
  TFraIndicadorPerformance = class(TFrameBase)
    CDSPIsClone: TClientDataSet;
    dtsPIs: TDataSource;
    bndPIS: TBindSourceDB;
    grdPIs: TGrid;
    LinkGridPI: TLinkGridToDataSource;
    procedure grdPIsDrawColumnCell(Sender: TObject; const Canvas: TCanvas; const Column: TColumn; const Bounds: TRectF; const Row: Integer;
      const Value: TValue; const State: TGridDrawStates);
    procedure FrameResize(Sender: TObject);
  private
    procedure SetIDUnidade(const aValue: Integer); override;
    procedure SetupDataset(const aIdUnidade: Integer);
  protected
    procedure SetVisible(const Value: Boolean); Override;
  public
    PIsUpdateTimer: TTimer;
    procedure AtualizarColunasGrid; Override;
    constructor Create(owner: TComponent); Overload; Override;
    constructor Create(owner: TComponent; const aIdUnidade: Integer); reintroduce; Overload; virtual;
    destructor Destroy; Override;
    procedure PIsUpdateTimerTimer(Sender: TObject);
  end;

function FraIndicadorPerformance(const aIDUnidade: integer; const aAllowNewInstance: Boolean = False; const aOwner: TComponent = nil): TFraIndicadorPerformance;

implementation

{$R *.fmx}

uses
  untCommonDMClient, untCommonDMConnection, Sics_Common_Parametros,
  untCommonDMUnidades, uPI;

{ TFraIndicadorPerformance }

function FraIndicadorPerformance (const aIDUnidade: integer; const aAllowNewInstance: Boolean = False;
                                  const aOwner: TComponent = nil): TFraIndicadorPerformance;
begin
  Result := TFraIndicadorPerformance(TFraIndicadorPerformance.GetInstancia(aIDUnidade, aAllowNewInstance, aOwner));
end;

procedure TFraIndicadorPerformance.SetIDUnidade(const aValue: Integer);
var
  LID: Integer;
begin
  LID := IDUnidade;

  inherited;

  if LID <> aValue then
  begin
    SetupDataset(aValue);

    if PIsUpdateTimer.Enabled then
      PIsUpdateTimerTimer(Self);
  end;
end;

procedure TFraIndicadorPerformance.AtualizarColunasGrid;
var
  LDMClient: TDMClient;
begin
  if Visible then
  begin
    LDMClient := DMClient(IDUnidade, not CRIAR_SE_NAO_EXISTIR);
    if Assigned(LDMClient) then
      AspUpdateColunasGrid(Self, LinkGridPI, LDMClient.CDSPIs);
  end;
end;

procedure TFraIndicadorPerformance.SetupDataset(const aIdUnidade: Integer);
var
  LDMClient: TDMClient;
begin
  CDSPIsClone.Close;
  LDMClient := DMClient(aIdUnidade, not CRIAR_SE_NAO_EXISTIR);
  if not LDMClient.CDSPIs.Active then
    LDMClient.CDSPIs.CreateDataSet;
  CDSPIsClone.CloneCursor(LDMClient.CDSPIs, False, False);
  bndPIS.DataSource := dtsPIs;
  AtualizarColunasGrid;
end;


constructor TFraIndicadorPerformance.Create(owner: TComponent; const aIdUnidade: Integer);
var
  LDMClient: TDMClient;
begin
  Create(owner);
  IDUnidade := aIDUnidade;
end;

constructor TFraIndicadorPerformance.Create(owner: TComponent);
begin
  inherited;

  SetupDataset(IdUnidade);

  PIsUpdateTimer := TTimer.Create(Self);
  PIsUpdateTimer.Interval := 15000;
  PIsUpdateTimer.OnTimer := PIsUpdateTimerTimer;
  PIsUpdateTimer.Enabled := true;
end;

destructor TFraIndicadorPerformance.Destroy;
begin
  inherited;
end;

procedure TFraIndicadorPerformance.FrameResize(Sender: TObject);
begin
  inherited;
//
end;

procedure TFraIndicadorPerformance.grdPIsDrawColumnCell(Sender: TObject; const Canvas: TCanvas;
  const Column: TColumn; const Bounds: TRectF;
  const Row: Integer; const Value: TValue; const State: TGridDrawStates);
var
  LColor: TAlphaColor;
  RowColor : TBrush;
  sValue: String;
begin
  sValue := EmptyStr;

  if (Column.Index <> 5) then
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

  RowColor := Tbrush.Create(TBrushKind.Solid,TAlphaColors.Alpha);
  RowColor.Color := LColor;
  Canvas.FillRect(Bounds, 0, 0, [], 1, RowColor);

  TGrid(Sender).Columns[Column.Index].DefaultDrawCell(Canvas, Bounds, Row, Value, State);
end;

procedure TFraIndicadorPerformance.PIsUpdateTimerTimer(Sender: TObject);
begin
  PIsUpdateTimer.Enabled := False;

  try
    if Self.Visible then
    begin
      DMClient(IDUnidade, not CRIAR_SE_NAO_EXISTIR).SolicitarAtualizacaoPIs(Self.IDUnidade, False);


      {
      TPIManager.BuscarPIs(Self.IDUnidade.ToString,
                           vgParametrosModulo.CaminhoAPI,
                           CDSPIsClone);
      }
    end;
  finally
    PIsUpdateTimer.Enabled := True;
  end;
end;

procedure TFraIndicadorPerformance.SetVisible(const Value: Boolean);
begin
  inherited;

end;

end.

