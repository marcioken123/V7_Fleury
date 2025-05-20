inherited FrmConfiguracoesSicsOnLine: TFrmConfiguracoesSicsOnLine
  Caption = 'Configura'#231#245'es Sics On-Line'
  ClientHeight = 827
  ClientWidth = 894
  Constraints.MinHeight = 600
  Constraints.MinWidth = 910
  ExplicitWidth = 910
  ExplicitHeight = 866
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlFundo: TPanel
    Width = 894
    Height = 827
    ExplicitWidth = 894
    ExplicitHeight = 561
    inherited grpConfiguracoes: TGroupBox
      Width = 689
      Height = 773
      ExplicitWidth = 689
      ExplicitHeight = 507
      inherited grpOutrasConfig: TGroupBox [0]
        Left = 432
        Top = 14
        Width = 250
        Height = 175
        Anchors = [akTop, akRight]
        ExplicitLeft = 432
        ExplicitTop = 14
        ExplicitWidth = 250
        ExplicitHeight = 175
        object dbchkVISUALIZAR_GRUPOS: TDBCheckBox
          Left = 17
          Top = 49
          Width = 150
          Height = 17
          Caption = 'Visualizar Grupos'
          DataField = 'VISUALIZAR_GRUPOS'
          DataSource = dtsConfig
          TabOrder = 1
          ValueChecked = 'T'
          ValueUnchecked = 'F'
        end
        object dbchkPODE_FECHAR_PROGRAMA: TDBCheckBox
          Left = 17
          Top = 27
          Width = 150
          Height = 17
          Caption = 'Pode Fechar Programa'
          DataField = 'PODE_FECHAR_PROGRAMA'
          DataSource = dtsConfig
          TabOrder = 0
          ValueChecked = 'T'
          ValueUnchecked = 'F'
        end
        object dbchkVISUALIZAR_NOME_CLIENTES: TDBCheckBox
          Left = 17
          Top = 72
          Width = 179
          Height = 17
          Caption = 'Visualizar Nome Clientes'
          DataField = 'VISUALIZAR_NOME_CLIENTES'
          DataSource = dtsConfig
          TabOrder = 2
          ValueChecked = 'T'
          ValueUnchecked = 'F'
        end
        object DBCheckBox1: TDBCheckBox
          Left = 17
          Top = 96
          Width = 180
          Height = 17
          Caption = 'Modo Call Center'
          DataField = 'MODO_CALL_CENTER'
          DataSource = dtsConfig
          TabOrder = 3
          ValueChecked = 'T'
          ValueUnchecked = 'F'
        end
        object DBCheckBox2: TDBCheckBox
          Left = 17
          Top = 119
          Width = 180
          Height = 17
          Caption = 'Mostrar Dados Adicionais'
          DataField = 'MOSTRAR_DADOS_ADICIONAIS'
          DataSource = dtsConfig
          TabOrder = 4
          ValueChecked = 'T'
          ValueUnchecked = 'F'
        end
        object DBCheckBox3: TDBCheckBox
          Left = 17
          Top = 142
          Width = 232
          Height = 17
          Caption = 'Mostrar Somente Tags Preenchidas'
          DataField = 'MOSTRAR_TAGS_PREENCHIDAS'
          DataSource = dtsConfig
          TabOrder = 5
          ValueChecked = 'T'
          ValueUnchecked = 'F'
        end
      end
      object scrlbxConfiguracoes: TScrollBox [1]
        Left = 7
        Top = 18
        Width = 419
        Height = 747
        Anchors = [akLeft, akTop, akRight, akBottom]
        Color = 14737632
        ParentColor = False
        TabOrder = 0
        DesignSize = (
          415
          743)
        object lblGrupoAtendPermitidos: TLabel
          Left = 11
          Top = 428
          Width = 184
          Height = 13
          Caption = 'Grupo de atendentes permitidos'
          FocusControl = edtGrupoAtendPermitidos
        end
        object lblGrupoIndicadoresPermitidos: TLabel
          Left = 11
          Top = 546
          Width = 131
          Height = 13
          Caption = 'Indicadores Permitidos'
          FocusControl = edtGrupoIndicadoresPermitidos
        end
        object lblGruposMotivosPausaPermitidos: TLabel
          Left = 11
          Top = 509
          Width = 190
          Height = 13
          Caption = 'Grupos Motivos Pausa Permitidos'
          FocusControl = edtGruposMotivosPausaPermitidos
        end
        object lblImpressoraComanda: TLabel
          Left = 260
          Top = 626
          Width = 136
          Height = 13
          Anchors = [akTop, akRight]
          Caption = 'Impressora comandada'
          ExplicitLeft = 223
        end
        object lblGruposPAsPermitidas: TLabel
          Left = 11
          Top = 583
          Width = 148
          Height = 13
          Caption = 'Grupos de PAs Permitidos'
          FocusControl = edtGruposPAsPermitidas
        end
        object lblGruposTagsPermitidos: TLabel
          Left = 11
          Top = 470
          Width = 153
          Height = 13
          Caption = 'Grupos de Tags Permitidos'
          FocusControl = edtGruposTagsPermitidos
        end
        object Label1: TLabel
          Left = 11
          Top = 626
          Width = 67
          Height = 13
          Caption = 'Tela Padr'#227'o'
        end
        object lblIdUnidadeCliente: TLabel
          Left = 11
          Top = 666
          Width = 106
          Height = 13
          Caption = 'Id Unidade Cliente'
          FocusControl = edtIdUnidadeCliente
        end
        object btnGrupoAtendPermitidos: TButton
          Left = 373
          Top = 443
          Width = 25
          Height = 21
          Anchors = [akTop, akRight]
          Caption = '...'
          TabOrder = 2
          OnClick = btnGrupoAtendPermitidosClick
          ExplicitLeft = 336
        end
        object btnGrupoIndicadoresPermitidos: TButton
          Left = 373
          Top = 559
          Width = 25
          Height = 21
          Anchors = [akTop, akRight]
          Caption = '...'
          TabOrder = 8
          OnClick = btnGrupoIndicadoresPermitidosClick
          ExplicitLeft = 336
        end
        object btnGruposMotivosPausaPermitidos: TButton
          Left = 373
          Top = 522
          Width = 25
          Height = 21
          Anchors = [akTop, akRight]
          Caption = '...'
          TabOrder = 6
          OnClick = btnGruposMotivosPausaPermitidosClick
          ExplicitLeft = 336
        end
        object btnGruposTagsPermitidos: TButton
          Left = 373
          Top = 485
          Width = 25
          Height = 21
          Anchors = [akTop, akRight]
          Caption = '...'
          TabOrder = 4
          OnClick = btnGruposTagsPermitidosClick
          ExplicitLeft = 336
        end
        object edtGrupoAtendPermitidos: TDBEdit
          Left = 11
          Top = 443
          Width = 356
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          DataField = 'GRUPOS_ATENDENTES_PERMITIDOS'
          DataSource = dtsConfig
          TabOrder = 1
          OnExit = edtFilasPermitidasExit
          OnKeyPress = edtFilasPermitidasKeyPress
          ExplicitWidth = 319
        end
        object edtGrupoIndicadoresPermitidos: TDBEdit
          Left = 11
          Top = 559
          Width = 356
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          DataField = 'GRUPOS_INDICADORES_PERMITIDOS'
          DataSource = dtsConfig
          TabOrder = 7
          OnExit = edtFilasPermitidasExit
          OnKeyPress = edtFilasPermitidasKeyPress
          ExplicitWidth = 319
        end
        object edtGruposMotivosPausaPermitidos: TDBEdit
          Left = 11
          Top = 522
          Width = 356
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          DataField = 'GRUPOS_MOTIVOS_PAUSA_PERMITIDO'
          DataSource = dtsConfig
          TabOrder = 5
          OnExit = edtFilasPermitidasExit
          OnKeyPress = edtFilasPermitidasKeyPress
          ExplicitWidth = 319
        end
        object edtImpressoraComanda: TDBEdit
          Left = 260
          Top = 640
          Width = 136
          Height = 21
          Anchors = [akTop, akRight]
          DataField = 'IMPRESSORA_COMANDADA'
          DataSource = dtsConfig
          TabOrder = 12
          ExplicitLeft = 223
        end
        object edtGruposTagsPermitidos: TDBEdit
          Left = 11
          Top = 485
          Width = 356
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          DataField = 'GRUPOS_TAGS_PERMITIDAS'
          DataSource = dtsConfig
          TabOrder = 3
          OnExit = edtFilasPermitidasExit
          OnKeyPress = edtFilasPermitidasKeyPress
          ExplicitWidth = 319
        end
        object edtGruposPAsPermitidas: TDBEdit
          Left = 11
          Top = 596
          Width = 356
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          DataField = 'GRUPOS_PAS_PERMITIDAS'
          DataSource = dtsConfig
          TabOrder = 9
          OnExit = edtFilasPermitidasExit
          OnKeyPress = edtFilasPermitidasKeyPress
          ExplicitWidth = 319
        end
        object btnGruposPAsPermitidas: TButton
          Left = 373
          Top = 596
          Width = 25
          Height = 21
          Anchors = [akTop, akRight]
          Caption = '...'
          TabOrder = 10
          OnClick = btnGruposPAsPermitidasClick
          ExplicitLeft = 336
        end
        object cbTelas: TDBLookupComboBox
          Left = 11
          Top = 640
          Width = 190
          Height = 21
          DataField = 'TELA_PADRAO'
          DataSource = dtsConfig
          KeyField = 'ID'
          ListField = 'NOME'
          ListSource = dmSicsMain.dscTelasOnline
          TabOrder = 11
        end
        object grpVisualizacaoEspera: TGroupBox
          Left = 3
          Top = 3
          Width = 405
          Height = 414
          Anchors = [akLeft, akTop, akRight]
          Caption = 'Visualiza'#231#227'o da espera'
          TabOrder = 0
          ExplicitWidth = 368
          DesignSize = (
            405
            414)
          object lblFilasPermitidas: TLabel
            Left = 8
            Top = 18
            Width = 89
            Height = 13
            Caption = 'Filas permitidas'
            FocusControl = edtFilasPermitidas
          end
          object lblPermiteExclusaoFilas: TLabel
            Left = 8
            Top = 57
            Width = 150
            Height = 13
            Caption = 'Permitir exclus'#227'o nas filas'
            FocusControl = edtPermiteExclusaoFilas
          end
          object lblPermitirReimpressaoFilas: TLabel
            Left = 8
            Top = 94
            Width = 171
            Height = 13
            Caption = 'Permitir reimpress'#227'o nas filas'
            FocusControl = edtPermitirReimpressao
          end
          object lblMostrarBotaoFilas: TLabel
            Left = 8
            Top = 132
            Width = 130
            Height = 13
            Caption = 'Mostrar bot'#227'o nas filas'
            FocusControl = edtMostrarBotaoFilas
          end
          object lblMostrarBloquearFilas: TLabel
            Left = 8
            Top = 170
            Width = 148
            Height = 13
            Caption = 'Mostrar bloquear nas filas'
            FocusControl = edtMostrarBloquearFilas
          end
          object lblMostrarPrioritariaFilas: TLabel
            Left = 8
            Top = 207
            Width = 154
            Height = 13
            Caption = 'Mostrar priorit'#225'ria nas filas'
            FocusControl = edtMostrarPrioritariaFilas
          end
          object lblPermitirInclusaoFilas: TLabel
            Left = 8
            Top = 244
            Width = 146
            Height = 13
            Caption = 'Permitir inclus'#227'o nas filas'
            FocusControl = edtPermitirInclusaoFilas
          end
          object lblColunasFilas: TLabel
            Left = 8
            Top = 286
            Width = 91
            Height = 13
            Caption = 'Colunas de filas'
          end
          object lblFilasPorPagina: TLabel
            Left = 117
            Top = 286
            Width = 81
            Height = 13
            Caption = 'Linhas de filas'
          end
          object lblTamanhoFonte: TLabel
            Left = 144
            Top = 330
            Width = 103
            Height = 13
            Caption = 'Tamanho da fonte'
          end
          object lblLayoutFilas: TLabel
            Left = 213
            Top = 288
            Width = 65
            Height = 13
            Caption = 'Layout filas'
          end
          object lblCorLimiar: TLabel
            Left = 8
            Top = 330
            Width = 57
            Height = 13
            Caption = 'Cor limiar'
          end
          object Label2: TLabel
            Left = 252
            Top = 330
            Width = 72
            Height = 13
            Caption = 'Estilo Layout'
          end
          object edtFilasPermitidas: TDBEdit
            Left = 8
            Top = 34
            Width = 356
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            DataField = 'FILAS_PERMITIDAS'
            DataSource = dtsConfig
            TabOrder = 0
            OnExit = edtFilasPermitidasExit
            OnKeyPress = edtFilasPermitidasKeyPress
            ExplicitWidth = 317
          end
          object btnFilasPermitidas: TButton
            Left = 369
            Top = 34
            Width = 25
            Height = 21
            Anchors = [akTop, akRight]
            Caption = '...'
            TabOrder = 1
            OnClick = btnFilasPermitidasClick
            ExplicitLeft = 330
          end
          object edtPermiteExclusaoFilas: TDBEdit
            Left = 8
            Top = 70
            Width = 356
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            DataField = 'PERMITIR_EXCLUSAO_NAS_FILAS'
            DataSource = dtsConfig
            TabOrder = 2
            OnExit = edtFilasPermitidasExit
            OnKeyPress = edtFilasPermitidasKeyPress
            ExplicitWidth = 317
          end
          object btnPermiteExclusaoFilas: TButton
            Left = 369
            Top = 70
            Width = 25
            Height = 21
            Anchors = [akTop, akRight]
            Caption = '...'
            TabOrder = 3
            OnClick = btnPermiteExclusaoFilasClick
            ExplicitLeft = 330
          end
          object edtPermitirReimpressao: TDBEdit
            Left = 8
            Top = 107
            Width = 356
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            DataField = 'PERMITIR_REIMPRESSAO_NAS_FILAS'
            DataSource = dtsConfig
            TabOrder = 4
            OnExit = edtFilasPermitidasExit
            OnKeyPress = edtFilasPermitidasKeyPress
            ExplicitWidth = 317
          end
          object btnPermitirReimpressao: TButton
            Left = 369
            Top = 107
            Width = 25
            Height = 21
            Anchors = [akTop, akRight]
            Caption = '...'
            TabOrder = 5
            OnClick = btnPermitirReimpressaoClick
            ExplicitLeft = 330
          end
          object edtMostrarBotaoFilas: TDBEdit
            Left = 8
            Top = 145
            Width = 356
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            DataField = 'MOSTRAR_BOTAO_NAS_FILAS'
            DataSource = dtsConfig
            TabOrder = 6
            OnExit = edtFilasPermitidasExit
            OnKeyPress = edtFilasPermitidasKeyPress
            ExplicitWidth = 317
          end
          object btnMostrarBotaoFilas: TButton
            Left = 369
            Top = 145
            Width = 25
            Height = 21
            Anchors = [akTop, akRight]
            Caption = '...'
            TabOrder = 7
            OnClick = btnMostrarBotaoFilasClick
            ExplicitLeft = 330
          end
          object edtMostrarBloquearFilas: TDBEdit
            Left = 8
            Top = 183
            Width = 356
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            DataField = 'MOSTRAR_BLOQUEAR_NAS_FILAS'
            DataSource = dtsConfig
            TabOrder = 8
            OnExit = edtFilasPermitidasExit
            OnKeyPress = edtFilasPermitidasKeyPress
            ExplicitWidth = 317
          end
          object btnMostrarBloquearFilas: TButton
            Left = 369
            Top = 183
            Width = 25
            Height = 21
            Anchors = [akTop, akRight]
            Caption = '...'
            TabOrder = 9
            OnClick = btnMostrarBloquearFilasClick
            ExplicitLeft = 330
          end
          object edtMostrarPrioritariaFilas: TDBEdit
            Left = 8
            Top = 221
            Width = 356
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            DataField = 'MOSTRAR_PRIORITARIA_NAS_FILAS'
            DataSource = dtsConfig
            TabOrder = 10
            OnExit = edtFilasPermitidasExit
            OnKeyPress = edtFilasPermitidasKeyPress
            ExplicitWidth = 317
          end
          object edtPermitirInclusaoFilas: TDBEdit
            Left = 8
            Top = 257
            Width = 356
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            DataField = 'PERMITIR_INCLUSAO_NAS_FILAS'
            DataSource = dtsConfig
            TabOrder = 12
            OnExit = edtFilasPermitidasExit
            OnKeyPress = edtFilasPermitidasKeyPress
            ExplicitWidth = 317
          end
          object btnMostrarPrioritariaFilas: TButton
            Left = 370
            Top = 221
            Width = 25
            Height = 21
            Anchors = [akTop, akRight]
            Caption = '...'
            TabOrder = 11
            OnClick = btnMostrarPrioritariaFilasClick
            ExplicitLeft = 331
          end
          object btnPermitirInclusaoFilas: TButton
            Left = 370
            Top = 257
            Width = 25
            Height = 21
            Anchors = [akTop, akRight]
            Caption = '...'
            TabOrder = 13
            OnClick = btnPermitirInclusaoFilasClick
            ExplicitLeft = 331
          end
          object edtColunasFilas: TDBEdit
            Left = 8
            Top = 303
            Width = 91
            Height = 21
            DataField = 'COLUNAS_DE_FILAS'
            DataSource = dtsConfig
            TabOrder = 14
          end
          object edtLinhasDeFilas: TDBEdit
            Left = 117
            Top = 303
            Width = 90
            Height = 21
            DataField = 'LINHAS_DE_FILAS'
            DataSource = dtsConfig
            TabOrder = 15
          end
          object cbTamanhoFonte: TDBLookupComboBox
            Left = 143
            Top = 347
            Width = 103
            Height = 21
            DataField = 'TAMANHO_FONTE'
            DataSource = dtsConfig
            KeyField = 'ID'
            ListField = 'NOME'
            ListSource = dmSicsMain.dsTamanhoFonteOnline
            TabOrder = 18
          end
          object cbLayoutFilas: TDBLookupComboBox
            Left = 213
            Top = 303
            Width = 142
            Height = 21
            DataField = 'SITUACAOESPERA_LAYOUT'
            DataSource = dtsConfig
            KeyField = 'ID'
            ListField = 'NOME'
            ListSource = dmSicsMain.dsLayoutsEsperaOnLine
            TabOrder = 16
          end
          object chkMostrarTodas: TDBCheckBox
            Left = 8
            Top = 374
            Width = 248
            Height = 17
            Caption = 'Mostrar op'#231#227'o excluir todas as senhas'
            DataField = 'MOSTRAR_EXCLUIR_TODAS'
            DataSource = dtsConfig
            TabOrder = 20
            ValueChecked = 'T'
            ValueUnchecked = 'F'
          end
          object chkMostrarTempoDecorridoEspera: TDBCheckBox
            Left = 8
            Top = 391
            Width = 227
            Height = 17
            Caption = 'Mostrar tempo decorrido de espera'
            DataField = 'MOSTRA_TEMPO_DECORRIDO_ESPERA'
            DataSource = dtsConfig
            TabOrder = 21
            ValueChecked = 'T'
            ValueUnchecked = 'F'
          end
          object cbCorLimiar: TDBLookupComboBox
            Left = 8
            Top = 345
            Width = 118
            Height = 21
            DataField = 'SITUACAOESPERA_CORLAYOUT'
            DataSource = dtsConfig
            KeyField = 'ID'
            ListField = 'NOME'
            ListSource = dmSicsMain.dsCorLimiarOnLine
            TabOrder = 17
          end
          object cbEstiloLayout: TDBLookupComboBox
            Left = 252
            Top = 347
            Width = 103
            Height = 21
            DataField = 'ESTILOESPERA_LAYOUT'
            DataSource = dtsConfig
            KeyField = 'ID'
            ListField = 'NOME'
            ListSource = dmSicsMain.dsEstiloLayoutsEsperaOnline
            TabOrder = 19
          end
        end
        object edtIdUnidadeCliente: TDBEdit
          Left = 11
          Top = 685
          Width = 77
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          DataField = 'ID_UNIDADE_CLI'
          DataSource = dtsConfig
          TabOrder = 13
          ExplicitWidth = 108
        end
      end
      inherited grpConfigTela: TGroupBox [2]
        Left = 468
        Top = 443
        Width = 215
        Height = 60
        Align = alCustom
        Caption = ''
        TabOrder = 2
        Visible = False
        ExplicitLeft = 468
        ExplicitTop = 443
        ExplicitWidth = 215
        ExplicitHeight = 60
      end
    end
    inherited pnlButtonSicsPA: TPanel
      Top = 775
      Width = 890
      ExplicitTop = 509
      ExplicitWidth = 890
      DesignSize = (
        890
        50)
      inherited btnSair: TBitBtn
        Left = 780
        ExplicitLeft = 780
      end
      inherited btnSalvar: TBitBtn
        Left = 665
        Cancel = False
        Glyph.Data = {
          DE010000424DDE01000000000000760000002800000024000000120000000100
          0400000000006801000000000000000000001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          3333333333333333333333330000333333333333333333333333F33333333333
          00003333344333333333333333388F3333333333000033334224333333333333
          338338F3333333330000333422224333333333333833338F3333333300003342
          222224333333333383333338F3333333000034222A22224333333338F338F333
          8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
          33333338F83338F338F33333000033A33333A222433333338333338F338F3333
          0000333333333A222433333333333338F338F33300003333333333A222433333
          333333338F338F33000033333333333A222433333333333338F338F300003333
          33333333A222433333333333338F338F00003333333333333A22433333333333
          3338F38F000033333333333333A223333333333333338F830000333333333333
          333A333333333333333338330000333333333333333333333333333333333333
          0000}
        ExplicitLeft = 665
      end
    end
    inherited grpModulos: TGroupBox
      Height = 773
      ExplicitHeight = 507
      DesignSize = (
        201
        773)
      inherited btnSicsIncluir: TBitBtn
        Top = 714
        ExplicitTop = 448
      end
      inherited btnSicsExcluir: TBitBtn
        Top = 714
        ExplicitTop = 448
      end
      inherited btnCopiar: TBitBtn
        Top = 714
        ExplicitTop = 448
      end
      inherited grpGrid: TGroupBox
        Height = 686
        ExplicitHeight = 420
        inherited grdModulos: TDBGrid
          Height = 599
        end
        inherited pnlNovaConfig: TPanel
          Top = 614
          ExplicitTop = 348
        end
      end
    end
  end
  inherited dtsConfig: TDataSource
    Left = 104
    Top = 120
  end
  inherited CDSConfig: TClientDataSet
    Left = 152
    Top = 120
  end
  inherited dtsModulos: TDataSource
    Left = 104
    Top = 160
  end
  inherited CDSModulos: TClientDataSet
    Left = 152
    Top = 161
  end
end
