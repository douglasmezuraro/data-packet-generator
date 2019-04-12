object Main: TMain
  Left = 0
  Top = 0
  Caption = 'Main'
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
    ActivePage = TabSheetData
    Align = alClient
    TabOrder = 0
    OnChange = PageControlChange
    object TabSheetFields: TTabSheet
      Caption = 'Fields'
      object GridFields: TDBGrid
        Left = 0
        Top = 0
        Width = 911
        Height = 442
        Align = alClient
        DataSource = DataSourceFields
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
      Caption = 'Data'
      ExplicitLeft = 7
      ExplicitTop = 23
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 911
        Height = 49
        Align = alTop
        TabOrder = 0
        object EditConstante: TLabeledEdit
          Left = 14
          Top = 20
          Width = 283
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
        DataSource = DataSourceData
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
      end
    end
    object TabSheetXML: TTabSheet
      Caption = 'XML'
      ExplicitTop = 23
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
        ExplicitLeft = 36
        ExplicitTop = 146
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
    object ButtonCreateDataSet: TButton
      Left = 1
      Top = 1
      Width = 100
      Height = 46
      Action = ActionCreateDataSet
      Align = alLeft
      Caption = 'Create &DataSet'
      TabOrder = 0
    end
    object ButtonExportData: TButton
      Left = 101
      Top = 1
      Width = 100
      Height = 46
      Action = ActionExportData
      Align = alLeft
      TabOrder = 1
    end
    object ButtonClear: TButton
      Left = 818
      Top = 1
      Width = 100
      Height = 46
      Action = ActionClear
      Align = alRight
      TabOrder = 2
    end
    object ButtonCopyToClipboard: TButton
      Left = 201
      Top = 1
      Width = 100
      Height = 46
      Action = ActionCopyToClipboard
      Align = alLeft
      TabOrder = 3
    end
  end
  object DataSourceFields: TDataSource
    DataSet = DataSetFields
    Left = 536
    Top = 160
  end
  object DataSetFields: TClientDataSet
    PersistDataPacket.Data = {
      4D0000009619E0BD0100000018000000030000000000030000004D00044E616D
      6501004900000001000557494454480200020050000453697A65040001000000
      0000045479706504000100000000000000}
    Active = True
    Aggregates = <>
    Params = <>
    Left = 409
    Top = 205
    object FieldName: TStringField
      FieldName = 'Name'
      Size = 80
    end
    object FieldDataSetFieldsType: TIntegerField
      FieldName = 'Type'
      Visible = False
    end
    object FieldDataSetFieldsTypeName: TStringField
      FieldKind = fkLookup
      FieldName = 'TypeName'
      LookupDataSet = DataSetFieldTypes
      LookupKeyFields = 'Type'
      LookupResultField = 'Name'
      KeyFields = 'Type'
      Size = 80
      Lookup = True
    end
    object FieldSize: TIntegerField
      FieldName = 'Size'
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
  end
  object DataSetFieldTypes: TClientDataSet
    PersistDataPacket.Data = {
      400000009619E0BD010000001800000002000000000003000000400004547970
      650400010000000000044E616D65010049000000010005574944544802000200
      50000000}
    Active = True
    Aggregates = <>
    Params = <>
    Left = 431
    Top = 124
    object FieldAAAAType: TIntegerField
      FieldName = 'Type'
    end
    object FielFieldTypesName: TStringField
      FieldName = 'Name'
      Size = 80
    end
  end
  object DataSourceFieldTypes: TDataSource
    DataSet = DataSetFieldTypes
    Left = 411
    Top = 284
  end
  object DataSetData: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 592
    Top = 115
  end
  object DataSourceData: TDataSource
    DataSet = DataSetData
    Left = 524
    Top = 245
  end
end
