unit ah_math;

 {$i ah_def.inc }
(*$define nomath *)
(*$b-*)   { I may make use of the shortcut boolean eval }

(*@/// interface *)
interface

{ Angular functions }
function tan(x:extended):extended;
function arctan2(a,b:extended):extended;
function arcsin(x:extended):extended;
function arccos(x:extended):extended;

{ Convert degree and radians }
function deg2rad(x:extended):extended;
function rad2deg(x:extended):extended;

{ Angular functions with degrees }
function sin_d(x:extended):extended;
function cos_d(x:extended):extended;
function tan_d(x:extended):extended;
function arctan2_d(a,b:extended):extended;
function arcsin_d(x:extended):extended;
function arccos_d(x:extended):extended;
function arctan_d(x:extended):extended;

{ Limit degree value into 0..360 range }
function put_in_360(x:extended):extended;
{ Modulo operation which returns the value in the range 1..b }
function adjusted_mod(a,b:integer):integer;

function floor(x: extended): integer;
function min(x,y: longint):longint;
function max(x,y: longint):longint;
function put_in_range(x,_min,_max: longint):longint;

type
  (*@/// TVector = record *)
  TVector = record
    case integer of
      0: (x,y,z: extended);
      1: (l,b,r: extended);
    end;
  (*@\\\*)
  (*@/// TMatrix = record *)
  TMatrix = record
    xx,xy,xz: extended;
    yx,yy,yz: extended;
    zx,zy,zz: extended;
    end;
  (*@\\\*)

function ScalarProduct(const a,b: TVector):extended;
function MatrixTimesVector(const m: TMatrix; const a:TVector):TVector;
function MatrixTimesMatrix(const a,b: TMatrix):TMatrix;
function AddVectors(const a,b:TVector):TVector;
function VectorTimesScalar(const a:TVector; s:extended):TVector;
function RotationMatrix_X(angle:extended):TMatrix;
function RotationMatrix_Y(angle:extended):TMatrix;
function RotationMatrix_Z(angle:extended):TMatrix;

function RectangularToSpherical(const a:TVector):TVector;
function SphericalToRectangular(const a:TVector):TVector;

function RadialVector(l,b,r:extended):TVector;
(*@\\\*)
(*@/// implementation *)
implementation

(*$ifndef nomath *)
uses
  math;
(*$endif *)

(*@/// function deg2rad(x:extended):extended; *)
function deg2rad(x:extended):extended;
begin
  result:=x/180*pi;
  end;
(*@\\\*)
(*@/// function rad2deg(x:extended):extended; *)
function rad2deg(x:extended):extended;
begin
  result:=x*180/pi;
  end;
(*@\\\*)

(*@/// function sign(value:extended):integer; *)
function sign(value:extended):integer;
begin
  if value=0 then
    result:=0
  else if value>0 then
    result:=1
  else
    result:=-1;
  end;
(*@\\\*)

(*$ifdef nomath *)
{ D1 has no unit math, so here are the needed functions }
(*@/// function tan(x:extended):extended; *)
function tan(x:extended):extended;
begin
  result:=sin(x)/cos(x);
  end;
(*@\\\*)
(*@/// function arctan2(a,b:extended):extended; *)
function arctan2(a,b:extended):extended;
begin
  if b=0 then
    result:=sign(a)*pi/2
  else
    result:=arctan(a/b);
  if b<0 then
    result:=result+pi;
  end;
(*@\\\000200040F00040F*)
(*@/// function arcsin(x:extended):extended; *)
function arcsin(x:extended):extended;
begin
  result:=arctan2(x,sqrt(1-x*x));
  end;
(*@\\\0000000301*)
(*@/// function arccos(x:extended):extended; *)
function arccos(x:extended):extended;
begin
  result:=pi/2-arcsin(x);
  end;
(*@\\\000000031A*)
(*$else
(*@/// function tan(x:extended):extended; *)
function tan(x:extended):extended;
begin
  result:=math.tan(x);
  end;
(*@\\\*)
(*@/// function arctan2(a,b:extended):extended; *)
function arctan2(a,b:extended):extended;
begin
  result:=math.arctan2(a,b);
  end
(*@\\\*)
(*@/// function arcsin(x:extended):extended; *)
function arcsin(x:extended):extended;
begin
  result:=math.arcsin(x);
  end;
(*@\\\*)
(*@/// function arccos(x:extended):extended; *)
function arccos(x:extended):extended;
begin
  result:=math.arccos(x);
  end;
(*@\\\*)
(*$endif *)

{ Angular functions with degrees }
(*@/// function sin_d(x:extended):extended; *)
function sin_d(x:extended):extended;
begin
  sin_d:=sin(deg2rad(put_in_360(x)));
  end;
(*@\\\000000030E*)
(*@/// function cos_d(x:extended):extended; *)
function cos_d(x:extended):extended;
begin
  cos_d:=cos(deg2rad(put_in_360(x)));
  end;
(*@\\\000000030E*)
(*@/// function tan_d(x:extended):extended; *)
function tan_d(x:extended):extended;
begin
  tan_d:=tan(deg2rad(put_in_360(x)));
  end;
(*@\\\0000000324*)
(*@/// function arctan2_d(a,b:extended):extended; *)
function arctan2_d(a,b:extended):extended;
begin
  result:=rad2deg(arctan2(a,b));
  end;
(*@\\\0000000320*)
(*@/// function arcsin_d(x:extended):extended; *)
function arcsin_d(x:extended):extended;
begin
  result:=rad2deg(arcsin(x));
  end;
(*@\\\000000031D*)
(*@/// function arccos_d(x:extended):extended; *)
function arccos_d(x:extended):extended;
begin
  result:=rad2deg(arccos(x));
  end;
(*@\\\000000031D*)
(*@/// function arctan_d(x:extended):extended; *)
function arctan_d(x:extended):extended;
begin
  result:=rad2deg(arctan(x));
  end;
(*@\\\000000031E*)

(*@/// function put_in_360(x:extended):extended; *)
function put_in_360(x:extended):extended;
begin
  result:=x-round(x/360)*360;
  while result<0 do result:=result+360;
  end;
(*@\\\*)
(*@/// function adjusted_mod(a,b:integer):integer; *)
function adjusted_mod(a,b:integer):integer;
begin
  result:=a mod b;
  while result<1 do
    result:=result+b;
  end;
(*@\\\*)

(*@/// function floor(x: extended): integer; *)
function floor(x: extended): integer;
begin
  result := Trunc(x);
  if frac(x)<0 then
    dec(result);
  end;
(*@\\\*)
(*@/// function min(x,y: longint):longint; *)
function min(x,y: longint):longint;
begin
  if x<y then result:=x
         else result:=y;
  end;
(*@\\\*)
(*@/// function max(x,y: longint):longint; *)
function max(x,y: longint):longint;
begin
  if x>y then result:=x
         else result:=y;
  end;
(*@\\\*)
(*@/// function put_in_range(x,_min,_max: longint):longint; *)
function put_in_range(x,_min,_max: longint):longint;
begin
  result:=min(max(x,_min),_max);
  end;
(*@\\\0000000321*)

(*@/// function ScalarProduct(const a,b: TVector):extended; *)
function ScalarProduct(const a,b: TVector):extended;
begin
  result:=a.x*b.x+a.y*b.y+a.z*b.z;
  end;
(*@\\\0000000301*)
(*@/// function MatrixTimesVector(const m: TMatrix; const a:TVector):TVector; *)
function MatrixTimesVector(const m: TMatrix; const a:TVector):TVector;
begin
  result.x:=m.xx*a.x+m.xy*a.y+m.xz*a.z;
  result.y:=m.yx*a.x+m.yy*a.y+m.yz*a.z;
  result.z:=m.zx*a.x+m.zy*a.y+m.zz*a.z;
  end;
(*@\\\0000000501*)
(*@/// function MatrixTimesMatrix(const a,b: TMatrix):TMatrix; *)
function MatrixTimesMatrix(const a,b: TMatrix):TMatrix;
begin
  WITH result do begin
    xx:=a.xx*b.xx+a.xy*b.yx+a.xz*b.zx;
    xy:=a.xx*b.xy+a.xy*b.yy+a.xz*b.zy;
    xz:=a.xx*b.xz+a.xy*b.yz+a.xz*b.zz;
    yx:=a.yx*b.xx+a.yy*b.yx+a.yz*b.zx;
    yy:=a.yx*b.xy+a.yy*b.yy+a.yz*b.zy;
    yz:=a.yx*b.xz+a.yy*b.yz+a.yz*b.zz;
    zx:=a.zx*b.xx+a.zy*b.yx+a.zz*b.zx;
    zy:=a.zx*b.xy+a.zy*b.yy+a.zz*b.zy;
    zz:=a.zx*b.xz+a.zy*b.yz+a.zz*b.zz;
    end;
  end;
(*@\\\*)
(*@/// function AddVectors(const a,b:TVector):TVector; *)
function AddVectors(const a,b:TVector):TVector;
begin
  result.x:=a.x+b.x;
  result.y:=a.y+b.y;
  result.z:=a.z+b.z;
  end;
(*@\\\0000000514*)
(*@/// function VectorTimesScalar(const a:TVector; s:extended):TVector; *)
function VectorTimesScalar(const a:TVector; s:extended):TVector;
begin
  result.x:=a.x*s;
  result.y:=a.y*s;
  result.z:=a.z*s;
  end;
(*@\\\0000000510*)

(*@/// function RectangularToSpherical(const a:TVector):TVector; *)
function RectangularToSpherical(const a:TVector):TVector;
begin
  result.l:=put_in_360(arctan2_d(a.y,a.x));
  result.b:=arctan_d(a.z/sqrt(a.x*a.x+a.y*a.y));
  result.r:=sqrt(ScalarProduct(a,a));
  end;
(*@\\\*)
(*@/// function SphericalToRectangular(const a:TVector):TVector; *)
function SphericalToRectangular(const a:TVector):TVector;
begin
  result.x:=a.r*cos_d(a.b)*cos_d(a.l);
  result.y:=a.r*cos_d(a.b)*sin_d(a.l);
  result.z:=a.r*sin_d(a.b)           ;
  end;
(*@\\\0000000201*)

(*@/// function RotationMatrix_X(angle:extended):TMatrix; *)
function RotationMatrix_X(angle:extended):TMatrix;
begin
  WITH result do begin
    xx:=1;  xy:=0;              xz:=0;
    yx:=0;  yy:=+cos_d(angle);  yz:=+sin_d(angle);
    zx:=0;  zy:=-sin_d(angle);  zz:=+cos_d(angle);
    end;
  end;
(*@\\\0000000301*)
(*@/// function RotationMatrix_Y(angle:extended):TMatrix; *)
function RotationMatrix_Y(angle:extended):TMatrix;
begin
  WITH result do begin
    xx:=+cos_d(angle);  xy:=0;  xz:=-sin_d(angle);
    yx:=0;              yy:=1;  yz:=0;
    zx:=+sin_d(angle);  zy:=0;  zz:=+cos_d(angle);
    end;
  end;
(*@\\\0000000807*)
(*@/// function RotationMatrix_Z(angle:extended):TMatrix; *)
function RotationMatrix_Z(angle:extended):TMatrix;
begin
  WITH result do begin
    xx:=+cos_d(angle);  xy:=+sin_d(angle);  xz:=0;
    yx:=-sin_d(angle);  yy:=+cos_d(angle);  yz:=0;
    zx:=0;              zy:=0;              zz:=1;
    end;
  end;
(*@\\\0000000807*)

(*@/// function RadialVector(l,b,r:extended):TVector; *)
function RadialVector(l,b,r:extended):TVector;
begin
  result.l:=l;
  result.b:=b;
  result.r:=r;
  end;
(*@\\\*)
(*@\\\003C000B0A000B0E00190100190100100E*)
(*$ifdef delphi_ge_2 *) (*$warnings off *) (*$endif *)
end.
(*@\\\0001000011*)
