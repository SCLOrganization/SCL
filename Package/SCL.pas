{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit SCL;

{$warn 5023 off : no warning about unused units}
interface

uses
  UNumber, UString, UException, UExceptionHelp, UNumberHelp, UMemory, UArray, UArrayHelp, UList, UListHelp, UFile, 
  UFileHelp, USegment, USegmentHelp, UStringHelp, UStringHandle, UStringHandleHelp, UStringCount, UStringSplit, 
  UStringSplitHelp, UStringCompare, UStringCheck, UStringCase, UFilePathHelp, UProgram, UProgramCommandLine, UConsole, 
  UThread, UThreadGroup, UThreadHelp, USystem, USystemCPU, USystemHelp, UTick, UTickHelp, UMemoryBlock, UFileMemoryHandler, 
  UFileCompare, UFileHandleHelp, UMemorySwap, UMemoryHelp, UArraySort, UByteUnit, UByteUnitHelp, UMemoryCompare, 
  UFileMemoryHandlerHelp, USQLite3, USQLite3Help, USQLite3LibraryStatic, UZstandard, UZstandardHelp, 
  UZstandardLibraryStatic, UFileEnumerateHelp, UxxHash, UxxHashLibraryStatic, LazarusPackageIntf;

implementation

procedure Register;
begin
end;

initialization
  RegisterPackage('SCL', @Register);
end.
