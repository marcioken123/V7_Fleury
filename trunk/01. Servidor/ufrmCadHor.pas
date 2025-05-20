unit ufrmCadHor;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, Grids, DBGrids, ExtCtrls, Buttons, ASPDbGrid, System.UITypes,
  Vcl.StdCtrls;

type
  TfrmSicsCadHor = class(TForm)
    dtsCadHor: TDataSource;
    btnIncluir: TBitBtn;
    btnExcluir: TBitBtn;
    btnOK: TBitBtn;
    btnCancelar: TBitBtn;
    dbgCadHor: TASPDbGrid;
    procedure FormCreate(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnIncluirClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure dbgCadHorColEnter(Sender: TObject);
    procedure dbgCadHorDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    class function ExibeForm(var IdUnidade: Integer): Boolean;

    { Public declarations }
  end;

implementation

uses
  sics_94, udmContingencia,
  udmCadHor, MyDlls_DR, ClassLibraryVCL;

{$R *.dfm}

class function TfrmSicsCadHor.ExibeForm(var IdUnidade: Integer): Boolean;
begin
  IdUnidade := dmSicsMain.CheckPromptUnidade;

	with TFrmSicsCadHor.Create(Application) do
  try

    dmSicsCadHor := TdmSicsCadHor.Create(nil);
    dmSicsCadHor.IdUnidade := IdUnidade;

  	Result := ShowModal = mrOk;
  finally
  	Free;
  end;
end;

procedure TfrmSicsCadHor.FormCreate(Sender: TObject);
begin
  inherited;
  LoadPosition(Sender as TForm);
    if dmSicsContingencia.TipoFuncionamento = tfContingente then
    begin
      btnIncluir.Enabled := False;
      btnExcluir.Enabled := False;
      btnOk.Enabled := False;
      dbgCadHor.ReadOnly := True;
    end;
end;

procedure TfrmSicsCadHor.btnCancelarClick(Sender: TObject);
begin
  if dmSicsCadHor.cdsCadHor.State in dsEditModes Then
     dmSicsCadHor.cdsCadHor.Cancel;
     dmSicsCadHor.cdsCadHor.CancelUpdates;

  close;
end;

procedure TfrmSicsCadHor.btnIncluirClick(Sender: TObject);
begin
	dmSicsCadHor.cdsCadHor.Append;
  dbgCadHor.SetFocus;
end;

procedure TfrmSicsCadHor.btnExcluirClick(Sender: TObject);
begin
	if MessageDlg('Confirma exclusão deste horário?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  	dmSicsCadHor.cdsCadHor.Delete;
end;

procedure TfrmSicsCadHor.btnOKClick(Sender: TObject);
begin
  if dmSicsCadHor.cdsCadHor.ApplyUpdates(0) = 0 then
  begin
      dmSicsContingencia.CheckReplicarTabelasP2C;
    ModalResult := mrOk;
  end;
end;


procedure TfrmSicsCadHor.dbgCadHorColEnter(Sender: TObject);
begin
  if dbgCadHor.SelectedIndex = 0 then
    dbgCadHor.SelectedIndex := 1;
end;

procedure TfrmSicsCadHor.dbgCadHorDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  with dbgCadHor do
  begin
    if DataCol = 0 then
      Canvas.Brush.Color := clBtnFace;
    DefaultDrawColumnCell(Rect, DataCol, Column, State);
  end;

end;

procedure TfrmSicsCadHor.FormDestroy(Sender: TObject);
begin
  FreeAndNil(dmSicsCadHor);
  SavePosition(Sender as TForm);
  inherited;
end;

end.
