unit ClassTree;

interface

const IS_WORD_FLAG   = 32;
      LAST_FLAG      = 64;
      HAS_CHILD_FLAG = 128;

type TTree = class
     public
       FData   : char;
       FWord   : boolean;
       FLeaves : array of TTree;

       constructor Create( Data : char; Word : boolean );
       destructor  Destroy; override;

       procedure   AddTree( Leave : TTree );
       function    GetTreeByData( Data : char ) : TTree;
       procedure   SetWord( Data : char );
       function    Pack : byte;
     end;

implementation

//==============================================================================
// Constructor/destructor
//==============================================================================

constructor TTree.Create( Data : char; Word : boolean );
begin
  inherited Create;
  FData := Data;
  FWord := Word;
  SetLength( FLeaves , 0 );
end;

destructor TTree.Destroy;
var I : integer;
begin
  for I := Low( FLeaves ) to High( FLeaves ) do
    FLeaves[I].Free;
  SetLength( FLeaves , 0 );
  inherited;
end;

//==============================================================================
// P U B L I C
//==============================================================================

procedure TTree.AddTree( Leave : TTree );
begin
  SetLength( FLeaves , Length( Fleaves )+1 );
  FLeaves[High( FLeaves )] := Leave;
end;

function TTree.GetTreeByData( Data : char ) : TTree;
var I : integer;
begin
  Result := nil;
  for I := Low( FLeaves ) to High( FLeaves ) do
    if (FLeaves[I].FData = Data) then
      begin
        Result := FLeaves[I];
        exit;
      end;
end;

procedure TTree.SetWord( Data : char );
var I : integer;
begin
  for I := Low( FLeaves ) to High( FLeaves ) do
    if (FLeaves[I].FData = Data) then
      begin
        FLeaves[I].FWord := true;
        exit;
      end;
end;

function TTree.Pack : byte;
begin
  Result := Ord( FData ) - Ord( 'a' );

  if (FWord) then
    Result := Result or IS_WORD_FLAG;

  if (Length( FLeaves ) > 0) then
    Result := Result or HAS_CHILD_FLAG;
end;

end.
