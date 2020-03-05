unit View.Main;

interface

uses
  System.SysUtils, System.UITypes, System.Classes, FMX.Types, FMX.Controls, FMX.Forms, System.Rtti,
  FMX.Grid, FMX.ScrollBox, FMX.StdCtrls, FMX.Controls.Presentation, FMX.TabControl, Winapi.Windows,
  Helper.FMX, Data.DB, System.Actions, FMX.ActnList, DataSnap.DBClient, FMX.Layouts,
  FMX.ListBox, FMX.Edit, FMX.Memo, FMX.Menus, FMX.Dialogs,
  System.RegularExpressions, FMX.DialogService, FMX.Grid.Style, Types.Dialogs, Types.Utils, Types.XMLExporter;

type
  TMain = class sealed(TForm)
    ActionCheckAll: TAction;
    ActionCopyToClipboard: TAction;
    ActionCreateData: TAction;
    ActionExport: TAction;
    ActionImport: TAction;
    ActionList: TActionList;
    ActionUncheckAll: TAction;
    ButtonCopyToClipboard: TButton;
    ButtonCreateDataSet: TButton;
    ButtonExport: TButton;
    ButtonImport: TButton;
    ColumnFieldName: TStringColumn;
    ColumnFieldSize: TIntegerColumn;
    ColumnFieldType: TPopupColumn;
    EditConstant: TEdit;
    EditFilter: TEdit;
    GridData: TStringGrid;
    GridFields: TStringGrid;
    GroupBoxIssue: TGroupBox;
    GroupBoxShortcuts: TGroupBox;
    LabelDelete: TLabel;
    LabelGitHubLink: TLabel;
    LabelInsert: TLabel;
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
    TabItemMisc: TTabItem;
    TabItemXML: TTabItem;
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure ActionCreateDataExecute(Sender: TObject);
    procedure ActionExportExecute(Sender: TObject);
    procedure EditFilterChangeTracking(Sender: TObject);
    procedure ActionCheckAllExecute(Sender: TObject);
    procedure ActionUncheckAllExecute(Sender: TObject);
    procedure ActionCopyToClipboardExecute(Sender: TObject);
    procedure ActionImportExecute(Sender: TObject);
    procedure LabelGitHubLinkMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
    procedure LabelGitHubLinkMouseLeave(Sender: TObject);
    procedure LabelGitHubLinkClick(Sender: TObject);
  strict private
    FDataSet: TClientDataSet;
    function GetActiveGrid: TStringGrid;
    function GetFilter: string;
    procedure SetFilter(const Value: string);
    function GetConstant: string;
    procedure SetConstant(const Value: string);
    function GetXML: string;
    procedure SetXML(const Value: string);
    function GetFields: TArray<string>;
    procedure SetFields(const Value: TArray<string>);
  private
    procedure CreateDataSet;
    procedure Export;
    procedure Import;
    procedure CopyToClipboard;
    procedure AfterDefineFields;
    function TreatMessage(const Exception: Exception): string;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  public
    property Filter: string read GetFilter write SetFilter;
    property Constant: string read GetConstant write SetConstant;
    property XML: string read GetXML write SetXML;
    property Fields: TArray<string> read GetFields write SetFields;
    property ActiveGrid: TStringGrid read GetActiveGrid;
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
  if GridFields.IsEmpty then
    Exit;

  try
    CreateDataSet;
    AfterDefineFields;
  except
    on E: Exception do
    begin
      TDialogs.Warning(TreatMessage(E));
    end;
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
  FDataSet.LogChanges := False;
  GridData.FromDataSet(FDataSet);
  Fields := GridData.Headers;
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
  if FDataSet.Active then
    FDataSet.Close;

  FDataSet.FieldDefs.Clear;

  for Index := 0 to Pred(GridFields.RowCount) do
  begin
    FieldDef          := FDataSet.FieldDefs.AddFieldDef;
    FieldDef.DataType := TRttiEnumerationType.GetValue<TFieldType>(GridFields.Cells[ColumnFieldType.Index, Index]);
    FieldDef.Name     := GridFields.Cells[ColumnFieldName.Index, Index];
    FieldDef.Size     := StrToIntDef(GridFields.Cells[ColumnFieldSize.Index, Index], FieldDef.Size);
  end;

  FDataSet.CreateDataSet;
end;

procedure TMain.EditFilterChangeTracking(Sender: TObject);
begin
  ListBoxFields.FilterPredicate := TPredicate<string>(
    function(const AFilter: string): Boolean
    begin
      Result := Filter.IsEmpty or TRegEx.Create(Filter, [roIgnoreCase]).IsMatch(AFilter);
    end);
end;

procedure TMain.Export;
var
  Exporter: TXMLExporter;
begin
  Exporter := TXMLExporter.Create;
  try
    GridData.ToDataSet(FDataSet);

    XML := Exporter.AddConstant(Constant)
                   .AddFields(Fields)
                   .AddDataSet(FDataSet)
                   .ToString;
  finally
    Exporter.Free;
  end;
end;

procedure TMain.FormShow(Sender: TObject);
begin
  Caption := Format('%s [%s]', [Application.Title, TUtils.GetVersion]);
  GridFields.Empty(False);
  ColumnFieldType.Items.AddStrings(TUtils.GetFieldTypes);
  TabControlView.ActiveTab := TabItemFields;
end;

function TMain.GetActiveGrid: TStringGrid;
begin
  if TabControlView.ActiveTab = TabItemFields then
    Exit(GridFields);

  if TabControlView.ActiveTab = TabItemData then
    Exit(GridData);

  Result := nil;
end;

function TMain.GetConstant: string;
begin
  Result := EditConstant.Text.Trim;
end;

function TMain.GetFields: TArray<string>;
begin
  Result := ListBoxFields.CheckedItems;
end;

function TMain.GetFilter: string;
begin
  Result := EditFilter.Text.Trim;
end;

function TMain.GetXML: string;
begin
  Result := MemoXML.Lines.Text;
end;

procedure TMain.Import;
var
  FileName: string;
begin
  if TDialogs.OpenFile(['XML', 'DAT'], FileName) then
  begin
    FDataSet.LoadFromFile(FileName);
    AfterDefineFields;
  end;
end;

procedure TMain.LabelGitHubLinkClick(Sender: TObject);
begin
  TUtils.OpenURL((Sender as TLabel).Text);
end;

procedure TMain.LabelGitHubLinkMouseLeave(Sender: TObject);
begin
  (Sender as TLabel).SetStyle(TLabel.TLabelStyle.lsNone);
end;

procedure TMain.LabelGitHubLinkMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
begin
  (Sender as TLabel).SetStyle(TLabel.TLabelStyle.lsHyperLink);
end;

procedure TMain.SetConstant(const Value: string);
begin
  EditConstant.Text := Value.Trim;
end;

procedure TMain.SetFields(const Value: TArray<string>);
begin
  ListBoxFields.Items.Clear;
  ListBoxFields.Items.AddStrings(Value);
  ListBoxFields.CheckAll;
end;

procedure TMain.SetFilter(const Value: string);
begin
  EditFilter.Text := Value.Trim;
end;

procedure TMain.SetXML(const Value: string);
begin
  MemoXML.Lines.Clear;
  MemoXML.Lines.Text := Value;
end;

function TMain.TreatMessage(const Exception: Exception): string;
begin
  if not Assigned(Exception) then
    Exit('Undefined error.');

  if Exception is EDatabaseError then
  begin
    if Exception.Message.Equals('Invalid field type.') then
      Exit('You must define a type for each of the fields.');

    if Exception.Message.Equals('Invalid field size') then
      Exit('Only "ftString" needs to set size property, which must be positive.');

    if Exception.Message.Contains('Duplicate name') then
      Exit(Format('%s. The field name must be unique.', [Exception.Message]));
  end;

  if Exception is ENotImplemented  then
    Exit(Exception.Message + ' Open a issue in github.');

  Result := 'Unknown error. Open a issue in github.';
end;

procedure TMain.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  if ssCtrl in Shift then
  begin
    if not Assigned(ActiveGrid) then
      Exit;

    case Key of
      vkInsert: ActiveGrid.Append;
      vkDelete: ActiveGrid.Delete;
    end;
  end;
end;

end.

