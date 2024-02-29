uses
  UWindows;

function LogicalProcessorCount: I32;
var
  SI: SYSTEM_INFO;
begin
  SI := Default(SYSTEM_INFO);
  GetSystemInfo(@SI);
  Result := SI.dwNumberOfProcessors;
end;
