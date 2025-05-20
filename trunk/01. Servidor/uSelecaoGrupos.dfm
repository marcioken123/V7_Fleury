object FrmSelecaoGrupos: TFrmSelecaoGrupos
  Left = 534
  Top = 204
  BorderStyle = bsDialog
  Caption = 'Configura'#231#245'es Sics '
  ClientHeight = 328
  ClientWidth = 465
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  DesignSize = (
    465
    328)
  PixelsPerInch = 96
  TextHeight = 13
  object btnGravar: TBitBtn
    Left = 240
    Top = 288
    Width = 105
    Height = 35
    Anchors = [akRight, akBottom]
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    Kind = bkOK
    NumGlyphs = 2
    ParentFont = False
    TabOrder = 0
    OnClick = btnGravarClick
  end
  object btnCancelar: TBitBtn
    Left = 352
    Top = 287
    Width = 105
    Height = 35
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancelar'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
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
    ParentFont = False
    TabOrder = 1
    OnClick = btnCancelarClick
  end
  object ASPDbGrid: TASPDbGrid
    Left = 8
    Top = 16
    Width = 449
    Height = 259
    Anchors = [akLeft, akTop, akRight, akBottom]
    DataSource = dscGrupos
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Verdana'
    Font.Style = []
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
    ParentFont = False
    PopupMenu = PopupMenu
    TabOrder = 2
    TitleFont.Charset = ANSI_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -13
    TitleFont.Name = 'Verdana'
    TitleFont.Style = []
    OnCheckFieldClick = ASPDbGridCheckFieldClick
    Columns = <
      item
        Expanded = False
        FieldName = 'Selecionado'
        Title.Alignment = taCenter
        Width = 22
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ID'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'NOME'
        Visible = True
      end>
  end
  object PopupMenu: TPopupMenu
    Left = 32
    Top = 56
    object SelecionarTodos1: TMenuItem
      Caption = 'Selecionar Todos'
      OnClick = SelecionarTodos1Click
    end
    object DesmarcarTodos1: TMenuItem
      Caption = 'Desmarcar Todos'
      OnClick = DesmarcarTodos1Click
    end
    object InverterSeleo1: TMenuItem
      Caption = 'Inverter Sele'#231#227'o'
      OnClick = InverterSeleo1Click
    end
  end
  object qryGrupos: TFDQuery
    Left = 24
    Top = 112
  end
  object dspGrupos: TDataSetProvider
    DataSet = qryGrupos
    Left = 104
    Top = 112
  end
  object cdsGrupos: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    IndexFieldNames = 'ID'
    Params = <>
    ProviderName = 'dspGrupos'
    StoreDefs = True
    Left = 64
    Top = 112
    object cdsGruposSelecionado: TBooleanField
      Tag = 1
      Alignment = taCenter
      DisplayLabel = '#'
      DisplayWidth = 2
      FieldKind = fkInternalCalc
      FieldName = 'Selecionado'
    end
    object cdsGruposID: TIntegerField
      FieldName = 'ID'
      DisplayFormat = '00'
    end
    object cdsGruposNOME: TStringField
      DisplayLabel = 'Nome'
      FieldName = 'NOME'
      Size = 30
    end
  end
  object dscGrupos: TDataSource
    DataSet = cdsGrupos
    Left = 144
    Top = 112
  end
end
