unit untCommonTCombobox;

interface
uses
  FMX.ListBox, FMX.Controls;

type
  TCombobox = class(FMX.ListBox.TCombobox)
  protected
    procedure AdjustFixedSize(const Ref: TControl); override;
  end;

implementation

uses
  FMX.Types;

procedure TCombobox.AdjustFixedSize(const Ref: TControl);
begin
  SetAdjustType(TAdjustType.None);
end;
end.
