unit UStringSplit;

{$I SCL.inc}

interface

uses
  UNumber, UString, USegment, USegmentHelp;

type
  TSplitStringToArrayOption = (sstaoExcludeEmpty, sstaoTrim);
  TSplitStringToArrayOptions = set of TSplitStringToArrayOption;

function Split(const AValue: RStr; ASeparator: Char; AOptions: TSplitStringToArrayOptions): TStringSegmentNCharUPSArray; overload;

implementation

uses
  UStringHandle, UList, UListHelp;

function Split(const AValue: RStr; ASeparator: Char; AOptions: TSplitStringToArrayOptions): TStringSegmentNCharUPSArray;
var
  ResultList: TStringSegmentNCharUPSList;
  P: PChar;
  C, L, S, E: NChar;
  F: Bool;
  G: PStringSegmentNCharUPS;
begin
  Result := nil;
  Create<TStringSegmentNCharUPS>(ResultList, Result, [loPacked]);
  Start(AValue, P, C, L);
  if P <> nil then
    repeat
      C := NextItem(P, C, L, ASeparator, S, E, F);
      if sstaoTrim in AOptions then
        Trim(P, S, E);
      if (sstaoExcludeEmpty in AOptions) and (S > E) then
        Continue;
      G := PStringSegmentNCharUPS(AddEmptyPointer<TStringSegmentNCharUPS>(ResultList));
      First<NChar, UPS>(G^, S);
      Count<NChar, UPS>(G^, E - S + 1);
    until not F;
end;

end.
