unit Eclipses;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Grids,
  ah_tool, moon, Main;

type
  Tfrm_eclipses = class(TForm)
    StringGrid1: TStringGrid;
    edFrom: TEdit;
    edTo: TEdit;
    UpDown1: TUpDown;
    UpDown2: TUpDown;
    Button1: TButton;
    SolarEclipse: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_eclipses: Tfrm_eclipses;

implementation

{$R *.DFM}
(*$i moontool.inc *)

procedure Tfrm_eclipses.FormCreate(Sender: TObject);
begin
  StringGrid1.Cells[0,0]:='Time';
  StringGrid1.Cells[1,0]:='Character';
end;

procedure Tfrm_eclipses.Button1Click(Sender: TObject);
var
  y,m,d: word;
  jetzt,jetzt2,fromDate,toDate: TDateTime;
  date: TDateTime;
  j: longint;
  eclipse_value: TEclipse;
  longitude, latitude: extended;

  r: integer;
  s: string;
begin
  //jetzt:=start_time+(now-first_now)+TimeZoneBias/(60*24);

  //DecodeDate(jetzt,y,m,d);

  d:=1; m:=1; y:=StrToInt(edFrom.Text);
  FromDate:=EncodeDate(y,m,d);
  d:=31; m:=12; y:=StrToInt(edTo.Text);
  ToDate:=EncodeDate(y,m,d);

  jetzt:=FromDate;

  r:=0;

  repeat

    if SolarEclipse.Checked then
    begin

      (*@/// Sun eclipse *)

      eclipse_value:=NextEclipse(jetzt,true);

      case eclipse_value of
        none, halfshadow: s:=LoadStr(SEclipseNone);
        partial:          s:=LoadStr(SEclipsePartial);
        total:            s:=LoadStr(SEclipseTotal);
        circular:         s:=LoadStr(SEclipseCircular);
        circulartotal:    s:=LoadStr(SEclipseCircularTotal);
        noncentral:       s:=LoadStr(SEclipseNonCentral);
      end;

    end else
    begin

      (*@\\\0000000901*)
      (*@/// Moon eclipse *)

      eclipse_value:=NextEclipse(jetzt,false);

      case eclipse_value of
        none:             s:=LoadStr(SEclipseNone);
        partial:          s:=LoadStr(SEclipsePartial);
        total:            s:=LoadStr(SEclipseTotal);
        halfshadow:       s:=LoadStr(SEclipseHalfshadow);
      {   circular:         typ_mooneclipse.caption:=LoadStr(SEclipseCircular); }
      {   circulartotal:    typ_mooneclipse.caption:=LoadStr(SEclipseCircularTotal); }
      {   noncentral:       typ_mooneclipse.caption:=LoadStr(SEclipseNonCentral); }
        end;

    end;

    if jetzt<=todate then
    begin
      r:=r+1;
      StringGrid1.RowCount:=r+1;
      StringGrid1.Cells[0,r]:=datestring(jetzt);
      StringGrid1.Cells[1,r]:=s;
    end;

    jetzt:=jetzt+24
  until jetzt>=todate

end;

end.
