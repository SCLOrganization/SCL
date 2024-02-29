uses
  BaseUnix, Unix;

var
  FCloseHandler: TConsoleCloseHandler;

procedure SignalHandler({%H-}ASignal: LongInt); cdecl;
begin
  if Assigned(FCloseHandler) then
    FCloseHandler;
end;

procedure CloseHandler(constref AHandler: TConsoleCloseHandler);
begin
  FpSignal(SIGINT, @SignalHandler);
  FpSignal(SIGHUP, @SignalHandler);
  FpSignal(SIGTERM, @SignalHandler);
  FpSignal(SIGQUIT, @SignalHandler);
  FCloseHandler := AHandler;
end;

procedure CursorVisible(AVisible: Bool);
begin
  if AVisible then
    fpSystem('tput cnorm')
  else
    fpSystem('tput civis');
end;

procedure InitializeUnit;
begin
end;
