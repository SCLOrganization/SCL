{$Mode Delphi}

{$ModeSwitch ClassicProcVars+}
{$ModeSwitch ObjPas+}
{$ModeSwitch PCharToString-}
{$ModeSwitch Result+}
{$ModeSwitch Out+}
{$ModeSwitch Exceptions+}
{$ModeSwitch AutoDeref-}
{$ModeSwitch Class+}
{$ModeSwitch DuplicateLocals-}
{$ModeSwitch HintDirective+}
{$ModeSwitch InitFinal+}
{$ModeSwitch AdvancedRecords+}
{$ModeSwitch DefaultParameters-}
{$ModeSwitch ArrayOperators+}
{$ModeSwitch PointerToProcVar+}
{$ModeSwitch Properties+}
{$ModeSwitch RepeatForward-}
{$ModeSwitch TypeHelpers+}
{$ModeSwitch UnicodeStrings-}
{$ModeSwitch NestedProcVars+}
{$ModeSwitch AnonymousFunctions+}
{$ModeSwitch FunctionReferences+}

{$LongStrings On}
{$PointerMath On}
{$TypedAddress On}
{$BoolEval Off}
{$VarStringChecks Off}

{$PackEnum 1}
{$PackSet 1}

{$CodePage UTF8}

{$IfDef Release}
  {$Inline On}
  {$RangeChecks Off}
  {$OverflowChecks Off}
  {$Assertions Off}
  {$StackChecking Off}
{$Else}
  {$Inline Off}
  {$RangeChecks On}
  {$OverflowChecks On}
  {$Assertions On}
  {$StackChecking On}
  {$Warn 3124 Off : Inlining disabled}
{$EndIf}

{$IfDef Debug}
  {$Define HeapTrace}
{$EndIf}

{$IfDef CPUX64}
  {$ASMMode Intel}
{$EndIf}

{$IfDef Unix}
  {$Define Posix}
{$EndIf}
