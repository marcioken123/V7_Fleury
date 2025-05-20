unit sics_5;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBGrids, ASPDbGrid, StdCtrls, Buttons, DB, DBClient,
  MyDlls_DR,  ClassLibraryVCL,
  Sics_94, sics_dm, uDataSetHelper, Vcl.Grids, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Datasnap.Provider;

type
  TfrmSicsProcessosParalelos = class(TForm)
    Label1: TLabel;
    gridPPs: TASPDbGrid;
    CloseButton: TBitBtn;
    cdsPPs: TClientDataSet;
    dsProcessosParalelos: TDataSource;
    cdsPPsId_TipoPP: TIntegerField;
    cdsPPsId_PA: TIntegerField;
    cdsPPsId_Atd: TIntegerField;
    cdsPPsHorario: TSQLTimeStampField;
    cdsPPslkp_PA_Nome: TStringField;
    cdsPPslkp_Atd_Nome: TStringField;
    cdsPPslkp_TipoPP_Nome: TStringField;
    cdsClonePPs: TClientDataSet;
    cdsPPsId_EventoPP: TIntegerField;
    cdsPPsTicketNumber: TIntegerField;
    cdsPPsNomeCliente: TStringField;
    cdsPPsID: TIntegerField;
    cdsPPsID_UNIDADE: TIntegerField;
    dspPPs: TDataSetProvider;
    qryPPs: TFDQuery;
    qryPPsID_UNIDADE: TIntegerField;
    qryPPsID: TIntegerField;
    qryPPsID_EVENTOPP: TIntegerField;
    qryPPsID_TIPOPP: TIntegerField;
    qryPPsID_PA: TIntegerField;
    qryPPsID_ATD: TIntegerField;
    qryPPsTICKETNUMBER: TIntegerField;
    qryPPsHORARIO: TSQLTimeStampField;
    qryPPsNOMECLIENTE: TStringField;
    procedure CloseButtonClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cdsPPsAfterOpen(DataSet: TDataSet);
    procedure cdsPPsBeforePost(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure IniciaPP            (TipoPP, PA, ATD, Senha : integer; Horario : TDateTime);
    function  FinalizaPP          (Id_EventoPP, PA, ATD: integer) : boolean;
    procedure UpdateNomeDoCliente (Senha: integer; Nome: string);
  end;

var
  frmSicsProcessosParalelos: TfrmSicsProcessosParalelos;

implementation

uses
  Sics_m, ASPGenerator;

{$R *.dfm}

procedure TfrmSicsProcessosParalelos.cdsPPsBeforePost(DataSet: TDataSet);
begin
  if cdsPPs.State = dsInsert then
  begin
    cdsPPsID.AsInteger := TGenerator.NGetNextGenerator('GEN_ID_PPAS', dmSicsMain.connOnLine);
  end;
end;

procedure TfrmSicsProcessosParalelos.CloseButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmSicsProcessosParalelos.FormResize(Sender: TObject);
const
  OFF = 5;
begin
  Label1.Top := OFF;
  Label1.Left := OFF;

  with gridPPs do
  begin
    Left := Label1.Left;
    Top  := Label1.Top + Label1.Height + OFF;
    Width := frmSicsProcessosParalelos.ClientWidth - 2*OFF;
    Height := frmSicsProcessosParalelos.ClientHeight - Label1.Height - CloseButton.Height - 4*OFF;

    Columns[1].Width := Canvas.TextWidth('  Senha  ');
    if vgMostrarNomeCliente then
    begin
      Columns[5].Width := Canvas.TextWidth('   88:88:88   ');
      Columns[0].Width := (ClientWidth - Columns[1].Width - Columns[5].Width - 7) div 4;
      Columns[2].Width := Columns[0].Width;
      Columns[3].Width := Columns[0].Width;
      Columns[4].Width := Columns[0].Width;
    end
    else
    begin
      Columns[4].Width := Canvas.TextWidth('   88:88:88   ');
      Columns[0].Width := (ClientWidth - Columns[1].Width - Columns[4].Width - 6) div 3;
      Columns[2].Width := Columns[0].Width;
      Columns[3].Width := Columns[0].Width;
    end;
  end;

  CloseButton.Top := gridPPs.Top + gridPPs.Height + OFF;;
  CloseButton.Left := gridPPs.Left + gridPPs.Width - CloseButton.Width;
end;  { proc FormResize }


procedure TfrmSicsProcessosParalelos.FormCreate(Sender: TObject);
begin
  with cdsPPs do
  begin
    CreateDataSet;
    LogChanges := false;
    FieldByName('NomeCliente').Visible := vgMostrarNomeCliente;
  end;

  LoadPosition (Sender as TForm);
end;


procedure TfrmSicsProcessosParalelos.FormDestroy(Sender: TObject);
begin
  SavePosition (Sender as TForm);
end;


procedure TfrmSicsProcessosParalelos.cdsPPsAfterOpen(DataSet: TDataSet);
begin
  cdsClonePPs.CloneCursor(cdsPPs, true);
end;


procedure TfrmSicsProcessosParalelos.IniciaPP (TipoPP, PA, ATD, Senha: integer; Horario: TDateTime);
var
  BM : TBookMark;
begin
  with cdsPPs do
  begin
    DisableControls;
    try
      BM := GetBookmark;
      try
        Append;

        FieldByName('ID_EventoPP').AsInteger  := TGenerator.NGetNextGenerator('GEN_ID_EVENTO_PP', dmSicsMain.connOnLine);
        FieldByName('ID_TipoPP').AsInteger    := TipoPP;
        FieldByName('ID_PA').AsInteger        := PA;
        FieldByName('ID_ATD').AsInteger       := ATD;
        FieldByName('TicketNumber').AsInteger := Senha;
        FieldByName('NomeCliente').AsString   := frmSicsMain.GetNomeParaSenha(Senha);
        FieldByName('Horario').AsDateTime     := Horario;

        Post;
        ApplyUpdates(0);

        GotoBookmark(BM);
      finally
        FreeBookmark(BM);
      end;
    finally
      EnableControls;
    end;
  end;

  frmSicsMain.SalvaSituacao_PPs;
end;


function TfrmSicsProcessosParalelos.FinalizaPP (Id_EventoPP, PA, ATD: integer) : boolean;
begin
  Result := false;
  with cdsClonePPs do
    if Locate ('Id_EventoPP', Id_EventoPP, []) then
    begin
      RegistraEventoPP (Id_EventoPP, FieldByName('Id_TipoPP').AsInteger, FieldByName('Id_PA').AsInteger, PA,
                        FieldByName('Id_Atd').AsInteger, ATD, FieldByName('TicketNumber').AsInteger,
                        FieldByName('Horario').AsDateTime, now);
      Delete;

      frmSicsMain.SalvaSituacao_PPs;
      Result := true;
    end;
end;


procedure TfrmSicsProcessosParalelos.UpdateNomeDoCliente (Senha : integer; Nome : string);
var
  CDSClone : TClientDataSet;
begin
  CDSClone := TClientDataSet.Create(nil);
  with CDSClone do
    try
      CloneCursor(cdsPPs, True);

      Filter := 'TicketNumber = ' + inttostr(senha);
      Filtered := true;

      First;
      while not eof do
      begin
        Edit;
        FieldByName('NomeCliente').AsString := Nome;
        Post;
        Next;
      end;
    finally
      FreeAndNil(CDSClone);
    end;
end;  { proc UpdateNomeDoCliente }

end.
