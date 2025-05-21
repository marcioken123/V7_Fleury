object dmTabelasScc: TdmTabelasScc
  OldCreateOrder = False
  Height = 291
  Width = 465
  object Conn: TFDConnection
    LoginPrompt = False
    Left = 80
    Top = 32
  end
  object cdsTemp: TClientDataSet
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
    ProviderName = 'dspTemp'
    StoreDefs = True
    Left = 144
    Top = 144
  end
  object dspTemp: TDataSetProvider
    DataSet = qryTemp
    Options = [poPropogateChanges]
    Left = 144
    Top = 88
  end
  object qryTemp: TFDQuery
    Connection = Conn
    Left = 144
    Top = 32
  end
end
