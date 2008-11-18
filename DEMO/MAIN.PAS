unit main;
(*@/// interface *)
interface

(*@/// uses *)
uses
(*$ifdef ver80 *)
  winprocs,
  wintypes,
(*$else *)
  Windows,
(*$endif *)
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  ExtCtrls,
  StdCtrls,
  moon,
  Menus;
(*@\\\0000000801*)
type
(*@///   TForm1 = class(TForm) *)
TMainForm = class(TForm)
  Moon: TMoon;
  lbl_age: TLabel;
  lbl_firstquart: TLabel;
  lbl_full: TLabel;
  lbl_julian: TLabel;
  lbl_lastlunation: TLabel;
  lbl_lastnew: TLabel;
  lbl_lastquart: TLabel;
  lbl_local: TLabel;
  lbl_moon_distance: TLabel;
  lbl_moon_subtend: TLabel;
  lbl_nextlunation: TLabel;
  lbl_nextnew: TLabel;
  lbl_phase: TLabel;
  lbl_sun_distance: TLabel;
  lbl_sun_subtend: TLabel;
  lbl_utc: TLabel;
  val_age: TLabel;
  val_firstquart: TLabel;
  val_full: TLabel;
  val_julian: TLabel;
  val_lastlunation: TLabel;
  val_lastquart: TLabel;
  val_local: TLabel;
  val_moon_distance: TLabel;
  val_moon_subtend: TLabel;
  val_newmoon: TLabel;
  val_nextlunation: TLabel;
  val_nextnew: TLabel;
  val_phase: TLabel;
    val_sun_subtend: TLabel;
  val_sun_distance: TLabel;
  val_utc: TLabel;
    Timer: TTimer;
    MainMenu: TMainMenu;
    mnu_file: TMenuItem;
    mnu_edit: TMenuItem;
    mnu_options: TMenuItem;
    mnu_help: TMenuItem;
    mnu_exit: TMenuItem;
    mnu_copy: TMenuItem;
    mnu_fast: TMenuItem;
    mnu_stop: TMenuItem;
    mnu_line1: TMenuItem;
    mnu_julian: TMenuItem;
    mnu_utc: TMenuItem;
    mnu_about: TMenuItem;
    mnu_line2: TMenuItem;
    mnu_timezone: TMenuItem;
  procedure TimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mnu_stopClick(Sender: TObject);
    procedure mnu_exitClick(Sender: TObject);
    procedure mnu_fastClick(Sender: TObject);
    procedure mnu_aboutClick(Sender: TObject);
private
  { Private-Deklarationen }
public
  { Public-Deklarationen }
end;
(*@\\\0000001301*)

var
  MainForm: TMainForm;
(*@\\\0000000301*)
(*@/// implementation *)
implementation

uses about;

{$R *.DFM}

const
  AU=149597869;             (* astronomical unit in km *)
var
  first_now: TDateTime;

(*@/// function datestring(x:TDateTime):string; *)
function datestring(x:TDateTime):string;
begin
  result:=formatdatetime('hh:nn',x)+' UTC '+formatdatetime('d mmmm yyyy',x);
  end;
(*@\\\*)
(*@/// function date2string(x:TDateTime):string; *)
function date2string(x:TDateTime):string;
begin
  result:=formatdatetime('hh:nn:ss d mmmm yyyy',x);
  end;
(*@\\\0000000301*)

(*@/// function TimeZoneBias:longint;          // in minutes ! *)
function TimeZoneBias:longint;
(*@/// 16 bit way: try a 32bit API call via thunking layer, if that fails try the TZ *)
(*$ifdef ver80 *)
(*@/// function GetEnvVar(const s:string):string; *)
function GetEnvVar(const s:string):string;
var
  L: Word;
  P: PChar;
begin
  L := length(s);
  P := GetDosEnvironment;
  while P^ <> #0 do begin
    if (StrLIComp(P, @s[1], L) = 0) and (P[L] = '=') then begin
      GetEnvVar := StrPas(P + L + 1);
      EXIT;
      end;
    Inc(P, StrLen(P) + 1);
    end;
  GetEnvVar := '';
  end;
(*@\\\*)

(*@/// function day_in_month(month,year,weekday: word; count: integer):TDateTime; *)
function day_in_month(month,year,weekday: word; count: integer):TDateTime;
var
  h: integer;
begin
  if count>0 then begin
    h:=dayofweek(encodedate(year,month,1));
    h:=((weekday-h+7) mod 7) +1 + (count-1)*7;
    result:=encodedate(year,month,h);
    end
  else begin
    h:=dayofweek(encodedate(year,month,1));
    h:=((weekday-h+7) mod 7) +1 + 6*7;
    while count<0 do begin
      h:=h-7;
      try
        result:=encodedate(year,month,h);
        inc(count);
        if count=0 then EXIT;
      except
        end;
      end;
    end;
  end;
(*@\\\*)
(*@/// function DayLight_Start:TDateTime;     // american way ! *)
function DayLight_Start:TDateTime;
var
  y,m,d: word;
begin
  DecodeDate(now,y,m,d);
  result:=day_in_month(4,y,1,1);
  (* for european one: day_in_month(3,y,1,-1) *)
  end;
(*@\\\*)
(*@/// function DayLight_End:TDateTime;       // american way ! *)
function DayLight_End:TDateTime;
var
  y,m,d: word;
begin
  DecodeDate(now,y,m,d);
  result:=day_in_month(10,y,1,-1);
  end;
(*@\\\*)
type    (* stolen from windows.pas *)
(*@///   TSystemTime = record ... end; *)
PSystemTime = ^TSystemTime;
TSystemTime = record
  wYear: Word;
  wMonth: Word;
  wDayOfWeek: Word;
  wDay: Word;
  wHour: Word;
  wMinute: Word;
  wSecond: Word;
  wMilliseconds: Word;
end;
(*@\\\*)
(*@///   TTimeZoneInformation = record ... end; *)
TTimeZoneInformation = record
  Bias: Longint;
  StandardName: array[0..31] of word;  (* wchar *)
  StandardDate: TSystemTime;
  StandardBias: Longint;
  DaylightName: array[0..31] of word;  (* wchar *)
  DaylightDate: TSystemTime;
  DaylightBias: Longint;
  end;
(*@\\\*)
var
  tz_info: TTimeZoneInformation;
  LL32:function (LibFileName: PChar; handle: longint; special: longint):Longint;
  FL32:function (hDll: Longint):boolean;
  GA32:function (hDll: Longint; functionname: PChar):longint;
  CP32:function (buffer:TTimeZoneInformation; prochandle,adressconvert,dwParams:Longint):longint;
  hdll32,dummy,farproc: longint;
  hdll:THandle;
  sign: integer;
  s: string;
begin
  hDll:=GetModuleHandle('kernel');                  { get the 16bit handle of kernel }
  @LL32:=GetProcAddress(hdll,'LoadLibraryEx32W');   { get the thunking layer functions }
  @FL32:=GetProcAddress(hdll,'FreeLibrary32W');
  @GA32:=GetProcAddress(hdll,'GetProcAddress32W');
  @CP32:=GetProcAddress(hdll,'CallProc32W');
(*@///   if possible then   call GetTimeZoneInformation via Thunking *)
if (@LL32<>NIL) and
   (@FL32<>NIL) and
   (@GA32<>NIL) and
   (@CP32<>NIL) then begin
  hDll32:=LL32('kernel32.dll',dummy,1);            { get the 32bit handle of kernel32 }
  farproc:=GA32(hDll32,'GetTimeZoneInformation');  { get the 32bit adress of the function }
  case CP32(tz_info,farproc,1,1) of                { and call it }
    1: result:=tz_info.StandardBias+tz_info.Bias;
    2: result:=tz_info.DaylightBias+tz_info.Bias;
    else result:=0;
    end;
  FL32(hDll32);                                    { and free the 32bit dll }
  end
(*@\\\*)
(*@///   else  calculate the bias out of the TZ environment variable *)
else begin
  s:=GetEnvVar('TZ');
  while (length(s)>0) and (not(s[1] in ['+','-','0'..'9'])) do
    s:=copy(s,2,length(s));
  case s[1] of
(*@///     '+': *)
'+': begin
  sign:=1;
  s:=copy(s,2,length(s));
  end;
(*@\\\*)
(*@///     '-': *)
'-': begin
  sign:=-1;
  s:=copy(s,2,length(s));
  end;
(*@\\\*)
    else sign:=1;
    end;
  try
    result:=strtoint(copy(s,1,2))*60;
    s:=copy(s,3,length(s));
  except
    try
      result:=strtoint(s[1])*60;
      s:=copy(s,2,length(s));
    except
      result:=0;
      end;
    end;
(*@///   if s[1]=':' then    minutes offset *)
if s[1]=':' then begin
  try
    result:=result+strtoint(copy(s,2,2));
    s:=copy(s,4,length(s));
  except
    try
      result:=result+strtoint(s[2]);
      s:=copy(s,3,length(s));
    except
      end;
    end;
  end;
(*@\\\*)
(*@///   if s[1]=':' then    seconds offset - ignored *)
if s[1]=':' then begin
  try
    strtoint(copy(s,2,2));
    s:=copy(s,4,length(s));
  except
    try
      strtoint(s[2]);
      s:=copy(s,3,length(s));
    except
      end;
    end;
  end;
(*@\\\*)
  result:=result*sign;
(*@///   if length(s)>0 then daylight saving activated, calculate it *)
if length(s)>0 then begin
  (* forget about the few hours on the start/end day *)
  if (now>daylight_start) and (now<DayLight_End+1) then
    result:=result-60;
  end;
(*@\\\*)
  end;
(*@\\\*)
  end;
(*@\\\*)
(*@/// 32 bit way: API call GetTimeZoneInformation *)
(*$else *)
var
  tz_info: TTimeZoneInformation;
begin
  case GetTimeZoneInformation(tz_info) of
    1: result:=tz_info.StandardBias+tz_info.Bias;
    2: result:=tz_info.DaylightBias+tz_info.Bias;
    else result:=0;
    end;
  end;
(*$endif *)
(*@\\\*)
(*@\\\0000000301*)

(*@/// procedure TForm1.FormCreate(Sender: TObject); *)
procedure TMainForm.FormCreate(Sender: TObject);
begin
  first_now:=now;
  Timer.OnTimer(NIL);
{   Application.Icon:=Moon.Icon; }
  end;
(*@\\\0000000601*)

(*@/// procedure TForm1.Timer1Timer(Sender: TObject); *)
procedure TMainForm.TimerTimer(Sender: TObject);
var
  jetzt: TDateTime;
  temp: TDateTime;
  dist,age: extended;
  s:string;
  h,m,sec,ms: word;
  bias: integer;
begin
  bias:=TimeZoneBias;
  if mnu_fast.checked then begin
    jetzt:=(now-first_now)*3600+now;
    val_local.caption:='';
    end
  else begin
    jetzt:=now;
    val_local.caption:=date2string(jetzt);
    end;

  jetzt:=jetzt+bias/(60*24);
  val_utc.caption:=date2string(jetzt);
  str(julian_date(jetzt):12:5,s);
  val_julian.caption:=s;

  moon.date:=jetzt;

  temp:=last_phase(jetzt,Newmoon);
  val_newmoon.caption:=datestring(temp);
  val_firstquart.caption:=datestring(next_phase(temp,FirstQuarter));
  val_full.caption:=datestring(next_phase(temp,FullMoon));
  val_lastquart.caption:=datestring(next_phase(temp,LastQuarter));
  val_nextnew.caption:=datestring(next_phase(jetzt,NewMoon));
  val_lastlunation.caption:=inttostr(lunation(temp+1));
  val_nextlunation.caption:=inttostr(lunation(temp+1)+1);

  dist:=moon_distance(jetzt);
  str(dist/6378.15:4:1,s);
  val_moon_distance.caption:=inttostr(round(dist))+' kilometres, '+s+' earth radii.';
  dist:=sun_distance(jetzt);
  str(dist:6:3,s);
  val_sun_distance.caption:=inttostr(round(dist*AU))+' kilometres, '+s+' astronomical units.';

  age:=age_of_moon(jetzt);
  decodetime(age,h,m,sec,ms);
  s:=inttostr(trunc(age))+' days, '+inttostr(h)+' hours, '+inttostr(m)+' minutes.';
  val_age.caption:=s;
  val_phase.caption:=inttostr(round(current_phase(jetzt)*100))+'% (0% = New, 100% = Full)';

  str(moon_diameter(jetzt)/3600:6:4,s);
  val_moon_subtend.caption:=s;
  str(sun_diameter(jetzt)/3600:6:4,s);
  val_sun_subtend.caption:=s;

  end;
(*@\\\000E000A09000A15000A15000A15*)
(*@/// procedure TMainForm.mnu_stopClick(Sender: TObject); *)
procedure TMainForm.mnu_stopClick(Sender: TObject);
begin
  timer.enabled:=not timer.enabled;
  if timer.enabled then
     mnu_stop.caption:='&Stop'
  else
    mnu_stop.caption:='&Run';
  end;
(*@\\\*)
(*@/// procedure TMainForm.mnu_fastClick(Sender: TObject); *)
procedure TMainForm.mnu_fastClick(Sender: TObject);
begin
  mnu_fast.checked:=not mnu_fast.checked;
  first_now:=now;
  end;
(*@\\\*)
(*@/// procedure TMainForm.mnu_exitClick(Sender: TObject); *)
procedure TMainForm.mnu_exitClick(Sender: TObject);
begin
  self.close;
  end;
(*@\\\*)
(*@/// procedure TMainForm.mnu_aboutClick(Sender: TObject); *)
procedure TMainForm.mnu_aboutClick(Sender: TObject);
begin
  aboutform.showmodal;
  end;
(*@\\\*)
(*@\\\0030000F0A000F16000F0A*)
end.
(*@\\\0001000011000301*)
