unit ufrmDashboardConfig;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  untCommonFrameBase, Data.Bind.EngExt, Fmx.Bind.DBEngExt, System.ImageList,
  FMX.ImgList, Data.Bind.Components, FMX.Effects, FMX.Objects,
  FMX.Controls.Presentation, FMX.Layouts, FireDAC.Stan.Intf, Data.DB,
  System.Rtti, FMX.Grid, FMX.TabControl, Fmx.Bind.Grid, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.Grid, Data.Bind.DBScope, FMX.Edit, FMX.ListBox,
  FireDAC.Stan.StorageBin, Sics_Common_Parametros, Datasnap.DBClient,
  MyAspFuncoesUteis, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TfraDashboardConfig = class(TFrameBase)
    memIndicadores: TFDMemTable;
    memIndicadoresNomeIndicador: TStringField;
    memIndicadoresSelecionado: TBooleanField;
    memIndicadoresFlagValorEmSegundos: TBooleanField;
    memIndicadoresTipoGrafico: TByteField;
    lbIndicadores: TListBox;
    ListBoxItem1: TListBoxItem;
    lytRodape: TLayout;
    btnCancelar: TButton;
    btnOK: TButton;
    Image1: TImage;
    lbSelTipoGrafico: TListBox;
    recFundoSelTipoGrafico: TRectangle;
    lbiBarras: TListBoxItem;
    lbiPizza: TListBoxItem;
    imgGraficoTipoBarras: TImage;
    imgGraficoTipoPizza: TImage;
    laySelecionarTipoGrafico: TLayout;
    Layout1: TLayout;
    bCancelarSelTipoGrafico: TButton;
    bOkSelTipoGrafico: TButton;
    recFundoLaySelTipoGrafico: TRectangle;
    ShadowEffect1: TShadowEffect;
    Rectangle1: TRectangle;
    lblTituloSelTipoGrafico: TLabel;
    FDStanStorageBinLink1: TFDStanStorageBinLink;
    cdsPIsClone: TClientDataSet;
    memTemp: TFDMemTable;
    procedure ImgSelTipoGraficoClick(Sender: TObject);
    procedure bCancelarSelTipoGraficoClick(Sender: TObject);
    procedure recFundoSelTipoGraficoClick(Sender: TObject);
    procedure bOkSelTipoGraficoClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure lbIndicadoresItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
  private
    FImagemClicada: TImage;

    procedure ExibirSelecaoTipoGrafico(const ATImage: TImage);
    constructor Create(AOwner: TComponent); override;
    procedure OcultarSelecaoTipoGrafico;
    procedure PopularListBoxIndicadores;
    procedure SetImagemTipoGrafico(ATImage: TImage; ATipoGrafico: TTipoGrafico);
  public
    { Public declarations }
  end;

function fraDashboardConfig (const aIDUnidade: integer;
  const aAllowNewInstance: Boolean = False;
  const aOwner: TComponent = nil): TfraDashboardConfig;

implementation

{$R *.fmx}

uses untCommonDMUnidades, untCommonDMClient, FMX.Ani, untCommonDMConnection,
  ufrmDashboard, untMainForm, uPI, System.JSON;

function fraDashboardConfig (const aIDUnidade: integer;
  const aAllowNewInstance: Boolean = False;
  const aOwner: TComponent = nil): TfraDashboardConfig;
begin
  Result := TfraDashboardConfig(TfraDashboardConfig.GetInstancia(aIDUnidade, aAllowNewInstance, aOwner));
end;

procedure TfraDashboardConfig.bCancelarSelTipoGraficoClick(Sender: TObject);
begin
  inherited;

  OcultarSelecaoTipoGrafico;
end;

procedure TfraDashboardConfig.bOkSelTipoGraficoClick(Sender: TObject);
begin
  inherited;

  if Assigned(FImagemClicada) then
  begin
    if lbSelTipoGrafico.ItemIndex > -1 then
      SetImagemTipoGrafico(FImagemClicada, TTipoGrafico(lbSelTipoGrafico.ItemIndex))
    else
    begin
      ShowMessage('Nenhuma imagem selecionada!');
      abort;
    end;
  end;

  OcultarSelecaoTipoGrafico;
end;

procedure TfraDashboardConfig.btnCancelarClick(Sender: TObject);
begin
  inherited;

  Visible := False;
end;

procedure TfraDashboardConfig.btnOKClick(Sender: TObject);
var
  lbi: TListBoxItem;
//  img: TImage;
  LTipoGrafico: TTipoGrafico;
  i: Integer;
  LFrmDashboard: TfraDashboard;
begin
  inherited;

  memIndicadores.First;
  while not memIndicadores.Eof do
  begin
    lbi := lbIndicadores.ItemByIndex(memIndicadores.RecNo-1);
    if Assigned(lbi) then
    begin
      LTipoGrafico := tgBarras;
      for i := 0 to lbi.ChildrenCount-1 do
        if lbi.Children[i] is TImage then
          LTipoGrafico := TTipoGrafico((lbi.Children[i] as TImage).Tag);

      memIndicadores.Edit;
      memIndicadoresSelecionado.AsBoolean := lbi.IsChecked;
      memIndicadoresTipoGrafico.Value := Integer(LTipoGrafico);
      memIndicadores.Post;
    end;

    memIndicadores.Next;
  end;
  memIndicadores.SaveToFile(FDashboardConfigFileName);

  LFrmDashboard := FraDashboard(IDUnidade, not CRIAR_SE_NAO_EXISTIR);
  if Assigned(LFrmDashboard) then
    LFrmDashboard.RecarregarConfiguracoes;

  MessageDlg('Configurações salvas com sucesso!' + sLineBreak + sLineBreak +
             'Deseja abrir o Dashboard agora?', TMsgDlgType.mtConfirmation,
             [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0, procedure (const AResult: TModalResult)
             begin
               if AResult = mrYes then
                 MainForm.AbrirFrameDashboard;
             end);
end;

constructor TfraDashboardConfig.Create(AOwner: TComponent);
const
  AGUARDAR_RETORNO = True;
var
  LArr: TJSONArray;
  LObj: TJSONValue;
  LNome: String;
  LFlag: Boolean;
begin
  inherited;
  laySelecionarTipoGrafico.Visible := False;
  recFundoSelTipoGrafico.Visible := False;
  memIndicadores.Open;

  try
    LArr := TJSONArray(TPIManager.BuscarPIsPossiveis(vgParametrosModulo.CaminhoAPI, tiAPI));
    try
      for LObj in LArr do
      begin
        LObj.TryGetValue('pi', LNome);
        LObj.TryGetValue('flag_valor_em_segundos', LFlag);

        memIndicadores.Append;
        memIndicadoresNomeIndicador.AsString := LNome;
        memIndicadoresSelecionado.Value := False;
        memIndicadoresFlagValorEmSegundos.Value := LFlag;
        memIndicadoresTipoGrafico.Value := Integer(tgBarras);
        memIndicadores.Post;
      end;
    finally
      LArr.Free;
    end;
  except
    on E: Exception do
      MyLogException(E);
  end;

  //carrega o arquivo de configurações locais, se existir, e atualiza o memIndicadores
  if FileExists(FDashboardConfigFileName) then
  begin
    memTemp.LoadFromFile(FDashboardConfigFileName);
    while not memTemp.Eof do
    begin
      if memIndicadores.Locate('NomeIndicador', memTemp.FieldByName('NomeIndicador').AsString, [loCaseInsensitive]) then
      begin
        memIndicadores.Edit;
        memIndicadoresSelecionado.Value := memTemp.FieldByName('Selecionado').AsBoolean;
        memIndicadoresTipoGrafico.Value := memTemp.FieldByName('TipoGrafico').AsInteger;
        memIndicadores.Post;
      end;

      memTemp.Next;
    end;
    memTemp.Close;
  end;

  PopularListBoxIndicadores;
end;

procedure TfraDashboardConfig.PopularListBoxIndicadores;
var
  lbi: TListBoxItem;
  img: TImage;
begin
  lbIndicadores.BeginUpdate;
  try
    lbIndicadores.Clear;
    memIndicadores.First;
    while not memIndicadores.Eof do
    begin
      lbi := TListBoxItem.Create(lbIndicadores);
      lbi.Parent := lbIndicadores;
      lbi.Text := memIndicadoresNomeIndicador.AsString;
      lbi.StyledSettings := [TStyledSetting.Family, TStyledSetting.Style, TStyledSetting.FontColor, TStyledSetting.Other];
      lbi.Font.Size := 16;
      lbi.IsChecked := memIndicadoresSelecionado.AsBoolean;
      lbi.Tag := memIndicadores.RecNo;

      img := TImage.Create(lbi);
      img.Name := 'imgTipoGraficoIndicador' + memIndicadores.RecNo.ToString;
      img.Parent := lbi;
      img.Align := TAlignLayout.Right;
      img.Width := 50;
      img.Cursor := crHandPoint;
      img.WrapMode := TImageWrapMode.Fit;
      img.Padding := TBounds.Create(TRectF.Create(5, 5, 5, 5));
      img.Hint := memIndicadoresNomeIndicador.AsString;
      img.OnClick := ImgSelTipoGraficoClick;
      SetImagemTipoGrafico(img, TTipoGrafico(memIndicadoresTipoGrafico.Value));

      memIndicadores.Next;
    end;
  finally
    lbIndicadores.EndUpdate;
  end;
end;

procedure TfraDashboardConfig.SetImagemTipoGrafico(ATImage: TImage; ATipoGrafico: TTipoGrafico);
begin
  case ATipoGrafico of
    tgBarras: ATImage.Bitmap.Assign(imgGraficoTipoBarras.Bitmap);
    tgPizza: ATImage.Bitmap.Assign(imgGraficoTipoPizza.Bitmap);
  end;
  ATImage.Tag := Integer(ATipoGrafico);
end;

procedure TfraDashboardConfig.ExibirSelecaoTipoGrafico(const ATImage: TImage);
begin
  FImagemClicada := ATImage;
  lbSelTipoGrafico.ItemIndex := ATImage.Tag;
  lblTituloSelTipoGrafico.Text := 'Tipo de Gráfico (' + ATImage.Hint + ')';

  recFundoSelTipoGrafico.Align := TAlignLayout.Client;
  recFundoSelTipoGrafico.Fill.Color := TAlphaColorRec.Black;
  recFundoSelTipoGrafico.Opacity := 0;
  recFundoSelTipoGrafico.Visible := True;
  recFundoSelTipoGrafico.BringToFront;

  laySelecionarTipoGrafico.Opacity := 0;
  laySelecionarTipoGrafico.Visible := True;
  laySelecionarTipoGrafico.Align := TAlignLayout.Center;
  laySelecionarTipoGrafico.BringToFront;

  TAnimator.AnimateFloat(recFundoSelTipoGrafico, 'opacity', 0.5);
  TAnimator.AnimateFloatWait(laySelecionarTipoGrafico, 'opacity', 1, 0.3);
end;

procedure TfraDashboardConfig.OcultarSelecaoTipoGrafico;
begin
  FImagemClicada := nil;
  TAnimator.AnimateFloat(recFundoSelTipoGrafico, 'opacity', 0);
  TAnimator.AnimateFloatWait(laySelecionarTipoGrafico, 'opacity', 0);
  recFundoSelTipoGrafico.Visible := False;
  laySelecionarTipoGrafico.Visible := False;
end;

procedure TfraDashboardConfig.recFundoSelTipoGraficoClick(Sender: TObject);
begin
  inherited;
  bCancelarSelTipoGraficoClick(Sender);
end;

procedure TfraDashboardConfig.ImgSelTipoGraficoClick(Sender: TObject);
begin
  inherited;

  ExibirSelecaoTipoGrafico(Sender as TImage);
end;

procedure TfraDashboardConfig.lbIndicadoresItemClick(
  const Sender: TCustomListBox; const Item: TListBoxItem);
begin
  inherited;
  Item.IsChecked := not Item.IsChecked;
end;

end.
