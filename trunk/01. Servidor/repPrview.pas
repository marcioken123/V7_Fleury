unit repPrview;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}
{$J+}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Printers, Buttons, ExtCtrls, qrprntr, ComCtrls,
  quickrpt, MyDlls_DR,  MyAspFuncoesUteis_VCL, Vcl.StdCtrls;

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
    procedure QRPreviewProgressUpdate(Sender: TObject; Progress: Integer);
    procedure QRPreviewPageAvailable(Sender: TObject; PageNum: Integer);
    procedure FirstBtnClick(Sender: TObject);
    procedure StatusBarResize(Sender: TObject);
    procedure CloseBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure QRPreviewClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    vlMaxPages : integer;
  public
    { Public declarations }
    pQuickReport : TQuickRep;

    class procedure Preview(AQuickReport: TQuickRep; AQrPrinter: TQrPrinter);
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

procedure TfrmSicsRepPreview.StatusBarResize(Sender: TObject);
begin
   StatusBar.Panels.Items[0].Width := StatusBar.ClientWidth div 3;
   StatusBar.Panels.Items[1].Width := StatusBar.ClientWidth div 3;

   Z100Btn.Left := 10;
   ZFitWidBtn.Left := Z100Btn.Left + Z100Btn.Width + 1;
   ZFitPageBtn.Left := ZFitWidBtn.Left + ZFitWidBtn.Width + 1;

   FirstBtn.Left := ZFitPageBtn.Left + ZFitPageBtn.Width + 10;
   PriorBtn.Left := FirstBtn.Left + FirstBtn.Width;
   NextBtn.Left := PriorBtn.Left + PriorBtn.Width;
   LastBtn.Left := NextBtn.Left + NextBtn.Width;

   PrintBtn.Left := LastBtn.Left + LastBtn.Width + 10;

   CloseBtn.Left := PrintBtn.Left + PrintBtn.Width + 10;
end;  { proc StatusBarResize }


procedure TfrmSicsRepPreview.QRPreviewProgressUpdate (Sender: TObject;
                                                   Progress: Integer);
begin
   Application.ProcessMessages;
   StatusBar.Panels.Items[0].Text := IntToStr(Progress) + '%';
end;  { proc QRPreviewProgressUpdate }


procedure TfrmSicsRepPreview.QRPreviewPageAvailable (Sender: TObject;
                                                  PageNum: Integer);
begin
   vlMaxPages := PageNum;
   StatusBar.Panels.Items[2].Text := 'Pág. ' + inttostr(QRPreview.PageNumber) +
                                     ' de ' + inttostr(vlMaxPages);
end;  { proc QRPreviewPageAvailable }


procedure TfrmSicsRepPreview.Z100BtnClick(Sender: TObject);
begin
   Application.ProcessMessages;
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
   Application.ProcessMessages;
   if Sender = FirstBtn then
      QRPreview.PageNumber := 1
   else if Sender = PriorBtn then
      QRPreview.PageNumber := QRPreview.PageNumber - 1
   else if Sender = NextBtn then
      QRPreview.PageNumber := QRPreview.PageNumber + 1
   else if Sender = LastBtn then
      QRPreview.PageNumber := vlMaxPages;

   StatusBar.Panels.Items[2].Text := 'Pág. ' + inttostr(QRPreview.PageNumber) +
                                     ' de ' + inttostr(vlMaxPages);
end;  { proc FirsBtnClick }


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
end;  { proc CloseBtnClick }


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
  LoadPosition(Self);

  QRPreview.UpdateImage;
  QRPreview.Repaint;
end;  { proc FormShow }


procedure TfrmSicsRepPreview.FormClose (Sender: TObject;
                                     var Action: TCloseAction);
begin
   pQuickReport.DataSet.EnableControls;
   QRPreview.PageNumber := 1;
   QRPreview.QRPrinter := nil;
end;  { proc FormClose }


procedure TfrmSicsRepPreview.FormDestroy(Sender: TObject);
begin
   SavePosition(Self);
end;

end.

