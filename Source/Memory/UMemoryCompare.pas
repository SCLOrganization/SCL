unit UMemoryCompare;

{$I SCL.inc}

interface

uses
  UNumber;

function Compare(AData: PU8; ACount: Siz; AValue: U8): Bool; inline; overload;

implementation

//Todo: Improve
function Compare(AData: PU8; ACount: Siz; AValue: U8): Bool;
var
  I: Ind;
begin
  Result := True; //Empty
  for I := 0 to ACount - 1 do
  begin
    Result := AData[I] = AValue;
    if not Result then
      Exit;
  end;
end;

end.
