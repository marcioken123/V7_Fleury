unit untParametrosTGSINI;

interface
{$INCLUDE ..\AspDefineDiretivas.inc}
uses
  System.Generics.Collections, SysUtils, System.Types, Classes, IniFiles, Datasnap.DBClient, ClassLibrary, System.Generics.defaults,
  {$IFDEF FIREMONKEY}
  FMX.Types, FMX.StdCtrls, AspPanel,  AspLabelFMX, AspGroupBox,  AspButton,
  {$ENDIF}
  untParametroBaseINI, System.UITypes, Aspect, System.IOUtils, AspComponenteUnidade, AspFuncoesUteis;

type
  {$IFDEF CompilarPara_TGS}
  
  TParametrosDebugIni = class(TParametrosModuloIniBase)
  public
    ModoDebug, LogSocket, LogVerifcaFilaNaOrdemDasFilas: Boolean;
    NivelDebug: Integer;
    DebugFileName: String;
    constructor Create(aOwner: TComponent); Override;
    procedure SetValoresDefault; Override;
    procedure CarregarOuSalvarParametrosPorIni(const aSalvar: Boolean); Override;
  end;

  {$ENDIF CompilarPara_TGS}
  
  {$IF Defined(CompilarPara_TGS) or Defined(CompilarPara_ONLINE)}
  TParametrosModuloTGS_ONLINEINI = class(TParametrosModuloBaseConfigIni)
  public
    IndexUltimoFrameAtivo: Integer;
    IDUltimaUnidadeAtiva: Integer;
    Unidade: String;
    Unidades: TListaUnidades;
    BaseDeDados: String;
    {$IFDEF CompilarPara_TGS}
    IndexMenuItensExpandidos: TIntegerDynArray;
    BaseDeDadosRelatorios: String;
    ModoOffline: Boolean;
    {$ENDIF CompilarPara_TGS}

    function GetBaseDeDadosRelatorios: String;
    constructor Create(aOwner: TComponent); Override;
    destructor Destroy; Override;
    procedure SetValoresDefault; Override;
    procedure CarregarOuSalvarParametrosPorIni(const aSalvar: Boolean); Override;
  end;
  {$ENDIF}

  {$IFDEF CompilarPara_TGS}
  TParametrosModuloTGSIni = class(TParametrosModuloTGS_ONLINEINI)
  public
    Debug: TParametrosDebugIni;
    DirXmlWS: String;
    MasterDebug: Boolean;
    EmailsDeMonitoramentoConexaoEquipamentos: String;
    EmailsDeMonitoramentoFaltaPapel: String;
    PathGBak: String;

    constructor Create(aOwner: TComponent); Override;
    destructor Destroy; Override;
    procedure SetValoresDefault; Override;
    procedure CarregarOuSalvarParametrosPorIni(const aSalvar: Boolean); Override;
  end;
{$ENDIF CompilarPara_TGS}
implementation
uses Sics_Common_Parametros;

{$IFDEF CompilarPara_TGS}
{ TParametrosModuloTGS }

procedure TParametrosModuloTGSIni.SetValoresDefault;
begin
  inherited;
  Debug.SetValoresDefault;

  DirXmlWS := SettingsPathName + 'XML\';
  MasterDebug := False;
  EmailsDeMonitoramentoConexaoEquipamentos := 'suporte_sw@aspect.com.br';
  EmailsDeMonitoramentoFaltaPapel := EmailsDeMonitoramentoConexaoEquipamentos;
  {$IFNDEF IS_MOBILE}
  PathGBak := GetProgramFilesDir + '\Firebird\Firebird_2_0\bin\gbak.exe';
  {$ELSE}
  PathGBak := '';
  {$ENDIF IS_MOBILE}
end;

constructor TParametrosModuloTGSIni.Create(aOwner: TComponent);
begin
  inherited;
  Debug := TParametrosDebugIni.Create(Self);
end;

destructor TParametrosModuloTGSIni.Destroy;
begin
  FreeAndNil(Debug);
  inherited;
end;

procedure TParametrosModuloTGSIni.CarregarOuSalvarParametrosPorIni(const aSalvar: Boolean);
begin
  inherited;
  DirXmlWS := IncludeTrailingPathDelimiter(WriteOrReadSettings(aSalvar, cSettings,'DirXmlWS', DirXmlWS));

  MasterDebug := WriteOrReadSettings(aSalvar, cSettings, 'MasterDebug', MasterDebug);
  EmailsDeMonitoramentoConexaoEquipamentos := WriteOrReadSettings(aSalvar, 'EmailsDeMonitoramento', 'ConexaoEquipamentos', EmailsDeMonitoramentoConexaoEquipamentos);
  EmailsDeMonitoramentoFaltaPapel          := WriteOrReadSettings(aSalvar, 'EmailsDeMonitoramento', 'FaltaPapel', EmailsDeMonitoramentoFaltaPapel);
  PathGBak := WriteOrReadSettings(aSalvar, cSettings, 'PathGBak', PathGBak);


end;

{ TParametrosDebugIni }

procedure TParametrosDebugIni.CarregarOuSalvarParametrosPorIni(const aSalvar: Boolean);
begin
  ModoDebug                     := WriteOrReadSettings(aSalvar, 'DEBUG', 'ModoDebug', ModoDebug);
  LogSocket                     := WriteOrReadSettings(aSalvar, 'DEBUG', 'LogSocket', LogSocket);
  LogVerifcaFilaNaOrdemDasFilas := WriteOrReadSettings(aSalvar, 'DEBUG', 'LogVerifcaFilaNaOrdemDasFilas' , LogVerifcaFilaNaOrdemDasFilas);
  NivelDebug                    := WriteOrReadSettings(aSalvar, 'DEBUG', 'NivelDebug', NivelDebug);
  DebugFileName                 := WriteOrReadSettings(aSalvar, 'DEBUG', 'DebugFileName', DebugFileName);
end;

constructor TParametrosDebugIni.Create(aOwner: TComponent);
begin
  inherited;

end;

procedure TParametrosDebugIni.SetValoresDefault;
begin
  inherited;

  ModoDebug                     := False;
  LogSocket                     := False;
  LogVerifcaFilaNaOrdemDasFilas := False;
  NivelDebug                    := 2;
  DebugFileName                 := ApplicationPath + '\DEBUG.LOG';
end;
{$ENDIF CompilarPara_TGS}


{$IF Defined(CompilarPara_TGS) or Defined(CompilarPara_ONLINE)}
{ TParametrosModuloTGS_ONLINEINI }

procedure TParametrosModuloTGS_ONLINEINI.CarregarOuSalvarParametrosPorIni(const aSalvar: Boolean);
{$IFDEF CompilarPara_TGS}
var
  LStrIndexMenuItensExpandidos: String;
{$ENDIF CompilarPara_TGS}
begin
  inherited;
  IndexUltimoFrameAtivo := WriteOrReadSettings(aSalvar, cSettings, 'IndexUltimoFrameAtivo', IndexUltimoFrameAtivo);
  IDUltimaUnidadeAtiva := WriteOrReadSettings(aSalvar, cSettings, 'IDUltimaUnidadeAtiva', IDUltimaUnidadeAtiva);
  Unidade := WriteOrReadSettings(aSalvar, cSettings, 'Unidade', Unidade);
  Unidades.CarregarOuSalvarParametrosPorIni(aSalvar);
  BaseDeDados := WriteOrReadSettings(aSalvar, cSettings, 'BaseDeDados', BaseDeDados);

  {$IFDEF CompilarPara_TGS}
  LStrIndexMenuItensExpandidos := '';
  IntArrayToStr(IndexMenuItensExpandidos,LStrIndexMenuItensExpandidos, False);
  StrToIntArray(WriteOrReadSettings(aSalvar, cSettings, 'IndexMenuItensExpandidos', LStrIndexMenuItensExpandidos), IndexMenuItensExpandidos, False);
  ModoOffline := WriteOrReadSettings(aSalvar, cSettings, 'ModoOffline', ModoOffline);
  BaseDeDadosRelatorios := WriteOrReadSettings(aSalvar, cSettings, 'BaseDeDadosRelatorios', BaseDeDadosRelatorios);
  {$ENDIF CompilarPara_TGS}
end;

constructor TParametrosModuloTGS_ONLINEINI.Create(aOwner: TComponent);
begin
  inherited;
  Unidades := TListaUnidades.Create(Self);

end;

function TParametrosModuloTGS_ONLINEINI.GetBaseDeDadosRelatorios: String;
begin
{$IFDEF CompilarPara_TGS}
  if (ParametrosModuloIni.ModoOffline) then
    Result := ParametrosModuloIni.BaseDeDadosRelatorios
  else
{$ENDIF CompilarPara_TGS}
    Result := ParametrosModuloIni.BaseDeDados;
end;

destructor TParametrosModuloTGS_ONLINEINI.Destroy;
begin
  FreeAndNil(Unidades);
  inherited;
end;

procedure TParametrosModuloTGS_ONLINEINI.SetValoresDefault;
begin
  inherited;
  Unidades.Clear;
  BaseDeDados := IP_DEFAULT + ':' + ApplicationPath + 'DbaseV5\SICSBASEv5.FDB';
  {$IFDEF CompilarPara_TGS}
  SetLength(IndexMenuItensExpandidos, 0);
  ModoOffline := False;
  BaseDeDadosRelatorios := IP_DEFAULT + ':' + ApplicationPath + 'DbaseV5\SICSBASEv5.FDB';
  {$ENDIF CompilarPara_TGS}
  Unidade := 'Principal';
  IndexUltimoFrameAtivo := -1;
  IDUltimaUnidadeAtiva := ID_UNIDADE_PRINCIPAL;

end;
{$ENDIF}
end.