unit Form.Main;

interface

uses
  Data.DB,
  Form.DataModule,
  System.Actions,
  System.Classes,
  System.SysUtils,
  Utils,
  Vcl.ActnList,
  Vcl.ComCtrls,
  Vcl.Controls,
  Vcl.DBGrids,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  Vcl.Forms,
  Vcl.Grids,
  Vcl.StdCtrls;

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
    function GetFileName: string;
  public
    property Constant: string read GetConstant write SetConstant;
    property XML: string read GetXML write SetXML;
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
begin
  XML := TUtils.GetXML(DataModuleDM.Data, Constant);
  NextPage;
end;

procedure TMain.ActionImportDataExecute(Sender: TObject);
begin
  DataModuleDM.Data.LoadFromFile(Self.GetFileName);
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

procedure TMain.FormShow(Sender: TObject);
begin
  PageControl.ActivePage := TabSheetFields;
  ControlView;
end;

function TMain.GetConstant: string;
begin
  Result := EditConstant.Text;
end;

function TMain.GetFileName: string;
var
  Dialog: TOpenDialog;
begin
  Result := string.Empty;

  Dialog := TOpenDialog.Create(Self);
  try
    Dialog.InitialDir := GetCurrentDir;
    Dialog.Options := [ofFileMustExist];
    Dialog.Filter := 'Arquivo Dat|*.dat|Arquivo XML|*.XML';

    if Dialog.Execute then
      Result := Dialog.FileName;
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

