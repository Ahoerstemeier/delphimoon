unit mtAbout;

interface

 {$i ah_def.inc }
uses
{$ifdef fpc}
  LCLIntf, LCLType, LMessages,
{$else}
 {$ifdef ver80}
  winprocs,
  wintypes,
 {$else}
  Windows,
 {$endif}
  Messages,
{$endif}
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ExtCtrls,
{$ifndef fpc}
  consts,
 {$ifdef delphi_ge_2}
  shellapi,
 {$endif}
{$endif}
  mooncomp,
  moon;

type
  { TfrmAbout }

  TfrmAbout = class(TForm)
    btnOK: TButton;
    lblMain: TLabel;
    lblCopyright: TLabel;
    lblRef: TLabel;
    lblURL: TLabel;
    Moon: TMoon;
    TextPanel: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lblURLClick(Sender: TObject);
    procedure lblURLMouseEnter(Sender: TObject);
    procedure lblURLMouseLeave(Sender: TObject);
  public
    procedure UpdateStrings;
  end;

var
  frmAbout: TfrmAbout;

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
  {$i moontool.inc }
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
  lblURL.Font.Color := clBlue;
  lblURL.Font.Style := [fsUnderline];
  lblURL.Cursor := crHandPoint;
end;

procedure TfrmAbout.lblURLMouseLeave(Sender: TObject);
begin
 lblURL.Font.Color := clBlack;
 lblURL.Font.Style := [];
 lblURL.cursor := crDefault;
end;

procedure TfrmAbout.UpdateStrings;
begin
  Caption := SAboutBox;
  btnOK.Caption := SOKButton;
  lblMain.Caption := SMoontoolAbout;
  lblRef.Caption := SBasedUpon;
end;

end.


