unit UException;

{$I SCL.inc}

interface

uses
  {$IfDef Windows}
  UWindows,
  {$EndIf}
  UNumber,
  UString;

type
  Exception = class
  private
    FMessage: Str; //Must be the first as debugger needs it
  public
    constructor Create(const AMessage: Str); overload;
  published
    property Message: Str read FMessage write FMessage;
  end;

  ExceptionClass = class of Exception;

  ESystemException = class(Exception)
  private
    FCode: IPS;
  public
    constructor Create(ACode: IPS); overload;
  published
    property Code: IPS read FCode write FCode;
  end;

implementation

constructor Exception.Create(const AMessage: Str);
begin
  FMessage := AMessage;
end;

constructor ESystemException.Create(ACode: IPS);
begin
  FCode := ACode;
end;

procedure HandleUnhandledException(AExceptionObject: TObject; AAddress: CodePointer; {%H-}FrameCount: Longint;
  {%H-}AFrame: PCodePointer);
begin
  WriteLn(StdErr, 'Unhandled exception at #', {%H-}UPS(AAddress), ':');
  if AExceptionObject is ESystemException then
    with ESystemException(AExceptionObject) do
      WriteLn(StdErr, '  ', ClassName, ': Code = ', Code)
  else if AExceptionObject is Exception then
    with Exception(AExceptionObject) do
      WriteLn(StdErr, '  ', ClassName, ': "', Message, '"');
end;

{$IfDef Windows}
function HandleException(ACode: LongInt; const {%H-}ARecord: EXCEPTION_RECORD): ESystemException;
begin
  Result := ESystemException.Create(ACode);
end;

function GetExceptionClassForSystemError({%H-}ACode: LongInt): ExceptionClass;
begin
  Result := ESystemException;
end;

{$ElSE}

procedure HandleError(AErrorCode: LongInt; AAddress: CodePointer; AFrame: Pointer);
begin
  raise ESystemException.Create(AErrorCode) at AAddress, AFrame;
end;
{$EndIf}

initialization
  ExceptProc := @HandleUnhandledException;
  {$IfDef Windows}
  //Compiler issue: ErrorProc is not supported by FPC for Windows
  ExceptObjProc := @HandleException; //Called by System to handle Exception
  ExceptClsProc := @GetExceptionClassForSystemError; //Called to get System Exception Class for exception handler
  {$Else}
  ErrorProc := @HandleError;
  {$EndIf}
end.
