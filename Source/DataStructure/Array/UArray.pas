unit UArray;

{$I SCL.inc}

interface

uses
  UNumber;

type
  TArray<T> = array of T;

function Count<T>(var AArray: TArray<T>; ACount: Siz): Bool; inline; overload;
function Count<T>(constref AArray: TArray<T>): Siz; inline; overload;
procedure Delete<T>(var AArray: TArray<T>; AIndex: Ind; ACount: Siz); inline; overload;
procedure Insert<T>(const AItem: T; var AArray: TArray<T>; AIndex: Ind); inline; overload;

implementation

//Todo: Improve
function Count<T>(var AArray: TArray<T>; ACount: Siz): Bool;
begin
  try
    SetLength(AArray, ACount);
    Result := True;
  except
    Result := False;
  end;
end;

function Count<T>(constref AArray: TArray<T>): Siz;
begin
  Result := System.Length(AArray);
end;

procedure Delete<T>(var AArray: TArray<T>; AIndex: Ind; ACount: Siz);
begin
  System.Delete(AArray, AIndex, ACount);
end;

procedure Insert<T>(const AItem: T; var AArray: TArray<T>; AIndex: Ind);
begin
  System.Insert(AItem, AArray, AIndex);
end;

end.
