unit UList;

{$I SCL.inc}

interface

uses
  UNumber, UArray, UMemory, UMemoryHelp;

type
  TListOption = (loOwned, loPacked);
  TListOptions = set of TListOption;

  TList<T> = record
    Data: ^TArray<T>;
    Count: UPS;
    Options: TListOptions;
    function GetItem(AIndex: Ind): T; inline;
    procedure SetItem(AIndex: Ind; const AValue: T); inline;
    class operator Initialize(var AList: TList<T>);
    class operator Finalize(var AList: TList<T>);
  type
    TListEnumerator = record
      FValue: Pointer;
      Position: Ind;
      function GetCurrent: T; inline;
      function MoveNext: Boolean; inline;
      property Current: T read GetCurrent;
    end;
  public
    function GetEnumerator: TListEnumerator;
    property Items[AIndex: Ind]: T read GetItem write SetItem; default;
  end;

procedure Create<T>(out AList: TList<T>; constref AData: TArray<T>; const AOptions: TListOptions); inline; overload;
procedure Create<T>(out AList: TList<T>; const AOptions: TListOptions); inline; overload;
procedure Create<T>(out AList: TList<T>); inline; overload;
procedure Destroy<T>(var AList: TList<T>); inline; overload;
procedure Data<T>(var AList: TList<T>; constref AData: TArray<T>); inline; overload;
function Data<T>(const AList: TList<T>): Ptr; inline; overload;
procedure Options<T>(var AList: TList<T>; const AOptions: TListOptions); inline; overload;
function Options<T>(const AList: TList<T>): TListOptions; inline; overload;
procedure Capacity<T>(var AList: TList<T>; const ACapacity: Siz); inline; overload;
function Capacity<T>(const AList: TList<T>): Siz; inline; overload;
procedure Count<T>(var AList: TList<T>; const ACount: Siz); inline; overload;
function Count<T>(const AList: TList<T>): Siz; inline; overload;
procedure Clear<T>(var AList: TList<T>); inline; overload;
procedure Move<T>(var AList: TList<T>; const ASource, ADestination: Ind; ACount: Siz); inline; overload;
procedure Pack<T>(var AList: TList<T>); inline; overload;
procedure Item<T>(var AList: TList<T>; const AIndex: Ind; const AItem: T); inline; overload;
function ItemPointer<T>(const AList: TList<T>; const AIndex: Ind): Ptr; inline; overload;
function Item<T>(const AList: TList<T>; const AIndex: Ind): T; inline; overload;
function Index<T>(const AList: TList<T>; const AItem: T): Ind; inline; overload;
procedure Items<T>(var AList: TList<T>; const AIndex: Ind; constref AItems: array of T); inline; overload;
function Items<T>(const AList: TList<T>; ALow, AHigh: Ind): TArray<T>; inline; overload;
function InsertEmpty<T>(var AList: TList<T>; AIndex: Ind): Ind; inline; overload;
function Insert<T>(var AList: TList<T>; AIndex: Ind; const AItem: T): Ind; inline; overload;
procedure InsertArray<T>(var AList: TList<T>; AIndex: Ind; const AItems: array of T); inline; overload;
function Add<T>(var AList: TList<T>; const AItem: T): Ind; overload;
procedure AddArray<T>(var AList: TList<T>; const AItems: array of T); inline; overload;
procedure Replace<T>(var AList: TList<T>; const AIndex: Ind; const AItem: T); inline; overload;
procedure ReplaceArray<T>(var AList: TList<T>; const AIndex: Ind; const AItems: array of T); inline; overload;
procedure Delete<T>(var AList: TList<T>; const AIndex: Ind); inline; overload;
procedure Delete<T>(var AList: TList<T>; const ALow, AHigh: Ind); inline; overload;
function First<T>(const AList: TList<T>): Ind; inline; overload;
function Last<T>(const AList: TList<T>): Ind; inline; overload;

implementation

uses
  UArrayHelp;

function TList<T>.GetEnumerator: TListEnumerator;
begin
  Result.Position := InvalidIndex;
  Result.FValue := @Self;
end;

procedure Create<T>(out AList: TList<T>; constref AData: TArray<T>; const AOptions: TListOptions);
begin
  Create<T>(AList, AOptions);
  Data<T>(AList, AData);
end;

procedure Create<T>(out AList: TList<T>; const AOptions: TListOptions);
begin
  AList.Count := 0;
  Options<T>(AList, AOptions);
end;

procedure Create<T>(out AList: TList<T>);
begin
  AList.Count := 0;
end;

procedure Destroy<T>(var AList: TList<T>);
begin
  Finalize(AList);
end;

procedure Data<T>(var AList: TList<T>; constref AData: TArray<T>);
begin
  with AList do
  begin
    Data := @AData;
    Count := Capacity<T>(AList);
  end;
end;

function Data<T>(const AList: TList<T>): Ptr;
begin
  Result := AList.Data;
end;

procedure Options<T>(var AList: TList<T>; const AOptions: TListOptions);
begin
  AList.Options := AOptions;
end;

function Options<T>(const AList: TList<T>): TListOptions;
begin
  Result := AList.Options;
end;

procedure Capacity<T>(var AList: TList<T>; const ACapacity: Siz);
begin
  with AList do
  begin
    if Data = nil then
    begin
      Options += [loOwned];
      New(Data);
    end;
    SetLength(Data^, ACapacity);
    if ACapacity < Count then
      Count := ACapacity;
  end;
end;

function Capacity<T>(const AList: TList<T>): Siz;
begin
  with AList do
    if Data = nil then
      Result := 0
    else
      Result := Length(Data^);
end;

procedure Count<T>(var AList: TList<T>; const ACount: Siz);
var
  C: Siz;
begin
  if Capacity<T>(AList) < ACount then
  begin
    //Compiler issue: Does not inline unless a variant is used
    C := SuggestNextExpand(ACount);
    Capacity<T>(AList, C);
  end;
  AList.Count := ACount;
end;

function Count<T>(const AList: TList<T>): Siz;
begin
  Result := AList.Count;
end;

procedure Clear<T>(var AList: TList<T>);
begin
  Capacity<T>(AList, 0);
end;

procedure Move<T>(var AList: TList<T>; const ASource, ADestination: Ind; ACount: Siz);
begin
  UMemoryHelp.Move<T>(AList.Data^[ASource], AList.Data^[ADestination], ACount);
end;

procedure Pack<T>(var AList: TList<T>);
begin
  Capacity<T>(AList, Count<T>(AList));
end;

//Todo: Check more managed types
procedure Item<T>(var AList: TList<T>; const AIndex: Ind; const AItem: T);
begin
  AList.Data^[AIndex] := AItem;
end;

function ItemPointer<T>(const AList: TList<T>; const AIndex: Ind): Ptr;
begin
  Result := @AList.Data^[AIndex];
end;

function Item<T>(const AList: TList<T>; const AIndex: Ind): T;
begin
  Result := AList.Data^[AIndex];
end;

function Index<T>(const AList: TList<T>; const AItem: T): Ind;
var
  C, I: Ind;
begin
  C := Count<T>(AList);
  for I := 0 to C - 1 do
    if Item<T>(AList, I) = AItem then
      Exit(I);
  Result := InvalidIndex;
end;

procedure Items<T>(var AList: TList<T>; const AIndex: Ind; constref AItems: array of T);
begin
  Move<T>(AItems[0], AList.Data^[AIndex], Length(AItems));
end;

function Items<T>(const AList: TList<T>; ALow, AHigh: Ind): TArray<T>;
var
  I: Ind;
begin
  Result := nil;
  I := Count<T>(AList);
  if AHigh >= I then
    AHigh := I - 1;
  SetLength(Result, AHigh - ALow + 1);
  Move<T>(AList.Data^[ALow], Result[0], Length(Result));
end;

//Todo: Check more managed types
function InsertEmpty<T>(var AList: TList<T>; AIndex: Ind): Ind;
var
  I: Ind;
begin
  I := Count<T>(AList);
  Count<T>(AList, I + 1);
  if AIndex >= I then
    AIndex := I
  else
  begin
    //Add an empty space
    Move<T>(AList.Data^[AIndex], AList.Data^[AIndex + 1], I - AIndex);
    Fill(PU8(@AList.Data^[AIndex]), SizeOf(T), 0);
  end;
  Result := AIndex;
end;

function Insert<T>(var AList: TList<T>; AIndex: Ind; const AItem: T): Ind;
begin
  Result := InsertEmpty<T>(AList, AIndex);
  Item<T>(AList, Result, AItem);
end;

//Compiler issue: Does not allow explicit specialization
procedure InsertArray<T>(var AList: TList<T>; AIndex: Ind; const AItems: array of T);
var
  I: Ind;
begin
  I := Count<T>(AList);
  Count<T>(AList, I + Length(AItems));
  if AIndex >= I then
    AIndex := I
  else
    Move<T>(AList, AIndex, AIndex + Length(AItems), I - AIndex);
  Items<T>(AList, AIndex, AItems);
end;

//Compiler issue: Can not Inline
function Add<T>(var AList: TList<T>; const AItem: T): Ind;
begin
  Result := Insert<T>(AList, Count<T>(AList), AItem);
end;

//Compiler issue: Does not allow explicit specialization
procedure AddArray<T>(var AList: TList<T>; const AItems: array of T);
begin
  InsertArray<T>(AList, Count<T>(AList), AItems);
end;

//Todo: Check more managed types
procedure Replace<T>(var AList: TList<T>; const AIndex: Ind; const AItem: T);
var
  I: Ind;
begin
  I := Count<T>(AList);
  if AIndex >= I then
    Count<T>(AList, AIndex + 1);
  Item<T>(AList, AIndex, AItem);
end;

procedure ReplaceArray<T>(var AList: TList<T>; const AIndex: Ind; const AItems: array of T);
var
  I: Ind;
begin
  I := Count<T>(AList);
  if AIndex + Length(AItems) >= I then
    Count<T>(AList, AIndex + Length(AItems));
  Items<T>(AList, AIndex, AItems);
end;

procedure Delete<T>(var AList: TList<T>; const AIndex: Ind);
var
  I, C: Ind;
begin
  I := Count<T>(AList);
  C := Capacity<T>(AList);
  Move<T>(AList, AIndex + 1, AIndex, C - AIndex - 1);
  Count<T>(AList, I - 1);
end;

procedure Delete<T>(var AList: TList<T>; const ALow, AHigh: Ind);
var
  I, C: Ind;
begin
  I := Count<T>(AList);
  C := Capacity<T>(AList);
  Move<T>(AList, AHigh + 1, ALow, C - AHigh - 1);
  Count<T>(AList, I - AHigh - ALow + 1);
end;

function First<T>(const AList: TList<T>): Ind;
begin
  Result := 0;
end;

function Last<T>(const AList: TList<T>): Ind;
begin
  Result := Count<T>(AList);
  Result -= 1;
end;

function TList<T>.TListEnumerator.GetCurrent: T;
begin
  Result := Item<T>(TList<T>(FValue^), Position);
end;

function TList<T>.TListEnumerator.MoveNext: Boolean;
var
  C: Ind;
begin
  Position := Position + 1;
  C := TList<T>(FValue^).Count;
  Result := Position < C;
end;

class operator TList<T>.Initialize(var AList: TList<T>);
begin
  AList := Default(TList<T>);
end;

function TList<T>.GetItem(AIndex: Ind): T;
begin
  Result := Item<T>(Self, AIndex);
end;

procedure TList<T>.SetItem(AIndex: Ind; const AValue: T);
begin
  Item<T>(Self, AIndex, AValue);
end;

class operator TList<T>.Finalize(var AList: TList<T>);
begin
  with AList do
    if Data <> nil then
      if loOwned in Options then
        Dispose(Data)
      else
      if loPacked in Options then
        Pack<T>(AList);
end;

end.
