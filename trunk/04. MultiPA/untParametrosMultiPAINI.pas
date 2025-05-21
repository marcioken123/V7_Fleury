unit untParametrosMultiPAINI;

interface
uses
  System.Generics.Collections, SysUtils, System.Types, Classes, IniFiles, Datasnap.DBClient, ClassLibrary, System.Generics.defaults,
  {$IFDEF FIREMONKEY}
  FMX.Types, FMX.StdCtrls, AspPanel,  AspLabelFMX, AspGroupBox,  AspButton,
  {$ENDIF}
  untParametroBaseINI, System.UITypes, Aspect,untParametroPAINI, System.IOUtils, AspComponenteUnidade, AspFuncoesUteis;

{$INCLUDE ..\AspDefineDiretivas.inc}
type
  {$IFDEF CompilarPara_MULTIPA}
  TParametrosModuloMPAIni = class(TParametrosModuloBase_PA_MPAINI)
  public
    OcultarPADeslogada: Boolean;
    OcultarPASemEspera: Boolean;
    OcultarPASemAtendimento: Boolean;
    procedure CarregarOuSalvarParametrosPorIni(const aSalvar: Boolean); Override;
    procedure SetValoresDefault; Override;
  end;
  {$ENDIF CompilarPara_MULTIPA}
implementation

uses Sics_Common_Parametros;
{$IFDEF CompilarPara_MULTIPA}
{ TParametrosModuloMPA }

procedure TParametrosModuloMPAIni.CarregarOuSalvarParametrosPorIni(const aSalvar: Boolean);
begin
  inherited;

  OcultarPADeslogada := WriteOrReadSettings(aSalvar, cSettings, 'OcultarPADeslogada', OcultarPADeslogada);
  OcultarPASemEspera := WriteOrReadSettings(aSalvar, cSettings, 'OcultarPASemEspera', OcultarPASemEspera);
  OcultarPASemAtendimento := WriteOrReadSettings(aSalvar, cSettings, 'OcultarPASemAtendimento', OcultarPASemAtendimento);
end;

procedure TParametrosModuloMPAIni.SetValoresDefault;
begin
  inherited;
  OcultarPADeslogada := False;
  OcultarPASemEspera := False;
  OcultarPASemAtendimento := False;

  {$IFDEF IS_MOBILE}
  TamanhoBotoesAltura := 20;
  TamanhoBotoesLargura := 50;
  TamanhoFonteBotoes := 14;
  {$ELSE}
  TamanhoBotoesAltura := 20;
  TamanhoBotoesLargura := 50;
  TamanhoFonteBotoes := 12;
  {$ENDIF IS_MOBILE}
end;
{$ENDIF CompilarPara_MULTIPA}
end.