unit ClassUpdate;

interface

uses MySQLClass, Classes, UnitFormUpdate, UnitCennik;

type PCennikData = ^TCennikData;
     TCennikData = array of TCennik;

     TUpdate = class( TThread )
     private
       FMySQL      : TMySQL;
       FDatabase   : string;
       FOld        : PCennikData;
       FNew        : PCennikData;
       FDir        : string;

       procedure   MySQLExecute( Text : string );
       procedure   MySQLAddRecord( TabName : string; Values : array of string );
       procedure   MySQLDeleteRecord( TabName : string; Values : array of string );
       procedure   MySQLCreateTable( TabName : string; ColCount : integer; CharSize : integer );
       procedure   MySQLDeleteTable( TabName : string );

       procedure   UpdateTable( Old : TCennik; New : TCennik; IsNew : boolean );

       function    GetTableCount( Old, New : TCennik ) : integer;
       function    GetCount : integer;

       procedure   Terminate( Sender: TObject );

     protected
       procedure   Execute; override;

     public
       Strings     : TStringList;

       constructor Create( Host, User, Password, Database : string; Port : integer; Dir : string );
       destructor  Destroy; override;

       procedure   Update( Old, New : PCennikData );
     end;

implementation

uses Dialogs, SysUtils;

constructor TUpdate.Create( Host, User, Password, Database : string; Port : integer; Dir : string );
begin
  inherited Create( true );

  OnTerminate := Terminate;

  FMySQL := TMySQL.Create;
  FMySQL.Host     := Host;
  FMySQL.User     := User;
  FMySQL.Password := Password;
  FMySQL.Port     := Port;

  FDatabase := Database;
  FOld      := nil;
  FNew      := nil;
  FDir      := Dir;

  Strings := TStringList.Create;
end;

destructor TUpdate.Destroy;
begin
  Strings.Destroy;

  inherited;
end;

//==============================================================================
//  P R I V A T E
//==============================================================================

procedure TUpdate.MySQLExecute( Text : string );
begin
  if (Text = '') then
    exit;

  FMySQL.Query( Text );
end;

procedure TUpdate.MySQLAddRecord( TabName : string; Values : array of string );
var S : string;
    I : integer;
begin
  S := 'INSERT INTO ' + TabName;

  S := S + ' VALUES (';

  for I := 0 to Length( Values )-1 do
    begin
      S := S + '''' + Values[I] + '''';
      if (I < Length( Values )-1) then
        S := S + ',';
    end;

  S := S + ')';

  MySQLExecute( S );
end;

procedure TUpdate.MySQLDeleteRecord( TabName : string; Values : array of string );
var S : string;
    I : integer;
begin
  S := 'DELETE FROM ' + TabName;

  S := S + ' WHERE ';

  for I := 0 to Length( Values )-1 do
    begin
      S := S + 'COL' + IntToStr(I) + '=''' + Values[I] + '''';
      if (I < Length( Values )-1) then
        S := S + ' AND ';
    end;

  MySQLExecute( S );
end;

procedure TUpdate.MySQLCreateTable( TabName : string; ColCount : integer; CharSize : integer );
var S : string;
    I : integer;
begin
  S := 'CREATE TABLE IF NOT EXISTS ' + TabName + ' (';

  for I := 0 to ColCount-1 do
    begin
      S := S + ' COL' + IntToStr( I ) + ' TEXT';
      if (I < ColCount-1) then
        S := S + ',';
    end;

  S := S + ', FULLTEXT (COL0))';

  MySQLExecute( S );
end;

procedure TUpdate.MySQLDeleteTable( TabName : string );
begin
  MySQLExecute( 'DROP TABLE ' + TabName );
end;

procedure TUpdate.UpdateTable( Old, New : TCennik; IsNew : boolean );
var I, J, K, L : integer;
    Found : boolean;
    Same : boolean;
begin
  if (IsNew) then
    begin
      for I := 0 to Length( New.Data )-1 do
        begin
          MySQLAddRecord( New.Name , New.Data[I] );
          FormUpdate.ProgressBar.StepIt;

          Old.AddRow;
          for J := 0 to Length( New.Data[I] )-1 do
            Old.Data[Length(Old.Data)-1,J] := New.Data[I,J];

          if (FormUpdate.CloseUpdate) then
            begin
              FormUpdate.Close;
              exit;
            end;
        end;
      exit;
    end;

  // Find old items to delete
  I := 0;
  L := Length( Old.Data )-1;
  while (I <= L) do
    begin
      Found := false;

      for J := 0 to Length( New.Data )-1 do
        begin
          Same := true;

          for K := 0 to FIELDS_MAX-1 do
            if (Old.Data[I,K] <> New.Data[J,K]) then
              begin
                Same := false;
                break;
              end;

          if (Same) then
            begin
              Found := true;
              break;
            end;
        end;

      if (not Found) then
        begin
          MySQLDeleteRecord( Old.Name , Old.Data[I] );
          FormUpdate.ProgressBar.StepIt;

          Old.DeleteRow( I );
          Dec( L );

          if (FormUpdate.CloseUpdate) then
            begin
              FormUpdate.Close;
              exit;
            end;
        end
      else
        Inc( I );
    end;

  // Find new items to add
  for I := 0 to Length( New.Data )-1 do
    begin
      Found := false;

      for J := 0 to Length( Old.Data )-1 do
        begin
          Same := true;

          for K := 0 to FIELDS_MAX-1 do
            if (New.Data[I,K] <> Old.Data[J,K]) then
              begin
                Same := false;
                break;
              end;

          if (Same) then
            begin
              Found := true;
              break;
            end;
        end;

      if (not Found) then
        begin
          MySQLAddRecord( New.Name , New.Data[I] );
          FormUpdate.ProgressBar.StepIt;

          Old.AddRow;
          for J := 0 to Length( New.Data[I] )-1 do
            Old.Data[Length(Old.Data)-1,J] := New.Data[I,J];

          if (FormUpdate.CloseUpdate) then
            begin
              FormUpdate.Close;
              exit;
            end;
        end;
    end;
end;

function TUpdate.GetTableCount( Old, New : TCennik ) : integer;
var I, J, K : integer;
    Found : boolean;
    Same : boolean;
begin
  Result := 0;

  if (Old = nil) then
    begin
      Result := Length( New.Data );
      exit;
    end;

  // Find old items to delete
  for I := 0 to Length( Old.Data )-1 do
    begin
      Found := false;

      for J := 0 to Length( New.Data )-1 do
        begin
          Same := true;

          for K := 0 to FIELDS_MAX-1 do
            if (Old.Data[I,K] <> New.Data[J,K]) then
              begin
                Same := false;
                break;
              end;

          if (Same) then
            begin
              Found := true;
              break;
            end;
        end;

      if (not Found) then
        Inc( Result );
    end;

  // Find new items to add
  for I := 0 to Length( New.Data )-1 do
    begin
      Found := false;

      for J := 0 to Length( Old.Data )-1 do
        begin
          Same := true;

          for K := 0 to FIELDS_MAX-1 do
            if (New.Data[I,K] <> Old.Data[J,K]) then
              begin
                Same := false;
                break;
              end;

          if (Same) then
            begin
              Found := true;
              break;
            end;
        end;

      if (not Found) then
        Inc( Result );
    end;
end;

function TUpdate.GetCount : integer;
var I, J : integer;
    Found : boolean;
begin
  Result := 0;

  if (Length( FOld^ ) = 0) then
    Inc( Result );

  for I := 0 to Length( FOld^ )-1 do
    begin
      Found := false;

      for J := 0 to Length( FNew^ )-1 do
        if ((FOld^[I].FriendlyName = FNew^[J].FriendlyName) and
            (FOld^[I].Name = FNew^[J].Name)) then
          begin
            Found := true;
            break;
          end;

      // If the table was deleted, remove it from the database
      if (not Found) then
        Inc( Result , 2 );
    end;

  for I := 0 to Length( FNew^ )-1 do
    begin
      Found := false;

      for J := 0 to Length( FOld^ )-1 do
        if ((FOld^[J].FriendlyName = FNew^[I].FriendlyName) and
            (FOld^[J].Name = FNew^[I].Name)) then
          begin
            Found := true;
            Inc( Result , GetTableCount( FOld^[J] , FNew^[I] ) );
            break;
          end;

      // If the table was deleted, remove it from the database
      if (not Found) then
        begin
          Inc( Result , 2 );
          Inc( Result , GetTableCount( nil , FNew^[I] ) );
        end;
    end;
end;

procedure TUpdate.Terminate( Sender: TObject );
var I, J : integer;
begin
  // Pack old data
  I := 0;
  J := 0;
  while (J <= Length( FOld^ )-1) do
    begin
      if (FOld^[J] <> nil) then
        begin
          FOld^[I] := FOld^[J];
          if (J > I) then
            FOld^[J] := nil;
          Inc( I );
        end;
      Inc( J );
    end;
  SetLength( FOld^ , I );

  FormUpdate.Close;
end;

//==============================================================================
//  P R O T E C T E D
//==============================================================================

procedure TUpdate.Execute;
var I, J : integer;
    Found : boolean;
    F : TextFile;
    FileName : string;
begin
  FormUpdate.ProgressBar.Min := 0;
  FormUpdate.ProgressBar.Max := 0;
  FormUpdate.ProgressBar.Step := 1;

  // Try to connect to the server
  FormUpdate.SetText( 'Prip�ja sa na server ...' );
  if (not FMySQL.Connect) then
    begin
      MessageDlg( 'Nepodarilo sa pripoji� na server!' , mtError , [mbOK] , 0 );
      exit;
    end;

  if (FormUpdate.CloseUpdate) then
    begin
      FormUpdate.Close;
      exit;
    end;

  // Try to select the database
  FormUpdate.SetText( 'Otv�ra sa datab�za ...' );
  if (not FMySQL.SelectDb( FDatabase )) then
    begin
      MessageDlg( 'Nepodarilo sa otvori� datab�zu!' , mtError , [mbOK] , 0 );
      exit;
    end;

  if (FormUpdate.CloseUpdate) then
    begin
      FormUpdate.Close;
      exit;
    end;

  // Get count of things to do
  FormUpdate.ProgressBar.Max := GetCount;

  FormUpdate.SetText( 'Aktualizuje sa datab�za ...' );

  if (Length( FOld^ ) = 0) then
    begin
      MySQLCreateTable( 'cenniky' , 2 , 255 );
      FormUpdate.ProgressBar.StepIt;
    end;

  //============================================================================
  // Delete old items from 'cenniky' table
  //============================================================================

  for I := 0 to Length( FOld^ )-1 do
    begin
      Found := false;

      for J := 0 to Length( FNew^ )-1 do
        if ((FOld^[I].FriendlyName = FNew^[J].FriendlyName) and
            (FOld^[I].Name = FNew^[J].Name)) then
          begin
            Found := true;
            break;
          end;

      // If the table was deleted, remove it from the database
      if (not Found) then
        begin
          MySQLDeleteRecord( 'cenniky' , [FOld^[I].FriendlyName,FOld^[I].Name] );
          MySQLDeleteTable( FOld^[I].Name );

          // Delete file
          FileName := FOld^[I].FileName;
          FOld^[I].Destroy;
          FOld^[I] := nil;
          AssignFile( F , FileName );
          Erase( F );

          FormUpdate.ProgressBar.StepBy( 2 );
        end;

      if (FormUpdate.CloseUpdate) then
        begin
          FormUpdate.Close;
          exit;
        end;
    end;

  //============================================================================
  // Add new items to 'cenniky' table and update data for each table
  //============================================================================

  for I := 0 to Length( FNew^ )-1 do
    begin
      Found := false;

      for J := 0 to Length( FOld^ )-1 do
        if (FOld^[J] <> nil) then
          if ((FOld^[J].FriendlyName = FNew^[I].FriendlyName) and
              (FOld^[J].Name = FNew^[I].Name)) then
            begin
              Found := true;
              UpdateTable( FOld^[J] , FNew^[I] , false );
              break;
            end;

      // If the table was deleted, remove it from the database
      if (not Found) then
        begin
          MySQLAddRecord( 'cenniky' , [FNew^[I].FriendlyName,FNew^[I].Name] );
          MySQLCreateTable( FNew^[I].Name , FIELDS_MAX , 255 );

          FormUpdate.ProgressBar.StepBy( 2 );

          SetLength( FOld^ , Length( FOld^ )+1 );
          FOld^[Length( FOld^ )-1] := TCennik.Create( FNew^[I].FriendlyName , FNew^[I].Name , FDir + '\' + FNew^[I].Name + OLD_CENNIK_EXT );

          UpdateTable( FOld^[Length( FOld^ )-1] , FNew^[I] , true );
        end;
    end;

  // Try to disconnect from the server
  FormUpdate.SetText( 'Odp�ja sa zo servera ...' );
  FMySQL.Disconnect;

  MessageDlg( 'Aktualiz�cia prebehla �spe�ne!' , mtInformation , [mbOK] , 0 );
end;

//==============================================================================
//  P U B L I C
//==============================================================================

procedure TUpdate.Update( Old, New : PCennikData );
begin
  // Show update dialog
  FormUpdate.CloseUpdate := false;
  FormUpdate.Show;

  FOld := Old;
  FNew := New;

  // Start update thread
  Suspended := false;
end;

end.
