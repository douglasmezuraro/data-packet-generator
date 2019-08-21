unit Util.Methods;

interface

type
  TMethods = class sealed
  public
    class function GetFieldTypes: TArray<string>;
  end;

implementation

{ TMethods }

class function TMethods.GetFieldTypes: TArray<string>;
begin
  Result := ['ftString', 'ftInteger', 'ftBoolean', 'ftFloat', 'ftDate', 'ftTime', 'ftDateTime'];
end;

end.
