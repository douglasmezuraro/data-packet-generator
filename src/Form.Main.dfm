object Main: TMain
  Left = 0
  Top = 0
  Caption = 'DataPacket Generator'
  ClientHeight = 600
  ClientWidth = 800
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 800
    Height = 552
    ActivePage = TabSheetData
    Align = alClient
    TabOrder = 0
    OnChange = PageControlChange
    ExplicitWidth = 919
    ExplicitHeight = 470
    object TabSheetFields: TTabSheet
      Caption = '1 - Fields'
      ExplicitWidth = 911
      ExplicitHeight = 442
      object GridFields: TDBGrid
        Left = 0
        Top = 0
        Width = 792
        Height = 524
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
      ExplicitWidth = 911
      ExplicitHeight = 442
      object PanelConstant: TPanel
        Left = 0
        Top = 0
        Width = 792
        Height = 49
        Align = alTop
        TabOrder = 0
        ExplicitWidth = 911
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
        Width = 697
        Height = 475
        Align = alLeft
        DataSource = DataModuleDM.DataSourceData
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
      end
      object CheckListBoxFields: TCheckListBox
        Left = 697
        Top = 49
        Width = 95
        Height = 475
        Align = alClient
        ItemHeight = 13
        TabOrder = 2
        ExplicitLeft = 768
        ExplicitTop = 128
        ExplicitWidth = 121
        ExplicitHeight = 97
      end
    end
    object TabSheetXML: TTabSheet
      Caption = '3 - XML'
      ExplicitWidth = 911
      ExplicitHeight = 442
      object MemoXML: TMemo
        Left = 0
        Top = 0
        Width = 792
        Height = 524
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        ExplicitTop = -1
        ExplicitWidth = 911
        ExplicitHeight = 442
      end
    end
  end
  object PanelBottom: TPanel
    Left = 0
    Top = 552
    Width = 800
    Height = 48
    Align = alBottom
    TabOrder = 1
    ExplicitTop = 470
    ExplicitWidth = 919
    object ButtonAction: TButton
      Left = 1
      Top = 1
      Width = 100
      Height = 46
      Align = alLeft
      Caption = 'Action'
      TabOrder = 0
      OnClick = ActionCreateDataSetExecute
    end
    object ButtonClear: TButton
      Left = 699
      Top = 1
      Width = 100
      Height = 46
      Action = ActionClear
      Align = alRight
      TabOrder = 1
      ExplicitLeft = 818
    end
    object ButtonImportData: TButton
      Left = 101
      Top = 1
      Width = 100
      Height = 46
      Action = ActionImportData
      Align = alLeft
      TabOrder = 2
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
    object ActionImportData: TAction
      Caption = '&Import Data'
      OnExecute = ActionImportDataExecute
    end
  end
end
