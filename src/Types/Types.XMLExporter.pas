unit Types.XMLExporter;

interface

uses
  Data.DB,
  Datasnap.DBClient,
  Helper.ClientDataSet,
  System.Classes,
  System.SysUtils,
  System.UITypes,
  XMLDoc,
  XMLIntf;

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

function TXMLExporter.AddConstant(const Constant: string): TXMLExporter;
begin
  FConstant := Constant;
  Result := Self;
end;

function TXMLExporter.AddDataSet(const DataSet: TClientDataSet): TXMLExporter;
var
  Field: string;
begin
  Result := Self;

  if FFields = nil then
    Exit;

  if Length(FFields) = DataSet.Fields.Count then
  begin
    FDataSet.Data := DataSet.Data;
    Exit;
  end;

  for Field in FFields do
  begin
    FDataSet.FieldDefs.AddFieldDef.Assign(DataSet.FieldDefs.Find(Field));
  end;

  FDataSet.CreateDataSet;
  FDataSet.LogChanges := False;

  DataSet.ForEach(
    procedure
    var
      Field: string;
    begin
      FDataSet.Append;
      for Field in FFields do
      begin
        FDataSet.FindField(Field).Assign(DataSet.FindField(Field));
      end;
      FDataSet.Post;
    end);
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

