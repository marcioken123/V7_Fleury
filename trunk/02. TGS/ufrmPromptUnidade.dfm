object frmSicsPromptUnidade: TfrmSicsPromptUnidade
  Left = 342
  Top = 116
  BorderStyle = bsDialog
  Caption = 'Selecione a Unidade'
  ClientHeight = 92
  ClientWidth = 328
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TAspLabel 
 TextSettings.WordWrap = False
    Left = 11
    Top = 16
    Width = 40
    Height = 13
    Caption = 'Unidade'
  end
  object btnOK: TAspButton
    Left = 55
    Top = 48
    Width = 105
    Height = 30
    Caption = 'OK'
    Default = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ModalResult = 1
    ParentFont = False
    TabOrder = 0
  end
  object btnCancelar: TAspButton
    Left = 166
    Top = 48
    Width = 105
    Height = 30
    Caption = 'Cancelar'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
  object cmbUnidade: TComboBox
    Left = 71
    Top = 8
    Width = 249
    Height = 21
    TabOrder = 2
  end
  object cdsUnidades: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 216
    Top = 8
  end
  object dtsUnidade: TDataSource
    DataSet = cdsUnidades
    Left = 184
    Top = 8
  end
end
