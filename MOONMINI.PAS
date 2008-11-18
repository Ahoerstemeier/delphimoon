unit moonmini;
  (* Analytical theory of the moon position with low accuracy *)
  (* based upon Montenbruck/Pfleger "Astronomy on the PC"      *)

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
(*@\\\0000000801*)
(*@/// implementation *)
implementation

type
  (*@/// TDelauny = record .. end; *)
  TDelauny = record
    t0,t1: extended;  (* mean values *)
    end;
  (*@\\\0000000301*)
  (*@/// TTermN = record .. end; *)
  TTermN = record
    p,q,r,s: shortint;
    N: extended;                  (* arc seconds *)
    end;
  (*@\\\*)
  TPertubation = (pb_longitude, pb_latitude);
  (*@/// TMoonMini=class(TCoordinateCalcMoon) *)
  TMoonMini=class(TCoordinateCalcMoon)
  protected
    function CalcLongitude:extended;  override;
    function CalcLatitude:extended;   Override;
    function CalcRadius:extended;     override;
    function CalcDelauny(factors:TDelauny):extended;
    function CalcPertubation(term:TPertubation):extended;
    end;
  (*@\\\000E000703000738000101*)

const
  (*@/// Delauny terms: TDelauny = ( .. ); *)
  Moon_mean_longitude:      TDelauny = ( t0: 0.606433*360;  t1: 1336.855225*360);
  Moon_Mean_Anomaly:        TDelauny = ( t0: 0.374897*360;  t1: 1325.552410*360);
  Sun_Mean_Anomaly:         TDelauny = ( t0: 0.993133*360;  t1:   99.997361*360);
  Moon_Mean_Longitude_Node: TDelauny = ( t0: 0.827361*360;  t1: 1236.953086*360);
  Moon_Mean_Elongation:     TDelauny = ( t0: 0.259086*360;  t1: 1342.227825*360);
  (*@\\\*)
  (*@/// pertubation_L: array[0..13] of TTermN = (..); *)
  pertubation_L: array[0..13] of TTermN = (
    { l     ls    f     d    }
    ( p: 1; q: 0; r: 0; s: 0; N: 22640 ),
    ( p: 1; q: 0; r: 0; s:-2; N: -4586 ),
    ( p: 0; q: 0; r: 0; s: 2; N:  2370 ),
    ( p: 2; q: 0; r: 0; s: 0; N:   769 ),
    ( p: 0; q: 1; r: 0; s: 0; N:  -668 ),
    ( p: 0; q: 0; r: 2; s: 0; N:  -412 ),
    ( p: 2; q: 0; r: 0; s:-2; N:  -212 ),
    ( p: 1; q: 1; r: 0; s:-2; N:  -206 ),
    ( p: 1; q: 0; r: 0; s: 2; N:   192 ),
    ( p: 0; q: 1; r: 0; s:-2; N:  -165 ),
    ( p: 0; q: 0; r: 0; s: 1; N:  -125 ),
    ( p: 1; q: 1; r: 0; s: 0; N:  -110 ),
    ( p: 1; q:-1; r: 0; s: 0; N:   148 ),
    ( p: 0; q: 0; r: 2; s:-2; N:   -55 )
    );
  (*@\\\000000011B*)
  (*@/// pertubation_B: array[0..6] of TTermN = (..); *)
  pertubation_B: array[0..6] of TTermN = (
    { l     ls    f     d    }
    ( p: 0; q: 0; r: 1; s:-2; N:  -526 ),
    ( p: 1; q: 0; r: 1; s:-2; N:    44 ),
    ( p:-1; q: 0; r: 1; s:-2; N:   -31 ),
    ( p: 0; q: 1; r: 1; s:-2; N:   -23 ),
    ( p: 0; q:-1; r: 1; s:-2; N:    11 ),
    ( p:-2; q: 0; r: 1; s: 0; N:   -25 ),
    ( p:-1; q: 0; r: 1; s: 0; N:    21 )
    );
  (*@\\\000000011B*)

(*@/// function TMoonMini.CalcLongitude:extended; *)
function TMoonMini.CalcLongitude:extended;
begin
  result:=CalcDelauny(Moon_mean_longitude)+CalcPertubation(pb_longitude);
  end;
(*@\\\0000000301*)
(*@/// function TMoonMini.CalcLatitude:extended; *)
function TMoonMini.CalcLatitude:extended;
var
  s,n: extended;
  ls,f: extended;
begin
  ls:=CalcDelauny(Sun_mean_Anomaly);
  f:=CalcDelauny(Moon_Mean_Longitude_Node);

  s:=f+CalcPertubation(pb_longitude)+
    (412*sin_d(2*f)+541*sin_d(2*ls))/3600;
  n:=CalcPertubation(pb_latitude);
  result:=(18520*sin_d(s)+n)/3600;
  end;
(*@\\\0000000401*)
(*@/// function TMoonMini.CalcRadius:extended; *)
function TMoonMini.CalcRadius:extended;
var
  sin_p: extended;
begin
  sin_p:=0.999953253*(3422.7/3600)*pi/180;
  result:=6378.15/sin_p;
  end;
(*@\\\*)
(*@/// function TMoonMini.CalcDelauny(factors:TDelauny):extended; *)
function TMoonMini.CalcDelauny(factors:TDelauny):extended;
begin
  result:=put_in_360(factors.t0+factors.t1*century_term(FDate));
  end;
(*@\\\*)
(*@/// function TMoonMini.CalcPertubation(term:TPertubation):extended; *)
function TMoonMini.CalcPertubation(term:TPertubation):extended;
var
  l,ls,f,d: extended;
  i: integer;
begin
  l:=CalcDelauny(Moon_Mean_Anomaly);
  ls:=CalcDelauny(Sun_mean_Anomaly);
  f:=CalcDelauny(Moon_Mean_Longitude_Node);
  d:=CalcDelauny(Moon_Mean_Elongation);
  result:=0;
  case term of
    pb_longitude:
      for i:=low(pertubation_L) to high(pertubation_L) do
        WITH pertubation_L[i] do
          result:=result+N*sin_d(p*l+q*ls+r*f+s*d);
    pb_latitude:
      for i:=low(pertubation_B) to high(pertubation_B) do
        WITH pertubation_B[i] do
          result:=result+N*sin_d(p*l+q*ls+r*f+s*d);
    end;
  result:=result/3600;
  end;
(*@\\\000000131F*)


(*@/// function moon_coord(date:TdateTime):TVector; *)
function moon_coord(date:TdateTime):TVector;
begin
  result:=TMoonMini.calc_coord(date);
  end;
(*@\\\0000000314*)
(*@\\\0030001201001240000726*)
(*$ifdef delphi_ge_2 *) (*$warnings off *) (*$endif *)
end.
(*@\\\0001000011000B01*)
