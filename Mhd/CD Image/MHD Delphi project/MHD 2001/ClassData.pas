unit ClassData;

interface

uses Controls, Classes, Windows, SysUtils;

type EDataError = class( Exception );

     PZastavka = ^TZastavka;
     PSpoj = ^TSpoj;
     PRozvrhy = ^TRozvrhy;
     PRozvrh = ^TRozvrh;
     PMinuty = ^TMinuty;
     PSpojInfo = ^TSpojInfo;

     TBlizka = record
       Min : integer;
       Zast : PZastavka;
     end;

     TZastavka = record
       Nazov : string;
       Pasmo : byte;
       NaZnamenie : boolean;

       Spoje : TList;
       BlizkeZast : array of TBlizka;
       Cislo : integer;

       Sur : TPoint;
     end;

     TStav = (Plus,Minus,Normal);

     TSpoj = record
       Cislo : integer;
       Typ : byte;
       {TYP
          0 - autobus
          1 - elektricka
          2 - trolejbus
          3 - nocak
        }
       Stav : TStav;

       Rozvrhy : PRozvrhy;
       NaZastavke : PZastavka;

       Info : PSpojInfo;
       Opacny : PSpoj;
       Next, Prev : PSpoj;
       NextMin : integer;
     end;

     TRozvrhy = record
       Zvlast : boolean;
       Rozvrh : array[0..3] of PRozvrh;
     end;

     TRozvrh = array[0..23] of PMinuty;

     TMinuty = record
       Stav : TStav;
       Cas : byte;
       Next : PMinuty;
     end;

     TSpojInfo = record
       Zaciatok, Koniec : PZastavka;
       Spoj, OpacnySpoj  : PSpoj;
     end;

     TData = class
     private
       EsteNeplatne, UzNeplatne : TStringList;
       FPeso : integer;

       //DATA :

       //pomocne procedury :
       procedure SpracujRiadokP( S : string; var Pasmo : byte; var Nazov : string );
       procedure SpracujRiadokO( S : string; var Offset : byte; var Nazov : string );

       procedure DealokujRozvrhy( Rozvrhy : PRozvrhy );

       procedure DataNacitajSubory;
         procedure SpravZoznamZastavok;
           procedure NacitajZastavky( Subor : string );
           procedure ZoradZastavky;
         procedure PriradZastavkeRozvrh;
           procedure NacitajRozvrh( Subor : string );
             function CisloZastavky( Zastavka : string ) : word;
             procedure PriradRozvrh( PNewRozvrhy : PRozvrhy; OldRozvrhy : TRozvrhy; Offset : word; Spoj : PSpoj );
         procedure UpravSpojeInfo;
       procedure DataPriradZastavkamSur;

       procedure VypisNeplatne;

       procedure SetPeso( Value : integer );
     public
       //Data :
       Zastavky : TList;
       SpojeInfo : TList;
       ZoznamSpojov : TList;

       constructor Create;
       destructor Destroy; override;

       property Peso : integer read FPeso write SetPeso;
     end;

var Data : TData;

implementation

uses Graphics, Dialogs, Konstanty;

//==============================================================================
//==============================================================================
//
//                                    Constructor
//
//==============================================================================
//==============================================================================

constructor TData.Create;
begin
  inherited Create;
  Zastavky := TList.Create;
  SpojeInfo := TList.Create;
  ZoznamSpojov := TList.Create;
  EsteNeplatne := TStringList.Create;
  UzNeplatne := TStringList.Create;

  try
    //DATA :
    DataNacitajSubory;
    DataPriradZastavkamSur;
  except
  end;

  VypisNeplatne;

  EsteNeplatne.Free;
  UzNeplatne.Free;
end;

//==============================================================================
//==============================================================================
//
//                                     Destructor
//
//==============================================================================
//==============================================================================

procedure TData.DealokujRozvrhy( Rozvrhy : PRozvrhy );
var I, J : integer;
    P1, P2 : PMinuty;
begin
  for I := 0 to 2 do
    begin
      for J := 0 to 23 do
        begin
          P1 := Rozvrhy.Rozvrh[I]^[J];
          while P1 <> nil do
            begin
              P2 := P1^.Next;
              Dispose( P1 );
              P1 := P2;
            end;
        end;
      Dispose( PRozvrh( Rozvrhy.Rozvrh[I] ) );
    end;
end;

destructor TData.Destroy;
var I,J : integer;
begin
  //ROZVRHY :
  for I := 0 to Zastavky.Count-1 do
    begin
      for J := 0 to TZastavka( Zastavky[I]^ ).Spoje.Count-1 do
        begin
          DealokujRozvrhy( PRozvrhy( TSpoj( TZastavka( Zastavky[I]^ ).Spoje[J]^ ).Rozvrhy ) );
          Dispose( PSpoj( TZastavka( Zastavky[I]^ ).Spoje[J] ) );
        end;
      TZastavka( Zastavky[I]^ ).Spoje.Free;
      SetLength( TZastavka( Zastavky[I]^ ).BlizkeZast , 0 );
      Dispose( PZastavka( Zastavky[I] ) );
    end;
  Zastavky.Free;

  for I := 0 to SpojeInfo.Count-1 do
    Dispose( PSpojInfo( SpojeInfo[I] ) );
  SpojeInfo.Free;

  ZoznamSpojov.Free;
  inherited;
end;

//==============================================================================
//==============================================================================
//
//                               Pomocne procedury
//
//==============================================================================
//==============================================================================

//==============================================================================
//==============================================================================
//
//                                   D A T A
//
//==============================================================================
//==============================================================================

//==============================================================================
//  Pomocne procedury
//==============================================================================

procedure TData.SpracujRiadokP( S : string; var Pasmo : byte; var Nazov : string );
var I : integer;
    PomS : string;
begin
  Pasmo := 0;
  Nazov := '';

  if S = '' then exit;

  I := 1;

  while S[I] <> ' ' do
    Inc( I );

  Inc( I );

  PomS := '';
  while S[I] <> ' ' do
    begin
      PomS := PomS + S[I];
      Inc( I );
    end;
  Pasmo := StrToInt( PomS );

  Inc( I );
  while I <= Length( S ) do
    begin
      Nazov := Nazov + S[I];
      Inc( I );
    end;
end;

procedure TData.SpracujRiadokO( S : string; var Offset : byte; var Nazov : string );
var I : integer;
    PomS : string;
begin
  Nazov := '';

  if S = '' then exit;

  I := 1;

  PomS := '';
  while S[I] <> ' ' do
    begin
      PomS := PomS + S[I];
      Inc( I );
    end;
  Offset := StrToInt( PomS );

  Inc( I );

  while S[I] <> ' ' do
    Inc( I );

  Inc( I );
  while I <= Length( S ) do
    begin
      Nazov := Nazov + S[I];
      Inc( I );
    end;
end;

//==============================================================================
//  Zoznam zastavok
//==============================================================================

procedure TData.NacitajZastavky( Subor : string );
var Fin : TextFile;

    PlatnyOd, PlatnyDo, DatumDnes : string;
    Den, Mes, Rok : word;
    DenDnes, MesDnes, RokDnes : word;

    PNovaZastavka : PZastavka;

    CisloSpoja : string;
    Nazov : string;
    Pasmo : byte;

    S : string;

    I : integer;

begin
  AssignFile( Fin , Subor );
  {$I-}
  Reset( Fin );
  {$I+}
  if IOResult <> 0 then
    raise EDataError.Create( 'Ned� sa otvori� datov� s�bor '+Subor+' !' );

  Readln( Fin , CisloSpoja );
  Readln( Fin , S );

  //Aktualny datum :
  DateTimeToString( DatumDnes , 'ddmmyyyy' , Date );
  DenDnes := StrToInt( Copy( DatumDnes , 1 , 2 ) );
  MesDnes := StrToInt( Copy( DatumDnes , 3 , 2 ) );
  RokDnes := StrToInt( Copy( DatumDnes , 5 , 4 ) );

  //Platnost od :
  Readln( Fin , PlatnyOd );
  Den := StrToInt( Copy( PlatnyOd , 1 , 2 ) );
  Mes := StrToInt( Copy( PlatnyOd , 4 , 2 ) );
  Rok := StrToInt( Copy( PlatnyOd , 7 , 4 ) );

  if (RokDnes < Rok) or
     ((RokDnes = Rok) and
      ((MesDnes < Mes) or
       ((MesDnes = Mes) and
        (DenDnes < Den)))) then
          EsteNeplatne.Add( CisloSpoja );

  //Platnost do :
  Readln( Fin , PlatnyDo );
  Den := StrToInt( Copy( PlatnyDo , 1 , 2 ) );
  Mes := StrToInt( Copy( PlatnyDo , 4 , 2 ) );
  Rok := StrToInt( Copy( PlatnyDo , 7 , 4 ) );

  if (RokDnes > Rok) or
     ((RokDnes = Rok) and
      ((MesDnes > Mes) or
       ((MesDnes = Mes) and
        (DenDnes > Den)))) then
          UzNeplatne.Add( CisloSpoja );

  Readln( Fin , S );
  SpracujRiadokP( S , Pasmo , Nazov );
  repeat
    try
      New( PNovaZastavka );
      Zastavky.Add( PNovaZastavka );
    except
      raise EDataError.Create( 'Nedostatok pam�te !' );
    end;

    Delete( Nazov , Pos( '+' , Nazov ) , 1 ) ;
    I := Pos( '-' , Nazov );
    if (I > 0) and
       (I < 3) then
      Delete( Nazov , I , 1 ) ;
    if Nazov[1] = 'z' then
      begin
        Delete( Nazov , 1 , 1 );
        PNovaZastavka^.NaZnamenie := True;
      end
        else
      PNovaZastavka^.NaZnamenie := False;

    PNovaZastavka^.Nazov := Nazov;
    PNovaZastavka^.Pasmo := Pasmo;
    PNovaZastavka^.Sur.X := 0;
    PNovaZastavka^.Sur.Y := 0;

    Readln( Fin , S );
    SpracujRiadokP( S , Pasmo , Nazov );
  until Nazov = 'KONIEC';

  CloseFile( Fin );
end;

function Porovnaj( P1, P2 : pointer ) : integer;
var S1, S2 : string;
begin
  S1 := string( P1^ );
  S2 := string( P2^ );

  Result := 0;
  if S1 = S2 then
    exit;

  if S1 < S2 then Result := -1;
  if S1 > S2 then Result := 1;
end;

procedure TData.ZoradZastavky;
var I : integer;
begin
  Zastavky.Sort( Porovnaj );

  for I := 1 to Zastavky.Count-1 do
    if (TZastavka( Zastavky[I-1]^ ).Nazov = TZastavka( Zastavky[I]^ ).Nazov) then
      begin
        Dispose( PZastavka( Zastavky[I-1] ) );
        Zastavky[I-1] := nil;
      end;

  Zastavky.Pack;

  for I := 0 to Zastavky.Count-1 do
    TZastavka( Zastavky[I]^ ).Cislo := I;
end;

procedure TData.SpravZoznamZastavok;
var SR : TSearchRec;
    I : integer;
begin
  FindFirst( ROZVRHY_DIR+'\*.mhd' , faAnyFile , SR );

  NacitajZastavky( ROZVRHY_DIR+'\'+SR.Name );
  while FindNext( SR ) = 0 do
    NacitajZastavky( ROZVRHY_DIR+'\'+SR.Name );

  FindClose( SR );

  ZoradZastavky;

  for I := 0 to Zastavky.Count-1 do
    TZastavka( Zastavky[I]^ ).Spoje := TList.Create;
end;

//==============================================================================
//  Priradenie rozvrhov
//==============================================================================

function TData.CisloZastavky( Zastavka : string ) : word;
var I, J, K : integer;
begin
  I := -1;
  J := Zastavky.Count;
  K := (I+J) div 2;
  while TZastavka( Zastavky[K]^ ).Nazov <> Zastavka do
    begin
      if TZastavka( Zastavky[K]^ ).Nazov > Zastavka then J := K
                                                    else I := K;
      K := (I+J) div 2;
    end;
  Result := K;
end;

procedure TData.PriradRozvrh( PNewRozvrhy : PRozvrhy; OldRozvrhy : TRozvrhy; Offset : word; Spoj : PSpoj );
var I, J : integer;
    P1 : array[0..23] of PMinuty;
    PFrom : PMinuty;
    OldTime, NewTime : integer;
    NewHour : integer;
begin
  for I := 0 to 3 do
    begin
      New( PNewRozvrhy.Rozvrh[I] );
      for J := 0 to 23 do
        PNewRozvrhy.Rozvrh[I]^[J] := nil;
    end;

  for I := 0 to 2 do
    begin
      for J := 0 to 23 do P1[J] := nil;
      for J := 0 to 23 do
        begin
          PFrom := OldRozvrhy.Rozvrh[I]^[J];
          while PFrom <> nil do
            begin
              OldTime := PFrom^.Cas;
              NewTime := OldTime + Offset;
              NewHour := J+(NewTime div 60);

              if NewHour > 23 then break;

              if (Spoj^.Stav = Normal) or
                 ((Spoj^.Stav = Plus) and
                  (PFrom^.Stav = Plus)) or
                 ((Spoj^.Stav = Minus) and
                  (PFrom^.Stav <> Minus)) then
                begin
                  if P1[NewHour] = nil then
                    begin
                      New( PNewRozvrhy.Rozvrh[I]^[NewHour] );
                      P1[NewHour] := PNewRozvrhy.Rozvrh[I]^[NewHour];
                    end
                      else
                    begin
                      New( P1[NewHour]^.Next );
                      P1[NewHour] := P1[NewHour]^.Next;
                    end;

                  P1[NewHour]^.Cas := NewTime-((NewTime div 60)*60);
                  P1[NewHour]^.Next := nil;
                  P1[NewHour]^.Stav := PFrom^.Stav;
                end;

              PFrom := PFrom^.Next;
            end;
        end;
    end;
end;

procedure TData.NacitajRozvrh( Subor : string );
var CisloSpoja : byte;
    TypSpoja : char;
    Nazov : string;
    Off : byte;

    Zoznam : array[1..100] of
      record
        Stav : TStav;
        Cislo : word;
        Offset : byte;
      end;
    Pocet : byte;

    Rozvrhy : TRozvrhy;
    PNewMinuty, P1 : PMinuty;

    PNewSpoj : PSpoj;
    PNewRozvrhy : PRozvrhy;
    Dalsi : PSpoj;

    PNewSpojInfo : PSpojInfo;

    I, J, K, N : integer;
    S : string;

function NacitajMinuty : PMinuty;
var c : char;
    S : string;
begin
  Result := nil;

  Read( c );
  while (c = ' ') and
        (not EoLn( Input )) do
    Read( c );
  if EoLn( Input ) then
    begin
      readln;
      exit;
    end;

  S := c;
  repeat
    Read( c );
    if c <> ' ' then S := S + c;
  until (c = ' ') or
        (EoLn( Input ));

  if EoLn( Input ) then readln;

  if S = '-1' then exit;

  New( Result );

  c := S[Length(S)];
  case c of
    '+' : begin
            Result^.Stav := Plus;
            Delete( S , Length(S) , 1 );
          end;
    '-' : begin
            Result^.Stav := Minus;
            Delete( S , Length(S) , 1 );
          end;
    else Result^.Stav := Normal;
  end;

  Result^.Cas := StrToInt( S );
  Result^.Next := nil;
end;

begin
  AssignFile( Input , Subor );
  {$I-}
  Reset( Input );
  {$I+}
  if IOResult <> 0 then
    raise EDataError.Create( 'Ned� sa otvori� datov� s�bor '+Subor+' !' );

  Readln( CisloSpoja );
  Readln( TypSpoja );

  //  Vytvorenie zoznamu zastavok :
  Readln;
  Readln;

  Pocet := 0;
  Off := 0;

  Readln( S );
  SpracujRiadokO( S , Off , Nazov );

  repeat
    Inc( Pocet );
    Zoznam[ Pocet ].Stav := Normal;
    if Pos( '+' , Nazov ) > 0 then
      begin
        Delete( Nazov , Pos( '+' , Nazov ) , 1 );
        Zoznam[ Pocet ].Stav := Plus;
      end
        else
      begin
        I := Pos( '-' , Nazov );
        if (I > 0) and
           (I < 3) then
          begin
            Delete( Nazov , I , 1 );
            Zoznam[ Pocet ].Stav := Minus;
          end;
      end;

    if Nazov[1] = 'z' then Delete( Nazov , 1 , 1 );

    Zoznam[ Pocet ].Cislo := CisloZastavky( Nazov );
    Zoznam[ Pocet ].Offset := Off;

    Readln( S );
    SpracujRiadokO( S , Off , Nazov );
  until Nazov = 'KONIEC';

  Readln( N );

  //  Nacitanie zakladneho rozvrhu :
  for K := 0 to N-1 do
    begin
      New( PRozvrh( Rozvrhy.Rozvrh[K] ) );
      for I := 0 to 23 do
        begin
          Rozvrhy.Rozvrh[K]^[I] := nil;

          PNewMinuty := NacitajMinuty;
          if PNewMinuty = nil then continue;

          Rozvrhy.Rozvrh[K]^[I] := PNewMinuty;

          P1 := Rozvrhy.Rozvrh[K]^[I];
          repeat
            PNewMinuty := NacitajMinuty;
            P1^.Next := PNewMinuty;
            P1 := PNewMinuty;
          until P1 = nil;
        end;
    end;

  //  Vytvorenie noveho spoja :
  Dalsi := nil;
  for I := Pocet downto 1 do
    begin
      New( PNewSpoj );
      if (Dalsi <> nil) then Dalsi^.Prev := PNewSpoj;

      if I = 1 then
        begin
          New( PNewSpojInfo );
          SpojeInfo.Add( PNewSpojInfo );

          PNewSpojInfo^.Spoj := PNewSpoj;
          PNewSpojInfo^.OpacnySpoj := nil;
          PNewSpojInfo^.Zaciatok := Zastavky[ Zoznam[1].Cislo ];
          PNewSpojInfo^.Koniec := Zastavky[ Zoznam[Pocet].Cislo ];
        end;

      with TZastavka( Zastavky[ Zoznam[I].Cislo ]^ ) do
        begin
          PNewSpoj^.Cislo := CisloSpoja;
          PNewSpoj^.Opacny := nil;

          K := -1;
          for J := 0 to Spoje.Count-1 do
            if TSpoj( Spoje[J]^ ).Cislo = PNewSpoj^.Cislo then
              begin
                if (TSpoj( Spoje[J]^ ).Opacny <> nil) then break;
                K := 0;
                TSpoj( Spoje[J]^ ).Opacny := PNewSpoj;
                PNewSpoj^.Opacny := PSpoj( Spoje[J] );
                break;
              end;

          if K = -1 then Spoje.Add( PNewSpoj );

          with PNewSpoj^ do
            begin
              Cislo := CisloSpoja;
              case TypSpoja of
                'A' : Typ := 0;
                'E' : Typ := 1;
                'T' : Typ := 2;
                'N' : Typ := 3;
              end;
              Stav := Zoznam[I].Stav;
              Info := nil;

              New( PNewRozvrhy );
              Rozvrhy := PNewRozvrhy;
              Next := Dalsi;
              Prev := nil;
              NaZastavke := PZastavka( Zastavky[ Zoznam[I].Cislo ] );

              Dalsi := PNewSpoj;
            end;
        end;

      if I < Pocet then
        PNewSpoj^.NextMin := Zoznam[I+1].Offset-Zoznam[I].Offset
          else
        PNewSpoj^.NextMin := 0;

      PriradRozvrh( PNewRozvrhy , Rozvrhy , Zoznam[I].Offset , PNewSpoj );
    end;

  //  Dealokacia :
  DealokujRozvrhy( @Rozvrhy );

  CloseFile( Input );
end;

procedure TData.PriradZastavkeRozvrh;
var SR : TSearchRec;
begin
  FindFirst( ROZVRHY_DIR+'\*.mhd' , faAnyFile , SR );
  repeat
    NacitajRozvrh( ROZVRHY_DIR+'\'+SR.Name );
  until FindNext( SR ) <> 0;
end;

//==============================================================================
//  Upravenie inform�cii o spojoch
//==============================================================================

function PorovnajSpojeInfo( P1 , P2 : pointer ) : integer;
begin
  Result := 0;
  if TSpojInfo( P1^ ).Spoj^.Cislo < TSpojInfo( P2^ ).Spoj^.Cislo then Result := -1;
  if TSpojInfo( P1^ ).Spoj^.Cislo > TSpojInfo( P2^ ).Spoj^.Cislo then Result := 1;
end;

procedure TData.UpravSpojeInfo;
var I, J : integer;
    Spoj : PSpoj;
    PNewInfo : PSpojInfo;
begin
  SpojeInfo.Sort( PorovnajSpojeInfo );

  for I := 1 to SpojeInfo.Count-1 do
    if TSpojInfo( SpojeInfo[I-1]^ ).Spoj^.Cislo = TSpojInfo( SpojeInfo[I]^ ).Spoj^.Cislo then
      begin
        TSpojInfo( SpojeInfo[I]^ ).OpacnySpoj := TSpojInfo( SpojeInfo[I-1]^ ).Spoj;
        Dispose( PSpojInfo( SpojeInfo[I-1] ) );
        SpojeInfo[I-1] := nil;
      end;

  SpojeInfo.Pack;

  ZoznamSpojov.Clear;
  J := SpojeInfo.Count-1;
  for I := 0 to J do
    begin
      ZoznamSpojov.Add( SpojeInfo[I] );

      Spoj := TSpojInfo( SpojeInfo[I]^ ).Spoj;
      while Spoj <> nil do
        begin
          Spoj^.Info := PSpojInfo( SpojeInfo[I] );
          Spoj := Spoj^.Next;
        end;

      New( PNewInfo );
      SpojeInfo.Add( PNewInfo );
      with PNewInfo^ do
        begin
          Zaciatok := PSpojInfo( SpojeInfo[I] )^.Koniec;
          Koniec := PSpojInfo( SpojeInfo[I] )^.Zaciatok;
          Spoj := TSpojInfo( SpojeInfo[I]^ ).OpacnySpoj;
          OpacnySpoj := TSpojInfo( SpojeInfo[I]^ ).Spoj;
        end;

      Spoj := TSpojInfo( SpojeInfo[I]^ ).OpacnySpoj;
      while Spoj <> nil do
        begin
          Spoj^.Info := PNewInfo;
          Spoj := Spoj^.Next;
        end;
    end;
end;

//==============================================================================
//  Nacitanie datovych suborov
//==============================================================================

procedure TData.DataNacitajSubory;
var SR : TSearchRec;
begin
  if FindFirst( ROZVRHY_DIR+'\*.mhd' , faAnyFile , SR ) <> 0 then
    raise EDataError.Create( 'Nebol n�jden� �iadny datov� s�bor!' );
  FindClose( SR );

  SpravZoznamZastavok;
  PriradZastavkeRozvrh;
  UpravSpojeInfo;
end;

//==============================================================================
//  Prirad zastavkam suradnice
//==============================================================================

procedure TData.DataPriradZastavkamSur;
var I : integer;
    Nazov : string;
    Suradnice : TPoint;
begin
  AssignFile( Input , ZASTAVKY_FILE );
  {$I-}
  Reset( Input );
  {$I+}
  if IOResult <> 0 then exit;

  I := 0;
  while not EoF( Input ) do
    begin
      Readln( Nazov );
      Readln( Suradnice.X );
      Readln( Suradnice.Y );

      if (Nazov > TZastavka( Zastavky[I]^ ).Nazov) then
        while (I < Zastavky.Count-1) and
              (Nazov > TZastavka( Zastavky[I]^ ).Nazov) do
                Inc( I );

      if (Nazov = TZastavka( Zastavky[I]^ ).Nazov) then
        begin
          TZastavka( Zastavky[I]^ ).Sur := Suradnice;
          if I < Zastavky.Count-1 then Inc( I );
        end;
    end;

  CloseFile( Input );
end;

//==============================================================================
//  Properties
//==============================================================================

procedure TData.SetPeso( Value : integer );
var I : integer;
    Spravene : array of boolean;
    Pixle : integer;

procedure SirSa( Cislo : integer );
var I : integer;
    d : real;
begin
  Spravene[ Cislo ] := True;
  
  for I := 0 to Zastavky.Count-1 do
    begin
      d := Round( Sqrt( Sqr( TZastavka( Zastavky[I]^ ).Sur.X - TZastavka( Zastavky[Cislo]^ ).Sur.X ) +
                  Sqr( TZastavka( Zastavky[I]^ ).Sur.Y - TZastavka( Zastavky[Cislo]^ ).Sur.Y ) ) );
      if (not Spravene[I]) and
         (d <= Pixle) then
        begin
          SetLength( TZastavka( Zastavky[I]^ ).BlizkeZast , Length( TZastavka( Zastavky[I]^ ).BlizkeZast )+1 );
          TZastavka( Zastavky[I]^ ).BlizkeZast[ Length( TZastavka( Zastavky[I]^ ).BlizkeZast )-1 ].Zast := Zastavky[ Cislo ];
          TZastavka( Zastavky[I]^ ).BlizkeZast[ Length( TZastavka( Zastavky[I]^ ).BlizkeZast )-1 ].Min := Round( d / (10*Pixle*SPEED) );

          SetLength( TZastavka( Zastavky[Cislo]^ ).BlizkeZast , Length( TZastavka( Zastavky[Cislo]^ ).BlizkeZast )+1 );
          TZastavka( Zastavky[Cislo]^ ).BlizkeZast[ Length( TZastavka( Zastavky[Cislo]^ ).BlizkeZast )-1 ].Zast := Zastavky[ I ];
          TZastavka( Zastavky[Cislo]^ ).BlizkeZast[ Length( TZastavka( Zastavky[Cislo]^ ).BlizkeZast )-1 ].Min := Round( d / (10*Pixle*SPEED) );

          SirSa( I );
        end;
    end;
end;

begin
  if (Value = FPeso) then exit;
  FPeso := Value;
  Pixle := Round( (HEKTOMETER/100)*FPeso );

  SetLength( Spravene , Zastavky.Count );
  for I := 0 to Length( Spravene )-1 do
    begin
      Spravene[I] := False;
      SetLength( TZastavka( Zastavky[I]^ ).BlizkeZast , 0 );
    end;

  if FPeso = 0 then exit;

  for I := 0 to Length( Spravene )-1 do
    if not Spravene[I] then SirSa( I );
end;

//==============================================================================
//==============================================================================
//
//                                  Neplatne
//
//==============================================================================
//==============================================================================

procedure TData.VypisNeplatne;
var I : integer;
    S : string;
begin
  S := '';
  for I := 0 to EsteNeplatne.Count-1 do
    begin
      S := S + EstenePlatne[I];
      if I < EsteNeplatne.Count-1 then S := S+', ';
    end;
  if EsteNeplatne.Count > 0 then
    MessageDlg( 'Rozvrhy t�chto spojov s� e�te neplatn� : '+S , mtWarning , [mbOk] , 0 );

  S := '';
  for I := 0 to UzNeplatne.Count-1 do
    begin
      S := S + UzNeplatne[I];
      if I < UzNeplatne.Count-1 then S := S+', ';
    end;
  if UzNeplatne.Count > 0 then
    MessageDlg( 'Rozvrhy t�chto spojov s� u� neplatn� : '+S , mtWarning , [mbOk] , 0 );
end;

end.
