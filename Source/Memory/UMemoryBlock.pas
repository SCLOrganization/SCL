unit UMemoryBlock;

{$I SCL.inc}

interface

uses
  UNumber, UMemory;

type
  TMemoryBlock = record
  private
    Data: Ptr;
    Size: Siz;
  end;
  PMemoryBlock = ^TMemoryBlock;

procedure Data(var AMemoryBlock: TMemoryBlock; AData: Ptr); inline; overload;
function Data(constref AMemoryBlock: TMemoryBlock): Ptr; inline; overload;
function Capacity(var AMemoryBlock: TMemoryBlock; ACapacity: Siz): Bool; inline; overload;
function Capacity(constref AMemoryBlock: TMemoryBlock): Siz; inline; overload;
procedure Size(var AMemoryBlock: TMemoryBlock; ASize: Siz); inline; overload;
function Size(constref AMemoryBlock: TMemoryBlock): Siz; inline; overload;

procedure Clear(var AMemoryBlock: TMemoryBlock); inline; overload;

implementation

procedure Data(var AMemoryBlock: TMemoryBlock; AData: Ptr);
begin
  AMemoryBlock.Data := AData;
end;

function Data(constref AMemoryBlock: TMemoryBlock): Ptr;
begin
  Result := AMemoryBlock.Data;
end;

function Capacity(var AMemoryBlock: TMemoryBlock; ACapacity: Siz): Bool;
begin
  if ACapacity <> 0 then
  begin
    AMemoryBlock.Data := Reallocate(AMemoryBlock.Data, ACapacity);
    Result := AMemoryBlock.Data <> nil;
  end
  else
  begin
    if AMemoryBlock.Data <> nil then
      Deallocate(AMemoryBlock.Data);
    Result := True;
  end;
end;

function Capacity(constref AMemoryBlock: TMemoryBlock): Siz;
begin
  if AMemoryBlock.Data <> nil then
    Result := Size(AMemoryBlock.Data)
  else
    Result := 0;
end;

procedure Size(var AMemoryBlock: TMemoryBlock; ASize: Siz);
begin
  AMemoryBlock.Size := ASize;
end;

function Size(constref AMemoryBlock: TMemoryBlock): Siz;
begin
  Result := AMemoryBlock.Size;
end;

procedure Clear(var AMemoryBlock: TMemoryBlock);
begin
  Capacity(AMemoryBlock, 0);
end;

end.
