unit uCadastroDevices;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Stan.Async, FireDAC.DApt,
  Datasnap.DBClient, Datasnap.Provider, FireDAC.Comp.Client, Vcl.DBCtrls, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ComCtrls, FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Phys, FireDAC.Phys.FB, FireDAC.VCLUI.Wait, System.StrUtils, System.UITypes,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet, Vcl.Mask;

type
  TfrmCadastroDevices = class(TForm)
    pagCad: TPageControl;
    tsLista: TTabSheet;
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    Label1: TLabel;
    edtPesquisa: TEdit;
    cboPesquisa: TComboBox;
    Panel2: TPanel;
    btnIncluir: TButton;
    btnAlterar: TButton;
    btnSair: TButton;
    btnExcluir: TButton;
    tsManutencao: TTabSheet;
    Label2: TLabel;
    Label3: TLabel;
    dbedtID: TDBEdit;
    dbedtDevice: TDBEdit;
    Panel3: TPanel;
    btnGravar: TButton;
    btnCancelar: TButton;
    qryDevice: TFDQuery;
    dspDevice: TDataSetProvider;
    cdsDevice: TClientDataSet;
    dsDevice: TDataSource;
    qryDeviceID: TStringField;
    qryDeviceNOME: TStringField;
    qryDeviceSTATUS: TStringField;
    qryDeviceULTIMO_ACESSO: TSQLTimeStampField;
    cdsDeviceID: TStringField;
    cdsDeviceNOME: TStringField;
    cdsDeviceSTATUS: TStringField;
    cdsDeviceULTIMO_ACESSO: TSQLTimeStampField;
    cdsDeviceCalcStatus: TStringField;
    Label4: TLabel;
    dbedtUltimoAcesso: TDBEdit;
    rgrpStatus: TDBRadioGroup;
    Panel4: TPanel;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    LabeledEdit3: TLabeledEdit;
    pagUnidades: TPageControl;
    tsUnidades: TTabSheet;
    DBGrid2: TDBGrid;
    qryDeviceUnid: TFDQuery;
    cdsDeviceUnid: TClientDataSet;
    dsDeviceUnid: TDataSource;
    dsLinkDevice: TDataSource;
    cdsDeviceqryDeviceUnid: TDataSetField;
    cdsDeviceUnidID_DEVICE: TStringField;
    cdsDeviceUnidID_UNIDADE: TIntegerField;
    qryUnidade: TFDQuery;
    dspUnidade: TDataSetProvider;
    cdsUnidade: TClientDataSet;
    dsUnidade: TDataSource;
    qryUnidadeID: TIntegerField;
    qryUnidadeNOME: TStringField;
    cdsUnidadeID: TIntegerField;
    cdsUnidadeNOME: TStringField;
    cdsDeviceUnidLookUnidade: TStringField;
    Panel5: TPanel;
    btnIncUnidade: TButton;
    btnExcUnidade: TButton;
    cdsClone: TClientDataSet;
    dsClone: TDataSource;
    procedure cdsDeviceCalcFields(DataSet: TDataSet);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure pagCadChanging(Sender: TObject; var AllowChange: Boolean);
    procedure FormShow(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure LabeledEdit1Enter(Sender: TObject);
    procedure edtPesquisaChange(Sender: TObject);
    procedure cboPesquisaCloseUp(Sender: TObject);
    procedure cdsDeviceUnidAfterInsert(DataSet: TDataSet);
    procedure btnIncUnidadeClick(Sender: TObject);
    procedure btnExcUnidadeClick(Sender: TObject);
    procedure cdsDeviceUnidBeforeInsert(DataSet: TDataSet);
    procedure cdsDeviceUnidID_UNIDADEValidate(Sender: TField);
    procedure cdsDeviceSTATUSGetText(Sender: TField; var Text: string; DisplayText: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
    class function ExibeForm: Boolean;
  end;

implementation

{$R *.dfm}

uses untMainForm;

procedure TfrmCadastroDevices.btnAlterarClick(Sender: TObject);
begin
  if not cdsDevice.IsEmpty then
  begin
    cdsDevice.Edit;
    pagCad.ActivePage := tsManutencao;
  end;
end;

procedure TfrmCadastroDevices.btnCancelarClick(Sender: TObject);
begin
  if cdsDevice.State in dsEditModes then
  begin
    cdsDevice.Cancel;
  end;

  pagCad.ActivePage := tsLista;
end;

procedure TfrmCadastroDevices.btnExcluirClick(Sender: TObject);
begin
   begin
    if MessageDlg('Deseja excluir o registro?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      cdsDevice.Delete;
      cdsDevice.ApplyUpdates(0);
    end;
  end;
end;

procedure TfrmCadastroDevices.btnExcUnidadeClick(Sender: TObject);
begin
  if not cdsDeviceUnid.IsEmpty then
  begin
    if MessageDlg('Deseja excluir o registro?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      cdsDeviceUnid.Delete;
    end;
  end;
end;

procedure TfrmCadastroDevices.btnGravarClick(Sender: TObject);
begin
  if dbedtDevice.Field.AsString.Trim.IsEmpty then
  begin
    MessageDlg('Device não pode ser vazio!', mtInformation, [mbOK], 0);
    dbedtDevice.SetFocus;
    Exit;
  end;

  if MessageDlg('Deseja gravar o registro?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    if cdsDeviceUnid.State in dsEditModes then
    begin
      cdsDeviceUnid.Post;
    end;

    if cdsDevice.State in dsEditModes then
    begin
      cdsDevice.Post;
      cdsDevice.ApplyUpdates(0);
    end;

    pagCad.ActivePage := tsLista;
  end;
end;

procedure TfrmCadastroDevices.btnIncUnidadeClick(Sender: TObject);
begin
  cdsDeviceUnid.Append;
  DBGrid2.SetFocus;
end;

procedure TfrmCadastroDevices.btnSairClick(Sender: TObject);
begin
  Close;
  ModalResult := mrOk;
end;

procedure TfrmCadastroDevices.cboPesquisaCloseUp(Sender: TObject);
begin
  edtPesquisa.Clear;
  edtPesquisa.SetFocus;
end;

procedure TfrmCadastroDevices.cdsDeviceCalcFields(DataSet: TDataSet);
begin
  case AnsiIndexStr(cdsDeviceSTATUS.Text, ['A', 'P', 'I', 'O']) of
    0: cdsDeviceCalcStatus.AsString := 'Ativo';
    1: cdsDeviceCalcStatus.AsString := 'Pendente';
    2: cdsDeviceCalcStatus.AsString := 'Inativo';
    3: cdsDeviceCalcStatus.AsString := 'Ocioso';
  else cdsDeviceCalcStatus.AsString := cdsDeviceSTATUS.AsString;
  end;
end;

procedure TfrmCadastroDevices.cdsDeviceSTATUSGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  case AnsiIndexStr(cdsDeviceSTATUS.AsString, ['A', 'P', 'I', 'O']) of
    0: Text := IfThen(cdsDeviceULTIMO_ACESSO.AsDateTime > (Now - vgParametrosModuloConfig.DiasDeviceOcioso), 'A', 'O');
  else Text := cdsDeviceSTATUS.AsString;
  end;
end;

procedure TfrmCadastroDevices.cdsDeviceUnidAfterInsert(DataSet: TDataSet);
begin
  cdsDeviceUnidID_DEVICE.AsString := cdsDeviceID.AsString;
  cdsDeviceUnidID_UNIDADE.Clear;
end;

procedure TfrmCadastroDevices.cdsDeviceUnidBeforeInsert(DataSet: TDataSet);
begin
  cdsClone.Close;
  cdsClone.XMLData  := cdsDeviceUnid.XMLData;

  cdsClone.Filter   := 'ID_DEVICE=' + cdsDeviceID.AsString.QuotedString;
  cdsClone.Filtered := True;
end;

procedure TfrmCadastroDevices.cdsDeviceUnidID_UNIDADEValidate(Sender: TField);
begin
  if not Sender.AsString.IsEmpty then
  begin
    if cdsClone.Locate('ID_UNIDADE', Sender.AsString, []) then
    begin
      raise Exception.Create('Unidade já cadastrada para o device!');
    end;
  end;
end;

procedure TfrmCadastroDevices.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer;
  Column: TColumn; State: TGridDrawState);
begin
  if not (State = [gdSelected]) then
  begin
    case AnsiIndexStr(cdsDeviceSTATUS.Text, ['A', 'P', 'I', 'O']) of
      0: DBGrid1.Canvas.Brush.Color := clWindow;
      1: DBGrid1.Canvas.Brush.Color := clInfoBk;
      2: DBGrid1.Canvas.Brush.Color := $00B9B1FE;
      3: DBGrid1.Canvas.Brush.Color := clInactiveCaption;
    end;

    DBGrid1.Canvas.FillRect(Rect);
    DBGrid1.DefaultDrawColumnCell(Rect, DataCol, Column, State);
  end;
end;

procedure TfrmCadastroDevices.edtPesquisaChange(Sender: TObject);
var
  lCampo: String;
begin
  case cboPesquisa.ItemIndex of
    0: lCampo := 'ID';
    1: lCampo := 'NOME';
    2: lCampo := 'CalcStatus';
  end;

  cdsDevice.IndexFieldNames := lCampo;
  cdsDevice.Locate(lCampo, edtPesquisa.Text, [loPartialKey, loCaseInsensitive]);
end;

class function TfrmCadastroDevices.ExibeForm: Boolean;
var
  lFrm: TfrmCadastroDevices;
begin
  lFrm := TfrmCadastroDevices.Create(Application);

  try
    Result := lFrm.ShowModal = mrOk;
  finally
    lFrm.Free;
  end;
end;

procedure TfrmCadastroDevices.FormShow(Sender: TObject);
begin
  Screen.Cursor := crSQLWait;

  try
    cdsDevice.Close;
    cdsDevice.Open;

    cdsUnidade.Close;
    cdsUnidade.Open;

    pagCad.ActivePage := tsLista;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmCadastroDevices.LabeledEdit1Enter(Sender: TObject);
begin
  DBGrid1.SetFocus;
end;

procedure TfrmCadastroDevices.pagCadChanging(Sender: TObject; var AllowChange: Boolean);
begin
  if pagCad.ActivePage = tsManutencao then
  begin
    AllowChange := not(dsDevice.State in dsEditModes);
  end;
end;

end.

