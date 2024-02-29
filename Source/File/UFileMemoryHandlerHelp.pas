unit UFileMemoryHandlerHelp;

{$I SCL.inc}

interface

uses
  UNumber, UString, UFile, UFileMemoryHandler;

function Start(const AFile: TFile; AOptions: TOpenFileMemoryHandlerOptions; out AHandler: TFileMemoryHandler;
  out P: PChar; out C, L: NChar): Bool; inline; overload;

implementation

function Start(const AFile: TFile; AOptions: TOpenFileMemoryHandlerOptions; out AHandler: TFileMemoryHandler;
  out P: PChar; out C, L: NChar): Bool;
begin
  Result := Open(AFile, AOptions, AHandler);
  if Result then
    Start(AHandler, P, C, L)
  else
  begin
    P := nil;
    C := InvalidNChar;
    L := InvalidNChar;
  end;
end;

end.
