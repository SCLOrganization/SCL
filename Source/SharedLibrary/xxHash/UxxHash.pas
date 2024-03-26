unit UxxHash;

{$I SCL.inc}

interface

uses
  UNumber, UString;

type
  int = I32;
  Pint = ^int;
  unsigned = U32;
  size_t = U64;
  unsignedlonglong = U64;

  XXH32_hash_t = U32;
  XXH64_hash_t = U64;

function XXH_versionNumber: unsigned; cdecl; external;
function XXH_versionString: PChar; cdecl; external;
function XXH32(input: Ptr; length: size_t; seed: XXH32_hash_t): XXH32_hash_t; cdecl; external;
function XXH64(input: Ptr; length: size_t; seed: XXH64_hash_t): XXH64_hash_t; cdecl; external;
function XXH3_64bits_withSeed(input: Ptr; length: size_t; seed: XXH64_hash_t): XXH64_hash_t; cdecl; external;
function XXH3_64bits(input: Ptr; length: size_t): XXH64_hash_t; cdecl; external;

implementation

end.
