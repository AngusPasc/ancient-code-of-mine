object MainForm: TMainForm
  Left = -4
  Top = -4
  Width = 808
  Height = 580
  Caption = 'CitiesGAME'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Image: TImage
    Left = 24
    Top = 8
    Width = 750
    Height = 520
  end
  object MainMenu1: TMainMenu
    Left = 768
    Top = 8
    object Game1: TMenuItem
      Caption = '&Game'
      object GameNew: TMenuItem
        Caption = '&New'
        ShortCut = 16462
        OnClick = GameNewClick
      end
      object GameExit: TMenuItem
        Caption = 'E&xit'
      end
    end
  end
end
