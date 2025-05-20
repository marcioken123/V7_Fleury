inherited FrmConfiguracoesSicsPA: TFrmConfiguracoesSicsPA
  ClientHeight = 627
  ClientWidth = 942
  Constraints.MinHeight = 666
  ExplicitWidth = 958
  ExplicitHeight = 666
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlFundo: TPanel
    Width = 942
    Height = 627
    ExplicitWidth = 942
    ExplicitHeight = 627
    inherited grpConfiguracoes: TGroupBox
      Width = 737
      Height = 573
      ExplicitWidth = 737
      ExplicitHeight = 573
      inherited grpConfigTela: TGroupBox
        Left = 536
        Height = 542
        TabOrder = 3
        ExplicitLeft = 536
        ExplicitHeight = 542
        object chkMostrarNomeCliente: TDBCheckBox
          Left = 8
          Top = 18
          Width = 180
          Height = 17
          Caption = 'Mostrar Nome Cliente'
          DataField = 'MOSTRAR_NOME_CLIENTE'
          DataSource = dtsConfig
          TabOrder = 0
          ValueChecked = 'T'
          ValueUnchecked = 'F'
        end
        object chkMostrarPA: TDBCheckBox
          Left = 8
          Top = 39
          Width = 180
          Height = 17
          Caption = 'Mostrar PA'
          DataField = 'MOSTRAR_PA'
          DataSource = dtsConfig
          TabOrder = 1
          ValueChecked = 'T'
          ValueUnchecked = 'F'
        end
        object chkMostrarNomeAtendente: TDBCheckBox
          Left = 8
          Top = 59
          Width = 180
          Height = 17
          Caption = 'Mostrar Nome do Atendente'
          DataField = 'MOSTRAR_NOME_ATENDENTE'
          DataSource = dtsConfig
          TabOrder = 2
          ValueChecked = 'T'
          ValueUnchecked = 'F'
        end
        object groupBotoesVisiveis: TGroupBox
          Left = 9
          Top = 81
          Width = 175
          Height = 224
          Caption = 'Bot'#245'es vis'#237'veis'
          TabOrder = 3
          object chkMostrarBotaoProximo: TDBCheckBox
            Left = 12
            Top = 18
            Width = 139
            Height = 17
            Caption = 'Pr'#243'ximo'
            DataField = 'MOSTRAR_BOTAO_PROXIMO'
            DataSource = dtsConfig
            TabOrder = 0
            ValueChecked = 'T'
            ValueUnchecked = 'F'
          end
          object chkMostrarBotaoRechama: TDBCheckBox
            Left = 12
            Top = 37
            Width = 139
            Height = 17
            Caption = 'Rechama'
            DataField = 'MOSTRAR_BOTAO_RECHAMA'
            DataSource = dtsConfig
            TabOrder = 1
            ValueChecked = 'T'
            ValueUnchecked = 'F'
          end
          object chkMostrarBotaoEncaminha: TDBCheckBox
            Left = 12
            Top = 77
            Width = 139
            Height = 17
            Caption = 'Encaminha'
            DataField = 'MOSTRAR_BOTAO_ENCAMINHA'
            DataSource = dtsConfig
            TabOrder = 3
            ValueChecked = 'T'
            ValueUnchecked = 'F'
          end
          object chkMostrarBotaoFinaliza: TDBCheckBox
            Left = 12
            Top = 97
            Width = 139
            Height = 17
            Caption = 'Finaliza'
            DataField = 'MOSTRAR_BOTAO_FINALIZA'
            DataSource = dtsConfig
            TabOrder = 4
            ValueChecked = 'T'
            ValueUnchecked = 'F'
          end
          object chkMostrarBotaoEspecifica: TDBCheckBox
            Left = 12
            Top = 57
            Width = 139
            Height = 17
            Caption = 'Espec'#237'fica'
            DataField = 'MOSTRAR_BOTAO_ESPECIFICA'
            DataSource = dtsConfig
            TabOrder = 2
            ValueChecked = 'T'
            ValueUnchecked = 'F'
          end
          object chkMostrarBotaoPausa: TDBCheckBox
            Left = 12
            Top = 117
            Width = 139
            Height = 17
            Caption = 'Pausa'
            DataField = 'MOSTRAR_BOTAO_PAUSA'
            DataSource = dtsConfig
            TabOrder = 5
            ValueChecked = 'T'
            ValueUnchecked = 'F'
          end
          object dbchkMOSTRAR_BOTAO_PROCESSOS: TDBCheckBox
            Left = 12
            Top = 137
            Width = 139
            Height = 17
            Caption = 'Processos paralelos'
            DataField = 'MOSTRAR_BOTAO_PROCESSOS'
            DataSource = dtsConfig
            TabOrder = 6
            ValueChecked = 'T'
            ValueUnchecked = 'F'
          end
          object chkMostrarBotaoLoginLogout: TDBCheckBox
            Left = 12
            Top = 157
            Width = 139
            Height = 17
            Caption = 'Login/Logout'
            DataField = 'MOSTRAR_BOTAO_LOGIN_LOGOUT'
            DataSource = dtsConfig
            TabOrder = 7
            ValueChecked = 'T'
            ValueUnchecked = 'F'
          end
          object chkMostrarBotaoSeguirAtendimento: TDBCheckBox
            Left = 12
            Top = 180
            Width = 139
            Height = 17
            Caption = 'Seguir Atendimento'
            DataField = 'MOSTRAR_BOTAO_SEGUIRATENDIMENTO'
            DataSource = dtsConfig
            TabOrder = 8
            ValueChecked = 'T'
            ValueUnchecked = 'F'
          end
          object chkMostrarBotaoDadosAdicionais: TDBCheckBox
            Left = 12
            Top = 203
            Width = 139
            Height = 17
            Caption = 'Dados Adicionais'
            DataField = 'MOSTRAR_BOTAO_DADOS_ADICIONAIS'
            DataSource = dtsConfig
            TabOrder = 9
            ValueChecked = 'T'
            ValueUnchecked = 'F'
          end
        end
        object groupMenusVisiveis: TGroupBox
          Left = 9
          Top = 311
          Width = 175
          Height = 226
          Caption = 'Menus vis'#237'veis'
          TabOrder = 4
          object chkMostrarMenuProximo: TDBCheckBox
            Left = 12
            Top = 15
            Width = 139
            Height = 17
            Caption = 'Pr'#243'ximo'
            DataField = 'MOSTRAR_MENU_PROXIMO'
            DataSource = dtsConfig
            TabOrder = 0
            ValueChecked = 'T'
            ValueUnchecked = 'F'
          end
          object chkMostrarMenuRechama: TDBCheckBox
            Left = 12
            Top = 38
            Width = 139
            Height = 17
            Caption = 'Rechama'
            DataField = 'MOSTRAR_MENU_RECHAMA'
            DataSource = dtsConfig
            TabOrder = 1
            ValueChecked = 'T'
            ValueUnchecked = 'F'
          end
          object chkMostrarMenuEspecifica: TDBCheckBox
            Left = 12
            Top = 58
            Width = 139
            Height = 17
            Caption = 'Espec'#237'fica'
            DataField = 'MOSTRAR_MENU_ESPECIFICA'
            DataSource = dtsConfig
            TabOrder = 2
            ValueChecked = 'T'
            ValueUnchecked = 'F'
          end
          object chkMostrarMenuEncaminha: TDBCheckBox
            Left = 12
            Top = 78
            Width = 139
            Height = 17
            Caption = 'Encaminha'
            DataField = 'MOSTRAR_MENU_ENCAMINHA'
            DataSource = dtsConfig
            TabOrder = 3
            ValueChecked = 'T'
            ValueUnchecked = 'F'
          end
          object chkMostrarMenuFinaliza: TDBCheckBox
            Left = 12
            Top = 99
            Width = 139
            Height = 17
            Caption = 'Finaliza'
            DataField = 'MOSTRAR_MENU_FINALIZA'
            DataSource = dtsConfig
            TabOrder = 4
            ValueChecked = 'T'
            ValueUnchecked = 'F'
          end
          object chkMostrarMenuPausa: TDBCheckBox
            Left = 12
            Top = 119
            Width = 139
            Height = 17
            Caption = 'Pausa'
            DataField = 'MOSTRAR_MENU_PAUSA'
            DataSource = dtsConfig
            TabOrder = 5
            ValueChecked = 'T'
            ValueUnchecked = 'F'
          end
          object dbchkMenuProcessos: TDBCheckBox
            Left = 12
            Top = 139
            Width = 139
            Height = 17
            Caption = 'Processos paralelos'
            DataField = 'MOSTRAR_MENU_PROCESSOS'
            DataSource = dtsConfig
            TabOrder = 6
            ValueChecked = 'T'
            ValueUnchecked = 'F'
          end
          object chkMostrarMenuLogin: TDBCheckBox
            Left = 12
            Top = 159
            Width = 139
            Height = 17
            Caption = 'Login/Logout'
            DataField = 'MOSTRAR_MENU_LOGIN_LOGOUT'
            DataSource = dtsConfig
            TabOrder = 7
            ValueChecked = 'T'
            ValueUnchecked = 'F'
          end
          object chkMostrarMenuAlteraSenha: TDBCheckBox
            Left = 12
            Top = 180
            Width = 139
            Height = 17
            Caption = 'Altera Senha'
            DataField = 'MOSTRAR_MENU_ALTERA_SENHA'
            DataSource = dtsConfig
            TabOrder = 8
            ValueChecked = 'T'
            ValueUnchecked = 'F'
          end
          object chkMostrarMenuSeguirAtendimento: TDBCheckBox
            Left = 12
            Top = 201
            Width = 139
            Height = 17
            Caption = 'Seguir Atendimento'
            DataField = 'MOSTRAR_MENU_SEGUIRATENDIMENTO'
            DataSource = dtsConfig
            TabOrder = 9
            ValueChecked = 'T'
            ValueUnchecked = 'F'
          end
        end
      end
      inherited grpOutrasConfig: TGroupBox
        Left = 341
        Top = 420
        Width = 193
        Height = 149
        Anchors = [akRight, akBottom]
        TabOrder = 2
        ExplicitLeft = 341
        ExplicitTop = 420
        ExplicitWidth = 193
        ExplicitHeight = 149
        object chkPodeFecharPrograma: TDBCheckBox
          Left = 8
          Top = 36
          Width = 150
          Height = 17
          Caption = 'Pode Fechar Programa'
          DataField = 'PODE_FECHAR_PROGRAMA'
          DataSource = dtsConfig
          TabOrder = 1
          ValueChecked = 'T'
          ValueUnchecked = 'F'
        end
        object chkTagsObrigatorias: TDBCheckBox
          Left = 8
          Top = 18
          Width = 150
          Height = 17
          Caption = 'Tags Obrigat'#243'rias'
          DataField = 'TAGS_OBRIGATORIAS'
          DataSource = dtsConfig
          TabOrder = 0
          ValueChecked = 'T'
          ValueUnchecked = 'F'
        end
        object DBCheckBox1: TDBCheckBox
          Left = 8
          Top = 55
          Width = 153
          Height = 17
          Caption = 'Minimizar Para Bandeja'
          DataField = 'MINIMIZAR_PARA_BANDEJA'
          DataSource = dtsConfig
          TabOrder = 2
          ValueChecked = 'T'
          ValueUnchecked = 'F'
        end
        object DBCheckBox2: TDBCheckBox
          Left = 8
          Top = 74
          Width = 175
          Height = 17
          Caption = 'Visualizar agendamentos'
          DataField = 'VISUALIZAR_AGENDAMENTOS'
          DataSource = dtsConfig
          TabOrder = 3
          ValueChecked = 'T'
          ValueUnchecked = 'F'
        end
        object dbchkCONECTAR_VIA_DB: TDBCheckBox
          Left = 8
          Top = 93
          Width = 175
          Height = 17
          Caption = 'Conectar Via DB'
          DataField = 'CONECTAR_VIA_DB'
          DataSource = dtsConfig
          TabOrder = 4
          ValueChecked = 'T'
          ValueUnchecked = 'F'
        end
        object DBCheckBox3: TDBCheckBox
          Left = 8
          Top = 112
          Width = 175
          Height = 17
          Caption = 'Visualizar Pessoas nas Filas'
          DataField = 'VISUALIZA_PESSOAS_FILAS'
          DataSource = dtsConfig
          TabOrder = 5
          ValueChecked = 'T'
          ValueUnchecked = 'F'
        end
        object DBCheckBox5: TDBCheckBox
          Left = 8
          Top = 129
          Width = 175
          Height = 17
          Caption = 'Permite Finalizar'
          DataField = 'PERMITEFINALIZAR'
          DataSource = dtsConfig
          TabOrder = 6
          ValueChecked = 'T'
          ValueUnchecked = 'F'
        end
      end
      object grpConfirmacoes: TGroupBox
        Left = 187
        Top = 420
        Width = 145
        Height = 149
        Anchors = [akRight, akBottom]
        Caption = ' Confirma'#231#245'es '
        TabOrder = 1
        object chkConfirmarProximo: TDBCheckBox
          Left = 11
          Top = 20
          Width = 120
          Height = 17
          Caption = 'Pr'#243'ximo'
          DataField = 'CONFIRMAR_PROXIMO'
          DataSource = dtsConfig
          TabOrder = 0
          ValueChecked = 'T'
          ValueUnchecked = 'F'
        end
        object chkConfirmarEncaminha: TDBCheckBox
          Left = 11
          Top = 42
          Width = 120
          Height = 17
          Caption = 'Encaminha'
          DataField = 'CONFIRMAR_ENCAMINHA'
          DataSource = dtsConfig
          TabOrder = 1
          ValueChecked = 'T'
          ValueUnchecked = 'F'
        end
        object chkConfirmarFinaliza: TDBCheckBox
          Left = 11
          Top = 64
          Width = 120
          Height = 17
          Caption = 'Finaliza'
          DataField = 'CONFIRMAR_FINALIZA'
          DataSource = dtsConfig
          TabOrder = 2
          ValueChecked = 'T'
          ValueUnchecked = 'F'
        end
        object chkConfirmarSenhaOutraFila: TDBCheckBox
          Left = 11
          Top = 87
          Width = 120
          Height = 17
          Caption = 'Senha Outra Fila'
          DataField = 'CONFIRMAR_SENHA_OUTRA_FILA'
          DataSource = dtsConfig
          TabOrder = 3
          ValueChecked = 'T'
          ValueUnchecked = 'F'
        end
      end
      object grpCodigoBarras: TGroupBox
        Left = 5
        Top = 420
        Width = 177
        Height = 149
        Anchors = [akRight, akBottom]
        Caption = ' Leitor de c'#243'digo de barras '
        TabOrder = 0
        object lblPortaLCDB: TLabel
          Left = 11
          Top = 49
          Width = 66
          Height = 13
          Caption = 'Porta LCDB'
          FocusControl = edtPortaLCDB
        end
        object chkUtilizarLeitorCodigoBarras: TDBCheckBox
          Left = 11
          Top = 26
          Width = 150
          Height = 17
          Caption = 'Utilizar'
          DataField = 'USE_CODE_BAR'
          DataSource = dtsConfig
          TabOrder = 0
          ValueChecked = 'T'
          ValueUnchecked = 'F'
          OnClick = chkUtilizarLeitorCodigoBarrasClick
        end
        object edtPortaLCDB: TDBEdit
          Left = 11
          Top = 65
          Width = 138
          Height = 21
          DataField = 'PORTA_LCDB'
          DataSource = dtsConfig
          TabOrder = 1
        end
      end
      object ScrollBox1: TScrollBox
        Left = 9
        Top = 23
        Width = 515
        Height = 391
        Anchors = [akLeft, akTop, akRight, akBottom]
        Color = 14803425
        ParentColor = False
        TabOrder = 4
        DesignSize = (
          494
          387)
        object lblAtendentesPermitidos: TLabel
          Left = 11
          Top = 113
          Width = 191
          Height = 13
          Caption = 'Grupos de Atendentes Permitidos'
          FocusControl = edtGruposAtendentesPermitidos
        end
        object lblGruposTagsPermitidos: TLabel
          Left = 11
          Top = 152
          Width = 153
          Height = 13
          Caption = 'Grupos de Tags Permitidos'
          FocusControl = edtGruposTagsPermitidos
        end
        object lblGruposProcessosParalelosPermitidos: TLabel
          Left = 11
          Top = 417
          Width = 234
          Height = 13
          Caption = 'Grupo de Processos Paralelos Permitidos'
          FocusControl = edtGruposProcessosParalelosPermitidos
        end
        object lblFilasPermitidas: TLabel
          Left = 11
          Top = 361
          Width = 89
          Height = 13
          Caption = 'Filas Permitidas'
          FocusControl = edtFilasPermitidas
        end
        object lblSegundosRechamar: TLabel
          Left = 395
          Top = 18
          Width = 88
          Height = 13
          Anchors = [akTop, akRight]
          Caption = 'Seg. Rechamar'
          ExplicitLeft = 412
        end
        object lblID_PA: TLabel
          Left = 11
          Top = 18
          Width = 33
          Height = 13
          Caption = 'ID PA'
        end
        object Label2: TLabel
          Left = 59
          Top = 17
          Width = 52
          Height = 13
          Caption = 'Nome PA'
        end
        object lblPAsPermitidas: TLabel
          Left = 11
          Top = 77
          Width = 85
          Height = 13
          Caption = 'PAs Permitidas'
          Enabled = False
          FocusControl = edtPAsPermitidas
        end
        object lblGruposPausasPermitidos: TLabel
          Left = 11
          Top = 306
          Width = 232
          Height = 13
          Caption = 'Grupos de Motivos de Pausas Permitidos'
          FocusControl = edtGruposPausasPermitidos
        end
        object GruposdeAcessoControleRemoto: TLabel
          Left = 12
          Top = 473
          Width = 204
          Height = 13
          Caption = 'Grupos de Acesso Controle Remoto'
          FocusControl = edtGruposAtendentesPermitidosCR
        end
        object lblCodigosUnidades: TLabel
          Left = 121
          Top = 510
          Width = 102
          Height = 13
          Caption = 'C'#243'digos Unidades'
          FocusControl = edtCodigosUnidades
        end
        object lblIdUnidadeCliente: TLabel
          Left = 9
          Top = 510
          Width = 106
          Height = 13
          Caption = 'Id Unidade Cliente'
          FocusControl = edtIdUnidadeCliente
        end
        object lblFilaEsperaProfissional: TLabel
          Left = 352
          Top = 510
          Width = 131
          Height = 13
          Anchors = [akTop, akRight]
          Caption = 'Fila Espera Profissional'
          FocusControl = edtFilaEsperaProfissional
          ExplicitLeft = 369
        end
        object lblTagAutomatica: TLabel
          Left = 9
          Top = 571
          Width = 109
          Height = 13
          Caption = 'ID TAG Autom'#225'tica'
          FocusControl = edtTagAutomatica
        end
        object lblGruposTagsLayoutBotao: TLabel
          Left = 11
          Top = 190
          Width = 224
          Height = 13
          Caption = 'Grupo de TAGs Visualizar Layout Bot'#227'o'
          FocusControl = edtGruposTagsLayoutBotao
        end
        object lblGruposTagsLayoutLista: TLabel
          Left = 11
          Top = 228
          Width = 217
          Height = 13
          Caption = 'Grupo de TAGs Visualizar Layout Lista'
          FocusControl = edtGruposTagsLayoutLista
        end
        object lblGruposTagsSomenteLeitura: TLabel
          Left = 11
          Top = 266
          Width = 184
          Height = 13
          Caption = 'Grupo de TAGs Somente Leitura'
          FocusControl = edtGruposTagsSomenteLeitura
        end
        object edtGruposAtendentesPermitidos: TDBEdit
          Left = 11
          Top = 129
          Width = 437
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          DataField = 'GRUPOS_ATENDENTES_PERMITIDOS'
          DataSource = dtsConfig
          TabOrder = 0
          OnExit = edtPAsPermitidasExit
          OnKeyPress = edtPAsPermitidasKeyPress
        end
        object edtGruposTagsPermitidos: TDBEdit
          Left = 11
          Top = 168
          Width = 437
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          DataField = 'GRUPOS_DE_TAGS_PERMITIDOS'
          DataSource = dtsConfig
          TabOrder = 1
          OnExit = edtPAsPermitidasExit
          OnKeyPress = edtPAsPermitidasKeyPress
        end
        object edtGruposProcessosParalelosPermitidos: TDBEdit
          Left = 11
          Top = 433
          Width = 437
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          DataField = 'GRUPOS_DE_PPS_PERMITIDOS'
          DataSource = dtsConfig
          TabOrder = 2
          OnExit = edtPAsPermitidasExit
          OnKeyPress = edtPAsPermitidasKeyPress
        end
        object edtFilasPermitidas: TDBEdit
          Left = 11
          Top = 377
          Width = 437
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          DataField = 'FILAS_PERMITIDAS'
          DataSource = dtsConfig
          TabOrder = 3
          OnExit = edtPAsPermitidasExit
          OnKeyPress = edtPAsPermitidasKeyPress
        end
        object chkVisualizarProcessosParalelos: TDBCheckBox
          Left = 11
          Top = 400
          Width = 193
          Height = 17
          Caption = 'Visualizar Processos Paralelos'
          DataField = 'VISUALIZAR_PROCESSOS_PARALELOS'
          DataSource = dtsConfig
          TabOrder = 4
          ValueChecked = 'T'
          ValueUnchecked = 'F'
          OnClick = chkVisualizarProcessosParalelosClick
        end
        object chkManualRedirect: TDBCheckBox
          Left = 10
          Top = 344
          Width = 193
          Height = 17
          Caption = 'Manual Redirect'
          DataField = 'MANUAL_REDIRECT'
          DataSource = dtsConfig
          TabOrder = 5
          ValueChecked = 'T'
          ValueUnchecked = 'F'
          OnClick = chkManualRedirectClick
        end
        object edtSegundosRechamar: TDBEdit
          Left = 394
          Top = 34
          Width = 89
          Height = 21
          Anchors = [akTop, akRight]
          DataField = 'SECS_ON_RECALL'
          DataSource = dtsConfig
          TabOrder = 6
        end
        object edtID_PA: TDBEdit
          Left = 11
          Top = 34
          Width = 38
          Height = 21
          DataField = 'ID_PA'
          DataSource = dtsConfig
          TabOrder = 7
          OnChange = edtID_PAChange
        end
        object btnGruposAtendentesPermitidos: TButton
          Left = 456
          Top = 129
          Width = 25
          Height = 21
          Anchors = [akTop, akRight]
          Caption = '...'
          TabOrder = 8
          OnClick = btnGruposAtendentesPermitidosClick
        end
        object btnGruposTagsPermitidos: TButton
          Left = 456
          Top = 168
          Width = 25
          Height = 21
          Anchors = [akTop, akRight]
          Caption = '...'
          TabOrder = 9
          OnClick = btnGruposTagsPermitidosClick
        end
        object btnFilasPermitidas: TButton
          Left = 456
          Top = 377
          Width = 25
          Height = 21
          Anchors = [akTop, akRight]
          Caption = '...'
          TabOrder = 10
          OnClick = btnFilasPermitidasClick
        end
        object btnGruposProcessosParalelosPermitidos: TButton
          Left = 456
          Top = 431
          Width = 25
          Height = 21
          Anchors = [akTop, akRight]
          Caption = '...'
          TabOrder = 11
          OnClick = btnGruposProcessosParalelosPermitidosClick
        end
        object cboNomePA: TDBLookupComboBox
          Left = 55
          Top = 34
          Width = 142
          Height = 21
          KeyField = 'ID'
          ListField = 'NOME'
          ListSource = dscNomePA
          TabOrder = 12
          OnClick = cboNomePAClick
        end
        object edtPAsPermitidas: TDBEdit
          Left = 12
          Top = 93
          Width = 436
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          DataField = 'PAS_PERMITIDAS'
          DataSource = dtsConfig
          Enabled = False
          TabOrder = 13
          OnExit = edtPAsPermitidasExit
          OnKeyPress = edtPAsPermitidasKeyPress
        end
        object btnPasPermitidas: TButton
          Left = 456
          Top = 93
          Width = 25
          Height = 21
          Anchors = [akTop, akRight]
          Caption = '...'
          Enabled = False
          TabOrder = 14
          OnClick = btnPasPermitidasClick
        end
        object edtGruposPausasPermitidos: TDBEdit
          Left = 11
          Top = 321
          Width = 437
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          DataField = 'GRUPOS_DE_PAUSAS_PERMITIDOS'
          DataSource = dtsConfig
          TabOrder = 15
          OnExit = edtPAsPermitidasExit
          OnKeyPress = edtPAsPermitidasKeyPress
        end
        object btnGruposPausasPermitidos: TButton
          Left = 456
          Top = 321
          Width = 25
          Height = 21
          Anchors = [akTop, akRight]
          Caption = '...'
          TabOrder = 16
          OnClick = btnGruposPausasPermitidosClick
        end
        object chkModoTerminalServer: TDBCheckBox
          Left = 11
          Top = 61
          Width = 150
          Height = 17
          Caption = 'Modo Terminal Server'
          DataField = 'MODO_TERMINAL_SERVER'
          DataSource = dtsConfig
          TabOrder = 17
          ValueChecked = 'T'
          ValueUnchecked = 'F'
          OnClick = chkModoTerminalServerClick
        end
        object edtGruposAtendentesPermitidosCR: TDBEdit
          Left = 13
          Top = 490
          Width = 435
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          DataField = 'GRUPOS_CONTROLE_REMOTO'
          DataSource = dtsConfig
          TabOrder = 18
          OnExit = edtPAsPermitidasExit
          OnKeyPress = edtPAsPermitidasKeyPress
        end
        object btnGruposAtendentesPermitidosCR: TButton
          Left = 456
          Top = 490
          Width = 25
          Height = 21
          Anchors = [akTop, akRight]
          Caption = '...'
          TabOrder = 19
          OnClick = btnGruposAtendentesPermitidosCRClick
        end
        object chkHabilitaControleRemoto: TDBCheckBox
          Left = 12
          Top = 455
          Width = 213
          Height = 17
          Caption = 'Habilitar Controle Remoto de TV'
          DataField = 'MOSTRAR_CONTROLE_REMOTO'
          DataSource = dtsConfig
          TabOrder = 20
          ValueChecked = 'T'
          ValueUnchecked = 'F'
        end
        object edtCodigosUnidades: TDBEdit
          Left = 121
          Top = 528
          Width = 223
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          DataField = 'CODIGOS_UNIDADES'
          DataSource = dtsConfig
          TabOrder = 21
        end
        object edtIdUnidadeCliente: TDBEdit
          Left = 9
          Top = 529
          Width = 89
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          DataField = 'ID_UNIDADE_CLI'
          DataSource = dtsConfig
          TabOrder = 22
        end
        object edtFilaEsperaProfissional: TDBEdit
          Left = 350
          Top = 528
          Width = 133
          Height = 21
          Anchors = [akTop, akRight]
          DataField = 'FILA_ESPERA_PROFISSIONAL'
          DataSource = dtsConfig
          TabOrder = 23
        end
        object DBCheckBox4: TDBCheckBox
          Left = 9
          Top = 556
          Width = 193
          Height = 17
          Caption = 'Marca TAG ap'#243's atendimento'
          DataField = 'MARCAR_TAG_APOS_ATENDIMENTO'
          DataSource = dtsConfig
          TabOrder = 24
          ValueChecked = 'T'
          ValueUnchecked = 'F'
        end
        object edtTagAutomatica: TDBEdit
          Left = 9
          Top = 587
          Width = 439
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          DataField = 'ID_TAG_AUTOMATICA'
          DataSource = dtsConfig
          TabOrder = 25
          OnExit = edtPAsPermitidasExit
          OnKeyPress = edtPAsPermitidasKeyPress
        end
        object btnTagAutomatica: TButton
          Left = 456
          Top = 587
          Width = 25
          Height = 21
          Anchors = [akTop, akRight]
          Caption = '...'
          TabOrder = 26
          OnClick = btnTagAutomaticaClick
        end
        object btnGruposTagsLayoutBotao: TButton
          Left = 456
          Top = 206
          Width = 25
          Height = 21
          Anchors = [akTop, akRight]
          Caption = '...'
          TabOrder = 27
          OnClick = btnGruposTagsLayoutBotaoClick
        end
        object edtGruposTagsLayoutBotao: TDBEdit
          Left = 11
          Top = 206
          Width = 437
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          DataField = 'GRUPOS_DE_TAGS_LAYOUT_BOTAO'
          DataSource = dtsConfig
          TabOrder = 28
          OnExit = edtGruposTagsLayoutBotaoExit
          OnKeyPress = edtGruposTagsLayoutBotaoKeyPress
        end
        object edtGruposTagsLayoutLista: TDBEdit
          Left = 11
          Top = 244
          Width = 437
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          DataField = 'GRUPOS_DE_TAGS_LAYOUT_LISTA'
          DataSource = dtsConfig
          TabOrder = 29
          OnExit = edtGruposTagsLayoutListaExit
          OnKeyPress = edtGruposTagsLayoutListaKeyPress
        end
        object btnGruposTagsLayoutLista: TButton
          Left = 456
          Top = 244
          Width = 25
          Height = 21
          Anchors = [akTop, akRight]
          Caption = '...'
          TabOrder = 30
          OnClick = btnGruposTagsLayoutListaClick
        end
        object edtGruposTagsSomenteLeitura: TDBEdit
          Left = 11
          Top = 282
          Width = 437
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          DataField = 'GRUPOS_DE_TAGS_SOMENTE_LEITURA'
          DataSource = dtsConfig
          TabOrder = 31
          OnExit = edtGruposTagsSomenteLeituraExit
          OnKeyPress = edtGruposTagsSomenteLeituraKeyPress
        end
        object btnGruposTagsSomenteLeitura: TButton
          Left = 456
          Top = 280
          Width = 25
          Height = 21
          Anchors = [akTop, akRight]
          Caption = '...'
          TabOrder = 32
          OnClick = btnGruposTagsSomenteLeituraClick
        end
      end
    end
    inherited pnlButtonSicsPA: TPanel
      Top = 575
      Width = 938
      ExplicitTop = 575
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
      Height = 573
      ExplicitHeight = 573
      inherited btnSicsIncluir: TBitBtn
        Top = 446
        ExplicitTop = 446
      end
      inherited btnSicsExcluir: TBitBtn
        Top = 446
        ExplicitTop = 446
      end
      inherited btnCopiar: TBitBtn
        Top = 446
        ExplicitTop = 446
      end
      inherited grpGrid: TGroupBox
        Height = 418
        ExplicitHeight = 418
        inherited grdModulos: TDBGrid
          Height = 331
          OnCellClick = grdModulosCellClick
        end
        inherited pnlNovaConfig: TPanel
          Top = 346
          ExplicitTop = 346
        end
      end
    end
  end
  object qryNomePA: TFDQuery
    Connection = dmSicsMain.connOnLine
    SQL.Strings = (
      
        'SELECT ID, NOME FROM PAS WHERE ATIVO = '#39'T'#39' AND ID_UNIDADE = :ID_' +
        'UNIDADE')
    Left = 16
    Top = 424
    ParamData = <
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object cdsNomePA: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspNomePA'
    Left = 80
    Top = 424
    object cdsNomePAID: TIntegerField
      FieldName = 'ID'
      Required = True
    end
    object cdsNomePANOME: TStringField
      FieldName = 'NOME'
      Size = 30
    end
  end
  object dspNomePA: TDataSetProvider
    DataSet = qryNomePA
    Left = 144
    Top = 424
  end
  object dscNomePA: TDataSource
    DataSet = cdsNomePA
    Left = 176
    Top = 424
  end
end
