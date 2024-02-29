unit UTickHelp;

{$I SCL.inc}

interface

uses
  UNumber, UTick;

procedure Start; inline; overload;
procedure Stop; inline; overload;

implementation

threadvar
  StartedTick: Tik;

procedure Start;
begin
  StartedTick := Tick;
end;

procedure Stop;
begin
  WriteLn(Tick - StartedTick, 'ms');
end;

end.
