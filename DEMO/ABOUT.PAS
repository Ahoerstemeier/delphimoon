unit about;
(*@/// interface *)
interface

(*@/// uses *)
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, moon;
(*@\\\*)
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
(*@\\\*)
(*@/// implementation *)
implementation

{$R *.DFM}

(*@/// procedure TAboutForm.FormShow(Sender: TObject); *)
procedure TAboutForm.FormShow(Sender: TObject);
begin
  moon.date:=now;
  end;
(*@\\\*)

(*@\\\0030000501000601000501*)
end.
(*@\\\000F000401000401000301000011000301*)
