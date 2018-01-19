unit pluto;

{$ifdef fpc}
  {$mode delphi}
{$endif}

{$i ah_def.inc }

{  Calculates the heliocentric coordinates of Pluto using the
   Meeus approximation }

(*@/// interface *)
interface

(*@/// uses *)
uses
  ah_math,
  moon_aux,
  sysutils,
  classes,
  windows;
(*@\\\0000000301*)

type
  (*@/// TPlutoMeeusEntry=record .. end; *)
  TPlutoMeeusEntry=record
    j,s,p: shortint;
    A,B: extended;
    end;
  (*@\\\000000030D*)
  TPlutoCalcFunc = function (index: integer):TPlutoMeeusEntry of object;
  (*@/// TPlutoMeeus=class(TCoordinateCalc) *)
  TPlutoMeeus=class(TCoordinateCalc)
  protected
    function LongitudeFactor(index: integer):TPlutoMeeusEntry;
    function LatitudeFactor(index: integer):TPlutoMeeusEntry;
    function RadiusFactor(index: integer):TPlutoMeeusEntry;
    function CalcLongitude:extended; override;
    function CalcLatitude:extended;  override;
    function CalcRadius:extended;    override;
    function Calc(factor: TPlutoCalcFunc):extended;
    procedure FinishCalculation(var v:TVector);  override;
    procedure SetDate(value: TDateTime);  override;
    end;
  (*@\\\0000000A2E*)

function pluto_coord(date:TdateTime):TVector;

(*@\\\000E000A01000A2E000B01000B01*)
(*@/// implementation *)
implementation

(*@/// function pluto_coord(date:TdateTime):TVector; *)
function pluto_coord(date:TdateTime):TVector;
begin
  result:=TPlutoMeeus.calc_coord(date);
  end;
(*@\\\0000000326*)

const
  empty_pluto_term:TPlutoMeeusEntry = ( j:0;s:0;p:0;A:0;b:0);

(*@/// class TPlutoMeeus *)
(*@/// function TPlutoMeeus.CalcLongitude:extended; *)
function TPlutoMeeus.CalcLongitude:extended;
begin
  result:=calc(Longitudefactor)+238.958116+144.96*century_term(FDate);
  end;
(*@\\\0000000301*)
(*@/// function TPlutoMeeus.CalcLatitude:extended; *)
function TPlutoMeeus.CalcLatitude:extended;
begin
  result:=calc(Latitudefactor)-3.908239;
  end;
(*@\\\0000000328*)
(*@/// function TPlutoMeeus.CalcRadius:extended; *)
function TPlutoMeeus.CalcRadius:extended;
begin
  result:=calc(radiusfactor)+40.7241346;
  end;
(*@\\\*)
(*@/// function TPlutoMeeus.Calc(factor: TPlutoCalcFunc):extended; *)
function TPlutoMeeus.Calc(factor: TPlutoCalcFunc):extended;
var
  t,arg: extended;
  jup,sat,plu: extended;
  i: integer;
begin
  t:=century_term(FDate);
  jup:= 34.35+3034.9057*t;
  sat:= 50.08+1222.1138*t;
  plu:=238.96+ 144.9600*t;
  result:=0;
  i:=0;
  while true do begin
    WITH Factor(i) do begin
      if (a=0) and (b=0) then
        BREAK;
      arg:=j*jup+s*sat+p*plu;
      result:=result+a*sin_d(arg)+b*cos_d(arg);
      inc(i);
      end;
    end;
  end;
(*@\\\*)
(*@/// procedure TPlutoMeeus.SetDate(value: TDateTime); *)
procedure TPlutoMeeus.SetDate(value: TDateTime);
var
  y,m,d: word;
begin
  decodedate(value,y,m,d);
  if (y<1885) or (y>2099) then
    raise E_OutOfAlgorithmRange.Create('Pluto algorithm only defined 1885-2099');
  inherited SetDate(value);
  end;
(*@\\\000000081C*)

(*@/// function TPlutoMeeus.RadiusFactor(index: integer):TPlutoMeeusEntry; *)
function TPlutoMeeus.RadiusFactor(index: integer):TPlutoMeeusEntry;
const
  (*@/// pluto_term:array[0..42] of TPlutoMeeusEntry = (..); *)
  pluto_term:array[0..42] of TPlutoMeeusEntry = (
    ( j: 0; s: 0; p: 1;  a: 66865439*1E-7; b: 68951812*1e-7),
    ( j: 0; s: 0; p: 2;  a:-11827535*1E-7; b:  -332538*1e-7),
    ( j: 0; s: 0; p: 3;  a:  1593179*1E-7; b: -1438890*1e-7),
    ( j: 0; s: 0; p: 4;  a:   -18444*1E-7; b:   483220*1e-7),
    ( j: 0; s: 0; p: 5;  a:   -65977*1E-7; b:   -85431*1e-7),
    ( j: 0; s: 0; p: 6;  a:    31174*1E-7; b:    -6032*1e-7),
    ( j: 0; s: 1; p:-1;  a:    -5794*1E-7; b:    22161*1e-7),
    ( j: 0; s: 1; p: 0;  a:     4601*1E-7; b:     4032*1e-7),
    ( j: 0; s: 1; p: 1;  a:    -1729*1E-7; b:      234*1e-7),
    ( j: 0; s: 1; p: 2;  a:     -415*1E-7; b:      702*1e-7),
    ( j: 0; s: 1; p: 3;  a:      239*1E-7; b:      723*1e-7),
    ( j: 0; s: 2; p:-2;  a:       67*1E-7; b:      -67*1e-7),
    ( j: 0; s: 2; p:-1;  a:     1034*1E-7; b:     -451*1e-7),
    ( j: 0; s: 2; p: 0;  a:     -129*1E-7; b:      504*1e-7),
    ( j: 1; s:-1; p: 0;  a:      480*1E-7; b:     -231*1e-7),
    ( j: 1; s:-1; p: 1;  a:        2*1E-7; b:     -441*1e-7),
    ( j: 1; s: 0; p:-3;  a:    -3359*1E-7; b:      265*1e-7),
    ( j: 1; s: 0; p:-2;  a:     7856*1E-7; b:    -7832*1e-7),
    ( j: 1; s: 0; p:-1;  a:       36*1E-7; b:    45763*1e-7),
    ( j: 1; s: 0; p: 0;  a:     8663*1E-7; b:     8547*1e-7),
    ( j: 1; s: 0; p: 1;  a:     -809*1E-7; b:     -769*1e-7),
    ( j: 1; s: 0; p: 2;  a:      263*1E-7; b:     -144*1e-7),
    ( j: 1; s: 0; p: 3;  a:     -126*1E-7; b:       32*1e-7),
    ( j: 1; s: 0; p: 4;  a:      -35*1E-7; b:      -16*1e-7),
    ( j: 1; s: 1; p:-3;  a:      -19*1E-7; b:       -4*1e-7),
    ( j: 1; s: 1; p:-2;  a:      -15*1E-7; b:        8*1e-7),
    ( j: 1; s: 1; p:-1;  a:       -4*1E-7; b:       12*1e-7),
    ( j: 1; s: 1; p: 0;  a:        5*1E-7; b:        6*1e-7),
    ( j: 1; s: 1; p: 1;  a:        3*1E-7; b:        1*1e-7),
    ( j: 1; s: 1; p: 3;  a:        6*1E-7; b:       -2*1e-7),
    ( j: 2; s: 0; p:-6;  a:        2*1E-7; b:        2*1e-7),
    ( j: 2; s: 0; p:-5;  a:       -2*1E-7; b:       -2*1e-7),
    ( j: 2; s: 0; p:-4;  a:       14*1E-7; b:       13*1e-7),
    ( j: 2; s: 0; p:-3;  a:      -63*1E-7; b:       13*1e-7),
    ( j: 2; s: 0; p:-2;  a:      136*1E-7; b:     -236*1e-7),
    ( j: 2; s: 0; p:-1;  a:      273*1E-7; b:     1065*1e-7),
    ( j: 2; s: 0; p: 0;  a:      251*1E-7; b:      149*1e-7),
    ( j: 2; s: 0; p: 1;  a:      -25*1E-7; b:       -9*1e-7),
    ( j: 2; s: 0; p: 2;  a:        9*1E-7; b:       -2*1e-7),
    ( j: 2; s: 0; p: 3;  a:       -8*1E-7; b:        7*1e-7),
    ( j: 3; s: 0; p:-2;  a:        2*1E-7; b:      -10*1e-7),
    ( j: 3; s: 0; p:-1;  a:       19*1E-7; b:       35*1e-7),
    ( j: 3; s: 0; p: 0;  a:       10*1E-7; b:        3*1e-7)
    );
  (*@\\\0000000235*)
begin
  if (index>=low(pluto_term)) and (index<=high(pluto_term)) then
    result:=pluto_term[index]
  else
    result:=empty_pluto_term;
  end;
(*@\\\0000000301*)
(*@/// function TPlutoMeeus.LongitudeFactor(index: integer):TPlutoMeeusEntry; *)
function TPlutoMeeus.LongitudeFactor(index: integer):TPlutoMeeusEntry;
const
  (*@/// pluto_term:array[0..42] of TPlutoMeeusEntry = (..); *)
  pluto_term:array[0..42] of TPlutoMeeusEntry = (
    ( j: 0; s: 0; p: 1;  a:-19799805*1e-6; b: 19850055*1e-6),
    ( j: 0; s: 0; p: 2;  a:   897144*1e-6; b: -4954829*1e-6),
    ( j: 0; s: 0; p: 3;  a:   611149*1e-6; b:  1211027*1e-6),
    ( j: 0; s: 0; p: 4;  a:  -341243*1e-6; b:  -189585*1e-6),
    ( j: 0; s: 0; p: 5;  a:   129287*1e-6; b:   -34992*1e-6),
    ( j: 0; s: 0; p: 6;  a:   -38164*1e-6; b:    30893*1e-6),
    ( j: 0; s: 1; p:-1;  a:    20442*1e-6; b:    -9987*1e-6),
    ( j: 0; s: 1; p: 0;  a:    -4063*1e-6; b:    -5071*1e-6),
    ( j: 0; s: 1; p: 1;  a:    -6016*1e-6; b:    -3336*1e-6),
    ( j: 0; s: 1; p: 2;  a:    -3956*1e-6; b:     3039*1e-6),
    ( j: 0; s: 1; p: 3;  a:     -667*1e-6; b:     3572*1e-6),
    ( j: 0; s: 2; p:-2;  a:     1276*1e-6; b:      501*1e-6),
    ( j: 0; s: 2; p:-1;  a:     1152*1e-6; b:     -917*1e-6),
    ( j: 0; s: 2; p: 0;  a:      630*1e-6; b:    -1277*1e-6),
    ( j: 1; s:-1; p: 0;  a:     2571*1e-6; b:     -459*1e-6),
    ( j: 1; s:-1; p: 1;  a:      899*1e-6; b:    -1449*1e-6),
    ( j: 1; s: 0; p:-3;  a:    -1016*1e-6; b:     1043*1e-6),
    ( j: 1; s: 0; p:-2;  a:    -2343*1e-6; b:    -1012*1e-6),
    ( j: 1; s: 0; p:-1;  a:     7042*1e-6; b:      788*1e-6),
    ( j: 1; s: 0; p: 0;  a:     1199*1e-6; b:     -338*1e-6),
    ( j: 1; s: 0; p: 1;  a:      418*1e-6; b:      -67*1e-6),
    ( j: 1; s: 0; p: 2;  a:      120*1e-6; b:     -274*1e-6),
    ( j: 1; s: 0; p: 3;  a:      -60*1e-6; b:     -159*1e-6),
    ( j: 1; s: 0; p: 4;  a:      -82*1e-6; b:      -29*1e-6),
    ( j: 1; s: 1; p:-3;  a:      -36*1e-6; b:      -29*1e-6),
    ( j: 1; s: 1; p:-2;  a:      -40*1e-6; b:        7*1e-6),
    ( j: 1; s: 1; p:-1;  a:      -14*1e-6; b:       22*1e-6),
    ( j: 1; s: 1; p: 0;  a:        4*1e-6; b:       13*1e-6),
    ( j: 1; s: 1; p: 1;  a:        5*1e-6; b:        2*1e-6),
    ( j: 1; s: 1; p: 3;  a:       -1*1e-6; b:        0*1e-6),
    ( j: 2; s: 0; p:-6;  a:        2*1e-6; b:        0*1e-6),
    ( j: 2; s: 0; p:-5;  a:       -4*1e-6; b:        5*1e-6),
    ( j: 2; s: 0; p:-4;  a:        4*1e-6; b:       -7*1e-6),
    ( j: 2; s: 0; p:-3;  a:       14*1e-6; b:       24*1e-6),
    ( j: 2; s: 0; p:-2;  a:      -49*1e-6; b:      -34*1e-6),
    ( j: 2; s: 0; p:-1;  a:      163*1e-6; b:      -48*1e-6),
    ( j: 2; s: 0; p: 0;  a:        9*1e-6; b:      -24*1e-6),
    ( j: 2; s: 0; p: 1;  a:       -4*1e-6; b:        1*1e-6),
    ( j: 2; s: 0; p: 2;  a:       -3*1e-6; b:        1*1e-6),
    ( j: 2; s: 0; p: 3;  a:        1*1e-6; b:        3*1e-6),
    ( j: 3; s: 0; p:-2;  a:       -3*1e-6; b:       -1*1e-6),
    ( j: 3; s: 0; p:-1;  a:        5*1e-6; b:       -3*1e-6),
    ( j: 3; s: 0; p: 0;  a:        0*1e-6; b:        0*1e-6)
    );
  (*@\\\0000000235*)
begin
  if (index>=low(pluto_term)) and (index<=high(pluto_term)) then
    result:=pluto_term[index]
  else
    result:=empty_pluto_term;
  end;
(*@\\\0000000331*)
(*@/// function TPlutoMeeus.LatitudeFactor(index: integer):TPlutoMeeusEntry; *)
function TPlutoMeeus.LatitudeFactor(index: integer):TPlutoMeeusEntry;
const
  (*@/// pluto_term:array[0..42] of TPlutoMeeusEntry = (..); *)
  pluto_term:array[0..38] of TPlutoMeeusEntry = (
    ( j: 0; s: 0; p: 1;  a: -5452852*1e-6; b:-14974862*1e-6),
    ( j: 0; s: 0; p: 2;  a:  3527812*1e-6; b:  1672790*1e-6),
    ( j: 0; s: 0; p: 3;  a: -1050748*1e-6; b:   327647*1e-6),
    ( j: 0; s: 0; p: 4;  a:   178690*1e-6; b:  -292153*1e-6),
    ( j: 0; s: 0; p: 5;  a:    18650*1e-6; b:   100340*1e-6),
    ( j: 0; s: 0; p: 6;  a:   -30697*1e-6; b:   -25823*1e-6),
    ( j: 0; s: 1; p:-1;  a:     4878*1e-6; b:    11248*1e-6),
    ( j: 0; s: 1; p: 0;  a:      226*1e-6; b:      -64*1e-6),
    ( j: 0; s: 1; p: 1;  a:     2030*1e-6; b:     -836*1e-6),
    ( j: 0; s: 1; p: 2;  a:       69*1e-6; b:     -604*1e-6),
    ( j: 0; s: 1; p: 3;  a:     -247*1e-6; b:     -567*1e-6),
    ( j: 0; s: 2; p:-2;  a:      -57*1e-6; b:        1*1e-6),
    ( j: 0; s: 2; p:-1;  a:     -122*1e-6; b:      175*1e-6),
    ( j: 0; s: 2; p: 0;  a:      -49*1e-6; b:     -164*1e-6),
    ( j: 1; s:-1; p: 0;  a:     -197*1e-6; b:      199*1e-6),
    ( j: 1; s:-1; p: 1;  a:      -25*1e-6; b:      217*1e-6),
    ( j: 1; s: 0; p:-3;  a:      589*1e-6; b:     -248*1e-6),
    ( j: 1; s: 0; p:-2;  a:     -269*1e-6; b:      711*1e-6),
    ( j: 1; s: 0; p:-1;  a:      185*1e-6; b:      193*1e-6),
    ( j: 1; s: 0; p: 0;  a:      315*1e-6; b:      807*1e-6),
    ( j: 1; s: 0; p: 1;  a:     -130*1e-6; b:      -43*1e-6),
    ( j: 1; s: 0; p: 2;  a:        5*1e-6; b:        3*1e-6),
    ( j: 1; s: 0; p: 3;  a:        2*1e-6; b:       17*1e-6),
    ( j: 1; s: 0; p: 4;  a:        2*1e-6; b:        5*1e-6),
    ( j: 1; s: 1; p:-3;  a:        2*1e-6; b:        3*1e-6),
    ( j: 1; s: 1; p:-2;  a:        3*1e-6; b:        1*1e-6),
    ( j: 1; s: 1; p:-1;  a:        2*1e-6; b:       -1*1e-6),
    ( j: 1; s: 1; p: 0;  a:        1*1e-6; b:       -1*1e-6),
    ( j: 1; s: 1; p: 1;  a:        0*1e-6; b:       -1*1e-6),
  { ( j: 1; s: 1; p: 3;  a:        0*1e-6; b:        0*1e-6), }
    ( j: 2; s: 0; p:-6;  a:        0*1e-6; b:       -2*1e-6),
    ( j: 2; s: 0; p:-5;  a:        2*1e-6; b:        2*1e-6),
    ( j: 2; s: 0; p:-4;  a:       -7*1e-6; b:        0*1e-6),
    ( j: 2; s: 0; p:-3;  a:       10*1e-6; b:       -8*1e-6),
    ( j: 2; s: 0; p:-2;  a:       -3*1e-6; b:       20*1e-6),
    ( j: 2; s: 0; p:-1;  a:        6*1e-6; b:        5*1e-6),
    ( j: 2; s: 0; p: 0;  a:       14*1e-6; b:       17*1e-6),
    ( j: 2; s: 0; p: 1;  a:       -2*1e-6; b:        0*1e-6),
  { ( j: 2; s: 0; p: 2;  a:        0*1e-6; b:        0*1e-6), }
  { ( j: 2; s: 0; p: 3;  a:        0*1e-6; b:        0*1e-6), }
    ( j: 3; s: 0; p:-2;  a:        0*1e-6; b:        1*1e-6),
  { ( j: 3; s: 0; p:-1;  a:        0*1e-6; b:        0*1e-6), }
    ( j: 3; s: 0; p: 0;  a:        1*1e-6; b:        0*1e-6)
    );
  (*@\\\0000000235*)
begin
  if (index>=low(pluto_term)) and (index<=high(pluto_term)) then
    result:=pluto_term[index]
  else
    result:=empty_pluto_term;
  end;
(*@\\\0000000301*)

(*@/// procedure TPlutoMeeus.FinishCalculation(var v:Tector); *)
procedure TPlutoMeeus.FinishCalculation(var v:TVector);
var
  rektaszension,declination: extended;
begin
  EclipticToEquatorial(Epoch_J2000,v.b,v.l,rektaszension,declination);
  ConvertEquinoxJ2000toDate(Fdate,rektaszension,declination);
  EquatorialToEcliptic(FDate,rektaszension,declination,v.b,v.l);
  end;

(*@\\\*)
(*@\\\*)
(*@\\\003000030100032E000301*)
(*$ifdef delphi_ge_2 *) (*$warnings off *) (*$endif *)
end.
(*@\\\0001000011000801*)
