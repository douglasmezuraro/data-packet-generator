program DataPacketGenerator;

uses
  Vcl.Forms,
  Form.Main in 'src\Form.Main.pas' {Main},
  Vcl.Themes,
  Vcl.Styles,
  Form.DataModule in 'src\Form.DataModule.pas' {DataModuleDM: TDataModule},
  Utils in 'src\Utils.pas';

{$R *.res}

var
  Main: TMain;

begin
  ReportMemoryLeaksOnShutdown := True;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Smokey Quartz Kamri');
  Application.CreateForm(TMain, Main);
  Application.CreateForm(TDataModuleDM, DataModuleDM);
  Application.Run;
end.
