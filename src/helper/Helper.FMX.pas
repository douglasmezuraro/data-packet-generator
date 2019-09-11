unit Helper.FMX;

interface

uses
  FMX.Grid, FMX.ListBox, System.Classes, System.SysUtils, Data.DB, DataSnap.DBClient, System.Math,
  FMX.StdCtrls, System.UITypes, FMX.Types, System.Rtti;

type
  TColumnFactory = class sealed
  public
    class function Fabricate(const FieldDef: TFieldDef): TColumn;
  end;

  TStringGridHelper = class Helper for TStringGrid
  private const
    NotFoundIndex: ShortInt = -1;
    FirstColumn = 0;
    FirstRow = 0;
  private
    procedure CreateColumns(const DataSet: TClientDataSet);
    procedure FillData(const DataSet: TClientDataSet);
  public
    procedure FromDataSet(const DataSet: TClientDataSet);
    procedure ToDataSet(const DataSet: TClientDataSet);
    function Headers: TArray<string>;

    function IsEmpty: Boolean;
    procedure Empty(const DeleteColumns: Boolean = True);
    procedure Append;
    procedure Insert;
    procedure Delete;
  end;

  TListBoxHelper = class Helper for TListBox
  private
    function GetCheckedItems: TArray<string>;
    procedure CheckOrUncheckAll(const Checked: Boolean);
  public
    procedure CheckAll;
    procedure UncheckAll;
    function IsFiltred(const Item: TListBoxItem): Boolean;
    property CheckedItems: TArray<string> read GetCheckedItems;
  end;

  TLabelHelper = class Helper for TLabel
  public type
    TLabelStyle = (lsNone, lsHyperLink);
  public
    procedure SetStyle(const Style: TLabelStyle);
  end;

implementation

{ TColumnFactory }

class function TColumnFactory.Fabricate(const FieldDef: TFieldDef): TColumn;
const
  DATE_TIME_FORMAT = 'dd/MM/yyyy hh:mm:ss';
var
  Column: TColumn;
begin
  case FieldDef.DataType of
    ftString   : Column := TStringColumn.Create(nil);
    ftInteger  : Column := TIntegerColumn.Create(nil);
    ftBoolean  : Column := TCheckColumn.Create(nil);
    ftFloat    : Column := TFloatColumn.Create(nil);
    ftDate     : Column := TDateColumn.Create(nil);
    ftTime     : Column := TTimeColumn.Create(nil);
    ftDateTime :
      begin
        Column := TTimeColumn.Create(nil);
        TTimeColumn(Column).Format := DATE_TIME_FORMAT;
        Column.Width := Max(Column.Width, Column.Width * 1.4);
      end
  else
    raise ENotImplemented.CreateFmt('The column for the "%s" fieldtype has been not implemented.',
      [TRttiEnumerationType.GetName<TFieldType>(FieldDef.DataType)]);
  end;

  Column.Header := FieldDef.Name;

  Result := Column;
end;

{ TStringGridHelper }

procedure TStringGridHelper.Append;
begin
  RowCount := Succ(RowCount);
  SelectCell(FirstColumn, Succ(Selected));
  EditorMode := True;
end;

procedure TStringGridHelper.CreateColumns(const DataSet: TClientDataSet);
var
  Enumerator: TCollectionEnumerator;
begin
  Enumerator := DataSet.FieldDefs.GetEnumerator;
  try
    while Enumerator.MoveNext do
      AddObject(TColumnFactory.Fabricate(Enumerator.Current as TFieldDef));
  finally
    Enumerator.Free;
  end;
end;

procedure TStringGridHelper.Delete;
var
  LColumn, LRow: Integer;
begin
  if IsEmpty then
    Exit;

  if Selected <> RowCount then
  begin
    for LRow := Selected to Pred(RowCount) do
    begin
      for LColumn := FirstColumn to Pred(ColumnCount) do
      begin
        Cells[LColumn, LRow] := Cells[LColumn, Succ(LRow)];
      end;
    end;
  end;

  RowCount := Pred(RowCount);
end;

procedure TStringGridHelper.Empty(const DeleteColumns: Boolean = True);
begin
  RowCount := 0;
  if DeleteColumns then
    ClearColumns;
end;

procedure TStringGridHelper.FillData(const DataSet: TClientDataSet);
var
  LColumn: Integer;
begin
  DataSet.DisableControls;
  try
    DataSet.First;
    while not DataSet.Eof do
    begin
      for LColumn := FirstColumn to Pred(ColumnCount) do
      begin
        Cells[LColumn, Pred(DataSet.RecNo)] := DataSet.FieldByName(ColumnByIndex(LColumn).Header).AsString;
      end;
      DataSet.Next;
    end;
  finally
    DataSet.EnableControls;
  end;
end;

procedure TStringGridHelper.FromDataSet(const DataSet: TClientDataSet);
begin
  if not Assigned(DataSet) then
    Exit;

  Empty;
  RowCount := DataSet.RecordCount;
  CreateColumns(DataSet);
  FillData(DataSet);
end;

function TStringGridHelper.Headers: TArray<string>;
var
  LColumn: Integer;
begin
  SetLength(Result, ColumnCount);
  for LColumn := FirstColumn to Pred(ColumnCount) do
    Result[LColumn] := ColumnByIndex(LColumn).Header;
end;

procedure TStringGridHelper.Insert;
var
  LColumn, LRow: Integer;
begin
  EditorMode := False;

  RowCount := Succ(RowCount);

  if Selected = NotFoundIndex then
    Exit;

  for LRow := Pred(RowCount) downto Selected  do
  begin
    for LColumn := FirstColumn to Pred(ColumnCount) do
    begin
      Cells[LColumn, LRow] := string.Empty;
      if LRow <> Selected then
        Cells[LColumn, LRow] := Cells[LColumn, Pred(LRow)];
    end;
  end;

  SelectColumn(FirstColumn);
  EditorMode := True;
end;

function TStringGridHelper.IsEmpty: Boolean;
begin
  Result := RowCount = 0;
end;

procedure TStringGridHelper.ToDataSet(const DataSet: TClientDataSet);
var
  LColumn, LRow: Integer;
begin
  if not Assigned(DataSet) then
    Exit;

  if not DataSet.Active then
    Exit;

  DataSet.DisableControls;
  try
    DataSet.EmptyDataSet;
    for LRow := FirstRow to Pred(RowCount) do
    begin
      DataSet.Append;
      for LColumn := FirstColumn to Pred(ColumnCount) do
      begin
        DataSet.FieldByName(ColumnByIndex(LColumn).Header).AsString := Cells[LColumn, LRow];
      end;
      DataSet.Post;
    end;
  finally
    DataSet.EnableControls;
  end;
end;

{ TListBoxHelper }

procedure TListBoxHelper.CheckAll;
begin
  CheckOrUncheckAll(True);
end;

procedure TListBoxHelper.UncheckAll;
begin
  CheckOrUncheckAll(False);
end;

procedure TListBoxHelper.CheckOrUncheckAll(const Checked: Boolean);
var
  Enumerator: TComponentEnumerator;
begin
  Enumerator := GetEnumerator;
  try
    while Enumerator.MoveNext do
    begin
      if Enumerator.Current is TListBoxItem then
      begin
        if not IsFiltred((Enumerator.Current as TListBoxItem)) then
          (Enumerator.Current as TListBoxItem).IsChecked := Checked;
      end;
    end;
  finally
    Enumerator.Free;
  end;
end;

function TListBoxHelper.GetCheckedItems: TArray<string>;
var
  Item: TListBoxItem;
  Enumerator: TComponentEnumerator;
begin
  Enumerator := GetEnumerator;
  try
    while Enumerator.MoveNext do
    begin
      if Enumerator.Current is TListBoxItem then
      begin
        Item := Enumerator.Current as TListBoxItem;
        if Item.IsChecked then
        begin
          SetLength(Result, Succ(Length(Result)));
          Result[High(Result)] := Item.Text;
        end;
      end;
    end;
  finally
    Enumerator.Free;
  end;
end;

function TListBoxHelper.IsFiltred(const Item: TListBoxItem): Boolean;
var
  Index: Integer;
begin
  Result := False;

  if not Assigned(Item) then
    Exit;

  for Index := 0 to Pred((Content.Scrollbox as TListBox).Items.Count) do
  begin
    if Item.Equals((Content.Scrollbox as TListBox).ListItems[Index]) then
      Exit;
  end;

  Result := True;
end;

{ TLabelHelper }

procedure TLabelHelper.SetStyle(const Style: TLabelStyle);
begin
  HitTest := True;
  StyledSettings := StyledSettings - [TStyledSetting.FontColor, TStyledSetting.Style];
  case Style of
    TLabelStyle.lsNone:
      begin
        FontColor := TAlphaColorRec.Black;
        Font.Style := Font.Style - [TFontStyle.fsUnderline];
        Cursor := crDefault;
      end;
    TLabelStyle.lsHyperLink:
      begin
        FontColor := TAlphaColorRec.Blue;
        Font.Style := Font.Style + [TFontStyle.fsUnderline];
        Cursor := crHandPoint;
      end;
  end;
end;

end.

