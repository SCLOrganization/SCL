uses
  UWindows, UException;

var
  FCloseHandler: TConsoleCloseHandler;

function CtrlHandler({%H-}dwCtrlType: DWORD): BOOL; stdcall;
begin
  if Assigned(FCloseHandler) then
    FCloseHandler;
  Result := True; //Handled
end;

//AHandler will be called from different thread
//On Ctrl-C, program will continue
//On Window Close, program will close on AHandler finish
procedure CloseHandler(constref AHandler: TConsoleCloseHandler);
begin
  SetConsoleCtrlHandler(@CtrlHandler, True);
  FCloseHandler := AHandler;
end;

procedure CursorVisible(AVisible: Bool);
var
  CCI: CONSOLE_CURSOR_INFO;
begin
  GetConsoleCursorInfo(StdOutputHandle, @CCI);
  CCI.bVisible := AVisible;
  SetConsoleCursorInfo(StdOutputHandle, @CCI);
end;

procedure InitializeUnit;
begin
  SetConsoleOutputCP(CP_UTF8); //Support Unicode output   
end;
