unit ClassNulovy;

interface

uses ExtCtrls, Windows, MojeTypy;

type TNulovy = class
     protected
       Image : TImage;

     public
       Hotovo : boolean;
       NasielRiesenie : boolean;

       Funkcia : TMojaFunkcia;

       Stred : TPoint;
       NakresliL, NakresliP : real;
       PocitajL, PocitajP : real;

       Presnost : real;

       constructor Create( iLavy, iPravy : real; iImage : TImage );
       destructor Destroy; override;

       procedure NakresliFunkciu;
       procedure RiesFunkciu;

       procedure Krok; virtual; abstract;
     end;

implementation

uses Graphics;

//==============================================================================
//==============================================================================
//
//                                   Constructor
//
//==============================================================================
//==============================================================================

constructor TNulovy.Create( iLavy, iPravy : real; iImage : TImage );
begin
  inherited Create;

  Image := iImage;

  Stred.X := Image.Width div 2;
  Stred.Y := Image.Height div 2;

  Hotovo := False;
end;

//==============================================================================
//==============================================================================
//
//                                    Destructor
//
//==============================================================================
//==============================================================================

destructor TNulovy.Destroy;
begin
  inherited;
end;

//==============================================================================
//==============================================================================
//
//                                 I N T E R F A C E
//
//==============================================================================
//==============================================================================

procedure TNulovy.NakresliFunkciu;
var I : integer;
    A, B : integer;
begin
  A := Round( NakresliL );
  B := Round( NakresliP );

  if A < -Stred.X then A := -Stred.X;
  if A > Stred.X then exit;
  if B < -Stred.X then exit;
  if B > Stred.X then B := Stred.X;

  with Image.Canvas do
    begin
      Brush.Color := clBlack;
      FillRect( Image.ClientRect );

      Pen.Color := clGray;
      MoveTo( 0 , Stred.Y );
      LineTo( Image.Width , Stred.Y );
      MoveTo( Stred.X , 0 );
      LineTo( Stred.X , Image.Height );

      Pen.Color := clYellow;
    end;

  Image.Canvas.MoveTo( Round( Stred.X + NakresliL ) , Round( Stred.Y - Funkcia( NakresliL ) ) );

  for I := A+1 to B do
    Image.Canvas.LineTo( Stred.X + I , Round( Stred.Y - Funkcia( I ) ) );
end;

procedure TNulovy.RiesFunkciu;
begin
  while not Hotovo do Krok;
end;

end.
