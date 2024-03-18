unit USystem;

{$I SCL.inc}

interface

uses
  UNumber, UString;

function Sleep(const ADuration: UPS): Bool; inline;

type
  TSystemErrorCode = IPS;
  TSystemErrorKind = (sekUnknown, sekNone, sekDoesNotExists, sekAlreadyExists, sekDiskIsFull, sekInvalidFileSystemName);

function LastSystemError: TSystemErrorKind; inline; overload;
function LastSystemErrorCode: TSystemErrorCode;
function LastSystemErrorMessage: Str;
function Kind(ACode: TSystemErrorCode): TSystemErrorKind; inline; overload;

implementation

{$IfDef Windows}
{$I USystemWindows.inc}
{$EndIf}
{$IfDef Posix}
{$I USystemPosix.inc}
{$EndIf}

function Kind(ACode: TSystemErrorCode): TSystemErrorKind;
var
  F: TSystemErrorKind;
  I: Ind;
begin
  for F := Succ(Low(TSystemErrorKind)) to High(TSystemErrorKind) do
    for I := 0 to High(ErrorCodes[F]) do
      if ErrorCodes[F][I] = ACode then
        Exit(F);
  Result := sekUnknown;
end;

function LastSystemError: TSystemErrorKind;
begin
  Result := Kind(LastSystemErrorCode);
end;

end.
