unit MoonTest;
(*$define planets *)
(*@/// interface *)
interface

(*@/// uses *)
uses
  moon,
  moon_aux,
(*$ifdef planets *)
  vsop,
  planets,
(*$endif *)
  ah_math,
  sysutils,
  TestFramework,
  TestExtensions
  ;
(*@\\\000000030C*)

type
  (*@/// TCalendarTestCase = class(TTestCase) *)
  TCalendarTestCase = class(TTestCase)
  published
    procedure TestJulianDate;
    procedure TestEasterDate;
    procedure TestEasterDateJulian;
    procedure TestWeekNumber;
    end;
  (*@\\\0000000601*)
  (*@/// TJewishTestCase = class(TTestcase) *)
  TJewishTestCase = class(TTestcase)
  published
    procedure TestEncodeDateJewish;
    procedure TestPesachEasterCoincide;
    end;
  (*@\\\0000000201*)
  (*@/// TChineseTestCase = class(TTestcase) *)
  TChineseTestCase = class(TTestcase)
  published
    procedure TestChineseNewYear;
    procedure TestLeapMonths;
    end;
  (*@\\\0000000401*)
  (*@/// TMoonTestCase = class(TTestcase) *)
  TMoonTestCase = class(TTestcase)
  published
    procedure TestApogee;
    procedure TestPosition;
    procedure TestPhases;
    procedure TestNodes;
    procedure TestBlueMoon;
    procedure TestBlueMoonMaine;
    procedure TestPhysicalEphemerides;
    procedure TestPhaseAngle;
    end;
  (*@\\\0000000A0D*)
  (*@/// TSunTestCase = class(TTestcase) *)
  TSunTestCase = class(TTestcase)
  published
    procedure TestMarchEquinox;
    procedure TestSeptemberEquinox;
    procedure TestJuneSolstice;
    procedure TestDecemberSolstice;
    procedure TestAphelion;
    procedure TestPerihelion;
    procedure TestSunCoordinate;
    end;
  (*@\\\0000000A01*)
  (*@/// TMiscAlgorithmTestCase = class(TTestcase) *)
  TMiscAlgorithmTestCase = class(TTestcase)
  published
    procedure TestDistanceOnEarth;
    procedure TestStarTime;
    procedure TestDynamicTimeOffset;
    procedure TestRefraction;
    procedure TestEquationOfTime;
    procedure TestCoordinateTransformation;
    procedure TestNutation;
    procedure TestEclipse;
    procedure TestEpochConversion;
    procedure TestParallaxCorrection;
    end;
  (*@\\\0000000B01*)
(*$ifdef planets *)
  (*@/// TPlanetTestCase = class(TTestcase) *)
  TPlanetTestCase = class(TTestcase)
  published
    procedure TestVenus;
    procedure TestSaturn;
    procedure TestPluto;
    end;
  (*@\\\0000000401*)
(*$endif *)
(*@\\\0000000601*)
(*@/// implementation *)
implementation

{ TCalendarTestCase }

(*@/// procedure TCalendarTestCase.TestJulianDate; *)
(* Examples in chapter 7 of Meeus *)
procedure TCalendarTestCase.TestJulianDate;
type
  (*@/// JulianDateExample = record ... end; *)
  JulianDateExample = record
    year: integer;
    month: integer;
    day: extended;
    juldat: extended;
    end;
  (*@\\\0000000601*)
const
  ExampleJulianDates: array[0..11] of JulianDateExample = (
    ( year: 2000; month:  1; day:  1.5; juldat: 2451545.0),
    ( year: 1999; month:  1; day:  1.0; juldat: 2451179.5),
    ( year: 1987; month:  1; day: 27.0; juldat: 2446822.5),
    ( year: 1987; month:  6; day: 19.5; juldat: 2446966.0),
    ( year: 1988; month:  1; day: 27.0; juldat: 2447187.5),
    ( year: 1988; month:  6; day: 19.5; juldat: 2447332.0),
    ( year: 1900; month:  1; day:  1.0; juldat: 2415020.5),
    ( year: 1600; month:  1; day:  1.0; juldat: 2305447.5),
    ( year: 1600; month: 12; day: 31.0; juldat: 2305812.5),
    ( year:  837; month:  4; day: 10.3; juldat: 2026871.8),
{     ( year: -123; month: 12; day: 31.0; juldat: 1676496.5), }
{     ( year: -122; month:  1; day:  1.0; juldat: 1676497.5), }
{     ( year:-1000; month:  7; day: 12.5; juldat: 1356001.0), }
{     ( year:-1000; month:  2; day: 29.0; juldat: 1355866.5), }
{     ( year:-1001; month:  8; day: 17.9; juldat: 1355671.4), }
{     ( year:-4712; month:  1; day:  1.5; juldat:       0.0), }
    ( year: 1957; month: 10; day:  4.8; juldat: 2436116.3),  (* Example 7.a *)
    ( year:  333; month:  1; day: 27.5; juldat: 1842713.0)   (* Example 7.b *)
   );
var
  i: integer;
  y,m,d: word;
  juldat: extended;
begin
  for i:=low(ExampleJulianDates) to high(ExampleJulianDates) do begin
    juldat:=Calc_Julian_date(ExampleJulianDates[i].year,
      ExampleJulianDates[i].month,trunc(ExampleJulianDates[i].day)) +
      frac(ExampleJulianDates[i].day);
    Check( abs(juldat - ExampleJulianDates[i].juldat)<0.1,
      'Failed julian date from '+inttostr(ExampleJulianDates[i].year)+'-'+
                          inttostr(ExampleJulianDates[i].month)+'-'+
                          floattostr(ExampleJulianDates[i].day) );
    Calc_Calendar_date(ExampleJulianDates[i].juldat,y,m,d);
    Check( (d = trunc(ExampleJulianDates[i].day) ) and
           (m = ExampleJulianDates[i].month ) and
           (y = ExampleJulianDates[i].year ),
      'Failed calendar date from '+floattostr(ExampleJulianDates[i].juldat));
    end;
  end;
(*@\\\0000000501*)
(*@/// procedure TCalendarTestCase.TestEasterDate; *)
(* Example values as in chapter 8 of Meeus *)
procedure TCalendarTestCase.TestEasterDate;
const
  EasterExampleDates: array[0..5,0..2] of integer = (
    (1991,3,31),
    (1992,4,19),
    (1993,4,11),
    (1954,4,18),
    (2000,4,23),
    (1818,3,22)
   );
var
  i: integer;
begin
  for i:=low(EasterExampleDates) to high(EasterExampleDates) do
    Check(EasterDate(EasterExampleDates[i,0]) =
          EncodedateCorrect(EasterExampleDates[i,0],EasterExampleDates[i,1],EasterExampleDates[i,2]),
          'Easter date wrong for '+inttostr(EasterExampleDates[i,0])
         );
  end;
(*@\\\0000000B01*)
(*@/// procedure TCalendarTestCase.TestEasterDateJulian; *)
(* Example values as in chapter 8 of Meeus *)
procedure TCalendarTestCase.TestEasterDateJulian;
const
  EasterExampleDates: array[0..4,0..2] of integer = (
    (179,4,12),
    (711,4,12),
    (1243,4,12),
    (2001,4,15),
    (2002,5,5)
   );
var
  i: integer;
begin
  for i:=low(EasterExampleDates) to high(EasterExampleDates) do
    Check(EasterDateJulian(EasterExampleDates[i,0]) =
          EncodedateCorrect(EasterExampleDates[i,0],EasterExampleDates[i,1],EasterExampleDates[i,2]),
          'Julian Easter date wrong for '+inttostr(EasterExampleDates[i,0])
         );
  end;
(*@\\\0002000421000421*)
(*@/// procedure TCalendarTestCase.TestWeekNumber; *)
procedure TCalendarTestCase.TestWeekNumber;
var
  y: integer;
  n: integer;
  d: TDateTime;
begin
  for y:=1990 to 2020 do begin
    d:=EncodeDate(y,1,1);
    n:=WeekNumber(d);
    if DayOfWeek(d) in [2,3,4,5] then
      Check(n=1,inttostr(y)+'-1-1 ('+ShortDayNames[DayOfWeek(d)]+') '+
                'is in week '+inttostr(n)+' instead of week 1')
    else
      Check(n>=52,inttostr(y)+'-1-1 ('+ShortDayNames[DayOfWeek(d)]+') '+
                  'is in week '+inttostr(n)+' instead of week 52 or 53');
    end;
  end;
(*@\\\0000000A20*)

{ TJewishTestCase }

(*@/// procedure TJewishTestCase.TestEncodeDateJewish; *)
(* Example 9.a of Meeus *)
procedure TJewishTestCase.TestEncodeDateJewish;
begin
  Check( EncodeDateJewish(5752,7,1) = Encodedate(1991,9,9),
         'Jewish calendar: 1 Tishri 5752 failed');
  Check( EncodeDateJewish(5751,7,1) = Encodedate(1990,9,20),
         'Jewish calendar: 1 Tishri 5751 failed');
  end;
(*@\\\000000041A*)
(*@/// procedure TJewishTestCase.TestPesachEasterCoincide; *)
procedure TJewishTestCase.TestPesachEasterCoincide;
var
  i: integer;
begin
  for i:=1800 to 2130 do begin
    case i of
      1805,1825,1903,1923,1927,1954,1981,2123:
        Check( PesachDate(i) = EasterDate(i) , 'Easter/Pesach concide not found for '+inttostr(i))
      else
        Check( PesachDate(i) <> EasterDate(i), 'Easter/Pesach concide found erroneous for '+inttostr(i));
      end;
    end;
  end;
(*@\\\0000000901*)

{ TChineseTestCase }

(*@/// procedure TChineseTestCase.TestChineseNewYear; *)
(* Table from Helmer Aslaksen "The Mathematics of the Chinese Calendar" *)
procedure TChineseTestCase.TestChineseNewYear;
const
  ExampleDates: array[0..37,0..2] of integer = (
    (1980,2,16),
    (1981,2, 5),
    (1982,1,25),
    (1983,2,13),
    (1984,2, 2),
    (1985,2,20),
    (1986,2, 9),
    (1987,1,29),
    (1988,2,17),
    (1989,2, 6),
    (1990,1,27),
    (1991,2,15),
    (1992,2, 4),
    (1993,1,23),
    (1994,2,10),
    (1995,1,31),
    (1996,2,19),
    (1997,2, 7),
    (1998,1,28),
    (1999,2,16),
    (2000,2, 5),
    (2001,1,24),
    (2002,2,12),
    (2003,2, 1),
    (2004,1,22),
    (2005,2, 9),
    (2006,1,29),
    (2007,2,18),
    (2008,2, 7),
    (2009,1,26),
    (2010,2,14),
    (2011,2, 3),
    (2012,1,23),
    (2013,2,10),
    (2014,1,31),
    (2015,2,19),
    (2016,2, 8),
    (2017,1,28)
   );
var
  i: integer;
begin
  for i:=low(ExampleDates) to high(ExampleDates) do
    Check(ChineseNewYear(ExampleDates[i,0]) =
          EncodedateCorrect(ExampleDates[i,0],ExampleDates[i,1],ExampleDates[i,2]),
          'Chinese new year date wrong for '+inttostr(ExampleDates[i,0])
         );
  end;
(*@\\\0000002C01*)
(*@/// procedure TChineseTestCase.TestLeapMonths; *)
(* Table from Helmer Aslaksen "The Mathematics of the Chinese Calendar" *)
procedure TChineseTestCase.TestLeapMonths;
const
  ExampleDates: array[0..90,0..1] of integer = (
    (1805,7),
    (1808,5),
    (1811,3),
    (1814,2),
    (1816,6),
    (1819,4),
    (1822,3),
    (1824,7),
    (1827,5),
    (1830,4),
    (1832,9),
    (1835,6),
    (1838,4),
    (1841,3),
    (1843,7),
    (1846,5),
    (1849,4),
    (1851,8),
    (1854,7),
    (1857,5),
    (1860,3),
    (1862,8),
    (1865,5),
    (1868,4),
    (1870,10),
    (1873,6),
    (1876,5),
    (1879,3),
    (1881,7),
    (1884,5),
    (1887,4),
    (1890,2),
    (1892,6),
    (1895,5),
    (1898,3),
    (1900,8),
    (1903,5),
    (1906,4),
    (1909,2),
    (1911,6),
    (1914,5),
    (1917,2),
    (1919,7),
    (1922,5),
    (1925,4),
    (1928,2),
    (1930,6),
    (1933,5),
    (1936,3),
    (1938,7),
    (1941,6),
    (1944,4),
    (1947,2),
    (1949,7),
    (1952,5),
    (1955,3),
    (1957,8),
    (1960,6),
    (1963,4),
    (1966,3),
    (1968,7),
    (1971,5),
    (1974,4),
    (1976,8),
    (1979,6),
    (1982,4),
    (1984,10),
    (1987,6),
    (1990,5),
    (1993,3),
    (1995,8),
    (1998,5),
    (2001,4),
    (2004,2),
    (2006,7),
    (2009,5),
    (2012,4),
    (2014,9),
    (2017,6),
    (2020,4),
    (2023,2),
    (2025,6),
    (2028,5),
    (2031,3),
    (2033,11),
    (2036,6),
    (2039,5),
    (2042,2),
    (2044,7),
    (2047,5),
    (2050,3)
  );
var
  i: integer;
  c: TChineseDate;
  success: boolean;
  date: TdateTime;
begin
  for i:=low(ExampleDates) to high(ExampleDates) do begin
    date:=Encodedate(ExampleDates[i,0],6,1);
    c:=ChineseDate(date);
    c.day:=1;
    c.month:=ExampleDates[i,1];
    c.leap:=true;
    try
      EncodeDateChinese(c);
      success:=true;
    except
      success:=false;
      end;
    Check(success,
          'Chinese leap month not fitting for '+inttostr(ExampleDates[i,0])
         );
    end;
  end;
(*@\\\0000006314*)

{ TMiscAlgorithmTestCase }
(*@/// procedure TMiscAlgorithmTestCase.TestDistanceOnEarth; *)
(* Example 11c of Meeus *)
procedure TMiscAlgorithmTestCase.TestDistanceOnEarth;
const
  washington_latitude = 38.0+55.0/60+17.0/3600;
  washington_longitude = 77.0+3.0/60+56.0/3600;
  paris_longitude = -(2.0+20.0/60+14.0/3600);
  paris_latitude = 48.0+50.0/60+11.0/3600;
var
  value: extended;
begin
  value:=abs(DistanceOnEarth(
    paris_latitude, paris_longitude,
    washington_latitude, washington_longitude )- 6181.63);
  Check( value < 0.01,
    'Distance between Paris and Washington off by '+floattostr(value));
  end;
(*@\\\0000000601*)
(*@/// procedure TMiscAlgorithmTestCase.TestStarTime; *)
(* Example 12.a/b of Meeus *)
procedure TMiscAlgorithmTestCase.TestStarTime;
var
  value: extended;
begin
  value:=abs(star_time(EncodeDate(1987,4,10)) - (13.0+10.0/60+46.1351/3600)*15)/15*3600;
  Check( value<0.01,
    'Apparent siderial time for 1987-4-10 off by '+floattostr(value)+' seconds');
  value:=abs(mean_star_time(EncodeDate(1987,4,10)) - (13.0+10.0/60+46.3668/3600)*15)*15*3600;
  Check( value<0.01,
    'Mean siderial time for 1987-4-10 off by '+floattostr(value)+' seconds');
  end;
(*@\\\0000000B0B*)
(*@/// procedure TMiscAlgorithmTestCase.TestDynamicTimeOffset; *)
(* Example 10.a/b *)
procedure TMiscAlgorithmTestCase.TestDynamicTimeOffset;
var
  value: extended;
begin
  value:=abs(DynamicTimeDifference(EncodeDateCorrect(333,2,6)) - 6146);
  Check( value<1,
    'Dynamic time offset for 333 differs by '+floattostr(value));
  value:=abs(DynamicTimeDifference(EncodeDateCorrect(1977,2,18)) - 48);
  Check( value<1,
    'Dynamic time offset for 1977 differs by '+floattostr(value));
  end;
(*@\\\*)
(*@/// procedure TMiscAlgorithmTestCase.TestRefraction; *)
(* Example 16.a *)
procedure TMiscAlgorithmTestCase.TestRefraction;
var
  value: extended;
begin
  value:=abs((Elevation_Apparent_to_Real(0.5,283,1010)-0.5) - 28.754/60);
  Check( value<0.001, 'Refraction apparent to real off by '+floattostr(value));
  value:=abs((Elevation_Real_To_Apparent(0.5541,283,1010)-0.5541) - 24.618/60);
  Check( value<0.001, 'Refraction real to apparent off by '+floattostr(value));
  end;
(*@\\\0000000A07*)
(*@/// procedure TMiscAlgorithmTestCase.TestEquationOfTime; *)
(* Example 28.a/b *)
procedure TMiscAlgorithmTestCase.TestEquationOfTime;
var
  value: extended;
begin
  value:=abs(EquationOfTime(EncodeDate(1992,10,13)) - (13*60+42.6));
  Check( value<0.1, 'Equation of time off by '+floattostr(value)+' seconds');
  end;
(*@\\\0000000601*)
(*@/// procedure TMiscAlgorithmTestCase.TestCoordinateTransformation; *)
(* Examples 13a/b *)
procedure TMiscAlgorithmTestCase.TestCoordinateTransformation;
var
  alpha, delta: extended;
  lambda, beta: extended;
  A,h: extended;
  value: extended;
  date: TdateTime;
const
  alpha_13a=116.328942;
  delta_13a=28.026183;
  lambda_13a=113.215630;
  beta_13a=6.684170;
  alpha_13b =(23+9/60+16.641/3600)/24*360;
  delta_13b =-(6+43/60+11.61/3600);
  azimuth_13b = 68.0337;
  elevation_13b = 15.1249;
  obs_latitude = 38+55/60+17/3600;
  obs_longitude = 77+3/60+56/3600;
begin
  (* Example 13a *)
  alpha:=alpha_13a;
  delta:=delta_13a;
  date:=Epoch_J2000;
  EquatorialToMeanEcliptic(date,alpha,delta,beta,lambda);
  value:=abs((lambda-lambda_13a)*3600);
  Check( value<0.1, 'Equator to Ecliptic: Longitude off by '+floattostr(value)+' arcseconds');
  value:=abs((beta-beta_13a)*3600);
  Check( value<0.1, 'Equator to Ecliptic: Latitude off by '+floattostr(value)+' arcseconds');
  MeanEclipticToEquatorial(date,beta,lambda,alpha,delta);
  value:=abs((alpha-alpha_13a)*3600);
  Check( value<0.1, 'Ecliptic to Equator: Rektaszension off by '+floattostr(value)+' arcseconds');
  value:=abs((delta-delta_13a)*3600);
  Check( value<0.1, 'Ecliptic to Equator: Declination off by '+floattostr(value)+' arcseconds');


  (* Example 13b *)
  alpha:=alpha_13b;
  delta:=delta_13b;
  date:=EncodeDate(1987,4,10)+encodetime(19,21,0,0);
  EquatorialToHorizontal(date,alpha,delta,obs_latitude,obs_longitude,h,A);
  value:=abs((A-azimuth_13b)*3600);
  Check( value<0.5, 'Equator to Horizon: Azimuth off by '+floattostr(value)+' arcseconds');
  value:=abs((h-elevation_13b)*3600);
  Check( value<0.5, 'Equator to Horizon: Elevation off by '+floattostr(value)+' arcseconds');
  HorizontalToEquatorial(date,h,a,obs_latitude,obs_longitude,alpha,delta);
  value:=abs((alpha-alpha_13b)*3600);
  Check( value<0.5, 'Horizon to Equator: Rektaszension off by '+floattostr(value)+' arcseconds');
  value:=abs((delta-delta_13b)*3600);
  Check( value<0.5, 'Horizon to Equator: Declination off by '+floattostr(value)+' arcseconds');
  end;
(*@\\\0000001101*)
(*@/// procedure TMiscAlgorithmTestCase.TestNutation; *)
(* Examples 22a *)
procedure TMiscAlgorithmTestCase.TestNutation;
var
  date: TdateTime;
  v: extended;
begin
  date:=encodedate(1987,4,10);
  v:=abs(Nutation_Longitude(date)*3600+3.788);
  Check( v<0.001, 'Nutation longitude off by '+floattostr(v)+' arcseconds');
  v:=abs(Nutation_Obliquity(date)*3600-9.443);
  Check( v<0.001, 'Nutation obliquity off by '+floattostr(v)+' arcseconds');
  v:=abs(EclipticObliquity(date)-(23+26/60+36.850/3600))*3600;
  Check( v<0.001, 'Obliquity of the ecliptic off by '+floattostr(v)+' arcseconds');
  end;
(*@\\\*)
(*@/// procedure TMiscAlgorithmTestCase.TestParallaxCorrection; *)
procedure TMiscAlgorithmTestCase.TestParallaxCorrection;
var
  date: TdateTime;
  rektaszension, declination, v: extended;
const
  r = 339.530208;
  d = -15.771083;
  palomar_latitude = 33.0+21.0/60+22.0/3600;
  palomar_longitude = 116.0+51.0/60+45.0/3600;
  palomar_height = 1706;
begin
  date:=encodedate(2003,8,28)+encodetime(3,17,0,0);
  rektaszension:=r;
  declination:=d;
  ParallaxCorrection(rektaszension,declination,0.37276,
    date,palomar_latitude,palomar_longitude,palomar_height);
  v:=abs((rektaszension-r)-0.0053917)*3600;
  Check( v<0.001, 'Rektaszension correction '+floattostr(v)+' arcseconds');
  v:=abs((declination-d)+14.1/3600)*3600;
  Check( v<0.1, 'Declination correction '+floattostr(v)+' arcseconds');
  end;
(*@\\\000C000101001507*)
(*@/// procedure TMiscAlgorithmTestCase.TestEclipse; *)
procedure TMiscAlgorithmTestCase.TestEclipse;
const
  eclipsetype: array[TEclipse] of string = (
    'none', 'partial', 'noncentral', 'circular', 'circulartotal', 'total', 'halfshadow');
var
  h: TEclipse;
  d: TDateTime;
begin
  d:=Encodedate(1993,5,1);
  h:=NextEclipse(d,true);
  d:=abs(d-EncodeDate(1993,5,21)-EncodeTime(14,21,0,0))*24*60;
  Check(d<1,'Maximum of solar eclipse 1993-5-21 off by '+floattostr(d)+' minutes');
  Check(h=partial,'Solar eclipse type of 1993-5-21 is '+eclipsetype[h]+' instead of partial');

  d:=Encodedate(2009,7,1);
  h:=NextEclipse(d,true);
  d:=abs(d-EncodeDate(2009,7,22)-EncodeTime(2,37,0,0))*24*60;
  Check(d<1,'Maximum of solar eclipse 2009-7-22 off by '+floattostr(d)+' minutes');
  Check(h=total,'Solar eclipse type of 2009-7-22 is '+eclipsetype[h]+' instead of total');

  d:=Encodedate(1973,6,1);
  h:=NextEclipse(d,false);
  d:=abs(d-EncodeDate(1973,6,15)-EncodeTime(20,51,0,0))*24*60;
  Check(d<1,'Maximum of lunar eclipse 1973-6-15 off by '+floattostr(d)+' minutes');
  Check(h=halfshadow,'Lunar eclipse type of 1993-5-21 is '+eclipsetype[h]+' instead of halfshadow');

  d:=Encodedate(1997,7,1);
  h:=NextEclipse(d,false);
  d:=abs(d-EncodeDate(1997,9,16)-EncodeTime(18,48,12,0))*24*60;
  Check(d<1,'Maximum of lunar eclipse 1997-9-16 off by '+floattostr(d)+' minutes');
  Check(h=total,'Lunar eclipse type of 1997-9-16 is '+eclipsetype[h]+' instead of total');
  end;
(*@\\\0000001801*)
(*@/// procedure TMiscAlgorithmTestCase.TestEpochConversion; *)
(* Examples 21b *)
procedure TMiscAlgorithmTestCase.TestEpochConversion;
var
  a,d: extended;
begin
  a:=(2+44/60+11.986/3600)*360/24;
  d:=49+13/60+42.48/3600;
  a:=a+0.989/3600/24*360;
  d:=d-2.58/3600;
  ConvertEquinoxJ2000toDate(EncodeDate(2028,11,13)+0.19,a,d);
  a:=abs(a-41.547214)*3600;
  d:=abs(d-49.348483)*3600;
  Check( a<0.001, 'Epoch converted right ascension off by '+floattostr(a)+' arcseconds');
  Check( d<0.001, 'Epoch converted declination off by '+floattostr(a)+' arcseconds');
  end;
(*@\\\0000000A01*)


{ TMoonTestCase }

(*@/// procedure TMoonTestCase.TestApogee; *)
(* Example 50.a of Meeus *)
procedure TMoonTestCase.TestApogee;
var
  value: TdateTime;
begin
  value:=abs(nextapogee(encodedate(1988,10,1))-encodedate(1988,10,7)-20.5/24)*24*60;
  Check( value<2, 'Apogee off by '+floattostr(value)+' minutes');
  end;
(*@\\\0000000601*)
(*@/// procedure TMoonTestCase.TestPosition; *)
(* Example 47.a of Meeus *)
procedure TMoonTestCase.TestPosition;
var
  date: TdateTime;
  value1, value2: extended;
begin
  date:=encodedate(1992,4,12);
  value1:=abs(moon_distance(date)-368405.6);
  Check( value1<5, 'Moon distance off by '+floattostr(value1)+' km');
  Moon_Position_Ecliptic(date,value1,value2);
  value1:=abs(value1+(3+13.0/60+45.0/3600))*3600;
  value2:=abs(value2-(133+10.0/60))*3600;
  Check( value1<1, 'Moon latitude off by '+floattostr(value1)+' seconds');
  Check( value2<3, 'Moon longitude off by '+floattostr(value2)+' seconds');
  end;
(*@\\\0000000C0E*)
(*@/// procedure TMoonTestCase.TestPhases; *)
(* Example 49.a/b of Meeus *)
procedure TMoonTestCase.TestPhases;
var
  date: extended;
begin
  date:=86400*abs(next_phase(encodedate(1977,2,1),Newmoon)-
    encodedate(1977,2,18)-encodetime(3,37,42,0));
  Check( date<3, 'New moon in February 1977 off by '+floattostr(date)+' seconds');

  date:=86400*abs(next_phase(encodedate(2044,1,1),LastQuarter)-
    encodedate(2044,1,21)-encodetime(23,48,17,0));
  Check( date<3, 'New moon in January 2044 off by '+floattostr(date)+' seconds');
  end;
(*@\\\0000000A12*)
(*@/// procedure TMoonTestCase.TestNodes; *)
(* Example 51.a of Meeus *)
procedure TMoonTestCase.TestNodes;
var
  value: TdateTime;
begin
  value:=abs(NextMoonNode(encodedate(1987,5,1),true)-encodedate(1987,5,23)-6.0/24-25.6/24/60)*24*60;
  Check( value<1, 'Ascending node off by '+floattostr(value)+' minutes');
  end;
(*@\\\000000060D*)
(*@/// procedure TMoonTestCase.TestBlueMoon; *)
procedure TMoonTestCase.TestBlueMoon;
const
  ExampleDates: array[0..10,0..1] of integer = (
    ( 1999, 1 ),
    ( 1999, 3 ),
    ( 2001,11 ),
    ( 2004, 7 ),
    ( 2007, 6 ),
    ( 2009,12 ),
    ( 2012, 8 ),
    ( 2015, 7 ),
    ( 2018, 1 ),
    ( 2018, 3 ),
    ( 2020,10 ) );
var
  i: integer;
  value: TDateTime;
begin
  for i:=low(ExampleDates) to high(ExampleDates) do begin
    if ExampleDates[i,1]=12 then
      value:=encodedate(ExampleDates[i,0]+1,1,1)
    else
      value:=encodedate(ExampleDates[i,0],ExampleDates[i,1]+1,1);
    Check(is_blue_moon(lunation(value)),
          'Blue moon missed for '+inttostr(ExampleDates[i,0])+'-'+
                                  inttostr(ExampleDates[i,1]));
    end;
  end;
(*@\\\0000001C07*)
(*@/// procedure TMoonTestCase.TestBlueMoonMaine; *)
procedure TMoonTestCase.TestBlueMoonMaine;
const
  ExampleDates: array[0..21,0..1] of integer = (
    ( 1915,11 ),
    ( 1918, 8 ),
    ( 1921, 5 ),
    ( 1924, 2 ),
    ( 1932, 5 ),
    ( 1934,11 ),
    ( 1937, 8 ),
    ( 1940, 5 ),
    ( 1943, 2 ),
    ( 1945,11 ),
    ( 1948, 5 ),
    ( 1951, 5 ),
    ( 1953,11 ),
    ( 1956, 8 ),
    ( 2000, 2 ),
    ( 2002,11 ),
    ( 2005, 8 ),
    ( 2008, 5 ),
    ( 2010,11 ),
    ( 2013, 8 ),
    ( 2016, 5 ),
    ( 2019, 2 ) );
var
  i: integer;
  value: TDateTime;
begin
  for i:=low(ExampleDates) to high(ExampleDates) do begin
    if ExampleDates[i,1]=12 then
      value:=encodedate(ExampleDates[i,0]+1,1,1)
    else
      value:=encodedate(ExampleDates[i,0],ExampleDates[i,1]+1,1);
    Check(MoonName(lunation(value))=mn_blue,
          'Blue moon missed for '+inttostr(ExampleDates[i,0])+'-'+
                                  inttostr(ExampleDates[i,1]));
    end;
  end;
(*@\\\0000002707*)
(*@/// procedure TMoonTestCase.TestPhysicalEphemerides; *)
(* Example 53.a of Meeus *)
procedure TMoonTestCase.TestPhysicalEphemerides;
var
  date: TdateTime;
  value1, value2: extended;
begin
  date:=encodedate(1992,4,12);
  value1:=put_in_360(MoonPositionAngleAxis(date)-15.08);
  if value1>180 then value1:=value1-360;
  Check( value1<0.01, 'Moon Position Angle of Axis off by '+floattostr(value1)+' degrees');
  OpticalLibration(date,value1,value2);
  value1:=abs(value1-4.194);
  value2:=abs(value2+1.206);
  Check( value1<0.001, 'Moon optical libration latitude off by '+floattostr(value1)+' degrees');
  Check( value2<0.001, 'Moon optical libration longitude off by '+floattostr(value2)+' degrees');
  PhysicalLibration(date,value1,value2);
  value1:=abs(value1-4.20);
  value2:=abs(value2+1.23);
  Check( value1<0.01, 'Moon optical libration latitude off by '+floattostr(value1)+' degrees');
  Check( value2<0.01, 'Moon optical libration longitude off by '+floattostr(value2)+' degrees');
  end;
(*@\\\000000111B*)
(*@/// procedure TMoonTestCase.TestPhaseAngle; *)
(* Example 48.a of Meeus *)
procedure TMoonTestCase.TestPhaseAngle;
var
  date: TdateTime;
  value: extended;
begin
  date:=encodedate(1992,4,12);
  value:=put_in_360(moon_phase_angle(date)-69.076);  // 69.0756 fir Meeus, 69.07619 for ELP
  if value>=180 then value:=value-360;
  Check( value<0.001, 'Moon phase angle off by '+floattostr(value)+' degrees');
  value:=abs(current_phase(date)-0.6786);
  Check( value<0.0001, 'Moon illuminated fraction off by '+floattostr(value));
  value:=put_in_360(MoonBrightLimbPositionAngle(date)-285);
  if value>=180 then value:=value-360;
  Check( value<0.1, 'Moon bright limb angle off by '+floattostr(value)+' degrees');
  end;
(*@\\\0000000C34*)


{ TSunTestCase }

(*@/// procedure TSunTestCase.TestMarchEquinox; *)
procedure TSunTestCase.TestMarchEquinox;
const
  ExampleDates: array[1996..2005,0..3] of integer = (
    ( {1996} 20, 8,04,07 ),
    ( {1997} 20,13,55,42 ),
    ( {1998} 20,19,55,35 ),
    ( {1999} 21, 1,46,53 ),
    ( {2000} 20, 7,36,19 ),
    ( {2001} 20,13,31,47 ),
    ( {2002} 20,19,17,13 ),
    ( {2003} 21, 1,00,50 ),
    ( {2004} 20, 6,49,42 ),
    ( {2005} 20,12,34,29 )
  );
var
  i: integer;
  value: TDateTime;
begin
  for i:=low(ExampleDates) to high(ExampleDates) do begin
    value:=86400*abs(StartSeason(i,spring)-Encodedate(i,3,ExampleDates[i,0])-
      EncodeTime(ExampleDates[i,1],ExampleDates[i,2],ExampleDates[i,3],0));
    Check(value < 20,
          'March equinox '+inttostr(i)+' off by '+inttostr(round(value))+' seconds');
    end;
 end;
(*@\\\0000001614*)
(*@/// procedure TSunTestCase.TestSeptemberEquinox; *)
procedure TSunTestCase.TestSeptemberEquinox;
const
  ExampleDates: array[1996..2005,0..3] of integer = (
    ( {1996} 22,18,01,08 ),
    ( {1997} 22,23,56,49 ),
    ( {1998} 23, 5,38,15 ),
    ( {1999} 23,11,32,34 ),
    ( {2000} 22,17,28,40 ),
    ( {2001} 22,23,05,32 ),
    ( {2002} 23, 4,56,28 ),
    ( {2003} 23,10,47,53 ),
    ( {2004} 22,16,30,54 ),
    ( {2005} 22,22,24,14 )
  );
var
  i: integer;
  value: TDateTime;
begin
  for i:=low(ExampleDates) to high(ExampleDates) do begin
    value:=86400*abs(StartSeason(i,autumn)-EncodeDate(i,9,ExampleDates[i,0])-
      EncodeTime(ExampleDates[i,1],ExampleDates[i,2],ExampleDates[i,3],0));
    Check(value < 20,
          'September equinox '+inttostr(i)+' off by '+inttostr(round(value))+' seconds');
    end;
 end;
(*@\\\0000001614*)
(*@/// procedure TSunTestCase.TestJuneSolstice; *)
procedure TSunTestCase.TestJuneSolstice;
const
  ExampleDates: array[1996..2005,0..3] of integer = (
    ( {1996} 21, 2,24,46 ),
    ( {1997} 21, 8,20,59 ),
    ( {1998} 21,14,03,38 ),
    ( {1999} 21,19,50,11 ),
    ( {2000} 21, 1,48,46 ),
    ( {2001} 21, 7,38,48 ),
    ( {2002} 21,13,25,29 ),
    ( {2003} 21,19,11,32 ),
    ( {2004} 21, 0,57,57 ),
    ( {2005} 21, 6,47,12 )
  );
var
  i: integer;
  value: TDateTime;
begin
  for i:=low(ExampleDates) to high(ExampleDates) do begin
    value:=86400*abs(StartSeason(i,summer)-EncodeDate(i,6,ExampleDates[i,0])-
      EncodeTime(ExampleDates[i,1],ExampleDates[i,2],ExampleDates[i,3],0));
    Check(value < 20,
          'June solstice '+inttostr(i)+' off by '+inttostr(round(value))+' seconds');
    end;
 end;
(*@\\\0000001614*)
(*@/// procedure TSunTestCase.TestDecemberSolstice; *)
procedure TSunTestCase.TestDecemberSolstice;
const
  ExampleDates: array[1996..2005,0..3] of integer = (
    ( {1996} 21,14,06,56 ),
    ( {1997} 21,20,08,05 ),
    ( {1998} 22, 1,57,31 ),
    ( {1999} 22, 7,44,52 ),
    ( {2000} 21,13,38,30 ),
    ( {2001} 21,19,22,34 ),
    ( {2002} 22, 1,15,26 ),
    ( {2003} 22, 7,04,53 ),
    ( {2004} 21,12,42,40 ),
    ( {2005} 21,18,36,01 )
  );
var
  i: integer;
  value: TDateTime;
begin
  for i:=low(ExampleDates) to high(ExampleDates) do begin
    value:=86400*abs(StartSeason(i,winter)-EncodeDate(i,12,ExampleDates[i,0])-
      EncodeTime(ExampleDates[i,1],ExampleDates[i,2],ExampleDates[i,3],0));
    Check(value < 20,
          'December solstice '+inttostr(i)+' off by '+inttostr(round(value))+' seconds');
    end;
 end;
(*@\\\0000001614*)
(*@/// procedure TSunTestCase.TestPerihelion; *)
procedure TSunTestCase.TestPerihelion;
const
  ExampleDates: array[1991..2010,0..3] of integer = (
    ( {1991}  1, 3, 3,00 ),
    ( {1992}  1, 3,15,06 ),
    ( {1993}  1, 4, 3,08 ),
    ( {1994}  1, 2, 5,92 ),
    ( {1995}  1, 4,11,10 ),
    ( {1996}  1, 4, 7,43 ),
    ( {1997}  1, 1,23,29 ),
    ( {1998}  1, 4,21,28 ),
    ( {1999}  1, 3,13,02 ),
    ( {2000}  1, 3, 5,31 ),
    ( {2001}  1, 4, 8,89 ),
    ( {2002}  1, 2,14,17 ),
    ( {2003}  1, 4, 5,04 ),
    ( {2004}  1, 4,17,72 ),
    ( {2005}  1, 2, 0,61 ),
    ( {2006}  1, 4,15,52 ),
    ( {2007}  1, 3,19,74 ),
    ( {2008}  1, 2,23,87 ),
    ( {2009}  1, 4,15,51 ),
    ( {2010}  1, 3, 0,18 )
  );
var
  i: integer;
  value: TDateTime;
begin
  for i:=low(ExampleDates) to high(ExampleDates) do begin
    value:=abs(nextperihel(Encodedate(i,1,1))-
      EncodeDate(i,ExampleDates[i,0],ExampleDates[i,1])-
      (ExampleDates[i,2]+ExampleDates[i,3]*0.01)/24)*24;
    Check(value < 0.7,  (* 0.05 for full VSOP *)
          'Perihelion '+inttostr(i)+' off by '+inttostr(round(value*60))+' minutes');
    end;
 end;
(*@\\\0000001E0F*)
(*@/// procedure TSunTestCase.TestAphelion; *)
procedure TSunTestCase.TestAphelion;
const
  ExampleDates: array[1991..2010,0..3] of integer = (
    ( {1991}  7, 6,15,46 ),
    ( {1992}  7, 3,12,14 ),
    ( {1993}  7, 4,22,37 ),
    ( {1994}  7, 5,19,30 ),
    ( {1995}  7, 4, 2,29 ),
    ( {1996}  7, 5,19,02 ),
    ( {1997}  7, 4,19,34 ),
    ( {1998}  7, 3,23,86 ),
    ( {1999}  7, 6,22,86 ),
    ( {2000}  7, 3,23,84 ),
    ( {2001}  7, 4,13,65 ),
    ( {2002}  7, 6, 3,80 ),
    ( {2003}  7, 4, 5,67 ),
    ( {2004}  7, 5,10,90 ),
    ( {2005}  7, 5, 4,98 ),
    ( {2006}  7, 3,23,18 ),
    ( {2007}  7, 6,23,89 ),
    ( {2008}  7, 4, 7,71 ),
    ( {2009}  7, 4, 1,69 ),
    ( {2010}  7, 6,11,52 )
  );
var
  i: integer;
  value: TDateTime;
begin
  for i:=low(ExampleDates) to high(ExampleDates) do begin
    value:=abs(nextaphel(Encodedate(i,1,1))-
      EncodeDate(i,ExampleDates[i,0],ExampleDates[i,1])-
      (ExampleDates[i,2]+ExampleDates[i,3]*0.01)/24)*24;
    Check(value < 0.8,  (* 0.05 for full VSOP *)
          'Aphelion '+inttostr(i)+' off by '+inttostr(round(value*60))+' minutes');
    end;
 end;
(*@\\\0000000C01*)
(*@/// procedure TSunTestCase.TestSunCoordinate; *)
(* Example 25.b of Meeus *)
procedure TSunTestCase.TestSunCoordinate;
var
  date: TdateTime;
  value1,value2: extended;
begin
  date:=encodedate(1992,10,13);
  value1:=abs(sun_distance(date) - 0.99760853);
  Check(value1 < 1e-6,'Sun distance off by '+floattostr(value1)+' AU');
  Sun_Position_Ecliptic(date,value2,value1);

  value1:=abs(value1 - (199+54.0/60+21.56/3600))*3600;
  value2:=abs(value2 - (0.72/3600))*3600;
  Check(value1 < 0.5,'Sun longitude off by '+floattostr(value1)+' seconds');
  Check(value2 < 0.2,'Sun latitude off by '+floattostr(value2)+' seconds');

  Sun_Position_Equatorial(date,value1,value2);
  value1:=abs(value1/15 - (13+13.0/60+30.749/3600))*3600;
  value2:=abs(value2 + (7+47.0/60+1.74/3600))*3600;
  Check(value1 < 0.1,'Sun rektaszension off by '+floattostr(value1)+' seconds');
  Check(value2 < 0.3,'Sun declination off by '+floattostr(value2)+' seconds');

  end;
(*@\\\*)

(*$ifdef planets *)
{ TPlanetTestCase }

(*@/// procedure TPlanetTestCase.TestVenus; *)
(* Example 33.a of Meeus *)
procedure TPlanetTestCase.TestVenus;
var
  date: TdateTime;
  l,b,r: extended;
begin
  date:=encodedate(1992,12,20);
  Planet_coord_apparent(date,plVenus,l,b,r);
  l:=abs(l - 313.08151);
  b:=abs(b +   2.08487);
  r:=abs(r - 0.91084596);
  Check(l < 5e-5,'Venus longitude off by '+floattostr(l*3600)+' arcseconds');
  Check(b < 5e-5,'Venus latitude off by '+floattostr(b*3600)+' arcseconds');
  Check(r < 5e-5,'Venus radius off by '+floattostr(r)+' AU');
  end;
(*@\\\*)
(*@/// procedure TPlanetTestCase.TestSaturn; *)
(* Example 32.b of Meeus *)
procedure TPlanetTestCase.TestSaturn;
var
  date: TdateTime;
  l,b,r: extended;
begin
  date:=encodedate(1999,7,26);
  Planet_coord(date,plSaturn,l,b,r);
  l:=abs(l - 39.9723901);
  Check(l < 1.1e-4,'Saturn heliocentric longitude off by '+floattostr(l*3600)+' arcseconds');
  end;
(*@\\\0000000701*)
(*@/// procedure TPlanetTestCase.TestPluto; *)
(* Example 37.a of Meeus *)
procedure TPlanetTestCase.TestPluto;
var
  date: TdateTime;
  l,b,r: extended;
  rektaszension,declination: extended;
begin
  date:=encodedate(1992,10,13);
  Planet_coord(date,plPluto,l,b,r);
  (* Test values are in J2000, Planet_coord in dynamic epoch *)
  EclipticToEquatorial(date,b,l,rektaszension,declination);
  ConvertEquinoxDateToJ2000(date,rektaszension,declination);
  EquatorialToEcliptic(Epoch_J2000,rektaszension,declination,b,l);

  l:=abs(l - 232.74071);
  b:=abs(b - 14.58782);
  r:=abs(r - 29.711111);
  Check(l < 1e-4,'Pluto heliocentric longitude off by '+floattostr(l*3600)+' arcseconds');
  Check(b < 1e-4,'Pluto heliocentric latitude off by '+floattostr(b*3600)+' arcseconds');
  Check(r < 1e-6,'Pluto heliocentric radius off by '+floattostr(r)+' AU');
  Planet_coord_astrometric(date,plPluto,l,b,r);
  (* Test values are in J2000, Planet_coord in dynamic epoch *)
  MeanEclipticToEquatorial(date,b,l,rektaszension,declination);
//  EclipticToEquatorial(date,b,l,rektaszension,declination);
  ConvertEquinoxDateToJ2000(date,rektaszension,declination);
  rektaszension:=abs(rektaszension - 232.93231)/15*3600;
  declination:=abs(declination + 4.45802 )*3600;
  r:=abs(r - 30.528739);
  Check(rektaszension < 0.1,'Pluto astrometric rektaszension off by '+floattostr(rektaszension)+' seconds');
  Check(declination < 1,'Pluto astrometric declination off by '+floattostr(declination)+' arcseconds');
  Check(r < 1e-6,'Pluto geocentric radius off by '+floattostr(r)+' AU');
  end;
(*@\\\0000000718*)
(*$endif *)
(*@\\\0030001D01000101000701*)
(*@/// initialization *)
var
  MoonTestSuite,
  CalendarTestSuite,
  JewishCalendarTestSuite,
  ChineseCalendarTestSuite,
  MoonAlgorithmsTestSuite,
  SunAlgorithmsTestSuite,
(*$ifdef planets *)
  PlanetCaseTestSuite,
(*$endif *)
  AlgorithmsTestSuite: TTestSuite;

initialization
begin
  MoonTestSuite := TTestSuite.Create('Moon and calendar functions');

  CalendarTestSuite := TTestSuite.Create('Basic calendar functions');
  CalendarTestSuite.AddTests(TCalendarTestCase);
  MoonTestSuite.AddSuite(CalendarTestSuite);

  JewishCalendarTestSuite := TTestSuite.Create('Jewish calendar functions');
  JewishCalendarTestSuite.AddTests(TJewishTestCase);
  MoonTestSuite.AddSuite(JewishCalendarTestSuite);

  ChineseCalendarTestSuite := TTestSuite.Create('Chinese calendar functions');
  ChineseCalendarTestSuite.AddTests(TChineseTestCase);
  MoonTestSuite.AddSuite(ChineseCalendarTestSuite);

  MoonAlgorithmsTestSuite := TTestSuite.Create('Moon calculations');
  MoonAlgorithmsTestSuite.AddTests(TMoonTestCase);
  MoonTestSuite.AddSuite(MoonAlgorithmsTestSuite);

  SunAlgorithmsTestSuite := TTestSuite.Create('Sun calculations');
  SunAlgorithmsTestSuite.AddTests(TSunTestCase);
  MoonTestSuite.AddSuite(SunAlgorithmsTestSuite);

(*$ifdef planets *)
  PlanetCaseTestSuite := TTestSuite.Create('Planet calculations');
  PlanetCaseTestSuite.AddTests(TPlanetTestCase);
  MoonTestSuite.AddSuite(PlanetCaseTestSuite);
(*$endif *)

  AlgorithmsTestSuite:=TTestSuite.Create('Misc astronomical algorithms');
  AlgorithmsTestSuite.AddTests(TMiscAlgorithmTestCase);
  MoonTestSuite.AddSuite(AlgorithmsTestSuite);

  TestFramework.RegisterTest(MoonTestSuite);
  end;
(*@\\\0000000A0C*)
(*$warnings off *)
end.
(*@\\\0001000011*)
