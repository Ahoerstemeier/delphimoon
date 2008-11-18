unit moon_elp;

 {$i ah_def.inc }

(*$b-*)   { I may make use of the shortcut boolean eval }
(*$define meeus *)

(*@/// interface *)
interface

uses
  ah_math,
  moon_aux,
  sysutils;

function moon_coord(date:TdateTime):TVector;
(*@\\\000000082D*)
(*@/// implementation *)
implementation

const
  precession = 5029.0966/3600;

type
  (*@/// T_ELP_main = record .. end; *)
  T_ELP_main = record
    i1,i2,i3,i4: shortint;
    A: extended;                  (* arc seconds / kilometers *)
    end;
  (*@\\\0000000401*)
  (*@/// T_ELP_earth_figure = record .. end; *)
  T_ELP_earth_figure = record
    i1,i2,i3,i4,i5: shortint;
    phi: extended;                (* degrees *)
    A: extended;                  (* arc seconds / kilometers *)
    end;
  (*@\\\0000000201*)
  (*@/// T_ELP_planet = record .. end; *)
  T_ELP_planet = record
    i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i11: shortint;
    phi: extended;                (* degrees *)
    A: extended;                  (* arc seconds / kilometers *)
    end;
  (*@\\\0000000201*)
  (*@/// T_ELP_tide = record .. end; *)
  T_ELP_tide = record
    i2,i3,i4,i5: shortint;
    phi,A: extended;                  (* arc seconds / kilometers *)
    end;
  (*@\\\*)
  T_ELP_moon_figure = T_ELP_tide;
  T_ELP_relativistic = T_ELP_tide;
  (*@/// T_ELP_eccentricity = record .. end; *)
  T_ELP_eccentricity = record
    i2,i3,i4,i5: shortint;
    phi: word;
    A: extended;                  (* arc seconds / kilometers *)
    end;
  (*@\\\*)
  TELPCalcFuncMain = function (elp,index: integer):T_ELP_main of object;
  TELPCalcFuncEarthFigure = function (elp,index: integer):T_ELP_earth_figure of object;
  TELPCalcFuncPlanet = function (elp,index: integer):T_ELP_planet of object;
  TELPCalcFuncTide = function (elp,index: integer):T_ELP_tide of object;
  TELPCalcFuncMoonFigure = TELPCalcFuncTide;
  TELPCalcFuncRelativistic = TELPCalcFuncTide;
  TELPCalcFuncEccentricity = function (elp,index: integer):T_ELP_eccentricity of object;
  TPlanet = (mercury, venus, mars, jupiter, saturn, uranus, neptune);
  T_polynomial_term_planet=array[0..1] of extended;
  TTermValue=(v_longitude, v_latitude, v_radius);
  (*@/// TMoonELP=class(TCoordinateCalcMoon) *)
  TMoonELP=class(TCoordinateCalcMoon)
  protected
    function CalcLongitude:extended;  override;
    function CalcLatitude:extended;   Override;
    function CalcRadius:extended;     override;

    function MainProblem(term:TTermValue):extended;
    function earth_figure(term:TTermValue):extended;
    function planetary(term:TTermValue):extended;
    function tide(term:TTermValue):extended;         virtual;
    function moon_figure(term:TTermValue):extended;  virtual;
    function relativistic(term:TTermValue):extended; virtual;
    function eccentricity(term:TTermValue):extended; virtual;

    function PlanetaryTerm(planet: TPlanet): extended;

    (* ELP 1 to 3 *)
    function GetTermMain(elp,index:integer):T_ELP_main;  virtual; abstract;
    (* ELP 4 to 9 *)
    function GetTermEarthFigure(elp,index:integer):T_ELP_earth_figure;  virtual; abstract;
    (* ELP 10 to 21 *)
    function GetTermPlanet(elp,index:integer):T_ELP_planet;  virtual; abstract;
    (* ELP 22 to 27 *)
    function GetTermTide(elp,index:integer):T_ELP_tide;  virtual; abstract;
    (* ELP 28 to 30 *)
    function GetTermMoonFigure(elp,index:integer):T_ELP_Moon_figure;  virtual; abstract;
    (* ELP 31 to 33 *)
    function GetTermRelativistic(elp,index:integer):T_ELP_relativistic;  virtual; abstract;
    (* ELP 34 to 36 *)
    function GetTermEccentricity(elp,index:integer):T_ELP_Eccentricity;  virtual; abstract;

    (* Results are in arcseconds / kilometers *)
    function CalcMain(elp: integer; factor:TELPCalcFuncMain):extended;
    function CalcEarthFigure(elp: integer; factor:TELPCalcFuncEarthFigure):extended;
    function CalcMoonFigure(elp: integer; factor:TELPCalcFuncMoonFigure):extended;
    function CalcTide(elp: integer; factor:TELPCalcFuncTide):extended;
    function CalcPlanet(elp: integer; factor:TELPCalcFuncPlanet):extended;
    function CalcPlanet2(elp: integer; factor:TELPCalcFuncPlanet):extended;
    function CalcRelativistic(elp: integer; factor:TELPCalcFuncRelativistic):extended;
    function CalcEccentricity(elp: integer; factor:TELPCalcFuncEccentricity):extended;
    end;
  (*@\\\0000000110*)
  (*@/// TMoonELP_Meeus=class(TMoonELP) *)
  TMoonELP_Meeus=class(TMoonELP)
  protected
    EccentricityTerm: Extended;
    procedure SetDate(value: TDateTime);  override;
    function tide(term:TTermValue):extended;   override;
    function moon_figure(term:TTermValue):extended;  override;
    function relativistic(term:TTermValue):extended; override;
    function eccentricity(term:TTermValue):extended; override;

    function GetTermMain(elp,index:integer):T_ELP_main;  override;
    function GetTermEarthFigure(elp,index:integer):T_ELP_earth_figure;  override;
    function GetTermMoonFigure(elp,index:integer):T_ELP_Moon_figure;  override;
    function GetTermRelativistic(elp,index:integer):T_ELP_relativistic;  override;
    function GetTermTide(elp,index:integer):T_ELP_tide;  override;
    function GetTermPlanet(elp,index:integer):T_ELP_planet;  override;
    function GetTermEccentricity(elp,index:integer):T_ELP_Eccentricity;  override;
    end;
  (*@\\\0000000303*)

const
  (*@/// empty_ELP_* *)
  empty_ELP_main: T_ELP_main =
    (i1:0; i2:0; i3:0; i4:0; A:0);
  empty_ELP_earth_figure: T_ELP_earth_figure =
    (i1:0; i2:0; i3:0; i4:0; i5:0; phi:0; A:0);
  empty_ELP_planet: T_ELP_planet =
    (i1:0; i2:0; i3:0; i4:0; i5:0; i6:0; i7:0; i8:0; i9:0; i10:0; i11:0; phi:0; A:0);
  empty_ELP_tide: T_ELP_tide =
    (i2:0; i3:0; i4:0; i5:0; phi:0; A:0);
  empty_ELP_moon_figure: T_ELP_moon_figure =
    (i2:0; i3:0; i4:0; i5:0; phi:0; A:0);
  empty_ELP_relativistic: T_ELP_relativistic =
    (i2:0; i3:0; i4:0; i5:0; phi:0; A:0);
  empty_ELP_eccentricity: t_ELP_eccentricity =
    (i2:0; i3:0; i4:0; i5:0; phi:0; A:0);
  (*@\\\0000000501*)

(*@/// class TMoonELP(TCoordinateCalc) *)
(*@/// function TMoonELP.PlanetaryTerm(planet: TPlanet): extended; *)
function TMoonELP.PlanetaryTerm(planet: TPlanet): extended;
const
  poly: array[TPlanet] of T_polynomial_term_planet = (
    (252+15/60+03.25986/3600,538101628.68898/3600),   { Mercury (Me) }
    (181+58/60+47.28305/3600,210664136.43355/3600),   { Venus   (V)  }
    (355+25/60+59.78866/3600, 68905077.59284/3600),   { Mars    (Ma) }
    ( 34+21/60+05.34212/3600, 10925660.42861/3600),   { Jupiter (J)  }
    ( 50+04/60+38.89694/3600,  4399609.65932/3600),   { Saturn  (S)  }
    (314+03/60+18.01841/3600,  1542481.19393/3600),   { Uranus  (U)  }
    (304+20/60+55.19575/3600,   786550.32074/3600)    { Neptune (N)  }
  );
var
  t: extended;
begin
  t:=century_term(FDate);
  result:=poly[planet,0]+t*poly[planet,1];
  result:=put_in_360(result);
  end;
(*@\\\*)
(*@/// function TMoonELP.CalcLongitude:extended; *)
function TMoonELP.CalcLongitude:extended;
begin
  result:= calc_poly(FDate,pt_moon_longitude,poly_full_order)
          +MainProblem(v_longitude)/3600
          +earth_figure(v_longitude)/3600
          +planetary(v_longitude)/3600
          +tide(v_longitude)/3600
          +moon_figure(v_longitude)/3600
          +relativistic(v_longitude)/3600
          +eccentricity(v_longitude)/3600;
  end;
(*@\\\0000000A25*)
(*@/// function TMoonELP.CalcLatitude:extended; *)
function TMoonELP.CalcLatitude:extended;
begin
  result:= MainProblem(v_Latitude)/3600
          +earth_figure(v_Latitude)/3600
          +planetary(v_Latitude)/3600
          +tide(v_Latitude)/3600
          +moon_figure(v_Latitude)/3600
          +relativistic(v_Latitude)/3600
          +eccentricity(v_Latitude)/3600;
  end;
(*@\\\0000000924*)
(*@/// function TMoonELP.CalcRadius:extended; *)
function TMoonELP.CalcRadius:extended;
begin
  result:= MainProblem(v_Radius)
          +earth_figure(v_Radius)
          +planetary(v_Radius)
          +tide(v_Radius)
          +moon_figure(v_Radius)
          +relativistic(v_Radius)
          +eccentricity(v_Radius)
          ;
  end;
(*@\\\0000000A0C*)

(*@/// function TMoonELP.CalcMain(elp:integer; factor:TELPCalcFuncMain):extended; *)
function TMoonELP.CalcMain(elp:integer; factor:TELPCalcFuncMain):extended;
var
  D,F,ls,l: extended;
  i: integer;
  radius: boolean;
begin
  ls:=calc_poly(FDate,pt_sun_anomaly,poly_full_order);        (* Meeus M *)
  d:=calc_poly(FDate,pt_moon_elongation,poly_full_order);
  l:=calc_poly(FDate,pt_moon_anomaly,poly_full_order);        (* Meeus M' *)
  f:=calc_poly(FDate,pt_moon_argument,poly_full_order);
  radius:=(elp=3);
  result:=0;
  i:=0;
  while true do begin
    WITH factor(elp,i) do begin
      if radius then
        result:=result+A*cos_d(i1*D+i2*ls+i3*l+i4*f)
      else
        result:=result+A*sin_d(i1*D+i2*ls+i3*l+i4*f);
      if A=0 then BREAK;
      end;
    inc(i);
    end;
  end;
(*@\\\*)
(*@/// function TMoonELP.CalcEarthFigure(elp:integer; factor:TELPCalcFuncEarthFigure):extended; *)
function TMoonELP.CalcEarthFigure(elp:integer; factor:TELPCalcFuncEarthFigure):extended;
var
  cy,zeta,D,l,ls,F: extended;
  i: integer;
begin
  cy:=Century_term(FDate);
  d:=calc_poly(FDate,pt_moon_elongation,1);
  l:=calc_poly(FDate,pt_moon_anomaly,1);
  ls:=calc_poly(FDate,pt_sun_anomaly,1);
  f:=calc_poly(FDate,pt_moon_argument,1);
  zeta:=calc_poly(FDate,pt_moon_longitude,1)+precession*cy;
  result:=0;
  i:=0;
  while true do begin
    WITH factor(elp,i) do begin
      result:=result+a*sin_d(i1*zeta+i2*D+i3*ls+i4*l+i5*f+phi);
      if A=0 then BREAK;
      end;
    inc(i);
    end;
  end;
(*@\\\0000000130*)
(*@/// function TMoonELP.CalcPlanet(elp:integer; factor:TELPCalcFuncPlanet):extended; *)
function TMoonELP.CalcPlanet(elp:integer; factor:TELPCalcFuncPlanet):extended;
var
  m_mercury, m_venus, m_mars, m_jupiter, m_saturn, m_uranus,m_neptune: extended;
  T,D,l,F: extended;
  i: integer;
begin
  m_mercury:=PlanetaryTerm(mercury);
  m_venus:=PlanetaryTerm(venus);
  m_mars:=PlanetaryTerm(mars);
  m_jupiter:=PlanetaryTerm(jupiter);
  m_saturn:=PlanetaryTerm(saturn);
  m_uranus:=PlanetaryTerm(uranus);
  m_neptune:=PlanetaryTerm(neptune);
  l:=calc_poly(fdate,pt_moon_anomaly,1);
  f:=calc_poly(fdate,pt_moon_argument,1);
  d:=calc_poly(fdate,pt_moon_elongation,1);
  T:=calc_poly(fdate,pt_moon_longitude,1)-D-180;
  result:=0;
  i:=0;
  while true do begin
    WITH factor(elp,i) do begin
      result:=result+a*sin_d(i1*m_mercury+i2*m_venus+i3*T+i4*m_mars
        +i5*m_jupiter+i6*m_saturn+i7*m_uranus+i8*m_neptune
        +i9*D+i10*l+i11*F+phi);
      if A=0 then BREAK;
      end;
    inc(i);
    end;
  end;
(*@\\\000000012B*)
(*@/// function TMoonELP.CalcPlanet2(elp:integer; factor:TELPCalcFuncPlanet):extended; *)
function TMoonELP.CalcPlanet2(elp:integer; factor:TELPCalcFuncPlanet):extended;
var
  m_mercury, m_venus, m_mars, m_jupiter, m_saturn, m_uranus: extended;
  T,D,ls,l,F: extended;
  i: integer;
begin
  m_mercury:=PlanetaryTerm(mercury);
  m_venus:=PlanetaryTerm(venus);
  m_mars:=PlanetaryTerm(mars);
  m_jupiter:=PlanetaryTerm(jupiter);
  m_saturn:=PlanetaryTerm(saturn);
  m_uranus:=PlanetaryTerm(uranus);
  l:=calc_poly(fdate,pt_moon_anomaly,1);
  ls:=calc_poly(fdate,pt_sun_anomaly,1);
  f:=calc_poly(fdate,pt_moon_argument,1);
  d:=calc_poly(fdate,pt_moon_elongation,1);
  T:=calc_poly(fdate,pt_moon_longitude,1)-D-180;
  result:=0;
  i:=0;
  while true do begin
    WITH factor(elp,i) do begin
      result:=result+a*sin_d(i1*m_mercury+i2*m_venus+i3*T+i4*m_mars
        +i5*m_jupiter+i6*m_saturn+i7*m_uranus
        +i8*D+i9*ls+i10*l+i11*F+phi);
      if A=0 then BREAK;
      end;
    inc(i);
    end;
  end;
(*@\\\000000011E*)
(*@/// function TMoonELP.CalcTide(elp:integer; factor:TELPCalcFuncTide):extended; *)
function TMoonELP.CalcTide(elp:integer; factor:TELPCalcFuncTide):extended;
var
  D,l,ls,F: extended;
  i: integer;
begin
  d:=calc_poly(fdate,pt_moon_elongation,1);
  l:=calc_poly(fdate,pt_moon_anomaly,1);
  ls:=calc_poly(fdate,pt_sun_anomaly,1);
  f:=calc_poly(fdate,pt_moon_argument,1);
  result:=0;
  i:=0;
  while true do begin
    WITH factor(elp,i) do begin
      result:=result+a*sin_d(i2*D+i3*ls+i4*l+i5*f+phi);
      if A=0 then BREAK;
      end;
    inc(i);
    end;
  end;
(*@\\\0000000A01*)
(*@/// function TMoonELP.CalcMoonFigure(elp:integer; factor:TELPCalcFuncMoonFigure):extended; *)
function TMoonELP.CalcMoonFigure(elp:integer; factor:TELPCalcFuncMoonFigure):extended;
begin
  result:=CalcTide(elp,factor);
  end;
(*@\\\0000000318*)
(*@/// function TMoonELP.CalcRelativistic(elp:integer; factor:TELPCalcFuncRelativistic):extended; *)
function TMoonELP.CalcRelativistic(elp:integer; factor:TELPCalcFuncRelativistic):extended;
begin
  result:=CalcTide(elp,factor);
  end;
(*@\\\0000000318*)
(*@/// function TMoonELP.CalcEccentricity(elp:integer; factor:TELPCalcFuncEccentricity):extended; *)
function TMoonELP.CalcEccentricity(elp:integer; factor:TELPCalcFuncEccentricity):extended;
var
  D,l,ls,F: extended;
  i: integer;
begin
  d:=calc_poly(fdate,pt_moon_elongation,1);
  l:=calc_poly(fdate,pt_moon_anomaly,1);
  ls:=calc_poly(fdate,pt_sun_anomaly,1);
  f:=calc_poly(fdate,pt_moon_argument,1);
  result:=0;
  i:=0;
  while true do begin
    WITH factor(elp,i) do begin
      result:=result+a*sin_d(i2*D+i3*ls+i4*l+i5*f+phi);
      if A=0 then BREAK;
      end;
    inc(i);
    end;
  end;
(*@\\\*)

(*@/// function TMoonELP.MainProblem(term:TTermValue):extended; *)
function TMoonELP.MainProblem(term:TTermValue):extended;
begin
  case term of
    v_longitude: result:=CalcMain(1,GetTermMain);
    v_latitude:  result:=CalcMain(2,GetTermMain);
    v_radius:    result:=CalcMain(3,GetTermMain);
    else         result:=0;
    end;
  end;
(*@\\\0000000201*)
(*@/// function TMoonELP.earth_figure(term:TTermValue):extended; *)
function TMoonELP.earth_figure(term:TTermValue):extended;
var
  cy: extended;
begin
  cy:=Century_term(FDate);
  case term of
    v_longitude: result:=CalcEarthFigure(4,GetTermEarthFigure)
                        +CalcEarthFigure(7,GetTermEarthFigure)*cy;
    v_latitude:  result:=CalcEarthFigure(5,GetTermEarthFigure)
                        +CalcEarthFigure(8,GetTermEarthFigure)*cy;
    v_radius:    result:=CalcEarthFigure(6,GetTermEarthFigure)
                        +CalcEarthFigure(9,GetTermEarthFigure)*cy;
    else         result:=0;
    end;
  end;
(*@\\\0000000842*)
(*@/// function TMoonELP.planetary(term:TTermValue):extended; *)
function TMoonELP.planetary(term:TTermValue):extended;
var
  cy: extended;
begin
  cy:=Century_term(fdate);
  case term of
    v_longitude: result:=
      CalcPlanet(10,GetTermPlanet)+cy*CalcPlanet(13,GetTermPlanet)+
      CalcPlanet2(16,GetTermPlanet)+cy*CalcPlanet2(19,GetTermPlanet);
    v_latitude:  result:=
      CalcPlanet(11,GetTermPlanet)+cy*CalcPlanet(14,GetTermPlanet)+
      CalcPlanet2(17,GetTermPlanet)+cy*CalcPlanet2(20,GetTermPlanet);
    v_radius:    result:=
      CalcPlanet(12,GetTermPlanet)+cy*CalcPlanet(15,GetTermPlanet)+
      CalcPlanet2(18,GetTermPlanet)+cy*CalcPlanet2(21,GetTermPlanet);
    else         result:=0;
    end;
  end;
(*@\\\0000000801*)
(*@/// function TMoonELP.tide(term:TTermValue):extended; *)
function TMoonELP.tide(term:TTermValue):extended;
var
  cy: extended;
begin
  cy:=Century_term(FDate);
  case term of
    v_longitude: result:=CalcTide(22,GetTermTide)
                        +CalcTide(25,GetTermTide)*cy;
    v_latitude:  result:=CalcTide(23,GetTermTide)
                        +CalcTide(26,GetTermTide)*cy;
    v_radius:    result:=CalcTide(24,GetTermTide)
                        +CalcTide(27,GetTermTide)*cy;
    else         result:=0;
    end;
  end;
(*@\\\0000000201*)
(*@/// function TMoonELP.moon_figure(term:TTermValue):extended; *)
function TMoonELP.moon_figure(term:TTermValue):extended;
begin
  case term of
    v_longitude: result:=CalcMoonFigure(28,GetTermMoonFigure);
    v_latitude:  result:=CalcMoonFigure(29,GetTermMoonFigure);
    v_radius:    result:=CalcMoonFigure(30,GetTermMoonFigure);
    else         result:=0;
    end;
  end;
(*@\\\0000000201*)
(*@/// function TMoonELP.relativistic(term:TTermValue):extended; *)
function TMoonELP.relativistic(term:TTermValue):extended;
begin
  case term of
    v_longitude: result:=CalcRelativistic(31,GetTermRelativistic);
    v_latitude:  result:=CalcRelativistic(32,GetTermRelativistic);
    v_radius:    result:=CalcRelativistic(33,GetTermRelativistic);
    else         result:=0;
    end;
  end;
(*@\\\000000052C*)
(*@/// function TMoonELP.eccentricity(term:TTermValue):extended; *)
function TMoonELP.eccentricity(term:TTermValue):extended;
var
  cy: extended;
begin
  cy:=Century_term(FDate);
  case term of
    v_longitude: result:=CalcEccentricity(34,GetTermEccentricity)*cy*cy;
    v_latitude:  result:=CalcEccentricity(35,GetTermEccentricity)*cy*cy;
    v_radius:    result:=CalcEccentricity(36,GetTermEccentricity)*cy*cy;
    else         result:=0;
    end;
  end;
(*@\\\0000000601*)
(*@\\\0000000501*)
(*@/// class TMoonELP_Meeus(TMoonELP) *)
(*@/// function TMoonELP_Meeus.tide(term:TTermValue):extended; *)
function TMoonELP_Meeus.tide(term:TTermValue):extended;
begin
  result:=0;
  end;
(*@\\\*)
(*@/// function TMoonELP_Meeus.moon_figure(term:TTermValue):extended; *)
function TMoonELP_Meeus.moon_figure(term:TTermValue):extended;
begin
  result:=0;
  end;
(*@\\\000000030D*)
(*@/// function TMoonELP_Meeus.relativistic(term:TTermValue):extended; *)
function TMoonELP_Meeus.relativistic(term:TTermValue):extended;
begin
  result:=0;
  end;
(*@\\\*)
(*@/// function TMoonELP_Meeus.eccentricity(term:TTermValue):extended; *)
function TMoonELP_Meeus.eccentricity(term:TTermValue):extended;
begin
  result:=0;
  end;
(*@\\\*)

(*@/// function TMoonELP_Meeus.GetTermMoonFigure(elp,index:integer):T_ELP_Moon_figure; *)
function TMoonELP_Meeus.GetTermMoonFigure(elp,index:integer):T_ELP_Moon_figure;
begin
  result:=empty_ELP_moon_figure;
  end;
(*@\\\000000012F*)
(*@/// function TMoonELP_Meeus.GetTermRelativistic(elp,index:integer):T_ELP_relativistic; *)
function TMoonELP_Meeus.GetTermRelativistic(elp,index:integer):T_ELP_relativistic;
begin
  result:=empty_ELP_relativistic;
  end;
(*@\\\0000000131*)
(*@/// function TMoonELP_Meeus.GetTermTide(elp,index:integer):T_ELP_tide; *)
function TMoonELP_Meeus.GetTermTide(elp,index:integer):T_ELP_tide;
begin
  result:=empty_ELP_tide;
  end;
(*@\\\0000000129*)
(*@/// function TMoonELP_Meeus.GetTermEccentricity(elp,index:integer):T_ELP_Eccentricity; *)
function TMoonELP_Meeus.GetTermEccentricity(elp,index:integer):T_ELP_Eccentricity;
begin
  result:=empty_ELP_eccentricity;
  end;
(*@\\\0000000131*)

(*@/// function TMoonELP_Meeus.GetTermMain(elp,index:integer):T_ELP_main; *)
function TMoonELP_Meeus.GetTermMain(elp,index:integer):T_ELP_main;
const
  (*@/// elp_1:array[0..59] of T_ELP_main = (..);     main problem longitude *)
  elp_1:array[0..59] of T_ELP_main = (
    ( i1: 0; i2: 0; i3: 1; i4: 0; A: 6288774*0.0036),
    ( i1: 2; i2: 0; i3:-1; i4: 0; A: 1274027*0.0036),
    ( i1: 2; i2: 0; i3: 0; i4: 0; A:  658314*0.0036),
    ( i1: 0; i2: 0; i3: 2; i4: 0; A:  213618*0.0036),
    ( i1: 0; i2: 1; i3: 0; i4: 0; A: -185116*0.0036),
    ( i1: 0; i2: 0; i3: 0; i4: 2; A: -114332*0.0036),
    ( i1: 2; i2: 0; i3:-2; i4: 0; A:   58793*0.0036),
    ( i1: 2; i2:-1; i3:-1; i4: 0; A:   57066*0.0036),
    ( i1: 2; i2: 0; i3: 1; i4: 0; A:   53322*0.0036),
    ( i1: 2; i2:-1; i3: 0; i4: 0; A:   45758*0.0036),
    ( i1: 0; i2: 1; i3:-1; i4: 0; A:  -40923*0.0036),
    ( i1: 1; i2: 0; i3: 0; i4: 0; A:  -34720*0.0036),
    ( i1: 0; i2: 1; i3: 1; i4: 0; A:  -30383*0.0036),
    ( i1: 2; i2: 0; i3: 0; i4:-2; A:   15327*0.0036),
    ( i1: 0; i2: 0; i3: 1; i4: 2; A:  -12528*0.0036),
    ( i1: 0; i2: 0; i3: 1; i4:-2; A:   10980*0.0036),
    ( i1: 4; i2: 0; i3:-1; i4: 0; A:   10675*0.0036),
    ( i1: 0; i2: 0; i3: 3; i4: 0; A:   10034*0.0036),
    ( i1: 4; i2: 0; i3:-2; i4: 0; A:    8548*0.0036),
    ( i1: 2; i2: 1; i3:-1; i4: 0; A:   -7888*0.0036),
    ( i1: 2; i2: 1; i3: 0; i4: 0; A:   -6766*0.0036),
    ( i1: 1; i2: 0; i3:-1; i4: 0; A:   -5163*0.0036),
    ( i1: 1; i2: 1; i3: 0; i4: 0; A:    4987*0.0036),
    ( i1: 2; i2:-1; i3: 1; i4: 0; A:    4036*0.0036),
    ( i1: 2; i2: 0; i3: 2; i4: 0; A:    3994*0.0036),
    ( i1: 4; i2: 0; i3: 0; i4: 0; A:    3861*0.0036),
    ( i1: 2; i2: 0; i3:-3; i4: 0; A:    3665*0.0036),
    ( i1: 0; i2: 1; i3:-2; i4: 0; A:   -2689*0.0036),
    ( i1: 2; i2: 0; i3:-1; i4: 2; A:   -2602*0.0036),
    ( i1: 2; i2:-1; i3:-2; i4: 0; A:    2390*0.0036),
    ( i1: 1; i2: 0; i3: 1; i4: 0; A:   -2348*0.0036),
    ( i1: 2; i2:-2; i3: 0; i4: 0; A:    2236*0.0036),
    ( i1: 0; i2: 1; i3: 2; i4: 0; A:   -2120*0.0036),
    ( i1: 0; i2: 2; i3: 0; i4: 0; A:   -2069*0.0036),
    ( i1: 2; i2:-2; i3:-1; i4: 0; A:    2048*0.0036),
    ( i1: 2; i2: 0; i3: 1; i4:-2; A:   -1773*0.0036),
    ( i1: 2; i2: 0; i3: 0; i4: 2; A:   -1595*0.0036),
    ( i1: 4; i2:-1; i3:-1; i4: 0; A:    1215*0.0036),
    ( i1: 0; i2: 0; i3: 2; i4: 2; A:   -1110*0.0036),
    ( i1: 3; i2: 0; i3:-1; i4: 0; A:    -892*0.0036),
    ( i1: 2; i2: 1; i3: 1; i4: 0; A:    -810*0.0036),
    ( i1: 4; i2:-1; i3:-2; i4: 0; A:     759*0.0036),
    ( i1: 0; i2: 2; i3:-1; i4: 0; A:    -713*0.0036),
    ( i1: 2; i2: 2; i3:-1; i4: 0; A:    -700*0.0036),
    ( i1: 2; i2: 1; i3:-2; i4: 0; A:     691*0.0036),
    ( i1: 2; i2:-1; i3: 0; i4:-2; A:     596*0.0036),
    ( i1: 4; i2: 0; i3: 1; i4: 0; A:     549*0.0036),
    ( i1: 0; i2: 0; i3: 4; i4: 0; A:     537*0.0036),
    ( i1: 4; i2:-1; i3: 0; i4: 0; A:     520*0.0036),
    ( i1: 1; i2: 0; i3:-2; i4: 0; A:    -487*0.0036),
    ( i1: 2; i2: 1; i3: 0; i4:-2; A:    -399*0.0036),
    ( i1: 0; i2: 0; i3: 2; i4:-2; A:    -381*0.0036),
    ( i1: 1; i2: 1; i3: 1; i4: 0; A:     351*0.0036),
    ( i1: 3; i2: 0; i3:-2; i4: 0; A:    -340*0.0036),
    ( i1: 4; i2: 0; i3:-3; i4: 0; A:     330*0.0036),
    ( i1: 2; i2:-1; i3: 2; i4: 0; A:     327*0.0036),
    ( i1: 0; i2: 2; i3: 1; i4: 0; A:    -323*0.0036),
    ( i1: 1; i2: 1; i3:-1; i4: 0; A:     299*0.0036),
    ( i1: 2; i2: 0; i3: 3; i4: 0; A:     294*0.0036),
    ( i1: 2; i2: 0; i3:-1; i4:-2; A:       0*0.0036)
    );
  (*@\\\*)
  (*@/// elp_2:array[0..59] of T_ELP_main = (..);     main problem latitude *)
  elp_2:array[0..59] of T_ELP_main = (
    ( i1: 0; i2: 0; i3: 0; i4: 1; A: 5128122*0.0036),
    ( i1: 0; i2: 0; i3: 1; i4: 1; A:  280602*0.0036),
    ( i1: 0; i2: 0; i3: 1; i4:-1; A:  277693*0.0036),
    ( i1: 2; i2: 0; i3: 0; i4:-1; A:  173237*0.0036),
    ( i1: 2; i2: 0; i3:-1; i4: 1; A:   55413*0.0036),
    ( i1: 2; i2: 0; i3:-1; i4:-1; A:   46271*0.0036),
    ( i1: 2; i2: 0; i3: 0; i4: 1; A:   32573*0.0036),
    ( i1: 0; i2: 0; i3: 2; i4: 1; A:   17198*0.0036),
    ( i1: 2; i2: 0; i3: 1; i4:-1; A:    9266*0.0036),
    ( i1: 0; i2: 0; i3: 2; i4:-1; A:    8822*0.0036), (* !!! Error in German Meeus *)
    ( i1: 2; i2:-1; i3: 0; i4:-1; A:    8216*0.0036),
    ( i1: 2; i2: 0; i3:-2; i4:-1; A:    4324*0.0036),
    ( i1: 2; i2: 0; i3: 1; i4: 1; A:    4200*0.0036),
    ( i1: 2; i2: 1; i3: 0; i4:-1; A:   -3359*0.0036),
    ( i1: 2; i2:-1; i3:-1; i4: 1; A:    2463*0.0036),
    ( i1: 2; i2:-1; i3: 0; i4: 1; A:    2211*0.0036),
    ( i1: 2; i2:-1; i3:-1; i4:-1; A:    2065*0.0036),
    ( i1: 0; i2: 1; i3:-1; i4:-1; A:   -1870*0.0036),
    ( i1: 4; i2: 0; i3:-1; i4:-1; A:    1828*0.0036),
    ( i1: 0; i2: 1; i3: 0; i4: 1; A:   -1794*0.0036),
    ( i1: 0; i2: 0; i3: 0; i4: 3; A:   -1749*0.0036),
    ( i1: 0; i2: 1; i3:-1; i4: 1; A:   -1565*0.0036),
    ( i1: 1; i2: 0; i3: 0; i4: 1; A:   -1491*0.0036),
    ( i1: 0; i2: 1; i3: 1; i4: 1; A:   -1475*0.0036),
    ( i1: 0; i2: 1; i3: 1; i4:-1; A:   -1410*0.0036),
    ( i1: 0; i2: 1; i3: 0; i4:-1; A:   -1344*0.0036),
    ( i1: 1; i2: 0; i3: 0; i4:-1; A:   -1335*0.0036),
    ( i1: 0; i2: 0; i3: 3; i4: 1; A:    1107*0.0036),
    ( i1: 4; i2: 0; i3: 0; i4:-1; A:    1021*0.0036),
    ( i1: 4; i2: 0; i3:-1; i4: 1; A:     833*0.0036),
    ( i1: 0; i2: 0; i3: 1; i4:-3; A:     777*0.0036),
    ( i1: 4; i2: 0; i3:-2; i4: 1; A:     671*0.0036),
    ( i1: 2; i2: 0; i3: 0; i4:-3; A:     607*0.0036),
    ( i1: 2; i2: 0; i3: 2; i4:-1; A:     596*0.0036),
    ( i1: 2; i2:-1; i3: 1; i4:-1; A:     491*0.0036),
    ( i1: 2; i2: 0; i3:-2; i4: 1; A:    -451*0.0036),
    ( i1: 0; i2: 0; i3: 3; i4:-1; A:     439*0.0036),
    ( i1: 2; i2: 0; i3: 2; i4: 1; A:     422*0.0036),
    ( i1: 2; i2: 0; i3:-3; i4:-1; A:     421*0.0036),
    ( i1: 2; i2: 1; i3:-1; i4: 1; A:    -366*0.0036),
    ( i1: 2; i2: 1; i3: 0; i4: 1; A:    -351*0.0036),
    ( i1: 4; i2: 0; i3: 0; i4: 1; A:     331*0.0036),
    ( i1: 2; i2:-1; i3: 1; i4: 1; A:     315*0.0036),
    ( i1: 2; i2:-2; i3: 0; i4:-1; A:     302*0.0036),
    ( i1: 0; i2: 0; i3: 1; i4: 3; A:    -283*0.0036),
    ( i1: 2; i2: 1; i3: 1; i4:-1; A:    -229*0.0036),
    ( i1: 1; i2: 1; i3: 0; i4:-1; A:     223*0.0036),
    ( i1: 1; i2: 1; i3: 0; i4: 1; A:     223*0.0036),
    ( i1: 0; i2: 1; i3:-2; i4:-1; A:    -220*0.0036),
    ( i1: 2; i2: 1; i3:-1; i4:-1; A:    -220*0.0036),
    ( i1: 1; i2: 0; i3: 1; i4: 1; A:    -185*0.0036),
    ( i1: 2; i2:-1; i3:-2; i4:-1; A:     181*0.0036),
    ( i1: 0; i2: 1; i3: 2; i4: 1; A:    -177*0.0036),
    ( i1: 4; i2: 0; i3:-2; i4:-1; A:     176*0.0036),
    ( i1: 4; i2:-1; i3:-1; i4:-1; A:     166*0.0036),
    ( i1: 1; i2: 0; i3: 1; i4:-1; A:    -164*0.0036),
    ( i1: 4; i2: 0; i3: 1; i4:-1; A:     132*0.0036),
    ( i1: 1; i2: 0; i3:-1; i4:-1; A:    -119*0.0036),
    ( i1: 4; i2:-1; i3: 0; i4:-1; A:     115*0.0036),
    ( i1: 2; i2:-2; i3: 0; i4: 1; A:     107*0.0036)
    );
  (*@\\\*)
  (*@/// elp_3:array[0..60] of T_ELP_main = (..);     main problem distance *)
    elp_3:array[0..46] of T_ELP_main = (
      ( i1: 0; i2: 0; i3: 0; i4: 0; A: 385000560*0.001),
      ( i1: 0; i2: 0; i3: 1; i4: 0; A: -20905355*0.001),
      ( i1: 2; i2: 0; i3:-1; i4: 0; A:  -3699111*0.001),
      ( i1: 2; i2: 0; i3: 0; i4: 0; A:  -2955968*0.001),
      ( i1: 0; i2: 0; i3: 2; i4: 0; A:   -569925*0.001),
      ( i1: 0; i2: 1; i3: 0; i4: 0; A:     48888*0.001),
      ( i1: 0; i2: 0; i3: 0; i4: 2; A:     -3149*0.001),
      ( i1: 2; i2: 0; i3:-2; i4: 0; A:    246158*0.001),
      ( i1: 2; i2:-1; i3:-1; i4: 0; A:   -152138*0.001),
      ( i1: 2; i2: 0; i3: 1; i4: 0; A:   -170733*0.001),
      ( i1: 2; i2:-1; i3: 0; i4: 0; A:   -204586*0.001),
      ( i1: 0; i2: 1; i3:-1; i4: 0; A:   -129620*0.001),
      ( i1: 1; i2: 0; i3: 0; i4: 0; A:    108743*0.001),
      ( i1: 0; i2: 1; i3: 1; i4: 0; A:    104755*0.001),
      ( i1: 2; i2: 0; i3: 0; i4:-2; A:     10321*0.001),
  {    ( i1: 0; i2: 0; i3: 1; i4: 2; A:         0*0.001), }
      ( i1: 0; i2: 0; i3: 1; i4:-2; A:     79661*0.001),
      ( i1: 4; i2: 0; i3:-1; i4: 0; A:    -34782*0.001),
      ( i1: 0; i2: 0; i3: 3; i4: 0; A:    -23210*0.001),
      ( i1: 4; i2: 0; i3:-2; i4: 0; A:    -21636*0.001),
      ( i1: 2; i2: 1; i3:-1; i4: 0; A:     24208*0.001),
      ( i1: 2; i2: 1; i3: 0; i4: 0; A:     30824*0.001),
      ( i1: 1; i2: 0; i3:-1; i4: 0; A:     -8379*0.001),
      ( i1: 1; i2: 1; i3: 0; i4: 0; A:    -16675*0.001),
      ( i1: 2; i2:-1; i3: 1; i4: 0; A:    -12831*0.001),
      ( i1: 2; i2: 0; i3: 2; i4: 0; A:    -10445*0.001),
      ( i1: 4; i2: 0; i3: 0; i4: 0; A:    -11650*0.001),
      ( i1: 2; i2: 0; i3:-3; i4: 0; A:     14403*0.001),
      ( i1: 0; i2: 1; i3:-2; i4: 0; A:     -7003*0.001),
  {    ( i1: 2; i2: 0; i3:-1; i4: 2; A:         0*0.001), }
      ( i1: 2; i2:-1; i3:-2; i4: 0; A:     10056*0.001),
      ( i1: 1; i2: 0; i3: 1; i4: 0; A:      6322*0.001),
      ( i1: 2; i2:-2; i3: 0; i4: 0; A:     -9884*0.001),
      ( i1: 0; i2: 1; i3: 2; i4: 0; A:      5751*0.001),
  {    ( i1: 0; i2: 2; i3: 0; i4: 0; A:         0*0.001), }
      ( i1: 2; i2:-2; i3:-1; i4: 0; A:     -4950*0.001),
      ( i1: 2; i2: 0; i3: 1; i4:-2; A:      4130*0.001),
  {    ( i1: 2; i2: 0; i3: 0; i4: 2; A:         0*0.001), }
      ( i1: 4; i2:-1; i3:-1; i4: 0; A:     -3958*0.001),
  {    ( i1: 0; i2: 0; i3: 2; i4: 2; A:         0*0.001), }
      ( i1: 3; i2: 0; i3:-1; i4: 0; A:      3258*0.001),
      ( i1: 2; i2: 1; i3: 1; i4: 0; A:      2616*0.001),
      ( i1: 4; i2:-1; i3:-2; i4: 0; A:     -1897*0.001),
      ( i1: 0; i2: 2; i3:-1; i4: 0; A:     -2117*0.001),
      ( i1: 2; i2: 2; i3:-1; i4: 0; A:      2354*0.001),
  {    ( i1: 2; i2: 1; i3:-2; i4: 0; A:         0*0.001), }
  {    ( i1: 2; i2:-1; i3: 0; i4:-2; A:         0*0.001), }
      ( i1: 4; i2: 0; i3: 1; i4: 0; A:     -1423*0.001),
      ( i1: 0; i2: 0; i3: 4; i4: 0; A:     -1117*0.001),
      ( i1: 4; i2:-1; i3: 0; i4: 0; A:     -1571*0.001),
      ( i1: 1; i2: 0; i3:-2; i4: 0; A:     -1739*0.001),
  {    ( i1: 2; i2: 1; i3: 0; i4:-2; A:         0*0.001), }
      ( i1: 0; i2: 0; i3: 2; i4:-2; A:     -4421*0.001),
  {    ( i1: 1; i2: 1; i3: 1; i4: 0; A:         0*0.001), }
  {    ( i1: 3; i2: 0; i3:-2; i4: 0; A:         0*0.001), }
  {    ( i1: 4; i2: 0; i3:-3; i4: 0; A:         0*0.001), }
  {    ( i1: 2; i2:-1; i3: 2; i4: 0; A:         0*0.001), }
      ( i1: 0; i2: 2; i3: 1; i4: 0; A:      1165*0.001),
  {    ( i1: 1; i2: 1; i3:-1; i4: 0; A:         0*0.001), }
  {    ( i1: 2; i2: 0; i3: 3; i4: 0; A:         0*0.001), }
      ( i1: 2; i2: 0; i3:-1; i4:-2; A:      8752*0.001)
      );
  (*@\\\*)
begin
  case elp of
    1: begin
      if (index>=low(elp_1)) and (index<=high(elp_1)) then
        result:=elp_1[index]
      else
        result:=empty_ELP_main;
      end;
    2: begin
      if (index>=low(elp_2)) and (index<=high(elp_2)) then
        result:=elp_2[index]
      else
        result:=empty_ELP_main;
      end;
    3: begin
      if (index>=low(elp_3)) and (index<=high(elp_3)) then
        result:=elp_3[index]
      else
        result:=empty_ELP_main;
      end;
    else
      result:=empty_ELP_main;
    end;
  case result.i2 of
    1: result.A:=result.A*(EccentricityTerm);
    2: result.A:=result.A*(EccentricityTerm*EccentricityTerm);
    end;
  end;
(*@\\\0000001F1C*)
(*@/// function TMoonELP_Meeus.GetTermEarthFigure(elp,index:integer):T_ELP_earth_figure; *)
function TMoonELP_Meeus.GetTermEarthFigure(elp,index:integer):T_ELP_earth_figure;
const
  (*@/// elp_4 :array[0..0] of T_ELP_earth_figure = (..); earth figure longitude *)
  elp_4:array[0..0] of T_ELP_earth_figure = (
   ( i1: 1; i2: 0; i3: 0; i4: 0; i5:-1; phi:   0.00094; A: 7.06304)
   );
  (*@\\\*)
  (*@/// elp_5 :array[0..2] of T_ELP_earth_figure = (..); earth figure latitude *)
  elp_5:array[0..2] of T_ELP_earth_figure = (
   ( i1: 1; i2: 0; i3: 0; i4: 0; i5: 0; phi: 180.00071; A: 8.04508),
   ( i1: 1; i2: 0; i3: 0; i4:-1; i5: 0; phi:   0.00075; A: 0.45586),
   ( i1: 1; i2: 0; i3: 0; i4: 1; i5: 0; phi: 180.00069; A: 0.41571)
   );
  (*@\\\*)
begin
  case elp of
    4: begin
      if (index>=low(elp_4)) and (index<=high(elp_4)) then
        result:=elp_4[index]
      else
        result:=empty_ELP_earth_figure;
      end;
    5: begin
      if (index>=low(elp_5)) and (index<=high(elp_5)) then
        result:=elp_5[index]
      else
        result:=empty_ELP_earth_figure;
      end;
    else
      result:=empty_ELP_earth_figure;
    end;
  end;
(*@\\\*)
(*@/// function TMoonELP_Meeus.GetTermPlanet(elp,index:integer):T_ELP_planet; *)
function TMoonELP_Meeus.GetTermPlanet(elp,index:integer):T_ELP_planet;
const
  (*@/// elp_10:array[0..1] of T_ELP_planet = (..); planetary pertubations longitude *)
  elp_10:array[0..1] of T_ELP_planet = (
   ( i1: 0; i2:  0; i3:  2; i4:  0; i5: -2; i6:  0; i7:  0; i8:  0; i9:  2; i10: -1; i11:  0; phi: 180.11977; A:   1.14307),
   ( i1: 0; i2: 18; i3:-16; i4:  0; i5:  0; i6:  0; i7:  0; i8:  0; i9:  0; i10: -1; i11:  0; phi:  26.54261; A:  14.24883)
   );
  (*@\\\*)
  (*@/// elp_11:array[0..1] of T_ELP_planet = (..); planetary pertubations latitude *)
  elp_11:array[0..1] of T_ELP_planet = (
   ( i1: 0; i2: 18; i3:-16; i4:  0; i5:  0; i6:  0; i7:  0; i8:  0; i9:  0; i10: -1; i11: -1; phi:  26.54272; A:   0.63014),
   ( i1: 0; i2: 18; i3:-16; i4:  0; i5:  0; i6:  0; i7:  0; i8:  0; i9:  0; i10: -1; i11:  1; phi:  26.54287; A:   0.63037)
   );
  (*@\\\*)
  (*@/// elp_17:array[0..0] of T_ELP_planet = (..); planetary pertubations latitude 2 *)
  elp_17:array[0..0] of T_ELP_planet = (
   ( i1: 0; i2:  0; i3:  1; i4:  0; i5:  0; i6:  0; i7:  0; i8:  1; i9:  0; i10:  0; i11:  0; phi: 275.13226; A:   1.37497)
   );
  (*@\\\*)
begin
  case elp of
    10: begin
      if (index>=low(elp_10)) and (index<=high(elp_10)) then
        result:=elp_10[index]
      else
        result:=empty_ELP_planet;
      end;
    11: begin
      if (index>=low(elp_11)) and (index<=high(elp_11)) then
        result:=elp_11[index]
      else
        result:=empty_ELP_planet;
      end;
    17: begin
      if (index>=low(elp_17)) and (index<=high(elp_17)) then
        result:=elp_17[index]
      else
        result:=empty_ELP_planet;
      end;
    else  result:=empty_ELP_planet;
    end;
  end;
(*@\\\0000000701*)

(*@/// procedure TMoonELP_Meeus.SetDate(value: TDateTime); *)
procedure TMoonELP_Meeus.SetDate(value: TDateTime);
begin
  inherited SetDate(value);
  EccentricityTerm:=GetEccentricityTerm(value);
  end;
(*@\\\0000000501*)
(*@\\\*)
(*$ifndef meeus *)
{$i elp_full.pas }
(*$endif *)

(*@/// function moon_coord(date:TdateTime):TVector; *)
function moon_coord(date:TdateTime):TVector;
begin
  (*$ifdef meeus *)
  result:=TMoonELP_Meeus.calc_coord(date);
  (*$else *)
  result:=TMoonELP_Full.calc_coord(date);
  (*$endif *)
  end;
(*@\\\0000000429*)
(*@\\\000C000501000501000501*)
(*$ifdef delphi_ge_2 *) (*$warnings off *) (*$endif *)
end.
(*@\\\0000000901*)
