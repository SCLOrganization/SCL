unit UMemory;

{$I SCL.inc}

interface

uses
  UNumber;

function Allocate(ACount: Siz): Ptr; inline; overload;
function AllocateInitialized(ACount: Siz): Ptr; inline; overload;
procedure Deallocate(AData: Ptr); inline; overload;
function Reallocate(AData: Ptr; ACount: Siz): Ptr; inline; overload;
function Size(AData: Ptr): Siz; inline; overload;
procedure Move(ASource, ADestination: PU8; ACount: Siz); inline; overload;
procedure Move(const ASource; var ADestination; ACount: Siz); deprecated; inline; overload;
procedure Fill(AData: Ptr; ACount: Siz; AValue: U8); inline; overload;

implementation

//Allocate not initialized memory
function Allocate(ACount: Siz): Ptr;
begin
  Result := System.GetMem(ACount);
end;

function AllocateInitialized(ACount: Siz): Ptr;
begin
  Result := System.AllocMem(ACount);
end;

procedure Deallocate(AData: Ptr);
begin
  System.Freemem(AData);
end;

//If Count is bigger, reallocate the old data, and allocate not initialized memory
//If not, truncate
//Always use the result as the new location
function Reallocate(AData: Ptr; ACount: Siz): Ptr;
begin
  Result := System.ReAllocMem(AData, ACount);
end;

//Must not be nil
function Size(AData: Ptr): Siz;
begin
  Result := System.MemSize(AData);
end;

procedure Move(ASource, ADestination: PU8; ACount: Siz);
begin
  System.Move(ASource^, ADestination^, ACount);
end;

//Prevent direct calling the system unit, but it should not be used
procedure Move(const ASource; var ADestination; ACount: Siz);
begin
  Move(@ASource, @ADestination, ACount);
end;

procedure Fill(AData: Ptr; ACount: Siz; AValue: U8);
begin
  System.FillByte(AData^, ACount, AValue);
end;

end.
