{$APPTYPE CONSOLE}

program TestMoon;

uses
  Forms,
  sysutils,
  TestFramework,
  GUITestRunner,
  TextTestRunner,
  MoonTest in 'MoonTest.pas';

{$R *.RES}

begin
  Application.Initialize;
//  GUITestRunner.RunRegisteredTests;
  if FindCmdLineSwitch('text-mode', ['-','/'], true) then
    TextTestRunner.RunRegisteredTests(rxbHaltOnFailures)
  else
    GUITestRunner.RunRegisteredTests;
end.

