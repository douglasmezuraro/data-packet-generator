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
    ActivePage = TabSheetXML
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
        Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
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
        ExplicitTop = -6
        object EditConstant: TLabeledEdit
          Left = 8
          Top = 22
          Width = 772
          Height = 21
          EditLabel.Width = 73
          EditLabel.Height = 13
          EditLabel.Caption = 'Constant name'
          EditLabel.Layout = tlCenter
          TabOrder = 0
        end
      end
      object GridData: TDBGrid
        Left = 0
        Top = 49
        Width = 633
        Height = 475
        Align = alLeft
        DataSource = DataModuleDM.DataSourceData
        Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
      end
      object CheckListBoxFields: TCheckListBox
        Left = 633
        Top = 49
        Width = 159
        Height = 475
        Align = alClient
        ItemHeight = 13
        PopupMenu = PopupMenuFields
        TabOrder = 2
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
      TabOrder = 2
      ExplicitLeft = 818
    end
    object ButtonImportData: TButton
      Left = 101
      Top = 1
      Width = 100
      Height = 46
      Action = ActionImportData
      Align = alLeft
      TabOrder = 1
    end
  end
  object ActionList: TActionList
    Left = 134
    Top = 112
    object ActionCreateDataSet: TAction
      Category = 'Button'
      Caption = 'Create &DataSet'
      OnExecute = ActionCreateDataSetExecute
    end
    object ActionExportData: TAction
      Category = 'Button'
      Caption = '&Export data'
      OnExecute = ActionExportDataExecute
    end
    object ActionClear: TAction
      Category = 'Button'
      Caption = '&Clear'
      OnExecute = ActionClearExecute
    end
    object ActionCopyToClipboard: TAction
      Category = 'Button'
      Caption = 'Co&py to clipboard'
      OnExecute = ActionCopyToClipboardExecute
    end
    object ActionImportData: TAction
      Category = 'Button'
      Caption = '&Import Data'
      OnExecute = ActionImportDataExecute
    end
    object ActionCheckAll: TAction
      Category = 'Popup'
      Caption = '&Selecionar todos'
      OnExecute = ActionCheckAllExecute
    end
    object ActionUncheckAll: TAction
      Category = 'Popup'
      Caption = '&Deselecionar todos'
      OnExecute = ActionUncheckAllExecute
    end
  end
  object PopupMenuFields: TPopupMenu
    Left = 49
    Top = 112
    object MenuItemCheckAll: TMenuItem
      Action = ActionCheckAll
    end
    object MenuItemUncheckAll: TMenuItem
      Action = ActionUncheckAll
    end
  end
end
