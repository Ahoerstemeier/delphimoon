program moontool;

uses
  Forms,
  mtmain in 'mtmain.pas' {MainForm},
  mtabout in 'mtabout.pas' {AboutForm},
  mtConst,
  mtUtils,
  mtStrings,
  mtUTCForm in 'mtutcform.pas' {frmUTC},
  mtJewishForm in 'mtjewishform.pas' {frmJewish},
  mtJulianForm in 'mtjulianform.pas' {frmJulian},
  mtLocation in 'mtlocation.pas' {frmLocations},
  mtMoreDataForm in 'mtmoredataform.pas' {frmMoreData};

{$ifdef fpc}
  {$R *.res}
{$else}
  {$R moontool.r32}
{$endif}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TfrmUTC, frmUTC);
  Application.CreateForm(TfrmJewish, frmJewish);
  Application.CreateForm(TfrmJulian, frmJulian);
  Application.CreateForm(TfrmLocations, frmLocations);
  Application.CreateForm(TfrmMoreData, frmMoreData);
  Application.Run;
end.
