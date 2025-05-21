unit ufrmReportPP;
//Renoemado unit sics_88;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  FMX.Grid, FMX.Controls, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls, FMX.ExtCtrls,
  FMX.Types, FMX.Layouts, FMX.ListView.Types, FMX.ListView, FMX.ListBox,
  Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors,
  FMX.Objects, FMX.Edit, FMX.TabControl, MyAspFuncoesUteis,
  {$IFDEF SuportaQuickRep}
  repPrview,
  repDetailPP,
  {$ENDIF SuportaQuickRep}
  System.UIConsts, System.Generics.Defaults, System.Generics.Collections,
  System.UITypes, System.Types, System.SysUtils, System.Classes,
  System.Variants, Data.DB, Datasnap.DBClient, System.Rtti, Data.Bind.EngExt,
  Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope,  System.DateUtils,
  Data.FMTBcd, Datasnap.Provider, FMX.Menus,
  FMX.Controls.Presentation, Sics_Common_Splash, System.IniFiles,
  ufrmReportBase, ufrmReport, ufrmReportCustom, System.ImageList, FMX.ImgList,
  FMX.Effects, FMX.Grid.Style, FMX.ScrollBox, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, uDataSetHelper;
{$J+}

const
//CANEXCLUDE : boolean = true;
//VERSAODBASE = 'Base de dados:'#13'Versão 2.0'#13'10/03/02';
//VERSAODBASE = 'Base de dados:'#13'Versão 2.0 Rev. A'#13'01/10/02';
//VERSAODBASE = 'Base de dados:'#13'Versão 3.0'#13'18/09/03';
  VERSAODBASE = 'Base de dados:'#13'Versão 3.1'#13'30/01/06';

type
  TfrmReportPP = class(TfrmSicsReportCustom)
    cdsEventosID: TIntegerField;
    cdsEventosID_TICKET: TIntegerField;
    cdsEventosID_FILATIPOTICKET: TIntegerField;
    cdsEventosINICIO: TSQLTimeStampField;
    cdsEventosFIM: TSQLTimeStampField;
    cdsEventosNUMEROTICKET: TIntegerField;
    cdsEventosTIPOTICKET: TStringField;
    cdsEventosNOMEPAINICIO: TStringField;
    cdsEventosNOMEATDINICIO: TStringField;
    cdsEventosID_UNIDADE: TIntegerField;
    cdsEventosLKP_NOME_UNIDADE: TStringField;
    cdsEventosINTCALC_TAGS: TStringField;
    cdsEventosDURACAO_SEGUNDOS: TIntegerField;
    cdsEventosNOMEPAFIM: TStringField;
    cdsEventosNOMEATDFIM: TStringField;
    cdsEventosID_TIPOPP: TSmallintField;
    cdsEventosID_PA_INICIO: TSmallintField;
    cdsEventosID_ATD_INICIO: TSmallintField;
    cdsEventosID_PA_FIM: TSmallintField;
    cdsEventosID_ATD_FIM: TSmallintField;
    cdsEventosNOMETIPOPP: TStringField;
    cdsEventosNOMECLIENTE: TStringField;

    procedure PrintPreviewButtonClick(Sender: TObject);
    procedure cdsAddEventoReconcileError(DataSet: TCustomClientDataSet; E: EReconcileError; UpdateKind: TUpdateKind; var Action: TReconcileAction);
  protected
    {$IFDEF SuportaQuickRep}
    qrSicsDetailPP: TqrSicsDetailPP;
    {$ENDIF SuportaQuickRep}
    procedure ConstroiSql; Override;
    function ConstroiDeleteSql : boolean; Override;
    function CreateCsvFile (FileName : string) : boolean; Override;
    procedure PreencherTagsCdsEventos; Override;
  public
	  constructor Create(aOwer: TComponent); Override;
    destructor Destroy; override;
  end;


implementation

{$R *.fmx}

uses
  FMX.Forms, Sics_Common_Parametros, untCommonFrameBase, ufrmPesquisaRelatorioPP, untCommonDMClient;

constructor TfrmReportPP.Create(aOwer: TComponent);
begin
  inherited;

  {$IFDEF SuportaQuickRep}
  qrSicsDetailPP := nil;
  {$ENDIF SuportaQuickRep}
end;

procedure TfrmReportPP.ConstroiSql;
var
  LIdUnidade: Integer;
  sInTags: string;
  LfrmPesquisaRelatorioPP: TfrmPesquisaRelatorioPP;
begin
  LfrmPesquisaRelatorioPP := (Owner as TfrmPesquisaRelatorioPP);
   try
      if cdsEventos.Active then
         cdsEventos.Close;

      cdsEventos.DisableControls;
      try

        LfrmPesquisaRelatorioPP.cdsUnidades.First;
        while not LfrmPesquisaRelatorioPP.cdsUnidades.Eof do
        begin

          if not LfrmPesquisaRelatorioPP.cdsUnidades.FieldByName('SELECIONADO').AsBoolean then
          begin
            LfrmPesquisaRelatorioPP.cdsUnidades.Next;
            Continue;
          end;

          LIdUnidade := LfrmPesquisaRelatorioPP.cdsUnidades.FieldByName('ID').AsInteger;

          qryEventos.Close;
          qryEventos.Sql.Clear;
          qryEventos.Connection := DMClient(LIdUnidade, not CRIAR_SE_NAO_EXISTIR).ConnRelatorio;

          qryEventos.Sql.Add ('select                                         '); //RAP
          qryEventos.Sql.Add ('   EPP.*,                                      '); //RAP
          qryEventos.Sql.Add ('   S.NUMEROTICKET AS NUMEROTICKET,             '); //RAP
          qryEventos.Sql.Add ('   T.NOME         AS NOMETIPOPP,               '); //RAP
          qryEventos.Sql.Add ('   F2.NOME        AS TIPOTICKET,               '); //RAP
          qryEventos.Sql.Add ('   P.NOME         AS NOMEPAINICIO,             '); //RAP
          qryEventos.Sql.Add ('   A.NOME         AS NOMEATDINICIO,            '); //RAP
          qryEventos.Sql.Add ('   PF.NOME        AS NOMEPAFIM,                '); //RAP
          qryEventos.Sql.Add ('   AF.NOME        AS NOMEATDFIM,               '); //RAP
          qryEventos.Sql.Add ('   S.NOMECLIENTE  AS NOMECLIENTE               '); //RAP
          qryEventos.Sql.Add ('from                                           '); //RAP
          qryEventos.Sql.Add ('   EVENTOS_PPS EPP                             '); //RAP
          qryEventos.Sql.Add ('   left join TICKETS    S  on EPP.ID_UNIDADE = S.ID_UNIDADE  AND EPP.ID_TICKET         = S.ID '); //RAP
          qryEventos.Sql.Add ('   left join PPS        T  on EPP.ID_UNIDADE = T.ID_UNIDADE  AND EPP.ID_TIPOPP         = T.ID '); //RAP
          qryEventos.Sql.Add ('   left join FILAS      F2 on EPP.ID_UNIDADE = F2.ID_UNIDADE AND EPP.ID_FILATIPOTICKET = F2.ID'); //RAP
          qryEventos.Sql.Add ('   left join PAS        P  on EPP.ID_UNIDADE = P.ID_UNIDADE  AND EPP.ID_PA_INICIO      = P.ID '); //RAP
          qryEventos.Sql.Add ('   left join ATENDENTES A  on EPP.ID_UNIDADE = A.ID_UNIDADE  AND EPP.ID_ATD_INICIO     = A.ID '); //RAP
          qryEventos.Sql.Add ('   left join PAS        PF on EPP.ID_UNIDADE = PF.ID_UNIDADE AND EPP.ID_PA_FIM         = PF.ID'); //RAP
          qryEventos.Sql.Add ('   left join ATENDENTES AF on EPP.ID_UNIDADE = AF.ID_UNIDADE AND EPP.ID_ATD_FIM        = AF.ID'); //RAP
          qryEventos.Sql.Add ('where EPP.ID_UNIDADE = :ID_UNIDADE ');
          qryEventos.Sql.Add ('   and (      ');
          qryEventos.Params.ParamByName('ID_UNIDADE').DataType := ftInteger;
          qryEventos.Params.ParamByName('ID_UNIDADE').AsInteger := LIdUnidade;

          LfrmPesquisaRelatorioPP.MontarWhere(qryEventos, sInTags, False);

          //RAP Deixei para testes Clipboard.AsText := qryEventos.SQL.Text;

          cdsEventos.FetchParams;
          //.FetchParams;

          if LfrmPesquisaRelatorioPP.cdsUnidades.RecNo = 1 then
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

          LfrmPesquisaRelatorioPP.cdsUnidades.Next;
        end;

        if not cdsEventos.active then
          cdsEventos.Open;
        cdsEventos.First;
      finally
        cdsEventos.EnableControls;
      end;

      AtualizaQtdeRegistros;
   finally
   end;  { try..finally }
   UpdateColunasGrid;
end;

function TfrmReportPP.ConstroiDeleteSql : boolean;
begin
  Result := False;
end;

function TfrmReportPP.CreateCsvFile (FileName : string) : boolean;
var
  Arq : TextFile;
  s : string;
begin
  Result := true;
  try
    AssignFile (Arq, FileName);
    rewrite (Arq);
    cdsEventos.DisableControls;
    ProgressBar1.Max := cdsEventos.RecordCount;
    ProgressBar1.Value := 0;
    ProgressBar1.Visible := true;
    try
      s := '';
      s := s + 'Unidade;Senha';

      if chkMostrarNomeDosClientes.IsChecked then
        s := ';Cliente';

      if chkMostrarTipoSenha.IsChecked then
        s := s + ';Tipo';

      s := s + ';Processo Paralelo';
      s := s + ';PA (Início);Atendente (Início);PA (Fim);Atendente (Fim);Início;Fim;Duração';

      if chkMostrarTags.IsChecked then
        s := s + ';Tags';

      writeln (arq, s);
      cdsEventos.First;
      while not cdsEventos.eof do
      begin
        s := '';
        s := cdsEventos.FieldByName('LKP_NOME_UNIDADE').AsString + ';' +
          s + cdsEventos.FieldByName('NUMEROTICKET').AsString;

        if chkMostrarNomeDosClientes.IsChecked then
          s := s + ';'+cdsEventos.FieldByName('NOMECLIENTE').AsString;


        if chkMostrarTipoSenha.IsChecked then
          s := s + ';'+ cdsEventos.FieldByName('TIPOTICKET').AsString ;
        s := s + ';' +
             cdsEventos.FieldByName('NOMETIPOPP').AsString + ';' +
             cdsEventos.FieldByName('NOMEPAINICIO'        ).AsString + ';' +
             cdsEventos.FieldByName('NOMEATDINICIO'       ).AsString + ';' +
             cdsEventos.FieldByName('NOMEPAFIM'        ).AsString + ';' +
             cdsEventos.FieldByName('NOMEATDFIM'        ).AsString + ';' +
             cdsEventos.FieldByName('INICIO'        ).AsString + ';' +
             cdsEventos.FieldByName('FIM'        ).AsString + ';' +
             MyFormatDateTime('[h]:nn:ss', IncSecond(0, cdsEventos.FieldByName('DURACAO_SEGUNDOS'           ).AsInteger ));

        if chkMostrarTags.IsChecked then
          s := s + ';' + cdsEventos.FieldByName('INTCALC_TAGS').AsString;

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

destructor TfrmReportPP.destroy;
begin
  inherited;
end;

procedure TfrmReportPP.PrintPreviewButtonClick(Sender: TObject);
{$IFDEF SuportaQuickRep}
var
  LfrmPesquisaRelatorioPP: TfrmPesquisaRelatorioPP;
{$ENDIF SuportaQuickRep}
begin
  {$IFDEF SuportaQuickRep}
  LfrmPesquisaRelatorioPP := (Owner as TfrmPesquisaRelatorioPP);
   if not Assigned(qrSicsDetailPP) then
   begin
     qrSicsDetailPP := TqrSicsDetailPP.Create(Self);
   end;

  FHeightqrgrpUnidade := qrSicsDetailPP.qrgrpUnidade.Height;
  qrSicsDetailPP.DataSet := cdsEventos;
   with qrSicsDetailPP do
   begin
      PeriodoDoRelatorioLabel.Caption := LfrmPesquisaRelatorioPP.vlRepVars.PeriodoDoRelatorio;
      PeriodoDoDiaLabel      .Caption := LfrmPesquisaRelatorioPP.vlRepVars.PeriodoDoDia;
      DurationLabel          .Caption := LfrmPesquisaRelatorioPP.vlRepVars.Duracao;
      SenhasLabel            .Caption := LfrmPesquisaRelatorioPP.vlRepVars.Senhas;
      AtendantsLabel         .Caption := LfrmPesquisaRelatorioPP.vlRepVars.Atds;
      PAsLabel               .Caption := LfrmPesquisaRelatorioPP.vlRepVars.PAS;
      TagsLabel              .Caption := LfrmPesquisaRelatorioPP.vlRepVars.Tags;
      AtendantsFimLabel      .Caption := LfrmPesquisaRelatorioPP.vlRepVars.AtdsFim;
      PAsFimLabel            .Caption := LfrmPesquisaRelatorioPP.vlRepVars.PAsFim;
      TiposPPLabel           .Caption := LfrmPesquisaRelatorioPP.vlRepVars.PPs;

      StrListUnidadesAtds.Clear;
      StrListUnidadesPAs.Clear;
      StrListUnidadesFilas.Clear;
      StrListUnidadesTags.Clear;

      if LfrmPesquisaRelatorioPP.cdsUnidades.RecordCount > 1 then
      begin
        with LfrmPesquisaRelatorioPP.cdsUnidades do
        begin
          First;
          while not Eof do
          begin
            StrListUnidadesAtds.Values[FieldByName('ID').AsString] := FieldByName('ATENDENTES_STR').AsString;
            StrListUnidadesPAs.Values[FieldByName('ID').AsString] := FieldByName('PAS_STR').AsString;
            StrListUnidadesFilas.Values[FieldByName('ID').AsString] := FieldByName('FILAS_STR').AsString;
            StrListUnidadesTags.Values[FieldByName('ID').AsString] := FieldByName('TAGS_STR').AsString;
            Next;
          end;
        end;
        qrgrpUnidade.Height := FHeightqrgrpUnidade;
        qrgrpUnidade.Master := qrSicsDetailPP;
      end
      else
      begin
        qrgrpUnidade.Height := 0;
        qrgrpUnidade.Master := nil;
      end;

      lblMultiUnidades.Visible    := LfrmPesquisaRelatorioPP.vlRepVars.MultiUnidades <> '';
      lblMultiUnidadesVal.Visible := lblMultiUnidades.Visible;
      lblMultiUnidadesVal.Caption := LfrmPesquisaRelatorioPP.vlRepVars.MultiUnidades;
      if lblMultiUnidades.Visible then
      begin
        lblRelatorio.Caption := '';
        UnidadeLabel.Caption := '';
      end
      else
      begin
        lblRelatorio.Caption := 'Relatório';
        UnidadeLabel.Caption := vgParametrosModulo.Unidade;
      end;
      if not lblMultiUnidadesVal.Visible then
        PageHeaderBand1.Height := lblMultiUnidadesVal.Top
      else
        PageHeaderBand1.Height := lblMultiUnidadesVal.Top + lblMultiUnidadesVal.Height + 5;

      lblCliente.Visible := chkMostrarNomeDosClientes.IsChecked;
      lblTags.Visible := chkMostrarTags.IsChecked;
      lblTipoSenha.Visible := chkMostrarTipoSenha.IsChecked;
      AlinharLabels;

      PreviewModal;
   end;  { with repDetail.Report }
  {$ENDIF SuportaQuickRep}
end;  { procedure PrintPreviewButtonClick }

procedure TfrmReportPP.PreencherTagsCdsEventos;
var
  sTags: string;
  iRecordCount: Integer;
begin
  with cdsEventos do
  begin
    First;

    TfrmSicsSplash.ShowStatus('Obtendo as Tags, aguarde...');
    try
      DisableControls;
      try
        iRecordCount := RecordCount;
        First;
        while not Eof do
        begin
          TfrmSicsSplash.ShowStatus('Obtendo as Tags ' + #13 + #10 + '(Registro ' + IntToStr(RecNo) + ' de ' + IntToStr(iRecordCount) + ')');
          Application.ProcessMessages;

          sTags := '';

          qryGetTagsTicket.Close;
          qryGetTagsTicket.Connection := DMClient(FieldByName('ID_UNIDADE').AsInteger, not CRIAR_SE_NAO_EXISTIR).ConnRelatorio;
          qryGetTagsTicket.ParamByName('ID_TICKET').AsInteger := FieldByName('ID_TICKET').AsInteger;
          qryGetTagsTicket.Open;
          try
            qryGetTagsTicket.First;
            while not qryGetTagsTicket.Eof do
            begin
              if sTags <> '' then
                sTags := sTags + ',';
              sTags := sTags + qryGetTagsTicket.FieldByName('NOMETAG').AsString;
              qryGetTagsTicket.Next;
            end;
          finally
            qryGetTagsTicket.Close;
          end;

          Edit;
          FieldByName('INTCALC_TAGS').AsString := sTags;
          Post;

          Next;
        end;
      finally
        EnableControls;
      end;
    finally
      TfrmSicsSplash.Hide;
    end;
  end;
end;

procedure TfrmReportPP.cdsAddEventoReconcileError (DataSet: TCustomClientDataSet; E: EReconcileError;
                                                  UpdateKind: TUpdateKind; var Action: TReconcileAction);
begin
  MyLogException(E);
end;

end.
