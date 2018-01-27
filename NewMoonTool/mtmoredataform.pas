unit mtMoreDataForm;

interface

uses
  {$ifdef fpc}
  LCLIntf, LCLType,
  {$else}
  Windows, Messages,
  {$endif}
  SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, StdCtrls,
  moon, mtLocation, ComCtrls;

type

  { TfrmMoreData }

  TfrmMoreData = class(TForm)
    valMoonZodiac_name: TLabel;
    lblMoonZodiac: TLabel;
    valSunZodiacname: TLabel;
    lblSunZodiac: TLabel;
    valLatitude: TLabel;
    valLongitude: TLabel;
    lblLatitude: TLabel;
    lblLongitude: TLabel;
    cbxLocation: TCombobox;
    lblLocation: TLabel;
    Timer: TTimer;
    PageControl: TPageControl;
    pgSun: TTabSheet;
    pgMoon: TTabSheet;
    pgCalendar: TTabSheet;
    lblEaster: TLabel;
    valEaster: TLabel;
    lblPesach: TLabel;
    valPesach: TLabel;
    lblChinese: TLabel;
    valChinese: TLabel;
    lblEasterJulian: TLabel;
    valEasterJulian: TLabel;
    lblMoonRise: TLabel;
    lblMoonTransit: TLabel;
    lblMoonSet: TLabel;
    valMoonRise: TLabel;
    valMoonTransit: TLabel;
    valMoonSet: TLabel;
    lblMoonEclipse: TLabel;
    valMoonEclipse: TLabel;
    typMoonEclipse: TLabel;
    lblPerigee: TLabel;
    valPerigee: TLabel;
    lblApogee: TLabel;
    valApogee: TLabel;
    sarosMoonEclipse: TLabel;
    lblSunRise: TLabel;
    lblSunTransit: TLabel;
    lblSunSet: TLabel;
    valSunRise: TLabel;
    valSunTransit: TLabel;
    valSunSet: TLabel;
    lblPerihel: TLabel;
    valPerihel: TLabel;
    lblAphel: TLabel;
    valAphel: TLabel;
    lblSunEclipse: TLabel;
    valSunEclipse: TLabel;
    typSunEclipse: TLabel;
    sarosSunEclipse: TLabel;
    lblSpring: TLabel;
    lblSummer: TLabel;
    lblAutumn: TLabel;
    lblWinter: TLabel;
    valSpring: TLabel;
    valSummer: TLabel;
    valAutumn: TLabel;
    valWinter: TLabel;
    lblSunRektaszension: TLabel;
    valSunRektaszension: TLabel;
    lblSunDeclination: TLabel;
    valSunDeclination: TLabel;
    valSunZodiac: TLabel;
    lblMoonRektaszension: TLabel;
    lblMoonDeclination: TLabel;
    valMoonRektaszension: TLabel;
    valMoonDeclination: TLabel;
    valMoonZodiac: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LocationChange(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
  private
    FLocations: TList;
    FFirstNow: TDateTime;
    FStartTime: TDateTime;
    procedure SetStartTime(AValue: TDateTime);
    procedure UpdateLayout;
    procedure UpdateStrings;
    procedure UpdateValues;
  public
    property StartTime: TDateTime read FStartTime write SetStartTime;
  end;

var
  frmMoreData: TfrmMoreData;


implementation

uses
  Math,
  mtStrings, mtConst, mtUtils;

{$ifdef FPC}
 {$R *.lfm}
{$else}
 {$R *.dfm}
{$endif}

var
  ChineseZodiac: array[TChineseZodiac] of string;


{ TfrmMoreData }

procedure TfrmMoreData.FormCreate(Sender: TObject);
begin
  FStartTime := now;
  FFirstNow := now;
  HelpContext := hc_moredata;
end;

procedure TfrmMoreData.FormHide(Sender: TObject);
begin
  SaveLocations(MOONTOOL_INIFILE, FLocations, cbxLocation.ItemIndex);
  FreeLocations(FLocations);
end;

procedure TfrmMoreData.FormShow(Sender: TObject);
var
  current, i: integer;
  L, T: Integer;
begin
  UpdateStrings;

  LoadLocations(moontool_inifile, FLocations, current);
  cbxLocation.Items.BeginUpdate;
  try
    cbxLocation.Items.Clear;
    for i:=0 to FLocations.Count-1 do
      cbxLocation.Items.Add(TLocation(FLocations[i]).Name);
  finally
    cbxLocation.Items.EndUpdate;
  end;
  cbxLocation.Itemindex := current;
  LocationChange(NIL);

  L := Application.MainForm.Left + (Application.MainForm.Width - Width) div 2;
  T := Application.MainForm.Top + (Application.MainForm.Height - Height) div 2;
  SetBounds(L, T, Width, Height);
end;

procedure TfrmMoreData.LocationChange(Sender: TObject);
begin
  UpdateValues;
end;

procedure TfrmMoreData.PageControlChange(Sender: TObject);
begin
  //UpdateLayout;
end;

procedure TfrmMoreData.SetStartTime(AValue: TDateTime);
begin
   FStartTime := AValue;
end;

procedure TfrmMoreData.UpdateLayout;
const
  MARGIN = 4;
  DISTANCE = 8;
  LARGE_DISTANCE = 24;
  ROW_DISTANCE = 2;
var
  x, y: Integer;
  pageWidthSun, pageWidthMoon, pageHeight: Integer;
  P: TPoint;
begin
  //  page 1: Sun
  x := MARGIN;
  ArrangeInColumns(x, pgSun, 10, 11, DISTANCE);
  inc(x, LARGE_DISTANCE);
  ArrangeInColumns(x, pgSun, 12, 13, DISTANCE);
  pageWidthSun := x + MARGIN;

  y := MARGIN;
  ArrangeInRow(y, ROW_DISTANCE, [lblSunRise, valSunRise, lblAphel, valAphel]);
  ArrangeInRow(y, ROW_DISTANCE, [lblSunTransit, valSunTransit, lblPerihel, valPerihel]);
  ArrangeInRow(y, ROW_DISTANCE, [lblSunSet, valSunSet]);
  inc(y, DISTANCE);
  ArrangeInRow(y, ROW_DISTANCE, [lblSunRektaszension, valSunRektaszension, lblSpring, valSpring]);
  ArrangeInRow(y, ROW_DISTANCE, [lblSunDeclination, valSunDeclination, lblSummer, valSummer]);
  ArrangeInRow(y, ROW_DISTANCE, [lblAutumn, valAutumn]);
  ArrangeInRow(y, ROW_DISTANCE, [lblWinter, valWinter]);
  inc(y, DISTANCE);
  ArrangeInRow(y, ROW_DISTANCE, [lblSunZodiac, valSunZodiacName]);
  ArrangeInRow(y, ROW_DISTANCE, [valSunZodiac]);
  inc(y, DISTANCE);
  ArrangeInRow(y, ROW_DISTANCE, [lblSunEclipse, valSunEclipse]);
  ArrangeInRow(y, ROW_DISTANCE, [sarosSunEclipse]);
  ArrangeInRow(y, ROW_DISTANCE, [typSunEclipse]);
  pageHeight := y;

  //  page 2: Moon
  x := MARGIN;
  ArrangeInColumns(x, pgMoon, 20, 21, DISTANCE);
  inc(x, LARGE_DISTANCE);
  ArrangeInColumns(x, pgMoon, 22, 23, DISTANCE);
  pageWidthMoon := x + MARGIN;

  y := MARGIN;
  ArrangeInRow(y, ROW_DISTANCE, [lblMoonRise, valMoonRise, lblApogee, valApogee]);
  ArrangeInRow(y, ROW_DISTANCE, [lblMoonTransit, valMoonTransit, lblPerigee, valPerigee]);
  ArrangeInRow(y, ROW_DISTANCE, [lblMoonSet, valMoonSet]);
  inc(y, DISTANCE);
  ArrangeInRow(y, ROW_DISTANCE, [lblMoonRektaszension, valMoonRektaszension]);
  ArrangeInRow(y, ROW_DISTANCE, [lblMoonDeclination, valMoonDeclination]);
  inc(y, DISTANCE);
  ArrangeInRow(y, ROW_DISTANCE, [lblMoonZodiac, valMoonZodiac_Name]);
  ArrangeInRow(y, ROW_DISTANCE, [valMoonZodiac]);
  inc(y, DISTANCE);
  ArrangeInRow(y, ROW_DISTANCE, [lblMoonEclipse, valMoonEclipse]);
  ArrangeInRow(y, ROW_DISTANCE, [sarosMoonEclipse]);
  ArrangeInRow(y, ROW_DISTANCE, [typMoonEclipse]);

  // page 3: Calendar
  x := MARGIN;
  ArrangeInColumns(x, pgCalendar, 30, 31, DISTANCE);
  y := MARGIN;
  ArrangeInRow(y, ROW_DISTANCE, [lblEaster, valEaster]);
  ArrangeInRow(y, ROW_DISTANCE, [lblPesach, valPesach]);
  ArrangeInRow(y, ROW_DISTANCE, [lblEasterJulian, valEasterJulian]);
  ArrangeInRow(y, ROW_DISTANCE, [lblChinese, valChinese]);

  P := PgSun.ClientToParent(Point(Max(pageWidthSun, pageWidthMoon), pageHeight), self);
  ClientWidth := P.X + 2*MARGIN;
  ClientHeight := P.Y + 2*MARGIN;
end;

procedure TfrmMoreData.UpdateStrings;
var
  z: TChineseZodiac;
begin
  Caption := SMoreData;
  lblLatitude.Caption := SLatitude;
  lblLongitude.Caption := SLongitude;
  lblSpring.Caption := SSpring;
  lblSummer.Caption := SSummer;
  lblAutumn.Caption := SAutumn;
  lblWinter.Caption := SWinter;
  lblSunRise.Caption := SSunRise;
  lblSunTransit.Caption := SSunTransit;
  lblSunSet.Caption := SSunSet;
  lblMoonRise.Caption := SMoonRise;
  lblMoonTransit.Caption := SMoonTransit;
  lblMoonSet.Caption := SMoonSet;
  lblLocation.Caption := SLocation;
  lblPerigee.Caption := SPerigee;
  lblApogee.Caption := SApogee;
  lblPerihel.Caption := SPerihel;
  lblAphel.Caption := SAphel;
  lblMoonEclipse.Caption := SMoonEclipse;
  lblSunEclipse.Caption := SSunEclipse;
  lblEaster.Caption := SEasterDate;
  lblPesach.Caption := SPesachDate;
  lblChinese.Caption := SChineseNewYear;
  lblEasterJulian.Caption := SEasterDateOrthodox;
  lblSunRektaszension.Caption := SRektaszension;
  lblSunDeclination.Caption := SDeclination;
  lblMoonRektaszension.Caption := SRektaszension;
  lblMoonDeclination.Caption := SDeclination;
  lblMoonZodiac.Caption := SZodiac;
  lblSunZodiac.Caption := SZodiac;
  pgSun.Caption := SSun;
  pgMoon.Caption := SMoon;
  pgCalendar.Caption := SCalendar;

  ChineseZodiac[ch_rat] := SChineseZodiacRat;
  ChineseZodiac[ch_ox] := SChineseZodiacOx;
  ChineseZodiac[ch_tiger] := SChineseZodiacTiger;
  ChineseZodiac[ch_rabbit] := SChineseZodiacRabbit;
  ChineseZodiac[ch_dragon] := SChineseZodiacDragon;
  ChineseZodiac[ch_snake] := SChineseZodiacSnake;
  ChineseZodiac[ch_horse] := SChineseZodiacHorse;
  ChineseZodiac[ch_Goat] := SChineseZodiacGoat;
  ChineseZodiac[ch_monkey] := SChineseZodiacMonkey;
  ChineseZodiac[ch_chicken] := SChineseZodiacChicken;
  ChineseZodiac[ch_dog] := SChineseZodiacDog;
  ChineseZodiac[ch_pig] := SChineseZodiacPig;

  UpdateLayout;
end;

procedure TfrmMoreData.UpdateValues;
var
  y,m,d: word;
  date: TDateTime;
  j: longint;
  eclipse_value: TEclipseData;
  longitude, latitude: extended;
  rektaszension, declination: extended;
  chinese: TChineseDate;
  z: TZodiac;
  utcNow: TDateTime;
  dt, dt2: TDateTime;
begin
  dt := FStartTime + (now - FFirstNow) + TimeZoneBias/(60*24);
  DecodeDate(dt, y, m, d);

  { recalculate and show data }
  try
    valSpring.Caption := UTCDateString(StartSeason(y, spring));
    valSummer.Caption := UTCDateString(StartSeason(y, summer));
    valAutumn.Caption := UTCDateString(StartSeason(y, autumn));
    valWinter.Caption := UTCDateString(StartSeason(y, winter));
  except
    valSpring.Caption := SOutOfRange;
    valSummer.Caption := SOutOfRange;
    valAutumn.Caption := SOutOfRange;
    valWinter.Caption := SOutOfRange;
  end;
  lblSpring.Hint := '';
  lblSummer.Hint:= '';
  lblAutumn.Hint := '';
  lblWinter.Hint := '';

  valPerigee.Caption := UTCDateString(NextPeriGee(dt));
  valApogee.Caption:= UTCDateString(NextApoGee(dt));
  valPerihel.Caption := UTCDateString(NextPerihel(dt));
  valAphel.Caption := UTCDateString(NextAphel(dt));

  { Sun eclipse }
  dt2 := dt;
  eclipse_value:=NextEclipseEx(dt2,true);
  valSunEclipse.Caption := UTCDateString(eclipse_value.Date);
  case eclipse_value.EclipseType of
    none, halfshadow: typSunEclipse.Caption := SEclipseNone;
    partial:          typSunEclipse.Caption := SEclipsePartial;
    total:            typSunEclipse.Caption := SEclipseTotal;
    circular:         typSunEclipse.Caption := SEclipseCircular;
    circulartotal:    typSunEclipse.Caption := SEclipseCircularTotal;
    noncentral:       typSunEclipse.Caption := SEclipseNonCentral;
  end;
  sarosSunEclipse.Caption := Format(SSaros, [
    eclipse_value.Saros, eclipse_value.Inex, eclipse_value.sarosNumber
  ]);

  { Moon eclipse }
  dt2 := dt;
  eclipse_value := NextEclipseEx(dt2, false);
  valMoonEclipse.Caption := UTCDateString(eclipse_value.Date);
  case eclipse_value.EclipseType of
    none:             typMoonEclipse.Caption := SEclipseNone;
    partial:          typMoonEclipse.Caption := SEclipsePartial;
    total:            typMoonEclipse.Caption := SEclipseTotal;
    halfshadow:       typMoonEclipse.Caption := SEclipseHalfshadow;
    { circular, circulartotal, and noncentral used by sun only }
  end;
  sarosMoonEclipse.Caption := Format(SSaros, [
    eclipse_value.Saros, eclipse_value.Inex, eclipse_value.SarosNumber
  ]);

  valEaster.Caption := FormatDateTime('c', FalsifyTDateTime(Easterdate(y)));
  valEasterJulian.caption := FormatDatetime('c',FalsifyTDateTime(EasterdateJulian(y)));
  valPesach.caption := FormatDatetime('c', FalsifyTDateTime(Pesachdate(y)));
  date := ChineseNewYear(y);
  chinese := ChineseDate(date);
  valChinese.Caption := FormatDateTime('c',FalsifyTDateTime(date))+
    ' ('+ChineseZodiac[chinese.YearCycle.Zodiac]+')';

  { location }
  j := cbxLocation.ItemIndex;
  if j = -1 then  EXIT;
  if FLocations <> NIL then begin
    longitude := TLocation(FLocations[j]).Longitude;
    latitude := TLocation(FLocations[j]).Latitude;
  end
  else begin
    longitude := 0;
    latitude := 0;
  end;
  valLongitude.Caption := DegreeToString(abs(longitude));
  if longitude >= 0 then
    valLongitude.Caption := valLongitude.Caption + ' ' + SWest
  else
    valLongitude.Caption := valLongitude.Caption + ' ' + SEast;
  valLatitude.Caption:= DegreeToString(abs(latitude));
  if latitude >= 0 then
    valLatitude.Caption := valLatitude.Caption + ' ' + SNorth
  else
    valLatitude.Caption := valLatitude.Caption + ' ' + SSouth;

  { season hints accoring to location }
  if latitude>0 then begin
    lblSpring.hint := SSpringHint;
    lblSummer.hint := SSommerHint;
    lblAutumn.hint := SAutumnHint;
    lblWinter.hint := SWinterHint;
  end
  else begin
    lblAutumn.hint := SSpringHint;
    lblWinter.hint := SSommerHint;
    lblSpring.hint := SAutumnHint;
    lblSummer.hint := SWinterHint;
  end;

  { calc rise/set/transit }
  j := trunc(dt);
  try
    date := Moon_Rise(j, latitude, longitude);
    if trunc(date) < j then
      date := Moon_Rise(j+1, latitude, longitude);
    if trunc(date) > j then
      date := Moon_Rise(j-1, latitude, longitude);
    if trunc(date) <> j then
      valMoonRise.Caption := '---'
    else
      valMoonRise.Caption:= UTCDateString(date);

    date := Moon_Transit(j, latitude, longitude);
    if trunc(date) < j then
      date := Moon_Transit(j+1, latitude, longitude);
    if trunc(date) > j then
      date := Moon_Transit(j-1, latitude, longitude);
    if trunc(date) <> j then
      valMoonTransit.Caption:='---'
    else
      valMoonTransit.Caption := UTCDateString(date);

    date := Moon_Set(j, latitude, longitude);
    if trunc(date) < j then
      date := Moon_Set(j+1, latitude, longitude);
    if trunc(date) > j then
      date := Moon_Set(j-1, latitude, longitude);
    if trunc(date) <> j then
      valMoonSet.Caption := '---'
    else
      valMoonSet.Caption := UTCDateString(date);
  except
  end;

  // Moon zodiac
  z := MoonZodiac(dt);
  valMoonZodiac.Caption := char(ord('^') + ord(z));
  valMoonZodiac.Hint := GetZodiacName(z);
  valMoonZodiac_Name.Caption := GetZodiacName(z);
  Moon_Position_Equatorial(dt, rektaszension, declination);
  valMoonDeclination.Caption := DegreeToString(declination);
  valMoonRektaszension.Caption := RektaszensionToString(rektaszension);

  // Sun zodiac
  z := SunZodiac(dt);
  valSunZodiac.Caption := char(ord('^') + ord(z));
  Sun_Position_Equatorial(dt, rektaszension, declination);
  valSunZodiac.Hint := GetZodiacName(z);
  valSunZodiacName.Caption := GetZodiacName(z);

  // Sun rektaszension and declination
  valSunDeclination.Caption := DegreeToString(declination);
  valSunRektaszension.Caption := RektaszensionToString(rektaszension);
  try
    date := Sun_Rise(j, latitude, longitude);
    if trunc(date) < j then
      date := Sun_Rise(j+1, latitude, longitude);
    if trunc(date) > j then
      date:=Sun_Rise(j-1, latitude, longitude);
    if trunc(date) <> j then
      valSunRise.Caption := '---'
    else
      valSunRise.Caption := UTCDateString(date);

    date := Sun_Transit(j, latitude, longitude);
    if trunc(date) < j then
      date := Sun_Transit(j+1, latitude, longitude);
    if trunc(date) > j then
      date := Sun_Transit(j-1, latitude, longitude);
    if trunc(date) <> j then
      valSunTransit.Caption := '---'
    else
      valSunTransit.Caption := UTCDateString(date);

    date := Sun_Set(j, latitude, longitude);
    if trunc(date) < j then
      date := Sun_Set(j+1, latitude, longitude);
    if trunc(date) > j then
      date := Sun_Set(j-1, latitude, longitude);
    if trunc(date) <> j then
      valSunSet.Caption := '---'
    else
      valSunSet.caption := UTCDateString(date);
  except
  end;

  UpdateLayout;
end;

end.

