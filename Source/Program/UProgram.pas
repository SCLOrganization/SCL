unit UProgram;

{$I SCL.inc}

interface

uses
  {$IfDef Posix}
  cthreads,
  {$EndIf}
  {$IfDef HeapTrace}
  heaptrc,
  {$EndIf}
  UString, UFile;

function CurrentDirectory: TDirectoryPath; overload;
function ProgramDirectory: TDirectoryPath; overload;

{$IfDef HeapTrace}
procedure HeapTracePath(const APath: TFilePath);
{$EndIf}

implementation

uses
  UFileHelp, UFilePathHelp;

//Todo: Get from OS
function CurrentDirectory: TDirectoryPath;
begin
  System.GetDir(0, Result{%H-});
  Adjust(Result);
  Result += PathDelimiter;
end;

//Todo: Get from OS
function ProgramDirectory: TDirectoryPath;
begin
  Result := System.ParamStr(0);
  Adjust(Result);
  Result := Parent(Result);
end;

{$IfDef HeapTrace}
procedure HeapTracePath(const APath: TFilePath);
var
  F: TFileSystemObject;
begin
  GlobalSkipIfNoLeaks := True;
  F := FileSystemObject(APath);
  if Exists(F) then
    Destroy(AsFile(F));
  SetHeapTraceOutput(APath);
end;
{$EndIf}

{$IfDef HeapTrace}
initialization
  HeapTracePath(ProgramDirectory + 'Trace.log');
{$EndIf}

end.
