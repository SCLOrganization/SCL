unit UFileHelp;

{$I SCL.inc}

interface

uses
  UNumber, UString, UFile, UList;

type
  TFileSystemPathList = TList<TFileSystemPath>;
  TFilePathList = TList<TFilePath>;

function FileSystemObject(const APath: TFileSystemPath): TFileSystemObject; inline; overload;
function Destroy(const AFileSystemObject: TFileSystemObject; AStop: PBool): Bool; inline; overload;
function Kind(const AFileSystemObject: TFileSystemObject): TFileSystemObjectKind; inline; overload;
function Size(const AFileSystemObject: TFileSystemObject): Siz; inline; overload;

function OpenLoad(constref AFileSystemObject: TFileSystemObject; out AHandler: TFileSystemObjectAttributesHandler): Bool;
  inline; overload;

function &File(const APath: TFilePath): TFile; inline; overload;

function Directory(const APath: TDirectoryPath): TDirectory; inline; overload;

function EnsureExists(const ADirectory: TDirectory): Bool; overload;
function CreateDirectoryAndParents(const ADirectory: TDirectory): Bool; overload;
function DestroyChildren(const ADirectory: TDirectory; AStop: PBool): Bool; overload;
function DestroyChildren(const ADirectory: TDirectory): Bool; overload;
function DestroyWithChildren(const ADirectory: TDirectory; AStop: PBool): Bool; overload;

implementation

uses
  USystem, UStringHelp, UStringSplitHelp;

function FileSystemObject(const APath: TFileSystemPath): TFileSystemObject;
begin
  Result := Default(TFileSystemObject);
  Path(Result, APath);
end;

function OpenLoad(constref AFileSystemObject: TFileSystemObject; out AHandler: TFileSystemObjectAttributesHandler): Bool;
begin
  Result := Open(AFileSystemObject, [hfsoaoLoad], AHandler);
end;

function Kind(const AFileSystemObject: TFileSystemObject): TFileSystemObjectKind;
var
  AH: TFileSystemObjectAttributesHandler;
begin
  if OpenLoad(AFileSystemObject, AH) then
  try
    Result := Kind(AH);
  finally
    Close(AH);
  end
  else
    Result := fsokNone;
end;

function Size(const AFileSystemObject: TFileSystemObject): Siz;
var
  AH: TFileSystemObjectAttributesHandler;
begin
  if OpenLoad(AFileSystemObject, AH) then
  try
    Result := Size(AH);
  finally
    Close(AH);
  end
  else
    Result := 0;
end;

function Destroy(const AFileSystemObject: TFileSystemObject; AStop: PBool): Bool;
begin
  case Kind(AFileSystemObject) of
    fsokNone: Result := False;
    fsokFile: Result := UFile.Destroy(AsFile(AFileSystemObject));
    fsokDirectory: Result := DestroyWithChildren(AsDirectory(AFileSystemObject), AStop);
  end;
end;

function &File(const APath: TFilePath): TFile;
begin
  Result := Default(TFile);
  Path(Result, APath);
end;

function Directory(const APath: TDirectoryPath): TDirectory;
begin
  Result := Default(TDirectory);
  Path(Result, APath);
end;

function EnsureExists(const ADirectory: TDirectory): Bool;
begin
  //Faster check, but from this line to Create, it may be created, so it will need a recheck
  Result := Exists(AsFileSystemObject(ADirectory));
  if Result then
    Exit;
  Result := Create(ADirectory);
  Result := Result or (LastSystemError = sekAlreadyExists); //No problem if it exists
end;

function CreateDirectoryAndParents(const ADirectory: TDirectory): Bool;
var
  A: TStrArray;
  P: TDirectoryPath;
  D: TDirectory;
  I: Ind;
begin
  Result := EnsureExists(ADirectory);
  if Result then
    Exit;

  A := SplitToStrArray(Path(ADirectory), PathDelimiter, []);
  if A = nil then
    Exit;
  D := Default(TDirectory);
  P := A[0] + PathDelimiter; //Root
  for I := 1 to High(A) - 1 do //-1 to skip the last empty one
  begin
    P += A[I] + PathDelimiter;
    Path(D, P);
    Result := EnsureExists(D);
    if not Result then
      Exit;
  end;
end;

function DestroyChildren(const ADirectory: TDirectory; AStop: PBool): Bool;
var
  E: TDirectoryEnumerator;
  P: TFileSystemPath;
begin
  if Open(ADirectory, E) then
  try
    Result := True; //Empty Directory
    while Result and Next(E) do
    begin
      if (AStop <> nil) and AStop^ then
        Exit(False);
      P := Path(E);
      if Kind(E) <> fsokDirectory then
        Result := Destroy(&File(P))
      else
        Result := DestroyWithChildren(Directory(P), AStop);
    end;
  finally
    Close(E);
  end;
end;

function DestroyChildren(const ADirectory: TDirectory): Bool;
begin
  Result := DestroyChildren(ADirectory, nil);
end;

function DestroyWithChildren(const ADirectory: TDirectory; AStop: PBool): Bool;
begin
  Result := DestroyChildren(ADirectory, AStop);
  Result := Result and Destroy(ADirectory);
end;

end.
