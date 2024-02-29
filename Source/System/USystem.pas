unit USystem;

{$I SCL.inc}

interface

uses
  UNumber, UString;

function Sleep(const ADuration: UPS): Bool; inline;

type
  TSystemErrorCode = IPS;
  TSystemErrorKind = (sekUnknown, sekNone, sekPathNotFound, sekFileNotFound, sekAlreadyExists, sekDiskIsFull);

function LastSystemError: TSystemErrorKind; inline; overload;
function LastSystemErrorCode: TSystemErrorCode;
function LastSystemErrorMessage: Str;
function Kind(ACode: TSystemErrorCode): TSystemErrorKind; inline; overload;
function Code(AKind: TSystemErrorKind): TSystemErrorCode; inline; overload;

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
begin
  for F := Succ(Low(TSystemErrorKind)) to High(TSystemErrorKind) do
    if ErrorCodes[F] = ACode then
      Exit(F);
  Result := sekUnknown;
end;

function Code(AKind: TSystemErrorKind): TSystemErrorCode;
begin
  Result := ErrorCodes[AKind];
end;

function LastSystemError: TSystemErrorKind;
begin
  Result := Kind(LastSystemErrorCode);
end;

end.
