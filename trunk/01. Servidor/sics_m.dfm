object frmSicsMain: TfrmSicsMain
  Left = 2185
  Top = 239
  Width = 909
  Height = 502
  HorzScrollBar.Smooth = True
  HorzScrollBar.Tracking = True
  VertScrollBar.Smooth = True
  VertScrollBar.Tracking = True
  AutoScroll = True
  BorderIcons = [biSystemMenu, biMinimize, biMaximize, biHelp]
  Caption = 'SICS'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = True
  Position = poDefault
  OnClose = FormClose
  OnCreate = FormCreate
  OnMouseUp = FormMouseUp
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel0: TBevel
    Left = 0
    Top = 0
    Width = 893
    Height = 10
    Align = alTop
    Shape = bsTopLine
    Style = bsRaised
  end
  object OutBuffer: TStringGrid
    Left = 17
    Top = 38
    Width = 126
    Height = 52
    TabStop = False
    ColCount = 2
    DefaultColWidth = 50
    DefaultRowHeight = 15
    RowCount = 3
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goColSizing, goColMoving, goThumbTracking]
    ScrollBars = ssNone
    TabOrder = 0
    ColWidths = (
      50
      50)
    RowHeights = (
      15
      15
      15)
  end
  object Panel1: TPanel
    Left = 149
    Top = 51
    Width = 125
    Height = 39
    Color = clBlack
    TabOrder = 1
    object SenhaLabel: TLabel
      Left = 1
      Top = 1
      Width = 123
      Height = 19
      Align = alTop
      Alignment = taCenter
      AutoSize = False
      Color = clBlack
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clLime
      Font.Height = -15
      Font.Name = 'System'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
    end
    object GuicheLabel: TLabel
      Left = 1
      Top = 20
      Width = 123
      Height = 18
      Align = alClient
      Alignment = taCenter
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -15
      Font.Name = 'System'
      Font.Style = []
      ParentFont = False
      Transparent = False
      ExplicitLeft = 0
    end
  end
  object Button1: TButton
    Left = 416
    Top = 240
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 2
    Visible = False
    OnClick = Button1Click
  end
  object ClearOutBufferTimer: TTimer
    Enabled = False
    OnTimer = ClearOutBufferTimerTimer
    Left = 311
    Top = 15
  end
  object MainMenu1: TMainMenu
    Left = 435
    Top = 13
    object MenuArquivo: TMenuItem
      Caption = '&Arquivo'
      object MenuSair: TMenuItem
        Caption = 'Sai&r'
        OnClick = MenuSairClick
      end
    end
    object MenuConfigurar: TMenuItem
      Caption = '&Configurar'
      object SubMenuPrioridadesDosBoxes: TMenuItem
        Caption = '&Prioridades de atendimento'
        ShortCut = 16464
        OnClick = SubMenuPrioridadesDosBoxesClick
      end
      object menuIndicadoresdePerformance: TMenuItem
        Caption = 'Indicadores de Performance'
        object menuDefinicoesDeIndicadores: TMenuItem
          Caption = '&Defini'#231#245'es de &indicadores'
          OnClick = menuDefinicoesDeIndicadoresClick
        end
        object menuDefinicoesDeHorarios: TMenuItem
          Caption = 'Defini'#231#245'es de &hor'#225'rios'
          OnClick = menuDefinicoesDeHorariosClick
        end
        object menuAlarmes: TMenuItem
          Caption = '&Alarmes'
          OnClick = menuAlarmesClick
        end
      end
    end
    object MenuVisualizar: TMenuItem
      Caption = '&Visualizar'
      object SubMenuSituacao: TMenuItem
        Caption = '&Situa'#231#227'o do atendimento'
        OnClick = SubMenuSituacaoClick
      end
      object SubMenuIndicadoresDePerformance: TMenuItem
        Caption = 'I&ndicadores de Performance'
        OnClick = SubMenuIndicadoresDePerformanceClick
      end
      object menuVisualizarPPs: TMenuItem
        Caption = '&Processos paralelos'
        OnClick = menuVisualizarPPsClick
      end
    end
    object MenuQuestionMark: TMenuItem
      Caption = '&?'
      object SubMenuConfiguracoesAvancadas: TMenuItem
        Caption = '&Configura'#231#245'es avan'#231'adas'
        object Grupos1: TMenuItem
          Caption = '&Grupos'
          object SubMenuGruposDePosicoesDeAtendimento: TMenuItem
            Caption = 'PAs - P&osi'#231#245'es de Atendimento'
            OnClick = SubMenuGruposDePosicoesDeAtendimentoClick
          end
          object SubMenuGruposDeAtendentes: TMenuItem
            Caption = '&Atendentes'
            OnClick = SubMenuGruposDeAtendentesClick
          end
          object SubMenuGruposTags: TMenuItem
            Caption = '&Tags'
            OnClick = SubMenuGruposTagsClick
          end
          object SubMenuGruposPPs: TMenuItem
            Caption = 'PPs - P&rocessos Paralelos'
            OnClick = SubMenuGruposPPsClick
          end
          object SubMenuGruposMotivosPausa: TMenuItem
            Caption = '&Motivos de Pausa'
            OnClick = SubMenuGruposMotivosPausaClick
          end
        end
        object menuTotens: TMenuItem
          Caption = 'Tote&ns'
          OnClick = menuTotensClick
        end
        object SubMenuPaineis: TMenuItem
          Caption = '&Pain'#233'is'
          OnClick = SubMenuPaineisClick
        end
        object SubMenuFilas: TMenuItem
          Caption = '&Filas'
          OnClick = SubMenuFilasClick
        end
        object SubMenuPosicoesDeAtendimento: TMenuItem
          Caption = 'PAs - P&osi'#231#245'es de Atendimento'
          OnClick = SubMenuPosicoesDeAtendimentoClick
        end
        object SubMenuAtendentes: TMenuItem
          Caption = '&Atendentes'
          OnClick = SubMenuAtendentesClick
        end
        object SubMenuClientes: TMenuItem
          Caption = 'C&lientes'
          OnClick = SubMenuClientesClick
        end
        object SubMenuEmails: TMenuItem
          Caption = '&E-mails'
          OnClick = SubMenuEmailsClick
        end
        object menuCelulares: TMenuItem
          Caption = '&Celulares'
          OnClick = menuCelularesClick
        end
        object menuTags: TMenuItem
          Caption = '&Tags'
          OnClick = menuTagsClick
        end
        object menuConfigurarPPs: TMenuItem
          Caption = 'PPs - P&rocessos Paralelos'
          OnClick = menuConfigurarPPsClick
        end
        object menuMotivosDePausa: TMenuItem
          Caption = '&Motivos de Pausa'
          OnClick = menuMotivosDePausaClick
        end
        object menuModulosDoSics: TMenuItem
          Caption = '&M'#243'dulos do SICS'
          object menuModulosSicsPA: TMenuItem
            Caption = '&PA'
            OnClick = menuModulosSicsPAClick
          end
          object menuModulosSicsMultiPA: TMenuItem
            Caption = 'MultiPA'
            OnClick = menuModulosSicsMultiPAClick
          end
          object menuModulosSicsOnLine: TMenuItem
            Caption = 'OnLine'
            OnClick = menuModulosSicsOnLineClick
          end
          object menuModulosSicsTGS: TMenuItem
            Caption = 'TGS'
            OnClick = menuModulosSicsTGSClick
          end
          object MenuModuloSicsCallCenter: TMenuItem
            Caption = 'CallCenter'
            OnClick = MenuModuloSicsCallCenterClick
          end
        end
        object N5: TMenuItem
          Caption = '-'
        end
        object SubMenuConfiguracoesDeEnvioDeEmail: TMenuItem
          Caption = '&Config&ura'#231#245'es de envio de e-mail'
          OnClick = SubMenuConfiguracoesDeEnvioDeEmailClick
        end
        object SubMenuTestarEnvioDeEmail: TMenuItem
          Caption = 'Te&star envio de e-mail'
          OnClick = SubMenuTestarEnvioDeEmailClick
        end
        object SubMenuConfiguracoesDeEnvioDeSms: TMenuItem
          Caption = 'Conf&igura'#231#245'es de envio de SMS'
          OnClick = SubMenuConfiguracoesDeEnvioDeSmsClick
        end
        object SubMenuTestarEnvioDeSms: TMenuItem
          Caption = 'Testar envio de S&MS'
          OnClick = SubMenuTestarEnvioDeSmsClick
        end
        object N4: TMenuItem
          Caption = '-'
        end
        object Backups1: TMenuItem
          Caption = 'Bac&kups'
          OnClick = Backups1Click
        end
        object N6: TMenuItem
          Caption = '-'
        end
        object SubMenuStatusDosTotens: TMenuItem
          Caption = 'Status &dos totens'
          OnClick = SubMenuStatusDosTotensClick
        end
        object SubMenuStatusDasConexoesTcpIp: TMenuItem
          Caption = 'Status das cone&x'#245'es TCP/IP'
          OnClick = SubMenuStatusDasConexoesTcpIpClick
        end
        object SubMenuPaineisAlfanumericos: TMenuItem
          Caption = 'Pain'#233'is a&lfanum'#233'ricos'
          object SubMenuResetarPaineis: TMenuItem
            Caption = '&Resetar pain'#233'is'
            OnClick = SubMenuResetarPaineisClick
          end
          object SubMenuInicializarPaineis: TMenuItem
            Caption = '&Inicializar pain'#233'is'
            OnClick = SubMenuInicializarPaineisClick
          end
          object SubMenuAjustarHorarioDosPaineis: TMenuItem
            Caption = '&Ajustar hor'#225'rio dos pain'#233'is'
            OnClick = SubMenuAjustarHorarioDosPaineisClick
          end
          object menuConfigurarEnderecosSeriais: TMenuItem
            Caption = 'Configurar &endere'#231'os seriais'
            OnClick = menuConfigurarEnderecosSeriaisClick
          end
        end
        object SubMenuPaineisNumericos: TMenuItem
          Caption = 'Pain'#233'is nu&m'#233'ricos'
          object SubMenuApagarPaineis: TMenuItem
            Caption = '&Apagar pain'#233'is'
            OnClick = SubMenuApagarPaineisClick
          end
          object SubMenuTestarComunicacao: TMenuItem
            Caption = '&Testar comunica'#231#227'o'
            OnClick = SubMenuTestarComunicacaoClick
          end
        end
      end
      object SubMenuValidade: TMenuItem
        Caption = '&Validade'
        Visible = False
        OnClick = SubMenuValidadeClick
      end
      object SubMenuSobre: TMenuItem
        Caption = '&Sobre....'
        OnClick = SubMenuSobreClick
      end
    end
    object Shortcuts1: TMenuItem
      Caption = 'Shortcuts'
      Visible = False
      object But1: TMenuItem
        Tag = 1
        Caption = 'But1'
        ShortCut = 112
        OnClick = BitBtnClick
      end
      object But2: TMenuItem
        Tag = 2
        Caption = 'But2'
        ShortCut = 113
        OnClick = BitBtnClick
      end
      object But3: TMenuItem
        Tag = 3
        Caption = 'But3'
        ShortCut = 114
        OnClick = BitBtnClick
      end
      object But4: TMenuItem
        Tag = 4
        Caption = 'But4'
        ShortCut = 115
        OnClick = BitBtnClick
      end
      object But5: TMenuItem
        Tag = 5
        Caption = 'But5'
        ShortCut = 116
        OnClick = BitBtnClick
      end
      object But6: TMenuItem
        Tag = 6
        Caption = 'But6'
        ShortCut = 117
        OnClick = BitBtnClick
      end
      object But7: TMenuItem
        Tag = 7
        Caption = 'But7'
        ShortCut = 118
        OnClick = BitBtnClick
      end
      object But8: TMenuItem
        Tag = 8
        Caption = 'But8'
        ShortCut = 119
        OnClick = BitBtnClick
      end
      object But9: TMenuItem
        Tag = 9
        Caption = 'But9'
        ShortCut = 120
        OnClick = BitBtnClick
      end
      object But10: TMenuItem
        Tag = 10
        Caption = 'But10'
        ShortCut = 121
        OnClick = BitBtnClick
      end
      object But11: TMenuItem
        Tag = 11
        Caption = 'But11'
        ShortCut = 122
        OnClick = BitBtnClick
      end
      object But12: TMenuItem
        Tag = 12
        Caption = 'But12'
        ShortCut = 123
        OnClick = BitBtnClick
      end
      object Debug1: TMenuItem
        Caption = 'Debug'
        ShortCut = 24696
        OnClick = Debug1Click
      end
    end
  end
  object ManagePswdPopMenu: TPopupMenu
    OnPopup = ManagePswdPopMenuPopup
    Left = 530
    Top = 15
    object PopUpMenuExcluir: TMenuItem
      Caption = '&Excluir'
      OnClick = PopUpMenuExcluirClick
    end
    object mnuExcluirTodos: TMenuItem
      Caption = 'Excluir Todos'
      OnClick = mnuExcluirTodosClick
    end
  end
  object ServerSocket1: TServerSocket
    Active = False
    Port = 6601
    ServerType = stNonBlocking
    OnClientConnect = ServerSocket1ClientConnect
    OnClientRead = ServerSocket1ClientRead
    OnClientError = ServerSocket1ClientError
    Left = 356
    Top = 74
  end
  object OneMinuteTimer: TTimer
    Interval = 60000
    OnTimer = OneMinuteTimerTimer
    Left = 356
    Top = 15
  end
  object PrinterPort: TVaComm
    Baudrate = br9600
    FlowControl.OutCtsFlow = True
    FlowControl.OutDsrFlow = False
    FlowControl.ControlDtr = dtrEnabled
    FlowControl.ControlRts = rtsEnabled
    FlowControl.XonXoffOut = False
    FlowControl.XonXoffIn = False
    FlowControl.DsrSensitivity = False
    FlowControl.TxContinueOnXoff = False
    DeviceName = 'Com1'
    MonitorEvents = [ceRxChar]
    Buffers.WriteSize = 4096
    OnRxChar = PrinterPortRxChar
    Version = '1.8.0.0'
    Left = 467
    Top = 74
  end
  object PainelPort: TVaComm
    Tag = 1
    FlowControl.OutCtsFlow = False
    FlowControl.OutDsrFlow = False
    FlowControl.ControlDtr = dtrEnabled
    FlowControl.ControlRts = rtsEnabled
    FlowControl.XonXoffOut = False
    FlowControl.XonXoffIn = False
    FlowControl.DsrSensitivity = True
    FlowControl.TxContinueOnXoff = False
    DeviceName = 'COM%d'
    MonitorEvents = [ceCts, ceDsr, ceError, ceTxEmpty]
    OnCts = PainelPortCts
    OnDsr = PainelPortDsr
    OnTxEmpty = PainelPortTxEmpty
    Version = '1.8.0.0'
    Left = 431
    Top = 74
  end
  object PainelTcpPort: TServerSocket
    Active = False
    Port = 6502
    ServerType = stNonBlocking
    Left = 467
    Top = 15
  end
  object CheckConnectionsTimer: TTimer
    Enabled = False
    Interval = 20000
    OnTimer = CheckConnectionsTimerTimer
    Left = 395
    Top = 15
  end
  object Botoeiras3B2LPort: TVaComm
    FlowControl.OutCtsFlow = False
    FlowControl.OutDsrFlow = False
    FlowControl.ControlDtr = dtrEnabled
    FlowControl.ControlRts = rtsEnabled
    FlowControl.XonXoffOut = False
    FlowControl.XonXoffIn = False
    FlowControl.DsrSensitivity = False
    FlowControl.TxContinueOnXoff = False
    DeviceName = 'COM%d'
    MonitorEvents = [ceError, ceRxChar]
    OnRxChar = Botoeiras3B2LPortRxChar
    Version = '1.8.0.0'
    Left = 504
    Top = 74
  end
  object TecladoPort: TVaComm
    Baudrate = br9600
    Parity = paEven
    Databits = db7
    Stopbits = sb2
    FlowControl.OutCtsFlow = False
    FlowControl.OutDsrFlow = False
    FlowControl.ControlDtr = dtrEnabled
    FlowControl.ControlRts = rtsEnabled
    FlowControl.XonXoffOut = False
    FlowControl.XonXoffIn = False
    FlowControl.DsrSensitivity = False
    FlowControl.TxContinueOnXoff = False
    DeviceName = 'COM%d'
    MonitorEvents = [ceError, ceRxChar]
    OnRxChar = TecladoPortRxChar
    Version = '1.8.0.0'
    Left = 540
    Top = 74
  end
  object TGSServerSocket: TServerSocket
    Active = False
    Port = 6602
    ServerType = stNonBlocking
    OnClientConnect = ServerSocket1ClientConnect
    OnClientRead = ServerSocket1ClientRead
    OnClientError = ServerSocket1ClientError
    Left = 395
    Top = 74
  end
  object cdsIdsTickets: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'NumeroTicket'
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end
      item
        DataType = ftInteger
        Name = 'NUMEROTICKET'
        ParamType = ptInput
      end>
    ProviderName = 'dspIdsTickets'
    AfterPost = cdsIdsTicketsAfterPost
    Left = 54
    Top = 94
    object cdsIdsTicketsID: TIntegerField
      FieldName = 'ID'
    end
    object cdsIdsTicketsNumeroTicket: TIntegerField
      FieldName = 'NumeroTicket'
    end
    object cdsIdsTicketsNomeCliente: TStringField
      DisplayWidth = 60
      FieldName = 'NomeCliente'
      Size = 80
    end
    object cdsIdsTicketsFila_Id: TIntegerField
      FieldName = 'Fila_Id'
    end
  end
  object TrayIcon1: TTrayIcon
    Icon.Data = {
      0000010001001010000000002000680400001600000028000000100000002000
      000001002000000000004004000000000000000000000000000000000000FFFF
      FF01FFFFFF01FFFFFF01004AFD4F004AFD93004AFDA1004AFD89004AFD59004A
      FD1BFFFFFF01FFFFFF01FFFFFF01FFFFFF01FFFFFF01FFFFFF01FFFFFF01FFFF
      FF01FFFFFF01004AFD6D004AFDD9004AFDCB004AFDA9004AFD99004AFD93004A
      FD71004AFD2BFFFFFF01FFFFFF01FFFFFF01FFFFFF01FFFFFF01FFFFFF01FFFF
      FF01004AFD85004AFDF1004AFD51004AFD03FFFFFF01FFFFFF01FFFFFF01004A
      FD1F004AFD41004AFD2D004AFD05FFFFFF01FFFFFF01FFFFFF01FFFFFF01004A
      FD47004AFDFB004AFD3DFFFFFF01FFFFFF01FFFFFF01FFFFFF01FFFFFF01FFFF
      FF01FFFFFF01004AFD07004AFD07004AFD05FFFFFF01FFFFFF01FFFFFF014F69
      9FD73C4B6CED3C3F3FC1373737B53B3B3C19757777494F414585564B4D157074
      74B33D3F3FC33D393A67595A5B65535A62CB3A3F43C5383A3AB9353737319494
      A8F1B6A8ABFFB8A9ACFF878182FF4D4E4F79848686736F5D61CD7D71733DC3C0
      C1FFABA4A6FF7F6B6FAD9085879BB7AAADFFB8A9ACFF8F898AFF464646953543
      9BAD614A6ACF6B444CAD806B70DF6F686AD18B7D7F77837074CD8980825F703E
      48C1530C1B7D50121F455F30393D724B54AF664456B7786776E35F5154E196A1
      B4C1A6A2A4FDB7AEB0F9B8AEAFFB6D3C45A98C7B7F7588777BCB858585755D3C
      4375FFFFFF01FFFFFF019D9D9D85B5B2B3FBB4AEAFFBBAB3B6FD5A3749CBB3B3
      B4DF765B6CE9623F4DAF57373DA34A30344B9999997989797DCB7E7F7F735F5B
      5EB92F33336D5452532FA5A7A6AD86696FE561353DA3523D59CF233787A77E59
      60AFBFBDBDFFBCB7B8FFB7B4B5FF86797DCF8B7A7E7D876C71D362373F45BEB5
      B7FFB1AEAFFF6E4750AD744F5777BEB9BAFFBBB5B6FFC1BFC0FF685A6EF14305
      1017500F1A774517398F4615358F4E0D19594E1621274F101C59FFFFFF014E0C
      196754111F814E0F1B4940030F09500E1A73510E1A7B352368BF252E94CBFFFF
      FF01FFFFFF01FFFFFF01004AFD13004AFD05FFFFFF01FFFFFF01FFFFFF01FFFF
      FF01FFFFFF01FFFFFF01FFFFFF01FFFFFF01004AFD07004AFDE3004AFD7FFFFF
      FF01FFFFFF01FFFFFF01FFFFFF01004AFD07004AFD27004AFD19FFFFFF01FFFF
      FF01FFFFFF01FFFFFF01FFFFFF01004AFD07004AFDAD004AFDD9004AFD17FFFF
      FF01FFFFFF01FFFFFF01FFFFFF01FFFFFF01004AFD0F004AFD4B004AFD71004A
      FD63004AFD4D004AFD51004AFD7D004AFDD1004AFDCF004AFD23FFFFFF01FFFF
      FF01FFFFFF01FFFFFF01FFFFFF01FFFFFF01FFFFFF01FFFFFF01004AFD19004A
      FD57004AFD91004AFDAB004AFD9F004AFD57004AFD05FFFFFF01FFFFFF01FFFF
      FF01FFFFFF01FFFFFF01FFFFFF01FFFFFF01FFFFFF01FFFFFF01FFFFFF01FFFF
      FF01FFFFFF01FFFFFF01FFFFFF01FFFFFF01FFFFFF01FFFFFF01FFFFFF010000
      FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000
      FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF}
    PopupMenu = menuTray
    OnDblClick = TrayIcon1DblClick
    Left = 232
    Top = 106
  end
  object menuTray: TPopupMenu
    AutoHotkeys = maManual
    Left = 318
    Top = 74
    object menuTrayRestaurar: TMenuItem
      Caption = '&Restaurar'
      Default = True
      OnClick = menuTrayRestaurarClick
    end
    object N7: TMenuItem
      Caption = '-'
    end
    object menuTraySair: TMenuItem
      Caption = 'Sai&r'
      OnClick = MenuSairClick
    end
  end
  object cdsIdsTicketsTags: TClientDataSet
    Aggregates = <>
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspIdsTicketsTags'
    AfterInsert = cdsIdsTicketsTagsAfterInsert
    Left = 56
    Top = 143
    object cdsIdsTicketsTagsId: TIntegerField
      FieldName = 'Id'
    end
    object cdsIdsTicketsTagsTicket_Id: TIntegerField
      FieldName = 'Ticket_Id'
    end
    object cdsIdsTicketsTagsTag_Id: TIntegerField
      FieldName = 'Tag_Id'
    end
    object cdsIdsTicketsTagsId_Unidade: TIntegerField
      FieldName = 'Id_Unidade'
    end
  end
  object ServerSocketRetrocompatibilidade: TServerSocket
    Active = False
    Port = 6501
    ServerType = stNonBlocking
    OnClientConnect = ServerSocket1ClientConnect
    OnClientRead = ServerSocket1ClientRead
    OnClientError = ServerSocket1ClientError
    Left = 356
    Top = 125
  end
  object cdsIdsTicketsAgendamentosFilas: TClientDataSet
    Aggregates = <>
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspIdsTicketsAgendamentosFilas'
    Left = 56
    Top = 192
    object cdsIdsTicketsAgendamentosFilasID: TIntegerField
      FieldName = 'ID'
      Required = True
    end
    object cdsIdsTicketsAgendamentosFilasID_TICKET: TIntegerField
      FieldName = 'ID_TICKET'
    end
    object cdsIdsTicketsAgendamentosFilasID_FILA: TIntegerField
      FieldName = 'ID_FILA'
    end
    object cdsIdsTicketsAgendamentosFilasDATAHORA: TSQLTimeStampField
      FieldName = 'DATAHORA'
    end
    object cdsIdsTicketsAgendamentosFilasCONCLUIDO: TStringField
      FieldName = 'CONCLUIDO'
      FixedChar = True
      Size = 1
    end
  end
  object socketImprimeCDB: TASPClientSocket
    Active = False
    ClientType = ctNonBlocking
    Port = 0
    OnError = socketImprimeCDBError
    Left = 352
    Top = 168
  end
  object cdsTmp: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 808
    Top = 184
  end
  object IdHTTPServer: TIdHTTPServer
    Bindings = <>
    OnCommandGet = IdHTTPServerCommandGet
    Left = 520
    Top = 168
  end
  object FDTGruposPAS_AlarmesPapelTotens: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 616
    Top = 256
    object FDTGruposPAS_AlarmesPapelTotensID_TOTEM: TIntegerField
      FieldName = 'ID_TOTEM'
    end
    object FDTGruposPAS_AlarmesPapelTotensSTATUS: TStringField
      FieldName = 'STATUS'
      Size = 10
    end
    object FDTGruposPAS_AlarmesPapelTotensGRUPO_PAS: TStringField
      FieldName = 'GRUPO_PAS'
      Size = 255
    end
  end
  object RoboFilaEsperaProfissional: TTimer
    Enabled = False
    OnTimer = RoboFilaEsperaProfissionalTimer
    Left = 600
    Top = 16
  end
  object qryIdsTicketsAgendamentosFilas: TFDQuery
    Connection = dmSicsMain.connOnLine
    SQL.Strings = (
      'SELECT'
      '  *'
      'FROM'
      '  AGENDAMENTOS_FILAS'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE'
      'ORDER BY'
      '  ID')
    Left = 616
    Top = 312
    ParamData = <
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
    object qryIdsTicketsAgendamentosFilasID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
      Origin = 'ID_UNIDADE'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qryIdsTicketsAgendamentosFilasID: TIntegerField
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInUpdate, pfInKey]
      Required = True
    end
    object qryIdsTicketsAgendamentosFilasID_TICKET: TIntegerField
      FieldName = 'ID_TICKET'
      Origin = 'ID_TICKET'
      ProviderFlags = [pfInUpdate]
    end
    object qryIdsTicketsAgendamentosFilasID_FILA: TIntegerField
      FieldName = 'ID_FILA'
      Origin = 'ID_FILA'
      ProviderFlags = [pfInUpdate]
    end
    object qryIdsTicketsAgendamentosFilasDATAHORA: TSQLTimeStampField
      FieldName = 'DATAHORA'
      Origin = 'DATAHORA'
      ProviderFlags = [pfInUpdate]
    end
    object qryIdsTicketsAgendamentosFilasCONCLUIDO: TStringField
      FieldName = 'CONCLUIDO'
      Origin = 'CONCLUIDO'
      ProviderFlags = [pfInUpdate]
      FixedChar = True
      Size = 1
    end
  end
  object dspIdsTicketsAgendamentosFilas: TDataSetProvider
    DataSet = qryIdsTicketsAgendamentosFilas
    Options = [poAutoRefresh, poPropogateChanges, poUseQuoteChar]
    UpdateMode = upWhereKeyOnly
    Left = 712
    Top = 312
  end
  object qryIdsTicketsTags: TFDQuery
    Connection = dmSicsMain.connOnLine
    SQL.Strings = (
      'SELECT'
      '  TT.*,'
      '  TI.NUMEROTICKET,'
      '  TA.ID_GRUPOTAG'
      'FROM'
      '  TICKETS_TAGS TT'
      
        '  INNER JOIN TICKETS TI ON (TI.ID_UNIDADE = TT.ID_UNIDADE AND TI' +
        '.ID = TT.TICKET_ID)'
      
        '  INNER JOIN TAGS    TA ON (TA.ID_UNIDADE = TT.ID_UNIDADE AND TA' +
        '.ID = TT.TAG_ID)'
      'WHERE'
      '  TT.ID_UNIDADE = :ID_UNIDADE')
    Left = 616
    Top = 200
    ParamData = <
      item
        Position = 1
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
      end>
    object qryIdsTicketsTagsID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
      Origin = 'ID_UNIDADE'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qryIdsTicketsTagsID: TIntegerField
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qryIdsTicketsTagsTICKET_ID: TIntegerField
      FieldName = 'TICKET_ID'
      Origin = 'TICKET_ID'
      ProviderFlags = [pfInUpdate]
    end
    object qryIdsTicketsTagsTAG_ID: TIntegerField
      FieldName = 'TAG_ID'
      Origin = 'TAG_ID'
      ProviderFlags = [pfInUpdate]
    end
    object qryIdsTicketsTagsNUMEROTICKET: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'NUMEROTICKET'
      Origin = 'NUMEROTICKET'
      ProviderFlags = [pfInUpdate]
      ReadOnly = True
    end
    object qryIdsTicketsTagsID_GRUPOTAG: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'ID_GRUPOTAG'
      Origin = 'ID_GRUPOTAG'
      ProviderFlags = [pfInUpdate]
      ReadOnly = True
    end
  end
  object dspIdsTicketsTags: TDataSetProvider
    DataSet = qryIdsTicketsTags
    Options = [poAutoRefresh, poPropogateChanges, poUseQuoteChar]
    UpdateMode = upWhereKeyOnly
    Left = 712
    Top = 200
  end
  object dspIdsTickets: TDataSetProvider
    DataSet = qryIdsTickets
    Options = [poAutoRefresh, poPropogateChanges, poUseQuoteChar]
    UpdateMode = upWhereKeyOnly
    Left = 712
    Top = 152
  end
  object qryIdsTickets: TFDQuery
    Connection = dmSicsMain.connOnLine
    FetchOptions.AssignedValues = [evUnidirectional]
    FetchOptions.Unidirectional = True
    SQL.Strings = (
      'SELECT'
      '  T.ID_UNIDADE,'
      '  T.ID,'
      '  T.NUMEROTICKET,'
      '  T.NOMECLIENTE,'
      '  T.FILA_ID,'
      '  T.ORDEM,'
      '  T.CREATEDAT'
      'FROM'
      '  TICKETS T'
      '  INNER JOIN (SELECT'
      '                T2.ID_UNIDADE,'
      '                MAX(T2.ID) AS ID'
      '              FROM'
      '                TICKETS T2'
      '              WHERE'
      '                T2.ID_UNIDADE = :ID_UNIDADE AND'
      '                T2.NUMEROTICKET = :NUMEROTICKET'
      '              GROUP BY'
      
        '                T2.ID_UNIDADE) T2 ON (T2.ID_UNIDADE = T.ID_UNIDA' +
        'DE AND'
      '                                      T2.ID = T.ID)')
    Left = 616
    Top = 152
    ParamData = <
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'NUMEROTICKET'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
    object qryIdsTicketsID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
      Origin = 'ID_UNIDADE'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qryIdsTicketsID: TIntegerField
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qryIdsTicketsNUMEROTICKET: TIntegerField
      FieldName = 'NUMEROTICKET'
      Origin = 'NUMEROTICKET'
      ProviderFlags = [pfInUpdate]
    end
    object qryIdsTicketsNOMECLIENTE: TStringField
      FieldName = 'NOMECLIENTE'
      Origin = 'NOMECLIENTE'
      ProviderFlags = [pfInUpdate]
      Size = 60
    end
    object qryIdsTicketsFILA_ID: TIntegerField
      FieldName = 'FILA_ID'
      Origin = 'FILA_ID'
      ProviderFlags = [pfInUpdate]
    end
    object qryIdsTicketsORDEM: TIntegerField
      FieldName = 'ORDEM'
      Origin = 'ORDEM'
      ProviderFlags = [pfInUpdate]
    end
    object qryIdsTicketsCREATEDAT: TSQLTimeStampField
      FieldName = 'CREATEDAT'
      Origin = 'CREATEDAT'
      ProviderFlags = [pfInUpdate]
    end
  end
end
