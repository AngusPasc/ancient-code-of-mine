program SubWinTest;

uses
  Forms,
  UnitMainForm in 'UnitMainForm.pas' {MainForm},
  ClassSubWin in 'ClassSubWin.pas',
  ClassNewImage in '..\NewImage\ClassNewImage.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
