unit mdMain;

{$ifdef fpc}
 {$mode delphi}
{$endif}

interface

uses
 {$ifdef fpc}
  LCLIntf, LCLType, Calendar,
 {$else}
  Windows, Messages,
 {$endif}
  SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, mooncomp, ExtCtrls, ComCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Moon1: TMoon;
    ScrollBar1: TScrollBar;
    ScrollBar2: TScrollBar;
    RadioGroup1: TRadioGroup;
    ScrollBar3: TScrollBar;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    RadioGroup2: TRadioGroup;
    RadioGroup3: TRadioGroup;
    Panel1: TPanel;
    ColorDialog1: TColorDialog;
    cbTransparent: TCheckBox;
    procedure ScrollBar2Change(Sender: TObject);
    procedure ScrollBar1Change(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure ScrollBar3Change(Sender: TObject);
    procedure MonthCalendar1Click(Sender: TObject);
    procedure RadioGroup2Click(Sender: TObject);
    procedure RadioGroup3Click(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbTransparentClick(Sender: TObject);
  private
    { Private-Deklarationen }
    MonthCalendar1: {$ifdef fpc}TCalendar{$else}TMonthCalendar{$endif};
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$ifdef fpc}
 {$R *.lfm}
{$else}
 {$R *.dfm}
{$endif}

procedure TForm1.ScrollBar2Change(Sender: TObject);
begin
  Moon1.Location.Latitude := -Scrollbar2.Position;
  Label2.Caption := Format('Latitude:'#13#10'%.0f°', [Moon1.Location.Latitude]);
end;

procedure TForm1.ScrollBar1Change(Sender: TObject);
begin
  Moon1.Location.Longitude := Scrollbar1.Position;
  Label3.Caption := Format('Longitude: %.0f°', [Moon1.Location.Longitude]);
end;

procedure TForm1.RadioGroup1Click(Sender: TObject);
begin
  Moon1.Rotation := TRotate(Radiogroup1.ItemIndex);
end;

procedure TForm1.ScrollBar3Change(Sender: TObject);
begin
  Moon1.RotationAngle := Scrollbar1.Position;
  Moon1.Invalidate;
end;

procedure TForm1.MonthCalendar1Click(Sender: TObject);
begin
 {$ifdef fpc}
  Moon1.Date := MonthCalendar1.DateTime;
 {$else}
  Moon1.Date := MonthCalendar1.Date;
 {$endif}
end;

procedure TForm1.RadioGroup2Click(Sender: TObject);
begin
  Moon1.MoonSize := TMoonSize(RadioGroup2.ItemIndex);
end;

procedure TForm1.RadioGroup3Click(Sender: TObject);
begin
  Moon1.MoonStyle := TMoonStyle(RadioGroup3.ItemIndex);
end;

procedure TForm1.Panel1Click(Sender: TObject);
begin
  ColorDialog1.Color := Moon1.MoonColor;
  if ColorDialog1.Execute then begin
    Moon1.MoonColor := ColorDialog1.Color;
    Moon1.MoonStyle := msMonochrome;
    Panel1.Color := Moon1.MoonColor;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Moon1.Date := EncodeDate(2018, 1, 11);
  Icon := Moon1.Icon;
  Moon1.Date := now;

  Moon1.MoonColor := clWhite;
  Panel1.Color := Moon1.MoonColor;

  MonthCalendar1 := {$ifdef fpc}TCalendar{$else}TMonthCalendar{$endif}.Create(self);
  with MonthCalendar1 do begin
    Parent := self;
    Left := 208;
    Top := 8;
    OnClick := MonthCalendar1Click;
  end;
end;

procedure TForm1.cbTransparentClick(Sender: TObject);
begin
  Moon1.Transparent := cbTransparent.Checked;
end;

end.
