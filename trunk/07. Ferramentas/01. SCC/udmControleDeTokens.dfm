object dmControleDeTokens: TdmControleDeTokens
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 240
  Width = 430
  object connControleDeTokens: TFDConnection
    Params.Strings = (
      'DriverID=SQLite')
    Connected = True
    LoginPrompt = False
    Left = 80
    Top = 32
  end
  object localsqlControleDeTokens: TFDLocalSQL
    Connection = connControleDeTokens
    Active = True
    DataSets = <>
    Left = 80
    Top = 88
  end
  object memtabControleDeTokens: TFDMemTable
    Active = True
    FieldDefs = <
      item
        Name = 'DescEndpoint'
        DataType = ftString
        Size = 120
      end
      item
        Name = 'Token'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'DataHora'
        DataType = ftDateTime
      end>
    IndexDefs = <>
    IndexFieldNames = 'Token'
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    LocalSQL = localsqlControleDeTokens
    StoreDefs = True
    Left = 80
    Top = 144
    object memtabControleDeTokensDescEndpoint: TStringField
      FieldName = 'DescEndpoint'
      Size = 120
    end
    object memtabControleDeTokensToken: TStringField
      FieldName = 'Token'
      Size = 255
    end
    object memtabControleDeTokensDataHora: TDateTimeField
      FieldName = 'DataHora'
    end
  end
  object qryControleDeTokens: TFDQuery
    Connection = connControleDeTokens
    SQL.Strings = (
      'delete'
      'from'
      '  memtabControleDeTokens'
      'where'
      '  DATAHORA < :LimiteHorario')
    Left = 272
    Top = 128
    ParamData = <
      item
        Name = 'LIMITEHORARIO'
        DataType = ftDateTime
        FDDataType = dtDateTime
        ParamType = ptInput
      end>
  end
  object tmrLimpaTokensAntigos: TTimer
    Interval = 300000
    OnTimer = tmrLimpaTokensAntigosTimer
    Left = 272
    Top = 56
  end
end
