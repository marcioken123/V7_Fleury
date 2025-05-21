unit ufrmMonitorUnidades;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.Rtti,
  Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, Data.Bind.Components, Data.Bind.Grid, FMX.Layouts,
  FMX.Grid, Data.Bind.DBScope, FMX.Grid.Style, FMX.Controls.Presentation,
  FMX.ScrollBox;

type
  TfrmMonitorUnidades = class(TForm)
    BindSourceDB1: TBindSourceDB;
    GridBindSourceDB1: TGrid;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    BindingsList1: TBindingsList;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMonitorUnidades: TfrmMonitorUnidades;

implementation

{$R *.fmx}

uses untCommonDMUnidades;

procedure TfrmMonitorUnidades.FormCreate(Sender: TObject);
begin
  Top  := Screen.Height - Height - 100;
  Left := Screen.Width - Width - 100;
end;

end.
