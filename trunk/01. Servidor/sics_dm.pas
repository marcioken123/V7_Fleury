unit sics_dm;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}
uses
  SysUtils, Classes, FMTBcd, Provider, DB, DBClient, Forms, Windows,
  IniFiles, ExtCtrls, MyDlls_DR, ClassLibraryVCL,
  dialogs, Variants, DateUtils, ufrmDebugParameters,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,

  FireDAC.Phys.FB, FireDAC.Phys, FireDAC.Phys.MSSQL,
  Datasnap.Win.TConnect, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.VCLUI.Wait, uDataSetHelper,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf;

type

  TFilasComChamadaAutomatica = record
    PAs: TIntArray;
  end;

  TdmSicsServidor = class(TDataModule)
    cdsInicializaBase: TClientDataSet;
    dspInicializaBase: TDataSetProvider;
    qryInicializaBase: TFDQuery;
    qryAddEvento: TFDQuery;
    dspAddEvento: TDataSetProvider;
    cdsAddEvento: TClientDataSet;
    cdsAddTicket: TClientDataSet;
    dspAddTicket: TDataSetProvider;
    qryAddTicket: TFDQuery;
    qryCheckExisteTicket: TFDQuery;
    cdsAddTicketTag: TClientDataSet;
    dspAddTicketTag: TDataSetProvider;
    qryAddTicketTag: TFDQuery;
    qryAddTicketTagID_TICKET: TIntegerField;
    qryAddTicketTagID_TAG: TIntegerField;
    qryAddTicketTagID_GRUPOTAG: TIntegerField;
    qryDeleteTicketTag: TFDQuery;
    qryUpdateNomeCliente: TFDQuery;
    cdsAddEventoPP: TClientDataSet;
    dspAddEventoPP: TDataSetProvider;
    qryAddEventoPP: TFDQuery;
    qryFilasChamadaAutomatica: TFDQuery;
    dspFilasChamadaAutomatica: TDataSetProvider;
    cdsFilasChamadaAutomatica: TClientDataSet;
    qryDeleteTicketsAgendamentosFilas: TFDQuery;
    cdsAddTicketAgendamentosFilas: TClientDataSet;
    dspAddTicketAgendamentosFilas: TDataSetProvider;
    qryAddTicketAgendamentosFilas: TFDQuery;
    qryIDTicket: TFDQuery;
    qryIDTicketID: TIntegerField;
    qryIDTicketNUMEROTICKET: TIntegerField;
    qryIDTicketNOMECLIENTE: TStringField;
    qryIDTicketFILA_ID: TIntegerField;
    qryIDTicketCREATEDAT: TSQLTimeStampField;
    qryAddTicketTagID_UNIDADE: TIntegerField;
    qryIDTicketID_UNIDADE: TIntegerField;
    cdsAddParametrosCalculoTEE: TClientDataSet;
    dspAddParametrosCalculoTEE: TDataSetProvider;
    qryAddParametrosCalculoTEE: TFDQuery;
    cdsAddAlarmeAtivoPA: TClientDataSet;
    dspAddAlarmeAtivoPA: TDataSetProvider;
    qryAddAlarmeAtivoPA: TFDQuery;
    cdsAddQtdEsperaPA: TClientDataSet;
    dspAddQtdEsperaPA: TDataSetProvider;
    qryAddQtdEsperaPA: TFDQuery;
    procedure cdsInicializaBaseReconcileError(DataSet: TCustomClientDataSet;
      E: EReconcileError; UpdateKind: TUpdateKind;
      var Action: TReconcileAction);
    procedure DataModuleCreate(Sender: TObject);
    procedure cdsAddTicketReconcileError(DataSet: TCustomClientDataSet;
      E: EReconcileError; UpdateKind: TUpdateKind;
      var Action: TReconcileAction);
    procedure cdsAddTicketTagReconcileError(DataSet: TCustomClientDataSet;
      E: EReconcileError; UpdateKind: TUpdateKind;
      var Action: TReconcileAction);
    procedure cdsAddEventoReconcileError(DataSet: TCustomClientDataSet;
      E: EReconcileError; UpdateKind: TUpdateKind;
      var Action: TReconcileAction);
    procedure cdsAddEventoPPReconcileError(DataSet: TCustomClientDataSet;
      E: EReconcileError; UpdateKind: TUpdateKind;
      var Action: TReconcileAction);
    procedure cdsAddTicketAgendamentosFilasReconcileError
      (DataSet: TCustomClientDataSet; E: EReconcileError;
      UpdateKind: TUpdateKind; var Action: TReconcileAction);
    procedure dspIdsTicketsGetTableName(Sender: TObject; DataSet: TDataSet;
      var TableName: string);
    procedure dspIdsTicketsTagsGetTableName(Sender: TObject; DataSet: TDataSet;
      var TableName: string);
  private
    FThreadCalculoPISRodando: Boolean;
    // function GetThreadCalculoPISRodando: Boolean;
  public
    PAsComChamadaAutomatica: TIntArray;
    FilasComChamadaAutomatica: array of TFilasComChamadaAutomatica;
    FilasComOrdenacaoAutomatica: TIntArray;
    procedure InicializaBase;
    procedure CarregarFilasComChamadaAutomatica;
  end;

function RegistraEvento(ID_AtType, ID_Atd, ID_PA, ID_FilaEspera,
  ID_MotivoPausa: integer; NumeroTicket: integer;
  IniTime, EndTime: TDateTime): Boolean;
function RegistraEventoPP(ID_EventoPP, ID_TipoPP, ID_PA_Inicio, ID_PA_Fim,
  ID_Atd_Inicio, ID_ATD_Fim: integer; NumeroTicket: integer;
  IniTime, EndTime: TDateTime): boolean;
function RegistraTicket(ID_Ticket, NumeroTicket, ID_Fila, Ordem: integer;
  PswdDateTime: TDateTime): Boolean;
function RecuperaTicket(AID_Ticket, AID_Fila, AOrdem: Integer; ADataHora: TDateTime): Boolean;
function OrdemTicketNaFila(AID_Fila, AOrdem: Integer; AIDTicket: Integer = 0): Integer;
function RegistraTicketNome(ID_Ticket: integer; NomeCliente: string): boolean;
function RegistraTicketTag(ID_Ticket, Id_Tag: integer): boolean;
function DesRegistraTicketTag(ID_Ticket, Id_Tag: integer): boolean;
function RegistraTicketAgendamentosFilas(ID_Ticket: integer): Boolean;
function DesRegistraTicketAgendamentosFilas(ID_Ticket: integer): Boolean;
function RegistraParametrosDeCalculoTEE(Fila : integer; ParametrosCalculo : string; Resultado : TDateTime; var AIDTEE:integer) : boolean;

// RA
function RemoverFilaTicketBD(pFila: Integer): Boolean; overload;
function RemoverFilaTicketBD(pFila, pIDTicket: Integer): Boolean; overload;
function DirecionarTicketParaFilaBD(pIDTicket, pFilaAnterior, pNovaFila,
  pOrdem: integer): Boolean;
function LocalizarTicket(pNumeroTicket: integer;
  var pIDTicket, pIDFila: integer; var pNomeCliente: String;
  var pCreatedAt: TDateTime): Boolean;

function LimparFilaTicket(IDTicket, Fila: Integer): Boolean;

function LimpaTodosAlarmesAtivoPAs : boolean;
function GravaAlarmeAtivoPA (PA : integer; NomeIndicador, NomeNivel : string; CodigoCorNivel : integer; Mensagem : string) : boolean;

function LimpaTodasQtdEsperaPAs : boolean;
function GravaQtdEsperaPA (PA : integer; QtdEspera : integer) : boolean;

function VerificaChamadaAutomatica(IdPA: integer): boolean;
function VerificaChamadaAutomaticaSemFlag(IdPA: integer): boolean;
function VerificaFilaChamadaAutomatica(Fila: integer): boolean;

var
  dmSicsServidor: TdmSicsServidor;

implementation

uses sics_94, Sics_91, sics_m, udmContingencia, uFuncoes, System.Math,

  UConexaoBD, ASPGenerator;

{$R *.dfm}

procedure TdmSicsServidor.InicializaBase;

  procedure InicializaTiposEvento;
  var
    Tipo: TTipoEvento;
    Rec: TRecTipoEvento;
    StrListIds: TStringList;
  begin
    StrListIds := TStringList.Create;
    try
      qryInicializaBase.Sql.Text :=
        'select * from TIPOS_EVENTOS WHERE ID_UNIDADE = :ID_UNIDADE';
      qryInicializaBase.ParamByName('ID_UNIDADE').AsInteger :=
        vgParametrosModulo.IdUnidade;
      with cdsInicializaBase do
      begin
        Open;
        try
          for Tipo := Low(TiposEventos) to High(TiposEventos) do
          begin
            Rec := TiposEventos[Tipo];

            StrListIds.Add(IntToStr(Rec.ID));

            if Locate('ID', Rec.ID, []) then
              Edit
            else
            begin
              Append;
              FieldByName('ID_UNIDADE').AsInteger :=
                vgParametrosModulo.IdUnidade;
              FieldByName('ID').AsInteger := Rec.ID;
            end;

            FieldByName('NOME').AsString := Rec.Nome;

            Post;
          end;

          First;
          while not Eof do
          begin
            if StrListIds.IndexOf(FieldByName('ID').AsString) < 0 then
              Delete
            else
              Next;
          end;

          ApplyUpdates(0);
        finally
          Close;
        end;
      end;
    finally
      StrListIds.Free;
    end;
  end;

  procedure InicializaStatusPAs;
  var
    Status: TStatusPA;
    Rec: TRecStatusPA;
    StrListIds: TStringList;
  begin
    StrListIds := TStringList.Create;
    try
      qryInicializaBase.Sql.Text :=
        'select * from STATUS_PAS WHERE ID_UNIDADE = :ID_UNIDADE';
      qryInicializaBase.ParamByName('ID_UNIDADE').AsInteger :=
        vgParametrosModulo.IdUnidade;
      with cdsInicializaBase do
      begin
        Open;
        try
          for Status := Low(StatusPAs) to High(StatusPAs) do
          begin
            Rec := StatusPAs[Status];

            StrListIds.Add(IntToStr(Rec.ID));

            if Locate('ID', Rec.ID, []) then
              Edit
            else
            begin
              Append;
              FieldByName('ID_UNIDADE').AsInteger :=
                vgParametrosModulo.IdUnidade;
              FieldByName('ID').AsInteger := Rec.ID;
            end;

            FieldByName('NOME').AsString := Rec.Nome;

            Post;
          end;

          First;
          while not Eof do
          begin
            if StrListIds.IndexOf(FieldByName('ID').AsString) < 0 then
              Delete
            else
              Next;
          end;

          ApplyUpdates(0);
        finally
          Close;
        end;
      end;
    finally
      StrListIds.Free;
    end;
  end;

  procedure InicializaModelosPaineis;
  var
    Tipo: TModeloPainel;
    Rec: TRecModeloPainel;
    StrListIds: TStringList;
  begin
    StrListIds := TStringList.Create;
    try
      qryInicializaBase.Sql.Text :=
        'select * from MODELOS_PAINEIS WHERE ID_UNIDADE = :ID_UNIDADE';
      qryInicializaBase.ParamByName('ID_UNIDADE').AsInteger :=
        vgParametrosModulo.IdUnidade;
      with cdsInicializaBase do
      begin
        Open;
        try
          for Tipo := Low(ModelosPaineis) to High(ModelosPaineis) do
          begin
            Rec := ModelosPaineis[Tipo];

            StrListIds.Add(IntToStr(Rec.ID));

            if Locate('ID', Rec.ID, []) then
              Edit
            else
            begin
              Append;
              FieldByName('ID_UNIDADE').AsInteger :=
                vgParametrosModulo.IdUnidade;
              FieldByName('ID').AsInteger := Rec.ID;
            end;

            FieldByName('NOME').AsString := Rec.Nome;

            Post;
          end;

          First;
          while not Eof do
          begin
            if StrListIds.IndexOf(FieldByName('ID').AsString) < 0 then
              Delete
            else
              Next;
          end;

          ApplyUpdates(0);
        finally
          Close;
        end;
      end;
    finally
      StrListIds.Free;
    end;
  end;

  procedure InicializaTiposPis;
  var
    Tipo: TTipoPI;
    Rec: TRecTipoPI;
    StrListIds: TStringList;
  begin
    StrListIds := TStringList.Create;
    try
      qryInicializaBase.Sql.Text :=
        'select * from PIS_TIPOS WHERE ID_UNIDADE = :ID_UNIDADE';
      qryInicializaBase.ParamByName('ID_UNIDADE').AsInteger :=
        vgParametrosModulo.IdUnidade;
      with cdsInicializaBase do
      begin
        Open;
        try
          for Tipo := Low(TiposPIs) to High(TiposPIs) do
          begin
            Rec := TiposPIs[Tipo];

            StrListIds.Add(IntToStr(Rec.ID));

            if Locate('ID_PITIPO', Rec.ID, []) then
              Edit
            else
            begin
              Append;
              FieldByName('ID_UNIDADE').AsInteger :=
                vgParametrosModulo.IdUnidade;
              FieldByName('ID_PITIPO').AsInteger := Rec.ID;
            end;

            FieldByName('NOME').AsString              := Rec.Nome;
            FieldByName('TABELARELACIONADA').AsString := Rec.TabelaRelacionada;
            FieldByName('FORMATOHORARIO').AsBoolean   := Rec.FormatoHorario;

            Post;
          end;

          First;
          while not Eof do
          begin
            if StrListIds.IndexOf(FieldByName('ID_PITIPO').AsString) < 0 then
              Delete
            else
              Next;
          end;

          ApplyUpdates(0);
        finally
          Close;
        end;
      end;
    finally
      StrListIds.Free;
    end;
  end;

  procedure InicializaAlinhamentosPIs;
  var
    Tipo: TAlinhamentoPI;
    Rec: TRecAlinhamentoPI;
    StrListIds: TStringList;
  begin
    StrListIds := TStringList.Create;
    try
      qryInicializaBase.Sql.Text :=
        'select * from PIS_POSICAO WHERE ID_UNIDADE = :ID_UNIDADE';
      qryInicializaBase.ParamByName('ID_UNIDADE').AsInteger :=
        vgParametrosModulo.IdUnidade;
      with cdsInicializaBase do
      begin
        Open;
        try
          for Tipo := Low(AlinhamentosPIs) to High(AlinhamentosPIs) do
          begin
            Rec := AlinhamentosPIs[Tipo];

            StrListIds.Add(IntToStr(Rec.ID));

            if Locate('ID_PIPOS', Rec.ID, []) then
              Edit
            else
            begin
              Append;
              FieldByName('ID_UNIDADE').AsInteger :=
                vgParametrosModulo.IdUnidade;
              FieldByName('ID_PIPOS').AsInteger := Rec.ID;
            end;

            FieldByName('NOME_POS').AsString := Rec.Nome;

            Post;
          end;

          First;
          while not Eof do
          begin
            if StrListIds.IndexOf(FieldByName('ID_PIPOS').AsString) < 0 then
              Delete
            else
              Next;
          end;

          ApplyUpdates(0);
        finally
          Close;
        end;
      end;
    finally
      StrListIds.Free;
    end;
  end;

  procedure InicializaNiveisPI;
  var
    Tipo: TNivelPI;
    Rec: TRecNivelPI;
  begin
    try
      qryInicializaBase.Sql.Text :=
        'select * from PIS_NIVEIS WHERE ID_UNIDADE = :ID_UNIDADE';
      qryInicializaBase.ParamByName('ID_UNIDADE').AsInteger :=
        vgParametrosModulo.IdUnidade;
      with cdsInicializaBase do
      begin
        Open;
        try
          for Tipo := Low(NiveisPIs) to High(NiveisPIs) do
          begin
            Rec := NiveisPIs[Tipo];

            if Locate('ID_PINIVEL', Rec.ID, []) then
            begin
              //
            end
            else
            begin
              Append;
              FieldByName('ID_UNIDADE').AsInteger :=
                vgParametrosModulo.IdUnidade;
              FieldByName('ID_PINIVEL').AsInteger          := Rec.ID;
              FieldByName('NOME').AsString                 := Rec.Nome;
              FieldByName('COR').AsString                  := Rec.Cor;
              FieldByName('CODIGOCOR').AsInteger           := Rec.CodigoCor;
              FieldByName('POSICAO').AsInteger             := Rec.Posicao;
              FieldByName('COR_PAINELELETRONICO').AsString :=
                Rec.CorPainelEletronico;
              Post;
            end;

          end;

          ApplyUpdates(0);
        finally
          Close;
        end;
      end;
    finally
    end;
  end;

  procedure InicializaFuncoesPIs;
  var
    Tipo: TFuncaoPI;
    Rec: TRecFuncaoPI;
    StrListIds: TStringList;
  begin
    StrListIds := TStringList.Create;
    try
      qryInicializaBase.Sql.Text :=
        'select * from PIS_FUNCOES WHERE ID_UNIDADE = :ID_UNIDADE';
      qryInicializaBase.ParamByName('ID_UNIDADE').AsInteger :=
        vgParametrosModulo.IdUnidade;
      with cdsInicializaBase do
      begin
        Open;
        try
          for Tipo := Low(FuncoesPIs) to High(FuncoesPIs) do
          begin
            Rec := FuncoesPIs[Tipo];

            StrListIds.Add(IntToStr(Rec.ID));

            if Locate('ID_PIFUNCAO', Rec.ID, []) then
              Edit
            else
            begin
              Append;
              FieldByName('ID_UNIDADE').AsInteger :=
                vgParametrosModulo.IdUnidade;
              FieldByName('ID_PIFUNCAO').AsInteger := Rec.ID;
            end;

            FieldByName('NOME').AsString := Rec.Nome;

            Post;
          end;

          First;
          while not Eof do
          begin
            if StrListIds.IndexOf(FieldByName('ID_PIFUNCAO').AsString) < 0 then
              Delete
            else
              Next;
          end;

          ApplyUpdates(0);
        finally
          Close;
        end;
      end;
    finally
      StrListIds.Free;
    end;
  end;

  procedure InicializaAcoesAlarmesPIs;
  var
    Tipo: TAcaoAlarmePI;
    Rec: TRecAcaoAlarmePI;
    StrListIds: TStringList;
  begin
    StrListIds := TStringList.Create;
    try
      qryInicializaBase.Sql.Text :=
        'select * from PIS_ACOES_DE_ALARMES WHERE ID_UNIDADE = :ID_UNIDADE';
      qryInicializaBase.ParamByName('ID_UNIDADE').AsInteger :=
        vgParametrosModulo.IdUnidade;
      with cdsInicializaBase do
      begin
        Open;
        try
          for Tipo := Low(AcoesAlarmesPIs) to High(AcoesAlarmesPIs) do
          begin
            Rec := AcoesAlarmesPIs[Tipo];

            StrListIds.Add(IntToStr(Rec.ID));

            if Locate('ID_PIACAODEALARME', Rec.ID, []) then
              Edit
            else
            begin
              Append;
              FieldByName('ID_UNIDADE').AsInteger :=
                vgParametrosModulo.IdUnidade;
              FieldByName('ID_PIACAODEALARME').AsInteger := Rec.ID;
            end;

            FieldByName('NOME').AsString              := Rec.Nome;
            FieldByName('TABELARELACIONADA').AsString := Rec.TabelaRelacionada;

            Post;
          end;

          First;
          while not Eof do
          begin
            if StrListIds.IndexOf(FieldByName('ID_PIACAODEALARME').AsString) < 0
            then
              Delete
            else
              Next;
          end;

          ApplyUpdates(0);
        finally
          Close;
        end;
      end;
    finally
      StrListIds.Free;
    end;
  end;

begin
  dmSicsMain.connOnLine.StartTransaction;
  try
    InicializaTiposEvento;
    InicializaStatusPAs;
    InicializaModelosPaineis;
    InicializaTiposPis;
    InicializaAlinhamentosPIs;
    InicializaNiveisPI;
    InicializaFuncoesPIs;
    InicializaAcoesAlarmesPIs;

    dmSicsMain.connOnLine.Commit;
  except
    dmSicsMain.connOnLine.Rollback;
    Raise;
  end;
end;

procedure TdmSicsServidor.cdsInicializaBaseReconcileError
  (DataSet: TCustomClientDataSet; E: EReconcileError; UpdateKind: TUpdateKind;
  var Action: TReconcileAction);
begin
  Raise Exception.Create(E.Message);
end;

procedure TdmSicsServidor.DataModuleCreate(Sender: TObject);
var
  PAsComChamadaAutomaticaStr: string;
  FilasComOrdenacaoAutomaticaStr: string;
begin
  TConexaoBD.DefinirQueriesComoUnidirectional(Self);

  FThreadCalculoPISRodando := False;

  try
    InicializaBase;
  except
    on E: Exception do
    begin
      MyLogException(E);
      Application.MessageBox('Erro ao inicializar base de dados!!', 'ERRO',
        MB_ICONSTOP);
      Halt;
    end;
  end;

  with TIniFile.Create(GetIniFileName) do
    try
      PAsComChamadaAutomaticaStr := ReadString('Settings',
        'PAsComChamadaAutomatica', '');
      FilasComOrdenacaoAutomaticaStr :=
        ReadString('Settings', 'FilasComOrdenacaoAutomatica', '');

      WriteString('Settings', 'PAsComChamadaAutomatica',
        PAsComChamadaAutomaticaStr);
      WriteString('Settings', 'FilasComOrdenacaoAutomatica',
        FilasComOrdenacaoAutomaticaStr);
    finally
      Free;
    end;

  StrToIntArray(PAsComChamadaAutomaticaStr, PAsComChamadaAutomatica);
  StrToIntArray(FilasComOrdenacaoAutomaticaStr, FilasComOrdenacaoAutomatica);

  CarregarFilasComChamadaAutomatica;
end;

procedure TdmSicsServidor.dspIdsTicketsGetTableName(Sender: TObject;
  DataSet: TDataSet; var TableName: string);
begin
  TableName := 'TICKETS';
end;

procedure TdmSicsServidor.dspIdsTicketsTagsGetTableName(Sender: TObject;
  DataSet: TDataSet; var TableName: string);
begin
  TableName := 'TICKETS_TAGS';
end;

{
  function TdmSicsServidor.GetThreadCalculoPISRodando: Boolean;
  var
  LBool: Boolean;
  begin
  TThread.Synchronize(nil, procedure begin
    LBool := FThreadCalculoPISRodando;
  end);
  result := LBool;
  end;
}

function RegistraEvento(ID_AtType, ID_Atd, ID_PA, ID_FilaEspera,
  ID_MotivoPausa: integer; NumeroTicket: integer;
  IniTime, EndTime: TDateTime): Boolean;
var
  ID_Ticket, Id_FilaTipoTicket: integer;
  bLocalizouTicket: Boolean;
begin
  TfrmDebugParameters.Debugar(tbRegistrosBD, 'Entrou   RegistraEvento');
  Result := False;
  if EndTime > IniTime then
  begin
    //bLocalizouTicket := (NumeroTicket <> -1) and (frmSicsMain.cdsIdsTickets.Locate('NUMEROTICKET', NumeroTicket, []));
    bLocalizouTicket := (NumeroTicket <> -1) and (frmSicsMain.BuscarMaxIDSenha(NumeroTicket));

    ID_Ticket := 0;

    if bLocalizouTicket then
    begin
      ID_Ticket := frmSicsMain.cdsIdsTickets.FieldByName('ID').AsInteger;

      // se for um servidor de contingencia, o ticket podera nao existir na tabela
      // pois inicialmente podera ter sido gerado no principal e logo entrou o
      // contigencia no ar, portanto eh necessario registra-lo para nao dar erro de FK
      // e soh eh verificado se for > 0, pois se for negativo eh pq ja inseriu no
      // contigencia, ja que somente contigencia insere com id negativo
      if (dmSicsContingencia.TipoFuncionamento = tfContingente) and
        (ID_Ticket > 0) then
      begin
        dmSicsServidor.qryCheckExisteTicket.ParamByName('ID').AsInteger :=
          ID_Ticket;
        dmSicsServidor.qryCheckExisteTicket.Open;
        try
          if dmSicsServidor.qryCheckExisteTicket.IsEmpty then
            RegistraTicket(ID_Ticket, NumeroTicket, ID_FilaEspera, 0, Now);
        finally
          dmSicsServidor.qryCheckExisteTicket.Close;
        end;
      end;
    end;

    Id_FilaTipoTicket := NGetFilaFromRange(NumeroTicket);

    with dmSicsServidor.cdsAddEvento do
    begin
      if not Active then
        Open;

      try
        Append;
        FieldByName('ID').AsInteger := TGenerator.NGetNextGenerator
          ('GEN_ID_EVENTO', dmSicsMain.connOnLine);
        FieldByName('ID_TIPOEVENTO').AsInteger := ID_AtType;
        FieldByName('ID_PA').AsInteger         := ID_PA;
        FieldByName('ID_ATENDENTE').AsInteger  := ID_Atd;
        if not bLocalizouTicket then
          FieldByName('ID_TICKET').Clear
        else
          FieldByName('ID_TICKET').AsInteger := ID_Ticket;
        if ID_FilaEspera = -1 then
          FieldByName('ID_FILAESPERA').Clear
        else
          FieldByName('ID_FILAESPERA').AsInteger := ID_FilaEspera;
        if ID_MotivoPausa = -1 then
          FieldByName('ID_MOTIVOPAUSA').Clear
        else
          FieldByName('ID_MOTIVOPAUSA').AsInteger := ID_MotivoPausa;
        if Id_FilaTipoTicket = -1 then
          FieldByName('ID_FILATIPOTICKET').Clear
        else
          FieldByName('ID_FILATIPOTICKET').AsInteger := Id_FilaTipoTicket;
        FieldByName('INICIO').AsDateTime             := IniTime;
        FieldByName('FIM').AsDateTime                := EndTime;
        FieldByName('DURACAO_SEGUNDOS').AsInteger :=
          SecondsBetween(IniTime, EndTime);

        Post;

        Result := (ApplyUpdates(0) = 0);
        if not Result then
          CancelUpdates;
      finally
        if RecordCount > 50 then
        begin
          LogChanges := False;
          try
            EmptyDataSet;
          finally
            LogChanges := True;
          end;
        end;
      end;
    end; { with cdsAddEvento }
  end;   { if EndTime > IniTime }
  TfrmDebugParameters.Debugar(tbRegistrosBD, 'Saiu     RegistraEvento');
end; { func RegistraEvento }

function RegistraEventoPP(ID_EventoPP, ID_TipoPP, ID_PA_Inicio, ID_PA_Fim,
  ID_Atd_Inicio, ID_ATD_Fim: integer; NumeroTicket: integer;
  IniTime, EndTime: TDateTime): boolean;
var
  ID_Ticket, Id_FilaTipoTicket: integer;
  bLocalizouTicket: Boolean;
begin
  Result := False;
  if EndTime > IniTime then
  begin
    //bLocalizouTicket := frmSicsMain.cdsIdsTickets.Locate('NUMEROTICKET', NumeroTicket, []);
    bLocalizouTicket := frmSicsMain.BuscarMaxIDSenha(NumeroTicket);

    ID_Ticket := 0;
    Id_FilaTipoTicket := NGetFilaFromRange(NumeroTicket);

    if bLocalizouTicket then
    begin
      ID_Ticket := frmSicsMain.cdsIdsTickets.FieldByName('ID').AsInteger;

      // se for um servidor de contingencia, o ticket podera nao existir na tabela
      // pois inicialmente podera ter sido gerado no principal e logo entrou o
      // contigencia no ar, portanto eh necessario registra-lo para nao dar erro de FK
      // e soh eh verificado se for > 0, pois se for negativo eh pq ja inseriu no
      // contigencia, ja que somente contigencia insere com id negativo
      if (dmSicsContingencia.TipoFuncionamento = tfContingente) and
        (ID_Ticket > 0) then
      begin
        dmSicsServidor.qryCheckExisteTicket.ParamByName('ID').AsInteger :=
          ID_Ticket;
        dmSicsServidor.qryCheckExisteTicket.Open;
        try
          if dmSicsServidor.qryCheckExisteTicket.IsEmpty then
            RegistraTicket(ID_Ticket, NumeroTicket, Id_FilaTipoTicket, 0, Now);
        finally
          dmSicsServidor.qryCheckExisteTicket.Close;
        end;
      end;
    end;

    with dmSicsServidor.cdsAddEventoPP do
    begin
      if not Active then
        Open;

      try
        Append;
        FieldByName('ID').AsInteger        := ID_EventoPP;
        FieldByName('ID_TIPOPP').AsInteger := ID_TipoPP;

        if not bLocalizouTicket then
          FieldByName('ID_TICKET').Clear
        else
          FieldByName('ID_TICKET').AsInteger := ID_Ticket;

        if ID_PA_Inicio = -1 then
          FieldByName('ID_PA_INICIO').Clear
        else
          FieldByName('ID_PA_INICIO').AsInteger := ID_PA_Inicio;

        if ID_PA_Fim = -1 then
          FieldByName('ID_PA_FIM').Clear
        else
          FieldByName('ID_PA_FIM').AsInteger := ID_PA_Fim;

        if ID_Atd_Inicio = -1 then
          FieldByName('ID_ATD_INICIO').Clear
        else
          FieldByName('ID_ATD_INICIO').AsInteger := ID_Atd_Inicio;

        if ID_ATD_Fim = -1 then
          FieldByName('ID_ATD_FIM').Clear
        else
          FieldByName('ID_ATD_FIM').AsInteger := ID_ATD_Fim;

        FieldByName('ID_FILATIPOTICKET').AsInteger := Id_FilaTipoTicket;
        FieldByName('INICIO').AsDateTime           := IniTime;
        FieldByName('FIM').AsDateTime              := EndTime;
        FieldByName('DURACAO_SEGUNDOS').AsInteger :=
          SecondsBetween(IniTime, EndTime);

        Post;
        Result := (ApplyUpdates(0) = 0);
        if not Result then
          CancelUpdates;
      finally
        if RecordCount > 50 then
        begin
          LogChanges := False;
          try
            EmptyDataSet;
          finally
            LogChanges := True;
          end;
        end;
      end;
    end; { with cdsAddEvento }
  end;   { if EndTime > IniTime }
end; { func RegistraPP }

function RegistraTicket(ID_Ticket, NumeroTicket, ID_Fila, Ordem: integer;
  PswdDateTime: TDateTime): Boolean;
var
  lOrdemTicket: Integer;
begin
  TfrmDebugParameters.Debugar(tbRegistrosBD, 'Entrou   RegistraTicket');

  if not InRange(Ordem, -2, -1) then
  begin
    Ordem := -2;
  end;

  lOrdemTicket := OrdemTicketNaFila(ID_Fila, Ordem);

  with dmSicsServidor.cdsAddTicket do
  begin
    if not Active then
      Open;

    try
      Append;
      FieldByName('ID_UNIDADE').AsInteger := vgParametrosModulo.IdUnidade;
      FieldByName('ID').AsInteger           := ID_Ticket;
      FieldByName('NUMEROTICKET').AsInteger := NumeroTicket;
      FieldByName('CREATEDAT').AsDateTime   := PswdDateTime;
      FieldByName('ORDEM').AsInteger        := lOrdemTicket;

      if ID_Fila > 0 then
      begin
        FieldByName('FILA_ID').AsInteger    := ID_Fila;
      end;

      Post;
      Result := (ApplyUpdates(0) = 0);
    finally
      if RecordCount > 50 then
      begin
        LogChanges := False;
        try
          EmptyDataSet;
        finally
          LogChanges := True;
        end;
      end;
    end;
  end; { with cdsAddEvento }
  TfrmDebugParameters.Debugar(tbRegistrosBD, 'Saiu   RegistraTicket');
end; { func IncludeAtendimento }

function RecuperaTicket(AID_Ticket, AID_Fila, AOrdem: Integer; ADataHora: TDateTime): Boolean;
const
  UPDATE_TICKET =
    'UPDATE TICKETS SET FILA_ID = :FILA_ID, ORDEM = :ORDEM, CREATEDAT = :CREATEDAT ' +
    'WHERE ID_UNIDADE = :ID_UNIDADE AND ID = :ID';

var
  LOrdemTicket: integer;
begin
  Result := True;

  TfrmDebugParameters.Debugar(tbRegistrosBD, 'Entrou   RecuperaTicket');

  LOrdemTicket := OrdemTicketNaFila(AID_Fila, AOrdem);

  dmSicsMain.connOnLine.ExecSQL(UPDATE_TICKET,
    [AID_Fila, LOrdemTicket, ADataHora, vgParametrosModulo.IdUnidade, AID_Ticket]);

  TfrmDebugParameters.Debugar(tbRegistrosBD, 'Saiu     RecuperaTicket');
end;

function OrdemTicketNaFila(AID_Fila, AOrdem: Integer; AIDTicket: Integer): Integer;
const
  SELECT_MIN = 'SELECT MIN(ORDEM) - 1 FROM TICKETS WHERE FILA_ID = %d AND ID <> %d'; //-1
  SELECT_MAX = 'SELECT MAX(ORDEM) + 1 FROM TICKETS WHERE FILA_ID = %d AND ID <> %d'; //-2

var
  LSelect: String;
begin
  case AOrdem of
   -1: LSelect := SELECT_MIN;
   -2: LSelect := SELECT_MAX;
  else Exit(0);
  end;

  Result := StrToIntDef(VarToStr(dmSicsMain.connOnLine.ExecSQLScalar(Format(LSelect, [AID_Fila, AIDTicket]))), 1);
end;

function RegistraTicketNome(ID_Ticket: integer; NomeCliente: string): boolean;
begin
  with dmSicsServidor.qryUpdateNomeCliente do
  begin
    ParamByName('nome').AsString := NomeCliente;
    ParamByName('ID_UNIDADE').AsInteger := vgParametrosModulo.IdUnidade;
    ParamByName('id').AsInteger  := ID_Ticket;
    try
      ExecSQL;
      Result := (RowsAffected = 1);
    except
      Result := False;
    end;
  end
end;

function RegistraTicketTag(ID_Ticket, Id_Tag: integer): boolean;
begin
  Result := False;
  if dmSicsMain.cdsTags.Locate('Id', Id_Tag, []) then
  begin
    with dmSicsServidor do
    begin
      qryAddTicketTag.ParamByName('ID_TICKET').AsInteger := ID_Ticket;
      qryAddTicketTag.ParamByName('ID_UNIDADE').AsInteger := vgParametrosModulo.IdUnidade;

      with cdsAddTicketTag do
      begin
        Open;
        try
          // se ja tiver alguma tag do mesmo GRUPO, removo
          {if Locate('ID_GRUPOTAG', dmSicsMain.cdsTags.FieldByName('ID_GRUPOTAG').Value, []) then
          begin
            if frmSicsMain.cdsIdsTicketsTags.Locate('Ticket_Id;Tag_Id',
              VarArrayOf([ID_Ticket, FieldByName('ID_TAG').Value]), []) then
            begin
              frmSicsMain.cdsIdsTicketsTags.Edit;
              frmSicsMain.cdsIdsTicketsTags.FieldByName('TAG_ID').AsInteger := Id_Tag;
              frmSicsMain.cdsIdsTicketsTags.Post;
              frmSicsMain.cdsIdsTicketsTags.ApplyUpdates(0);
            end;

            Edit;
            FieldByName('ID_TAG').AsInteger := Id_Tag;
            Post;
          end
          else}
          if not frmSicsMain.cdsIdsTicketsTags.Locate('TICKET_ID;TAG_ID', VarArrayOf([ID_Ticket, Id_Tag]), []) then
          begin
            frmSicsMain.cdsIdsTicketsTags.Append;
            frmSicsMain.cdsIdsTicketsTags.FieldByName('ID').AsInteger := TGenerator.NGetNextGenerator('GEN_ID_TICKETS_TAGS', dmSicsMain.connOnLine);
            frmSicsMain.cdsIdsTicketsTags.FieldByName('ID_UNIDADE').AsInteger := vgParametrosModulo.IdUnidade;
            frmSicsMain.cdsIdsTicketsTags.FieldByName('TICKET_ID').AsInteger  := ID_Ticket;
            frmSicsMain.cdsIdsTicketsTags.FieldByName('TAG_ID').AsInteger     := Id_Tag;
            frmSicsMain.cdsIdsTicketsTags.Post;
            frmSicsMain.cdsIdsTicketsTags.ApplyUpdates(0);

            Append;
            FieldByName('ID_TAG').AsInteger    := Id_Tag;
            FieldByName('ID_TICKET').AsInteger := ID_Ticket;
            Post;
          end;

          Result := ApplyUpdates(0) = 0;

          if Result then
            frmSicsMain.SaveTags;
        finally
          Close;
        end;
      end;
    end;
  end;
end;

function DesRegistraTicketTag(ID_Ticket, Id_Tag: integer): boolean;
begin
  with dmSicsServidor.qryDeleteTicketTag do
  begin
    if frmSicsMain.cdsIdsTicketsTags.Locate('Ticket_Id;Tag_Id',
      VarArrayOf([ID_Ticket, Id_Tag]), []) then
      frmSicsMain.cdsIdsTicketsTags.Delete;

    if frmSicsMain.cdsIdsTicketsTags.ChangeCount > 0 then
    begin
      frmSicsMain.cdsIdsTicketsTags.ApplyUpdates(0);
    end;

    ParamByName('ID_UNIDADE').AsInteger := vgParametrosModulo.IdUnidade;
    ParamByName('ID_TICKET').AsInteger := ID_Ticket;
    ParamByName('ID_TAG').AsInteger    := Id_Tag;
    ExecSQL;
    Result := True;

    frmSicsMain.SaveTags;
  end;
end;

function RegistraTicketAgendamentosFilas(ID_Ticket: integer): Boolean;
begin
  // Result := False;

  dmSicsServidor.qryAddTicketAgendamentosFilas.ParamByName('ID_TICKET')
    .AsInteger := ID_Ticket;
  dmSicsServidor.cdsAddTicketAgendamentosFilas.Open;
  try
    if not dmSicsServidor.cdsAddTicketAgendamentosFilas.IsEmpty then
    begin
      DesRegistraTicketAgendamentosFilas(ID_Ticket);
      dmSicsServidor.cdsAddTicketAgendamentosFilas.Refresh;
    end;

    with frmSicsMain.cdsIdsTicketsAgendamentosFilas do
    begin
      Filter   := 'IdTicket=' + inttostr(ID_Ticket);
      Filtered := True;
      try
        First;
        while not Eof do
        begin
          dmSicsServidor.cdsAddTicketAgendamentosFilas.Append;
          dmSicsServidor.cdsAddTicketAgendamentosFilas.FieldByName('ID_TICKET')
            .AsInteger := FieldByName('ID_TICKET').AsInteger;
          dmSicsServidor.cdsAddTicketAgendamentosFilas.FieldByName('ID_FILA')
            .AsInteger := FieldByName('ID_FILA').AsInteger;
          dmSicsServidor.cdsAddTicketAgendamentosFilas.FieldByName('DATAHORA')
            .AsDateTime := FieldByName('DATAHORA').AsDateTime;
          dmSicsServidor.cdsAddTicketAgendamentosFilas.Post;

          Next;
        end;
      finally
        Filtered := false;
      end;
    end;

    Result := dmSicsServidor.cdsAddTicketAgendamentosFilas.ApplyUpdates(0) = 0;

    if Result then
      frmSicsMain.SaveAgendamentosFilas;
  finally
    dmSicsServidor.cdsAddTicketAgendamentosFilas.Close;
  end;
end;

function DesRegistraTicketAgendamentosFilas(ID_Ticket: integer): Boolean;
begin
  frmSicsMain.cdsIdsTicketsAgendamentosFilas.Filter := 'IdTicket=' +
    IntToStr(ID_Ticket);
  frmSicsMain.cdsIdsTicketsAgendamentosFilas.Filtered := True;
    try
    while not frmSicsMain.cdsIdsTicketsAgendamentosFilas.IsEmpty do
      frmSicsMain.cdsIdsTicketsAgendamentosFilas.Delete;
    finally
    frmSicsMain.cdsIdsTicketsAgendamentosFilas.Filtered := False;
  end;

  dmSicsServidor.qryDeleteTicketsAgendamentosFilas.ParamByName('ID_UNIDADE')
    .AsInteger := vgParametrosModulo.IdUnidade;
  dmSicsServidor.qryDeleteTicketsAgendamentosFilas.ParamByName('ID_TICKET')
    .AsInteger := ID_Ticket;
  dmSicsServidor.qryDeleteTicketsAgendamentosFilas.ExecSQL;

  Result := True;
  frmSicsMain.SaveAgendamentosFilas;
end;

function RegistraParametrosDeCalculoTEE(Fila : integer; ParametrosCalculo : string; Resultado : TDateTime; var AIDTEE:integer) : boolean;
var
  ID_Ticket, Id_FilaTipoTicket: integer;
  bLocalizouTicket: Boolean;
begin
  TfrmDebugParameters.Debugar(tbRegistrosBD, 'Entrou   RegistraParametrosDeCalculoTEE');
  Result := False;
  with dmSicsServidor.cdsAddParametrosCalculoTEE do
  begin
    if not Active then
      Open;

    try
      Append;
      AIDTEE := TGenerator.NGetNextGenerator('GEN_ID_PARAMETROSCALCULOTEE', dmSicsMain.connOnLine);
      FieldByName('ID').AsInteger := AIDTEE;
      FieldByName('ID_FILA').AsInteger := Fila;
      FieldByName('DATAHORA').AsDateTime := now;
      FieldByName('PARAMETROS_CALCULO').AsString := ParametrosCalculo;
      FieldByName('RESULTADO').AsDateTime := Resultado;

      Post;

      Result := (ApplyUpdates(0) = 0);
      if not Result then
        CancelUpdates;
    finally
      if RecordCount > 50 then
      begin
        LogChanges := False;
        try
          EmptyDataSet;
        finally
          LogChanges := True;
        end;
      end;
    end;
  end; { with cdsAddEvento }
  TfrmDebugParameters.Debugar(tbRegistrosBD, 'Saiu     RegistraParametrosDeCalculoTEE');
end;

function RemoverFilaTicketBD(pFila: Integer): Boolean; overload;
const
  UPDATE_TICKET = 'UPDATE TICKETS SET FILA_ID = NULL WHERE ID_UNIDADE = %d AND FILA_ID = %d';
begin
  TfrmDebugParameters.Debugar(tbRegistrosBD, 'Entrou   RemoverFilaTicketBD Fila: ' + pFila.ToString);

  dmSicsMain.connOnLine.StartTransaction;

  try
    dmSicsMain.connOnLine.ExecSQL(Format(UPDATE_TICKET, [vgParametrosModulo.IdUnidade, pFila]));

    dmSicsMain.connOnLine.Commit;

    Result := True;
  except
    on E: Exception do
    begin
      Result := False;
      dmSicsMain.connOnLine.Rollback;
    end;
  end;

  TfrmDebugParameters.Debugar(tbRegistrosBD, 'Saiu   RemoverFilaTicketBD Fila: ' + pFila.ToString);
end;

function RemoverFilaTicketBD(pFila, pIDTicket: Integer): Boolean;
const
  UPDATE_TICKET =
    'UPDATE TICKETS SET FILA_ID = NULL WHERE ID_UNIDADE = %d AND NUMEROTICKET = %d AND FILA_ID = %d';

var
  lRows: Integer;
begin
  TfrmDebugParameters.Debugar(tbRegistrosBD, 'Entrou   RemoverFilaTicketBD Fila: ' + pFila.ToString + ' Ticket: ' + pIDTicket.ToString);

  dmSicsMain.connOnLine.StartTransaction;

  try
    lRows := dmSicsMain.connOnLine.ExecSQL(Format(UPDATE_TICKET,
      [vgParametrosModulo.IdUnidade, pIDTicket, pFila]));

    if lRows > 1 then
    begin
      raise Exception.Create(Format('Foram afetados %d registros!', [lRows]));
    end;

    dmSicsMain.connOnLine.Commit;

    Result := True;
  except
    on E: Exception do
    begin
      Result := False;
      dmSicsMain.connOnLine.Rollback;
    end;
  end;

  TfrmDebugParameters.Debugar(tbRegistrosBD, 'Saiu   RemoverFilaTicketBD Fila: ' + pFila.ToString + ' Ticket: ' + pIDTicket.ToString);
end;

function DirecionarTicketParaFilaBD(pIDTicket, pFilaAnterior, pNovaFila,
  pOrdem: integer): Boolean;
const
  UPDATE_TICKET =
    'UPDATE TICKETS SET FILA_ID = %d, ORDEM = %d WHERE ID_UNIDADE = %d AND NUMEROTICKET = %d AND FILA_ID = %d';
  SELECT_MAX =
    'SELECT COALESCE(MAX(ORDEM), 0) + 1 FROM TICKETS WHERE ID_UNIDADE = %d AND FILA_ID = %d';
  SELECT_MIN =
    'SELECT COALESCE(MIN(ORDEM), 0) - 1 FROM TICKETS WHERE ID_UNIDADE = %d AND FILA_ID = %d';

var
  lRows: Integer;

  lOrdemTicket: Integer;
begin
  TfrmDebugParameters.Debugar (tbRegistrosBD, 'Entrou   DirecionarTicketParaFilaBD Fila Anterior: ' + pFilaAnterior.ToString +
                                                                                    ' Nova Fila: ' + pNovaFila.ToString +
                                                                                       ' Ticket: ' + pIDTicket.ToString);

  dmSicsMain.connOnLine.StartTransaction;

  try
    case pOrdem of
      - 1:
        lOrdemTicket := dmSicsMain.connOnLine.ExecSQLScalar
          (Format(SELECT_MIN, [vgParametrosModulo.IdUnidade, pNovaFila]));
      -2:
        lOrdemTicket := dmSicsMain.connOnLine.ExecSQLScalar
          (Format(SELECT_MAX, [vgParametrosModulo.IdUnidade, pNovaFila]));
    else
      lOrdemTicket := 0;
    end;

    lRows := dmSicsMain.connOnLine.ExecSQL(Format(UPDATE_TICKET,
      [pNovaFila, lOrdemTicket, vgParametrosModulo.IdUnidade, pIDTicket,
      pFilaAnterior]));

    if lRows > 1 then
    begin
      raise Exception.Create(Format('Foram afetados %d registros!', [lRows]));
    end;

    dmSicsMain.connOnLine.Commit;

    Result := True;
  except
    on E: Exception do
    begin
      Result := False;
      dmSicsMain.connOnLine.Rollback;
    end;
  end;

  TfrmDebugParameters.Debugar (tbRegistrosBD, 'Saiu   DirecionarTicketParaFilaBD Fila Anterior: ' + pFilaAnterior.ToString +
                                                                                  ' Nova Fila: ' + pNovaFila.ToString +
                                                                                     ' Ticket: ' + pIDTicket.ToString);
end;

function LocalizarTicket(pNumeroTicket: integer;
  var pIDTicket, pIDFila: integer; var pNomeCliente: String;
  var pCreatedAt: TDateTime): Boolean;
begin
  Result := False;

  dmSicsServidor.qryIDTicket.Close;
  dmSicsServidor.qryIDTicket.ParamByName('NUMEROTICKET').AsInteger :=
    pNumeroTicket;
  dmSicsServidor.qryIDTicket.Open;

  if not dmSicsServidor.qryIDTicket.IsEmpty then
  begin
    pIDTicket    := dmSicsServidor.qryIDTicketID.AsInteger;
    pIDFila      := dmSicsServidor.qryIDTicketFILA_ID.AsInteger;
    pNomeCliente := dmSicsServidor.qryIDTicketNOMECLIENTE.AsString;
    pCreatedAt   := dmSicsServidor.qryIDTicketCREATEDAT.AsDateTime;
    Result       := True;
  end;

  dmSicsServidor.qryIDTicket.Close;
end;

function LimparFilaTicket(IDTicket, Fila: Integer): Boolean;
const
  UPDATE_TICKET_FILA =
    'UPDATE TICKETS SET FILA_ID = NULL WHERE ID_UNIDADE = %d AND NUMEROTICKET = %d AND FILA_ID IS NOT NULL';

var
  lRows: Integer;

  // lOrdemTicket: Integer;
begin
  TfrmDebugParameters.Debugar(tbRegistrosBD, 'Entrou   LimparFilaTicket Fila: ' + Fila.ToString +
                                                                    ' Ticket: ' + IDTicket.ToString);

  dmSicsMain.connOnLine.StartTransaction;

  try
    lRows := dmSicsMain.connOnLine.ExecSQL(Format(UPDATE_TICKET_FILA,
      [vgParametrosModulo.IdUnidade, IDTicket]));

    if lRows > 1 then
    begin
      // raise Exception.Create(Format('Foram afetados %d registros!', [lRows]));
    end;

    dmSicsMain.connOnLine.Commit;

    Result := True;
  except
    on E: Exception do
    begin
      Result := False;
      dmSicsMain.connOnLine.Rollback;
    end;
  end;

  TfrmDebugParameters.Debugar (tbRegistrosBD, 'Saiu LimparFilaTicket Fila: ' + Fila.ToString +
                                                                ' Ticket: ' + IDTicket.ToString);
end;

function LimpaTodosAlarmesAtivoPAs : boolean;
begin
  dmSicsMain.connOnLine.ExecSQL('delete from PIS_ALARMES_ATIVOS_POR_PA where ID_UNIDADE = ' + inttostr(vgParametrosModulo.IdUnidade));
end;

function GravaAlarmeAtivoPA (PA : integer; NomeIndicador, NomeNivel : string; CodigoCorNivel : integer; Mensagem : string) : boolean;
begin
  TfrmDebugParameters.Debugar(tbRegistrosBD, 'Entrou   GravaAlarmeAtivoPA');
  Result := False;
  with dmSicsServidor.cdsAddAlarmeAtivoPA do
  begin
    if not Active then
      Open;

    try
      Append;
      FieldByName('ID_PA'         ).AsInteger := PA;
      FieldByName('NOMEINDICADOR' ).AsString  := NomeIndicador;
      FieldByName('NOMENIVEL'     ).AsString  := NomeNivel;
      FieldByName('CODIGOCORNIVEL').AsInteger := CodigoCorNivel;
      FieldByName('MENSAGEM'      ).AsString  := Mensagem;
      Post;

      Result := (ApplyUpdates(0) = 0);
      if not Result then
        CancelUpdates;
    finally
      if RecordCount > 50 then
      begin
        LogChanges := False;
        try
          EmptyDataSet;
        finally
          LogChanges := True;
        end;
      end;
    end;
  end;
  TfrmDebugParameters.Debugar(tbRegistrosBD, 'Saiu     GravaAlarmeAtivoPA');
end;

function LimpaTodasQtdEsperaPAs : boolean;
begin
  dmSicsMain.connOnLine.ExecSQL('delete from QTD_ESPERA_POR_PA where ID_UNIDADE = ' + inttostr(vgParametrosModulo.IdUnidade));
end;

function GravaQtdEsperaPA (PA : integer; QtdEspera : integer) : boolean;
begin
  TfrmDebugParameters.Debugar(tbRegistrosBD, 'Entrou   GravaQtdEsperaPA');
  Result := False;
  with dmSicsServidor.cdsAddQtdEsperaPA do
  begin
    if not Active then
      Open;

    try
      Append;
      FieldByName('ID_PA'     ).AsInteger := PA;
      FieldByName('QTD_ESPERA').AsInteger := QtdEspera;
      Post;

      Result := (ApplyUpdates(0) = 0);
      if not Result then
        CancelUpdates;
    finally
      if RecordCount > 50 then
      begin
        LogChanges := False;
        try
          EmptyDataSet;
        finally
          LogChanges := True;
        end;
      end;
    end;
  end;
  TfrmDebugParameters.Debugar(tbRegistrosBD, 'Saiu     GravaQtdEsperaPA');
end;

function VerificaChamadaAutomatica(IdPA: integer): Boolean;
begin
  Result := (not SomenteRedirecionar) and
    ExisteNoIntArray(IdPA, dmSicsServidor.PAsComChamadaAutomatica);
end;

function VerificaChamadaAutomaticaSemFlag(IdPA: integer): boolean;
begin
  Result := ExisteNoIntArray(IdPA, dmSicsServidor.PAsComChamadaAutomatica);
end;

function VerificaFilaChamadaAutomatica(Fila: Integer): Boolean;
begin
  Result := (Fila >= 0) and
    (Fila <= Length(dmSicsServidor.FilasComChamadaAutomatica) - 1) and
    (Length(dmSicsServidor.FilasComChamadaAutomatica[Fila].PAs) > 0);
end;

procedure TdmSicsServidor.cdsAddTicketReconcileError
  (DataSet: TCustomClientDataSet; E: EReconcileError; UpdateKind: TUpdateKind;
  var Action: TReconcileAction);
begin
  MyLogException(E);
end;

procedure TdmSicsServidor.cdsAddTicketTagReconcileError
  (DataSet: TCustomClientDataSet; E: EReconcileError; UpdateKind: TUpdateKind;
  var Action: TReconcileAction);
begin
  MyLogException(E);
end;

procedure TdmSicsServidor.cdsAddTicketAgendamentosFilasReconcileError
  (DataSet: TCustomClientDataSet; E: EReconcileError; UpdateKind: TUpdateKind;
  var Action: TReconcileAction);
begin
  MyLogException(E);
end;

procedure TdmSicsServidor.cdsAddEventoReconcileError
  (DataSet: TCustomClientDataSet; E: EReconcileError; UpdateKind: TUpdateKind;
  var Action: TReconcileAction);
var
  I: integer;
  sDados: string;
begin
  sDados := '';
  for I  := 0 to cdsAddEvento.Fields.Count - 1 do
  begin
    if sDados <> '' then
      sDados := sDados + #13 + #10;
    sDados := sDados + cdsAddEvento.Fields[I].FieldName + '=' +
      cdsAddEvento.Fields[I].AsString;
  end;
  E.Message := E.Message + #13 + #10 + 'Dados:' + #13 + #10 + sDados;
  MyLogException(E);
end;

procedure TdmSicsServidor.cdsAddEventoPPReconcileError
  (DataSet: TCustomClientDataSet; E: EReconcileError; UpdateKind: TUpdateKind;
  var Action: TReconcileAction);
var
  I: integer;
  sDados: string;
begin
  sDados := '';
  for I  := 0 to cdsAddEventoPP.Fields.Count - 1 do
  begin
    if sDados <> '' then
      sDados := sDados + #13 + #10;
    sDados := sDados + cdsAddEventoPP.Fields[I].FieldName + '=' +
      cdsAddEventoPP.Fields[I].AsString;
  end;
  E.Message := E.Message + #13 + #10 + 'Dados:' + #13 + #10 + sDados;
  MyLogException(E);
end;


procedure TdmSicsServidor.CarregarFilasComChamadaAutomatica;
var
  // FilasComChamadaAutomaticaStr: string;
  I, C, F, PA: Integer;
  sWhere: string;
begin
  // ********************************************************************************
  // Filas com chamada automática
  // ********************************************************************************
  if Length(PAsComChamadaAutomatica) > 0 then
  begin
    Finalize(FilasComChamadaAutomatica);
    sWhere := '';
    for I := 0 to High(PAsComChamadaAutomatica) do
      sWhere := sWhere + IntToStr(PAsComChamadaAutomatica[I]) + ',';

    sWhere := '(' + Copy(sWhere, 1, Length(sWhere) - 1) + ')';

    cdsFilasChamadaAutomatica.Active    := False;
    qryFilasChamadaAutomatica.Sql.Text :=
      'SELECT ID_FILA, ID_PA FROM NN_PAS_FILAS WHERE ID_UNIDADE = :ID_UNIDADE AND ID_PA IN '
      + sWhere + ' ORDER BY ID_FILA, ID_PA';
    qryFilasChamadaAutomatica.ParamByName('ID_UNIDADE').AsInteger :=
      vgParametrosModulo.IdUnidade;
    cdsFilasChamadaAutomatica.Active    := True;

    if not cdsFilasChamadaAutomatica.IsEmpty then
    begin
      cdsFilasChamadaAutomatica.Last;
      C := cdsFilasChamadaAutomatica.FieldByName('ID_FILA').AsInteger + 1;
      SetLength(FilasComChamadaAutomatica, C);
      cdsFilasChamadaAutomatica.First;
      while not cdsFilasChamadaAutomatica.Eof do
      begin
        F := cdsFilasChamadaAutomatica.FieldByName('ID_FILA').AsInteger;
        if F > -1 then
        begin
          PA  := Length(FilasComChamadaAutomatica[F].PAs);
          SetLength(FilasComChamadaAutomatica[F].PAs, PA + 1);

          FilasComChamadaAutomatica[F].PAs[PA] :=
            cdsFilasChamadaAutomatica.FieldByName('ID_PA').AsInteger;
          cdsFilasChamadaAutomatica.Next;

        end;
      end;
    end;

  end;
end;

end.
