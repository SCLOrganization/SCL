unit UPosix;

{$I SCL.inc}

interface

uses
  UNumber, UString,
  BaseUnix, syscall;

const
  RENAME_NOREPLACE = 1;
  RENAME_EXCHANGE = 2;
  RENAME_WHITEOUT = 4;

  DT_UNKNOWN = 0;
  DT_FIFO = 1;
  DT_CHR = 2;
  DT_DIR = 4;
  DT_BLK = 6;
  DT_REG = 8;
  DT_LNK = 10;
  DT_SOCK = 12;
  DT_WHT = 14;

function renameat2(olddirfd: cint; const oldpath: PChar; newdirfd: cint; const newpath: PChar; flags: cint): cint;

implementation

function renameat2(olddirfd: cint; const oldpath: PChar; newdirfd: cint; const newpath: PChar; flags: cint): cint;
begin
  Result := Do_SysCall(syscall_nr_renameat2, TSysParam(olddirfd), {%H-}TSysParam(oldpath), TSysParam(newdirfd),
    {%H-}TSysParam(newpath), TSysParam(flags));
end;

end.
