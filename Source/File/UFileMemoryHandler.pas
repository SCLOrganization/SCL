unit UFileMemoryHandler;

{$I SCL.inc}

interface

uses
  UNumber, UString, UFile;

type
  TOpenFileMemoryHandlerOption = (ofmhoMap);
  TOpenFileMemoryHandlerOptions = set of TOpenFileMemoryHandlerOption;
  TFileMemoryHandler = record
  private
    Options: TOpenFileMemoryHandlerOptions;
    Buffer: RStr;
    Handler: TFileHandler;
    Mapper: TFileMapper;
    Viewer: TFileMapperViewer;
  end;
  PStrFileHandler = ^TFileMemoryHandler;

function Open(const AFile: TFile; AOptions: TOpenFileMemoryHandlerOptions; out AHandler: TFileMemoryHandler): Bool;
  inline; overload;
function Close(var AHandler: TFileMemoryHandler): Bool; inline; overload;
procedure Start(constref AHandler: TFileMemoryHandler; out P: PChar; out C, L: NChar); inline; overload;

implementation

uses
  UFileHandleHelp;

function Open(const AFile: TFile; AOptions: TOpenFileMemoryHandlerOptions; out AHandler: TFileMemoryHandler): Bool;
begin
  AHandler := Default(TFileMemoryHandler);
  with AHandler do
  begin
    Options := AOptions;
    if ofmhoMap in Options then
      Result := View(AFile, [vfmRead], Handler, Mapper, Viewer)
    else
      Result := Read(AFile, Buffer);
  end;
end;

function Close(var AHandler: TFileMemoryHandler): Bool;
begin
  with AHandler do
    if ofmhoMap in Options then
      Result := Close(Viewer) and Close(Mapper) and Close(Handler)
    else
    begin
      Buffer := '';
      Result := True;
    end;
end;

procedure Start(constref AHandler: TFileMemoryHandler; out P: PChar; out C, L: NChar);
begin
  C := 0;
  with AHandler do
    if ofmhoMap in Options then
    begin
      P := First(Viewer);
      L := Size(Viewer);
    end
    else
    begin
      P := First(Buffer);
      L := Length(Buffer);
    end;
end;

end.
