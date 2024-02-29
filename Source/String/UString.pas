unit UString;

{$I SCL.inc}

interface

uses
  UNumber;

const
  UTF16Codepage = 1200;
  UTF8Codepage = 65001;

type
  AStr = type Ansistring;
  UTF8Str = type Ansistring(UTF8Codepage);
  UTF16Str = type Ansistring(UTF16Codepage);
  RStr = type Rawbytestring;
  Str = String;
  SStr = type Shortstring;
  UStr = type Unicodestring;

  PChar = ^Char;
  PPChar = ^PChar;
  PWideChar = ^Widechar;
  PAStr = ^AStr;
  PStr = ^Str;
  PRStr = ^RStr;
  PSStr = ^SStr;

  NChar = type Ind;

const
  InvalidNChar = High(NChar);

function Count(const {%H-}AChar: Char): Siz; inline; overload;

function First(const AString: RStr): PChar; inline; overload;
function Last(const AString: RStr): NChar; inline; overload;
function Count(const AString: RStr): Siz; inline; overload;
procedure Create<TString; TChar>(out AString: TString; AData: TChar; ALength: Siz); inline; overload;

implementation

function Count(const AChar: Char): Siz;
begin
  Result := 1;
end;

function First(const AString: RStr): PChar;
begin
  Result := PChar(AString);
end;

function Count(const AString: RStr): Siz;
begin
  Result := System.Length(AString);
end;

function Last(const AString: RStr): NChar;
begin
  Result := Count(AString) - 1;
end;

procedure Create<TString; TChar>(out AString: TString; AData: TChar; ALength: Siz);
begin
  System.SetString(AString, AData, ALength);
end;

initialization
  //Support Unicode string operations
  //Todo: Improve
  SetMultiByteConversionCodePage(CP_UTF8);
  SetMultiByteRTLFileSystemCodePage(CP_UTF8);
end.
