object frmSicsPrincipalInoperante: TfrmSicsPrincipalInoperante
  Left = 88
  Top = 187
  Caption = 'SICS - Servidor Principal Inoperante'
  ClientHeight = 422
  ClientWidth = 680
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 168
    Top = 72
    Width = 342
    Height = 24
    Caption = 'Servidor Principal est'#225' inoperante'
    Font.Charset = ANSI_CHARSET
    Font.Color = clRed
    Font.Height = -21
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 128
    Top = 120
    Width = 455
    Height = 24
    Caption = 'Servidor Contigente atuando neste momento'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object BitBtn1: TBitBtn
    Left = 216
    Top = 184
    Width = 281
    Height = 89
    Caption = 'Sincronizar com Contingente'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = BitBtn1Click
  end
  object MainMenu1: TMainMenu
    Left = 72
    Top = 216
    object Arquivo1: TMenuItem
      Caption = '&Arquivo'
      object Sair1: TMenuItem
        Caption = 'Sai&r'
        OnClick = Sair1Click
      end
    end
    object N1: TMenuItem
      Caption = '&?'
      object Sobre1: TMenuItem
        Caption = '&Sobre...'
        OnClick = Sobre1Click
      end
    end
  end
end
