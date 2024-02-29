unit USystemCPU;

{$I SCL.inc}

interface

uses
  UNumber;

function LogicalProcessorCount: I32;

implementation

{$IfDef Windows}
{$I USystemCPUWindows.inc}
{$EndIf}
{$IfDef Posix}
{$I USystemCPUPosix.inc}
{$EndIf}

end.
