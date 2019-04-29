unit Form.DataModule;

interface

uses
  Datasnap.DBClient,
  Data.DB,
  System.Classes,
  System.TypInfo;

type
  TDataModuleDM = class(TDataModule)
    DataSetTypes: TClientDataSet;
    FieldTypeId: TIntegerField;
    FieldTypeName: TStringField;
    DataSourceTypes: TDataSource;
    DataSetFields: TClientDataSet;
    FieldFieldName: TStringField;
    FieldFieldTypeId: TIntegerField;
    FieldFieldTypeName: TStringField;
    FieldFieldSize: TIntegerField;
    DataSourceFields: TDataSource;
    DataSourceData: TDataSource;
    DataSetData: TClientDataSet;
  private
    procedure PopulateTypes;
    function GetData: TClientDataSet;
    function GetFields: TClientDataSet;
  public
    constructor Create(Owner: TComponent); override;
    procedure Clear;
    procedure CreateData;
    property Data: TClientDataSet read GetData;
    property Fields: TClientDataSet read GetFields;
  end;

var
  DataModuleDM: TDataModuleDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDataModule1 }

function TDataModuleDM.GetData: TClientDataSet;
begin
  Result := DataSetData;
end;

function TDataModuleDM.GetFields: TClientDataSet;
begin
  Result := DataSetFields;
end;

procedure TDataModuleDM.Clear;
begin
  Fields.EmptyDataSet;
  if Data.Active then
  begin
    Data.EmptyDataSet;
    Data.FieldDefs.Clear;
  end;
end;

constructor TDataModuleDM.Create(Owner: TComponent);
begin
  inherited;
  DataSetTypes.CreateDataSet;
  DataSetFields.CreateDataSet;

  PopulateTypes;

  Fields.Open;
end;

procedure TDataModuleDM.CreateData;
begin
  Data.FieldDefs.Clear;

  Fields.First;
  while not Fields.Eof do
  begin
    Data.FieldDefs.Add(
      Fields.FieldByName('Name').AsString,
      TFieldType(Fields.FieldByName('TypeId').AsInteger),
      Fields.FieldByName('Size').AsInteger);

    Fields.Next;
  end;

  if Data.Active then
    Data.Close;

  Data.CreateDataSet;
  Data.LogChanges := False;
end;

procedure TDataModuleDM.PopulateTypes;
var
  Index, Count: Integer;
begin
  Count := Ord(High(TFieldType));
  for Index := 0 to Pred(Count) do
  begin
    DataSetTypes.InsertRecord([Index, GetEnumName(TypeInfo(TFieldType), Index)]);
  end;
end;

end.

