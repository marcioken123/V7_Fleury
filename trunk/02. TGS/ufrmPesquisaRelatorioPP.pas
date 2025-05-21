unit ufrmPesquisaRelatorioPP;
//Renomeado unit sics_89;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  {$IFNDEF IS_MOBILE}
  Winapi.Windows,
  {$ENDIF IS_MOBILE}

  FMX.Grid, FMX.Controls, FMX.Forms, FMX.Graphics,  ufrmReportPP, FMX.Dialogs,
  FMX.StdCtrls, FMX.ExtCtrls, FMX.Types, FMX.Layouts, FMX.ListView.Types,
  FMX.ListView, FMX.ListBox, Fmx.Bind.DBEngExt, Fmx.Bind.Grid,
  System.Bindings.Outputs, Fmx.Bind.Editors, FMX.Objects, FMX.Edit,
  FMX.TabControl, System.UIConsts, System.Generics.Defaults,
  System.Generics.Collections, System.UITypes, System.Types, System.SysUtils,
  System.Classes, System.Variants, Data.DB, Datasnap.DBClient, System.Rtti,
  Data.Bind.EngExt, Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope,
  System.DateUtils, MyAspFuncoesUteis, IniFiles, ufrmPesquisaRelatorioBase, Data.FMTBcd, System.ImageList, FMX.ImgList,
  FMX.TreeView, FMX.EditBox, FMX.SpinBox, ufrmGraphicsPP, Data.SqlTimSt,
  untCommonFormBase, FMX.Controls.Presentation, FMX.Effects,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, 
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, 
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.DBX.Migrate,
  uDataSetHelper;

type
  TDuracao       = record
                      TipoDeDuracao  : TTipoDeDuracao;
                      Tempo1, Tempo2 : TDateTime;
                    end;  { record }

  TQueryParamsPP = record
                      Duracao                                                  : TDuracao;
                      ChoosePeriodoDoRelatorio, ChooseDuracao, ChooseAtds,
                        ChoosePAs, ChoosePswd, ChooseAtdsFim, ChoosePAsFim,
                        ChoosePPs, ChoosePeriodoDoDia, ChooseTags              : boolean;
                      IniPswd, EndPswd,
                      DayPeriodIniHour, DayPeriodIniMinute,
                        DayPeriodUntilHour, DayPeriodUntilMinute               : integer;
                      IniSinceTime, IniUntilTime                               : TDateTime
                   end;  { TQueryParamsPP }

  //Eventos OK
  TfrmPesquisaRelatorioPP = class(TfrmPesquisaRelatorioBase)
    Label29: TLabel;
    Label30: TLabel;
    PasswordCheckBox: TCheckBox;
    PswdSinceSpin: TSpinBox;
    PswdUntilSpin: TSpinBox;
    AtendsPanel: TPanel;
    AtendsLabel: TLabel;
    PAsPanel: TPanel;
    PAsLabel: TLabel;
    pnlTipo: TPanel;
    AtendsFinPanel: TPanel;
    dtsUnidades: TDataSource;
    qryAux: TFDQuery;
    PAsFinPanel: TPanel;
    pnlBotoes: TPanel;
    btnExibirTabela: TButton;
    btnExibirGraficosTMETMA: TButton;
    CancelButton: TButton;
    BitBtn1: TButton;
    imgsCheckBox: TImageList;
    AtendsTreeView: TTreeView;
    PAsTreeView: TTreeView;
    AtendsFimTreeView: TTreeView;
    PAsFimTreeView: TTreeView;
    AtendsFinLabel: TLabel;
    PAsFinLabel: TLabel;
    PPsLabel: TLabel;
    PPsTreeView: TTreeView;
    bnd1: TBindSourceDB;
    rect1: TRectangle;
    rectDuracao: TRectangle;
    edDuracaoAteHoras: TEdit;
    edDuracaoAteMinutos: TEdit;
    edDuracaoAteSegundos: TEdit;
    edDuracaoDesdeHoras: TEdit;
    edDuracaoDesdeMinutos: TEdit;
    edDuracaoDesdeSegundos: TEdit;
    edDuracaoMaiorMenorHoras: TEdit;
    edDuracaoMaiorMenorMinutos: TEdit;
    edDuracaoMaiorMenorSegundos: TEdit;
    lblTipo1Ate: TLabel;
    lblTipo1DoisPontos1: TLabel;
    lblTipo1DoisPontos2: TLabel;
    lblTipo1DoisPontos3: TLabel;
    lblTipo1DoisPontos4: TLabel;
    lblTipo1DoisPontos5: TLabel;
    lblTipo1DoisPontos6: TLabel;
    rbDuracaoEntre: TRadioButton;
    rbDuracaoMaiorIgual: TRadioButton;
    rbDuracaoMenor: TRadioButton;
    rbDuracaoTodos: TRadioButton;
    rectTituloDuracao: TRectangle;
    chkDuracao: TCheckBox;
    IniPeriodPanel: TRectangle;
    rectTituloPeriodoInicio: TRectangle;
    IniPeriodCheckBox: TCheckBox;
    IniSinceDayEdit: TEdit;
    IniSinceMonthEdit: TEdit;
    IniSinceYearEdit: TEdit;
    IniUntilDayEdit: TEdit;
    IniUntilMonthEdit: TEdit;
    IniUntilYearEdit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    IniDayPeriodPanel: TRectangle;
    rect2: TRectangle;
    DayPeriodCheckBox: TCheckBox;
    DayPeriodIniHourEdit: TEdit;
    DayPeriodIniMinuteEdit: TEdit;
    DayPeriodUntilHourEdit: TEdit;
    DayPeriodUntilMinuteEdit: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    Label10: TLabel;
    Label9: TLabel;
    PswdPanel: TRectangle;
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    Rectangle3: TRectangle;
    Rectangle4: TRectangle;
    Rectangle5: TRectangle;
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
    procedure PasswordCheckBoxChange(Sender: TObject);
    procedure chkDuracaoChange(Sender: TObject);
    procedure rbDuracaoTodosChange(Sender: TObject);
    procedure AtendsTreeViewKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure rbDuracaoMenorMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure rbDuracaoEntreMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure dbgrdUnidadesKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure dbgrdUnidadesDrawColumnCell(Sender: TObject;
      const Canvas: TCanvas; const Column: TColumn; const Bounds: TRectF;
      const Row: Integer; const Value: TValue; const State: TGridDrawStates);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  protected
    procedure CarregaUnidades; Override;
    procedure CarregarTreeViews; Override;

    function CheckUnidadesSelecionadas: Boolean; Override;
    procedure GetQueryParams; Override;
    procedure GetRepVars; Override;
    procedure ExibirGraficoSLA; Override;
    procedure SetIDUnidade(const Value: Integer); Override;
    procedure EditarClientDataSet(const tabela: string; const Id: Integer; const Selecionado: Boolean); Override;
  public
    FfrmSicsReportPP: TfrmReportPP;
    FfrmSicsGraphicsPP: TfrmGraphicsPP;
    vlRepVars : record
                   Atds, PAs, AtdsFim, PAsFim, PPs, Senhas, Tags,
                     PeriodoDoRelatorio, PeriodoDoDia, Duracao, MultiUnidades : string;
                   QtdeUnidadesSelecionadas                                   : Integer;
                end;  { record RepVars }
    vlQueryParamsPP : TQueryParamsPP;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; Override;
    procedure MontarWhere(QryEventos: TFDQuery; var SqlInTags: string; IgnoreDuracao: Boolean); Override;
  end;

function frmSicsPesquisaRelatorioPP(const aIDUnidade: integer; const aAllowNewInstance: Boolean = False; const aOwner: TComponent = nil): TFrmPesquisaRelatorioPP;

implementation

uses
  ufrmParamsNiveisSLA, untMainForm, untCommonDMConnection, untCommonDMClient,
  untCommonDMUnidades, Sics_Common_Parametros,
  FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys;

{$R *.fmx}

function frmSicsPesquisaRelatorioPP(const aIDUnidade: integer; const aAllowNewInstance: Boolean = False; const aOwner: TComponent = nil): TFrmPesquisaRelatorioPP;
begin
  Result := TfrmPesquisaRelatorioPP(TfrmPesquisaRelatorioPP.GetInstancia(aIDUnidade, aAllowNewInstance, aOwner));
end;

procedure TfrmPesquisaRelatorioPP.CarregarTreeViews;
begin
   //LBC
   Carregar(Self,TDataSetField(cdsUnidades.FieldByName('ATENDENTES')).NestedDataSet, AtendsTreeView    ,'ATENDENTES');
   Carregar(Self,TDataSetField(cdsUnidades.FieldByName('PAS'       )).NestedDataSet, PasTreeView       ,'PAS');
   Carregar(Self,TDataSetField(cdsUnidades.FieldByName('TAGS'      )).NestedDataSet, TagsTreeView      ,'TAGS');
   Carregar(Self,TDataSetField(cdsUnidades.FieldByName('ATDS_FIM'  )).NestedDataSet, AtendsFimTreeView ,'ATDS_FIM');
   Carregar(Self,TDataSetField(cdsUnidades.FieldByName('PAS_FIM'   )).NestedDataSet, PAsFimTreeView    ,'PAS_FIM');
   Carregar(Self,TDataSetField(cdsUnidades.FieldByName('PPS'       )).NestedDataSet, PPsTreeView       ,'PPS');
end;


procedure TfrmPesquisaRelatorioPP.CarregaUnidades;
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

          if Tabela = 'PPS' then                                                           //RAP
          begin                                                                            //RAP
            CdsDestino.FieldByName('ID_GRUPOPP').Value := FieldByName('ID_GRUPOPP').Value; //RAP
            CdsDestino.FieldByName('CODIGOCOR').Value := FieldByName('CODIGOCOR').Value;   //RAP
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

  procedure InserirPAInicioNenhuma;
  begin
    with TDataSetField(cdsUnidades.FieldByName('PAS')).NestedDataSet do
    begin
      Append;
      FieldByName('ID').AsInteger := 0;
      FieldByName('NOME').AsString := '(nenhuma)';
      FieldByName('SELECIONADO').AsBoolean := True;
      Post;
    end;
  end;

  procedure InserirAtendsInicioNenhuma;
  begin
    with TDataSetField(cdsUnidades.FieldByName('ATENDENTES')).NestedDataSet do
    begin
      Append;
      FieldByName('ID').AsInteger := 0;
      FieldByName('NOME').AsString := '(nenhum)';
      FieldByName('SELECIONADO').AsBoolean := True;
      Post;
    end;
  end;

  procedure InserirPAFimNenhuma;
  begin
    with TDataSetField(cdsUnidades.FieldByName('PAS_FIM')).NestedDataSet do
    begin
      Append;
      FieldByName('ID').AsInteger := 0;
      FieldByName('NOME').AsString := '(nenhuma)';
      FieldByName('SELECIONADO').AsBoolean := True;
      Post;
    end;
  end;

  procedure InserirAtendsFimNenhuma;
  begin
    with TDataSetField(cdsUnidades.FieldByName('ATDS_FIM')).NestedDataSet do
    begin
      Append;
      FieldByName('ID').AsInteger := 0;
      FieldByName('NOME').AsString := '(nenhum)';
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

        if not Active then
        begin

          //LBC
          // preparando o dataset
          for iCampo := 1 to 10 do
          begin
            case iCampo of
               1: sCampo := 'ATENDENTES';
               2: sCampo := 'PAS';
               3: sCampo := 'FILAS';
               4: sCampo := 'TAGS';
               5: sCampo := 'ATDS_FIM';
               6: sCampo := 'PAS_FIM';
               7: sCampo := 'GRUPOS_ATENDENTES';
               8: sCampo := 'GRUPOS_PAS';
               9: sCampo := 'GRUPOS_PPS';
              10: sCampo := 'PPS';
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

            if sCampo = 'ATDS_FIM' then
            begin
              with FieldDefs[FieldDefs.IndexOf(sCampo)].ChildDefs.AddFieldDef do
              begin
                DataType := ftInteger;
                Name := 'ID_GRUPOATENDENTE';
              end;
            end;

            if sCampo = 'PAS_FIM' then
            begin
              with FieldDefs[FieldDefs.IndexOf(sCampo)].ChildDefs.AddFieldDef do
              begin
                DataType := ftInteger;
                Name := 'ID_GRUPOPA';
              end;
            end;

            if sCampo = 'PPS' then
            begin
              with FieldDefs[FieldDefs.IndexOf(sCampo)].ChildDefs.AddFieldDef do
              begin
                DataType := ftInteger;
                Name := 'ID_GRUPOPP';
              end;

              with FieldDefs[FieldDefs.IndexOf(sCampo)].ChildDefs.AddFieldDef do
              begin
                DataType := ftInteger;
                Name := 'CODIGOCOR';
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

        // copiando os dados das outras unidades
        dmUnidades.cdsUnidadesClone.First;
        while not dmUnidades.cdsUnidadesClone.Eof do
        begin
          if not Locate('ID', dmUnidades.cdsUnidadesClone.FieldByName('ID').Value, []) then
          begin
            Append;
            FieldByName('ID').AsInteger := dmUnidades.cdsUnidadesClone.FieldByName('ID').AsInteger;
            FieldByName('NOME').AsString := dmUnidades.cdsUnidadesClone.FieldByName('NOME').AsString;
            FieldByName('CONECTADA').AsBoolean := dmUnidades.cdsUnidadesClone.FieldByName('CONECTADA').AsBoolean;
            if dmUnidades.cdsUnidadesClone.FieldByName('CONECTADA').AsBoolean then
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

            conn := DMClient(dmUnidades.cdsUnidadesClone.FieldByName('ID').AsInteger, not CRIAR_SE_NAO_EXISTIR).ConnRelatorio;
            try
              conn.Connected := True;
              FieldByName('CONECTADA').AsBoolean := True;
            except
              FieldByName('CONECTADA').AsBoolean := False;
              FieldByName('SELECIONADO').AsBoolean := False;
              Post;
              dmUnidades.cdsUnidadesClone.Next;
              Continue;
            end;

            for iTabela := 1 to 10 do
            begin
               case iTabela of
                  1: begin
                       sCampo := 'ATENDENTES';
                       sCampoGrupoId := 'id_grupoatendente';
                       sSql := 'select atd.id, atd.nome, atd.id_grupoatendente, grp.nome as grupo_nome from atendentes atd left join grupos_atendentes grp on grp.id_unidade = atd.id_unidade and grp.id = atd.id_grupoatendente where atd.id_unidade = :ID_UNIDADEATUAL';
                     end;
                  2: begin
                       sCampo := 'PAS';
                       sCampoGrupoId := 'id_grupopa';
                       sSql := 'select pas.id, pas.nome, pas.id_grupopa, grp.nome as grupo_nome from pas left join grupos_pas grp on grp.id_unidade = pas.id_unidade and grp.id = pas.id_grupopa where pas.id_unidade = :ID_UNIDADEATUAL';
                     end;
                  3: begin
                       sCampo := 'ATDS_FIM';
                       sCampoGrupoId := 'id_grupoatendente';
                       sSql := 'select atd.id, atd.nome, atd.id_grupoatendente, grp.nome as grupo_nome from atendentes atd left join grupos_atendentes grp on grp.id_unidade = atd.id_unidade and grp.id = atd.id_grupoatendente where atd.id_unidade = :ID_UNIDADEATUAL';
                     end;
                  4: begin
                       sCampo := 'PAS_FIM';
                       sCampoGrupoId := 'id_grupopa';
                       sSql := 'select pas.id, pas.nome, pas.id_grupopa, grp.nome as grupo_nome from pas left join grupos_pas grp on grp.id_unidade = pas.id_unidade and grp.id = pas.id_grupopa where pas.id_unidade = :ID_UNIDADEATUAL';
                     end;
                  5: begin
                       sCampo := 'FILAS';
                       sCampoGrupoId := '';
                       sSql := 'select id, nome, rangeminimo, rangemaximo from filas where id_unidade = :ID_UNIDADEATUAL';
                       InserirFilaNenhuma;
                     end;
                  6: begin
                       sCampo := 'TAGS';
                       sCampoGrupoId := 'id_grupotag';
                       sSql := 'select tags.id, tags.nome, tags.id_grupotag, tags.codigocor, grp.nome as grupo_nome from tags left join grupos_tags grp on grp.id_unidade = tags.id_unidade and grp.id = tags.id_grupotag where tags.id_unidade = :ID_UNIDADEATUAL';
                       InserirTagsNenhuma;
                     end;
                  7: begin
                       sCampo := 'GRUPOS_ATENDENTES';
                       sCampoGrupoId := '';
                       sSql := 'select id, nome from grupos_atendentes where id_unidade = :ID_UNIDADEATUAL';
                     end;
                  8: begin
                       sCampo := 'GRUPOS_PAS';
                       sCampoGrupoId := '';
                       sSql := 'select id, nome from grupos_pas where id_unidade = :ID_UNIDADEATUAL';
                     end;
                  //RAP 9 e 10 -------------------------------------
                  9: begin
                       sCampo := 'GRUPOS_PPS';
                       sCampoGrupoId := '';
                       sSql := 'select id, nome from grupos_pps where id_unidade = :ID_UNIDADEATUAL';
                     end;
                 10: begin
                       sCampo := 'PPS';
                       sCampoGrupoId := 'id_grupopp';
                       sSql := 'select pps.id, pps.nome, pps.id_grupopp, pps.codigocor, gpp.nome as grupo_nome from pps left join grupos_pps gpp on gpp.id_unidade = pps.id_unidade and gpp.id = pps.id_grupopp where pps.id_unidade = :ID_UNIDADEATUAL';
                     end;
                  //RAP 9 e 10 -------------------------------------
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

                         if sCampo = 'PPS' then
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

          dmUnidades.cdsUnidadesClone.Next;
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


procedure TfrmPesquisaRelatorioPP.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  SalvaSituacaoTreeView(Self,AtendsTreeView);
  SalvaSituacaoTreeView(Self,PAsTreeView);
  SalvaSituacaoTreeView(Self,PPsTreeView);
  SalvaSituacaoTreeView(Self,AtendsFimTreeView);
  SalvaSituacaoTreeView(Self,PAsFimTreeView);
  SalvaSituacaoTreeView(Self,TagsTreeView);
end;

procedure TfrmPesquisaRelatorioPP.FormKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  inherited;
//
end;

procedure TfrmPesquisaRelatorioPP.edDuracaoMaiorMenorHorasChange(Sender: TObject);
begin
  vlChanged := true;
  if ((not rbDuracaoMenor.IsChecked) and (not rbDuracaoMaiorIgual.IsChecked))  then
    rbDuracaoMenor.IsChecked := true;
end;

procedure TfrmPesquisaRelatorioPP.edDuracaoDesdeHorasChange(Sender: TObject);
begin
  vlChanged := true;
  rbDuracaoEntre.IsChecked := true;
end;


procedure TfrmPesquisaRelatorioPP.rbDuracaoTodosChange(Sender: TObject);
begin
  inherited;
  vlChanged := true;
end;

procedure TfrmPesquisaRelatorioPP.SetIDUnidade(const Value: Integer);
begin
  if (IDUnidade <> Value) then
  begin
    inherited;
    FreeAndNil(FfrmSicsReportPP);
    FreeAndNil(FfrmSicsGraphicsPP);
  end;
end;

procedure TfrmPesquisaRelatorioPP.rbDuracaoEntreMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  inherited;
  vlChanged := true;
  edDuracaoDesdeHoras.SetFocus;
end;

procedure TfrmPesquisaRelatorioPP.rbDuracaoMenorMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  inherited;
  vlChanged := true;
  edDuracaoMaiorMenorHoras.SetFocus;
end;

procedure TfrmPesquisaRelatorioPP.IniPeriodCheckBoxChange(Sender: TObject);
begin
  inherited;

   vlChanged := true;

   EnableDisableAllControls(IniPeriodPanel, IniPeriodCheckBox.IsChecked, rectTituloPeriodoInicio);
   if IniPeriodCheckBox.IsChecked then
      IniSinceDayEdit.SetFocus;
end;

procedure TfrmPesquisaRelatorioPP.DayPeriodCheckBoxChange(Sender: TObject);
begin
  inherited;
   vlChanged := true;

   Label9.Enabled  := DayPeriodCheckBox.IsChecked;
   Label10.Enabled := DayPeriodCheckBox.IsChecked;
   Label8.Enabled := DayPeriodCheckBox.IsChecked;
   Label7.Enabled := DayPeriodCheckBox.IsChecked;
   DayPeriodIniHourEdit.Enabled     := DayPeriodCheckBox.IsChecked;
   DayPeriodIniMinuteEdit.Enabled   := DayPeriodCheckBox.IsChecked;
   DayPeriodUntilHourEdit.Enabled   := DayPeriodCheckBox.IsChecked;
   DayPeriodUntilMinuteEdit.Enabled := DayPeriodCheckBox.IsChecked;

   if DayPeriodCheckBox.IsChecked then
      DayPeriodIniHourEdit.SetFocus;
end;

procedure TfrmPesquisaRelatorioPP.PasswordCheckBoxChange(Sender: TObject);
begin
  inherited;
   vlChanged := true;

   Label29.Enabled := PasswordCheckBox.IsChecked;
   Label30.Enabled := PasswordCheckBox.IsChecked;
   PswdSinceSpin.Enabled := PasswordCheckBox.IsChecked;
   PswdUntilSpin.Enabled := PasswordCheckBox.IsChecked;

   if PasswordCheckBox.IsChecked then
   begin
      PswdSinceSpin.SetFocus;
      PswdSinceSpin.FontColor := claWindowText;
      PswdUntilSpin.FontColor := claWindowText;
   end
   else
   begin
      PswdSinceSpin.FontColor := claGrayText;
      PswdUntilSpin.FontColor := claGrayText;
   end;  { else }
end;

procedure TfrmPesquisaRelatorioPP.EditarClientDataSet(const tabela: string;
  const Id: Integer; const Selecionado: Boolean);
//var
//  sCampo: string;
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

procedure TfrmPesquisaRelatorioPP.GetQueryParams;
var
  iDetalhes, iTotalRec : integer;
  sCampoDetalhe : string;
  bTodos: Boolean;
  LDataSetTmp: TClientDataSet;
begin
  vlChanged := false;

  with vlQueryParamsPP do
  begin
     ChoosePeriodoDoRelatorio := false;
     ChooseDuracao            := false;
     ChoosePeriodoDoDia       := false;
     ChooseAtds               := false;
     ChooseAtdsFim            := false;
     ChoosePAs                := false;
     ChoosePAsFim             := false;
     ChoosePswd               := false;
     ChoosePPs                := false;
     IniPswd                  := 0;
     EndPswd                  := 0;
     IniSinceTime             := 0;
     IniUntilTime             := 0;
     DayPeriodIniHour         := 0;
     DayPeriodIniMinute       := 0;
     DayPeriodUntilHour       := 0;
     DayPeriodUntilMinute     := 0;

     if ((not chkDuracao.IsChecked) or (rbDuracaoTodos.IsChecked)) then
     begin
       ChooseDuracao := false;
       Duracao.TipoDeDuracao := tdTodos;
       Duracao.Tempo1 := 0;
       Duracao.Tempo2 := 0;
     end
     else if rbDuracaoMenor.IsChecked then
     begin
       ChooseDuracao := true;
       Duracao.TipoDeDuracao := tdMenor;
       Duracao.Tempo1 := EncodeTime (strtoint(edDuracaoMaiorMenorHoras   .Text),
                                     strtoint(edDuracaoMaiorMenorMinutos .Text),
                                     strtoint(edDuracaoMaiorMenorSegundos.Text), 0);
       Duracao.Tempo2 := 0;
     end
     else if rbDuracaoMaiorIgual.IsChecked then
     begin
       ChooseDuracao := true;
       Duracao.TipoDeDuracao := tdMaiorIgual;
       Duracao.Tempo1 := EncodeTime (strtoint(edDuracaoMaiorMenorHoras   .Text),
                                     strtoint(edDuracaoMaiorMenorMinutos .Text),
                                     strtoint(edDuracaoMaiorMenorSegundos.Text), 0);
       Duracao.Tempo2 := 0;
     end
     else if rbDuracaoEntre.IsChecked then
     begin
       ChooseDuracao := true;
       Duracao.TipoDeDuracao := tdEntre;
       Duracao.Tempo1 := EncodeTime (strtoint(edDuracaoDesdeHoras   .Text),
                                     strtoint(edDuracaoDesdeMinutos .Text),
                                     strtoint(edDuracaoDesdeSegundos.Text), 0);
       Duracao.Tempo2 := EncodeTime (strtoint(edDuracaoAteHoras     .Text),
                                     strtoint(edDuracaoAteMinutos   .Text),
                                     strtoint(edDuracaoAteSegundos  .Text), 999);
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
       //LBC
       for iDetalhes := 1 to 6 do
       begin
         case iDetalhes of
           1: sCampoDetalhe := 'ATENDENTES';
           2: sCampoDetalhe := 'PAS';
           3: sCampoDetalhe := 'TAGS';
           4: sCampoDetalhe := 'ATDS_FIM';
           5: sCampoDetalhe := 'PAS_FIM';
           6: sCampoDetalhe := 'PPS';
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
           1: ChooseAtds    := not bTodos;
           2: ChoosePas     := not bTodos;
           3: ChooseTags    := not bTodos;
           4: ChooseAtdsFim := not bTodos;
           5: ChoosePAsFim  := not bTodos;
           6: ChoosePPs     := not bTodos;
         end;
       end;
     finally
       FreeAndNil(LDataSetTmp);
     end;

     if PasswordCheckBox.IsChecked then
     begin
        ChoosePswd := true;
        IniPswd := Trunc(PswdSinceSpin.Value);
        EndPswd := Trunc(PswdUntilSpin.Value);
     end;
  end;
end;  { func GetQueryParams }


procedure TfrmPesquisaRelatorioPP.MontarWhere(QryEventos: TFDQuery; var SqlInTags: string; IgnoreDuracao: Boolean);

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
  iDetalhes                         : integer;
   sOldIndexFieldNames     : string;
   iTotalRec                         : Integer;
   bTodos,bTbNenhum                  : Boolean;
  LDataSetTmp: TClientDataSet;
begin
  SqlInTags := '';

  if ((vlQueryParamsPP.ChoosePeriodoDoRelatorio = false) and
      ((vlQueryParamsPP.ChooseDuracao = false) or (IgnoreDuracao)) and
      (vlQueryParamsPP.ChoosePswd = false) and
      (vlQueryParamsPP.ChooseAtds = false) and
      (vlQueryParamsPP.ChoosePAs = false) and
      (vlQueryParamsPP.ChooseTags = false) and
      (vlQueryParamsPP.ChooseAtdsFim = false) and
      (vlQueryParamsPP.ChoosePAsFim = false) and
      (vlQueryParamsPP.ChoosePPS = false)  and
      (vlQueryParamsPP.ChoosePeriodoDoDia = false)) then
  begin
    qryEventos.SQL.Delete(qryEventos.SQL.Count - 1);
  end
  else
  begin
     if vlQueryParamsPP.ChoosePeriodoDoRelatorio then
     begin
        s := '((EPP.INICIO >= :IniSinceTime )and(EPP.INICIO <= :IniUntilTime ))and';
        ExtractComma (s);
        qryEventos.Sql.Add (s);
     end;  { if ChoosePeriodoDoRelatorio }

     if vlQueryParamsPP.ChoosePswd then
     begin
        s := '((S.NUMEROTICKET>=' + inttostr(vlQueryParamsPP.IniPswd) + ')and' +
             ' (S.NUMEROTICKET<=' + inttostr(vlQueryParamsPP.EndPswd) + '))and';
        ExtractComma (s);
        qryEventos.Sql.Add (s);
     end;  { if ChoosePswd }

     if vlQueryParamsPP.ChoosePeriodoDoDia then
     begin
       if (vlQueryParamsPP.DayPeriodIniHour) = (vlQueryParamsPP.DayPeriodUntilHour) then  { EXEMPLO: 10:02 ~ 10:38 => [H=10] & [2<=M<=38] }
         s := '((({extract(hour from INICIO)} = ' + IntToStr(vlQueryParamsPP.DayPeriodIniHour) + ')'      + ' and ' +
              '({extract(minute from INICIO)} between ' + IntToStr(vlQueryParamsPP.DayPeriodIniMinute)   + ' and ' +
                                                         IntToStr(vlQueryParamsPP.DayPeriodUntilMinute) + '))) and'
       else   { EXEMPLO:  10:50 ~ 13:30 => [H=10 & M>=50] + [H=13 & M<=30] + [10+1<=H<=13-1] }
         s := '((({extract(hour, INICIO)} = '    + IntToStr(vlQueryParamsPP.DayPeriodIniHour)    + ') and ' +
                '({extract(minute, INICIO)} >= ' + IntToStr(vlQueryParamsPP.DayPeriodIniMinute)  + ')    )  or ' +

               '(({extract(hour, INICIO)} = '    + IntToStr(vlQueryParamsPP.DayPeriodUntilHour)   + ') and ' +
                '({extract(minute, INICIO)} <= ' + IntToStr(vlQueryParamsPP.DayPeriodUntilMinute) + ')    ) or ' +

               '({extract(hour, INICIO)} between ' + IntToStr(vlQueryParamsPP.DayPeriodIniHour+1) +' and '+ IntToStr(vlQueryParamsPP.DayPeriodUntilHour-1) + '))and';
       //ExtractComma(s);
       qryEventos.SQL.Add(s);
     end;  { if ChoosePeriodoDoDia }

     //LBC
     for iDetalhes := 1 to 6 do
     begin
       case iDetalhes of
         1: begin
              sCampoOrigem := 'ATENDENTES';
              sCampoWhere := 'EPP.ID_ATD_INICIO';
            end;
         2: begin
              sCampoOrigem := 'PAS';
              sCampoWhere := 'EPP.ID_PA_INICIO';
            end;
         3: begin
              sCampoOrigem := 'TAGS';
              sCampoWhere := '';
            end;
         4: begin
              sCampoOrigem := 'ATDS_FIM';
              sCampoWhere := 'EPP.ID_ATD_FIM';
            end;
         5: begin
              sCampoOrigem := 'PAS_FIM';
              sCampoWhere := 'EPP.ID_PA_FIM';
            end;
         6: begin
              sCampoOrigem := 'PPS';
              sCampoWhere := 'EPP.ID_TIPOPP';
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
              s := s + 'not exists (select id_ticket from nn_tickets_tags where nn_tickets_tags.id_unidade = :ID_UNIDADE and nn_tickets_tags.id_unidade = epp.id_unidade and nn_tickets_tags.id_ticket = epp.id_ticket)';

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
               s := s + 'exists (select id_ticket from nn_tickets_tags where nn_tickets_tags.id_unidade = :ID_UNIDADE and nn_tickets_tags.id_unidade = epp.id_unidade and nn_tickets_tags.id_ticket = epp.id_ticket and nn_tickets_tags.id_tag in (' + sIn + '))';
             end;
           end;
           s := s + ')and';
           qryEventos.Sql.Add (s);
         end;
       finally
         FreeAndNil(LDataSetTmp);
       end;
     end;

     if ((vlQueryParamsPP.ChooseDuracao) and (not IgnoreDuracao)) then
     begin
       s := '(';

       case vlQueryParamsPP.Duracao.TipoDeDuracao of
         tdMenor      : s := s + '((EPP.DURACAO_SEGUNDOS < :Tempo11))or';
         tdMaiorIgual : s := s + '((EPP.DURACAO_SEGUNDOS >= :Tempo11))or';
         tdEntre      : s := s + '((EPP.DURACAO_SEGUNDOS >= :Tempo11)and(EPP.DURACAO_SEGUNDOS <= :Tempo21))or';
       end; { case }

       s := Copy (s, 1, Length(s)-2);
       s := s + ')and';
       qryEventos.Sql.Add(s);
     end;

     s := ExtractAND (qryEventos.Sql.Strings[qryEventos.Sql.Count - 1]);
     s := s + ')';
     qryEventos.Sql.Delete (qryEventos.Sql.Count - 1);
     qryEventos.Sql.Add (s);
  end;  { else }

  if vlQueryParamsPP.ChoosePeriodoDoRelatorio then
  begin
     qryEventos.Params.ParamByName('IniSinceTime').DataType := ftTimeStamp;
     qryEventos.Params.ParamByName('IniUntilTime').DataType := ftTimeStamp;
     qryEventos.Params.ParamByName('IniSinceTime').AsSQLTimeStamp := DateTimeToSQLTimeStamp (vlQueryParamsPP.IniSinceTime);
     qryEventos.Params.ParamByName('IniUntilTime').AsSQLTimeStamp := DateTimeToSQLTimeStamp (vlQueryParamsPP.IniUntilTime);
  end;  { if ChoosePeriodoDoRelatorio }

  if ((vlQueryParamsPP.ChooseDuracao) and (not IgnoreDuracao)) then
  begin
    case vlQueryParamsPP.Duracao.TipoDeDuracao of
      tdMenor, tdMaiorIgual : begin
                                qryEventos.Params.ParamByName('Tempo11').DataType := ftInteger;
                                qryEventos.Params.ParamByName('Tempo11').AsInteger := SecondsBetween(0, vlQueryParamsPP.Duracao.Tempo1);
                              end;
      tdEntre               : begin
                                qryEventos.Params.ParamByName('Tempo11').DataType := ftInteger;
                                qryEventos.Params.ParamByName('Tempo21').DataType := ftInteger;
                                qryEventos.Params.ParamByName('Tempo11').AsInteger := SecondsBetween(0, vlQueryParamsPP.Duracao.Tempo1);
                                qryEventos.Params.ParamByName('Tempo21').AsInteger := SecondsBetween(0, vlQueryParamsPP.Duracao.Tempo2);
                              end;
    end;  { case }
  end;
end;


procedure TfrmPesquisaRelatorioPP.FormResize(Sender: TObject);
const
  OFF = 10;
begin
  IniPeriodPanel.Position.X      := OFF;
  IniPeriodPanel.Position.Y      := OFF;
  IniDayPeriodPanel.Position.X   := IniPeriodPanel.Position.X + IniPeriodPanel.Width + OFF;
  IniDayPeriodPanel.Position.Y   := IniPeriodPanel.Position.Y;
  PswdPanel.Position.X           := IniDayPeriodPanel.Position.X + IniDayPeriodPanel.Width + OFF;
  PswdPanel.Position.Y           := IniPeriodPanel.Position.Y;

  rectDuracao.Position.Y         := IniPeriodPanel.Position.Y + IniPeriodPanel.Height + OFF;
  rectDuracao.Position.X         := IniPeriodPanel.Position.X;
  rectDuracao.Width              := PswdPanel.Position.X + PswdPanel.Width - rectDuracao.Position.X;

  pnlUnidades.Position.X         := OFF;
  pnlUnidades.Position.Y         := rectDuracao.Position.Y + rectDuracao.Height + OFF;
  pnlUnidades.Width              := rectDuracao.Width;
  pnlUnidades.Height             := ClientHeight - pnlUnidades.Position.Y - pnlBotoes.Height - OFF;

  AtendsPanel.Position.X         := rectDuracao.Position.X + rectDuracao.Width + OFF;
  AtendsPanel.Position.Y         := IniDayPeriodPanel.Position.Y;
  AtendsPanel.Height             := ((Trunc((Height - pnlBotoes.Height - 4*OFF)) div 2)) - 10;
  AtendsPanel.Width              := (Trunc((Width - rectDuracao.Width - 5*OFF)) div 3) -5;
  PAsPanel.Position.X            := AtendsPanel.Position.X + AtendsPanel.Width + OFF;
  PAsPanel.Position.Y            := AtendsPanel.Position.Y;
  PAsPanel.Height                := AtendsPanel.Height;
  PAsPanel.Width                 := AtendsPanel.Width;
  AtendsFinPanel.Position.X      := AtendsPanel.Position.X;
  AtendsFinPanel.Position.Y      := AtendsPanel.Position.Y + AtendsPanel.Height + OFF;
  AtendsFinPanel.Height          := AtendsPanel.Height;
  AtendsFinPanel.Width           := AtendsPanel.Width;
  PAsFinPanel.Position.X         := AtendsFinPanel.Position.X + AtendsFinPanel.Width + OFF;
  PAsFinPanel.Position.Y         := AtendsFinPanel.Position.Y;
  PAsFinPanel.Height             := AtendsFinPanel.Height;
  PAsFinPanel.Width              := AtendsFinPanel.Width;
  pnlTipo.Position.X             := PAsPanel.Position.X + PAsPanel.Width + OFF;
  pnlTipo.Position.Y             := PAsPanel.Position.Y;
  pnlTipo.Height                 := PAsPanel.Height;
  pnlTipo.Width                  := PAsPanel.Width;
  TagsPanel.Position.X           := pnlTipo.Position.X;
  TagsPanel.Position.Y           := AtendsFinPanel.Position.Y;
  TagsPanel.Height               := pnlTipo.Height;
  TagsPanel.Width                := pnlTipo.Width;

  AtendsTreeView.Position.X      := OFF;
  AtendsTreeView.Position.Y      := AtendsLabel.Position.Y + AtendsLabel.Height + OFF;
  AtendsTreeView.Height          := AtendsPanel.Height - AtendsTreeView.Position.Y - OFF;
  AtendsTreeView.Width           := AtendsPanel.Width - 2*OFF;
  PAsTreeView.Position.X         := OFF;
  PAsTreeView.Position.Y         := PAsLabel.Position.Y + PAsLabel.Height + OFF;
  PAsTreeView.Height             := PAsPanel.Height - PAsTreeView.Position.Y - OFF;
  PAsTreeView.Width              := PAsPanel.Width - 2*OFF;
  AtendsFimTreeView.Position.X   := OFF;
  AtendsFimTreeView.Position.Y   := AtendsFinLabel.Position.Y + AtendsFinLabel.Height + OFF;
  AtendsFimTreeView.Height       := AtendsFinPanel.Height - AtendsFimTreeView.Position.Y - OFF;
  AtendsFimTreeView.Width        := AtendsFinPanel.Width - 2*OFF;
  PAsFimTreeView.Position.X      := OFF;
  PAsFimTreeView.Position.Y      := PAsFinLabel.Position.Y + PAsFinLabel.Height + OFF;
  PAsFimTreeView.Height          := PAsFinPanel.Height - PAsFimTreeView.Position.Y - OFF;
  PAsFimTreeView.Width           := PAsFinPanel.Width - 2*OFF;
  PPsTreeView.Position.X         := OFF;
  PPsTreeView.Position.Y         := PPsLabel.Position.Y + PPsLabel.Height + OFF;
  PPsTreeView.Height             := pnlTipo.Height - PPsTreeView.Position.Y - OFF;
  PPsTreeView.Width              := pnlTipo.Width - 2*OFF;
  TagsTreeView.Position.X        := OFF;
  TagsTreeView.Position.Y        := TagsLabel.Position.Y + TagsLabel.Height + OFF;
  TagsTreeView.Height            := TagsPanel.Height - TagsTreeView.Position.Y - OFF;
  TagsTreeView.Width             := TagsPanel.Width - 2*OFF;
end;


procedure TfrmPesquisaRelatorioPP.cdsUnidadesAfterScroll(DataSet: TDataSet);
begin
   if not FAtualizarTreeViewsDataSetScroll then Exit;

   CarregarTreeViews;
end;


procedure TfrmPesquisaRelatorioPP.cdsUnidadesBeforeInsert(DataSet: TDataSet);
begin
   if not FPermiteInserirUnidades then Abort;
end;

procedure TfrmPesquisaRelatorioPP.GetRepVars;
var
  iDetalhes, iTotalRec: Integer;
  bAtdsDivergente, bPAsDivergente, bAtdsFimDivergente, bPAsFimDivergente, bPPsDivergente, bTagsDivergente, bTodos, bTbNenhum: Boolean;
  sAtdsBase, sPAsBase, sAtdsFimBase, sPAsFimBase, sPPsBase, sTagsBase, sIds, sCampoOrigem, sOldIndexFieldNames, sIdsTemp: string;
  ArrIds: TIntegerDynArray;
  bOldAtualizarTreeViewsDataSetScroll: Boolean;
  LDataSetTmp: TClientDataSet;
begin
  bOldAtualizarTreeViewsDataSetScroll := FAtualizarTreeViewsDataSetScroll;
  FAtualizarTreeViewsDataSetScroll := False;
  try

     //LBC
     for iDetalhes := 1 to 6 do
     begin
       case iDetalhes of
         1: sCampoOrigem := 'ATENDENTES';
         2: sCampoOrigem := 'PAS';
         3: sCampoOrigem := 'TAGS';
         4: sCampoOrigem := 'ATDS_FIM';
         5: sCampoOrigem := 'PAS_FIM';
         6: sCampoOrigem := 'PPS';
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
             begin
               if iDetalhes in[1, 4] then //Atendentes INICIO/FIM
                 sIdsTemp := 'Nenhum'
               else
                 sIdsTemp := 'Nenhuma';
             end else
               if iDetalhes in[1, 4] then //Atendentes INICIO/FIM
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
        PPs                := 'Todos';
        Atds               := 'Todos';
        PAs                := 'Todas';
        Tags               := 'Todas';
        AtdsFim            := 'Todas';
        PAsFim             := 'Todas';
        Senhas             := 'Todas';
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
            Atds       := cdsUnidades.FieldByName('ATENDENTES_STR').AsString;
            PAs        := cdsUnidades.FieldByName('PAS_STR').AsString;
            AtdsFim    := cdsUnidades.FieldByName('ATDS_FIM_STR').AsString;
            PAsFim     := cdsUnidades.FieldByName('PAS_FIM_STR').AsString;
            PPs        := cdsUnidades.FieldByName('PPS_STR').AsString;
            Tags       := cdsUnidades.FieldByName('TAGS_STR').AsString;
          end;
        end
        else
        begin
          bAtdsDivergente    := False;
          bPAsDivergente     := False;
          bAtdsFimDivergente := False;
          bPAsFimDivergente  := False;
          bPPsDivergente     := False;
          bTagsDivergente    := False;
          with cdsUnidades do
          begin
            First;
            sAtdsBase    := FieldByName('ATENDENTES_STR' ).AsString;
            sPAsBase     := FieldByName('PAS_STR'        ).AsString;
            sAtdsFimBase := FieldByName('ATDS_FIM_STR'   ).AsString;
            sPAsFimBase  := FieldByName('PAS_FIM_STR'    ).AsString;
            sPPsBase     := FieldByName('PPS_STR'        ).AsString;
            sTagsBase    := FieldByName('TAGS_STR'       ).AsString;
            while not Eof do
            begin
              if FieldByName('ATENDENTES_STR').AsString <> sAtdsBase    then bAtdsDivergente    := True;
              if FieldByName('PAS_STR'       ).AsString <> sPAsBase     then bPAsDivergente     := True;
              if FieldByName('ATDS_FIM_STR'  ).AsString <> sAtdsFimBase then bAtdsFimDivergente := True;
              if FieldByName('PAS_FIM_STR'   ).AsString <> sPAsFimBase  then bPAsFimDivergente  := True;
              if FieldByName('PPS_STR'       ).AsString <> sPPsBase     then bPPsDivergente     := True;
              if FieldByName('TAGS_STR'      ).AsString <> sTagsBase    then bTagsDivergente    := True;
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
          if bAtdsFimDivergente then
            AtdsFim := 'Conforme Unidade'
          else
            AtdsFim := sAtdsFimBase;
          if bPAsFimDivergente then
            PAsFim := 'Conforme Unidade'
          else
            PAsFim := sPAsFimBase;
          if bPPsDivergente then
            PPs := 'Conforme Unidade'
          else
            PPs := sPPsBase;
          if bTagsDivergente then
            Tags := 'Conforme Unidade'
          else
            Tags := sTagsBase;

        end;

        if vlQueryParamsPP.ChoosePeriodoDoRelatorio then
        begin
           PeriodoDoRelatorio := FormatDateTime ('dd/mm/yy', vlQueryParamsPP.IniSinceTime) + ' a ' +
                                 FormatDateTime ('dd/mm/yy', vlQueryParamsPP.IniUntilTime);
        end;  { if ChoosePeriodoDoRelatorio }

        if vlQueryParamsPP.ChoosePeriodoDoDia then
        begin
           PeriodoDoDia := FormatNumber (2, vlQueryParamsPP.DayPeriodIniHour  ) + ':' + FormatNumber (2, vlQueryParamsPP.DayPeriodIniMinute  ) + ' a ' +
                           FormatNumber (2, vlQueryParamsPP.DayPeriodUntilHour) + ':' + FormatNumber (2, vlQueryParamsPP.DayPeriodUntilMinute) ;
        end;  { if ChooseDuracao }

        if vlQueryParamsPP.ChoosePswd then
        begin
           Senhas := inttostr(vlQueryParamsPP.IniPswd) + ' a ' +
                     inttostr(vlQueryParamsPP.EndPswd);
        end;  { if ChoosePswd }

        if (vlQueryParamsPP.ChooseDuracao) then  //inserir o ignoreduracao ?
        begin
           case vlQueryParamsPP.Duracao.TipoDeDuracao of
             tdTodos      : Duracao := 'Todas';
             tdMenor      : Duracao := '<' + FormatTimeComAspas(vlQueryParamsPP.Duracao.Tempo1);
             tdMaiorIgual : Duracao := '>='+ FormatTimeComAspas(vlQueryParamsPP.Duracao.Tempo1);
             tdEntre      : Duracao := '' +  FormatTimeComAspas(vlQueryParamsPP.Duracao.Tempo1) + ' a ' + FormatTimeComAspas(vlQueryParamsPP.Duracao.Tempo2);
           end; { case }
        end;
     end;  { with RepVars }

  finally
    FAtualizarTreeViewsDataSetScroll := bOldAtualizarTreeViewsDataSetScroll;
  end;
end;


procedure TfrmPesquisaRelatorioPP.btnExibirTabelaClick(Sender: TObject);
begin
  if not CheckUnidadesSelecionadas then
    Exit;

  GetQueryParams;
  GetRepVars;
  try
    if not Assigned(FfrmSicsReportPP) then
    begin
      FfrmSicsReportPP := TfrmReportPP.Create(Self, IDUnidade);
    end;

    MainForm.ExibeSomenteOFrame(FfrmSicsReportPP);
  except
    FreeAndNil(FfrmSicsReportPP);
    raise;
  end;
  Hide;
end;


procedure TfrmPesquisaRelatorioPP.btnExibirGraficosTMETMAClick(Sender: TObject);
var
  ParamsSla: TParamsNiveisSla;
begin
  if not CheckUnidadesSelecionadas then
    Exit;

  GetQueryParams;
  GetRepVars;
  try
    if not Assigned(FfrmSicsGraphicsPP) then
    begin
      FfrmSicsGraphicsPP := TfrmGraphicsPP.Create(Self, IDUnidade);
    end;

    FfrmSicsGraphicsPP.GraficoSla := False;
    FfrmSicsGraphicsPP.ParamsSla := ParamsSla;
    MainForm.ExibeSomenteOFrame(FfrmSicsGraphicsPP);
  except
    FreeAndNil(FfrmSicsGraphicsPP);
    raise;
  end;
  Hide;
end;


procedure TfrmPesquisaRelatorioPP.CancelButtonClick(Sender: TObject);
begin
  Close;
end;


procedure TfrmPesquisaRelatorioPP.AtendsTreeViewKeyDown(Sender: TObject;
  var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  inherited;
  {$IFNDEF IS_MOBILE}
  if (Key = VK_SPACE) and Assigned(TTreeView(Sender).Selected) then
    ToggleTreeViewCheckBoxes(TTreeView(Sender).Selected);
  {$ENDIF IS_MOBILE}
end;

procedure TfrmPesquisaRelatorioPP.BitBtn1Click(Sender: TObject);
begin
  if not CheckUnidadesSelecionadas then
    Exit;

  ExibirGraficoSLA;
end;

procedure TfrmPesquisaRelatorioPP.ExibirGraficoSLA;
var
  ParamsSla: TParamsNiveisSla;
begin
  GetQueryParams;
  GetRepVars;
  TfrmSicsParamsNiveisSLA.Exibir(Self, IDUnidade,
    procedure (const Amarelo, Vermelho: integer; UltimoPerfil: Variant)
    begin
      ParamsSla.Amarelo := Amarelo;
      ParamsSla.Vermelho := Vermelho;
      try
        if not Assigned(FfrmSicsGraphicsPP) then
        begin
          FfrmSicsGraphicsPP := TfrmGraphicsPP.Create(Self, IDUnidade);
        end;

        FfrmSicsGraphicsPP.GraficoSla := True;
        FfrmSicsGraphicsPP.ParamsSla := ParamsSla;
        MainForm.ExibeSomenteOFrame(FfrmSicsGraphicsPP);
      except
        FreeAndNil(FfrmSicsGraphicsPP);
        raise;
      end;
      Hide;
    end, FUltimoPerfilSLA);
end;


function TfrmPesquisaRelatorioPP.CheckUnidadesSelecionadas: Boolean;
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


procedure TfrmPesquisaRelatorioPP.dbgrdUnidadesCheckFieldClick(
  Field: TField);
begin
  if not cdsUnidades.FieldByName('CONECTADA').AsBoolean then
    Field.AsBoolean := False;
end;


procedure TfrmPesquisaRelatorioPP.dbgrdUnidadesDrawColumnCell(Sender: TObject;
  const Canvas: TCanvas; const Column: TColumn; const Bounds: TRectF;
  const Row: Integer; const Value: TValue; const State: TGridDrawStates);
begin
  inherited;
//
end;

procedure TfrmPesquisaRelatorioPP.dbgrdUnidadesKeyDown(Sender: TObject;
  var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  inherited;
//
end;

destructor TfrmPesquisaRelatorioPP.Destroy;
begin
  inherited;
end;

procedure TfrmPesquisaRelatorioPP.chkDuracaoChange(Sender: TObject);
begin
  inherited;
  vlChanged := true;

  EnableDisableAllControls(rectDuracao, (Sender as TCheckBox).IsChecked, rectTituloDuracao);
  if (Sender as TCheckBox).IsChecked then
     rbDuracaoTodos.SetFocus;
end;

constructor TfrmPesquisaRelatorioPP.Create(AOwner: TComponent);
begin
  FfrmSicsReportPP := nil;
  FfrmSicsGraphicsPP := nil;
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

  edDuracaoMaiorMenorHoras   .Text := '00';
  edDuracaoMaiorMenorMinutos .Text := '00';
  edDuracaoMaiorMenorSegundos.Text := '00';
  edDuracaoDesdeHoras        .Text := '00';
  edDuracaoDesdeMinutos      .Text := '00';
  edDuracaoDesdeSegundos     .Text := '00';
  edDuracaoAteHoras          .Text := '23';
  edDuracaoAteMinutos        .Text := '59';
  edDuracaoAteSegundos       .Text := '59';

  rbDuracaoTodos.IsChecked := true;

  DayPeriodIniHourEdit.Text     := '00';
  DayPeriodIniMinuteEdit.Text   := '00';
  DayPeriodUntilHourEdit.Text   := '23';
  DayPeriodUntilMinuteEdit.Text := '59';

end;

end.
