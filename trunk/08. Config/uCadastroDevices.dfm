object frmCadastroDevices: TfrmCadastroDevices
  Left = 0
  Top = 0
  Caption = 'Cadastro de Devices'
  ClientHeight = 416
  ClientWidth = 626
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pagCad: TPageControl
    Left = 0
    Top = 0
    Width = 626
    Height = 416
    ActivePage = tsLista
    Align = alClient
    TabOrder = 0
    OnChanging = pagCadChanging
    object tsLista: TTabSheet
      Caption = 'Lista'
      object DBGrid1: TDBGrid
        Left = 0
        Top = 44
        Width = 618
        Height = 279
        Align = alClient
        DataSource = dsDevice
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        OnDrawColumnCell = DBGrid1DrawColumnCell
        OnDblClick = btnAlterarClick
        Columns = <
          item
            Expanded = False
            FieldName = 'ID'
            Width = 230
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'NOME'
            Width = 180
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CalcStatus'
            Width = 60
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ULTIMO_ACESSO'
            Width = 110
            Visible = True
          end>
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 618
        Height = 44
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        DesignSize = (
          618
          44)
        object Label1: TLabel
          Left = 3
          Top = 4
          Width = 42
          Height = 13
          Caption = 'Pesquisa'
        end
        object edtPesquisa: TEdit
          Left = 3
          Top = 18
          Width = 515
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 0
          OnChange = edtPesquisaChange
        end
        object cboPesquisa: TComboBox
          Left = 523
          Top = 18
          Width = 90
          Height = 21
          Style = csDropDownList
          Anchors = [akTop, akBottom]
          ItemIndex = 1
          TabOrder = 1
          Text = 'Device'
          OnCloseUp = cboPesquisaCloseUp
          Items.Strings = (
            'ID'
            'Device'
            'Status')
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 353
        Width = 618
        Height = 35
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 2
        DesignSize = (
          618
          35)
        object btnIncluir: TButton
          Left = 3
          Top = 6
          Width = 75
          Height = 25
          Anchors = [akLeft, akBottom]
          Caption = 'Incluir'
          Enabled = False
          TabOrder = 0
        end
        object btnAlterar: TButton
          Left = 84
          Top = 6
          Width = 75
          Height = 25
          Anchors = [akLeft, akBottom]
          Caption = 'Alterar'
          TabOrder = 1
          OnClick = btnAlterarClick
        end
        object btnSair: TButton
          Left = 538
          Top = 6
          Width = 75
          Height = 25
          Anchors = [akRight, akBottom]
          Caption = 'Sair'
          TabOrder = 2
          OnClick = btnSairClick
        end
        object btnExcluir: TButton
          Left = 165
          Top = 6
          Width = 75
          Height = 25
          Caption = 'Excluir'
          TabOrder = 3
          OnClick = btnExcluirClick
        end
      end
      object Panel4: TPanel
        Left = 0
        Top = 323
        Width = 618
        Height = 30
        Align = alBottom
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 3
        object LabeledEdit1: TLabeledEdit
          Left = 4
          Top = 5
          Width = 21
          Height = 21
          HelpType = htKeyword
          TabStop = False
          Color = clInfoBk
          EditLabel.Width = 46
          EditLabel.Height = 13
          EditLabel.Caption = 'Pendente'
          LabelPosition = lpRight
          ReadOnly = True
          TabOrder = 0
          OnEnter = LabeledEdit1Enter
        end
        object LabeledEdit2: TLabeledEdit
          Left = 104
          Top = 5
          Width = 21
          Height = 21
          HelpType = htKeyword
          TabStop = False
          Color = clInactiveCaption
          EditLabel.Width = 32
          EditLabel.Height = 13
          EditLabel.Caption = 'Ocioso'
          LabelPosition = lpRight
          ReadOnly = True
          TabOrder = 1
          OnEnter = LabeledEdit1Enter
        end
        object LabeledEdit3: TLabeledEdit
          Left = 204
          Top = 5
          Width = 21
          Height = 21
          HelpType = htKeyword
          TabStop = False
          Color = 12169726
          EditLabel.Width = 34
          EditLabel.Height = 13
          EditLabel.Caption = 'Inativo'
          LabelPosition = lpRight
          ReadOnly = True
          TabOrder = 2
          OnEnter = LabeledEdit1Enter
        end
      end
    end
    object tsManutencao: TTabSheet
      Caption = 'Manuten'#231#227'o'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      DesignSize = (
        618
        388)
      object Label2: TLabel
        Left = 3
        Top = 8
        Width = 11
        Height = 13
        Caption = 'ID'
        FocusControl = dbedtID
      end
      object Label3: TLabel
        Left = 3
        Top = 48
        Width = 32
        Height = 13
        Caption = 'Device'
        FocusControl = dbedtDevice
      end
      object Label4: TLabel
        Left = 312
        Top = 88
        Width = 66
        Height = 13
        Anchors = [akTop, akRight]
        Caption = #218'ltimo Acesso'
        FocusControl = dbedtUltimoAcesso
      end
      object dbedtID: TDBEdit
        Left = 3
        Top = 24
        Width = 240
        Height = 21
        TabStop = False
        Color = clBtnFace
        DataField = 'ID'
        DataSource = dsDevice
        ReadOnly = True
        TabOrder = 0
      end
      object dbedtDevice: TDBEdit
        Left = 3
        Top = 64
        Width = 610
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        DataField = 'NOME'
        DataSource = dsDevice
        TabOrder = 1
      end
      object Panel3: TPanel
        Left = 0
        Top = 353
        Width = 618
        Height = 35
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 5
        DesignSize = (
          618
          35)
        object btnGravar: TButton
          Left = 3
          Top = 6
          Width = 75
          Height = 25
          Anchors = [akLeft, akBottom]
          Caption = 'Gravar'
          TabOrder = 0
          OnClick = btnGravarClick
        end
        object btnCancelar: TButton
          Left = 84
          Top = 6
          Width = 75
          Height = 25
          Anchors = [akLeft, akBottom]
          Caption = 'Cancelar'
          TabOrder = 1
          OnClick = btnCancelarClick
        end
      end
      object dbedtUltimoAcesso: TDBEdit
        Left = 312
        Top = 104
        Width = 180
        Height = 21
        TabStop = False
        Anchors = [akTop, akRight]
        Color = clBtnFace
        DataField = 'ULTIMO_ACESSO'
        DataSource = dsDevice
        ReadOnly = True
        TabOrder = 3
      end
      object rgrpStatus: TDBRadioGroup
        Left = 3
        Top = 88
        Width = 303
        Height = 38
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Status'
        Columns = 4
        DataField = 'STATUS'
        DataSource = dsDevice
        Items.Strings = (
          'Ativo'
          'Ocioso'
          'Pendente'
          'Inativo')
        TabOrder = 2
        Values.Strings = (
          'A'
          'O'
          'P'
          'I')
      end
      object pagUnidades: TPageControl
        Left = 3
        Top = 132
        Width = 610
        Height = 215
        ActivePage = tsUnidades
        Anchors = [akLeft, akTop, akRight, akBottom]
        TabOrder = 4
        object tsUnidades: TTabSheet
          Caption = 'Unidades'
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object DBGrid2: TDBGrid
            Left = 0
            Top = 0
            Width = 602
            Height = 152
            Align = alClient
            DataSource = dsDeviceUnid
            TabOrder = 0
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -11
            TitleFont.Name = 'Tahoma'
            TitleFont.Style = []
            Columns = <
              item
                DropDownRows = 12
                Expanded = False
                FieldName = 'LookUnidade'
                Width = 489
                Visible = True
              end>
          end
          object Panel5: TPanel
            Left = 0
            Top = 152
            Width = 602
            Height = 35
            Align = alBottom
            BevelOuter = bvNone
            TabOrder = 1
            DesignSize = (
              602
              35)
            object btnIncUnidade: TButton
              Left = 3
              Top = 6
              Width = 75
              Height = 25
              Anchors = [akLeft, akBottom]
              Caption = 'Incluir'
              TabOrder = 0
              OnClick = btnIncUnidadeClick
            end
            object btnExcUnidade: TButton
              Left = 84
              Top = 6
              Width = 75
              Height = 25
              Anchors = [akLeft, akBottom]
              Caption = 'Excluir'
              TabOrder = 1
              OnClick = btnExcUnidadeClick
            end
          end
        end
      end
    end
  end
  object qryDevice: TFDQuery
    Connection = MainForm.connUnidades
    SQL.Strings = (
      'SELECT'
      '  D.*'
      'FROM'
      '  DEVICES D'
      'ORDER BY'
      '  D.ID')
    Left = 32
    Top = 128
    object qryDeviceID: TStringField
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
      Size = 36
    end
    object qryDeviceNOME: TStringField
      FieldName = 'NOME'
      Origin = 'NOME'
      Required = True
      Size = 50
    end
    object qryDeviceSTATUS: TStringField
      FieldName = 'STATUS'
      Origin = 'STATUS'
      FixedChar = True
      Size = 1
    end
    object qryDeviceULTIMO_ACESSO: TSQLTimeStampField
      FieldName = 'ULTIMO_ACESSO'
      Origin = 'ULTIMO_ACESSO'
    end
  end
  object dspDevice: TDataSetProvider
    DataSet = qryDevice
    Left = 96
    Top = 128
  end
  object cdsDevice: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspDevice'
    OnCalcFields = cdsDeviceCalcFields
    Left = 32
    Top = 176
    object cdsDeviceID: TStringField
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
      Size = 36
    end
    object cdsDeviceNOME: TStringField
      DisplayLabel = 'Device'
      FieldName = 'NOME'
      Origin = 'NOME'
      Required = True
      Size = 50
    end
    object cdsDeviceSTATUS: TStringField
      FieldName = 'STATUS'
      Origin = 'STATUS'
      OnGetText = cdsDeviceSTATUSGetText
      FixedChar = True
      Size = 1
    end
    object cdsDeviceULTIMO_ACESSO: TSQLTimeStampField
      DisplayLabel = #218'ltimo Acesso'
      FieldName = 'ULTIMO_ACESSO'
      Origin = 'ULTIMO_ACESSO'
    end
    object cdsDeviceCalcStatus: TStringField
      DisplayLabel = 'Status'
      FieldKind = fkInternalCalc
      FieldName = 'CalcStatus'
    end
    object cdsDeviceqryDeviceUnid: TDataSetField
      FieldName = 'qryDeviceUnid'
    end
  end
  object dsDevice: TDataSource
    DataSet = cdsDevice
    Left = 96
    Top = 176
  end
  object qryDeviceUnid: TFDQuery
    MasterSource = dsLinkDevice
    MasterFields = 'ID'
    Connection = MainForm.connUnidades
    FetchOptions.AssignedValues = [evCache]
    FetchOptions.Cache = [fiBlobs, fiMeta]
    SQL.Strings = (
      'SELECT * FROM DEVICES_UNIDADES WHERE ID_DEVICE = :ID')
    Left = 232
    Top = 128
    ParamData = <
      item
        Name = 'ID'
        DataType = ftString
        ParamType = ptInput
        Size = 36
        Value = 'D9A36B1165A943569C1CEFC414FAB1EA'
      end>
  end
  object cdsDeviceUnid: TClientDataSet
    Aggregates = <>
    DataSetField = cdsDeviceqryDeviceUnid
    Params = <>
    BeforeInsert = cdsDeviceUnidBeforeInsert
    AfterInsert = cdsDeviceUnidAfterInsert
    BeforeEdit = cdsDeviceUnidBeforeInsert
    AfterPost = cdsDeviceUnidBeforeInsert
    Left = 232
    Top = 176
    object cdsDeviceUnidID_DEVICE: TStringField
      FieldName = 'ID_DEVICE'
      Required = True
      Size = 36
    end
    object cdsDeviceUnidID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
      Required = True
      OnValidate = cdsDeviceUnidID_UNIDADEValidate
    end
    object cdsDeviceUnidLookUnidade: TStringField
      DisplayLabel = 'Unidade'
      FieldKind = fkLookup
      FieldName = 'LookUnidade'
      LookupDataSet = cdsUnidade
      LookupKeyFields = 'ID'
      LookupResultField = 'NOME'
      KeyFields = 'ID_UNIDADE'
      Size = 50
      Lookup = True
    end
  end
  object dsDeviceUnid: TDataSource
    DataSet = cdsDeviceUnid
    Left = 304
    Top = 176
  end
  object dsLinkDevice: TDataSource
    DataSet = qryDevice
    Left = 168
    Top = 104
  end
  object qryUnidade: TFDQuery
    Connection = MainForm.connUnidades
    SQL.Strings = (
      'SELECT '
      '  ID, '
      '  NOME '
      'FROM '
      '  UNIDADES'
      'ORDER BY'
      '  ID')
    Left = 32
    Top = 240
    object qryUnidadeID: TIntegerField
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qryUnidadeNOME: TStringField
      FieldName = 'NOME'
      Origin = 'NOME'
      Size = 40
    end
  end
  object dspUnidade: TDataSetProvider
    DataSet = qryUnidade
    Left = 96
    Top = 240
  end
  object cdsUnidade: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspUnidade'
    Left = 32
    Top = 288
    object cdsUnidadeID: TIntegerField
      FieldName = 'ID'
      Required = True
    end
    object cdsUnidadeNOME: TStringField
      DisplayLabel = 'Unidade'
      FieldName = 'NOME'
      Size = 40
    end
  end
  object dsUnidade: TDataSource
    DataSet = cdsUnidade
    Left = 96
    Top = 288
  end
  object cdsClone: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 400
    Top = 264
  end
  object dsClone: TDataSource
    DataSet = cdsClone
    Left = 448
    Top = 264
  end
end
