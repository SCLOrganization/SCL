unit UConsole;

{$I SCL.inc}

interface

uses
  UNumber, UString;

type
  TConsoleCloseHandler = reference to procedure;

procedure CloseHandler(constref AHandler: TConsoleCloseHandler); overload;
procedure CursorVisible(AVisible: Bool); overload;

implementation

{$IfDef Windows}
{$I UConsoleWindows.inc}
{$EndIf}
{$IfDef Posix}
{$I UConsolePosix.inc}
{$EndIf}

initialization
  SetTextCodePage(Output, CP_UTF8); //Support Unicode output
  InitializeUnit;
end.
