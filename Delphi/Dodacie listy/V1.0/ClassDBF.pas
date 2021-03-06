unit ClassDBF;

interface

uses Classes, SysUtils, Dialogs;

type PFldDesc = ^TFldDesc;

     TFldDesc = record
       FldName : array[1..11] of char;
       FldType : char;
       FldAddr : word;
       FldLength : byte;
     end;

     THeader = record
       Compatibility : byte;
       Rok, Mesiac, Den : byte;
       Records : Longword;
       HeaderSize : word;
       RecordSize : word;
       Transaction : byte;
       Encryption : byte;
       LanguageDriver : byte;

       FldDescs : TList;
     end;

     Tdbf = class
     private
       Subor : string;
       FileStr : TFileStream;
       Rows : TList;
     protected
       function NacitajHeader : THeader;
       function NacitajFieldDescriptor : TFldDesc;
       procedure NacitajRecords;

       procedure Nacitaj;
     public
       Header : THeader;

       function Cells( Row, Col : integer ) : string;

       constructor Create( iSubor : string );
       destructor Destroy; override;
     end;

implementation

//==============================================================================
//==============================================================================
//
//                                 Constructor
//
//==============================================================================
//==============================================================================

constructor Tdbf.Create( iSubor : string );
begin
  inherited Create;
  Subor := iSubor;
  Rows := TList.Create;

  Nacitaj;
end;

//==============================================================================
//==============================================================================
//
//                                 Destructor
//
//==============================================================================
//==============================================================================

destructor Tdbf.Destroy;
var I : integer;
begin
  if Header.FldDescs <> nil then
    begin
      for I := 0 to Header.FldDescs.Count-1 do
        Dispose( PFldDesc( Header.FldDescs[I] ) );
      Header.FldDescs.Free;
    end;

  for I := 0 to Rows.Count-1 do
    FreeMem( Rows.Items[I] , Header.RecordSize );
  Rows.Free;
  inherited;
end;

//==============================================================================
//==============================================================================
//
//                          Na��tavanie d�t zo s�boru :
//
//==============================================================================
//==============================================================================

function Tdbf.NacitajHeader : THeader;
begin
  with FileStr do
    begin
      Read( Result.Compatibility , 1 );
      Read( Result.Rok , 1 );
      Read( Result.Mesiac , 1 );
      Read( Result.Den , 1 );
      Read( Result.Records , 4 );
      Read( Result.HeaderSize , 2 );
      Read( Result.RecordSize , 2 );
      Seek( 2 , soFromCurrent );
      Read( Result.Transaction , 1 );
      Read( Result.Encryption , 1 );
      Seek( 13 , soFromCurrent );
      Read( Result.LanguageDriver , 1 );
      Seek( 2 , soFromCurrent );
    end;
end;

function Tdbf.NacitajFieldDescriptor : TFldDesc;
begin
  with FileStr do
    begin
      Read( Result.FldName , 11 );
      Read( Result.FldType , 1 );
      Read( Result.FldAddr , 2 );
      Seek( 2 , soFromCurrent );
      Read( Result.FldLength , 1 );
      Seek( 15 , soFromCurrent );
    end;
end;

procedure Tdbf.NacitajRecords;
var I : integer;
    P : pointer;
begin
  for I := 0 to Header.Records-1 do
    begin
      GetMem( P , Header.RecordSize );
      Rows.Add( P );
      FileStr.Read( P^ , Header.RecordSize );
    end;
end;

procedure Tdbf.Nacitaj;
var PNewFldDesc : PFldDesc;
    Koniec : byte;
begin
  FileStr := TFileStream.Create( Subor , fmOpenRead or fmShareExclusive );
  
  //Na��tanie hlavi�ky a popisu jednotliv�ch pol� (Field descriptors)
  Header := NacitajHeader;
  Header.FldDescs := TList.Create;
  repeat
    New( PNewFldDesc );
    PNewFldDesc^ := NacitajFieldDescriptor;
    Header.FldDescs.Add( PNewFldDesc );
  until FileStr.Position >= Header.HeaderSize-1;

  FileStr.Read( Koniec , 1 );
  if Koniec <> $0D then
    begin
      MessageDlg( 'Nebol n�jden� koniec hlavi�ky!' , mtError , [mbOK] , 0 );
      FileStr.Free;
      Exit;
    end;

  //Na��tanie tabu�ky
  NacitajRecords;

  FileStr.Free;
end;

//==============================================================================
//==============================================================================
//
//                          Pr�stup k jednotliv�m bunk�m
//
//==============================================================================
//==============================================================================

function Tdbf.Cells( Row, Col : integer ) : string;
type TZnak = record
       Z : array[1..2] of byte;
       Znak : char;
     end;
const Znaky : array[1..13] of TZnak =
      ((Z:($00, $A0) ; Znak:'�' ),
       (Z:($00, $84) ; Znak:'�' ),
       (Z:($80, $87) ; Znak:'�' ),
       (Z:($00, $82) ; Znak:'�' ),
       (Z:($00, $A1) ; Znak:'�' ),
       (Z:($9C, $8C) ; Znak:'�' ),
       (Z:($00, $A4) ; Znak:'�' ),
       (Z:($9B, $A8) ; Znak:'�' ),
       (Z:($00, $9F) ; Znak:'�' ),
       (Z:($00, $97) ; Znak:'�' ),
       (Z:($00, $98) ; Znak:'�' ),
       (Z:($00, $93) ; Znak:'�' ),
       (Z:($92, $91) ; Znak:'�' ));

var I, J, K : integer;
    P : pointer;
    S : string;

label Pokracuj;

begin
  P := Rows.Items[Row-1];
  P := Ptr( LongWord( P ) + TFldDesc( Header.FldDescs.Items[Col-1]^ ).FldAddr );

  Result := '';
  for I := 1 to TFldDesc( Header.FldDescs.Items[Col-1]^ ).FldLength do
    Result := Result + Char( Ptr( LongWord( P ) + LongWord( I - 1 ) )^ );

  //Form�tovanie stringu :
  if TFldDesc( Header.FldDescs.Items[Col-1]^ ).FldType = 'C' then
    begin
      S := Result;
      Result := '';
      I := 1;
      while (S[I] = ' ') and
            (I < Length(S)) do Inc( I );
      while (I <= Length(S)) do
        begin
          for J := 1 to 13 do
            for K := 1 to 2 do
              if Ord( S[I] ) = Znaky[J].Z[K] then
                begin
                  if K = 1 then S[I] := UpCase( Znaky[J].Znak )
                           else S[I] := Znaky[J].Znak;
                  goto Pokracuj;
                end;
          Pokracuj : Result := Result + S[I];
          Inc( I );
        end;
      I := Length( Result );
      while Result[I] = ' ' do
        Dec( I );
      if I <> Length( Result ) then Delete( Result , I+1 , Length( Result ) - I );
    end;

  //Form�tovanie floatu :
  if TFldDesc( Header.FldDescs.Items[Col-1]^ ).FldType = 'N' then
    begin
      S := Result;
      Result := '';
      I := 1;
      while (S[I] = ' ') and
            (I < Length(S)) do Inc( I );
      while (S[I] <> '.') and
            (I <= Length(S)) do
        begin
          Result := Result + S[I];
          Inc( I );
        end;
      if I > Length(S) then exit;
      Result := Result + ',';
      Inc( I );
      while I <= Length( S ) do
        begin
          Result := Result + S[I];
          Inc( I );
        end;
    end;

  //Form�tovanie d�tumu :
  if TFldDesc( Header.FldDescs.Items[Col-1]^ ).FldType = 'D' then
    begin
      S := Result;
      Result := Copy( S , 7 , 2 ) + '.' + Copy( S , 5 , 2 ) + '.' + Copy( S , 1 , 4 );
    end;
end;

end.

