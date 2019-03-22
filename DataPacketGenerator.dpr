program DataPacketGenerator;

uses
  Vcl.Forms,
  Form.Main in 'Form.Main.pas' {Main},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

var
  Main: TMain;

begin
  ReportMemoryLeaksOnShutdown := True;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Smokey Quartz Kamri');
  Application.CreateForm(TMain, Main);
  Application.Run;
end.
