unit UFileCompare;

{$I SCL.inc}

interface

uses
  UNumber, UString, UFile;

type
  TCompareFileResult = (cfrMatched, cfrMissingA, cfrMissingB,
    cfrCanNotReadA, cfrCanNotReadB, cfrDiffrentKind, cfrDiffrentName, cfrDiffrentContent);

function Compare(const A, B: TFilePathArray; out AIssue: Ind): TCompareFileResult; overload;
function Compare(const A, B: TDirectoryPath; out AIssueAtA, AIssueAtB: TFileSystemPath): TCompareFileResult; overload;
function Compare(const A, B: TFileSystemPath; out AIssueAtA, AIssueAtB: TFileSystemPath): TCompareFileResult; overload;

implementation

uses
  UNumberHelp, UFileMemoryHandler, UFileHelp, UFileMemoryHandlerHelp, UFilePathHelp, UFileEnumerateHelp,
  UArrayHelp, UStringCheck;

function CompareDirectory(const A, B: TFilePath): TCompareFileResult; inline; overload;
begin
  if Name(TDirectoryPath(A)) <> Name(TDirectoryPath(B)) then
    Exit(cfrDiffrentName)
  else
    Exit(cfrMatched);
end;

function CompareFile(const A, B: TFilePath): TCompareFileResult; overload;
var
  AF, BF: TFileSystemObject;
  AH, BH: TFileMemoryHandler;
  AP, BP: PChar;
  AFS, BFS: Siz;
  AC, BC, AL, BL: Ind;
begin
  //Name
  if Name(A) <> Name(B) then
    Exit(cfrDiffrentName);

  AF := FileSystemObject(A);
  BF := FileSystemObject(B);

  //Todo: Get OS error instead of checking Exists and benchmark
  if not Exists(AF) then
    Exit(cfrMissingA);
  if not Exists(BF) then
    Exit(cfrMissingB);

  //Size
  //Todo: Start function returns false if the file is empty. Remove when it is fixed
  //Todo: Get OS error or size of File instead of this and benchmark
  AFS := Size(AF);
  BFS := Size(BF);
  if AFS <> BFS then
    Exit(cfrDiffrentContent);
  if AFS = 0 then
    Exit(cfrMatched);

  //Content
  if not Start(AsFile(AF), [ofmhoMap], AH, AP, AC, AL) then
    Exit(cfrCanNotReadA)
  else
  try
    if not Start(AsFile(BF), [ofmhoMap], BH, BP, BC, BL) then
      Exit(cfrCanNotReadB)
    else
    try
      if not Check(AP, AL, BP, BL) then
        Exit(cfrDiffrentContent);
      Result := cfrMatched;
    finally
      Close(BH);
    end;
  finally
    Close(AH);
  end;
end;

function CompareObject(const A, B: TFileSystemPath): TCompareFileResult; overload;
var
  AK, BK: TFileSystemObjectKind;
begin
  if Kind(A) <> Kind(B) then
    Exit(cfrDiffrentKind);

  AK := Kind(FileSystemObject(A));
  BK := Kind(FileSystemObject(B));
  if AK <> BK then
    Exit(cfrDiffrentKind);

  case AK of
    fsokFile: Result := CompareFile(A, B);
    fsokDirectory: Result := CompareDirectory(A, B);
    else
      Exit(cfrMissingA);
  end;
end;

function Compare(const A, B: TFilePathArray; out AIssue: Ind): TCompareFileResult;
var
  I: Ind;
begin
  try
    if (A = nil) and (B = nil) then
      Exit(cfrMatched);
    for I := 0 to Max(High(A), High(B)) do
    begin
      if I = Length(A) then
        Exit(cfrMissingA);
      if I = Length(B) then
        Exit(cfrMissingB);
      Result := CompareObject(A[I], B[I]);
      if Result <> cfrMatched then
        Exit;
    end;
  finally
    if Result <> cfrMatched then
      AIssue := I
    else
      AIssue := InvalidIndex;
  end;
end;

function Compare(const A, B: TDirectoryPath; out AIssueAtA, AIssueAtB: TFileSystemPath): TCompareFileResult;
var
  AL, BL: TFileSystemPathArray;
  ISI: Ind;
begin
  AL := Objects(Directory(A));
  BL := Objects(Directory(B));
  Sort<TFileSystemPath>(AL);
  Sort<TFileSystemPath>(BL);
  Result := Compare(AL, BL, ISI);
  case Result of
    cfrMatched:
    begin
      AIssueAtA := '';
      AIssueAtB := '';
    end;
    cfrMissingA:
    begin
      AIssueAtA := '';
      AIssueAtB := BL[ISI];
    end;
    cfrMissingB:
    begin
      AIssueAtA := AL[ISI];
      AIssueAtB := '';
    end;
    else
    begin
      AIssueAtA := AL[ISI];
      AIssueAtB := BL[ISI];
    end;
  end;
end;

//Todo: Add stop and progress
function Compare(const A, B: TFileSystemPath; out AIssueAtA, AIssueAtB: TFileSystemPath): TCompareFileResult;
var
  AK, BK: TFileSystemObjectKind;
begin
  if Kind(A) <> Kind(B) then
    Exit(cfrDiffrentKind);

  AK := Kind(FileSystemObject(A));
  BK := Kind(FileSystemObject(B));
  if AK <> BK then
    Exit(cfrDiffrentKind);

  case AK of
    fsokFile:
    begin
      Result := CompareFile(TFilePath(A), TFilePath(B));
      if Result = cfrMatched then
      begin
        AIssueAtA := '';
        AIssueAtB := '';
      end
      else
      begin
        AIssueAtA := A;
        AIssueAtB := B;
      end;
    end;
    fsokDirectory: Result := Compare(TDirectoryPath(A), TDirectoryPath(B), AIssueAtA, AIssueAtB)
    else
      Exit(cfrMissingA);
  end;
end;

end.
