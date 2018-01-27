unit mtLocation;

interface

uses
{$ifdef fpc}
  LCLIntf, LCLType, LMessages,
{$else}
  Windows, Messages, consts,
{$endif}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, Buttons,
  ExtCtrls, inifiles;

type
  TLocation = class(TObject)
    Name: string;
    Latitude, Longitude: extended;
    Height: integer;
  end;

  { TfrmLocations }

  TfrmLocations = class(TForm)
    Bevel1: TBevel;
    cbxLongSign: TComboBox;
    cbxLatSign: TComboBox;
    edtLatDeg: TEdit;
    edtLatMin: TEdit;
    edtLatSec: TEdit;
    edtLongDeg: TEdit;
    edtLongMin: TEdit;
    edtLongSec: TEdit;
    edtAltitude: TEdit;
    lblAltitudeUnit: TLabel;
    lblLatMin: TLabel;
    lblLongMin: TLabel;
    lblName: TLabel;
    lblLatDeg: TLabel;
    lblLongSec: TLabel;
    lblLatSec: TLabel;
    lblLongDeg: TLabel;
    lbxLocations: TListBox;
    btnUp: TSpeedButton;
    btnDown: TSpeedButton;
    btnNew: TSpeedButton;
    btnDel: TSpeedButton;
    edtName: TEdit;
    lblLongitude: TLabel;
    lblLatitude: TLabel;
    lblAltitude: TLabel;
    btnOK: TButton;
    btnCancel: TButton;
    btnImport: TButton;
    dlg: TOpenDialog;
    procedure btnDelClick(Sender: TObject);
    procedure btnDownClick(Sender: TObject);
    procedure btnImportClick(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnUpClick(Sender: TObject);
    procedure edtChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lbxLocationsClick(Sender: TObject);
  private
    FLocations: TList;
    FChanging: Integer;
    procedure UpdateLayout;
    procedure UpdateStrings;
  end;

procedure LoadLocations(const AFilename: string; var ALocations: TList;
  var ACurrent: integer);

procedure LoadSTSPlusCityFile(const AFileName: String; var ALocations: TList);

procedure SaveLocations(const Afilename: string; ALocations: TList;
  ACurrent: integer);

procedure FreeLocations(var ALocations: TList);

var
  frmLocations: TfrmLocations;

implementation

uses
  Math,
  mtStrings, mtConst;

{$ifdef fpc}
  {$R *.lfm}
{$else}
  {$R *.dfm}
{$endif}

procedure LoadLocations(const AFilename: string;
  var ALocations:TList; var ACurrent:integer);
var
  iniFile : TCustomIniFile;
  h: TLocation;
  s: string;
  nr: integer;
  nam: String;
  longitude, latitude: Extended;
  elev: Integer;
begin
  if ALocations = nil then
    ALocations := TList.Create;

  iniFile := TMemIniFile.Create(AFilename);
  try
    nr := 0;
    repeat
      s := 'Location' + IntToStr(nr);
      nam := iniFile.ReadString(s, 'Name', '');
      if nam = '' then
        break;
      latitude := iniFile.ReadInteger(s, 'Latitude', 0)/3600;
      longitude := inifile.ReadInteger(s, 'Longitude', 0)/3600;
      elev := iniFile.ReadInteger(s, 'Elevation', 0);
      h := TLocation.create;
      h.Name := nam;
      h.Longitude := longitude;
      h.Latitude := latitude;
      h.Height := elev;
      ALocations.Add(h);
      inc(nr);
    until false;
    ACurrent := IniFile.ReadInteger('Current', 'Index', 0);
    if ALocations.Count = 0 then ACurrent := -1;
  finally
    inifile.Free;
  end;
end;

procedure SaveLocations(const AFilename: string;
  ALocations: TList; ACurrent:integer);
var
  iniFile : TCustomIniFile;
  i, nr: integer;
  s: String;
  loc: TLocation;
begin
  if ALocations = NIL then
    exit;

  iniFile := TMemIniFile.Create(AFilename);
  try
    nr:=0;
    for i := 0 to ALocations.Count - 1 do begin
      if (ALocations[i] <> nil) and
         (TObject(ALocations[i]) is TLocation) then
      begin
        loc := TLocation(ALocations[i]);
        s := 'Location' + IntToStr(nr);
        iniFile.WriteString(s, 'Name', loc.Name);
        iniFile.WriteInteger(s, 'Longitude', round(loc.Longitude*3600));
        iniFile.WriteInteger(s, 'Latitude', round(loc.Latitude*3600));
        iniFile.WriteInteger(s, 'Elevation', loc.Height);
        inc(nr);
      end;
    end;
    Inifile.WriteInteger('Current', 'Index', ACurrent);
  finally
    Inifile.Free;
  end;
end;

procedure FreeLocations(var ALocations: TList);
var
  i: Integer;
begin
  if ALocations = nil then
    exit;
  for i:=ALocations.Count-1 downto 0 do begin
    TObject(ALocations[i]).Free;
    ALocations.Delete(i);
  end;
  FreeAndNil(ALocations);
end;

{ Syntax of STSplus city file:
  - "Name"
  - longitude (degree, + = east)
  - latitude (degree, + = north)
  - altitude (m)
}
procedure LoadSTSPlusCityFile(const AFileName: String; var ALocations: TList);
var
  L, line: TStrings;
  longitude, latitude, elev: Extended;
  res: Integer;
  i: Integer;
  h: TLocation;
  s: String;
begin
  if ALocations = nil then
    ALocations := TList.Create;

  L := TStringList.Create;
  try
    L.LoadFromFile(AFileName);
    line := TStringList.Create;
    try
      for i:= 0 to L.Count-1 do begin
        s := L[i];
        line.CommaText := L[i];
        if line.Count < 4 then
          raise Exception.CreateFmt('4 columns expected in line %d.', [i+1]);
        val(line[1], longitude, res);
        if res <> 0 then
          raise Exception.CreateFmt('Numeric data expected in line %d', [i+1]);
        val(line[2], latitude, res);
        if res <> 0 then
          raise Exception.CreateFmt('Numeric data expected in line %d', [i+1]);
        val(line[3], elev, res);
        if res <> 0 then
          raise Exception.CreateFmt('Numeric data expected in line %d', [i+1]);
        h := TLocation.Create;
        h.Name := line[0];
        h.Longitude := -longitude;
        h.Latitude := latitude;
        h.Height := round(elev);
        ALocations.Add(h);
      end;
    finally
      line.Free;
    end;
  finally
    L.Free;
  end;
end;

procedure FloatToDMS(AValue: extended; out ADegs, AMins, ASecs: Integer);
var
  isNeg: Boolean;
begin
  isNeg := AValue < 0;
  AValue := round(abs(AValue)*3600);
  ASecs := round(AValue) mod 60;
  AMins := round((AValue - ASecs)/60) mod 60;
  ADegs := round((AValue - ASecs - AMins*60)/3600);
  if isNeg then ADegs := -ADegs;
end;


{ TfrmLocations }

procedure TfrmLocations.btnDelClick(Sender: TObject);
var
  p: integer;
begin
  p := lbxLocations.ItemIndex;
  if p > -1 then begin
    TObject(FLocations[p]).free;
    FLocations.Delete(p);
    lbxLocations.Items.Delete(p);
    lbxLocations.ItemIndex := p-1;
    lbxlocationsClick(nil);
  end;
end;

procedure TfrmLocations.btnDownClick(Sender: TObject);
var
  p: integer;
begin
  p := lbxLocations.ItemIndex;
  if (p > 0) and (p < lbxLocations.Items.Count-1) then begin
    FLocations.Move(p, p+1);
    lbxLocations.Items.Move(p, p+1);
    lbxLocations.ItemIndex := p + 1;
    lbxLocationsClick(nil);
  end;
end;

procedure TfrmLocations.btnImportClick(Sender: TObject);
var
  i: Integer;
  current: String;
begin
  if dlg.execute then
    case dlg.filterindex of
      1:  begin
            Screen.Cursor := crHourglass;
            try
              if lbxLocations.ItemIndex = -1 then
                current := ''
              else
                current := lbxLocations.Items[lbxLocations.ItemIndex];
              FreeLocations(FLocations);
              LoadSTSPlusCityFile(dlg.FileName, FLocations);
              if FLocations <> nil then begin
                lbxLocations.Items.BeginUpdate;
                try
                  lbxLocations.Items.Clear;
                  for i:=0 to FLocations.Count-1 do
                    lbxLocations.Items.Add(TLocation(FLocations[i]).Name);
                finally
                  lbxLocations.Items.EndUpdate;
                  if current <> '' then
                    lbxLocations.ItemIndex := lbxLocations.Items.IndexOf(current);
                end;
              end;
            finally
              Screen.Cursor := crDefault;
            end;
          end;
    end;
end;

procedure TfrmLocations.btnNewClick(Sender: TObject);
var
  p: integer;
  h: TLocation;
begin
  h := TLocation.Create;
  h.Name := SNewLocation;
  p := FLocations.Add(h);
  lbxLocations.Items.Add(h.Name);
  lbxLocations.ItemIndex := p;
  lbxLocationsClick(nil);
end;

procedure TfrmLocations.btnOKClick(Sender: TObject);
begin
  SaveLocations(MOONTOOL_INIFILE, FLocations, lbxLocations.ItemIndex);
end;

procedure TfrmLocations.btnUpClick(Sender: TObject);
var
  p: integer;
begin
  p := lbxLocations.ItemIndex;
  if (p > 0) then begin
    FLocations.Move(p, p-1);
    lbxLocations.Items.Move(p, p-1);
    lbxLocations.ItemIndex := p - 1;
    lbxLocationsClick(nil);
  end;
end;

procedure TfrmLocations.edtChange(Sender: TObject);
const
  SGN: Array[0..1] of Integer = (+1, -1);
var
  p: integer;
  h: TLocation;
  d,m,s: Integer;
begin
  if (FChanging <> 0) then
    exit;
  p := lbxLocations.ItemIndex;
  if p > -1 then begin
    h := TLocation(FLocations[p]);
    h.Name := edtName.Text;

    if TryStrToInt(edtLongDeg.Text, d) and TryStrToInt(edtLongMin.Text, m) and
       TryStrToInt(edtLongSec.Text, s) and (cbxLongSign.ItemIndex > -1)
    then
      h.Longitude := (d + m/60 + s/3600) * SGN[cbxLongSign.ItemIndex]
    else
      raise Exception.Create('Invalid number in longitude');

    if TryStrToInt(edtLatDeg.Text, d) and TryStrToInt(edtLatMin.Text, m) and
       TryStrToInt(edtLatSec.Text, s) and (cbxLatSign.ItemIndex > -1)
    then
      h.Latitude := (d + m/60 + s/3600) * SGN[cbxLatSign.ItemIndex]
    else
      raise Exception.Create('Invalid number in latitude');

    if TryStrToInt(trim(edtAltitude.Text), d) then
      h.Height := d
    else
      raise Exception.Create('Invalid number in altitude');

    lbxLocations.Items[p] := h.Name;
    lbxLocations.ItemIndex := p;
  end;
end;

procedure TfrmLocations.lbxLocationsClick(Sender: TObject);
var
  h: TLocation;
  d, m, s:Integer;
begin
  if lbxLocations.ItemIndex > -1 then begin
    inc(FChanging);
    h := TLocation(FLocations.Items[lbxLocations.ItemIndex]);
    try
      edtName.Text := h.Name;

      FloatToDMS(abs(h.Longitude), d, m, s);
      edtLongDeg.Text := IntToStr(d);
      edtLongMin.Text := IntToStr(m);
      edtLongSec.Text := IntToStr(s);
      if h.Longitude < 0 then cbxLongSign.ItemIndex := 1
        else cbxLongSign.ItemIndex := 0;

      FloatToDMS(abs(h.Latitude), d, m, s);
      edtLatDeg.Text := IntToStr(d);
      edtLatMin.Text := IntToStr(m);
      edtLatSec.Text := IntToStr(s);
      if h.Latitude < 0 then cbxLatSign.ItemIndex := 1
        else cbxLatSign.ItemIndex := 0;

      edtAltitude.Text := IntToStr(h.Height);

      btnUp.Enabled := true;
    finally
      dec(FChanging);
    end;
  end else
  begin
    edtName.Text := '';
    edtLongDeg.Text := '';
    edtLongMin.Text := '';
    edtLongSec.Text := '';
    edtLatDeg.Text := '';
    edtLatMin.Text := '';
    edtLatSec.text := '';
    edtAltitude.Text := '';
    btnUp.enabled := false;
  end;
  btnDown.Enabled := (lbxLocations.ItemIndex > 0) and
                     (lbxLocations.ItemIndex < lbxLocations.Items.Count - 1)
end;

procedure TfrmLocations.FormCreate(Sender: TObject);
begin
  HelpContext := HC_LOCATIONS;
end;

procedure TfrmLocations.FormShow(Sender: TObject);
var
  current, i: integer;
  L, T: Integer;
begin
  UpdateStrings;
  UpdateLayout;
  L := Application.MainForm.Left + (Application.MainForm.Width - Width) div 2;
  T := Application.MainForm.Top + (Application.MainForm.Height - Height) div 2;
  SetBounds(L, T, Width, Height);

  FreeLocations(FLocations);
  LoadLocations(MOONTOOL_INIFILE, FLocations, current);
  lbxLocations.Items.BeginUpdate;
  try
    lbxLocations.Items.Clear;
    if FLocations <> nil then
      for i:=0 to FLocations.Count-1 do
        lbxLocations.Items.Add(TLocation(FLocations[i]).Name);
  finally
    lbxLocations.Items.EndUpdate;
  end;
  lbxLocations.ItemIndex := current;
  lbxLocationsClick(nil);
end;

procedure TfrmLocations.Updatelayout;
const
  DISTANCE = 8;
  BTN_DISTANCE = 4;
var
  w: Integer;
  i: Integer;
begin
  w := Max(Max(lblLongitude.Width, lblLatitude.Width), lblAltitude.Width);

  lblName.Left := lbxLocations.Left;
  lblLongitude.Left := lbxLocations.Left;
  lblLatitude.Left := lbxLocations.Left;
  lblAltitude.Left := lbxLocations.Left;

  edtName.Left := lblName.Left + DISTANCE + w;
  edtLongDeg.Left := edtName.Left;
  edtLatDeg.Left := edtName.Left;
  edtAltitude.Left := edtName.Left;

  lblLongDeg.Left := edtLongDeg.Left + edtLongDeg.Width + DISTANCE;
  lblLatDeg.Left := lblLongDeg.Left;
  lblAltitudeUnit.Left := lblLongDeg.Left;

  edtLongMin.Left := lblLongDeg.Left + lblLongDeg.Width + DISTANCE;
  edtLatMin.Left := edtLongMin.Left;

  lblLongMin.Left := edtLongMin.Left + edtLongMin.Width + DISTANCE;
  lblLatMin.Left := lblLongMin.Left;

  edtLongSec.Left := lblLongMin.Left + lblLongMin.Width + DISTANCE;
  edtLatSec.Left := edtLongSec.Left;

  lblLongSec.Left := edtLongSec.Left + edtLongSec.Width + DISTANCE;
  lblLatSec.Left := lblLongSec.Left;

  cbxLongSign.Left := lblLongSec.Left + lblLongSec.Width + DISTANCE;
  cbxLatSign.Left := cbxLongSign.Left;

  edtName.Width := cbxLatSign.Left + cbxLatSign.Width - edtName.Left;

  btnUp.Left := edtName.Left + edtName.Width - btnUp.Width;
  btnDown.Left := btnUp.Left;
  btnNew.Left := btnUp.Left;
  btnDel.Left := btnUp.Left;

  lbxLocations.Width := btnUp.Left - BTN_DISTANCE - lbxLocations.Left;

  btnImport.Left := lbxLocations.Left;
  btnCancel.Left := edtName.Left + edtName.Width - btnCancel.Width;
  btnOK.Left := btnCancel.Left - DISTANCE - btnOK.Width;

  ClientWidth := edtName.Left + edtName.Width + lblName.Left;

  // Vertically Center labels within their FocusControls
  for i:=0 to ControlCount-1 do
    if Controls[i] is TLabel then
      with TLabel(Controls[i]) do
        if FocusControl <> nil then
          Top := FocusControl.Top + (FocusControl.Height - Height) div 2;
end;

procedure TfrmLocations.UpdateStrings;
begin
  Caption := SEditLocation;
  btnOK.Caption := SOKButton;
  btnCancel.Caption := SCancelButton;
  lblLatitude.Caption := SLatitude;
  lblLongitude.Caption := SLongitude;
  lblAltitude.Caption := SAltitude;
  lblLongDeg.Caption := SDegreeAbbrev;
  lblLatDeg.Caption := SDegreeAbbrev;
  lblLongMin.Caption := SMinAbbrev;
  lblLatMin.Caption := SMinAbbrev;
  lblLongSec.Caption := SSecAbbrev;
  lblLatSec.Caption := SSecAbbrev;
  edtLatDeg.Hint := SLatitudeHint;
  edtLatMin.Hint := SLatitudeHint;
  edtLatSec.Hint := SLatitudeHint;
  cbxLatSign.Hint := SLatitudeHint;
  edtLongDeg.Hint := SLongitudeHint;
  edtLongMin.Hint := SLongitudeHint;
  edtLongSec.Hint := SLongitudeHint;
  cbxLongSign.Hint := SLongitudeHint;
  edtAltitude.Hint := SAltitudeHint;
  btnUp.Hint := SMoveUp;
  btnDown.Hint := SMoveDown;
  btnDel.Hint := SDelete;
  btnNew.Hint := SNewLocation;
end;

end.

