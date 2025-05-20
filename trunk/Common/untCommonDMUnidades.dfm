object dmUnidades: TdmUnidades
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 217
  Width = 302
  object conn: TFDConnection
    Params.Strings = (
      'User_Name=SYSDBA'
      'Password=masterkey'
      'Database=C:\BD\V701072020\SICSV7.FDB'
      'DriverID=FB')
    LoginPrompt = False
    Left = 24
    Top = 16
  end
  object qryUnidades: TFDQuery
    Connection = conn
    SQL.Strings = (
      'select *'
      'from UNIDADES')
    Left = 96
    Top = 16
    object qryUnidadesID: TIntegerField
      FieldName = 'ID'
      Required = True
    end
    object qryUnidadesNOME: TStringField
      FieldName = 'NOME'
      Size = 40
    end
    object qryUnidadesDBDIR: TStringField
      FieldName = 'DBDIR'
      Size = 100
    end
    object qryUnidadesIP: TStringField
      FieldName = 'IP'
      Size = 255
    end
    object qryUnidadesPORTA: TIntegerField
      FieldName = 'PORTA'
    end
    object qryUnidadesPORTA_TGS: TIntegerField
      FieldName = 'PORTA_TGS'
    end
    object qryUnidadesID_UNID_CLI: TStringField
      FieldName = 'ID_UNID_CLI'
      Origin = 'ID_UNID_CLI'
      Size = 32
    end
    object qryUnidadesIDGRUPO: TIntegerField
      FieldName = 'IDGRUPO'
      Origin = 'IDGRUPO'
    end
    object qryUnidadesHOST: TStringField
      FieldName = 'HOST'
      Origin = 'HOST'
      Size = 100
    end
    object qryUnidadesBANCO: TStringField
      FieldName = 'BANCO'
      Origin = 'BANCO'
      Size = 100
    end
    object qryUnidadesUSUARIO: TStringField
      FieldName = 'USUARIO'
      Origin = 'USUARIO'
      Size = 100
    end
    object qryUnidadesSENHA: TStringField
      FieldName = 'SENHA'
      Origin = 'SENHA'
      Size = 255
    end
    object qryUnidadesOSAUTHENT: TStringField
      FieldName = 'OSAUTHENT'
      Origin = 'OSAUTHENT'
      FixedChar = True
      Size = 1
    end
  end
  object cdsUnidades: TClientDataSet
    Aggregates = <>
    Params = <>
    AfterOpen = cdsUnidadesAfterOpen
    Left = 94
    Top = 70
    object cdsUnidadesID: TIntegerField
      DisplayWidth = 50
      FieldName = 'ID'
    end
    object cdsUnidadesNOME: TStringField
      DisplayLabel = 'Nome'
      DisplayWidth = 100
      FieldName = 'NOME'
      Size = 40
    end
    object cdsUnidadesPATH_BASE: TStringField
      DisplayLabel = 'Path Base Online'
      FieldName = 'PATH_BASE'
      Size = 255
    end
    object cdsUnidadesIP_ENDERECO: TStringField
      DisplayLabel = 'IP'
      FieldName = 'IP_ENDERECO'
      Size = 255
    end
    object cdsUnidadesIP_PORTA: TIntegerField
      DisplayLabel = 'Porta'
      FieldName = 'IP_PORTA'
    end
    object cdsUnidadesCONECTADA: TBooleanField
      Tag = 1
      DisplayLabel = 'Conectada'
      DisplayWidth = 10
      FieldName = 'CONECTADA'
    end
    object cdsUnidadesIDMODULO: TIntegerField
      FieldName = 'IDMODULO'
    end
    object cdsUnidadesID_UNID_CLI: TStringField
      FieldName = 'ID_UNID_CLI'
      Origin = 'ID_UNID_CLI'
      Size = 32
    end
    object cdsUnidadesIDGRUPO: TIntegerField
      FieldName = 'IDGRUPO'
      Origin = 'IDGRUPO'
    end
    object cdsUnidadesHOST: TStringField
      FieldName = 'HOST'
      Origin = 'HOST'
      Size = 100
    end
    object cdsUnidadesBANCO: TStringField
      FieldName = 'BANCO'
      Origin = 'BANCO'
      Size = 100
    end
    object cdsUnidadesUSUARIO: TStringField
      FieldName = 'USUARIO'
      Origin = 'USUARIO'
      Size = 100
    end
    object cdsUnidadesSENHA: TStringField
      FieldName = 'SENHA'
      Origin = 'SENHA'
      Size = 255
    end
    object cdsUnidadesOSAUTHENT: TStringField
      FieldName = 'OSAUTHENT'
      Origin = 'OSAUTHENT'
      FixedChar = True
      Size = 1
    end
  end
  object FDManager: TFDManager
    FormatOptions.AssignedValues = [fvMapRules]
    FormatOptions.OwnMapRules = True
    FormatOptions.MapRules = <>
    Active = True
    Left = 24
    Top = 72
  end
end
