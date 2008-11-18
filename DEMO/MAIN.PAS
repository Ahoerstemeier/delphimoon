unit main;
(*@/// interface *)
interface

(*@/// uses *)
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, moon, Menus;
(*@\\\*)
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
(*@\\\0000000501*)
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

(*@/// procedure TForm1.FormCreate(Sender: TObject); *)
procedure TMainForm.FormCreate(Sender: TObject);
begin
  first_now:=now;
  Timer.OnTimer(NIL);
  end;
(*@\\\*)

(*@/// procedure TForm1.Timer1Timer(Sender: TObject); *)
procedure TMainForm.TimerTimer(Sender: TObject);
var
  jetzt: TDateTime;
  temp: TDateTime;
  dist,age: extended;
  s:string;
  h,m,sec,ms: word;
  tz_info: TTimeZoneInformation;
begin
  GetTimeZoneInformation(tz_info);
  if mnu_fast.checked then begin
    jetzt:=(now-first_now)*3600+now;
    val_local.caption:='';
    end
  else begin
    jetzt:=now;
    val_local.caption:=date2string(jetzt);
    end;

  jetzt:=jetzt+tz_info.bias/(60*24);
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
(*@\\\0002000C20000C20*)
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

(*@\\\003C001501001601001001001001001101*)
end.
(*@\\\0001000011000301*)
