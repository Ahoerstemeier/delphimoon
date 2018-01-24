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
    lbxLocation: TListBox;
    btnUp: TSpeedButton;
    btnDown: TSpeedButton;
    btnNew: TSpeedButton;
    btnDel: TSpeedButton;
    edtName: TEdit;
    lbl_Longitude: TLabel;
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
    procedure lbxLocationClick(Sender: TObject);
  private
    FLocations: TList;
    FChanging: Integer;
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
{$ifdef fpc}
  mtStrings,
{$endif}
  mtConst;

{$ifdef fpc}
  {$R *.lfm}
{$else}
  {$R *.lfm}
  {$i moontool.inc }
{$endif}

procedure LoadLocations(const AFilename: string;
  var ALocations:TList; var ACurrent:integer);
var
  iniFile : TIniFile;
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
  iniFile : TIniFile;
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

function StrToDegree(AValue: string): extended;
var
  p, sgn, len: integer;
  sd, sm, ss: string;
  fs: TFormatSettings;
  d, m, s: Double;
begin
  AValue := trim(AValue);

  len := Length(AValue);
  if len = 0 then
    raise Exception.Create('StrToDegree: Empty string');

  fs := DefaultFormatSettings;
  if fs.DecimalSeparator = ',' then
    fs.DecimalSeparator := '.';

  if AValue[1] = '-' then begin
    sgn := -1;
    Delete(AValue, 1, 1);
  end else
    sgn := +1;

  p := pos(':', AValue);
  if p = 0 then begin
    // fractional coordinates
    if TryStrToFloat(trim(AValue), Result) then
      exit;
    if TryStrToFloat(trim(AValue), Result, fs) then
      exit;
    raise Exception.Create('Invalid number passed to StrToDegree');
  end;

  sm := '';
  ss := '';
  d := 0;
  m := 0;
  s := 0;

  // degree part
  sd := trim(Copy(AValue, 1, p-1));
  AValue := trim(Copy(AValue, p+1, MaxInt));
  if not TryStrToFloat(sd, d) then
    d := StrToFloat(sd, fs);

  // minute and second parts
  p := pos(':', AValue);
  if p > 0 then
  begin
    sm := Copy(AValue, 1, p-1);
    ss := trim(Copy(AValue, p+1, MaxInt));
  end else begin
    sm := AValue;
    ss := '';
  end;

  if (sm <> '') and not TryStrToFloat(sm, m) then begin
    m := StrToFloat(sm, fs);
    if (m < 0) or (m >= 60) then
      raise Exception.Create('Invalid number in StrToDegree');
  end;
  if (ss <> '') and not TryStrToFloat(ss, s) then begin
    s := StrToFloat(ss, fs);
    if (s < 0) or (s >= 60) then
      raise Exception.Create('Invalid number in StrToDegree');
  end;

  Result := (d + m/60 + s /3600) * sgn;
end;

procedure TfrmLocations.lbxLocationClick(Sender: TObject);
var
  h: TLocation;
  d, m, s:Integer;
begin
  if lbxLocation.ItemIndex > -1 then begin
    inc(FChanging);
    h := TLocation(FLocations.Items[lbxLocation.ItemIndex]);
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
  btnDown.Enabled := (lbxLocation.ItemIndex > 0) and
                     (lbxLocation.ItemIndex < lbxLocation.Items.Count - 1)
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
  p := lbxLocation.ItemIndex;
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

    lbxLocation.Items[p] := h.Name;
    lbxLocation.ItemIndex := p;
  end;
end;

procedure TfrmLocations.btnDelClick(Sender: TObject);
var
  p: integer;
begin
  p := lbxLocation.ItemIndex;
  if p > -1 then begin
    TObject(FLocations[p]).free;
    FLocations.Delete(p);
    lbxLocation.Items.Delete(p);
    lbxLocation.ItemIndex := p-1;
    lbxlocationClick(nil);
  end;
end;

procedure TfrmLocations.btnUpClick(Sender: TObject);
var
  p: integer;
begin
  p := lbxLocation.ItemIndex;
  if (p > 0) then begin
    FLocations.Move(p, p-1);
    lbxLocation.Items.Move(p, p-1);
    lbxLocation.ItemIndex := p - 1;
    lbxlocationClick(nil);
  end;
end;

procedure TfrmLocations.btnDownClick(Sender: TObject);
var
  p: integer;
begin
  p := lbxLocation.ItemIndex;
  if (p > 0) and (p < lbxLocation.Items.Count-1) then begin
    FLocations.Move(p, p+1);
    lbxLocation.Items.Move(p, p+1);
    lbxLocation.ItemIndex := p + 1;
    lbxlocationClick(nil);
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
  lbxLocation.Items.Add(h.Name);
  lbxLocation.ItemIndex := p;
  lbxlocationClick(nil);
end;

procedure TfrmLocations.btnOKClick(Sender: TObject);
begin
  SaveLocations(MOONTOOL_INIFILE, FLocations, lbxLocation.ItemIndex);
end;

procedure TfrmLocations.FormShow(Sender: TObject);
var
  current, i: integer;
begin
  UpdateStrings;
  FreeLocations(FLocations);
  LoadLocations(MOONTOOL_INIFILE, FLocations, current);
  lbxLocation.Items.BeginUpdate;
  try
    lbxLocation.Items.Clear;
    if FLocations <> nil then
      for i:=0 to FLocations.Count-1 do
        lbxLocation.Items.Add(TLocation(FLocations[i]).Name);
  finally
    lbxLocation.Items.EndUpdate;
  end;
  lbxLocation.ItemIndex := current;
  lbxlocationClick(nil);
end;

procedure TfrmLocations.FormCreate(Sender: TObject);
begin
  HelpContext := HC_LOCATIONS;
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
              if lbxLocation.ItemIndex = -1 then
                current := ''
              else
                current := lbxLocation.Items[lbxLocation.ItemIndex];
              FreeLocations(FLocations);
              LoadSTSPlusCityFile(dlg.FileName, FLocations);
              if FLocations <> nil then begin
                lbxLocation.Items.BeginUpdate;
                try
                  lbxLocation.Items.Clear;
                  for i:=0 to FLocations.Count-1 do
                    lbxLocation.Items.Add(TLocation(FLocations[i]).Name);
                finally
                  lbxLocation.Items.EndUpdate;
                  if current <> '' then
                    lbxLocation.ItemIndex := lbxLocation.Items.IndexOf(current);
                end;
              end;
            finally
              Screen.Cursor := crDefault;
            end;
          end;
    end;
end;

procedure TfrmLocations.UpdateStrings;
begin
  Caption := SEditLocation;
  btnOK.Caption := SOKButton;
  btnCancel.Caption := SCancelButton;
  lblLatitude.Caption := SLatitude;
  lbl_Longitude.Caption := SLongitude;
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

