unit UStringSplitHelp;

{$I SCL.inc}

interface

uses
  UNumber, UString, UStringHelp, USegment, USegmentHelp, UStringSplit;

function SplitToStrArray(const AValue: RStr; ASeparator: Char; AOptions: TSplitStringToArrayOptions): TStrArray; overload;

implementation

function SplitToStrArray(const AValue: RStr; ASeparator: Char; AOptions: TSplitStringToArrayOptions): TStrArray;
begin
  Result := ToStrArray<NChar, UPS>(PChar(AValue), Split(AValue, ASeparator, AOptions));
end;

end.
