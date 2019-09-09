unit Util.XMLExporter;

interface

uses
  Data.DB, Datasnap.DBClient, System.Classes, System.SysUtils, System.UITypes, XMLDoc, XMLIntf;

type
  TXMLExporter = class sealed
  private
    FDataSet: TClientDataSet;
    FFields: TArray<string>;
    FConstant: string;
    function FormatXML: string;
  public
    constructor Create;
    destructor Destroy; override;
    function AddFields(const Fields: TArray<string>): TXMLExporter;
    function AddConstant(const Constant: string): TXMLExporter;
    function AddDataSet(const DataSet: TClientDataSet): TXMLExporter;
    function ToString: string; override;
  end;

implementation

{ TXMLExporter }

function TXMLExporter.AddConstant(const Constant: string): TXMLExporter;
begin
  FConstant := Constant;
  Result := Self;
end;

function TXMLExporter.AddDataSet(const DataSet: TClientDataSet): TXMLExporter;
var
  Field: TFieldDef;
  FieldName: string;
begin
  Result := Self;

  if Length(FFields) = 0 then
    Exit;

  if Length(FFields) = DataSet.Fields.Count then
  begin
    FDataSet.Data := DataSet.Data;
    Exit;
  end;

  for FieldName in FFields do
  begin
    Field := DataSet.FieldDefs.Find(FieldName);
    FDataSet.FieldDefs.Add(Field.Name, Field.DataType, Field.Size, Field.Required);
  end;

  FDataSet.CreateDataSet;
  FDataSet.LogChanges := False;

  DataSet.First;
  while not DataSet.Eof do
  begin
    FDataSet.Append;
    for FieldName in FFields do
    begin
      FDataSet.FindField(FieldName).Assign(DataSet.FindField(FieldName));
    end;
    FDataSet.Post;

    DataSet.Next;
  end;
end;

function TXMLExporter.AddFields(const Fields: TArray<string>): TXMLExporter;
begin
  FFields := Fields;
  Result := Self;
end;

constructor TXMLExporter.Create;
begin
  FDataSet := TClientDataSet.Create(nil);
end;

destructor TXMLExporter.Destroy;
begin
  FDataSet.Free;
  inherited Destroy;
end;

function TXMLExporter.ToString: string;
begin
  Result := FormatXML;
end;

function TXMLExporter.FormatXML: string;
const
  Delimiter: array[Boolean] of string = ('+', ';');
  FirstLine = 0;
  Tab = Char(vkTab);
var
  Eof: Boolean;
  Line: Integer;
  Lines: TStringList;
begin
  Result := XmlDoc.FormatXMLData(FDataSet.XMLData);

  if FConstant.Trim.IsEmpty then
    Exit;

  Lines := TStringList.Create;
  try
    Lines.Text := Result;

    for Line := FirstLine to Pred(Lines.Count) do
    begin
      Eof := Line = Pred(Lines.Count);
      Lines.Strings[Line] := Tab + Lines.Strings[Line].QuotedString + Delimiter[Eof];
    end;

    Lines.Insert(FirstLine, FConstant + ' = ');

    Result := Lines.Text;
  finally
    Lines.Free;
  end;
end;

end.

