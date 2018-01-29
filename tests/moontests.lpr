program moontests;

{$mode delphi}

uses
  Interfaces, Forms, GuiTestRunner, MoonTest;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

