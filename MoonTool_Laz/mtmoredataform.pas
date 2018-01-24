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
    procedure UpdateInfos;
    procedure UpdatePositions;
    procedure UpdateStrings;
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
end;

procedure TfrmMoreData.locationChange(Sender: TObject);
begin
  UpdateInfos;
end;

procedure TfrmMoreData.PageControlChange(Sender: TObject);
begin
  UpdatePositions;
end;

procedure TfrmMoreData.SetStartTime(AValue: TDateTime);
begin
   FStartTime := AValue;
end;

procedure TfrmMoreData.UpdateInfos;
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

  z := MoonZodiac(dt);
  valMoonZodiac.Caption := char(ord('^') + ord(z));
  valMoonZodiac.Hint := GetZodiacName(z);
  valMoonZodiac_Name.Caption := GetZodiacName(z);
  Moon_Position_Equatorial(dt, rektaszension, declination);
  valMoonDeclination.Caption := DegreeToString(declination);
  valMoonRektaszension.Caption := RektaszensionToString(rektaszension);

  z := SunZodiac(dt);
  valSunZodiac.Caption := char(ord('^') + ord(z));
  Sun_Position_Equatorial(dt, rektaszension, declination);
  valSunZodiac.Hint := GetZodiacName(z);
  valSunZodiacName.Caption := GetZodiacName(z);
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

  UpdatePositions;
end;

procedure TfrmMoreData.UpdatePositions;

  function FindAnchorControl(AParent: TWinControl; ALeft: Integer): TControl;
  var
    i: Integer;
    w, wmax: Integer;
  begin
    Result := nil;
    wmax := 0;
    for i := 0 to AParent.ControlCount-1 do begin
      if AParent.Controls[i].Left = ALeft then begin
        w := AParent.Controls[i].Width;
        if w > wmax then begin
          wmax := w;
          Result := AParent.Controls[i];
        end;
      end;
    end;
  end;

var
  wSun, wMoon, wCalendar: Integer;
  c: TControl;
begin
  valSunRise.AnchorSideLeft.Control := FindAnchorControl(PgSun, lblSunRise.Left);
  lblAphel.AnchorSideLeft.Control := FindAnchorControl(PgSun, valSunRise.Left);
  valAphel.AnchorSideLeft.Control := FindAnchorControl(PgSun, lblAphel.Left);
  c := FindAnchorControl(PgSun, valAphel.Left);
  wSun := c.Left + c.Width + lblSunRise.Left;

  valMoonRise.AnchorSideLeft.Control := FindAnchorControl(PgMoon, lblMoonRise.Left);
  lblApogee.AnchorSideLeft.Control := FindAnchorControl(PgMoon, valMoonRise.Left);
  valApogee.AnchorSideLeft.control := FindAnchorControl(PgMoon, lblApogee.Left);
  c := FindAnchorControl(PgMoon, valApogee.Left);
  wMoon := c.Left + c.Width + lblMoonRise.Left;

  valEaster.AnchorSideLeft.Control := FindAnchorControl(PgCalendar, lblEaster.Left);
  c := FindAnchorControl(PgCalendar, valEaster.Left);
  wCalendar := c.Left + c.Width + lblEaster.Left;

  Width := MaxValue([wSun, wMoon, wCalendar]) + 2*PageControl.Left;
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
end;


end.

