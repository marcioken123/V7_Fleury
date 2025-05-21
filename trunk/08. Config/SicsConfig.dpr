program SicsConfig;


{$INCLUDE ..\AspDefineDiretivas.inc}
uses
  Sharemem,
  MidasLib,
  VCL.Forms,
  SysUtils,
  SvcMgr,
  WinSvc,
  Classes,
  Windows,
  IniFiles,
  MyDlls_DR,
  cfgGenerica in '..\01. Servidor\cfgGenerica.pas' {frmSicsConfiguraTabela},
  sics_94 in '..\01. Servidor\sics_94.pas' {dmSicsMain: TDataModule},
  Sics_92 in '..\01. Servidor\Sics_92.pas' {frmSicsGerarNovaSenhaOuUtilizarUltima},
  Sics_91 in '..\01. Servidor\Sics_91.pas',
  uqrCfgGenerica in '..\01. Servidor\uqrCfgGenerica.pas' {qrSicsCfgGenerica: TQuickRep},
  ufrmCadTotens in '..\01. Servidor\ufrmCadTotens.pas' {frmSicsCadTotens},
  udmCadTotens in '..\01. Servidor\udmCadTotens.pas' {dmSicsCadTotens: TDataModule},
  uSelecaoGrupos in '..\01. Servidor\uSelecaoGrupos.pas' {FrmSelecaoGrupos},
  uFrmConfiguracoesSicsMultiPA in '..\01. Servidor\uFrmConfiguracoesSicsMultiPA.pas' {FrmConfiguracoesSicsMultiPA},
  Vcl.Themes,
  Vcl.Styles,
  uFrmBaseConfiguracoesSics in '..\01. Servidor\uFrmBaseConfiguracoesSics.pas' {FrmBaseConfiguracoesSics},
  uFrmConfiguracoesSicsOnLine in '..\01. Servidor\uFrmConfiguracoesSicsOnLine.pas' {FrmConfiguracoesSicsOnLine},
  uFrmConfiguracoesSicsPA in '..\01. Servidor\uFrmConfiguracoesSicsPA.pas' {FrmConfiguracoesSicsPA},
  untCadastroUnidades in 'untCadastroUnidades.pas' {FrmCadastroUnidades},
  untMainForm in 'untMainForm.pas' {MainForm},
  uFrmConfiguracoesSicsTGS in '..\01. Servidor\uFrmConfiguracoesSicsTGS.pas' {FrmConfiguracoesSicsTGS},
  udmCadBase in '..\01. Servidor\udmCadBase.pas' {dmSicsCadBase: TDataModule},
  ufrmPingMonitor_DX in 'ufrmPingMonitor_DX.pas' {frmPingMonitor},
  repPrview in '..\01. Servidor\repPrview.pas' {frmSicsRepPreview},
  Sics_Common_Splash in '..\Common\Sics_Common_Splash.pas' {frmSicsSplash},
  untCaminhosUpdate in 'untCaminhosUpdate.pas' {frmCaminhosUpdate},
  MyAspFuncoesUteis_VCL in '..\Common\Library\MyAspFuncoesUteis_VCL.pas',
  untLog in '..\Common\Library\untLog.pas',
  uScriptUnidades in '..\Common\uScriptUnidades.pas',
  uFrmConfiguracoesSicsCallCenter in '..\01. Servidor\uFrmConfiguracoesSicsCallCenter.pas' {FrmConfiguracoesSicsCallCenter},
  UConexaoBD in '..\Common\UConexaoBD.pas',
  ASPGenerator in '..\..\..\..\00. Library\Common\Rio\ASPGenerator.pas',
  uCadastroGrupos in 'uCadastroGrupos.pas' {frmCadastroGrupos},
  uCadastroDevices in 'uCadastroDevices.pas' {frmCadastroDevices},
  ASPDbGrid in '..\..\..\..\00. Library\Components\DX Rio\Aspect\Source\ASPDbGrid\ASPDbGrid.pas',
  uDataSetHelper in '..\Common\uDataSetHelper.pas',
  uFrmConfiguracoesSicsTV in '..\01. Servidor\uFrmConfiguracoesSicsTV.pas' {FrmConfiguracoesSicsTV};

{$R *.RES}

begin
  with TIniFile.Create(GetAppIniFileName) do
  try
    vgParametrosModuloConfig.ArqUpdateDir     := ReadString ('Settings' , 'ArqUpdateDir'    , ''  );
    vgParametrosModuloConfig.DBDir            := ReadString ('Settings' , 'BaseDeDados'     , ''  );
    vgParametrosModuloConfig.DBHost           := ReadString ('Settings' , 'DBHost'          , ''  );
    vgParametrosModuloConfig.DBBanco          := ReadString ('Settings' , 'DBBanco'         , ''  );
    vgParametrosModuloConfig.DBUsuario        := ReadString ('Settings' , 'DBUsuario'       , ''  );
    vgParametrosModuloConfig.DBSenha          := ReadString ('Settings' , 'DBSenha'         , ''  );
    vgParametrosModuloConfig.DBOSAuthent      := ReadBool   ('Settings' , 'DBOSAuthent'     , True);
    vgParametrosModuloConfig.DiasDeviceOcioso := ReadInteger('Settings' , 'DiasDeviceOcioso', 7   );

    WriteString ('Settings' , 'ArqUpdateDir'    , vgParametrosModuloConfig.ArqUpdateDir    );
    WriteString ('Settings' , 'BaseDeDados'     , vgParametrosModuloConfig.DBDir           );
    WriteString ('Settings' , 'DBHost'          , vgParametrosModuloConfig.DBHost          );
    WriteString ('Settings' , 'DBBanco'         , vgParametrosModuloConfig.DBBanco         );
    WriteString ('Settings' , 'DBUsuario'       , vgParametrosModuloConfig.DBUsuario       );
    WriteString ('Settings' , 'DBSenha'         , vgParametrosModuloConfig.DBSenha         );
    WriteBool   ('Settings' , 'DBOSAuthent'     , vgParametrosModuloConfig.DBOSAuthent     );
    WriteInteger('Settings' , 'DiasDeviceOcioso', vgParametrosModuloConfig.DiasDeviceOcioso);
  finally
    Free;
  end; { try .. finaly }
  // Se for fazer update automatico falta criar o caminho do update
  // No cadastro de updates
  //AspUpd_ChecarEFazerUpdate(vgParametrosModulo.ArqUpdateDir);

  VCL.Forms.Application.Initialize;
  VCL.Forms.Application.Title := 'SICS Config';
  VCL.Forms.Application.OnException := TLog.MyException;
  VCL.Forms.Application.CreateForm(TMainForm, MainForm);
  VCL.Forms.Application.Run;
end.
