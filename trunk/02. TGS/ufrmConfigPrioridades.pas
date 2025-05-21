unit ufrmConfigPrioridades;
//Renomeado unit cfgPrioridades;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  {$IFNDEF IS_MOBILE}
  Windows,
  {$ENDIF IS_MOBILE}
  FMX.Grid, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.ExtCtrls, FMX.Types, FMX.Layouts, FMX.ListView.Types, FMX.ListView,
  FMX.ListBox, untMainForm, Fmx.Bind.DBEngExt, Fmx.Bind.Grid,
  System.Bindings.Outputs, Fmx.Bind.Editors, FMX.Objects, FMX.Edit,
  FMX.TabControl, untCommonDMClient, System.UITypes, System.Types,
  System.SysUtils, System.Classes, System.Variants, Data.DB, Datasnap.DBClient,
  System.Rtti,  Data.Bind.EngExt, Data.Bind.Components, Data.Bind.Grid,
  Data.Bind.DBScope, MyAspFuncoesUteis, untCommonFrameBase, IniFiles, Data.FMTBcd, Datasnap.Provider, FMX.Controls.Presentation, System.ImageList,
  FMX.ImgList, untCommonFormBase, FMX.Effects, FMX.Grid.Style, FMX.ScrollBox,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.DBX.Migrate, uDataSetHelper;

type
  TfrmSicsConfigPrioridades = class(TFrameBase)
    cdsPAs: TClientDataSet;
    dspPAs: TDataSetProvider;
    cdsFilas: TClientDataSet;
    dspFilas: TDataSetProvider;
    qryFilas: TFDQuery;
    dsPAs: TDataSource;
    dsFilas: TDataSource;
    cdsPAs_Filas: TClientDataSet;
    cdsLkupFilas: TClientDataSet;
    dspLkupFilas: TDataSetProvider;
    tblLkupFilas: TFDQuery;
    cdsPAs_FilasID_PA: TIntegerField;
    cdsPAs_FilasID_FILA: TIntegerField;
    cdsPAs_FilasPOSICAO: TIntegerField;
    cdsPAs_FilasLKUP_FILA: TStringField;
    cdsFilasID: TIntegerField;
    cdsFilasNOME: TStringField;
    cdsFilasRANGEMINIMO: TIntegerField;
    cdsFilasRANGEMAXIMO: TIntegerField;
    cdsFilasTROCARMILHAR: TStringField;
    cdsFilasTROCARDEZENADEMILHAR: TStringField;
    cdsFilasMETAESPERA: TSQLTimeStampField;
    cdsFilasPOSICAO: TIntegerField;
    cdsFilasATIVO: TStringField;
    cdsSalvarPAs: TClientDataSet;
    cdsSalvarFilas: TClientDataSet;
    cdsSalvarPAsID: TIntegerField;
    cdsSalvarPAsOBEDECERSEQUENCIAFILAS: TStringField;
    cdsSalvarFilasID: TIntegerField;
    cdsSalvarFilasMETAESPERA: TSQLTimeStampField;
    PageControl: TTabControl;
    TabSheet1: TTabItem;
    TabSheet2: TTabItem;
    gridMetasDeEsperaDasFilas: TGrid;
    lytRodape: TLayout;
    btnSalvar: TButton;
    btnCarregar: TButton;
    btnOK: TButton;
    btnCancela: TButton;
    bndPA: TBindSourceDB;
    LinkListControlToField1: TLinkListControlToField;
    bndFIlas: TBindSourceDB;
    bndPAsFilas: TBindSourceDB;
    chkObedecerOrdem: TCheckBox;
    LinkControlToField1: TLinkControlToField;
    LinkGridMeta: TLinkGridToDataSource;
    qryPAS: TFDQuery;
    cdsFilasNOMENOTICKET: TStringField;
    cdsFilasGERACAOAUTOMATICA: TStringField;
    cdsFilasCODIGOCOR: TIntegerField;
    cdsFilasNOMENOTOTEM: TStringField;
    cdsLkupFilasID: TIntegerField;
    cdsLkupFilasNOME: TStringField;
    cdsLkupFilasRANGEMINIMO: TIntegerField;
    cdsLkupFilasRANGEMAXIMO: TIntegerField;
    cdsLkupFilasTROCARMILHAR: TStringField;
    cdsLkupFilasTROCARDEZENADEMILHAR: TStringField;
    cdsLkupFilasMETAESPERA: TSQLTimeStampField;
    cdsLkupFilasNOMENOTICKET: TStringField;
    cdsLkupFilasGERACAOAUTOMATICA: TStringField;
    cdsLkupFilasPOSICAO: TIntegerField;
    cdsLkupFilasATIVO: TStringField;
    cdsLkupFilasCODIGOCOR: TIntegerField;
    cdsLkupFilasNOMENOTOTEM: TStringField;
    qryPASID: TIntegerField;
    qryPASID_GRUPOPA: TIntegerField;
    qryPASID_PAINEL: TIntegerField;
    qryPASID_FILAAUTOENCAMINHA: TIntegerField;
    qryPASNOME: TStringField;
    qryPASNOMENOPAINEL: TStringField;
    qryPASMAGAZINE: TIntegerField;
    qryPASOBEDECERSEQUENCIAFILAS: TStringField;
    qryPASATIVO: TStringField;
    qryPASPOSICAO: TIntegerField;
    qryPASID_ATENDENTE_AUTOLOGIN: TIntegerField;
    qryPASNOMEPORVOZ: TStringField;
    cdsPAsID: TIntegerField;
    cdsPAsID_GRUPOPA: TIntegerField;
    cdsPAsID_PAINEL: TIntegerField;
    cdsPAsID_FILAAUTOENCAMINHA: TIntegerField;
    cdsPAsNOME: TStringField;
    cdsPAsNOMENOPAINEL: TStringField;
    cdsPAsMAGAZINE: TIntegerField;
    cdsPAsOBEDECERSEQUENCIAFILAS: TStringField;
    cdsPAsATIVO: TStringField;
    cdsPAsPOSICAO: TIntegerField;
    cdsPAsID_ATENDENTE_AUTOLOGIN: TIntegerField;
    cdsPAsNOMEPORVOZ: TStringField;
    Layout1: TLayout;
    btnExcluir: TButton;
    btnIncluir: TButton;
    listOrdem: TGrid;
    lblOrdemAtend: TLabel;
    lblFilasDisp: TLabel;
    cbbPA: TComboBox;
    lblPA: TLabel;
    btnSubir: TButton;
    btnDescer: TButton;
    qryPAs_Filas: TFDQuery;
    dspPAs_Filas: TDataSetProvider;
    dtsPAs_Filas: TDataSource;
    qryPAs_FilasID_PA: TIntegerField;
    qryPAs_FilasID_FILA: TIntegerField;
    qryPAs_FilasPOSICAO: TIntegerField;
    lstFilas: TListBox;
    LinkFillControlToField2: TLinkFillControlToField;
    LinkGridToDataSourcebndPAsFilas: TLinkGridToDataSource;
    LinkFillControlToFieldNOME: TLinkFillControlToField;
    cdsPAs_FilasID_UNIDADE: TIntegerField;
    qryPAs_FilasID_UNIDADE: TIntegerField;
    qryPASID_UNIDADE: TIntegerField;
    cdsPAsID_UNIDADE: TIntegerField;
    cdsFilasID_UNIDADE: TIntegerField;
    procedure btnOKClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnIncluirClick(Sender: TObject);
    procedure cdsPAsReconcileError(DataSet: TCustomClientDataSet;
      E: EReconcileError; UpdateKind: TUpdateKind;
      var Action: TReconcileAction);
    procedure cdsFilasBeforeInsert(DataSet: TDataSet);
    procedure cdsFilasBeforeDelete(DataSet: TDataSet);
    procedure btnSubirClick(Sender: TObject);
    procedure btnDescerClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnCarregarClick(Sender: TObject);
    procedure cdsFilasMETAESPERASetText(Sender: TField;
      const Text: String);
    procedure FrameKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure btnCancelaClick(Sender: TObject);
    procedure cdsPAsAfterOpen(DataSet: TDataSet);
    procedure cdsPAsAfterScroll(DataSet: TDataSet);
    procedure cdsPAsAfterPost(DataSet: TDataSet);
    procedure cdsPAsAfterDelete(DataSet: TDataSet);
    procedure cdsFilasMETAESPERAGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure lstFilasItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure cdsFilasAfterOpen(DataSet: TDataSet);
  private
    FPrimeiraInicializacao: Boolean;
  protected
    ReconcileErrors : string;
    procedure Inicializar;
    procedure TrocaPosicao(PosAtual: Integer; Incrementa: Boolean);
    procedure AjustarCamposPosicaoCds;
    procedure CarregarArquivo(const Path: string);
    procedure SalvarArquivo(const Path: string);
    procedure SetIDUnidade(const Value: Integer); Override;
    procedure FiltrarFilasPorPAs;
  public
    SaveDialog: TSaveDialog;
    OpenDialog: TOpenDialog;
    ProcIDUnidade: TProcIDUnidade;
    function GetContextoCorrente: string; Override;
    function ValidacaoAtivaModoConectado: Boolean; Override;
  	constructor Create(aOwer: TComponent); Override;
  end;

function FrmSicsConfigPrioridades(const aIDUnidade: integer; const aAllowNewInstance: Boolean = False; const aOwner: TComponent = nil): TFrmSicsConfigPrioridades;

implementation

uses untCommonDMConnection, Sics_Common_Parametros;

{$R *.fmx}

type
  TCabecalhoArquivo = record
    TamFilas: Integer;
    TamPas: Integer;
    TamPasFilas: Integer;
  end;

function FrmSicsConfigPrioridades(const aIDUnidade: integer; const aAllowNewInstance: Boolean = False; const aOwner: TComponent = nil): TFrmSicsConfigPrioridades;
begin
  Result := TfrmSicsConfigPrioridades(TfrmSicsConfigPrioridades.GetInstancia(aIDUnidade, aAllowNewInstance, aOwner));
end;

constructor TfrmSicsConfigPrioridades.Create(aOwer: TComponent);
begin
  inherited;
  FPrimeiraInicializacao := True;
  ProcIDUnidade := nil;
  OpenDialog := TOpenDialog.Create(Self);
  OpenDialog.DefaultExt := '.dat';
  OpenDialog.Filter := 'Arquivo de prioridades SICS|*.aps|Todos arquivos|*.*';

  SaveDialog := TSaveDialog.Create(Self);
  SaveDialog.DefaultExt := '.dat';
  SaveDialog.Filter := 'Arquivo de prioridades SICS|*.aps|Todos arquivos|*.*';
  SaveDialog.Options := [TOpenOption.ofOverwritePrompt, TOpenOption.ofHideReadOnly, TOpenOption.ofEnableSizing];
end;

procedure TfrmSicsConfigPrioridades.btnOKClick(Sender: TObject);
begin
  ReconcileErrors := '';

  if cdsPAs.State in dsEditModes then
  begin
    cdsPAs.UpdateRecord;
    cdsPAs.Post;
  end;

  if cdsFilas.State in dsEditModes then
  begin
    cdsFilas.UpdateRecord;
    cdsFilas.Post;
  end;

  if cdsPAs_Filas.State in dsEditModes then
  begin
    cdsPAs_Filas.UpdateRecord;
    cdsPAs_Filas.Post;
  end;

  if ((cdsPAs_Filas.ChangeCount > 0) or (cdsPAs.ChangeCount > 0) or (cdsFilas.ChangeCount > 0)) then
  begin
    cdsPAs.ApplyUpdates(-1);
    cdsFilas.ApplyUpdates(-1);
    cdsPAs_Filas.ApplyUpdates(-1);

    if ((cdsPAs.ChangeCount > 0) or (cdsFilas.ChangeCount > 0) or (cdsPAs_Filas.ChangeCount > 0)) then
      WarningMessage('Atenção! Erros ao aplicar alterações!');

    if Assigned(ProcIDUnidade) then
      ProcIDUnidade(IdUnidade);
  end;
  Visible := False;
end;


procedure TfrmSicsConfigPrioridades.btnExcluirClick(Sender: TObject);
begin
  if (listOrdem.Selected > -1) and (cdsPAs_Filas.recordcount > 0) then
  begin
    cdsPAs_Filas.RecNo := listOrdem.Selected + 1;
    cdsPAs_Filas.Delete;
    AjustarCamposPosicaoCds;
  end;
end;


procedure TfrmSicsConfigPrioridades.btnIncluirClick(Sender: TObject);
var
  Posicao,I : integer;
begin
  if ((cdsFILAs.recordcount > 0)) then
  begin
    for I := 0 to lstFilas.Items.Count -1 do
    begin
      if(lstFilas.ItemByIndex(I).IsChecked)then
      begin
        cdsFilas.RecNo := I + 1;

        if not cdsPAs_Filas.Locate('ID_FILA', cdsFILAs.FieldByName('ID').Value, []) then
        begin
          cdsPAs_Filas.Last;
          Posicao := cdsPAs_Filas.FieldByName('POSICAO').AsInteger + 1;

          cdsPAs_Filas.Append;
          cdsPAs_Filas.FieldByName('ID_PA'  ).Value := cdsPAs.FieldByName('ID').Value;
          cdsPAs_Filas.FieldByName('ID_FILA').Value := cdsFILAs.FieldByName('ID').Value;
          cdsPAs_Filas.FieldByName('POSICAO').Value := Posicao;
          cdsPAs_Filas.Post;
        end;
        //lstFilas.ItemByIndex(I).IsChecked := False;
      end;
    end;
  end;
end;


procedure TfrmSicsConfigPrioridades.cdsPAsAfterDelete(DataSet: TDataSet);
begin
  inherited;

  FiltrarFilasPorPAs;
end;

procedure TfrmSicsConfigPrioridades.cdsPAsAfterOpen(DataSet: TDataSet);
begin
  inherited;
  FiltrarFilasPorPAs;
end;

procedure TfrmSicsConfigPrioridades.cdsPAsAfterPost(DataSet: TDataSet);
begin
  inherited;

  FiltrarFilasPorPAs;
end;

procedure TfrmSicsConfigPrioridades.cdsPAsAfterScroll(DataSet: TDataSet);
begin
  inherited;
  FiltrarFilasPorPAs;
end;

procedure TfrmSicsConfigPrioridades.cdsPAsReconcileError (DataSet: TCustomClientDataSet; E: EReconcileError;
                                                      UpdateKind: TUpdateKind; var Action: TReconcileAction);
begin
  ReconcileErrors := ReconcileErrors + E.Message + #13#10;
end;


procedure TfrmSicsConfigPrioridades.cdsFilasBeforeInsert(DataSet: TDataSet);
begin
  Abort;
end;


procedure TfrmSicsConfigPrioridades.cdsFilasAfterOpen(DataSet: TDataSet);
begin
  inherited;
  lstFilas.Items.Clear;

  cdsFilas.First;

  while not cdsFilas.Eof do
  begin
    lstFilas.Items.Add(cdsFilasNOME.AsString);

    cdsFilas.Next;
  end;
end;

procedure TfrmSicsConfigPrioridades.cdsFilasBeforeDelete(DataSet: TDataSet);
begin
  Abort;
end;

procedure TfrmSicsConfigPrioridades.TrocaPosicao(PosAtual: Integer; Incrementa: Boolean);
var
  PosNova: integer;
begin
  with cdsPAs_Filas do
  begin
    if Locate('POSICAO', PosAtual, []) then
    begin

      if Incrementa then
      begin
        Next;
        if Eof then Exit;
        PosNova := FieldByName('POSICAO').AsInteger;
        Prior;
      end
      else
      begin
        Prior;
        if Bof then Exit;
        PosNova := FieldByName('POSICAO').AsInteger;
        Next;
      end;

      Edit;
      FieldByName('POSICAO').AsInteger := -1000;
      Post;

      if Locate('POSICAO', PosNova, []) then
      begin
        Edit;
        FieldByName('POSICAO').AsInteger := PosAtual;
        Post;

        if Locate('POSICAO', -1000, []) then
        begin
          Edit;
          FieldByName('POSICAO').AsInteger := PosNova;
          Post;
        end;
      end
      else
      begin
        if Locate('POSICAO', -1000, []) then
        begin
          Edit;
          FieldByName('POSICAO').AsInteger := PosAtual;
          Post;
        end;
      end;
    end;
  end;
end;

function TfrmSicsConfigPrioridades.ValidacaoAtivaModoConectado: Boolean;
begin
  Result := cNaoPossuiConexaoDiretoDB;
end;

procedure TfrmSicsConfigPrioridades.btnSubirClick(Sender: TObject);
begin
  if (cdsPAs_Filas.recordcount >= (listOrdem.Selected + 1)) then
  begin
    listOrdem.BeginUpdate;
    try
      cdsPAs_Filas.RecNo := listOrdem.Selected + 1;
      TrocaPosicao(cdsPAs_Filas.FieldByName('POSICAO').AsInteger, False);
      listOrdem.Selected := cdsPAs_Filas.RecNo - 1;
    finally
      listOrdem.EndUpdate;
    end;
  end;
end;


procedure TfrmSicsConfigPrioridades.btnDescerClick(Sender: TObject);
begin
  if (cdsPAs_Filas.RecordCount >= (listOrdem.Selected + 1)) then
  begin
    listOrdem.BeginUpdate;
    try
      cdsPAs_Filas.RecNo := listOrdem.Selected + 1;
      TrocaPosicao(cdsPAs_Filas.FieldByName('POSICAO').AsInteger, True);
      listOrdem.Selected := cdsPAs_Filas.RecNo - 1;
    finally
      listOrdem.EndUpdate;
    end;
  end;
end;

procedure TfrmSicsConfigPrioridades.btnSalvarClick(Sender: TObject);
var
  LContextoAtual: String;
begin
  LContextoAtual := GetContextoCorrente;
  if(SaveDialog.Execute)then
  begin
    if (LContextoAtual = GetContextoCorrente) then
          SalvarArquivo(SaveDialog.FileName)
    else
      ErrorMessage(Format('Contexto foi alterado. De %s para %s.', [LContextoAtual, GetContextoCorrente]));
  end;
end;

procedure TfrmSicsConfigPrioridades.btnCancelaClick(Sender: TObject);
begin
  inherited;
   if cdsPAs.State in dsEditModes then
  begin
    cdsPAs.Cancel;
    cdsPAs.CancelUpdates;
  end;

  if cdsFilas.State in dsEditModes then
  begin
    cdsFilas.Cancel;
    cdsFilas.CancelUpdates;
  end;

  if cdsPAs_Filas.State in dsEditModes then
  begin
    cdsPAs_Filas.Cancel;
    cdsPAs_Filas.CancelUpdates;
  end;
  Visible := False;
end;

procedure TfrmSicsConfigPrioridades.btnCarregarClick(Sender: TObject);
var
  LContextoAtual: String;
begin
  LContextoAtual := GetContextoCorrente;
  if(OpenDialog.Execute)then
  begin
     if (LContextoAtual = GetContextoCorrente) then
        CarregarArquivo(OpenDialog.FileName)
     else
        ErrorMessage(Format('Contexto foi alterado. De %s para %s.', [LContextoAtual, GetContextoCorrente]));
  end;
end;

procedure TfrmSicsConfigPrioridades.FiltrarFilasPorPAs;
begin
  if not (cdspas.Active and cdsPAs_Filas.Active) then
    Exit;
  cdsPAs_Filas.Filtered := False;
  cdsPAs_Filas.Filter := Format('%s = %d', [cdsPAs_FilasID_PA.FieldName, cdspasID.AsInteger]);
  cdsPAs_Filas.Filtered := True;
end;

procedure TfrmSicsConfigPrioridades.FrameKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  {$IFNDEF IS_MOBILE}
  if Key in [VK_NEXT, VK_PRIOR] then
  begin
    cdsPAs.Locate('ID', cbbPA.KeyValue[cdsPAs, 'ID'], []);
    if Key = VK_NEXT then
      cdsPAs.Next
    else
      cdsPas.Prior;

    cbbPA.ItemIndex := cbbPA.Items.IndexOf(cdsPAs.FieldByName('NOME').Value);
  end;
  {$ENDIF IS_MOBILE}
 inherited;
end;

function TfrmSicsConfigPrioridades.GetContextoCorrente: string;
begin
  Result := Format('PA: %d, ID Fila: %d, ID Ordem Fila: %d.', [cdsPAsID.AsInteger, cdsFilasID.AsInteger, cdsPAs_FilasID_FILA.AsInteger]);
end;

procedure TfrmSicsConfigPrioridades.AjustarCamposPosicaoCds;
var
  Posicao: Integer;
begin
  with cdsPAs_Filas do
  begin
    First;
    Posicao := 0;
    while not Eof do
    begin
      Edit;
      FieldByName('POSICAO').AsInteger := Posicao;
      Post;
      Next;
      Inc(Posicao);
    end;
  end;
end;

procedure TfrmSicsConfigPrioridades.cdsFilasMETAESPERAGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  inherited;

  Text := FormatDateTime('nn:ss', Sender.asdateTime);
end;

procedure TfrmSicsConfigPrioridades.cdsFilasMETAESPERASetText(Sender: TField;
  const Text: String);
begin
  if Text <> '' then
    Sender.AsString := '00:' + Text;
end;

procedure TfrmSicsConfigPrioridades.CarregarArquivo(const Path: string);
var
  msPAs, msFilas, msPAsFilas: TMemoryStream;
  FileStream: TFileStream;
  Cabecalho: TCabecalhoArquivo;
  FCDSPAS_FILAs: TClientDataSet;
begin
  msPAs := nil;
  msFilas := nil;
  msPAsFilas := nil;
  FileStream := nil;
  try
    msPAs := TMemoryStream.Create;
    msFilas := TMemoryStream.Create;
    msPAsFilas := TMemoryStream.Create;
    FileStream := TFileStream.Create(Path, fmOpenRead);

    FileStream.ReadBuffer(Cabecalho, SizeOf(TCabecalhoArquivo));

    msPAs.CopyFrom(FileStream, Cabecalho.TamPAs);
    msFilas.CopyFrom(FileStream, Cabecalho.TamFilas);
    msPAsFilas.CopyFrom(FileStream, Cabecalho.TamPAsFilas);

    msPAs.Seek(0, soFromBeginning);
    msFilas.Seek(0, soFromBeginning);
    msPAsFilas.Seek(0, soFromBeginning);

    // carregando dados das PAs
    cdsSalvarPAs.LoadFromStream(msPAs);
    with cdsPAS do
    begin
      First;
      while not Eof do
      begin
        if cdsSalvarPAs.Locate('ID', FieldByName('ID').Value, []) then
        begin
          Edit;
          FieldByName('OBEDECERSEQUENCIAFILAS').Value := cdsSalvarPAs.FieldByName('OBEDECERSEQUENCIAFILAS').Value;
          Post;
        end;
        Next;
      end;
    end;

    // carregando dados das Filas
    cdsSalvarFilas.LoadFromStream(msFilas);
    with cdsFilas do
    begin
      First;
      while not Eof do
      begin
        if cdsSalvarFilas.Locate('ID', FieldByName('ID').Value, []) then
        begin
          Edit;
          FieldByName('METAESPERA').Value := cdsSalvarFilas.FieldByName('METAESPERA').Value;
          Post;
        end;
        Next;
      end;
    end;

    // carregando dados das PAS_FILAs
    FCDSPAS_FILAs := TClientDataSet.Create(Self);
    with FCDSPAS_FILAs do
    try
      LoadFromStream(msPAsFilas);

      cdsPAS.First;
      while not cdsPAS.Eof do
      begin
        while not cdsPAs_Filas.IsEmpty do
          cdsPAs_Filas.Delete;
        cdsPAs.Next;
      end;

      First;
      while not Eof do
      begin
        if cdsPAs.Locate('ID', FieldByName('ID_PA').Value, []) then
        begin
          cdsPAs_Filas.Append;
          cdsPAs_Filas.FieldByName('ID_PA').Value   := FieldByName('ID_PA').Value;
          cdsPAs_Filas.FieldByName('ID_FILA').Value := FieldByName('ID_FILA').Value;
          cdsPAs_Filas.FieldByName('POSICAO').Value := FieldByName('POSICAO').Value;
          cdsPAs_Filas.Post;
        end;
        Next;
      end;

      cdsPAS.Locate('ID', cbbPA.KeyValue[cdsPAs, 'ID'], []);

    finally
      FreeAndNil(FCDSPAS_FILAs);
    end;

  finally
    FreeAndNil(msPAs);
    FreeAndNil(msFilas);
    FreeAndNil(msPAsFilas);
    FreeAndNil(FileStream);
  end;
end;

procedure TfrmSicsConfigPrioridades.SalvarArquivo(const Path: string);
var
  msPAS, msFilas, msPASFilas: TMemoryStream;
  Cabecalho: TCabecalhoArquivo;
  FileStream: TFileStream;
  FCdsmsPASFilas: TClientDataSet;
begin
  FCdsmsPASFilas := nil;
  msPAS := nil;
  msFilas := nil;
  msPASFilas := nil;
  try
    msPAs := TMemoryStream.Create;
    msFilas := TMemoryStream.Create;
    msPAsFilas := TMemoryStream.Create;

    // guardando dados das PAS (parcial)
    if not cdsSalvarPAs.Active then
      cdsSalvarPAs.CreateDataSet
    else
      cdsSalvarPAs.EmptyDataSet;
    with cdsPAS do
    begin
      First;
      while not Eof do
      begin
        cdsSalvarPAs.Append;
        cdsSalvarPAs.FieldByName('ID').Value := FieldByName('ID').Value;
        cdsSalvarPAs.FieldByName('OBEDECERSEQUENCIAFILAS').Value := FieldByName('OBEDECERSEQUENCIAFILAS').Value;
        cdsSalvarPAs.Post;
        Next;
      end;
    end;
    cdsSalvarPAs.SaveToStream(msPAS);

    // guardando dados das FILAS (parcial)
    if not cdsSalvarFilas.Active then
      cdsSalvarFilas.CreateDataSet
    else
      cdsSalvarFilas.EmptyDataSet;
    with cdsFilas do
    begin
      First;
      while not Eof do
      begin
        cdsSalvarFilas.Append;
        cdsSalvarFilas.FieldByName('ID').Value := FieldByName('ID').Value;
        cdsSalvarFilas.FieldByName('METAESPERA').Value := FieldByName('METAESPERA').Value;
        cdsSalvarFilas.Post;
        Next;
      end;
    end;
    cdsSalvarFilas.SaveToStream(msFilas);

    // guardando dados das PAS_FILAS (tudo)
	  FCdsmsPASFilas := TClientDataSet.Create(Self);
    with FCdsmsPASFilas do
    begin
      FCdsmsPASFilas.Data := cdsPAs_Filas.Data;
      FCdsmsPASFilas.SaveToStream(msPASFilas);
    end;

    with Cabecalho do
    begin
      TamPAs := msPAs.Size;
      TamFilas := msFilas.Size;
      TamPAsFilas := msPAsFilas.Size;
    end;

    msPAs.Seek(0, soFromBeginning);
    msFilas.Seek(0, soFromBeginning);
    msPAsFilas.Seek(0, soFromBeginning);

    FileStream := TFileStream.Create(SaveDialog.FileName, fmCreate);
    try
      FileStream.WriteBuffer(Cabecalho, SizeOf(TCabecalhoArquivo));
      FileStream.CopyFrom(msPaS, msPAs.Size);
      FileStream.CopyFrom(msFilas, msFilas.Size);
      FileStream.CopyFrom(msPAsFilas, msPAsFilas.Size);
    finally
      FreeAndNil(FileStream);
    end;

  finally
    FreeAndNil(msPAS);
    FreeAndNil(msFilas);
    FreeAndNil(msPASFilas);
    FreeAndNil(FCdsmsPASFilas);
  end;
end;

procedure TfrmSicsConfigPrioridades.SetIdUnidade(const Value: Integer);
begin
  if (IDUnidade <> Value) or FPrimeiraInicializacao then
  begin
    inherited;
    Inicializar;
  end;
end;

procedure TfrmSicsConfigPrioridades.Inicializar;
begin
  DMClient(IDunidade, not CRIAR_SE_NAO_EXISTIR).SetNewSqlConnectionForSQLDataSet(Self);

  if FPrimeiraInicializacao then
  begin
    FPrimeiraInicializacao := False;

    cdsPAs.Open;
    cdsFilas.Open;
    cdsLkupFilas.Open;
    cdsPAs_Filas.Open;
  end
  else
    CloseOpenNosCDSsAtivos;

  FiltrarFilasPorPAs;
  AspUpdateColunasGrid(Self, bndList);
end;

procedure TfrmSicsConfigPrioridades.lstFilasItemClick(
  const Sender: TCustomListBox; const Item: TListBoxItem);
begin
  inherited;
  Item.IsChecked := not Item.IsChecked;
end;

end.
