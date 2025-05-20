unit untFrmConfigParametros;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  {$IFNDEF IS_MOBILE}
  Windows, Messages, ScktComp,
  {$ENDIF}
  FMX.Grid, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.ExtCtrls, FMX.Types, FMX.Layouts, FMX.ListView.Types, FMX.ListView, FMX.ListBox,
  Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors, FMX.Objects, FMX.Edit,
  System.UITypes, System.Types, System.SysUtils, System.Classes, System.IniFiles, System.Variants, System.Rtti,
  MyAspFuncoesUteis,untCommonFormBase, FMX.EditBox, FMX.NumberBox, FMX.Controls.Presentation,
  Data.Bind.EngExt, Data.Bind.Components, System.ImageList, FMX.ImgList, IdStack,
  FMX.Effects;

type
  TFrmConfigParametros = class(TFrmBase)
    edtIP: TEdit;
    lblIp: TLabel;
    lblPorta: TLabel;
    lblModulo: TLabel;
    btnConfirmar: TButton;
    btnCancelar: TButton;
    edtPorta: TEdit;
    edtModulo: TEdit;
    rectBotoes: TRectangle;
    procedure btnConfirmarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FCustomOnClose: TProc;
    { Private declarations }
  public
    { Public declarations }
    class procedure ConfiguraParametrosConexao(ACustomOnClose: TProc = nil);
  end;

implementation

{$R *.fmx}

uses
  untCommonDMConnection, Sics_Common_Parametros, untCommonDMUnidades;

var
  FrmConfigParametros : TFrmConfigParametros;

procedure TFrmConfigParametros.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmConfigParametros.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;

  if Assigned(FCustomOnClose) then
  begin
    FCustomOnClose();
    FCustomOnClose := nil;
  end;

  {$IFDEF IS_MOBILE}
  FreeAndNil (FrmConfigParametros);
  {$ELSE}
  Action := TCloseAction.caFree;
  {$ENDIF IS_MOBILE}
end;

procedure TFrmConfigParametros.btnConfirmarClick(Sender: TObject);
var
  AlterouParametros : boolean;
begin
  AlterouParametros := ((vgParametrosModulo    .IdModulo   <> StrToInt(edtModulo.Text)) or
                        (vgParametrosSicsClient.TCPSrvAdr  <> edtIP.Text              ) or
                        (vgParametrosSicsClient.TCPSrvPort <> StrToInt(edtPorta.Text) ));

  if AlterouParametros then
  begin
    vgParametrosModulo    .IdModulo   := StrToInt(edtModulo.Text);
    vgParametrosSicsClient.TCPSrvAdr  := edtIP.Text;
    vgParametrosSicsClient.TCPSrvPort := StrToInt(edtPorta.Text);

    with TIniFile.Create(AspLib_GetAppIniFileName) do
    try
      WriteInteger('Settings', 'IdModulo'   , vgParametrosModulo.IdModulo      );
      WriteString ('Conexoes', 'TCPSrvAdr'  , vgParametrosSicsClient.TCPSrvAdr );
      WriteInteger('Conexoes', 'TCPSrvPort' , vgParametrosSicsClient.TCPSrvPort);
    finally
      Free;
    end;
  end;

  Close;

  if AlterouParametros then
    FinalizeApplication;
end;

class procedure TFrmConfigParametros.ConfiguraParametrosConexao(ACustomOnClose: TProc = nil);
begin
  FrmConfigParametros := TFrmConfigParametros.Create(GetApplication);

  with FrmConfigParametros do
  begin
    FCustomOnClose := ACustomOnClose;
    edtModulo.Text := IntToStr(vgParametrosModulo.IdModulo);
    edtIP    .Text := vgParametrosSicsClient.TCPSrvAdr;
    edtPorta .Text := IntToStr(vgParametrosSicsClient.TCPSrvPort);

    {$IFDEF IS_MOBILE}
    Show;
    {$ELSE}
    ShowModal;
    {$ENDIF IS_MOBILE}
  end;
end;

end.
