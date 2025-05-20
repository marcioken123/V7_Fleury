object dmSicsServidor: TdmSicsServidor
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 649
  Width = 916
  object cdsInicializaBase: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspInicializaBase'
    OnReconcileError = cdsInicializaBaseReconcileError
    Left = 60
    Top = 92
  end
  object dspInicializaBase: TDataSetProvider
    DataSet = qryInicializaBase
    Left = 60
    Top = 136
  end
  object qryInicializaBase: TFDQuery
    Connection = dmSicsMain.connOnLine
    Left = 60
    Top = 184
  end
  object qryAddEvento: TFDQuery
    Connection = dmSicsMain.connOnLine
    SQL.Strings = (
      'select * from EVENTOS'
      'where 2 = 3')
    Left = 200
    Top = 200
  end
  object dspAddEvento: TDataSetProvider
    DataSet = qryAddEvento
    Left = 264
    Top = 184
  end
  object cdsAddEvento: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspAddEvento'
    OnReconcileError = cdsAddEventoReconcileError
    Left = 312
    Top = 128
  end
  object cdsAddTicket: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspAddTicket'
    OnReconcileError = cdsAddTicketReconcileError
    Left = 280
    Top = 320
  end
  object dspAddTicket: TDataSetProvider
    DataSet = qryAddTicket
    Left = 232
    Top = 320
  end
  object qryAddTicket: TFDQuery
    Connection = dmSicsMain.connOnLine
    SQL.Strings = (
      'select * from TICKETS'
      'where 2 = 3')
    Left = 184
    Top = 320
  end
  object qryCheckExisteTicket: TFDQuery
    Connection = dmSicsMain.connOnLine
    SQL.Strings = (
      'SELECT'
      '  ID'
      'FROM'
      '  TICKETS'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE AND'
      '  ID = :ID')
    Left = 136
    Top = 432
    ParamData = <
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'ID'
        DataType = ftInteger
        ParamType = ptInput
      end>
  end
  object cdsAddTicketTag: TClientDataSet
    Aggregates = <>
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end
      item
        DataType = ftInteger
        Name = 'ID_TICKET'
        ParamType = ptInput
      end>
    ProviderName = 'dspAddTicketTag'
    OnReconcileError = cdsAddTicketTagReconcileError
    Left = 384
    Top = 296
  end
  object dspAddTicketTag: TDataSetProvider
    DataSet = qryAddTicketTag
    Left = 384
    Top = 344
  end
  object qryAddTicketTag: TFDQuery
    Connection = dmSicsMain.connOnLine
    SQL.Strings = (
      'SELECT'
      '  TT.ID_UNIDADE,'
      '  TT.ID_TICKET,'
      '  TT.ID_TAG,'
      '  TAGS.ID_GRUPOTAG'
      'FROM'
      '  NN_TICKETS_TAGS TT'
      '  INNER JOIN TAGS ON (TAGS.ID_UNIDADE = TT.ID_UNIDADE AND '
      '                      TAGS.ID         = TT.ID_TAG)'
      'WHERE'
      '  TT.ID_UNIDADE = :ID_UNIDADE AND'
      '  TT.ID_TICKET = :ID_TICKET')
    Left = 384
    Top = 392
    ParamData = <
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'ID_TICKET'
        DataType = ftInteger
        ParamType = ptInput
      end>
    object qryAddTicketTagID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
      Origin = 'ID_UNIDADE'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qryAddTicketTagID_TICKET: TIntegerField
      FieldName = 'ID_TICKET'
      Required = True
    end
    object qryAddTicketTagID_TAG: TIntegerField
      FieldName = 'ID_TAG'
      Required = True
    end
    object qryAddTicketTagID_GRUPOTAG: TIntegerField
      FieldName = 'ID_GRUPOTAG'
      ProviderFlags = []
    end
  end
  object qryDeleteTicketTag: TFDQuery
    Connection = dmSicsMain.connOnLine
    SQL.Strings = (
      'DELETE FROM '
      '  NN_TICKETS_TAGS'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE AND'
      '  ID_TICKET = :ID_TICKET AND '
      '  ID_TAG = :ID_TAG')
    Left = 56
    Top = 344
    ParamData = <
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'ID_TICKET'
        ParamType = ptInput
      end
      item
        Name = 'ID_TAG'
        ParamType = ptInput
      end>
  end
  object qryUpdateNomeCliente: TFDQuery
    Connection = dmSicsMain.connOnLine
    SQL.Strings = (
      'UPDATE'
      '  TICKETS'
      'SET'
      '  NOMECLIENTE = :nome'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE AND'
      '  ID = :id')
    Left = 385
    Top = 165
    ParamData = <
      item
        Name = 'nome'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'id'
        DataType = ftInteger
        ParamType = ptInput
      end>
  end
  object cdsAddEventoPP: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspAddEventoPP'
    OnReconcileError = cdsAddEventoPPReconcileError
    Left = 280
    Top = 374
  end
  object dspAddEventoPP: TDataSetProvider
    DataSet = qryAddEventoPP
    Left = 232
    Top = 374
  end
  object qryAddEventoPP: TFDQuery
    Connection = dmSicsMain.connOnLine
    SQL.Strings = (
      'select * from EVENTOS_PPS'
      'where 2 = 3')
    Left = 184
    Top = 374
  end
  object qryFilasChamadaAutomatica: TFDQuery
    Connection = dmSicsMain.connOnLine
    Left = 600
    Top = 40
  end
  object dspFilasChamadaAutomatica: TDataSetProvider
    DataSet = qryFilasChamadaAutomatica
    Left = 744
    Top = 32
  end
  object cdsFilasChamadaAutomatica: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspFilasChamadaAutomatica'
    Left = 752
    Top = 80
  end
  object qryDeleteTicketsAgendamentosFilas: TFDQuery
    Connection = dmSicsMain.connOnLine
    SQL.Strings = (
      'DELETE FROM '
      '  NN_TICKETS_AGENDAMENTOSFILAS'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE AND'
      '  ID_TICKET = :ID_TICKET'
      '')
    Left = 768
    Top = 392
    ParamData = <
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'ID_TICKET'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object cdsAddTicketAgendamentosFilas: TClientDataSet
    Aggregates = <>
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end
      item
        DataType = ftInteger
        Name = 'ID_TICKET'
        ParamType = ptInput
      end>
    ProviderName = 'dspAddTicketAgendamentosFilas'
    OnReconcileError = cdsAddTicketAgendamentosFilasReconcileError
    Left = 608
    Top = 296
  end
  object dspAddTicketAgendamentosFilas: TDataSetProvider
    DataSet = qryAddTicketAgendamentosFilas
    Left = 608
    Top = 344
  end
  object qryAddTicketAgendamentosFilas: TFDQuery
    Connection = dmSicsMain.connOnLine
    SQL.Strings = (
      'SELECT'
      '  TAF.*'
      'FROM'
      '  NN_TICKETS_AGENDAMENTOSFILAS TAF'
      'WHERE'
      '  TAF.ID_UNIDADE = :ID_UNIDADE AND'
      '  TAF.ID_TICKET = :ID_TICKET')
    Left = 608
    Top = 392
    ParamData = <
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'ID_TICKET'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object qryIDTicket: TFDQuery
    Tag = 1
    Connection = dmSicsMain.connOnLine
    SQL.Strings = (
      'SELECT'
      '  T.ID_UNIDADE,'
      '  T.ID,'
      '  T.NUMEROTICKET,'
      '  T.NOMECLIENTE,'
      '  T.FILA_ID,'
      '  T.CREATEDAT'
      'FROM'
      '  TICKETS T'
      'WHERE'
      '  T.ID_UNIDADE   = :ID_UNIDADE AND'
      '  T.NUMEROTICKET = :NUMEROTICKET '
      'ORDER BY'
      '  T.ID DESC'
      '{LIMIT(0, 1)}')
    Left = 488
    Top = 280
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
        Value = 1
      end>
    object qryIDTicketID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
      Origin = 'ID_UNIDADE'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qryIDTicketID: TIntegerField
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qryIDTicketNUMEROTICKET: TIntegerField
      FieldName = 'NUMEROTICKET'
      Origin = 'NUMEROTICKET'
    end
    object qryIDTicketNOMECLIENTE: TStringField
      FieldName = 'NOMECLIENTE'
      Origin = 'NOMECLIENTE'
      Size = 60
    end
    object qryIDTicketFILA_ID: TIntegerField
      FieldName = 'FILA_ID'
      Origin = 'FILA_ID'
    end
    object qryIDTicketCREATEDAT: TSQLTimeStampField
      FieldName = 'CREATEDAT'
      Origin = 'CREATEDAT'
    end
  end
  object qryUpdateTicket: TFDQuery
    Connection = dmSicsMain.connOnLine
    SQL.Strings = (
      'UPDATE'
      '  TICKETS'
      'SET'
      '  FILA_ID = :fila,'
      '  CREATEDAT = :datahora,'
      '  ORDEM = :ordemnafila'
      'WHERE'
      '  ID = :id')
    Left = 385
    Top = 229
    ParamData = <
      item
        Name = 'FILA'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'DATAHORA'
        DataType = ftDateTime
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'ORDEMNAFILA'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'id'
        DataType = ftInteger
        ParamType = ptInput
      end>
  end
  object cdsAddParametrosCalculoTEE: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspAddParametrosCalculoTEE'
    OnReconcileError = cdsAddEventoReconcileError
    Left = 240
    Top = 576
  end
  object dspAddParametrosCalculoTEE: TDataSetProvider
    DataSet = qryAddParametrosCalculoTEE
    Left = 240
    Top = 528
  end
  object qryAddParametrosCalculoTEE: TFDQuery
    Connection = dmSicsMain.connOnLine
    SQL.Strings = (
      'select * from CALCULOS_TEE'
      'where 2 = 3')
    Left = 240
    Top = 480
  end
  object cdsAddAlarmeAtivoPA: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspAddAlarmeAtivoPA'
    OnReconcileError = cdsAddEventoReconcileError
    Left = 440
    Top = 576
  end
  object dspAddAlarmeAtivoPA: TDataSetProvider
    DataSet = qryAddAlarmeAtivoPA
    Left = 440
    Top = 528
  end
  object qryAddAlarmeAtivoPA: TFDQuery
    Connection = dmSicsMain.connOnLine
    SQL.Strings = (
      'select * from PIS_ALARMES_ATIVOS_POR_PA'
      'where 2 = 3')
    Left = 440
    Top = 480
  end
  object cdsAddQtdEsperaPA: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspAddQtdEsperaPA'
    OnReconcileError = cdsAddEventoReconcileError
    Left = 576
    Top = 576
  end
  object dspAddQtdEsperaPA: TDataSetProvider
    DataSet = qryAddQtdEsperaPA
    Left = 576
    Top = 528
  end
  object qryAddQtdEsperaPA: TFDQuery
    Connection = dmSicsMain.connOnLine
    SQL.Strings = (
      'select * from QTD_ESPERA_POR_PA'
      'where 2 = 3')
    Left = 576
    Top = 480
  end
end
