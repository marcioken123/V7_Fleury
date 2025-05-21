inherited dmSicsCadNiveis: TdmSicsCadNiveis
  OnCreate = DataModuleCreate
  Height = 281
  Width = 347
  inherited dtsMain: TDataSource
    DataSet = cdsCadNiveis
    Left = 178
    Top = 25
  end
  object cdsCadNiveis: TClientDataSet
    Aggregates = <>
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspCadNiveis'
    OnReconcileError = cdsCadNiveisReconcileError
    Left = 171
    Top = 76
    object cdsCadNiveisID_PINIVEL: TSmallintField
      DisplayLabel = 'ID'
      DisplayWidth = 60
      FieldName = 'ID_PINIVEL'
      Required = True
    end
    object cdsCadNiveisNOME: TStringField
      DisplayLabel = 'Nome'
      DisplayWidth = 60
      FieldName = 'NOME'
      Size = 30
    end
    object cdsCadNiveisCOR: TStringField
      DisplayLabel = 'Cor'
      DisplayWidth = 60
      FieldName = 'COR'
      Size = 30
    end
    object cdsCadNiveisCODIGOCOR: TIntegerField
      DisplayLabel = 'C'#243'digo Cor'
      DisplayWidth = 60
      FieldName = 'CODIGOCOR'
      ReadOnly = True
      DisplayFormat = ' '
    end
  end
  object dspCadNiveis: TDataSetProvider
    DataSet = qryCadNiveis
    Options = [poPropogateChanges]
    Left = 176
    Top = 144
  end
  object qryCadNiveis: TFDQuery
    SQL.Strings = (
      'select '
      '  * '
      'from '
      '  PIS_NIVEIS'
      'WHERE '
      '  ID_UNIDADE = :ID_UNIDADE')
    Left = 176
    Top = 192
    ParamData = <
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
end
