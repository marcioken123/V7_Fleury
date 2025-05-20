object dmSicsCadNiveis: TdmSicsCadNiveis
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 391
  Width = 405
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
    AfterApplyUpdates = cdsCadNiveisAfterApplyUpdates
    Left = 176
    Top = 96
    object cdsCadNiveisID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
      Required = True
    end
    object cdsCadNiveisID_PINIVEL: TSmallintField
      FieldName = 'ID_PINIVEL'
      Required = True
    end
    object cdsCadNiveisNOME: TStringField
      FieldName = 'NOME'
      Size = 30
    end
    object cdsCadNiveisCOR: TStringField
      FieldName = 'COR'
      Size = 30
    end
    object cdsCadNiveisCODIGOCOR: TIntegerField
      FieldName = 'CODIGOCOR'
      ReadOnly = True
      DisplayFormat = ' '
    end
    object cdsCadNiveisPOSICAO: TIntegerField
      FieldName = 'POSICAO'
    end
    object cdsCadNiveisCOR_PAINELELETRONICO: TStringField
      FieldName = 'COR_PAINELELETRONICO'
      Size = 30
    end
  end
  object dspCadNiveis: TDataSetProvider
    DataSet = qryCadNiveis
    Options = [poPropogateChanges]
    Left = 176
    Top = 144
  end
  object qryCadNiveis: TFDQuery
    Connection = dmSicsMain.connOnLine
    SQL.Strings = (
      'select '
      '  * '
      'from'
      '  PIS_NIVEIS'
      'WHERE'
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
