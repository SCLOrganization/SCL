uses
  UExceptionHelp;

procedure Path(var AFileSystemObject: TFileSystemObject; const APath: TFileSystemPath);
begin
  AFileSystemObject.Path := APath;
end;

function Path(const AFileSystemObject: TFileSystemObject): TFileSystemPath;
begin
  Result := AFileSystemObject.Path;
end;

function Exists(const AFileSystemObject: TFileSystemObject): Bool;
begin
  Result := FpAccess(AFileSystemObject.Path, F_OK) = 0;
end;

function Move(const ASource, ADestination: TFileSystemObject; AOptions: TMoveFileSystemObjectOptions): Bool;
var
  flags: cint;
begin
  flags := 0;
  if not (mfsooReplace in AOptions) then
    flags := flags or RENAME_NOREPLACE;
  Result := renameat2(0, PChar(ASource.Path), 0, PChar(ADestination.Path), flags) = 0;
end;

procedure Path(var AFile: TFile; const APath: TFilePath);
begin
  AFile.Path := APath;
end;

function Path(const AFile: TFile): TFilePath;
begin
  Result := AFile.Path;
end;

//ofoCreate: Create if it does not exist
//ofoOverwrite: Used with ofoCreate and creates the file if it exists or not
//Todo: Handle ofoShareRead, ofoShareWrite and ofoShareDelete
function Open(const AFile: TFile; AOptions: TOpenFileOptions; out AHandler: TFileHandler): Bool;
var
  flags, H: cint;
  NR, NW: Bool;
begin
  NR := AOptions * [ofoRead, ofoReadAttributes] <> [];
  NW := AOptions * [ofoWrite, ofoWriteAttributes] <> [];
  if NR and NW then
    flags := O_RDWR
  else if NR then
    flags := O_RDONLY
  else
    flags := O_WRONLY;

  if ofoCreate in AOptions then
  begin
    flags := flags or O_CREAT;
    if ofoOverwrite in AOptions then
      flags := flags or O_TRUNC;
  end;

  H := FpOpen(AFile.Path, flags);
  Result := H > 0;
  if Result then
    AHandler.Handle := H
  else
    AHandler.Handle := InvalidHandle;
end;

function Close(var AHandler: TFileHandler): Bool;
begin
  Result := FpClose(AHandler.Handle) = 0;
  if Result then
    AHandler.Handle := InvalidHandle;
end;

function Size(const AHandler: TFileHandler): Siz;
var
  S: stat;
begin
  if FPFStat(AHandler.Handle, S{%H-}) = 0 then
    Result := S.st_size
  else
    Result := 0;
end;

function Read(const AHandler: TFileHandler; AData: PU8; ACount: Siz; ADone: PSiz): Bool;
var
  V: TsSize;
begin
  V := FpRead(cint(AHandler.Handle), PAnsiChar(AData), ACount);
  Result := V >= 0;
  if Result and (ADone <> nil) then
    ADone^ := V;
end;

function Write(const AHandler: TFileHandler; AData: PU8; ACount: Siz; ADone: PSiz): Bool;
var
  V: TsSize;
begin
  V := FpWrite(cint(AHandler.Handle), PAnsiChar(AData), ACount);
  Result := V >= 0;
  if Result and (ADone <> nil) then
    ADone^ := V;
end;

function Seek(const AHandler: TFileHandler; ACount: IPS; AOrigin: TSeekFileOrigin; APosition: PSiz): Bool;
var
  whence: cint;
  V: TOff;
begin
  case AOrigin of
    sfoBegin: whence := SEEK_SET;
    sfoCurrent: whence := SEEK_CUR;
    sfoEnd: whence := SEEK_END;
  end;
  V := FpLseek(cint(AHandler.Handle), ACount, whence);
  Result := V >= 0;
  if Result and (APosition <> nil) then
    APosition^ := V;
end;

function Destroy(const AFile: TFile): Bool;
begin
  Result := FpUnlink(AFile.Path) = 0;
end;

function Open(constref AHandler: TFileHandler; AOptions: TMapFileOptions; ASize: Siz; out AMapper: TFileMapper): Bool;
begin
  AMapper.FileHandler := @AHandler;
  AMapper.Size := ASize;
  Result := True;
end;

function Close(var AMapper: TFileMapper): Bool;
begin
  Result := True;
end;

function Open(constref AMapper: TFileMapper; AOptions: TViewFileMapperOptions; AOffset, ASize: Siz;
  out AViewer: TFileMapperViewer): Bool;
var
  prot: cint;
begin
  prot := PROT_NONE;
  if vfmRead in AOptions then
    prot := PROT_READ;
  if vfmWrite in AOptions then
    prot := prot or PROT_WRITE;
  AViewer.Address := Fpmmap(nil, ASize, prot,
    MAP_PRIVATE, //Private to this process
    cint(AMapper.FileHandler^.Handle), AOffset);
  Result := AViewer.Address <> MAP_FAILED;
  if not Result then
    Exit;
  with AViewer do
  begin
    Mapper := @AMapper;
    Offset := AOffset;
    Size := ASize;
  end;
end;

function Close(var AViewer: TFileMapperViewer): Bool;
begin
  Result := Fpmunmap(AViewer.Address, AViewer.Size) = 0;
end;

procedure Path(var ADirectory: TDirectory; const APath: TDirectoryPath);
begin
  ADirectory.Path := APath;
end;

function Path(const ADirectory: TDirectory): TDirectoryPath;
begin
  Result := ADirectory.Path;
end;

function Create(const ADirectory: TDirectory): Bool;
begin
  Result := FpMkdir(ADirectory.Path,
    S_IRWXU or S_IRWXG or S_IROTH or S_IXOTH //Default security
    ) = 0;
end;

function Destroy(const ADirectory: TDirectory): Bool;
begin
  Result := FpRmdir(ADirectory.Path) = 0;
end;

function Open(constref ADirectory: TDirectory; out AEnumerator: TDirectoryEnumerator): Bool;
begin
  AEnumerator := Default(TDirectoryEnumerator);
  with AEnumerator do
  begin
    InternalDirectory := FpOpendir(ADirectory.Path);
    Result := InternalDirectory <> nil;
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
  Result := FpClosedir(AEnumerator.InternalDirectory^) = 0;
end;

function KindFromd_type(d_type: cuchar): TFileSystemObjectKind; inline;
begin
  case d_type of
    DT_REG: Result := fsokFile;
    DT_DIR: Result := fsokDirectory;
    else
      Result := fsokNone;
  end;
end;

function KindFromStat(constref AStat: TStat): TFileSystemObjectKind; inline;
begin
  case (AStat.st_mode and S_IFMT) of
    S_IFREG: Result := fsokFile;
    S_IFDIR: Result := fsokDirectory;
    else
      Result := fsokNone;
  end;
end;

function SizeFromStat(constref AStat: TStat; AKind: TFileSystemObjectKind): Siz; inline;
begin
  if AKind <> fsokDirectory then //Prevent invalid size for Directory
    Result := AStat.st_size
  else
    Result := 0;
end;

function Name(constref AEnumerator: TDirectoryEnumerator): TFileSystemName;
begin
  Result := AEnumerator.Entry^.d_name;
end;

function IsIgnoredName(AEntry: pDirent): Bool; inline;
begin
  with AEntry^ do
    Result := (d_name[0] = '.') and ((d_name[1] = #0) or ((d_name[1] = '.') and (d_name[2] = #0)));
end;

function Next(var AEnumerator: TDirectoryEnumerator): Bool;
begin
  with AEnumerator, Entry^ do
  begin
    while True do //Find Next
    begin
      Entry := FpReaddir(InternalDirectory^);
      Result := Entry <> nil;
      Path := ''; //Reset anyway
      if not Result then
        Exit; //End

      if Entry^.d_type <> DT_UNKNOWN then //d_type is supported
      begin
        Kind := KindFromd_type(Entry^.d_type);
        if (Kind = fsokDirectory) and IsIgnoredName(Entry) then //Check for Kind first as a faster way
          Continue; //Ignore

        if Kind in ExcludedKinds then //Check before updating stat as a faster way
          Continue; //Excluded

        if AllDirectoryEnumeratorAttributes - ExcludedAttributes = [deaKind] then
          //Only deaKind is needed so no Stat is needed
          StatIsValid := False
        else
          StatIsValid := fpLstat(UFile.Path(AEnumerator), Stat) = 0; //Update stat for other attributes
      end
      else
      begin
        if IsIgnoredName(Entry) then
          Continue; //Ignore
        //Need Stat for Kind and maybe for other attributes
        StatIsValid := fpLstat(UFile.Path(AEnumerator), Stat) = 0;
        if StatIsValid then
          Kind := KindFromStat(Stat)
        else
          Kind := fsokNone;

        if Kind in ExcludedKinds then
          Continue; //Excluded
      end;
      Break; //Found
    end;
  end;
end;

function Kind(constref AEnumerator: TDirectoryEnumerator): TFileSystemObjectKind;
begin
  Result := AEnumerator.Kind;
end;

function Size(constref AEnumerator: TDirectoryEnumerator): Siz;
begin
  Result := SizeFromStat(AEnumerator.Stat, AEnumerator.Kind);
end;

function IsHidden(constref AEnumerator: TDirectoryEnumerator): Bool;
begin
  Result := AEnumerator.Entry^.d_name[0] = '.';
end;

function IsReadOnly(constref AEnumerator: TDirectoryEnumerator): Bool;
begin
  Result := FpAccess(UFile.Path(AEnumerator), W_OK) = 0;
end;

function Open(constref AFileSystemObject: TFileSystemObject; AOptions: THandleFileSystemObjectAttributesOptions;
  out AHandler: TFileSystemObjectAttributesHandler): Bool;
begin
  if AOptions = [] then
    Exit(False);
  if AOptions = [hfsoaoSave] then //Todo: Support hfsoaoSave
    RaiseNotSupported;

  Result := fpLstat(AFileSystemObject.Path, AHandler.Stat) = 0;
  if not Result then
    Exit;
  AHandler.Options := AOptions;
  AHandler.FileSystemObject := @AFileSystemObject;
end;

//Todo: Support hfsoaoSave
function Close(var AHandler: TFileSystemObjectAttributesHandler): Bool;
begin
  Result := True;
end;

function Kind(const AHandler: TFileSystemObjectAttributesHandler): TFileSystemObjectKind;
begin
  Result := KindFromStat(AHandler.Stat);
end;

function Size(const AHandler: TFileSystemObjectAttributesHandler): Siz;
begin
  Result := SizeFromStat(AHandler.Stat, KindFromStat(AHandler.Stat));
end;

function IsHidden(const AHandler: TFileSystemObjectAttributesHandler): Bool;
begin
  Result := False;
  RaiseNotSupported;
end;

procedure IsHidden(var AHandler: TFileSystemObjectAttributesHandler; AValue: Bool);
begin
  RaiseNotSupported;
end;

function IsReadOnly(const AHandler: TFileSystemObjectAttributesHandler): Bool;
begin
  Result := FpAccess(AHandler.FileSystemObject^.Path, W_OK) <> 0;
end;

procedure IsReadOnly(var AHandler: TFileSystemObjectAttributesHandler; AValue: Bool);
begin
  RaiseNotSupported;
end;
