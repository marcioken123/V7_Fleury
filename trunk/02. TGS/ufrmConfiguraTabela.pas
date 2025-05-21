unit ufrmConfiguraTabela;
//Renomeado unit cfgGenerica;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  {$IFNDEF IS_MOBILE}
  Windows, Vcl.Dialogs,
  {$ENDIF IS_MOBILE}
  FMX.Grid, FMX.Controls, FMX.Forms, FMX.Graphics, untMainForm, System.UIConsts,
  FMX.Dialogs, FMX.StdCtrls,  FMX.ExtCtrls, FMX.Types, FMX.Layouts,
  FMX.ListView.Types, FMX.ListView, FMX.ListBox, untCommonDMClient,
  Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors,
  FMX.Objects, FMX.Edit, FMX.TabControl, System.UITypes, System.Types,
  System.SysUtils, System.Classes, System.Variants, Data.DB, Datasnap.DBClient,
  System.Rtti, untCommonFrameSituacaoAtendimento, Data.Bind.EngExt,
  Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope, MyAspFuncoesUteis,
  untCommonFrameBase, IniFiles, Data.FMTBcd, FMX.Menus,
  Datasnap.Provider, FMX.Controls.Presentation, System.ImageList, FMX.ImgList,
  untCommonFormBase, FMX.Effects, FMX.Grid.Style, FMX.ScrollBox, System.Math,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, 
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, 
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.DBX.Migrate,
  uDataSetHelper, FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef, FireDAC.FMXUI.Wait;

type
  TTabelaSics = (ctNone, ctFilas, ctGruposDePaineis, ctPaineis, ctGruposDePAs, ctPAs, ctGruposDeAtendentes, ctAtendentes, ctClientes, ctEmails, ctCelulares,
                 ctTags, ctGruposTags, ctTVs, ctPPs, ctGruposDePPs, ctMotivosPausa, ctGruposDeMotivosPausa);

  TfrmSicsConfiguraTabela = class(TFrameBase)
    dsGenerico: TDataSource;
    cdsFilas: TClientDataSet;
    dspFilas: TDataSetProvider;
    cdsFilasNOME: TStringField;
    cdsFilasRANGEMINIMO: TIntegerField;
    cdsFilasRANGEMAXIMO: TIntegerField;
    cdsFilasTROCARMILHAR: TStringField;
    cdsFilasTROCARDEZENADEMILHAR: TStringField;
    qryGeneratorGenericoTESTARREMOVER: TFDQuery;
    lblConfigTabela: TLabel;
    cdsPaineis: TClientDataSet;
    dspPaineis: TDataSetProvider;
    cdsFilasID: TIntegerField;
    cdsPaineisID: TIntegerField;
    cdsPaineisID_MODELOPAINEL: TIntegerField;
    cdsPaineisNOME: TStringField;
    cdsPaineisENDERECOSERIAL: TStringField;
    cdsPaineisMANTERULTIMASENHA: TStringField;
    cdsPaineisMONITORAMENTO: TStringField;
    cdsGruposDePAs: TClientDataSet;
    dspGruposDePAs: TDataSetProvider;
    cdsLkpModelosDePaineis: TClientDataSet;
    dspLkpModelosDePaineis: TDataSetProvider;
    cdsPaineisLKUP_MODELOPAINEL: TStringField;
    cdsGruposDePaineis: TClientDataSet;
    dspGruposDePaineis: TDataSetProvider;
    cdsGruposDePaineisID: TIntegerField;
    cdsGruposDePaineisNOME: TStringField;
    cdsPAs: TClientDataSet;
    dspPAs: TDataSetProvider;
    cdsGruposDeAtendentes: TClientDataSet;
    dspGruposDeAtendentes: TDataSetProvider;
    cdsAtendentes: TClientDataSet;
    dspAtendentes: TDataSetProvider;
    cdsEmails: TClientDataSet;
    dspEmails: TDataSetProvider;
    cdsCelulares: TClientDataSet;
    dspCelulares: TDataSetProvider;
    cdsGruposDePAsID: TIntegerField;
    cdsGruposDePAsNOME: TStringField;
    cdsPAsID: TIntegerField;
    cdsPAsID_GRUPOPA: TIntegerField;
    cdsPAsID_FILAAUTOENCAMINHA: TIntegerField;
    cdsPAsNOME: TStringField;
    cdsPAsNOMENOPAINEL: TStringField;
    cdsPAsMAGAZINE: TIntegerField;
    cdsPAsATIVO: TStringField;
    cdsGruposDeAtendentesID: TIntegerField;
    cdsGruposDeAtendentesNOME: TStringField;
    cdsAtendentesID: TIntegerField;
    cdsAtendentesID_GRUPOATENDENTE: TIntegerField;
    cdsAtendentesNOME: TStringField;
    cdsAtendentesLOGIN: TStringField;
    cdsAtendentesREGISTROFUNCIONAL: TStringField;
    cdsAtendentesNOMERELATORIO: TStringField;
    cdsAtendentesSENHALOGIN: TStringField;
    cdsAtendentesATIVO: TStringField;
    cdsEmailsID: TIntegerField;
    cdsEmailsNOME: TStringField;
    cdsEmailsENDERECO: TStringField;
    cdsCelularesID: TIntegerField;
    cdsCelularesNOME: TStringField;
    cdsCelularesNUMERO: TStringField;
    cdsPAsID_PAINEL: TIntegerField;
    cdsFilasPOSICAO: TIntegerField;
    cdsPAsLKUP_GRUPO: TStringField;
    cdsPAsLKUP_PAINEL: TStringField;
    cdsPAsLKUP_FILAAUTOENCAMINHA: TStringField;
    cdsAtendentesLKUP_GRUPOATENDENTE: TStringField;
    cdsPAsPOSICAO: TIntegerField;
    cdsCelularesPREFIXO: TStringField;
    cdsPaineisTCPIP: TStringField;
    cdsPAsLKP_ATENDENTE: TStringField;
    cdsPAsID_ATENDENTE_AUTOLOGIN: TIntegerField;
    cdsFilasCODIGOCOR: TIntegerField;
    cdsFilasATIVO: TStringField;
    cdsFilasNOMENOTICKET: TStringField;
    cdsFilasGERACAOAUTOMATICA: TStringField;
    mnuPopGrid: TPopupMenu;
    mnuLimpar: TMenuItem;
    edBusca: TEdit;
    btnIncluirBusca: TSpeedButton;
    mnuItemCopiarCor: TMenuItem;
    mnuItemColarCor: TMenuItem;
    cdsTags: TClientDataSet;
    dspTags: TDataSetProvider;
    cdsGruposDeTags: TClientDataSet;
    dspGruposDeTags: TDataSetProvider;
    cdsTagsID: TIntegerField;
    cdsTagsNOME: TStringField;
    cdsTagsID_GRUPOTAG: TIntegerField;
    cdsTagsCODIGOCOR: TIntegerField;
    cdsGruposDeTagsID: TIntegerField;
    cdsGruposDeTagsNOME: TStringField;
    cdsTagsLKP_GRUPO: TStringField;
    cdsGruposDeTagsPOSICAO: TIntegerField;
    cdsTagsPOSICAO: TIntegerField;
    cdsTagsATIVO: TStringField;
    cdsGruposDeTagsATIVO: TStringField;
    cdsFilasNOMENOTOTEM: TStringField;
    qryAtendentes: TFDQuery;
    qryFilas: TFDQuery;
    qryGruposDePaineis: TFDQuery;
    qryPaineis: TFDQuery;
    qryGruposDePAs: TFDQuery;
    qryPAs: TFDQuery;
    qryGrupoDeAtendentes: TFDQuery;
    qryEmails: TFDQuery;
    qryCelulares: TFDQuery;
    qryTags: TFDQuery;
    qryGruposDeTags: TFDQuery;
    qryLkpModelosDePaineis: TFDQuery;
    cdsLkpGruposPAs: TClientDataSet;
    dspLkpGruposPAs: TDataSetProvider;
    qryLkpGruposPAs: TFDQuery;
    cdsLkpGruposAtendentes: TClientDataSet;
    dspLkpGruposAtendentes: TDataSetProvider;
    qryLkpGruposAtendentes: TFDQuery;
    cdsLkpGruposTags: TClientDataSet;
    dspLkpGruposTags: TDataSetProvider;
    qryLkpGruposTags: TFDQuery;
    cdsLkpFila: TClientDataSet;
    dspLkpFila: TDataSetProvider;
    qryLkpFila: TFDQuery;
    cdsLkpPainel: TClientDataSet;
    dspLkpPainel: TDataSetProvider;
    qryLkpPainel: TFDQuery;
    cdsLkpAtendentes: TClientDataSet;
    dspLkpAtendentes: TDataSetProvider;
    qryLkpAtendentes: TFDQuery;
    cdsTVs: TClientDataSet;
    IntegerField1: TIntegerField;
    StringField2: TStringField;
    dspTVs: TDataSetProvider;
    qryTVs: TFDQuery;
    cdsPPs: TClientDataSet;
    dspPPs: TDataSetProvider;
    qryPPs: TFDQuery;
    cdsPPsID: TIntegerField;
    cdsPPsID_GRUPOPP: TIntegerField;
    cdsPPsNOME: TStringField;
    cdsPPsCODIGOCOR: TIntegerField;
    cdsPPsPOSICAO: TIntegerField;
    cdsPPsATIVO: TStringField;
    cdsLkpGruposPPs: TClientDataSet;
    dspLkpGruposPPs: TDataSetProvider;
    qryLkpGruposPPs: TFDQuery;
    cdsPPsLKUP_GRUPO: TStringField;
    cdsGruposDePPs: TClientDataSet;
    dspGruposDePPs: TDataSetProvider;
    qryGruposDePPs: TFDQuery;
    cdsGruposDePPsID: TIntegerField;
    cdsGruposDePPsNOME: TStringField;
    cdsGruposDePPsPOSICAO: TIntegerField;
    cdsMotivosPausa: TClientDataSet;
    IntegerField2: TIntegerField;
    StringField1: TStringField;
    StringField3: TStringField;
    StringField4: TStringField;
    IntegerField4: TIntegerField;
    IntegerField5: TIntegerField;
    dspMotivosPausa: TDataSetProvider;
    qryMotivosPausa: TFDQuery;
    cdsGruposDeMotivosPausa: TClientDataSet;
    IntegerField6: TIntegerField;
    StringField5: TStringField;
    IntegerField7: TIntegerField;
    dspGruposDeMotivosPausa: TDataSetProvider;
    qryGruposDeMotivosPausa: TFDQuery;
    cdsMotivosPausaID_GRUPOMOTIVOSPAUSA: TIntegerField;
    cdsLkpGruposMotivosPausa: TClientDataSet;
    dspLkpGruposMotivosPausa: TDataSetProvider;
    qryLkpGruposMotivosPausa: TFDQuery;
    cdsPAsNOMEPORVOZ: TStringField;
    lytRodape: TLayout;
    btnIncluir: TButton;
    btnExcluir: TButton;
    btnApagarSenha: TButton;
    btnListagem: TButton;
    btnConfirmar: TButton;
    btnCancelar: TButton;
    gridGenerico: TGrid;
    btnSubir: TButton;
    btnDescer: TButton;
    LinkGridToDataSource1: TLinkGridToDataSource;
    dtsGenerico: TDataSource;
    bndDataSet: TBindSourceDB;
    lytBusca: TLayout;
    btnPrintCDB: TButton;
    qryClientes: TFDQuery;
    dspClientes: TDataSetProvider;
    cdsClientes: TClientDataSet;
    cdsClientesID: TIntegerField;
    cdsClientesNOME: TStringField;
    cdsClientesLOGIN: TStringField;
    cdsClientesSENHALOGIN: TStringField;
    cdsClientesATIVO: TStringField;
    cdsCache: TClientDataSet;
    btnCopiarNome: TButton;
    cdsAtendentesID_UNIDADE: TIntegerField;
    cdsGruposDePAsID_UNIDADE: TIntegerField;
    cdsFilasID_UNIDADE: TIntegerField;
    cdsFilasMETAESPERA: TSQLTimeStampField;
    cdsFilasIMPRIME_CDB: TStringField;
    cdsFilasLIMIAR_AMARELO: TTimeField;
    cdsFilasLIMIAR_VERMELHO: TTimeField;
    cdsFilasLIMIAR_LARANJA: TTimeField;
    cdsFilasTAMANHO_NOME_FILA: TIntegerField;
    cdsFilasNEGRITO_NOME_FILA: TStringField;
    cdsFilasITALICO_NOME_FILA: TStringField;
    cdsFilasSUBLINHADO_NOME_FILA: TStringField;
    cdsFilasCOR_NOME_FILA: TIntegerField;
    cdsFilasIMAGEM_FILA: TBlobField;
    cdsFilasALINHAMENTO_IMAGEM: TIntegerField;
    cdsFilasCONTADOR: TIntegerField;
    cdsGruposDePaineisID_UNIDADE: TIntegerField;
    cdsPAsID_UNIDADE: TIntegerField;
    cdsPAsOBEDECERSEQUENCIAFILAS: TStringField;
    cdsGruposDeAtendentesID_UNIDADE: TIntegerField;
    cdsEmailsID_UNIDADE: TIntegerField;
    cdsCelularesID_UNIDADE: TIntegerField;
    cdsCelularesID_PUSH: TStringField;
    cdsCelularesPRATAFORMA: TStringField;
    cdsTagsID_UNIDADE: TIntegerField;
    cdsGruposDeTagsID_UNIDADE: TIntegerField;
    cdsTVsID_UNIDADE: TIntegerField;
    cdsTVsIPTV: TStringField;
    cdsTVsPORTATV: TIntegerField;
    cdsTVsULTIMAATUALIZACAO: TSQLTimeStampField;
    cdsTVsIDGRUPOTVSPLAYLISTS: TIntegerField;
    cdsTVsID_CANAL_TV_PADRAO: TIntegerField;
    cdsClientesID_UNIDADE: TIntegerField;
    cdsClientesLOGADO_NUMERO_MESA: TIntegerField;
    cdsGruposDeMotivosPausaID_UNIDADE: TIntegerField;
    cdsMotivosPausaID_UNIDADE: TIntegerField;
    cdsPaineisID_UNIDADE: TIntegerField;
    cdsPaineisMENSAGEM: TMemoField;
    cdsPaineisID_CANAL_TV: TIntegerField;
    cdsPPsID_UNIDADE: TIntegerField;
    cdsGruposDePPsID_UNIDADE: TIntegerField;
    qryAtendentesID_UNIDADE: TIntegerField;
    qryAtendentesID: TIntegerField;
    qryAtendentesID_GRUPOATENDENTE: TIntegerField;
    qryAtendentesNOME: TStringField;
    qryAtendentesLOGIN: TStringField;
    qryAtendentesREGISTROFUNCIONAL: TStringField;
    qryAtendentesNOMERELATORIO: TStringField;
    qryAtendentesSENHALOGIN: TStringField;
    qryAtendentesATIVO: TStringField;
    procedure btnConfirmarClick(Sender: TObject);
    procedure dspGenericoBeforeUpdateRecord(Sender: TObject;
      SourceDS: TDataSet; DeltaDS: TCustomClientDataSet;
      UpdateKind: TUpdateKind; var Applied: Boolean);
    procedure cdsGenericoReconcileError(DataSet: TCustomClientDataSet;
      E: EReconcileError; UpdateKind: TUpdateKind;
      var Action: TReconcileAction);
    procedure cdsGenericoBeforePost(DataSet: TDataSet);
    procedure btnApagarSenhaClick(Sender: TObject);
    procedure dsGenericoStateChange(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnIncluirClick(Sender: TObject);
    procedure btnSubirClick(Sender: TObject);
    procedure cdsFilasBeforeInsert(DataSet: TDataSet);
    procedure cdsFilasNewRecord(DataSet: TDataSet);
    procedure mnuLimparClick(Sender: TObject);
    procedure mnuPopGridPopup(Sender: TObject);
    procedure btnListagemClick(Sender: TObject);
    procedure cdsAtendentesFilterRecord(DataSet: TDataSet;
      var Accept: Boolean);
    procedure btnIncluirBuscaClick(Sender: TObject);
    procedure edBuscaExit(Sender: TObject);
    procedure mnuItemCopiarCorClick(Sender: TObject);
    procedure mnuItemColarCorClick(Sender: TObject);
    procedure edBuscaKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure gridGenericoDrawColumnCell(Sender: TObject; const Canvas: TCanvas;
      const Column: TColumn; const Bounds: TRectF; const Row: Integer;
      const Value: TValue; const State: TGridDrawStates);
    procedure edBuscaKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure FrameResize(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnPrintCDBClick(Sender: TObject);
    procedure gridGenericoSelectCell(Sender: TObject; const ACol,
      ARow: Integer; var CanSelect: Boolean);
    procedure gridGenericoCellDblClick(const Column: TColumn;
      const Row: Integer);
    procedure cdsAtendentesReconcileError(DataSet: TCustomClientDataSet; E: EReconcileError; UpdateKind: TUpdateKind;
      var Action: TReconcileAction);
    procedure btnCopiarNomeClick(Sender: TObject);
    procedure gridGenericoHeaderClick(Column: TColumn);
  private
    FPrimeiraInicializacao: Boolean;
    procedure Inicializar;
    procedure PrepararColunasAtendentes;
    procedure PrepararColunasClientes;
  protected
    { Private declarations }
    FLastPosicao: Integer;
    FCopyColor: Longint;
    FConfigurandoTabela: TTabelaSics;
    FIndexColunaSelecionada : integer;
    procedure TrocaPosicao(PosAtual: Integer; Incrementa: Boolean);
    procedure GravarCorNoCampo(Cor: TAlphaColor);
    procedure SetConfigurandoTabela(const Value: TTabelaSics);
    procedure SetIDUnidade(const Value: Integer); Override;

  public
    ProcUnidade: TProcIDUnidade;
    {$IFNDEF IS_MOBILE}
    cldCorgeral: TColorDialog;
    {$ENDIF IS_MOBILE}
    function ValidacaoAtivaModoConectado: Boolean; Override;
    property ConfigurandoTabela: TTabelaSics read FConfigurandoTabela write SetConfigurandoTabela;
    constructor Create(AOwner: TComponent); overload; override;
    procedure ExibirOcultarCampoBusca(const aExibir: Boolean);
    procedure OrdenarGrid(DataSet: TDataSet; Campo: TField);
  end;

function FrmSicsConfiguraTabela(const aIDUnidade: integer; const aAllowNewInstance: Boolean = False; const aOwner: TComponent = nil): TFrmSicsConfiguraTabela;

implementation

uses
  {$IFDEF SuportaQuickRep}
  uqrCfgGenerica,
  {$ENDIF SuportaQuickRep}
  untCommonDMConnection, Sics_Common_Parametros, untCommonDMUnidades,untCommonFormSelecaoGrupoAtendente,
  ASPGenerator, System.StrUtils;

{$R *.fmx}

function FrmSicsConfiguraTabela(const aIDUnidade: integer; const aAllowNewInstance: Boolean = False; const aOwner: TComponent = nil): TFrmSicsConfiguraTabela;
begin
  Result := TfrmSicsConfiguraTabela(TfrmSicsConfiguraTabela.GetInstancia(aIDUnidade, aAllowNewInstance, aOwner));
end;

procedure TfrmSicsConfiguraTabela.btnPrintCDBClick(Sender: TObject);
var
  LChar: Char;
begin
  inherited;

  LChar := #0;
  case ConfigurandoTabela of
    ctFilas      : LChar := 'F';
    ctPAs        : LChar := 'P';
    ctAtendentes : LChar := 'A';
  end;  { case }

  if LChar <> #0 then
  begin
    DMConnection(IdUnidade, not CRIAR_SE_NAO_EXISTIR)
      .EnviarComando(cProtocoloPAVazia + Chr($76) + LChar +
                     (dsGenerico.DataSet as TClientDataSet).FieldByName('ID').AsString,
                     IdUnidade);

    AppMessageBox('Comando enviado para o servidor. Cheque a impressão do código no totem ou impressora de senhas.', 'Confirmação', MB_ICONINFORMATION);
  end;
end;


procedure TfrmSicsConfiguraTabela.btnConfirmarClick(Sender: TObject);
begin
  with (dsGenerico.DataSet as TClientDataSet) do
  begin
    if State in dsEditModes then
    begin
      UpdateRecord;
      Post;
    end;

    if ChangeCount > 0 then
    begin
      if ApplyUpdates(0) = 0 then
      begin
          // ****************************************************************************************************
          // GOT 14/11/2014
          // após ApplyUpdates verifica se o form genérico está configurando PAs ou Atendentes ...
          // ****************************************************************************************************
          if ConfigurandoTabela in [ctPAs, ctAtendentes] then
          begin
            if (ConfigurandoTabela = ctPAs) then
            begin
              with FraSituacaoAtendimento(idUnidade).cdsPAs do
              begin
                cdsPAs.First;
                while not cdsPAs.Eof do
                begin
                  // ****************************************************************************************************
                  // verifica todas as PAs ATIVAS no banco de dados e caso exista na situação do atendimento
                  // atualiza "Nome, Grupo e Posição", se não existir insere a nova PA na lista.
                  // ****************************************************************************************************
                  if (cdsPAsATIVO.AsString = 'T') then
                  begin
                    if Locate('ID_PA',cdsPAsID.AsInteger,[]) then
                    begin
                      Edit;
                      if cdsPAsID_ATENDENTE_AUTOLOGIN.IsNull then
                        FieldByName('ID_ATENDENTE_AUTOLOGIN').Clear
                      else
                        FieldByName('ID_ATENDENTE_AUTOLOGIN').AsInteger := cdsPAsID_ATENDENTE_AUTOLOGIN.AsInteger;
                      FieldByName('Ativo').AsBoolean := true;
                      FieldByName('POSICAO').AsInteger := cdsPAsPOSICAO.AsInteger;
                      Post;
                    end else
                    begin
                      Append;
                      FieldByName('Id_PA').AsInteger      := cdsPAsID.AsInteger;
                      FieldByName('Horario').AsDateTime   := Now;
                      FieldByName('Id_Status').AsInteger  := 0;
                      if cdsPAsID_ATENDENTE_AUTOLOGIN.IsNull then
                        FieldByName('ID_ATENDENTE_AUTOLOGIN').Clear
                      else
                        FieldByName('ID_ATENDENTE_AUTOLOGIN').AsInteger := cdsPAsID_ATENDENTE_AUTOLOGIN.AsInteger;
                      FieldByName('Ativo').AsBoolean := true;
                      FieldByName('POSICAO').AsInteger  := cdsPAsPOSICAO.AsInteger;
                      Post;
                    end;
                  end;
                  cdsPAs.Next;
                end;

                // ****************************************************************************************************
                // verifica todas as PAs na situação do atendimento e exclui da lista caso não exista mais ou esteja
                // inativa no banco de dados.
                // ****************************************************************************************************
                First;
                while not Eof do
                begin
                  if (not cdsPAs.Locate('ID',FieldByName('Id_PA').AsInteger,[])) or (cdsPAsATIVO.AsString <> 'T') then
                    Delete
                  else
                    Next;
                end;
              end;
            end else
            if (ConfigurandoTabela = ctAtendentes) then
            begin
              with FraSituacaoAtendimento(idUnidade).cdsAtds do
              begin
                cdsAtendentes.First;
                while not cdsAtendentes.Eof do
                begin
                  // ****************************************************************************************************
                  // verifica todas os Atendentes ativos no banco de dados e caso exista na situação do atendimento
                  // atualiza "Nome, Grupo e Posição", se não existir insere o novo atendente na lista.
                  // ****************************************************************************************************
                  if (cdsAtendentesATIVO.AsString = 'T') then
                  begin
                    if Locate('ID_ATD',cdsAtendentesID.AsInteger,[]) then
                    begin
                      //nenhum campo a ser editado caso já exista
                    end else
                    begin
                      Append;
                      FieldByName('ID_ATD').AsInteger     := cdsAtendentesID.AsInteger;
                      FieldByName('Horario').AsDateTime   := Now;
                      FieldByName('Id_Status').AsInteger  := 0;
                      Post;
                    end;
                  end;
                  cdsAtendentes.Next;
                end;

                // ****************************************************************************************************
                // verifica todos os atendentes na situação do atendimento e exclui da lista caso não exista mais ou esteja
                // inativo no banco de dados.
                // ****************************************************************************************************
                First;
                while not Eof do
                begin
                  if (not cdsAtendentes.Locate('ID',FieldByName('ID_ATD').AsInteger,[])) or (cdsAtendentesATIVO.AsString <> 'T') then
                    Delete
                  else
                    Next;
                end;
              end;

              // ****************************************************************************************************
              // atualiza RT
              // ****************************************************************************************************
              DMConnection(IDUnidade, not CRIAR_SE_NAO_EXISTIR)
                .EnviarComando(cProtocoloPAVazia + Chr($7A) + 'A', IdUnidade);
            end;
          end;

        try
          Refresh;
        except
          {
           Eduardo Rocha
           No cadastro de filas, quando incluia uma fila e MOVIA outros registros (com as setas)
           ao tentar fazer o refresh aqui dava o seguinte erro:
           cdsFilas: Must apply updates before refreshing data
           Acredito ser um bug do clientdataset, nao consegui descobrir,
           o importante eh que pelo menos está gravando corretamente
          }
        end;

        if Assigned(ProcUnidade) then
          ProcUnidade(idUnidade);
      end
    end;
  end;
  Visible := False;
end;


procedure TfrmSicsConfiguraTabela.btnCopiarNomeClick(Sender: TObject);
begin
  inherited;
  if cdsAtendentes.Active then
  begin
    cdsAtendentes.First;

    while not cdsAtendentes.Eof do
    begin
      if  cdsAtendentes.FieldByName('LOGIN').AsString.Trim.IsEmpty then
      begin
        if not(cdsAtendentes.State = dsEdit) then
        begin
          cdsAtendentes.Edit;
        end;

        cdsAtendentes.FieldByName('LOGIN').AsString := cdsAtendentes.FieldByName('NOME').AsString;
        cdsAtendentes.Post;
      end;

      cdsAtendentes.Next;
    end;
  end;

  if cdsClientes.Active then
  begin
    cdsClientes.First;

    while not cdsClientes.Eof do
    begin
      if cdsClientes.FieldByName('LOGIN').AsString.Trim.IsEmpty then
      begin
        if not(cdsClientes.State = dsEdit) then
        begin
          cdsClientes.Edit;
        end;

        cdsClientes.FieldByName('LOGIN').AsString := cdsClientes.FieldByName('NOME').AsString;
        cdsClientes.Post;
      end;

      cdsClientes.Next;
    end;
  end;
end;

procedure TfrmSicsConfiguraTabela.btnCancelarClick(Sender: TObject);
begin
  inherited;
  (dsGenerico.DataSet as TClientDataSet).CancelUpdates;
  Visible := False;
end;

procedure TfrmSicsConfiguraTabela.dspGenericoBeforeUpdateRecord (Sender: TObject; SourceDS: TDataSet; DeltaDS: TCustomClientDataSet;
                                                             UpdateKind: TUpdateKind; var Applied: Boolean);
VAR
  FSqlConnUnidade: TFDConnection;
begin
  FSqlConnUnidade := DMClient(IDUnidade, not CRIAR_SE_NAO_EXISTIR).connDMClient;
  if UpdateKind = ukInsert then
    case ConfigurandoTabela of
      ctFilas                : DeltaDS.FieldByName('ID').NewValue := TGenerator.NGetNextGenerator('GEN_ID_FILA'            , FSqlConnUnidade);
      ctGruposDePaineis      : DeltaDS.FieldByName('ID').NewValue := TGenerator.NGetNextGenerator('GEN_ID_GRUPOPAINEL'     , FSqlConnUnidade);
      ctPaineis              : DeltaDS.FieldByName('ID').NewValue := TGenerator.NGetNextGenerator('GEN_ID_PAINEL'          , FSqlConnUnidade);
      ctGruposDePAs          : DeltaDS.FieldByName('ID').NewValue := TGenerator.NGetNextGenerator('GEN_ID_GRUPOPA'         , FSqlConnUnidade);
      ctPAs                  : DeltaDS.FieldByName('ID').NewValue := TGenerator.NGetNextGenerator('GEN_ID_PA'              , FSqlConnUnidade);
      ctGruposDeAtendentes   : DeltaDS.FieldByName('ID').NewValue := TGenerator.NGetNextGenerator('GEN_ID_GRUPOATENDENTE'  , FSqlConnUnidade);
      ctAtendentes           : DeltaDS.FieldByName('ID').NewValue := TGenerator.NGetNextGenerator('GEN_ID_ATENDENTE'       , FSqlConnUnidade);
      ctClientes             : DeltaDS.FieldByName('ID').NewValue := TGenerator.NGetNextGenerator('GEN_ID_CLIENTE'         , FSqlConnUnidade);
      ctEmails               : DeltaDS.FieldByName('ID').NewValue := TGenerator.NGetNextGenerator('GEN_ID_EMAIL'           , FSqlConnUnidade);
      ctCelulares            : DeltaDS.FieldByName('ID').NewValue := TGenerator.NGetNextGenerator('GEN_ID_CELULAR'         , FSqlConnUnidade);
      ctTags                 : DeltaDS.FieldByName('ID').NewValue := TGenerator.NGetNextGenerator('GEN_ID_TAG'             , FSqlConnUnidade);
      ctGruposTags           : DeltaDS.FieldByName('ID').NewValue := TGenerator.NGetNextGenerator('GEN_ID_GRUPOTAG'        , FSqlConnUnidade);
      ctTVs                  : DeltaDS.FieldByName('ID').NewValue := TGenerator.NGetNextGenerator('GEN_ID_TV'              , FSqlConnUnidade);
      ctPPs                  : DeltaDS.FieldByName('ID').NewValue := TGenerator.NGetNextGenerator('GEN_ID_PP'              , FSqlConnUnidade);
      ctGruposDePPs          : DeltaDS.FieldByName('ID').NewValue := TGenerator.NGetNextGenerator('GEN_ID_GRUPOPP'         , FSqlConnUnidade);
      ctMotivosPausa         : DeltaDS.FieldByName('ID').NewValue := TGenerator.NGetNextGenerator('GEN_ID_MOTIVOPAUSA'     , FSqlConnUnidade);
      ctGruposDeMotivosPausa : DeltaDS.FieldByName('ID').NewValue := TGenerator.NGetNextGenerator('GEN_ID_GRUPOMOTIVOPAUSA', FSqlConnUnidade);
    end;  { case }
end;


procedure TfrmSicsConfiguraTabela.cdsGenericoBeforePost(DataSet: TDataSet);
var
  lID: Integer;
begin
  if DataSet.FieldByName('ID').IsNull then
  begin
    if DataSet is TClientDataSet then
    begin
      cdsCache.IndexFieldNames := 'ID';

      cdsCache.First;

      lID := (cdsCache.FieldByName('ID').AsInteger - 1);

      if lID >= 0 then lID := -1;

      cdsCache.Close;
    end
    else
    begin
      lID := -1;
    end;

    DataSet.FieldByName('ID').AsInteger := lID;
  end;

  if (FieldExists(DataSet, 'SENHALOGIN')) and (DataSet.FieldByName('SENHALOGIN').AsString = '') then
  begin
    DataSet.FieldByName('SENHALOGIN').AsString := TextHash(DataSet.FieldByName('SENHALOGIN').AsString);
  end;
end;


procedure TfrmSicsConfiguraTabela.cdsGenericoReconcileError (DataSet: TCustomClientDataSet; E: EReconcileError;
                                                         UpdateKind: TUpdateKind; var Action: TReconcileAction);
begin
  MyLogException(E);
end;


constructor TfrmSicsConfiguraTabela.Create(AOwner: TComponent);
begin
  inherited;
  FPrimeiraInicializacao := True;
  {$IFNDEF IS_MOBILE}
  cldCorgeral := TColorDialog.Create(Self);
  cldCorgeral.Options := [cdFullOpen];
  {$ENDIF IS_MOBILE}
  btnlistagem.Enabled := {$IFDEF SuportaQuickRep}True;{$ELSE}False;{$ENDIF SuportaQuickRep}
  ProcUnidade := nil;
  FConfigurandoTabela := ctNone;
end;

procedure TfrmSicsConfiguraTabela.btnApagarSenhaClick(Sender: TObject);
var
  FOldRecno: Integer;
  LDataSet : TDataSet;
begin
  if ConfigurandoTabela = ctAtendentes then
    LDataSet := cdsAtendentes
  else
  if ConfigurandoTabela = ctClientes then
    LDataSet := cdsClientes
  else
    exit;

  with LDataSet do
  begin
    if  (RecordCount > 0) then
    begin
      FOldRecno := RecNo;

      ConfirmationMessage(Format('Apagar senha de %s - %s?',[FieldByName('ID').AsString,FieldByName('NOME').AsString]),
        procedure (const aOK: Boolean)
        begin
          if aOK then
          begin
            if (FOldRecno = RecNo) then
            begin
              Edit;
              FieldByName('SENHALOGIN').AsString := TextHash('');
              Post;
            end
            else
              ErrorMessage(Format('Contexto foi modificado. Posição de %d para %d.', [FOldRecno, RecNo]));
          end;
        end);
    end;
  end;
end;


procedure TfrmSicsConfiguraTabela.dsGenericoStateChange(Sender: TObject);
begin
  if ConfigurandoTabela = ctAtendentes then
    btnApagarSenha.Enabled := (cdsAtendentes.State = dsBrowse)
  else if ConfigurandoTabela = ctClientes then
    btnApagarSenha.Enabled := (cdsClientes.State = dsBrowse)
  else  
    btnApagarSenha.Enabled := False;   

  if ((dsGenerico.State = dsInsert) and (dsGenerico.DataSet.FindField('ATIVO') <> nil)) then
    dsGenerico.DataSet.FieldByName('ATIVO').AsBoolean := true;
end;


procedure TfrmSicsConfiguraTabela.btnExcluirClick(Sender: TObject);
var
  LOldRecno: Integer;
begin
  if not (dsGenerico.DataSet.Active and (dsGenerico.DataSet.RecordCount > 0)) then
    Exit;
  LOldRecno := dsGenerico.DataSet.RecNo;
  ConfirmationMessage('Deseja excluir "' + dsGenerico.DataSet.FieldByName('NOME').AsString + '" ?',
    procedure (const aOK: Boolean)
    begin
      if aOK then
      begin
        if (LOldRecno = dsGenerico.DataSet.RecNo) then
          dsGenerico.DataSet.Delete
        else
          ErrorMessage(Format('Contexto foi alterado. Registro de %d para %d.', [LOldRecno, dsGenerico.DataSet.RecNo]));
      end;
    end);
end;


procedure TfrmSicsConfiguraTabela.btnIncluirClick(Sender: TObject);
begin
  ExibirOcultarCampoBusca(True);
end;

procedure TfrmSicsConfiguraTabela.TrocaPosicao(PosAtual: Integer; Incrementa: Boolean);
var
  PosNova: integer;
begin
  with dsGenerico.DataSet do
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

function TfrmSicsConfiguraTabela.ValidacaoAtivaModoConectado: Boolean;
begin
  Result := cNaoPossuiConexaoDiretoDB;
end;

procedure TfrmSicsConfiguraTabela.btnSubirClick(Sender: TObject);
begin
  if dsGenerico.DataSet.FindField('POSICAO') <> nil then
    with dsGenerico.DataSet do
      if ((Sender = btnSubir) and (RecNo <> 1)) then
        TrocaPosicao(FieldByName('POSICAO').AsInteger, False)
      else if Sender = btnDescer then
        TrocaPosicao(FieldByName('POSICAO').AsInteger, True);
end;


procedure TfrmSicsConfiguraTabela.cdsFilasBeforeInsert(DataSet: TDataSet);
begin
  with DataSet do
  begin
    if FindField('POSICAO') <> nil then
    begin
      Last;
      FLastPosicao := FieldByName('POSICAO').AsInteger;
    end;

    if FindField('ID') <> nil then
    begin
      if DataSet is TClientDataSet then
      begin
        cdsCache.XMLData := TClientDataSet(DataSet).XMLData;
      end;
    end;
  end;
end;

procedure TfrmSicsConfiguraTabela.gridGenericoCellDblClick(
  const Column: TColumn; const Row: Integer);
var
   nomeCampo : string;
begin
  {$IFNDEF IS_MOBILE}
  if gridGenerico.GetFieldNameByColumn(gridGenerico.SelectedColumn, bndList) = 'CODIGOCOR' then
  begin
     cldCorgeral.Color := TColor(dsGenerico.DataSet.FieldByName('CODIGOCOR').AsInteger);
     if (cldCorgeral.Execute) Then
       GravarCorNoCampo(cldCorgeral.Color);
  end;

  nomeCampo := gridGenerico.GetFieldNameByColumn(gridGenerico.ColumnByIndex(FIndexColunaSelecionada), bndList);
  if((nomeCampo = 'LKUP_GRUPOATENDENTE') or (nomeCampo = 'ID_GRUPOATENDENTE'))then
  begin
     FrmSelecaoGrupoAtendente(IDUnidade).ShowModal(
      procedure(aResult: TModalResult)
      begin
        if (aResult = mrOk) then
        begin
          with FrmSicsConfiguraTabela(IDUnidade) do
          begin
            if not(dsGenerico.DataSet.State in [dsInsert,dsEdit])then
              dsGenerico.DataSet.Edit;

            dsGenerico.DataSet.FieldByName('ID_GRUPOATENDENTE').AsInteger := FrmSelecaoGrupoAtendente(IDUnidade).IdSelecionado;
            dsGenerico.DataSet.Post;
          end;
        end;
      end
     );
  end;
  {$ENDIF IS_MOBILE}
end;

procedure TfrmSicsConfiguraTabela.gridGenericoDrawColumnCell(Sender: TObject;
  const Canvas: TCanvas; const Column: TColumn; const Bounds: TRectF;
  const Row: Integer; const Value: TValue; const State: TGridDrawStates);
begin
  inherited;

    if (((Sender AS Tgrid).GetFieldNameByColumn(Column, bndList) = 'CODIGOCOR') and Assigned(dsGenerico.DataSet)) Then
      Canvas.fill.Color := TColor(dsGenerico.DataSet.FieldByName('CODIGOCOR').AsInteger)
    else
      Canvas.fill.Color := claBtnFace;

  Column.DefaultDrawCell(Canvas, Bounds, Row, Value, State);
end;

procedure TfrmSicsConfiguraTabela.gridGenericoHeaderClick(Column: TColumn);
begin
  inherited;
  gridGenerico.BeginUpdate;
  try
    OrdenarGrid(cdsAtendentes, cdsAtendentes.Fields[Column.Index]);
  finally
    gridGenerico.EndUpdate;
  end;
end;

procedure TfrmSicsConfiguraTabela.gridGenericoSelectCell(Sender: TObject;
  const ACol, ARow: Integer; var CanSelect: Boolean);
begin
  inherited;
 // ShowMessage(Inttostr(ACol));
 FIndexColunaSelecionada := ACol;
end;

procedure TfrmSicsConfiguraTabela.cdsFilasNewRecord(DataSet: TDataSet);
begin
  with DataSet do
  begin
    if FindField('POSICAO') <> nil then
    begin
      FieldByName('POSICAO').AsInteger := FLastPosicao + 1;
    end;

    if DataSet = cdsPAS then
    begin
      DataSet.FieldByName('MAGAZINE').AsInteger := 1;
    end;
  end;
end;

procedure TfrmSicsConfiguraTabela.ExibirOcultarCampoBusca(const aExibir: Boolean);
const
  OFF = 10;
begin
  lytBusca.Visible         := aExibir;

  if aExibir then
    edBusca.SetFocus
  else
  begin
    edBusca.Text := '';
    dsGenerico.DataSet.Filtered := False;
  end;
end;

procedure TfrmSicsConfiguraTabela.FrameResize(Sender: TObject);
const
  OFF = 10;
  FIXEDCOLWIDTH = 10;
begin
  if (csLoading in self.componentstate) then
    Exit;
  inherited;

  btnSubir.Visible      := ConfigurandoTabela in [ctFilas, ctPAs, ctGruposTags, ctTags, ctPPs, ctGruposDePPs, ctMotivosPausa, ctGruposDeMotivosPausa];
  btnDescer.Visible     := btnSubir.Visible;
  btnCopiarNome.Visible := ConfigurandoTabela in [ctAtendentes, ctClientes];

  btnSubir.Position.X   := gridGenerico.Position.X + gridGenerico.Width + OFF;
  btnSubir.Position.Y   := gridGenerico.Position.Y;
  btnDescer.Position.X  := btnSubir.Position.X;
  btnDescer.Position.Y  := btnSubir.Position.Y + btnSubir.Height + OFF;
end;

procedure TfrmSicsConfiguraTabela.mnuLimparClick(Sender: TObject);
var
  bOldReadOnly: Boolean;
  LSelectedField: TField;
  SelectedColumn: TColumn;
begin
  if not (Assigned(dsGenerico.DataSet) and dsGenerico.DataSet.Active) then
    Exit;

  SelectedColumn := gridGenerico.SelectedColumn;
  if not Assigned(SelectedColumn) then
    Exit;

  LSelectedField := dtsGenerico.DataSet.FindField((Sender as TGrid).GetFieldNameByColumn(SelectedColumn, bndList));
  if not Assigned(LSelectedField) then
    Exit;

  with dsGenerico.DataSet do
  begin
    if not (State in dsEditModes) then Edit;

    bOldReadOnly := LSelectedField.ReadOnly;
    LSelectedField.ReadOnly := False;
    try
      if LSelectedField.FieldKind = fkLookup then
        FieldByName(LSelectedField.KeyFields).Clear
      else
        LSelectedField.Clear;
    finally
      LSelectedField.ReadOnly := bOldReadOnly;
    end;
  end;
end;

procedure TfrmSicsConfiguraTabela.mnuPopGridPopup(Sender: TObject);
var
  LSelectedColumn: TColumn;
  LFieldNameColuna: String;
begin
  LSelectedColumn := gridGenerico.SelectedColumn;
  LFieldNameColuna := gridGenerico.GetFieldNameByColumn(LSelectedColumn, bndList);
  with mnuLimpar do
  begin
    Visible := (dtsGenerico.DataSet.FieldByName(LFieldNameColuna).FieldKind = fkLookup) or
               (LFieldNameColuna = 'CODIGOCOR');
    Enabled := Visible and (dtsGenerico.DataSet.FieldByName(LFieldNameColuna).AsInteger <> 0);
  end;

  with mnuItemColarCor do
  begin
    Visible := LFieldNameColuna = 'CODIGOCOR';
    Enabled := Visible and (FCopyColor <> -1);
  end;

  with mnuItemCopiarCor do
  begin
    Visible := LFieldNameColuna = 'CODIGOCOR';
    Enabled := Visible and (not dtsGenerico.DataSet.FieldByName(LFieldNameColuna).IsNull);
  end;
end;

procedure TfrmSicsConfiguraTabela.OrdenarGrid(DataSet: TDataSet; Campo: TField);
var
  LMesmoCampo: Boolean;
  LIndices:    TStrings;
  LiCont:      Integer;
begin
  if Campo.FieldKind <> fkLookup then
  begin
    LMesmoCampo := False;
    LIndices    := TStringList.Create;
    TClientDataSet(DataSet).GetIndexNames(LIndices);
    TClientDataSet(DataSet).IndexName := EmptyStr;
    LiCont := LIndices.IndexOf('idx' + Campo.FieldName);
    if LiCont >= 0 then
    begin
      LMesmoCampo := not (ixDescending in TClientDataSet(DataSet).IndexDefs[LiCont].Options);
      TClientDataSet(DataSet).DeleteIndex('idx' + Campo.FieldName);
    end;
    TClientDataSet(DataSet).AddIndex('idx' + Campo.FieldName, Campo.FieldName, [], IfThen(LMesmoCampo, Campo.FieldName, ''));
    TClientDataSet(DataSet).IndexName := 'idx' + Campo.FieldName;
    TClientDataSet(DataSet).First;
  end
  else
  begin
    ShowMessage('Ação indisponível para está coluna.');
  end;
end;

procedure TfrmSicsConfiguraTabela.SetConfigurandoTabela(const Value: TTabelaSics);
begin
  FConfigurandoTabela := Value;

  case Value of
    ctFilas                : begin
                               dsGenerico.DataSet := cdsFilas;
                               lblConfigTabela.Text := 'Filas:';
                               Self.Caption := 'Configuração das Filas';
                             end;
    ctGruposDePaineis      : begin
                               dsGenerico.DataSet := cdsGruposDePaineis;
                               lblConfigTabela.Text := 'Grupos de painéis:';
                               Self.Caption := 'Configuração dos Grupos de Painéis';
                             end;
    ctPaineis              : begin
                               dsGenerico.DataSet := cdsPaineis;
                               lblConfigTabela.Text := 'Painéis:';
                               Self.Caption := 'Configuração dos Painéis';
                               cdsLkpModelosDePaineis.Open;
                             end;
    ctGruposDePAs          : begin
                               dsGenerico.DataSet := cdsGruposDePAs;
                               lblConfigTabela.Text := 'Grupos de PAs:';
                               Self.Caption := 'Configuração dos Grupos de PAs';
                             end;
    ctPAs                  : begin
                               dsGenerico.DataSet := cdsPAs;
                               lblConfigTabela.Text := 'PAs:';
                               Self.Caption := 'Configuração das Posições de Atendimento';
                               cdsLkpGruposPAs.Open;
                               cdsLkpPainel.Open;
                               cdsLkpFila.Open;
                               cdsLkpAtendentes.Open;
                             end;
    ctGruposDeAtendentes   : begin
                               dsGenerico.DataSet := cdsGruposDeAtendentes;
                               lblConfigTabela.Text := 'Grupos de atendentes:';
                               Self.Caption := 'Configuração dos Grupos de Atendentes';
                             end;
    ctAtendentes           : begin
                               if vgParametrosModulo.ModoCallCenter then
                               begin
                                 lblConfigTabela.Text := 'Coordenadores:';
                                 Self.Caption := 'Configuração dos Coordenadores';
                               end
                               else
                               begin
                                 lblConfigTabela.Text := 'Atendentes:';
                                 Self.Caption := 'Configuração dos Atendentes';
                               end;
                               dsGenerico.DataSet := cdsAtendentes;
                               cdsLkpGruposAtendentes.Open;
                              end;
    ctClientes             : begin
                               dsGenerico.DataSet := cdsClientes;
                               lblConfigTabela.Text := 'Atendentes:';
                               Self.Caption := 'Configuração dos Atendentes';
                             end;
    ctEmails               : begin
                               dsGenerico.DataSet := cdsEmails;
                               lblConfigTabela.Text := 'E-mails:';
                               Self.Caption := 'Configuração dos E-mails';
                             end;
    ctCelulares            : begin
                               dsGenerico.DataSet := cdsCelulares;
                               lblConfigTabela.Text := 'Celulares:';
                               Self.Caption := 'Configuração dos Celulares';
                             end;

    ctTags                 : begin
                               dsGenerico.DataSet := cdsTags;
                               lblConfigTabela.Text := 'Tags:';
                               Self.Caption := 'Configuração das Tags';
                               cdsLkpGruposTags.Open;
                             end;

    ctGruposTags           : begin
                               dsGenerico.DataSet := cdsGruposDeTags;
                               lblConfigTabela.Text := 'Grupos de Tags:';
                               Self.Caption := 'Configuração dos Grupos de Tags';
                             end;

    ctTVS                  : begin
                               dsGenerico.DataSet := cdsTVS;
                               lblConfigTabela.Text := 'TVs:';
                               Self.Caption := 'Configuração de TVs';
                             end;

    ctGruposDePPs          : begin
                               dsGenerico.DataSet := cdsGruposDePPs;
                               lblConfigTabela.Text := 'Grupos de Processos Paralelos:';
                               Self.Caption := 'Configuração dos Grupos de Tipos de Processos Paralelos';
                             end;

    ctPPs                  : begin
                               dsGenerico.DataSet := cdsPPs;
                               lblConfigTabela.Text := 'Processos Paralelos:';
                               Self.Caption := 'Configuração dos Tipos de Processos Paralelos';
                               cdsLkpGruposPPs.Open;
                             end;

    ctGruposDeMotivosPausa : begin
                               dsGenerico.DataSet := cdsGruposDeMotivosPausa;
                               lblConfigTabela.Text := 'Grupos de Motivos de Pausa:';
                               Self.Caption := 'Configuração dos Grupos de Motivos de Pausa';
                             end;

    ctMotivosPausa         : begin
                               dsGenerico.DataSet := cdsMotivosPausa;
                               lblConfigTabela.Text := 'Motivos de Pausa:';
                               Self.Caption := 'Configuração dos Motivos de Pausa';
                               cdsLkpGruposMotivosPausa.Open;
                             end;
  end;  { case }

  btnPrintCDB.Visible := Value in [ctFilas, ctPAs, ctAtendentes];

  btnApagarSenha.Visible := Value in [ctAtendentes, ctClientes];
  dtsGenerico.DataSet := dsGenerico.DataSet;
  bndDataSet.DataSet := dsGenerico.DataSet;
  FCopyColor := -1;
  
  if value = ctAtendentes then
  begin
    PrepararColunasAtendentes;
  end
  else if value = ctClientes then
  begin
    PrepararColunasClientes; 
  end
  else
    raise Exception.Create('Tabela não implementada.');

  if(dsGenerico.DataSet.State in [dsInactive])then
    dsGenerico.DataSet.Open
  else
  begin
    dsGenerico.DataSet.Close;
    dsGenerico.DataSet.Open;
  end;
  
  AspUpdateColunasGrid(Self, bndList);
  FrameResize(Self);
end;



procedure TfrmSicsConfiguraTabela.PrepararColunasAtendentes;
var
  LColumn : TLinkGridToDataSourceColumn;
begin
  LinkGridToDataSource1.Columns.Clear;

  LColumn := LinkGridToDataSource1.Columns.Add;
  LColumn.MemberName := 'ID';

  LColumn := LinkGridToDataSource1.Columns.Add;
  LColumn.MemberName := 'ATIVO';
  LColumn.ColumnStyle:= 'CheckColumn';

  LColumn := LinkGridToDataSource1.Columns.Add;
  LColumn.MemberName := 'NOME';

  LColumn := LinkGridToDataSource1.Columns.Add;
  LColumn.MemberName := 'ID_GRUPOATENDENTE';

  LColumn := LinkGridToDataSource1.Columns.Add;
  LColumn.MemberName := 'LKUP_GRUPOATENDENTE';

  LColumn := LinkGridToDataSource1.Columns.Add;
  LColumn.MemberName := 'LOGIN';

  LColumn := LinkGridToDataSource1.Columns.Add;
  LColumn.MemberName := 'REGISTROFUNCIONAL';

  LColumn := LinkGridToDataSource1.Columns.Add;
  LColumn.MemberName := 'NOMERELATORIO';

  LColumn := LinkGridToDataSource1.Columns.Add;
  LColumn.MemberName := 'SENHALOGIN';

  {
  LColumn := LinkGridToDataSource1.Columns.Add;
  LColumn.MemberName := 'TRIAGEM';
  LColumn.ColumnStyle:= 'CheckColumn';

  LColumn := LinkGridToDataSource1.Columns.Add;
  LColumn.MemberName := 'IMPRIMIRPULSEIRA';
  LColumn.ColumnStyle:= 'CheckColumn';

  LColumn := LinkGridToDataSource1.Columns.Add;
  LColumn.MemberName := 'FOTO';
  LColumn.ColumnStyle:= 'PopupColumn';
  }
end;

procedure TfrmSicsConfiguraTabela.PrepararColunasClientes;
var
  LColumn : TLinkGridToDataSourceColumn;
begin
  LinkGridToDataSource1.Columns.Clear;

  LColumn := LinkGridToDataSource1.Columns.Add;
  LColumn.MemberName := 'ID';

  LColumn := LinkGridToDataSource1.Columns.Add;
  LColumn.MemberName := 'ATIVO';
  LColumn.ColumnStyle:= 'CheckColumn';

  LColumn := LinkGridToDataSource1.Columns.Add;
  LColumn.MemberName := 'NOME';

  LColumn := LinkGridToDataSource1.Columns.Add;
  LColumn.MemberName := 'LOGIN';
end;


procedure TfrmSicsConfiguraTabela.SetidUnidade(const Value: Integer);
begin
  if (IDUnidade <> Value) or FPrimeiraInicializacao then
  begin
    inherited;
    Inicializar;
  end;
end;

procedure TfrmSicsConfiguraTabela.Inicializar;
begin
  if FPrimeiraInicializacao then
    FPrimeiraInicializacao := False;

  DMClient(IDUnidade, not CRIAR_SE_NAO_EXISTIR).SetNewSqlConnectionForSQLDataSet(Self);
  CloseOpenNosCDSsAtivos;
end;


procedure TfrmSicsConfiguraTabela.btnListagemClick(Sender: TObject);
{$IFDEF SuportaQuickRep}
var
  LqrSicsCfgGenerica: TqrSicsCfgGenerica;
begin
  LqrSicsCfgGenerica := TqrSicsCfgGenerica.Create(Self);
  try
    LqrSicsCfgGenerica.AjustarQR(ConfigurandoTabela, dsGenerico.DataSet);
    LqrSicsCfgGenerica.PreviewModal;
  finally
    FreeAndNil(LqrSicsCfgGenerica);
  end;
end;
{$ELSE}
begin
end;
{$ENDIF SuportaQuickRep}

procedure TfrmSicsConfiguraTabela.cdsAtendentesFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
  Accept :=
    (DataSet.Active) and
    ( (Trim(edBusca.Text) = '') or
      (Pos(LowerCase(edBusca.Text), LowerCase(DataSet.FieldByName('nome').AsString)) > 0)
    );
end;

procedure TfrmSicsConfiguraTabela.cdsAtendentesReconcileError(DataSet: TCustomClientDataSet; E: EReconcileError;
  UpdateKind: TUpdateKind; var Action: TReconcileAction);
begin
  inherited;
  if ((E.Message.ToUpper.Contains('FOREIGN KEY')) or (E.Message.ToLower.Contains('conflitou com a restrição'))) then
  begin
    MessageDlg('Não é possível excluir atendente, pois existem dependências em outras tabelas do banco de dados.' + sLineBreak +
               'Desative a atendente.', mtInformation, [mbOK], 0);
    cdsAtendentes.CancelUpdates;
    cdsAtendentes.Refresh;
  end;

  MyLogException(E);
end;

procedure TfrmSicsConfiguraTabela.btnIncluirBuscaClick(Sender: TObject);
var
  sNome: string;
  LColumnName: TColumn;
  LFieldName: TField;
begin
  sNome := edBusca.Text;
  ExibirOcultarCampoBusca(False);
  dsGenerico.DataSet.Append;
  LFieldName := dsGenerico.DataSet.FindField('NOME');
  if Assigned(LFieldName) then
  begin
    LFieldName.AsString := sNome;
    gridGenerico.SetFocus;
    LColumnName := gridGenerico.ColumnByHeader('NOME');
    if Assigned(LColumnName) then
      gridGenerico.SelectColumn(LColumnName.Index);
  end;
  dsGenerico.DataSet.Post;
end;

procedure TfrmSicsConfiguraTabela.edBuscaExit(Sender: TObject);
begin
  ExibirOcultarCampoBusca(False);
end;

procedure TfrmSicsConfiguraTabela.edBuscaKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  inherited;

  {$IFNDEF IS_MOBILE}
  if Key = VK_ESCAPE then
    ExibirOcultarCampoBusca(False);

  if Key = VK_RETURN then
    btnIncluirBuscaClick(Sender);
  {$ENDIF IS_MOBILE}
end;

procedure TfrmSicsConfiguraTabela.edBuscaKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  inherited;

  with dsGenerico.DataSet do
  begin
    Filtered := False;
    Filtered := True;
  end;

  if (KeyChar = #13) then
    btnIncluirBusca.OnClick(btnIncluirBusca);
end;

procedure TfrmSicsConfiguraTabela.mnuItemCopiarCorClick(Sender: TObject);
begin
  FCopyColor := dsGenerico.DataSet.FieldByName('CODIGOCOR').AsInteger;
end;

procedure TfrmSicsConfiguraTabela.mnuItemColarCorClick(Sender: TObject);
begin
  if FCopyColor >= 0 then
    GravarCorNoCampo(TAlphaColor(FCopyColor));
end;

procedure TfrmSicsConfiguraTabela.GravarCorNoCampo(Cor: TAlphaColor);
begin
  with dsGenerico.DataSet do
    if not (State in dsEditModes) then
      Edit;
  with dsGenerico.DataSet.FieldByName('CODIGOCOR') do
  begin
    ReadOnly := False;
    AsInteger := Integer(Cor);
    ReadOnly := True;
  end;
end;

end.
