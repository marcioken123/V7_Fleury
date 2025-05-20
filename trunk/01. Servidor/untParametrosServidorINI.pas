unit untParametrosServidorINI;

interface
uses
  System.Generics.Collections, SysUtils, System.Types, Classes, IniFiles, Datasnap.DBClient, System.Generics.defaults,
  {$IFDEF FIREMONKEY}
  FMX.Types, FMX.StdCtrls, AspPanel, AspLabelFMX, AspGroupBox,  AspButton,
  {$ENDIF}
  untParametroBaseINI, System.UITypes, System.IOUtils, AspFuncoesUteis;

{$INCLUDE ..\AspDefineDiretivas.inc}
type
  {$IF Defined(CompilarPara_SICS) or Defined(CompilarPara_CONFIG)}
  TParametrosModuloBaseSICSOnline = class(TParametrosModuloBaseConfigIni)
  public
    WebserverAtivo: Boolean;
    ReportarTemposMaximos: Boolean;
    ExportarGrafico: Boolean;
    BaseDeDados: String;
    Unidade: String;
    MasterDebug: Boolean;
    DirXmlWS: String;
    EmailsDeMonitoramentoConexaoEquipamentos: String;
    EmailsDeMonitoramentoFaltaPapel: String;
    PathGBak: String;
    Unidades: TListaUnidades;
    WebserverPort: Integer;
    SmtpNomeRemetente: String;
    SmtpEmailRemetente: String;
    TimeOutPA: Integer;

    procedure SetValoresDefault; Override;
    constructor Create(aOwner: TComponent); Override;
    destructor Destroy; Override;
    procedure CarregarOuSalvarParametrosPorIni(const aSalvar: Boolean); Override;
  end;
  {$ENDIF}
  {$IFDEF CompilarPara_SICS}
  TParametrosModuloSICS = TParametrosModuloBaseSICSOnline;
  {$ENDIF CompilarPara_SICS}
implementation
uses
  MyDlls_DX,  ClassLibraryVCL, AspectVCL, 
  Sics_Common_Parametros3;

{ TParametrosModuloSICS }

destructor TParametrosModuloBaseSICSOnline.Destroy;
begin
  FreeAndNil(Unidades);
  inherited;
end;
constructor TParametrosModuloBaseSICSOnline.Create(aOwner: TComponent);
begin
  inherited;
  Unidades := TListaUnidades.Create(Self);

end;
procedure TParametrosModuloBaseSICSOnline.SetValoresDefault;
begin
  inherited;
  Unidades.Clear;
  ExportarGrafico := True;
  ReportarTemposMaximos := False;
  MasterDebug := False;
  Unidade := '';
  DirXmlWS := SettingsPathName + 'XML\';
  EmailsDeMonitoramentoConexaoEquipamentos := 'suporte_sw@aspect.com.br';
  EmailsDeMonitoramentoFaltaPapel := EmailsDeMonitoramentoConexaoEquipamentos;
  {$IFNDEF IS_MOBILE}
  PathGBak := GetProgramFilesDir + '\Firebird\Firebird_2_0\bin\gbak.exe';
  {$ENDIF IS_MOBILE}
  WebserverPort := 80;
  WebserverAtivo := False;
  SmtpNomeRemetente := '';
  SmtpEmailRemetente := '';
  BaseDeDados := IP_DEFAULT + ':' + GetApplicationPath + '\DbaseV5\SICSBASEv5.FDB';
  TimeOutPA := 0;
end;

procedure TParametrosModuloBaseSICSOnline.CarregarOuSalvarParametrosPorIni(const aSalvar: Boolean);
begin
  inherited;
  BaseDeDados := WriteOrReadSettings(aSalvar, cSettings, 'BaseDeDados', BaseDeDados);

  WebserverAtivo := WriteOrReadSettings(aSalvar, 'WebServer', 'Ativo', WebserverAtivo);

  ReportarTemposMaximos := WriteOrReadSettings(aSalvar, cSettings, 'ReportarTemposMaximos', ReportarTemposMaximos);
  ExportarGrafico := WriteOrReadSettings(aSalvar, cSettings, 'ExportarGrafico', ExportarGrafico);

  Unidade := WriteOrReadSettings(aSalvar, cSettings, 'Unidade', Unidade);
  MasterDebug := WriteOrReadSettings(aSalvar, cSettings, 'MasterDebug', MasterDebug);
  DirXmlWS := IncludeTrailingPathDelimiter(WriteOrReadSettings(aSalvar, cSettings,'DirXmlWS', DirXmlWS));

  EmailsDeMonitoramentoConexaoEquipamentos := WriteOrReadSettings(aSalvar, 'EmailsDeMonitoramento', 'ConexaoEquipamentos', EmailsDeMonitoramentoConexaoEquipamentos);
  EmailsDeMonitoramentoFaltaPapel          := WriteOrReadSettings(aSalvar, 'EmailsDeMonitoramento', 'FaltaPapel', EmailsDeMonitoramentoFaltaPapel);
  PathGBak := WriteOrReadSettings(aSalvar, cSettings, 'PathGBak', PathGBak);

  WebserverPort := WriteOrReadSettings(aSalvar, 'WebServer', 'Port', WebserverPort);
  TimeOutPA := WriteOrReadSettings(aSalvar, cSettings, 'TimeOutPA', TimeOutPA);
  SmtpNomeRemetente := WriteOrReadSettings(aSalvar, 'SMTP', 'SMTPNomeRemetente', SmtpNomeRemetente);
  SmtpEmailRemetente := WriteOrReadSettings(aSalvar, 'SMTP', 'SMTPEmailRemetente', SmtpEmailRemetente);


  Unidades.CarregarOuSalvarParametrosPorIni(aSalvar);
end;
{$ENDIF}
end.
