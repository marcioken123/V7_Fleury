unit untMainForm;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  MyDlls_DR, MyAspFuncoesUteis_VCL,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Grids, DBGrids, DB, IniFiles,
  FMTBcd, Provider, DBClient, ExtCtrls, StdCtrls, Buttons, ScktComp, sics_94,
  ImgList, Menus, FireDAC.Phys.IB, FireDAC.Phys.FB, System.ImageList,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Comp.Client, FireDAC.Stan.Param, System.UITypes,
  FireDAC.DatS, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.VCLUI.Wait, Vcl.DBCtrls, FireDAC.Phys.MSSQL,
  IdStack, FireDAC.Phys.Intf, FireDAC.DApt.Intf;

{$INCLUDE ..\SicsVersoes.pas}

type
  TGrupo = class
  private
    FID: Integer;
    FNome: String;
    procedure SetID(const Value: Integer);
    procedure SetNome(const Value: String);
  public
    property ID  : Integer read FID write SetID;
    property Nome: String read FNome write SetNome;
  end;

  TMainForm = class(TForm)
    PageControl: TPageControl;
    tabConexoes: TTabSheet;
    grdUnidades: TDBGrid;
    qryUnidades: TFDQuery;
    dscUnidades: TDataSource;
    cdsUnidades: TClientDataSet;
    dspUnidades: TDataSetProvider;
    cdsUnidadesID: TIntegerField;
    cdsUnidadesNOME: TStringField;
    cdsUnidadesDBDIR: TStringField;
    cdsUnidadesIP: TStringField;
    cdsUnidadesPORTA: TIntegerField;
    cdsUnidadesPORTA_TGS: TIntegerField;
    tabConfiguracoes: TTabSheet;
    tvwConexoes: TTreeView;
    Splitter: TSplitter;
    btnAtualizar: TBitBtn;
    ClientSocket: TClientSocket;
    grpGrupo: TGroupBox;
    btnGrupoPAs: TButton;
    btnGrupoAtendentes: TButton;
    btnGrupoTAGs: TButton;
    grpTabelas: TGroupBox;
    ImageList: TImageList;
    btnPing: TBitBtn;
    btnGrupoPPs: TButton;
    btnGrupoMotivosPausa: TButton;
    btnTotens: TButton;
    btnPaineis: TButton;
    btnFilas: TButton;
    btnPAs: TButton;
    btnAtendentes: TButton;
    btnTAGs: TButton;
    btnPPs: TButton;
    btnMotivosPausa: TButton;
    mnuUnidades: TPopupMenu;
    mnuNovaUnidade: TMenuItem;
    mnuExcluirUnidade: TMenuItem;
    btnCelulares: TButton;
    btnEmails: TButton;
    cdsUnidadesCONECTADO_SOCKET: TIntegerField;
    cdsUnidadesCONECTADO_BASE: TIntegerField;
    grpModulosSics: TGroupBox;
    btnConfigPA: TButton;
    btnConfigMultiPA: TButton;
    btnConfigOnline: TButton;
    btnConfigTGS: TButton;
    btnCaminhosUpdate: TButton;
    GroupBox1: TGroupBox;
    btnConfigGeraisConfigurarEmail: TButton;
    btnConfigGeraisSMS: TButton;
    btnConfigGeraisTestarEmail: TButton;
    btnConfigGeraisTestarSMS: TButton;
    qryAuxScriptBd: TFDQuery;
    cdsUnidadesID_UNID_CLI: TStringField;
    btnClientes: TButton;
    btnConfigCallCenter: TButton;
    connUnidades: TFDConnection;
    cdsUnidadesIDGRUPO: TIntegerField;
    cdsUnidadesHOST: TStringField;
    cdsUnidadesBANCO: TStringField;
    cdsUnidadesUSUARIO: TStringField;
    cdsUnidadesSENHA: TStringField;
    cdsUnidadesOSAUTHENT: TStringField;
    pnlUnidades: TPanel;
    Panel1: TPanel;
    Label1: TLabel;
    cboGrupos: TComboBox;
    Button1: TButton;
    qryGrupo: TFDQuery;
    dsGrupo: TDataSource;
    qryGrupoIDGRUPO: TIntegerField;
    qryGrupoNOME: TStringField;
    dspGrupo: TDataSetProvider;
    cdsGrupo: TClientDataSet;
    cdsGrupoIDGRUPO: TIntegerField;
    cdsGrupoNOME: TStringField;
    qryUnidadesID: TIntegerField;
    qryUnidadesNOME: TStringField;
    qryUnidadesDBDIR: TStringField;
    qryUnidadesIP: TStringField;
    qryUnidadesPORTA: TIntegerField;
    qryUnidadesPORTA_TGS: TIntegerField;
    qryUnidadesID_UNID_CLI: TStringField;
    qryUnidadesIDGRUPO: TIntegerField;
    qryUnidadesHOST: TStringField;
    qryUnidadesBANCO: TStringField;
    qryUnidadesUSUARIO: TStringField;
    qryUnidadesSENHA: TStringField;
    qryUnidadesOSAUTHENT: TStringField;
    qryUnidadesTIPOBANCO: TStringField;
    cdsUnidadesTIPOBANCO: TStringField;
    mnuPingUnidade: TMenuItem;
    pnlRodapeUnidades: TPanel;
    btnNovaUnidade: TBitBtn;
    btnAlterarUnidade: TBitBtn;
    btnExcluirUnidade: TBitBtn;
    btnDevicesUnidade: TButton;
    Label2: TLabel;
    edtFiltro: TEdit;
    menuAcoesTreeView: TPopupMenu;
    menuSCCM: TMenuItem;
    menuPing: TMenuItem;
    menuTelnet: TMenuItem;
    menuPorta9999: TMenuItem;
    menuPorta3001: TMenuItem;
    menuPorta5000: TMenuItem;
    menuOutraPorta: TMenuItem;
    btnSCCM: TBitBtn;
    btnTelnet: TBitBtn;
    BtnSinalTV: TBitBtn;
    btnGrupoCategorias: TButton;
    btnGrupoFilas: TButton;
    btnConfigTV: TButton;
    procedure FormCreate(Sender: TObject);
    procedure cdsUnidadesAfterScroll(DataSet: TDataSet);
    procedure grdUnidadesDblClick(Sender: TObject);
    procedure btnAtualizarClick(Sender: TObject);
    procedure ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure mnuNovaUnidadeClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnPingClick(Sender: TObject);
    procedure mnuExcluirUnidadeClick(Sender: TObject);
    procedure mnuUnidadesPopup(Sender: TObject);
    procedure btnGrupoPAsClick(Sender: TObject);
    procedure btnGrupoAtendentesClick(Sender: TObject);
    procedure btnGrupoTAGsClick(Sender: TObject);
    procedure btnGrupoPPsClick(Sender: TObject);
    procedure btnGrupoMotivosPausaClick(Sender: TObject);
    procedure btnPaineisClick(Sender: TObject);
    procedure btnFilasClick(Sender: TObject);
    procedure btnPAsClick(Sender: TObject);
    procedure btnAtendentesClick(Sender: TObject);
    procedure btnTAGsClick(Sender: TObject);
    procedure btnPPsClick(Sender: TObject);
    procedure btnMotivosPausaClick(Sender: TObject);
    procedure btnTotensClick(Sender: TObject);
    procedure btnCelularesClick(Sender: TObject);
    procedure btnEmailsClick(Sender: TObject);
    procedure btnConfigPAClick(Sender: TObject);
    procedure btnConfigMultiPAClick(Sender: TObject);
    procedure btnConfigOnlineClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnConfigTGSClick(Sender: TObject);
    procedure btnCaminhosUpdateClick(Sender: TObject);
    procedure btnConfigGeraisConfigurarEmailClick(Sender: TObject);
    procedure btnConfigGeraisTestarEmailClick(Sender: TObject);
    procedure btnConfigGeraisSMSClick(Sender: TObject);
    procedure btnConfigGeraisTestarSMSClick(Sender: TObject);
    procedure btnClientesClick(Sender: TObject);
    procedure btnConfigCallCenterClick(Sender: TObject);
    procedure dspUnidadesBeforeUpdateRecord(Sender: TObject; SourceDS: TDataSet;
      DeltaDS: TCustomClientDataSet; UpdateKind: TUpdateKind;
      var Applied: Boolean);
    procedure cdsUnidadesNewRecord(DataSet: TDataSet);
    procedure Button1Click(Sender: TObject);
    procedure cboGruposCloseUp(Sender: TObject);
    procedure btnDevicesUnidadeClick(Sender: TObject);
    procedure cdsUnidadesReconcileError(DataSet: TCustomClientDataSet; E: EReconcileError; UpdateKind: TUpdateKind;
      var Action: TReconcileAction);
    procedure edtFiltroKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure grdUnidadesKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure dscUnidadesDataChange(Sender: TObject; Field: TField);
    procedure menuSCCMClick(Sender: TObject);
    procedure menuTelnetClick(Sender: TObject);
    procedure tvwConexoesMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure menuAcoesTreeViewPopup(Sender: TObject);
    procedure tvwConexoesChange(Sender: TObject; Node: TTreeNode);
    procedure BtnSinalTVClick(Sender: TObject);
    procedure btnGrupoFilasClick(Sender: TObject);
    procedure btnGrupoCategoriasClick(Sender: TObject);
    procedure btnConfigTVClick(Sender: TObject);
  private
    FPingTitle  : string;
    FIdunidade  : Integer;
    FSelectedIP : string;

    /// <summary>
    /// Grava qtde tentativas de acessar configuração PA\MULTIPA com senha inválida
    /// </summary>
    FTentativasAcessoMenuProtegido: Integer;
    FDataUltimaTentativasAcessoMenuProtegido: TDateTime;

    FRecebeuConfiguracoesEmail, FRecebeuConfiguracoesSMS,
      FRecebeuConfirmacaoDeComando, FRecebeuNegativaDeComando: Boolean;

    procedure ExecutarScriptsBDUnidades;
    procedure AtualizarGrupos;
  public
    function ConectarBancoDadosUnidade: Boolean;
    function ConectarSocketUnidade(const APort: Integer): Boolean;
    function EnviarComando(const Protocolo: string): Boolean;
  end;

  TUnidade = record
    ID: Integer;
    Nome: string;
    BaseDados: string;
    IP: string;
    Porta: Integer;
    PortaTGS: Integer;
    Host: string;
    Banco: string;
    Usuario: string;
    Senha: string;
    Osauthent: string;
  end;

var
  vgParametrosModuloConfig: TParametrosModulo_Config;
  MainForm: TMainForm;
  Unidade: TUnidade;

function NGetNextGenerator(GeneratorName: string;
  ANewSqlConnection: TFDConnection = nil): Integer;

implementation

uses
  untCadastroUnidades,
  ufrmPingMonitor_DX,
  cfgGenerica,
  ufrmCadTotens,
  uFrmConfiguracoesSicsMultiPA,
  uFrmConfiguracoesSicsOnLine,
  uFrmConfiguracoesSicsPA,
  uFrmConfiguracoesSicsTGS,
  uFrmConfiguracoesSicsCallCenter,
  untCaminhosUpdate,
  uScriptUnidades,
  UConexaoBD,
  uCadastroGrupos,
  uCadastroDevices,
  ASPGenerator,

  uFrmConfiguracoesSicsTV;

const
  VERSAO_PROTOCOLO = 3;
  STX = Chr(2);
  ETX = Chr(3);
  CR = Chr(13);
  LF = Chr(10);
  ACK = Chr(6);
  NAK = Chr(21);

{$R *.dfm}

function CreateProcessWithLogonW (lpUsername,
                                  lpDomain,
                                  lpPassword:PWideChar;
                                  dwLogonFlags:dword;
                                  lpApplicationName: PWideChar;
                                  lpCommandLine: PWideChar;
                                  dwCreationFlags: DWORD;
                                  lpEnvironment: Pointer;
                                  lpCurrentDirectory: PWideChar;
                                  lpStartupInfo: PStartupInfoW;
                                  lpProcessInformation: PProcessInformation
                                 ): BOOL; stdcall; external 'advapi32.dll';

function NGetNextGenerator(GeneratorName: string;
  ANewSqlConnection: TFDConnection = nil): Integer;
{
var
  LSqlQuery: TFDQuery;
begin
  LSqlQuery := TFDQuery.Create(nil);
  with LSqlQuery do
    try
      if ANewSqlConnection <> nil then
        Connection := ANewSqlConnection
      else
        Connection := dmSicsMain.connOnLine;
      Sql.Text := Format(cSELECT_NEXT_GEN, [GeneratorName, 1]);
      Open;
      try
        Result := FieldByName('ID').AsInteger;
      finally
        Close;
      end;
    finally
      FreeAndNil(LSqlQuery);
    end;
end;
}
begin
  if ANewSqlConnection = nil then
  begin
    ANewSqlConnection := dmSicsMain.connOnLine;
  end;

  Result := TGenerator.NGetNextGenerator(GeneratorName, ANewSqlConnection);
end;

procedure TMainForm.ExecutarScriptsBDUnidades;
var
  i, iVersao: Integer;
begin
  with qryAuxScriptBd do
  begin
    if not TConexaoBD.TabelaExiste('CONFIGURACOES_GERAIS',connUnidades) then
      connUnidades.ExecSQL('CREATE TABLE CONFIGURACOES_GERAIS (ID VARCHAR(50) NOT NULL PRIMARY KEY, VALOR VARCHAR(50))');

    Close;
    Sql.Text := 'SELECT VALOR FROM CONFIGURACOES_GERAIS WHERE ID = ' +
      QuotedStr(CONFIG_KEY_BD_VERSION);
    Open;
    try
      if IsEmpty then
      begin
        connUnidades.ExecSQL('INSERT INTO CONFIGURACOES_GERAIS (ID, VALOR) VALUES (' +
          QuotedStr(CONFIG_KEY_BD_VERSION) + ', ' + QuotedStr('0') + ')');
        iVersao := 0;
      end
      else
      begin
        if FieldByName('VALOR').AsString = '' then
          iVersao := 0
        else
          iVersao := FieldByName('VALOR').AsInteger;
      end;
    finally
      Close;
    end;

    for i := Low(ScriptsBdUnidades) to High(ScriptsBdUnidades) do
    begin
      if i <= iVersao then
        Continue;

      connUnidades.StartTransaction;
      try
        connUnidades.ExecSQL(ScriptsBdUnidades[i]);
        connUnidades.ExecSQL('UPDATE CONFIGURACOES_GERAIS SET VALOR = ' +
                              QuotedStr(IntToStr(i)) + ' WHERE ID = ' +
                              QuotedStr(CONFIG_KEY_BD_VERSION));
        connUnidades.Commit;
      except
        connUnidades.Rollback;
        raise;
      end;
    end;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
const
  cSettings = 'Settings';
begin
  FIdunidade  := 0;
  FTentativasAcessoMenuProtegido := 0;
  FDataUltimaTentativasAcessoMenuProtegido := 0;
  LoadPosition(Sender as TForm);

  connUnidades.Close;

  PageControl.ActivePage := tabConexoes;

  try
    connUnidades.Close;
    connUnidades.ConnectionDefName := TConexaoBD.GetConnection(vgParametrosModuloConfig.DBDir,
                                                               vgParametrosModuloConfig.DBHost,
                                                               vgParametrosModuloConfig.DBBanco,
                                                               vgParametrosModuloConfig.DBUsuario,
                                                               vgParametrosModuloConfig.DBSenha,
                                                               vgParametrosModuloConfig.DBOSAuthent);
    connUnidades.Open;
  except
    on E: Exception do
    begin
      MyLogException(E);

      if vgParametrosModuloConfig.DBDir.Trim.IsEmpty then
      begin
        MessageDlg('Erro ao abrir base de dados de Unidades!!' + #13 + 'Erro: ' + e.Message, mtInformation, [mbAbort], 0);
      end
      else
      begin
        MessageDlg('Erro ao abrir base de dados de Unidades.' + sLineBreak +
                   'Arquivo ' + vgParametrosModuloConfig.DBDir.Trim + ' não encontrado.', mtInformation, [mbAbort], 0);
      end;

      Halt;
    end;
  end;

  try
    if connUnidades.Connected then
      ExecutarScriptsBDUnidades;
  except
    on E: Exception do
    begin
      MyLogException(E);
      MessageDlg
        ('Erro ao executar scripts de atualização da base de dados de Unidades!'
        + #13 + 'Erro: ' + E.Message, TMsgDlgType.mtError,
        [TMsgDlgBtn.mbAbort], 0);
      Halt;
    end;
  end;

  AtualizarGrupos;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  SavePosition(Sender as TForm);
  inherited;
end;

procedure TMainForm.cdsUnidadesAfterScroll(DataSet: TDataSet);
begin
  Unidade.ID           := cdsUnidadesID.AsInteger;
  Unidade.Nome         := cdsUnidadesNOME.AsString;

  if cdsUnidadesTIPOBANCO.AsString <> EmptyStr then
  begin
    if cdsUnidadesTIPOBANCO.AsString = '0' then
      Unidade.BaseDados    := cdsUnidadesDBDIR.AsString
    else
      Unidade.BaseDados    := cdsUnidadesBANCO.AsString;
  end;

//  Unidade.BaseDados    := cdsUnidadesDBDIR.AsString;
  Unidade.IP           := cdsUnidadesIP.AsString;
  Unidade.Porta        := cdsUnidadesPORTA.AsInteger;
  Unidade.PortaTGS     := cdsUnidadesPORTA_TGS.AsInteger;
  Unidade.Host         := cdsUnidadesHOST.AsString;
  Unidade.Banco        := cdsUnidadesBANCO.AsString;
  Unidade.Usuario      := cdsUnidadesUSUARIO.AsString;
  Unidade.Senha        := cdsUnidadesSENHA.AsString;
  Unidade.Osauthent    := cdsUnidadesOSAUTHENT.AsString;

  vgParametrosModulo.IdUnidade := cdsUnidadesID.AsInteger;

  btnAtualizar.Enabled := True;
end;

procedure TMainForm.cdsUnidadesNewRecord(DataSet: TDataSet);
begin
  Dec(FIdunidade);
  cdsUnidadesID.AsInteger := FIdunidade;
end;

procedure TMainForm.cdsUnidadesReconcileError(DataSet: TCustomClientDataSet; E: EReconcileError;
  UpdateKind: TUpdateKind; var Action: TReconcileAction);
begin
  raise Exception.Create(E.Message);
end;

procedure TMainForm.grdUnidadesDblClick(Sender: TObject);
var
  LForm: TFrmCadastroUnidades;
  LBookmark: TBookmark;
begin
  LBookmark := MainForm.dscUnidades.DataSet.GetBookmark;

  LForm := TFrmCadastroUnidades.Create(nil);
  try
    cdsUnidades.Edit;
    LForm.ShowModal;
  finally
    LForm.Release;
    AtualizarGrupos;
    MainForm.dscUnidades.DataSet.GotoBookmark(LBookmark);
    MainForm.dscUnidades.DataSet.FreeBookmark(LBookmark);
  end;
end;

procedure TMainForm.grdUnidadesKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = vkUp) and (grdUnidades.DataSource.DataSet.RecNo = 1) and (grdUnidades.DataSource.DataSet.Bof) then
  begin
    edtFiltro.SetFocus;
    Key := 0;
  end

  else if (Key = vkReturn) and (btnAlterarUnidade.Enabled) then
  begin
    btnAlterarUnidade.Click;
    Key := 0;
  end;
end;

procedure TMainForm.cboGruposCloseUp(Sender: TObject);
begin
  Screen.Cursor := crSQLWait;

  try
    cdsUnidades.Close;
    cdsUnidades.ParamByName('IDGRUPO').AsInteger := TGrupo(cboGrupos.Items.Objects[cboGrupos.ItemIndex]).ID;
    cdsUnidades.Open;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TMainForm.btnAtualizarClick(Sender: TObject);
begin
  tvwConexoes.Items.Clear;
  btnAtualizar.Enabled := False;

  if ConectarSocketUnidade(Unidade.PortaTGS) then
    EnviarComando('0000' + Chr($B3))
  else
    btnAtualizar.Enabled := True;
end;

procedure TMainForm.ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
var
  S: string;
  i: Integer;
  G: Integer; // group
  C: Integer; // connected
  A: string; // address
  N: TTreeNode;
  D: TTreeNode; // device
  Nodes: array of TTreeNode;
  Comando: Char;
  ProtData: string;
  vVersaoProtocolo: Integer;
  vTipoConfiguracao: Char;
  IniFile: TIniFile;
  MyStringList: TStringList;
  vSecaoIni: string;
begin
  S := AspAnsiStringToString(Socket.ReceiveText);

  if ((Length(S) > 6) and (S[1] = STX) and (S[Length(S)] = ETX)) then
  begin
    if ((Length(S) = 7) and (S[6] = ACK)) then
    begin
      FRecebeuConfirmacaoDeComando := True;
      Exit;
    end
    else if ((Length(S) = 7) and (S[6] = NAK)) then
    begin
      FRecebeuNegativaDeComando := True;
      Exit;
    end
    else
    begin
      vVersaoProtocolo := StrToIntDef('$' + ExtractStr(S, 2, 4), 0);
      Comando := Chr(TEncoding.Default.GetBytes(S[6])[0]);
      ProtData := Copy(S, 7, Length(S) - 7);
    end;
  end
  else // Verificar se deve gerar exceção
    Exit;

  if (vVersaoProtocolo <> VERSAO_PROTOCOLO) then
    raise Exception.Create
      (Format('Protocolo com versão distinta. Versão servidor: %d e local %d.',
      [vVersaoProtocolo, VERSAO_PROTOCOLO]));

  case Comando of
    Chr($A1):
      begin
        vTipoConfiguracao := ProtData[1];
        IniFile := TIniFile.Create(GetAppIniFileName);
        try
          MyStringList := TStringList.Create;
          try
            MyStringList.Text := Copy(ProtData, 2);

            if MyStringList.Count > 0 then
            begin
              vSecaoIni := MyStringList.Strings[0];
              IniFile.EraseSection(vSecaoIni);
              for i := 1 to MyStringList.Count - 1 do
                IniFile.WriteString(vSecaoIni, MyStringList.Names[i],
                  MyStringList.ValueFromIndex[i]);

              case vTipoConfiguracao of
                'E':
                  FRecebeuConfiguracoesEmail := True;
                'S':
                  FRecebeuConfiguracoesSMS := True;
              end;
            end;
          finally
            MyStringList.Free;
          end;
        finally
          IniFile.Free;
        end;
      end;
    Chr($B8):
      begin
        // mmoLog.Lines.Text := ProtData;
      end;
    Chr($B7):
      begin
        tvwConexoes.Items.Clear;

        Finalize(Nodes);
        SetLength(Nodes, 5);

        Nodes[0] := tvwConexoes.Items.AddChild(nil, 'PAs e MultiPAs');
        Nodes[1] := tvwConexoes.Items.AddChild(nil, 'OnLines e TGSs');
        Nodes[2] := tvwConexoes.Items.AddChild(nil, 'Painéis');
        Nodes[3] := tvwConexoes.Items.AddChild(nil, 'Totens');
        Nodes[4] := tvwConexoes.Items.AddChild(nil, 'Teclados');

        for i := Low(Nodes) to High(Nodes) do
        begin
          Nodes[i].ImageIndex := 2;
          Nodes[i].SelectedIndex := 2;
        end;

        with TStringList.Create do
        begin
          Text := StringReplace(ProtData, #9, #13, [rfReplaceAll]);
          for i := 0 to Pred(Count) do
          begin
            G := StrToInt(Strings[i][1]) - 1;
            C := StrToInt(Strings[i][2]);
            A := Copy(Strings[i], 3, Length(Strings[i]));

            if (G in [0,1]) then
            begin
              if A.Contains(';') then
                A := Copy(A, 1, Pos(';', A) - 1);
            end
            else
            if (G in [2,3,4]) then
            begin
              A := A;
            end;

            N := Nodes[G];

            D := tvwConexoes.Items.AddChild(N, A);
            D.ImageIndex := C;
            D.SelectedIndex := C;
            D.MakeVisible;
          end;
        end;

        btnAtualizar.Enabled := True;
      end;
    Chr($A8):
      begin
        tvwConexoes.Items.Clear;

        Finalize(Nodes);
        SetLength(Nodes, 1);

        Nodes[0] := tvwConexoes.Items.AddChild(Nil, ProtData);
      end;


  end;
end;

procedure TMainForm.ClientSocketError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  ErrorCode := 0;
end;

procedure TMainForm.mnuNovaUnidadeClick(Sender: TObject);
var
  LFrmCadastroUnidades: TFrmCadastroUnidades;
begin
  LFrmCadastroUnidades := TFrmCadastroUnidades.Create(nil);
  try
    cdsUnidades.Append;
    LFrmCadastroUnidades.ShowModal;

  finally
    FreeAndNil(LFrmCadastroUnidades);
    if cdsUnidades.State in dsEditModes then
      cdsUnidades.Cancel;
  end;
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = Vk_ESCAPE then
    Self.Close;
end;

procedure TMainForm.btnPingClick(Sender: TObject);
var
  IP: string;
begin
  if (TComponent(Sender).Name = btnPing.Name) or (TComponent(Sender).Name = menuPing.Name) then
    IP := FSelectedIP
  else
    if TComponent(Sender).Name = mnuPingUnidade.Name then
    begin
      IP := cdsUnidadesIP.AsString;
      FPingTitle := 'Servidor';
    end;

  CriaMonitorPing(nil, Unidade.Nome + ' - ' + FPingTitle, IP, False);
end;


procedure TMainForm.menuSCCMClick(Sender: TObject);
const
  LOGON_WITH_PROFILE = $00000001;
var
  SCCM_Path     : string;
  SCCM_User     : string;
  SCCM_Domain   : string;
  SCCM_Password : string;
  IP            : string;
  Erro          : integer;
  StartupInfoW  : TStartupInfoW;
  StartupInfo   : TStartupInfo;
  pif           : TProcessInformation;
  hUserToken    : THandle;
begin
  with TIniFile.Create(GetAppIniFileName) do
  try
    SCCM_Path     := ReadString('SCCM', 'ExePath' , '');
    SCCM_User     := ReadString('SCCM', 'User'    , '');
    SCCM_Domain   := ReadString('SCCM', 'Domain'  , '');
    SCCM_Password := ReadString('SCCM', 'Password', '');

    WriteString('SCCM', 'ExePath' , SCCM_Path    );
    WriteString('SCCM', 'User'    , SCCM_User    );
    WriteString('SCCM', 'Domain'  , SCCM_Domain  );
    WriteString('SCCM', 'Password', SCCM_Password);
  finally
    Free;
  end;

  IP := FSelectedIP;

  if IP = '' then
    AppMessageBox('IP inválido.', 'Erro', MB_ICONSTOP)
  else if SCCM_Path = '' then
    AppMessageBox('Configure o caminho do SCCM no INI do SicsConfig.', 'Erro', MB_ICONSTOP)
  else
  begin
    SCCM_Path := SCCM_Path + ' "' + IP + '"';
    if (SCCM_User <> '') then
    begin
      FillChar(StartupInfoW, sizeof(StartupInfoW), 0);
      FillChar(pif, sizeof(pif), 0);

      if not LogonUser(PChar(SCCM_User), PChar(SCCM_Domain), PChar(SCCM_password), LOGON32_LOGON_INTERACTIVE, LOGON32_PROVIDER_DEFAULT, hUserToken) then
      begin
        AppMessageBox('Usuário, domínio ou senha inválido.', 'Erro', MB_ICONSTOP);
        Exit;
      end;

      CreateProcessWithLogonW (PWideChar(SCCM_user), PChar(SCCM_Domain), PWideChar(SCCM_password), LOGON_WITH_PROFILE, nil,
                               PWideChar(SCCM_Path), CREATE_UNICODE_ENVIRONMENT, nil, nil, @StartupInfoW, @pif);

      Erro := GetLastError;
      If Erro <> 0 then
        AppMessageBox('Rodar SCCM falhou com código de erro ' + inttostr(Erro) + '.', 'Erro', MB_ICONSTOP);
    end
    else
    begin
      ZeroMemory(@StartupInfo, SizeOf(StartupInfo));
      StartupInfo.cb := SizeOf(StartupInfo);
      StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
      StartupInfo.wShowWindow := SW_SHOWNORMAL;

      UniqueString(SCCM_Path);
      SetLastError(0);
      if not CreateProcess(nil, PChar(SCCM_Path), nil, nil, True, NORMAL_PRIORITY_CLASS or CREATE_NEW_PROCESS_GROUP, nil, nil, StartupInfo, pif) then
      begin
        Erro := GetLastError;
        AppMessageBox('Rodar SCCM falhou com código de erro ' + inttostr(Erro) + '.', 'Erro', MB_ICONSTOP);
      end;
    end;
  end;
end;

procedure TMainForm.menuTelnetClick(Sender: TObject);
var
  Telnet_Path   : string;
  IP            : string;
  Porta         : integer;
  Erro          : integer;
  StartupInfo   : TStartupInfo;
  pif           : TProcessInformation;
begin
  with TIniFile.Create(GetAppIniFileName) do
  try
    Telnet_Path := ReadString('TELNET', 'ExePath' , 'c:\windows\system32\telnet.exe');

    WriteString('TELNET', 'ExePath' , Telnet_Path);
  finally
    Free;
  end;

  IP := FSelectedIP;

  if IP = '' then
    AppMessageBox('IP inválido.', 'Erro', MB_ICONSTOP)
  else
  begin
    if Sender = menuPorta9999 then
      Porta := 9999
    else if Sender = menuPorta3001 then
      Porta := 3001
    else if Sender = menuPorta5000 then
      Porta := 5000
    else if (Sender = menuOutraPorta) or (Sender = btnTelnet) then
      Porta := StrToIntDef(InputBox('Porta', 'Digite a porta desejada para o telnet:', ''), -1);

    if Porta > 0 then
    begin
      Telnet_Path := '"' + Telnet_Path + '" ' + IP + ' ' + inttostr(Porta);

      ZeroMemory(@StartupInfo, SizeOf(StartupInfo));
      StartupInfo.cb := SizeOf(StartupInfo);

      SetLastError(0);
      if CreateProcess(nil, PChar(WideString(Telnet_Path)), nil, nil, false, 0, nil, nil, StartupInfo, pif) then
      begin
        CloseHandle(pif.hProcess);
        CloseHandle(pif.hThread);
      end
      else
      begin
        Erro := GetLastError;
        AppMessageBox('Telnet falhou com código de erro ' + inttostr(Erro) + '.', 'Erro', MB_ICONSTOP);
      end;
    end;
  end;
end;

procedure TMainForm.mnuExcluirUnidadeClick(Sender: TObject);
begin
  cdsUnidades.Delete;
  cdsUnidades.ApplyUpdates(0);
end;

procedure TMainForm.mnuUnidadesPopup(Sender: TObject);
begin
  mnuExcluirUnidade.Visible := not cdsUnidades.IsEmpty;
  mnuPingUnidade.Visible := (not cdsUnidades.IsEmpty) and (Unidade.IP.Trim <> EmptyStr);
end;

procedure TMainForm.btnGrupoPAsClick(Sender: TObject);
begin
  if ConectarBancoDadosUnidade and TfrmSicsConfiguraTabela.ExibeForm
    (ctGruposDePAs, Unidade.ID) and ConectarSocketUnidade(Unidade.Porta) then
    EnviarComando('FFFF' + Chr($7A) + 'P');
end;

function TMainForm.ConectarBancoDadosUnidade: Boolean;

  procedure CadastraUnidades;
  var
    LOldRecno: Integer;
  begin
    cdsUnidades.DisableControls;
    try
      LOldRecno := cdsUnidades.recno;
      try
        cdsUnidades.First;
        while not cdsUnidades.Eof do
        begin
          dmSicsMain.InsereUnidade(cdsUnidades.recno - 1,
            cdsUnidadesNOME.AsString, cdsUnidadesDBDIR.AsString, '',
            cdsUnidadesIP.AsString, cdsUnidadesPORTA.AsInteger);
          cdsUnidades.Next;
        end;
      finally
        if (LOldRecno > -1) then
          cdsUnidades.recno := LOldRecno;
      end;
    finally
      cdsUnidades.EnableControls;
    end;
  end;

begin
  cdsUnidadesAfterScroll(cdsUnidades);
  try
    if not(Assigned(dmSicsMain) and (dmSicsMain.connOnLine.Params.Values
      ['Database'] = Unidade.BaseDados) and dmSicsMain.connOnLine.Connected)
    then
    begin
      FreeAndNil(dmSicsMain);
      Application.CreateForm(TdmSicsMain, dmSicsMain);
      CadastraUnidades;

      dmSicsMain.connOnLine.Close;
      dmSicsMain.connOnLine.ConnectionDefName := TConexaoBD.GetConnection(cdsUnidadesDBDIR.AsString,
                                                                          cdsUnidadesHOST.AsString,
                                                                          cdsUnidadesBANCO.AsString,
                                                                          cdsUnidadesUSUARIO.AsString,
                                                                          cdsUnidadesSENHA.AsString,
                                                                          cdsUnidadesOSAUTHENT.AsString = 'S',
                                                                          cdsUnidadesID.AsInteger);

      dmSicsMain.connOnLine.Open;

      dmSicsMain.CarregaTabelasDM;
    end;
    dmSicsMain.CheckVersionBD;
    Result := True;
  except
    raise;
  end;
end;

procedure TMainForm.btnGrupoAtendentesClick(Sender: TObject);
begin
  if ConectarBancoDadosUnidade and TfrmSicsConfiguraTabela.ExibeForm
    (ctGruposDeAtendentes, Unidade.ID) and ConectarSocketUnidade(Unidade.Porta)
  then
    EnviarComando('FFFF' + Chr($7A) + 'A');
end;

procedure TMainForm.btnGrupoCategoriasClick(Sender: TObject);
var
 LUnidade:integer;
begin
  LUnidade:= 0;
  if ConectarBancoDadosUnidade and TfrmSicsConfiguraTabela.ExibeForm
    (ctCategoriaFilas, Unidade.ID) and ConectarSocketUnidade(Unidade.Porta)
  then
    EnviarComando('FFFF' + Chr($7A) + 'B');

end;

procedure TMainForm.btnGrupoFilasClick(Sender: TObject);
begin
  if ConectarBancoDadosUnidade and TfrmSicsConfiguraTabela.ExibeForm
    (ctGrupoFilas, Unidade.ID) and ConectarSocketUnidade(Unidade.Porta)
  then
    EnviarComando('FFFF' + Chr($7A) + 'G');

end;

procedure TMainForm.btnGrupoTAGsClick(Sender: TObject);
begin
  if ConectarBancoDadosUnidade and TfrmSicsConfiguraTabela.ExibeForm
    (ctGruposTags, Unidade.ID) and ConectarSocketUnidade(Unidade.Porta) then
    EnviarComando('FFFF' + Chr($7A) + 'T');
end;

procedure TMainForm.btnGrupoPPsClick(Sender: TObject);
begin
  if ConectarBancoDadosUnidade and TfrmSicsConfiguraTabela.ExibeForm
    (ctGruposDePPs, Unidade.ID) and ConectarSocketUnidade(Unidade.Porta) then
    EnviarComando('FFFF' + Chr($7A) + 'S');
end;

procedure TMainForm.btnGrupoMotivosPausaClick(Sender: TObject);
begin
  if ConectarBancoDadosUnidade and TfrmSicsConfiguraTabela.ExibeForm
    (ctGruposDeMotivosPausa, Unidade.ID) and ConectarSocketUnidade(Unidade.Porta)
  then
    EnviarComando('FFFF' + Chr($7A) + 'M');
end;

procedure TMainForm.btnPaineisClick(Sender: TObject);
begin
  if ConectarBancoDadosUnidade then
    TfrmSicsConfiguraTabela.ExibeForm(ctPaineis, Unidade.ID);
end;

procedure TMainForm.btnFilasClick(Sender: TObject);
begin
  if ConectarBancoDadosUnidade and TfrmSicsConfiguraTabela.ExibeForm(ctFilas,
    Unidade.ID) and ConectarSocketUnidade(Unidade.Porta) then
    EnviarComando('FFFF' + Chr($7A) + 'P');
end;

procedure TMainForm.btnPAsClick(Sender: TObject);
begin
  if ConectarBancoDadosUnidade and TfrmSicsConfiguraTabela.ExibeForm(ctPAs,
    Unidade.ID) and ConectarSocketUnidade(Unidade.Porta) then
    EnviarComando('FFFF' + Chr($7A) + 'P');
end;

procedure TMainForm.btnAtendentesClick(Sender: TObject);
begin
  if ConectarBancoDadosUnidade and TfrmSicsConfiguraTabela.ExibeForm
    (ctAtendentes, Unidade.ID) and ConectarSocketUnidade(Unidade.Porta) then
    EnviarComando('FFFF' + Chr($7A) + 'A');
end;

procedure TMainForm.btnTAGsClick(Sender: TObject);
begin
  if ConectarBancoDadosUnidade and TfrmSicsConfiguraTabela.ExibeForm(ctTags,
    Unidade.ID) and ConectarSocketUnidade(Unidade.Porta) then
    EnviarComando('FFFF' + Chr($7A) + 'T');
end;

procedure TMainForm.btnPPsClick(Sender: TObject);
begin
  if ConectarBancoDadosUnidade and TfrmSicsConfiguraTabela.ExibeForm(ctPPs,
    Unidade.ID) and ConectarSocketUnidade(Unidade.Porta) then
    EnviarComando('FFFF' + Chr($7A) + 'S');
end;

procedure TMainForm.BtnSinalTVClick(Sender: TObject);
begin
  tvwConexoes.Items.Clear;
  BtnSinalTV.Enabled := False;

  if ConectarSocketUnidade(Unidade.Porta) then
    EnviarComando('0000' + Chr($A7))
  else
    BtnSinalTV.Enabled := True;
end;

procedure TMainForm.btnMotivosPausaClick(Sender: TObject);
begin
  if ConectarBancoDadosUnidade and TfrmSicsConfiguraTabela.ExibeForm
    (ctMotivosPausa, Unidade.ID) and ConectarSocketUnidade(Unidade.Porta) then
    EnviarComando('FFFF' + Chr($7A) + 'M');
end;

procedure TMainForm.btnTotensClick(Sender: TObject);
begin
  if ConectarBancoDadosUnidade and TfrmSicsCadTotens.ExibeForm and
    ConectarSocketUnidade(Unidade.Porta) then
    EnviarComando('FFFF' + Chr($7A) + 'E');
end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  TfrmCadastroGrupos.ExibeForm;

  AtualizarGrupos;
end;

procedure TMainForm.btnCelularesClick(Sender: TObject);
begin
  if ConectarBancoDadosUnidade and TfrmSicsConfiguraTabela.ExibeForm
    (ctCelulares, Unidade.ID) and ConectarSocketUnidade(Unidade.Porta) then
    EnviarComando('FFFF' + Chr($7A) + 'W');
end;

procedure TMainForm.btnClientesClick(Sender: TObject);
begin
  if ConectarBancoDadosUnidade and TfrmSicsConfiguraTabela.ExibeForm(ctClientes,
    Unidade.ID) and ConectarSocketUnidade(Unidade.Porta) then
    EnviarComando('FFFF' + Chr($7A) + 'L');
end;

procedure TMainForm.btnConfigPAClick(Sender: TObject);
begin
  if ConectarBancoDadosUnidade then
    with TFrmConfiguracoesSicsPA.Create(Application) do
      try
        ShowModal;
      finally
        ConectarSocketUnidade(Unidade.Porta);
        EnviarComando('FFFF' + Chr($7A) + 'H');
        Free;
      end;
end;

procedure TMainForm.btnConfigCallCenterClick(Sender: TObject);
begin
  if ConectarBancoDadosUnidade then
    with TFrmConfiguracoesSicsCallCenter.Create(Application) do
      try
        ShowModal;
      finally
        ConectarSocketUnidade(Unidade.Porta);
        EnviarComando('FFFF' + Chr($7A) + 'H');
        Free;
      end;
end;

procedure TMainForm.btnConfigGeraisConfigurarEmailClick(Sender: TObject);
var
  Timeout: TDateTime;
  vTipoConfiguracao: Char;
  IniFile: TIniFile;
  MyStringList: TStringList;
begin
  FRecebeuConfiguracoesEmail := False;

  if ConectarSocketUnidade(Unidade.PortaTGS) then
    EnviarComando('FFFF' + Chr($A0) + 'E')
  else
    Application.MessageBox('Erro ao conectar ao servidor.', 'Erro',
      MB_ICONSTOP);

  Timeout := now + EncodeTime(0, 0, 15, 0);
  while ((not FRecebeuConfiguracoesEmail) and (now < Timeout)) do
    Application.ProcessMessages;

  if FRecebeuConfiguracoesEmail then
  begin
    IniFile := TIniFile.Create(GetAppIniFileName);
    try
      if AspConfiguraEmail then
      begin
        vTipoConfiguracao := 'E';
        MyStringList := TStringList.Create;
        try
          IniFile.ReadSectionValues('SMTP', MyStringList);

          FRecebeuConfirmacaoDeComando := False;
          EnviarComando('FFFF' + Chr($A1) + vTipoConfiguracao + 'SMTP' + CR + LF
            + MyStringList.Text);

          Timeout := now + EncodeTime(0, 0, 15, 0);
          while ((not FRecebeuConfirmacaoDeComando) and (now < Timeout)) do
            Application.ProcessMessages;

          if FRecebeuConfirmacaoDeComando then
            Application.MessageBox('Configuração ok.', 'Informação',
              MB_ICONINFORMATION)
          else
            Application.MessageBox('Erro ao configurar parâmetros.', 'Erro',
              MB_ICONSTOP);
        finally
          MyStringList.Free;
        end;
      end;

      IniFile.EraseSection('SMTP');
    finally
      IniFile.Free;
    end;
  end
  else
    Application.MessageBox('Timeout ou receber valores do servidor.', 'Erro',
      MB_ICONSTOP);
end;

procedure TMainForm.btnConfigGeraisSMSClick(Sender: TObject);
var
  Timeout: TDateTime;
  vTipoConfiguracao: Char;
  IniFile: TIniFile;
  MyStringList: TStringList;
begin
  FRecebeuConfiguracoesSMS := False;

  if ConectarSocketUnidade(Unidade.PortaTGS) then
    EnviarComando('FFFF' + Chr($A0) + 'S')
  else
    Application.MessageBox('Erro ao conectar ao servidor.', 'Erro',
      MB_ICONSTOP);

  Timeout := now + EncodeTime(0, 0, 15, 0);
  while ((not FRecebeuConfiguracoesSMS) and (now < Timeout)) do
    Application.ProcessMessages;

  if FRecebeuConfiguracoesSMS then
  begin
    IniFile := TIniFile.Create(GetAppIniFileName);
    try
      if AspConfiguraSms then
      begin
        vTipoConfiguracao := 'S';
        MyStringList := TStringList.Create;
        try
          IniFile.ReadSectionValues('SMS', MyStringList);

          FRecebeuConfirmacaoDeComando := False;
          EnviarComando('FFFF' + Chr($A1) + vTipoConfiguracao + 'SMS' + CR + LF
            + MyStringList.Text);

          Timeout := now + EncodeTime(0, 0, 15, 0);
          while ((not FRecebeuConfirmacaoDeComando) and (now < Timeout)) do
            Application.ProcessMessages;

          if FRecebeuConfirmacaoDeComando then
            Application.MessageBox('Configuração ok.', 'Informação',
              MB_ICONINFORMATION)
          else
            Application.MessageBox('Erro ao configurar parâmetros.', 'Erro',
              MB_ICONSTOP);
        finally
          MyStringList.Free;
        end;
      end;

      IniFile.EraseSection('SMS');
    finally
      IniFile.Free;
    end;
  end
  else
    Application.MessageBox('Timeout ou receber valores do servidor.', 'Erro',
      MB_ICONSTOP);
end;

procedure TMainForm.btnConfigGeraisTestarEmailClick(Sender: TObject);
var
  Timeout: TDateTime;
  S: string;
begin
  S := 'suporte_sw@aspect.com.br';

  if InputQuery('Teste de envio de e-mail', 'Digite e-mail do destinatário:', S)
  then
  begin
    FRecebeuConfirmacaoDeComando := False;
    FRecebeuNegativaDeComando := False;

    EnviarComando('FFFF' + Chr($A2) + 'E' + S);

    Timeout := now + EncodeTime(0, 0, 15, 0);
    while ((not FRecebeuConfirmacaoDeComando) and
      (not FRecebeuNegativaDeComando) and (now < Timeout)) do
      Application.ProcessMessages;

    if FRecebeuConfirmacaoDeComando then
      AppMessageBox('Um e-mail foi enviado para o endereço "' + S +
        '". Por favor cheque esta caixa postal dentro de instantes para confirmar o seu recebimento.',
        'Informação', MB_ICONINFORMATION)
    else
      AppMessageBox
        ('Falha ao enviar e-mail. Por favor cheque as configurações de SMTP. Para maiores informações, consulte o arquivo de LOG do Servidor SICS.',
        'Erro', MB_ICONSTOP);
  end;
end;

procedure TMainForm.btnConfigGeraisTestarSMSClick(Sender: TObject);
var
  Timeout: TDateTime;
  S: string;
begin
  S := '55xx99999999';
  if InputQuery('Teste de envio de SMS', 'Digite número do destinatário:', S)
  then
  begin
    FRecebeuConfirmacaoDeComando := False;
    FRecebeuNegativaDeComando := False;

    EnviarComando('FFFF' + Chr($A2) + 'S' + S);

    Timeout := now + EncodeTime(0, 0, 30, 0);
    while ((not FRecebeuConfirmacaoDeComando) and
      (not FRecebeuNegativaDeComando) and (now < Timeout)) do
      Application.ProcessMessages;

    if FRecebeuConfirmacaoDeComando then
      AppMessageBox('Um SMS foi enviado para o número "' + S +
        '". Por favor cheque esta caixa postal dentro de instantes para confirmar o seu recebimento.',
        'Informação', MB_ICONINFORMATION)
    else
      AppMessageBox
        ('Falha ao enviar SMS. Por favor cheque as configurações de SMS e a correta digitação do número do destinatário. Para maiores informações, consulte o arquivo de LOG do Servidor SICS.',
        'Erro', MB_ICONSTOP);
  end;
end;

procedure TMainForm.btnConfigMultiPAClick(Sender: TObject);
begin
  if ConectarBancoDadosUnidade then
    with TFrmConfiguracoesSicsMultiPA.Create(Application) do
      try
        ShowModal;
      finally
        ConectarSocketUnidade(Unidade.Porta);
        EnviarComando('FFFF' + Chr($7A) + 'H');
        Free;
      end;
end;

procedure TMainForm.btnConfigOnlineClick(Sender: TObject);
begin
  if ConectarBancoDadosUnidade then
    with TFrmConfiguracoesSicsOnline.Create(Application) do
      try
        ShowModal;
      finally
        ConectarSocketUnidade(Unidade.Porta);
        EnviarComando('FFFF' + Chr($7A) + 'H');
        Free;
      end;
end;

procedure TMainForm.btnConfigTGSClick(Sender: TObject);
begin
  if ConectarBancoDadosUnidade then
    with TFrmConfiguracoesSicsTGS.Create(Application) do
      try
        ShowModal;
      finally
        ConectarSocketUnidade(Unidade.Porta);
        EnviarComando('FFFF' + Chr($7A) + 'H');
        Free;
      end;
end;

procedure TMainForm.btnConfigTVClick(Sender: TObject);
begin
   if ConectarBancoDadosUnidade then
    with TFrmConfiguracoesSicsTV.Create(Application) do
      try
        ShowModal;
      finally
        ConectarSocketUnidade(Unidade.Porta);
        EnviarComando('FFFF' + Chr($7A) + 'H');
        Free;
      end;
end;

procedure TMainForm.btnDevicesUnidadeClick(Sender: TObject);
begin
  TfrmCadastroDevices.ExibeForm;
end;

procedure TMainForm.btnEmailsClick(Sender: TObject);
begin
  if ConectarBancoDadosUnidade and TfrmSicsConfiguraTabela.ExibeForm(ctEmails,
    Unidade.ID) and ConectarSocketUnidade(Unidade.Porta) then
    EnviarComando('FFFF' + Chr($7A) + 'O');
end;

function TMainForm.ConectarSocketUnidade(const APort: Integer): Boolean;
var
  Timeout: TDateTime;
begin
  cdsUnidadesAfterScroll(cdsUnidades);
  Result := False;
  try
    ClientSocket.Close;
    ClientSocket.Host := Unidade.IP; //Não é necessário resolver Host manualmente aqui - IdStack.GStack.ResolveHost(Unidade.IP);
    ClientSocket.Port := APort;
    ClientSocket.Open;

    Timeout := now + EncodeTime(0, 0, 10, 0);
    while not ClientSocket.Active and (now < Timeout) do
    begin
      Application.ProcessMessages;
      Sleep(1000);
    end;

    if not ClientSocket.Active then
    begin
      btnAtualizar.Enabled := True;
      ShowMessage('O servidor não está respondendo, verifique as configurações.'
        + #13 + 'Verifique se a porta do Sics Config está em conflito com a porta do Sics Servidor');
    end
    else
    begin
      Result := True;
    end;
  except
    raise;
  end;
end;

procedure TMainForm.dscUnidadesDataChange(Sender: TObject; Field: TField);
begin
  btnNovaUnidade.Enabled    := cdsUnidades.Active and (not (cdsUnidades.State in dsEditModes));
  btnAlterarUnidade.Enabled := cdsUnidades.Active and (not cdsUnidades.IsEmpty) and (not (cdsUnidades.State in dsEditModes));
  btnExcluirUnidade.Enabled := cdsUnidades.Active and (not cdsUnidades.IsEmpty) and (not (cdsUnidades.State in dsEditModes));
  btnDevicesUnidade.Enabled := cdsUnidades.Active and (not cdsUnidades.IsEmpty) and (not (cdsUnidades.State in dsEditModes));
end;

procedure TMainForm.dspUnidadesBeforeUpdateRecord(Sender: TObject;
  SourceDS: TDataSet; DeltaDS: TCustomClientDataSet; UpdateKind: TUpdateKind;
  var Applied: Boolean);
begin
	if UpdateKind = ukInsert then
  begin
    if (SourceDs = qryUnidades)then
    begin
      if DeltaDs.FieldByName('ID').AsInteger < 0 then
        DeltaDs.FieldByName('ID').NewValue := NGetNextGenerator('GEN_UNIDADES_ID', connUnidades);
    end;
  end;
end;

procedure TMainForm.edtFiltroKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
const
  NOT_A_NUMBER = -99999;
var
  LId: Integer;
  LFiltro, LCriterio: String;
begin
  if (Key = vkDown) or (Key = vkReturn) then
  begin
    grdUnidades.SetFocus;
    exit;
  end;

  LCriterio := Trim(edtFiltro.Text);

  LId := StrToIntDef(LCriterio, NOT_A_NUMBER);

  LFiltro := '(NOME LIKE ' + QuotedStr('%' + LCriterio + '%') + ')';
  if LId <> NOT_A_NUMBER then
    LFiltro := LFiltro + ' OR (ID = ' + LCriterio + ')';

  cdsUnidades.Filter := LFiltro;
  cdsUnidades.Filtered := not Trim(edtFiltro.Text).IsEmpty;
end;

function TMainForm.EnviarComando(const Protocolo: string): Boolean;
begin
  ClientSocket.Socket.SendText
    (AspStringToAnsiString(STX + TAspEncode.AspIntToHex(VERSAO_PROTOCOLO,
    4) + Protocolo + ETX));
  Result := True;
end;

procedure TMainForm.AtualizarGrupos;
var
  lGrupo: TGrupo;
begin
  Screen.Cursor := crSQLWait;

  try
    cboGrupos.Items.Clear;

    lGrupo      := TGrupo.Create;
    lGrupo.ID   := 0;
    lGrupo.Nome := 'Todos';
    cboGrupos.AddItem(lGrupo.Nome, lGrupo);

    cdsGrupo.Close;
    cdsGrupo.Open;

    cdsGrupo.First;

    while not cdsGrupo.Eof do
    begin
      lGrupo      := TGrupo.Create;
      lGrupo.ID   := cdsGrupoIDGRUPO.AsInteger;
      lGrupo.Nome := cdsGrupoNOME.AsString;
      cboGrupos.AddItem(lGrupo.Nome, lGrupo);

      cdsGrupo.Next;
    end;

    cboGrupos.ItemIndex := 0;
    cboGruposCloseUp(nil);
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TMainForm.btnCaminhosUpdateClick(Sender: TObject);
begin
  if ConectarBancoDadosUnidade then
    with TfrmCaminhosUpdate.Create(Application) do
      try
        if ShowModal = mrOk then
        begin
          if ConectarSocketUnidade(Unidade.Porta) then
            EnviarComando('FFFF' + Chr($7A) + 'C');
        end;
      finally
        Free;
      end;
end;

procedure TMainForm.tvwConexoesChange(Sender: TObject; Node: TTreeNode);
begin
  if Assigned(tvwConexoes.Selected) and Assigned(tvwConexoes.Selected.Parent) then
  begin
    if tvwConexoes.Selected.Parent.Text = 'PAs e MultiPAs' then
      FPingTitle := 'PA / MultiPA'
    else if tvwConexoes.Selected.Parent.Text = 'OnLines e TGSs' then
      FPingTitle := 'On-Line / TGS'
    else if tvwConexoes.Selected.Parent.Text = 'Painéis' then
      FPingTitle := 'Painel'
    else if tvwConexoes.Selected.Parent.Text = 'Totens' then
      FPingTitle := 'Tótem'
    else if tvwConexoes.Selected.Parent.Text = 'Teclados' then
      FPingTitle := 'Teclado';

    if Pos(';', tvwConexoes.Selected.Text) > 0 then
      FSelectedIP := Copy(tvwConexoes.Selected.Text, 1, Pos(';', tvwConexoes.Selected.Text) - 1)
    else if Pos(' ', tvwConexoes.Selected.Text) > 0 then
      FSelectedIP := Copy(tvwConexoes.Selected.Text, 1, Pos(' ', tvwConexoes.Selected.Text) - 1)
    else
      FSelectedIP := tvwConexoes.Selected.Text;
  end
  else
  begin
    FPingTitle  := '';
    FSelectedIP := '';
  end;

  btnPing.Enabled    := FSelectedIP <> '';
  btnSCCM.Enabled    := FSelectedIP <> '';
  btnTelnet.Enabled  := FSelectedIP <> '';

  menuPing.Enabled   := FSelectedIP <> '';
  menuSCCM.Enabled   := FSelectedIP <> '';
  menuTelnet.Enabled := FSelectedIP <> '';
end;


procedure TMainForm.tvwConexoesMouseUp (Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  tvwConexoesChange(tvwConexoes, tvwConexoes.Selected);

  if Button = mbRight then
  begin
    X := X + tvwConexoes.Left + tabConexoes.Left + PageControl.Left + MainForm.Left + (MainForm.Width  - MainForm.ClientWidth );
    Y := Y + tvwConexoes.Top  + tabConexoes.Top  + PageControl.Top  + MainForm.Top  + (MainForm.Height - MainForm.ClientHeight);

    menuAcoesTreeView.Popup(X, Y);
  end;

  tvwConexoes.Select(tvwConexoes.Selected);
end;

procedure TMainForm.menuAcoesTreeViewPopup(Sender: TObject);
begin
  tvwConexoes.Select(tvwConexoes.Selected);
end;

{ TGrupo }

procedure TGrupo.SetID(const Value: Integer);
begin
  FID := Value;
end;

procedure TGrupo.SetNome(const Value: String);
begin
  FNome := Value;
end;

end.
