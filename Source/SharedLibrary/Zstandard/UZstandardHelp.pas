unit UZstandardHelp;

{$I SCL.inc}

interface

uses
  UNumber, UZstandard;

type
  TZSTDCompressionLevel = -1..19;
  TZSTDThreadCount = 0..32;
  TZSTDWindowLog = U16;
  TZSTDChainLog = U16;
  TZSTDHashLog = U16;
  TZSTDSearchLog = U16;
  TZSTDMinMatch = U16;
  TZSTDTargetLength = U16;
  TZSTDStrategy = U16;

function EffectiveZSTDWindowLog(ASize: Siz): TZSTDWindowLog; inline;
function SetParameter(AContext: PZSTD_CCtx; AParameter: ZSTD_cParameter; AValue: int; out AResultCode: size_t): Bool;
  inline; overload;
function GetParameter(AContext: PZSTD_CCtx; AParameter: ZSTD_cParameter; out AValue: int; out AResultCode: size_t): Bool;
  inline; overload;

function Create(out ACompressor: PZSTD_CCtx; AZSTDStrategy: TZSTDStrategy; AZSTDWindowLog: TZSTDWindowLog;
  AZSTDChainLog: TZSTDChainLog; AZSTDHashLog: TZSTDHashLog; AZSTDSearchLog: TZSTDSearchLog;
  AZSTDMinMatch: TZSTDMinMatch; AZSTDTargetLength: TZSTDTargetLength): Bool; overload;

implementation

function EffectiveZSTDWindowLog(ASize: Siz): TZSTDWindowLog;
begin
  if ASize = 0 then
    Exit(0); //Default
  Result := BsrQWord(ASize);
end;

function SetParameter(AContext: PZSTD_CCtx; AParameter: ZSTD_cParameter; AValue: int; out AResultCode: size_t): Bool;
begin
  AResultCode := ZSTD_CCtx_setParameter(AContext, AParameter, AValue);
  Result := ZSTD_isError(AResultCode) = 0;
end;

function GetParameter(AContext: PZSTD_CCtx; AParameter: ZSTD_cParameter; out AValue: int; out AResultCode: size_t): Bool;
begin
  AResultCode := ZSTD_CCtx_getParameter(AContext, AParameter, @AValue);
  Result := ZSTD_isError(AResultCode) = 0;
end;

function Create(out ACompressor: PZSTD_CCtx; AZSTDStrategy: TZSTDStrategy; AZSTDWindowLog: TZSTDWindowLog;
  AZSTDChainLog: TZSTDChainLog; AZSTDHashLog: TZSTDHashLog; AZSTDSearchLog: TZSTDSearchLog; AZSTDMinMatch: TZSTDMinMatch;
  AZSTDTargetLength: TZSTDTargetLength): Bool;
var
  R: size_t;
begin
  ACompressor := ZSTD_createCCtx;
  try
    Result := SetParameter(ACompressor, ZSTD_c_windowLog, AZSTDWindowLog, R);
    Result := Result and SetParameter(ACompressor, ZSTD_c_chainLog, AZSTDChainLog, R);
    Result := Result and SetParameter(ACompressor, ZSTD_c_hashLog, AZSTDHashLog, R);
    Result := Result and SetParameter(ACompressor, ZSTD_c_searchLog, AZSTDSearchLog, R);
    Result := Result and SetParameter(ACompressor, ZSTD_c_minMatch, AZSTDMinMatch, R);
    Result := Result and SetParameter(ACompressor, ZSTD_c_targetLength, AZSTDTargetLength, R);
    Result := Result and SetParameter(ACompressor, ZSTD_c_strategy, AZSTDStrategy, R);
  finally
    if not Result then
    begin
      ZSTD_freeCCtx(ACompressor);
      ACompressor := nil;
    end;
  end;
end;

end.
