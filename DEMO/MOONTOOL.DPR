program moontool;

uses
  Forms,
  main in 'MAIN.PAS' {MainForm},
  about in 'ABOUT.PAS' {AboutForm},
  More in 'MORE.PAS' {frm_more};

{$R *.RES}

begin
(*$ifdef ver90 *)
  Application.Initialize;
(*$endif *)
  Application.Title := 'Moontool';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.CreateForm(Tfrm_more, frm_more);
  Application.Run;
  end.
