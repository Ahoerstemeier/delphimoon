unit mtEclipsesForm;

interface

uses
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Grids, ExtCtrls;

type

  { TfrmEclipses }

  TfrmEclipses = class(TForm)
    Grid: TStringGrid;
    edFrom: TEdit;
    edTo: TEdit;
    lblTo: TLabel;
    lblFrom: TLabel;
    rbSolarEclipses: TRadioButton;
    rbLunarEclipses: TRadioButton;
    udFrom: TUpDown;
    udTo: TUpDown;
    btnSearch: TButton;
    procedure btnSearchClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure UpdateLayout;
    procedure UpdateStrings;
  public
    { Public declarations }
  end;

var
  frmEclipses: TfrmEclipses;

implementation

{$ifdef fpc}
  {$R *.lfm}
{$else}
  {$R *.dfm}
{$endif}

uses
  Moon, mtStrings, mtUtils;

procedure TfrmEclipses.FormCreate(Sender: TObject);
var
  y,m,d: Word;
begin
  Grid.Cells[0, 0] := SDateTime;
  Grid.Cells[1, 0] := SEclipseType;
  DecodeDate(Now(), y,m,d);
  udFrom.Position := y div 10 * 10 - 10;
  udTo.Position := y div 10 * 10 + 50;
end;

procedure TfrmEclipses.FormShow(Sender: TObject);
var
  L, T: Integer;
begin
  UpdateStrings;
  UpdateLayout;

  L := Application.MainForm.Left + (Application.MainForm.Width - Width) div 2;
  T := Application.MainForm.Top + (Application.MainForm.Height - Height) div 2;
  SetBounds(L, T, Width, Height);
end;

procedure TfrmEclipses.btnSearchClick(Sender: TObject);
var
  dt, fromDate, toDate: TDateTime;
  eclipseValue: TEclipse;
  r: integer;
  s: string;
begin
  fromDate := EncodeDate(StrToInt(edFrom.Text), 1, 1);
  toDate := EncodeDate(StrToInt(edTo.Text), 12, 31);
  dt := fromDate;

  Grid.RowCount := 100;
  r := 0;
  repeat
    eclipseValue := NextEclipse(dt, rbSolarEclipses.Checked);
    case eclipseValue of
      none, halfshadow : s := SEclipseNone;
      partial          : s := SEclipsePartial;
      total            : s := SEclipseTotal;
      circular         : s := SEclipseCircular;
      circulartotal    : s := SEclipseCircularTotal;
      noncentral       : s := SEclipseNonCentral;
    end;
    if dt <= toDate then
    begin
      inc(r);
      if r >= Grid.RowCount then Grid.RowCount := Grid.RowCount + 100;
      Grid.Cells[0, r] := UTCDateString(dt);
      Grid.Cells[1, r] := s;
    end;
    dt := dt + 24
  until dt >= toDate;
  Grid.RowCount := r+1;
end;

procedure TfrmEclipses.UpdateLayout;
begin
  rbLunarEclipses.Left := edFrom.Left;
  rbSolarEclipses.Left := edFrom.Left;
  Grid.DefaultRowHeight := Grid.Canvas.TextHeight('Tg') + 4;
end;

procedure TfrmEclipses.UpdateStrings;
begin
  Caption := SSolarAndLunarEclipses;
  rbSolarEclipses.Caption := SSolarEclipses;
  rbLunarEclipses.Caption := SLunarEclipses;
  btnSearch.Caption := SSearch;
  lblFrom.Caption := SFrom;
  lblTo.Caption := STo;
end;

end.
