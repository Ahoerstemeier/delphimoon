unit mtJulianForm;

interface

uses
{$ifdef fpc}
  LCLType, LCLIntf, LMessages,
{$else}
  Windows, Messages, Consts,
{$endif}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,
  moon, mtMain;

type

  { TfrmJulian }

  TfrmJulian = class(TForm)
    lblJulian: TLabel;
    edtJulian: TEdit;
    grpUTC: TGroupBox;
    lblUTC: TLabel;
    btnNow: TButton;
    btnOK: TButton;
    btnCancel: TButton;
    procedure btnNowClick(Sender: TObject);
    procedure edtJulianEditingDone(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FDate: TDateTime;
    procedure SetDate(AValue: TDateTime);
    procedure UpdateLayout;
    procedure UpdateStrings;
    procedure UpdateValues;
  public
    property Date: TDateTime read FDate write SetDate;
  end;

var
  frmJulian: TfrmJulian;


implementation

uses
  mtStrings, mtConst, mtUtils;

{$ifdef fpc}
  {$R *.lfm}
{$else}
  {$R *.dfm}
{$endif}


{ TfrmJulian }

procedure TfrmJulian.btnNowClick(Sender: TObject);
begin
  SetDate(now);
end;

procedure TfrmJulian.edtJulianEditingDone(Sender: TObject);
var
  j_date: extended;
  valid: boolean;
  res: Integer;
  fs: TFormatSettings;
begin
  val(edtJulian.Text, j_date, res);
  if (res = 0) or TryStrToFloat(edtJulian.Text, j_date) then
  begin
    SetDate(Delphi_Date(j_date));
    valid := true;
  end else begin
    valid := false;
    lblUTC.Caption := SInvalid;
    FDate := 0;
  end;
  btnOK.Enabled := valid;
end;

procedure TfrmJulian.FormCreate(Sender: TObject);
begin
  HelpContext := HC_SET_JULIAN;
end;

procedure TfrmJulian.FormShow(Sender: TObject);
var
  L, T: Integer;
begin
  UpdateStrings;
  UpdateValues;
  L := Application.MainForm.Left + (Application.MainForm.Width - Width) div 2;
  T := Application.MainForm.Top + (Application.MainForm.Height - Height) div 2;
  SetBounds(L, T, Width, Height);
end;

procedure TfrmJulian.SetDate(AValue: TDateTime);
begin
  FDate := AValue;
  UpdateValues;
end;

procedure TfrmJulian.UpdateLayout;
begin
  edtJulian.Left := lblJulian.Left + lblJulian.Width + 16;
  edtJulian.Width := grpUTC.Width - edtJulian.Left;
end;

procedure TfrmJulian.UpdateStrings;
begin
  lblJulian.Caption := SJulianDate;
  Caption := SSetJulian;
  btnNow.Caption := SNow;
  grpUTC.Caption := SUTC;
  btnOK.Caption := SOKButton;
  btnCancel.Caption := SCancelButton;

  UpdateLayout;
end;

procedure TfrmJulian.UpdateValues;
begin
  edtJulian.Text := FloatToStrF(Julian_date(FDate), ffFixed, 12, 5);
  lblUTC.Caption := DateToString(FDate);
end;

end.

