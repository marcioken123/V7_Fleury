unit untCommonFormSelecaoPP;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  {$IFNDEF IS_MOBILE}
  Windows, Messages, ScktComp,
  {$ENDIF}
  FMX.Grid, FMX.Controls, FMX.Forms, FMX.Graphics,
  FMX.Dialogs, FMX.StdCtrls, FMX.ExtCtrls, FMX.Types, FMX.Layouts, FMX.ListView.Types,
  FMX.ListView, FMX.ListBox,
   Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors, FMX.Objects, FMX.Edit, FMX.TabControl,
  System.UITypes, System.Types, System.SysUtils, System.Classes, System.Variants, Data.DB, System.Rtti,
  Data.Bind.EngExt, Data.Bind.Components,
  Data.Bind.Grid, Data.Bind.DBScope,MyAspFuncoesUteis,
  untCommonFormBaseSelecao, untCommonFormBase,
  FMX.Controls.Presentation, System.ImageList, FMX.ImgList, FMX.Effects;

type
  TFrmSelecaoPP = class(TFrmBaseSelecao)
  private
    //private statements
  public
    function Incluir(const ID: Integer; const Nome: string; const aIndex: Integer = -1): Boolean; Override;
  end;

function FrmSelecaoPP(const aIDUnidade: integer; const aAllowNewInstance: Boolean = False; const aOwner: TComponent = nil): TFrmSelecaoPP;

implementation

{$R *.fmx}

uses untCommonFormStyleBook;
{ %CLASSGROUP 'FMX.Controls.TControl' }

function FrmSelecaoPP(const aIDUnidade: integer; const aAllowNewInstance: Boolean = False; const aOwner: TComponent = nil): TFrmSelecaoPP;
begin
  Result := TFrmSelecaoPP(TFrmSelecaoPP.GetInstancia(aIDUnidade, aAllowNewInstance, aOwner));
end;

{ TFrmSelecaoPP }

function TFrmSelecaoPP.Incluir(const ID: Integer; const Nome: string; const aIndex: Integer): Boolean;
begin
  Result := inherited Incluir(ID, Nome, aIndex);
end;

end.

