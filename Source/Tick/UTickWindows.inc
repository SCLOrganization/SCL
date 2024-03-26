uses
  UWindows, UException;

var
  QueryPerformanceFrequencyValue: I64;

function TickCount: TTickCount;
begin
  QueryPerformanceCounter(PLARGE_INTEGER(@Result));
end;

function ToMicrosecond(const ATick: TTickCount): TTickMicrosecond;
begin
  Result := ATick div (QueryPerformanceFrequencyValue div 1000000);
end;

procedure InitializeUnit;
begin
  if not QueryPerformanceFrequency(PLARGE_INTEGER(@QueryPerformanceFrequencyValue)) then
    raise Exception.Create('Problem in getting frequency value.');
end;
