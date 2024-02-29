unit UStringHandle;

{$I SCL.inc}

interface

uses
  UNumber, UString;

procedure Start(const AValue: RStr; out P: PChar; out L: NChar); inline; overload;
procedure Start(const AValue: RStr; out P: PChar; out C, L: NChar); inline; overload;
procedure StartFromLast(const AValue: RStr; out P: PChar; out C, L: NChar); inline; overload;

function Next(P: PChar; C, L: NChar; AValue: Char): NChar; inline; overload;
function Previous(P: PChar; C, L: NChar; AValue: Char): NChar; inline; overload;
function Previous(P: PChar; C, L: NChar; AValue1, AValue2: Char): NChar; inline; overload;

function NextNotWhiteSpace(P: PChar; C, L: NChar): NChar; inline; overload;
function PreviousNotWhiteSpace(P: PChar; C, L: NChar): NChar; inline; overload;

procedure Trim(const P: PChar; var AStart, AStop: NChar); inline; overload;

function NextItem(const P: PChar; C, L: NChar; ASeparator: Char; out AStart, AStop: NChar; out AFound: Bool): NChar;
  inline; overload;

implementation

procedure Start(const AValue: RStr; out P: PChar; out L: NChar);
begin
  P := First(AValue);
  L := Length(AValue);
end;

procedure Start(const AValue: RStr; out P: PChar; out C, L: NChar);
begin
  P := First(AValue);
  C := 0;
  L := Length(AValue);
end;

procedure StartFromLast(const AValue: RStr; out P: PChar; out C, L: NChar);
begin
  P := First(AValue);
  L := -1;
  C := Length(AValue) - 1;
end;

function Next(P: PChar; C, L: NChar; AValue: Char): NChar;
begin
  while (C < L) and (P[C] <> AValue) do
    C += 1;
  Result := C;
end;

function Previous(P: PChar; C, L: NChar; AValue: Char): NChar;
begin
  while (C > L) and (P[C] <> AValue) do
    C -= 1;
  Result := C;
end;

function Previous(P: PChar; C, L: NChar; AValue1, AValue2: Char): NChar;
begin
  while (C > L) and (not (P[C] in [AValue1, AValue2])) do
    C -= 1;
  Result := C;
end;

function NextNotWhiteSpace(P: PChar; C, L: NChar): NChar;
begin
  if (C < L) and (P[C] <= ' ') then
    repeat
      C += 1;
    until (C = L) or (P[C] > ' ');
  Result := C;
end;

function PreviousNotWhiteSpace(P: PChar; C, L: NChar): NChar;
begin
  if (C > L) and (P[C] <= ' ') then
    repeat
      C -= 1;
    until (C = L) or (P[C] > ' ');
  Result := C;
end;

procedure Trim(const P: PChar; var AStart, AStop: NChar);
begin
  AStart := NextNotWhiteSpace(P, AStart, AStop + 1);
  AStop := PreviousNotWhiteSpace(P, AStop, AStart - 1);
end;

function NextItem(const P: PChar; C, L: NChar; ASeparator: Char; out AStart, AStop: NChar; out AFound: Bool): NChar;
begin
  AStart := C;
  C := Next(P, C, L, ASeparator);
  AStop := C - 1;
  AFound := C < L;
  if AFound then
    C += 1;
  Result := C;
end;

end.
