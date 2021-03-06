unit UnitMainForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls;

type
  TMainForm = class(TForm)
    Image: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

uses ClassChess;

{$R *.DFM}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Chess := TChess.Create( Image );
  Chess.Play;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  Chess.Free;
end;

end.
