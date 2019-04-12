unit Form.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Datasnap.DBClient, Vcl.Grids, Vcl.DBGrids,
  Vcl.ExtCtrls, Vcl.ComCtrls, System.Actions, Vcl.ActnList, Vcl.StdCtrls, System.TypInfo,
  XMLDoc, XMLIntf;

type
  TMain = class(TForm)
    PageControl: TPageControl;
    TabSheetFields: TTabSheet;
    PanelBottom: TPanel;
    GridFields: TDBGrid;
    DataSourceFields: TDataSource;
    DataSetFields: TClientDataSet;
    FieldName: TStringField;
    FieldSize: TIntegerField;
    ActionList: TActionList;
    DataSetFieldTypes: TClientDataSet;
    FielFieldTypesName: TStringField;
    FieldAAAAType: TIntegerField;
    DataSourceFieldTypes: TDataSource;
    ActionCreateDataSet: TAction;
    FieldDataSetFieldsType: TIntegerField;
    FieldDataSetFieldsTypeName: TStringField;
    TabSheetData: TTabSheet;
    DataSetData: TClientDataSet;
    DataSourceData: TDataSource;
    ButtonCreateDataSet: TButton;
    ButtonExportData: TButton;
    ActionExportData: TAction;
    ActionClear: TAction;
    ButtonClear: TButton;
    TabSheetXML: TTabSheet;
    ButtonCopyToClipboard: TButton;
    ActionCopyToClipboard: TAction;
    MemoXML: TMemo;
    Panel1: TPanel;
    GridData: TDBGrid;
    EditConstante: TLabeledEdit;
    procedure FormShow(Sender: TObject);
    procedure ActionCreateDataSetExecute(Sender: TObject);
    procedure ActionExportDataExecute(Sender: TObject);
    procedure ActionClearExecute(Sender: TObject);
    procedure ActionCopyToClipboardExecute(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
  private
    procedure Initialize;
    procedure PopulateDataSetFieldTypes;
    procedure CreateDataSet;
    procedure ExportData;
    procedure Clear;
    procedure ControlButtons;
    procedure ControlPages;
    procedure CopyToClipboard;
    procedure NextPage(const Proc: TProc);
    function FormatXML(const XML: string): string;
    procedure FormatXMLToDelphiStringPattern;
  end;

implementation

{$R *.dfm}

procedure TMain.ActionClearExecute(Sender: TObject);
begin
  Clear;
end;

procedure TMain.ActionCopyToClipboardExecute(Sender: TObject);
begin
  CopyToClipboard;
end;

procedure TMain.ActionCreateDataSetExecute(Sender: TObject);
begin
  if DataSetFields.IsEmpty then
  begin
    ShowMessage('The fields in the dataset have not been defined.');
    Exit;
  end;

  NextPage(CreateDataSet);
end;

procedure TMain.ActionExportDataExecute(Sender: TObject);
begin
  if DataSetData.IsEmpty then
  begin
    ShowMessage('The data in the dataset has not been defined.');
    Exit;
  end;

  NextPage(ExportData);
end;

procedure TMain.Clear;
begin
  DataSetFields.EmptyDataSet;

  if DataSetData.Active then
  begin
    DataSetData.EmptyDataSet;
    DataSetData.FieldDefs.Clear;
  end;

  MemoXML.Clear;
end;

procedure TMain.ControlButtons;
begin
  ButtonCreateDataSet.Visible   := PageControl.ActivePage = TabSheetFields;
  ButtonExportData.Visible      := PageControl.ActivePage = TabSheetData;
  ButtonCopyToClipboard.Visible := PageControl.ActivePage = TabSheetXML;
end;

procedure TMain.ControlPages;
begin
  PageControl.ActivePage := TabSheetFields;
  ControlButtons;
end;

procedure TMain.CopyToClipboard;
begin
  MemoXML.SelectAll;
  MemoXML.CopyToClipboard;
end;

procedure TMain.CreateDataSet;
begin
  DataSetData.FieldDefs.Clear;

  DataSetFields.First;
  while not DataSetFields.Eof do
  begin
    DataSetData.FieldDefs.Add(
      DataSetFields.FieldByName('Name').AsString,
      TFieldType(DataSetFields.FieldByName('Type').AsInteger),
      DataSetFields.FieldByName('Size').AsInteger);

    DataSetFields.Next;
  end;

  if DataSetData.Active then
    DataSetData.Close;
  DataSetData.CreateDataSet;
  DataSetData.LogChanges := False;

  GridData.Columns.RebuildColumns;
end;

procedure TMain.ExportData;
var
  Stream: TStringStream;
begin
  MemoXML.Clear;
  Stream := TStringStream.Create;
  try
    DataSetData.SaveToStream(Stream, dfXML);
    MemoXML.Lines.Add(FormatXML(Stream.DataString));
    FormatXMLToDelphiStringPattern;
  finally
    Stream.Free;
  end;
end;

procedure TMain.FormatXMLToDelphiStringPattern;
const
  Delimiter: array[Boolean] of string = ('+', ';');
  Tab = '  ';
var
  Constant: string;
  Index: Integer;
  Eof: Boolean;
begin
  Constant := EditConstante.Text;

  if Constant.Trim.IsEmpty then
    Exit;

  MemoXML.Lines.Delete(Pred(MemoXML.Lines.Count));
  for Index := 0 to Pred(MemoXML.Lines.Count) do
  begin
    Eof := Index = Pred(MemoXML.Lines.Count);
    MemoXML.Lines.Strings[Index] := Tab + QuotedStr(MemoXML.Lines.Strings[Index]) + Delimiter[Eof];
  end;

  MemoXML.Lines.Insert(0, Constant + ' = ');
end;

function TMain.FormatXML(const XML: string): string;
begin
  Result := XmlDoc.FormatXMLData(XML);
end;

procedure TMain.NextPage(const Proc: TProc);
var
  Index: Integer;
begin
  Proc;

  Index := PageControl.ActivePageIndex;
  if PageControl.ActivePageIndex < PageControl.PageCount then
    Inc(Index);

  PageControl.ActivePageIndex := Index;

  ControlButtons;
end;

procedure TMain.FormShow(Sender: TObject);
begin
  Initialize;
end;

procedure TMain.Initialize;
begin
  PopulateDataSetFieldTypes;
  ControlButtons;
  ControlPages;
end;

procedure TMain.PageControlChange(Sender: TObject);
begin
  ControlButtons;
end;

procedure TMain.PopulateDataSetFieldTypes;
var
  Index, Count: Integer;
begin
  Count := Ord(High(TFieldType));
  for Index := 0 to Pred(Count) do
  begin
    DataSetFieldTypes.InsertRecord([Index, GetEnumName(TypeInfo(TFieldType), Index)]);
  end;
end;

end.

