unit Sics_Common_PIShow;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, ExtCtrls, IniFiles, MyDlls_DR;

type
  TfrmSicsCommom_PIShow = class(TForm)
    sgPIs: TStringGrid;
    btnFechar: TButton;
    PIsUpdateTimer: TTimer;
    procedure btnFecharClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PIsUpdateTimerTimer(Sender: TObject);
    procedure sgPIsDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    vlPIsPermitidos : TIntArray;
  public
    { Public declarations }
    procedure AssociaNomePI (IdPI : integer; NomePI : string);
    function AtualizaStatusPI (TotalPIs, IndexPI, IdPI : integer; EstadoPI : char; ValorPI : string) : boolean;
    function IsAllowedPI (PI : integer) : boolean;
  end;

implementation

uses Sics_Common_DataModuleClientConnection;

{$R *.dfm}

procedure TfrmSicsCommom_PIShow.AssociaNomePI (IdPI : integer; NomePI : string);
var
  i : integer;
begin
  for i := 1 to sgPIs.RowCount - 1 do
  begin
    if sgPIs.Cells[3,i] = inttostr(idPI) then
      sgPIs.Cells[0,i] := NomePI;
  end;  { for i }
end;  { proc AssociaNomePI }


function TfrmSicsCommom_PIShow.AtualizaStatusPI (TotalPIs, IndexPI, IdPI : integer; EstadoPI : char; ValorPI : string) : boolean;
begin
  with sgPIs do
  begin
    RowCount := TotalPIs + 1;
    if IndexPI > sgPIs.RowCount then
    begin
      // algo deu errado...
      Result := false;
      Exit;
    end;

    if Cells[3,IndexPI] <> inttostr(idPI) then
      Cells[0,IndexPI] := '???';

    Cells[1,IndexPI] := ValorPI;
    case EstadoPI of
      'N' : Cells[2,IndexPI] := 'Normal';
      'A' : Cells[2,IndexPI] := 'Atenção';
      'C' : Cells[2,IndexPI] := 'Crítico';
    end;
    Cells[3,IndexPI] := inttostr(idPI);

    Result := (Cells[0,IndexPI] <> '???');
  end;  { for i }
end;  { proc AtualizaStatusPI }


procedure TfrmSicsCommom_PIShow.btnFecharClick(Sender: TObject);
begin
  Close;
end;  { proc btnFecharClick }


procedure TfrmSicsCommom_PIShow.FormResize(Sender: TObject);
const
  OFF = 5;
begin
  sgPIs.Left     := OFF;
  sgPIs.Top      := OFF;
  sgPIs.Width    := ClientWidth - 2*OFF;
  sgPIs.Height   := ClientHeight - btnFechar.Height - 3*OFF;
  btnFechar.Left := ClientWidth - OFF - btnFechar.Width;
  btnFechar.Top  := ClientHeight - OFF - btnFechar.Height;
  sgPIs.Repaint;
end;


procedure TfrmSicsCommom_PIShow.FormCreate (Sender: TObject);
var
  ArqIni : TIniFile;
begin
  ArqIni := TIniFile.Create (GetAppIniFileName);
  try
    StrToIntArray (ArqIni.ReadString  ('Settings', 'IndicadoresPermitidos', ''), vlPIsPermitidos);
  finally
    ArqIni.Free;
  end;

  with sgPIs do
  begin
    ColCount := 4;
    RowCount := 2;
    Cells[0,0] := 'PI';
    Cells[1,0] := 'Valor';
    Cells[2,0] := 'Estado';
    Cells[3,0] := 'IdPI';
  end;

  LoadPosition (Sender as TForm);
end;


procedure TfrmSicsCommom_PIShow.FormDestroy (Sender: TObject);
var
  ArqIni : TIniFile;
  aux1   : string;
begin
  IntArrayToStr(vlPIsPermitidos, aux1);

  ArqIni := TIniFile.Create(GetAppIniFileName);
  try
    ArqIni.WriteString  ('Settings', 'IndicadoresPermitidos', aux1);
  finally
    ArqIni.Free;
  end;

  SavePosition (Sender as TForm);
end;


procedure TfrmSicsCommom_PIShow.PIsUpdateTimerTimer (Sender: TObject);
begin
  dmSicsClientConnection.SendCommandToHost($FFFF, $66, '', Tag, False);
end;


procedure TfrmSicsCommom_PIShow.sgPIsDrawCell (Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  Hcenter, Hsot, Vcenter, Vsot : integer;
begin
  if Sender is TStringGrid then
    with Sender as TStringGrid do
    begin
      if (Acol = 0) or (Acol = 1) or (Acol = 2) then
      begin
        Hcenter := (Rect.Right + Rect.Left) div 2;
        Hsot := Hcenter - (Canvas.TextWidth(Cells[Acol,Arow]) div 2);

        Vcenter := (Rect.Bottom + Rect.Top) div 2;
        Vsot := Vcenter - (Canvas.TextHeight(Cells[Acol,Arow]) div 2);

        if Acol = 2 then
        begin
          if Cells[Acol, Arow] = 'Normal' then
            Canvas.Brush.Color := clLime
          else if Cells[Acol, Arow] = 'Atenção' then
            Canvas.Brush.Color := clYellow
          else if Cells[Acol, Arow] = 'Crítico' then
            Canvas.Brush.Color := clRed
        end
        else
          Canvas.Brush.Color := clWhite;

        Canvas.TextRect (Rect, Hsot, VSot, Cells[Acol, Arow]);
      end;  { if Sender is TStringGrid }

      ColWidths[1] := Canvas.TextWidth(' HH:MM:SS ');
      ColWidths[2] := Canvas.TextWidth(' Atenção ');
      ColWidths[0] := ClientWidth - ColWidths[1] - ColWidths[2] - 4;
      ColWidths[3] := -1;
    end;  { with }
end;  { proc sgPIsOnDrawCell }


procedure TfrmSicsCommom_PIShow.FormClose(Sender: TObject; var Action: TCloseAction);
begin
end;  { proc FormClose }


procedure TfrmSicsCommom_PIShow.FormShow(Sender: TObject);
begin
end;  { proc FormShow }


function TfrmSicsCommom_PIShow.IsAllowedPI (PI : integer) : boolean;
begin
  Result := ( ExisteNoIntArray(PI , vlPIsPermitidos) or
              ExisteNoIntArray(0  , vlPIsPermitidos)
            );
end;  { is AllowedPI }

end.
