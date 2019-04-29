object DataModuleDM: TDataModuleDM
  OldCreateOrder = False
  Height = 171
  Width = 327
  object DataSetTypes: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 35
    Top = 30
    object FieldTypeId: TIntegerField
      FieldName = 'Id'
    end
    object FieldTypeName: TStringField
      FieldName = 'Name'
      Size = 80
    end
  end
  object DataSourceTypes: TDataSource
    DataSet = DataSetTypes
    Left = 37
    Top = 90
  end
  object DataSetFields: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 134
    Top = 29
    object FieldFieldName: TStringField
      FieldName = 'Name'
      Size = 80
    end
    object FieldFieldTypeId: TIntegerField
      FieldName = 'TypeId'
      Visible = False
    end
    object FieldFieldTypeName: TStringField
      FieldKind = fkLookup
      FieldName = 'TypeName'
      LookupDataSet = DataSetTypes
      LookupKeyFields = 'Id'
      LookupResultField = 'Name'
      KeyFields = 'TypeId'
      Size = 80
      Lookup = True
    end
    object FieldFieldSize: TIntegerField
      FieldName = 'Size'
    end
  end
  object DataSourceFields: TDataSource
    DataSet = DataSetFields
    Left = 138
    Top = 92
  end
  object DataSourceData: TDataSource
    DataSet = DataSetData
    Left = 244
    Top = 89
  end
  object DataSetData: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 238
    Top = 31
  end
end
