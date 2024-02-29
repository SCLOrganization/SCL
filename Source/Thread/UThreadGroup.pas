unit UThreadGroup;

{$I SCL.inc}

interface

uses
  UNumber, UThread;

type
  TThreadGroupMethod = reference to procedure(AThreadIndex: Ind; AParameter: Ptr);
  PThreadGroup = ^TThreadGroup;
  TThreadGroupItem = record
  private
    Index: Ind;
    Thread: TThread;
    Group: PThreadGroup;
  end;
  PThreadGroupItem = ^TThreadGroupItem;

  TThreadGroup = record
  private
    Method: TThreadGroupMethod;
    Parameter: Ptr;
    StackSize: Siz;
    Items: array of TThreadGroupItem;
  end;

procedure Count(var AGroup: TThreadGroup; ACount: U8); overload;
procedure Method(var AGroup: TThreadGroup; constref AMethod: TThreadGroupMethod); overload;
procedure Parameter(var AGroup: TThreadGroup; AParameter: Ptr); overload;
procedure StackSize(var AGroup: TThreadGroup; AStackSize: Siz); overload;

function Execute(var AGroup: TThreadGroup): Bool; overload;
procedure WaitFor(constref AGroup: TThreadGroup); overload;
function Close(var AGroup: TThreadGroup): Bool; overload;

implementation

procedure Count(var AGroup: TThreadGroup; ACount: U8);
var
  I: Ind;
begin
  //Todo: Control if current Count is not zero
  SetLength(AGroup.Items, ACount);
  for I := 0 to High(AGroup.Items) do
    with AGroup.Items[I] do
    begin
      Index := I;
      Thread := Default(TThread);
      Initialize(Thread);
      Group := @AGroup;
    end;
end;

procedure Method(var AGroup: TThreadGroup; constref AMethod: TThreadGroupMethod);
begin
  AGroup.Method := AMethod;
end;

procedure Parameter(var AGroup: TThreadGroup; AParameter: Ptr);
begin
  AGroup.Parameter := AParameter;
end;

procedure StackSize(var AGroup: TThreadGroup; AStackSize: Siz);
begin
  AGroup.StackSize := AStackSize;
end;

procedure ExecuteThread(AItem: Ptr);
begin
  with PThreadGroupItem(AItem)^ do
    Group^.Method(Index, Group^.Parameter);
end;

function Execute(var AGroup: TThreadGroup): Bool;
var
  I: Ind;
begin
  Result := True;
  for I := 0 to High(AGroup.Items) do
    with AGroup.Items[I] do
    begin
      Method(Thread, ExecuteThread);
      Parameter(Thread, @AGroup.Items[I]);
      if AGroup.StackSize <> 0 then
        StackSize(Thread, AGroup.StackSize);
      Result := Execute(Thread);
      if not Result then
        Exit;
    end;
end;

procedure WaitFor(constref AGroup: TThreadGroup);
var
  I: Ind;
begin
  with AGroup do
    for I := 0 to High(Items) do
      WaitFor(Items[I].Thread);
end;

function Close(var AGroup: TThreadGroup): Bool;
var
  I: Ind;
begin
  with AGroup do
    for I := 0 to High(Items) do
      Close(Items[I].Thread);
  Result := True;
end;

end.
