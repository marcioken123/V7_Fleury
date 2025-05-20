unit NAtdCfg;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}
uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, Grids, My_Dlls, My_Types, Sics_94;

type
  TAtendConfigForm = class(TForm)
    AtendConfigGrid: TStringGrid;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    AtendLabel: TLabel;
    IncludeButton: TBitBtn;
    ExcludeButton: TBitBtn;
    PrintBtn: TBitBtn;
    ApagarSenhaBtn: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure AtendConfigGridDblClick(Sender: TObject);
    procedure AtendConfigGridDrawCell(Sender: TObject; Col,
      Row: Longint; Rect: TRect; State: TGridDrawState);
    procedure AtendConfigGridKeyPress(Sender: TObject; var Key: Char);
    procedure IncludeButtonClick(Sender: TObject);
    procedure ExcludeButtonClick(Sender: TObject);
    procedure AtendConfigGridMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormResize(Sender: TObject);
    procedure PrintBtnClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure AtendConfigGridKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ApagarSenhaBtnClick(Sender: TObject);
  private
    { Private declarations }
    vlChanged : boolean;
  public
    { Public declarations }
  end;

function NConfigAtendants : boolean;

implementation

{$R *.DFM}

uses
  sics_m, NSituat;

procedure TAtendConfigForm.AtendConfigGridDblClick(Sender: TObject);
begin
   if AtendConfigGrid.Cells[6, AtendConfigGrid.Row] = '0' then
   begin
      if AtendConfigGrid.Cells[1, AtendConfigGrid.Row] = 'X' then
      begin
        if Application.Messagebox('Deseja desativar este atendente?', 'Confirmação', MB_ICONQUESTION or MB_YESNOCANCEL) = mrYes then
        begin
           AtendConfigGrid.Cells[1, AtendConfigGrid.Row] := '';
           vlChanged := true;
        end;
      end
      else
      begin
         AtendConfigGrid.Cells[1, AtendConfigGrid.Row] := 'X';
         vlChanged := true;
      end;
   end  { if Cells[6,CurrentRow = '0' }
   else
      Application.MessageBox ('Este atendente não pode ser desativado pois está atendendo.',
                              'Atenção', MB_OK OR MB_ICONEXCLAMATION);
end;  { proc AtendConfigGridDblClick }


procedure TAtendConfigForm.AtendConfigGridKeyPress (Sender: TObject;
                                                  var Key: Char);
begin
   vlChanged := true;
end;  { proc AtendConfigGridKeyPress }


procedure TAtendConfigForm.AtendConfigGridKeyUp (Sender: TObject;
                                                 var Key: Word; Shift: TShiftState);
begin
  if Sender is TStringGrid then
    with Sender as TStringGrid do
      If ((Col = 4) and (Key = VK_LEFT)) then
        Col := 3
      else if ((Col = 4) or (Col = 6)) then
        Col := 5;
end;


procedure TAtendConfigForm.AtendConfigGridDrawCell (Sender: TObject;
                                                    Col, Row: Longint; Rect: TRect; State: TGridDrawState);
var
   Hcenter, Hsot, Vcenter, Vsot : integer;
begin
   if (Sender is TStringGrid) then
   begin
      Hcenter := (Rect.Right + Rect.Left) div 2;
      Hsot := Hcenter - ((Sender as TStringGrid).Canvas.TextWidth
                         ((Sender as TStringGrid).Cells[col,row]) div 2);
      Vcenter := (Rect.Bottom + Rect.Top) div 2;
      Vsot := Vcenter - ((Sender as TStringGrid).Canvas.TextHeight
                       ((Sender as TStringGrid).Cells[col,row]) div 2);

//      if ((col = 4) and (row <> 0)) then
//      begin
//        s := '****';
//
//        Hcenter := (Rect.Right + Rect.Left) div 2;
//        Hsot := Hcenter - ((Sender as TStringGrid).Canvas.TextWidth(s) div 2);
//
//        (Sender as TStringGrid).Canvas.TextRect (Rect, Hsot, Vsot, s);
//      end
//      else if col <> 2 then
      if col <> 2 then
         (Sender as TStringGrid).Canvas.TextRect (Rect, Hsot, Vsot,
            (Sender as TStringGrid).Cells[col, row])
      else
         (Sender as TStringGrid).Canvas.TextRect (Rect, Rect.Left + 4, Vsot,
            (Sender as TStringGrid).Cells[col, row])
   end;  { if Sender is TStringGrid }
end;  { proc AtendConfigGridDrawCell }


procedure TAtendConfigForm.AtendConfigGridMouseUp (Sender: TObject;
                                                 Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
   CurrentRow, CurrentCol : longint;
begin
   AtendConfigGrid.MouseToCell (X,Y,CurrentCol,CurrentRow);
   if CurrentRow = 0 then
      CurrentRow := 1;
   AtendConfigGrid.Row := CurrentRow;
   if CurrentCol < 2 then
      AtendConfigGrid.Col := 2;
end;  { proc AtendConfigGridMouseUp }

{----------------------------------------------}

procedure TAtendConfigForm.IncludeButtonClick(Sender: TObject);
var
   s : string;
begin
   s := '';
   if InputQuery ('Novo atendente', 'Digite o número do atendente:', s) then
      try
         if strtoint(s) >= 0 then
         begin
            if strtoint(s) <= cgMaxAtds then
            begin
              if SicsDataModule.InsertAtend(AtendConfigGrid,strtoint(s),true,'','','',0) then
              begin
                 AtendConfigGrid.SetFocus;
                 vlChanged := true;
              end  { if InsertAtend }
              else
                 Application.MessageBox ('Este atendente já existe.', 'Erro', MB_ICONEXCLAMATION);
            end
            else
               Application.MessageBox ('Valor ultrapassa máximo permitido nesta versão.', 'Erro', MB_ICONEXCLAMATION);
         end
         else
            Application.MessageBox ('Este não é um número válido.', 'Erro', MB_ICONEXCLAMATION);
      except
         Application.MessageBox ('Este não é um número válido.', 'Erro', MB_ICONEXCLAMATION);
      end  { try .. except }
end;  { proc IncludeButtonClick }


procedure TAtendConfigForm.ExcludeButtonClick(Sender: TObject);
var
   i : longint;
begin
   if Application.MessageBox ('Excluir este atendente?', 'Confirmação', MB_ICONQUESTION or MB_YESNOCANCEL) = mrYes then
   begin
      i := AtendConfigGrid.Row;
      RemoveRowTitled(AtendConfigGrid, i);
      if i > AtendConfigGrid.RowCount - 1 then
         i := AtendConfigGrid.RowCount - 1;
      AtendConfigGrid.Row := i;
      AtendConfigGrid.Col := 2;
      ExcludeButton.SetFocus;
      AtendConfigGrid.SetFocus;
      vlChanged := true;
   end;  { if Application.MessageBox }
end;  { proc ExcludeButtonClick }


procedure TAtendConfigForm.ApagarSenhaBtnClick(Sender: TObject);
begin
  with AtendConfigGrid do
    if  ((Row > 0 )and (Cells[0,Row] <> '') and (AppMessageBox(Format('Apagar senha do atendente %s - %s?',[Cells[0,Row],Cells[2,Row]]), 'Confirmação', MB_ICONQUESTION or MB_YESNOCANCEL) = mrYes)) then
    begin
      Cells[4,Row] := '';
      vlChanged := true;
    end;
end;


procedure TAtendConfigForm.PrintBtnClick(Sender: TObject);
var
  s1, s2 : string;
begin
  if MainForm.TipoDaImpressora = tiBematech then
  begin
     MainForm.ConfiguraCDBBematech (0);
     Delay(250);
  end;

//  s := 'SICS - Atendente ' + AtendConfigGrid.Cells[0,AtendConfigGrid.Row] + ' (' + AtendConfigGrid.Cells[2,AtendConfigGrid.Row] + ')'#10;
  s1 :=  'SICS - Atendente ' + AtendConfigGrid.Cells[0,AtendConfigGrid.Row] + ' (' + AtendConfigGrid.Cells[2,AtendConfigGrid.Row] + '){{Quebra de Linha}}';
  ConverteProtocoloImpressora(s2, s1, MainForm.TipoDaImpressora);
  MainForm.Imprime(0, s2);

  Delay(500);

//  s := #29#107#73#16 + '/Atd:' + AtendConfigGrid.Cells[0,AtendConfigGrid.Row] + '\';
//  for i := length('/Atd:' + AtendConfigGrid.Cells[0,AtendConfigGrid.Row] + '\') to 15 do
//    s := s + ' ';
//  s := s + #10#10#10#10#27#119;

  s1 := '{{CDB Code39}}'+FormatLeftString(10,'%ATD' + AtendConfigGrid.Cells[0,AtendConfigGrid.Row] + '$')+
        '{{Quebra de Linha}}{{Quebra de Linha}}{{Corte Total}}';
  ConverteProtocoloImpressora(s2, s1, MainForm.TipoDaImpressora);
  MainForm.Imprime(0, s2);
end; { proc PrintBtnClick }

{----------------------------------------------}

procedure TAtendConfigForm.FormCreate(Sender: TObject);
begin
   with AtendConfigGrid do
   begin
      Cells[0,0] := ' No. ';
      Cells[1,0] := ' Ativo ';
      Cells[2,0] := ' Nome ';
      Cells[3,0] := ' Login ';
      Cells[4,0] := ' Senha ';
      Cells[5,0] := ' Grupo ';
      ColWidths[0] := Canvas.TextWidth(Cells[0,0]);
      ColWidths[1] := Canvas.TextWidth(Cells[1,0]);
      ColWidths[5] := Canvas.TextWidth(Cells[5,0]);
      ColWidths[2] := (ClientWidth - ColWidths[0] - ColWidths[1] - ColWidths[5] - 4) div 2;
      ColWidths[3] := ColWidths[2];
      ColWidths[4] := -1;
      ColWidths[6] := -1;
      RowCount := 2;
   end;

   LoadPosition (Sender as TForm);
end;  { proc FormCreate }

procedure TAtendConfigForm.FormDestroy(Sender: TObject);
begin
  SavePosition (Sender as TForm);
end;  { proc FormDestroy }

procedure TAtendConfigForm.FormResize(Sender: TObject);
const
  OFF = 3;
begin
  AtendLabel.Left        := OFF;
  AtendLabel.Top         := OFF;
  AtendConfigGrid.Left   := OFF;
  AtendConfigGrid.Top    := AtendLabel.Top + AtendLabel.Height + OFF;
  AtendConfigGrid.Width  := ClientWidth    - 2*OFF;
  AtendConfigGrid.Height := ClientHeight   - AtendConfigGrid.Top - IncludeButton.Height - 2*OFF;
  IncludeButton.Left     := OFF;
  IncludeButton.Top      := AtendConfigGrid.Top  + AtendConfigGrid.Height + OFF;
  ExcludeButton.Left     := IncludeButton  .Left + IncludeButton  .Width  + 2*OFF;
  ExcludeButton.Top      := IncludeButton.Top;
  ApagarSenhaBtn.Left    := ExcludeButton  .Left + ExcludeButton  .Width  + OFF;
  ApagarSenhaBtn.Top     := IncludeButton.Top;
  PrintBtn.Left          := ApagarSenhaBtn .Left + ApagarSenhaBtn .Width  + OFF;
  PrintBtn.Top           := IncludeButton.Top;
  CancelButton.Left      := AtendConfigGrid.Left + AtendConfigGrid.Width  - CancelButton.Width;
  CancelButton.Top       := IncludeButton.Top;
  OkButton.Left          := CancelButton   .Left - OkButton       .Width  - OFF;
  OkButton.Top           := IncludeButton.Top;

   with AtendConfigGrid do
   begin
      ColWidths[2] := (ClientWidth - ColWidths[0] - ColWidths[1] - ColWidths[5] - 4) div 2;
      ColWidths[3] := ColWidths[2];
   end;  { with AtendConfigGrid }

  AtendConfigGrid.Repaint;
end;  { proc FormResize }

{------------------------------------------------}

function NConfigAtendants : boolean;
var
  AtendConfigForm : TAtendConfigForm;
  i               : integer;
begin
  Result := false;
  try
    AtendConfigForm := TAtendConfigForm.Create(Application);
    try
      with AtendConfigForm do
      begin
         vlChanged := false;
         SicsDataModule.LoadAtendFromDBTable(AtendConfigGrid);
{ Destrava todos os teclados }
         for i := 1 to AtendConfigGrid.RowCount - 1 do
            AtendConfigGrid.Cells[6,i] := '0';

         if ((ShowModal = mrOk) and (vlChanged)) then
         begin
            SicsDataModule.SaveAtendToDBTable  (AtendConfigGrid);
            SicsDataModule.LoadAtendFromDBTable(SicsDataModule.AtdGrid);
            SituationForm .AtualizaListaDeAtendentes;
            Result := true;
         end   { if ShowModal = Ok }
      end;  { with AtendConfigForm }
    finally
      AtendConfigForm.Free;
    end;  { try .. finally }
  except
//    Result := false;
    Raise;
  end;  { try .. except }
end;  {  func ConfigAtendants }

end.
