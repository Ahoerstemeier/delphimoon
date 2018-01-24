object Form1: TForm1
  Left = 186
  Top = 152
  Width = 435
  Height = 391
  Caption = 'Simple Moon Demo'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Moon1: TMoon
    Left = 24
    Top = 16
    Width = 64
    Height = 64
    MoonSize = ms64
    Rotation = rot_none
    ShowApollo11 = True
    MoonStyle = msClassic
    Transparent = False
    Color = clBlack
    MoonColor = clBlack
    RotationAngle = 0
    ParentColor = False
  end
  object Label1: TLabel
    Left = 24
    Top = 184
    Width = 69
    Height = 13
    Caption = 'Rotation angle'
  end
  object Label2: TLabel
    Left = 96
    Top = 32
    Width = 41
    Height = 13
    Caption = 'Latitude:'
    WordWrap = True
  end
  object Label3: TLabel
    Left = 24
    Top = 88
    Width = 50
    Height = 13
    Caption = 'Longitude:'
  end
  object ScrollBar1: TScrollBar
    Left = 24
    Top = 112
    Width = 121
    Height = 17
    LargeChange = 10
    Max = 180
    Min = -180
    PageSize = 0
    TabOrder = 0
    OnChange = ScrollBar1Change
  end
  object ScrollBar2: TScrollBar
    Left = 160
    Top = 16
    Width = 17
    Height = 97
    Kind = sbVertical
    LargeChange = 10
    Max = 90
    Min = -89
    PageSize = 0
    TabOrder = 1
    OnChange = ScrollBar2Change
  end
  object RadioGroup1: TRadioGroup
    Left = 224
    Top = 176
    Width = 169
    Height = 89
    Caption = 'Rotation'
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      'rot_none'
      'rot_90'
      'rot_180'
      'rot_270'
      'rot_angle'
      'rot_location')
    TabOrder = 2
    OnClick = RadioGroup1Click
  end
  object ScrollBar3: TScrollBar
    Left = 24
    Top = 200
    Width = 161
    Height = 17
    LargeChange = 15
    Max = 360
    PageSize = 0
    TabOrder = 3
    OnChange = ScrollBar3Change
  end
  object RadioGroup2: TRadioGroup
    Left = 224
    Top = 280
    Width = 169
    Height = 49
    Caption = 'Moon Size'
    Columns = 3
    ItemIndex = 0
    Items.Strings = (
      'ms64'
      'ms32'
      'ms16')
    TabOrder = 4
    OnClick = RadioGroup2Click
  end
  object RadioGroup3: TRadioGroup
    Left = 24
    Top = 232
    Width = 169
    Height = 97
    Caption = 'Moon Style'
    ItemIndex = 0
    Items.Strings = (
      'msClassic'
      'msColor'
      'msMonochrome')
    TabOrder = 5
    OnClick = RadioGroup3Click
  end
  object Panel1: TPanel
    Left = 152
    Top = 296
    Width = 25
    Height = 25
    TabOrder = 6
    OnClick = Panel1Click
  end
  object cbTransparent: TCheckBox
    Left = 24
    Top = 152
    Width = 97
    Height = 17
    Caption = 'Transparent'
    TabOrder = 7
    OnClick = cbTransparentClick
  end
  object ColorDialog1: TColorDialog
    Left = 152
    Top = 256
  end
end
