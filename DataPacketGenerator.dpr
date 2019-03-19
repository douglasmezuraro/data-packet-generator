program DataPacketGenerator;

uses
  Vcl.Forms,
  Form.Main in 'Form.Main.pas' {Main};

{$R *.res}

var
  Main: TMain;

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMain, Main);
  Application.Run;
end.
