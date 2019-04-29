object Main: TMain
  Left = 0
  Top = 0
  Caption = 'DataPacket Generator'
  ClientHeight = 518
  ClientWidth = 919
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  WindowState = wsMaximized
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 919
    Height = 470
    ActivePage = TabSheetXML
    Align = alClient
    TabOrder = 0
    OnChange = PageControlChange
    object TabSheetFields: TTabSheet
      Caption = '1 - Fields'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GridFields: TDBGrid
        Left = 0
        Top = 0
        Width = 911
        Height = 442
        Align = alClient
        DataSource = DataModuleDM.DataSourceFields
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'Name'
            Title.Caption = 'FieldName'
            Width = 457
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Type'
            Title.Caption = 'FieldType'
            Visible = False
          end
          item
            Expanded = False
            FieldName = 'TypeName'
            Width = 186
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Size'
            Visible = True
          end>
      end
    end
    object TabSheetData: TTabSheet
      Caption = '2 - Data'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object PanelConstant: TPanel
        Left = 0
        Top = 0
        Width = 911
        Height = 49
        Align = alTop
        TabOrder = 0
        object EditConstant: TLabeledEdit
          Left = 14
          Top = 20
          Width = 727
          Height = 21
          EditLabel.Width = 93
          EditLabel.Height = 13
          EditLabel.Caption = 'Nome da constante'
          EditLabel.Layout = tlCenter
          TabOrder = 0
        end
      end
      object GridData: TDBGrid
        Left = 0
        Top = 49
        Width = 911
        Height = 393
        Align = alClient
        DataSource = DataModuleDM.DataSourceData
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
      end
    end
    object TabSheetXML: TTabSheet
      Caption = '3 - XML'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object MemoXML: TMemo
        Left = 0
        Top = 0
        Width = 911
        Height = 442
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
    end
  end
  object PanelBottom: TPanel
    Left = 0
    Top = 470
    Width = 919
    Height = 48
    Align = alBottom
    TabOrder = 1
    object ButtonAction: TButton
      Left = 1
      Top = 1
      Width = 100
      Height = 46
      Align = alLeft
      Caption = 'Action'
      TabOrder = 0
      OnClick = ActionCreateDataSetExecute
      ExplicitLeft = 0
      ExplicitTop = 2
    end
    object ButtonClear: TButton
      Left = 818
      Top = 1
      Width = 100
      Height = 46
      Action = ActionClear
      Align = alRight
      TabOrder = 1
    end
  end
  object ActionList: TActionList
    Left = 334
    Top = 128
    object ActionCreateDataSet: TAction
      Caption = '&Create DataSet'
      OnExecute = ActionCreateDataSetExecute
    end
    object ActionExportData: TAction
      Caption = '&Export data'
      OnExecute = ActionExportDataExecute
    end
    object ActionClear: TAction
      Caption = '&Clear'
      OnExecute = ActionClearExecute
    end
    object ActionCopyToClipboard: TAction
      Caption = 'Co&py to clipboard'
      OnExecute = ActionCopyToClipboardExecute
    end
    object Action1: TAction
      Caption = 'Action1'
    end
  end
end
