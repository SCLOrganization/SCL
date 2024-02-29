unit UWindows;

{$I SCL.inc}

interface

uses
  UNumber, UString;

const
  Kernel32 = 'kernel32';
  MAX_PATH = 260;

type
  HANDLE = System.THandle;
  SHORT = Smallint;
  WINT = Longint;
  LONG = Longint;
  LONGLONG = Int64;
  DWORD = Cardinal;
  LPDWORD = ^DWORD;
  PVOID = Pointer;
  LPVOID = Pointer;
  LPCVOID = Pointer;
  ULONG = QWord;
  ULONGLONG = QWord;
  ULONG_PTR = QWord;
  DWORD_PTR = ULONG_PTR;
  PDWORD_PTR = ^DWORD_PTR;
  UINT = Cardinal;
  SIZE_T = ULONG_PTR;
  LARGE_INTEGER = record
    case Byte of
      0: (LowPart: DWORD;
        HighPart: LONG);
      1: (QuadPart: LONGLONG);
  end;
  PLARGE_INTEGER = ^LARGE_INTEGER;
  ULARGE_INTEGER = record
    case Byte of
      0: (LowPart: DWORD;
        HighPart: DWORD);
      1: (QuadPart: ULONGLONG);
  end;

  HLOCAL = HANDLE;

const
  INVALID_HANDLE_VALUE = HANDLE(-1);

type
  LPCSTR = PChar;
  LPCWSTR = PWideChar;
  LPWSTR = PWideChar;

//Handle
function CloseHandle(hObject: HANDLE): BOOL; stdcall; external Kernel32;

//Process
function GetCurrentProcess: HANDLE; stdcall; external Kernel32;

//System
type
  SYSTEM_INFO = record
    Dummy: packed record
      case U8 of
        0: (dwOemId: DWORD);
        1: (wProcessorArchitecture: Word;
          wReserved: Word;);
      end;
    dwPageSize: DWORD;
    lpMinimumApplicationAddress: LPVOID;
    lpMaximumApplicationAddress: LPVOID;
    dwActiveProcessorMask: DWORD_PTR;
    dwNumberOfProcessors: DWORD;
    dwProcessorType: DWORD;
    dwAllocationGranularity: DWORD;
    wProcessorLevel: WORD;
    wProcessorRevision: WORD;
  end;
  LPSYSTEM_INFO = ^SYSTEM_INFO;

type
  SYSTEMTIME = record
    wYear: WORD;
    wMonth: WORD;
    wDayOfWeek: WORD;
    wDay: WORD;
    wHour: WORD;
    wMinute: WORD;
    wSecond: WORD;
    wMilliseconds: WORD;
  end;
  LPSYSTEMTIME = ^SYSTEMTIME;

procedure GetSystemInfo(lpSystemInfo: LPSYSTEM_INFO); stdcall; external Kernel32;

//Memory
type
  WIN32_MEMORY_RANGE_ENTRY = record
    VirtualAddress: PVOID;
    NumberOfBytes: SIZE_T;
  end;
  PWIN32_MEMORY_RANGE_ENTRY = ^WIN32_MEMORY_RANGE_ENTRY;

function PrefetchVirtualMemory(hProcess: HANDLE; NumberOfEntries: ULONG_PTR;
  VirtualAddresses: PWIN32_MEMORY_RANGE_ENTRY; Flags: ULONG): BOOL; stdcall; external Kernel32;
function SetProcessWorkingSetSize(hProcess: HANDLE; dwMinimumWorkingSetSize, dwMaximumWorkingSetSize: SIZE_T): BOOL;
  stdcall; external Kernel32;
function LocalFree(hMem: HLOCAL): HLOCAL; stdcall; external Kernel32;

//File
type
  SECURITY_ATTRIBUTES = record
    nLength: DWORD;
    lpSecurityDescriptor: LPVOID;
    bInheritHandle: BOOL;
  end;
  LPSECURITY_ATTRIBUTES = ^SECURITY_ATTRIBUTES;

  FILETIME = record
    dwLowDateTime: DWORD;
    dwHighDateTime: DWORD;
  end;
  LPFILETIME = ^FILETIME;

  WIN32_FILE_ATTRIBUTE_DATA = packed record
    dwFileAttributes: DWORD;
    ftCreationTime: FILETIME;
    ftLastAccessTime: FILETIME;
    ftLastWriteTime: FILETIME;
    nFileSizeHigh: DWORD;
    nFileSizeLow: DWORD;
  end;

  OVERLAPPED = record
    Internal: ULONG_PTR;
    InternalHigh: ULONG_PTR;
    Offset: DWORD;
    OffsetHigh: DWORD;
    hEvent: HANDLE;
  end;
  POVERLAPPED = ^OVERLAPPED;

  GET_FILEEX_INFO_LEVELS = (GetFileExInfoStandard, GetFileExMaxInfoLevel);

  FINDEX_INFO_LEVELS = (FindExInfoStandard, FindExInfoBasic, FindExInfoMaxInfoLevel);
  FINDEX_SEARCH_OPS = (FindExSearchNameMatch, FindExSearchLimitToDirectories, FindExSearchLimitToDevices,
    FindExSearchMaxSearchOp);

  WIN32_FIND_DATAW = record
    dwFileAttributes: DWORD;
    ftCreationTime: FILETIME;
    ftLastAccessTime: FILETIME;
    ftLastWriteTime: FILETIME;
    nFileSizeHigh: DWORD;
    nFileSizeLow: DWORD;
    dwReserved0: DWORD;
    dwReserved1: DWORD;
    cFileName: array[0..(MAX_PATH) - 1] of WCHAR;
    cAlternateFileName: array[0..13] of WCHAR;
  end;
  LPWIN32_FIND_DATAW = ^WIN32_FIND_DATAW;

  FILE_INFO_BY_HANDLE_CLASS = (FileBasicInfo, FileStandardInfo, FileNameInfo, FileRenameInfo, FileDispositionInfo,
    FileAllocationInfo, FileEndOfFileInfo, FileStreamInfo, FileCompressionInfo, FileAttributeTagInfo,
    FileIdBothDirectoryInfo,
    FileIdBothDirectoryRestartInfo, FileIoPriorityHintInfo, FileRemoteProtocolInfo, FileFullDirectoryInfo,
    FileFullDirectoryRestartInfo, FileStorageInfo, FileAlignmentInfo, FileIdInfo, FileIdExtdDirectoryInfo,
    FileIdExtdDirectoryRestartInfo, FileDispositionInfoEx, FileRenameInfoEx, FileCaseSensitiveInfo, FileNormalizedNameInfo,
    MaximumFileInfoByHandleClass);

  FILE_BASIC_INFO = record
    CreationTime: LARGE_INTEGER;
    LastAccessTime: LARGE_INTEGER;
    LastWriteTime: LARGE_INTEGER;
    ChangeTime: LARGE_INTEGER;
    FileAttributes: DWORD;
  end;

const
  FILE_ADD_FILE = 2;
  FILE_ADD_SUBDIRECTORY = 4;
  FILE_APPEND_DATA = 4;
  FILE_CREATE_PIPE_INSTANCE = 4;
  FILE_DELETE_CHILD = 64;
  FILE_EXECUTE = 32;
  FILE_LIST_DIRECTORY = 1;
  FILE_READ_ATTRIBUTES = 128;
  FILE_READ_DATA = 1;
  FILE_READ_EA = 8;
  FILE_TRAVERSE = 32;
  FILE_WRITE_ATTRIBUTES = 256;
  FILE_WRITE_DATA = 2;
  FILE_WRITE_EA = 16;

  GENERIC_ALL = $10000000;
  GENERIC_EXECUTE = $20000000;
  GENERIC_WRITE = $40000000;
  GENERIC_READ = $80000000;

  FILE_SHARE_NONE = $00000000;
  FILE_SHARE_READ = $00000001;
  FILE_SHARE_WRITE = $00000002;
  FILE_SHARE_DELETE = $00000004;

  CREATE_NEW = $00000001;
  CREATE_ALWAYS = $00000002;
  OPEN_EXISTING = $00000003;
  OPEN_ALWAYS = $00000004;
  TRUNCATE_EXISTING = $00000005;

  INVALID_FILE_ATTRIBUTES = DWORD(-1);
  FILE_ATTRIBUTE_READONLY = $0000001;
  FILE_ATTRIBUTE_HIDDEN = $0000002;
  FILE_ATTRIBUTE_SYSTEM = $0000004;
  FILE_ATTRIBUTE_DIRECTORY = $0000010;
  FILE_ATTRIBUTE_ARCHIVE = $0000020;
  FILE_ATTRIBUTE_DEVICE = $0000040;
  FILE_ATTRIBUTE_NORMAL = $0000080;
  FILE_ATTRIBUTE_TEMPORARY = $0000100;
  FILE_ATTRIBUTE_SPARSE_FILE = $0000200;
  FILE_ATTRIBUTE_REPARSE_POINT = $0000400;
  FILE_ATTRIBUTE_COMPRESSED = $0000800;
  FILE_ATTRIBUTE_OFFLINE = $0001000;
  FILE_ATTRIBUTE_NOT_CONTENT_INDEXED = $0002000;
  FILE_ATTRIBUTE_ENCRYPTED = $0004000;
  FILE_ATTRIBUTE_INTEGRITY_STREAM = $0008000;
  FILE_ATTRIBUTE_VIRTUAL = $0010000;
  FILE_ATTRIBUTE_NO_SCRUB_DATA = $0020000;
  FILE_ATTRIBUTE_EA = $0040000;
  FILE_ATTRIBUTE_PINNED = $0080000;
  FILE_ATTRIBUTE_UNPINNED = $0100000;
  FILE_ATTRIBUTE_RECALL_ON_OPEN = $0040000;
  FILE_ATTRIBUTE_RECALL_ON_DATA_ACCESS = $0400000;

  FILE_FLAG_WRITE_THROUGH = $80000000;
  FILE_FLAG_OVERLAPPED = $40000000;
  FILE_FLAG_NO_BUFFERING = $20000000;
  FILE_FLAG_RANDOM_ACCESS = $10000000;
  FILE_FLAG_SEQUENTIAL_SCAN = $08000000;
  FILE_FLAG_DELETE_ON_CLOSE = $04000000;
  FILE_FLAG_BACKUP_SEMANTICS = $02000000;
  FILE_FLAG_POSIX_SEMANTICS = $01000000;
  FILE_FLAG_SESSION_AWARE = $00800000;
  FILE_FLAG_OPEN_REPARSE_POINT = $00200000;
  FILE_FLAG_OPEN_NO_RECALL = $00100000;

  FILE_BEGIN = 0;
  FILE_CURRENT = 1;
  FILE_END = 2;

  PAGE_READONLY = 2;
  PAGE_READWRITE = 4;
  PAGE_WRITECOPY = 8;

  SEC_COMMIT = $08000000;
  SEC_LARGE_PAGES = $80000000;

  FILE_MAP_WRITE = $00000002;
  FILE_MAP_READ = $00000004;
  FILE_MAP_LARGE_PAGES = $20000000;

  FIND_FIRST_EX_CASE_SENSITIVE = $00000001;
  FIND_FIRST_EX_LARGE_FETCH = $00000002;
  FIND_FIRST_EX_ON_DISK_ENTRIES_ONLY = $00000004;

  MOVEFILE_REPLACE_EXISTING = 1;
  MOVEFILE_COPY_ALLOWED = 2;
  MOVEFILE_DELAY_UNTIL_REBOOT = 4;
  MOVEFILE_WRITE_THROUGH = 8;
  MOVEFILE_CREATE_HARDLINK = 16;
  MOVEFILE_FAIL_IF_NOT_TRACKABLE = 32;

function CreateFileW(lpFileName: LPCWSTR; dwDesiredAccess: DWORD; dwShareMode: DWORD;
  lpSecurityAttributes: LPSECURITY_ATTRIBUTES; dwCreationDisposition: DWORD; dwFlagsAndAttributes: DWORD;
  hTemplateFile: HANDLE): HANDLE; stdcall; external Kernel32;
function DeleteFileW(lpFileName: LPCWSTR): Bool; stdcall; external Kernel32;
function GetFileSizeEx(hFile: HANDLE; lpFileSize: PLARGE_INTEGER): BOOL; stdcall; external Kernel32;
function ReadFile(hFile: THandle; lpBuffer: LPVOID; nNumberOfBytesToRead: DWORD; lpNumberOfBytesRead: LPDWORD;
  lpOverlapped: POverlapped): BOOL; stdcall; external Kernel32;
function WriteFile(hFile: THandle; lpBuffer: LPVOID; nNumberOfBytesToWrite: DWORD;
  lpNumberOfBytesWritten: LPDWORD; lpOverlapped: POverlapped): BOOL; stdcall; external Kernel32;
function SetFilePointerEx(hFile: THandle; liDistanceToMove: LARGE_INTEGER; const lpNewFilePointer: PLARGE_INTEGER;
  dwMoveMethod: DWORD): BOOL; stdcall; external Kernel32;
function GetFileAttributesW(lpFileName: LPCWSTR): DWORD; stdcall; external Kernel32;
function GetFileAttributesExW(lpFileName: LPCWSTR; fInfoLevelId: GET_FILEEX_INFO_LEVELS; lpFileInformation: LPVOID): BOOL;
  stdcall; external Kernel32;
function SetFileAttributesW(lpFileName: LPCWSTR; dwFileAttributes: DWORD): BOOL; stdcall; external Kernel32;
function SetFileTime(hFile: THandle; const lpCreationTime: LPFILETIME; const lpLastAccessTime: LPFILETIME;
  const lpLastWriteTime: LPFILETIME): BOOL; stdcall; external Kernel32;
function SetFileInformationByHandle(hFile: THandle; FileInformationClass: FILE_INFO_BY_HANDLE_CLASS;
  lpFileInformation: LPVOID; dwBufferSize: DWORD): BOOL; stdcall; external Kernel32;
function FileTimeToSystemTime(const lpFileTime: LPFILETIME; lpSystemTime: LPSYSTEMTIME): BOOL; stdcall; external Kernel32;
function SystemTimeToFileTime(const lpSystemTime: LPSYSTEMTIME; lpFileTime: LPFILETIME): BOOL; stdcall; external Kernel32;
function CreateFileMappingW(hFile: HANDLE; lpFileMappingAttributes: LPSECURITY_ATTRIBUTES;
  flProtect: DWORD; dwMaximumSizeHigh: DWORD; dwMaximumSizeLow: DWORD; lpName: LPCWSTR): HANDLE; stdcall; external Kernel32;
function MapViewOfFile(hFileMappingObject: HANDLE; dwDesiredAccess: DWORD; dwFileOffsetHigh: DWORD;
  dwFileOffsetLow: DWORD; dwNumberOfBytesToMap: SIZE_T): LPVOID; stdcall; external Kernel32;
function FlushViewOfFile(lpBaseAddress: LPCVOID; dwNumberOfBytesToFlush: SIZE_T): BOOL; stdcall; external Kernel32;
function UnmapViewOfFile(lpBaseAddress: LPVOID): BOOL; stdcall; external Kernel32;
function MoveFileExW(lpExistingFileName: LPCWSTR; lpNewFileName: LPCWSTR; dwFlags: DWORD): BOOL; stdcall; external Kernel32;

//Directory
function CreateDirectoryW(lpPathName: LPCWSTR; lpSecurityAttributes: LPSECURITY_ATTRIBUTES): BOOL;
  stdcall; external Kernel32;
function RemoveDirectoryW(lpPathName: LPCWSTR): BOOL; stdcall; external Kernel32;

//Find
function FindFirstFileExW(lpFileName: LPCWSTR; fInfoLevelId: FINDEX_INFO_LEVELS; lpFindFileData: LPVOID;
  fSearchOp: FINDEX_SEARCH_OPS; lpSearchFilter: LPVOID; dwAdditionalFlags: DWORD): HANDLE; stdcall; external Kernel32;
function FindNextFileW(hFindFile: HANDLE; lpFindFileData: LPWIN32_FIND_DATAW): BOOL; stdcall; external Kernel32;
function FindClose(hFindFile: HANDLE): BOOL; stdcall; external Kernel32;

//Error
const
  ERROR_SUCCESS = $00000000;
  NERR_Success = $00000000;
  ERROR_INVALID_FUNCTION = $00000001;
  ERROR_FILE_NOT_FOUND = $00000002;
  ERROR_PATH_NOT_FOUND = $00000003;
  ERROR_TOO_MANY_OPEN_FILES = $00000004;
  ERROR_ACCESS_DENIED = $00000005;
  ERROR_INVALID_HANDLE = $00000006;
  ERROR_ARENA_TRASHED = $00000007;
  ERROR_NOT_ENOUGH_MEMORY = $00000008;
  ERROR_INVALID_BLOCK = $00000009;
  ERROR_BAD_ENVIRONMEN = $0000000A;
  ERROR_BAD_FORMAT = $0000000B;
  ERROR_INVALID_ACCESS = $0000000C;
  ERROR_INVALID_DATA = $0000000D;
  ERROR_OUTOFMEMORY = $0000000E;
  ERROR_INVALID_DRIVE = $0000000F;
  ERROR_ALREADY_EXISTS = $000000B7;
  ERROR_DISK_FULL = $00000070;

function GetLastError: DWORD; stdcall; external Kernel32;

//Message
const
  FORMAT_MESSAGE_ALLOCATE_BUFFER = $00000100;
  FORMAT_MESSAGE_ARGUMENT_ARRAY = $00002000;
  FORMAT_MESSAGE_FROM_HMODULE = $00000800;
  FORMAT_MESSAGE_FROM_STRING = $00000400;
  FORMAT_MESSAGE_FROM_SYSTEM = $00001000;
  FORMAT_MESSAGE_IGNORE_INSERTS = $00000200;
  FORMAT_MESSAGE_MAX_WIDTH_MASK = $000000FF;

function FormatMessageW(dwFlags: DWORD; lpSource: LPCVOID; dwMessageId: DWORD; dwLanguageId: DWORD;
  lpBuffer: LPWSTR; nSize: DWORD; Arguments: Ptr): DWORD; stdcall; external Kernel32;

//Time
procedure Sleep(dwMilliseconds: DWORD); stdcall; external Kernel32;
function QueryPerformanceCounter(lpPerformanceCount: PLARGE_INTEGER): BOOL; stdcall; external Kernel32;
function QueryPerformanceFrequency(lpFrequency: PLARGE_INTEGER): BOOL; stdcall; external Kernel32;
procedure GetSystemTimeAsFileTime(lpSystemTimeAsFileTime: LPFILETIME); stdcall; external Kernel32;

//Console
type
  CONSOLE_CURSOR_INFO = record
    dwSize: DWORD;
    bVisible: BOOL;
  end;
  PCONSOLE_CURSOR_INFO = ^CONSOLE_CURSOR_INFO;
  PHANDLER_ROUTINE = function(dwCtrlType: DWORD): BOOL; stdcall;

const
  CTRL_C_EVENT = 0;
  CTRL_BREAK_EVENT = 1;
  CTRL_CLOSE_EVENT = 3;
  CTRL_LOGOFF_EVENT = 5;
  CTRL_SHUTDOWN_EVENT = 6;

function SetConsoleOutputCP(wCodePageID: UINT): BOOL; stdcall; external Kernel32;
function GetConsoleCursorInfo(hConsoleOutput: HANDLE; lpConsoleCursorInfo: PCONSOLE_CURSOR_INFO): BOOL;
  stdcall; external Kernel32;
function SetConsoleCursorInfo(hConsoleOutput: HANDLE; const lpConsoleCursorInfo: PCONSOLE_CURSOR_INFO): BOOL;
  stdcall; external Kernel32;
function SetConsoleCtrlHandler(HandlerRoutine: PHANDLER_ROUTINE; Add: BOOL): BOOL; stdcall; external Kernel32;

//Exception
const
  EXCEPTION_MAXIMUM_PARAMETERS = 15;

type
  EXCEPTION_RECORD = record
    ExceptionCode: DWORD;
    ExceptionFlags: DWORD;
    ExceptionRecord: ^EXCEPTION_RECORD;
    ExceptionAddress: PVOID;
    NumberParameters: DWORD;
    ExceptionInformation: array[0..(EXCEPTION_MAXIMUM_PARAMETERS) - 1] of ULONG_PTR;
  end;

implementation

end.
