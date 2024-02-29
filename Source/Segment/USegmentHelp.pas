unit USegmentHelp;

{$I SCL.inc}

interface

uses
  UNumber, UString, UStringHelp, USegment, UArray, UList;

type
  TStringSegmentNCharUPS = TSegment<NChar, UPS>;
  PStringSegmentNCharUPS = ^TStringSegmentNCharUPS;
  TStringSegmentNCharUPSArray = TArray<TStringSegmentNCharUPS>;
  TStringSegmentNCharUPSList = TList<TStringSegmentNCharUPS>;

function ToStr<TFirst, TCount>(AData: PChar; const ASegment: TSegment<TFirst, TCount>): Str; inline; overload;
function ToStrArray<TFirst, TCount>(AData: PChar; const AArray: TSegmentArray<TFirst, TCount>): TStrArray; overload;

implementation

function ToStr<TFirst, TCount>(AData: PChar; const ASegment: TSegment<TFirst, TCount>): Str;
var
  F: TFirst;
  C: TCount;
begin
  F := First<TFirst, TCount>(ASegment);
  C := Count<TFirst, TCount>(ASegment);
  Result := Create(AData + F, C);
end;

function ToStrArray<TFirst, TCount>(AData: PChar; const AArray: TSegmentArray<TFirst, TCount>): TStrArray;
var
  I: Ind;
begin
  SetLength(Result{%H-}, Length(AArray));
  for I := Low(AArray) to High(AArray) do
    Result[I] := ToStr<TFirst, TCount>(AData, AArray[I]);
end;

end.
