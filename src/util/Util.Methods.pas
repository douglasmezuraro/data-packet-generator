unit Util.Methods;

interface

uses
  System.SysUtils, WinApi.Windows;

type
  TMethods = class sealed
  public
    class function GetFieldTypes: TArray<string>;
    class function GetVersion: string;
  end;

implementation

{ TMethods }

class function TMethods.GetFieldTypes: TArray<string>;
begin
  Result := ['ftString', 'ftInteger', 'ftBoolean', 'ftFloat', 'ftDate', 'ftTime', 'ftDateTime'];
end;

class function TMethods.GetVersion: string;
var
  Exe: string;
  Size, Handle: DWORD;
  Buffer: TBytes;
  FixedPtr: PVSFixedFileInfo;
begin
  Result := '1.0.0.0';

  Exe := ParamStr(0);
  Size := GetFileVersionInfoSize(PChar(Exe), Handle);

  if Size = 0 then
    Exit;

  SetLength(Buffer, Size);

  if not GetFileVersionInfo(PChar(Exe), Handle, Size, Buffer) then
    Exit;

  if not VerQueryValue(Buffer, '\', Pointer(FixedPtr), Size) then
    Exit;

  Result := Format('%d.%d.%d.%d', [
    LongRec(FixedPtr.dwFileVersionMS).Hi,  { Major }
    LongRec(FixedPtr.dwFileVersionMS).Lo,  { Minor }
    LongRec(FixedPtr.dwFileVersionLS).Hi,  { Release }
    LongRec(FixedPtr.dwFileVersionLS).Lo]) { Build }
end;

end.

