unit untCommonFormSituacaoAtendimento;

interface
{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  {$IFNDEF IS_MOBILE}
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
  untCommonFormBase, untCommonFrameBase, FMX.Controls.Presentation;

type
  TStatusPA = (spDeslogado, spDisponivel, spEmAtendimento, spEmPausa);

  TFrmSituacaoAtendimento = class(TFrmBase)
    Layout1: TAspLayout;
    cdsPAs: TClientDataSet;
    cdsPAsId_PA: TIntegerField;
    cdsPAsLKUP_PA: TStringField;
    cdsPAsLKUP_GRUPO: TStringField;
    cdsPAsLKUP_STATUS: TStringField;
    cdsPAsLKUP_ATD: TStringField;
    cdsPAsSENHA: TIntegerField;
    cdsPAsNomeCliente: TStringField;
    cdsPAsHorario: TDateTimeField;
    cdsPAsLKUP_MOTIVOPAUSA: TStringField;
    cdsPAsLKUP_FILA: TStringField;
    cdsPAsLKUP_ID_GRUPO: TIntegerField;
    cdsPAsId_Status: TIntegerField;
    cdsPAsId_Atd: TIntegerField;
    cdsPAsId_Fila: TIntegerField;
    cdsPAsId_MotivoPausa: TIntegerField;
    cdsAtds: TClientDataSet;
    IntegerField2: TIntegerField;
    cdsAtdsLKUP_ATD: TStringField;
    cdsAtdsLKUP_ID_GRUPO: TIntegerField;
    cdsAtdsLKUP_GRUPO: TStringField;
    cdsAtdsId_Status: TIntegerField;
    cdsAtdsLKUP_STATUS: TStringField;
    IntegerField1: TIntegerField;
    cdsAtdsLKUP_PA: TStringField;
    IntegerField4: TIntegerField;
    cdsAtdsNomeCliente: TStringField;
    DateTimeField1: TDateTimeField;
    cdsAtdsId_Fila: TIntegerField;
    cdsAtdsLKUP_FILA: TStringField;
    cdsAtdsId_MotivoPausa: TIntegerField;
    cdsAtdsLKUP_MOTIVOPAUSA: TStringField;
    grpFiltro: TAspGroupBox;
    lblEstado: TAspLabel;
    cmbEstado: TComboBox;
    lblPausa: TAspLabel;
    cmbPausa: TComboBox;
    TabControl: TTabControl;
    tabPAs: TTabItem;
    grdPAs: TGrid;
    tabAtendentes: TTabItem;
    grdAtds: TGrid;
    BindSourceDB1: TBindSourceDB;
    BindSourceDB: TBindSourceDB;
    BindingsList: TBindingsList;
    LinkGridToDataSourceBindSourceDB: TLinkGridToDataSource;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;

    procedure cmbEstadoChange(Sender: TObject);
    procedure cmbPausaChange(Sender: TObject);
    procedure cdsPAsLKUPOnGetText(Sender: TField; var Text: string; const DisplayText: Boolean; const aFieldID: String);

    procedure cdsPAsLKUP_PAGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure cdsPAsLKUP_GRUPOGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure cdsPAsLKUP_ATDGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure cdsPAsLKUP_FILAGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CDSAtdsAfterOpen(DataSet: TDataSet);
    procedure cdsPAsAfterOpen(DataSet: TDataSet);
  private
    { Private declarations }
    procedure ImportarParaComboStatusPAs;
    procedure ImportarParaComboMotivosPausa;
  public
    { Public declarations }
    constructor Create(aOwner: TComponent); Override;
    destructor Destroy; Override;
    function UpdateNomeCliente(Senha: Integer; Nome: string): Boolean;
    procedure AtualizaLookups;
    procedure AtualizaListaDePAs;
    procedure AtualizaListaDeAtendentes;
    procedure UpdatePASituation(PA, StatusPA, ATD: Integer; PWD: string; FilaProveniente, MotivoPausa: Integer; TIM: TDateTime; NomeCliente: string);
  end;

const
  cFiltroTodos = 'Todos';

function FraSituacaoAtendimento(const aIDUnidade: Integer): TFrmSituacaoAtendimento;

implementation

{$R *.fmx}
{ %CLASSGROUP 'FMX.Controls.TControl' }
uses

untCommonDMClient,
untCommonDMConnection, Sics_Common_Parametros, Aspect;


function FraSituacaoAtendimento(const aIDUnidade: Integer): TFrmSituacaoAtendimento;
begin
  Result := TFrmSituacaoAtendimento(FGerenciadorUnidades.FormGerenciado[tcFraSitAtend, aIDUnidade]);
end;

procedure TFrmSituacaoAtendimento.AtualizaListaDeAtendentes;
var
  nowtime : TDateTime;
  LEstavaFiltrandoPAs, LEstavaFiltrandoAtend: Boolean;
  LOldRecnoPA: Integer;
begin
  if not (cdsAtds.Active and cdsPAs.Active) then
    Exit;

  cdsAtds.DisableControls;
  cdsPAs.DisableControls;

  try
    LEstavaFiltrandoPAs := cdsPAs.Filtered;
    LEstavaFiltrandoAtend := cdsAtds.Filtered;
    LOldRecnoPA := cdsPAs.RecNo;
    try
      cdsPAs.Filtered  := False;
      cdsAtds.Filtered := False;
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

        cdsAtds.FieldByName('Id_Atd' ).AsInteger  := DMClient.cdsAtendentes.FieldByName('ID').AsInteger;
        cdsAtds.FieldByName('Horario').AsDateTime := nowtime;
        cdsAtds.FieldByName('Id_Status').AsInteger:= Integer(spDeslogado);


        cdsAtds.Post;

        DMClient.cdsAtendentes.Next;
      end;  { with }
    finally
      cdsPAs.Filtered  := LEstavaFiltrandoPAs;
      cdsAtds.Filtered := LEstavaFiltrandoAtend;
      if (LOldRecnoPA > -1) then
        cdsPAs.RecNo := LOldRecnoPA;
    end;
  finally
    cdsAtds.EnableControls;
    cdsPAs.EnableControls;
  end;
end;

procedure TFrmSituacaoAtendimento.AtualizaListaDePAs;
var
  NowTime                     : TDateTime;
  LOldRecnoPA, LOldRecnoAtds  : Integer;
  LEstavaFiltrandoPAs,
  LEstavaFiltrandoAtend       : Boolean;
begin
  cdsPAs.DisableControls;
  cdsAtds.DisableControls;

  try
    LEstavaFiltrandoPAs := cdsPAs.Filtered;
    LEstavaFiltrandoAtend := cdsAtds.Filtered;
    LOldRecnoAtds := cdsAtds.RecNo;
    try
      cdsPAs.Filtered  := False;
      cdsAtds.Filtered  := False;

      with cdsPAs do
      begin
        First;
        while not eof do
          Delete;
      end;

      NowTime   := now;
      LOldRecnoPA := DMClient.cdsPAs.RecNo;
      try
        DMClient.cdsPAs.First;
        while not DMClient.cdsPAs.eof do
        begin
          cdsPAs.Append;

          cdsPAs.FieldByName('Id_PA').AsInteger    := DMClient.cdsPAs.FieldByName('ID').AsInteger;
          cdsPAs.FieldByName('Horario').AsDateTime := NowTime;

          cdsPAs.Post;

          DMClient.cdsPAs.Next;
        end; { with }
      finally
        if (LOldRecnoPA > -1) then
          DMClient.cdsPAs.RecNo := LOldRecnoPA;
      end;
    finally
      cdsPAs.Filtered := LEstavaFiltrandoPAs;
      cdsAtds.Filtered := LEstavaFiltrandoAtend;
      if (LOldRecnoAtds > -1) then
        cdsAtds.RecNo := LOldRecnoAtds;
    end;
  finally
    cdsPAs.EnableControls;
    cdsAtds.EnableControls;
  end;
end;

procedure TFrmSituacaoAtendimento.AtualizaLookups;
begin
  AtualizaListaDePAs;
  AtualizaListaDeAtendentes;
  ImportarParaComboStatusPAs;
  ImportarParaComboMotivosPausa;
end;

procedure TFrmSituacaoAtendimento.CDSAtdsAfterOpen(DataSet: TDataSet);
begin
  inherited;
  AspUpdateColunasGrid(Self, grdAtds, cdsAtds);
end;

procedure TFrmSituacaoAtendimento.cdsPAsAfterOpen(DataSet: TDataSet);
begin
  inherited;
  AspUpdateColunasGrid(Self, grdPAs, cdsPAs);
end;

procedure TFrmSituacaoAtendimento.cdsPAsLKUPOnGetText(Sender: TField; var Text: string; const DisplayText: Boolean; const aFieldID: String);
begin
  Text := Sender.AsString;
  if ((Sender.AsString = '') and (not Sender.DataSet.FieldByName(aFieldID).IsNull)) then
    Text := '???';
end;

procedure TFrmSituacaoAtendimento.cdsPAsLKUP_ATDGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  inherited;
  cdsPAsLKUPOnGetText(Sender, Text, DisplayText, 'Id_Atd');
end;

procedure TFrmSituacaoAtendimento.cdsPAsLKUP_FILAGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  inherited;
  cdsPAsLKUPOnGetText(Sender, Text, DisplayText, 'Id_Fila');
end;

procedure TFrmSituacaoAtendimento.cdsPAsLKUP_GRUPOGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  inherited;
  cdsPAsLKUPOnGetText(Sender, Text, DisplayText, 'LKUP_Id_Grupo');
end;

procedure TFrmSituacaoAtendimento.cdsPAsLKUP_PAGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  inherited;
  cdsPAsLKUPOnGetText(Sender, Text, DisplayText, 'Id_PA');
end;

procedure TFrmSituacaoAtendimento.cmbEstadoChange(Sender: TObject);
begin
  inherited;
  cmbPausa.ItemIndex := 0;

  if ((cmbEstado.ItemIndex > -1) and (cmbEstado.Selected.Text <> cFiltroTodos)) then
  begin
    cdsPAs.Filtered := False;
    if DMClient.cdsStatusPAs.Locate('Nome', cmbEstado.Selected.Text, []) then
    begin
      cdsPAs.Filter     := 'Id_Status = ' + DMClient.cdsStatusPAs.FieldByName('ID').AsString;
      cdsPAs.Filtered   := True;

      cdsAtds.Filter    := cdsPAs.Filter;
      cdsAtds.Filtered   := cdsPAs.Filtered;
    end;
    cdsPAs.IndexFieldNames := '';
    cdsAtds.IndexFieldNames := cdsPAs.IndexFieldNames;

    cdsPAs.IndexFieldNames := 'Horario';
    cdsAtds.IndexFieldNames := cdsPAs.IndexFieldNames;
  end
  else
  begin
    cdsPAs.Filtered        := False;
    cdsPAs.IndexFieldNames := 'Id_PA';

    cdsAtds.Filtered        := cdsPAs.Filtered;
    cdsAtds.IndexFieldNames := 'Id_Atd';
  end;
end;

procedure TFrmSituacaoAtendimento.cmbPausaChange(Sender: TObject);
begin
  inherited;

  if ((cmbPausa.ItemIndex > -1) and (cmbPausa.Items[cmbPausa.ItemIndex] <> cFiltroTodos)) then
  begin
    cmbEstado.OnChange      := nil;
    cmbEstado.ItemIndex     := cmbEstado.Items.IndexOf('Em pausa');
    cmbEstado.OnChange      := cmbEstadoChange;

    cdsPAs.Filtered         := False;
    if DMClient.cdsMotivosPausa.Locate('Nome', cmbPausa.Items[cmbPausa.ItemIndex], []) then
    begin
      cdsPAs.Filter         := 'Id_MotivoPausa = ' + DMClient.cdsMotivosPausa.FieldByName('ID').AsString;
      cdsPAs.Filtered       := True;

      cdsAtds.Filter        := cdsPAs.Filter;
      cdsAtds.Filtered      := cdsPAs.Filtered;
    end;

    cdsPAs.IndexFieldNames  := 'Horario';
    cdsAtds.IndexFieldNames := cdsPAs.IndexFieldNames;
  end
  else
  begin
    cdsPAs.Filtered         := False;
    cdsPAs.IndexFieldNames  := 'Id_pA';


    cdsAtds.Filtered        := cdsPAs.Filtered;
    cdsAtds.IndexFieldNames := 'Id_Atd';
    cmbEstado.OnChange(cmbEstado);
  end;
end;

constructor TFrmSituacaoAtendimento.Create(aOwner: TComponent);
begin
  inherited;
  FGerenciadorUnidades.Add(tcFraSitAtend, Self);
end;

destructor TFrmSituacaoAtendimento.Destroy;
begin
  FGerenciadorUnidades.Remove(tcFraSitAtend, Self);
  inherited;
end;

procedure TFrmSituacaoAtendimento.FormCreate(Sender: TObject);
begin
  inherited;

  // cdsPAs.CreateDataSet;
  // cdsPAs.LogChanges := False;
end;

procedure TFrmSituacaoAtendimento.FormShow(Sender: TObject);
begin
  inherited;
  ImportarParaComboStatusPAs;
  ImportarParaComboMotivosPausa;
  cmbEstado.ItemIndex := 0;
  cmbPausa.ItemIndex  := 0;

  cdsPAsLKUP_GRUPO.Visible := ParametrosModulo.VisualizarGrupos;
  cdsAtdsLKUP_GRUPO.Visible := ParametrosModulo.VisualizarGrupos;
{$IFDEF CompilarPara_PA_MULTIPA}
  cdsPAsNomeCliente.Visible := ParametrosModulo.MostrarNomeCliente;
  cdsAtdsNomeCliente.Visible := ParametrosModulo.MostrarNomeCliente;
  cdsPAsLKUP_MOTIVOPAUSA.Visible := ParametrosModulo.MostrarPausa;
  cdsAtdsLKUP_MOTIVOPAUSA.Visible := ParametrosModulo.MostrarPausa;
{$ELSE}
  cdsPAsNomeCliente.Visible := True;
  cdsAtdsNomeCliente.Visible := True;
  cdsPAsLKUP_MOTIVOPAUSA.Visible := True;
  cdsAtdsLKUP_MOTIVOPAUSA.Visible := True;
{$ENDIF CompilarPara_PA_MULTIPA}
end;

procedure TFrmSituacaoAtendimento.ImportarParaComboMotivosPausa;
var
  nRecno         : Integer;
  LOldMotivoPausa: String;
begin
  cmbPausa.Items.Clear;
  cmbPausa.Items.Add(cFiltroTodos);
  nRecno          := DMClient.cdsMotivosPausa.RecNo;
  LOldMotivoPausa := '';
  if (cmbPausa.ItemIndex > -1) then
    LOldMotivoPausa := cmbPausa.Items[cmbPausa.ItemIndex];
  try
    DMClient.cdsMotivosPausa.First;
    while not DMClient.cdsMotivosPausa.eof do
    begin
      cmbPausa.Items.Add(DMClient.cdsMotivosPausa.FieldByName('Nome').AsString);
      DMClient.cdsMotivosPausa.Next;
    end;
  finally
    if (nRecno > -1) then
      DMClient.cdsMotivosPausa.RecNo := nRecno;
    if (LOldMotivoPausa <> '') then
      cmbPausa.ItemIndex := cmbPausa.Items.IndexOf(LOldMotivoPausa);
  end;
end;

procedure TFrmSituacaoAtendimento.ImportarParaComboStatusPAs;
var
  LOldRecno : Integer;
  LOldEstado: String;
begin
  LOldRecno  := DMClient.cdsStatusPAs.RecNo;
  LOldEstado := '';
  if (cmbEstado.ItemIndex > -1) then
    LOldEstado := cmbEstado.Items[cmbEstado.ItemIndex];
  try
    cmbEstado.Items.Clear;
    cmbEstado.Items.Add(cFiltroTodos);
    DMClient.cdsStatusPAs.First;
    while not DMClient.cdsStatusPAs.eof do
    begin
      cmbEstado.Items.Add(DMClient.cdsStatusPAs.FieldByName('Nome').AsString);
      DMClient.cdsStatusPAs.Next;
    end;
  finally
    if (LOldRecno > -1) then
      DMClient.cdsStatusPAs.RecNo := LOldRecno;
    if (LOldEstado <> '') then
      cmbEstado.ItemIndex := cmbEstado.Items.IndexOf(LOldEstado);
  end;
end;

function TFrmSituacaoAtendimento.UpdateNomeCliente(Senha: Integer; Nome: string): Boolean;
var
  BM1, BM2             : TBookmark;
  bEstavaFiltrandoPAs, bEstavaFiltrandoAtds: Boolean;
begin
  Result := False;

  cdsPAs.DisableControls;
  cdsAtds.DisableControls;
  try
    bEstavaFiltrandoAtds  := cdsAtds.Filtered;
    bEstavaFiltrandoPAs   := cdsPAs.Filtered;
    BM1                   := cdsAtds.GetBookmark;
    BM2                   := cdsPAs.GetBookmark;
    try
      cdsPAs.Filtered := False;
      cdsAtds.Filtered := False;
      try
        with cdsPAs do
        begin
          if Locate('SENHA', Senha, []) then
          begin
            Edit;
            FieldByName('NomeCliente').AsString := Nome;
            Post;
            Result := True;
          end;
        end;

        with cdsAtds do
        begin
          if Locate('SENHA', Senha, []) then
          begin
            Edit;
            FieldByName('NomeCliente').AsString := Nome;
            Post;
            Result := true;
          end;
        end;
      finally
        cdsPAs.Filtered := bEstavaFiltrandoPAs;
        cdsAtds.Filtered := bEstavaFiltrandoAtds;

        if cdsAtds.BookmarkValid(BM1) then
          cdsAtds.GotoBookmark(BM1);

        if cdsPAs.BookmarkValid(BM2) then
          cdsPAs.GotoBookmark(BM2);
      end;

    finally
      cdsAtds.FreeBookmark(BM1);
      cdsPAs.FreeBookmark(BM2);
    end;
  finally
    cdsPAs.EnableControls;
    cdsAtds.EnableControls;
  end;
end;

procedure TFrmSituacaoAtendimento.UpdatePASituation(PA, StatusPA, ATD: Integer; PWD: string; FilaProveniente, MotivoPausa: Integer; TIM: TDateTime; NomeCliente: string);
var
  BM1, BM2             : TBookmark;
  bEstavaFiltrandoPAs, bEstavaFiltrandoAtds: Boolean;
  AtdLogado, PALogada: Integer;
begin
  AtdLogado := -1;
  PALogada := -1;

  cdsPAs.DisableControls;
  cdsAtds.DisableControls;

  try
    BM2                   := cdsPAs.GetBookmark;
    bEstavaFiltrandoPAs   := cdsPAs.Filtered;
    BM1                   := cdsAtds.GetBookmark;
    bEstavaFiltrandoAtds  := cdsAtds.Filtered;
    try
      cdsPAs.Filtered := False;
      cdsAtds.Filtered := False;
      try
        with cdsAtds do
        begin
          if ((Locate('ID_ATD', Atd, [])) and (not FieldByName('ID_PA').IsNull)) then
            PALogada := FieldByName('ID_PA').AsInteger;
        end;

        with cdsPAs do
        begin
          if ((Locate('ID_PA', PA, [])) and (not FieldByName('ID_ATD').IsNull)) then
            AtdLogado := FieldByName('ID_ATD').AsInteger;
        end;

        with cdsPAs do
        begin
          if PA <> PALogada then
          begin
            if Locate('ID_PA', PALogada, []) then
            begin
              Edit;

              FieldByName('Id_Status').AsInteger:= Integer(spDeslogado);
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
              FieldByName('Id_Status').AsInteger:= Integer(spDeslogado)
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

              FieldByName('Id_Status').AsInteger:= Integer(spDeslogado);
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
              FieldByName('Id_Status').AsInteger:= Integer(spDeslogado)
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
        cdsPAs.Filtered := bEstavaFiltrandoPAs;
        cdsAtds.Filtered := bEstavaFiltrandoAtds;

        if cdsPAs.BookmarkValid(BM2) then
          cdsPAs.GotoBookmark(BM2);

        if cdsAtds.BookmarkValid(BM1) then
          cdsAtds.GotoBookmark(BM1);
      end;
    finally
      cdsAtds.FreeBookmark(BM1);
      cdsPAs.FreeBookmark(BM2);
    end;
  finally
    cdsAtds.EnableControls;
    cdsPAs.EnableControls;
    grdPAs.Repaint;
  end;
end;

end.
