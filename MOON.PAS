unit moon;

 {$i ah_def.inc }

{ Copyright 1997-2002 Andreas Hörstemeier            Version 2.1 2002-01-15  }
{ this component is public domain - please check the file moon.hlp for       }
{ more detailed info on usage and distributing                               }

{ Algorithms taken from the book "Astronomical Algorithms" by Jean Meeus     }

(*$b-*)   { I may make use of the shortcut boolean eval }

(*@/// interface *)
interface

(*@/// uses *)
uses
  ah_math,
  moon_aux,
  moon_elp,
  vsop,
  sysutils;
(*@\\\000000040C*)

type
  TMoonPhase=(Newmoon,WaxingCrescent,FirstQuarter,WaxingGibbous,
              Fullmoon,WaningGibbous,LastQuarter,WaningCrescent);
  TMoonName=(mn_wolf, mn_snow, mn_worm, mn_pink, mn_flower,
             mn_strawberry, mn_buck, mn_sturgeon, mn_harvest,
             mn_hunter, mn_beaver, mn_cold, mn_blue);
  TSeason=(Winter,Spring,Summer,Autumn);
  TEclipse=(none, partial, noncentral, circular, circulartotal, total, halfshadow);
  (*@/// TEclipseData=record *)
  TEclipseData=record
    date: TDateTime;
    eclipsetype: TEclipse;
    saros, inex: integer;
    sarosnumber: integer;
    end;
  (*@\\\0000000201*)
  E_NoRiseSet=class(Exception);
  TSolarTerm=(st_z2,st_j3,st_z3,st_j4,st_z4,st_j5,st_z5,st_j6,st_z6,
              st_j7,st_z7,st_j8,st_z8,st_j9,st_z9,st_j10,st_z10,
              st_j11,st_z11,st_j12,st_z12,st_j1,st_z1,st_j2);
  TChineseZodiac=(ch_rat,ch_ox,ch_tiger,ch_rabbit,ch_dragon,ch_snake,
                      ch_horse,ch_goat,ch_monkey,ch_chicken,ch_dog,ch_pig);
  TChineseStem=(ch_jia,ch_yi,ch_bing,ch_ding,ch_wu,ch_ji,
                    ch_geng,ch_xin,ch_ren,ch_gui);
  (*@/// TChineseCycle= record *)
  TChineseCycle=record
    zodiac: TChineseZodiac;
    stem:   TChineseStem;
    end;
  (*@\\\*)
  (*@/// TChineseDate = record *)
  TChineseDate = record
    cycle: integer;
    year: integer;
    epoch_years: integer;
    month: integer;
    leap: boolean;
    leapyear: boolean;
    day: integer;
    yearcycle: TChineseCycle;
    daycycle: TChineseCycle;
    monthcycle: TChineseCycle;
    end;
  (*@\\\*)
  TZodiac = ( z_aries, z_taurus, z_gemini, z_cancer, z_leo, z_virgo, z_libra,
              z_scorpio, z_sagittarius, z_capricorn, z_aquarius, z_pisces );

const
  (* Date of calendar reformation - start of gregorian calendar *)
  calendar_change_standard: extended = 2299160.5;
  calendar_change_russia: extended = 2421638.5;
  calendar_change_england: extended = 2361221.5;
  calendar_change_sweden: extended = 2361389.5;
  (*@/// Jewish_Month_Name:array[1..13] of string *)
  Jewish_Month_Name:array[1..13] of string = (
    'Nisan',
    'Iyar',
    'Sivan',
    'Tammuz',
    'Av',
    'Elul',
    'Tishri',
    'Heshvan',
    'Kislev',
    'Tevet',
    'Shevat',
    'Adar',
    'Adar 2'
    );
  (*@\\\*)


{ Calendar algorithms }
function julian_date(date:TDateTime):extended;
function delphi_date(juldat:extended):TDateTime;
function EasterDate(year:integer):TDateTime;
function EasterDateJulian(year:integer):TDateTime;
function PesachDate(year:integer):TDateTime;
procedure DecodeDateJewish(date: TDateTime; var year,month,day: word);
function EncodeDateJewish(year,month,day: word):TDateTime;
function WeekNumber(date:TDateTime):integer;

{ Convert date to julian date and back }
function Calc_Julian_date_julian(year,month,day:word):extended;
function Calc_Julian_date_gregorian(year,month,day:word):extended;
function Calc_Julian_date_switch(year,month,day:word; switch_date:extended):extended;
function Calc_Julian_date(year,month,day:word):extended;
procedure Calc_Calendar_date_julian(juldat:extended; var year,month,day:word);
procedure Calc_Calendar_date_gregorian(juldat:extended; var year,month,day:word);
procedure Calc_Calendar_date_switch(juldat:extended; var year,month,day:word; switch_date:extended);
procedure Calc_Calendar_date(juldat:extended; var year,month,day:word);

{ corrected TDateTime functions }
function isleapyearcorrect(year:word):boolean;
function EncodedateCorrect(year,month,day: word):TDateTime;
procedure DecodedateCorrect(date:TDateTime; var year,month,day: word);
procedure DecodetimeCorrect(date:TDateTime; var hour,min,sec,msec: word);
function FalsifyTdateTime(date:TDateTime):TdateTime;

{ Sun and Moon }
function sun_distance(date:TDateTime): extended;
function moon_distance(date:TDateTime): extended;
function AgeOfMoon(date:TDateTime): extended;
function AgeOfMoonWalker(date:TDateTime): extended;

function last_phase(date:TDateTime; phase:TMoonPhase):TDateTime;
function next_phase(date:TDateTime; phase:TMoonPhase):TDateTime;
function nearest_phase(date: TDateTime):TMoonPhase;
function next_blue_moon(date: TDateTime):TDateTime;
function is_blue_moon(lunation: integer):boolean;
function MoonName(lunation: integer):TMoonName;

function moon_phase_angle(date: TDateTime):extended;
function current_phase(date:TDateTime):extended;
function MoonBrightLimbPositionAngle(date:TDateTime):extended;
function MoonBrightLimbPositionAngleZenith(date:TDateTime; latitude,longitude:extended):extended;

function lunation(date:TDateTime):integer;
function Lunation_phase(lunation: integer; phase: TMoonPhase):TDateTime;

function sun_diameter(date:TDateTime):extended;
function moon_diameter(date:TDateTime):extended;

function Sun_Rise(date:TDateTime; latitude, longitude:extended):TDateTime;
function Sun_Set(date:TDateTime; latitude, longitude:extended):TDateTime;
function Sun_Transit(date:TDateTime; latitude, longitude:extended):TDateTime;
function Morning_Twilight_Civil(date:TDateTime; latitude, longitude:extended):TDateTime;
function Evening_Twilight_Civil(date:TDateTime; latitude, longitude:extended):TDateTime;
function Morning_Twilight_Nautical(date:TDateTime; latitude, longitude:extended):TDateTime;
function Evening_Twilight_Nautical(date:TDateTime; latitude, longitude:extended):TDateTime;
function Morning_Twilight_Astronomical(date:TDateTime; latitude, longitude:extended):TDateTime;
function Evening_Twilight_Astronomical(date:TDateTime; latitude, longitude:extended):TDateTime;
function Moon_Rise(date:TDateTime; latitude, longitude:extended):TDateTime;
function Moon_Set(date:TDateTime; latitude, longitude:extended):TDateTime;
function Moon_Transit(date:TDateTime; latitude, longitude:extended):TDateTime;

function nextperigee(date:TDateTime):TDateTime;
function nextapogee(date:TDateTime):TDateTime;
function nextperihel(date:TDateTime):TDateTime;
function nextaphel(date:TDateTime):TDateTime;
function NextMoonNode(const date:TDateTime; const rising:boolean):TDateTime;

function NextEclipse(var date:TDateTime; sun:boolean):TEclipse;
function NextEclipseEx(date:TDateTime; sun:boolean):TEclipseData;

procedure Moon_Position_Horizontal(date:TdateTime; refraction:boolean; latitude,longitude: extended;
                                   var elevation,azimuth: extended);
procedure Sun_Position_Horizontal(date:TdateTime; refraction:boolean; latitude,longitude: extended;
                                  var elevation,azimuth: extended);

procedure Sun_Position_Ecliptic(date:TdateTime; var latitude,longitude:extended);
procedure Moon_Position_Ecliptic(date:TdateTime; var latitude,longitude:extended);

procedure Sun_Position_Equatorial(date:TdateTime; var rektaszension,declination:extended);
procedure Moon_Position_Equatorial(date:TdateTime; var rektaszension,declination:extended);

function SunZodiac(date: TDateTime):TZodiac;
function MoonZodiac(date: TDateTime):TZodiac;

function Elevation_Real_to_Apparent(elevation:extended; temperature,airpressure:extended):extended;
function Elevation_Apparent_to_Real(elevation:extended; temperature,airpressure:extended):extended;

procedure OpticalLibration(date: TDateTime; var latitude,longitude:extended);
procedure PhysicalLibration(date: TDateTime; var latitude,longitude:extended);
function MoonPositionAngleAxis(date:TDateTime):extended;

{ Further useful functions }
function DynamicTimeDifference(date:TdateTime):extended;
function StartSeason(year: integer; season:TSeason):TDateTime;
function CalcSolarTerm(year: integer; term: TSolarTerm):TDateTime;
function DistanceOnEarth(latitude1,longitude1,latitude2,longitude2:extended):extended;
function EquationOfTime(date:TDateTime):extended;
procedure ParallaxCorrection(var rektaszension,declination:extended;
  distance:extended; date:TDateTime; latitude,longitude,height:extended);


{ Chinese calendar }
function ChineseNewYear(year: integer): TDateTime;
function ChineseDate(date: TdateTime): TChineseDate;
function EncodeDateChinese(date:TChineseDate):TDateTime;
(*@\\\0000006B01*)
(*@/// implementation *)
implementation

(*$undef low_accuracy *)

const
  AU=149597869;             (* astronomical unit in km *)
  mean_lunation=29.530589;  (* Mean length of a month *)
  tropic_year=365.242190;   (* Tropic year length *)
  earth_radius=6378.14;     (* Radius of the earth, km, IAU 1976 *)
  earth_flattening=1.0/298.257; (* IAU 1976 *)
  standard_temperature = 283;  (* Refraction standard temperature 283K = 10øC = 50F *)
  standard_pressure = 1010;    (* Refraction standard pressure 1010 hPa *)
  date = '';  (* make sure I don't use sysutils.date by accident *)
  juldat_2000_01_01: extended = 2451545.5;
  inex_cycle=358*mean_lunation;
  saros_cycle=223*mean_lunation;

  suneclipse_base_saros=145;
  suneclipse_base_inex=38;
  mooneclipse_base_saros=119;
  mooneclipse_base_inex=56;

(*$ifdef delphi_ge_3 *)
var
(*$else *)
const
(*$endif *)
  (* Shortcuts to avoid calling Encodedate too often *)
  datetime_2000_01_01: extended = 0;
  datetime_1999_01_01: extended = 0;
  datetime_suneclipse_base: extended = 0;
  datetime_mooneclipse_base: extended = 0;
  datetime_chinese_epoch: extended = 0;
  datetime_first_lunation: extended = 0;
  datetime_earliest_next_leapsecond: extended = 0;
  julian_offset: extended = 0;
  (* How broken is the TDateTime? *)
  negative_dates_broken: boolean = false;
  calendar_reform_supported: boolean = true;
  julian_calendar_before_1582: boolean = true;

const
  beijing_longitude = -(116+25/60);   (* for chinese calendar *)
  modified_julian_date_offset = 2400000.5;
  maine_timezone_offset = +5/24;      (* for MoonName *)

type
  (*@/// t_coord = record *)
  t_coord = record
    longitude, latitude, radius: extended; (* lambda, beta, R *)
    rektaszension, declination: extended;  (* alpha, delta *)
    parallax: extended;
    elevation, azimuth: extended;          (* h, A *)
    end;
  (*@\\\*)
  T_RiseSet=(_rise,_set,_transit,_rise_civil,_rise_nautical,_rise_astro,_set_civil,_set_nautical,_set_astro);
  TJewishYearStyle=(ys_common_deficient,ys_common_regular,ys_common_complete,
                    ys_leap_deficient,ys_leap_regular,ys_leap_complete);
const
  (*@/// Jewish_Month_length:array[1..13,TJewishYearStyle] of shortint *)
  Jewish_Month_length:array[1..13,TJewishYearStyle] of word = (
   ( 30,30,30,30,30,30),
   ( 29,29,29,29,29,29),
   ( 30,30,30,30,30,30),
   ( 29,29,29,29,29,29),
   ( 30,30,30,30,30,30),
   ( 29,29,29,29,29,29),
   ( 30,30,30,30,30,30),
   ( 29,29,30,29,29,30),
   ( 29,30,30,29,30,30),
   ( 29,29,29,29,29,29),
   ( 30,30,30,30,30,30),
   ( 29,29,29,30,30,30),
   (  0, 0, 0,29,29,29)
   );
  (*@\\\*)
  (*@/// Jewish_Month_Name_short:array[1..13] of string *)
  Jewish_Month_Name_short:array[1..13] of string = (
    'Nis',
    'Iya',
    'Siv',
    'Tam',
    'Av' ,
    'Elu',
    'Tis',
    'Hes',
    'Kis',
    'Tev',
    'She',
    'Ada',
    'Ad2'
    );
  (*@\\\*)
  Jewish_year_length:array[TJewishYearStyle] of integer = (353,354,355,383,384,385);

{ Julian date }
(*@/// function julian_date(date:TDateTime):extended; *)
function julian_date(date:TDateTime):extended;
begin
  julian_date:=julian_offset+date
  end;
(*@\\\*)
(*@/// function delphi_date(juldat:extended):TDateTime; *)
function delphi_date(juldat:extended):TDateTime;
begin
  delphi_date:=juldat-julian_offset;
  end;
(*@\\\*)
(*@/// function isleapyearcorrect(year:word):boolean; *)
function isleapyearcorrect(year:word):boolean;
begin
  if year<=1582 then
    result:=((year mod 4)=0)
  else
    result:=(((year mod 4)=0) and ((year mod 100)<>0)) or
             ((year mod 400)=0);
  end;
(*@\\\*)
(*@/// function Calc_Julian_date_julian(year,month,day:word):extended; *)
function Calc_Julian_date_julian(year,month,day:word):extended;
begin
  if (year<1) or (year>9999) then
    raise EConvertError.Create('Invalid year');
  if month<3 then begin
    month:=month+12;
    year:=year-1;
    end;
  case month of
    3,5,7,8,10,12,13: if (day<1) or (day>31) then EConvertError.Create('Invalid day');
    4,6,9,11:         if (day<1) or (day>30) then EConvertError.Create('Invalid day');
    14: case day of
          1..28: ;
          29: if (year+1) mod 4<>0 then EConvertError.Create('Invalid day');
          else EConvertError.Create('Invalid day');
          end;
     else raise EConvertError.Create('Invalid month');
     end;
  result:=trunc(365.25*(year+4716))+trunc(30.6001*(month+1))+day-1524.5;
  end;
(*@\\\*)
(*@/// function Calc_Julian_date_gregorian(year,month,day:word):extended; *)
function Calc_Julian_date_gregorian(year,month,day:word):extended;
var
  a,b: longint;
begin
  if (year<1) or (year>9999) then
    raise EConvertError.Create('Invalid year');
  if month<3 then begin
    month:=month+12;
    year:=year-1;
    end;
  a:=year div 100;
  case month of
    3,5,7,8,10,12,13: if (day<1) or (day>31) then EConvertError.Create('Invalid day');
    4,6,9,11:         if (day<1) or (day>30) then EConvertError.Create('Invalid day');
    14: case day of
          1..28: ;
          29: if (((year mod 4)<>0) or ((year mod 100)=0)) and
                 ((year mod 400)<>0) then EConvertError.Create('Invalid day');
          else EConvertError.Create('Invalid day');
          end;
     else raise EConvertError.Create('Invalid month');
     end;
  b:=2-a+(a div 4);
  result:=trunc(365.25*(year+4716))+trunc(30.6001*(month+1))+day+b-1524.5;
  end;
(*@\\\*)
(*@/// function Calc_Julian_date_switch(year,month,day:word; switch_date:extended):extended; *)
function Calc_Julian_date_switch(year,month,day:word; switch_date:extended):extended;
begin
  result:=Calc_Julian_date_julian(year,month,day);
  if result>=switch_date then begin
    result:=Calc_Julian_date_gregorian(year,month,day);
    if result<switch_date then
      raise EConvertError.Create('Date invalid due to calendar change');
    end;
  end;
(*@\\\*)
(*@/// function Calc_Julian_date(year,month,day:word):extended; *)
function Calc_Julian_date(year,month,day:word):extended;
begin
  result:=Calc_Julian_date_switch(year,month,day,calendar_change_standard);
  end;
(*@\\\*)
(*@/// procedure Calc_Calendar_date_julian(juldat:extended; var year,month,day:word); *)
procedure Calc_Calendar_date_julian(juldat:extended; var year,month,day:word);
var
  z,a,b,c,d,e: longint;
begin
  if juldat<0 then
    raise EConvertError.Create('Negative julian dates not supported');
  juldat:=juldat+0.5;
  z:=trunc(juldat);
  a:=z;
  b:=a+1524;
  c:=trunc((b-122.1)/365.25);
  d:=trunc(365.25*c);
  e:=trunc((b-d)/30.6001);
  day:=b-d-trunc(30.6001*e);
  year:=c-4716;
  if e<14 then
    month:=e-1
  else begin
    month:=e-13;
    year:=year+1;
    end;
  end;
(*@\\\*)
(*@/// procedure Calc_Calendar_date_gregorian(juldat:extended; var year,month,day:word); *)
procedure Calc_Calendar_date_gregorian(juldat:extended; var year,month,day:word);
var
  alpha,z,a,b,c,d,e: longint;
begin
  if juldat<0 then
    raise EConvertError.Create('Negative julian dates not supported');
  juldat:=juldat+0.5;
  z:=trunc(juldat);
  alpha:=trunc((z-1867216.25)/36524.25);
  a:=z+1+alpha-trunc(alpha/4);
  b:=a+1524;
  c:=trunc((b-122.1)/365.25);
  d:=trunc(365.25*c);
  e:=trunc((b-d)/30.6001);
  day:=b-d-trunc(30.6001*e);
  year:=c-4716;
  if e<14 then
    month:=e-1
  else begin
    month:=e-13;
    year:=year+1;
    end;
  end;
(*@\\\*)
(*@/// procedure Calc_Calendar_date_switch(juldat:extended; var year,month,day:word; switch_date:extended); *)
procedure Calc_Calendar_date_switch(juldat:extended; var year,month,day:word; switch_date:extended);
begin
  if juldat<0 then
    raise EConvertError.Create('Negative julian dates not supported');
  if juldat<switch_date then
    Calc_Calendar_date_julian(juldat,year,month,day)
  else
    Calc_Calendar_date_gregorian(juldat,year,month,day);
  end;
(*@\\\*)
(*@/// procedure Calc_Calendar_date(juldat:extended; var year,month,day:word); *)
procedure Calc_Calendar_date(juldat:extended; var year,month,day:word);
begin
  Calc_Calendar_date_switch(juldat,year,month,day,calendar_change_standard);
  end;
(*@\\\*)


{ TDateTime correction }
(*@/// procedure check_TDatetime; *)
(* Check how many bugs the TDateTime has compare to julian date *)
procedure check_TDatetime;
var
  h,m,s,ms: word;
  d1,d2: TDateTime;
begin
  (*$ifndef delphi_1 *)        { Delphi 1 did not allow negative values }
  decodetime(-1.9,h,m,s,ms);
  negative_dates_broken:=h>12;
  (*$endif delphi_1 *)
  d1:=EncodeDate(1582,10,15);
  d2:=EncodeDate(1582,10,4);
  calendar_reform_supported:=((d1-d2)=1);
  d1:=EncodeDate(1500,3,1);
  d2:=EncodeDate(1500,2,28);
  julian_calendar_before_1582:=((d1-d2)=2);
  end;
(*@\\\0000001107*)
(*@/// function EncodedateCorrect(year,month,day: word):TDateTime; *)
function EncodedateCorrect(year,month,day: word):TDateTime;
begin
  result:=delphi_date(Calc_Julian_date(year,month,day));
  end;
(*@\\\0000000201*)
(*@/// function EncodedateJulian(year,month,day: word):TDateTime; *)
function EncodedateJulian(year,month,day: word):TDateTime;
begin
  result:=delphi_date(Calc_Julian_date_julian(year,month,day));
  end;
(*@\\\0000000301*)
(*@/// procedure DecodedateCorrect(date:TDateTime; var year,month,day: word); *)
procedure DecodedateCorrect(date:TDateTime; var year,month,day: word);
begin
  Calc_Calendar_date(julian_date(date),year,month,day);
  end;
(*@\\\*)
(*@/// procedure DecodedateJulian(date:TDateTime; var year,month,day: word); *)
procedure DecodedateJulian(date:TDateTime; var year,month,day: word);
begin
  Calc_Calendar_date_julian(julian_date(date),year,month,day);
  end;
(*@\\\000000031C*)
(*@/// procedure DecodetimeCorrect(date:TDateTime; var hour,min,sec,msec: word); *)
procedure DecodetimeCorrect(date:TDateTime; var hour,min,sec,msec: word);
begin
  Decodetime(1+frac(date),hour,min,sec,msec);
  end;
(*@\\\*)
(*@/// function FalsifyTdateTime(date:TDateTime):TdateTime; *)
function FalsifyTdateTime(date:TDateTime):TdateTime;
var
  d,m,y: word;
begin
  DecodedateCorrect(date,d,m,y);
  result:=Encodedate(d,m,y);
  result:=result+frac(date);
  if negative_dates_broken and (result<0) and (frac(result)<>0) then
    result:=int(result)-(1-abs(frac(result)));
  end;
(*@\\\*)
(*@/// function DynamicTimeDifference(date:TdateTime):extended; *)
{ Based upon chapter 10 (9) of Meeus }
{ Chapront, Chapront-Touz‚ & Francou (1997) }

function DynamicTimeDifference(date:TdateTime):extended;
type
  (*@/// TTAI2UTC = record *)
  TTAI2UTC = record
    mjd: longint;
    offset: extended;
    dynamic: extended;
    refmjd: longint;
    end;
  (*@\\\0000000503*)
  (*@/// TTDT2UTC = record *)
  TTDT2UTC = record
    year: integer;
    offset: extended;
    end;
  (*@\\\*)
const
  (*@/// TAI2UTC: array[..] of TTAI2UTC = (...); *)
  TAI2UTC: array[0..35] of TTAI2UTC = (
    ( mjd: 37300; offset: 1.4228180; dynamic: 0.001296 ; refmjd: 37300 ),  { 1961 JAN  1 }
    ( mjd: 37512; offset: 1.3728180; dynamic: 0.001296 ; refmjd: 37300 ),  { 1961 AUG  1 }
    ( mjd: 37665; offset: 1.8458580; dynamic: 0.0011232; refmjd: 37665 ),  { 1962 JAN  1 }
    ( mjd: 38334; offset: 1.9458580; dynamic: 0.0011232; refmjd: 37665 ),  { 1963 NOV  1 }
    ( mjd: 38395; offset: 3.2401300; dynamic: 0.001296 ; refmjd: 38761 ),  { 1964 JAN  1 }
    ( mjd: 38486; offset: 3.3401300; dynamic: 0.001296 ; refmjd: 38761 ),  { 1964 APR  1 }
    ( mjd: 38639; offset: 3.4401300; dynamic: 0.001296 ; refmjd: 38761 ),  { 1964 SEP  1 }
    ( mjd: 38761; offset: 3.5401300; dynamic: 0.001296 ; refmjd: 38761 ),  { 1965 JAN  1 }
    ( mjd: 38820; offset: 3.6401300; dynamic: 0.001296 ; refmjd: 38761 ),  { 1965 MAR  1 }
    ( mjd: 38942; offset: 3.7401300; dynamic: 0.001296 ; refmjd: 38761 ),  { 1965 JUL  1 }
    ( mjd: 39004; offset: 3.8401300; dynamic: 0.001296 ; refmjd: 38761 ),  { 1965 SEP  1 }
    ( mjd: 39126; offset: 4.3131700; dynamic: 0.002592 ; refmjd: 39126 ),  { 1966 JAN  1 }
    ( mjd: 39887; offset: 4.2131700; dynamic: 0.002592 ; refmjd: 39126 ),  { 1968 FEB  1 }
    ( mjd: 41317; offset:10.0      ; dynamic: 0.0      ; refmjd: 41317 ),  { 1972 JAN  1 }
    ( mjd: 41499; offset:11.0      ; dynamic: 0.0      ; refmjd: 41317 ),  { 1972 JUL  1 }
    ( mjd: 41683; offset:12.0      ; dynamic: 0.0      ; refmjd: 41317 ),  { 1973 JAN  1 }
    ( mjd: 42048; offset:13.0      ; dynamic: 0.0      ; refmjd: 41317 ),  { 1974 JAN  1 }
    ( mjd: 42413; offset:14.0      ; dynamic: 0.0      ; refmjd: 41317 ),  { 1975 JAN  1 }
    ( mjd: 42778; offset:15.0      ; dynamic: 0.0      ; refmjd: 41317 ),  { 1976 JAN  1 }
    ( mjd: 43144; offset:16.0      ; dynamic: 0.0      ; refmjd: 41317 ),  { 1977 JAN  1 }
    ( mjd: 43509; offset:17.0      ; dynamic: 0.0      ; refmjd: 41317 ),  { 1978 JAN  1 }
    ( mjd: 43874; offset:18.0      ; dynamic: 0.0      ; refmjd: 41317 ),  { 1979 JAN  1 }
    ( mjd: 44239; offset:19.0      ; dynamic: 0.0      ; refmjd: 41317 ),  { 1980 JAN  1 }
    ( mjd: 44786; offset:20.0      ; dynamic: 0.0      ; refmjd: 41317 ),  { 1981 JUL  1 }
    ( mjd: 45151; offset:21.0      ; dynamic: 0.0      ; refmjd: 41317 ),  { 1982 JUL  1 }
    ( mjd: 45516; offset:22.0      ; dynamic: 0.0      ; refmjd: 41317 ),  { 1983 JUL  1 }
    ( mjd: 46247; offset:23.0      ; dynamic: 0.0      ; refmjd: 41317 ),  { 1985 JUL  1 }
    ( mjd: 47161; offset:24.0      ; dynamic: 0.0      ; refmjd: 41317 ),  { 1988 JAN  1 }
    ( mjd: 47892; offset:25.0      ; dynamic: 0.0      ; refmjd: 41317 ),  { 1990 JAN  1 }
    ( mjd: 48257; offset:26.0      ; dynamic: 0.0      ; refmjd: 41317 ),  { 1991 JAN  1 }
    ( mjd: 48804; offset:27.0      ; dynamic: 0.0      ; refmjd: 41317 ),  { 1992 JUL  1 }
    ( mjd: 49169; offset:28.0      ; dynamic: 0.0      ; refmjd: 41317 ),  { 1993 JUL  1 }
    ( mjd: 49534; offset:29.0      ; dynamic: 0.0      ; refmjd: 41317 ),  { 1994 JUL  1 }
    ( mjd: 50083; offset:30.0      ; dynamic: 0.0      ; refmjd: 41317 ),  { 1996 JAN  1 }
    ( mjd: 50630; offset:31.0      ; dynamic: 0.0      ; refmjd: 41317 ),  { 1997 JUL  1 }
    ( mjd: 51179; offset:32.0      ; dynamic: 0.0      ; refmjd: 41317 )   { 1999 JAN  1 }
    );
  (*@\\\0000002501*)
  (*@/// TDT2UTC: array[..] of TTDT2UTC = (...); *)
  TDT2UTC: array[0..171] of TTDT2UTC = (
    ( year: 1620;  offset: +121.0 ),
    ( year: 1622;  offset: +112.0 ),
    ( year: 1624;  offset: +103.0 ),
    ( year: 1626;  offset: + 95.0 ),
    ( year: 1628;  offset: + 88.0 ),
    ( year: 1630;  offset: + 82.0 ),
    ( year: 1632;  offset: + 77.0 ),
    ( year: 1634;  offset: + 72.0 ),
    ( year: 1636;  offset: + 68.0 ),
    ( year: 1638;  offset: + 63.0 ),
    ( year: 1640;  offset: + 60.0 ),
    ( year: 1642;  offset: + 56.0 ),
    ( year: 1644;  offset: + 53.0 ),
    ( year: 1646;  offset: + 51.0 ),
    ( year: 1648;  offset: + 48.0 ),
    ( year: 1650;  offset: + 46.0 ),
    ( year: 1652;  offset: + 44.0 ),
    ( year: 1654;  offset: + 42.0 ),
    ( year: 1656;  offset: + 40.0 ),
    ( year: 1658;  offset: + 38.0 ),
    ( year: 1660;  offset: + 35.0 ),
    ( year: 1662;  offset: + 33.0 ),
    ( year: 1664;  offset: + 31.0 ),
    ( year: 1666;  offset: + 29.0 ),
    ( year: 1668;  offset: + 26.0 ),
    ( year: 1670;  offset: + 24.0 ),
    ( year: 1672;  offset: + 22.0 ),
    ( year: 1674;  offset: + 20.0 ),
    ( year: 1676;  offset: + 18.0 ),
    ( year: 1678;  offset: + 16.0 ),
    ( year: 1680;  offset: + 14.0 ),
    ( year: 1682;  offset: + 12.0 ),
    ( year: 1684;  offset: + 11.0 ),
    ( year: 1686;  offset: + 10.0 ),
    ( year: 1688;  offset: +  9.0 ),
    ( year: 1690;  offset: +  8.0 ),
    ( year: 1692;  offset: +  7.0 ),
    ( year: 1694;  offset: +  7.0 ),
    ( year: 1696;  offset: +  7.0 ),
    ( year: 1698;  offset: +  7.0 ),
    ( year: 1700;  offset: +  7.0 ),
    ( year: 1702;  offset: +  7.0 ),
    ( year: 1704;  offset: +  8.0 ),
    ( year: 1706;  offset: +  8.0 ),
    ( year: 1708;  offset: +  9.0 ),
    ( year: 1710;  offset: +  9.0 ),
    ( year: 1712;  offset: +  9.0 ),
    ( year: 1714;  offset: +  9.0 ),
    ( year: 1716;  offset: +  9.0 ),
    ( year: 1718;  offset: + 10.0 ),
    ( year: 1720;  offset: + 10.0 ),
    ( year: 1722;  offset: + 10.0 ),
    ( year: 1724;  offset: + 10.0 ),
    ( year: 1726;  offset: + 10.0 ),
    ( year: 1728;  offset: + 10.0 ),
    ( year: 1730;  offset: + 10.0 ),
    ( year: 1732;  offset: + 10.0 ),
    ( year: 1734;  offset: + 11.0 ),
    ( year: 1736;  offset: + 11.0 ),
    ( year: 1738;  offset: + 11.0 ),
    ( year: 1740;  offset: + 11.0 ),
    ( year: 1742;  offset: + 11.0 ),
    ( year: 1744;  offset: + 12.0 ),
    ( year: 1746;  offset: + 12.0 ),
    ( year: 1748;  offset: + 12.0 ),
    ( year: 1750;  offset: + 12.0 ),
    ( year: 1752;  offset: + 13.0 ),
    ( year: 1754;  offset: + 13.0 ),
    ( year: 1756;  offset: + 13.0 ),
    ( year: 1758;  offset: + 14.0 ),
    ( year: 1760;  offset: + 14.0 ),
    ( year: 1762;  offset: + 14.0 ),
    ( year: 1764;  offset: + 14.0 ),
    ( year: 1766;  offset: + 15.0 ),
    ( year: 1768;  offset: + 15.0 ),
    ( year: 1770;  offset: + 15.0 ),
    ( year: 1772;  offset: + 15.0 ),
    ( year: 1774;  offset: + 15.0 ),
    ( year: 1776;  offset: + 16.0 ),
    ( year: 1778;  offset: + 16.0 ),
    ( year: 1780;  offset: + 16.0 ),
    ( year: 1782;  offset: + 16.0 ),
    ( year: 1784;  offset: + 16.0 ),
    ( year: 1786;  offset: + 16.0 ),
    ( year: 1788;  offset: + 16.0 ),
    ( year: 1790;  offset: + 16.0 ),
    ( year: 1792;  offset: + 15.0 ),
    ( year: 1794;  offset: + 15.0 ),
    ( year: 1796;  offset: + 14.0 ),
    ( year: 1798;  offset: + 13.0 ),
    ( year: 1800;  offset: + 13.1 ),
    ( year: 1802;  offset: + 12.5 ),
    ( year: 1804;  offset: + 12.2 ),
    ( year: 1806;  offset: + 12.0 ),
    ( year: 1808;  offset: + 12.0 ),
    ( year: 1810;  offset: + 12.0 ),
    ( year: 1812;  offset: + 12.0 ),
    ( year: 1814;  offset: + 12.0 ),
    ( year: 1816;  offset: + 12.0 ),
    ( year: 1818;  offset: + 11.9 ),
    ( year: 1820;  offset: + 11.6 ),
    ( year: 1822;  offset: + 11.0 ),
    ( year: 1824;  offset: + 10.2 ),
    ( year: 1826;  offset: +  9.2 ),
    ( year: 1828;  offset: +  8.2 ),
    ( year: 1830;  offset: +  7.1 ),
    ( year: 1832;  offset: +  6.2 ),
    ( year: 1834;  offset: +  5.6 ),
    ( year: 1836;  offset: +  5.4 ),
    ( year: 1838;  offset: +  5.3 ),
    ( year: 1840;  offset: +  5.4 ),
    ( year: 1842;  offset: +  5.6 ),
    ( year: 1844;  offset: +  5.9 ),
    ( year: 1846;  offset: +  6.2 ),
    ( year: 1848;  offset: +  6.5 ),
    ( year: 1850;  offset: +  6.8 ),
    ( year: 1852;  offset: +  7.1 ),
    ( year: 1854;  offset: +  7.3 ),
    ( year: 1856;  offset: +  7.5 ),
    ( year: 1858;  offset: +  7.6 ),
    ( year: 1860;  offset: +  7.7 ),
    ( year: 1862;  offset: +  7.3 ),
    ( year: 1864;  offset: +  6.2 ),
    ( year: 1866;  offset: +  5.2 ),
    ( year: 1868;  offset: +  2.7 ),
    ( year: 1870;  offset: +  1.4 ),
    ( year: 1872;  offset: -  1.2 ),
    ( year: 1874;  offset: -  2.8 ),
    ( year: 1876;  offset: -  3.8 ),
    ( year: 1878;  offset: -  4.8 ),
    ( year: 1880;  offset: -  5.5 ),
    ( year: 1882;  offset: -  5.3 ),
    ( year: 1884;  offset: -  5.6 ),
    ( year: 1886;  offset: -  5.7 ),
    ( year: 1888;  offset: -  5.9 ),
    ( year: 1890;  offset: -  6.0 ),
    ( year: 1892;  offset: -  6.3 ),
    ( year: 1894;  offset: -  6.5 ),
    ( year: 1896;  offset: -  6.2 ),
    ( year: 1898;  offset: -  4.7 ),
    ( year: 1900;  offset: -  2.8 ),
    ( year: 1902;  offset: -  0.1 ),
    ( year: 1904;  offset: +  2.6 ),
    ( year: 1906;  offset: +  5.3 ),
    ( year: 1908;  offset: +  7.7 ),
    ( year: 1910;  offset: + 10.4 ),
    ( year: 1912;  offset: + 13.3 ),
    ( year: 1914;  offset: + 16.0 ),
    ( year: 1916;  offset: + 18.2 ),
    ( year: 1918;  offset: + 20.2 ),
    ( year: 1920;  offset: + 21.1 ),
    ( year: 1922;  offset: + 22.4 ),
    ( year: 1924;  offset: + 23.5 ),
    ( year: 1926;  offset: + 23.8 ),
    ( year: 1928;  offset: + 24.3 ),
    ( year: 1930;  offset: + 24.0 ),
    ( year: 1932;  offset: + 23.9 ),
    ( year: 1934;  offset: + 23.9 ),
    ( year: 1936;  offset: + 23.7 ),
    ( year: 1938;  offset: + 24.0 ),
    ( year: 1940;  offset: + 24.3 ),
    ( year: 1942;  offset: + 25.3 ),
    ( year: 1944;  offset: + 26.2 ),
    ( year: 1946;  offset: + 27.3 ),
    ( year: 1948;  offset: + 28.2 ),
    ( year: 1950;  offset: + 29.1 ),
    ( year: 1952;  offset: + 30.0 ),
    ( year: 1954;  offset: + 30.7 ),
    ( year: 1956;  offset: + 31.4 ),
    ( year: 1958;  offset: + 32.2 ),
    ( year: 1960;  offset: + 33.1 ),
    ( year: 1962;  offset: + 34.0 )
    );
  (*@\\\*)
  TDT2TAI = 32.184;  (* offset TDT vs. TAI *)
var
  mjd: longint;
  i: integer;
  year,month,day: word;
  t: extended;
begin
  result:=0;
  mjd:=trunc(julian_date(date)-modified_julian_date_offset);
  if (mjd>=TAI2UTC[0].mjd) and (date<=datetime_earliest_next_leapsecond) then begin
    (* find the fitting entry in the array *)
    for i:=high(TAI2UTC) downto low(TAI2UTC) do begin
      result:=i;
      if TAI2UTC[i].mjd<=mjd then begin
        result:=TDT2TAI + TAI2UTC[i].offset + TAI2UTC[i].dynamic*(mjd-TAI2UTC[i].refmjd);
        BREAK;
        end;
      end;
    end
  else begin
    DecodedateCorrect(date,year,month,day);
    t:=(year-2000)*0.01;
    if year<948 then
      result:=2177+t*(497+44.1*t)
    else if (year>=948) and (year<1600) then
      result:=102+t*(102+25.3*t)
    else if (year>2000) and (year<2100) then
      result:=102+t*(102+25.3*t)+0.37*(year-2100)
    else if (year>=2100) then
      result:=102+t*(102+25.3*t)
    else begin
      for i:=low(TDT2UTC) to high(TDT2UTC) do
        if TDT2UTC[i].year>=year then begin
          result:=TDT2UTC[i].offset;
          BREAK;
          end;
      end;
    end;
  end;
(*@\\\0000000B01*)

{ Calendar functions }
(*@/// function WeekNumber(date:TDateTime):integer; *)
function WeekNumber(date:TDateTime):integer;
var
  y,m,d: word;
  h: integer;
  FirstofJanuary,
  FirstThursday,
  FirstWeekStart: TDateTime;
begin
  DecodedateCorrect(date,y,m,d);
  FirstofJanuary:=EncodedateCorrect(y,1,1);
  h:=dayOfWeek(FirstofJanuary);
  FirstThursday:=FirstofJanuary+((12-h) mod 7);
  FirstWeekStart:=FirstThursday-3;
  if trunc(date)<FirstWeekStart then
    result:=WeekNumber(FirstofJanuary-1) (* 12-31 of previous year *)
  else
    result:=(round(trunc(date)-FirstWeekStart) div 7)+1;
  end;
(*@\\\0000000C01*)
(*@/// function WeekOfMonth(date:TDateTime):integer; *)
function WeekOfMonth(date:TDateTime):integer;
var
  y,m,d: word;
  firstofmonth,
  firstthursday,
  FirstWeekStart: TDateTime;
  h: integer;
begin
  decodedatecorrect(date,y,m,d);
  FirstOfMonth:=encodedatecorrect(y,m,1);
  h:=dayOfWeek(FirstofMonth);
  FirstThursday:=FirstofMonth+((12-h) mod 7);
  FirstWeekStart:=FirstThursday-3;
  if trunc(date)<FirstWeekStart then
    result:=WeekOfMonth(FirstofMonth-1) (* last day of previous month *)
  else
    result:=(round(trunc(date)-FirstWeekStart) div 7)+1;
  (* check if the day is already in the first week of the next month *)
  if m=12 then begin
    inc(y);
    m:=0;
    end;
  FirstOfMonth:=encodedate(y,m+1,1);
  h:=dayOfWeek(FirstofMonth);
  FirstThursday:=FirstofMonth+((12-h) mod 7);
  FirstWeekStart:=FirstThursday-3;
  if FirstWeekStart<=date then
    result:=WeekOfMonth(FirstThursday);
  end;
(*@\\\003200010100012E000101*)
(*@/// function EasterDateGregorian(year:integer):TDateTime; *)
function EasterDateGregorian(year:integer):TDateTime;
var
  a,b,c,d,e,m,n,day,month: integer;
begin
  case year of
    1583..1699:  begin  m:=22; n:=2;  end;
    1700..1799:  begin  m:=23; n:=3;  end;
    1800..1899:  begin  m:=23; n:=4;  end;
    1900..2099:  begin  m:=24; n:=5;  end;
    2100..2199:  begin  m:=24; n:=6;  end;
    2200..2399:  begin  m:=25; n:=0;  end;
    else raise E_OutOfAlgorithmRange.Create('Out of range of the algorithm');
    end;
  a:=year mod 19;
  b:=year mod 4;
  c:=year mod 7;
  d:=(19*a+m) mod 30;
  e:=(2*b+4*c+6*d+n) mod 7;
  day:=(22+d+e);
  if day<=31 then
    month:=3
  else begin
    day:=(d+e-9);
    month:=4;
    end;
  if (day=26) and (month=4) then  day:=19;
  if (day=25) and (month=4) and (d=28) and (e=6) and (a>10) then  day:=18;
  result:=EncodedateCorrect(year,month,day);
  end;
(*@\\\0000001C01*)
(*@/// function EasterDate(year:integer):TDateTime; *)
function EasterDate(year:integer):TDateTime;
begin
  if year<1583 then
    result:=EasterDateJulian(year)
  else
    result:=EasterDateGregorian(year);
  end;
(*@\\\*)
(*@/// function EasterDateJulian(year:integer):TDateTime; *)
function EasterDateJulian(year:integer):TDateTime;
var
  a,b,c,d,e,f,g: integer;
begin
  a:=year mod 4;
  b:=year mod 7;
  c:=year mod 19;
  d:=(19*c+15) mod 30;
  e:=(2*a+4*b-d+34) mod 7;
  f:=(d+e+114) div 31;
  g:=(d+e+114) mod 31;
  result:=EncodedateJulian(year,f,g+1);
  end;
(*@\\\*)
(*@/// function PesachDate(year:integer):TDateTime; *)
function PesachDate(year:integer):TDateTime;
var
  a,b,c,d,j,s: integer;
  q,r: extended;
begin
  if year<359 then
    raise E_OutOfAlgorithmRange.Create('Out of range of the algorithm');
  c:=year div 100;
  if year<1583 then
    s:=0
  else
    s:=(3*c-5) div 4;
  a:=(12*year+12) mod 19;
  b:=year mod 4;
  q:=-1.904412361576+1.554241796621*a+0.25*b-0.003177794022*year+s;
  j:=(trunc(q)+3*year+5*b+2-s) mod 7;
  r:=frac(q);
  if false then
  else if j in [2,4,6] then
    d:=trunc(q)+23
  else if (j=1) and (a>6) and (r>=0.632870370) then
    d:=trunc(q)+24
  else if (j=0) and (a>11) and (r>=0.897723765) then
    d:=trunc(q)+23
  else
    d:=trunc(q)+22;

  if d>31 then
    result:=EncodedateCorrect(year,4,d-31)
  else
    result:=EncodedateCorrect(year,3,d);
  end;
(*@\\\*)
(*@/// function JewishYearStyle(year:word):TJewishYearStyle; *)
function JewishYearStyle(year:word):TJewishYearStyle;
var
  i: TJewishYearStyle;
  yearlength: integer;
begin
  yearlength:=round(pesachdate(year-3760)-pesachdate(year-3761));
  result:=low(TJewishYearStyle);
  for i:=low(TJewishYearStyle) to high(TJewishYearStyle) do
    if yearlength=Jewish_year_length[i] then
      result:=i;
  end;
(*@\\\*)
(*@/// function EncodeDateJewish(year,month,day: word):TDateTime; *)
function EncodeDateJewish(year,month,day: word):TDateTime;
var
  yearstyle: TJewishYearStyle;
  offset,i: integer;
begin
  yearstyle:=JewishYearStyle(year);
  if (month<1) or (month>13) then
    raise EConvertError.Create('Invalid month');
  if (month=13) and
     (yearstyle in [ys_common_deficient,ys_common_regular,ys_common_complete]) then
    raise EConvertError.Create('Invalid month');
  if (day<1) or (day>Jewish_Month_length[month,yearstyle]) then
    raise EConvertError.Create('Invalid day');
  offset:=day-1;
  (* count months from tishri *)
  month:=(month+6) mod 13 +1;
  for i:=1 to month-1 do
    offset:=offset+Jewish_Month_length[(i+5) mod 13 +1,yearstyle];
  result:=pesachdate(year-3761)+163+offset;
  end;
(*@\\\*)
(*@/// procedure DecodeDateJewish(date: TDateTime; var year,month,day: word); *)
procedure DecodeDateJewish(date: TDateTime; var year,month,day: word);
var
  year_g,month_g,day_g: word;
  yearstyle: TJewishYearStyle;
  tishri1: TDateTime;
begin
  DecodedateCorrect(date,year_g,month_g,day_g);
  tishri1:=pesachdate(year_g)+163;
  if tishri1>date then begin
    tishri1:=pesachdate(year_g-1)+163;
    year:=year_g+3760;
    end
  else
    year:=year_g+3761;
  yearstyle:=JewishYearStyle(year);
  month:=7;
  day:=round(date-tishri1+1);
  while day>Jewish_Month_length[month,yearstyle] do begin
    dec(day,Jewish_Month_length[month,yearstyle]);
    month:=(month mod 13) +1;
    end;
  end;
(*@\\\*)

{ Misc }
(*@/// function EquationOfTime(date:TDateTime):extended;       // seconds *)
function sun_coordinate(date:TDateTime):t_coord;  forward;

{ Based upon 28 (27) of Meeus }
function EquationOfTime(date:TDateTime):extended;
var
  tau,ls,delta_phi,epsilon:extended;
  coord:t_coord;
begin
  tau:=0.1*century_term(date);
  ls:=put_in_360(280.4664567+360007.6982779*tau
                            +0.03032028*tau*tau
                            +(tau*tau*tau)/49931
                            -(tau*tau*tau*tau)/15300
                            -(tau*tau*tau*tau*tau)/2000000);
  coord:=sun_coordinate(date);
  put_in_360(coord.rektaszension);
  delta_phi:=Nutation_Longitude(date);
  epsilon:=EclipticObliquity(date);
  result:=(ls-0.0057183-coord.rektaszension+delta_phi*cos_d(epsilon))*4*60;
  { we really have to believe Meeus here... }
  while result>20*60 do
    result:=result-86400;
  while result<-20*60 do
    result:=result+86400;
  end;
(*@\\\*)
(*@/// function parallax(distance_au:extended): extended; *)
function parallax(distance_au:extended): extended;
begin
  result:=arcsin_d(sin_d(8.794/3600)/distance_au);
  end;
(*@\\\000000011F*)

{ Coordinates of sun and moon }
(*@/// function sun_coordinate(date:TDateTime):t_coord; *)
{ Based upon Chapter 25 (24) of Meeus - low accurancy }

(*@/// function sun_coordinate_low(date:TDateTime):t_coord; *)
function sun_coordinate_low(date:TDateTime):t_coord;
var
  t,e,m,c,nu: extended;
  l0,o,omega,lambda: extended;
begin
  t:=Century_Term(date);

  (* geometrical mean longitude of the sun *)
  l0:=280.46645+(36000.76983+0.0003032*t)*t;

  (* excentricity of the earth orbit *)
  e:=0.016708617+(-0.000042037-0.0000001236*t)*t;

  (* mean anomaly of the sun *)
  m:=357.52910+(35999.05030-(0.0001559+0.00000048*t)*t)*t;

  (* mean point of sun *)
  c:= (1.914600+(-0.004817-0.000014*t)*t)*sin_d(m)
     +(0.019993-0.000101*t)*sin_d(2*m)
     +0.000290*sin_d(3*m);

  (* true longitude of the sun *)
  o:=put_in_360(l0+c);

  (* true anomaly of the sun *)
  nu:=m+c;

  (* distance of the sun in km *)
  result.radius:=(1.000001018*(1-e*e))/(1+e*cos_d(nu))*AU;

  (* apparent longitude of the sun *)
  omega:=calc_poly_IAU(date,pt_moon_longitude,poly_full_order);
  lambda:=o-0.00569-0.00478*sin_d(omega)
           -20.4898/3600/(result.radius/AU);

  result.longitude:=put_in_360(lambda+Nutation_Longitude(date));
  result.latitude:=0;
  EclipticToEquatorial(date,result.latitude,result.longitude,
    result.rektaszension,result.declination);
  end;
(*@\\\0000002601*)
(*@/// function sun_coordinate(date:TDateTime):t_coord; *)
function sun_coordinate(date:TDateTime):t_coord;
var
  v: TVector;
begin
  v:=earth_coord(date);
  (* convert earth coordinate to sun coordinate *)
  v.l:=put_in_360(v.l+180);
  v.b:=-v.b;
  (* conversion to FK5 is already done in VSOP *)
  (* aberration *)
  v.l:=v.l-20.4898/3600/v.r;
  (* correction of nutation - is done inside coord_eclipse2equator *)
{   calc_epsilon_phi(date,delta_phi,epsilon); }
{   l:=l+delta_phi; }
  (* fill result and convert to geocentric *)
  result.longitude:=put_in_360(v.l+Nutation_Longitude(date));
  result.latitude:=v.b;
  result.radius:=v.r*AU;
  EclipticToEquatorial(date,result.latitude,result.longitude,
    result.rektaszension,result.declination);
  end;
(*@\\\0000001201*)
(*@\\\0000000401*)
(*@/// function moon_coordinate(date:TDateTime):t_coord; *)
function moon_coordinate(date:TDateTime):t_coord;
var
  v: TVector;
begin
  v:=moon_coord(date);
  result.radius:=v.r;
  result.longitude:=put_in_360(v.l+Nutation_Longitude(date));
  result.latitude:=v.b;
  EclipticToEquatorial(date,result.latitude,result.longitude,
    result.rektaszension,result.declination);
  end;
(*@\\\0000000516*)
(*@/// function MeanSunRektaszension(date: TdateTime); *)
function MeanSunRektaszension(date: TdateTime):extended;
var
  t: extended;
  l0,omega,lambda,radius: extended;
  dummy: extended;
begin
  t:=Century_Term(date);

  (* geometrical mean longitude of the sun *)
  l0:=280.46645+(36000.76983+0.0003032*t)*t;

  (* distance of the sun in km *)
  radius:=1.000001018*AU;

  (* apparent longitude of the sun *)
  omega:=calc_poly_IAU(date,pt_moon_longitude,poly_full_order);
  lambda:=put_in_360(l0-0.00569-0.00478*sin_d(omega)
                     -20.4898/3600/(radius/AU));

  EclipticToEquatorial(date,0,lambda,
    result,dummy);
  end;
(*@\\\0000000419*)

(*@/// procedure EarthGlobeCorrection(latitude,longitude,height:extended; var u,rho_sin,rho_cos: extended); *)
{ Based upon chapter 11 (10) of Meeus }

procedure EarthGlobeCorrection(latitude,longitude,height:extended; var u,rho_sin,rho_cos: extended);
const
  b_a=(1.0-earth_flattening);
begin
  u:=arctan_d(b_a*tan_d(latitude));
  rho_sin:=b_a*sin_d(u)+height/1000/earth_radius*sin_d(latitude);
  rho_cos:=cos_d(u)+height/1000/earth_radius*cos_d(latitude);
  end;
(*@\\\*)
(*@/// procedure ParallaxCorrection(var rektaszension,declination:extended; *)
{ Based upon chapter 40 (39) of Meeus }

procedure ParallaxCorrection(var rektaszension,declination:extended;
  distance:extended; date:TDateTime; latitude,longitude,height:extended);
var
  u,h,delta_alpha: extended;
  rho_sin, rho_cos: extended;
  p: extended;
begin
  EarthGlobeCorrection(latitude,longitude,height,u,rho_sin,rho_cos);
  p:=parallax(distance);
  h:=star_time(date)-longitude-rektaszension;
  delta_alpha:=arctan2_d(
                (-rho_cos*sin_d(p)*sin_d(h)),
                (cos_d(declination)-rho_cos*sin_d(p)*cos_d(h)));
  rektaszension:=rektaszension+delta_alpha;
  declination:=arctan2_d(
      (( sin_d(declination)-rho_sin*sin_d(p))*cos_d(delta_alpha)),
       ( cos_d(declination)-rho_cos*sin_d(p)*cos_d(h)));
  end;
(*@\\\*)

{ Moon phases and age of the moon }
(*@/// procedure calc_phase_data(date:TDateTime; phase:TMoonPhase; var jde,kk,m,ms,f,o,e: extended); *)
{ Based upon Chapter 49 (47) of Meeus }
{ Both used for moon phases and moon and sun eclipses }

procedure calc_phase_data(date:TDateTime; phase:TMoonPhase; var jde,kk,m,ms,f,o,e: extended);
const
  phases = ord(high(TMoonPhase))+1;
var
  t: extended;
  k: longint;
begin
  k:=round(century_term(date)*1236.85-ord(phase)/phases);
  kk:=int(k)+ord(phase)/phases;
  t:=kk/1236.85;
(*$ifdef firstedition *)
  jde:=2451550.09765+29.530588853*kk
       +t*t*(0.0001337-t*(0.000000150-0.00000000073*t));
  m:=2.5534+29.10535669*kk-t*t*(0.0000218+0.00000011*t);
  ms:=201.5643+385.81693528*kk+t*t*(0.1017438+t*(0.00001239-t*0.000000058));
  f:=160.7108+390.67050274*kk-t*t*(0.0016341+t*(0.00000227-t*0.000000011));
  o:=124.7746-1.56375580*kk+t*t*(0.0020691+t*0.00000215);
(*$else *)
  jde:=2451550.09766+29.530588861*kk
       +t*t*(0.00015437-t*(0.000000150-0.00000000073*t));
  m:=2.5534+29.10535670*kk-t*t*(0.0000014+0.00000011*t);
  ms:=201.5643+385.81693528*kk+t*t*(0.0107582+t*(0.00001238-t*0.000000058));
  f:=160.7108+390.67050284*kk-t*t*(0.0016118+t*(0.00000227-t*0.000000011));
  o:=124.7746-1.56375588*kk+t*t*(0.0020672+t*0.00000215);
(*$endif *)
  e:=GetEccentricityTerm(date)
  end;
(*@\\\0000000A01*)
(*@/// function nextphase_approx(date: TDateTime; phase:TMoonphase):TDateTime; *)
function nextphase_approx(date: TDateTime; phase:TMoonphase):TDateTime;
const
  epsilon = 1E-7;
  phases = ord(high(TMoonPhase))+1;
var
  target_age: extended;
  h: extended;
begin
  target_age:=ord(phase)*mean_lunation/phases;
  result:=date;
  repeat
    h:=AgeOfMoonWalker(result)-target_age;
    if h>mean_lunation/2 then
      h:=h-mean_lunation;
    result:=result-h;
    until abs(h)<epsilon;
  end;
(*@\\\0000000C17*)
(*@/// function nextphase_49(date:TDateTime; phase:TMoonPhase):TDateTime; *)
{ Based upon Chapter 49 (47) of Meeus }

function nextphase_49(date:TDateTime; phase:TMoonPhase):TDateTime;
var
  t: extended;
  kk: extended;
  jde: extended;
  m,ms,f,o,e: extended;
  korr,w,akorr: extended;
  a:array[1..14] of extended;
begin
  if not (phase in [Newmoon,FirstQuarter,Fullmoon,LastQuarter]) then
    raise E_OutOfAlgorithmRange.Create('Invalid TMoonPhase');
  calc_phase_data(date,phase,jde,kk,m,ms,f,o,e);
  t:=kk/1236.85;
  case phase of
    (*@/// Newmoon: *)
    Newmoon:  begin
      korr:= -0.40720*sin_d(ms)
             +0.17241*e*sin_d(m)
             +0.01608*sin_d(2*ms)
             +0.01039*sin_d(2*f)
             +0.00739*e*sin_d(ms-m)
             -0.00514*e*sin_d(ms+m)
             +0.00208*e*e*sin_d(2*m)
             -0.00111*sin_d(ms-2*f)
             -0.00057*sin_d(ms+2*f)
             +0.00056*e*sin_d(2*ms+m)
             -0.00042*sin_d(3*ms)
             +0.00042*e*sin_d(m+2*f)
             +0.00038*e*sin_d(m-2*f)
             -0.00024*e*sin_d(2*ms-m)
             -0.00017*sin_d(o)
             -0.00007*sin_d(ms+2*m)
             +0.00004*sin_d(2*ms-2*f)
             +0.00004*sin_d(3*m)
             +0.00003*sin_d(ms+m-2*f)
             +0.00003*sin_d(2*ms+2*f)
             -0.00003*sin_d(ms+m+2*f)
             +0.00003*sin_d(ms-m+2*f)
             -0.00002*sin_d(ms-m-2*f)
             -0.00002*sin_d(3*ms+m)
             +0.00002*sin_d(4*ms);
      end;
    (*@\\\*)
    (*@/// FirstQuarter,LastQuarter: *)
    FirstQuarter,LastQuarter:  begin
      korr:= -0.62801*sin_d(ms)
             +0.17172*e*sin_d(m)
             -0.01183*e*sin_d(ms+m)
             +0.00862*sin_d(2*ms)
             +0.00804*sin_d(2*f)
             +0.00454*e*sin_d(ms-m)
             +0.00204*e*e*sin_d(2*m)
             -0.00180*sin_d(ms-2*f)
             -0.00070*sin_d(ms+2*f)
             -0.00040*sin_d(3*ms)
             -0.00034*e*sin_d(2*ms-m)
             +0.00032*e*sin_d(m+2*f)
             +0.00032*e*sin_d(m-2*f)
             -0.00028*e*e*sin_d(ms+2*m)
             +0.00027*e*sin_d(2*ms+m)
             -0.00017*sin_d(o)
             -0.00005*sin_d(ms-m-2*f)
             +0.00004*sin_d(2*ms+2*f)
             -0.00004*sin_d(ms+m+2*f)
             +0.00004*sin_d(ms-2*m)
             +0.00003*sin_d(ms+m-2*f)
             +0.00003*sin_d(3*m)
             +0.00002*sin_d(2*ms-2*f)
             +0.00002*sin_d(ms-m+2*f)
             -0.00002*sin_d(3*ms+m);
      w:=0.00306-0.00038*e*cos_d(m)
                +0.00026*cos_d(ms)
                -0.00002*cos_d(ms-m)
                +0.00002*cos_d(ms+m)
                +0.00002*cos_d(2*f);
      if phase = FirstQuarter then begin
        korr:=korr+w;
        end
      else begin
        korr:=korr-w;
        end;
      end;
    (*@\\\*)
    (*@/// Fullmoon: *)
    Fullmoon:  begin
      korr:= -0.40614*sin_d(ms)
             +0.17302*e*sin_d(m)
             +0.01614*sin_d(2*ms)
             +0.01043*sin_d(2*f)
             +0.00734*e*sin_d(ms-m)
             -0.00515*e*sin_d(ms+m)
             +0.00209*e*e*sin_d(2*m)
             -0.00111*sin_d(ms-2*f)
             -0.00057*sin_d(ms+2*f)
             +0.00056*e*sin_d(2*ms+m)
             -0.00042*sin_d(3*ms)
             +0.00042*e*sin_d(m+2*f)
             +0.00038*e*sin_d(m-2*f)
             -0.00024*e*sin_d(2*ms-m)
             -0.00017*sin_d(o)
             -0.00007*sin_d(ms+2*m)
             +0.00004*sin_d(2*ms-2*f)
             +0.00004*sin_d(3*m)
             +0.00003*sin_d(ms+m-2*f)
             +0.00003*sin_d(2*ms+2*f)
             -0.00003*sin_d(ms+m+2*f)
             +0.00003*sin_d(ms-m+2*f)
             -0.00002*sin_d(ms-m-2*f)
             -0.00002*sin_d(3*ms+m)
             +0.00002*sin_d(4*ms);
      end;
    (*@\\\*)
    (*@/// else *)
    else
      korr:=0;   (* Delphi 2 shut up! *)
    (*@\\\*)
    end;
  (*@/// Additional Corrections due to planets *)
  a[1]:=299.77+0.107408*kk-0.009173*t*t;
  a[2]:=251.88+0.016321*kk;
  a[3]:=251.83+26.651886*kk;
  a[4]:=349.42+36.412478*kk;
  a[5]:= 84.66+18.206239*kk;
  a[6]:=141.74+53.303771*kk;
  a[7]:=207.14+2.453732*kk;
  a[8]:=154.84+7.306860*kk;
  a[9]:= 34.52+27.261239*kk;
  a[10]:=207.19+0.121824*kk;
  a[11]:=291.34+1.844379*kk;
  a[12]:=161.72+24.198154*kk;
  a[13]:=239.56+25.513099*kk;
  a[14]:=331.55+3.592518*kk;
  akorr:=   +0.000325*sin_d(a[1])
            +0.000165*sin_d(a[2])
            +0.000164*sin_d(a[3])
            +0.000126*sin_d(a[4])
            +0.000110*sin_d(a[5])
            +0.000062*sin_d(a[6])
            +0.000060*sin_d(a[7])
            +0.000056*sin_d(a[8])
            +0.000047*sin_d(a[9])
            +0.000042*sin_d(a[10])
            +0.000040*sin_d(a[11])
            +0.000037*sin_d(a[12])
            +0.000035*sin_d(a[13])
            +0.000023*sin_d(a[14]);
  korr:=korr+akorr;
  (*@\\\*)
  result:=delphi_date(jde+korr);
  end;
(*@\\\0000000201*)
(*@/// function nextphase(date:TDateTime; phase:TMoonPhase):TDateTime; *)
(* nextphase_approx has similar accuracy as nextphase_49 *)

function nextphase(date:TDateTime; phase:TMoonPhase):TDateTime;
begin
  case phase of
    Newmoon,FirstQuarter,Fullmoon,LastQuarter:
      result:=nextphase_49(date,phase);
    WaxingCrescent,WaxingGibbous,WaningGibbous,WaningCrescent:
      result:=nextphase_approx(date,phase);
    else
      result:=0;   (* Delphi shut up *)
      end;
  end;
(*@\\\*)
(*@/// function last_phase(date:TDateTime; phase:TMoonPhase):TDateTime; *)
function last_phase(date:TDateTime; phase:TMoonPhase):TDateTime;
var
  temp_date: TDateTime;
begin
  temp_date:=date+28;
  result:=temp_date;
  while result>date do begin
    result:=nextphase(temp_date,phase);
    if result=0 then
      raise E_OutOfAlgorithmRange.Create('No TDateTime possible');
    temp_date:=temp_date-28;
    end;
  end;
(*@\\\*)
(*@/// function next_phase(date:TDateTime; phase:TMoonPhase):TDateTime; *)
function next_phase(date:TDateTime; phase:TMoonPhase):TDateTime;
var
  temp_date: TDateTime;
begin
  temp_date:=date-28;
  result:=temp_date;
  while result<date do begin
    result:=nextphase(temp_date,phase);
    if result=0 then
      raise E_OutOfAlgorithmRange.Create('No TDateTime possible');
    temp_date:=temp_date+28;
    end;
  end;
(*@\\\*)
(*@/// function nearest_phase(date: TDateTime):TMoonPhase; *)
function nearest_phase(date: TDateTime):TMoonPhase;
const
  phases = ord(high(TMoonPhase))+1;
begin
  result:=TMoonPhase(round(AgeOfMoonWalker(date)/mean_lunation*phases) mod phases);
  end;
(*@\\\0000000501*)
(*@/// function next_blue_moon_bias(date: TDateTime; timezonebias:extended):TDateTime; *)
function next_blue_moon_bias(date: TDateTime; timezonebias:extended):TDateTime;
var
  h: TDateTime;
  y,m,d: word;
  y1,m1,d1: word;
begin
  h:=date-1+timezonebias;
  repeat
    h:=h+1;
    h:=next_phase(h,Fullmoon);
    DecodeDateCorrect(h-timezonebias,y,m,d);
    if d>27 then     (* only chance for a blue moon anyway *)
      DecodeDateCorrect(last_phase(h-5,FullMoon)-timezonebias,y1,m1,d1)
    else
      m1:=0;
    until m=m1;
  result:=h;
  end;
(*@\\\*)
(*@/// function next_blue_moon(date: TDateTime):TDateTime; *)
function next_blue_moon(date: TDateTime):TDateTime;
begin
  result:=next_blue_moon_bias(date,0);
  end;
(*@\\\*)
(*@/// function is_blue_moon(lunation: integer):boolean; *)
function is_blue_moon(lunation: integer):boolean;
var
  date: TDateTime;
begin
  date:=Lunation_phase(lunation,NewMoon);
  result:=((next_blue_moon(date)-date)<mean_lunation);
  end;
(*@\\\0000000503*)

(*@/// function MoonName(lunation: integer):TMoonName; *)
function StartMeanSeason(year: integer; season:TSeason):TDateTime;  forward;

function MoonName(lunation: integer):TMoonName;
var
  date_full, first_full, last_full: TDateTime;
  previous_vernal_equinox, next_vernal_equinox: TDateTime;
  easter: TDateTime;
  year,month,day: word;
  season_length: extended;
  season: integer;
  moon_number: integer;
begin
  date_full:=Lunation_phase(lunation,FullMoon);
  decodedate(date_full,year,month,day);
  previous_vernal_equinox:=StartMeanSeason(year-1,spring);
  next_vernal_equinox:=StartMeanSeason(year,spring);
  if next_vernal_equinox<date_full then begin
    previous_vernal_equinox:=next_vernal_equinox;
    next_vernal_equinox:=StartMeanSeason(year+1,spring);
    end;
  season_length:=(next_vernal_equinox-previous_vernal_equinox)/4;
  season:=trunc((date_full-previous_vernal_equinox)/season_length);
  (* Special of Farmer's Almanac Rule: use ecclesiastical equinox instead of mean *)
  easter:=EasterDate(year);
  if season=0 then begin
    first_full:=next_phase(EncodeDate(year,3,21)+maine_timezone_offset,FullMoon);
    if easter-first_full>7 then
      first_full:=next_phase(first_full+5,FullMoon);
    end
  else
    first_full:=next_phase(previous_vernal_equinox+season*season_length,FullMoon);
  if season=3 then begin
    last_full:=last_phase(EncodeDate(year,3,21)+maine_timezone_offset,FullMoon);
    if easter-last_full>7 then
      last_full:=next_phase(last_full+5,FullMoon);
    end
  else
    last_full:=last_phase(previous_vernal_equinox+(season+1)*season_length,FullMoon);
  moon_number:=round((date_full-first_full)/mean_lunation);
  if round((last_full-first_full)/mean_lunation)=2 then
    result:=TMoonName(((season+1) mod 4)*3+moon_number)
  else  (* has blue moon in this season *)
    case moon_number of
      0,1: result:=TMoonName(((season+1) mod 4)*3+moon_number);
      2:   result:=mn_blue;
      3:   result:=TMoonName(((season+1) mod 4)*3+moon_number-1);
      else result:=mn_blue;  (* this cannot happen - just to avoid warning *)
      end;
  end;
(*@\\\0000002101*)

(*@/// function moon_phase_angle(date: TDateTime):extended; *)
{ Based upon Chapter 48 (46) of Meeus }

function moon_phase_angle(date: TDateTime):extended;
var
  sun_coord,moon_coord: t_coord;
  psi: extended;
begin
  sun_coord:=sun_coordinate(date);
  moon_coord:=moon_coordinate(date);
  psi:=arccos_d(cos_d(moon_coord.latitude)
               *cos_d(moon_coord.longitude-sun_coord.longitude));
  result:=arctan2_d(sun_coord.radius*sin_d(psi),
                    moon_coord.radius-sun_coord.radius*cos_d(psi));
  if put_in_360(moon_coord.longitude-sun_coord.longitude)>180 then
    result:=-result;
  end;
(*@\\\0000000E01*)
(*@/// function AgeOfMoonWalker(date:TDateTime): extended; *)
function AgeOfMoonWalker(date:TDateTime): extended;
var
  sun_coord,moon_coord: t_coord;
begin
  sun_coord:=sun_coordinate(date);
  moon_coord:=moon_coordinate(date);
  result:=put_in_360(moon_coord.longitude-sun_coord.longitude)/360*mean_lunation;
  end;
(*@\\\000000010A*)
(*@/// function AgeOfMoon(date:TDateTime): extended; *)
function AgeOfMoon(date:TDateTime): extended;
begin
  result:=date-last_phase(date,Newmoon);
  end;
(*@\\\0000000301*)
(*@/// function current_phase(date:TDateTime):extended; *)
function current_phase(date:TDateTime):extended;
begin
  result:=(1+cos_d(moon_phase_angle(date)))/2;
  end;
(*@\\\*)
(*@/// function MoonBrightLimbPositionAngle(date:TDateTime):extended; *)
{ Based upon Chapter 48 (46) of Meeus }

function MoonBrightLimbPositionAngle(date:TDateTime):extended;
var
  sun,moon: t_coord;
begin
  sun:=sun_coordinate(date);
  moon:=moon_coordinate(date);
  result:=arctan2_d(cos_d(sun.declination)*sin_d(sun.rektaszension-moon.rektaszension),
    sin_d(sun.declination)*cos_d(moon.declination)-
    cos_d(sun.declination)*sin_d(moon.declination)*cos_d(sun.rektaszension-moon.rektaszension));
  end;
(*@\\\0000000901*)
(*@/// function MoonBrightLimbPositionAngleZenith(date:TDateTime; latitude,longitude:extended):extended; *)
function MoonBrightLimbPositionAngleZenith(date:TDateTime; latitude,longitude:extended):extended;
var
  moon: t_coord;
  chi,h,q: extended;
begin
  moon:=moon_coordinate(date);
  chi:=MoonBrightLimbPositionAngle(date);
  h:=put_in_360(star_time(date)-moon.rektaszension-longitude);
  q:=arctan2_d(sin_d(h),
    tan_d(latitude)*cos_d(moon.declination)-sin_d(moon.declination)*cos_d(h));
  result:=put_in_360(chi-q);
  end;
(*@\\\0000000801*)


(*@/// function lunation(date:TDateTime):integer; *)
function lunation(date:TDateTime):integer;
begin
  result:=round((last_phase(date,NewMoon)-datetime_first_lunation)/mean_lunation)+1;
  end;
(*@\\\*)
(*@/// function Lunation_phase(lunation: integer; phase: TMoonPhase):TDateTime; *)
function Lunation_phase(lunation: integer; phase: TMoonPhase):TDateTime;
begin
  result:=next_phase(datetime_first_lunation+(lunation-1)*mean_lunation-2,phase);
  end;
(*@\\\*)

{ Libration et.al. }
(*@/// procedure Libration_terms(date: TdateTime; var rho,sigma,tau,w,a,I,lambda,beta:extended); *)
procedure Libration_terms(date: TdateTime; var rho,sigma,tau,w,a,I,lambda,beta:extended);
var
  coord: t_coord;
  t,m,ms,f,d,e,omega: extended;
  k1,k2: extended;
begin
  t:=century_term(date);
  I:=1.0+32.0/60+32.7/3600; (* inclination of mean lunar equator to ecliptic *)
  coord:=moon_coordinate(date);
  lambda:=coord.longitude;
  beta:=coord.latitude;
  w:=lambda-Nutation_Longitude(date)-calc_poly(date,pt_moon_node,poly_full_order);
  a:=arctan2_d(
    (sin_d(w)*cos_d(beta)*cos_d(I)-sin_d(beta)*sin_d(I)),
    (cos_d(w)*cos_d(beta)) );

  d:=calc_poly(date,pt_moon_elongation,poly_full_order);
  m:=calc_poly(date,pt_sun_anomaly,poly_full_order);
  ms:=calc_poly(date,pt_moon_anomaly,poly_full_order);
  f:=calc_poly(date,pt_moon_argument,poly_full_order);
  omega:=calc_poly(date,pt_moon_node,poly_full_order);
  e:=GetEccentricityTerm(date);
  k1:=119.75+131.849*t;
  k2:= 72.56+ 20.186*t;
  rho:=-0.02752*cos_d(ms)
       -0.02245*sin_d(f)
       +0.00684*cos_d(ms-2*f)
       -0.00293*cos_d(2*f)
       -0.00085*cos_d(2*f-2*d)
       -0.00054*cos_d(ms-2*d)
       -0.00020*sin_d(ms+f)
       -0.00020*cos_d(ms+2*f)
       -0.00020*cos_d(ms-f)
       +0.00014*cos_d(ms+2*f-2*d);
  sigma:=-0.02816*sin_d(ms)
         +0.02244*cos_d(f)
         -0.00682*sin_d(ms-2*f)
         -0.00279*sin_d(2*f)
         -0.00083*sin_d(2*f-2*d)
         +0.00069*sin_d(ms-2*d)
         +0.00040*cos_d(ms+f)
         -0.00025*sin_d(2*ms)
         -0.00023*sin_d(ms+2*f)
         +0.00020*cos_d(ms-f)
         +0.00019*sin_d(ms-f)
         +0.00013*sin_d(ms+2*f-2*d)
         -0.00010*cos_d(ms-3*f);
  tau:=+0.02520*e*sin_d(m)
       +0.00473*sin_d(2*ms-2*f)
       -0.00467*sin_d(ms)
       +0.00396*sin_d(k1)
       +0.00276*sin_d(2*ms-2*d)
       +0.00196*sin_d(omega)
       -0.00183*cos_d(ms-f)
       +0.00115*sin_d(ms-2*d)
       -0.00096*sin_d(ms-d)
       +0.00046*sin_d(2*f-2*d)
       -0.00039*sin_d(ms-f)
       -0.00032*sin_d(ms-m-d)
       +0.00027*sin_d(2*ms-m-2*d)
       +0.00023*sin_d(k2)
       -0.00014*sin_d(2*d)
       +0.00014*cos_d(2*ms-2*f)
       -0.00012*sin_d(ms-2*f)
       -0.00012*sin_d(2*ms)
       +0.00011*sin_d(2*ms-2*m-2*d);
  end;
(*@\\\0000001601*)
(*@/// procedure OpticalLibration(date: TDateTime; var latitude,longitude:extended); *)
procedure OpticalLibration(date: TDateTime; var latitude,longitude:extended);
var
  rho,sigma,tau,w,a,I,lambda,beta: extended;
begin
  Libration_terms(date,rho,sigma,tau,w,a,I,lambda,beta);
  longitude:=a-calc_poly(date,pt_moon_argument,poly_full_order);
  latitude:=arcsin_d(-sin_d(w)*cos_d(beta)*sin_d(I)
                     -sin_d(beta)*cos_d(I) );
  end;
(*@\\\*)
(*@/// procedure PhysicalLibration(date: TDateTime; var latitude,longitude:extended); *)
procedure PhysicalLibration(date: TDateTime; var latitude,longitude:extended);
var
  rho,sigma,tau,w,a,I,lambda,beta: extended;
begin
  Libration_terms(date,rho,sigma,tau,w,a,I,lambda,beta);
  OpticalLibration(date,latitude,longitude);
  longitude:=longitude-tau+(rho*cos_d(a)+sigma*sin_d(a))*tan_d(latitude);
  latitude:=latitude+sigma*cos_d(a)-rho*sin_d(a);
  end;
(*@\\\0000000201*)
(*@/// function MoonPositionAngleAxis(date:TDateTime):extended; *)
function MoonPositionAngleAxis(date:TDateTime):extended;
var
  rho,sigma,tau,w,a,I,lambda,beta: extended;
  v,x,y,omega: extended;
  epsilon: extended;
  l,b: extended;
  alpha,delta: extended;
begin
  Libration_terms(date,rho,sigma,tau,w,a,I,lambda,beta);
  epsilon:=EclipticObliquity(date);
  PhysicalLibration(date,b,l);
  EclipticToEquatorial(date,beta,lambda,alpha,delta);
  v:=calc_poly(date,pt_moon_node,poly_full_order)+Nutation_Longitude(date)+sigma/sin_d(I);
  x:=sin_d(I+rho)*sin_d(v);
  y:=sin_d(I+rho)*cos_d(v)*cos_d(epsilon)-cos_d(I+rho)*sin_d(epsilon);
  omega:=arctan2_d(X,Y);
  result:=arcsin_d(sqrt(X*X+Y*Y)*cos_d(alpha-omega)/cos_d(b));
  end;
(*@\\\0000000C01*)

{ Equatorial coordinates }
(*@/// procedure Sun_Position_Equatorial(date:TdateTime; var rektaszension,declination:extended); *)
procedure Sun_Position_Equatorial(date:TdateTime; var rektaszension,declination:extended);
var
  coord: T_Coord;
begin
  coord:=sun_coordinate(date);
  rektaszension:=coord.rektaszension;
  declination:=coord.declination;
  end;
(*@\\\0000000122*)
(*@/// procedure Moon_Position_Equatorial(date:TdateTime; var rektaszension,declination:extended); *)
procedure Moon_Position_Equatorial(date:TdateTime; var rektaszension,declination:extended);
var
  coord: T_Coord;
begin
  coord:=moon_coordinate(date);
  rektaszension:=coord.rektaszension;
  declination:=coord.declination;
  end;
(*@\\\*)

{ Ecliptic coordinates }
(*@/// procedure Sun_Position_Ecliptic(date:TdateTime; var latitude,longitude:extended); *)
procedure Sun_Position_Ecliptic(date:TdateTime; var latitude,longitude:extended);
var
  coord: T_Coord;
begin
  coord:=sun_coordinate(date);
  longitude:=coord.longitude;
  latitude:=coord.latitude;
  end;
(*@\\\*)
(*@/// procedure Moon_Position_Ecliptic(date:TdateTime; var latitude,longitude:extended); *)
procedure Moon_Position_Ecliptic(date:TdateTime; var latitude,longitude:extended);
var
  coord: T_Coord;
begin
  coord:=moon_coordinate(date);
  longitude:=coord.longitude;
  latitude:=coord.latitude;
  end;
(*@\\\*)

(*@/// function SunZodiac(date: TDateTime):TZodiac; *)
function SunZodiac(date: TDateTime):TZodiac;
var
  longitude,latitude:extended;
begin
  Sun_Position_Ecliptic(date,latitude,longitude);
  result:=TZodiac(trunc(longitude/30.0));
  end;
(*@\\\0000000625*)
(*@/// function MoonZodiac(date: TDateTime):TZodiac; *)
function MoonZodiac(date: TDateTime):TZodiac;
var
  longitude,latitude:extended;
begin
  Moon_Position_Ecliptic(date,latitude,longitude);
  result:=TZodiac(trunc(longitude/30.0));
  end;
(*@\\\0000000625*)

{ The distances }
(*@/// function sun_distance(date: TDateTime): extended;    // AU *)
function sun_distance(date: TDateTime): extended;
begin
  result:=sun_coordinate(date).radius/au;
  end;
(*@\\\*)
(*@/// function moon_distance(date: TDateTime): extended;   // km *)
function moon_distance(date: TDateTime): extended;
begin
  result:=moon_coordinate(date).radius;
  end;
(*@\\\0000000117*)

(*@/// function DistanceOnEarth(const s1,s2:t_coord):extended; *)
{ Based upon chapter 11 (10) of Meeus }

function DistanceOnEarth(latitude1,longitude1,latitude2,longitude2:extended):extended;
const
  a=6378.14;        { equatorial radius }
  flat=1.0/298.257; { flattening }
var
  F,G,lambda,S,C, omega, omegaAsRadian, R, D, H1, H2:extended;
begin
  if ((longitude1=longitude2) and (latitude1=latitude2)) then begin
    result:=0;
    EXIT;
    end;

  F:=(latitude1+latitude2)*0.5;
  G:=(latitude1-latitude2)*0.5;
  lambda:=(longitude1-longitude2)*0.5;
  S:=sin_d(G)*sin_d(G)*cos_d(lambda)*cos_d(lambda)+
     cos_d(F)*cos_d(F)*sin_d(lambda)*sin_d(lambda);
  C:=cos_d(G)*cos_d(G)*cos_d(lambda)*cos_d(lambda)+
     sin_d(F)*sin_d(F)*sin_d(lambda)*sin_d(lambda);
  omega :=arctan_d(Sqrt(S/C));
  omegaAsRadian:=deg2rad(omega);
  R:=(Sqrt(S*C))/omegaAsRadian;
  D:=2*omegaAsRadian*a;

  H1:=(3*R-1)/(2*C);
  H2:=(3*R+1)/(2*S);
  result:=D*(1+
    (flat*H1*sqr(sin_d(F))*sqr(cos_d(G)))-
    (flat*H2*sqr(cos_d(F))*sqr(sin_d(G)))
                                                  );
  end;
(*@\\\0000000501*)

{ The angular diameter (which is 0.5 of the subtent in moontool) }
(*@/// function sun_diameter(date:TDateTime):extended;     // angular seconds *)
function sun_diameter(date:TDateTime):extended;
begin
  result:=959.63/(sun_coordinate(date).radius/au)*2;
  end;
(*@\\\*)
(*@/// function moon_diameter(date:TDateTime):extended;    // angular seconds *)
function moon_diameter(date:TDateTime):extended;
begin
  result:=358473400/moon_coordinate(date).radius*2;
  end;
(*@\\\*)

{ Perigee and Apogee }
(*@/// function nextXXXgee(date:TDateTime; apo: boolean):TDateTime; *)
{ Based upon Chapter 50 (48) of Meeus }

function nextXXXgee(date:TDateTime; apo: boolean):TDateTime;
const
  (*@/// arg_apo:array[0..31,0..2] of shortint = (..); *)
  arg_apo:array[0..31,0..2] of shortint = (
     { D  F  M }
     ( 2, 0, 0),
     ( 4, 0, 0),
     ( 0, 0, 1),
     ( 2, 0,-1),
     ( 0, 2, 0),
     ( 1, 0, 0),
     ( 6, 0, 0),
     ( 4, 0,-1),
     ( 2, 2, 0),
     ( 1, 0, 1),
     ( 8, 0, 0),
     ( 6, 0,-1),
     ( 2,-2, 0),
     ( 2, 0,-2),
     ( 3, 0, 0),
     ( 4, 2, 0),
     ( 8, 0,-1),
     ( 4, 0,-2),
     (10, 0, 0),
     ( 3, 0, 1),
     ( 0, 0, 2),
     ( 2, 0, 1),
     ( 2, 0, 2),
     ( 6, 2, 0),
     ( 6, 0,-2),
     (10, 0,-1),
     ( 5, 0, 0),
     ( 4,-2, 0),
     ( 0, 2, 1),
     (12, 0, 0),
     ( 2, 2,-1),
     ( 1, 0,-1)
               );
  (*@\\\*)
  (*@/// arg_per:array[0..59,0..2] of shortint = (..); *)
  arg_per:array[0..59,0..2] of shortint = (
     { D  F  M }
     ( 2, 0, 0),
     ( 4, 0, 0),
     ( 6, 0, 0),
     ( 8, 0, 0),
     ( 2, 0,-1),
     ( 0, 0, 1),
     (10, 0, 0),
     ( 4, 0,-1),
     ( 6, 0,-1),
     (12, 0, 0),
     ( 1, 0, 0),
     ( 8, 0,-1),
     (14, 0, 0),
     ( 0, 2, 0),
     ( 3, 0, 0),
     (10, 0,-1),
     (16, 0, 0),
     (12, 0,-1),
     ( 5, 0, 0),
     ( 2, 2, 0),
     (18, 0, 0),
     (14, 0,-1),
     ( 7, 0, 0),
     ( 2, 1, 0),
     (20, 0, 0),
     ( 1, 0, 1),
     (16, 0,-1),
     ( 4, 0, 1),
     ( 2, 0,-2),
     ( 4, 0,-2),
     ( 6, 0,-2),
     (22, 0, 0),
     (18, 0,-1),
     ( 6, 0, 1),
     (11, 0, 0),
     ( 8, 0, 1),
     ( 4,-2, 0),
     ( 6, 2, 0),
     ( 3, 0, 1),
     ( 5, 0, 1),
     (13, 0, 0),
     (20, 0,-1),
     ( 3, 0, 2),
     ( 4, 2,-2),
     ( 1, 0, 2),
     (22, 0,-1),
     ( 0, 4, 0),
     ( 6,-2, 0),
     ( 2,-2, 1),
     ( 0, 0, 2),
     ( 0, 2,-1),
     ( 2, 4, 0),
     ( 0, 2,-2),
     ( 2,-2, 2),
     (24, 0, 0),
     ( 4,-4, 0),
     ( 9, 0, 0),
     ( 4, 2, 0),
     ( 2, 0, 2),
     ( 1, 0,-1)
               );
  (*@\\\*)
  (*@/// koe_apo:array[0..31,0..1] of longint = (..); *)
  koe_apo:array[0..31,0..1] of longint = (
     {    1   T }
     ( 4392,  0),
     (  684,  0),
     (  456,-11),
     (  426,-11),
     (  212,  0),
     ( -189,  0),
     (  144,  0),
     (  113,  0),
     (   47,  0),
     (   36,  0),
     (   35,  0),
     (   34,  0),
     (  -34,  0),
     (   22,  0),
     (  -17,  0),
     (   13,  0),
     (   11,  0),
     (   10,  0),
     (    9,  0),
     (    7,  0),
     (    6,  0),
     (    5,  0),
     (    5,  0),
     (    4,  0),
     (    4,  0),
     (    4,  0),
     (   -4,  0),
     (   -4,  0),
     (    3,  0),
     (    3,  0),
     (    3,  0),
     (   -3,  0)
                 );
  (*@\\\*)
  (*@/// koe_per:array[0..59,0..1] of longint = (..); *)
  koe_per:array[0..59,0..1] of longint = (
     {     1   T }
     (-16769,  0),
     (  4589,  0),
     ( -1856,  0),
     (   883,  0),
     (  -773, 19),
     (   502,-13),
     (  -460,  0),
     (   422,-11),
     (  -256,  0),
     (   253,  0),
     (   237,  0),
     (   162,  0),
     (  -145,  0),
     (   129,  0),
     (  -112,  0),
     (  -104,  0),
     (    86,  0),
     (    69,  0),
     (    66,  0),
     (   -53,  0),
     (   -52,  0),
     (   -46,  0),
     (   -41,  0),
     (    40,  0),
     (    32,  0),
     (   -32,  0),
     (    31,  0),
     (   -29,  0),
     (   -27,  0),
     (    24,  0),
     (   -21,  0),
     (   -21,  0),
     (   -21,  0),
     (    19,  0),
     (   -18,  0),
     (   -14,  0),
     (   -14,  0),
     (   -14,  0),
     (    14,  0),
     (   -14,  0),
     (    13,  0),
     (    13,  0),
     (    11,  0),
     (   -11,  0),
     (   -10,  0),
     (    -9,  0),
     (    -8,  0),
     (     8,  0),
     (     8,  0),
     (     7,  0),
     (     7,  0),
     (     7,  0),
     (    -6,  0),
     (    -6,  0),
     (     6,  0),
     (     5,  0),
     (    27,  0),
     (    27,  0),
     (     5,  0),
     (    -4,  0)
                 );
  (*@\\\*)
var
  k, jde, t: extended;
  d,m,f,v: extended;
  i: integer;
begin
  k:=round(((date-datetime_1999_01_01)/365.25-0.97)*13.2555);
  if apo then k:=k+0.5;
  t:=k/1325.55;
  jde:=2451534.6698+27.55454988*k+(-0.0006886+
       (-0.000001098+0.0000000052*t)*t)*t*t;
  d:=171.9179+335.9106046*k+(-0.0100250+(-0.00001156+0.000000055*t)*t)*t*t;
  m:=347.3477+27.1577721*k+(-0.0008323-0.0000010*t)*t*t;
  f:=316.6109+364.5287911*k+(-0.0125131-0.0000148*t)*t*t;
  v:=0;
  if apo then
    for i:=0 to 31 do
      v:=v+sin_d(arg_apo[i,0]*d+arg_apo[i,1]*f+arg_apo[i,2]*m)*
         (koe_apo[i,0]*0.0001+koe_apo[i,1]*0.00001*t)
  else
    for i:=0 to 59 do
      v:=v+sin_d(arg_per[i,0]*d+arg_per[i,1]*f+arg_per[i,2]*m)*
         (koe_per[i,0]*0.0001+koe_per[i,1]*0.00001*t);
  result:=delphi_date(jde+v);
  end;
(*@\\\0000000E01*)
(*@/// function nextperigee(date:TDateTime):TDateTime; *)
function nextperigee(date:TDateTime):TDateTime;
var
  temp_date: TDateTime;
begin
  temp_date:=date-30;         (* perigee maximum distance of 28.5 days *)
  result:=temp_date;
  while result<date do begin
    result:=nextXXXgee(temp_date,false);
    temp_date:=temp_date+24;  (* perigee minimum distance of 24.6 days *)
    end;
  end;
(*@\\\*)
(*@/// function nextapogee(date:TDateTime):TDateTime; *)
function nextapogee(date:TDateTime):TDateTime;
var
  temp_date: TDateTime;
begin
  temp_date:=date-28;         (* apogee maximum distance of 27.9 days *)
  result:=temp_date;
  while result<date do begin
    result:=nextXXXgee(temp_date,true);
    temp_date:=temp_date+26;  (* apogee minimum distance of 26.98 days *)
    end;
  end;
(*@\\\*)
(*@/// function nextxxxhel(date: TDateTime; apo: boolean):TDateTime; *)
{ Based upon Chapter 38 (37) of Meeus }

function nextxxxhel(date: TDateTime; apo: boolean):TDateTime;
var
  k, jde: extended;
  a1,a2,a3,a4,a5 : extended;
  corr: extended;
(*$ifndef low_accuracy *)
  value, delta: extended;
const
  epsilon = 1.0/864000; (* 0.1 second *)
  delta_t = 1.0/24/60;  (* 1 minute *)
(*$endif *)
begin
  k:=round(((date-datetime_2000_01_01)/365.25-0.01)*0.99997);
  if apo then k:=k+0.5;
(*$ifdef firstedition *)
  jde:=2451547.507+(365.2596358+0.0000000158*k)*k;
(*$else *)
  jde:=2451547.507+(365.2596358+0.0000000156*k)*k;
(*$endif *)
  a1:= 328.41 + 132.788585*k;
  a2:= 316.13 + 584.903153*k;
  a3:= 346.20 + 450.380738*k;
  a4:= 136.95 + 659.306737*k;
  a5:= 249.52 + 329.653368*k;
  if apo then
    corr:=-1.352*sin_d(a1)+0.061*sin_d(a2)+0.062*sin_d(a3)+0.029*sin_d(a4)+0.031*sin_d(a5)
  else
    corr:=+1.278*sin_d(a1)-0.055*sin_d(a2)-0.091*sin_d(a3)-0.056*sin_d(a4)-0.045*sin_d(a5);
  result:=delphi_date(jde+corr);

(*$ifndef low_accuracy *)
  repeat
    value:=(sun_distance(result)-sun_distance(result+epsilon));
    delta:=value-(sun_distance(result+delta_t)-sun_distance(result+delta_t+epsilon));
    if delta=0 then
      result:=result-delta_t/2
    else
      result:=result+delta_t*value/delta;
  until abs(value)<1e-14;
(*$endif *)
  end;
(*@\\\*)
(*@/// function nextperihel(date:TDateTime):TDateTime; *)
function nextperihel(date:TDateTime):TDateTime;
var
  temp_date: TDateTime;
begin
  temp_date:=date-366;
  result:=temp_date;
  while result<date do begin
    result:=nextXXXhel(temp_date,false);
    temp_date:=temp_date+365;
    end;
  end;
(*@\\\*)
(*@/// function nextaphel(date:TDateTime):TDateTime; *)
function nextaphel(date:TDateTime):TDateTime;
var
  temp_date: TDateTime;
begin
  temp_date:=date-366;
  result:=temp_date;
  while result<date do begin
    result:=nextXXXhel(temp_date,true);
    temp_date:=temp_date+365;
    end;
  end;
(*@\\\*)

{ Nodes }
(*@/// function NextMoonNode(const date:TDateTime; const rising:boolean):TDateTime; *)
{ Based upon Chapter 51 (49) of Meeus }

function NextMoonNode(const date:TDateTime; const rising:boolean):TDateTime;
var
  k,T,D,M,MS,omega,V,P,E: extended;
  t2,t3,t4: extended;
begin
  k:=floor((date-datetime_2000_01_01-28)*(13.4223/365.2425));
  if not rising then
    k:=k+0.5;
  repeat
    T :=k/1342.23;
    t2:=T*T;
    t3:=t2*T;
    t4:=t3*T;
    D:=183.6380+331.73735682*k+0.0014852  *t2
                              +0.00000209 *t3
                              -0.000000010*t4;
    M:= 17.4006+ 26.82037250*k+0.0001186 *t2
                              +0.00000006*t3;
    MS:=38.3776+355.52747313*k+0.0123499 *t2
                              +0.000014627*t3
                              -0.000000069*t4;
    omega:=123.9767-1.44098956*k+0.0020608*t2
                                +0.00000214*t3
                                -0.000000016*t4;
    V:=299.75+132.85*T-0.009173*T2;
    P:=omega+272.75-2.3*T;

  (* correction term due to excentricity of the earth orbit *)
    E:=GetEccentricityTerm(date);
    result:=delphi_date(2451565.1619
                        +27.212220817*k
                        +0.0002762  *t2
                        +0.000000021*t3
                        -0.000000000088*t4
                        -0.4721*sin_d(MS)
                        -0.1649*sin_d(2*D)
                        -0.0868*sin_d(2*D-MS)
                        +0.0084*sin_d(2*D+MS)
                        -0.0083*sin_d(2*D-M)   *e
                        -0.0039*sin_d(2*D-M-MS)*e
                        +0.0034*sin_d(2*MS)
                        -0.0031*sin_d(2*D-2*MS)
                        +0.0030*sin_d(2*D+M)   *e
                        +0.0028*sin_d(M-MS)    *e
                        +0.0026*sin_d(M)       *e
                        +0.0025*sin_d(4*D)
                        +0.0024*sin_d(D)
                        +0.0022*sin_d(M+MS)    *e
                        +0.0017*sin_d(omega)
                        +0.0014*sin_d(4*D-MS)
                        +0.0005*sin_d(2*D+M-MS)*e
                        +0.0004*sin_d(2*D-M+MS)*e
                        -0.0003*sin_d(2*D-2*M) *e
                        +0.0003*sin_d(4*D-M)   *e
                        +0.0003*sin_d(V)
                        +0.0003*sin_d(P)
                        );
     k:=k+1;
   until result>date;
   end;
(*@\\\0000002801*)

{ The seasons }
(*@/// function CalcSolarTerm_(year: integer; term: TSolarTerm; mean:boolean):TDateTime; *)
function CalcSolarTerm_(year: integer; term: TSolarTerm; mean:boolean):TDateTime;
(*@/// function dist(degree1,degree2:extended):extended; *)
function dist(degree1,degree2:extended):extended;
begin
  result:=put_in_360(degree2-degree1);
  if result>180 then
    result:=result-360;
  end;
(*@\\\*)
const
  epsilon = 3E-10;
var
  degree: extended;
  coord: T_coord;
  length: extended;
begin
  degree:=15*ord(term);
  result:=tropic_year/24*ord(term)+31+28+21;  (* approximate date of term *)
  if result>365 then
    result:=result+encodedate(year-1,1,1)
  else
    result:=result+encodedate(year,1,1);
  repeat
    if mean then
      length:=MeanSunRektaszension(result)
    else begin
      coord:=sun_coordinate(result);
      length:=coord.longitude;
      end;
    result:=result+58*sin_d(degree-length);
  until abs(dist(length,degree))<=epsilon;
  end;
(*@\\\0000001601*)
(*@/// function CalcSolarTerm(year: integer; term: TSolarTerm):TDateTime; *)
function CalcSolarTerm(year: integer; term: TSolarTerm):TDateTime;
begin
  result:=CalcSolarTerm_(year,term,false);
  end;
(*@\\\0000000301*)
(*@/// function StartSeason(year: integer; season:TSeason):TDateTime; *)
(*$ifndef low_accuracy *)
function StartSeason(year: integer; season:TSeason):TDateTime;
begin
  result:=0;  (* avoid warning only *)
  case season of
    spring: result:=CalcSolarTerm(year,st_z2);
    summer: result:=CalcSolarTerm(year,st_z5);
    autumn: result:=CalcSolarTerm(year,st_z8);
    winter: result:=CalcSolarTerm(year,st_z11);
    end;
  end;
(*$else *)

{ Based upon chapter 27 (26) of Meeus }

function StartSeason(year: integer; season:TSeason):TDateTime;
var
  y: extended;
  jde0: extended;
  t, w, dl, s: extended;
  i: integer;
const
  (*@/// a: array[0..23] of integer = (..); *)
  a: array[0..23] of integer = (
    485, 203, 199, 182, 156, 136, 77, 74, 70, 58, 52, 50,
    45, 44, 29, 18, 17, 16, 14, 12, 12, 12, 9, 8 );
  (*@\\\*)
  (*@/// bc:array[0..23,1..2] of extended = (..); *)
  bc:array[0..23,1..2] of extended = (
     ( 324.96,   1934.136 ),
     ( 337.23,  32964.467 ),
     ( 342.08,     20.186 ),
     (  27.85, 445267.112 ),
     (  73.14,  45036.886 ),
     ( 171.52,  22518.443 ),
     ( 222.54,  65928.934 ),
     ( 296.72,   3034.906 ),
     ( 243.58,   9037.513 ),
     ( 119.81,  33718.147 ),
     ( 297.17,    150.678 ),
     (  21.02,   2281.226 ),
     ( 247.54,  29929.562 ),
     ( 325.15,  31555.956 ),
     (  60.93,   4443.417 ),
     ( 155.12,  67555.328 ),
     ( 288.79,   4562.452 ),
     ( 198.04,  62894.029 ),
     ( 199.76,  31436.921 ),
     (  95.39,  14577.848 ),
     ( 287.11,  31931.756 ),
     ( 320.81,  34777.259 ),
     ( 227.73,   1222.114 ),
     (  15.45,  16859.074 )
                             );
  (*@\\\*)
begin
  case year of
    (*@/// -1000..+999: *)
    -1000..+999: begin
      y:=year/1000;
      case season of
        spring: jde0:=1721139.29189+(365242.13740+( 0.06134+( 0.00111-0.00071*y)*y)*y)*y;
        summer: jde0:=1721233.25401+(365241.72562+(-0.05323+( 0.00907+0.00025*y)*y)*y)*y;
        autumn: jde0:=1721325.70455+(365242.49558+(-0.11677+(-0.00297+0.00074*y)*y)*y)*y;
        winter: jde0:=1721414.39987+(365242.88257+(-0.00769+(-0.00933-0.00006*y)*y)*y)*y;
        else    jde0:=0;   (* this can't happen *)
        end;
      end;
    (*@\\\*)
    (*@/// +1000..+3000: *)
    +1000..+3000: begin
      y:=(year-2000)/1000;
      case season of
        spring: jde0:=2451623.80984+(365242.37404+( 0.05169+(-0.00411-0.00057*y)*y)*y)*y;
        summer: jde0:=2451716.56767+(365241.62603+( 0.00325+( 0.00888-0.00030*y)*y)*y)*y;
        autumn: jde0:=2451810.21715+(365242.01767+(-0.11575+( 0.00337+0.00078*y)*y)*y)*y;
        winter: jde0:=2451900.05952+(365242.74049+(-0.06223+(-0.00823+0.00032*y)*y)*y)*y;
        else    jde0:=0;   (* this can't happen *)
        end;
      end;
    (*@\\\*)
    else raise E_OutOfAlgorithmRange.Create('Out of range of the algorithm');
    end;
  t:=(jde0-juldat_2000_01_01+0.5)/36525;
  w:=35999.373*t-2.47;
  dl:=1+0.0334*cos_d(w)+0.0007*cos_d(2*w);
  (*@/// s := ä a cos(b+c*t) *)
  s:=0;
  for i:=0 to 23 do
    s:=s+a[i]*cos_d(bc[i,1]+bc[i,2]*t);
  (*@\\\*)
  result:=delphi_date(jde0+(0.00001*s)/dl);
  end;
(*$endif *)
(*@\\\0000001F21*)
(*@/// function StartMeanSeason(year: integer; season:TSeason):TDateTime; *)
function StartMeanSeason(year: integer; season:TSeason):TDateTime;
begin
  result:=0;  (* avoid warning only *)
  case season of
    spring: result:=CalcSolarTerm_(year,st_z2,true);
    summer: result:=CalcSolarTerm_(year,st_z5,true);
    autumn: result:=CalcSolarTerm_(year,st_z8,true);
    winter: result:=CalcSolarTerm_(year,st_z11,true);
    end;
  end;
(*@\\\0000000301*)
(*@/// function MajorSolarTerm(month: integer):TSolarTerm; *)
function MajorSolarTerm(month: integer):TSolarTerm;
var
  count: integer;
begin
  count:=(month-2)*2 + ord(st_z1);
  result:=TSolarTerm(count mod 24);
  end;
(*@\\\*)
(*@/// function MajorSolarTermAfter(date: TDateTime):TDateTime; *)
function MajorSolarTermAfter(date: TDateTime):TDateTime;
var
  y,m,d: word;
begin
  DecodeDateCorrect(date,y,m,d);
  repeat
    result:=CalcSolarTerm(y,MajorSolarTerm(m));
    inc(m);
    if m>12 then begin
      inc(y);
      m:=1;
      end;
  until result>=date;
  end;
(*@\\\*)
(*@/// function MajorSolarTermBefore(date: TDateTime):TDateTime; *)
function MajorSolarTermBefore(date: TDateTime):TDateTime;
var
  y,m,d: word;
begin
  DecodeDateCorrect(date,y,m,d);
  repeat
    result:=CalcSolarTerm(y,MajorSolarTerm(m));
    dec(m);
    if m<1 then begin
      dec(y);
      m:=12;
      end;
  until result<date;
  end;
(*@\\\*)

{ Rising and setting of moon and sun }
(*$ifdef meeus *)
(*@/// function Calc_Set_Rise(date:TDateTime; latitude, longitude:extended; *)
{ Based upon chapter 15 (14) of Meeus }

function Calc_Set_Rise(date:TDateTime; latitude, longitude:extended;
                       sun: boolean; kind: T_RiseSet):TDateTime;
var
  h: Extended;
  pos1, pos2, pos3: t_coord;
  h0, theta0, cos_h0, cap_h0: extended;
  m0,m1,m2, dm: extended;
(*@/// procedure correct_position(var position:t_coord; date:TDateTime; ...); *)
procedure correct_position(var position:t_coord; date:TDateTime;
                           latitude,longitude,height:extended);
begin
  ParallaxCorrection(
    position.rektaszension,position.declination,moon_distance(date)/AU,
    date,latitude,longitude,height);
  end;
(*@\\\*)
(*@/// function interpolation(y1,y2,y3,n: extended):extended; *)
function interpolation(y1,y2,y3,n: extended):extended;
var
  a,b,c: extended;
begin
  a:=y2-y1;
  b:=y3-y2;
  if a>100 then  a:=a-360;
  if a<-100 then  a:=a+360;
  if b>100 then  b:=b-360;
  if b<-100 then  b:=b+360;
  c:=b-a;
  result:=y2+0.5*n*(a+b+n*c);
  end;
(*@\\\*)
(*@/// function correction(m:extended; kind:integer):extended; *)
function correction(m:extended; kind:integer):extended;
var
  alpha,delta,h, height: extended;
begin
  alpha:=interpolation(pos1.rektaszension,
                       pos2.rektaszension,
                       pos3.rektaszension,
                       m);
  delta:=interpolation(pos1.declination,
                       pos2.declination,
                       pos3.declination,
                       m);
  h:=put_in_360((theta0+360.985647*m)-longitude-alpha);
  if h>180 then h:=h-360;

  height:=arcsin_d(sin_d(latitude)*sin_d(delta)
                   +cos_d(latitude)*cos_d(delta)*cos_d(h));  { Meeus 13.6 }

  case kind of
    0:   result:=-h/360;
    1,2: result:=(height-h0)/(360*cos_d(delta)*cos_d(latitude)*sin_d(h));
    else result:=0;   (* this cannot happen *)
    end;
  end;
(*@\\\*)
const
  sun_diameter = 0.8333;
  civil_twilight_elevation = -6.0;
  nautical_twilight_elevation = -12.0;
  astronomical_twilight_elevation = -18.0;
begin
  case kind of
    _rise, _set: begin
      if sun then
        h0:=-sun_diameter
      else
        h0:=0.7275*parallax(moon_distance(date)/AU)-34/60;
      end;
    _rise_civil,
    _set_civil:   h0:=civil_twilight_elevation;
    _rise_nautical,
    _set_nautical: h0:=nautical_twilight_elevation;
    _rise_astro,
    _set_astro:   h0:=astronomical_twilight_elevation;
    else          h0:=0;  (* don't care for _transit *)
    end;

  h:=int(date);
  theta0:=star_time(h);
  if sun then begin
    pos1:=sun_coordinate(h-1);
    pos2:=sun_coordinate(h);
    pos3:=sun_coordinate(h+1);
    end
  else begin
    pos1:=moon_coordinate(h-1);
    pos2:=moon_coordinate(h);
    pos3:=moon_coordinate(h+1);
    end;

  cos_h0:=(sin_d(h0)-sin_d(latitude)*sin_d(pos2.declination))/
          (cos_d(latitude)*cos_d(pos2.declination));
  if (cos_h0<-1) or (cos_h0>1) then
    raise E_NoRiseSet.Create('No rises or sets calculable');
  cap_h0:=arccos_d(cos_h0);

  m0:=(pos2.rektaszension+longitude-theta0)/360;
  m1:=m0-cap_h0/360;
  m2:=m0+cap_h0/360;

  m0:=frac(m0);
  if m0<0 then m0:=m0+1;
  m1:=frac(m1);
  if m1<0 then m1:=m1+1;
  m2:=frac(m2);
  if m2<0 then m2:=m2+1;

  repeat
    dm:=correction(m0,0);
    m0:=m0+dm;
  until abs(dm)<1/60/24/10;
  repeat
    dm:=correction(m1,1);
    m1:=m1+dm;
  until abs(dm)<1/60/24/10;
  repeat
    dm:=correction(m2,2);
    m2:=m2+dm;
  until abs(dm)<1/60/24/10;

  case kind of
    _rise,
    _rise_civil,
    _rise_nautical,
    _rise_astro:    result:=h+m1;
    _set,
    _set_civil,
    _set_nautical,
    _set_astro:     result:=h+m2;
    _transit: result:=h+m0;
    else      result:=0;    (* this can't happen *)
    end;

  end;
(*@\\\0000001701*)
(*$else *)
(*@/// function Calc_Set_Rise(date:TDateTime; latitude, longitude:extended; *)
{ Based upon chapter 3 of Montenbruck }

function Calc_Set_Rise(date:TDateTime; latitude, longitude:extended;
                       sun: boolean; kind: T_RiseSet):TDateTime;
type
  (*@/// TParabelInfo=record..end; *)
  TParabelInfo=record
    x_extrem, y_extrem: extended;
    extrem_high: boolean;
    number_root: integer;
    root: array[0..1] of extended;
    end;
  (*@\\\0000000403*)
var
  basedatetime: TDateTime;
  h0: extended;
  pos1, pos2, pos3: extended;
const
  sun_diameter = 0.8333;
  civil_twilight_elevation = -6.0;
  nautical_twilight_elevation = -12.0;
  astronomical_twilight_elevation = -18.0;
(*@/// procedure correct_position(var position:t_coord; date:TDateTime; ...); *)
procedure correct_position(var position:t_coord; date:TDateTime;
                           latitude,longitude,height:extended);
begin
  ParallaxCorrection(
    position.rektaszension,position.declination,moon_distance(date)/AU,
    date,latitude,longitude,height);
  end;
(*@\\\*)
(*@/// function calc(dt: TDateTime):extended; *)
function calc(dt: TDateTime):extended;
var
  elevation,azimuth: extended;
  p: t_coord;
begin
  if sun then
    p:=sun_coordinate(dt)
  else
    p:=moon_coordinate(dt);
  EquatorialToHorizontal(dt,p.rektaszension,p.declination,
    latitude,longitude,elevation,azimuth);
  result:=sin_d(elevation)-sin_d(h0);
//  result:=elevation-h0;
  end;
(*@\\\*)
(*@/// function QuadInterpol(ym,y0,yp: extended):TParabelInfo; *)
function QuadInterpol(ym,y0,yp: extended):TParabelInfo;
var
  a,b,c,d,r: extended;
begin
  a:=0.5*(yp+ym)-y0;
  b:=0.5*(yp-ym);
  c:=y0;
  result.x_extrem:=-b/(2*a);
  result.y_extrem:=(a*result.x_extrem+b)*result.x_extrem+c;
  result.extrem_high:=(a<0);
  d:=b*b-4*a*c;
  result.number_root:=0;
  if d>=0 then begin
    d:=0.5*sqrt(d)/abs(a);
    r:=result.x_extrem-d;
    if abs(r)<=1 then begin
      result.root[result.number_root]:=r;
      inc(result.number_root);
      end;
    r:=result.x_extrem+d;
    if (abs(r)<=1) and (d<>0) then begin
      result.root[result.number_root]:=r;
      inc(result.number_root);
      end;
    end;
  end;
(*@\\\*)
(*@/// function FindTransit(v:TParabelInfo; hour: integer; var dt:TDateTime):boolean; *)
function FindTransit(v:TParabelInfo; hour: integer; var dt:TDateTime):boolean;
begin
  result:=(abs(v.x_extrem)<=1) and (v.extrem_high);
  if result then
    dt:=basedatetime+hour/24+v.x_extrem/24;
  end;
(*@\\\0000000310*)
(*@/// function FindRise(v:TParabelInfo; hour: integer; var dt:TDateTime):boolean; *)
function FindRise(v:TParabelInfo; hour: integer; var dt:TDateTime):boolean;
var
  root: extended;
begin
  root:=0;
  if v.number_root=0 then
    result:=false
  else if v.number_root=1 then begin
    result:=(pos1<0);
    root:=v.root[0];
    end
  else begin
    result:=true;
    if v.y_extrem<0 then
      root:=v.root[1]
    else
      root:=v.root[0];
    end;
  if result then
    dt:=basedatetime+(hour+root)/24;
  end;
(*@\\\0000000501*)
(*@/// function FindSet(v:TParabelInfo; hour: integer; var dt:TDateTime):boolean; *)
function FindSet(v:TParabelInfo; hour: integer; var dt:TDateTime):boolean;
var
  root: extended;
begin
  root:=0;
  if v.number_root=0 then
    result:=false
  else if v.number_root=1 then begin
    result:=(pos1>0);
    root:=v.root[0];
    end
  else begin
    result:=true;
    if v.y_extrem>0 then
      root:=v.root[1]
    else
      root:=v.root[0];
    end;
  if result then
    dt:=basedatetime+(hour+root)/24;
  end;
(*@\\\0000000601*)
var
  v: TParabelInfo;
  i: integer;
begin
  case kind of
    _rise, _set: begin
      if sun then
        h0:=-sun_diameter
      else
        h0:=0.7275*parallax(moon_distance(date)/AU)-34/60;
      end;
    _rise_civil,
    _set_civil:   h0:=civil_twilight_elevation;
    _rise_nautical,
    _set_nautical: h0:=nautical_twilight_elevation;
    _rise_astro,
    _set_astro:   h0:=astronomical_twilight_elevation;
    else          h0:=0;  (* don't care for _transit *)
    end;

{   basedatetime:=int(date); }
  basedatetime:=date;
  pos3:=calc(basedatetime-1/24);
  for i:=0 to 12-1 do begin
    pos1:=pos3;
    pos2:=calc(basedatetime+i/12);
    pos3:=calc(basedatetime+i/12+1/24);
    v:=QuadInterpol(pos1,pos2,pos3);
    case kind of
      _rise,_rise_civil,_rise_nautical,_rise_astro:
        if FindRise(v,i*2,result) then  BREAK;
      _set,_set_civil,_set_nautical,_set_astro:
        if FindSet(v,i*2,result) then  BREAK;
      _transit:
        if FindTransit(v,i*2,result) then  BREAK;
      else      result:=0;    (* this can't happen *)
      end;
    end;
  end;
(*@\\\0000001501*)
(*$endif *)

(*@/// function Sun_Rise(date:TDateTime; latitude, longitude:extended):TDateTime; *)
function Sun_Rise(date:TDateTime; latitude, longitude:extended):TDateTime;
begin
  result:=Calc_Set_Rise(date,latitude,longitude,true,_rise);
  end;
(*@\\\*)
(*@/// function Sun_Set(date:TDateTime; latitude, longitude:extended):TDateTime; *)
function Sun_Set(date:TDateTime; latitude, longitude:extended):TDateTime;
begin
  result:=Calc_Set_Rise(date,latitude,longitude,true,_set);
  end;
(*@\\\*)
(*@/// function Sun_Transit(date:TDateTime; latitude, longitude:extended):TDateTime; *)
function Sun_Transit(date:TDateTime; latitude, longitude:extended):TDateTime;
begin
  result:=Calc_Set_Rise(date,latitude,longitude,true,_transit);
  end;
(*@\\\*)
(*@/// function Moon_Rise(date:TDateTime; latitude, longitude:extended):TDateTime; *)
function Moon_Rise(date:TDateTime; latitude, longitude:extended):TDateTime;
begin
  result:=Calc_Set_Rise(date,latitude,longitude,false,_rise);
  end;
(*@\\\*)
(*@/// function Moon_Set(date:TDateTime; latitude, longitude:extended):TDateTime; *)
function Moon_Set(date:TDateTime; latitude, longitude:extended):TDateTime;
begin
  result:=Calc_Set_Rise(date,latitude,longitude,false,_set);
  end;
(*@\\\*)
(*@/// function Moon_Transit(date:TDateTime; latitude, longitude:extended):TDateTime; *)
function Moon_Transit(date:TDateTime; latitude, longitude:extended):TDateTime;
begin
  result:=Calc_Set_Rise(date,latitude,longitude,false,_transit);
  end;
(*@\\\*)

(*@/// function Morning_Twilight_Civil(date:TDateTime; latitude, longitude:extended):TDateTime; *)
function Morning_Twilight_Civil(date:TDateTime; latitude, longitude:extended):TDateTime;
begin
  result:=Calc_Set_Rise(date,latitude,longitude,true,_rise_civil);
  end;
(*@\\\*)
(*@/// function Evening_Twilight_Civil(date:TDateTime; latitude, longitude:extended):TDateTime; *)
function Evening_Twilight_Civil(date:TDateTime; latitude, longitude:extended):TDateTime;
begin
  result:=Calc_Set_Rise(date,latitude,longitude,true,_set_civil);
  end;
(*@\\\*)
(*@/// function Morning_Twilight_Nautical(date:TDateTime; latitude, longitude:extended):TDateTime; *)
function Morning_Twilight_Nautical(date:TDateTime; latitude, longitude:extended):TDateTime;
begin
  result:=Calc_Set_Rise(date,latitude,longitude,true,_rise_nautical);
  end;
(*@\\\*)
(*@/// function Evening_Twilight_Nautical(date:TDateTime; latitude, longitude:extended):TDateTime; *)
function Evening_Twilight_Nautical(date:TDateTime; latitude, longitude:extended):TDateTime;
begin
  result:=Calc_Set_Rise(date,latitude,longitude,true,_set_nautical);
  end;
(*@\\\*)
(*@/// function Morning_Twilight_Astronomical(date:TDateTime; latitude, longitude:extended):TDateTime; *)
function Morning_Twilight_Astronomical(date:TDateTime; latitude, longitude:extended):TDateTime;
begin
  result:=Calc_Set_Rise(date,latitude,longitude,true,_rise_astro);
  end;
(*@\\\*)
(*@/// function Evening_Twilight_Astronomical(date:TDateTime; latitude, longitude:extended):TDateTime; *)
function Evening_Twilight_Astronomical(date:TDateTime; latitude, longitude:extended):TDateTime;
begin
  result:=Calc_Set_Rise(date,latitude,longitude,true,_set_astro);
  end;
(*@\\\*)

{ Checking for eclipses }
(*@/// function Eclipse(var date:TDateTime; sun:boolean):TEclipse; *)
function Eclipse(var date:TDateTime; sun:boolean):TEclipse;
var
  jde,kk,m,ms,f,o,e: extended;
  t,f1,a1: extended;
  p,q,w,gamma,u: extended;
begin
  if sun then
    calc_phase_data(date,NewMoon,jde,kk,m,ms,f,o,e)
  else
    calc_phase_data(date,FullMoon,jde,kk,m,ms,f,o,e);
  t:=kk/1236.85;
  if abs(sin_d(f))>0.36 then
    result:=none
  (*@/// else *)
  else begin
    f1:=f-0.02665*sin_d(o);
    a1:=299.77+0.107408*kk-0.009173*t*t;
    if sun then
      jde:=jde - 0.4075     * sin_d(ms)
               + 0.1721 * e * sin_d(m)
    else
      jde:=jde - 0.4065     * sin_d(ms)
               + 0.1727 * e * sin_d(m);
    jde:=jde   + 0.0161     * sin_d(2*ms)
               - 0.0097     * sin_d(2*f1)
               + 0.0073 * e * sin_d(ms-m)
               - 0.0050 * e * sin_d(ms+m)
               - 0.0023     * sin_d(ms-2*f1)
               + 0.0021 * e * sin_d(2*m)
               + 0.0012     * sin_d(ms+2*f1)
               + 0.0006 * e * sin_d(2*ms+m)
               - 0.0004     * sin_d(3*ms)
               - 0.0003 * e * sin_d(m+2*f1)
               + 0.0003     * sin_d(a1)
               - 0.0002 * e * sin_d(m-2*f1)
               - 0.0002 * e * sin_d(2*ms-m)
               - 0.0002     * sin_d(o);
    p:=        + 0.2070 * e * sin_d(m)
               + 0.0024 * e * sin_d(2*m)
               - 0.0392     * sin_d(ms)
               + 0.0116     * sin_d(2*ms)
               - 0.0073 * e * sin_d(ms+m)
               + 0.0067 * e * sin_d(ms-m)
               + 0.0118     * sin_d(2*f1);
    q:=        + 5.2207
               - 0.0048 * e * cos_d(m)
               + 0.0020 * e * cos_d(2*m)
               - 0.3299     * cos_d(ms)
               - 0.0060 * e * cos_d(ms+m)
               + 0.0041 * e * cos_d(ms-m);
    w:=abs(cos_d(f1));
    gamma:=(p*cos_d(f1)+q*sin_d(f1))*(1-0.0048*w);
    u:= + 0.0059
        + 0.0046 * e * cos_d(m)
        - 0.0182     * cos_d(ms)
        + 0.0004     * cos_d(2*ms)
        - 0.0005     * cos_d(m+ms);
    (*@/// if sun then *)
    if sun then begin
      if abs(gamma)<0.9972 then begin
        if u<0 then
          result:=total
        else if u>0.0047 then
          result:=circular
        else if u<0.00464*sqrt(1-gamma*gamma) then
          result:=circulartotal
        else
          result:=circular;
        end
      else if abs(gamma)>1.5433+u then
        result:=none
      else if abs(gamma)<0.9972+abs(u) then
        result:=noncentral
      else
        result:=partial;
      end
    (*@\\\0000000303*)
    (*@/// else *)
    else begin
      if (1.0128 - u - abs(gamma)) / 0.5450 > 0 then
        result:=total
      else if (1.5573 + u - abs(gamma)) / 0.5450 > 0 then
        result:=halfshadow
      else
        result:=none;
      end;
    (*@\\\*)
    end;
  (*@\\\0000002C01*)
  date:=delphi_date(jde);
  end;
(*@\\\0000000E01*)
(*@/// function NextEclipse(var date:TDateTime; sun:boolean):TEclipse; *)
function NextEclipse(var date:TDateTime; sun:boolean):TEclipse;
var
  temp_date: TDateTime;
begin
  result:=none;    (* just to make Delphi 2/3 shut up, not needed really *)
  temp_date:=date-28*2;
  while (temp_date<date) or (result=none) do begin
    temp_date:=temp_date+14;
    result:=Eclipse(temp_date,sun);
    end;
  date:=temp_date;
  end;
(*@\\\*)
(*@/// function NextEclipseEx(date:TDateTime; sun:boolean):TEclipseData; *)
function NextEclipseEx(date:TDateTime; sun:boolean):TEclipseData;
const
  max_index=200;
  delta_min = 1;
var
  delta: TdateTime;
  i,j: integer;
  found: boolean;
  e: TEclipse;
begin
  result.date:=date;
  result.eclipsetype:=NextEclipse(result.date,sun);
  if sun then begin
    delta:=result.date-datetime_suneclipse_base;
    result.saros:=suneclipse_base_saros;
    result.inex :=suneclipse_base_inex;
    end
  else begin
    delta:=result.date-datetime_mooneclipse_base;
    result.saros:=mooneclipse_base_saros;
    result.inex :=mooneclipse_base_inex;
    end;
  i:=0; found:=false;
  while (not found) and (i<=max_index) do begin
    j:=0;
    while (not found) and (j<=max_index) do begin
      if false then
      else if abs(delta+inex_cycle*i+saros_cycle*j)<delta_min then begin
        result.saros:=result.saros+i;
        result.inex :=result.inex +j;
        found:=true;
        end
      else if abs(delta-inex_cycle*i+saros_cycle*j)<delta_min then begin
        result.saros:=result.saros+i;
        result.inex :=result.inex -j;
        found:=true;
        end
      else if abs(delta+inex_cycle*i-saros_cycle*j)<delta_min then begin
        result.saros:=result.saros-i;
        result.inex :=result.inex +j;
        found:=true;
        end
      else if abs(delta-inex_cycle*i-saros_cycle*j)<delta_min then begin
        result.saros:=result.saros-i;
        result.inex :=result.inex -j;
        found:=true;
        end;
      inc(j);
      end;
    inc(i);
    end;
  result.sarosnumber:=0;
  repeat
    inc(result.sarosnumber);
    delta:=result.date-result.sarosnumber*saros_cycle;
    e:=Eclipse(delta,sun)
  until (e=none);
  end;
(*@\\\0000003701*)

{ Horizontal positions }
(*@/// procedure Moon_Position_Horizontal(date:TdateTime; refraction:boolean; latitude,longitude: extended; ...); *)
procedure Moon_Position_Horizontal(date:TdateTime; refraction:boolean; latitude,longitude: extended;
                                   var elevation,azimuth: extended);
var
  pos1: T_Coord;
begin
  pos1:=moon_coordinate(date);
  EquatorialToHorizontal(date,pos1.rektaszension,pos1.declination,
    latitude,longitude,elevation,azimuth);
  if refraction then
    elevation:=Elevation_Real_to_Apparent(elevation,standard_temperature,standard_pressure);
  end;
(*@\\\0000000701*)
(*@/// procedure Sun_Position_Horizontal(date:TdateTime; refraction:boolean; latitude,longitude: extended; ...); *)
procedure Sun_Position_Horizontal(date:TdateTime; refraction:boolean; latitude,longitude: extended;
                                  var elevation,azimuth: extended);
var
  pos1: T_Coord;
begin
  pos1:=sun_coordinate(date);
  EquatorialToHorizontal(date,pos1.rektaszension,pos1.declination,
    latitude,longitude,elevation,azimuth);
  if refraction then
    elevation:=Elevation_Real_to_Apparent(elevation,standard_temperature,standard_pressure);
  end;
(*@\\\0000000901*)

(*@/// function Elevation_Real_to_Apparent(elevation:extended; temperature,airpressure:extended):extended; *)
{ Based upon chapter 16 (15) of Meeus }

function Elevation_Real_to_Apparent(elevation:extended; temperature,airpressure:extended):extended;
var
  r: extended;
begin
  r:=1.02/tan_d(elevation+10.3/(elevation+5.11))/60+0.0019279/60;
  r:=r*(temperature/standard_temperature)*(airpressure/standard_pressure);
  if elevation+r>=0 then
    result:=elevation+r
  else
    result:=elevation;
  end;
(*@\\\000000070B*)
(*@/// function Elevation_Apparent_to_Real(elevation:extended; temperature,airpressure:extended):extended; *)
{ Based upon chapter 16 (15) of Meeus }

function Elevation_Apparent_to_Real(elevation:extended; temperature,airpressure:extended):extended;
var
  r: extended;
begin
  if elevation<0 then
    result:=elevation
  else begin
    r:=1.0/tan_d(elevation+7.31/(elevation+4.4))/60+0.0013515/60;
    r:=r*(temperature/standard_temperature)*(airpressure/standard_pressure);
    result:=elevation+r;
    end;
  end;
(*@\\\0000000A11*)

{ Chinese calendar }
(*@/// function UTCtoChina(date: TdateTime):TDateTime; *)
function UTCtoChina(date: TdateTime):TDateTime;
var
  y,m,d: word;
begin
  decodedatecorrect(date,y,m,d);
  if y<1929 then
    result:=date-beijing_longitude/360
  else
    result:=date+120/360;
  end;
(*@\\\0000000A01*)
(*@/// function ChinaToUTC(date: TdateTime):TDateTime; *)
function ChinaToUTC(date: TdateTime):TDateTime;
var
  y,m,d: word;
begin
  decodedatecorrect(date,y,m,d);
  if y<1929 then
    result:=date+beijing_longitude/360
  else
    result:=date-120/360;
  end;
(*@\\\*)
(*@/// function ChinaNewMoonBefore(date:TDateTime):TdateTime; *)
function ChinaNewMoonBefore(date:TDateTime):TdateTime;
begin
  result:=Floor(UTCtoChina(last_phase(ChinaToUTC(date),Newmoon)));
  end;
(*@\\\000000030B*)
(*@/// function ChinaNewMoonAfter(date:TDateTime):TdateTime; *)
function ChinaNewMoonAfter(date:TDateTime):TdateTime;
begin
  result:=Floor(UTCtoChina(next_phase(ChinaToUTC(date),Newmoon)));
  end;
(*@\\\0000000310*)
(*@/// function ChinaSolarTermAfter(date:TDateTime):TdateTime; *)
function ChinaSolarTermAfter(date:TDateTime):TdateTime;
begin
  result:=Floor(UTCtoChina(MajorSolarTermAfter(ChinaToUTC(date))));
  end;
(*@\\\0000000310*)
(*@/// function ChinaSolarTermBefore(date:TDateTime):TdateTime; *)
function ChinaSolarTermBefore(date:TDateTime):TdateTime;
begin
  result:=Floor(UTCtoChina(MajorSolarTermBefore(ChinaToUTC(date))));
  end;
(*@\\\0000000310*)
(*@/// function hasnomajorsolarterm(date:TDateTime):boolean; *)
function hasnomajorsolarterm(date:TDateTime):boolean;
var
  term_before_date,
  term_before_next_month,
  next_month: TDateTime;
begin
  term_before_date:=ChinaSolarTermBefore(date);
  next_month:=ChinaNewMoonAfter(date+2);
  term_before_next_month:=ChinaSolarTermBefore(next_month);
  result:=term_before_date=term_before_next_month;
  end;
(*@\\\*)
(*@/// function haspriorleapmonth(date1,date2: TdateTime):boolean; *)
function haspriorleapmonth(date1,date2: TdateTime):boolean;
{ Recursive }
begin
  if (date2>date1) then
    result:=haspriorleapmonth(date1,ChinaNewMoonBefore(date2-1))
  else
    result:=false;
  if not result then
    result:=hasnomajorsolarterm(date2);
  end;
(*@\\\*)

(*@/// function ChineseDate(date: TdateTime): TChineseDate; *)
function ChineseDate(date: TdateTime): TChineseDate;
var
  s1,s2,s3: TDateTime;
  m0,m1,m2: TdateTime;
  y,m,d: word;
  daycycle, monthcycle: integer;
begin
  Decodedatecorrect(date,y,m,d);
  date:=trunc(date);
  (* Winter solstices (Z12) around the date *)
  s1:=ChinaSolarTermAfter(encodedatecorrect(y-1,12,15));
  s2:=ChinaSolarTermAfter(encodedatecorrect(y  ,12,15));
  s3:=ChinaSolarTermAfter(encodedatecorrect(y+1,12,15));
  (* Start of Months around winter solstices *)
  if (s1<=date) and (date<s2) then begin
    m1:=ChinaNewMoonAfter(s1+1);
    m2:=ChinaNewMoonBefore(s2+1);
    end
  else begin
    m1:=ChinaNewMoonAfter(s2+1);
    m2:=ChinaNewMoonBefore(s3+1);
    end;
  (* Start of current month *)
  m0:=ChinaNewMoonBefore(date+1);
  result.leapyear:=round((m2-m1)/mean_lunation)=12;
  result.month:=round((m0-m1)/mean_lunation);
  result.leap:=result.leapyear and hasnomajorsolarterm(m0) and
               (not haspriorleapmonth(m1,ChinaNewMoonBefore(m0)));
  if result.leapyear and (haspriorleapmonth(m1,m0) or result.leap) then
    result.month:=result.month-1;
  result.month:=adjusted_mod(result.month,12);
  result.day:=round(date-m0+1);
  result.epoch_years:=y+2636;
  if (result.month<11) or (date>EncodedateCorrect(y,7,1)) then
    inc(result.epoch_years);
  result.cycle:=((result.epoch_years-1) div 60)+1;
  result.year:=adjusted_mod(result.epoch_years,60);
  result.yearcycle.zodiac:=TChineseZodiac((result.year-1) mod 12);
  result.yearcycle.stem:=TChineseStem((result.year-1) mod 10);
  (* 2000-1-7 = daycycle jia-zi *)
  daycycle:=adjusted_mod(round(trunc(date)-datetime_2000_01_01-6),60);
  result.daycycle.zodiac:=TChineseZodiac(daycycle mod 12);
  result.daycycle.stem:=TChineseStem(daycycle mod 10);
  (* 1998-12-19 = monthcycle jia-zi *)
  monthcycle:=adjusted_mod(1+round((m0-datetime_1999_01_01-13)/mean_lunation),60);
  result.monthcycle.zodiac:=TChineseZodiac(monthcycle mod 12);
  result.monthcycle.stem:=TChineseStem(monthcycle mod 10);
  end;
(*@\\\0000003001*)
(*@/// function EncodeDateChinese(date:TChineseDate):TDateTime; *)
function EncodeDateChinese(date:TChineseDate):TDateTime;
var
  y: integer;
  newyear, month_begin: TdateTime;
  chinese: TChineseDate;
begin
  y:=60*(date.cycle-1)+(date.year-1)-2636;
  newyear:=ChineseNewYear(y);
  month_begin:=ChinaNewMoonAfter(newyear+29*(date.month-1));
  chinese:=ChineseDate(month_begin);
  if (chinese.month=date.month) and (chinese.leap=date.leap) then
    result:=month_begin+date.day-1
  else
    result:=ChinaNewMoonAfter(month_begin+5)+date.day-1;
  (* check if the input date was valid *)
  chinese:=ChineseDate(result);
  if (chinese.day<>date.day) or (chinese.month<>date.month) or
     (chinese.leap<>date.leap) or (chinese.year<>date.year) or
     (chinese.cycle<>date.cycle) then
    raise EConvertError.Create('Invalid chinese date');
  end;
(*@\\\*)
(*@/// function ChineseNewYear(year: integer): TDateTime; *)
function ChineseNewYear(year: integer): TDateTime;
var
  s1,s2: TDateTime;
  m1,m2,m11: TdateTime;
begin
  (* Winter solstices (Z12) around the January 1st of the year *)
  s1:=ChinaSolarTermAfter(encodedatecorrect(year-1,12,15));
  s2:=ChinaSolarTermAfter(encodedatecorrect(year  ,12,15));
  m1:=ChinaNewMoonAfter(s1+1);
  m2:=ChinaNewMoonAfter(m1+4);
  m11:=ChinaNewMoonBefore(s2+1);
  if (round((m11-m1)/mean_lunation)=12) and
     (hasnomajorsolarterm(m1) or hasnomajorsolarterm(m2)) then
    result:=ChinaNewMoonAfter(m2+1)
  else
    result:=m2;
  end;
(*@\\\*)
(*@\\\000C00530100532E005301*)
(*@/// initialization *)
(*$ifdef delphi_1 *)
begin
(*$else *)
initialization
(*$endif *)
  julian_offset:=2451544.5-EncodeDate(2000,1,1);
  datetime_2000_01_01:=EncodedateCorrect(2000,1,1);
  datetime_1999_01_01:=EncodedateCorrect(1999,1,1);
  datetime_first_lunation:=EncodeDate(1923,1,17);
  datetime_suneclipse_base:=EncodedateCorrect(1999,8,11)+0.46;
  datetime_mooneclipse_base:=EncodedateCorrect(1999,7,28)+0.48;
  datetime_earliest_next_leapsecond:=EncodeDate(2002,12,31);
  check_TDatetime;
(*@\\\0000000B01*)
(*$ifdef delphi_ge_2 *) (*$warnings off *) (*$endif *)
end.
(*@\\\0001000011*)
