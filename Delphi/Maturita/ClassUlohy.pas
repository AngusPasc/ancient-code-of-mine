unit ClassUlohy;

interface

uses Classes, SysUtils, Windows;

type    TUloha = class
        protected
          Strings : TStringList;
        public
          function Solve : TStrings; virtual;
          destructor Destroy; override;
        end;

var List : TList;

implementation

type    TUloha1 = class( TUloha )
	private
          function NSD( Cisla : array of integer ) : integer;
        public
          function Solve : TStrings; override;
        end;

//==============================================================================
//  Ulohy
//==============================================================================

destructor TUloha.Destroy;
begin
  if (Strings <> nil) then
    Strings.Free;
end;

function TUloha.Solve : TStrings;
begin
  Strings := TStringList.Create;
  Result := Strings;
end;

//==============================================================================
//  Uloha c. 1
//==============================================================================

function TUloha1.NSD( Cisla : array of integer ) : integer;
var I, J : integer;
    Min : integer;
    P : array[0..100] of integer;
    PCount : integer;
begin
  Result := 1;

  Min := MAXINT;
  for I := 0 to Length( Cisla )-1 do
    if Cisla[I] < Min then
      Min := Cisla[I];

  PCount := 0;
  for I := 0 to Round( Sqrt( Min ) ) do

end;

function TUloha1.Solve : TStrings;
begin
  inherited Solve;
  Result := Strings;
  Strings.Add( 'Maturitn� ot�zka �. 1' );
  Strings.Add( '  NSD = '+IntToStr( NSD( [1,2,3,4] ) ) );
end;

//==============================================================================
//  Initialization / Finalization
//==============================================================================

procedure CreateList;
begin
  List := TList.Create;
  List.Add( TUloha1.Create );
end;

procedure DestroyList;
var I : integer;
begin
  for I := 0 to List.Count - 1 do
    TUloha( List[I] ).Free;
  List.Free;
end;

initialization
begin
  CreateList;
end;

finalization
begin
  DestroyList;
end;

end.
