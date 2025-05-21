object MainForm: TMainForm
  Left = 333
  Top = 176
  Caption = 'SICS Config'
  ClientHeight = 571
  ClientWidth = 944
  Color = clWindow
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Verdana'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 14
  object Splitter: TSplitter
    Left = 329
    Top = 0
    Height = 571
    ExplicitHeight = 562
  end
  object PageControl: TPageControl
    Left = 332
    Top = 0
    Width = 612
    Height = 571
    ActivePage = tabConfiguracoes
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 629
    object tabConexoes: TTabSheet
      Caption = 'Conex'#245'es'
      ExplicitWidth = 621
      DesignSize = (
        604
        542)
      object tvwConexoes: TTreeView
        Left = 0
        Top = 0
        Width = 604
        Height = 503
        Align = alTop
        Anchors = [akLeft, akTop, akRight, akBottom]
        Images = ImageList
        Indent = 19
        RightClickSelect = True
        TabOrder = 0
        OnChange = tvwConexoesChange
        OnMouseUp = tvwConexoesMouseUp
        ExplicitWidth = 621
      end
      object btnAtualizar: TBitBtn
        Left = 0
        Top = 509
        Width = 103
        Height = 31
        Anchors = [akLeft, akBottom]
        Caption = '&Atualizar'
        Glyph.Data = {
          DE010000424DDE01000000000000760000002800000024000000120000000100
          0400000000006801000000000000000000001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333444444
          33333333333F8888883F33330000324334222222443333388F3833333388F333
          000032244222222222433338F8833FFFFF338F3300003222222AAAAA22243338
          F333F88888F338F30000322222A33333A2224338F33F8333338F338F00003222
          223333333A224338F33833333338F38F00003222222333333A444338FFFF8F33
          3338888300003AAAAAAA33333333333888888833333333330000333333333333
          333333333333333333FFFFFF000033333333333344444433FFFF333333888888
          00003A444333333A22222438888F333338F3333800003A2243333333A2222438
          F38F333333833338000033A224333334422224338338FFFFF8833338000033A2
          22444442222224338F3388888333FF380000333A2222222222AA243338FF3333
          33FF88F800003333AA222222AA33A3333388FFFFFF8833830000333333AAAAAA
          3333333333338888883333330000333333333333333333333333333333333333
          0000}
        NumGlyphs = 2
        TabOrder = 1
        OnClick = btnAtualizarClick
        ExplicitTop = 499
      end
      object btnPing: TBitBtn
        Left = 282
        Top = 509
        Width = 103
        Height = 31
        Anchors = [akRight, akBottom]
        Caption = '&Ping'
        Enabled = False
        Glyph.Data = {
          F6060000424DF606000000000000360000002800000018000000180000000100
          180000000000C006000000000000000000000000000000000000FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDCDCDCE2E2E2E1E1E1E1E1
          E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1
          E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E2E2E2DCDCDCFFFFFFB7B7B7000000
          1414141414141414141414141414141414141414141414141414141414141414
          14141414141414141414141414141414141414141414141414141414000000B7
          B7B75F5F5F000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000005F5F5F1C1C1C00000000000000000000000000000000000000
          00000000000000000000001111110F0F0F000000000000000000000000000000
          0000000000000000000000000000001F1F1F0809060000000000000000000000
          00000000000000000000000000000000040404BBBBBBC6C6C616161600000000
          0000000000000000000000000000000000000000000000080608050411151098
          1E18BF000000000000000000000000000000000000000000000000F0F0F0FFFF
          FFB2B2B200000000000000000000000000000000000000000040981B5DD92906
          0B052120211B14D32F25FF000000000000000000000000000000000000000000
          000000000000E9E9E9FFFFFFACACAC0000000000000000000000000000000000
          005DD9295DD9292121215354470D07902C21FF05042200000000000000000000
          0000000000000000000000000000000000AFAFAFFFFFFF6D6D6D000000000000
          0000000000002C64165DD9295DD929544E56A8A99A00006D2920FF1B15B50000
          000000000000000000000000000000000000000000000000000000008A8A8AFF
          FFFF5858580000000000000000005DD9295DD929154C00A69EA9DFDFDA00000E
          1F18EB251DF20604280000000000000000000000000000000000000000000000
          000000000000005C5C5CFFFFFF6C6C6C00000000010A5DD9295DD929000900DE
          DBDFFFFFFF5B5B480000652A21FF1E16C6000000000000000000000000000000
          000000000000000000000000000000000000484848F9F3F300000001C0C60094
          A60000005A555BFFFFFFFFFFFFDBDBDA050600241BFF271EFF2119D800000000
          00000000000000000000000000000000000000000000000000000000001A0000
          00D8E300FFFF00FFFF0A0000E2E2E2FFFFFFFFFFFFFFFFFFAFB0A8000000221A
          E9281EFF221ADC00010200000000000000000000000000000000000000000000
          050600151500D4E000FFFF00EEF8000000B0A9A9FFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFF6E6E620000151F18DA25108A024D3F00B0B1006971001B1D0000000000
          00001A1D00707000B4B600FBFF00FFFF00D5DC001518716261FFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFF9A9B91000004000B120DE4E500FFFF00FFFF
          00ECEC00D4D400D4D300ECEC00FFFF00FFFF00FFFF006B6E0000019F9191FFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2E2B2914
          000000444A0AC8CF00CFCF00E7E800EEEF00D1D200CFCD004E57110406301717
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFD1CECE877B7A513B3B311C1C1A2C2F183A3D2E1E1E533A3988
          7A79D3CCCCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFCFCEDEBEBE4DBDBE3D9
          D9ECE9E9FCFDFCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        TabOrder = 2
        OnClick = btnPingClick
        ExplicitLeft = 368
        ExplicitTop = 499
      end
      object btnSCCM: TBitBtn
        Left = 390
        Top = 509
        Width = 103
        Height = 31
        Anchors = [akRight, akBottom]
        Caption = '&SCCM'
        Enabled = False
        Glyph.Data = {
          F6060000424DF606000000000000360000002800000018000000180000000100
          180000000000C006000000000000000000000000000000000000FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFD4C8BFD6CBC4D4C9C2D1C6BECEC2BACCC1B8C8BDB4C5BAB0
          C3B7AEBFB3A9BCB0A6BAAEA4BAAFA68B705E89674F88654F88654F88654E8865
          4D8C675159341BFFFFFFFFFFFFE5DBD7D3C6BDBFA99DBDA89BB7A294B29C8DB0
          9989AA9282A48C7CA189789C8271987D6C957A688C7261A28370F3CFBEEAC7B5
          EAC5B4EAC5B2EAC4B0EBC3B18C6851FFFFFFFFFFFFD4C5BEFFFFFFF4F1EEFBEF
          F3FFEDF5EFE7E4FAE6DEFFE5D9E6DCD6E5DAD4E2D4CEE0D2CBDFD0C8E1D1CBA6
          8874FBDACBF2D0C1F9D6C4FCD8C7F4D0BEECC6B4886650FFFFFFFFFFFFD8CBC4
          FFFDFCFCF1F4ABEBB628D656FFEAEE77D3F400A8FFFFE1D3E3DAD4E2D5D0CEBF
          B8CABAB2C3B2A8AD917FF9DED0FADACB9F8D80816958DAB9A8EECCBB896751FF
          FFFFFFFFFFDBCDC6FFFFFEFEF4F7B6EFBF47E269FFECF1A2E3F407CAFFFEE2D7
          E6DED8E6DAD5CCBDB5C6B3AAB6A094B19686FADFD2F5D8CAE8D2C6DEC4B6EACB
          BBEECCBD8A6953FFFFFFFFFFFFDCD0C8FFFFFFFCFDFCFFFBFFFFF9FFF6F3F2FF
          F1EEFFF0E7EEE8E5EEE5E3E9E1DCE8DFDBE7DED7E9DFDAB29988FCE4D9FEE5DB
          866C5B694D38E0C3B6EFD2C38E6D5AFFFFFFFFFFFFEAE2DFE5D8D3E7DDD7E8DE
          D9E7DDD8E6DCD7E6DBD6E5DAD5E4DAD4E4D9D3E4D7D2E2D7D0E1D5D0E3D7CFB9
          A394FDE9E0F9E2D8E1CEC4D6C0B3EAD0C4F0D5C8917460FFFFFFFFFFFFFFFFFF
          E5D9D5C2B0A5A38B7AA38A7AA087769F85759D827199806F987E6C957A689076
          658F7563866C58C5B1A4FDECE4FFEFE6FFEBE3FEEAE0FFF0E6EFD5C9947765FF
          FFFFFFFFFFFFFFFFFFFFFFCEC3BAFFFFFFFFFFFFFAF9F8F6F4F4F1EBE7EDE1E0
          EADEDBE5D7D3E4CFC7DDC9C0D5BEB5C6B3A6FFFCF783644FAF9988D0BAAD4F31
          19FFE9E19A7E6DFFFFFFFFFFFFFFFFFFFFFFFFCBB6AAFFFFFFF1C6B1FBB693F7
          B291F3B08EEDAA89E6A585DD9C7DD79678D49575CE896ACBBFB7FFF8F3EEE2DB
          F1E0D9F8EAE5E4D0C7F5E3DA9F8775FFFFFFFFFFFFFFFFFFFFFFFFCEC0B6FFFF
          FFEAAA8BFF9258FC8C54F68952EA804CDC7847C86C3EBB6337B45D34A2481DD3
          CBC4FFFEFBC4AEA0DDCDC3E8D7CFAD9788F9E9E2A38B7AFFFFFFFFFFFFFFFFFF
          FFFFFFCFC2B8FFFFFFEAAC90FF9C68FF9763FE945EF78D58E98553D5784ACA72
          46C36C42B1562AD7D2CCFFFFFFCDBBB0DBC9BFEEE3DDB09284F9EFE9AA9283FF
          FFFFFFFFFFFFFFFFFFFFFFD1C4BBFFFFFFEFB194FFA271FF9E6BFF9A66FE935D
          F58D58E2804FD5794BCF7447BD5E2FDBD7D3FFFFFFCBB9AEE0D5CFEDE2DCB7A4
          97FAF2EDAF9B8CFFFFFFFFFFFFFFFFFFFFFFFFD2C6BDFFFFFFF2B496FFA577FF
          A170FF9D6AFF9661FA905BE88452DB7C4ED5784BC46233DDDBD7FFFFFFA58977
          C6B4AAE0D3CB7C5A45FEF9F7B39F92FFFFFFFFFFFFFFFFFFFFFFFFD3C8C0FFFF
          FFF6B99AFFAA80FFA778FFA373FF9D69FF9662F38A57E78552E07F50D06B38E3
          E1DFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F1F0B8A79BFFFFFFFFFFFFFFFFFF
          FFFFFFD5CBC3FFFFFFFCBD9DFFB086FFAA7FFFA87CFFA272FF9C69FC925CF28A
          57EC8755DE743FD3D3CFE4E0DCE2DCD7E1DBD5DDD6D0E1D5CFD0C2B8BFADA1FF
          FFFFFFFFFFFFFFFFFFFFFFD5CBC4FFFFFFFFBE9FFFB28AFFAD83FFAC82FFA679
          FF9F6EFF9560F88F5AF28B57E67E4BD09B7FCB9273C48C6FBA8265CDA4908F77
          66DCD2CAE1D9D3FFFFFFFFFFFFFFFFFFFFFFFFD7CEC6FFFFFFFFC2A3FFBD9DFF
          BC97FFB895FFAF87FFA677FF9C67FE9660FC915BF18A57E57E4BDD7A49D27142
          C16233E8AB8D69523FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD9D0C9FFFF
          FFFFC8AAFFCEB4FFCDB4FFCCB1FFC3A1FFB087FFA474FF9E6CFF9B67FF945FF5
          8D59ED8957E08050D27143EEB2956F5946FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFDAD2CBFFFFFFFFC09CFFA87BFFA879FEA575F8996AF18955E87A43E172
          3BDD6D36D46530CA5E29C45B28BC5725B24B19E0A083735C49FFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFDACDC2FFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFCFC
          FFFCFAFEF9F7FEF8F5FFF6F3FEF5EFFEF3ECFFF1EAFFF0E7FFECE4FFF1E5694C
          35FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE5DDD7D9CDC4D8CCC4D6CBC3D5
          CAC2D3C8C0D2C7BFD1C6BECFC4BCCDC2B9CCC1B9CABFB6C7BDB4C6BBB3C5BAB1
          C3B7AFBEB3AAEBE3DFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        TabOrder = 3
        OnClick = menuSCCMClick
        ExplicitLeft = 476
        ExplicitTop = 499
      end
      object btnTelnet: TBitBtn
        Left = 499
        Top = 509
        Width = 103
        Height = 31
        Anchors = [akRight, akBottom]
        Caption = '&Telnet'
        Enabled = False
        Glyph.Data = {
          E6040000424DE604000000000000360000002800000014000000140000000100
          180000000000B004000000000000000000000000000000000000FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF3EAE1C07F45BC7737B7
          773BBD783ABE783AB7773BBD783ABE783AB7773BBC783ABE783AB9773BBB783A
          BE783ABA773ABA783BBD7738BE7F45F1E9E1B976367B50297A56367956357755
          367B56357956357755367B56357A56357655367B56357B56357655367B56357B
          56357755357956367C5129BB7636BB6A20514E4940484E44494D44494D42494D
          44494D44494D434A4E454B4F454B4F444B4F454B4F454A4E43494D43494D4449
          4D40484E514E49BB6A20BC6D24574F46494B4B4B4B4A41403F4A4A494B4C4B4C
          4C4B4545432323222726252525242424232F2F2E4E4E4D4A4C4A4C4C4A494B4B
          574E47BA6D24BB6D24564E46494A4B4747469D9D9D4444434646454648476565
          64FFFFFFFFFFFFFFFFFFFFFFFFF6F6F631312F4D4C4B4B4C4B494B4B574F46BC
          6D24BD6D24574F4646494A4F4F4EF9F9F9D6D6D64444434646454A4B4A60605F
          5C5C5B5C5C5B5F5E5D5959584647464C4C4B4C4C4B484B4B574F46BD6D24BD6D
          24564F46494B4C44444340403EFFFFFFE0E0DF3C3C3B48484746484748484748
          48474648474949484C4C4B4A4C4B4C4C4B494B4B574F47BA6D24BB6D24564E46
          494B4B4C4C4B444544464645F4F4F4E0E0E04343424B4B4A4A4C4B4C4C4B4C4C
          4B4B4C4B4B4C4B4C4C4B4B4C4B494B4B574F46BB6D24BD6D24574F46484B4B4C
          4C4B2C2D2C939292FFFFFF9191904143424C4B4A4B4C4B4B4C4B4C4C4B4C4C4B
          4A4C4B4C4C4B4C4C4B484B4B574F46BD6D24BD6D24564F46484A4B444443A2A2
          A1FFFFFF7C7D7C3232314D4C4B4A4C4B4C4C4B4C4C4B4A4C4B4C4C4B4C4C4B4A
          4C4B4C4C4B494B4B574F47BB6D24BB6D24564E4648494A4E4F4EF7F8F7848483
          3A3B394B4C4B4C4C4B4B4C4B4A4C4B4C4C4B4B4C4B4B4C4B4C4C4B4B4C4B4B4C
          4B494B4B574F46BA6D24BD6D24574F46494B4C4646454748473C3C3B4C4C4B4B
          4C4B4B4C4B4C4C4B4B4C4B4B4C4B4C4C4B4C4C4B4A4C4B4C4C4B4C4C4B484B4B
          574F46BD6D24BD6D24574F46494B4B4D4C4A4B4A494C4C4B4C4C4A4D4C4A4D4C
          4A4B4C4A4D4C4A4D4C4A4B4C4A4D4C4A4D4C4A4B4C4A4D4C4A4A4B4B574F46BB
          6D24BC6D24454A4C324453344552354551354552354552354552354552354552
          34455235455235455234455235455234455234455233445345494DBB6D23AD68
          29BA6C25C36E21C56F20BE6E23C16E22C56F20C06E23C06E22C56F20C16E23BF
          6E23C56F21C26F22BE6D23C56F21C36F21BD6D23C06E22AD682AAC6626AD6929
          A7672BAB682AAE6929A7672BAA672AAE6929A8672AA9672BAE6928A9682AA867
          2BAE6928AB682AA6662BAD6828AC682AA8672BAC6626B2733AA75E19AD6625A6
          6326AA6525AD6623A66426A96526AD6623A76426A76426AD6623A96526A66426
          AD6623AA6525A66326AD6624A75E1AB2733AF3EAE2B47D4AB4743AB5763CAF75
          3DB5763DB6763CB0753DB4763DB6763CB1753DB3763DB6763CB2763DB2753DB6
          763CB3763CB0733BBA7E47F3E9E1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFF}
        TabOrder = 4
        OnClick = menuTelnetClick
        ExplicitLeft = 585
        ExplicitTop = 499
      end
      object BtnSinalTV: TBitBtn
        Left = 178
        Top = 509
        Width = 98
        Height = 31
        Anchors = [akRight, akBottom]
        Caption = '&Sinal TV'
        TabOrder = 5
        OnClick = BtnSinalTVClick
        ExplicitLeft = 264
        ExplicitTop = 499
      end
    end
    object tabConfiguracoes: TTabSheet
      Caption = 'Configura'#231#245'es'
      ImageIndex = 1
      ExplicitWidth = 621
      DesignSize = (
        604
        542)
      object grpGrupo: TGroupBox
        Left = 3
        Top = 0
        Width = 596
        Height = 68
        Anchors = [akLeft, akTop, akRight]
        Caption = ' Grupos '
        TabOrder = 0
        ExplicitWidth = 613
        object btnGrupoPAs: TButton
          Left = 8
          Top = 22
          Width = 90
          Height = 33
          Caption = 'PAs'
          TabOrder = 0
          OnClick = btnGrupoPAsClick
        end
        object btnGrupoAtendentes: TButton
          Left = 104
          Top = 22
          Width = 90
          Height = 33
          Caption = 'Atendentes'
          TabOrder = 1
          OnClick = btnGrupoAtendentesClick
        end
        object btnGrupoTAGs: TButton
          Left = 200
          Top = 22
          Width = 90
          Height = 33
          Caption = 'TAGs'
          TabOrder = 2
          OnClick = btnGrupoTAGsClick
        end
        object btnGrupoPPs: TButton
          Left = 296
          Top = 22
          Width = 90
          Height = 33
          Caption = 'PPs'
          TabOrder = 3
          OnClick = btnGrupoPPsClick
        end
        object btnGrupoMotivosPausa: TButton
          Left = 392
          Top = 22
          Width = 90
          Height = 33
          Caption = 'Motivos de Pausa'
          TabOrder = 4
          WordWrap = True
          OnClick = btnGrupoMotivosPausaClick
        end
      end
      object grpTabelas: TGroupBox
        Left = 4
        Top = 68
        Width = 596
        Height = 141
        Anchors = [akLeft, akTop, akRight]
        Caption = ' Tabelas '
        TabOrder = 1
        ExplicitWidth = 613
        object btnTotens: TButton
          Left = 8
          Top = 22
          Width = 90
          Height = 33
          Caption = 'Totens'
          TabOrder = 0
          OnClick = btnTotensClick
        end
        object btnPaineis: TButton
          Left = 104
          Top = 22
          Width = 90
          Height = 33
          Caption = 'Pain'#233'is'
          TabOrder = 1
          OnClick = btnPaineisClick
        end
        object btnFilas: TButton
          Left = 200
          Top = 22
          Width = 90
          Height = 33
          Caption = 'Filas'
          TabOrder = 2
          OnClick = btnFilasClick
        end
        object btnPAs: TButton
          Left = 296
          Top = 22
          Width = 90
          Height = 33
          Caption = 'PAs'
          TabOrder = 3
          OnClick = btnPAsClick
        end
        object btnAtendentes: TButton
          Left = 392
          Top = 22
          Width = 90
          Height = 33
          Caption = 'Atendentes'
          TabOrder = 4
          OnClick = btnAtendentesClick
        end
        object btnTAGs: TButton
          Left = 8
          Top = 61
          Width = 90
          Height = 33
          Caption = 'TAGs'
          TabOrder = 5
          OnClick = btnTAGsClick
        end
        object btnPPs: TButton
          Left = 104
          Top = 61
          Width = 90
          Height = 33
          Caption = 'PPs'
          TabOrder = 6
          OnClick = btnPPsClick
        end
        object btnMotivosPausa: TButton
          Left = 200
          Top = 61
          Width = 90
          Height = 33
          Caption = 'Motivos de Pausa'
          TabOrder = 7
          WordWrap = True
          OnClick = btnMotivosPausaClick
        end
        object btnCelulares: TButton
          Left = 296
          Top = 61
          Width = 90
          Height = 33
          Caption = 'Celulares'
          TabOrder = 8
          WordWrap = True
          OnClick = btnCelularesClick
        end
        object btnEmails: TButton
          Left = 392
          Top = 61
          Width = 90
          Height = 33
          Caption = 'E-mails'
          TabOrder = 9
          WordWrap = True
          OnClick = btnEmailsClick
        end
        object btnClientes: TButton
          Left = 8
          Top = 100
          Width = 90
          Height = 33
          Caption = 'Clientes'
          TabOrder = 10
          OnClick = btnClientesClick
        end
      end
      object grpModulosSics: TGroupBox
        Left = 3
        Top = 225
        Width = 596
        Height = 106
        Anchors = [akLeft, akTop, akRight]
        Caption = ' Configura'#231#245'es SICS '
        TabOrder = 2
        ExplicitWidth = 613
        object btnConfigPA: TButton
          Left = 9
          Top = 22
          Width = 90
          Height = 33
          Caption = 'PA'
          TabOrder = 0
          OnClick = btnConfigPAClick
        end
        object btnConfigMultiPA: TButton
          Left = 105
          Top = 22
          Width = 90
          Height = 33
          Caption = 'MultiPA'
          TabOrder = 1
          OnClick = btnConfigMultiPAClick
        end
        object btnConfigOnline: TButton
          Left = 201
          Top = 22
          Width = 90
          Height = 33
          Caption = 'OnLine'
          TabOrder = 2
          OnClick = btnConfigOnlineClick
        end
        object btnConfigTGS: TButton
          Left = 297
          Top = 22
          Width = 90
          Height = 33
          Caption = 'TGS'
          TabOrder = 3
          OnClick = btnConfigTGSClick
        end
        object btnCaminhosUpdate: TButton
          Left = 392
          Top = 22
          Width = 90
          Height = 33
          Caption = 'Caminhos Update'
          TabOrder = 4
          WordWrap = True
          OnClick = btnCaminhosUpdateClick
        end
        object btnConfigCallCenter: TButton
          Left = 9
          Top = 61
          Width = 90
          Height = 33
          Caption = 'Call Center'
          TabOrder = 5
          OnClick = btnConfigCallCenterClick
        end
        object btnConfigTV: TButton
          Left = 105
          Top = 61
          Width = 90
          Height = 33
          Caption = 'TV'
          TabOrder = 6
          OnClick = btnConfigTVClick
        end
      end
      object GroupBox1: TGroupBox
        Left = 3
        Top = 337
        Width = 596
        Height = 68
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Gerais'
        TabOrder = 3
        ExplicitWidth = 613
        object btnConfigGeraisConfigurarEmail: TButton
          Left = 9
          Top = 22
          Width = 90
          Height = 33
          Caption = 'Configurar E-mail'
          TabOrder = 0
          WordWrap = True
          OnClick = btnConfigGeraisConfigurarEmailClick
        end
        object btnConfigGeraisSMS: TButton
          Left = 201
          Top = 22
          Width = 90
          Height = 33
          Caption = 'Configurar SMS'
          TabOrder = 1
          WordWrap = True
          OnClick = btnConfigGeraisSMSClick
        end
        object btnConfigGeraisTestarEmail: TButton
          Left = 105
          Top = 22
          Width = 90
          Height = 33
          Caption = 'Testar E-mail'
          TabOrder = 2
          WordWrap = True
          OnClick = btnConfigGeraisTestarEmailClick
        end
        object btnConfigGeraisTestarSMS: TButton
          Left = 297
          Top = 22
          Width = 90
          Height = 33
          Caption = 'Testar SMS'
          TabOrder = 3
          WordWrap = True
          OnClick = btnConfigGeraisTestarSMSClick
        end
        object btnGrupoCategorias: TButton
          Left = 393
          Top = 22
          Width = 90
          Height = 33
          Caption = 'Categorias de Filas'
          TabOrder = 4
          WordWrap = True
          OnClick = btnGrupoCategoriasClick
        end
        object btnGrupoFilas: TButton
          Left = 487
          Top = 22
          Width = 90
          Height = 33
          Caption = 'Filas'
          TabOrder = 5
          WordWrap = True
          OnClick = btnGrupoFilasClick
        end
      end
    end
  end
  object pnlUnidades: TPanel
    Left = 0
    Top = 0
    Width = 329
    Height = 571
    Align = alLeft
    BevelOuter = bvNone
    Caption = 'pnlUnidades'
    TabOrder = 1
    object grdUnidades: TDBGrid
      Left = 0
      Top = 110
      Width = 329
      Height = 420
      Align = alClient
      DataSource = dscUnidades
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
      PopupMenu = mnuUnidades
      ReadOnly = True
      TabOrder = 0
      TitleFont.Charset = ANSI_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -12
      TitleFont.Name = 'Verdana'
      TitleFont.Style = []
      OnDblClick = grdUnidadesDblClick
      OnKeyUp = grdUnidadesKeyUp
      Columns = <
        item
          Expanded = False
          FieldName = 'ID'
          Title.Caption = 'Id'
          Width = 50
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NOME'
          Title.Caption = 'Nome da Unidade'
          Width = 244
          Visible = True
        end>
    end
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 329
      Height = 110
      Align = alTop
      BevelKind = bkFlat
      BevelOuter = bvNone
      Color = clWindow
      ParentBackground = False
      TabOrder = 1
      DesignSize = (
        325
        106)
      object Label1: TLabel
        Left = 4
        Top = 7
        Width = 45
        Height = 14
        Caption = '&Grupos'
        FocusControl = cboGrupos
      end
      object Label2: TLabel
        Left = 4
        Top = 55
        Width = 36
        Height = 14
        Caption = '&Filtrar'
        FocusControl = edtFiltro
      end
      object cboGrupos: TComboBox
        Left = 4
        Top = 23
        Width = 290
        Height = 22
        Anchors = [akLeft, akTop, akRight]
        DropDownCount = 12
        TabOrder = 0
        OnCloseUp = cboGruposCloseUp
      end
      object Button1: TButton
        Left = 296
        Top = 22
        Width = 25
        Height = 24
        Anchors = [akTop, akRight]
        Caption = '...'
        TabOrder = 1
        OnClick = Button1Click
      end
      object edtFiltro: TEdit
        Left = 4
        Top = 71
        Width = 317
        Height = 22
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 2
        TextHint = 'Filtrar por Id ou Nome da Unidade'
        OnKeyUp = edtFiltroKeyUp
      end
    end
    object pnlRodapeUnidades: TPanel
      Left = 0
      Top = 530
      Width = 329
      Height = 41
      Align = alBottom
      BevelKind = bkFlat
      BevelOuter = bvNone
      TabOrder = 2
      DesignSize = (
        325
        37)
      object btnNovaUnidade: TBitBtn
        Left = 4
        Top = 6
        Width = 61
        Height = 25
        Caption = '&Nova'
        TabOrder = 0
        OnClick = mnuNovaUnidadeClick
      end
      object btnAlterarUnidade: TBitBtn
        Left = 66
        Top = 6
        Width = 61
        Height = 25
        Caption = 'A&lterar'
        TabOrder = 1
        OnClick = grdUnidadesDblClick
      end
      object btnExcluirUnidade: TBitBtn
        Left = 128
        Top = 6
        Width = 61
        Height = 25
        Caption = '&Excluir'
        TabOrder = 2
        OnClick = mnuExcluirUnidadeClick
      end
      object btnDevicesUnidade: TButton
        Left = 260
        Top = 6
        Width = 61
        Height = 25
        Anchors = [akTop, akRight]
        Caption = '&Devices'
        TabOrder = 3
        OnClick = btnDevicesUnidadeClick
      end
    end
  end
  object qryUnidades: TFDQuery
    CachedUpdates = True
    Connection = connUnidades
    SQL.Strings = (
      
        'SELECT * FROM UNIDADES WHERE ((IDGRUPO = :IDGRUPO) OR (:IDGRUPO ' +
        '= 0))')
    Left = 32
    Top = 104
    ParamData = <
      item
        Position = 1
        Name = 'IDGRUPO'
        DataType = ftInteger
        ParamType = ptInput
      end>
    object qryUnidadesID: TIntegerField
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInUpdate, pfInKey]
      Required = True
    end
    object qryUnidadesNOME: TStringField
      FieldName = 'NOME'
      Origin = 'NOME'
      ProviderFlags = [pfInUpdate]
      Size = 40
    end
    object qryUnidadesDBDIR: TStringField
      FieldName = 'DBDIR'
      Origin = 'DBDIR'
      ProviderFlags = [pfInUpdate]
      Size = 255
    end
    object qryUnidadesIP: TStringField
      FieldName = 'IP'
      Origin = 'IP'
      ProviderFlags = [pfInUpdate]
      Size = 255
    end
    object qryUnidadesPORTA: TIntegerField
      FieldName = 'PORTA'
      Origin = 'PORTA'
      ProviderFlags = [pfInUpdate]
    end
    object qryUnidadesPORTA_TGS: TIntegerField
      FieldName = 'PORTA_TGS'
      Origin = 'PORTA_TGS'
      ProviderFlags = [pfInUpdate]
    end
    object qryUnidadesID_UNID_CLI: TStringField
      FieldName = 'ID_UNID_CLI'
      Origin = 'ID_UNID_CLI'
      ProviderFlags = [pfInUpdate]
      Size = 32
    end
    object qryUnidadesIDGRUPO: TIntegerField
      FieldName = 'IDGRUPO'
      Origin = 'IDGRUPO'
      ProviderFlags = [pfInUpdate]
    end
    object qryUnidadesHOST: TStringField
      FieldName = 'HOST'
      Origin = 'HOST'
      ProviderFlags = [pfInUpdate]
      Size = 100
    end
    object qryUnidadesBANCO: TStringField
      FieldName = 'BANCO'
      Origin = 'BANCO'
      ProviderFlags = [pfInUpdate]
      Size = 100
    end
    object qryUnidadesUSUARIO: TStringField
      FieldName = 'USUARIO'
      Origin = 'USUARIO'
      ProviderFlags = [pfInUpdate]
      Size = 100
    end
    object qryUnidadesSENHA: TStringField
      FieldName = 'SENHA'
      Origin = 'SENHA'
      ProviderFlags = [pfInUpdate]
      Size = 255
    end
    object qryUnidadesOSAUTHENT: TStringField
      FieldName = 'OSAUTHENT'
      Origin = 'OSAUTHENT'
      ProviderFlags = [pfInUpdate]
      FixedChar = True
      Size = 1
    end
    object qryUnidadesTIPOBANCO: TStringField
      FieldName = 'TIPOBANCO'
      FixedChar = True
      Size = 1
    end
  end
  object dscUnidades: TDataSource
    DataSet = cdsUnidades
    OnDataChange = dscUnidadesDataChange
    Left = 200
    Top = 104
  end
  object cdsUnidades: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <
      item
        DataType = ftInteger
        Name = 'IDGRUPO'
        ParamType = ptInput
      end>
    ProviderName = 'dspUnidades'
    AfterScroll = cdsUnidadesAfterScroll
    OnNewRecord = cdsUnidadesNewRecord
    OnReconcileError = cdsUnidadesReconcileError
    Left = 176
    Top = 280
    object cdsUnidadesID: TIntegerField
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInUpdate, pfInKey]
      Visible = False
    end
    object cdsUnidadesNOME: TStringField
      DisplayLabel = 'Unidades'
      FieldName = 'NOME'
      Origin = 'NOME'
      ProviderFlags = [pfInUpdate]
      Size = 40
    end
    object cdsUnidadesDBDIR: TStringField
      FieldName = 'DBDIR'
      Origin = 'DBDIR'
      ProviderFlags = [pfInUpdate]
      Visible = False
      Size = 255
    end
    object cdsUnidadesIP: TStringField
      FieldName = 'IP'
      Origin = 'IP'
      ProviderFlags = [pfInUpdate]
      Visible = False
      Size = 255
    end
    object cdsUnidadesPORTA: TIntegerField
      FieldName = 'PORTA'
      Origin = 'PORTA'
      ProviderFlags = [pfInUpdate]
      Visible = False
    end
    object cdsUnidadesPORTA_TGS: TIntegerField
      FieldName = 'PORTA_TGS'
      Origin = 'PORTA_TGS'
      ProviderFlags = [pfInUpdate]
      Visible = False
    end
    object cdsUnidadesCONECTADO_SOCKET: TIntegerField
      FieldKind = fkCalculated
      FieldName = 'CONECTADO_SOCKET'
      Calculated = True
    end
    object cdsUnidadesCONECTADO_BASE: TIntegerField
      FieldKind = fkCalculated
      FieldName = 'CONECTADO_BASE'
      Calculated = True
    end
    object cdsUnidadesID_UNID_CLI: TStringField
      FieldName = 'ID_UNID_CLI'
      Origin = 'ID_UNID_CLI'
      ProviderFlags = [pfInUpdate]
      Size = 32
    end
    object cdsUnidadesIDGRUPO: TIntegerField
      FieldName = 'IDGRUPO'
      Origin = 'IDGRUPO'
      ProviderFlags = [pfInUpdate]
    end
    object cdsUnidadesHOST: TStringField
      FieldName = 'HOST'
      Origin = 'HOST'
      ProviderFlags = [pfInUpdate]
      Size = 100
    end
    object cdsUnidadesBANCO: TStringField
      FieldName = 'BANCO'
      Origin = 'BANCO'
      ProviderFlags = [pfInUpdate]
      Size = 100
    end
    object cdsUnidadesUSUARIO: TStringField
      FieldName = 'USUARIO'
      Origin = 'USUARIO'
      ProviderFlags = [pfInUpdate]
      Size = 100
    end
    object cdsUnidadesSENHA: TStringField
      FieldName = 'SENHA'
      Origin = 'SENHA'
      ProviderFlags = [pfInUpdate]
      Size = 255
    end
    object cdsUnidadesOSAUTHENT: TStringField
      FieldName = 'OSAUTHENT'
      Origin = 'OSAUTHENT'
      ProviderFlags = [pfInUpdate]
      FixedChar = True
      Size = 1
    end
    object cdsUnidadesTIPOBANCO: TStringField
      FieldName = 'TIPOBANCO'
      FixedChar = True
      Size = 1
    end
  end
  object dspUnidades: TDataSetProvider
    DataSet = qryUnidades
    Options = [poAutoRefresh, poPropogateChanges, poUseQuoteChar]
    UpdateMode = upWhereKeyOnly
    BeforeUpdateRecord = dspUnidadesBeforeUpdateRecord
    Left = 104
    Top = 112
  end
  object ClientSocket: TClientSocket
    Active = False
    ClientType = ctNonBlocking
    Port = 0
    OnRead = ClientSocketRead
    OnError = ClientSocketError
    Left = 24
    Top = 175
  end
  object ImageList: TImageList
    Left = 96
    Top = 160
    Bitmap = {
      494C010103000500040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000080000000800000008000000080000000800000008000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000008000000080000000800000008000000080000000800000008000000080
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808080008080
      8000808080000000000080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000080
      0000008000000080000000800000008000000080000000800000008000000080
      0000008000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000808080008080
      8000000000008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF0000000000000000000000FF000000FF000000FF000000FF00000000000000
      00000000FF000000FF0000000000000000000000000000000000008000000080
      0000008000000080000000800000D0F5E7005BDBAA0000800000008000000080
      0000008000000080000000000000000000000000000000000000000000000000
      0000000000000000000000000000808080000000000000000000808080000000
      0000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF000000000000000000000000000000FF000000FF0000000000000000000000
      00000000FF000000FF0000000000000000000000000000800000008000000080
      00000080000000800000DCF7ED0000000000FEFFFE005BDBAA00008000000080
      0000008000000080000000000000000000000000000000000000000000000000
      0000000000000000000080808000000000008080800000000000000000008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF00000000000000000000800000008000000080
      000000800000DDF8ED00000000000000000000000000FEFFFF005DDBAB000080
      0000008000000080000000800000000000000000000000000000000000000000
      0000000000008080800000000000000000000000000000000000000000000000
      0000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF000000FF000000FF00000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF00000000000000000000800000008000000080
      0000C7F3E20000000000FEFFFF006EDFB400E0F8EF0000000000FEFFFF006BDE
      B200008000000080000000800000000000000000000000000000000000000000
      0000808080000000000000000000000000000000000000000000808080008080
      8000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF000000FF000000FF00000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF00000000000000000000800000008000000080
      000000800000F2FCF9007CE2BB000080000000800000E3F9F00000000000FEFF
      FF007BE2BA000080000000800000000000000000000000000000000000000000
      0000808080008080800080808000000000000000000000000000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF00000000000000000000800000008000000080
      0000008000000080000000800000008000000080000000800000E6F9F2000000
      0000DDF8EE000080000000800000000000000000000000000000000000000000
      0000808080008080800080808000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF000000000000000000000000000000FF000000FF0000000000000000000000
      00000000FF000000FF0000000000000000000000000000800000008000000080
      000000800000008000000080000000800000008000000080000000800000C3F2
      E000008000000080000000000000000000000000000000000000000000000000
      0000808080000000000080808000000000008080800080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF0000000000000000000000FF000000FF000000FF000000FF00000000000000
      00000000FF000000FF0000000000000000000000000000000000008000000080
      0000008000000080000000800000008000000080000000800000008000000080
      0000008000000080000000000000000000000000000000000000000000008080
      8000000000008080800000000000808080008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000080
      0000008000000080000000800000008000000080000000800000008000000080
      0000008000000000000000000000000000000000000000000000808080000000
      0000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000008000000080000000800000008000000080000000800000008000000080
      0000000000000000000000000000000000000000000080808000000000008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000080000000800000008000000080000000800000008000000000
      0000000000000000000000000000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFFFFFF0000F81FF81FFFFB0000
      F00FF00FFF850000E007E007FF490000CC33C003FE9300008E738103FD630000
      87E18381FAC7000083C18441F5C3000083C18021F1D7000087E18011F08F0000
      8E738003F43F0000CC33C003E83F0000E007E007D3FF0000F00FF00FA7FF0000
      F81FF81F8FFF0000FFFFFFFFFFFF000000000000000000000000000000000000
      000000000000}
  end
  object mnuUnidades: TPopupMenu
    OnPopup = mnuUnidadesPopup
    Left = 344
    Top = 177
    object mnuNovaUnidade: TMenuItem
      Caption = 'Nova Unidade'
      OnClick = mnuNovaUnidadeClick
    end
    object mnuExcluirUnidade: TMenuItem
      Caption = 'Excluir Unidade'
      OnClick = mnuExcluirUnidadeClick
    end
    object mnuPingUnidade: TMenuItem
      Caption = 'Ping'
      OnClick = btnPingClick
    end
  end
  object qryAuxScriptBd: TFDQuery
    Connection = connUnidades
    SQL.Strings = (
      'SELECT'
      '  RDB$RELATION_NAME'
      'FROM'
      '  RDB$RELATIONS'
      'WHERE'
      '  RDB$RELATION_NAME = '#39'CONFIGURACOES_GERAIS'#39)
    Left = 23
    Top = 223
  end
  object connUnidades: TFDConnection
    LoginPrompt = False
    Left = 240
    Top = 168
  end
  object qryGrupo: TFDQuery
    Connection = connUnidades
    SQL.Strings = (
      'SELECT'
      '  *'
      'FROM'
      '  GRUPOS'
      'ORDER BY'
      '  IDGRUPO')
    Left = 456
    Top = 305
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
  object dsGrupo: TDataSource
    DataSet = cdsGrupo
    Left = 512
    Top = 360
  end
  object dspGrupo: TDataSetProvider
    DataSet = qryGrupo
    Left = 512
    Top = 304
  end
  object cdsGrupo: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspGrupo'
    Left = 456
    Top = 360
    object cdsGrupoIDGRUPO: TIntegerField
      FieldName = 'IDGRUPO'
      Required = True
    end
    object cdsGrupoNOME: TStringField
      FieldName = 'NOME'
      Size = 50
    end
  end
  object menuAcoesTreeView: TPopupMenu
    OnPopup = menuAcoesTreeViewPopup
    Left = 648
    Top = 184
    object menuPing: TMenuItem
      Caption = '&Ping'
      OnClick = btnPingClick
    end
    object menuSCCM: TMenuItem
      Caption = '&SCCM'
      OnClick = menuSCCMClick
    end
    object menuTelnet: TMenuItem
      Caption = '&Telnet'
      object menuPorta9999: TMenuItem
        Caption = 'Porta &9999'
        OnClick = menuTelnetClick
      end
      object menuPorta3001: TMenuItem
        Caption = 'Porta &3001'
        OnClick = menuTelnetClick
      end
      object menuPorta5000: TMenuItem
        Caption = 'Porta &5000'
        OnClick = menuTelnetClick
      end
      object menuOutraPorta: TMenuItem
        Caption = '&Outra porta...'
        OnClick = menuTelnetClick
      end
    end
  end
end
