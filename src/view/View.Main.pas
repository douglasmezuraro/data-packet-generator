unit View.Main;

interface

uses
  System.SysUtils, System.UITypes, System.Classes, FMX.Types, FMX.Controls, FMX.Forms, System.Rtti,
  FMX.Grid, FMX.ScrollBox, FMX.StdCtrls, FMX.Controls.Presentation, FMX.TabControl, Winapi.Windows,
  Helper.FMX, Util.Methods, Data.DB, System.Actions, FMX.ActnList, DataSnap.DBClient, FMX.Layouts,
  FMX.ListBox, FMX.Edit, FMX.Memo, Util.XMLExporter, FMX.Menus, FMX.Dialogs,
  System.RegularExpressions, FMX.DialogService, Winapi.UrlMon, FMX.Grid.Style;

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
  private
    FDataSet: TClientDataSet;
    procedure CreateDataSet;
    procedure Export;
    procedure Import;
    procedure CopyToClipboard;
    procedure AfterDefineFields;
    function TreatMessage(const Exception: EDatabaseError): string;
    function GetActiveGrid: TStringGrid;
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
    try
      CreateDataSet;
      AfterDefineFields;
    except
      on Exception: EDatabaseError do
      begin
        TDialogService.MessageDialog(TreatMessage(Exception), TMsgDlgType.mtWarning, [TMsgDlgBtn.mbOK], TMsgDlgBtn.mbOK, -1, nil);
      end;

      on Exception: ENotImplemented do
      begin
        TDialogService.MessageDialog(Exception.Message + ' Open a issue in github.', TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], TMsgDlgBtn.mbOK, -1, nil);
      end;

      on Exception: Exception do
      begin
        TDialogService.MessageDialog('Unknown error. Open a issue in github.', TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], TMsgDlgBtn.mbOK, -1, nil);
      end;
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
  GridData.FromDataSet(FDataSet);
  ListBoxFields.Items.Clear;
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
  FDataSet.LogChanges := False;
end;

procedure TMain.EditFilterChangeTracking(Sender: TObject);
var
  Text: string;
  RegEx: TRegEx;
begin
  Text := (Sender as TEdit).Text.Trim;

  RegEx := TRegEx.Create(Text, [roIgnoreCase]);
  ListBoxFields.FilterPredicate := TPredicate<string>(
    function(const Filter: string): Boolean
    begin
      Result := Text.IsEmpty or RegEx.IsMatch(Filter);
    end);
end;

procedure TMain.Export;
var
  Exporter: TXMLExporter;
begin
  Exporter := TXMLExporter.Create;
  try
    GridData.ToDataSet(FDataSet);

    MemoXML.Lines.Text := Exporter.AddConstant(EditConstant.Text)
                                  .AddFields(ListBoxFields.CheckedItems)
                                  .AddDataSet(FDataSet)
                                  .ToString;
  finally
    Exporter.Free;
  end;
end;

procedure TMain.FormShow(Sender: TObject);
begin
  GridFields.Empty(False);
  ColumnFieldType.Items.AddStrings(TMethods.GetFieldTypes);
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

procedure TMain.LabelGitHubLinkClick(Sender: TObject);
begin
  HlinkNavigateString(nil, PWideChar((Sender as TLabel).Text));
end;

procedure TMain.LabelGitHubLinkMouseLeave(Sender: TObject);
begin
  (Sender as TLabel).SetStyle(TLabel.TLabelStyle.lsNone);
end;

procedure TMain.LabelGitHubLinkMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
begin
  (Sender as TLabel).SetStyle(TLabel.TLabelStyle.lsHyperLink);
end;

function TMain.TreatMessage(const Exception: EDatabaseError): string;
begin
  if not Assigned(Exception) then
    Exit('Undefined error.');

  if Exception.Message.Equals('Invalid field type.') then
    Exit('You must define a type for each of the fields.');

  if Exception.Message.Equals('Invalid field size') then
    Exit('Only "ftString" needs to set size property, which must be positive.');

  if Exception.Message.Contains('Duplicate name') then
    Exit(Format('%s. The field name must be unique.', [Exception.Message]));

  Result := Exception.Message;
end;

procedure TMain.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
var
  Grid: TStringGrid;
begin
  if ssCtrl in Shift then
  begin
    Grid := GetActiveGrid;

    if not Assigned(Grid) then
      Exit;

    case Key of
      vkInsert: Grid.Append;
      vkDelete: Grid.Delete;
    end;
  end;
end;

end.

