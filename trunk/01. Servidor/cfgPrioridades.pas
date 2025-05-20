unit cfgPrioridades;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FMTBcd, DBGrids, DB, DBCtrls, ComCtrls, Provider,
  DBClient, Sics_94, MyDlls_DR, ClassLibraryVCL, StdCtrls, Buttons,
  ExtCtrls,
  ASPDbGrid,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Comp.Client, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt, uDataSetHelper, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Comp.DataSet, Vcl.Grids;

type
  TfrmSicsConfigPrioridades = class(TForm)
    qryPAs: TFDQuery;
    cdsPAs: TClientDataSet;
    dspPAs: TDataSetProvider;
    cdsFilas: TClientDataSet;
    dspFilas: TDataSetProvider;
    qryFilas: TFDQuery;
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    dsPAs: TDataSource;
    dsFilas: TDataSource;
    listOrdem: TASPDbGrid;
    qryPAs_Filas: TFDQuery;
    cdsPAs_Filas: TClientDataSet;
    dsPAs_Filas: TDataSource;
    dsLinkPA: TDataSource;
    cdsPAsID: TIntegerField;
    cdsPAsID_GRUPOPA: TIntegerField;
    cdsPAsID_PAINEL: TIntegerField;
    cdsPAsID_FILAAUTOENCAMINHA: TIntegerField;
    cdsPAsNOME: TStringField;
    cdsPAsNOMENOPAINEL: TStringField;
    cdsPAsMAGAZINE: TIntegerField;
    cdsPAsOBEDECERSEQUENCIAFILAS: TStringField;
    cdsPAsATIVO: TStringField;
    cdsPAsqryPAs_Filas: TDataSetField;
    cdsLkupFilas: TClientDataSet;
    dspLkupFilas: TDataSetProvider;
    qryLkupFilas: TFDQuery;
    cdsPAs_FilasID_PA: TIntegerField;
    cdsPAs_FilasID_FILA: TIntegerField;
    cdsPAs_FilasPOSICAO: TIntegerField;
    cdsPAs_FilasLKUP_FILA: TStringField;
    chkObedecerOrdem: TDBCheckBox;
    cdsFilasID: TIntegerField;
    cdsFilasNOME: TStringField;
    cdsFilasRANGEMINIMO: TIntegerField;
    cdsFilasRANGEMAXIMO: TIntegerField;
    cdsFilasTROCARMILHAR: TStringField;
    cdsFilasTROCARDEZENADEMILHAR: TStringField;
    cdsFilasMETAESPERA: TSQLTimeStampField;
    cdsFilasPOSICAO: TIntegerField;
    gridMetasDeEsperaDasFilas: TDBGrid;
    btnSubir: TBitBtn;
    btnDescer: TBitBtn;
    listFilas: TASPDbGrid;
    btnExcluir: TButton;
    btnIncluir: TButton;
    cmbPA: TDBLookupComboBox;
    btnCarregar: TBitBtn;
    btnSalvar: TBitBtn;
    btnOK: TButton;
    btnCancela: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    SaveDialog: TSaveDialog;
    OpenDialog: TOpenDialog;
    cdsFilasATIVO: TStringField;
    cdsSalvarPAs: TClientDataSet;
    cdsSalvarFilas: TClientDataSet;
    cdsSalvarPAsID: TIntegerField;
    cdsSalvarPAsOBEDECERSEQUENCIAFILAS: TStringField;
    cdsSalvarFilasID: TIntegerField;
    cdsSalvarFilasMETAESPERA: TSQLTimeStampField;
    cdsPAsID_UNIDADE: TIntegerField;
    cdsPAsPOSICAO: TIntegerField;
    cdsPAsID_ATENDENTE_AUTOLOGIN: TIntegerField;
    cdsPAsNOMEPORVOZ: TStringField;
    cdsFilasID_UNIDADE: TIntegerField;
    cdsPAs_FilasID_UNIDADE: TIntegerField;
    procedure btnOKClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnIncluirClick(Sender: TObject);
    procedure cdsPAsReconcileError(DataSet: TCustomClientDataSet;
      E: EReconcileError; UpdateKind: TUpdateKind;
      var Action: TReconcileAction);
    procedure FormCreate(Sender: TObject);
    procedure cdsFilasBeforeInsert(DataSet: TDataSet);
    procedure cdsFilasBeforeDelete(DataSet: TDataSet);
    procedure gridMetasDeEsperaDasFilasColEnter(Sender: TObject);
    procedure btnSubirClick(Sender: TObject);
    procedure btnDescerClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnCarregarClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cdsFilasMETAESPERASetText(Sender: TField; const Text: String);

  private
    FSqlConnUnidade: TFDConnection;
    ReconcileErrors: string;
    procedure Inicializar(IdUnidade: Integer);
    procedure TrocaPosicao(PosAtual: Integer; Incrementa: Boolean);
    procedure AjustarCamposPosicaoCds;
    procedure CarregarArquivo(const Path: string);
    procedure SalvarArquivo(const Path: string);
  public
    class function ExibeForm(var IdUnidade: Integer): Boolean;
  end;

implementation

uses
  udmContingencia;

{$R *.dfm}

type
  TCabecalhoArquivo = record
    TamFilas: Integer;
    TamPas: Integer;
    TamPasFilas: Integer;
  end;

class function TfrmSicsConfigPrioridades.ExibeForm(var IdUnidade
  : Integer): Boolean;
var
  LfrmSicsConfigPrioridades: TfrmSicsConfigPrioridades;
begin
  IdUnidade := dmSicsMain.CheckPromptUnidade;

  LfrmSicsConfigPrioridades := TfrmSicsConfigPrioridades.Create(Application);
  with LfrmSicsConfigPrioridades do
  try
    Inicializar(IdUnidade);
    Result := ShowModal = mrOK;
  finally
    FreeAndNil(LfrmSicsConfigPrioridades);
  end;  { try .. finally }
end;  { func NConfigPrioridades }


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

  if ((cdsPAs.ChangeCount > 0) or (cdsFilas.ChangeCount > 0)) then
  begin
    cdsPAs.ApplyUpdates(-1);
    cdsFilas.ApplyUpdates(-1);

    if ((cdsPAs.ChangeCount > 0) or (cdsFilas.ChangeCount > 0)) then
      ErrorMessage('Atenção! Erros ao aplicar alterações!' + #13 +
        ReconcileErrors)
    else
      dmSicsContingencia.CheckReplicarTabelasP2C;

    dmSicsMain.CarregaTabelasPAsEFilas;

    ModalResult := mrOK;
  end
  else
    ModalResult := mrCancel;
end;


procedure TfrmSicsConfigPrioridades.btnExcluirClick(Sender: TObject);
var
  i: Integer;
begin
  if listOrdem.SelectedRows.Count > 0 then
  begin
    for i := listOrdem.SelectedRows.Count - 1 downto 0 do
    begin
      cdsPAs_Filas.GotoBookmark(listOrdem.SelectedRows.Items[i]);
      cdsPAs_Filas.Delete;

      listOrdem.SelectedRows.Refresh;
    end;
    AjustarCamposPosicaoCds;
  end;
end;


procedure TfrmSicsConfigPrioridades.btnIncluirClick(Sender: TObject);
var
  i, Posicao: Integer;
begin
  if listFilas.SelectedRows.Count > 0 then
    for i := 0 to listFilas.SelectedRows.Count - 1 do
    begin
      cdsFilas.GotoBookmark(listFilas.SelectedRows.Items[i]);

      if not cdsPAs_Filas.Locate('ID_FILA', cdsFilas.FieldByName('ID').Value, [])
      then
      begin
        cdsPAs_Filas.Last;
        Posicao := cdsPAs_Filas.FieldByName('POSICAO').AsInteger + 1;

        cdsPAs_Filas.Append;
        cdsPAs_Filas.FieldByName('ID_PA').Value :=
          cdsPAs.FieldByName('ID').Value;
        cdsPAs_Filas.FieldByName('ID_FILA').Value :=
          cdsFilas.FieldByName('ID').Value;
        cdsPAs_Filas.FieldByName('POSICAO').Value := Posicao;
        cdsPAs_Filas.Post;
      end;
    end;
end;

procedure TfrmSicsConfigPrioridades.cdsPAsReconcileError
  (DataSet: TCustomClientDataSet; E: EReconcileError; UpdateKind: TUpdateKind;
  var Action: TReconcileAction);
begin
  ReconcileErrors := ReconcileErrors + E.Message + #13#10;
end;


procedure TfrmSicsConfigPrioridades.FormCreate(Sender: TObject);
begin
  if dmSicsContingencia.TipoFuncionamento = tfContingente then
    btnOK.Enabled := False;

  LoadPosition(Sender as TForm);
end;


procedure TfrmSicsConfigPrioridades.cdsFilasBeforeInsert(DataSet: TDataSet);
begin
  SysUtils.Abort;
end;


procedure TfrmSicsConfigPrioridades.cdsFilasBeforeDelete(DataSet: TDataSet);
begin
  SysUtils.Abort;
end;

procedure TfrmSicsConfigPrioridades.gridMetasDeEsperaDasFilasColEnter
  (Sender: TObject);
begin
  with gridMetasDeEsperaDasFilas do
    if ((SelectedField <> nil) and (SelectedField.FieldName = 'NOME')) then
      Options := Options - [dgEditing]
    else
      Options := Options + [dgEditing];
end;

procedure TfrmSicsConfigPrioridades.TrocaPosicao(PosAtual: Integer;
  Incrementa: Boolean);
var
  PosNova: Integer;
begin
  with cdsPAs_Filas do
  begin
    if Locate('POSICAO', PosAtual, []) then
    begin

      if Incrementa then
      begin
        Next;
        if Eof then
          Exit;
        PosNova := FieldByName('POSICAO').AsInteger;
        Prior;
      end
      else
      begin
        Prior;
        if Bof then
          Exit;
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

        Locate('POSICAO', -1000, []);
        Edit;
        FieldByName('POSICAO').AsInteger := PosNova;
        Post;
      end
      else
      begin
        Locate('POSICAO', -1000, []);
        Edit;
        FieldByName('POSICAO').AsInteger := PosAtual;
        Post;
      end;
    end;
  end;
end;

procedure TfrmSicsConfigPrioridades.btnSubirClick(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to listOrdem.SelectedRows.Count - 1 do
  begin
    if i < listOrdem.SelectedRows.Count then
    begin
      cdsPAs_Filas.GotoBookmark(listOrdem.SelectedRows.Items[i]);

      if ((cdsPAs_Filas.RecNo = 1) and (listOrdem.SelectedRows.Count > 1)) then
        TrocaPosicao(cdsPAs_Filas.FieldByName('POSICAO').AsInteger, True)
      else
        TrocaPosicao(cdsPAs_Filas.FieldByName('POSICAO').AsInteger, False);

      listOrdem.SelectedRows.Clear;

      listOrdem.SelectedRows.CurrentRowSelected := True;
    end;
  end;
end;


procedure TfrmSicsConfigPrioridades.btnDescerClick(Sender: TObject);
var
  i: Integer;
begin
  if listOrdem.SelectedRows.Count > 0 then
    for i := listOrdem.SelectedRows.Count - 1 downto 0 do
    begin
      cdsPAs_Filas.GotoBookmark(listOrdem.SelectedRows.Items[i]);

      TrocaPosicao(cdsPAs_Filas.FieldByName('POSICAO').AsInteger, True);

      listOrdem.SelectedRows.Clear;

      listOrdem.SelectedRows.CurrentRowSelected := True;
    end;
end;


procedure TfrmSicsConfigPrioridades.btnSalvarClick(Sender: TObject);
begin
  with SaveDialog do
    if Execute then
      SalvarArquivo(FileName);
end;


procedure TfrmSicsConfigPrioridades.btnCarregarClick(Sender: TObject);
begin
  with OpenDialog do
    if Execute then
      CarregarArquivo(FileName);
end;

procedure TfrmSicsConfigPrioridades.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key in [VK_NEXT, VK_PRIOR] then
  begin
    cdsPAs.Locate('ID', cmbPA.KeyValue, []);
    if Key = VK_NEXT then
      cdsPAs.Next
    else
      cdsPAs.Prior;

    cmbPA.KeyValue := cdsPAs.FieldByName('ID').Value;
  end;
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

procedure TfrmSicsConfigPrioridades.FormResize(Sender: TObject);
const
  OFF = 5;
begin
  PageControl.Left   := OFF;
  PageControl.Top    := OFF;
  PageControl.Width := ClientWidth - 2 * OFF;
  PageControl.Height := ClientHeight - btnOK.Height - 3 * OFF;

  Label1.Left := OFF;
  Label1.Top  := OFF + (cmbPA.Height - Label1.Height) div 2;
  cmbPA.Top   := OFF;
  cmbPA.Left  := Label1.Left + Label1.Width + OFF;
  cmbPA.Width := TabSheet1.ClientWidth - cmbPA.Left - OFF;

  Label2.Top := cmbPA.Top + cmbPA.Height + 2 * OFF;
  Label2.Left           := OFF;
  listFilas.Left        := Label2.Left;
  listFilas.Top         := Label2.Top + Label2.Height + OFF;
  listFilas.Width := (TabSheet1.ClientWidth - btnIncluir.Width - btnSubir.Width
    - 5 * OFF) div 2;
  listFilas.Height := TabSheet1.ClientHeight - Label2.Height - cmbPA.Height
    - 5 * OFF;
  btnIncluir.Top        := listFilas.Top;
  btnIncluir.Left       := listFilas.Left + listFilas.Width + OFF;
  btnExcluir.Top        := btnIncluir.Top + btnIncluir.Height + 2 * OFF;
  btnExcluir.Left       := btnIncluir.Left;
  Label3.Top := cmbPA.Top + cmbPA.Height + 2 * OFF;
  Label3.Left           := btnIncluir.Left + btnIncluir.Width + OFF;
  listOrdem.Left        := Label3.Left;
  listOrdem.Top         := listFilas.Top;
  listOrdem.Height      := listFilas.Height - chkObedecerOrdem.Height - OFF;
  listOrdem.Width       := listFilas.Width;
  btnSubir.Left         := listOrdem.Left + listOrdem.Width + OFF;
  btnSubir.Top          := btnIncluir.Top;
  btnDescer.Left        := btnSubir.Left;
  btnDescer.Top         := btnSubir.Top + btnSubir.Height + OFF;
  chkObedecerOrdem.Left := listOrdem.Left;
  chkObedecerOrdem.Top := listFilas.Top + listFilas.Height -
    chkObedecerOrdem.Height;

  gridMetasDeEsperaDasFilas.Left   := OFF;
  gridMetasDeEsperaDasFilas.Top    := OFF;
  gridMetasDeEsperaDasFilas.Width := TabSheet2.ClientWidth - 2 * OFF;
  gridMetasDeEsperaDasFilas.Height := TabSheet2.ClientHeight - 2 * OFF;

  gridMetasDeEsperaDasFilas.Columns[1].Width :=
    Canvas.TextWidth('      Meta de Espera      ');
  gridMetasDeEsperaDasFilas.Columns[0].Width :=
    gridMetasDeEsperaDasFilas.ClientWidth - gridMetasDeEsperaDasFilas.Columns[1]
    .Width - 2;

  btnCarregar.Left := OFF;
  btnCarregar.Top  := ClientHeight - btnCarregar.Height - OFF;
  btnSalvar.Left   := btnCarregar.Left + btnCarregar.Width + OFF;
  btnSalvar.Top    := btnCarregar.Top;
  btnCancela.Left  := ClientWidth - btnCancela.Width - OFF;
  btnCancela.Top   := btnCarregar.Top;
  btnOK.Left := btnCancela.Left - btnOK.Width - OFF;
  btnOK.Top := btnCarregar.Top;

  gridMetasDeEsperaDasFilas.Repaint;

  listOrdem.Repaint;
  listFilas.Repaint;

  with listOrdem do
    Columns.Items[0].Width := ClientWidth;
  with listFilas do
    Columns.Items[0].Width := ClientWidth;
end;

procedure TfrmSicsConfigPrioridades.FormDestroy(Sender: TObject);
begin
  SavePosition(Sender as TForm);
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
  FCDSPAsFilas: TClientDataSet;
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

    msPAs.CopyFrom(FileStream, Cabecalho.TamPas);
    msFilas.CopyFrom(FileStream, Cabecalho.TamFilas);
    msPAsFilas.CopyFrom(FileStream, Cabecalho.TamPasFilas);

    msPAs.Seek(0, soFromBeginning);
    msFilas.Seek(0, soFromBeginning);
    msPAsFilas.Seek(0, soFromBeginning);

    // carregando dados das PAs
    cdsSalvarPAs.LoadFromStream(msPAs);
    with cdsPAs do
    begin
      First;
      while not Eof do
      begin
        if cdsSalvarPAs.Locate('ID', FieldByName('ID').Value, []) then
        begin
          Edit;
          FieldByName('OBEDECERSEQUENCIAFILAS').Value :=
            cdsSalvarPAs.FieldByName('OBEDECERSEQUENCIAFILAS').Value;
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
          FieldByName('METAESPERA').Value := cdsSalvarFilas.FieldByName
            ('METAESPERA').Value;
          Post;
        end;
        Next;
      end;
    end;

    // carregando dados das PAS_FILAs
    FCDSPAsFilas := TClientDataSet.Create(Self);
    with FCDSPAsFilas do
    try
      LoadFromStream(msPAsFilas);

        cdsPAs.First;
        while not cdsPAs.Eof do
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
            cdsPAs_Filas.FieldByName('ID_PA').Value :=
              FieldByName('ID_PA').Value;
            cdsPAs_Filas.FieldByName('ID_FILA').Value :=
              FieldByName('ID_FILA').Value;
            cdsPAs_Filas.FieldByName('POSICAO').Value :=
              FieldByName('POSICAO').Value;
          cdsPAs_Filas.Post;
        end;
        Next;
      end;

        cdsPAs.Locate('ID', cmbPA.KeyValue, []);

    finally
      FreeAndNil(FCDSPAsFilas);
    end;

  finally
    msPAs.Free;
    msFilas.Free;
    msPAsFilas.Free;
    FileStream.Free;
  end;
end;

procedure TfrmSicsConfigPrioridades.SalvarArquivo(const Path: string);
var
  msPAs, msFilas, msPAsFilas: TMemoryStream;
  Cabecalho: TCabecalhoArquivo;
  FileStream: TFileStream;
begin
  msPAs := nil;
  msFilas := nil;
  msPAsFilas := nil;
  try
    msPAs := TMemoryStream.Create;
    msFilas := TMemoryStream.Create;
    msPAsFilas := TMemoryStream.Create;

    // guardando dados das PAS (parcial)
    if not cdsSalvarPAs.Active then
      cdsSalvarPAs.CreateDataSet
    else
      cdsSalvarPAs.EmptyDataSet;
    with cdsPAs do
    begin
      First;
      while not Eof do
      begin
        cdsSalvarPAs.Append;
        cdsSalvarPAs.FieldByName('ID').Value := FieldByName('ID').Value;
        cdsSalvarPAs.FieldByName('OBEDECERSEQUENCIAFILAS').Value :=
          FieldByName('OBEDECERSEQUENCIAFILAS').Value;
        cdsSalvarPAs.Post;
        Next;
      end;
    end;
    cdsSalvarPAs.SaveToStream(msPAs);

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
        cdsSalvarFilas.FieldByName('METAESPERA').Value :=
          FieldByName('METAESPERA').Value;
        cdsSalvarFilas.Post;
        Next;
      end;
    end;
    cdsSalvarFilas.SaveToStream(msFilas);

    // guardando dados das PAS_FILAS (tudo)
    with TClientDataSet.Create(Self) do
    begin
      Data := cdsPAs_Filas.Data;
      SaveToStream(msPAsFilas);
    end;

    with Cabecalho do
    begin
      TamPas := msPAs.Size;
      TamFilas := msFilas.Size;
      TamPasFilas := msPAsFilas.Size;
    end;

    msPAs.Seek(0, soFromBeginning);
    msFilas.Seek(0, soFromBeginning);
    msPAsFilas.Seek(0, soFromBeginning);

    FileStream := TFileStream.Create(SaveDialog.FileName, fmCreate);
    try
      FileStream.WriteBuffer(Cabecalho, SizeOf(TCabecalhoArquivo));
      FileStream.CopyFrom(msPAs, msPAs.Size);
      FileStream.CopyFrom(msFilas, msFilas.Size);
      FileStream.CopyFrom(msPAsFilas, msPAsFilas.Size);
    finally
      FileStream.Free;
    end;

  finally
    msPAs.Free;
    msFilas.Free;
    msPAsFilas.Free;
  end;
end;

procedure TfrmSicsConfigPrioridades.Inicializar(IdUnidade: Integer);
begin
  if IdUnidade > 0 then
    FSqlConnUnidade := dmSicsMain.CreateSqlConnUnidade(Self, IdUnidade)
  else
    FSqlConnUnidade := dmSicsMain.connOnLine;

  dmSicsMain.SetNewSqlConnectionForSQLDataSet(Self, FSqlConnUnidade);

  cdsPAs.Close;
  cdsPAs.Open;

  cdsFilas.Close;
  cdsFilas.Open;

  cdsLkupFilas.Close;
  cdsLkupFilas.Open;

  cmbPA.KeyValue := cdsPAs.FieldByName('ID').Value;
end;

end.
