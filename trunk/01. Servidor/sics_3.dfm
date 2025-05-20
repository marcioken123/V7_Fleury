object frmSicsPIMonitor: TfrmSicsPIMonitor
  Left = 434
  Top = 58
  Caption = 'Indicadores de Performance'
  ClientHeight = 304
  ClientWidth = 484
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  DesignSize = (
    484
    304)
  PixelsPerInch = 96
  TextHeight = 13
  object lblSegundosRecalcular: TLabel
    Left = 8
    Top = 283
    Width = 17
    Height = 13
    Hint = 'Tempo para novo c'#225'lculo dos indicadores'
    Anchors = [akLeft, akBottom]
    Caption = '20s'
    ParentShowHint = False
    ShowHint = True
    ExplicitTop = 282
  end
  object dbgrdPIs: TASPDbGrid
    AlignWithMargins = True
    Left = 8
    Top = 8
    Width = 468
    Height = 255
    Margins.Left = 8
    Margins.Top = 8
    Margins.Right = 8
    Margins.Bottom = 8
    Align = alTop
    DataSource = dtsPIs
    Options = [dgEditing, dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
    ReadOnly = True
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnDrawColumnCell = dbgrdPIsDrawColumnCell
    Columns = <
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'PINOME'
        Title.Alignment = taCenter
        Width = 100
        Visible = True
      end
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'VALOR'
        Title.Alignment = taCenter
        Width = 50
        Visible = True
      end
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'NOMENIVEL'
        Title.Alignment = taCenter
        Width = 80
        Visible = True
      end>
  end
  object btnFechar: TButton
    Left = 401
    Top = 270
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Cancel = True
    Caption = '&Fechar'
    TabOrder = 1
    OnClick = btnFecharClick
  end
  object PIsUpdateTimer: TTimer
    Tag = 20
    Enabled = False
    OnTimer = PIsUpdateTimerTimer
    Left = 63
    Top = 49
  end
  object cdsPIs: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'ID_PI'
    Params = <>
    AfterOpen = cdsPIsAfterOpen
    Left = 64
    Top = 96
    object cdsPIsPINOME: TStringField
      DisplayLabel = 'PI'
      FieldName = 'PINOME'
      Size = 40
    end
    object cdsPIsID_PI: TIntegerField
      DisplayLabel = 'IdPI'
      FieldName = 'ID_PI'
    end
    object cdsPIsID_PIMONITORAMENTO: TIntegerField
      DisplayLabel = 'IDMonitoramento'
      FieldName = 'ID_PIMONITORAMENTO'
    end
    object cdsPIsVALOR: TStringField
      DisplayLabel = 'Valor'
      FieldName = 'VALOR'
    end
    object cdsPIsID_PINIVEL: TIntegerField
      FieldName = 'ID_PINIVEL'
    end
    object cdsPIsID_PINIVEL_ANTERIOR: TIntegerField
      FieldName = 'ID_PINIVEL_ANTERIOR'
    end
    object cdsPIsCODIGOCOR: TIntegerField
      FieldName = 'CODIGOCOR'
    end
    object cdsPIsNOMENIVEL: TStringField
      DisplayLabel = 'Estado'
      FieldName = 'NOMENIVEL'
    end
    object cdsPIsCOR_PAINELELETRONICO: TStringField
      FieldName = 'COR_PAINELELETRONICO'
      Size = 30
    end
    object cdsPIsPOSICAONIVEL_ANTERIOR: TIntegerField
      FieldName = 'POSICAONIVEL_ANTERIOR'
    end
    object cdsPIsPOSICAONIVEL: TIntegerField
      FieldName = 'POSICAONIVEL'
    end
    object cdsPIsVALOR_NUMERICO: TIntegerField
      FieldName = 'VALOR_NUMERICO'
    end
    object cdsPIsFLAG_VALOR_EM_SEGUNDOS: TBooleanField
      FieldName = 'FLAG_VALOR_EM_SEGUNDOS'
    end
    object cdsPIsGRUPOSPASIDRELACIONADOS: TStringField
      FieldName = 'GRUPOSPASIDRELACIONADOS'
      Size = 255
    end
    object cdsPIsMENSAGEMTRADUZIDA: TStringField
      FieldName = 'MENSAGEMTRADUZIDA'
      Size = 255
    end
  end
  object dtsPIs: TDataSource
    DataSet = cdsPIs
    Left = 120
    Top = 96
  end
  object cdsPIsClone: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 64
    Top = 144
  end
  object cdsPIsNivelUltExec: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 64
    Top = 240
    object cdsPIsNivelUltExecID_PI: TIntegerField
      FieldName = 'ID_PI'
    end
    object cdsPIsNivelUltExecID_PINIVEL: TIntegerField
      FieldName = 'ID_PINIVEL'
    end
    object cdsPIsNivelUltExecDATAHORA: TDateTimeField
      FieldName = 'DATAHORA'
    end
  end
  object TimerAtualizarPaineis: TTimer
    Enabled = False
    Interval = 300000
    OnTimer = TimerAtualizarPaineisTimer
    Left = 344
    Top = 96
  end
  object cdsPIsClone_AlarmesAtivos: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 64
    Top = 192
  end
end
