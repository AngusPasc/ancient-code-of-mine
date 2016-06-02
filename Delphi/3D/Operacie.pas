unit Operacie;

interface
  uses ExtCtrls, Windows, Graphics, Math;

  procedure Premietni( Image : TImage );
  procedure PremietniEditor( Image : TImage );

implementation
uses FHlavneOkno;

type TRgb = record
              R, G, B : Byte;
            end;  

function NasobMatice( Co : TBod; Matica : TMatica) : TBod;
var A,B : byte;
    C : real;
    Pom : TBod;
begin
   for A := 1 to 3 do
    begin
      C := 0;
      for B := 1 to 3 do
        C := C + Co[ b ]*Matica[ b , a ];
      C := C + Matica[ 4 , a ];
      Pom[ a ] := C;
    end;
  NasobMatice := Pom;
end;

{--------------- T R A N S F O R M A C I E  O B J E K T U --------------}

function Posun( tx , ty , tz : Real; PosunBody : TBody ) : TBody;
const Matica : Tmatica =
        (( 1 , 0 , 0 ),
         ( 0 , 1 , 0 ),
         ( 0 , 0 , 1 ),
         ( 0 , 0 , 0 ));
var A : Word;
begin
  Matica[4,1] := tx;
  Matica[4,2] := ty;
  Matica[4,3] := tz;

  for A := 1 to PocetBodov do
    PosunBody[A] := NasobMatice( PosunBody[A] , Matica );
  Posun := PosunBody;
end;

function Otoc( alfa , beta , gama : real; OtocBody : TBody) : TBody;

procedure OtocX( uhol : real );
const Matica : TMatica =
        (( 1 , 0 , 0 ),
         ( 0 , 1 , 0 ),
         ( 0 , 0 , 1 ),
         ( 0 , 0 , 0 ));
var A : Word;
begin
  matica[2,2] := cos((pi/180)*uhol);
  matica[3,3] := matica[2,2];
  matica[2,3] := -sin((pi/180)*uhol);
  matica[3,2] := -matica[2,3];

  for A := 1 to PocetBodov do
    OtocBody[A] := NasobMatice( OtocBody[A] , Matica );
end;

procedure OtocY( uhol : Real );
const Matica : TMatica =
        (( 1 , 0 , 0 ),
         ( 0 , 1 , 0 ),
         ( 0 , 0 , 1 ),
         ( 0 , 0 , 0 ));
var A : Word;
begin
  matica[1,1] := cos(uhol/180*pi);
  matica[3,3] := matica[1,1];
  matica[3,1] := sin(uhol/180*pi);
  matica[1,3] := -matica[3,1];

  for A := 1 to PocetBodov do
    OtocBody[A] := NasobMatice( OtocBody[A] , Matica );
end;

procedure OtocZ( uhol : real );
const Matica : TMatica =
        (( 1 , 0 , 0 ),
         ( 0 , 1 , 0 ),
         ( 0 , 0 , 1 ),
         ( 0 , 0 , 0 ));
var A : Word;
begin
  matica[1,1] := cos(pi / 180 * uhol);
  matica[2,2] := matica[1,1];
  matica[2,1] := sin(pi / 180 * uhol);
  matica[1,2] := -matica[2,1];

  for A := 1 to PocetBodov do
    OtocBody[A] := NasobMatice( OtocBody[A] , Matica );
end;

begin
  OtocX( alfa );
  OtocY( beta );
  OtocZ( gama );
  Otoc := OtocBody;
end;

function Zvacsi( Zoom : Real; ZvacsiBody : TBody ) : TBody;
var A : Word;
    B : Byte;
begin
  for A := 1 to PocetBodov do
    for B := 1 to 3 do
      ZvacsiBody[A,B] := ZvacsiBody[A,B] * Zoom;
  Zvacsi := ZvacsiBody;
end;

{--------------- V E K T O R Y --------------}

function VelkostVektora( u : TVektor ) : Real;
begin
  VelkostVektora := Sqrt( Sqr(U.X) + Sqr(U.Y) + Sqr(U.Z) );
end;

function SkalarnySucin( u, v : TVektor ) : Real;
begin
  SkalarnySucin := U.X*V.X + U.Y*V.Y + U.Z*V.Z;
end;

function VektorovySucin( u, v : TVektor ) : TVektor;
begin
  VektorovySucin.X := U.Y*V.Z - U.Z*V.Y;
  VektorovySucin.Y := U.Z*V.X - U.X*V.Z;
  VektorovySucin.Z := U.X*V.Y - U.Y*V.X;
end;

function CosVektorov( u, v : TVektor ) : Real;
begin
  CosVektorov := Cos( SkalarnySucin(u,v) / (VelkostVektora(u)*VelkostVektora(v)));
end;

function Normala( Plocha : TStena ) : TVektor;
var u, v : TVektor;
begin
  U.X := Kamera.Body[ Plocha.B , 1 ] - Kamera.Body[ Plocha.A , 1 ];
  U.Y := Kamera.Body[ Plocha.B , 2 ] - Kamera.Body[ Plocha.A , 2 ];
  U.Z := Kamera.Body[ Plocha.B , 3 ] - Kamera.Body[ Plocha.A , 3 ];

  V.X := Kamera.Body[ Plocha.C , 1 ] - Kamera.Body[ Plocha.B , 1 ];
  V.Y := Kamera.Body[ Plocha.C , 2 ] - Kamera.Body[ Plocha.B , 2 ];
  V.Z := Kamera.Body[ Plocha.C , 3 ] - Kamera.Body[ Plocha.B , 3 ];

  Normala := VektorovySucin( U , V );
end;

procedure VypocitajZBuffer( BufferBody : TBody; Vidiet : TVidiet );
var A : word;

procedure QuickSort( iLo, iHi: Integer );
var Lo, Hi : Integer;
    Mid : Real;
    C : TStena;
begin
  Lo := iLo;
  Hi := iHi;
  Mid := Steny[(Lo + Hi) div 2].Z;
  repeat
    while Steny[Lo].Z > Mid do Inc(Lo);
    while Steny[Hi].Z < Mid do Dec(Hi);
    if Lo <= Hi then
      begin
        C := Steny[Hi];
        Steny[Hi] := Steny[Lo];
        Steny[Lo] := C;
        Inc(Lo);
        Dec(Hi);
      end;
  until Lo > Hi;
  if Hi > iLo then QuickSort( iLo, Hi );
  if Lo < iHi then QuickSort( Lo, iHi );
end;

begin
  for A := 1 to PocetStien do
    begin
      Steny[A].Normala := Normala( Steny[A] );
      if ( BufferBody[Steny[A].A,3] <= 0 ) or
         ( BufferBody[Steny[A].B,3] <= 0 ) or
         ( BufferBody[Steny[A].C,3] <= 0 ) then
           Steny[A].Vidiet := False
             else
           begin
             Steny[A].Z := BufferBody[Steny[A].A,3] + BufferBody[Steny[A].B,3] + BufferBody[Steny[A].C,3];
             if Steny[A].Normala.Z > 0 then Steny[A].Vidiet := True
                                       else Steny[A].Vidiet := False;
           end;
    end;
  QuickSort( 1 , PocetStien );
end;

function FarbaNaRGB( Farba : TColor ) : TRgb;
begin
  FarbaNaRGB.R := Farba;
  FarbaNaRGB.G := Farba shr 8;
  FarbaNaRGB.B := Farba shr 16;
end;

function UrobSvetlo( Normala : TVektor; Farba : TColor ) : TColor;
var DifuznaIntenzita : Real;
    Intenzita : Real;
    RGB : TRgb;
    Vysledok : TRgb;
begin
  DifuznaIntenzita := CosVektorov( Normala , Svetlo.Smer );
  Intenzita := Svetlo.Intenzita + DifuznaIntenzita;
  RGB := FarbaNaRGB( Farba );
  if Round(RGB.R*Intenzita) < MaxByte then Vysledok.R := Round(RGB.R*Intenzita)
                                      else Vysledok.R := MaxByte;
  if Round(RGB.G*Intenzita) < MaxByte then Vysledok.G := Round(RGB.G*Intenzita)
                                      else Vysledok.G := MaxByte;
  if Round(RGB.B*Intenzita) < MaxByte then Vysledok.B := Round(RGB.B*Intenzita)
                                      else Vysledok.B := MaxByte;
  UrobSvetlo := (Vysledok.R) + (Vysledok.G shl 8) + (Vysledok.B shl 16);
end;

procedure Premietni( Image : TImage );
var A : Word;
    Premietnute : array[1..3] of TPoint;

function PremietniBod( Co : TBod ) : TPoint;
begin
  PremietniBod.X := Round( StredX + (Co[1]) );
  PremietniBod.Y := Round( StredY + (Co[2]) );
end;

begin
  Image.Canvas.Brush.Color := clBlack;
  Image.Canvas.FillRect( Image.ClientRect );

  Kamera.Body := Body;
  Kamera.Body := Zvacsi( Kamera.Zvacsenie , Kamera.Body );
  Kamera.Body := Otoc( -Kamera.Alfa , -Kamera.Beta , -Kamera.Gama , Kamera.Body );
  Posun( -Kamera.X , -Kamera.Y , -Kamera.Z , Kamera.Body );
  VypocitajZBuffer( Kamera.Body , Kamera.Vidiet );

  for A := 1 to PocetStien do
    if Steny[A].Vidiet then
      begin
        Premietnute[1] := PremietniBod( Kamera.Body[ Steny[A].A ] );
        Premietnute[2] := PremietniBod( Kamera.Body[ Steny[A].B ] );
        Premietnute[3] := PremietniBod( Kamera.Body[ Steny[A].C ] );

        with Image.Canvas do
          begin
            Brush.Color := UrobSvetlo( Steny[A].Normala , Steny[A].Farba );
            Pen.Color := Brush.Color;
            Polygon( Premietnute );
          end;
      end;
end;

procedure PremietniEditor( Image : TImage );
begin
end;

end.
