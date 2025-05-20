unit Sics_Common_SituationShow;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}
uses
  {$IFNDEF IS_MOBILE}
  Windows, Messages, ScktComp,
  {$ENDIF}
  FMX.Grid, FMX.Controls, FMX.Forms, FMX.Graphics,
  FMX.Dialogs, FMX.StdCtrls, FMX.ExtCtrls, FMX.Types, FMX.Layouts, AspLayout, FMX.ListView.Types,
  FMX.ListView, FMX.ListBox, 
  AspFMXHelper, Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors, FMX.Objects, FMX.Edit, FMX.TabControl,

  System.UIConsts, System.Generics.Defaults, System.Generics.Collections,
  System.UITypes, System.Types, System.SysUtils, System.Classes, System.Variants, Data.DB, Datasnap.DBClient, System.Rtti,
  Data.Bind.EngExt, Data.Bind.Components,
  Data.Bind.Grid, Data.Bind.DBScope,
  ClassLibrary, MyDlls_DX,
  IniFiles, untCommonFormBase, untCommonFrameBase;

type
  TfrmSicsCommon_MostraSituacaoAtendimento = class(TForm)
    CloseButton: TBitBtn;
    FinalizarAtendimentoButton: TAspButton;
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    gridPAs: TDBGrid;
    TabSheet2: TTabSheet;
    gridAtds: TDBGrid;
    cdsPAs: TClientDataSet;
    cdsPAsId_PA: TIntegerField;
    cdsPAsLKUP_PA: TStringField;
    cdsPAsLKUP_ID_GRUPO: TIntegerField;
    cdsPAsLKUP_GRUPO: TStringField;
    cdsPAsId_Atd: TIntegerField;
    cdsPAsLKUP_ATD: TStringField;
    cdsPAsSENHA: TIntegerField;
    cdsPAsHorario: TDateTimeField;
    cdsPAsId_Fila: TIntegerField;
    cdsPAsLKUP_FILA: TStringField;
    cdsAtds: TClientDataSet;
    IntegerField2: TIntegerField;
    cdsAtdsLKUP_ATD: TStringField;
    cdsAtdsLKUP_ID_GRUPO: TIntegerField;
    cdsAtdsLKUP_GRUPO: TStringField;
    IntegerField1: TIntegerField;
    cdsAtdsLKUP_PA: TStringField;
    IntegerField4: TIntegerField;
    DateTimeField1: TDateTimeField;
    cdsAtdsId_Fila: TIntegerField;
    cdsAtdsLKUP_FILA: TStringField;
    dsAtds: TDataSource;
    dsPAs: TDataSource;
    cdsPAsNomeCliente: TStringField;
    cdsAtdsNomeCliente: TStringField;
    cdsPAsId_MotivoPausa: TIntegerField;
    cdsPAsLKUP_MOTIVOPAUSA: TStringField;
    cdsAtdsId_MotivoPausa: TIntegerField;
    cdsAtdsLKUP_MOTIVOPAUSA: TStringField;
    cdsPAsLKUP_STATUS: TStringField;
    cdsAtdsLKUP_STATUS: TStringField;
    cdsPAsId_Status: TIntegerField;
    cdsAtdsId_Status: TIntegerField;
    procedure CloseButtonClick(Sender: TObject);
    procedure FinalizarAtendimentoButtonClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure LKUP_PAGetText(Sender: TField; var Text: String; DisplayText: Boolean);
    procedure LKUP_GRUPOGetText(Sender: TField; var Text: String; DisplayText: Boolean);
    procedure LKUP_ATDGetText(Sender: TField; var Text: String; DisplayText: Boolean);
    procedure LKUP_FILAGetText(Sender: TField; var Text: String; DisplayText: Boolean);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure UpdatePASituation(PA, StatusPA, ATD: integer; PWD: string; FilaProveniente, MotivoPausa: integer; TIM: TDateTime; NomeCliente: string);
    function UpdateNomeCliente(Senha: integer; Nome: string): Boolean;
    procedure AtualizaListaDeAtendentes;
    procedure AtualizaListaDePAs;
    procedure AtualizaLookUps;
  end;

function frmSicsCommon_MostraSituacaoAtendimento(const aIDUnidade: Integer = 0): TfrmSicsCommon_MostraSituacaoAtendimento;
implementation

uses untCommonDMConnection,


untCommonDMClient,
{$IFDEF CompilarPara_TGS}
sics_94,
{$ENDIF CompilarPara_TGS}
Sics_Common_Parametros, Aspect;

{$R *.fmx}
{ %CLASSGROUP 'FMX.Controls.TControl' }

function frmSicsCommon_MostraSituacaoAtendimento(const aIDUnidade: Integer = 0): TfrmSicsCommon_MostraSituacaoAtendimento;
begin
  Result := TfrmSicsCommon_MostraSituacaoAtendimento(FGerenciadorUnidades.FormGerenciado[tcSituacaoShow, aIDUnidade]);
end;

procedure TfrmSicsCommon_MostraSituacaoAtendimento.UpdatePASituation(PA, StatusPA, ATD: integer; PWD: string; FilaProveniente, MotivoPausa: integer; TIM: TDateTime; NomeCliente: string);
var
  BM1, BM2           : TBookmark;
  AtdLogado, PALogada: integer;
begin
  cdsPAs.DisableControls;
  cdsAtds.DisableControls;
  try
    AtdLogado := -1;
    PALogada  := -1;

    BM1 := cdsAtds.GetBookmark;
    BM2 := cdsPAs.GetBookmark;
    try
      with cdsAtds do
        if ((Locate('ID_ATD', ATD, [])) and (not FieldByName('ID_PA').IsNull)) then
          PALogada := FieldByName('ID_PA').AsInteger;

      with cdsPAs do
        if ((Locate('ID_PA', PA, [])) and (not FieldByName('ID_ATD').IsNull)) then
          AtdLogado := FieldByName('ID_ATD').AsInteger;

      with cdsPAs do
      begin
        if PA <> PALogada then
        begin
          if Locate('ID_PA', PALogada, []) then
          begin
            Edit;

            FieldByName('ID_STATUS').Clear;
            FieldByName('ID_ATD').Clear;
            FieldByName('SENHA').Clear;
            FieldByName('ID_FILA').Clear;
            FieldByName('ID_MOTIVOPAUSA').Clear;
            FieldByName('HORARIO').AsDateTime := TIM;

            Post;
          end;
        end;

        if Locate('ID_PA', PA, []) then
        begin
          Edit;

          if StatusPA = -1 then
            FieldByName('ID_STATUS').Clear
          else
            FieldByName('ID_STATUS').AsInteger := StatusPA;

          if ATD = -1 then
            FieldByName('ID_ATD').Clear
          else
            FieldByName('ID_ATD').AsInteger := ATD;

          if ((PWD = '-1') or (PWD = '---')) then
            FieldByName('SENHA').Clear
          else
            FieldByName('SENHA').AsString := PWD;

          if FilaProveniente = -1 then
            FieldByName('ID_FILA').Clear
          else
            FieldByName('ID_FILA').AsInteger := FilaProveniente;

          if MotivoPausa = -1 then
            FieldByName('ID_MOTIVOPAUSA').Clear
          else
            FieldByName('ID_MOTIVOPAUSA').AsInteger := MotivoPausa;

          FieldByName('HORARIO').AsDateTime   := TIM;
          FieldByName('NomeCliente').AsString := NomeCliente;

          Post;
        end;
      end;

      with cdsAtds do
      begin
        if ATD <> AtdLogado then
        begin
          if Locate('ID_ATD', AtdLogado, []) then
          begin
            Edit;

            FieldByName('ID_STATUS').Clear;
            FieldByName('ID_PA').Clear;
            FieldByName('SENHA').Clear;
            FieldByName('ID_FILA').Clear;
            FieldByName('ID_MOTIVOPAUSA').Clear;
            FieldByName('HORARIO').AsDateTime := TIM;

            Post;
          end;
        end;

        if Locate('ID_ATD', ATD, []) then
        begin
          Edit;

          if StatusPA = -1 then
            FieldByName('ID_STATUS').Clear
          else
            FieldByName('ID_STATUS').AsInteger := StatusPA;

          if PA = -1 then
            FieldByName('ID_PA').Clear
          else
            FieldByName('ID_PA').AsInteger := PA;

          if ((PWD = '-1') or (PWD = '---')) then
            FieldByName('SENHA').Clear
          else
            FieldByName('SENHA').AsString := PWD;

          if FilaProveniente = -1 then
            FieldByName('ID_FILA').Clear
          else
            FieldByName('ID_FILA').AsInteger := FilaProveniente;

          if MotivoPausa = -1 then
            FieldByName('ID_MOTIVOPAUSA').Clear
          else
            FieldByName('ID_MOTIVOPAUSA').AsInteger := MotivoPausa;

          FieldByName('HORARIO').AsDateTime   := TIM;
          FieldByName('NomeCliente').AsString := NomeCliente;

          Post;
        end;
      end;
    finally
      cdsAtds.GotoBookmark(BM1);
      cdsPAs.GotoBookmark(BM2);

      cdsAtds.FreeBookmark(BM1);
      cdsPAs.FreeBookmark(BM2);
    end;
  finally
    cdsPAs.EnableControls;
    cdsAtds.EnableControls;
  end;
end; { proc UpdatePASituation }

function TfrmSicsCommon_MostraSituacaoAtendimento.UpdateNomeCliente(Senha: integer; Nome: string): Boolean;
var
  BM1, BM2: TBookmark;
begin
  Result := false;
  cdsPAs.DisableControls;
  cdsAtds.DisableControls;
  try
    BM1 := cdsAtds.GetBookmark;
    BM2 := cdsPAs.GetBookmark;
    try
      with cdsPAs do
        if Locate('SENHA', Senha, []) then
        begin
          Edit;
          FieldByName('NomeCliente').AsString := Nome;
          Post;
          Result := true;
        end;

      with cdsAtds do
        if Locate('SENHA', Senha, []) then
        begin
          Edit;
          FieldByName('NomeCliente').AsString := Nome;
          Post;
          Result := true;
        end;
    finally
      cdsAtds.GotoBookmark(BM1);
      cdsPAs.GotoBookmark(BM2);

      cdsAtds.FreeBookmark(BM1);
      cdsPAs.FreeBookmark(BM2);
    end;
  finally
    cdsPAs.EnableControls;
    cdsAtds.EnableControls;
  end;
end; { func UpdateNomeCliente }

procedure TfrmSicsCommon_MostraSituacaoAtendimento.AtualizaListaDePAs;
var
  nowtime: TDateTime;
begin
  with cdsPAs do
  begin
    First;
    while not eof do
      Delete;
  end;

  nowtime := now;

  DMClient.cdsPAs.First;
  while not DMClient.cdsPAs.eof do
  begin
    cdsPAs.Append;

    cdsPAs.FieldByName('Id_PA').AsInteger    := DMClient.cdsPAs.FieldByName('ID').AsInteger;
    cdsPAs.FieldByName('Horario').AsDateTime := nowtime;

    cdsPAs.Post;

    DMClient.cdsPAs.Next;
  end; { with }
end;

procedure TfrmSicsCommon_MostraSituacaoAtendimento.AtualizaLookUps;
var
  BM: TBookmark;
begin
  with cdsPAs do
  begin
    BM := GetBookmark;
    try
      First;           // Como o campo nome do PP é um LookUp, uma simples varredura no cds
      while not eof do // deve ser suficiente para dar um refresh em todo estes LookUps. Testar.
        Next;
    finally
      GotoBookmark(BM);
      FreeBookmark(BM);
    end;
  end;

  with cdsAtds do
  begin
    BM := GetBookmark;
    try
      First;           // Como o campo nome do PP é um LookUp, uma simples varredura no cds
      while not eof do // deve ser suficiente para dar um refresh em todo estes LookUps. Testar.
        Next;
    finally
      GotoBookmark(BM);
      FreeBookmark(BM);
    end;
  end;
end;

procedure TfrmSicsCommon_MostraSituacaoAtendimento.AtualizaListaDeAtendentes;
var
  nowtime: TDateTime;
begin
  with cdsAtds do
  begin
    First;
    while not eof do
      Delete;
  end;
  nowtime := now;

  DMClient.cdsAtendentes.First;
  while not DMClient.cdsAtendentes.eof do
  begin
    cdsAtds.Append;

    cdsAtds.FieldByName('Id_Atd').AsInteger   := DMClient.cdsAtendentes.FieldByName('ID').AsInteger;
    cdsAtds.FieldByName('Horario').AsDateTime := nowtime;

    cdsAtds.Post;

    DMClient.cdsAtendentes.Next;
  end; { with }
end;

{ ======================================================================== }

procedure TfrmSicsCommon_MostraSituacaoAtendimento.FormResize(Sender: TObject);
const
  OFF = 5;
var
  i, ColunasVariaveis: integer;
  Col_ID, Col_NomePA, Col_Grupo, Col_NomeAtd, Col_Senha, Col_NomeCliente, Col_Horario, Col_Fila, Col_Status, Col_MotivoPausa: integer;
begin
  PageControl.Top    := OFF;
  PageControl.Left   := OFF;
  PageControl.Width  := ClientWidth - 2 * OFF;
  PageControl.Height := ClientHeight - FinalizarAtendimentoButton.Height - 3 * OFF;

  FinalizarAtendimentoButton.Top  := ClientHeight - FinalizarAtendimentoButton.Height - OFF;
  FinalizarAtendimentoButton.Left := OFF;
  CloseButton.Top                 := FinalizarAtendimentoButton.Top;
  CloseButton.Left                := PageControl.Left + PageControl.Width - CloseButton.Width;

  Col_ID          := 0;
  Col_NomePA      := 1;
  Col_Grupo       := 2;
  Col_Status      := 3;
  Col_NomeAtd     := 4;
  Col_Senha       := 5;
  Col_NomeCliente := 6;
  Col_Horario     := 7;
  Col_Fila        := 8;
  Col_MotivoPausa := 9;

  if not cdsPAsLKUP_GRUPO.Visible then
  begin
    Col_Grupo       := -1;
    Col_Status      := Col_Status - 1;
    Col_NomeAtd     := Col_NomeAtd - 1;
    Col_Senha       := Col_Senha - 1;
    Col_NomeCliente := Col_NomeCliente - 1;
    Col_Horario     := Col_Horario - 1;
    Col_Fila        := Col_Fila - 1;
    Col_MotivoPausa := Col_MotivoPausa - 1;
  end;

  if not cdsPAsNomeCliente.Visible then
  begin
    Col_NomeCliente := -1;
    Col_Horario     := Col_Horario - 1;
    Col_Fila        := Col_Fila - 1;
    Col_MotivoPausa := Col_MotivoPausa - 1;
  end;

  if not cdsPAsLKUP_MOTIVOPAUSA.Visible then
  begin
    Col_MotivoPausa := -1;
  end;

  with gridPAs do
  begin
    Columns[Col_ID].Width      := Canvas.TextWidth(' 333 ');
    Columns[Col_Senha].Width   := Canvas.TextWidth(' Senha ');
    Columns[Col_Horario].Width := Canvas.TextWidth(' 88:88:88 ');
    Columns[Col_Status].Width  := Canvas.TextWidth(' Em atendimento ');

    ColunasVariaveis := 6;
    if not cdsPAsLKUP_GRUPO.Visible then
      ColunasVariaveis := ColunasVariaveis - 1;
    if not cdsPAsNomeCliente.Visible then
      ColunasVariaveis := ColunasVariaveis - 1;
    if not cdsPAsLKUP_MOTIVOPAUSA.Visible then
      ColunasVariaveis := ColunasVariaveis - 1;

    Columns[Col_NomePA].Width := (ClientWidth - Columns[Col_ID].Width - Columns[Col_Senha].Width - Columns[Col_Horario].Width - Columns[Col_Status].Width - (ColunasVariaveis + 2)) div ColunasVariaveis;

    if Col_Grupo <> -1 then
      Columns[Col_Grupo].Width := Columns[Col_NomePA].Width;
    if Col_NomeCliente <> -1 then
      Columns[Col_NomeCliente].Width := Columns[Col_NomePA].Width;
    Columns[Col_NomeAtd].Width       := Columns[Col_NomePA].Width;
    Columns[Col_Fila].Width          := Columns[Col_NomePA].Width;
    if Col_MotivoPausa <> -1 then
      Columns[Col_MotivoPausa].Width := Columns[Col_NomePA].Width;
  end;

  for i                       := 0 to gridAtds.Columns.Count - 1 do
    gridAtds.Columns[i].Width := gridPAs.Columns[i].Width;
end; { proc FormResize }

procedure TfrmSicsCommon_MostraSituacaoAtendimento.FormCreate(Sender: TObject);
begin
  Aspect.LoadPosition(Sender as TForm);
  FGerenciadorUnidades.Add(tcSituacaoShow, Self);
end;

procedure TfrmSicsCommon_MostraSituacaoAtendimento.FormDestroy(Sender: TObject);
begin
  Aspect.SavePosition(Sender as TForm);
  FGerenciadorUnidades.Remove(tcSituacaoShow, Self);
end; { proc FormDestroy }

{ ------------------------------------------------ }

procedure TfrmSicsCommon_MostraSituacaoAtendimento.FinalizarAtendimentoButtonClick(Sender: TObject);
(* var
  a : array[0..255] of char;
  p : PChar;
  SenhaAtendida : string;
  nowtime, initime : TDateTime; *)
begin
  (* with SituationGrid do
    begin
    if ((Row >= 1) and (Row <= RowCount - 1)) then
    begin
    p := @a;
    StrPCopy (p, 'Finalizar atendimento de "' + Cells[1,Row] + '"?');
    if GetApplication.MessageBox (p, 'Confirmação', MB_ICONQUESTION or MB_YESNO) = mrYes then
    begin
    SenhaAtendida := Cells[2,Row];
    if SenhaAtendida <> '---' then
    begin
    IniTime := strtoDateTime(Cells[4,Row]);
    NowTime := now;
    IncludeAtendimento2 (ord(atAtendimento), Row, strtoint(SenhaAtendida), IniTime, nowtime);
    Cells[2,Row] := '---';
    Cells[3,Row] := FormatDateTime('hh:nn:ss', nowtime);
    Cells[4,Row] := FormatDateTime('dd/mm/yyyy hh:nn:ss', nowtime);
    end;  { if SenhaAtendida <> '---' }
    end;  { if GetApplication.MessageBox }
    end;  { if Row between 1 and maxguiches }
    end;  { with SituationGrid } *)
end; { proc FinalizarAtendimentoButtonClick }

procedure TfrmSicsCommon_MostraSituacaoAtendimento.CloseButtonClick(Sender: TObject);
begin
  Close;
end; { proc CloseButtonClick }

procedure TfrmSicsCommon_MostraSituacaoAtendimento.LKUP_PAGetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  Text := Sender.AsString;

  if ((Sender.AsString = '') and (not Sender.DataSet.FieldByName('Id_PA').IsNull)) then
    Text := '???';
end;

procedure TfrmSicsCommon_MostraSituacaoAtendimento.LKUP_GRUPOGetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  Text := Sender.AsString;

  if ((Sender.AsString = '') and (not Sender.DataSet.FieldByName('LKUP_Id_Grupo').IsNull)) then
    Text := '???';
end;

procedure TfrmSicsCommon_MostraSituacaoAtendimento.LKUP_ATDGetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  Text := Sender.AsString;

  if ((Sender.AsString = '') and (not Sender.DataSet.FieldByName('Id_Atd').IsNull)) then
    Text := '???';
end;

procedure TfrmSicsCommon_MostraSituacaoAtendimento.LKUP_FILAGetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  Text := Sender.AsString;

  if ((Sender.AsString = '') and (not Sender.DataSet.FieldByName('Id_Fila').IsNull)) then
    Text := '???';
end;

procedure TfrmSicsCommon_MostraSituacaoAtendimento.FormShow(Sender: TObject);
begin

{$IF Defined(CompilarPara_TGS) or Defined(CompilarPara_PA)}

  cdsPAsLKUP_GRUPO.Visible  := ParametrosModulo.VisualizarGrupos;
  cdsAtdsLKUP_GRUPO.Visible := ParametrosModulo.VisualizarGrupos;

{$ELSE}

  cdsPAsLKUP_GRUPO.Visible  := true;
  cdsAtdsLKUP_GRUPO.Visible := true;

{$ENDIF}
{$IFDEF CompilarPara_PA_MULTIPA}

  cdsPAsNomeCliente.Visible       := ParametrosModulo.MostrarNomeCliente;
  cdsAtdsNomeCliente.Visible      := ParametrosModulo.MostrarNomeCliente;
  cdsPAsLKUP_MOTIVOPAUSA.Visible  := ParametrosModulo.MostrarPausa;
  cdsAtdsLKUP_MOTIVOPAUSA.Visible := ParametrosModulo.MostrarPausa;

{$ELSE}

  cdsPAsNomeCliente.Visible       := true;
  cdsAtdsNomeCliente.Visible      := true;
  cdsPAsLKUP_MOTIVOPAUSA.Visible  := true;
  cdsAtdsLKUP_MOTIVOPAUSA.Visible := true;

{$ENDIF CompilarPara_PA_MULTIPA}

end;

end.
