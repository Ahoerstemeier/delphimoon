{$ifndef clx}
unit mooncomp;
{$endif}

 {$i ah_def.inc }

{ Copyright 1997-2001 Andreas Hörstemeier            Version 2.1 2001-012-03 }
{ this component is public domain - please check the file moon.hlp for       }
{ more detailed info on usage and distributing                               }

{$b-}   { I may make use of the shortcut boolean eval }

{@/// interface}
interface

{@/// uses}
uses
{$ifdef fpc}
  LCLType, LCLIntf, LMessages, graphics, controls, extctrls,
{$else}
{$ifdef clx}
  types,
  qgraphics,
  qextctrls,
  qcontrols,
{$else}
{$ifdef delphi_1}
  winprocs,
  wintypes,
{$else}
  windows,
{$endif}
  messages,
  graphics,
  extctrls,
  controls,
{$endif}
{$endif}
  classes,
  sysutils,
  ah_math,
  moon;
{@\\\0000000504}

{$ifdef fpc}
  {$r moon.r32}
{$else}
{$ifdef clx}
  {$r moon.q32 }            { The File containing the bitmaps }
{$else}
{$ifdef delphi_1}
  {$r moon.r16 }            { The File containing the bitmaps }
{$else}
  {$r moon.r32 }            { The File containing the bitmaps }
{$endif}
{$endif}
{$endif}

type
  TMoonSize=(ms64,ms32,ms16);
  TMoonStyle=(msClassic,msColor,msMonochrome);
  TRotate=(rot_none,rot_90,rot_180,rot_270,rot_angle,rot_location);
  {@/// TLocation=class(TPersistent)}
  TLocation=class(TPersistent)
  private
    Fname: string;
    Flatitude, Flongitude: extended;
    Fheight: extended;
    FOnChange: TNotifyEvent;
  protected
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    procedure SetLatitude(value:extended);
    procedure SetLongitude(value:extended);
    procedure Changed;
  public
    property Height:extended read FHeight write FHeight;
    procedure Assign(Source: Tpersistent); override;
  published
    property Latitude: extended read FLatitude write SetLatitude;
    property Longitude: extended read FLongitude write SetLongitude;
    property Name: string read FName write FName;
    end;
  {@\\\}
  {@/// TMoon=class(TGraphicControl)}
  TMoon=class(TGraphicControl)
  private
    FBMP : TBitmap;
    FIcon: TIcon;
    FLimbAngle: extended;
    FAngle: integer;
  {$ifdef delphi_lt_4}
    FMaxWidth,FMaxHeight: integer;
  {$endif}
    FMoonSize: TMoonSize;
    FMoonIconSize: TMoonSize;
    FMoonColor: TColor;
    FDate: TDateTime;
    FDateChanged: boolean;
    FRotate: TRotate;
    FApollo: boolean;
    FStyle: TMoonStyle;
    FTransparent: boolean;
    FLocation: TLocation;
    procedure SetSize(Value:TMoonSize);
    procedure SetIconSize(Value:TMoonSize);
    procedure SetDate(value:TDateTime);
    procedure SetRotate(value:TRotate);
    procedure SetStyle(value:TMoonStyle);
    procedure SetTransparent(value: boolean);
    procedure SetColor(value: TColor);
    procedure SetApollo(value: boolean);
    procedure SetMoonColor(value: TColor);
    procedure SetRotAngle(value: integer);
    procedure SetLocation(value: TLocation);
    procedure LocationChange(sender: TObject);
  {$ifdef delphi_lt_4}
    procedure WMSize (var Message: TWMSize); message wm_paint;
  {$endif}

  protected
    procedure SetBitmap;
    procedure Draw_Moon(canvas:TCanvas; size:TMoonSize);
    procedure Draw_Apollo(canvas:TCanvas; angle:integer; size:TMoonSize);
    function GetIcon:TIcon;
    procedure Paint;  override;
    procedure Loaded; override;
    { not yet supported}
    property MoonIconSize:TMoonSize read FMoonIconSize write SetIconSize;
    property LimbAngle:extended read FLimbAngle write FLimbAngle;
  public
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
    property Bitmap:TBitmap read FBMP;
    property Icon:TIcon read GetIcon;
  published
    property MoonSize:TMoonSize read FMoonSize write SetSize;
    property Date: TDateTime read FDate write SetDate stored FDateChanged;
    property Rotation:TRotate read FRotate write SetRotate;
    property ShowApollo11:boolean read fApollo write SetApollo;
    property MoonStyle:TMoonStyle read fStyle write SetStyle;
    property Transparent: boolean read ftransparent write SetTransparent;
    property Color write SetColor;
    property MoonColor:TColor read FMoonColor write SetMoonColor;
    property RotationAngle:integer read FAngle write SetRotAngle;
    property Location: TLocation read FLocation write SetLocation;

    property ParentColor;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnStartDrag;
    property OnEndDrag;
  {$ifndef clx}
    property DragCursor;
  {$endif}
    property DragMode;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  {$ifdef delphi_ge_4}
    property Anchors;
  {$ifndef clx}
    property DragKind;
    property OnStartDock;
    property OnEndDock;
  {$endif}
  {$endif}
  {$ifdef fpc}
    //property AntialiasingMode;
//    property Align;
    property AutoSize;
    property BorderSpacing;
    property Constraints;
    property Enabled;
    property OnChangeBounds;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnPaint;
    property OnResize;
  {$endif}
    end;
  {@\\\0000002727}

procedure rotate_bitmap_free(source:TBitmap; angle:extended);
{@\\\000000140B}
{@/// implementation}
implementation

{$ifdef fpc}
uses
  IntfGraphics;
{$endif}

const
  transcolor_1 = clFuchsia;
  transcolor_2 = clLime;

{$ifdef fpc}
procedure rotate_bitmap(ASource: TBitmap; ARotate: TRotate);
var
  tempImage: TBitmap;
  w,h,i,j: integer;
  s_wnd, h_wnd: THandle;
  {$IFDEF FPC}
  srcImg, tmpImg: TLazIntfImage;
  {$ENDIF}
begin
  tempImage := TBitmap.Create;
  try
    tempImage.Assign(ASource);
    h := ASource.Height - 1;
    w := ASource.Width - 1;
    s_wnd := ASource.Canvas.Handle;
    h_wnd := tempImage.Canvas.Handle;
    case ARotate of
      rot_none:
        ;
      rot_90:
        begin
          srcImg := ASource.CreateIntfImage;
          tmpImg := tempImage.CreateIntfImage;
          try
            for i:=0 to w do
              for j:=0 to h do
                srcImg.Pixels[i,h-j] := tmpImg.Pixels[j,i];
            ASource.LoadFromIntfImage(srcImg);
          finally
            srcImg.free;
            tmpImg.free;
          end;
        end;
      rot_180:
        ASource.Canvas.CopyRect(
          Rect(w, h, 0, 0),
          tempImage.Canvas,
          Rect(0, 0, w, h)
        );
      rot_270:
        begin
          srcImg := ASource.CreateIntfImage;
          tmpImg := tempImage.CreateIntfImage;
          try
            for i:=0 to w do
              for j:=0 to h do
                srcImg.Pixels[w-i,j] := tmpImg.Pixels[j,i];
            ASource.LoadFromIntfImage(srcImg);
          finally
            srcImg.Free;
            tmpImg.Free;
          end;
        end;
    end;
  finally
    tempImage.free;
  end;
end;
{$else}
{@/// procedure rotate_bitmap(source:TBitmap; rotate:TRotate);}
procedure rotate_bitmap(source:TBitmap; rotate:TRotate);
var
  tempimage: TBitmap;
  w,h,i,j: integer;
{$ifndef clx}
  s_wnd, h_wnd: THandle;
{$endif}
begin
  tempimage:=NIL;
  try
    tempimage:=TBitmap.Create;
    tempimage.assign(source);
    h:=source.height-1;
    w:=source.width-1;
{$ifndef clx}
    s_wnd:=source.canvas.handle;
    h_wnd:=tempimage.canvas.handle;
{$endif}
    case rotate of
      rot_none: ;
      {@/// rot_90:   rotate pixel by pixel}
      rot_90: begin
        for i:=0 to w do
          for j:=0 to h do begin
      {$ifdef clx}
            source.canvas.copyrect(rect(i,h-j,i+1,h-j+1),tempimage.canvas,rect(j,i,j+1,i+1));
      {$else}
            setpixel(s_wnd,i,h-j,getpixel(h_wnd,j,i));
            { Much faster than using canvas.pixels[] }
      {$endif}
            end;
          end;
      {@\\\}
      {@/// rot_180:  rotate via the StretchBlt}
      rot_180: begin
      {$ifdef clx}
        source.canvas.stretchdraw(rect(w,h,0,0),tempimage);
      {$else}
        source.canvas.copyrect(rect(w,h,0,0),tempimage.canvas,rect(0,0,w,h));
      {$endif}
        end;
      {@\\\0000000201}
      {@/// rot_270:  rotate pixel by pixel}
      rot_270: begin
        for i:=0 to w do
          for j:=0 to h do
      {$ifdef clx}
            source.canvas.copyrect(rect(w-i,j,w-i+1,j+1),tempimage.canvas,rect(j,i,j+1,i+1));
      {$else}
            setpixel(s_wnd,w-i,j,getpixel(h_wnd,j,i));
      {$endif}
        end;
      {@\\\0000000401}
      end;
  finally
    tempimage.free;
    end;
  end;
{@\\\0000001801}
{$endif}

{@/// procedure rotate_bitmap_free(source:TBitmap; angle:extended);}
procedure rotate_bitmap_free(source:TBitmap; angle:extended);
var
  tempimage: TBitmap;
  w,h,i,j: integer;
  xx,xy,yx,yy: extended;
  sx, sy, dx, dy: integer;
{$ifndef clx}
  s_wnd, h_wnd: THandle;
{$endif}
begin
  xx:=+cos_d(angle);  xy:=+sin_d(angle);
  yx:=-sin_d(angle);  yy:=+cos_d(angle);
  tempimage:=NIL;
  try
    tempimage:=TBitmap.Create;
    tempimage.assign(source);
    h:=source.height-1;
    w:=source.width-1;
    dx:=(w+1) div 2;
    dy:=(h+1) div 2;
{$ifndef clx}
    s_wnd:=source.canvas.handle;
    h_wnd:=tempimage.canvas.handle;
{$endif}
    for i:=0 to w do
      for j:=0 to h do begin
        sx:=put_in_range(round(xx*(i-dx)+xy*(j-dy))+dx,0,w);
        sy:=put_in_range(round(yx*(i-dx)+yy*(j-dy))+dy,0,h);
{$ifdef fpc}
        source.canvas.Pixels[i, j] := tempimage.canvas.Pixels[sx, sy];
{$else}
{$ifdef clx}
        source.canvas.copyrect(rect(i,j,i+1,j+1),tempimage.canvas,rect(sx,sy,sx+1,sy+1));
{$else}
        setpixel(s_wnd,i,j,getpixel(h_wnd,sx,sy));
        { Much faster than using canvas.pixels[] }
{$endif}
{$endif}
        end;
  finally
    tempimage.free;
    end;
  end;
{@\\\0000001101}

{$ifdef ver80}
const
{$else}
var
{$endif}
  ApolloDate : TDateTime = 0;
const
  ApolloLongitude = -(23+25/60);

type
  {@/// TMoonSizeInfo = record}
  TMoonSizeInfo = record
    max_x, max_y: integer;
    offset_x, offset_y: integer;
    radius: integer;
    end;
  {@\\\0000000501}

{@/// Resource names and sizes}
const
{$ifdef clx}
  ResString:array[TMoonSize] of string=('QMOON_LARGE'#0,
                                        'QMOON_SMALL'#0,
                                        'QMOON_TINY'#0);
  ResStringBW:array[TMoonSize] of string=('QMOON_BW_LARGE'#0,
                                          'QMOON_BW_SMALL'#0,
                                          'QMOON_BW_TINY'#0);
  ResStringColor:array[TMoonSize] of string=('QMOON_COLOR_LARGE'#0,
                                             'QMOON_COLOR_SMALL'#0,
                                             'QMOON_COLOR_TINY'#0);
{$else}
  ResString:array[TMoonSize] of string=('MOON_LARGE'#0,
                                        'MOON_SMALL'#0,
                                        'MOON_TINY'#0);
  ResStringBW:array[TMoonSize] of string=('MOON_BW_LARGE'#0,
                                          'MOON_BW_SMALL'#0,
                                          'MOON_BW_TINY'#0);
  ResStringColor:array[TMoonSize] of string=('MOON_COLOR_LARGE'#0,
                                             'MOON_COLOR_SMALL'#0,
                                             'MOON_COLOR_TINY'#0);
{$endif}
  size_moon:array[TMoonSize] of TMoonSizeInfo =
    ((max_x: 64; max_y: 64; offset_x: 31; offset_y: 28; radius: 28 ),
     (max_x: 32; max_y: 32; offset_x: 15; offset_y: 14; radius: 14 ),
     (max_x: 16; max_y: 16; offset_x:  7; offset_y:  7; radius:  7 ));
{@\\\0000001701}

{@/// class TMoon(TGraphicControl)}
{@/// constructor TMoon.Create(AOwner: TComponent);}
constructor TMoon.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLocation:=TLocation.create;
  Flocation.OnChange:=LocationChange;
  FBMP := TBitmap.Create;
  ficon:=TIcon.Create;
  FBMP.Transparent:=true;
  SetDate(now);
  FDateChanged:=false;
  FApollo:=true;
  Color:=clBlack;
  Transparent:=false;
  SetSize(ms64);
  end;
{@\\\0000000403}
{@/// destructor TMoon.Destroy;}
destructor TMoon.Destroy;
begin
  FBMP.free;
  ficon.free;
  inherited destroy;
  end;
{@\\\}
{@/// procedure TMoon.Paint;}
procedure TMoon.Paint;
begin
  if not transparent then begin
    canvas.brush.color:=self.color;
    canvas.fillrect(rect(0,0,width,height));
    end;
  canvas.Draw(0,0,FBMP);
  end;
{@\\\0000000701}
{@/// procedure TMoon.Loaded;}
procedure TMoon.Loaded;
begin
  inherited Loaded;
  SetBitmap;
  end;
{@\\\}

{@/// procedure TMoon.SetBitmap;}
procedure TMoon.SetBitmap;
{@/// procedure color_bitmap(var bmp:TBitmap; Color:TColor);}
procedure color_bitmap(var bmp:TBitmap; Color:TColor);
{ cmSrcPaint doesn't work with CLX of D6, that's why it's more complicated}
var
  tempbmp,h: TBitmap;
  dest: TRect;
begin
  tempbmp:=NIL;
  try
    tempbmp:=TBitmap.Create;
    tempbmp.monochrome:=false;
    tempbmp.width:=bmp.width;
    tempbmp.height:=bmp.height;
    tempbmp.canvas.brush.color:=color;
    dest:=Rect(0,0,bmp.width,bmp.height);
    tempbmp.canvas.FillRect(dest);
    bmp.canvas.copymode:=cmDStInvert;
    bmp.canvas.copyrect(dest,bmp.canvas,dest);
    tempbmp.canvas.copymode:=cmSrcAnd;
    tempbmp.canvas.copyrect(dest,bmp.Canvas,dest);
    h:=tempbmp;
    tempbmp:=bmp;
    bmp:=h;
  finally
    tempbmp.free;
    end;
  end;
{@\\\0000000105}
var
  h: string;
  tempbmp: TBitmap;
  dest: TRect;
  transcolor: TColor;
  current_angle: integer;
begin
  tempbmp:=NIL;
  try
    tempbmp:=TBitmap.Create;
    case FStyle of
      msClassic:    h:=ResString[FMoonSize];
      msColor:      h:=ResStringColor[FMoonSize];
      msMonochrome: h:=ResStringBW[FMoonSize];
      end;
{$ifdef clx}
    tempbmp.LoadFromResourceName(hInstance, h);
    { ARGH! Why not working by using FBMP.Width }
    FBMP.LoadFromResourceName(hInstance, ResStringColor[FMoonSize]);
{$else}
    tempbmp.Handle := LoadBitmap(hInstance, @h[1]);
    FBMP.Width:=tempbmp.Width;
    FBMP.Height:=tempbmp.Height;
{$endif}
    if FStyle=msMonochrome then
      color_bitmap(tempbmp,FMoonColor);
    if ColorToRGB(FMoonColor)<>transcolor_1 then
      transcolor:=transcolor_1
    else
      transcolor:=transcolor_2;
    FBMP.Canvas.Brush.Color:=transcolor;
{$ifndef clx}
    FBMP.TransparentColor:=transcolor;
{$else}
    FBMP.TransparentMode:=tmAuto;  { tmFixed doesn't work with D6 CLX}
    if transcolor=transcolor_1 then
      FBMP.TransparentColor:=transcolor_2
    else
      FBMP.TransparentColor:=transcolor_1;
{$endif}
    dest:=Rect(0,0,Fbmp.width,Fbmp.height);
    FBMP.Canvas.FillRect(dest);
    tempbmp.transparent:=true;
    tempbmp.transparentmode:=tmAuto;
    FBMP.Canvas.Draw(0,0,tempbmp);
    draw_moon(FBMP.canvas,FMoonSize);

    case FRotate of
      rot_location:
        current_angle:=round(MoonBrightLimbPositionAngleZenith(fdate,
          location.latitude,location.longitude));
      rot_angle: current_angle:=fangle;
      rot_none:  current_angle:=0;
      rot_90:    current_angle:=90;
      rot_180:   current_angle:=180;
      rot_270:   current_angle:=270;
      else       current_angle:=0;
      end;
    rotate_bitmap_free(FBMP,current_angle);
    Draw_Apollo(FBMP.canvas,current_angle,FMoonSize);
{$ifdef clx}
    FBMP.TransparentColor:=transcolor;
{$endif}
    invalidate;
  finally
    tempbmp.free;
    end;
  end;
{@\\\0000003407}
{@/// procedure TMoon.SetSize(Value:TMoonSize);}
procedure TMoon.SetSize(Value:TMoonSize);
begin
  if (FMoonSize<>value) or (width<>size_moon[FMoonSize].max_x) then begin
    FMoonSize:=value;
    {$ifdef delphi_ge_4}
    constraints.maxheight:=size_moon[FMoonSize].max_y;
    constraints.minheight:=size_moon[FMoonSize].max_y;
    height:=size_moon[FMoonSize].max_y;
    constraints.maxwidth:=size_moon[FMoonSize].max_x;
    constraints.minwidth:=size_moon[FMoonSize].max_x;
    { at least D4 and D6 CLX need this - setting constraints does not update width/height}
    { $ifdef clx}
    height:=size_moon[FMoonSize].max_y;
    width:=size_moon[FMoonSize].max_x;
    { $endif}
    {$else}
    FMaxHeight:=size_moon[FMoonSize].max_x;
    FMaxWidth:=size_moon[FMoonSize].max_y;
    Self.Height := FMaxHeight;
    Self.Width := FMaxWidth;
    {$endif}
    setbitmap;
    end;
  end;
{@\\\0000000601}
{@/// procedure TMoon.Draw_Moon(canvas:TCanvas; size:TMoonSize);}
procedure TMoon.Draw_Moon(canvas:TCanvas; size:TMoonSize);
var
  y,radius2: integer;
  xm,scale: extended;
  xmax,xmin:integer;
  offset_x,offset_y,radius: integer;
begin

{ FLimbAngle = 0   -> Full Moon
   FLimbAngle = 90  -> First Quarter
   FLimbAngle = 180 -> New Moon
   FLimbAngle = 270 -> LasT Quarter}

  offset_x:=size_moon[Size].offset_x;
  offset_y:=size_moon[Size].offset_y;
  radius:=size_moon[Size].radius;
  canvas.brush.color:=clBlack;
  canvas.pen.color:=clBlack;
  radius2:=radius*radius;
  scale:=cos_d(FLimbAngle);
  for y:=0 to radius do begin
    xm:=sqrt(radius2-y*y);
    xmax:=round(xm);
    xmin:=round(xm*scale);
    if xmax>xmin then begin
      if FLimbAngle<180 then begin
        xmax:=offset_x-xmax-1;
        xmin:=offset_x-xmin;
        end
      else begin
        xmax:=offset_x+xmax+1;
        xmin:=offset_x+xmin;
        end;
      canvas.moveto(xmin,y+offset_y);
      canvas.lineto(xmax,y+offset_y);
      canvas.moveto(xmin,-y+offset_y);
      canvas.lineto(xmax,-y+offset_y);
      end;
    end;
  end;
{@\\\0000001201}
{@/// procedure TMoon.Draw_Apollo(canvas:TCanvas; angle:integer; size:TMoonSize);}
procedure TMoon.Draw_Apollo(canvas:TCanvas; angle:integer; size:TMoonSize);
var
  apollo_x, apollo_y: extended;
  x,y: integer;
begin
  if fApollo and (ApolloDate<fdate) and
    ((FLimbAngle<=90-ApolloLongitude) or
     (FLimbAngle>=270-ApolloLongitude)) then begin
    apollo_x:=-size_moon[Size].radius*sin_d(ApolloLongitude)+size_moon[Size].offset_x-size_moon[Size].max_x div 2;
    apollo_y:=size_moon[Size].offset_y-size_moon[Size].max_y div 2;
    x:=round( apollo_x*cos_d(angle)-apollo_y*sin_d(angle)+size_moon[Size].max_x div 2);
    y:=round( apollo_x*sin_d(angle)+apollo_y*cos_d(angle)+size_moon[Size].max_y div 2);
{$ifdef clx}
    canvas.pen.color:=clRed;
    canvas.DrawPoint(x,y);
{$else}
    canvas.pixels[x,y]:=clRed;
{$endif}
    end;
  end;
{@\\\003C000B3B000B5600095600097100090F}
{$ifdef clx}
{@/// function TMoon.GetIcon:TIcon;}
function TMoon.GetIcon:TIcon;
begin
  FIcon.Assign(FBMP);  { !!!}
  result:=FIcon;
  end;
{@\\\0000000401}
{$else}
{@/// function TMoon.GetIcon:TIcon;}
function TMoon.GetIcon:TIcon;
var
  IconSizeX : integer;
  IconSizeY : integer;
  AndMask : TBitmap;
  XOrMask : TBitmap;
{$ifdef delphi_1}
  BitmapX,BitmapA: wintypes.TBitmap;
  AndData, XOrData: pointer;
  AndLen, XorLen: integer;
{$else}
  IconInfo : TIconInfo;
{$endif}
  Size: TMoonSize;
  FBMP: TBitmap;
  tempcolor: TColor;
  current_angle: integer;
begin
  AndMask:=NIL;
  XOrMask:=NIL;
  FBMP:=NIL;
  try
    {Get the icon size}
    IconSizeX := GetSystemMetrics(SM_CXICON);
    IconSizeY := GetSystemMetrics(SM_CYICON);

    Size:=ms32;
    if false then
    else if (IconSizeX=16) and (IconSizeY=16) then
      Size:=ms16
    else if (IconSizeX=32) and (IconSizeY=32) then
      Size:=ms32
    else if (IconSizeX=64) and (IconSizeY=64) then
      size:=ms64
    else
      { ???};

    {Create the "And" mask}
    AndMask := TBitmap.Create;
    AndMask.Monochrome := true;
    AndMask.Width := size_moon[Size].max_x;
    AndMask.Height := size_moon[Size].max_y;

    FBMP:=TBitmap.Create;
    FBMP.Handle := LoadBitmap(hInstance, @ResStringBW[Size][1]);
    AndMask.canvas.Draw(0,0,FBMP);

    {Create the "XOr" mask}
    XOrMask := TBitmap.Create;
    XOrMask.Width := size_moon[Size].max_x;
    XOrMask.Height := size_moon[Size].max_y;

    {Draw on the "XOr" mask}
    case FStyle of
      msClassic:    FBMP.Handle := LoadBitmap(hInstance, @ResString[Size][1]);
      msColor:      FBMP.Handle := LoadBitmap(hInstance, @ResStringColor[Size][1]);
      msMonochrome: FBMP.Handle := LoadBitmap(hInstance, @ResStringBW[Size][1]);
      end;
    XOrMask.canvas.Draw(0,0,FBMP);

    if FStyle=msMonochrome then begin
      tempcolor:=clFuchsia;
      if ColorToRGB(FMoonColor)=clFuchsia then
        tempcolor:=clLime;
      XOrMask.Canvas.Brush.color:=tempcolor;
      XOrMask.Canvas.FloodFill(0,0,clWhite,fsSurface);
      XOrMask.Canvas.Brush.color:=FMoonColor;
      XOrMask.Canvas.FloodFill(size_moon[Size].offset_x,size_moon[Size].offset_y,clBlack,fsSurface);
      XOrMask.Canvas.Brush.color:=clBlack;
      XOrMask.Canvas.FloodFill(0,0,tempcolor,fsSurface);
      end;

    draw_moon(XOrMask.Canvas,Size);

    case FRotate of
      rot_location:
        current_angle:=round(MoonBrightLimbPositionAngleZenith(fdate,
          location.latitude,location.longitude));
      rot_angle: current_angle:=fangle;
      rot_none:  current_angle:=0;
      rot_90:    current_angle:=90;
      rot_180:   current_angle:=180;
      rot_270:   current_angle:=270;
      else       current_angle:=0;
      end;
    rotate_bitmap_free(XOrMask,current_angle);
    rotate_bitmap_free(AndMask,current_angle);
    Draw_Apollo(XOrMask.canvas,current_angle,Size);

    {@/// Create a icon}
    {$ifdef delphi_1}
    AndData:=NIL;
    XorData:=NIL;
    try
      GetObject(AndMask.handle, SizeOf(BitmapA), @BitmapA);
      AndLen := BitmapA.bmWidthBytes * BitmapA.bmHeight * BitmapA.bmPlanes;
      AndData := MemAlloc(AndLen);
      GetBitmapBits(AndMask.handle, AndLen, AndData);
      GetObject(XOrMask.handle, SizeOf(BitmapX), @BitmapX);
      XorLen := BitmapX.bmWidthBytes * BitmapX.bmHeight * BitmapX.bmPlanes;
      XorData := MemAlloc(XorLen);
      GetBitmapBits(XorMask.handle, XorLen, XorData);

      FIcon.Handle := CreateIcon(hinstance,IconSizeX,IconSizeY,
        BitmapX.bmPlanes,BitmapX.bmBitsPixel, AndData, XOrData);
    finally
      if AndData<>NIL then  FreeMem(AndData, AndLen);
      if XorData<>NIL then  FreeMem(XorData, XorLen);
      end;
    {$else}
    IconInfo.fIcon := true;
    IconInfo.xHotspot := 0;
    IconInfo.yHotspot := 0;
    IconInfo.hbmMask := AndMask.Handle;
    IconInfo.hbmColor := XOrMask.Handle;
    FIcon.Handle := CreateIconIndirect({$ifdef fpc}@{$endif}IconInfo);
    {$endif}
    {@\\\0000001B01}

    result := FIcon;
  finally
    AndMask.Free;
    XOrMask.Free;
    FBMP.Free;
    end;
  end;
{@\\\0000005401}
{$endif}

{@/// procedure TMoon.SetDate(Value: TDateTime);}
procedure TMoon.SetDate(Value: TDateTime);
begin
  FDate:=Value;
  FLimbAngle:=put_in_360(moon_phase_angle(Value));
  setbitmap;
  FDateChanged:=true;
  end;
{@\\\0000000501}
{@/// procedure TMoon.SetRotate(value:TRotate);}
procedure TMoon.SetRotate(value:TRotate);
begin
  if frotate<>value then begin
    frotate:=value;
    setbitmap;
    end;
  end;
{@\\\0000000501}
{@/// procedure TMoon.SetStyle(value:TMoonStyle);}
procedure TMoon.SetStyle(value:TMoonStyle);
begin
  if fstyle<>value then begin
    fstyle:=value;
    setbitmap;
    end;
  end;
{@\\\0000000201}
{@/// procedure TMoon.SetIconSize(Value:TMoonSize);}
procedure TMoon.SetIconSize(Value:TMoonSize);
begin
  if FMoonIconSize<>value then begin
    FMoonIconSize:=value;
    GetIcon;
    end;
  end;
{@\\\0000000401}
{@/// procedure TMoon.SetTransparent(value: boolean);}
procedure TMoon.SetTransparent(value: boolean);
begin
  if FTransparent<>value then begin
    FTransparent:=value;
    self.invalidate;
    end;
  end;
{@\\\0000000301}
{@/// procedure TMoon.SetColor(value: TColor);}
procedure TMoon.SetColor(value: TColor);
begin
  if Color<>value then begin
    inherited Color:=value;
    if not transparent then
      invalidate;
    end;
  end;
{@\\\000000030B}
{@/// procedure TMoon.SetApollo(value: boolean);}
procedure TMoon.SetApollo(value: boolean);
begin
  if fapollo<>value then begin
    fapollo:=value;
    setbitmap;
    end;
  end;
{@\\\0000000505}
{@/// procedure TMoon.SetMoonColor(value: TColor);}
procedure TMoon.SetMoonColor(value: TColor);
begin
  if FMoonColor<>value then begin
    FMoonColor:=value;
    if MoonStyle=msMonochrome then
      setbitmap;
    end;
  end;
{@\\\0000000601}
{@/// procedure TMoon.SetRotAngle(value: integer);}
procedure TMoon.SetRotAngle(value: integer);
begin
  if fangle<>value then begin
    fangle:=value;
{    case value of
      0: frotate:=rot_none;
      90: frotate:=rot_90;
      180: frotate:=rot_180;
      270: frotate:=rot_270;
      else frotate:=rot_angle;
      end;   }
    setbitmap;
    end;
  end;
{@\\\0000000C01}
{@/// procedure TMoon.LocationChange(sender: TObject);}
procedure TMoon.LocationChange(sender: TObject);
begin
  setbitmap;
  end;
{@\\\}
{@/// procedure TMoon.SetLocation(value: TLocation);}
procedure TMoon.SetLocation(value: TLocation);
begin
  Location.assign(value);
  end;
{@\\\000000031A}


{$ifdef delphi_lt_4}
{@/// procedure TMoon.WMSize(var Message: TWMSize);}
procedure TMoon.WMSize(var Message: TWMSize);
begin
  inherited;
  if (csDesigning in ComponentState) then begin
    Width := FMaxWidth;
    Height := FMaxHeight;
    end;
  end;
{@\\\}
{$endif}
{@\\\0000000901}
{@/// class TLocation(TPersistent)}
{@/// procedure TLocation.Assign(Source: Tpersistent);}
procedure TLocation.Assign(Source: Tpersistent);
begin
  if (source is TLocation) then begin
    FLatitude:=TLocation(source).Latitude;
    FLongitude:=TLocation(source).Longitude;
    FName:=TLocation(source).Name;
    FHeight:=TLocation(source).Height;
    changed;
    EXIT;
    end;
  inherited Assign(source);
  end;
{@\\\0000000801}
{@/// procedure TLocation.SetLatitude(value:extended);}
procedure TLocation.SetLatitude(value:extended);
begin
  FLatitude:=value;
  changed;
  end;
{@\\\0000000201}
{@/// procedure TLocation.SetLongitude(value:extended);}
procedure TLocation.SetLongitude(value:extended);
begin
  FLongitude:=value;
  changed;
  end;
{@\\\}
{@/// procedure TLocation.changed;}
procedure TLocation.changed;
begin
  if assigned(OnChange) then OnChange(self);
  end;
{@\\\}
{@\\\}
{@\\\0002001116001116}
{@/// initialization}
{$ifdef ver80}
begin
{$else}
initialization
{$endif}
  ApolloDate:=EncodeDate(1969,7,20)+EncodeTime(20,17,43,0);
{@\\\}
{$ifdef delphi_ge_2} {$warnings off} {$endif}
end.
{@\\\0001000011}
