program Scrabble;

uses
  Forms,
  UnitMainForm in 'UnitMainForm.pas' {MainForm},
  ClassGame in 'ClassGame.pas',
  ClassLetterBoard in 'ClassLetterBoard.pas',
  ClassScoreBoard in 'ClassScoreBoard.pas',
  ClassBoard in 'ClassBoard.pas',
  ClassPlayer in 'ClassPlayer.pas',
  ClassHuman in 'ClassHuman.pas',
  ClassComputer in 'ClassComputer.pas',
  ClassLetterStack in 'ClassLetterStack.pas',
  ClassLetters in 'ClassLetters.pas',
  ClassBaseBoard in 'ClassBaseBoard.pas',
  ClassWords in 'ClassWords.pas',
  UnitFormJoker in 'UnitFormJoker.pas' {FormJoker},
  UnitFormNewGame in 'UnitFormNewGame.pas' {FormNewGame},
  UnitFormWinner in 'UnitFormWinner.pas' {FormWinner},
  ClassBSTree in 'ClassBSTree.pas',
  UnitFormWait in 'UnitFormWait.pas' {FormWait};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TFormJoker, FormJoker);
  Application.CreateForm(TFormNewGame, FormNewGame);
  Application.CreateForm(TFormWinner, FormWinner);
  Application.Run;
end.
