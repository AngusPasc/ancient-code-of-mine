program SkuskaVykres;

uses
  Forms,
  FormHlavneOkno in 'FormHlavneOkno.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.