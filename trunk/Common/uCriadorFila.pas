unit uCriadorFila;

interface

uses System.UITypes, FMX.Objects, FMX.Layouts, Data.DB, FMX.Controls,
  FMX.StdCtrls, System.SysUtils, FMX.Types, FMX.Graphics, System.UIConsts,
  FMX.ListBox, System.Types, System.JSON, System.Classes;

type
  TLayoutFila           = (lfGrid, lfCartoes);
  TLayoutFila_CorLimiar = (lcClean, lcColorido);

  TGeradorFila = class
  private
    FParent: TControl;
    FDataset: TDataSet;
    FCampoNome: TField;
    FCampoSenha: TField;
    FCampoProntuario: TField;
    FCampoHora: TField;
    FCampoCor: TField;
    FCamposTags: array of TField;
    FOnSenhaMouseUp: TMouseEvent;
    FOnListBoxItemDblClick: TNotifyEvent;
    procedure CriarFilaComCorDeFundo;
    procedure CriarFilaClean;
    procedure CriarFilaGrid;

    procedure ListBoxFilaLayoutGridOnCalcContentBounds(Sender: TObject;
      var ContentBounds: TRectF);
  public
    class var FTamanhoFonte: Integer;
    class var FEstiloLayout: Integer;
    class procedure Execute(const ALayout: TLayoutFila; const AParent: TControl;
      const ADataset: TDataset; const AFieldNome, AFieldSenha, AFieldHora,
      AFieldCor, AFieldProntuario: string; const AFieldsDescTags: Array of String;
      const AOnSenhaMouseUpEvent: TMouseEvent; AOnListBoxItemDblClick: TNotifyEvent);
  end;

implementation

uses
  uConstsCriacaoFilas,
  Sics_Common_Parametros,
  System.StrUtils,
  untCommonFormDadosAdicionais,
  untCommonDMConnection,
  System.Math,
  FMX.Dialogs;

procedure SeparaStrings(const aValue, aSeparador: string; var Antes, Depois: string);
var
  LIndexValue: SmallInt;
begin
  LIndexValue := Pos(aSeparador, aValue);
  if LIndexValue <= 0 then
  begin
    Antes  := aValue;
    Depois := '';
  end
  else
  begin
    Antes  := Copy(aValue, 1, LIndexValue - 1);
    Depois := Copy(aValue, LIndexValue + Length(aSeparador), Length(aValue) -
      LIndexValue - Length(aSeparador) + 1);
  end;
end;

{ TGeradorFila }

procedure TGeradorFila.CriarFilaClean;
begin
  raise Exception.Create('Layout ainda não implementado!');
end;

procedure TGeradorFila.CriarFilaComCorDeFundo;
const
  MARGIN = 5;
var
  rec, recTag, recFundo: TRectangle;
  cor, corTexto: TAlphaColor;
  lbl: TLabel;
  i, c, x: Integer;
  lay, layTags: TLayout;
  valorTag, TagColor, TagID, TagNome: String;
  RGB: Integer;
begin
  //FDataset.Last;
  FDataset.First;
  //while not FDataset.Bof do
  while not FDataset.Eof do
  begin
    {$REGION 'Retângulo base'}
    rec := TRectangle.Create(FParent);
    rec.Parent := FParent;
    rec.Align := TAlignLayout.Top;
    rec.Margins.Top    := MARGIN;
    rec.Margins.Left   := MARGIN;
    rec.Margins.Bottom := MARGIN;
    rec.Margins.Right  := MARGIN;

    if vgParametrosModulo.VisualizarNomeClientes then
    begin
      case FTamanhoFonte of
        TAMANHO_FONTE_EX_GRANDE : rec.Height := 106;
        TAMANHO_FONTE_GRANDE    : rec.Height := 70;
        TAMANHO_FONTE_MEDIA     : rec.Height := 50;
        TAMANHO_FONTE_NORMAL    : rec.Height := 35;
      end;
    end
    else
    begin
      case FTamanhoFonte of
        TAMANHO_FONTE_EX_GRANDE : rec.Height := 55;
        TAMANHO_FONTE_GRANDE    : rec.Height := 35;
        TAMANHO_FONTE_MEDIA     : rec.Height := 31;
        TAMANHO_FONTE_NORMAL    : rec.Height := 27;
      end;
    end;

    rec.Stroke.Color := TAlphaColorRec.Gray; //linha cinza
    rec.ClipChildren := True;
    rec.Tag          := FDataset.Tag; //id da fila
    rec.TagFloat     := FCampoSenha.AsInteger;
    rec.TagString    := FCampoNome.AsString;
    rec.OnMouseUp    := FOnSenhaMouseUp;

    cor := StrToIntDef(FCampoCor.AsString, TAlphaColorRec.White);
    rec.Fill.Color := Cor;
    if cor = TAlphaColorRec.Red then
      corTexto := TAlphaColorRec.White
    else
      corTexto := TAlphaColorRec.Black;
    {$ENDREGION}

    {$REGION '//label do nome'}
    if vgParametrosModulo.VisualizarNomeClientes then
    begin
      lbl := TLabel.Create(rec);
      lbl.Parent := rec;
      lbl.Align := TAlignLayout.Client;
      lbl.TextSettings.Font.Size := FTamanhoFonte;
      lbl.TextSettings.FontColor := corTexto;
      lbl.TextSettings.WordWrap  := False;
      lbl.TextSettings.Trimming  := TTextTrimming.Character;
      lbl.StyledSettings := lbl.StyledSettings - [TStyledSetting.Size, TStyledSetting.FontColor];
      lbl.Margins.Right  := 2;
      lbl.Margins.Top    := 0;
      lbl.Margins.Left   := 2;
      lbl.Margins.Bottom := 2;

      case FTamanhoFonte of
        TAMANHO_FONTE_EX_GRANDE : lbl.Height := 36;
        TAMANHO_FONTE_GRANDE    : lbl.Height := 26;
        TAMANHO_FONTE_MEDIA     : lbl.Height := 20;
        TAMANHO_FONTE_NORMAL    : lbl.Height := 16;
      end;

      lbl.Text := FCampoNome.AsString;
    end;
    {$ENDREGION}

    {$REGION '//layout para Senha, Tags e Tempo'}
    lay := TLayout.Create(rec);
    lay.Parent := rec;
    lay.Align := TAlignLayout.Bottom;

    if vgParametrosModulo.VisualizarNomeClientes then
    begin
      case FTamanhoFonte of
        TAMANHO_FONTE_EX_GRANDE : begin
                                    lay.Height := 54;
                                    lay.Margins.Bottom := 10;
                                  end;
        TAMANHO_FONTE_GRANDE    : begin
                                    lay.Height := 34;
                                    lay.Margins.Bottom := 2;
                                  end;
        TAMANHO_FONTE_MEDIA     : begin
                                    lay.Height := 30;
                                    lay.Margins.Bottom := 4;
                                  end;
        TAMANHO_FONTE_NORMAL    : begin
                                    lay.Height := 19;
                                    lay.Margins.Bottom := 4;
                                  end;
      end;

      lay.Margins.Bottom := 2
    end
    else
    begin
      case FTamanhoFonte of
        TAMANHO_FONTE_EX_GRANDE : begin
                                    lay.Height := 54;
                                    lay.Margins.Bottom := 5;
                                  end;
        TAMANHO_FONTE_GRANDE    : begin
                                    lay.Height := 38;
                                    lay.Margins.Bottom := 2;
                                  end;
        TAMANHO_FONTE_MEDIA     : begin
                                    lay.Height := 30;
                                    lay.Margins.Bottom := 4;
                                  end;
        TAMANHO_FONTE_NORMAL    : begin
                                    lay.Height := 14;
                                    lay.Margins.Bottom := 4;
                                  end;
      end;
    end;

    lay.Margins.Left   := 2;
    lay.Margins.Right  := 2;

    {$REGION '//Label da senha'}
    lbl := TLabel.Create(lay);
    lbl.Parent := lay;
    lbl.Align := TAlignLayout.Left;
    lbl.TextSettings.Font.Size := FTamanhoFonte;
    lbl.TextSettings.FontColor := corTexto;
    lbl.TextSettings.WordWrap  := False;
    lbl.TextSettings.Trimming  := TTextTrimming.Character;
    lbl.StyledSettings := lbl.StyledSettings - [TStyledSetting.Size, TStyledSetting.FontColor];

    if FTamanhoFonte = TAMANHO_FONTE_EX_GRANDE then
      lbl.Width := 350
    else
    if FTamanhoFonte = TAMANHO_FONTE_GRANDE then
      lbl.Width := 160
    else
    if FTamanhoFonte = TAMANHO_FONTE_MEDIA then
      lbl.Width := 130
    else
    if FTamanhoFonte = TAMANHO_FONTE_NORMAL then
      lbl.Width := 120;

    if vgParametrosModulo.ModoCallCenter then
      lbl.Text := 'Mesa ' + FCampoSenha.AsString
    else
      lbl.Text := 'Senha ' + FCampoSenha.AsString;

    {$ENDREGION}

    {$REGION '//Label do prontuário'}
    lbl := TLabel.Create(lay);
    lbl.Parent := lay;
    lbl.Align := TAlignLayout.Left;
    lbl.Margins.Left := 5;
    lbl.TextSettings.Font.Size := FTamanhoFonte;
    lbl.TextSettings.FontColor := corTexto;
    lbl.TextSettings.WordWrap  := False;
    lbl.TextSettings.Trimming  := TTextTrimming.None;
    lbl.StyledSettings := lbl.StyledSettings - [TStyledSetting.Size, TStyledSetting.FontColor];

    if FTamanhoFonte = TAMANHO_FONTE_EX_GRANDE then
      lbl.Width := 220
    else
    if FTamanhoFonte = TAMANHO_FONTE_GRANDE then
      lbl.Width := 150
    else
    if FTamanhoFonte = TAMANHO_FONTE_MEDIA then
      lbl.Width := 130
    else
      lbl.Width := 120;

    lbl.Text := '7777777777';
    {$ENDREGION}

    {$REGION '//Label do tempo'}
    lbl := TLabel.Create(lay);
    lbl.Parent := lay;
    lbl.Align := TAlignLayout.Left;
    lbl.Margins.Left := 5;
    lbl.TextSettings.Font.Size := FTamanhoFonte;
    lbl.TextSettings.FontColor := corTexto;
    lbl.TextSettings.WordWrap  := False;
    lbl.TextSettings.Trimming  := TTextTrimming.None;
    lbl.StyledSettings := lbl.StyledSettings - [TStyledSetting.Size, TStyledSetting.FontColor];

    if FTamanhoFonte = TAMANHO_FONTE_EX_GRANDE then
      lbl.Width := 220
    else
    if FTamanhoFonte = TAMANHO_FONTE_GRANDE then
      lbl.Width := 150
    else
    if FTamanhoFonte = TAMANHO_FONTE_MEDIA then
      lbl.Width := 130
    else
      lbl.Width := 120;

    lbl.Text := FCampoHora.AsString;
    {$ENDREGION}

      {$REGION '//Layout das tags e seus retangulos'}
      layTags := TLayout.Create(lay);
      layTags.Parent := lay;
      layTags.Align := TAlignLayout.Client;
      layTags.Margins.Right := 5;

      //retângulos das Tags
      for x := Low(FCamposTags) to High(FCamposTags) do
      begin
        if (FCamposTags[x].AsString <> '')  then
        begin
          recTag := TRectangle.Create(layTags);
          recTag.Parent := layTags;
          recTag.HitTest := False;
          recTag.Align := TAlignLayout.Right;
          recTag.Stroke.Kind := TBrushKind.None;
          recTag.Width := 32;
          recTag.Height := 32;
          recTag.Margins.Left := 3;

          valorTag := FCamposTags[x].AsString;
          SeparaStrings(valorTag, ';', TagID, TagColor);
          SeparaStrings(TagColor, ';', TagColor, TagNome);
          RGB               := StrToIntDef(TagColor, TAlphaColorRec.White);
          recTag.Fill.Color := TAlphaColor(RGBtoBGR(RGB) or $FF000000);
        end;
      end;
      {$ENDREGION}
    {$ENDREGION}

    FDataset.Next;
  end;
end;

procedure TGeradorFila.CriarFilaGrid;
var
  lb: TListbox;
  lbi: TListBoxItem;
  gpl, gplCabecalho: TGridPanelLayout;
  x: Integer;
  rec: TRectangle;
  lbl: TLabel;
  cor, corTexto: TAlphaColor;
  layCabecalho: TLayout;
  valorTag, TagID, TagColor, TagNome: String;
  RGB: TAlphaColor;
  linha : TLine;
  LMargemLinhaColorida: Integer;

  function CriarColunasNaLinha(const AParent: TControl): TObject;
  var
    li, lc: Integer;
    col: TGridPanelLayout.TColumnItem;
  begin
    gpl := TGridPanelLayout.Create(AParent);
    gpl.Parent := AParent;
    gpl.Align := TAlignLayout.Client;
    gpl.RowCollection.Clear;
    gpl.RowCollection.Add;
    gpl.ColumnCollection.Clear;
    gpl.HitTest := False;

    //Senha
    col := gpl.ColumnCollection.Add;
    col.SizeStyle := TGridPanelLayout.TSizeStyle.Absolute;

    if FTamanhoFonte = TAMANHO_FONTE_EX_GRANDE then
      col.Value := 160
    else
    if FTamanhoFonte = TAMANHO_FONTE_GRANDE then
      col.Value := 100
    else
    if FTamanhoFonte = TAMANHO_FONTE_MEDIA then
      col.Value := 50
    else
      col.Value := 40;

    //Nome
    if vgParametrosModulo.VisualizarNomeClientes then
    begin
      col := gpl.ColumnCollection.Add;
      col.SizeStyle := TGridPanelLayout.TSizeStyle.Percent;
      col.Value := 100;
    end;

    if vgParametrosModulo.MostrarProntuario then
    begin
      col := gpl.ColumnCollection.Add;
      col.SizeStyle := TGridPanelLayout.TSizeStyle.Percent;
      col.Value := 50;
    end;

    //Hora
    col := gpl.ColumnCollection.Add;
    col.SizeStyle := TGridPanelLayout.TSizeStyle.Absolute;

    if FTamanhoFonte = TAMANHO_FONTE_EX_GRANDE then
      col.Value := 180
    else
    if FTamanhoFonte = TAMANHO_FONTE_GRANDE then
      col.Value := 160
    else
    if FTamanhoFonte = TAMANHO_FONTE_MEDIA then
      col.Value := 80
    else
      col.Value := 60;

    //tags
    for li := Low(FCamposTags) to High(FCamposTags) do
    begin
      col := gpl.ColumnCollection.Add;
      col.SizeStyle := TGridPanelLayout.TSizeStyle.Absolute;

      if (FCamposTags[li].Visible) or (not vgParametrosModulo.MostrarTAGsPreenchidas) then
      begin
        var LColunas: Integer;

        col.Value := 15;

        if Assigned(gplCabecalho) then
          gplCabecalho.ColumnCollection[col.Index].Value := 15;

        if AParent is TListBoxItem then
          for var k := 0 to Pred(lb.Items.Count) do
          begin
            //ShowMessage(lb.ItemByIndex(k).TagObject.ClassName);

            if Assigned(lb.ItemByIndex(k).TagObject) then
            begin
              LColunas := TGridPanelLayout(lb.ItemByIndex(k).TagObject).ColumnCollection.Count - High(FCamposTags) - 1;
              TGridPanelLayout(lb.ItemByIndex(k).TagObject).ColumnCollection[li + LColunas].Value := 15;
            end;
            //ShowMessage(IntToStr(TGridPanelLayout(lb.ItemByIndex(k).TagObject).ColumnCollection.Count));
            //TGridPanelLayout(lb.ItemByIndex(k).TagObject).ColumnCollection[k].Value := 15;
          end;
      end;
    end;

    Result := gpl;
  end;

  procedure CabecalhoColuna(const AParent: TControl; const AField: TField);
  begin
    rec := TRectangle.Create(AParent);
    rec.Parent := gpl;
    rec.Align := TAlignLayout.Client;
    rec.Stroke.Color := TAlphaColorRec.Gray;
    rec.Sides := [TSide.Right];
    rec.Fill.Color := $FF005E8D; //Azul escuro, igual ao Style
    rec.HitTest := False; //isto desabilita o clique no cabeçalho da coluna

    if Assigned(AField) and (AField.DisplayLabel <> '') then
    begin
      lbl := TLabel.Create(rec);
      lbl.Parent := rec;
      lbl.Align := TAlignLayout.Client;

      if ((vgParametrosModulo.ModoCallCenter) and (AField.DisplayLabel = 'Senha')) then
        lbl.Text := 'Mesa'
      else
        lbl.Text := AField.DisplayLabel;

      lbl.TextSettings.HorzAlign := TTextAlign.Center;
      lbl.TextSettings.Font.Style := [TFontStyle.fsBold];
      lbl.FontColor := TAlphaColorRec.White;
      lbl.TextSettings.Trimming := TTextTrimming.None;

      if FTamanhoFonte = TAMANHO_FONTE_EX_GRANDE then
        lbl.TextSettings.Font.Size := FTamanhoFonte - 15
      else
      if FTamanhoFonte = TAMANHO_FONTE_GRANDE then
        lbl.TextSettings.Font.Size := FTamanhoFonte - 10
      else
      if FTamanhoFonte = TAMANHO_FONTE_MEDIA then
        lbl.TextSettings.Font.Size := FTamanhoFonte - 8
      else
        lbl.TextSettings.Font.Size := FTamanhoFonte;

      lbl.TextSettings.WordWrap := False;
      lbl.StyledSettings := lbl.StyledSettings - [TStyledSetting.Style, TStyledSetting.FontColor, TStyledSetting.Size];
    end;
  end;
begin
  layCabecalho := TLayout.Create(FParent);
  layCabecalho.Parent := FParent;
  layCabecalho.Align  := TAlignLayout.Top;

  if (FTamanhoFonte = TAMANHO_FONTE_EX_GRANDE) then
    layCabecalho.Height := 60
  else if (FTamanhoFonte = TAMANHO_FONTE_GRANDE) then
    layCabecalho.Height := 40
  else if (FTamanhoFonte = TAMANHO_FONTE_MEDIA) then
    layCabecalho.Height := 28
  else
    layCabecalho.Height := 20;

  {$REGION '//Cabeçalho'}
  gplCabecalho := TGridPanelLayout(CriarColunasNaLinha(layCabecalho));

  CabecalhoColuna(layCabecalho, FCampoSenha);
  if vgParametrosModulo.VisualizarNomeClientes then CabecalhoColuna(layCabecalho, FCampoNome);
  if vgParametrosModulo.MostrarProntuario then CabecalhoColuna(layCabecalho, FCampoProntuario);
  CabecalhoColuna(layCabecalho, FCampoHora);

  for x := Low(FCamposTags) to High(FCamposTags) do
    //if FCamposTags[x].Visible then
    CabecalhoColuna(layCabecalho, nil);
  {$ENDREGION}

  lb := TListBox.Create(FParent);
  lb.Parent := FParent;
  lb.Align := TAlignLayout.Client;
  lb.DefaultItemStyles.ItemStyle := 'listboxitemstyle';
  lb.StyleLookup := 'transparentlistboxstyle';
  lb.AlternatingRowBackground := True;
  lb.MultiSelect := False;
  lb.EnableDragHighlight := False;
  lb.MultiSelectStyle := TMultiSelectStyle.None;
  lb.DisableMouseWheel := True;

  if (FTamanhoFonte = TAMANHO_FONTE_EX_GRANDE) then
  begin
    lb.ItemHeight        := 70;
    LMargemLinhaColorida := 10;
  end
  else if (FTamanhoFonte = TAMANHO_FONTE_GRANDE) then
  begin
    lb.ItemHeight        := 50;
    LMargemLinhaColorida := 5;
  end
  else if (FTamanhoFonte = TAMANHO_FONTE_MEDIA) then
  begin
    lb.ItemHeight        := 30;
    LMargemLinhaColorida := 3;
  end
  else
  begin
    lb.ItemHeight        := 22;
    LMargemLinhaColorida := 1;
  end;

  lb.BeginUpdate;
  try

    FDataset.First;
    while not FDataset.Eof do
    begin
      //cria o listboxitem (linha do grid)
      lbi            := TListBoxItem.Create(lb);
      lbi.Height     := lb.ItemHeight;
      lbi.Parent     := lb;
      lbi.Selectable := True;
      lbi.OnDblClick := FOnListBoxItemDblClick;
      lbi.Tag        := FDataset.Tag; //id da fila
      lbi.TagFloat   := FCampoSenha.AsInteger;
      lbi.TagString  := FCampoNome.AsString;
      lbi.OnMouseUp  := FOnSenhaMouseUp;
      //lbi.Selectable := False;

      for x := Low(FCamposTags) to High(FCamposTags) do
        if FCamposTags[x].AsString <> '' then
          FCamposTags[x].Visible := True;

      lbi.TagObject := CriarColunasNaLinha(lbi);

      //define a cor que será usada no texto
      cor := StrToIntDef(FCampoCor.AsString, TAlphaColorRec.White);
      corTexto := TAlphaColorRec.Black;

      {$REGION '//retângulo de fundo na linha para preencher a cor do limiar'}
      if (cor <> TAlphaColorRec.White) then
      begin
        rec := TRectangle.Create(lbi);
        rec.Parent := lbi;
        rec.Align := TAlignLayout.Contents;
        rec.Stroke.Kind := TBrushKind.None;
        rec.Fill.Color := cor;
        rec.HitTest := False;

        // Estilo Layout 0 Linear Fina
        if FEstiloLayout = 0 then
          rec.Margins.Top := lbi.Height - LMargemLinhaColorida
        else if FEstiloLayout = 1 then // Estilo Layout 0 Linear Solida
          rec.Margins.Top := 0;

        rec.Margins.Left := 0;
        rec.Margins.Bottom := 0;
        rec.Margins.Right := 0;
        gpl.BringToFront;
      end;
      {$ENDREGION}

      {$REGION '//label da SENHA'}
      lbl := TLabel.Create(gpl);
      lbl.Parent := gpl;
      lbl.Align := TAlignLayout.Client;
      lbl.Text := FCampoSenha.AsString;
      lbl.TextSettings.HorzAlign := TTextAlign.Center;
      lbl.Margins.Left := 2;
      lbl.Margins.Right := 2;
      lbl.TextSettings.Trimming := TTextTrimming.None;
      lbl.TextSettings.WordWrap := False;
      lbl.TextSettings.Font.Size := FTamanhoFonte;
      lbl.StyledSettings := lbl.StyledSettings - [TStyledSetting.FontColor, TStyledSetting.Size];
      lbl.FontColor := corTexto;
      {$ENDREGION}

      {$REGION '//label do Nome'}
      if vgParametrosModulo.VisualizarNomeClientes then
      begin
        lbl := TLabel.Create(gpl);
        lbl.Parent := gpl;
        lbl.Align := TAlignLayout.Client;
        lbl.Text :=  FCampoNome.AsString;
        lbl.TextSettings.HorzAlign := TTextAlign.Leading;
        lbl.Margins.Left := 2;
        lbl.Margins.Right := 2;
        lbl.TextSettings.Trimming := TTextTrimming.None;
        lbl.TextSettings.WordWrap := False;
        lbl.TextSettings.Font.Size := FTamanhoFonte;
        lbl.StyledSettings := lbl.StyledSettings - [TStyledSetting.FontColor, TStyledSetting.Size];
        lbl.FontColor := corTexto;
      end;
      {$ENDREGION}

      {$REGION '//label do Prontuário'}
      if vgParametrosModulo.MostrarProntuario then
      begin
        lbl := TLabel.Create(gpl);
        lbl.Parent := gpl;
        lbl.Align := TAlignLayout.Client;
        lbl.Text := IfThen(FCampoProntuario.AsInteger = 0, '', FCampoProntuario.AsString);
        lbl.TextSettings.HorzAlign := TTextAlign.Center;
        lbl.Margins.Left := 2;
        lbl.Margins.Right := 2;
        lbl.TextSettings.Trimming := TTextTrimming.None;
        lbl.TextSettings.WordWrap := False;
        lbl.TextSettings.Font.Size := FTamanhoFonte;
        lbl.StyledSettings := lbl.StyledSettings - [TStyledSetting.FontColor, TStyledSetting.Size];
        lbl.FontColor := corTexto;
      end;
      {$ENDREGION}

      {$REGION '//label da HORA'}
      lbl := TLabel.Create(gpl);
      lbl.Parent := gpl;
      lbl.Align := TAlignLayout.Client;
      lbl.Text := FCampoHora.AsString;
      lbl.TextSettings.HorzAlign := TTextAlign.Center;
      lbl.Margins.Left := 2;
      lbl.Margins.Right := 2;
      lbl.TextSettings.Trimming := TTextTrimming.None;
      lbl.TextSettings.WordWrap := False;
      lbl.TextSettings.Font.Size := FTamanhoFonte;
      lbl.StyledSettings := lbl.StyledSettings - [TStyledSetting.FontColor, TStyledSetting.Size];
      lbl.FontColor := corTexto;
      {$ENDREGION}

      {$REGION '//tags'}
      for x := Low(FCamposTags) to High(FCamposTags) do
      begin
        rec := TRectangle.Create(gpl);
        rec.Parent := gpl;
        rec.HitTest := False;
        rec.Align := TAlignLayout.Client;

        if (FCamposTags[x].AsString <> '') then
        begin
          rec.Stroke.Kind := TBrushKind.None;
          rec.Margins.Top := 2;
          rec.Margins.Left := 3;
          rec.Margins.Bottom := 3;
          rec.Margins.Right := 1;

          valorTag := FCamposTags[x].AsString;
          SeparaStrings(valorTag, ';', TagID, TagColor);
          SeparaStrings(TagColor, ';', TagColor, TagNome);
          RGB := StrToIntDef(TagColor, TAlphaColorRec.White);
          rec.Fill.Color := TAlphaColor(RGBtoBGR(RGB) or $FF000000);
        end
        else
        begin
          rec.Visible := False;
          //gpl.ColumnCollection.Count;
          //gpl.ColumnCollection[x+4].Value := 1;
          //gplCabecalho.ColumnCollection[x+4].Value := 1;
        end;
      end;
      {$ENDREGION}

      {$REGION '//Linha Horizontal'}
      linha := TLine.Create(lbi);
      linha.Parent       := lbi;
      linha.Align        := TAlignLayout.Contents;
      linha.LineType     := TLineType.Bottom;
      linha.Stroke.Kind  := TBrushKind.Solid;
      linha.Stroke.Color := $FFD5D5D5;
      linha.HitTest := False;
      {$ENDREGION}
      FDataset.Next;
    end;
  finally
    lb.TagObject := layCabecalho;
    lb.OnCalcContentBounds := ListBoxFilaLayoutGridOnCalcContentBounds;
    lb.EndUpdate;
  end;
end;

procedure TGeradorFila.ListBoxFilaLayoutGridOnCalcContentBounds(Sender: TObject;
  var ContentBounds: TRectF);
var
  ListBox: TListBox;
begin
  ListBox := TListBox(Sender);
  TLayout(ListBox.TagObject).Margins.Right :=
    ListBox.Width - ListBox.ClientWidth-2;
end;

class procedure TGeradorFila.Execute(const ALayout: TLayoutFila;
  const AParent: TControl; const ADataset: TDataset; const AFieldNome,
  AFieldSenha, AFieldHora, AFieldCor, AFieldProntuario: string;
  const AFieldsDescTags: Array of String;
  const AOnSenhaMouseUpEvent: TMouseEvent; AOnListBoxItemDblClick: TNotifyEvent);
var
  gen: TGeradorFila;
  i: Integer;
begin
  if (not Assigned(ADataset)) or (not ADataset.Active) or (ADataset.IsEmpty) or
     (not Assigned(AParent)) then
    exit;

  gen := TGeradorFila.Create;
  try
    gen.FParent                := AParent;
    gen.FDataset               := ADataset;
    gen.FCampoNome             := ADataset.FieldByName(AFieldNome);
    gen.FCampoSenha            := ADataset.FieldByName(AFieldSenha);
    gen.FCampoHora             := ADataset.FieldByName(AFieldHora);
    gen.FCampoProntuario       := ADataset.FieldByName(AFieldProntuario);
    gen.FCampoCor              := ADataset.FieldByName(AFieldCor);
    gen.FOnSenhaMouseUp        := AOnSenhaMouseUpEvent;
    gen.FOnListBoxItemDblClick := AOnListBoxItemDblClick;

    SetLength(gen.FCamposTags, Length(AFieldsDescTags));
    for i := Low(AFieldsDescTags) to High(AFieldsDescTags) do
    begin
      gen.FCamposTags[i] := ADataset.FieldByName(AFieldsDescTags[i]);

      if ADataset.FieldByName(AFieldsDescTags[i]).AsString<>'' then
        gen.FCamposTags[i].Visible := True;
    end;

    case ALayout of
      lfCartoes: gen.CriarFilaComCorDeFundo;
      lfGrid:    gen.CriarFilaGrid;
    end;
  finally
    gen.Free;
  end;
end;

end.
