program ARozvrhy;

uses
  Forms,
  FormHlavneOkno in 'FormHlavneOkno.pas' {HlavneOkno},
  ClassKontrola in 'ClassKontrola.pas',
  Konstanty in '..\..\Konstanty.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(THlavneOkno, HlavneOkno);
  Application.Run;
end.
