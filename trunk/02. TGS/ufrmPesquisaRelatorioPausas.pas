unit ufrmPesquisaRelatorioPausas;
// Renomeado unit sics_87;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
{$IFNDEF IS_MOBILE}
  Winapi.Windows,
{$ENDIF IS_MOBILE}
  FMX.Grid, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.ExtCtrls, FMX.Types, FMX.Layouts, FMX.ListView.Types, FMX.ListView,
  FMX.ListBox, FMX.Bind.DBEngExt, FMX.Bind.Grid, System.Bindings.Outputs,
  FMX.Bind.Editors, FMX.Objects, FMX.Edit, FMX.TabControl, System.UIConsts,
  System.Generics.Defaults, System.Generics.Collections, System.UITypes,
  System.Types, System.SysUtils, System.Classes, System.Variants, Data.DB,
  Datasnap.DBClient, System.Rtti, Data.Bind.EngExt, Data.Bind.Components,
  Data.Bind.Grid, Data.Bind.DBScope, MyAspFuncoesUteis, DateUtils,
  IniFiles, ufrmPesquisaRelatorioBase, Data.FMTBcd, Data.SqlTimSt,
  ufrmReportPausas, ufrmGraphicsPausas, System.ImageList, FMX.ImgList,
  FMX.TreeView, FMX.Controls.Presentation, FMX.Effects,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, 
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, 
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.DBX.Migrate, uDataSetHelper;

type
  TDuracao = record
    TipoDeDuracao: TTipoDeDuracao;
    Tempo1, Tempo2: TDateTime;
  end; { record }

  TQueryParamsPausasLogins = record
    DuracaoPausa,
    DuracaoLogin: TDuracao;
    ChoosePeriodoDoRelatorio,
    ChooseDuracaoPausa,
    ChooseDuracaoLogin,
    ChooseAtds,
    ChoosePAs,
    ChooseMPs,
    ChoosePeriodoDoDia: boolean;

    DayPeriodIniHour,
    DayPeriodIniMinute,
    DayPeriodUntilHour,
    DayPeriodUntilMinute: integer;

    IniSinceTime, IniUntilTime: TDateTime
  end;

    { TQueryParamsPP }

    TfrmPesquisaRelatorioPausas = class(TfrmPesquisaRelatorioBase)
      IniPeriodPanel2: TPanel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label2: TLabel;
    Label1: TLabel;
    Label4: TLabel;
    IniUntilYearEdit: TEdit;
    IniSinceDayEdit: TEdit;
    IniUntilMonthEdit: TEdit;
    IniUntilDayEdit: TEdit;
    IniSinceMonthEdit: TEdit;
    IniSinceYearEdit: TEdit;
    AtendsPanel: TPanel;
    AtendsLabel: TLabel;
    PAsPanel: TPanel;
    PAsLabel: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    DayPeriodUntilHourEdit: TEdit;
    DayPeriodIniMinuteEdit: TEdit;
    DayPeriodUntilMinuteEdit: TEdit;
    DayPeriodIniHourEdit: TEdit;
    DayPeriodCheckBox: TCheckBox;
    pnlMP: TPanel;
    dtsUnidades: TDataSource;
    qryAux: TFDQuery;
    IniPeriodCheckBox: TCheckBox;
    ClientDataSet1: TClientDataSet;
    IntegerField1: TIntegerField;
    StringField1: TStringField;
    DataSetField1: TDataSetField;
    DataSetField2: TDataSetField;
    DataSetField3: TDataSetField;
    BooleanField1: TBooleanField;
    StringField2: TStringField;
    StringField3: TStringField;
    StringField4: TStringField;
    pnlBotoes: TPanel;
    btnExibirTabela: TButton;
    btnExibirGraficosTMETMA: TButton;
    CancelButton: TButton;
    BitBtn1: TButton;
    imgsCheckBox: TImageList;
    AtendsTreeView: TTreeView;
    PAsTreeView: TTreeView;
    MPsLabel: TLabel;
    MPsTreeView: TTreeView;
    chkDuracaoPausa: TCheckBox;
    cdsUnidadesID: TIntegerField;
    cdsUnidadesNOME: TStringField;
    cdsUnidadesATENDENTES: TDataSetField;
    cdsUnidadesPAS: TDataSetField;
    cdsUnidadesMOTIVOS_PAUSA: TDataSetField;
    cdsUnidadesGRUPOS_ATENDENTES: TDataSetField;
    cdsUnidadesGRUPOS_PAS: TDataSetField;
    cdsUnidadesGRUPOS_MOTIVOS_PAUSA: TDataSetField;
    cdsUnidadesSELECIONADO: TBooleanField;
    cdsUnidadesATENDENTES_STR: TStringField;
    cdsUnidadesPAS_STR: TStringField;
    cdsUnidadesMOTIVOS_PAUSA_STR: TStringField;
    cdsUnidadesCONECTADA: TBooleanField;
    cdsUnidadesCARREGOU_DADOS: TBooleanField;
    rbDuracaoTodosPausa: TRadioButton;
    rbDuracaoMenorPausa: TRadioButton;
    rbDuracaoMaiorIgualPausa: TRadioButton;
    rbDuracaoEntrePausa: TRadioButton;
    edDuracaoDesdeHorasPausa: TEdit;
    edDuracaoMaiorMenorHorasPausa: TEdit;
    lblTipo1DoisPontos1: TLabel;
    edDuracaoDesdeMinutosPausa: TEdit;
    edDuracaoMaiorMenorMinutosPausa: TEdit;
    lblTipo1DoisPontos2: TLabel;
    lblTipo1DoisPontos4: TLabel;
    edDuracaoDesdeSegundosPausa: TEdit;
    edDuracaoMaiorMenorSegundosPausa: TEdit;
    lblTipo1AtePausa: TLabel;
    edDuracaoAteMinutosPausa: TEdit;
    edDuracaoAteSegundosPausa: TEdit;
    lblTipo1DoisPontos6: TLabel;
    lblTipo1DoisPontos5: TLabel;
    edDuracaoAteHorasPausa: TEdit;
    lblTipo1DoisPontos3: TLabel;
    bndUnidades: TBindSourceDB;
    rectDuracaoPausa: TRectangle;
    rectTituloDuracaoPausa: TRectangle;
    IniPeriodPanel: TRectangle;
    rectTituloPeriodoInicio: TRectangle;
    IniDayPeriodPanel: TRectangle;
    rect2: TRectangle;
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    Rectangle3: TRectangle;
    rect1: TRectangle;
    rectDuracaoLogin: TRectangle;
    edDuracaoAteHorasLogin: TEdit;
    edDuracaoAteMinutosLogin: TEdit;
    edDuracaoAteSegundosLogin: TEdit;
    edDuracaoDesdeHorasLogin: TEdit;
    edDuracaoDesdeMinutosLogin: TEdit;
    edDuracaoDesdeSegundosLogin: TEdit;
    edDuracaoMaiorMenorHorasLogin: TEdit;
    edDuracaoMaiorMenorMinutosLogin: TEdit;
    edDuracaoMaiorMenorSegundosLogin: TEdit;
    lblTipo1AteLogin: TLabel;
    Label8: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    rbDuracaoEntreLogin: TRadioButton;
    rbDuracaoMaiorIgualLogin: TRadioButton;
    rbDuracaoMenorLogin: TRadioButton;
    rbDuracaoTodosLogin: TRadioButton;
    rectTituloDuracaoLogin: TRectangle;
    ChkDuracaoLogin: TCheckBox;
    pnlTipo: TPanel;
    Rectangle6: TRectangle;
    procedure FormResize(Sender: TObject);
    procedure cdsUnidadesAfterScroll(DataSet: TDataSet);
    procedure cdsUnidadesBeforeInsert(DataSet: TDataSet);
    procedure btnExibirTabelaClick(Sender: TObject);
    procedure btnExibirGraficosTMETMAClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);

    procedure dbgrdUnidadesCheckFieldClick(Field: TField);
    procedure edDuracaoMaiorMenorHorasChange(Sender: TObject);
    procedure edDuracaoDesdeHorasChange(Sender: TObject);
    procedure IniPeriodCheckBoxChange(Sender: TObject);
    procedure DayPeriodCheckBoxChange(Sender: TObject);
    procedure chkDuracaoPausaChange(Sender: TObject);
    procedure rbDuracaoTodosPausaChange(Sender: TObject);
    procedure AtendsTreeViewKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure rbDuracaoMenorPausaMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure rbDuracaoEntrePausaMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure dbgrdUnidadesKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure dbgrdUnidadesDrawColumnCell(Sender: TObject;
      const Canvas: TCanvas; const Column: TColumn; const Bounds: TRectF;
      const Row: integer; const Value: TValue; const State: TGridDrawStates);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ChkDuracaoLoginChange(Sender: TObject);
    procedure rbDuracaoTodosLoginChange(Sender: TObject);
    procedure rbDuracaoMenorLoginMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure rbDuracaoEntreLoginMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure edDuracaoMaiorMenorHorasLoginChangeTracking(Sender: TObject);
    procedure edDuracaoDesdeHorasLoginChangeTracking(Sender: TObject);
    procedure edDuracaoMaiorMenorMinutosLoginChangeTracking(Sender: TObject);
    procedure edDuracaoDesdeMinutosLoginChangeTracking(Sender: TObject);
    procedure edDuracaoMaiorMenorSegundosLoginChangeTracking(Sender: TObject);
    procedure edDuracaoDesdeSegundosLoginChangeTracking(Sender: TObject);
    procedure edDuracaoAteHorasLoginChangeTracking(Sender: TObject);
    procedure edDuracaoAteMinutosLoginChangeTracking(Sender: TObject);
    procedure edDuracaoAteSegundosLoginChangeTracking(Sender: TObject);
  protected
    procedure SetIDUnidade(const Value: integer); Override;
    procedure CarregaUnidades; Override;
    procedure CarregarTreeViews; Override;

    function CheckUnidadesSelecionadas: boolean; Override;
    procedure GetQueryParams; Override;
    procedure GetRepVars; Override;
    procedure ExibirGraficoSLA; Override;
    procedure EditarClientDataSet(const tabela: string; const Id: integer;
      const Selecionado: boolean); Override;
  public
    FfrmSicsReportPausas: TfrmReportPausas;
    FfrmSicsGraphicsPausas: TfrmGraphicsPausas;

    vlRepVars: record
      Atds, PAs, MPs, PeriodoDoRelatorio, PeriodoDoDia, Duracao,
        MultiUnidades: string;
      QtdeUnidadesSelecionadas: integer;
    end; { record RepVars }

    vlQueryParams: TQueryParamsPausasLogins;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; Override;
    procedure MontarWhere(QryEventos: TFDQuery; var SqlInTags: string;
      IgnoreDuracao: boolean); Override;
  end;

function frmSicsPesquisaRelatorioPausas(const aIDUnidade: integer;
  const aAllowNewInstance: boolean = False; const AOwner: TComponent = nil)
  : TfrmPesquisaRelatorioPausas;

implementation

uses
  ufrmParamsNiveisSLA,
  Sics_Common_Parametros, untMainForm, Sics_Common_Splash,
  untCommonDMConnection, untCommonDMClient,
  untCommonDMUnidades,
  FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys;

{$R *.fmx}

function frmSicsPesquisaRelatorioPausas(const aIDUnidade: integer;
  const aAllowNewInstance: boolean = False; const AOwner: TComponent = nil)
  : TfrmPesquisaRelatorioPausas;
begin
  Result := TfrmPesquisaRelatorioPausas(TfrmPesquisaRelatorioPausas.GetInstancia
    (aIDUnidade, aAllowNewInstance, AOwner));
end;

procedure TfrmPesquisaRelatorioPausas.CarregarTreeViews;
begin
  // LBC
  Carregar(Self, TDataSetField(cdsUnidades.FieldByName('ATENDENTES'))
    .NestedDataSet, AtendsTreeView, 'ATENDENTES');
  Carregar(Self, TDataSetField(cdsUnidades.FieldByName('PAS')).NestedDataSet,
    PAsTreeView, 'PAS');
  Carregar(Self, TDataSetField(cdsUnidades.FieldByName('MOTIVOS_PAUSA'))
    .NestedDataSet, MPsTreeView, 'MOTIVOS_PAUSA');
end;

procedure TfrmPesquisaRelatorioPausas.CarregaUnidades;
  procedure Copiar(CdsOrigem, CdsDestino: TDataSet; const CampoIdGrupo: string;
    CdsLkpGrupo: TDataSet; const tabela: string);
  begin
    with CdsOrigem do
    begin
      First;
      while not Eof do
      begin
        CdsDestino.Append;
        CdsDestino.FieldByName('ID').Value := FieldByName('ID').Value;
        CdsDestino.FieldByName('NOME').Value := FieldByName('NOME').Value;
        if CampoIdGrupo <> '' then
        begin
          CdsDestino.FieldByName('GRUPO_ID').Value :=
            FieldByName(CampoIdGrupo).Value;
          if CdsLkpGrupo.Locate('ID', FieldByName(CampoIdGrupo).Value, []) then
            CdsDestino.FieldByName('GRUPO_NOME').Value :=
              CdsLkpGrupo.FieldByName('NOME').Value;
        end;
        CdsDestino.FieldByName('SELECIONADO').AsBoolean := True;

        if tabela = 'ATENDENTES' then
        begin
          CdsDestino.FieldByName('ID_GRUPOATENDENTE').Value :=
            FieldByName('ID_GRUPOATENDENTE').Value;
        end;

        if tabela = 'PAS' then
        begin
          CdsDestino.FieldByName('ID_GRUPOPA').Value :=
            FieldByName('ID_GRUPOPA').Value;
        end;

        if tabela = 'MOTIVOS_PAUSA' then
        begin
          CdsDestino.FieldByName('ID_GRUPOMOTIVOSPAUSA').Value :=
            FieldByName('ID_GRUPOMOTIVOSPAUSA').Value;
          CdsDestino.FieldByName('CODIGOCOR').Value :=
            FieldByName('CODIGOCOR').Value;
        end;

        CdsDestino.Post;
        Next;
      end;
    end;
  end;

var
  iCampo: integer;
  sCampo: string;
  iTabela: integer;
  sSql, sCampoGrupoId: string;
  conn: TFDConnection;
  LConectada: Boolean;
begin
  FAtualizarTreeViewsDataSetScroll := False;
  try
    with cdsUnidades do
    begin

      FPermiteInserirUnidades := True;
      try

        if not Active then
        begin
          // LBC
          // preparando o dataset
          for iCampo := 1 to 6 do
          begin
            case iCampo of
              1:
                sCampo := 'ATENDENTES';
              2:
                sCampo := 'PAS';
              3:
                sCampo := 'MOTIVOS_PAUSA';
              4:
                sCampo := 'GRUPOS_ATENDENTES';
              5:
                sCampo := 'GRUPOS_PAS';
              6:
                sCampo := 'GRUPOS_MOTIVOS_PAUSA';
            else
              sCampo := '';
            end;

            with FieldDefs[FieldDefs.IndexOf(sCampo)].ChildDefs.AddFieldDef do
            begin
              DataType := ftInteger;
              Name := 'ID';
            end;

            with FieldDefs[FieldDefs.IndexOf(sCampo)].ChildDefs.AddFieldDef do
            begin
              DataType := ftString;
              Name := 'NOME';
              Size := 50;
            end;

            with FieldDefs[FieldDefs.IndexOf(sCampo)].ChildDefs.AddFieldDef do
            begin
              DataType := ftBoolean;
              Name := 'SELECIONADO';
            end;

            with FieldDefs[FieldDefs.IndexOf(sCampo)].ChildDefs.AddFieldDef do
            begin
              DataType := ftInteger;
              Name := 'GRUPO_ID';
            end;

            with FieldDefs[FieldDefs.IndexOf(sCampo)].ChildDefs.AddFieldDef do
            begin
              DataType := ftString;
              Name := 'GRUPO_NOME';
              Size := 50;
            end;

            // daqui pra baixo foi necessario para aproveitar no "resumo" do relatorio
            // onde faz chamadas aos metodos NGetFilaFromRange, NGetIdGrAtend,  NGetIdGrPA
            // que dependem destes campos

            // atendentes
            if sCampo = 'ATENDENTES' then
            begin
              with FieldDefs[FieldDefs.IndexOf(sCampo)].ChildDefs.AddFieldDef do
              begin
                DataType := ftInteger;
                Name := 'ID_GRUPOATENDENTE';
              end;
            end;

            if sCampo = 'PAS' then
            begin
              with FieldDefs[FieldDefs.IndexOf(sCampo)].ChildDefs.AddFieldDef do
              begin
                DataType := ftInteger;
                Name := 'ID_GRUPOPA';
              end;
            end;

            if sCampo = 'MOTIVOS_PAUSA' then
            begin
              with FieldDefs[FieldDefs.IndexOf(sCampo)].ChildDefs.AddFieldDef do
              begin
                DataType := ftInteger;
                Name := 'ID_GRUPOMOTIVOSPAUSA';
              end;

              with FieldDefs[FieldDefs.IndexOf(sCampo)].ChildDefs.AddFieldDef do
              begin
                DataType := ftInteger;
                Name := 'CODIGOCOR';
              end;
            end;
          end;
          CreateDataSet;
        end;

        // copiando os dados das outras unidades
        dmUnidades.cdsUnidades.First;
        while not dmUnidades.cdsUnidades.Eof do
        begin

          if not Locate('ID', dmUnidades.cdsUnidades.FieldByName('ID').Value, [])
          then
          begin
            Append;
            FieldByName('ID').AsInteger := dmUnidades.cdsUnidades.FieldByName
              ('ID').AsInteger;
            FieldByName('NOME').AsString := dmUnidades.cdsUnidades.FieldByName
              ('NOME').AsString;
            FieldByName('CONECTADA').AsBoolean :=
              dmUnidades.cdsUnidades.FieldByName('CONECTADA').AsBoolean;
            if dmUnidades.cdsUnidades.FieldByName('CONECTADA').AsBoolean then
              FieldByName('SELECIONADO').AsBoolean := True;
            FieldByName('CARREGOU_DADOS').AsBoolean := False;
            Post;
          end;

          {$REGION '//Testa se a unidade está conectada via BD'}
//          LConectada := False;
          conn := DMClient(dmUnidades.cdsUnidades.FieldByName('ID').AsInteger, not CRIAR_SE_NAO_EXISTIR).connRelatorio;
          try
            conn.Connected := True;
            LConectada := conn.Connected;
          except
            LConectada := False;
          end;

          Edit;
          FieldByName('CONECTADA').AsBoolean := LConectada;
          if not LConectada then
          begin
            FieldByName('SELECIONADO').AsBoolean := False;
            Post;
            dmUnidades.cdsUnidades.Next;
            Continue;
          end;
          Post;
          {$ENDREGION}


          if (not FieldByName('CARREGOU_DADOS').AsBoolean) then
          begin
            Edit;

            for iTabela := 1 to 6 do
            begin
              case iTabela of
                1:
                  begin
                    sCampo := 'ATENDENTES';
                    sCampoGrupoId := 'id_grupoatendente';
                    sSql := 'select atd.id, atd.nome, atd.id_grupoatendente, grp.nome as grupo_nome from atendentes atd left join grupos_atendentes grp on grp.id_unidade = atd.id_unidade and grp.id = atd.id_grupoatendente where atd.id_unidade = :ID_UNIDADEATUAL';
                  end;
                2:
                  begin
                    sCampo := 'PAS';
                    sCampoGrupoId := 'id_grupopa';
                    sSql := 'select pas.id, pas.nome, pas.id_grupopa, grp.nome as grupo_nome from pas left join grupos_pas grp on grp.id_unidade = pas.id_unidade and grp.id = pas.id_grupopa where pas.id_unidade = :ID_UNIDADEATUAL';
                  end;
                3:
                  begin
                    sCampo := 'MOTIVOS_PAUSA';
                    sCampoGrupoId := 'id_grupomotivospausa';
                    sSql := 'select mp.id, mp.codigocor, mp.nome, mp.id_grupomotivospausa, grp.nome as grupo_nome from motivos_pausa mp left join grupos_motivos_pausa grp on grp.id_unidade = mp.id_unidade and grp.id = mp.id_grupomotivospausa where mp.id_unidade = :ID_UNIDADEATUAL';
                  end;
                4:
                  begin
                    sCampo := 'GRUPOS_ATENDENTES';
                    sCampoGrupoId := '';
                    sSql := 'select id, nome from grupos_atendentes where id_unidade = :ID_UNIDADEATUAL';
                  end;
                5:
                  begin
                    sCampo := 'GRUPOS_PAS';
                    sCampoGrupoId := '';
                    sSql := 'select id, nome from grupos_pas where id_unidade = :ID_UNIDADEATUAL';
                  end;
                6:
                  begin
                    sCampo := 'GRUPOS_MOTIVOS_PAUSA';
                    sCampoGrupoId := '';
                    sSql := 'select id, nome from grupos_motivos_pausa where id_unidade = :ID_UNIDADEATUAL';
                  end;
              end;

              qryAux.Sql.Text := sSql;
              qryAux.Connection := conn;
              qryAux.Params.ParamByName('ID_UNIDADEATUAL').DataType := ftInteger;
              qryAux.Params.ParamByName('ID_UNIDADEATUAL').AsInteger := cdsUnidades.FieldByName('ID').Value;
              qryAux.Open;
              try
                with TDataSetField(FieldByName(sCampo)).NestedDataSet do
                begin
                  qryAux.First;
                  while not qryAux.Eof do
                  begin
                    Append;
                    FieldByName('ID').Value := qryAux.FieldByName('ID').Value;
                    FieldByName('NOME').Value :=
                      qryAux.FieldByName('NOME').Value;
                    if sCampoGrupoId <> '' then
                    begin
                      // depois ver pq criei dois campos com o id do grupo um com nome generico e outro com nome especifico
                      FieldByName('GRUPO_ID').Value :=
                        qryAux.FieldByName(sCampoGrupoId).Value;
                      FieldByName(sCampoGrupoId).Value :=
                        qryAux.FieldByName(sCampoGrupoId).Value;
                      FieldByName('GRUPO_NOME').Value :=
                        qryAux.FieldByName('GRUPO_NOME').Value;
                    end;
                    FieldByName('SELECIONADO').AsBoolean := True;

                    if sCampo = 'MOTIVOS_PAUSA' then
                    begin
                      FieldByName('CODIGOCOR').Value :=
                        qryAux.FieldByName('CODIGOCOR').Value;
                    end;

                    Post;
                    qryAux.Next;
                  end;
                end;
              finally
                qryAux.Close;
              end;
            end;

            FieldByName('CARREGOU_DADOS').AsBoolean := True;

            Post;
          end;

          dmUnidades.cdsUnidades.Next;
        end;
      finally
        FPermiteInserirUnidades := False;
      end;

      First;
      CarregarTreeViews;
    end;

  finally
    FAtualizarTreeViewsDataSetScroll := True;
    PosicionaUnidadeCorrente;
  end;

  inherited;
end;

procedure TfrmPesquisaRelatorioPausas.edDuracaoMaiorMenorHorasChange
  (Sender: TObject);
begin
  vlChanged := True;
  if ((not rbDuracaoMenorPausa.IsChecked) and
    (not rbDuracaoMaiorIgualPausa.IsChecked)) then
    rbDuracaoMenorPausa.IsChecked := True;
end;

procedure TfrmPesquisaRelatorioPausas.edDuracaoMaiorMenorHorasLoginChangeTracking(
  Sender: TObject);
begin
  vlChanged := True;
  if ((not rbDuracaoMenorLogin.IsChecked) and
    (not rbDuracaoMaiorIgualLogin.IsChecked)) then
    rbDuracaoMenorLogin.IsChecked := True;
end;

procedure TfrmPesquisaRelatorioPausas.edDuracaoMaiorMenorMinutosLoginChangeTracking(
  Sender: TObject);
begin
  vlChanged := True;
  if ((not rbDuracaoMenorLogin.IsChecked) and
    (not rbDuracaoMaiorIgualLogin.IsChecked)) then
    rbDuracaoMenorLogin.IsChecked := True;
end;

procedure TfrmPesquisaRelatorioPausas.edDuracaoMaiorMenorSegundosLoginChangeTracking(
  Sender: TObject);
begin
  vlChanged := True;
  if ((not rbDuracaoMenorLogin.IsChecked) and
    (not rbDuracaoMaiorIgualLogin.IsChecked)) then
    rbDuracaoMenorLogin.IsChecked := True;
end;

procedure TfrmPesquisaRelatorioPausas.edDuracaoAteHorasLoginChangeTracking(
  Sender: TObject);
begin
  vlChanged := True;
  rbDuracaoEntreLogin.IsChecked := True;
end;

procedure TfrmPesquisaRelatorioPausas.edDuracaoAteMinutosLoginChangeTracking(
  Sender: TObject);
begin
  vlChanged := True;
  rbDuracaoEntreLogin.IsChecked := True;
end;

procedure TfrmPesquisaRelatorioPausas.edDuracaoAteSegundosLoginChangeTracking(
  Sender: TObject);
begin
  vlChanged := True;
  rbDuracaoEntreLogin.IsChecked := True;
end;

procedure TfrmPesquisaRelatorioPausas.edDuracaoDesdeHorasChange
  (Sender: TObject);
begin
  vlChanged := True;
  rbDuracaoEntrePausa.IsChecked := True;
end;

procedure TfrmPesquisaRelatorioPausas.edDuracaoDesdeHorasLoginChangeTracking(
  Sender: TObject);
begin
  vlChanged := True;
  rbDuracaoEntreLogin.IsChecked := True;
end;

procedure TfrmPesquisaRelatorioPausas.edDuracaoDesdeMinutosLoginChangeTracking(
  Sender: TObject);
begin
  vlChanged := True;
  rbDuracaoEntreLogin.IsChecked := True;
end;

procedure TfrmPesquisaRelatorioPausas.edDuracaoDesdeSegundosLoginChangeTracking(
  Sender: TObject);
begin
  vlChanged := True;
  rbDuracaoEntreLogin.IsChecked := True;
end;

procedure TfrmPesquisaRelatorioPausas.rbDuracaoTodosLoginChange(
  Sender: TObject);
begin
  inherited;
  vlChanged := True;
end;

procedure TfrmPesquisaRelatorioPausas.rbDuracaoTodosPausaChange
  (Sender: TObject);
begin
  inherited;
  vlChanged := True;
end;

procedure TfrmPesquisaRelatorioPausas.SetIDUnidade(const Value: integer);
begin
  if (IDUnidade <> Value) then
  begin
    inherited;
    FreeAndNil(FfrmSicsReportPausas);
    FreeAndNil(FfrmSicsGraphicsPausas);
  end;
end;

procedure TfrmPesquisaRelatorioPausas.rbDuracaoEntreLoginMouseUp(
  Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  inherited;
  vlChanged := True;
  edDuracaoDesdeHorasLogin.SetFocus;
end;

procedure TfrmPesquisaRelatorioPausas.rbDuracaoEntrePausaMouseUp
  (Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  inherited;
  vlChanged := True;
  edDuracaoDesdeHorasPausa.SetFocus;
end;

procedure TfrmPesquisaRelatorioPausas.rbDuracaoMenorLoginMouseUp(
  Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  inherited;
  vlChanged := True;
  edDuracaoMaiorMenorHorasLogin.SetFocus;
end;

procedure TfrmPesquisaRelatorioPausas.rbDuracaoMenorPausaMouseUp
  (Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  inherited;
  vlChanged := True;
  edDuracaoMaiorMenorHorasPausa.SetFocus;
end;

procedure TfrmPesquisaRelatorioPausas.IniPeriodCheckBoxChange(Sender: TObject);
begin
  inherited;
  vlChanged := True;

  EnableDisableAllControls(IniPeriodPanel, IniPeriodCheckBox.IsChecked,
    rectTituloPeriodoInicio);
  if IniPeriodCheckBox.IsChecked then
    IniSinceDayEdit.SetFocus;
end;

procedure TfrmPesquisaRelatorioPausas.DayPeriodCheckBoxChange(Sender: TObject);
begin
  inherited;
  vlChanged := True;

  Label9.Enabled := DayPeriodCheckBox.IsChecked;
  Label10.Enabled := DayPeriodCheckBox.IsChecked;
  Label11.Enabled := DayPeriodCheckBox.IsChecked;
  Label12.Enabled := DayPeriodCheckBox.IsChecked;
  DayPeriodIniHourEdit.Enabled := DayPeriodCheckBox.IsChecked;
  DayPeriodIniMinuteEdit.Enabled := DayPeriodCheckBox.IsChecked;
  DayPeriodUntilHourEdit.Enabled := DayPeriodCheckBox.IsChecked;
  DayPeriodUntilMinuteEdit.Enabled := DayPeriodCheckBox.IsChecked;

  if DayPeriodCheckBox.IsChecked then
    DayPeriodIniHourEdit.SetFocus;
end;

procedure TfrmPesquisaRelatorioPausas.EditarClientDataSet(const tabela: string;
  const Id: integer; const Selecionado: boolean);
//var
//  sCampo: string;
begin
  if FLimpandoTreeView then
    Exit;

  if tabela <> '' then
  begin
    with TDataSetField(cdsUnidades.FieldByName(tabela)).NestedDataSet do
    begin
      if Locate('ID', Id, []) then
      begin
        Edit;
        FieldByName('SELECIONADO').AsBoolean := Selecionado;
        Post;
      end;
    end;
  end;
end;

procedure TfrmPesquisaRelatorioPausas.GetQueryParams;
var
  iDetalhes, iTotalRec: integer;
  sCampoDetalhe: string;
  bTodos: boolean;
  LDataSetTmp: TClientDataSet;
begin
  vlChanged := False;

  with vlQueryParams do
  begin
    ChoosePeriodoDoRelatorio := False;
    ChooseDuracaoPausa := False;
    ChooseDuracaoLogin := False;
    ChoosePeriodoDoDia := False;
    ChooseAtds := False;
    ChoosePAs := False;
    ChooseMPs := False;
    IniSinceTime := 0;
    IniUntilTime := 0;
    DayPeriodIniHour := 0;
    DayPeriodIniMinute := 0;
    DayPeriodUntilHour := 0;
    DayPeriodUntilMinute := 0;

    {$REGION '//Recupera filtros "Duração Pausa"'}
    ChooseDuracaoPausa := chkDuracaoPausa.IsChecked;
    if (rbDuracaoTodosPausa.IsChecked) then
    begin
      DuracaoPausa.TipoDeDuracao := tdTodos;
      DuracaoPausa.Tempo1 := 0;
      DuracaoPausa.Tempo2 := 0;
    end
    else if rbDuracaoMenorPausa.IsChecked then
    begin
      DuracaoPausa.TipoDeDuracao := tdMenor;
      DuracaoPausa.Tempo1 := EncodeTime(strtoint(edDuracaoMaiorMenorHorasPausa.Text),
        strtoint(edDuracaoMaiorMenorMinutosPausa.Text),
        strtoint(edDuracaoMaiorMenorSegundosPausa.Text), 0);
      DuracaoPausa.Tempo2 := 0;
    end
    else if rbDuracaoMaiorIgualPausa.IsChecked then
    begin
      DuracaoPausa.TipoDeDuracao := tdMaiorIgual;
      DuracaoPausa.Tempo1 := EncodeTime(strtoint(edDuracaoMaiorMenorHorasPausa.Text),
        strtoint(edDuracaoMaiorMenorMinutosPausa.Text),
        strtoint(edDuracaoMaiorMenorSegundosPausa.Text), 0);
      DuracaoPausa.Tempo2 := 0;
    end
    else if rbDuracaoEntrePausa.IsChecked then
    begin
      DuracaoPausa.TipoDeDuracao := tdEntre;
      DuracaoPausa.Tempo1 := EncodeTime(strtoint(edDuracaoDesdeHorasPausa.Text),
        strtoint(edDuracaoDesdeMinutosPausa.Text),
        strtoint(edDuracaoDesdeSegundosPausa.Text), 0);
      DuracaoPausa.Tempo2 := EncodeTime(strtoint(edDuracaoAteHorasPausa.Text),
        strtoint(edDuracaoAteMinutosPausa.Text),
        strtoint(edDuracaoAteSegundosPausa.Text), 999);
    end;
    {$ENDREGION}

    {$REGION '//Recupera filtros "Duração Login"'}
    ChooseDuracaoLogin := ChkDuracaoLogin.IsChecked;
    if (rbDuracaoTodosLogin.IsChecked)
    then
    begin
      DuracaoLogin.TipoDeDuracao := tdTodos;
      DuracaoLogin.Tempo1 := 0;
      DuracaoLogin.Tempo2 := 0;
    end
    else if rbDuracaoMenorLogin.IsChecked then
    begin
      DuracaoLogin.TipoDeDuracao := tdMenor;
      DuracaoLogin.Tempo1 :=
        EncodeTime(strtoint(edDuracaoMaiorMenorHorasLogin.Text),
        strtoint(edDuracaoMaiorMenorMinutosLogin.Text),
        strtoint(edDuracaoMaiorMenorSegundosLogin.Text), 0);
      DuracaoLogin.Tempo2 := 0;
    end
    else if rbDuracaoMaiorIgualLogin.IsChecked then
    begin
      DuracaoLogin.TipoDeDuracao := tdMaiorIgual;
      DuracaoLogin.Tempo1 :=
        EncodeTime(strtoint(edDuracaoMaiorMenorHorasLogin.Text),
        strtoint(edDuracaoMaiorMenorMinutosLogin.Text),
        strtoint(edDuracaoMaiorMenorSegundosLogin.Text), 0);
      DuracaoLogin.Tempo2 := 0;
    end
    else if rbDuracaoEntreLogin.IsChecked then
    begin
      DuracaoLogin.TipoDeDuracao := tdEntre;
      DuracaoLogin.Tempo1 :=
        EncodeTime(strtoint(edDuracaoDesdeHorasLogin.Text),
        strtoint(edDuracaoDesdeMinutosLogin.Text),
        strtoint(edDuracaoDesdeSegundosLogin.Text), 0);
      DuracaoLogin.Tempo2 := EncodeTime(strtoint(edDuracaoAteHorasLogin.Text),
        strtoint(edDuracaoAteMinutosLogin.Text),
        strtoint(edDuracaoAteSegundosLogin.Text), 999);
    end;
    {$ENDREGION}

    if IniPeriodCheckBox.IsChecked then
    begin
      ChoosePeriodoDoRelatorio := True;

      IniSinceTime := EncodeDate(2000 + strtoint(IniSinceYearEdit.Text),
        strtoint(IniSinceMonthEdit.Text), strtoint(IniSinceDayEdit.Text)) +
        EncodeTime(0, 0, 0, 0);

      IniUntilTime := EncodeDate(2000 + strtoint(IniUntilYearEdit.Text),
        strtoint(IniUntilMonthEdit.Text), strtoint(IniUntilDayEdit.Text)) +
        EncodeTime(23, 59, 59, 999);
    end;

    if DayPeriodCheckBox.IsChecked then
    begin
      ChoosePeriodoDoDia := True;
      DayPeriodIniHour := strtoint(DayPeriodIniHourEdit.Text);
      DayPeriodIniMinute := strtoint(DayPeriodIniMinuteEdit.Text);
      DayPeriodUntilHour := strtoint(DayPeriodUntilHourEdit.Text);
      DayPeriodUntilMinute := strtoint(DayPeriodUntilMinuteEdit.Text);
    end;

    LDataSetTmp := TClientDataSet.Create(nil);
    try
      // LBC
      for iDetalhes := 1 to 3 do
      begin
        case iDetalhes of
          1:
            sCampoDetalhe := 'ATENDENTES';
          2:
            sCampoDetalhe := 'PAS';
          3:
            sCampoDetalhe := 'MOTIVOS_PAUSA';
        end;
        LDataSetTmp.DataSetField :=
          TDataSetField(cdsUnidades.FieldByName(sCampoDetalhe));
        iTotalRec := LDataSetTmp.RecordCount;
        LDataSetTmp.Filter := 'SELECIONADO=TRUE';
        LDataSetTmp.Filtered := True;
        try
          bTodos := LDataSetTmp.RecordCount = iTotalRec;
        finally
          LDataSetTmp.Filtered := False;
        end;

        case iDetalhes of
          1:
            ChooseAtds := not bTodos;
          2:
            ChoosePAs := not bTodos;
          3:
            ChooseMPs := not bTodos;
        end;
      end;
    finally
      FreeAndNil(LDataSetTmp);
    end;
  end;
end; { func GetQueryParams }

procedure TfrmPesquisaRelatorioPausas.MontarWhere(QryEventos: TFDQuery;
  var SqlInTags: string; IgnoreDuracao: boolean);

  procedure ExtractComma(var s: string);
  var
    i: integer;
  begin
    for i := 1 to length(s) do
      if s[i] = ',' then
        s[i] := '.';
  end; { procedure ExtractComma }

  function ExtractAND(const s: string): string;
  begin
    ExtractAND := Copy(s, 1, length(s) - 3);
  end; { procedure ExtractAND }

var
  sDuracao, s, sIn, sCampoOrigem, sCampoWhere: string;
  iDetalhes: integer;
  sOldIndexFieldNames: string;
  iTotalRec: integer;
  bTodos, bTbNenhum: boolean;
  LDataSetTmp: TClientDataSet;
begin
  SqlInTags := '';

  if vlQueryParams.ChooseDuracaoPausa XOR vlQueryParams.ChooseDuracaoLogin then
  begin
    if vlQueryParams.ChooseDuracaoPausa then
      s := '(E.ID_TIPOEVENTO = ' + inttostr(ord(teEmPausa)) + ' ) and'
    else
      s := '(E.ID_TIPOEVENTO = ' + inttostr(ord(teLogado)) + ' ) and';
  end
  else
    s := '(E.ID_TIPOEVENTO IN ( ' + inttostr(ord(teLogado)) + ', ' +
                                    inttostr(ord(teEmPausa)) + ') ) and';
  QryEventos.Sql.Add(s);

  if vlQueryParams.ChoosePeriodoDoRelatorio then
  begin
    s := '((E.INICIO >= :IniSinceTime )and(E.INICIO <= :IniUntilTime ))and';
    ExtractComma(s);
    QryEventos.Sql.Add(s);
  end; { if ChoosePeriodoDoRelatorio }

  if vlQueryParams.ChoosePeriodoDoDia then
  begin
    if (vlQueryParams.DayPeriodIniHour)
      = (vlQueryParams.DayPeriodUntilHour)
    then { EXEMPLO: 10:02 ~ 10:38 => [H=10] & [2<=M<=38] }
      s := '((({extract(hour, INICIO)} = ' +
        inttostr(vlQueryParams.DayPeriodIniHour) + ')' + ' and ' +
        '({extract(minute, INICIO)} between ' +
        inttostr(vlQueryParams.DayPeriodIniMinute) + ' and ' +
        inttostr(vlQueryParams.DayPeriodUntilMinute) + '))) and'
    else { EXEMPLO:  10:50 ~ 13:30 => [H=10 & M>=50] + [H=13 & M<=30] + [10+1<=H<=13-1] }
      s := '((({extract(hour, INICIO)} = ' +
        inttostr(vlQueryParams.DayPeriodIniHour) + ') and ' +
        '({extract(minute, INICIO)} >= ' +
        inttostr(vlQueryParams.DayPeriodIniMinute) + ')    )  or ' +

        '(({extract(hour, INICIO)} = ' +
        inttostr(vlQueryParams.DayPeriodUntilHour) + ') and ' +
        '({extract(minute, INICIO)} <= ' +
        inttostr(vlQueryParams.DayPeriodUntilMinute) + ')    ) or ' +

        '({extract(hour, INICIO)} between ' +
        inttostr(vlQueryParams.DayPeriodIniHour + 1) + ' and ' +
        inttostr(vlQueryParams.DayPeriodUntilHour - 1) + '))and';
    //ExtractComma(s);
    QryEventos.Sql.Add(s);
  end; { if ChoosePeriodoDoDiaPausas }

  // LBC
  for iDetalhes := 1 to 3 do
  begin
    case iDetalhes of
      1:
        begin
          sCampoOrigem := 'ATENDENTES';
          sCampoWhere := 'E.ID_ATENDENTE';
        end;
      2:
        begin
          sCampoOrigem := 'PAS';
          sCampoWhere := 'E.ID_PA';
        end;
      3:
        begin
          sCampoOrigem := 'MOTIVOS_PAUSA';
          sCampoWhere := 'E.ID_MOTIVOPAUSA';
        end;
    end;

    sIn := '';
    LDataSetTmp := TClientDataSet.Create(nil);
    try
      LDataSetTmp.DataSetField :=
        TDataSetField(Self.cdsUnidades.FieldByName(sCampoOrigem));

      iTotalRec := LDataSetTmp.RecordCount;
      LDataSetTmp.Filter := 'SELECIONADO=TRUE';
      LDataSetTmp.Filtered := True;
      try
        bTodos := LDataSetTmp.RecordCount = iTotalRec;
        bTbNenhum := False;

        if not bTodos then
        begin
          sOldIndexFieldNames := LDataSetTmp.IndexFieldNames;
          LDataSetTmp.IndexFieldNames := 'ID';
          try
            LDataSetTmp.First;
            while not LDataSetTmp.Eof do
            begin
              if LDataSetTmp.FieldByName('ID').AsInteger = 0 then
                bTbNenhum := True
              else
              begin
                if sIn <> '' then
                  sIn := sIn + ',';
                sIn := sIn + LDataSetTmp.FieldByName('ID').AsString;
              end;

              LDataSetTmp.Next;
            end;
          finally
            LDataSetTmp.IndexFieldNames := sOldIndexFieldNames;
          end;
        end;

      finally
        LDataSetTmp.Filtered := False;
      end;

      if (sIn <> '') or (bTbNenhum) then
      begin
        s := '(';
        if bTbNenhum then
          s := s + sCampoWhere + ' is null';

        if sIn <> '' then
        begin
          if bTbNenhum then
            s := s + ' or ';

          s := s + sCampoWhere + ' in (' + sIn + ')'
        end;
        s := s + ')and';

        QryEventos.Sql.Add(s);
      end;
    finally
      FreeAndNil(LDataSetTmp);
    end;
  end;

  if (vlQueryParams.ChooseDuracaoPausa and (vlQueryParams.DuracaoPausa.TipoDeDuracao <> tdTodos)) or
     (vlQueryParams.ChooseDuracaoLogin and (vlQueryParams.DuracaoLogin.TipoDeDuracao <> tdTodos)) then
  begin
    sDuracao := '(';

    if ((vlQueryParams.ChooseDuracaoPausa) and (not IgnoreDuracao)) then
    begin
      if vlQueryParams.DuracaoPausa.TipoDeDuracao <> tdTodos then
      begin

        case vlQueryParams.DuracaoPausa.TipoDeDuracao of
          tdMenor:
            s := '((E.DURACAO_SEGUNDOS < :Tempo11) and (E.ID_TIPOEVENTO = '+ inttostr(ord(teEmPausa)) +' ))  or ';
          tdMaiorIgual:
            s := '((E.DURACAO_SEGUNDOS >= :Tempo11) and (E.ID_TIPOEVENTO = '+ inttostr(ord(teEmPausa)) +')) or ';
          tdEntre:
            s := '(((E.DURACAO_SEGUNDOS >= :Tempo11) and (E.DURACAO_SEGUNDOS <= :Tempo21) and (E.ID_TIPOEVENTO = '+ inttostr(ord(teEmPausa)) +'))) or ';
        end; { case }

        sDuracao := sDuracao + s;
      end;
    end;

    if ((vlQueryParams.ChooseDuracaoLogin) and (not IgnoreDuracao)) then
    begin
      if vlQueryParams.DuracaoLogin.TipoDeDuracao <> tdTodos then
      begin
        case vlQueryParams.DuracaoLogin.TipoDeDuracao of
          tdMenor:
            s := '((E.DURACAO_SEGUNDOS < :Tempo11Login)  and (E.ID_TIPOEVENTO = '+ inttostr(ord(teLogado)) +') ) or ';
          tdMaiorIgual:
            s := '((E.DURACAO_SEGUNDOS >= :Tempo11Login) and (E.ID_TIPOEVENTO = '+ inttostr(ord(teLogado)) +'))  or ';
          tdEntre:
            s := '(((E.DURACAO_SEGUNDOS >= :Tempo11Login) and (E.DURACAO_SEGUNDOS <= :Tempo21Login) and (E.ID_TIPOEVENTO = '+ inttostr(ord(teLogado)) +'))) or ';
        end; { case }

        sDuracao := sDuracao + s;
      end;
    end;

    //se o tamanho do sDuracao for 1, é porque só ficou o "(", ou seja, não
    //entrou em nenhum dos IF acima, sendo assim, não é necessário adicionar
    //nada na SQL
    if Length(sDuracao) > 1 then
    begin
      sDuracao := Copy(sDuracao, 1, length(sDuracao) - 3);
      sDuracao := sDuracao + ') and';
      QryEventos.Sql.Add(sDuracao);
    end;
  end;

  s := ExtractAND(QryEventos.Sql.Strings[QryEventos.Sql.Count - 1]);
  s := s + ')';
  QryEventos.Sql.Delete(QryEventos.Sql.Count - 1);
  QryEventos.Sql.Add(s);

  QryEventos.Params.ParamByName('ID_UNIDADE').DataType := ftInteger;

  if vlQueryParams.ChoosePeriodoDoRelatorio then
  begin
    QryEventos.Params.ParamByName('IniSinceTime').DataType := ftTimeStamp;
    QryEventos.Params.ParamByName('IniUntilTime').DataType := ftTimeStamp;
    QryEventos.Params.ParamByName('IniSinceTime').AsSQLTimeStamp :=
      DateTimeToSQLTimeStamp(vlQueryParams.IniSinceTime);
    QryEventos.Params.ParamByName('IniUntilTime').AsSQLTimeStamp :=
      DateTimeToSQLTimeStamp(vlQueryParams.IniUntilTime);
  end; { if ChoosePeriodoDoRelatorio }

  if ((vlQueryParams.ChooseDuracaoPausa) and (not IgnoreDuracao)) then
  begin
    case vlQueryParams.DuracaoPausa.TipoDeDuracao of
      tdMenor, tdMaiorIgual:
        begin
          QryEventos.Params.ParamByName('Tempo11').DataType := ftInteger;
          QryEventos.Params.ParamByName('Tempo11').AsInteger :=
            SecondsBetween(0, vlQueryParams.DuracaoPausa.Tempo1);
        end;
      tdEntre:
        begin
          QryEventos.Params.ParamByName('Tempo11').DataType := ftInteger;
          QryEventos.Params.ParamByName('Tempo21').DataType := ftInteger;
          QryEventos.Params.ParamByName('Tempo11').AsInteger :=
            SecondsBetween(0, vlQueryParams.DuracaoPausa.Tempo1);
          QryEventos.Params.ParamByName('Tempo21').AsInteger :=
            SecondsBetween(0, vlQueryParams.DuracaoPausa.Tempo2);
        end;
    end; { case }
  end;

  /// //////////////////////---PARAMETROS ESCOLHEU DURAÇÃO LOGIN---////////////////////////////////
  if ((vlQueryParams.ChooseDuracaoLogin) and (not IgnoreDuracao)) then
  begin
    case vlQueryParams.DuracaoLogin.TipoDeDuracao of
      tdMenor, tdMaiorIgual:
        begin
          QryEventos.Params.ParamByName('ID_UNIDADE').DataType := ftInteger;
          QryEventos.Params.ParamByName('Tempo11Login').DataType := ftInteger;
          QryEventos.Params.ParamByName('Tempo11Login').AsInteger :=
            SecondsBetween(0, vlQueryParams.DuracaoLogin.Tempo1);
        end;
      tdEntre:
        begin
          QryEventos.Params.ParamByName('ID_UNIDADE').DataType := ftInteger;
          QryEventos.Params.ParamByName('Tempo11Login').DataType := ftInteger;
          QryEventos.Params.ParamByName('Tempo21Login').DataType := ftInteger;
          QryEventos.Params.ParamByName('Tempo11Login').AsInteger :=
            SecondsBetween(0, vlQueryParams.DuracaoLogin.Tempo1);
          QryEventos.Params.ParamByName('Tempo21Login').AsInteger :=
            SecondsBetween(0, vlQueryParams.DuracaoLogin.Tempo2);
        end;
    end; { case }
  end;

end;

procedure TfrmPesquisaRelatorioPausas.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  SalvaSituacaoTreeView(Self, AtendsTreeView);
  SalvaSituacaoTreeView(Self, PAsTreeView);
  SalvaSituacaoTreeView(Self, MPsTreeView);
end;

procedure TfrmPesquisaRelatorioPausas.FormResize(Sender: TObject);
const
  OFF = 10;
begin
  IniPeriodPanel.Position.X := OFF;
  IniPeriodPanel.Position.Y := OFF;
  IniDayPeriodPanel.Position.X := IniPeriodPanel.Position.X +IniPeriodPanel.Width + OFF;
  IniDayPeriodPanel.Position.Y := IniPeriodPanel.Position.Y;

  pnlTipo.Position.X             := OFF;
  pnlTipo.Position.Y             := IniPeriodPanel.Position.Y + IniPeriodPanel.Height + OFF;

  pnlUnidades.Position.X         := OFF;
  pnlUnidades.Position.Y         := pnlTipo.Position.Y + pnlTipo.Height + OFF;
  pnlUnidades.Height             := ClientHeight - pnlUnidades.Position.Y - pnlBotoes.Height - OFF;

  AtendsPanel.Position.X := pnlTipo.Position.X + pnlTipo.Width + OFF;
  AtendsPanel.Position.Y := IniDayPeriodPanel.Position.Y;
  AtendsPanel.Height := (Height - pnlBotoes.Height - 3 * OFF) - 25;
  AtendsPanel.Width := (Trunc((Width -    pnlTipo.Width - 5 * OFF)) div 3) - 5;
  PAsPanel.Position.X := AtendsPanel.Position.X + AtendsPanel.Width + OFF;
  PAsPanel.Position.Y := AtendsPanel.Position.Y;
  PAsPanel.Height := AtendsPanel.Height;
  PAsPanel.Width := AtendsPanel.Width;
  pnlMP.Position.X := PAsPanel.Position.X + PAsPanel.Width + OFF;
  pnlMP.Position.Y := PAsPanel.Position.Y;
  pnlMP.Height := PAsPanel.Height;
  pnlMP.Width := PAsPanel.Width;

  AtendsTreeView.Position.X := OFF;
  AtendsTreeView.Position.Y := AtendsLabel.Position.Y + AtendsLabel.Height + OFF;
  AtendsTreeView.Height := AtendsPanel.Height - AtendsTreeView.Position.Y - OFF;
  AtendsTreeView.Width := AtendsPanel.Width - 2 * OFF;
  PAsTreeView.Position.X := OFF;
  PAsTreeView.Position.Y := PAsLabel.Position.Y + PAsLabel.Height + OFF;
  PAsTreeView.Height := PAsPanel.Height - PAsTreeView.Position.Y - OFF;
  PAsTreeView.Width := PAsPanel.Width - 2 * OFF;
  MPsTreeView.Position.X := OFF;
  MPsTreeView.Position.Y := MPsLabel.Position.Y + MPsLabel.Height + OFF;
  MPsTreeView.Height := pnlMP.Height - MPsTreeView.Position.Y - OFF;
  MPsTreeView.Width := pnlMP.Width - 2 * OFF;
end;

procedure TfrmPesquisaRelatorioPausas.cdsUnidadesAfterScroll(DataSet: TDataSet);
begin
  if not FAtualizarTreeViewsDataSetScroll then
    Exit;

  CarregarTreeViews;
end;

procedure TfrmPesquisaRelatorioPausas.cdsUnidadesBeforeInsert
  (DataSet: TDataSet);
begin
  if not FPermiteInserirUnidades then
    Abort;
end;

procedure TfrmPesquisaRelatorioPausas.GetRepVars;
var
  iDetalhes, iTotalRec: integer;
  bAtdsDivergente, bPAsDivergente, bMPsDivergente, bTodos, bTbNenhum: boolean;
  sAtdsBase, sPAsBase, sMPsBase, sIds, sCampoOrigem, sOldIndexFieldNames,
    sIdsTemp: string;
  ArrIds: TIntegerDynArray;
  bOldAtualizarTreeViewsDataSetScroll: boolean;
  LDataSetTmp: TClientDataSet;
begin
  bOldAtualizarTreeViewsDataSetScroll := FAtualizarTreeViewsDataSetScroll;
  FAtualizarTreeViewsDataSetScroll := False;
  try

    // LBC
    for iDetalhes := 1 to 3 do
    begin
      case iDetalhes of
        1:
          sCampoOrigem := 'ATENDENTES';
        2:
          sCampoOrigem := 'PAS';
        3:
          sCampoOrigem := 'MOTIVOS_PAUSA';
      end;

      sIds := '';
      LDataSetTmp := TClientDataSet.Create(nil);
      try
        LDataSetTmp.DataSetField :=
          TDataSetField(cdsUnidades.FieldByName(sCampoOrigem));

        iTotalRec := LDataSetTmp.RecordCount;
        LDataSetTmp.Filter := 'SELECIONADO=TRUE';
        LDataSetTmp.Filtered := True;
        try
          bTodos := LDataSetTmp.RecordCount = iTotalRec;
          bTbNenhum := False;

          if not bTodos then
          begin
            sOldIndexFieldNames := LDataSetTmp.IndexFieldNames;
            LDataSetTmp.IndexFieldNames := 'ID';
            try
              LDataSetTmp.First;
              while not LDataSetTmp.Eof do
              begin
                if LDataSetTmp.FieldByName('ID').AsInteger = 0 then
                  bTbNenhum := True
                else
                begin
                  if sIds <> '' then
                    sIds := sIds + ',';
                  sIds := sIds + LDataSetTmp.FieldByName('ID').AsString;
                end;
                LDataSetTmp.Next;
              end;
            finally
              LDataSetTmp.IndexFieldNames := sOldIndexFieldNames;
            end;
          end;
        finally
          LDataSetTmp.Filtered := False;
        end;

        if bTodos then
          sIdsTemp := 'Todos'
        else
        begin
          StrToIntArray(StringReplace(sIds, ',', ';',
            [rfReplaceAll, rfIgnoreCase]), ArrIds);
          IntArrayToStr(ArrIds, sIdsTemp);
          if bTbNenhum then
            if sIdsTemp = '' then
            begin
              if iDetalhes in [1, 3] then // Atendentes ou Motivo de Pausa
                sIdsTemp := 'Nenhum'
              else
                sIdsTemp := 'Nenhuma';
            end
            else if iDetalhes in [1, 3] then // Atendentes ou Motivo de Pausa
              sIdsTemp := sIdsTemp + ' + nenhum'
            else
              sIdsTemp := sIdsTemp + ' + nenhuma';
        end;
        cdsUnidades.Edit;
        cdsUnidades.FieldByName(sCampoOrigem + '_STR').AsString := sIdsTemp;
        cdsUnidades.Post;
      finally
        FreeAndNil(LDataSetTmp);
      end;
    end;

    with vlRepVars do
    begin
      MPs := 'Todos';
      Atds := 'Todos';
      PAs := 'Todas';
      PeriodoDoRelatorio := '---';
      PeriodoDoDia := '---';
      Duracao := '---';
      MultiUnidades := '';
      QtdeUnidadesSelecionadas := 0;

      if (cdsUnidades.RecordCount > 1) then
      begin
        with cdsUnidades do
        begin
          First;
          while not Eof do
          begin
            if FieldByName('SELECIONADO').AsBoolean then
            begin
              if MultiUnidades <> '' then
                MultiUnidades := MultiUnidades + ', ';
              MultiUnidades := MultiUnidades + FieldByName('NOME').AsString;
              QtdeUnidadesSelecionadas := QtdeUnidadesSelecionadas + 1;
            end;
            Next;
          end;
        end;
      end;

      if QtdeUnidadesSelecionadas > 1 then
        MultiUnidades := 'Conforme Unidade';

      if cdsUnidades.RecordCount = 1 then
      begin
        QtdeUnidadesSelecionadas := 1;
        if cdsUnidades.Locate('ID', 0, []) then
        begin
          Atds := cdsUnidades.FieldByName('ATENDENTES_STR').AsString;
          PAs := cdsUnidades.FieldByName('PAS_STR').AsString;
          MPs := cdsUnidades.FieldByName('MOTIVOS_PAUSA_STR').AsString;
        end;
      end
      else
      begin
        bAtdsDivergente := False;
        bPAsDivergente := False;
        bMPsDivergente := False;
        with cdsUnidades do
        begin
          First;
          sAtdsBase := FieldByName('ATENDENTES_STR').AsString;
          sPAsBase := FieldByName('PAS_STR').AsString;
          sMPsBase := FieldByName('MOTIVOS_PAUSA_STR').AsString;

          while not Eof do
          begin
            if FieldByName('ATENDENTES_STR').AsString <> sAtdsBase then
              bAtdsDivergente := True;
            if FieldByName('PAS_STR').AsString <> sPAsBase then
              bPAsDivergente := True;
            if FieldByName('MOTIVOS_PAUSA_STR').AsString <> sMPsBase then
              bMPsDivergente := True;
            Next;
          end;
        end;

        if bAtdsDivergente then
          Atds := 'Conforme Unidade'
        else
          Atds := sAtdsBase;
        if bPAsDivergente then
          PAs := 'Conforme Unidade'
        else
          PAs := sPAsBase;
        if bMPsDivergente then
          MPs := 'Conforme Unidade'
        else
          MPs := sMPsBase;
      end;

      if vlQueryParams.ChoosePeriodoDoRelatorio then
      begin
        PeriodoDoRelatorio := FormatDateTime('dd/mm/yy',
          vlQueryParams.IniSinceTime) + ' a ' + FormatDateTime('dd/mm/yy',
          vlQueryParams.IniUntilTime);
      end; { if ChoosePeriodoDoRelatorio }

      if vlQueryParams.ChoosePeriodoDoDia then
      begin
        PeriodoDoDia := FormatNumber(2, vlQueryParams.DayPeriodIniHour) +
          ':' + FormatNumber(2, vlQueryParams.DayPeriodIniMinute) + ' a '
          + FormatNumber(2, vlQueryParams.DayPeriodUntilHour) + ':' +
          FormatNumber(2, vlQueryParams.DayPeriodUntilMinute);
      end; { if ChooseDuracao }

      if (vlQueryParams.ChooseDuracaoPausa) then // inserir o ignoreduracao ?
      begin
        case vlQueryParams.DuracaoPausa.TipoDeDuracao of
          tdTodos:
            Duracao := 'Todas';
          tdMenor:
            Duracao := '<' + FormatTimeComAspas
              (vlQueryParams.DuracaoPausa.Tempo1);
          tdMaiorIgual:
            Duracao := '>=' + FormatTimeComAspas
              (vlQueryParams.DuracaoPausa.Tempo1);
          tdEntre:
            Duracao := '' + FormatTimeComAspas
              (vlQueryParams.DuracaoPausa.Tempo1) + ' a ' +
              FormatTimeComAspas(vlQueryParams.DuracaoPausa.Tempo2);
        end; { case }
      end;
    end; { with RepVars }

  finally
    FAtualizarTreeViewsDataSetScroll := bOldAtualizarTreeViewsDataSetScroll;
  end;
end;

procedure TfrmPesquisaRelatorioPausas.btnExibirTabelaClick(Sender: TObject);
begin
  if not CheckUnidadesSelecionadas then
    Exit;

  GetQueryParams;
  GetRepVars;

  try
    if not Assigned(FfrmSicsReportPausas) then
    begin
      FfrmSicsReportPausas := TfrmReportPausas.Create(Self, IDUnidade);
    end;
    MainForm.ExibeSomenteOFrame(FfrmSicsReportPausas);
  except
    FreeAndNil(FfrmSicsGraphicsPausas);
    raise;
  end;
  Hide;
end;

procedure TfrmPesquisaRelatorioPausas.btnExibirGraficosTMETMAClick
  (Sender: TObject);
var
  ParamsSla: TParamsNiveisSla;
begin
  if not CheckUnidadesSelecionadas then
    Exit;

  GetQueryParams;
  GetRepVars;

  try
    if not Assigned(FfrmSicsGraphicsPausas) then
    begin
      FfrmSicsGraphicsPausas := TfrmGraphicsPausas.Create(Self, IDUnidade);
    end;
    FfrmSicsGraphicsPausas.GraficoSla := False;
    FfrmSicsGraphicsPausas.ParamsSla := ParamsSla;
    MainForm.ExibeSomenteOFrame(FfrmSicsGraphicsPausas);
  except
    FreeAndNil(FfrmSicsGraphicsPausas);
    raise;
  end;
  Hide;
end;

procedure TfrmPesquisaRelatorioPausas.CancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmPesquisaRelatorioPausas.AtendsTreeViewKeyDown(Sender: TObject;
  var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  inherited;
{$IFNDEF IS_MOBILE}
  if (Key = VK_SPACE) and Assigned(TTreeView(Sender).Selected) then
    ToggleTreeViewCheckBoxes(TTreeView(Sender).Selected);
{$ENDIF IS_MOBILE}
end;

procedure TfrmPesquisaRelatorioPausas.BitBtn1Click(Sender: TObject);
begin
  if not CheckUnidadesSelecionadas then
    Exit;

  ExibirGraficoSLA;
end;

procedure TfrmPesquisaRelatorioPausas.ExibirGraficoSLA;
var
  ParamsSla: TParamsNiveisSla;
begin
  GetQueryParams;
  GetRepVars;
  TfrmSicsParamsNiveisSLA.Exibir(Self, IDUnidade,
    procedure(const Amarelo, Vermelho: integer; UltimoPerfil: Variant)
    begin
      ParamsSla.Amarelo := Amarelo;
      ParamsSla.Vermelho := Vermelho;
      try
        if not Assigned(FfrmSicsGraphicsPausas) then
        begin
          FfrmSicsGraphicsPausas := TfrmGraphicsPausas.Create(Self, IDUnidade);
        end;
        FfrmSicsGraphicsPausas.GraficoSla := True;
        FfrmSicsGraphicsPausas.ParamsSla := ParamsSla;
        MainForm.ExibeSomenteOFrame(FfrmSicsGraphicsPausas);
      except
        FreeAndNil(FfrmSicsGraphicsPausas);
        raise;
      end;
      Hide;
    end, FUltimoPerfilSLA);
end;

function TfrmPesquisaRelatorioPausas.CheckUnidadesSelecionadas: boolean;
begin
  Result := True;

  with cdsUnidades do
  begin
    First;
    while not Eof do
    begin
      if (FieldByName('SELECIONADO').AsBoolean) and (not FieldByName('CONECTADA').AsBoolean) then
      begin
        WarningMessage('Você selecionou a unidade ' + FieldByName('NOME').AsString + ', porém a mesma não está conectada neste momento.' + #13 + #10 +
        'Por favor desmarque-a antes de emitir o relatório');
        Result := False;
        Break;
      end;

      Next;
    end;
  end;
end;

procedure TfrmPesquisaRelatorioPausas.ChkDuracaoLoginChange(Sender: TObject);
begin
  inherited;
  vlChanged := True;

  EnableDisableAllControls(rectDuracaoLogin, (Sender as TCheckBox).IsChecked,
    rectTituloDuracaoLogin);
  if (Sender as TCheckBox).IsChecked then
    rbDuracaoTodosLogin.SetFocus;
end;

procedure TfrmPesquisaRelatorioPausas.dbgrdUnidadesCheckFieldClick
  (Field: TField);
begin
  if not cdsUnidades.FieldByName('CONECTADA').AsBoolean then
    Field.AsBoolean := False;
end;

procedure TfrmPesquisaRelatorioPausas.dbgrdUnidadesDrawColumnCell
  (Sender: TObject; const Canvas: TCanvas; const Column: TColumn;
const Bounds: TRectF; const Row: integer; const Value: TValue;
const State: TGridDrawStates);
begin
  inherited;
  //
end;

procedure TfrmPesquisaRelatorioPausas.dbgrdUnidadesKeyDown(Sender: TObject;
var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  inherited;
  //
end;

destructor TfrmPesquisaRelatorioPausas.Destroy;
begin
  inherited;
end;

procedure TfrmPesquisaRelatorioPausas.chkDuracaoPausaChange(Sender: TObject);
begin
  inherited;
  vlChanged := True;

  EnableDisableAllControls(rectDuracaoPausa, (Sender as TCheckBox).IsChecked,
    rectTituloDuracaoPausa);
  if (Sender as TCheckBox).IsChecked then
    rbDuracaoTodosPausa.SetFocus;
end;

constructor TfrmPesquisaRelatorioPausas.Create(AOwner: TComponent);
begin
  FfrmSicsReportPausas := nil;
  FfrmSicsGraphicsPausas := nil;
  inherited;

  FUltimoPerfilSLA := Null;
  FAtualizarTreeViewsDataSetScroll := True;
  FLimpandoTreeView := False;
  FPermiteInserirUnidades := False;

  vlChanged := False;

  IniSinceDayEdit.Text := FormatDateTime('dd', now);
  IniSinceMonthEdit.Text := FormatDateTime('mm', now);
  IniSinceYearEdit.Text := FormatDateTime('yy', now);
  IniUntilDayEdit.Text := FormatDateTime('dd', now);
  IniUntilMonthEdit.Text := FormatDateTime('mm', now);
  IniUntilYearEdit.Text := FormatDateTime('yy', now);

  edDuracaoMaiorMenorHorasPausa.Text := '00';
  edDuracaoMaiorMenorMinutosPausa.Text := '00';
  edDuracaoMaiorMenorSegundosPausa.Text := '00';
  edDuracaoDesdeHorasPausa.Text := '00';
  edDuracaoDesdeMinutosPausa.Text := '00';
  edDuracaoDesdeSegundosPausa.Text := '00';
  edDuracaoAteHorasPausa.Text := '23';
  edDuracaoAteMinutosPausa.Text := '59';
  edDuracaoAteSegundosPausa.Text := '59';

  edDuracaoMaiorMenorHorasLogin.Text := '00';
  edDuracaoMaiorMenorMinutosLogin.Text := '00';
  edDuracaoMaiorMenorSegundosLogin.Text := '00';
  edDuracaoDesdeHorasLogin.Text := '00';
  edDuracaoDesdeMinutosLogin.Text := '00';
  edDuracaoDesdeSegundosLogin.Text := '00';
  edDuracaoAteHorasLogin.Text := '23';
  edDuracaoAteMinutosLogin.Text := '59';
  edDuracaoAteSegundosLogin.Text := '59';

  rbDuracaoTodosPausa.IsChecked := True;
  rbDuracaoTodosLogin.IsChecked := True;

  DayPeriodIniHourEdit.Text := '00';
  DayPeriodIniMinuteEdit.Text := '00';
  DayPeriodUntilHourEdit.Text := '23';
  DayPeriodUntilMinuteEdit.Text := '59';
end;

end.
