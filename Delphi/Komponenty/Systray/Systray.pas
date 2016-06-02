unit Systray;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ShellApi, Menus;

const
  SH_CALLBACK = WM_USER +1;
type
  TSystray = class(TCustomControl)
  private
    FIconData : PNOTIFYICONDATA;
    FIcon : TIcon;
    FMenu : TPopupMenu;
    FToolTip : array [0..63] of AnsiChar;
    FtoolTipS : string;
    procedure CallBack (var Message : TMessage); message SH_CALLBACK;
  protected
    FCreated : boolean;
    procedure SetParent (AParent: TWinControl); override;
    procedure SetIcon (AIcon : TIcon); virtual;
    procedure SetMenu (AMenu : TPopupMenu); virtual;
    function GetTool : string; virtual;
    procedure SetTool (S : string); virtual;
    procedure IconChange (Sender : TObject);
    procedure MenuChange (Sender : TObject;Source : TMenuItem;Rebuild : boolean);
  public
    constructor Create (AOwner : TComponent); override;
    procedure Reset;
    destructor Destroy; override;
  published
    property Menu : TPopupMenu read FMenu write SetMenu;
    property Icon : TIcon read FIcon write SetIcon;
    property ToolTip : String read GetTool write SetTool;
//    property OnMouseMove read
  end;

procedure Register;

implementation

const ID : integer = 1;

constructor TSystray.Create;
begin
  inherited Create (AOwner);
  ControlStyle := ControlStyle + [csAcceptsControls];
  Width := 50;
  Height := 50;
  FIcon := TIcon.Create;
  FIcon.OnChange := IconChange;
  FMenu := TPopupMenu.Create (Self);
  FtoolTipS := 'ToolTip';
  getmem (FIconData,sizeof (NOTIFYICONDATA));
  if not (csDesigning in ComponentState) then
  with FIconData^ do
    begin
      cbSize := sizeof (NOTIFYICONDATA);
      uFlags := NIF_ICON or NIF_TIP or NIF_MESSAGE;
      uID := ID;
      uCallBackMessage := SH_CALLBACK;
    end;
  FCreated := false;
end;

procedure TSystray.SetTool;
var i : integer;
begin
  FToolTipS := S;
  i := 1;
  FTooltip [0] := #0;
  if length (s) > 0 then
  repeat
    FToolTip[i-1] := S[i];
    inc (i);
  until i > length (S);
  FToolTip [i] := #0;
  Reset;
end;

function TSystray.GetTool;
begin
{  SetLength (S,64); i := 1;
  repeat
    s[i] := FToolTip [i-1];
    inc (i);
  until FToolTip [i] = #0;}
  result := FToolTipS;
end;

procedure TSystray.SetMenu;
var i : integer;M : TMenuItem;
begin
  FMenu.Free;
  FMenu := AMenu;
  Reset;
end;

procedure TSystray.CallBack;
var P : TPoint;
begin
  GetCursorPos (P);
  if (message.LParam = WM_LBUTTONUP) or (message.LParam = WM_RBUTTONUP)then
    SetForegroundWindow (Self.handle);
  if message.LParam = WM_RBUTTONUP then
    if Assigned (FMenu) then FMenu.Popup (P.x,P.y);
end;

procedure TSystray.IconChange;
begin
  Reset;
end;

procedure Tsystray.MenuChange;
begin
end;

procedure TSystray.SetIcon;
begin
  FIcon.Assign( AIcon );
end;

procedure Tsystray.Reset;
begin
  if not (csDesigning in ComponentState) then
    begin
      FIconData.Wnd := Handle;
      FIconData.hIcon := FIcon.Handle;
      Move (FToolTip,FIconData.szTip,64);
      if FCreated then Shell_NotifyIcon (NIM_MODIFY,FIconData)
      else Shell_NotifyIcon (NIM_ADD,FIconData);
      FCreated := true;
    end;
end;

destructor TSystray.Destroy;
begin
  if ComponentState = [csDestroying] then
    begin
      Shell_NotifyIcon (NIM_DELETE,FIconData);
    end;
  Freemem (FIconData,sizeof (NOTIFYICONDATA));
  FIcon.Free;
//  FMenu.Free;
  inherited Destroy;
end;

procedure Register;
begin
  RegisterComponents('Additional', [TSystray]);
end;

procedure TSystray.SetParent(AParent: TWinControl);
begin
  inherited SetParent (AParent);
  if ComponentState = [] then Reset;
end;

end.
