object frmSicsParamsNiveisSLA: TfrmSicsParamsNiveisSLA
  Left = 482
  Top = 275
  Caption = 'Par'#226'metros do Gr'#225'fico SLA'
  ClientHeight = 195
  ClientWidth = 283
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label7: TLabel
    Left = 66
    Top = 72
    Width = 137
    Height = 13
    Caption = 'N'#237'veis de separa'#231#227'o do SLA'
  end
  object Label13: TLabel
    Tag = 1
    Left = 154
    Top = 97
    Width = 2
    Height = 13
    AutoSize = False
    Caption = ':'
  end
  object Label14: TLabel
    Tag = 1
    Left = 184
    Top = 97
    Width = 2
    Height = 13
    AutoSize = False
    Caption = ':'
  end
  object Label15: TLabel
    Left = 78
    Top = 96
    Width = 47
    Height = 13
    Alignment = taRightJustify
    Caption = ' Amarelo :'
    Color = clYellow
    ParentColor = False
    Transparent = False
  end
  object Label16: TLabel
    Tag = 1
    Left = 154
    Top = 121
    Width = 2
    Height = 13
    AutoSize = False
    Caption = ':'
  end
  object Label17: TLabel
    Tag = 1
    Left = 184
    Top = 121
    Width = 2
    Height = 13
    AutoSize = False
    Caption = ':'
  end
  object Label18: TLabel
    Left = 71
    Top = 120
    Width = 53
    Height = 13
    Alignment = taRightJustify
    Caption = ' Vermelho :'
    Color = clRed
    ParentColor = False
    Transparent = False
  end
  object Bevel1: TBevel
    Left = 66
    Top = 88
    Width = 150
    Height = 2
    Shape = bsTopLine
  end
  object Label1: TLabel
    Left = 18
    Top = 16
    Width = 66
    Height = 13
    Caption = 'Carregar Perfil'
  end
  object SpeedButton3: TSpeedButton
    Left = 190
    Top = 30
    Width = 23
    Height = 22
    Hint = 'Criar perfil'
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000130B0000130B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0033333333B333
      333B33FF33337F3333F73BB3777BB7777BB3377FFFF77FFFF77333B000000000
      0B3333777777777777333330FFFFFFFF07333337F33333337F333330FFFFFFFF
      07333337F33333337F333330FFFFFFFF07333337F33333337F333330FFFFFFFF
      07333FF7F33333337FFFBBB0FFFFFFFF0BB37777F3333333777F3BB0FFFFFFFF
      0BBB3777F3333FFF77773330FFFF000003333337F333777773333330FFFF0FF0
      33333337F3337F37F3333330FFFF0F0B33333337F3337F77FF333330FFFF003B
      B3333337FFFF77377FF333B000000333BB33337777777F3377FF3BB3333BB333
      3BB33773333773333773B333333B3333333B7333333733333337}
    NumGlyphs = 2
    ParentShowHint = False
    ShowHint = True
    OnClick = SpeedButton3Click
  end
  object SpeedButton4: TSpeedButton
    Left = 215
    Top = 30
    Width = 23
    Height = 22
    Hint = 'Salvar perfil'
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000130B0000130B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333330070
      7700333333337777777733333333008088003333333377F73377333333330088
      88003333333377FFFF7733333333000000003FFFFFFF77777777000000000000
      000077777777777777770FFFFFFF0FFFFFF07F3333337F3333370FFFFFFF0FFF
      FFF07F3FF3FF7FFFFFF70F00F0080CCC9CC07F773773777777770FFFFFFFF039
      99337F3FFFF3F7F777F30F0000F0F09999937F7777373777777F0FFFFFFFF999
      99997F3FF3FFF77777770F00F000003999337F773777773777F30FFFF0FF0339
      99337F3FF7F3733777F30F08F0F0337999337F7737F73F7777330FFFF0039999
      93337FFFF7737777733300000033333333337777773333333333}
    NumGlyphs = 2
    ParentShowHint = False
    ShowHint = True
    OnClick = SpeedButton4Click
  end
  object SpeedButton5: TSpeedButton
    Left = 240
    Top = 30
    Width = 23
    Height = 22
    Hint = 'Excluir perfil'
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333000000000
      3333333777777777F3333330F777777033333337F3F3F3F7F3333330F0808070
      33333337F7F7F7F7F3333330F080707033333337F7F7F7F7F3333330F0808070
      33333337F7F7F7F7F3333330F080707033333337F7F7F7F7F3333330F0808070
      333333F7F7F7F7F7F3F33030F080707030333737F7F7F7F7F7333300F0808070
      03333377F7F7F7F773333330F080707033333337F7F7F7F7F333333070707070
      33333337F7F7F7F7FF3333000000000003333377777777777F33330F88877777
      0333337FFFFFFFFF7F3333000000000003333377777777777333333330777033
      3333333337FFF7F3333333333000003333333333377777333333}
    NumGlyphs = 2
    ParentShowHint = False
    ShowHint = True
    OnClick = SpeedButton5Click
  end
  object Bevel3: TBevel
    Left = 18
    Top = 144
    Width = 247
    Height = 2
    Shape = bsTopLine
  end
  object edtSLAPPAmareloHora: TEdit
    Tag = 1
    Left = 129
    Top = 93
    Width = 24
    Height = 20
    AutoSize = False
    MaxLength = 2
    TabOrder = 1
    Text = '00'
  end
  object edtSLAPPAmareloMin: TEdit
    Tag = 1
    Left = 159
    Top = 93
    Width = 24
    Height = 20
    AutoSize = False
    MaxLength = 2
    TabOrder = 2
    Text = '00'
  end
  object edtSLAPPAmareloSeg: TEdit
    Tag = 1
    Left = 189
    Top = 93
    Width = 24
    Height = 20
    AutoSize = False
    MaxLength = 2
    TabOrder = 3
    Text = '00'
  end
  object edtSLAPPVermelhoHora: TEdit
    Tag = 1
    Left = 129
    Top = 117
    Width = 24
    Height = 20
    AutoSize = False
    MaxLength = 2
    TabOrder = 4
    Text = '00'
  end
  object edtSLAPPVermelhoMin: TEdit
    Tag = 1
    Left = 159
    Top = 117
    Width = 24
    Height = 20
    AutoSize = False
    MaxLength = 2
    TabOrder = 5
    Text = '00'
  end
  object edtSLAPPVermelhoSeg: TEdit
    Tag = 1
    Left = 189
    Top = 117
    Width = 24
    Height = 20
    AutoSize = False
    MaxLength = 2
    TabOrder = 6
    Text = '00'
  end
  object btnOk: TBitBtn
    Left = 49
    Top = 158
    Width = 89
    Height = 25
    Caption = '&OK'
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
    ModalResult = 1
    NumGlyphs = 2
    TabOrder = 7
    OnClick = btnOkClick
  end
  object btnCancela: TBitBtn
    Left = 145
    Top = 158
    Width = 89
    Height = 25
    Cancel = True
    Caption = '&Cancela'
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      333333333333333333333333000033338833333333333333333F333333333333
      0000333911833333983333333388F333333F3333000033391118333911833333
      38F38F333F88F33300003339111183911118333338F338F3F8338F3300003333
      911118111118333338F3338F833338F3000033333911111111833333338F3338
      3333F8330000333333911111183333333338F333333F83330000333333311111
      8333333333338F3333383333000033333339111183333333333338F333833333
      00003333339111118333333333333833338F3333000033333911181118333333
      33338333338F333300003333911183911183333333383338F338F33300003333
      9118333911183333338F33838F338F33000033333913333391113333338FF833
      38F338F300003333333333333919333333388333338FFF830000333333333333
      3333333333333333333888330000333333333333333333333333333333333333
      0000}
    ModalResult = 2
    NumGlyphs = 2
    TabOrder = 8
  end
  object dblkpPerfis: TDBLookupComboBox
    Left = 18
    Top = 32
    Width = 163
    Height = 21
    KeyField = 'ID'
    ListField = 'NOME'
    ListSource = dtsPerfis
    TabOrder = 0
    OnClick = dblkpPerfisClick
  end
  object dtsPerfis: TDataSource
    DataSet = cdsPerfis
    Left = 231
    Top = 67
  end
  object cdsPerfisClone: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 158
    Top = 2
  end
  object cdsPerfis: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'nome'
    Params = <>
    AfterOpen = cdsPerfisAfterOpen
    AfterPost = cdsPerfisAfterPost
    AfterDelete = cdsPerfisAfterDelete
    Left = 125
    Top = 7
    object cdsPerfisID: TIntegerField
      FieldName = 'ID'
    end
    object cdsPerfisNOME: TStringField
      FieldName = 'NOME'
      Size = 40
    end
    object cdsPerfisPP_AMARELO: TIntegerField
      FieldName = 'PP_AMARELO'
    end
    object cdsPerfisPP_VERMELHO: TIntegerField
      FieldName = 'PP_VERMELHO'
    end
    object cdsPerfisINTCALC_ACABOU_CRIAR: TBooleanField
      FieldName = 'INTCALC_ACABOU_CRIAR'
    end
  end
end
