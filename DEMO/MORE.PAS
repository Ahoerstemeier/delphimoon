unit More;
(*@/// interface *)
interface

(*@/// uses *)
uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, StdCtrls, Spin,
  moon, main, inifiles;
(*@\\\0000000417*)

type
(*@///   Tfrm_more = class(TForm) *)
Tfrm_more = class(TForm)
  edt_latitude: TSpinEdit;
  edt_longitude: TSpinEdit;
  lbl_latitude: TLabel;
  lbl_longitude: TLabel;
  lbl_spring: TLabel;
  lbl_summer: TLabel;
  lbl_autumn: TLabel;
  lbl_winter: TLabel;
  val_spring: TLabel;
  val_summer: TLabel;
  val_autumn: TLabel;
  val_winter: TLabel;
  lbl_sunrise: TLabel;
  lbl_suntransit: TLabel;
  lbl_sunset: TLabel;
  val_sunrise: TLabel;
  val_suntransit: TLabel;
  val_sunset: TLabel;
  lbl_moonrise: TLabel;
  lbl_moontransit: TLabel;
  lbl_moonset: TLabel;
  val_moonrise: TLabel;
  val_moontransit: TLabel;
  val_moonset: TLabel;
  edt_location: TEdit;
  lbl_location: TLabel;
  lbl_perigee: TLabel;
  val_perigee: TLabel;
  lbl_apogee: TLabel;
  val_apogee: TLabel;
  lbl_mooneclipse: TLabel;
  lbl_suneclipse: TLabel;
  val_mooneclipse: TLabel;
  val_suneclipse: TLabel;
  typ_mooneclipse: TLabel;
  typ_suneclipse: TLabel;
  Timer: TTimer;
  procedure FormShow(Sender: TObject);
  procedure locationChange(Sender: TObject);
  procedure FormHide(Sender: TObject);
private
public
end;
(*@\\\0000002203*)

var
  frm_more: Tfrm_more;
(*@\\\0000000601*)
(*@/// implementation *)
implementation

{$R *.DFM}

(*@/// procedure Tfrm_more.FormShow(Sender: TObject); *)
procedure Tfrm_more.FormShow(Sender: TObject);
var
  IniFile : TIniFile;
begin
  try
    IniFile := TIniFile.Create('Moontool.ini');
    edt_location.text := IniFile.ReadString('Location','Name','');
    edt_longitude.value := IniFile.ReadInteger('Location','Longitude',0);
    edt_latitude.value := IniFile.ReadInteger('Location','Latitude',0);
  finally
    Inifile.Free;
    end;
  locationChange(NIL);
end;
(*@\\\0000000D01*)
(*@/// procedure Tfrm_more.FormHide(Sender: TObject); *)
procedure Tfrm_more.FormHide(Sender: TObject);
var
  IniFile : TIniFile;
begin
  IniFile:=NIL;
  try
    IniFile := TIniFile.Create('Moontool.ini');
    IniFile.WriteString('Location','Name',edt_location.text);
    IniFile.WriteInteger('Location','Longitude',edt_longitude.value);
    IniFile.WriteInteger('Location','Latitude',edt_latitude.value);
  finally
    Inifile.Free;
    end;
end;
(*@\\\0000000A01*)
(*@/// procedure Tfrm_more.locationChange(Sender: TObject); *)
procedure Tfrm_more.locationChange(Sender: TObject);
var
  y,m,d: word;
  jetzt,jetzt2: TDateTime;
  date: TDateTime;
  j: longint;
  eclipse_value: TEclipse;
begin
  jetzt:=now+TimeZoneBias/(60*24);

  DecodeDate(jetzt,y,m,d);
  { recalculate and show data }
  val_spring.caption:=datestring(StartSeason(y,spring));
  val_summer.caption:=datestring(StartSeason(y,summer));
  val_autumn.caption:=datestring(StartSeason(y,autumn));
  val_winter.caption:=datestring(StartSeason(y,winter));

  val_perigee.caption:=datestring(NextPeriGee(jetzt));
  val_apogee.caption:=datestring(NextApoGee(jetzt));

  j:=trunc(jetzt);
  try
(*@///     date:=Moon_Rise(j,edt_latitude.value,edt_longitude.value); *)
date:=Moon_Rise(j,edt_latitude.value,edt_longitude.value);
if trunc(date)<j then
  date:=Moon_Rise(j+1,edt_latitude.value,edt_longitude.value);
if trunc(date)>j then
  date:=Moon_Rise(j-1,edt_latitude.value,edt_longitude.value);
if trunc(date)<>j then
  val_moonrise.caption:='---'
else
  val_moonrise.caption:=datestring(date);
(*@\\\0000000701*)
(*@///     date:=Moon_Transit(j,edt_latitude.value,edt_longitude.value); *)
date:=Moon_Transit(j,edt_latitude.value,edt_longitude.value);
if trunc(date)<j then
  date:=Moon_Transit(j+1,edt_latitude.value,edt_longitude.value);
if trunc(date)>j then
  date:=Moon_Transit(j-1,edt_latitude.value,edt_longitude.value);
if trunc(date)<>j then
  val_moontransit.caption:='---'
else
  val_moontransit.caption:=datestring(date);
(*@\\\000000092D*)
(*@///     date:=Moon_Set(j,edt_latitude.value,edt_longitude.value); *)
date:=Moon_Set(j,edt_latitude.value,edt_longitude.value);
if trunc(date)<j then
  date:=Moon_Set(j+1,edt_latitude.value,edt_longitude.value);
if trunc(date)>j then
  date:=Moon_Set(j-1,edt_latitude.value,edt_longitude.value);
if trunc(date)<>j then
  val_moonset.caption:='---'
else
  val_moonset.caption:=datestring(date);
(*@\\\0000000929*)
  except
    val_moonrise.caption:='---';
    val_moontransit.caption:='---';
    val_moonset.caption:='---';
    end;
  try
(*@///     date:=Sun_Rise(j,edt_latitude.value,edt_longitude.value); *)
date:=Sun_Rise(j,edt_latitude.value,edt_longitude.value);
if trunc(date)<j then
  date:=Sun_Rise(j+1,edt_latitude.value,edt_longitude.value);
if trunc(date)>j then
  date:=Sun_Rise(j-1,edt_latitude.value,edt_longitude.value);
if trunc(date)<>j then
  val_sunrise.caption:='---'
else
  val_sunrise.caption:=datestring(date);
(*@\\\*)
(*@///     date:=Sun_Transit(j,edt_latitude.value,edt_longitude.value); *)
date:=Sun_Transit(j,edt_latitude.value,edt_longitude.value);
if trunc(date)<j then
  date:=Sun_Transit(j+1,edt_latitude.value,edt_longitude.value);
if trunc(date)>j then
  date:=Sun_Transit(j-1,edt_latitude.value,edt_longitude.value);
if trunc(date)<>j then
  val_suntransit.caption:='---'
else
  val_suntransit.caption:=datestring(date);
(*@\\\*)
(*@///     date:=Sun_Set(j,edt_latitude.value,edt_longitude.value); *)
date:=Sun_Set(j,edt_latitude.value,edt_longitude.value);
if trunc(date)<j then
  date:=Sun_Set(j+1,edt_latitude.value,edt_longitude.value);
if trunc(date)>j then
  date:=Sun_Set(j-1,edt_latitude.value,edt_longitude.value);
if trunc(date)<>j then
  val_sunset.caption:='---'
else
  val_sunset.caption:=datestring(date);
(*@\\\0000000917*)
  except
    val_sunrise.caption:='---';
    val_suntransit.caption:='---';
    val_sunset.caption:='---';
    end;
(*@///   Sun eclipse *)
jetzt2:=jetzt-28*2;
eclipse_value:=none;
while eclipse_value=none do begin
  jetzt2:=jetzt2+28;
  eclipse_value:=NextEclipse(jetzt2,true);
  end;
val_suneclipse.caption:=datestring(jetzt2);
case eclipse_value of
  none, halfshadow: typ_suneclipse.caption:='None';
  partial:          typ_suneclipse.caption:='Partial';
  total:            typ_suneclipse.caption:='Total';
  circular:         typ_suneclipse.caption:='Circular';
  circulartotal:    typ_suneclipse.caption:='Circular total';
  noncentral:       typ_suneclipse.caption:='Noncentral';
  end;
(*@\\\000C00051200051D00051D*)
(*@///   Moon eclipse *)
jetzt2:=jetzt-28*2;
eclipse_value:=none;
while eclipse_value=none do begin
  jetzt2:=jetzt2+28;
  eclipse_value:=NextEclipse(jetzt2,false);
  end;
val_mooneclipse.caption:=datestring(jetzt2);
case eclipse_value of
  none:          typ_mooneclipse.caption:='None';
  halfshadow:    typ_mooneclipse.caption:='Half shadow';
  partial:       typ_mooneclipse.caption:='Partial';
  total:         typ_mooneclipse.caption:='Total';
{   circular:      typ_mooneclipse.caption:='Circular'; }
{   circulartotal: typ_mooneclipse.caption:='Circular total'; }
{   noncentral:    typ_mooneclipse.caption:='Noncentral'; }
  end;
(*@\\\003000051200051D000512*)
end;
(*@\\\0002000101*)
(*@\\\0000000701*)
end.
(*@\\\0001000011000305*)
