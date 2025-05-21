object frmSicsCommom_PIShow: TfrmSicsCommom_PIShow
  Left = 352
  Top = 300
  Caption = 'Indicadores de Performance'
  ClientHeight = 178
  ClientWidth = 342
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object sgPIs: TStringGrid
    Left = 20
    Top = 10
    Width = 320
    Height = 120
    ColCount = 3
    DefaultDrawing = False
    FixedCols = 0
    TabOrder = 0
    OnDrawCell = sgPIsDrawCell
    ColWidths = (
      147
      68
      73)
    RowHeights = (
      24
      24
      24
      24
      24)
  end
  object btnFechar: TButton
    Left = 225
    Top = 145
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Fechar'
    TabOrder = 1
    OnClick = btnFecharClick
  end
  object PIsUpdateTimer: TTimer
    Interval = 30000
    OnTimer = PIsUpdateTimerTimer
    Left = 15
    Top = 145
  end
end
