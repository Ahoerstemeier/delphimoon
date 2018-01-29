unit mtMain;

interface

{$i ..\ah_def.inc}

{$ifdef fpc}
  {$define use_tray_icon}
  {$define use_html_help_handler}
{$else}
 {$ifdef delphi_7}
  {$define use_html_help_handler}
 {$endif}
{$endif}

uses
{$ifdef fpc}
  LCLIntf, LCLType,
{$else}
  Windows, Messages,
{$endif}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs, ExtCtrls, StdCtrls,
  Menus, Clipbrd, IniFiles,

{$ifdef use_tray_icon}
 {$ifndef fpc}
  trayicon,
 {$endif}
{$endif}

{$ifndef fpc}
 {$ifdef delphi_2007}
  HtmlHelpViewer,
 {$endif}
  XPMan, gnugettext,
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
    Moon: TMoon;
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
      mnuLanguage: TMenuItem;
        mnuLanguageEN: TMenuItem;
        mnuLanguageDE: TMenuItem;
      mnuSpeed: TMenuItem;
        mnuNormalSpeed: TMenuItem;
        mnuFastMode: TMenuItem;
        mnuVeryFastMode: TMenuItem;
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
      mnuEclipses: TMenuItem;
    mnuHelp: TMenuItem;
      mnuMenuAbout: TMenuItem;
      mnuLine2: TMenuItem;
      mnuHelpTimezones: TMenuItem;
      mnuHelpItem: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure mnuColorizeMoonClick(Sender: TObject);
    procedure mnuCopyClick(Sender: TObject);
    procedure mnuEclipsesClick(Sender: TObject);
    procedure mnuExitClick(Sender: TObject);
    procedure mnuHelpItemClick(Sender: TObject);
    procedure mnuJewishClick(Sender: TObject);
    procedure mnuJulianClick(Sender: TObject);
    procedure mnuLanguageClick(Sender: TObject);
    procedure mnuLocationsClick(Sender: TObject);
    procedure mnuMenuAboutClick(Sender: TObject);
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
    FTranslated: Boolean;
   {$ifdef use_tray_icon}
    FTrayIcon: TTrayIcon;
    procedure TrayDblClick(Sender: TObject);
   {$endif}
   {$ifdef use_html_help_handler}
   function HtmlHelpHandler(Command: word; Data:Longint; var CallHelp:Boolean): Boolean;
   {$endif}
    procedure SelectLanguage(ALang: String; AUpdateSize: Boolean);
    procedure UpdateLayout;
    procedure UpdateStrings;
    procedure UpdateValues;
  public
  end;

var
  MainForm: TMainForm;


implementation

uses
 {$ifdef fpc}
  {$ifdef windows} htmlhelp,{$endif}
  Translations,
 {$endif}
  Math, mtStrings, mtConst, mtUtils,
  mtAbout, mtMoreDataForm, mtEclipsesForm, mtLocation,
  mtUTCForm, mtJulianForm, mtJewishForm;

{$ifdef fpc}
  {$R *.lfm}
{$else}
  {$R *.dfm}
{$endif}

{$ifdef delphi_7}
 const
   hhctrlLib = 'hhctrl.ocx';
   HH_DISPLAY_TOPIC = $0000;
   HH_HELP_CONTEXT = $000F;
   HH_CLOSE_ALL  = $0012;

function HtmlHelpA(hwndCaller: HWND; pszFile: PChar;
  uCommand: UINT; dwData: DWORD): HWND; stdcall; external hhctrlLib Name 'HtmlHelpA';
{$endif}

procedure LoadSettings(var rotate: integer; var color:boolean);
var
  iniFile : TCustomIniFile;
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
  Timer.Enabled := false;
  Lang := GetOSLanguage;
  SelectLanguage(Lang, false);

  FFirstNow := now;
  FStartTime := now;

  {$ifdef use_tray_icon}
  FTrayIcon := TTrayIcon.Create(self);
  FTrayIcon.OnDblClick := TrayDblClick;
  mnuTray.Visible := true;
  {$endif}

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

  UpdateValues;

  Application.Icon := Moon.Icon;
  if FileExists(HELPFILENAME) then begin
    Application.Helpfile := ExtractFilePath(Application.ExeName) + HELPFILENAME;
   {$ifdef use_html_help_handler}
    Application.OnHelp := HtmlHelpHandler;
   {$endif}
  end;

  FLastPhaseValue := 199;
  mnuHelpTimezones.Enabled := Application.Helpfile <> '';
  HelpContext := HC_MAINFORM;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  SelectLanguage(Lang, true);
  Timer.Enabled := true;
end;

// Call online-help
{$ifdef use_html_help_handler}
function TMainForm.HtmlHelpHandler(Command:word; Data:Longint; var CallHelp:Boolean): Boolean;
var
  res: Integer;
begin
{$ifdef mswindows}
 {$ifdef fpc}
  // Call HTML help (.chm file)
  res := htmlHelp.HtmlHelpA(0, PChar(Application.HelpFile), HH_HELP_CONTEXT, Data);
 {$endif}
 {$ifdef delphi_7}
  //Result :=
  res := HTMLHelpA(0, PChar(Application.HelpFile), HH_HELP_CONTEXT, Data);
 {$endif}
  Result := res <> 0;
  CallHelp := False;
{$endif}
end;
{$endif}

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
  UpdateValues;
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

procedure TMainForm.mnuEclipsesClick(Sender: TObject);
begin
  frmEclipses.Show;
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
    UpdateValues;
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
    UpdateValues;
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
  SelectLanguage(lang, true);
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
  UpdateValues;
end;

procedure TMainForm.mnuSpeedUpClick(Sender: TObject);
const
  INTERVALS: array[0..2] of Integer = (1000, 1000, 100);
var
  i: Integer;
begin
  if Sender = mnuNormalSpeed then
    FSpeed := 0
  else if Sender = mnuFastMode then
    FSpeed := 1
  else if Sender = mnuVeryFastMode then
    FSpeed := 2;
  Timer.Interval := INTERVALS[FSpeed];

  for i:=0 to mnuSpeed.Count-1 do
    mnuSpeed.Items[i].Checked := (mnuSpeed.Items[i] = Sender);

  FFirstNow := now;
end;

procedure TMainForm.mnuTrayClick(sender: TObject);
begin
{$ifdef use_tray_icon}
 {$ifdef fpc}
  Hide;
  FTrayIcon.Show;
 {$else}
  FTrayIcon.Active := true;
  Application.Minimize;
  ShowWindow(Application.Handle, SW_HIDE);
 {$endif}
{$endif}
end;

procedure TMainForm.mnuUTCClick(Sender: TObject);
var
  bias: TDateTime;
begin
  if frmUTC = nil then
    frmUTC := TfrmUTC.Create(Application);
  bias := TimeZoneBias / (60*24);
  frmUTC.Date := FStartTime + (now - FFirstNow) + bias;
  if frmUTC.ShowModal = mrOk then begin
    FStartTime := frmUTC.Date - (now - FFirstNow) - bias;
    UpdateLayout;
    if frmMoreData = nil then
      frmMoreData := TfrmMoreData.Create(Application);
    frmMoreData.StartTime := FStartTime;
  end;
end;

procedure TMainForm.SelectLanguage(ALang: string; AUpdateSize:Boolean);
var
  s: String;
  i, j: Integer;
  p: Integer;
  {$ifdef fpc}
  fn: String;
  langdir: String;
  langfile: String;
  {$endif}
begin
  Lang := '';
  for i:=1 to Length(ALang) do begin
    if ALang[i] = '&' then continue;
    Lang := Lang + lowercase(ALang[i]);
  end;

  // Update formatsettings (for month names etc)
  GetFormatSettingsFromLangCode(Lang, LocalFormatSettings);

  // Translate strings
 {$ifdef fpc}
  langdir := IncludeTrailingPathDelimiter(ExtractFilepath(Application.Exename) + LANGUAGE_DIR);
  langfile := Format('%s.%s.po', [
    ChangeFileExt(ExtractFileName(Application.ExeName), ''), Lang
  ]);
  fn := langdir + langfile;
  Translations.TranslateResourceStrings(fn);
  //fn := langdir + 'lclstrconsts.' + Lang + '.po';
  // Translations.TranslateResourceStrings(fn);
 {$else}
  UseLanguage(Lang);
  if not FTranslated then
    TranslateComponent(self)
  else
    RetranslateComponent(self);
  FTranslated := true;
 {$endif}

  // Apply strings to form and update layout
  UpdateStrings;
  UpdateValues;
  UpdateLayout;

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

{$ifdef use_tray_icon}
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
{$endif}

procedure TMainForm.TimerTimer(Sender: TObject);
begin
  UpdateValues;
end;

procedure TMainForm.UpdateLayout;
const
  OFFSET = 8;
  MOON_SIZE = 80;
  ROW_DISTANCE = 2;
  BLOCK_DISTANCE = 8;
var
  i: integer;
  y: Integer;
  labelPos, valuePos: Integer;
  labelWidth: Integer;
  valueWidth_Moon: Integer;
  valueWidth_NoMoon: Integer;
  valueWidth_Times: Integer;
  lunationPos: Integer;
  lunationLabelWidth: Integer;
  lunationValueWidth: Integer;
  w, h: Integer;
begin
  // Calc max width of first column and lunation columns
  labelWidth := 0;
  lunationLabelWidth := 0;
  lunationValueWidth := 0;
  for i:=0 to ControlCount - 1 do
    case Controls[i].Tag of
      1: labelWidth := Max(labelWidth, Controls[i].Width); // labels in 1st column
      5: lunationLabelWidth := Max(lunationLabelWidth, Controls[i].Width);
      6: lunationValueWidth := max(lunationValueWidth, Controls[i].Width);
    end;

  // Reposition first value column, get offset and width for the rest
  labelPos := OFFSET;
  valuePos := labelPos + labelWidth + OFFSET;
  valueWidth_Moon := 0;
  valueWidth_NoMoon := 0;
  valueWidth_Times := 0;
  for i:=0 to ControlCount - 1 do
    case Controls[i].Tag of
      1: Controls[i].Left := labelPos;
      2: begin
           Controls[i].Left := valuePos;
           valueWidth_Moon := Max(valueWidth_Moon, Controls[i].Width);
         end;
      3: begin
           Controls[i].Left := valuePos;
           valueWidth_NoMoon := Max(valueWidth_NoMoon, Controls[i].Width);
         end;
      4: begin
           Controls[i].Left := valuePos;
           valueWidth_Times := Max(valueWidth_Times, Controls[i].Width);
         end;
      5: lunationLabelWidth := max(lunationLabelWidth, Controls[i].Width);
      6: lunationValueWidth := max(lunationValueWidth, Controls[i].Width);
    end;

  // Position the Lunation labels and values
  lunationPos := valuePos + valueWidth_Times + 2*OFFSET;
  for i := 0 to ControlCount-1 do
    case Controls[i].Tag of
      5: Controls[i].Left := lunationPos;
      6: Controls[i].Left := lunationPos + OFFSET + lunationLabelWidth;
    end;

  y := 4;
  ArrangeInRow(y, ROW_DISTANCE, [lblJulian, valJulian]);
  ArrangeInRow(y, ROW_DISTANCE, [lblUTC, valUTC]);
  ArrangeInRow(y, ROW_DISTANCE, [lblLocal, valLocal]);
  inc(y, BLOCK_DISTANCE);
  ArrangeInRow(y, ROW_DISTANCE, [lblAgeOfMoon, valAgeOfMoon]);
  ArrangeInRow(y, ROW_DISTANCE, [lblPhase, valPhase]);
  ArrangeInRow(y, ROW_DISTANCE, [lblMoonDistance, valMoonDistance]);
  ArrangeInRow(y, ROW_DISTANCE, [lblMoonSubtend, valMoonSubtend]);
  inc(y, BLOCK_DISTANCE);
  ArrangeInRow(y, ROW_DISTANCE, [lblSunDistance, valSunDistance]);
  ArrangeInRow(y, ROW_DISTANCE, [lblSunSubtend, valSunSubtend]);
  inc(y, BLOCK_DISTANCE);
  ArrangeInRow(y, ROW_DISTANCE, [lblLastNew, valNewMoon, lblLastLunation, valLastLunation]);
  ArrangeInRow(y, ROW_DISTANCE, [lblFirstQuart, valFirstQuart]);
  ArrangeInRow(y, ROW_DISTANCE, [lblFullMoon, valFullMoon]);
  ArrangeInRow(y, ROW_DISTANCE, [lblLastQuart, valLastQuart]);
  ArrangeInRow(y, ROW_DISTANCE, [lblNextNewMoon, valNextNewMoon, lblNextLunation, valNextLunation]);

  // Form size
  labelPos := labelPos + OFFSET + labelWidth;  // badly named: it is the x where the values start
  w := Max(Max(
        labelPos + valueWidth_Moon + 2*OFFSET + MOON_SIZE,
        labelPos + valueWidth_NoMoon),
        lunationPos + lunationValueWidth)
    + OFFSET;
  h := lblNextNewMoon.Top + lblNextNewMoon.Height + OFFSET;
  ClientWidth := w;
  ClientHeight := h;

  // Moon icon
  Moon.Top := LblJulian.Top;
  Moon.Left := Width - MOON_SIZE - Moon.Top;
end;

procedure TMainForm.UpdateStrings;
var
  s: String;
begin
  Caption := SMoontool;
  lblAgeOfMoon.Caption := SAgeOfMoon;
  s := SAgeOfMoon;
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
  mnuEclipses.Caption := SMenuEclipses;
  mnuHelp.Caption := SMenuHelp;
  mnuHelpItem.Caption := SMenuHelpItem;
  mnuMenuAbout.Caption := SMenuAbout;
  mnuHelpTimezones.Caption := SMenuTimeZones;
  Application.Title := Caption;
end;

procedure TMainForm.UpdateValues;
var
  jetzt: TDateTime;
  temp: TDateTime;
  dist,age: extended;
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
    else raise Exception.Create('Invalid speed specification.');
  end;
  if FSpeed = 0 then
    valLocal.Caption := DateToString(jetzt)
  else
    valLocal.Caption := '';

  jetzt := jetzt + bias/(60*24);
  valUTC.Caption := DateToString(jetzt);
  valJulian.Caption := Format('%.5n', [Julian_Date(jetzt)], LocalFormatSettings);

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
    lblFullMoon.Hint := GetMoonName(TMoonName(lunation_value));
    valLastQuart.Caption := UTCDateString(Next_Phase(temp, LastQuarter));
    valNextNewMoon.Caption := UTCDateString(Next_Phase(jetzt, NewMoon));
    valLastLunation.Caption := IntToStr(lunation_value);
    valNextLunation.Caption := IntToStr(lunation_value+1);
  except
    { ignore exception which might be raised if too close to October 1582 }
  end;

  dist := Moon_Distance(jetzt);
  valMoonDistance.Caption := Format('%.0n %s = %.1f %s', [
    dist, SKilometers, dist/EARTH_RADIUS, SEarthRadii
    ], LocalFormatSettings);

  dist := Sun_Distance(jetzt);
  valSunDistance.Caption := Format('%.0n %s = %.3f %s', [
    dist*AU, SKilometers, dist, SAstronomicalUnits
    ], LocalFormatSettings);

  age := AgeOfMoonWalker(jetzt);
  DecodeTime(age, h, m, sec, ms);
  valAgeOfMoon.Caption := Format(SAgeOfMoonValue, [trunc(age), h, m]);

  new_phase := round(Current_Phase(jetzt) * 100);
  valPhase.Caption := IntToStr(new_phase) + '% ' + SPhaseHint;

  valMoonSubtend.Caption := Format('%.4f%s', [Moon_Diameter(jetzt)/3600, DEG_SYMBOL], LocalFormatSettings);
  valSunSubtend.Caption := Format('%.4f%s', [Sun_Diameter(jetzt)/3600, DEG_SYMBOL], LocalFormatSettings);

  if new_phase <> FLastPhaseValue then begin
    Moon.Date := jetzt;
    Application.Icon := Moon.Icon;
    {$ifndef fpc}
    InvalidateRect(Application.Handle, nil, true);
    {$endif}
    FLastPhaseValue := new_phase;
    {$ifdef use_tray_icon}
    if FTrayicon <> NIL then begin
      FTrayicon.Icon := Moon.icon;
      {$ifdef fpc}
      FTrayicon.Hint := IntToStr(new_phase) + '%';
      {$else}
      FTrayIcon.ToolTip := IntToStr(new_phase) + '%';
      {$endif}
    end;
    {$endif}
  end;
end;


initialization
  MOONTOOL_INIFILE := ExtractFilePath(ParamStr(0)) + MOONTOOL_INIFILE;

end.

