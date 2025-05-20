unit untCommonFormProcessoParalelo;

interface
{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  {$IFNDEF IS_MOBILE}
  Windows, Messages, ScktComp,
  {$ENDIF}
  FMX.Grid, FMX.Controls, FMX.Forms, FMX.Graphics,
  FMX.Dialogs, FMX.StdCtrls, FMX.ExtCtrls, FMX.Types, FMX.Layouts, FMX.ListView.Types,
  FMX.ListView, FMX.ListBox,
   Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors, FMX.Objects, FMX.Edit, FMX.TabControl,
  System.SysUtils,
  System.UITypes, System.Types, System.Classes, System.Variants, Data.DB, Datasnap.DBClient, System.Rtti,
  Data.Bind.EngExt, Data.Bind.Components,
  Data.Bind.Grid, Data.Bind.DBScope,
  MyAspFuncoesUteis, untCommonFormBase, untCommonFrameBase, FMX.Controls.Presentation,
  System.ImageList, FMX.ImgList, FMX.Effects, FMX.Grid.Style, FMX.ScrollBox;

type
  TFrmProcessoParalelo = class(TFrmBase)
    Layout1: TLayout;
    layBotoes: TLayout;
    btnNovo: TButton;
    btnFinalizar: TButton;
    btnFechar: TButton;
    grdPPs: TGrid;
    lblEmAndamento: TLabel;
    cdsPPs: TClientDataSet;
    cdsPPsId_EventoPP: TIntegerField;
    cdsPPsId_TipoPP: TIntegerField;
    cdsPPsId_PA: TIntegerField;
    cdsPPsId_Atd: TIntegerField;
    cdsPPslkp_TipoPP_Nome: TStringField;
    cdsPPsTicketNumber: TIntegerField;
    cdsPPsNomeCliente: TStringField;
    cdsPPslkp_PA_Nome: TStringField;
    cdsPPslkp_Atd_Nome: TStringField;
    cdsPPsHorario: TDateTimeField;
    cdsPPsCTRL_RegistroAtualizado: TBooleanField;
    dtsPPs: TDataSource;
    bndPPs: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    ilPrincipal: TImageList;
    procedure cdsPPsAfterOpen(DataSet: TDataSet);
    procedure FormShow(Sender: TObject);
    procedure btnFinalizarClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure dtsPPsStateChange(Sender: TObject);
    procedure dtsPPsDataChange(Sender: TObject; Field: TField);
    procedure btnNovoClick(Sender: TObject);
  private
    procedure HabilitaBotoes;
  public
    ListagemServidor       : Boolean;
    AtdAtual, PAAtual, SenhaAtual: Integer;

    procedure AtualizarColunasGrid; Override;
    procedure AtualizaLookUps;
    procedure UpdateNomeCliente(Senha: Integer; Nome: string);
    procedure IniciarAtualizacao;
    procedure UpdatePPSituation(IdEventoPP, IdPP, IdPA, IdATD, TicketNumber: Integer; NomeCliente: string; Horario: TDateTime);
    procedure ConcluirAtualizacao;
    function GetSituacaoAtual: string;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; Override;
    procedure CarregarParametrosDB; Override;
  end;

function FrmProcessoParalelo(const aIDUnidade: integer; const aAllowNewInstance: Boolean = False; const aOwner: TComponent = nil): TFrmProcessoParalelo;

implementation

uses
  untCommonDMConnection, untCommonFormSelecaoPP, Sics_Common_Parametros,
  untCommonFormStyleBook, untCommonDMUnidades;

{$R *.fmx}

{ %CLASSGROUP 'FMX.Controls.TControl' }

{ TFrmProcessoParalelo }

function FrmProcessoParalelo(const aIDUnidade: integer; const aAllowNewInstance: Boolean = False; const aOwner: TComponent = nil): TFrmProcessoParalelo;
begin
  Result := TFrmProcessoParalelo(TFrmProcessoParalelo.GetInstancia(aIDUnidade, aAllowNewInstance, aOwner));
end;

procedure TFrmProcessoParalelo.AtualizarColunasGrid;
begin
  if Self.Visible and cdsPPs.Active then
    AspUpdateColunasGrid(Self, grdPPs, cdsPPs);
end;

procedure TFrmProcessoParalelo.AtualizaLookUps;
var
  BM: TBookmark;
begin
  // ********************************************************************************
  // V4 - Como o campo nome do PP é um LookUp, uma simples varredura no cds
  // deve ser suficiente para dar um refresh em todo estes LookUps. Testar.
  // ********************************************************************************
  with cdsPPs do
  begin
    if not Active then
      Exit;

    BM := GetBookmark;
    try
      First;
      while not eof do
        Next;
      if BookmarkValid(BM) then
        GotoBookmark(BM);
    finally
      FreeBookmark(BM);
    end;
  end;
end;

procedure TFrmProcessoParalelo.btnFecharClick(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TFrmProcessoParalelo.btnFinalizarClick(Sender: TObject);
var
  s, AtdStr : string;
  LSituacaoPAAoExibirForm, LSituacaoPPAoExibirForm: String;
begin
  s := '';
  try
    if (grdPPs.Selected < 0) then
    begin
      ErrorMessage('Nenhum processo paralelo foi selecionado.');
      Exit;
    end;

    LSituacaoPPAoExibirForm := GetSituacaoAtual;
    LSituacaoPAAoExibirForm := dmUnidades.FormClient.GetSituacaoAtual; //***
    ConfirmationMessage('Confirma finalização dos processos paralelos selecionados?',
      procedure (const aOK: Boolean)
      begin
        if aOK then
        begin
          if (LSituacaoPPAoExibirForm = GetSituacaoAtual) and
             (LSituacaoPAAoExibirForm = dmUnidades.FormClient.GetSituacaoAtual) then
          begin
            //Verificar como implementar multi-select
            cdsPPs.RecNo := grdPPs.Selected + 1;
            s := s + cdsPPs.fieldByName('Id_EventoPP').AsString + ';';

            if s <> '' then
            begin
              if AtdAtual = -1 then
                AtdStr := '----'
              else
                AtdStr := IntToHex(AtdAtual,4);

              DMConnection(0, not CRIAR_SE_NAO_EXISTIR).EnviarComando(IntToHex(PAAtual,4) + Chr($5A) + AtdStr + inttostr(SenhaAtual) + ',' + s, Self.IDUnidade);
            end;
          end
          else
            ErrorMessage(Format('Situação do processo paralelo foi alterada de %s para %s.' + #13 +
                                'Situação do atendimento foi alterada de %s para %s.',
              [LSituacaoPPAoExibirForm, GetSituacaoAtual,
               LSituacaoPAAoExibirForm, dmUnidades.FormClient.GetSituacaoAtual]));
        end;
        GetApplication.ProcessMessages;
      end);
  finally
    HabilitaBotoes;
  end;
end;

procedure TFrmProcessoParalelo.btnNovoClick(Sender: TObject);
{$IFDEF CompilarPara_PA_MULTIPA}
var
  LSituacaoPPAoExibirForm, LSituacaoPAAoExibirForm: string;
  LFrmSelecaoPP: TFrmSelecaoPP;
begin
  LSituacaoPPAoExibirForm := GetSituacaoAtual;
  LSituacaoPAAoExibirForm := dmUnidades.FormClient.GetSituacaoAtualPA(PAAtual);

  LFrmSelecaoPP := FrmSelecaoPP(IDUnidade);
  LFrmSelecaoPP.ShowModal(
    procedure (aModalResult: TModalResult)
    var
      AtdStr: string;
    begin
      if (aModalResult = mrOk) then
      begin
        if ((LSituacaoPPAoExibirForm = GetSituacaoAtual) and
            (LSituacaoPAAoExibirForm = dmUnidades.FormClient.GetSituacaoAtualPA(PAAtual))) then
        begin
          if AtdAtual = -1 then
            AtdStr := '----'
          else
            AtdStr := TAspEncode.AspIntToHex(AtdAtual, 4);

          DMConnection(IdUnidade, not CRIAR_SE_NAO_EXISTIR).EnviarComando(TAspEncode.AspIntToHex(PAAtual, 4) + Chr($68) + AtdStr +
            TAspEncode.AspIntToHex(LFrmSelecaoPP.IdSelecionado, 4) + inttostr(SenhaAtual), Self.IDUnidade);
        end
        else
          ErrorMessage(Format('Situação do processo paralelo foi alterada de %s para %s.' + #13 +
                              'Situação do atendimento foi alterada de %s para %s.',
            [LSituacaoPPAoExibirForm, GetSituacaoAtual,
            LSituacaoPAAoExibirForm, dmUnidades.FormClient.GetSituacaoAtualPA(PAAtual)]));
      end;
    end);
end;
{$ELSE}
begin

end;
{$ENDIF}


procedure TFrmProcessoParalelo.CarregarParametrosDB;
begin
  inherited;

  {$IFDEF CompilarPara_PA_MULTIPA}
  cdsPPs.FieldByName('NomeCliente').Visible := vgParametrosModulo.MostrarNomeCliente;
  {$ELSE}
  cdsPPs.FieldByName('NomeCliente').Visible := True;
  {$ENDIF CompilarPara_PA_MULTIPA}
end;

procedure TFrmProcessoParalelo.cdsPPsAfterOpen(DataSet: TDataSet);
begin
  inherited;
  AtualizarColunasGrid;
  HabilitaBotoes;
  grdPPs.Repaint;
  GetApplication.ProcessMessages;
end;

procedure TFrmProcessoParalelo.ConcluirAtualizacao;
begin
  {$IFDEF CompilarPara_PA_MULTIPA}
  ListagemServidor := True;
  {$ENDIF}

  {$IFDEF CompilarPara_TGS}
  with cdsPPs do
  begin
    Filter   := 'CTRL_RegistroAtualizado = False';
    Filtered := True;
    try
      First;
      while not eof do
        Delete;
    finally
      Filtered := false;
    end;
  end;
  {$ENDIF}
  HabilitaBotoes;
end;

constructor TFrmProcessoParalelo.Create(AOwner: TComponent);
begin
  inherited;
end;

destructor TFrmProcessoParalelo.Destroy;
begin
  inherited;
end;

procedure TFrmProcessoParalelo.dtsPPsDataChange(Sender: TObject; Field: TField);
begin
  inherited;
  HabilitaBotoes;
end;

procedure TFrmProcessoParalelo.dtsPPsStateChange(Sender: TObject);
begin
  inherited;
  HabilitaBotoes;
end;

procedure TFrmProcessoParalelo.FormShow(Sender: TObject);
begin
  inherited;

  {$IFDEF CompilarPara_PA_MULTIPA}
  btnNovo.Visible      := True;
  btnFinalizar.Visible := True;
  {$ELSE}
  btnNovo.Visible      := false;
  btnFinalizar.Visible := false;
  {$ENDIF}
end;

function TFrmProcessoParalelo.GetSituacaoAtual: string;
begin
  Result := Format('Listagem Servidor: %s. Atend. Atual: %d. PA Atual: %d. Senha Atual: %d.',
    [BoolToStr(ListagemServidor), AtdAtual, PAAtual, SenhaAtual]);
end;

procedure TFrmProcessoParalelo.HabilitaBotoes;
var
  LAtivarBotaoFinalizar: Boolean;
begin
  LAtivarBotaoFinalizar := cdsPPs.Active and (cdsPPs.RecordCount > 0) and (grdPPs.Selected >= 0);
  if (LAtivarBotaoFinalizar <> btnFinalizar.Enabled) then
  begin
    btnFinalizar.Enabled := LAtivarBotaoFinalizar;
    GetApplication.ProcessMessages;
  end;
end;

procedure TFrmProcessoParalelo.IniciarAtualizacao;
begin
  {$IFDEF CompilarPara_PA_MULTIPA}
  cdsPPs.EmptyDataSet;
  {$ENDIF CompilarPara_PA_MULTIPA}

  {$IFDEF CompilarPara_TGS_ONLINE}
    with cdsPPs do
    begin
      First;
      while not eof do
      begin
        Edit;
        FieldByName('CTRL_RegistroAtualizado').AsBoolean := false;
        Post;
        Next;
      end;
    end;
  {$ENDIF CompilarPara_TGS_ONLINE}

  grdPPs.Selected := -1;
end;

procedure TFrmProcessoParalelo.UpdateNomeCliente(Senha: Integer; Nome: string);
var
  cdsClone: TClientDataSet;
begin
  cdsClone := TClientDataSet.Create(nil);
  with cdsClone do
  begin
    try
      CloneCursor(cdsPPs, True);

      Filter   := 'TicketNumber = ' + inttostr(Senha);
      Filtered := True;

      First;
      while not eof do
      begin
        Edit;
        FieldByName('NomeCliente').AsString := Nome;
        Post;
        Next;
      end;
    finally
      FreeAndNil(cdsClone);
    end;
  end;
end;

procedure TFrmProcessoParalelo.UpdatePPSituation(IdEventoPP, IdPP, IdPA, IdATD, TicketNumber: Integer; NomeCliente: string; Horario: TDateTime);
var
  BM: TBookmark;
begin
  with cdsPPs do
  begin
    BM := GetBookmark;
    try
      try
        if Locate('Id_EventoPP', IdEventoPP, []) then
          Edit
        else
        begin
          Append;
          FieldByName('Id_EventoPP').AsInteger := IdEventoPP;
        end;

        FieldByName('Id_TipoPP').AsInteger    := IdPP;
        FieldByName('Id_PA').AsInteger        := IdPA;
        FieldByName('Id_ATD').AsInteger       := IdATD;
        FieldByName('TicketNumber').AsInteger := TicketNumber;
        FieldByName('NomeCliente').AsString   := NomeCliente;
        FieldByName('Horario').AsDateTime     := Horario;

        FieldByName('CTRL_RegistroAtualizado').AsBoolean := True;

        Post;
      finally
        if BookmarkValid(BM) then
          GotoBookmark(BM);
      end;
    finally
      FreeBookmark(BM);
    end;
  end;
end;

end.

