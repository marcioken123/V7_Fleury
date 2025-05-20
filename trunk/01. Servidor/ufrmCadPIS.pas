{
  - O botao OK vai desfazer TUDO? Ou somente a edicao do PI selecionado?
  - Talvez abrir a tela de alarmes filtrando somente a PI selecionada

}
unit ufrmCadPIS;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, DBGrids, DBCtrls,
  FMTBcd, DB, DBClient, ASPDbGrid, System.UITypes, uDataSetHelper;

type
  TfrmSicsCadPIS = class(TForm)
    gbDadosindic: TGroupBox;
    btnIncluir: TBitBtn;
    btnExcluir: TBitBtn;
    btnOK: TBitBtn;
    btnCancelar: TBitBtn;
    dblcbTipodados: TDBLookupComboBox;
    lblTipoindic: TLabel;
    dblcbFuncao: TDBLookupComboBox;
    lblFuncao: TLabel;
    dsTipos: TDataSource;
    dsPis: TDataSource;
    dsFuncao: TDataSource;
    dbgrdIndicadoresSelecionados: TASPDbGrid;
    dtsRelacionado: TDataSource;
    GroupBox1: TGroupBox;
    dbgListindicadores: TDBGrid;
    procedure btnCancelarClick(Sender: TObject);
    procedure btnIncluirClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure dsPisDataChange(Sender: TObject; Field: TField);
    procedure dbgrdIndicadoresSelecionadosDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure dbgrdIndicadoresSelecionadosCheckFieldClick(Field: TField);
    procedure FormDestroy(Sender: TObject);
  private

  public
    class function ExibeForm(var IdUnidade: Integer): Boolean;
    { Public declarations }
  end;

implementation

uses
udmContingencia,

sics_94,udmCadPIS, MyDlls_DR,  ClassLibraryVCL, Sics_91;

{$R *.dfm}

class function TfrmSicsCadPIS.ExibeForm(var IdUnidade: Integer): Boolean;
begin
  IdUnidade := dmSicsMain.CheckPromptUnidade;

	with TFrmSicsCadPis.Create(Application) do
  try
    dmSicsCadPIS := TdmSicsCadPis.Create(nil);
    dmSicsCadPIS.IdUnidade := IdUnidade;
    dsPisDataChange(nil, nil);

  	Result := ShowModal = mrOk;
  finally
  	Free;
  end;
end;

procedure TfrmSicsCadPIS.btnCancelarClick(Sender: TObject);
begin
  with dmSicsCadPis.cdsPis do
  	if State in dsEditModes then
    begin
    	Cancel;
      CancelUpdates;
    end;

  Close;
end;

procedure TfrmSicsCadPIS.btnIncluirClick(Sender: TObject);
begin
	dmSicsCadPis.cdsPis.Append;
  dbgListindicadores.SetFocus;
end;

procedure TfrmSicsCadPIS.btnExcluirClick(Sender: TObject);
begin
	if MessageDlg('Confirma exclusão desta PI?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  	dmSicsCadPis.cdsPis.Delete;
end;

procedure TfrmSicsCadPIS.btnOKClick(Sender: TObject);
begin
  with dmSicsCadPis.cdsPis do
  	if ApplyUpdates(0) = 0 then
    begin
        dmSicsContingencia.CheckReplicarTabelasP2C;
      ModalResult := mrOk;
    end
    else
    	CancelUpdates;
end;

procedure TfrmSicsCadPIS.FormCreate(Sender: TObject);
begin
  inherited;
  LoadPosition(Sender as TForm);
    if dmSicsContingencia.TipoFuncionamento = tfContingente then
    begin
      btnIncluir.Enabled := False;
      btnExcluir.Enabled := False;
      btnOk.Enabled := False;
      dbgListindicadores.ReadOnly := True;
      dbgrdIndicadoresSelecionados.ReadOnly := True;
    end;
end;

procedure TfrmSicsCadPIS.dsPisDataChange(Sender: TObject; Field: TField);
begin
	if not Assigned(dmSicsCadPis) then Exit;

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
end;

procedure TfrmSicsCadPIS.dbgrdIndicadoresSelecionadosDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
	with dbgrdIndicadoresSelecionados do
  begin
  	if (DataSource.DataSet <> nil) and (Column.FieldName = 'NOME') then
    begin
    	if DataSource.DataSet.FieldByName('CALC_SELECIONADO').AsBoolean then
      	Canvas.Font.Style := [fsBold]
      else
        Canvas.Font.Style := [];
			DefaultDrawColumnCell(Rect, DataCol, Column, State);
		end;
  end;
end;

procedure TfrmSicsCadPIS.dbgrdIndicadoresSelecionadosCheckFieldClick(Field: TField);
begin
	with dmSicsCadPis.cdsPisRelacionados do
  begin
  	if not Field.AsBoolean then
    begin
    	Locate('ID_RELACIONADO', dtsRelacionado.DataSet.FieldByName('ID').Value, []);
      Delete;

      dmSicsCadPis.RefreshRelacionados;
    end
    else
    begin
    	Append;
      FieldByName('ID_RELACIONADO').Value := dtsRelacionado.DataSet.FieldByName('ID').Value;
      Post;

      dmSicsCadPis.RefreshRelacionados;
    end;
  end;

end;

procedure TfrmSicsCadPIS.FormDestroy(Sender: TObject);
begin
  FreeAndNil(dmSicsCadPIS);
  SavePosition(Sender as TForm);
  inherited;
end;

end.
