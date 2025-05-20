object CalculoPIs: TCalculoPIs
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 327
  Width = 489
  object LcdsPIs: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 32
    Top = 24
  end
  object LcdsPIsRel: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 104
    Top = 24
  end
  object LcdsFilas: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 176
    Top = 24
  end
  object LcdsNN_PAs_Filas: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 256
    Top = 24
  end
  object LcdsPAs: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 336
    Top = 24
  end
  object LcdsPIsClone: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 32
    Top = 80
  end
  object con: TFDConnection
    Params.Strings = (
      'DriverUnit=Data.DBXFirebird'
      
        'DriverPackageLoader=TDBXDynalinkDriverLoader,DbxCommonDriver230.' +
        'bpl'
      
        'DriverAssemblyLoader=Borland.Data.TDBXDynalinkDriverLoader,Borla' +
        'nd.Data.DbxCommonDriver,Version=23.0.0.0,Culture=neutral,PublicK' +
        'eyToken=91d62ebb5b0d1b1b'
      
        'MetaDataPackageLoader=TDBXFirebirdMetaDataCommandFactory,DbxFire' +
        'birdDriver230.bpl'
      
        'MetaDataAssemblyLoader=Borland.Data.TDBXFirebirdMetaDataCommandF' +
        'actory,Borland.Data.DbxFirebirdDriver,Version=23.0.0.0,Culture=n' +
        'eutral,PublicKeyToken=91d62ebb5b0d1b1b'
      'GetDriverFunc=getSQLDriverINTERBASE'
      'LibraryName=dbxfb.dll'
      'LibraryNameOsx=libsqlfb.dylib'
      'VendorLib=fbclient.dll'
      'VendorLibWin64=fbclient.dll'
      'VendorLibOsx=/Library/Frameworks/Firebird.framework/Firebird'
      'Database=database.fdb'
      'User_Name=sysdba'
      'Password=masterkey'
      'Role=RoleName'
      'MaxBlobSize=-1'
      'LocaleCode=0000'
      'IsolationLevel=ReadCommitted'
      'SQLDialect=3'
      'CommitRetain=False'
      'WaitOnLocks=True'
      'TrimChar=False'
      'BlobSize=-1'
      'ErrorResourceFile='
      'RoleName=RoleName'
      'ServerCharSet='
      'Trim Char=False')
    LoginPrompt = False
    Left = 32
    Top = 152
  end
  object qryTMA: TFDQuery
    Connection = con
    SQL.Strings = (
      'select avg(duracao_segundos) from ('
      '  select first 5 e.duracao_segundos from eventos e'
      '  where e.id_tipoevento = 2 and e.id_pa in (1,2,3) '
      '  order by e.id desc)')
    Left = 88
    Top = 152
  end
  object qryValoresEmBD: TFDQuery
    Connection = dmSicsMain.connPIS
    SQL.Strings = (
      'SELECT'
      '  ID_UNIDADE,'
      '  ID,'
      '  NOME,'
      '  VALOR,'
      '  ULTIMO_VALOR_EM'
      'FROM'
      '  PIS_VALORES_EM_BD'
      'WHERE'
      '  ID_UNIDADE = :ID_UNIDADE')
    Left = 409
    Top = 24
    ParamData = <
      item
        Position = 1
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
      end>
  end
end
