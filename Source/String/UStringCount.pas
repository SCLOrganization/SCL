unit UStringCount;

{$I SCL.inc}

interface

uses
  UNumber, UString;

function Count(P: PChar): Siz; inline; overload;

implementation

//Looks for the end of a zero-terminated string
function Count(P: PChar): Siz;
begin
  Result := System.StrLen(P);
end;

end.
