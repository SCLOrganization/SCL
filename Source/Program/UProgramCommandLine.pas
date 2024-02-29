unit UProgramCommandLine;

{$I SCL.inc}

interface

uses
  UNumber, UString;

type
  TParseProgramCommandLineParameterKind = (ppclpkUnknown, ppclpkName, ppclpkValue, ppclpkNameValue);

function Parse(const P: PChar; C, L: NChar; var ACanBeValue: Bool; out AKind: TParseProgramCommandLineParameterKind;
  out ANameStart, ANameFinish, AValueStart, AValueFinish: NChar): Bool;

type
  TProgramCommandLineParameter = record
  private
    Name: Str;
    Value: Str;
  end;
  PProgramCommandLineParameter = ^TProgramCommandLineParameter;
  TProgramCommandLineParameterArray = array of TProgramCommandLineParameter;

function Name(constref AParameter: TProgramCommandLineParameter): Str; inline; overload;
function Value(constref AParameter: TProgramCommandLineParameter): Str; inline; overload;

function Parameters: TProgramCommandLineParameterArray; overload;

implementation

uses
  UStringHelp, UStringHandle, UList, UListHelp;

function Parse(const P: PChar; C, L: NChar; var ACanBeValue: Bool; out AKind: TParseProgramCommandLineParameterKind; out
  ANameStart, ANameFinish, AValueStart, AValueFinish: NChar): Bool;

  procedure SetName(A, B: NChar);
  begin
    AKind := ppclpkName;
    ANameStart := A;
    ANameFinish := B;
  end;

  procedure SetValue(A, B: NChar);
  begin
    if AKind = ppclpkName then
      AKind := ppclpkNameValue
    else
    begin
      ANameStart := InvalidNChar;
      ANameFinish := InvalidNChar;
      AKind := ppclpkValue;
    end;
    AValueStart := A;
    AValueFinish := B;
    ACanBeValue := False; //Value is handled, so the next one must be a Name
  end;

  function SetError: Bool;
  begin
    AKind := ppclpkUnknown;
    ANameStart := InvalidNChar;
    ANameFinish := InvalidNChar;
    AValueStart := C;
    AValueFinish := L - 1;
    Result := False;
  end;

var
  S: NChar;
begin
  Result := False;
  AKind := ppclpkUnknown;
  case L of
    0: Exit(SetError); //Invalid Name
    1: //It can only be a value, as names are only -X or --XX
      if ACanBeValue then
        SetValue(C, C)
      else
        Exit(SetError); //Invalid Name
    2: //Either -X or a Value
      if (P[C] = '-') and (P[C + 1] <> '-') then //Is Name
      begin
        C += 1;
        SetName(C, C);
        ACanBeValue := True; //Wait for Name or Value
      end
      else if ACanBeValue then //Can have Value
        SetValue(C, C + 1)
      else
        Exit(SetError); //Invalid Name
    else //Either --XX=XX or a Value
    begin
      if (P[C] = '-') and (P[C + 1] = '-') and (P[C + 2] <> '-') then
      begin
        if P[C + 2] = '-' then
          Exit(SetError); //Invalid Name
        C += 2; //--
        S := C;
        C := Next(P, C, L, '=');
        SetName(S, C - 1);
        if C <> L then //Has Value
          SetValue(C + 1, L - 1);
      end
      else if ACanBeValue then //Can have Value
      begin
        SetValue(C, L - 1);
      end
      else
        Exit(SetError); //Invalid Name
    end;
  end;
  Result := True;
end;

function Name(constref AParameter: TProgramCommandLineParameter): Str;
begin
  Result := AParameter.Name;
end;

function Value(constref AParameter: TProgramCommandLineParameter): Str;
begin
  Result := AParameter.Value;
end;

var
  ProgramParameters: TProgramCommandLineParameterArray;

function Parameters: TProgramCommandLineParameterArray;
begin
  Result := ProgramParameters;
end;

//Todo: Using OS instead of System Unit
procedure ParseAll;
var
  I: Ind;
  P: PChar;
  C, L, NS, NF, VS, VF: NChar;
  CBV: Bool;
  K: TParseProgramCommandLineParameterKind;
  List: TList<TProgramCommandLineParameter>;
  PP: PProgramCommandLineParameter = nil;
begin
  Create<TProgramCommandLineParameter>(List, ProgramParameters, [loPacked]);
  CBV := False; //Start from a Name
  for I := 1 to System.ParamCount do //0 is Executable path
  begin
    Start(objpas.ParamStr(I), P, C, L); //Quotes are handled at ParamStr
    Parse(P, C, L, CBV, K, NS, NF, VS, VF);
    if K <> ppclpkValue then //Add only if it is not a Value
      PP := PProgramCommandLineParameter(AddEmptyPointer<TProgramCommandLineParameter>(List));
    case K of
      ppclpkUnknown: PP^.Value := Create(P, VS, VF); //To Report error, but continue
      ppclpkName: PP^.Name := Create(P, NS, NF);
      ppclpkValue: PP^.Value := Create(P, VS, VF); //If it is Value, then PP is set to previous one
      ppclpkNameValue:
      begin
        PP^.Name := Create(P, NS, NF);
        PP^.Value := Create(P, VS, VF);
      end;
    end;
  end;
end;

initialization
  ParseAll;
end.
