object frmSicsBackup: TfrmSicsBackup
  Left = 345
  Top = 294
  Caption = 'Backup'
  ClientHeight = 214
  ClientWidth = 610
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object grBackupAutomatico: TGroupBox
    Left = 8
    Top = 4
    Width = 607
    Height = 97
    TabOrder = 1
    object Label1: TLabel
      Left = 12
      Top = 74
      Width = 46
      Height = 13
      Caption = '&Na pasta:'
      Enabled = False
      FocusControl = edPasta
    end
    object Label2: TLabel
      Left = 22
      Top = 23
      Width = 89
      Height = 13
      Caption = '&A cada:         dia(s)'
      Enabled = False
      FocusControl = edDias
    end
    object Label5: TLabel
      Left = 43
      Top = 48
      Width = 15
      Height = 13
      Caption = #192'&s:'
      Enabled = False
      FocusControl = edHorario
    end
    object edPasta: TEdit
      Left = 62
      Top = 70
      Width = 507
      Height = 21
      CharCase = ecLowerCase
      Enabled = False
      TabOrder = 2
      Text = 'edpasta'
      OnChange = edDiasChange
    end
    object btnProcuraPasta: TBitBtn
      Left = 575
      Top = 73
      Width = 25
      Height = 21
      Enabled = False
      Glyph.Data = {
        62050000424D62050000000000003604000028000000120000000F0000000100
        0800000000002C01000000000000000000000001000000000000000000004000
        000080000000FF000000002000004020000080200000FF200000004000004040
        000080400000FF400000006000004060000080600000FF600000008000004080
        000080800000FF80000000A0000040A0000080A00000FFA0000000C0000040C0
        000080C00000FFC0000000FF000040FF000080FF0000FFFF0000000020004000
        200080002000FF002000002020004020200080202000FF202000004020004040
        200080402000FF402000006020004060200080602000FF602000008020004080
        200080802000FF80200000A0200040A0200080A02000FFA0200000C0200040C0
        200080C02000FFC0200000FF200040FF200080FF2000FFFF2000000040004000
        400080004000FF004000002040004020400080204000FF204000004040004040
        400080404000FF404000006040004060400080604000FF604000008040004080
        400080804000FF80400000A0400040A0400080A04000FFA0400000C0400040C0
        400080C04000FFC0400000FF400040FF400080FF4000FFFF4000000060004000
        600080006000FF006000002060004020600080206000FF206000004060004040
        600080406000FF406000006060004060600080606000FF606000008060004080
        600080806000FF80600000A0600040A0600080A06000FFA0600000C0600040C0
        600080C06000FFC0600000FF600040FF600080FF6000FFFF6000000080004000
        800080008000FF008000002080004020800080208000FF208000004080004040
        800080408000FF408000006080004060800080608000FF608000008080004080
        800080808000FF80800000A0800040A0800080A08000FFA0800000C0800040C0
        800080C08000FFC0800000FF800040FF800080FF8000FFFF80000000A0004000
        A0008000A000FF00A0000020A0004020A0008020A000FF20A0000040A0004040
        A0008040A000FF40A0000060A0004060A0008060A000FF60A0000080A0004080
        A0008080A000FF80A00000A0A00040A0A00080A0A000FFA0A00000C0A00040C0
        A00080C0A000FFC0A00000FFA00040FFA00080FFA000FFFFA0000000C0004000
        C0008000C000FF00C0000020C0004020C0008020C000FF20C0000040C0004040
        C0008040C000FF40C0000060C0004060C0008060C000FF60C0000080C0004080
        C0008080C000FF80C00000A0C00040A0C00080A0C000FFA0C00000C0C00040C0
        C00080C0C000FFC0C00000FFC00040FFC00080FFC000FFFFC0000000FF004000
        FF008000FF00FF00FF000020FF004020FF008020FF00FF20FF000040FF004040
        FF008040FF00FF40FF000060FF004060FF008060FF00FF60FF000080FF004080
        FF008080FF00FF80FF0000A0FF0040A0FF0080A0FF00FFA0FF0000C0FF0040C0
        FF0080C0FF00FFC0FF0000FFFF0040FFFF0080FFFF00FFFFFF00DBDBDBDBDBDB
        DBDBDBDBDBDBDBDBDBDBDBDB0000DB0000000000000000000000DBDBDBDBDBDB
        0000DB000090909090909090909000DBDBDBDBDB0000DB00FC00909090909090
        90909000DBDBDBDB0000DB00FFFC0090909090909090909000DBDBDB0000DB00
        FCFFFC0090909090909090909000DBDB0000DB00FFFCFFFC0000000000000000
        000000DB0000DB00FCFFFCFFFCFFFCFFFC00DBDBDBDBDBDB0000DB00FFFCFFFC
        FFFCFFFCFF00DBDBDBDBDBDB0000DB00FCFFFC00000000000000DBDBDBDBDBDB
        0000DBDB000000DBDBDBDBDBDBDBDB000000DBDB0000DBDBDBDBDBDBDBDBDBDB
        DBDBDBDB0000DBDB0000DBDBDBDBDBDBDBDBDB00DBDBDB00DB00DBDB0000DBDB
        DBDBDBDBDBDBDBDB000000DBDBDBDBDB0000DBDBDBDBDBDBDBDBDBDBDBDBDBDB
        DBDBDBDB0000}
      TabOrder = 3
      OnClick = btnProcuraPastaClick
    end
    object edDias: TEdit
      Left = 62
      Top = 19
      Width = 21
      Height = 21
      Enabled = False
      NumbersOnly = True
      TabOrder = 0
      Text = '1'
      OnChange = edDiasChange
    end
    object edHorario: TMaskEdit
      Left = 62
      Top = 44
      Width = 39
      Height = 21
      Enabled = False
      EditMask = '!90:00;1;_'
      MaxLength = 5
      TabOrder = 1
      Text = '  :  '
      OnChange = edDiasChange
      OnExit = edHorarioExit
    end
  end
  object cbBackupAutomatico: TCheckBox
    Left = 19
    Top = 3
    Width = 172
    Height = 17
    Caption = '&Fazer backup automaticamente'
    TabOrder = 0
    OnClick = cbBackupAutomaticoClick
  end
  object btnOK: TButton
    Left = 457
    Top = 195
    Width = 75
    Height = 25
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 4
  end
  object btnCancel: TButton
    Left = 539
    Top = 195
    Width = 75
    Height = 25
    Caption = '&Cancela'
    ModalResult = 2
    TabOrder = 5
  end
  object btnFazerAgora: TButton
    Left = 537
    Top = 107
    Width = 75
    Height = 73
    Caption = 'Fa&zer agora'
    TabOrder = 3
    OnClick = btnFazerAgoraClick
  end
  object GroupBox1: TGroupBox
    Left = 5
    Top = 107
    Width = 527
    Height = 73
    Caption = 'Ultimo Backup'
    TabOrder = 2
    object Label3: TLabel
      Left = 8
      Top = 23
      Width = 59
      Height = 13
      Caption = 'Data e hora:'
    end
    object Label4: TLabel
      Left = 21
      Top = 48
      Width = 46
      Height = 13
      Caption = 'Na pasta:'
    end
    object edPastaUltimoBackup: TEdit
      Left = 76
      Top = 44
      Width = 441
      Height = 21
      CharCase = ecLowerCase
      ParentColor = True
      ReadOnly = True
      TabOrder = 1
      Text = 'edpastaultimobackup'
    end
    object edDataUltimoBackup: TEdit
      Left = 76
      Top = 19
      Width = 165
      Height = 21
      ParentColor = True
      ReadOnly = True
      TabOrder = 0
      Text = 'eddataultimobackup'
    end
  end
  object Memo1: TMemo
    Left = 280
    Top = 184
    Width = 57
    Height = 33
    Lines.Strings = (
      'Memo1')
    TabOrder = 6
    Visible = False
  end
  object lbFolders: TListBox
    Left = 216
    Top = 184
    Width = 57
    Height = 33
    ItemHeight = 13
    Sorted = True
    TabOrder = 7
    Visible = False
  end
  object tmrBackup: TTimer
    Interval = 10000
    OnTimer = tmrBackupTimer
    Left = 344
    Top = 186
  end
  object dlgOpenFolder: TOpenDialog
    Left = 381
    Top = 21
  end
end
