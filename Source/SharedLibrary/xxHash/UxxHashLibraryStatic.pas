unit UxxHashLibraryStatic;

{$I SCL.inc}

interface

implementation

uses
  {$IfDef Windows}
  UWindowsLibC,
  {$EndIF}
  UxxHash, UException, UStringHelp;

  {$LinkLib libxxhash.a}

procedure CheckVersion;
const
  Expected = 802;
begin
  if XXH_versionNumber <> Expected then
    raise Exception.Create('Wrong SQLite version. ' + 'Expected: ' + ToStr(Expected) + ' but linked ' +
      ToStr(XXH_versionNumber) + '.');
end;

initialization
  CheckVersion;
end.
