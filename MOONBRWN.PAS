unit moonbrwn;
  (* Moon Theory of E.W.Brown - improved version (ILE) of 1954 *)
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
(*@\\\000C00080100082D*)
(*@/// implementation *)
implementation

type
  (*@/// TTermN = record .. end; *)
  TTermN = record
    p,q,r,s: shortint;
    N: extended;                  (* arc seconds *)
    end;
  (*@\\\0000000330*)
  (*@/// TTerm = record .. end; *)
  TTerm = record
    p,q,r,s: shortint;
    dl, ds, gc, dp: extended;     (* arc seconds / kilometers *)
    end;
  (*@\\\0000000102*)
  (*@/// TDelauny = record .. end; *)
  TDelauny = record
    t0,t1,t2: extended;  (* mean values *)
    s1,s2,s3,s4,s5,s6,s7: extended;  (* long periodic corrections - arc seconds *)
    end;
  (*@\\\*)
  T_polynomial_term_planet=array[0..1] of extended;
  TPertubation = (_dl, _ds, _gc, _dp, _n);
  (*@/// TMoonBrown=class(TCoordinateCalcMoon) *)
  TMoonBrown=class(TCoordinateCalcMoon)
  protected
    function planetary_terms_longitude:extended;
    function CalcDelauny(factors:TDelauny):extended;
    function CalcPertubationTerm(index: TPertubation):extended;
    function CalcDeltaGamma:extended;

    function CalcLongitude:extended;  override;
    function CalcLatitude:extended;   Override;
    function CalcRadius:extended;     override;
    end;
  (*@\\\0002000125000125*)

const
  (*@/// solar_pertubation_N: array[0..9] of TTermN = (..); *)
  solar_pertubation_N: array[0..9] of TTermN = (
    ( p: 0; q: 0; r:1; s:-2; N: -526.069),
    ( p: 0; q: 0; r:1; s:-4; N:   -3.352),
    ( p:+1; q: 0; r:1; s:-2; N:  +44.297),
    ( p:+1; q: 0; r:1; s:-4; N:   -6.000),
    ( p:-1; q: 0; r:1; s: 0; N:  +20.599),
    ( p:-1; q: 0; r:1; s:-2; N:  -30.598),
    ( p:-2; q: 0; r:1; s: 0; N:  -24.649),
    ( p:-2; q: 0; r:1; s:-2; N:   -2.000),
    ( p: 0; q:+1; r:1; s:-2; N:  -22.571),
    ( p: 0; q:-1; r:1; s:-2; N:  +10.985)
    );
  (*@\\\0000000201*)
  (*@/// solar_pertubation: array[0..103] of TTerm = (..); *)
  solar_pertubation: array[0..103] of TTerm = (
    (p: 0; q: 0; r: 0; s: 4; dl:   13.902; ds:   14.06; gc:-0.001; dp:   0.2607),
    (p: 0; q: 0; r: 0; s: 3; dl:    0.403; ds:   -4.01; gc:+0.394; dp:   0.0023),
    (p: 0; q: 0; r: 0; s: 2; dl: 2369.912; ds: 2373.36; gc:+0.601; dp:  28.2333),
    (p: 0; q: 0; r: 0; s: 1; dl: -125.154; ds: -112.79; gc:-0.725; dp:  -0.9781),
    (p: 1; q: 0; r: 0; s: 4; dl:    1.979; ds:    6.98; gc:-0.445; dp:   0.0433),
    (p: 1; q: 0; r: 0; s: 2; dl:  191.953; ds:  192.72; gc:+0.029; dp:   3.0861),
    (p: 1; q: 0; r: 0; s: 1; dl:   -8.466; ds:  -13.51; gc:+0.455; dp:  -0.1093),
    (p: 1; q: 0; r: 0; s: 0; dl:22639.500; ds:22609.07; gc:+0.079; dp: 186.5398),
    (p: 1; q: 0; r: 0; s:-1; dl:   18.609; ds:    3.59; gc:-0.094; dp:   0.0118),
    (p: 1; q: 0; r: 0; s:-2; dl:-4586.465; ds:-4578.13; gc:-0.077; dp:  34.3117),
    (p: 1; q: 0; r: 0; s:-3; dl:   +3.215; ds:    5.44; gc:+0.192; dp:  -0.0386),
    (p: 1; q: 0; r: 0; s:-4; dl:  -38.428; ds:  -38.64; gc:+0.001; dp:   0.6008),
    (p: 1; q: 0; r: 0; s:-6; dl:   -0.393; ds:   -1.43; gc:-0.092; dp:   0.0086),
    (p: 0; q: 1; r: 0; s: 4; dl:   -0.289; ds:   -1.59; gc:+0.123; dp:  -0.0053),
    (p: 0; q: 1; r: 0; s: 2; dl:  -24.420; ds:  -25.10; gc:+0.040; dp:  -0.3000),
    (p: 0; q: 1; r: 0; s: 1; dl:   18.023; ds:   17.93; gc:+0.007; dp:   0.1494),
    (p: 0; q: 1; r: 0; s: 0; dl: -668.146; ds: -126.98; gc:-1.302; dp:  -0.3997),
    (p: 0; q: 1; r: 0; s:-1; dl:    0.560; ds:    0.32; gc:-0.001; dp:  -0.0037),
    (p: 0; q: 1; r: 0; s:-2; dl: -165.145; ds: -165.06; gc:+0.054; dp:   1.9178),
    (p: 0; q: 1; r: 0; s:-4; dl:   -1.877; ds:   -6.46; gc:-0.416; dp:   0.0339),
    (p: 2; q: 0; r: 0; s: 4; dl:    0.213; ds:    1.02; gc:-0.074; dp:   0.0054),
    (p: 2; q: 0; r: 0; s: 2; dl:   14.387; ds:   14.78; gc:-0.017; dp:   0.2833),
    (p: 2; q: 0; r: 0; s: 1; dl:   -0.586; ds:   -1.20; gc:+0.054; dp:  -0.0100),
    (p: 2; q: 0; r: 0; s: 0; dl:  769.016; ds:  767.96; gc:+0.107; dp:  10.1657),
    (p: 2; q: 0; r: 0; s:-1; dl:   +1.750; ds:    2.01; gc:-0.018; dp:   0.0155),
    (p: 2; q: 0; r: 0; s:-2; dl: -211.656; ds: -152.53; gc:+5.679; dp:  -0.3039),
    (p: 2; q: 0; r: 0; s:-3; dl:   +1.225; ds:    0.91; gc:-0.030; dp:  -0.0088),
    (p: 2; q: 0; r: 0; s:-4; dl:  -30.773; ds:  -34.07; gc:-0.308; dp:   0.3722),
    (p: 2; q: 0; r: 0; s:-6; dl:   -0.570; ds:   -1.40; gc:-0.074; dp:   0.0109),
    (p: 1; q: 1; r: 0; s: 2; dl:   -2.921; ds:  -11.75; gc:+0.787; dp:  -0.0484),
    (p: 1; q: 1; r: 0; s: 1; dl:   +1.267; ds:    1.52; gc:-0.022; dp:   0.0164),
    (p: 1; q: 1; r: 0; s: 0; dl: -109.673; ds: -115.18; gc:+0.461; dp:  -0.9490),
    (p: 1; q: 1; r: 0; s:-2; dl: -205.962; ds: -182.36; gc:+2.056; dp:  +1.4437),
    (p: 1; q: 1; r: 0; s:-3; dl:    0.233; ds:    0.36; gc: 0.012; dp:  -0.0025),
    (p: 1; q: 1; r: 0; s:-4; dl:   -4.391; ds:   -9.66; gc:-0.471; dp:   0.0673),
    (p: 1; q:-1; r: 0; s:+4; dl:    0.283; ds:    1.53; gc:-0.111; dp:  +0.0060),
    (p: 1; q:-1; r: 0; s: 2; dl:   14.577; ds:   31.70; gc:-1.540; dp:  +0.2302),
    (p: 1; q:-1; r: 0; s: 0; dl:  147.687; ds:  138.76; gc:+0.679; dp:  +1.1528),
    (p: 1; q:-1; r: 0; s:-1; dl:   -1.089; ds:    0.55; gc:+0.021; dp:   0.0   ),
    (p: 1; q:-1; r: 0; s:-2; dl:   28.475; ds:   23.59; gc:-0.443; dp:  -0.2257),
    (p: 1; q:-1; r: 0; s:-3; dl:   -0.276; ds:   -0.38; gc:-0.006; dp:  -0.0036),
    (p: 1; q:-1; r: 0; s:-4; dl:    0.636; ds:    2.27; gc:+0.146; dp:  -0.0102),
    (p: 0; q: 2; r: 0; s: 2; dl:   -0.189; ds:   -1.68; gc:+0.131; dp:  -0.0028),
    (p: 0; q: 2; r: 0; s: 0; dl:   -7.486; ds:   -0.66; gc:-0.037; dp:  -0.0086),
    (p: 0; q: 2; r: 0; s:-2; dl:   -8.096; ds:  -16.35; gc:-0.740; dp:   0.0918),
    (p: 0; q: 0; r: 2; s: 2; dl:   -5.741; ds:   -0.04; gc: 0.0  ; dp:  -0.0009),
    (p: 0; q: 0; r: 2; s: 1; dl:    0.255; ds:    0.0 ; gc: 0.0  ; dp:   0.0   ),
    (p: 0; q: 0; r: 2; s: 0; dl: -411.608; ds:   -0.20; gc: 0.0  ; dp:  -0.0124),
    (p: 0; q: 0; r: 2; s:-1; dl:    0.584; ds:    0.84; gc: 0.0  ; dp:  +0.0071),
    (p: 0; q: 0; r: 2; s:-2; dl:  -55.173; ds:  -52.14; gc: 0.0  ; dp:  -0.1052),
    (p: 0; q: 0; r: 2; s:-3; dl:    0.254; ds:    0.25; gc: 0.0  ; dp:  -0.0017),
    (p: 0; q: 0; r: 2; s:-4; dl:   +0.025; ds:   -1.67; gc: 0.0  ; dp:  +0.0031),
    (p: 3; q: 0; r: 0; s:+2; dl:    1.060; ds:    2.96; gc:-0.166; dp:   0.0243),
    (p: 3; q: 0; r: 0; s: 0; dl:   36.124; ds:   50.64; gc:-1.300; dp:   0.6215),
    (p: 3; q: 0; r: 0; s:-2; dl:  -13.193; ds:  -16.40; gc:+0.258; dp:  -0.1187),
    (p: 3; q: 0; r: 0; s:-4; dl:   -1.187; ds:   -0.74; gc:+0.042; dp:   0.0074),
    (p: 3; q: 0; r: 0; s:-6; dl:   -0.293; ds:   -0.31; gc:-0.002; dp:   0.0046),
    (p: 2; q: 1; r: 0; s: 2; dl:   -0.290; ds:   -1.45; gc:+0.116; dp:  -0.0051),
    (p: 2; q: 1; r: 0; s: 0; dl:   -7.649; ds:  -10.56; gc:+0.259; dp:  -0.1038),
    (p: 2; q: 1; r: 0; s:-2; dl:   -8.627; ds:   -7.59; gc:+0.078; dp:  -0.0192),
    (p: 2; q: 1; r: 0; s:-4; dl:   -2.740; ds:   -2.54; gc:+0.022; dp:   0.0324),
    (p: 2; q:-1; r: 0; s:+2; dl:    1.181; ds:    3.32; gc:-0.212; dp:   0.0213),
    (p: 2; q:-1; r: 0; s: 0; dl:    9.703; ds:   11.67; gc:-0.151; dp:   0.1268),
    (p: 2; q:-1; r: 0; s:-1; dl:   -0.352; ds:   -0.37; gc:+0.001; dp:  -0.0028),
    (p: 2; q:-1; r: 0; s:-2; dl:   -2.494; ds:   -1.17; gc:-0.003; dp:  -0.0017),
    (p: 2; q:-1; r: 0; s:-4; dl:    0.360; ds:    0.20; gc:-0.012; dp:  -0.0043),
    (p: 1; q: 2; r: 0; s: 0; dl:   -1.167; ds:   -1.25; gc:+0.008; dp:  -0.0106),
    (p: 1; q: 2; r: 0; s:-2; dl:   -7.412; ds:   -6.12; gc:+0.117; dp:   0.0484),
    (p: 1; q: 2; r: 0; s:-4; dl:   -0.311; ds:   -0.65; gc:-0.032; dp:   0.0044),
    (p: 1; q:-2; r: 0; s: 2; dl:   +0.757; ds:    1.82; gc:-0.105; dp:   0.0112),
    (p: 1; q:-2; r: 0; s: 0; dl:   +2.580; ds:    2.32; gc:+0.027; dp:   0.0196),
    (p: 1; q:-2; r: 0; s:-2; dl:   +2.533; ds:    2.40; gc:-0.014; dp:  -0.0212),
    (p: 0; q: 3; r: 0; s:-2; dl:   -0.344; ds:   -0.57; gc:-0.025; dp:  +0.0036),
    (p: 1; q: 0; r: 2; s: 2; dl:   -0.992; ds:   -0.02; gc: 0.0  ; dp:   0.0   ),
    (p: 1; q: 0; r: 2; s: 0; dl:  -45.099; ds:   -0.02; gc: 0.0  ; dp:  -0.0010),
    (p: 1; q: 0; r: 2; s:-2; dl:   -0.179; ds:   -9.52; gc: 0.0  ; dp:  -0.0833),
    (p: 1; q: 0; r: 2; s:-4; dl:   -0.301; ds:   -0.33; gc: 0.0  ; dp:   0.0014),
    (p: 1; q: 0; r:-2; s: 2; dl:   -6.382; ds:   -3.37; gc: 0.0  ; dp:  -0.0481),
    (p: 1; q: 0; r:-2; s: 0; dl:   39.528; ds:   85.13; gc: 0.0  ; dp:  -0.7136),
    (p: 1; q: 0; r:-2; s:-2; dl:    9.366; ds:    0.71; gc: 0.0  ; dp:  -0.0112),
    (p: 1; q: 0; r:-2; s:-4; dl:    0.202; ds:    0.02; gc: 0.0  ; dp:   0.0   ),
    (p: 0; q: 1; r: 2; s: 0; dl:    0.415; ds:    0.10; gc: 0.0  ; dp:   0.0013),
    (p: 0; q: 1; r: 2; s:-2; dl:   -2.152; ds:   -2.26; gc: 0.0  ; dp:  -0.0066),
    (p: 0; q: 1; r:-2; s: 2; dl:   -1.440; ds:   -1.30; gc: 0.0  ; dp:  +0.0014),
    (p: 0; q: 1; r:-2; s:-2; dl:    0.384; ds:   -0.04; gc: 0.0  ; dp:   0.0   ),
    (p: 4; q: 0; r: 0; s: 0; dl:   +1.938; ds:   +3.60; gc:-0.145; dp:  +0.0401),
    (p: 4; q: 0; r: 0; s:-2; dl:   -0.952; ds:   -1.58; gc:+0.052; dp:  -0.0130),
    (p: 3; q: 1; r: 0; s: 0; dl:   -0.551; ds:   -0.94; gc:+0.032; dp:  -0.0097),
    (p: 3; q: 1; r: 0; s:-2; dl:   -0.482; ds:   -0.57; gc:+0.005; dp:  -0.0045),
    (p: 3; q:-1; r: 0; s: 0; dl:    0.681; ds:    0.96; gc:-0.026; dp:   0.0115),
    (p: 2; q: 2; r: 0; s:-2; dl:   -0.297; ds:   -0.27; gc: 0.002; dp:  -0.0009),
    (p: 2; q:-2; r: 0; s:-2; dl:    0.254; ds:   +0.21; gc:-0.003; dp:   0.0   ),
    (p: 1; q: 3; r: 0; s:-2; dl:   -0.250; ds:   -0.22; gc: 0.004; dp:   0.0014),
    (p: 2; q: 0; r: 2; s: 0; dl:   -3.996; ds:    0.0 ; gc: 0.0  ; dp:  +0.0004),
    (p: 2; q: 0; r: 2; s:-2; dl:    0.557; ds:   -0.75; gc: 0.0  ; dp:  -0.0090),
    (p: 2; q: 0; r:-2; s: 2; dl:   -0.459; ds:   -0.38; gc: 0.0  ; dp:  -0.0053),
    (p: 2; q: 0; r:-2; s: 0; dl:   -1.298; ds:    0.74; gc: 0.0  ; dp:  +0.0004),
    (p: 2; q: 0; r:-2; s:-2; dl:    0.538; ds:    1.14; gc: 0.0  ; dp:  -0.0141),
    (p: 1; q: 1; r: 2; s: 0; dl:    0.263; ds:    0.02; gc: 0.0  ; dp:   0.0   ),
    (p: 1; q: 1; r:-2; s:-2; dl:    0.426; ds:   +0.07; gc: 0.0  ; dp:  -0.0006),
    (p: 1; q:-1; r: 2; s: 0; dl:   -0.304; ds:   +0.03; gc: 0.0  ; dp:  +0.0003),
    (p: 1; q:-1; r:-2; s: 2; dl:   -0.372; ds:   -0.19; gc: 0.0  ; dp:  -0.0027),
    (p: 0; q: 0; r: 4; s: 0; dl:   +0.418; ds:    0.0 ; gc: 0.0  ; dp:   0.0   ),
    (p: 3; q: 0; r: 2; s: 0; dl:   -0.330; ds:   -0.04; gc: 0.0  ; dp:   0.0   )
    );
  (*@\\\0000000120*)
  (*@/// Delauny terms: TDelauny = ( .. ); *)
  Moon_mean_longitude: TDelauny = (
    t0: 218.31617; t1: 481267.88088; t2: -4.06/3600;
    s1: 0.84; s2: 0.31; s3: 14.27; s4:  7.26; s5:  0.28; s6: 0.24; s7: 0.00 );
  Moon_Mean_Anomaly: TDelauny = (
    t0: 134.96292; t1: 477198.86753; t2: 33.25/3600;
    s1: 2.94; s2: 0.31; s3: 14.27; s4:  9.34; s5:  1.12; s6: 0.83; s7: 0.00 );
  Sun_Mean_Anomaly: TDelauny = (
    t0: 357.52543; t1: 35999.04944; t2: -0.58/3600;
    s1:-6.40; s2: 0.00; s3:  0.00; s4:  0.00; s5:  0.00; s6:-1.89; s7: 0.00 );
  Moon_Mean_Longitude_Node: TDelauny = (
    t0: 93.27283; t1: 483202.01873; t2: -11.56/3600;
    s1: 0.21; s2: 0.31; s3: 14.27; s4:-88.70; s5:-15.30; s6: 0.24; s7:-1.86 );
  Moon_Mean_Elongation: TDelauny = (
    t0: 297.85027; t1: 445267.11135; t2: -5.15/3600;
    (* Delta D = Delta L0 - Delta ls *)
    s1: 7.24; s2: 0.31; s3: 14.27; s4:  7.26; s5:  0.28; s6: 2.13; s7: 0.00 );
  (*@\\\0000000F01*)

(*@/// function TMoonBrown.planetary_terms_longitude:extended; *)
function TMoonBrown.planetary_terms_longitude:extended;
var
  t: extended;
begin
  t:=century_term(FDate);
  result:=(
    0.82*sin_d((0.7736  -62.5512*t)*360)+0.31*sin_d((0.0466 -125.1025*t)*360)+
    0.35*sin_d((0.5785  -25.1042*t)*360)+0.66*sin_d((0.4591+1335.8075*t)*360)+
    0.64*sin_d((0.3130  -91.5680*t)*360)+1.14*sin_d((0.1480+1331.2898*t)*360)+
    0.21*sin_d((0.5918+1056.5859*t)*360)+0.44*sin_d((0.5784+1322.8595*t)*360)+
    0.24*sin_d((0.2275   -5.7374*t)*360)+0.28*sin_d((0.2965   +2.6929*t)*360)+
    0.33*sin_d((0.3132   +6.3368*t)*360)
    )/3600;
  END;
(*@\\\*)
(*@/// function TMoonBrown.CalcLongitude:extended; *)
function TMoonBrown.CalcLongitude:extended;
begin
  result:=CalcDelauny(Moon_mean_longitude)+
          CalcPertubationTerm(_dl)+
          planetary_terms_longitude;
  end;
(*@\\\0000000316*)
(*@/// function TMoonBrown.CalcLatitude:extended; *)
function TMoonBrown.CalcLatitude:extended;
var
  s: extended;
begin
  s:=CalcDelauny(Moon_Mean_Longitude_Node)+CalcPertubationTerm(_ds);
  result:=(1.000002708+139.978*CalcDeltaGamma)*
            (18519.70/3600+CalcPertubationTerm(_gc))*sin_d(s)
          -6.24/3600*sin_d(3*s)+CalcPertubationTerm(_n);
  end;
(*@\\\0000000735*)
(*@/// function TMoonBrown.CalcRadius:extended; *)
function TMoonBrown.CalcRadius:extended;
var
  sin_p: extended;
begin
  sin_p:=0.999953253*(3422.7/3600+CalcPertubationTerm(_dp))*pi/180;
  result:=6378.15/sin_p;
  end;
(*@\\\0000000612*)
(*@/// function TMoonBrown.CalcDelauny(factors:TDelauny):extended; *)
function TMoonBrown.CalcDelauny(factors:TDelauny):extended;
var
  t: extended;
begin
  t:=century_term(FDate);
  result:=put_in_360(
    factors.t0+
    factors.t1*t+
    factors.t2*t*t+
    factors.s1*sin_d((0.19833+0.05611*t)*360)/3600+
    factors.s2*sin_d((0.27869+0.04508*t)*360)/3600+
    factors.s3*sin_d((0.16827-0.36903*t)*360)/3600+
    factors.s4*sin_d((0.34734-5.37261*t)*360)/3600+
    factors.s5*sin_d((0.10498-5.37899*t)*360)/3600+
    factors.s6*sin_d((0.42681-0.41855*t)*360)/3600+
    factors.s7*sin_d((0.14943-5.37511*t)*360)/3600
    );
  end;
(*@\\\*)
(*@/// function TMoonBrown.CalcPertubationTerm(index: TPertubation):extended; *)
function TMoonBrown.CalcPertubationTerm(index: TPertubation):extended;
var
  l,ls,f,d: extended;
  t: extended;
  delta_gamma: extended;
(*@/// function calc(p,q,r,s: shortint; A: extended):extended; *)
function calc(p,q,r,s: shortint; A: extended):extended;
var
  arg: extended;
begin
  arg:=p*l+q*ls+r*f+s*d;
  case index of
    _dl, _ds, _n: result:=sin_d(arg);
    _gc, _dp    : result:=cos_d(arg);
    else          result:=0;   (* This can't happen - avoid Delphi warning *)
    end;
    result:=result*exp(abs(p)*ln(1.000002208))
                  *exp(abs(q)*ln(1.0-0.002495388*(t+1)))
                  *exp(abs(r)*ln(1.000002708+139.978*delta_gamma))
                  *a*(1/3600);
  end;
(*@\\\000000094E*)
var
  i: integer;
begin
  l:=CalcDelauny(Moon_Mean_Anomaly);
  ls:=CalcDelauny(Sun_mean_Anomaly);
  f:=CalcDelauny(Moon_Mean_Longitude_Node);
  d:=CalcDelauny(Moon_Mean_Elongation);
  result:=0;
  t:=century_term(FDate);
  delta_gamma:=CalcDeltaGamma;
  if index=_n then begin
    for i:=low(solar_pertubation_N) to high(solar_pertubation_N) do
      WITH solar_pertubation_N[i] do
        result:=result+calc(p,q,r,s,N);
    end
  else begin
    for i:=low(solar_pertubation) to high(solar_pertubation) do
      WITH solar_pertubation[i] do
        case index of
          _dl: result:=result+calc(p,q,r,s,dl);
          _ds: result:=result+calc(p,q,r,s,ds);
          _gc: result:=result+calc(p,q,r,s,gc);
          _dp: result:=result+calc(p,q,r,s,dp);
          end;
    end;
  end;
(*@\\\0000000F01*)
(*@/// function TMoonBrown.CalcDeltaGamma:extended; *)
function TMoonBrown.CalcDeltaGamma:extended;
var
  t: extended;
begin
  t:=century_term(FDate);
  result:=-3332E-9 * sin_d((0.59734-5.37261*t)*360)
           -539E-9 * sin_d((0.35498-5.37899*t)*360)
            -64E-9 * sin_d((0.39943-5.37511*t)*360);
  end;
(*@\\\0000000601*)


(*@/// function moon_coord(date:TdateTime):TVector; *)
function moon_coord(date:TdateTime):TVector;
begin
  result:=TMoonBrown.calc_coord(date);
  end;
(*@\\\*)
(*@\\\003000190100192D000927*)
(*$ifdef delphi_ge_2 *) (*$warnings off *) (*$endif *)
end.
(*@\\\0001000011000B05*)
