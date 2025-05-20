unit udmCadTotens;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}
uses
  MyDlls_DR,  MyAspFuncoesUteis_VCL,
  SysUtils, Classes, FMTBcd, Provider, DB, DBClient,Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, uDataSetHelper,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf;

type
  TdmSicsCadTotens = class(TDataModule)
    cdsTotens: TClientDataSet;
    dspTotens: TDataSetProvider;
    qryTotens: TFDQuery;
    qryTotensID: TIntegerField;
    qryTotensIP: TStringField;
    qryTotensIDFILA_BOTAO1: TIntegerField;
    qryTotensIDFILA_BOTAO2: TIntegerField;
    qryTotensIDFILA_BOTAO3: TIntegerField;
    qryTotensIDFILA_BOTAO4: TIntegerField;
    qryTotensIDFILA_BOTAO5: TIntegerField;
    qryTotensIDFILA_BOTAO6: TIntegerField;
    qryTotensIDFILA_BOTAO7: TIntegerField;
    qryTotensIDFILA_BOTAO8: TIntegerField;
    cdsTotensID: TIntegerField;
    cdsTotensIP: TStringField;
    cdsTotensIDFILA_BOTAO1: TIntegerField;
    cdsTotensIDFILA_BOTAO2: TIntegerField;
    cdsTotensIDFILA_BOTAO3: TIntegerField;
    cdsTotensIDFILA_BOTAO4: TIntegerField;
    cdsTotensIDFILA_BOTAO5: TIntegerField;
    cdsTotensIDFILA_BOTAO6: TIntegerField;
    cdsTotensIDFILA_BOTAO7: TIntegerField;
    cdsTotensIDFILA_BOTAO8: TIntegerField;
    cdsLkpModeloToten: TClientDataSet;
    cdsLkpModeloTotenDESCRICAO: TStringField;
    cdsLkpFilas: TClientDataSet;
    dspLkpFilas: TDataSetProvider;
    qryLkpFilas: TFDQuery;
    cdsLkpModeloTotenID: TIntegerField;
    qryTotensID_MODELOTOTEM: TIntegerField;
    cdsTotensID_MODELOTOTEM: TIntegerField;
    cdsTotensLKP_MODELO: TStringField;
    qryTotensNOME: TStringField;
    cdsTotensNOME: TStringField;
    qryTotensOPCOES_PICOTEENTREVIAS: TStringField;
    qryTotensOPCOES_CORTEPARCIALAOFINAL: TStringField;
    qryTotensOPCOES_CDBSENHAS: TStringField;
    qryTotensOPCOES_DATAHORANA2AVIA: TStringField;
    cdsTotensOPCOES_PICOTEENTREVIAS: TStringField;
    cdsTotensOPCOES_CORTEPARCIALAOFINAL: TStringField;
    cdsTotensOPCOES_CDBSENHAS: TStringField;
    cdsTotensOPCOES_DATAHORANA2AVIA: TStringField;              
    qryTotensOPCOES_NOMEFILANA2AVIA: TStringField;
    cdsTotensOPCOES_NOMEFILANA2AVIA: TStringField;
    qryTotensFILAS_PERMITIDAS: TStringField;
    qryTotensBOTOES_COLUNAS: TIntegerField;
    qryTotensBOTOES_TRANSPARENTES: TStringField;
    qryTotensBOTOES_MARGEM_SUPERIOR: TIntegerField;
    qryTotensBOTOES_MARGEM_INFERIOR: TIntegerField;
    qryTotensBOTOES_MARGEM_DIREITA: TIntegerField;
    qryTotensBOTOES_MARGEM_ESQUERDA: TIntegerField;
    qryTotensBOTOES_ESPACO_COLUNAS: TIntegerField;
    qryTotensBOTOES_ESPACO_LINHAS: TIntegerField;
    qryTotensPORTA_TCP: TIntegerField;
    qryTotensIMAGEM_FUNDO: TStringField;
    qryTotensPORTA_SERIAL_IMPRESSORA: TStringField;
    qryTotensMOSTRAR_BOTAO_FECHAR: TStringField;
    qryTotensBOTAO_FECHAR_TAM_MAIOR: TStringField;
    qryTotensPODE_FECHAR_PROGRAMA: TStringField;
    cdsTotensFILAS_PERMITIDAS: TStringField;
    cdsTotensBOTOES_COLUNAS: TIntegerField;
    cdsTotensBOTOES_TRANSPARENTES: TStringField;
    cdsTotensBOTOES_MARGEM_SUPERIOR: TIntegerField;
    cdsTotensBOTOES_MARGEM_INFERIOR: TIntegerField;
    cdsTotensBOTOES_MARGEM_DIREITA: TIntegerField;
    cdsTotensBOTOES_MARGEM_ESQUERDA: TIntegerField;
    cdsTotensBOTOES_ESPACO_COLUNAS: TIntegerField;
    cdsTotensBOTOES_ESPACO_LINHAS: TIntegerField;
    cdsTotensPORTA_TCP: TIntegerField;
    cdsTotensIMAGEM_FUNDO: TStringField;
    cdsTotensPORTA_SERIAL_IMPRESSORA: TStringField;
    cdsTotensMOSTRAR_BOTAO_FECHAR: TStringField;
    cdsTotensBOTAO_FECHAR_TAM_MAIOR: TStringField;
    cdsTotensPODE_FECHAR_PROGRAMA: TStringField;
    qryTotensIMAGEM: TBlobField;
    cdsTotensIMAGEM: TBlobField;
    qryTotensIMAGEM_NOME: TStringField;
    cdsTotensIMAGEM_NOME: TStringField;
    qryTotensST_HABILITA: TStringField;
    qryTotensST_BOTOES_COLUNAS: TIntegerField;
    qryTotensST_BOTOES_MARGEM_SUPERIOR: TIntegerField;
    qryTotensST_BOTOES_MARGEM_INFERIOR: TIntegerField;
    qryTotensST_BOTOES_MARGEM_ESQUERDA: TIntegerField;
    qryTotensST_BOTOES_MARGEM_DIREITA: TIntegerField;
    qryTotensST_BOTOES_ESPACO_COLUNAS: TIntegerField;
    qryTotensST_BOTOES_ESPACO_LINHAS: TIntegerField;
    qryTotensST_IMAGEM_FUNDO: TBlobField;
    cdsTotensST_HABILITA: TStringField;
    cdsTotensST_BOTOES_COLUNAS: TIntegerField;
    cdsTotensST_BOTOES_MARGEM_SUPERIOR: TIntegerField;
    cdsTotensST_BOTOES_MARGEM_INFERIOR: TIntegerField;
    cdsTotensST_BOTOES_MARGEM_ESQUERDA: TIntegerField;
    cdsTotensST_BOTOES_MARGEM_DIREITA: TIntegerField;
    cdsTotensST_BOTOES_ESPACO_COLUNAS: TIntegerField;
    cdsTotensST_BOTOES_ESPACO_LINHAS: TIntegerField;
    cdsTotensST_IMAGEM_FUNDO: TBlobField;
    qryTotensST_IMAGEM_FUNDO_NOME: TStringField;
    cdsTotensST_IMAGEM_FUNDO_NOME: TStringField;
    cdsTelas: TClientDataSet;
    dspTelas: TDataSetProvider;
    qryTelas: TFDQuery;
    cdsTelasBotoes: TClientDataSet;
    dspTelasBotoes: TDataSetProvider;
    qryTelasBotoes: TFDQuery;
    cdsTelasID: TIntegerField;
    cdsTelasNOME: TStringField;
    cdsTelasINTERVALO: TIntegerField;
    cdsTelasIMAGEM: TBlobField;
    cdsTelasBotoesID: TIntegerField;
    cdsTelasBotoesNOME: TStringField;
    cdsTelasBotoesPOS_LEFT: TIntegerField;
    cdsTelasBotoesPOS_TOP: TIntegerField;
    cdsTelasBotoesTAM_WIDTH: TIntegerField;
    cdsTelasBotoesTAM_HEIGHT: TIntegerField;
    cdsTelasBotoesID_TELA: TIntegerField;
    cdsTelasBotoesID_PROXIMATELA: TIntegerField;
    cdsTelasBotoesID_FILA: TIntegerField;
    cdsTelasBotoesID_TAG: TIntegerField;
    qryTotensTEMPO_INATIVIDADE: TIntegerField;
    qryTotensID_TELA: TIntegerField;
    cdsTotensTEMPO_INATIVIDADE: TIntegerField;
    cdsTotensID_TELA: TIntegerField;
    cdsLkpFechar: TClientDataSet;
    StringField1: TStringField;
    cdsLkpFecharID: TStringField;
    cdsTelasLKP_FECHAR: TStringField;
    cdsLkpMomentoImpresao: TClientDataSet;
    StringField3: TStringField;
    cdsLkpMomentoImpresaoID: TIntegerField;
    cdsTelasLKP_MOMENTO_IMPRESSAO: TStringField;
    cdsTelasFECHAR: TStringField;
    cdsTelasMOMENTO_IMPRESSAO: TSmallintField;
    cdsTelasBotoesLKP_TELA: TStringField;
    cdsTelasBotoesLKP_TELA_PROXIMA: TStringField;
    cdsTelasClone: TClientDataSet;
    cdsTelasCloneID: TIntegerField;
    cdsTelasCloneNOME: TStringField;
    cdsFilas: TClientDataSet;
    dspFilas: TDataSetProvider;
    qryFilas: TFDQuery;
    cdsTags: TClientDataSet;
    dspTags: TDataSetProvider;
    qryTags: TFDQuery;
    cdsTelasBotoesLKP_FILA: TStringField;
    cdsTelasBotoesLKP_TAG: TStringField;
    cdsFilasID: TIntegerField;
    cdsFilasNOME: TStringField;
    cdsTagsID: TIntegerField;
    cdsTagsNOME: TStringField;
    qryTotensID_UNIDADE: TIntegerField;
    cdsTotensID_UNIDADE: TIntegerField;
    cdsTelasID_UNIDADE: TIntegerField;
    cdsTelasBotoesID_UNIDADE: TIntegerField;
    cdsFilasID_UNIDADE: TIntegerField;
    cdsTagsID_UNIDADE: TIntegerField;
    procedure DataModuleCreate(Sender: TObject);
    procedure cdsTotensNewRecord(DataSet: TDataSet);
    procedure cdsTotensReconcileError(DataSet: TCustomClientDataSet;
      E: EReconcileError; UpdateKind: TUpdateKind;
      var Action: TReconcileAction);
    procedure cdsTotensBeforePost(DataSet: TDataSet);
    procedure cdsTotensIDSetText(Sender: TField; const Text: string);
    procedure cdsTelasAfterOpen(DataSet: TDataSet);
    procedure cdsTelasAfterScroll(DataSet: TDataSet);
    procedure dspTelasBeforeUpdateRecord(Sender: TObject; SourceDS: TDataSet;
      DeltaDS: TCustomClientDataSet; UpdateKind: TUpdateKind;
      var Applied: Boolean);
    procedure dspTelasBotoesBeforeUpdateRecord(Sender: TObject;
      SourceDS: TDataSet; DeltaDS: TCustomClientDataSet;
      UpdateKind: TUpdateKind; var Applied: Boolean);
    procedure cdsTelasNewRecord(DataSet: TDataSet);
    procedure cdsTelasBotoesNewRecord(DataSet: TDataSet);
    procedure cdsTelasIMAGEMGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
  private
    FIdTelaSeq       : Integer;
    FIdTelaBotoesSeq : Integer;
  public

  end;

var
  dmSicsCadTotens: TdmSicsCadTotens;

implementation

uses
 Sics_91, sics_94, UConexaoBD, ASPGenerator;

{$R *.dfm}

procedure TdmSicsCadTotens.DataModuleCreate(Sender: TObject);
var
  i : integer;
begin
  FIdTelaSeq := 0;
  FIdTelaBotoesSeq := 0;

  TConexaoBD.DefinirQueriesComoUnidirectional(Self);

  qryTotens.Connection   := dmSicsMain.connOnLine;
  qryLkpFilas.Connection := dmSicsMain.connOnLine;

  with cdsLkpModeloToten do
  begin
    CreateDataSet;

    for i := low(ModelosTotens) to high(ModelosTotens) do
      if ModelosTotens[i].Nome <> DESC_TOTEM_OBSOLETO then
      begin
        Append;
        FieldByName('ID'       ).AsInteger := ModelosTotens[i].ID;
        FieldByName('DESCRICAO').AsString  := ModelosTotens[i].Nome;
        Post;
      end;
  end;

  with cdsLkpFechar do
  begin
    CreateDataSet;

    Append;
    FieldByName('ID').AsString        := 'S';
    FieldByName('DESCRICAO').AsString := 'SIM';
    Post;

    Append;
    FieldByName('ID').AsString        := 'N';
    FieldByName('DESCRICAO').AsString := 'NÃO';
    Post;
  end;

  with cdsLkpMomentoImpresao do
  begin
    CreateDataSet;

    Append;
    FieldByName('ID').AsInteger        := 0;
    FieldByName('DESCRICAO').AsString := 'NÃO IMPRIMIR';
    Post;

    Append;
    FieldByName('ID').AsInteger        := 1;
    FieldByName('DESCRICAO').AsString := 'IMPRIMIR NO INÍCIO';
    Post;

    Append;
    FieldByName('ID').AsInteger        := 2;
    FieldByName('DESCRICAO').AsString := 'IMPRIMIR NO FINAL';
    Post;
  end;

  cdsTotens.Open;
  cdSLkpFilas.Open;

  cdsTelas.Open;
  cdsTelasBotoes.Open;
  cdsFilas.Open;
  cdsTags.Open;
end;

procedure TdmSicsCadTotens.dspTelasBeforeUpdateRecord(Sender: TObject;
  SourceDS: TDataSet; DeltaDS: TCustomClientDataSet; UpdateKind: TUpdateKind;
  var Applied: Boolean);
begin
	if UpdateKind = ukInsert then
  begin
		if DeltaDs.FieldByName('ID').AsInteger < 0 then
    	DeltaDs.FieldByName('ID').NewValue := TGenerator.NGetNextGenerator('GEN_ID_MULTITELAS', dmSicsMain.connOnLine);
  end;
end;

procedure TdmSicsCadTotens.dspTelasBotoesBeforeUpdateRecord(Sender: TObject;
  SourceDS: TDataSet; DeltaDS: TCustomClientDataSet; UpdateKind: TUpdateKind;
  var Applied: Boolean);
begin
	if UpdateKind = ukInsert then
  begin
		if DeltaDs.FieldByName('ID').AsInteger < 0 then
    	DeltaDs.FieldByName('ID').NewValue := TGenerator.NGetNextGenerator('GEN_ID_MULTITELAS_BOTOES', dmSicsMain.connOnLine);
  end;
end;

procedure TdmSicsCadTotens.cdsTotensIDSetText(Sender: TField;
  const Text: string);
var
  Lid: Integer;
begin
  Lid := strtointdef(Text,0);
  if (LId < 1) or (LId > cgMaxTotens)then
  begin
    ShowMessage('O Id deve ser entre 1  e ' + Inttostr(cgMaxTotens));
  end
  else
  begin
    Sender.Value := Text;
  end;
end;

procedure TdmSicsCadTotens.cdsTotensNewRecord(DataSet: TDataSet);
begin
  with DataSet do
  begin
    FieldByName('ID_MODELOTOTEM'         ).AsInteger := TOTEM_MODELO_BALCAO;
    FieldByName('PORTA_TCP'              ).AsInteger := 3001;
    FieldByName('PORTA_SERIAL_IMPRESSORA').AsString  := 'com1,115200,8,n,1';
  end;
end;

procedure TdmSicsCadTotens.cdsTotensReconcileError(DataSet: TCustomClientDataSet;
  E: EReconcileError; UpdateKind: TUpdateKind;
  var Action: TReconcileAction);
begin
	MyLogException(E);
end;

procedure TdmSicsCadTotens.cdsTelasAfterOpen(DataSet: TDataSet);
begin
  cdsTelasClone.CloneCursor(cdsTelas, True);
end;

procedure TdmSicsCadTotens.cdsTelasAfterScroll(DataSet: TDataSet);
begin
  cdsTelasClone.CloneCursor(cdsTelas, True);
  if (cdsTelas.Active) and (cdsTelasID.AsInteger > 0) then
  begin
    if cdsTelasBotoes.Active then
    begin
      cdsTelasBotoes.Active := False;
      cdsTelasBotoes.Filtered := False;
      cdsTelasBotoes.Filter := 'ID_TELA = ' + cdsTelasID.AsString;
      cdsTelasBotoes.Active := True;
      cdsTelasBotoes.Filtered := True;
    end;
  end;

end;

procedure TdmSicsCadTotens.cdsTelasBotoesNewRecord(DataSet: TDataSet);
begin
	Dec(FIdTelaBotoesSeq);
  DataSet.FieldByName('ID').AsInteger := FIdTelaBotoesSeq;
  DataSet.FieldByName('ID_TELA').AsInteger := cdsTelasID.AsInteger;
end;

procedure TdmSicsCadTotens.cdsTelasIMAGEMGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  Text := 'Clique Aqui->'
end;

procedure TdmSicsCadTotens.cdsTelasNewRecord(DataSet: TDataSet);
begin
	Dec(FIdTelaSeq);
  DataSet.FieldByName('ID').AsInteger := FIdTelaSeq;
end;

procedure TdmSicsCadTotens.cdsTotensBeforePost(DataSet: TDataSet);
var
  i: Integer;
begin
  with cdsTotens do
  begin
    if FieldByName('ID').IsNull then
      raise Exception.Create('Id do totem não informado');

    if FieldByName('ID_MODELOTOTEM').AsInteger = TOTEM_MODELO_BALCAO then
    begin
      FieldByName('IDFILA_BOTAO7').Clear;
      FieldByName('IDFILA_BOTAO8').Clear;
    end;

    for i := 1 to 8 do
      with FieldByName('IDFILA_BOTAO' + IntToStr(i)) do
        if AsInteger = 0 then
          Clear;
  end;
end;

end.
