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
    ActivePage = TabSheetFields
    Align = alClient
    TabOrder = 0
    ExplicitHeight = 477
    object TabSheetFields: TTabSheet
      Caption = 'Fields'
      ExplicitHeight = 449
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
      ExplicitHeight = 449
      object GridData: TDBGrid
        Left = 0
        Top = 0
        Width = 911
        Height = 442
        Align = alClient
        DataSource = DataSourceData
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
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
      ExplicitHeight = 45
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
      Left = 201
      Top = 1
      Width = 100
      Height = 46
      Action = ActionClear
      Align = alLeft
      TabOrder = 2
      ExplicitLeft = 218
      ExplicitTop = 10
      ExplicitHeight = 25
    end
  end
  object DataSourceFields: TDataSource
    DataSet = DataSetFields
    Left = 38
    Top = 52
  end
  object DataSetFields: TClientDataSet
    PersistDataPacket.Data = {
      4D0000009619E0BD0100000018000000030000000000030000004D00044E616D
      6501004900000001000557494454480200020050000453697A65040001000000
      0000045479706504000100000000000000}
    Active = True
    Aggregates = <>
    Params = <>
    Left = 110
    Top = 50
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
    Left = 470
    Top = 152
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
  end
  object DataSetFieldTypes: TClientDataSet
    PersistDataPacket.Data = {
      400000009619E0BD010000001800000002000000000003000000400004547970
      650400010000000000044E616D65010049000000010005574944544802000200
      50000000}
    Active = True
    Aggregates = <>
    Params = <>
    Left = 122
    Top = 120
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
    Left = 34
    Top = 120
  end
  object DataSetData: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 110
    Top = 174
  end
  object DataSourceData: TDataSource
    DataSet = DataSetData
    Left = 30
    Top = 176
  end
end
