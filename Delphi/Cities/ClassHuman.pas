unit ClassHuman;

interface

uses Classes, Controls, ExtCtrls, ClassPlayer;

type THuman = class( TPlayer )
     private
       Sur : TPos;
       Image : TImage;
       Clicked : boolean;
       procedure OnMouseDown( Sender: TObject; Button: TMouseButton;
                              Shift: TShiftState; X, Y: Integer );
     public
       constructor Create( iImage : TImage );
       function MakeMove( Table : TTable ) : TPos; override;
     end;

implementation

uses Forms;

//******************************************************************************
//   Constructor
//******************************************************************************

constructor THuman.Create( iImage : TImage );
begin
  Finish := False;
  Image := iImage;
  Image.OnMouseDown := OnMouseDown;
end;

//******************************************************************************
//   Private
//******************************************************************************

procedure THuman.OnMouseDown( Sender: TObject; Button: TMouseButton;
                              Shift: TShiftState; X, Y: Integer );
begin
  Sur.X := X;
  Sur.Y := Y;
  Clicked := True;
end;

//******************************************************************************
//   INTERFACE
//******************************************************************************

function THuman.MakeMove( Table : TTable ) : TPos;
var I : integer;
    d, b : double;
    Correct : boolean;
begin
  Result.X := 0;
  Result.Y := 0;

  d := Image.Width / XMAX;
  b := Image.Height / YMAX;

  Correct := False;
  repeat
    Clicked := False;
    repeat
      Application.ProcessMessages;
    until (Clicked) or (Finish);

    if (Finish) then
      break;

    for I := 1 to XMAX do
      if (Round( d * I ) >= Sur.X) then
        begin
          Result.X := I;
          break;
        end;

    for I := 1 to YMAX do
      if (Round( b * I ) >= Sur.Y) then
        begin
          Result.Y := I;
          break;
        end;

    if (Table[Result.X,Result.Y] = -1) then
      Correct := True;
  until (Correct);
end;

end.
