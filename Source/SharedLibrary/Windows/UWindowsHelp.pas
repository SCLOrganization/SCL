unit UWindowsHelp;

{$I SCL.inc}

interface

uses
  UNumber, UString, UWindows;

function GetErrorMessage(AError: DWORD): Str;

implementation

function GetErrorMessage(AError: DWORD): Str;
var
  lpBuffer: LPWSTR;
  L: DWORD;
begin
  L := FormatMessageW(FORMAT_MESSAGE_ALLOCATE_BUFFER or //Automate memory allocation
    FORMAT_MESSAGE_FROM_SYSTEM or //To process system error code
    FORMAT_MESSAGE_IGNORE_INSERTS, //Prevent issues: https://devblogs.microsoft.com/oldnewthing/20071128-00/?p=24353
    nil, //No source
    AError,
    0, //Default language
    LPWSTR(@lpBuffer),
    0, nil); //Automate memory allocation

  //Remove end of a line
  if (L > 1) and (lpBuffer[L - 1] = #10) and (lpBuffer[L - 2] = #13) then
    L -= 2;
  Create<Str, LPWSTR>(Result, lpBuffer, L);
  LocalFree({%H-}HLOCAL(lpBuffer));
end;

end.
