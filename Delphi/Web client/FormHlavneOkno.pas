unit FormHlavneOkno;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ScktComp;

type
  THlavneOkno = class(TForm)
    EditPort: TEdit;
    EditIP: TEdit;
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TClient = class(TClientSocket)
  end;

var
  HlavneOkno: THlavneOkno;
  Client : TClient;

implementation

{$R *.DFM}

procedure THlavneOkno.FormCreate(Sender: TObject);
begin
  Client := TClient.Create( HlavneOkno );
  Client.ClientType := ctNonBlocking;
  Client.Address := 'localhost';
  Client.Host := 'localhost';
  Client.Port := 80;
  Client.Service := 'http';
end;

procedure THlavneOkno.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Client.Free;
end;

procedure THlavneOkno.Button1Click(Sender: TObject);
begin
  Client.Open;
end;

end.
