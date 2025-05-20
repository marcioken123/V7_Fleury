unit Sics_LBC_Debug_ShowDataSet;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  untCommonDmClient, System.Rtti, FMX.StdCtrls, FMX.ListBox, FMX.Edit,
  FMX.Controls.Presentation, Data.DB, Datasnap.DBClient, FMX.Layouts,
  FMX.Grid, Data.Bind.EngExt, Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope ;

type
  TfrmShowDataSet = class(TForm)
    Label1: TLabel;
    edUnidade: TEdit;
    cboDataSet: TComboBox;
    Button1: TButton;
    Grid1: TGrid;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    bds: TBindSourceDB;
    bdl: TBindingsList;
    gtd: TLinkGridToDataSource;
  public
    { Public declarations }
  end;

var
  frmShowDataSet: TfrmShowDataSet;

implementation

{$R *.fmx}

procedure TfrmShowDataSet.Button1Click(Sender: TObject);
var
  MyDmClient : TDMClient;
  cds        : TClientDataSet;
begin
  MyDmClient := DMClient(strtoint(edUnidade.Text));
  case cboDataSet.ItemIndex of
    0 : cds := MyDmClient.cdsPAs;
    1 : cds := MyDmClient.cdsAtendentes;
  end;

  bds.DataSet := cds;
end;

procedure TfrmShowDataSet.FormCreate(Sender: TObject);
begin
  bds := TBindSourceDB.Create(Self);
  bdl := TBindingsList.Create(Self);
  gtd := TLinkGridToDataSource.Create(bdl);

  gtd.DataSource := bds;
  gtd.GridControl := Grid1;
end;

end.
