inherited dmCadPesquisaOpniao: TdmCadPesquisaOpniao
  OnCreate = DataModuleCreate
  Height = 254
  Width = 347
  inherited dtsMain: TDataSource
    DataSet = cdsCadPesquisaOpniao
    Left = 138
    Top = 25
  end
  object cdsCadPesquisaOpniao: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspCadNiveis'
    OnReconcileError = cdsCadPesquisaOpniaoReconcileError
    Left = 139
    Top = 76
    object cdsCadPesquisaOpniaoID_PINIVEL: TSmallintField
      DisplayLabel = 'ID'
      DisplayWidth = 60
      FieldName = 'ID_PINIVEL'
      Required = True
    end
    object cdsCadPesquisaOpniaoNOME: TStringField
      DisplayLabel = 'Nome'
      DisplayWidth = 60
      FieldName = 'NOME'
      Size = 30
    end
    object cdsCadPesquisaOpniaoCOR: TStringField
      DisplayLabel = 'Cor'
      DisplayWidth = 60
      FieldName = 'COR'
      Size = 30
    end
    object cdsCadPesquisaOpniaoCODIGOCOR: TIntegerField
      DisplayLabel = 'C'#243'digo Cor'
      DisplayWidth = 60
      FieldName = 'CODIGOCOR'
      ReadOnly = True
      DisplayFormat = ' '
    end
  end
  object dspCadPesquisaOpniao: TDataSetProvider
    DataSet = qryCadPesquisaOpniao
    Options = [poPropogateChanges]
    Left = 136
    Top = 136
  end
  object qryCadPesquisaOpniao: TFDQuery

    Params = <>
    SQL.Strings = (
      'select * from PESQUISA_OPINIAO')
    Left = 136
    Top = 192
  end
end
