uses
  UWindows, UWindowsHelp;

const
  ErrorCodes: array[TSystemErrorKind] of array of TSystemErrorCode = (
    [-1],
    [ERROR_SUCCESS],
    [ERROR_PATH_NOT_FOUND, ERROR_FILE_NOT_FOUND],
    [ERROR_ALREADY_EXISTS, ERROR_FILE_EXISTS],
    [ERROR_DISK_FULL],
    [ERROR_INVALID_NAME]);

function Sleep(const ADuration: UPS): Bool;
begin
  UWindows.Sleep(ADuration);
  Result := True;
end;

function LastSystemErrorCode: TSystemErrorCode;
begin
  Result := GetLastError;
end;

function LastSystemErrorMessage: Str;
begin
  Result := GetErrorMessage(GetLastError);
end;
