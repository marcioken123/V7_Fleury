unit ufrmCadBase;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  {$IFNDEF IS_MOBILE}
  Windows, Messages, ScktComp,
  {$ENDIF}

  {$IFDEF AplicacaoFiremokeySemVCL}
  Fmx.Bind.DBEngExt, Fmx.Bind.Grid, Fmx.Bind.Editors, FMX.Layouts, AspLayout, FMX.Grid, FMX.Types,
  FMX.Controls, FMX.StdCtrls,
  FMX.Forms, FMX.Graphics,
  FMX.Dialogs, FMX.ExtCtrls, FMX.ListView.Types,
  FMX.ListView, FMX.ListBox,
  FMX.Objects, FMX.Edit, FMX.TabControl,
  {$ELSE}
  VCL.Grids, VCL.Controls, VCL.Forms, VCL.Buttons,
  VCL.Dialogs, VCL.StdCtrls, VCL.ExtCtrls, VCL.Graphics,Vcl.Bind.DBEngExt,   Vcl.Bind.Grid, Vcl.Bind.Editors,
  {$ENDIF}

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
    class procedure ExibeForm;

    { Public declarations }
  end;

implementation

uses

sics_94,

{$IFNDEF CompilarPara_TGS}
  udmContingencia,
{$ENDIF}
  udmCadHor, MyDlls_DX,  ClassLibraryVCL, AspectVCL, {$ELSE}MyDlls_DX,  ClassLibrary, Aspect, AspFMXHelper, ClassLibrary;

{$IFDEF AplicacaoFiremokeySemVCL}
{$R *.fmx}
{ %CLASSGROUP 'FMX.Controls.TControl' }
{$ELSE}
{$R *.dfm}
{$ENDIF AplicacaoFiremokeySemVCL}

class procedure TfrmSicsCadBase.ExibeForm;
begin
  dmSicsMain.CheckPromptUnidade(
    procedure (IdUnidade: Integer)
    var
      LfrmSicsCadBase: TfrmSicsCadBase;
    begin
      LfrmSicsCadBase := Self.Create(Application);
      try
        LfrmSicsCadBase.Inicializar(IdUnidade);
        LfrmSicsCadBase.ShowModal(
          procedure (aModalResult: TModalResult)
          begin
            FreeAndNil(LfrmSicsCadBase);
          end);
      except
        FreeAndNil(LfrmSicsCadBase);
        raise;
      end;
    end);
end;

procedure TfrmSicsCadBase.FormCreate(Sender: TObject);
begin
  inherited;
  dmSicsCadBase := nil;
  LoadPosition(Sender as TForm);
end;

procedure TfrmSicsCadBase.FormDestroy(Sender: TObject);
begin
  FreeAndNil(dmSicsCadBase);
  SavePosition(Sender as TForm);
  inherited;
end;

procedure TfrmSicsCadBase.Inicializar(const IdUnidade: Integer);
begin
  if not Assigned(dmSicsCadBase) then
    dmSicsCadBase := GetClassDM.Create(nil);
  dmSicsCadBase.Inicializar(IdUnidade);
end;

end.

