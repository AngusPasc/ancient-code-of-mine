program Analytika;

uses
  Forms,
  FormHlavneOkno in 'FormHlavneOkno.pas' {HlavneOkno},
  ClassSustava in 'ClassSustava.pas',
  ClassVykres in 'ClassVykres.pas',
  ClassSubor in 'ClassSubor.pas',
  Debugging in 'Debugging.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(THlavneOkno, HlavneOkno);
  Application.Run;
end.
