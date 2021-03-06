unit ClassZakList;

interface

uses Classes, Graphics, Dbtables, Db;

const PageMargin = 50;

type TZakazList = class
	 private
       Query : TQuery;
              
	   procedure PrintAtPos( Canvas : TCanvas; X, Y, Width, Height : integer );

	 public
	   ZakListCislo : string;
	   Odberatel : TStringList;
	   ObjCislo : string;
	   DatumPrij : string;
	   VybDna : string;
	   Zaruka : boolean;
	   DruhZar : TStringList;
	   PopisPor : TStringList;
	   Prisl : TStringList;
	   PopisVyk : TStringList;
	   PrislVyk : TStringList;

	   constructor Create;
	   destructor Destroy; override;

	   procedure Clear;

	   procedure Print( Canvas : TCanvas; Width, Height : integer );
       procedure Save( FileName : string );
       procedure Open( FileName : string );

       function GetAndIncCounter : integer;
	 end;

implementation

uses Dialogs, SysUtils;

// Constructor

constructor TZakazList.Create;
begin
  inherited;
  Odberatel := TStringList.Create;
  DruhZar := TStringList.Create;
  PopisPor := TStringList.Create;
  Prisl := TStringList.Create;
  PopisVyk := TStringList.Create;
  PrislVyk := TStringList.Create;

  Query := TQuery.Create( nil );

  Clear;
end;

// Destructor

destructor TZakazList.Destroy;
begin
  Query.Free;

  Odberatel.Free;
  DruhZar.Free;
  PopisPor.Free;
  Prisl.Free;
  PopisVyk.Free;
  PrislVyk.Free;
  inherited;
end;

function TZakazList.GetAndIncCounter : integer;
begin
  Query.Active := False;
  Query.DatabaseName := 'PcPrompt';
  Query.SQL.Clear;
  Query.SQL.Add( 'SELECT (counter.number) FROM counter' );
  Query.Active := True;
  Query.First;
  Result := Query.Fields[0].AsInteger;

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add( 'DELETE FROM counter WHERE number = ' + IntToStr( Result ) );
  Query.ExecSQL;

  Query.SQL.Clear;
  Query.SQL.Add( 'INSERT INTO counter (number) VALUES ('+ IntToStr( Result + 1 ) +')' );
  Query.ExecSQL;
end;

procedure TZakazList.PrintAtPos( Canvas : TCanvas; X, Y, Width, Height : integer );
const Margin = 50;
var I, J, K : integer;
	dX, dY : integer;
begin
  // Bounding rectangle
  Canvas.Pen.Color := clBlack;
  Canvas.Pen.Width := 1;

  Canvas.Rectangle( X , Y , X+Width , Y+Height );

  // Top header
  Canvas.MoveTo( X , Y+250 );
  Canvas.LineTo( X+Width , Y+250 );

  // Center texts
  dX := X;
  dY := Y+250;

  Canvas.MoveTo( dX , dY+8*Margin );
  Canvas.LineTo( dX+Width , dY+8*Margin );

  Canvas.TextOut( dX+Margin , dY+Margin , 'Z�kazkov� list �. :' );
  Canvas.TextOut( dX+Margin+300 , dY+Margin , ZakListCislo );

  Canvas.TextOut( dX+Margin , dY+2*Margin , 'Odberate� :' );
  J := Odberatel.Count;
  if (J > 5) then
	J := 5;
  for I := 0 to J-1  do
	Canvas.TextOut( dX+Margin+300 , dY+(2+I)*Margin , Odberatel[I] );

  Canvas.TextOut( dX+Margin , dY+7*Margin , 'Objedn�vka �. :' );
  Canvas.TextOut( dX+Margin+300 , dY+7*Margin , ObjCislo );

  Canvas.TextOut( dX+((Width div 4)*3) , dY+Margin , 'D�tum prijatia :' );
  Canvas.TextOut( dX+((Width div 4)*3)+300 , dY+Margin , DatumPrij );

  Canvas.TextOut( dX+((Width div 4)*3) , dY+2*Margin , 'Vybaven� d�a :' );
  Canvas.TextOut( dX+((Width div 4)*3)+300 , dY+2*Margin , VybDna );

  Canvas.TextOut( dX+((Width div 4)*3) , dY+7*Margin , 'Z�ruka :' );
  if (Zaruka) then
	Canvas.TextOut( dX+((Width div 4)*3)+300 , dY+7*Margin , '�no' )
  else
	Canvas.TextOut( dX+((Width div 4)*3)+300 , dY+7*Margin , 'Nie' );

  // Bottom texts
  dX := X;
  dY := dY + 8*Margin;

  Canvas.Brush.Color := clLtGray;
  Canvas.Brush.Style := bsSolid;

  Canvas.Rectangle( dX , dY , dX + Width , dY + Margin );

  Canvas.MoveTo( dX+(Width div 2) , dY );
  Canvas.LineTo( dX+(Width div 2) , Y + Height );

  Canvas.MoveTo( dX , dY + Margin );
  Canvas.LineTo( dX + Width , dY + Margin );

  Canvas.TextOut( dX + (Width div 4)-(Canvas.TextWidth( 'Pr�jem' ) div 2) , dY + 1, 'Pr�jem' );
  Canvas.TextOut( dX + 3*(Width div 4)-(Canvas.TextWidth( 'V�daj' ) div 2) , dY + 1, 'V�daj' );

  Canvas.Brush.Color := clWhite;

  dY := dY + Margin;
  I := (Height - (dY - Y)) div 5;

  Canvas.MoveTo( dX , dY + I );
  Canvas.LineTo( dX + (Width div 2) , dY + I );

  Canvas.TextOut( dX + Margin , dY + 1 , 'Druh zariadenia :' );
  K := DruhZar.Count;
  if (K > 2) then
	K := 2;
  for J := 0 to K-1 do
	Canvas.TextOut( dX + Margin , dY + 1 + (J+1)*Margin , DruhZar[J] );

  Canvas.TextOut( dX + (Width div 2) + Margin , dY + 1 , 'Popis v�konu :' );
  K := PopisVyk.Count;
  if (K > 5) then
	K := 5;
  for J := 0 to K-1 do
	Canvas.TextOut( dX + (Width div 2) + Margin , dY + 1 + (J+1)*Margin , PopisVyk[J] );

  Canvas.MoveTo( dX , dY + 2*I );
  Canvas.LineTo( dX + Width , dY + 2*I );

  Canvas.TextOut( dX + Margin , dY + I + 1 , 'Popis poruchy :' );
  K := PopisPor.Count;
  if (K > 2) then
	K := 2;
  for J := 0 to K-1 do
	Canvas.TextOut( dX + Margin , dY + I + 1 + (J+1)*Margin , PopisPor[J] );


  Canvas.MoveTo( dX , dY + 3*I );
  Canvas.LineTo( dX + Width , dY + 3*I );

  Canvas.TextOut( dX + Margin , dY + 2*I + 1, 'Pr�slu�enstvo :' );
  K := Prisl.Count;
  if (K > 2) then
	K := 2;
  for J := 0 to K-1 do
	Canvas.TextOut( dX + Margin , dY + 2*I + 1 + (J+1)*Margin , Prisl[J] );

  Canvas.TextOut( dX + (Width div 2) + Margin , dY + 2*I + 1 , 'Pr�slu�enstvo :' );
  K := PrislVyk.Count;
  if (K > 2) then
	K := 2;
  for J := 0 to K-1 do
	Canvas.TextOut( dX + (Width div 2) + Margin , dY + 2*I + 1 + (J+1)*Margin , PrislVyk[J] );

  Canvas.TextOut( dX + (Width div 4)-(Canvas.TextWidth( 'Pr�jem do opravy' ) div 2) , Y + Height - Margin , 'Pr�jem do opravy' );
  Canvas.TextOut( dX + 3*(Width div 4)-(Canvas.TextWidth( 'Prevzatie z opravy' ) div 2) , Y + Height - Margin , 'Prevzatie z opravy' );
end;

procedure TZakazList.Clear;
begin
  Odberatel.Clear;
  DruhZar.Clear;
  PopisPor.Clear;
  Prisl.Clear;
  PopisVyk.Clear;
  PrislVyk.Clear;
  ZakListCislo := '';
  ObjCislo := '';
  DatumPrij := '';
  VybDna := '';
  Zaruka := true;
end;

procedure TZakazList.Print( Canvas : TCanvas; Width, Height : integer );
begin
  PrintAtPos( Canvas , PageMargin , PageMargin , Width-2*PageMargin , (Height-3*PageMargin) div 2 );

  // Dividing line
  Canvas.Pen.Style := psDash;
  Canvas.MoveTo( 0 , Height div 2 );
  Canvas.LineTo( Width , Height div 2 );
  Canvas.Pen.Style := psSolid; 

  PrintAtPos( Canvas , PageMargin , (Height+PageMargin) div 2 , Width-2*PageMargin , (Height-3*PageMargin) div 2 );
end;

procedure TZakazList.Save( FileName : string );
var F : TextFile;

procedure WriteStrings( Strings : TStrings );
var I : integer;
begin
  Writeln( F , Strings.Count );
  for I := 0 to Strings.Count-1 do
    Writeln( F , Strings[I] );
end;

begin
  AssignFile( F , FileName );
  try
    Rewrite( F );

    Writeln( F , ZakListCislo );
    Writeln( F , ObjCislo );
    Writeln( F , DatumPrij );
    Writeln( F , VybDna );
    if (Zaruka) then
      Writeln( F , 'ANO' )
    else
      Writeln( F , 'NIE' );

    WriteStrings( Odberatel );
    WriteStrings( DruhZar );
    WriteStrings( PopisPor );
    WriteStrings( Prisl );
    WriteStrings( PopisVyk );
    WriteStrings( PrislVyk );
  finally
    CloseFile( F );
  end;
end;

procedure TZakazList.Open( FileName : string );
var F : TextFile;
    S : string;

procedure ReadStrings( Strings : TStrings );
var I, J : integer;
begin
  Readln( F , J );
  for I := 0 to J-1 do
    begin
      Readln( F , S );
      Strings.Add( S );
    end;
end;

begin
  Clear;

  AssignFile( F , FileName );
  try
    Reset( F );

    Readln( F , ZakListCislo );
    Readln( F , ObjCislo );
    Readln( F , DatumPrij );
    Readln( F , VybDna );
    Readln( F , S );
    Zaruka := (S = 'ANO');

    ReadStrings( Odberatel );
    ReadStrings( DruhZar );
    ReadStrings( PopisPor );
    ReadStrings( Prisl );
    ReadStrings( PopisVyk );
    ReadStrings( PrislVyk );
  finally
    CloseFile( F );
  end;
end;

end.
