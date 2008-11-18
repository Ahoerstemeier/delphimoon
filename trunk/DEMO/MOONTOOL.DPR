program moontool;

uses
  Forms,
  main in 'main.pas' {MainForm},
  about in 'about.pas' {AboutForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Moontool';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.Run;
  end.
