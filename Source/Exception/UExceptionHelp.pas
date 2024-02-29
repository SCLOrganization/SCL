unit UExceptionHelp;

{$I SCL.inc}

interface

uses
  UString, UException;

procedure RaiseNotSupportedType; inline;
procedure RaiseNotSupported; inline;

implementation

//Compiler issue: There should be a function to raise this error at compile time
procedure RaiseNotSupportedType;
begin
  raise Exception.Create('This type is not supported.');
end;

procedure RaiseNotSupported;
begin
  raise Exception.Create('This is not supported.');
end;

end.
