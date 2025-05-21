object frmCaminhosUpdate: TfrmCaminhosUpdate
  Left = 0
  Top = 0
  Caption = 'Caminhos de Update'
  ClientHeight = 290
  ClientWidth = 548
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    548
    290)
  PixelsPerInch = 96
  TextHeight = 13
  object lblPA: TLabel
    Left = 16
    Top = 32
    Width = 13
    Height = 13
    Caption = 'PA'
  end
  object lblMultPA: TLabel
    Left = 16
    Top = 59
    Width = 38
    Height = 13
    Caption = 'Multi PA'
  end
  object lblTV: TLabel
    Left = 16
    Top = 87
    Width = 12
    Height = 13
    Caption = 'TV'
  end
  object lblOnline: TLabel
    Left = 16
    Top = 115
    Width = 30
    Height = 13
    Caption = 'Online'
  end
  object lblTGS: TLabel
    Left = 16
    Top = 143
    Width = 19
    Height = 13
    Caption = 'TGS'
  end
  object Label1: TLabel
    Left = 16
    Top = 171
    Width = 50
    Height = 13
    Caption = 'CallCenter'
  end
  object Label2: TLabel
    Left = 16
    Top = 199
    Width = 30
    Height = 13
    Caption = 'Totem'
  end
  object edtCaminhoPA: TEdit
    Left = 72
    Top = 29
    Width = 458
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
  end
  object edtCaminhoMultPA: TEdit
    Left = 72
    Top = 56
    Width = 458
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
  end
  object edtCaminhoTV: TEdit
    Left = 72
    Top = 84
    Width = 458
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
  end
  object edtCaminhoOnline: TEdit
    Left = 72
    Top = 112
    Width = 458
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 3
  end
  object edtCaminhoTGS: TEdit
    Left = 72
    Top = 140
    Width = 458
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 4
  end
  object btnOK: TBitBtn
    Left = 310
    Top = 241
    Width = 106
    Height = 41
    Anchors = [akRight, akBottom]
    Caption = '&OK'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
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
    ParentFont = False
    TabOrder = 7
    OnClick = btnOKClick
  end
  object btnCancelar: TBitBtn
    Left = 422
    Top = 241
    Width = 106
    Height = 41
    Anchors = [akRight, akBottom]
    Caption = '&Cancela'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
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
    ParentFont = False
    TabOrder = 8
    OnClick = btnCancelarClick
  end
  object edtCaminhoCallCenter: TEdit
    Left = 72
    Top = 168
    Width = 458
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 5
  end
  object edtCaminhoTotemtouch: TEdit
    Left = 72
    Top = 196
    Width = 458
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 6
  end
  object qryCaminhosUpdate: TFDQuery
    SQL.Strings = (
      'select'
      '  ID_UNIDADE,'
      '            ID,'
      '           VALOR'
      'from'
      '           CONFIGURACOES_GERAIS '
      'where '
      '  ID_UNIDADE = :ID_UNIDADE AND'
      '  ID in (:PATH_UPDATE_TV,'
      '                    :PATH_UPDATE_TGS,'
      '                    :PATH_UPDATE_ONLINE,'
      '                    :PATH_UPDATE_MULTIPA,'
      '                    :PATH_UPDATE_PA,'
      '                    :PATH_UPDATE_CALLCENTER,'
      '         :PATH_UPDATE_TOTEMTOUCH)')
    Left = 248
    Top = 218
    ParamData = <
      item
        Name = 'ID_UNIDADE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'PATH_UPDATE_TV'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'PATH_UPDATE_TGS'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'PATH_UPDATE_ONLINE'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'PATH_UPDATE_MULTIPA'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'PATH_UPDATE_PA'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'PATH_UPDATE_CALLCENTER'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'PATH_UPDATE_TOTEMTOUCH'
        DataType = ftString
        ParamType = ptInput
      end>
  end
  object dspCaminhosUpdate: TDataSetProvider
    DataSet = qryCaminhosUpdate
    Left = 144
    Top = 218
  end
  object cdsCaminhosUpdate: TClientDataSet
    Aggregates = <>
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_UNIDADE'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = 'PATH_UPDATE_TV'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = 'PATH_UPDATE_TGS'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = 'PATH_UPDATE_ONLINE'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = 'PATH_UPDATE_MULTIPA'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = 'PATH_UPDATE_PA'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = 'PATH_UPDATE_CALLCENTER'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = 'PATH_UPDATE_TOTEMTOUCH'
        ParamType = ptInput
      end>
    ProviderName = 'dspCaminhosUpdate'
    Left = 40
    Top = 218
  end
end
