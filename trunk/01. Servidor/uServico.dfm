object srvSicsApp: TsrvSicsApp
  OldCreateOrder = False
  OnCreate = ServiceCreate
  OnDestroy = ServiceDestroy
  AllowPause = False
  Dependencies = <
    item
      Name = 'FirebirdServerDefaultInstance'
      IsGroup = False
    end>
  DisplayName = 'SICS Service Application'
  Interactive = True
  BeforeInstall = ServiceBeforeInstall
  AfterInstall = ServiceAfterInstall
  BeforeUninstall = ServiceBeforeUninstall
  OnExecute = ServiceExecute
  OnStart = ServiceStart
  OnStop = ServiceStop
  Height = 150
  Width = 215
end
