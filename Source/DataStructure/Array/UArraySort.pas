unit UArraySort;

{$I SCL.inc}

interface

uses
  UNumber;

procedure QuickSortMiddlePivot<T>(var AArray: array of T); inline;

implementation

//Choose middle element as pivot
procedure QuickSortMiddlePivot<T>(var AArray: array of T);
var
  L, H: I64;
  Piv, Tmp: T;
begin
  L := Low(AArray);
  H := High(AArray);
  Piv := AArray[(L + H) div 2];
  repeat
    while AArray[L] < Piv do
      L += 1;
    while AArray[H] > Piv do
      h -= 1;
    if L <= H then
    begin
      Tmp := AArray[L];
      AArray[L] := AArray[H];
      AArray[H] := Tmp;
      L += 1;
      H -= 1;
    end;
  until L > H;
  if H > Low(AArray) then
    QuickSortMiddlePivot<T>(AArray[Low(AArray)..H]);
  if L < High(AArray) then
    QuickSortMiddlePivot<T>(AArray[L..High(AArray)]);
end;

end.

