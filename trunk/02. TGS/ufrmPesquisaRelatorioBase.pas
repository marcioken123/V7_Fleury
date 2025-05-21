unit ufrmPesquisaRelatorioBase;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  {$IFNDEF IS_MOBILE}
  Winapi.Windows,
  {$ENDIF IS_MOBILE}
  FMX.Grid, FMX.Controls, FMX.Forms, FMX.Graphics,
  FMX.Dialogs, FMX.StdCtrls, FMX.ExtCtrls, FMX.Types, FMX.Layouts, FMX.ListView.Types,
  FMX.ListView, FMX.ListBox, FMX.ImgList,
  Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.UIConsts,
  Fmx.Bind.Editors, FMX.Objects, FMX.Edit, FMX.TabControl, FMX.TreeView,

  FMX.MultiResBitmap,
  System.UITypes, System.Types, System.SysUtils, System.Classes, System.Variants, Data.DB,
  System.Rtti, Data.Bind.EngExt, Data.Bind.Components,

  untCommonFormBase, SqlTimSt, DateUtils, Data.Bind.Grid, Data.Bind.DBScope, System.Bindings.Outputs, Data.FMTBcd, FMX.Controls.Presentation, System.ImageList, Datasnap.DBClient, FMX.Effects,System.IniFiles,
  MyAspFuncoesUteis,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, 
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, 
  FireDAC.Phys, FireDAC.Comp.Client, FireDAC.DBX.Migrate, FireDAC.Stan.Param, 
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, uDataSetHelper;

type
  TTipoDeDuracao = (tdTodos, tdMenor, tdMaiorIgual, tdEntre);
  TfrmPesquisaRelatorioBase = class(TFrmBase)
    imgsTags: TImageList;
    TagsPanel: TPanel;
    TagsLabel: TLabel;
    TagsTreeView: TTreeView;
  	cdsUnidades: TClientDataSet;
    rect5: TRectangle;
    pnlUnidades: TRectangle;
    Rectangle8: TRectangle;
    Label18: TLabel;
    lbUnidades: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    procedure ToggleTreeViewCheckBoxes(Node : TTreeViewItem); virtual;
    procedure FormShow(Sender: TObject);
    procedure lbUnidadesChange(Sender: TObject);
    procedure lbUnidadesChangeCheck(Sender: TObject);
  protected
    vlChanged : boolean;
    FAtualizarTreeViewsDataSetScroll: Boolean;
    FLimpandoTreeView,FAlterandoNodePaiAutomaticamente: Boolean;
    FPermiteInserirUnidades: Boolean;
    FUltimoPerfilSLA: Variant;

    procedure Carregar(aForm : FMX.Forms.TForm;DataSet: TDataSet; TreeView: TTreeView;tabela : string); Virtual;
    procedure CarregaUnidades; virtual;
    procedure CarregarTreeViews; virtual; abstract;
    procedure PosicionaUnidadeCorrente; virtual;
    function CheckUnidadesSelecionadas: Boolean; virtual; abstract;
    procedure GetQueryParams; virtual; abstract;
    procedure GetRepVars; virtual; abstract;
    procedure ExibirGraficoSLA; virtual; abstract;
    procedure InsertInTreeView(aForm : FMX.Forms.TForm;const TreeView: TTreeView; const Id: Integer; Nome, GrupoNome,tabela: string;
      const CodigoCor: TAlphaColor;const ASelected: Boolean = False); virtual;
    procedure EditarClientDataSet(const tabela: string; const Id: Integer; const Selecionado: Boolean); virtual; abstract;
    procedure OnClickNodeGrupo(Sender: TObject);
    procedure SetIDUnidade(const Value: Integer); Override;
    procedure VerificaNodeGrupo(TreeView : TTreeView);
    procedure SalvaSituacaoTreeView(aForm: FMX.Forms.TForm;TreeView : TTreeView);
  public
    ArrConexoes: array of TFDConnection;

    function ValidacaoAtivaModoConectado: Boolean; Override;
    procedure MontarWhere(QryEventos: TFDQuery; var SqlInTags: string; IgnoreDuracao: Boolean); virtual; abstract;
    constructor Create(aOwner: TComponent); override;
  end;

  implementation

  {$R *.fmx}

uses Sics_Common_Parametros, untMainForm, untCommonDMUnidades;


{ TfrmPesquisaRelatorioBase }

procedure TfrmPesquisaRelatorioBase.Carregar(aForm : FMX.Forms.TForm;DataSet: TDataSet;
  TreeView: TTreeView;tabela : string);
var
  iCodigoCor: Integer;
begin
 FLimpandoTreeView := True;
 try
   TreeView.Clear;
   imgsTags.Source.Clear;

   with DataSet do
   begin
     First;
       while not eof do
     begin
         if FindField('CODIGOCOR') <> nil then
           iCodigoCor := FieldByName('CODIGOCOR').AsInteger
         else
           iCodigoCor := 0;

         InsertInTreeView(
           aForm,
           TreeView,
           FieldByName('ID'               ).AsInteger,
           FieldByName('NOME'             ).AsString,
           FieldByName('GRUPO_NOME').AsString,
           tabela,
           iCodigoCor,
           FieldByName('SELECIONADO').AsBoolean);

       Next;
     end; { while not eof }
   end;  // with cds

  VerificaNodeGrupo(TreeView);
 finally
    FLimpandoTreeView := False;
 end;
end;

procedure TfrmPesquisaRelatorioBase.CarregaUnidades;
var
  lbi: TListBoxItem;
begin
  pnlUnidades.Visible := dmUnidades.Quantidade > 1;

  if pnlUnidades.Visible then
  begin
    lbUnidades.BeginUpdate;
    try
      lbUnidades.Clear;
      cdsUnidades.First;
      while not cdsUnidades.Eof do
      begin
        lbi := TListBoxItem.Create(lbUnidades);
        lbi.Parent := lbUnidades;
        lbi.Tag := cdsUnidades.FieldByName('ID').AsInteger;
        lbi.Text := cdsUnidades.FieldByName('NOME').AsString;
        lbi.IsChecked := cdsUnidades.FieldByName('SELECIONADO').AsBoolean;
        if not cdsUnidades.FieldByName('CONECTADA').AsBoolean then
        begin
          lbi.StyledSettings := lbi.StyledSettings - [TStyledSetting.FontColor];
          lbi.FontColor      := TAlphaColorRec.Red;
        end;

        cdsUnidades.Next;
      end;
    finally
      lbUnidades.EndUpdate;
    end;
    PosicionaUnidadeCorrente;
    lbUnidades.ItemIndex := cdsUnidades.RecNo-1;
  end;
end;

constructor TfrmPesquisaRelatorioBase.Create(aOwner: TComponent);
begin
  inherited;
  if (Assigned(AOwner) and (AOwner is TMainForm)) then
  begin
    Self.Width := Trunc(TMainForm(AOwner).layCenter.Width);
    Self.Height := Trunc(TMainForm(AOwner).layCenter.Height);
  end;
end;

procedure TfrmPesquisaRelatorioBase.FormShow(Sender: TObject);
begin
  inherited;
  CarregaUnidades;
end;

procedure TfrmPesquisaRelatorioBase.InsertInTreeView(aForm : FMX.Forms.TForm;const TreeView: TTreeView;
  const Id: Integer; Nome, GrupoNome,tabela: string; const CodigoCor: TAlphaColor;
  const ASelected: Boolean);
const
  IMG_WIDTH = 16;
  IMG_HEIGHT = 16;
var
  i: Integer;
  NodeGrupo, NodeFilho: TTreeViewItem;
  Bmp: TBitmapOfItem;

  function VerificarExpand : boolean;
  var
    iniFile : TIniFile;
  begin
//    Result := true;
    IniFile := TIniFile.Create(SettingsPathName + 'PosicaoTela'+ApplicationName('.ini'));

    try
     Result:= iniFile.ReadBool(aForm.Name,TreeView.Name+inttostr(NodeGrupo.Index),true);
    finally
     FreeAndNil(iniFile);
    end;

  end;
begin
  NodeGrupo := nil;
  if GrupoNome = '' then
    GrupoNome := 'Sem Grupo';

  for i := 0 to TreeView.Count -1 do
  begin
    if TreeView.Items[i].Text = GrupoNome then
    begin
      NodeGrupo := TreeView.Items[i];
      Break;
    end;
  end;

  if NodeGrupo = nil then
  begin

    NodeGrupo := TTreeViewItem.Create(TreeView);
    NodeGrupo.Text := GrupoNome;
    NodeGrupo.ImageIndex    := -1;
    TreeView.AddObject(NodeGrupo);
    TreeView.Selected := nil;
  end;


  if TreeView = TagsTreeView then
  begin
    Bmp := TBitmapOfItem.Create;
    try
      Bmp.Width  := IMG_WIDTH;
      Bmp.Height := IMG_HEIGHT;
      Bmp.Canvas.Fill.Color := CodigoCor;
      imgsTags.Source.Add.MultiResBitmap.Add.Bitmap := Bmp;
    finally
      FreeAndNil(Bmp);
    end;
  end;

  NodeFilho := TTreeViewItem.Create(TreeView);
  NodeFilho.IsChecked   := True;
  NodeFilho.Tag := Id;
  NodeFilho.Text        := Nome;
  NodeFilho.TagString := tabela;
  NodeGrupo.AddObject(NodeFilho);

  // tem que fazer INVERTIDO, pois o metodo ToggleTreeViewCheckBoxes
  // que eh chamado mais abaixo INVERTE a situacao atual
  if not ASelected then
    NodeFilho.IsChecked := True
  else
    NodeFilho.IsChecked := False;
  ToggleTreeViewCheckBoxes(NodeFilho);

  if TreeView = TagsTreeView then
  begin
    NodeFilho.ImageIndex    := imgsTags.Count -1;
  end;
  NodeGrupo.IsChecked := True;
  if(VerificarExpand)then
    NodeGrupo.ExpandAll
  else
    NodeGrupo.CollapseAll;

  TreeView.OnChangeCheck := OnClickNodeGrupo;
end;

procedure TfrmPesquisaRelatorioBase.lbUnidadesChange(Sender: TObject);
begin
  inherited;

  if not FAtualizarTreeViewsDataSetScroll then
    exit;

  cdsUnidades.RecNo := lbUnidades.ItemIndex+1;
  CarregarTreeViews;
  if lbUnidades.Visible then
    lbUnidades.SetFocus;
end;

procedure TfrmPesquisaRelatorioBase.lbUnidadesChangeCheck(Sender: TObject);
begin
  inherited;

  cdsUnidades.Edit;
  cdsUnidades.FieldByName('SELECIONADO').AsBoolean :=
    lbUnidades.ItemByIndex(lbUnidades.ItemIndex).IsChecked;
  cdsUnidades.Post;
end;

procedure TfrmPesquisaRelatorioBase.OnClickNodeGrupo(Sender: TObject);
  function VerificaNosFilhos(nodeGrupo :TTreeViewItem; checked : boolean) :Boolean;
    var
      i,qtde: Integer;
      NodeFilho: TTreeViewItem;
  begin
    Result := True;
    qtde := 0;
    for i := 0 to nodeGrupo.Count -1 do
    begin
       NodeFilho := nodeGrupo.ItemByIndex(i);

      if (Assigned(NodeFilho)  and (NodeFilho.IsChecked = checked) )then
      begin
          Inc(qtde);
          Result := False;
      end;

      if(qtde = nodeGrupo.Count)then
      begin
        Result := True;
      end;

    end;
  end;
var
  NodeGrupo, NodeFilho: TTreeViewItem;
  i{,tag}: Integer;
//  dataset : TDataSet;
begin
  if not Assigned(Sender) then
    Exit;

  NodeGrupo := (Sender as TTreeViewItem);
  if(NodeGrupo.Count > 0)then
  begin
    if (not FLimpandoTreeView) and (not FAlterandoNodePaiAutomaticamente) then

    for i := 0 to NodeGrupo.Count -1 do
    begin
      NodeFilho := NodeGrupo.ItemByIndex(i);
      if Assigned(NodeFilho) then
        NodeFilho.IsChecked := NodeGrupo.IsChecked;
    end;
  end;

  EditarClientDataSet(NodeGrupo.TagString,NodeGrupo.Tag,NodeGrupo.IsChecked);
  if(NodeGrupo.ParentItem is TTreeViewItem)then
  begin
    if not (NodeGrupo.IsChecked)then
    begin
      FAlterandoNodePaiAutomaticamente := True;
      NodeGrupo.ParentItem.IsChecked := False;
      FAlterandoNodePaiAutomaticamente := False;
    end;
  end;
end;

procedure TfrmPesquisaRelatorioBase.PosicionaUnidadeCorrente;
begin
  if cdsUnidades.Active then
    cdsUnidades.Locate('ID', IDUnidade, []);
end;

procedure TfrmPesquisaRelatorioBase.SalvaSituacaoTreeView(
  aForm: FMX.Forms.TForm;TreeView: TTreeView);
  var
    I : integer;
    IniFile : TIniFile;
begin
   IniFile := TIniFile.Create(SettingsPathName + 'PosicaoTela'+ApplicationName('.ini'));
   try
    for I := 0 to TreeView.Count -1 do
    begin
     with IniFile do
     begin
       WriteBool(aForm.Name,TreeView.Name+inttostr(I),TreeView.Items[I].IsExpanded);
     end;
    end;
   finally
    FreeAndNil(IniFile);
   end;
end;

procedure TfrmPesquisaRelatorioBase.SetIDUnidade(const Value: Integer);
begin
  inherited;
  PosicionaUnidadeCorrente;
end;

procedure TfrmPesquisaRelatorioBase.ToggleTreeViewCheckBoxes(Node: TTreeViewItem);
var
//  Pai,
  Filho{,
  Irmao} : TTreeViewItem;
  {StatusIrmaos, PrimeiroFilho, }CheckType: Boolean;
  i: Integer;
begin
//  Pai   := Node.ParentItem;

  CheckType := not Node.IsChecked;
   Node.IsChecked := CheckType;
  if (Node.Tag > 0) then
    EditarClientDataSet(Node.TagString, Node.Tag, CheckType);
  for i := 0 to Node.Count - 1 do
  begin
    Filho := Node.Items[i];
    if (Filho.Tag > 0) then
      EditarClientDataSet(Node.TagString, Filho.Tag, CheckType);
    Filho.IsChecked := CheckType;
  end;
end;

function TfrmPesquisaRelatorioBase.ValidacaoAtivaModoConectado: Boolean;
begin
  Result := cNaoPossuiConexaoDiretoDB;
end;

procedure TfrmPesquisaRelatorioBase.VerificaNodeGrupo(TreeView: TTreeView);
  var
    i,j :Integer;
    Node,NodePai: TTreeViewItem;
begin
  for I := 0 to TreeView.Count -1 do
  begin
    NodePai := TreeView.ItemByIndex(i);
    for j := 0 to NodePai.Count -1 do
    begin
      Node :=   NodePai.ItemByIndex(j);
      if(not Node.IsChecked)then
      begin
        FAlterandoNodePaiAutomaticamente := True;
        NodePai.IsChecked := False;
        FAlterandoNodePaiAutomaticamente := False;
      end;
    end;
  end;
end;

end.
