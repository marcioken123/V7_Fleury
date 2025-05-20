object PushNotificationServer: TPushNotificationServer
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 152
  Width = 197
  object BackendPush: TBackendPush
    Provider = EMSProvider
    Extras = <>
    Left = 112
    Top = 80
  end
  object EMSProvider: TEMSProvider
    AndroidPush.GCMAppID = '791785988148'
    ApiVersion = '1'
    ApplicationId = 'pushNotificationsAppID'
    AppSecret = 'pushNotificationsAppSecret'
    MasterSecret = 'pushNotificationsMasterSecret'
    URLHost = '192.168.0.245'
    URLPort = 8080
    Left = 48
    Top = 32
  end
  object KinveyProvider: TKinveyProvider
    ApiVersion = '3'
    Left = 128
    Top = 24
  end
end
