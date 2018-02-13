program moontestsgui_laz;

{$mode delphi}

uses
  Interfaces, Forms, GuiTestRunner, moontest;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

