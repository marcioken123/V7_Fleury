unit ufrmPesquisaRelatorioTotem;
//Renomeado unit sics_93;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  {$IFNDEF IS_MOBILE}
  Winapi.Windows,
  {$ENDIF IS_MOBILE}
  FMX.Grid, FMX.Controls, FMX.Forms, FMX.Graphics,
  FMX.StdCtrls,FMX.Types, FMX.Layouts,
  FMX.Objects, FMX.Edit, FMX.TreeView,
  System.UITypes, System.Types, System.SysUtils, System.Classes,
  System.Variants, Data.DB,
  Datasnap.DBClient, System.Rtti,

  DateUtils, Data.Bind.DBScope, ufrmPesquisaRelatorioBase,
  FMX.Controls.Presentation,
  ufrmReportTotem, ufrmGraphicsTotem,
  FireDAC.Stan.Param,

  FireDAC.Comp.Client, Data.Bind.EngExt, Fmx.Bind.DBEngExt, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.Bind.Components,
  FireDAC.Comp.DataSet, System.ImageList, FMX.ImgList, FMX.ListBox, FMX.Effects;

const
  cgMaxAtTypes    = 5;

type
  TDuracaoPorTipo = record
                      TipoDeDuracao  : TTipoDeDuracao;
                      Tempo1, Tempo2 : TDateTime;
                      Habilitado: Boolean;
                    end;  { record }

  TQueryParams = record
                    AtType                              : byte;  { 1 bit for each type from lsb }
                    DuracaoPorTipo                      :  array[1..cgMaxAtTypes] of TDuracaoPorTipo;
                    ChoosePeriodoDoRelatorio, ChooseDuracao,
                      ChooseAtds, ChoosePAs, ChoosePswd,
                      ChoosePeriodoDoDia, ChooseFilas, ChooseTags, ChooseClientes, ChooseTotens, ChooseFluxos: boolean;
                    IniPswd, EndPswd,
                      DayPeriodIniHour, DayPeriodIniMinute,
                      DayPeriodUntilHour, DayPeriodUntilMinute : integer;
                    IniSinceTime, IniUntilTime : TDateTime
                 end;  { TQueryParams }

  TfrmPesquisaRelatorioTotem = class(TfrmPesquisaRelatorioBase)
    dtsUnidades: TDataSource;
    qryAux: TFDQuery;
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
    cdsUnidadesID: TIntegerField;
    cdsUnidadesNOME: TStringField;
    cdsUnidadesATENDENTES: TDataSetField;
    cdsUnidadesPAS: TDataSetField;
    cdsUnidadesFILAS: TDataSetField;
    cdsUnidadesTAGS: TDataSetField;
    cdsUnidadesGRUPOS_ATENDENTES: TDataSetField;
    cdsUnidadesGRUPOS_PAS: TDataSetField;
    cdsUnidadesSELECIONADO: TBooleanField;
    cdsUnidadesATENDENTES_STR: TStringField;
    cdsUnidadesPAS_STR: TStringField;
    cdsUnidadesFILAS_STR: TStringField;
    cdsUnidadesTAGS_STR: TStringField;
    cdsUnidadesCONECTADA: TBooleanField;
    cdsUnidadesCARREGOU_DADOS: TBooleanField;
    bndsrcdb1: TBindSourceDB;
    pnlBotoes: TPanel;
    TotensPanel: TPanel;
    TotensLabel: TLabel;
    TotensTreeView: TTreeView;
    FluxosPanel: TPanel;
    FluxosLabel: TLabel;
    FluxosTreeView: TTreeView;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    DayPeriodUntilHourEdit: TEdit;
    DayPeriodIniMinuteEdit: TEdit;
    DayPeriodUntilMinuteEdit: TEdit;
    DayPeriodIniHourEdit: TEdit;
    DayPeriodCheckBox: TCheckBox;
    Label29: TLabel;
    Label30: TLabel;
    PasswordCheckBox: TCheckBox;
    PswdSinceEdit: TEdit;
    PswdUntilEdit: TEdit;
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
    IniPeriodCheckBox: TCheckBox;
    pnlTipo: TPanel;
    lblTipo1DoisPontos6: TLabel;
    lblTipo1DoisPontos5: TLabel;
    lblTipo1Ate: TLabel;
    lblTipo1DoisPontos4: TLabel;
    lblTipo1DoisPontos3: TLabel;
    lblTipo1DoisPontos1: TLabel;
    lblTipo1DoisPontos2: TLabel;
    edTipo1AteSegundos: TEdit;
    edTipo1AteMinutos: TEdit;
    edTipo1AteHoras: TEdit;
    edTipo1DesdeSegundos: TEdit;
    edTipo1DesdeMinutos: TEdit;
    edTipo1DesdeHoras: TEdit;
    rbTipo1Entre: TRadioButton;
    edTipo1MaiorMenorHoras: TEdit;
    edTipo1MaiorMenorMinutos: TEdit;
    edTipo1MaiorMenorSegundos: TEdit;
    rbTipo1MaiorIgual: TRadioButton;
    rbTipo1Menor: TRadioButton;
    rbTipo1Todos: TRadioButton;
    lblTipo2DoisPontos6: TLabel;
    lblTipo2DoisPontos5: TLabel;
    lblTipo2Ate: TLabel;
    lblTipo2DoisPontos4: TLabel;
    lblTipo2DoisPontos3: TLabel;
    lblTipo2DoisPontos1: TLabel;
    lblTipo2DoisPontos2: TLabel;
    edTipo2AteSegundos: TEdit;
    edTipo2AteMinutos: TEdit;
    edTipo2AteHoras: TEdit;
    edTipo2DesdeSegundos: TEdit;
    edTipo2DesdeMinutos: TEdit;
    edTipo2DesdeHoras: TEdit;
    rbTipo2Entre: TRadioButton;
    edTipo2MaiorMenorHoras: TEdit;
    edTipo2MaiorMenorMinutos: TEdit;
    edTipo2MaiorMenorSegundos: TEdit;
    rbTipo2Menor: TRadioButton;
    rbTipo2Todos: TRadioButton;
    rbTipo2MaiorIgual: TRadioButton;
    lblTipo3DoisPontos6: TLabel;
    lblTipo3DoisPontos5: TLabel;
    Label42: TLabel;
    lblTipo3DoisPontos4: TLabel;
    lblTipo3DoisPontos3: TLabel;
    lblTipo3DoisPontos1: TLabel;
    lblTipo3DoisPontos2: TLabel;
    edTipo3AteSegundos: TEdit;
    edTipo3AteMinutos: TEdit;
    edTipo3AteHoras: TEdit;
    edTipo3DesdeSegundos: TEdit;
    edTipo3DesdeMinutos: TEdit;
    edTipo3DesdeHoras: TEdit;
    rbTipo3Entre: TRadioButton;
    edTipo3MaiorMenorHoras: TEdit;
    edTipo3MaiorMenorMinutos: TEdit;
    edTipo3MaiorMenorSegundos: TEdit;
    rbTipo3Menor: TRadioButton;
    rbTipo3Todos: TRadioButton;
    rbTipo3MaiorIgual: TRadioButton;
    cbTipo1: TCheckBox;
    cbTipo2: TCheckBox;
    cbTipo3: TCheckBox;
    btnExibirGraficosTMETMA: TButton;
    btnExibirTabela: TButton;
    btnExibirGraficosSLA: TButton;
    CancelButton: TButton;
    BindSourceDB1: TBindSourceDB;
    IniPeriodPanel: TRectangle;
    rectTituloPeriodoRelatorio: TRectangle;
    IniDayPeriodPanel: TRectangle;
    Rectangle1: TRectangle;
    PswdPanel: TRectangle;
    Rectangle2: TRectangle;
    gbTipo1: TRectangle;
    rect1: TRectangle;
    gbTipo2: TRectangle;
    rect3: TRectangle;
    gbTipo3: TRectangle;
    rect4: TRectangle;
    rect2: TRectangle;
    Rectangle3: TRectangle;
    Rectangle5: TRectangle;
    Rectangle6: TRectangle;
    cdsUnidadesCLIENTES: TDataSetField;
    cdsUnidadesCLIENTES_STR: TStringField;
    ClientDataSet1TOTENS: TStringField;
    ClientDataSet1TIPOS_FLUXOS_AA: TStringField;
    cdsUnidadesTOTENS: TDataSetField;
    cdsUnidadesTIPOS_FLUXOS_AA: TDataSetField;
    cdsUnidadesTOTENS_STR: TStringField;
    cdsUnidadesTIPOS_FLUXOS_AA_STR: TStringField;
    procedure edMaiorMenorChange(Sender: TObject);
    procedure edEntreChange(Sender: TObject);
    procedure cdsUnidadesBeforeInsert(DataSet: TDataSet);
    procedure btnExibirTabelaClick(Sender: TObject);
    procedure btnExibirGraficosTMETMAClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure btnExibirGraficosSLAClick(Sender: TObject);
    procedure dbgrdUnidadesCheckFieldClick(Field: TField);
    procedure PasswordCheckBoxChange(Sender: TObject);
    procedure DayPeriodCheckBoxChange(Sender: TObject);
    procedure IniPeriodCheckBoxChange(Sender: TObject);
    procedure cbTipo1Change(Sender: TObject);
    procedure rbTipo1TodosChange(Sender: TObject);

    procedure rbMaiorMenorMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure rbEntreMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure TotensTreeViewKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure dbgrdUnidadesKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure dbgrdUnidadesDrawColumnCell(Sender: TObject;
      const Canvas: TCanvas; const Column: TColumn; const Bounds: TRectF;
      const Row: Integer; const Value: TValue; const State: TGridDrawStates);
    procedure FormResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    procedure ComponentesCallCenter;
    function PossuiConteudoEntreParentesesNaUltimaLinhaDoSQL(
      AQuery: TFDQuery): boolean;
  protected
    procedure CarregaUnidades; Override;
    procedure CarregarTreeViews; Override;
    procedure SetIDUnidade(const Value: Integer); Override;

    function CheckUnidadesSelecionadas: Boolean; Override;
    procedure GetQueryParams; Override;
    procedure GetRepVars; Override;
    procedure ExibirGraficoSLA; Override;
    procedure PosicionaUnidadeCorrente; Override;

    procedure EditarClientDataSet(const tabela: string; const Id: Integer; const Selecionado: Boolean); Override;
  public
    FfrmSicsReport: TfrmSicsReportTotem;
    FfrmSicsGraphics: TfrmSicsGraphicsTotem;
    vlRepVars : record
                   Tipos, Atendentes, PAs, Filas, Tags, Senhas, PeriodoDoRelatorio, PeriodoDoDia, Duracao, MultiUnidades, Clientes, Totens, Fluxos : string;
                   QtdeUnidadesSelecionadas: Integer;
                end;  { record RepVars }
    vlQueryParams: TQueryParams;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; Override;
    procedure MontarWhere(QryEventos: TFDQuery; var SqlInTags: string; IgnoreDuracao: Boolean); // Override;
  end;

function frmSicsPesquisaRelatorioTotem(const aIDUnidade: integer; const aAllowNewInstance: Boolean = False; const aOwner: TComponent = nil): TfrmPesquisaRelatorioTotem;

implementation

uses
  ufrmParamsGraficoSLA,
  MyAspFuncoesUteis,
  untMainForm,
  untCommonDMClient,
  untCommonDMUnidades,
  Sics_Common_Parametros;

{$R *.fmx}

const
  clAtTypesAbrev : array[0..cgMaxAtTypes - 1] of string{$IFNDEF IS_MOBILE} [4]{$ENDIF} = ('ESP','RECH','ATD', 'OCIO','LOG');

function frmSicsPesquisaRelatorioTotem(const aIDUnidade: integer; const aAllowNewInstance: Boolean = False; const aOwner: TComponent = nil): TfrmPesquisaRelatorioTotem;
begin
  Result := TfrmPesquisaRelatorioTotem(TfrmPesquisaRelatorioTotem.GetInstancia(aIDUnidade, aAllowNewInstance, aOwner));
end;

procedure TfrmPesquisaRelatorioTotem.CarregarTreeViews;
begin
  Carregar(Self,TDataSetField(cdsUnidades.FieldByName('TOTENS')).NestedDataSet, TotensTreeView, 'TOTENS');
  TotensTreeView.ExpandAll;
  //Carregar(Self,TDataSetField(cdsUnidades.FieldByName('CLIENTES')).NestedDataSet, PasTreeView   , 'CLIENTES');
  Carregar(Self,TDataSetField(cdsUnidades.FieldByName('TIPOS_FLUXOS_AA')).NestedDataSet, FluxosTreeView , 'TIPOS_FLUXOS_AA');
  FluxosTreeView.ExpandAll;
  //LM
  //Carregar(Self,TDataSetField(cdsUnidades.FieldByName('PAS'       )).NestedDataSet, PasTreeView   , 'PAS');
  //Carregar(Self,TDataSetField(cdsUnidades.FieldByName('TAGS'      )).NestedDataSet, TagsTreeView  , 'TAGS');
end;

procedure TfrmPesquisaRelatorioTotem.CarregaUnidades;
  procedure Copiar(CdsOrigem, CdsDestino: TDataSet; const CampoIdGrupo: string; CdsLkpGrupo: TDataSet; const Tabela: string);
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
            CdsDestino.FieldByName('GRUPO_ID').Value := FieldByName(CampoIdGrupo).Value;
            if CdsLkpGrupo.Locate('ID', FieldByName(CampoIdGrupo).Value, []) then
              CdsDestino.FieldByName('GRUPO_NOME').Value := CdsLkpGrupo.FieldByName('NOME').Value;
          end;
          CdsDestino.FieldByName('SELECIONADO').AsBoolean := True;

          if Tabela = 'ATENDENTES' then
          begin
            CdsDestino.FieldByName('ID_GRUPOATENDENTE').Value := FieldByName('ID_GRUPOATENDENTE').Value;
          end;

          if Tabela = 'PAS' then
          begin
            CdsDestino.FieldByName('ID_GRUPOPA').Value := FieldByName('ID_GRUPOPA').Value;
          end;

          if Tabela = 'FILAS' then
          begin
            CdsDestino.FieldByName('RANGEMINIMO').Value := FieldByName('RANGEMINIMO').Value;
            CdsDestino.FieldByName('RANGEMAXIMO').Value := FieldByName('RANGEMAXIMO').Value;
          end;

          if Tabela = 'TAGS' then
          begin
            CdsDestino.FieldByName('ID_GRUPOTAG').Value := FieldByName('ID_GRUPOTAG').Value;
            CdsDestino.FieldByName('CODIGOCOR').Value := FieldByName('CODIGOCOR').Value;
          end;

          CdsDestino.Post;
          Next;
       end;
    end;
  end;

  procedure InserirFilaNenhuma;
  begin
    with TDataSetField(cdsUnidades.FieldByName('FILAS')).NestedDataSet do
    begin
      Append;
      FieldByName('ID').AsInteger := 0;
      FieldByName('NOME').AsString := '(nenhuma)';
      FieldByName('SELECIONADO').AsBoolean := True;
      Post;
    end;
  end;

  procedure InserirTagsNenhuma;
  begin
    with TDataSetField(cdsUnidades.FieldByName('TAGS')).NestedDataSet do
    begin
      Append;
      FieldByName('ID').AsInteger := 0;
      FieldByName('NOME').AsString := '(Não classificado)';
      FieldByName('GRUPO_NOME').AsString := 'Não classificado';
      FieldByName('SELECIONADO').AsBoolean := True;
      Post;
    end;
  end;

var
  iCampo: Integer;
  sCampo: string;
  iTabela: Integer;
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

        {$REGION '//Inicializa os NestedDataSets do cdsUnidades e o cria em memória}
        if not Active then
        begin

          // preparando o dataset
          for iCampo := 1 to 9 do
          begin
            case iCampo of
              1: sCampo := 'ATENDENTES';
              2: sCampo := 'PAS';
              3: sCampo := 'FILAS';
              4: sCampo := 'TAGS';
              5: sCampo := 'GRUPOS_ATENDENTES';
              6: sCampo := 'GRUPOS_PAS';
              7: sCampo := 'CLIENTES';
              8: sCampo := 'TOTENS';
              9: sCampo := 'TIPOS_FLUXOS_AA';
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

            with FieldDefs[FieldDefs.IndexOf(sCampo)].ChildDefs.AddFieldDef do
            begin
              DataType := ftString;
              Name := 'TOTENS';
              Size := 30;
            end;

            with FieldDefs[FieldDefs.IndexOf(sCampo)].ChildDefs.AddFieldDef do
            begin
              DataType := ftString;
              Name := 'TIPOS_FLUXOS_AA';
              Size := 30;
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

            if sCampo = 'FILAS' then
            begin
              with FieldDefs[FieldDefs.IndexOf(sCampo)].ChildDefs.AddFieldDef do
              begin
                DataType := ftInteger;
                Name := 'RANGEMINIMO';
              end;
              with FieldDefs[FieldDefs.IndexOf(sCampo)].ChildDefs.AddFieldDef do
              begin
                DataType := ftInteger;
                Name := 'RANGEMAXIMO';
              end;

            end;

            if sCampo = 'TAGS' then
            begin
              with FieldDefs[FieldDefs.IndexOf(sCampo)].ChildDefs.AddFieldDef do
              begin
                DataType := ftInteger;
                Name := 'ID_GRUPOTAG';
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
        {$ENDREGION}

        dmUnidades.cdsUnidades.First;
        while not dmUnidades.cdsUnidades.Eof do
        begin

          if not Locate('ID', dmUnidades.cdsUnidades.FieldByName('ID').Value, []) then
          begin
            Append;
            FieldByName('ID').AsInteger := dmUnidades.cdsUnidades.FieldByName('ID').AsInteger;
            FieldByName('NOME').AsString := dmUnidades.cdsUnidades.FieldByName('NOME').AsString;
            FieldByName('CONECTADA').AsBoolean := dmUnidades.cdsUnidades.FieldByName('CONECTADA').AsBoolean;

            if (dmUnidades.cdsUnidades.FieldByName('CONECTADA').AsBoolean or (FieldByName('ID').AsInteger = ID_UNIDADE_PADRAO)) then
              FieldByName('SELECIONADO').AsBoolean := True;

            FieldByName('CARREGOU_DADOS').AsBoolean := False;
            Post;
          end;

          {$REGION '//Testa se a unidade está conectada via BD'}
          LConectada := False;
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
            (*
            conn := DMClient(dmUnidades.cdsUnidades.FieldByName('ID').AsInteger, not CRIAR_SE_NAO_EXISTIR).connRelatorio;
            try
              conn.Connected := True;
              FieldByName('CONECTADA').AsBoolean := True;
            except
              FieldByName('CONECTADA').AsBoolean := False;
              FieldByName('SELECIONADO').AsBoolean := False;
              Post;
              dmUnidades.cdsUnidades.Next;
              Continue;
            end;
            *)
            for iTabela := 1 to 9 do
            begin
               case iTabela of
                  1:
                  begin
                     sCampo := 'ATENDENTES';
                     sCampoGrupoId := 'id_grupoatendente';
                     sSql := 'select atd.id, atd.nome, atd.id_grupoatendente, grp.nome as grupo_nome from atendentes atd left join grupos_atendentes grp on grp.id = atd.id_grupoatendente';
                   end;
                  2:
                  begin
                     sCampo := 'PAS';
                     sCampoGrupoId := 'id_grupopa';
                     sSql := 'select pas.id, pas.nome, pas.id_grupopa, grp.nome as grupo_nome from pas left join grupos_pas grp on grp.id = pas.id_grupopa';
                  end;
                  3:
                  begin
                     sCampo := 'FILAS';
                     sCampoGrupoId := '';
                     sSql := 'select id, nome, rangeminimo, rangemaximo from filas';
                     InserirFilaNenhuma;
                  end;
                  4:
                  begin
                     sCampo := 'TAGS';
                     sCampoGrupoId := 'id_grupotag';
                     sSql := 'select tags.id, tags.nome, tags.id_grupotag, tags.codigocor, grp.nome as grupo_nome from tags left join grupos_tags grp on grp.id = tags.id_grupotag';
                     InserirTagsNenhuma;
                  end;
                  5:
                  begin
                     sCampo := 'GRUPOS_ATENDENTES';
                     sCampoGrupoId := '';
                     sSql := 'select id, nome from grupos_atendentes';
                  end;
                  6:
                  begin
                     sCampo := 'GRUPOS_PAS';
                     sCampoGrupoId := '';
                     sSql := 'select id, nome from grupos_pas';
                  end;
                  7:
                  begin
                     sCampo := 'CLIENTES';
                     sSql := 'select c.id, c.nome from clientes c';
                   end;
                  8:
                  begin
                     sCampo := 'TOTENS';
                     sSql := 'select c.id, c.nome from totens c';
                   end;
                  9:
                  begin
                     sCampo := 'TIPOS_FLUXOS_AA';
                     sSql := 'select c.id, c.nome nome from TIPOS_FLUXOS_AA c';
                   end;
               end;

               qryAux.Sql.Text := sSql;
               qryAux.Connection := conn;
               qryAux.Open;

               try
                  with TDataSetField(FieldByName(sCampo)).NestedDataSet do
                  begin
                    qryAux.First;
                     while not qryAux.Eof do
                     begin
                       Append;
                       FieldByName('ID').Value := qryAux.FieldByName('ID').Value;
                       FieldByName('NOME').Value := qryAux.FieldByName('NOME').Value;

                       if sCampoGrupoId <> '' then
                       begin
                         // depois ver pq criei dois campos com o id do grupo um com nome generico e outro com nome especifico
                         FieldByName('GRUPO_ID').Value := qryAux.FieldByName(sCampoGrupoId).Value;
                         FieldByName(sCampoGrupoId).Value := qryAux.FieldByName(sCampoGrupoId).Value;
                         FieldByName('GRUPO_NOME').Value := qryAux.FieldByName('GRUPO_NOME').Value;
                       end;

                       FieldByName('SELECIONADO').AsBoolean := True;

                       if sCampo = 'FILAS' then
                       begin
                         FieldByName('RANGEMINIMO').Value := qryAux.FieldByName('RANGEMINIMO').Value;
                         FieldByName('RANGEMAXIMO').Value := qryAux.FieldByName('RANGEMAXIMO').Value;
                       end;

                       if sCampo = 'TAGS' then
                       begin
                         FieldByName('CODIGOCOR').Value := qryAux.FieldByName('CODIGOCOR').Value;
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

procedure TfrmPesquisaRelatorioTotem.cbTipo1Change(Sender: TObject);
begin
  inherited;
  vlChanged := true;
  EnableDisableAllControls(FindComponent('gbTipo'+inttostr((Sender as TCheckBox).Tag)) as TControl, (Sender as TCheckBox).IsChecked, ((sender as TCheckBox).Parent as TRectangle));
end;

procedure TfrmPesquisaRelatorioTotem.edMaiorMenorChange(Sender: TObject);
begin
  vlChanged := true;

  if (((FindComponent('rbTipo'+inttostr((Sender as TEdit).Tag)+'Menor') as TRadioButton).IsChecked = false) and
      ((FindComponent('rbTipo'+inttostr((Sender as TEdit).Tag)+'MaiorIgual') as TRadioButton).IsChecked = false))  then
    (FindComponent('rbTipo'+inttostr((Sender as TEdit).Tag)+'Menor') as TRadioButton).IsChecked := true;
end;  { proc edMaiorMenorChange }

procedure TfrmPesquisaRelatorioTotem.edEntreChange(Sender: TObject);
begin
  vlChanged := true;
  (FindComponent('rbTipo'+inttostr((Sender as TEdit).Tag)+'Entre') as TRadioButton).IsChecked := true;
end;

procedure TfrmPesquisaRelatorioTotem.EditarClientDataSet(const tabela: string;
  const Id: Integer; const Selecionado: Boolean);
var
  sCampo: string;
begin
  if FLimpandoTreeView then Exit;

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

procedure TfrmPesquisaRelatorioTotem.rbEntreMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  inherited;
   vlChanged := true;
  (FindComponent('edTipo'+inttostr((Sender as TRadioButton).Tag)+'DesdeHoras') as TEdit).SetFocus;
end;

procedure TfrmPesquisaRelatorioTotem.rbMaiorMenorMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  vlChanged := true;
  (FindComponent('edTipo'+inttostr((Sender as TRadioButton).Tag)+'MaiorMenorHoras') as TEdit).SetFocus;
end;

procedure TfrmPesquisaRelatorioTotem.rbTipo1TodosChange(Sender: TObject);
begin
  inherited;
   vlChanged := true;
end;

procedure TfrmPesquisaRelatorioTotem.SetIDUnidade(const Value: Integer);
begin
  if (IDUnidade <> Value) then
  begin
    inherited;
    FreeAndNil(FfrmSicsReport);
    FreeAndNil(FfrmSicsGraphics);
  end;
end;

procedure TfrmPesquisaRelatorioTotem.IniPeriodCheckBoxChange(Sender: TObject);
begin
  inherited;
  vlChanged := true;

  EnableDisableAllControls(IniPeriodPanel, IniPeriodCheckBox.IsChecked, rectTituloPeriodoRelatorio);

  if IniPeriodCheckBox.IsChecked then
    IniSinceDayEdit.SetFocus;
end;

procedure TfrmPesquisaRelatorioTotem.DayPeriodCheckBoxChange(Sender: TObject);
begin
  inherited;
   vlChanged := true;

   Label9.Enabled  := DayPeriodCheckBox.IsChecked;
   Label10.Enabled := DayPeriodCheckBox.IsChecked;
   Label11.Enabled := DayPeriodCheckBox.IsChecked;
   Label12.Enabled := DayPeriodCheckBox.IsChecked;
   DayPeriodIniHourEdit.Enabled     := DayPeriodCheckBox.IsChecked;
   DayPeriodIniMinuteEdit.Enabled   := DayPeriodCheckBox.IsChecked;
   DayPeriodUntilHourEdit.Enabled   := DayPeriodCheckBox.IsChecked;
   DayPeriodUntilMinuteEdit.Enabled := DayPeriodCheckBox.IsChecked;

   if DayPeriodCheckBox.IsChecked then
      DayPeriodIniHourEdit.SetFocus;
end;

procedure TfrmPesquisaRelatorioTotem.PasswordCheckBoxChange(Sender: TObject);
begin
  inherited;
   vlChanged := true;

   Label29.Enabled := PasswordCheckBox.IsChecked;
   Label30.Enabled := PasswordCheckBox.IsChecked;
   PswdSinceEdit.Enabled := PasswordCheckBox.IsChecked;
   PswdUntilEdit.Enabled := PasswordCheckBox.IsChecked;

   if PasswordCheckBox.IsChecked then
   begin
      PswdSinceEdit.SetFocus;
      PswdSinceEdit.FontColor := claWindowText;
      PswdUntilEdit.FontColor := claWindowText;
   end
   else
   begin
      PswdSinceEdit.FontColor := claGrayText;
      PswdUntilEdit.FontColor := claGrayText;
   end;  { else }
end;

procedure TfrmPesquisaRelatorioTotem.PosicionaUnidadeCorrente;
begin
  inherited;
end;

procedure TfrmPesquisaRelatorioTotem.GetQueryParams;
var
  i, iDetalhes, iTotalRec : integer;
  sCampoDetalhe : string;
  bTodos: Boolean;
  LDataSetTmp: TClientDataSet;
begin
    vlChanged := false;

    with vlQueryParams do
    begin
       AtType := 0;
       ChoosePeriodoDoRelatorio := false;
       ChooseDuracao            := false;
       ChoosePeriodoDoDia       := false;
       ChooseAtds               := false;
       ChoosePAs                := false;
       ChoosePswd               := false;
       IniPswd                  := 0;
       EndPswd                  := 0;
       IniSinceTime             := 0;
       IniUntilTime             := 0;
       DayPeriodIniHour         := 0;
       DayPeriodIniMinute       := 0;
       DayPeriodUntilHour       := 0;
       DayPeriodUntilMinute     := 0;

       for i := 1 to cgMaxAtTypes do
       begin
         if (FindComponent('cbTipo'+inttostr(i))) <> nil then
         begin
           if (FindComponent('cbTipo'+inttostr(i)) as TCheckBox).IsChecked then
           begin
             DuracaoPorTipo[i].Habilitado := True;

             AtType := AtType or (Eleva(2,i-1));   { marca o bit relativo a i: (ex: i = 1 => AtType := 255 - #00000001b) }

             if (FindComponent('rbTipo'+inttostr(i)+'Todos') as TRadioButton).IsChecked then
             begin
               DuracaoPorTipo[i].TipoDeDuracao := tdTodos;
               DuracaoPorTipo[i].Tempo1 := 0;
               DuracaoPorTipo[i].Tempo2 := 0;
             end
             else if (FindComponent('rbTipo'+inttostr(i)+'Menor') as TRadioButton).IsChecked then
             begin
               DuracaoPorTipo[i].TipoDeDuracao := tdMenor;
               DuracaoPorTipo[i].Tempo1 := EncodeTime (strtoint((FindComponent('edTipo'+inttostr(i)+'MaiorMenorHoras'   ) as TEdit).Text),
                                                       strtoint((FindComponent('edTipo'+inttostr(i)+'MaiorMenorMinutos' ) as TEdit).Text),
                                                       strtoint((FindComponent('edTipo'+inttostr(i)+'MaiorMenorSegundos') as TEdit).Text), 0);
               DuracaoPorTipo[i].Tempo2 := 0;
               ChooseDuracao := true;
             end
             else if (FindComponent('rbTipo'+inttostr(i)+'MaiorIgual') as TRadioButton).IsChecked then
             begin
               DuracaoPorTipo[i].TipoDeDuracao := tdMaiorIgual;
               DuracaoPorTipo[i].Tempo1 := EncodeTime (strtoint((FindComponent('edTipo'+inttostr(i)+'MaiorMenorHoras'   ) as TEdit).Text),
                                                       strtoint((FindComponent('edTipo'+inttostr(i)+'MaiorMenorMinutos' ) as TEdit).Text),
                                                       strtoint((FindComponent('edTipo'+inttostr(i)+'MaiorMenorSegundos') as TEdit).Text), 0);
               DuracaoPorTipo[i].Tempo2 := 0;
               ChooseDuracao := true;
             end
             else if (FindComponent('rbTipo'+inttostr(i)+'Entre') as TRadioButton).IsChecked then
             begin
               DuracaoPorTipo[i].TipoDeDuracao := tdEntre;
               DuracaoPorTipo[i].Tempo1 := EncodeTime (strtoint((FindComponent('edTipo'+inttostr(i)+'DesdeHoras'   ) as TEdit).Text),
                                                       strtoint((FindComponent('edTipo'+inttostr(i)+'DesdeMinutos' ) as TEdit).Text),
                                                       strtoint((FindComponent('edTipo'+inttostr(i)+'DesdeSegundos') as TEdit).Text), 0);
               DuracaoPorTipo[i].Tempo2 := EncodeTime (strtoint((FindComponent('edTipo'+inttostr(i)+'AteHoras'     ) as TEdit).Text),
                                                       strtoint((FindComponent('edTipo'+inttostr(i)+'AteMinutos'   ) as TEdit).Text),
                                                       strtoint((FindComponent('edTipo'+inttostr(i)+'AteSegundos'  ) as TEdit).Text), 999);
               ChooseDuracao := true;
             end
           end
           else
           begin
            ChooseDuracao := true;
            DuracaoPorTipo[i].Habilitado := False;
           end;
         end
       end;

       if IniPeriodCheckBox.IsChecked then
       begin
          ChoosePeriodoDoRelatorio := true;

          IniSinceTime := EncodeDate (2000+strtoint(IniSinceYearEdit.Text),
                                      strtoint(IniSinceMonthEdit.Text), strtoint(IniSinceDayEdit.Text)) +
                          EncodeTime (0, 0, 0, 0);

          IniUntilTime := EncodeDate (2000+strtoint(IniUntilYearEdit.Text),
                                      strtoint(IniUntilMonthEdit.Text), strtoint(IniUntilDayEdit.Text)) +
                          EncodeTime (23, 59, 59, 999);
       end;

       if DayPeriodCheckBox.IsChecked then
       begin
          ChoosePeriodoDoDia := true;
          DayPeriodIniHour := strtoint(DayPeriodIniHourEdit.Text);
          DayPeriodIniMinute := strtoint(DayPeriodIniMinuteEdit.Text);
          DayPeriodUntilHour := strtoint(DayPeriodUntilHourEdit.Text);
          DayPeriodUntilMinute := strtoint(DayPeriodUntilMinuteEdit.Text);
       end;

       LDataSetTmp := TClientDataSet.Create(nil);

       try
         for iDetalhes := 1 to 7 do
         begin
           case iDetalhes of
             1: sCampoDetalhe := 'ATENDENTES';
             2: sCampoDetalhe := 'PAS';
             3: sCampoDetalhe := 'FILAS';
             4: sCampoDetalhe := 'TAGS';
             5: sCampoDetalhe := 'CLIENTES';
             6: sCampoDetalhe := 'TOTENS';
             7: sCampoDetalhe := 'TIPOS_FLUXOS_AA';
           end;

           LDataSetTmp.DataSetField := TDataSetField(cdsUnidades.FieldByName(sCampoDetalhe));
           iTotalRec := LDataSetTmp.RecordCount;
           LDataSetTmp.Filter := 'SELECIONADO=TRUE';
           LDataSetTmp.Filtered := True;

           try
             bTodos := LDataSetTmp.RecordCount = iTotalRec;
           finally
             LDataSetTmp.Filtered := False;
           end;

           case iDetalhes of
             1: ChooseAtds      := not bTodos;
             2: ChoosePas       := not bTodos;
             3: ChooseFilas     := not bTodos;
             4: ChooseTags      := not bTodos;
             5: ChooseClientes  := not bTodos;
             6: ChooseTotens    := not bTodos;
             7: ChooseFluxos    := not bTodos;
           end;
         end;
       finally
         FreeAndNil(LDataSetTmp);
       end;

       if PasswordCheckBox.IsChecked then
       begin
          ChoosePswd := true;
          IniPswd := StrToInt(PswdSinceEdit.Text);
          EndPswd := StrToInt(PswdUntilEdit.Text);
       end;
    end;
end;  { func GetQueryParams }

procedure TfrmPesquisaRelatorioTotem.MontarWhere(QryEventos: TFDQuery; var SqlInTags: string; IgnoreDuracao: Boolean);

  procedure ExtractComma (var s :string);
  var
     i : integer;
  begin
     for i := 1 to length(s) do
        if s[i] = ',' then s[i] := '.';
  end;  { procedure ExtractComma }

  function ExtractAND (const s : string) : string;
  begin
     ExtractAND := Copy(s, 1, length(s)-3);
  end;  { procedure ExtractAND }

var
   s, sIn, sCampoOrigem, sCampoWhere : string;
   i                                 : integer;
   iDetalhes              : integer;
//   t1                                : TDateTime;
   sOldIndexFieldNames     : string;
   iTotalRec                         : Integer;
   bTodos,bTbNenhum                  : Boolean;
  LDataSetTmp: TClientDataSet;
begin
  SqlInTags := '';

  if ((vlQueryParams.ChoosePeriodoDoRelatorio = false) and
      ((vlQueryParams.ChooseDuracao = false) or (IgnoreDuracao)) and (vlQueryParams.ChoosePswd = false) and
      (vlQueryParams.ChooseAtds = false) and (vlQueryParams.ChoosePAs = false) and
      (vlQueryParams.ChooseFilas = false) and (vlQueryParams.ChooseTags = false) and
      (vlQueryParams.ChoosePeriodoDoDia = false) and (vlQueryParams.ChooseClientes = false) and
      (vlQueryParams.ChooseFluxos = false) and ((vlQueryParams.ChooseTotens = false))) then
  begin
    qryEventos.SQL.Delete(qryEventos.SQL.Count - 1);
  end
  else if (vlQueryParams.AtType = 0) then
  begin
    WarningMessage('Selecione pelo menos um tipo de registro para filtro');
    Abort;
  end
  else
  begin
     if vlQueryParams.ChoosePeriodoDoRelatorio then
     begin
        s := '((AA.INICIO >= :IniSinceTime )and(AA.INICIO <= :IniUntilTime ))and';
        ExtractComma (s);
        qryEventos.Sql.Add (s);
     end;  { if ChoosePeriodoDoRelatorio }

     if vlQueryParams.ChoosePswd then
     begin
        s := '((S.NUMEROTICKET>=' + inttostr(vlQueryParams.IniPswd) + ')and' +
             '(S.NUMEROTICKET<=' + inttostr(vlQueryParams.EndPswd) + '))and';
        ExtractComma (s);
        qryEventos.Sql.Add (s);
     end;  { if ChoosePswd }

     if vlQueryParams.ChoosePeriodoDoDia then
     begin
       if (vlQueryParams.DayPeriodIniHour) = (vlQueryParams.DayPeriodUntilHour) then  { EXEMPLO: 10:02 ~ 10:38 => [H=10] & [2<=M<=38] }
         s := '((({extract(hour, AA.INICIO)} = ' + IntToStr(vlQueryParams.DayPeriodIniHour) + ')'      + ' and ' +
              '({extract(minute, AA.INICIO)} between ' + IntToStr(vlQueryParams.DayPeriodIniMinute)   + ' and ' +
                                                         IntToStr(vlQueryParams.DayPeriodUntilMinute) + '))) and'
       else   { EXEMPLO:  10:50 ~ 13:30 => [H=10 & M>=50] + [H=13 & M<=30] + [10+1<=H<=13-1] }
         s := '((({extract(hour, AA.INICIO)} = '    + IntToStr(vlQueryParams.DayPeriodIniHour)    + ') and ' +
                '({extract(minute, AA.INICIO)} >= ' + IntToStr(vlQueryParams.DayPeriodIniMinute)  + ')    )  or ' +

               '(({extract(hour, AA.INICIO)} = '    + IntToStr(vlQueryParams.DayPeriodUntilHour)   + ') and ' +
                '({extract(minute, AA.INICIO)} <= ' + IntToStr(vlQueryParams.DayPeriodUntilMinute) + ')    ) or ' +

               '({extract(hour, AA.INICIO)} between ' + IntToStr(vlQueryParams.DayPeriodIniHour+1) +' and '+ IntToStr(vlQueryParams.DayPeriodUntilHour-1) + '))and';

//         s := '(CAST({extract(hour, INICIO)}AS INTEGER) between 13 and 16)';
//         s := '  ';
//       if (vlQueryParams.DayPeriodIniHour) = (vlQueryParams.DayPeriodUntilHour) then  { EXEMPLO: 10:02 ~ 10:38 => [H=10] & [2<=M<=38] }
//         s := '(((extract(hour from INICIO) = ' + IntToStr(vlQueryParams.DayPeriodIniHour) + ')'      + ' and ' +
//              '(extract(minute from INICIO) between ' + IntToStr(vlQueryParams.DayPeriodIniMinute)   + ' and ' +
//                                                         IntToStr(vlQueryParams.DayPeriodUntilMinute) + '))) and'
//       else   { EXEMPLO:  10:50 ~ 13:30 => [H=10 & M>=50] + [H=13 & M<=30] + [10+1<=H<=13-1] }
//         s := '(((extract(hour from INICIO) = '    + IntToStr(vlQueryParams.DayPeriodIniHour)    + ') and ' +
//                '(extract(minute from INICIO) >= ' + IntToStr(vlQueryParams.DayPeriodIniMinute)  + ')    )  or ' +
//
//               '((extract(hour from INICIO) = '    + IntToStr(vlQueryParams.DayPeriodUntilHour)   + ') and ' +
//                '(extract(minute from INICIO) <= ' + IntToStr(vlQueryParams.DayPeriodUntilMinute) + ')    ) or ' +
//
//               '(extract(hour from INICIO) between ' + IntToStr(vlQueryParams.DayPeriodIniHour+1) +' and '+ IntToStr(vlQueryParams.DayPeriodUntilHour-1) + '))and';

       //Ver Kelver verificar se tem numero antes e depois para aplicar...
       //ExtractComma(s);
       qryEventos.SQL.Add(s);
     end;  { if ChoosePeriodoDoDia }

     for iDetalhes := 1 to 7 do
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
           sCampoOrigem := 'FILAS';
           sCampoWhere := 'E.ID_FILAESPERA';
         end;
         4:
         begin
           sCampoOrigem := 'TAGS';
           sCampoWhere := '';
         end;
         5:
         begin
           sCampoOrigem := 'CLIENTES';
           sCampoWhere := 'C.ID';
         end;
         6:
         begin
           sCampoOrigem := 'TOTENS';
           sCampoWhere := 'AA.ID_TOTEM';
         end;
         7:
         begin
           sCampoOrigem := 'TIPOS_FLUXOS_AA';
           sCampoWhere := 'AA.ID_TIPOFLUXO';
         end;
       end;

       sIn := '';
       LDataSetTmp := TClientDataSet.Create(nil);

       try
         LDataSetTmp.DataSetField := TDataSetField(Self.cdsUnidades.FieldByName(sCampoOrigem));

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
                   if sIn <> '' then sIn := sIn + ',';
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
           begin
             if sCampoOrigem <> 'TAGS' then
              s := s + sCampoWhere + ' is null'
             else
              s := s + 'not exists (select id_ticket from nn_tickets_tags where nn_tickets_tags.id_ticket = e.id_ticket)';
           end;

           if sIn <> '' then
           begin
             if bTbNenhum then
              s := s + ' or ';

             if sCampoOrigem <> 'TAGS' then
               s := s + sCampoWhere + ' in (' + sIn + ')'
             else
             begin
               SqlInTags := sIn;
               s := s + 'exists (select id_ticket from nn_tickets_tags where nn_tickets_tags.id_ticket = e.id_ticket and nn_tickets_tags.id_tag in (' + sIn + '))';
             end;
           end;
           s := s + ')and';

           qryEventos.Sql.Add (s);
         end;
       finally
         FreeAndNil(LDataSetTmp);
       end;
     end;

     if (((vlQueryParams.ChooseDuracao))) then
     begin
       s := '(';
       for i := 1 to cgMaxAtTypes do
       begin
         if ((vlQueryParams.AtType and Eleva(2,i-1)) <> 0) then
         begin
           if vlQueryParams.DuracaoPorTipo[i].Habilitado then
           begin
             if IgnoreDuracao then
              s := s + ' '
             else
             begin
               case vlQueryParams.DuracaoPorTipo[i].TipoDeDuracao of
                 tdTodos      : s := s + ' ';
                 tdMenor      : s := s + '((AA.DURACAO_SEGUNDOS < :Tempo1'+inttostr(i)+'))or';
                 tdMaiorIgual : s := s + '((AA.DURACAO_SEGUNDOS >= :Tempo1'+inttostr(i)+'))or';
                 tdEntre      : s := s + '((AA.DURACAO_SEGUNDOS >= :Tempo1'+inttostr(i)+')and(AA.DURACAO_SEGUNDOS <= :Tempo2'+inttostr(i)+'))or';
               end; { case }
             end;
           end;
         end;
       end;

       s := Copy (s, 1, Length(s)-2);
       s := s + ')and';
       qryEventos.Sql.Add(s);
     end;

     s := ExtractAND (qryEventos.Sql.Strings[qryEventos.Sql.Count - 1]);
     s := s + ')';
     qryEventos.Sql.Delete (qryEventos.Sql.Count - 1);
     qryEventos.Sql.Add (s);

     if not PossuiConteudoEntreParentesesNaUltimaLinhaDoSQL(qryEventos) then
       qryEventos.Sql.Delete (qryEventos.Sql.Count - 1);
  end;  { else }

  if vlQueryParams.ChoosePeriodoDoRelatorio then
  begin
    qryEventos.Params.ParamByName('IniSinceTime').DataType := ftDateTime;
    qryEventos.Params.ParamByName('IniUntilTime').DataType := ftDateTime;
    qryEventos.Params.ParamByName('IniSinceTime').AsDateTime := vlQueryParams.IniSinceTime;
    qryEventos.Params.ParamByName('IniUntilTime').AsDateTime := vlQueryParams.IniUntilTime;
  end;  { if ChoosePeriodoDoRelatorio }

  if not IgnoreDuracao then
  begin
    for i := 1 to cgMaxAtTypes do
    begin
      if ((vlQueryParams.AtType and Eleva(2,i-1)) <> 0) then
        case vlQueryParams.DuracaoPorTipo[i].TipoDeDuracao of
          tdMenor, tdMaiorIgual : begin
                                    qryEventos.Params.ParamByName('Tempo1'+inttostr(i)).DataType := ftInteger;
                                    qryEventos.Params.ParamByName('Tempo1'+inttostr(i)).AsInteger := SecondsBetween(0, vlQueryParams.DuracaoPorTipo[i].Tempo1);
                                  end;
          tdEntre               : begin
                                    qryEventos.Params.ParamByName('Tempo1'+inttostr(i)).DataType := ftInteger;
                                    qryEventos.Params.ParamByName('Tempo2'+inttostr(i)).DataType := ftInteger;
                                    qryEventos.Params.ParamByName('Tempo1'+inttostr(i)).AsInteger := SecondsBetween(0, vlQueryParams.DuracaoPorTipo[i].Tempo1);
                                    qryEventos.Params.ParamByName('Tempo2'+inttostr(i)).AsInteger := SecondsBetween(0, vlQueryParams.DuracaoPorTipo[i].Tempo2);
                                  end;
        end;  { case }
    end;
  end;
end;

function TfrmPesquisaRelatorioTotem.PossuiConteudoEntreParentesesNaUltimaLinhaDoSQL(AQuery: TFDQuery): boolean;
var
  LUltimaLinha: String;
  LPosEsquerda, LPosDireita: Integer;
begin
  LUltimaLinha := AQuery.SQL[ AQuery.SQL.Count-1 ];
  LPosEsquerda := Pos('(', LUltimaLinha);
  LPosDireita  := Pos(')', LUltimaLinha);
  result := Trim(Copy(LUltimaLinha, LPosEsquerda+1, LPosDireita-LPosEsquerda-1)) <> EmptyStr;
end;

procedure TfrmPesquisaRelatorioTotem.cdsUnidadesBeforeInsert(DataSet: TDataSet);
begin
   if not FPermiteInserirUnidades then Abort;
end;

procedure TfrmPesquisaRelatorioTotem.GetRepVars;
var
  i, iDetalhes, iTotalRec: Integer;
  bAtdsDivergente, bPAsDivergente, bFilasDivergente, bTagsDivergente, bTodos, bTbNenhum, bClientesDivergente: Boolean;
  sAtdsBase, sPAsBase, sFilasBase, sTagsBase, sIds, sCampoOrigem, sOldIndexFieldNames, sIdsTemp, sClientesBase, sTotens, sFluxos: string;
  ArrIds: TIntegerDynArray;
  bOldAtualizarTreeViewsDataSetScroll: Boolean;
  LDataSetTmp: TClientDataSet;
begin
  bOldAtualizarTreeViewsDataSetScroll := FAtualizarTreeViewsDataSetScroll;
  FAtualizarTreeViewsDataSetScroll := False;

  try
     for iDetalhes := 1 to 7 do
     begin
       case iDetalhes of
         1:
         begin
           sCampoOrigem := 'ATENDENTES';
         end;
         2:
         begin
           sCampoOrigem := 'PAS';
         end;
         3:
         begin
           sCampoOrigem := 'FILAS';
         end;
         4:
         begin
           sCampoOrigem := 'TAGS';
         end;
         5:
         begin
           sCampoOrigem := 'CLIENTES';
         end;
         6:
         begin
           sCampoOrigem := 'TOTENS';
         end;
         7:
         begin
           sCampoOrigem := 'TIPOS_FLUXOS_AA';
         end;
       end;

       sIds := '';
       LDataSetTmp := TClientDataSet.Create(nil);

       try
         LDataSetTmp.DataSetField := TDataSetField(cdsUnidades.FieldByName(sCampoOrigem));

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
                   if sIds <> '' then sIds := sIds + ',';
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
           StrToIntArray(StringReplace(sIds, ',', ';', [rfReplaceAll, rfIgnoreCase]), ArrIds);
           IntArrayToStr(ArrIds, sIdsTemp);

           if bTbNenhum then
             if sIdsTemp = '' then
               sIdsTemp := 'Nenhuma'
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
        Tipos              := 'Todos';
        Atendentes         := 'Todos';
        PAs                := 'Todas';
        Filas              := 'Todas';
        Tags               := 'Todas';
        Senhas             := 'Todas';
        Clientes           := 'Todos';
        PeriodoDoRelatorio := '---';
        PeriodoDoDia       := '---';
        Duracao            := '---';
        MultiUnidades      := '';
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
                if MultiUnidades <> '' then MultiUnidades := MultiUnidades + ', ';
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
            Atendentes := cdsUnidades.FieldByName('ATENDENTES_STR').AsString;
            PAs        := cdsUnidades.FieldByName('PAS_STR').AsString;
            Filas      := cdsUnidades.FieldByName('FILAS_STR').AsString;
            Tags       := cdsUnidades.FieldByName('TAGS_STR').AsString;
            Clientes   := cdsUnidades.FieldByName('CLIENTES_STR').AsString;
            Totens     := cdsUnidades.FieldByName('TOTENS_STR').AsString;
            Fluxos     := cdsUnidades.FieldByName('TIPOS_FLUXOS_AA_STR').AsString;
          end;
        end
        else
        begin
          bAtdsDivergente := False;
          bPAsDivergente := False;
          bFilasDivergente := False;
          bTagsDivergente := False;

          with cdsUnidades do
          begin
            First;
            sAtdsBase := FieldByName('ATENDENTES_STR').AsString;
            sPAsBase := FieldByName('PAS_STR').AsString;
            sFilasBase := FieldByName('FILAS_STR').AsString;
            sTagsBase := FieldByName('TAGS_STR').AsString;
            sClientesBase := FieldByName('CLIENTES_STR').AsString;

            while not Eof do
            begin
              if FieldByName('ATENDENTES_STR').AsString <> sAtdsBase then bAtdsDivergente := True;
              if FieldByName('PAS_STR').AsString <> sPAsBase then bPAsDivergente := True;
              if FieldByName('FILAS_STR').AsString <> sFilasBase then bFilasDivergente := True;
              if FieldByName('TAGS_STR').AsString <> sTagsBase then bTagsDivergente := True;
              if FieldByName('CLIENTES_STR').AsString <> sClientesBase then bClientesDivergente := True;
              Next;
            end;
          end;

          if bAtdsDivergente then
            Atendentes := 'Conforme Unidade'
          else
            Atendentes := sAtdsBase;
          if bPAsDivergente then
            PAs := 'Conforme Unidade'
          else
            PAs := sPAsBase;
          if bFilasDivergente then
            Filas := 'Conforme Unidade'
          else
            Filas := sFilasBase;
          if bTagsDivergente then
            Tags := 'Conforme Unidade'
          else
          if bClientesDivergente then
            Clientes := 'Conforme Unidade'
          else
            Tags := sTagsBase;
        end;

        if vlQueryParams.ChoosePeriodoDoRelatorio then
        begin
           PeriodoDoRelatorio := FormatDateTime ('dd/mm/yy', vlQueryParams.IniSinceTime) + ' a ' +
                                 FormatDateTime ('dd/mm/yy', vlQueryParams.IniUntilTime);
        end;  { if ChoosePeriodoDoRelatorio }

        if vlQueryParams.ChoosePeriodoDoDia then
        begin
           PeriodoDoDia := FormatNumber (2, vlQueryParams.DayPeriodIniHour  ) + ':' + FormatNumber (2, vlQueryParams.DayPeriodIniMinute  ) + ' a ' +
                           FormatNumber (2, vlQueryParams.DayPeriodUntilHour) + ':' + FormatNumber (2, vlQueryParams.DayPeriodUntilMinute) ;
        end;  { if ChooseDuracao }

        if vlQueryParams.ChoosePswd then
        begin
           Senhas := inttostr(vlQueryParams.IniPswd) + ' a ' +
                     inttostr(vlQueryParams.EndPswd);
        end;  { if ChoosePswd }

        if ((vlQueryParams.AtType <> 255) or (vlQueryParams.ChooseDuracao)) then
        begin
           Tipos := '';
           for i := 1 to cgMaxAtTypes do
           begin
             if ((vlQueryParams.AtType and Eleva(2,i-1)) <> 0) then
             begin
               case vlQueryParams.DuracaoPorTipo[i].TipoDeDuracao of
                 tdTodos      : Tipos := Tipos + String(clAtTypesAbrev[i-1]) + '; ';
                 tdMenor      : Tipos := Tipos + String(clAtTypesAbrev[i-1]) + ': <' + FormatTimeComAspas(vlQueryParams.DuracaoPorTipo[i].Tempo1) + '; ';
                 tdMaiorIgual : Tipos := Tipos + String(clAtTypesAbrev[i-1]) + ': >='+ FormatTimeComAspas(vlQueryParams.DuracaoPorTipo[i].Tempo1) + '; ';
                 tdEntre      : Tipos := Tipos + String(clAtTypesAbrev[i-1]) + ': ' + FormatTimeComAspas(vlQueryParams.DuracaoPorTipo[i].Tempo1) + ' a ' + FormatTimeComAspas(vlQueryParams.DuracaoPorTipo[i].Tempo2) + '; ';
               end; { case }
             end;
           end;

           Tipos := Copy (Tipos, 1, length(tipos) - 2);
           Duracao := Tipos;
        end;  { if AtType <> 255 }
     end;  { with RepVars }

  finally
    FAtualizarTreeViewsDataSetScroll := bOldAtualizarTreeViewsDataSetScroll;
  end;
end;

procedure TfrmPesquisaRelatorioTotem.btnExibirTabelaClick(Sender: TObject);
begin
  GetQueryParams;
  GetRepVars;

  try
    if not Assigned(FfrmSicsReport) then
    begin
      FfrmSicsReport := TfrmSicsReportTotem.Create(Self, IDUnidade);
    end;

    Hide;
    MainForm.ExibeSomenteOFrame(FfrmSicsReport);
  except
    FreeAndNil(FfrmSicsReport);
    raise;
  end;
end;

procedure TfrmPesquisaRelatorioTotem.btnExibirGraficosTMETMAClick(Sender: TObject);
var
  ParamsSla: TParamsSla;
begin
  if not CheckUnidadesSelecionadas then
    Exit;

  GetQueryParams;
  GetRepVars;

  try
    if not Assigned(FfrmSicsGraphics) then
    begin
      FfrmSicsGraphics := TfrmSicsGraphicsTotem.Create(Self, IDUnidade);
    end;

    FfrmSicsGraphics.GraficoSla := False;
    FfrmSicsGraphics.ParamsSla := ParamsSla;
    Hide;
    MainForm.ExibeSomenteOFrame(FfrmSicsGraphics);
  except
    FreeAndNil(FfrmSicsGraphics);
    raise;
  end;
end;

procedure TfrmPesquisaRelatorioTotem.CancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmPesquisaRelatorioTotem.TotensTreeViewKeyDown(Sender: TObject;
  var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  inherited;

  {$IFNDEF IS_MOBILE}
  if (Key = VK_SPACE) and Assigned(TTreeView(Sender).Selected) then
    ToggleTreeViewCheckBoxes(TTreeView(Sender).Selected);
  {$ENDIF IS_MOBILE}
end;

procedure TfrmPesquisaRelatorioTotem.btnExibirGraficosSLAClick(Sender: TObject);
begin
  if CheckUnidadesSelecionadas then
    ExibirGraficoSLA;
end;

procedure TfrmPesquisaRelatorioTotem.ExibirGraficoSLA;
begin
  if (not cbTipo1.IsChecked) and (not cbTipo3.IsChecked) then
  begin
    InformationMessage('Selecione uma opção de filtro (Atendimento / Espera)');
    Exit;
  end;

  GetQueryParams;
  GetRepVars;

  TfrmSicsParamsGraficoSLA.Exibir(Self, IDUnidade,
    procedure (EspAmarelo, EspVermelho, AtdAmarelo, AtdVermelho: Integer; UltimoPerfil: Variant)
    var
      ParamsSla: TParamsSla;
    begin
      ParamsSla.EspAmarelo := EspAmarelo;
      ParamsSla.EspVermelho := EspVermelho;
      ParamsSla.AtdAmarelo := AtdAmarelo;
      ParamsSla.AtdVermelho := AtdVermelho;

      try
        if not Assigned(FfrmSicsGraphics) then
        begin
          FfrmSicsGraphics := TfrmSicsGraphicsTotem.Create(Self, IDUnidade);
        end;

        FfrmSicsGraphics.GraficoSla := True;
        FfrmSicsGraphics.ParamsSla := ParamsSla;

        Hide;

        MainForm.ExibeSomenteOFrame(FfrmSicsGraphics);
      except
        FreeAndNil(FfrmSicsGraphics);
        raise;
      end;
    end, FUltimoPerfilSLA);
end;

procedure TfrmPesquisaRelatorioTotem.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  SalvaSituacaoTreeView(Self, TotensTreeView);
  //SalvaSituacaoTreeView(Self,PAsTreeView);
  SalvaSituacaoTreeView(Self, FluxosTreeView);
  //SalvaSituacaoTreeView(Self,TagsTreeView);
end;

procedure TfrmPesquisaRelatorioTotem.FormCreate(Sender: TObject);
begin
  inherited;
  if vgParametrosModulo.ModoCallCenter then
    ComponentesCallCenter;
end;

procedure TfrmPesquisaRelatorioTotem.FormResize(Sender: TObject);
const
  OFF = 20;
begin
  inherited;
  IniPeriodPanel.Position.X      := OFF;
  IniPeriodPanel.Position.Y      := OFF;

  pnlTipo.Position.X             := OFF;
  pnlTipo.Position.Y             := IniPeriodPanel.Position.Y + IniPeriodPanel.Height + OFF;

  pnlUnidades.Position.X         := OFF;
  pnlUnidades.Position.Y         := pnlTipo.Position.Y + pnlTipo.Height + OFF;
  pnlUnidades.Height             := ClientHeight - pnlUnidades.Position.Y - pnlBotoes.Height - OFF;

  IniDayPeriodPanel.Position.X   := IniPeriodPanel.Position.X + IniPeriodPanel.Width + OFF;
  IniDayPeriodPanel.Position.Y   := OFF;
  IniDayPeriodPanel.Width        := (Trunc((Width - IniPeriodPanel.Width - 4*OFF)) div 2);

  PswdPanel.Position.X           := IniDayPeriodPanel.Position.X + IniDayPeriodPanel.Width + OFF;
  PswdPanel.Position.Y           := OFF;
  PswdPanel.Width                := IniDayPeriodPanel.Width;

  TotensPanel.Position.X         := IniDayPeriodPanel.Position.X;
  TotensPanel.Position.Y         := IniDayPeriodPanel.Position.Y + IniDayPeriodPanel.Height + OFF;
  TotensPanel.Height             := Height - IniDayPeriodPanel.Height - pnlBotoes.Height - 4*OFF;
  TotensPanel.Width              := (Trunc((Width - IniPeriodPanel.Width - 4 * OFF)) div 4);

  TotensTreeView.Position.X      := OFF;
  TotensTreeView.Position.Y      := TotensLabel.Position.Y + TotensLabel.Height + OFF;
  TotensTreeView.Height          := TotensPanel.Height - TotensTreeView.Position.Y - OFF;
  TotensTreeView.Width           := TotensPanel.Width - 2 * OFF;

  FluxosPanel.Position.X         := TotensPanel.Position.X + TotensPanel.Width + OFF;
  FluxosPanel.Position.Y         := TotensPanel.Position.Y;
  FluxosPanel.Height             := TotensPanel.Height;
  FluxosPanel.Width              := TotensPanel.Width;

  FluxosTreeView.Position.X      := OFF;
  FluxosTreeView.Position.Y      := FluxosLabel.Position.Y + FluxosLabel.Height + OFF;
  FluxosTreeView.Height          := FluxosPanel.Height - FluxosTreeView.Position.Y - OFF;
  FluxosTreeView.Width           := FluxosPanel.Width - 2 * OFF;

  //TagsPanel.Position.X           := FilasPanel.Position.X + FilasPanel.Width + OFF;
  //TagsPanel.Position.Y           := FilasPanel.Position.Y;
  //TagsPanel.Height               := FilasPanel.Height;
  //TagsPanel.Width                := FilasPanel.Width;

  //TagsTreeView.Position.X        := OFF;
  //TagsTreeView.Position.Y        := TagsLabel.Position.Y + TagsLabel.Height + OFF;
  //TagsTreeView.Height            := TagsPanel.Height - TagsTreeView.Position.Y - OFF;
  //TagsTreeView.Width             := TagsPanel.Width - 2*OFF;
end;

function TfrmPesquisaRelatorioTotem.CheckUnidadesSelecionadas: Boolean;
begin
  Result := True;

  cdsUnidades.First;
  while not cdsUnidades.Eof do
  begin
    if (cdsUnidades.FieldByName('SELECIONADO').AsBoolean) and (not cdsUnidades.FieldByName('CONECTADA').AsBoolean) then
    begin
      WarningMessage('Você selecionou a unidade ' + cdsUnidades.FieldByName('NOME').AsString + ', porém a' +
                     ' mesma não está conectada neste momento.' + sLineBreak + 'Por favor desmarque-a antes de emitir o relatório.');
      Result := False;
      Break;
    end;

    cdsUnidades.Next;
  end;
end;

constructor TfrmPesquisaRelatorioTotem.Create(AOwner: TComponent);
var
  i  : integer;
begin
  FfrmSicsReport := nil;
  FfrmSicsGraphics := nil;
  inherited;
  FUltimoPerfilSLA := Null;
  FAtualizarTreeViewsDataSetScroll := True;
  FLimpandoTreeView := False;
  FPermiteInserirUnidades := False;

  vlChanged := false;

  IniSinceDayEdit.Text    := FormatDateTime ('dd', now);
  IniSinceMonthEdit.Text  := FormatDateTime ('mm', now);
  IniSinceYearEdit.Text   := FormatDateTime ('yy', now);
  IniUntilDayEdit.Text    := FormatDateTime ('dd', now);
  IniUntilMonthEdit.Text  := FormatDateTime ('mm', now);
  IniUntilYearEdit.Text   := FormatDateTime ('yy', now);

  for i := 1 to cgMaxAtTypes do
  begin
    if FindComponent('cbTipo'+inttostr(i)) <> nil then
    begin
      (FindComponent('edTipo'+inttostr(i)+'MaiorMenorHoras'   ) as TEdit).Text := '00';
      (FindComponent('edTipo'+inttostr(i)+'MaiorMenorMinutos' ) as TEdit).Text := '00';
      (FindComponent('edTipo'+inttostr(i)+'MaiorMenorSegundos') as TEdit).Text := '00';
      (FindComponent('edTipo'+inttostr(i)+'DesdeHoras'        ) as TEdit).Text := '00';
      (FindComponent('edTipo'+inttostr(i)+'DesdeMinutos'      ) as TEdit).Text := '00';
      (FindComponent('edTipo'+inttostr(i)+'DesdeSegundos'     ) as TEdit).Text := '00';
      (FindComponent('edTipo'+inttostr(i)+'AteHoras'          ) as TEdit).Text := '23';
      (FindComponent('edTipo'+inttostr(i)+'AteMinutos'        ) as TEdit).Text := '59';
      (FindComponent('edTipo'+inttostr(i)+'AteSegundos'       ) as TEdit).Text := '59';

      (FindComponent('rbTipo'+inttostr(i)+'Todos'             ) as TRadioButton).IsChecked := true;
    end;  { if FindComponent }
  end;

  DayPeriodIniHourEdit.Text     := '00';
  DayPeriodIniMinuteEdit.Text   := '00';
  DayPeriodUntilHourEdit.Text   := '23';
  DayPeriodUntilMinuteEdit.Text := '59';
end;

procedure TfrmPesquisaRelatorioTotem.dbgrdUnidadesCheckFieldClick(
  Field: TField);
begin
  if not cdsUnidades.FieldByName('CONECTADA').AsBoolean then
    Field.AsBoolean := False;
end;

procedure TfrmPesquisaRelatorioTotem.dbgrdUnidadesDrawColumnCell(Sender: TObject;
  const Canvas: TCanvas; const Column: TColumn; const Bounds: TRectF;
  const Row: Integer; const Value: TValue; const State: TGridDrawStates);
begin
  inherited;
//
end;

procedure TfrmPesquisaRelatorioTotem.dbgrdUnidadesKeyDown(Sender: TObject;
  var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  inherited;
   //
end;

destructor TfrmPesquisaRelatorioTotem.Destroy;
begin
  inherited;
end;

procedure TfrmPesquisaRelatorioTotem.ComponentesCallCenter;
begin
  btnExibirGraficosTMETMA.Text := 'Gráficos TME';
  Caption                      := 'Filtrar base de dados (Tempo de Atendimento no Totem)';
  PasswordCheckBox.Text        := 'Determinar &mesas';
  gbTipo2.Visible              := False;
  gbTipo3.Visible              := False;
  TagsPanel.Visible            := False;
  btnExibirGraficosSLA.Visible := False;
  pnlTipo.Height               := 165;
end;

end.


