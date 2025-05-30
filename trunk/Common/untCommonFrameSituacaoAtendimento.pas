unit untCommonFrameSituacaoAtendimento;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  {$IFNDEF IS_MOBILE}
  Windows, Messages, ScktComp,
  {$ENDIF}
  FMX.Grid, FMX.Controls, FMX.Graphics,
  FMX.Dialogs, FMX.StdCtrls, FMX.ExtCtrls, FMX.Types, FMX.Layouts, FMX.ListView.Types,
  FMX.ListView, FMX.ListBox,
   Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors, FMX.Objects, FMX.Edit, FMX.TabControl,

  System.UITypes, System.Types, System.SysUtils, System.Classes, System.Variants, Data.DB, Datasnap.DBClient, System.Rtti,
  Data.Bind.EngExt, Data.Bind.Components,
  Data.Bind.Grid, Data.Bind.DBScope,
  MyAspFuncoesUteis, untCommonFrameBase, FMX.Controls.Presentation,
  System.ImageList, FMX.ImgList,untCommonFormBaseOnLineTGS, FMX.Effects,
  FMX.Filter.Effects, System.Generics.Collections, FMX.Grid.Style, FMX.ScrollBox, FMX.Ani;

type
  TStatusPA = (spDeslogado, spDisponivel, spEmAtendimento, spEmPausa);

  TFraSituacaoAtendimento = class(TFrameBase)
    TabControl: TTabControl;
    tabPAs: TTabItem;
    grdPAs: TGrid;
    tabAtendentes: TTabItem;
    grdAtds: TGrid;
    lblEstado: TLabel;
    cmbEstado: TComboBox;
    lblPausa: TLabel;
    cbbPausa: TComboBox;

    cdsPAs: TClientDataSet;
    cdsPAsId_PA: TIntegerField;
    cdsPAsLKUP_PA: TStringField;
    cdsPAsLKUP_GRUPO: TStringField;
    cdsPAsLKUP_STATUS: TStringField;
    cdsPAsLKUP_ATD: TStringField;
    cdsPAsSENHA: TIntegerField;
    cdsPAsNomeCliente: TStringField;
    cdsPAsHorario: TDateTimeField;
    cdsPAsLKUP_MOTIVOPAUSA: TStringField;
    cdsPAsLKUP_FILA: TStringField;
    cdsPAsId_Status: TIntegerField;
    cdsPAsId_Atd: TIntegerField;
    cdsPAsId_Fila: TIntegerField;
    cdsPAsId_MotivoPausa: TIntegerField;
    bndPAs: TBindSourceDB;
    LinkGridPAs: TLinkGridToDataSource;
    LinkGridAtds: TLinkGridToDataSource;

    cdsAtds: TClientDataSet;
    IntegerField2: TIntegerField;
    cdsAtdsLKUP_ATD: TStringField;
    cdsAtdsLKUP_GRUPO: TStringField;
    cdsAtdsId_Status: TIntegerField;
    cdsAtdsLKUP_STATUS: TStringField;
    IntegerField1: TIntegerField;
    cdsAtdsLKUP_PA: TStringField;
    IntegerField4: TIntegerField;
    cdsAtdsNomeCliente: TStringField;
    DateTimeField1: TDateTimeField;
    cdsAtdsId_Fila: TIntegerField;
    cdsAtdsLKUP_FILA: TStringField;
    cdsAtdsId_MotivoPausa: TIntegerField;
    cdsAtdsLKUP_MOTIVOPAUSA: TStringField;
    bndAtds: TBindSourceDB;
    rectFiltro: TRectangle;
    cdsAtdsIdGrupo: TIntegerField;
    cdsPAsIdGrupo: TIntegerField;
    pResumoPAs: TPanel;
    Image1: TImage;
    lblQtdDisponivel: TLabel;
    Image2: TImage;
    lblQtdAtendendo: TLabel;
    Image3: TImage;
    lblQtdDeslogado: TLabel;
    Image4: TImage;
    lblQtdEmPausa: TLabel;
    FillRGBEffect1: TFillRGBEffect;
    FillRGBEffect2: TFillRGBEffect;
    FillRGBEffect3: TFillRGBEffect;
    FillRGBEffect4: TFillRGBEffect;
    cdsResumoStatus: TClientDataSet;
    cdsPAsClone: TClientDataSet;
    cdsAtdsClone: TClientDataSet;
    recPreLoader: TRectangle;
    aniPreLoader: TAniIndicator;
    prgPreLoader: TProgressBar;

    procedure cmbEstadoChange(Sender: TObject);
    procedure cbbPausaChange(Sender: TObject);
    procedure cdsPAsLKUPOnGetText(Sender: TField; var Text: string; const DisplayText: Boolean; const aFieldID: String);

    procedure cdsPAsLKUP_PAGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure cdsPAsLKUP_GRUPOGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure cdsPAsLKUP_ATDGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure cdsPAsLKUP_FILAGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure cdsAfterOpen(DataSet: TDataSet);
    procedure cbbPausaClick(Sender: TObject);
    procedure cdsPAsAfterScroll(DataSet: TDataSet);
    procedure cdsAtdsAfterScroll(DataSet: TDataSet);
    procedure TabControlChange(Sender: TObject);
  private
    FResumoMotivosPausa: TDictionary<string,integer>;
    FPreLoader: Boolean;
    FMaxRecords: Integer;
    procedure ImportarParaComboStatusPAs;
    procedure ImportarParaComboMotivosPausa;
    procedure AtualizarResumoPAS;
    procedure SetMaxRecords(const Value: Integer);
  protected
    procedure SetVisible(const aValue: Boolean); Override;
    procedure SetIDUnidade(const aValue: Integer); Override;
  public
    procedure CarregarParametrosDB; Overload; Override;
    procedure CarregarParametrosDB(const aIDUnidade: Integer); Overload; Override;
    destructor Destroy; Override;
    function UpdateNomeCliente(Senha: Integer; Nome: string): Boolean;
    procedure AtualizaLookups;
    procedure AtualizaListaDePAs;
    procedure AtualizaListaDeAtendentes;
    procedure UpdatePASituation(PA, StatusPA, ATD: Integer; PWD: string; FilaProveniente, MotivoPausa: Integer; TIM: TDateTime; NomeCliente: string);
    procedure ResetDatasets;
    procedure RepaintGrid;
    procedure SetPreLoader(Value: Boolean);
    constructor Create(AOwner: TComponent); overload; override;

    procedure UpdateProgress(AValue: Integer);

    property PreLoader: Boolean read FPreLoader write SetPreLoader;
    property MaxRecords: Integer read FMaxRecords write SetMaxRecords;
  end;

const
  cFiltroTodos = 'Todos';

function FraSituacaoAtendimento(const aIDUnidade: integer; const aAllowNewInstance: Boolean = False; const aOwner: TComponent = nil): TFraSituacaoAtendimento;

implementation

uses
  untCommonDMClient,
  untCommonDMConnection,
  Sics_Common_Parametros,
  untLog;

{$R *.fmx}

function FraSituacaoAtendimento(const aIDUnidade: integer; const aAllowNewInstance: Boolean = False; const aOwner: TComponent = nil): TFraSituacaoAtendimento;
begin
  Result := TFraSituacaoAtendimento(TFraSituacaoAtendimento.GetInstancia(aIDUnidade, aAllowNewInstance, aOwner));
end;

procedure TFraSituacaoAtendimento.AtualizaListaDeAtendentes;
var
  nowtime : TDateTime;
  LEstavaFiltrandoPAs, LEstavaFiltrandoAtend: Boolean;
  LOldRecnoPA: Integer;
  LDMClient: TDMClient;
begin
  LDMClient := DMClient(Self.IDUnidade, not CRIAR_SE_NAO_EXISTIR);
  cdsAtds.DisableControls;
  cdsPAs.DisableControls;

  try
    LEstavaFiltrandoPAs := cdsPAs.Filtered;
    LEstavaFiltrandoAtend := cdsAtds.Filtered;
    LOldRecnoPA := cdsPAs.RecNo;
    try
      cdsPAs.Filtered  := False;
      cdsAtds.Filtered := False;
      with cdsAtds do
      begin
        First;
        while not eof do
          Delete;
      end;

      nowtime := now;

      LDMClient.cdsAtendentes.First;
      while not LDMClient.cdsAtendentes.eof do
      begin
        cdsAtds.Append;

        cdsAtds.FieldByName('Id_Atd' ).AsInteger  := LDMClient.cdsAtendentes.FieldByName('ID').AsInteger;
        cdsAtds.FieldByName('Horario').AsDateTime := nowtime;
        cdsAtds.FieldByName('Id_Status').AsInteger:= Integer(spDeslogado);
        cdsAtds.FieldByName('IdGrupo').AsInteger:= LDMClient.cdsAtendentes.FieldByName('IdGrupo').AsInteger;


        cdsAtds.Post;

        LDMClient.cdsAtendentes.Next;
      end;  { with }
    finally
      cdsPAs.Filtered  := LEstavaFiltrandoPAs;
      cdsAtds.Filtered := LEstavaFiltrandoAtend;

      if (LOldRecnoPA > -1) then
        cdsPAs.RecNo := LOldRecnoPA;
    end;
  finally
    cdsAtds.EnableControls;
    cdsPAs.EnableControls;
  end;
end;

procedure TFraSituacaoAtendimento.AtualizaListaDePAs;
var
  NowTime                     : TDateTime;
  LOldRecnoPA, LOldRecnoAtds  : Integer;
  LEstavaFiltrandoPAs,
  LEstavaFiltrandoAtend       : Boolean;
  LDMClient: TDMClient;
begin
  LDMClient := DMClient(Self.IDUnidade, not CRIAR_SE_NAO_EXISTIR);
  cdsPAs.DisableControls;
  cdsAtds.DisableControls;

  try
    LEstavaFiltrandoPAs := cdsPAs.Filtered;
    LEstavaFiltrandoAtend := cdsAtds.Filtered;
    LOldRecnoAtds := cdsAtds.RecNo;
    try
      cdsPAs.Filtered  := False;
      cdsAtds.Filtered  := False;

      with cdsPAs do
      begin
        First;
        while not eof do
          Delete;
      end;

      NowTime   := now;
      LOldRecnoPA := LDMClient.cdsPAs.RecNo;
      try
        LDMClient.cdsPAs.First;
        while not LDMClient.cdsPAs.eof do
        begin
          cdsPAs.Append;

          cdsPAs.FieldByName('Id_PA').AsInteger    := LDMClient.cdsPAs.FieldByName('ID').AsInteger;
          cdsPAs.FieldByName('Horario').AsDateTime := NowTime;
          cdsPAs.FieldByName('IdGrupo').AsInteger :=  LDMClient.cdsPAs.FieldByName('IdGrupo').AsInteger;

          cdsPAs.Post;

          LDMClient.cdsPAs.Next;
        end; { with }
      finally
        if (LOldRecnoPA > -1) then
          LDMClient.cdsPAs.RecNo := LOldRecnoPA;
      end;
    finally
      cdsPAs.Filtered := LEstavaFiltrandoPAs;
      cdsAtds.Filtered := LEstavaFiltrandoAtend;

      if (LOldRecnoAtds > -1) then
        cdsAtds.RecNo := LOldRecnoAtds;
    end;
  finally
    cdsPAs.EnableControls;
    cdsAtds.EnableControls;
  end;
end;

procedure TFraSituacaoAtendimento.RepaintGrid;
begin
  BeginUpdate;
  try
    AtualizarResumoPAS;

    Self.RepaintJointArea(grdPAs);
  finally
    EndUpdate;
  end;
end;

procedure TFraSituacaoAtendimento.ResetDatasets;
var
  LDMClient: TDMClient;
begin
  cdsPAs.Close;
  cdsAtds.Close;

  LDMClient := DMCLient(IdUnidade, not CRIAR_SE_NAO_EXISTIR);

  cdsPAsLKUP_PA.LookupDataSet          := LDMClient.cdsPAs;
  //cdsPAsLKUP_ID_GRUPO.LookupDataSet    := LDMClient.cdsPAs;
  cdsPAsLKUP_GRUPO.LookupDataSet       := LDMClient.cdsGruposDePAs;
  cdsPAsLKUP_ATD.LookupDataSet         := LDMClient.cdsAtendentes;
  cdsPAsLKUP_FILA.LookupDataSet        := LDMClient.cdsFilas;
  cdsPAsLKUP_STATUS.LookupDataSet      := LDMClient.cdsStatusPAs;
  cdsPAsLKUP_MOTIVOPAUSA.LookupDataSet := LDMClient.cdsMotivosPausa;

  cdsAtdsLKUP_PA.LookupDataSet          := LDMClient.cdsPAs;
  cdsAtdsLKUP_GRUPO.LookupDataSet       := LDMClient.cdsGruposDeAtendentes;
  cdsAtdsLKUP_ATD.LookupDataSet         := LDMClient.cdsAtendentes;
  cdsAtdsLKUP_FILA.LookupDataSet        := LDMClient.cdsFilas;
  cdsAtdsLKUP_STATUS.LookupDataSet      := LDMClient.cdsStatusPAs;
  cdsAtdsLKUP_MOTIVOPAUSA.LookupDataSet := LDMClient.cdsMotivosPausa;

  cdsPAs.CreateDataSet;
  cdsAtds.CreateDataSet;
  cdsPAs.LogChanges  := False;
  cdsAtds.LogChanges := False;

  cdsPAsClone .CloneCursor (cdsPAs , true);
  cdsPAsClone .LogChanges := false;

  cdsAtdsClone.CloneCursor (cdsAtds, true);
  cdsAtdsClone.LogChanges := false;
end;

procedure TFraSituacaoAtendimento.AtualizaLookups;
begin
  ResetDatasets;
  AtualizaListaDePAs;
  AtualizaListaDeAtendentes;
  ImportarParaComboStatusPAs;
  ImportarParaComboMotivosPausa;
  AtualizarResumoPAS;
end;

procedure TFraSituacaoAtendimento.CarregarParametrosDB(const aIDUnidade: Integer);
begin
  inherited;

  cdsPAsLKUP_GRUPO.Visible  := vgParametrosModulo.VisualizarGruposPAsAtds;
  cdsAtdsLKUP_GRUPO.Visible := vgParametrosModulo.VisualizarGruposPAsAtds;
end;

procedure TFraSituacaoAtendimento.CarregarParametrosDB;
begin
  inherited;
  {$IFDEF CompilarPara_PA_MULTIPA}
  cdsPAsNomeCliente.Visible := ParametrosModuloDB.MostrarNomeCliente;
  cdsAtdsNomeCliente.Visible := ParametrosModuloDB.MostrarNomeCliente;
  cdsPAsLKUP_MOTIVOPAUSA.Visible := ParametrosModuloDB.MostrarPausa;
  cdsAtdsLKUP_MOTIVOPAUSA.Visible := ParametrosModuloDB.MostrarPausa;
  {$ELSE}
  cdsPAsNomeCliente.Visible := True;
  cdsAtdsNomeCliente.Visible := True;
  cdsPAsLKUP_MOTIVOPAUSA.Visible := True;
  cdsAtdsLKUP_MOTIVOPAUSA.Visible := True;
  {$ENDIF CompilarPara_PA_MULTIPA}
end;

procedure TFraSituacaoAtendimento.cdsAtdsAfterScroll(DataSet: TDataSet);
begin
  inherited;
  cdsAtdsNomeCliente.Visible := vgParametrosModulo.VisualizarNomeClientes;
end;

procedure TFraSituacaoAtendimento.cdsAfterOpen(DataSet: TDataSet);
begin
  inherited;
  AtualizarColunasGrid;
  AtualizarResumoPAS;
  if vgParametrosModulo.ModoCallCenter then
    DataSet.FieldByName('SENHA').DisplayLabel := 'Mesa';
end;

procedure TFraSituacaoAtendimento.cdsPAsAfterScroll(DataSet: TDataSet);
begin
  inherited;
  cdsPAsNomeCliente.Visible := vgParametrosModulo.VisualizarNomeClientes;
end;

procedure TFraSituacaoAtendimento.cdsPAsLKUPOnGetText(Sender: TField; var Text: string; const DisplayText: Boolean; const aFieldID: String);
begin
  Text := Sender.AsString;
  if ((Sender.AsString = '') and (not Sender.DataSet.FieldByName(aFieldID).IsNull)) then
    Text := '???';
end;

procedure TFraSituacaoAtendimento.cdsPAsLKUP_ATDGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  inherited;
  cdsPAsLKUPOnGetText(Sender, Text, DisplayText, 'Id_Atd');
end;

procedure TFraSituacaoAtendimento.cdsPAsLKUP_FILAGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  inherited;
  cdsPAsLKUPOnGetText(Sender, Text, DisplayText, 'Id_Fila');
end;

procedure TFraSituacaoAtendimento.cdsPAsLKUP_GRUPOGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  inherited;
  if cdsPAsLKUP_GRUPO.LookupDataSet.Locate('ID', cdsPAsIdGrupo.AsInteger, []) then
    Text := cdsPAsLKUP_GRUPO.LookupDataSet.FieldByName('Nome').AsString
  else
    Text := '???';
end;

procedure TFraSituacaoAtendimento.cdsPAsLKUP_PAGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  inherited;
  cdsPAsLKUPOnGetText(Sender, Text, DisplayText, 'Id_PA');
end;

procedure TFraSituacaoAtendimento.cmbEstadoChange(Sender: TObject);
var
  LDMClient: TDMClient;
  LOldOnChange: TNotifyEvent;
  LPASBook,
  LAtdsBook: TBookmark;
begin
  LDMClient := DMClient(Self.IDUnidade, not CRIAR_SE_NAO_EXISTIR);
  inherited;
  LOldOnChange := cmbEstado.OnChange;
  try
    cmbEstado.OnChange := nil;
    cbbPausa.ItemIndex := 0;

    LPASBook := cdsPAs.GetBookmark;
    LAtdsBook := cdsAtds.GetBookmark;
    try
      if ((cmbEstado.ItemIndex > -1) and (cmbEstado.Selected.Text <> cFiltroTodos)) then
      begin
        cdsPAs.Filtered := False;
        if LDMClient.cdsStatusPAs.Locate('Nome', cmbEstado.Selected.Text, []) then
        begin
          cdsPAs.Filter     := 'Id_Status = ' + LDMClient.cdsStatusPAs.FieldByName('ID').AsString;
          cdsPAs.Filtered   := True;

          cdsAtds.Filter    := cdsPAs.Filter;
          cdsAtds.Filtered   := cdsPAs.Filtered;
        end;
      end
      else
      begin
        cdsPAs.Filtered        := False;
        cdsPAs.IndexFieldNames := 'Id_PA';

        cdsAtds.Filtered        := cdsPAs.Filtered;
        cdsAtds.IndexFieldNames := 'Id_Atd';
      end;
    finally
      if cdsPAs.BookmarkValid(LPASBook) then
        cdsPAs.GotoBookmark(LPASBook);

      if cdsAtds.BookmarkValid(LAtdsBook) then
        cdsAtds.GotoBookmark(LAtdsBook);
    end;
  finally
    cmbEstado.OnChange := LOldOnChange;
  end;
end;

constructor TFraSituacaoAtendimento.Create(AOwner: TComponent);
begin
  inherited;
  FResumoMotivosPausa := TDictionary<string, integer>.Create;
end;

procedure TFraSituacaoAtendimento.cbbPausaChange(Sender: TObject);
var
  LDMClient: TDMClient;
  LOldOnChange: TNotifyEvent;
  LPASBook,
  LAtdsBook: TBookmark;
begin
  LDMClient := DMClient(Self.IDUnidade, not CRIAR_SE_NAO_EXISTIR);
  inherited;

  LOldOnChange := cbbPausa.OnChange;
  try
    cbbPausa.OnChange       := nil;
    cmbEstado.OnChange      := cmbEstadoChange;

    LPASBook := cdsPAs.GetBookmark;
    LAtdsBook := cdsAtds.GetBookmark;
    try
      if ((cbbPausa.ItemIndex > -1) and (cbbPausa.Items[cbbPausa.ItemIndex] <> cFiltroTodos)) then
      begin
        cmbEstado.ItemIndex     := cmbEstado.Items.IndexOf('Em pausa');

        cdsPAs.Filtered         := False;
        if LDMClient.cdsMotivosPausa.Locate('Nome', cbbPausa.Items[cbbPausa.ItemIndex], []) then
        begin
          cdsPAs.Filter         := 'Id_MotivoPausa = ' + LDMClient.cdsMotivosPausa.FieldByName('ID').AsString;
          cdsPAs.Filtered       := True;

          cdsAtds.Filter        := cdsPAs.Filter;
          cdsAtds.Filtered      := cdsPAs.Filtered;
        end;

        cdsPAs.IndexFieldNames  := 'Horario';
        cdsAtds.IndexFieldNames := cdsPAs.IndexFieldNames;
      end
      else
      begin
        cdsPAs.Filtered         := False;
        cdsPAs.IndexFieldNames  := 'Id_pA';

        cdsAtds.Filtered        := cdsPAs.Filtered;
        cdsAtds.IndexFieldNames := 'Id_Atd';
        cmbEstado.OnChange(cmbEstado);
      end;
    finally
      if cdsPAs.BookmarkValid(LPASBook) then
        cdsPAs.GotoBookmark(LPASBook);

      if cdsAtds.BookmarkValid(LAtdsBook) then
        cdsAtds.GotoBookmark(LAtdsBook);
    end;
  finally
    cbbPausa.OnChange := LOldOnChange;
  end;
end;

procedure TFraSituacaoAtendimento.cbbPausaClick(Sender: TObject);
begin
  inherited;
  Exit;
end;


destructor TFraSituacaoAtendimento.Destroy;
begin
  FResumoMotivosPausa.Free;
  inherited;
end;

procedure TFraSituacaoAtendimento.ImportarParaComboMotivosPausa;
var
  nRecno         : Integer;
  LOldMotivoPausa: String;
  LDMClient: TDMClient;
  LOldOnChange: TNotifyEvent;
begin
  LDMClient := DMClient(Self.IDUnidade, not CRIAR_SE_NAO_EXISTIR);
  LOldOnChange := cmbEstado.OnChange;
  try
    cmbEstado.OnChange := nil;
    cbbPausa.Items.Clear;
    cbbPausa.Items.Add(cFiltroTodos);
    nRecno          := LDMClient.cdsMotivosPausa.RecNo;
    LOldMotivoPausa := '';

    if (cbbPausa.ItemIndex > -1) then
      LOldMotivoPausa := cbbPausa.Items[cbbPausa.ItemIndex];
    try
      LDMClient.cdsMotivosPausa.First;
      while not LDMClient.cdsMotivosPausa.eof do
      begin
        cbbPausa.Items.Add(LDMClient.cdsMotivosPausa.FieldByName('Nome').AsString);
        LDMClient.cdsMotivosPausa.Next;
      end;
    finally
      if (nRecno > -1) then
        LDMClient.cdsMotivosPausa.RecNo := nRecno;

      if (LOldMotivoPausa <> '') then
        cbbPausa.ItemIndex := cbbPausa.Items.IndexOf(LOldMotivoPausa)
      else
      if cbbPausa.Items.Count > 0 then
        cbbPausa.ItemIndex := 0;
    end;
  finally
    cmbEstado.OnChange := LOldOnChange;
  end;
end;

procedure TFraSituacaoAtendimento.ImportarParaComboStatusPAs;
var
  LOldRecno : Integer;
  LOldEstado: String;
  LDMClient: TDMClient;
  LOldOnChange: TNotifyEvent;
begin
  LDMClient := DMClient(Self.IDUnidade, not CRIAR_SE_NAO_EXISTIR);

  LOldOnChange := cmbEstado.OnChange;
  try
    cmbEstado.OnChange := nil;
    LOldRecno  := LDMClient.cdsStatusPAs.RecNo;
    LOldEstado := '';

    if (cmbEstado.ItemIndex > -1) then
      LOldEstado := cmbEstado.Items[cmbEstado.ItemIndex];
    try
      cmbEstado.Items.Clear;
      cmbEstado.Items.Add(cFiltroTodos);
      LDMClient.cdsStatusPAs.First;
      while not LDMClient.cdsStatusPAs.eof do
      begin
        cmbEstado.Items.Add(LDMClient.cdsStatusPAs.FieldByName('Nome').AsString);
        LDMClient.cdsStatusPAs.Next;
      end;
    finally
      if (LOldRecno > -1) then
        LDMClient.cdsStatusPAs.RecNo := LOldRecno;

      if (LOldEstado <> '') then
        cmbEstado.ItemIndex := cmbEstado.Items.IndexOf(LOldEstado)
      else
      if cmbEstado.Items.Count > 0 then
        cmbEstado.ItemIndex := 0;
    end;
  finally
    cmbEstado.OnChange := LOldOnChange;
  end;
end;

procedure TFraSituacaoAtendimento.SetPreLoader(Value: Boolean);
begin
  TThread.Queue(nil,
    procedure
    begin
      FPreLoader := Value;

      if FPreLoader then
      begin
        cdsPAs.DisableControls;
        cdsAtds.DisableControls;

        cdsPAsLKUP_PA.RefreshLookupList;
        cdsPAsLKUP_ATD.RefreshLookupList;
        cdsAtdsLKUP_ATD.RefreshLookupList;

        recPreLoader.Align := TAlignLayout.Contents;
        recPreLoader.Visible := True;
        aniPreLoader.Enabled := True;
        prgPreLoader.Value := 0;
      end
      else
      begin
        recPreLoader.Visible := False;
        recPreLoader.Align := TAlignLayout.None;
        aniPreLoader.Enabled := False;
        prgPreLoader.Value := 0;

        cdsPAs.EnableControls;
        cdsAtds.EnableControls;

        IDUnidade := FIDUnidade;
      end;
    end);
end;

procedure TFraSituacaoAtendimento.SetIDUnidade(const aValue: Integer);
var
  LID: Integer;
  LDMConnection         : TDMConnection;
  LgIdDoModulo          : string;
  GuardaIDcmbEstado     : Integer;
  GuardaIDcbbPausa      : Integer;
  GuardaTabControlIndex : Integer;
begin
  //JLS - 23/01/2019  - Adicionei as 3 próximas linhas para guardar as últimas
  //                    opções selecionadas nos combos e TabControl.
  GuardaIDcmbEstado     := cmbEstado.ItemIndex;
  GuardaIDcbbPausa      := cbbPausa.ItemIndex;
  GuardaTabControlIndex := TabControl.TabIndex;
  try

    LID := IDUnidade;

  inherited;

    if (LID <> aValue) then
    begin
      AtualizaLookups;
      LDMConnection := DMConnection(IdUnidade, not CRIAR_SE_NAO_EXISTIR);
      LgIdDoModulo := TAspEncode.AspIntToHex(LDMConnection.IdModulo, 4);
      LDMConnection.EnviarComando(LgIdDoModulo + Chr($71), IDUnidade);
      LDMConnection.EnviarComando(LgIdDoModulo + Chr($3D), IDUnidade);
    end;

    if not FPreLoader then
    begin
      ImportarParaComboStatusPAs;
      ImportarParaComboMotivosPausa;
      cmbEstado.ItemIndex := 0;
      cbbPausa.ItemIndex  := 0;
    end;
  finally
    //JLS - 23/01/2019 - Após a atualização e recarregamento dos componentes,
    //                   restauro as opções selecionadas, cujos índices foram
    //                   guardados no início desta "procedure".
    if not FPreLoader then
    begin
      cmbEstado.ItemIndex   := GuardaIDcmbEstado;
//      cmbEstadoChange(Self);
      cbbPausa.ItemIndex    := GuardaIDcbbPausa;
//      cbbPausaChange(Self);
    end;

    TabControl.TabIndex   := GuardaTabControlIndex;
  end;
end;

procedure TFraSituacaoAtendimento.SetMaxRecords(const Value: Integer);
begin
  FMaxRecords := Value;

  prgPreLoader.Max := FMaxRecords;
end;

procedure TFraSituacaoAtendimento.SetVisible(const aValue: Boolean);
begin
  inherited;
end;

procedure TFraSituacaoAtendimento.UpdateProgress(AValue: Integer);
begin
  TThread.Queue(nil,
    procedure
    begin
      prgPreLoader.Value := AValue;
    end);
end;

procedure TFraSituacaoAtendimento.TabControlChange(Sender: TObject);
begin
  inherited;
  AtualizarResumoPAS;
end;

function TFraSituacaoAtendimento.UpdateNomeCliente(Senha: Integer; Nome: string): Boolean;
var
  BM1, BM2             : TBookmark;
  bEstavaFiltrandoPAs, bEstavaFiltrandoAtds: Boolean;
begin
  Result := False;

  cdsPAs.DisableControls;
  cdsAtds.DisableControls;
  try
    grdPAs.BeginUpdate;

    bEstavaFiltrandoAtds  := cdsAtds.Filtered;
    bEstavaFiltrandoPAs   := cdsPAs.Filtered;
    BM1                   := cdsAtds.GetBookmark;
    BM2                   := cdsPAs.GetBookmark;
    try
      cdsPAs.Filtered := False;
      cdsAtds.Filtered := False;
      try
        with cdsPAs do
        begin
          if Locate('SENHA', Senha, []) then
          begin
            Edit;
            FieldByName('NomeCliente').AsString := Nome;
            Post;
            Result := True;
          end;
        end;

        with cdsAtds do
        begin
          if Locate('SENHA', Senha, []) then
          begin
            Edit;
            FieldByName('NomeCliente').AsString := Nome;
            Post;
            Result := true;
          end;
        end;
      finally
        cdsPAs.Filtered := bEstavaFiltrandoPAs;
        cdsAtds.Filtered := bEstavaFiltrandoAtds;

        if cdsAtds.BookmarkValid(BM1) then
          cdsAtds.GotoBookmark(BM1);

        if cdsPAs.BookmarkValid(BM2) then
          cdsPAs.GotoBookmark(BM2);
      end;

    finally
      cdsAtds.FreeBookmark(BM1);
      cdsPAs.FreeBookmark(BM2);
    end;
  finally
    cdsPAs.EnableControls;
    cdsAtds.EnableControls;

    grdPAs.EndUpdate;
  end;
end;

procedure TFraSituacaoAtendimento.UpdatePASituation(PA, StatusPA, ATD: Integer; PWD: string; FilaProveniente, MotivoPausa: Integer; TIM: TDateTime; NomeCliente: string);
var
  bEstavaFiltrandoPAs, bEstavaFiltrandoAtds: Boolean;
  AtdLogado, PALogada: Integer;
begin
  try
    AtdLogado := -1;
    PALogada := -1;

    with cdsAtdsClone do
    begin
      if ((Locate('ID_ATD', Atd, [])) and (not FieldByName('ID_PA').IsNull)) then
        PALogada := FieldByName('ID_PA').AsInteger;
    end;

    with cdsPAsClone do
    begin
      if ((Locate('ID_PA', PA, [])) and (not FieldByName('ID_ATD').IsNull)) then
        AtdLogado := FieldByName('ID_ATD').AsInteger;
    end;

    with cdsPAsClone do
    begin
      if PA <> PALogada then
      begin
        if Locate('ID_PA', PALogada, []) then
        begin
          Edit;

          FieldByName('Id_Status').AsInteger:= Integer(spDeslogado);
          FieldByName('ID_ATD').Clear;
          FieldByName('SENHA').Clear;
          FieldByName('ID_FILA').Clear;
          FieldByName('ID_MOTIVOPAUSA').Clear;
          FieldByName('HORARIO').AsDateTime := TIM;

          Post;
        end;
      end;

      if Locate('ID_PA', PA, []) then
      begin
        Edit;

        if StatusPA = -1 then
          FieldByName('Id_Status').AsInteger:= Integer(spDeslogado)
        else
          FieldByName('ID_STATUS').AsInteger := StatusPA;

        if ATD = -1 then
          FieldByName('ID_ATD').Clear
        else
          FieldByName('ID_ATD').AsInteger := ATD;

        if ((PWD = '-1') or (PWD = '---')) then
          FieldByName('SENHA').Clear
        else
          FieldByName('SENHA').AsString := PWD;

        if FilaProveniente = -1 then
          FieldByName('ID_FILA').Clear
        else
          FieldByName('ID_FILA').AsInteger := FilaProveniente;

        if MotivoPausa = -1 then
          FieldByName('ID_MOTIVOPAUSA').Clear
        else
          FieldByName('ID_MOTIVOPAUSA').AsInteger := MotivoPausa;

        FieldByName('HORARIO').AsDateTime   := TIM;
        FieldByName('NomeCliente').AsString := NomeCliente;

        Post;
      end;
    end;

    with cdsAtdsClone do
    begin
      if ATD <> AtdLogado then
      begin
        if Locate('ID_ATD', AtdLogado, []) then
        begin
          Edit;

          FieldByName('Id_Status').AsInteger:= Integer(spDeslogado);
          FieldByName('ID_PA').Clear;
          FieldByName('SENHA').Clear;
          FieldByName('ID_FILA').Clear;
          FieldByName('ID_MOTIVOPAUSA').Clear;
          FieldByName('HORARIO').AsDateTime := TIM;

          Post;
        end;
      end;

      if Locate('ID_ATD', ATD, []) then
      begin
        Edit;

        if StatusPA = -1 then
          FieldByName('Id_Status').AsInteger:= Integer(spDeslogado)
        else
          FieldByName('ID_STATUS').AsInteger := StatusPA;

        if PA = -1 then
          FieldByName('ID_PA').Clear
        else
          FieldByName('ID_PA').AsInteger := PA;

        if ((PWD = '-1') or (PWD = '---')) then
          FieldByName('SENHA').Clear
        else
          FieldByName('SENHA').AsString := PWD;

        if FilaProveniente = -1 then
          FieldByName('ID_FILA').Clear
        else
          FieldByName('ID_FILA').AsInteger := FilaProveniente;

        if MotivoPausa = -1 then
          FieldByName('ID_MOTIVOPAUSA').Clear
        else
          FieldByName('ID_MOTIVOPAUSA').AsInteger := MotivoPausa;

        FieldByName('HORARIO').AsDateTime   := TIM;
        FieldByName('NomeCliente').AsString := NomeCliente;

        Post;
      end;
    end;
  except
    on E: Exception do
      MyLogException(E);
  end;
end;

procedure TFraSituacaoAtendimento.AtualizarResumoPAS;
var
  LDisp, LAten, LDesl, LPaus: Integer;
  LMotivo: String;

  procedure MotivoInc(const AMotivo: String);
  var
    LAtual: Integer;
  begin
    if FResumoMotivosPausa.TryGetValue(AMotivo, LAtual) then
      FResumoMotivosPausa.Items[AMotivo] := LAtual+1
    else
      FResumoMotivosPausa.Add(AMotivo, 1);
  end;

  function GetNomeMotivo(const AMotivoId: String): String;
  var
    LDMClient: TDMClient;
    LRecNo: Integer;
  begin
    LDMClient := DMClient(Self.IDUnidade, not CRIAR_SE_NAO_EXISTIR);
    LDMClient.cdsMotivosPausa.DisableControls;
    try
      LRecNo := LDMClient.cdsMotivosPausa.RecNo;
      if LDMClient.cdsMotivosPausa.Locate('ID', AMotivoId, []) then
        result := LDMClient.cdsMotivosPausa.FieldByName('Nome').AsString
      else
        result := AMotivoId;
    finally
      LDMClient.cdsMotivosPausa.RecNo := LRecNo;
      LDMClient.cdsMotivosPausa.EnableControls;
    end;
  end;

begin
  lblQtdDisponivel.Text := '0';
  lblQtdAtendendo.Text  := '0';
  lblQtdDeslogado.Text  := '0';
  lblQtdEmPausa.Text    := '0';

  if (not cdsPAs.Active) or cdsPAs.IsEmpty then
    exit;

  try
    LDisp := 0;
    LAten := 0;
    LDesl := 0;
    LPaus := 0;
    FResumoMotivosPausa.Clear;

    cdsResumoStatus.Close;

    if TabControl.ActiveTab = tabPAs then
      cdsResumoStatus.CloneCursor(cdsPAs, True, False)
    else
      cdsResumoStatus.CloneCursor(cdsAtds, True, False);

    cdsResumoStatus.First;
    while not cdsResumoStatus.Eof do
    begin
      case cdsResumoStatus.FieldByName('Id_Status').AsInteger of
        0: Inc(LDesl);
        1: Inc(LDisp);
        2: Inc(LAten);
        3: begin
             Inc(LPaus);
             MotivoInc(cdsResumoStatus.FieldByName('Id_MotivoPausa').AsString);
           end;
      end;

      cdsResumoStatus.Next;
    end;

    cdsResumoStatus.Close;

    lblQtdDisponivel.Text := LDisp.ToString;
    lblQtdAtendendo.Text  := LAten.ToString;
    lblQtdDeslogado.Text  := LDesl.ToString;
    lblQtdEmPausa.Text    := LPaus.ToString;

    if LPaus > 0 then
    begin
      lblQtdEmPausa.Text := lblQtdEmPausa.Text + ' (';

      for LMotivo in FResumoMotivosPausa.Keys do
        lblQtdEmPausa.Text := lblQtdEmPausa.Text + GetNomeMotivo(LMotivo) + ': ' + FResumoMotivosPausa.Items[LMotivo].ToString + ', ';

      lblQtdEmPausa.Text := Copy(lblQtdEmPausa.Text, 1, Length(lblQtdEmPausa.Text)-2) + ')';
    end;
  except
    on E: Exception do
      MyLogException(E);
  end;
end;

end.
