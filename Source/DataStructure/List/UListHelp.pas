unit UListHelp;

{$I SCL.inc}

interface

uses
  UNumber, UList;

function AddEmpty<T>(var AList: TList<T>): Ind; overload;
function AddEmpty<T>(var AList: TList<T>; out APointer: Ptr): Ind; overload;
function AddEmptyPointer<T>(var AList: TList<T>): Ptr; overload;

implementation

function AddEmpty<T>(var AList: TList<T>): Ind;
begin
  Result := Count<T>(AList);
  Count<T>(AList, Result + 1);
end;

function AddEmpty<T>(var AList: TList<T>; out APointer: Ptr): Ind;
begin
  Result := AddEmpty<T>(AList);
  APointer := ItemPointer<T>(AList, Result);
end;

function AddEmptyPointer<T>(var AList: TList<T>): Ptr;
begin
  AddEmpty<T>(AList, Result);
end;

end.
