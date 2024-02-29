unit UMemoryHelp;

{$I SCL.inc}

interface

uses
  UNumber, UString, UMemory;

procedure Move<T>(constref ASource: T; var ADestination: T; ACount: Siz); inline; overload;

function Copy(AData: Ptr; ACount: Siz): Ptr; inline; overload;
function Copy(AData: Ptr): Ptr; inline; overload;

function Read<T>(ASource: PU8; APosition: Siz): T; inline; overload;
function ReadString<T>(ASource: PU8; APosition: Siz; ALength: Siz): T; inline; overload;

procedure Write<T>(ADestination: PU8; APosition: Siz; constref AValue: T); inline; overload;
procedure WriteString(ADestination: PU8; APosition: Siz; const AValue: RStr; AWithZeroEnding: Bool); overload;

implementation

procedure Move<T>(constref ASource: T; var ADestination: T; ACount: Siz);
begin
  Move(PU8(@ASource), PU8(@ADestination), ACount * SizeOf(T));
end;

function Copy(AData: Ptr; ACount: Siz): Ptr;
begin
  Result := Allocate(ACount);
  if Result = nil then
    Exit;
  Move(AData, Result, ACount);
end;

function Copy(AData: Ptr): Ptr;
begin
  Result := Copy(AData, Size(AData));
end;

function Read<T>(ASource: PU8; APosition: Siz): T;
begin
  UMemory.Move(ASource + APosition, PU8(@Result), SizeOf(T));
end;

function ReadString<T>(ASource: PU8; APosition: Siz; ALength: Siz): T;
begin
  SetLength(Result{%H-}, ALength);
  UMemory.Move(ASource + APosition, PU8(@Result[1]), Length(Result));
end;

procedure Write<T>(ADestination: PU8; APosition: Siz; constref AValue: T);
begin
  UMemory.Move(PU8(@AValue), ADestination + APosition, SizeOf(T));
end;

procedure WriteString(ADestination: PU8; APosition: Siz; const AValue: RStr; AWithZeroEnding: Bool);
var
  P: PU8;
begin
  P := PU8(AValue); //Compiler Issue: Helps Inline
  UMemory.Move(P, ADestination + APosition, Length(AValue));
  if AWithZeroEnding then
    ADestination[APosition + Length(AValue)] := 0;
end;

end.
