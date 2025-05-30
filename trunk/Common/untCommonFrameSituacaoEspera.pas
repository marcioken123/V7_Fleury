unit untCommonFrameSituacaoEspera;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  {$IFNDEF IS_MOBILE}
  Windows, Messages, ScktComp,
  {$ENDIF}
  FMX.Grid, FMX.Controls, FMX.Graphics,
  FMX.Dialogs, FMX.StdCtrls, FMX.ExtCtrls, FMX.Types, FMX.Layouts, FMX.ListView.Types,
  FMX.ListView, FMX.ListBox, System.Threading,
  FMX.Bind.DBEngExt, FMX.Bind.Grid, System.Bindings.Outputs, FMX.Bind.Editors,
  FMX.Objects, FMX.Edit, FMX.TabControl, uCriadorFila,

  System.UIConsts, System.Generics.Defaults, System.Generics.Collections,
  System.UITypes, System.Types, System.SysUtils, System.Classes, System.Variants, DB, DBClient, System.Rtti,
  Data.Bind.EngExt, Data.Bind.Components,
  Data.Bind.Grid, Data.Bind.DBScope,
  MyAspFuncoesUteis, FMX.Platform.Win, FMX.Forms,
  untCommonFrameBase, Math, DateUtils,
  FMX.Controls.Presentation, System.ImageList, FMX.ImgList, FMX.Menus,
  FMX.Effects, untCommonDMClient, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.FMXUI.Wait,
  FireDAC.Comp.Client, FireDAC.Phys.SQLiteVDataSet, FMX.Header, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, IdContext, IdHeaderList;

const
  // COL_IDFILA       = 0;
  COL_SENHA = 0;
  COL_NOME  = 1;
  COL_HORA  = 2;
  // COL_DATAHORA     = 4;
  COL_COR_LINHA           = 3;
  COL_PRIMEIRA_TAG        = 4;
  WIDTH_COLS_TAGS         = 10;
  StrLinkGridToDataSource = 'LinkGridToDataSource';

type
  TDisposicaoDasFilas = record
    Linhas, Colunas: Integer;
  end;

  TFraSituacaoEspera = class(TFrameBase)
    pnlTecladoTouch: TPanel;
    btnTecladoTouch_1: TButton;
    btnTecladoTouch_2: TButton;
    btnTecladoTouch_3: TButton;
    btnTecladoTouch_4: TButton;
    btnTecladoTouch_5: TButton;
    btnTecladoTouch_6: TButton;
    btnTecladoTouch_7: TButton;
    btnTecladoTouch_8: TButton;
    btnTecladoTouch_9: TButton;
    btnTecladoTouch_0: TButton;
    btnTecladoTouch_Back: TButton;
    btnTecladoTouch_Close: TButton;
    btnTecladoTouch_OK: TButton;
    tbcEspera: TTabControl;
    imgPriorPage: TImage;
    btnNextPage: TButton;
    imgNextPage: TImage;
    btnPriorPage: TButton;
    imgAtalhos: TImageList;
    lytRodape: TLayout;
    tmrAtualizaHorario: TTimer;
    FDConnection1: TFDConnection;
    FDLocalSQL1: TFDLocalSQL;
    IdHTTP1: TIdHTTP;

    procedure SenhasList1ApplyStyleLookup(Sender: TObject);
    procedure SenhaEdit1Enter(Sender: TObject);

    procedure InsertSenhaButton1Click(Sender: TObject);
    procedure SenhaEdit1Change(Sender: TObject);

    procedure SenhaMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure BitBtn1Click(Sender: TObject);
    procedure PrioritaryList1Click(Sender: TObject);
    procedure btnTecladoTouch_CloseClick(Sender: TObject);
    procedure btnTecladoTouch_1Click(Sender: TObject);
    procedure btnTecladoTouch_BackClick(Sender: TObject);
    procedure btnTecladoTouch_OKClick(Sender: TObject);
    procedure btnNextPageClick(Sender: TObject);
    procedure btnPriorPageClick(Sender: TObject);
    procedure tbcEsperaChange(Sender: TObject);
    procedure tmrAtualizaHorarioTimer(Sender: TObject);
    procedure FDQueryCalcFields(DataSet: TDataSet);
  private
    FLayoutFila: TLayoutFila;

    function FormataNomeGridPanelLayout(ATabItem: TTabItem): String;
    procedure AtualizarBotoesRodape;
    procedure OnSenhaAfterOpen(ADataset: TDataset);
    procedure RedesenharFila(ADataset: TDataset);
    procedure HeadersAvailable(Sender: TObject; AHeaders: TIdHeaderList;
      var VContinue: Boolean);
    procedure carregaImagem(idFila: integer; imagemFila: TImage;
      LLayoutTopBase: TLayout);
  protected
    FFilasCriadas       : Array of Integer;
    FFilasLimiarAmarelo : TDictionary<Integer, string>;
    FFilasLimiarVermelho: TDictionary<Integer, string>;
    FFilasLimiarLaranja : TDictionary<Integer, string>;
    FFilasClientDataSet : TObjectDictionary<Integer, TClientDataSet>;
    FFDQuery            : TObjectDictionary<Integer, TFDQuery>;
    vDMClient           : TDMClient;
    function ExisteOBitBtn(const FilaNo: Integer): Boolean;
    procedure AtualizaLabelQtdeSenha(poDataSetSenha: TDataSet);
    procedure UpdateColunasGrid(const Fila: Integer);
    function AddTabItem: TTabItem;
    function GetDataSetOfLinkGrid(const aLinkGridToDataSource: TLinkGridToDataSource): TDataSet; Override;
    procedure SetVisible(const aValue: Boolean); Override;
    procedure DoResizeCard(Sender: TObject);
  public
    procedure SetListBlocked(Fila: Integer; Check: Boolean);
    procedure SetPrioritaryList(Fila: Integer; Check: Boolean);
    function FindComponent(const AName: string; const aFindInSubComponent: Boolean = False): TComponent;
    constructor Create(ower: TComponent); Override;
    function FormataNomeComponente(const aNomeComponente: String; const aFila: Integer): String; Virtual;
    function GetComponenteFila(const aNome: String; const aCodFila: Integer): TComponent;
    function GetComponenteFilaEdt(const aNome: String; const aCodFila: Integer): TEdit;
    function GetComponenteFilaRec(const aNome: String; const aCodFila: Integer): TRectangle;
    function GetComponenteFilaLabel(const aNome: String; const aCodFila: Integer): TLabel;
    function GetComponenteFilaCDS(const aNome: String; const aCodFila: Integer): TClientDataSet;
    function GetComponenteFilaBtn(const aNome: String; const aCodFila: Integer): TButton;
    procedure AtualizarPropriedade(NomePropriedade, NomeComponente: string; ValorPropriedade: Variant; PA: Integer);
    function LerPropriedade(const aNomePropriedade, aNomeComponente: string; const aValorPadrao: Variant; const aFila: Integer): Variant;

    procedure InsertPswd(const Fila, Pswd, Prontuario: Integer; const NomeCliente: string; const PswdDateTime: TDateTime; const Tags: TIntegerDynArray;
      const Posit: Integer; const aCanRefreshGrid: Boolean = True);

    procedure RefreshGrid(const aFila: Integer);
    procedure AtualizaNomeCliente(const aFila, aSenha: Integer; const aNome: string);
    procedure RefreshAllGrids;
    function CriaComponenteFila(FilaNo: Integer; FilaNome: string; Cor: Integer;
      LimiarAmarelo, LimiarVermelho, LimiarLaranja, FonteNome: string): Boolean;
    function ExisteAFila(const Fila: Integer): Boolean;
    function FilaEhPermitida(const Fila: Integer): Boolean;
    procedure LimpaFila(const Fila: Integer);
    procedure CarregarParametrosDB; Override;
    procedure CarregarParametrosINI; Override;
    function verificaLimiar(hora: string; Fila: Integer): Integer;
    procedure AtivaLocalSQL(Fila: Integer);
    function TamanhoDaFonte: Integer;
    procedure ListBoxItemOnDblClick(Sender: TObject);
  end;

function FraSituacaoEspera(const aIDUnidade: Integer; const aAllowNewInstance: Boolean = False; const aOwner: TComponent = nil): TFraSituacaoEspera;

const
  COLUNA_DESCTAG       = 'DESCTAG';
  COLUNA_CORTAG        = 'CORTAG';
  cgMAXFILAS           = 99;
  StrSenhasCountLabel  = 'SenhasCountLabel';
  StrFilaLabel         = 'FilaLabel';
  StrShape             = 'Shape';
  StrCdsSenhas         = 'cdsSenhas';
  StrDsSenhas          = 'dsSenhas';
  StrLabel             = 'Label';
  StrInserirSenha      = 'BitBtn';
  StrSenhaEdit         = 'SenhaEdit';
  StrRecSenhaEdit      = 'RecSenhaEdit';
  StrInsertSenhaButton = 'InsertSenhaButton';
  StrListBlocked       = 'ListBlocked';
  StrPrioritaryList    = 'PrioritaryList';
  StrSenhasList        = 'GridSenhasList';
  StrBindSourceDB      = 'BindSourceDB';
  StrBindingsList      = 'BindingsList';
  StrGridPanelLayout   = 'GridPanelLayout';

implementation

uses
  untCommonDMConnection,
  Sics_Common_Parametros,
  untSicsOnLine,
  untCommonDMUnidades,
  uConstsCriacaoFilas,
  untCommonFormDadosAdicionais,
  System.JSON;

{$R *.fmx}

function FraSituacaoEspera(const aIDUnidade: Integer; const aAllowNewInstance: Boolean = False; const aOwner: TComponent = nil): TFraSituacaoEspera;
begin
  Result := TFraSituacaoEspera(TFraSituacaoEspera.GetInstancia(aIDUnidade, aAllowNewInstance, aOwner));
end;

procedure GetSendClicarBotaoGerarSenhaText(const aFila, aIDUnidade: Integer; var s: string);
begin
  if vgParametrosModulo.ImpressoraComandada >= 0 then
    s := IntToHex(aFila, 4) + IntToHex(vgParametrosModulo.ImpressoraComandada, 4);
end;

procedure GetSendExcluirSenhaText(Senha: Integer; var s: string);
begin
  s := IntToStr(Senha);
end;

procedure GetSendInserirSenhaText(Fila, Senha: Integer; var s: string);
begin
  s := IntToHex(Fila, 4) + IntToStr(Senha);
end;

procedure GetSendReimprimirSenhaText(const aSenha, aIDUnidade: Integer; var s: string);
begin
  s := IntToStr(aSenha) + ';' + IntToHex(vgParametrosModulo.ImpressoraComandada, 4);
end;

procedure GetSendClicarCheckBoxPrioritariaOuBloquearText(Fila: Integer; TipoCheckBox: string; Estado: Boolean; var s: string);
begin
  s := IntToHex(Fila, 4);
  if Pos('Block', TipoCheckBox) > 0 then
    s := s + 'B'
  else
    s := s + 'P';
  if Estado then
    s := s + '1'
  else
    s := s + '0';
end;

procedure TFraSituacaoEspera.AtivaLocalSQL(Fila: Integer);
var
  I: Integer;
begin
  if(ExisteAFila(Fila))then
  begin
    if (FDLocalSQL1.DataSets.Count > 0) then
    begin
      FDLocalSQL1.Active := False;
      FDLocalSQL1.Active := True;
      if (FFDQuery.Items[Fila].State in [dsInactive]) then
      begin
        if ((FFilasClientDataSet.Items[Fila].State in [dsBrowse]) and (FFilasClientDataSet.Items[Fila].RecordCount > 0)) then
          FFDQuery.Items[Fila].Open();
      end
      else
        FFDQuery.Items[Fila].Refresh;
    end;
  end;
end;

procedure TFraSituacaoEspera.AtualizaLabelQtdeSenha(poDataSetSenha: TDataSet);
var
  LLabel: TLabel;
begin
  LLabel := GetComponenteFilaLabel(StrSenhasCountLabel, poDataSetSenha.Tag);
  if Assigned(LLabel) then
    LLabel.Text := IntToStr(poDataSetSenha.RecordCount);
end;

procedure TFraSituacaoEspera.AtualizaNomeCliente(const aFila, aSenha: Integer; const aNome: string);
begin
  if FFDQuery[aFila].Locate('SENHA', aSenha, []) then
  begin
    FFDQuery[aFila].Edit;
    FFDQuery[aFila].FieldByName('NOMECLIENTE').AsString := aNome;
    FFDQuery[aFila].Post;
  end;

  RefreshGrid(aFila);
end;

procedure TFraSituacaoEspera.AtualizarPropriedade(NomePropriedade, NomeComponente: string; ValorPropriedade: Variant; PA: Integer);
var
  Componente: TComponent;
begin
  Componente := GetComponenteFila(NomeComponente, PA);
  AspAtualizarPropriedade(nil, Componente, NomePropriedade, ValorPropriedade);
end;

procedure TFraSituacaoEspera.BitBtn1Click(Sender: TObject);
var
  Aux       : string;
  LComponent: TControl;
begin
  if (Sender is TControl) then
  begin
    LComponent := TControl(Sender);
    if ExisteOBitBtn(LComponent.Tag) then
    begin
      GetSendClicarBotaoGerarSenhaText(LComponent.Tag, IDunidade, Aux);
      DMConnection(IDunidade, not CRIAR_SE_NAO_EXISTIR).EnviarComando(cProtocoloPAVazia + Chr($70) + Aux, IDunidade, '', True);
      Application.ProcessMessages;
    end;
  end;

end;

procedure TFraSituacaoEspera.btnNextPageClick(Sender: TObject);
begin
  inherited;
  tbcEspera.Next;
end;

procedure TFraSituacaoEspera.btnPriorPageClick(Sender: TObject);
begin
  tbcEspera.Previous;
end;

procedure TFraSituacaoEspera.btnTecladoTouch_1Click(Sender: TObject);
var
  LSenhaEdit: TEdit;
begin
  inherited;
  LSenhaEdit := GetComponenteFilaEdt(StrSenhaEdit, pnlTecladoTouch.Tag);
  if Assigned(LSenhaEdit) then
  begin
    with LSenhaEdit do
    begin
      Text     := Text + (Sender as TButton).Text;
      SelStart := Length(Text);
    end;
  end;
end;

procedure TFraSituacaoEspera.btnTecladoTouch_BackClick(Sender: TObject);
var
  LEdtSenhaEdit: TEdit;
begin
  inherited;
  LEdtSenhaEdit := GetComponenteFilaEdt(StrSenhaEdit, pnlTecladoTouch.Tag);
  if Assigned(LEdtSenhaEdit) then
  begin
    with LEdtSenhaEdit do
    begin
      if SelLength = Length(Text) then
        Text := ''
      else
        Text := Copy(Text, 1, Length(Text) - 1);

      SelStart := Length(Text);
    end;
  end;
end;

procedure TFraSituacaoEspera.btnTecladoTouch_CloseClick(Sender: TObject);
var
  LRecSenhaEdit: TRectangle;
begin
  inherited;
  LRecSenhaEdit := GetComponenteFilaRec(StrRecSenhaEdit, (Sender as TControl).Tag);
  if Assigned(LRecSenhaEdit) then
    LRecSenhaEdit.Fill.Color := claBtnFace;

  pnlTecladoTouch.Visible := False;
end;

procedure TFraSituacaoEspera.btnTecladoTouch_OKClick(Sender: TObject);
var
  LBtnInsertSenhaButton: TButton;
begin
  inherited;
  LBtnInsertSenhaButton := GetComponenteFilaBtn(StrInsertSenhaButton, pnlTecladoTouch.Tag);
  if Assigned(LBtnInsertSenhaButton) then
    LBtnInsertSenhaButton.OnClick(LBtnInsertSenhaButton);

end;

procedure TFraSituacaoEspera.CarregarParametrosDB;
begin
  inherited;
  self.FrameResize(self);
end;

procedure TFraSituacaoEspera.CarregarParametrosINI;
begin
  inherited;
  self.FrameResize(self);
end;

constructor TFraSituacaoEspera.Create(ower: TComponent);
begin
  inherited;
  SetLength(FFilasCriadas, 0);
  self.OnResize           := FrameResize;
  pnlTecladoTouch.Visible := False;
end;

procedure TFraSituacaoEspera.AtualizarBotoesRodape;
begin
  btnNextPage.Visible  := tbcEspera.TabIndex < tbcEspera.TabCount - 1;
  btnPriorPage.Visible := tbcEspera.TabIndex > 0;
end;

procedure TFraSituacaoEspera.carregaImagem(idFila : integer; imagemFila: TImage;
  LLayoutTopBase: TLayout);
var
  lHttp: TidHttp;
  LStream: TMemoryStream;
  LUrl: String;
  LAlinhamento: Integer;
begin
  LUrl := 'http://' +
          vgParametrosSicsClient.TCPSrvAdr + ':' +
          vgParametrosModulo.PortaServidorArquivos.ToString +
          '/imagens/fila/' +
          idFila.ToString;
  try
    LStream := TMemoryStream.Create;
    try
      lHttp := TIdHTTP.Create(nil);
      try
        lHttp.OnHeadersAvailable := HeadersAvailable;
        lHttp.Get(LUrl, LStream);
        LAlinhamento := lHttp.Tag;
      finally
        lHttp.Free;
      end;
         LStream.Position := 0;
       if LStream.Size > 0  then
       begin
         //TThread.Queue(nil,
           //procedure
           //begin
             imagemFila := TImage.Create(LLayoutTopBase);
             imagemFila.Align:= TAlignLayout.Client;
             with imagemFila do
             begin
               Name:= 'ImagemFila'+ IntToStr(idFila);   
               imagemFila.Bitmap.LoadFromStream(LStream);
               TThread.Synchronize(nil,
               procedure
               begin
                    LLayoutTopBase.Visible:=True;
                    Parent := LLayoutTopBase;
               end);

               if (LAlinhamento = 0) then
               begin
                 LLayoutTopBase.Align := TAlignLayout.MostRight;
               end
               else
               begin
                 LLayoutTopBase.Align := TAlignLayout.MostLeft;
               end;
               LLayoutTopBase.Width := TControl(LLayoutTopBase.Parent).Width / 4;
               WrapMode := TImageWrapMode.Fit;

              end
          //end);
       end;
    finally
      LStream.Free;
    end;
  except on E: Exception do
    begin
     E.Message := 'Não foi possivel criar a imagem da fila.  '+ #13 + e.Message;
     TThread.Queue(nil,
       procedure
       begin
         MyLogException(E);
       end);
     end;
  end;
end;

function TFraSituacaoEspera.CriaComponenteFila(FilaNo: Integer; FilaNome: string; Cor: Integer;
  LimiarAmarelo, LimiarVermelho, LimiarLaranja, FonteNome: string): Boolean;
var
  lblShape                                         : TShape;
  lblFila                                          : TLabel;
  lblSenhasCountLabel                              : TLabel;
  lblStrFilaLabel                                  : TLabel;
  btnInserirSenha                                  : TButton;
  btnInsertSenhaButton                             : TButton;
  edtSenhaEdit                                     : TEdit;
  chkListBlocked                                   : TCheckBox;
  chkPrioritaryList                                : TCheckBox;
  //LGridSenhasList                                  : TGrid;
  LVertScrollBox                                   : TVertScrollBox;
  ShowButton                                       : Boolean;
  ShowBlocked                                      : Boolean;
  ShowPriority                                     : Boolean;
  ShowInsert                                       : Boolean;
  AllowDelete                                      : Boolean;
  LDataSourceSenha                                 : TDataSource;
  LDataSetSenha                                    : TClientDataSet;
  LBindSourceDB                                    : TBindSourceDB;
  LImageFAtalho                                    : TImage;
  LFDQuery                                         : TFDQuery;
  LFieldTempoEspera, LFieldSenha, LFieldNomeCLiente: TField;
  LFieldCorLinha                                   : TIntegerField;
  LFieldProntuario                                 : TIntegerField;
  aField                                           : TField;
  I                                                : Integer;
  TamanhoNomeFila, NegritoNomeFila, ItalicoNomeFila, SublinhadoNomeFila, CorNomeFila: string;
  bitmap: TBitmap;
  recFundo: TRectangle;

  function GetTabItem: TTabItem;
  var
    MaximoSituacaoPorTab: Integer;
  begin
    if (tbcEspera.TabCount = 0) then
    begin
      Result     := AddTabItem;
      Result.Tag := 1;
      Exit;
    end;

    Result               := tbcEspera.Tabs[tbcEspera.TabCount - 1];
    MaximoSituacaoPorTab := (Max(vgParametrosModulo.LinhasDeFilas, 1) * Max(vgParametrosModulo.ColunasdeFilas, 1));
    if (MaximoSituacaoPorTab <= Result.Tag) then
    begin
      Result     := AddTabItem;
      Result.Tag := 1;
    end
    else
      Result.Tag := Result.Tag + 1;
  end;

var
  LTabItemOwner          : TTabItem;
  LLinkGridToDataSource  : TLinkGridToDataSource;
  LLayout, LLayoutAgrupar,LLayoutTopBase,LLayoutImage: TLayout;
  LDMClient              : TDMClient;

const
  OFF = 4;
begin
  LDMClient := DMClient(IDunidade, not CRIAR_SE_NAO_EXISTIR);

  ShowButton   := ((ExisteNoIntArray(FilaNo, vgParametrosModulo.MostrarBotaoNasFilas)) and (vgParametrosModulo.ImpressoraComandada >= 0));
  ShowBlocked  := ExisteNoIntArray(FilaNo, vgParametrosModulo.MostrarBloquearNasFilas);
  ShowPriority := ExisteNoIntArray(FilaNo, vgParametrosModulo.MostrarPrioritariaNasFilas);
  ShowInsert   := ExisteNoIntArray(FilaNo, vgParametrosModulo.PermitirInclusaoNasFilas);
  AllowDelete  := ExisteNoIntArray(FilaNo, vgParametrosModulo.PermitirExclusaoNasFilas);

  if FilaNo > vgParametrosModulo.MaiorFilaCadastrada then
    vgParametrosModulo.MaiorFilaCadastrada := FilaNo;

  try
    SetLength(FFilasCriadas, Length(FFilasCriadas) + 1);
    FFilasCriadas[Length(FFilasCriadas) - 1] := FilaNo;

    if (vgParametrosModulo.MostrarTempoDecorridoEspera) then
    begin
      if (not Assigned(FFilasLimiarAmarelo)) then
        FFilasLimiarAmarelo := TDictionary<Integer, string>.Create;

      if (not Assigned(FFilasLimiarVermelho)) then
        FFilasLimiarVermelho := TDictionary<Integer, string>.Create;

      if (not Assigned(FFilasLimiarLaranja)) then
        FFilasLimiarLaranja := TDictionary<Integer, string>.Create;

      FFilasLimiarAmarelo.Add(FilaNo, LimiarAmarelo);
      FFilasLimiarVermelho.Add(FilaNo, LimiarVermelho);
      FFilasLimiarLaranja.Add(FilaNo, LimiarLaranja);
    end;
    LTabItemOwner := GetTabItem;
    lblShape      := TRectangle.Create(LTabItemOwner);
    with lblShape do
    begin
      Parent         := LTabItemOwner.FindComponent(FormataNomeGridPanelLayout(LTabItemOwner)) as TGridPanelLayout;
      Align          := TAlignLayout.Client;
      Margins.Top    := 0;
      Margins.Left   := 0;
      Margins.Right  := 0;
      Margins.Bottom := 0;
      Name           := StrShape + IntToStr(FilaNo);
      if Cor <> 0 then
        Fill.Color := TAlphaColor(RGBtoBGR(Cor) or $FF000000);
      Tag          := FilaNo;
    end;

    LLayoutTopBase := TLayout.Create(lblShape);
    with LLayoutTopBase do
    begin
      OnResize:= DoResizeCard;
      Parent := lblShape;
      Align := TAlignLayout.Top;
      Height := 0;
    end;

    LLayoutImage:= TLayout.Create(LLayoutTopBase);
    LLayoutImage.Parent := LLayoutTopBase;
    LLayoutImage.ClipChildren:=True;
    LLayoutImage.Name:='LayoutImage'+ IntToStr(FilaNo);
    LLayoutImage.Margins.Top:=2;
    LLayoutImage.Margins.Bottom:=2;
    LLayoutImage.Margins.Left:=2;
    LLayoutImage.Margins.Right:=2;
    LLayoutImage.Visible:=False;

    {$REGION '//Carrega a imagem em background e ajusta seu tamanho'}
    if vgParametrosModulo.ExibirImagem then
    begin
      //LLayoutTopBase.Height:=25;
      TTask.Run(
        procedure
        var
          imagemFila: TImage;
        begin
          try
            imagemFila := nil;
            carregaImagem(FilaNo, ImagemFila, LLayoutImage);
          except
          end;
        end
      );
    end;
    {$ENDREGION}

    {$REGION '//Primeira Linha da tela - lblFila e lblSenhasCountLabel'}
    // *** Layout para a primeira linha: lblFila e lblSenhasCountLabel
    LLayout        := TLayout.Create(LLayoutTopBase);
    LLayout.Parent := LLayoutTopBase;
    LLayout.Align  := TAlignLayout.Top;
    LLayout.Height := 15 * TamanhoDaFonte;
    LLayoutTopBase.Height := LLayoutTopBase.Height + LLayout.Height;
    lblFila        := TLabel.Create(LLayout);
    with lblFila do
    begin
      Parent                 := LLayout;
      Align                  := TAlignLayout.Client;
//      Margins.Top            := OFF;
      Margins.Left           := OFF;
      Name                   := StrLabel + IntToStr(FilaNo);
      Text                   := 'Fila ' + IntToStr(FilaNo) + ':';
      TextSettings.Font.Size := TextSettings.Font.Size * TamanhoDaFonte;
      TextSettings.VertAlign := TTextAlign.Leading;
      StyledSettings         := StyledSettings - [TStyledSetting.Size];
      Tag                    := FilaNo;
    end;

    lblSenhasCountLabel := TLabel.Create(LLayout);
    with lblSenhasCountLabel do
    begin
      Parent                 := LLayout;
      Align                  := TAlignLayout.Right;
      Margins.Right          := OFF;
//      Margins.Top            := OFF;
      Name                   := StrSenhasCountLabel + IntToStr(FilaNo);
      Text                   := '0';
      TextSettings.HorzAlign := TTextAlign.Trailing;
      TextSettings.VertAlign := TTextAlign.Leading;
      TextSettings.Font.Size := TextSettings.Font.Size * TamanhoDaFonte;
      TextSettings.WordWrap  := false;
      TextSettings.Trimming  := TTextTrimming.None;
      StyledSettings         := StyledSettings - [TStyledSetting.Size];
      Width                  := 40;
      AutoSize               := false;
      Tag                    := FilaNo;
    end;

    // *** FIM Layout para a primeira linha: lblFila e lblSenhasCountLabel
    {$ENDREGION}
    {$REGION '//Segunda Linha da tela - lblStrFilaLabel'}
    // *** Layout para a segunda linha: lblStrFilaLabel
    LLayout             := TLayout.Create(LLayoutTopBase);
    LLayout.Parent      := LLayoutTopBase;
    //LLayout.Padding.Top := OFF;
    //LLayout.Margins.Top := OFF;
    LLayout.Position.Y  := Screen.Height;
    LLayout.Align       := TAlignLayout.Top;


    TamanhoNomeFila    := '$' + Copy(FonteNome, 1, 4);
    NegritoNomeFila    := Copy(FonteNome, 5, 1);
    ItalicoNomeFila    := Copy(FonteNome, 6, 1);
    SublinhadoNomeFila := Copy(FonteNome, 7, 1);
    CorNomeFila        := '$' + Copy(FonteNome, 8, 6);

    lblStrFilaLabel := TLabel.Create(lblShape);
    with lblStrFilaLabel do
    begin
      Parent                 := LLayout;
      Align                  := TAlignLayout.Client;
      Name                   := StrFilaLabel + IntToStr(FilaNo);
      Text                   := FilaNome;
      TextSettings.HorzAlign := TTextAlign.Center;
      TextSettings.VertAlign  := TTextAlign.Leading;

      if (NegritoNomeFila = 'T') then
        TextSettings.Font.Style := TextSettings.Font.Style + [TFontStyle.fsBold];
      if (ItalicoNomeFila = 'T') then
        TextSettings.Font.Style := TextSettings.Font.Style + [TFontStyle.fsItalic];
      if (SublinhadoNomeFila = 'T') then
        TextSettings.Font.Style := TextSettings.Font.Style + [TFontStyle.fsUnderline];

      if (vgParametrosModulo.TamanhoFonteFile > 0) and (not vgParametrosModulo.FontePadrao) then
         TextSettings.Font.Size:=vgParametrosModulo.TamanhoFonteFile
      else if (strtoInt(TamanhoNomeFila) > 0) then
        TextSettings.Font.Size := ifthen(vgParametrosModulo.FontePadrao,12, strtoInt(TamanhoNomeFila) )
      else
        TextSettings.Font.Size := 12;

      TextSettings.FontColor := TAlphaColor(RGBtoBGR(strtoInt(CorNomeFila)) or $FF000000);

      StyledSettings := StyledSettings - [TStyledSetting.Size, TStyledSetting.Style, TStyledSetting.FontColor];
      Tag            := FilaNo;
    end;
    LLayout.Height :=1.35*lblStrFilaLabel.TextSettings.Font.Size;
    LLayoutTopBase.Height := LLayoutTopBase.Height + LLayout.Height;
(*
    if ExisteNoIntArray(FilaNo, vgParametrosModulo.MostrarBotaoNasFilas)then
    begin
      bitmap := TBitmap.Create;
      try
        bitmap.Canvas.Font.Size  := lblStrFilaLabel.Font.Size;
        bitmap.Canvas.Font.Style := lblStrFilaLabel.Font.Style;
        LLayout.Height           := bitmap.Canvas.TextHeight(FilaNome) + 10;
        LLayout.Margins.Bottom   := 20;
//        LLayoutTopBase.Height := LLayoutTopBase.Height + LLayout.Height;
      finally
        bitmap.Free;
      end;
    end;
*)



//    LLayoutTopBase.Height := LLayoutTopBase.Height + LLayout.Height + 20;

//    LLayoutTopBase.Height := 20 + LLayout.Height;

    // *** FIM Layout para a segunda linha: lblStrFilaLabel

    {$ENDREGION}
    {$REGION '//Terceira Linha da tela - btnInserirSenha'}
    // *** Layout para a terceira linha: btnInserirSenha
    LLayout            := TLayout.Create(LLayoutTopBase);
    LLayout.Parent     := LLayoutTopBase;
    LLayout.Position.Y := Screen.Height;
    LLayout.Align      := TAlignLayout.Top;
    LLayout.Height     := 25;
    //LLayout.Padding.Top := OFF;
    //LLayout.Margins.Top := OFF;
//    btnInserirSenha    := TButton.Create(lblShape);
    btnInserirSenha    := TButton.Create(LLayout);
    with btnInserirSenha do
    begin
      Parent      := LLayout;
      Align       := TAlignLayout.Center;
//      ControlType := TControlType.Platform;
      //Align       := TAlignLayout.Top;
      Name        := StrInserirSenha + IntToStr(FilaNo);
      Text        := '';
      Height      := 24;
      Width       := 24;
//      Images      := imgAtalhos;
      Visible     := ShowButton;
      OnClick     := BitBtn1Click;
      StyleLookup := 'additembutton';
      Cursor      := crHandPoint;
      Tag         := FilaNo;
    end;

    LImageFAtalho         := TImage.Create(btnInserirSenha);
    LImageFAtalho.Align   := TAlignLayout.Client;
    LImageFAtalho.Parent  := btnInserirSenha;
    LImageFAtalho.HitTest := False;
    LImageFAtalho.bitmap.Assign(imgAtalhos.Source.Items[0].MultiResBitmap[0].bitmap);
    LLayout.Visible := ShowButton;

    if(LLayout.Visible)then
      LLayoutTopBase.Height := LLayoutTopBase.Height + LLayout.Height;
    // *** FIM Layout para a terceira linha: btnInserirSenha
    {$ENDREGION}
    {$REGION '//Quarta Linha da tela - edtSenhaEdit e btnInsertSenhaButton'}
    // *** Layout para a quarta linha: edtSenhaEdit e btnInsertSenhaButton
    LLayout            := TLayout.Create(LLayoutTopBase);
    LLayout.Parent     := LLayoutTopBase;
    LLayout.Position.Y := Screen.Height;
    LLayout.Align      := TAlignLayout.Top;
    LLayout.Height     := 25;
    LLayoutTopBase.Height := LLayoutTopBase.Height + LLayout.Height;

    LLayoutAgrupar        := TLayout.Create(LLayout);
    LLayoutAgrupar.Parent := LLayout;
    LLayoutAgrupar.Height := 22;
    LLayoutAgrupar.Width  := 40 + OFF + 40; // largura do Edit e do Botão com espaçam.(5)

    edtSenhaEdit := TEdit.Create(lblShape);
    with edtSenhaEdit do
    begin
      Parent      := LLayoutAgrupar;
      ControlType := TControlType.Styled;
      //Position.X  := OFF;
      Position.X  := 0;
      Name        := StrSenhaEdit + IntToStr(FilaNo);
      Height      := 20;
      Width       := 40;
      Text        := '';
      Visible     := ShowInsert;
      OnEnter     := SenhaEdit1Enter;
      // OnExit           := SenhaEdit1Exit;
      OnChangeTracking := SenhaEdit1Change;
      { // ??      OnClick    := SenhaEdit1Click; } // >>> já estava comentado
      Tag := FilaNo;
    end;

    btnInsertSenhaButton := TButton.Create(lblShape);
    with btnInsertSenhaButton do
    begin
      Parent     := LLayoutAgrupar;
      Position.X := edtSenhaEdit.Width + OFF;
      ControlType := TControlType.Styled;
      Name       := StrInsertSenhaButton + IntToStr(FilaNo);
      Text       := 'Inserir';
      Height     := 20;
      Width      := 40;
      Enabled    := False;
      Visible    := ShowInsert;
      OnClick    := InsertSenhaButton1Click;
      Tag        := FilaNo;
    end;
    LLayoutAgrupar.Align := TAlignLayout.Center;
    LLayout.Visible      := ShowInsert;
    if LLayout.Visible then
      LLayoutTopBase.Height := LLayoutTopBase.Height + LLayout.Height;
    // *** FIM Layout para a quarta linha: edtSenhaEdit e btnInsertSenhaButton

    {$ENDREGION}
    {$REGION '//Quinta Linha da tela - chkListBlocked'}
    // *** Layout para a quinta linha: chkListBlocked
    LLayout            := TLayout.Create(LLayoutTopBase);
    LLayout.Parent     := LLayoutTopBase;
    LLayout.Position.Y := Screen.Height;
    LLayout.Align      := TAlignLayout.Top;
    LLayout.Height := 22 * TamanhoDaFonte;

    chkListBlocked := TCheckBox.Create(lblShape);
    with chkListBlocked do
    begin
      Parent := LLayout;
      Name   := StrListBlocked + IntToStr(FilaNo);
      Text   := 'Bloquear';
      Height := 18 * TamanhoDaFonte;
      Width                  := 75 * TamanhoDaFonte;
      Align                  := TAlignLayout.Center;
      Visible                := ShowBlocked;
      OnChange               := PrioritaryList1Click;
      Tag                    := FilaNo;
      TextSettings.Font.Size := TextSettings.Font.Size * TamanhoDaFonte;
      StyledSettings         := StyledSettings - [TStyledSetting.Size];
    end;
    LLayout.Visible := ShowBlocked;
    if(LLayout.Visible)then
      LLayoutTopBase.Height := LLayoutTopBase.Height + LLayout.Height;
    // *** FIM Layout para a quinta linha: chkListBlocked

    {$ENDREGION}
    {$REGION '//Sexta Linha da tela - chkPrioritaryList'}
    // *** Layout para a quinta linha: chkPrioritaryList
    LLayout            := TLayout.Create(LLayoutTopBase);
    LLayout.Parent     := LLayoutTopBase;
    LLayout.Position.Y := Screen.Height;
    LLayout.Align      := TAlignLayout.Top;
    LLayout.Height     := 22 * TamanhoDaFonte;
    LLayout.Visible    := ShowPriority;

    chkPrioritaryList := TCheckBox.Create(lblShape);
    with chkPrioritaryList do
    begin
      Parent := LLayout;
      Name   := StrPrioritaryList + IntToStr(FilaNo);
      Text   := 'Prioritária';
      Height := 18 * TamanhoDaFonte;
      Width                := 75 * TamanhoDaFonte;
      Align                  := TAlignLayout.Center;
      Visible                := ShowPriority;
      OnChange               := PrioritaryList1Click;
      Tag                    := FilaNo;
      TextSettings.Font.Size := TextSettings.Font.Size * TamanhoDaFonte;
      StyledSettings         := StyledSettings - [TStyledSetting.Size];
    end;

    if LLayout.Visible then
      LLayoutTopBase.Height := LLayoutTopBase.Height + LLayout.Height;

    // *** FIM Layout para a sexta linha: chkListBlocked

    {$ENDREGION}
    {$REGION '//ScrollBox Base para os itens das filas, no layout apropriado'}
    //este retângulo é apenas para manter o fundo branco atrás do scrollbox, criado a seguir
    recFundo := TRectangle.Create(lblShape);
    recFundo.Parent := lblShape;
    recFundo.Fill.Color := TAlphaColorRec.White;
    recFundo.Stroke.Kind := TBrushKind.None;
    recFundo.Align := TAlignLayout.Client;
    recFundo.Margins.Left := 3;
    recFundo.Margins.Right := 3;
    recFundo.Margins.Bottom := 3;

    LVertScrollBox := TVertScrollBox.Create(lblShape);
    LVertScrollBox.Parent := recFundo;
    LVertScrollBox.Name := StrSenhasList + IntToStr(FilaNo);
    LVertScrollBox.Align := TAlignLayout.Client;
    LVertScrollBox.TabOrder := 1;
    LVertScrollBox.Width := 145;
    LVertScrollBox.Tag := FilaNo;
    {$ENDREGION}

    {$IFNDEF CompilarPara_Online}
    if (not Assigned(FFilasClientDataSet)) then
    {$ENDIF CompilarPara_Online}
      FFilasClientDataSet := TObjectDictionary<Integer, TClientDataSet>.Create;

    LDataSetSenha      := TClientDataSet.Create(lblShape);
    LDataSetSenha.Name := StrCdsSenhas + IntToStr(FilaNo);
    LDataSetSenha.Tag  := FilaNo;
    FFilasClientDataSet.Add(FilaNo, LDataSetSenha);
    FDLocalSQL1.DataSets.Add(LDataSetSenha, '', 'FILA' + IntToStr(FilaNo));

    {$REGION 'Cria a FDQuery para a fila, para rodar o select em memória, sobre o CDS'}
    LFDQuery := TFDQuery.Create(lblShape);
    LFDQuery.Tag := FilaNo;

    LFieldTempoEspera := TStringField.Create(LFDQuery);
    with LFieldTempoEspera do
    begin
      if (vgParametrosModulo.MostrarTempoDecorridoEspera) then
      begin
        DisplayLabel := 'Tempo';
      end
      else
      begin
        DisplayLabel := 'Horário';
      end;

      FieldKind    := fkCalculated;
      FieldName    := 'TEMPO_ESPERA';
      DisplayWidth := 50;
    end;

    LFieldSenha := TIntegerField.Create(LFDQuery);
    with LFieldSenha do
    begin
      DisplayLabel := 'Senha';
      FieldKind    := fkData;
      FieldName    := 'SENHA';
    end;

    LFieldNomeCLiente := TStringField.Create(LFDQuery);

    with LFieldNomeCLiente do
    begin
      DisplayLabel := 'Nome';
      FieldKind    := fkData;
      FieldName    := 'NOMECLIENTE';
      Size         := 50;
      DisplayWidth := 50;
    end;

    LFieldProntuario := TIntegerField.Create(LFDQuery);
    with LFieldProntuario do
    begin
      DisplayLabel := 'Prontuário';
      FieldKind    := fkData;
      FieldName    := 'PRONTUARIO';
    end;

    LFieldCorLinha := TIntegerField.Create(LFDQuery);
    with LFieldCorLinha do
    begin
      FieldKind    := fkCalculated;
      FieldName    := 'COR_LINHA';
      DisplayLabel := 'COR LINHA';
      DisplayWidth := 20;
      Visible      := True;
    end;

    with LFDQuery do
    begin
      Connection                  := FDConnection1;
      FieldOptions.AutoCreateMode := TFieldsAutoCreationMode.acCombineAlways;
      Name                        := 'FDQueryFila' + IntToStr(FilaNo);
      Tag                         := FilaNo;
      OnCalcFields                := FDQueryCalcFields;
      SQL.Add('select *,');
      if (not vgParametrosModulo.MostrarTempoDecorridoEspera) then
        SQL.Add('  time(DATAHORA) as HORA_SENHA')
      else
        SQL.Add('  round((julianday("now", "localtime")-julianday(DATAHORA))*24*60*60) as TEMPO_ESPERA_SEGUNDOS');
      SQL.Add('from ');
      SQL.Add('  FILA' + IntToStr(FilaNo));
    end;

    LFieldSenha.DataSet       := LFDQuery;
    LFieldNomeCLiente.DataSet := LFDQuery;
    LFieldTempoEspera.DataSet := LFDQuery;
    LFieldCorLinha.DataSet    := LFDQuery;
    LFieldProntuario.DataSet  := LFDQuery;

    for I := 0 to LDMClient.cdsGruposDeTags.RecordCount - 1 do
    begin
      aField              := TStringField.Create(LFDQuery);
      aField.DisplayLabel := ' ';
      aField.DisplayWidth := 10;
      aField.FieldName    := COLUNA_CORTAG + IntToStr(COL_PRIMEIRA_TAG + I);
      aField.Size         := 200;
      aField.DataSet := LFDQuery;
    end;
    {$ENDREGION}

    if (not Assigned(FFDQuery)) then
      FFDQuery := TObjectDictionary<Integer, TFDQuery>.Create;
    FFDQuery.Add(FilaNo, LFDQuery);
    LFDQuery.AfterOpen     := OnSenhaAfterOpen;
    LFDQuery.AfterRefresh  := OnSenhaAfterOpen;

    self.FrameResize(self);
    lytRodape.Visible := tbcEspera.TabCount > 1;
    AtualizarBotoesRodape;

    Result := True;
  except
    on E: Exception do
    begin
      MyLogException(E);
      Result := False;
      Exit;
    end;
  end;
end;

procedure TFraSituacaoEspera.DoResizeCard(Sender: TObject);
var
   LLayoutTopBase: TControl;
   LLayoutImage: TLayout;

   function FindLayoutImage(AFromControl: TControl; out ALayoutImage: TLayout): Boolean;
   var
      I: Integer;
   begin
        Result:=False;
        ALayoutImage:=nil;
        for I := 0 to AFromControl.ControlsCount-1 do
        begin
             if (String(AFromControl.Controls[I].Name).StartsWith('LayoutImage')) and (AFromControl.Controls[I] is TLayout) then
             begin
                  Result:=True;
                  ALayoutImage:=AFromControl.Controls[I] as TLayout;
                  Break;
             end;   
        end;
   end;

begin
     if Sender is TControl then
     begin
          LLayoutTopBase:= Sender as TControl;
          if FindLayoutImage(LLayoutTopBase, LLayoutImage) then
          begin
               LLayoutImage.Width:= TControl(LLayoutTopBase.Parent).Width/4;
          end;
     end;
end;

function TFraSituacaoEspera.ExisteAFila(const Fila: Integer): Boolean;
begin
  Result := Assigned(GetComponenteFila(StrLabel, Fila));
end;

function TFraSituacaoEspera.ExisteOBitBtn(const FilaNo: Integer): Boolean;
var
  btnBitBtn: TButton;
begin
  btnBitBtn := GetComponenteFilaBtn(StrInserirSenha, FilaNo);
  Result    := (Assigned(btnBitBtn) and btnBitBtn.Visible);
end;

procedure TFraSituacaoEspera.FDQueryCalcFields(DataSet: TDataSet);
var
  hora, Min, Seg, Segundos: Integer;
  horas                   : string;
  LLinkGridToDataSource   : TLinkGridToDataSource;
  bitmap                  : TBitmap;
begin
  if (vgParametrosModulo.MostrarTempoDecorridoEspera) then
  begin
    if (Pos('.', DataSet.FieldByName('TEMPO_ESPERA_SEGUNDOS').AsString) > 0) then
    begin
      Segundos := Round(StrToFloat(StringReplace(DataSet.FieldByName('TEMPO_ESPERA_SEGUNDOS').AsString, '.', ',', [rfReplaceAll, rfIgnoreCase])));
    end
    else
      Segundos := Round(DataSet.FieldByName('TEMPO_ESPERA_SEGUNDOS').AsFloat);
    hora       := Segundos div 3600;
    Seg        := Segundos mod 3600;
    Min        := Seg div 60;
    Seg        := Seg mod 60;

    horas := FormatFloat(',00', hora) + ':' + FormatFloat('00', Min) + ':' + FormatFloat('00', Seg);

    //LM HCor quer só minuto e segundo precisamos criar parametro para essa situação
    //DataSet.FieldByName('TEMPO_ESPERA').AsString := FormatFloat(',00', hora) + ':' + FormatFloat('00', Min) + ':' + FormatFloat('00', Seg);
    
    if hora>0 then    
       DataSet.FieldByName('TEMPO_ESPERA').AsString := FormatFloat('00', hora)+'h'+ FormatFloat('00', Min) + 'm'
    else
       DataSet.FieldByName('TEMPO_ESPERA').AsString := FormatFloat('00', Min) + ':' + FormatFloat('00', Seg); 


          
    DataSet.FieldByName('COR_LINHA').AsInteger := verificaLimiar(horas, DataSet.Tag);
  end
  else
  begin
    DataSet.FieldByName('TEMPO_ESPERA').AsString := DataSet.FieldByName('HORA_SENHA').AsString;
  end;
end;

function TFraSituacaoEspera.FilaEhPermitida(const Fila: Integer): Boolean;
begin
  Result := (ExisteNoIntArray(Fila, vgParametrosModulo.FilasPermitidas) or ExisteNoIntArray(0, vgParametrosModulo.FilasPermitidas));
end;

function TFraSituacaoEspera.FindComponent(const AName: string; const aFindInSubComponent: Boolean): TComponent;
var
  ATabItem: TTabItem;
  I       : Integer;
begin
  Result := nil;
  if (AName = '') then
    Exit;

  for I := 0 to tbcEspera.TabCount - 1 do
  begin
    ATabItem := tbcEspera.Tabs[I];
    if Assigned(ATabItem) then
    begin
      Result := AspFindComponentAndSubComp(ATabItem, AName, True);
      if Assigned(Result) then
        Exit;
    end;
  end;

  Result := AspFindComponentAndSubComp(self, AName, aFindInSubComponent);
end;

function TFraSituacaoEspera.FormataNomeComponente(const aNomeComponente: String; const aFila: Integer): String;
begin
  Result := aNomeComponente + IntToStr(aFila);
end;

function TFraSituacaoEspera.GetComponenteFila(const aNome: String; const aCodFila: Integer): TComponent;
begin
  Result := AspFindComponentAndSubComp(self, FormataNomeComponente(aNome, aCodFila), True);
end;

function TFraSituacaoEspera.GetComponenteFilaBtn(const aNome: String; const aCodFila: Integer): TButton;
var
  LObjAux: TComponent;
begin
  Result  := nil;
  LObjAux := GetComponenteFila(aNome, aCodFila);
  if Assigned(LObjAux) then
    Result := LObjAux as TButton;
end;

function TFraSituacaoEspera.GetComponenteFilaCDS(const aNome: String; const aCodFila: Integer): TClientDataSet;
var
  LObjAux: TComponent;
begin
  Result  := nil;
  LObjAux := GetComponenteFila(aNome, aCodFila);
  if Assigned(LObjAux) then
    Result := LObjAux as TClientDataSet;
end;

function TFraSituacaoEspera.GetComponenteFilaEdt(const aNome: String; const aCodFila: Integer): TEdit;
var
  LObjAux: TComponent;
begin
  Result  := nil;
  LObjAux := GetComponenteFila(aNome, aCodFila);
  if Assigned(LObjAux) then
    Result := LObjAux as TEdit;
end;

function TFraSituacaoEspera.GetComponenteFilaLabel(const aNome: String; const aCodFila: Integer): TLabel;
var
  LObjAux: TComponent;
begin
  Result  := nil;
  LObjAux := GetComponenteFila(aNome, aCodFila);
  if Assigned(LObjAux) then
    Result := LObjAux as TLabel;
end;

function TFraSituacaoEspera.GetComponenteFilaRec(const aNome: String; const aCodFila: Integer): TRectangle;
var
  LObjAux: TComponent;
begin
  Result  := nil;
  LObjAux := GetComponenteFila(aNome, aCodFila);
  if Assigned(LObjAux) then
    Result := LObjAux as TRectangle;
end;

function TFraSituacaoEspera.GetDataSetOfLinkGrid(const aLinkGridToDataSource: TLinkGridToDataSource): TDataSet;
var
  LDMClient: TDMClient;
begin
  Result := inherited GetDataSetOfLinkGrid(aLinkGridToDataSource);
  if Assigned(Result) then
    Exit;
  LDMClient := DMClient(IDunidade, not CRIAR_SE_NAO_EXISTIR);
  if Assigned(LDMClient) and Assigned(aLinkGridToDataSource) and (Pos(StrLinkGridToDataSource, aLinkGridToDataSource.Name) = 1) then
    Result := LDMClient.CDSSenhas;
end;

procedure TFraSituacaoEspera.HeadersAvailable(Sender: TObject;
  AHeaders: TIdHeaderList; var VContinue: Boolean);
var
  LAlinhamento: String;
begin
  LAlinhamento := AHeaders.Values['alinhamento'];
  if not LAlinhamento.Trim.IsEmpty then
    TComponent(Sender).Tag := StrToIntDef(LAlinhamento, -1);
end;

procedure TFraSituacaoEspera.InsertPswd(const Fila, Pswd, Prontuario: Integer; const NomeCliente: string; const PswdDateTime: TDateTime;
  const Tags: TIntegerDynArray; const Posit: Integer; const aCanRefreshGrid: Boolean);
var
  I              : Integer;
  Grupo          : String;
  LDMClient      : TDMClient;
  dataAtual, hora: TDateTime;
  tempoEspera    : string;
  corLinha       : Integer;

const
  COLUNA_CODTAG = 'CODTAG';

  procedure CriarDataSetSenha;
  const
    COLUNAS_FIXAS_SENHA   = 8;
    COLUNAS_POR_GRUPO_TAG = 3;
  var
    TotalColunas : SmallInt;
    I            : Integer;
    LDataSetSenha: TClientDataSet;
    aField       : TField;
    qtde         : Integer;
  begin
    TotalColunas := ((LDMClient.cdsGruposDeTags.RecordCount * COLUNAS_POR_GRUPO_TAG) + COLUNAS_FIXAS_SENHA);
    if (LDMClient.CDSSenhas.FieldDefs.Count <> TotalColunas) then
    begin
      if LDMClient.CDSSenhas.Active then
      begin
        LDMClient.CDSSenhas.EmptyDataSet;
        LDMClient.CDSSenhas.Close;
      end;

      while (LDMClient.CDSSenhas.FieldDefs.Count > COLUNAS_FIXAS_SENHA) do
      begin
        LDMClient.CDSSenhas.FieldDefs.Delete(COLUNAS_FIXAS_SENHA);
      end;

      for I := 0 to LDMClient.cdsGruposDeTags.RecordCount - 1 do
      begin
        LDMClient.CDSSenhas.FieldDefs.Add(COLUNA_CODTAG + IntToStr(COL_PRIMEIRA_TAG + I), ftInteger);
        aField              := LDMClient.CDSSenhas.FieldDefs[LDMClient.CDSSenhas.FieldDefs.Count - 1].CreateField(LDMClient.CDSSenhas);
        aField.DisplayLabel := ' ';
        aField.DisplayWidth := 10;
        aField.Visible      := False;

        LDMClient.CDSSenhas.FieldDefs.Add(COLUNA_DESCTAG + IntToStr(COL_PRIMEIRA_TAG + I), ftString, 200);
        aField              := LDMClient.CDSSenhas.FieldDefs[LDMClient.CDSSenhas.FieldDefs.Count - 1].CreateField(LDMClient.CDSSenhas);
        aField.DisplayLabel := ' ';
        aField.DisplayWidth := 10;
        aField.Visible      := False;

        LDMClient.CDSSenhas.FieldDefs.Add(COLUNA_CORTAG + IntToStr(COL_PRIMEIRA_TAG + I), ftString, 200);
        aField              := LDMClient.CDSSenhas.FieldDefs[LDMClient.CDSSenhas.FieldDefs.Count - 1].CreateField(LDMClient.CDSSenhas);
        aField.DisplayLabel := ' ';
        aField.DisplayWidth := 10;
        aField.Visible      := True;
      end;
    end;

    {$IFDEF CompilarPara_PA_MULTIPA}
    LDMClient.CDSSenhasNOMECLIENTE.Visible := LParametrosModuloUnidade.MostrarNomeCliente;
    {$ELSE}
    LDMClient.CDSSenhasNOMECLIENTE.Visible := True;
    {$ENDIF CompilarPara_PA_MULTIPA}
    if not LDMClient.CDSSenhas.Active then
    begin
      LDMClient.CDSSenhas.CreateDataSet;
      LDMClient.CDSSenhas.LogChanges := False;
    end;

	{$IFNDEF CompilarPara_Online}
    if Assigned(FFilasClientDataSet) then    
    {$ENDIF CompilarPara_Online}
      for I := 0 to Length(FFilasCriadas) - 1 do
      begin
        LDataSetSenha := FFilasClientDataSet.Items[FFilasCriadas[I]];
        if not LDataSetSenha.Active then
        begin
          LDataSetSenha.CloneCursor(LDMClient.CDSSenhas, True, True);
          LDataSetSenha.Filtered   := False;
          LDataSetSenha.Filter     := Format('(IDFILA = %d)', [FFilasCriadas[I]]);
          LDataSetSenha.Filtered   := True;
          LDataSetSenha.LogChanges := False;
          UpdateColunasGrid(FFilasCriadas[I]);
        end;
      end;
  end;

  function ObtemColunaDaTag(ID: Integer): Integer;
  begin
    Result := 0;
    if LDMClient.cdsGruposDeTags.FindKey([ID]) then
      Result := (COL_PRIMEIRA_TAG - 1) + LDMClient.cdsGruposDeTags.RecNO;
  end;

begin
  hora      := PswdDateTime;
  LDMClient := DMClient(IDunidade, not CRIAR_SE_NAO_EXISTIR);

  if not LDMClient.cdsFilas.Locate('ID', Fila, []) then
  begin
    ErrorMessage(Format('A fila %d não foi encontrada', [Fila]));
    Exit;
  end;

  CriarDataSetSenha;

  if Posit = -1 then // inserir no comeco
  begin
    LDMClient.CDSSenhas.First;
    LDMClient.CDSSenhas.Append;
  end
  else
    LDMClient.CDSSenhas.Insert;

  LDMClient.CDSSenhas.FieldByName('IDFILA').AsInteger     := Fila;
  LDMClient.CDSSenhas.FieldByName('SENHA').AsInteger      := Pswd;
  LDMClient.CDSSenhas.FieldByName('NOMECLIENTE').AsString := NomeCliente;
  LDMClient.CDSSenhas.FieldByName('HORA').AsDateTime      := TimeOf(hora);
  LDMClient.CDSSenhas.FieldByName('DATAHORA').AsDateTime  := PswdDateTime;
  LDMClient.CDSSenhas.FieldByName('COR_LINHA').AsInteger  := corLinha;
  LDMClient.CDSSenhas.FieldByName('PRONTUARIO').AsInteger := Prontuario;

  for I := Low(Tags) to High(Tags) do
  begin
    if not Assigned(FListaTAGs) then
      FListaTAGs := TStringList.Create
    else
      FListaTAGs.Clear;

    //LDMClient.CDSSenhas.FieldByName(COLUNA_DESCTAG + IntToStr(COL_PRIMEIRA_TAG + I)).Visible := False;

    if LDMClient.cdsTags.FindKey([Tags[I]]) then
    begin
      Grupo := '';

      if LDMClient.cdsGruposDeTags.FindKey([LDMClient.cdsTags.FieldByName('IDGRUPO').AsInteger]) then
        Grupo := LDMClient.cdsGruposDeTags.FieldByName('Nome').AsString + ' - ';

      LDMClient.CDSSenhas.FieldByName(COLUNA_DESCTAG + IntToStr(COL_PRIMEIRA_TAG + I)).Visible := False;

      LDMClient.CDSSenhas.FieldByName(COLUNA_DESCTAG + IntToStr(COL_PRIMEIRA_TAG + I)).AsString :=
        IntToStr(LDMClient.cdsTags.FieldByName('ID').AsInteger) + ';' + IntToStr(LDMClient.cdsTags.FieldByName('CODIGOCOR').AsInteger) + ';' + Grupo +
        LDMClient.cdsTags.FieldByName('Nome').AsString;

      LDMClient.CDSSenhas.FieldByName(COLUNA_CODTAG + IntToStr(COL_PRIMEIRA_TAG + I)).AsInteger := Tags[I];

      if (FListaTAGs.IndexOf(LDMClient.cdsTags.FieldByName('Nome').AsString) = -1) then
        FListaTAGs.AddObject(LDMClient.cdsTags.FieldByName('Nome').AsString, TObject(LDMClient.cdsTags.FieldByName('CodigoCor').AsInteger));
    end;
  end;

  LDMClient.CDSSenhas.Post;

  if aCanRefreshGrid then
    RefreshGrid(Fila);
end;

procedure TFraSituacaoEspera.InsertSenhaButton1Click(Sender: TObject);
var
  Aux                : string;
  LSenha             : Integer;
  LInsertSenhaButton1: TButton;
begin
  if Sender is TButton then
  begin
    LInsertSenhaButton1 := (Sender as TButton);
    LSenha              := StrToIntDef(GetComponenteFilaEdt(StrSenhaEdit, LInsertSenhaButton1.Tag).Text, 0);
    if LSenha = 0 then
      raise Exception.Create('A senha não foi informada!');

    GetSendInserirSenhaText(LInsertSenhaButton1.Tag, LSenha, Aux);
    DMConnection(IDunidade, not CRIAR_SE_NAO_EXISTIR).EnviarComando(cProtocoloPAVazia + Chr($6B) + Aux, IDunidade);

    GetComponenteFilaEdt(StrSenhaEdit, LInsertSenhaButton1.Tag).Text := '';
    btnTecladoTouch_Close.OnClick(btnTecladoTouch_Close);
  end; { if Sender isTButton }
end;

function TFraSituacaoEspera.LerPropriedade(const aNomePropriedade, aNomeComponente: string; const aValorPadrao: Variant;
  const aFila: Integer): Variant;
var
  LComponente: TComponent;
begin
  LComponente := GetComponenteFila(aNomeComponente, aFila);
  Result      := AspLerPropriedade(LComponente, aNomePropriedade, aValorPadrao);
end;

procedure TFraSituacaoEspera.LimpaFila(const Fila: Integer);
var
  LCDSSenha: TClientDataSet;

  procedure DeleteAll;
  begin
    LCDSSenha.Last;
    while not LCDSSenha.Bof do
    begin
      LCDSSenha.Delete;
    end;
  end;

begin
  {$IFNDEF CompilarPara_Online}
  if Assigned(FFilasClientDataSet) then
  {$ENDIF CompilarPara_Online}
    LCDSSenha := FFilasClientDataSet.Items[Fila];

  if Assigned(LCDSSenha) and LCDSSenha.Active then
    DeleteAll;
end;

procedure TFraSituacaoEspera.OnSenhaAfterOpen(ADataset: TDataset);
begin
  FLayoutFila := TLayoutFila(vgParametrosModulo.SituacaoEsperaLayout);
  RedesenharFila(ADataset);
  AtualizaLabelQtdeSenha(ADataset);
end;

procedure TFraSituacaoEspera.RedesenharFila(ADataset: TDataset);
var
  LArray: TStringDynArray;
  LParent: TControl;
  i: Integer;
  s: string;
  LDMClient: TDMClient;
begin
  LArray := [];
  LDMClient := DMClient(IDunidade, not CRIAR_SE_NAO_EXISTIR);
  SetLength(LArray, LDMClient.cdsGruposDeTags.RecordCount);
  for I := 0 to LDMClient.cdsGruposDeTags.RecordCount - 1 do
  begin
    s := COLUNA_DESCTAG + IntToStr(COL_PRIMEIRA_TAG + I);
    if Assigned(ADataset.FindField(s))  then
    begin
      LArray[i] := s;
      ADataset.FieldByName(s).Visible := False;
    end;
  end;

  LParent := TControl(FindComponent(StrSenhasList + ADataset.Tag.ToString));
  LParent.BeginUpdate;
  try
    if LParent is TVertScrollBox then
      with TVertScrollBox(LParent) do
        while Content.ControlsCount>0 do
        begin
          var LControl: TControl := Content.Controls[0];

          LControl.Parent := nil;
          LControl.Free;
        end;

    if (vgParametrosModulo.TamanhoFonte = FONTE_EX_GRANDE) then
      TGeradorFila.FTamanhoFonte := TAMANHO_FONTE_EX_GRANDE
    else if (vgParametrosModulo.TamanhoFonte = FONTE_GRANDE) then
      TGeradorFila.FTamanhoFonte := TAMANHO_FONTE_GRANDE
    else if (vgParametrosModulo.TamanhoFonte = FONTE_MEDIA) then
      TGeradorFila.FTamanhoFonte := TAMANHO_FONTE_MEDIA
    else
      TGeradorFila.FTamanhoFonte := TAMANHO_FONTE_NORMAL;

    TGeradorFila.FEstiloLayout := vgParametrosModulo.SituacaoEsperaEstiloLayout;

    TGeradorFila.Execute(FLayoutFila,
                         LParent,
                         ADataset,
                         'NOMECLIENTE',
                         'SENHA',
                         'TEMPO_ESPERA',
                         'COR_LINHA',
                         'PRONTUARIO',
                         LArray,
                         SenhaMouseUp,
                         ListBoxItemOnDblClick);
  finally
    LParent.EndUpdate;
  end;
end;

procedure TFraSituacaoEspera.PrioritaryList1Click(Sender: TObject);
var
  Aux      : string;
  LCheckBox: TCheckBox;
begin
  if (Sender is TCheckBox) then
  begin
    LCheckBox := (Sender as TCheckBox);
    GetSendClicarCheckBoxPrioritariaOuBloquearText(LCheckBox.Tag, LCheckBox.Name, LCheckBox.IsChecked, Aux);
    DMConnection(IDunidade, not CRIAR_SE_NAO_EXISTIR).EnviarComando(cProtocoloPAVazia + Chr($69) + Aux, IDunidade, '', False);
  end;
end;

procedure TFraSituacaoEspera.RefreshAllGrids;
var
  I: Integer;
begin
  for I := 1 to vgParametrosModulo.MaiorFilaCadastrada do
    RefreshGrid(I);
end;

procedure TFraSituacaoEspera.RefreshGrid(const aFila: Integer);
begin
  {$IFNDEF CompilarPara_Online}
  if Assigned(FFDQuery) then
  {$ENDIF CompilarPara_Online}
    RedesenharFila(FFDQuery.Items[aFila]);
end;

procedure TFraSituacaoEspera.SenhaEdit1Change(Sender: TObject);
var
  I                 : Integer;
  LInsertSenhaButton: TButton;
  LSenhaEdit        : TEdit;
begin
  if Assigned(Sender) and (Sender is TEdit) then
  begin
    LSenhaEdit         := TEdit(Sender);
    I                  := LSenhaEdit.Tag;
    LInsertSenhaButton := GetComponenteFilaBtn(StrInsertSenhaButton, I);
    try
      if ((LSenhaEdit.Text = '') or (StrToIntDef(LSenhaEdit.Text, 0) = 0)) then
        LInsertSenhaButton.Enabled := False
      else
        LInsertSenhaButton.Enabled := True;
    except
      LInsertSenhaButton.Enabled := False;
    end
  end;
end;

procedure TFraSituacaoEspera.SenhaEdit1Enter(Sender: TObject);
const
  OFF = 5;
var
  j           : Integer;
  edtSenhaEdit: TEdit;

  function GetParentTop(const aControl: TFmxObject): Single;
  begin
    Result := 0;
    if not(Assigned(aControl) and (aControl <> pnlTecladoTouch.Parent)) then
      Exit;

    if (aControl is TControl) then
      Result := TControl(aControl).Position.Y;
    if Assigned(aControl.Parent) then
      Result := Result + GetParentTop(aControl.Parent);
  end;

  function GetParentLeft(const aControl: TFmxObject): Single;
  begin
    Result := 0;
    if not(Assigned(aControl) and (aControl <> pnlTecladoTouch.Parent)) then
      Exit;

    if (aControl is TControl) then
      Result := TControl(aControl).Position.X;
    if Assigned(aControl.Parent) then
      Result := Result + GetParentLeft(aControl.Parent);
  end;

begin
  // LBC MULTIUNIDADES  LParametrosModuloUnidade := ParametrosModuloPorUnidade(IDUnidade);

  // LBC MULTIUNIDADES  for j := 1 to LParametrosModuloUnidade.MaiorFilaCadastrada do
  for j := 1 to vgParametrosModulo.MaiorFilaCadastrada do
  begin
    if ExisteAFila(j) then
      GetComponenteFilaBtn(StrInsertSenhaButton, j).Default := (Sender = GetComponenteFilaEdt(StrSenhaEdit, j));
  end;
end;

procedure TFraSituacaoEspera.SenhasList1ApplyStyleLookup(Sender: TObject);
var
  Header    : THeader;
  HeaderItem: THeaderItem;
  I         : Integer;
begin
  Header := THeader((Sender as TGrid).FindStyleResource('header'));
  if Assigned(Header) then
  begin
    for I := 0 to Header.Count - 1 do
    begin
      HeaderItem := Header.Items[I];

      if (vgParametrosModulo.TamanhoFonte = FONTE_GRANDE) then
        HeaderItem.Font.Size := 42
      else if (vgParametrosModulo.TamanhoFonte = FONTE_MEDIA) then
        HeaderItem.Font.Size := 21
      else
        HeaderItem.Font.Size := 12;

      HeaderItem.TextSettings.FontColor := TAlphaColorRec.White;
      HeaderItem.StyledSettings         := HeaderItem.StyledSettings - [TStyledSetting.FontColor, TStyledSetting.Size, TStyledSetting.Style];
    end;
    if (vgParametrosModulo.TamanhoFonte = FONTE_GRANDE) then
      Header.Height := 21 * 3
    else if (vgParametrosModulo.TamanhoFonte = FONTE_MEDIA) then
      Header.Height := 21 * 2
    else
      Header.Height := 21;
  end;
end;

procedure TFraSituacaoEspera.SenhaMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
var
  point           : TPoint;
  popup           : TPopupMenu;
  LFmxObject      : TFMXObject;
  item            : TMenuItem;
  I, LFila, LSenha: Integer;
  AllowDelete     : Boolean;
  AllowDeleteAll  : Boolean;
  AllowReimpressao: Boolean;
  LNome           : string;
begin
  if (Sender is TFmxObject) then
  begin
    LFmxObject := Sender as TFMXObject;
    LFila  := LFmxObject.Tag;
    LSenha := Trunc(LFmxObject.TagFloat);
    LNome  := LFmxObject.TagString;
  end;

  AllowDelete      := ExisteNoIntArray(LFila, vgParametrosModulo.PermitirExclusaoNasFilas);
  AllowReimpressao := ExisteNoIntArray(LFila, vgParametrosModulo.PermitirReimpressaonasFilas);
  AllowDeleteAll   := ExisteNoIntArray(LFila, vgParametrosModulo.PermitirExclusaoNasFilas) and vgParametrosModulo.MostrarExcluirTodas;

  if (Button = TMouseButton.mbRight) then
  begin
    {$IFNDEF IS_MOBILE}
    GetCursorPos(point);
    {$ENDIF }

    popup           := TPopupMenu(FrmSicsOnLine.FindComponent('ManagePswdPopMenu'));
    filaSelecionada := LFmxObject.Tag;
    if (popup <> nil) then
    begin
      popup.Tag := LSenha;
      popup.TagString := LNome;
      for I     := 0 to popup.ItemsCount - 1 do
      begin
        if (popup.Items[I].Name = 'PopUpMenuExcluir') then
        begin
          popup.Items[I].Visible := AllowDelete;
        end;
        if (popup.Items[I].Name = 'PopUpMenuReimprimir') then
        begin
          popup.Items[I].Visible := AllowReimpressao;
        end;
        if (popup.Items[I].Name = 'PopUpMenuExcluirTodos') then
        begin
          popup.Items[I].Visible := AllowDeleteAll;
        end;
      end;
      popup.popup(point.X, point.Y);
    end;
  end;
end;

procedure TFraSituacaoEspera.SetListBlocked(Fila: Integer; Check: Boolean);
begin
  if ExisteAFila(Fila) then
  begin
    (FindComponent('ListBlocked' + IntToStr(Fila)) as TCheckBox).OnChange := nil;
    (FindComponent('ListBlocked' + IntToStr(Fila)) as TCheckBox).IsChecked := Check;
    (FindComponent('ListBlocked' + IntToStr(Fila)) as TCheckBox).OnChange := PrioritaryList1Click;
  end;
end;

procedure TFraSituacaoEspera.SetPrioritaryList(Fila: Integer; Check: Boolean);
begin
  if ExisteAFila(Fila) then
  begin
    (FindComponent('PrioritaryList' + IntToStr(Fila)) as TCheckBox).OnChange := nil;
    (FindComponent('PrioritaryList' + IntToStr(Fila)) as TCheckBox).IsChecked := Check;
    (FindComponent('PrioritaryList' + IntToStr(Fila)) as TCheckBox).OnChange := PrioritaryList1Click;
  end;
end;

procedure TFraSituacaoEspera.SetVisible(const aValue: Boolean);
begin
  inherited;
  if (not aValue) then
  begin
    if (Assigned(tmrAtualizaHorario)) then
      tmrAtualizaHorario.Enabled := False;
  end;
end;

function TFraSituacaoEspera.TamanhoDaFonte: Integer;
begin
  case vgParametrosModulo.TamanhoFonte of
    FONTE_MEDIA:
      Result := 2;
    FONTE_GRANDE:
      Result := 3;
  else
    Result := 1;
  end;

end;

procedure TFraSituacaoEspera.tbcEsperaChange(Sender: TObject);
begin
  inherited;

  AtualizarBotoesRodape;
  pnlTecladoTouch.Visible := False;
end;

procedure TFraSituacaoEspera.tmrAtualizaHorarioTimer(Sender: TObject);
var
  I: Integer;
begin
  inherited;
  for I := 0 to Length(FFilasCriadas) - 1 do
  begin
    if (FFDQuery.Items[FFilasCriadas[I]].State in [dsBrowse]) then
      FFDQuery.Items[FFilasCriadas[I]].Refresh;
  end;
end;

procedure TFraSituacaoEspera.UpdateColunasGrid(const Fila: Integer);
var
  LLinkGridToDataSource: TLinkGridToDataSource; // BAH substituindo TAspLinkGridToDataSource
  LDMClient            : TDMClient;
begin
  if self.Visible then
  begin
    LLinkGridToDataSource := GetComponenteFila(StrLinkGridToDataSource, Fila) as TLinkGridToDataSource;
    LDMClient             := DMClient(IDunidade, not CRIAR_SE_NAO_EXISTIR);
    if Assigned(LDMClient) then
      AspUpdateColunasGrid(self, LLinkGridToDataSource, LDMClient.CDSSenhas);
  end;
end;

function TFraSituacaoEspera.verificaLimiar(hora: string; Fila: Integer): Integer;
const
  COR_LARANJA  = $FFFF8000;
  COR_VERDE    = $FF00FF00;
  COR_AMARELO  = TAlphaColorRec.Yellow;
  COR_VERMELHO = TAlphaColorRec.Red;
begin
  Result := COR_VERDE;
  if ((FFilasLimiarAmarelo.Items[Fila] <> '00:00:00') and (FFilasLimiarVermelho.Items[Fila] <> '00:00:00') and
    (FFilasLimiarLaranja.Items[Fila] <> '00:00:00')) then
  begin
    if ((hora >= FFilasLimiarAmarelo.Items[Fila]) and (hora < FFilasLimiarLaranja.Items[Fila])) then
      Result := COR_AMARELO
    else if ((hora >= FFilasLimiarLaranja.Items[Fila]) and (hora < FFilasLimiarVermelho.Items[Fila])) then
      Result := COR_LARANJA
    else if (hora >= FFilasLimiarVermelho.Items[Fila]) then
      Result := TAlphaColorRec.Red;
  end
  else if (FFilasLimiarAmarelo.Items[Fila] <> '00:00:00') then
  begin
    if (FFilasLimiarLaranja.Items[Fila] <> '00:00:00') then
    begin
      if ((hora >= FFilasLimiarAmarelo.Items[Fila]) and (hora < FFilasLimiarLaranja.Items[Fila])) then
        Result := COR_AMARELO
      else if (hora >= FFilasLimiarLaranja.Items[Fila]) then
        Result := COR_LARANJA;
    end
    else if (FFilasLimiarVermelho.Items[Fila] <> '00:00:00') then
    begin
      if ((hora >= FFilasLimiarAmarelo.Items[Fila]) and (hora < FFilasLimiarVermelho.Items[Fila])) then
        Result := COR_AMARELO
      else if (hora >= FFilasLimiarVermelho.Items[Fila]) then
        Result := COR_VERMELHO;
    end
    else if (hora >= FFilasLimiarAmarelo.Items[Fila]) then
      Result := COR_AMARELO;
  end
  else if (FFilasLimiarLaranja.Items[Fila] <> '00:00:00') then
  begin
    if (FFilasLimiarVermelho.Items[Fila] <> '00:00:00') then
    begin
      if ((hora >= FFilasLimiarLaranja.Items[Fila]) and (hora < FFilasLimiarVermelho.Items[Fila])) then
        Result := COR_LARANJA
      else if (hora >= FFilasLimiarVermelho.Items[Fila]) then
        Result := COR_VERMELHO;
    end
    else if (hora >= FFilasLimiarLaranja.Items[Fila]) then
      Result := COR_LARANJA;
  end
  else if (FFilasLimiarVermelho.Items[Fila] <> '00:00:00') then
  begin
    if (hora >= FFilasLimiarVermelho.Items[Fila]) then
      Result := COR_VERMELHO; // $F1FD5A5A;
  end
  else
  begin
    Result := $00000000;
  end;
end;

function TFraSituacaoEspera.FormataNomeGridPanelLayout(ATabItem: TTabItem): String;
begin
  Result := StrGridPanelLayout + ATabItem.Name;
end;

function TFraSituacaoEspera.AddTabItem: TTabItem;
var
  LGridPanelLayout: TGridPanelLayout;
  I               : Integer;
begin
  Result                  := tbcEspera.Add;
  Result.Text             := IntToStr(tbcEspera.TabCount);
  pnlTecladoTouch.Visible := False;

  // KM - Adicionado para solucionar o problema de Resize das filas ao
  // redimensionar a Janela. A partir de agora os objetos das filas já serão
  // criados nas respectivas posições/alinhamentos, dispensando códigos futuros
  // para isso
  LGridPanelLayout        := TGridPanelLayout.Create(Result);
  LGridPanelLayout.Parent := Result;
  LGridPanelLayout.Name   := FormataNomeGridPanelLayout(Result);
  LGridPanelLayout.Align  := TAlignLayout.Client;
  LGridPanelLayout.ColumnCollection.Clear;
  LGridPanelLayout.RowCollection.Clear;

  // adiciona no GridPanelLayout as linhas e colunas configuradas
  for I := 1 to vgParametrosModulo.ColunasdeFilas do
    LGridPanelLayout.ColumnCollection.Add;
  for I := 1 to vgParametrosModulo.LinhasDeFilas do
    LGridPanelLayout.RowCollection.Add;

  // ajustando a largura percentual de todas as colunas para ZERO faz todas terem mesma largura
  LGridPanelLayout.ColumnCollection.BeginUpdate;
  try
    for I                                        := 0 to LGridPanelLayout.ColumnCollection.Count - 1 do
      LGridPanelLayout.ColumnCollection[I].Value := 0;
  finally
    LGridPanelLayout.ColumnCollection.EndUpdate;
  end;

  // ajustando a altura percentual de todas as linhas para ZERO faz todas terem mesma altura
  LGridPanelLayout.RowCollection.BeginUpdate;
  try
    for I                                     := 0 to LGridPanelLayout.RowCollection.Count - 1 do
      LGridPanelLayout.RowCollection[I].Value := 0;
  finally
    LGridPanelLayout.RowCollection.EndUpdate;
  end;
end;

procedure TFraSituacaoEspera.ListBoxItemOnDblClick(Sender: TObject);
var
   LFrmDadosAdicionais: TFrmDadosAdicionais;
begin
  if vgParametrosModulo.MostrarDadosAdicionais then
  begin
    {$IFNDEF IS_MOBILE}
    LockWindowUpdate(WindowHandleToPlatform(Application.MainForm.Handle).Wnd);
    {$ENDIF IS_MOBILE}

    FreeAndNil(FJSONDadosAdicionais);

    LFrmDadosAdicionais := FrmDadosAdicionais(IDUnidade, True);
    LFrmDadosAdicionais.CarregarDadosAdicionais(0, FloatToStr(TListBoxItem(Sender).TagFloat), IDUnidade);
    LFrmDadosAdicionais.Show;

    Application.ProcessMessages;
    Sleep(10);
    LockWindowUpdate(0);
    TListBoxItem(Sender).IsSelected := False;
    TListBoxItem(Sender).UpdateEffects;
    TListBox(TListBoxItem(Sender).Owner).ClearSelection;

    LFrmDadosAdicionais.ShowModal(
      procedure (aModalResult: TModalResult)
      begin
        if (aModalResult = mrOk) then
        begin

        end;
      end);
  end;
end;

end.
