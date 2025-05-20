{

Funcionando como contingente, ao inserir registro na tabela evento checar
se o id do ticket realmente existe na tabela ticket, pois pode nao estar
pq soh foi gerado no principal...neste caso gerar com o mesmo id. E na hora
de inserir um novo ticket pq imprimiu a senha, gerar com id negativo, neste
caso consome o generator como positivo mas inverte o sinal quando for pro banco
e na hora de migrar pro principal fazer um tabela DE -> PARA convertendo negativo
em positivo

24/09 - Terminei o processo de replicacao do contingencia p/ o principal,
        testei uma vez, mas testar denovo.
29/09 - Ajustei os pontos que geram o ticket para inserir com id negativo qdo fosse contigencia
      - Ajustei o ponto que insere o evento para checar se o ticket existe quando eh contingente,
        senao achar ja insere
01/10 - Ajustes nas rotinas para a replicacao ida->volta (arquivos e banco)
      - Ajustes na documentacao
      - Controle de Erros
06/10 - Fiz a thread do replicador e mapeei os lugarers p/ chama-lo, agora tem de testar
15/10 - Fiz a comunicacao via sockets entre principal e contingencia, entao o P
        ja mando pro C o arquivo e o ID, quando o P entrar no ar ja atualiza o C
        quando o C entra depois o P ja atualiza
20/10 - Controle de quem eh principal/contingente/ativo,
        avaliacao dos ids e tela pra ativar contingente
        testes com pas / replicacao de RT e banco de dados

Todo:
- Codificar os metodos s/ implementacao (prox versao)
- Ajustar o metodo AlertarDeptTI p/ enviar o email e pensar como evitar que a replicacao de RT e Tabelas
fique enviando emails a todos instante, ja que geram exception qdo nao esta conectado
o ideal seria nao gerar a exception
- Servicos OK, porem o botao AtivarPrincipal ou Sincronizar, nao esta fazendo HIDE correto no Form,
dando um duplo clique aparece a tela denovo
}

unit udmContingencia;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}
uses
  SysUtils, Classes, DB, IniFiles, FMTBcd, Provider,
  DBClient, Windows, ExtCtrls, Dialogs, ScktComp, Forms, ASPClientSocket,
  FireDAC.Phys.IB, System.UITypes,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Comp.Client, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.VCLUI.Wait, uDataSetHelper, FireDAC.Phys.Intf, FireDAC.DApt.Intf;

type
  TTipoFuncionamento = (tfNormal, tfPrincipal, tfContingente);
  TTipoAlertaDeptoTI = (
    taNone,
    taErroReplicarRT, taSucessoReplicarRT,
    taErroReplicarTabelas, taSucessoReplicarTabelas,
    taServidorIndisponivel, taServidorDisponivel,
    taContingenteEPrincipalOnLine);

  TThreadReplicacaoP2C = class(TThread)
  protected
    procedure DoTerminate; override;
  public
    procedure Execute; override;
  end;

  TdmSicsContingencia = class(TDataModule)
    SQLConContingencia: TFDConnection;
    cdsReplicacao: TClientDataSet;
    dspReplicacao: TDataSetProvider;
    qryReplicacao: TFDQuery;
    qryAuxPrincipal: TFDQuery;
    cdsZiparArquivosRT: TClientDataSet;
    cdsZiparArquivosRTNOME: TStringField;
    cdsZiparArquivosRTARQUIVO: TBlobField;
    cdsZiparArquivosRTRT_ID: TIntegerField;
    qryContingenteTickets: TFDQuery;
    cdsPrincipalEventos: TClientDataSet;
    dspPrincipalEventos: TDataSetProvider;
    qryPrincipalEventos: TFDQuery;
    qryContingenteEventos: TFDQuery;
    cdsPrincipalTickets: TClientDataSet;
    dspPrincipalTickets: TDataSetProvider;
    qryPrincipalTickets: TFDQuery;
    ClientSocketReplicacao: TASPClientSocket;
    ServerSocketReplicacao: TServerSocket;
    SQLConnPrincipal: TFDConnection;
    qryGen: TFDQuery;
    ClientSocketVerificarServidorOnLine: TClientSocket;
    TimerConectarReplicacao: TTimer;
    procedure DataModuleCreate(Sender: TObject);
    procedure cdsReplicacaoReconcileError(DataSet: TCustomClientDataSet;
      E: EReconcileError; UpdateKind: TUpdateKind;
      var Action: TReconcileAction);
    procedure cdsPrincipalEventosReconcileError(
      DataSet: TCustomClientDataSet; E: EReconcileError;
      UpdateKind: TUpdateKind; var Action: TReconcileAction);
    procedure ServerSocketReplicacaoClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure cdsZiparArquivosRTAfterOpen(DataSet: TDataSet);
    procedure ServerSocketReplicacaoClientError(Sender: TObject;
      Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer);
    procedure ServerSocketReplicacaoClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ClientSocketReplicacaoConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ClientSocketReplicacaoError(Sender: TObject;
      Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer);
    procedure ClientSocketVerificarServidorOnLineConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ClientSocketVerificarServidorOnLineError(Sender: TObject;
      Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer);
    procedure TimerConectarReplicacaoTimer(Sender: TObject);
    procedure ServerSocketReplicacaoClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
  private
    FPathBanco: string;
    FRealTimeIdP: Integer;
    FRealTimeIdMemC: Integer;
    FTipoFuncionamento: TTipoFuncionamento;
    FThreadReplicacaoP2CExecuting: Boolean;
    FRequisicaoReplicacaoP2C: Boolean;
    FPathRealTime: string;
    FConectadoServidor: Boolean;
    FRecebeuArquivoRTTmp: Boolean;
    FTemp: Boolean;
    FSituacaoIrregular: Boolean;
    FEnviarEmailsMonitoramento: Boolean;
    FEmailMonitoramento: string;

    FArquivoRTTmp: TMemoryStream;
    FTamanhoArquivoRTTmp: Int64;
    FRecebendoArquivoRTTmp: Boolean;
    FContingenciaAtivo: Boolean;
    FHoraUltimoEnvioEmail: array[TTipoAlertaDeptoTI] of TDateTime;


    function GetPathTemp: string;

    procedure ExcluirArquivo(const Path: string);

    procedure ReplicarTabela(const Tabela, CamposChave: string);
    procedure EnviarRTIdServidorContingencia(Id: Integer);
    procedure EnviarRTIdPAS(Id: Integer; ReenviarParaContingencia: Boolean);
    procedure ZiparArquivosRealTime(DirOrigem, PathZipDestino: string; RealTimeId: Integer);
    procedure EnviarArquivoRealTimeZipado(const PathOrigem: string);
    procedure ExtrairArquivosRealTime(PathZip, DirDestino: string; var RTId: Integer);
    procedure ReplicarTabelasC2P;
    procedure ReplicarArquivosRealTimeC2P(const PathZipDestino: string);
    procedure AlertarDeptoTI(TipoAlerta: TTipoAlertaDeptoTI; MsgAux: string);
    function  ObterMaiorRTIdPas: Integer;
    procedure GerarNovoRTId;
    procedure ReplicarTabelasP2C(Thread: Boolean);
    procedure ReplicarArquivosRealTimeP2C;
    function  GetRealTimeIdP: Integer;
    function  ConexaoHwsDisponivel: Boolean;
    function  VerificarServidorOpostoOnLine: Boolean;

    procedure SetThreadReplicacaoP2CExecuting(const Value: Boolean);
  public
    procedure CarregarConfiguracoes(AtivarSockets: Boolean);

    procedure CheckGerarNovoRTId;
    procedure CheckReplicarTabelasP2C;
    procedure CheckReplicarArquivosRealTimeP2C;

    procedure SincronizarPrincipal;
    function  AvaliarContingente(var RTIdArquivo: Integer): Boolean;
    procedure AtivarContingente;

    property RealTimeIdP: Integer read GetRealTimeIdP write FRealTimeIdP;
    property RealTimeIdMemC: Integer read FRealTimeIdMemC write FRealTimeIdMemC;
    property TipoFuncionamento: TTipoFuncionamento read FTipoFuncionamento write FTipoFuncionamento;
    property ThreadReplicacaoP2CExecuting: Boolean read FThreadReplicacaoP2CExecuting write SetThreadReplicacaoP2CExecuting;
    property ContingenciaAtivo: Boolean read FContingenciaAtivo write FContingenciaAtivo;
    property SituacaoIrregular: Boolean read FSituacaoIrregular write FSituacaoIrregular;
  end;

var
  dmSicsContingencia: TdmSicsContingencia;

implementation

uses
  MyDlls_DR,  ClassLibraryVCL,
  ufrmContingencia, uFuncoes, sics_94, sics_m, DateUtils, UConexaoBD, ASPGenerator;

{$R *.dfm}

{ TdmContingencia }

const
  FILE_NAME_RT_ZIP = 'file.zip';
  CMD_CLOSE_PORTS = '1';
  CMD_SEND_RT_TO_PRINCIPAL = '2';
  CMD_REOPEN_CONTINGENCIA = '3';
  CMD_PORTS_CLOSED = '4';
  CMD_RTID = 'RTID=';
  CMD_RTFILE = 'RTFILE=';

var
  CritSect: TRTLCriticalSection;

procedure TdmSicsContingencia.CarregarConfiguracoes(AtivarSockets: Boolean);
begin
  with TIniFile.Create(GetIniFileName)  do
  try
    FTipoFuncionamento := TTipoFuncionamento(ReadInteger('CONTINGENCIA', 'TipoFuncionamento', 0));
    FContingenciaAtivo := ReadBool('CONTINGENCIA', 'ServidorContingenciaAtivo', False);
    FPathBanco := ReadString('CONTINGENCIA', 'BaseDeDadosContingente', '');
    FEnviarEmailsMonitoramento := ReadBool('EmailsDeMonitoramento', 'EnviarEmailsDeMonitoramento', False);
    FEmailMonitoramento := ReadString('EmailsDeMonitoramento', 'Contingencia', 'suporte_sw@aspect.com.br');

    WriteString ('EmailsDeMonitoramento', 'Contingencia', FEmailMonitoramento);

    if FTipoFuncionamento in [tfPrincipal, tfContingente] then
    begin
      if AtivarSockets then
      begin
        ClientSocketVerificarServidorOnLine.Port := ReadInteger('Settings', 'TcpPort', 0);

        if FTipoFuncionamento = tfPrincipal then
        begin
          ClientSocketVerificarServidorOnLine.Host := ReadString('CONTINGENCIA', 'TCPSrvAdrContingencia', '');

          // se no INI nao foi definido como INI, entao ainda checo senao esta online
          // se tiver ja atualizo o INI
          if not FContingenciaAtivo then
          begin
            FContingenciaAtivo := VerificarServidorOpostoOnLine;
            if FContingenciaAtivo then
            begin
              WriteBool('CONTINGENCIA', 'ServidorContingenciaAtivo', True);
            end;
          end;
        end;

        if FTipoFuncionamento = tfContingente then
        begin
          ClientSocketVerificarServidorOnLine.Host := ReadString('CONTINGENCIA', 'TCPSrvAdrPrincipal', '');
          if (FContingenciaAtivo) and (VerificarServidorOpostoOnLine) then
          begin
            AlertarDeptoTI(taContingenteEPrincipalOnLine, '');
            SituacaoIrregular := True;
            MessageDlg('Não é possível inicializar o contingente, pois o servidor principal está no ar',
              mtError, [mbOk], 0);
          end;
        end;

        if not SituacaoIrregular then
        begin
          ServerSocketReplicacao.Port := ReadInteger('CONTINGENCIA', 'TcpPortReplicacao', 0);
          ServerSocketReplicacao.Active := True;

          ClientSocketReplicacao.Port := ReadInteger('CONTINGENCIA', 'TcpPortReplicacao', 0);
          if FTipoFuncionamento = tfPrincipal then
            ClientSocketReplicacao.Host := ReadString('CONTINGENCIA', 'TCPSrvAdrContingencia', '');
          if FTipoFuncionamento = tfContingente then
            ClientSocketReplicacao.Host := ReadString('CONTINGENCIA', 'TCPSrvAdrPrincipal', '');
          ClientSocketReplicacao.Active := True;

          if not FContingenciaAtivo then
            TimerConectarReplicacao.Enabled := True;
        end;
      end;
    end;

  finally
    Free;
  end;

  with SQLConContingencia do
  begin
    Params.Values['DATABASE'] := FPathBanco;
  end;
end;

procedure TdmSicsContingencia.ReplicarTabela(const Tabela, CamposChave: string);
var
  i: Integer;
  StrListChavesNomes, StrListChavesValores: TStringList;
begin
  StrListChavesNomes := nil;
  StrListChavesValores := nil;
  try
    StrListChavesNomes := TStringList.Create;
    StrListChavesValores := TStringList.Create;

    StrListChavesNomes.Text := StringReplace(CamposChave, ';', #13 + #10, [rfReplaceAll]);

    with qryAuxPrincipal, Sql do
    begin
      Connection := dmSicsMain.connOnLine;

      Text := 'select * from ' + Tabela + ' WHERE ID_UNIDADE = ' + vgParametrosModulo.IdUnidade.ToString;
      Open;
      try

        qryReplicacao.Sql.Text := 'select * from ' + UpperCase(Tabela) + ' WHERE ID_UNIDADE = ' + vgParametrosModulo.IdUnidade.ToString;
        cdsReplicacao.Open;
        try

          while not Eof do
          begin

            StrListChavesValores.Clear;
            for i := 0 to StrListChavesNomes.Count -1 do
              StrListChavesValores.Append(FieldByName(StrListChavesNomes[i]).AsString);

            if cdsReplicacao.Locate(CamposChave, VarArrayFromStrings(StrListChavesValores), []) then
              cdsReplicacao.Edit
            else
              cdsReplicacao.Append;

            for i := 0 to Fields.Count -1 do
              cdsReplicacao.FieldByName(Fields[i].FieldName).Value := Fields[i].Value;

            cdsReplicacao.Post;

            Next;
          end;

          cdsReplicacao.ApplyUpdates(0);

        finally
          cdsReplicacao.Close;
        end;


      finally
        Close;
      end;

    end;

  finally
    StrListChavesNomes.Free;
    StrListChavesValores.Free;
  end;
end;

{
  Replica todas tabelas (menos de ticket e eventos) do servidor principal
  para o servidor de contingencia
}
procedure TdmSicsContingencia.ReplicarTabelasP2C(Thread: Boolean);
begin
  try
    if Thread then
    begin

      // to checando somente se foi requisitado o modo thread, pois neste caso
      // sei que estou no objeto "dmcontingencia" da aplicacao e os sockets estarao conectados
      // quando nao eh modo thread, entao esta usando o "dmcontingencia" da thread
      // e neste caso os sockets estao sempre desligados
      if not ClientSocketReplicacao.Active then
        raise Exception.Create('Servidor Contingente indisponível');

      // se a thread esta sendo executada
      if FThreadReplicacaoP2CExecuting then
      begin
        // ativando a requisicao p/ executar logo que concluir a thread
        if not FRequisicaoReplicacaoP2C then
          FRequisicaoReplicacaoP2C := True;
        Exit;
      end;

      // executando a thread
      with TThreadReplicacaoP2C.Create(True) do
      begin
        FreeOnTerminate := True;
        FThreadReplicacaoP2CExecuting := True;
        Start;
        Exit;
      end;
    end;

    SQLConContingencia.Connected := True;
    try

      ReplicarTabela('GRUPOS_ATENDENTES', 'ID');
      ReplicarTabela('GRUPOS_PAINEIS', 'ID');
      ReplicarTabela('MODELOS_PAINEIS', 'ID');
      ReplicarTabela('GRUPOS_PAS', 'ID');
      ReplicarTabela('CELULARES', 'ID');
      ReplicarTabela('EMAILS', 'ID');
      ReplicarTabela('FILAS', 'ID');
      ReplicarTabela('ATENDENTES', 'ID');
      ReplicarTabela('PAINEIS', 'ID');
      ReplicarTabela('NN_PAINEIS_GRUPOSPAINEIS', 'ID_PAINEL;ID_GRUPOPAINEL');
      ReplicarTabela('PAS', 'ID');
      ReplicarTabela('NN_PAS_FILAS', 'ID_PA;ID_FILA');
      ReplicarTabela('PIS_FUNCOES', 'ID_PIFUNCAO');
      ReplicarTabela('PIS_HORARIOS', 'ID_PIHORARIO');
      ReplicarTabela('PIS_NIVEIS', 'ID_PINIVEL');
      ReplicarTabela('PIS_POSICAO', 'ID_PIPOS');
      ReplicarTabela('PIS_TIPOS', 'ID_PITIPO');
      ReplicarTabela('PIS_ACOES_DE_ALARMES', 'ID_PIACAODEALARME');
      ReplicarTabela('PIS', 'ID_PI');
      ReplicarTabela('PIS_MONITORAMENTOS', 'ID_PIMONITORAMENTO');
      ReplicarTabela('PIS_ALARMES', 'ID_PIALARME');
      ReplicarTabela('PIS_RELACIONADOS', 'ID_PI;ID_RELACIONADO');
      ReplicarTabela('PIS_ALARMES_RELACIONADOS', 'ID_PIALARME;ID_RELACIONADO');
      ReplicarTabela('TIPOS_EVENTOS', 'ID');

    finally
      SQLConContingencia.Connected := False;
    end;

    EnterCriticalSection(CritSect);
    try
      dmSicsContingencia.AlertarDeptoTI(taSucessoReplicarTabelas, '');
    finally
      LeaveCriticalSection(CritSect);
    end;
  except
    on E: Exception do
    try
      AlertarDeptoTI(taErroReplicarTabelas, E.Message);
    except
      //
    end;
  end;
end;
{

Replica as tabelas (eventos e tickets) do servidor de contingencia para o principal
e exclui posteriormente. Tambem converte os ids negativos dos tickets para positivos e
atualiza o clientdataset que mantem as senhas para que os ids negativos dos tickets sejam atualizados,
portanto antes de chamar este metodo eh necessario que o metodo que copia os arquivos RT
do contigencia para o principal tenha sido chamado anteriormente

}
procedure TdmSicsContingencia.ReplicarTabelasC2P;
var
  //TDPrincipal, TDContingente: TFDTransaction;
  i, iNovoIdTicket: Integer;
  sPathTicket: string;
  cdsTicket: TClientDataSet;

  function GetNextGeneratorEvento: Integer;
  begin
    {DONE -oRafael Araujo -cCompatibilização SQL Server : Select em RDB$DATABASE só funcionará com Firebird}
    {
    qryGen.Connection := SQLConnPrincipal;
    qryGen.SQL.Text := 'select gen_id(gen_id_evento, 1) as newid from rdb$database';
    qryGen.Open;
    try
      Result := qryGen.FieldByName('newid').AsInteger;
    finally
      qryGen.Close;
    end;
    }

    Result := TGenerator.NGetNextGenerator('GEN_ID_EVENTO', SQLConnPrincipal);
  end;

  function GetNewGeneratorTicket: Integer;
  begin
    {DONE -oRafael Araujo -cCompatibilização SQL Server : Select em RDB$DATABASE só funcionará com Firebird}
    {
    qryGen.Connection := SQLConnPrincipal;
    qryGen.SQL.Text := 'select gen_id(gen_id_ticket, 1) as newid from rdb$database';
    qryGen.Open;
    try
      Result := qryGen.FieldByName('newid').AsInteger;
    finally
      qryGen.Close;
    end;
    }

    Result := TGenerator.NGetNextGenerator('GEN_ID_EVENTO', SQLConnPrincipal);
  end;
begin
  with TIniFile.Create(GetIniFileName)  do
  try
    SQLConnPrincipal.Params.Values['DATABASE'] :=
      ReadString ('Settings', 'BaseDeUnidades', GetApplicationPath + '\DbaseV5\SICSBASEv5.FDB');
  finally
    Free;
  end;

  qryAuxPrincipal.Connection := SQLConnPrincipal;

  cdsTicket := nil;
  try
    sPathTicket := IncludeTrailingPathDelimiter(FPathRealTime) + 'PSWDSIDS.DAT';

    cdsTicket := TClientDataSet.Create(Self);
    cdsTicket.LoadFromFile(sPathTicket);

    cdsPrincipalEventos.Open;
    cdsPrincipalTickets.Open;

    with qryContingenteTickets do
    begin
      Open;
      try
        while not Eof do
        begin
          SQLConnPrincipal.StartTransaction;
          SQLConContingencia.StartTransaction;
          try

            if FieldByName('id').AsInteger > 0 then
            begin
              iNovoIdTicket := FieldByName('id').AsInteger;

              qryAuxPrincipal.SQL.Text := 'select id, numeroticket from tickets where ID_UNIDADE = :ID_UNIDADE AND id = :id';
              qryAuxPrincipal.ParamByName('ID_UNIDADE').AsInteger := vgParametrosModulo.IdUnidade;
              qryAuxPrincipal.ParamByName('id').AsInteger := FieldByName('id').AsInteger;

              qryAuxPrincipal.Open;
              try
                if qryAuxPrincipal.IsEmpty then
                  raise Exception.Create('Ticket ' + FieldByName('id').AsString + ' não localizado no servidor principal');
                if qryAuxPrincipal.FieldByName('numeroticket').Value <> FieldByName('numeroticket').Value then
                  raise Exception.Create('Número da senha do Ticket ' + FieldByName('id').AsString + ' diferente entre principal e contingente');
              finally
                qryAuxPrincipal.Close;
              end;
            end
            else
            begin
              iNovoIdticket := GetNewGeneratorTicket;

              cdsPrincipalTickets.Append;
              for i := 0 to Fields.Count -1 do
                cdsPrincipalTickets.FieldByName(Fields[i].FieldName).Value := Fields[i].Value;
              cdsPrincipalTickets.FieldByName('id').AsInteger := iNovoIdTicket;
              cdsPrincipalTickets.Post;
              cdsPrincipalTickets.ApplyUpdates(0);
            end;

            qryContingenteEventos.ParamByName('id_ticket').AsInteger := FieldByName('id').AsInteger;
            qryContingenteEventos.Open;
            try
              while not qryContingenteEventos.Eof do
              begin
                cdsPrincipalEventos.Append;
                for i := 0 to qryContingenteEventos.Fields.Count -1 do
                  cdsPrincipalEventos.FieldByName(qryContingenteEventos.Fields[i].FieldName).Value :=
                    qryContingenteEventos.Fields[i].Value;
                cdsPrincipalEventos.FieldByName('id').AsInteger :=  GetNextGeneratorEvento;
                cdsPrincipalEventos.FieldByName('id_ticket').Value := iNovoIdTicket;
                cdsPrincipalEventos.Post;

                qryContingenteEventos.Next;
              end;
              cdsPrincipalEventos.ApplyUpdates(0);
            finally
              qryContingenteEventos.Close;
            end;

            // excluindo os eventos e o ticket do servidor de contingencia
            SQLConContingencia.ExecSQL('delete from eventos where ID_UNIDADE = ' + vgParametrosModulo.IdUnidade.ToString + ' AND id_ticket = ' + FieldByName('id').AsString);
            SQLConContingencia.ExecSQL('delete from tickets where ID_UNIDADE = ' + vgParametrosModulo.IdUnidade.ToString + ' AND id = ' + FieldByName('id').AsString);

            if FieldByName('id').AsInteger < 0 then
            begin
              if cdsTicket.Locate('id', FieldByName('id').AsInteger, []) then
              begin
                cdsTicket.Edit;
                cdsTicket.FieldByName('id').AsInteger := iNovoIdticket;
                cdsTicket.Post;
                cdsTicket.SavetoFile(sPathTicket);
              end;
            end;


            SQLConContingencia.Commit;
            SQLConnPrincipal.Commit;
          except
            SQLConnPrincipal.Rollback;
            SQLConContingencia.Rollback;
            raise;
          end;

          Next;
        end;

      finally
        Close;
      end;

    end;
  finally
    cdsPrincipalEventos.Close;
    cdsPrincipalTickets.Close;
    cdsTicket.Free;
  end;
end;

{
 Replica os arquivos de RealTime do principal para o contigencia. Este metodo
 'zipa' os arquivos e grava no de contigencia na respectiva pasta,
 mas nao perde tempo extraindo, pois este metodo sera chamado a todo instante quando
 ocorrer qq mudanca nos arquivos de RT do principal.
 A descompactacao soh eh necessaria quando o contigente entra no ar
}
procedure TdmSicsContingencia.ReplicarArquivosRealTimeP2C;
var
  sPathTemp: string;
begin
  try
    sPathTemp := GetPathTemp;

    ZiparArquivosRealTime(FPathRealTime, sPathTemp, RealTimeIdP);
    try
      EnviarArquivoRealTimeZipado(sPathTemp);
    finally
      ExcluirArquivo(sPathTemp);
    end;

    AlertarDeptoTI(taSucessoReplicarRT, '');
  except
    on E: Exception do
    begin
      try
        AlertarDeptoTI(taErroReplicarRT, E.Message);
      except
        //
      end;
    end;
  end;
end;

function TdmSicsContingencia.GetRealTimeIdP: Integer;
begin
  if FRealTimeIdP = 0 then
    FRealTimeIdP := TGenerator.NGetCurrentGenerator('RT', dmSicsMain.connOnLine);

  Result := FRealTimeIdP;
end;

{
  Devera testar as portas dos hws p/ ver se estao disponiveis
}
function TdmSicsContingencia.ConexaoHwsDisponivel: Boolean;
begin
  // implementar
  Result := True;
end;

function TdmSicsContingencia.VerificarServidorOpostoOnLine: Boolean;
var
  iSegundos: Integer;
begin
  Result := False;

  FConectadoServidor := False;
  ClientSocketVerificarServidorOnLine.Active := True;
  iSegundos := 0;
  while not FConectadoServidor do
  begin
    Delay(1000);
    Inc(iSegundos);
    Application.ProcessMessages;
    if iSegundos = 10 then
    begin
      ClientSocketVerificarServidorOnLine.Active := False;
      Break;
    end;
  end;

  // senao conseguiu conectar no servidor
  if not ClientSocketVerificarServidorOnLine.Active then
  begin
    // e nao conseguiu conectar nos hws
    if not ConexaoHwsDisponivel then
    begin
      // entao eh pq o servidor esta no ar,
      // porem nao consegui conectar nele,
      Result := True;
    end
    else
    begin
      // se cair aqui eh pq o servidor nao esta no ar
    end;
  end else
  begin
    Result := True;
    ClientSocketVerificarServidorOnLine.Active := False;
  end;
end;

{
  Replica os arquivos de realtime do contingencia para o principal. Este metodo
  tambem zipa os arquivos e grava no principal zipado. Eh chamado que o principal
  precisar ser sincronizado depois de ter ficado fora do ar.
}
procedure TdmSicsContingencia.ReplicarArquivosRealTimeC2P(const PathZipDestino: string);
var
  sPathTemp: string;
begin
  sPathTemp := GetPathTemp;

  ZiparArquivosRealTime(FPathRealTime, sPathTemp, 0);
  try
    EnviarArquivoRealTimeZipado(sPathTemp);
  finally
    ExcluirArquivo(sPathTemp);
  end;
end;

{
  AJUSTAR, fazer o envio de emails
}

procedure TdmSicsContingencia.AlertarDeptoTI (TipoAlerta: TTipoAlertaDeptoTI; MsgAux: string);
var
  Msg            : string;
  vgMinutes      : Integer; // depois pegar do INI
  oposto_sucesso : TTipoAlertaDeptoTI;
begin
  Msg := '';
  vgMinutes := 1;

  // se nao estiver ligado o monitoramente por email ou
  // nao foi definido o email nao faz nada
  if (not FEnviarEmailsMonitoramento) or (FEmailMonitoramento = '') then
    Exit;

  oposto_sucesso := taNone;
  case TipoAlerta of
    taSucessoReplicarRT: oposto_sucesso := taErroReplicarRT;
    taSucessoReplicarTabelas: oposto_sucesso := taErroReplicarTabelas;
    taServidorDisponivel: oposto_sucesso := taServidorIndisponivel;
  end;
  if oposto_sucesso <> taNone then
  begin
    if FHoraUltimoEnvioEmail[oposto_sucesso] = 0 then
      Exit;
    FHoraUltimoEnvioEmail[oposto_sucesso] := 0;
  end;

  if (FHoraUltimoEnvioEmail[TipoAlerta] > 0) and
    (MinutesBetween(Now, FHoraUltimoEnvioEmail[TipoAlerta]) < vgMinutes) then
    Exit
  else
    FHoraUltimoEnvioEmail[TipoAlerta] := Now;

  case TipoAlerta of
    taServidorIndisponivel:
    begin
      if TipoFuncionamento = tfPrincipal then
        Msg := 'Servidor Contingencia indisponível'
      else
        Msg := 'Servidor Principal indisponível';
    end;

    taServidorDisponivel:
    begin
      if TipoFuncionamento = tfPrincipal then
        Msg := 'Servidor principal conectado no contingencia'
      else
        Msg := 'Servidor contingencia conectado no principal'
    end;

    taErroReplicarRT:
    begin
      Msg := 'Erro ao replicar os arquivos de real time';
    end;

    taSucessoReplicarRT:
    begin
      Msg := 'Sucesso ao replicar os arquivos de real time';
    end;

    taErroReplicarTabelas:
    begin
      Msg := 'Erro ao replicar as tabelas';
    end;

    taSucessoReplicarTabelas:
    begin
      Msg := 'Sucesso ao replicar as tabelas';
    end;

    taContingenteEPrincipalOnLine:
    begin
      Msg := 'Contigente tentando entrar no ar com o servidor principal operante';
    end;
  end;


  if MsgAux <> '' then
    Msg := Msg + '-' + MsgAux;

  if Msg <> '' then
  begin
    {$IFDEF SuportaEmail}
    if AspEnviaEmail (FEmailMonitoramento,
                    '*** SICS - Contingência ***',
                    '*********************************************************************'#13#10 +
                    '*  Horário: ' + FormatLeftString(54, FormatDateTime ('dd/mm/yyyy hh:nn:ss', now)                ) + '  *'#13#10 +
                    '*  Status:  ' + FormatLeftString(54, Msg                                                          ) + '  *'#13#10 +
                    '*********************************************************************') then
      MyLogException(EEnvioDeEmail.Create('E-mail de monitoramento enviado com sucesso.'))
    else
      MyLogException(EEnvioDeEmail.Create('Falha ao enviar e-mail de monitoramento.'));
    {$ENDIF SuportaEmail}
  end;
end;

function TdmSicsContingencia.ObterMaiorRTIdPas: Integer;
begin
  // implementar
 Result := 0;
end;

procedure TdmSicsContingencia.GerarNovoRTId;
var
  bPasEnviarRTIdServidor: Boolean;
begin
  FRealTimeIdP := TGenerator.NGetNextGenerator('GEN_ID_RT', dmSicsMain.connOnLine);

  // logo apos gerar o RTId ja mando pro servidor de contingencia
  // ficar com este id na memoria
  bPasEnviarRTIdServidor := False;
  try
    EnviarRTIdServidorContingencia(RealTimeIdP);
  except
    // caso de algum erro, apenas sinalizo para as PAS tentarem mandar
    // o RTId ao servidor de contingencia
    bPasEnviarRTIdServidor := True;
  end;

  // enviando RTId para as PAS
  EnviarRTIdPAS(RealTimeIdP, bPasEnviarRTIdServidor);
end;

procedure TdmSicsContingencia.CheckGerarNovoRTId;
begin
  if FTipoFuncionamento = tfPrincipal then
    GerarNovoRTId;
end;

procedure TdmSicsContingencia.CheckReplicarTabelasP2C;
begin
  if FTipoFuncionamento = tfPrincipal then
    ReplicarTabelasP2C(True);
end;

procedure TdmSicsContingencia.CheckReplicarArquivosRealTimeP2C;
begin
  if FTipoFuncionamento = tfPrincipal then
    ReplicarArquivosRealTimeP2C;
end;

{
 Envia o RID para as PAS e se foi sinalizado devera reenviar o RID para o Contingencia
}
procedure TdmSicsContingencia.EnviarRTIdPAS(Id: Integer; ReenviarParaContingencia: Boolean);
begin
  // fazer via sockets
end;

{
  Envia o RTId para o servidor de contingencia
}
procedure TdmSicsContingencia.EnviarRTIdServidorContingencia(Id: Integer);
begin
  if ClientSocketReplicacao.Active then
    ClientSocketReplicacao.Socket.SendText(AspStringToAnsiString(CMD_RTID + IntToStr(Id)));
end;

{
  Apenas grava o arquivo de origem PathOrigem no PathDestino
  Futuramente podera usar 'sockets' ou outro protocolo para este fim
}
procedure TdmSicsContingencia.EnviarArquivoRealTimeZipado(const PathOrigem: string);
var
  Tamanho: Int64;
  Arquivo: TFileStream;
begin
  if ClientSocketReplicacao.Active then
  begin
    Arquivo := TFileStream.Create(PathOrigem, fmOpenRead or fmShareDenyWrite);
    Tamanho := Arquivo.Size;
    ClientSocketReplicacao.Socket.SendText(AspStringToAnsiString(CMD_RTFILE + IntToStr(Tamanho) + #0));
    ClientSocketReplicacao.Socket.SendStream(Arquivo);
    // NAO EXECUTAR ARQUIVO.FREE, pois o proprio SendStream se encarrega disto
  end
  else
  begin
    if TipoFuncionamento = tfPrincipal then
      raise Exception.Create('Servidor Contingente indisponivel')
    else
      raise Exception.Create('Servidor Principal indisponivel');
  end;
end;

{
  Extrai os arquivos de RealTime a partir do PathZip de origem para a pasta DirDestino
  e retorna qual eh o RTId armazenado no zip.
}
procedure TdmSicsContingencia.ExtrairArquivosRealTime(PathZip, DirDestino: string;
  var RTId: Integer);
var
  iResult: Integer;
  SearchRec: TSearchRec;
begin
  DirDestino := IncludeTrailingPathDelimiter(DirDestino);

  iResult := FindFirst(DirDestino + '*.dat', faAnyFile, SearchRec);
  while iResult = 0 do
  begin
    ExcluirArquivo(DirDestino + SearchRec.Name);
    iResult := FindNext(SearchRec);
  end;

  with cdsZiparArquivosRT do
  begin
    LoadFromFile(PathZip);
    try
      while not Eof do
      begin
        TBlobField(FieldByName('ARQUIVO')).SaveToFile(DirDestino + FieldByName('NOME').AsString);
        Next;
      end;

      // posso pegar o RTId de qualquer registro, pois sao todos iguais
      // foi o jeito mais simples de guardar o RTId no 'zip'
      RTId := FieldByName('RT_ID').AsInteger;
    finally
      Close;
    end;
  end;
end;

{
  Sincroniza o servidor principal copiando do contingente os
  arquivos de real time e as tabelas
}
procedure TdmSicsContingencia.SincronizarPrincipal;
var
  sPathZip: string;
  iRTId: Integer;
  iSegs: Integer;
begin
  FTemp := False;
  ClientSocketReplicacao.Socket.SendText(CMD_CLOSE_PORTS);
  iSegs := 0;
  while not FTemp do
  begin
    Delay(1000);
    Inc(iSegs);
    Application.ProcessMessages;
    if iSegs = 10 then
      raise Exception.Create('Não foi possível obter uma resposta do servidor contingente');
  end;
  FTemp := False;

  sPathZip := FPathRealTime + FILE_NAME_RT_ZIP;

  // copiando os arquivos RT do contigente e trazendo pra ca no path do zip
  FRecebeuArquivoRTTmp := False;
  ClientSocketReplicacao.Socket.SendText(CMD_SEND_RT_TO_PRINCIPAL);
  iSegs := 0;
  while not FRecebeuArquivoRTTmp do
  begin
    Delay(1000);
    Inc(iSegs);
    Application.ProcessMessages;
    if iSegs = 10 then
      raise Exception.Create('Não foi possível obter uma resposta do servidor contingente');
  end;
  FRecebeuArquivoRTTmp := False;

  // extraindo os arquivos
  ExtrairArquivosRealTime(sPathZip, FPathRealTime, iRTId);

  // replicando as tabelas, tem de ser apos extrair os arquivos
  // pois edito o arquivo de senhas na replicacao das tabelas
  ReplicarTabelasC2P;

  // excluindo zip, nao eh necessario mante-lo
  ExcluirArquivo(sPathZip);

  with TIniFile.Create(GetIniFileName)  do
  try
    WriteBool('CONTINGENCIA', 'ServidorContingenciaAtivo', False);
  finally
    Free;
  end;

  ClientSocketReplicacao.Socket.SendText(CMD_REOPEN_CONTINGENCIA);

  uFuncoes.CriarFormsDmsInicializacao(True);
end;

function TdmSicsContingencia.AvaliarContingente(var RTIdArquivo: Integer): Boolean;
var
  iRTId: Integer;
begin
  Result := True;

  // extraindo o zip dos arquivos real time
  ExtrairArquivosRealTime(IncludeTrailingPathDelimiter(FPathRealTime) + FILE_NAME_RT_ZIP, FPathRealTime, iRTId);

  RTIdArquivo:= iRTId;

  // soh acontecera isso se o principal nao conseguiu (nem as PAS) mandar pro
  // contingencia o RTId por sockets, mas consegiu gravar os arquivos RT
  // portanto, neste caso igualo. Ou quando reiniciou o contingente e a
  // variavel FRealTimeIdMemC estava zerada
  if FRealTimeIdMemC < iRTId then
    FRealTimeIdMemC := iRTId;

  // se o RTId na memoria estiver maior,
  // significa que o contingente recebeu por sockets logo que gerou o RTId,
  // mas nao recebeu os arquivos, portanto neste caso de fato esta desatualizado
  if FRealTimeIdMemC > iRTId then
  begin
    Result := False;
  end
  else
  // soh caira aqui quando forem iguais, neste caso nao siginfica que esta
  // atualizado, portanto, pego das PAS o maior ID para 'deduzir' se estou atualizado
  begin
    // se o maior RTId das PAS for maior que o RTId da memoria,
    // entao o contingente esta mesmo desatualizado
    if ObterMaiorRTIdPas > FRealTimeIdMemC then
      Result := False;
  end;
end;

procedure TdmSicsContingencia.AtivarContingente;
begin
  if VerificarServidorOpostoOnLine then
  begin
    MessageDlg('Não é possível ativar o servidor contingente, pois o servidor principal está operante', mtError, [mbOk], 0);
    SysUtils.Abort;
  end;

  with TIniFile.Create(GetIniFileName)  do
  try
    WriteBool('CONTINGENCIA', 'ServidorContingenciaAtivo', True);
    FContingenciaAtivo := True;
  finally
    Free;
  end;

  uFuncoes.CriarFormsDmsInicializacao(True);
end;

{
  Varre a pasta "DirOrigem" pegando todos arquivos .dat
  juntando-os num soh arquivo (PathZipDestino)
}
procedure TdmSicsContingencia.ZiparArquivosRealTime(DirOrigem, PathZipDestino: string; RealTimeId: Integer);
var
  iResult: Integer;
  SearchRec: TSearchRec;
begin
  DirOrigem := IncludeTrailingPathDelimiter(DirOrigem);

  if FileExists(PathZipDestino) then
     ExcluirArquivo(PathZipDestino);

  try
    if not cdsZiparArquivosRT.Active then
      cdsZiparArquivosRT.CreateDataSet;

    iResult := FindFirst(DirOrigem + '*.dat', faAnyFile, SearchRec);
    while iResult = 0 do
    begin
      cdsZiparArquivosRT.Append;
      cdsZiparArquivosRT.FieldByName('RT_ID').AsInteger := RealTimeId;
      cdsZiparArquivosRT.FieldByName('NOME').AsString := SearchRec.Name;
      TBlobField(cdsZiparArquivosRT.FieldByName('ARQUIVO')).LoadFromFile(DirOrigem + SearchRec.Name);
      cdsZiparArquivosRT.Post;

      iResult := FindNext(SearchRec);
    end;

    cdsZiparArquivosRT.SaveToFile(PathZipDestino);
  finally
    while not cdsZiparArquivosRT.Eof do cdsZiparArquivosRT.Delete;
  end;
end;

{
  Monta um path temporario
}
function TdmSicsContingencia.GetPathTemp: string;
  function GetTempDirectory: String;
  var
    tempFolder: array[0..MAX_PATH] of Char;
  begin
    GetTempPath(MAX_PATH, @tempFolder);
    result := StrPas(tempFolder);
  end;
var
   FileName : array[0..MAX_PATH] of Char;
begin
  if GetTempFileName(PChar(GetTempDirectory), PChar('sics'), 0, FileName) = 0 then
    raise Exception.Create ('GetTempFileName error');
  Result := FileName;
end;

{
 Apenas exclui um arquivo e gera uma exception em caso de erro
}
procedure TdmSicsContingencia.ExcluirArquivo(const Path: string);
begin
  if not DeleteFile(Pchar(Path)) then
    raise Exception.Create(SysErrorMessage(GetLastError));
end;


procedure TdmSicsContingencia.DataModuleCreate(Sender: TObject);
var
  i: TTipoAlertaDeptoTI;
begin
  TConexaoBD.DefinirQueriesComoUnidirectional(Self);
  FSituacaoIrregular := False;
  FContingenciaAtivo := False;
  FRealTimeIdMemC := 0;
  FRealTimeIdP := 0;
  FThreadReplicacaoP2CExecuting := False;
  FRequisicaoReplicacaoP2C := False;
  FRecebendoArquivoRTTmp := False;
  FRecebeuArquivoRTTmp := False;
  //FPathRealTime := GetPathRealTime;

  // deixar como -1, pois indica que nem foi usado ainda um envio deste tipo
  for i := Low(TTipoAlertaDeptoTI) to High(TTipoAlertaDeptoTI) do
    FHoraUltimoEnvioEmail[i] := -1;
end;

procedure TdmSicsContingencia.cdsReplicacaoReconcileError(
  DataSet: TCustomClientDataSet; E: EReconcileError;
  UpdateKind: TUpdateKind; var Action: TReconcileAction);
begin
  raise Exception.Create(E.Message);
end;


procedure TdmSicsContingencia.cdsPrincipalEventosReconcileError(
  DataSet: TCustomClientDataSet; E: EReconcileError;
  UpdateKind: TUpdateKind; var Action: TReconcileAction);
begin
  raise Exception.Create(E.Message);
end;

procedure TdmSicsContingencia.SetThreadReplicacaoP2CExecuting(const Value: Boolean);
begin
  if (FThreadReplicacaoP2CExecuting <> Value) then
  begin
    FThreadReplicacaoP2CExecuting := Value;
    if (not FThreadReplicacaoP2CExecuting) and (FRequisicaoReplicacaoP2C) then
    begin
      FRequisicaoReplicacaoP2C := False;
      ReplicarTabelasP2C(True);
    end;
  end;
end;

{ TThreadReplicacaoP2C }

procedure TThreadReplicacaoP2C.DoTerminate;
begin
  inherited;
  dmSicsContingencia.ThreadReplicacaoP2CExecuting := False;
end;

procedure TThreadReplicacaoP2C.Execute;
begin
  inherited;

  // eh necessario trabalhar em outra instancia por ser uma thread
  // senao qq outro processo do sistema poderia alterar os clientdatasets
  // ou acessar o SQLConnection e teriamos erros de acesso
  with TdmSicsContingencia.Create(nil) do
  try
    CarregarConfiguracoes(False);
    ReplicarTabelasP2C(False);
  finally
    Free;
  end;
end;

procedure TdmSicsContingencia.ServerSocketReplicacaoClientRead(Sender: TObject; Socket: TCustomWinSocket);
var
  sPath, sText: string;
  iRTId: Integer;
begin
  sText := AspAnsiStringToString(Socket.ReceiveText);

  if not FRecebendoArquivoRTTmp then
  begin
    if sText = CMD_SEND_RT_TO_PRINCIPAL then
    begin
      ReplicarArquivosRealTimeC2P(FPathRealTime + FILE_NAME_RT_ZIP);
    end;

    if sText = CMD_CLOSE_PORTS then
    begin
      frmSicsMain.ServerSocket1                   .Active := False;
      frmSicsMain.TGSServerSocket                 .Active := False;
      frmSicsMain.ServerSocketRetrocompatibilidade.Active := False;
      with TIniFile.Create(GetIniFileName) do
      try
        WriteBool('CONTINGENCIA', 'ServidorContingenciaAtivo', False);
      finally
        Free;
      end;
      ClientSocketReplicacao.Socket.SendText(CMD_PORTS_CLOSED);
    end;

    if sText = CMD_PORTS_CLOSED then
    begin
      FTemp := True;
    end;

    if sText = CMD_REOPEN_CONTINGENCIA then
    begin
      DestruirFormsDmsInicializacao;
      Forms.Application.CreateForm(TfrmSicsContingencia, frmSicsContingencia);
      frmSicsContingencia.Show;
    end;

    // recebendo RTID
    if Copy(sText, 1, Length(CMD_RTID)) = CMD_RTID then
    begin
      iRTId := StrToInt(Copy(sText, 6, Length(sText) - 5));
      if iRTId > FRealTimeIdMemC then // para se precaver de alguma PA mandar id antigo
      begin
        FRealTimeIdMemC := iRtId;
        if Assigned(frmSicsContingencia) then
          frmSicsContingencia.AtualizarUltimaDataHoraRTId;
      end;
      Exit;
    end;

    // recebendo o tamanho do RTFILE
    if Copy(sText, 1, Length(CMD_RTFILE)) = CMD_RTFILE then
    begin
      FTamanhoArquivoRTTmp := StrToInt(Copy(sText, 8, Length(sText) - 7));
      FRecebendoArquivoRTTmp := True;
      Delete(sText, 1, Pos(#0, sText));
      if FArquivoRTTmp = nil then
        FArquivoRTTmp := TMemoryStream.Create;
    end
    else
      Exit;
  end;

  try
    if sText <> '' then
    begin
      FArquivoRTTmp.Write(sText[1], Length(sText));
      if FArquivoRTTmp.Size = FTamanhoArquivoRTTmp then
      begin
        sPath := IncludeTrailingPathDelimiter(FPathRealTime) + FILE_NAME_RT_ZIP;
        if FileExists(sPath) then ExcluirArquivo(sPath);
        FArquivoRTTmp.SaveToFile(sPath);
        FArquivoRTTmp.Free;
        FArquivoRTTmp := nil;

        FRecebendoArquivoRTTmp := False;
        FRecebeuArquivoRTTmp := True;

        if Assigned(frmSicsContingencia) then
          frmSicsContingencia.AtualizarUltimaDataHoraRTFile;
      end;
    end;
  except
    on E: Exception do
      raise Exception.Create('Aqui ' + IntToStr(Length(sText)) + ' ' + E.MessAGE);
  end;
end;

procedure TdmSicsContingencia.cdsZiparArquivosRTAfterOpen(DataSet: TDataSet);
begin
  cdsZiparArquivosRT.LogChanges := False;
end;

procedure TdmSicsContingencia.ServerSocketReplicacaoClientError(
  Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  case ErrorCode of
    10053, 10065 : ErrorCode := 0;
    else begin
           if Sender is TServerSocket then
           begin
             (Sender as TServerSocket).Close;
             Delay(3500);
             (Sender as TServerSocket).Open;
           end;
         end;
  end;
end;

procedure TdmSicsContingencia.ServerSocketReplicacaoClientConnect(
  Sender: TObject; Socket: TCustomWinSocket);
begin
  // esta checagem eh para resolver o problema de ordem de start do servidor principal/contingencia
  // exemplo:
  // o principal entra no ar e o contingente esta desligado, logo o principal nao se conecta no contingente
  // quando o contingente entrar no ar ele se conectara no principal, logo o
  // principal recebendo a conexao checa se nao esta conectado no contingente,
  // senao tiver ja conecta

  // se eu for o principal e o contingencia estiver online, cai fora
  if (FTipoFuncionamento = tfPrincipal) and (FContingenciaAtivo) then Exit;

  if not ClientSocketReplicacao.Active then
    ClientSocketReplicacao.Active := True;
end;

procedure TdmSicsContingencia.ClientSocketReplicacaoConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  AlertarDeptoTI(taServidorDisponivel, '');

  // se eu for o principal e o contingencia estiver online, cai fora
  if (FTipoFuncionamento = tfPrincipal) and (FContingenciaAtivo) then Exit;

  CheckReplicarArquivosRealTimeP2C;
  CheckReplicarTabelasP2C;
end;

procedure TdmSicsContingencia.ClientSocketReplicacaoError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  if ErrorCode = 10061 then
  begin
    if TipoFuncionamento = tfPrincipal then
      AlertarDeptoTI(taServidorIndisponivel, '');
    ErrorCode := 0;
  end;
end;

procedure TdmSicsContingencia.ClientSocketVerificarServidorOnLineConnect(
  Sender: TObject; Socket: TCustomWinSocket);
begin
  FConectadoServidor := True;
end;

procedure TdmSicsContingencia.ClientSocketVerificarServidorOnLineError(
  Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  ErrorCode := 0;
end;

procedure TdmSicsContingencia.TimerConectarReplicacaoTimer(Sender: TObject);
begin
  if ClientSocketReplicacao.Status = ASPClientSocket.ssIdle then
  begin
    ClientSocketReplicacao.Active := True;
    AlertarDeptoTI(taServidorIndisponivel, '');
  end;
end;

procedure TdmSicsContingencia.ServerSocketReplicacaoClientDisconnect(
  Sender: TObject; Socket: TCustomWinSocket);
begin
  AlertarDeptoTI(taServidorIndisponivel, '');
end;

initialization
  InitializeCriticalSection(CritSect);

finalization
  DeleteCriticalSection(CritSect);


end.
