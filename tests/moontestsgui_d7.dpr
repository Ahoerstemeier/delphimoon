program moontestsgui_d7;

uses
  TestFramework,
  Forms,
  GUITestRunner,
  moon in '..\moon.pas',
  moontest in 'moontest.pas',
  ah_math in '..\ah_math.pas',
  moon_aux in '..\moon_aux.pas',
  moon_elp in '..\moon_elp.pas',
  vsop in '..\vsop.pas',
  planets in '..\planets.pas',
  vsop_jup in '..\vsop_jup.pas',
  vsop_mar in '..\vsop_mar.pas',
  vsop_mer in '..\vsop_mer.pas',
  vsop_nep in '..\vsop_nep.pas',
  vsop_sat in '..\vsop_sat.pas',
  vsop_ura in '..\vsop_ura.pas',
  vsop_ven in '..\vsop_ven.pas',
  pluto in '..\pluto.pas';

{$R *.res}

begin
  Application.Initialize;
  GUITestRunner.RunRegisteredTests;
end.


