unit UThreadHelp;

{$I SCL.inc}

interface

uses
  UNumber, UThread, UThreadGroup;

procedure Create(out AThread: TThread; constref AMethod: TThreadMethod; AParameter: Ptr); overload;
function Start(out AThread: TThread; constref AMethod: TThreadMethod; AParameter: Ptr): Bool; overload;

procedure Create(out AGroup: TThreadGroup; ACount: U8; constref AMethod: TThreadGroupMethod; AParameter: Ptr); overload;
function Start(out AGroup: TThreadGroup; ACount: U8; constref AMethod: TThreadGroupMethod; AParameter: Ptr): Bool; overload;

implementation

procedure Create(out AThread: TThread; constref AMethod: TThreadMethod; AParameter: Ptr);
begin
  AThread := Default(TThread);
  Initialize(AThread);
  Method(AThread, AMethod);
  Parameter(AThread, AParameter);
end;

function Start(out AThread: TThread; constref AMethod: TThreadMethod; AParameter: Ptr): Bool;
begin
  Create(AThread, AMethod, AParameter);
  Result := Execute(AThread);
end;

procedure Create(out AGroup: TThreadGroup; ACount: U8; constref AMethod: TThreadGroupMethod; AParameter: Ptr);
begin
  AGroup := Default(TThreadGroup);
  Initialize(AGroup);
  Count(AGroup, ACount);
  Method(AGroup, AMethod);
  Parameter(AGroup, AParameter);
end;

function Start(out AGroup: TThreadGroup; ACount: U8; constref AMethod: TThreadGroupMethod; AParameter: Ptr): Bool;
begin
  Create(AGroup, ACount, AMethod, AParameter);
  Result := Execute(AGroup);
end;

end.
