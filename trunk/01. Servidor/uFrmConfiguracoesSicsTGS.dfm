inherited FrmConfiguracoesSicsTGS: TFrmConfiguracoesSicsTGS
  Caption = 'Configura'#231#245'es Sics TGS'
  ClientHeight = 571
  ClientWidth = 942
  ExplicitWidth = 958
  ExplicitHeight = 610
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlFundo: TPanel
    Width = 942
    Height = 571
    ExplicitWidth = 942
    ExplicitHeight = 571
    inherited grpConfiguracoes: TGroupBox
      Width = 737
      Height = 517
      ExplicitWidth = 737
      ExplicitHeight = 517
      object lblGruposAtendentesPermitidos: TLabel [0]
        Left = 10
        Top = 24
        Width = 191
        Height = 13
        Caption = 'Grupos de Atendentes Permitidos'
        FocusControl = edtGruposAtendentesPermitidos
      end
      object lblGruposTagsPermitidos: TLabel [1]
        Left = 10
        Top = 100
        Width = 153
        Height = 13
        Caption = 'Grupos de Tags Permitidos'
        FocusControl = edtGruposTagsPermitidos
      end
      object lblGruposIndicadoresPermitidos: TLabel [2]
        Left = 10
        Top = 138
        Width = 131
        Height = 13
        Caption = 'Indicadores Permitidos'
        FocusControl = edtGruposIndicadoresPermitidos
      end
      object lblGruposPausasPermitidos: TLabel [3]
        Left = 10
        Top = 62
        Width = 232
        Height = 13
        Caption = 'Grupos de Motivos de Pausas Permitidos'
        FocusControl = edtGruposPausasPermitidos
      end
      object lblGruposPAsPermitidas: TLabel [4]
        Left = 10
        Top = 178
        Width = 148
        Height = 13
        Caption = 'Grupos de PAs Permitidos'
        FocusControl = edtGruposPAsPermitidas
      end
      inherited grpConfigTela: TGroupBox
        Left = 517
        Top = 24
        Width = 213
        Height = 89
        Align = alCustom
        Anchors = [akTop, akRight]
        TabOrder = 10
        ExplicitLeft = 517
        ExplicitTop = 24
        ExplicitWidth = 213
        ExplicitHeight = 89
        object dbchkREPORTAR_TEMPOS_MAXIMOS: TDBCheckBox
          Left = 8
          Top = 63
          Width = 179
          Height = 17
          Caption = 'Reportar Tempos M'#225'ximos'
          DataField = 'REPORTAR_TEMPOS_MAXIMOS'
          DataSource = dtsConfig
          TabOrder = 0
          ValueChecked = 'T'
          ValueUnchecked = 'F'
        end
        object dbchkVISUALIZAR_GRUPOS: TDBCheckBox
          Left = 8
          Top = 20
          Width = 179
          Height = 17
          Caption = 'Visualizar Grupos'
          DataField = 'VISUALIZAR_GRUPOS'
          DataSource = dtsConfig
          TabOrder = 1
          ValueChecked = 'T'
          ValueUnchecked = 'F'
        end
        object dbchkVISUALIZAR_NOME_CLIENTES: TDBCheckBox
          Left = 8
          Top = 41
          Width = 179
          Height = 17
          Caption = 'Visualizar Nome Clientes'
          DataField = 'VISUALIZAR_NOME_CLIENTES'
          DataSource = dtsConfig
          TabOrder = 2
          ValueChecked = 'T'
          ValueUnchecked = 'F'
        end
      end
      inherited grpOutrasConfig: TGroupBox
        Left = 517
        Top = 247
        Width = 213
        Height = 122
        Anchors = [akTop, akRight]
        TabOrder = 11
        ExplicitLeft = 517
        ExplicitTop = 247
        ExplicitWidth = 213
        ExplicitHeight = 122
        object chkPodeFecharPrograma: TDBCheckBox
          Left = 8
          Top = 23
          Width = 150
          Height = 17
          Caption = 'Pode Fechar Programa'
          DataField = 'PODE_FECHAR_PROGRAMA'
          DataSource = dtsConfig
          TabOrder = 0
          ValueChecked = 'T'
          ValueUnchecked = 'F'
        end
        object dbchkMINIMIZAR_PARA_BANDEJA: TDBCheckBox
          Left = 8
          Top = 47
          Width = 180
          Height = 17
          Caption = 'Minimizar Para Bandeja'
          DataField = 'MINIMIZAR_PARA_BANDEJA'
          DataSource = dtsConfig
          TabOrder = 1
          ValueChecked = 'T'
          ValueUnchecked = 'F'
        end
        object DBCheckBox1: TDBCheckBox
          Left = 8
          Top = 71
          Width = 180
          Height = 17
          Caption = 'Modo Call Center'
          DataField = 'MODO_CALL_CENTER'
          DataSource = dtsConfig
          TabOrder = 2
          ValueChecked = 'T'
          ValueUnchecked = 'F'
        end
        object DBCheckBox2: TDBCheckBox
          Left = 8
          Top = 94
          Width = 180
          Height = 17
          Caption = 'Mostrar Relat'#243'rio de TMAA'
          DataField = 'MOSTRAR_RELATORIO_TMAA'
          DataSource = dtsConfig
          TabOrder = 3
          ValueChecked = 'T'
          ValueUnchecked = 'F'
        end
      end
      object edtGruposAtendentesPermitidos: TDBEdit
        Left = 10
        Top = 39
        Width = 470
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        DataField = 'GRUPOS_DE_ATENDENTES_PERMITIDOS'
        DataSource = dtsConfig
        TabOrder = 0
        OnExit = edtGruposAtendentesPermitidosExit
        OnKeyPress = edtGruposAtendentesPermitidosKeyPress
      end
      object edtGruposTagsPermitidos: TDBEdit
        Left = 10
        Top = 115
        Width = 470
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        DataField = 'GRUPOS_DE_TAGS_PERMITIDOS'
        DataSource = dtsConfig
        TabOrder = 4
        OnExit = edtGruposAtendentesPermitidosExit
        OnKeyPress = edtGruposAtendentesPermitidosKeyPress
      end
      object btnGruposAtendentesPermitidos: TButton
        Left = 485
        Top = 39
        Width = 25
        Height = 21
        Anchors = [akTop, akRight]
        Caption = '...'
        TabOrder = 1
        OnClick = btnGruposAtendentesPermitidosClick
      end
      object btnGruposTagsPermitidos: TButton
        Left = 485
        Top = 115
        Width = 25
        Height = 21
        Anchors = [akTop, akRight]
        Caption = '...'
        TabOrder = 5
        OnClick = btnGruposTagsPermitidosClick
      end
      object edtGruposIndicadoresPermitidos: TDBEdit
        Left = 10
        Top = 153
        Width = 470
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        DataField = 'GRUPOS_INDICADORES_PERMITIDOS'
        DataSource = dtsConfig
        TabOrder = 6
        OnExit = edtGruposAtendentesPermitidosExit
        OnKeyPress = edtGruposAtendentesPermitidosKeyPress
      end
      object btnGruposIndicadoresPermitidos: TButton
        Left = 485
        Top = 153
        Width = 25
        Height = 21
        Anchors = [akTop, akRight]
        Caption = '...'
        TabOrder = 7
        OnClick = btnGruposIndicadoresPermitidosClick
      end
      object edtGruposPausasPermitidos: TDBEdit
        Left = 10
        Top = 77
        Width = 470
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        DataField = 'GRUPOS_DE_MOTIVOS_DE_PAUSA_PERM'
        DataSource = dtsConfig
        TabOrder = 2
        OnExit = edtGruposAtendentesPermitidosExit
        OnKeyPress = edtGruposAtendentesPermitidosKeyPress
      end
      object btnGruposPausasPermitidos: TButton
        Left = 485
        Top = 77
        Width = 25
        Height = 21
        Anchors = [akTop, akRight]
        Caption = '...'
        TabOrder = 3
        OnClick = btnGruposPausasPermitidosClick
      end
      object edtGruposPAsPermitidas: TDBEdit
        Left = 10
        Top = 193
        Width = 470
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        DataField = 'GRUPOS_DE_PAS_PERMITIDAS'
        DataSource = dtsConfig
        TabOrder = 8
        OnExit = edtGruposAtendentesPermitidosExit
        OnKeyPress = edtGruposAtendentesPermitidosKeyPress
      end
      object btnGruposPAsPermitidas: TButton
        Left = 486
        Top = 191
        Width = 25
        Height = 21
        Anchors = [akTop, akRight]
        Caption = '...'
        TabOrder = 9
        OnClick = btnGruposPAsPermitidasClick
      end
      object GroupBox1: TGroupBox
        Left = 517
        Top = 126
        Width = 213
        Height = 105
        Anchors = [akTop, akRight]
        Caption = 'Permitir configura'#231#227'o de:'
        TabOrder = 12
        object dbchkPODE_CONFIG_ATENDENTES: TDBCheckBox
          Left = 8
          Top = 25
          Width = 179
          Height = 17
          Caption = 'Atendentes'
          DataField = 'PODE_CONFIG_ATENDENTES'
          DataSource = dtsConfig
          TabOrder = 0
          ValueChecked = 'T'
          ValueUnchecked = 'F'
        end
        object dbchkPODE_CONFIG_PRIORIDADES_ATEND: TDBCheckBox
          Left = 8
          Top = 51
          Width = 179
          Height = 17
          Caption = 'Prioridade de atendimento'
          DataField = 'PODE_CONFIG_PRIORIDADES_ATEND'
          DataSource = dtsConfig
          TabOrder = 1
          ValueChecked = 'T'
          ValueUnchecked = 'F'
        end
        object dbchkPODE_CONFIG_IND_DE_PERFORMANCE: TDBCheckBox
          Left = 8
          Top = 74
          Width = 179
          Height = 17
          Caption = 'Indicadores de Performance'
          DataField = 'PODE_CONFIG_IND_DE_PERFORMANCE'
          DataSource = dtsConfig
          TabOrder = 2
          ValueChecked = 'T'
          ValueUnchecked = 'F'
        end
      end
    end
    inherited pnlButtonSicsPA: TPanel
      Top = 519
      Width = 938
      ExplicitTop = 519
      ExplicitWidth = 938
      DesignSize = (
        938
        50)
      inherited btnSair: TBitBtn
        Left = 823
        ExplicitLeft = 823
      end
      inherited btnSalvar: TBitBtn
        Left = 713
        ExplicitLeft = 713
      end
    end
    inherited grpModulos: TGroupBox
      Height = 517
      ExplicitHeight = 517
      DesignSize = (
        201
        517)
      inherited btnSicsIncluir: TBitBtn
        Top = 445
        ExplicitTop = 445
      end
      inherited btnSicsExcluir: TBitBtn
        Top = 445
        ExplicitTop = 445
      end
      inherited btnCopiar: TBitBtn
        Left = 152
        Top = 445
        ExplicitLeft = 152
        ExplicitTop = 445
      end
      inherited grpGrid: TGroupBox
        Height = 417
        ExplicitHeight = 417
        inherited grdModulos: TDBGrid
          Height = 330
        end
        inherited pnlNovaConfig: TPanel
          Top = 345
          ExplicitTop = 345
        end
      end
    end
  end
  inherited dtsConfig: TDataSource
    Left = 752
    Top = 368
  end
  inherited CDSConfig: TClientDataSet
    Left = 824
    Top = 368
  end
  inherited dtsModulos: TDataSource
    Left = 752
    Top = 456
  end
  inherited CDSModulos: TClientDataSet
    Left = 824
    Top = 464
  end
end
