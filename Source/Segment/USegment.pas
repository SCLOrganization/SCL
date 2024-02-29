unit USegment;

{$I SCL.inc}

interface

uses
  UString;

type
  TSegment<TFirst, TCount> = packed record
    First: TFirst;
    Count: TCount;
  end;
  TSegmentArray<TFirst, TCount> = array of TSegment<TFirst, TCount>;

procedure First<TFirst, TCount>(var ASegment: TSegment<TFirst, TCount>; const AFirst: TFirst); inline; overload;
function First<TFirst, TCount>(constref ASegment: TSegment<TFirst, TCount>): TFirst; inline; overload;
procedure Count<TFirst, TCount>(var ASegment: TSegment<TFirst, TCount>; const ASize: TCount); inline; overload;
function Count<TFirst, TCount>(constref ASegment: TSegment<TFirst, TCount>): TCount; inline; overload;

implementation

procedure First<TFirst, TCount>(var ASegment: TSegment<TFirst, TCount>; const AFirst: TFirst);
begin
  ASegment.First := AFirst;
end;

function First<TFirst, TCount>(constref ASegment: TSegment<TFirst, TCount>): TFirst;
begin
  Result := ASegment.First;
end;

procedure Count<TFirst, TCount>(var ASegment: TSegment<TFirst, TCount>; const ASize: TCount);
begin
  ASegment.Count := ASize;
end;

function Count<TFirst, TCount>(constref ASegment: TSegment<TFirst, TCount>): TCount;
begin
  Result := ASegment.Count;
end;

end.
