program moondemo_dnew;

uses
  Forms,
  mdmain in 'mdmain.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
