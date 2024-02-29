unit UByteUnit;

{$I SCL.inc}

interface

uses
  UString;

type
  TByteUnit = (buB,
    buKilo, buMega, buGiga, buTera, buPeta, buExa,
    buKibi, buMebi, buGibi, buTebi, buPebi, buExbi);
  TByteUnitSystem = (busDecimal, busBinary);

const
  ByteUnits: array[TByteUnit] of Str = (
    'B', 'kB', 'MB', 'GB', 'TB', 'PB', 'EB',
    'KiB', 'MiB', 'GiB', 'TiB', 'PiB', 'EiB');

implementation

end.
