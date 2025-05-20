unit ufrmCadNiveis;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  MyDlls_DR,  ClassLibraryVCL,
  Dialogs, DB, Buttons, Grids, DBGrids, ExtCtrls, ASPDbGrid, System.UITypes,
  Vcl.StdCtrls;

type
  TfrmSicsCadNiveis = class(TForm)
    dtsCadNiveis: TDataSource;
    bvlBotoes: TBevel;
    btnIncluir: TBitBtn;
    btnExcluir: TBitBtn;
    btnOK: TBitBtn;
    btnCancelar: TBitBtn;
    cldCorgeral: TColorDialog;
    dbgCadNiveis: TASPDbGrid;
    procedure FormCreate(Sender: TObject);
    procedure btnIncluirClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure dbgCadNiveisDblClick(Sender: TObject);
    procedure dbgCadNiveisDrawColumnCell(Sender: TObject;
      const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
     class procedure ExibeForm;

    { Public declarations }
  end;

var
  frmSicsCadNiveis: TfrmSicsCadNiveis;

implementation
uses udmCadNiveis, udmContingencia;

{$R *.dfm}

class procedure TfrmSicsCadNiveis.ExibeForm;
begin
	with TFrmSicsCadNiveis.Create(Application) do
  try
  	ShowModal;
  finally
  	Free;
  end;
end;

procedure TfrmSicsCadNiveis.FormCreate(Sender: TObject);
begin
  inherited;
  LoadPosition(Sender as TForm);
  if dmSicsContingencia.TipoFuncionamento = tfContingente then
  begin
    btnOk.Enabled := False;
    btnIncluir.Enabled := False;
    btnExcluir.Enabled := False;
    dbgCadNiveis.ReadOnly := True;
  end;

  dmSicsCadNiveis := TdmSicsCadNiveis.Create(Self);
end;

procedure TfrmSicsCadNiveis.FormDestroy(Sender: TObject);
begin
  SavePosition(Sender as TForm);
  inherited;
end;

procedure TfrmSicsCadNiveis.btnIncluirClick(Sender: TObject);
begin
	dmSicsCadNiveis.cdsCadNiveis.Append;
  dbgCadNiveis.SetFocus;
end;

procedure TfrmSicsCadNiveis.btnExcluirClick(Sender: TObject);
begin
	if MessageDlg('Confirma exclusão deste registro?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  	dmSicsCadNiveis.cdsCadNiveis.Delete;
end;

procedure TfrmSicsCadNiveis.btnOKClick(Sender: TObject);
begin
  if dmSicsCadNiveis.cdsCadNiveis.ApplyUpdates(0) = 0 then
  begin
    dmSicsContingencia.CheckReplicarTabelasP2C;
  end
  else
  begin
    dmSicsCadNiveis.cdsCadNiveis.Cancel;
    dmSicsCadNiveis.cdsCadNiveis.CancelUpdates;
  end;
end;

procedure TfrmSicsCadNiveis.btnCancelarClick(Sender: TObject);
begin
  if dmSicsCadNiveis.cdsCadNiveis.State in dsEditModes Then
     dmSicsCadNiveis.cdsCadNiveis.Cancel;
     dmSicsCadNiveis.cdsCadNiveis.CancelUpdates;

  close;
end;

procedure TfrmSicsCadNiveis.dbgCadNiveisDblClick(Sender: TObject);
begin
     if (cldCorgeral.Execute) Then
     begin
       if not (dmSicsCadNiveis.cdsCadNiveis.State in dsEditModes) Then
       begin
         dmSicsCadNiveis.cdsCadNiveis.Edit;
       end;
       dmSicsCadNiveis.cdsCadNiveis.FieldByName('CODIGOCOR').ReadOnly := False;
       dmSicsCadNiveis.cdsCadNiveis.FieldByName('CODIGOCOR').AsInteger := ColorToRGB(cldCorgeral.Color);
       dmSicsCadNiveis.cdsCadNiveis.FieldByName('CODIGOCOR').ReadOnly := True;
     end;
end;

procedure TfrmSicsCadNiveis.dbgCadNiveisDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  with Sender As TDBGrid Do
  begin
    if (Column.FieldName = 'CODIGOCOR') and (not column.Field.IsNull) Then
    begin
      Canvas.Brush.Color := TColor(column.Field.AsInteger);
      Canvas.Font.Color  := TColor(column.Field.AsInteger);
    end;
    DefaultDrawColumnCell(Rect,DataCol,Column,State);
  end;
end;

end.
