program moontool;

uses
  Forms, Interfaces,
  {$ifdef fpc}
  lclversion,
  {$endif}
  mtMain in 'MAIN.PAS' {MainForm},
  mtAbout in 'ABOUT.PAS' {AboutForm},
  mtMoreDataForm in 'MORE.PAS' {frm_more},
  mtJulianForm in 'julian.pas' {frm_julian},
  mtUTCForm in 'utc.pas' {frm_utc},
  mtLocation in 'location.pas' {frm_locations},
  mtJewishForm in 'jewish.pas', mtConst, mtUtils, mtStrings {frm_jewish};

{$ifdef fpc}
  {$R *.res}
{$else}
  {$R moontool.r32}
{$endif}

begin
{$ifdef fpc}
  {$if lcl_fullversion >= 1080000}
  Application.Scaled := True;
  {$endif}
{$endif}

  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TfrmMoreData, frmMoreData);
  Application.CreateForm(TfrmJulian, frmJulian);
  Application.CreateForm(TfrmUTC, frmUTC);
  Application.CreateForm(TfrmLocations, frmLocations);
  Application.CreateForm(TfrmJewish, frmJewish);
  Application.Run;
end.
