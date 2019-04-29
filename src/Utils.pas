unit Utils;

interface

uses
  Datasnap.DBClient,
  System.Classes,
  System.SysUtils,
  XMLDoc,
  XMLIntf;

type
  TUtils = class
  private
    class function GetXML(const DataSet: TClientDataSet): string; overload;
    class function FormatXML(const XML: string; const Constant: string): string;
  public
    class function GetXML(const DataSet: TClientDataSet; const Constant: string): string; overload;
  end;

implementation

{ TUtils }

class function TUtils.FormatXML(const XML, Constant: string): string;
const
  Delimiter: array[Boolean] of string = ('+', ';');
  Tab = #9;
var
  StringList: TStringList;
  Index: Integer;
  Eof: Boolean;
begin
  Result := XmlDoc.FormatXMLData(XML);

  if Constant.Trim.IsEmpty then
    Exit;

  StringList := TStringList.Create;
  try
    StringList.Text := Result;

    for Index := 0 to Pred(StringList.Count) do
    begin
      Eof := Index = Pred(StringList.Count);
      StringList.Strings[Index] := Tab + QuotedStr(StringList.Strings[Index]) + Delimiter[Eof];
    end;

    StringList.Insert(0, Constant + ' =');

    Result := StringList.Text;
  finally
    StringList.Free;
  end;
end;

class function TUtils.GetXML(const DataSet: TClientDataSet): string;
var
  Stream: TStringStream;
begin
  Result := string.Empty;

  if not Assigned(DataSet) then
    Exit;

  Stream := TStringStream.Create;
  try
    DataSet.SaveToStream(Stream, dfXML);
    Result := Stream.DataString;
  finally
    Stream.Free;
  end;
end;

class function TUtils.GetXML(const DataSet: TClientDataSet; const Constant: string): string;
var
  XML: string;
begin
  XML := GetXML(DataSet);
  XML := FormatXML(XML, Constant);

  Result := XML;
end;

end.
