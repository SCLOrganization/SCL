uses
  BaseUnix, Unix, errors;

const
  ErrorCodes: array[TSystemErrorKind] of TSystemErrorCode = (
    -1,
    0,
    ESysENOENT,
    ESysENOENT, //Same as sekPathNotFound
    ESysEEXIST,
    ESysENOSPC);

//System sleep in MS
function Sleep(const ADuration: UPS): Bool;
var
  rem, req: TTimeSpec;
begin
  req.tv_nsec := (ADuration mod 1000) * 1000000;
  req.tv_sec := ADuration div 1000;
  Result := FpNanoSleep(@req, @rem) = 0;
end;

function LastSystemErrorCode: TSystemErrorCode;
begin
  Result := fpgeterrno;
end;

function LastSystemErrorMessage: Str;
begin
  Result := StrError(fpgeterrno);
end;
