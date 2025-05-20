object frmSicsGerarNovaSenhaOuUtilizarUltima: TfrmSicsGerarNovaSenhaOuUtilizarUltima
  Left = 533
  Top = 270
  Caption = 'Confirma'#231#227'o'
  ClientHeight = 159
  ClientWidth = 273
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
  object lblPergunta: TLabel
    Left = 10
    Top = 10
    Width = 262
    Height = 29
    AutoSize = False
    Caption = 
      'Voc'#234' gostaria de criar uma nova senha 330 ou trata-se da '#250'ltima ' +
      'que foi utilizada com este n'#250'mero?'
    WordWrap = True
  end
  object rgEscolha: TRadioGroup
    Left = 8
    Top = 48
    Width = 265
    Height = 73
    Items.Strings = (
      'Gerar nova senha'
      'Utilizar a '#250'ltima')
    TabOrder = 0
    OnClick = rgEscolhaClick
  end
  object btnOK: TButton
    Left = 112
    Top = 136
    Width = 75
    Height = 25
    Caption = '&OK'
    Default = True
    Enabled = False
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancela: TButton
    Left = 200
    Top = 136
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Cancela'
    ModalResult = 2
    TabOrder = 2
  end
end
