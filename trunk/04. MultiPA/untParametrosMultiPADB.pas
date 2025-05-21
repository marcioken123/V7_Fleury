unit untParametrosMultiPADB;

interface
uses
  System.Generics.Collections, SysUtils, System.Types, Classes, IniFiles, Datasnap.DBClient, ClassLibrary, System.Generics.defaults,
  {$IFDEF FIREMONKEY}
  FMX.Types, FMX.StdCtrls, AspPanel,  AspLabelFMX, AspGroupBox,  AspButton,
  {$ENDIF}
  untParametroBaseDB,System.UITypes, untParametroPADB, Aspect, System.IOUtils, AspComponenteUnidade, AspFuncoesUteis;

{$INCLUDE ..\AspDefineDiretivas.inc}
type
  {$IFDEF CompilarPara_MULTIPA}
  TParametrosModuloMPADB = class(TParametrosModuloBase_PA_MPADB)
  public
    TempoLimparPA: Integer;
    ColunasPAs: Integer;
    procedure SetValoresDefault; Override;
  end;
  {$ENDIF CompilarPara_MULTIPA}
implementation

{$IFDEF CompilarPara_MULTIPA}
procedure TParametrosModuloMPADB.SetValoresDefault;
begin
  inherited;
  TempoLimparPA := 0;
  ColunasPAs := 0;
end;
{$ENDIF CompilarPara_MULTIPA}
end.