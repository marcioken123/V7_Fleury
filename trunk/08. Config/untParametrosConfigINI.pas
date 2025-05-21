unit untParametrosConfigINI;

interface
{$INCLUDE ..\AspDefineDiretivas.inc}
uses
  untParametrosServidorINI;

type
  {$IFDEF CompilarPara_CONFIG}
  TParametrosModuloConfig = TParametrosModuloBaseSICSOnline;
  {$ENDIF CompilarPara_CONFIG}
implementation

end.