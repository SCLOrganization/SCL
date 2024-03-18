unit UTickHelp;

{$I SCL.inc}

interface

uses
  UNumber, UString, UTick;

procedure LogSpentTick(const AStartTick: Tik); inline; overload;
procedure LogSpentTick(const ACaption: Str; const AStartTick: Tik); inline; overload;

procedure Start; inline; overload;
procedure Stop; inline; overload;
procedure Stop(const ACaption: Str); inline; overload;

implementation

threadvar
  StartedTick: Tik;

procedure LogSpentTick(const AStartTick: Tik);
begin
  WriteLn(Tick - AStartTick, 'ms');
end;

procedure LogSpentTick(const ACaption: Str; const AStartTick: Tik);
begin
  WriteLn(ACaption, ': ', Tick - AStartTick, 'ms');
end;

procedure Start;
begin
  StartedTick := Tick;
end;

procedure Stop;
begin
  LogSpentTick(StartedTick);
end;

procedure Stop(const ACaption: Str);
begin
  LogSpentTick(ACaption, StartedTick);
end;

end.
