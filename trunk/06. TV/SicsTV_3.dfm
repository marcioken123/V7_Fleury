object frmSicsHorarioDeFuncionamento: TfrmSicsHorarioDeFuncionamento
  Left = 258
  Top = 103
  Caption = 'Hor'#225'rio de funcionamento'
  ClientHeight = 124
  ClientWidth = 243
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 27
    Top = 19
    Width = 17
    Height = 13
    Caption = '&De:'
  end
  object Label2: TLabel
    Left = 144
    Top = 19
    Width = 19
    Height = 13
    Caption = '&At'#233':'
  end
  object Label3: TLabel
    Left = 77
    Top = 19
    Width = 3
    Height = 13
    Caption = ':'
  end
  object Label4: TLabel
    Left = 194
    Top = 19
    Width = 3
    Height = 13
    Caption = ':'
  end
  object chkFuncionaDomingo: TCheckBox
    Left = 130
    Top = 60
    Width = 110
    Height = 17
    Caption = 'Funciona do&mingo'
    TabOrder = 0
  end
  object chkFuncionaSabado: TCheckBox
    Left = 10
    Top = 60
    Width = 104
    Height = 17
    Caption = 'Funciona &s'#225'bado'
    TabOrder = 1
  end
  object btnOK: TButton
    Left = 33
    Top = 95
    Width = 75
    Height = 25
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object btnCancela: TButton
    Left = 143
    Top = 95
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Cancela'
    ModalResult = 2
    TabOrder = 3
  end
  object edDeH: TEdit
    Left = 50
    Top = 15
    Width = 23
    Height = 21
    TabOrder = 4
    Text = 'edDeH'
  end
  object edDeM: TEdit
    Left = 84
    Top = 15
    Width = 23
    Height = 21
    TabOrder = 5
    Text = 'edDeH'
  end
  object edAteH: TEdit
    Left = 167
    Top = 15
    Width = 23
    Height = 21
    TabOrder = 6
    Text = 'edDeH'
  end
  object edAteM: TEdit
    Left = 201
    Top = 15
    Width = 23
    Height = 21
    TabOrder = 7
    Text = 'edDeH'
  end
end
