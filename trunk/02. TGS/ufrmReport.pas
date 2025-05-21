unit ufrmReport;
//Renomeado unit sics_95;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

{$J+}

uses
  FMX.Grid, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.ExtCtrls, FMX.Types, FMX.Layouts, FMX.ListView.Types, FMX.ListView,
  FMX.ListBox, System.DateUtils, untMainForm, Fmx.Bind.DBEngExt, Fmx.Bind.Grid,
  System.Bindings.Outputs, Fmx.Bind.Editors, FMX.Objects, FMX.Edit,
  FMX.TabControl,
  {$IFDEF SuportaQuickRep}
  repDetail,
  repPrview,
  {$ENDIF SuportaQuickRep}
  System.UIConsts, System.Generics.Defaults, System.Generics.Collections,
  System.UITypes, System.Types, System.SysUtils, System.Classes,
  System.Variants, Data.DB, Datasnap.DBClient, System.Rtti, Data.Bind.EngExt,
  Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope, MyAspFuncoesUteis,
  Sics_Common_Splash, System.IniFiles, Data.FMTBcd, Datasnap.Provider,
  ufrmReportCustom, untCommonFormBase, FMX.Menus, ufrmReportBase,
  FMX.Controls.Presentation, System.ImageList, FMX.ImgList, FMX.Effects,Vcl.Clipbrd,
  FMX.Grid.Style, FMX.ScrollBox, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, uDataSetHelper;

const
//CANEXCLUDE : boolean = true;
//VERSAODBASE = 'Base de dados:'#13'Versão 2.0'#13'10/03/02';
//VERSAODBASE = 'Base de dados:'#13'Versão 2.0 Rev. A'#13'01/10/02';
//VERSAODBASE = 'Base de dados:'#13'Versão 3.0'#13'18/09/03';
  VERSAODBASE = 'Base de dados:'#13'Versão 3.1'#13'30/01/06';

type
  TfrmSicsReport = class(TfrmSicsReportCustom)
    cdsEventosID: TIntegerField;
    cdsEventosID_TIPOEVENTO: TSmallintField;
    cdsEventosID_TICKET: TIntegerField;
    cdsEventosID_FILAESPERA: TIntegerField;
    cdsEventosID_FILATIPOTICKET: TIntegerField;
    cdsEventosID_PA: TSmallintField;
    cdsEventosID_ATENDENTE: TSmallintField;
    cdsEventosCALC_CustNomeCliente: TStringField;
    cdsEventosNUMEROTICKET: TIntegerField;
    cdsEventosNOMETIPOEVENTO: TStringField;
    cdsEventosNOMEFILAESPERA: TStringField;
    cdsEventosTIPOTICKET: TStringField;
    cdsEventosNOMEPA: TStringField;
    cdsEventosNOMEATD: TStringField;
    cdsEventosLKP_NOME_UNIDADE: TStringField;
    cdsEventosINTCALC_TAGS: TStringField;
    cdsEventosDURACAO_SEGUNDOS: TIntegerField;
    cdsEventosNOMECLIENTE: TStringField;
    cdsEventosID_MOTIVOPAUSA: TIntegerField;
    cdsEventosDURACAO_OLD: TSQLTimeStampField;
    cdsEventosID_UNIDADE: TIntegerField;
    cdsEventosINICIO: TSQLTimeStampField;
    cdsEventosFIM: TSQLTimeStampField;

    procedure PrintPreviewButtonClick(Sender: TObject);
    procedure FrameResize(Sender: TObject);
  private
    procedure ComponentesCallCenter;
  protected
    {$IFDEF SuportaQuickRep}
    qrSicsDetail: TqrSicsDetail;
    {$ENDIF SuportaQuickRep}
    procedure ConstroiSql; Override;
    function  ConstroiDeleteSql : boolean; Override;
    function  CreateCsvFile (FileName : string) : boolean; Override;
    procedure PreencherTagsCdsEventos; Override;
  public
    constructor Create(aOwner: TComponent); overload; override;
  end;

implementation

{$R *.fmx}

uses
  Sics_Common_Parametros, untCommonFrameBase, ufrmPesquisaRelatorio, untCommonDMClient;

procedure TfrmSicsReport.ConstroiSql;
var
  LIdUnidade, I: Integer;
  sInTags: string;
  LfrmPesquisaRelatorio: TfrmPesquisaRelatorio;
begin
  LfrmPesquisaRelatorio := (owner as TfrmPesquisaRelatorio);
   TfrmSicsSplash.ShowStatus('Carregando os dados...');
   try
      try

      if cdsEventos.Active then
         cdsEventos.Close;

      cdsEventos.DisableControls;
      try

        LfrmPesquisaRelatorio.cdsUnidades.First;
        while not LfrmPesquisaRelatorio.cdsUnidades.Eof do
        begin

          if not LfrmPesquisaRelatorio.cdsUnidades.FieldByName('SELECIONADO').AsBoolean then
          begin
            LfrmPesquisaRelatorio.cdsUnidades.Next;
            Continue;
          end;

          LIdUnidade := LfrmPesquisaRelatorio.cdsUnidades.FieldByName('ID').AsInteger;
          qryEventos.Close; //2
          qryEventos.Sql.Clear;
          qryEventos.Connection := DMClient(LIdUnidade, not CRIAR_SE_NAO_EXISTIR).ConnRelatorio;
          qryEventos.Sql.Add ('select                                                         ');
          //qryEventos.Sql.Add ('   CAST(' + IntToStr(LIdUnidade) + ' AS INT) as ID_UNIDADE,                 ');
          qryEventos.Sql.Add ('   E.*,                                                        ');
          qryEventos.Sql.Add ('   S.NUMEROTICKET  AS NUMEROTICKET,                            ');
          qryEventos.Sql.Add ('   T.NOME          AS NOMETIPOEVENTO,                          ');
          qryEventos.Sql.Add ('   F1.NOME         AS NOMEFILAESPERA,                          ');
          qryEventos.Sql.Add ('   F2.NOME         AS TIPOTICKET,                              ');
          qryEventos.Sql.Add ('   P.NOME		      AS NOMEPA,                                  ');
          qryEventos.Sql.Add ('   A.NOME          AS NOMEATD,                                 ');

          if vgParametrosModulo.ModoCallCenter then
            qryEventos.Sql.Add (' C.NOME          AS NOMECLIENTE                            ')
          else
            qryEventos.Sql.Add (' S.NOMECLIENTE   AS NOMECLIENTE                            ');

          qryEventos.Sql.Add ('from                                                         ');
          qryEventos.Sql.Add ('   EVENTOS E                                                 ');
          qryEventos.Sql.Add ('   left join TICKETS       S  on E.ID_UNIDADE = S.ID_UNIDADE  AND E.ID_TICKET         = S.ID  ');
          qryEventos.Sql.Add ('   left join TIPOS_EVENTOS T  on E.ID_UNIDADE = T.ID_UNIDADE  AND E.ID_TIPOEVENTO     = T.ID  ');
          qryEventos.Sql.Add ('   left join FILAS         F1 on E.ID_UNIDADE = F1.ID_UNIDADE AND E.ID_FILAESPERA     = F1.ID ');
          qryEventos.Sql.Add ('   left join FILAS         F2 on E.ID_UNIDADE = F2.ID_UNIDADE AND E.ID_FILATIPOTICKET = F2.ID ');
          qryEventos.Sql.Add ('   left join PAS           P  on E.ID_UNIDADE = P.ID_UNIDADE  AND E.ID_PA             = P.ID  ');
          qryEventos.Sql.Add ('   left join ATENDENTES    A  on E.ID_UNIDADE = A.ID_UNIDADE  AND E.ID_ATENDENTE      = A.ID  ');

          if vgParametrosModulo.ModoCallCenter then
            qryEventos.Sql.Add (' left join CLIENTES      C  on S.ID_CLIENTE        = C .ID AND C.ID_UNIDADE = S.ID_UNIDADE');

          qryEventos.Sql.Add ('where E.ID_TIPOEVENTO IN (0,2) ');
          qryEventos.Sql.Add ('and E.ID_UNIDADE = :ID_UNIDADE ');
          qryEventos.Sql.Add ('and (                          ');
          qryEventos.Params.ParamByName('ID_UNIDADE').DataType := ftInteger;
          qryEventos.Params.ParamByName('ID_UNIDADE').AsInteger := LIdUnidade;


          LfrmPesquisaRelatorio.MontarWhere(qryEventos, sInTags, False);

         // RAP Deixei para testes
         {$IFDEF DEBUG}
         Clipboard.AsText := qryEventos.SQL.Text;
         {$ENDIF}

         cdsEventos.FetchParams;
         //cdsEventosTmp.FetchParams;

         qryEventos.Prepare;

          if LfrmPesquisaRelatorio.cdsUnidades.RecNo = 1 then
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

          LfrmPesquisaRelatorio.cdsUnidades.Next;
        end;

        if not cdsEventos.active then
          cdsEventos.Open;
        cdsEventos.First;
      finally
        cdsEventos.EnableControls;
        AtualizaQtdeRegistros;
      end;
     finally

     end;  { try..finally }
   finally
      TfrmSicsSplash.Hide;
   end;
end;  { procedure ConstroiSql }


function TfrmSicsReport.ConstroiDeleteSql : boolean;
begin
  Result := False;
end;

constructor TfrmSicsReport.Create(aOwner: TComponent);
begin
  inherited;
  {$IFDEF SuportaQuickRep}
  qrSicsDetail := nil;
  {$ENDIF SuportaQuickRep}
end;

function TfrmSicsReport.CreateCsvFile (FileName : string) : boolean;
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
      if vgParametrosModulo.ModoCallCenter then
        s := 'Mesa;Evento;Fila;Coordenador;Atendente;Inicio;Término'
      else
      begin
        s := 'Unidade;Senha;';
        if chkMostrarNomeDosClientes.IsChecked then
          s := s + 'Cliente;';
        if chkMostrarTipoSenha.IsChecked then
          s := s + 'Tipo;';
          s := s + 'Evento;Fila;PA;Atendente;Inicio;Término;';
        if chkMostrarTags.IsChecked then
          s := s + 'Tags';
      end;

      writeln (arq, s);
      cdsEventos.First;
      while not cdsEventos.eof do
      begin
        s := cdsEventos.FieldByName('LKP_NOME_UNIDADE').AsString + ';' +
          cdsEventos.FieldByName('NUMEROTICKET').AsString + ';';

        if vgParametrosModulo.ModoCallCenter then
        begin
          s := s +
          cdsEventos.FieldByName('NOMETIPOEVENTO').AsString + ';' +
          cdsEventos.FieldByName('NOMEFILAESPERA').AsString + ';' +
          cdsEventos.FieldByName('NOMEATD'       ).AsString + ';' +
          cdsEventos.FieldByName('NOMECLIENTE'   ).AsString + ';' +
          cdsEventos.FieldByName('INICIO'        ).AsString + ';' +
          cdsEventos.FieldByName('FIM'           ).AsString + ';' ;
        end
        else
        begin
          if chkMostrarNomeDosClientes.IsChecked then
            s := s + cdsEventos.FieldByName('NOMECLIENTE').AsString + ';';

          if chkMostrarTipoSenha.IsChecked then
            s := s + cdsEventos.FieldByName('TIPOTICKET').AsString + ';';

          s := s +
          cdsEventos.FieldByName('NOMETIPOEVENTO').AsString + ';' +
          cdsEventos.FieldByName('NOMEFILAESPERA').AsString + ';' +
          cdsEventos.FieldByName('NOMEPA'        ).AsString + ';' +
          cdsEventos.FieldByName('NOMEATD'       ).AsString + ';' +
          cdsEventos.FieldByName('INICIO'        ).AsString + ';' +
          cdsEventos.FieldByName('FIM'           ).AsString + ';' ;

          if chkMostrarTags.IsChecked then
            s := s + cdsEventos.FieldByName('INTCALC_TAGS').AsString;
        end;

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

procedure TfrmSicsReport.FrameResize(Sender: TObject);
begin
  inherited;
  if vgParametrosModulo.ModoCallCenter then
    ComponentesCallCenter;
end;

procedure TfrmSicsReport.PrintPreviewButtonClick(Sender: TObject);
{$IFDEF SuportaQuickRep}
var
  LfrmPesquisaRelatorio: TfrmPesquisaRelatorio;
{$ENDIF SuportaQuickRep}
begin
  {$IFDEF SuportaQuickRep}
  LfrmPesquisaRelatorio := (owner as TfrmPesquisaRelatorio);
  if not Assigned(qrSicsDetail) then
  begin
    qrSicsDetail := TqrSicsDetail.Create(Self);
  end;

  qrSicsDetail.DataSet := cdsEventos;
  FHeightqrgrpUnidade := qrSicsDetail.qrgrpUnidade.Height;

  with qrSicsDetail do
  begin
    if vgParametrosModulo.ModoCallCenter then
    begin
      qrlAtendente.Caption := 'Coordenadores:';
      qrlSenhas.Caption    := 'Mesas:';
      qrlPas.Enabled       := False;
      PAsLabel.Enabled     := False;
      qrlTags.Enabled      := False;
      TagsLabel.Enabled    := False;
      qrlFilas.Top         := 50;
      FilasLabel.Top       := 50;
    end;

    PeriodoDoRelatorioLabel.Caption := LfrmPesquisaRelatorio.vlRepVars.PeriodoDoRelatorio;
    PeriodoDoDiaLabel      .Caption := LfrmPesquisaRelatorio.vlRepVars.PeriodoDoDia;
    DurationLabel          .Caption := LfrmPesquisaRelatorio.vlRepVars.Duracao;
    SenhasLabel            .Caption := LfrmPesquisaRelatorio.vlRepVars.Senhas;
    AtendantsLabel         .Caption := LfrmPesquisaRelatorio.vlRepVars.Atendentes;
    PAsLabel               .Caption := LfrmPesquisaRelatorio.vlRepVars.PAS;
    FilasLabel             .Caption := LfrmPesquisaRelatorio.vlRepVars.Filas;
    TagsLabel              .Caption := LfrmPesquisaRelatorio.vlRepVars.Tags;

    StrListUnidadesAtds.Clear;
    StrListUnidadesPAs.Clear;
    StrListUnidadesFilas.Clear;
    StrListUnidadesTags.Clear;

    if LfrmPesquisaRelatorio.cdsUnidades.RecordCount > 1 then
    begin
      with LfrmPesquisaRelatorio.cdsUnidades do
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
      qrgrpUnidade.Master := qrSicsDetail;
    end
    else
    begin
      qrgrpUnidade.Height := 0;
      qrgrpUnidade.Master := nil;
    end;

    qrlMultiUnidades.Visible    := LfrmPesquisaRelatorio.vlRepVars.MultiUnidades <> '';
    lblMultiUnidadesVal.Visible := qrlMultiUnidades.Visible;
    lblMultiUnidadesVal.Caption := LfrmPesquisaRelatorio.vlRepVars.MultiUnidades;
    if qrlMultiUnidades.Visible then
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
    lblTipo.Visible := chkMostrarTipoSenha.IsChecked;
    AlinharLabels;
    PreviewModal;
  end;
  {$ENDIF SuportaQuickRep}
end;

procedure TfrmSicsReport.PreencherTagsCdsEventos;
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

procedure TfrmSicsReport.ComponentesCallCenter;
begin
  chkMostrarTags.Visible              := False;
  chkMostrarNomeDosClientes.Visible   := False;
  cdsEventosNUMEROTICKET.DisplayLabel := 'Mesa';
  cdsEventosNOMEATD.DisplayLabel      := 'Coordenador';
  cdsEventosNOMECLIENTE.DisplayLabel  := 'Atendente';
  cdsEventosNOMEPA.Visible            := False;
  cdsEventosNOMECLIENTE.Visible       := True;
end;

end.


