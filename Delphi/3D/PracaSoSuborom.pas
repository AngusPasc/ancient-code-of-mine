unit PracaSoSuborom;

interface
  uses FHlavneOkno, Graphics;

  procedure OtvorSubor( Nazov : String );

implementation

procedure OtvorSubor( Nazov : String );
var Subor : Text;
    Riadok : String;
    A, B, C : Word;
begin
  Assign( Subor , Nazov );
  Reset( Subor );
  Readln( Subor , Riadok ); // Nazov objektu

  HlavneOkno.Caption := '3D Engine - ' + Riadok;

  A := 0;
  B := 0;
  C := 0;

  //Body objektu :
  repeat
    Inc( A );
    {$I-}
    Readln( Subor , Body[A,1] , Body[A,2] , Body[A,3] );
    {$I+}
    if IOResult <> 0 then
      begin
        Dec( A );
        Break;
      end;
  until False;

  //Hrany objektu :
  repeat
    Inc( B );
    {$I-}
    Readln( Subor , Hrany[B].A , Hrany[B].B );
    {$I+}
    if IOResult <> 0 then
      begin
        Dec( B );
        Break;
      end;
  until False;

  //Plochy objektu :
  while not EoF( Subor ) do
    begin
      Inc( C );
      Readln( Subor , Steny[C].A , Steny[C].B , Steny[C].C );
      with Steny[C] do
        begin
          Farba := clRed;
          Vidiet := True;
        end;
    end;
  Close( Subor );
  PocetBodov := A;
  PocetHran := B;
  PocetStien := C;
end;

end.
