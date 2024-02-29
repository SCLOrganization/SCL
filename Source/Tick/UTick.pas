unit UTick;

{$I SCL.inc}

interface

uses
  UNumber;

type
  TTickCount = type IPS; //System tick count in the highest resolution
  TTickMicrosecond = type IPS;
  TTickMillisecond = type IPS;
  Tik = type TTickMillisecond;
  TTikDynArray = array of Tik;

function TickCount: TTickCount; inline;
function Tick: Tik; inline;
function ToMicrosecond(const ATick: TTickCount): TTickMicrosecond; inline;
function ToMillisecond(const ATick: TTickCount): TTickMillisecond; inline;

implementation

{$IfDef Windows}
{$I UTickWindows.inc}
{$EndIf}
{$IfDef Linux}
{$I UTickLinux.inc}
{$EndIf}

function ToMillisecond(const ATick: TTickCount): TTickMillisecond;
begin
  Result := ToMicrosecond(ATick) div 1000;
end;

function Tick: Tik;
begin
  Result := ToMillisecond(TickCount);
end;

initialization
  InitializeUnit;
end.
