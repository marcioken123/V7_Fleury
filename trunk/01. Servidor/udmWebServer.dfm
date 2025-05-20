object dmSicsWebServer: TdmSicsWebServer
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 412
  Width = 477
  object IdHTTPServer1: TIdHTTPServer
    Bindings = <>
    Left = 168
    Top = 96
  end
  object TimerIniciarServer: TTimer
    OnTimer = TimerIniciarServerTimer
    Left = 80
    Top = 96
  end
  object ppGlobal: TPageProducer
    Left = 176
    Top = 168
  end
end
