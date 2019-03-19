unit Form.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Datasnap.DBClient, Vcl.Grids, Vcl.DBGrids,
  Vcl.ExtCtrls, Vcl.ComCtrls, System.Actions, Vcl.ActnList, Vcl.StdCtrls, System.TypInfo;

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
    GridData: TDBGrid;
    DataSetData: TClientDataSet;
    DataSourceData: TDataSource;
    ButtonCreateDataSet: TButton;
    ButtonExportData: TButton;
    ActionExportData: TAction;
    ActionClear: TAction;
    ButtonClear: TButton;
    procedure FormShow(Sender: TObject);
    procedure ActionCreateDataSetExecute(Sender: TObject);
    procedure ActionExportDataExecute(Sender: TObject);
    procedure ActionClearExecute(Sender: TObject);
  private
    procedure Initialize;
    procedure PopulateDataSetFieldTypes;
    procedure CreateDataSet;
    procedure ExportData;
    procedure Clear;
  end;

implementation

{$R *.dfm}

procedure TMain.ActionClearExecute(Sender: TObject);
begin
  Clear;
end;

procedure TMain.ActionCreateDataSetExecute(Sender: TObject);
begin
  if DataSetFields.IsEmpty then
  begin
    ShowMessage('The fields in the dataset have not been defined.');
    Exit;
  end;

  CreateDataSet;
  TabSheetData.TabVisible := True;
  PageControl.ActivePage := TabSheetData;
end;

procedure TMain.ActionExportDataExecute(Sender: TObject);
begin
  if DataSetData.IsEmpty then
  begin
    ShowMessage('The data in the dataset has not been defined.');
    Exit;
  end;

  ExportData;
end;

procedure TMain.Clear;
begin
  DataSetFields.EmptyDataSet;

  if DataSetData.Active then
  begin
    DataSetData.EmptyDataSet;
    DataSetData.FieldDefs.Clear;
  end;
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

  DataSetData.CreateDataSet;
  GridData.Columns.RebuildColumns;
end;

procedure TMain.ExportData;
var
  Dialog: TSaveDialog;
begin
  Dialog := TSaveDialog.Create(Self);
  try
    Dialog.InitialDir := GetCurrentDir;
    Dialog.Filter := 'Data file|*.xml';
    Dialog.DefaultExt := 'xml';

    if Dialog.Execute then
      DataSetData.SaveToFile(Dialog.FileName, dfXML);
  finally
    Dialog.Free;
  end;
end;

procedure TMain.FormShow(Sender: TObject);
begin
  Initialize;
end;

procedure TMain.Initialize;
begin
  PopulateDataSetFieldTypes;
  PageControl.ActivePage := TabSheetFields;
  TabSheetData.TabVisible := False;
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
