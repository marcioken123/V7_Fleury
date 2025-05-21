inherited dmSicsCadPIS: TdmSicsCadPIS
  OnCreate = DataModuleCreate
  Height = 382
  Width = 586
  inherited dtsMain: TDataSource
    DataSet = cdsPis
    Left = 158
    Top = 176
  end
  object cdsPis: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'ID_PI'
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspPis'
    AfterOpen = cdsPisAfterOpen
    BeforeDelete = cdsPisBeforeDelete
    OnNewRecord = cdsPisNewRecord
    OnReconcileError = cdsPisReconcileError
    Left = 31
    Top = 40
    object cdsPisID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
      Origin = 'ID_UNIDADE'
      Required = True
    end
    object cdsPisID_PI: TSmallintField
      DisplayLabel = 'ID PI'
      DisplayWidth = 40
      FieldName = 'ID_PI'
      Origin = 'ID_PI'
      Required = True
    end
    object cdsPisID_PITIPO: TSmallintField
      DisplayLabel = 'ID Tipo'
      DisplayWidth = 60
      FieldName = 'ID_PITIPO'
      Origin = 'ID_PITIPO'
      Visible = False
      OnValidate = cdsPisID_PITIPOValidate
    end
    object cdsPisID_PIFUNCAO: TSmallintField
      DisplayLabel = 'ID Fun'#231#227'o'
      DisplayWidth = 60
      FieldName = 'ID_PIFUNCAO'
      Origin = 'ID_PIFUNCAO'
      Visible = False
    end
    object cdsPisID_PIPOS: TSmallintField
      DisplayLabel = 'ID Pipos'
      DisplayWidth = 60
      FieldName = 'ID_PIPOS'
      Origin = 'ID_PIPOS'
      Visible = False
    end
    object cdsPisNOME: TStringField
      DisplayLabel = 'Nome'
      DisplayWidth = 120
      FieldName = 'NOME'
      Origin = 'NOME'
      Size = 60
    end
    object cdsPisCARACTERES: TIntegerField
      DisplayLabel = 'Caracteres'
      DisplayWidth = 60
      FieldName = 'CARACTERES'
      Origin = 'CARACTERES'
      Visible = False
    end
    object cdsPisIDSRELACIONADOS: TStringField
      DisplayLabel = 'IDs Relacionados'
      DisplayWidth = 60
      FieldName = 'IDSRELACIONADOS'
      Origin = 'IDSRELACIONADOS'
      Visible = False
      Size = 1000
    end
    object cdsPisFAZERLOG: TStringField
      DisplayLabel = 'Fazer Log'
      DisplayWidth = 60
      FieldName = 'FAZERLOG'
      Origin = 'FAZERLOG'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object cdsPisqyPisRelacionados: TDataSetField
      DisplayWidth = 60
      FieldName = 'qyPisRelacionados'
      Visible = False
    end
    object cdsPisCALC_SELECIONADO: TBooleanField
      DisplayLabel = 'Selecionado'
      FieldKind = fkInternalCalc
      FieldName = 'CALC_SELECIONADO'
      Visible = False
    end
    object cdsPisID: TIntegerField
      DisplayWidth = 60
      FieldKind = fkInternalCalc
      FieldName = 'ID'
      Visible = False
    end
  end
  object dspPis: TDataSetProvider
    DataSet = qryPis
    Options = [poPropogateChanges]
    BeforeUpdateRecord = dspPisBeforeUpdateRecord
    Left = 32
    Top = 88
  end
  object qryPis: TFDQuery
    SQL.Strings = (
      'select * from PIS WHERE ID_UNIDADE = :ID_UNIDADE')
    Left = 30
    Top = 136
    ParamData = <
      item
        Position = 1
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
      end>
  end
  object cdsTipos: TClientDataSet
    Aggregates = <>
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspTipos'
    OnCalcFields = cdsTiposCalcFields
    Left = 215
    Top = 39
    object cdsTiposID_PITIPO: TSmallintField
      DisplayLabel = 'ID'
      DisplayWidth = 60
      FieldName = 'ID_PITIPO'
      Required = True
    end
    object cdsTiposNOME: TStringField
      DisplayLabel = 'Nome'
      DisplayWidth = 60
      FieldName = 'NOME'
      Size = 60
    end
    object cdsTiposTABELARELACIONADA: TStringField
      DisplayLabel = 'Tabela Relacionada'
      DisplayWidth = 60
      FieldName = 'TABELARELACIONADA'
      Size = 30
    end
    object cdsTiposFORMATOHORARIO: TStringField
      DisplayLabel = 'Hor'#225'rio'
      DisplayWidth = 60
      FieldName = 'FORMATOHORARIO'
      FixedChar = True
      Size = 1
    end
    object cdsTiposINTCALC_NOME: TStringField
      DisplayLabel = 'Nome'
      DisplayWidth = 60
      FieldKind = fkInternalCalc
      FieldName = 'INTCALC_NOME'
      Size = 80
    end
    object cdsTiposID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
      Required = True
    end
  end
  object dspTipos: TDataSetProvider
    DataSet = qryTipos
    Left = 216
    Top = 88
  end
  object qryTipos: TFDQuery
    SQL.Strings = (
      'select * from PIS_TIPOS WHERE ID_UNIDADE = :ID_UNIDADE')
    Left = 216
    Top = 136
    ParamData = <
      item
        Position = 1
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
      end>
  end
  object cdsFuncao: TClientDataSet
    Aggregates = <>
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspFuncao'
    Left = 281
    Top = 41
    object cdsFuncaoID_PIFUNCAO: TSmallintField
      DisplayLabel = 'ID'
      DisplayWidth = 60
      FieldName = 'ID_PIFUNCAO'
      Required = True
    end
    object cdsFuncaoNOME: TStringField
      DisplayLabel = 'Nome'
      DisplayWidth = 60
      FieldName = 'NOME'
      Size = 30
    end
    object cdsFuncaoID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
      Required = True
    end
  end
  object dspFuncao: TDataSetProvider
    DataSet = qryFuncao
    Left = 280
    Top = 88
  end
  object qryFuncao: TFDQuery
    SQL.Strings = (
      'select * from PIS_FUNCOES WHERE ID_UNIDADE = :ID_UNIDADE')
    Left = 280
    Top = 136
    ParamData = <
      item
        Position = 1
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
      end>
  end
  object cdsFilas: TClientDataSet
    Aggregates = <>
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspFilas'
    OnCalcFields = cdsFilasCalcFields
    Left = 378
    Top = 162
    object cdsFilasID: TIntegerField
      DisplayWidth = 60
      FieldName = 'ID'
      Required = True
      Visible = False
    end
    object cdsFilasNOME: TStringField
      DisplayLabel = 'Nome'
      DisplayWidth = 150
      FieldName = 'NOME'
      Size = 30
    end
    object cdsFilasCALC_SELECIONADO: TBooleanField
      Tag = 1
      DisplayLabel = ' '
      DisplayWidth = 60
      FieldKind = fkInternalCalc
      FieldName = 'CALC_SELECIONADO'
      OnChange = cdsFilasCALC_SELECIONADOChange
    end
    object cdsFilasID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
      Required = True
    end
  end
  object dspFilas: TDataSetProvider
    DataSet = qryFilas
    Left = 376
    Top = 208
  end
  object qryFilas: TFDQuery
    SQL.Strings = (
      'SELECT'
      '  ID_UNIDADE,'
      '  ID,'
      '  NOME'
      'FROM'
      '  FILAS'
      'WHERE '
      '  ID_UNIDADE = :ID_UNIDADE'
      '')
    Left = 376
    Top = 256
    ParamData = <
      item
        Position = 1
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
      end>
  end
  object cdsPAS: TClientDataSet
    Aggregates = <>
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspPAS'
    Left = 425
    Top = 160
    object cdsPASID: TIntegerField
      DisplayWidth = 60
      FieldName = 'ID'
      Required = True
    end
    object cdsPASNOME: TStringField
      DisplayLabel = 'Nome'
      DisplayWidth = 60
      FieldName = 'NOME'
      Size = 30
    end
    object cdsPASCALC_SELECIONADO: TBooleanField
      DisplayLabel = 'Selecionado'
      DisplayWidth = 60
      FieldKind = fkInternalCalc
      FieldName = 'CALC_SELECIONADO'
      OnChange = cdsPASCALC_SELECIONADOChange
    end
    object cdsPASID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
      Required = True
    end
  end
  object dspPAS: TDataSetProvider
    DataSet = qryPAS
    Left = 424
    Top = 208
  end
  object qryPAS: TFDQuery
    SQL.Strings = (
      'SELECT '
      '  ID_UNIDADE,'
      '  ID,'
      '  NOME'
      'FROM'
      '  PAS'
      'WHERE '
      '  ID_UNIDADE = :ID_UNIDADE')
    Left = 424
    Top = 256
    ParamData = <
      item
        Position = 1
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
      end>
  end
  object cdsPisRelacionados: TClientDataSet
    Aggregates = <>
    DataSetField = cdsPisqyPisRelacionados
    Params = <>
    Left = 110
    Top = 73
    object cdsPisRelacionadosID_PI: TSmallintField
      DisplayLabel = 'ID'
      DisplayWidth = 60
      FieldName = 'ID_PI'
      Required = True
    end
    object cdsPisRelacionadosID_RELACIONADO: TIntegerField
      DisplayLabel = 'ID Relacionado'
      DisplayWidth = 60
      FieldName = 'ID_RELACIONADO'
      Required = True
    end
    object cdsPisRelacionadosID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
      Origin = 'ID_UNIDADE'
      Required = True
    end
  end
  object qyPisRelacionados: TFDQuery
    MasterSource = dtsLinkPis
    MasterFields = 'ID_PI;ID_UNIDADE'
    DetailFields = 'ID_PI'
    FetchOptions.AssignedValues = [evCache]
    FetchOptions.Cache = [fiBlobs, fiMeta]
    SQL.Strings = (
      'SELECT'
      '  ID_UNIDADE,'
      '  ID_PI,'
      '  ID_RELACIONADO'
      'FROM'
      '  PIS_RELACIONADOS'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE AND'
      '  ID_PI = :ID_PI'
      '  ')
    Left = 112
    Top = 118
    ParamData = <
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'ID_PI'
        DataType = ftSmallint
        ParamType = ptInput
        Value = Null
      end>
    object qyPisRelacionadosID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
      Origin = 'ID_UNIDADE'
      ProviderFlags = [pfInUpdate, pfInKey]
      Required = True
    end
    object qyPisRelacionadosID_PI: TSmallintField
      FieldName = 'ID_PI'
      ProviderFlags = [pfInUpdate, pfInKey]
      Required = True
    end
    object qyPisRelacionadosID_RELACIONADO: TIntegerField
      FieldName = 'ID_RELACIONADO'
      ProviderFlags = [pfInUpdate, pfInKey]
      Required = True
    end
  end
  object dtsLinkPis: TDataSource
    DataSet = qryPis
    Left = 80
    Top = 176
  end
  object cdSPisClone: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 232
    Top = 224
  end
  object qryMonitoramentos: TFDQuery
    SQL.Strings = (
      'SELECT'
      '  ID_UNIDADE,'
      '  ID_PIMONITORAMENTO,'
      '  ID_PI,'
      '  ID_PIHORARIO'
      'FROM'
      '  PIS_MONITORAMENTOS'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE')
    Left = 32
    Top = 328
    ParamData = <
      item
        Position = 1
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
      end>
  end
  object dspMonitoramentos: TDataSetProvider
    DataSet = qryMonitoramentos
    Options = [poPropogateChanges]
    Left = 32
    Top = 280
  end
  object cdsMonitoramentos: TClientDataSet
    Aggregates = <>
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspMonitoramentos'
    Left = 31
    Top = 231
    object cdsMonitoramentosID_PIMONITORAMENTO: TSmallintField
      DisplayLabel = 'ID'
      DisplayWidth = 60
      FieldName = 'ID_PIMONITORAMENTO'
      Required = True
      Visible = False
    end
    object cdsMonitoramentosID_PIHORARIO: TSmallintField
      DisplayLabel = 'ID Hor'#225'rio'
      DisplayWidth = 100
      FieldName = 'ID_PIHORARIO'
    end
    object cdsMonitoramentosID_PI: TSmallintField
      DisplayLabel = 'ID PI'
      DisplayWidth = 60
      FieldName = 'ID_PI'
    end
    object cdsMonitoramentosID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
      Required = True
    end
  end
  object cdsValores: TClientDataSet
    Aggregates = <>
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspValores'
    Left = 489
    Top = 160
    object cdsValoresID: TIntegerField
      DisplayWidth = 60
      FieldName = 'ID'
      Required = True
    end
    object cdsValoresNOME: TStringField
      DisplayLabel = 'Nome'
      DisplayWidth = 60
      FieldName = 'NOME'
      Size = 30
    end
    object cdsValoresCALC_SELECIONADO: TBooleanField
      DisplayLabel = 'Selecionado'
      DisplayWidth = 60
      FieldKind = fkInternalCalc
      FieldName = 'CALC_SELECIONADO'
      OnChange = cdsValoresCALC_SELECIONADOChange
    end
    object cdsValoresID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
      Required = True
    end
  end
  object dspValores: TDataSetProvider
    DataSet = qryValores
    Left = 488
    Top = 208
  end
  object qryValores: TFDQuery
    SQL.Strings = (
      'SELECT '
      '  ID_UNIDADE,'
      '  ID,'
      '  NOME'
      'FROM'
      '  PIS_VALORES_EM_BD'
      'WHERE '
      '  ID_UNIDADE = :ID_UNIDADE')
    Left = 488
    Top = 256
    ParamData = <
      item
        Position = 1
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
      end>
  end
end
