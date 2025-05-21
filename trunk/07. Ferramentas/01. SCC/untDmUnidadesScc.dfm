object dmUnidadesScc: TdmUnidadesScc
  OldCreateOrder = False
  Height = 291
  Width = 465
  object cdsUn: TClientDataSet
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'ID'
        Attributes = [faRequired]
        DataType = ftInteger
      end
      item
        Name = 'NOME'
        DataType = ftString
        Size = 40
      end
      item
        Name = 'DBDIR'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'IP'
        DataType = ftString
        Size = 15
      end
      item
        Name = 'PORTA'
        DataType = ftInteger
      end
      item
        Name = 'PORTA_TGS'
        DataType = ftInteger
      end
      item
        Name = 'ID_UNID_CLI'
        DataType = ftString
        Size = 32
      end
      item
        Name = 'IDGRUPO'
        DataType = ftInteger
      end
      item
        Name = 'HOST'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'BANCO'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'USUARIO'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'SENHA'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'OSAUTHENT'
        Attributes = [faFixed]
        DataType = ftString
        Size = 1
      end>
    IndexDefs = <>
    Params = <>
    ProviderName = 'dspUn'
    StoreDefs = True
    Left = 144
    Top = 144
    object cdsUnID: TIntegerField
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object cdsUnNOME: TStringField
      FieldName = 'NOME'
      Origin = 'NOME'
      Size = 40
    end
    object cdsUnDBDIR: TStringField
      FieldName = 'DBDIR'
      Origin = 'DBDIR'
      Size = 255
    end
    object cdsUnIP: TStringField
      FieldName = 'IP'
      Origin = 'IP'
      Size = 15
    end
    object cdsUnPORTA: TIntegerField
      FieldName = 'PORTA'
      Origin = 'PORTA'
    end
    object cdsUnPORTA_TGS: TIntegerField
      FieldName = 'PORTA_TGS'
      Origin = 'PORTA_TGS'
    end
    object cdsUnID_UNID_CLI: TStringField
      FieldName = 'ID_UNID_CLI'
      Origin = 'ID_UNID_CLI'
      Size = 10
    end
  end
  object dspUn: TDataSetProvider
    DataSet = qryUn
    Options = [poPropogateChanges]
    Left = 144
    Top = 88
  end
  object Conn: TFDConnection
    LoginPrompt = False
    Left = 80
    Top = 32
  end
  object qryUn: TFDQuery
    Connection = Conn
    SQL.Strings = (
      'SELECT * FROM UNIDADES')
    Left = 144
    Top = 32
  end
end
