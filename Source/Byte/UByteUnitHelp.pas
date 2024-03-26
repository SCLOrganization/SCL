unit UByteUnitHelp;

{$I SCL.inc}

interface

uses
  UNumber, UString, UByteUnit;

type
  TByteUnitPower = 0..6;

function PowerToByteUnit(AValue: TByteUnitPower; ASystem: TByteUnitSystem): TByteUnit; inline; overload;
function SuggestBinaryUnit(AValue: Siz; ASystem: TByteUnitSystem): TByteUnit; inline; overload;
function SuggestBinaryUnit(AValue: Siz): TByteUnit; inline; overload;
function FromByteUnit(AUnit: TByteUnit): Siz; inline; overload;
function FromByteUnit(AValue: Siz; AUnit: TByteUnit): Siz; inline; overload;
function ToByteUnit(AValue: Siz; AUnit: TByteUnit): Siz; inline; overload;
function ToByteString(AValue: Siz; AUnit: TByteUnit): Str; inline; overload;
function ToByteString(AValue: Siz): Str; inline; overload;
function ToFractionalByteString(AValue: Siz; ASystem: TByteUnitSystem): Str; inline; overload;
function ToFractionalByteString(AValue: Siz): Str; inline; overload;

implementation

uses
  UNumberHelp, UStringHelp;

function PowerToByteUnit(AValue: TByteUnitPower; ASystem: TByteUnitSystem): TByteUnit;
const
  Units: array [TByteUnitSystem] of array[TByteUnitPower] of TByteUnit = (
    (buB, buKilo, buMega, buGiga, buTera, buPeta, buExa),
    (buB, buKibi, buMebi, buGibi, buTebi, buPebi, buExbi));
begin
  Result := Units[ASystem][AValue];
end;

function SuggestBinaryUnit(AValue: Siz; ASystem: TByteUnitSystem): TByteUnit;
var
  BC: U8;
begin
  BC := BitCount(AValue);
  if BC > 0 then
    Result := PowerToByteUnit((BC - 1) div 10, ASystem)
  else
    Result := buB;
end;

function SuggestBinaryUnit(AValue: Siz): TByteUnit;
begin
  Result := SuggestBinaryUnit(AValue, busBinary);
end;

function FromByteUnit(AUnit: TByteUnit): Siz;
begin
  if AUnit in [buKibi.. buExbi] then
    Result := 1 shl ((Ord(AUnit) - Ord(buKibi) + 1) * 10)
  else if AUnit in [buKilo.. buExa] then
    Result := Exponent10((Ord(AUnit) - Ord(buKilo) + 1) * 3)
  else
    Result := 1;
end;

function FromByteUnit(AValue: Siz; AUnit: TByteUnit): Siz;
begin
  Result := AValue * FromByteUnit(AUnit);
end;

function ToByteUnit(AValue: Siz; AUnit: TByteUnit): Siz;
begin
  Result := AValue div FromByteUnit(AUnit);
end;

function ToByteString(AValue: Siz; AUnit: TByteUnit): Str;
begin
  Result := ToStr(ToByteUnit(AValue, AUnit)) + ' ' + ByteUnits[AUnit];
end;

function ToByteString(AValue: Siz): Str;
begin
  Result := ToByteString(AValue, SuggestBinaryUnit(AValue));
end;

function ToFractionalByteString(AValue: Siz; ASystem: TByteUnitSystem): Str;
var
  U: TByteUnit;
  V, Q, R: UPS;
begin
  U := SuggestBinaryUnit(AValue, ASystem);
  V := FromByteUnit(U);
  Divide<UPS>(AValue, V, Q, R);
  Q := AValue div V;
  Result := ToStr(Q);
  R := (R * 10) div V;
  Result += '.' + ToStr(R);
  Result += ' ' + ByteUnits[U];
end;

function ToFractionalByteString(AValue: Siz): Str;
begin
  Result := ToFractionalByteString(AValue, busBinary);
end;

end.
