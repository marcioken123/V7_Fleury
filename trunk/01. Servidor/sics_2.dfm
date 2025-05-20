object frmSicsSituacaoAtendimento: TfrmSicsSituacaoAtendimento
  Left = 363
  Top = 189
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Situa'#231#227'o do atendimento'
  ClientHeight = 311
  ClientWidth = 446
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poDefault
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object CloseButton: TBitBtn
    Left = 209
    Top = 248
    Width = 71
    Height = 27
    Caption = 'Fe&char'
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 0
    OnClick = CloseButtonClick
  end
  object FinalizarAtendimentoButton: TButton
    Left = 60
    Top = 248
    Width = 127
    Height = 27
    Caption = '&Finalizar atendimento'
    TabOrder = 1
    Visible = False
  end
  object PageControl: TPageControl
    Left = 15
    Top = 15
    Width = 289
    Height = 193
    ActivePage = TabSheet1
    TabOrder = 2
    object TabSheet1: TTabSheet
      Caption = 'PAs'
      object gridPAs: TDBGrid
        Left = 0
        Top = 0
        Width = 281
        Height = 165
        Align = alClient
        DataSource = dsPAs
        Options = [dgTitles, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        ReadOnly = True
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clBlack
        TitleFont.Height = -10
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Atendentes'
      ImageIndex = 1
      object gridAtds: TDBGrid
        Left = 0
        Top = 0
        Width = 281
        Height = 165
        Align = alClient
        DataSource = dsAtds
        Options = [dgTitles, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        ReadOnly = True
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clBlack
        TitleFont.Height = -10
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
      end
    end
  end
  object cdsPAs: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'POSICAO'
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspAtendPAs'
    AfterOpen = cdsPAsAfterOpen
    BeforePost = cdsPAsBeforePost
    Left = 344
    Top = 16
    object cdsPAsID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
      Required = True
      Visible = False
    end
    object cdsPAsID: TIntegerField
      FieldName = 'ID'
      Visible = False
    end
    object cdsPAsId_PA: TIntegerField
      Alignment = taCenter
      DisplayLabel = '#'
      FieldName = 'Id_PA'
    end
    object cdsPAsLKUP_PA: TStringField
      DisplayLabel = 'PA'
      FieldKind = fkLookup
      FieldName = 'LKUP_PA'
      LookupDataSet = dmSicsMain.cdsPAs
      LookupKeyFields = 'ID'
      LookupResultField = 'NOME'
      KeyFields = 'Id_PA'
      Size = 30
      Lookup = True
    end
    object cdsPAsLKUP_ID_GRUPO: TIntegerField
      FieldKind = fkLookup
      FieldName = 'LKUP_ID_GRUPO'
      LookupDataSet = dmSicsMain.cdsPAs
      LookupKeyFields = 'ID'
      LookupResultField = 'ID_GRUPOPA'
      KeyFields = 'Id_PA'
      Visible = False
      Lookup = True
    end
    object cdsPAsLKUP_GRUPO: TStringField
      DisplayLabel = 'Grupo'
      FieldKind = fkLookup
      FieldName = 'LKUP_GRUPO'
      LookupDataSet = dmSicsMain.cdsGruposDePAs
      LookupKeyFields = 'ID'
      LookupResultField = 'NOME'
      KeyFields = 'LKUP_ID_GRUPO'
      Size = 30
      Lookup = True
    end
    object cdsPAsId_Status: TIntegerField
      FieldName = 'Id_Status'
      Visible = False
    end
    object cdsPAsLKUP_STATUS: TStringField
      DisplayLabel = 'Estado'
      FieldKind = fkLookup
      FieldName = 'LKUP_STATUS'
      LookupDataSet = dmSicsMain.cdsStatusDasPAs
      LookupKeyFields = 'ID'
      LookupResultField = 'NOME'
      KeyFields = 'Id_Status'
      Size = 30
      Lookup = True
    end
    object cdsPAsId_Atd: TIntegerField
      FieldName = 'Id_Atd'
      Visible = False
    end
    object cdsPAsLKUP_ATD: TStringField
      DisplayLabel = 'Atendente'
      FieldKind = fkLookup
      FieldName = 'LKUP_ATD'
      LookupDataSet = dmSicsMain.cdsAtendentes
      LookupKeyFields = 'ID'
      LookupResultField = 'NOME'
      KeyFields = 'Id_Atd'
      Size = 30
      Lookup = True
    end
    object cdsPAsId_Senha: TIntegerField
      FieldName = 'Id_Senha'
      Visible = False
    end
    object cdsPAsSENHA: TIntegerField
      Alignment = taCenter
      DisplayLabel = 'Senha'
      FieldName = 'SENHA'
    end
    object cdsPAsNomeCliente: TStringField
      FieldName = 'NomeCliente'
      Size = 60
    end
    object cdsPAsHorario: TSQLTimeStampField
      Alignment = taCenter
      FieldName = 'Horario'
      DisplayFormat = 'hh:nn:ss'
    end
    object cdsPAsId_Fila: TIntegerField
      FieldName = 'Id_Fila'
      Visible = False
    end
    object cdsPAsLKUP_FILA: TStringField
      DisplayLabel = 'Veio da fila'
      FieldKind = fkLookup
      FieldName = 'LKUP_FILA'
      LookupDataSet = dmSicsMain.cdsFilas
      LookupKeyFields = 'ID'
      LookupResultField = 'NOME'
      KeyFields = 'Id_Fila'
      Size = 30
      Lookup = True
    end
    object cdsPAsId_MotivoPausa: TIntegerField
      FieldName = 'Id_MotivoPausa'
      Visible = False
    end
    object cdsPAsLKUP_MOTIVOPAUSA: TStringField
      DisplayLabel = 'Motivo Pausa'
      FieldKind = fkLookup
      FieldName = 'LKUP_MOTIVOPAUSA'
      LookupDataSet = dmSicsMain.cdsMotivosDePausa
      LookupKeyFields = 'ID'
      LookupResultField = 'NOME'
      KeyFields = 'Id_MotivoPausa'
      Size = 60
      Lookup = True
    end
    object cdsPAsID_ATENDENTE_AUTOLOGIN: TIntegerField
      FieldName = 'ID_ATENDENTE_AUTOLOGIN'
      Visible = False
    end
    object cdsPAsAtivo: TStringField
      FieldName = 'Ativo'
      Visible = False
    end
    object cdsPAsPOSICAO: TIntegerField
      FieldName = 'POSICAO'
      Visible = False
    end
    object cdsPAsHorarioLogin: TSQLTimeStampField
      Alignment = taCenter
      FieldName = 'HorarioLogin'
      DisplayFormat = 'hh:nn:ss'
    end
  end
  object dsPAs: TDataSource
    DataSet = cdsPAs
    OnDataChange = dsPAsDataChange
    Left = 384
    Top = 16
  end
  object cdsAtds: TClientDataSet
    Aggregates = <>
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspAtendAtds'
    AfterOpen = cdsAtdsAfterOpen
    BeforePost = cdsAtdsBeforePost
    OnReconcileError = cdsAtdsReconcileError
    Left = 344
    Top = 56
    object cdsAtdsID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
      Required = True
      Visible = False
    end
    object cdsAtdsID: TIntegerField
      FieldName = 'ID'
      Required = True
      Visible = False
    end
    object IntegerField2: TIntegerField
      Alignment = taCenter
      DisplayLabel = '#'
      FieldName = 'Id_Atd'
    end
    object cdsAtdsLKUP_ATD: TStringField
      DisplayLabel = 'Atendente'
      FieldKind = fkLookup
      FieldName = 'LKUP_ATD'
      LookupDataSet = dmSicsMain.cdsAtendentes
      LookupKeyFields = 'ID'
      LookupResultField = 'NOME'
      KeyFields = 'Id_Atd'
      Size = 30
      Lookup = True
    end
    object cdsAtdsLKUP_ID_GRUPO: TIntegerField
      FieldKind = fkLookup
      FieldName = 'LKUP_ID_GRUPO'
      LookupDataSet = dmSicsMain.cdsAtendentes
      LookupKeyFields = 'ID'
      LookupResultField = 'ID_GRUPOATENDENTE'
      KeyFields = 'Id_Atd'
      Visible = False
      Lookup = True
    end
    object cdsAtdsLKUP_GRUPO: TStringField
      DisplayLabel = 'Grupo'
      FieldKind = fkLookup
      FieldName = 'LKUP_GRUPO'
      LookupDataSet = dmSicsMain.cdsGruposDeAtendentes
      LookupKeyFields = 'ID'
      LookupResultField = 'NOME'
      KeyFields = 'LKUP_ID_GRUPO'
      Size = 30
      Lookup = True
    end
    object cdsAtdsId_Status: TIntegerField
      FieldName = 'Id_Status'
      Visible = False
    end
    object cdsAtdsLKUP_STATUS: TStringField
      DisplayLabel = 'Estado'
      FieldKind = fkLookup
      FieldName = 'LKUP_STATUS'
      LookupDataSet = dmSicsMain.cdsStatusDasPAs
      LookupKeyFields = 'ID'
      LookupResultField = 'NOME'
      KeyFields = 'Id_Status'
      Size = 30
      Lookup = True
    end
    object IntegerField1: TIntegerField
      FieldName = 'Id_PA'
      Visible = False
    end
    object cdsAtdsLKUP_PA: TStringField
      DisplayLabel = 'PA'
      FieldKind = fkLookup
      FieldName = 'LKUP_PA'
      LookupDataSet = dmSicsMain.cdsPAs
      LookupKeyFields = 'ID'
      LookupResultField = 'NOME'
      KeyFields = 'Id_PA'
      Lookup = True
    end
    object IntegerField3: TIntegerField
      FieldName = 'Id_Senha'
      Visible = False
    end
    object IntegerField4: TIntegerField
      Alignment = taCenter
      DisplayLabel = 'Senha'
      FieldName = 'SENHA'
    end
    object cdsAtdsNomeCliente: TStringField
      FieldName = 'NomeCliente'
      Size = 60
    end
    object DateTimeField1: TSQLTimeStampField
      Alignment = taCenter
      FieldName = 'Horario'
      DisplayFormat = 'hh:nn:ss'
    end
    object cdsAtdsId_Fila: TIntegerField
      FieldName = 'Id_Fila'
      Visible = False
    end
    object cdsAtdsLKUP_FILA: TStringField
      DisplayLabel = 'Veio da fila'
      FieldKind = fkLookup
      FieldName = 'LKUP_FILA'
      LookupDataSet = dmSicsMain.cdsFilas
      LookupKeyFields = 'ID'
      LookupResultField = 'NOME'
      KeyFields = 'Id_Fila'
      Size = 30
      Lookup = True
    end
    object cdsAtdsId_MotivoPausa: TIntegerField
      FieldName = 'Id_MotivoPausa'
      Visible = False
    end
    object cdsAtdsLKUP_MOTIVOPAUSA: TStringField
      DisplayLabel = 'Motivo Pausa'
      FieldKind = fkLookup
      FieldName = 'LKUP_MOTIVOPAUSA'
      LookupDataSet = dmSicsMain.cdsMotivosDePausa
      LookupKeyFields = 'ID'
      LookupResultField = 'NOME'
      KeyFields = 'Id_MotivoPausa'
      Size = 60
      Lookup = True
    end
    object cdsAtdsHorarioLogin: TSQLTimeStampField
      Alignment = taCenter
      FieldName = 'HorarioLogin'
      DisplayFormat = 'hh:nn:ss'
    end
  end
  object dsAtds: TDataSource
    DataSet = cdsAtds
    Left = 384
    Top = 56
  end
  object TimerVerificarTimeOutPAS: TTimer
    Interval = 30000
    OnTimer = TimerVerificarTimeOutPASTimer
    Left = 344
    Top = 96
  end
  object cdsClonePAs: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 344
    Top = 152
  end
  object cdsCloneATDs: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 344
    Top = 192
  end
  object cdsPAsDisponiveisComChamadaAutomatica: TClientDataSet
    Aggregates = <>
    Filter = 'Id_Status = 1'
    IndexFieldNames = 'HORARIO'
    Params = <>
    Left = 344
    Top = 248
  end
  object ActionList1: TActionList
    Left = 80
    Top = 24
  end
  object dspAtendPAs: TDataSetProvider
    DataSet = qryAtendPAs
    Options = [poAutoRefresh, poPropogateChanges, poUseQuoteChar]
    UpdateMode = upWhereKeyOnly
    Left = 208
    Top = 176
  end
  object qryAtendPAs: TFDQuery
    Connection = dmSicsMain.connOnLine
    SQL.Strings = (
      'SELECT'
      '  A.*'
      'FROM'
      '  ATEND_PAS A'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE')
    Left = 144
    Top = 176
    ParamData = <
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
    object qryAtendPAsID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
      Origin = 'ID_UNIDADE'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qryAtendPAsID: TIntegerField
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qryAtendPAsID_PA: TIntegerField
      FieldName = 'ID_PA'
      Origin = 'ID_PA'
      ProviderFlags = [pfInUpdate]
    end
    object qryAtendPAsID_STATUS: TIntegerField
      FieldName = 'ID_STATUS'
      Origin = 'ID_STATUS'
      ProviderFlags = [pfInUpdate]
    end
    object qryAtendPAsID_ATD: TIntegerField
      FieldName = 'ID_ATD'
      Origin = 'ID_ATD'
      ProviderFlags = [pfInUpdate]
    end
    object qryAtendPAsID_SENHA: TIntegerField
      FieldName = 'ID_SENHA'
      Origin = 'ID_SENHA'
      ProviderFlags = [pfInUpdate]
    end
    object qryAtendPAsSENHA: TIntegerField
      FieldName = 'SENHA'
      Origin = 'SENHA'
      ProviderFlags = [pfInUpdate]
    end
    object qryAtendPAsNOMECLIENTE: TStringField
      FieldName = 'NOMECLIENTE'
      Origin = 'NOMECLIENTE'
      ProviderFlags = [pfInUpdate]
      Size = 60
    end
    object qryAtendPAsHORARIO: TSQLTimeStampField
      FieldName = 'HORARIO'
      Origin = 'HORARIO'
      ProviderFlags = [pfInUpdate]
    end
    object qryAtendPAsID_FILA: TIntegerField
      FieldName = 'ID_FILA'
      Origin = 'ID_FILA'
      ProviderFlags = [pfInUpdate]
    end
    object qryAtendPAsID_MOTIVOPAUSA: TIntegerField
      FieldName = 'ID_MOTIVOPAUSA'
      Origin = 'ID_MOTIVOPAUSA'
      ProviderFlags = [pfInUpdate]
    end
    object qryAtendPAsID_ATENDENTE_AUTOLOGIN: TIntegerField
      FieldName = 'ID_ATENDENTE_AUTOLOGIN'
      Origin = 'ID_ATENDENTE_AUTOLOGIN'
      ProviderFlags = [pfInUpdate]
    end
    object qryAtendPAsATIVO: TStringField
      FieldName = 'ATIVO'
      Origin = 'ATIVO'
      ProviderFlags = [pfInUpdate]
      FixedChar = True
      Size = 1
    end
    object qryAtendPAsPOSICAO: TIntegerField
      FieldName = 'POSICAO'
      Origin = 'POSICAO'
      ProviderFlags = [pfInUpdate]
    end
    object qryAtendPAsHORARIOLOGIN: TSQLTimeStampField
      FieldName = 'HORARIOLOGIN'
      Origin = 'HORARIOLOGIN'
      ProviderFlags = [pfInUpdate]
    end
  end
  object dspAtendAtds: TDataSetProvider
    DataSet = qryAtendAtds
    Options = [poAutoRefresh, poPropogateChanges, poUseQuoteChar]
    UpdateMode = upWhereKeyOnly
    Left = 208
    Top = 128
  end
  object qryAtendAtds: TFDQuery
    Connection = dmSicsMain.connOnLine
    SQL.Strings = (
      'SELECT'
      '  S.*'
      'FROM'
      '  ATEND_ATDS S'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE')
    Left = 144
    Top = 128
    ParamData = <
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
    object qryAtendAtdsID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qryAtendAtdsID: TIntegerField
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qryAtendAtdsID_ATD: TIntegerField
      FieldName = 'ID_ATD'
      Origin = 'ID_ATD'
      ProviderFlags = [pfInUpdate]
    end
    object qryAtendAtdsID_STATUS: TIntegerField
      FieldName = 'ID_STATUS'
      Origin = 'ID_STATUS'
      ProviderFlags = [pfInUpdate]
    end
    object qryAtendAtdsID_PA: TIntegerField
      FieldName = 'ID_PA'
      Origin = 'ID_PA'
      ProviderFlags = [pfInUpdate]
    end
    object qryAtendAtdsID_SENHA: TIntegerField
      FieldName = 'ID_SENHA'
      Origin = 'ID_SENHA'
      ProviderFlags = [pfInUpdate]
    end
    object qryAtendAtdsSENHA: TIntegerField
      FieldName = 'SENHA'
      Origin = 'SENHA'
      ProviderFlags = [pfInUpdate]
    end
    object qryAtendAtdsNOMECLIENTE: TStringField
      FieldName = 'NOMECLIENTE'
      Origin = 'NOMECLIENTE'
      ProviderFlags = [pfInUpdate]
      Size = 60
    end
    object qryAtendAtdsHORARIO: TSQLTimeStampField
      FieldName = 'HORARIO'
      Origin = 'HORARIO'
      ProviderFlags = [pfInUpdate]
    end
    object qryAtendAtdsID_FILA: TIntegerField
      FieldName = 'ID_FILA'
      Origin = 'ID_FILA'
      ProviderFlags = [pfInUpdate]
    end
    object qryAtendAtdsID_MOTIVOPAUSA: TIntegerField
      FieldName = 'ID_MOTIVOPAUSA'
      Origin = 'ID_MOTIVOPAUSA'
      ProviderFlags = [pfInUpdate]
    end
    object qryAtendAtdsHORARIOLOGIN: TSQLTimeStampField
      FieldName = 'HORARIOLOGIN'
      Origin = 'HORARIOLOGIN'
      ProviderFlags = [pfInUpdate]
    end
  end
end
