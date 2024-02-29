uses
  UNumberHelp, UStringHelp;

function FromFilePath(constref AValue: TFilePath): UStr; inline; overload;
var
  P: RStr;
begin
  P := '\\?\' + AValue;
  Replace(P, PathDelimiter, '\');
  Result := UStr(P);
end;

function ToFilePath(const AValue: UStr): TFilePath; inline; overload;
var
  P: RStr;
begin
  P := RStr(AValue);
  Delete(P, 1, 4);
  Replace(P, '\', PathDelimiter);
  Result := TFilePath(P);
end;

procedure Path(var AFileSystemObject: TFileSystemObject; const APath: TFileSystemPath);
begin
  AFileSystemObject.Path := FromFilePath(APath);
end;

function Path(const AFileSystemObject: TFileSystemObject): TFileSystemPath;
begin
  Result := ToFilePath(AFileSystemObject.Path);
end;

function Exists(const AFileSystemObject: TFileSystemObject): Bool;
var
  V: DWORD;
begin
  V := GetFileAttributesW(PWideChar(AFileSystemObject.Path));
  Result := (V <> INVALID_FILE_ATTRIBUTES);
end;

function Move(const ASource, ADestination: TFileSystemObject; AOptions: TMoveFileSystemObjectOptions): Bool;
var
  dwFlags: DWORD;
begin
  dwFlags := MOVEFILE_COPY_ALLOWED; //Always copy
  if mfsooReplace in AOptions then
    dwFlags := dwFlags or MOVEFILE_REPLACE_EXISTING;
  Result := MoveFileExW(PWideChar(ASource.Path), PWideChar(ADestination.Path), dwFlags);
end;

procedure Path(var AFile: TFile; const APath: TFilePath);
begin
  AFile.Path := FromFilePath(APath);
end;

function Path(const AFile: TFile): TFilePath;
begin
  Result := ToFilePath(AFile.Path);
end;

//ofoCreate: Create if it does not exist
//ofoOverwrite: Used with ofoCreate and creates the file if it exists or not
function Open(const AFile: TFile; AOptions: TOpenFileOptions; out AHandler: TFileHandler): Bool;
var
  dwDesiredAccess, dwCreationDisposition, dwShareMode: DWORD;
begin
  dwDesiredAccess := 0;
  if ofoReadAttributes in AOptions then
    dwDesiredAccess := dwDesiredAccess or FILE_READ_ATTRIBUTES;
  if ofoWriteAttributes in AOptions then
    dwDesiredAccess := dwDesiredAccess or FILE_WRITE_ATTRIBUTES;
  if ofoRead in AOptions then
    dwDesiredAccess := dwDesiredAccess or GENERIC_READ;
  if ofoWrite in AOptions then
    dwDesiredAccess := dwDesiredAccess or GENERIC_WRITE;

  if ofoCreate in AOptions then
    if ofoOverwrite in AOptions then
      dwCreationDisposition := CREATE_ALWAYS //Create or Truncate
    else
      dwCreationDisposition := OPEN_ALWAYS //Create or Open
  else
    dwCreationDisposition := OPEN_EXISTING; //Open or Fail

  dwShareMode := FILE_SHARE_NONE;
  if ofoShareRead in AOptions then
    dwShareMode := dwShareMode or FILE_SHARE_READ;
  if ofoShareWrite in AOptions then
    dwShareMode := dwShareMode or FILE_SHARE_WRITE;
  if ofoShareDelete in AOptions then
    dwShareMode := dwShareMode or FILE_SHARE_DELETE;

  AHandler.Handle := CreateFileW(PWideChar(AFile.Path),
    dwDesiredAccess,
    dwShareMode,
    nil, //No access for childs
    dwCreationDisposition,
    FILE_ATTRIBUTE_NORMAL,
    0); // No template
  Result := AHandler.Handle <> InvalidHandle;
end;

function Close(var AHandler: TFileHandler): Bool;
begin
  Result := CloseHandle(AHandler.Handle);
  if Result then
    AHandler.Handle := InvalidHandle;
end;

function Size(const AHandler: TFileHandler): Siz;
begin
  if not GetFileSizeEx(AHandler.Handle, PLARGE_INTEGER(@Result)) then
    Result := 0;
end;

function Read(const AHandler: TFileHandler; AData: PU8; ACount: Siz; ADone: PSiz): Bool;
var
  V: DWORD;
begin
  if ACount > High(DWORD) then
    ACount := High(DWORD);
  Result := ReadFile(AHandler.Handle, AData, ACount, @V, nil);
  if ADone <> nil then
    ADone^ := V;
end;

function Write(const AHandler: TFileHandler; AData: PU8; ACount: Siz; ADone: PSiz): Bool;
var
  V: DWORD;
begin
  if ACount > High(DWORD) then
    ACount := High(DWORD);
  Result := WriteFile(AHandler.Handle, AData, ACount, @V, nil);
  if ADone <> nil then
    ADone^ := V;
end;

function Seek(const AHandler: TFileHandler; ACount: IPS; AOrigin: TSeekFileOrigin; APosition: PSiz): Bool;
var
  O: DWORD;
  V: LARGE_INTEGER;
begin
  case AOrigin of
    sfoBegin: O := FILE_BEGIN;
    sfoCurrent: O := FILE_CURRENT;
    sfoEnd: O := FILE_END;
  end;
  Result := SetFilePointerEx(AHandler.Handle, LARGE_INTEGER(ACount), @V, O);
  if APosition <> nil then
    APosition^ := V.QuadPart;
end;

function Destroy(const AFile: TFile): Bool;
begin
  Result := DeleteFileW(PWideChar(AFile.Path));
end;

function Open(constref AHandler: TFileHandler; AOptions: TMapFileOptions; ASize: Siz; out AMapper: TFileMapper): Bool;
var
  Size: LARGE_INTEGER;
  flProtect: DWORD;
begin
  Size.QuadPart := ASize;

  if AOptions = [mfoRead, mfoWrite] then
    flProtect := PAGE_READWRITE
  else if AOptions = [mfoRead] then
    flProtect := PAGE_READONLY
  else
    flProtect := 0;

  AMapper.Handle := CreateFileMappingW(AHandler.Handle,
    nil,  //No access for childs
    flProtect,
    Size.HighPart, Size.LowPart, //Current size of the file
    nil); //No name

  Result := AMapper.Handle <> 0;
  if Result then
    AMapper.Size := Size.QuadPart;
end;

function Close(var AMapper: TFileMapper): Bool;
begin
  Result := CloseHandle(AMapper.Handle);
end;

function Open(constref AMapper: TFileMapper; AOptions: TViewFileMapperOptions; AOffset, ASize: Siz;
  out AViewer: TFileMapperViewer): Bool;
var
  dwDesiredAccess: DWORD;
  Offset: TU64Record absolute AOffset;
begin
  if AOptions = [vfmRead, vfmWrite] then
    dwDesiredAccess := FILE_MAP_WRITE
  else if AOptions = [vfmRead] then
    dwDesiredAccess := FILE_MAP_READ
  else
    dwDesiredAccess := 0;

  AViewer.Address := MapViewOfFile(AMapper.Handle, dwDesiredAccess, Offset.L, Offset.H, ASize);

  Result := AViewer.Address <> nil;
  if Result then
    with AViewer do
    begin
      Mapper := @AMapper;
      Offset := AOffset;
      Size := ASize;
    end;
end;

function Close(var AViewer: TFileMapperViewer): Bool;
begin
  Result := UnmapViewOfFile(AViewer.Address);
end;

procedure Path(var ADirectory: TDirectory; const APath: TDirectoryPath);
begin
  ADirectory.Path := FromFilePath(APath);
end;

function Path(const ADirectory: TDirectory): TDirectoryPath;
begin
  Result := ToFilePath(ADirectory.Path);
end;

function Create(const ADirectory: TDirectory): Bool;
begin
  Result := CreateDirectoryW(PWideChar(ADirectory.Path),
    nil); // Default security;
end;

function Destroy(const ADirectory: TDirectory): Bool;
begin
  Result := RemoveDirectoryW(PWideChar(ADirectory.Path));
end;

function Open(constref ADirectory: TDirectory; out AEnumerator: TDirectoryEnumerator): Bool;
begin
  with AEnumerator do
  begin
    Handle := FindFirstFileExW(PWideChar(ADirectory.Path + '*'),
      FindExInfoBasic, //No cAlternateFileName and faster
      @Data,
      FindExSearchNameMatch,
      nil,
      0); //No additional flags are needed
    First := True; //First file is available at open

    Result := Handle <> InvalidHandle;
    if not Result then
      Exit;
    Directory := @ADirectory;
    ExcludedAttributes := [];
    ExcludedKinds := [];
    Path := '';
  end;
end;

function Close(var AEnumerator: TDirectoryEnumerator): Bool;
begin
  Result := FindClose(AEnumerator.Handle);
end;

function KindFromFileAttributes(AFileAttributes: DWORD): TFileSystemObjectKind; inline; overload;
begin
  if AFileAttributes and FILE_ATTRIBUTE_DIRECTORY = 0 then
    Result := fsokFile
  else if AFileAttributes and FILE_ATTRIBUTE_DIRECTORY <> 0 then
    Result := fsokDirectory
  else
    Result := fsokNone;
end;

//Ignoring function ExcludeAttributes as Windows gives back all the data anyway
function Next(var AEnumerator: TDirectoryEnumerator): Bool;
var
  K: TFileSystemObjectKind;
begin
  with AEnumerator, AEnumerator.Data do
    while True do //Find Next
    begin
      if First then
        First := False
      else if not FindNextFileW(Handle, @Data) then
        Exit(False); //End
      Path := ''; //Reset anyway

      K := KindFromFileAttributes(dwFileAttributes);
      if K in ExcludedKinds then
        Continue; //Excluded
      if K = fsokDirectory then
        if (cFileName[0] = '.') and ((cFileName[1] = #0) or ((cFileName[1] = '.') and (cFileName[2] = #0))) then
          Continue; //Ignore

      Exit(True); //Found
    end;
end;

function Kind(constref AEnumerator: TDirectoryEnumerator): TFileSystemObjectKind;
begin
  Result := KindFromFileAttributes(AEnumerator.Data.dwFileAttributes);
end;

function Name(constref AEnumerator: TDirectoryEnumerator): TFileSystemName;
begin
  Result := AEnumerator.Data.cFileName;
end;

function Size(constref AEnumerator: TDirectoryEnumerator): Siz;
begin
  with AEnumerator.Data do
    Result := ToU64(nFileSizeLow, nFileSizeHigh);
end;

function IsHidden(constref AEnumerator: TDirectoryEnumerator): Bool;
begin
  Result := AEnumerator.Data.dwFileAttributes and FILE_ATTRIBUTE_HIDDEN <> 0;
end;

function IsReadOnly(constref AEnumerator: TDirectoryEnumerator): Bool;
begin
  Result := AEnumerator.Data.dwFileAttributes and FILE_ATTRIBUTE_READONLY <> 0;
end;

function Open(constref AFileSystemObject: TFileSystemObject; AOptions: THandleFileSystemObjectAttributesOptions;
  out AHandler: TFileSystemObjectAttributesHandler): Bool;
begin
  AHandler := Default(TFileSystemObjectAttributesHandler);
  if AOptions = [] then
    Exit(False);

  //Need to load even if hfsoaoLoad is not in the Options, as hfodaoSave needs it
  Result := GetFileAttributesExW(PWideChar(AFileSystemObject.Path), GetFileExInfoStandard, @AHandler.Data);
  if not Result then
    Exit;

  AHandler.Options := AOptions;
  AHandler.FileSystemObject := @AFileSystemObject;
  AHandler.ForSaveAttributes := [];
end;

function Close(var AHandler: TFileSystemObjectAttributesHandler): Bool;
var
  H: HANDLE;
  FI: FILE_BASIC_INFO;
begin
  if (not (hfsoaoSave in AHandler.Options)) or (AHandler.ForSaveAttributes = []) then
    Exit(True);

  H := CreateFileW(PWideChar(AHandler.FileSystemObject^.Path),
    FILE_WRITE_ATTRIBUTES, FILE_SHARE_READ or FILE_SHARE_WRITE or FILE_SHARE_DELETE, nil, OPEN_EXISTING, 0, 0);
  if H = InvalidHandle then
    Exit(False);

  try
    with AHandler.Data, FI do
    begin
      CreationTime := LARGE_INTEGER(ftCreationTime);
      LastAccessTime := LARGE_INTEGER(ftLastAccessTime);
      LastWriteTime := LARGE_INTEGER(ftLastWriteTime);
      ChangeTime := LARGE_INTEGER(ftLastWriteTime);
      FileAttributes := dwFileAttributes;
    end;
    Result := SetFileInformationByHandle(H, FileBasicInfo, @FI, SizeOf(FI));
  finally
    CloseHandle(H);
  end;
end;

function Kind(const AHandler: TFileSystemObjectAttributesHandler): TFileSystemObjectKind;
begin
  Result := KindFromFileAttributes(AHandler.Data.dwFileAttributes);
end;

function Size(const AHandler: TFileSystemObjectAttributesHandler): Siz;
begin
  with AHandler.Data do
    if dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY = 0 then
      Result := ToU64(nFileSizeLow, nFileSizeHigh)
    else //nFileSizeLow, and nFileSizeHigh have no meaning for directories, and Windows returns not zero sometimes
      Result := 0;
end;

function IsHidden(const AHandler: TFileSystemObjectAttributesHandler): Bool;
begin
  Result := AHandler.Data.dwFileAttributes and FILE_ATTRIBUTE_HIDDEN <> 0;
end;

procedure IsHidden(var AHandler: TFileSystemObjectAttributesHandler; AValue: Bool);
begin
  with AHandler.Data do
    if AValue then
      dwFileAttributes := dwFileAttributes or FILE_ATTRIBUTE_HIDDEN
    else
      dwFileAttributes := dwFileAttributes and not FILE_ATTRIBUTE_HIDDEN;
  AHandler.ForSaveAttributes += [fodahfsaHidden];
end;

function IsReadOnly(const AHandler: TFileSystemObjectAttributesHandler): Bool;
begin
  Result := AHandler.Data.dwFileAttributes and FILE_ATTRIBUTE_READONLY <> 0;
end;

procedure IsReadOnly(var AHandler: TFileSystemObjectAttributesHandler; AValue: Bool);
begin
  with AHandler.Data do
    if AValue then
      dwFileAttributes := dwFileAttributes or FILE_ATTRIBUTE_READONLY
    else
      dwFileAttributes := dwFileAttributes and not FILE_ATTRIBUTE_READONLY;
  AHandler.ForSaveAttributes += [fodahfsaReadOnly];
end;
