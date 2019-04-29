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
    Action1: TAction;
    procedure FormShow(Sender: TObject);
    procedure ActionCreateDataSetExecute(Sender: TObject);
    procedure ActionExportDataExecute(Sender: TObject);
    procedure ActionClearExecute(Sender: TObject);
    procedure ActionCopyToClipboardExecute(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
  private
    function GetConstant: string;
    procedure SetConstant(const Value: string);
    function GetXML: string;
    procedure SetXML(const Value: string);

    {}
    procedure ControlView;

    function Validate(out Message: string): Boolean;
    procedure NextPage;
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
  if not Validate(Message) then
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

function TMain.Validate(out Message: string): Boolean;
const
  StringType = [ftString, ftWideString, ftFixedChar, ftFixedWideChar];
begin
  Result := False;

  if DataModuleDM.Fields.IsEmpty then
  begin
    Message := 'Não existem definições de campos.';
    Exit;
  end;

  DataModuleDM.Fields.First;
  while not DataModuleDM.Fields.Eof do
  begin
    if DataModuleDM.Fields['Name'] = string.Empty then
    begin
      Message := Format('O campo de indíce %d está com o nome vazio.', [DataModuleDM.Fields.RecNo]);
      Exit;
    end;

    if DataModuleDM.Fields.FieldByName('Size').IsNull then
    begin
      if TFieldType(DataModuleDM.Fields['TypeId']) in StringType then
      begin
        begin
          Message := Format('O campo "%s" esta com a propriedade "Size" indefinida.', [DataModuleDM.Fields['Name']]);
          Exit;
        end;
      end;
    end;

    if not DataModuleDM.Fields.FieldByName('Size').IsNull then
    begin
      if not (TFieldType(DataModuleDM.Fields['TypeId']) in StringType) then
      begin
        begin
          Message := Format('O campo "%s" esta com a propriedade "Size" definida desnecessariamente.', [DataModuleDM.Fields['Name']]);
          Exit;
        end;
      end;
    end;

    DataModuleDM.Fields.Next;
  end;

  Result := True;
end;

end.

