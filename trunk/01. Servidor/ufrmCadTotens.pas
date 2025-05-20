unit ufrmCadTotens;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, DBCtrls, ExtCtrls, ComCtrls, Grids, DBGrids,
  DB, MyDlls_DR,  MyAspFuncoesUteis_VCL,ASPDbGrid, System.UITypes, System.Types,
  Vcl.Mask, uFrmBaseConfiguracoesSics, Vcl.Menus, System.IniFiles, uDataSetHelper;

type
  TfrmSicsCadTotens = class(TForm)
    btnIncluir: TBitBtn;
    btnExcluir: TBitBtn;
    btnOK: TBitBtn;
    btnCancelar: TBitBtn;
    gridTotens: TASPDbGrid;
    pcTotens: TPageControl;
    tbsModelo1: TTabSheet;
    tbsModelo2: TTabSheet;
    Panel1: TPanel;
    dblkpModelo1Fila1: TDBLookupComboBox;
    dblkpModelo1Fila2: TDBLookupComboBox;
    dblkpModelo1Fila3: TDBLookupComboBox;
    dblkpModelo1Fila4: TDBLookupComboBox;
    dblkpModelo1Fila5: TDBLookupComboBox;
    dblkpModelo1Fila6: TDBLookupComboBox;
    Panel2: TPanel;
    dblkpModelo2Fila1: TDBLookupComboBox;
    dblkpModelo2Fila2: TDBLookupComboBox;
    dblkpModelo2Fila3: TDBLookupComboBox;
    dblkpModelo2Fila4: TDBLookupComboBox;
    dblkpModelo2Fila5: TDBLookupComboBox;
    dblkpModelo2Fila6: TDBLookupComboBox;
    dblkpModelo2Fila7: TDBLookupComboBox;
    dblkpModelo2Fila8: TDBLookupComboBox;
    dtsTotens: TDataSource;
    dtsLkpFila: TDataSource;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    Shape5: TShape;
    Shape6: TShape;
    Shape7: TShape;
    Shape8: TShape;
    Shape9: TShape;
    Shape10: TShape;
    Shape11: TShape;
    Shape12: TShape;
    Shape13: TShape;
    Shape14: TShape;
    Label1: TDBText;
    Label2: TDBText;
    Shape15: TShape;
    tbsModelo3: TTabSheet;
    Panel3: TPanel;
    btnFilasPermitidas: TButton;
    edtFilasPermitidas: TDBEdit;
    lblFilasPermitidas: TLabel;
    OpenDialog: TOpenDialog;
    PgTotem: TPageControl;
    TabTotem: TTabSheet;
    TabSegundaTela: TTabSheet;
    grpTotemTouch: TGroupBox;
    lblTotemColunas: TLabel;
    lblTotemMargemSuperior: TLabel;
    lblTotemMargemEsquerda: TLabel;
    lblTotemMargemInferior: TLabel;
    lblTotemMargemDireita: TLabel;
    lblTotemEspacoColunas: TLabel;
    lblTotemEspacoLinhas: TLabel;
    lblTotemPortaTCP: TLabel;
    lblTotemPortaSerialImpressora: TLabel;
    lblTotemImagemFundo: TLabel;
    edtTotemColunas: TDBEdit;
    edtTotemMargemSuperior: TDBEdit;
    edtTotemMargemEsquerda: TDBEdit;
    edtTotemMargemInferior: TDBEdit;
    edtTotemMargemDireita: TDBEdit;
    edtTotemEspacoColunas: TDBEdit;
    edtTotemEspacoLinhas: TDBEdit;
    edtTotemPortaTCP: TDBEdit;
    edtTotemPortaSerialImpressora: TDBEdit;
    edtTotemImagemFundo: TDBEdit;
    BtnGravar: TBitBtn;
    DBImage1: TDBImage;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label12: TLabel;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    DBEdit7: TDBEdit;
    DBEdit10: TDBEdit;
    chkBotoesTransparentes: TDBCheckBox;
    dbchkPODE_FECHAR_PROGRAMA: TDBCheckBox;
    chkMostrarBotaoFechar: TDBCheckBox;
    chkMostrarBotaoFecharMaior: TDBCheckBox;
    DBCheckBox1: TDBCheckBox;
    BitBtn1: TBitBtn;
    DBImage2: TDBImage;
    tbsModelo4: TTabSheet;
    dtsTelas: TDataSource;
    dtsTelasBotoes: TDataSource;
    dtsTelasClone: TDataSource;
    tbsModelo5: TTabSheet;
    tbsModelo6: TTabSheet;
    Panel4: TPanel;
    Shape16: TShape;
    Shape17: TShape;
    Shape18: TShape;
    Shape19: TShape;
    Shape20: TShape;
    Shape21: TShape;
    DBText1: TDBText;
    dblkpModelo6Fila1: TDBLookupComboBox;
    dblkpModelo6Fila2: TDBLookupComboBox;
    dblkpModelo6Fila3: TDBLookupComboBox;
    dblkpModelo6Fila4: TDBLookupComboBox;
    dblkpModelo6Fila5: TDBLookupComboBox;
    dblkpModelo6Fila6: TDBLookupComboBox;
    dblkpModelo6Fila7: TDBLookupComboBox;
    Shape22: TShape;
    dblkpModelo6Fila8: TDBLookupComboBox;
    Shape23: TShape;
    Panel5: TPanel;
    popDeleteTelas: TPopupMenu;
    popDeleteBotoes: TPopupMenu;
    miExcluirTela: TMenuItem;
    miExcluirBotoes: TMenuItem;
    pnlDetalheDaTela: TPanel;
    imgImagemDeFundo: TDBImage;
    Splitter1: TSplitter;
    pnlBotoes: TPanel;
    Label14: TLabel;
    dbgridTelasBotoes: TDBGrid;
    popImagemDeFundo: TPopupMenu;
    menuAmpliar: TMenuItem;
    menuAlterar: TMenuItem;
    menuExcluir: TMenuItem;
    pnlInformacaoTela: TPanel;
    Label10: TLabel;
    dbeIntervaloInatividade: TDBEdit;
    Label11: TLabel;
    dblTelaInicial: TDBLookupComboBox;
    dbgridTelas: TDBGrid;
    Label13: TLabel;
    Splitter2: TSplitter;
    gbConfiguracaoImpressora: TGroupBox;
    Label16: TLabel;
    Label15: TLabel;
    DBEdit8: TDBEdit;
    DBEdit9: TDBEdit;
    pnlImagemDeFundo: TPanel;
    DBImage3: TDBImage;
    lblFechar: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnIncluirClick(Sender: TObject);
    procedure dtsTotensDataChange(Sender: TObject; Field: TField);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure Shape1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormResize(Sender: TObject);
    procedure gridTotensMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure edtFilasPermitidasKeyPress(Sender: TObject; var Key: Char);
    procedure btnFilasPermitidasClick(Sender: TObject);
    procedure BtnGravarClick(Sender: TObject);
    procedure Panel3MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure BitBtn1Click(Sender: TObject);
    procedure dbgridTelasExit(Sender: TObject);
    procedure dbgridTelasBotoesExit(Sender: TObject);
    procedure dbgridTelasBotoesKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure miExcluirTelaClick(Sender: TObject);
    procedure miExcluirBotoesClick(Sender: TObject);
    procedure pnlBotoesResize(Sender: TObject);
    procedure menuAmpliarClick(Sender: TObject);
    procedure menuAlterarClick(Sender: TObject);
    procedure menuExcluirClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lblFecharClick(Sender: TObject);
  private
    procedure MostrarModeloTotem;
    procedure MostrarCombosFilas;

    procedure DoDeleteScreen;
    procedure DoDeleteScreenButton;
  public
    class function ExibeForm: Boolean;
    var FIniFile: TIniFile;
  end;

implementation

uses
{$IFNDEF CompilarPara_CONFIG}
  sics_m,
{$ENDIF}
 udmCadTotens, Sics_91, Datasnap.DBClient, sics_94;

CONST FILTER_IMAGE = 'All image files (*.bmp,*.jpg,*.pcx)|*.BMP;*.JPG;*.PCX|' +
    'BMP files (*.bmp)|*.BMP|' + 'JPEG files (*.jpg)|*.JPG|' + 'PCX files (*.pcx)|*.PCX';


{$R *.dfm}

class function TfrmSicsCadTotens.ExibeForm;
begin
  with TfrmSicsCadTotens.Create(Application) do
  try
    Result := (ShowModal = mrOk);
  finally
    Release;
  end;
end;

procedure TfrmSicsCadTotens.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FIniFile := TIniFile.Create(GetAppIniFileName);
  try
    FIniFile.WriteInteger('LayoutTela' , 'cadTotemSplitVertical'  , imgImagemDeFundo.Width  );
    FIniFile.WriteInteger('LayoutTela' , 'cadTotemSplitHorizontal', pnlInformacaoTela.Height);
  finally
    FreeAndNil(FIniFile);
  end;
end;

procedure TfrmSicsCadTotens.FormCreate(Sender: TObject);
begin
  dmSicsCadTotens := TdmSicsCadTotens.Create(Self);
  LoadPosition (Sender as TForm);

  FIniFile := TIniFile.Create(GetAppIniFileName);
  try
    imgImagemDeFundo.Width   := FIniFile.ReadInteger('LayoutTela' , 'cadTotemSplitVertical'  , 100);
    pnlInformacaoTela.Height := FIniFile.ReadInteger('LayoutTela' , 'cadTotemSplitHorizontal', 200);
  finally
    FreeAndNil(FIniFile);
  end;
end;

procedure TfrmSicsCadTotens.btnOKClick(Sender: TObject);
begin
  with dmSicsCadTotens.cdsTotens do
  begin
    if State in dsEditModes then
      Post;

    if ApplyUpdates(0) <> 0 then
      CancelUpdates
{$IFNDEF CompilarPara_CONFIG}
    else
      frmSicsMain.LoadTotens;
{$ENDIF}
  end;


  if dmSicsCadTotens.cdsTelas.ApplyUpdates(0) <> 0 then
    dmSicsCadTotens.cdsTelas.CancelUpdates;

  if dmSicsCadTotens.cdsTelasBotoes.ApplyUpdates(0) <> 0 then
    dmSicsCadTotens.cdsTelasBotoes.CancelUpdates;
end;

procedure TfrmSicsCadTotens.btnIncluirClick(Sender: TObject);
begin
  if dmSicsCadTotens.cdsTotens.state in dsEditModes then
    dmSicsCadTotens.cdsTotens.Post;

  dmSicsCadTotens.cdsTotens.Append;
  //Valores Default atribuídos no evento NewRecord do DataSet
  //edtTotemPortaTCP.Text := '3001';
  //edtTotemPortaSerialImpressora.Text := 'com1,9600,8,n,1';
  gridTotens.SetFocus;
end;

procedure TfrmSicsCadTotens.MostrarModeloTotem;
var
  iModelo: Integer;
begin
  iModelo := dtsTotens.DataSet.FieldByName('ID_MODELOTOTEM').AsInteger;

  tbsModelo1.TabVisible := iModelo in [TOTEM_MODELO_BALCAO, TOTEM_MODELO_BALCAO_RAPIDO];

  tbsModelo2.TabVisible := iModelo in [TOTEM_MODELO_SILOUETE, TOTEM_MODELO_SILOUETE_BEMATECH, TOTEM_MODELO_SILOUETE_RAPIDO];

  tbsModelo3.TabVisible := iModelo in [TOTEM_MODELO_TOUCH_ZEBRA, TOTEM_MODELO_TOUCH_BALCAO_PAREDE, TOTEM_MODELO_IMPRESSORA_BEMATECH, TOTEM_MODELO_SILOUETE_TOUCH, TOTEM_MODELO_ELGIN, TOTEM_MODELO_SLIMTOUCH];

  tbsModelo4.TabVisible := iModelo in [TOTEM_MODELO_MULTITELAS, TOTEM_MODELO_TOUCH_BALCAO_PAREDE_MULTITELAS];

  tbsModelo5.TabVisible := iModelo in [TOTEM_MODELO_STANDALONE];

  tbsModelo6.TabVisible := iModelo in [TOTEM_MODELO_SLIMBUTTON];

  MostrarCombosFilas;
end;

procedure TfrmSicsCadTotens.Panel3MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  if not (dtsTotens.DataSet.State in dsEditModes) then
    dtsTotens.Edit;
end;

procedure TfrmSicsCadTotens.pnlBotoesResize(Sender: TObject);
const
  FIXEDCOLWIDTH = 10;
begin
  dbgridTelasBotoes.Columns[1].Width := dbgridTelasBotoes.Canvas.TextWidth(' 8888 ');
  dbgridTelasBotoes.Columns[2].Width := dbgridTelasBotoes.Columns[1].Width;
  dbgridTelasBotoes.Columns[3].Width := dbgridTelasBotoes.Columns[1].Width;
  dbgridTelasBotoes.Columns[4].Width := dbgridTelasBotoes.Columns[1].Width;
  dbgridTelasBotoes.Columns[0].Width := (dbgridTelasBotoes.ClientWidth - FIXEDCOLWIDTH -
                                         dbgridTelasBotoes.Columns[1].Width - dbgridTelasBotoes.Columns[2].Width -
                                         dbgridTelasBotoes.Columns[3].Width - dbgridTelasBotoes.Columns[4].Width - 10) div 4;
  dbgridTelasBotoes.Columns[5].Width := dbgridTelasBotoes.Columns[0].Width;
  dbgridTelasBotoes.Columns[6].Width := dbgridTelasBotoes.Columns[0].Width;
  dbgridTelasBotoes.Columns[7].Width := dbgridTelasBotoes.Columns[0].Width;
end;

procedure TfrmSicsCadTotens.dbgridTelasBotoesExit(Sender: TObject);
begin
  if dmSicsCadTotens.cdsTelasBotoes.ApplyUpdates(0) <> 0 then
    dmSicsCadTotens.cdsTelasBotoes.CancelUpdates;
end;

procedure TfrmSicsCadTotens.dbgridTelasBotoesKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_DELETE then
  begin
    if dbgridTelasBotoes.SelectedField.FieldKind = fkLookup then
    begin
      if not (dbgridTelasBotoes.DataSource.State in dsEditModes) then
      begin
        dbgridTelasBotoes.DataSource.Edit;
      end;

      if dbgridTelasBotoes.DataSource.DataSet.FindField(dbgridTelasBotoes.SelectedField.KeyFields) <> nil then
      begin
        dbgridTelasBotoes.DataSource.DataSet.FindField(dbgridTelasBotoes.SelectedField.KeyFields).Clear;
      end;
    end;
  end;
end;

procedure TfrmSicsCadTotens.dbgridTelasExit(Sender: TObject);
begin
  if dmSicsCadTotens.cdsTelas.ApplyUpdates(0) <> 0 then
    dmSicsCadTotens.cdsTelas.CancelUpdates;
end;


procedure TfrmSicsCadTotens.DoDeleteScreenButton;
begin
  if not dtsTelasBotoes.DataSet.IsEmpty then
  begin
    dtsTelasBotoes.DataSet.Delete;
  end;
end;

procedure TfrmSicsCadTotens.DoDeleteScreen;
begin
  if not dtsTelas.DataSet.IsEmpty then
  begin
    if not dtsTelasBotoes.DataSet.IsEmpty then
    begin
      ShowMessage('Exclua primeiramente todos os botões vinculados a esta Tela.');
      Exit;
    end;

    dtsTelas.DataSet.Delete;
  end;
end;

procedure TfrmSicsCadTotens.dtsTotensDataChange(Sender: TObject;
  Field: TField);
begin
  if (Field = nil) or (Field.FieldName = 'ID_MODELOTOTEM') then
    MostrarModeloTotem;

  if (Field = nil) or (Copy(Field.FieldName, 1, 12) = 'IDFILA_BOTAO') then
    MostrarCombosFilas;
end;

procedure TfrmSicsCadTotens.edtFilasPermitidasKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not(Key in ['0' .. '9', ';', '-', #8, #3, #$16]) then
    Key := #0;
end;

procedure TfrmSicsCadTotens.btnExcluirClick(Sender: TObject);
begin
  if MessageDlg('Confirma a exclusão do Totem?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    if dmSicsCadTotens.cdsTotens.state in dsEditModes then
      dmSicsCadTotens.cdsTotens.Cancel
    else
      dtsTotens.DataSet.Delete;
  end;
end;

procedure TfrmSicsCadTotens.btnFilasPermitidasClick(Sender: TObject);
begin
  edtFilasPermitidas.Text := CarregarGrupos(dmSicsMain.connOnLine, 'FILAS', edtFilasPermitidas.Text, lblFilasPermitidas.Caption);
end;

procedure TfrmSicsCadTotens.BtnGravarClick(Sender: TObject);
begin
  OpenDialog.Filter := FILTER_IMAGE;
  if OpenDialog.Execute then
  begin
    //Carregar imagem
    TBlobField(dtsTotens.DataSet.FieldByName('IMAGEM')).LoadFromFile(OpenDialog.FileName);
    dtsTotens.DataSet.FieldByName('IMAGEM_NOME').AsString := ExtractFileName(OpenDialog.FileName);
  end;
end;

procedure TfrmSicsCadTotens.BitBtn1Click(Sender: TObject);
begin
  OpenDialog.Filter := FILTER_IMAGE;
  if OpenDialog.Execute then
  begin
    //Carregar imagem
    TBlobField(dtsTotens.DataSet.FieldByName('ST_IMAGEM_FUNDO')).LoadFromFile(OpenDialog.FileName);
    dtsTotens.DataSet.FieldByName('ST_IMAGEM_FUNDO_NOME').AsString := ExtractFileName(OpenDialog.FileName);
  end;
end;

procedure TfrmSicsCadTotens.btnCancelarClick(Sender: TObject);
begin
  with dmSicsCadTotens.cdsTotens do
  begin
  	if State in dsEditModes then
    	Cancel;

    CancelUpdates;
  end;
	Close;
end;

procedure TfrmSicsCadTotens.Shape1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  with dtsTotens.DataSet do
  begin
    if not (State in dsEditModes) then Edit;
    with FieldByName('IDFILA_BOTAO' + IntToStr(TShape(Sender).Tag)) do
      if IsNull then
        AsInteger := 0
      else
      begin
        ConfirmationMessage('Confirma a exclusão desta fila?',
          procedure (const aOK: Boolean)
          begin
            if aOK then
              Clear;
          end);
      end;
  end;
end;

procedure TfrmSicsCadTotens.MostrarCombosFilas;
var
  iFila, iModelo: Integer;
  DbLkp: TDBLookupComboBox;
begin
  for iModelo := 1 to 2 do
    for iFila := 1 to 8 do
    begin
      DbLkp := TDBLookupComboBox(FindComponent('dblkpModelo' + IntToStr(iModelo) + 'Fila' + IntToStr(iFila)));
      if DbLkp <> nil then
        DbLkp.Visible := not dtsTotens.DataSet.FieldByName('IDFILA_BOTAO' + IntToStr(iFila)).IsNull;
    end;
end;

procedure TfrmSicsCadTotens.FormResize(Sender: TObject);
const
  OFF = 10;
  FIXEDCOLWIDTH = 10;
begin
  gridTotens.Left   := OFF;
  gridTotens.Top    := OFF;
  gridTotens.Width  := (ClientWidth - 3*OFF) * 40 div 100;
  gridTotens.Height := ClientHeight - btnIncluir.Height - 3*OFF;

  pcTotens.Left   := gridTotens.Left + gridTotens.Width + OFF;
  pcTotens.Top    := gridTotens.Top;
  pcTotens.Width  := ClientWidth - gridTotens.Width - 3*OFF;
  pcTotens.Height := gridTotens.Height;

  btnIncluir.Left := OFF;
  btnIncluir.Top  := gridTotens.Top + gridTotens.Height + OFF;

  btnExcluir.Left := btnIncluir.Left + btnIncluir.Width + OFF;
  btnExcluir.Top  := btnIncluir.Top;

  btnCancelar.Left := pcTotens.Left + pcTotens.Width - btnCancelar.Width;
  btnCancelar.Top  := btnIncluir.Top;

  btnOK.Left := btnCancelar.Left - btnOK.Width - OFF;
  btnOK.Top  := btnIncluir.Top;

  gridTotens.Columns[ 0].Width := Canvas.TextWidth(' 888 ');
  gridTotens.Columns[ 4].Width := Canvas.TextWidth(' OP1 ');
  gridTotens.Columns[ 5].Width := gridTotens.Columns[ 4].Width;
  gridTotens.Columns[ 6].Width := gridTotens.Columns[ 4].Width;
  gridTotens.Columns[ 7].Width := gridTotens.Columns[ 4].Width;
  gridTotens.Columns[ 8].Width := gridTotens.Columns[ 4].Width;
  gridTotens.Columns[ 1].Width := (gridTotens.ClientWidth - FIXEDCOLWIDTH - gridTotens.Columns[0].Width - gridTotens.Columns[4].Width - gridTotens.Columns[5].Width - gridTotens.Columns[6].Width - gridTotens.Columns[7].Width - gridTotens.Columns[8].Width - 11) div 3;
  gridTotens.Columns[ 2].Width := gridTotens.Columns[1].Width;
  gridTotens.Columns[ 3].Width := gridTotens.Columns[1].Width;

  dbgridTelas.Columns[1].Width := dbgridTelas.Canvas.TextWidth(' FECHAR ');
  dbgridTelas.Columns[3].Width := dbgridTelas.Canvas.TextWidth(' INTERVALO ');
  dbgridTelas.Columns[0].Width := (dbgridTelas.ClientWidth - FIXEDCOLWIDTH -
                                   dbgridTelas.Columns[1].Width - dbgridTelas.Columns[3].Width - 6) div 2;
  dbgridTelas.Columns[2].Width := dbgridTelas.Columns[0].Width;
end;

procedure TfrmSicsCadTotens.gridTotensMouseMove (Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  SelectedCell : TGridCoord;
begin
  try
    (Sender as TDBGrid).Hint := '';
    SelectedCell := (Sender as TDBGrid).MouseCoord(X, Y);

    case SelectedCell.X of
      5 : (Sender as TDBGrid).Hint := 'Corte parcial ao final do ticket';
      6 : (Sender as TDBGrid).Hint := 'Imprimir código de barras da senha (2a via)';
      7 : (Sender as TDBGrid).Hint := 'Picote entre as vias';
      8 : (Sender as TDBGrid).Hint := 'Imprimir data e hora na 2a via';
      9 : (Sender as TDBGrid).Hint := 'Imprimir nome da fila na 2a via';
      else begin
             (Sender as TDBGrid).Hint := '';
             Application.HideHint;
           end
    end;
    Application.ActivateHint(Point((Sender as TDBGrid).Left + X,(Sender as TDBGrid).Top + Y));
  except
    {do nothing}
  end;
end;

procedure TfrmSicsCadTotens.lblFecharClick(Sender: TObject);
begin
  pnlImagemDeFundo.Visible := False;
end;

procedure TfrmSicsCadTotens.menuAlterarClick(Sender: TObject);
begin
  if not (dbgridTelas.DataSource.DataSet.State in dsEditModes) then
    dbgridTelas.DataSource.DataSet.Edit;

  OpenDialog.Filter := FILTER_IMAGE;
  if OpenDialog.Execute then
  begin
    TBlobField(dtsTelas.DataSet.FieldByName('IMAGEM')).LoadFromFile(OpenDialog.FileName);
  end;
end;

procedure TfrmSicsCadTotens.menuAmpliarClick(Sender: TObject);
begin
  if not (dbgridTelas.DataSource.DataSet.State in dsEditModes) then
    dbgridTelas.DataSource.DataSet.Edit;
  pnlImagemDeFundo.Visible := True;
end;

procedure TfrmSicsCadTotens.menuExcluirClick(Sender: TObject);
begin
  if not (dbgridTelas.DataSource.DataSet.State in dsEditModes) then
    dbgridTelas.DataSource.DataSet.Edit;

  TBlobField(dtsTelas.DataSet.FieldByName('IMAGEM')).Clear;
end;

procedure TfrmSicsCadTotens.miExcluirBotoesClick(Sender: TObject);
begin
  DoDeleteScreenButton;
end;

procedure TfrmSicsCadTotens.miExcluirTelaClick(Sender: TObject);
begin
  DoDeleteScreen;
end;

end.
