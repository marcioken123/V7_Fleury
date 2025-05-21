object DMPlayListManager: TDMPlayListManager
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 315
  Width = 432
  object FDConnection: TFDConnection
    Params.Strings = (
      'Database=C:\BD\SICSUNIDADES.FDB'
      'User_Name=SYSDBA'
      'Password=masterkey'
      'DriverID=FB')
    LoginPrompt = False
    Left = 112
    Top = 40
  end
  object TimerVerificaPlayListManager: TTimer
    Enabled = False
    OnTimer = TimerVerificaPlayListManagerTimer
    Left = 232
    Top = 40
  end
  object FDQueryArquivos: TFDQuery
    Connection = FDConnection
    SQL.Strings = (
      'SELECT IDMIDIA, ARQUIVO_MIDIA '
      'FROM ARQUIVOS'
      'WHERE IDMIDIA =:IDMIDIA ')
    Left = 136
    Top = 136
    ParamData = <
      item
        Name = 'IDMIDIA'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
    object FDQueryArquivosIDMIDIA: TIntegerField
      FieldName = 'IDMIDIA'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object FDQueryArquivosARQUIVO_MIDIA: TBlobField
      FieldName = 'ARQUIVO_MIDIA'
    end
  end
  object FDQueryPlayList: TFDQuery
    Connection = FDConnection
    SQL.Strings = (
      'SELECT PL.ORDEM, PL.IDMIDIA, PL.DURACAOSEGS, '
      '             MD.TIPO, MD.HASH_ARQUIVO, MD.EXTENSAO'
      'FROM PLAYLIST_GRUPO        AS PL'
      'INNER JOIN  MIDIAS         AS MD ON MD.IDMIDIA   = PL.IDMIDIA'
      'INNER JOIN  GRUPOS         AS GR ON GR.IDGRUPO   = PL.IDGRUPO'
      'INNER JOIN  UNIDADES       AS UN ON UN.IDGRUPO   = GR.IDGRUPO'
      'INNER JOIN  TVS            AS TV ON TV.IDUNIDADE = UN.ID'
      'WHERE TV.IDTV = :IDTV'
      'ORDER BY PL.ORDEM')
    Left = 232
    Top = 136
    ParamData = <
      item
        Name = 'IDTV'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
    object FDQueryPlayListORDEM: TIntegerField
      FieldName = 'ORDEM'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object FDQueryPlayListIDMIDIA: TIntegerField
      FieldName = 'IDMIDIA'
      Required = True
    end
    object FDQueryPlayListDURACAOSEGS: TIntegerField
      FieldName = 'DURACAOSEGS'
      Required = True
    end
    object FDQueryPlayListHASH_ARQUIVO: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'HASH_ARQUIVO'
      ProviderFlags = []
      ReadOnly = True
      Size = 100
    end
    object FDQueryPlayListEXTENSAO: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'EXTENSAO'
      ProviderFlags = []
      ReadOnly = True
      Size = 10
    end
    object FDQueryPlayListTIPO: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'TIPO'
      ProviderFlags = []
      ReadOnly = True
      FixedChar = True
      Size = 1
    end
  end
  object ClientDataSetPlayList: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 336
    Top = 136
    object ClientDataSetPlayListARQUIVO_CAMINHO: TStringField
      FieldName = 'ARQUIVO_CAMINHO'
      Size = 500
    end
    object ClientDataSetPlayListARQUIVO_TIPO: TStringField
      FieldName = 'ARQUIVO_TIPO'
      Size = 1
    end
    object ClientDataSetPlayListARQUIVO_DURACAOSEGS: TIntegerField
      FieldName = 'ARQUIVO_DURACAOSEGS'
    end
    object ClientDataSetPlayListARQUIVO_HASH: TStringField
      FieldName = 'ARQUIVO_HASH'
      Size = 100
    end
  end
end
