inherited FrmConfiguracoesSicsTV: TFrmConfiguracoesSicsTV
  Caption = 'Configura'#231#245'es Sics TV'
  ClientHeight = 626
  ClientWidth = 1052
  OnActivate = FormActivate
  ExplicitWidth = 1068
  ExplicitHeight = 665
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlFundo: TPanel
    Width = 1052
    Height = 626
    ExplicitWidth = 1052
    ExplicitHeight = 626
    inherited grpConfiguracoes: TGroupBox
      Width = 847
      Height = 572
      ExplicitWidth = 847
      ExplicitHeight = 572
      inherited grpConfigTela: TGroupBox
        Left = 646
        Height = 541
        TabOrder = 1
        ExplicitLeft = 646
        ExplicitHeight = 541
        object chkMostrarNomeCliente: TDBCheckBox
          Left = 8
          Top = 18
          Width = 180
          Height = 17
          Caption = 'Chamada Interrompe V'#237'deo'
          DataField = 'CHAMADAINTERROMPEVIDEO'
          DataSource = dtsConfig
          TabOrder = 0
          ValueChecked = 'T'
          ValueUnchecked = 'F'
        end
        object DBCheckBox1: TDBCheckBox
          Left = 8
          Top = 41
          Width = 180
          Height = 17
          Caption = 'Maximizar Monitor 1'
          DataField = 'MAXIMIZARMONITOR1'
          DataSource = dtsConfig
          TabOrder = 1
          ValueChecked = 'T'
          ValueUnchecked = 'F'
        end
        object DBCheckBox2: TDBCheckBox
          Left = 8
          Top = 64
          Width = 180
          Height = 17
          Caption = 'Maximizar Monitor 2'
          DataField = 'MAXIMIZARMONITOR2'
          DataSource = dtsConfig
          TabOrder = 2
          ValueChecked = 'T'
          ValueUnchecked = 'F'
        end
      end
      inherited grpOutrasConfig: TGroupBox
        Left = 645
        Top = 370
        Width = 193
        Height = 193
        Anchors = [akRight, akBottom]
        TabOrder = 0
        ExplicitLeft = 645
        ExplicitTop = 370
        ExplicitWidth = 193
        ExplicitHeight = 193
      end
      object ScrollBox1: TScrollBox
        Left = 16
        Top = 23
        Width = 617
        Height = 540
        Anchors = [akLeft, akTop, akRight, akBottom]
        Color = clBtnFace
        ParentColor = False
        TabOrder = 2
        object Panel1: TPanel
          Left = 0
          Top = 0
          Width = 613
          Height = 121
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          DesignSize = (
            613
            121)
          object lblID_PA: TLabel
            Left = 11
            Top = 12
            Width = 33
            Height = 13
            Caption = 'ID TV'
          end
          object lblGrupoIndicadoresPermitidos: TLabel
            Left = 11
            Top = 60
            Width = 131
            Height = 13
            Caption = 'Indicadores Permitidos'
            FocusControl = edtGrupoIndicadoresPermitidos
          end
          object lblColunasFilas: TLabel
            Left = 159
            Top = 9
            Width = 84
            Height = 13
            Caption = 'Porta IP Painel'
          end
          object Label65: TLabel
            Left = 76
            Top = 12
            Width = 52
            Height = 13
            Caption = 'ID Painel'
          end
          object edtID_PA: TDBEdit
            Left = 11
            Top = 28
            Width = 54
            Height = 21
            DataField = 'IDTV'
            DataSource = dtsConfig
            TabOrder = 0
          end
          object edtGrupoIndicadoresPermitidos: TDBEdit
            Left = 11
            Top = 75
            Width = 226
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            DataField = 'INDICADORESPERMITIDOS'
            DataSource = dtsConfig
            TabOrder = 1
          end
          object btnGrupoIndicadoresPermitidos: TButton
            Left = 243
            Top = 75
            Width = 25
            Height = 21
            Anchors = [akTop, akRight]
            Caption = '...'
            TabOrder = 2
            OnClick = btnGrupoIndicadoresPermitidosClick
          end
          object edtPortaIPPainel: TDBEdit
            Left = 159
            Top = 28
            Width = 103
            Height = 21
            DataField = 'PORTAIPPAINEL'
            DataSource = dtsConfig
            TabOrder = 3
          end
          object DBEdit1: TDBEdit
            Left = 76
            Top = 28
            Width = 66
            Height = 21
            DataField = 'IDPAINEL'
            DataSource = dtsConfig
            TabOrder = 4
          end
          object GroupBox4: TGroupBox
            Left = 325
            Top = 0
            Width = 288
            Height = 121
            Align = alRight
            Caption = 'Hor'#225'rio de Funcionamento'
            TabOrder = 5
            object Label64: TLabel
              Left = 194
              Top = 32
              Width = 5
              Height = 13
              Caption = ':'
            end
            object Label66: TLabel
              Left = 77
              Top = 32
              Width = 5
              Height = 13
              Caption = ':'
            end
            object Label67: TLabel
              Left = 144
              Top = 32
              Width = 24
              Height = 13
              Caption = '&At'#233':'
            end
            object Label68: TLabel
              Left = 27
              Top = 32
              Width = 21
              Height = 13
              Caption = '&De:'
            end
            object chkFuncionaDomingo: TDBCheckBox
              Left = 146
              Top = 77
              Width = 127
              Height = 17
              Caption = 'Funciona do&mingo'
              DataField = 'FUNCIONADOMINGO'
              DataSource = dtsConfig
              TabOrder = 0
              ValueChecked = 'T'
              ValueUnchecked = 'F'
            end
            object edAteM: TDBEdit
              Left = 201
              Top = 28
              Width = 24
              Height = 21
              DataField = 'ATEM'
              DataSource = dtsConfig
              TabOrder = 1
            end
            object edAteH: TDBEdit
              Left = 167
              Top = 28
              Width = 23
              Height = 21
              DataField = 'ATEH'
              DataSource = dtsConfig
              MaxLength = 2
              TabOrder = 2
            end
            object edDeM: TDBEdit
              Left = 84
              Top = 28
              Width = 23
              Height = 21
              DataField = 'DEM'
              DataSource = dtsConfig
              MaxLength = 2
              TabOrder = 3
            end
            object edDeH: TDBEdit
              Left = 50
              Top = 28
              Width = 23
              Height = 21
              DataField = 'DEH'
              DataSource = dtsConfig
              MaxLength = 2
              TabOrder = 4
            end
            object chkFuncionaSabado: TDBCheckBox
              Left = 18
              Top = 77
              Width = 122
              Height = 17
              Caption = 'Funciona &s'#225'bado'
              DataField = 'FUNCIONASABADO'
              DataSource = dtsConfig
              TabOrder = 5
              ValueChecked = 'T'
              ValueUnchecked = 'F'
            end
          end
        end
        object pnlListaPanels: TPanel
          Left = 0
          Top = 121
          Width = 217
          Height = 415
          Align = alLeft
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 1
          object Label26: TLabel
            Left = 2
            Top = 2
            Width = 213
            Height = 16
            Align = alTop
            AutoSize = False
            Caption = 'Quadros'
          end
          object Panel2: TPanel
            Left = 2
            Top = 376
            Width = 213
            Height = 37
            Align = alBottom
            BevelOuter = bvNone
            Ctl3D = False
            ParentCtl3D = False
            TabOrder = 0
            object Button1: TButton
              Left = 8
              Top = 1
              Width = 89
              Height = 32
              Caption = 'Criar Novo'
              DropDownMenu = menuPopup
              Style = bsSplitButton
              TabOrder = 0
            end
            object Button2: TButton
              Left = 112
              Top = 1
              Width = 89
              Height = 32
              Caption = '&Excluir'
              TabOrder = 1
              OnClick = Button2Click
            end
          end
          object DBGrid1: TDBGrid
            Left = 2
            Top = 18
            Width = 213
            Height = 358
            Align = alClient
            DataSource = dscPaineis
            Options = [dgEditing, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
            TabOrder = 1
            TitleFont.Charset = ANSI_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -11
            TitleFont.Name = 'Verdana'
            TitleFont.Style = []
            Columns = <
              item
                Expanded = False
                FieldName = 'ccNOME'
                Visible = True
              end>
          end
        end
        object PageControlConfigs: TPageControl
          Left = 217
          Top = 121
          Width = 396
          Height = 415
          ActivePage = tbsUltimasChamadas
          Align = alClient
          TabOrder = 2
          object tbsGeral: TTabSheet
            Caption = 'Gerais'
            ExplicitLeft = 0
            ExplicitTop = 0
            ExplicitWidth = 0
            ExplicitHeight = 0
            object groupPosicao: TGroupBox
              Left = 0
              Top = 0
              Width = 366
              Height = 60
              Caption = 'Posi'#231#227'o na tela'
              TabOrder = 0
              object Label1: TLabel
                Left = 15
                Top = 29
                Width = 13
                Height = 13
                Caption = 'X:'
              end
              object Label2: TLabel
                Left = 104
                Top = 29
                Width = 11
                Height = 13
                Caption = 'Y:'
              end
              object Label16: TLabel
                Left = 183
                Top = 29
                Width = 34
                Height = 13
                Caption = 'Larg.:'
              end
              object Label17: TLabel
                Left = 285
                Top = 29
                Width = 24
                Height = 13
                Caption = 'Alt.:'
              end
              object edLeft: TDBEdit
                Left = 32
                Top = 25
                Width = 41
                Height = 21
                DataField = 'LEFT'
                DataSource = dscPaineis
                TabOrder = 0
              end
              object edTop: TDBEdit
                Left = 121
                Top = 25
                Width = 41
                Height = 21
                DataField = 'TOP'
                DataSource = dscPaineis
                TabOrder = 1
              end
              object edWidth: TDBEdit
                Left = 217
                Top = 25
                Width = 41
                Height = 21
                DataField = 'WIDTH'
                DataSource = dscPaineis
                TabOrder = 2
              end
              object edHeight: TDBEdit
                Left = 310
                Top = 25
                Width = 41
                Height = 21
                DataField = 'HEIGHT'
                DataSource = dscPaineis
                TabOrder = 3
              end
            end
            object groupBackground: TGroupBox
              Left = 0
              Top = 66
              Width = 366
              Height = 110
              Caption = '&Plano de fundo'
              TabOrder = 1
              object rbBackgroundImage: TRadioButton
                Left = 10
                Top = 17
                Width = 66
                Height = 17
                Caption = 'Imagem:'
                Checked = True
                TabOrder = 0
                TabStop = True
              end
              object rbBackGroundColor: TRadioButton
                Left = 10
                Top = 60
                Width = 66
                Height = 17
                Caption = 'Cor'
                TabOrder = 1
              end
              object cmbBackgroundColor: TJvOfficeColorButton
                Left = 30
                Top = 78
                Width = 50
                Height = 22
                ColorDialogOptions = [cdSolidColor, cdAnyColor]
                TabOrder = 2
                Flat = False
                SelectedColor = clDefault
                HotTrackFont.Charset = DEFAULT_CHARSET
                HotTrackFont.Color = clWindowText
                HotTrackFont.Height = -11
                HotTrackFont.Name = 'MS Sans Serif'
                HotTrackFont.Style = []
                Properties.ShowNoneColor = True
                Properties.ShowDefaultColor = False
                Properties.NoneColorCaption = 'Transparente'
                Properties.DefaultColorCaption = 'Automatic'
                Properties.CustomColorCaption = 'Other Colors...'
                Properties.NoneColorHint = 'Transparente'
                Properties.DefaultColorHint = 'Automatic'
                Properties.CustomColorHint = 'Other Colors...'
                Properties.NoneColorColor = 11259375
                Properties.NoneColorFont.Charset = DEFAULT_CHARSET
                Properties.NoneColorFont.Color = clWindowText
                Properties.NoneColorFont.Height = -11
                Properties.NoneColorFont.Name = 'MS Sans Serif'
                Properties.NoneColorFont.Style = []
                Properties.DefaultColorFont.Charset = DEFAULT_CHARSET
                Properties.DefaultColorFont.Color = clWindowText
                Properties.DefaultColorFont.Height = -11
                Properties.DefaultColorFont.Name = 'MS Sans Serif'
                Properties.DefaultColorFont.Style = []
                Properties.CustomColorFont.Charset = DEFAULT_CHARSET
                Properties.CustomColorFont.Color = clWindowText
                Properties.CustomColorFont.Height = -11
                Properties.CustomColorFont.Name = 'MS Sans Serif'
                Properties.CustomColorFont.Style = []
                Properties.TopMargin = 40
                Properties.FloatWindowCaption = 'Color Window'
                Properties.DragBarHint = 'Drag to float'
              end
              object edBackgroundImage: TDBEdit
                Left = 30
                Top = 35
                Width = 299
                Height = 21
                DataField = 'BACKGROUNDFILE'
                DataSource = dscPaineis
                TabOrder = 3
              end
            end
          end
          object tbsChamadaSenhas: TTabSheet
            Caption = 'Chamadas de senhas'
            ImageIndex = 1
            object pnlChamadaSenhas: TGroupBox
              Left = 0
              Top = 0
              Width = 388
              Height = 387
              Align = alClient
              Caption = '&Chamada de senhas'
              TabOrder = 0
              object groupChamadaDeSenhasFonte: TGroupBox
                Left = 5
                Top = 13
                Width = 366
                Height = 43
                Caption = 'Fonte'
                TabOrder = 0
                object btnChamadaSenhasNegrito: TJvSpeedButton
                  Left = 300
                  Top = 15
                  Width = 20
                  Height = 22
                  AllowAllUp = True
                  Caption = 'N'
                  GroupIndex = 2
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -13
                  Font.Name = 'Times New Roman'
                  Font.Style = [fsBold]
                  HotTrackFont.Charset = DEFAULT_CHARSET
                  HotTrackFont.Color = clWindowText
                  HotTrackFont.Height = -13
                  HotTrackFont.Name = 'Times New Roman'
                  HotTrackFont.Style = []
                  ParentFont = False
                end
                object btnChamadaSenhasItalico: TJvSpeedButton
                  Left = 320
                  Top = 15
                  Width = 20
                  Height = 22
                  AllowAllUp = True
                  Caption = 'I'
                  GroupIndex = 3
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -13
                  Font.Name = 'Times New Roman'
                  Font.Style = [fsItalic]
                  HotTrackFont.Charset = DEFAULT_CHARSET
                  HotTrackFont.Color = clWindowText
                  HotTrackFont.Height = -13
                  HotTrackFont.Name = 'Times New Roman'
                  HotTrackFont.Style = []
                  ParentFont = False
                end
                object btnChamadaSenhasSublinhado: TJvSpeedButton
                  Left = 340
                  Top = 15
                  Width = 20
                  Height = 22
                  AllowAllUp = True
                  Caption = 'S'
                  GroupIndex = 4
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -13
                  Font.Name = 'Times New Roman'
                  Font.Style = [fsUnderline]
                  HotTrackFont.Charset = DEFAULT_CHARSET
                  HotTrackFont.Color = clWindowText
                  HotTrackFont.Height = -13
                  HotTrackFont.Name = 'Times New Roman'
                  HotTrackFont.Style = []
                  ParentFont = False
                end
                object cmbChamadaSenhasFonte: TJvFontComboBox
                  Left = 5
                  Top = 15
                  Width = 190
                  Height = 22
                  DroppedDownWidth = 190
                  MaxMRUCount = 0
                  FontName = 'DejaVu Math TeX Gyre'
                  ItemIndex = 123
                  ParentShowHint = False
                  ShowHint = True
                  Sorted = True
                  TabOrder = 0
                end
                object cmbChamadaSenhasFontSize: TDBComboBox
                  Left = 199
                  Top = 15
                  Width = 51
                  Height = 21
                  DataField = 'FONTESIZE'
                  DataSource = dscPaineis
                  Items.Strings = (
                    '8'
                    '10'
                    '11'
                    '12'
                    '13'
                    '14'
                    '16'
                    '18'
                    '20'
                    '22'
                    '24'
                    '26'
                    '28'
                    '30'
                    '36'
                    '40'
                    '48'
                    '70'
                    '72')
                  TabOrder = 1
                end
                object cmbChamadaSenhasFontColor: TJvOfficeColorButton
                  Left = 251
                  Top = 15
                  Width = 47
                  Height = 22
                  ColorDialogOptions = [cdSolidColor, cdAnyColor]
                  TabOrder = 2
                  Flat = False
                  SelectedColor = clDefault
                  HotTrackFont.Charset = DEFAULT_CHARSET
                  HotTrackFont.Color = clWindowText
                  HotTrackFont.Height = -11
                  HotTrackFont.Name = 'MS Sans Serif'
                  HotTrackFont.Style = []
                  Properties.ShowDefaultColor = False
                  Properties.NoneColorCaption = 'No Color'
                  Properties.DefaultColorCaption = 'Automatic'
                  Properties.CustomColorCaption = 'Other Colors...'
                  Properties.NoneColorHint = 'No Color'
                  Properties.DefaultColorHint = 'Automatic'
                  Properties.CustomColorHint = 'Other Colors...'
                  Properties.NoneColorFont.Charset = DEFAULT_CHARSET
                  Properties.NoneColorFont.Color = clWindowText
                  Properties.NoneColorFont.Height = -11
                  Properties.NoneColorFont.Name = 'MS Sans Serif'
                  Properties.NoneColorFont.Style = []
                  Properties.DefaultColorFont.Charset = DEFAULT_CHARSET
                  Properties.DefaultColorFont.Color = clWindowText
                  Properties.DefaultColorFont.Height = -11
                  Properties.DefaultColorFont.Name = 'MS Sans Serif'
                  Properties.DefaultColorFont.Style = []
                  Properties.CustomColorFont.Charset = DEFAULT_CHARSET
                  Properties.CustomColorFont.Color = clWindowText
                  Properties.CustomColorFont.Height = -11
                  Properties.CustomColorFont.Name = 'MS Sans Serif'
                  Properties.CustomColorFont.Style = []
                  Properties.TopMargin = 40
                  Properties.FloatWindowCaption = 'Color Window'
                  Properties.DragBarHint = 'Drag to float'
                end
              end
              object groupChamadaDeSenhasSom: TGroupBox
                Left = 5
                Top = 219
                Width = 366
                Height = 99
                Caption = 'Som'
                TabOrder = 2
                object edChamadaSenhasSoundFileName: TJvFilenameEdit
                  Left = 72
                  Top = 15
                  Width = 287
                  Height = 21
                  TabOrder = 0
                  Text = 'edChamadaSenhasSoundFileName'
                end
                object lstVozChamada: TCheckListBox
                  Left = 72
                  Top = 45
                  Width = 133
                  Height = 46
                  ItemHeight = 13
                  Items.Strings = (
                    '1. N'#250'mero da senha'
                    '2. Nome da PA'
                    '3. Nome do cliente')
                  TabOrder = 1
                end
                object btnSubirChamada: TBitBtn
                  Left = 210
                  Top = 43
                  Width = 24
                  Height = 24
                  Glyph.Data = {
                    C6050000424DC605000000000000360400002800000014000000140000000100
                    0800000000009001000000000000000000000001000000010000000000008080
                    8000000080000080800000800000808000008000000080008000408080004040
                    0000FF80000080400000FF00400000408000FFFFFF00C0C0C0000000FF0000FF
                    FF0000FF0000FFFF0000FF000000FF00FF0080FFFF0080FF0000FFFF8000FF80
                    80008000FF004080FF00C0DCC000F0CAA600DEDED600DED6D600D6CEC600CECE
                    C600CEBDAD00CEB5B500C6C6BD00C6BDB500C6B5B500C6B5AD00BDBDB500BDBD
                    AD00BDB5AD00BDA59C00BD9C9400BD948C00B5BDBD00B5B5B500B5B5AD00B5AD
                    A500B5A59C00B59C9400B58C8400ADADB500ADA5B500ADA59C00AD9C9400AD94
                    8C00AD8C8400AD847300A5CED600A5C6C600A5BDBD00A5ADAD00A59C9C00A59C
                    9400A56B5A009CB5C6009CB5BD009CA5AD009C949C009C8C8C009C8473009C73
                    8C009C7384009C737B009C7373009C736B009C6B6300949CAD0094737B009473
                    730094635A008CB5C6008CA5AD008C9CAD008C94AD008C8C94008C7B7B008C6B
                    6B008C6363008C524A008C4A420084A5BD008494BD0084849C0084848C008473
                    8C008473840084737B0084737300846B730084637300845A5A0084525200844A
                    4200843929007B8CAD007B636B007B4A42007B39310073ADC600739CC600739C
                    B5007394BD00738CB50073849C00737B9C00737B8C00737B7B0073738400736B
                    730073637300735A630073525200734A42007339420073393100733131006B84
                    AD006B849C006B7B9C006B7B84006B7394006B5263006B4A4A006B4242006B39
                    39006B3131006B293900639CBD00639CAD00638CBD00638CAD006384B500637B
                    AD00637B9C00637B8C00636B94006363730063525A00634A4A00633939006339
                    31006331390063313100632929005A9CAD005A8CC6005A8CAD005A84BD005A7B
                    B5005A73A5005A5263005A3939005294B5005284AD0052849C00527BB500527B
                    8C00526BAD0052639400525A8400525A6B0052527300524A6300524273005242
                    5200523131004A9CAD004A84A5004A639C004A5284004A4A73004A394A004A31
                    4A004A3139004A3131004A294A004A2931004A2929004A214A00428494004263
                    8400425A9C00425A6B004252940042527B00424A63004242630042425A004231
                    3900423131004231290042312100422139004221210042102100396B9C003952
                    940039528C0039527300394A630039425A003939520039314A00393142003931
                    31003184AD0031638400315A73003152730031526B00314A8C00314273003142
                    630031425A00313952003131420031313100299CAD002984AD0029428C002942
                    5200293952002939420029314A002929630029213100217B9400217B8C00216B
                    9C0021529C00214A5A0021425200213142002131180021184A00211829002118
                    2100185A730018527300185263001839730018396300106384000F0F0F0F0F0F
                    0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
                    0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
                    0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F01010101010F0F0F0F0F0F0F0F0F
                    0F0F0F0F0F0606060606010F0F0F0F0F0F0F0F0F0F0F0F0F0F1414141406010F
                    0F0F0F0F0F0F0F0F0F0F0F0F0F1414141406010F0F0F0F0F0F0F0F0F0F0F0F0F
                    0F1414141406010F0F0F0F0F0F0F0F0F0F0F0F0F0F1414141406010F0F0F0F0F
                    0F0F0F0F0F0F0F0F0F14141414060101010F0F0F0F0F0F0F0F0F0F1414141414
                    141414140F0F0F0F0F0F0F0F0F0F0F0F141414141414140F0F0F0F0F0F0F0F0F
                    0F0F0F0F0F14141414140F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F1414140F0F0F
                    0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F140F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
                    0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
                    0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
                    0F0F0F0F0F0F0F0F0F0F}
                  TabOrder = 2
                end
                object btnDescerChamada: TBitBtn
                  Left = 210
                  Top = 67
                  Width = 24
                  Height = 24
                  Glyph.Data = {
                    C6050000424DC605000000000000360400002800000014000000140000000100
                    0800000000009001000000000000000000000001000000010000000000008080
                    8000000080000080800000800000808000008000000080008000408080004040
                    0000FF80000080400000FF00400000408000FFFFFF00C0C0C0000000FF0000FF
                    FF0000FF0000FFFF0000FF000000FF00FF0080FFFF0080FF0000FFFF8000FF80
                    80008000FF004080FF00C0DCC000F0CAA600DEDED600DED6D600D6CEC600CECE
                    C600CEBDAD00CEB5B500C6C6BD00C6BDB500C6B5B500C6B5AD00BDBDB500BDBD
                    AD00BDB5AD00BDA59C00BD9C9400BD948C00B5BDBD00B5B5B500B5B5AD00B5AD
                    A500B5A59C00B59C9400B58C8400ADADB500ADA5B500ADA59C00AD9C9400AD94
                    8C00AD8C8400AD847300A5CED600A5C6C600A5BDBD00A5ADAD00A59C9C00A59C
                    9400A56B5A009CB5C6009CB5BD009CA5AD009C949C009C8C8C009C8473009C73
                    8C009C7384009C737B009C7373009C736B009C6B6300949CAD0094737B009473
                    730094635A008CB5C6008CA5AD008C9CAD008C94AD008C8C94008C7B7B008C6B
                    6B008C6363008C524A008C4A420084A5BD008494BD0084849C0084848C008473
                    8C008473840084737B0084737300846B730084637300845A5A0084525200844A
                    4200843929007B8CAD007B636B007B4A42007B39310073ADC600739CC600739C
                    B5007394BD00738CB50073849C00737B9C00737B8C00737B7B0073738400736B
                    730073637300735A630073525200734A42007339420073393100733131006B84
                    AD006B849C006B7B9C006B7B84006B7394006B5263006B4A4A006B4242006B39
                    39006B3131006B293900639CBD00639CAD00638CBD00638CAD006384B500637B
                    AD00637B9C00637B8C00636B94006363730063525A00634A4A00633939006339
                    31006331390063313100632929005A9CAD005A8CC6005A8CAD005A84BD005A7B
                    B5005A73A5005A5263005A3939005294B5005284AD0052849C00527BB500527B
                    8C00526BAD0052639400525A8400525A6B0052527300524A6300524273005242
                    5200523131004A9CAD004A84A5004A639C004A5284004A4A73004A394A004A31
                    4A004A3139004A3131004A294A004A2931004A2929004A214A00428494004263
                    8400425A9C00425A6B004252940042527B00424A63004242630042425A004231
                    3900423131004231290042312100422139004221210042102100396B9C003952
                    940039528C0039527300394A630039425A003939520039314A00393142003931
                    31003184AD0031638400315A73003152730031526B00314A8C00314273003142
                    630031425A00313952003131420031313100299CAD002984AD0029428C002942
                    5200293952002939420029314A002929630029213100217B9400217B8C00216B
                    9C0021529C00214A5A0021425200213142002131180021184A00211829002118
                    2100185A730018527300185263001839730018396300106384000F0F0F0F0F0F
                    0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
                    0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
                    010F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0601010F0F0F0F0F0F0F0F0F0F
                    0F0F0F0F0F0F14140601010F0F0F0F0F0F0F0F0F0F0F0F0F0F14141414060101
                    0F0F0F0F0F0F0F0F0F0F0F0F1414141414140601010F0F0F0F0F0F0F0F0F0F14
                    14141414140606060F0F0F0F0F0F0F0F0F0F0F0F0F1414141406010F0F0F0F0F
                    0F0F0F0F0F0F0F0F0F1414141406010F0F0F0F0F0F0F0F0F0F0F0F0F0F141414
                    1406010F0F0F0F0F0F0F0F0F0F0F0F0F0F1414141406010F0F0F0F0F0F0F0F0F
                    0F0F0F0F0F1414141406010F0F0F0F0F0F0F0F0F0F0F0F0F0F14141414060F0F
                    0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
                    0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
                    0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
                    0F0F0F0F0F0F0F0F0F0F}
                  TabOrder = 3
                end
                object chkArquivo: TDBCheckBox
                  Left = 8
                  Top = 16
                  Width = 65
                  Height = 17
                  Caption = 'Arquivo'
                  TabOrder = 4
                  ValueChecked = 'T'
                  ValueUnchecked = 'F'
                end
                object chkVoz: TDBCheckBox
                  Left = 8
                  Top = 40
                  Width = 57
                  Height = 17
                  Caption = 'Voz'
                  DataField = 'SOMVOZ'
                  DataSource = dscPaineis
                  TabOrder = 5
                  ValueChecked = 'T'
                  ValueUnchecked = 'F'
                end
              end
              object groupChamadaDeSenhasPAsPermitidas: TGroupBox
                Left = 5
                Top = 335
                Width = 366
                Height = 53
                Caption = 'PAS Permitidas'
                TabOrder = 3
                DesignSize = (
                  366
                  53)
                object edChamadaSenhasPASPermitidas: TDBEdit
                  Left = 7
                  Top = 21
                  Width = 322
                  Height = 21
                  DataField = 'PASPERMITIDAS'
                  DataSource = dscPaineis
                  TabOrder = 0
                end
                object btnPASPermitidos: TButton
                  Left = 333
                  Top = 20
                  Width = 25
                  Height = 21
                  Anchors = [akTop, akRight]
                  Caption = '...'
                  TabOrder = 1
                  OnClick = btnPASPermitidosClick
                end
              end
              object groupChamadaDeSenhasLayout: TGroupBox
                Left = 5
                Top = 57
                Width = 366
                Height = 158
                Caption = 'Layout'
                TabOrder = 1
                object groupChamadaDeSenhasLayoutSenha: TGroupBox
                  Left = 4
                  Top = 16
                  Width = 357
                  Height = 44
                  TabOrder = 1
                  object Label32: TLabel
                    Left = 10
                    Top = 21
                    Width = 13
                    Height = 13
                    Caption = 'X:'
                  end
                  object Label33: TLabel
                    Left = 74
                    Top = 21
                    Width = 11
                    Height = 13
                    Caption = 'Y:'
                  end
                  object Label23: TLabel
                    Left = 131
                    Top = 21
                    Width = 34
                    Height = 13
                    Caption = 'Larg.:'
                  end
                  object Label35: TLabel
                    Left = 206
                    Top = 21
                    Width = 24
                    Height = 13
                    Caption = 'Alt.:'
                  end
                  object btnChamadaDeSenhasLayoutSenhaAlinhaEsquerda: TSpeedButton
                    Left = 275
                    Top = 15
                    Width = 23
                    Height = 22
                    GroupIndex = 1
                    Glyph.Data = {
                      C6050000424DC605000000000000360400002800000014000000140000000100
                      0800000000009001000000000000000000000001000000000000000000000000
                      80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
                      A6000020400000206000002080000020A0000020C0000020E000004000000040
                      20000040400000406000004080000040A0000040C0000040E000006000000060
                      20000060400000606000006080000060A0000060C0000060E000008000000080
                      20000080400000806000008080000080A0000080C0000080E00000A0000000A0
                      200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0
                      200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0
                      200000E0400000E0600000E0800000E0A00000E0C00000E0E000400000004000
                      20004000400040006000400080004000A0004000C0004000E000402000004020
                      20004020400040206000402080004020A0004020C0004020E000404000004040
                      20004040400040406000404080004040A0004040C0004040E000406000004060
                      20004060400040606000406080004060A0004060C0004060E000408000004080
                      20004080400040806000408080004080A0004080C0004080E00040A0000040A0
                      200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0
                      200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0
                      200040E0400040E0600040E0800040E0A00040E0C00040E0E000800000008000
                      20008000400080006000800080008000A0008000C0008000E000802000008020
                      20008020400080206000802080008020A0008020C0008020E000804000008040
                      20008040400080406000804080008040A0008040C0008040E000806000008060
                      20008060400080606000806080008060A0008060C0008060E000808000008080
                      20008080400080806000808080008080A0008080C0008080E00080A0000080A0
                      200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0
                      200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0
                      200080E0400080E0600080E0800080E0A00080E0C00080E0E000C0000000C000
                      2000C0004000C0006000C0008000C000A000C000C000C000E000C0200000C020
                      2000C0204000C0206000C0208000C020A000C020C000C020E000C0400000C040
                      2000C0404000C0406000C0408000C040A000C040C000C040E000C0600000C060
                      2000C0604000C0606000C0608000C060A000C060C000C060E000C0800000C080
                      2000C0804000C0806000C0808000C080A000C080C000C080E000C0A00000C0A0
                      2000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C0
                      2000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000
                      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0700000000000000000000070707070707070707070707070707070707070707
                      0707070707070707070000000000000000000000000000070707070707070707
                      0707070707070707070707070707070707000000000000000000000707070707
                      0707070707070707070707070707070707070707070707070700000000000000
                      0000000000000007070707070707070707070707070707070707070707070707
                      0700000000000000000000070707070707070707070707070707070707070707
                      0707070707070707070000000000000000000000000000070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      07070707070707070707}
                  end
                  object btnChamadaDeSenhasLayoutSenhaAlinhaCentro: TSpeedButton
                    Left = 300
                    Top = 15
                    Width = 23
                    Height = 22
                    GroupIndex = 1
                    Glyph.Data = {
                      C6050000424DC605000000000000360400002800000014000000140000000100
                      0800000000009001000000000000000000000001000000000000000000000000
                      80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
                      A6000020400000206000002080000020A0000020C0000020E000004000000040
                      20000040400000406000004080000040A0000040C0000040E000006000000060
                      20000060400000606000006080000060A0000060C0000060E000008000000080
                      20000080400000806000008080000080A0000080C0000080E00000A0000000A0
                      200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0
                      200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0
                      200000E0400000E0600000E0800000E0A00000E0C00000E0E000400000004000
                      20004000400040006000400080004000A0004000C0004000E000402000004020
                      20004020400040206000402080004020A0004020C0004020E000404000004040
                      20004040400040406000404080004040A0004040C0004040E000406000004060
                      20004060400040606000406080004060A0004060C0004060E000408000004080
                      20004080400040806000408080004080A0004080C0004080E00040A0000040A0
                      200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0
                      200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0
                      200040E0400040E0600040E0800040E0A00040E0C00040E0E000800000008000
                      20008000400080006000800080008000A0008000C0008000E000802000008020
                      20008020400080206000802080008020A0008020C0008020E000804000008040
                      20008040400080406000804080008040A0008040C0008040E000806000008060
                      20008060400080606000806080008060A0008060C0008060E000808000008080
                      20008080400080806000808080008080A0008080C0008080E00080A0000080A0
                      200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0
                      200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0
                      200080E0400080E0600080E0800080E0A00080E0C00080E0E000C0000000C000
                      2000C0004000C0006000C0008000C000A000C000C000C000E000C0200000C020
                      2000C0204000C0206000C0208000C020A000C020C000C020E000C0400000C040
                      2000C0404000C0406000C0408000C040A000C040C000C040E000C0600000C060
                      2000C0604000C0606000C0608000C060A000C060C000C060E000C0800000C080
                      2000C0804000C0806000C0808000C080A000C080C000C080E000C0A00000C0A0
                      2000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C0
                      2000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000
                      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070000000000000000000007070707070707070707070707070707070707
                      0707070707070707070000000000000000000000000000070707070707070707
                      0707070707070707070707070707070707070700000000000000000000070707
                      0707070707070707070707070707070707070707070707070700000000000000
                      0000000000000007070707070707070707070707070707070707070707070707
                      0707070000000000000000000007070707070707070707070707070707070707
                      0707070707070707070000000000000000000000000000070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      07070707070707070707}
                  end
                  object btnChamadaDeSenhasLayoutSenhaAlinhaDireita: TSpeedButton
                    Left = 325
                    Top = 15
                    Width = 23
                    Height = 22
                    GroupIndex = 1
                    Glyph.Data = {
                      C6050000424DC605000000000000360400002800000014000000140000000100
                      0800000000009001000000000000000000000001000000000000000000000000
                      80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
                      A6000020400000206000002080000020A0000020C0000020E000004000000040
                      20000040400000406000004080000040A0000040C0000040E000006000000060
                      20000060400000606000006080000060A0000060C0000060E000008000000080
                      20000080400000806000008080000080A0000080C0000080E00000A0000000A0
                      200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0
                      200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0
                      200000E0400000E0600000E0800000E0A00000E0C00000E0E000400000004000
                      20004000400040006000400080004000A0004000C0004000E000402000004020
                      20004020400040206000402080004020A0004020C0004020E000404000004040
                      20004040400040406000404080004040A0004040C0004040E000406000004060
                      20004060400040606000406080004060A0004060C0004060E000408000004080
                      20004080400040806000408080004080A0004080C0004080E00040A0000040A0
                      200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0
                      200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0
                      200040E0400040E0600040E0800040E0A00040E0C00040E0E000800000008000
                      20008000400080006000800080008000A0008000C0008000E000802000008020
                      20008020400080206000802080008020A0008020C0008020E000804000008040
                      20008040400080406000804080008040A0008040C0008040E000806000008060
                      20008060400080606000806080008060A0008060C0008060E000808000008080
                      20008080400080806000808080008080A0008080C0008080E00080A0000080A0
                      200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0
                      200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0
                      200080E0400080E0600080E0800080E0A00080E0C00080E0E000C0000000C000
                      2000C0004000C0006000C0008000C000A000C000C000C000E000C0200000C020
                      2000C0204000C0206000C0208000C020A000C020C000C020E000C0400000C040
                      2000C0404000C0406000C0408000C040A000C040C000C040E000C0600000C060
                      2000C0604000C0606000C0608000C060A000C060C000C060E000C0800000C080
                      2000C0804000C0806000C0808000C080A000C080C000C080E000C0A00000C0A0
                      2000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C0
                      2000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000
                      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070707000000000000000000000707070707070707070707070707070707
                      0707070707070707070000000000000000000000000000070707070707070707
                      0707070707070707070707070707070707070707070000000000000000000007
                      0707070707070707070707070707070707070707070707070700000000000000
                      0000000000000007070707070707070707070707070707070707070707070707
                      0707070707000000000000000000000707070707070707070707070707070707
                      0707070707070707070000000000000000000000000000070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      07070707070707070707}
                  end
                  object edChamadaDeSenhasLayoutSenhaX: TDBEdit
                    Left = 26
                    Top = 17
                    Width = 33
                    Height = 21
                    DataField = 'LAYOUTSENHAX'
                    DataSource = dscPaineis
                    TabOrder = 0
                  end
                  object edChamadaDeSenhasLayoutSenhaY: TDBEdit
                    Left = 86
                    Top = 17
                    Width = 33
                    Height = 21
                    DataField = 'LAYOUTSENHAY'
                    DataSource = dscPaineis
                    TabOrder = 1
                  end
                  object edChamadaDeSenhasLayoutSenhaLarg: TDBEdit
                    Left = 162
                    Top = 17
                    Width = 33
                    Height = 21
                    DataField = 'LAYOUTSENHALARG'
                    DataSource = dscPaineis
                    TabOrder = 2
                  end
                  object edChamadaDeSenhasLayoutSenhaAlt: TDBEdit
                    Left = 229
                    Top = 17
                    Width = 33
                    Height = 21
                    DataField = 'LAYOUTSENHAALT'
                    DataSource = dscPaineis
                    TabOrder = 3
                  end
                end
                object chkChamadaDeSenhasLayoutMostrarSenha: TDBCheckBox
                  Left = 13
                  Top = 14
                  Width = 132
                  Height = 17
                  Caption = 'Mostrar senha'
                  DataField = 'MOSTRARSENHA'
                  DataSource = dscPaineis
                  TabOrder = 0
                  ValueChecked = 'T'
                  ValueUnchecked = 'F'
                end
                object groupChamadaDeSenhasLayoutPA: TGroupBox
                  Left = 4
                  Top = 63
                  Width = 357
                  Height = 44
                  TabOrder = 3
                  object Label34: TLabel
                    Left = 10
                    Top = 21
                    Width = 13
                    Height = 13
                    Caption = 'X:'
                  end
                  object Label37: TLabel
                    Left = 74
                    Top = 21
                    Width = 11
                    Height = 13
                    Caption = 'Y:'
                  end
                  object Label38: TLabel
                    Left = 131
                    Top = 21
                    Width = 34
                    Height = 13
                    Caption = 'Larg.:'
                  end
                  object Label39: TLabel
                    Left = 206
                    Top = 21
                    Width = 24
                    Height = 13
                    Caption = 'Alt.:'
                  end
                  object btnChamadaDeSenhasLayoutPAAlinhaEsquerda: TSpeedButton
                    Left = 275
                    Top = 15
                    Width = 23
                    Height = 22
                    GroupIndex = 2
                    Glyph.Data = {
                      C6050000424DC605000000000000360400002800000014000000140000000100
                      0800000000009001000000000000000000000001000000000000000000000000
                      80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
                      A6000020400000206000002080000020A0000020C0000020E000004000000040
                      20000040400000406000004080000040A0000040C0000040E000006000000060
                      20000060400000606000006080000060A0000060C0000060E000008000000080
                      20000080400000806000008080000080A0000080C0000080E00000A0000000A0
                      200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0
                      200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0
                      200000E0400000E0600000E0800000E0A00000E0C00000E0E000400000004000
                      20004000400040006000400080004000A0004000C0004000E000402000004020
                      20004020400040206000402080004020A0004020C0004020E000404000004040
                      20004040400040406000404080004040A0004040C0004040E000406000004060
                      20004060400040606000406080004060A0004060C0004060E000408000004080
                      20004080400040806000408080004080A0004080C0004080E00040A0000040A0
                      200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0
                      200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0
                      200040E0400040E0600040E0800040E0A00040E0C00040E0E000800000008000
                      20008000400080006000800080008000A0008000C0008000E000802000008020
                      20008020400080206000802080008020A0008020C0008020E000804000008040
                      20008040400080406000804080008040A0008040C0008040E000806000008060
                      20008060400080606000806080008060A0008060C0008060E000808000008080
                      20008080400080806000808080008080A0008080C0008080E00080A0000080A0
                      200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0
                      200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0
                      200080E0400080E0600080E0800080E0A00080E0C00080E0E000C0000000C000
                      2000C0004000C0006000C0008000C000A000C000C000C000E000C0200000C020
                      2000C0204000C0206000C0208000C020A000C020C000C020E000C0400000C040
                      2000C0404000C0406000C0408000C040A000C040C000C040E000C0600000C060
                      2000C0604000C0606000C0608000C060A000C060C000C060E000C0800000C080
                      2000C0804000C0806000C0808000C080A000C080C000C080E000C0A00000C0A0
                      2000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C0
                      2000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000
                      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0700000000000000000000070707070707070707070707070707070707070707
                      0707070707070707070000000000000000000000000000070707070707070707
                      0707070707070707070707070707070707000000000000000000000707070707
                      0707070707070707070707070707070707070707070707070700000000000000
                      0000000000000007070707070707070707070707070707070707070707070707
                      0700000000000000000000070707070707070707070707070707070707070707
                      0707070707070707070000000000000000000000000000070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      07070707070707070707}
                  end
                  object btnChamadaDeSenhasLayoutPAAlinhaCentro: TSpeedButton
                    Left = 300
                    Top = 15
                    Width = 23
                    Height = 22
                    GroupIndex = 2
                    Glyph.Data = {
                      C6050000424DC605000000000000360400002800000014000000140000000100
                      0800000000009001000000000000000000000001000000000000000000000000
                      80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
                      A6000020400000206000002080000020A0000020C0000020E000004000000040
                      20000040400000406000004080000040A0000040C0000040E000006000000060
                      20000060400000606000006080000060A0000060C0000060E000008000000080
                      20000080400000806000008080000080A0000080C0000080E00000A0000000A0
                      200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0
                      200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0
                      200000E0400000E0600000E0800000E0A00000E0C00000E0E000400000004000
                      20004000400040006000400080004000A0004000C0004000E000402000004020
                      20004020400040206000402080004020A0004020C0004020E000404000004040
                      20004040400040406000404080004040A0004040C0004040E000406000004060
                      20004060400040606000406080004060A0004060C0004060E000408000004080
                      20004080400040806000408080004080A0004080C0004080E00040A0000040A0
                      200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0
                      200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0
                      200040E0400040E0600040E0800040E0A00040E0C00040E0E000800000008000
                      20008000400080006000800080008000A0008000C0008000E000802000008020
                      20008020400080206000802080008020A0008020C0008020E000804000008040
                      20008040400080406000804080008040A0008040C0008040E000806000008060
                      20008060400080606000806080008060A0008060C0008060E000808000008080
                      20008080400080806000808080008080A0008080C0008080E00080A0000080A0
                      200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0
                      200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0
                      200080E0400080E0600080E0800080E0A00080E0C00080E0E000C0000000C000
                      2000C0004000C0006000C0008000C000A000C000C000C000E000C0200000C020
                      2000C0204000C0206000C0208000C020A000C020C000C020E000C0400000C040
                      2000C0404000C0406000C0408000C040A000C040C000C040E000C0600000C060
                      2000C0604000C0606000C0608000C060A000C060C000C060E000C0800000C080
                      2000C0804000C0806000C0808000C080A000C080C000C080E000C0A00000C0A0
                      2000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C0
                      2000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000
                      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070000000000000000000007070707070707070707070707070707070707
                      0707070707070707070000000000000000000000000000070707070707070707
                      0707070707070707070707070707070707070700000000000000000000070707
                      0707070707070707070707070707070707070707070707070700000000000000
                      0000000000000007070707070707070707070707070707070707070707070707
                      0707070000000000000000000007070707070707070707070707070707070707
                      0707070707070707070000000000000000000000000000070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      07070707070707070707}
                  end
                  object btnChamadaDeSenhasLayoutPAAlinhaDireita: TSpeedButton
                    Left = 325
                    Top = 15
                    Width = 23
                    Height = 22
                    GroupIndex = 2
                    Glyph.Data = {
                      C6050000424DC605000000000000360400002800000014000000140000000100
                      0800000000009001000000000000000000000001000000000000000000000000
                      80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
                      A6000020400000206000002080000020A0000020C0000020E000004000000040
                      20000040400000406000004080000040A0000040C0000040E000006000000060
                      20000060400000606000006080000060A0000060C0000060E000008000000080
                      20000080400000806000008080000080A0000080C0000080E00000A0000000A0
                      200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0
                      200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0
                      200000E0400000E0600000E0800000E0A00000E0C00000E0E000400000004000
                      20004000400040006000400080004000A0004000C0004000E000402000004020
                      20004020400040206000402080004020A0004020C0004020E000404000004040
                      20004040400040406000404080004040A0004040C0004040E000406000004060
                      20004060400040606000406080004060A0004060C0004060E000408000004080
                      20004080400040806000408080004080A0004080C0004080E00040A0000040A0
                      200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0
                      200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0
                      200040E0400040E0600040E0800040E0A00040E0C00040E0E000800000008000
                      20008000400080006000800080008000A0008000C0008000E000802000008020
                      20008020400080206000802080008020A0008020C0008020E000804000008040
                      20008040400080406000804080008040A0008040C0008040E000806000008060
                      20008060400080606000806080008060A0008060C0008060E000808000008080
                      20008080400080806000808080008080A0008080C0008080E00080A0000080A0
                      200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0
                      200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0
                      200080E0400080E0600080E0800080E0A00080E0C00080E0E000C0000000C000
                      2000C0004000C0006000C0008000C000A000C000C000C000E000C0200000C020
                      2000C0204000C0206000C0208000C020A000C020C000C020E000C0400000C040
                      2000C0404000C0406000C0408000C040A000C040C000C040E000C0600000C060
                      2000C0604000C0606000C0608000C060A000C060C000C060E000C0800000C080
                      2000C0804000C0806000C0808000C080A000C080C000C080E000C0A00000C0A0
                      2000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C0
                      2000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000
                      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070707000000000000000000000707070707070707070707070707070707
                      0707070707070707070000000000000000000000000000070707070707070707
                      0707070707070707070707070707070707070707070000000000000000000007
                      0707070707070707070707070707070707070707070707070700000000000000
                      0000000000000007070707070707070707070707070707070707070707070707
                      0707070707000000000000000000000707070707070707070707070707070707
                      0707070707070707070000000000000000000000000000070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      07070707070707070707}
                  end
                  object edChamadaDeSenhasLayoutPAX: TDBEdit
                    Left = 26
                    Top = 17
                    Width = 33
                    Height = 21
                    DataField = 'LAYOUTPAX'
                    DataSource = dscPaineis
                    TabOrder = 0
                  end
                  object edChamadaDeSenhasLayoutPAY: TDBEdit
                    Left = 86
                    Top = 17
                    Width = 33
                    Height = 21
                    DataField = 'LAYOUTPAY'
                    DataSource = dscPaineis
                    TabOrder = 1
                  end
                  object edChamadaDeSenhasLayoutPALarg: TDBEdit
                    Left = 162
                    Top = 17
                    Width = 33
                    Height = 21
                    DataField = 'LAYOUTPALARG'
                    DataSource = dscPaineis
                    TabOrder = 2
                  end
                  object edChamadaDeSenhasLayoutPAAlt: TDBEdit
                    Left = 229
                    Top = 17
                    Width = 33
                    Height = 21
                    DataField = 'LAYOUTPAALT'
                    DataSource = dscPaineis
                    TabOrder = 3
                  end
                end
                object chkChamadaDeSenhasLayoutMostrarPA: TDBCheckBox
                  Left = 13
                  Top = 61
                  Width = 147
                  Height = 17
                  Caption = 'Mostrar PA'
                  DataField = 'MOSTRARPA'
                  DataSource = dscPaineis
                  TabOrder = 2
                  ValueChecked = 'T'
                  ValueUnchecked = 'F'
                end
                object groupChamadaDeSenhasLayoutNomeCliente: TGroupBox
                  Left = 4
                  Top = 110
                  Width = 357
                  Height = 44
                  TabOrder = 5
                  object Label40: TLabel
                    Left = 10
                    Top = 21
                    Width = 13
                    Height = 13
                    Caption = 'X:'
                  end
                  object Label41: TLabel
                    Left = 74
                    Top = 21
                    Width = 11
                    Height = 13
                    Caption = 'Y:'
                  end
                  object Label42: TLabel
                    Left = 131
                    Top = 21
                    Width = 34
                    Height = 13
                    Caption = 'Larg.:'
                  end
                  object Label43: TLabel
                    Left = 206
                    Top = 21
                    Width = 24
                    Height = 13
                    Caption = 'Alt.:'
                  end
                  object btnChamadaDeSenhasLayoutNomeClienteAlinhaEsquerda: TSpeedButton
                    Left = 275
                    Top = 15
                    Width = 23
                    Height = 22
                    GroupIndex = 3
                    Glyph.Data = {
                      C6050000424DC605000000000000360400002800000014000000140000000100
                      0800000000009001000000000000000000000001000000000000000000000000
                      80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
                      A6000020400000206000002080000020A0000020C0000020E000004000000040
                      20000040400000406000004080000040A0000040C0000040E000006000000060
                      20000060400000606000006080000060A0000060C0000060E000008000000080
                      20000080400000806000008080000080A0000080C0000080E00000A0000000A0
                      200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0
                      200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0
                      200000E0400000E0600000E0800000E0A00000E0C00000E0E000400000004000
                      20004000400040006000400080004000A0004000C0004000E000402000004020
                      20004020400040206000402080004020A0004020C0004020E000404000004040
                      20004040400040406000404080004040A0004040C0004040E000406000004060
                      20004060400040606000406080004060A0004060C0004060E000408000004080
                      20004080400040806000408080004080A0004080C0004080E00040A0000040A0
                      200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0
                      200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0
                      200040E0400040E0600040E0800040E0A00040E0C00040E0E000800000008000
                      20008000400080006000800080008000A0008000C0008000E000802000008020
                      20008020400080206000802080008020A0008020C0008020E000804000008040
                      20008040400080406000804080008040A0008040C0008040E000806000008060
                      20008060400080606000806080008060A0008060C0008060E000808000008080
                      20008080400080806000808080008080A0008080C0008080E00080A0000080A0
                      200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0
                      200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0
                      200080E0400080E0600080E0800080E0A00080E0C00080E0E000C0000000C000
                      2000C0004000C0006000C0008000C000A000C000C000C000E000C0200000C020
                      2000C0204000C0206000C0208000C020A000C020C000C020E000C0400000C040
                      2000C0404000C0406000C0408000C040A000C040C000C040E000C0600000C060
                      2000C0604000C0606000C0608000C060A000C060C000C060E000C0800000C080
                      2000C0804000C0806000C0808000C080A000C080C000C080E000C0A00000C0A0
                      2000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C0
                      2000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000
                      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0700000000000000000000070707070707070707070707070707070707070707
                      0707070707070707070000000000000000000000000000070707070707070707
                      0707070707070707070707070707070707000000000000000000000707070707
                      0707070707070707070707070707070707070707070707070700000000000000
                      0000000000000007070707070707070707070707070707070707070707070707
                      0700000000000000000000070707070707070707070707070707070707070707
                      0707070707070707070000000000000000000000000000070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      07070707070707070707}
                  end
                  object btnChamadaDeSenhasLayoutNomeClienteAlinhaCentro: TSpeedButton
                    Left = 300
                    Top = 15
                    Width = 23
                    Height = 22
                    GroupIndex = 3
                    Glyph.Data = {
                      C6050000424DC605000000000000360400002800000014000000140000000100
                      0800000000009001000000000000000000000001000000000000000000000000
                      80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
                      A6000020400000206000002080000020A0000020C0000020E000004000000040
                      20000040400000406000004080000040A0000040C0000040E000006000000060
                      20000060400000606000006080000060A0000060C0000060E000008000000080
                      20000080400000806000008080000080A0000080C0000080E00000A0000000A0
                      200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0
                      200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0
                      200000E0400000E0600000E0800000E0A00000E0C00000E0E000400000004000
                      20004000400040006000400080004000A0004000C0004000E000402000004020
                      20004020400040206000402080004020A0004020C0004020E000404000004040
                      20004040400040406000404080004040A0004040C0004040E000406000004060
                      20004060400040606000406080004060A0004060C0004060E000408000004080
                      20004080400040806000408080004080A0004080C0004080E00040A0000040A0
                      200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0
                      200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0
                      200040E0400040E0600040E0800040E0A00040E0C00040E0E000800000008000
                      20008000400080006000800080008000A0008000C0008000E000802000008020
                      20008020400080206000802080008020A0008020C0008020E000804000008040
                      20008040400080406000804080008040A0008040C0008040E000806000008060
                      20008060400080606000806080008060A0008060C0008060E000808000008080
                      20008080400080806000808080008080A0008080C0008080E00080A0000080A0
                      200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0
                      200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0
                      200080E0400080E0600080E0800080E0A00080E0C00080E0E000C0000000C000
                      2000C0004000C0006000C0008000C000A000C000C000C000E000C0200000C020
                      2000C0204000C0206000C0208000C020A000C020C000C020E000C0400000C040
                      2000C0404000C0406000C0408000C040A000C040C000C040E000C0600000C060
                      2000C0604000C0606000C0608000C060A000C060C000C060E000C0800000C080
                      2000C0804000C0806000C0808000C080A000C080C000C080E000C0A00000C0A0
                      2000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C0
                      2000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000
                      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070000000000000000000007070707070707070707070707070707070707
                      0707070707070707070000000000000000000000000000070707070707070707
                      0707070707070707070707070707070707070700000000000000000000070707
                      0707070707070707070707070707070707070707070707070700000000000000
                      0000000000000007070707070707070707070707070707070707070707070707
                      0707070000000000000000000007070707070707070707070707070707070707
                      0707070707070707070000000000000000000000000000070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      07070707070707070707}
                  end
                  object btnChamadaDeSenhasLayoutNomeClienteAlinhaDireita: TSpeedButton
                    Left = 325
                    Top = 15
                    Width = 23
                    Height = 22
                    GroupIndex = 3
                    Glyph.Data = {
                      C6050000424DC605000000000000360400002800000014000000140000000100
                      0800000000009001000000000000000000000001000000000000000000000000
                      80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
                      A6000020400000206000002080000020A0000020C0000020E000004000000040
                      20000040400000406000004080000040A0000040C0000040E000006000000060
                      20000060400000606000006080000060A0000060C0000060E000008000000080
                      20000080400000806000008080000080A0000080C0000080E00000A0000000A0
                      200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0
                      200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0
                      200000E0400000E0600000E0800000E0A00000E0C00000E0E000400000004000
                      20004000400040006000400080004000A0004000C0004000E000402000004020
                      20004020400040206000402080004020A0004020C0004020E000404000004040
                      20004040400040406000404080004040A0004040C0004040E000406000004060
                      20004060400040606000406080004060A0004060C0004060E000408000004080
                      20004080400040806000408080004080A0004080C0004080E00040A0000040A0
                      200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0
                      200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0
                      200040E0400040E0600040E0800040E0A00040E0C00040E0E000800000008000
                      20008000400080006000800080008000A0008000C0008000E000802000008020
                      20008020400080206000802080008020A0008020C0008020E000804000008040
                      20008040400080406000804080008040A0008040C0008040E000806000008060
                      20008060400080606000806080008060A0008060C0008060E000808000008080
                      20008080400080806000808080008080A0008080C0008080E00080A0000080A0
                      200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0
                      200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0
                      200080E0400080E0600080E0800080E0A00080E0C00080E0E000C0000000C000
                      2000C0004000C0006000C0008000C000A000C000C000C000E000C0200000C020
                      2000C0204000C0206000C0208000C020A000C020C000C020E000C0400000C040
                      2000C0404000C0406000C0408000C040A000C040C000C040E000C0600000C060
                      2000C0604000C0606000C0608000C060A000C060C000C060E000C0800000C080
                      2000C0804000C0806000C0808000C080A000C080C000C080E000C0A00000C0A0
                      2000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C0
                      2000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000
                      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070707000000000000000000000707070707070707070707070707070707
                      0707070707070707070000000000000000000000000000070707070707070707
                      0707070707070707070707070707070707070707070000000000000000000007
                      0707070707070707070707070707070707070707070707070700000000000000
                      0000000000000007070707070707070707070707070707070707070707070707
                      0707070707000000000000000000000707070707070707070707070707070707
                      0707070707070707070000000000000000000000000000070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      07070707070707070707}
                  end
                  object edChamadaDeSenhasLayoutNomeClienteX: TDBEdit
                    Left = 26
                    Top = 17
                    Width = 33
                    Height = 21
                    DataField = 'LAYOUTNOMECLIENTEX'
                    DataSource = dscPaineis
                    TabOrder = 0
                  end
                  object edChamadaDeSenhasLayoutNomeClienteY: TDBEdit
                    Left = 86
                    Top = 17
                    Width = 33
                    Height = 21
                    DataField = 'LAYOUTNOMECLIENTEY'
                    DataSource = dscPaineis
                    TabOrder = 1
                  end
                  object edChamadaDeSenhasLayoutNomeClienteLarg: TDBEdit
                    Left = 162
                    Top = 17
                    Width = 33
                    Height = 21
                    DataField = 'LAYOUTNOMECLIENTELARG'
                    DataSource = dscPaineis
                    TabOrder = 2
                  end
                  object edChamadaDeSenhasLayoutNomeClienteAlt: TDBEdit
                    Left = 229
                    Top = 17
                    Width = 33
                    Height = 21
                    DataField = 'LAYOUTNOMECLIENTEALT'
                    DataSource = dscPaineis
                    TabOrder = 3
                  end
                end
                object chkChamadaDeSenhasLayoutMostrarNomeCliente: TDBCheckBox
                  Left = 13
                  Top = 108
                  Width = 172
                  Height = 17
                  Caption = 'Mostrar nome do cliente'
                  DataField = 'MOSTRARNOMECLIENTE'
                  DataSource = dscPaineis
                  TabOrder = 4
                  ValueChecked = 'T'
                  ValueUnchecked = 'F'
                end
              end
            end
          end
          object tbsTV: TTabSheet
            Caption = 'TV'
            ImageIndex = 2
            object OLDpnlTV: TGroupBox
              Left = 0
              Top = 0
              Width = 388
              Height = 387
              Align = alClient
              Caption = 'TV'
              TabOrder = 0
              Visible = False
              object Label24: TLabel
                Left = 52
                Top = 18
                Width = 77
                Height = 13
                Caption = 'Canal padr'#227'o'
              end
              object Label31: TLabel
                Left = 10
                Top = 18
                Width = 14
                Height = 13
                Caption = 'ID'
              end
              object grbVsVideoCaptureDevice: TGroupBox
                Left = 7
                Top = 59
                Width = 366
                Height = 115
                Hint = 
                  'to select programmatically an item by its name in a list, use th' +
                  'e FindIndexInListByName function'
                Caption = 'video source = video capture device'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = [fsBold]
                ParentFont = False
                TabOrder = 0
                object Label25: TLabel
                  Left = 8
                  Top = 38
                  Width = 55
                  Height = 13
                  Caption = 'video input:'
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -11
                  Font.Name = 'MS Sans Serif'
                  Font.Style = []
                  ParentFont = False
                end
                object Label104: TLabel
                  Left = 190
                  Top = 38
                  Width = 47
                  Height = 13
                  Caption = 'video size'
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -11
                  Font.Name = 'MS Sans Serif'
                  Font.Style = []
                  ParentFont = False
                end
                object Label14: TLabel
                  Left = 190
                  Top = 76
                  Width = 105
                  Height = 13
                  Caption = 'analog video standard'
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -11
                  Font.Name = 'MS Sans Serif'
                  Font.Style = []
                  ParentFont = False
                end
                object Label15: TLabel
                  Left = 8
                  Top = 76
                  Width = 66
                  Height = 13
                  Caption = 'video subtype'
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -11
                  Font.Name = 'MS Sans Serif'
                  Font.Style = []
                  ParentFont = False
                end
                object cboVideoInputs: TDBComboBox
                  Left = 5
                  Top = 53
                  Width = 175
                  Height = 21
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -11
                  Font.Name = 'MS Sans Serif'
                  Font.Style = []
                  ParentFont = False
                  TabOrder = 0
                end
                object cboVideoDevices: TDBComboBox
                  Left = 5
                  Top = 16
                  Width = 355
                  Height = 21
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -11
                  Font.Name = 'MS Sans Serif'
                  Font.Style = []
                  ParentFont = False
                  TabOrder = 1
                end
                object cboVideoSubtypes: TDBComboBox
                  Left = 5
                  Top = 90
                  Width = 175
                  Height = 21
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -11
                  Font.Name = 'MS Sans Serif'
                  Font.Style = []
                  ParentFont = False
                  TabOrder = 2
                end
                object cboVideoSizes: TDBComboBox
                  Left = 185
                  Top = 53
                  Width = 175
                  Height = 21
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -11
                  Font.Name = 'MS Sans Serif'
                  Font.Style = []
                  ParentFont = False
                  TabOrder = 3
                end
                object cboAnalogVideoStandard: TDBComboBox
                  Left = 185
                  Top = 90
                  Width = 175
                  Height = 21
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -11
                  Font.Name = 'MS Sans Serif'
                  Font.Style = []
                  ParentFont = False
                  TabOrder = 4
                end
              end
              object grbPreview: TGroupBox
                Left = 305
                Top = 16
                Width = 67
                Height = 40
                Caption = 'Preview'
                TabOrder = 1
                object btnStartPreview: TBitBtn
                  Left = 6
                  Top = 15
                  Width = 25
                  Height = 20
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clRed
                  Font.Height = -11
                  Font.Name = 'MS Sans Serif'
                  Font.Style = [fsBold]
                  Glyph.Data = {
                    36050000424D3605000000000000360400002800000010000000100000000100
                    080000000000000100007A120000701200000001000000000000000000008080
                    8000000080000080800000800000808000008000000080008000408080004040
                    0000FF80000080400000FF00400000408000FFFFFF00C0C0C0000000FF0000FF
                    FF0000FF0000FFFF0000FF000000FF00FF0080FFFF0080FF0000FFFF8000FF80
                    80008000FF004080FF00C0DCC000F0CAA60060F0F00090F0900099CCFF00FF33
                    990030903000000030009090F00080F0B000101010003070700070F0D00050D0
                    B00050E0E00030B060007FFFCC0040B0B0001030300040B070004CCC99001020
                    20002030300072FFE5004C667F007090B000EFEFEF00BFBFBF0050E0D00059E5
                    CC009966FF000000F0002121210031212100212131004A212100312131004A21
                    31002131290031312900212152005A2931003121520029294A00213142004229
                    4A003131420029295A0021216B0052294A004A3142002131520042295A002942
                    31003131520021217B004A3152006B314A0029424A0029317300214A42006B31
                    5A00314A420042424A00423173005A425200524A4A0021426B00294A5A002152
                    52007342520031426B00424A5A006B4A4A0031525200524A5A004A426B005A42
                    6B004A525200294A73006B4A5A005A525200295A5A0021526B007B4A5A007352
                    5200424A730031526B00524A7300294A8400425A5A004A526B0021527B00525A
                    5A006B4A73005A526B0031527B00424A84006B5A5A00316B52007B5A5A004A52
                    7B0073526B004A6B520084526B005A528400216B73006B5A7B00295A9400945A
                    7300316B73007B5A7B0029736B00425A94004A6B7300525A940042736B005A6B
                    7300316B840052736B0029737B00846B6B004A6B8400736B73006B736B009473
                    5A00317B73005A6B84009C6B6B0042737B0052737B00736B84004A7B7300316B
                    9C00297394006B737B005A7B73009C6B7B00317B84004A6B9C00947373007B73
                    7B00847B6B00737B73004273940029847B00A57373004A7B84009C7B6B002973
                    A5005273940042847B0073739C005A8484006B7B9400947B840084847B00427B
                    A5007B7B940031849C0073848400AD7B8400527BA5004A849C00A5847B005294
                    7B006B7BA5005A849C003184AD006B947B007B7BA50029949400C6847B004A84
                    AD004294940084849C004A9C84005A84AD00AD947300529494009C849C005A9C
                    84006B949400319C9C00739C84007B9494005294A500CE947B00849C84004A9C
                    9C00BD94840094949400A59494007394A50052A594005294BD006BA594008494
                    AD00A594A50042A5A5006B9CAD007394BD005AA5A5004AAD9C00AD9C9C00949C
                    A50084A59C00C69C9400A5A5940073A5A50052ADAD0084A5AD006B9CC6006BAD
                    AD00D6A59400A5A5A500949CBD0073A5BD0094ADA500BDA5A500EFA594005ABD
                    A50084A5C60073A5CE00CEAD9C00ADADAD006BADC600E7AD9C000F0F0F0F0F0F
                    0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0E0F0F
                    0F0F0F0F0F0F0F0F0F0F0F0F01120E0E0F0F0F0F0F0F0F0F0F0F0F0F01121212
                    0E0E0F0F0F0F0F0F0F0F0F0F0112121212120E0E0F0F0F0F0F0F0F0F01121212
                    121212120E0E0F0F0F0F0F0F011212121212121212120E0E0F0F0F0F01121212
                    12121212121201010E0F0F0F011212121212121201010F0F0F0F0F0F01121212
                    121201010F0F0F0F0F0F0F0F0112121201010F0F0F0F0F0F0F0F0F0F01120101
                    0F0F0F0F0F0F0F0F0F0F0F0F01010F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
                    0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F}
                  ParentFont = False
                  TabOrder = 0
                end
                object btnStopPreview: TBitBtn
                  Left = 36
                  Top = 15
                  Width = 25
                  Height = 20
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clRed
                  Font.Height = -11
                  Font.Name = 'MS Sans Serif'
                  Font.Style = [fsBold]
                  Glyph.Data = {
                    36050000424D3605000000000000360400002800000010000000100000000100
                    080000000000000100007A120000701200000001000000000000000000008080
                    8000000080000080800000800000808000008000000080008000408080004040
                    0000FF80000080400000FF00400000408000FFFFFF00C0C0C0000000FF0000FF
                    FF0000FF0000FFFF0000FF000000FF00FF0080FFFF0080FF0000FFFF8000FF80
                    80008000FF004080FF00C0DCC000F0CAA60060F0F00090F0900099CCFF00FF33
                    990030903000000030009090F00080F0B000101010003070700070F0D00050D0
                    B00050E0E00030B060007FFFCC0040B0B0001030300040B070004CCC99001020
                    20002030300072FFE5004C667F007090B000EFEFEF00BFBFBF0050E0D00059E5
                    CC009966FF000000F0002121210031212100212131004A212100312131004A21
                    31002131290031312900212152005A2931003121520029294A00213142004229
                    4A003131420029295A0021216B0052294A004A3142002131520042295A002942
                    31003131520021217B004A3152006B314A0029424A0029317300214A42006B31
                    5A00314A420042424A00423173005A425200524A4A0021426B00294A5A002152
                    52007342520031426B00424A5A006B4A4A0031525200524A5A004A426B005A42
                    6B004A525200294A73006B4A5A005A525200295A5A0021526B007B4A5A007352
                    5200424A730031526B00524A7300294A8400425A5A004A526B0021527B00525A
                    5A006B4A73005A526B0031527B00424A84006B5A5A00316B52007B5A5A004A52
                    7B0073526B004A6B520084526B005A528400216B73006B5A7B00295A9400945A
                    7300316B73007B5A7B0029736B00425A94004A6B7300525A940042736B005A6B
                    7300316B840052736B0029737B00846B6B004A6B8400736B73006B736B009473
                    5A00317B73005A6B84009C6B6B0042737B0052737B00736B84004A7B7300316B
                    9C00297394006B737B005A7B73009C6B7B00317B84004A6B9C00947373007B73
                    7B00847B6B00737B73004273940029847B00A57373004A7B84009C7B6B002973
                    A5005273940042847B0073739C005A8484006B7B9400947B840084847B00427B
                    A5007B7B940031849C0073848400AD7B8400527BA5004A849C00A5847B005294
                    7B006B7BA5005A849C003184AD006B947B007B7BA50029949400C6847B004A84
                    AD004294940084849C004A9C84005A84AD00AD947300529494009C849C005A9C
                    84006B949400319C9C00739C84007B9494005294A500CE947B00849C84004A9C
                    9C00BD94840094949400A59494007394A50052A594005294BD006BA594008494
                    AD00A594A50042A5A5006B9CAD007394BD005AA5A5004AAD9C00AD9C9C00949C
                    A50084A59C00C69C9400A5A5940073A5A50052ADAD0084A5AD006B9CC6006BAD
                    AD00D6A59400A5A5A500949CBD0073A5BD0094ADA500BDA5A500EFA594005ABD
                    A50084A5C60073A5CE00CEAD9C00ADADAD006BADC600E7AD9C000F0F0F0F0F0F
                    0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
                    0F0F0F0F0F0F0F0F0F0F0F0F0E0E0E0E0E0E0E0E0E0E0E0E0F0F0F0110101010
                    101010101010100E0F0F0F0110101010101010101010100E0F0F0F0110101010
                    101010101010100E0F0F0F0110101010101010101010100E0F0F0F0110101010
                    101010101010100E0F0F0F0110101010101010101010100E0F0F0F0110101010
                    101010101010100E0F0F0F0110101010101010101010100E0F0F0F0101010101
                    010101010101010F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
                    0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F}
                  ParentFont = False
                  TabOrder = 1
                end
              end
              object grbAudioCaptureDevice: TGroupBox
                Left = 7
                Top = 176
                Width = 366
                Height = 120
                Caption = 'Audio capture device'
                TabOrder = 2
                object Label27: TLabel
                  Left = 8
                  Top = 38
                  Width = 68
                  Height = 13
                  Caption = 'audio input:'
                end
                object Label49: TLabel
                  Left = 190
                  Top = 38
                  Width = 94
                  Height = 13
                  Caption = 'audio input level'
                end
                object Label36: TLabel
                  Left = 190
                  Top = 76
                  Width = 111
                  Height = 13
                  Caption = 'audio input balance'
                end
                object cboAudioDevices: TDBComboBox
                  Left = 5
                  Top = 16
                  Width = 355
                  Height = 21
                  TabOrder = 0
                end
                object cboAudioInputs: TDBComboBox
                  Left = 5
                  Top = 53
                  Width = 175
                  Height = 21
                  TabOrder = 1
                end
                object tbrAudioInputLevel: TTrackBar
                  Left = 185
                  Top = 53
                  Width = 175
                  Height = 25
                  Max = 65535
                  Frequency = 900
                  Position = 50000
                  TabOrder = 2
                  ThumbLength = 15
                end
                object tbrAudioInputBalance: TTrackBar
                  Left = 185
                  Top = 90
                  Width = 175
                  Height = 25
                  Max = 32767
                  Min = -32768
                  Frequency = 900
                  TabOrder = 3
                  ThumbLength = 15
                end
              end
              object grbAudioRendering: TGroupBox
                Left = 7
                Top = 298
                Width = 366
                Height = 87
                Caption = 'audio renderer'
                TabOrder = 3
                object Label28: TLabel
                  Left = 8
                  Top = 38
                  Width = 42
                  Height = 13
                  Caption = 'volume'
                end
                object Label29: TLabel
                  Left = 190
                  Top = 38
                  Width = 44
                  Height = 13
                  Caption = 'balance'
                end
                object tbrAudioVolume: TTrackBar
                  Left = 5
                  Top = 53
                  Width = 175
                  Height = 25
                  Max = 65535
                  Frequency = 400
                  TabOrder = 0
                  ThumbLength = 15
                end
                object tbrAudioBalance: TTrackBar
                  Left = 185
                  Top = 53
                  Width = 175
                  Height = 25
                  Max = 32767
                  Min = -32768
                  Frequency = 800
                  TabOrder = 1
                  ThumbLength = 15
                end
                object cboAudioRenderers: TDBComboBox
                  Left = 5
                  Top = 16
                  Width = 355
                  Height = 21
                  TabOrder = 2
                end
              end
              object dblkpCanalPadrao: TDBLookupComboBox
                Left = 52
                Top = 35
                Width = 242
                Height = 21
                KeyField = 'ID'
                ListField = 'NOME'
                TabOrder = 4
              end
              object edtIdTV: TDBEdit
                Left = 7
                Top = 35
                Width = 37
                Height = 21
                TabOrder = 5
              end
            end
            object pnlTV: TGroupBox
              Left = 0
              Top = 0
              Width = 378
              Height = 393
              Caption = 'TV'
              TabOrder = 1
              object Label3: TLabel
                Left = 30
                Top = 33
                Width = 112
                Height = 13
                Caption = 'Softwares padr'#245'es:'
              end
              object Label53: TLabel
                Left = 7
                Top = 67
                Width = 140
                Height = 13
                Caption = 'Caminho do execut'#225'vel:'
              end
              object Label54: TLabel
                Left = 44
                Top = 100
                Width = 95
                Height = 13
                Caption = 'Nome da janela:'
              end
              object lblNome: TLabel
                Left = 67
                Top = 156
                Width = 67
                Height = 13
                Caption = 'Dispositivo:'
              end
              object lblResolucao: TLabel
                Left = 67
                Top = 186
                Width = 63
                Height = 13
                Caption = 'Resolu'#231#227'o:'
              end
              object lblResolucaoPadrao: TLabel
                Left = 7
                Top = 128
                Width = 137
                Height = 13
                Caption = 'Funcionar na resolu'#231#227'o:'
              end
              object lblVolume: TLabel
                Left = 83
                Top = 219
                Width = 47
                Height = 13
                Caption = 'Volume:'
              end
              object cboSoftwaresHomologados: TComboBox
                Left = 156
                Top = 32
                Width = 124
                Height = 21
                Style = csDropDownList
                ItemIndex = 0
                TabOrder = 0
                Text = '(outro)'
                OnChange = cboSoftwaresHomologadosChange
                Items.Strings = (
                  '(outro)'
                  'AverTV'
                  'VLC'
                  'AverCap'
                  'VisioForge'
                  'Sics LiveTV'
                  'USB Video')
              end
              object edCaminhoExecutavel: TDBEdit
                Left = 153
                Top = 63
                Width = 217
                Height = 21
                DataField = 'CAMINHODOEXECUTAVEL'
                DataSource = dscPaineis
                TabOrder = 1
              end
              object edNomeJanela: TDBEdit
                Left = 152
                Top = 96
                Width = 218
                Height = 21
                DataField = 'NOMEDAJANELA'
                DataSource = dscPaineis
                TabOrder = 2
              end
              object cbxDispositivo: TDBComboBox
                Left = 152
                Top = 155
                Width = 218
                Height = 21
                Style = csDropDownList
                DataSource = dscPaineis
                TabOrder = 3
              end
              object cbxResolucao: TDBComboBox
                Left = 152
                Top = 183
                Width = 113
                Height = 21
                Style = csDropDownList
                TabOrder = 4
              end
              object edResolucaoPadrao: TDBEdit
                Left = 150
                Top = 125
                Width = 115
                Height = 21
                DataField = 'RESOLUCAOPADRAO'
                DataSource = dscPaineis
                TabOrder = 5
              end
              object trckVolume: TTrackBar
                Left = 152
                Top = 216
                Width = 225
                Height = 36
                Max = 1000
                Min = 600
                PageSize = 100
                Frequency = 100
                Position = 800
                TabOrder = 6
              end
            end
          end
          object tbsImagem: TTabSheet
            Caption = 'Imagem'
            ImageIndex = 3
            ExplicitLeft = 0
            ExplicitTop = 0
            ExplicitWidth = 0
            ExplicitHeight = 0
            object pnlImagem: TGroupBox
              Left = 0
              Top = 0
              Width = 388
              Height = 387
              Align = alClient
              Caption = '&Imagem'
              TabOrder = 0
              object Label6: TLabel
                Left = 10
                Top = 29
                Width = 307
                Height = 13
                Caption = 'N'#227'o existem propriedades espec'#237'ficas para este item.'
              end
            end
          end
          object tbsUltimasChamadas: TTabSheet
            Caption = #218'ltimas senhas chamadas'
            ImageIndex = 4
            object pnlUltimasChamadas: TGroupBox
              Left = 0
              Top = 0
              Width = 388
              Height = 387
              Align = alClient
              Caption = '&'#218'ltimas senhas chamadas'
              TabOrder = 0
              object grpUltimasChamadasFonte: TGroupBox
                Left = 5
                Top = 13
                Width = 366
                Height = 43
                Caption = 'Fonte'
                TabOrder = 0
                object btnUltimasChamadasNegrito: TJvSpeedButton
                  Left = 300
                  Top = 15
                  Width = 20
                  Height = 22
                  AllowAllUp = True
                  Caption = 'N'
                  GroupIndex = 2
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -13
                  Font.Name = 'Times New Roman'
                  Font.Style = [fsBold]
                  HotTrackFont.Charset = DEFAULT_CHARSET
                  HotTrackFont.Color = clWindowText
                  HotTrackFont.Height = -13
                  HotTrackFont.Name = 'Times New Roman'
                  HotTrackFont.Style = []
                  ParentFont = False
                end
                object btnUltimasChamadasItalico: TJvSpeedButton
                  Left = 320
                  Top = 15
                  Width = 20
                  Height = 22
                  AllowAllUp = True
                  Caption = 'I'
                  GroupIndex = 3
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -13
                  Font.Name = 'Times New Roman'
                  Font.Style = [fsItalic]
                  HotTrackFont.Charset = DEFAULT_CHARSET
                  HotTrackFont.Color = clWindowText
                  HotTrackFont.Height = -13
                  HotTrackFont.Name = 'Times New Roman'
                  HotTrackFont.Style = []
                  ParentFont = False
                end
                object btnUltimasChamadasSublinhado: TJvSpeedButton
                  Left = 340
                  Top = 15
                  Width = 20
                  Height = 22
                  AllowAllUp = True
                  Caption = 'S'
                  GroupIndex = 4
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -13
                  Font.Name = 'Times New Roman'
                  Font.Style = [fsUnderline]
                  HotTrackFont.Charset = DEFAULT_CHARSET
                  HotTrackFont.Color = clWindowText
                  HotTrackFont.Height = -13
                  HotTrackFont.Name = 'Times New Roman'
                  HotTrackFont.Style = []
                  ParentFont = False
                end
                object cmbUltimasChamadasFonte: TJvFontComboBox
                  Left = 5
                  Top = 15
                  Width = 190
                  Height = 22
                  DroppedDownWidth = 190
                  MaxMRUCount = 0
                  FontName = 'Dubai'
                  ItemIndex = 137
                  Options = [foWysiWyg]
                  ParentShowHint = False
                  ShowHint = True
                  Sorted = True
                  TabOrder = 0
                end
                object cmbUltimasChamadasFontSize: TDBComboBox
                  Left = 199
                  Top = 15
                  Width = 51
                  Height = 21
                  DataField = 'FONTESIZE'
                  DataSource = dscPaineis
                  Items.Strings = (
                    '8'
                    '10'
                    '11'
                    '12'
                    '13'
                    '14'
                    '16'
                    '18'
                    '20'
                    '22'
                    '24'
                    '26'
                    '28'
                    '30'
                    '36'
                    '40'
                    '48'
                    '70'
                    '72')
                  TabOrder = 1
                end
                object cmbUltimasChamadasFontColor: TJvOfficeColorButton
                  Left = 251
                  Top = 15
                  Width = 47
                  Height = 22
                  ColorDialogOptions = [cdSolidColor, cdAnyColor]
                  TabOrder = 2
                  Flat = False
                  SelectedColor = clDefault
                  HotTrackFont.Charset = DEFAULT_CHARSET
                  HotTrackFont.Color = clWindowText
                  HotTrackFont.Height = -11
                  HotTrackFont.Name = 'MS Sans Serif'
                  HotTrackFont.Style = []
                  Properties.ShowDefaultColor = False
                  Properties.NoneColorCaption = 'No Color'
                  Properties.DefaultColorCaption = 'Automatic'
                  Properties.CustomColorCaption = 'Other Colors...'
                  Properties.NoneColorHint = 'No Color'
                  Properties.DefaultColorHint = 'Automatic'
                  Properties.CustomColorHint = 'Other Colors...'
                  Properties.NoneColorFont.Charset = DEFAULT_CHARSET
                  Properties.NoneColorFont.Color = clWindowText
                  Properties.NoneColorFont.Height = -11
                  Properties.NoneColorFont.Name = 'MS Sans Serif'
                  Properties.NoneColorFont.Style = []
                  Properties.DefaultColorFont.Charset = DEFAULT_CHARSET
                  Properties.DefaultColorFont.Color = clWindowText
                  Properties.DefaultColorFont.Height = -11
                  Properties.DefaultColorFont.Name = 'MS Sans Serif'
                  Properties.DefaultColorFont.Style = []
                  Properties.CustomColorFont.Charset = DEFAULT_CHARSET
                  Properties.CustomColorFont.Color = clWindowText
                  Properties.CustomColorFont.Height = -11
                  Properties.CustomColorFont.Name = 'MS Sans Serif'
                  Properties.CustomColorFont.Style = []
                  Properties.TopMargin = 40
                  Properties.FloatWindowCaption = 'Color Window'
                  Properties.DragBarHint = 'Drag to float'
                end
              end
              object groupUltimasChamadasPAsPermitidas: TGroupBox
                Left = 5
                Top = 302
                Width = 366
                Height = 53
                Caption = 'PAS Permitidas'
                TabOrder = 2
                DesignSize = (
                  366
                  53)
                object edUltimasChamadasPASPermitidas: TDBEdit
                  Left = 8
                  Top = 21
                  Width = 321
                  Height = 21
                  DataField = 'PASPERMITIDAS'
                  DataSource = dscPaineis
                  TabOrder = 0
                end
                object Button3: TButton
                  Left = 335
                  Top = 20
                  Width = 25
                  Height = 21
                  Anchors = [akTop, akRight]
                  Caption = '...'
                  TabOrder = 1
                  OnClick = Button3Click
                end
              end
              object groupUltimasChamadasLayout: TGroupBox
                Left = 5
                Top = 57
                Width = 366
                Height = 240
                Caption = 'Layout'
                TabOrder = 1
                object Label7: TLabel
                  Left = 248
                  Top = 171
                  Width = 93
                  Height = 13
                  Caption = 'Mostrar '#250'ltimas:'
                end
                object Label52: TLabel
                  Left = 253
                  Top = 196
                  Width = 81
                  Height = 13
                  Caption = 'Espa'#231'amento:'
                end
                object Label59: TLabel
                  Left = 288
                  Top = 221
                  Width = 42
                  Height = 13
                  Caption = 'Atraso:'
                end
                object groupUltimasChamadasLayoutSenha: TGroupBox
                  Left = 4
                  Top = 16
                  Width = 357
                  Height = 44
                  TabOrder = 1
                  object Label9: TLabel
                    Left = 10
                    Top = 21
                    Width = 13
                    Height = 13
                    Caption = 'X:'
                  end
                  object Label10: TLabel
                    Left = 74
                    Top = 21
                    Width = 11
                    Height = 13
                    Caption = 'Y:'
                  end
                  object Label11: TLabel
                    Left = 131
                    Top = 21
                    Width = 34
                    Height = 13
                    Caption = 'Larg.:'
                  end
                  object Label12: TLabel
                    Left = 206
                    Top = 21
                    Width = 24
                    Height = 13
                    Caption = 'Alt.:'
                  end
                  object btnUltimasChamadasLayoutSenhaAlinhaEsquerda: TSpeedButton
                    Left = 275
                    Top = 15
                    Width = 23
                    Height = 22
                    GroupIndex = 1
                    Glyph.Data = {
                      C6050000424DC605000000000000360400002800000014000000140000000100
                      0800000000009001000000000000000000000001000000000000000000000000
                      80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
                      A6000020400000206000002080000020A0000020C0000020E000004000000040
                      20000040400000406000004080000040A0000040C0000040E000006000000060
                      20000060400000606000006080000060A0000060C0000060E000008000000080
                      20000080400000806000008080000080A0000080C0000080E00000A0000000A0
                      200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0
                      200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0
                      200000E0400000E0600000E0800000E0A00000E0C00000E0E000400000004000
                      20004000400040006000400080004000A0004000C0004000E000402000004020
                      20004020400040206000402080004020A0004020C0004020E000404000004040
                      20004040400040406000404080004040A0004040C0004040E000406000004060
                      20004060400040606000406080004060A0004060C0004060E000408000004080
                      20004080400040806000408080004080A0004080C0004080E00040A0000040A0
                      200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0
                      200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0
                      200040E0400040E0600040E0800040E0A00040E0C00040E0E000800000008000
                      20008000400080006000800080008000A0008000C0008000E000802000008020
                      20008020400080206000802080008020A0008020C0008020E000804000008040
                      20008040400080406000804080008040A0008040C0008040E000806000008060
                      20008060400080606000806080008060A0008060C0008060E000808000008080
                      20008080400080806000808080008080A0008080C0008080E00080A0000080A0
                      200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0
                      200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0
                      200080E0400080E0600080E0800080E0A00080E0C00080E0E000C0000000C000
                      2000C0004000C0006000C0008000C000A000C000C000C000E000C0200000C020
                      2000C0204000C0206000C0208000C020A000C020C000C020E000C0400000C040
                      2000C0404000C0406000C0408000C040A000C040C000C040E000C0600000C060
                      2000C0604000C0606000C0608000C060A000C060C000C060E000C0800000C080
                      2000C0804000C0806000C0808000C080A000C080C000C080E000C0A00000C0A0
                      2000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C0
                      2000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000
                      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0700000000000000000000070707070707070707070707070707070707070707
                      0707070707070707070000000000000000000000000000070707070707070707
                      0707070707070707070707070707070707000000000000000000000707070707
                      0707070707070707070707070707070707070707070707070700000000000000
                      0000000000000007070707070707070707070707070707070707070707070707
                      0700000000000000000000070707070707070707070707070707070707070707
                      0707070707070707070000000000000000000000000000070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      07070707070707070707}
                  end
                  object btnUltimasChamadasLayoutSenhaAlinhaCentro: TSpeedButton
                    Left = 300
                    Top = 15
                    Width = 23
                    Height = 22
                    GroupIndex = 1
                    Glyph.Data = {
                      C6050000424DC605000000000000360400002800000014000000140000000100
                      0800000000009001000000000000000000000001000000000000000000000000
                      80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
                      A6000020400000206000002080000020A0000020C0000020E000004000000040
                      20000040400000406000004080000040A0000040C0000040E000006000000060
                      20000060400000606000006080000060A0000060C0000060E000008000000080
                      20000080400000806000008080000080A0000080C0000080E00000A0000000A0
                      200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0
                      200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0
                      200000E0400000E0600000E0800000E0A00000E0C00000E0E000400000004000
                      20004000400040006000400080004000A0004000C0004000E000402000004020
                      20004020400040206000402080004020A0004020C0004020E000404000004040
                      20004040400040406000404080004040A0004040C0004040E000406000004060
                      20004060400040606000406080004060A0004060C0004060E000408000004080
                      20004080400040806000408080004080A0004080C0004080E00040A0000040A0
                      200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0
                      200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0
                      200040E0400040E0600040E0800040E0A00040E0C00040E0E000800000008000
                      20008000400080006000800080008000A0008000C0008000E000802000008020
                      20008020400080206000802080008020A0008020C0008020E000804000008040
                      20008040400080406000804080008040A0008040C0008040E000806000008060
                      20008060400080606000806080008060A0008060C0008060E000808000008080
                      20008080400080806000808080008080A0008080C0008080E00080A0000080A0
                      200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0
                      200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0
                      200080E0400080E0600080E0800080E0A00080E0C00080E0E000C0000000C000
                      2000C0004000C0006000C0008000C000A000C000C000C000E000C0200000C020
                      2000C0204000C0206000C0208000C020A000C020C000C020E000C0400000C040
                      2000C0404000C0406000C0408000C040A000C040C000C040E000C0600000C060
                      2000C0604000C0606000C0608000C060A000C060C000C060E000C0800000C080
                      2000C0804000C0806000C0808000C080A000C080C000C080E000C0A00000C0A0
                      2000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C0
                      2000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000
                      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070000000000000000000007070707070707070707070707070707070707
                      0707070707070707070000000000000000000000000000070707070707070707
                      0707070707070707070707070707070707070700000000000000000000070707
                      0707070707070707070707070707070707070707070707070700000000000000
                      0000000000000007070707070707070707070707070707070707070707070707
                      0707070000000000000000000007070707070707070707070707070707070707
                      0707070707070707070000000000000000000000000000070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      07070707070707070707}
                  end
                  object btnUltimasChamadasLayoutSenhaAlinhaDireita: TSpeedButton
                    Left = 325
                    Top = 15
                    Width = 23
                    Height = 22
                    GroupIndex = 1
                    Glyph.Data = {
                      C6050000424DC605000000000000360400002800000014000000140000000100
                      0800000000009001000000000000000000000001000000000000000000000000
                      80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
                      A6000020400000206000002080000020A0000020C0000020E000004000000040
                      20000040400000406000004080000040A0000040C0000040E000006000000060
                      20000060400000606000006080000060A0000060C0000060E000008000000080
                      20000080400000806000008080000080A0000080C0000080E00000A0000000A0
                      200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0
                      200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0
                      200000E0400000E0600000E0800000E0A00000E0C00000E0E000400000004000
                      20004000400040006000400080004000A0004000C0004000E000402000004020
                      20004020400040206000402080004020A0004020C0004020E000404000004040
                      20004040400040406000404080004040A0004040C0004040E000406000004060
                      20004060400040606000406080004060A0004060C0004060E000408000004080
                      20004080400040806000408080004080A0004080C0004080E00040A0000040A0
                      200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0
                      200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0
                      200040E0400040E0600040E0800040E0A00040E0C00040E0E000800000008000
                      20008000400080006000800080008000A0008000C0008000E000802000008020
                      20008020400080206000802080008020A0008020C0008020E000804000008040
                      20008040400080406000804080008040A0008040C0008040E000806000008060
                      20008060400080606000806080008060A0008060C0008060E000808000008080
                      20008080400080806000808080008080A0008080C0008080E00080A0000080A0
                      200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0
                      200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0
                      200080E0400080E0600080E0800080E0A00080E0C00080E0E000C0000000C000
                      2000C0004000C0006000C0008000C000A000C000C000C000E000C0200000C020
                      2000C0204000C0206000C0208000C020A000C020C000C020E000C0400000C040
                      2000C0404000C0406000C0408000C040A000C040C000C040E000C0600000C060
                      2000C0604000C0606000C0608000C060A000C060C000C060E000C0800000C080
                      2000C0804000C0806000C0808000C080A000C080C000C080E000C0A00000C0A0
                      2000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C0
                      2000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000
                      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070707000000000000000000000707070707070707070707070707070707
                      0707070707070707070000000000000000000000000000070707070707070707
                      0707070707070707070707070707070707070707070000000000000000000007
                      0707070707070707070707070707070707070707070707070700000000000000
                      0000000000000007070707070707070707070707070707070707070707070707
                      0707070707000000000000000000000707070707070707070707070707070707
                      0707070707070707070000000000000000000000000000070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      07070707070707070707}
                  end
                  object edUltimasChamadasLayoutSenhaX: TDBEdit
                    Left = 26
                    Top = 17
                    Width = 33
                    Height = 21
                    DataField = 'LAYOUTSENHAX'
                    DataSource = dscPaineis
                    TabOrder = 0
                  end
                  object edUltimasChamadasLayoutSenhaY: TDBEdit
                    Left = 86
                    Top = 17
                    Width = 33
                    Height = 21
                    DataField = 'LAYOUTSENHAY'
                    DataSource = dscPaineis
                    TabOrder = 1
                  end
                  object edUltimasChamadasLayoutSenhaLarg: TDBEdit
                    Left = 162
                    Top = 17
                    Width = 33
                    Height = 21
                    DataField = 'LAYOUTSENHALARG'
                    DataSource = dscPaineis
                    TabOrder = 2
                  end
                  object edUltimasChamadasLayoutSenhaAlt: TDBEdit
                    Left = 229
                    Top = 17
                    Width = 33
                    Height = 21
                    DataField = 'LAYOUTSENHAALT'
                    DataSource = dscPaineis
                    TabOrder = 3
                  end
                end
                object chkUltimasChamadasLayoutMostrarSenha: TDBCheckBox
                  Left = 13
                  Top = 14
                  Width = 116
                  Height = 17
                  Caption = 'Mostrar senha'
                  DataField = 'MOSTRARSENHA'
                  DataSource = dscPaineis
                  TabOrder = 0
                  ValueChecked = 'T'
                  ValueUnchecked = 'F'
                end
                object groupUltimasChamadasLayoutPA: TGroupBox
                  Left = 4
                  Top = 63
                  Width = 357
                  Height = 44
                  TabOrder = 3
                  object Label13: TLabel
                    Left = 10
                    Top = 21
                    Width = 13
                    Height = 13
                    Caption = 'X:'
                  end
                  object Label44: TLabel
                    Left = 74
                    Top = 21
                    Width = 11
                    Height = 13
                    Caption = 'Y:'
                  end
                  object Label45: TLabel
                    Left = 131
                    Top = 21
                    Width = 34
                    Height = 13
                    Caption = 'Larg.:'
                  end
                  object Label46: TLabel
                    Left = 206
                    Top = 21
                    Width = 24
                    Height = 13
                    Caption = 'Alt.:'
                  end
                  object btnUltimasChamadasLayoutPAAlinhaEsquerda: TSpeedButton
                    Left = 275
                    Top = 15
                    Width = 23
                    Height = 22
                    GroupIndex = 2
                    Glyph.Data = {
                      C6050000424DC605000000000000360400002800000014000000140000000100
                      0800000000009001000000000000000000000001000000000000000000000000
                      80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
                      A6000020400000206000002080000020A0000020C0000020E000004000000040
                      20000040400000406000004080000040A0000040C0000040E000006000000060
                      20000060400000606000006080000060A0000060C0000060E000008000000080
                      20000080400000806000008080000080A0000080C0000080E00000A0000000A0
                      200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0
                      200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0
                      200000E0400000E0600000E0800000E0A00000E0C00000E0E000400000004000
                      20004000400040006000400080004000A0004000C0004000E000402000004020
                      20004020400040206000402080004020A0004020C0004020E000404000004040
                      20004040400040406000404080004040A0004040C0004040E000406000004060
                      20004060400040606000406080004060A0004060C0004060E000408000004080
                      20004080400040806000408080004080A0004080C0004080E00040A0000040A0
                      200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0
                      200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0
                      200040E0400040E0600040E0800040E0A00040E0C00040E0E000800000008000
                      20008000400080006000800080008000A0008000C0008000E000802000008020
                      20008020400080206000802080008020A0008020C0008020E000804000008040
                      20008040400080406000804080008040A0008040C0008040E000806000008060
                      20008060400080606000806080008060A0008060C0008060E000808000008080
                      20008080400080806000808080008080A0008080C0008080E00080A0000080A0
                      200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0
                      200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0
                      200080E0400080E0600080E0800080E0A00080E0C00080E0E000C0000000C000
                      2000C0004000C0006000C0008000C000A000C000C000C000E000C0200000C020
                      2000C0204000C0206000C0208000C020A000C020C000C020E000C0400000C040
                      2000C0404000C0406000C0408000C040A000C040C000C040E000C0600000C060
                      2000C0604000C0606000C0608000C060A000C060C000C060E000C0800000C080
                      2000C0804000C0806000C0808000C080A000C080C000C080E000C0A00000C0A0
                      2000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C0
                      2000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000
                      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0700000000000000000000070707070707070707070707070707070707070707
                      0707070707070707070000000000000000000000000000070707070707070707
                      0707070707070707070707070707070707000000000000000000000707070707
                      0707070707070707070707070707070707070707070707070700000000000000
                      0000000000000007070707070707070707070707070707070707070707070707
                      0700000000000000000000070707070707070707070707070707070707070707
                      0707070707070707070000000000000000000000000000070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      07070707070707070707}
                  end
                  object btnUltimasChamadasLayoutPAAlinhaCentro: TSpeedButton
                    Left = 300
                    Top = 15
                    Width = 23
                    Height = 22
                    GroupIndex = 2
                    Glyph.Data = {
                      C6050000424DC605000000000000360400002800000014000000140000000100
                      0800000000009001000000000000000000000001000000000000000000000000
                      80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
                      A6000020400000206000002080000020A0000020C0000020E000004000000040
                      20000040400000406000004080000040A0000040C0000040E000006000000060
                      20000060400000606000006080000060A0000060C0000060E000008000000080
                      20000080400000806000008080000080A0000080C0000080E00000A0000000A0
                      200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0
                      200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0
                      200000E0400000E0600000E0800000E0A00000E0C00000E0E000400000004000
                      20004000400040006000400080004000A0004000C0004000E000402000004020
                      20004020400040206000402080004020A0004020C0004020E000404000004040
                      20004040400040406000404080004040A0004040C0004040E000406000004060
                      20004060400040606000406080004060A0004060C0004060E000408000004080
                      20004080400040806000408080004080A0004080C0004080E00040A0000040A0
                      200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0
                      200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0
                      200040E0400040E0600040E0800040E0A00040E0C00040E0E000800000008000
                      20008000400080006000800080008000A0008000C0008000E000802000008020
                      20008020400080206000802080008020A0008020C0008020E000804000008040
                      20008040400080406000804080008040A0008040C0008040E000806000008060
                      20008060400080606000806080008060A0008060C0008060E000808000008080
                      20008080400080806000808080008080A0008080C0008080E00080A0000080A0
                      200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0
                      200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0
                      200080E0400080E0600080E0800080E0A00080E0C00080E0E000C0000000C000
                      2000C0004000C0006000C0008000C000A000C000C000C000E000C0200000C020
                      2000C0204000C0206000C0208000C020A000C020C000C020E000C0400000C040
                      2000C0404000C0406000C0408000C040A000C040C000C040E000C0600000C060
                      2000C0604000C0606000C0608000C060A000C060C000C060E000C0800000C080
                      2000C0804000C0806000C0808000C080A000C080C000C080E000C0A00000C0A0
                      2000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C0
                      2000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000
                      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070000000000000000000007070707070707070707070707070707070707
                      0707070707070707070000000000000000000000000000070707070707070707
                      0707070707070707070707070707070707070700000000000000000000070707
                      0707070707070707070707070707070707070707070707070700000000000000
                      0000000000000007070707070707070707070707070707070707070707070707
                      0707070000000000000000000007070707070707070707070707070707070707
                      0707070707070707070000000000000000000000000000070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      07070707070707070707}
                  end
                  object btnUltimasChamadasLayoutPAAlinhaDireita: TSpeedButton
                    Left = 325
                    Top = 15
                    Width = 23
                    Height = 22
                    GroupIndex = 2
                    Glyph.Data = {
                      C6050000424DC605000000000000360400002800000014000000140000000100
                      0800000000009001000000000000000000000001000000000000000000000000
                      80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
                      A6000020400000206000002080000020A0000020C0000020E000004000000040
                      20000040400000406000004080000040A0000040C0000040E000006000000060
                      20000060400000606000006080000060A0000060C0000060E000008000000080
                      20000080400000806000008080000080A0000080C0000080E00000A0000000A0
                      200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0
                      200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0
                      200000E0400000E0600000E0800000E0A00000E0C00000E0E000400000004000
                      20004000400040006000400080004000A0004000C0004000E000402000004020
                      20004020400040206000402080004020A0004020C0004020E000404000004040
                      20004040400040406000404080004040A0004040C0004040E000406000004060
                      20004060400040606000406080004060A0004060C0004060E000408000004080
                      20004080400040806000408080004080A0004080C0004080E00040A0000040A0
                      200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0
                      200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0
                      200040E0400040E0600040E0800040E0A00040E0C00040E0E000800000008000
                      20008000400080006000800080008000A0008000C0008000E000802000008020
                      20008020400080206000802080008020A0008020C0008020E000804000008040
                      20008040400080406000804080008040A0008040C0008040E000806000008060
                      20008060400080606000806080008060A0008060C0008060E000808000008080
                      20008080400080806000808080008080A0008080C0008080E00080A0000080A0
                      200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0
                      200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0
                      200080E0400080E0600080E0800080E0A00080E0C00080E0E000C0000000C000
                      2000C0004000C0006000C0008000C000A000C000C000C000E000C0200000C020
                      2000C0204000C0206000C0208000C020A000C020C000C020E000C0400000C040
                      2000C0404000C0406000C0408000C040A000C040C000C040E000C0600000C060
                      2000C0604000C0606000C0608000C060A000C060C000C060E000C0800000C080
                      2000C0804000C0806000C0808000C080A000C080C000C080E000C0A00000C0A0
                      2000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C0
                      2000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000
                      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070707000000000000000000000707070707070707070707070707070707
                      0707070707070707070000000000000000000000000000070707070707070707
                      0707070707070707070707070707070707070707070000000000000000000007
                      0707070707070707070707070707070707070707070707070700000000000000
                      0000000000000007070707070707070707070707070707070707070707070707
                      0707070707000000000000000000000707070707070707070707070707070707
                      0707070707070707070000000000000000000000000000070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      07070707070707070707}
                  end
                  object edUltimasChamadasLayoutPAX: TDBEdit
                    Left = 26
                    Top = 17
                    Width = 33
                    Height = 21
                    DataField = 'LAYOUTPAX'
                    DataSource = dscPaineis
                    TabOrder = 0
                  end
                  object edUltimasChamadasLayoutPAY: TDBEdit
                    Left = 86
                    Top = 17
                    Width = 33
                    Height = 21
                    DataField = 'LAYOUTPAY'
                    DataSource = dscPaineis
                    TabOrder = 1
                  end
                  object edUltimasChamadasLayoutPALarg: TDBEdit
                    Left = 162
                    Top = 17
                    Width = 33
                    Height = 21
                    DataField = 'LAYOUTPALARG'
                    DataSource = dscPaineis
                    TabOrder = 2
                  end
                  object edUltimasChamadasLayoutPAAlt: TDBEdit
                    Left = 229
                    Top = 17
                    Width = 33
                    Height = 21
                    DataField = 'LAYOUTPAALT'
                    DataSource = dscPaineis
                    TabOrder = 3
                  end
                end
                object chkUltimasChamadasLayoutMostrarPA: TDBCheckBox
                  Left = 13
                  Top = 61
                  Width = 147
                  Height = 17
                  Caption = 'Mostrar PA'
                  DataField = 'MOSTRARPA'
                  DataSource = dscPaineis
                  TabOrder = 2
                  ValueChecked = 'T'
                  ValueUnchecked = 'F'
                end
                object groupUltimasChamadasLayoutNomeCliente: TGroupBox
                  Left = 4
                  Top = 110
                  Width = 357
                  Height = 44
                  TabOrder = 5
                  object Label47: TLabel
                    Left = 10
                    Top = 21
                    Width = 13
                    Height = 13
                    Caption = 'X:'
                  end
                  object Label48: TLabel
                    Left = 74
                    Top = 21
                    Width = 11
                    Height = 13
                    Caption = 'Y:'
                  end
                  object Label50: TLabel
                    Left = 131
                    Top = 21
                    Width = 34
                    Height = 13
                    Caption = 'Larg.:'
                  end
                  object Label51: TLabel
                    Left = 206
                    Top = 21
                    Width = 24
                    Height = 13
                    Caption = 'Alt.:'
                  end
                  object btnUltimasChamadasLayoutNomeClienteAlinhaEsquerda: TSpeedButton
                    Left = 275
                    Top = 15
                    Width = 23
                    Height = 22
                    GroupIndex = 3
                    Glyph.Data = {
                      C6050000424DC605000000000000360400002800000014000000140000000100
                      0800000000009001000000000000000000000001000000000000000000000000
                      80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
                      A6000020400000206000002080000020A0000020C0000020E000004000000040
                      20000040400000406000004080000040A0000040C0000040E000006000000060
                      20000060400000606000006080000060A0000060C0000060E000008000000080
                      20000080400000806000008080000080A0000080C0000080E00000A0000000A0
                      200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0
                      200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0
                      200000E0400000E0600000E0800000E0A00000E0C00000E0E000400000004000
                      20004000400040006000400080004000A0004000C0004000E000402000004020
                      20004020400040206000402080004020A0004020C0004020E000404000004040
                      20004040400040406000404080004040A0004040C0004040E000406000004060
                      20004060400040606000406080004060A0004060C0004060E000408000004080
                      20004080400040806000408080004080A0004080C0004080E00040A0000040A0
                      200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0
                      200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0
                      200040E0400040E0600040E0800040E0A00040E0C00040E0E000800000008000
                      20008000400080006000800080008000A0008000C0008000E000802000008020
                      20008020400080206000802080008020A0008020C0008020E000804000008040
                      20008040400080406000804080008040A0008040C0008040E000806000008060
                      20008060400080606000806080008060A0008060C0008060E000808000008080
                      20008080400080806000808080008080A0008080C0008080E00080A0000080A0
                      200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0
                      200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0
                      200080E0400080E0600080E0800080E0A00080E0C00080E0E000C0000000C000
                      2000C0004000C0006000C0008000C000A000C000C000C000E000C0200000C020
                      2000C0204000C0206000C0208000C020A000C020C000C020E000C0400000C040
                      2000C0404000C0406000C0408000C040A000C040C000C040E000C0600000C060
                      2000C0604000C0606000C0608000C060A000C060C000C060E000C0800000C080
                      2000C0804000C0806000C0808000C080A000C080C000C080E000C0A00000C0A0
                      2000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C0
                      2000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000
                      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0700000000000000000000070707070707070707070707070707070707070707
                      0707070707070707070000000000000000000000000000070707070707070707
                      0707070707070707070707070707070707000000000000000000000707070707
                      0707070707070707070707070707070707070707070707070700000000000000
                      0000000000000007070707070707070707070707070707070707070707070707
                      0700000000000000000000070707070707070707070707070707070707070707
                      0707070707070707070000000000000000000000000000070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      07070707070707070707}
                  end
                  object btnUltimasChamadasLayoutNomeClienteAlinhaCentro: TSpeedButton
                    Left = 300
                    Top = 15
                    Width = 23
                    Height = 22
                    GroupIndex = 3
                    Glyph.Data = {
                      C6050000424DC605000000000000360400002800000014000000140000000100
                      0800000000009001000000000000000000000001000000000000000000000000
                      80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
                      A6000020400000206000002080000020A0000020C0000020E000004000000040
                      20000040400000406000004080000040A0000040C0000040E000006000000060
                      20000060400000606000006080000060A0000060C0000060E000008000000080
                      20000080400000806000008080000080A0000080C0000080E00000A0000000A0
                      200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0
                      200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0
                      200000E0400000E0600000E0800000E0A00000E0C00000E0E000400000004000
                      20004000400040006000400080004000A0004000C0004000E000402000004020
                      20004020400040206000402080004020A0004020C0004020E000404000004040
                      20004040400040406000404080004040A0004040C0004040E000406000004060
                      20004060400040606000406080004060A0004060C0004060E000408000004080
                      20004080400040806000408080004080A0004080C0004080E00040A0000040A0
                      200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0
                      200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0
                      200040E0400040E0600040E0800040E0A00040E0C00040E0E000800000008000
                      20008000400080006000800080008000A0008000C0008000E000802000008020
                      20008020400080206000802080008020A0008020C0008020E000804000008040
                      20008040400080406000804080008040A0008040C0008040E000806000008060
                      20008060400080606000806080008060A0008060C0008060E000808000008080
                      20008080400080806000808080008080A0008080C0008080E00080A0000080A0
                      200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0
                      200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0
                      200080E0400080E0600080E0800080E0A00080E0C00080E0E000C0000000C000
                      2000C0004000C0006000C0008000C000A000C000C000C000E000C0200000C020
                      2000C0204000C0206000C0208000C020A000C020C000C020E000C0400000C040
                      2000C0404000C0406000C0408000C040A000C040C000C040E000C0600000C060
                      2000C0604000C0606000C0608000C060A000C060C000C060E000C0800000C080
                      2000C0804000C0806000C0808000C080A000C080C000C080E000C0A00000C0A0
                      2000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C0
                      2000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000
                      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070000000000000000000007070707070707070707070707070707070707
                      0707070707070707070000000000000000000000000000070707070707070707
                      0707070707070707070707070707070707070700000000000000000000070707
                      0707070707070707070707070707070707070707070707070700000000000000
                      0000000000000007070707070707070707070707070707070707070707070707
                      0707070000000000000000000007070707070707070707070707070707070707
                      0707070707070707070000000000000000000000000000070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      07070707070707070707}
                  end
                  object btnUltimasChamadasLayoutNomeClienteAlinhaDireita: TSpeedButton
                    Left = 325
                    Top = 15
                    Width = 23
                    Height = 22
                    GroupIndex = 3
                    Glyph.Data = {
                      C6050000424DC605000000000000360400002800000014000000140000000100
                      0800000000009001000000000000000000000001000000000000000000000000
                      80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
                      A6000020400000206000002080000020A0000020C0000020E000004000000040
                      20000040400000406000004080000040A0000040C0000040E000006000000060
                      20000060400000606000006080000060A0000060C0000060E000008000000080
                      20000080400000806000008080000080A0000080C0000080E00000A0000000A0
                      200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0
                      200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0
                      200000E0400000E0600000E0800000E0A00000E0C00000E0E000400000004000
                      20004000400040006000400080004000A0004000C0004000E000402000004020
                      20004020400040206000402080004020A0004020C0004020E000404000004040
                      20004040400040406000404080004040A0004040C0004040E000406000004060
                      20004060400040606000406080004060A0004060C0004060E000408000004080
                      20004080400040806000408080004080A0004080C0004080E00040A0000040A0
                      200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0
                      200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0
                      200040E0400040E0600040E0800040E0A00040E0C00040E0E000800000008000
                      20008000400080006000800080008000A0008000C0008000E000802000008020
                      20008020400080206000802080008020A0008020C0008020E000804000008040
                      20008040400080406000804080008040A0008040C0008040E000806000008060
                      20008060400080606000806080008060A0008060C0008060E000808000008080
                      20008080400080806000808080008080A0008080C0008080E00080A0000080A0
                      200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0
                      200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0
                      200080E0400080E0600080E0800080E0A00080E0C00080E0E000C0000000C000
                      2000C0004000C0006000C0008000C000A000C000C000C000E000C0200000C020
                      2000C0204000C0206000C0208000C020A000C020C000C020E000C0400000C040
                      2000C0404000C0406000C0408000C040A000C040C000C040E000C0600000C060
                      2000C0604000C0606000C0608000C060A000C060C000C060E000C0800000C080
                      2000C0804000C0806000C0808000C080A000C080C000C080E000C0A00000C0A0
                      2000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C0
                      2000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000
                      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070707000000000000000000000707070707070707070707070707070707
                      0707070707070707070000000000000000000000000000070707070707070707
                      0707070707070707070707070707070707070707070000000000000000000007
                      0707070707070707070707070707070707070707070707070700000000000000
                      0000000000000007070707070707070707070707070707070707070707070707
                      0707070707000000000000000000000707070707070707070707070707070707
                      0707070707070707070000000000000000000000000000070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      0707070707070707070707070707070707070707070707070707070707070707
                      07070707070707070707}
                  end
                  object edUltimasChamadasLayoutNomeClienteX: TDBEdit
                    Left = 26
                    Top = 17
                    Width = 33
                    Height = 21
                    DataField = 'LAYOUTNOMECLIENTEX'
                    DataSource = dscPaineis
                    TabOrder = 0
                  end
                  object edUltimasChamadasLayoutNomeClienteY: TDBEdit
                    Left = 86
                    Top = 17
                    Width = 33
                    Height = 21
                    DataField = 'LAYOUTNOMECLIENTEY'
                    DataSource = dscPaineis
                    TabOrder = 1
                  end
                  object edUltimasChamadasLayoutNomeClienteLarg: TDBEdit
                    Left = 162
                    Top = 17
                    Width = 33
                    Height = 21
                    DataField = 'LAYOUTNOMECLIENTELARG'
                    DataSource = dscPaineis
                    TabOrder = 2
                  end
                  object edUltimasChamadasLayoutNomeClienteAlt: TDBEdit
                    Left = 229
                    Top = 17
                    Width = 33
                    Height = 21
                    DataField = 'LAYOUTNOMECLIENTEALT'
                    DataSource = dscPaineis
                    TabOrder = 3
                  end
                end
                object chkUltimasChamadasLayoutMostrarNomeCliente: TDBCheckBox
                  Left = 13
                  Top = 108
                  Width = 260
                  Height = 17
                  Caption = 'Mostrar nome do cliente'
                  DataField = 'MOSTRARNOMECLIENTE'
                  DataSource = dscPaineis
                  TabOrder = 4
                  ValueChecked = 'T'
                  ValueUnchecked = 'F'
                end
                object groupUltimasChamadasLayoutDisposicao: TGroupBox
                  Left = 5
                  Top = 159
                  Width = 100
                  Height = 71
                  Caption = 'Disposi'#231#227'o'
                  TabOrder = 6
                  object rbUltimasChamadasDisposicaoEmLinhas: TRadioButton
                    Left = 10
                    Top = 16
                    Width = 55
                    Height = 16
                    Caption = 'Linhas'
                    Checked = True
                    TabOrder = 0
                    TabStop = True
                  end
                  object rbUltimasChamadasDisposicaoEmColunas: TRadioButton
                    Left = 10
                    Top = 47
                    Width = 66
                    Height = 17
                    Caption = 'Colunas'
                    TabOrder = 1
                  end
                end
                object edUltimasChamadasQuantidade: TDBEdit
                  Left = 327
                  Top = 163
                  Width = 31
                  Height = 21
                  DataField = 'QUANTIDADE'
                  DataSource = dscPaineis
                  TabOrder = 7
                end
                object edUltimasChamadasEspacamento: TDBEdit
                  Left = 327
                  Top = 188
                  Width = 31
                  Height = 21
                  DataField = 'ESPACAMENTO'
                  DataSource = dscPaineis
                  TabOrder = 9
                end
                object edUltimasChamadasAtraso: TDBEdit
                  Left = 327
                  Top = 213
                  Width = 31
                  Height = 21
                  DataField = 'ATRASO'
                  DataSource = dscPaineis
                  TabOrder = 8
                end
              end
            end
          end
          object tbsDataHora: TTabSheet
            Caption = 'Data e Hora'
            ImageIndex = 5
            object pnlDataHora: TGroupBox
              Left = 0
              Top = 0
              Width = 388
              Height = 387
              Align = alClient
              Caption = '&Data e hora'
              TabOrder = 0
              object groupDataHoraFonte: TGroupBox
                Left = 5
                Top = 13
                Width = 366
                Height = 43
                Caption = '&Fonte'
                TabOrder = 0
                object btnDataHoraNegrito: TJvSpeedButton
                  Left = 300
                  Top = 15
                  Width = 20
                  Height = 22
                  AllowAllUp = True
                  Caption = 'N'
                  GroupIndex = 2
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -13
                  Font.Name = 'Times New Roman'
                  Font.Style = [fsBold]
                  HotTrackFont.Charset = DEFAULT_CHARSET
                  HotTrackFont.Color = clWindowText
                  HotTrackFont.Height = -13
                  HotTrackFont.Name = 'Times New Roman'
                  HotTrackFont.Style = []
                  ParentFont = False
                end
                object btnDataHoraItalico: TJvSpeedButton
                  Left = 320
                  Top = 15
                  Width = 20
                  Height = 22
                  AllowAllUp = True
                  Caption = 'I'
                  GroupIndex = 3
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -13
                  Font.Name = 'Times New Roman'
                  Font.Style = [fsItalic]
                  HotTrackFont.Charset = DEFAULT_CHARSET
                  HotTrackFont.Color = clWindowText
                  HotTrackFont.Height = -13
                  HotTrackFont.Name = 'Times New Roman'
                  HotTrackFont.Style = []
                  ParentFont = False
                end
                object btnDataHoraSublinhado: TJvSpeedButton
                  Left = 340
                  Top = 15
                  Width = 20
                  Height = 22
                  AllowAllUp = True
                  Caption = 'S'
                  GroupIndex = 4
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -13
                  Font.Name = 'Times New Roman'
                  Font.Style = [fsUnderline]
                  HotTrackFont.Charset = DEFAULT_CHARSET
                  HotTrackFont.Color = clWindowText
                  HotTrackFont.Height = -13
                  HotTrackFont.Name = 'Times New Roman'
                  HotTrackFont.Style = []
                  ParentFont = False
                end
                object cmbDataHoraFonte: TJvFontComboBox
                  Left = 5
                  Top = 15
                  Width = 190
                  Height = 22
                  DroppedDownWidth = 190
                  MaxMRUCount = 0
                  FontName = 'Dubai'
                  ItemIndex = 137
                  Options = [foWysiWyg]
                  ParentShowHint = False
                  ShowHint = True
                  Sorted = True
                  TabOrder = 0
                end
                object cmbDataHoraFontSize: TDBComboBox
                  Left = 199
                  Top = 15
                  Width = 51
                  Height = 21
                  DataField = 'FONTESIZE'
                  DataSource = dscPaineis
                  Items.Strings = (
                    '8'
                    '10'
                    '11'
                    '12'
                    '13'
                    '14'
                    '16'
                    '18'
                    '20'
                    '22'
                    '24'
                    '26'
                    '28'
                    '30'
                    '36'
                    '40'
                    '48'
                    '70'
                    '72')
                  TabOrder = 1
                end
                object cmbDataHoraFontColor: TJvOfficeColorButton
                  Left = 251
                  Top = 15
                  Width = 47
                  Height = 22
                  ColorDialogOptions = [cdSolidColor, cdAnyColor]
                  TabOrder = 2
                  Flat = False
                  SelectedColor = clDefault
                  HotTrackFont.Charset = DEFAULT_CHARSET
                  HotTrackFont.Color = clWindowText
                  HotTrackFont.Height = -11
                  HotTrackFont.Name = 'MS Sans Serif'
                  HotTrackFont.Style = []
                  Properties.ShowDefaultColor = False
                  Properties.NoneColorCaption = 'No Color'
                  Properties.DefaultColorCaption = 'Automatic'
                  Properties.CustomColorCaption = 'Other Colors...'
                  Properties.NoneColorHint = 'No Color'
                  Properties.DefaultColorHint = 'Automatic'
                  Properties.CustomColorHint = 'Other Colors...'
                  Properties.NoneColorFont.Charset = DEFAULT_CHARSET
                  Properties.NoneColorFont.Color = clWindowText
                  Properties.NoneColorFont.Height = -11
                  Properties.NoneColorFont.Name = 'MS Sans Serif'
                  Properties.NoneColorFont.Style = []
                  Properties.DefaultColorFont.Charset = DEFAULT_CHARSET
                  Properties.DefaultColorFont.Color = clWindowText
                  Properties.DefaultColorFont.Height = -11
                  Properties.DefaultColorFont.Name = 'MS Sans Serif'
                  Properties.DefaultColorFont.Style = []
                  Properties.CustomColorFont.Charset = DEFAULT_CHARSET
                  Properties.CustomColorFont.Color = clWindowText
                  Properties.CustomColorFont.Height = -11
                  Properties.CustomColorFont.Name = 'MS Sans Serif'
                  Properties.CustomColorFont.Style = []
                  Properties.TopMargin = 40
                  Properties.FloatWindowCaption = 'Color Window'
                  Properties.DragBarHint = 'Drag to float'
                end
              end
              object groupDataHoraOutras: TGroupBox
                Left = 5
                Top = 101
                Width = 366
                Height = 43
                Caption = '&Outras'
                TabOrder = 2
                object Label8: TLabel
                  Left = 5
                  Top = 19
                  Width = 52
                  Height = 13
                  Caption = 'Formato:'
                end
                object edDataHoraFormato: TDBEdit
                  Left = 63
                  Top = 15
                  Width = 294
                  Height = 21
                  DataField = 'FORMATO'
                  DataSource = dscPaineis
                  TabOrder = 0
                end
              end
              object groupDataHoraMargens: TGroupBox
                Left = 5
                Top = 56
                Width = 366
                Height = 43
                Caption = 'Margens'
                TabOrder = 1
                object Label18: TLabel
                  Left = 5
                  Top = 20
                  Width = 31
                  Height = 13
                  Caption = 'Sup.:'
                end
                object Label19: TLabel
                  Left = 106
                  Top = 20
                  Width = 24
                  Height = 13
                  Caption = 'Inf.:'
                end
                object Label20: TLabel
                  Left = 194
                  Top = 20
                  Width = 29
                  Height = 13
                  Caption = 'Esq.:'
                end
                object Label21: TLabel
                  Left = 294
                  Top = 20
                  Width = 24
                  Height = 13
                  Caption = 'Dir.:'
                end
                object edDataHoraMargemSuperior: TDBEdit
                  Left = 35
                  Top = 16
                  Width = 40
                  Height = 21
                  DataField = 'MARGEMSUPERIOR'
                  DataSource = dscPaineis
                  TabOrder = 0
                end
                object edDataHoraMargemInferior: TDBEdit
                  Left = 129
                  Top = 16
                  Width = 40
                  Height = 21
                  DataField = 'MARGEMINFERIOR'
                  DataSource = dscPaineis
                  TabOrder = 1
                end
                object edDataHoraMargemEsquerda: TDBEdit
                  Left = 223
                  Top = 16
                  Width = 40
                  Height = 21
                  DataField = 'MARGEMESQUERDA'
                  DataSource = dscPaineis
                  TabOrder = 2
                end
                object edDataHoraMargemDireita: TDBEdit
                  Left = 318
                  Top = 16
                  Width = 40
                  Height = 21
                  DataField = 'MARGEMDIREITA'
                  DataSource = dscPaineis
                  TabOrder = 3
                end
              end
            end
          end
          object tbsVideo: TTabSheet
            Caption = 'V'#237'deo'
            ImageIndex = 6
            object pnlVideo: TGroupBox
              Left = 0
              Top = 0
              Width = 388
              Height = 387
              Align = alClient
              Caption = 'Videos'
              TabOrder = 0
              object lblTempoAlternancia: TLabel
                Left = 8
                Top = 224
                Width = 152
                Height = 13
                Caption = 'Tempo de Altern'#226'cia (min)'
              end
              object lstVideoFileNames: TListBox
                Left = 5
                Top = 24
                Width = 337
                Height = 149
                ItemHeight = 13
                ParentShowHint = False
                ShowHint = True
                TabOrder = 0
              end
              object BitBtn1: TBitBtn
                Left = 8
                Top = 176
                Width = 75
                Height = 25
                Caption = 'Adicionar...'
                TabOrder = 1
                OnClick = BitBtn1Click
              end
              object BitBtn2: TBitBtn
                Left = 88
                Top = 176
                Width = 75
                Height = 25
                Caption = 'Remover...'
                TabOrder = 2
                OnClick = BitBtn2Click
              end
              object btnSubir: TBitBtn
                Left = 347
                Top = 25
                Width = 24
                Height = 24
                Glyph.Data = {
                  C6050000424DC605000000000000360400002800000014000000140000000100
                  0800000000009001000000000000000000000001000000010000000000008080
                  8000000080000080800000800000808000008000000080008000408080004040
                  0000FF80000080400000FF00400000408000FFFFFF00C0C0C0000000FF0000FF
                  FF0000FF0000FFFF0000FF000000FF00FF0080FFFF0080FF0000FFFF8000FF80
                  80008000FF004080FF00C0DCC000F0CAA600DEDED600DED6D600D6CEC600CECE
                  C600CEBDAD00CEB5B500C6C6BD00C6BDB500C6B5B500C6B5AD00BDBDB500BDBD
                  AD00BDB5AD00BDA59C00BD9C9400BD948C00B5BDBD00B5B5B500B5B5AD00B5AD
                  A500B5A59C00B59C9400B58C8400ADADB500ADA5B500ADA59C00AD9C9400AD94
                  8C00AD8C8400AD847300A5CED600A5C6C600A5BDBD00A5ADAD00A59C9C00A59C
                  9400A56B5A009CB5C6009CB5BD009CA5AD009C949C009C8C8C009C8473009C73
                  8C009C7384009C737B009C7373009C736B009C6B6300949CAD0094737B009473
                  730094635A008CB5C6008CA5AD008C9CAD008C94AD008C8C94008C7B7B008C6B
                  6B008C6363008C524A008C4A420084A5BD008494BD0084849C0084848C008473
                  8C008473840084737B0084737300846B730084637300845A5A0084525200844A
                  4200843929007B8CAD007B636B007B4A42007B39310073ADC600739CC600739C
                  B5007394BD00738CB50073849C00737B9C00737B8C00737B7B0073738400736B
                  730073637300735A630073525200734A42007339420073393100733131006B84
                  AD006B849C006B7B9C006B7B84006B7394006B5263006B4A4A006B4242006B39
                  39006B3131006B293900639CBD00639CAD00638CBD00638CAD006384B500637B
                  AD00637B9C00637B8C00636B94006363730063525A00634A4A00633939006339
                  31006331390063313100632929005A9CAD005A8CC6005A8CAD005A84BD005A7B
                  B5005A73A5005A5263005A3939005294B5005284AD0052849C00527BB500527B
                  8C00526BAD0052639400525A8400525A6B0052527300524A6300524273005242
                  5200523131004A9CAD004A84A5004A639C004A5284004A4A73004A394A004A31
                  4A004A3139004A3131004A294A004A2931004A2929004A214A00428494004263
                  8400425A9C00425A6B004252940042527B00424A63004242630042425A004231
                  3900423131004231290042312100422139004221210042102100396B9C003952
                  940039528C0039527300394A630039425A003939520039314A00393142003931
                  31003184AD0031638400315A73003152730031526B00314A8C00314273003142
                  630031425A00313952003131420031313100299CAD002984AD0029428C002942
                  5200293952002939420029314A002929630029213100217B9400217B8C00216B
                  9C0021529C00214A5A0021425200213142002131180021184A00211829002118
                  2100185A730018527300185263001839730018396300106384000F0F0F0F0F0F
                  0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
                  0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
                  0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F01010101010F0F0F0F0F0F0F0F0F
                  0F0F0F0F0F0606060606010F0F0F0F0F0F0F0F0F0F0F0F0F0F1414141406010F
                  0F0F0F0F0F0F0F0F0F0F0F0F0F1414141406010F0F0F0F0F0F0F0F0F0F0F0F0F
                  0F1414141406010F0F0F0F0F0F0F0F0F0F0F0F0F0F1414141406010F0F0F0F0F
                  0F0F0F0F0F0F0F0F0F14141414060101010F0F0F0F0F0F0F0F0F0F1414141414
                  141414140F0F0F0F0F0F0F0F0F0F0F0F141414141414140F0F0F0F0F0F0F0F0F
                  0F0F0F0F0F14141414140F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F1414140F0F0F
                  0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F140F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
                  0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
                  0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
                  0F0F0F0F0F0F0F0F0F0F}
                TabOrder = 3
                OnClick = btnSubirClick
              end
              object btnDescer: TBitBtn
                Left = 347
                Top = 51
                Width = 24
                Height = 24
                Glyph.Data = {
                  C6050000424DC605000000000000360400002800000014000000140000000100
                  0800000000009001000000000000000000000001000000010000000000008080
                  8000000080000080800000800000808000008000000080008000408080004040
                  0000FF80000080400000FF00400000408000FFFFFF00C0C0C0000000FF0000FF
                  FF0000FF0000FFFF0000FF000000FF00FF0080FFFF0080FF0000FFFF8000FF80
                  80008000FF004080FF00C0DCC000F0CAA600DEDED600DED6D600D6CEC600CECE
                  C600CEBDAD00CEB5B500C6C6BD00C6BDB500C6B5B500C6B5AD00BDBDB500BDBD
                  AD00BDB5AD00BDA59C00BD9C9400BD948C00B5BDBD00B5B5B500B5B5AD00B5AD
                  A500B5A59C00B59C9400B58C8400ADADB500ADA5B500ADA59C00AD9C9400AD94
                  8C00AD8C8400AD847300A5CED600A5C6C600A5BDBD00A5ADAD00A59C9C00A59C
                  9400A56B5A009CB5C6009CB5BD009CA5AD009C949C009C8C8C009C8473009C73
                  8C009C7384009C737B009C7373009C736B009C6B6300949CAD0094737B009473
                  730094635A008CB5C6008CA5AD008C9CAD008C94AD008C8C94008C7B7B008C6B
                  6B008C6363008C524A008C4A420084A5BD008494BD0084849C0084848C008473
                  8C008473840084737B0084737300846B730084637300845A5A0084525200844A
                  4200843929007B8CAD007B636B007B4A42007B39310073ADC600739CC600739C
                  B5007394BD00738CB50073849C00737B9C00737B8C00737B7B0073738400736B
                  730073637300735A630073525200734A42007339420073393100733131006B84
                  AD006B849C006B7B9C006B7B84006B7394006B5263006B4A4A006B4242006B39
                  39006B3131006B293900639CBD00639CAD00638CBD00638CAD006384B500637B
                  AD00637B9C00637B8C00636B94006363730063525A00634A4A00633939006339
                  31006331390063313100632929005A9CAD005A8CC6005A8CAD005A84BD005A7B
                  B5005A73A5005A5263005A3939005294B5005284AD0052849C00527BB500527B
                  8C00526BAD0052639400525A8400525A6B0052527300524A6300524273005242
                  5200523131004A9CAD004A84A5004A639C004A5284004A4A73004A394A004A31
                  4A004A3139004A3131004A294A004A2931004A2929004A214A00428494004263
                  8400425A9C00425A6B004252940042527B00424A63004242630042425A004231
                  3900423131004231290042312100422139004221210042102100396B9C003952
                  940039528C0039527300394A630039425A003939520039314A00393142003931
                  31003184AD0031638400315A73003152730031526B00314A8C00314273003142
                  630031425A00313952003131420031313100299CAD002984AD0029428C002942
                  5200293952002939420029314A002929630029213100217B9400217B8C00216B
                  9C0021529C00214A5A0021425200213142002131180021184A00211829002118
                  2100185A730018527300185263001839730018396300106384000F0F0F0F0F0F
                  0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
                  0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
                  010F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0601010F0F0F0F0F0F0F0F0F0F
                  0F0F0F0F0F0F14140601010F0F0F0F0F0F0F0F0F0F0F0F0F0F14141414060101
                  0F0F0F0F0F0F0F0F0F0F0F0F1414141414140601010F0F0F0F0F0F0F0F0F0F14
                  14141414140606060F0F0F0F0F0F0F0F0F0F0F0F0F1414141406010F0F0F0F0F
                  0F0F0F0F0F0F0F0F0F1414141406010F0F0F0F0F0F0F0F0F0F0F0F0F0F141414
                  1406010F0F0F0F0F0F0F0F0F0F0F0F0F0F1414141406010F0F0F0F0F0F0F0F0F
                  0F0F0F0F0F1414141406010F0F0F0F0F0F0F0F0F0F0F0F0F0F14141414060F0F
                  0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
                  0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
                  0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
                  0F0F0F0F0F0F0F0F0F0F}
                TabOrder = 4
                OnClick = btnDescerClick
              end
              object edtTempoAlternancia: TDBEdit
                Left = 166
                Top = 221
                Width = 49
                Height = 21
                DataField = 'TEMPOALTERNANCIA'
                DataSource = dscPaineis
                TabOrder = 5
              end
            end
          end
          object tbsFlash: TTabSheet
            Caption = 'Flash'
            ImageIndex = 7
            ExplicitLeft = 0
            ExplicitTop = 0
            ExplicitWidth = 0
            ExplicitHeight = 0
            object pnlFlash: TGroupBox
              Left = 0
              Top = 0
              Width = 388
              Height = 387
              Align = alClient
              Caption = '&Flash'
              TabOrder = 0
              object Label4: TLabel
                Left = 10
                Top = 29
                Width = 49
                Height = 13
                Caption = '&Arquivo:'
              end
              object Label5: TLabel
                Left = 10
                Top = 65
                Width = 131
                Height = 13
                Caption = 'Atualizar a cada (&seg):'
              end
              object btnFlashFilName: TSpeedButton
                Left = 352
                Top = 24
                Width = 31
                Height = 23
                Glyph.Data = {
                  76010000424D7601000000000000760000002800000020000000100000000100
                  04000000000000010000120B0000120B00001000000000000000000000000000
                  800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
                  FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
                  5555555555555555555555555555555555555555555555555555555555555555
                  555555555555555555555555555555555555555FFFFFFFFFF555550000000000
                  55555577777777775F55500B8B8B8B8B05555775F555555575F550F0B8B8B8B8
                  B05557F75F555555575F50BF0B8B8B8B8B0557F575FFFFFFFF7F50FBF0000000
                  000557F557777777777550BFBFBFBFB0555557F555555557F55550FBFBFBFBF0
                  555557F555555FF7555550BFBFBF00055555575F555577755555550BFBF05555
                  55555575FFF75555555555700007555555555557777555555555555555555555
                  5555555555555555555555555555555555555555555555555555}
                NumGlyphs = 2
                OnClick = btnFlashFilNameClick
              end
              object edFlashRefresh: TDBEdit
                Left = 147
                Top = 62
                Width = 31
                Height = 21
                DataSource = dscPaineis
                TabOrder = 0
              end
              object edFlashFileName: TDBEdit
                Left = 65
                Top = 26
                Width = 281
                Height = 21
                DataField = 'FLASHFILE'
                DataSource = dscPaineis
                TabOrder = 1
              end
            end
          end
          object tbsJornalEletronico: TTabSheet
            Caption = 'Jornal Eletr'#244'nico'
            ImageIndex = 8
            object GroupBox3: TGroupBox
              Left = 0
              Top = 0
              Width = 388
              Height = 387
              Align = alClient
              Caption = 'Jornal Eletr'#244'nico'
              TabOrder = 0
              object Label30: TLabel
                Left = 11
                Top = 72
                Width = 57
                Height = 13
                Caption = 'Intervalo:'
              end
              object groupJornalEletronicoFonte: TGroupBox
                Left = 5
                Top = 13
                Width = 366
                Height = 43
                Caption = '&Fonte'
                TabOrder = 0
                object btnJornalEletronicoNegrito: TJvSpeedButton
                  Left = 300
                  Top = 15
                  Width = 20
                  Height = 22
                  AllowAllUp = True
                  Caption = 'N'
                  GroupIndex = 2
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -13
                  Font.Name = 'Times New Roman'
                  Font.Style = [fsBold]
                  HotTrackFont.Charset = DEFAULT_CHARSET
                  HotTrackFont.Color = clWindowText
                  HotTrackFont.Height = -13
                  HotTrackFont.Name = 'Times New Roman'
                  HotTrackFont.Style = []
                  ParentFont = False
                end
                object btnJornalEletronicoItalico: TJvSpeedButton
                  Left = 320
                  Top = 15
                  Width = 20
                  Height = 22
                  AllowAllUp = True
                  Caption = 'I'
                  GroupIndex = 3
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -13
                  Font.Name = 'Times New Roman'
                  Font.Style = [fsItalic]
                  HotTrackFont.Charset = DEFAULT_CHARSET
                  HotTrackFont.Color = clWindowText
                  HotTrackFont.Height = -13
                  HotTrackFont.Name = 'Times New Roman'
                  HotTrackFont.Style = []
                  ParentFont = False
                end
                object btnJornalEletronicoSublinhado: TJvSpeedButton
                  Left = 340
                  Top = 15
                  Width = 20
                  Height = 22
                  AllowAllUp = True
                  Caption = 'S'
                  GroupIndex = 4
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -13
                  Font.Name = 'Times New Roman'
                  Font.Style = [fsUnderline]
                  HotTrackFont.Charset = DEFAULT_CHARSET
                  HotTrackFont.Color = clWindowText
                  HotTrackFont.Height = -13
                  HotTrackFont.Name = 'Times New Roman'
                  HotTrackFont.Style = []
                  ParentFont = False
                end
                object cmbJornalEletronicoFonte: TJvFontComboBox
                  Left = 5
                  Top = 15
                  Width = 190
                  Height = 22
                  DroppedDownWidth = 190
                  MaxMRUCount = 0
                  FontName = 'Dubai'
                  ItemIndex = 137
                  Options = [foWysiWyg]
                  ParentShowHint = False
                  ShowHint = True
                  Sorted = True
                  TabOrder = 0
                end
                object cmbJornalEletronicoFontSize: TDBComboBox
                  Left = 196
                  Top = 15
                  Width = 51
                  Height = 21
                  DataField = 'FONTESIZE'
                  DataSource = dscPaineis
                  Items.Strings = (
                    '8'
                    '10'
                    '11'
                    '12'
                    '13'
                    '14'
                    '16'
                    '18'
                    '20'
                    '22'
                    '24'
                    '26'
                    '28'
                    '30'
                    '36'
                    '40'
                    '48'
                    '70'
                    '72')
                  TabOrder = 1
                end
                object cmbJornalEletronicoFontColor: TJvOfficeColorButton
                  Left = 251
                  Top = 15
                  Width = 47
                  Height = 22
                  ColorDialogOptions = [cdSolidColor, cdAnyColor]
                  TabOrder = 2
                  Flat = False
                  SelectedColor = clDefault
                  HotTrackFont.Charset = DEFAULT_CHARSET
                  HotTrackFont.Color = clWindowText
                  HotTrackFont.Height = -11
                  HotTrackFont.Name = 'MS Sans Serif'
                  HotTrackFont.Style = []
                  Properties.ShowDefaultColor = False
                  Properties.NoneColorCaption = 'No Color'
                  Properties.DefaultColorCaption = 'Automatic'
                  Properties.CustomColorCaption = 'Other Colors...'
                  Properties.NoneColorHint = 'No Color'
                  Properties.DefaultColorHint = 'Automatic'
                  Properties.CustomColorHint = 'Other Colors...'
                  Properties.NoneColorFont.Charset = DEFAULT_CHARSET
                  Properties.NoneColorFont.Color = clWindowText
                  Properties.NoneColorFont.Height = -11
                  Properties.NoneColorFont.Name = 'MS Sans Serif'
                  Properties.NoneColorFont.Style = []
                  Properties.DefaultColorFont.Charset = DEFAULT_CHARSET
                  Properties.DefaultColorFont.Color = clWindowText
                  Properties.DefaultColorFont.Height = -11
                  Properties.DefaultColorFont.Name = 'MS Sans Serif'
                  Properties.DefaultColorFont.Style = []
                  Properties.CustomColorFont.Charset = DEFAULT_CHARSET
                  Properties.CustomColorFont.Color = clWindowText
                  Properties.CustomColorFont.Height = -11
                  Properties.CustomColorFont.Name = 'MS Sans Serif'
                  Properties.CustomColorFont.Style = []
                  Properties.TopMargin = 40
                  Properties.FloatWindowCaption = 'Color Window'
                  Properties.DragBarHint = 'Drag to float'
                end
              end
              object edtJornalEletronicoInterval: TDBEdit
                Left = 74
                Top = 69
                Width = 57
                Height = 21
                DataField = 'INTERVALOVERIFICACAO'
                DataSource = dscPaineis
                TabOrder = 1
              end
            end
          end
          object tbsIndicadoresDePerformance: TTabSheet
            Caption = 'Indicadores de Performance'
            ImageIndex = 9
            ExplicitLeft = 0
            ExplicitTop = 0
            ExplicitWidth = 0
            ExplicitHeight = 0
            object GroupBox7: TGroupBox
              Left = 0
              Top = 0
              Width = 388
              Height = 89
              Align = alTop
              Caption = '&HTML'
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
              object Label22: TLabel
                Left = 10
                Top = 29
                Width = 39
                Height = 13
                Caption = '&Arquivo:'
              end
              object btnHTMLFileName: TSpeedButton
                Left = 351
                Top = 24
                Width = 31
                Height = 23
                Glyph.Data = {
                  76010000424D7601000000000000760000002800000020000000100000000100
                  04000000000000010000120B0000120B00001000000000000000000000000000
                  800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
                  FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
                  5555555555555555555555555555555555555555555555555555555555555555
                  555555555555555555555555555555555555555FFFFFFFFFF555550000000000
                  55555577777777775F55500B8B8B8B8B05555775F555555575F550F0B8B8B8B8
                  B05557F75F555555575F50BF0B8B8B8B8B0557F575FFFFFFFF7F50FBF0000000
                  000557F557777777777550BFBFBFBFB0555557F555555557F55550FBFBFBFBF0
                  555557F555555FF7555550BFBFBF00055555575F555577755555550BFBF05555
                  55555575FFF75555555555700007555555555557777555555555555555555555
                  5555555555555555555555555555555555555555555555555555}
                NumGlyphs = 2
                OnClick = btnHTMLFileNameClick
              end
              object edHTMLFileName: TDBEdit
                Left = 64
                Top = 25
                Width = 281
                Height = 21
                DataField = 'NOMEARQUIVOHTML'
                DataSource = dscPaineis
                TabOrder = 0
              end
              object chkCorDaFonteAcompanhaNivelPI: TDBCheckBox
                Left = 10
                Top = 60
                Width = 266
                Height = 17
                Caption = 'Valor do PI acompanha a cor do respectivo n'#237'vel'
                DataField = 'VALORACOMPANHACORDONIVEL'
                DataSource = dscPaineis
                TabOrder = 1
                ValueChecked = 'T'
                ValueUnchecked = 'F'
                Visible = False
              end
            end
            object GroupBox1: TGroupBox
              Left = 0
              Top = 89
              Width = 388
              Height = 298
              Align = alClient
              Caption = ' Som '
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 1
              object lblIndicador: TLabel
                Left = 8
                Top = 21
                Width = 44
                Height = 13
                Caption = 'Indicador'
              end
              object lblArquivoSomPI: TLabel
                Left = 8
                Top = 50
                Width = 36
                Height = 13
                Caption = 'Arquivo'
              end
              object edtIndicador: TDBEdit
                Left = 64
                Top = 17
                Width = 81
                Height = 21
                DataField = 'INDICADORSOMPI'
                DataSource = dscPaineis
                TabOrder = 0
              end
              object edtSomPI: TDBEdit
                Left = 64
                Top = 46
                Width = 281
                Height = 21
                DataField = 'ARQUIVOSOMPI'
                DataSource = dscPaineis
                TabOrder = 1
              end
            end
          end
          object tbsPlayListManager: TTabSheet
            Caption = 'Playlist Corporativo'
            ImageIndex = 10
            object GroupBox2: TGroupBox
              Left = 0
              Top = 0
              Width = 388
              Height = 387
              Align = alClient
              Caption = '&Dados PlayList Corporativo'
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
              object Label55: TLabel
                Left = 13
                Top = 32
                Width = 14
                Height = 13
                Caption = 'ID:'
              end
              object Label56: TLabel
                Left = 13
                Top = 62
                Width = 73
                Height = 13
                Caption = 'Tipo do Banco:'
              end
              object Label57: TLabel
                Left = 13
                Top = 92
                Width = 74
                Height = 13
                Caption = 'Host do Banco:'
              end
              object Label58: TLabel
                Left = 13
                Top = 122
                Width = 77
                Height = 13
                Caption = 'Porta do Banco:'
              end
              object lblBancoDados: TLabel
                Left = 13
                Top = 152
                Width = 134
                Height = 13
                Caption = 'Nome do Arquivo do Banco:'
              end
              object Label60: TLabel
                Left = 13
                Top = 182
                Width = 88
                Height = 13
                Caption = 'Usuario do Banco:'
              end
              object Label61: TLabel
                Left = 13
                Top = 212
                Width = 83
                Height = 13
                Caption = 'Senha do Banco:'
              end
              object Label62: TLabel
                Left = 13
                Top = 242
                Width = 71
                Height = 13
                Caption = 'Diretorio Local:'
              end
              object Label63: TLabel
                Left = 13
                Top = 273
                Width = 141
                Height = 13
                Caption = 'Intvervalo de Verifica'#231#227'o Min:'
              end
              object edtIDTVPlayListManager: TDBEdit
                Left = 155
                Top = 28
                Width = 60
                Height = 21
                DataField = 'IDTVPLAYLISTMANAGER'
                DataSource = dscPaineis
                TabOrder = 0
              end
              object cbTipoBancoPlayList: TDBComboBox
                Left = 155
                Top = 58
                Width = 206
                Height = 21
                Style = csDropDownList
                DataField = 'TIPOBANCO'
                DataSource = dscPaineis
                Items.Strings = (
                  'FireBird'
                  'SQL Express')
                TabOrder = 1
              end
              object edtHostBancoPlayList: TDBEdit
                Left = 155
                Top = 85
                Width = 206
                Height = 21
                DataField = 'HOSTBANCO'
                DataSource = dscPaineis
                TabOrder = 2
              end
              object edtPortaBancoPlayList: TDBEdit
                Left = 155
                Top = 118
                Width = 60
                Height = 21
                DataField = 'PORTABANCO'
                DataSource = dscPaineis
                TabOrder = 3
              end
              object edtNomeArquivoBancoPlayList: TDBEdit
                Left = 155
                Top = 148
                Width = 206
                Height = 21
                DataField = 'NOMEARQUIVOBANCO'
                DataSource = dscPaineis
                TabOrder = 4
              end
              object edtUsuarioBancoPlayList: TDBEdit
                Left = 155
                Top = 178
                Width = 206
                Height = 21
                DataField = 'USUARIOBANCO'
                DataSource = dscPaineis
                TabOrder = 5
              end
              object edtSenhaBancoPlayList: TDBEdit
                Left = 155
                Top = 208
                Width = 206
                Height = 21
                DataField = 'SENHABANCO'
                DataSource = dscPaineis
                PasswordChar = '*'
                TabOrder = 6
              end
              object edtDiretorioLocalPlayList: TDBEdit
                Left = 155
                Top = 238
                Width = 206
                Height = 21
                DataField = 'DIRETORIOLOCAL'
                DataSource = dscPaineis
                TabOrder = 7
              end
              object edtIntervaloVerificacaoPlayList: TDBEdit
                Left = 155
                Top = 269
                Width = 60
                Height = 21
                DataField = 'INTERVALOVERIFICACAO'
                DataSource = dscPaineis
                TabOrder = 8
              end
            end
          end
        end
      end
      object grpCodigoBarras: TGroupBox
        Left = 646
        Top = 231
        Width = 192
        Height = 133
        Anchors = [akRight, akBottom]
        Caption = ' Leitor de c'#243'digo de barras '
        TabOrder = 3
        object lblPortaLCDB: TLabel
          Left = 11
          Top = 49
          Width = 139
          Height = 13
          Caption = 'Porta Leitor C'#243'd. Barras'
          FocusControl = edtPortaLCDB
        end
        object chkUtilizarLeitorCodigoBarras: TDBCheckBox
          Left = 11
          Top = 26
          Width = 150
          Height = 17
          Caption = 'Utilizar'
          DataField = 'USECODEBAR'
          DataSource = dtsConfig
          TabOrder = 0
          ValueChecked = 'T'
          ValueUnchecked = 'F'
        end
        object edtPortaLCDB: TDBEdit
          Left = 11
          Top = 65
          Width = 166
          Height = 21
          DataField = 'CODEBARPORT'
          DataSource = dtsConfig
          TabOrder = 1
        end
      end
    end
    inherited pnlButtonSicsPA: TPanel
      Top = 574
      Width = 1048
      ExplicitTop = 574
      ExplicitWidth = 1048
      DesignSize = (
        1048
        50)
      inherited btnSair: TBitBtn
        Left = 933
        ExplicitLeft = 933
      end
      inherited btnSalvar: TBitBtn
        Left = 822
        Top = 6
        ExplicitLeft = 822
        ExplicitTop = 6
      end
    end
    inherited grpModulos: TGroupBox
      Height = 572
      ExplicitHeight = 572
      inherited btnSicsIncluir: TBitBtn
        Top = 445
        ExplicitTop = 445
      end
      inherited btnSicsExcluir: TBitBtn
        Left = 80
        Top = 447
        ExplicitLeft = 80
        ExplicitTop = 447
      end
      inherited btnCopiar: TBitBtn
        Top = 445
        ExplicitTop = 445
      end
      inherited grpGrid: TGroupBox
        Height = 426
        ExplicitHeight = 426
        inherited grdModulos: TDBGrid
          Height = 339
        end
        inherited pnlNovaConfig: TPanel
          Top = 354
          ExplicitTop = 354
        end
      end
    end
  end
  inherited dtsConfig: TDataSource
    Left = 40
    Top = 56
  end
  inherited CDSConfig: TClientDataSet
    Left = 112
    Top = 56
    object CDSConfigID: TIntegerField
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object CDSConfigCHAMADAINTERROMPEVIDEO: TStringField
      FieldName = 'CHAMADAINTERROMPEVIDEO'
      Origin = 'CHAMADAINTERROMPEVIDEO'
      FixedChar = True
      Size = 1
    end
    object CDSConfigMAXIMIZARMONITOR1: TStringField
      FieldName = 'MAXIMIZARMONITOR1'
      Origin = 'MAXIMIZARMONITOR1'
      FixedChar = True
      Size = 1
    end
    object CDSConfigMAXIMIZARMONITOR2: TStringField
      FieldName = 'MAXIMIZARMONITOR2'
      Origin = 'MAXIMIZARMONITOR2'
      FixedChar = True
      Size = 1
    end
    object CDSConfigFUNCIONASABADO: TStringField
      FieldName = 'FUNCIONASABADO'
      Origin = 'FUNCIONASABADO'
      FixedChar = True
      Size = 1
    end
    object CDSConfigFUNCIONADOMINGO: TStringField
      FieldName = 'FUNCIONADOMINGO'
      Origin = 'FUNCIONADOMINGO'
      FixedChar = True
      Size = 1
    end
    object CDSConfigUSECODEBAR: TStringField
      FieldName = 'USECODEBAR'
      Origin = 'USECODEBAR'
      FixedChar = True
      Size = 1
    end
    object CDSConfigIDPAINEL: TIntegerField
      FieldName = 'IDPAINEL'
      Origin = 'IDPAINEL'
    end
    object CDSConfigIDTV: TIntegerField
      FieldName = 'IDTV'
      Origin = 'IDTV'
    end
    object CDSConfigPORTAIPPAINEL: TIntegerField
      FieldName = 'PORTAIPPAINEL'
      Origin = 'PORTAIPPAINEL'
    end
    object CDSConfigLASTMUTE: TIntegerField
      FieldName = 'LASTMUTE'
      Origin = 'LASTMUTE'
    end
    object CDSConfigVOLUME: TIntegerField
      FieldName = 'VOLUME'
      Origin = 'VOLUME'
    end
    object CDSConfigDEM: TIntegerField
      FieldName = 'DEM'
      Origin = 'DEM'
    end
    object CDSConfigATEM: TIntegerField
      FieldName = 'ATEM'
      Origin = 'ATEM'
    end
    object CDSConfigCODEBARPORT: TStringField
      FieldName = 'CODEBARPORT'
      Origin = 'CODEBARPORT'
    end
    object CDSConfigINDICADORESPERMITIDOS: TStringField
      FieldName = 'INDICADORESPERMITIDOS'
      Origin = 'INDICADORESPERMITIDOS'
      Size = 400
    end
    object CDSConfigDEH: TIntegerField
      FieldName = 'DEH'
      Origin = 'DEH'
    end
    object CDSConfigATEH: TIntegerField
      FieldName = 'ATEH'
      Origin = 'ATEH'
    end
    object CDSConfigID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
    end
  end
  inherited dtsModulos: TDataSource
    Left = 40
    Top = 112
  end
  inherited CDSModulos: TClientDataSet
    Left = 112
    Top = 112
    object CDSModulosID: TIntegerField
      FieldName = 'ID'
      KeyFields = 'ID'
    end
    object CDSModulosTIPO: TIntegerField
      FieldName = 'TIPO'
    end
    object CDSModulosNOME: TStringField
      FieldName = 'NOME'
      Size = 30
    end
    object CDSModulosID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
    end
  end
  object qryNomePA: TFDQuery
    Connection = dmSicsMain.connOnLine
    SQL.Strings = (
      'SELECT ID, NOME FROM PAS WHERE ATIVO = '#39'T'#39)
    Left = 32
    Top = 168
  end
  object cdsNomePA: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspNomePA'
    Left = 32
    Top = 216
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
    Left = 112
    Top = 168
  end
  object dscNomePA: TDataSource
    DataSet = cdsNomePA
    Left = 112
    Top = 216
  end
  object cdsPaineis: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspPaineis'
    AfterScroll = cdsPaineisAfterScroll
    OnCalcFields = cdsPaineisCalcFields
    Left = 32
    Top = 320
    object cdsPaineisID: TIntegerField
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object cdsPaineisTIPO: TIntegerField
      FieldName = 'TIPO'
      Origin = 'TIPO'
    end
    object cdsPaineisBACKGROUNDFILE: TStringField
      FieldName = 'BACKGROUNDFILE'
      Origin = 'BACKGROUNDFILE'
      Size = 200
    end
    object cdsPaineisFONTE: TStringField
      FieldName = 'FONTE'
      Origin = 'FONTE'
      Size = 50
    end
    object cdsPaineisARQUIVOSOM: TStringField
      FieldName = 'ARQUIVOSOM'
      Origin = 'ARQUIVOSOM'
      Size = 200
    end
    object cdsPaineisFLASHFILE: TStringField
      FieldName = 'FLASHFILE'
      Origin = 'FLASHFILE'
      Size = 200
    end
    object cdsPaineisCAMINHODOEXECUTAVEL: TStringField
      FieldName = 'CAMINHODOEXECUTAVEL'
      Origin = 'CAMINHODOEXECUTAVEL'
      Size = 200
    end
    object cdsPaineisNOMEDAJANELA: TStringField
      FieldName = 'NOMEDAJANELA'
      Origin = 'NOMEDAJANELA'
      Size = 50
    end
    object cdsPaineisRESOLUCAOPADRAO: TStringField
      FieldName = 'RESOLUCAOPADRAO'
      Origin = 'RESOLUCAOPADRAO'
      FixedChar = True
      Size = 50
    end
    object cdsPaineisARQUIVOSVIDEO: TStringField
      FieldName = 'ARQUIVOSVIDEO'
      Origin = 'ARQUIVOSVIDEO'
      Size = 200
    end
    object cdsPaineisHOSTBANCO: TStringField
      FieldName = 'HOSTBANCO'
      Origin = 'HOSTBANCO'
      Size = 50
    end
    object cdsPaineisPORTABANCO: TStringField
      FieldName = 'PORTABANCO'
      Origin = 'PORTABANCO'
      Size = 50
    end
    object cdsPaineisNOMEARQUIVOBANCO: TStringField
      FieldName = 'NOMEARQUIVOBANCO'
      Origin = 'NOMEARQUIVOBANCO'
      Size = 200
    end
    object cdsPaineisUSUARIOBANCO: TStringField
      FieldName = 'USUARIOBANCO'
      Origin = 'USUARIOBANCO'
      Size = 50
    end
    object cdsPaineisSENHABANCO: TStringField
      FieldName = 'SENHABANCO'
      Origin = 'SENHABANCO'
      Size = 50
    end
    object cdsPaineisDIRETORIOLOCAL: TStringField
      FieldName = 'DIRETORIOLOCAL'
      Origin = 'DIRETORIOLOCAL'
      Size = 200
    end
    object cdsPaineisLAYOUTSENHAX: TIntegerField
      FieldName = 'LAYOUTSENHAX'
      Origin = 'LAYOUTSENHAX'
    end
    object cdsPaineisLAYOUTSENHAY: TIntegerField
      FieldName = 'LAYOUTSENHAY'
      Origin = 'LAYOUTSENHAY'
    end
    object cdsPaineisLAYOUTSENHALARG: TIntegerField
      FieldName = 'LAYOUTSENHALARG'
      Origin = 'LAYOUTSENHALARG'
    end
    object cdsPaineisLAYOUTSENHAALT: TIntegerField
      FieldName = 'LAYOUTSENHAALT'
      Origin = 'LAYOUTSENHAALT'
    end
    object cdsPaineisLAYOUTPAX: TIntegerField
      FieldName = 'LAYOUTPAX'
      Origin = 'LAYOUTPAX'
    end
    object cdsPaineisLAYOUTPAY: TIntegerField
      FieldName = 'LAYOUTPAY'
      Origin = 'LAYOUTPAY'
    end
    object cdsPaineisLAYOUTPALARG: TIntegerField
      FieldName = 'LAYOUTPALARG'
      Origin = 'LAYOUTPALARG'
    end
    object cdsPaineisLAYOUTPAALT: TIntegerField
      FieldName = 'LAYOUTPAALT'
      Origin = 'LAYOUTPAALT'
    end
    object cdsPaineisLAYOUTNOMECLIENTEX: TIntegerField
      FieldName = 'LAYOUTNOMECLIENTEX'
      Origin = 'LAYOUTNOMECLIENTEX'
    end
    object cdsPaineisLAYOUTNOMECLIENTEY: TIntegerField
      FieldName = 'LAYOUTNOMECLIENTEY'
      Origin = 'LAYOUTNOMECLIENTEY'
    end
    object cdsPaineisLAYOUTNOMECLIENTELARG: TIntegerField
      FieldName = 'LAYOUTNOMECLIENTELARG'
      Origin = 'LAYOUTNOMECLIENTELARG'
    end
    object cdsPaineisLAYOUTNOMECLIENTEALT: TIntegerField
      FieldName = 'LAYOUTNOMECLIENTEALT'
      Origin = 'LAYOUTNOMECLIENTEALT'
    end
    object cdsPaineisQUANTIDADE: TStringField
      FieldName = 'QUANTIDADE'
      Origin = 'QUANTIDADE'
      Size = 50
    end
    object cdsPaineisATRASO: TStringField
      FieldName = 'ATRASO'
      Origin = 'ATRASO'
      Size = 50
    end
    object cdsPaineisESPACAMENTO: TStringField
      FieldName = 'ESPACAMENTO'
      Origin = 'ESPACAMENTO'
      Size = 50
    end
    object cdsPaineisPASPERMITIDAS: TStringField
      FieldName = 'PASPERMITIDAS'
      Origin = 'PASPERMITIDAS'
      FixedChar = True
      Size = 400
    end
    object cdsPaineisMARGEMSUPERIOR: TIntegerField
      FieldName = 'MARGEMSUPERIOR'
      Origin = 'MARGEMSUPERIOR'
    end
    object cdsPaineisMARGEMINFERIOR: TIntegerField
      FieldName = 'MARGEMINFERIOR'
      Origin = 'MARGEMINFERIOR'
    end
    object cdsPaineisMARGEMESQUERDA: TIntegerField
      FieldName = 'MARGEMESQUERDA'
      Origin = 'MARGEMESQUERDA'
    end
    object cdsPaineisMARGEMDIREITA: TIntegerField
      FieldName = 'MARGEMDIREITA'
      Origin = 'MARGEMDIREITA'
    end
    object cdsPaineisFORMATO: TStringField
      FieldName = 'FORMATO'
      Origin = 'FORMATO'
      Size = 50
    end
    object cdsPaineisNOMEARQUIVOHTML: TStringField
      FieldName = 'NOMEARQUIVOHTML'
      Origin = 'NOMEARQUIVOHTML'
      Size = 200
    end
    object cdsPaineisINDICADORSOMPI: TStringField
      FieldName = 'INDICADORSOMPI'
      Origin = 'INDICADORSOMPI'
      Size = 200
    end
    object cdsPaineisARQUIVOSOMPI: TStringField
      FieldName = 'ARQUIVOSOMPI'
      Origin = 'ARQUIVOSOMPI'
      Size = 200
    end
    object cdsPaineisLEFT: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'LEFT'
      Origin = '"LEFT"'
      EditFormat = '0'
    end
    object cdsPaineisTOP: TIntegerField
      FieldName = 'TOP'
      Origin = 'TOP'
      EditFormat = '0'
    end
    object cdsPaineisHEIGHT: TIntegerField
      FieldName = 'HEIGHT'
      Origin = 'HEIGHT'
      EditFormat = '0'
    end
    object cdsPaineisCOLOR: TIntegerField
      FieldName = 'COLOR'
      Origin = 'COLOR'
    end
    object cdsPaineisFONTESIZE: TIntegerField
      FieldName = 'FONTESIZE'
      Origin = 'FONTESIZE'
    end
    object cdsPaineisFONTECOLOR: TIntegerField
      FieldName = 'FONTECOLOR'
      Origin = 'FONTECOLOR'
    end
    object cdsPaineisSOFTWAREHOMOLOGADO: TIntegerField
      FieldName = 'SOFTWAREHOMOLOGADO'
      Origin = 'SOFTWAREHOMOLOGADO'
    end
    object cdsPaineisDISPOSITIVO: TIntegerField
      FieldName = 'DISPOSITIVO'
      Origin = 'DISPOSITIVO'
    end
    object cdsPaineisRESOLUCAO: TIntegerField
      FieldName = 'RESOLUCAO'
      Origin = 'RESOLUCAO'
    end
    object cdsPaineisTEMPOALTERNANCIA: TIntegerField
      FieldName = 'TEMPOALTERNANCIA'
      Origin = 'TEMPOALTERNANCIA'
    end
    object cdsPaineisIDTVPLAYLISTMANAGER: TIntegerField
      FieldName = 'IDTVPLAYLISTMANAGER'
      Origin = 'IDTVPLAYLISTMANAGER'
    end
    object cdsPaineisTIPOBANCO: TIntegerField
      FieldName = 'TIPOBANCO'
      Origin = 'TIPOBANCO'
    end
    object cdsPaineisINTERVALOVERIFICACAO: TIntegerField
      FieldName = 'INTERVALOVERIFICACAO'
      Origin = 'INTERVALOVERIFICACAO'
    end
    object cdsPaineisLAYOUTSENHAALINHAMENTO: TIntegerField
      FieldName = 'LAYOUTSENHAALINHAMENTO'
      Origin = 'LAYOUTSENHAALINHAMENTO'
    end
    object cdsPaineisLAYOUTPAALINHAMENTO: TIntegerField
      FieldName = 'LAYOUTPAALINHAMENTO'
      Origin = 'LAYOUTPAALINHAMENTO'
    end
    object cdsPaineisLAYOUTNOMECLIENTEALINHAMENTO: TIntegerField
      FieldName = 'LAYOUTNOMECLIENTEALINHAMENTO'
      Origin = 'LAYOUTNOMECLIENTEALINHAMENTO'
    end
    object cdsPaineisSOMVOZCHAMADA0: TIntegerField
      FieldName = 'SOMVOZCHAMADA0'
      Origin = 'SOMVOZCHAMADA0'
    end
    object cdsPaineisSOMVOZCHAMADA1: TIntegerField
      FieldName = 'SOMVOZCHAMADA1'
      Origin = 'SOMVOZCHAMADA1'
    end
    object cdsPaineisSOMVOZCHAMADA2: TIntegerField
      FieldName = 'SOMVOZCHAMADA2'
      Origin = 'SOMVOZCHAMADA2'
    end
    object cdsPaineisVOICEINDEX: TIntegerField
      FieldName = 'VOICEINDEX'
      Origin = 'VOICEINDEX'
    end
    object cdsPaineisATUALIZACAOPLAYLIST: TDateField
      FieldName = 'ATUALIZACAOPLAYLIST'
      Origin = 'ATUALIZACAOPLAYLIST'
    end
    object cdsPaineisTRANSPARENT: TStringField
      FieldName = 'TRANSPARENT'
      Origin = 'TRANSPARENT'
      FixedChar = True
      Size = 1
    end
    object cdsPaineisNEGRITO: TStringField
      FieldName = 'NEGRITO'
      Origin = 'NEGRITO'
      FixedChar = True
      Size = 1
    end
    object cdsPaineisITALICO: TStringField
      FieldName = 'ITALICO'
      Origin = 'ITALICO'
      FixedChar = True
      Size = 1
    end
    object cdsPaineisSUBLINHADO: TStringField
      FieldName = 'SUBLINHADO'
      Origin = 'SUBLINHADO'
      FixedChar = True
      Size = 1
    end
    object cdsPaineisMOSTRARSENHA: TStringField
      FieldName = 'MOSTRARSENHA'
      Origin = 'MOSTRARSENHA'
      FixedChar = True
      Size = 1
    end
    object cdsPaineisMOSTRARPA: TStringField
      FieldName = 'MOSTRARPA'
      Origin = 'MOSTRARPA'
      FixedChar = True
      Size = 1
    end
    object cdsPaineisMOSTRARNOMECLIENTE: TStringField
      FieldName = 'MOSTRARNOMECLIENTE'
      Origin = 'MOSTRARNOMECLIENTE'
      FixedChar = True
      Size = 1
    end
    object cdsPaineisSOMARQUIVO: TStringField
      FieldName = 'SOMARQUIVO'
      Origin = 'SOMARQUIVO'
      FixedChar = True
      Size = 1
    end
    object cdsPaineisSOMVOZ: TStringField
      FieldName = 'SOMVOZ'
      Origin = 'SOMVOZ'
      FixedChar = True
      Size = 1
    end
    object cdsPaineisSOMVOZCHAMADA1MARCADO: TStringField
      FieldName = 'SOMVOZCHAMADA1MARCADO'
      Origin = 'SOMVOZCHAMADA1MARCADO'
      FixedChar = True
      Size = 1
    end
    object cdsPaineisSOMVOZCHAMADA2MARCADO: TStringField
      FieldName = 'SOMVOZCHAMADA2MARCADO'
      Origin = 'SOMVOZCHAMADA2MARCADO'
      FixedChar = True
      Size = 1
    end
    object cdsPaineisSOMVOZCHAMADA3MARCADO: TStringField
      FieldName = 'SOMVOZCHAMADA3MARCADO'
      Origin = 'SOMVOZCHAMADA3MARCADO'
      FixedChar = True
      Size = 1
    end
    object cdsPaineisDISPOSICAOLINHAS: TStringField
      FieldName = 'DISPOSICAOLINHAS'
      Origin = 'DISPOSICAOLINHAS'
      FixedChar = True
      Size = 1
    end
    object cdsPaineisVALORACOMPANHACORDONIVEL: TStringField
      FieldName = 'VALORACOMPANHACORDONIVEL'
      Origin = 'VALORACOMPANHACORDONIVEL'
      FixedChar = True
      Size = 1
    end
    object cdsPaineisID_MODULO_TV: TIntegerField
      FieldName = 'ID_MODULO_TV'
      Origin = 'ID_MODULO_TV'
    end
    object cdsPaineisccNOME: TStringField
      FieldKind = fkCalculated
      FieldName = 'ccNOME'
      Size = 40
      Calculated = True
    end
    object cdsPaineisWIDTH: TIntegerField
      FieldName = 'WIDTH'
    end
    object cdsPaineisID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
    end
  end
  object dscPaineis: TDataSource
    DataSet = cdsPaineis
    Left = 112
    Top = 320
  end
  object qryPaineis: TFDQuery
    Connection = dmSicsMain.connOnLine
    SQL.Strings = (
      'SELECT *  FROM MODULOS_TV_PAINEIS'
      '')
    Left = 32
    Top = 272
  end
  object dspPaineis: TDataSetProvider
    DataSet = qryPaineis
    ResolveToDataSet = True
    Left = 112
    Top = 272
  end
  object DTS: TDataSource
    Left = 172
    Top = 57
  end
  object menuPopup: TPopupMenu
    Left = 335
    Top = 392
    object menuQuadroChamadaSenhas: TMenuItem
      Tag = 1
      Caption = '&Chamada de senhas'
      OnClick = MmPlaylistManagerClick
    end
    object menuQuadroUltimasChamadas: TMenuItem
      Tag = 2
      Caption = '&'#218'ltimas chamadas'
      OnClick = MmPlaylistManagerClick
    end
    object menuImagem: TMenuItem
      Tag = 3
      Caption = '&Imagem'
      OnClick = MmPlaylistManagerClick
    end
    object menuFlash: TMenuItem
      Tag = 4
      Caption = '&Flash'
      OnClick = MmPlaylistManagerClick
    end
    object menuDataHora: TMenuItem
      Tag = 5
      Caption = '&Data / hora'
      OnClick = MmPlaylistManagerClick
    end
    object menuVideo: TMenuItem
      Tag = 6
      Caption = '&Video'
      OnClick = MmPlaylistManagerClick
    end
    object V1: TMenuItem
      Tag = 7
      Caption = 'T&V'
      OnClick = MmPlaylistManagerClick
    end
    object JornalEletrnico1: TMenuItem
      Tag = 8
      Caption = '&Jornal eletr'#244'nico'
      OnClick = MmPlaylistManagerClick
    end
    object Indicadordeperformance1: TMenuItem
      Tag = 9
      Caption = 'I&ndicador de performance'
      OnClick = MmPlaylistManagerClick
    end
    object MmPlaylistManager: TMenuItem
      Tag = 10
      Caption = 'Playlist Manager'
      OnClick = MmPlaylistManagerClick
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 584
    Top = 362
  end
end
