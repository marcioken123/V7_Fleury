unit ufrmCadAlarmes;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  FMX.Grid, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.ExtCtrls, FMX.Types, FMX.Layouts, FMX.ListView.Types, FMX.ListView,
  FMX.ListBox,FMX.Memo, System.UIConsts, Fmx.Bind.DBEngExt, Fmx.Bind.Grid,
  Fmx.Bind.Editors, FMX.Objects, FMX.Edit, FMX.TabControl, untMainForm,
  System.UITypes, System.Types, System.SysUtils, System.Classes,
  System.Variants, Data.DB, Datasnap.DBClient, System.Rtti, Data.Bind.EngExt,
  Data.Bind.Components, MyAspFuncoesUteis, udmCadAlarmes, udmCadBase,
  ufrmCadBase, Data.Bind.Grid, Data.Bind.DBScope, System.Bindings.Outputs,
  FMX.ScrollBox, FMX.Controls.Presentation, System.ImageList, FMX.ImgList,
  FMX.Effects, FMX.Grid.Style, uDataSetHelper;

type
  TfrmSicsCadAlarmes = class(TfrmSicsCadBase)
    dtsMonitoramentes: TDataSource;
    dtsAlarmes: TDataSource;
    dtsAcoesAlarmes: TDataSource;
    dtsRelacionado: TDataSource;
    lblMensagem: TLabel;
    lblLimiar: TLabel;
    lblAcao: TLabel;
    dbGrdAlarmes: TGrid;
    mmoMensagem: TMemo;
    edtLimiar: TEdit;
    chkSuperior: TCheckBox;
    cbbAcao: TComboBox;
    dbgrdMonitoramento: TGrid;
    btnExcluir: TButton;
    btnIncluir: TButton;
    bndMonitoramentes: TBindSourceDB;
    bndAlarmes: TBindSourceDB;
    bndAcoesAlarmes: TBindSourceDB;
    LinkControlToFieldMensagem: TLinkControlToField;
    LinkControlToFieldSuperior: TLinkControlToField;
    LinkGridAlarmes: TLinkGridToDataSource;
    LinkGridMonitoramento: TLinkGridToDataSource;
    bndRelacionado: TBindSourceDB;
    LinkControlToFieldLimiar: TLinkControlToField;
    cbxPI: TComboBox;
    cbxHorario: TComboBox;
    dsHorarios: TDataSource;
    bndHorarios: TBindSourceDB;
    dsPI: TDataSource;
    bndPI: TBindSourceDB;
    lblIndicador: TLabel;
    lblHorarios: TLabel;
    lblIdPI: TLabel;
    LinkFillControlToPropertyText: TLinkFillControlToProperty;
    lblIdHorarios: TLabel;
    LinkFillControlToPropertyText2: TLinkFillControlToProperty;
    cbxNivel: TComboBox;
    lblNivel: TLabel;
    lblIdNivel: TLabel;
    dsNivel: TDataSource;
    bndNivel: TBindSourceDB;
    LinkFillControlToPropertyText3: TLinkFillControlToProperty;
    LinkFillControlToField1: TLinkFillControlToField;
    btnIncluirAlarme: TButton;
    btnExcluirAlarme: TButton;
    groupDetalhesDoAlarme: TGroupBox;
    edtIdPI: TEdit;
    LinkControlToField1: TLinkControlToField;
    lstAcoes: TListBox;
    LinkFillControlToField2: TLinkFillControlToField;
    lstId: TListBox;
    LinkFillControlToField3: TLinkFillControlToField;
    procedure btnIncluirClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnIncluirAlarmeClick(Sender: TObject);
    procedure dtsAlarmesDataChange(Sender: TObject; Field: TField);

    procedure btnExcluirClick(Sender: TObject);
    procedure dtsMonitoramentesDataChange(Sender: TObject; Field: TField);
    procedure btnExcluirAlarmeClick(Sender: TObject);
    procedure dtsAcoesAlarmesDataChange(Sender: TObject; Field: TField);
    procedure dtsRelacionadoDataChange(Sender: TObject; Field: TField);
    procedure cbbAcaoChange(Sender: TObject);
    procedure dbGrdAlarmesDrawColumnCell(Sender: TObject; const Canvas: TCanvas; const Column: TColumn; const Bounds: TRectF; const Row: Integer;
      const Value: TValue; const State: TGridDrawStates);
    procedure dbGrdAlarmesDrawColumnHeader(Sender: TObject;
      const Canvas: TCanvas; const Column: TColumn; const Bounds: TRectF);
    procedure edtLimiarExit(Sender: TObject);
    procedure lstAcoesChangeCheck(Sender: TObject);
    procedure cbbAcaoClick(Sender: TObject);
    procedure lstAcoesItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
  private
    FFormatoHorario : Boolean;
    { Private declarations }
  protected
    function GetClassDM: TClassdmSicsCadBase; Override;
    procedure HabilitaBotoes; Override;
    //procedure FormataCampoLimiar;
  public
    procedure Inicializar; Override;
    procedure AtualizarPIS; override;
    function dmSicsCadAlarmes: TdmSicsCadAlarmes;
  end;

function FrmSicsCadAlarmes(const aIDUnidade: integer; const aAllowNewInstance: Boolean = False; const aOwner: TComponent = nil): TFrmSicsCadAlarmes;

implementation

{$R *.fmx}

uses
  Sics_Common_Parametros;

function FrmSicsCadAlarmes(const aIDUnidade: integer; const aAllowNewInstance: Boolean = False; const aOwner: TComponent = nil): TFrmSicsCadAlarmes;
begin
  Result := TfrmSicsCadAlarmes(TfrmSicsCadAlarmes.GetInstancia(aIDUnidade, aAllowNewInstance, aOwner));
end;

procedure TfrmSicsCadAlarmes.btnIncluirClick(Sender: TObject);
begin
  if((cbxPI.ItemIndex = -1) or (cbxHorario.ItemIndex = -1))then
  begin
    MessageDlg('Os campos Indicador e Horário não podem ser vazios', TMsgDlgType.mtWarning, [TMsgDlgBtn.mbOK], 0);
    Exit;
  end;

  with dmSicsCadAlarmes.cdsMonitoramentos do
  begin
    if(Locate('ID_PI;ID_PIHORARIO',VarArrayOf([lblIdPI.Text,lblIdHorarios.Text]),[]))then
    begin
      MessageDlg('Essa combinação de indicador e horário já foram incluidos', TMsgDlgType.mtWarning, [TMsgDlgBtn.mbOK], 0);
      Exit;
    end;

    Append;
    FieldByName('ID_PIHORARIO').AsString := lblIdHorarios.Text;
    FieldByName('ID_PI').AsString := lblIdPI.Text;
    Post;
  end;

end;

procedure TfrmSicsCadAlarmes.btnOKClick(Sender: TObject);
begin
  if dmSicsCadAlarmes.cdsAlarmes.State in[dsInsert, dsEdit] then
    dmSicsCadAlarmes.cdsAlarmes.Post;

  if (dtsRelacionado.DataSet <> nil) and (dtsRelacionado.DataSet.State in [dsInsert, dsEdit]) then
  	dtsRelacionado.DataSet.Post;

  if dmSicsCadAlarmes.cdsMonitoramentos.Applyupdates(0) = 0 then
  begin
    dmSicsCadAlarmes.cdsAlarmes.ApplyUpdates(0);

    if (dtsRelacionado.DataSet <> nil) then
      TClientDataset(dtsRelacionado.DataSet).Applyupdates(0);

    Visible := False;
  end
  else
    dmSicsCadAlarmes.cdsMonitoramentos.CancelUpdates;
end;

procedure TfrmSicsCadAlarmes.cbbAcaoChange(Sender: TObject);
//var
//  selectedValue : Integer;
begin
  inherited;

  mudouTipoPis := true;
end;

procedure TfrmSicsCadAlarmes.cbbAcaoClick(Sender: TObject);
begin
  inherited;
  clicouTipoPis := True;
end;

procedure TfrmSicsCadAlarmes.btnCancelarClick(Sender: TObject);
begin
  with dmSicsCadAlarmes.cdsMonitoramentos do
  	if State in dsEditModes then
    begin
    	Cancel;
      CancelUpdates;
    end;

    with dmSicsCadAlarmes.cdsAlarmes do
  	if State in dsEditModes then
    begin
    	Cancel;
      CancelUpdates;
    end;
    if(Assigned(dtsRelacionado.DataSet))then
    begin
      with TClientDataSet(dtsRelacionado.DataSet) do
      if State in dsEditModes then
      begin
        Cancel;
        CancelUpdates;
      end;
    end;

	Visible := False;
end;

procedure TfrmSicsCadAlarmes.btnIncluirAlarmeClick(Sender: TObject);
begin
  if(dmSicsCadAlarmes.cdsMonitoramentos.RecordCount <= 0)then
  begin
    MessageDlg('Por favor insira um monitoramento!', TMsgDlgType.mtWarning, [TMsgDlgBtn.mbOK], 0);
    Exit;
  end;

   if((cbxNivel.ItemIndex = -1))then
  begin
    MessageDlg('O campo Nivel não pode ser vazio', TMsgDlgType.mtWarning, [TMsgDlgBtn.mbOK], 0);
    Exit;
  end;

  with dmSicsCadAlarmes.cdsAlarmes do
  begin
    if(Locate('ID_PINIVEL',lblIdNivel.Text,[]))then
    begin

      MessageDlg('Esse nível já foi incluido', TMsgDlgType.mtWarning, [TMsgDlgBtn.mbOK], 0);
      Exit;
    end;

    Append;
    FieldByName('ID_PINIVEL').AsString := lblIdNivel.Text;
    Post;
  end;
end;

procedure TfrmSicsCadAlarmes.dtsAcoesAlarmesDataChange(Sender: TObject;
  Field: TField);

begin
  inherited;

  HabilitaBotoes;

end;

procedure TfrmSicsCadAlarmes.dtsAlarmesDataChange(Sender: TObject;
  Field: TField);
  var
  I : Integer;
begin

  if (dmSicsCadAlarmes = nil) or  (changeCheck) then Exit;

  if (Field = nil) or (UpperCase(Field.FieldName) = 'ID_PIACAODEALARME') then
  begin
		dtsRelacionado.DataSet := dmSicsCadAlarmes.GetDataRelacionado;
  	dmSicsCadAlarmes.RefreshRelacionados;
  end;
  HabilitaBotoes;

  with dmSicsCadAlarmes.cdsAlarmes do
  begin
     for I := 0 to lstAcoes.Count -1 do
     begin
       if dmSicsCadAlarmes.cdsAlarmesRelacionados.Locate('ID_PIALARME;ID_RELACIONADO',
               VarArrayOf( [
                            FieldByName('ID_PIALARME').AsInteger,
                            StrToInt(lstId.ItemByIndex(I).Text)
                          ]), []) then
       begin
        if not (clicouTipoPis and mudouTipoPis)then
        begin
         lstAcoes.ItemByIndex(I).IsChecked := True;
        end
        else
        begin
         lstAcoes.ItemByIndex(I).IsChecked := False;
         dmSicsCadAlarmes.cdsAlarmesRelacionados.Delete;
        end;
       end;

     end;
  end;
  mudouTipoPis := False;
  clicouTipoPis := False;
  changeCheck := false;
end;

procedure TfrmSicsCadAlarmes.dbGrdAlarmesDrawColumnCell(Sender: TObject; const Canvas: TCanvas; const Column: TColumn;
  const Bounds: TRectF; const Row: Integer; const Value: TValue; const State: TGridDrawStates);
var
  RowColor : TBrush;
begin
  inherited;
  with Sender As TGrid Do
  begin
    if (Column.Index = 0) and (not (Value.AsString.Trim.IsEmpty{dtsAlarmes.DataSet.FieldByName('LKP_COR').IsNull})) Then
    begin
      RowColor := TBrush.Create(TBrushKind.Solid,TAlphaColors.Alpha);

      try
        RowColor.Color    := TAlphaColor(RGBtoBGR(Value.AsString.ToInteger{dtsAlarmes.DataSet.FieldByName('LKP_COR').AsInteger}) or $FF000000);
        Canvas.FillRect(Bounds, 0, 0, [], 1, RowColor);

        Canvas.FillText(Bounds, EmptyStr, False, 1, [], TTextAlign.Leading, TTextAlign.Center);

        LinkGridAlarmes.Columns[0].Width := 40;
      finally
        RowColor.Free;
      end;
    end;

    //Column.DefaultDrawCell(Canvas, Bounds, Row, Value, State);
  end;
end;

procedure TfrmSicsCadAlarmes.dbGrdAlarmesDrawColumnHeader(Sender: TObject;
  const Canvas: TCanvas; const Column: TColumn; const Bounds: TRectF);
begin
  inherited;
  LinkGridAlarmes.Columns[0].Width := 40;
end;

function TfrmSicsCadAlarmes.GetClassDM: TClassdmSicsCadBase;
begin
  Result := TdmSicsCadAlarmes;
end;

procedure TfrmSicsCadAlarmes.HabilitaBotoes;
var
  dm : TdmSicsCadAlarmes;
begin

 dm := dmSicsCadAlarmes;
  btnOK.Enabled := Assigned(dm) and dm.PossuiModificacoes;

  btnIncluir.Enabled := Assigned(dtsMonitoramentes.DataSet) and dtsMonitoramentes.DataSet.Active;
  btnExcluir.Enabled := true;
end;

procedure TfrmSicsCadAlarmes.Inicializar;
begin

  inherited;
  dtsAlarmesDataChange(nil, nil);
  dmSicsCadAlarmes.cdsAcoesAlarmes.Open;
  dmSicsCadAlarmes.cdsAlarmes.Open;
  dmSicsCadAlarmes.cdsMonitoramentos.Open;
  dtsAcoesAlarmes.DataSet := dmSicsCadAlarmes.cdsAcoesAlarmes;
  dtsAlarmes.DataSet := dmSicsCadAlarmes.cdsAlarmes;
  dtsMonitoramentes.DataSet := dmSicsCadAlarmes.cdsMonitoramentos;
end;

procedure TfrmSicsCadAlarmes.lstAcoesChangeCheck(Sender: TObject);
    var
    id :string;
    item : TListBoxItem;
    cdsAlarmes : TDataSet;
begin
  inherited;


   if dtsRelacionado.DataSet = nil then Exit;

   item := (Sender as TListBoxItem);
   id := lstId.ItemByIndex(item.Index).Text;
   cdsAlarmes := dmSicsCadAlarmes.cdsAlarmes;
   changeCheck := True;
   with dmSicsCadAlarmes.cdsAlarmesRelacionados do
   begin
     if not item.IsChecked then
     begin
       if Locate('ID_PIALARME;ID_RELACIONADO',
               VarArrayOf( [
                            cdsAlarmes.FieldByName('ID_PIALARME').Value,
                            StrToInt(id)
                          ]), []) then
         Delete;

     end
     else
     begin
       Append;
       FieldByName('ID_PIALARME').Value := cdsAlarmes.FieldByName('ID_PIALARME').Value;
       FieldByName('ID_RELACIONADO').Value := StrToInt(id);
       Post;
     end;
   end;
   changeCheck := false;
   HabilitaBotoes;
end;

procedure TfrmSicsCadAlarmes.lstAcoesItemClick(
  const Sender: TCustomListBox; const Item: TListBoxItem);
begin
  inherited;
  Item.IsChecked := not item.IsChecked;
end;

function TfrmSicsCadAlarmes.dmSicsCadAlarmes: TdmSicsCadAlarmes;
begin
  Result := TdmSicsCadAlarmes(dmSicsCadBase);
end;

procedure TfrmSicsCadAlarmes.btnExcluirClick(Sender: TObject);
var
  LOldRecno: Integer;
begin
  if(dmSicsCadAlarmes.cdsMonitoramentos.RecordCount <= 0)then
  begin
    MessageDlg('Não há registros para serem excluidos', TMsgDlgType.mtWarning, [TMsgDlgBtn.mbOK], 0);
    Exit;
  end;
  LOldRecno := dmSicsCadAlarmes.cdsMonitoramentos.RecNo;
	ConfirmationMessage('Confirma exclusão deste Monitoramento?',
    procedure (const aOK: Boolean)
    begin
      if aOK then
      begin
        if (LOldRecno = dmSicsCadAlarmes.cdsMonitoramentos.RecNo) then
          dmSicsCadAlarmes.cdsMonitoramentos.Delete
        else
          ErrorMessage(Format('Contexto foi alterado. Registro de %d para %d.', [LOldRecno, dmSicsCadAlarmes.cdsMonitoramentos.RecNo]));
      end;
    end);
end;

procedure TfrmSicsCadAlarmes.dtsMonitoramentesDataChange(Sender: TObject; Field: TField);
begin
	if (dmSicsCadAlarmes = nil) then Exit;

  if (Field = nil) or (UpperCase(Field.FieldName) = 'ID_PI') then
  begin
    FFormatoHorario := dmSicsCadAlarmes.IsFormatoHorario;
    if FFormatoHorario then
      dmSicsCadAlarmes.cdsAlarmes.FieldByName('LIMIAR').EditMask := '!90:00;1;_'
    else
      dmSicsCadAlarmes.cdsAlarmes.FieldByName('LIMIAR').EditMask := '';

//    FormataCampoLimiar;
  end;
  HabilitaBotoes;
end;

procedure TfrmSicsCadAlarmes.dtsRelacionadoDataChange(Sender: TObject;
  Field: TField);
begin
  inherited;
  HabilitaBotoes;
end;

procedure TfrmSicsCadAlarmes.edtLimiarExit(Sender: TObject);
var
  valor :string;
begin
  inherited;
  if FFormatoHorario {(formatoHorario = 'T')} then
  begin
    valor := edtLimiar.Text;

    if(valor <> '')then
    begin
      if(Length(valor) = 1 )then
        edtLimiar.Text := '00:0'+valor
      else if(Length(valor) = 2 )then
        edtLimiar.Text := '00:'+valor
      else if(Length(valor) = 3 )then
        edtLimiar.Text := '0'+Copy(valor,1,1) + ':' + Copy(valor,2)
      else if (Length(valor) = 4) then
        edtLimiar.Text := Copy(valor,1,2) + ':' + Copy(valor,3);
    end;
  end;

end;

//procedure TfrmSicsCadAlarmes.FormataCampoLimiar;
//var
//  idPI : string;
//begin
//  idPI := edtIdPI.Text;
//
//  if(idPI = '')then
//    Exit;
//
//  with TClientDataSet(dsPI.DataSet) do
//  begin
//    if(Locate('ID_PI',idPI,[]))then
//    begin
//      formatoHorario := FieldByName('FORMATOHORARIO').AsString;
//    end;
//  end;
//end;

procedure TfrmSicsCadAlarmes.AtualizarPIS;
begin
  inherited;
  dmSicsCadAlarmes.cdsPIS.Close;
  dmSicsCadAlarmes.cdsPIS.Open;
end;

procedure TfrmSicsCadAlarmes.btnExcluirAlarmeClick(Sender: TObject);
begin
  if(dmSicsCadAlarmes.cdsMonitoramentos.RecordCount <= 0)then
  begin
    MessageDlg('Não há registros para serem excluidos!', TMsgDlgType.mtWarning, [TMsgDlgBtn.mbOK], 0);
    Exit;
  end;

  if (dmSicsCadAlarmes.cdsAlarmes.State = dsInsert) then
    dmSicsCadAlarmes.cdsAlarmes.Cancel
  else
	  dmSicsCadAlarmes.cdsAlarmes.Delete;
end;

end.

