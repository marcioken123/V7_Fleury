object DMClient: TDMClient
  OldCreateOrder = True
  OnDestroy = DataModuleDestroy
  Height = 500
  Width = 876
  object cdsFilas: TClientDataSet
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'ID'
        DataType = ftInteger
      end
      item
        Name = 'Nome'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'Cor'
        DataType = ftInteger
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 128
    Top = 8
    object cdsFilasID: TIntegerField
      FieldName = 'ID'
    end
    object cdsFilasNome: TStringField
      FieldName = 'Nome'
      Size = 30
    end
    object cdsFilasCor: TIntegerField
      FieldName = 'Cor'
    end
  end
  object cdsPAs: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspPAs'
    Left = 188
    Top = 232
    object cdsPAsID: TIntegerField
      FieldName = 'ID'
    end
    object cdsPAsNome: TStringField
      FieldName = 'Nome'
      Size = 30
    end
    object cdsPAsIdGrupo: TIntegerField
      FieldName = 'IdGrupo'
    end
  end
  object cdsAtendentes: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspAtendentes'
    Left = 188
    Top = 160
    object cdsAtendentesID: TIntegerField
      FieldName = 'ID'
    end
    object cdsAtendentesNome: TStringField
      FieldName = 'Nome'
      Size = 30
    end
    object cdsAtendentesRegistroFuncional: TStringField
      FieldName = 'RegistroFuncional'
      Size = 15
    end
    object cdsAtendentesSenhaLogin: TStringField
      FieldName = 'SenhaLogin'
      Size = 32
    end
    object cdsAtendentesIdGrupo: TIntegerField
      FieldName = 'IdGrupo'
    end
    object cdsAtendenteslogin: TStringField
      FieldName = 'login'
      Size = 30
    end
  end
  object cdsGruposDeAtendentes: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 272
    Top = 144
    object cdsGruposDeAtendentesID: TIntegerField
      FieldName = 'ID'
    end
    object cdsGruposDeAtendentesNome: TStringField
      FieldName = 'Nome'
      Size = 30
    end
  end
  object cdsGruposDePAs: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 383
    Top = 64
    object cdsGruposDePAsID: TIntegerField
      FieldName = 'ID'
    end
    object cdsGruposDePAsNome: TStringField
      FieldName = 'Nome'
      Size = 30
    end
  end
  object cdsGruposDeTAGs: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'ID'
    Params = <>
    Left = 510
    Top = 64
    object cdsGruposDeTAGsID: TIntegerField
      FieldName = 'ID'
    end
    object cdsGruposDeTAGsNOME: TStringField
      FieldName = 'Nome'
      Size = 40
    end
  end
  object cdsTags: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'ID'
    Params = <>
    ProviderName = 'dspPAs'
    Left = 515
    Top = 8
    object cdsTagsID: TIntegerField
      FieldName = 'ID'
    end
    object cdsTagsNOME: TStringField
      FieldName = 'Nome'
      Size = 40
    end
    object cdsTagsIdGrupo: TIntegerField
      FieldName = 'IdGrupo'
    end
    object cdsTagsCODIGOCOR: TIntegerField
      FieldName = 'CodigoCor'
    end
  end
  object cdsPPs: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 645
    Top = 8
    object cdsPPsID: TIntegerField
      FieldName = 'ID'
    end
    object cdsPPsNOME: TStringField
      FieldName = 'Nome'
      Size = 40
    end
    object cdsPPsIdGrupo: TIntegerField
      FieldName = 'IdGrupo'
    end
    object cdsPPsCODIGOCOR: TIntegerField
      FieldName = 'CodigoCor'
    end
  end
  object cdsGruposDePPs: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 640
    Top = 64
    object cdsGruposDePPsID: TIntegerField
      FieldName = 'ID'
    end
    object cdsGruposDePPsNOME: TStringField
      FieldName = 'Nome'
      Size = 40
    end
  end
  object cdsMotivosPausa: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 773
    Top = 8
    object IntegerField1: TIntegerField
      FieldName = 'ID'
    end
    object StringField1: TStringField
      FieldName = 'Nome'
      Size = 30
    end
    object IntegerField2: TIntegerField
      FieldName = 'IdGrupo'
    end
    object cdsMotivosPausaCodigoCor: TIntegerField
      FieldName = 'CodigoCor'
    end
  end
  object cdsGruposDeMotivosPausa: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 775
    Top = 64
    object IntegerField3: TIntegerField
      FieldName = 'ID'
    end
    object StringField2: TStringField
      FieldName = 'Nome'
      Size = 30
    end
  end
  object cdsStatusPAs: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 38
    Top = 7
    object IntegerField4: TIntegerField
      FieldName = 'ID'
    end
    object StringField3: TStringField
      FieldName = 'Nome'
      Size = 30
    end
  end
  object connDMClient: TFDConnection
    Params.Strings = (
      'DriverName=Firebird'
      
        'Database=servarq01:d:\Tecnica\Desenvolvimentos\SW\BDs - Desenvol' +
        'vimento\SICSBASEv5.FDB'
      'RoleName=RoleName'
      'User_Name=sysdba'
      'Password=masterkey'
      'ServerCharSet='
      'SQLDialect=3'
      'ErrorResourceFile='
      'LocaleCode=0000'
      'BlobSize=-1'
      'CommitRetain=False'
      'WaitOnLocks=True'
      'IsolationLevel=ReadCommitted'
      'Trim Char=False')
    LoginPrompt = False
    Left = 37
    Top = 79
  end
  object qryPAs: TFDQuery
    Connection = connDMClient
    Left = 32
    Top = 232
  end
  object dspPAs: TDataSetProvider
    DataSet = qryPAs
    Left = 112
    Top = 232
  end
  object dspAtendentes: TDataSetProvider
    DataSet = qryAtendentes
    Left = 112
    Top = 160
  end
  object qryAtendentes: TFDQuery
    Left = 32
    Top = 160
  end
  object CDSSenhas: TClientDataSet
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'IDFILA'
        DataType = ftInteger
      end
      item
        Name = 'SENHA'
        DataType = ftInteger
      end
      item
        Name = 'NOMECLIENTE'
        DataType = ftString
        Size = 250
      end
      item
        Name = 'HORA'
        DataType = ftTime
      end
      item
        Name = 'DATAHORA'
        DataType = ftDateTime
      end
      item
        Name = 'COR_LINHA'
        DataType = ftInteger
      end
      item
        Name = 'TEMPO_ESPERA'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'PRONTUARIO'
        DataType = ftInteger
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 424
    Top = 128
    object CDSSenhasIDFILA: TIntegerField
      DisplayWidth = 50
      FieldName = 'IDFILA'
      Visible = False
    end
    object CDSSenhasSENHA: TIntegerField
      DisplayLabel = 'Senha'
      DisplayWidth = 50
      FieldName = 'SENHA'
    end
    object CDSSenhasNOMECLIENTE: TStringField
      DisplayLabel = 'Nome'
      DisplayWidth = 50
      FieldName = 'NOMECLIENTE'
      Size = 250
    end
    object CDSSenhasHORA: TTimeField
      DisplayLabel = 'Hor'#225'rio'
      DisplayWidth = 70
      FieldName = 'HORA'
      Visible = False
    end
    object CDSSenhasDATAHORA: TDateTimeField
      DisplayLabel = 'Data'
      FieldName = 'DATAHORA'
      Visible = False
    end
    object CDSSenhasCOR_LINHA: TIntegerField
      FieldKind = fkCalculated
      FieldName = 'COR_LINHA'
      Visible = False
      Calculated = True
    end
    object CDSSenhasTEMPO_ESPERA: TStringField
      FieldName = 'TEMPO_ESPERA'
    end
    object CDSSenhasPRONTUARIO: TIntegerField
      DisplayLabel = 'Prontu'#225'rio'
      FieldName = 'PRONTUARIO'
    end
  end
  object CDSPIs: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    IndexFieldNames = 'IDPI'
    Params = <>
    StoreDefs = True
    Left = 504
    Top = 144
    object CDSPIsID: TIntegerField
      FieldName = 'ID'
      Visible = False
    end
    object CDSPIsUNIDADE: TStringField
      FieldName = 'UNIDADE'
      Visible = False
      Size = 50
    end
    object CDSPIsPI: TStringField
      DisplayWidth = 150
      FieldName = 'PI'
      Size = 200
    end
    object CDSPIsVALOR: TStringField
      DisplayLabel = 'Valor'
      DisplayWidth = 60
      FieldName = 'VALOR'
    end
    object CDSPIsVALOR_NUMERICO: TIntegerField
      DisplayLabel = 'Valor'
      FieldName = 'VALOR_NUMERICO'
      Visible = False
    end
    object CDSPIsESTADO: TStringField
      DisplayLabel = 'Estado'
      DisplayWidth = 60
      FieldName = 'ESTADO'
    end
    object CDSPIsIDPI: TIntegerField
      DisplayLabel = 'ID PI'
      DisplayWidth = 30
      FieldName = 'IDPI'
      Visible = False
    end
    object CDSPIsIDESTADO: TStringField
      DisplayLabel = 'Estado'
      FieldName = 'IDESTADO'
      Visible = False
      Size = 1
    end
    object CDSPIsFLAG_VALOR_EM_SEGUNDOS: TBooleanField
      FieldName = 'FLAG_VALOR_EM_SEGUNDOS'
      Visible = False
    end
    object CDSPIsCREATEDAT: TFloatField
      FieldName = 'CREATEDAT'
      Visible = False
    end
  end
  object cdsUnidadesClone: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 543
    Top = 209
  end
  object cdsUnidades: TClientDataSet
    Aggregates = <>
    Params = <>
    AfterOpen = cdsUnidadesAfterOpen
    Left = 463
    Top = 209
    object cdsUnidadesID: TIntegerField
      FieldName = 'ID'
    end
    object cdsUnidadesNOME: TStringField
      FieldName = 'NOME'
      Size = 40
    end
    object cdsUnidadesPATH_BASE_ONLINE: TStringField
      FieldName = 'PATH_BASE_ONLINE'
      Size = 255
    end
    object cdsUnidadesPATH_BASE_RELATORIOS: TStringField
      FieldName = 'PATH_BASE_RELATORIOS'
      Size = 255
    end
    object cdsUnidadesIDX_CONN_RELATORIO: TIntegerField
      FieldName = 'IDX_CONN_RELATORIO'
    end
    object cdsUnidadesIP_ENDERECO: TStringField
      FieldName = 'IP_ENDERECO'
      Size = 15
    end
    object cdsUnidadesIP_PORTA: TIntegerField
      FieldName = 'IP_PORTA'
    end
    object cdsUnidadesCONECTADA: TBooleanField
      Tag = 1
      FieldName = 'CONECTADA'
    end
  end
  object cdsEmails: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspGenerico'
    Left = 620
    Top = 220
  end
  object cdsPaineis: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspGenerico'
    Left = 656
    Top = 272
  end
  object cdsGruposDePaineis: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspGenerico'
    Left = 712
    Top = 272
  end
  object cdsMotivosDePausa: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspGenerico'
    Left = 794
    Top = 225
  end
  object cdsCelulares: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspGenerico'
    Left = 788
    Top = 171
  end
  object dspGenerico: TDataSetProvider
    DataSet = tblGenerica
    Left = 336
    Top = 241
  end
  object tblGenerica: TFDTable
    Connection = connDMClient
    Left = 337
    Top = 192
  end
  object cdsNN_PAs_Filas: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'ID_PA;POSICAO'
    MasterFields = 'ID'
    Params = <>
    ProviderName = 'dspGenerico'
    Left = 264
    Top = 241
  end
  object connRelatorio: TFDConnection
    Params.Strings = (
      'DriverUnit=Data.DBXFirebird'
      
        'DriverPackageLoader=TDBXDynalinkDriverLoader,DbxCommonDriver200.' +
        'bpl'
      
        'DriverAssemblyLoader=Borland.Data.TDBXDynalinkDriverLoader,Borla' +
        'nd.Data.DbxCommonDriver,Version=20.0.0.0,Culture=neutral,PublicK' +
        'eyToken=91d62ebb5b0d1b1b'
      
        'MetaDataPackageLoader=TDBXFirebirdMetaDataCommandFactory,DbxFire' +
        'birdDriver200.bpl'
      
        'MetaDataAssemblyLoader=Borland.Data.TDBXFirebirdMetaDataCommandF' +
        'actory,Borland.Data.DbxFirebirdDriver,Version=20.0.0.0,Culture=n' +
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
    Left = 107
    Top = 81
  end
  object cdsAgendamentosSenhasPorFila: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 344
    Top = 360
    object cdsAgendamentosSenhasPorFilaIdPA: TIntegerField
      FieldName = 'IdPA'
    end
    object cdsAgendamentosSenhasPorFilaSenha: TIntegerField
      FieldName = 'Senha'
    end
    object cdsAgendamentosSenhasPorFilaIdFila: TIntegerField
      FieldName = 'IdFila'
    end
    object cdsAgendamentosSenhasPorFilaDataHora: TDateTimeField
      FieldName = 'DataHora'
    end
  end
  object qryImagemFila: TFDQuery
    Connection = connDMClient
    Left = 552
    Top = 344
  end
  object dspImagemFila: TDataSetProvider
    DataSet = qryImagemFila
    Left = 640
    Top = 344
  end
  object cdsImagemFila: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspImagemFila'
    Left = 712
    Top = 344
    object cdsImagemFilaIMAGEM_FILA: TBlobField
      FieldName = 'IMAGEM_FILA'
    end
    object cdsImagemFilaALINHAMENTO_IMAGEM: TIntegerField
      FieldName = 'ALINHAMENTO_IMAGEM'
    end
  end
  object qryQtdePIsSemFormatoHorario: TFDQuery
    Connection = connDMClient
    SQL.Strings = (
      'select count(*) from pis_relacionados pir'
      'inner join pis on pir.id_relacionado = pis.id_pi'
      
        'inner join pis_tipos pit on pis.id_pitipo = pit.id_pitipo and pi' +
        't.formatohorario = '#39'F'#39
      'where pir.id_pi = :id_pi')
    Left = 76
    Top = 344
    ParamData = <
      item
        Name = 'id_pi'
        DataType = ftInteger
        ParamType = ptInput
      end>
  end
  object qryPIsPermitidos: TFDQuery
    Connection = connDMClient
    SQL.Strings = (
      'select'
      '  NOME'
      'from'
      '  PIS'
      'where'
      '  ID_PI in (%s)')
    Left = 72
    Top = 392
  end
  object qryTVs: TFDQuery
    Connection = connDMClient
    SQL.Strings = (
      'SELECT NOME,TCPIP'
      'FROM PAINEIS'
      'WHERE ID_MODELOPAINEL = 10')
    Left = 184
    Top = 408
  end
  object cdsPessoasFilaEsperaPA: TClientDataSet
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'Fila'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'Senha'
        DataType = ftInteger
      end
      item
        Name = 'Nome'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'Horario'
        DataType = ftTime
      end
      item
        Name = 'Prontuario'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'Observacao'
        DataType = ftString
        Size = 250
      end
      item
        Name = 'ccIdObservacao'
        DataType = ftInteger
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    AfterOpen = CriarIndicesParaCadaColunaDoDataset
    AfterPost = cdsPessoasFilaEsperaPAAfterPost
    OnCalcFields = cdsPessoasFilaEsperaPACalcFields
    Left = 224
    Top = 8
    object cdsPessoasFilaEsperaPAFila: TStringField
      FieldName = 'Fila'
      Size = 50
    end
    object cdsPessoasFilaEsperaPASenha: TIntegerField
      FieldName = 'Senha'
    end
    object cdsPessoasFilaEsperaPANome: TStringField
      FieldName = 'Nome'
      Size = 50
    end
    object cdsPessoasFilaEsperaPAHorario: TTimeField
      FieldName = 'Horario'
    end
    object cdsPessoasFilaEsperaPAProntuario: TStringField
      FieldName = 'Prontuario'
    end
    object cdsPessoasFilaEsperaPAObservacao: TStringField
      FieldName = 'Observacao'
      Size = 250
    end
    object cdsPessoasFilaEsperaPAccIdObservacao: TIntegerField
      Alignment = taCenter
      FieldKind = fkCalculated
      FieldName = 'ccIdObservacao'
      Calculated = True
    end
  end
  object dsPessoasNasFilas: TDataSource
    DataSet = cdsPessoasFilaEsperaPA
    Left = 224
    Top = 64
  end
end
