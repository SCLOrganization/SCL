unit USQLite3Help;

{$I SCL.inc}

interface

uses
  UNumber, UNumberHelp, UString, UStringHelp, UFile, UFileHelp, USQLite3, UExceptionHelp, UMemoryBlock;

type
  Pint = ^int;
  TSQLite3ROWID = sqlite3_int64;
  TSQLite3ROWIDArray = array of TSQLite3ROWID;
  TSQLite3SQLStatement = type Str;
  TSQLite3Integer = int;
  TSQLite3Integer64 = sqlite3_int64;
  TSQLite3ResultCode = int;
  TSQLite3ApplicationID = I32;
  TSQLite3UserVersion = I32;
  TSQLite3HeaderString = array[0..15] of Char;

const
  SQLite3HeaderString: TSQLite3HeaderString = 'SQLite format 3';
  SQLite3Extension: Str = 'sqlite3';

function ErrorMessage(ACode: TSQLite3ResultCode): Str; overload;
function Open(const APath: TFilePath; out AConnection: Psqlite3): TSQLite3ResultCode; overload;
function Open(const APath: TFilePath; AFlags: int; out AConnection: Psqlite3): TSQLite3ResultCode; overload;
function Close(var AConnection: Psqlite3): TSQLite3ResultCode; overload;

function Prepare(AConnection: Psqlite3; const ASQLStatement: TSQLite3SQLStatement; out AStatement: Psqlite3_stmt;
  out AResultCode: TSQLite3ResultCode): Bool; inline; overload;
function Prepare(AConnection: Psqlite3; const ASQLStatement: TSQLite3SQLStatement; out AStatement: Psqlite3_stmt): Bool;
  inline; overload;

function Finalize(var AStatement: Psqlite3_stmt; out AResultCode: TSQLite3ResultCode): Bool; inline; overload;
function Finalize(var AStatement: Psqlite3_stmt): Bool; inline; overload;

function Step(AStatement: Psqlite3_stmt; AExpectedResultCode: TSQLite3ResultCode;
  out AResultCode: TSQLite3ResultCode): Bool; inline; overload;
function Step(AStatement: Psqlite3_stmt; out AResultCode: TSQLite3ResultCode): Bool; inline; overload;

function Reset(AStatement: Psqlite3_stmt; out AResultCode: TSQLite3ResultCode): Bool; inline; overload;
function Reset(AStatement: Psqlite3_stmt): Bool; inline; overload;

function StepResetSelect(AStatement: Psqlite3_stmt; out AResultCode: TSQLite3ResultCode): Bool; inline; overload;
function StepResetInsert(AStatement: Psqlite3_stmt; out AResultCode: TSQLite3ResultCode): Bool; inline; overload;

function Bind<T>(AStatement: Psqlite3_stmt; AIndex: Ind; constref AValue: T;
  out AResultCode: TSQLite3ResultCode): Bool; inline; overload;
function BindAll<T1>(AStatement: Psqlite3_stmt; constref V1: T1; out AResultCode: TSQLite3ResultCode): Bool;
  inline; overload;
function BindAll<T1, T2>(AStatement: Psqlite3_stmt; constref V1: T1; constref V2: T2;
  out AResultCode: TSQLite3ResultCode): Bool; inline; overload;
function BindAll<T1, T2, T3>(AStatement: Psqlite3_stmt; constref V1: T1; constref V2: T2; constref V3: T3;
  out AResultCode: TSQLite3ResultCode): Bool; inline; overload;
function BindAll<T1, T2, T3, T4>(AStatement: Psqlite3_stmt; constref V1: T1; constref V2: T2;
  constref V3: T3; constref V4: T4; out AResultCode: TSQLite3ResultCode): Bool; inline; overload;
function BindAll<T1, T2, T3, T4, T5>(AStatement: Psqlite3_stmt;
  constref V1: T1; constref V2: T2; constref V3: T3; constref V4: T4; constref V5: T5;
  out AResultCode: TSQLite3ResultCode): Bool; inline; overload;
function BindAll<T1, T2, T3, T4, T5, T6>(AStatement: Psqlite3_stmt;
  constref V1: T1; constref V2: T2; constref V3: T3; constref V4: T4; constref V5: T5; constref V6: T6;
  out AResultCode: TSQLite3ResultCode): Bool; inline; overload;

function BindBlob(AStatement: Psqlite3_stmt; AIndex: Ind; const AValue: Ptr; ASize: Siz;
  out AResultCode: TSQLite3ResultCode): Bool; inline; overload;
function BindNull(AStatement: Psqlite3_stmt; AIndex: Ind; out AResultCode: TSQLite3ResultCode): Bool; inline; overload;

function Column<T>(AStatement: Psqlite3_stmt; AIndex: Ind; out AValue: T): Bool; inline; overload;
function ColumnValue<T>(AStatement: Psqlite3_stmt; AIndex: Ind): T; inline; overload;
function ColumnIPS(AStatement: Psqlite3_stmt; AIndex: Ind): IPS;
function ColumnRStr(AStatement: Psqlite3_stmt; AIndex: Ind): RStr;
procedure ColumnBlob(AStatement: Psqlite3_stmt; AIndex: Ind; out AValue: Ptr; out ASize: Siz); inline; overload;
procedure ColumnBlob(AStatement: Psqlite3_stmt; AIndex: Ind; out AMemoryBlock: TMemoryBlock); inline; overload;

function ColumnAll<T1>(AStatement: Psqlite3_stmt; out V1: T1): Bool; overload;
function ColumnAll<T1, T2>(AStatement: Psqlite3_stmt; out V1: T1; out V2: T2): Bool; overload;
function ColumnAll<T1, T2, T3>(AStatement: Psqlite3_stmt; out V1: T1; out V2: T2; out V3: T3): Bool; overload;
function ColumnAll<T1, T2, T3, T4>(AStatement: Psqlite3_stmt; out V1: T1; out V2: T2; out V3: T3; out V4: T4): Bool;
  overload;
function ColumnAll<T1, T2, T3, T4, T5>(AStatement: Psqlite3_stmt; out V1: T1; out V2: T2; out V3: T3;
  out V4: T4; out V5: T5): Bool; overload;
function ColumnAll<T1, T2, T3, T4, T5, T6>(AStatement: Psqlite3_stmt; out V1: T1; out V2: T2; out V3: T3;
  out V4: T4; out V5: T5; out V6: T6): Bool; overload;

function Execute(AConnection: Psqlite3; const ASQLStatement: TSQLite3SQLStatement): TSQLite3ResultCode; overload;
function Execute(AConnection: Psqlite3; const ASQLStatement: TSQLite3SQLStatement;
  out AResultCode: TSQLite3ResultCode): Bool; overload;
function Execute(AConnection: Psqlite3; const ASQLStatements: array of TSQLite3SQLStatement; AUseTransaction: Bool;
  out AResultCode: TSQLite3ResultCode): Bool; overload;

function Vacuum(AConnection: Psqlite3): TSQLite3ResultCode; overload;
function BeginTransaction(AConnection: Psqlite3): TSQLite3ResultCode; overload;
function EndTransaction(AConnection: Psqlite3): TSQLite3ResultCode; overload;
function RollbackTransaction(AConnection: Psqlite3): TSQLite3ResultCode; overload;
function EndTransaction(AConnection: Psqlite3; ACancel: Bool): TSQLite3ResultCode; overload;

function Select<T>(AConnection: Psqlite3; ASQLStatement: TSQLite3SQLStatement;
  out AResultCode: TSQLite3ResultCode): T; overload;

function Insert<T1>(AStatement: Psqlite3_stmt; constref V1: T1; out AResultCode: TSQLite3ResultCode): Bool; overload;
function Insert<T1, T2>(AStatement: Psqlite3_stmt; constref V1: T1; constref V2: T2;
  out AResultCode: TSQLite3ResultCode): Bool; overload;
function Insert<T1, T2, T3>(AStatement: Psqlite3_stmt; constref V1: T1; constref V2: T2;
  constref V3: T3; out AResultCode: TSQLite3ResultCode): Bool; overload;
function Insert<T1, T2, T3, T4>(AStatement: Psqlite3_stmt; constref V1: T1; constref V2: T2;
  constref V3: T3; constref V4: T4; out AResultCode: TSQLite3ResultCode): Bool; overload;
function Insert<T1, T2, T3, T4, T5>(AStatement: Psqlite3_stmt; constref V1: T1; constref V2: T2;
  constref V3: T3; constref V4: T4; constref V5: T5; out AResultCode: TSQLite3ResultCode): Bool; overload;
function Insert<T1, T2, T3, T4, T5, T6>(AStatement: Psqlite3_stmt; constref V1: T1; constref V2: T2;
  constref V3: T3; constref V4: T4; constref V5: T5; constref V6: T6; out AResultCode: TSQLite3ResultCode): Bool; overload;

function InsertedID(AConnection: Psqlite3): TSQLite3ROWID;

procedure Pragma<T>(AConnection: Psqlite3; const AName: Str; const AValue: T; out AResultCode: TSQLite3ResultCode);
  overload;
function Pragma<T>(AConnection: Psqlite3; const AName: Str; out AResultCode: TSQLite3ResultCode;
  out AStatus: Bool): T; overload;
function Pragma<T>(AConnection: Psqlite3; const AName: Str): T; overload;

function Pragma<T, VT>(AConnection: Psqlite3; const AName: Str; const AValue: T; const AVerifyValue: VT;
  out AResultCode: TSQLite3ResultCode): Bool; overload;
function Pragma<T>(AConnection: Psqlite3; const AName: Str; const AValue: T; AVerifyWrite: Bool;
  out AResultCode: TSQLite3ResultCode): Bool; overload;

function ClearAll(const APath: TFilePath): Bool; overload;

type
  TSQLite3SynchronousMode = (s3smOff, s3smNormal, s3smFull, s3smExtra);
  TSQLite3LockingMode = (s3lmNormal, s3lmExclusive);
  TSQLite3JournalMode = (s3jmDelete, s3jmTruncate, s3jmPersist, s3jmMemory, s3jmWal, s3jmOff);
  TSQLite3TempStore = (s3tsDefault, s3tmFile, s3tmMemory);
  TSQLite3PageSize = U32;

const
  SQLite3SynchronousModesText: array[TSQLite3SynchronousMode] of Str = (
    'OFF', 'NORMAL', 'FULL', 'EXTRA');
  SQLite3LockingModesText: array[TSQLite3LockingMode] of Str = (
    'NORMAL', 'EXCLUSIVE');
  SQLite3JournalModesText: array[TSQLite3JournalMode] of Str = (
    'DELETE', 'TRUNCATE', 'PERSIST', 'MEMORY', 'WAL', 'OFF');
  SQLite3TempStoresText: array[TSQLite3TempStore] of Str = (
    'DEFAULT', 'FILE', 'MEMORY');

const
  SQLite3SynchronousModesU8: array[TSQLite3SynchronousMode] of U8 = (0, 1, 2, 3);
  SQLite3TempStoresU8: array[TSQLite3TempStore] of U8 = (0, 1, 2);

function SynchronousMode(AConnection: Psqlite3; AValue: TSQLite3SynchronousMode; out AResultCode: TSQLite3ResultCode): Bool;
  inline; overload;
function LockingMode(AConnection: Psqlite3; AValue: TSQLite3LockingMode; out AResultCode: TSQLite3ResultCode): Bool;
  inline; overload;
function JournalMode(AConnection: Psqlite3; AValue: TSQLite3JournalMode; out AResultCode: TSQLite3ResultCode): Bool;
  inline; overload;
function TempStore(AConnection: Psqlite3; AValue: TSQLite3TempStore; out AResultCode: TSQLite3ResultCode): Bool;
  inline; overload;
function Options(AConnection: Psqlite3; ASynchronousMode: TSQLite3SynchronousMode;
  ALockingMode: TSQLite3LockingMode; AJournalMode: TSQLite3JournalMode; ATempStore: TSQLite3TempStore;
  out AResultCode: TSQLite3ResultCode): Bool; inline; overload;

function PageSize(AConnection: Psqlite3; AValue: TSQLite3PageSize; out AResultCode: TSQLite3ResultCode): Bool;
  inline; overload;
function PageSize(AConnection: Psqlite3; out AResultCode: TSQLite3ResultCode; out AStatus: Bool): TSQLite3PageSize;
  inline; overload;

type
  TSQLite3SetPageSizeOption = (s3spoCheckBeforeChange, s3spoVacuum);
  TSQLite3SetPageSizeOptions = set of TSQLite3SetPageSizeOption;

function PageSize(AConnection: Psqlite3; AValue: TSQLite3PageSize; AOptions: TSQLite3SetPageSizeOptions;
  out AResultCode: TSQLite3ResultCode): Bool; overload;

type
  TSQLite3Error = record
  private
    Code: TSQLite3ResultCode;
    Message: Str;
  end;
  PSQLite3Error = ^TSQLite3Error;

procedure Code(var AError: TSQLite3Error; ACode: TSQLite3ResultCode); inline; overload;
function Code(constref AError: TSQLite3Error): TSQLite3ResultCode; inline; overload;
procedure Message(var AError: TSQLite3Error; const AMessage: Str); inline; overload;
function Message(constref AError: TSQLite3Error): Str; inline; overload;
function HasError(constref AError: TSQLite3Error): Bool; inline; overload;

procedure LogCallbacks; overload;

implementation

uses
  UStringCase;

function ErrorMessage(ACode: TSQLite3ResultCode): Str;
var
  P: PChar;
begin
  P := sqlite3_errstr(ACode);
  Result := Create(P, Count(P));
end;

function Open(const APath: TFilePath; out AConnection: Psqlite3): TSQLite3ResultCode;
begin
  Result := sqlite3_open(PChar(APath), @AConnection);
end;

function Open(const APath: TFilePath; AFlags: int; out AConnection: Psqlite3): TSQLite3ResultCode;
begin
  Result := sqlite3_open_v2(PChar(APath), @AConnection, AFlags, nil);
end;

function Close(var AConnection: Psqlite3): TSQLite3ResultCode;
begin
  Result := sqlite3_close(AConnection);
end;

function Prepare(AConnection: Psqlite3; const ASQLStatement: TSQLite3SQLStatement; out AStatement: Psqlite3_stmt;
  out AResultCode: TSQLite3ResultCode): Bool;
var
  Tail: PChar;
begin
  AResultCode := sqlite3_prepare_v2(AConnection, PChar(ASQLStatement), Length(ASQLStatement), @AStatement, @Tail);
  Result := AResultCode = SQLITE_OK;
end;

function Prepare(AConnection: Psqlite3; const ASQLStatement: TSQLite3SQLStatement; out AStatement: Psqlite3_stmt): Bool;
var
  R: TSQLite3ResultCode;
begin
  Result := Prepare(AConnection, ASQLStatement, AStatement, R);
end;

function Finalize(var AStatement: Psqlite3_stmt; out AResultCode: TSQLite3ResultCode): Bool;
begin
  AResultCode := sqlite3_finalize(AStatement);
  Result := AResultCode = SQLITE_OK;
  if Result then
    AStatement := nil;
end;

function Finalize(var AStatement: Psqlite3_stmt): Bool;
var
  R: TSQLite3ResultCode;
begin
  Result := Finalize(AStatement, R);
end;

function Step(AStatement: Psqlite3_stmt; AExpectedResultCode: TSQLite3ResultCode;
  out AResultCode: TSQLite3ResultCode): Bool;
begin
  AResultCode := sqlite3_step(AStatement);
  Result := AResultCode = AExpectedResultCode;
end;

function Step(AStatement: Psqlite3_stmt; out AResultCode: TSQLite3ResultCode): Bool;
begin
  Result := Step(AStatement, SQLITE_ROW, AResultCode);
end;

function Reset(AStatement: Psqlite3_stmt; out AResultCode: TSQLite3ResultCode): Bool;
begin
  AResultCode := sqlite3_reset(AStatement);
  Result := AResultCode = SQLITE_OK;
end;

function Reset(AStatement: Psqlite3_stmt): Bool;
begin
  Result := sqlite3_reset(AStatement) = SQLITE_OK;
end;

function StepResetSelect(AStatement: Psqlite3_stmt; out AResultCode: TSQLite3ResultCode): Bool;
begin
  Result := Step(AStatement, SQLITE_ROW, AResultCode);
  Result := Result and Reset(AStatement, AResultCode);
end;

function StepResetInsert(AStatement: Psqlite3_stmt; out AResultCode: TSQLite3ResultCode): Bool;
begin
  Result := Step(AStatement, SQLITE_DONE, AResultCode);
  Result := Result and Reset(AStatement, AResultCode);
end;

function Bind<T>(AStatement: Psqlite3_stmt; AIndex: Ind; constref AValue: T; out AResultCode: TSQLite3ResultCode): Bool;
begin
  if IsNumber<T> then //Cast any number as sqlite3_int64
    AResultCode := sqlite3_bind_int64(AStatement, AIndex + 1, ToI64<T>(AValue))
  else if IsString<T> then
    AResultCode := sqlite3_bind_text64(AStatement, AIndex + 1, PChar(PRStr(@AValue)^), Length(PRStr(@AValue)^),
      SQLITE_STATIC, SQLITE_UTF8)
  else if PPtr(@AValue)^ = nil then
    AResultCode := sqlite3_bind_null(AStatement, AIndex + 1)
  else if TypeInfo(T) = TypeInfo(TMemoryBlock) then
    AResultCode := sqlite3_bind_blob(AStatement, AIndex + 1, Data(PMemoryBlock(@AValue)^),
      Size(PMemoryBlock(@AValue)^), SQLITE_STATIC)
  else
    RaiseNotSupportedType;
  Result := AResultCode = SQLITE_OK;
end;

function BindAll<T1>(AStatement: Psqlite3_stmt; constref V1: T1; out AResultCode: TSQLite3ResultCode): Bool;
begin
  Result := Bind<T1>(AStatement, 0, V1, AResultCode);
end;

function BindAll<T1, T2>(AStatement: Psqlite3_stmt; constref V1: T1; constref V2: T2;
  out AResultCode: TSQLite3ResultCode): Bool;
begin
  Result := BindAll<T1>(AStatement, V1, AResultCode);
  Result := Result and (Bind<T2>(AStatement, 1, V2, AResultCode));
end;

function BindAll<T1, T2, T3>(AStatement: Psqlite3_stmt; constref V1: T1; constref V2: T2; constref V3: T3;
  out AResultCode: TSQLite3ResultCode): Bool;
begin
  Result := BindAll<T1, T2>(AStatement, V1, V2, AResultCode);
  Result := Result and (Bind<T3>(AStatement, 2, V3, AResultCode));
end;

function BindAll<T1, T2, T3, T4>(AStatement: Psqlite3_stmt; constref V1: T1; constref V2: T2;
  constref V3: T3; constref V4: T4; out AResultCode: TSQLite3ResultCode): Bool;
begin
  Result := BindAll<T1, T2, T3>(AStatement, V1, V2, V3, AResultCode);
  Result := Result and (Bind<T4>(AStatement, 3, V4, AResultCode));
end;

function BindAll<T1, T2, T3, T4, T5>(AStatement: Psqlite3_stmt; constref V1: T1; constref V2: T2;
  constref V3: T3; constref V4: T4; constref V5: T5; out AResultCode: TSQLite3ResultCode): Bool;
begin
  Result := BindAll<T1, T2, T3, T4>(AStatement, V1, V2, V3, V4, AResultCode);
  Result := Result and (Bind<T5>(AStatement, 4, V5, AResultCode));
end;

function BindAll<T1, T2, T3, T4, T5, T6>(AStatement: Psqlite3_stmt; constref V1: T1; constref V2: T2;
  constref V3: T3; constref V4: T4; constref V5: T5; constref V6: T6; out AResultCode: TSQLite3ResultCode): Bool;
begin
  Result := BindAll<T1, T2, T3, T4, T5>(AStatement, V1, V2, V3, V4, V5, AResultCode);
  Result := Result and (Bind<T6>(AStatement, 5, V6, AResultCode));
end;

function BindBlob(AStatement: Psqlite3_stmt; AIndex: Ind; const AValue: Ptr; ASize: Siz;
  out AResultCode: TSQLite3ResultCode): Bool;
begin
  AResultCode := sqlite3_bind_blob(AStatement, AIndex + 1, AValue, ASize, SQLITE_STATIC);
  Result := AResultCode = SQLITE_OK;
end;

function BindNull(AStatement: Psqlite3_stmt; AIndex: Ind; out AResultCode: TSQLite3ResultCode): Bool;
begin
  AResultCode := sqlite3_bind_null(AStatement, AIndex + 1);
  Result := AResultCode = SQLITE_OK;
end;

function Column<T>(AStatement: Psqlite3_stmt; AIndex: Ind; out AValue: T): Bool;
var
  V: sqlite3_int64;
  P: PChar;
  N: int;
begin
  if IsNumber<T> then
  begin
    V := sqlite3_column_int64(AStatement, AIndex);
    Result := FromI64<T>(V, AValue);
  end
  else if IsString<T> then
  begin
    P := sqlite3_column_text(AStatement, AIndex);
    N := sqlite3_column_bytes(AStatement, AIndex);
    Result := P <> nil;
    if Result then
      PRStr(@AValue)^ := Create(P, N);
  end
  else
    RaiseNotSupportedType;
end;

function ColumnValue<T>(AStatement: Psqlite3_stmt; AIndex: Ind): T;
  {%H-}begin
  Column<T>(AStatement, AIndex, Result);
end;

function ColumnIPS(AStatement: Psqlite3_stmt; AIndex: Ind): IPS;
begin
  Result := sqlite3_column_int64(AStatement, AIndex);
end;

function ColumnRStr(AStatement: Psqlite3_stmt; AIndex: Ind): RStr;
var
  P: PChar;
  N: int;
begin
  P := sqlite3_column_text(AStatement, AIndex);
  N := sqlite3_column_bytes(AStatement, AIndex);
  Result := Create(P, N);
end;

procedure ColumnBlob(AStatement: Psqlite3_stmt; AIndex: Ind; out AValue: Ptr; out ASize: Siz);
begin
  AValue := sqlite3_column_blob(AStatement, AIndex);
  ASize := sqlite3_column_bytes(AStatement, AIndex);
end;

procedure ColumnBlob(AStatement: Psqlite3_stmt; AIndex: Ind; out AMemoryBlock: TMemoryBlock);
begin
  Initialize(AMemoryBlock);
  Data(AMemoryBlock, sqlite3_column_blob(AStatement, AIndex));
  Size(AMemoryBlock, sqlite3_column_bytes(AStatement, AIndex));
end;

function ColumnAll<T1>(AStatement: Psqlite3_stmt; out V1: T1): Bool;
begin
  Result := Column<T1>(AStatement, 0, V1);
end;

function ColumnAll<T1, T2>(AStatement: Psqlite3_stmt; out V1: T1; out V2: T2): Bool;
begin
  Result := ColumnAll<T1>(AStatement, V1);
  Result := Result and (Column<T2>(AStatement, 1, V2));
end;

function ColumnAll<T1, T2, T3>(AStatement: Psqlite3_stmt; out V1: T1; out V2: T2; out V3: T3): Bool;
begin
  Result := ColumnAll<T1, T2>(AStatement, V1, V2);
  Result := Result and (Column<T3>(AStatement, 2, V3));
end;

function ColumnAll<T1, T2, T3, T4>(AStatement: Psqlite3_stmt; out V1: T1; out V2: T2; out V3: T3; out V4: T4): Bool;
begin
  Result := ColumnAll<T1, T2, T3>(AStatement, V1, V2, V3);
  Result := Result and (Column<T4>(AStatement, 3, V4));
end;

function ColumnAll<T1, T2, T3, T4, T5>(AStatement: Psqlite3_stmt; out V1: T1; out V2: T2; out V3: T3; out V4: T4; out V5: T5
  ): Bool;
begin
  Result := ColumnAll<T1, T2, T3, T4>(AStatement, V1, V2, V3, V4);
  Result := Result and (Column<T5>(AStatement, 4, V5));
end;

function ColumnAll<T1, T2, T3, T4, T5, T6>(AStatement: Psqlite3_stmt; out V1: T1; out V2: T2; out V3: T3; out V4: T4; out
  V5: T5; out V6: T6): Bool;
begin
  Result := ColumnAll<T1, T2, T3, T4, T5>(AStatement, V1, V2, V3, V4, V5);
  Result := Result and (Column<T6>(AStatement, 5, V6));
end;

function Execute(AConnection: Psqlite3; const ASQLStatement: TSQLite3SQLStatement): TSQLite3ResultCode;
begin
  Result := sqlite3_exec(AConnection, PChar(ASQLStatement), nil, nil, nil);
end;

function Execute(AConnection: Psqlite3; const ASQLStatement: TSQLite3SQLStatement;
  out AResultCode: TSQLite3ResultCode): Bool;
begin
  AResultCode := Execute(AConnection, ASQLStatement);
  Result := AResultCode = SQLITE_OK;
end;

function Execute(AConnection: Psqlite3; const ASQLStatements: array of TSQLite3SQLStatement; AUseTransaction: Bool; out
  AResultCode: TSQLite3ResultCode): Bool;
var
  I: Ind;
  R: TSQLite3ResultCode;
begin
  if AUseTransaction then
  begin
    AResultCode := BeginTransaction(AConnection);
    Result := AResultCode = SQLITE_OK;
    if not Result then
      Exit;
  end;
  try
    Result := True;
    for I := 0 to High(ASQLStatements) do
    begin
      Result := Execute(AConnection, ASQLStatements[I], AResultCode);
      if not Result then
        Break;
    end;
  finally
    if AUseTransaction then
    begin
      R := EndTransaction(AConnection, not Result);
      if Result then //Set if it does not override the Execute ResultCode
        AResultCode := R;
    end;
  end;
end;

function Vacuum(AConnection: Psqlite3): TSQLite3ResultCode;
begin
  Result := Execute(AConnection, 'VACUUM;');
end;

function BeginTransaction(AConnection: Psqlite3): TSQLite3ResultCode;
begin
  Result := Execute(AConnection, 'BEGIN;');
end;

function EndTransaction(AConnection: Psqlite3): TSQLite3ResultCode;
begin
  Result := Execute(AConnection, 'END;');
end;

function RollbackTransaction(AConnection: Psqlite3): TSQLite3ResultCode;
begin
  Result := Execute(AConnection, 'ROLLBACK;');
end;

function EndTransaction(AConnection: Psqlite3; ACancel: Bool): TSQLite3ResultCode;
begin
  if not ACancel then
    Result := EndTransaction(AConnection)
  else
    Result := RollbackTransaction(AConnection);
end;

function Select<T>(AConnection: Psqlite3; ASQLStatement: TSQLite3SQLStatement; out AResultCode: TSQLite3ResultCode): T;
var
  S: Psqlite3_stmt;
begin
  Initialize(Result);
  if Prepare(AConnection, ASQLStatement, S, AResultCode) then
  try
    if Step(S, SQLITE_ROW, AResultCode) then
      Result := ColumnValue<T>(S, 0);
  finally
    Finalize(S);
  end;
end;

function Insert<T1>(AStatement: Psqlite3_stmt; constref V1: T1; out AResultCode: TSQLite3ResultCode): Bool;
begin
  Result := BindAll<T1>(AStatement, V1, AResultCode);
  Result := Result and StepResetInsert(AStatement, AResultCode);
end;

function Insert<T1, T2>(AStatement: Psqlite3_stmt; constref V1: T1; constref V2: T2;
  out AResultCode: TSQLite3ResultCode): Bool;
begin
  Result := BindAll<T1, T2>(AStatement, V1, V2, AResultCode);
  Result := Result and StepResetInsert(AStatement, AResultCode);
end;

function Insert<T1, T2, T3>(AStatement: Psqlite3_stmt; constref V1: T1; constref V2: T2; constref V3: T3; out
  AResultCode: TSQLite3ResultCode): Bool;
begin
  Result := BindAll<T1, T2, T3>(AStatement, V1, V2, V3, AResultCode);
  Result := Result and StepResetInsert(AStatement, AResultCode);
end;

function Insert<T1, T2, T3, T4>(AStatement: Psqlite3_stmt; constref V1: T1; constref V2: T2; constref V3: T3; constref
  V4: T4; out AResultCode: TSQLite3ResultCode): Bool;
begin
  Result := BindAll<T1, T2, T3, T4>(AStatement, V1, V2, V3, V4, AResultCode);
  Result := Result and StepResetInsert(AStatement, AResultCode);
end;

function Insert<T1, T2, T3, T4, T5>(AStatement: Psqlite3_stmt; constref V1: T1; constref V2: T2; constref V3: T3; constref
  V4: T4; constref V5: T5; out AResultCode: TSQLite3ResultCode): Bool;
begin
  Result := BindAll<T1, T2, T3, T4, T5>(AStatement, V1, V2, V3, V4, V5, AResultCode);
  Result := Result and StepResetInsert(AStatement, AResultCode);
end;

function Insert<T1, T2, T3, T4, T5, T6>(AStatement: Psqlite3_stmt; constref V1: T1; constref V2: T2; constref V3: T3;
  constref V4: T4; constref V5: T5; constref V6: T6; out AResultCode: TSQLite3ResultCode): Bool;
begin
  Result := BindAll<T1, T2, T3, T4, T5, T6>(AStatement, V1, V2, V3, V4, V5, V6, AResultCode);
  Result := Result and StepResetInsert(AStatement, AResultCode);
end;

function InsertedID(AConnection: Psqlite3): TSQLite3ROWID;
begin
  Result := sqlite3_last_insert_rowid(AConnection);
end;

procedure Pragma<T>(AConnection: Psqlite3; const AName: Str; const AValue: T; out AResultCode: TSQLite3ResultCode);
begin
  AResultCode := Execute(AConnection, 'PRAGMA ' + AName + ' = ' + (AsStr<T>(AValue)));
end;

function Pragma<T>(AConnection: Psqlite3; const AName: Str; out AResultCode: TSQLite3ResultCode; out AStatus: Bool): T;
begin
  Result := Select<T>(AConnection, 'PRAGMA ' + AName, AResultCode);
  AStatus := AResultCode = SQLITE_ROW;
end;

function Pragma<T>(AConnection: Psqlite3; const AName: Str): T;
var
  R: TSQLite3ResultCode;
  S: Bool;
begin
  Result := Pragma<T>(AConnection, AName, R, S);
end;

//AVerifyValue can be different than AValue because SQLite3 returns different values for some
function Pragma<T, VT>(AConnection: Psqlite3; const AName: Str; const AValue: T; const AVerifyValue: VT;
  out AResultCode: TSQLite3ResultCode): Bool;
var
  V: VT;
  R: TSQLite3ResultCode;
begin
  Result := False;
  Pragma<T>(AConnection, AName, AValue, AResultCode);
  Result := AResultCode = SQLITE_OK;
  if not Result then
    Exit;
  V := Pragma<VT>(AConnection, AName, R, Result); //Use R to keep AResultCode as is
  if not Result then
    Exit;
  Result := AVerifyValue = V;
end;

//AVerifyWrite because SQLite3 does not raise any error if the value is invalid
function Pragma<T>(AConnection: Psqlite3; const AName: Str; const AValue: T; AVerifyWrite: Bool;
  out AResultCode: TSQLite3ResultCode): Bool;
begin
  if AVerifyWrite then
    Result := Pragma<T, T>(AConnection, AName, AValue, AValue, AResultCode)
  else
  begin
    Pragma<T>(AConnection, AName, AValue, AResultCode);
    Result := AResultCode = SQLITE_OK;
  end;
end;

function ClearAll(const APath: TFilePath): Bool;
var
  DB: Psqlite3;
  R: TSQLite3ResultCode;
begin
  Result := Open(APath, SQLITE_OPEN_READWRITE, DB) = SQLITE_OK;
  if Result then
  try
    Result := Pragma<Bool>(DB, 'writable_schema', True, True, R);
    if not Result then
      Exit;

    Result := Execute(DB, 'DELETE FROM sqlite_schema;') = SQLITE_OK;
    if not Result then
      Exit;

    Result := Pragma<Bool>(DB, 'writable_schema', False, True, R);
    if not Result then
      Exit;

    Result := Vacuum(DB) = SQLITE_OK;
  finally
    Close(DB);
  end;
end;

function SynchronousMode(AConnection: Psqlite3; AValue: TSQLite3SynchronousMode; out AResultCode: TSQLite3ResultCode): Bool;
begin
  Result := Pragma<Str, U8>(AConnection, 'synchronous', SQLite3SynchronousModesText[AValue],
    SQLite3SynchronousModesU8[AValue], AResultCode);
end;

function LockingMode(AConnection: Psqlite3; AValue: TSQLite3LockingMode; out AResultCode: TSQLite3ResultCode): Bool;
begin
  Result := Pragma<Str, Str>(AConnection, 'locking_mode', SQLite3LockingModesText[AValue],
    ToLowerCase(SQLite3LockingModesText[AValue]), AResultCode);
end;

function JournalMode(AConnection: Psqlite3; AValue: TSQLite3JournalMode; out AResultCode: TSQLite3ResultCode): Bool;
begin
  Result := Pragma<Str, Str>(AConnection, 'journal_mode', SQLite3JournalModesText[AValue],
    ToLowerCase(SQLite3JournalModesText[AValue]), AResultCode);
end;

function TempStore(AConnection: Psqlite3; AValue: TSQLite3TempStore; out AResultCode: TSQLite3ResultCode): Bool;
begin
  Result := Pragma<Str, U8>(AConnection, 'temp_store', SQLite3TempStoresText[AValue],
    SQLite3TempStoresU8[AValue], AResultCode);
end;

function Options(AConnection: Psqlite3; ASynchronousMode: TSQLite3SynchronousMode; ALockingMode: TSQLite3LockingMode;
  AJournalMode: TSQLite3JournalMode; ATempStore: TSQLite3TempStore; out AResultCode: TSQLite3ResultCode): Bool;
begin
  Result := SynchronousMode(AConnection, ASynchronousMode, AResultCode);
  Result := Result and LockingMode(AConnection, ALockingMode, AResultCode);
  Result := Result and JournalMode(AConnection, AJournalMode, AResultCode);
  Result := Result and TempStore(AConnection, ATempStore, AResultCode);
end;

function PageSize(AConnection: Psqlite3; AValue: TSQLite3PageSize; out AResultCode: TSQLite3ResultCode): Bool;
begin
  Result := Pragma<TSQLite3PageSize>(AConnection, 'page_size', AValue,
    False, //Not verifying the value as it will not change until next vacuum
    AResultCode);
end;

function PageSize(AConnection: Psqlite3; out AResultCode: TSQLite3ResultCode; out AStatus: Bool): TSQLite3PageSize;
begin
  Result := Pragma<TSQLite3PageSize>(AConnection, 'page_size', AResultCode, AStatus);
end;

function PageSize(AConnection: Psqlite3; AValue: TSQLite3PageSize; AOptions: TSQLite3SetPageSizeOptions;
  out AResultCode: TSQLite3ResultCode): Bool;
var
  PS: TSQLite3PageSize;
begin
  if s3spoCheckBeforeChange in AOptions then //No need to change and vacuum if it already the same
  begin
    PS := PageSize(AConnection, AResultCode, Result);
    if not Result then
      Exit;
    if PS = AValue then
    begin
      AResultCode := SQLITE_OK; //Change from SQLITE_ROW to prevent alert for the caller
      Exit;
    end;
  end;

  Result := PageSize(AConnection, AValue, AResultCode);
  if not Result then
    Exit;

  if s3spoVacuum in AOptions then //Vacuum is needed to reset page_size
  begin
    AResultCode := Vacuum(AConnection);
    Result := AResultCode = SQLITE_OK;
  end;
end;

procedure Code(var AError: TSQLite3Error; ACode: TSQLite3ResultCode);
begin
  AError.Code := ACode;
end;

function Code(constref AError: TSQLite3Error): TSQLite3ResultCode;
begin
  Result := AError.Code;
end;

procedure Message(var AError: TSQLite3Error; const AMessage: Str);
begin
  AError.Message := AMessage;
end;

function Message(constref AError: TSQLite3Error): Str;
begin
  Result := AError.Message;
end;

function HasError(constref AError: TSQLite3Error): Bool;
begin
  Result := AError.Code <> SQLITE_OK;
end;

procedure SQLite3LogCallBack({%H-}pArg: Ptr; {%H-}iErrCode: int; const zMsg: PChar); cdecl;
begin
  WriteLn(StdErr, 'SQLite3Log: ', zMsg);
end;

procedure LogCallbacks;
begin
  sqlite3_config(SQLITE_CONFIG_LOG, @SQLite3LogCallBack, nil);
end;

end.
