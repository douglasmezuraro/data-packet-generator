unit View.Main;

interface

uses
  System.SysUtils, System.UITypes, System.Classes, FMX.Types, FMX.Controls, FMX.Forms, System.Rtti,
  FMX.Grid, FMX.ScrollBox, FMX.StdCtrls, FMX.Controls.Presentation, FMX.TabControl, Winapi.Windows,
  Helper.FMX, Util.Methods, Data.DB, System.Actions, FMX.ActnList, DataSnap.DBClient, FMX.Layouts,
  FMX.ListBox, FMX.Edit, FMX.Memo, Util.XMLExporter, FMX.Menus, FMX.Grid.Style, FMX.Dialogs,
  System.RegularExpressions;

type
  TMain = class(TForm)
    ActionCheckAll: TAction;
    ActionCopyToClipboard: TAction;
    ActionCreateData: TAction;
    ActionExport: TAction;
    ActionList: TActionList;
    ActionUncheckAll: TAction;
    ButtonCopyToClipboard: TButton;
    ButtonCreateDataSet: TButton;
    ButtonExport: TButton;
    ColumnFieldName: TStringColumn;
    ColumnFieldSize: TIntegerColumn;
    ColumnFieldType: TPopupColumn;
    EditConstant: TEdit;
    EditFilter: TEdit;
    GridData: TStringGrid;
    GridFields: TStringGrid;
    ListBoxFields: TListBox;
    MemoXML: TMemo;
    MenuItemCheckAll: TMenuItem;
    MenuItemUncheckAll: TMenuItem;
    PanelButtonsTabData: TPanel;
    PanelButtonsTabFields: TPanel;
    PanelButtonsTabXML: TPanel;
    PanelFilterFields: TPanel;
    PanelGridData: TPanel;
    PopupMenu: TPopupMenu;
    TabControlView: TTabControl;
    TabItemData: TTabItem;
    TabItemFields: TTabItem;
    TabItemXML: TTabItem;
    ActionImport: TAction;
    ButtonImport: TButton;
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure ActionCreateDataExecute(Sender: TObject);
    procedure ActionExportExecute(Sender: TObject);
    procedure EditFilterChangeTracking(Sender: TObject);
    procedure ActionCheckAllExecute(Sender: TObject);
    procedure ActionUncheckAllExecute(Sender: TObject);
    procedure ActionCopyToClipboardExecute(Sender: TObject);
    procedure ActionImportExecute(Sender: TObject);
  private
    FDataSet: TClientDataSet;
    procedure CreateDataSet;
    procedure Export;
    procedure Import;
    procedure CopyToClipboard;
    procedure AfterDefineFields;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.fmx}

constructor TMain.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDataSet := TClientDataSet.Create(nil);
end;

destructor TMain.Destroy;
begin
  FDataSet.Free;
  inherited Destroy;
end;

procedure TMain.ActionCheckAllExecute(Sender: TObject);
begin
  ListBoxFields.CheckAll;
end;

procedure TMain.ActionCopyToClipboardExecute(Sender: TObject);
begin
  CopyToClipboard;
end;

procedure TMain.ActionCreateDataExecute(Sender: TObject);
begin
  if not GridFields.IsEmpty then
  begin
    CreateDataSet;
    AfterDefineFields;
  end;
end;

procedure TMain.ActionExportExecute(Sender: TObject);
begin
  Export;
  TabControlView.Next;
end;

procedure TMain.ActionImportExecute(Sender: TObject);
begin
  Import;
end;

procedure TMain.ActionUncheckAllExecute(Sender: TObject);
begin
  ListBoxFields.UncheckAll;
end;

procedure TMain.AfterDefineFields;
begin
  GridData.FromDataSet(FDataSet);
  ListBoxFields.Items.AddStrings(GridData.Headers);
  ListBoxFields.CheckAll;
  TabControlView.Next;
end;

procedure TMain.CopyToClipboard;
begin
  MemoXML.SelectAll;
  MemoXML.CopyToClipboard;
end;

procedure TMain.CreateDataSet;
var
  Index: Integer;
  FieldDef: TFieldDef;
begin
  FDataSet.FieldDefs.Clear;

  for Index := 0 to Pred(GridFields.RowCount) do
  begin
    FieldDef          := FDataSet.FieldDefs.AddFieldDef;
    FieldDef.DataType := TRttiEnumerationType.GetValue<TFieldType>(GridFields.Cells[ColumnFieldType.Index, Index]);
    FieldDef.Name     := GridFields.Cells[ColumnFieldName.Index, Index];
    FieldDef.Size     := StrToIntDef(GridFields.Cells[ColumnFieldSize.Index, Index], FieldDef.Size);
  end;

  FDataSet.CreateDataSet;
  FDataSet.LogChanges := False;
end;

procedure TMain.EditFilterChangeTracking(Sender: TObject);
var
  Text: string;
  RegEx: TRegEx;
begin
  Text := (Sender as TEdit).Text.Trim;

  if Text.IsEmpty then
    Exit;

  RegEx := TRegEx.Create(Text, [roIgnoreCase]);
  ListBoxFields.FilterPredicate := TPredicate<string>(
    function(const Filter: string): Boolean
    begin
      Result := RegEx.IsMatch(Filter)
    end);
end;

procedure TMain.Export;
var
  Exporter: TXMLExporter;
begin
  Exporter := TXMLExporter.Create;
  try
    GridData.ToDataSet(FDataSet);
    Exporter.Constant := EditConstant.Text;
    Exporter.Fields := ListBoxFields.CheckedItems;
    Exporter.DataSet := FDataSet;

    MemoXML.Lines.Text := Exporter.Export;
  finally
    Exporter.Free;
  end;
end;

procedure TMain.FormShow(Sender: TObject);
begin
  GridFields.Initialize;
  ColumnFieldType.Items.AddStrings(TMethods.GetFieldTypes);
  TabControlView.ActiveTab := TabItemFields;
end;

procedure TMain.Import;
var
  Dialog: TOpenDialog;
begin
  Dialog := TOpenDialog.Create(Self);
  try
    Dialog.Options := [TOpenOption.ofFileMustExist, TOpenOption.ofHideReadOnly];
    Dialog.Filter := 'DAT File|*.dat|XML File|*.XML';

    if Dialog.Execute then
    begin
      FDataSet.LoadFromFile(Dialog.FileName);
      AfterDefineFields;
    end;
  finally
    Dialog.Free;
  end;
end;

procedure TMain.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);

  function GetGrid: TStringGrid;
  begin
    if TabControlView.ActiveTab = TabItemFields then
      Exit(GridFields);

    if TabControlView.ActiveTab = TabItemData then
      Exit(GridData);

    Result := nil;
  end;

var
  Grid: TStringGrid;
begin
  if ssCtrl in Shift then
  begin
    Grid := GetGrid;

    if not Assigned(Grid) then
      Exit;

    case Key of
      vkInsert:
        begin
          Grid.Append;
        end;
      vkDelete:
        begin
          Grid.Delete;
        end;
    end;
  end;
end;

end.

