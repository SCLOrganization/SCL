unit UMemorySwap;

{$I SCL.inc}

interface

uses
  UString;

procedure Swap<T>(var A, B: T); inline; overload;

implementation

procedure Swap<T>(var A, B: T);
var
  C: T;
begin
  C := A;
  A := B;
  B := C;
end;

end.
