unit ufrmCadAlarmes;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, Grids, DBGrids, StdCtrls, Buttons, DBCtrls, ExtCtrls,
  ASPDbGrid, System.UITypes, uDataSetHelper, Vcl.Mask;

type
  TfrmSicsCadAlarmes = class(TForm)
    dtsMonitoramentes: TDataSource;
    GroupBox1: TGroupBox;
    dbgrdMonitoramento: TDBGrid;
    btnIncluir: TBitBtn;
    btnExcluir: TBitBtn;
    GroupBox2: TGroupBox;
    dbGrdAlarmes: TDBGrid;
    Label1: TLabel;
    dtsAlarmes: TDataSource;
    DBMemo1: TDBMemo;
    Label2: TLabel;
    DBEdit1: TDBEdit;
    Label3: TLabel;
    DBCheckBox1: TDBCheckBox;
    DBLookupComboBox1: TDBLookupComboBox;
    Bevel1: TBevel;
    Label4: TLabel;
    dtsAcao: TDataSource;
    btnOK: TBitBtn;
    btnCancelar: TBitBtn;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    dtsRelacionado: TDataSource;
    dbGridAcoes: TASPDbGrid;
    procedure FormCreate(Sender: TObject);
    procedure btnIncluirClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure dtsAlarmesDataChange(Sender: TObject; Field: TField);
    procedure dbGrdAlarmesDrawColumnCell(Sender: TObject;
      const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure FormDestroy(Sender: TObject);
    procedure dbGridAcoesCheckFieldClick(Field: TField);
    procedure dbGridAcoesDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure btnExcluirClick(Sender: TObject);
    procedure dtsMonitoramentesDataChange(Sender: TObject; Field: TField);
    procedure SpeedButton2Click(Sender: TObject);
  private
    { Private declarations }
  public
		class function ExibeForm(var IdUnidade: Integer): Boolean;
  end;

implementation

uses udmCadAlarmes

{$IFDEF CompilarPara_TGS}

{$ELSE}
  , udmContingencia
{$ENDIF}
  , sics_94;

{$R *.dfm}

class function TfrmSicsCadAlarmes.ExibeForm(var IdUnidade: Integer): Boolean;
begin
  IdUnidade := dmSicsMain.CheckPromptUnidade;

	with TFrmSicsCadAlarmes.Create(Application) do
  try
	  dmSicsCadAlarmes := TdmSicsCadAlarmes.Create(nil);
    dmSicsCadAlarmes.Inicializar(IdUnidade);
    dtsAlarmesDataChange(nil, nil);

  	Result := ShowModal = mrOk;
  finally
  	Free;
  end;
end;

procedure TfrmSicsCadAlarmes.FormCreate(Sender: TObject);
begin
  {$IFDEF CompilarPara_TGS}

  {$ELSE}
    if dmSicsContingencia.TipoFuncionamento = tfContingente then
    begin
      btnIncluir.Enabled := False;
      btnExcluir.Enabled := False;
      btnOk.Enabled := False;
      dbgrdMonitoramento.ReadOnly := True;
      dbGrdAlarmes.ReaDOnly := True;
      dbGridAcoes.ReadOnly := True;
    end;
  {$ENDIF}

end;

procedure TfrmSicsCadAlarmes.btnIncluirClick(Sender: TObject);
begin
	dmSicsCadAlarmes.cdsMonitoramentos.Append;
  dbgrdMonitoramento.SetFocus;
end;

procedure TfrmSicsCadAlarmes.btnOKClick(Sender: TObject);
begin
	with dmSicsCadAlarmes.cdsMonitoramentos do
  	if Applyupdates(0) = 0 then
    begin
      {$IFDEF CompilarPara_TGS}
        //
      {$ELSE}
        dmSicsContingencia.CheckReplicarTabelasP2C;
      {$ENDIF}
      ModalResult := mrOk;
    end
    else
    	CancelUpdates;
end;

procedure TfrmSicsCadAlarmes.btnCancelarClick(Sender: TObject);
begin
  with dmSicsCadAlarmes.cdsMonitoramentos do
  	if State in dsEditModes then
    begin
    	Cancel;
      CancelUpdates;
    end;

	Close;    
end;

procedure TfrmSicsCadAlarmes.SpeedButton1Click(Sender: TObject);
begin
	dmSicsCadAlarmes.cdsAlarmes.Append;
  with dbGrdAlarmes do
  begin
  	SetFocus;
  	EditorMode := True;
  	SelectedField := DataSource.DataSet.FieldByName('LKP_NIVEL');
  end;
end;

procedure TfrmSicsCadAlarmes.dtsAlarmesDataChange(Sender: TObject;
  Field: TField);
begin
	if not Assigned(dmSicsCadAlarmes) then Exit;

  if (Field = nil) or (UpperCase(Field.FieldName) = 'ID_PIACAODEALARME') then
  begin
		dtsRelacionado.DataSet := dmSicsCadAlarmes.GetDataRelacionado;
  	dmSicsCadAlarmes.RefreshRelacionados;
  end;

  

end;

procedure TfrmSicsCadAlarmes.dbGrdAlarmesDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  with Sender As TDBGrid Do
  begin
    if (Column.FieldName = 'LKP_COR') and (not column.Field.IsNull) Then
    begin
      Canvas.Brush.Color := TColor(column.Field.AsInteger);
      Canvas.Font.Color  := TColor(column.Field.AsInteger);
    end;
    DefaultDrawColumnCell(Rect,DataCol,Column,State);
  end;
end;

procedure TfrmSicsCadAlarmes.FormDestroy(Sender: TObject);
begin
	FreeAndNil(dmSicsCadAlarmes);
end;

procedure TfrmSicsCadAlarmes.dbGridAcoesCheckFieldClick(Field: TField);
begin
	if dtsRelacionado.DataSet = nil then Exit;

	with dmSicsCadAlarmes.cdsAlarmesRelacionados do
  begin
  	if not Field.AsBoolean then
    begin
    	Locate('ID_RELACIONADO', dtsRelacionado.DataSet.FieldByName('ID').Value, []);
      Delete;

      dmSicsCadAlarmes.RefreshRelacionados;
    end
    else
    begin
    	Append;
      FieldByName('ID_RELACIONADO').Value := dtsRelacionado.DataSet.FieldByName('ID').Value;
      Post;

      dmSicsCadAlarmes.RefreshRelacionados;
    end;
  end;
end;

procedure TfrmSicsCadAlarmes.dbGridAcoesDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
	with dbGridAcoes do
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

procedure TfrmSicsCadAlarmes.btnExcluirClick(Sender: TObject);
begin
	if MessageDlg('Confirma exclusão deste Monitoramento?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  	dmSicsCadAlarmes.cdsMonitoramentos.Delete;
end;

procedure TfrmSicsCadAlarmes.dtsMonitoramentesDataChange(Sender: TObject;
  Field: TField);
begin
	if not Assigned(dmSicsCadAlarmes) then Exit;

  if (Field = nil) or (UpperCase(Field.FieldName) = 'ID_PI') then
  begin
    with dmSicsCadAlarmes, cdsAlarmes.FieldByName('LIMIAR') do
  		if IsFormatoHorario then
      	EditMask := '!90:00;1;_'
      else
      	EditMask := '';
  end;

end;

procedure TfrmSicsCadAlarmes.SpeedButton2Click(Sender: TObject);
begin
	dmSicsCadAlarmes.cdsAlarmes.Delete;
end;

end.
