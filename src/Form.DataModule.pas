unit Form.DataModule;

interface

uses
  Datasnap.DBClient,
  Data.DB,
  System.Classes,
  System.SysUtils,
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
    function Validate(out Message: string): Boolean;
    property Data: TClientDataSet read GetData;
    property Fields: TClientDataSet read GetFields;
  end;

var
  DataModuleDM: TDataModuleDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDataModuleDM }

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

function TDataModuleDM.Validate(out Message: string): Boolean;
const
  StringType = [ftString, ftWideString, ftFixedChar, ftFixedWideChar];
begin
  Result := False;

  if Fields.IsEmpty then
  begin
    Message := 'Não existem definições de campos.';
    Exit;
  end;

  Fields.First;
  while not Fields.Eof do
  begin
    if Fields['Name'] = string.Empty then
    begin
      Message := Format('O campo de indíce %d está com o nome vazio.', [Fields.RecNo]);
      Exit;
    end;

    if Fields.FieldByName('Size').IsNull then
    begin
      if TFieldType(Fields['TypeId']) in StringType then
      begin
        begin
          Message := Format('O campo "%s" esta com a propriedade "Size" indefinida.', [DataModuleDM.Fields['Name']]);
          Exit;
        end;
      end;
    end;

    if not Fields.FieldByName('Size').IsNull then
    begin
      if not (TFieldType(Fields['TypeId']) in StringType) then
      begin
        begin
          Message := Format('O campo "%s" esta com a propriedade "Size" definida desnecessariamente.', [DataModuleDM.Fields['Name']]);
          Exit;
        end;
      end;
    end;

    Fields.Next;
  end;

  Result := True;
end;


end.

