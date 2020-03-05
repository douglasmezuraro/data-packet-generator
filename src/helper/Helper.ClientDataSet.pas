unit Helper.ClientDataSet;

interface

uses
  Datasnap.DBClient,
  System.SysUtils;

type
  TClientDataSetHelper = class Helper for TClientDataSet
  public
    procedure ForEach(const Method: TProc);
  end;


implementation

procedure TClientDataSetHelper.ForEach(const Method: TProc);
begin
  First;
  while not Eof do
  begin
    Method;
    Next;
  end;
end;

end.
