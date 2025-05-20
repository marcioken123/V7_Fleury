unit untCommonFormSelecaoGrupoAtendente;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  untCommonFormBaseSelecao, Data.Bind.EngExt, Fmx.Bind.DBEngExt,
  System.ImageList, FMX.ImgList, Data.Bind.Components, FMX.Layouts,
  FMX.ListBox, FMX.Effects, FMX.Objects, FMX.Controls.Presentation;

type
  TFrmSelecaoGrupoAtendente = class(TFrmBaseSelecao)
  private
    { Private declarations }
  public
    { Public declarations }
  end;
 function FrmSelecaoGrupoAtendente(const aIDUnidade: integer; const aAllowNewInstance: Boolean = False; const aOwner: TComponent = nil): TfrmSelecaoGrupoAtendente;


implementation

{$R *.fmx}
uses untCommonFormStyleBook;

{ %CLASSGROUP 'FMX.Controls.TControl' }

function FrmSelecaoGrupoAtendente(const aIDUnidade: integer; const aAllowNewInstance: Boolean = False; const aOwner: TComponent = nil): TfrmSelecaoGrupoAtendente;
begin
  Result := TFrmSelecaoGrupoAtendente(TFrmSelecaoGrupoAtendente.GetInstancia(aIDUnidade, aAllowNewInstance, aOwner));
end;

end.
