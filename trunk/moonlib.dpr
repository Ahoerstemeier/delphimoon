library moonlib;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  SysUtils,
  Classes,
  moon;

{$R *.res}

{ Calendar algorithms }
function julian_date(date:TDateTime):extended;  stdcall;
begin
  result:=moon.julian_date(date);
  end;
function delphi_date(juldat:extended):TDateTime; stdcall;
begin
  result:=moon.delphi_date(juldat);
  end;
function EasterDate(year:integer):TDateTime; stdcall;
begin
  result:=moon.EasterDate(year);
  end;
function EasterDateJulian(year:integer):TDateTime; stdcall;
begin
  result:=moon.EasterDateJulian(year);
  end;
function PesachDate(year:integer):TDateTime; stdcall;
begin
  result:=moon.PesachDate(year);
  end;
procedure DecodeDateJewish(date: TDateTime; var year,month,day: word); stdcall;
begin
  moon.DecodeDateJewish(date,year,month,day);
  end;
function EncodeDateJewish(year,month,day: word):TDateTime; stdcall;
begin
  result:=moon.EncodeDateJewish(year,month,day);
  end;
function WeekNumber(date:TDateTime):integer; stdcall;
begin
  result:=moon.WeekNumber(date);
  end;

{ Convert date to julian date and back }
function Calc_Julian_date_julian(year,month,day:word):extended; stdcall;
begin
  result:=moon.Calc_Julian_date_julian(year,month,day);
  end;
function Calc_Julian_date_gregorian(year,month,day:word):extended; stdcall;
begin
  result:=moon.Calc_Julian_date_gregorian(year,month,day);
  end;
function Calc_Julian_date_switch(year,month,day:word; switch_date:extended):extended; stdcall;
begin
  result:=moon.Calc_Julian_date_switch(year,month,day,switch_date);
  end;
function Calc_Julian_date(year,month,day:word):extended; stdcall;
begin
  result:=moon.Calc_Julian_date(year,month,day);
  end;
procedure Calc_Calendar_date_julian(juldat:extended; var year,month,day:word); stdcall;
begin
  moon.Calc_Calendar_date_julian(juldat,year,month,day);
  end;
procedure Calc_Calendar_date_gregorian(juldat:extended; var year,month,day:word); stdcall;
begin
  moon.Calc_Calendar_date_gregorian(juldat,year,month,day);
  end;
procedure Calc_Calendar_date_switch(juldat:extended; var year,month,day:word; switch_date:extended); stdcall;
begin
  moon.Calc_Calendar_date_switch(juldat,year,month,day,switch_date);
  end;
procedure Calc_Calendar_date(juldat:extended; var year,month,day:word); stdcall;
begin
  moon.Calc_Calendar_date(juldat,year,month,day);
  end;

{ Sun and Moon }
function sun_distance(date:TDateTime): extended; stdcall;
begin
  result:=moon.sun_distance(date);
  end;
function moon_distance(date:TDateTime): extended; stdcall;
begin
  result:=moon.moon_distance(date);
  end;
function age_of_moon(date:TDateTime): extended; stdcall;
begin
  result:=moon.age_of_moon(date);
  end;

function last_phase(date:TDateTime; phase:TMoonPhase):TDateTime; stdcall;
begin
  result:=moon.last_phase(date,phase);
  end;
function next_phase(date:TDateTime; phase:TMoonPhase):TDateTime; stdcall;
begin
  result:=moon.next_phase(date,phase);
  end;
function nearest_phase(date: TDateTime):TMoonPhase; stdcall;
begin
  result:=moon.nearest_phase(date);
  end;
function next_blue_moon(date: TDateTime):TDateTime; stdcall;
begin
  result:=moon.next_blue_moon(date);
  end;
function is_blue_moon(lunation: integer):boolean; stdcall;
begin
  result:=moon.is_blue_moon(lunation);
  end;

function moon_phase_angle(date: TDateTime):extended; stdcall;
begin
  result:=moon.moon_phase_angle(date);
  end;
function current_phase(date:TDateTime):extended; stdcall;
begin
  result:=moon.current_phase(date);
  end;
function lunation(date:TDateTime):integer; stdcall;
begin
  result:=moon.lunation(date);
  end;

function sun_diameter(date:TDateTime):extended; stdcall;
begin
  result:=moon.sun_diameter(date);
  end;
function moon_diameter(date:TDateTime):extended; stdcall;
begin
  result:=moon.moon_diameter(date);
  end;

function Sun_Rise(date:TDateTime; latitude, longitude:extended):TDateTime; stdcall;
begin
  result:=moon.Sun_Rise(date,latitude,longitude);
  end;
function Sun_Set(date:TDateTime; latitude, longitude:extended):TDateTime; stdcall;
begin
  result:=moon.Sun_Set(date,latitude,longitude);
  end;
function Sun_Transit(date:TDateTime; latitude, longitude:extended):TDateTime; stdcall;
begin
  result:=moon.Sun_Transit(date,latitude,longitude);
  end;
function Morning_Twilight_Civil(date:TDateTime; latitude, longitude:extended):TDateTime; stdcall;
begin
  result:=moon.Morning_Twilight_Civil(date,latitude,longitude);
  end;
function Evening_Twilight_Civil(date:TDateTime; latitude, longitude:extended):TDateTime; stdcall;
begin
  result:=moon.Evening_Twilight_Civil(date,latitude,longitude);
  end;
function Morning_Twilight_Nautical(date:TDateTime; latitude, longitude:extended):TDateTime; stdcall;
begin
  result:=moon.Morning_Twilight_Nautical(date,latitude,longitude);
  end;
function Evening_Twilight_Nautical(date:TDateTime; latitude, longitude:extended):TDateTime; stdcall;
begin
  result:=moon.Evening_Twilight_Nautical(date,latitude,longitude);
  end;
function Morning_Twilight_Astronomical(date:TDateTime; latitude, longitude:extended):TDateTime; stdcall;
begin
  result:=moon.Morning_Twilight_Astronomical(date,latitude,longitude);
  end;
function Evening_Twilight_Astronomical(date:TDateTime; latitude, longitude:extended):TDateTime; stdcall;
begin
  result:=moon.Evening_Twilight_Astronomical(date,latitude,longitude);
  end;
function Moon_Rise(date:TDateTime; latitude, longitude:extended):TDateTime; stdcall;
begin
  result:=moon.Moon_Rise(date,latitude,longitude);
  end;
function Moon_Set(date:TDateTime; latitude, longitude:extended):TDateTime; stdcall;
begin
  result:=moon.Moon_Set(date,latitude,longitude);
  end;
function Moon_Transit(date:TDateTime; latitude, longitude:extended):TDateTime; stdcall;
begin
  result:=moon.Moon_Transit(date,latitude,longitude);
  end;

function nextperigee(date:TDateTime):TDateTime; stdcall;
begin
  result:=moon.nextperigee(date);
  end;
function nextapogee(date:TDateTime):TDateTime; stdcall;
begin
  result:=moon.nextapogee(date);
  end;
function nextperihel(date:TDateTime):TDateTime; stdcall;
begin
  result:=moon.nextperihel(date);
  end;
function nextaphel(date:TDateTime):TDateTime; stdcall;
begin
  result:=moon.nextaphel(date);
  end;

function NextEclipse(var date:TDateTime; sun:boolean):TEclipse; stdcall;
begin
  result:=moon.NextEclipse(date,sun);
  end;

procedure Moon_Position_Horizontal(date:TdateTime; refraction:boolean; latitude,longitude: extended; var elevation,azimuth: extended); stdcall;
begin
  moon.Moon_Position_Horizontal(date,refraction,latitude,longitude,elevation,azimuth);
  end;
procedure Sun_Position_Horizontal(date:TdateTime; refraction:boolean; latitude,longitude: extended; var elevation,azimuth: extended); stdcall;
begin
  moon.Sun_Position_Horizontal(date,refraction,latitude,longitude,elevation,azimuth);
  end;

procedure Sun_Position_Ecliptic(date:TdateTime; var rektaszension,declination:extended); stdcall;
begin
  moon.Sun_Position_Ecliptic(date,rektaszension,declination);
  end;
procedure Moon_Position_Ecliptic(date:TdateTime; var rektaszension,declination:extended); stdcall;
begin
  moon.Moon_Position_Ecliptic(date,rektaszension,declination);
  end;

function Elevation_Real_to_Apparent(elevation:extended; temperature,airpressure:extended):extended; stdcall;
begin
  result:=moon.Elevation_Real_to_Apparent(elevation,temperature,airpressure);
  end;
function Elevation_Apparent_to_Real(elevation:extended; temperature,airpressure:extended):extended; stdcall;
begin
  result:=moon.Elevation_Apparent_to_Real(elevation,temperature,airpressure);
  end;

{ Further useful functions }
function star_time(date:TDateTime):extended; stdcall;
begin
  result:=moon.star_time(date);
  end;
function DynamicTimeDifference(date:TdateTime):extended; stdcall;
begin
  result:=moon.DynamicTimeDifference(date);
  end;
function StartSeason(year: integer; season:TSeason):TDateTime; stdcall;
begin
  result:=moon.StartSeason(year,season);
  end;

{ Chinese calendar }
function ChineseNewYear(year: integer): TDateTime; stdcall;
begin
  result:=moon.ChineseNewYear(year);
  end;

exports
  julian_date,
  delphi_date,
  EasterDate,
  EasterDateJulian,
  PesachDate,
  DecodeDateJewish,
  EncodeDateJewish,
  WeekNumber,
{ Convert date to julian date and back }
  Calc_Julian_date_julian,
  Calc_Julian_date_gregorian,
  Calc_Julian_date_switch,
  Calc_Julian_date,
  Calc_Calendar_date_julian,
  Calc_Calendar_date_gregorian,
  Calc_Calendar_date_switch,
  Calc_Calendar_date,
{ Sun and Moon }
  sun_distance,
  moon_distance,
  age_of_moon,
  last_phase,
  next_phase,
  nearest_phase,
  next_blue_moon,
  is_blue_moon,
  moon_phase_angle,
  current_phase,
  lunation,
  sun_diameter,
  moon_diameter,
  Sun_Rise,
  Sun_Set,
  Sun_Transit,
  Morning_Twilight_Civil,
  Evening_Twilight_Civil,
  Morning_Twilight_Nautical,
  Evening_Twilight_Nautical,
  Morning_Twilight_Astronomical,
  Evening_Twilight_Astronomical,
  Moon_Rise,
  Moon_Set,
  Moon_Transit,
  nextperigee,
  nextapogee,
  nextperihel,
  nextaphel,
  NextEclipse,
  Moon_Position_Horizontal,
  Sun_Position_Horizontal,
  Sun_Position_Ecliptic,
  Moon_Position_Ecliptic,
  Elevation_Real_to_Apparent,
  Elevation_Apparent_to_Real,
{ Further useful functions }
  star_time,
  DynamicTimeDifference,
  StartSeason,
{ Chinese calendar }
  ChineseNewYear;

begin
end.
 