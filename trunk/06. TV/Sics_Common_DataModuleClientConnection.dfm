object dmSicsClientConnection: TdmSicsClientConnection
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 251
  Width = 321
  object ClientSocketPrincipal: TASPClientSocket
    Active = False
    ClientType = ctNonBlocking
    Port = 6501
    OnConnect = ClientSocketConnect
    OnDisconnect = ClientSocketDisconnect
    OnRead = ClientSocketRead
    OnError = ClientSocketError
    Left = 80
    Top = 16
  end
  object ClientSocketContingente: TASPClientSocket
    Active = False
    ClientType = ctNonBlocking
    Port = 6501
    OnConnect = ClientSocketConnect
    OnDisconnect = ClientSocketDisconnect
    OnRead = ClientSocketRead
    OnError = ClientSocketError
    Left = 72
    Top = 64
  end
  object ReconnectTimer: TTimer
    OnTimer = ReconnectTimerTimer
    Left = 74
    Top = 127
  end
  object CodeBarPort: TVaComm
    Baudrate = br9600
    FlowControl.OutCtsFlow = False
    FlowControl.OutDsrFlow = False
    FlowControl.ControlDtr = dtrDisabled
    FlowControl.ControlRts = rtsDisabled
    FlowControl.XonXoffOut = False
    FlowControl.XonXoffIn = False
    FlowControl.DsrSensitivity = False
    FlowControl.TxContinueOnXoff = False
    DeviceName = 'COM%d'
    MonitorEvents = [ceError, ceRxChar]
    OnRxChar = CodeBarPortRxChar
    Version = '1.8.0.0'
    Left = 186
    Top = 16
  end
end
