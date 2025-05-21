inherited dmSicsCadHor: TdmSicsCadHor
  Height = 320
  Width = 490
  inherited dtsMain: TDataSource
    DataSet = cdsCadHor
  end
  object cdsCadHor: TClientDataSet
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'ID_PIHORARIO'
        Attributes = [faRequired]
        DataType = ftSmallint
      end
      item
        Name = 'NOME'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'HORAINICIO'
        DataType = ftTime
      end
      item
        Name = 'HORAFIM'
        DataType = ftTime
      end
      item
        Name = 'DOMINGO'
        Attributes = [faFixed]
        DataType = ftString
        Size = 1
      end
      item
        Name = 'SEGUNDAFEIRA'
        Attributes = [faFixed]
        DataType = ftString
        Size = 1
      end
      item
        Name = 'TERCAFEIRA'
        Attributes = [faFixed]
        DataType = ftString
        Size = 1
      end
      item
        Name = 'QUARTAFEIRA'
        Attributes = [faFixed]
        DataType = ftString
        Size = 1
      end
      item
        Name = 'QUINTAFEIRA'
        Attributes = [faFixed]
        DataType = ftString
        Size = 1
      end
      item
        Name = 'SEXTAFEIRA'
        Attributes = [faFixed]
        DataType = ftString
        Size = 1
      end
      item
        Name = 'SABADO'
        Attributes = [faFixed]
        DataType = ftString
        Size = 1
      end>
    IndexDefs = <>
    IndexFieldNames = 'ID_PIHORARIO'
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspCadHor'
    StoreDefs = True
    BeforeInsert = cdsCadHorBeforeInsert
    AfterInsert = cdsCadHorAfterInsert
    OnReconcileError = cdsCadHorReconcileError
    Left = 152
    Top = 44
    object cdsCadHorID_PIHORARIO: TSmallintField
      DisplayLabel = 'ID'
      DisplayWidth = 70
      FieldName = 'ID_PIHORARIO'
      Required = True
    end
    object cdsCadHorNOME: TStringField
      DisplayLabel = 'Nome'
      DisplayWidth = 80
      FieldName = 'NOME'
      Size = 30
    end
    object cdsCadHorHORAINICIO: TTimeField
      DisplayLabel = 'Hora In'#237'cio'
      DisplayWidth = 80
      FieldName = 'HORAINICIO'
      DisplayFormat = 'hh:nn:ss'
    end
    object cdsCadHorHORAFIM: TTimeField
      DisplayLabel = 'Hora Fim'
      DisplayWidth = 80
      FieldName = 'HORAFIM'
      DisplayFormat = 'hh:nn:ss'
    end
    object cdsCadHorDOMINGO: TStringField
      Tag = 1
      DisplayLabel = 'Domingo'
      DisplayWidth = 80
      FieldName = 'DOMINGO'
      FixedChar = True
      Size = 1
    end
    object cdsCadHorSEGUNDAFEIRA: TStringField
      Tag = 1
      DisplayLabel = 'Segunda Feira'
      DisplayWidth = 80
      FieldName = 'SEGUNDAFEIRA'
      FixedChar = True
      Size = 1
    end
    object cdsCadHorTERCAFEIRA: TStringField
      Tag = 1
      DisplayLabel = 'Ter'#231'a Feira'
      DisplayWidth = 80
      FieldName = 'TERCAFEIRA'
      FixedChar = True
      Size = 1
    end
    object cdsCadHorQUARTAFEIRA: TStringField
      Tag = 1
      DisplayLabel = 'Quarta Feira'
      DisplayWidth = 80
      FieldName = 'QUARTAFEIRA'
      FixedChar = True
      Size = 1
    end
    object cdsCadHorQUINTAFEIRA: TStringField
      Tag = 1
      DisplayLabel = 'Quinta Feira'
      DisplayWidth = 80
      FieldName = 'QUINTAFEIRA'
      FixedChar = True
      Size = 1
    end
    object cdsCadHorSEXTAFEIRA: TStringField
      Tag = 1
      DisplayLabel = 'Sexta Feira'
      DisplayWidth = 80
      FieldName = 'SEXTAFEIRA'
      FixedChar = True
      Size = 1
    end
    object cdsCadHorSABADO: TStringField
      Tag = 1
      DisplayLabel = 'S'#225'bado'
      DisplayWidth = 80
      FieldName = 'SABADO'
      FixedChar = True
      Size = 1
    end
    object cdsCadHorID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
    end
  end
  object dspCadHor: TDataSetProvider
    DataSet = qryCadHor
    Left = 152
    Top = 112
  end
  object qryCadHor: TFDQuery
    SQL.Strings = (
      'select '
      '  * '
      'from '
      '  PIS_HORARIOS'
      'WHERE '
      '  ID_UNIDADE = :ID_UNIDADE')
    Left = 153
    Top = 166
    ParamData = <
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
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
    Left = 295
    Top = 55
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
  end
  object dspMonitoramentos: TDataSetProvider
    DataSet = qryMonitoramentos
    Options = [poPropogateChanges]
    Left = 296
    Top = 101
  end
  object qryMonitoramentos: TFDQuery
    SQL.Strings = (
      'SELECT'
      '  ID_PIMONITORAMENTO,'
      '  ID_PI,'
      '  ID_PIHORARIO'
      'FROM'
      '  PIS_MONITORAMENTOS'
      'WHERE '
      '  ID_UNIDADE = :ID_UNIDADE')
    Left = 296
    Top = 149
    ParamData = <
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
end
