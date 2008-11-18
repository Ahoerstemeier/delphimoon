unit moon;

(*$define component *)

{ Copyright 1997 Andreas Hörstemeier                 Version 1.0 1997-04-03  }
{ this component is public domain - please check the file readme.txt for     }
{ more detailed info on usage and distributing                               }

{ Algorithms taken from the book "Astronomical Algorithms" by Jean Meeus     }

(*@/// interface *)
interface

uses
(*$ifdef ver90 *)
  math,
(*$endif *)
(*$ifdef component *)
(*$ifdef ver90 *)
  windows,
(*$else *)
  winprocs,
  wintypes,
(*$endif *)
  messages,
  graphics,
  classes,
  controls,
  extctrls,
(*$endif *)
  sysutils;

(*$ifdef component *)
  {$r *.res }            { The File containing the bitmaps }
(*$endif *)

type
  TMoonPhase=(Newmoon,FirstQuarter,Fullmoon,LastQuarter);


{ Functions as needed for a MoonTool clone }

function julian_date(date:TDateTime):extended;

function sun_distance(date:TDateTime): extended;
function moon_distance(date:TDateTime): extended;
function age_of_moon(date:TDateTime): extended;

function last_phase(date:TDateTime; phase:TMoonPhase):TDateTime;
function next_phase(date:TDateTime; phase:TMoonPhase):TDateTime;

function current_phase(date:TDateTime):extended;
function lunation(date:TDateTime):integer;

function sun_diameter(date:TDateTime):extended;
function moon_diameter(date:TDateTime):extended;

(*$ifdef component *)
type
  TMoonSize=(ms64,ms32);
(*@///   TMoon=class(TImage) *)
TMoon=class(TImage)
private
  FBMP : TBitmap;
  FMaxWidth,FMaxHeight: integer;
  FMoonSize: TMoonSize;
  FAngle: extended;
  FDate: TDateTime;
  FDateChanged: boolean;
  procedure Set_Size(Value:TMoonSize);
  procedure SetDate(value:TDateTime);
  procedure DoNothing(value:TPicture);
protected
  procedure SetBitmap;
  procedure Draw_Moon;
  procedure WMSize (var Message: TWMSize); message wm_paint;
public
  constructor Create(AOwner:TComponent); override;
published
  property MoonSize:TMoonSize read FMoonSize write Set_Size;
  property Date: TDateTime read FDate write SetDate stored FDateChanged;
  property Picture write donothing stored false;
  end;
(*@\\\003000080300080F000803*)

procedure Register;
(*$endif *)
(*@\\\000000320C*)
(*@/// implementation *)
implementation

const
  AU=149597869;             (* astronomical unit in km *)
  mean_lunation=29.530589;  (* Mean length of a month *)

type
(*@///   t_coord = record *)
t_coord = record
  longitude, latitude, radius: extended;
  rektaszension, declination: extended;
  end;
(*@\\\0000000201*)

(*@/// function put_in_360(x:extended):extended; *)
function put_in_360(x:extended):extended;
begin
  result:=x-round(x/360)*360;
  while result<0 do result:=result+360;
  end;
(*@\\\0000000401*)

(*$ifndef ver90 *)
{ D1 has no unit math, so here are the needed functions }
(*@/// function arctan2(a,b:extended):extended; *)
function arctan2(a,b:extended):extended;
begin
  result:=arctan(a/b);
  if b<0 then result:=result+pi;
  end;
(*@\\\0000000301*)
(*@/// function arcsin(x:extended):extended; *)
function arcsin(x:extended):extended;
begin
  result:=arctan(x/sqrt(1-x*x));
  end;
(*@\\\0000000301*)
(*@/// function arccos(x:extended):extended; *)
function arccos(x:extended):extended;
begin
  result:=pi/2-arcsin(x);
  end;
(*@\\\0000000301*)
(*$endif *)

{ Angular functions with degrees }
(*@/// function sin_d(x:extended):extended; *)
function sin_d(x:extended):extended;
begin
  sin_d:=sin(put_in_360(x)*pi/180);
  end;
(*@\\\000000030A*)
(*@/// function cos_d(x:extended):extended; *)
function cos_d(x:extended):extended;
begin
  cos_d:=cos(put_in_360(x)*pi/180);
  end;
(*@\\\0000000301*)
(*@/// function arctan2_d(a,b:extended):extended; *)
function arctan2_d(a,b:extended):extended;
begin
  result:=arctan2(a,b)*180/pi;
  end;
(*@\\\*)
(*@/// function arcsin_d(x:extended):extended; *)
function arcsin_d(x:extended):extended;
begin
  result:=arcsin(x)*180/pi;
  end;
(*@\\\0000000301*)

{ Julian date }
(*@/// function julian_date(date:TDateTime):extended; *)
function julian_date(date:TDateTime):extended;
begin
  if date>encodedate(1582,10,14) then
    julian_date:=2451544.5-encodedate(2000,1,1)+date
  else
    julian_date:=0;   { not yet implemented !!! }
  end;
(*@\\\0000000601*)
(*@/// function delphi_date(juldat:extended):TDateTime; *)
function delphi_date(juldat:extended):TDateTime;
begin
  if juldat>=julian_date(encodedate(1582,10,15)) then begin
    delphi_date:= juldat-2451544.5+encodedate(2000,1,1);
    end
  else
    delphi_date:=0;    { not yet implemented !!! }
  end;
(*@\\\0000000701*)

{ Coordinate functions }
(*@/// procedure calc_geocentric(var coord:t_coord; date:TDateTime); *)
{ Based upon Chapter 21 of Meeus }

procedure calc_geocentric(var coord:t_coord; date:TDateTime);
var
  t,o,omega,l,ls,
  epsilon,epsilon_0,delta_epsilon,
{   delta_phi, }
  alpha,delta: extended;
begin
  t:=(julian_date(date)-2451545.0)/36525;

  o:=coord.longitude;

  (* mean longitude of sun (l) and moon (ls) *)
  l:=280.4665+36000.7698*t;
  ls:=218.3165+481267.8813*t;

  (* longitude of rising knot *)
  omega:=125.04452+(-1934.136261+(0.0020708+1/450000*t)*t)*t;

  (* angle of ecliptic *)
  epsilon_0:=84381.448+(-46.8150+(-0.00059+0.001813*t)*t)*t;

  (* correction due to nutation *)
  delta_epsilon:=9.20*cos_d(omega)+0.57*cos_d(2*l)+0.10*cos_d(2*ls)-0.09*cos_d(2*omega);
  epsilon:=(epsilon_0+delta_epsilon)/3600;

  (* longitude correction due to nutation *)
{   delta_phi:=(-17.20*sin_d(omega)-1.32*sin_d(2*l)-0.23*sin_d(2*ls)+0.21*sin_d(2*omega))/3600; }

  (* geocentric coordinates *)
  alpha:=arctan2_d(cos_d(epsilon)*sin_d(o),cos_d(o));
  delta:=arcsin_d(sin_d(epsilon)*sin_d(o));

  coord.rektaszension:=alpha;
  coord.declination:=delta;
  end;
(*@\\\0000000801*)

(*@/// function sun_coordinate(date:TDateTime):t_coord; *)
{ Based upon Chapter 24 of Meeus }

function sun_coordinate(date:TDateTime):t_coord;
var
  t,e,m,c,nu: extended;
  l0,o,omega,lambda: extended;
begin
  t:=(julian_date(date)-2451545.0)/36525;

  (* geometrical mean longitude of the sun *)
  l0:=280.46645+(36000.76983+0.0003032*t)*t;

  (* excentricity of the erath orbit *)
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
  omega:=125.04452+(-1934.136261+(0.0020708+1/450000*t)*t)*t;
  lambda:=put_in_360(o-0.00569-0.00478*sin_d(omega));

  result.longitude:=o;
  result.latitude:=lambda;

  calc_geocentric(result,date);
  end;
(*@\\\0000000301*)
(*@/// function moon_coordinate(date:TDateTime):t_coord; *)
{ Based upon Chapter 45 of Meeus }

function moon_coordinate(date:TDateTime):t_coord;
const
(*@///   arg_lr:array[0..59,0..3] of integer = (..); *)
arg_lr:array[0..59,0..3] of integer = (
   ( 0, 0, 1, 0),
   ( 2, 0,-1, 0),
   ( 2, 0, 0, 0),
   ( 0, 0, 2, 0),
   ( 0, 1, 0, 0),
   ( 0, 0, 0, 2),
   ( 2, 0,-2, 0),
   ( 2,-1,-1, 0),
   ( 2, 0, 1, 0),
   ( 2,-1, 0, 0),
   ( 0, 1,-1, 0),
   ( 1, 0, 0, 0),
   ( 0, 1, 1, 0),
   ( 2, 0, 0,-2),
   ( 0, 0, 1, 2),
   ( 0, 0, 1,-2),
   ( 4, 0,-1, 0),
   ( 0, 0, 3, 0),
   ( 4, 0,-2, 0),
   ( 2, 1,-1, 0),
   ( 2, 1, 0, 0),
   ( 1, 0,-1, 0),
   ( 1, 1, 0, 0),
   ( 2,-1, 1, 0),
   ( 2, 0, 2, 0),
   ( 4, 0, 0, 0),
   ( 2, 0,-3, 0),
   ( 0, 1,-2, 0),
   ( 2, 0,-1, 2),
   ( 2,-1,-2, 0),
   ( 1, 0, 1, 0),
   ( 2,-2, 0, 0),
   ( 0, 1, 2, 0),
   ( 0, 2, 0, 0),
   ( 2,-2,-1, 0),
   ( 2, 0, 1,-2),
   ( 2, 0, 0, 2),
   ( 4,-1,-1, 0),
   ( 0, 0, 2, 2),
   ( 3, 0,-1, 0),
   ( 2, 1, 1, 0),
   ( 4,-1,-2, 0),
   ( 0, 2,-1, 0),
   ( 2, 2,-1, 0),
   ( 2, 1,-2, 0),
   ( 2,-1, 0,-2),
   ( 4, 0, 1, 0),
   ( 0, 0, 4, 0),
   ( 4,-1, 0, 0),
   ( 1, 0,-2, 0),
   ( 2, 1, 0,-2),
   ( 0, 0, 2,-2),
   ( 1, 1, 1, 0),
   ( 3, 0,-2, 0),
   ( 4, 0,-3, 0),
   ( 2,-1, 2, 0),
   ( 0, 2, 1, 0),
   ( 1, 1,-1, 0),
   ( 2, 0, 3, 0),
   ( 2, 0,-1,-2)
                 );
(*@\\\*)
(*@///   arg_b:array[0..59,0..3] of integer = (); *)
arg_b:array[0..59,0..3] of integer = (
   ( 0, 0, 0, 1),
   ( 0, 0, 1, 1),
   ( 0, 0, 1,-1),
   ( 2, 0, 0,-1),
   ( 2, 0,-1, 1),
   ( 2, 0,-1,-1),
   ( 2, 0, 0, 1),
   ( 0, 0, 2, 1),
   ( 2, 0, 1,-1),
   ( 0, 0, 2,-1),  (* !!! Error in German Meeus *)
   ( 2,-1, 0,-1),
   ( 2, 0,-2,-1),
   ( 2, 0, 1, 1),
   ( 2, 1, 0,-1),
   ( 2,-1,-1, 1),
   ( 2,-1, 0, 1),
   ( 2,-1,-1,-1),
   ( 0, 1,-1,-1),
   ( 4, 0,-1,-1),
   ( 0, 1, 0, 1),
   ( 0, 0, 0, 3),
   ( 0, 1,-1, 1),
   ( 1, 0, 0, 1),
   ( 0, 1, 1, 1),
   ( 0, 1, 1,-1),
   ( 0, 1, 0,-1),
   ( 1, 0, 0,-1),
   ( 0, 0, 3, 1),
   ( 4, 0, 0,-1),
   ( 4, 0,-1, 1),
   ( 0, 0, 1,-3),
   ( 4, 0,-2, 1),
   ( 2, 0, 0,-3),
   ( 2, 0, 2,-1),
   ( 2,-1, 1,-1),
   ( 2, 0,-2, 1),
   ( 0, 0, 3,-1),
   ( 2, 0, 2, 1),
   ( 2, 0,-3,-1),
   ( 2, 1,-1, 1),
   ( 2, 1, 0, 1),
   ( 4, 0, 0, 1),
   ( 2,-1, 1, 1),
   ( 2,-2, 0,-1),
   ( 0, 0, 1, 3),
   ( 2, 1, 1,-1),
   ( 1, 1, 0,-1),
   ( 1, 1, 0, 1),
   ( 0, 1,-2,-1),
   ( 2, 1,-1,-1),
   ( 1, 0, 1, 1),
   ( 2,-1,-2,-1),
   ( 0, 1, 2, 1),
   ( 4, 0,-2,-1),
   ( 4,-1,-1,-1),
   ( 1, 0, 1,-1),
   ( 4, 0, 1,-1),
   ( 1, 0,-1,-1),
   ( 4,-1, 0,-1),
   ( 2,-2, 0, 1)
  );
(*@\\\*)
(*@///   sigma_r: array[0..59] of longint = (..); *)
sigma_r: array[0..59] of longint = (
 -20905355,
  -3699111,
  -2955968,
   -569925,
     48888,
     -3149,
    246158,
   -152138,
   -170733,
   -204586,
   -129620,
    108743,
    104755,
     10321,
         0,
     79661,
    -34782,
    -23210,
    -21636,
     24208,
     30824,
     -8379,
    -16675,
    -12831,
    -10445,
    -11650,
     14403,
     -7003,
         0,
     10056,
      6322,
     -9884,
      5751,
         0,
     -4950,
      4130,
         0,
     -3958,
         0,
      3258,
      2616,
     -1897,
     -2117,
      2354,
         0,
         0,
     -1423,
     -1117,
     -1571,
     -1739,
         0,
     -4421,
         0,
         0,
         0,
         0,
      1165,
         0,
         0,
      8752
            );
(*@\\\0000003301*)
(*@///   sigma_l: array[0..59] of longint = (..); *)
sigma_l: array[0..59] of longint = (
  6288774,
  1274027,
   658314,
   213618,
  -185116,
  -114332,
    58793,
    57066,
    53322,
    45758,
   -40923,
   -34720,
   -30383,
    15327,
   -12528,
    10980,
    10675,
    10034,
     8548,
    -7888,
    -6766,
    -5163,
     4987,
     4036,
     3994,
     3861,
     3665,
    -2689,
    -2602,
     2390,
    -2348,
     2236,
    -2120,
    -2069,
     2048,
    -1773,
    -1595,
     1215,
    -1110,
     -892,
     -810,
      759,
     -713,
     -700,
      691,
      596,
      549,
      537,
      520,
     -487,
     -399,
     -381,
      351,
     -340,
      330,
      327,
     -323,
      299,
      294,
        0
  );
(*@\\\*)
(*@///   sigma_b: array[0..59] of longint = (..); *)
sigma_b: array[0..59] of longint = (
  5128122,
   280602,
   277693,
   173237,
    55413,
    46271,
    32573,
    17198,
     9266,
     8822,
     8216,
     4324,
     4200,
    -3359,
     2463,
     2211,
     2065,
    -1870,
     1828,
    -1794,
    -1749,
    -1565,
    -1491,
    -1475,
    -1410,
    -1344,
    -1335,
     1107,
     1021,
      833,
      777,
      671,
      607,
      596,
      491,
     -451,
      439,
      422,
      421,
     -366,
     -351,
      331,
      315,
      302,
     -283,
     -229,
      223,
      223,
     -220,
     -220,
     -185,
      181,
     -177,
      176,
      166,
     -164,
      132,
     -119,
      115,
      107
  );
(*@\\\0000003E05*)
var
  t,d,m,ms,f,e,ls : extended;
  sr,sl,sb,temp: extended;
  a1,a2,a3: extended;
  lambda,beta,delta: extended;
  i: integer;
begin
  t:=(julian_date(date)-2451545)/36525;

  (* mean elongation of the moon *)
  d:=297.8502042+(445267.1115168+(-0.0016300+(1/545868-1/113065000*t)*t)*t)*t;

  (* mean anomaly of the sun *)
  m:=357.5291092+(35999.0502909+(-0.0001536+1/24490000*t)*t)*t;

  (* mean anomaly of the moon *)
  ms:=134.9634114+(477198.8676313+(0.0089970+(1/69699-1/1471200*t)*t)*t)*t;

  (* argument of the longitude of the moon *)
  f:=93.2720993+(483202.0175273+(-0.0034029+(-1/3526000+1/863310000*t)*t)*t)*t;

  (* correction term due to excentricity of the earth orbit *)
  e:=1.0+(-0.002516-0.0000074*t)*t;

  (* mean longitude of the moon *)
  ls:=218.3164591+(481267.88134236+(-0.0013268+(1/538841-1/65194000*t)*t)*t)*t;

  (* arguments of correction terms *)
  a1:=119.75+131.849*t;
  a2:=53.09+479264.290*t;
  a3:=313.45+481266.484*t;

(*@///   sr := ä r_i cos(d,m,ms,f);   !!!  gives different value than in Meeus *)
sr:=0;
for i:=0 to 59 do begin
  temp:=sigma_r[i]*cos_d( arg_lr[i,0]*d
                         +arg_lr[i,1]*m
                         +arg_lr[i,2]*ms
                         +arg_lr[i,3]*f);
  if abs(arg_lr[i,1])=1 then temp:=temp*e;
  if abs(arg_lr[i,1])=2 then temp:=temp*e;
  sr:=sr+temp;
  end;
(*@\\\0000000201*)
(*@///   sl := ä l_i sin(d,m,ms,f); *)
sl:=0;
for i:=0 to 59 do begin
  temp:=sigma_l[i]*sin_d( arg_lr[i,0]*d
                         +arg_lr[i,1]*m
                         +arg_lr[i,2]*ms
                         +arg_lr[i,3]*f);
  if abs(arg_lr[i,1])=1 then temp:=temp*e;
  if abs(arg_lr[i,1])=2 then temp:=temp*e;
  sl:=sl+temp;
  end;

(* correction terms *)
sl:=sl +3958*sin_d(a1)
       +1962*sin_d(ls-f)
        +318*sin_d(a2);
(*@\\\0000000B01*)
(*@///   sb := ä b_i sin(d,m,ms,f); *)
sb:=0;
for i:=0 to 59 do begin
  temp:=sigma_b[i]*sin_d( arg_b[i,0]*d
                         +arg_b[i,1]*m
                         +arg_b[i,2]*ms
                         +arg_b[i,3]*f);
  if abs(arg_b[i,1])=1 then temp:=temp*e;
  if abs(arg_b[i,1])=2 then temp:=temp*e;
  sb:=sb+temp;
  end;

(* correction terms *)
sb:=sb -2235*sin_d(ls)
        +382*sin_d(a3)
        +175*sin_d(a1-f)
        +175*sin_d(a1+f)
        +127*sin_d(ls-ms)
        -115*sin_d(ls+ms);
(*@\\\0000001216*)

  lambda:=ls+sl/1000000;
  beta:=sb/1000000;
  delta:=385000.56+sr/1000;

  result.radius:=delta;
  result.longitude:=lambda;  (* I ignore the correction delta_phi *)
  result.latitude:=beta;

  calc_geocentric(result,date);
  end;
(*@\\\0000000701*)

{ Moon phases and age of the moon }
(*@/// function nextphase(date:TDateTime; phase:TMoonPhase):TDateTime; *)
{ Based upon Chapter 47 of Meeus }

function nextphase(date:TDateTime; phase:TMoonPhase):TDateTime;
var
  t: extended;
  k: longint;
  kk: extended;
  jde: extended;
  ts: extended;
  m,ms,f,o,e: extended;
  korr,w,akorr: extended;
  a:array[1..14] of extended;
begin
  k:=round((date-encodedate(2000,1,1))/36525.0*1236.85);
  ts:=(date-encodedate(2000,1,1))/36525.0;
  kk:=int(k)+ord(phase)/4.0;
  t:=kk/1236.85;
  jde:=2451550.09765+29.530588853*kk
       +t*t*(0.0001337-t*(0.000000150-0.00000000073*t));
  m:=2.5534+29.10535669*kk-t*t*(0.0000218+0.00000011*t);
  ms:=201.5643+385.81693528*kk+t*t*(0.1017438+t*(0.00001239-t*0.000000058));
  f:= 160.7108+390.67050274*kk-t*t*(0.0016341+t*(0.00000227-t*0.000000011));
  o:=124.7746-1.56375580*kk+t*t*(0.0020691+t*0.00000215);
  e:=1-ts*(0.002516+ts*0.0000074);
  case phase of
(*@///     Newmoon: *)
Newmoon:
begin
  korr:= -0.40720*sin_d(ms)
         +0.17241*e*sin_d(m)
         +0.01608*sin_d(2*ms)
         +0.01039*sin_d(2*f)
         +0.00739*e*sin_d(ms-m)
         -0.00512*e*sin_d(ms+m)
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
         +0.00002*sin_d(4*ms);
  end;
(*@\\\0000000307*)
(*@///     FirstQuarter,LastQuarter: *)
FirstQuarter,LastQuarter:
begin
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
(*@///     Fullmoon: *)
Fullmoon:
begin
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
         +0.00002*sin_d(4*ms);
  end;
(*@\\\*)
(*@///     else *)
else
  korr:=0;   (* Delphi 2 shut up! *)
(*@\\\*)
    end;
(*@///   Additional Corrections due to planets *)
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
  nextphase:=delphi_date(jde+korr);
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
    temp_date:=temp_date-28;
    end;
  end;
(*@\\\0000000303*)
(*@/// function next_phase(date:TDateTime; phase:TMoonPhase):TDateTime; *)
function next_phase(date:TDateTime; phase:TMoonPhase):TDateTime;
var
  temp_date: TDateTime;
begin
  temp_date:=date-28;
  result:=temp_date;
  while result<date do begin
    result:=nextphase(temp_date,phase);
    temp_date:=temp_date+28;
    end;
  end;
(*@\\\0000000919*)

(*@/// function moon_phase_angle(date: TDateTime):extended; *)
{ Based upon Chapter 46 of Meeus }

function moon_phase_angle(date: TDateTime):extended;
var
  sun_coord,moon_coord: t_coord;
  phi,i: extended;
begin
  sun_coord:=sun_coordinate(date);
  moon_coord:=moon_coordinate(date);
  phi:=arccos(cos_d(moon_coord.latitude)
             *cos_d(moon_coord.longitude-sun_coord.longitude));
  i:=arctan(sun_coord.radius*sin(phi)/
            (moon_coord.radius-sun_coord.radius*cos(phi)));
  if i<0 then  result:=i/pi*180+180
         else  result:=i/pi*180;

  if put_in_360(moon_coord.longitude-sun_coord.longitude)>180 then
    result:=-result;

  end;
(*@\\\*)
(*@/// function age_of_moon(date: TDateTime):extended; *)
function age_of_moon(date: TDateTime):extended;
var
  sun_coord,moon_coord: t_coord;
begin
  sun_coord:=sun_coordinate(date);
  moon_coord:=moon_coordinate(date);
  result:=put_in_360(moon_coord.longitude-sun_coord.longitude)/360*mean_lunation;
  end;
(*@\\\*)
(*@/// function current_phase(date:TDateTime):extended; *)
function current_phase(date:TDateTime):extended;
begin
  result:=(1+cos_d(moon_phase_angle(date)))/2;
  end;
(*@\\\0000000301*)

(*@/// function lunation(date:TDateTime):integer; *)
function lunation(date:TDateTime):integer;
begin
  result:=round((last_phase(date,NewMoon)-delphi_date(2423436))/mean_lunation)+1;
  end;
(*@\\\0000000301*)

{ The distances }
(*@/// function sun_distance(date: TDateTime): extended;    // AU *)
function sun_distance(date: TDateTime): extended;
begin
  result:=sun_coordinate(date).radius/au;
  end;
(*@\\\0000000301*)
(*@/// function moon_distance(date: TDateTime): extended;   // km *)
function moon_distance(date: TDateTime): extended;
begin
  result:=moon_coordinate(date).radius;
  end;
(*@\\\0000000301*)

{ The angular diameter (which is 0.5 of the subtent in moontool) }
(*@/// function sun_diameter(date:TDateTime):extended;     // angular seconds *)
function sun_diameter(date:TDateTime):extended;
begin
  result:=959.63/(sun_coordinate(date).radius/au)*2;
  end;
(*@\\\0000000335*)
(*@/// function moon_diameter(date:TDateTime):extended;    // angular seconds *)
function moon_diameter(date:TDateTime):extended;
begin
  result:=358473400/moon_coordinate(date).radius*2;
  end;
(*@\\\0000000334*)

(*$ifdef component *)
const
  ResString:array[TMoonSize] of string=('MOON_LARGE'#0,'MOON_SMALL'#0);
  size_moon:array[TMoonSize,0..4] of integer=
    ((64,64,28,31,28),
     (32,32,14,15,14));   { max_x,max_y,offset_y,offset_x,radius }
(*@/// constructor TMoon.Create(AOwner: TComponent); *)
constructor TMoon.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBMP := TBitmap.Create;  {Note dynamic allocation of the pointer}
  SetDate(now);
  FDateChanged:=false;
  Set_Size(ms64);
  end;
(*@\\\0000000617*)
(*@/// procedure TMoon.SetBitmap; *)
procedure TMoon.SetBitmap;
begin
  FBMP.Handle := LoadBitmap(hInstance, @ResString[FMoonSize][1]);
  Self.Picture.Graphic := FBMP as TGraphic;
  draw_moon;
  end;
(*@\\\0000000501*)
(*@/// procedure TMoon.WMSize(var Message: TWMSize); *)
procedure TMoon.WMSize(var Message: TWMSize);
begin
  inherited;
  if (csDesigning in ComponentState) then begin
    Width := FMaxWidth;
    Height := FMaxHeight;
    end;
  end;
(*@\\\0000000501*)
(*@/// procedure TMoon.Set_Size(Value:TMoonSize); *)
procedure TMoon.Set_Size(Value:TMoonSize);
begin
  FMoonSize:=value;
  FMaxHeight:=size_moon[FMoonSize,0];
  FMaxWidth:=size_moon[FMoonSize,1];
  Self.Height := FMaxHeight;
  Self.Width := FMaxWidth;
  setbitmap;
  end;
(*@\\\0000000501*)
(*@/// procedure TMoon.Draw_Moon; *)
procedure TMoon.Draw_Moon;
var
  Offset_x,offset_y,radius:integer;
  y,radius2: integer;
  xm,scale: extended;
  xmax,xmin:integer;
begin

(* FAngle = 0   -> New Moon
   FAngle = 90  -> First Quarter
   FAngle = 180 -> Full Moon
   FAngle = 270 -> Last Quarter *)

  Offset_y:=size_moon[FMoonSize,2];
  Offset_x:=size_moon[FMoonSize,3];
  Radius:=size_moon[FMoonSize,4];
  self.canvas.brush.color:=clBlack;
  radius2:=radius*radius;
  scale:=cos_d(fangle);
  for y:=0 to radius do begin
    xm:=sqrt(radius2-y*y);
    xmax:=round(xm);
    xmin:=round(xm*scale);
    if fangle<180 then begin
      xmax:=offset_x-xmax-1;
      xmin:=offset_x-xmin;
      end
    else begin
      xmax:=offset_x+xmax+1;
      xmin:=offset_x+xmin;
      end;
    self.canvas.moveto(xmin,y+offset_y);
    self.canvas.lineto(xmax,y+offset_y);
    self.canvas.moveto(xmin,-y+offset_y);
    self.canvas.lineto(xmax,-y+offset_y);
    end;
  end;
(*@\\\0000001D16*)
(*@/// procedure TMoon.SetDate(Value: TDateTime); *)
procedure TMoon.SetDate(Value: TDateTime);
begin
  FDate:=Value;
  FAngle:=put_in_360(moon_phase_angle(Value));
  setbitmap;
  draw_moon;
  FDateChanged:=true;
  end;
(*@\\\000C00070300070F000701*)
(*@/// procedure TMoon.DoNothing(value:TPicture); *)
procedure TMoon.DoNothing(value:TPicture);
begin
  end;
(*@\\\*)

(*@/// procedure Register; *)
procedure Register;
begin
  RegisterComponents('Custom', [TMoon]);
  end;
(*@\\\000000040F*)
(*$endif *)
(*@\\\000000410C*)
end.
(*@\\\0003000601000011000601*)
