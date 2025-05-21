inherited dmSicsCadAlarmes: TdmSicsCadAlarmes
  OnCreate = DataModuleCreate
  Height = 479
  Width = 866
  inherited dtsMain: TDataSource
    DataSet = cdsAlarmes
    Left = 163
    Top = 28
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
    BeforePost = cdsMonitoramentosBeforePost
    BeforeDelete = cdsMonitoramentosBeforeDelete
    OnNewRecord = cdsMonitoramentosNewRecord
    OnReconcileError = cdsMonitoramentosReconcileError
    Left = 55
    Top = 31
    object cdsMonitoramentosID_UNIDADE: TIntegerField
      DisplayLabel = 'ID'
      DisplayWidth = 60
      FieldName = 'ID_UNIDADE'
      Visible = False
    end
    object cdsMonitoramentosID_PIMONITORAMENTO: TSmallintField
      DisplayLabel = 'ID'
      DisplayWidth = 60
      FieldName = 'ID_PIMONITORAMENTO'
      Required = True
      Visible = False
    end
    object cdsMonitoramentosqryAlarmes: TDataSetField
      FieldName = 'qryAlarmes'
      Visible = False
    end
    object cdsMonitoramentosID_PIHORARIO: TSmallintField
      DisplayLabel = 'ID Hor'#225'rio'
      DisplayWidth = 100
      FieldName = 'ID_PIHORARIO'
    end
    object cdsMonitoramentosLKP_HORARIO: TStringField
      DisplayLabel = 'Hor'#225'rio'
      DisplayWidth = 100
      FieldKind = fkLookup
      FieldName = 'LKP_HORARIO'
      LookupDataSet = cdsHorarios
      LookupKeyFields = 'ID_PIHORARIO'
      LookupResultField = 'NOME'
      KeyFields = 'ID_PIHORARIO'
      Size = 30
      Lookup = True
    end
    object cdsMonitoramentosID_PI: TSmallintField
      DisplayLabel = 'ID PI'
      DisplayWidth = 60
      FieldName = 'ID_PI'
    end
    object cdsMonitoramentosLKP_PI: TStringField
      DisplayLabel = 'Indicador'
      DisplayWidth = 100
      FieldKind = fkLookup
      FieldName = 'LKP_PI'
      LookupDataSet = cdsPIS
      LookupKeyFields = 'ID_PI'
      LookupResultField = 'NOME'
      KeyFields = 'ID_PI'
      Size = 30
      Lookup = True
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
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object cdsAlarmes: TClientDataSet
    Aggregates = <>
    DataSetField = cdsMonitoramentosqryAlarmes
    IndexFieldNames = 'INTCALC_POSICAONIVEL'
    Params = <>
    AfterInsert = cdsAlarmesAfterInsert
    BeforeDelete = cdsAlarmesBeforeDelete
    OnCalcFields = cdsAlarmesCalcFields
    Left = 234
    Top = 62
    object cdsAlarmesID_UNIDADE: TIntegerField
      DisplayLabel = 'ID'
      DisplayWidth = 60
      FieldName = 'ID_UNIDADE'
      Visible = False
    end
    object cdsAlarmesID_PIALARME: TSmallintField
      DisplayLabel = 'ID'
      DisplayWidth = 60
      FieldName = 'ID_PIALARME'
      Required = True
      Visible = False
    end
    object cdsAlarmesID_PIMONITORAMENTO: TSmallintField
      DisplayLabel = 'ID Monitoramento'
      DisplayWidth = 60
      FieldName = 'ID_PIMONITORAMENTO'
      Visible = False
    end
    object cdsAlarmesID_PINIVEL: TSmallintField
      DisplayLabel = 'ID N'#237'vel'
      DisplayWidth = 60
      FieldName = 'ID_PINIVEL'
      Visible = False
    end
    object cdsAlarmesID_PIACAODEALARME: TSmallintField
      DisplayLabel = 'ID A'#231#227'o Alarme'
      DisplayWidth = 60
      FieldName = 'ID_PIACAODEALARME'
      Visible = False
      OnValidate = cdsAlarmesID_PIACAODEALARMEValidate
    end
    object cdsAlarmesSUPERIOR: TStringField
      DisplayLabel = 'Superior'
      DisplayWidth = 60
      FieldName = 'SUPERIOR'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object cdsAlarmesMENSAGEM: TStringField
      DisplayLabel = 'Mensagem'
      DisplayWidth = 60
      FieldName = 'MENSAGEM'
      Visible = False
      Size = 1000
    end
    object cdsAlarmesLKP_ACAOALARME: TStringField
      DisplayLabel = 'A'#231#227'o Alarme'
      DisplayWidth = 60
      FieldKind = fkLookup
      FieldName = 'LKP_ACAOALARME'
      LookupDataSet = cdsAcoesAlarmes
      LookupKeyFields = 'ID_PIACAODEALARME'
      LookupResultField = 'NOME'
      KeyFields = 'ID_PIACAODEALARME'
      Visible = False
      Size = 30
      Lookup = True
    end
    object cdsAlarmesLKP_COR: TIntegerField
      DisplayLabel = ' '
      DisplayWidth = 60
      FieldKind = fkLookup
      FieldName = 'LKP_COR'
      LookupDataSet = cdsNiveis
      LookupKeyFields = 'ID_PINIVEL'
      LookupResultField = 'CODIGOCOR'
      KeyFields = 'ID_PINIVEL'
      Lookup = True
    end
    object cdsAlarmesLKP_NIVEL: TStringField
      DisplayLabel = 'N'#237'vel'
      DisplayWidth = 200
      FieldKind = fkLookup
      FieldName = 'LKP_NIVEL'
      LookupDataSet = cdsNiveis
      LookupKeyFields = 'ID_PINIVEL'
      LookupResultField = 'NOME'
      KeyFields = 'ID_PINIVEL'
      Size = 30
      Lookup = True
    end
    object cdsAlarmesqryAlarmesRelacionados: TDataSetField
      DisplayWidth = 60
      FieldName = 'qryAlarmesRelacionados'
      Visible = False
    end
    object cdsAlarmesLIMIAR: TFloatField
      DisplayLabel = 'Limiar'
      DisplayWidth = 80
      FieldName = 'LIMIAR'
      OnGetText = cdsAlarmesLIMIARGetText
      OnSetText = cdsAlarmesLIMIARSetText
    end
    object cdsAlarmesINTCALC_POSICAONIVEL: TIntegerField
      DisplayLabel = 'Posi'#231#227'o'
      DisplayWidth = 60
      FieldKind = fkInternalCalc
      FieldName = 'INTCALC_POSICAONIVEL'
      Visible = False
    end
  end
  object qryAlarmes: TFDQuery
    MasterSource = dtsLinkMonitoramentos
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
        Size = 2
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
    object cdsHorariosID_PIHORARIO: TIntegerField
      FieldName = 'ID_PIHORARIO'
    end
    object cdsHorariosNOME: TStringField
      FieldName = 'NOME'
    end
  end
  object dspHorarios: TDataSetProvider
    DataSet = qryHorarios
    Left = 56
    Top = 248
  end
  object qryHorarios: TFDQuery
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
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
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
    Left = 119
    Top = 200
    object cdsPISNOME: TStringField
      FieldName = 'NOME'
    end
    object cdsPISFORMATOHORARIO: TStringField
      FieldName = 'FORMATOHORARIO'
    end
    object cdsPISID_PI: TIntegerField
      FieldName = 'ID_PI'
    end
    object cdsPISID_PITIPO: TSmallintField
      FieldName = 'ID_PITIPO'
    end
  end
  object dspPIS: TDataSetProvider
    DataSet = qryPIS
    Left = 120
    Top = 248
  end
  object qryPIS: TFDQuery
    SQL.Strings = (
      'SELECT'
      '  PIS.ID_PI,'
      '  PIS.NOME,'
      '  T.FORMATOHORARIO,'
      '  PIS.ID_PITIPO'
      'FROM'
      '  PIS '
      
        '  INNER JOIN PIS_TIPOS T ON T.ID_UNIDADE = PIS.ID_UNIDADE AND T.' +
        'ID_PITIPO = PIS.ID_PITIPO'
      'WHERE'
      '  PIS.ID_UNIDADE = :ID_UNIDADE')
    Left = 120
    Top = 296
    ParamData = <
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
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
    object cdsAcoesAlarmesID_PIACAODEALARME: TSmallintField
      DisplayLabel = 'ID'
      DisplayWidth = 60
      FieldName = 'ID_PIACAODEALARME'
      Required = True
    end
    object cdsAcoesAlarmesNOME: TStringField
      DisplayLabel = 'Nome'
      DisplayWidth = 80
      FieldName = 'NOME'
      Size = 30
    end
  end
  object dspAcoesAlarmes: TDataSetProvider
    DataSet = qryAcoesAlarmes
    Left = 184
    Top = 248
  end
  object qryAcoesAlarmes: TFDQuery
    SQL.Strings = (
      'SELECT'
      '  ID_PIACAODEALARME,'
      '  NOME'
      'FROM'
      '  PIS_ACOES_DE_ALARMES'
      ''
      '  '
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE')
    Left = 183
    Top = 297
    ParamData = <
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
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
    Left = 266
    Top = 200
    object cdsNiveisID_PINIVEL: TIntegerField
      FieldName = 'ID_PINIVEL'
    end
    object cdsNiveisNOME: TStringField
      FieldName = 'NOME'
    end
    object cdsNiveisCODIGOCOR: TIntegerField
      FieldName = 'CODIGOCOR'
    end
    object cdsNiveisPOSICAO: TIntegerField
      FieldName = 'POSICAO'
    end
  end
  object dspNiveis: TDataSetProvider
    DataSet = qryNiveis
    Left = 264
    Top = 248
  end
  object qryNiveis: TFDQuery
    SQL.Strings = (
      'SELECT'
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
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
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
      DisplayLabel = ' '
      DisplayWidth = 35
      FieldKind = fkInternalCalc
      FieldName = 'CALC_SELECIONADO'
      OnChange = cdsEmailsCALC_SELECIONADOChange
    end
    object cdsEmailsID: TIntegerField
      FieldName = 'ID'
      Required = True
      Visible = False
    end
    object cdsEmailsNOME: TStringField
      DisplayLabel = 'Nome'
      DisplayWidth = 240
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
    SQL.Strings = (
      'SELECT'
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
    object cdsCelularesCALC_SELECIONADO: TBooleanField
      DisplayLabel = ' '
      DisplayWidth = 35
      FieldKind = fkInternalCalc
      FieldName = 'CALC_SELECIONADO'
      OnChange = cdsCelularesCALC_SELECIONADOChange
    end
    object cdsCelularesID: TIntegerField
      FieldName = 'ID'
      Required = True
      Visible = False
    end
    object cdsCelularesNOME: TStringField
      DisplayLabel = 'Nome'
      DisplayWidth = 240
      FieldName = 'NOME'
      Size = 30
    end
  end
  object dspCelulares: TDataSetProvider
    DataSet = qryCelulares
    Left = 392
    Top = 248
  end
  object qryCelulares: TFDQuery
    SQL.Strings = (
      'SELECT'
      '  ID,'
      '  NOME'
      'FROM'
      '  CELULARES'
      ' '
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE')
    Left = 392
    Top = 296
    ParamData = <
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
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
    object cdsGruposPasCALC_SELECIONADO: TBooleanField
      Tag = 1
      DisplayLabel = ' '
      DisplayWidth = 35
      FieldKind = fkInternalCalc
      FieldName = 'CALC_SELECIONADO'
      OnChange = cdsGruposPasCALC_SELECIONADOChange
    end
    object cdsGruposPasID: TIntegerField
      FieldName = 'ID'
      Required = True
      Visible = False
    end
    object cdsGruposPasNOME: TStringField
      DisplayLabel = 'Nome'
      DisplayWidth = 240
      FieldName = 'NOME'
      Size = 30
    end
  end
  object dspGruposPas: TDataSetProvider
    DataSet = qryGruposPas
    Left = 464
    Top = 248
  end
  object qryGruposPas: TFDQuery
    SQL.Strings = (
      'SELECT'
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
    Left = 535
    Top = 200
    object cdsPaineisCALC_SELECIONADO: TBooleanField
      DisplayLabel = ' '
      DisplayWidth = 35
      FieldKind = fkInternalCalc
      FieldName = 'CALC_SELECIONADO'
      OnChange = cdsPaineisCALC_SELECIONADOChange
    end
    object cdsPaineisID: TIntegerField
      FieldName = 'ID'
      Required = True
      Visible = False
    end
    object cdsPaineisNOME: TStringField
      DisplayLabel = 'Nome'
      DisplayWidth = 240
      FieldName = 'NOME'
      Size = 30
    end
  end
  object dspPaineis: TDataSetProvider
    DataSet = qryPaineis
    Left = 536
    Top = 248
  end
  object qryPaineis: TFDQuery
    SQL.Strings = (
      'SELECT'
      '  ID,'
      '  NOME'
      'FROM'
      '  PAINEIS'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE')
    Left = 536
    Top = 296
    ParamData = <
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object cdsAlarmesRelacionados: TClientDataSet
    Aggregates = <>
    DataSetField = cdsAlarmesqryAlarmesRelacionados
    Params = <>
    Left = 404
    Top = 61
    object cdsAlarmesRelacionadosID_UNIDADE: TIntegerField
      DisplayLabel = 'ID'
      DisplayWidth = 60
      FieldName = 'ID_UNIDADE'
    end
    object cdsAlarmesRelacionadosID_PIALARME: TSmallintField
      DisplayLabel = 'ID'
      DisplayWidth = 60
      FieldName = 'ID_PIALARME'
      Required = True
    end
    object cdsAlarmesRelacionadosID_RELACIONADO: TIntegerField
      DisplayLabel = 'Relacionado'
      DisplayWidth = 60
      FieldName = 'ID_RELACIONADO'
      Required = True
    end
  end
  object qryAlarmesRelacionados: TFDQuery
    MasterSource = dtsLinkAlarmes
    SQL.Strings = (
      'SELECT'
      ' ID_UNIDADE,'
      '  ID_PIALARME,'
      '  ID_RELACIONADO'
      'FROM'
      '  PIS_ALARMES_RELACIONADOS'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE AND'
      '  ID_PIALARME = :ID_PIALARME')
    Left = 401
    Top = 111
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
        Size = 2
      end>
  end
  object dtsLinkAlarmes: TDataSource
    DataSet = qryAlarmes
    Left = 304
    Top = 96
  end
end
