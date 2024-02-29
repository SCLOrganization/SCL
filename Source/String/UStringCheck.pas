unit UStringCheck;

{$I SCL.inc}

interface

uses
  UNumber, UString;

function Check(A: PChar; const B: RStr): Bool; inline; overload;
function Check(const A: PChar; AL: NChar; const B: PChar; BL: NChar): Bool; inline; overload;

implementation

uses
  UStringCompare;

function Check(A: PChar; const B: RStr): Bool;
begin
  Result := Compare(A, PChar(B), Length(B)) = 0;
end;

function Check(const A: PChar; AL: NChar; const B: PChar; BL: NChar): Bool;
begin
  Result := (AL = BL) and (Compare(A, B, AL) = 0);
end;

end.
