unit Sics_Common_PIShow;

interface
{$INCLUDE ..\AspDefineDiretivas.inc}


uses
  {$IFNDEF IS_MOBILE}
  Windows, Messages, ScktComp,
  {$ENDIF}
  FMX.Grid, FMX.Controls, FMX.Forms, FMX.Graphics,
  FMX.Dialogs, FMX.StdCtrls, FMX.ExtCtrls, FMX.Types, FMX.Layouts, AspLayout, FMX.ListView.Types,
  FMX.ListView, FMX.ListBox,
  FMX.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors, FMX.Objects, FMX.Edit, FMX.TabControl,

  System.UIConsts, System.Generics.Defaults, System.Generics.Collections,
  System.UITypes, System.Types, System.SysUtils, System.Classes, System.Variants, Data.DB, Datasnap.DBClient, System.Rtti, 
  Data.Bind.EngExt, Data.Bind.Components,
  Data.Bind.Grid, Data.Bind.DBScope, 
  AspFMXHelper, ClassLibrary, MyDlls_DX,  
  IniFiles, AspButton,
  untCommonFormBase, untCommonFrameBase, FMX.Controls.Presentation;

type
  TfrmSicsCommom_PIShow = class(TForm)
    sgPIs: TStringGrid;
    btnFechar: TAspButton;
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
  public
    { Public declarations }
    procedure AssociaNomePI (IdPI : integer; NomePI : string);
    function AtualizaStatusPI (TotalPIs, IndexPI, IdPI : integer; EstadoPI : char; ValorPI : string) : boolean;
    function IsAllowedPI (PI : integer) : boolean;
  end;

function FraIndicadorPerformance(const aIDUnidade: Integer): TfrmSicsCommom_PIShow;
function frmSicsCommom_PIShow(const aIDUnidade: Integer): TfrmSicsCommom_PIShow;
implementation

uses untCommonDMConnection, Sics_Common_Parametros, Aspect, AspComponenteUnidade, AspVCLtoFMXHelper;

{$R *.fmx}
{ %CLASSGROUP 'FMX.Controls.TControl' }

function frmSicsCommom_PIShow(const aIDUnidade: Integer): TfrmSicsCommom_PIShow;
begin
  Result := TfrmSicsCommom_PIShow(FGerenciadorUnidades.FormGerenciado[tcPIShow, aIDUnidade]);
end;

function FraIndicadorPerformance(const aIDUnidade: Integer): TfrmSicsCommom_PIShow;
begin
  Result := frmSicsCommom_PIShow(aIDUnidade);
end;

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
  sgPIs.Position.X     := OFF;
  sgPIs.Position.Y      := OFF;
  sgPIs.Width    := ClientWidth - 2*OFF;
  sgPIs.Height   := ClientHeight - btnFechar.Height - 3*OFF;
  btnFechar.Position.X := ClientWidth - OFF - btnFechar.Width;
  btnFechar.Position.Y  := ClientHeight - OFF - btnFechar.Height;
  sgPIs.Repaint;
end;


procedure TfrmSicsCommom_PIShow.FormCreate (Sender: TObject);
begin
  FGerenciadorUnidades.Add(tcPIShow, Self);
  with sgPIs do
  begin
    ColumnCount := 4;
    RowCount := 2;
    Cells[0,0] := 'PI';
    Cells[1,0] := 'Valor';
    Cells[2,0] := 'Estado';
    Cells[3,0] := 'IdPI';
  end;

  aspect.LoadPosition (Sender as TForm);
end;


procedure TfrmSicsCommom_PIShow.FormDestroy (Sender: TObject);
begin
  FGerenciadorUnidades.Remove(tcPIShow, Self);
  aspect.SavePosition (Sender as TForm);
  inherited;
end;


procedure TfrmSicsCommom_PIShow.PIsUpdateTimerTimer (Sender: TObject);
begin
  DMConnection.EnviarComando('FFFF' + Chr($66), Tag);
end;


procedure TfrmSicsCommom_PIShow.sgPIsDrawCell (Sender: TObject; ACol, ARow: Integer;
                                     Rect: TRect; State: TGridDrawState);

//var
  //Hcenter, Hsot : integer;
begin
  if Sender is TStringGrid then
    with Sender as TStringGrid do
    begin
      if (Acol = 0) or (Acol = 1) or (Acol = 2) then
      begin
        //Hcenter := (Rect.Right + Rect.Left) div 2;
        //Hsot := Hcenter - (Trunc(Canvas.TextWidth(Cells[Acol,Arow])) div 2);
        if Acol = 2 then
        begin
          if Cells[Acol, Arow] = 'Normal' then
            Canvas.Fill.Color := clLime
          else if Cells[Acol, Arow] = 'Atenção' then
            Canvas.Fill.Color := clYellow
          else if Cells[Acol, Arow] = 'Crítico' then
            Canvas.Fill.Color := clRed
        end;
        //Canvas.TextRect (Rect, Hsot, Rect.Top, Cells[Acol, Arow]);
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
  Result := ( ExisteNoIntArray(PI , ParametrosModulo.GruposIndicadoresPermitidos) or
              ExisteNoIntArray(0  , ParametrosModulo.GruposIndicadoresPermitidos)
            );
end;  { is AllowedPI }

end.
