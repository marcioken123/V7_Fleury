unit ufrmMensagemPainelEImpressora;
//Renomeado unit Sics_Common_MensagemPainelEImpressora;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  FMX.Grid, FMX.Controls, FMX.Forms, FMX.Graphics,
  FMX.Dialogs, FMX.StdCtrls, FMX.ExtCtrls, FMX.Types, FMX.Layouts, FMX.ListView.Types,
  FMX.ListView, FMX.ListBox, untCommonDMClient,
  Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors, FMX.Objects, FMX.Edit, FMX.TabControl,
  System.UITypes, System.Types, System.SysUtils, System.Classes, System.Variants, Data.DB, Datasnap.DBClient, System.Rtti,
  Data.Bind.EngExt, Data.Bind.Components,
  Data.Bind.Grid, Data.Bind.DBScope, untMainForm,
  IniFiles, Data.FMTBcd, Soap.SOAPHTTPClient, Datasnap.Provider, FMX.ScrollBox, FMX.Memo,
  MyAspFuncoesUteis, untCommonFrameBase, FMX.Controls.Presentation, Soap.InvokeRegistry, Soap.Rio,
  untCommonFormBase, System.ImageList, FMX.ImgList, FMX.Effects,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, 
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, 
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.DBX.Migrate, System.Net.URLClient, uDataSetHelper;

type
  TTipoDeConfiguracao = (tcPainel, tcImpressora);
  TProcPainel = TProc<Integer, string, Integer>;

  TfrmMensagemPainelEImpressora = class(TFrameBase)
    cdsPaineis: TClientDataSet;
    dspPaineis: TDataSetProvider;
    qryPaineis: TFDQuery;
    qryTotens: TFDQuery;
    dtsPaineis: TDataSource;
    cdsTotens: TClientDataSet;
    dspTotens: TDataSetProvider;
    dtsTotens: TDataSource;
    HTTPRIO: THTTPRIO;
    dbMemo: TMemo;
    lytRodape: TLayout;
    cboComandosPaineis: TComboBox;
    dblkpTotens: TComboBox;
    dblkpPainel: TComboBox;
    PainelLabel: TLabel;
    OpenBtn: TButton;
    SaveBtn: TButton;
    CancelBtn: TButton;
    OkBtn: TButton;
    cdsPaineisID: TIntegerField;
    cdsPaineisNOME: TStringField;
    cdsPaineisMENSAGEM: TMemoField;
    bndPaineis: TBindSourceDB;
    cdsTotensID: TIntegerField;
    cdsTotensNOME: TStringField;
    cdsTotensMENSAGEM: TMemoField;
    bndTotens: TBindSourceDB;
    dtsMain: TDataSource;
    LinkFillControlToField1: TLinkFillControlToField;
    LinkFillControlToField2: TLinkFillControlToField;
    cboPIs: TComboBox;
    cdsPaineisID_UNIDADE: TIntegerField;
    cdsTotensID_UNIDADE: TIntegerField;
    procedure MainMemoChange(Sender: TObject);
    procedure OpenBtnClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure cdsPaineisPrintersReconcileError(DataSet: TCustomClientDataSet; E: EReconcileError;
      UpdateKind: TUpdateKind; var Action: TReconcileAction);
    procedure OkBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure dblkpPainelChange(Sender: TObject);
    procedure cdsPaineisAfterOpen(DataSet: TDataSet);
    procedure cdsPaineisAfterScroll(DataSet: TDataSet);
    procedure cdsPaineisBeforePost(DataSet: TDataSet);
    procedure cdsTotensBeforePost(DataSet: TDataSet);
    procedure cdsTotensAfterScroll(DataSet: TDataSet);
    procedure cdsTotensAfterOpen(DataSet: TDataSet);
    procedure dblkpTotensChange(Sender: TObject);
    procedure cboOnChangeAddToMemo(Sender: TObject);
  private
    FPrimeiraInicializacao: Boolean;
    procedure Inicializar;
    procedure CarregarPIsEmCboPIs;
    procedure CarregarComandosEmCboComandosPaineis;
  protected
    { Private declarations }
    vlChanged : boolean;
    FTipoDeConfiguracao: TTipoDeConfiguracao;

    procedure GravarMensagem;
    function RemoveTag(AText: string): string;
    procedure SetIDUnidade(const Value: Integer); Override;
    procedure SetTipoDeConfiguracao(const Value: TTipoDeConfiguracao);
    procedure HabilitaBotoes;
  public
    DataSourceMemo: TDataSource;
    { Public declarations }
    FPodeSincronizaMensagem: Boolean;
    TextoComTagWS: string;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    ProcPainel: TProcPainel;

    dblkpCurrent: TComboBox;
    function GetContextoCorrente: string; Override;
    procedure SincronizaMensagem(const aEnviarParaDataSet, aSetRecno: Boolean);
    function ValidacaoAtivaModoConectado: Boolean; Override;
    property TipoDeConfiguracao: TTipoDeConfiguracao read FTipoDeConfiguracao write SetTipoDeConfiguracao;
	  constructor Create(aOwer: TComponent); Override;
  end;

function FrmMensagemPainelEImpressora(const aIDUnidade: integer; const aAllowNewInstance: Boolean = False; const aOwner: TComponent = nil): TFrmMensagemPainelEImpressora;

implementation

uses untCommonDMConnection, Sics_Common_Parametros;

{$R *.fmx}

function FrmMensagemPainelEImpressora(const aIDUnidade: integer; const aAllowNewInstance: Boolean = False; const aOwner: TComponent = nil): TFrmMensagemPainelEImpressora;
begin
  Result := TfrmMensagemPainelEImpressora(TfrmMensagemPainelEImpressora.GetInstancia(aIDUnidade, aAllowNewInstance, aOwner));
end;

constructor TfrmMensagemPainelEImpressora.Create(aOwer: TComponent);
begin
  inherited;
  FPrimeiraInicializacao := True;
  FPodeSincronizaMensagem := True;
  ProcPainel := nil;
  FTipoDeConfiguracao := TTipoDeConfiguracao.tcPainel;
  OpenDialog1 := TOpenDialog.Create(Self);
  OpenDialog1.DefaultExt := 'txt';
  OpenDialog1.Filter := 'Arquivo texto|*.txt|Todos os arquivos|*.*';
  OpenDialog1.FilterIndex := 0;
  OpenDialog1.Options := [TOpenOption.ofHideReadOnly, TOpenOption.ofPathMustExist, TOpenOption.ofFileMustExist];
  OpenDialog1.Title := 'Abrir mensagem';

  SaveDialog1 := TSaveDialog.Create(Self);
  SaveDialog1.DefaultExt := 'txt';
  SaveDialog1.Filter := 'Arquivo texto|*.txt|Todos os arquivos|*.*';
  SaveDialog1.FilterIndex := 0;
  SaveDialog1.Options := [TOpenOption.ofOverwritePrompt, TOpenOption.ofHideReadOnly];
  SaveDialog1.Title := 'Salvar mensagem';

  //qryPaineis.Connection := DMClient(IDUnidade, not PERMITIR_NOVA_INSTANCIA).connDMClient;
  //qryTotens.Connection := DMClient(IDUnidade, not PERMITIR_NOVA_INSTANCIA).connDMClient;

  CarregarComandosEmCboComandosPaineis;
  CarregarPIsEmCboPIs;

  HabilitaBotoes;
end;

procedure TfrmMensagemPainelEImpressora.CarregarComandosEmCboComandosPaineis;
begin
  cboComandosPaineis.BeginUpdate;
  try
    cboComandosPaineis.Clear;
    cboComandosPaineis.Items.Text := ASPEzPorListaTodosComandos;
    cboComandosPaineis.Items.Insert(0, '- Comandos - ');
    cboComandosPaineis.ItemIndex := 0;
  finally
    cboComandosPaineis.EndUpdate;
  end;
end;

procedure TfrmMensagemPainelEImpressora.CarregarPIsEmCboPIs;
var
  i: Integer;
begin
  cboPIs.BeginUpdate;
  try
    cboPIs.Clear;
    cboPIs.Items.Add('- Indicad. de Performance -');
    for i := Low(vgParametrosModulo.NomesIndicadoresPermitidos) to High(vgParametrosModulo.NomesIndicadoresPermitidos) do
      cboPIs.Items.Add(vgParametrosModulo.NomesIndicadoresPermitidos[i]);
    cboPIs.ItemIndex := 0;
  finally
    cboPIs.EndUpdate;
  end;
end;


procedure TfrmMensagemPainelEImpressora.dblkpPainelChange(Sender: TObject);
begin
  inherited;
  SincronizaMensagem(True, True);
end;

procedure TfrmMensagemPainelEImpressora.dblkpTotensChange(Sender: TObject);
begin
  inherited;

  SincronizaMensagem(True, True);
end;

procedure TfrmMensagemPainelEImpressora.MainMemoChange(Sender: TObject);
begin
   vlChanged := true;
end;

procedure TfrmMensagemPainelEImpressora.OpenBtnClick(Sender: TObject);
var
  LContextoAtual: String;
begin
  LContextoAtual := GetContextoCorrente;
  if(OpenDialog1.Execute) then
  begin
    if (LContextoAtual = GetContextoCorrente) then
        begin
          dbMemo.Lines.Clear;
          dbMemo.Lines.LoadFromFile (OpenDialog1.FileName);
        end
        else
          ErrorMessage(Format('Contexto foi alterado. De %s para %s.', [LContextoAtual, GetContextoCorrente]));
  end;
end;

procedure TfrmMensagemPainelEImpressora.SaveBtnClick(Sender: TObject);
var
  LContextoAtual: String;
begin
  LContextoAtual := GetContextoCorrente;
 if(SaveDialog1.Execute)then
    if (LContextoAtual = GetContextoCorrente) then
       dbMemo.Lines.SaveToFile (SaveDialog1.FileName)
    else
       ErrorMessage(Format('Contexto foi alterado. De %s para %s.', [LContextoAtual, GetContextoCorrente]));

end;

procedure TfrmMensagemPainelEImpressora.SetIdUnidade(const Value: Integer);
begin
  if (IdUnidade <> Value) or FPrimeiraInicializacao then
  begin
    inherited;
    Inicializar;
  end;
end;

procedure TfrmMensagemPainelEImpressora.Inicializar;
begin
  if FPrimeiraInicializacao then
    FPrimeiraInicializacao := False;

  DMClient(IDUnidade, not CRIAR_SE_NAO_EXISTIR).SetNewSqlConnectionForSQLDataSet(Self);
  SetTipoDeConfiguracao(TipoDeConfiguracao);
end;

procedure TfrmMensagemPainelEImpressora.SetTipoDeConfiguracao(const Value: TTipoDeConfiguracao);
begin
  FTipoDeConfiguracao := Value;
  if (FTipoDeConfiguracao = tcPainel) then
  begin
    dblkpCurrent               := dblkpPainel;
    dtsMain.DataSet            := cdsPaineis;
    Self.Caption               := 'Mensagem do Painel';
    dbMemo.Hint                := 'Digite aqui a mensagem que deverá aparecer no painel.';
    PainelLabel.Text           := 'Painel:';
    dblkpPainel.Visible        := true;
    dblkpTotens.Visible        := false;
    cboComandosPaineis.Visible := true;
    cboPIs.Visible             := true;
    DataSourceMemo             := dtsPaineis;
    vlChanged                  := false;

    cdsPaineis.Close;
    cdsPaineis.Open;
    if not cdsPaineis.IsEmpty then
      dblkpPainel.KeyValue[cdsPaineis, 'ID'] := cdsPaineis.FieldByName('ID').Value;

    cdsPaineis.Edit;
  end
  else
  begin
    dbMemo.Hint                := 'Digite aqui a mensagem será apresentada no roda-pé da senha (Ticket).';
    dblkpCurrent               := dblkpTotens;
    dtsMain.DataSet            := cdsTotens;
    Self.Caption               := 'Mensagem de rodapé dos tickets de senha';
    PainelLabel.Text           := 'Totem:';
    dblkpPainel.Visible        := false;
    dblkpTotens.Visible        := true;
    cboComandosPaineis.Visible := false;
    cboPIs.Visible             := False;
    DataSourceMemo             := dtsTotens;
    vlChanged                  := false;

    cdsTotens.Close;
    cdsTotens.Open;
    if not cdsTotens.IsEmpty then
      dblkpTotens.KeyValue[cdsTotens, 'ID'] := cdsTotens.FieldByName('ID').Value;

    cdsTotens.Edit;
  end;
  dblkpTotens.Position.X := dblkpPainel.Position.X;
  dblkpTotens.Position.Y := dblkpPainel.Position.Y;
  dblkpTotens.Width := dblkpPainel.Width;
  dblkpTotens.Height := dblkpPainel.Height;

  cboPIs.Width  := dblkpPainel.Width;
  cboPIs.Height := dblkpPainel.Height;
  cboPIs.Position.X := cboComandosPaineis.Position.X + cboComandosPaineis.Width + 7;
  cboPIs.Position.Y := cboComandosPaineis.Position.Y;

  HabilitaBotoes;
end;

procedure TfrmMensagemPainelEImpressora.SincronizaMensagem(const aEnviarParaDataSet, aSetRecno: Boolean);
begin
  if aEnviarParaDataSet then
  begin
    if not FPodeSincronizaMensagem then
      Exit;

    FPodeSincronizaMensagem := False;
    try
      if (dblkpCurrent.ItemIndex > -1) then
      begin
        if not (dtsMain.DataSet.State in dsEditModes) then
          dtsMain.DataSet.Edit;
        dtsMain.DataSet.FieldByName('MENSAGEM').AsString := dbMemo.Lines.Text;

        if aSetRecno and (dtsMain.DataSet.RecNo <> dblkpCurrent.ItemIndex + 1) then
        begin
          if (dtsMain.DataSet.State in dsEditModes) then
            dtsMain.DataSet.Post;
          dtsMain.DataSet.RecNo := dblkpCurrent.ItemIndex + 1;
          dbMemo.Lines.Text := dtsMain.DataSet.FieldByName('MENSAGEM').AsString;
        end;
      end;
    finally
      FPodeSincronizaMensagem := True;
    end;
  end
  else
    dbMemo.Lines.Text := dtsMain.DataSet.FieldByName('MENSAGEM').AsString;
end;

function TfrmMensagemPainelEImpressora.ValidacaoAtivaModoConectado: Boolean;
begin
  Result := cNaoPossuiConexaoDiretoDB;
end;

function TfrmMensagemPainelEImpressora.GetContextoCorrente: string;
begin
  Result := 'ID Painel: ' + dtsMain.DataSet.FieldByName('ID').AsString;
end;

procedure TfrmMensagemPainelEImpressora.GravarMensagem;
var
  cds : TClientDataSet;
begin
  if TipoDeConfiguracao = tcPainel then
    cds := cdsPaineis
  else
    cds := cdsTotens;

  with cds do
  begin
    if State in dsEditModes then
    begin
      UpdateRecord;
      Post;
    end;
    if ApplyUpdates(0) <> 0 then
      CancelUpdates;
  end;

  ProcPainel(cds.FieldByName('ID').AsInteger,cds.FieldByName('MENSAGEM').AsString,IDUnidade);
end;

procedure TfrmMensagemPainelEImpressora.HabilitaBotoes;
begin
  OkBtn.Enabled := ASsigned(dblkpCurrent) and (dblkpCurrent.ItemIndex > -1);
end;

procedure TfrmMensagemPainelEImpressora.cdsPaineisAfterOpen(DataSet: TDataSet);
begin
  inherited;
  SincronizaMensagem(False, False);
end;

procedure TfrmMensagemPainelEImpressora.cdsPaineisAfterScroll(DataSet: TDataSet);
begin
  inherited;

  SincronizaMensagem(False, False);
end;

procedure TfrmMensagemPainelEImpressora.cdsPaineisBeforePost(DataSet: TDataSet);
begin
  inherited;

  SincronizaMensagem(True, False);
end;

procedure TfrmMensagemPainelEImpressora.cdsPaineisPrintersReconcileError(
  DataSet: TCustomClientDataSet; E: EReconcileError;
  UpdateKind: TUpdateKind; var Action: TReconcileAction);
begin
  ErrorMessage(E.Message);
end;

procedure TfrmMensagemPainelEImpressora.cdsTotensAfterOpen(DataSet: TDataSet);
begin
  inherited;

  SincronizaMensagem(False, False);
end;

procedure TfrmMensagemPainelEImpressora.cdsTotensAfterScroll(DataSet: TDataSet);
begin
  inherited;

  SincronizaMensagem(False, False);
end;

procedure TfrmMensagemPainelEImpressora.cdsTotensBeforePost(DataSet: TDataSet);
begin
  inherited;

  SincronizaMensagem(True, False);
end;

procedure TfrmMensagemPainelEImpressora.CancelBtnClick(Sender: TObject);
var
  cds : TClientDataSet;
begin
  if TipoDeConfiguracao = tcPainel then
    cds := cdsPaineis
  else
    cds := cdsTotens;
  inherited;
  with cds do
  begin
  	if State in dsEditModes then
    begin
    	Cancel;
      CancelUpdates;
    end;
  end;
  Visible := False;
end;

procedure TfrmMensagemPainelEImpressora.cboOnChangeAddToMemo(Sender: TObject);
var
  sText, sAdd: String;
  iSelStart: Integer;
  LCombo: TComboBox;
begin
  LCombo := TComboBox(Sender);

  if (LCombo.ItemIndex = 0) then
    Exit;

  sText := dbMemo.Text;
  sAdd := LCombo.Items[LCombo.ItemIndex];
  if Sender = cboPIs then
    sAdd  := '{{PI ' + sAdd + '}}';
  iSelStart := dbMemo.SelStart;

  Delete(sText, iSelStart + 1, dbMemo.SelLength);
  Insert(sAdd, sText, iSelStart + 1);
  dbMemo.Text := sText;
  dbMemo.SetFocus;
  dbMemo.SelStart := iSelStart + Length(sAdd);

  //usa uma Thread para aguardar o término do "onChange" em que um
  //Comandou ou PI foi selecionado e, em seguida, volta o itemindex
  //do respectivo combo para 0, permitindo que o mesmo item seja
  //selecionado novamente
  TThread.CreateAnonymousThread(procedure begin
    Sleep(50);
    TThread.Synchronize(nil, procedure begin
      LCombo.ItemIndex := 0;
    end);
  end).Start;
end;

procedure TfrmMensagemPainelEImpressora.OkBtnClick(Sender: TObject);
begin
  SincronizaMensagem(True, False);  //LBC: o que faz esta linha?

  GravarMensagem;

  Visible := False;
end;

function TfrmMensagemPainelEImpressora.RemoveTag(AText: string): string;
const
  cOpenTag  = '{{';
  cCloseTag = '}}';
var
  A,B: Integer;

  procedure ReadTagPositon;
  begin
    A := Pos(cOpenTag,AText);
    B := Pos(cCloseTag,AText);
  end;

begin
  Result  := EmptyStr;

  ReadTagPositon;

  while ((A > 0) and (B > 0)) do
  begin
    Delete(AText,A, (B - A) + Length(cOpenTag));
    ReadTagPositon;
  end;

  Result := AText;
end;

end.


