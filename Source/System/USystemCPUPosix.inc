function LogicalProcessorCount: I32;
begin
  Result := System.GetCPUCount;
end;
