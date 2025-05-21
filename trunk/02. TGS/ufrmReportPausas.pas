unit ufrmReportPausas;
//Renomeado sics_86;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

{$J+}

uses
  FMX.Grid, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.ExtCtrls, FMX.Types, FMX.Layouts, FMX.ListView.Types, FMX.ListView,
  FMX.ListBox, Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs,
  Fmx.Bind.Editors, FMX.Objects, FMX.Edit, FMX.TabControl, MyAspFuncoesUteis,
  {$IFDEF SuportaQuickRep}
  repPrview,
  repDetailPausas,
  {$ENDIF SuportaQuickRep}
  System.UIConsts, System.Generics.Defaults, System.Generics.Collections,
  System.UITypes, System.Types, System.SysUtils, System.Classes,
  System.Variants, Data.DB, Datasnap.DBClient, System.Rtti, Data.Bind.EngExt,
  Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope, Sics_Common_Splash,
  ufrmReport, DateUtils, IniFiles, Data.FMTBcd, Datasnap.Provider,
  FMX.Menus, ufrmReportCustom, untCommonFormBase, FMX.Controls.Presentation,
  System.ImageList, FMX.ImgList, FMX.Effects, FMX.Grid.Style, FMX.ScrollBox,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, uDataSetHelper;

const
//CANEXCLUDE : boolean = true;
//VERSAODBASE = 'Base de dados:'#13'Versão 2.0'#13'10/03/02';
//VERSAODBASE = 'Base de dados:'#13'Versão 2.0 Rev. A'#13'01/10/02';
//VERSAODBASE = 'Base de dados:'#13'Versão 3.0'#13'18/09/03';
  VERSAODBASE = 'Base de dados:'#13'Versão 3.1'#13'30/01/06';

type
  TfrmReportPausas = class(TfrmSicsReportCustom)
    cdsEventosID: TIntegerField;
    cdsEventosID_TIPOEVENTO: TSmallintField;
    cdsEventosID_PA: TSmallintField;
    cdsEventosID_ATENDENTE: TSmallintField;
    cdsEventosINICIO: TSQLTimeStampField;
    cdsEventosFIM: TSQLTimeStampField;
    cdsEventosNOMETIPOEVENTO: TStringField;
    cdsEventosNOMEPA: TStringField;
    cdsEventosNOMEATD: TStringField;
    cdsEventosID_UNIDADE: TIntegerField;
    cdsEventosLKP_NOME_UNIDADE: TStringField;
    cdsEventosDURACAO_SEGUNDOS: TIntegerField;
    cdsEventosID_MOTIVOPAUSA: TIntegerField;
    cdsEventosNOMEMOTIVOPAUSA: TStringField;
    qryEventosID_UNIDADE: TIntegerField;
    qryEventosID: TIntegerField;
    qryEventosID_TIPOEVENTO: TIntegerField;
    qryEventosID_PA: TIntegerField;
    qryEventosID_ATENDENTE: TIntegerField;
    qryEventosID_TICKET: TIntegerField;
    qryEventosID_FILAESPERA: TIntegerField;
    qryEventosID_FILATIPOTICKET: TIntegerField;
    qryEventosID_MOTIVOPAUSA: TIntegerField;
    qryEventosINICIO: TSQLTimeStampField;
    qryEventosFIM: TSQLTimeStampField;
    qryEventosDURACAO_OLD: TSQLTimeStampField;
    qryEventosDURACAO_SEGUNDOS: TIntegerField;
    qryEventosNOMETIPOEVENTO: TStringField;
    qryEventosNOMEPA: TStringField;
    qryEventosNOMEATD: TStringField;
    qryEventosNOMEMOTIVOPAUSA: TStringField;
    cdsEventosID_TICKET: TIntegerField;
    cdsEventosID_FILAESPERA: TIntegerField;
    cdsEventosID_FILATIPOTICKET: TIntegerField;
    cdsEventosDURACAO_OLD: TSQLTimeStampField;


    procedure PrintPreviewButtonClick(Sender: TObject);


    procedure cdsAddEventoReconcileError(DataSet: TCustomClientDataSet;
      E: EReconcileError; UpdateKind: TUpdateKind;
      var Action: TReconcileAction);
  protected
    {$IFDEF SuportaQuickRep}
    qrSicsDetailPausas: TqrSicsDetailPausas;
    {$ENDIF SuportaQuickRep}
    procedure ConstroiSql; Override;
    function  ConstroiDeleteSql : boolean; Override;
    function  CreateCsvFile (FileName : string) : boolean; Override;
  public
	  constructor Create(aOwer: TComponent); Override;
    destructor Destroy; Override;
  end;


implementation

{$R *.fmx}

uses
  Sics_Common_Parametros, ufrmPesquisaRelatorioPausas, untCommonDMClient,
  untCommonDMUnidades;

constructor TfrmReportPausas.Create(aOwer: TComponent);
begin
  inherited;

  {$IFDEF SuportaQuickRep}
  qrSicsDetailPausas := nil;
  {$ENDIF SuportaQuickRep}
end;

procedure TfrmReportPausas.ConstroiSql;
var
  LIdUnidade: Integer;
  sInTags: string;
  LfrmPesquisaRelatorioPausas: TfrmPesquisaRelatorioPausas;
begin
  LfrmPesquisaRelatorioPausas := (Owner as TfrmPesquisaRelatorioPausas);
  TfrmSicsSplash.ShowStatus('Carregando os dados...');
  try
    try
      if cdsEventos.Active then
         cdsEventos.Close;

      cdsEventos.DisableControls;
      try

        LfrmPesquisaRelatorioPausas.cdsUnidades.First;
        while not LfrmPesquisaRelatorioPausas.cdsUnidades.Eof do
        begin

          if not LfrmPesquisaRelatorioPausas.cdsUnidades.FieldByName('SELECIONADO').AsBoolean then
          begin
            LfrmPesquisaRelatorioPausas.cdsUnidades.Next;
            Continue;
          end;

          LIdUnidade := LfrmPesquisaRelatorioPausas.cdsUnidades.FieldByName('ID').AsInteger;

          qryEventos.Close;    //1
          qryEventos.Sql.Clear;
          qryEventos.Connection := DMClient(LIdUnidade, not CRIAR_SE_NAO_EXISTIR).ConnRelatorio;
          qryEventos.Sql.Add ('select                                                       ');
          qryEventos.Sql.Add ('   ' + IntToStr(LIdUnidade) + ' as ID_UNIDADE,                ');
          qryEventos.Sql.Add ('   E.ID, E.ID_TIPOEVENTO, E.ID_PA, E.ID_ATENDENTE, E.ID_TICKET,');
          qryEventos.Sql.Add ('   E.ID_FILAESPERA, E.ID_FILATIPOTICKET, E.ID_MOTIVOPAUSA,     ');
          qryEventos.Sql.Add ('   E.INICIO, E.FIM, E.DURACAO_OLD, E.DURACAO_SEGUNDOS,         ');
          qryEventos.Sql.Add ('   T.NOME          AS NOMETIPOEVENTO,                        ');
          qryEventos.Sql.Add ('   P.NOME		      AS NOMEPA,                                ');
          qryEventos.Sql.Add ('   A.NOME          AS NOMEATD,                               ');
          qryEventos.Sql.Add ('   MP.NOME         AS NOMEMOTIVOPAUSA                        ');
          qryEventos.Sql.Add ('from                                                         ');
          qryEventos.Sql.Add ('   EVENTOS E                                                 ');
          qryEventos.Sql.Add ('   left join TIPOS_EVENTOS T  on E.ID_UNIDADE = T.ID_UNIDADE  AND E.ID_TIPOEVENTO   = T.ID ');
          qryEventos.Sql.Add ('   left join PAS           P  on E.ID_UNIDADE = P.ID_UNIDADE  AND E.ID_PA           = P.ID ');
          qryEventos.Sql.Add ('   left join ATENDENTES    A  on E.ID_UNIDADE = A.ID_UNIDADE  AND E.ID_ATENDENTE    = A.ID ');
          qryEventos.Sql.Add ('   left join MOTIVOS_PAUSA MP on E.ID_UNIDADE = MP.ID_UNIDADE AND E.ID_MOTIVOPAUSA = MP.ID ');
          qryEventos.Sql.Add ('where E.ID_UNIDADE = :ID_UNIDADE AND (                                                     ');
          qryEventos.Params.ParamByName('ID_UNIDADE').DataType := ftInteger;
          qryEventos.Params.ParamByName('ID_UNIDADE').AsInteger := LIdUnidade;

          LfrmPesquisaRelatorioPausas.MontarWhere(qryEventos, sInTags, False);
          //Clipboard.AsText := qryEventos.SQL.Text;

          cdsEventos.FetchParams;
          //cdsEventosTmp.FetchParams;

          if LfrmPesquisaRelatorioPausas.cdsUnidades.RecNo = 1 then
            cdsEventos.Open
          else
          begin
            cdsEventosTmp.Open;
            try
              cdsEventos.AppendData(cdsEventosTmp.Data, True);
            finally
              cdsEventosTmp.Close;
            end;
          end;

          LfrmPesquisaRelatorioPausas.cdsUnidades.Next;
        end;

        if not cdsEventos.active then
          cdsEventos.Open;
        cdsEventos.First;
      finally
        cdsEventos.EnableControls;
      end;

      AtualizaQtdeRegistros;
    finally
    end;
  finally
    TfrmSicsSplash.Hide;
  end;
  UpdateColunasGrid;
end;

function TfrmReportPausas.ConstroiDeleteSql : boolean;
begin
  Result := False;
end;

function TfrmReportPausas.CreateCsvFile (FileName : string) : boolean;
var
  Arq : TextFile;
  s : string;
  LfrmPesquisaRelatorioPausas: TfrmPesquisaRelatorioPausas;
begin
  LfrmPesquisaRelatorioPausas := (Owner as TfrmPesquisaRelatorioPausas);

  Result := true;
  try
    AssignFile (Arq, FileName);
    rewrite (Arq);
    cdsEventos.DisableControls;
    ProgressBar1.Max := cdsEventos.RecordCount;
    ProgressBar1.Value := 0;
    ProgressBar1.Visible := true;
    try
      s := 'Evento;PA;Atendente;Motivo;Inicio;Término;';
      if LfrmPesquisaRelatorioPausas.vlRepVars.QtdeUnidadesSelecionadas > 1 then
        s := 'Unidade;' + s;

      writeln (arq, s);
      cdsEventos.First;
      while not cdsEventos.eof do
      begin
        s := cdsEventos.FieldByName('NOMETIPOEVENTO' )  .AsString + ';' +
             cdsEventos.FieldByName('NOMEPA'         )  .AsString + ';' +
             cdsEventos.FieldByName('NOMEATD'        )  .AsString + ';' +
             cdsEventos.FieldByName('NOMEMOTIVOPAUSA')  .AsString + ';' +
             cdsEventos.FieldByName('INICIO'         )  .AsString + ';' +
             cdsEventos.FieldByName('FIM'            )  .AsString;

        if LfrmPesquisaRelatorioPausas.vlRepVars.QtdeUnidadesSelecionadas > 1 then
          s := cdsEventos.FieldByName('LKP_NOME_UNIDADE' ).AsString + ';' + s;

        writeln (arq, s);
        ProgressBar1.Value := cdsEventos.RecNo;
        cdsEventos.Next;
      end;  { while not eof }
    finally
      CloseFile (Arq);
      cdsEventos.EnableControls;
      ProgressBar1.Visible := false;
    end;  { try .. finally }
  except
    Result := false;
  end;  { try .. except }
end;

destructor TfrmReportPausas.Destroy;
begin
  inherited;
end;

procedure TfrmReportPausas.PrintPreviewButtonClick(Sender: TObject);
{$IFDEF SuportaQuickRep}
var
  LfrmPesquisaRelatorioPausas: TfrmPesquisaRelatorioPausas;
{$ENDIF SuportaQuickRep}
begin
  {$IFDEF SuportaQuickRep}
  LfrmPesquisaRelatorioPausas := (Owner as TfrmPesquisaRelatorioPausas);
   if not Assigned(qrSicsDetailPausas) then
   begin
     qrSicsDetailPausas := TqrSicsDetailPausas.Create(Self);
   end;

  FHeightqrgrpUnidade := qrSicsDetailPausas.qrgrpUnidade.Height;
  qrSicsDetailPausas.DataSet := cdsEventos;
   with qrSicsDetailPausas do
   begin
      PeriodoDoRelatorioLabel.Caption := LfrmPesquisaRelatorioPausas.vlRepVars.PeriodoDoRelatorio;
      PeriodoDoDiaLabel      .Caption := LfrmPesquisaRelatorioPausas.vlRepVars.PeriodoDoDia;
      DurationLabel          .Caption := LfrmPesquisaRelatorioPausas.vlRepVars.Duracao;
      AtendantsLabel         .Caption := LfrmPesquisaRelatorioPausas.vlRepVars.Atds;
      PAsLabel               .Caption := LfrmPesquisaRelatorioPausas.vlRepVars.PAS;
      MotivosPausaLabel      .Caption := LfrmPesquisaRelatorioPausas.vlRepVars.MPs;

      StrListUnidadesAtds.Clear;
      StrListUnidadesPAs.Clear;
      StrListUnidadesMotivosPausa.Clear;

      if LfrmPesquisaRelatorioPausas.cdsUnidades.RecordCount > 1 then
      begin
        with LfrmPesquisaRelatorioPausas.cdsUnidades do
        begin
          First;
          while not Eof do
          begin
            StrListUnidadesAtds.Values[FieldByName('ID').AsString] := FieldByName('ATENDENTES_STR').AsString;
            StrListUnidadesPAs.Values[FieldByName('ID').AsString] := FieldByName('PAS_STR').AsString;
            StrListUnidadesMotivosPausa.Values[FieldByName('ID').AsString] := FieldByName('MOTIVOS_PAUSA_STR').AsString;
            Next;
          end;
        end;
        qrgrpUnidade.Height := FHeightqrgrpUnidade;
        qrgrpUnidade.Master := qrSicsDetailPausas;
      end
      else
      begin
        qrgrpUnidade.Height := 0;
        qrgrpUnidade.Master := nil;
      end;

      lblMultiUnidades.Visible    := LfrmPesquisaRelatorioPausas.vlRepVars.MultiUnidades <> '';
      lblMultiUnidadesVal.Visible := lblMultiUnidades.Visible;
      lblMultiUnidadesVal.Caption := LfrmPesquisaRelatorioPausas.vlRepVars.MultiUnidades;
      if lblMultiUnidades.Visible then
      begin
        lblRelatorio.Caption := '';
        UnidadeLabel.Caption := '';
      end
      else
      begin
        lblRelatorio.Caption := 'Relatório de Pausas';
        UnidadeLabel.Caption := vgParametrosModulo.Unidade;
      end;
      if not lblMultiUnidadesVal.Visible then
        PageHeaderBand1.Height := lblMultiUnidadesVal.Top
      else
        PageHeaderBand1.Height := lblMultiUnidadesVal.Top + lblMultiUnidadesVal.Height + 5;

      AlinharLabels;

      PreviewModal;
   end;
  {$ENDIF SuportaQuickRep}
end;

procedure TfrmReportPausas.cdsAddEventoReconcileError (DataSet: TCustomClientDataSet; E: EReconcileError;
                                                  UpdateKind: TUpdateKind; var Action: TReconcileAction);
begin
  MyLogException(E);
end;


end.
