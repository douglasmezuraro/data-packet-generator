unit Form.Main;

interface

uses
  Data.DB,
  Form.DataModule,
  System.Actions,
  System.Classes,
  System.SysUtils,
  Vcl.ActnList,
  Vcl.CheckLst,
  Vcl.ComCtrls,
  Vcl.Controls,
  Vcl.DBGrids,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  Vcl.Forms,
  Vcl.Grids,
  Vcl.Menus,
  Vcl.StdCtrls,
  XML.Exporter;

type
  TMain = class(TForm)
    ActionClear: TAction;
    ActionCopyToClipboard: TAction;
    ActionCreateDataSet: TAction;
    ActionExportData: TAction;
    ActionList: TActionList;
    ButtonClear: TButton;
    ButtonAction: TButton;
    EditConstant: TLabeledEdit;
    GridData: TDBGrid;
    GridFields: TDBGrid;
    MemoXML: TMemo;
    PageControl: TPageControl;
    PanelConstant: TPanel;
    PanelBottom: TPanel;
    TabSheetData: TTabSheet;
    TabSheetFields: TTabSheet;
    TabSheetXML: TTabSheet;
    ActionImportData: TAction;
    ButtonImportData: TButton;
    CheckListBoxFields: TCheckListBox;
    PopupMenuFields: TPopupMenu;
    MenuItemCheckAll: TMenuItem;
    ActionCheckAll: TAction;
    ActionUncheckAll: TAction;
    MenuItemUncheckAll: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure ActionCreateDataSetExecute(Sender: TObject);
    procedure ActionExportDataExecute(Sender: TObject);
    procedure ActionClearExecute(Sender: TObject);
    procedure ActionCopyToClipboardExecute(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
    procedure ActionImportDataExecute(Sender: TObject);
    procedure ActionCheckAllExecute(Sender: TObject);
    procedure ActionUncheckAllExecute(Sender: TObject);
  strict private
    function GetConstant: string;
    procedure SetConstant(const Value: string);
    function GetXML: string;
    procedure SetXML(const Value: string);
    function GetFields: TArray<string>;
  private
    procedure ControlView;
    procedure NextPage;
    procedure UpdateFieldList;
    function OpenFile(out FileName: TFileName): Boolean;
  public
    property Constant: string read GetConstant write SetConstant;
    property XML: string read GetXML write SetXML;
    property Fields: TArray<string> read GetFields;
  end;

implementation

{$R *.dfm}

procedure TMain.ActionCheckAllExecute(Sender: TObject);
begin
  CheckListBoxFields.CheckAll(TCheckBoxState.cbChecked);
end;

procedure TMain.ActionClearExecute(Sender: TObject);
begin
  DataModuleDM.Clear;
  MemoXML.Clear;
  CheckListBoxFields.Clear;
  GridData.Columns.RebuildColumns;
  Constant := string.Empty;
end;

procedure TMain.ActionCopyToClipboardExecute(Sender: TObject);
begin
  MemoXML.SelectAll;
  MemoXML.CopyToClipboard;
end;

procedure TMain.ActionCreateDataSetExecute(Sender: TObject);
var
  Message: string;
begin
  if not DataModuleDM.Validate(Message) then
  begin
    ShowMessage(Message);
    Abort;
  end;

  DataModuleDM.CreateData;
  GridData.Columns.RebuildColumns;

  UpdateFieldList;

  NextPage;
end;

procedure TMain.ActionExportDataExecute(Sender: TObject);
var
  Exporter: TXMLExporter;
begin
  Exporter := TXMLExporter.Create;
  try
    Exporter.Fields := Fields;
    Exporter.DataSet := DataModuleDM.Data;
    Exporter.Constant := Constant;

    XML := Exporter.Export;

    NextPage;
  finally
    Exporter.Free;
  end;
end;

procedure TMain.ActionImportDataExecute(Sender: TObject);
var
  FileName: TFileName;
begin
  if OpenFile(FileName) then
  begin
    DataModuleDM.Data.LoadFromFile(FileName);
    DataModuleDM.Data.LogChanges := False;
    UpdateFieldList;
    NextPage;
  end;
end;

procedure TMain.ActionUncheckAllExecute(Sender: TObject);
begin
  CheckListBoxFields.CheckAll(TCheckBoxState.cbUnchecked);
end;

procedure TMain.ControlView;
begin
  if PageControl.ActivePage = TabSheetFields then
    ButtonAction.Action := ActionCreateDataSet;

  if PageControl.ActivePage = TabSheetData then
    ButtonAction.Action := ActionExportData;

  if PageControl.ActivePage = TabSheetXML then
    ButtonAction.Action := ActionCopyToClipboard;

  ButtonImportData.Visible := PageControl.ActivePage = TabSheetFields;
end;

procedure TMain.UpdateFieldList;
begin
  DataModuleDM.Data.GetFieldNames(CheckListBoxFields.Items);
  CheckListBoxFields.Sorted := True;
  CheckListBoxFields.CheckAll(TCheckBoxState.cbChecked);
end;

procedure TMain.FormShow(Sender: TObject);
begin
  PageControl.ActivePage := TabSheetFields;
  ControlView;
end;

function TMain.GetConstant: string;
begin
  Result := EditConstant.Text;
end;

function TMain.GetFields: TArray<string>;
var
  Index, Length: Integer;
begin
  Length := 0;
  for Index := 0 to Pred(CheckListBoxFields.Items.Count) do
  begin
    if CheckListBoxFields.Checked[Index] then
    begin
      Length := Succ(Length);
      SetLength(Result, Length);
      Result[Pred(Length)] := CheckListBoxFields.Items[Index];
    end;
  end;
end;

function TMain.OpenFile(out FileName: TFileName): Boolean;
var
  Dialog: TOpenDialog;
begin
  Result := False;
  Dialog := TOpenDialog.Create(Self);
  try
    Dialog.Options := [ofFileMustExist, ofHideReadOnly];
    Dialog.Filter := 'DAT File|*.dat|XML File|*.XML';

    if Dialog.Execute then
    begin
      FileName := Dialog.FileName;
      Result := True;
    end;
  finally
    Dialog.Free;
  end;
end;

function TMain.GetXML: string;
begin
  Result := MemoXML.Lines.Text;
end;

procedure TMain.NextPage;
begin
  PageControl.ActivePageIndex := Succ(PageControl.ActivePageIndex);
  ControlView;
end;

procedure TMain.PageControlChange(Sender: TObject);
begin
  ControlView;
end;

procedure TMain.SetConstant(const Value: string);
begin
  EditConstant.Text := Value;
end;

procedure TMain.SetXML(const Value: string);
begin
  MemoXML.Clear;
  MemoXML.Lines.Text := Value;
end;

end.

