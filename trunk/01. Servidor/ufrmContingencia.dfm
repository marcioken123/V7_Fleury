object frmSicsContingencia: TfrmSicsContingencia
  Left = 169
  Top = 106
  Caption = 'SICS - Servidor de Conting'#234'ncia'
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
    Left = 104
    Top = 48
    Width = 388
    Height = 37
    Caption = 'Servidor de Conting'#234'ncia'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -32
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 96
    Top = 160
    Width = 225
    Height = 19
    Alignment = taRightJustify
    AutoSize = False
    Caption = #218'ltima atualiza'#231#227'o de RT File:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblUltimaAtualizacaoRTFile: TLabel
    Left = 328
    Top = 160
    Width = 194
    Height = 19
    AutoSize = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 96
    Top = 128
    Width = 225
    Height = 19
    Alignment = taRightJustify
    AutoSize = False
    Caption = #218'ltima atualiza'#231#227'o de RT ID:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblUltimaAtualizacaoRTId: TLabel
    Left = 328
    Top = 128
    Width = 194
    Height = 19
    AutoSize = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Button1: TButton
    Left = 208
    Top = 216
    Width = 250
    Height = 65
    Caption = 'Avaliar Atualiza'#231#245'es'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = Button1Click
  end
  object btnAtivar: TButton
    Left = 208
    Top = 296
    Width = 250
    Height = 65
    Caption = 'Ativar'
    Enabled = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = btnAtivarClick
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
