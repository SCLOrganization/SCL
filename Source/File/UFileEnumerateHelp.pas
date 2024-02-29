unit UFileEnumerateHelp;

{$I SCL.inc}

interface

uses
  UNumber, UString, UFile, UFileHelp, UList;

function Name(const AEnumerator: TDirectoryEnumerator; AWithoutPathDelimiterForDirectory: Bool): TFileSystemName;
  inline; overload;

procedure Objects(const ADirectory: TDirectory; var APaths: TFileSystemPathList); overload;
function Objects(const ADirectory: TDirectory): TFileSystemPathArray; overload;
procedure Files(const ADirectory: TDirectory; var APaths: TFilePathList); overload;
function Files(const ADirectory: TDirectory): TFilePathArray; overload;

implementation

function Name(const AEnumerator: TDirectoryEnumerator; AWithoutPathDelimiterForDirectory: Bool): TFileSystemName;
begin
  Result := Name(AEnumerator);
  if (Kind(AEnumerator) = fsokDirectory) and (not AWithoutPathDelimiterForDirectory) then
    Result += PathDelimiter;
end;

procedure Objects(const ADirectory: TDirectory; var APaths: TFileSystemPathList);
var
  E: TDirectoryEnumerator;
  P: TFileSystemPath;
begin
  if Open(ADirectory, E) then
  try
    while Next(E) do
    begin
      P := Path(E);
      Add<TFileSystemPath>(APaths, P);
      if Kind(E) = fsokDirectory then
        Objects(Directory(P), APaths);
    end;
  finally
    Close(E);
  end;
end;

function Objects(const ADirectory: TDirectory): TFileSystemPathArray;
var
  L: TList<TFilePath>;
begin
  Result := nil;
  Create<TFileSystemPath>(L, Result, [loPacked]);
  Objects(ADirectory, L);
end;

procedure Files(const ADirectory: TDirectory; var APaths: TFilePathList);
var
  E: TDirectoryEnumerator;
begin
  if Open(ADirectory, E) then
  try
    while Next(E) do
      if Kind(E) = fsokFile then
        Add<TFilePath>(APaths, Path(E));
  finally
    Close(E);
  end;
end;

function Files(const ADirectory: TDirectory): TFilePathArray;
var
  L: TList<TFilePath>;
begin
  Result := nil;
  Create<TFilePath>(L, Result, [loPacked]);
  Files(ADirectory, L);
end;

end.
