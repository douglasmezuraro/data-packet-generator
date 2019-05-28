program DataPacketGenerator;

uses
  Midas,
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  Form.Main in 'src\Form.Main.pas' {Main},
  Form.DataModule in 'src\Form.DataModule.pas' {DataModuleDM: TDataModule},
  XML.Exporter in 'src\XML.Exporter.pas';

{$R *.res}

var
  Main: TMain;

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Data Packet Generator';

  TStyleManager.TrySetStyle('Smokey Quartz Kamri');

  Application.CreateForm(TMain, Main);
  Application.CreateForm(TDataModuleDM, DataModuleDM);
  Application.Run;

  ReportMemoryLeaksOnShutdown := True;
end.
