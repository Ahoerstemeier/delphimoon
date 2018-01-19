unit
  moon_aux;
 {$i ah_def.inc }
 (*$undef low_accuracy *)
(*@/// interface *)
interface

uses
  ah_math,
  sysutils;

type
  poly_term = (pt_moon_argument, pt_moon_elongation, pt_moon_anomaly,
               pt_sun_anomaly, pt_moon_longitude, pt_moon_node );

const
  poly_full_order = 4;

function Century_term(date: TdateTime):extended;
function calc_poly(date:TDateTime; term:poly_term; order: integer):extended;
function calc_poly_IAU(date:TDateTime; term:poly_term; order: integer):extended;

function GetEccentricityTerm(const date:TDateTime): extended;

type
  (*@/// TCoordinateCalc=class(TObject) *)
  TCoordinateCalc=class(TObject)
  protected
    FDate: TDateTime;
    function CalcLongitude:extended;  virtual; abstract;  (* deg *)
    function CalcLatitude:extended;   virtual; abstract;  (* deg *)
    function CalcRadius:extended;     virtual; abstract;  (* AU (km for moon) *)
    function CalcParallax:extended;
    procedure SetDate(value: TDateTime);  virtual;
    procedure FinishCalculation(var v:TVector);  virtual;
  public
    class function calc_coord(date: TDateTime):TVector;
    class function RadiusUnit:extended;  virtual;
      (* in case radius is not AU: factor to make radius AU *)
    property Longitude:extended read CalcLongitude;
    property Latitude:extended read CalcLatitude;
    property Radius:extended read CalcRadius;
    property Parallax:extended read CalcParallax;
    property Date:TDateTime write SetDate;
    end;
  (*@\\\0000000C01*)
  (*@/// TCoordinateCalcMoon=class(TCoordinateCalc) *)
  TCoordinateCalcMoon=class(TCoordinateCalc)
  public
    class function RadiusUnit:extended;  override;
    end;
  (*@\\\0000000301*)
  TCCoordinateCalc=class of TCoordinateCalc;
  E_OutOfAlgorithmRange=class(Exception);

function Nutation_Longitude(date:TdateTime):extended;   // Delta psi
function Nutation_Obliquity(date:TdateTime):extended;   // Delta epsilon
function MeanEclipticObliquity(date:TdateTime):extended;// epsilon
function EclipticObliquity(date:TdateTime):extended;    // epsilon0

function star_time(date:TDateTime):extended;
function Mean_star_time(date:TDateTime):extended;


{ Epoch transformation }
procedure ConvertEquinox(source_date, target_date: TDateTime; var rektaszension,declination:extended);
procedure ConvertEquinoxB1950toJ2000(var rektaszension,declination:extended);
procedure ConvertEquinoxDateToJ2000(date: TDateTime; var rektaszension,declination:extended);
procedure ConvertEquinoxJ2000toDate(date: TDateTime; var rektaszension,declination:extended);

var
  Epoch_B1900, Epoch_B1950, Epoch_J2000, Epoch_J2050: TDateTime;

{ Coordinate transformations }
procedure EclipticToEquatorial(date: TDateTime; latitude, longitude: extended; var rektaszension,declination: extended);
procedure MeanEclipticToEquatorial(date: TDateTime; latitude, longitude: extended; var rektaszension,declination: extended);
procedure EquatorialToEcliptic(date: TDateTime; rektaszension,declination: extended; var latitude, longitude: extended);
procedure EquatorialToMeanEcliptic(date: TDateTime; rektaszension,declination: extended; var latitude, longitude: extended);
procedure EquatorialToHorizontal(date: TDateTime; rektaszension,declination: extended;
                                 observer_latitude,observer_longitude: extended;
                                 var elevation,azimuth: extended);
procedure HorizontalToEquatorial(date: TDateTime; elevation,azimuth: extended;
                                 observer_latitude,observer_longitude: extended;
                                 var rektaszension,declination: extended);
procedure EclipticToHorizontal(date: TDateTime; latitude, longitude: extended;
                               observer_latitude,observer_longitude: extended;
                               var elevation,azimuth: extended);
procedure HorizontalToEcliptic(date: TDateTime; elevation,azimuth: extended;
                               observer_latitude,observer_longitude: extended;
                               var latitude, longitude: extended);
function DynamicToFK5(Date:TDateTime; v:TVector):TVector;
(*@\\\0000001601*)
(*@/// implementation *)
implementation

const
  AU=149597869;             (* astronomical unit in km *)


(*$ifdef delphi_ge_3 *)
var
(*$else *)
const
(*$endif *)
  (* Shortcut to avoid calling Encodedate too often *)
  datetime_2000_01_01: extended = 0;

type
  T_polynomial_term = array[0..poly_full_order] of extended;
const
  (*@/// poly_moon_argument_of_latitude: T_polynomial_term = (..);   // F *)
  poly_moon_argument_of_latitude: T_polynomial_term = (
    93+16/60+19.55755/3600,
    1739527263.0983/3600,
    -12.2505/3600,
    -0.001021/3600,
    0.00000417/3600
    );
  poly_moon_argument_of_latitude_II: T_polynomial_term = (
    93.2720950,
    483202.0175233,
    -0.0036539,
    -1/3526000,
    1/863310000
    );
  poly_moon_argument_of_latitude_IAU: T_polynomial_term = (
    93.27191,
    483202.017538,
    -0.0036825,
    1/327270,
    0
    );
  (*@\\\0000000801*)
  (*@/// poly_moon_mean_elongation: T_polynomial_term = (..);        // D *)
  poly_moon_mean_elongation: T_polynomial_term = (
    297+51/60+0.73512/3600,
    1602961601.4603/3600,
    -5.8681/3600,
    0.006595/3600,
    -0.00003184/3600
    );
  poly_moon_mean_elongation_II: T_polynomial_term = (
    297.8501921,
    445267.1114034,
    -0.0018819,
    1/545868,
    -1/113065000
    );
  poly_moon_mean_elongation_IAU: T_polynomial_term = (
    297.85036,
    445267.111480,
    -0.0019142,
    1/189474,
    0
    );
  (*@\\\*)
  (*@/// poly_moon_mean_anomaly: T_polynomial_term = (..);           // l  = M' *)
  poly_moon_mean_anomaly: T_polynomial_term = (
    134+57/60+48.28096/3600,
    1717915923.4728/3600,
    32.3893/3600,
    0.051651/3600,
    -0.00024470/3600
    );
  poly_moon_mean_anomaly_II: T_polynomial_term = (
    134.9633964,
    477198.8675055,
    0.0087414,
    1/69699,
    -1/14712000
    );
  poly_moon_mean_anomaly_IAU: T_polynomial_term = (
    134.96298,
    477198.867398,
    0.0086972,
    -1/56250,
    0
    );
  (*@\\\*)
  (*@/// poly_sun_mean_anomaly: T_polynomial_term = (..);            // l' = M *)
  poly_sun_mean_anomaly: T_polynomial_term = (
    357+31/60+44.79306/3600,
    129596581.0474/3600,
    -0.5529/3600,
    0.000147/3600,
    0.0
    );
  poly_sun_mean_anomaly_IAU: T_polynomial_term = (
    357.52772,
    35999.050340,
    -0.0001603,
    1/300000,
    0
    );
  (*@\\\*)
  (*@/// poly_moon_longitude_of_node: T_polynomial_term = (..);      // W3 = Omega *)
  poly_moon_longitude_of_node: T_polynomial_term = (
    125+2/60+40.39816/3600,
    -6967919.3622/3600,
    6.3622/3600,
    0.007625/3600,
    -0.00003586/3600
    );
  poly_moon_longitude_of_node_II: T_polynomial_term = (
    125.0445479,
    -1934.1362891,
    0.0020754,
    1/467441,
    1/60616000
    );
  poly_moon_longitude_of_node_IAU: T_polynomial_term = (
    125.04452,
    -1934.136261,
    0.0029798,
    1/450000,
    0
    );
  (*@\\\*)
  (*@/// poly_moon_mean_longitude: T_polynomial_term = (..);         // W1 = L' *)
  poly_moon_mean_longitude: T_polynomial_term = (
    218+18/60+59.95571/3600,
    1732559343.73604/3600,
    -5.8883/3600,
    0.006604/3600,
    -0.00003169/3600
    );
  poly_moon_mean_longitude_II: T_polynomial_term = (
    218.3164477,
    481267.88123421,
    -0.0015786,
    1/538841,
    -1/65194000
    );
  (*@\\\0000000801*)


(*@/// function Century_term(date: TdateTime):extended;                   // t = T *)
function Century_term(date: TdateTime):extended;
begin
  result:=(date-datetime_2000_01_01-0.5)/36525;
  end;
(*@\\\*)
(*@/// function calc_poly_intern(date:TDateTime; const poly: T_polynomial_term; order: integer):extended; *)
function calc_poly_intern(date:TDateTime; const poly: T_polynomial_term; order: integer):extended;
var
  t: extended;
  i: integer;
begin
  t:=century_term(date);
  result:=0;
  if order>poly_full_order then
    order:=poly_full_order;
  for i:=order downto 0 do
    result:=result*t+poly[i];
  result:=put_in_360(result);
  end;
(*@\\\000000091B*)
(*@/// function calc_poly(date:TDateTime; term:poly_term; order: integer):extended; *)
function calc_poly(date:TDateTime; term:poly_term; order: integer):extended;
begin
  case term of
    pt_moon_argument  : result:=calc_poly_intern(date,poly_moon_argument_of_latitude_II,order);
    pt_moon_elongation: result:=calc_poly_intern(date,poly_moon_mean_elongation_II,order);
    pt_moon_anomaly   : result:=calc_poly_intern(date,poly_moon_mean_anomaly_II,order);
    pt_sun_anomaly    : result:=calc_poly_intern(date,poly_sun_mean_anomaly,order);
    pt_moon_longitude : result:=calc_poly_intern(date,poly_moon_mean_longitude_II,order);
    pt_moon_node      : result:=calc_poly_intern(date,poly_moon_longitude_of_node_II,order);
    else                result:=0;  (* This cannot happen - Delphi shut up *)
    end;
  end;
(*@\\\0000000550*)
(*@/// function calc_poly_IAU(date:TDateTime; term:poly_term; order: integer):extended; *)
function calc_poly_IAU(date:TDateTime; term:poly_term; order: integer):extended;
begin
  case term of
    pt_moon_argument  : result:=calc_poly_intern(date,poly_moon_argument_of_latitude_IAU,order);
    pt_moon_elongation: result:=calc_poly_intern(date,poly_moon_mean_elongation_IAU,order);
    pt_moon_anomaly   : result:=calc_poly_intern(date,poly_moon_mean_anomaly_IAU,order);
    pt_sun_anomaly    : result:=calc_poly_intern(date,poly_sun_mean_anomaly_IAU,order);
    pt_moon_longitude : result:=calc_poly_intern(date,poly_moon_mean_longitude_II,order);
    pt_moon_node      : result:=calc_poly_intern(date,poly_moon_longitude_of_node_IAU,order);
    else                result:=0;  (* This cannot happen - Delphi shut up *)
    end;
  end;
(*@\\\0000000550*)

(*@/// function GetEccentricityTerm(const date:TDateTime): extended; *)
function GetEccentricityTerm(const date:TDateTime): extended;
var
  t: extended;
begin
  t:=century_term(date);
  result:=1.0 - (0.002516*t)-(0.0000074*t*t); { expression 47.6 }
  end;
(*@\\\*)

{ Nutation and Obliquity of  Ecliptic }
{ Based upon 22 (21) of Meeus }
{ 1980 IAU theory of nutation and reduction }
(*$ifndef low_accuracy *)
type
  nutation_entry=record
    ms,m,f,d,o: shortint;  { m = l'; ms = l }
    psi, psi_t: longint;
    eps, eps_t: longint;
    end;
const
  { Table 22.A of Meeus }
  { Table 3.222.1 of Expl. Supplement }
  (*@/// nutation_terms: array of nutation_entry = (..); *)
  (*$ifdef meeus *)
  nutation_terms: array[0..62] of nutation_entry = (
  (*$else *)
  nutation_terms: array[0..105] of nutation_entry = (
  (*$endif *)
   { 001 } (ms: 0; m: 0; f: 0; d: 0; o: 1; psi:-171996; psi_t:-1742; eps:92025; eps_t: 89),
   { 002 } (ms: 0; m: 0; f: 0; d: 0; o: 2; psi:   2062; psi_t:    2; eps: -895; eps_t:  5),
   { 003 } (ms:-2; m: 0; f: 2; d: 0; o: 1; psi:     46; psi_t:    0; eps:  -24; eps_t:  0),
   { 004 } (ms: 2; m: 0; f:-2; d: 0; o: 0; psi:    +11; psi_t:    0; eps:    0; eps_t:  0),
   { 005 } (ms:-2; m: 0; f: 2; d: 0; o: 2; psi:     -3; psi_t:    0; eps:    0; eps_t:  0),
   { 006 } (ms: 1; m:-1; f: 0; d:-1; o: 0; psi:     -3; psi_t:    0; eps:    0; eps_t:  0),
  (*$ifndef meeus *)
   { 007 } (ms: 0; m:-2; f: 2; d:-2; o: 1; psi:     -2; psi_t:    0; eps:    1; eps_t:  0),
   { 008 } (ms: 2; m: 0; f:-2; d: 0; o: 1; psi:      1; psi_t:    0; eps:    0; eps_t:  0),
  (*$endif *)
   { 009 } (ms: 0; m: 0; f: 2; d:-2; o: 2; psi: -13187; psi_t:  -16; eps: 5736; eps_t:-31),
   { 010 } (ms: 0; m: 1; f: 0; d: 0; o: 0; psi:   1426; psi_t:  -34; eps:   54; eps_t: -1),
   { 011 } (ms: 0; m: 1; f: 2; d:-2; o: 2; psi:   -517; psi_t:   12; eps:  224; eps_t: -6),
   { 012 } (ms: 0; m:-1; f: 2; d:-2; o: 2; psi:    217; psi_t:   -5; eps:  -95; eps_t:  3),
   { 013 } (ms: 0; m: 0; f: 2; d:-2; o: 1; psi:    129; psi_t:    1; eps:  -70; eps_t:  0),
   { 014 } (ms: 2; m: 0; f: 0; d:-2; o: 0; psi:     48; psi_t:    0; eps:    0; eps_t:  0),
   { 015 } (ms: 0; m: 0; f: 2; d:-2; o: 0; psi:    -22; psi_t:    0; eps:    0; eps_t:  0),
   { 016 } (ms: 0; m: 2; f: 0; d: 0; o: 0; psi:     17; psi_t:   -1; eps:    0; eps_t:  0),
   { 017 } (ms: 0; m: 1; f: 0; d: 0; o: 1; psi:    -15; psi_t:    0; eps:    9; eps_t:  0),
   { 018 } (ms: 0; m: 2; f: 2; d:-2; o: 2; psi:    -16; psi_t:    1; eps:    7; eps_t:  0),
   { 019 } (ms: 0; m:-1; f: 0; d: 0; o: 1; psi:    -12; psi_t:    0; eps:    6; eps_t:  0),
   { 020 } (ms:-2; m: 0; f: 0; d: 2; o: 1; psi:     -6; psi_t:    0; eps:    3; eps_t:  0),
   { 021 } (ms: 0; m:-1; f: 2; d:-2; o: 1; psi:     -5; psi_t:    0; eps:    3; eps_t:  0),
   { 022 } (ms: 2; m: 0; f: 0; d:-2; o: 1; psi:     +4; psi_t:    0; eps:    0; eps_t:  0),
   { 023 } (ms: 0; m: 1; f: 2; d:-2; o: 1; psi:     +4; psi_t:    0; eps:    0; eps_t:  0),
   { 024 } (ms: 1; m: 0; f: 0; d:-1; o: 0; psi:     -4; psi_t:    0; eps:    0; eps_t:  0),
  (*$ifndef meeus *)
   { 025 } (ms: 2; m: 1; f: 0; d:-2; o: 0; psi:      1; psi_t:    0; eps:    0; eps_t:  0),
   { 026 } (ms: 0; m: 0; f:-2; d: 2; o: 1; psi:      1; psi_t:    0; eps:    0; eps_t:  0),
   { 027 } (ms: 0; m: 1; f:-2; d: 2; o: 0; psi:     -1; psi_t:    0; eps:    0; eps_t:  0),
   { 028 } (ms: 0; m: 1; f: 0; d: 0; o: 2; psi:      1; psi_t:    0; eps:    0; eps_t:  0),
   { 029 } (ms:-1; m: 0; f: 0; d: 1; o: 1; psi:      1; psi_t:    0; eps:    0; eps_t:  0),
   { 030 } (ms: 0; m: 1; f: 2; d:-2; o: 0; psi:     -1; psi_t:    0; eps:    0; eps_t:  0),
  (*$endif *)
   { 031 } (ms: 0; m: 0; f: 2; d: 0; o: 2; psi:  -2274; psi_t:   -2; eps:  977; eps_t: -5),
   { 032 } (ms: 1; m: 0; f: 0; d: 0; o: 0; psi:    712; psi_t:    1; eps:   -7; eps_t:  0),
   { 033 } (ms: 0; m: 0; f: 2; d: 0; o: 1; psi:   -386; psi_t:   -4; eps:  200; eps_t:  0),
   { 034 } (ms: 1; m: 0; f: 2; d: 0; o: 2; psi:   -301; psi_t:    0; eps:  129; eps_t: -1),
   { 035 } (ms: 1; m: 0; f: 0; d:-2; o: 0; psi:   -158; psi_t:    0; eps:    0; eps_t:  0),
   { 036 } (ms:-1; m: 0; f: 2; d: 0; o: 2; psi:    123; psi_t:    0; eps:  -53; eps_t:  0),
   { 037 } (ms: 0; m: 0; f: 0; d: 2; o: 0; psi:     63; psi_t:    0; eps:    0; eps_t:  0),
   { 038 } (ms: 1; m: 0; f: 0; d: 0; o: 1; psi:     63; psi_t:    1; eps:  -33; eps_t:  0),
   { 039 } (ms:-1; m: 0; f: 0; d: 0; o: 1; psi:    -58; psi_t:   -1; eps:   32; eps_t:  0),
   { 040 } (ms:-1; m: 0; f: 2; d: 2; o: 2; psi:    -59; psi_t:    0; eps:   26; eps_t:  0),
   { 041 } (ms: 1; m: 0; f: 2; d: 0; o: 1; psi:    -51; psi_t:    0; eps:   27; eps_t:  0),
   { 042 } (ms: 0; m: 0; f: 2; d: 2; o: 2; psi:    -38; psi_t:    0; eps:   16; eps_t:  0),
   { 043 } (ms: 2; m: 0; f: 0; d: 0; o: 0; psi:     29; psi_t:    0; eps:    0; eps_t:  0),
   { 044 } (ms: 1; m: 0; f: 2; d:-2; o: 2; psi:     29; psi_t:    0; eps:  -12; eps_t:  0),
   { 045 } (ms: 2; m: 0; f: 2; d: 0; o: 2; psi:    -31; psi_t:    0; eps:   13; eps_t:  0),
   { 046 } (ms: 0; m: 0; f: 2; d: 0; o: 0; psi:     26; psi_t:    0; eps:    0; eps_t:  0),
   { 047 } (ms:-1; m: 0; f: 2; d: 0; o: 1; psi:     21; psi_t:    0; eps:  -10; eps_t:  0),
   { 048 } (ms:-1; m: 0; f: 0; d: 2; o: 1; psi:     16; psi_t:    0; eps:   -8; eps_t:  0),
   { 049 } (ms: 1; m: 0; f: 0; d:-2; o: 1; psi:    -13; psi_t:    0; eps:    7; eps_t:  0),
   { 050 } (ms:-1; m: 0; f: 2; d: 2; o: 1; psi:    -10; psi_t:    0; eps:    5; eps_t:  0),
   { 051 } (ms: 1; m: 1; f: 0; d:-2; o: 0; psi:     -7; psi_t:    0; eps:    0; eps_t:  0),
   { 052 } (ms: 0; m: 1; f: 2; d: 0; o: 2; psi:     +7; psi_t:    0; eps:   -3; eps_t:  0),
   { 053 } (ms: 0; m:-1; f: 2; d: 0; o: 2; psi:     -7; psi_t:    0; eps:    3; eps_t:  0),
   { 054 } (ms: 1; m: 0; f: 2; d: 2; o: 2; psi:     -8; psi_t:    0; eps:    3; eps_t:  0),
   { 055 } (ms: 1; m: 0; f: 0; d: 2; o: 0; psi:     +6; psi_t:    0; eps:    0; eps_t:  0),
   { 056 } (ms: 2; m: 0; f: 2; d:-2; o: 2; psi:     +6; psi_t:    0; eps:   -3; eps_t:  0),
   { 057 } (ms: 0; m: 0; f: 0; d: 2; o: 1; psi:     -6; psi_t:    0; eps:    3; eps_t:  0),
   { 058 } (ms: 0; m: 0; f: 2; d: 2; o: 1; psi:     -7; psi_t:    0; eps:    3; eps_t:  0),
   { 059 } (ms: 1; m: 0; f: 2; d:-2; o: 1; psi:     +6; psi_t:    0; eps:   -3; eps_t:  0),
   { 060 } (ms: 0; m: 0; f: 0; d:-2; o: 1; psi:     -5; psi_t:    0; eps:    3; eps_t:  0),
   { 061 } (ms: 1; m:-1; f: 0; d: 0; o: 0; psi:     +5; psi_t:    0; eps:    0; eps_t:  0),
   { 062 } (ms: 2; m: 0; f: 2; d: 0; o: 1; psi:     -5; psi_t:    0; eps:    3; eps_t:  0),
   { 063 } (ms: 0; m: 1; f: 0; d:-2; o: 0; psi:     -4; psi_t:    0; eps:    0; eps_t:  0),
   { 064 } (ms: 1; m: 0; f:-2; d: 0; o: 0; psi:     +4; psi_t:    0; eps:    0; eps_t:  0),
   { 065 } (ms: 0; m: 0; f: 0; d: 1; o: 0; psi:     -4; psi_t:    0; eps:    0; eps_t:  0),
   { 066 } (ms: 1; m: 1; f: 0; d: 0; o: 0; psi:     -3; psi_t:    0; eps:    0; eps_t:  0),
   { 067 } (ms: 1; m: 0; f: 2; d: 0; o: 0; psi:     +3; psi_t:    0; eps:    0; eps_t:  0),
   { 068 } (ms: 1; m:-1; f: 2; d: 0; o: 2; psi:     -3; psi_t:    0; eps:    0; eps_t:  0),
   { 069 } (ms:-1; m:-1; f: 2; d: 2; o: 2; psi:     -3; psi_t:    0; eps:    0; eps_t:  0),
  (*$ifndef meeus *)
   { 070 } (ms:-2; m: 0; f: 0; d: 0; o: 1; psi:     -2; psi_t:    0; eps:    1; eps_t:  0),
  (*$endif *)
   { 071 } (ms: 3; m: 0; f: 2; d: 0; o: 2; psi:     -3; psi_t:    0; eps:    0; eps_t:  0),
   { 072 } (ms: 0; m:-1; f: 2; d: 2; o: 2; psi:     -3; psi_t:    0; eps:    0; eps_t:  0)
  (*$ifndef meeus *)
                                                                                          ,
   { 073 } (ms: 1; m: 1; f: 2; d: 0; o: 2; psi:      2; psi_t:    0; eps:   -1; eps_t:  0),
   { 074 } (ms:-1; m: 0; f: 2; d:-2; o: 1; psi:     -2; psi_t:    0; eps:    1; eps_t:  0),
   { 075 } (ms: 2; m: 0; f: 0; d: 0; o: 1; psi:      2; psi_t:    0; eps:   -1; eps_t:  0),
   { 076 } (ms: 1; m: 0; f: 0; d: 0; o: 2; psi:     -2; psi_t:    0; eps:    1; eps_t:  0),
   { 077 } (ms: 3; m: 0; f: 0; d: 0; o: 0; psi:      2; psi_t:    0; eps:    0; eps_t:  0),
   { 078 } (ms: 0; m: 0; f: 2; d: 1; o: 2; psi:      2; psi_t:    0; eps:   -1; eps_t:  0),
   { 079 } (ms:-1; m: 0; f: 0; d: 0; o: 2; psi:      1; psi_t:    0; eps:   -1; eps_t:  0),
   { 080 } (ms: 1; m: 0; f: 0; d:-4; o: 0; psi:     -1; psi_t:    0; eps:    0; eps_t:  0),
   { 081 } (ms:-2; m: 0; f: 2; d: 2; o: 2; psi:      1; psi_t:    0; eps:   -1; eps_t:  0),
   { 082 } (ms:-1; m: 0; f: 2; d: 4; o: 2; psi:     -2; psi_t:    0; eps:    1; eps_t:  0),
   { 083 } (ms: 2; m: 0; f: 0; d:-4; o: 0; psi:     -1; psi_t:    0; eps:    0; eps_t:  0),
   { 084 } (ms: 1; m: 1; f: 2; d:-2; o: 2; psi:      1; psi_t:    0; eps:   -1; eps_t:  0),
   { 085 } (ms: 1; m: 0; f: 2; d: 2; o: 1; psi:     -1; psi_t:    0; eps:    1; eps_t:  0),
   { 086 } (ms:-2; m: 0; f: 2; d: 4; o: 2; psi:     -1; psi_t:    0; eps:    1; eps_t:  0),
   { 087 } (ms:-1; m: 0; f: 4; d: 0; o: 2; psi:      1; psi_t:    0; eps:    0; eps_t:  0),
   { 088 } (ms: 1; m:-1; f: 0; d:-2; o: 0; psi:      1; psi_t:    0; eps:    0; eps_t:  0),
   { 089 } (ms: 2; m: 0; f: 2; d:-2; o: 1; psi:      1; psi_t:    0; eps:   -1; eps_t:  0),
   { 090 } (ms: 2; m: 0; f: 2; d: 2; o: 2; psi:     -1; psi_t:    0; eps:    0; eps_t:  0),
   { 091 } (ms: 1; m: 0; f: 0; d: 2; o: 1; psi:     -1; psi_t:    0; eps:    0; eps_t:  0),
   { 092 } (ms: 0; m: 0; f: 4; d:-2; o: 2; psi:      1; psi_t:    0; eps:    0; eps_t:  0),
   { 093 } (ms: 3; m: 0; f: 2; d:-2; o: 2; psi:      1; psi_t:    0; eps:    0; eps_t:  0),
   { 094 } (ms: 1; m: 0; f: 2; d:-2; o: 0; psi:     -1; psi_t:    0; eps:    0; eps_t:  0),
   { 095 } (ms: 0; m: 1; f: 2; d: 0; o: 1; psi:      1; psi_t:    0; eps:    0; eps_t:  0),
   { 096 } (ms:-1; m:-1; f: 0; d: 2; o: 1; psi:      1; psi_t:    0; eps:    0; eps_t:  0),
   { 097 } (ms: 0; m: 0; f:-2; d: 0; o: 1; psi:     -1; psi_t:    0; eps:    0; eps_t:  0),
   { 098 } (ms: 0; m: 0; f: 2; d:-1; o: 2; psi:     -1; psi_t:    0; eps:    0; eps_t:  0),
   { 099 } (ms: 0; m: 1; f: 0; d: 2; o: 0; psi:     -1; psi_t:    0; eps:    0; eps_t:  0),
   { 100 } (ms: 1; m: 0; f:-2; d:-2; o: 0; psi:     -1; psi_t:    0; eps:    0; eps_t:  0),
   { 101 } (ms: 0; m:-1; f: 2; d: 0; o: 1; psi:     -1; psi_t:    0; eps:    0; eps_t:  0),
   { 102 } (ms: 1; m: 1; f: 0; d:-2; o: 1; psi:     -1; psi_t:    0; eps:    0; eps_t:  0),
   { 103 } (ms: 1; m: 0; f:-2; d: 2; o: 0; psi:     -1; psi_t:    0; eps:    0; eps_t:  0),
   { 104 } (ms: 2; m: 0; f: 0; d: 2; o: 0; psi:      1; psi_t:    0; eps:    0; eps_t:  0),
   { 105 } (ms: 0; m: 0; f: 2; d: 4; o: 2; psi:     -1; psi_t:    0; eps:    0; eps_t:  0),
   { 106 } (ms: 0; m: 1; f: 0; d: 1; o: 0; psi:      1; psi_t:    0; eps:    0; eps_t:  0)
  (*$endif *)
           );
  (*@\\\*)
(*$endif *)
(*@/// function Nutation_Longitude(date:TdateTime):extended; *)
function Nutation_Longitude(date:TdateTime):extended;
var
  t,omega: extended;
(*$ifdef low_accuracy *)
  l,ls: extended;
(*$else *)
  d,m,ms,f,s: extended;
  i: integer;
(*$endif *)
  delta_psi: extended;
begin
  t:=Century_term(date);
  omega:=calc_poly_IAU(date,pt_moon_node,poly_full_order);

(*$ifdef low_accuracy *)
  (*@/// delta_psi and delta_epsilon - low accuracy *)
  (* mean longitude of sun (l) and moon (ls) *)
  l:=280.4665+36000.7698*t;
  ls:=218.3165+481267.8813*t;

  (* longitude correction due to nutation *)
  delta_psi:=(-17.20*sin_d(omega)-1.32*sin_d(2*l)-0.23*sin_d(2*ls)+0.21*sin_d(2*omega))/3600;
  (*@\\\000000061F*)
(*$else *)
  (*@/// delta_psi and delta_epsilon - higher accuracy *)
  (* mean elongation of moon to sun *)
  d:=calc_poly_IAU(date,pt_moon_elongation,poly_full_order);
  (* mean anomaly of the sun *)
  m:=calc_poly_IAU(date,pt_sun_anomaly,poly_full_order);
  (* mean anomaly of the moon *)
  ms:=calc_poly_IAU(date,pt_moon_anomaly,poly_full_order);
  (* argument of the latitude of the moon *)
  f:=calc_poly_IAU(date,pt_moon_argument,poly_full_order);

  delta_psi:=0;

  for i:=low(nutation_terms) to high(nutation_terms) do begin
    s:= nutation_terms[i].d*d
       +nutation_terms[i].m*m
       +nutation_terms[i].ms*ms
       +nutation_terms[i].f*f
       +nutation_terms[i].o*omega;
    delta_psi:=delta_psi+(nutation_terms[i].psi+nutation_terms[i].psi_t*t*0.1)*sin_d(s);
    end;

  delta_psi:=delta_psi*0.0001/3600;
  (*@\\\0000000601*)
(*$endif *)
  result:=delta_psi;
  end;
(*@\\\000000010A*)
(*@/// function Nutation_Obliquity(date:TdateTime):extended; *)
function Nutation_Obliquity(date:TdateTime):extended;
var
  t,omega: extended;
(*$ifdef low_accuracy *)
  l,ls: extended;
(*$else *)
  d,m,ms,f,s: extended;
  i: integer;
(*$endif *)
  delta_epsilon: extended;
begin
  t:=Century_term(date);
  omega:=calc_poly_IAU(date,pt_moon_node,poly_full_order);

(*$ifdef low_accuracy *)
  (*@/// delta_epsilon - low accuracy *)
  (* mean longitude of sun (l) and moon (ls) *)
  l:=280.4665+36000.7698*t;
  ls:=218.3165+481267.8813*t;

  (* correction due to nutation *)
  delta_epsilon:=9.20*cos_d(omega)+0.57*cos_d(2*l)+0.10*cos_d(2*ls)-0.09*cos_d(2*omega);
  (*@\\\0000000201*)
(*$else *)
  (*@/// delta_epsilon - higher accuracy *)
  (* mean elongation of moon to sun *)
  d:=calc_poly_IAU(date,pt_moon_elongation,poly_full_order);
  (* mean anomaly of the sun *)
  m:=calc_poly_IAU(date,pt_sun_anomaly,poly_full_order);
  (* mean anomaly of the moon *)
  ms:=calc_poly_IAU(date,pt_moon_anomaly,poly_full_order);
  (* argument of the latitude of the moon *)
  f:=calc_poly_IAU(date,pt_moon_argument,poly_full_order);

  delta_epsilon:=0;

  for i:=low(nutation_terms) to high(nutation_terms) do begin
    s:= nutation_terms[i].d*d
       +nutation_terms[i].m*m
       +nutation_terms[i].ms*ms
       +nutation_terms[i].f*f
       +nutation_terms[i].o*omega;
    delta_epsilon:=delta_epsilon+(nutation_terms[i].eps+nutation_terms[i].eps_t*t*0.1)*cos_d(s);
    end;

  delta_epsilon:=delta_epsilon*0.0001;
  (*@\\\*)
(*$endif *)

  result:=delta_epsilon/3600;
  end;
(*@\\\0000001201*)
(*@/// function MeanEclipticObliquity(date:TdateTime):extended; *)
function MeanEclipticObliquity(date:TdateTime):extended;
var
  t,epsilon_0: extended;
(*$ifndef low_accuracy *)
  u: extended;
(*$endif *)
begin
  t:=Century_term(date);
(*$ifdef low_accuracy *)
  epsilon_0:=84381.448+(-46.8150+(-0.00059+0.001813*t)*t)*t;
(*$else *)
  u:=t/100;
  epsilon_0:=84381.448+(-4680.93+(-1.55+(1999.25+(-51.38+(-249.67+(-39.90+
                       (7.12+(27.87+(5.79+2.45*u)*u)*u)*u)*u)*u)*u)*u)*u)*u;  (* Meeus 22.3 *)
(*$endif *)
  result:=epsilon_0/3600;
  end;
(*@\\\0000000E01*)
(*@/// function EclipticObliquity(date:TdateTime):extended; *)
function EclipticObliquity(date:TdateTime):extended;
begin
  result:=MeanEclipticObliquity(date)+Nutation_Obliquity(date);
  end;
(*@\\\000000010A*)

(*@/// class TCoordinateCalc(TObject) *)
(*@/// procedure TCoordinateCalc.SetDate(value: TDateTime); *)
procedure TCoordinateCalc.SetDate(value: TDateTime);
begin
  FDate:=value;
  end;
(*@\\\000000011A*)
(*@/// class function TCoordinateCalc.calc_coord(date: TDateTime):TVector; *)
class function TCoordinateCalc.calc_coord(date: TDateTime):TVector;
var
  obj: TCoordinateCalc;
begin
  obj:=NIL;
  try
    obj:=self.Create;
    obj.date:=date;
    result.r:=obj.radius;
    result.l:=obj.longitude;
    result.b:=obj.latitude;
    obj.FinishCalculation(result);
  finally
    obj.free;
    end;
  result.l:=put_in_360(result.l);
  end;
(*@\\\0000001001*)
(*@/// procedure TCoordinateCalc.FinishCalculation(var v:TVector); *)
procedure TCoordinateCalc.FinishCalculation(var v:TVector);
begin
  end;
(*@\\\000000013A*)
(*@/// function TCoordinateCalc.CalcParallax:extended; *)
function TCoordinateCalc.CalcParallax:extended;
begin
  result:=arcsin_d(sin_d(8.794/3600)/(Radius*RadiusUnit));
  end;
(*@\\\0000000301*)
(*@/// class function TCoordinateCalc.RadiusUnit:extended; *)
class function TCoordinateCalc.RadiusUnit:extended;
begin
  result:=1;
  end;
(*@\\\0000000110*)

(*@/// class function TCoordinateCalcMoon.RadiusUnit:extended; *)
class function TCoordinateCalcMoon.RadiusUnit:extended;
begin
  result:=AU;
  end;
(*@\\\*)
(*@\\\0000000701*)

(*@/// function PrecessionMatric_Equatorial(source_date, target_date: TDateTime):TMatrix; *)
function PrecessionMatric_Equatorial(source_date, target_date: TDateTime):TMatrix;
var
  t_start, t_end: extended;
  zeta,z,theta: extended;
begin
  t_start:=Century_term(source_date);
  t_end:=Century_term(target_date)-t_start;
  zeta:= ((2306.2181+(1.39656-0.000139*t_start)*t_start)+
          ((0.30188-0.000344*t_start)+0.017998*t_end)*t_end)*t_end/3600;
  z:=zeta+((0.79280+0.0004111*t_start+0.000205*t_end)*t_end)*t_end/3600;
  theta:=((2004.3109-(0.85330+0.000217*t_start)*t_start)-
          ((0.42665+0.000217*t_start)+0.041883*t_end)*t_end)*t_end/3600;
  result:=MatrixTimesMatrix(
    MatrixTimesMatrix(RotationMatrix_Z(-z),RotationMatrix_Y(theta)),
    RotationMatrix_Z(-zeta));
  end;
(*@\\\0000000E17*)
(*@/// procedure ConvertEquinox(source_date, target_date: TDateTime; var rektaszension,declination:extended); *)
(* Based upon chapter 21 (20) of Meeus *)
(* Based upon chapter 2.4 of Montenbruck/Pfleger *)
procedure ConvertEquinox(source_date, target_date: TDateTime; var rektaszension,declination:extended);
(*$ifdef meeus *)
(*@/// Meeus way *)
var
  t_start, t_end: extended;
  zeta,z,theta: extended;
  A,B,C: extended;
begin
  t_start:=Century_term(source_date);
  t_end:=Century_term(target_date)-t_start;
  zeta:= ((2306.2181+(1.39656-0.000139*t_start)*t_start)+
          ((0.30188-0.000344*t_start)+0.017998*t_end)*t_end)*t_end/3600;
  z:=    ((2306.2181+(1.39656-0.000139*t_start)*t_start)+
          ((1.09468+0.000066*t_start)+0.018203*t_end)*t_end)*t_end/3600;
  theta:=((2004.3109-(0.85330+0.000217*t_start)*t_start)-
          ((0.42665+0.000217*t_start)+0.041883*t_end)*t_end)*t_end/3600;
  A:=cos_d(declination)*sin_d(rektaszension+zeta);
  B:=cos_d(theta)*cos_d(declination)*cos_d(rektaszension+zeta)-sin_d(theta)*sin_d(declination);
  C:=sin_d(theta)*cos_d(declination)*cos_d(rektaszension+zeta)+cos_d(theta)*sin_d(declination);
  rektaszension:=arctan2_d(A,B)+z;
  declination:=arcsin_d(C);
  end;
(*@\\\0000000E01*)
(*$else *)
(*@/// Montenbruck/Pfleger way *)
var
  v: TVector;
begin
  v:=RadialVector(rektaszension,declination,1);
  v:=SphericalToRectangular(v);
  v:=MatrixTimesVector(PrecessionMatric_Equatorial(source_date,target_date),v);
  v:=RectangularToSpherical(v);
  rektaszension:=v.l;
  declination  :=v.b;
  end;
(*@\\\0000000606*)
(*$endif *)
(*@\\\003000070100070C00070C*)
(*@/// procedure ConvertEquinoxB1950toJ2000(var rektaszension,declination:extended); *)
procedure ConvertEquinoxB1950toJ2000(var rektaszension,declination:extended);
begin
  ConvertEquinox(Epoch_B1950,Epoch_J2000,rektaszension,declination);
  end;
(*@\\\0000000201*)
(*@/// procedure ConvertEquinoxDateToJ2000(date: TDateTime; var rektaszension,declination:extended); *)
procedure ConvertEquinoxDateToJ2000(date: TDateTime; var rektaszension,declination:extended);
begin
  ConvertEquinox(date,Epoch_J2000,rektaszension,declination);
  end;
(*@\\\0000000201*)
(*@/// procedure ConvertEquinoxJ2000toDate(date: TDateTime; var rektaszension,declination:extended); *)
procedure ConvertEquinoxJ2000toDate(date: TDateTime; var rektaszension,declination:extended);
begin
  ConvertEquinox(Epoch_J2000,date,rektaszension,declination);
  end;
(*@\\\0000000201*)

{ Misc }
(*@/// function Mean_star_time(date:TDateTime):extended; *)
{ Based upon 12 (11) of Meeus }

function Mean_star_time(date:TDateTime):extended;
var
  t: extended;
begin
  t:=Century_term(date);
{
  t:=(date-datetime_2000_01_01-frac(date))/36525;
  result:=100.46061837+t*(36000.770053608+t*(0.000387933-t/38710000));
  result:=result+360.0*frac(date)*1.00273790935;
  result:=result+delta_phi*cos_d(epsilon);
  result:=put_in_360(result);
}
  result:=put_in_360(280.46061837+360.98564736629*(date-datetime_2000_01_01-0.5)+
                     t*t*(0.000387933-t/38710000));
  end;
(*@\\\0000000F4D*)
(*@/// function star_time(date:TDateTime):extended;            // degrees *)
{ Based upon 12 (11) of Meeus }

function star_time(date:TDateTime):extended;
var
  delta_phi, epsilon: extended;
begin
  delta_phi:=Nutation_Longitude(date);
  epsilon:=EclipticObliquity(date);
  result:=put_in_360(Mean_star_time(date)+delta_phi*cos_d(epsilon));
  end;
(*@\\\*)

{ Convert dynamic equinox of VSOP/ELP to FK5 (standard equinox of date }
{ Based upon chapter 32 (31) of Meeus }
(*@/// function DynamicToFK5(Date:TDateTime; v:TVector):TVector; *)
function DynamicToFK5(Date:TDateTime; v:TVector):TVector;
(*@/// approximation as in Meeus 32.3 *)
var
  lprime,t: extended;
  delta_l, delta_b: extended;
begin
  t:=century_term(date);
  lprime:=v.l+(-1.397-0.00031*t)*t;
  delta_l:=-(0.09033/3600)+(0.03916/3600)*(cos_d(lprime)+sin_d(lprime))*tan_d(v.b);
  delta_b:=(0.03916/3600)*(cos_d(lprime)-sin_d(lprime));
  result.l:=v.l+delta_l;
  result.b:=v.b+delta_b;
  result.r:=v.r;
  end;
(*@\\\0000000501*)
(*$ifdef zero *)
(*@/// function InertialJ2000toFK5:TMatrix; *)
function InertialJ2000toFK5:TMatrix;
begin
  with result do begin
//    xx:= 1.000000000000; xy:= 0.000000437913; xz:=-0.000000189859;
//    yx:=-0.000000477299; yy:= 0.917482137607; yz:=-0.397776981701;
//    zx:= 0.000000000000; zy:= 0.397776981701; zz:= 0.917482137607;
    xx:=+1.000000000000; yx:=+0.000000440360; zx:=-0.000000190919;
    xy:=-0.000000479966; yy:=+0.917482137087; zy:=-0.397776982902;
    xz:= 0.000000000000; yz:=+0.397776982902; zz:=+0.917482137087;
    end;
  end;
(*@\\\0000000401*)
begin
  result:=SphericalToRectangular(v);
  result:=MatrixTimesVector(PrecessionMatric_Equatorial(date,Epoch_J2000),result);
  result:=MatrixTimesVector(InertialJ2000toFK5,result);
  result:=MatrixTimesVector(PrecessionMatric_Equatorial(Epoch_J2000,date),result);
  result:=RectangularToSpherical(result);
  end;
(*$endif *)
(*@\\\0000000401*)

{ Coordinate transformation }
{ Based upon Chapter 13 (12) of Meeus }
(*@/// procedure EclipticToEquatorial_(date: TDateTime; latitude, longitude: extended; ...); *)
procedure EclipticToEquatorial_(date: TDateTime; latitude, longitude: extended; var rektaszension,declination: extended; mean: boolean);
var
  epsilon: extended;
(*$ifndef meeus *)
  v: TVector;
(*$endif *)
begin
  if mean then
    epsilon:=MeanEclipticObliquity(date)
  else
    epsilon:=EclipticObliquity(date);
(*$ifdef meeus *)
  rektaszension:=arctan2_d( sin_d(longitude)*cos_d(epsilon)
                           -tan_d(latitude)*sin_d(epsilon)
                           ,cos_d(longitude));
  declination:=arcsin_d( sin_d(latitude)*cos_d(epsilon)
                        +cos_d(latitude)*sin_d(epsilon)*sin_d(longitude));
(*$else *)
  v:=RadialVector(longitude,latitude,1);
  v:=SphericalToRectangular(v);
  v:=MatrixTimesVector(RotationMatrix_X(-epsilon),v);
  v:=RectangularToSpherical(v);
  rektaszension:=v.l;
  declination  :=v.b;
(*$endif *)
  end;
(*@\\\0000001501*)
(*@/// procedure EclipticToEquatorial(date: TDateTime; latitude, longitude: extended; ...); *)
procedure EclipticToEquatorial(date: TDateTime; latitude, longitude: extended; var rektaszension,declination: extended);
begin
  EclipticToEquatorial_(date,latitude,longitude,rektaszension,declination,false);
  end;
(*@\\\0000000401*)
(*@/// procedure MeanEclipticToEquatorial(date: TDateTime; latitude, longitude: extended; ...); *)
procedure MeanEclipticToEquatorial(date: TDateTime; latitude, longitude: extended; var rektaszension,declination: extended);
begin
  EclipticToEquatorial_(date,latitude,longitude,rektaszension,declination,true);
  end;
(*@\\\*)
(*@/// procedure EquatorialToEcliptic_(date: TDateTime; rektaszension,declination: extended; ...); *)
procedure EquatorialToEcliptic_(date: TDateTime; rektaszension,declination: extended; var latitude, longitude: extended; mean: boolean);
var
  epsilon: extended;
(*$ifndef meeus *)
  v: TVector;
(*$endif *)
begin
  if mean then
    epsilon:=MeanEclipticObliquity(date)
  else
    epsilon:=EclipticObliquity(date);
(*$ifdef meeus *)
  longitude:=arctan2_d( sin_d(rektaszension)*cos_d(epsilon)
                       +tan_d(declination)*sin_d(epsilon)
                       ,cos_d(rektaszension));
  latitude:=arcsin_d( sin_d(declination)*cos_d(epsilon)
                     -cos_d(declination)*sin_d(epsilon)*sin_d(rektaszension));
(*$else *)
  v:=RadialVector(rektaszension,declination,1);
  v:=SphericalToRectangular(v);
  v:=MatrixTimesVector(RotationMatrix_X(epsilon),v);
  v:=RectangularToSpherical(v);
  longitude:=v.l;
  latitude :=v.b;
(*$endif *)

  end;
(*@\\\0000001801*)
(*@/// procedure EquatorialToEcliptic(date: TDateTime; rektaszension,declination: extended; ...); *)
procedure EquatorialToEcliptic(date: TDateTime; rektaszension,declination: extended; var latitude, longitude: extended);
begin
  EquatorialToEcliptic_(date,rektaszension,declination,latitude,longitude,false);
  end;
(*@\\\0000000401*)
(*@/// procedure EquatorialToMeanEcliptic(date: TDateTime; rektaszension,declination: extended; ...); *)
procedure EquatorialToMeanEcliptic(date: TDateTime; rektaszension,declination: extended; var latitude, longitude: extended);
begin
  EquatorialToEcliptic_(date,rektaszension,declination,latitude,longitude,true);
  end;
(*@\\\000000034E*)
(*@/// procedure EquatorialToHorizontal(date: TDateTime; rektaszension,declination: extended; ... ); *)
procedure EquatorialToHorizontal(date: TDateTime; rektaszension,declination: extended;
                                 observer_latitude,observer_longitude: extended;
                                 var elevation,azimuth: extended);
var
  h: extended;
(*$ifndef meeus *)
  v: TVector;
(*$endif *)
begin
  h:=put_in_360(star_time(date)-rektaszension-observer_longitude);
(*$ifdef meeus *)
  azimuth:=put_in_360(arctan2_d(sin_d(h),
                     cos_d(h)*sin_d(observer_latitude)-
                     tan_d(declination)*cos_d(observer_latitude) ));
  elevation:=arcsin_d(sin_d(observer_latitude)*sin_d(declination)+
                      cos_d(observer_latitude)*cos_d(declination)*cos_d(h));
(*$else *)
  v:=RadialVector(h,declination,1);
  v:=SphericalToRectangular(v);
  v:=MatrixTimesVector(RotationMatrix_Y(90-observer_latitude),v);
  v:=RectangularToSpherical(v);
  azimuth  :=v.l;
  elevation:=v.b;
(*$endif *)
  end;
(*@\\\0000000601*)
(*@/// procedure HorizontalToEquatorial(date: TDateTime; elevation,azimuth: extended; ... ); *)
procedure HorizontalToEquatorial(date: TDateTime; elevation,azimuth: extended;
                                 observer_latitude,observer_longitude: extended;
                                 var rektaszension,declination: extended);
var
(*$ifdef meeus *)
  h: extended;
(*$else *)
  v: TVector;
(*$endif *)
begin
(*$ifdef meeus *)
  h:=arctan2_d(sin_d(azimuth),
               cos_d(azimuth)*sin_d(observer_latitude)+
               tan_d(elevation)*cos_d(observer_latitude) );
  rektaszension:=put_in_360(star_time(date)-observer_longitude-h);
  declination:=arcsin_d(sin_d(observer_latitude)*sin_d(elevation)-
                        cos_d(observer_latitude)*cos_d(elevation)*cos_d(azimuth));
(*$else *)
  v:=RadialVector(azimuth,elevation,1);
  v:=SphericalToRectangular(v);
  v:=MatrixTimesVector(RotationMatrix_Y(-(90-observer_latitude)),v);
  v:=RectangularToSpherical(v);
  rektaszension:=put_in_360(star_time(date)-observer_longitude-v.l);
  declination:=v.b;
(*$endif *)
  end;
(*@\\\*)

(*@/// procedure EclipticToHorizontal(date: TDateTime; latitude, longitude: extended; ... ); *)
procedure EclipticToHorizontal(date: TDateTime; latitude, longitude: extended;
                               observer_latitude,observer_longitude: extended;
                               var elevation,azimuth: extended);
var
  rektaszension,declination: extended;
begin
  EclipticToEquatorial(date,latitude,longitude,rektaszension,declination);
  EquatorialToHorizontal(date,rektaszension,declination,
    observer_latitude,observer_longitude,elevation,azimuth);
  end;
(*@\\\*)
(*@/// procedure HorizontalToEcliptic(date: TDateTime; elevation,azimuth: extended; ... ); *)
procedure HorizontalToEcliptic(date: TDateTime; elevation,azimuth: extended;
                               observer_latitude,observer_longitude: extended;
                               var latitude, longitude: extended);
var
  rektaszension,declination: extended;
begin
  HorizontalToEquatorial(date,elevation,azimuth,
    observer_latitude,observer_longitude,rektaszension,declination);
  EquatorialToEcliptic(date,rektaszension,declination,latitude,longitude);
  end;
(*@\\\0000000845*)

(*@/// procedure Aberation(date: TDateTime; sun_longitude: extended; var latitude,longitude:extended=; *)
{ procedure Aberation(date: TDateTime; sun_longitude: extended; var latitude,longitude:extended=; }
{ const }
{   k = 20.49552/3600; }
{ var }
{   p, e, t: extended; }
{   d_l, d_b: extended; }
{ begin }
{   t:=century_term(date); }
{   e:=0.016708634+(-0.000042037-0.0000001267*t)*t; }
{   p:=102.93735+(1.71946+0.00046*t)*t; }
{   d_l:=(-k*cos_d(sun_longitude-longitude)+e*k*cos_d(p-longitude))/cos_d(latitude); }
{   d_b:=-k*sin_d(latitude)*(sin_d(sun_longitude-longitude)-e*sin_d(p-longitude)); }
{   longitude:=longitude+d_l; }
{   latitude:=latitude+d_b; }
{   end; }
(*@\\\0000000F01*)
(*@\\\000C000401000501003801*)
(*@/// initialization *)
(*$ifdef delphi_1 *)
begin
(*$else *)
initialization
(*$endif *)
  datetime_2000_01_01:=Encodedate(2000,1,1);
  Epoch_B1900:=EncodeDate(1899,12,31)+0.8135;
  Epoch_B1950:=EncodeDate(1949,12,31)+0.9235;
  Epoch_J2000:=datetime_2000_01_01+0.5;
  Epoch_J2050:=EncodeDate(2050,1,1)+0.5;
(*@\\\*)
(*$ifdef delphi_ge_2 *) (*$warnings off *) (*$endif *)
end.
(*@\\\0003000905000011000905*)
