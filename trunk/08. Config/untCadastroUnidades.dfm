object FrmCadastroUnidades: TFrmCadastroUnidades
  Left = 518
  Top = 298
  Caption = 'Cadastro de Unidades'
  ClientHeight = 331
  ClientWidth = 705
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  DesignSize = (
    705
    331)
  PixelsPerInch = 96
  TextHeight = 13
  object lblNome: TLabel
    Left = 8
    Top = 8
    Width = 33
    Height = 13
    Caption = 'Nome'
  end
  object lblIP: TLabel
    Left = 416
    Top = 8
    Width = 50
    Height = 13
    Anchors = [akTop, akRight]
    Caption = 'IP / Host'
  end
  object lblBaseDados: TLabel
    Left = 134
    Top = 128
    Width = 86
    Height = 13
    Caption = 'Base de Dados'
  end
  object lblPorta: TLabel
    Left = 8
    Top = 48
    Width = 30
    Height = 13
    Caption = 'Porta'
  end
  object lblPortaTGS: TLabel
    Left = 95
    Top = 48
    Width = 58
    Height = 13
    Caption = 'Porta TGS'
  end
  object lblIDUnidade: TLabel
    Left = 175
    Top = 48
    Width = 108
    Height = 13
    Caption = 'ID Unidade Cliente'
  end
  object lblTipoBanco: TLabel
    Left = 8
    Top = 128
    Width = 81
    Height = 13
    Caption = 'Tipo do Banco'
  end
  object Label1: TLabel
    Left = 8
    Top = 88
    Width = 35
    Height = 13
    Caption = 'Grupo'
  end
  object edtNome: TDBEdit
    Left = 8
    Top = 24
    Width = 402
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    DataField = 'NOME'
    DataSource = MainForm.dscUnidades
    TabOrder = 0
  end
  object edtIP: TDBEdit
    Left = 416
    Top = 24
    Width = 281
    Height = 21
    Anchors = [akTop, akRight]
    DataField = 'IP'
    DataSource = MainForm.dscUnidades
    TabOrder = 1
  end
  object edtBaseDados: TDBEdit
    Left = 134
    Top = 144
    Width = 563
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    DataField = 'DBDIR'
    DataSource = MainForm.dscUnidades
    TabOrder = 7
  end
  object edtPorta: TDBEdit
    Left = 8
    Top = 64
    Width = 81
    Height = 21
    DataField = 'PORTA'
    DataSource = MainForm.dscUnidades
    TabOrder = 2
  end
  object edtPortaTGS: TDBEdit
    Left = 95
    Top = 64
    Width = 74
    Height = 21
    DataField = 'PORTA_TGS'
    DataSource = MainForm.dscUnidades
    TabOrder = 3
  end
  object btnOK: TBitBtn
    Left = 517
    Top = 293
    Width = 87
    Height = 30
    Anchors = [akRight, akBottom]
    Caption = 'OK'
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
    NumGlyphs = 2
    TabOrder = 9
    OnClick = btnOKClick
  end
  object btnCancelar: TBitBtn
    Left = 610
    Top = 293
    Width = 87
    Height = 30
    Anchors = [akRight, akBottom]
    Caption = 'Cancelar'
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
    NumGlyphs = 2
    TabOrder = 10
    OnClick = btnCancelarClick
  end
  object edtIDUnidadeCliente: TDBEdit
    Left = 175
    Top = 64
    Width = 522
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    DataField = 'ID_UNID_CLI'
    DataSource = MainForm.dscUnidades
    TabOrder = 4
  end
  object pnlConexaoSQL: TPanel
    Left = 8
    Top = 171
    Width = 689
    Height = 111
    Anchors = [akLeft, akTop, akRight]
    BevelInner = bvLowered
    TabOrder = 8
    DesignSize = (
      689
      111)
    object lblServer: TLabel
      Left = 6
      Top = 4
      Width = 39
      Height = 13
      Caption = 'Server'
    end
    object lblBanco: TLabel
      Left = 275
      Top = 4
      Width = 35
      Height = 13
      Caption = 'Banco'
    end
    object lblUsuario: TLabel
      Left = 6
      Top = 44
      Width = 43
      Height = 13
      Caption = 'Usu'#225'rio'
    end
    object lblSenha: TLabel
      Left = 275
      Top = 44
      Width = 36
      Height = 13
      Caption = 'Senha'
    end
    object edtServerSQL: TDBEdit
      Left = 6
      Top = 20
      Width = 240
      Height = 21
      DataField = 'HOST'
      DataSource = MainForm.dscUnidades
      TabOrder = 0
    end
    object edtBancoSQL: TDBEdit
      Left = 275
      Top = 20
      Width = 410
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      DataField = 'BANCO'
      DataSource = MainForm.dscUnidades
      TabOrder = 1
    end
    object edtUsuarioSQL: TDBEdit
      Left = 6
      Top = 60
      Width = 240
      Height = 21
      DataField = 'USUARIO'
      DataSource = MainForm.dscUnidades
      TabOrder = 2
    end
    object edtSenhaSQL: TDBEdit
      Left = 275
      Top = 60
      Width = 410
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      DataField = 'SENHA'
      DataSource = MainForm.dscUnidades
      PasswordChar = '*'
      TabOrder = 3
    end
    object chxAutenticacaoOSSQL: TDBCheckBox
      Left = 6
      Top = 89
      Width = 239
      Height = 17
      Caption = 'Autentica'#231#227'o via sistema operacional'
      DataField = 'OSAUTHENT'
      DataSource = MainForm.dscUnidades
      TabOrder = 4
      ValueChecked = 'T'
      ValueUnchecked = 'F'
    end
  end
  object cbTipoBancodeDados: TComboBox
    Left = 8
    Top = 144
    Width = 120
    Height = 21
    Style = csDropDownList
    TabOrder = 6
    OnSelect = cbTipoBancodeDadosSelect
    Items.Strings = (
      'FireBird'
      'SQL Express')
  end
  object lkpGrupo: TDBLookupComboBox
    Left = 8
    Top = 104
    Width = 689
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    DataField = 'IDGRUPO'
    DataSource = MainForm.dscUnidades
    KeyField = 'IDGRUPO'
    ListField = 'NOME'
    ListSource = MainForm.dsGrupo
    TabOrder = 5
  end
end
