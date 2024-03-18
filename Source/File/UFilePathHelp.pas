unit UFilePathHelp;

{$I SCL.inc}

interface

uses
  UNumber, UString, UFile;

const
  ExtensionDelimiter = '.';
  ParentDelimiter = '..';
  DriveDelimiter = ':';

type
  TFileSystemPathKind = (fspkNone, fspkFile, fspkDirectory);

function Kind(const APath: TFileSystemPath): TFileSystemPathKind; inline; overload;

function PreviousName(const P: PChar; C, L: NChar): NChar; inline; overload;
function Split(const APath: TFileSystemPath; out P: PChar; out N, L: NChar): Bool; inline; overload;

type
  TSplitFileOrDirectoryPathOption = (sfodpoWithoutPathDelimiter, sfodpoWithoutExtension);
  TSplitFileOrDirectoryPathOptions = set of TSplitFileOrDirectoryPathOption;

procedure Split(const APath: TFileSystemPath; AOptions: TSplitFileOrDirectoryPathOptions;
  out AParent: TDirectoryPath; out AName: TFileSystemName); overload;

function Name(const APath: TFileSystemPath; AWithoutPathDelimiterForDirectory: Bool): TFileSystemName;
  inline; overload;
function Name(const APath: TFileSystemPath): TFileSystemName; inline; overload;
function Parent(const APath: TFileSystemPath): TDirectoryPath; inline; overload;
function Drive(const APath: TFileSystemPath): TFilePath; inline; overload;

function IsAbsolute(const APath: TFileSystemPath): Bool; inline; overload;
function IsRelative(const APath: TFileSystemPath): Bool; inline; overload;
function ToAbsolute(const APath: TFileSystemPath): TFileSystemPath; inline; overload;

procedure Adjust(var APath: TFileSystemPath); inline; overload;
function Adjusted(const APath: TFileSystemPath): TFileSystemPath; inline; overload;
procedure Adjust(var APaths: TFileSystemPathArray); inline; overload;
function Adjusted(const APaths: TFileSystemPathArray): TFileSystemPathArray; inline; overload;

function Name(const APath: TDirectoryPath; AWithoutPathDelimiter: Bool): TDirectoryName; inline; overload;

function PreviousExtension(const P: PChar; C, L: NChar): NChar; inline; overload;
function Name(const APath: TFilePath; AWithoutExtension: Bool; out P: PChar; out A, B: NChar): Bool; inline; overload;
function Name(const APath: TFilePath; AWithoutExtension: Bool): TFileName; inline; overload;
function Extension(const APath: TFilePath): TFileExtension; inline; overload;
procedure Extension(var APath: TFilePath; const AExtension: TFileExtension); overload;
function ChangedExtension(const APath: TFilePath; const AExtension: TFileExtension): TFilePath; overload;

function Fix(const APath: TFileSystemPath): TFileSystemPath; overload;
procedure Fix(var APaths: TFileSystemPathArray); overload;

implementation

uses
  UStringHandle, UStringHelp, UStringSplitHelp, UArrayHelp, UFileHelp, UProgram;

function Kind(const APath: TFileSystemPath): TFileSystemPathKind;
begin
  if APath <> '' then
  begin
    if APath[High(APath)] = PathDelimiter then
      Result := fspkDirectory
    else
      Result := fspkFile;
  end
  else
    Result := fspkNone;
end;

function PreviousName(const P: PChar; C, L: NChar): NChar;
begin
  if C <= L then //Empty
    Exit(C);
  C := Previous(P, C, L, PathDelimiter);
  if C = L then
    C := 0
  else
    C += 1;
  Result := C;
end;

function Split(const APath: TFileSystemPath; out P: PChar; out N, L: NChar): Bool;
var
  C: NChar;
begin
  StartFromLast(APath, P, C, L);
  if C = L then
    Exit(False);
  if P[C] = PathDelimiter then //Directory
    C -= 1;
  N := PreviousName(P, C, L);
  Result := N <> L;
  L := Length(APath) - 1;
end;

function Name(const APath: TFileSystemPath; AWithoutPathDelimiterForDirectory: Bool): TFileSystemName;
var
  P: PChar;
  N, L: NChar;
begin
  if not Split(APath, P, N, L) then
    Exit('');
  if AWithoutPathDelimiterForDirectory and (P[L] = PathDelimiter) then
    L -= 1;
  Result := Create(P, N, L);
end;

function Name(const APath: TFileSystemPath): TFileSystemName;
begin
  Result := Name(APath, True);
end;

function Parent(const APath: TFileSystemPath): TDirectoryPath;
var
  P: PChar;
  N, L: NChar;
begin
  if not Split(APath, P, N, L) then
    Exit('');
  Result := Create(P, 0, N - 1);
end;

function Drive(const APath: TFileSystemPath): TFilePath;
var
  P: PChar;
  C, L: NChar;
begin
  Start(APath, P, C, L);
  if (L >= 2) and (P[1] = DriveDelimiter) then
    Result := P[0]
  else
    Result := '';
end;

function IsAbsolute(const APath: TFileSystemPath): Bool;
var
  P: PChar;
  C, L: NChar;
begin
  Start(APath, P, C, L);
  {$IfDef Windows}
  Result := (L >= 2) and (P[1] = DriveDelimiter);
  {$Else}
  Result := (L >= 1) and (P[0] = PathDelimiter);
  {$EndIf}
end;

function IsRelative(const APath: TFileSystemPath): Bool;
begin
  Result := not IsAbsolute(APath);
end;

function ToAbsolute(const APath: TFileSystemPath): TFileSystemPath;
var
  A: TStrArray;
  I: Ind = 0;
begin
  if (APath = '') or IsAbsolute(APath) then
    Exit(APath);

  A := SplitToStrArray(CurrentDirectory + APath, PathDelimiter, []);
  if A = nil then
    Exit('');
  I := Low(A);
  while I <= High(A) do
    if A[I] = '..' then //Remove previous and this
    begin
      Delete<Str>(A, I); //This
      if I > 1 then //Previous if it is not root
      begin
        Delete<Str>(A, I - 1);
        I -= 1;
      end;
    end
    else if A[I] = '.' then //Remove this
    begin
      if I <> 0 then
        Delete<Str>(A, I);
    end
    else
      I += 1;
  Result := Join<Str>(A, PathDelimiter);
end;

procedure Adjust(var APath: TFileSystemPath);
begin
  {$IfDef Windows}
  Replace(RStr(APath), '\', PathDelimiter);
  {$EndIf}
end;

function Adjusted(const APath: TFileSystemPath): TFileSystemPath;
begin
  {$IfDef Windows}
  Result := APath;
  UniqueString(Result);
  Adjust(Result);
  {$Else}
  Result := APath;
  {$EndIf}
end;

procedure Adjust(var APaths: TFileSystemPathArray);
{$IfDef Windows}
var
  I: Ind;
{$EndIf}
begin
  {$IfDef Windows}
  for I := 0 to High(APaths) do
    Adjust(APaths[I]);
  {$EndIf}
end;

function Adjusted(const APaths: TFileSystemPathArray): TFileSystemPathArray;
var
  I: Ind;
begin
  Result := nil;
  SetLength(Result, Length(APaths));
  for I := 0 to High(APaths) do
    Result[I] := Adjusted(APaths[I]);
end;

function Name(const APath: TDirectoryPath; AWithoutPathDelimiter: Bool): TDirectoryName;
var
  P: PChar;
  N, L: NChar;
begin
  if not Split(APath, P, N, L) then
    Exit('');
  if (P[L] = PathDelimiter) and AWithoutPathDelimiter then
    L -= 1;
  Result := Create(P, N, L);
end;

function PreviousExtension(const P: PChar; C, L: NChar): NChar;
begin
  if (C <= L) or (P[C] = PathDelimiter) then //Empty
    Exit(C);
  C := Previous(P, C, L, ExtensionDelimiter, PathDelimiter);
  if (C <> L) and (P[C] = ExtensionDelimiter) then
    C += 1
  else
    C := L;
  Result := C;
end;

function Name(const APath: TFilePath; AWithoutExtension: Bool; out P: PChar; out A, B: NChar): Bool;
var
  C, L: NChar;
begin
  StartFromLast(APath, P, C, L);
  if (C = L) or (P[C] = PathDelimiter) then
    Exit(False);
  A := PreviousName(P, C, L);
  if A = L then
    Exit(False);
  B := Length(APath) - 1;
  if AWithoutExtension then
  begin
    C := PreviousExtension(P, C, L);
    if C <> L then
      B := C - 2;
  end;
  Result := True;
end;

function Name(const APath: TFilePath; AWithoutExtension: Bool): TFileName;
var
  P: PChar;
  A, B: NChar;
begin
  if Name(APath, AWithoutExtension, P, A, B) then
    Result := Create(P, A, B)
  else
    Result := '';
end;

function Extension(const APath: TFilePath): TFileExtension;
var
  P: PChar;
  C, L: NChar;
begin
  StartFromLast(APath, P, C, L);
  if (C = L) or (P[C] = PathDelimiter) then
    Exit('');
  C := PreviousExtension(P, C, L);
  if C = L then
    Exit('');
  Result := Create(P, C, Length(APath) - 1);
end;

procedure Extension(var APath: TFilePath; const AExtension: TFileExtension);
var
  P: TDirectoryPath;
  N: TFileSystemName;
begin
  Split(APath, [sfodpoWithoutExtension], P, N);
  APath := P + N + ExtensionDelimiter + AExtension;
end;

function ChangedExtension(const APath: TFilePath; const AExtension: TFileExtension): TFilePath;
begin
  Result := APath;
  Extension(Result, AExtension);
end;

function Fix(const APath: TFileSystemPath): TFileSystemPath;
var
  R: TFileSystemPath;
begin
  R := Adjusted(APath);
  R := ToAbsolute(R);
  //Is a directory but does not have the last PathDelimiter
  if (Kind(FileSystemObject(APath)) = fsokDirectory) and (Kind(R) <> fspkDirectory) then
    R += PathDelimiter;
  Result := R;
end;

procedure Fix(var APaths: TFileSystemPathArray);
var
  I: Ind;
begin
  for I := 0 to High(APaths) do
    APaths[I] := Fix(APaths[I]);
end;

procedure Split(const APath: TFileSystemPath; AOptions: TSplitFileOrDirectoryPathOptions; out AParent: TDirectoryPath;
  out AName: TFileSystemName);
var
  P: PChar;
  N, L, C: NChar;
begin
  if not Split(APath, P, N, L) then
  begin
    AParent := '';
    AName := '';
    Exit;
  end;
  AParent := Create(P, 0, N - 1);
  if P[L] = PathDelimiter then
  begin
    if sfodpoWithoutPathDelimiter in AOptions then
      L -= 1;
  end
  else if sfodpoWithoutExtension in AOptions then
  begin
    C := L;
    C := PreviousExtension(P, C, -1);
    if C <> -1 then
      L := C - 2;
  end;
  AName := Create(P, N, L);
end;

end.
