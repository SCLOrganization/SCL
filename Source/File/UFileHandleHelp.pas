unit UFileHandleHelp;

{$I SCL.inc}

interface

uses
  UNumber, UString, UFile;

function SeekTo(const AHandler: TFileHandler; APosition: Siz): Bool; inline; overload;

function Read(const AHandler: TFileHandler; const AData: PU8; const ASize: Siz): Bool; overload;
function Read<T>(const AHandler: TFileHandler; var AData: T; ACount: Siz; ADone: PSiz): Bool; inline; overload;
function Read<T>(const AHandler: TFileHandler; out ADone: Bool): T; inline; overload;
function Read<T>(const AHandler: TFileHandler; APosition: Siz; out ADone: Bool): T; inline; overload;
function ReadMemory(const AHandler: TFileHandler; ASize: Siz; out ADone: Bool): Ptr; inline; overload;
function ReadMemory(const AHandler: TFileHandler; APosition: Siz; ASize: Siz; out ADone: Bool): Ptr; inline; overload;
function ReadString<T>(const AHandler: TFileHandler; ALength: Siz; out ADone: Bool): T; inline; overload;
function ReadString<T>(const AHandler: TFileHandler; APosition: Siz; ALength: Siz; out ADone: Bool): T; inline; overload;

function Read(const AFile: TFile; var AData: RStr): Bool; overload;
function Read(const AFile: TFile): RStr; overload;

function Write(const AHandler: TFileHandler; AData: PU8; ACount: Siz): Bool; inline; overload;
function Write<T>(const AHandler: TFileHandler; constref AData: T; ACount: Siz; ADone: PSiz): Bool; inline; overload;
function Write(const AFile: TFile; const AData: RStr): Bool; overload;

function View(const AFile: TFile; AOptions: TViewFileMapperOptions; out AHandler: TFileHandler;
  out AMapper: TFileMapper; out AViewer: TFileMapperViewer): Bool; overload;

implementation

uses
  UFileHelp, UMemory;

function SeekTo(const AHandler: TFileHandler; APosition: Siz): Bool;
var
  P: Siz;
begin
  Result := UFile.Seek(AHandler, APosition, sfoBegin, @P);
  Result := Result and (APosition = P);
end;

//Retry reading until done or error
function Read(const AHandler: TFileHandler; const AData: PU8; const ASize: Siz): Bool;
var
  D, C: Siz;
begin
  if ASize = 0 then
    Exit(True);
  C := 0;
  D := 0;
  while UFile.Read(AHandler, AData + C, ASize - C, @D) and (D <> 0) do
    C += D;
  Result := ASize = C;
end;

function Read<T>(const AHandler: TFileHandler; var AData: T; ACount: Siz; ADone: PSiz): Bool;
begin
  Result := Read(AHandler, PU8(@AData), ACount * SizeOf(T), ADone);
end;

function Read<T>(const AHandler: TFileHandler; out ADone: Bool): T;
var
  S: Siz;
begin
  ADone := Read(AHandler, PU8(@Result), SizeOf(T), @S);
  ADone := ADone and (S = SizeOf(T));
end;

function Read<T>(const AHandler: TFileHandler; APosition: Siz; out ADone: Bool): T;
begin
  ADone := SeekTo(AHandler, APosition);
  if not ADone then
  begin
    Result := Default(T);
    Exit;
  end;
  Result := Read<T>(AHandler, ADone);
end;

function ReadMemory(const AHandler: TFileHandler; ASize: Siz; out ADone: Bool): Ptr;
var
  S: Siz;
begin
  Result := Allocate(ASize);
  if Result = nil then
  begin
    ADone := False;
    Exit;
  end;
  ADone := Read(AHandler, PU8(Result), ASize, @S);
  ADone := ADone and (S = ASize);
  if not ADone then
    Deallocate(Result);
end;

function ReadMemory(const AHandler: TFileHandler; APosition: Siz; ASize: Siz; out ADone: Bool): Ptr;
begin
  ADone := SeekTo(AHandler, APosition);
  if not ADone then
    Exit(nil);
  Result := ReadMemory(AHandler, ASize, ADone);
end;

function ReadString<T>(const AHandler: TFileHandler; ALength: Siz; out ADone: Bool): T;
var
  S: Siz;
begin
  SetLength(Result{%H-}, ALength);
  ADone := Read(AHandler, PU8(@Result[1]), ALength, @S);
  ADone := ADone and (S = ALength);
end;

function ReadString<T>(const AHandler: TFileHandler; APosition: Siz; ALength: Siz; out ADone: Bool): T;
begin
  ADone := SeekTo(AHandler, APosition);
  if not ADone then
    Exit;
  Result := ReadString<T>(AHandler, ALength, ADone);
end;

function Read(const AFile: TFile; var AData: RStr): Bool;
var
  H: TFileHandler;
  S: UPS;
  B: PU8;
begin
  Result := False;
  if not Open(AFile, [ofoRead], H) then
    Exit;
  AData := '';
  try
    S := Size(H);
    if S = 0 then
      Exit(True);
    SetLength(AData, S);
    B := PU8(First(AData));
    Result := Read(H, B, S);
    if not Result then
      AData := '';
  finally
    Close(H);
  end;
end;

function Read(const AFile: TFile): RStr;
begin
  Result := '';
  Read(AFile, Result);
end;

//Retry writing until done or error
function Write(const AHandler: TFileHandler; AData: PU8; ACount: Siz): Bool;
var
  D: Siz;
begin
  Result := True;
  while ACount > 0 do
  begin
    Result := UFile.Write(AHandler, AData, ACount, @D);
    if not Result then
      Exit;
    AData += D;
    ACount -= D;
  end;
end;

function Write<T>(const AHandler: TFileHandler; constref AData: T; ACount: Siz; ADone: PSiz): Bool;
begin
  Result := Write(AHandler, PU8(@AData), ACount * SizeOf(T), ADone);
end;

function Write(const AFile: TFile; const AData: RStr): Bool;
var
  H: TFileHandler;
  D: UPS;
begin
  Result := False;
  if not Open(AFile, [ofoCreate, ofoRead, ofoWrite, ofoOverwrite], H) then
    Exit;
  try
    Result := Write(H, PU8(First(AData)), Length(AData), @D) and (D = Length(AData));
  finally
    Close(H);
  end;
end;

function View(const AFile: TFile; AOptions: TViewFileMapperOptions; out AHandler: TFileHandler; out AMapper: TFileMapper;
  out AViewer: TFileMapperViewer): Bool;
var
  OO: TOpenFileOptions = [];
  MO: TMapFileOptions = [];
begin
  Result := False;
  if vfmRead in AOptions then
    OO += [ofoRead];
  if vfmWrite in AOptions then
    OO += [ofoWrite];
  if Open(AFile, OO, AHandler) then
  begin
    if vfmRead in AOptions then
      MO += [mfoRead];
    if vfmWrite in AOptions then
      MO += [mfoWrite];
    if Open(AHandler, MO, Size(AHandler), AMapper) then
      Result := Open(AMapper, AOptions, 0, Size(AMapper), AViewer);
  end;
end;

end.
