inherited FrmConfiguracoesSicsCallCenter: TFrmConfiguracoesSicsCallCenter
  Caption = 'Configura'#231#245'es Sics Call Center'
  ClientHeight = 568
  ClientWidth = 942
  ExplicitWidth = 958
  ExplicitHeight = 607
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlFundo: TPanel
    Width = 942
    Height = 568
    ExplicitWidth = 942
    ExplicitHeight = 568
    inherited grpConfiguracoes: TGroupBox
      Width = 737
      Height = 514
      ExplicitWidth = 737
      ExplicitHeight = 514
      object lblID_PA: TLabel [0]
        Left = 11
        Top = 18
        Width = 96
        Height = 13
        Caption = 'N'#250'mero da Mesa'
      end
      inherited grpConfigTela: TGroupBox
        Left = 536
        Height = 483
        TabOrder = 2
        Visible = False
        ExplicitLeft = 536
        ExplicitHeight = 483
      end
      inherited grpOutrasConfig: TGroupBox
        Left = 341
        Top = 398
        Width = 193
        Height = 108
        Anchors = [akRight, akBottom]
        Visible = False
        ExplicitLeft = 341
        ExplicitTop = 398
        ExplicitWidth = 193
        ExplicitHeight = 108
      end
      object edtID_Mesa: TDBEdit
        Left = 11
        Top = 34
        Width = 134
        Height = 21
        DataField = 'NUMERO_MESA'
        DataSource = dtsConfig
        TabOrder = 0
      end
      object chkModoTerminalServer: TDBCheckBox
        Left = 11
        Top = 61
        Width = 278
        Height = 17
        Caption = 'Login Autom'#225'tico pelo usu'#225'rio do Windows'
        DataField = 'LOGIN_WINDOWS'
        DataSource = dtsConfig
        TabOrder = 3
        ValueChecked = 'T'
        ValueUnchecked = 'F'
      end
    end
    inherited pnlButtonSicsPA: TPanel
      Top = 516
      Width = 938
      ExplicitTop = 516
      ExplicitWidth = 938
      DesignSize = (
        938
        50)
      inherited btnSair: TBitBtn
        Left = 823
        ExplicitLeft = 823
      end
      inherited btnSalvar: TBitBtn
        Left = 713
        ExplicitLeft = 713
      end
    end
    inherited grpModulos: TGroupBox
      Height = 514
      ExplicitHeight = 514
      inherited btnSicsIncluir: TBitBtn
        Top = 387
        ExplicitTop = 387
      end
      inherited btnSicsExcluir: TBitBtn
        Top = 387
        ExplicitTop = 387
      end
      inherited btnCopiar: TBitBtn
        Top = 387
        ExplicitTop = 387
      end
      inherited grpGrid: TGroupBox
        Height = 359
        ExplicitHeight = 359
        inherited grdModulos: TDBGrid
          Height = 272
        end
        inherited pnlNovaConfig: TPanel
          Top = 287
          ExplicitTop = 287
        end
      end
    end
  end
  object qryNomePA: TFDQuery
    Connection = dmSicsMain.connOnLine
    SQL.Strings = (
      'SELECT ID, NOME FROM PAS WHERE ATIVO = '#39'T'#39)
    Left = 16
    Top = 424
  end
  object cdsNomePA: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspNomePA'
    Left = 80
    Top = 424
    object cdsNomePAID: TIntegerField
      FieldName = 'ID'
      Required = True
    end
    object cdsNomePANOME: TStringField
      FieldName = 'NOME'
      Size = 30
    end
  end
  object dspNomePA: TDataSetProvider
    DataSet = qryNomePA
    Left = 144
    Top = 424
  end
  object dscNomePA: TDataSource
    DataSet = cdsNomePA
    Left = 176
    Top = 424
  end
end
