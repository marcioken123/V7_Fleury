object frmDebugParameters: TfrmDebugParameters
  Left = 310
  Top = 123
  Caption = 'Par'#226'metros de debug'
  ClientHeight = 487
  ClientWidth = 612
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    612
    487)
  PixelsPerInch = 96
  TextHeight = 13
  object grpDebug: TGroupBox
    Left = 14
    Top = 11
    Width = 590
    Height = 86
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    DesignSize = (
      590
      86)
    object Label1: TLabel
      Left = 8
      Top = 29
      Width = 77
      Height = 13
      Caption = 'N'#237'vel de debug:'
    end
    object Label2: TLabel
      Left = 8
      Top = 58
      Width = 91
      Height = 13
      Caption = 'Arquivo de registro:'
    end
    object edDebugNivel: TEdit
      Left = 90
      Top = 25
      Width = 39
      Height = 21
      Hint = 
        '1 - mensagem na tela  /  2 - grava log  /  3 - mensagem na tela ' +
        'e grava log'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Text = '2'
    end
    object edDebugFileName: TEdit
      Left = 104
      Top = 54
      Width = 395
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
    end
  end
  object chkDebugMode: TCheckBox
    Left = 28
    Top = 8
    Width = 85
    Height = 17
    Caption = 'Modo debug'
    TabOrder = 0
    OnClick = chkDebugModeClick
  end
  object btnOK: TButton
    Left = 440
    Top = 454
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
    OnClick = btnOKClick
  end
  object btnCancela: TButton
    Left = 528
    Top = 454
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = '&Cancela'
    ModalResult = 2
    TabOrder = 3
    OnClick = btnCancelaClick
  end
  object btnAplicar: TButton
    Left = 520
    Top = 33
    Width = 75
    Height = 46
    Anchors = [akTop, akRight]
    Caption = 'Aplicar'
    TabOrder = 4
    OnClick = btnAplicarClick
  end
  object memoDebug: TMemo
    Left = 160
    Top = 103
    Width = 443
    Height = 345
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 5
    WordWrap = False
  end
  object chkWordWrap: TCheckBox
    Left = 14
    Top = 459
    Width = 85
    Height = 16
    Anchors = [akLeft, akBottom]
    Caption = 'Word wrap'
    TabOrder = 6
    OnClick = chkWordWrapClick
  end
  object chklistTiposDebug: TCheckListBox
    Left = 14
    Top = 103
    Width = 140
    Height = 345
    OnClickCheck = chklistTiposDebugClickCheck
    Anchors = [akLeft, akTop, akBottom]
    ItemHeight = 13
    TabOrder = 7
  end
  object btnLimparMemo: TButton
    Left = 160
    Top = 454
    Width = 65
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = '&Limpar'
    TabOrder = 8
    OnClick = btnLimparMemoClick
  end
end
