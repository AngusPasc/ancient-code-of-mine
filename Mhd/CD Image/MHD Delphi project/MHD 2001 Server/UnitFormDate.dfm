object FormDate: TFormDate
  Left = 192
  Top = 102
  Width = 253
  Height = 137
  Caption = 'New update'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 12
    Width = 25
    Height = 13
    Caption = 'Day :'
  end
  object Label2: TLabel
    Left = 16
    Top = 44
    Width = 36
    Height = 13
    Caption = 'Month :'
  end
  object Label3: TLabel
    Left = 16
    Top = 76
    Width = 28
    Height = 13
    Caption = 'Year :'
  end
  object EditDen: TEdit
    Left = 64
    Top = 8
    Width = 73
    Height = 21
    TabOrder = 0
    Text = '10'
  end
  object EditMes: TEdit
    Left = 64
    Top = 40
    Width = 73
    Height = 21
    TabOrder = 1
    Text = '4'
  end
  object EditRok: TEdit
    Left = 64
    Top = 72
    Width = 73
    Height = 21
    TabOrder = 2
    Text = '2001'
  end
  object ButtonOK: TButton
    Left = 160
    Top = 8
    Width = 75
    Height = 25
    Caption = '&OK'
    Default = True
    TabOrder = 3
    OnClick = ButtonOKClick
  end
  object ButtonCancel: TButton
    Left = 160
    Top = 40
    Width = 75
    Height = 25
    Caption = '&Cancel'
    TabOrder = 4
    OnClick = ButtonCancelClick
  end
end
