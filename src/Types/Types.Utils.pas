unit Types.Utils;

interface

uses
  System.SysUtils,
  Winapi.UrlMon,
  WinApi.Windows;

type
  TUtils = class sealed
  public
    class procedure OpenURL(const URL: string);
    class function GetFieldTypes: TArray<string>;
    class function GetVersion: string;
  end;

implementation

class function TUtils.GetFieldTypes: TArray<string>;
begin
  Result := ['ftString', 'ftInteger', 'ftBoolean', 'ftFloat', 'ftDate', 'ftTime', 'ftDateTime'];
end;

class function TUtils.GetVersion: string;
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

class procedure TUtils.OpenURL(const URL: string);
begin
  HlinkNavigateString(nil, PWideChar(URL));
end;

end.
