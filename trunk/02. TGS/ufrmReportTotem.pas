unit ufrmReportTotem;
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
  repDetailTotem,
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
  FireDAC.Comp.Client;

const
//CANEXCLUDE : boolean = true;
//VERSAODBASE = 'Base de dados:'#13'Versão 2.0'#13'10/03/02';
//VERSAODBASE = 'Base de dados:'#13'Versão 2.0 Rev. A'#13'01/10/02';
//VERSAODBASE = 'Base de dados:'#13'Versão 3.0'#13'18/09/03';
  VERSAODBASE = 'Base de dados:'#13'Versão 3.1'#13'30/01/06';

type
  TfrmSicsReportTotem = class(TfrmSicsReportCustom)
    cdsEventosINICIO: TSQLTimeStampField;
    cdsEventosFIM: TSQLTimeStampField;
    cdsEventosCALC_CustNomeCliente: TStringField;
    cdsEventosNUMEROTICKET: TIntegerField;
    cdsEventosNOMEFILAESPERA: TStringField;
    cdsEventosNOMEPA: TStringField;
    cdsEventosNOMEATD: TStringField;
    cdsEventosID_UNIDADE: TIntegerField;
    cdsEventosLKP_NOME_UNIDADE: TStringField;
    cdsEventosINTCALC_TAGS: TStringField;
    cdsEventosDURACAO_SEGUNDOS: TIntegerField;
    cdsEventosNOMECLIENTE: TStringField;
    cdsEventosID_TICKET: TIntegerField;
    cdsEventosNOMETOTEM: TStringField;
    cdsEventosNOMETIPOFLUXO: TStringField;
    cdsEventosNOMERESULTADO: TStringField;

    procedure PrintPreviewButtonClick(Sender: TObject);
    procedure FrameResize(Sender: TObject);
  private
    procedure ComponentesCallCenter;
  protected
    {$IFDEF SuportaQuickRep}
    qrSicsDetail: TqrSicsDetailTotem;
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
  Sics_Common_Parametros,
  untCommonFrameBase,
  ufrmPesquisaRelatorioTotem,
  untCommonDMClient;

procedure TfrmSicsReportTotem.ConstroiSql;
var
  LIdUnidade: Integer;
  sInTags: string;
  LfrmPesquisaRelatorio: TfrmPesquisaRelatorioTotem;
begin
  LfrmPesquisaRelatorio := (owner as TfrmPesquisaRelatorioTotem);
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

          qryEventos.Close;
          qryEventos.Sql.Clear;
          qryEventos.Connection := DMClient(LIdUnidade, not CRIAR_SE_NAO_EXISTIR).ConnRelatorio;
          qryEventos.Sql.Add ('select distinct                                              ');
          qryEventos.Sql.Add ('   ' + IntToStr(LIdUnidade) + ' as ID_UNIDADE,               ');
          qryEventos.Sql.Add ('   F3.ID_TICKET,                                             ');
          qryEventos.Sql.Add ('   AA.ID, AA.INICIO, AA.FIM, AA.DURACAO_SEGUNDOS,            ');
          qryEventos.Sql.Add ('   S.NUMEROTICKET                   AS NUMEROTICKET,         ');
          qryEventos.Sql.Add ('   T.NOME                           AS NOMERESULTADO,        ');
          qryEventos.Sql.Add ('   F1.NOME                          AS NOMEFILAESPERA,       ');
          qryEventos.Sql.Add ('   P.NOME		                       AS NOMEPA,               ');
          qryEventos.Sql.Add ('   A.NOME                           AS NOMEATD,              ');
          qryEventos.Sql.Add ('   TT.NOME                          AS NOMETOTEM,            ');
          qryEventos.Sql.Add ('   F4.NOME                          AS NOMETIPOFLUXO,        ');

          if vgParametrosModulo.ModoCallCenter then
            qryEventos.Sql.Add (' C.NOME          AS NOMECLIENTE                            ')
          else
            qryEventos.Sql.Add (' S.NOMECLIENTE   AS NOMECLIENTE                            ');

          qryEventos.Sql.Add ('from                                                         ');
          qryEventos.Sql.Add ('   AA AA                                                     ');
          qryEventos.Sql.Add ('   inner join NN_AA_TICKETS        F3 on AA.ID                    = F3.ID_AA');
          qryEventos.Sql.Add ('   inner join TOTENS               TT on TT.ID                    = AA.ID_TOTEM');
          qryEventos.Sql.Add ('   inner join TIPOS_FLUXOS_AA      F4 on F4.ID                    = AA.ID_TIPOFLUXO');
          qryEventos.Sql.Add ('   inner join TICKETS              S  on F3.ID_TICKET             = S .ID ');
          qryEventos.Sql.Add ('   left  join EVENTOS              E  on E .ID_TICKET             = S .ID');
          qryEventos.Sql.Add ('   left  join TIPOS_RESULTADOS_AA  T  on AA.ID_RESULTADO          = T .ID ');
          qryEventos.Sql.Add ('   left  join FILAS                F1 on AA.ID_FILAENCAMINHAMENTO = F1.ID ');
          qryEventos.Sql.Add ('   left  join PAS                  P  on E .ID_PA                 = P .ID ');
          qryEventos.Sql.Add ('   left  join ATENDENTES           A  on E .ID_ATENDENTE          = A .ID ');

          if vgParametrosModulo.ModoCallCenter then
            qryEventos.Sql.Add (' left join CLIENTES      C  on S.ID_CLIENTE        = C .ID ');

          qryEventos.Sql.Add ('where (                                                        ');

          LfrmPesquisaRelatorio.MontarWhere(qryEventos, sInTags, False);

         // RAP Deixei para testes
         {$IFDEF DEBUG}
         Clipboard.AsText := qryEventos.SQL.Text;
         {$ENDIF}

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


function TfrmSicsReportTotem.ConstroiDeleteSql : boolean;
begin
   try
      Result := true;
      try
        cdsEventos.Close;
        with qryEventos do
        begin
          Close;
          if SQL.Count > 14 then
          begin
            //deleta todas as linhas antes do where
            SQL.Delete(15);
            SQL.Delete(14);
            SQL.Delete(13);
            SQL.Delete(12);
            SQL.Delete(11);
            SQL.Delete(10);
            SQL.Delete(9);
            SQL.Delete(8);
            SQL.Delete(7);
            SQL.Delete(6);
            SQL.Delete(5);
            SQL.Delete(4);
            SQL.Delete(3);
            SQL.Delete(2);
            SQL.Delete(1);
            SQL.Delete(0);
            //deleta linhas do order by
            SQL.Delete(SQL.Count - 1);
            SQL.Delete(SQL.Count - 1);
            //insere comando SQL para DELETE
            SQL.Insert(0, 'delete from EVENTOS');
          end;

          Open;
          Result := Active;
        end;
      except
         Result := false;
      end;  { try .. except }
   finally

   end;  { try..finally }
end;  { procedure ConstroiDeleteSql }


constructor TfrmSicsReportTotem.Create(aOwner: TComponent);
begin
  inherited;
  {$IFDEF SuportaQuickRep}
  qrSicsDetail := nil;
  {$ENDIF SuportaQuickRep}
end;

function TfrmSicsReportTotem.CreateCsvFile (FileName : string) : boolean;
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
      s := 'Senha;';
      s := s + 'Totem;';
      s := s + 'Fluxo;';
      s := s + 'Resultado;';
      s := s + 'Inicio;Término;Duração';

      writeln (arq, s);

      cdsEventos.First;

      while not cdsEventos.eof do
      begin
        s := cdsEventos.FieldByName('NUMEROTICKET').AsString + ';';
        s := s + cdsEventos.FieldByName('NOMETOTEM').AsString + ';';
        s := s + cdsEventos.FieldByName('NOMETIPOFLUXO').AsString + ';';
        s := s + cdsEventos.FieldByName('NOMERESULTADO').AsString + ';';
        s := s + cdsEventos.FieldByName('INICIO'        ).AsString + ';';
        s := s + cdsEventos.FieldByName('FIM'           ).AsString + ';';
        s := s + cdsEventos.FieldByName('DURACAO_SEGUNDOS').AsString;

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

procedure TfrmSicsReportTotem.FrameResize(Sender: TObject);
begin
  inherited;
  if vgParametrosModulo.ModoCallCenter then
    ComponentesCallCenter;
end;

procedure TfrmSicsReportTotem.PrintPreviewButtonClick(Sender: TObject);
{$IFDEF SuportaQuickRep}
var
  LfrmPesquisaRelatorio: TfrmPesquisaRelatorioTotem;
{$ENDIF SuportaQuickRep}
begin
  {$IFDEF SuportaQuickRep}
  LfrmPesquisaRelatorio := (owner as TfrmPesquisaRelatorioTotem);
  if not Assigned(qrSicsDetail) then
  begin
    qrSicsDetail := TqrSicsDetailTotem.Create(Self);
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
    TotensLabel            .Caption := LfrmPesquisaRelatorio.vlRepVars.Totens;
    FluxosLabel            .Caption := LfrmPesquisaRelatorio.vlRepVars.Fluxos;

    StrListUnidadesAtds.Clear;
    StrListUnidadesPAs.Clear;
    StrListUnidadesFilas.Clear;
    StrListUnidadesTotens.Clear;
    StrListUnidadesFluxos.Clear;

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
          StrListUnidadesTotens.Values[FieldByName('ID').AsString] := FieldByName('TOTENS_STR').AsString;
          StrListUnidadesFluxos.Values[FieldByName('ID').AsString] := FieldByName('FLUXOS_STR').AsString;

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

    lblCliente.Visible := True;
    //lblTotens.Visible := True;
    //lblFluxos.Visible := True;
    lblTipo.Visible := True;
    //AlinharLabels;
    PreviewModal;
  end;
  {$ENDIF SuportaQuickRep}
end;

procedure TfrmSicsReportTotem.PreencherTagsCdsEventos;
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

procedure TfrmSicsReportTotem.ComponentesCallCenter;
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


