unit UThread;

{$I SCL.inc}

interface

uses
  UNumber, UString;

type
  TThreadMethod = reference to procedure(AParameter: Ptr);
  TThread = record
  private
    Method: TThreadMethod;
    Parameter: Ptr;
    StackSize: Siz;
    Handle: TThreadID;
    Paused: Bool;
    class operator Initialize(var AThread: TThread);
  end;
  PThread = ^TThread;

procedure Method(var AThread: TThread; const AMethod: TThreadMethod); overload;
procedure Parameter(var AThread: TThread; AParameter: Ptr); overload;
procedure StackSize(var AThread: TThread; AStackSize: Siz); overload;

function Execute(var AThread: TThread): Bool; overload;
procedure WaitFor(constref AThread: TThread); overload;
function Pause(var AThread: TThread): Bool; overload;
function Resume(var AThread: TThread): Bool; overload;
function Close(var AThread: TThread): Bool; overload;

type
  TCriticalSection = record
  private
    CriticalSection: TRTLCriticalSection;
  end;
  PCriticalSection = ^TCriticalSection;

procedure Create(out ACriticalSection: TCriticalSection); overload;
procedure Enter(var ACriticalSection: TCriticalSection); overload;
function TryEnter(var ACriticalSection: TCriticalSection): Bool; overload;
procedure Leave(var ACriticalSection: TCriticalSection); overload;
procedure Destroy(var ACriticalSection: TCriticalSection); overload;

function InterlockedIncrement(var AValue: IPS): IPS; inline; overload;
function InterlockedDecrement(var AValue: IPS): IPS; inline; overload;
function InterlockedAdd(var AValue: IPS; AAddend: IPS): IPS; inline; overload;
function InterlockedExchange(var AValue: IPS; ANew: IPS): IPS; inline; overload;
function InterlockedCompareExchange(var AValue: IPS; ANew, AComperand: IPS): IPS; inline; overload;

function InterlockedIncrement(var AValue: UPS): UPS; inline; overload;
function InterlockedDecrement(var AValue: UPS): UPS; inline; overload;
function InterlockedAdd(var AValue: UPS; AAddend: UPS): UPS; inline; overload;
function InterlockedExchange(var AValue: UPS; ANew: UPS): UPS; inline; overload;
function InterlockedCompareExchange(var AValue: UPS; ANew, AComperand: UPS): UPS; inline; overload;

implementation

procedure Method(var AThread: TThread; const AMethod: TThreadMethod);
begin
  AThread.Method := AMethod;
end;

procedure Parameter(var AThread: TThread; AParameter: Ptr);
begin
  AThread.Parameter := AParameter;
end;

procedure StackSize(var AThread: TThread; AStackSize: Siz);
begin
  AThread.StackSize := AStackSize;
end;

function Act(AParameter: Pointer): PtrInt; overload;
var
  Thread: PThread absolute AParameter;
begin
  Thread^.Method(Thread^.Parameter);
  Result := 0; //No return code
end;

function Execute(var AThread: TThread): Bool;
var
  ID: TThreadID;
begin
  AThread.Handle := BeginThread(nil, //No signal action
    AThread.StackSize, Act, @AThread,
    0, //No creation flags
    ID{%H-});
  Result := AThread.Handle <> TThreadID(0);
end;

procedure WaitFor(constref AThread: TThread);
begin
  WaitForThreadTerminate(AThread.Handle,
    0); //Wait indefinitely
end;

function Pause(var AThread: TThread): Bool;
begin
  if AThread.Paused then
    Exit(False);
  Result := SuspendThread(AThread.Handle) = 0;
  AThread.Paused := Result;
end;

function Resume(var AThread: TThread): Bool;
begin
  if not AThread.Paused then
    Exit(False);

  //Returns SuspendThread count and as Pause does not allow more than one pause, checks for 1
  Result := ResumeThread(AThread.Handle) = 1;
  AThread.Paused := not Result;
end;

//Todo: ThreadManager returns diffrent result depending on the platform
// Windows returns 1 on success
// Unix always returns 0 and does nothing
function Close(var AThread: TThread): Bool;
begin
  CloseThread(AThread.Handle);
  Result := True;
end;

class operator TThread.Initialize(var AThread: TThread);
begin
  AThread.StackSize := 128 * 1024;
end;

procedure Create(out ACriticalSection: TCriticalSection);
begin
  InitCriticalSection(ACriticalSection.CriticalSection);
end;

//Tries to enter a section or suspend current thread
procedure Enter(var ACriticalSection: TCriticalSection);
begin
  EnterCriticalSection(ACriticalSection.CriticalSection);
end;

//Returns true if current thread already entered the section or just entered
function TryEnter(var ACriticalSection: TCriticalSection): Bool;
begin
  Result := TryEnterCriticalSection(ACriticalSection.CriticalSection) <> 0;
end;

procedure Leave(var ACriticalSection: TCriticalSection);
begin
  LeaveCriticalSection(ACriticalSection.CriticalSection);
end;

procedure Destroy(var ACriticalSection: TCriticalSection);
begin
  DoneCriticalSection(ACriticalSection.CriticalSection);
end;

function InterlockedIncrement(var AValue: IPS): IPS;
begin
  Result := System.InterlockedIncrement64(AValue);
end;

function InterlockedDecrement(var AValue: IPS): IPS;
begin
  Result := System.InterlockedDecrement64(AValue);
end;

//Adds AAddend to AValue and returns the old AValue
function InterlockedAdd(var AValue: IPS; AAddend: IPS): IPS;
begin
  Result := System.InterlockedExchangeAdd64(AValue, AAddend);
end;

//Stores ANew in AValue and returns the old AValue
function InterlockedExchange(var AValue: IPS; ANew: IPS): IPS;
begin
  Result := System.InterlockedExchange64(AValue, ANew);
end;

//If AValue and AComperand are equal, stores ANew in AValue and returns the old AValue
function InterlockedCompareExchange(var AValue: IPS; ANew, AComperand: IPS): IPS;
begin
  Result := System.InterlockedCompareExchange64(AValue, ANew, AComperand);
end;

function InterlockedIncrement(var AValue: UPS): UPS;
begin
  Result := System.InterlockedIncrement64(AValue);
end;

function InterlockedDecrement(var AValue: UPS): UPS;
begin
  Result := System.InterlockedDecrement64(AValue);
end;

//Adds AAddend to AValue and returns the old AValue
function InterlockedAdd(var AValue: UPS; AAddend: UPS): UPS;
begin
  Result := System.InterlockedExchangeAdd64(AValue, AAddend);
end;

function InterlockedExchange(var AValue: UPS; ANew: UPS): UPS;
begin
  Result := System.InterlockedExchange64(AValue, ANew);
end;

//If AValue and AComperand are equal, stores ANew in AValue and returns the old AValue
function InterlockedCompareExchange(var AValue: UPS; ANew, AComperand: UPS): UPS;
begin
  Result := System.InterlockedCompareExchange64(AValue, ANew, AComperand);
end;

end.
