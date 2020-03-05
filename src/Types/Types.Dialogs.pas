unit Types.Dialogs;

interface

uses
  FMX.Dialogs, FMX.DialogService, System.SysUtils, System.UITypes;

type
  TDialogs = class sealed
  strict private
    const HelpCtx: Byte = 0;
  private
    class function FormatExtensions(const Extensions: TArray<string>): string;
    class function OpenDialog(const Dialog: TOpenDialog; const Extensions: TArray<string>; out FileName: string): Boolean;
  public
    class function Confirmation(const Message: string): Boolean; overload;
    class function Confirmation(const Message: string; const Args: array of const): Boolean; overload;
    class procedure Error(const Message: string); overload;
    class procedure Error(const Message: string; const Args: array of const); overload;
    class procedure Information(const Message: string); overload;
    class procedure Information(const Message: string; const Args: array of const); overload;
    class procedure Warning(const Message: string); overload;
    class procedure Warning(const Message: string; const Args: array of const); overload;
    class function OpenFile(const Extension: string; out FileName: string): Boolean; overload;
    class function OpenFile(const Extensions: TArray<string>; out FileName: string): Boolean; overload;
    class function SaveFile(const Extension: string; out FileName: string): Boolean; overload;
    class function SaveFile(const Extensions: TArray<string>; out FileName: string): Boolean; overload;
  end;

implementation

class function TDialogs.Confirmation(const Message: string; const Args: array of const): Boolean;
begin
  Result := Confirmation(Format(Message, Args));
end;

class function TDialogs.Confirmation(const Message: string): Boolean;
var
  LResult: Boolean;
begin
  TDialogService.MessageDialog(Message, TMsgDlgType.mtConfirmation, FMX.Dialogs.mbYesNo, TMsgDlgBtn.mbNo, HelpCtx,
    procedure(const AResult: TModalResult)
    begin
      LResult := IsPositiveResult(AResult);
    end);

  Result := LResult;
end;

class procedure TDialogs.Error(const Message: string; const Args: array of const);
begin
  Error(Format(Message, Args));
end;

class procedure TDialogs.Error(const Message: string);
begin
  TDialogService.MessageDialog(Message, TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], TMsgDlgBtn.mbOK, HelpCtx, nil);
end;

class procedure TDialogs.Information(const Message: string; const Args: array of const);
begin
  Information(Format(Message, Args));
end;

class procedure TDialogs.Information(const Message: string);
begin
  TDialogService.MessageDialog(Message, TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOK], TMsgDlgBtn.mbOK, HelpCtx, nil);
end;

class procedure TDialogs.Warning(const Message: string; const Args: array of const);
begin
  Warning(Format(Message, Args));
end;

class procedure TDialogs.Warning(const Message: string);
begin
  TDialogService.MessageDialog(Message, TMsgDlgType.mtWarning, [TMsgDlgBtn.mbOK], TMsgDlgBtn.mbOK, HelpCtx, nil);
end;

class function TDialogs.OpenDialog(const Dialog: TOpenDialog; const Extensions: TArray<string>; out FileName: string): Boolean;
begin
  Dialog.Filter := FormatExtensions(Extensions);
  try
    if Dialog.Execute then
    begin
      FileName := Dialog.FileName;
      Exit(True);
    end;

    Result := False;
  finally
    Dialog.Free;
  end;
end;

class function TDialogs.OpenFile(const Extensions: TArray<string>; out FileName: string): Boolean;
begin
  Result := OpenDialog(TOpenDialog.Create(nil), Extensions, FileName);
end;

class function TDialogs.OpenFile(const Extension: string; out FileName: string): Boolean;
begin
  Result := OpenFile([Extension], FileName);
end;

class function TDialogs.SaveFile(const Extensions: TArray<string>; out FileName: string): Boolean;
begin
  Result := OpenDialog(TSaveDialog.Create(nil), Extensions, FileName);
end;

class function TDialogs.SaveFile(const Extension: string; out FileName: string): Boolean;
begin
  Result := SaveFile([Extension], FileName);
end;

class function TDialogs.FormatExtensions(const Extensions: TArray<string>): string;
var
  Extension: string;
  Builder: TStringBuilder;
begin
  Builder := TStringBuilder.Create;
  try
    for Extension in Extensions do
    begin
      Builder.Append('|*.').Append(Extension);
    end;

    Result := Builder.ToString;
  finally
    Builder.Free;
  end;
end;

end.

