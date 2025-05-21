object frmCadastroGrupos: TfrmCadastroGrupos
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Cadastro de Grupos'
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
        Height = 309
        Align = alClient
        DataSource = dsGrupo
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        OnDblClick = btnAlterarClick
        Columns = <
          item
            Expanded = False
            FieldName = 'IDGRUPO'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'NOME'
            Width = 485
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
          Text = 'Grupo'
          OnCloseUp = cboPesquisaCloseUp
          Items.Strings = (
            'ID'
            'Grupo')
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
          TabOrder = 0
          OnClick = btnIncluirClick
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
        Width = 29
        Height = 13
        Caption = 'Grupo'
        FocusControl = dbedtGrupo
      end
      object dbedtID: TDBEdit
        Left = 3
        Top = 24
        Width = 80
        Height = 21
        TabStop = False
        Color = clBtnFace
        DataField = 'IDGRUPO'
        DataSource = dsGrupo
        ReadOnly = True
        TabOrder = 0
      end
      object dbedtGrupo: TDBEdit
        Left = 3
        Top = 64
        Width = 610
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        DataField = 'NOME'
        DataSource = dsGrupo
        TabOrder = 1
      end
      object Panel3: TPanel
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
    end
  end
  object dsGrupo: TDataSource
    DataSet = cdsGrupo
    Left = 272
    Top = 192
  end
  object qryGrupo: TFDQuery
    Connection = MainForm.connUnidades
    SQL.Strings = (
      'SELECT'
      '  *'
      'FROM'
      '  GRUPOS'
      'ORDER BY'
      '  IDGRUPO')
    Left = 104
    Top = 193
    object qryGrupoIDGRUPO: TIntegerField
      DisplayLabel = 'ID'
      FieldName = 'IDGRUPO'
      Origin = 'IDGRUPO'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qryGrupoNOME: TStringField
      DisplayLabel = 'Grupo'
      FieldName = 'NOME'
      Origin = 'NOME'
      Size = 50
    end
  end
  object dspGrupo: TDataSetProvider
    DataSet = qryGrupo
    Options = [poAutoRefresh, poPropogateChanges, poUseQuoteChar]
    UpdateMode = upWhereKeyOnly
    Left = 160
    Top = 192
  end
  object cdsGrupo: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspGrupo'
    AfterInsert = cdsGrupoAfterInsert
    BeforePost = cdsGrupoBeforePost
    Left = 216
    Top = 192
    object cdsGrupoIDGRUPO: TIntegerField
      DisplayLabel = 'ID'
      FieldName = 'IDGRUPO'
      Required = True
    end
    object cdsGrupoNOME: TStringField
      DisplayLabel = 'Grupo'
      FieldName = 'NOME'
      Size = 50
    end
  end
end
