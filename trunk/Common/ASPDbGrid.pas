unit ASPDbGrid;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Grids, DBGrids,
  DB, Forms, Graphics, StdCtrls, UITypes;

type

  EOnCheckFieldClick = procedure(Field: TField) of object;

  TASPDbGrid = class(TDBGrid)
  private
    FBookAnterior: TBookmark;
    FOnCheckFieldClick: EOnCheckFieldClick;

    function  KeyIsDown(const Key: Integer): Boolean;
    function  ControlMultiSelect: Boolean;
    procedure CheckUnCheckField(Field: TField);
    procedure DrawCheck(ACanvas: TCanvas; R: TRect; AFlat: Boolean; AState: TCheckBoxState; AEnabled: Boolean);
    function IsBooleanField(Field: TField): Boolean;
    function IsBlobField(Field: TField): Boolean;

  protected
    procedure DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState); override;

    function CanEditShow: Boolean; Override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure DoEnter; override;
    procedure Scroll(Distance: Integer); override;
    procedure Paint; override;
    procedure CellClick(Column: TColumn); override;
    procedure DrawColumnCell(const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState); override;
    procedure ColEnter; override;
    procedure KeyPress(var Key: Char); override;

    procedure DoOnCheckFieldClick(Field: TField); virtual;
  public
    procedure CreateWnd; override;
  published
    property OnCheckFieldClick: EOnCheckFieldClick read FOnCheckFieldClick write FOnCheckFieldClick;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TASPDbGrid]);
end;

{ TASPDbGrid }

function TASPDbGrid.KeyIsDown(const Key: Integer): Boolean;
begin
  Result := GetKeyState(Key) and 128 > 0;
end;

function TASPDbGrid.ControlMultiSelect: Boolean;
begin
  Result :=
    (Assigned(DataSource)) and
    (Assigned(DataSource.DataSet)) and
    (dgMultiSelect in Self.Options);
end;

procedure TASPDbGrid.CheckUnCheckField(Field: TField);
begin
  if Self.ReadOnly Then
     Exit;

  with Field.DataSet do
  begin
    if not (State in dsEditModes) then
      Edit;
    Field.AsBoolean := not Field.AsBoolean;

    DoOnCheckFieldClick(Field);
  end;
end;

function TASPDbGrid.IsBlobField(Field: TField): Boolean;
begin
  Result := (Field <> nil) and (Field is TBlobField);
end;

function TASPDbGrid.IsBooleanField(Field: TField): Boolean;
begin
  Result := (Field <> nil) and ( (Field is TBooleanField) or (Field.Tag = 1) );
end;

procedure TASPDbGrid.DrawCell(ACol, ARow: Integer; ARect: TRect;
  AState: TGridDrawState);
var
  LOldDefaultDrawing: Boolean;
  LCol: Integer;
begin
  LCol := aCol;
  Dec(LCol, 1);
  if ((Columns.Count > LCol) and (LCol > -1) and IsBooleanField(Columns[LCol].Field)) then
  begin
    LOldDefaultDrawing := DefaultDrawing;
    DefaultDrawing := False;
    try
      inherited;
    finally
      DefaultDrawing := LOldDefaultDrawing;
    end;
  end
  else
    inherited;
end;

procedure TASPDbGrid.DrawCheck(ACanvas: TCanvas; R: TRect;
  AFlat: Boolean; AState: TCheckBoxState; AEnabled: Boolean);
const
  cCheckWidth  = 13;
  cCheckHeight = 13;
var
  DrawState: Integer;
  DrawRect: TRect;
  OldBrushColor: TColor;
  OldBrushStyle: TBrushStyle;
  OldPenColor: TColor;
  Rgn, SaveRgn: HRgn;
//D7  ElementDetails: TThemedElementDetails;
begin
  SaveRgn := 0;
  DrawRect.Left := R.Left + (R.Right - R.Left - cCheckWidth) div 2;
  DrawRect.Top := R.Top + (R.Bottom - R.Top - cCheckHeight) div 2;
  DrawRect.Right := DrawRect.Left + cCheckWidth;
  DrawRect.Bottom := DrawRect.Top + cCheckHeight;
  with ACanvas do
  begin
    if AFlat then
    begin
      { Remember current clipping region }
      SaveRgn := CreateRectRgn(0,0,0,0);
      GetClipRgn(Handle, SaveRgn);
      { Clip 3d-style checkbox to prevent flicker }
      with DrawRect do
        Rgn := CreateRectRgn(Left + 2, Top + 2, Right - 2, Bottom - 2);
      SelectClipRgn(Handle, Rgn);
      DeleteObject(Rgn);
    end;

{   if ThemeServices.ThemesEnabled then
   begin
      case AState of
        cbChecked:
          if AEnabled then
            ElementDetails := ThemeServices.GetElementDetails(tbCheckBoxCheckedNormal)
          else
            ElementDetails := ThemeServices.GetElementDetails(tbCheckBoxCheckedDisabled);
        cbUnchecked:
          if AEnabled then
            ElementDetails := ThemeServices.GetElementDetails(tbCheckBoxUncheckedNormal)
          else
            ElementDetails := ThemeServices.GetElementDetails(tbCheckBoxUncheckedDisabled)
        else // cbGrayed
          if AEnabled then
            ElementDetails := ThemeServices.GetElementDetails(tbCheckBoxMixedNormal)
          else
            ElementDetails := ThemeServices.GetElementDetails(tbCheckBoxMixedDisabled);
      end;
      ThemeServices.DrawElement(Handle, ElementDetails, R);
    end
    else
}
    begin
      case AState of
        cbChecked:
          DrawState := DFCS_BUTTONCHECK or DFCS_CHECKED;
        cbUnchecked:
          DrawState := DFCS_BUTTONCHECK;
        else // cbGrayed
          DrawState := DFCS_BUTTON3STATE or DFCS_CHECKED;
      end;
      if not AEnabled then
        DrawState := DrawState or DFCS_INACTIVE;
      DrawFrameControl(Handle, DrawRect, DFC_BUTTON, DrawState);
    end;

    if AFlat then
    begin
      SelectClipRgn(Handle, SaveRgn);
      DeleteObject(SaveRgn);
      { Draw flat rectangle in-place of clipped 3d checkbox above }
      OldBrushStyle := Brush.Style;
      OldBrushColor := Brush.Color;
      OldPenColor := Pen.Color;
      Brush.Style := bsClear;
      Pen.Color := clBtnShadow;
      with DrawRect do
        Rectangle(Left + 1, Top + 1, Right - 1, Bottom - 1);
      Brush.Style := OldBrushStyle;
      Brush.Color := OldBrushColor;
      Pen.Color := OldPenColor;
    end;
  end;
end;

procedure TASPDbGrid.CreateWnd;
begin
  inherited;

  if not (csDesigning in ComponentState) then ColEnter;
end;

procedure TASPDbGrid.Scroll(Distance: Integer);
begin
  inherited;

  if not ControlMultiSelect then Exit;

  if (Self.SelectedRows.Count = 0) and (not KeyIsDown(VK_SHIFT)) then
    Self.FBookAnterior := DataSource.DataSet.GetBookmark;
end;

procedure TASPDbGrid.DoEnter;
begin
  inherited;

  if not ControlMultiSelect then Exit;

  if (Self.SelectedRows.Count = 0) then
    Self.SelectedRows.CurrentRowSelected := True
end;

procedure TASPDbGrid.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if not ControlMultiSelect then
  begin
    inherited;
    Exit;
  end;

  if (ssShift in Shift) and (Key in [VK_END, VK_HOME] ) then
  begin
    with Self do
    begin
      SelectedRows.CurrentRowSelected := true;
      DataSource.DataSet.GotoBookmark(SelectedRows.Items[0]);
      if Key = VK_END then
      begin
        while not DataSource.DataSet.Eof do
        begin
          DataSource.DataSet.Next;
          SelectedRows.CurrentRowSelected := true;
        end;
      end
      else
      begin
        while not DataSource.DataSet.Bof do
        begin
          DataSource.DataSet.Prior;
          SelectedRows.CurrentRowSelected := true;
        end;
      end;
    end;
    Key := 0;
  end;

  inherited;
end;

procedure TASPDbGrid.KeyUp(var Key: Word; Shift: TShiftState);
begin
  if not ControlMultiSelect then
  begin
    inherited;
    Exit;
  end;

  if Key in [VK_UP, VK_DOWN, VK_HOME, VK_END, VK_PRIOR, VK_NEXT] then
    if (Self.SelectedRows.Count = 0) then
       Self.SelectedRows.CurrentRowSelected := True;

  inherited;
end;

procedure TASPDbGrid.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
  RecNoAtual, RecNoAnterior, RecIr: Integer;
  BookAtual: TBookMark;
begin
  inherited;

  if not ControlMultiSelect then Exit;

  if not (ssShift in Shift) then
  begin
    FBookAnterior := DataSource.DataSet.GetBookmark;
  end;

  if (ssShift in Shift) then
  begin

    try
      DataSource.DataSet.DisableControls;

      try
        RecNoAtual := DataSource.DataSet.RecNo;
        BookAtual := DataSource.DataSet.GetBookMark;

        DataSource.DataSet.GotoBookmark(FBookAnterior);
        RecNoAnterior := DataSource.DataSet.RecNo;

        if RecNoAtual<RecNoAnterior then
        begin
           DataSource.DataSet.GotoBookmark(BookAtual);
           RecIr := RecNoAnterior;
        end
        else
        begin
            RecIr := RecNoAtual;
        end;

        while DataSource.DataSet.RecNo <> RecIr do
        begin
          Self.SelectedRows.CurrentRowSelected := True;
          DataSource.DataSet.Next;
        end;


      finally
        DataSource.DataSet.EnableControls;
      end;
    finally

    end;
  end;
end;

procedure TASPDbGrid.Paint;
begin
  if (Self.DataSource <> nil) and (Self.DataSource.DataSet <> nil) and
    (Self.DataSource.DataSet.Active) then
    if ((Self.DataSource.DataSet.RecordCount+1) * Self.DefaultRowHeight) < Self.ClientHeight then
      ShowScrollBar (Self.Handle, SB_VERT, False)
    else
      ShowScrollBar (Self.Handle, SB_VERT, true);

  inherited Paint;
end;

function TASPDbGrid.CanEditShow: Boolean;
//var
//  LCol: Integer;
begin
  //Não editar o texto de campos booleano
  Result := inherited CanEditShow;
{  if Result then
  begin
    LCol := Col;
    Dec(LCol, 1);
    Result := (not ((Columns.Count > LCol) and (LCol > -1) and IsBooleanField(Columns[LCol].Field)));
  end;                   }
end;

procedure TASPDbGrid.CellClick(Column: TColumn);
begin
  if IsBooleanField(SelectedField) then
    CheckUnCheckField(SelectedField);

  inherited;
end;

procedure TASPDbGrid.DrawColumnCell(const Rect: TRect; DataCol: Integer;
  Column: TColumn; State: TGridDrawState);
var
  CheckBoxState: TCheckBoxState;
begin
  Canvas.FillRect(Rect);
  inherited;
  with Self do
  begin
    if (Column <> nil) and (Column.Field <> nil) and IsBooleanField(Column.Field) then
    begin
       Canvas.FillRect(Rect);
      // desenhando checkbox
      if Column.Field.AsBoolean then
        CheckBoxState := cbChecked
      else
        CheckBoxState := cbUnchecked;

      DrawCheck(Canvas, Rect, False, CheckBoxState, True);

    end else   if(not IsBlobField(Column.Field))then
      DefaultDrawColumnCell(Rect, DataCol, Column, State);
  end;
end;


procedure TASPDbGrid.ColEnter;
begin
  if IsBooleanField(SelectedField) then
    Options := Options - [dgEditing]
  else
    Options := Options + [dgEditing];

  inherited;
end;

procedure TASPDbGrid.KeyPress(var Key: Char);
begin
  if (Key = #32) and IsBooleanField(SelectedField) then
    CheckUnCheckField(SelectedField);

  inherited;
end;

procedure TASPDbGrid.DoOnCheckFieldClick(Field: TField);
begin
	if Assigned(FOnCheckFieldClick) then
		FOnCheckFieldClick(Field);
end;

end.

