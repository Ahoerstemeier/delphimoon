unit mtUTCForm;

interface

uses
{$ifdef fpc}
  LCLType, LMessages,
{$else}
 {$ifdef ver80 }
  winprocs, wintypes,
 {$else }
  Windows,
 {$endif }
  Messages, Consts,
{$endif}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,
  moon, mtMain;

type
  TfrmUTC = class(TForm)
    grpUTC: TGroupBox;
    edtYear: TEdit;
    lblYear: TLabel;
    cbxMonth: TComboBox;
    lblMonth: TLabel;
    edtDay: TEdit;
    lblDay: TLabel;
    edtHour: TEdit;
    edtMin: TEdit;
    edtSec: TEdit;
    lblHour: TLabel;
    lblSec: TLabel;
    lblMin: TLabel;
    grpJulian: TGroupBox;
    lblJulian: TLabel;
    btnNow: TButton;
    btnOK: TButton;
    btnCancel: TButton;
    procedure anyChange(Sender: TObject);
    procedure btnNowClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FDate: TDateTime;
    procedure SetDate(AValue: TDateTime);
    procedure UpdateControls;
    procedure UpdateStrings;
  public
    property Date: TDateTime read FDate write SetDate;
  end;

var
  frmUTC: TfrmUTC;


implementation

uses
{$ifdef fpc}
  mtStrings,
{$endif}
  mtConst, mtUtils;

{$ifdef fpc}
  {$R *.lfm}
{$else}
  {$R *.lfm}
{$endif}


{ TfrmUTC }

procedure TfrmUTC.AnyChange(Sender: TObject);
var
  valid: boolean;
  y, m, d, h,s: Integer;
begin
  valid := true;

  if TryStrToInt(edtYear.Text, y) and TryStrToInt(edtDay.Text, d) then
    try
      FDate := EncodeDateCorrect(y, cbxMonth.ItemIndex+1, d);
      valid := true;
    except
      valid := false;
    end;

  if valid and TryStrToInt(edtHour.Text, h) and TryStrToInt(edtMin.text, m) and
    TryStrToInt(edtSec.Text, s)
  then
    try
      FDate := FDate + Encodetime(h, m, s, 0);
      valid := true;
    except
      valid := false;
    end;

  if valid then
    lblJulian.Caption := FloatToStrF(Julian_date(FDate), ffFixed, 12, 5)
  else
    lblJulian.Caption := SInvalid;

  btnOK.Enabled := valid;
end;

procedure TfrmUTC.btnNowClick(Sender: TObject);
begin
  SetDate(now);
end;

procedure TfrmUTC.FormCreate(Sender: TObject);
begin
  HelpContext := HC_SET_UTC;
  cbxMonth.DropdownCount := DROPDOWN_COUNT;
end;

procedure TfrmUTC.FormShow(Sender: TObject);
begin
  UpdateStrings;
  UpdateControls;
end;

procedure TfrmUTC.SetDate(AValue: TDateTime);
begin
  FDate := AValue;
  UpdateControls;
end;

procedure TfrmUTC.UpdateControls;
var
  y,m,d: word;
  h,min,s,ms: word;
  dt: TdateTime;
begin
  dt := FalsifyTDateTime(FDate);
  DecodeDate(dt, y, m, d);
  DecodeTime(dt, h, min, s, ms);
  edtYear.Text := IntToStr(y);
  edtDay.Text := IntToStr(d);
  cbxMonth.ItemIndex := m-1;
  edtHour.Text := IntToStr(h);
  edtMin.Text := IntTostr(min);
  edtSec.Text := IntTostr(s);
end;

procedure TfrmUTC.UpdateStrings;
var
  i: integer;
begin
  Caption := SSetUTC;
  grpJulian.Caption := SJulianDate;
  btnNow.Caption := SNow;
  grpUTC.Caption := SUTC;
  btnOK.Caption := SOKButton;
  btnCancel.Caption := SCancelButton;
  lblYear.Caption := SYear;
  lblMonth.Caption := SMonth;
  lblDay.Caption := SDay;
  lblHour.Caption := SHour;
  lblMin.Caption := SMinute;
  lblSec.Caption := SSecond;
  cbxMonth.Items.Clear;
  for i:=1 to 12 do
    cbxMonth.Items.Add(LocalFormatSettings.LongMonthNames[i]);
end;

end.

