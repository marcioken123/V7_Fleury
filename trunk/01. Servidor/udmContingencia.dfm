object dmSicsContingencia: TdmSicsContingencia
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 471
  Width = 775
  object SQLConContingencia: TFDConnection
    Params.Strings = (
      'Database=database.gdb'
      'RoleName=RoleName'
      'User_Name=sysdba'
      'Password=masterkey'
      'ServerCharSet='
      'SQLDialect=3'
      'BlobSize=-1'
      'CommitRetain=False'
      'WaitOnLocks=True'
      'ErrorResourceFile='
      'LocaleCode=0000'
      'Interbase TransIsolation=ReadCommited'
      'Trim Char=False')
    LoginPrompt = False
    Left = 608
    Top = 24
  end
  object cdsReplicacao: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspReplicacao'
    OnReconcileError = cdsReplicacaoReconcileError
    Left = 256
    Top = 32
  end
  object dspReplicacao: TDataSetProvider
    DataSet = qryReplicacao
    Left = 256
    Top = 80
  end
  object qryReplicacao: TFDQuery
    Connection = SQLConContingencia
    Left = 256
    Top = 128
  end
  object qryAuxPrincipal: TFDQuery
    Left = 40
    Top = 56
  end
  object cdsZiparArquivosRT: TClientDataSet
    Aggregates = <>
    Params = <>
    AfterOpen = cdsZiparArquivosRTAfterOpen
    Left = 40
    Top = 104
    object cdsZiparArquivosRTNOME: TStringField
      FieldName = 'NOME'
    end
    object cdsZiparArquivosRTARQUIVO: TBlobField
      FieldName = 'ARQUIVO'
    end
    object cdsZiparArquivosRTRT_ID: TIntegerField
      FieldName = 'RT_ID'
    end
  end
  object qryContingenteTickets: TFDQuery
    Connection = SQLConContingencia
    SQL.Strings = (
      'SELECT'
      '  *'
      'FROM'
      '  TICKETS'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE')
    Left = 408
    Top = 88
    ParamData = <
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object cdsPrincipalEventos: TClientDataSet
    Aggregates = <>
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspPrincipalEventos'
    OnReconcileError = cdsPrincipalEventosReconcileError
    Left = 40
    Top = 224
  end
  object dspPrincipalEventos: TDataSetProvider
    DataSet = qryPrincipalEventos
    Left = 40
    Top = 272
  end
  object qryPrincipalEventos: TFDQuery
    Connection = SQLConnPrincipal
    SQL.Strings = (
      'SELECT '
      '  * '
      'FROM '
      '  EVENTOS '
      'WHERE '
      '  ID_UNIDADE = :ID_UNIDADE AND'
      '  ID IS NULL')
    Left = 40
    Top = 320
    ParamData = <
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object qryContingenteEventos: TFDQuery
    Connection = SQLConContingencia
    SQL.Strings = (
      'SELECT'
      '  *'
      'FROM'
      '  EVENTOS'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE AND'
      '  ID_TICKET = :ID_TICKET')
    Left = 408
    Top = 136
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
  object cdsPrincipalTickets: TClientDataSet
    Aggregates = <>
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end>
    ProviderName = 'dspPrincipalTickets'
    OnReconcileError = cdsPrincipalEventosReconcileError
    Left = 160
    Top = 224
  end
  object dspPrincipalTickets: TDataSetProvider
    DataSet = qryPrincipalTickets
    Left = 160
    Top = 272
  end
  object qryPrincipalTickets: TFDQuery
    Connection = SQLConnPrincipal
    SQL.Strings = (
      'SELECT'
      '  *'
      'FROM'
      '  TICKETS'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE AND'
      '  ID IS NULL ')
    Left = 160
    Top = 320
    ParamData = <
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object ClientSocketReplicacao: TASPClientSocket
    Active = False
    ClientType = ctNonBlocking
    Port = 0
    OnConnect = ClientSocketReplicacaoConnect
    OnError = ClientSocketReplicacaoError
    Left = 568
    Top = 312
  end
  object ServerSocketReplicacao: TServerSocket
    Active = False
    Port = 0
    ServerType = stNonBlocking
    OnClientConnect = ServerSocketReplicacaoClientConnect
    OnClientDisconnect = ServerSocketReplicacaoClientDisconnect
    OnClientRead = ServerSocketReplicacaoClientRead
    OnClientError = ServerSocketReplicacaoClientError
    Left = 568
    Top = 264
  end
  object SQLConnPrincipal: TFDConnection
    Params.Strings = (
      'BlobSize=-1'
      'CommitRetain=False'
      'Database='
      'ErrorResourceFile='
      'LocaleCode=0000'
      'Password=masterkey'
      'RoleName=RoleName'
      'ServerCharSet='
      'SQLDialect=3'
      'Interbase TransIsolation=ReadCommited'
      'User_Name=sysdba'
      'WaitOnLocks=True')
    LoginPrompt = False
    Left = 608
    Top = 88
  end
  object qryGen: TFDQuery
    Left = 296
    Top = 248
  end
  object ClientSocketVerificarServidorOnLine: TClientSocket
    Active = False
    ClientType = ctNonBlocking
    Port = 0
    OnConnect = ClientSocketVerificarServidorOnLineConnect
    OnError = ClientSocketVerificarServidorOnLineError
    Left = 568
    Top = 360
  end
  object TimerConectarReplicacao: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = TimerConectarReplicacaoTimer
    Left = 568
    Top = 208
  end
end
