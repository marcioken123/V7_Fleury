inherited dmSicsCadPIS: TdmSicsCadPIS
  OldCreateOrder = True
  OnCreate = DataModuleCreate
  Height = 382
  Width = 554
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
    AfterPost = cdsPisAfterPost
    BeforeDelete = cdsPisBeforeDelete
    OnNewRecord = cdsPisNewRecord
    OnReconcileError = cdsPisReconcileError
    AfterApplyUpdates = cdsPisAfterApplyUpdates
    Left = 33
    Top = 40
    object cdsPisID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
      Origin = 'ID_UNIDADE'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object cdsPisID_PI: TSmallintField
      FieldName = 'ID_PI'
      Origin = 'ID_PI'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object cdsPisID_PITIPO: TSmallintField
      FieldName = 'ID_PITIPO'
      Origin = 'ID_PITIPO'
    end
    object cdsPisID_PIFUNCAO: TSmallintField
      FieldName = 'ID_PIFUNCAO'
      Origin = 'ID_PIFUNCAO'
    end
    object cdsPisID_PIPOS: TSmallintField
      FieldName = 'ID_PIPOS'
      Origin = 'ID_PIPOS'
    end
    object cdsPisNOME: TStringField
      FieldName = 'NOME'
      Origin = 'NOME'
      Size = 60
    end
    object cdsPisCARACTERES: TIntegerField
      FieldName = 'CARACTERES'
      Origin = 'CARACTERES'
    end
    object cdsPisIDSRELACIONADOS: TStringField
      FieldName = 'IDSRELACIONADOS'
      Origin = 'IDSRELACIONADOS'
      Size = 1000
    end
    object cdsPisFAZERLOG: TStringField
      FieldName = 'FAZERLOG'
      Origin = 'FAZERLOG'
      FixedChar = True
      Size = 1
    end
    object cdsPisqyPisRelacionados: TDataSetField
      FieldName = 'qyPisRelacionados'
    end
    object cdsPisCALC_SELECIONADO: TBooleanField
      FieldKind = fkInternalCalc
      FieldName = 'CALC_SELECIONADO'
    end
    object cdsPisID: TIntegerField
      FieldKind = fkInternalCalc
      FieldName = 'ID'
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
    Connection = dmSicsMain.connOnLine
    SQL.Strings = (
      'SELECT'
      '  * '
      'FROM '
      '  PIS'
      'WHERE '
      '  ID_UNIDADE = :ID_UNIDADE')
    Left = 32
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
    Left = 216
    Top = 40
    object cdsTiposID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
      Required = True
    end
    object cdsTiposID_PITIPO: TSmallintField
      FieldName = 'ID_PITIPO'
      Required = True
    end
    object cdsTiposNOME: TStringField
      FieldName = 'NOME'
      Size = 60
    end
    object cdsTiposTABELARELACIONADA: TStringField
      FieldName = 'TABELARELACIONADA'
      Size = 30
    end
    object cdsTiposFORMATOHORARIO: TStringField
      FieldName = 'FORMATOHORARIO'
      FixedChar = True
      Size = 1
    end
    object cdsTiposINTCALC_NOME: TStringField
      FieldKind = fkInternalCalc
      FieldName = 'INTCALC_NOME'
      Size = 80
    end
  end
  object dspTipos: TDataSetProvider
    DataSet = qryTipos
    Left = 216
    Top = 88
  end
  object qryTipos: TFDQuery
    Connection = dmSicsMain.connOnLine
    SQL.Strings = (
      'select '
      '  * '
      'from '
      '  PIS_TIPOS'
      'where'
      '  ID_UNIDADE = :ID_UNIDADE')
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
    Left = 280
    Top = 40
    object cdsFuncaoID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
      Required = True
    end
    object cdsFuncaoID_PIFUNCAO: TSmallintField
      FieldName = 'ID_PIFUNCAO'
      Required = True
    end
    object cdsFuncaoNOME: TStringField
      FieldName = 'NOME'
      Size = 30
    end
  end
  object dspFuncao: TDataSetProvider
    DataSet = qryFuncao
    Left = 280
    Top = 88
  end
  object qryFuncao: TFDQuery
    Connection = dmSicsMain.connOnLine
    SQL.Strings = (
      'select '
      '  * '
      'from '
      '  PIS_FUNCOES'
      'where'
      '  ID_UNIDADE = :ID_UNIDADE')
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
    Left = 376
    Top = 160
    object cdsFilasID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
      Required = True
    end
    object cdsFilasID: TIntegerField
      FieldName = 'ID'
      Required = True
    end
    object cdsFilasNOME: TStringField
      FieldName = 'NOME'
      Size = 30
    end
    object cdsFilasCALC_SELECIONADO: TBooleanField
      Tag = 1
      FieldKind = fkInternalCalc
      FieldName = 'CALC_SELECIONADO'
    end
  end
  object dspFilas: TDataSetProvider
    DataSet = qryFilas
    Left = 376
    Top = 208
  end
  object qryFilas: TFDQuery
    Connection = dmSicsMain.connOnLine
    SQL.Strings = (
      'SELECT'
      '  ID_UNIDADE,'
      '  ID,'
      '  NOME'
      'FROM'
      '  FILAS'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE')
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
    OnCalcFields = cdsPASCalcFields
    Left = 424
    Top = 160
    object cdsPASID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
      Required = True
    end
    object cdsPASID: TIntegerField
      FieldName = 'ID'
      Required = True
    end
    object cdsPASNOME: TStringField
      FieldName = 'NOME'
      Size = 30
    end
    object cdsPASCALC_SELECIONADO: TBooleanField
      FieldKind = fkInternalCalc
      FieldName = 'CALC_SELECIONADO'
    end
  end
  object dspPAS: TDataSetProvider
    DataSet = qryPAS
    Left = 424
    Top = 208
  end
  object qryPAS: TFDQuery
    Connection = dmSicsMain.connOnLine
    SQL.Strings = (
      'SELECT '
      '  ID_UNIDADE,'
      '  ID,'
      '  NOME'
      'FROM'
      '  PAS'
      'WHERE'
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
    Left = 112
    Top = 72
  end
  object qyPisRelacionados: TFDQuery
    MasterSource = dtsLinkPis
    MasterFields = 'ID_PI;ID_UNIDADE'
    DetailFields = 'ID_PI;ID_UNIDADE'
    Connection = dmSicsMain.connOnLine
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
      '  ID_PI = :ID_PI')
    Left = 112
    Top = 120
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
  end
  object dtsLinkPis: TDataSource
    DataSet = qryPis
    Left = 80
    Top = 176
  end
  object cdSPisClone: TClientDataSet
    Aggregates = <>
    Params = <>
    OnCalcFields = cdSPisCloneCalcFields
    Left = 184
    Top = 224
  end
  object cdsValoresEmBD: TClientDataSet
    Aggregates = <>
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspValoresEmBD'
    OnCalcFields = cdsValoresEmBDCalcFields
    Left = 488
    Top = 160
    object cdsValoresEmBDID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
      Required = True
    end
    object cdsValoresEmBDID: TIntegerField
      FieldName = 'ID'
      Required = True
    end
    object cdsValoresEmBDNOME: TStringField
      FieldName = 'NOME'
      Size = 100
    end
    object cdsValoresEmBDVALOR: TStringField
      FieldName = 'VALOR'
      Size = 100
    end
    object cdsValoresEmBDULTIMO_VALOR_EM: TSQLTimeStampField
      FieldName = 'ULTIMO_VALOR_EM'
    end
    object cdsValoresEmBDCALC_SELECIONADO: TBooleanField
      FieldKind = fkInternalCalc
      FieldName = 'CALC_SELECIONADO'
    end
  end
  object dspValoresEmBD: TDataSetProvider
    DataSet = qryValoresEmBD
    Left = 488
    Top = 208
  end
  object qryValoresEmBD: TFDQuery
    Connection = dmSicsMain.connOnLine
    SQL.Strings = (
      'SELECT'
      '  ID_UNIDADE,'
      '  ID,'
      '  NOME,'
      '  VALOR,'
      '  ULTIMO_VALOR_EM'
      'FROM'
      '  PIS_VALORES_EM_BD'
      'WHERE'
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
