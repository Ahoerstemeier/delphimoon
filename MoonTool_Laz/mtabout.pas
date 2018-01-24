unit mtAbout;

interface

uses
{$ifdef fpc}
  LCLIntf, LCLType,
{$else}
  Windows, Messages, Consts, ShellApi,
{$endif}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls,
  MoonComp, Moon;

type
  { TfrmAbout }

  TfrmAbout = class(TForm)
    btnOK: TButton;
    lblMain: TLabel;
    lblCopyright: TLabel;
    lblRef: TLabel;
    lblURL: TLabel;
    Moon: TMoon;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lblURLClick(Sender: TObject);
    procedure lblURLMouseEnter(Sender: TObject);
    procedure lblURLMouseLeave(Sender: TObject);
  private
    procedure UpdateLayout;
  public
    procedure UpdateStrings;
  end;

var
  frmAbout: TfrmAbout;

implementation

uses
  mtStrings, mtConst, Math;

{$ifdef fpc}
  {$R *.lfm}
{$else}
  {$R *.dfm}
{$endif}


{ TfrmAbout }

procedure TfrmAbout.FormCreate(Sender: TObject);
begin
 {$ifdef fpc}
  lblURL.OnMouseLeave := lblURLMouseLeave;
  lblURL.OnMouseEnter := lblURLMouseEnter;
 {$endif}
end;

procedure TfrmAbout.FormShow(Sender: TObject);
begin
  UpdateStrings;
  Moon.Date := now;
end;

procedure TfrmAbout.lblURLClick(Sender: TObject);
begin
 {$ifdef fpc}
  OpenURL('http://www.hoerstemeier.com');
 {$else}
  ShellExecute(Application.Handle,PChar('open'),'http://www.hoerstemeier.com',PChar(''),nil,SW_NORMAL);
 {$endif}
end;

procedure TfrmAbout.lblURLMouseEnter(Sender: TObject);
begin
//  lblURL.Font.Color := clBlue;
//  lblURL.Font.Style := [fsUnderline];
//  lblURL.Cursor := crHandPoint;
end;

procedure TfrmAbout.lblURLMouseLeave(Sender: TObject);
begin
// lblURL.Font.Color := clBlack;
// lblURL.Font.Style := [];
// lblURL.cursor := crDefault;
end;

procedure TfrmAbout.UpdateLayout;
const
  DISTANCE = 16;
var
  w: Integer;
  p: Integer;
begin
  w := Max(Max(Max(lblMain.Width, lblCopyright.Width), lblURL.Width), lblRef.Width);

  p := Moon.Left + Moon.Width + DISTANCE + w div 2;

  lblMain.Left := p - lblMain.Width div 2;
  lblCopyright.Left := p - lblCopyright.Width div 2;
  lblURL.Left := p - lblURL.Width div 2;
  lblRef.Left := p - lblRef.Width div 2;
  btnOK.Left := p - btnOK.Width div 2;

  lblMain.Top := Moon.Top;
  lblCopyright.Top := lblMain.Top + lblMain.Height + 8;
  lblURL.Top := lblCopyright.Top + lblCopyright.Height;
  lblRef.Top := lblURL.Top + lblURL.Height + 8;
  btnOK.Top := lblRef.Top + lblRef.Height + 16;

  ClientWidth := Moon.Left + Moon.Width + DISTANCE + w + DISTANCE;
  ClientHeight := btnOK.Top + btnOK.Height + 8;
end;

procedure TfrmAbout.UpdateStrings;
begin
  Caption := SAboutBox;
  btnOK.Caption := SOKButton;
  lblMain.Caption := SMoontoolAbout;
  lblRef.Caption := SBasedUpon;
  UpdateLayout;
end;

end.


