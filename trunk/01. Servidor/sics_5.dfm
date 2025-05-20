object frmSicsProcessosParalelos: TfrmSicsProcessosParalelos
  Left = 581
  Top = 129
  Caption = 'Processos paralelos'
  ClientHeight = 369
  ClientWidth = 650
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
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 5
    Top = 5
    Width = 170
    Height = 13
    Caption = '&Processos paralelos em andamento:'
  end
  object gridPPs: TASPDbGrid
    Left = 10
    Top = 35
    Width = 320
    Height = 120
    DataSource = dsProcessosParalelos
    Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
  end
  object CloseButton: TBitBtn
    Left = 254
    Top = 168
    Width = 71
    Height = 27
    Caption = 'Fe&char'
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 1
    OnClick = CloseButtonClick
  end
  object cdsPPs: TClientDataSet
    Aggregates = <>
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspPPs'
    AfterOpen = cdsPPsAfterOpen
    BeforePost = cdsPPsBeforePost
    Left = 343
    Top = 60
    object cdsPPsID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
      Required = True
      Visible = False
    end
    object cdsPPsID: TIntegerField
      FieldName = 'ID'
      Required = True
    end
    object cdsPPsId_EventoPP: TIntegerField
      FieldName = 'Id_EventoPP'
      Visible = False
    end
    object cdsPPsId_TipoPP: TIntegerField
      FieldName = 'Id_TipoPP'
      Visible = False
    end
    object cdsPPsId_PA: TIntegerField
      FieldName = 'Id_PA'
      Visible = False
    end
    object cdsPPsId_Atd: TIntegerField
      FieldName = 'Id_Atd'
      Visible = False
    end
    object cdsPPslkp_TipoPP_Nome: TStringField
      DisplayLabel = 'Tipo do processo paralelo'
      FieldKind = fkLookup
      FieldName = 'lkp_TipoPP_Nome'
      LookupDataSet = dmSicsMain.cdsPPs
      LookupKeyFields = 'ID'
      LookupResultField = 'NOME'
      KeyFields = 'Id_TipoPP'
      Size = 60
      Lookup = True
    end
    object cdsPPsTicketNumber: TIntegerField
      Alignment = taCenter
      DisplayLabel = 'Senha'
      FieldName = 'TicketNumber'
    end
    object cdsPPsNomeCliente: TStringField
      DisplayLabel = 'Nome do cliente'
      FieldName = 'NomeCliente'
      Size = 60
    end
    object cdsPPslkp_PA_Nome: TStringField
      DisplayLabel = 'Onde iniciou'
      FieldKind = fkLookup
      FieldName = 'lkp_PA_Nome'
      LookupDataSet = dmSicsMain.cdsPAs
      LookupKeyFields = 'Id'
      LookupResultField = 'Nome'
      KeyFields = 'Id_PA'
      Size = 60
      Lookup = True
    end
    object cdsPPslkp_Atd_Nome: TStringField
      DisplayLabel = 'Quem iniciou'
      FieldKind = fkLookup
      FieldName = 'lkp_Atd_Nome'
      LookupDataSet = dmSicsMain.cdsAtendentes
      LookupKeyFields = 'ID'
      LookupResultField = 'Nome'
      KeyFields = 'Id_Atd'
      Size = 60
      Lookup = True
    end
    object cdsPPsHorario: TSQLTimeStampField
      Alignment = taCenter
      DisplayLabel = 'Hor'#225'rio'
      FieldName = 'Horario'
      DisplayFormat = 'hh:nn:ss'
    end
  end
  object dsProcessosParalelos: TDataSource
    DataSet = cdsPPs
    Left = 378
    Top = 60
  end
  object cdsClonePPs: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 342
    Top = 107
  end
  object dspPPs: TDataSetProvider
    DataSet = qryPPs
    Left = 254
    Top = 88
  end
  object qryPPs: TFDQuery
    Connection = dmSicsMain.connOnLine
    SQL.Strings = (
      'SELECT'
      '  *'
      'FROM'
      '  PPAS'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE'
      'ORDER BY'
      '  ID')
    Left = 216
    Top = 88
    ParamData = <
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
    object qryPPsID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
      Origin = 'ID_UNIDADE'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qryPPsID: TIntegerField
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qryPPsID_EVENTOPP: TIntegerField
      FieldName = 'ID_EVENTOPP'
      Origin = 'ID_EVENTOPP'
    end
    object qryPPsID_TIPOPP: TIntegerField
      FieldName = 'ID_TIPOPP'
      Origin = 'ID_TIPOPP'
    end
    object qryPPsID_PA: TIntegerField
      FieldName = 'ID_PA'
      Origin = 'ID_PA'
    end
    object qryPPsID_ATD: TIntegerField
      FieldName = 'ID_ATD'
      Origin = 'ID_ATD'
    end
    object qryPPsTICKETNUMBER: TIntegerField
      FieldName = 'TICKETNUMBER'
      Origin = 'TICKETNUMBER'
    end
    object qryPPsHORARIO: TSQLTimeStampField
      FieldName = 'HORARIO'
      Origin = 'HORARIO'
    end
    object qryPPsNOMECLIENTE: TStringField
      FieldName = 'NOMECLIENTE'
      Origin = 'NOMECLIENTE'
      Size = 60
    end
  end
end
