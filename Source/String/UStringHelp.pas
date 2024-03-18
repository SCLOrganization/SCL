unit UStringHelp;

{$I SCL.inc}

interface

uses
  UNumber, UNumberHelp, UArray, UString, UExceptionHelp;

type
  TKind = (kUnknownString, kRStr, kStr);

  TCharArray = TArray<Char>;
  TChars = set of Char;
  TStrArray = TArray<Str>;
  TRStrArray = TArray<RStr>;
  TSStrArray = TArray<SStr>;

  TPCharArray = TArray<PChar>;
  TPStrArray = TArray<PStr>;
  TPRStrArray = TArray<PRStr>;
  TPSStrArray = TArray<PSStr>;

  TNCharArray = TArray<NChar>;

  PCharArray = ^TCharArray;
  PChars = ^TChars;
  PStrArray = ^TStrArray;
  PRStrArray = ^TRStrArray;
  PSStrArray = ^TSStrArray;

  PPCharArray = ^PCharArray;
  PPChars = ^PChars;
  PPStrArray = ^PStrArray;
  PPRStrArray = ^PRStrArray;
  PPSStrArray = ^PSStrArray;

function Kind<T>: TKind; inline; overload;
function IsString<T>: Bool; inline; overload;

function Create<TString; TChar>(P: TChar; ALength: Siz): TString; inline; overload;
procedure Create(out AString: RStr; P: PChar; ALength: Siz); inline; overload;
function Create(P: PChar; ALength: Siz): RStr; inline; overload;
function Create(out AString: RStr; P: PChar; A, B: NChar): Bool; inline; overload;
function Create(P: PChar; A, B: NChar): RStr; inline; overload;

function ToStr(const AValue: Bool): Str; inline; overload;
function ToStr(const AValue: I64): Str; inline; overload;
function ToStr(const AValue: U64): Str; inline; overload;
function ToStr(const AValue: F64): Str; inline; overload;
function ToStr<T>(const AValue: T): Str; inline; overload;
function AsStr<T>(const AValue: T): Str; inline; overload;

function ToI64(const AStr: Str; out AI64: I64): Bool; inline; overload;
function ToU64(const AStr: Str; out AU64: U64): Bool; inline; overload;

procedure Replace(var AValue: RStr; AFrom, ATo: Char); inline; overload;
function Replaced(const AValue: RStr; AFrom, ATo: Char): RStr; inline; overload;

function Join<T>(const AValue: array of T; const AStart, AStarter, ASeparator, AFinisher, AFinish: Str): Str; overload;
function Join<T>(const AValue: array of T; const ASeparator: Str): Str; overload;

function StringOfChar(AValue: Char; ACount: Siz): Str; overload;

type
  TPadAlignment = (paLeft, paRight);

procedure Pad(var AValue: Str; ACount: Siz; AAlignment: TPadAlignment); inline; overload;
function Padded(const AValue: Str; ACount: Siz; AAlignment: TPadAlignment): Str; inline; overload;

implementation

uses
  UStringHandle, UMemory;

function Kind<T>: TKind;
begin
  Result := kUnknownString;
  {%H-}if TypeInfo(T) = TypeInfo(RStr) then
    {%H-}Result := kRStr
  else if TypeInfo(T) = TypeInfo(Str) then
    {%H-}Result := kStr
  //System types
  //TypeInfo does not work for these
  else //Todo: More
    {%H-}case GetTypeKind(T) of
      tkAnsiString: Result := kStr;
      else;
    end;
end;

function IsString<T>: Bool;
begin
  Result := Kind<T> <> kUnknownString;
end;

function Create<TString; TChar>(P: TChar; ALength: Siz): TString;
begin
  UString.Create<TString, TChar>(Result, P, ALength);
end;

procedure Create(out AString: RStr; P: PChar; ALength: Siz);
begin
  UString.Create<RStr, PChar>(AString, P, ALength);
end;

function Create(P: PChar; ALength: Siz): RStr;
begin
  Create(Result, P, ALength);
end;

function Create(out AString: RStr; P: PChar; A, B: NChar): Bool;
var
  L: NChar;
begin
  L := B - A + 1;
  Create(AString, P + A, L);
  Result := Length(AString) = L;
end;

function Create(P: PChar; A, B: NChar): RStr;
begin
  Create(Result, P + A, B - A + 1);
end;

//Todo: Move
function ToStr(const AValue: Bool): Str;
begin
  System.Str(AValue, Result);
end;

//Todo: Move
function ToStr(const AValue: I64): Str;
begin
  System.Str(AValue, Result);
end;

//Todo: Move
function ToStr(const AValue: U64): Str;
begin
  System.Str(AValue, Result);
end;

//Todo: Move
function ToStr(const AValue: F64): Str;
begin
  System.Str(AValue, Result);
end;

//Todo: Move
function ToStr<T>(const AValue: T): Str;
begin
  case UNumberHelp.Kind<T> of
    kBool: Result := ToStr(PBool(@AValue)^);
    kI8: Result := ToStr(PI8(@AValue)^);
    kI16: Result := ToStr(PI16(@AValue)^);
    kI32: Result := ToStr(PI32(@AValue)^);
    kI64: Result := ToStr(PI64(@AValue)^);
    kU8: Result := ToStr(PU8(@AValue)^);
    kU16: Result := ToStr(PU16(@AValue)^);
    kU32: Result := ToStr(PU32(@AValue)^);
    kU64: Result := ToStr(PU64(@AValue)^);
    kU128: RaiseNotSupportedType;
    kF32: Result := ToStr(PF32(@AValue)^);
    kF64: Result := ToStr(PF64(@AValue)^);
    kPtr: Result := ToStr({%H-}U64(PPtr(@AValue)^));
    kIPS: Result := ToStr(U64(PIPS(@AValue)^));
    kUPS: Result := ToStr(PUPS(@AValue)^);
    kiInd: Result := ToStr(PInd(@AValue)^);
    kSiz: Result := ToStr(PSiz(@AValue)^);
    kHandle: Result := ToStr(PHandle(@AValue)^);
    else
      RaiseNotSupportedType;
  end;
end;

//Todo: Move
function AsStr<T>(const AValue: T): Str;
begin
  if UNumberHelp.Kind<T> <> kUnknownNumber then
    Result := ToStr<T>(AValue)
  else
    case Kind<T> of
      kRStr: Result := PRStr(@AValue)^;
      kStr: Result := PStr(@AValue)^;
      else
        RaiseNotSupportedType;
    end;
end;

//Todo: Improve
function ToI64(const AStr: Str; out AI64: I64): Bool;
var
  Code: I32;
begin
  System.Val(AStr, AI64, Code);
  Result := Code = 0;
end;

//Todo: Improve
function ToU64(const AStr: Str; out AU64: U64): Bool;
var
  Code: I32;
begin
  System.Val(AStr, AU64, Code);
  Result := Code = 0;
end;

procedure Replace(var AValue: RStr; AFrom, ATo: Char);
var
  P: PChar;
  C, L: NChar;
begin
  Start(AValue, P, C, L);
  C := Next(P, C, L, AFrom);
  while C < L do
  begin
    P[C] := ATo;
    C := Next(P, C, L, AFrom);
  end;
end;

function Replaced(const AValue: RStr; AFrom, ATo: Char): RStr;
begin
  Result := AValue;
  UniqueString(Result);
  Replace(Result, AFrom, ATo);
end;

//Todo: Improve performance
function Join<T>(const AValue: array of T; const AStart, AStarter, ASeparator, AFinisher, AFinish: Str): Str;
var
  I: Ind;
begin
  Result := AStart;
  for I := Low(AValue) to High(AValue) do
  begin
    Result += AStarter + (AsStr<T>(AValue[I])) + AFinisher;
    if I <> High(AValue) then
      Result += ASeparator;
  end;
  Result += AFinish;
end;

function Join<T>(const AValue: array of T; const ASeparator: Str): Str;
begin
  Result := Join<T>(AValue, '', '', ASeparator, '', '');
end;

//Todo: Improve
function StringOfChar(AValue: Char; ACount: Siz): Str;
begin
  SetLength(Result, ACount);
  Fill(PU8(Result), ACount, U8(AValue));
end;

procedure Pad(var AValue: Str; ACount: Siz; AAlignment: TPadAlignment);
begin
  if Length(AValue) < ACount then
    case AAlignment of
      paLeft: AValue := StringOfChar(' ', ACount - Length(AValue)) + AValue;
      paRight: AValue := AValue + StringOfChar(' ', ACount - Length(AValue));
    end;
end;

function Padded(const AValue: Str; ACount: Siz; AAlignment: TPadAlignment): Str;
begin
  Result := AValue;
  Pad(Result, ACount, AAlignment);
end;

end.
