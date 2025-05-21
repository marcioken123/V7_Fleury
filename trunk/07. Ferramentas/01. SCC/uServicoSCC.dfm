object srvSCCApp: TsrvSCCApp
  OldCreateOrder = False
  OnCreate = ServiceCreate
  OnDestroy = ServiceDestroy
  AllowPause = False
  Dependencies = <
    item
      Name = 'FirebirdServerDefaultInstance'
      IsGroup = False
    end>
  DisplayName = 'SCC Service Application'
  BeforeInstall = ServiceBeforeInstall
  AfterInstall = ServiceAfterInstall
  BeforeUninstall = ServiceBeforeUninstall
  OnExecute = ServiceExecute
  OnStart = ServiceStart
  OnStop = ServiceStop
  Height = 150
  Width = 215
end
