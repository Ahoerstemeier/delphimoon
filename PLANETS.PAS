unit planets;

 {$i ah_def.inc }

(*@/// interface *)
interface

(*@/// uses *)
uses
  ah_math,
  moon_aux,
  vsop,
  vsop_mer,
  vsop_ven,
  vsop_mar,
  vsop_jup,
  vsop_sat,
  vsop_ura,
  vsop_nep,
  pluto,
  sysutils,
  classes,
  windows;
(*@\\\*)

type
  TPlanet = (plMercury, plVenus, plEarth, plMars, plJupiter,
             plSaturn, plUranus, plNeptune, plPluto);

{ Heliocentric geometric }
procedure Planet_coord(date:TdateTime; planet:TPlanet; var l,b,r: extended);
{ Geocentric apparent }
procedure Planet_coord_apparent(date:TdateTime; planet:TPlanet; var l,b,r: extended);
{ Geocentric astrometric }
procedure Planet_coord_astrometric(date:TdateTime; planet:TPlanet; var l,b,r: extended);
(*@\\\0000000A01*)
(*@/// implementation *)
implementation

uses moon;

const
  (*@/// PlanetClass: array[TPlanet] of TCCoordinateCalc = ( *)
  PlanetClass: array[TPlanet] of TCCoordinateCalc = (
    TVSOPMercury,  { plMercury }
    TVSOPVenus,    { plVenus }
    TVSOPEarth,    { plEarth }
    TVSOPMars,     { plMars }
    TVSOPJupiter,  { plJupiter }
    TVSOPSaturn,   { plSaturn }
    TVSOPUranus,   { plUranus }
    TVSOPNeptune,  { plNeptune }
    TPlutoMeeus    { plPluto }
    );
  (*@\\\0000000130*)

(*@/// procedure Planet_coord(date:TdateTime; planet:TPlanet; var l,b,r: extended); *)
procedure Planet_coord(date:TdateTime; planet:TPlanet; var l,b,r: extended);
var
  v: TVector;
begin
  v:=PlanetClass[planet].calc_coord(date);
  l:=v.l;
  b:=v.b;
  r:=v.r;
  end;
(*@\\\000000080A*)

(*@/// procedure Planet_coord_apparent(date:TdateTime; planet:TPlanet; var l,b,r: extended ...); *)
procedure Planet_coord_apparent(date:TdateTime; planet:TPlanet; var l,b,r: extended);
var
  pos_earth, pos_planet, delta: TVector;
  tau, delta_tau: extended;
begin
  if planet=plEarth then
    raise E_OutOfAlgorithmRange.Create('Earth cannot be geocentric');
  tau:=0;
  repeat
    pos_earth:=PlanetClass[plEarth].calc_coord(date-tau);
    if planet=plPluto then begin
      pos_earth:=DynamicToFK5(date-tau,pos_earth);
      end;
    pos_earth:=SphericalToRectangular(pos_earth);
    pos_planet:=PlanetClass[planet].calc_coord(date-tau);
    pos_planet:=SphericalToRectangular(pos_planet);
    delta:=AddVectors(pos_planet,VectorTimesScalar(pos_earth,-1));
    delta_tau:=tau;
    tau:=0.0057755183*sqrt(ScalarProduct(delta,delta));
    delta_tau:=abs(delta_tau-tau);
  until (delta_tau*86400)<1.0;  (* 1 second accuracy *)
  delta:=RectAngularToSpherical(delta);
{   if planet<>plPluto then }
{     delta:=DynamicToFK5(date,delta); }
  delta.l:=put_in_360(delta.l+Nutation_Longitude(date));
  r:=delta.r;
  l:=delta.l;
  b:=delta.b;
  end;
(*@\\\0032000301000401001901001901*)
(*@/// procedure Planet_coord_astrometric(date:TdateTime; planet:TPlanet; var l,b,r: extended ...); *)
procedure Planet_coord_astrometric(date:TdateTime; planet:TPlanet; var l,b,r: extended);
var
  pos_earth, pos_planet, delta: TVector;
  tau, delta_tau: extended;
begin
  if planet=plEarth then
    raise E_OutOfAlgorithmRange.Create('Earth cannot be geocentric');
  tau:=0;
  pos_earth:=PlanetClass[plEarth].calc_coord(date);
  pos_earth:=SphericalToRectangular(pos_earth);
  repeat
    pos_planet:=PlanetClass[planet].calc_coord(date-tau);
    pos_planet:=SphericalToRectangular(pos_planet);
    delta:=AddVectors(pos_planet,VectorTimesScalar(pos_earth,-1));
    delta_tau:=tau;
    tau:=0.0057755183*sqrt(ScalarProduct(delta,delta));
    delta_tau:=abs(delta_tau-tau);
  until (delta_tau*86400)<1.0;  (* 1 second accuracy *)
  delta:=RectAngularToSpherical(delta);
  delta.l:=put_in_360(delta.l+Nutation_Longitude(date));
  r:=delta.r;
  l:=delta.l;
  b:=delta.b;
  end;
(*@\\\000C000301000401001801*)
(*@\\\0000000A01*)
(*$ifdef delphi_ge_2 *) (*$warnings off *) (*$endif *)
end.
(*@\\\0001000011*)
