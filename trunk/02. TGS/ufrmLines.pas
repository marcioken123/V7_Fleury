unit ufrmLines;
//renomeado unit SixTgs_2;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  FMX.Grid, FMX.Controls, FMX.Forms, FMX.Graphics,
  FMX.Dialogs, FMX.StdCtrls, FMX.ExtCtrls, FMX.Types, FMX.Layouts, FMX.ListView.Types,
  FMX.ListView, FMX.ListBox,
  Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors, FMX.Objects, FMX.Edit, FMX.TabControl,
  System.UITypes, System.Types, System.SysUtils, System.Classes, System.Variants, Data.DB, System.Rtti,
  Data.Bind.EngExt, Data.Bind.Components,
  Data.Bind.Grid, Data.Bind.DBScope, System.UIConsts,
  MyAspFuncoesUteis,
  IniFiles, untMainForm,
  untCommonFrameBase, FMX.Controls.Presentation, Datasnap.DBClient,
  untCommonFormBase, System.ImageList, FMX.ImgList, FMX.Effects, FMX.Grid.Style,
  FMX.ScrollBox;

type
  TfrmLines = class(TFrameBase)
    LinesGrid: TGrid;
    CloseBtn: TButton;
    cdsFila: TClientDataSet;
    cdsFilaNOME: TStringField;
    cdsFilaTEMPO_ESPERA: TDateTimeField;
    cdsFilaFILA: TIntegerField;
    cdsFilaSENHA: TIntegerField;
    lblTotalSenhas: TLabel;
    bnd1: TBindSourceDB;
    LinkGridToDataSourcebnd1: TLinkGridToDataSource;
    cdsFilaMAIOR_ESPERA: TTimeField;
    rectTotalSenhas: TRectangle;
    procedure CloseBtnClick(Sender: TObject);
    procedure cdsFilaAfterPost(DataSet: TDataSet);
    procedure cdsFilaAfterDelete(DataSet: TDataSet);
    procedure LinesGridDrawColumnCell(Sender: TObject; const Canvas: TCanvas; const Column: TColumn; const Bounds: TRectF; const Row: Integer;
      const Value: TValue; const State: TGridDrawStates);
    procedure cdsFilaCalcFields(DataSet: TDataSet);
  private
    { Private declarations }
    FirstPswds, TotalSenhas: Integer;
    FirstTime: TDateTime;
    procedure SetIDUnidade(const aValue: Integer); override;
  public
    { Public declarations }
    destructor Destroy; Override;
    procedure ClearGrid;
    procedure UpdateSituation(const aFila, aSenha: integer; const aTIM: TDateTime);
    procedure InsertFila(const aFila: integer; const aNome: string);
    procedure AtualizarTotalizadores;
	  constructor Create(aOwer: TComponent); Override;
  end;

  function frmLines(const aIDUnidade: integer; const aAllowNewInstance: Boolean = False; const aOwner: TComponent = nil): TFrmLines;

implementation


{$R *.fmx}

uses untCommonDMClient, Sics_Common_Parametros, untCommonDMConnection;

function frmLines(const aIDUnidade: integer; const aAllowNewInstance: Boolean = False; const aOwner: TComponent = nil): TFrmLines;
begin

  Result := TfrmLines(TfrmLines.GetInstancia(aIDUnidade, aAllowNewInstance, aOwner));
end;

procedure TfrmLines.SetIDUnidade(const aValue: Integer);
var
  LID: Integer;
  LDMClient: TDMClient;
  LDMConnection : TDMConnection;
begin
  LID := IDUnidade;

  inherited;

  if LID <> aValue then
  begin //reimporta a lista de Filas
    ClearGrid;

    LDMClient := DMClient(IDUnidade, not CRIAR_SE_NAO_EXISTIR);
    if not Assigned(LDMClient) then
      exit;

    LDMClient.cdsFilas.First;
    while not LDMClient.cdsFilas.Eof do
    begin
      InsertFila(LDMClient.cdsFilasID.Value,
                 LDMClient.cdsFilasNome.AsString);
      LDMCLient.cdsFilas.Next;
    end;
    LDMConnection := DMConnection(IDUnidade, not CRIAR_SE_NAO_EXISTIR);
    LDMConnection.EnviarComando(cProtocoloPAVazia + Chr($34), FIDUnidade);

  end;
end;

procedure TfrmLines.AtualizarTotalizadores;

  procedure CalcularTotalizadores;
  var
    nOldrecno: Integer;
  begin
    TotalSenhas := 0;
    FirstPswds := 1;
    FirstTime := now;
    cdsFila.DisableControls;
    try
      nOldrecno := cdsFila.RecNo;
      try
        cdsFila.First;
        while not cdsFila.Eof do
        begin
          TotalSenhas := TotalSenhas + cdsFilaSENHA.AsInteger;
          if cdsFilaSENHA.AsInteger > FirstPswds then
            FirstPswds := cdsFilaSENHA.AsInteger;
          if cdsFilaMAIOR_ESPERA.AsDateTime < FirstTime then
            FirstTime := cdsFilaMAIOR_ESPERA.AsDateTime;

          cdsFila.Next;
        end;
      finally
        if (nOldrecno > 0) then
          cdsFila.RecNo := nOldrecno;
      end;
    finally
      cdsFila.EnableControls;
    end;
  end;

  procedure AtualizarInfoTotalizadores;
  begin
    lblTotalSenhas.Text := Format('Total senhas: %d', [TotalSenhas]);
  end;
begin
  CalcularTotalizadores;
  AtualizarInfoTotalizadores;
end;

procedure TfrmLines.cdsFilaAfterDelete(DataSet: TDataSet);
begin
  inherited;

  AtualizarTotalizadores;
end;

procedure TfrmLines.cdsFilaAfterPost(DataSet: TDataSet);
begin
  inherited;
  AtualizarTotalizadores;
end;

procedure TfrmLines.cdsFilaCalcFields(DataSet: TDataSet);
begin
  inherited;
  if ((cdsFilaTEMPO_ESPERA.AsDateTime > 0) and (cdsFilaSENHA.AsInteger > 0)) then
    cdsFilaMAIOR_ESPERA.AsDateTime := NOW - cdsFilaTEMPO_ESPERA.AsDateTime
  else
    cdsFilaMAIOR_ESPERA.AsDateTime := 0;
end;

procedure TfrmLines.ClearGrid;
begin
  while not cdsFila.IsEmpty do
  begin
    cdsFila.First;
    cdsFila.Delete;
  end;
end;

procedure TfrmLines.UpdateSituation(const aFila, aSenha: integer; const aTIM: TDateTime);
begin
  if cdsFila.Locate(cdsFilaFILA.FieldName, aFila, []) then
    cdsFila.Edit
  else
    cdsFila.Insert;
  cdsFilaSENHA.AsInteger := aSenha;
  cdsFilaFILA.AsInteger := aFila;

  if(aSenha <> 0)then
    cdsFilaTEMPO_ESPERA.AsDateTime := aTIM
  else
    cdsFilaTEMPO_ESPERA.AsString := '';

  cdsFila.Post;
end;

procedure TfrmLines.InsertFila(const aFila: integer; const aNome: string);
begin
  if cdsFila.Locate(cdsFilaFILA.FieldName, aFila, []) then
    cdsFila.Edit
  else
  begin
    cdsFila.Insert;
    cdsFilaFILA.AsInteger := aFila;
  end;

  cdsFilaNOME.AsString := aNome;
  cdsFilaTEMPO_ESPERA.Clear;
  cdsFila.Post;
end;


procedure TfrmLines.LinesGridDrawColumnCell(Sender: TObject;
  const Canvas: TCanvas; const Column: TColumn; const Bounds: TRectF;
  const Row: Integer; const Value: TValue; const State: TGridDrawStates);
var
   LStringGrid: TStringGrid;
begin
  inherited;
  if (Sender is TStringGrid) then
  begin
    LStringGrid := TStringGrid(Sender);
    if (((Column.Index = 1) and (cdsFilaSENHA.AsInteger = FirstPswds) or
        ((Column.Index = 2) and (cdsFilaMAIOR_ESPERA.AsDateTime = FirstTime)))) then
      LStringGrid.Canvas.Fill.Color := claSkyBlue
    else
    if (((Column.Index = 1) and (Pos('S', LStringGrid.Cells[4,Row]) > 0)) or
             ((Column.Index = 2) and (Pos('s', LStringGrid.Cells[4,Row]) > 0))) then
      LStringGrid.Canvas.Fill.Color := claYellow
    else
        LStringGrid.Canvas.Fill.Color := claBtnFace;


    if ((((Column.Index = 1) or (Row = 0))) or
        (((Column.Index <> 0) and (Row <> 0) and (Row <> LStringGrid.RowCount-1)))) then
    begin
      LStringGrid.Canvas.Font.Style := [];
    end
    else if (Column.Index <> 0)then
    begin
      LStringGrid.Canvas.Fill.Color := claGreen;
    end;

  end;
end;

procedure TfrmLines.CloseBtnClick(Sender: TObject);
begin
  Visible := False;
end;

constructor TfrmLines.Create(aOwer: TComponent);
begin
  inherited;
  cdsFila.CreateDataSet;

end;

destructor TfrmLines.Destroy;
begin
  inherited;
end;

end.
