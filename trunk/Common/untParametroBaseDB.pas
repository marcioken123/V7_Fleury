unit untParametroBaseDB;

{$INCLUDE ..\AspDefineDiretivas.inc}
interface
uses
  System.Generics.Collections, SysUtils, System.Types, Classes, IniFiles, Datasnap.DBClient, System.Generics.defaults,
  {$IFDEF FIREMONKEY}
  FMX.Types, FMX.StdCtrls, AspPanel, AspLabelFMX, AspGroupBox,  AspButton,
  {$ENDIF}

  {$IFDEF SuportaDLL}MyDlls_DX,  ClassLibraryVCL, AspectVCL, {$ELSE}ClassLibrary, Aspect, AspComponenteUnidade, {$ENDIF SuportaDLL}
  System.UITypes, System.IOUtils, AspFuncoesUteis;

type

  TParametrosModuloBaseConfigDB = class(TParametrosModuloBase)
    protected
      procedure SetConfiguradoParametrosModulo(const Value: Boolean); Override;
  public
    constructor Create(aOwner: TComponent); Override;
    destructor Destroy; Override;
    procedure SetValoresDefault; Override;
  end;

  TParametrosModuloDBBase = class(TParametrosModuloBaseConfigDB)
  public
    GruposDeAtendentesPermitidos: TIntegerDynArray;
    Id: Integer;
    PodeFecharPrograma: Boolean;
    GruposDePasPermitidas: TIntegerDynArray;
    NomeModulo: String;
    FilasPermitidas: TIntegerDynArray;
    procedure SetValoresDefault; Override;
  end;

  {$IF Defined(CompilarPara_TGS) or Defined(CompilarPara_PA_MULTIPA)}
  TParametrosModuloBase_PA_MPA_TGSDB = class(TParametrosModuloDBBase)
  public
    {$IFDEF CompilarPara_PA_MULTIPA}
    UseCodebar: Boolean;
    {$ENDIF CompilarPara_PA_MULTIPA}

    {$IFNDEF CompilarPara_ONLINE}
    GruposdePPsPermitidos: TIntegerDynArray;
    GruposdeTagsPermitidos: TIntegerDynArray;
    MinimizarParaBandeja: Boolean;
    VisualizarProcessosParalelos: Boolean;
    {$ENDIF CompilarPara_ONLINE}

    procedure SetValoresDefault; Override;
  end;
  {$ENDIF}
implementation


constructor TParametrosModuloBaseConfigDB.Create(aOwner: TComponent);
begin
  inherited;
end;

destructor TParametrosModuloBaseConfigDB.Destroy;
begin

  inherited;
end;


procedure TParametrosModuloBaseConfigDB.SetConfiguradoParametrosModulo(const Value: Boolean);
begin
  if (ConfiguradoParametrosModulo = Value) then
    Exit;
  inherited;

  {$IFNDEF SuportaDLL}
  if Value then
    FListaFormComponentesDesabilitados.CarregarParametrosDBForAll;
  {$ENDIF SuportaDLL}
end;

procedure TParametrosModuloBaseConfigDB.SetValoresDefault;
begin
  inherited;
  ConfiguradoParametrosModulo := False;
end;


procedure TParametrosModuloDBBase.SetValoresDefault;
begin
  inherited;
  SetLength(GruposDeAtendentesPermitidos, 0);
  Id := 0;
  PodeFecharPrograma := True;
  NomeModulo := '';
  SetLength(GruposDePasPermitidas, 0);
  SetLength(FilasPermitidas, 0);
end;

{$IF Defined(CompilarPara_TGS) or Defined(CompilarPara_PA_MULTIPA)}
{ TParametrosModuloBase_PA_MPA_TGS }

procedure TParametrosModuloBase_PA_MPA_TGSDB.SetValoresDefault;
begin
  inherited;
  {$IFDEF CompilarPara_PA_MULTIPA}
  UseCodebar := False;
  {$ENDIF CompilarPara_PA_MULTIPA}

  {$IFNDEF CompilarPara_ONLINE}
  SetLength(GruposdePPsPermitidos, 0);
  SetLength(GruposdeTagsPermitidos, 0);
  MinimizarParaBandeja := False;
  VisualizarProcessosParalelos := False;
  {$ENDIF CompilarPara_TGS}
end;
{$ENDIF}

end.

