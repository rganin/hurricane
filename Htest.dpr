program Htest;

uses
  Forms,
  Main in 'Main.pas' {Form1},
  Hurricane in 'Hurricane.pas',
  AboutUnit in 'AboutUnit.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
