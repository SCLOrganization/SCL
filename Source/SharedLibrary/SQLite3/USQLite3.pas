unit USQLite3;

{$I SCL.inc}

interface

uses
  UNumber, UString;

type
  int = I32;
  Pint = ^int;
  unsigned_int = U32;
  unsigned_char = U8;
  double = F64;
  Pdouble = ^double;

  sqlite_int64 = I64;
  sqlite_uint64 = U64;
  sqlite3_int64 = sqlite_int64;
  Psqlite3_int64 = ^sqlite3_int64;
  sqlite3_uint64 = sqlite_uint64;

  sqlite3 = record;
  Psqlite3 = ^sqlite3;
  PPsqlite3 = ^Psqlite3;

  sqlite3_value = record;
  Psqlite3_value = ^sqlite3_value;
  PPsqlite3_value = ^Psqlite3_value;

  sqlite3_stmt = record;
  Psqlite3_stmt = ^sqlite3_stmt;
  PPsqlite3_stmt = ^Psqlite3_stmt;

  sqlite3_context = record;
  Psqlite3_context = ^sqlite3_context;

  sqlite3_destroy_function = procedure(p: Ptr); cdecl;
  sqlite3_destructor_type = sqlite3_destroy_function;
  sqlite3_exec_callback = function(data: Ptr; n: int; texts: PPChar; names: PPChar): int; cdecl;
  sqlite3_function_function = procedure(context: Psqlite3_context; argc: int; argv: PPsqlite3_value); cdecl;
  Psqlite3_function_function = ^sqlite3_function_function;
  sqlite3_step_function = procedure(context: Psqlite3_context; argc: int; argv: PPsqlite3_value); cdecl;
  sqlite3_final_function = procedure(context: Psqlite3_context); cdecl;

  Psqlite3_module = ^sqlite3_module;

  sqlite3_vtab = object
    pModule: Psqlite3_module;
    nRef: int;
    zErrMsg: PChar;
  end;
  Psqlite3_vtab = ^sqlite3_vtab;
  PPsqlite3_vtab = ^Psqlite3_vtab;

  sqlite3_index_constraint = record
    iColumn: int;
    op: unsigned_char;
    usable: unsigned_char;
    iTermOffset: int;
  end;
  Psqlite3_index_constraint = ^sqlite3_index_constraint;

  sqlite3_index_orderby = record
    iColumn: int;
    desc: unsigned_char;
  end;
  Psqlite3_index_orderby = ^sqlite3_index_orderby;

  sqlite3_index_constraint_usage = record
    argvIndex: int;
    omit: unsigned_char;
  end;
  Psqlite3_index_constraint_usage = ^sqlite3_index_constraint_usage;

  sqlite3_index_info = record
    nConstraint: int;
    aConstraint: Psqlite3_index_constraint;
    nOrderBy: int;
    aOrderBy: Psqlite3_index_orderby;
    aConstraintUsage: Psqlite3_index_constraint_usage;
    idxNum: int;
    idxStr: PChar;
    needToFreeIdxStr: int;
    orderByConsumed: int;
    estimatedCost: double;
    estimatedRows: sqlite3_int64;
    idxFlags: int;
    colUsed: sqlite3_uint64;
  end;
  Psqlite3_index_info = ^sqlite3_index_info;

  sqlite3_vtab_cursor = object
    pVtab: Psqlite3_vtab;
  end;
  Psqlite3_vtab_cursor = ^sqlite3_vtab_cursor;
  PPsqlite3_vtab_cursor = ^Psqlite3_vtab_cursor;

  sqlite3_module = record
    iVersion: int;
    xCreate: function(db: Psqlite3; pAux: Ptr; argc: int; const argv: PPChar; ppVTab: PPsqlite3_vtab;
      pzErr: PPChar): int; cdecl;
    xConnect: function(db: Psqlite3; pAux: Ptr; argc: int; const argv: PPChar; ppVTab: PPsqlite3_vtab;
      pzErr: PPChar): int; cdecl;
    xBestIndex: function(pVTab: Psqlite3_vtab; pInfo: Psqlite3_index_info): int; cdecl;
    xDisconnect: function(pVTab: Psqlite3_vtab): int; cdecl;
    xDestroy: function(pVTab: Psqlite3_vtab): int; cdecl;
    xOpen: function(pVTab: Psqlite3_vtab; ppCursor: PPsqlite3_vtab_cursor): int; cdecl;
    xClose: function(pVtabCursor: Psqlite3_vtab_cursor): int; cdecl;
    xFilter: function(pVtabCursor: Psqlite3_vtab_cursor; idxNum: int; const idxStr: PChar;
      argc: int; argv: PPsqlite3_value): int; cdecl;
    xNext: function(pVtabCursor: Psqlite3_vtab_cursor): int; cdecl;
    xEof: function(pVtabCursor: Psqlite3_vtab_cursor): int; cdecl;
    xColumn: function(pVtabCursor: Psqlite3_vtab_cursor; sContext: Psqlite3_context; n: int): int; cdecl;
    xRowid: function(pVtabCursor: Psqlite3_vtab_cursor; pRowid: Psqlite3_int64): int; cdecl;
    xUpdate: function(pVTab: Psqlite3_vtab; argc: int; argv: PPsqlite3_value; pRowid: Psqlite3_int64): int; cdecl;
    xBegin: function(pVTab: Psqlite3_vtab): int; cdecl;
    xSync: function(pVTab: Psqlite3_vtab): int; cdecl;
    xCommit: function(pVTab: Psqlite3_vtab): int; cdecl;
    xRollback: function(pVTab: Psqlite3_vtab): int; cdecl;
    xFindFunction: function(pVTab: Psqlite3_vtab; nArg: int; const zName: PChar;
      pxFunc: Psqlite3_function_function; ppArg: PPtr): int; cdecl;
    xRename: function(pVTab: Psqlite3_vtab; const zNew: PChar): int; cdecl;
    xSavepoint: function(pVTab: Psqlite3_vtab; iSavepoint: int): int; cdecl;
    xRelease: function(pVTab: Psqlite3_vtab; iSavepoint: int): int; cdecl;
    xRollbackTo: function(pVTab: Psqlite3_vtab; iSavepoint: int): int; cdecl;
  end;

  Psqlite3_io_methods = ^sqlite3_io_methods;

  sqlite3_file = object
    pMethods: Psqlite3_io_methods;
  end;
  Psqlite3_file = ^sqlite3_file;

  sqlite3_io_methods = record
    iVersion: int;
    xClose: function(pFile: Psqlite3_file): int; cdecl;
    xRead: function(pFile: Psqlite3_file; zBuf: Ptr; iAmt: int; iOfst: sqlite3_int64): int; cdecl;
    xWrite: function(pFile: Psqlite3_file; const zBuf: Ptr; iAmt: int; iOfst: sqlite3_int64): int; cdecl;
    xTruncate: function(pFile: Psqlite3_file; size: sqlite3_int64): int; cdecl;
    xSync: function(pFile: Psqlite3_file; flags: int): int; cdecl;
    xFileSize: function(pFile: Psqlite3_file; pSize: Psqlite3_int64): int; cdecl;
    xLock: function(pFile: Psqlite3_file; eLock: int): int; cdecl;
    xUnlock: function(pFile: Psqlite3_file; eLock: int): int; cdecl;
    xCheckReservedLock: function(pFile: Psqlite3_file; pResOut: Pint): int; cdecl;
    xFileControl: function(pFile: Psqlite3_file; op: int; pArg: Ptr): int; cdecl;
    xSectorSize: function(pFile: Psqlite3_file): int; cdecl;
    xDeviceCharacteristics: function(pFile: Psqlite3_file): int; cdecl;
    xShmMap: function(pFile: Psqlite3_file; iPg: int; pgsz: int; isWrite: int; volatile: PPtr): int; cdecl;
    xShmLock: function(pFile: Psqlite3_file; offset: int; n: int; flags: int): int; cdecl;
    xShmBarrier: procedure(pFile: Psqlite3_file); cdecl;
    xShmUnmap: function(pFile: Psqlite3_file; deleteFlag: int): int; cdecl;
    xFetch: function(pFile: Psqlite3_file; iOfst: sqlite3_int64; iAmt: int; pp: PPtr): int; cdecl;
    xUnfetch: function(pFile: Psqlite3_file; iOfst: sqlite3_int64; iAmt: int; p: Ptr): int; cdecl;
  end;

  sqlite3_syscall_ptr = procedure(); cdecl;

  sqlite3_filename = PChar;
  Psqlite3_vfs = ^sqlite3_vfs;

  sqlite3_vfs = record
    iVersion: int;
    szOsFile: int;
    mxPathname: int;
    pNext: Psqlite3_vfs;
    zName: PChar;
    pAppData: Ptr;
    xOpen: function(pVfs: Psqlite3_vfs; zName: sqlite3_filename; pfile: Psqlite3_file; flags: int;
      pOutFlags: Pint): int; cdecl;
    xDelete: function(pVfs: Psqlite3_vfs; const zName: PChar; syncDir: int): int; cdecl;
    xAccess: function(pVfs: Psqlite3_vfs; const zName: PChar; flags: int; pResOut: Pint): int; cdecl;
    xFullPathname: function(pVfs: Psqlite3_vfs; const zName: PChar; nOut: int; zOut: PChar): int; cdecl;
    xDlOpen: function(pVfs: Psqlite3_vfs; const zFilename: PChar): Ptr; cdecl;
    xDlError: procedure(pVfs: Psqlite3_vfs; nByte: int; zErrMsg: PChar); cdecl;
    xDlSym: function(pVfs: Psqlite3_vfs; pHandle: Ptr; const zSymbol: PChar): Ptr; cdecl;
    xDlClose: procedure(pVfs: Psqlite3_vfs; pHandle: Ptr); cdecl;
    xRandomness: function(pVfs: Psqlite3_vfs; nByte: int; zOut: PChar): int; cdecl;
    xSleep: function(pVfs: Psqlite3_vfs; microseconds: int): int; cdecl;
    xCurrentTime: function(pVfs: Psqlite3_vfs; pTimeOut: Pdouble): int; cdecl;
    xGetLastError: function(pVfs: Psqlite3_vfs; iErr: int; zErr: PChar): int; cdecl;
    xCurrentTimeInt64: function(pVfs: Psqlite3_vfs; pTimeOut: Psqlite3_int64): int; cdecl;
    xSetSystemCall: function(pVfs: Psqlite3_vfs; const zName: PChar; v: sqlite3_syscall_ptr): int; cdecl;
    xGetSystemCall: function(pVfs: Psqlite3_vfs; const zName: PChar): sqlite3_syscall_ptr; cdecl;
    xNextSystemCall: function(pVfs: Psqlite3_vfs; const zName: PChar): PChar; cdecl;
  end;

const
  SQLITE_OPEN_READONLY = $00000001;
  SQLITE_OPEN_READWRITE = $00000002;
  SQLITE_OPEN_CREATE = $00000004;
  SQLITE_OPEN_DELETEONCLOSE = $00000008;
  SQLITE_OPEN_EXCLUSIVE = $00000010;
  SQLITE_OPEN_AUTOPROXY = $00000020;
  SQLITE_OPEN_URI = $00000040;
  SQLITE_OPEN_MEMORY = $00000080;
  SQLITE_OPEN_MAIN_DB = $00000100;
  SQLITE_OPEN_TEMP_DB = $00000200;
  SQLITE_OPEN_TRANSIENT_DB = $00000400;
  SQLITE_OPEN_MAIN_JOURNAL = $00000800;
  SQLITE_OPEN_TEMP_JOURNAL = $00001000;
  SQLITE_OPEN_SUBJOURNAL = $00002000;
  SQLITE_OPEN_SUPER_JOURNAL = $00004000;
  SQLITE_OPEN_NOMUTEX = $00008000;
  SQLITE_OPEN_FULLMUTEX = $00010000;
  SQLITE_OPEN_SHAREDCACHE = $00020000;
  SQLITE_OPEN_PRIVATECACHE = $00040000;
  SQLITE_OPEN_WAL = $00080000;
  SQLITE_OPEN_NOFOLLOW = $01000000;
  SQLITE_OPEN_EXRESCODE = $02000000;

  SQLITE_OK = 0;
  SQLITE_ERROR = 1;
  SQLITE_INTERNAL = 2;
  SQLITE_PERM = 3;
  SQLITE_ABORT = 4;
  SQLITE_BUSY = 5;
  SQLITE_LOCKED = 6;
  SQLITE_NOMEM = 7;
  SQLITE_READONLY = 8;
  SQLITE_INTERRUPT = 9;
  SQLITE_IOERR = 10;
  SQLITE_CORRUPT = 11;
  SQLITE_NOTFOUND = 12;
  SQLITE_FULL = 13;
  SQLITE_CANTOPEN = 14;
  SQLITE_PROTOCOL = 15;
  SQLITE_EMPTY = 16;
  SQLITE_SCHEMA = 17;
  SQLITE_TOOBIG = 18;
  SQLITE_CONSTRAINT = 19;
  SQLITE_MISMATCH = 20;
  SQLITE_MISUSE = 21;
  SQLITE_NOLFS = 22;
  SQLITE_AUTH = 23;
  SQLITE_FORMAT = 24;
  SQLITE_RANGE = 25;
  SQLITE_NOTADB = 26;
  SQLITE_NOTICE = 27;
  SQLITE_WARNING = 28;
  SQLITE_ROW = 100;
  SQLITE_DONE = 101;

  SQLITE_ERROR_MISSING_COLLSEQ = (SQLITE_ERROR or (1 shl 8));
  SQLITE_ERROR_RETRY = (SQLITE_ERROR or (2 shl 8));
  SQLITE_ERROR_SNAPSHOT = (SQLITE_ERROR or (3 shl 8));
  SQLITE_IOERR_READ = (SQLITE_IOERR or (1 shl 8));
  SQLITE_IOERR_SHORT_READ = (SQLITE_IOERR or (2 shl 8));
  SQLITE_IOERR_WRITE = (SQLITE_IOERR or (3 shl 8));
  SQLITE_IOERR_FSYNC = (SQLITE_IOERR or (4 shl 8));
  SQLITE_IOERR_DIR_FSYNC = (SQLITE_IOERR or (5 shl 8));
  SQLITE_IOERR_TRUNCATE = (SQLITE_IOERR or (6 shl 8));
  SQLITE_IOERR_FSTAT = (SQLITE_IOERR or (7 shl 8));
  SQLITE_IOERR_UNLOCK = (SQLITE_IOERR or (8 shl 8));
  SQLITE_IOERR_RDLOCK = (SQLITE_IOERR or (9 shl 8));
  SQLITE_IOERR_DELETE = (SQLITE_IOERR or (10 shl 8));
  SQLITE_IOERR_BLOCKED = (SQLITE_IOERR or (11 shl 8));
  SQLITE_IOERR_NOMEM = (SQLITE_IOERR or (12 shl 8));
  SQLITE_IOERR_ACCESS = (SQLITE_IOERR or (13 shl 8));
  SQLITE_IOERR_CHECKRESERVEDLOCK = (SQLITE_IOERR or (14 shl 8));
  SQLITE_IOERR_LOCK = (SQLITE_IOERR or (15 shl 8));
  SQLITE_IOERR_CLOSE = (SQLITE_IOERR or (16 shl 8));
  SQLITE_IOERR_DIR_CLOSE = (SQLITE_IOERR or (17 shl 8));
  SQLITE_IOERR_SHMOPEN = (SQLITE_IOERR or (18 shl 8));
  SQLITE_IOERR_SHMSIZE = (SQLITE_IOERR or (19 shl 8));
  SQLITE_IOERR_SHMLOCK = (SQLITE_IOERR or (20 shl 8));
  SQLITE_IOERR_SHMMAP = (SQLITE_IOERR or (21 shl 8));
  SQLITE_IOERR_SEEK = (SQLITE_IOERR or (22 shl 8));
  SQLITE_IOERR_DELETE_NOENT = (SQLITE_IOERR or (23 shl 8));
  SQLITE_IOERR_MMAP = (SQLITE_IOERR or (24 shl 8));
  SQLITE_IOERR_GETTEMPPATH = (SQLITE_IOERR or (25 shl 8));
  SQLITE_IOERR_CONVPATH = (SQLITE_IOERR or (26 shl 8));
  SQLITE_IOERR_VNODE = (SQLITE_IOERR or (27 shl 8));
  SQLITE_IOERR_AUTH = (SQLITE_IOERR or (28 shl 8));
  SQLITE_IOERR_BEGIN_ATOMIC = (SQLITE_IOERR or (29 shl 8));
  SQLITE_IOERR_COMMIT_ATOMIC = (SQLITE_IOERR or (30 shl 8));
  SQLITE_IOERR_ROLLBACK_ATOMIC = (SQLITE_IOERR or (31 shl 8));
  SQLITE_IOERR_DATA = (SQLITE_IOERR or (32 shl 8));
  SQLITE_IOERR_CORRUPTFS = (SQLITE_IOERR or (33 shl 8));
  SQLITE_LOCKED_SHAREDCACHE = (SQLITE_LOCKED or (1 shl 8));
  SQLITE_LOCKED_VTAB = (SQLITE_LOCKED or (2 shl 8));
  SQLITE_BUSY_RECOVERY = (SQLITE_BUSY or (1 shl 8));
  SQLITE_BUSY_SNAPSHOT = (SQLITE_BUSY or (2 shl 8));
  SQLITE_BUSY_TIMEOUT = (SQLITE_BUSY or (3 shl 8));
  SQLITE_CANTOPEN_NOTEMPDIR = (SQLITE_CANTOPEN or (1 shl 8));
  SQLITE_CANTOPEN_ISDIR = (SQLITE_CANTOPEN or (2 shl 8));
  SQLITE_CANTOPEN_FULLPATH = (SQLITE_CANTOPEN or (3 shl 8));
  SQLITE_CANTOPEN_CONVPATH = (SQLITE_CANTOPEN or (4 shl 8));
  SQLITE_CANTOPEN_DIRTYWAL = (SQLITE_CANTOPEN or (5 shl 8));
  SQLITE_CANTOPEN_SYMLINK = (SQLITE_CANTOPEN or (6 shl 8));
  SQLITE_CORRUPT_VTAB = (SQLITE_CORRUPT or (1 shl 8));
  SQLITE_CORRUPT_SEQUENCE = (SQLITE_CORRUPT or (2 shl 8));
  SQLITE_CORRUPT_INDEX = (SQLITE_CORRUPT or (3 shl 8));
  SQLITE_READONLY_RECOVERY = (SQLITE_READONLY or (1 shl 8));
  SQLITE_READONLY_CANTLOCK = (SQLITE_READONLY or (2 shl 8));
  SQLITE_READONLY_ROLLBACK = (SQLITE_READONLY or (3 shl 8));
  SQLITE_READONLY_DBMOVED = (SQLITE_READONLY or (4 shl 8));
  SQLITE_READONLY_CANTINIT = (SQLITE_READONLY or (5 shl 8));
  SQLITE_READONLY_DIRECTORY = (SQLITE_READONLY or (6 shl 8));
  SQLITE_ABORT_ROLLBACK = (SQLITE_ABORT or (2 shl 8));
  SQLITE_CONSTRAINT_CHECK = (SQLITE_CONSTRAINT or (1 shl 8));
  SQLITE_CONSTRAINT_COMMITHOOK = (SQLITE_CONSTRAINT or (2 shl 8));
  SQLITE_CONSTRAINT_FOREIGNKEY = (SQLITE_CONSTRAINT or (3 shl 8));
  SQLITE_CONSTRAINT_FUNCTION = (SQLITE_CONSTRAINT or (4 shl 8));
  SQLITE_CONSTRAINT_NOTNULL = (SQLITE_CONSTRAINT or (5 shl 8));
  SQLITE_CONSTRAINT_PRIMARYKEY = (SQLITE_CONSTRAINT or (6 shl 8));
  SQLITE_CONSTRAINT_TRIGGER = (SQLITE_CONSTRAINT or (7 shl 8));
  SQLITE_CONSTRAINT_UNIQUE = (SQLITE_CONSTRAINT or (8 shl 8));
  SQLITE_CONSTRAINT_VTAB = (SQLITE_CONSTRAINT or (9 shl 8));
  SQLITE_CONSTRAINT_ROWID = (SQLITE_CONSTRAINT or (10 shl 8));
  SQLITE_CONSTRAINT_PINNED = (SQLITE_CONSTRAINT or (11 shl 8));
  SQLITE_NOTICE_RECOVER_WAL = (SQLITE_NOTICE or (1 shl 8));
  SQLITE_NOTICE_RECOVER_ROLLBACK = (SQLITE_NOTICE or (2 shl 8));
  SQLITE_WARNING_AUTOINDEX = (SQLITE_WARNING or (1 shl 8));
  SQLITE_AUTH_USER = (SQLITE_AUTH or (1 shl 8));
  SQLITE_OK_LOAD_PERMANENTLY = (SQLITE_OK or (1 shl 8));
  SQLITE_OK_SYMLINK = (SQLITE_OK or (2 shl 8));

  SQLITE_STATIC = Ptr(0);
  SQLITE_TRANSIENT = Ptr(-1);

  SQLITE_INTEGER = 1;
  SQLITE_FLOAT = 2;
  SQLITE_TEXT = 3;
  SQLITE_BLOB = 4;
  SQLITE_NULL = 5;

  SQLITE_UTF8 = 1;
  SQLITE_UTF16LE = 2;
  SQLITE_UTF16BE = 3;
  SQLITE_UTF16 = 4;
  SQLITE_UTF16_ALIGNED = 8;

  SQLITE_CONFIG_SINGLETHREAD = 1;
  SQLITE_CONFIG_MULTITHREAD = 2;
  SQLITE_CONFIG_SERIALIZED = 3;
  SQLITE_CONFIG_MALLOC = 4;
  SQLITE_CONFIG_GETMALLOC = 5;
  SQLITE_CONFIG_SCRATCH = 6;
  SQLITE_CONFIG_PAGECACHE = 7;
  SQLITE_CONFIG_HEAP = 8;
  SQLITE_CONFIG_MEMSTATUS = 9;
  SQLITE_CONFIG_MUTEX = 10;
  SQLITE_CONFIG_GETMUTEX = 11;
  SQLITE_CONFIG_CHUNKALLOC = 12;
  SQLITE_CONFIG_LOOKASIDE = 13;
  SQLITE_CONFIG_PCACHE = 14;
  SQLITE_CONFIG_GETPCACHE = 15;
  SQLITE_CONFIG_LOG = 16;
  SQLITE_CONFIG_URI = 17;
  SQLITE_CONFIG_PCACHE2 = 18;
  SQLITE_CONFIG_GETPCACHE2 = 19;
  SQLITE_CONFIG_COVERING_INDEX_SCAN = 20;
  SQLITE_CONFIG_SQLLOG = 21;
  SQLITE_CONFIG_MMAP_SIZE = 22;
  SQLITE_CONFIG_WIN32_HEAPSIZE = 23;
  SQLITE_CONFIG_PCACHE_HDRSZ = 24;
  SQLITE_CONFIG_PMASZ = 25;
  SQLITE_CONFIG_STMTJRNL_SPILL = 26;
  SQLITE_CONFIG_SMALL_MALLOC = 27;
  SQLITE_CONFIG_SORTERREF_SIZE = 28;
  SQLITE_CONFIG_MEMDB_MAXSIZE = 29;

  SQLITE_DBCONFIG_MAINDBNAME = 1000;
  SQLITE_DBCONFIG_LOOKASIDE = 1001;
  SQLITE_DBCONFIG_ENABLE_FKEY = 1002;
  SQLITE_DBCONFIG_ENABLE_TRIGGER = 1003;
  SQLITE_DBCONFIG_ENABLE_FTS3_TOKENIZER = 1004;
  SQLITE_DBCONFIG_ENABLE_LOAD_EXTENSION = 1005;
  SQLITE_DBCONFIG_NO_CKPT_ON_CLOSE = 1006;
  SQLITE_DBCONFIG_ENABLE_QPSG = 1007;
  SQLITE_DBCONFIG_TRIGGER_EQP = 1008;
  SQLITE_DBCONFIG_RESET_DATABASE = 1009;
  SQLITE_DBCONFIG_DEFENSIVE = 1010;
  SQLITE_DBCONFIG_WRITABLE_SCHEMA = 1011;
  SQLITE_DBCONFIG_LEGACY_ALTER_TABLE = 1012;
  SQLITE_DBCONFIG_DQS_DML = 1013;
  SQLITE_DBCONFIG_DQS_DDL = 1014;
  SQLITE_DBCONFIG_ENABLE_VIEW = 1015;
  SQLITE_DBCONFIG_LEGACY_FILE_FORMAT = 1016;
  SQLITE_DBCONFIG_TRUSTED_SCHEMA = 1017;
  SQLITE_DBCONFIG_STMT_SCANSTATUS = 1018;
  SQLITE_DBCONFIG_REVERSE_SCANORDER = 1019;
  SQLITE_DBCONFIG_MAX = 1019;

  SQLITE_INDEX_SCAN_UNIQUE = 1;
  SQLITE_INDEX_CONSTRAINT_EQ = 2;
  SQLITE_INDEX_CONSTRAINT_GT = 4;
  SQLITE_INDEX_CONSTRAINT_LE = 8;
  SQLITE_INDEX_CONSTRAINT_LT = 16;
  SQLITE_INDEX_CONSTRAINT_GE = 32;
  SQLITE_INDEX_CONSTRAINT_MATCH = 64;
  SQLITE_INDEX_CONSTRAINT_LIKE = 65;
  SQLITE_INDEX_CONSTRAINT_GLOB = 66;
  SQLITE_INDEX_CONSTRAINT_REGEXP = 67;
  SQLITE_INDEX_CONSTRAINT_NE = 68;
  SQLITE_INDEX_CONSTRAINT_ISNOT = 69;
  SQLITE_INDEX_CONSTRAINT_ISNOTNULL = 70;
  SQLITE_INDEX_CONSTRAINT_ISNULL = 71;
  SQLITE_INDEX_CONSTRAINT_IS = 72;
  SQLITE_INDEX_CONSTRAINT_LIMIT = 73;
  SQLITE_INDEX_CONSTRAINT_OFFSET = 74;
  SQLITE_INDEX_CONSTRAINT_FUNCTION = 150;

  SQLITE_DETERMINISTIC = $000000800;
  SQLITE_DIRECTONLY = $000080000;
  SQLITE_SUBTYPE = $000100000;
  SQLITE_INNOCUOUS = $000200000;

  SQLITE_LIMIT_LENGTH = 0;
  SQLITE_LIMIT_SQL_LENGTH = 1;
  SQLITE_LIMIT_COLUMN = 2;
  SQLITE_LIMIT_EXPR_DEPTH = 3;
  SQLITE_LIMIT_COMPOUND_SELECT = 4;
  SQLITE_LIMIT_VDBE_OP = 5;
  SQLITE_LIMIT_FUNCTION_ARG = 6;
  SQLITE_LIMIT_ATTACHED = 7;
  SQLITE_LIMIT_LIKE_PATTERN_LENGTH = 8;
  SQLITE_LIMIT_VARIABLE_NUMBER = 9;
  SQLITE_LIMIT_TRIGGER_DEPTH = 10;
  SQLITE_LIMIT_WORKER_THREADS = 11;

  SQLITE_STATUS_MEMORY_USED = 0;
  SQLITE_STATUS_PAGECACHE_USED = 1;
  SQLITE_STATUS_PAGECACHE_OVERFLOW = 2;
  SQLITE_STATUS_SCRATCH_USED = 3;
  SQLITE_STATUS_SCRATCH_OVERFLOW = 4;
  SQLITE_STATUS_MALLOC_SIZE = 5;
  SQLITE_STATUS_PARSER_STACK = 6;
  SQLITE_STATUS_PAGECACHE_SIZE = 7;
  SQLITE_STATUS_SCRATCH_SIZE = 8;
  SQLITE_STATUS_MALLOC_COUNT = 9;

function sqlite3_initialize: int; cdecl; external;
function sqlite3_shutdown: int; cdecl; external;
function sqlite3_libversion: PChar; cdecl; external;
function sqlite3_libversion_number: int; cdecl; external;
function sqlite3_sourceid: PChar; cdecl; external;
function sqlite3_threadsafe: int; cdecl; external;
function sqlite3_status64(op: int; pCurrent: Psqlite3_int64; pHighwater: Psqlite3_int64; resetFlag: int): int;
  cdecl; external;
function sqlite3_config(op: int): int; cdecl varargs; external;
procedure sqlite3_log(iErrCode: int; const zFormat: PChar); cdecl varargs; external;

function sqlite3_errcode(db: Psqlite3): int; cdecl; external;
function sqlite3_extended_errcode(db: Psqlite3): int; cdecl; external;
function sqlite3_errmsg(db: Psqlite3): PChar; cdecl; external;
function sqlite3_errstr(Code: int): PChar; cdecl; external;
function sqlite3_system_errno(db: Psqlite3): int; cdecl; external;
function sqlite3_extended_result_codes(db: Psqlite3; OnOff: int): int; cdecl; external;
function sqlite3_error_offset(db: Psqlite3): int; cdecl; external;

function sqlite3_last_insert_rowid(db: Psqlite3): sqlite3_int64; cdecl; external;
procedure sqlite3_set_last_insert_rowid(db: Psqlite3; value: sqlite3_int64); cdecl; external;

function sqlite3_malloc(n: int): Ptr; cdecl; external;
function sqlite3_malloc64(n: sqlite3_uint64): Ptr; cdecl; external;
function sqlite3_realloc(pOld: Ptr; n: int): Ptr; cdecl; external;
function sqlite3_realloc64(pOld: Ptr; n: sqlite3_uint64): Ptr; cdecl; external;
procedure sqlite3_free(p: Ptr); cdecl; external;
function sqlite3_msize(p: Ptr): sqlite3_uint64; cdecl; external;

function sqlite3_open(const filename: PChar; ppDb: PPsqlite3): int; cdecl; external;
function sqlite3_open_v2(const filename: PChar; ppDb: PPsqlite3; flags: int; zVfs: PChar): int; cdecl; external;
function sqlite3_close(db: Psqlite3): int; cdecl; external;
function sqlite3_db_readonly(db: Psqlite3; const zDbName: PChar): int; cdecl; external;
function sqlite3_db_config(db: Psqlite3; op: int): int; cdecl varargs; external;
function sqlite3_exec(db: Psqlite3; const sql: PChar; callback: sqlite3_exec_callback; data: Ptr; errmsg: PPChar): int;
  cdecl; external;

function sqlite3_limit(db: Psqlite3; id: int; newVal: int): int; cdecl; external;

function sqlite3_prepare_v2(db: Psqlite3; const zSql: PChar; nByte: int; ppStmt: PPsqlite3_stmt;
  const pzTail: PPChar): int; cdecl; external;
function sqlite3_prepare_v3(db: Psqlite3; const zSql: PChar; nByte: int; prepFlags: unsigned_int;
  ppStmt: PPsqlite3_stmt; const pzTail: PPChar): int; cdecl; external;
function sqlite3_step(pStmt: Psqlite3_stmt): int; cdecl; external;
function sqlite3_reset(pStmt: Psqlite3_stmt): int; cdecl; external;
function sqlite3_finalize(pStmt: Psqlite3_stmt): int; cdecl; external;

function sqlite3_sql(pStmt: Psqlite3_stmt): PChar; cdecl; external;
function sqlite3_expanded_sql(pStmt: Psqlite3_stmt): PChar; cdecl; external;
function sqlite3_normalized_sql(pStmt: Psqlite3_stmt): PChar; cdecl; external;
function sqlite3_column_count(pStmt: Psqlite3_stmt): int; cdecl; external;
function sqlite3_column_name(pStmt: Psqlite3_stmt; N: int): PChar; cdecl; external;
function sqlite3_column_database_name(pStmt: Psqlite3_stmt; N: int): PChar; cdecl; external;
function sqlite3_column_table_name(pStmt: Psqlite3_stmt; N: int): PChar; cdecl; external;
function sqlite3_column_origin_name(pStmt: Psqlite3_stmt; N: int): PChar; cdecl; external;
function sqlite3_column_decltype(pStmt: Psqlite3_stmt; N: int): PChar; cdecl; external;
function sqlite3_bind_parameter_count(pStmt: Psqlite3_stmt): int; cdecl; external;

function sqlite3_bind_blob(pStmt: Psqlite3_stmt; index: int; const value: Ptr; n: int;
  destroy: sqlite3_destructor_type): int; cdecl; external;
function sqlite3_bind_blob64(pStmt: Psqlite3_stmt; index: int; const value: Ptr; n: sqlite3_uint64;
  destroy: sqlite3_destructor_type): int; cdecl; external;
function sqlite3_bind_double(pStmt: Psqlite3_stmt; index: int; value: double): int; cdecl; external;
function sqlite3_bind_int(pStmt: Psqlite3_stmt; index: int; value: int): int; cdecl; external;
function sqlite3_bind_int64(pStmt: Psqlite3_stmt; index: int; value: sqlite3_int64): int; cdecl; external;
function sqlite3_bind_null(pStmt: Psqlite3_stmt; index: int): int; cdecl; external;
function sqlite3_bind_text(pStmt: Psqlite3_stmt; index: int; const value: PChar; bytes: int;
  destroy: sqlite3_destructor_type): int; cdecl; external;
function sqlite3_bind_text64(pStmt: Psqlite3_stmt; index: int; const value: PChar; bytes: sqlite3_uint64;
  destroy: sqlite3_destructor_type; encoding: unsigned_char): int; cdecl; external;
function sqlite3_bind_value(pStmt: Psqlite3_stmt; index: int; const value: Psqlite3_value): int; cdecl; external;
function sqlite3_bind_pointer(pStmt: Psqlite3_stmt; index: int; value: Ptr; const typ: PChar;
  destroy: sqlite3_destructor_type): int; cdecl; external;
function sqlite3_bind_zeroblob(pStmt: Psqlite3_stmt; index: int; size: int): int; cdecl; external;
function sqlite3_bind_zeroblob64(pStmt: Psqlite3_stmt; index: int; size: sqlite3_uint64): int; cdecl; external;
function sqlite3_bind_parameter_index(pStmt: Psqlite3_stmt; zName: PChar): int; cdecl; external;
function sqlite3_bind_parameter_name(pStmt: Psqlite3_stmt; index: int): PChar; cdecl; external;
function sqlite3_clear_bindings(pStmt: Psqlite3_stmt): int; cdecl; external;

function sqlite3_column_blob(pStmt: Psqlite3_stmt; iCol: int): Ptr; cdecl; external;
function sqlite3_column_double(pStmt: Psqlite3_stmt; iCol: int): double; cdecl; external;
function sqlite3_column_int(pStmt: Psqlite3_stmt; iCol: int): int; cdecl; external;
function sqlite3_column_int64(pStmt: Psqlite3_stmt; iCol: int): sqlite3_int64; cdecl; external;
function sqlite3_column_text(pStmt: Psqlite3_stmt; iCol: int): PChar; cdecl; external;
function sqlite3_column_value(pStmt: Psqlite3_stmt; iCol: int): Psqlite3_value; cdecl; external;
function sqlite3_column_bytes(pStmt: Psqlite3_stmt; iCol: int): int; cdecl; external;
function sqlite3_column_type(pStmt: Psqlite3_stmt; iCol: int): int; cdecl; external;

function sqlite3_value_blob(value: Psqlite3_value): Ptr; cdecl; external;
function sqlite3_value_double(value: Psqlite3_value): double; cdecl; external;
function sqlite3_value_int(value: Psqlite3_value): int; cdecl; external;
function sqlite3_value_int64(value: Psqlite3_value): sqlite3_int64; cdecl; external;
function sqlite3_value_pointer(value: Psqlite3_value; typ: PChar): Ptr; cdecl; external;
function sqlite3_value_text(value: Psqlite3_value): PChar; cdecl; external;
function sqlite3_value_bytes(value: Psqlite3_value): int; cdecl; external;
function sqlite3_value_type(value: Psqlite3_value): int; cdecl; external;
function sqlite3_value_numeric_type(value: Psqlite3_value): int; cdecl; external;
function sqlite3_value_nochange(value: Psqlite3_value): int; cdecl; external;
function sqlite3_value_frombind(value: Psqlite3_value): int; cdecl; external;
function sqlite3_value_subtype(value: Psqlite3_value): unsigned_int; cdecl; external;
function sqlite3_value_dup(value: Psqlite3_value): Psqlite3_value; cdecl; external;
procedure sqlite3_value_free(value: Psqlite3_value); cdecl; external;

procedure sqlite3_result_blob(context: Psqlite3_context; const value: Ptr; n: int; destroy: sqlite3_destructor_type);
  cdecl; external;
procedure sqlite3_result_blob64(context: Psqlite3_context; const value: Ptr; n: sqlite3_uint64;
  destroy: sqlite3_destructor_type); cdecl; external;
procedure sqlite3_result_double(context: Psqlite3_context; value: double); cdecl; external;
procedure sqlite3_result_error(context: Psqlite3_context; const value: PChar; n: int); cdecl; external;
procedure sqlite3_result_error_code(context: Psqlite3_context; value: int); cdecl; external;
procedure sqlite3_result_int(context: Psqlite3_context; value: int); cdecl; external;
procedure sqlite3_result_int64(context: Psqlite3_context; value: sqlite3_int64); cdecl; external;
procedure sqlite3_result_null(context: Psqlite3_context); cdecl; external;
procedure sqlite3_result_text(context: Psqlite3_context; const value: PChar; n: int; destroy: sqlite3_destructor_type);
  cdecl; external;
procedure sqlite3_result_text64(context: Psqlite3_context; const value: PChar; n: sqlite3_uint64;
  destroy: sqlite3_destructor_type; encoding: unsigned_char); cdecl; external;
procedure sqlite3_result_value(context: Psqlite3_context; value: Psqlite3_value); cdecl; external;
procedure sqlite3_result_pointer(context: Psqlite3_context; value: Ptr; typ: PChar; const destroy: sqlite3_destructor_type);
  cdecl; external;
procedure sqlite3_result_zeroblob(context: Psqlite3_context; n: int); cdecl; external;
function sqlite3_result_zeroblob64(context: Psqlite3_context; n: sqlite3_uint64): int; cdecl; external;
procedure sqlite3_result_subtype(context: Psqlite3_context; value: unsigned_int); cdecl; external;

function sqlite3_create_module_v2(db: Psqlite3; const zName: PChar; const p: Psqlite3_module;
  pClientData: ptr; xDestroy: sqlite3_destroy_function): int; cdecl; external;
function sqlite3_drop_modules(db: Psqlite3; azKeep: PChar): int; cdecl; external;
function sqlite3_declare_vtab(db: Psqlite3; zSQL: PChar): int; cdecl; external;

function sqlite3_vtab_distinct(pInfo: Psqlite3_index_info): int; cdecl; external;
function sqlite3_vtab_in(pInfo: Psqlite3_index_info; iCons: int; bHandle: int): int; cdecl; external;
function sqlite3_vtab_in_first(pVal: Psqlite3_value; ppOut: PPsqlite3_value): int; cdecl; external;
function sqlite3_vtab_in_next(pVal: Psqlite3_value; ppOut: PPsqlite3_value): int; cdecl; external;
function sqlite3_vtab_nochange(context: Psqlite3_context): int; cdecl; external;
function sqlite3_vtab_on_conflict(db: Psqlite3): int; cdecl; external;
function sqlite3_vtab_rhs_value(pInfo: Psqlite3_index_info; n: int; ppVal: PPsqlite3_value): int; cdecl; external;

function sqlite3_create_function_v2(db: Psqlite3; const zFunctionName: PChar; nArg: int;
  eTextRep: int; pApp: Ptr; xFunc: sqlite3_function_function; xStep: sqlite3_step_function;
  xFinal: sqlite3_final_function; xDestroy: sqlite3_destroy_function): int; cdecl; external;
function sqlite3_user_data(context: Psqlite3_context): Ptr; cdecl; external;
function sqlite3_aggregate_context(context: Psqlite3_context; nBytes: int): Ptr; cdecl; external;
procedure sqlite3_set_auxdata(context: Psqlite3_context; N: int; metadata: ptr; destroy: sqlite3_destroy_function);
  cdecl; external;
function sqlite3_get_auxdata(context: Psqlite3_context; N: int): Ptr; cdecl; external;
function sqlite3_context_db_handle(context: Psqlite3_context): Psqlite3; cdecl; external;

function sqlite3_vfs_find(const zVfsName: PChar): Psqlite3_vfs; cdecl; external;
function sqlite3_vfs_register(const pVfs: Psqlite3_vfs; makeDflt: int): int; cdecl; external;
function sqlite3_vfs_unregister(const pVfs: Psqlite3_vfs): int; cdecl; external;

const
  SQLiteMemoryDatabaseName = ':memory:';

implementation

initialization
  sqlite3_initialize;

finalization
  sqlite3_shutdown;
end.
