unit jupiter;

 {$i ah_def.inc }
(*$b-*)   { I may make use of the shortcut boolean eval }

(*@/// interface *)
interface

uses
  ah_math,
  moon,
  vsop,
  vsop_jup;
(*@\\\0000000508*)
(*@/// implementation *)
implementation

type
  (*@/// t_jupiter_coord=record *)
  t_jupiter_coord=record
    d, v, m, n, j, a, b, k, rr, r, delta, psi, deke: extended;
    end;
  (*@\\\*)
  t_jupiter_moon=array[0..3,0..1] of extended;

(*@/// function Jupiter_ephem_phys(date:TdateTime):t_jupiter_coord; *)
{ Based upon chapter 44 (42) of Meeus }

function Jupiter_ephem_phys(date:TdateTime):t_jupiter_coord;
var
  d, t, t1, alpha_0, delta_0, w1, w2: extended;
  l, b, r, l0, b0, r0: extended;
  x,y,z,delta: extended;
  epsilon_0: extended;
  alpha_s, delta_s, D_s: extended;
  u,v,alpha_,delta_,zeta: extended;
  D_E: extended;
  omega1, omega2: extended;
begin
  { Step 1 }
  d:=(julian_date(date)-2433282.5);
  t1:=d/36525;
  t:=(julian_date(date)-2451545)/36525;
  alpha_0:=268.0+0.1061*t1;
  delta_0:=64.5-0.0164*t1;
  { Step 2 }
  w1:=put_in_360(17.710+877.90003539*d);
  w2:=put_in_360(16.838+870.27003539*d);
  { Step 3 }
  earth_coord(date,l0,b0,r0);
  { Step 4 }
  jupiter_coord(date,l,b,r);
  { Step 5 }
  x:=r*cos_d(b)*cos_d(l)-r0*cos_d(l0);
  y:=r*cos_d(b)*sin_d(l)-r0*sin_d(l0);
  z:=r*sin_d(b)-r0*sin_d(b0);
  delta:=sqrt(x*x+y*y+z*z);
  { Step 6 }
  l:=l-0.012990*delta/r/r;
  { Step 7 }
  x:=r*cos_d(b)*cos_d(l)-r0*cos_d(l0);
  y:=r*cos_d(b)*sin_d(l)-r0*sin_d(l0);
  z:=r*sin_d(b)-r0*sin_d(b0);
  delta:=sqrt(x*x+y*y+z*z);
  { Step 8 }
  epsilon_0:=(84381.448+(-46.8150+(-0.00059+0.001813*t)*t)*t)/3600;
  { Step 9 }
  alpha_s:=arctan2_d(cos_d(epsilon_0)*sin_d(l)-sin_d(epsilon_0)*tan(b),cos_d(l));
  delta_s:=arcsin_d(cos_d(epsilon_0)*sin_d(b)+sin_d(epsilon_0)*cos_d(b)*sin_d(l));
  { Step 10 }
  D_s:=arcsin_d(-sin_d(delta_0)*sin_d(delta_s)-cos_d(delta_0)*cos_d(delta_s)*cos_d(alpha_0-alpha_s));
  { Step 11 }
  u:=y*cos_d(epsilon_0)-z*sin_d(epsilon_0);
  v:=y*sin_d(epsilon_0)+z*cos_d(epsilon_0);
  alpha_:=arctan2_d(u,x);
  delta_:=arctan_d(v/sqrt(x*x+u*u));
  zeta:=arctan2_d(sin_d(delta_0)*cos_d(delta_)*cos_d(alpha_0-alpha_)-sin_d(delta)*cos_d(delta_0),cos_d(delta_)*sin_d(alpha_0-alpha_));
  { Step 12 }
  D_E:=arcsin_d(-sin_d(delta_0)*sin_d(delta_)-cos_d(delta_0)*cos_d(delta_)*cos_d(alpha_0-alpha_));
  { Step 13 }
  omega1:=put_in_360(W1-zeta-5.07033*delta);
  omega2:=put_in_360(w2-zeta-5.02626*delta);
  { Step 14 }
  end;
(*@\\\003E003601003701003901003A01003901003901*)
(*@/// function Jupiter_moon(date:TdateTime):t_jupiter_moon; *)
{ Based upon chapter 43 of Meeus }

function Jupiter_moon(date:TdateTime):t_jupiter_moon;
begin
  end;
(*@\\\*)
(*@\\\0000000701*)
(*$ifdef delphi_ge_2 *) (*$warnings off *) (*$endif *)
end.
(*@\\\0001000011*)
