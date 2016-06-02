program Dodacie;

//{$DEFINE DEBUG}
{$IFDEF DEBUG}
  {$APPTYPE CONSOLE}
{$ENDIF DEBUG}

{%ToDo 'Dodacie.todo'}

uses
  Forms,
  ClassFaktury in 'ClassFaktury.pas',
  Typy in 'Typy.pas',
  FormHlavneOkno in 'FormHlavneOkno.pas' {HlavneOkno},
  DialogDodaciKFakture in 'DialogDodaciKFakture.pas' {DodaciKFakture},
  ClassTlacDod in 'ClassTlacDod.pas',
  ClassAdresy in 'ClassAdresy.pas',
  FormOtvorPon in 'FormOtvorPon.pas' {FormOtvoritPon},
  Ini in 'Ini.pas',
  FormAdresar in 'FormAdresar.pas' {FormAdr},
  FormMoznosti in 'FormMoznosti.pas' {FormMozn},
  FormTlacDodPon in 'FormTlacDodPon.pas' {FormTlacDodPonuka},
  ClassDodPon in 'ClassDodPon.pas',
  FormTlacPon in 'FormTlacPon.pas' {FormTlacPonuka},
  FormMan in 'FormMan.pas' {FormManager},
  FormChooseAdr in 'FormChooseAdr.pas' {FormChAdr},
  FormZakList in 'FormZakList.pas' {ZakList},
  ClassZakList in 'ClassZakList.pas',
  FormSaveZak in 'FormSaveZak.pas' {FormZakazSave};

{$R *.RES}

begin
  {$IFDEF DEBUG}
  Writeln( 'Z1' );
  {$ENDIF DEBUG}
  Application.Initialize;
  {$IFDEF DEBUG}
  Writeln( 'Z2' );
  {$ENDIF DEBUG}
  Application.Title := 'Dodacie listy v1.2';
  Application.CreateForm(THlavneOkno, HlavneOkno);
  Application.CreateForm(TFormTlacPonuka, FormTlacPonuka);
  Application.CreateForm(TFormManager, FormManager);
  Application.CreateForm(TZakList, ZakList);
  Application.CreateForm(TFormTlacDodPonuka, FormTlacDodPonuka);
  Application.CreateForm(TFormZakazSave, FormZakazSave);
  Application.CreateForm(TFormAdr, FormAdr);
  {$IFDEF DEBUG}
  Writeln( 'Z5' );
  {$ENDIF DEBUG}
  Application.CreateForm(TFormMozn, FormMozn);
  {$IFDEF DEBUG}
  Writeln( 'Z6' );
  {$ENDIF DEBUG}
  Application.CreateForm(TFormOtvoritPon, FormOtvoritPon);
  {$IFDEF DEBUG}
  Writeln( 'Z7' );
  {$ENDIF DEBUG}
  Application.CreateForm(TDodaciKFakture, DodaciKFakture);
  {$IFDEF DEBUG}
  Writeln( 'Z8' );
  {$ENDIF DEBUG}
  Application.Run;
end.
