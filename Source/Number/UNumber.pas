unit UNumber;

{$I SCL.inc}

interface

type
  Bool = type Boolean;
  I8 = type Shortint;
  I16 = type Smallint;
  I32 = type Longint;
  I64 = type Int64;
  U8 = type Byte;
  U16 = type Word;
  U32 = type DWord;
  U64 = type QWord;
  U128 = record
  private
    {%H-}L, {%H-}H: U64;
  end;
  F32 = type Single;
  F64 = type Double;
  Ptr = type Pointer;
  IPS = type I64;
  UPS = type U64;
  FPS = type F64;
  Ind = type IPS;
  Siz = type UPS;
  THandle = type U64;

  PBool = ^Bool;
  PI8 = ^I8;
  PI16 = ^I16;
  PI32 = ^I32;
  PI64 = ^I64;
  PU8 = ^U8;
  PU16 = ^U16;
  PU32 = ^U32;
  PU64 = ^U64;
  PU128 = ^U128;
  PF32 = ^F32;
  PF64 = ^F64;
  PPtr = ^Ptr;
  PIPS = ^IPS;
  PUPS = ^UPS;
  PFPS = ^FPS;
  PInd = ^Ind;
  PSiz = ^Siz;
  PHandle = ^THandle;

const
  NaN = 0.0 / 0.0;
  Infinity = 1.0 / 0.0;
  NegInfinity = -1.0 / 0.0;
  InvalidIndex = -1;
  InvalidHandle = THandle(-1);

implementation

end.
