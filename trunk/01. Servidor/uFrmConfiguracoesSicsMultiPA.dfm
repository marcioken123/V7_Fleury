inherited FrmConfiguracoesSicsMultiPA: TFrmConfiguracoesSicsMultiPA
  Left = 1842
  Top = 287
  ActiveControl = nil
  Caption = 'Configura'#231#245'es Sics MultiPA'
  ClientHeight = 644
  ClientWidth = 942
  Constraints.MinHeight = 683
  ExplicitWidth = 958
  ExplicitHeight = 683
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlFundo: TPanel
    Width = 942
    Height = 644
    ExplicitWidth = 942
    ExplicitHeight = 784
    inherited grpConfiguracoes: TGroupBox
      Width = 737
      Height = 590
      ExplicitWidth = 737
      ExplicitHeight = 730
      inherited grpConfigTela: TGroupBox
        Left = 528
        Width = 201
        Height = 559
        TabOrder = 3
        ExplicitLeft = 528
        ExplicitWidth = 201
        ExplicitHeight = 699
        object chkMostrarNomeCliente: TDBCheckBox
          Left = 8
          Top = 19
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
          Top = 105
          Width = 175
          Height = 225
          Caption = 'Bot'#245'es vis'#237'veis'
          TabOrder = 3
          object chkMostrarBotaoProcessos: TDBCheckBox
            Left = 12
            Top = 137
            Width = 142
            Height = 17
            Caption = 'Processos paralelos'
            DataField = 'MOSTRAR_BOTAO_PROCESSOS'
            DataSource = dtsConfig
            TabOrder = 6
            ValueChecked = 'T'
            ValueUnchecked = 'F'
          end
          object chkMostrarBotaoPausa: TDBCheckBox
            Left = 12
            Top = 117
            Width = 142
            Height = 17
            Caption = 'Pausa'
            DataField = 'MOSTRAR_BOTAO_PAUSA'
            DataSource = dtsConfig
            TabOrder = 5
            ValueChecked = 'T'
            ValueUnchecked = 'F'
          end
          object chkMostrarBotaoEspecifica: TDBCheckBox
            Left = 12
            Top = 57
            Width = 142
            Height = 17
            Caption = 'Espec'#237'fica'
            DataField = 'MOSTRAR_BOTAO_ESPECIFICA'
            DataSource = dtsConfig
            TabOrder = 2
            ValueChecked = 'T'
            ValueUnchecked = 'F'
          end
          object chkMostrarBotaoFinaliza: TDBCheckBox
            Left = 12
            Top = 97
            Width = 142
            Height = 17
            Caption = 'Finaliza'
            DataField = 'MOSTRAR_BOTAO_FINALIZA'
            DataSource = dtsConfig
            TabOrder = 4
            ValueChecked = 'T'
            ValueUnchecked = 'F'
          end
          object chkMostrarBotaoEncaminha: TDBCheckBox
            Left = 12
            Top = 77
            Width = 142
            Height = 17
            Caption = 'Encaminha'
            DataField = 'MOSTRAR_BOTAO_ENCAMINHA'
            DataSource = dtsConfig
            TabOrder = 3
            ValueChecked = 'T'
            ValueUnchecked = 'F'
          end
          object chkMostrarBotaoRechama: TDBCheckBox
            Left = 12
            Top = 37
            Width = 142
            Height = 17
            Caption = 'Rechama'
            DataField = 'MOSTRAR_BOTAO_RECHAMA'
            DataSource = dtsConfig
            TabOrder = 1
            ValueChecked = 'T'
            ValueUnchecked = 'F'
          end
          object chkMostrarBotaoProximo: TDBCheckBox
            Left = 12
            Top = 18
            Width = 142
            Height = 17
            Caption = 'Pr'#243'ximo'
            DataField = 'MOSTRAR_BOTAO_PROXIMO'
            DataSource = dtsConfig
            TabOrder = 0
            ValueChecked = 'T'
            ValueUnchecked = 'F'
          end
          object chkMostrarBotaoLogin: TDBCheckBox
            Left = 12
            Top = 157
            Width = 142
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
          Top = 331
          Width = 175
          Height = 221
          Caption = 'Menus vis'#237'veis'
          TabOrder = 4
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
          object chkMostrarMenuProximo: TDBCheckBox
            Left = 12
            Top = 18
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
          object chkMostrarMenuProcessos: TDBCheckBox
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
        object DBCheckBox3: TDBCheckBox
          Left = 8
          Top = 82
          Width = 180
          Height = 17
          Caption = 'Mostrar Painel de Grupos'
          DataField = 'MOSTRAR_PAINEL_GRUPOS'
          DataSource = dtsConfig
          TabOrder = 5
          ValueChecked = 'T'
          ValueUnchecked = 'F'
        end
      end
      inherited grpOutrasConfig: TGroupBox
        Left = 336
        Top = 455
        Width = 181
        Height = 127
        Anchors = [akRight, akBottom]
        TabOrder = 2
        ExplicitLeft = 336
        ExplicitTop = 455
        ExplicitWidth = 181
        ExplicitHeight = 127
        object chkPodeFecharPrograma: TDBCheckBox
          Left = 8
          Top = 33
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
          Top = 15
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
          Top = 51
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
          Top = 69
          Width = 169
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
          Top = 87
          Width = 168
          Height = 17
          Caption = 'Conectar Via DB'
          DataField = 'CONECTAR_VIA_DB'
          DataSource = dtsConfig
          TabOrder = 4
          ValueChecked = 'T'
          ValueUnchecked = 'F'
        end
        object DBCheckBox5: TDBCheckBox
          Left = 10
          Top = 107
          Width = 168
          Height = 17
          Caption = 'Permite Finalizar'
          DataField = 'PERMITEFINALIZAR'
          DataSource = dtsConfig
          TabOrder = 5
          ValueChecked = 'T'
          ValueUnchecked = 'F'
        end
      end
      object grpCodigoBarras: TGroupBox
        Left = 12
        Top = 455
        Width = 171
        Height = 127
        Anchors = [akLeft, akRight, akBottom]
        Caption = ' Leitor de c'#243'digo de barras '
        TabOrder = 0
        object lblPortaLCDB: TLabel
          Left = 18
          Top = 51
          Width = 66
          Height = 13
          Caption = 'Porta LCDB'
          FocusControl = edtPortaLCDB
        end
        object chkUtilizarLeitorCodigoBarras: TDBCheckBox
          Left = 18
          Top = 28
          Width = 100
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
          Left = 18
          Top = 67
          Width = 138
          Height = 21
          DataField = 'PORTA_LCDB'
          DataSource = dtsConfig
          TabOrder = 1
        end
      end
      object grpConfirmacoes: TGroupBox
        Left = 189
        Top = 455
        Width = 144
        Height = 126
        Anchors = [akRight, akBottom]
        Caption = ' Confirma'#231#245'es '
        TabOrder = 1
        object chkConfirmarProximo: TDBCheckBox
          Left = 11
          Top = 19
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
          Top = 39
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
          Top = 60
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
          Top = 81
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
      object ScrollBox1: TScrollBox
        Left = 9
        Top = 23
        Width = 508
        Height = 426
        Anchors = [akLeft, akTop, akRight, akBottom]
        Color = 14737632
        ParentColor = False
        TabOrder = 4
        DesignSize = (
          487
          422)
        object lblGruposTagsSomenteLeitura: TLabel
          Left = 22
          Top = 259
          Width = 184
          Height = 13
          Caption = 'Grupo de TAGs Somente Leitura'
          FocusControl = edtGruposTagsSomenteLeitura
        end
        object lblGruposTagsLayoutLista: TLabel
          Left = 20
          Top = 219
          Width = 217
          Height = 13
          Caption = 'Grupo de TAGs Visualizar Layout Lista'
          FocusControl = edtGruposTagsLayoutLista
        end
        object lblGruposTagsLayoutBotao: TLabel
          Left = 20
          Top = 179
          Width = 224
          Height = 13
          Caption = 'Grupo de TAGs Visualizar Layout Bot'#227'o'
          FocusControl = edtGruposTagsLayoutBotao
        end
        object lblTagAutomatica: TLabel
          Left = 19
          Top = 519
          Width = 109
          Height = 13
          Caption = 'ID TAG Autom'#225'tica'
          FocusControl = edtTagAutomatica
        end
        object lblFilaEsperaProfissional: TLabel
          Left = 347
          Top = 459
          Width = 131
          Height = 13
          Caption = 'Fila Espera Profissional'
          FocusControl = edtFilaEsperaProfissional
        end
        object lblIdUnidadeCliente: TLabel
          Left = 19
          Top = 463
          Width = 106
          Height = 13
          Caption = 'Id Unidade Cliente'
          FocusControl = edtIdUnidadeCliente
        end
        object lblCodigosUnidades: TLabel
          Left = 131
          Top = 459
          Width = 102
          Height = 13
          Caption = 'C'#243'digos Unidades'
          FocusControl = edtCodigosUnidades
        end
        object lblSegundosRechamar: TLabel
          Left = 373
          Top = 17
          Width = 88
          Height = 13
          Anchors = [akTop, akRight]
          Caption = 'Seg. Rechamar'
          FocusControl = edtSegundosRechamar
          ExplicitLeft = 390
        end
        object Label3: TLabel
          Left = 278
          Top = 17
          Width = 65
          Height = 13
          Anchors = [akTop, akRight]
          Caption = 'Colunas PA'
          FocusControl = edtColunasPA
          ExplicitLeft = 295
        end
        object Label1: TLabel
          Left = 160
          Top = 17
          Width = 100
          Height = 13
          Anchors = [akTop, akRight]
          Caption = 'Tempo Limpar PA'
          FocusControl = edtTempoLimparPA
          ExplicitLeft = 177
        end
        object lblGruposPausasPermitidos: TLabel
          Left = 20
          Top = 305
          Width = 232
          Height = 13
          Caption = 'Grupos de Motivos de Pausas Permitidos'
          FocusControl = edtGruposPausasPermitidos
        end
        object lblPAsPermitidas: TLabel
          Left = 20
          Top = 59
          Width = 85
          Height = 13
          Caption = 'PAs Permitidas'
          FocusControl = edtPAsPermitidas
        end
        object lblFilasPermitidas: TLabel
          Left = 19
          Top = 365
          Width = 89
          Height = 13
          Caption = 'Filas Permitidas'
          FocusControl = edtFilasPermitidas
        end
        object lblGruposProcessosParalelosPermitidos: TLabel
          Left = 19
          Top = 423
          Width = 234
          Height = 13
          Caption = 'Grupo de Processos Paralelos Permitidos'
          FocusControl = edtGruposProcessosParalelosPermitidos
        end
        object lblGrupoTagsPermitidas: TLabel
          Left = 20
          Top = 139
          Width = 147
          Height = 13
          Caption = 'Grupo de Tags Permitidos'
          FocusControl = edtGrupoTagsPermitidas
        end
        object lblGrupoAtendentesPermitidos: TLabel
          Left = 20
          Top = 99
          Width = 185
          Height = 13
          Caption = 'Grupo de Atendentes Permitidos'
          FocusControl = edtGrupoAtendentesPermitidos
        end
        object edtGruposTagsSomenteLeitura: TDBEdit
          Left = 19
          Top = 278
          Width = 421
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          DataField = 'GRUPOS_DE_TAGS_SOMENTE_LEITURA'
          DataSource = dtsConfig
          TabOrder = 0
          OnExit = edtGruposTagsSomenteLeituraExit
          OnKeyPress = edtGruposTagsSomenteLeituraKeyPress
          ExplicitWidth = 438
        end
        object btnGruposTagsLayoutBotao: TButton
          Left = 446
          Top = 198
          Width = 25
          Height = 21
          Anchors = [akTop, akRight]
          Caption = '...'
          TabOrder = 1
          OnClick = btnGruposTagsLayoutBotaoClick
          ExplicitLeft = 463
        end
        object btnGruposTagsLayoutLista: TButton
          Left = 448
          Top = 238
          Width = 25
          Height = 21
          Anchors = [akTop, akRight]
          Caption = '...'
          TabOrder = 2
          OnClick = btnGruposTagsLayoutListaClick
          ExplicitLeft = 465
        end
        object btnGruposTagsSomenteLeitura: TButton
          Left = 448
          Top = 278
          Width = 25
          Height = 21
          Anchors = [akTop, akRight]
          Caption = '...'
          TabOrder = 3
          OnClick = btnGruposTagsSomenteLeituraClick
          ExplicitLeft = 465
        end
        object edtGruposTagsLayoutLista: TDBEdit
          Left = 19
          Top = 238
          Width = 421
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          DataField = 'GRUPOS_DE_TAGS_LAYOUT_LISTA'
          DataSource = dtsConfig
          TabOrder = 4
          OnExit = edtGruposTagsLayoutListaExit
          OnKeyPress = edtGruposTagsLayoutListaKeyPress
          ExplicitWidth = 438
        end
        object edtGruposTagsLayoutBotao: TDBEdit
          Left = 19
          Top = 198
          Width = 421
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          DataField = 'GRUPOS_DE_TAGS_LAYOUT_BOTAO'
          DataSource = dtsConfig
          TabOrder = 5
          OnExit = edtGruposTagsLayoutBotaoExit
          OnKeyPress = edtGruposTagsLayoutBotaoKeyPress
          ExplicitWidth = 438
        end
        object btnTagAutomatica: TButton
          Left = 446
          Top = 538
          Width = 25
          Height = 21
          Anchors = [akTop, akRight]
          Caption = '...'
          TabOrder = 6
          OnClick = btnTagAutomaticaClick
          ExplicitLeft = 463
        end
        object edtTagAutomatica: TDBEdit
          Left = 19
          Top = 538
          Width = 421
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          DataField = 'ID_TAG_AUTOMATICA'
          DataSource = dtsConfig
          TabOrder = 7
          OnExit = edtPAsPermitidasExit
          OnKeyPress = edtPAsPermitidasKeyPress
          ExplicitWidth = 438
        end
        object DBCheckBox4: TDBCheckBox
          Left = 19
          Top = 503
          Width = 193
          Height = 17
          Caption = 'Marca TAG ap'#243's atendimento'
          DataField = 'VISUALIZAR_PROCESSOS_PARALELOS'
          DataSource = dtsConfig
          TabOrder = 8
          ValueChecked = 'T'
          ValueUnchecked = 'F'
          OnClick = chkVisualizarProcessosParalelosClick
        end
        object edtFilaEsperaProfissional: TDBEdit
          Left = 347
          Top = 478
          Width = 125
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          DataField = 'FILA_ESPERA_PROFISSIONAL'
          DataSource = dtsConfig
          TabOrder = 9
          ExplicitWidth = 142
        end
        object edtIdUnidadeCliente: TDBEdit
          Left = 19
          Top = 479
          Width = 90
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          DataField = 'ID_UNIDADE_CLI'
          DataSource = dtsConfig
          TabOrder = 10
          ExplicitWidth = 107
        end
        object edtCodigosUnidades: TDBEdit
          Left = 132
          Top = 478
          Width = 192
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          DataField = 'CODIGOS_UNIDADES'
          DataSource = dtsConfig
          TabOrder = 11
          ExplicitWidth = 209
        end
        object btnGruposPausasPermitidos: TButton
          Left = 448
          Top = 324
          Width = 25
          Height = 21
          Anchors = [akTop, akRight]
          Caption = '...'
          TabOrder = 12
          OnClick = btnGruposPausasPermitidosClick
          ExplicitLeft = 465
        end
        object edtGruposPausasPermitidos: TDBEdit
          Left = 21
          Top = 324
          Width = 419
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          DataField = 'GRUPOS_DE_PAUSAS_PERMITIDOS'
          DataSource = dtsConfig
          TabOrder = 13
          OnExit = edtPAsPermitidasExit
          OnKeyPress = edtPAsPermitidasKeyPress
          ExplicitWidth = 436
        end
        object Button1: TButton
          Left = 446
          Top = 78
          Width = 25
          Height = 21
          Anchors = [akTop, akRight]
          Caption = '...'
          TabOrder = 14
          OnClick = Button1Click
          ExplicitLeft = 463
        end
        object edtPAsPermitidas: TDBEdit
          Left = 19
          Top = 78
          Width = 421
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          DataField = 'PAS_PERMITIDAS'
          DataSource = dtsConfig
          TabOrder = 15
          OnExit = edtPAsPermitidasExit
          OnKeyPress = edtPAsPermitidasKeyPress
          ExplicitWidth = 438
        end
        object edtColunasPA: TDBEdit
          Left = 278
          Top = 33
          Width = 89
          Height = 21
          Anchors = [akTop, akRight]
          DataField = 'COLUNAS_PAS'
          DataSource = dtsConfig
          TabOrder = 16
          ExplicitLeft = 295
        end
        object edtTempoLimparPA: TDBEdit
          Left = 160
          Top = 33
          Width = 112
          Height = 21
          Anchors = [akTop, akRight]
          DataField = 'TEMPO_LIMPAR_PA'
          DataSource = dtsConfig
          TabOrder = 17
          ExplicitLeft = 177
        end
        object btnGruposProcessosParalelosPermitidos: TButton
          Left = 448
          Top = 439
          Width = 25
          Height = 21
          Anchors = [akTop, akRight]
          Caption = '...'
          TabOrder = 18
          OnClick = btnGruposProcessosParalelosPermitidosClick
          ExplicitLeft = 465
        end
        object btnFilasPermitidas: TButton
          Left = 448
          Top = 381
          Width = 25
          Height = 21
          Anchors = [akTop, akRight]
          Caption = '...'
          TabOrder = 19
          OnClick = btnFilasPermitidasClick
          ExplicitLeft = 465
        end
        object Button3: TButton
          Left = 446
          Top = 155
          Width = 25
          Height = 21
          Anchors = [akTop, akRight]
          Caption = '...'
          TabOrder = 20
          OnClick = Button3Click
          ExplicitLeft = 463
        end
        object Button2: TButton
          Left = 446
          Top = 118
          Width = 25
          Height = 21
          Anchors = [akTop, akRight]
          Caption = '...'
          TabOrder = 21
          OnClick = Button2Click
          ExplicitLeft = 463
        end
        object edtSegundosRechamar: TDBEdit
          Left = 375
          Top = 33
          Width = 89
          Height = 21
          Anchors = [akTop, akRight]
          DataField = 'SECS_ON_RECALL'
          DataSource = dtsConfig
          TabOrder = 22
          ExplicitLeft = 392
        end
        object chkManualRedirect: TDBCheckBox
          Left = 19
          Top = 349
          Width = 193
          Height = 17
          Caption = 'Manual Redirect'
          DataField = 'MANUAL_REDIRECT'
          DataSource = dtsConfig
          TabOrder = 23
          ValueChecked = 'T'
          ValueUnchecked = 'F'
          OnClick = chkManualRedirectClick
        end
        object chkVisualizarProcessosParalelos: TDBCheckBox
          Left = 19
          Top = 407
          Width = 193
          Height = 17
          Caption = 'Visualizar Processos Paralelos'
          DataField = 'VISUALIZAR_PROCESSOS_PARALELOS'
          DataSource = dtsConfig
          TabOrder = 24
          ValueChecked = 'T'
          ValueUnchecked = 'F'
          OnClick = chkVisualizarProcessosParalelosClick
        end
        object edtFilasPermitidas: TDBEdit
          Left = 19
          Top = 381
          Width = 421
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          DataField = 'FILAS_PERMITIDAS'
          DataSource = dtsConfig
          TabOrder = 25
          OnExit = edtPAsPermitidasExit
          OnKeyPress = edtPAsPermitidasKeyPress
          ExplicitWidth = 438
        end
        object edtGruposProcessosParalelosPermitidos: TDBEdit
          Left = 19
          Top = 439
          Width = 421
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          DataField = 'GRUPOS_DE_PPS_PERMITIDOS'
          DataSource = dtsConfig
          TabOrder = 26
          OnExit = edtPAsPermitidasExit
          OnKeyPress = edtPAsPermitidasKeyPress
          ExplicitWidth = 438
        end
        object edtGrupoTagsPermitidas: TDBEdit
          Left = 19
          Top = 158
          Width = 421
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          DataField = 'GRUPOS_DE_TAGS_PERMITIDOS'
          DataSource = dtsConfig
          TabOrder = 27
          OnExit = edtPAsPermitidasExit
          OnKeyPress = edtPAsPermitidasKeyPress
          ExplicitWidth = 438
        end
        object edtGrupoAtendentesPermitidos: TDBEdit
          Left = 19
          Top = 118
          Width = 421
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          DataField = 'GRUPOS_ATENDENTES_PERMITIDOS'
          DataSource = dtsConfig
          TabOrder = 28
          OnExit = edtPAsPermitidasExit
          OnKeyPress = edtPAsPermitidasKeyPress
          ExplicitWidth = 438
        end
      end
    end
    inherited pnlButtonSicsPA: TPanel
      Top = 592
      Width = 938
      ExplicitTop = 732
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
      Height = 590
      ExplicitHeight = 730
      inherited btnSicsIncluir: TBitBtn
        Top = 497
        ExplicitTop = 637
      end
      inherited btnSicsExcluir: TBitBtn
        Top = 497
        ExplicitTop = 637
      end
      inherited btnCopiar: TBitBtn
        Top = 497
        ExplicitTop = 637
      end
      inherited grpGrid: TGroupBox
        Height = 469
        ExplicitHeight = 609
        inherited grdModulos: TDBGrid
          Height = 382
        end
        inherited pnlNovaConfig: TPanel
          Top = 397
          ExplicitTop = 537
        end
      end
    end
  end
  inherited dtsConfig: TDataSource
    Left = 48
    Top = 224
  end
  inherited CDSConfig: TClientDataSet
    Left = 120
    Top = 224
  end
  inherited dtsModulos: TDataSource
    Left = 48
    Top = 296
  end
  inherited CDSModulos: TClientDataSet
    Left = 120
    Top = 296
  end
end
