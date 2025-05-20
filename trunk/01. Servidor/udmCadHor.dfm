inherited dmSicsCadHor: TdmSicsCadHor
  OldCreateOrder = True
  object cdsCadHor: TClientDataSet
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'ID_UNIDADE'
        Attributes = [faRequired]
        DataType = ftInteger
      end
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
    AfterApplyUpdates = cdsCadHorAfterApplyUpdates
    Left = 152
    Top = 47
    object cdsCadHorID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
      Required = True
    end
    object cdsCadHorID_PIHORARIO: TSmallintField
      FieldName = 'ID_PIHORARIO'
      Required = True
    end
    object cdsCadHorNOME: TStringField
      FieldName = 'NOME'
      Size = 30
    end
    object cdsCadHorHORAINICIO: TTimeField
      FieldName = 'HORAINICIO'
      DisplayFormat = 'hh:nn'
    end
    object cdsCadHorHORAFIM: TTimeField
      FieldName = 'HORAFIM'
      DisplayFormat = 'hh:nn'
    end
    object cdsCadHorDOMINGO: TStringField
      Tag = 1
      FieldName = 'DOMINGO'
      FixedChar = True
      Size = 1
    end
    object cdsCadHorSEGUNDAFEIRA: TStringField
      Tag = 1
      FieldName = 'SEGUNDAFEIRA'
      FixedChar = True
      Size = 1
    end
    object cdsCadHorTERCAFEIRA: TStringField
      Tag = 1
      FieldName = 'TERCAFEIRA'
      FixedChar = True
      Size = 1
    end
    object cdsCadHorQUARTAFEIRA: TStringField
      Tag = 1
      FieldName = 'QUARTAFEIRA'
      FixedChar = True
      Size = 1
    end
    object cdsCadHorQUINTAFEIRA: TStringField
      Tag = 1
      FieldName = 'QUINTAFEIRA'
      FixedChar = True
      Size = 1
    end
    object cdsCadHorSEXTAFEIRA: TStringField
      Tag = 1
      FieldName = 'SEXTAFEIRA'
      FixedChar = True
      Size = 1
    end
    object cdsCadHorSABADO: TStringField
      Tag = 1
      FieldName = 'SABADO'
      FixedChar = True
      Size = 1
    end
  end
  object dspCadHor: TDataSetProvider
    DataSet = qryCadHor
    Left = 152
    Top = 112
  end
  object qryCadHor: TFDQuery
    Connection = dmSicsMain.connOnLine
    SQL.Strings = (
      'select '
      '  * '
      'from '
      '  PIS_HORARIOS'
      'where'
      '  ID_UNIDADE = :ID_UNIDADE')
    Left = 152
    Top = 168
    ParamData = <
      item
        Position = 1
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
      end>
  end
end
