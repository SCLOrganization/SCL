unit UNumberHelp;

{$I SCL.inc}

interface

uses
  UNumber, UArray, UException, UExceptionHelp;

type
  TKind = (kUnknownNumber, kBool, kI8, kI16, kI32, kI64, kU8, kU16, kU32, kU64, kU128,
    kF32, kF64, kIPS, kPtr, kUPS, kiInd, kSiz, kHandle, kE8, kE16, kE32);

  TBoolArray = TArray<Bool>;
  TI8Array = TArray<I8>;
  TI16Array = TArray<I16>;
  TI32Array = TArray<I32>;
  TI64Array = TArray<I64>;
  TU8Array = TArray<U8>;
  TU16Array = TArray<U16>;
  TU32Array = TArray<U32>;
  TU64Array = TArray<U64>;
  TF32Array = TArray<F32>;
  TF64Array = TArray<F64>;
  TPtrArray = TArray<Ptr>;

  TPBoolArray = TArray<PBool>;
  TPI8Array = TArray<PI8>;
  TPI16Array = TArray<PI16>;
  TPI32Array = TArray<PI32>;
  TPI64Array = TArray<PI64>;
  TPU8Array = TArray<PU8>;
  TPU16Array = TArray<PU16>;
  TPU32Array = TArray<PU32>;
  TPU64Array = TArray<PU64>;
  TPF32Array = TArray<PF32>;
  TPF64Array = TArray<PF64>;
  TPPtrArray = TArray<PPtr>;

  PBoolArray = ^TBoolArray;
  PI8Array = ^TI8Array;
  PI16Array = ^TI16Array;
  PI32Array = ^TI32Array;
  PI64Array = ^TI64Array;
  PU8Array = ^TU8Array;
  PU16Array = ^TU16Array;
  PU32Array = ^TU32Array;
  PU64Array = ^TU64Array;
  PF32Array = ^TF32Array;
  PF64Array = ^TF64Array;
  PPtrArray = ^TPtrArray;

function Kind<T>: TKind; inline; overload;
function IsNumber<T>: Bool; inline; overload;
function IsPointer<T>: Bool; inline; overload;

type
  TU16Record = packed record
    case U8 of
      1: (U8s: array[0..1] of U8);
      2: (L, H: U8);
  end;

  TU32Record = packed record
    case U8 of
      1: (U8s: array[0..3] of U8);
      2: (U16s: array[0..1] of U16);
      3: (L, H: U16);
  end;

  TU64Record = packed record
    case U8 of
      0: (U8s: array[0..7] of U8);
      1: (U16s: array[0..3] of U16);
      2: (U32s: array[0..1] of U32);
      3: (L, H: U32);
  end;

  TU128Record = packed record
    case U8 of
      0: (U8s: array[0..15] of U8);
      1: (U16s: array[0..7] of U16);
      2: (U32s: array[0..3] of U32);
      3: (U64s: array[0..1] of U64);
      4: (L, H: U64);
  end;

function FromI64<T>(ASource: I64; out ADestination: T): Bool; inline;
function ToI64<T>(AValue: T): I64; inline; overload;
function ToU64(const ALow, AHigh: U32): U64; inline;
procedure FromU64(const AValue: U64; out ALow, AHigh: U32); inline;
function ToU128(const ALow, AHigh: U64): U128; inline;
procedure FromU128(const AValue: U128; out ALow, AHigh: U64); inline;

function ToBigEndian<T>(const AValue: T): T; inline;
function FromBigEndian<T>(const AValue: T): T; inline;
function ToLittleEndian<T>(const AValue: T): T; inline;
function FromLittleEndian<T>(const AValue: T): T; inline;

function Min(A, B: I64): I64; inline; overload;
function Max(A, B: I64): I64; inline; overload;
function Min(A, B, C: I64): I64; inline; overload;
function Max(A, B, C: I64): I64; inline; overload;
function Clamp(ANumber, AMin, AMax: I64): I64; inline; overload;
function DivCeil(A, B: I64): I64; inline; overload;
procedure Divide(const ADividend, ADivisor: UPS; out AQuotient, ARemainder: UPS); inline; overload;
function Condition<T>(ACondition: Bool; ATrueValue, AFalseValue: T): T; inline; overload;

function Truncate(AValue: FPS): IPS; inline; overload;
function Fraction(AValue: FPS): FPS; inline; overload;
function Round(AValue: FPS): IPS; inline; overload;
function Floor(AValue: FPS): IPS; inline; overload;
function Ceil(AValue: FPS): IPS; inline; overload;

type
  TExponent10 = 0..19;

function Exponent10(AExponent: TExponent10): UPS; inline; overload;

function BitCount(AValue: UPS): U8; inline; overload;

implementation

function Kind<T>: TKind;
begin
  Result := kUnknownNumber;
  {%H-}if TypeInfo(T) = TypeInfo(Bool) then
    {%H-}Result := kBool
  else {%H-}if TypeInfo(T) = TypeInfo(I8) then
    {%H-}Result := kI8
  else if TypeInfo(T) = TypeInfo(I16) then
    {%H-}Result := kI16
  else if TypeInfo(T) = TypeInfo(I32) then
    {%H-}Result := kI32
  else {%H-}if TypeInfo(T) = TypeInfo(I64) then
    {%H-}Result := kI64
  else {%H-}if TypeInfo(T) = TypeInfo(U8) then
    {%H-}Result := kU8
  else {%H-}if TypeInfo(T) = TypeInfo(U16) then
    {%H-}Result := kU16
  else {%H-}if TypeInfo(T) = TypeInfo(U32) then
    {%H-}Result := kU32
  else {%H-}if TypeInfo(T) = TypeInfo(U64) then
    {%H-}Result := kU64
  else if TypeInfo(T) = TypeInfo(U128) then
    {%H-}Result := kU128
  else if TypeInfo(T) = TypeInfo(F32) then
    {%H-}Result := kF32
  else if TypeInfo(T) = TypeInfo(F64) then
    {%H-}Result := kF64
  //System types
  //TypeInfo does not work for these
  else //Todo: More
    case GetTypeKind(T) of
      tkInteger: Result := kI32;
      tkInt64: Result := kI64;
      tkQWord: Result := kU64;
      tkEnumeration:
        case SizeOf(T) of
          1: Result := kE8;
          2: Result := kE16;
          4: Result := kE32;
          else
            Result := kUnknownNumber;
        end;
      tkPointer: Result := kPtr;
      else
        Result := kUnknownNumber;
    end;
end;

function IsNumber<T>: Bool;
begin
  Result := Kind<T> <> kUnknownNumber;
end;

function IsPointer<T>: Bool;
begin
  Result := (Kind<T>) = kPtr;
end;

function FromI64<T>(ASource: I64; out ADestination: T): Bool;
begin
  if GetTypeKind(T) = tkInt64 then
    {%H-}Result := True
  else {%H-}if GetTypeKind(T) = tkQWord then
    {%H-}Result := ASource >= 0
  else {%H-}if SizeOf(T) < SizeOf(I64) then //Can cast, like Enum types
    {%H-}Result := (ASource >= I64(Low(T))) and (ASource <= I64(High(T)))
  else
    {%H-}Result := False;
  if Result then
    ADestination := T(ASource)
  else
    ADestination := Default(T);
end;

function ToI64<T>(AValue: T): I64;
begin
  case Kind<T> of
    kBool: RaiseNotSupportedType;
    kI8: Result := PI8(@AValue)^;
    kI16: Result := PI16(@AValue)^;
    kI32: Result := PI32(@AValue)^;
    kI64: Result := PI64(@AValue)^;
    kU8: Result := PU8(@AValue)^;
    kU16: Result := PU16(@AValue)^;
    kU32: Result := PU32(@AValue)^;
    kU64: Result := PU64(@AValue)^;
    kU128: RaiseNotSupportedType;
    kF32: RaiseNotSupportedType;
    kF64: RaiseNotSupportedType;
    kPtr: RaiseNotSupportedType;
    kIPS: Result := U64(PIPS(@AValue)^);
    kUPS: Result := PUPS(@AValue)^;
    kiInd: Result := PInd(@AValue)^;
    kSiz: Result := PSiz(@AValue)^;
    kE8: Result := PU8(@AValue)^;
    kE16: Result := PU16(@AValue)^;
    kE32: Result := PU32(@AValue)^;
    kHandle: RaiseNotSupportedType;
    else
      RaiseNotSupportedType;
  end;
end;

function ToU64(const ALow, AHigh: U32): U64;
var
  V: TU64Record absolute Result;
begin
  V.L := ALow;
  V.H := AHigh;
end;

procedure FromU64(const AValue: U64; out ALow, AHigh: U32);
var
  V: TU64Record absolute AValue;
begin
  ALow := V.L;
  AHigh := V.H;
end;

function ToU128(const ALow, AHigh: U64): U128;
var
  V: TU128Record absolute Result;
begin
  V.L := ALow;
  V.H := AHigh;
end;

procedure FromU128(const AValue: U128; out ALow, AHigh: U64);
var
  V: TU128Record absolute AValue;
begin
  ALow := V.L;
  AHigh := V.H;
end;

function ToBigEndian<T>(const AValue: T): T;
begin
  Result := NtoBE(AValue);
end;

function FromBigEndian<T>(const AValue: T): T;
begin
  Result := BEtoN(AValue);
end;

function ToLittleEndian<T>(const AValue: T): T;
begin
  Result := NtoLE(AValue);
end;

function FromLittleEndian<T>(const AValue: T): T;
begin
  Result := LEtoN(AValue);
end;

function Min(A, B: I64): I64;
begin
  if A < B then
    Result := A
  else
    Result := B;
end;

function Max(A, B: I64): I64;
begin
  if A > B then
    Result := A
  else
    Result := B;
end;

function Min(A, B, C: I64): I64;
begin
  Result := Min(Min(A, B), C);
end;

function Max(A, B, C: I64): I64;
begin
  Result := Max(Max(A, B), C);
end;

function Clamp(ANumber, AMin, AMax: I64): I64;
begin
  Result := ANumber;
  if Result < AMin then
    Result := AMin
  else
  if Result > AMax then
    Result := AMax;
end;

function DivCeil(A, B: I64): I64;
begin
  Result := (A + B - 1) div B;
end;

procedure Divide(const ADividend, ADivisor: UPS; out AQuotient, ARemainder: UPS);
begin
  AQuotient := ADividend div ADivisor;
  ARemainder := ADividend - (AQuotient * ADivisor);
end;

function Condition<T>(ACondition: Bool; ATrueValue, AFalseValue: T): T;
begin
  if ACondition then
    Result := ATrueValue
  else
    Result := AFalseValue;
end;

function Truncate(AValue: FPS): IPS;
begin
  Result := System.Trunc(AValue);
end;

function Fraction(AValue: FPS): FPS;
begin
  Result := System.Frac(AValue);
end;

function Round(AValue: FPS): IPS;
begin
  Result := System.Round(AValue);
end;

function Floor(AValue: FPS): IPS;
begin
  Result := Truncate(AValue) - Ord(Fraction(AValue) < 0);
end;

function Ceil(AValue: FPS): IPS;
begin
  Result := Truncate(AValue) + Ord(Fraction(AValue) > 0);
end;

function Exponent10(AExponent: TExponent10): UPS;
const
  Powers: array[TExponent10] of UPS = (
    1, 10, 100,
    1_000, 10_000, 100_000,
    1_000_000, 10_000_000, 100_000_000,
    1_000_000_000, 10_000_000_000, 100_000_000_000,
    1_000_000_000_000, 10_000_000_000_000, 100_000_000_000_000,
    1_000_000_000_000_000, 10_000_000_000_000_000, 100_000_000_000_000_000,
    1_000_000_000_000_000_000, 10_000_000_000_000_000_000);
begin
  Result := Powers[AExponent];
end;

function BitCount(AValue: UPS): U8;
begin
  {$Push}
  {$RangeChecks-}
  Result := System.BsrQWord(AValue) + 1;
  {$Pop}
end;

end.
