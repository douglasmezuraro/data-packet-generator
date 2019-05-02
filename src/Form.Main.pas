{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N-,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$WARN SYMBOL_DEPRECATED ON}
{$WARN SYMBOL_LIBRARY ON}
{$WARN SYMBOL_PLATFORM ON}
{$WARN SYMBOL_EXPERIMENTAL ON}
{$WARN UNIT_LIBRARY ON}
{$WARN UNIT_PLATFORM ON}
{$WARN UNIT_DEPRECATED ON}
{$WARN UNIT_EXPERIMENTAL ON}
{$WARN HRESULT_COMPAT ON}
{$WARN HIDING_MEMBER ON}
{$WARN HIDDEN_VIRTUAL ON}
{$WARN GARBAGE ON}
{$WARN BOUNDS_ERROR ON}
{$WARN ZERO_NIL_COMPAT ON}
{$WARN STRING_CONST_TRUNCED ON}
{$WARN FOR_LOOP_VAR_VARPAR ON}
{$WARN TYPED_CONST_VARPAR ON}
{$WARN ASG_TO_TYPED_CONST ON}
{$WARN CASE_LABEL_RANGE ON}
{$WARN FOR_VARIABLE ON}
{$WARN CONSTRUCTING_ABSTRACT ON}
{$WARN COMPARISON_FALSE ON}
{$WARN COMPARISON_TRUE ON}
{$WARN COMPARING_SIGNED_UNSIGNED ON}
{$WARN COMBINING_SIGNED_UNSIGNED ON}
{$WARN UNSUPPORTED_CONSTRUCT ON}
{$WARN FILE_OPEN ON}
{$WARN FILE_OPEN_UNITSRC ON}
{$WARN BAD_GLOBAL_SYMBOL ON}
{$WARN DUPLICATE_CTOR_DTOR ON}
{$WARN INVALID_DIRECTIVE ON}
{$WARN PACKAGE_NO_LINK ON}
{$WARN PACKAGED_THREADVAR ON}
{$WARN IMPLICIT_IMPORT ON}
{$WARN HPPEMIT_IGNORED ON}
{$WARN NO_RETVAL ON}
{$WARN USE_BEFORE_DEF ON}
{$WARN FOR_LOOP_VAR_UNDEF ON}
{$WARN UNIT_NAME_MISMATCH ON}
{$WARN NO_CFG_FILE_FOUND ON}
{$WARN IMPLICIT_VARIANTS ON}
{$WARN UNICODE_TO_LOCALE ON}
{$WARN LOCALE_TO_UNICODE ON}
{$WARN IMAGEBASE_MULTIPLE ON}
{$WARN SUSPICIOUS_TYPECAST ON}
{$WARN PRIVATE_PROPACCESSOR ON}
{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_CAST OFF}
{$WARN OPTION_TRUNCATED ON}
{$WARN WIDECHAR_REDUCED ON}
{$WARN DUPLICATES_IGNORED ON}
{$WARN UNIT_INIT_SEQ ON}
{$WARN LOCAL_PINVOKE ON}
{$WARN MESSAGE_DIRECTIVE ON}
{$WARN TYPEINFO_IMPLICITLY_ADDED ON}
{$WARN RLINK_WARNING ON}
{$WARN IMPLICIT_STRING_CAST ON}
{$WARN IMPLICIT_STRING_CAST_LOSS ON}
{$WARN EXPLICIT_STRING_CAST OFF}
{$WARN EXPLICIT_STRING_CAST_LOSS OFF}
{$WARN CVT_WCHAR_TO_ACHAR ON}
{$WARN CVT_NARROWING_STRING_LOST ON}
{$WARN CVT_ACHAR_TO_WCHAR ON}
{$WARN CVT_WIDENING_STRING_LOST ON}
{$WARN NON_PORTABLE_TYPECAST ON}
{$WARN XML_WHITESPACE_NOT_ALLOWED ON}
{$WARN XML_UNKNOWN_ENTITY ON}
{$WARN XML_INVALID_NAME_START ON}
{$WARN XML_INVALID_NAME ON}
{$WARN XML_EXPECTED_CHARACTER ON}
{$WARN XML_CREF_NO_RESOLVE ON}
{$WARN XML_NO_PARM ON}
{$WARN XML_NO_MATCHING_PARM ON}
{$WARN IMMUTABLE_STRINGS OFF}
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
    procedure FormShow(Sender: TObject);
    procedure ActionCreateDataSetExecute(Sender: TObject);
    procedure ActionExportDataExecute(Sender: TObject);
    procedure ActionClearExecute(Sender: TObject);
    procedure ActionCopyToClipboardExecute(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
    procedure ActionImportDataExecute(Sender: TObject);
  private
    function GetConstant: string;
    procedure SetConstant(const Value: string);
    function GetXML: string;
    procedure SetXML(const Value: string);
    procedure ControlView;
    procedure NextPage;
    procedure Foo;
    function OpenFile(out FileName: TFileName): Boolean;
    function GetFields: TArray<string>;
  public
    property Constant: string read GetConstant write SetConstant;
    property XML: string read GetXML write SetXML;
    property Fields: TArray<string> read GetFields;
  end;

implementation

{$R *.dfm}

procedure TMain.ActionClearExecute(Sender: TObject);
begin
  DataModuleDM.Clear;
  MemoXML.Lines.Clear;
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
    Foo;
  end;
end;

procedure TMain.ControlView;
begin
  if PageControl.ActivePage = TabSheetFields then
    ButtonAction.Action := ActionCreateDataSet;

  if PageControl.ActivePage = TabSheetData then
    ButtonAction.Action := ActionExportData;

  if PageControl.ActivePage = TabSheetXML then
    ButtonAction.Action := ActionCopyToClipboard;
end;

procedure TMain.Foo;
begin
  DataModuleDM.Data.GetFieldNames(CheckListBoxFields.Items);
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
  //  Dialog.InitialDir := GetCurrentDir;
    Dialog.Options := [ofFileMustExist];
    Dialog.Filter := 'Arquivo Dat|*.dat|Arquivo XML|*.XML';

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

