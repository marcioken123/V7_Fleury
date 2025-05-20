object LogSQLiteDB: TLogSQLiteDB
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 300
  Width = 420
  object Con: TFDConnection
    Params.Strings = (
      'LockingMode=Normal'
      'StringFormat=Unicode'
      'DateTimeFormat=DateTime'
      'SharedCache=False'
      'Synchronous=Full'
      'DriverID=SQLite')
    UpdateOptions.AssignedValues = [uvLockWait]
    UpdateOptions.LockWait = True
    ConnectedStoredUsage = [auDesignTime]
    LoginPrompt = False
    Left = 40
    Top = 16
  end
  object FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink
    Left = 320
    Top = 16
  end
  object qryAuxScriptBd: TFDQuery
    Connection = Con
    Left = 40
    Top = 64
  end
  object cmdInsert: TFDCommand
    Connection = Con
    CommandKind = skInsert
    CommandText.Strings = (
      'INSERT INTO logs ('
      '  datahora,'
      '  tipomsg,'
      '  categoria,'
      '  versaoexe,'
      '  hostname,'
      '  ip,'
      '  nometotem,'
      '  idtotem,'
      '  nomeunidade,'
      '  idunidade,'
      '  msg,'
      '  logasjson'
      ')VALUES ('
      '  :datahora,'
      '  :tipomsg,'
      '  :categoria,'
      '  :versaoexe,'
      '  :hostname,'
      '  :ip,'
      '  :nometotem,'
      '  :idtotem,'
      '  :nomeunidade,'
      '  :idunidade,'
      '  :msg,'
      '  :logasjson'
      ')')
    ParamData = <
      item
        Name = 'DATAHORA'
        DataType = ftDateTime
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'TIPOMSG'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'CATEGORIA'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'VERSAOEXE'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'HOSTNAME'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'IP'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'NOMETOTEM'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'IDTOTEM'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'NOMEUNIDADE'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'IDUNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'MSG'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'LOGASJSON'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end>
    Left = 112
    Top = 16
  end
  object cmdUpdate: TFDCommand
    Connection = ConPendentes
    CommandKind = skUpdate
    CommandText.Strings = (
      'update logs set'
      '  issent = :issent,'
      '  sentat = :sentat,'
      '  remoteid = :remoteid'
      'where'
      '  id = :id')
    ParamData = <
      item
        Name = 'ISSENT'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'SENTAT'
        DataType = ftDateTime
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'REMOTEID'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'ID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
    Left = 344
    Top = 232
  end
  object ConPendentes: TFDConnection
    Params.Strings = (
      'LockingMode=Normal'
      'StringFormat=Unicode'
      'DateTimeFormat=DateTime'
      'SharedCache=False'
      'Synchronous=Full'
      'DriverID=SQLite')
    UpdateOptions.AssignedValues = [uvLockWait]
    UpdateOptions.LockWait = True
    ConnectedStoredUsage = [auDesignTime]
    LoginPrompt = False
    Left = 296
    Top = 176
  end
  object qryProximoPendente: TFDQuery
    Connection = ConPendentes
    SQL.Strings = (
      'select id, logasjson from logs where issent = 0 limit 1')
    Left = 248
    Top = 232
  end
end
