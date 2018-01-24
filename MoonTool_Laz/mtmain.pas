unit mtMain;

interface

uses
{$ifdef fpc}
  LCLIntf, LCLType,
{$else}
  Windows, Messages,
{$endif}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs, ExtCtrls, StdCtrls,
  Menus, Clipbrd, IniFiles,
{$ifndef fpc}
  trayicon,
{$endif}
  Moon, MoonComp;

type
  { TMainForm }

  TMainForm = class(TForm)
    lblAgeOfMoon: TLabel;
    lblFirstQuart: TLabel;
    lblfullMoon: TLabel;
    lblJulian: TLabel;
    lblLastLunation: TLabel;
    lblLastNew: TLabel;
    lblLastQuart: TLabel;
    lblLocal: TLabel;
    lblMoonDistance: TLabel;
    lblMoonSubtend: TLabel;
    lblNextLunation: TLabel;
    lblNextNewMoon: TLabel;
    lblPhase: TLabel;
    lblSunDistance: TLabel;
    lblSunSubtend: TLabel;
    lblUTC: TLabel;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    mnuVeryFastMode: TMenuItem;
    mnuFastMode: TMenuItem;
    mnuNormalSpeed: TMenuItem;
    mnuSpeed: TMenuItem;
    mnLanguageDE: TMenuItem;
    mnuLanguageEN: TMenuItem;
    mnuLanguage: TMenuItem;
    Moon: TMoon;
    Panel1: TPanel;
    valAgeOfMoon: TLabel;
    valFirstQuart: TLabel;
    valFullMoon: TLabel;
    valJulian: TLabel;
    valLastLunation: TLabel;
    valLastQuart: TLabel;
    valLocal: TLabel;
    valMoonDistance: TLabel;
    valMoonSubtend: TLabel;
    valNewMoon: TLabel;
    valNextLunation: TLabel;
    valNextNewMoon: TLabel;
    valPhase: TLabel;
    valSunSubtend: TLabel;
    valSunDistance: TLabel;
    valUTC: TLabel;
    Timer: TTimer;
    MainMenu: TMainMenu;
    mnuFile: TMenuItem;
      mnuTray: TMenuItem;
      mnuExit: TMenuItem;
    mnuEdit: TMenuItem;
      mnuCopy: TMenuItem;
    mnuOptions: TMenuItem;
      mnuStop: TMenuItem;
      mnuline1: TMenuItem;
      mnuJulian: TMenuItem;
      mnuUTC: TMenuItem;
      mnuJewish: TMenuItem;
      mnuLine3: TMenuItem;
      mnuColorizeMoon: TMenuItem;
      mnuRotate: TMenuItem;
        mnuRotNorth: TMenuItem;
        mnuRotSouth: TMenuItem;
      mnuLine4: TMenuItem;
      mnuLocations: TMenuItem;
      mnuMoreData: TMenuItem;
    mnuHelp: TMenuItem;
      mnuMenuAbout: TMenuItem;
      mnuLine2: TMenuItem;
      mnuHelpTimezones: TMenuItem;
      mnuHelpItem: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure mnuMenuAboutClick(Sender: TObject);
    procedure mnuColorizeMoonClick(Sender: TObject);
    procedure mnuCopyClick(Sender: TObject);
    procedure mnuExitClick(Sender: TObject);
    procedure mnuHelpItemClick(Sender: TObject);
    procedure mnuJewishClick(Sender: TObject);
    procedure mnuJulianClick(Sender: TObject);
    procedure mnuLanguageClick(Sender: TObject);
    procedure mnuLocationsClick(Sender: TObject);
    procedure mnuMoreDataClick(Sender: TObject);
    procedure mnuRotateClick(Sender: TObject);
    procedure mnuSpeedUpClick(Sender: TObject);
    procedure mnuStopClick(Sender: TObject);
    procedure mnuHelpTimezonesClick(Sender: TObject);
    procedure mnuTrayClick(sender: TObject);
    procedure mnuUTCClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    FlastPhaseValue: integer;
    FFirstNow: TDateTime;
    FSpeed: Integer;
    FStartTime: TDateTime;
    FTrayIcon: TTrayIcon;
    function HelpHandler(Command:word; Data:Longint; var CallHelp:Boolean): Boolean;
    procedure SelectLanguage(ALang: String);
    procedure TrayDblClick(Sender: TObject);
    procedure UpdateControls;
    procedure UpdateStrings;
  public
  end;

var
  MainForm: TMainForm;


implementation

uses
  {$ifdef windows}
  htmlhelp,
  {$endif}
  {$ifdef fpc}
  mtStrings, Translations,
  {$endif}
  mtConst, mtUtils,
  mtAbout, mtMoreDataForm, mtJulianForm, mtUTCForm, mtLocation, mtJewishForm;

{$ifdef fpc}
  {$r *.lfm}
{$else}
  {$r *.dfm}
{$endif}

procedure LoadSettings(var rotate: integer; var color:boolean);
var
  iniFile : TIniFile;
begin
  iniFile := TMemIniFile.Create(MOONTOOL_INIFILE);
  try
    rotate := IniFile.ReadInteger('Current', 'Rotate', 0);
    color := iniFile.ReadBool('Current', 'Color', false);
  finally
    inifile.Free;
  end;
end;

procedure SaveSettings(rotate: integer; color: boolean);
var
  iniFile: TIniFile;
begin
  iniFile := TIniFile.Create(MOONTOOL_INIFILE);
  try
    inifile.WriteInteger('Current', 'Rotate', rotate);
    inifile.WriteBool('Current', 'Color', color);
  finally
    inifile.Free;
  end;
end;


{ TMainForm }

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
  rotate: integer;
begin
  if Moon.Rotation = rot_180 then
    rotate := 180
  else
    rotate := 0;
  SaveSettings(rotate, Moon.MoonStyle=msColor);
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  rotate: integer;
  use_color: boolean;
begin
  Lang := GetOSLanguage;

  FFirstNow := now;
  FStartTime := now;

  FTrayIcon := TTrayIcon.Create(self);
  FTrayIcon.OnDblClick := TrayDblClick;
  mnuTray.Visible := true;

  LoadSettings(rotate, use_color);
  if use_color then
    Moon.MoonStyle := msColor
  else
    Moon.MoonStyle := msClassic;
  if rotate = 180 then
    Moon.Rotation := rot_180
  else
    Moon.Rotation := rot_none;

  mnuRotSouth.Checked := rotate = 180;
  mnuRotNorth.Checked := rotate = 0;
  mnuColorizeMoon.Checked := use_color;

  Timer.OnTimer(nil);

  Application.Icon := Moon.Icon;
  if FileExists(HELPFILENAME) then begin
    Application.Helpfile := HELPFILENAME;
    Application.Helpfile := ChangeFileExt(Application.ExeName, '.chm'); //HELPFILENAME;
    Application.OnHelp := HelpHandler;
  end;
  {$ifndef fpc}
  InvalidateRect(Application.Handle, nil, true);
  {$endif}

  FLastPhaseValue := 199;
  mnuHelpTimezones.Enabled := Application.Helpfile <> '';
  HelpContext := HC_MAINFORM;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  SelectLanguage(Lang);
end;

function TMainForm.HelpHandler(Command:word; Data:Longint; var CallHelp:Boolean): Boolean;
// Call online-help
begin
  {$ifdef windows}
  // Call HTML help (.chm file)
  htmlHelp.HtmlHelpA(0,
    PChar(Application.HelpFile),
    HH_HELP_CONTEXT,
    Data
  );

  // Don't call regular help
  CallHelp := False;
  {$endif}
end;

procedure TMainForm.TimerTimer(Sender: TObject);
begin
  UpdateControls;
end;

procedure TMainForm.mnuStopClick(Sender: TObject);
begin
  Timer.Enabled := not Timer.Enabled;
  if Timer.Enabled then
     mnuStop.Caption := SMenuStop
  else
    mnuStop.Caption := SMenuRun;
end;

procedure TMainForm.mnuExitClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.mnuMenuAboutClick(Sender: TObject);
var
  F: TfrmAbout;
begin
  F := TfrmAbout.Create(nil);
  try
    F.ShowModal;
  finally
    F.Free;
  end;
end;

procedure TMainForm.mnuColorizeMoonClick(Sender: TObject);
begin
  mnuColorizeMoon.Checked := not mnuColorizeMoon.Checked;
  if mnuColorizeMoon.Checked then
    Moon.MoonStyle := msColor
  else
    Moon.MoonStyle := msClassic;
  FLastPhaseValue := 199;
  UpdateControls;
end;

procedure TMainForm.mnuCopyClick(Sender: TObject);
var
  h: TBitmap;
begin
  h := TBitmap.Create;
  try
    h.Width := ClientWidth;
    h.Height := ClientHeight;
    Update;
    h.Canvas.CopyRect(
      Rect(0, 0, ClientWidth, ClientHeight),
      Canvas,
      Rect(0, 0, ClientWidth, ClientHeight)
    );
    Clipboard.Assign(h);
  finally
    h.Free;
  end;
end;

procedure TMainForm.mnuHelpItemClick(Sender: TObject);
begin
  Application.HelpContext(HC_MAIN);
end;

procedure TMainForm.mnuHelpTimezonesClick(Sender: TObject);
begin
  Application.HelpContext(HC_TIMEZONES);
end;

procedure TMainForm.mnuJewishClick(Sender: TObject);
var
  bias: TDateTime;
begin
  if frmJewish = nil then
    frmJewish := TfrmJewish.Create(Application);
  bias := TimeZoneBias/(60*24);
  frmJewish.Date := FStartTime + (now - FFirstNow) + bias;
  if frmJewish.ShowModal = mrOk then begin
    FStartTime := frmJewish.Date - (now - FFirstNow) - bias;
    UpdateControls;
    if frmMoreData = nil then
      frmMoreData := TfrmMoreData.Create(Application);
    frmMoreData.StartTime := FStartTime;
  end;
end;

procedure TMainForm.mnuJulianClick(Sender: TObject);
var
  bias: TDateTime;
begin
  if frmJulian = nil then
    frmJulian := TfrmJulian.Create(Application);
  bias := TimeZoneBias / (60*24);
  frmJulian.Date := FStartTime + (now - FFirstNow) + bias;
  if frmJulian.ShowModal = mrOk then begin
    FStartTime := frmJulian.Date - (now - FFirstNow) - bias;
    UpdateControls;
    if frmMoreData = nil then
      frmMoreData := TfrmMoreData.Create(Application);
    frmMoredata.StartTime := FStartTime;
  end;
end;

procedure TMainForm.mnuLanguageClick(Sender: TObject);
var
  s: String;
  p: Integer;
  lang: String;
begin
  if not (Sender is TMenuItem) then
    exit;
  s := TMenuItem(Sender).Caption;
  p := pos('-', s);
  lang := trim(Copy(s, 1, p-1));
  SelectLanguage(lang);
end;

procedure TMainForm.mnuLocationsClick(Sender: TObject);
begin
  frmLocations.ShowModal;
end;

procedure TMainForm.mnuMoreDataClick(Sender: TObject);
begin
  if frmMoreData = nil then
    frmMoreData := TfrmMoreData.Create(Application);
  frmMoreData.Show;
end;

procedure TMainForm.mnuRotateClick(Sender: TObject);
begin
  if Sender = mnuRotNorth then
    Moon.Rotation := rot_none
  else
  if Sender = mnuRotSouth then
    Moon.Rotation := rot_180;

  mnuRotNorth.Checked := Moon.Rotation = rot_none;
  mnuRotSouth.Checked := Moon.Rotation = rot_180;
  FLastPhaseValue := 199;
  UpdateControls;
end;

procedure TMainForm.mnuSpeedUpClick(Sender: TObject);
var
  i: Integer;
begin
  if Sender = mnuNormalSpeed then
    FSpeed := 0
  else if Sender = mnuFastMode then
    FSpeed := 1
  else if Sender = mnuVeryFastMode then
    FSpeed := 2;

  for i:=0 to mnuSpeed.Count-1 do
    mnuSpeed.Items[i].Checked := (mnuSpeed.Items[i] = Sender);

  FFirstNow := now;
end;

procedure TMainForm.mnuTrayClick(sender: TObject);
begin
 {$ifdef fpc}
  Hide;
  FTrayIcon.Show;
 {$else}
  FTrayIcon.Active := true;
  Application.Minimize;
  ShowWindow(Application.Handle, SW_HIDE);
 {$endif}
end;

procedure TMainForm.mnuUTCClick(Sender: TObject);
var
  bias: TDateTime;
begin
  if frmUTC = nil then
    frmUTC := TfrmUTC.Create(Application);
  bias := TimeZoneBias/(60*24);
  frmUTC.Date := FStartTime + (now - FFirstNow) + bias;
  if frmUTC.ShowModal = mrOk then begin
    FStartTime := frmUTC.Date - (now - FFirstNow) - bias;
    UpdateControls;
    if frmMoreData = nil then
      frmMoreData := TfrmMoreData.Create(Application);
    frmMoreData.StartTime := FStartTime;
  end;
end;

procedure TMainForm.SelectLanguage(ALang: string);
var
  s: String;
  i: Integer;
  p: Integer;
  fn: String;
  langdir: String;
begin
  Lang := lowercase(ALang);

  // Update formatsettings (for month names etc)
  GetFormatSettingsFromLangCode(Lang, LocalFormatSettings);

  // Translate strings
  langdir := IncludeTrailingPathDelimiter(ExtractFilepath(Application.Exename) + LANGUAGE_DIR);
  fn := langdir + ChangeFileExt(ExtractFilename(Application.ExeName), '') + '.' + Lang + '.po';
  Translations.TranslateResourceStrings(fn);
  //fn := langdir + 'lclstrconsts.' + Lang + '.po';
  // Translations.TranslateResourceStrings(fn);

  // Apply strings to form
  UpdateStrings;

  // Select the new language in the language menu
  for i:=0 to mnuLanguage.Count-1 do begin
    s := mnuLanguage.Items[i].Caption;
    p := pos(' ', s);
    if p = 0 then
      p := pos('-', s);
    if p = 0 then
      raise Exception.Create('Language items are not properly formatted.');
    s := lowercase(copy(s, 1, p-1));
    mnuLanguage.Items[i].Checked := (s = Lang);
  end;
end;

procedure TMainForm.TrayDblClick(sender: TObject);
begin
 {$ifdef fpc}
  Show;
  FTrayIcon.Hide;
 {$else}
  FTrayIcon.Active := false;
  ShowWindow(Application.Handle, SW_SHOW);
  {$endif}
end;

procedure TMainForm.UpdateControls;
var
  jetzt: TDateTime;
  temp: TDateTime;
  dist,age: extended;
  s:string;
  h,m,sec,ms: word;
  bias: integer;
  new_phase: integer;
  lunation_value: integer;
begin
  bias := TimeZoneBias;
  case FSpeed of
    0: jetzt := (now - FFirstNow) + FStartTime;
    1: jetzt := (now - FFirstNow) * 3600 + FStartTime;       // 1 hour per second
    2: jetzt := (now - FFirstNow) * 3600 * 24 + FStartTime;  // 1 day per second
  end;
  if FSpeed = 0 then
    valLocal.Caption := DateToString(jetzt)
  else
    valLocal.Caption := '';

  jetzt := jetzt + bias/(60*24);
  valUTC.Caption := DateToString(jetzt);
  str(Julian_Date(jetzt):12:5, s);
  valJulian.Caption := s;

  try
    temp := Last_Phase(jetzt, Newmoon);
    lunation_value := Lunation(temp+1);
    valNewMoon.Caption := UTCDateString(temp);
    valFirstQuart.Caption := UTCDateString(Next_Phase(temp, FirstQuarter));
    valFullMoon.Caption := UTCDateString(Next_Phase(temp, FullMoon));
    if Is_Blue_Moon(lunation_value) then
      lblfullMoon.Font.Color := clBlue
    else
      lblfullMoon.Font.Color := clWindowText;
    case MoonName(lunation_value) of
      mn_wolf:        lblfullMoon.Hint := SMoonNameWolf;
      mn_snow:        lblfullMoon.Hint := SMoonNameSnow;
      mn_worm:        lblfullMoon.Hint := SMoonNameWorm;
      mn_pink:        lblfullMoon.Hint := SMoonNamePink;
      mn_flower:      lblfullMoon.Hint := SMoonNameFlower;
      mn_strawberry:  lblfullMoon.Hint := SMoonNameStrawberry;
      mn_buck:        lblfullMoon.Hint := SMoonNameBuck;
      mn_sturgeon:    lblfullMoon.Hint := SMoonNameSturgeon;
      mn_harvest:     lblfullMoon.Hint := SMoonNameHarvest;
      mn_hunter:      lblfullMoon.Hint := SMoonNameHunter;
      mn_beaver:      lblfullMoon.Hint := SMoonNameBeaver;
      mn_cold:        lblfullMoon.Hint := SMoonNameCold;
      mn_blue:        lblfullMoon.Hint := SMoonNameBlue;
    end;
    valLastQuart.Caption := UTCDateString(Next_Phase(temp, LastQuarter));
    valNextNewMoon.Caption := UTCDateString(Next_Phase(jetzt, NewMoon));
    valLastLunation.Caption := IntToStr(lunation_value);
    valNextLunation.Caption := IntToStr(lunation_value+1);
  except
    { ignore exception which might be raised if too close to October 1582 }
  end;

  dist := Moon_Distance(jetzt);
  str(dist/EARTH_RADIUS:4:1, s);
  valMoonDistance.Caption := IntToStr(round(dist))+' '+SKilometers+', '+s+' '+SEarthRadii+'.';

  dist := Sun_Distance(jetzt);
  str(dist:6:3, s);
  valSunDistance.Caption := IntToStr(round(dist*AU))+' '+SKilometers+', '+s+' '+SAstronomicalUnits+'.';

  age := AgeOfMoonWalker(jetzt);
  DecodeTime(age, h, m, sec, ms);
  valAgeOfMoon.Caption := Format(SAgeOfMoonValue, [trunc(age), h, m]);

  new_phase := round(Current_Phase(jetzt) * 100);
  valPhase.Caption := IntToStr(new_phase) + '% ' + SPhaseHint;

  Str(moon_diameter(jetzt)/3600:6:4, s);
  valMoonSubtend.Caption := s + DEG_SYMBOL;

  Str(sun_diameter(jetzt)/3600:6:4, s);
  valSunSubtend.Caption := s + DEG_SYMBOL;

  if new_phase <> FLastPhaseValue then begin
    Moon.Date := jetzt;
    Application.Icon := Moon.Icon;
    {$ifndef fpc}
    InvalidateRect(Application.Handle, nil, true);
    {$endif}
    FLastPhaseValue := new_phase;
    if FTrayicon <> NIL then begin
      FTrayicon.Icon := Moon.icon;
      {$ifdef fpc}
      FTrayicon.Hint := IntToStr(new_phase) + '%';
      {$else}
      FTrayIcon.ToolTip := IntToStr(new_phase) + '%';
      {$endif}
    end;
  end;
end;

procedure TMainForm.UpdateStrings;
var
  i, w: Integer;
  maxwidth:Integer;
  C: TControl;
begin
//  UpdateControls;    { make sure the val_* are set }
  Caption := SMoontool;
  lblAgeOfMoon.Caption := SAgeOfMoon;
  lblFirstQuart.Caption := SFirstQuarter;
  lblfullMoon.Caption := SFullMoon;
  lblJulian.Caption := SJuliandate;
  lblLastLunation.Caption := SLunation;
  lblLastNew.Caption := SLastNewMoon;
  lblLastQuart.Caption := SLastQuarter;
  lblLocal.Caption := SLocalTime;
  lblMoonDistance.Caption := SMoonDistance;
  lblMoonSubtend.Caption := SMoonSize;
  lblNextLunation.Caption := SLunation;
  lblNextNewMoon.Caption := SNextNewMoon;
  lblPhase.Caption := SMoonPhase;
  lblSunDistance.Caption := SSunDistance;
  lblSunSubtend.Caption := SSunSize;
  lblUTC.Caption := SUTC;
  mnuFile.Caption := SMenuFile;
  mnuTray.Caption := SMinimizeTray;
  mnuExit.Caption := SMenuExit;
  mnuEdit.Caption := SMenuEdit;
  mnuCopy.Caption := SMenuCopy;
  mnuExit.Caption := SMenuExit;
  mnuOptions.Caption := SMenuOptions;
  mnuLanguage.Caption := SMenuLanguage;
  mnuSpeed.Caption := SMenuSpeed;
  mnuNormalSpeed.Caption := SMenuNormalSpeed;
  mnuFastMode.Caption := SMenuFast;
  mnuVeryFastMode.Caption := SMenuVeryFast;
  mnuStop.Caption := SMenuStop;
  mnuJulian.Caption := SMenuJulian;
  mnuUTC.Caption := SMenuUTC;
  mnuJewish.Caption := SMenuJewish;
  mnuLocations.Caption := SMenuLocation;
  mnuRotate.Caption := SMenuRotate;
  mnuRotNorth.Caption := SMenuRotateNorth;
  mnuRotSouth.Caption := SMenuRotateSouth;
  mnuColorizeMoon.Caption := SMenuColorMoon;
  mnuMoreData.Caption := SMenuMore;
  mnuHelp.Caption := SMenuHelp;
  mnuHelpItem.Caption := SMenuHelpItem;
  mnuMenuAbout.Caption := SMenuAbout;
  mnuHelpTimezones.Caption := SMenuTimeZones;
  Application.Title := Caption;

  C := nil;
  maxWidth := 0;
  for i:=0 to ControlCount-1 do
    if (Controls[i] is TLabel) and (TLabel(Controls[i]).Left = lblJulian.Left) then
    begin
      w := Controls[i].Width;
      if w > maxWidth then begin
        maxWidth := w;
        C := Controls[i];
      end;
    end;
  if C <> nil then
    valJulian.AnchorSideLeft.Control := C;
end;

initialization
  MOONTOOL_INIFILE := ExtractFilePath(ParamStr(0)) + MOONTOOL_INIFILE;

end.

