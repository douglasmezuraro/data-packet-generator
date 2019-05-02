unit XML.Exporter;

interface

uses
  Data.DB,
  Datasnap.DBClient,
  System.Classes,
  System.SysUtils,
  XMLDoc,
  XMLIntf;

type
  TXMLExporter = class
  private
    FDataSet: TClientDataSet;
    FFields: TArray<string>;
    FConstant: string;
    function FormatXML: string;
    procedure SetDataSet(const Value: TClientDataSet);
  public
    constructor Create;
    destructor Destroy; override;
    function Export: string; overload;
    property DataSet: TClientDataSet read FDataSet write SetDataSet;
    property Constant: string read FConstant write FConstant;
    property Fields: TArray<string> read FFields write FFields;
  end;

implementation

{ TXMLExporter }

constructor TXMLExporter.Create;
begin
  FDataSet := TClientDataSet.Create(nil);
end;

destructor TXMLExporter.Destroy;
begin
  FDataSet.Free;
  inherited Destroy;
end;

function TXMLExporter.FormatXML: string;
const
  Delimiter: array[Boolean] of string = ('+', ';');
  Tab = #9;
var
  Lines: TStringList;
  Index: Integer;
  Eof: Boolean;
begin
  Result := XmlDoc.FormatXMLData(FDataSet.XMLData);

  if Constant.Trim.IsEmpty then
    Exit;

  Lines := TStringList.Create;
  try
    Lines.Text := Result;

    for Index := 0 to Pred(Lines.Count) do
    begin
      Eof := Index = Pred(Lines.Count);
      Lines.Strings[Index] := Tab + Lines.Strings[Index].QuotedString + Delimiter[Eof];
    end;

    Lines.Insert(0, Constant + ' =');

    Result := Lines.Text;
  finally
    Lines.Free;
  end;
end;

procedure TXMLExporter.SetDataSet(const Value: TClientDataSet);
var
  Field: TFieldDef;
  Name: string;
begin
  if Length(Fields) = 0 then
    Exit;

  if Length(Fields) = Value.Fields.Count then
  begin
    FDataSet.Data := Value.Data;
    Exit;
  end;

  for Name in FFields do
  begin
    Field := Value.FieldDefs.Find(Name);
    FDataSet.FieldDefs.Add(Field.Name, Field.DataType, Field.Size, Field.Required);
  end;

  FDataSet.CreateDataSet;
  FDataSet.LogChanges := False;

  Value.First;
  while not Value.Eof do
  begin
    FDataSet.Append;
    for Name in FFields do
    begin
      FDataSet.FindField(Name).Assign(Value.FindField(Name));
    end;
    FDataSet.Post;

    Value.Next;
  end;
end;

function TXMLExporter.Export: string;
begin
  Result := FormatXML;
end;

end.
