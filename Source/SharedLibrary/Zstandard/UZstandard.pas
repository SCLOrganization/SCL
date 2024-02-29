unit UZstandard;

{$I SCL.inc}

interface

uses
  UNumber, UString;

type
  int = I32;
  Pint = ^int;
  unsigned = U32;
  size_t = U64;
  unsignedlonglong = U64;
  ZSTD_CCtx = record;
  PZSTD_CCtx = ^ZSTD_CCtx;
  ZSTD_DCtx = record;
  PZSTD_DCtx = ^ZSTD_DCtx;

  ZSTD_strategy = (
    ZSTD_fast = 1,
    ZSTD_dfast = 2,
    ZSTD_greedy = 3,
    ZSTD_lazy = 4,
    ZSTD_lazy2 = 5,
    ZSTD_btlazy2 = 6,
    ZSTD_btopt = 7,
    ZSTD_btultra = 8,
    ZSTD_btultra2 = 9);

  ZSTD_cParameter = (
    //Compression
    ZSTD_c_compressionLevel = 100,
    ZSTD_c_windowLog = 101,
    ZSTD_c_hashLog = 102,
    ZSTD_c_chainLog = 103,
    ZSTD_c_searchLog = 104,
    ZSTD_c_minMatch = 105,
    ZSTD_c_targetLength = 106,
    ZSTD_c_strategy = 107,
    //Frame
    ZSTD_c_contentSizeFlag = 200,
    ZSTD_c_checksumFlag = 201,
    ZSTD_c_dictIDFlag = 202,
    //Multi-threading
    ZSTD_c_nbWorkers = 400,
    ZSTD_c_jobSize = 401,
    ZSTD_c_overlapLog = 402);

const
  ZSTD_CONTENTSIZE_UNKNOWN = unsignedlonglong(-1);
  ZSTD_CONTENTSIZE_ERROR = unsignedlonglong(-2);

function ZSTD_versionNumber: unsigned; cdecl; external;
function ZSTD_versionString: PChar; cdecl; external;
function ZSTD_isError(code: size_t): unsigned; cdecl; external;

function ZSTD_compressBound(srcSize: size_t): size_t; cdecl; external;
function ZSTD_createCCtx: PZSTD_CCtx; cdecl; external;
function ZSTD_freeCCtx(cctx: PZSTD_CCtx): size_t; cdecl; external;
function ZSTD_compress2(cctx: PZSTD_CCtx; dst: Ptr; dstCapacity: size_t; src: Ptr; srcSize: size_t): size_t;
  cdecl; external;
function ZSTD_CCtx_setParameter(cctx: PZSTD_CCtx; param: ZSTD_cParameter; value: int): size_t; cdecl; external;
function ZSTD_CCtx_getParameter(cctx: PZSTD_CCtx; param: ZSTD_cParameter; value: Pint): size_t; cdecl; external;

function ZSTD_isFrame(buffer: Ptr; size: size_t): unsigned; cdecl; external;
function ZSTD_getFrameContentSize(src: Ptr; srcSize: size_t): unsignedlonglong; cdecl; external;
function ZSTD_createDCtx: PZSTD_DCtx; cdecl; external;
function ZSTD_freeDCtx(dctx: PZSTD_DCtx): size_t; cdecl; external;
function ZSTD_decompressDCtx(dctx: PZSTD_DCtx; dst: Ptr; dstCapacity: size_t; src: Ptr; srcSize: size_t): size_t;
  cdecl; external;

implementation

end.
