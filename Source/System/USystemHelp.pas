unit USystemHelp;

{$I SCL.inc}

interface

uses
  UNumber, UString, USystem;

type
  TSystemError = record
  private
    Code: TSystemErrorCode;
    Message: Str;
  end;
  POSError = ^TSystemError;

procedure Code(var AError: TSystemError; ACode: TSystemErrorCode); inline; overload;
function Code(constref AError: TSystemError): TSystemErrorCode; inline; overload;
procedure Message(var AError: TSystemError; const AMessage: Str); inline; overload;
function Message(constref AError: TSystemError): Str; inline; overload;
function Kind(constref AError: TSystemError): TSystemErrorKind; inline; overload;

function HasError(constref AError: TSystemError): Bool; inline; overload;
procedure UpdateToLast(var AError: TSystemError); inline; overload;

implementation

procedure Code(var AError: TSystemError; ACode: TSystemErrorCode);
begin
  AError.Code := ACode;
end;

function Code(constref AError: TSystemError): TSystemErrorCode;
begin
  Result := AError.Code;
end;

procedure Message(var AError: TSystemError; const AMessage: Str);
begin
  AError.Message := AMessage;
end;

function Message(constref AError: TSystemError): Str;
begin
  Result := AError.Message;
end;

function Kind(constref AError: TSystemError): TSystemErrorKind;
begin
  Result := Kind(AError.Code);
end;

function HasError(constref AError: TSystemError): Bool;
begin
  Result := Kind(AError) <> sekNone;
end;

procedure UpdateToLast(var AError: TSystemError);
begin
  //Code(AError, LastSystemErrorCode);
  //Message(AError, LastSystemErrorMessage);
end;

end.
