unit UFile;

{$I SCL.inc}

interface

uses
  {$IfDef Windows}
  UWindows,
  {$EndIf}
  {$IfDef Posix}
  UPosix, BaseUnix,
  {$EndIf}
  UNumber, UString, UException;

type
  TFileSystemPath = type Str;
  TFileSystemName = type Str;
  TFilePath = type TFileSystemPath;
  TFileName = type TFileSystemName;
  TFileExtension = type Str;
  TDirectoryPath = type TFileSystemPath;
  TDirectoryName = type TFileSystemName;
  TFileHandle = type THandle;
  TFileSystemObjectKind = (fsokNone, fsokFile, fsokDirectory);
  TFileSystemObjectKinds = set of TFileSystemObjectKind;

type
  PFileSystemPath = ^TFileSystemPath;
  PFileSystemName = ^TFileSystemName;
  PFilePath = ^TFilePath;
  PFileName = ^TFilePath;
  PFileExtension = ^TFilePath;
  PDirectoryPath = ^TFilePath;
  PFileHandle = ^THandle;

  TFileSystemPathArray = array of TFileSystemPath;
  TFileSystemNameArray = array of TFileSystemName;
  TFilePathArray = array of TFilePath;
  TFileNameArray = array of TFileName;
  TFileExtensionArray = array of TFileExtension;
  TDirectoryPathArray = array of TDirectoryPath;
  TDirectoryNameArray = array of TDirectoryName;
  TFileHandleArray = array of TFileHandle;

const
  InvalidHandle = TFileHandle(-1);
  PathDelimiter = '/';

type
  TFileSystemObject = record
  private
    {$IfDef Windows}
    Path: UStr;
    {$EndIf}
    {$IfDef Posix}
    Path: Str;
    {$EndIf}
  end;
  PFileSystemObject = ^TFileSystemObject;
  TFileSystemObjectArray = array of TFileSystemObject;

  TMoveFileSystemObjectOption = (mfsooReplace);
  TMoveFileSystemObjectOptions = set of TMoveFileSystemObjectOption;

procedure Path(var AFileSystemObject: TFileSystemObject; const APath: TFileSystemPath); inline; overload;
function Path(const AFileSystemObject: TFileSystemObject): TFileSystemPath; inline; overload;
function Exists(const AFileSystemObject: TFileSystemObject): Bool; inline; overload;
function Move(const ASource, ADestination: TFileSystemObject; AOptions: TMoveFileSystemObjectOptions): Bool;
  inline; overload;

type
  TFile = record
  private
    {$IfDef Windows}
    Path: UStr;
    {$EndIf}
    {$IfDef Posix}
    Path: Str;
    {$EndIf}
  end;
  PFile = ^TFile;
  TFileArray = array of TFile;

procedure Path(var AFile: TFile; const APath: TFilePath); inline; overload;
function Path(const AFile: TFile): TFilePath; inline; overload;

type
  TOpenFileOption = (ofoCreate, ofoOverwrite, ofoOpen,
    ofoRead, ofoWrite,
    ofoShareRead, ofoShareWrite, ofoShareDelete,
    ofoReadAttributes, ofoWriteAttributes);
  TOpenFileOptions = set of TOpenFileOption;
  TSeekFileOrigin = (sfoBegin, sfoCurrent, sfoEnd);
  TFileHandler = record
  private
    Handle: TFileHandle;
  end;
  PFileHandler = ^TFileHandler;

function Open(const AFile: TFile; AOptions: TOpenFileOptions; out AHandler: TFileHandler): Bool; inline; overload;
function Close(var AHandler: TFileHandler): Bool; inline; overload;
function Handle(const AHandler: TFileHandler): TFileHandle; inline; overload;
function Size(const AHandler: TFileHandler): Siz; inline; overload;
function Read(const AHandler: TFileHandler; AData: PU8; ACount: Siz; ADone: PSiz): Bool; inline; overload;
function Write(const AHandler: TFileHandler; AData: PU8; ACount: Siz; ADone: PSiz): Bool; inline; overload;
function Seek(const AHandler: TFileHandler; ACount: IPS; AOrigin: TSeekFileOrigin; APosition: PSiz): Bool; inline; overload;
function Destroy(const AFile: TFile): Bool; inline; overload;
function AsFileSystemObject(const AFile: TFile): TFileSystemObject; inline; overload;
function AsFile(const AFileSystemObject: TFileSystemObject): TFile; inline; overload;

type
  TMapFileOption = (mfoRead, mfoWrite);
  TMapFileOptions = set of TMapFileOption;
  TFileMapper = record
  private
    Size: Siz;
    {$IfDef Windows}
    Handle: THandle;
    {$EndIf}
    {$IfDef Posix}
    FileHandler: PFileHandler;
    {$EndIf}
  end;
  PFileMapper = ^TFileMapper;

function Open(constref AHandler: TFileHandler; AOptions: TMapFileOptions; ASize: Siz; out AMapper: TFileMapper): Bool;
  inline; overload;
function Close(var AMapper: TFileMapper): Bool; inline; overload;
function Size(const AMapper: TFileMapper): Siz; inline; overload;

type
  TViewFileMapperOption = (vfmRead, vfmWrite);
  TViewFileMapperOptions = set of TViewFileMapperOption;
  TFileMapperViewer = record
  private
    Mapper: PFileMapper;
    Offset: Siz;
    Size: Siz;
    Address: Ptr;
  end;

function Open(constref AMapper: TFileMapper; AOptions: TViewFileMapperOptions; AOffset, ASize: Siz;
  out AViewer: TFileMapperViewer): Bool; inline; overload;
function Close(var AViewer: TFileMapperViewer): Bool; inline; overload;
function First(const AViewer: TFileMapperViewer): Ptr; inline; overload;
function Size(const AViewer: TFileMapperViewer): Siz; inline; overload;

type
  TDirectory = record
  private
    {$IfDef Windows}
    Path: UStr;
    {$EndIf}
    {$IfDef Posix}
    Path: Str;
    {$EndIf}
  end;
  PDirectory = ^TDirectory;
  TDirectoryArray = array of TDirectory;

procedure Path(var ADirectory: TDirectory; const APath: TDirectoryPath); inline; overload;
function Path(const ADirectory: TDirectory): TDirectoryPath; inline; overload;
function Create(const ADirectory: TDirectory): Bool; inline; overload;
function Destroy(const ADirectory: TDirectory): Bool; inline; overload;
function AsFileSystemObject(const ADirectory: TDirectory): TFileSystemObject; inline; overload;
function AsDirectory(const AFileSystemObject: TFileSystemObject): TDirectory; inline; overload;

type
  TDirectoryEnumeratorAttribute = (deaKind, deaName, deaSize, deaIsHidden, deaIsReadOnly);
  TDirectoryEnumeratorAttributes = set of TDirectoryEnumeratorAttribute;

const
  AllDirectoryEnumeratorAttributes = [Low(TDirectoryEnumeratorAttribute)..High(TDirectoryEnumeratorAttribute)];

type
  TDirectoryEnumerator = record
  private
    Directory: PDirectory;
    ExcludedAttributes: TDirectoryEnumeratorAttributes;
    ExcludedKinds: TFileSystemObjectKinds;
    Path: TFileSystemPath;
    {$IfDef Windows}
    Handle: THandle;
    Data: WIN32_FIND_DATAW;
    First: Bool;
    {$EndIf}
    {$IfDef Posix}
    InternalDirectory: pDir;
    Entry: pDirent;
    Stat: TStat;
    Kind: TFileSystemObjectKind;
    StatIsValid: Bool;
    {$EndIf}
  end;
  PDirectoryEnumerator = ^TDirectoryEnumerator;

function Open(constref ADirectory: TDirectory; out AEnumerator: TDirectoryEnumerator): Bool; inline; overload;
function Close(var AEnumerator: TDirectoryEnumerator): Bool; inline; overload;
procedure ExcludedAttributes(var AEnumerator: TDirectoryEnumerator; AAttributes: TDirectoryEnumeratorAttributes);
  inline; overload;
procedure ExcludedKinds(var AEnumerator: TDirectoryEnumerator; AKinds: TFileSystemObjectKinds); inline; overload;
function Next(var AEnumerator: TDirectoryEnumerator): Bool; inline; overload;
function Kind(constref AEnumerator: TDirectoryEnumerator): TFileSystemObjectKind; inline; overload;
function Name(constref AEnumerator: TDirectoryEnumerator): TFileSystemName; inline; overload;
function Path(constref AEnumerator: TDirectoryEnumerator): TFileSystemPath; inline; overload;
function Size(constref AEnumerator: TDirectoryEnumerator): Siz; inline; overload;
function IsHidden(constref AEnumerator: TDirectoryEnumerator): Bool; inline; overload;
function IsReadOnly(constref AEnumerator: TDirectoryEnumerator): Bool; inline; overload;

type
  THandleFileSystemObjectAttributesOption = (hfsoaoLoad, hfsoaoSave);
  THandleFileSystemObjectAttributesOptions = set of THandleFileSystemObjectAttributesOption;
  TFileSystemObjectAttributesHandler = record
  private
    Options: THandleFileSystemObjectAttributesOptions;
    FileSystemObject: PFileSystemObject;
    {$IfDef Windows}
    Data: WIN32_FILE_ATTRIBUTE_DATA;
    ForSaveAttributes: set of (fodahfsaHidden, fodahfsaReadOnly,
      fodahfsaCreatedTime, fodahfsaModifiedTime, fodahfsaAccessedTime);
    {$EndIf}
    {$IfDef Posix}
    Stat: TStat;
    {$EndIf}
  end;
  PFileOrDirectoryAttributesHandler = ^TFileSystemObjectAttributesHandler;

function Open(constref AFileSystemObject: TFileSystemObject; AOptions: THandleFileSystemObjectAttributesOptions;
  out AHandler: TFileSystemObjectAttributesHandler): Bool; inline; overload;
function Close(var AHandler: TFileSystemObjectAttributesHandler): Bool; inline; overload;
function Kind(const AHandler: TFileSystemObjectAttributesHandler): TFileSystemObjectKind; inline; overload;
function Size(const AHandler: TFileSystemObjectAttributesHandler): Siz; inline; overload;
function IsHidden(const AHandler: TFileSystemObjectAttributesHandler): Bool; inline; overload;
procedure IsHidden(var AHandler: TFileSystemObjectAttributesHandler; AValue: Bool); inline; overload;
function IsReadOnly(const AHandler: TFileSystemObjectAttributesHandler): Bool; inline; overload;
procedure IsReadOnly(var AHandler: TFileSystemObjectAttributesHandler; AValue: Bool); inline; overload;

implementation

{$IfDef Windows}
{$I UFileWindows.inc}
{$EndIf}
{$IfDef Posix}
{$I UFilePosix.inc}
{$EndIf}

function Handle(const AHandler: TFileHandler): TFileHandle;
begin
  Result := AHandler.Handle;
end;

function AsFileSystemObject(const AFile: TFile): TFileSystemObject;
begin
  Result.Path := AFile.Path;
end;

function AsFile(const AFileSystemObject: TFileSystemObject): TFile;
begin
  Result.Path := AFileSystemObject.Path;
end;

function Size(const AMapper: TFileMapper): Siz;
begin
  Result := AMapper.Size;
end;

function Size(const AViewer: TFileMapperViewer): Siz;
begin
  Result := AViewer.Size;
end;

function First(const AViewer: TFileMapperViewer): Ptr;
begin
  Result := AViewer.Address;
end;

function AsFileSystemObject(const ADirectory: TDirectory): TFileSystemObject;
begin
  Result.Path := ADirectory.Path;
end;

function AsDirectory(const AFileSystemObject: TFileSystemObject): TDirectory;
begin
  Result.Path := AFileSystemObject.Path;
end;

procedure ExcludedAttributes(var AEnumerator: TDirectoryEnumerator; AAttributes: TDirectoryEnumeratorAttributes);
begin
  AEnumerator.ExcludedAttributes := AAttributes;
end;

procedure ExcludedKinds(var AEnumerator: TDirectoryEnumerator; AKinds: TFileSystemObjectKinds);
begin
  AEnumerator.ExcludedKinds := AKinds;
end;

function Path(constref AEnumerator: TDirectoryEnumerator): TFileSystemPath;
begin
  with PDirectoryEnumerator(@AEnumerator)^ do
  begin
    if Path = '' then
    begin
      Path := UFile.Path(Directory^) + Name(AEnumerator); //Todo: Improve speed
      if UFile.Kind(AEnumerator) = fsokDirectory then
        Path += PathDelimiter;
    end;
    Result := Path;
  end;
end;

end.
