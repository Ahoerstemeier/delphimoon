program moondemo_d7;

uses
  Forms,
  mdmain in 'mdmain.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
