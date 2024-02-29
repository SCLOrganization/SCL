unit UStringCase;

{$I SCL.inc}

interface

uses
  UNumber, UString;

function ToLowerCase(AValue: Char): Char; inline; overload;
function ToLowerCase(const AValue: Str): Str; inline; overload;
procedure LowerCase(var AValue: Str); inline; overload;
function ToUpperCase(AValue: Char): Char; inline; overload;
function ToUpperCase(const AValue: Str): Str; inline; overload;
procedure UpperCase(var AValue: Str); inline; overload;

implementation

function ToLowerCase(AValue: Char): Char;
begin
  if AValue in ['A' .. 'Z'] then
    Result := Chr(Ord(AValue) - Ord('A') + Ord('a'))
  else
    Result := AValue;
end;

function ToLowerCase(const AValue: Str): Str;
var
  I: Ind;
begin
  SetLength(Result{%H-}, Length(AValue));
  for I := 1 to Count(AValue) do
    Result[I] := ToLowerCase(AValue[I]);
end;

procedure LowerCase(var AValue: Str);
var
  I: Ind;
begin
  for I := 1 to Count(AValue) do
    AValue[I] := ToLowerCase(AValue[I]);
end;

function ToUpperCase(AValue: Char): Char;
begin
  if AValue in ['a' .. 'z'] then
    Result := Chr(Ord(AValue) - Ord('a') + Ord('A'))
  else
    Result := AValue;
end;

function ToUpperCase(const AValue: Str): Str;
var
  I: Ind;
begin
  SetLength(Result{%H-}, Length(AValue));
  for I := 1 to Count(AValue) do
    Result[I] := ToUpperCase(AValue[I]);
end;

procedure UpperCase(var AValue: Str);
var
  I: Ind;
begin
  for I := 1 to Count(AValue) do
    AValue[I] := ToUpperCase(AValue[I]);
end;

end.
