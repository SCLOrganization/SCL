unit UWindowsLibC;

{$I SCL.inc}

interface

uses
  UNumber, UString;

const
  LibC = 'msvcrt.dll';

type
  int = I32;
  size_t = Siz;
  unsigned = U32;
  Punsigned = ^unsigned;
  __time64_t = I64;
  P__time64_t = ^__time64_t;
  uintptr_t = UPS;

  time_t = packed record
    tm_sec: int;
    tm_min: int;
    tm_hour: int;
    tm_mday: int;
    tm_mon: int;
    tm_year: int;
    tm_wday: int;
    tm_yday: int;
    tm_isdst: int;
    __tm_gmtoff: int;
    __tm_zone: PChar;
  end;

function memcmp(buffer1, buffer2: PByte; count: size_t): int; cdecl; external LibC;
function memchr(buffer: Ptr; c: int; count: size_t): Ptr; cdecl; external LibC;
function strcspn(str, strCharSet: PChar): int; cdecl; external LibC;
function strspn(str, strCharSet: PChar): int; cdecl; external LibC;
function strncmp(string1, string2: PChar; count: size_t): int; cdecl; external LibC;
function strcat(strDestination, strSource: PChar): PChar; cdecl; external LibC;
function strcpy(strDestination, strSource: PChar): PChar; cdecl; external LibC;
function strtod(strSource: PChar; endptr: PPChar): F64; cdecl; external LibC;
function strchr(str: Ptr; c: int): Ptr; cdecl; external LibC;
function _beginthreadex(security: Ptr; stack_size: unsigned; start: Ptr; arglist: Ptr; initflag: unsigned;
  threadid: Punsigned): uintptr_t; cdecl; external LibC;
procedure _endthreadex(retval: unsigned); cdecl; external LibC;
function _localtime64(sourceTime: P__time64_t): Ptr; cdecl; external LibC;
function _gmtime64(sourceTime: P__time64_t): Ptr; cdecl; external LibC;
function strftime(strDest: PChar; maxsize: size_t; format: PChar; timeptr: Ptr): size_t; cdecl; external LibC;

implementation

//Help static linking other C libraries

uses
  UMemory, UStringCount, UStringCompare, UException;

{$IfDef Windows}
{$LinkLib libkernel32.a}
{$EndIf}

function mallocMethod(size: U32): Ptr; cdecl; public Name 'malloc';
begin
  Result := Allocate(size);
end;

function callocMethod(n, size: size_t): Ptr; cdecl; public Name 'calloc';
begin
  Result := UMemory.AllocateInitialized(size * n);
end;

procedure freeMethod(P: Ptr); cdecl; public Name 'free';
begin
  UMemory.Deallocate(P);
end;

function reallocMethod(P: Ptr; size: int): Ptr; cdecl; public Name 'realloc';
begin
  Result := UMemory.Reallocate(P, size);
end;

function memcpyMethod(dest, src: Ptr; count: size_t): Ptr; cdecl; public Name 'memcpy';
begin
  UMemory.Move(src, dest, count);
  Result := dest;
end;

function memsetMethod(dest: Ptr; val: int; count: size_t): Ptr; cdecl; public Name 'memset';
begin
  UMemory.Fill(dest, count, U8(val));
  Result := dest;
end;

function memmoveMethod(dest, src: Ptr; count: size_t): Ptr; cdecl; public Name 'memmove';
begin
  UMemory.Move(src, dest, count);
  Result := dest;
end;

function memcmpMethod(buffer1, buffer2: PByte; count: size_t): int; cdecl; public Name 'memcmp';
begin
  Result := memcmp(buffer1, buffer2, count);
end;

function memchrMethod(buffer: Ptr; c: int; count: size_t): Ptr; cdecl; public Name 'memchr';
begin
  Result := memchr(buffer, c, count);
end;

function strlenMethod(p: PChar): int; cdecl; public Name 'strlen';
begin
  Result := UStringCount.Count(p);
end;

function strcmpMethod(p1, p2: PChar): int; cdecl; public Name 'strcmp';
begin
  Result := UStringCompare.Compare(p1, p2);
end;

function strcspnMethod(str, strCharSet: PChar): int; cdecl; public Name 'strcspn';
begin
  Result := strcspn(str, strCharSet);
end;

function strspnMethod(str, strCharSet: PChar): int; cdecl; public Name 'strspn';
begin
  Result := strspn(str, strCharSet);
end;

function strncmpMethod(string1, string2: PChar; count: size_t): int; cdecl; public Name 'strncmp';
begin
  Result := strncmp(string1, string2, count);
end;

function strcatMethod(strDestination, strSource: PChar): PChar; cdecl; public Name 'strcat';
begin
  Result := strcat(strDestination, strSource);
end;

function strcpyMethod(strDestination, strSource: PChar): PChar; cdecl; public Name 'strcpy';
begin
  Result := strcpy(strDestination, strSource);
end;

function strtodMethod(strSource: PChar; endptr: PPChar): Double; cdecl; public Name '__strtod';
begin
  Result := strtod(strSource, endptr);
end;

function strchrMethod(str: Ptr; c: int): Ptr; cdecl; public Name 'strchr';
begin
  Result := strchr(str, c);
end;

//Returns a pointer to the last occurrence of c in the string str.
function strrchrMethod(s: PChar; c: Char): PChar; cdecl; public Name 'strrchr';
begin
  Result := nil;
  if (s <> nil) and (s^ <> #0) then
    repeat
      if s^ = c then
        Result := s;
      s += 1;
    until s^ = #0;
end;

//From mORMot
procedure ___chkstk_msMethod; assembler; nostackframe; public Name '___chkstk_ms';
asm
         PUSH    RCX
         PUSH    RAX
         CMP     RAX, 4096
         LEA     RCX, qword ptr [RSP+18H]
         JC      @@002
         @@001:
         SUB     RCX, 4096
         OR      qword ptr [RCX], 00H
         SUB     RAX, 4096
         CMP     RAX, 4096
         JA      @@001
         @@002:
         SUB     RCX, RAX
         OR      qword ptr [RCX], 00H
         POP     RAX
         POP     RCX
end;

function beginthreadexMethod(security: Ptr; stack_size: unsigned; start: Ptr; arglist: Ptr;
  initflag: unsigned; threadid: Punsigned): uintptr_t; cdecl;
begin
  Result := _beginthreadex(security, stack_size, start, arglist, initflag, threadid);
end;

procedure endthreadexMethod(exitcode: unsigned); cdecl;
begin
  _endthreadex(exitcode);
end;

function localtime64Method(sourceTime: P__time64_t): pointer; cdecl;
begin
  Result := _localtime64(sourceTime);
end;

function gmtime64Method(sourceTime: P__time64_t): pointer; cdecl;
begin
  Result := _gmtime64(sourceTime);
end;

function strftimeMethod(strDest: PChar; maxsize: size_t; format: PChar; timeptr: Ptr): size_t;
  cdecl; public Name 'strftime';
begin
  Result := strftime(strDest, maxsize, format, timeptr);
end;

var
  __imp__beginthreadex: Ptr public Name '__imp__beginthreadex';
  __imp__endthreadex: Ptr public Name '__imp__endthreadex';
  __imp__localtime64: Ptr public Name '__imp__localtime64';
  __imp__gmtime64: Ptr public Name '__imp__gmtime64';

initialization
  __imp__beginthreadex := @beginthreadexMethod;
  __imp__endthreadex := @endthreadexMethod;
  __imp__localtime64 := @localtime64Method;
  __imp__gmtime64 := @gmtime64Method;
end.
