{
  - O botao OK vai desfazer TUDO? Ou somente a edicao do PI selecionado?
  - Talvez abrir a tela de alarmes filtrando somente a PI selecionada

}
unit ufrmCadPIS;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  FMX.Grid, FMX.Controls, FMX.Forms, FMX.Graphics,
  FMX.Dialogs, FMX.StdCtrls,FMX.ExtCtrls, FMX.Types, FMX.Layouts, FMX.ListView.Types,
  FMX.ListView, FMX.ListBox,
  Fmx.Bind.DBEngExt, Fmx.Bind.Grid,
  Fmx.Bind.Editors, FMX.Objects, FMX.Edit, FMX.TabControl,

  System.UIConsts,
  MyAspFuncoesUteis, System.UITypes, System.Types, System.SysUtils, System.Classes, System.Variants, Data.DB,
  Datasnap.DBClient, System.Rtti, Data.Bind.EngExt, Data.Bind.Components,
  udmCadPIS,udmCadAlarmes, udmCadBase, ufrmCadBase, Data.Bind.Grid, Data.Bind.DBScope, System.Bindings.Outputs,
  FMX.Controls.Presentation, System.ImageList, FMX.ImgList, FMX.Effects,
  FMX.Grid.Style, FMX.ScrollBox, uDataSetHelper;

type
  TfrmSicsCadPIS = class(TfrmSicsCadBase)
    dsTipos: TDataSource;
    dsPis: TDataSource;
    dsFuncao: TDataSource;
    dtsRelacionado: TDataSource;
    btnExcluir: TButton;
    btnIncluir: TButton;
    GroupBox1: TGroupBox;
    dbgListindicadores: TGrid;
    LinkGridToDataSource1: TLinkGridToDataSource;
    bndPis: TBindSourceDB;
    bndRelacionado: TBindSourceDB;
    lnkflcntrltfld1: TLinkFillControlToField;
    bndTipo: TBindSourceDB;
    bndFuncao: TBindSourceDB;
    lnkflcntrltfld2: TLinkFillControlToField;
    LinkFillControlToField1: TLinkFillControlToField;
    LinkFillControlToField2: TLinkFillControlToField;
    rectTipo: TRectangle;
    dblcbFuncao: TComboBox;
    dblcbTipodados: TComboBox;
    lblFuncao: TLabel;
    lblTipoindic: TLabel;
    lstId: TListBox;
    lstIndicadoresSelecionados: TListBox;
    LinkFillControlToField3: TLinkFillControlToField;
    LinkFillControlToField4: TLinkFillControlToField;
    LinkFillControlToField5: TLinkFillControlToField;
    LinkFillControlToField6: TLinkFillControlToField;
    procedure btnCancelarClick(Sender: TObject);
    procedure btnIncluirClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure dsPisDataChange(Sender: TObject; Field: TField);
    procedure dsTiposDataChange(Sender: TObject; Field: TField);
    procedure dtsRelacionadoDataChange(Sender: TObject; Field: TField);
    procedure dsFuncaoDataChange(Sender: TObject; Field: TField);
    procedure dblcbTipodadosChange(Sender: TObject);
    procedure lstIndicadoresSelecionadosChangeCheck(Sender: TObject);
    procedure dblcbTipodadosClick(Sender: TObject);
    procedure lstIndicadoresSelecionadosItemClick(
      const Sender: TCustomListBox; const Item: TListBoxItem);
  private

  protected
    function GetClassDM: TClassdmSicsCadBase; Override;
  public
    procedure Inicializar; Override;
    function dmSicsCadPis: TdmSicsCadPis;
    procedure HabilitaBotoes; Override;
  end;

function FrmSicsCadPIS(const aIDUnidade: integer; const aAllowNewInstance: Boolean = False; const aOwner: TComponent = nil): TFrmSicsCadPIS;


implementation

uses
  untMainForm;

{$R *.fmx}

function FrmSicsCadPIS(const aIDUnidade: integer; const aAllowNewInstance: Boolean = False; const aOwner: TComponent = nil): TFrmSicsCadPIS;
begin
  Result := TfrmSicsCadPIS(TfrmSicsCadPIS.GetInstancia(aIDUnidade, aAllowNewInstance, aOwner));
end;

procedure TfrmSicsCadPIS.btnCancelarClick(Sender: TObject);
begin
  with dmSicsCadPis.cdsPis do
  begin
  	if State in dsEditModes then
    begin
    	Cancel;
      CancelUpdates;
    end;
  end;
  Visible := False;
end;

procedure TfrmSicsCadPIS.btnIncluirClick(Sender: TObject);
begin
  if dmSicsCadPis.cdsPis.State in dsEditModes then
    dmSicsCadPis.cdsPis.Post;

	dmSicsCadPis.cdsPis.Append;
  dbgListindicadores.SetFocus;
  dblcbFuncao.ItemIndex := -1;
end;

procedure TfrmSicsCadPIS.btnExcluirClick(Sender: TObject);
var
  LOldRecno: Integer;
begin
  with dmSicsCadPis do
  begin
    cdsMonitoramentos.Open;
    if(cdsMonitoramentos.Locate('ID_PI',cdsPis.FieldByName('ID_PI').AsString,[]))then
    begin
      ErrorMessage('Este PI não pode ser excluído pois está relacionado a um alarme.');
      Exit;
    end;
    cdsMonitoramentos.Close;
  end;

  LOldRecno := dmSicsCadPis.cdsPis.RecNo;
  ConfirmationMessage('Confirma exclusão desta PI?',
    procedure (const aOK: Boolean)
    begin
      if aOK then
      begin
        if (LOldRecno = dmSicsCadPis.cdsPis.RecNo) then
        begin
          dmSicsCadPIS.cdsFilas.First;
          while not dmSicsCadPIS.cdsFilas.Eof do
          begin
            dmSicsCadPIS.cdsFilas.Delete;
          end;
          dmSicsCadPis.cdsPis.Delete;
        end
        else
          ErrorMessage(Format('Contexto foi alterado. Registro de %d para %d.', [LOldRecno, dmSicsCadPis.cdsPis.RecNo]));
      end;
    end);
end;

procedure TfrmSicsCadPIS.btnOKClick(Sender: TObject);

begin

   if(dblcbFuncao.ItemIndex = -1)then
   begin
     ShowMessage('Por favor escolha uma Função!');
     dblcbFuncao.SetFocus;
     Exit;
   end;
   clicouNoBotaoOK := True;
   with dmSicsCadPis do
   begin
     cdsPis.First;

     while not (cdsPis.Eof) do
     begin
        cdsPisRelacionados.First;
        cdsPis.Edit;
        while not cdsPisRelacionados.Eof do
        begin
            if(cdsPis.FieldByName('ID_PI').AsString = cdsPisRelacionados.FieldByName('ID_PI').AsString)then
            begin
               if (cdsPis.FieldByName('IDSRELACIONADOS').IsNull)then
               begin
                 cdsPis.FieldByName('IDSRELACIONADOS').AsString := cdsPisRelacionados.FieldByName('ID_RELACIONADO').AsString;
               end
               else
               begin
                 cdsPis.FieldByName('IDSRELACIONADOS').AsString := cdsPis.FieldByName('IDSRELACIONADOS').AsString + '-'
                                                                   +cdsPisRelacionados.FieldByName('ID_RELACIONADO').AsString;
               end;

            end;
           cdsPisRelacionados.Next;
        end;
        cdsPis.Post;
        cdsPis.Next;
     end;
   end;


  if dmSicsCadPis.cdsPis.ApplyUpdates(0) = 0 then
    Visible := False
  else
    dmSicsCadPis.cdsPis.CancelUpdates;

  clicouNoBotaoOK := False;
end;

procedure TfrmSicsCadPIS.dsFuncaoDataChange(Sender: TObject; Field: TField);
begin
  inherited;

  HabilitaBotoes;
end;

procedure TfrmSicsCadPIS.dsPisDataChange(Sender: TObject; Field: TField);
var
  I : Integer;
begin
	if (dmSicsCadPis = nil) or (clicouNoBotaoOK) or (changeCheck) then Exit;

  if (Field = nil) or (UpperCase(Field.FieldName) = 'ID_PITIPO') then
  begin
		dtsRelacionado.DataSet := dmSicsCadPis.GetDataRelacionado;
  	dmSicsCadPis.RefreshRelacionados;

    //ajusta o campo Função e desabilita o combo caso seja algum PI que faz sempre a média
    if (dmSicsCadPIS.cdsPis.FieldByName('ID_PITIPO').AsInteger in
      [Integer(tpiTempoEstimadoDeEspera), Integer(tpiTempoMedioDeAtendimento)]) then
    begin
      if (dmSicsCadPIS.cdsPis.FieldByName('ID_PIFUNCAO').AsInteger <> Integer(fpiMedia)) then
      begin
        if not (dmSicsCadPIS.cdsPis.State in dsEditModes) then
          dmSicsCadPIS.cdsPis.Edit;
        dmSicsCadPIS.cdsPis.FieldByName('ID_PIFUNCAO').AsInteger := Integer(fpiMedia);
      end;
      dblcbFuncao.Enabled := False;
    end
    else
      dblcbFuncao.Enabled := True;
  end;

  HabilitaBotoes;

  with dmSicsCadPis.cdsPis do
  begin
    for I := 0 to lstIndicadoresSelecionados.Count -1 do
    begin
      if dmSicsCadPis.cdsPisRelacionados.Locate('ID_PI;ID_RELACIONADO',
              VarArrayOf( [
                            FieldByName('ID_PI').AsInteger,
                            StrToInt(lstId.ItemByIndex(I).Text)
                          ]), []) then
      begin
        if not (clicouTipoPis and mudouTipoPis)then
        begin
          lstIndicadoresSelecionados.ItemByIndex(I).IsChecked := True;
        end
        else
        begin
          lstIndicadoresSelecionados.ItemByIndex(I).IsChecked := False;
          dmSicsCadPis.cdsPisRelacionados.Delete;
        end;
      end;
    end;
  end;
  mudouTipoPis := False;
  clicouTipoPis := False;
  changeCheck := false;
end;

procedure TfrmSicsCadPIS.dsTiposDataChange(Sender: TObject; Field: TField);

begin
  inherited;
  HabilitaBotoes;
end;

procedure TfrmSicsCadPIS.dtsRelacionadoDataChange(Sender: TObject;
  Field: TField);
begin
  inherited;
  HabilitaBotoes;
  
end;

procedure TfrmSicsCadPIS.dblcbTipodadosChange(Sender: TObject);
//var
//  I : Integer;
begin
  inherited;
  mudouTipoPis := true;
  Application.ProcessMessages;
end;

procedure TfrmSicsCadPIS.dblcbTipodadosClick(Sender: TObject);
begin
  inherited;
  clicouTipoPis := True;
end;

function TfrmSicsCadPIS.dmSicsCadPis: TdmSicsCadPis;
begin
  Result := TdmSicsCadPis(dmSicsCadBase);
end;

function TfrmSicsCadPIS.GetClassDM: TClassdmSicsCadBase;
begin
  Result := TdmSicsCadPis;
end;

procedure TfrmSicsCadPIS.HabilitaBotoes;
var
  habilitarBotao:Boolean;
begin
  habilitarBotao := ((dblcbTipodados.ItemIndex <> -1) and (dblcbFuncao.ItemIndex <> -1) and (dmSicsCadPis.cdsPisRelacionados.RecordCount > 0));
  btnOK.Enabled := dmSicsCadPis.PossuiModificacoes and habilitarBotao;
  btnIncluir.Enabled := Assigned(dsPis.DataSet) and dsPis.DataSet.Active;
  btnExcluir.Enabled := btnIncluir.Enabled and ((not dsPis.DataSet.IsEmpty) or (dsPis.DataSet.State in[dsInsert, dsEdit]));
end;

procedure TfrmSicsCadPIS.Inicializar;
var
  LOnChange: TNotifyEvent;
begin
  inherited;

  LOnChange := dblcbTipodados.onChange;
  try
    dblcbTipodados.OnChange := nil;

    dsTipos.DataSet := dmSicsCadPIS.cdsTipos;
    dsPis.DataSet := dmSicsCadPIS.cdsPis;
    dsFuncao.DataSet := dmSicsCadPIS.cdsFuncao;
    dtsRelacionado.DataSet := dmSicsCadPIS.cdsFilas;

  finally
    dblcbTipodados.OnChange := LOnChange;
  end;

  dsPisDataChange(nil, nil);
  AspUpdateColunasGrid(Self, bndList);
end;

procedure TfrmSicsCadPIS.lstIndicadoresSelecionadosChangeCheck(
  Sender: TObject);
    var
    id :string;
    item : TListBoxItem;
    cdsPis : TDataSet;
begin
  inherited;
   if(clicouNoBotaoOK) then Exit;

   item := (Sender as TListBoxItem);
   id := lstId.ItemByIndex(item.Index).Text;
   cdsPis := dmSicsCadPis.cdsPis;
   changeCheck := True;
   with dmSicsCadPis.cdsPisRelacionados do
   begin
     if not item.IsChecked then
     begin
       if Locate('ID_PI;ID_RELACIONADO',
               VarArrayOf( [
                            cdsPis.FieldByName('ID_PI').Value,
                            StrToInt(id)
                          ]), []) then
         Delete;

     end
     else
     begin
       Append;
       FieldByName('ID_PI').Value := cdsPis.FieldByName('ID_PI').Value;
       FieldByName('ID_RELACIONADO').Value := StrToInt(id);
       try
         Post;
       except
         on E: Exception do
         begin
           ShowMessage(E.Message);
         end;
       end;
     end;
   end;
   changeCheck := false;
   HabilitaBotoes;
end;

procedure TfrmSicsCadPIS.lstIndicadoresSelecionadosItemClick(
  const Sender: TCustomListBox; const Item: TListBoxItem);
begin
  inherited;
  Item.IsChecked := not item.IsChecked;
end;

end.
