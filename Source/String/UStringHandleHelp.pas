unit UStringHandleHelp;

{$I SCL.inc}

interface

uses
  UNumber, UString;

function NextItem(const P: PChar; var C: NChar; const L: NChar; const ASeparator: Char; const ATrimed: Bool): Str;
  inline; overload;

implementation

uses
  UStringHelp, UStringHandle;

function NextItem(const P: PChar; var C: NChar; const L: NChar; const ASeparator: Char; const ATrimed: Bool): Str;
var
  S, E: NChar;
  F: Bool;
begin
  C := NextItem(P, C, L, ASeparator, S, E, F);
  if ATrimed then
    Trim(P, S, E);
  Result := Create(P, S, E);
end;

end.
