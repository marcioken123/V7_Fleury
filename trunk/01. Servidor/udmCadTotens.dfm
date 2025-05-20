object dmSicsCadTotens: TdmSicsCadTotens
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 401
  Width = 488
  object cdsTotens: TClientDataSet
    Aggregates = <>
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspTotens'
    BeforePost = cdsTotensBeforePost
    OnNewRecord = cdsTotensNewRecord
    OnReconcileError = cdsTotensReconcileError
    Left = 80
    Top = 48
    object cdsTotensID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
      Required = True
    end
    object cdsTotensID: TIntegerField
      FieldName = 'ID'
      Required = True
      OnSetText = cdsTotensIDSetText
    end
    object cdsTotensNOME: TStringField
      FieldName = 'NOME'
      Size = 30
    end
    object cdsTotensIP: TStringField
      FieldName = 'IP'
      Size = 15
    end
    object cdsTotensIDFILA_BOTAO1: TIntegerField
      FieldName = 'IDFILA_BOTAO1'
    end
    object cdsTotensIDFILA_BOTAO2: TIntegerField
      FieldName = 'IDFILA_BOTAO2'
    end
    object cdsTotensIDFILA_BOTAO3: TIntegerField
      FieldName = 'IDFILA_BOTAO3'
    end
    object cdsTotensIDFILA_BOTAO4: TIntegerField
      FieldName = 'IDFILA_BOTAO4'
    end
    object cdsTotensIDFILA_BOTAO5: TIntegerField
      FieldName = 'IDFILA_BOTAO5'
    end
    object cdsTotensIDFILA_BOTAO6: TIntegerField
      FieldName = 'IDFILA_BOTAO6'
    end
    object cdsTotensIDFILA_BOTAO7: TIntegerField
      FieldName = 'IDFILA_BOTAO7'
    end
    object cdsTotensIDFILA_BOTAO8: TIntegerField
      FieldName = 'IDFILA_BOTAO8'
    end
    object cdsTotensID_MODELOTOTEM: TIntegerField
      FieldName = 'ID_MODELOTOTEM'
    end
    object cdsTotensLKP_MODELO: TStringField
      FieldKind = fkLookup
      FieldName = 'LKP_MODELO'
      LookupDataSet = cdsLkpModeloToten
      LookupKeyFields = 'ID'
      LookupResultField = 'DESCRICAO'
      KeyFields = 'ID_MODELOTOTEM'
      Lookup = True
    end
    object cdsTotensOPCOES_PICOTEENTREVIAS: TStringField
      Tag = 1
      DisplayLabel = 'Picote entre vias'
      FieldName = 'OPCOES_PICOTEENTREVIAS'
      FixedChar = True
      Size = 1
    end
    object cdsTotensOPCOES_CORTEPARCIALAOFINAL: TStringField
      Tag = 1
      DisplayLabel = 'Corte parcial ao final'
      FieldName = 'OPCOES_CORTEPARCIALAOFINAL'
      FixedChar = True
      Size = 1
    end
    object cdsTotensOPCOES_CDBSENHAS: TStringField
      Tag = 1
      DisplayLabel = 'CDB Senhas'
      FieldName = 'OPCOES_CDBSENHAS'
      FixedChar = True
      Size = 1
    end
    object cdsTotensOPCOES_DATAHORANA2AVIA: TStringField
      Tag = 1
      DisplayLabel = 'Data e hora na 2a via'
      FieldName = 'OPCOES_DATAHORANA2AVIA'
      FixedChar = True
      Size = 1
    end
    object cdsTotensOPCOES_NOMEFILANA2AVIA: TStringField
      Tag = 1
      DisplayLabel = 'Nome da fila na 2a via'
      FieldName = 'OPCOES_NOMEFILANA2AVIA'
      FixedChar = True
      Size = 1
    end
    object cdsTotensFILAS_PERMITIDAS: TStringField
      FieldName = 'FILAS_PERMITIDAS'
      Size = 80
    end
    object cdsTotensBOTOES_COLUNAS: TIntegerField
      FieldName = 'BOTOES_COLUNAS'
    end
    object cdsTotensBOTOES_TRANSPARENTES: TStringField
      FieldName = 'BOTOES_TRANSPARENTES'
      FixedChar = True
      Size = 1
    end
    object cdsTotensBOTOES_MARGEM_SUPERIOR: TIntegerField
      FieldName = 'BOTOES_MARGEM_SUPERIOR'
    end
    object cdsTotensBOTOES_MARGEM_INFERIOR: TIntegerField
      FieldName = 'BOTOES_MARGEM_INFERIOR'
    end
    object cdsTotensBOTOES_MARGEM_DIREITA: TIntegerField
      FieldName = 'BOTOES_MARGEM_DIREITA'
    end
    object cdsTotensBOTOES_MARGEM_ESQUERDA: TIntegerField
      FieldName = 'BOTOES_MARGEM_ESQUERDA'
    end
    object cdsTotensBOTOES_ESPACO_COLUNAS: TIntegerField
      FieldName = 'BOTOES_ESPACO_COLUNAS'
    end
    object cdsTotensBOTOES_ESPACO_LINHAS: TIntegerField
      FieldName = 'BOTOES_ESPACO_LINHAS'
    end
    object cdsTotensPORTA_TCP: TIntegerField
      FieldName = 'PORTA_TCP'
    end
    object cdsTotensIMAGEM_FUNDO: TStringField
      FieldName = 'IMAGEM_FUNDO'
      Size = 300
    end
    object cdsTotensPORTA_SERIAL_IMPRESSORA: TStringField
      FieldName = 'PORTA_SERIAL_IMPRESSORA'
      Size = 40
    end
    object cdsTotensMOSTRAR_BOTAO_FECHAR: TStringField
      FieldName = 'MOSTRAR_BOTAO_FECHAR'
      FixedChar = True
      Size = 1
    end
    object cdsTotensBOTAO_FECHAR_TAM_MAIOR: TStringField
      FieldName = 'BOTAO_FECHAR_TAM_MAIOR'
      FixedChar = True
      Size = 1
    end
    object cdsTotensPODE_FECHAR_PROGRAMA: TStringField
      FieldName = 'PODE_FECHAR_PROGRAMA'
      FixedChar = True
      Size = 1
    end
    object cdsTotensIMAGEM: TBlobField
      FieldName = 'IMAGEM'
      Size = 1
    end
    object cdsTotensIMAGEM_NOME: TStringField
      FieldName = 'IMAGEM_NOME'
      Size = 100
    end
    object cdsTotensST_HABILITA: TStringField
      FieldName = 'ST_HABILITA'
      FixedChar = True
      Size = 1
    end
    object cdsTotensST_BOTOES_COLUNAS: TIntegerField
      FieldName = 'ST_BOTOES_COLUNAS'
    end
    object cdsTotensST_BOTOES_MARGEM_SUPERIOR: TIntegerField
      FieldName = 'ST_BOTOES_MARGEM_SUPERIOR'
    end
    object cdsTotensST_BOTOES_MARGEM_INFERIOR: TIntegerField
      FieldName = 'ST_BOTOES_MARGEM_INFERIOR'
    end
    object cdsTotensST_BOTOES_MARGEM_ESQUERDA: TIntegerField
      FieldName = 'ST_BOTOES_MARGEM_ESQUERDA'
    end
    object cdsTotensST_BOTOES_MARGEM_DIREITA: TIntegerField
      FieldName = 'ST_BOTOES_MARGEM_DIREITA'
    end
    object cdsTotensST_BOTOES_ESPACO_COLUNAS: TIntegerField
      FieldName = 'ST_BOTOES_ESPACO_COLUNAS'
    end
    object cdsTotensST_BOTOES_ESPACO_LINHAS: TIntegerField
      FieldName = 'ST_BOTOES_ESPACO_LINHAS'
    end
    object cdsTotensST_IMAGEM_FUNDO: TBlobField
      FieldName = 'ST_IMAGEM_FUNDO'
    end
    object cdsTotensST_IMAGEM_FUNDO_NOME: TStringField
      FieldName = 'ST_IMAGEM_FUNDO_NOME'
      Size = 100
    end
    object cdsTotensTEMPO_INATIVIDADE: TIntegerField
      FieldName = 'TEMPO_INATIVIDADE'
      DisplayFormat = '00:00'
      EditFormat = '00:00'
    end
    object cdsTotensID_TELA: TIntegerField
      FieldName = 'ID_TELA'
    end
  end
  object dspTotens: TDataSetProvider
    DataSet = qryTotens
    UpdateMode = upWhereKeyOnly
    Left = 80
    Top = 96
  end
  object qryTotens: TFDQuery
    Connection = dmSicsMain.connOnLine
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
      '  OPCOES_PICOTEENTREVIAS,'
      '  OPCOES_CORTEPARCIALAOFINAL,'
      '  OPCOES_CDBSENHAS,'
      '  OPCOES_DATAHORANA2AVIA,'
      '  OPCOES_NOMEFILANA2AVIA,'
      '  FILAS_PERMITIDAS,'
      '  BOTOES_COLUNAS,'
      '  BOTOES_TRANSPARENTES,'
      '  BOTOES_MARGEM_SUPERIOR,'
      '  BOTOES_MARGEM_INFERIOR,'
      '  BOTOES_MARGEM_DIREITA,'
      '  BOTOES_MARGEM_ESQUERDA,'
      '  BOTOES_ESPACO_COLUNAS,'
      '  BOTOES_ESPACO_LINHAS,'
      '  PORTA_TCP,'
      '  IMAGEM_FUNDO,'
      '  PORTA_SERIAL_IMPRESSORA,'
      '  MOSTRAR_BOTAO_FECHAR,'
      '  BOTAO_FECHAR_TAM_MAIOR,'
      '  PODE_FECHAR_PROGRAMA,'
      '  IMAGEM,'
      '  IMAGEM_NOME,'
      '  ST_HABILITA,'
      '  ST_BOTOES_COLUNAS,'
      '  ST_BOTOES_MARGEM_SUPERIOR,'
      '  ST_BOTOES_MARGEM_INFERIOR,'
      '  ST_BOTOES_MARGEM_ESQUERDA,'
      '  ST_BOTOES_MARGEM_DIREITA,'
      '  ST_BOTOES_ESPACO_COLUNAS,'
      '  ST_BOTOES_ESPACO_LINHAS,'
      '  ST_IMAGEM_FUNDO,'
      '  ST_IMAGEM_FUNDO_NOME,'
      '  TEMPO_INATIVIDADE, '
      '  ID_TELA'
      'FROM'
      '  TOTENS'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE')
    Left = 80
    Top = 144
    ParamData = <
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
    object qryTotensID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
      Origin = 'ID_UNIDADE'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qryTotensID: TIntegerField
      FieldName = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qryTotensNOME: TStringField
      FieldName = 'NOME'
      Size = 30
    end
    object qryTotensIP: TStringField
      FieldName = 'IP'
      Size = 15
    end
    object qryTotensIDFILA_BOTAO1: TIntegerField
      FieldName = 'IDFILA_BOTAO1'
    end
    object qryTotensIDFILA_BOTAO2: TIntegerField
      FieldName = 'IDFILA_BOTAO2'
    end
    object qryTotensIDFILA_BOTAO3: TIntegerField
      FieldName = 'IDFILA_BOTAO3'
    end
    object qryTotensIDFILA_BOTAO4: TIntegerField
      FieldName = 'IDFILA_BOTAO4'
    end
    object qryTotensIDFILA_BOTAO5: TIntegerField
      FieldName = 'IDFILA_BOTAO5'
    end
    object qryTotensIDFILA_BOTAO6: TIntegerField
      FieldName = 'IDFILA_BOTAO6'
    end
    object qryTotensIDFILA_BOTAO7: TIntegerField
      FieldName = 'IDFILA_BOTAO7'
    end
    object qryTotensIDFILA_BOTAO8: TIntegerField
      FieldName = 'IDFILA_BOTAO8'
    end
    object qryTotensID_MODELOTOTEM: TIntegerField
      FieldName = 'ID_MODELOTOTEM'
    end
    object qryTotensOPCOES_PICOTEENTREVIAS: TStringField
      FieldName = 'OPCOES_PICOTEENTREVIAS'
      FixedChar = True
      Size = 1
    end
    object qryTotensOPCOES_CORTEPARCIALAOFINAL: TStringField
      FieldName = 'OPCOES_CORTEPARCIALAOFINAL'
      FixedChar = True
      Size = 1
    end
    object qryTotensOPCOES_CDBSENHAS: TStringField
      FieldName = 'OPCOES_CDBSENHAS'
      FixedChar = True
      Size = 1
    end
    object qryTotensOPCOES_DATAHORANA2AVIA: TStringField
      FieldName = 'OPCOES_DATAHORANA2AVIA'
      FixedChar = True
      Size = 1
    end
    object qryTotensOPCOES_NOMEFILANA2AVIA: TStringField
      FieldName = 'OPCOES_NOMEFILANA2AVIA'
      FixedChar = True
      Size = 1
    end
    object qryTotensFILAS_PERMITIDAS: TStringField
      FieldName = 'FILAS_PERMITIDAS'
      Size = 80
    end
    object qryTotensBOTOES_COLUNAS: TIntegerField
      FieldName = 'BOTOES_COLUNAS'
    end
    object qryTotensBOTOES_TRANSPARENTES: TStringField
      FieldName = 'BOTOES_TRANSPARENTES'
      FixedChar = True
      Size = 1
    end
    object qryTotensBOTOES_MARGEM_SUPERIOR: TIntegerField
      FieldName = 'BOTOES_MARGEM_SUPERIOR'
    end
    object qryTotensBOTOES_MARGEM_INFERIOR: TIntegerField
      FieldName = 'BOTOES_MARGEM_INFERIOR'
    end
    object qryTotensBOTOES_MARGEM_DIREITA: TIntegerField
      FieldName = 'BOTOES_MARGEM_DIREITA'
    end
    object qryTotensBOTOES_MARGEM_ESQUERDA: TIntegerField
      FieldName = 'BOTOES_MARGEM_ESQUERDA'
    end
    object qryTotensBOTOES_ESPACO_COLUNAS: TIntegerField
      FieldName = 'BOTOES_ESPACO_COLUNAS'
    end
    object qryTotensBOTOES_ESPACO_LINHAS: TIntegerField
      FieldName = 'BOTOES_ESPACO_LINHAS'
    end
    object qryTotensPORTA_TCP: TIntegerField
      FieldName = 'PORTA_TCP'
    end
    object qryTotensIMAGEM_FUNDO: TStringField
      FieldName = 'IMAGEM_FUNDO'
      Size = 300
    end
    object qryTotensPORTA_SERIAL_IMPRESSORA: TStringField
      FieldName = 'PORTA_SERIAL_IMPRESSORA'
      Size = 40
    end
    object qryTotensMOSTRAR_BOTAO_FECHAR: TStringField
      FieldName = 'MOSTRAR_BOTAO_FECHAR'
      FixedChar = True
      Size = 1
    end
    object qryTotensBOTAO_FECHAR_TAM_MAIOR: TStringField
      FieldName = 'BOTAO_FECHAR_TAM_MAIOR'
      FixedChar = True
      Size = 1
    end
    object qryTotensPODE_FECHAR_PROGRAMA: TStringField
      FieldName = 'PODE_FECHAR_PROGRAMA'
      FixedChar = True
      Size = 1
    end
    object qryTotensIMAGEM: TBlobField
      FieldName = 'IMAGEM'
    end
    object qryTotensIMAGEM_NOME: TStringField
      FieldName = 'IMAGEM_NOME'
      Size = 100
    end
    object qryTotensST_HABILITA: TStringField
      FieldName = 'ST_HABILITA'
      Origin = 'ST_HABILITA'
      FixedChar = True
      Size = 1
    end
    object qryTotensST_BOTOES_COLUNAS: TIntegerField
      FieldName = 'ST_BOTOES_COLUNAS'
      Origin = 'ST_BOTOES_COLUNAS'
    end
    object qryTotensST_BOTOES_MARGEM_SUPERIOR: TIntegerField
      FieldName = 'ST_BOTOES_MARGEM_SUPERIOR'
      Origin = 'ST_BOTOES_MARGEM_SUPERIOR'
    end
    object qryTotensST_BOTOES_MARGEM_INFERIOR: TIntegerField
      FieldName = 'ST_BOTOES_MARGEM_INFERIOR'
      Origin = 'ST_BOTOES_MARGEM_INFERIOR'
    end
    object qryTotensST_BOTOES_MARGEM_ESQUERDA: TIntegerField
      FieldName = 'ST_BOTOES_MARGEM_ESQUERDA'
      Origin = 'ST_BOTOES_MARGEM_ESQUERDA'
    end
    object qryTotensST_BOTOES_MARGEM_DIREITA: TIntegerField
      FieldName = 'ST_BOTOES_MARGEM_DIREITA'
      Origin = 'ST_BOTOES_MARGEM_DIREITA'
    end
    object qryTotensST_BOTOES_ESPACO_COLUNAS: TIntegerField
      FieldName = 'ST_BOTOES_ESPACO_COLUNAS'
      Origin = 'ST_BOTOES_ESPACO_COLUNAS'
    end
    object qryTotensST_BOTOES_ESPACO_LINHAS: TIntegerField
      FieldName = 'ST_BOTOES_ESPACO_LINHAS'
      Origin = 'ST_BOTOES_ESPACO_LINHAS'
    end
    object qryTotensST_IMAGEM_FUNDO: TBlobField
      FieldName = 'ST_IMAGEM_FUNDO'
      Origin = 'ST_IMAGEM_FUNDO'
    end
    object qryTotensST_IMAGEM_FUNDO_NOME: TStringField
      FieldName = 'ST_IMAGEM_FUNDO_NOME'
      Origin = 'ST_IMAGEM_FUNDO_NOME'
      Size = 100
    end
    object qryTotensTEMPO_INATIVIDADE: TIntegerField
      FieldName = 'TEMPO_INATIVIDADE'
      Origin = 'TEMPO_INATIVIDADE'
    end
    object qryTotensID_TELA: TIntegerField
      FieldName = 'ID_TELA'
      Origin = 'ID_TELA'
    end
  end
  object cdsLkpModeloToten: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 176
    Top = 48
    object cdsLkpModeloTotenID: TIntegerField
      FieldName = 'ID'
    end
    object cdsLkpModeloTotenDESCRICAO: TStringField
      FieldName = 'DESCRICAO'
    end
  end
  object cdsLkpFilas: TClientDataSet
    Aggregates = <>
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspLkpFilas'
    Left = 272
    Top = 48
  end
  object dspLkpFilas: TDataSetProvider
    DataSet = qryLkpFilas
    Left = 272
    Top = 96
  end
  object qryLkpFilas: TFDQuery
    Connection = dmSicsMain.connOnLine
    SQL.Strings = (
      'SELECT'
      '  ID,'
      '  NOME'
      'FROM'
      '  FILAS'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE')
    Left = 272
    Top = 144
    ParamData = <
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object cdsTelas: TClientDataSet
    Aggregates = <>
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspTelas'
    AfterOpen = cdsTelasAfterOpen
    AfterScroll = cdsTelasAfterScroll
    OnNewRecord = cdsTelasNewRecord
    Left = 80
    Top = 232
    object cdsTelasID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
      Required = True
    end
    object cdsTelasID: TIntegerField
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object cdsTelasNOME: TStringField
      FieldName = 'NOME'
      Origin = 'NOME'
      Size = 50
    end
    object cdsTelasLKP_FECHAR: TStringField
      FieldKind = fkLookup
      FieldName = 'LKP_FECHAR'
      LookupDataSet = cdsLkpFechar
      LookupKeyFields = 'ID'
      LookupResultField = 'DESCRICAO'
      KeyFields = 'FECHAR'
      Size = 3
      Lookup = True
    end
    object cdsTelasLKP_MOMENTO_IMPRESSAO: TStringField
      FieldKind = fkLookup
      FieldName = 'LKP_MOMENTO_IMPRESSAO'
      LookupDataSet = cdsLkpMomentoImpresao
      LookupKeyFields = 'ID'
      LookupResultField = 'DESCRICAO'
      KeyFields = 'MOMENTO_IMPRESSAO'
      Size = 50
      Lookup = True
    end
    object cdsTelasINTERVALO: TIntegerField
      FieldName = 'INTERVALO'
      Origin = 'INTERVALO'
      DisplayFormat = '00:00'
    end
    object cdsTelasIMAGEM: TBlobField
      FieldName = 'IMAGEM'
      Origin = 'IMAGEM'
      OnGetText = cdsTelasIMAGEMGetText
    end
    object cdsTelasFECHAR: TStringField
      FieldName = 'FECHAR'
      FixedChar = True
      Size = 1
    end
    object cdsTelasMOMENTO_IMPRESSAO: TSmallintField
      FieldName = 'MOMENTO_IMPRESSAO'
    end
  end
  object dspTelas: TDataSetProvider
    DataSet = qryTelas
    BeforeUpdateRecord = dspTelasBeforeUpdateRecord
    Left = 80
    Top = 280
  end
  object qryTelas: TFDQuery
    Connection = dmSicsMain.connOnLine
    SQL.Strings = (
      'SELECT '
      '  ID_UNIDADE,'
      '  ID, '
      '  NOME, '
      '  FECHAR, '
      '  MOMENTO_IMPRESSAO, '
      '  INTERVALO, '
      '  IMAGEM'
      'FROM '
      '  MULTITELAS'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE')
    Left = 80
    Top = 328
    ParamData = <
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object cdsTelasBotoes: TClientDataSet
    Aggregates = <>
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspTelasBotoes'
    OnNewRecord = cdsTelasBotoesNewRecord
    Left = 176
    Top = 232
    object cdsTelasBotoesID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
      Required = True
    end
    object cdsTelasBotoesID: TIntegerField
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object cdsTelasBotoesNOME: TStringField
      FieldName = 'NOME'
      Origin = 'NOME'
      Size = 50
    end
    object cdsTelasBotoesPOS_LEFT: TIntegerField
      FieldName = 'POS_LEFT'
      Origin = 'POS_LEFT'
    end
    object cdsTelasBotoesPOS_TOP: TIntegerField
      FieldName = 'POS_TOP'
      Origin = 'POS_TOP'
    end
    object cdsTelasBotoesTAM_WIDTH: TIntegerField
      FieldName = 'TAM_WIDTH'
      Origin = 'TAM_WIDTH'
    end
    object cdsTelasBotoesTAM_HEIGHT: TIntegerField
      FieldName = 'TAM_HEIGHT'
      Origin = 'TAM_HEIGHT'
    end
    object cdsTelasBotoesID_TELA: TIntegerField
      FieldName = 'ID_TELA'
      Origin = 'ID_TELA'
    end
    object cdsTelasBotoesID_PROXIMATELA: TIntegerField
      FieldName = 'ID_PROXIMATELA'
      Origin = 'ID_PROXIMATELA'
    end
    object cdsTelasBotoesID_FILA: TIntegerField
      FieldName = 'ID_FILA'
      Origin = 'ID_FILA'
    end
    object cdsTelasBotoesID_TAG: TIntegerField
      FieldName = 'ID_TAG'
      Origin = 'ID_TAG'
    end
    object cdsTelasBotoesLKP_TELA: TStringField
      FieldKind = fkLookup
      FieldName = 'LKP_TELA'
      LookupDataSet = cdsTelasClone
      LookupKeyFields = 'ID'
      LookupResultField = 'NOME'
      KeyFields = 'ID_TELA'
      Size = 50
      Lookup = True
    end
    object cdsTelasBotoesLKP_TELA_PROXIMA: TStringField
      FieldKind = fkLookup
      FieldName = 'LKP_TELA_PROXIMA'
      LookupDataSet = cdsTelasClone
      LookupKeyFields = 'ID'
      LookupResultField = 'NOME'
      KeyFields = 'ID_PROXIMATELA'
      Size = 50
      Lookup = True
    end
    object cdsTelasBotoesLKP_FILA: TStringField
      FieldKind = fkLookup
      FieldName = 'LKP_FILA'
      LookupDataSet = cdsFilas
      LookupKeyFields = 'ID'
      LookupResultField = 'NOME'
      KeyFields = 'ID_FILA'
      Size = 30
      Lookup = True
    end
    object cdsTelasBotoesLKP_TAG: TStringField
      FieldKind = fkLookup
      FieldName = 'LKP_TAG'
      LookupDataSet = cdsTags
      LookupKeyFields = 'ID'
      LookupResultField = 'NOME'
      KeyFields = 'ID_TAG'
      Size = 30
      Lookup = True
    end
  end
  object dspTelasBotoes: TDataSetProvider
    DataSet = qryTelasBotoes
    BeforeUpdateRecord = dspTelasBotoesBeforeUpdateRecord
    Left = 176
    Top = 280
  end
  object qryTelasBotoes: TFDQuery
    Connection = dmSicsMain.connOnLine
    SQL.Strings = (
      'SELECT '
      '  ID_UNIDADE,'
      '  ID, '
      '  NOME, '
      '  POS_LEFT, '
      '  POS_TOP, '
      '  TAM_WIDTH, '
      '  TAM_HEIGHT, '
      '  ID_TELA,'
      '  ID_PROXIMATELA, '
      '  ID_FILA, '
      '  ID_TAG'
      'FROM '
      '  MULTITELAS_BOTOES'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE')
    Left = 176
    Top = 328
    ParamData = <
      item
        Position = 1
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
      end>
  end
  object cdsLkpFechar: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 176
    Top = 96
    object cdsLkpFecharID: TStringField
      FieldName = 'ID'
      Size = 1
    end
    object StringField1: TStringField
      FieldName = 'DESCRICAO'
    end
  end
  object cdsLkpMomentoImpresao: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 176
    Top = 144
    object cdsLkpMomentoImpresaoID: TIntegerField
      FieldName = 'ID'
    end
    object StringField3: TStringField
      FieldName = 'DESCRICAO'
    end
  end
  object cdsTelasClone: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 360
    Top = 96
    object cdsTelasCloneID: TIntegerField
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object cdsTelasCloneNOME: TStringField
      FieldName = 'NOME'
      Origin = 'NOME'
      Size = 50
    end
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
    Left = 272
    Top = 232
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
  end
  object dspFilas: TDataSetProvider
    DataSet = qryFilas
    Left = 272
    Top = 280
  end
  object qryFilas: TFDQuery
    Connection = dmSicsMain.connOnLine
    SQL.Strings = (
      'SELECT '
      '  ID_UNIDADE,'
      '  ID, '
      '  NOME'
      'FROM '
      '  FILAS'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE')
    Left = 272
    Top = 328
    ParamData = <
      item
        Position = 1
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
      end>
  end
  object cdsTags: TClientDataSet
    Aggregates = <>
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspTags'
    Left = 360
    Top = 232
    object cdsTagsID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
      Required = True
    end
    object cdsTagsID: TIntegerField
      FieldName = 'ID'
      Required = True
    end
    object cdsTagsNOME: TStringField
      FieldName = 'NOME'
      Size = 30
    end
  end
  object dspTags: TDataSetProvider
    DataSet = qryTags
    Left = 360
    Top = 280
  end
  object qryTags: TFDQuery
    Connection = dmSicsMain.connOnLine
    SQL.Strings = (
      'SELECT '
      '  ID_UNIDADE,'
      '  ID,  '
      '  NOME'
      'FROM '
      '  TAGS'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE')
    Left = 360
    Top = 328
    ParamData = <
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
end
