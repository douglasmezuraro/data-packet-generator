program DataPacketGenerator;

uses
  MidasLib,
  System.StartUpCopy,
  FMX.Forms,
  View.Main in 'src\view\View.Main.pas' {Main},
  Helper.FMX in 'src\helper\Helper.FMX.pas',
  Types.XMLExporter in 'src\Types\Types.XMLExporter.pas',
  Types.Dialogs in 'src\Types\Types.Dialogs.pas',
  Types.Utils in 'src\Types\Types.Utils.pas',
  Helper.ClientDataSet in 'src\helper\Helper.ClientDataSet.pas';

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

