unit uCadastroGrupos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.DBGrids, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.DBCtrls, System.UITypes, System.StrUtils, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.Client, FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys,
  FireDAC.Phys.FB, FireDAC.VCLUI.Wait, Datasnap.DBClient, Datasnap.Provider,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet, Vcl.Mask,
  Vcl.Grids;

type
  TfrmCadastroGrupos = class(TForm)
    pagCad: TPageControl;
    tsLista: TTabSheet;
    tsManutencao: TTabSheet;
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    Panel2: TPanel;
    btnIncluir: TButton;
    btnAlterar: TButton;
    btnSair: TButton;
    Label1: TLabel;
    edtPesquisa: TEdit;
    cboPesquisa: TComboBox;
    btnExcluir: TButton;
    dsGrupo: TDataSource;
    Label2: TLabel;
    dbedtID: TDBEdit;
    Label3: TLabel;
    dbedtGrupo: TDBEdit;
    Panel3: TPanel;
    btnGravar: TButton;
    btnCancelar: TButton;
    qryGrupo: TFDQuery;
    qryGrupoIDGRUPO: TIntegerField;
    qryGrupoNOME: TStringField;
    dspGrupo: TDataSetProvider;
    cdsGrupo: TClientDataSet;
    cdsGrupoIDGRUPO: TIntegerField;
    cdsGrupoNOME: TStringField;
    procedure btnSairClick(Sender: TObject);
    procedure btnIncluirClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure pagCadChanging(Sender: TObject; var AllowChange: Boolean);
    procedure edtPesquisaChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cdsGrupoBeforePost(DataSet: TDataSet);
    procedure cdsGrupoAfterInsert(DataSet: TDataSet);
    procedure cboPesquisaCloseUp(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class procedure ExibeForm;
  end;

implementation

{$R *.dfm}

uses untMainForm, ASPGenerator;

class procedure TfrmCadastroGrupos.ExibeForm;
var
  lFrm: TfrmCadastroGrupos;
begin
  lFrm := TfrmCadastroGrupos.Create(Application);

  try
    lFrm.ShowModal;
  finally
    lFrm.Free;
  end;
end;

procedure TfrmCadastroGrupos.btnAlterarClick(Sender: TObject);
begin
  if not cdsGrupo.IsEmpty then
  begin
    cdsGrupo.Edit;
    pagCad.ActivePage := tsManutencao;
  end;
end;

procedure TfrmCadastroGrupos.btnCancelarClick(Sender: TObject);
begin
  if cdsGrupo.State in dsEditModes then
  begin
    cdsGrupo.Cancel;
  end;

  pagCad.ActivePage := tsLista;
end;

procedure TfrmCadastroGrupos.btnExcluirClick(Sender: TObject);
begin
  if not cdsGrupo.IsEmpty then
  begin
    if MessageDlg('Deseja excluir o registro?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      cdsGrupo.Delete;
      cdsGrupo.ApplyUpdates(0);
    end;
  end;
end;

procedure TfrmCadastroGrupos.btnGravarClick(Sender: TObject);
begin
  if dbedtGrupo.Field.AsString.Trim.IsEmpty then
  begin
    MessageDlg('Grupo não pode ser vazio!', mtInformation, [mbOK], 0);
    dbedtGrupo.SetFocus;
    Exit;
  end;

  if MessageDlg('Deseja gravar o registro?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    if cdsGrupo.State in dsEditModes then
    begin
      cdsGrupo.Post;
      cdsGrupo.ApplyUpdates(0);
    end;

    pagCad.ActivePage := tsLista;
  end;
end;

procedure TfrmCadastroGrupos.btnIncluirClick(Sender: TObject);
begin
  cdsGrupo.Insert;
  pagCad.ActivePage := tsManutencao;
end;

procedure TfrmCadastroGrupos.btnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCadastroGrupos.cboPesquisaCloseUp(Sender: TObject);
begin
  edtPesquisa.Clear;
  edtPesquisa.SetFocus;
end;

procedure TfrmCadastroGrupos.cdsGrupoAfterInsert(DataSet: TDataSet);
begin
  cdsGrupoIDGRUPO.AsInteger := 0;
end;

procedure TfrmCadastroGrupos.cdsGrupoBeforePost(DataSet: TDataSet);
begin
  if cdsGrupo.State = dsInsert then
  begin
    cdsGrupoIDGRUPO.AsInteger := TGenerator.NGetNextGenerator('GEN_GRUPOS_ID', MainForm.connUnidades);
  end;
end;

procedure TfrmCadastroGrupos.edtPesquisaChange(Sender: TObject);
var
  lCampo: String;
begin
  lCampo := IfThen(cboPesquisa.ItemIndex = 0, 'IDGRUPO', 'NOME');
  cdsGrupo.IndexFieldNames := lCampo;
  cdsGrupo.Locate(lCampo, edtPesquisa.Text, [loPartialKey, loCaseInsensitive]);
end;

procedure TfrmCadastroGrupos.FormShow(Sender: TObject);
begin
  Screen.Cursor := crSQLWait;

  try
    cdsGrupo.Close;
    cdsGrupo.Open;

    pagCad.ActivePage := tsLista;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmCadastroGrupos.pagCadChanging(Sender: TObject; var AllowChange: Boolean);
begin
  if pagCad.ActivePage = tsManutencao then
  begin
    AllowChange := not(dsGrupo.State in dsEditModes);
  end;
end;

end.
