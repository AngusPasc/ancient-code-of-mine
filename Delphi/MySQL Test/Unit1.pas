unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, MySQL;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    MySQL : TMySQL;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  MySQL := TMySQL.Create;
  with MySQL do
    begin
      Host := 'r6a4t8';
      User := 'rburansky';
      Name := 'rburansky';
      Password := 'evjlls';
      Port := 3306;
    end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  MySQL.Destroy;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if (MySQL.Connect) then
    begin
      MySQL.SelectDb( 'pcprompt' );

      MySQL.Query( 'INSERT INTO Table0 VALUES (''a'','''','''');' );
//      MySQL.Query( 'DELETE FROM Table0 WHERE COL0=''a'';' );
//      MySQL.Query( 'CREATE TABLE IF NOT EXISTS aaa (COL0 CHAR(255), COL1 CHAR(255))' );
//      MySQL.Query( 'DROP TABLE aaa' );

      MySQL.Disconnect;
    end;
end;

end.
