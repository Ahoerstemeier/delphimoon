unit about;
(*@/// interface *)
interface

(*@/// uses *)
uses
(*$ifdef ver80 *)
  winprocs,
  wintypes,
(*$else *)
  Windows,
(*$endif *)
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ExtCtrls,
  moon;
(*@\\\003C000101000101000201000801*)
type
(*@///   TAboutForm = class(TForm) *)
TAboutForm = class(TForm)
  btn_ok: TButton;
  Moon: TMoon;
  lbl_1: TLabel;
  lbl_2: TLabel;
  lbl_3: TLabel;
  lbl_4: TLabel;
    procedure FormShow(Sender: TObject);
private
  { Private-Deklarationen }
public
  { Public-Deklarationen }
end;
(*@\\\*)

var
  AboutForm: TAboutForm;
(*@\\\0000000501*)
(*@/// implementation *)
implementation

{$R *.DFM}

(*@/// procedure TAboutForm.FormShow(Sender: TObject); *)
procedure TAboutForm.FormShow(Sender: TObject);
begin
  moon.date:=now;
  end;
(*@\\\*)
(*@\\\0000000501*)
end.
(*@\\\0003000301000011000301*)
