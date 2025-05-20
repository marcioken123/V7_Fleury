unit untCommonFormDadosAdicionais;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  untCommonFormBase, Data.Bind.EngExt, Fmx.Bind.DBEngExt, Data.Bind.Components,
  FMX.Effects, FMX.Objects, FMX.Controls.Presentation, FMX.Layouts, FMX.ListBox,
  System.JSON, FMX.ScrollBox, FMX.Memo;

type
  TListaBotoes = Array of FMX.StdCtrls.TButton;

  TListBtnsTAGs = class
    public
     ListaBotoes: TListaBotoes;
     PA: Integer;
     constructor Create;
     procedure AddButton(const aBotao: FMX.StdCtrls.TButton);
    end;

  TFrmDadosAdicionais = class(TFrmBase)
    ListBox_DadosAdicionais: TListBox;
    ListBox_TAGs: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    ListBoxItem4: TListBoxItem;
    ListBoxItem5: TListBoxItem;
    ListBoxItem6: TListBoxItem;
    ListBoxHeader1: TListBoxHeader;
    Label1: TLabel;
    ListBoxItem7: TListBoxItem;
    Timer1: TTimer;
    Splitter1: TSplitter;
    Image1: TImage;
    imgCopy: TImage;
    rectObservacao: TRectangle;
    Layout1: TLayout;
    memObservacao: TMemo;
    Label2: TLabel;
    btnSalvar: TButton;
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
  private
    { Private declarations }
    function GetListBtnsTAGs(const aIDPA: Integer): TListBtnsTAGs;
    property ListBtnsTAGs[const aIDPA: Integer]: TListBtnsTAGs read GetListBtnsTAGs;
    function GetIndexPANaListBtnsTAGs(const aIDPA: Integer): Word;
  public
    { Public declarations }
    FMaxTAGsCriadas: Integer;
    FListBtnsTAGs: Array of TListBtnsTAGs;
    LNome, LProntuario, LPassagem, LTelefone, LObservacao, LSenha: string;
    LIdPA, LIdUnidade: Integer;
    procedure CriarTAGs(const PA: Integer; LParent: TRectangle);
    function CarregarDadosAdicionais(PA: integer; Senha: string; const aIdUnidade: Integer): Boolean;
    procedure DesligarOutrasTAGGrupos(const aIDPA: Integer; const aTagAtual: FMX.StdCtrls.TButton);
    procedure AtualizarIsPressedRetangulo(const aBotaoTag: FMX.StdCtrls.TButton); overload;
    procedure AtualizarIsPressedRetangulo(const aTag: Integer); overload;
    procedure centralizaGruposTags;
  end;

const
  {$IFDEF IS_MOBILE}
  BTN_WIDTH  = 40;
  BTN_HEIGHT = 40;
  {$ELSE}
 // BTN_WIDTH  = 22;
 // BTN_HEIGHT = 23;
   BTN_WIDTH  = 22;
   BTN_HEIGHT = 22;
  {$ENDIF}
  cMarginLeft = 4;

var
  FListaTAGs: TStringList;
  FJSONDadosAdicionais: TJSONObject;
  TAGs: TIntegerDynArray;

function FrmDadosAdicionais(const aIDUnidade: integer; const aAllowNewInstance: Boolean = False; const aOwner: TComponent = nil): TFrmDadosAdicionais;

implementation

uses
  MyAspFuncoesUteis,
  untCommonDMConnection,
  Sics_Common_Parametros,
  untCommonDMUnidades,
  System.UIConsts,
  uFormat,
  System.MaskUtils,
  untLog,
  Winapi.Windows,
  untCommonDMClient,
  FMX.Platform.Win,
  Datasnap.DBClient,
  Vcl.Graphics,
  Vcl.ClipBrd;

{$R *.fmx}

procedure TFrmDadosAdicionais.centralizaGruposTags;
var
  LChildren1: TComponent;
begin
//btnTag.Position.X   := ((BTN_WIDTH + cMarginLeft ) * (LDMClient.cdsTags.RecNo - 1)) + ((grpBox.Width - ((BTN_WIDTH + cMarginLeft) * LDMClient.cdsTags.RecordCount)) /2) + 2;

  for var j := 0 to ListBox_TAGs.Count - 1 do
  begin
    for var k := 0 to ListBox_TAGs.ItemByIndex(j).ComponentCount - 1 do
    begin
      if ListBox_TAGs.ItemByIndex(j).Components[k] is TRectangle then
        for var m := 0 to ListBox_TAGs.ItemByIndex(j).Components[k].ComponentCount - 1 do
        begin
          LChildren1 := ListBox_TAGs.ItemByIndex(j).Components[k].Components[m];

          for var i := 0 to LChildren1.ComponentCount - 1 do
            if (LChildren1.Components[i] is TButton) then
            begin
              TButton(LChildren1.Components[i]).Position.X :=
              ((BTN_WIDTH + cMarginLeft) * (i - 1)) + ((TGroupBox(LChildren1).Width - ((BTN_WIDTH + cMarginLeft) * (LChildren1.ComponentCount - 1))) / 2) + 2;
            end;
        end;
    end;
  end;
end;

function InvertColor(Color: TColor): TColor;
begin
  if ((GetRValue(Color) * 299 + GetGValue(Color) * 587 + GetBValue(Color) * 114))/1000 < 128 then
    Result := clWhite
  else
    Result := clBlack;
end;

function IntInArray(const Value: Integer; IntArray: array of Integer): Boolean;
var
  I: Integer;
begin
    Result := True;
    for I := Low(IntArray) to High(IntArray) do
        if IntArray[i] = Value then Exit;
    Result := False;
end;

procedure TFrmDadosAdicionais.CriarTAGs(const PA: Integer; LParent: TRectangle);
const
  {$IFDEF IS_MOBILE}
  BTN_WIDTH  = 40;
  BTN_HEIGHT = 40;
  {$ELSE}
 // BTN_WIDTH  = 22;
 // BTN_HEIGHT = 23;
   BTN_WIDTH  = 22;
   BTN_HEIGHT = 22;
  {$ENDIF}
  cMarginLeft = 4;

var
  iTop, iLeft,
  LTopBtnTag, maiorTamanho : Single;
  grpBox                   : TGroupBox;
  FUltimoGrupBoxTags       : TControl;
  FUltimoBtnTag, btnTag    : TButton;
  LCircle                  : TCircle;
  LComponent, vPanelTAGs   : TComponent;
  LNomeGrupoTag            : String;
  LBeginUpdatePA           : Boolean;
  LDMClient                : TDMClient;
  LListBtnsTAGs            : TListBtnsTAGs;
  tituloGroupTag           : TLabel;

  procedure centralizaGruposTags;
  var
    recTags : TRectangle;
    LChildren: TFMxObject;
  begin
    recTags := LParent;

    if recTags.ChildrenCount > 0 then
    for LChildren in  recTags.Children do
    begin
      if(LChildren is TGroupBox)then
      begin
        if(TGroupBox(LChildren).Width < recTags.Width )then
        begin
          TGroupBox(LChildren).Position.X := (recTags.Width - TGroupBox(LChildren).Width)/2
        end;
      end;
    end;
  end;

  function SelecionarTAG(IdTag: Integer; grpName: string; Visible: Boolean): Boolean;
  var
    btn     : FMX.StdCtrls.TButton; // RAP
    //grpBox  : TComponent;
    OldStaysPressed: Boolean;
  begin
    //grpBox := GetComponentePA(grpName, PA, True);

    if not Assigned(grpBox) then Exit;

    TGroupBox(grpBox).Visible := True;
    btn := FMX.StdCtrls.TButton(grpBox.FindComponent('btnTag__' + IntToStr(IdTag)));

    if Assigned(btn) then
    begin
      DesligarOutrasTAGGrupos(PA, btn);
      OldStaysPressed := btn.StaysPressed;

      try
        btn.StaysPressed := True;
        btn.IsPressed := True;
      finally
        btn.StaysPressed := OldStaysPressed;
      end;

      AtualizarIsPressedRetangulo(IdTag);

      if (LDMClient.cdsTags.Locate('ID', IdTag, [])) then
      begin
        if (FListaTAGs.IndexOf(LDMClient.cdsTags.FieldByName('Nome').AsString) = -1) then
          FListaTAGs.AddObject(LDMClient.cdsTags.FieldByName('Nome').AsString, TGroupBox(grpBox).Clone(nil));
      end;
    end;
  end;
begin
  //if not GetPaJaFoiCriada(PA) then
    //exit;

  LDMClient := DMClient(IdUnidade, not CRIAR_SE_NAO_EXISTIR);
{$IFNDEF IS_MOBILE}
  LockWindowUpdate(WindowHandleToPlatform(Self.Handle).Wnd);
{$ENDIF IS_MOBILE}
  try
    //LBeginUpdatePA := BeginUpdatePA(PA);
    try
      try
        if not DMConnection(IDUnidade, not CRIAR_SE_NAO_EXISTIR).ValidarPA(PA, IdUnidade) then
          Exit;

        iTop := 5;
        FMaxTAGsCriadas := 0;
        maiorTamanho := 0;

        if (not LDMClient.cdsGruposDeTAGs.IsEmpty) and (not LDMClient.cdsTags.IsEmpty) then
          LParent.Visible := True
        else
        begin
          LParent.Visible := False;
          Exit;
        end;

        vPanelTAGs := LParent;

        if Assigned(vPanelTAGs) then
        begin
          vPanelTAGs.DestroyComponents;
          TControl(TControl(vPanelTAGs).Parent).Height := 4;
        end;

        TControl(vPanelTAGs).Width := 20;

        if not(Assigned(vPanelTAGs) and (vPanelTAGs is TControl)) then
          Exit;

        FUltimoGrupBoxTags := nil;

        LDMClient.cdsGruposDeTAGs.First;

        while not LDMClient.cdsGruposDeTAGs.Eof do
        begin
          LDMClient.cdsTags.Filter   := 'IdGrupo=' + LDMClient.cdsGruposDeTAGs.FieldByName('ID').AsString;
          LDMClient.cdsTags.Filtered := True;
          LDMClient.cdsTags.First;

          {$IFNDEF CompilarPara_TGS}
          if (LDMClient.cdsTags.IsEmpty) or
             (not IntInArray(LDMClient.cdsTags.FieldByName('IDgrupo').AsInteger, vgParametrosModulo.GruposTAGSLayoutBotao)) then
          begin
            LDMClient.cdsGruposDeTAGs.Next;
            Continue;
          end;
          {$ENDIF CompilarPara_TGS}

          Inc(FMaxTAGsCriadas);
          LNomeGrupoTag := 'grpTags_' + IntToStr(FMaxTAGsCriadas);
          LComponent := vPanelTAGs.FindComponent(LNomeGrupoTag);

          if Assigned(LComponent) then
            FreeAndNil(LComponent);

          TControl(vPanelTAGs).width := (LDMClient.cdsTags.RecordCount * (BTN_WIDTH + cMarginLeft)) + 20;    // + 6

          grpBox                         := TGroupBox.Create(vPanelTAGs);
          grpBox.Parent                  := LParent;
          grpBox.Margins.Left            := 4;
          grpBox.Margins.Top             := 4;
          FUltimoGrupBoxTags             := grpBox;
          grpBox.Enabled                 := True;
          //grpBox.Align                   := TAlignLayout.None;
          grpBox.Align                   := TAlignLayout.MostTop;
          grpBox.Name                    := LNomeGrupoTag;
          grpBox.Text                    := '   ';
          grpBox.StyledSettings          := [TStyledSetting.Family, TStyledSetting.Size];
          grpBox.TextSettings.FontColor  := claWhite;
          grpBox.TextSettings.Font.Style := [TFontStyle.fsBold];
          grpBox.StyleLookup             := 'grpTags';

          tituloGroupTag := TLabel.Create(grpBox);

          with tituloGroupTag do
          begin
            Parent   := grpBox;
            Name     := 'lbl'+LNomeGrupoTag;
            Text     := LDMClient.cdsGruposDeTAGs.FieldByName('NOME').AsString;
            Align    := TAlignLayout.MostTop;
            TextSettings.HorzAlign := TTextAlign.Center;
            AutoSize := True;
            {$IFDEF CompilarPara_PA}
            Visible  := IntInArray(LDMClient.cdsTags.FieldByName('IDgrupo').AsInteger, vgParametrosModulo.GruposTAGSLayoutBotao);
            {$ENDIF CompilarPara_PA}
          end;

          if Assigned(vPanelTAGs) and (vPanelTAGs is TControl) then
            grpBox.Parent   := TControl(vPanelTAGs);

          {$IFNDEF IS_MOBILE}
          grpBox.Height     := 45;
          {$ENDIF IS_MOBILE}

          if (Assigned(vPanelTAGs) and (vPanelTAGs is TControl) and Assigned(TControl(vPanelTAGs).Parent) and
            (TControl(vPanelTAGs).Parent is TControl)) then
          begin
            {$IFDEF CompilarPara_MULTIPA}
            TControl(TControl(vPanelTAGs).Parent).Height := TControl(TControl(vPanelTAGs).Parent).Height + TControl(vPanelTAGs).Height + TControl(vPanelTAGs).Margins.Top + 20;
            {$ENDIF CompilarPara_MULTIPA}

            {$IFDEF IS_MOBILE}
             TControl(TControl(vPanelTAGs).Parent).Height := 90;
             TControl(vPanelTAGs).Anchors    := [TAnchorKind.akTop];
             TControl(vPanelTAGs).Height     := 80;
             grpBox.Height                   := 80;
             TControl(vPanelTAGs).Position.Y := 5;
             TControl(TControl(vPanelTAGs).Parent).Position.Y := GetPnlLogin.Position.Y;
             GetPnlLogin.Position.Y          := TControl(TControl(vPanelTAGs).Parent).Position.Y + TControl(TControl(vPanelTAGs).Parent).Height;
            {$ELSE}
              TControl(TControl(vPanelTAGs).Parent).Height := 50;
              TControl(vPanelTAGs).Height    := 48;
            {$ENDIF IS_MOBILE}
          end;
         // grpBox.Width      := (LDMClient.cdsTags.RecordCount * (BTN_WIDTH + cMarginLeft)) + 20 + tituloGroupTag.Width;

          grpBox.Position.X := 0;
          grpBox.Position.Y := iTop;

          if(grpBox.Width > maiorTamanho)then
          begin
            maiorTamanho := grpBox.Width;
          end;

          iTop := iTop + grpBox.Height + 2;

          grpBox.Tag        := PA; // id da PA
          grpBox.Anchors    := [TAnchorKind.akLeft, TAnchorKind.akTop];
          //grpBox.OnClick    := edtNomeClienteExit;

          {$IFDEF CompilarPara_PA}
          grpBox.Visible := IntInArray(LDMClient.cdsTags.FieldByName('IDgrupo').AsInteger, vgParametrosModulo.GruposTAGSLayoutBotao);
          {$ENDIF CompilarPara_PA}
          //LDMClient.cdsGruposDeTAGs.Next;
          //Continue;

          try
            iLeft := 4;
            LTopBtnTag := 17;
            FUltimoBtnTag := nil;

            LDMClient.cdsTags.First;
            while not LDMClient.cdsTags.Eof do
            begin
              btnTag              := TButton.Create(grpBox);
              FUltimoBtnTag       := btnTag;

              btnTag.Name         := 'btnTag_' + LDMClient.cdsTags.FieldByName('ID').AsString;
              btnTag.Anchors      := [TAnchorKind.akLeft, TAnchorKind.akTop];
              btnTag.parent       := grpBox;
              btnTag.Position.X   := ((BTN_WIDTH + cMarginLeft ) * (LDMClient.cdsTags.RecNo - 1)) + ((grpBox.Width - ((BTN_WIDTH + cMarginLeft) * LDMClient.cdsTags.RecordCount)) /2) + 2;
              {$IFDEF IS_MOBILE}
              btnTag.Position.Y   := LTopBtnTag + 12; //RAP 02/06/2016
              {$ELSE}
              btnTag.Position.Y   := LTopBtnTag;
              {$ENDIF}

              btnTag.Width        := BTN_WIDTH;
              btnTag.Margins.Left := cMarginLeft;
              btnTag.Margins.Top  := 4;
              btnTag.Enabled      := True;
              btnTag.Height       := BTN_HEIGHT;
              iLeft := iLeft + btnTag.Width + 4;
              btnTag.StyleLookup  := 'BtCirculoVermelho';

              // *** não compatível com FMX, analisar alternativa!
              // GroupIndex := frmDataModuleClientes.cdsGruposDeTags.FieldByName('ID').AsInteger;

              // *** não compatível com FMX, analisar alternativa!
              // Layout := blGlyphRight; ==> não compatível com FMX

              btnTag.Tag          := LDMClient.cdsTags.FieldByName('ID').AsInteger;
              btnTag.Text         := '';
              //btnTag.OnClick      := dmUnidades.FormClient.OnClickBtnTag;
              //btnTag.OnMouseDown  := dmUnidades.FormClient.OnMouseDownBtnTag;
              btnTag.StaysPressed := True;

              LCircle                     := TCircle.Create(btnTag);
              LCircle.Name                := 'recColorTag_' + LDMClient.cdsTags.FieldByName('ID').AsString;
              LCircle.Parent              := btnTag;
              LCircle.Align               := TAlignLayout.Client;
              LCircle.Fill.Color          := TAlphaColor(RGBtoBGR(LDMClient.cdsTags.FieldByName('CODIGOCOR').AsInteger) or $FF000000);   //RGBToAlphaColor(LDMClient.cdsTags.FieldByName('CODIGOCOR').AsInteger);
              LCircle.Fill.Kind           := TBrushKind.Solid;
              LCircle.Fill.Gradient.Style := TGradientStyle.Radial;
              LCircle.Fill.Gradient.Color := LCircle.Fill.Color;

              if EhCorClara(LCircle.Fill.Color) then
                LCircle.Fill.Gradient.Color1 := claBlack
              else if EhCorPreta(LCircle.Fill.Color) then
                LCircle.Fill.Gradient.Color1 := claYellow
              else
                LCircle.Fill.Gradient.Color1 := claWhite;

//              AddHint(btnTag, LDMClient.cdsTags.FieldByName('NOME').AsString, '', LCircle.Fill.Color);
              AddHint(btnTag, LDMClient.cdsTags.FieldByName('NOME').AsString, '', TAlphaColorRec.Black);

              LCircle.HitTest    := False;
              LCircle.Tag        := btnTag.Tag;
              LCircle.Width      := 100;
              LCircle.Height     := 100;
              LCircle.Position.X := 0;
              LCircle.Position.Y := 0;
              LCircle.Align      := TAlignLayout.Client;
              LListBtnsTAGs      := ListBtnsTAGs[PA];

              if Assigned(LListBtnsTAGs) then
                LListBtnsTAGs.AddButton(btnTag);

              if (IntInArray(LDMClient.cdsTags.FieldByName('ID').AsInteger, TAGS)) then
                AtualizarIsPressedRetangulo(LDMClient.cdsTags.FieldByName('ID').AsInteger);

              LDMClient.cdsTags.Next;
            end;
          finally
            LDMClient.cdsTags.Filtered := False;
          end;

          grpBox.Repaint;
          LDMClient.cdsGruposDeTAGs.Next;
        end;

        TControl(vPanelTAGs).Repaint;
        //GetpnlTAGs(PA).Height := iTop;
        LParent.Height := iTop;
        LParent.Width  := maiorTamanho;
        {$IFDEF CompilarPara_MULTIPA}
        TControl(vPanelTAGs).Height := TControl(vPanelTAGs).Height + TControl(vPanelTAGs).Height;
        {$ENDIF CompilarPara_MULTIPA}
        //dmUnidades.FormClient.AjustarTopBotoes(False);   //LBC VERIFICAR BUG #85
        {$IFDEF CompilarPara_MULTIPA}
        Application.ProcessMessages;
        TControl(vPanelTAGs).Height := TControl(vPanelTAGs).Height + TControl(vPanelTAGs).Height;
        {$ENDIF CompilarPara_MULTIPA}

        centralizaGruposTags;
      except
        on E: Exception do
          TLog.MyLog('Erro ao criar tags: ' + E.Message, Self);
      end;
    finally
      //if LBeginUpdatePA then
        //EndUpdatePA(PA);
    end;
  finally
{$IFNDEF IS_MOBILE}
    LockWindowUpdate(0);
{$ENDIF IS_MOBILE}
  end;
end;

function FormatarTelefone(ATelefone : String): String;
  function SomenteNumero(snum : String) : String;
  var s1, s2: string;
    i: Integer;
  begin
    s1 := snum;
    s2 := '';
    for i := 1 to Length(s1) do
      if CharInSet(s1[i],['0'..'9']) then
        s2 := s2 + s1[i];
    result := s2;
  end;

var
  sTel : String;
  iDigitos : Integer;
begin
  //Obs: mascara prevê tratamento apenas para números brasileiros
  //Obs2: Esta função não leva em conta o código do país (Ex: 55, ou +55)

  sTel := SomenteNumero(ATelefone); //Remove qualquer formatação que o usuário possa ter colocado.
  if sTel = '' then
    Result := ''
  else
  begin
    if sTel[1]='0' then //Verifica se foi adicionado o 0 no início do número
    begin
      sTel  := Trim( copy(sTel,2,Length(sTel)) ); //Remove para fazer a formatação depois adiciona
    end;

   iDigitos := Length(sTel);
   //Formata de acordo com a quantidade de números encontrados.
   case iDigitos of
     1  : Result := FormatMaskText('(9;0;_',sTel);         //8 digitos SEM DDD (ex: 34552318)
     2  : Result := FormatMaskText('(99;0;_',sTel);         //8 digitos SEM DDD (ex: 34552318)
     3  : Result := FormatMaskText('(99) 9;0;_',sTel);         //8 digitos SEM DDD (ex: 34552318)
     4  : Result := FormatMaskText('(99) 99;0;_',sTel);         //8 digitos SEM DDD (ex: 34552318)
     5  : Result := FormatMaskText('(99) 999;0;_',sTel);         //8 digitos SEM DDD (ex: 34552318)
     6  : Result := FormatMaskText('(99) 9999;0;_',sTel);         //8 digitos SEM DDD (ex: 34552318)
     7  : Result := FormatMaskText('(99) 9999-9;0;_',sTel);         //8 digitos SEM DDD (ex: 34552318)
     8  : Result := FormatMaskText('(99) 9999-99;0;_',sTel);         //8 digitos SEM DDD (ex: 34552318)
     9  : Result := FormatMaskText('(99) 9999-999;0;_',sTel);       //9 digitos SEM DDD (ex: 991916889)
     10 : Result := FormatMaskText('(99) 9999-9999;0;_',sTel);    //8 Digitos (convencional, ex: 7734552318)
     11 : Result := FormatMaskText('(99) 99999-9999;0;_',sTel);  //9 Digitos (novos números, ex: 77991916889)
     12 : Result := FormatMaskText('99(99)9999-9999;0;_',sTel);   //Se foram 12 digitos possívelmente digitou a operadora também
     13 : Result := FormatMaskText('99(99)9 9999-9999;0;_',sTel); //Se foram 13 digitos possívelmente digitou a operadora também
   else
     Result := ATelefone; //Mantém na forma que o usuário digitou
   end;
//   if bZero then //Para ficar com a preferência do usuário, se ele digitou o "0" eu mantenho.
//     Result := '0'+Result;
  end;
end;

function FrmDadosAdicionais(const aIDUnidade: integer; const aAllowNewInstance: Boolean = False; const aOwner: TComponent = nil): TFrmDadosAdicionais;
begin
  Result := TFrmDadosAdicionais(TFrmDadosAdicionais.GetInstancia(aIDUnidade, aAllowNewInstance, aOwner));
end;

{ TFrmDadosAdicionais }

function TFrmDadosAdicionais.CarregarDadosAdicionais(PA: integer; Senha: string; const aIdUnidade: Integer): Boolean;
var
  LListBoxItem: TListBoxItem;
  LGroupBox: TGroupBox;
  LRectangle: TRectangle;
  LDMClient: TDMClient;
  LcdsTagsClone: TClientDataSet;

  procedure AddListBox_TAGs(LListBox: TListBox; LListItem: string; LCodigoCor: Integer);
  var
    LListBoxItem: TListBoxItem;
    LRectangle: TRectangle;
  begin
    LListBoxItem := TListBoxItem.Create(LListBox);

    with LListBoxItem do
    begin
      Parent := LListBox;
      StyledSettings := [];
      TextSettings.Font.Family := 'Montserrat';
      TextSettings.Font.Size := 20;
      TextSettings.HorzAlign := TTextAlign.Center;
      TextSettings.FontColor := TAlphaColorRec.White;
      Margins.Top := 5;
      Position.Y := 49;
      Size.Width := 459;
      Size.Height := 44;
      Size.PlatformDefault := False;
      //StyleLookup := 'listboxitemstyle';
      Text := LListItem;
    end;

    LRectangle := TRectangle.Create(LListBoxItem);

    with LRectangle do
    begin
      Parent := LListBoxItem;
      Fill.Color := TAlphaColor(RGBtoBGR(LCodigoCor) or $FF000000); ;
      Fill.Kind := TBrushKind.bkSolid;
      Stroke.Kind := TBrushKind.bkNone;
      Width := 0;
      Height := 0;
      Position.X := 0;
      Position.Y := 0;
      Align := TAlignLayout.Client;
      AddHint(LRectangle, LListItem, '', TAlphaColorRec.Black);
    end;

    with TLabel.Create(LListBoxItem) do
    begin
      Parent := LRectangle;
      StyledSettings := [];
      TextSettings.Font.Family := 'Montserrat';
      TextSettings.Font.Size := 20;
      TextSettings.HorzAlign := TTextAlign.Center;
      TextSettings.FontColor := TAlphaColor(RGBtoBGR(InvertColor(LCodigoCor)) or $FF000000);
      //TextSettings.FontColor := TAlphaColorRec.White;
      Text := LListItem;
      Align := TAlignLayout.Client;
      BringToFront;
    end;
  end;

  procedure AddListBox_DadosAdicionais(LListItem: string);
  var
    LListBoxItem: TListBoxItem;
    LRectangle: TRectangle;
  begin
    LListBoxItem := TListBoxItem.Create(ListBox_DadosAdicionais);

    with LListBoxItem do
    begin
      Parent := ListBox_DadosAdicionais;
      StyledSettings := [];
      TextSettings.Font.Family := 'Montserrat';
      TextSettings.Font.Size := 20;
      Margins.Bottom := 5;
      Position.Y := 49;
      Size.Width := 459;
      Size.Height := 44;
      Size.PlatformDefault := False;
      //StyleLookup := 'listboxitemstyle';
      Text := LListItem;
    end;

    with TImage.Create(LListBoxItem) do
    begin
      Parent := LListBoxItem;
      Align := TAlignLayout.Right;
      MultiResBitmap := imgCopy.MultiResBitmap;
      Opacity := 0.2;
      //HitTest := False;
      Margins.Top := 5;
      Margins.Bottom := 5;
      Width := 25;
      DisableInterpolation := True;
      MarginWrapMode := TImageWrapMode.Fit;
      OnClick := imgCopy.OnClick;
    end;

    LRectangle := TRectangle.Create(LListBoxItem);

    with LRectangle do
    begin
      Parent := LListBoxItem;
      Fill.Kind := TBrushKind.bkNone;
      Stroke.Color := TAlphaColor(RGBtoBGR($FFD9D9D9) or $FF000000);
      Stroke.Kind := TBrushKind.bkSolid;
      Align := TAlignLayout.Client;
    end;
  end;

  function CloneComponent(aSource: TComponent): TComponent;
  var
    mem: TMemoryStream;
  begin
    mem := TMemoryStream.Create;
    try
      mem.WriteComponent(aSource);
      mem.Seek(0, soFromBeginning);
      Result := mem.ReadComponent(nil);
    finally
      mem.free;
    end;
  end;
begin
  with DMConnection(aIdUnidade, not CRIAR_SE_NAO_EXISTIR) do
  begin
    //{$IFDEF CompilarPara_ONLINE}
    SolicitarTAGs(PA, Senha, aIdUnidade);
    //{$ENDIF CompilarPara_ONLINE}
    //if ValidarPA(PA, aIdUnidade) then
    begin
      if EstaPreenchidoCampo(Senha) then
        //EnviarComando(TAspEncode.AspIntToHex(PA, 4) + Chr($CD) + Senha, aIdUnidade)
        SolicitarDadosAdicionais(PA, Senha, aIdUnidade);
        //Beep(400, 800);
    end;

    ListBox_DadosAdicionais.Clear;
    ListBox_TAGs.Items.Clear;
    LObservacao := EmptyStr;
    AddListBox_DadosAdicionais('Senha: ' + Senha);
    memObservacao.Lines.Clear;

    if Assigned(FJSONDadosAdicionais) then
    begin
      LSenha := Senha;
      LIdPA := PA;

      if FJSONDadosAdicionais.TryGetValue('NOME', LNome) then
        AddListBox_DadosAdicionais('Nome: ' + LNome);

      if FJSONDadosAdicionais.TryGetValue('PRONTUARIO', LProntuario) then
        AddListBox_DadosAdicionais('Prontuário: ' + LProntuario);

      if FJSONDadosAdicionais.TryGetValue('IDPASSAGEM', LPassagem) then
        AddListBox_DadosAdicionais('Passagem: ' + LPassagem);

      if FJSONDadosAdicionais.TryGetValue('TELEFONE', LTelefone) then
        AddListBox_DadosAdicionais('Telefone: ' + FormatarTelefone(LTelefone));

      if FJSONDadosAdicionais.TryGetValue('OBSERVACAO', LObservacao) then
        memObservacao.Text := LObservacao
      else
        memObservacao.Text := '';
    end
    else
    begin
      memObservacao.Text := '';
      LSenha := Senha;
      LIdPA := PA;
    end;

    LDMClient := DMClient(IdUnidade, not CRIAR_SE_NAO_EXISTIR);
    ListBox_TAGs.Items.Clear;

    LDMClient.cdsTags.Filtered := False;

    LcdsTagsClone := TClientDataSet.Create(Self);
    LcdsTagsClone.CloneCursor(LDMClient.cdsTags, True);
    LcdsTagsClone.Open;
    LcdsTagsClone.First;

    {$IFNDEF CompilarPara_TGS}
    while not LcdsTagsClone.Eof do
    begin
      if (IntInArray(LcdsTagsClone.FieldByName('IDgrupo').AsInteger, vgParametrosModulo.GruposTAGSLayoutBotao)) then
      begin
        if (ListBox_TAGs.FindComponent('ListBoxItemGrupo_' + LcdsTagsClone.FieldByName('IDgrupo').AsString) = nil) then
        begin
          LListBoxItem := TListBoxItem.Create(ListBox_TAGs);
          LListBoxItem.Parent := ListBox_TAGs;
          LListBoxItem.Size.Height := 44;
          LListBoxItem.Name := 'ListBoxItemGrupo_' + LcdsTagsClone.FieldByName('IDgrupo').AsString;

          //LGroupBox := TGroupBox(TGroupBox(dmUnidades.FormClient.FListaTAGs.Objects[i]).Clone(LListBoxItem));
          LRectangle := TRectangle.Create(LListBoxItem);
          LRectangle.Parent := LListBoxItem;
          LRectangle.Align := TAlignLayout.Client;
          LRectangle.Stroke.Kind := TBrushKind.None;
          LRectangle.Name := 'rectGrupo_' + LcdsTagsClone.FieldByName('IDgrupo').AsString;

          CriarTAGs(PA, LRectangle);
          //LGroupBox.Parent := LListBoxItem;
        end;
      end
      else
      {$IFDEF CompilarPara_PA_MULTIPA}
      if ((IntInArray(LcdsTagsClone.FieldByName('IDgrupo').AsInteger, vgParametrosModulo.GruposTAGSLayoutLista)) or
         (IntInArray(LcdsTagsClone.FieldByName('IDgrupo').AsInteger, vgParametrosModulo.GruposTAGSSomenteLeitura))) then
      if (FListaTAGs.IndexOf(LcdsTagsClone.FieldByName('Nome').AsString) > -1) then
      {$ENDIF CompilarPara_PA_MULTIPA}

      //{$IFDEF CompilarPara_ONLINE}
      if (IntInArray(LcdsTagsClone.FieldByName('ID').AsInteger, TAGS)) then
      //{$ENDIF CompilarPara_ONLINE}
        AddListBox_TAGs(ListBox_TAGs,
                        LcdsTagsClone.FieldByName('Nome').AsString,
                        LcdsTagsClone.FieldByName('codigocor').AsInteger);

      LcdsTagsClone.Next;
    end;
    {$ENDIF CompilarPara_TGS}
    FreeAndNil(LcdsTagsClone);
  end;
end;

{ TListBtnsTAGs }

procedure TListBtnsTAGs.AddButton(const aBotao: FMX.StdCtrls.TButton);
begin
  SetLength(ListaBotoes, Length(ListaBotoes) + 1);
  ListaBotoes[Length(ListaBotoes) - 1] := aBotao;
end;

constructor TListBtnsTAGs.Create;
begin
  SetLength(ListaBotoes, 0);
  PA := 0;
end;

procedure TFrmDadosAdicionais.DesligarOutrasTAGGrupos(const aIDPA: Integer; const aTagAtual: FMX.StdCtrls.TButton);
var
  i: Integer;
  LSpeedButton: FMX.StdCtrls.TButton;
  OldStaysPressed: Boolean;
  LListBtnsTAGs: TListBtnsTAGs;
begin
  LListBtnsTAGs := ListBtnsTAGs[aIDPA];
  if not Assigned(LListBtnsTAGs) then
    Exit;

  for I := 0 to Length(LListBtnsTAGs.ListaBotoes) - 1 do
  begin
    LSpeedButton              := (LListBtnsTAGs.ListaBotoes[i] as FMX.StdCtrls.TButton);
    //A tag atual e as tags do outro grupo não serão desmarcada
    if (LSpeedButton = aTagAtual) or (LSpeedButton.Parent <> aTagAtual.Parent) then
      Continue;

    OldStaysPressed := LSpeedButton.StaysPressed;
    try
      LSpeedButton.StaysPressed := True;
      LSpeedButton.IsPressed    := False;
      AtualizarIsPressedRetangulo(LSpeedButton);
    finally
      LSpeedButton.StaysPressed := OldStaysPressed;
    end;
  end;
end;

procedure TFrmDadosAdicionais.FormResize(Sender: TObject);
begin
  inherited;

  centralizaGruposTags;
end;

procedure TFrmDadosAdicionais.FormShow(Sender: TObject);
begin
  inherited;

  centralizaGruposTags;
end;

procedure TFrmDadosAdicionais.AtualizarIsPressedRetangulo(const aBotaoTag: FMX.StdCtrls.TButton);
  function GetCircle: TCircle;
  var
    i: Integer;
  begin
    Result := nil;

    for i := 0 to aBotaoTag.ComponentCount -1 do
    begin
      if aBotaoTag.Components[i] is TCircle then
      begin
        Result := TCircle(aBotaoTag.Components[i]);
        Break;
      end;
    end;
  end;

var
  LCircle: TCircle;
begin
  LCircle := GetCircle;
  if not Assigned(LCircle) then
    Exit;

  if not aBotaoTag.IsPressed then
      LCircle.Fill.Kind  := TBrushKind.Gradient
  else
      LCircle.Fill.Kind  := TBrushKind.Solid;
end;

procedure TFrmDadosAdicionais.AtualizarIsPressedRetangulo(const aTag: Integer);
var
  LCircle: TCircle;
begin
  if Assigned( FindComponent('recColorTag_' + IntToStr(aTag))) then
    LCircle := TCircle(FindComponent('recColorTag_' + IntToStr(aTag)));

  if not Assigned(LCircle) then
    Exit;

  //if not aBotaoTag.IsPressed then
  if IntInArray(aTag, TAGs) then
      LCircle.Fill.Kind  := TBrushKind.Gradient
  else
      LCircle.Fill.Kind  := TBrushKind.Solid;
end;

procedure TFrmDadosAdicionais.btnSalvarClick(Sender: TObject);
begin
  if not Assigned(FJSONDadosAdicionais) then
    FJSONDadosAdicionais := TJSONObject.Create;

  if FJSONDadosAdicionais.TryGetValue('OBSERVACAO', LObservacao) then
    FJSONDadosAdicionais.RemovePair('OBSERVACAO');

  FJSONDadosAdicionais.AddPair('OBSERVACAO', Copy(memObservacao.Text, 1, 250));
  DMConnection(IdUnidade, not CRIAR_SE_NAO_EXISTIR).EnviarComando(TAspEncode.AspIntToHex(LIdPA, 4) + Chr($CB) + LSenha + TAB + FJSONDadosAdicionais.ToString, IdUnidade);

  Close;
end;

function TFrmDadosAdicionais.GetListBtnsTAGs(const aIDPA: Integer): TListBtnsTAGs;
var
  LIndex: Integer;
begin
  LIndex := GetIndexPANaListBtnsTAGs(aIDPA);
  Result := nil;
  if ((LIndex > -1) and (LIndex < Length(FListBtnsTAGs))) then
    Result := FListBtnsTAGs[LIndex];
end;

procedure TFrmDadosAdicionais.Image1Click(Sender: TObject);
var
  strAux: string;
begin
  ListBox_DadosAdicionais.ItemIndex := TListBoxItem(TImage(Sender).Parent).Index;

  strAux := ListBox_DadosAdicionais.Items[ListBox_DadosAdicionais.ItemIndex];
  Clipboard.AsText := Copy(strAux, Pos(': ', strAux)+2, Length(strAux));
end;

procedure TFrmDadosAdicionais.Timer1Timer(Sender: TObject);
begin
  inherited;

  centralizaGruposTags;
end;

function TFrmDadosAdicionais.GetIndexPANaListBtnsTAGs(const aIDPA: Integer): Word;
var
  i: Integer;
begin
  for i := 0 to Length(FListBtnsTAGs) -1 do
  begin
    if ((FListBtnsTAGs[i] <> nil) and (FListBtnsTAGs[i].PA = aIDPA)) then
    begin
      Result := i;
      Exit;
    end;
  end;

  SetLength(FListBtnsTAGs, Length(FListBtnsTAGs) +1);
  Result := Length(FListBtnsTAGs) -1;
  FListBtnsTAGs[Result]     := TListBtnsTAGs.Create;
  FListBtnsTAGs[Result].PA  := aIDPA;
end;

end.
