unit mtConst;

{$ifdef fpc}
 {$mode delphi}
{$endif}

interface

uses
  Classes, SysUtils;

const
  AU = 149597869.0;             // astronomical unit in km
  EARTH_RADIUS = 6378.15;       // earch radius, in km

  HELPFILENAME  = 'moontool.chm';
  HC_MAIN       = 1000;
  HC_MAINFORM   = 1010;
  HC_MOREDATA   = 1012;
  HC_SET_UTC    = 1020;
  HC_SET_JULIAN = 1030;
  HC_SET_JEWISH = 1035;
  HC_LOCATIONS  = 1038;
  HC_CLIPBOARD  = 1040;
  HC_SYSTRY     = 1050;
  HC_TIMEZONES  = 1055;


  LANGUAGE_DIR = 'languages';

  DROPDOWN_COUNT = 24;

 {$ifdef fpc}
  DEG_SYMBOL: string = '°';
 {$else}
 {$ifdef unicode}
  DEG_SYMBOL: widestring = '°';
 {$else}
  DEG_SYMBOL: char = #176;
 {$endif}
  LineEnding = #13#10;
 {$endif}

var
  MOONTOOL_INIFILE: string = 'moontool.ini';
  Lang: String = '';

  LocalFormatSettings: TFormatSettings;

implementation

initialization
 {$ifdef fpc}
  LocalFormatSettings := FormatSettings;
 {$else}
  GetLocaleFormatSettings(0, LocalFormatSettings);
 {$endif}

end.

