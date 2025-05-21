inherited ServiceApp: TServiceApp
  OldCreateOrder = True
  Width = 317
  object qryTotenVersion: TFDQuery
    SQL.Strings = (
      
        'select v.id_totem, v.id_tipoexecutavel, v.versao_anterior_id, v.' +
        'versao_anterior_deployed_por, v.versao_anterior_deployed_em,'
      
        '       v.versao_atual_id, v.versao_atual_deployed_por, v.versao_' +
        'atual_deployed_em, v.versao_proxima_id, v.versao_proxima_deploye' +
        'd_por,'
      '       v.versao_proxima_deployed_em, v.id_status_deploy'
      '  from totens_versoes v'
      ' where v.id_totem = :id_totem')
    Left = 184
    Top = 56
    ParamData = <
      item
        Name = 'ID_TOTEM'
        DataType = ftInteger
        ParamType = ptInput
      end>
    object qryTotenVersionID_TOTEM: TIntegerField
      FieldName = 'ID_TOTEM'
      Origin = 'ID_TOTEM'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qryTotenVersionID_TIPOEXECUTAVEL: TIntegerField
      FieldName = 'ID_TIPOEXECUTAVEL'
      Origin = 'ID_TIPOEXECUTAVEL'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qryTotenVersionVERSAO_ANTERIOR_ID: TIntegerField
      FieldName = 'VERSAO_ANTERIOR_ID'
      Origin = 'VERSAO_ANTERIOR_ID'
    end
    object qryTotenVersionVERSAO_ANTERIOR_DEPLOYED_POR: TIntegerField
      FieldName = 'VERSAO_ANTERIOR_DEPLOYED_POR'
      Origin = 'VERSAO_ANTERIOR_DEPLOYED_POR'
    end
    object qryTotenVersionVERSAO_ANTERIOR_DEPLOYED_EM: TSQLTimeStampField
      FieldName = 'VERSAO_ANTERIOR_DEPLOYED_EM'
      Origin = 'VERSAO_ANTERIOR_DEPLOYED_EM'
    end
    object qryTotenVersionVERSAO_ATUAL_ID: TIntegerField
      FieldName = 'VERSAO_ATUAL_ID'
      Origin = 'VERSAO_ATUAL_ID'
    end
    object qryTotenVersionVERSAO_ATUAL_DEPLOYED_POR: TIntegerField
      FieldName = 'VERSAO_ATUAL_DEPLOYED_POR'
      Origin = 'VERSAO_ATUAL_DEPLOYED_POR'
    end
    object qryTotenVersionVERSAO_ATUAL_DEPLOYED_EM: TSQLTimeStampField
      FieldName = 'VERSAO_ATUAL_DEPLOYED_EM'
      Origin = 'VERSAO_ATUAL_DEPLOYED_EM'
    end
    object qryTotenVersionVERSAO_PROXIMA_ID: TIntegerField
      FieldName = 'VERSAO_PROXIMA_ID'
      Origin = 'VERSAO_PROXIMA_ID'
    end
    object qryTotenVersionVERSAO_PROXIMA_DEPLOYED_POR: TIntegerField
      FieldName = 'VERSAO_PROXIMA_DEPLOYED_POR'
      Origin = 'VERSAO_PROXIMA_DEPLOYED_POR'
    end
    object qryTotenVersionVERSAO_PROXIMA_DEPLOYED_EM: TSQLTimeStampField
      FieldName = 'VERSAO_PROXIMA_DEPLOYED_EM'
      Origin = 'VERSAO_PROXIMA_DEPLOYED_EM'
    end
    object qryTotenVersionID_STATUS_DEPLOY: TIntegerField
      FieldName = 'ID_STATUS_DEPLOY'
      Origin = 'ID_STATUS_DEPLOY'
    end
  end
  object qryExecutavel: TFDQuery
    SQL.Strings = (
      
        'select e.id, e.id_tipo, e.original_filename, e.original_filesize' +
        ', e.versao, e.binario,'
      
        '       e.binario_hash, e.uploaded_por, e.uploaded_em, e.ultimous' +
        'o_em, e.deletado'
      '  from executaveis e'
      ' where e.id = :id')
    Left = 184
    Top = 112
    ParamData = <
      item
        Name = 'ID'
        DataType = ftInteger
        ParamType = ptInput
      end>
    object qryExecutavelID: TIntegerField
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qryExecutavelID_TIPO: TIntegerField
      FieldName = 'ID_TIPO'
      Origin = 'ID_TIPO'
    end
    object qryExecutavelORIGINAL_FILENAME: TStringField
      FieldName = 'ORIGINAL_FILENAME'
      Origin = 'ORIGINAL_FILENAME'
      Size = 50
    end
    object qryExecutavelORIGINAL_FILESIZE: TIntegerField
      FieldName = 'ORIGINAL_FILESIZE'
      Origin = 'ORIGINAL_FILESIZE'
    end
    object qryExecutavelVERSAO: TStringField
      FieldName = 'VERSAO'
      Origin = 'VERSAO'
      Size = 50
    end
    object qryExecutavelBINARIO: TBlobField
      FieldName = 'BINARIO'
      Origin = 'BINARIO'
    end
    object qryExecutavelBINARIO_HASH: TStringField
      FieldName = 'BINARIO_HASH'
      Origin = 'BINARIO_HASH'
      Size = 32
    end
    object qryExecutavelUPLOADED_POR: TIntegerField
      FieldName = 'UPLOADED_POR'
      Origin = 'UPLOADED_POR'
    end
    object qryExecutavelUPLOADED_EM: TSQLTimeStampField
      FieldName = 'UPLOADED_EM'
      Origin = 'UPLOADED_EM'
    end
    object qryExecutavelULTIMOUSO_EM: TSQLTimeStampField
      FieldName = 'ULTIMOUSO_EM'
      Origin = 'ULTIMOUSO_EM'
    end
    object qryExecutavelDELETADO: TStringField
      FieldName = 'DELETADO'
      Origin = 'DELETADO'
      FixedChar = True
      Size = 1
    end
  end
end
