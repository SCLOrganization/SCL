unit UStringCompare;

{$I SCL.inc}

interface

uses
  UNumber, UString;

function Compare(A, B: PChar): IPS; inline; overload;
function Compare(A, B: PChar; L: NChar): IPS; overload;

implementation

//Todo: Improve performance
function Compare(A, B: PChar): IPS;
var
  I: Ind;
  C1, C2: Char;
begin
  I := 0;
  repeat
    C1 := A[I];
    C2 := B[I];
    I += 1;
  until (C1 <> C2) or (C1 = #0) or (C2 = #0);
  Result := Ord(C1) - Ord(C2);
end;

//Todo: Improve performance
function Compare(A, B: PChar; L: NChar): IPS;
var
  I: Ind;
  C: NChar;
begin
  C := 0;
  for I := 1 to L shr 3 do
  begin
    if PU64(@A[C])^ <> PU64(@B[C])^ then
      Exit(Ord(PU64(@A[C])^ > PU64(@B[C])^) - Ord(PU64(@A[C])^ < PU64(@B[C])^));
    C += 8;
  end;
  for I := C to L - 1 do
    if A[I] <> B[I] then
      Exit(Ord(A[I] > B[I]) - Ord(A[I] < B[I]));
  Result := 0;
end;

end.
