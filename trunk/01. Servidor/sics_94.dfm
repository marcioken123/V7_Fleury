object dmSicsMain: TdmSicsMain
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 894
  Width = 1339
  object tblGenerica1: TFDTable
    Connection = connOnLine
    Left = 32
    Top = 64
  end
  object cdsFilas: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'POSICAO'
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspFilas'
    Left = 152
    Top = 64
  end
  object dspGenerico: TDataSetProvider
    DataSet = tblGenerica1
    Left = 32
    Top = 112
  end
  object cdsPaineis: TClientDataSet
    Aggregates = <>
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspPaineis'
    AfterOpen = cdsPaineisAfterOpen
    Left = 576
    Top = 664
  end
  object cdsGruposDePAs: TClientDataSet
    Aggregates = <>
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspGruposDePAs'
    Left = 579
    Top = 720
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
    ProviderName = 'dspPAs'
    Left = 248
    Top = 64
  end
  object cdsAtendentes: TClientDataSet
    Aggregates = <>
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspAtendentes'
    OnReconcileError = cdsAtendentesReconcileError
    Left = 579
    Top = 62
  end
  object cdsGruposDeAtendentes: TClientDataSet
    Aggregates = <>
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspGruposDeAtendentes'
    Left = 579
    Top = 8
  end
  object cdsGruposDePaineis: TClientDataSet
    Aggregates = <>
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspGruposDePaineis'
    Left = 579
    Top = 776
  end
  object cdsCelulares: TClientDataSet
    Aggregates = <>
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspCelulares'
    Left = 579
    Top = 171
  end
  object cdsEmails: TClientDataSet
    Aggregates = <>
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspEmails'
    Left = 579
    Top = 116
  end
  object cdsContadoresDeFilas: TClientDataSet
    Aggregates = <>
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end
      item
        DataType = ftInteger
        Name = 'ID'
        ParamType = ptInput
      end>
    ProviderName = 'dspContadoresDeFilas'
    Left = 41
    Top = 672
    object cdsContadoresDeFilasID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
      Required = True
    end
    object cdsContadoresDeFilasID: TIntegerField
      FieldName = 'ID'
      Origin = 'ID'
    end
    object cdsContadoresDeFilasCONTADOR: TIntegerField
      FieldName = 'CONTADOR'
      Origin = 'CONTADOR'
    end
  end
  object dsFilas: TDataSource
    DataSet = cdsFilas
    Left = 192
    Top = 64
  end
  object dsPaineis: TDataSource
    DataSet = cdsPaineis
    Left = 579
    Top = 664
  end
  object cdsControleDePaineis: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 232
    Top = 176
    object cdsControleDePaineisID: TIntegerField
      FieldName = 'ID'
    end
    object cdsControleDePaineisPROXIMACHAMADA: TDateTimeField
      FieldName = 'PROXIMACHAMADA'
    end
  end
  object qryGeneratorGenerico: TFDQuery
    Connection = connOnLine
    SQL.Strings = (
      'SELECT GEN_ID (GEN_ID_FILA, 1) AS ID FROM RDB$DATABASE')
    Left = 48
    Top = 176
  end
  object dsPAs: TDataSource
    DataSet = cdsPAs
    Left = 288
    Top = 64
  end
  object cdsNN_PAs_Filas: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'ID_PA;POSICAO'
    MasterFields = 'ID'
    MasterSource = dsPAs
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspNN_PAs_Filas'
    Left = 200
    Top = 288
  end
  object cdsPIS: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspPIS'
    OnReconcileError = cdsAtendentesReconcileError
    Left = 686
    Top = 8
    object cdsPISID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
      Required = True
    end
    object cdsPISID_PI: TSmallintField
      FieldName = 'ID_PI'
      Required = True
    end
    object cdsPISID_PITIPO: TSmallintField
      FieldName = 'ID_PITIPO'
    end
    object cdsPISID_PIFUNCAO: TSmallintField
      FieldName = 'ID_PIFUNCAO'
    end
    object cdsPISID_PIPOS: TSmallintField
      FieldName = 'ID_PIPOS'
    end
    object cdsPISVALOR: TFloatField
      FieldKind = fkInternalCalc
      FieldName = 'VALOR'
    end
  end
  object dspPIS: TDataSetProvider
    DataSet = qryPIS
    Left = 686
    Top = 56
  end
  object qryPIS: TFDQuery
    Connection = connOnLine
    SQL.Strings = (
      'SELECT'
      '  ID_UNIDADE,'
      '  ID_PI, '
      '  ID_PITIPO,'
      '  ID_PIFUNCAO,'
      '  ID_PIPOS'
      'FROM'
      '  PIS'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE')
    Left = 686
    Top = 104
    ParamData = <
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object cdsPisRelacionados: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'ID_UNIDADE;ID_PI'
    MasterFields = 'ID_UNIDADE;ID_PI'
    MasterSource = dtsPis
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspPisRelacionados'
    OnReconcileError = cdsAtendentesReconcileError
    Left = 902
    Top = 22
    object cdsPisRelacionadosID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
      Required = True
    end
    object cdsPisRelacionadosID_PI: TSmallintField
      FieldName = 'ID_PI'
      Required = True
    end
    object cdsPisRelacionadosID_RELACIONADO: TIntegerField
      FieldName = 'ID_RELACIONADO'
      Required = True
    end
  end
  object dspPisRelacionados: TDataSetProvider
    DataSet = qryPisRelacionados
    Left = 902
    Top = 72
  end
  object qryPisRelacionados: TFDQuery
    Connection = connOnLine
    SQL.Strings = (
      'SELECT'
      '  ID_UNIDADE,  '
      '  ID_PI,'
      '  ID_RELACIONADO'
      'FROM'
      '  PIS_RELACIONADOS'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE')
    Left = 902
    Top = 120
    ParamData = <
      item
        Position = 1
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
      end>
  end
  object dtsPis: TDataSource
    DataSet = cdsPIS
    Left = 750
    Top = 56
  end
  object dspMonitoramentos: TDataSetProvider
    DataSet = qryMonitoramentos
    Left = 686
    Top = 264
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
    OnReconcileError = cdsAtendentesReconcileError
    Left = 686
    Top = 212
    object cdsMonitoramentosID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
      Required = True
    end
    object cdsMonitoramentosID_PIMONITORAMENTO: TSmallintField
      FieldName = 'ID_PIMONITORAMENTO'
      Required = True
    end
    object cdsMonitoramentosID_PI: TSmallintField
      FieldName = 'ID_PI'
    end
    object cdsMonitoramentosID_PIHORARIO: TSmallintField
      FieldName = 'ID_PIHORARIO'
    end
    object cdsMonitoramentosPINOME: TStringField
      FieldName = 'PINOME'
      Size = 30
    end
    object cdsMonitoramentosCARACTERES: TIntegerField
      FieldName = 'CARACTERES'
    end
    object cdsMonitoramentosALINHAMENTO: TSmallintField
      FieldName = 'ALINHAMENTO'
    end
    object cdsMonitoramentosPITIPO: TSmallintField
      FieldName = 'PITIPO'
    end
    object cdsMonitoramentosFORMATOHORARIO: TStringField
      FieldName = 'FORMATOHORARIO'
      FixedChar = True
      Size = 1
    end
    object cdsMonitoramentosVALOR: TFloatField
      FieldKind = fkLookup
      FieldName = 'VALOR'
      LookupDataSet = cdsPIS
      LookupKeyFields = 'ID_PI'
      LookupResultField = 'VALOR'
      KeyFields = 'ID_PI'
      Lookup = True
    end
  end
  object qryMonitoramentos: TFDQuery
    Connection = connOnLine
    SQL.Strings = (
      'select'
      '   M.*,'
      '   P.NOME as PINOME,'
      '   P.CARACTERES,'
      '   P.ID_PIPOS as ALINHAMENTO,'
      '   P.ID_PITIPO as PITIPO,'
      '   T.FORMATOHORARIO'
      'from'
      '   PIS_MONITORAMENTOS M'
      
        '   inner join PIS       P on (M.ID_UNIDADE = P.ID_UNIDADE AND M.' +
        'ID_PI     = P.ID_PI)'
      
        '   left  join PIS_TIPOS T on (P.ID_UNIDADE = T.ID_UNIDADE AND P.' +
        'ID_PITIPO = T.ID_PITIPO)'
      'WHERE'
      '  M.ID_UNIDADE = :ID_UNIDADE')
    Left = 686
    Top = 304
    ParamData = <
      item
        Position = 1
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
      end>
  end
  object dspHorarios: TDataSetProvider
    DataSet = qryHorarios
    Left = 686
    Top = 400
  end
  object cdsHorarios: TClientDataSet
    Aggregates = <>
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspHorarios'
    OnReconcileError = cdsAtendentesReconcileError
    Left = 686
    Top = 358
  end
  object qryHorarios: TFDQuery
    Connection = connOnLine
    SQL.Strings = (
      'SELECT'
      '   *'
      'FROM'
      '   PIS_HORARIOS'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE')
    Left = 686
    Top = 448
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
    IndexFieldNames = 'ID_PIMONITORAMENTO'
    MasterFields = 'ID_PIMONITORAMENTO'
    MasterSource = dsMonitoramentos
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspAlarmes'
    OnReconcileError = cdsAtendentesReconcileError
    Left = 902
    Top = 214
  end
  object dspAlarmes: TDataSetProvider
    DataSet = qryAlarmes
    Left = 902
    Top = 264
  end
  object qryAlarmes: TFDQuery
    Connection = connOnLine
    SQL.Strings = (
      'select'
      '  A.*,'
      '  N.NOME AS NOMENIVEL,'
      '  N.CODIGOCOR,'
      '  N.POSICAO AS POSICAONIVEL,'
      '  N.COR_PAINELELETRONICO'
      'from'
      '  PIS_ALARMES A'
      '  INNER JOIN PIS_NIVEIS N on (A.ID_UNIDADE = N.ID_UNIDADE AND'
      '                              A.ID_PINIVEL = N.ID_PINIVEL)'
      'WHERE'
      '  A.ID_UNIDADE = :ID_UNIDADE')
    Left = 902
    Top = 312
    ParamData = <
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object dsMonitoramentos: TDataSource
    DataSet = cdsMonitoramentos
    Left = 782
    Top = 208
  end
  object cdsIdsRelacionados: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'ID_PIALARME'
    MasterFields = 'ID_PIALARME'
    MasterSource = dsAlarmes
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspIdsRelacionados'
    OnReconcileError = cdsAtendentesReconcileError
    Left = 1046
    Top = 214
  end
  object dspIdsRelacionados: TDataSetProvider
    DataSet = qryIdsRelacionados
    Left = 1046
    Top = 264
  end
  object qryIdsRelacionados: TFDQuery
    Connection = connOnLine
    SQL.Strings = (
      'SELECT'
      '  *'
      'FROM'
      '  PIS_ALARMES_RELACIONADOS'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE')
    Left = 1046
    Top = 312
    ParamData = <
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object dsAlarmes: TDataSource
    DataSet = cdsAlarmes
    Left = 974
    Top = 240
  end
  object cdsUnidades: TClientDataSet
    Aggregates = <>
    Params = <>
    AfterOpen = cdsUnidadesAfterOpen
    Left = 31
    Top = 506
    object cdsUnidadesID: TIntegerField
      FieldName = 'ID'
    end
    object cdsUnidadesNOME: TStringField
      FieldName = 'NOME'
      Size = 40
    end
    object cdsUnidadesPATH_BASE_ONLINE: TStringField
      FieldName = 'PATH_BASE_ONLINE'
      Size = 255
    end
    object cdsUnidadesPATH_BASE_RELATORIOS: TStringField
      FieldName = 'PATH_BASE_RELATORIOS'
      Size = 255
    end
    object cdsUnidadesIDX_CONN_RELATORIO: TIntegerField
      FieldName = 'IDX_CONN_RELATORIO'
    end
    object cdsUnidadesIP_ENDERECO: TStringField
      FieldName = 'IP_ENDERECO'
      Size = 15
    end
    object cdsUnidadesIP_PORTA: TIntegerField
      FieldName = 'IP_PORTA'
    end
    object cdsUnidadesCONECTADA: TBooleanField
      Tag = 1
      FieldName = 'CONECTADA'
    end
  end
  object cdsUnidadesClone: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 119
    Top = 506
  end
  object qryAux: TFDQuery
    Connection = connOnLine
    Left = 48
    Top = 232
  end
  object qryAuxScriptBd: TFDQuery
    Connection = connOnLine
    SQL.Strings = (
      'SELECT'
      '  RDB$RELATION_NAME'
      'FROM'
      '  RDB$RELATIONS'
      'WHERE'
      '  RDB$RELATION_NAME = '#39'CONFIGURACOES_GERAIS'#39)
    Left = 215
    Top = 351
  end
  object cdsTags: TClientDataSet
    Aggregates = <>
    FilterOptions = [foNoPartialCompare]
    IndexFieldNames = 'POSICAO'
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspTags'
    Left = 579
    Top = 225
  end
  object cdsGruposDeTags: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'POSICAO'
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspGruposDeTags'
    AfterOpen = cdsGruposDeTagsAfterOpen
    Left = 579
    Top = 280
  end
  object qryInserirTotem: TFDQuery
    Connection = connOnLine
    Left = 1030
    Top = 24
  end
  object cdsTotens: TClientDataSet
    Aggregates = <>
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspTotens'
    Left = 750
    Top = 352
  end
  object dspTotens: TDataSetProvider
    DataSet = qryTotens
    Left = 750
    Top = 400
  end
  object qryTotens: TFDQuery
    Connection = connOnLine
    SQL.Strings = (
      'SELECT'
      '  ID_UNIDADE,'
      '  ID,'
      '  NOME,'
      '  IP,'
      '  IDFILA_BOTAO1,'
      '  IDFILA_BOTAO2,'
      '  IDFILA_BOTAO3,'
      '  IDFILA_BOTAO4,'
      '  IDFILA_BOTAO5,'
      '  IDFILA_BOTAO6,'
      '  IDFILA_BOTAO7,'
      '  IDFILA_BOTAO8,'
      '  ID_MODELOTOTEM,'
      '  MENSAGEM,'
      '  OPCOES_PICOTEENTREVIAS,   '
      '  OPCOES_CORTEPARCIALAOFINAL,'
      '  OPCOES_CDBSENHAS,'
      '  OPCOES_DATAHORANA2AVIA,'
      '  OPCOES_NOMEFILANA2AVIA'
      'FROM'
      '  TOTENS'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE')
    Left = 750
    Top = 448
    ParamData = <
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object cdsTVsCanais: TClientDataSet
    Aggregates = <>
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspTVsCanais'
    Left = 830
    Top = 352
  end
  object dspTVsCanais: TDataSetProvider
    DataSet = qryTVsCanais
    Left = 830
    Top = 400
  end
  object qryTVsCanais: TFDQuery
    Connection = connOnLine
    SQL.Strings = (
      'SELECT'
      '  TC.ID_UNIDADE,'
      '  TC.ID_TV,'
      '  TC.ID_CANAL_TV,'
      '  CANAIS_TV.NOME AS CANAL_NOME,'
      '  CANAIS_TV.FREQUENCIA AS CANAL_FREQUENCIA,'
      
        '  (CASE WHEN TC.ID_CANAL_TV = TVS.ID_CANAL_TV_PADRAO THEN '#39'S'#39' EL' +
        'SE '#39'N'#39' END) AS CANAL_PADRAO'
      'FROM'
      '  NN_TVS_CANAIS_TV TC'
      
        '  INNER JOIN TVS       ON (TVS.ID_UNIDADE       = TC.ID_UNIDADE ' +
        'AND '
      '                           TVS.ID               = TC.ID_TV)'
      
        '  INNER JOIN CANAIS_TV ON (CANAIS_TV.ID_UNIDADE = TC.ID_UNIDADE ' +
        'AND'
      
        '                           CANAIS_TV.ID         = TC.ID_CANAL_TV' +
        ')'
      '                           '
      'WHERE'
      '  TC.ID_UNIDADE = :ID_UNIDADE')
    Left = 830
    Top = 448
    ParamData = <
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object cdsPISNiveis: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'POSICAO'
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspPISNiveis'
    Left = 579
    Top = 334
  end
  object cdsCloneGruposDeTags: TClientDataSet
    Aggregates = <>
    Filter = 'ATIVO='#39'T'#39
    Filtered = True
    Params = <>
    Left = 256
    Top = 392
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
    OnReconcileError = cdsAtendentesReconcileError
    Left = 579
    Top = 552
  end
  object cdsGruposDePPs: TClientDataSet
    Aggregates = <>
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspGruposDePPs'
    Left = 579
    Top = 608
  end
  object cdsMotivosDePausa: TClientDataSet
    Aggregates = <>
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspMotivosDePausa'
    Left = 579
    Top = 443
  end
  object cdsStatusDasPAs: TClientDataSet
    Aggregates = <>
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspStatusDasPAs'
    Left = 579
    Top = 497
  end
  object cdsGruposDeMotivosPausa: TClientDataSet
    Aggregates = <>
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspGruposDeMotivosPausa'
    Left = 579
    Top = 388
  end
  object dscSicsPA: TDataSource
    DataSet = cdsSicsPA
    Left = 1222
    Top = 552
  end
  object dspSicsPA: TDataSetProvider
    DataSet = qrySicsPA
    Left = 1062
    Top = 552
  end
  object cdsSicsPA: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive, foNoPartialCompare]
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspSicsPA'
    Left = 1143
    Top = 553
    object cdsSicsPAID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
      Required = True
    end
    object cdsSicsPAID: TIntegerField
      FieldName = 'ID'
      Required = True
      DisplayFormat = '00'
    end
    object cdsSicsPAID_PA: TIntegerField
      DisplayLabel = 'ID PA'
      FieldName = 'ID_PA'
    end
    object cdsSicsPAGRUPOS_ATENDENTES_PERMITIDOS: TStringField
      DisplayLabel = 'Grupo de Atendentes Permitidos'
      FieldName = 'GRUPOS_ATENDENTES_PERMITIDOS'
      Visible = False
      Size = 500
    end
    object cdsSicsPAGRUPOS_DE_TAGS_PERMITIDOS: TStringField
      DisplayLabel = 'Grupo de Tags Permitidos'
      FieldName = 'GRUPOS_DE_TAGS_PERMITIDOS'
      Visible = False
      Size = 500
    end
    object cdsSicsPAGRUPOS_DE_PPS_PERMITIDOS: TStringField
      DisplayLabel = 'Grupo de Processos Paralelos Permitidos'
      FieldName = 'GRUPOS_DE_PPS_PERMITIDOS'
      Visible = False
      Size = 500
    end
    object cdsSicsPAVISUALIZAR_PROCESSOS_PARALELOS: TStringField
      DisplayLabel = 'Visualizar Processos Paralelos'
      FieldName = 'VISUALIZAR_PROCESSOS_PARALELOS'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object cdsSicsPAMODO_LOGIN_LOGOUT: TStringField
      DisplayLabel = 'Modo Login / Logout'
      FieldName = 'MODO_LOGIN_LOGOUT'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object cdsSicsPAMODO_TERMINAL_SERVER: TStringField
      DisplayLabel = 'Modo Terminal Server'
      FieldName = 'MODO_TERMINAL_SERVER'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object cdsSicsPAPODE_FECHAR_PROGRAMA: TStringField
      DisplayLabel = 'Pode Fechar Programa'
      FieldName = 'PODE_FECHAR_PROGRAMA'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object cdsSicsPATAGS_OBRIGATORIAS: TStringField
      DisplayLabel = 'Tags Obrigat'#243'rias'
      FieldName = 'TAGS_OBRIGATORIAS'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object cdsSicsPAMANUAL_REDIRECT: TStringField
      DisplayLabel = 'Manual Redirect'
      FieldName = 'MANUAL_REDIRECT'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object cdsSicsPASECS_ON_RECALL: TIntegerField
      DisplayLabel = 'Segundos ao Rechamar'
      FieldName = 'SECS_ON_RECALL'
      Visible = False
    end
    object cdsSicsPAUSE_CODE_BAR: TStringField
      DisplayLabel = 'Utilizar Leitor de C'#243'digo de Barras'
      FieldName = 'USE_CODE_BAR'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object cdsSicsPAFILAS_PERMITIDAS: TStringField
      DisplayLabel = 'Filas Permitidas'
      FieldName = 'FILAS_PERMITIDAS'
      Visible = False
      Size = 500
    end
    object cdsSicsPAMOSTRAR_NOME_CLIENTE: TStringField
      DisplayLabel = 'Mostrar Nome Cliente'
      FieldName = 'MOSTRAR_NOME_CLIENTE'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object cdsSicsPAMOSTRAR_PA: TStringField
      DisplayLabel = 'Mostrar PA'
      FieldName = 'MOSTRAR_PA'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object cdsSicsPAMOSTRAR_BOTAO_LOGIN: TStringField
      DisplayLabel = 'Mostrar Bot'#227'o Login'
      FieldName = 'MOSTRAR_BOTAO_LOGIN_LOGOUT'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object cdsSicsPAMOSTRAR_BOTAO_PROXIMO: TStringField
      DisplayLabel = 'Mostrar Bot'#227'o Proximo'
      FieldName = 'MOSTRAR_BOTAO_PROXIMO'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object cdsSicsPAMOSTRAR_BOTAO_RECHAMA: TStringField
      DisplayLabel = 'Mostrar Bot'#227'o Rechama'
      FieldName = 'MOSTRAR_BOTAO_RECHAMA'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object cdsSicsPAMOSTRAR_BOTAO_ENCAMINHA: TStringField
      DisplayLabel = 'Mostrar Bot'#227'o Encaminha'
      FieldName = 'MOSTRAR_BOTAO_ENCAMINHA'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object cdsSicsPAMOSTRAR_BOTAO_FINALIZA: TStringField
      DisplayLabel = 'Mostrar Bot'#227'o Finaliza'
      FieldName = 'MOSTRAR_BOTAO_FINALIZA'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object cdsSicsPAMOSTRAR_BOTAO_ESPECIFICA: TStringField
      DisplayLabel = 'Mostrar Bot'#227'o Especifica'
      FieldName = 'MOSTRAR_BOTAO_ESPECIFICA'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object cdsSicsPAMOSTRAR_MENU_LOGIN: TStringField
      FieldName = 'MOSTRAR_MENU_LOGIN_LOGOUT'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object cdsSicsPAMOSTRAR_MENU_ALTERA_SENHA: TStringField
      DisplayLabel = 'Mostrar Menu Altera Senha'
      FieldName = 'MOSTRAR_MENU_ALTERA_SENHA'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object cdsSicsPAMOSTRAR_MENU_PROXIMO: TStringField
      DisplayLabel = 'Mostrar Menu Proximo'
      FieldName = 'MOSTRAR_MENU_PROXIMO'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object cdsSicsPAMOSTRAR_MENU_RECHAMA: TStringField
      DisplayLabel = 'Mostrar Menu Rechama'
      FieldName = 'MOSTRAR_MENU_RECHAMA'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object cdsSicsPAMOSTRAR_MENU_ESPECIFICA: TStringField
      DisplayLabel = 'Mostrar Menu Especifica'
      FieldName = 'MOSTRAR_MENU_ESPECIFICA'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object cdsSicsPAMOSTRAR_MENU_ENCAMINHA: TStringField
      DisplayLabel = 'Mostrar Menu Encaminha'
      FieldName = 'MOSTRAR_MENU_ENCAMINHA'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object cdsSicsPAMOSTRAR_MENU_FINALIZA: TStringField
      DisplayLabel = 'Mostrar Menu Finaliza'
      FieldName = 'MOSTRAR_MENU_FINALIZA'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object cdsSicsPACONFIRMAR_PROXIMO: TStringField
      DisplayLabel = 'Confirmar Proximo'
      FieldName = 'CONFIRMAR_PROXIMO'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object cdsSicsPACONFIRMAR_ENCAMINHA: TStringField
      DisplayLabel = 'Confirmar Encaminha'
      FieldName = 'CONFIRMAR_ENCAMINHA'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object cdsSicsPACONFIRMAR_FINALIZA: TStringField
      DisplayLabel = 'Confirmar Finaliza'
      FieldName = 'CONFIRMAR_FINALIZA'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object cdsSicsPACONFIRMAR_SENHA_OUTRA_FILA: TStringField
      DisplayLabel = 'Confirmar Senha Outra Fila'
      FieldName = 'CONFIRMAR_SENHA_OUTRA_FILA'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object cdsSicsPAMINIMIZAR_PARA_BANDEJA: TStringField
      DisplayLabel = 'Minimizar Bandeja'
      FieldName = 'MINIMIZAR_PARA_BANDEJA'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object cdsSicsPAMOSTRAR_BOTAO_PAUSA: TStringField
      FieldName = 'MOSTRAR_BOTAO_PAUSA'
      FixedChar = True
      Size = 1
    end
    object cdsSicsPAMOSTRAR_MENU_PAUSA: TStringField
      FieldName = 'MOSTRAR_MENU_PAUSA'
      FixedChar = True
      Size = 1
    end
    object cdsSicsPAPAS_PERMITIDAS: TStringField
      FieldName = 'PAS_PERMITIDAS'
      Size = 500
    end
    object cdsSicsPAGRUPOS_DE_PAUSAS_PERMITIDOS: TStringField
      FieldName = 'GRUPOS_DE_PAUSAS_PERMITIDOS'
      Size = 500
    end
    object cdsSicsPAMOSTRAR_BOTAO_PROCESSOS: TStringField
      FieldName = 'MOSTRAR_BOTAO_PROCESSOS'
      FixedChar = True
      Size = 1
    end
    object cdsSicsPAMOSTRAR_MENU_PROCESSOS: TStringField
      FieldName = 'MOSTRAR_MENU_PROCESSOS'
      FixedChar = True
      Size = 1
    end
    object cdsSicsPAMOSTRAR_NOME_ATENDENTE: TStringField
      FieldName = 'MOSTRAR_NOME_ATENDENTE'
      FixedChar = True
      Size = 1
    end
    object strngfldSicsPACONECTAR_VIA_DB: TStringField
      FieldName = 'CONECTAR_VIA_DB'
      Size = 1
    end
    object cdsSicsPAMOSTRAR_CONTROLE_REMOTO: TStringField
      FieldName = 'MOSTRAR_CONTROLE_REMOTO'
      FixedChar = True
      Size = 1
    end
    object cdsSicsPAGRUPOS_CONTROLE_REMOTO: TStringField
      DisplayLabel = 'Grupo de Controle Remoto'
      FieldName = 'GRUPOS_CONTROLE_REMOTO'
      Size = 500
    end
    object cdsSicsPAMOSTRAR_BOTAO_SEGUIRATENDIMENTO: TStringField
      FieldName = 'MOSTRAR_BOTAO_SEGUIRATENDIMENTO'
      FixedChar = True
      Size = 1
    end
    object cdsSicsPAMOSTRAR_MENU_SEGUIRATENDIMENTO: TStringField
      FieldName = 'MOSTRAR_MENU_SEGUIRATENDIMENTO'
      FixedChar = True
      Size = 1
    end
    object cdsSicsPACODIGOS_UNIDADES: TStringField
      FieldName = 'CODIGOS_UNIDADES'
      Size = 50
    end
    object cdsSicsPAFILA_ESPERA_PROFISSIONAL: TIntegerField
      DisplayLabel = 'Fila Espera Profissional'
      FieldName = 'FILA_ESPERA_PROFISSIONAL'
    end
    object cdsSicsPAID_TAG_AUTOMATICA: TIntegerField
      DisplayLabel = 'ID TAG Automatica'
      FieldName = 'ID_TAG_AUTOMATICA'
    end
    object cdsSicsPAMARCAR_TAG_APOS_ATENDIMENTO: TStringField
      DisplayLabel = 'Marcar Tag Apos Atendimento'
      FieldName = 'MARCAR_TAG_APOS_ATENDIMENTO'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object cdsSicsPAMOSTRAR_BOTAO_DADOS_ADICIONAIS: TStringField
      DisplayLabel = 'Mostrar Bot'#227'o Dados Adicionais'
      FieldName = 'MOSTRAR_BOTAO_DADOS_ADICIONAIS'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object cdsSicsPAGRUPOS_DE_TAGS_LAYOUT_BOTAO: TStringField
      DisplayLabel = 'Grupo de Tags Layout Bot'#227'o'
      FieldName = 'GRUPOS_DE_TAGS_LAYOUT_BOTAO'
      Visible = False
      Size = 500
    end
    object cdsSicsPAGRUPOS_DE_TAGS_LAYOUT_LISTA: TStringField
      DisplayLabel = 'Grupo de Tags Layout Lista'
      FieldName = 'GRUPOS_DE_TAGS_LAYOUT_LISTA'
      Visible = False
      Size = 500
    end
    object cdsSicsPAGRUPOS_DE_TAGS_SOMENTE_LEITURA: TStringField
      DisplayLabel = 'Grupo de Tags Somente Leitura'
      FieldName = 'GRUPOS_DE_TAGS_SOMENTE_LEITURA'
      Visible = False
      Size = 500
    end
    object cdsSicsPAID_UNIDADE_CLI: TIntegerField
      DisplayLabel = 'ID UNIDADE Cliente'
      FieldName = 'ID_UNIDADE_CLI'
    end
  end
  object qrySicsPA: TFDQuery
    Connection = connOnLine
    SQL.Strings = (
      'SELECT '
      '  * '
      'FROM '
      '  MODULOS_PAS'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE')
    Left = 973
    Top = 549
    ParamData = <
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object cdsFiltroGrupos: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 168
    Top = 496
  end
  object cdsFiltroFilas: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 814
    Top = 568
  end
  object dscSicsMultiPA: TDataSource
    DataSet = cdsSicsMultiPA
    Left = 1222
    Top = 600
  end
  object dspSicsMultiPA: TDataSetProvider
    DataSet = qrySicsMultiPA
    Left = 1062
    Top = 600
  end
  object cdsSicsMultiPA: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive, foNoPartialCompare]
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspSicsMultiPA'
    Left = 1141
    Top = 599
    object cdsSicsMultiPAID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
      Required = True
    end
    object cdsSicsMultiPAID: TIntegerField
      FieldName = 'ID'
      Required = True
      DisplayFormat = '00'
    end
    object cdsSicsMultiPAGRUPOS_ATENDENTES_PERMITIDOS: TStringField
      FieldName = 'GRUPOS_ATENDENTES_PERMITIDOS'
      Visible = False
      Size = 500
    end
    object cdsSicsMultiPAGRUPOS_DE_TAGS_PERMITIDOS: TStringField
      FieldName = 'GRUPOS_DE_TAGS_PERMITIDOS'
      Visible = False
      Size = 500
    end
    object cdsSicsMultiPAGRUPOS_DE_PPS_PERMITIDOS: TStringField
      FieldName = 'GRUPOS_DE_PPS_PERMITIDOS'
      Visible = False
      Size = 500
    end
    object cdsSicsMultiPAVISUALIZAR_PROCESSOS_PARALELOS: TStringField
      FieldName = 'VISUALIZAR_PROCESSOS_PARALELOS'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object cdsSicsMultiPAMODO_LOGIN_LOGOUT: TStringField
      FieldName = 'MODO_LOGIN_LOGOUT'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object cdsSicsMultiPAPODE_FECHAR_PROGRAMA: TStringField
      FieldName = 'PODE_FECHAR_PROGRAMA'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object cdsSicsMultiPATAGS_OBRIGATORIAS: TStringField
      FieldName = 'TAGS_OBRIGATORIAS'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object cdsSicsMultiPAMANUAL_REDIRECT: TStringField
      FieldName = 'MANUAL_REDIRECT'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object cdsSicsMultiPASECS_ON_RECALL: TIntegerField
      FieldName = 'SECS_ON_RECALL'
      Visible = False
    end
    object cdsSicsMultiPAUSE_CODE_BAR: TStringField
      FieldName = 'USE_CODE_BAR'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object cdsSicsMultiPAFILAS_PERMITIDAS: TStringField
      FieldName = 'FILAS_PERMITIDAS'
      Visible = False
      Size = 500
    end
    object cdsSicsMultiPAMOSTRAR_NOME_CLIENTE: TStringField
      FieldName = 'MOSTRAR_NOME_CLIENTE'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object cdsSicsMultiPAMOSTRAR_PA: TStringField
      FieldName = 'MOSTRAR_PA'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object cdsSicsMultiPAMOSTRAR_BOTAO_LOGIN: TStringField
      FieldName = 'MOSTRAR_BOTAO_LOGIN_LOGOUT'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object cdsSicsMultiPAMOSTRAR_BOTAO_PROXIMO: TStringField
      FieldName = 'MOSTRAR_BOTAO_PROXIMO'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object cdsSicsMultiPAMOSTRAR_BOTAO_RECHAMA: TStringField
      FieldName = 'MOSTRAR_BOTAO_RECHAMA'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object cdsSicsMultiPAMOSTRAR_BOTAO_ENCAMINHA: TStringField
      FieldName = 'MOSTRAR_BOTAO_ENCAMINHA'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object cdsSicsMultiPAMOSTRAR_BOTAO_FINALIZA: TStringField
      FieldName = 'MOSTRAR_BOTAO_FINALIZA'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object cdsSicsMultiPAMOSTRAR_BOTAO_ESPECIFICA: TStringField
      FieldName = 'MOSTRAR_BOTAO_ESPECIFICA'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object cdsSicsMultiPAMOSTRAR_MENU_LOGIN: TStringField
      FieldName = 'MOSTRAR_MENU_LOGIN_LOGOUT'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object cdsSicsMultiPAMOSTRAR_MENU_ALTERA_SENHA: TStringField
      FieldName = 'MOSTRAR_MENU_ALTERA_SENHA'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object cdsSicsMultiPAMOSTRAR_MENU_PROXIMO: TStringField
      FieldName = 'MOSTRAR_MENU_PROXIMO'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object cdsSicsMultiPAMOSTRAR_MENU_RECHAMA: TStringField
      FieldName = 'MOSTRAR_MENU_RECHAMA'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object cdsSicsMultiPAMOSTRAR_MENU_ESPECIFICA: TStringField
      FieldName = 'MOSTRAR_MENU_ESPECIFICA'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object cdsSicsMultiPAMOSTRAR_MENU_ENCAMINHA: TStringField
      FieldName = 'MOSTRAR_MENU_ENCAMINHA'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object cdsSicsMultiPAMOSTRAR_MENU_FINALIZA: TStringField
      FieldName = 'MOSTRAR_MENU_FINALIZA'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object cdsSicsMultiPACONFIRMAR_PROXIMO: TStringField
      FieldName = 'CONFIRMAR_PROXIMO'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object cdsSicsMultiPACONFIRMAR_ENCAMINHA: TStringField
      FieldName = 'CONFIRMAR_ENCAMINHA'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object cdsSicsMultiPACONFIRMAR_FINALIZA: TStringField
      FieldName = 'CONFIRMAR_FINALIZA'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object cdsSicsMultiPACONFIRMAR_SENHA_OUTRA_FILA: TStringField
      FieldName = 'CONFIRMAR_SENHA_OUTRA_FILA'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object cdsSicsMultiPAMINIMIZAR_PARA_BANDEJA: TStringField
      FieldName = 'MINIMIZAR_PARA_BANDEJA'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object cdsSicsMultiPACOLUNAS_PAS: TIntegerField
      FieldName = 'COLUNAS_PAS'
    end
    object cdsSicsMultiPATEMPO_LIMPAR_PA: TIntegerField
      FieldName = 'TEMPO_LIMPAR_PA'
    end
    object cdsSicsMultiPAPAS_PERMITIDAS: TStringField
      FieldName = 'PAS_PERMITIDAS'
      Size = 500
    end
    object cdsSicsMultiPAMOSTRAR_BOTAO_PAUSA: TStringField
      FieldName = 'MOSTRAR_BOTAO_PAUSA'
      Size = 1
    end
    object cdsSicsMultiPAID_TAG_AUTOMATICA: TIntegerField
      DisplayLabel = 'ID TAG Automatica'
      FieldName = 'ID_TAG_AUTOMATICA'
    end
    object cdsSicsMultiPAMARCAR_TAG_APOS_ATENDIMENTO: TStringField
      FieldName = 'MARCAR_TAG_APOS_ATENDIMENTO'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object cdsSicsMultiPAMOSTRAR_BOTAO_PROCESSOS: TStringField
      FieldName = 'MOSTRAR_BOTAO_PROCESSOS'
      Size = 1
    end
    object cdsSicsMultiPAGRUPOS_DE_PAUSAS_PERMITIDOS: TStringField
      FieldName = 'GRUPOS_DE_PAUSAS_PERMITIDOS'
      Size = 500
    end
    object cdsSicsMultiPAMOSTRAR_MENU_PAUSA: TStringField
      FieldName = 'MOSTRAR_MENU_PAUSA'
      Size = 1
    end
    object cdsSicsMultiPAMOSTRAR_MENU_PROCESSOS: TStringField
      FieldName = 'MOSTRAR_MENU_PROCESSOS'
      FixedChar = True
      Size = 1
    end
    object cdsSicsMultiPAPORTA_LDBC: TStringField
      FieldName = 'PORTA_LCDB'
      Size = 40
    end
    object cdsSicsMultiPAMOSTRAR_NOME_ATENDENTE: TStringField
      FieldName = 'MOSTRAR_NOME_ATENDENTE'
      Size = 1
    end
    object strngfldSicsMultiPACONECTAR_VIA_DB: TStringField
      FieldName = 'CONECTAR_VIA_DB'
      Size = 1
    end
    object cdsSicsMultiPAMOSTRAR_BOTAO_SEGUIRATENDIMENTO: TStringField
      FieldName = 'MOSTRAR_BOTAO_SEGUIRATENDIMENTO'
      FixedChar = True
      Size = 1
    end
    object cdsSicsMultiPAMOSTRAR_MENU_SEGUIRATENDIMENTO: TStringField
      FieldName = 'MOSTRAR_MENU_SEGUIRATENDIMENTO'
      FixedChar = True
      Size = 1
    end
    object cdsSicsMultiPACODIGOS_UNIDADES: TStringField
      FieldName = 'CODIGOS_UNIDADES'
      Size = 50
    end
    object cdsSicsMultiPAID_UNIDADE_CLI: TIntegerField
      DisplayLabel = 'ID UNIDADE Cliente'
      FieldName = 'ID_UNIDADE_CLI'
    end
    object cdsSicsMultiPAMOSTRAR_PAINEL_GRUPOS: TStringField
      FieldName = 'MOSTRAR_PAINEL_GRUPOS'
      FixedChar = True
      Size = 1
    end
    object cdsSicsMultiPAFILA_ESPERA_PROFISSIONAL: TIntegerField
      DisplayLabel = 'Fila Espera Profissional'
      FieldName = 'FILA_ESPERA_PROFISSIONAL'
    end
    object cdsSicsMultiPAMOSTRAR_BOTAO_DADOS_ADICIONAIS: TStringField
      DisplayLabel = 'Mostrar Bot'#227'o Dados Adicionais'
      FieldName = 'MOSTRAR_BOTAO_DADOS_ADICIONAIS'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object cdsSicsMultiPAGRUPOS_DE_TAGS_LAYOUT_BOTAO: TStringField
      DisplayLabel = 'Grupo de Tags Layout Bot'#227'o'
      FieldName = 'GRUPOS_DE_TAGS_LAYOUT_BOTAO'
      Visible = False
      Size = 500
    end
    object cdsSicsMultiPAGRUPOS_DE_TAGS_LAYOUT_LISTA: TStringField
      DisplayLabel = 'Grupo de Tags Layout Lista'
      FieldName = 'GRUPOS_DE_TAGS_LAYOUT_LISTA'
      Visible = False
      Size = 500
    end
    object cdsSicsMultiPAGRUPOS_DE_TAGS_SOMENTE_LEITURA: TStringField
      DisplayLabel = 'Grupo de Tags Somente Leitura'
      FieldName = 'GRUPOS_DE_TAGS_SOMENTE_LEITURA'
      Visible = False
      Size = 500
    end
  end
  object qrySicsMultiPA: TFDQuery
    Connection = connOnLine
    SQL.Strings = (
      'SELECT '
      '  * '
      'FROM '
      '  MODULOS_MULTIPAS'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE')
    Left = 974
    Top = 600
    ParamData = <
      item
        Position = 1
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
      end>
  end
  object dscModulos: TDataSource
    DataSet = cdsModulos
    Left = 1222
    Top = 488
  end
  object dspModulos: TDataSetProvider
    DataSet = qryModulos
    Left = 1062
    Top = 488
  end
  object cdsModulos: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive, foNoPartialCompare]
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspModulos'
    Left = 1142
    Top = 488
    object cdsModulosID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
      Required = True
    end
    object cdsModulosID: TIntegerField
      FieldName = 'ID'
      Required = True
    end
    object cdsModulosTIPO: TIntegerField
      FieldName = 'TIPO'
    end
    object cdsModulosNOME: TStringField
      FieldName = 'NOME'
      Size = 30
    end
  end
  object qryModulos: TFDQuery
    Connection = connOnLine
    SQL.Strings = (
      'SELECT '
      '  * '
      'FROM '
      '  MODULOS'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE')
    Left = 974
    Top = 488
    ParamData = <
      item
        Position = 1
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
      end>
  end
  object cdsFiltroPAs: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 251
    Top = 496
  end
  object qrySicsOnLine: TFDQuery
    Connection = connOnLine
    SQL.Strings = (
      'SELECT '
      '  * '
      'FROM '
      '  MODULOS_ONLINE'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE')
    Left = 974
    Top = 648
    ParamData = <
      item
        Position = 1
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
      end>
  end
  object dspSicsOnLine: TDataSetProvider
    DataSet = qrySicsOnLine
    Left = 1062
    Top = 648
  end
  object cdsSicsOnLine: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive, foNoPartialCompare]
    FieldDefs = <
      item
        Name = 'ID_UNIDADE'
        Attributes = [faRequired]
        DataType = ftInteger
      end
      item
        Name = 'ID'
        Attributes = [faRequired]
        DataType = ftInteger
      end
      item
        Name = 'FILAS_PERMITIDAS'
        DataType = ftString
        Size = 80
      end
      item
        Name = 'MOSTRAR_BOTAO_NAS_FILAS'
        DataType = ftString
        Size = 500
      end
      item
        Name = 'MOSTRAR_BLOQUEAR_NAS_FILAS'
        DataType = ftString
        Size = 500
      end
      item
        Name = 'MOSTRAR_PRIORITARIA_NAS_FILAS'
        DataType = ftString
        Size = 500
      end
      item
        Name = 'PERMITIR_INCLUSAO_NAS_FILAS'
        DataType = ftString
        Size = 500
      end
      item
        Name = 'IMPRESSORA_COMANDADA'
        DataType = ftInteger
      end
      item
        Name = 'COLUNAS_DE_FILAS'
        DataType = ftInteger
      end
      item
        Name = 'MODO_TOTEM_TOUCH'
        Attributes = [faFixed]
        DataType = ftString
        Size = 1
      end
      item
        Name = 'GRUPOS_MOTIVOS_PAUSA_PERMITIDO'
        DataType = ftString
        Size = 500
      end
      item
        Name = 'VISUALIZAR_GRUPOS'
        Attributes = [faFixed]
        DataType = ftString
        Size = 1
      end
      item
        Name = 'TOTEM_BOTOES_COLUNAS'
        DataType = ftInteger
      end
      item
        Name = 'TOTEM_BOTOES_TRANSPARENTES'
        Attributes = [faFixed]
        DataType = ftString
        Size = 1
      end
      item
        Name = 'TOTEM_BOTOES_MARGEM_SUPERIOR'
        DataType = ftInteger
      end
      item
        Name = 'TOTEM_BOTOES_MARGEM_INFERIOR'
        DataType = ftInteger
      end
      item
        Name = 'TOTEM_BOTOES_MARGEM_DIREITA'
        DataType = ftInteger
      end
      item
        Name = 'TOTEM_BOTOES_MARGEM_ESQUERDA'
        DataType = ftInteger
      end
      item
        Name = 'TOTEM_BOTOES_ESPACO_COLUNAS'
        DataType = ftInteger
      end
      item
        Name = 'TOTEM_BOTOES_ESPACO_LINHAS'
        DataType = ftInteger
      end
      item
        Name = 'TOTEM_PORTA_TCP'
        DataType = ftInteger
      end
      item
        Name = 'TOTEM_IMAGEM_FUNDO'
        DataType = ftString
        Size = 300
      end
      item
        Name = 'TOTEM_PORTA_SERIAL_IMPRESSORA'
        DataType = ftString
        Size = 40
      end
      item
        Name = 'TOTEM_MOSTRAR_BOTAO_FECHAR'
        Attributes = [faFixed]
        DataType = ftString
        Size = 1
      end
      item
        Name = 'TOTEM_BOTAO_FECHAR_TAM_MAIOR'
        Attributes = [faFixed]
        DataType = ftString
        Size = 1
      end
      item
        Name = 'LINHAS_DE_FILAS'
        DataType = ftInteger
      end
      item
        Name = 'GRUPOS_INDICADORES_PERMITIDOS'
        DataType = ftString
        Size = 500
      end
      item
        Name = 'VISUALIZAR_NOME_CLIENTES'
        Attributes = [faFixed]
        DataType = ftString
        Size = 1
      end
      item
        Name = 'PODE_FECHAR_PROGRAMA'
        Attributes = [faFixed]
        DataType = ftString
        Size = 1
      end
      item
        Name = 'GRUPOS_ATENDENTES_PERMITIDOS'
        DataType = ftString
        Size = 500
      end
      item
        Name = 'GRUPOS_PAS_PERMITIDAS'
        DataType = ftString
        Size = 500
      end
      item
        Name = 'GRUPOS_TAGS_PERMITIDAS'
        DataType = ftString
        Size = 500
      end
      item
        Name = 'PERMITIR_EXCLUSAO_NAS_FILAS'
        DataType = ftString
        Size = 500
      end
      item
        Name = 'PERMITIR_REIMPRESSAO_NAS_FILAS'
        DataType = ftString
        Size = 500
      end
      item
        Name = 'MOSTRAR_EXCLUIR_TODAS'
        Attributes = [faFixed]
        DataType = ftString
        Size = 1
      end
      item
        Name = 'MOSTRA_TEMPO_DECORRIDO_ESPERA'
        Attributes = [faFixed]
        DataType = ftString
        Size = 1
      end
      item
        Name = 'TELA_PADRAO'
        DataType = ftInteger
      end
      item
        Name = 'TAMANHO_FONTE'
        DataType = ftInteger
      end
      item
        Name = 'SITUACAOESPERA_LAYOUT'
        DataType = ftInteger
      end
      item
        Name = 'SITUACAOESPERA_CORLAYOUT'
        DataType = ftInteger
      end
      item
        Name = 'ESTILOESPERA_LAYOUT'
        DataType = ftInteger
      end
      item
        Name = 'MODO_CALL_CENTER'
        Attributes = [faFixed]
        DataType = ftString
        Size = 1
      end>
    IndexDefs = <>
    Params = <
      item
        DataType = ftUnknown
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspSicsOnLine'
    StoreDefs = True
    Left = 1141
    Top = 648
    object cdsSicsOnLineID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
      Required = True
    end
    object cdsSicsOnLineID: TIntegerField
      FieldName = 'ID'
      Required = True
    end
    object cdsSicsOnLineFILAS_PERMITIDAS: TStringField
      FieldName = 'FILAS_PERMITIDAS'
      Size = 80
    end
    object cdsSicsOnLineMOSTRAR_BOTAO_NAS_FILAS: TStringField
      FieldName = 'MOSTRAR_BOTAO_NAS_FILAS'
      Size = 500
    end
    object cdsSicsOnLineGRUPOS_INDICADORES_PERMITIDOS: TStringField
      FieldName = 'GRUPOS_INDICADORES_PERMITIDOS'
      Size = 500
    end
    object cdsSicsOnLineMOSTRAR_BLOQUEAR_NAS_FILAS: TStringField
      FieldName = 'MOSTRAR_BLOQUEAR_NAS_FILAS'
      Size = 500
    end
    object cdsSicsOnLineMOSTRAR_PRIORITARIA_NAS_FILAS: TStringField
      FieldName = 'MOSTRAR_PRIORITARIA_NAS_FILAS'
      Size = 500
    end
    object cdsSicsOnLinePERMITIR_INCLUSAO_NAS_FILAS: TStringField
      FieldName = 'PERMITIR_INCLUSAO_NAS_FILAS'
      Size = 500
    end
    object cdsSicsOnLineIMPRESSORA_COMANDADA: TIntegerField
      FieldName = 'IMPRESSORA_COMANDADA'
    end
    object cdsSicsOnLineCOLUNAS_DE_FILAS: TIntegerField
      FieldName = 'COLUNAS_DE_FILAS'
    end
    object cdsSicsOnLineMODO_TOTEM_TOUCH: TStringField
      FieldName = 'MODO_TOTEM_TOUCH'
      FixedChar = True
      Size = 1
    end
    object cdsSicsOnLineGRUPOS_MOTIVOS_PAUSA_PERMITIDO: TStringField
      FieldName = 'GRUPOS_MOTIVOS_PAUSA_PERMITIDO'
      Size = 500
    end
    object cdsSicsOnLineVISUALIZAR_GRUPOS: TStringField
      FieldName = 'VISUALIZAR_GRUPOS'
      FixedChar = True
      Size = 1
    end
    object cdsSicsOnLineTOTEM_BOTOES_COLUNAS: TIntegerField
      FieldName = 'TOTEM_BOTOES_COLUNAS'
    end
    object cdsSicsOnLineTOTEM_BOTOES_TRANSPARENTES: TStringField
      FieldName = 'TOTEM_BOTOES_TRANSPARENTES'
      FixedChar = True
      Size = 1
    end
    object cdsSicsOnLineTOTEM_BOTOES_MARGEM_SUPERIOR: TIntegerField
      FieldName = 'TOTEM_BOTOES_MARGEM_SUPERIOR'
    end
    object cdsSicsOnLineTOTEM_BOTOES_MARGEM_INFERIOR: TIntegerField
      FieldName = 'TOTEM_BOTOES_MARGEM_INFERIOR'
    end
    object cdsSicsOnLineTOTEM_BOTOES_MARGEM_DIREITA: TIntegerField
      FieldName = 'TOTEM_BOTOES_MARGEM_DIREITA'
    end
    object cdsSicsOnLineTOTEM_BOTOES_MARGEM_ESQUERDA: TIntegerField
      FieldName = 'TOTEM_BOTOES_MARGEM_ESQUERDA'
    end
    object cdsSicsOnLineTOTEM_BOTOES_ESPACO_COLUNAS: TIntegerField
      FieldName = 'TOTEM_BOTOES_ESPACO_COLUNAS'
    end
    object cdsSicsOnLineTOTEM_BOTOES_ESPACO_LINHAS: TIntegerField
      FieldName = 'TOTEM_BOTOES_ESPACO_LINHAS'
    end
    object cdsSicsOnLineLINHAS_DE_FILAS: TIntegerField
      FieldName = 'LINHAS_DE_FILAS'
    end
    object cdsSicsOnLineTOTEM_PORTA_TCP: TIntegerField
      FieldName = 'TOTEM_PORTA_TCP'
    end
    object cdsSicsOnLineTOTEM_IMAGEM_FUNDO: TStringField
      FieldName = 'TOTEM_IMAGEM_FUNDO'
      Size = 300
    end
    object cdsSicsOnLineTOTEM_PORTA_SERIAL_IMPRESSORA: TStringField
      FieldName = 'TOTEM_PORTA_SERIAL_IMPRESSORA'
      Size = 40
    end
    object cdsSicsOnLineTOTEM_MOSTRAR_BOTAO_FECHAR: TStringField
      FieldName = 'TOTEM_MOSTRAR_BOTAO_FECHAR'
      FixedChar = True
      Size = 1
    end
    object cdsSicsOnLineTOTEM_BOTAO_FECHAR_TAM_MAIOR: TStringField
      FieldName = 'TOTEM_BOTAO_FECHAR_TAM_MAIOR'
      FixedChar = True
      Size = 1
    end
    object cdsSicsOnLinePERMITIR_EXCLUSAO_NAS_FILAS: TStringField
      FieldName = 'PERMITIR_EXCLUSAO_NAS_FILAS'
      Size = 500
    end
    object cdsSicsOnLinePODE_FECHAR_PROGRAMA: TStringField
      FieldName = 'PODE_FECHAR_PROGRAMA'
      FixedChar = True
      Size = 1
    end
    object cdsSicsOnLineGRUPOS_ATENDENTES_PERMITIDOS: TStringField
      FieldName = 'GRUPOS_ATENDENTES_PERMITIDOS'
      Size = 500
    end
    object cdsSicsOnLineGRUPOS_PAS_PERMITIDAS: TStringField
      FieldName = 'GRUPOS_PAS_PERMITIDAS'
      Size = 500
    end
    object cdsSicsOnLineGRUPOS_TAGS_PERMITIDAS: TStringField
      FieldName = 'GRUPOS_TAGS_PERMITIDAS'
      Size = 500
    end
    object cdsSicsOnLineVISUALIZAR_NOME_CLIENTES: TStringField
      FieldName = 'VISUALIZAR_NOME_CLIENTES'
      Size = 1
    end
    object cdsSicsOnLinePERMITIR_REIMPRESSAO_NAS_FILAS: TStringField
      FieldName = 'PERMITIR_REIMPRESSAO_NAS_FILAS'
      Size = 500
    end
    object cdsSicsOnLineMOSTRAR_EXCLUIR_TODAS: TStringField
      FieldName = 'MOSTRAR_EXCLUIR_TODAS'
      Size = 1
    end
    object cdsSicsOnLineTELA_PADRAO: TIntegerField
      FieldName = 'TELA_PADRAO'
    end
    object cdsSicsOnLineTAMANHO_FONTE: TIntegerField
      FieldName = 'TAMANHO_FONTE'
    end
    object cdsSicsOnLineMOSTRA_TEMPO_DECORRIDO_ESPERA: TStringField
      FieldName = 'MOSTRA_TEMPO_DECORRIDO_ESPERA'
      FixedChar = True
      Size = 1
    end
    object cdsSicsOnLineSITUACAOESPERA_LAYOUT: TIntegerField
      FieldName = 'SITUACAOESPERA_LAYOUT'
    end
    object cdsSicsOnLineSITUACAOESPERA_CORLAYOUT: TIntegerField
      FieldName = 'SITUACAOESPERA_CORLAYOUT'
    end
    object cdsSicsOnLineESTILOESPERA_LAYOUT: TIntegerField
      FieldName = 'ESTILOESPERA_LAYOUT'
    end
    object cdsSicsOnLineMODO_CALL_CENTER: TStringField
      FieldName = 'MODO_CALL_CENTER'
      FixedChar = True
      Size = 1
    end
    object cdsSicsOnLineMOSTRAR_DADOS_ADICIONAIS: TStringField
      FieldName = 'MOSTRAR_DADOS_ADICIONAIS'
      Size = 500
    end
  end
  object dscSicsOnLine: TDataSource
    DataSet = cdsSicsOnLine
    Left = 1222
    Top = 648
  end
  object dscSicsTGS: TDataSource
    DataSet = cdsSicsTGS
    Left = 1222
    Top = 432
  end
  object cdsSicsTGS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive, foNoPartialCompare]
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspSicsTGS'
    Left = 1141
    Top = 431
    object cdsSicsTGSID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
      Required = True
    end
    object cdsSicsTGSID: TIntegerField
      FieldName = 'ID'
      Required = True
    end
    object cdsSicsTGSMINIMIZAR_PARA_BANDEJA: TStringField
      FieldName = 'MINIMIZAR_PARA_BANDEJA'
      FixedChar = True
      Size = 1
    end
    object cdsSicsTGSPODE_FECHAR_PROGRAMA: TStringField
      FieldName = 'PODE_FECHAR_PROGRAMA'
      FixedChar = True
      Size = 1
    end
    object cdsSicsTGSPODE_CONFIG_ATENDENTES: TStringField
      FieldName = 'PODE_CONFIG_ATENDENTES'
      FixedChar = True
      Size = 1
    end
    object cdsSicsTGSREPORTAR_TEMPOS_MAXIMOS: TStringField
      FieldName = 'REPORTAR_TEMPOS_MAXIMOS'
      FixedChar = True
      Size = 1
    end
    object cdsSicsTGSPODE_CONFIG_PRIORIDADES_ATEND: TStringField
      FieldName = 'PODE_CONFIG_PRIORIDADES_ATEND'
      FixedChar = True
      Size = 1
    end
    object cdsSicsTGSPODE_CONFIG_IND_DE_PERFORMANCE: TStringField
      FieldName = 'PODE_CONFIG_IND_DE_PERFORMANCE'
      FixedChar = True
      Size = 1
    end
    object cdsSicsTGSGRUPOS_DE_ATENDENTES_PERMITIDOS: TStringField
      FieldName = 'GRUPOS_DE_ATENDENTES_PERMITIDOS'
      Size = 500
    end
    object cdsSicsTGSGRUPOS_DE_PAS_PERMITIDAS: TStringField
      FieldName = 'GRUPOS_DE_PAS_PERMITIDAS'
      Size = 500
    end
    object cdsSicsTGSGRUPOS_DE_TAGS_PERMITIDOS: TStringField
      FieldName = 'GRUPOS_DE_TAGS_PERMITIDOS'
      Size = 500
    end
    object cdsSicsTGSGRUPOS_DE_MOTIVOS_DE_PAUSA_PERM: TStringField
      FieldName = 'GRUPOS_DE_MOTIVOS_DE_PAUSA_PERM'
      Size = 500
    end
    object cdsSicsTGSGRUPOS_INDICADORES_PERMITIDOS: TStringField
      FieldName = 'GRUPOS_INDICADORES_PERMITIDOS'
      Size = 500
    end
    object cdsSicsTGSVISUALIZAR_GRUPOS: TStringField
      FieldName = 'VISUALIZAR_GRUPOS'
      FixedChar = True
      Size = 1
    end
    object cdsSicsTGSVISUALIZAR_NOME_CLIENTES: TStringField
      FieldName = 'VISUALIZAR_NOME_CLIENTES'
      FixedChar = True
      Size = 1
    end
    object cdsSicsTGSMODO_CALL_CENTER: TStringField
      FieldName = 'MODO_CALL_CENTER'
      FixedChar = True
      Size = 1
    end
  end
  object dspSicsTGS: TDataSetProvider
    DataSet = qrySicsTGS
    Left = 1062
    Top = 432
  end
  object qrySicsTGS: TFDQuery
    Connection = connOnLine
    SQL.Strings = (
      'SELECT '
      '  * '
      'FROM '
      '  MODULOS_TGS'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE')
    Left = 974
    Top = 430
    ParamData = <
      item
        Position = 1
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
      end>
  end
  object cdsConfiguracoesGerais: TClientDataSet
    Aggregates = <>
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspConfiguracoesGerais'
    Left = 1186
    Top = 153
    object cdsConfiguracoesGeraisID: TStringField
      DisplayWidth = 100
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
      Size = 50
    end
    object cdsConfiguracoesGeraisVALOR: TStringField
      FieldName = 'VALOR'
      Origin = 'VALOR'
      Size = 300
    end
  end
  object dspConfiguracoesGerais: TDataSetProvider
    DataSet = qryConfiguracoesGerais
    Left = 1189
    Top = 101
  end
  object cdsTelasOnline: TClientDataSet
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'ID'
        DataType = ftInteger
      end
      item
        Name = 'NOME'
        DataType = ftString
        Size = 50
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 1142
    Top = 704
    object cdsTelasOnlineID: TIntegerField
      FieldName = 'ID'
    end
    object cdsTelasOnlineNOME: TStringField
      FieldName = 'NOME'
      Size = 50
    end
  end
  object dscTelasOnline: TDataSource
    DataSet = cdsTelasOnline
    Left = 1222
    Top = 704
  end
  object cdsTamanhoFonteOnline: TClientDataSet
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'ID'
        DataType = ftInteger
      end
      item
        Name = 'NOME'
        DataType = ftString
        Size = 20
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 686
    Top = 616
    object cdsTamanhoFonteOnlineID: TIntegerField
      FieldName = 'ID'
    end
    object cdsTamanhoFonteOnlineNOME: TStringField
      FieldName = 'NOME'
    end
  end
  object dsTamanhoFonteOnline: TDataSource
    DataSet = cdsTamanhoFonteOnline
    Left = 814
    Top = 616
  end
  object qryQtdePIsSemFormatoHorario: TFDQuery
    Connection = connOnLine
    SQL.Strings = (
      'SELECT'
      '  COUNT(*)'
      'FROM'
      '  PIS_RELACIONADOS PIR'
      
        '  INNER JOIN           PIS ON (PIR.ID_UNIDADE     = PIS.ID_UNIDA' +
        'DE AND'
      '                               PIR.ID_RELACIONADO = PIS.ID_PI)'
      
        '  INNER JOIN PIS_TIPOS PIT ON (PIS.ID_UNIDADE     = PIT.ID_UNIDA' +
        'DE AND '
      
        '                               PIS.ID_PITIPO      = PIT.ID_PITIP' +
        'O  AND '
      '                               PIT.FORMATOHORARIO = '#39'F'#39')'
      'WHERE'
      '  PIR.ID_UNIDADE = :ID_UNIDADE AND'
      '  PIR.ID_PI      = :ID_PI')
    Left = 1014
    Top = 152
    ParamData = <
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'ID_PI'
        DataType = ftInteger
        ParamType = ptInput
      end>
  end
  object cdsPaineisClone: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 688
    Top = 568
  end
  object cdsPISClone: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 686
    Top = 160
  end
  object qryInsertCampoAdicional: TFDQuery
    Connection = connOnLine
    SQL.Strings = (
      'insert into TICKETS_CAMPOSADIC('
      '  ID_UNIDADE,'
      '  ID_TICKET,'
      '  CAMPO,'
      '  VALOR'
      ') values ('
      '  :ID_UNIDADE,'
      '  :ID_TICKET,'
      '  :CAMPO,'
      '  :VALOR'
      ')')
    Left = 40
    Top = 288
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
      end
      item
        Name = 'CAMPO'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'VALOR'
        DataType = ftString
        ParamType = ptInput
      end>
  end
  object qryCamposAdicionais: TFDQuery
    Connection = connOnLine
    SQL.Strings = (
      'select'
      '  CAMPO,'
      '  VALOR'
      'from '
      '  TICKETS_CAMPOSADIC'
      'where'
      '  ID_UNIDADE = :ID_UNIDADE AND'
      '  ID_TICKET = :ID_TICKET')
    Left = 40
    Top = 336
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
  end
  object qryDtHrEmissaoSenha: TFDQuery
    Connection = connOnLine
    SQL.Strings = (
      'select'
      '  ID_UNIDADE,'
      '  ID,'
      '  INICIO'
      'from'
      '  EVENTOS'
      'where'
      '  ID_UNIDADE = :ID_UNIDADE AND'
      '  ID_TICKET = :TICKETID  '
      '{limit(1)}'
      'order by'
      '  ID')
    Left = 40
    Top = 392
    ParamData = <
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'TICKETID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
    object qryDtHrEmissaoSenhaINICIO: TSQLTimeStampField
      FieldName = 'INICIO'
    end
    object qryDtHrEmissaoSenhaID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
      Origin = 'ID_UNIDADE'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qryDtHrEmissaoSenhaID: TIntegerField
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
  end
  object qryDeviceIdSenha: TFDQuery
    Connection = connOnLine
    SQL.Strings = (
      'select'
      '  DEVICEID'
      'from'
      '  TICKETS'
      'where'
      '  ID_UNIDADE = :ID_UNIDADE AND'
      '  ID = :ID')
    Left = 128
    Top = 392
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
  object cdsLayoutsEsperaOnLine: TClientDataSet
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'ID'
        DataType = ftInteger
      end
      item
        Name = 'NOME'
        DataType = ftString
        Size = 20
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 686
    Top = 664
    object IntegerField1: TIntegerField
      FieldName = 'ID'
    end
    object StringField1: TStringField
      FieldName = 'NOME'
    end
  end
  object dsLayoutsEsperaOnLine: TDataSource
    DataSet = cdsLayoutsEsperaOnLine
    Left = 814
    Top = 664
  end
  object cdsCorLimiarOnLine: TClientDataSet
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'ID'
        DataType = ftInteger
      end
      item
        Name = 'NOME'
        DataType = ftString
        Size = 20
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 686
    Top = 712
    object IntegerField2: TIntegerField
      FieldName = 'ID'
    end
    object StringField2: TStringField
      FieldName = 'NOME'
    end
  end
  object dsCorLimiarOnLine: TDataSource
    DataSet = cdsCorLimiarOnLine
    Left = 814
    Top = 712
  end
  object cdsEstiloLayoutsEsperaOnline: TClientDataSet
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'ID'
        DataType = ftInteger
      end
      item
        Name = 'NOME'
        DataType = ftString
        Size = 20
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 686
    Top = 768
    object IntegerField3: TIntegerField
      FieldName = 'ID'
    end
    object StringField3: TStringField
      FieldName = 'NOME'
    end
  end
  object dsEstiloLayoutsEsperaOnline: TDataSource
    DataSet = cdsEstiloLayoutsEsperaOnline
    Left = 814
    Top = 768
  end
  object qrySicsCallCenter: TFDQuery
    Connection = connOnLine
    SQL.Strings = (
      'SELECT '
      '  * '
      'FROM '
      '  MODULOS_CALLCENTER'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE')
    Left = 973
    Top = 773
    ParamData = <
      item
        Position = 1
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
      end>
  end
  object dspSicsCallCenter: TDataSetProvider
    DataSet = qrySicsCallCenter
    Left = 1062
    Top = 768
  end
  object cdsSicsCallCenter: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive, foNoPartialCompare]
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspSicsCallCenter'
    Left = 1143
    Top = 769
    object cdsSicsCallCenterID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
      Required = True
    end
    object IntegerField4: TIntegerField
      FieldName = 'ID'
      Required = True
      OnGetText = IntegerField4GetText
      DisplayFormat = '00'
    end
    object IntegerField5: TIntegerField
      FieldName = 'NUMERO_MESA'
    end
    object cdsSicsCallCenterLOGIN_WINDOWS: TStringField
      DefaultExpression = #39'F'#39
      FieldName = 'LOGIN_WINDOWS'
      Size = 1
    end
  end
  object dsSicsCallCenter: TDataSource
    DataSet = cdsSicsCallCenter
    Left = 1222
    Top = 768
  end
  object qryClientesLogin: TFDQuery
    Connection = connOnLine
    SQL.Strings = (
      'Select '
      '  ID_UNIDADE,'
      '  ID, '
      '  NOME, '
      '  LOGIN,  '
      '  SENHALOGIN'
      'From '
      '  CLIENTES'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE')
    Left = 982
    Top = 368
    ParamData = <
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
    object qryClientesLoginID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
      Origin = 'ID_UNIDADE'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qryClientesLoginID: TIntegerField
      FieldName = 'ID'
      Required = True
    end
    object qryClientesLoginNOME: TStringField
      FieldName = 'NOME'
      Size = 60
    end
    object qryClientesLoginLOGIN: TStringField
      FieldName = 'LOGIN'
      Size = 30
    end
    object qryClientesLoginSENHALOGIN: TStringField
      FieldName = 'SENHALOGIN'
      Size = 32
    end
  end
  object qryAtendenteLogin: TFDQuery
    Connection = connOnLine
    SQL.Strings = (
      'Select'
      '  LOGIN,'
      '  SENHALOGIN'
      'From'
      '  ATENDENTES'
      'where'
      '  ID_UNIDADE = :ID_UNIDADE AND'
      '  LOGIN      = :LOGIN      AND'
      '  SENHALOGIN = :SENHALOGIN')
    Left = 1078
    Top = 368
    ParamData = <
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'LOGIN'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'SENHALOGIN'
        DataType = ftString
        ParamType = ptInput
      end>
  end
  object connRelatorio: TFDConnection
    LoginPrompt = False
    Left = 40
    Top = 448
  end
  object connUnidades: TFDConnection
    LoginPrompt = False
    Left = 288
    Top = 128
  end
  object connOnLine: TFDConnection
    LoginPrompt = False
    OnError = connOnLineError
    OnLost = connOnLineLost
    OnRestored = connOnLineRestored
    OnRecover = connOnLineRecover
    BeforeStartTransaction = connOnLineBeforeStartTransaction
    AfterStartTransaction = connOnLineAfterStartTransaction
    BeforeCommit = connOnLineBeforeCommit
    AfterCommit = connOnLineAfterCommit
    BeforeRollback = connOnLineBeforeRollback
    AfterRollback = connOnLineAfterRollback
    Left = 32
    Top = 16
  end
  object qryUnidades: TFDQuery
    Connection = connUnidades
    SQL.Strings = (
      'SELECT '
      '  * '
      'FROM '
      '  UNIDADES'
      'WHERE '
      '  ID = :ID')
    Left = 288
    Top = 176
    ParamData = <
      item
        Name = 'ID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
    object qryUnidadesID: TIntegerField
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qryUnidadesNOME: TStringField
      FieldName = 'NOME'
      Origin = 'NOME'
      Size = 40
    end
    object qryUnidadesDBDIR: TStringField
      FieldName = 'DBDIR'
      Origin = 'DBDIR'
      Size = 255
    end
    object qryUnidadesIP: TStringField
      FieldName = 'IP'
      Origin = 'IP'
      Size = 15
    end
    object qryUnidadesPORTA: TIntegerField
      FieldName = 'PORTA'
      Origin = 'PORTA'
    end
    object qryUnidadesPORTA_TGS: TIntegerField
      FieldName = 'PORTA_TGS'
      Origin = 'PORTA_TGS'
    end
    object qryUnidadesID_UNID_CLI: TStringField
      FieldName = 'ID_UNID_CLI'
      Origin = 'ID_UNID_CLI'
      Size = 32
    end
    object qryUnidadesIDGRUPO: TIntegerField
      FieldName = 'IDGRUPO'
      Origin = 'IDGRUPO'
    end
    object qryUnidadesHOST: TStringField
      FieldName = 'HOST'
      Origin = 'HOST'
      Size = 100
    end
    object qryUnidadesBANCO: TStringField
      FieldName = 'BANCO'
      Origin = 'BANCO'
      Size = 100
    end
    object qryUnidadesUSUARIO: TStringField
      FieldName = 'USUARIO'
      Origin = 'USUARIO'
      Size = 100
    end
    object qryUnidadesSENHA: TStringField
      FieldName = 'SENHA'
      Origin = 'SENHA'
      Size = 255
    end
    object qryUnidadesOSAUTHENT: TStringField
      FieldName = 'OSAUTHENT'
      Origin = 'OSAUTHENT'
      FixedChar = True
      Size = 1
    end
  end
  object qryContadoresDeFilas: TFDQuery
    Connection = connOnLine
    SQL.Strings = (
      'SELECT'
      '  F.ID_UNIDADE,'
      '  F.ID,'
      '  F.CONTADOR'
      'FROM'
      '  FILAS F '
      'WHERE'
      '  F.ID_UNIDADE = :ID_UNIDADE AND'
      '  F.ID = :ID'
      'ORDER BY'
      '  F.ID')
    Left = 40
    Top = 576
    ParamData = <
      item
        Position = 1
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
      end
      item
        Position = 2
        Name = 'ID'
        DataType = ftInteger
        ParamType = ptInput
      end>
    object qryContadoresDeFilasID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
      Origin = 'ID_UNIDADE'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qryContadoresDeFilasID: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInUpdate, pfInKey]
      ReadOnly = True
    end
    object qryContadoresDeFilasCONTADOR: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'CONTADOR'
      Origin = 'CONTADOR'
      ProviderFlags = [pfInUpdate]
    end
  end
  object dspContadoresDeFilas: TDataSetProvider
    DataSet = qryContadoresDeFilas
    Options = [poAutoRefresh, poPropogateChanges, poUseQuoteChar]
    UpdateMode = upWhereKeyOnly
    Left = 40
    Top = 624
  end
  object tmrAtualizaJornalTVs: TTimer
    Enabled = False
    OnTimer = tmrAtualizaJornalTVsTimer
    Left = 686
    Top = 504
  end
  object cdsGruposDePAsAtivos: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 256
    Top = 440
  end
  object dspAux: TDataSetProvider
    DataSet = qryAux
    Left = 104
    Top = 232
  end
  object qryFilas: TFDQuery
    Connection = connOnLine
    SQL.Strings = (
      'SELECT '
      '  * '
      'FROM '
      '  FILAS'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE')
    Left = 152
    Top = 16
    ParamData = <
      item
        Position = 1
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
      end>
  end
  object dspFilas: TDataSetProvider
    DataSet = qryFilas
    Left = 192
    Top = 16
  end
  object qryPAs: TFDQuery
    Connection = connOnLine
    SQL.Strings = (
      'SELECT * FROM PAS WHERE ID_UNIDADE = :ID_UNIDADE')
    Left = 248
    Top = 16
    ParamData = <
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object dspPAs: TDataSetProvider
    DataSet = qryPAs
    Left = 288
    Top = 16
  end
  object qryNN_PAs_Filas: TFDQuery
    Connection = connOnLine
    SQL.Strings = (
      'SELECT * FROM NN_PAS_FILAS WHERE ID_UNIDADE = :ID_UNIDADE')
    Left = 200
    Top = 240
    ParamData = <
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object dspNN_PAs_Filas: TDataSetProvider
    DataSet = qryNN_PAs_Filas
    Left = 288
    Top = 240
  end
  object qryGruposDeAtendentes: TFDQuery
    Connection = connOnLine
    SQL.Strings = (
      'SELECT '
      '  * '
      'FROM '
      '  GRUPOS_ATENDENTES'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE')
    Left = 400
    Top = 8
    ParamData = <
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object qryAtendentes: TFDQuery
    Connection = connOnLine
    SQL.Strings = (
      'SELECT '
      '  * '
      'FROM '
      '  ATENDENTES'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE')
    Left = 400
    Top = 62
    ParamData = <
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object qryEmails: TFDQuery
    Connection = connOnLine
    SQL.Strings = (
      'SELECT '
      '  * '
      'FROM '
      '  EMAILS'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE')
    Left = 400
    Top = 116
    ParamData = <
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object qryCelulares: TFDQuery
    Connection = connOnLine
    SQL.Strings = (
      'SELECT '
      '  * '
      'FROM '
      '  CELULARES'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE')
    Left = 400
    Top = 171
    ParamData = <
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object qryTags: TFDQuery
    Connection = connOnLine
    SQL.Strings = (
      'SELECT '
      '  * '
      'FROM '
      '  TAGS'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE')
    Left = 400
    Top = 225
    ParamData = <
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object qryGruposDeTags: TFDQuery
    Connection = connOnLine
    SQL.Strings = (
      'SELECT '
      '  * '
      'FROM '
      '  GRUPOS_TAGS'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE')
    Left = 400
    Top = 280
    ParamData = <
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object qryPISNiveis: TFDQuery
    Connection = connOnLine
    SQL.Strings = (
      'SELECT '
      '  * '
      'FROM '
      '  PIS_NIVEIS'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE')
    Left = 400
    Top = 334
    ParamData = <
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object qryGruposDeMotivosPausa: TFDQuery
    Connection = connOnLine
    SQL.Strings = (
      'SELECT '
      '  * '
      'FROM '
      '  GRUPOS_MOTIVOS_PAUSA'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE')
    Left = 400
    Top = 388
    ParamData = <
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object qryMotivosDePausa: TFDQuery
    Connection = connOnLine
    SQL.Strings = (
      'SELECT '
      '  * '
      'FROM '
      '  MOTIVOS_PAUSA'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE')
    Left = 400
    Top = 443
    ParamData = <
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object qryStatusDasPAs: TFDQuery
    Connection = connOnLine
    SQL.Strings = (
      'SELECT '
      '  * '
      'FROM '
      '  STATUS_PAS'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE')
    Left = 400
    Top = 497
    ParamData = <
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object qryPPs: TFDQuery
    Connection = connOnLine
    SQL.Strings = (
      'SELECT '
      '  * '
      'FROM '
      '  PPS'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE')
    Left = 400
    Top = 552
    ParamData = <
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object dspGruposDeAtendentes: TDataSetProvider
    DataSet = qryGruposDeAtendentes
    Left = 488
    Top = 8
  end
  object dspAtendentes: TDataSetProvider
    DataSet = qryAtendentes
    Left = 488
    Top = 62
  end
  object dspEmails: TDataSetProvider
    DataSet = qryEmails
    Left = 488
    Top = 116
  end
  object dspCelulares: TDataSetProvider
    DataSet = qryCelulares
    Left = 488
    Top = 171
  end
  object dspTags: TDataSetProvider
    DataSet = qryTags
    Left = 488
    Top = 225
  end
  object dspGruposDeTags: TDataSetProvider
    DataSet = qryGruposDeTags
    Left = 488
    Top = 280
  end
  object dspPISNiveis: TDataSetProvider
    DataSet = qryPISNiveis
    Left = 488
    Top = 334
  end
  object dspGruposDeMotivosPausa: TDataSetProvider
    DataSet = qryGruposDeMotivosPausa
    Left = 488
    Top = 388
  end
  object dspMotivosDePausa: TDataSetProvider
    DataSet = qryMotivosDePausa
    Left = 488
    Top = 443
  end
  object dspStatusDasPAs: TDataSetProvider
    DataSet = qryStatusDasPAs
    Left = 488
    Top = 497
  end
  object dspPPs: TDataSetProvider
    DataSet = qryPPs
    Left = 488
    Top = 552
  end
  object qryGruposDePPs: TFDQuery
    Connection = connOnLine
    SQL.Strings = (
      'SELECT '
      '  * '
      'FROM '
      '  GRUPOS_PPS'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE')
    Left = 400
    Top = 608
    ParamData = <
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object dspGruposDePPs: TDataSetProvider
    DataSet = qryGruposDePPs
    Left = 488
    Top = 608
  end
  object qryPaineis: TFDQuery
    Connection = connOnLine
    SQL.Strings = (
      'SELECT '
      '  * '
      'FROM '
      '  PAINEIS'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE')
    Left = 400
    Top = 664
    ParamData = <
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object dspPaineis: TDataSetProvider
    DataSet = qryPaineis
    Left = 488
    Top = 664
  end
  object qryGruposDePAs: TFDQuery
    Connection = connOnLine
    SQL.Strings = (
      'SELECT '
      '  * '
      'FROM '
      '  GRUPOS_PAS'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE')
    Left = 400
    Top = 720
    ParamData = <
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object dspGruposDePAs: TDataSetProvider
    DataSet = qryGruposDePAs
    Left = 488
    Top = 720
  end
  object qryGruposDePaineis: TFDQuery
    Connection = connOnLine
    SQL.Strings = (
      'SELECT '
      '  * '
      'FROM '
      '  GRUPOS_PAINEIS'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE')
    Left = 400
    Top = 776
    ParamData = <
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object dspGruposDePaineis: TDataSetProvider
    DataSet = qryGruposDePaineis
    Left = 488
    Top = 776
  end
  object qryConfiguracoesGerais: TFDQuery
    Connection = connOnLine
    SQL.Strings = (
      'SELECT '
      '  *'
      'FROM'
      '  CONFIGURACOES_GERAIS'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE')
    Left = 1192
    Top = 48
    ParamData = <
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object cdsNN_PAs_Filas_SemFiltro: TClientDataSet
    Aggregates = <>
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspNN_PAs_Filas_SemFiltro'
    Left = 576
    Top = 832
  end
  object qryNN_PAs_Filas_SemFiltro: TFDQuery
    Connection = connOnLine
    SQL.Strings = (
      'SELECT'
      '  *'
      'FROM'
      '  NN_PAS_FILAS'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE')
    Left = 400
    Top = 832
    ParamData = <
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object dspNN_PAs_Filas_SemFiltro: TDataSetProvider
    DataSet = qryNN_PAs_Filas_SemFiltro
    Left = 488
    Top = 832
  end
  object cdsPASClone: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 264
    Top = 304
  end
  object cdsFilasClone: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 216
    Top = 128
  end
  object qryGrupoFila: TFDQuery
    Connection = connOnLine
    SQL.Strings = (
      'SELECT '
      '  * '
      'FROM '
      '  GRUPOS_FILAS'
      '')
    Left = 168
    Top = 552
  end
  object dspGrupoFila: TDataSetProvider
    DataSet = qryGrupoFila
    Left = 248
    Top = 552
  end
  object cdsGrupoFila: TClientDataSet
    Aggregates = <>
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspGrupoFila'
    Left = 168
    Top = 608
  end
  object dsGrupoFila: TDataSource
    DataSet = cdsGrupoFila
    Left = 248
    Top = 608
  end
  object qryCategoriaFilas: TFDQuery
    Connection = connOnLine
    SQL.Strings = (
      'SELECT '
      '  * '
      'FROM '
      '  CATEGORIAS_FILAS'
      '')
    Left = 168
    Top = 664
  end
  object dspCategoriaFilas: TDataSetProvider
    DataSet = qryCategoriaFilas
    Left = 248
    Top = 664
  end
  object cdsCategoriaFilas: TClientDataSet
    Aggregates = <>
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspCategoriaFilas'
    Left = 168
    Top = 720
  end
  object dsCategoriaFilas: TDataSource
    DataSet = cdsCategoriaFilas
    Left = 248
    Top = 720
  end
  object qryAddModulos: TFDQuery
    Connection = connOnLine
    SQL.Strings = (
      'Select * from'
      'MODULOS'
      '')
    Left = 880
    Top = 552
  end
  object cdsAddModulos: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspAddModulos'
    Left = 876
    Top = 673
    object cdsAddModulosID: TIntegerField
      FieldName = 'ID'
      Required = True
    end
    object cdsAddModulosTIPO: TIntegerField
      FieldName = 'TIPO'
    end
    object cdsAddModulosNOME: TStringField
      FieldName = 'NOME'
      Size = 30
    end
    object cdsAddModulosID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
    end
  end
  object dspAddModulos: TDataSetProvider
    DataSet = qryAddModulos
    Left = 879
    Top = 613
  end
  object cdsAddPaineis: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspAddPaineis'
    Left = 1132
    Top = 129
    object cdsAddPaineisID: TIntegerField
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object cdsAddPaineisTIPO: TIntegerField
      FieldName = 'TIPO'
      Origin = 'TIPO'
    end
    object cdsAddPaineisBACKGROUNDFILE: TStringField
      FieldName = 'BACKGROUNDFILE'
      Origin = 'BACKGROUNDFILE'
      Size = 200
    end
    object cdsAddPaineisFONTE: TStringField
      FieldName = 'FONTE'
      Origin = 'FONTE'
      Size = 50
    end
    object cdsAddPaineisARQUIVOSOM: TStringField
      FieldName = 'ARQUIVOSOM'
      Origin = 'ARQUIVOSOM'
      Size = 200
    end
    object cdsAddPaineisFLASHFILE: TStringField
      FieldName = 'FLASHFILE'
      Origin = 'FLASHFILE'
      Size = 200
    end
    object cdsAddPaineisCAMINHODOEXECUTAVEL: TStringField
      FieldName = 'CAMINHODOEXECUTAVEL'
      Origin = 'CAMINHODOEXECUTAVEL'
      Size = 200
    end
    object cdsAddPaineisNOMEDAJANELA: TStringField
      FieldName = 'NOMEDAJANELA'
      Origin = 'NOMEDAJANELA'
      Size = 50
    end
    object cdsAddPaineisRESOLUCAOPADRAO: TStringField
      FieldName = 'RESOLUCAOPADRAO'
      Origin = 'RESOLUCAOPADRAO'
      FixedChar = True
      Size = 50
    end
    object cdsAddPaineisARQUIVOSVIDEO: TStringField
      FieldName = 'ARQUIVOSVIDEO'
      Origin = 'ARQUIVOSVIDEO'
      Size = 200
    end
    object cdsAddPaineisHOSTBANCO: TStringField
      FieldName = 'HOSTBANCO'
      Origin = 'HOSTBANCO'
      Size = 50
    end
    object cdsAddPaineisPORTABANCO: TStringField
      FieldName = 'PORTABANCO'
      Origin = 'PORTABANCO'
      Size = 50
    end
    object cdsAddPaineisNOMEARQUIVOBANCO: TStringField
      FieldName = 'NOMEARQUIVOBANCO'
      Origin = 'NOMEARQUIVOBANCO'
      Size = 200
    end
    object cdsAddPaineisUSUARIOBANCO: TStringField
      FieldName = 'USUARIOBANCO'
      Origin = 'USUARIOBANCO'
      Size = 50
    end
    object cdsAddPaineisSENHABANCO: TStringField
      FieldName = 'SENHABANCO'
      Origin = 'SENHABANCO'
      Size = 50
    end
    object cdsAddPaineisDIRETORIOLOCAL: TStringField
      FieldName = 'DIRETORIOLOCAL'
      Origin = 'DIRETORIOLOCAL'
      Size = 200
    end
    object cdsAddPaineisLAYOUTSENHAX: TIntegerField
      FieldName = 'LAYOUTSENHAX'
      Origin = 'LAYOUTSENHAX'
    end
    object cdsAddPaineisLAYOUTSENHAY: TIntegerField
      FieldName = 'LAYOUTSENHAY'
      Origin = 'LAYOUTSENHAY'
    end
    object cdsAddPaineisLAYOUTSENHALARG: TIntegerField
      FieldName = 'LAYOUTSENHALARG'
      Origin = 'LAYOUTSENHALARG'
    end
    object cdsAddPaineisLAYOUTSENHAALT: TIntegerField
      FieldName = 'LAYOUTSENHAALT'
      Origin = 'LAYOUTSENHAALT'
    end
    object cdsAddPaineisLAYOUTPAX: TIntegerField
      FieldName = 'LAYOUTPAX'
      Origin = 'LAYOUTPAX'
    end
    object cdsAddPaineisLAYOUTPAY: TIntegerField
      FieldName = 'LAYOUTPAY'
      Origin = 'LAYOUTPAY'
    end
    object cdsAddPaineisLAYOUTPALARG: TIntegerField
      FieldName = 'LAYOUTPALARG'
      Origin = 'LAYOUTPALARG'
    end
    object cdsAddPaineisLAYOUTPAALT: TIntegerField
      FieldName = 'LAYOUTPAALT'
      Origin = 'LAYOUTPAALT'
    end
    object cdsAddPaineisLAYOUTNOMECLIENTEX: TIntegerField
      FieldName = 'LAYOUTNOMECLIENTEX'
      Origin = 'LAYOUTNOMECLIENTEX'
    end
    object cdsAddPaineisLAYOUTNOMECLIENTEY: TIntegerField
      FieldName = 'LAYOUTNOMECLIENTEY'
      Origin = 'LAYOUTNOMECLIENTEY'
    end
    object cdsAddPaineisLAYOUTNOMECLIENTELARG: TIntegerField
      FieldName = 'LAYOUTNOMECLIENTELARG'
      Origin = 'LAYOUTNOMECLIENTELARG'
    end
    object cdsAddPaineisLAYOUTNOMECLIENTEALT: TIntegerField
      FieldName = 'LAYOUTNOMECLIENTEALT'
      Origin = 'LAYOUTNOMECLIENTEALT'
    end
    object cdsAddPaineisQUANTIDADE: TStringField
      FieldName = 'QUANTIDADE'
      Origin = 'QUANTIDADE'
      Size = 50
    end
    object cdsAddPaineisATRASO: TStringField
      FieldName = 'ATRASO'
      Origin = 'ATRASO'
      Size = 50
    end
    object cdsAddPaineisESPACAMENTO: TStringField
      FieldName = 'ESPACAMENTO'
      Origin = 'ESPACAMENTO'
      Size = 50
    end
    object cdsAddPaineisPASPERMITIDAS: TStringField
      FieldName = 'PASPERMITIDAS'
      Origin = 'PASPERMITIDAS'
      FixedChar = True
      Size = 400
    end
    object cdsAddPaineisMARGEMSUPERIOR: TIntegerField
      FieldName = 'MARGEMSUPERIOR'
      Origin = 'MARGEMSUPERIOR'
    end
    object cdsAddPaineisMARGEMINFERIOR: TIntegerField
      FieldName = 'MARGEMINFERIOR'
      Origin = 'MARGEMINFERIOR'
    end
    object cdsAddPaineisMARGEMESQUERDA: TIntegerField
      FieldName = 'MARGEMESQUERDA'
      Origin = 'MARGEMESQUERDA'
    end
    object cdsAddPaineisMARGEMDIREITA: TIntegerField
      FieldName = 'MARGEMDIREITA'
      Origin = 'MARGEMDIREITA'
    end
    object cdsAddPaineisFORMATO: TStringField
      FieldName = 'FORMATO'
      Origin = 'FORMATO'
      Size = 50
    end
    object cdsAddPaineisNOMEARQUIVOHTML: TStringField
      FieldName = 'NOMEARQUIVOHTML'
      Origin = 'NOMEARQUIVOHTML'
      Size = 200
    end
    object cdsAddPaineisINDICADORSOMPI: TStringField
      FieldName = 'INDICADORSOMPI'
      Origin = 'INDICADORSOMPI'
      Size = 200
    end
    object cdsAddPaineisARQUIVOSOMPI: TStringField
      FieldName = 'ARQUIVOSOMPI'
      Origin = 'ARQUIVOSOMPI'
      Size = 200
    end
    object cdsAddPaineisLEFT: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'LEFT'
      Origin = '"LEFT"'
      EditFormat = '0'
    end
    object cdsAddPaineisTOP: TIntegerField
      FieldName = 'TOP'
      Origin = 'TOP'
      EditFormat = '0'
    end
    object cdsAddPaineisHEIGHT: TIntegerField
      FieldName = 'HEIGHT'
      Origin = 'HEIGHT'
      EditFormat = '0'
    end
    object cdsAddPaineisCOLOR: TIntegerField
      FieldName = 'COLOR'
      Origin = 'COLOR'
    end
    object cdsAddPaineisFONTESIZE: TIntegerField
      FieldName = 'FONTESIZE'
      Origin = 'FONTESIZE'
    end
    object cdsAddPaineisFONTECOLOR: TIntegerField
      FieldName = 'FONTECOLOR'
      Origin = 'FONTECOLOR'
    end
    object cdsAddPaineisSOFTWAREHOMOLOGADO: TIntegerField
      FieldName = 'SOFTWAREHOMOLOGADO'
      Origin = 'SOFTWAREHOMOLOGADO'
    end
    object cdsAddPaineisDISPOSITIVO: TIntegerField
      FieldName = 'DISPOSITIVO'
      Origin = 'DISPOSITIVO'
    end
    object cdsAddPaineisRESOLUCAO: TIntegerField
      FieldName = 'RESOLUCAO'
      Origin = 'RESOLUCAO'
    end
    object cdsAddPaineisTEMPOALTERNANCIA: TIntegerField
      FieldName = 'TEMPOALTERNANCIA'
      Origin = 'TEMPOALTERNANCIA'
    end
    object cdsAddPaineisIDTVPLAYLISTMANAGER: TIntegerField
      FieldName = 'IDTVPLAYLISTMANAGER'
      Origin = 'IDTVPLAYLISTMANAGER'
    end
    object cdsAddPaineisTIPOBANCO: TIntegerField
      FieldName = 'TIPOBANCO'
      Origin = 'TIPOBANCO'
    end
    object cdsAddPaineisINTERVALOVERIFICACAO: TIntegerField
      FieldName = 'INTERVALOVERIFICACAO'
      Origin = 'INTERVALOVERIFICACAO'
    end
    object cdsAddPaineisLAYOUTSENHAALINHAMENTO: TIntegerField
      FieldName = 'LAYOUTSENHAALINHAMENTO'
      Origin = 'LAYOUTSENHAALINHAMENTO'
    end
    object cdsAddPaineisLAYOUTPAALINHAMENTO: TIntegerField
      FieldName = 'LAYOUTPAALINHAMENTO'
      Origin = 'LAYOUTPAALINHAMENTO'
    end
    object cdsAddPaineisLAYOUTNOMECLIENTEALINHAMENTO: TIntegerField
      FieldName = 'LAYOUTNOMECLIENTEALINHAMENTO'
      Origin = 'LAYOUTNOMECLIENTEALINHAMENTO'
    end
    object cdsAddPaineisSOMVOZCHAMADA0: TIntegerField
      FieldName = 'SOMVOZCHAMADA0'
      Origin = 'SOMVOZCHAMADA0'
    end
    object cdsAddPaineisSOMVOZCHAMADA1: TIntegerField
      FieldName = 'SOMVOZCHAMADA1'
      Origin = 'SOMVOZCHAMADA1'
    end
    object cdsAddPaineisSOMVOZCHAMADA2: TIntegerField
      FieldName = 'SOMVOZCHAMADA2'
      Origin = 'SOMVOZCHAMADA2'
    end
    object cdsAddPaineisVOICEINDEX: TIntegerField
      FieldName = 'VOICEINDEX'
      Origin = 'VOICEINDEX'
    end
    object cdsAddPaineisATUALIZACAOPLAYLIST: TDateField
      FieldName = 'ATUALIZACAOPLAYLIST'
      Origin = 'ATUALIZACAOPLAYLIST'
    end
    object cdsAddPaineisTRANSPARENT: TStringField
      FieldName = 'TRANSPARENT'
      Origin = 'TRANSPARENT'
      FixedChar = True
      Size = 1
    end
    object cdsAddPaineisNEGRITO: TStringField
      FieldName = 'NEGRITO'
      Origin = 'NEGRITO'
      FixedChar = True
      Size = 1
    end
    object cdsAddPaineisITALICO: TStringField
      FieldName = 'ITALICO'
      Origin = 'ITALICO'
      FixedChar = True
      Size = 1
    end
    object cdsAddPaineisSUBLINHADO: TStringField
      FieldName = 'SUBLINHADO'
      Origin = 'SUBLINHADO'
      FixedChar = True
      Size = 1
    end
    object cdsAddPaineisMOSTRARSENHA: TStringField
      FieldName = 'MOSTRARSENHA'
      Origin = 'MOSTRARSENHA'
      FixedChar = True
      Size = 1
    end
    object cdsAddPaineisMOSTRARPA: TStringField
      FieldName = 'MOSTRARPA'
      Origin = 'MOSTRARPA'
      FixedChar = True
      Size = 1
    end
    object cdsAddPaineisMOSTRARNOMECLIENTE: TStringField
      FieldName = 'MOSTRARNOMECLIENTE'
      Origin = 'MOSTRARNOMECLIENTE'
      FixedChar = True
      Size = 1
    end
    object cdsAddPaineisSOMARQUIVO: TStringField
      FieldName = 'SOMARQUIVO'
      Origin = 'SOMARQUIVO'
      FixedChar = True
      Size = 1
    end
    object cdsAddPaineisSOMVOZ: TStringField
      FieldName = 'SOMVOZ'
      Origin = 'SOMVOZ'
      FixedChar = True
      Size = 1
    end
    object cdsAddPaineisSOMVOZCHAMADA1MARCADO: TStringField
      FieldName = 'SOMVOZCHAMADA1MARCADO'
      Origin = 'SOMVOZCHAMADA1MARCADO'
      FixedChar = True
      Size = 1
    end
    object cdsAddPaineisSOMVOZCHAMADA2MARCADO: TStringField
      FieldName = 'SOMVOZCHAMADA2MARCADO'
      Origin = 'SOMVOZCHAMADA2MARCADO'
      FixedChar = True
      Size = 1
    end
    object cdsAddPaineisSOMVOZCHAMADA3MARCADO: TStringField
      FieldName = 'SOMVOZCHAMADA3MARCADO'
      Origin = 'SOMVOZCHAMADA3MARCADO'
      FixedChar = True
      Size = 1
    end
    object cdsAddPaineisDISPOSICAOLINHAS: TStringField
      FieldName = 'DISPOSICAOLINHAS'
      Origin = 'DISPOSICAOLINHAS'
      FixedChar = True
      Size = 1
    end
    object cdsAddPaineisVALORACOMPANHACORDONIVEL: TStringField
      FieldName = 'VALORACOMPANHACORDONIVEL'
      Origin = 'VALORACOMPANHACORDONIVEL'
      FixedChar = True
      Size = 1
    end
    object cdsAddPaineisID_MODULO_TV: TIntegerField
      FieldName = 'ID_MODULO_TV'
      Origin = 'ID_MODULO_TV'
    end
    object cdsAddPaineisccNOME: TStringField
      FieldKind = fkCalculated
      FieldName = 'ccNOME'
      Size = 40
      Calculated = True
    end
    object cdsAddPaineisID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
    end
    object cdsAddPaineisWIDTH: TIntegerField
      FieldName = 'WIDTH'
    end
  end
  object dspAddPaineis: TDataSetProvider
    DataSet = qryAddPaineis
    Left = 1135
    Top = 69
  end
  object qryAddPaineis: TFDQuery
    Connection = connOnLine
    SQL.Strings = (
      'Select * from'
      'MODULOS_TV_PAINEIS'
      'where id_modulo_tv=:id'
      'AND id_unidade=:id_unidade')
    Left = 1136
    Top = 8
    ParamData = <
      item
        Name = 'ID'
        ParamType = ptInput
      end
      item
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
  end
  object cdsModuloTV: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspModuloTV'
    Left = 1284
    Top = 297
    object cdsModuloTVID: TIntegerField
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object cdsModuloTVCHAMADAINTERROMPEVIDEO: TStringField
      FieldName = 'CHAMADAINTERROMPEVIDEO'
      Origin = 'CHAMADAINTERROMPEVIDEO'
      FixedChar = True
      Size = 1
    end
    object cdsModuloTVMAXIMIZARMONITOR1: TStringField
      FieldName = 'MAXIMIZARMONITOR1'
      Origin = 'MAXIMIZARMONITOR1'
      FixedChar = True
      Size = 1
    end
    object cdsModuloTVMAXIMIZARMONITOR2: TStringField
      FieldName = 'MAXIMIZARMONITOR2'
      Origin = 'MAXIMIZARMONITOR2'
      FixedChar = True
      Size = 1
    end
    object cdsModuloTVFUNCIONASABADO: TStringField
      FieldName = 'FUNCIONASABADO'
      Origin = 'FUNCIONASABADO'
      FixedChar = True
      Size = 1
    end
    object cdsModuloTVFUNCIONADOMINGO: TStringField
      FieldName = 'FUNCIONADOMINGO'
      Origin = 'FUNCIONADOMINGO'
      FixedChar = True
      Size = 1
    end
    object cdsModuloTVUSECODEBAR: TStringField
      FieldName = 'USECODEBAR'
      Origin = 'USECODEBAR'
      FixedChar = True
      Size = 1
    end
    object cdsModuloTVIDPAINEL: TIntegerField
      FieldName = 'IDPAINEL'
      Origin = 'IDPAINEL'
    end
    object cdsModuloTVIDTV: TIntegerField
      FieldName = 'IDTV'
      Origin = 'IDTV'
    end
    object cdsModuloTVPORTAIPPAINEL: TIntegerField
      FieldName = 'PORTAIPPAINEL'
      Origin = 'PORTAIPPAINEL'
    end
    object cdsModuloTVLASTMUTE: TIntegerField
      FieldName = 'LASTMUTE'
      Origin = 'LASTMUTE'
    end
    object cdsModuloTVVOLUME: TIntegerField
      FieldName = 'VOLUME'
      Origin = 'VOLUME'
    end
    object cdsModuloTVDEM: TIntegerField
      FieldName = 'DEM'
      Origin = 'DEM'
    end
    object cdsModuloTVATEM: TIntegerField
      FieldName = 'ATEM'
      Origin = 'ATEM'
    end
    object cdsModuloTVCODEBARPORT: TStringField
      FieldName = 'CODEBARPORT'
      Origin = 'CODEBARPORT'
    end
    object cdsModuloTVINDICADORESPERMITIDOS: TStringField
      FieldName = 'INDICADORESPERMITIDOS'
      Origin = 'INDICADORESPERMITIDOS'
      Size = 400
    end
    object cdsModuloTVDEH: TIntegerField
      FieldName = 'DEH'
      Origin = 'DEH'
    end
    object cdsModuloTVATEH: TIntegerField
      FieldName = 'ATEH'
      Origin = 'ATEH'
    end
    object cdsModuloTVID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
    end
  end
  object qryModuloTV: TFDQuery
    Connection = connOnLine
    SQL.Strings = (
      'Select * from'
      'MODULOS_TV')
    Left = 1288
    Top = 184
  end
  object dspModuloTV: TDataSetProvider
    DataSet = qryModuloTV
    Left = 1287
    Top = 237
  end
  object dsSicsTV: TDataSource
    DataSet = cdsSicsTV
    Left = 1048
    Top = 768
  end
  object cdsSicsTV: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive, foNoPartialCompare]
    Params = <>
    ProviderName = 'dspSicsTV'
    Left = 977
    Top = 721
  end
  object dspSicsTV: TDataSetProvider
    DataSet = qrySicsTV
    Left = 888
    Top = 768
  end
  object qrySicsTV: TFDQuery
    Connection = connOnLine
    SQL.Strings = (
      'SELECT * FROM MODULOS_TV')
    Left = 791
    Top = 765
  end
  object connPIS: TFDConnection
    Left = 104
    Top = 16
  end
end
