unit untCommonFormSelecaoMotivoPausa;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  {$IFNDEF IS_MOBILE}
  Windows, Messages, ScktComp,
  {$ENDIF}
  FMX.Grid, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.ExtCtrls, FMX.Types, FMX.Layouts, FMX.ListView.Types, FMX.ListView,
  FMX.ListBox, Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs,
  Fmx.Bind.Editors, FMX.Objects, FMX.Edit, FMX.TabControl, System.UITypes,
  System.Types, System.SysUtils, System.Classes, System.Variants, Data.DB,
  System.Rtti, Data.Bind.EngExt, Data.Bind.Components, Data.Bind.Grid,
  Data.Bind.DBScope, untCommonFormBaseSelecao, untCommonFormBase,
  MyAspFuncoesUteis, FMX.Controls.Presentation, System.ImageList, FMX.ImgList,
  FMX.Effects;

type
  TFrmSelecaoMotivoPausa = class(TFrmBaseSelecao)
    procedure FormResize(Sender: TObject);
  private

  public
    procedure ConfiguraLayoutMobile; //RAP 15/06/2016
  end;

function FrmSelecaoMotivoPausa(const aIDUnidade: integer; const aAllowNewInstance: Boolean = False; const aOwner: TComponent = nil): TFrmSelecaoMotivoPausa;


implementation

{$R *.fmx}

uses untCommonFormStyleBook;
{ %CLASSGROUP 'FMX.Controls.TControl' }


function FrmSelecaoMotivoPausa(const aIDUnidade: integer; const aAllowNewInstance: Boolean = False; const aOwner: TComponent = nil): TFrmSelecaoMotivoPausa;
begin
  Result := TFrmSelecaoMotivoPausa(TFrmSelecaoMotivoPausa.GetInstancia(aIDUnidade, aAllowNewInstance, aOwner));
end;

{ TFrmSelecaoMotivoPausa }

procedure TFrmSelecaoMotivoPausa.FormResize(Sender: TObject);
begin
  inherited;
  {$IFDEF ANDROID} //RAP 15/06/2016 //***IOS
    ConfiguraLayoutMobile;
  {$ENDIF ENDIF}
end;

procedure TFrmSelecaoMotivoPausa.ConfiguraLayoutMobile; //RAP 15/06/2016
begin
  recCaption.Height := 75;
  self.lblCaption.TextSettings.Font.Size := 42;

  lblSubTitulo.Height := 34;
  lblSubTitulo.TextSettings.Font.Size := 28;
end;

end.


