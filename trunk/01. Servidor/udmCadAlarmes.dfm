object dmSicsCadAlarmes: TdmSicsCadAlarmes
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 404
  Width = 642
  object cdsMonitoramentos: TClientDataSet
    Aggregates = <>
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspMonitoramentos'
    BeforePost = cdsMonitoramentosBeforePost
    BeforeDelete = cdsMonitoramentosBeforeDelete
    OnNewRecord = cdsMonitoramentosNewRecord
    OnReconcileError = cdsMonitoramentosReconcileError
    AfterApplyUpdates = cdsMonitoramentosAfterApplyUpdates
    Left = 56
    Top = 32
    object cdsMonitoramentosID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
      Origin = 'ID_UNIDADE'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object cdsMonitoramentosID_PIMONITORAMENTO: TSmallintField
      FieldName = 'ID_PIMONITORAMENTO'
      Origin = 'ID_PIMONITORAMENTO'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object cdsMonitoramentosID_PI: TSmallintField
      FieldName = 'ID_PI'
      Origin = 'ID_PI'
    end
    object cdsMonitoramentosID_PIHORARIO: TSmallintField
      FieldName = 'ID_PIHORARIO'
      Origin = 'ID_PIHORARIO'
    end
    object cdsMonitoramentosLKP_HORARIO: TStringField
      FieldKind = fkLookup
      FieldName = 'LKP_HORARIO'
      LookupDataSet = cdsHorarios
      LookupKeyFields = 'ID_PIHORARIO'
      LookupResultField = 'NOME'
      KeyFields = 'ID_PIHORARIO'
      Size = 30
      Lookup = True
    end
    object cdsMonitoramentosLKP_PI: TStringField
      FieldKind = fkLookup
      FieldName = 'LKP_PI'
      LookupDataSet = cdsPIS
      LookupKeyFields = 'ID_PI'
      LookupResultField = 'NOME'
      KeyFields = 'ID_PI'
      Size = 30
      Lookup = True
    end
    object cdsMonitoramentosqryAlarmes: TDataSetField
      FieldName = 'qryAlarmes'
    end
  end
  object dspMonitoramentos: TDataSetProvider
    DataSet = qryMonitoramentos
    Options = [poPropogateChanges]
    BeforeUpdateRecord = dspMonitoramentosBeforeUpdateRecord
    Left = 56
    Top = 80
  end
  object qryMonitoramentos: TFDQuery
    Connection = dmSicsMain.connOnLine
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
    Left = 56
    Top = 128
    ParamData = <
      item
        Position = 1
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
      end>
  end
  object cdsAlarmes: TClientDataSet
    Aggregates = <>
    DataSetField = cdsMonitoramentosqryAlarmes
    IndexFieldNames = 'INTCALC_POSICAONIVEL'
    Params = <>
    BeforeDelete = cdsAlarmesBeforeDelete
    OnCalcFields = cdsAlarmesCalcFields
    OnNewRecord = cdsAlarmesNewRecord
    Left = 232
    Top = 64
    object cdsAlarmesID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
      Origin = 'ID_UNIDADE'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object cdsAlarmesID_PIALARME: TSmallintField
      FieldName = 'ID_PIALARME'
      Origin = 'ID_PIALARME'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object cdsAlarmesID_PIMONITORAMENTO: TSmallintField
      FieldName = 'ID_PIMONITORAMENTO'
      Origin = 'ID_PIMONITORAMENTO'
    end
    object cdsAlarmesID_PINIVEL: TSmallintField
      FieldName = 'ID_PINIVEL'
      Origin = 'ID_PINIVEL'
    end
    object cdsAlarmesID_PIACAODEALARME: TSmallintField
      FieldName = 'ID_PIACAODEALARME'
      Origin = 'ID_PIACAODEALARME'
      OnValidate = cdsAlarmesID_PIACAODEALARMEValidate
    end
    object cdsAlarmesSUPERIOR: TStringField
      FieldName = 'SUPERIOR'
      Origin = 'SUPERIOR'
      FixedChar = True
      Size = 1
    end
    object cdsAlarmesMENSAGEM: TStringField
      FieldName = 'MENSAGEM'
      Origin = 'MENSAGEM'
      Size = 1000
    end
    object cdsAlarmesLKP_ACAOALARME: TStringField
      FieldKind = fkLookup
      FieldName = 'LKP_ACAOALARME'
      LookupDataSet = cdsAcoesAlarmes
      LookupKeyFields = 'ID_PIACAODEALARME'
      LookupResultField = 'NOME'
      KeyFields = 'ID_PIACAODEALARME'
      Size = 30
      Lookup = True
    end
    object cdsAlarmesLKP_NIVEL: TStringField
      FieldKind = fkLookup
      FieldName = 'LKP_NIVEL'
      LookupDataSet = cdsNiveis
      LookupKeyFields = 'ID_PINIVEL'
      LookupResultField = 'NOME'
      KeyFields = 'ID_PINIVEL'
      Size = 30
      Lookup = True
    end
    object cdsAlarmesLKP_COR: TIntegerField
      FieldKind = fkLookup
      FieldName = 'LKP_COR'
      LookupDataSet = cdsNiveis
      LookupKeyFields = 'ID_PINIVEL'
      LookupResultField = 'CODIGOCOR'
      KeyFields = 'ID_PINIVEL'
      Lookup = True
    end
    object cdsAlarmesLIMIAR: TFloatField
      FieldName = 'LIMIAR'
      Origin = 'LIMIAR'
      OnGetText = cdsAlarmesLIMIARGetText
      OnSetText = cdsAlarmesLIMIARSetText
    end
    object cdsAlarmesINTCALC_POSICAONIVEL: TIntegerField
      FieldKind = fkInternalCalc
      FieldName = 'INTCALC_POSICAONIVEL'
    end
    object cdsAlarmesqryAlarmesRelacionados: TDataSetField
      FieldName = 'qryAlarmesRelacionados'
    end
  end
  object qryAlarmes: TFDQuery
    MasterSource = dtsLinkMonitoramentos
    MasterFields = 'ID_UNIDADE;ID_PIMONITORAMENTO'
    DetailFields = 'ID_UNIDADE;ID_PIMONITORAMENTO'
    Connection = dmSicsMain.connOnLine
    FetchOptions.AssignedValues = [evCache]
    FetchOptions.Cache = [fiBlobs, fiMeta]
    SQL.Strings = (
      'SELECT'
      '  *'
      'FROM'
      '  PIS_ALARMES'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE AND'
      '  ID_PIMONITORAMENTO = :ID_PIMONITORAMENTO')
    Left = 232
    Top = 112
    ParamData = <
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'ID_PIMONITORAMENTO'
        DataType = ftSmallint
        ParamType = ptInput
        Value = Null
      end>
  end
  object dtsLinkMonitoramentos: TDataSource
    DataSet = qryMonitoramentos
    Left = 144
    Top = 104
  end
  object cdsHorarios: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'NOME'
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspHorarios'
    Left = 56
    Top = 200
  end
  object dspHorarios: TDataSetProvider
    DataSet = qryHorarios
    Left = 56
    Top = 248
  end
  object qryHorarios: TFDQuery
    Connection = dmSicsMain.connOnLine
    SQL.Strings = (
      'SELECT'
      '  ID_PIHORARIO,'
      '  NOME'
      'FROM'
      '  PIS_HORARIOS'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE')
    Left = 56
    Top = 296
    ParamData = <
      item
        Position = 1
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
      end>
  end
  object cdsPIS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'NOME'
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspPIS'
    Left = 120
    Top = 200
  end
  object dspPIS: TDataSetProvider
    DataSet = qryPIS
    Left = 120
    Top = 248
  end
  object qryPIS: TFDQuery
    Connection = dmSicsMain.connOnLine
    SQL.Strings = (
      'SELECT'
      '  PIS.ID_UNIDADE,'
      '  PIS.ID_PI,'
      '  PIS.NOME,'
      '  T.FORMATOHORARIO,'
      '  PIS.ID_PITIPO'
      'FROM'
      '  PIS '
      '  INNER JOIN PIS_TIPOS T ON (T.ID_UNIDADE = PIS.ID_UNIDADE AND '
      '                             T.ID_PITIPO  = PIS.ID_PITIPO)'
      'WHERE'
      '  PIS.ID_UNIDADE = :ID_UNIDADE')
    Left = 120
    Top = 296
    ParamData = <
      item
        Position = 1
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
      end>
  end
  object cdsAcoesAlarmes: TClientDataSet
    Aggregates = <>
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspAcoesAlarmes'
    Left = 184
    Top = 200
  end
  object dspAcoesAlarmes: TDataSetProvider
    DataSet = qryAcoesAlarmes
    Left = 184
    Top = 248
  end
  object qryAcoesAlarmes: TFDQuery
    Connection = dmSicsMain.connOnLine
    SQL.Strings = (
      'SELECT'
      '  ID_UNIDADE,'
      '  ID_PIACAODEALARME,'
      '  NOME,'
      '  TABELARELACIONADA'
      'FROM'
      '  PIS_ACOES_DE_ALARMES'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE')
    Left = 184
    Top = 296
    ParamData = <
      item
        Position = 1
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
      end>
  end
  object cdsNiveis: TClientDataSet
    Aggregates = <>
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspNiveis'
    Left = 264
    Top = 200
  end
  object dspNiveis: TDataSetProvider
    DataSet = qryNiveis
    Left = 264
    Top = 248
  end
  object qryNiveis: TFDQuery
    Connection = dmSicsMain.connOnLine
    SQL.Strings = (
      'SELECT'
      '  ID_UNIDADE,'
      '  ID_PINIVEL,'
      '  NOME,'
      '  CODIGOCOR,'
      '  POSICAO'
      'FROM'
      '  PIS_NIVEIS'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE')
    Left = 264
    Top = 296
    ParamData = <
      item
        Position = 1
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
      end>
  end
  object cdsEmails: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'NOME'
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspEmails'
    OnCalcFields = cdsEmailsCalcFields
    Left = 328
    Top = 200
    object cdsEmailsCALC_SELECIONADO: TBooleanField
      DisplayLabel = 'Selecionar'
      FieldKind = fkCalculated
      FieldName = 'CALC_SELECIONADO'
      Calculated = True
    end
    object cdsEmailsID: TIntegerField
      FieldName = 'ID'
      Required = True
    end
    object cdsEmailsNOME: TStringField
      FieldName = 'NOME'
      Size = 30
    end
  end
  object dspEmails: TDataSetProvider
    DataSet = qryEmails
    Left = 328
    Top = 248
  end
  object qryEmails: TFDQuery
    Connection = dmSicsMain.connOnLine
    SQL.Strings = (
      'SELECT'
      '  ID_UNIDADE,'
      '  ID,'
      '  NOME'
      'FROM'
      '  EMAILS'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE')
    Left = 328
    Top = 296
    ParamData = <
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object cdsCelulares: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'NOME'
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspCelulares'
    OnCalcFields = cdsEmailsCalcFields
    Left = 392
    Top = 200
    object cdsCelularesID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
      Required = True
    end
    object cdsCelularesID: TIntegerField
      FieldName = 'ID'
      Required = True
    end
    object cdsCelularesNOME: TStringField
      FieldName = 'NOME'
      Size = 30
    end
    object cdsCelularesCALC_SELECIONADO: TBooleanField
      DisplayLabel = 'Selecionar'
      FieldKind = fkCalculated
      FieldName = 'CALC_SELECIONADO'
      Calculated = True
    end
  end
  object dspCelulares: TDataSetProvider
    DataSet = qryCelulares
    Left = 392
    Top = 248
  end
  object qryCelulares: TFDQuery
    Connection = dmSicsMain.connOnLine
    SQL.Strings = (
      'SELECT'
      '  ID_UNIDADE,'
      '  ID,'
      '  NOME'
      'FROM'
      '  CELULARES'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE')
    Left = 392
    Top = 296
    ParamData = <
      item
        Position = 1
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
      end>
  end
  object cdsGruposPas: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'NOME'
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspGruposPas'
    OnCalcFields = cdsEmailsCalcFields
    Left = 464
    Top = 200
    object cdsGruposPasID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
      Required = True
    end
    object cdsGruposPasID: TIntegerField
      FieldName = 'ID'
      Required = True
    end
    object cdsGruposPasNOME: TStringField
      FieldName = 'NOME'
      Size = 30
    end
    object cdsGruposPasCALC_SELECIONADO: TBooleanField
      Tag = 1
      DisplayLabel = 'Selecionar'
      FieldKind = fkCalculated
      FieldName = 'CALC_SELECIONADO'
      Calculated = True
    end
  end
  object dspGruposPas: TDataSetProvider
    DataSet = qryGruposPas
    Left = 464
    Top = 248
  end
  object qryGruposPas: TFDQuery
    Connection = dmSicsMain.connOnLine
    SQL.Strings = (
      'SELECT'
      '  ID_UNIDADE,'
      '  ID,'
      '  NOME'
      'FROM'
      '  GRUPOS_PAS'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE')
    Left = 464
    Top = 296
    ParamData = <
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object cdsPaineis: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'NOME'
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspPaineis'
    OnCalcFields = cdsEmailsCalcFields
    Left = 536
    Top = 200
    object cdsPaineisID: TIntegerField
      FieldName = 'ID'
      Required = True
    end
    object cdsPaineisNOME: TStringField
      FieldName = 'NOME'
      Size = 30
    end
    object cdsPaineisID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
      Required = True
    end
    object cdsPaineisCALC_SELECIONADO: TBooleanField
      DisplayLabel = 'Selecionar'
      FieldKind = fkCalculated
      FieldName = 'CALC_SELECIONADO'
      Calculated = True
    end
  end
  object dspPaineis: TDataSetProvider
    DataSet = qryPaineis
    Left = 536
    Top = 248
  end
  object qryPaineis: TFDQuery
    Connection = dmSicsMain.connOnLine
    SQL.Strings = (
      'SELECT'
      '  ID_UNIDADE,'
      '  ID,'
      '  NOME'
      'FROM'
      '  PAINEIS'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE'
      '')
    Left = 536
    Top = 296
    ParamData = <
      item
        Position = 1
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
      end>
  end
  object cdsAlarmesRelacionados: TClientDataSet
    Aggregates = <>
    DataSetField = cdsAlarmesqryAlarmesRelacionados
    Params = <>
    Left = 400
    Top = 64
    object cdsAlarmesRelacionadosID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
      Origin = 'ID_UNIDADE'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object cdsAlarmesRelacionadosID_PIALARME: TSmallintField
      FieldName = 'ID_PIALARME'
      Origin = 'ID_PIALARME'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object cdsAlarmesRelacionadosID_RELACIONADO: TIntegerField
      FieldName = 'ID_RELACIONADO'
      Origin = 'ID_RELACIONADO'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
  end
  object qryAlarmesRelacionados: TFDQuery
    MasterSource = dtsLinkAlarmes
    MasterFields = 'ID_UNIDADE;ID_PIALARME'
    DetailFields = 'ID_UNIDADE;ID_PIALARME'
    Connection = dmSicsMain.connOnLine
    FetchOptions.AssignedValues = [evCache]
    FetchOptions.Cache = [fiBlobs, fiMeta]
    SQL.Strings = (
      'SELECT'
      '  ID_UNIDADE,'
      '  ID_PIALARME,'
      '  ID_RELACIONADO'
      'FROM'
      '  PIS_ALARMES_RELACIONADOS'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE AND'
      '  ID_PIALARME = :ID_PIALARME')
    Left = 400
    Top = 112
    ParamData = <
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'ID_PIALARME'
        DataType = ftSmallint
        ParamType = ptInput
        Value = Null
      end>
  end
  object dtsLinkAlarmes: TDataSource
    DataSet = qryAlarmes
    Left = 304
    Top = 96
  end
end
