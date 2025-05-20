unit ufrmCadBase;

interface
{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  {$IFNDEF IS_MOBILE}
  Windows, Messages, ScktComp,
  {$ENDIF}

  Fmx.Bind.DBEngExt, Fmx.Bind.Grid, Fmx.Bind.Editors, FMX.Layouts, AspLayout, FMX.Grid, FMX.Types,
  FMX.Controls, FMX.StdCtrls,
  FMX.Forms, FMX.Graphics,
  FMX.Dialogs, FMX.ExtCtrls, FMX.ListView.Types,
  FMX.ListView, FMX.ListBox,
  FMX.Objects, FMX.Edit, FMX.TabControl,

  System.UIConsts, System.Generics.Defaults, System.Generics.Collections,
  System.UITypes, System.Types, System.SysUtils, System.Classes, System.Variants, Data.DB, Datasnap.DBClient, System.Rtti, 
  Data.Bind.EngExt, Data.Bind.Components,
  Data.Bind.Grid, Data.Bind.DBScope, udmCadBase,
  System.Bindings.Outputs;

type
  TfrmSicsCadBase = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  protected
    function GetClassDM: TClassdmSicsCadBase; Virtual; abstract;
  public
    dmSicsCadBase: TdmSicsCadBase;
    procedure Inicializar(const IdUnidade: Integer); Virtual;
    {$IFNDEF NEXTGEN}
    class function ExibeForm(var IdUnidade: Integer): Boolean;
    {$ENDIF NEXTGEN}

    { Public declarations }
  end;

implementation

uses

{$IFNDEF CompilarPara_TGS}
  udmContingencia,
untCommonDMClient,
{$ENDIF CompilarPara_TGS}
sics_94,
  udmCadHor, Aspect, AspFMXHelper, ClassLibrary;

{$R *.fmx}
{ %CLASSGROUP 'FMX.Controls.TControl' }

{$IFNDEF NEXTGEN}
class function TfrmSicsCadBase.ExibeForm(var IdUnidade: Integer): Boolean;
begin
  IdUnidade := dmSicsMain.CheckPromptUnidade;

	with Self.Create(GetApplication) do
  try
    Inicializar(IdUnidade);

  	Result := ShowModal = mrOk;
  finally
  	Free;
  end;
end;
{$ENDIF NEXTGEN}

procedure TfrmSicsCadBase.FormCreate(Sender: TObject);
begin
  inherited;
  dmSicsCadBase := nil;
  aspect.LoadPosition(Sender as TForm);
end;

procedure TfrmSicsCadBase.FormDestroy(Sender: TObject);
begin
  FreeAndNil(dmSicsCadBase);
  aspect.SavePosition(Sender as TForm);
  inherited;
end;

procedure TfrmSicsCadBase.Inicializar(const IdUnidade: Integer);
begin
  if not Assigned(dmSicsCadBase) then
    dmSicsCadBase := GetClassDM.Create(nil);
  dmSicsCadBase.Inicializar(IdUnidade);
end;

end.

