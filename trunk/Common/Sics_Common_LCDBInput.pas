unit Sics_Common_LCDBInput;

interface
{$INCLUDE ..\AspDefineDiretivas.inc}


uses
  {$IFNDEF IS_MOBILE}
  Windows, Messages, ScktComp,
  {$ENDIF}
  FMX.Grid, FMX.Controls, FMX.Forms, FMX.Graphics,
  FMX.Dialogs, FMX.StdCtrls, FMX.ExtCtrls, FMX.Types, FMX.Layouts, FMX.ListView.Types,
  FMX.ListView, FMX.ListBox, FMX.Memo,
   Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors, FMX.Objects, FMX.Edit, FMX.TabControl,

  System.UITypes, System.Types, System.SysUtils, System.Classes, System.Variants, Data.DB, System.Rtti,
  Data.Bind.EngExt, Data.Bind.Components,
  Data.Bind.Grid, Data.Bind.DBScope,
  MyAspFuncoesUteis,
  IniFiles, untCommonFormBase, FMX.ScrollBox,
  FMX.Controls.Presentation;

type
  TfrmSicsCommon_LCDBInput = class(TFrmBase)
    memoLCDBInput: TMemo;
    btnClear: TButton;
    procedure btnClearClick(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; Override;
  end;

var
  frmSicsCommon_LCDBInput: TfrmSicsCommon_LCDBInput;

implementation

{$R *.fmx}
{ %CLASSGROUP 'FMX.Controls.TControl' }

procedure TfrmSicsCommon_LCDBInput.btnClearClick(Sender: TObject);
begin
  inherited;
  memoLCDBInput.Lines.Clear;
end;

constructor TfrmSicsCommon_LCDBInput.Create(AOwner: TComponent);
begin
  inherited;
end;

destructor TfrmSicsCommon_LCDBInput.Destroy;
begin

  inherited;
end;

end.
