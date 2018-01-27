object frmAbout: TfrmAbout
  Left = 250
  Top = 186
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  ClientHeight = 185
  ClientWidth = 425
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblURL: TLabel
    Left = 112
    Top = 64
    Width = 146
    Height = 13
    Cursor = crHandPoint
    Caption = 'http://www.hoerstemeier.com'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsUnderline]
    ParentColor = False
    ParentFont = False
    Transparent = False
    OnClick = lblURLClick
  end
  object lblCopyright: TLabel
    Left = 96
    Top = 40
    Width = 178
    Height = 13
    Caption = '(c) 1997-2001 Andreas Hoerstemeier'
    Color = clBtnFace
    ParentColor = False
    Transparent = False
  end
  object lblMain: TLabel
    Left = 136
    Top = 8
    Width = 91
    Height = 23
    Caption = 'Moontool'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object lblRef: TLabel
    Left = 112
    Top = 88
    Width = 118
    Height = 26
    Alignment = taCenter
    Caption = 'based upon the program'#13#10'by John Walker'
    Color = clBtnFace
    ParentColor = False
    Transparent = False
  end
  object Moon: TMoon
    Left = 8
    Top = 9
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
  object btnOK: TButton
    Left = 152
    Top = 144
    Width = 75
    Height = 25
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
end
