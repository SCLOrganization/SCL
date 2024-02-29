uses
  BaseUnix, Linux;

function TickCount: TTickCount;
var
  R: cint;
  T: TTimeSpec;
begin
  R := clock_gettime(CLOCK_MONOTONIC, @T);
  if R = 0 then
    Result := T.tv_nsec + T.tv_sec * 1000000000
  else
    Result := 0;
end;

function ToMicrosecond(const ATick: TTickCount): TTickMicrosecond;
begin
  Result := ATick div 1000;
end;

procedure InitializeUnit;
begin
end;
