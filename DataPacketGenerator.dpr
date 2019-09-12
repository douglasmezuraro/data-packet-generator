program DataPacketGenerator;

uses
  MidasLib,
  System.StartUpCopy,
  FMX.Forms,
  View.Main in 'src\view\View.Main.pas' {Main},
  Helper.FMX in 'src\helper\Helper.FMX.pas',
  Util.Methods in 'src\util\Util.Methods.pas',
  Util.XMLExporter in 'src\util\Util.XMLExporter.pas';

{$R *.res}

var
  Main: TMain;

begin
  Application.Initialize;
  Application.Title := 'DataPacket Generator';
  Application.CreateForm(TMain, Main);
  Application.Run;

  {$WARN SYMBOL_PLATFORM OFF}
  ReportMemoryLeaksOnShutdown := WordBool(DebugHook);
  {$WARN SYMBOL_PLATFORM ON}
end.

