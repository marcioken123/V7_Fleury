unit Sics_Common_VisualizaManipulaPPs;


interface
{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  {$IFNDEF NEXTGEN}
  Windows, Messages, ScktComp,
  {$ENDIF}
  FMX.Grid, FMX.Controls, FMX.Forms, FMX.Graphics,
  FMX.Dialogs, FMX.StdCtrls, FMX.ExtCtrls, FMX.Types, FMX.Layouts, AspLayout, FMX.ListView.Types,
  FMX.ListView, FMX.ListBox, 
   Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors, FMX.Objects, FMX.Edit, FMX.TabControl,
 
  System.UIConsts, System.Generics.Defaults, System.Generics.Collections,
  System.UITypes, System.Types, System.SysUtils, System.Classes, System.Variants, Data.DB, Datasnap.DBClient, System.Rtti, 
  Data.Bind.EngExt, Data.Bind.Components,
  Data.Bind.Grid, Data.Bind.DBScope, 
  AspFMXHelper, ClassLibrary, MyDlls_DX,  
  IniFiles, untCommonFormBase, untCommonFrameBase, FMX.Controls.Presentation, AspButton, AspLabelFMX;

type
  TfrmSicsCommon_VisualizaManipulaPPs = class(TForm)
    gridPPs: TStringGrid;
    Label1: TAspLabel;
    btnNovo: TAspButton;
    btnFinalizar: TAspButton;
    btnFechar: TAspButton;
    dsPPs: TDataSource;
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
    cdsClonePPs: TClientDataSet;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    procedure FormResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnFinalizarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cdsPPsAfterOpen(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    fListagemObtidaDoServidor        : boolean;
    fAtdAtual, fPAAtual, fSenhaAtual : integer;


    procedure AtualizaLookUps;
    procedure UpdateNomeCliente (Senha : integer; Nome : string);

    procedure IniciarAtualizacao;
    procedure UpdatePPSituation (IdEventoPP, IdPP, IdPA, IdATD, TicketNumber : integer; NomeCliente : string; Horario : TDateTime);
    procedure ConcluirAtualizacao;
  end;

function frmSicsCommon_VisualizaManipulaPPs(const aIDUnidade: Integer): TfrmSicsCommon_VisualizaManipulaPPs;
implementation

uses
{$IFDEF CompilarPara_PA_MULTIPA}
  Sics_Common_EscolhePP,
{$ENDIF}
 untAspEncode, untCommonDMConnection, Aspect, AspComponenteUnidade;

{$R *.fmx}
{ %CLASSGROUP 'FMX.Controls.TControl' }

function frmSicsCommon_VisualizaManipulaPPs(const aIDUnidade: Integer): TfrmSicsCommon_VisualizaManipulaPPs;
begin
  Result := TfrmSicsCommon_VisualizaManipulaPPs(FGerenciadorUnidades.FormGerenciado[tcManipulaPPs, aIDUnidade]);
end;

procedure TfrmSicsCommon_VisualizaManipulaPPs.FormShow(Sender: TObject);
begin

{$IFDEF CompilarPara_PA_MULTIPA}
  cdsPPs.FieldByName('NomeCliente').Visible := ParametrosModulo.MostrarNomeCliente;
   btnNovo     .Visible := true;
   btnFinalizar.Visible := true;
{$ELSE}
  cdsPPs.FieldByName('NomeCliente').Visible := True;
   btnNovo     .Visible := false;
   btnFinalizar.Visible := false;
{$ENDIF}
end;


procedure TfrmSicsCommon_VisualizaManipulaPPs.FormResize(Sender: TObject);
const
  OFF = 5;
begin
  Label1.Top := OFF;
  Label1.Left := OFF;

  gridPPs.Left   := Label1.Left;
  gridPPs.Top    := Label1.Top + Label1.Height + OFF;
  gridPPs.Width  := ClientWidth - 2*OFF;
  gridPPs.Height := ClientHeight - Label1.Height - btnNovo.Height - 4*OFF;

  with gridPPs do
  begin
    Columns[1].Width := Canvas.TextWidth('  Senha  ');
    if cdsPPs.FieldByName('NomeCliente').Visible then
    begin
      Columns[5].Width := Canvas.TextWidth('   88:88:88   ');
      Columns[0].Width := (Trunc(ClientWidth - Columns[1].Width - Columns[5].Width - 7)) div 4;
      Columns[2].Width := Columns[0].Width;
      Columns[3].Width := Columns[0].Width;
      Columns[4].Width := Columns[0].Width;
    end
    else
    begin
      Columns[4].Width := Canvas.TextWidth('   88:88:88   ');
      Columns[0].Width := (Trunc(ClientWidth - Columns[1].Width - Columns[4].Width - 6)) div 3;
      Columns[2].Width := Columns[0].Width;
      Columns[3].Width := Columns[0].Width;
    end;
  end;

  btnNovo.Left := gridPPs.Left;
  btnNovo.Top  := gridPPs.Top + gridPPs.Height + OFF;

  btnFinalizar.Left := btnNovo.Left + btnNovo.Width + OFF;
  btnFinalizar.Top  := btnNovo.Top;

  btnFechar.Left := gridPPs.Left + gridPPs.Width - btnFechar.Width;
  btnFechar.Top  := btnNovo.Top;
end;  { proc FormResize }


procedure TfrmSicsCommon_VisualizaManipulaPPs.FormCreate(Sender: TObject);
begin
  Aspect.LoadPosition(Sender as TForm);
  FGerenciadorUnidades.Add(tcManipulaPPs, Self);
end;

procedure TfrmSicsCommon_VisualizaManipulaPPs.FormDestroy(Sender: TObject);
begin
  FGerenciadorUnidades.Remove(tcManipulaPPs, Self);
  aspect.SavePosition (Sender as TForm);
end;

{======================================}

procedure TfrmSicsCommon_VisualizaManipulaPPs.btnNovoClick(Sender: TObject);
{$IFDEF CompilarPara_PA_MULTIPA}
var
  IdPP   : integer;
  AtdStr : string;
{$ENDIF}
begin
{$IFDEF CompilarPara_PA_MULTIPA}
  if GetPP (IdPP) then
  begin
    if fAtdAtual = -1 then
      AtdStr := '----'
    else
      AtdStr := TAspEncode.AspIntToHex(fAtdAtual,4);

    DMConnection.EnviarComando(TAspEncode.AspIntToHex(fPAAtual,4) + Chr($68) + AtdStr + inttohex(IdPP, 4) + inttostr(fSenhaAtual), 0);
  end;
{$ENDIF}
end;  { proc btnNovoClick }


procedure TfrmSicsCommon_VisualizaManipulaPPs.btnFinalizarClick (Sender: TObject);
var
  s, AtdStr : string;
begin
  s := '';

  if (gridPPs.selected > -1) then
  begin
    ConfirmationMessage('Confirma finalização dos processos paralelos selecionados?',
      procedure(const aConfirmation: Boolean)
      begin
        if (aConfirmation) then
        begin
         { for i := 0 to gridPPs.SelectedRows.Count - 1 do
          begin
            cdsPPs.GotoBookmark(pointer(gridPPs.SelectedRows.Items[i]));
            s := s + cdsPPs.fieldByName('Id_EventoPP').AsString + ';';
          end;    }
          cdsPPs.RecNo := gridPPs.selected;
          s := cdsPPs.fieldByName('Id_EventoPP').AsString + ';';

          if s <> '' then
          begin
            if fAtdAtual = -1 then
              AtdStr := '----'
            else
              AtdStr := TAspEncode.AspIntToHex(fAtdAtual,4);

            DMConnection.EnviarComando(TAspEncode.AspIntToHex(fPAAtual,4) + Chr($5A) + AtdStr + inttostr(fSenhaAtual) + ',' + s, 0);
          end;
        end;
      end);
  end;
end;

procedure TfrmSicsCommon_VisualizaManipulaPPs.btnFecharClick(Sender: TObject);
begin
  Close;
end;  { proc btnFecharClick }

{======================================}

procedure TfrmSicsCommon_VisualizaManipulaPPs.UpdateNomeCliente (Senha: integer; Nome: string);
var
  CDSClone : TClientDataSet;
begin
  CDSClone := TClientDataSet.Create(nil);
  with CDSClone do
    try
      CloneCursor(cdsPPs, True);

      Filter := 'TicketNumber = ' + inttostr(senha);
      Filtered := true;

      First;
      while not eof do
      begin
        Edit;
        FieldByName('NomeCliente').AsString := Nome;
        Post;
        Next;
      end;
    finally
      Free;
    end;
end;  { proc UpdateNomeDoCliente }


procedure TfrmSicsCommon_VisualizaManipulaPPs.UpdatePPSituation (IdEventoPP, IdPP, IdPA, IdATD, TicketNumber: integer; NomeCliente: string; Horario: TDateTime);
var
  BM : TBookmark;
begin
  with cdsPPs do
  begin
    BM := GetBookmark;
    try
      if Locate ('Id_EventoPP', IdEventoPP, []) then
        Edit
      else
      begin
        Append;
        FieldByName('Id_EventoPP' ).AsInteger := IdEventoPP;
      end;

      FieldByName('Id_TipoPP'   ).AsInteger  := IdPP;
      FieldByName('Id_PA'       ).AsInteger  := IdPA;
      FieldByName('Id_ATD'      ).AsInteger  := IdATD;
      FieldByName('TicketNumber').AsInteger  := TicketNumber;
      FieldByName('NomeCliente' ).AsString   := NomeCliente;
      FieldByName('Horario'     ).AsDateTime := Horario;

      FieldByName('CTRL_RegistroAtualizado').AsBoolean := true;

      Post;
    finally
      GotoBookmark(BM);
      FreeBookmark(BM);
    end;
  end;
end;  { proc UpdatePPSituation }


procedure TfrmSicsCommon_VisualizaManipulaPPs.AtualizaLookUps;
var
  BM : TBookmark;
begin
  with cdsPPs do
  begin
    BM := GetBookmark;
    try
      First;             //Como o campo nome do PP é um LookUp, uma simples varredura no cds
      while not eof do   //deve ser suficiente para dar um refresh em todo estes LookUps. Testar.
        Next;
    finally
      GotoBookmark(BM);
      FreeBookmark(BM);
    end;
  end;
end;


procedure TfrmSicsCommon_VisualizaManipulaPPs.IniciarAtualizacao;
begin
{$IFDEF CompilarPara_PA_MULTIPA}
  cdsPPs.EmptyDataSet;
{$ELSE} {$IFDEF CompilarPara_TGS_ONLINE}
  with cdsClonePPs do
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
{$ENDIF} {$ENDIF}
  gridPPs.Selected := -1;
end;  { proc IniciarAtualizacao }


procedure TfrmSicsCommon_VisualizaManipulaPPs.ConcluirAtualizacao;
begin
{$IFDEF CompilarPara_PA_MULTIPA}
  fListagemObtidaDoServidor := true;
{$ELSE} {$IFDEF CompilarPara_TGS_ONLINE}
  with cdsClonePPs do
  begin
    Filter := 'CTRL_RegistroAtualizado = false';
    Filtered := true;
    try
      First;
      while not eof do
        Delete;
    finally
      Filtered := false;
    end;
  end;
{$ENDIF} {$ENDIF}
end;  { proc ConcluirAtualizacao }


procedure TfrmSicsCommon_VisualizaManipulaPPs.cdsPPsAfterOpen (DataSet: TDataSet);
begin
  cdsClonePPs.CloneCursor(cdsPPs, true);
end;  { proc cdsPPsAfterOpen }


end.
