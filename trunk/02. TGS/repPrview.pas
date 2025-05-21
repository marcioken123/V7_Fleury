unit repPrview;

interface
{$INCLUDE ..\AspDefineDiretivas.inc}

{$J+}

uses
  Windows, Messages, SysUtils, Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.Printers, Vcl.Buttons, Vcl.ExtCtrls, qrprntr, Vcl.ComCtrls, Vcl.ToolWin, Vcl.StdCtrls,
  quickrpt,MyAspFuncoesUteis;

type
  TfrmSicsRepPreview = class(TForm)
    ToolbarPanel: TPanel;
    PrintDialog: TPrintDialog;
    StatusBar: TStatusBar;
    QRPreview: TQRPreview;
    ZFitWidBtn: TBitBtn;
    Z100Btn: TBitBtn;
    ZFitPageBtn: TBitBtn;
    FirstBtn: TBitBtn;
    PriorBtn: TBitBtn;
    NextBtn: TBitBtn;
    LastBtn: TBitBtn;
    PrintBtn: TBitBtn;
    CloseBtn: TBitBtn;
    procedure PrintBtnClick(Sender: TObject);
    procedure Z100BtnClick(Sender: TObject);
    procedure QRPreviewProgressUpdate(Sender: TObject; Value: Integer);
    procedure FirstBtnClick(Sender: TObject);
    procedure StatusBarResize(Sender: TObject);
    procedure CloseBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure QRPreviewClick(Sender: TObject);
    procedure QRPreviewPageAvailable(Sender: TObject; PageNum: Integer);
  protected
    procedure AtualizaStatusQtdePaginas; Virtual;
    { Private declarations }
  public
    { Public declarations }
    pQuickReport : TQuickRep;

    class procedure Preview(AQuickReport: TQuickRep; AQrPrinter: TQrPrinter);
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; Override;
  end;

implementation

{$R *.DFM}

class procedure TfrmSicsRepPreview.Preview(AQuickReport: TQuickRep; AQrPrinter: TQrPrinter);
var
  LfrmSicsRepPreview: TfrmSicsRepPreview;
begin
  LfrmSicsRepPreview := TfrmSicsRepPreview.Create(nil);
  with LfrmSicsRepPreview do
  try
    pQuickreport := AQuickReport;
    QRPreview.QRPrinter := AQrPrinter;
    ShowModal;
  finally
    FreeAndNil(LfrmSicsRepPreview);
  end;
end;

procedure TfrmSicsRepPreview.AtualizaStatusQtdePaginas;
begin
   StatusBar.Panels.Items[2].Text := 'Pág. ' + inttostr(QRPreview.PageNumber) +
                                     ' de ' + inttostr(QRPreview.QRPrinter.PageCount);
end;

procedure TfrmSicsRepPreview.StatusBarResize(Sender: TObject);
begin
   StatusBar.Panels.Items[0].Width := StatusBar.Width div 3;
   StatusBar.Panels.Items[1].Width := StatusBar.Width div 3;

   Z100Btn.Left := 10;
   ZFitWidBtn.Left := Z100Btn.Left + Z100Btn.Width + 1;
   ZFitPageBtn.Left := ZFitWidBtn.Left + ZFitWidBtn.Width + 1;

   FirstBtn.Left := ZFitPageBtn.Left + ZFitPageBtn.Width + 10;
   PriorBtn.Left := FirstBtn.Left + FirstBtn.Width;
   NextBtn.Left := PriorBtn.Left + PriorBtn.Width;
   LastBtn.Left := NextBtn.Left + NextBtn.Width;

   PrintBtn.Left := LastBtn.Left + LastBtn.Width + 10;

   CloseBtn.Left := PrintBtn.Left + PrintBtn.Width + 10;
end; 

procedure TfrmSicsRepPreview.QRPreviewPageAvailable(Sender: TObject; PageNum: Integer);
begin
  AtualizaStatusQtdePaginas;
end;

procedure TfrmSicsRepPreview.QRPreviewProgressUpdate (Sender: TObject; Value: Integer);
begin
   GetApplication.ProcessMessages;
   StatusBar.Panels.Items[0].Text := IntToStr(Value) + '%';
end;  

procedure TfrmSicsRepPreview.Z100BtnClick(Sender: TObject);
begin
   GetApplication.ProcessMessages;
   if Sender = Z100Btn then
      QRPreview.Zoom := 100
   else if Sender = ZFitWidBtn then
      QRPreview.ZoomToWidth
   else if Sender = ZFitPageBtn then
      QRPreview.ZoomToFit;
   Z100Btn.Enabled     := true;
   ZFitWidBtn.Enabled  := true;
   ZFitPageBtn.Enabled := true;
   (Sender as TBitBtn).Enabled := false;
end;  { proc Z100BtnClick }


procedure TfrmSicsRepPreview.FirstBtnClick(Sender: TObject);
begin
   GetApplication.ProcessMessages;
   if Sender = FirstBtn then
      QRPreview.PageNumber := 1
   else if Sender = PriorBtn then
      QRPreview.PageNumber := QRPreview.PageNumber - 1
   else if Sender = NextBtn then
      QRPreview.PageNumber := QRPreview.PageNumber + 1
   else if Sender = LastBtn then
      QRPreview.PageNumber := QRPreview.QRPrinter.PageCount;

  AtualizaStatusQtdePaginas;
end;

procedure TfrmSicsRepPreview.PrintBtnClick(Sender: TObject);
begin
  with pQuickReport do
  begin
    tag := -1; { Just in case you are using an older version }
    PrinterSetup;
    if tag = 0 then
      print;
  end;
end;  { proc PrintBtnClick }

procedure TfrmSicsRepPreview.CloseBtnClick(Sender: TObject);
begin
   Z100Btn.Enabled     := true;
   ZFitWidBtn.Enabled  := true;
   ZFitPageBtn.Enabled := true;
   Close;
end;

constructor TfrmSicsRepPreview.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TfrmSicsRepPreview.Destroy;
begin
  pQuickReport := nil;
  FreeAndNil(QRPreview);
  inherited;
end;

procedure TfrmSicsRepPreview.QRPreviewClick(Sender: TObject);
const
   Zoom200 : boolean = false;
begin
   Z100Btn.Enabled     := true;
   ZFitWidBtn.Enabled  := true;
   ZFitPageBtn.Enabled := true;

   if Zoom200 then
      QRPreview.Zoom := 200
   else
   begin
      Z100Btn.Enabled := false;
      QRPreview.Zoom := 100;
   end;  { else }
   Zoom200 := not Zoom200;
end;  { proc QRPreviewClick }

procedure TfrmSicsRepPreview.FormShow(Sender: TObject);
begin
  inherited;

  QRPreview.UpdateImage;
  QRPreview.Repaint;
end;

procedure TfrmSicsRepPreview.FormClose (Sender: TObject;
                                     var Action: TCloseAction);
begin
   QRPreview.PageNumber := 1;
   QRPreview.QRPrinter := nil;
end;  { proc FormClose }


end.

