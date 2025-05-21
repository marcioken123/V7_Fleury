object frmSicsProperties: TfrmSicsProperties
  Left = 495
  Top = 153
  Caption = 'Propriedades'
  ClientHeight = 461
  ClientWidth = 603
  Color = clBtnFace
  Constraints.MaxHeight = 500
  Constraints.MaxWidth = 619
  Constraints.MinHeight = 500
  Constraints.MinWidth = 619
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object PageControlConfigs: TPageControl
    Left = 217
    Top = 0
    Width = 386
    Height = 420
    ActivePage = tbsUltimasChamadas
    Align = alClient
    TabOrder = 0
    object tbsGeral: TTabSheet
      Caption = 'Gerais'
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
          Width = 10
          Height = 13
          Caption = 'X:'
        end
        object Label2: TLabel
          Left = 104
          Top = 29
          Width = 10
          Height = 13
          Caption = 'Y:'
        end
        object Label16: TLabel
          Left = 183
          Top = 29
          Width = 27
          Height = 13
          Caption = 'Larg.:'
        end
        object Label17: TLabel
          Left = 285
          Top = 29
          Width = 18
          Height = 13
          Caption = 'Alt.:'
        end
        object edLeft: TEdit
          Left = 32
          Top = 25
          Width = 41
          Height = 21
          TabOrder = 0
          Text = 'edLeft'
        end
        object edTop: TEdit
          Left = 121
          Top = 25
          Width = 41
          Height = 21
          TabOrder = 1
          Text = 'edTop'
        end
        object edWidth: TEdit
          Left = 217
          Top = 25
          Width = 41
          Height = 21
          TabOrder = 2
          Text = 'edWidth'
        end
        object edHeight: TEdit
          Left = 310
          Top = 25
          Width = 41
          Height = 21
          TabOrder = 3
          Text = 'edHeight'
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
          OnClick = rbBackgroundImageClick
        end
        object rbBackGroundColor: TRadioButton
          Left = 10
          Top = 60
          Width = 66
          Height = 17
          Caption = 'Cor'
          TabOrder = 1
          OnClick = rbBackgroundImageClick
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
        object edBackgroundImage: TJvFilenameEdit
          Left = 30
          Top = 35
          Width = 328
          Height = 21
          TabOrder = 3
          Text = 'edBackgroundImage'
        end
      end
    end
    object tbsChamadaSenhas: TTabSheet
      Caption = 'Chamadas de senhas'
      ImageIndex = 1
      object pnlChamadaSenhas: TGroupBox
        Left = 0
        Top = 0
        Width = 378
        Height = 392
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
            OnChange = cmbUltimasChamadasFonteChange
          end
          object cmbChamadaSenhasFontSize: TComboBox
            Left = 199
            Top = 15
            Width = 51
            Height = 21
            TabOrder = 1
            Text = 'cmbChamadaSenhasFontSize'
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
            OnClick = btnSubirChamadaClick
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
            OnClick = btnDescerChamadaClick
          end
          object chkArquivo: TCheckBox
            Left = 8
            Top = 16
            Width = 57
            Height = 17
            Caption = 'Arquivo'
            TabOrder = 4
          end
          object chkVoz: TCheckBox
            Left = 8
            Top = 40
            Width = 57
            Height = 17
            Caption = 'Voz'
            TabOrder = 5
          end
        end
        object groupChamadaDeSenhasPAsPermitidas: TGroupBox
          Left = 5
          Top = 335
          Width = 366
          Height = 53
          Caption = 'PAS Permitidas'
          TabOrder = 3
          object edChamadaSenhasPASPermitidas: TEdit
            Left = 7
            Top = 21
            Width = 349
            Height = 21
            TabOrder = 0
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
              Width = 10
              Height = 13
              Caption = 'X:'
            end
            object Label33: TLabel
              Left = 74
              Top = 21
              Width = 10
              Height = 13
              Caption = 'Y:'
            end
            object Label23: TLabel
              Left = 131
              Top = 21
              Width = 27
              Height = 13
              Caption = 'Larg.:'
            end
            object Label35: TLabel
              Left = 206
              Top = 21
              Width = 18
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
            object edChamadaDeSenhasLayoutSenhaX: TEdit
              Left = 26
              Top = 17
              Width = 33
              Height = 21
              TabOrder = 0
              Text = 'edChamadaDeSenhasLayoutSenhaX'
            end
            object edChamadaDeSenhasLayoutSenhaY: TEdit
              Left = 86
              Top = 17
              Width = 33
              Height = 21
              TabOrder = 1
              Text = 'edChamadaDeSenhasLayoutSenhaY'
            end
            object edChamadaDeSenhasLayoutSenhaLarg: TEdit
              Left = 162
              Top = 17
              Width = 33
              Height = 21
              TabOrder = 2
              Text = 'edChamadaDeSenhasLayoutSenhaLarg'
            end
            object edChamadaDeSenhasLayoutSenhaAlt: TEdit
              Left = 229
              Top = 17
              Width = 33
              Height = 21
              TabOrder = 3
              Text = 'edChamadaDeSenhasLayoutSenhaAlt'
            end
          end
          object chkChamadaDeSenhasLayoutMostrarSenha: TCheckBox
            Left = 13
            Top = 14
            Width = 90
            Height = 17
            Caption = 'Mostrar senha'
            TabOrder = 0
            OnClick = chkChamadaDeSenhasLayoutMostrarSenhaClick
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
              Width = 10
              Height = 13
              Caption = 'X:'
            end
            object Label37: TLabel
              Left = 74
              Top = 21
              Width = 10
              Height = 13
              Caption = 'Y:'
            end
            object Label38: TLabel
              Left = 131
              Top = 21
              Width = 27
              Height = 13
              Caption = 'Larg.:'
            end
            object Label39: TLabel
              Left = 206
              Top = 21
              Width = 18
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
            object edChamadaDeSenhasLayoutPAX: TEdit
              Left = 26
              Top = 17
              Width = 33
              Height = 21
              TabOrder = 0
              Text = 'edChamadaDeSenhasLayoutPAX'
            end
            object edChamadaDeSenhasLayoutPAY: TEdit
              Left = 86
              Top = 17
              Width = 33
              Height = 21
              TabOrder = 1
              Text = 'edChamadaDeSenhasLayoutPAY'
            end
            object edChamadaDeSenhasLayoutPALarg: TEdit
              Left = 162
              Top = 17
              Width = 33
              Height = 21
              TabOrder = 2
              Text = 'edChamadaDeSenhasLayoutPALarg'
            end
            object edChamadaDeSenhasLayoutPAAlt: TEdit
              Left = 229
              Top = 17
              Width = 33
              Height = 21
              TabOrder = 3
              Text = 'edChamadaDeSenhasLayoutPAAlt'
            end
          end
          object chkChamadaDeSenhasLayoutMostrarPA: TCheckBox
            Left = 13
            Top = 61
            Width = 76
            Height = 17
            Caption = 'Mostrar PA'
            TabOrder = 2
            OnClick = chkChamadaDeSenhasLayoutMostrarSenhaClick
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
              Width = 10
              Height = 13
              Caption = 'X:'
            end
            object Label41: TLabel
              Left = 74
              Top = 21
              Width = 10
              Height = 13
              Caption = 'Y:'
            end
            object Label42: TLabel
              Left = 131
              Top = 21
              Width = 27
              Height = 13
              Caption = 'Larg.:'
            end
            object Label43: TLabel
              Left = 206
              Top = 21
              Width = 18
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
            object edChamadaDeSenhasLayoutNomeClienteX: TEdit
              Left = 26
              Top = 17
              Width = 33
              Height = 21
              TabOrder = 0
              Text = 'edChamadaDeSenhasLayoutNomeClienteX'
            end
            object edChamadaDeSenhasLayoutNomeClienteY: TEdit
              Left = 86
              Top = 17
              Width = 33
              Height = 21
              TabOrder = 1
              Text = 'edChamadaDeSenhasLayoutNomeClienteY'
            end
            object edChamadaDeSenhasLayoutNomeClienteLarg: TEdit
              Left = 162
              Top = 17
              Width = 33
              Height = 21
              TabOrder = 2
              Text = 'edChamadaDeSenhasLayoutNomeClienteLarg'
            end
            object edChamadaDeSenhasLayoutNomeClienteAlt: TEdit
              Left = 229
              Top = 17
              Width = 33
              Height = 21
              TabOrder = 3
              Text = 'edChamadaDeSenhasLayoutNomeClienteAlt'
            end
          end
          object chkChamadaDeSenhasLayoutMostrarNomeCliente: TCheckBox
            Left = 13
            Top = 108
            Width = 136
            Height = 17
            Caption = 'Mostrar nome do cliente'
            TabOrder = 4
            OnClick = chkChamadaDeSenhasLayoutMostrarSenhaClick
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
        Width = 378
        Height = 392
        Align = alClient
        Caption = 'TV'
        TabOrder = 0
        Visible = False
        object Label24: TLabel
          Left = 52
          Top = 18
          Width = 63
          Height = 13
          Caption = 'Canal padr'#227'o'
        end
        object Label31: TLabel
          Left = 10
          Top = 18
          Width = 11
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
          object cboVideoInputs: TComboBox
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
            OnChange = cboVideoInputsChange
          end
          object cboVideoDevices: TComboBox
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
          object cboVideoSubtypes: TComboBox
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
            OnChange = cboVideoSubtypesChange
          end
          object cboVideoSizes: TComboBox
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
            OnChange = cboVideoSizesChange
          end
          object cboAnalogVideoStandard: TComboBox
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
            Width = 55
            Height = 13
            Caption = 'audio input:'
          end
          object Label49: TLabel
            Left = 190
            Top = 38
            Width = 77
            Height = 13
            Caption = 'audio input level'
          end
          object Label36: TLabel
            Left = 190
            Top = 76
            Width = 93
            Height = 13
            Caption = 'audio input balance'
          end
          object cboAudioDevices: TComboBox
            Left = 5
            Top = 16
            Width = 355
            Height = 21
            TabOrder = 0
            OnChange = cboAudioDevicesChange
          end
          object cboAudioInputs: TComboBox
            Left = 5
            Top = 53
            Width = 175
            Height = 21
            TabOrder = 1
            OnChange = cboAudioInputsChange
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
            OnChange = tbrAudioInputLevelChange
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
            OnChange = tbrAudioInputBalanceChange
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
            Width = 34
            Height = 13
            Caption = 'volume'
          end
          object Label29: TLabel
            Left = 190
            Top = 38
            Width = 38
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
          object cboAudioRenderers: TComboBox
            Left = 5
            Top = 16
            Width = 355
            Height = 21
            TabOrder = 2
            OnChange = cboAudioRenderersChange
          end
        end
        object dblkpCanalPadrao: TDBLookupComboBox
          Left = 52
          Top = 35
          Width = 242
          Height = 21
          KeyField = 'ID'
          ListField = 'NOME'
          ListSource = dtsCanalPadrao
          TabOrder = 4
        end
        object edtIdTV: TEdit
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
          Width = 91
          Height = 13
          Caption = 'Softwares padr'#245'es:'
        end
        object Label53: TLabel
          Left = 7
          Top = 67
          Width = 114
          Height = 13
          Caption = 'Caminho do execut'#225'vel:'
        end
        object Label54: TLabel
          Left = 44
          Top = 100
          Width = 77
          Height = 13
          Caption = 'Nome da janela:'
        end
        object lblNome: TLabel
          Left = 67
          Top = 156
          Width = 54
          Height = 13
          Caption = 'Dispositivo:'
        end
        object lblResolucao: TLabel
          Left = 67
          Top = 186
          Width = 54
          Height = 13
          Caption = 'Resolu'#231#227'o:'
        end
        object lblResolucaoPadrao: TLabel
          Left = 7
          Top = 128
          Width = 114
          Height = 13
          Caption = 'Funcionar na resolu'#231#227'o:'
        end
        object lblVolume: TLabel
          Left = 83
          Top = 219
          Width = 38
          Height = 13
          Caption = 'Volume:'
        end
        object cboSoftwaresHomologados: TComboBox
          Left = 127
          Top = 29
          Width = 145
          Height = 21
          Style = csDropDownList
          TabOrder = 0
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
        object edCaminhoExecutavel: TEdit
          Left = 127
          Top = 63
          Width = 243
          Height = 21
          TabOrder = 1
        end
        object edNomeJanela: TEdit
          Left = 127
          Top = 96
          Width = 243
          Height = 21
          TabOrder = 2
        end
        object cbxDispositivo: TComboBox
          Left = 127
          Top = 155
          Width = 243
          Height = 21
          Style = csDropDownList
          TabOrder = 3
          OnChange = cbxDispositivoChange
        end
        object cbxResolucao: TComboBox
          Left = 127
          Top = 183
          Width = 138
          Height = 21
          Style = csDropDownList
          TabOrder = 4
          OnChange = cbxResolucaoChange
        end
        object edResolucaoPadrao: TEdit
          Left = 127
          Top = 125
          Width = 138
          Height = 21
          TabOrder = 5
        end
        object trckVolume: TTrackBar
          Left = 121
          Top = 216
          Width = 256
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
      object pnlImagem: TGroupBox
        Left = 0
        Top = 0
        Width = 378
        Height = 392
        Align = alClient
        Caption = '&Imagem'
        TabOrder = 0
        object Label6: TLabel
          Left = 10
          Top = 29
          Width = 252
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
        Width = 378
        Height = 392
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
            FontName = '@Microsoft YaHei UI'
            ItemIndex = 8
            Options = [foWysiWyg]
            ParentShowHint = False
            ShowHint = True
            Sorted = True
            TabOrder = 0
            OnChange = cmbUltimasChamadasFonteChange
          end
          object cmbUltimasChamadasFontSize: TComboBox
            Left = 199
            Top = 15
            Width = 51
            Height = 21
            TabOrder = 1
            Text = 'cmbChamadaSenhasFontSize'
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
          object edUltimasChamadasPASPermitidas: TEdit
            Left = 8
            Top = 21
            Width = 350
            Height = 21
            TabOrder = 0
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
            Width = 73
            Height = 13
            Caption = 'Mostrar '#250'ltimas:'
          end
          object Label52: TLabel
            Left = 253
            Top = 196
            Width = 68
            Height = 13
            Caption = 'Espa'#231'amento:'
          end
          object Label59: TLabel
            Left = 288
            Top = 221
            Width = 33
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
              Width = 10
              Height = 13
              Caption = 'X:'
            end
            object Label10: TLabel
              Left = 74
              Top = 21
              Width = 10
              Height = 13
              Caption = 'Y:'
            end
            object Label11: TLabel
              Left = 131
              Top = 21
              Width = 27
              Height = 13
              Caption = 'Larg.:'
            end
            object Label12: TLabel
              Left = 206
              Top = 21
              Width = 18
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
            object edUltimasChamadasLayoutSenhaX: TEdit
              Left = 26
              Top = 17
              Width = 33
              Height = 21
              TabOrder = 0
              Text = 'edUltimasChamadasLayoutSenhaX'
            end
            object edUltimasChamadasLayoutSenhaY: TEdit
              Left = 86
              Top = 17
              Width = 33
              Height = 21
              TabOrder = 1
              Text = 'edUltimasChamadasLayoutSenhaY'
            end
            object edUltimasChamadasLayoutSenhaLarg: TEdit
              Left = 162
              Top = 17
              Width = 33
              Height = 21
              TabOrder = 2
              Text = 'edUltimasChamadasLayoutSenhaLarg'
            end
            object edUltimasChamadasLayoutSenhaAlt: TEdit
              Left = 229
              Top = 17
              Width = 33
              Height = 21
              TabOrder = 3
              Text = 'edUltimasChamadasLayoutSenhaAlt'
            end
          end
          object chkUltimasChamadasLayoutMostrarSenha: TCheckBox
            Left = 13
            Top = 14
            Width = 90
            Height = 17
            Caption = 'Mostrar senha'
            TabOrder = 0
            OnClick = chkChamadaDeSenhasLayoutMostrarSenhaClick
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
              Width = 10
              Height = 13
              Caption = 'X:'
            end
            object Label44: TLabel
              Left = 74
              Top = 21
              Width = 10
              Height = 13
              Caption = 'Y:'
            end
            object Label45: TLabel
              Left = 131
              Top = 21
              Width = 27
              Height = 13
              Caption = 'Larg.:'
            end
            object Label46: TLabel
              Left = 206
              Top = 21
              Width = 18
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
            object edUltimasChamadasLayoutPAX: TEdit
              Left = 26
              Top = 17
              Width = 33
              Height = 21
              TabOrder = 0
              Text = 'edUltimasChamadasLayoutPAX'
            end
            object edUltimasChamadasLayoutPAY: TEdit
              Left = 86
              Top = 17
              Width = 33
              Height = 21
              TabOrder = 1
              Text = 'edUltimasChamadasLayoutPAY'
            end
            object edUltimasChamadasLayoutPALarg: TEdit
              Left = 162
              Top = 17
              Width = 33
              Height = 21
              TabOrder = 2
              Text = 'edUltimasChamadasLayoutPALarg'
            end
            object edUltimasChamadasLayoutPAAlt: TEdit
              Left = 229
              Top = 17
              Width = 33
              Height = 21
              TabOrder = 3
              Text = 'edUltimasChamadasLayoutPAAlt'
            end
          end
          object chkUltimasChamadasLayoutMostrarPA: TCheckBox
            Left = 13
            Top = 61
            Width = 76
            Height = 17
            Caption = 'Mostrar PA'
            TabOrder = 2
            OnClick = chkChamadaDeSenhasLayoutMostrarSenhaClick
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
              Width = 10
              Height = 13
              Caption = 'X:'
            end
            object Label48: TLabel
              Left = 74
              Top = 21
              Width = 10
              Height = 13
              Caption = 'Y:'
            end
            object Label50: TLabel
              Left = 131
              Top = 21
              Width = 27
              Height = 13
              Caption = 'Larg.:'
            end
            object Label51: TLabel
              Left = 206
              Top = 21
              Width = 18
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
            object edUltimasChamadasLayoutNomeClienteX: TEdit
              Left = 26
              Top = 17
              Width = 33
              Height = 21
              TabOrder = 0
              Text = 'edUltimasChamadasLayoutNomeClienteX'
            end
            object edUltimasChamadasLayoutNomeClienteY: TEdit
              Left = 86
              Top = 17
              Width = 33
              Height = 21
              TabOrder = 1
              Text = 'edUltimasChamadasLayoutNomeClienteY'
            end
            object edUltimasChamadasLayoutNomeClienteLarg: TEdit
              Left = 162
              Top = 17
              Width = 33
              Height = 21
              TabOrder = 2
              Text = 'edUltimasChamadasLayoutNomeClienteLarg'
            end
            object edUltimasChamadasLayoutNomeClienteAlt: TEdit
              Left = 229
              Top = 17
              Width = 33
              Height = 21
              TabOrder = 3
              Text = 'edUltimasChamadasLayoutNomeClienteAlt'
            end
          end
          object chkUltimasChamadasLayoutMostrarNomeCliente: TCheckBox
            Left = 13
            Top = 108
            Width = 137
            Height = 17
            Caption = 'Mostrar nome do cliente'
            TabOrder = 4
            OnClick = chkChamadaDeSenhasLayoutMostrarSenhaClick
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
          object edUltimasChamadasQuantidade: TEdit
            Left = 327
            Top = 163
            Width = 31
            Height = 21
            TabOrder = 7
            Text = 'edUltimasChamadasQuantidade'
          end
          object edUltimasChamadasEspacamento: TEdit
            Left = 327
            Top = 188
            Width = 31
            Height = 21
            TabOrder = 9
            Text = 'edUltimasChamadasQuantidade'
          end
          object edUltimasChamadasAtraso: TEdit
            Left = 327
            Top = 213
            Width = 31
            Height = 21
            TabOrder = 8
            Text = 'edUltimasChamadasAtraso'
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
        Width = 378
        Height = 392
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
            FontName = '@Microsoft YaHei UI'
            ItemIndex = 8
            Options = [foWysiWyg]
            ParentShowHint = False
            ShowHint = True
            Sorted = True
            TabOrder = 0
            OnChange = cmbUltimasChamadasFonteChange
          end
          object cmbDataHoraFontSize: TComboBox
            Left = 199
            Top = 15
            Width = 51
            Height = 21
            TabOrder = 1
            Text = 'cmbDataHoraFontSize'
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
            Width = 41
            Height = 13
            Caption = 'Formato:'
          end
          object edDataHoraFormato: TEdit
            Left = 51
            Top = 15
            Width = 306
            Height = 21
            TabOrder = 0
            Text = 'edDataHoraFormato'
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
            Width = 25
            Height = 13
            Caption = 'Sup.:'
          end
          object Label19: TLabel
            Left = 106
            Top = 20
            Width = 18
            Height = 13
            Caption = 'Inf.:'
          end
          object Label20: TLabel
            Left = 194
            Top = 20
            Width = 24
            Height = 13
            Caption = 'Esq.:'
          end
          object Label21: TLabel
            Left = 294
            Top = 20
            Width = 19
            Height = 13
            Caption = 'Dir.:'
          end
          object edDataHoraMargemSuperior: TEdit
            Left = 35
            Top = 16
            Width = 40
            Height = 21
            TabOrder = 0
            Text = 'edDataHoraMargemSuperior'
          end
          object edDataHoraMargemInferior: TEdit
            Left = 129
            Top = 16
            Width = 40
            Height = 21
            TabOrder = 1
            Text = 'edDataHoraMargemInferior'
          end
          object edDataHoraMargemEsquerda: TEdit
            Left = 223
            Top = 16
            Width = 40
            Height = 21
            TabOrder = 2
            Text = 'edDataHoraMargemEsquerda'
          end
          object edDataHoraMargemDireita: TEdit
            Left = 318
            Top = 16
            Width = 40
            Height = 21
            TabOrder = 3
            Text = 'edDataHoraMargemDireita'
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
        Width = 378
        Height = 392
        Align = alClient
        Caption = 'Videos'
        TabOrder = 0
        object lblTempoAlternancia: TLabel
          Left = 8
          Top = 224
          Width = 123
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
          OnClick = lstVideoFileNamesClick
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
        object edtTempoAlternancia: TEdit
          Left = 140
          Top = 221
          Width = 49
          Height = 21
          TabOrder = 5
        end
      end
    end
    object tbsFlash: TTabSheet
      Caption = 'Flash'
      ImageIndex = 7
      object pnlFlash: TGroupBox
        Left = 0
        Top = 0
        Width = 378
        Height = 392
        Align = alClient
        Caption = '&Flash'
        TabOrder = 0
        object Label4: TLabel
          Left = 10
          Top = 29
          Width = 39
          Height = 13
          Caption = '&Arquivo:'
        end
        object Label5: TLabel
          Left = 10
          Top = 65
          Width = 105
          Height = 13
          Caption = 'Atualizar a cada (&seg):'
        end
        object edFlashRefresh: TEdit
          Left = 120
          Top = 61
          Width = 31
          Height = 21
          TabOrder = 0
          Text = '0'
        end
        object edFlashFileName: TJvFilenameEdit
          Left = 56
          Top = 25
          Width = 310
          Height = 21
          TabOrder = 1
          Text = 'edFlashFileName'
        end
      end
    end
    object tbsJornalEletronico: TTabSheet
      Caption = 'Jornal Eletr'#244'nico'
      ImageIndex = 8
      object GroupBox3: TGroupBox
        Left = 0
        Top = 0
        Width = 378
        Height = 392
        Align = alClient
        Caption = 'Jornal Eletr'#244'nico'
        TabOrder = 0
        object Label30: TLabel
          Left = 11
          Top = 72
          Width = 44
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
            FontName = '@Microsoft YaHei UI'
            ItemIndex = 8
            Options = [foWysiWyg]
            ParentShowHint = False
            ShowHint = True
            Sorted = True
            TabOrder = 0
            OnChange = cmbUltimasChamadasFonteChange
          end
          object cmbJornalEletronicoFontSize: TComboBox
            Left = 196
            Top = 15
            Width = 51
            Height = 21
            TabOrder = 1
            Text = 'cmbJornalEletronicoFontSize'
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
        object edtJornalEletronicoInterval: TEdit
          Left = 61
          Top = 68
          Width = 57
          Height = 21
          TabOrder = 1
        end
      end
    end
    object tbsIndicadoresDePerformance: TTabSheet
      Caption = 'Indicadores de Performance'
      ImageIndex = 9
      object GroupBox7: TGroupBox
        Left = 0
        Top = 0
        Width = 378
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
        object edHTMLFileName: TJvFilenameEdit
          Left = 64
          Top = 25
          Width = 302
          Height = 21
          TabOrder = 0
          Text = 'edHTMLFileName'
        end
        object chkCorDaFonteAcompanhaNivelPI: TCheckBox
          Left = 10
          Top = 60
          Width = 266
          Height = 17
          Caption = 'Valor do PI acompanha a cor do respectivo n'#237'vel'
          TabOrder = 1
          Visible = False
        end
      end
      object GroupBox1: TGroupBox
        Left = 0
        Top = 89
        Width = 378
        Height = 303
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
        object edtIndicador: TEdit
          Left = 64
          Top = 17
          Width = 57
          Height = 21
          TabOrder = 0
        end
        object edtSomPI: TJvFilenameEdit
          Left = 64
          Top = 46
          Width = 305
          Height = 21
          TabOrder = 1
          Text = ''
        end
      end
    end
    object tbsPlayListManager: TTabSheet
      Caption = 'Playlist Corporativo'
      ImageIndex = 10
      object GroupBox2: TGroupBox
        Left = 0
        Top = 0
        Width = 378
        Height = 392
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
        object edtIDTVPlayListManager: TEdit
          Left = 155
          Top = 28
          Width = 60
          Height = 21
          TabOrder = 0
        end
        object cbTipoBancoPlayList: TComboBox
          Left = 155
          Top = 58
          Width = 206
          Height = 21
          Style = csDropDownList
          ItemIndex = 0
          TabOrder = 1
          Text = 'FireBird'
          OnSelect = cbTipoBancoPlayListSelect
          Items.Strings = (
            'FireBird'
            'SQL Express')
        end
        object edtHostBancoPlayList: TEdit
          Left = 155
          Top = 88
          Width = 206
          Height = 21
          TabOrder = 2
        end
        object edtPortaBancoPlayList: TEdit
          Left = 155
          Top = 118
          Width = 60
          Height = 21
          TabOrder = 3
        end
        object edtNomeArquivoBancoPlayList: TEdit
          Left = 155
          Top = 148
          Width = 206
          Height = 21
          TabOrder = 4
        end
        object edtUsuarioBancoPlayList: TEdit
          Left = 155
          Top = 178
          Width = 206
          Height = 21
          TabOrder = 5
        end
        object edtSenhaBancoPlayList: TEdit
          Left = 155
          Top = 208
          Width = 206
          Height = 21
          PasswordChar = '*'
          TabOrder = 6
        end
        object edtDiretorioLocalPlayList: TEdit
          Left = 155
          Top = 238
          Width = 206
          Height = 21
          TabOrder = 7
        end
        object edtIntervaloVerificacaoPlayList: TEdit
          Left = 155
          Top = 269
          Width = 60
          Height = 21
          TabOrder = 8
        end
      end
    end
  end
  object pnlListaPanels: TPanel
    Left = 0
    Top = 0
    Width = 217
    Height = 420
    Align = alLeft
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 1
    object Label26: TLabel
      Left = 5
      Top = 5
      Width = 40
      Height = 13
      Caption = 'Quadros'
    end
    object lstQuadros: TListBox
      Left = 2
      Top = 23
      Width = 213
      Height = 395
      Align = alBottom
      Anchors = [akLeft, akTop, akRight, akBottom]
      ItemHeight = 13
      TabOrder = 0
      OnClick = lstQuadrosClick
      OnKeyDown = lstQuadrosKeyDown
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 420
    Width = 603
    Height = 41
    Align = alBottom
    TabOrder = 2
    object btnAplicar: TButton
      Left = 517
      Top = 6
      Width = 75
      Height = 22
      Caption = '&Aplicar'
      Default = True
      TabOrder = 0
      OnClick = btnAplicarClick
    end
  end
  object dtsCanalPadrao: TDataSource
    DataSet = frmSicsTVPrincipal.cdsTVCanais
    Left = 81
    Top = 361
  end
  object OpenDialogVideos: TOpenDialog
    Filter = 'Arquivos de Video|*.wmv;*.avi;*.mpg;*.mpeg'
    Left = 34
    Top = 360
  end
end
