object MainForm: TMainForm
  Left = 239
  Top = 131
  Caption = 'SICS Customiza'#231#227'o de Chamadas'
  ClientHeight = 214
  ClientWidth = 428
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object ledDataSourceAvailable: TLEDRLabel
    Left = 80
    Top = 168
    Width = 225
    Color = lcGreen
    OnChangeState = ledDataSourceAvailableChangeState
    Caption = 'Fonte de dados para interface dispon'#237'vel'
  end
  object ledPastaDestinoConfigurada: TLEDRLabel
    Left = 80
    Top = 192
    Width = 225
    Color = lcGreen
    OnChangeState = ledDataSourceAvailableChangeState
    Caption = 'Pasta de destino configurada'
  end
  object memoStatus: TMemo
    Left = 152
    Top = 8
    Width = 265
    Height = 81
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object gridMV: TDBGrid
    Left = 16
    Top = 8
    Width = 129
    Height = 129
    DataSource = dsMV
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
  end
  object tmrCheckInterface: TTimer
    OnTimer = tmrCheckInterfaceTimer
    Left = 56
    Top = 40
  end
  object PopUpMenu: TPopupMenu
    Left = 56
    Top = 96
    object menuRestaurar: TMenuItem
      Caption = 'R&estaurar'
      Default = True
      OnClick = TrayIconDblClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object menuSobre: TMenuItem
      Caption = '&Sobre...'
      OnClick = menuSobreClick
    end
    object menuSair: TMenuItem
      Caption = 'Sai&r'
      OnClick = menuSairClick
    end
  end
  object cdsMV: TClientDataSet
    Aggregates = <>
    Params = <>
    AfterPost = cdsMVAfterPost
    Left = 312
    Top = 224
    object cdsMVSala: TStringField
      Alignment = taCenter
      DisplayWidth = 4
      FieldName = 'Sala'
      Size = 2
    end
    object cdsMVIdPA: TIntegerField
      Alignment = taCenter
      DisplayLabel = 'Id PA SICS'
      FieldName = 'IdPA'
    end
  end
  object dsMV: TDataSource
    DataSet = cdsMV
    Left = 352
    Top = 224
  end
  object sktMV: TServerSocket
    Active = False
    Port = 0
    ServerType = stNonBlocking
    OnListen = sktMVListen
    OnClientConnect = sktMVClientConnect
    OnClientDisconnect = sktMVClientDisconnect
    OnClientRead = sktMVClientRead
    OnClientError = sktMVClientError
    Left = 392
    Top = 224
  end
  object TrayIcon: TTrayIcon
    PopupMenu = PopUpMenu
    OnClick = TrayIconClick
    OnDblClick = TrayIconDblClick
    Left = 280
    Top = 104
  end
  object TimerTentarCarregarParametrosUnidades: TTimer
    Enabled = False
    Interval = 30000
    OnTimer = TimerTentarCarregarParametrosUnidadesTimer
    Left = 312
    Top = 128
  end
  object IdServerInterceptLogFile: TIdServerInterceptLogFile
    Left = 488
    Top = 224
  end
  object tmrLog: TTimer
    OnTimer = tmrLogTimer
    Left = 368
    Top = 104
  end
end
