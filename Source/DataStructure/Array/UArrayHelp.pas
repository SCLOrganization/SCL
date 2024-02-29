unit UArrayHelp;

{$I SCL.inc}

interface

uses
  UNumber, UArray;

procedure Delete<T>(var AArray: TArray<T>; AIndex: Ind); inline; overload;

function SuggestNextExpand(const ANeeded: Siz): Siz; inline; overload;

procedure Reverse<T>(var AArray: array of T); inline; overload;

procedure Sort<T>(var AArray: array of T; ADescending: Bool); inline; overload;
procedure Sort<T>(var AArray: array of T); inline; overload;

type
  TEnumArray<TEnum; T> = array[TEnum] of T;

function Find<TEnum; T>(const AArray: TEnumArray<TEnum, T>; const AItem: T; out AEnum: TEnum): Bool; inline; overload;

implementation

uses
  UMemorySwap, UArraySort;

procedure Delete<T>(var AArray: TArray<T>; AIndex: Ind);
begin
  Delete<T>(AArray, AIndex, 1);
end;

function SuggestNextExpand(const ANeeded: Siz): Siz;
begin
  Result := ANeeded;
  if Result < 128 shl 20 then
    if Result < 8 shl 20 then
      if Result <= 128 then
        if Result > 8 then
          Result += 16 //Small
        else
          Result += 4 //Tiny
      else
        Result += Result shr 2 //Big: More or equal to 128, increase 1/4 of the size
    else
      Result += Result shr 3 //Large: More than 8M, increase 1/8 of the size
  else
    Result += 16 shl 20; //Huge: More than 128M, increase 16M
end;

//Todo: Improve Speed
procedure Reverse<T>(var AArray: array of T);
var
  L, H: Ind;
begin
  L := Low(AArray);
  H := High(AArray);
  while L < H do
  begin
    Swap<T>(AArray[L], AArray[H]);
    L += 1;
    H -= 1;
  end;
end;

procedure Sort<T>(var AArray: array of T; ADescending: Bool);
begin
  if Length(AArray) = 0 then
    Exit;
  QuickSortMiddlePivot<T>(AArray);
  if ADescending then
    Reverse<T>(AArray);
end;

procedure Sort<T>(var AArray: array of T);
begin
  Sort<T>(AArray, False);
end;

function Find<TEnum; T>(const AArray: TEnumArray<TEnum, T>; const AItem: T; out AEnum: TEnum): Bool;
var
  E: TEnum;
begin
  for E := Low(TEnum) to High(TEnum) do
    if AArray[E] = AItem then
    begin
      AEnum := E;
      Exit(True);
    end;
  Result := False;
end;

end.
