object frmMoreData: TfrmMoreData
  Left = 363
  Top = 118
  Width = 659
  Height = 593
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'More Data'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  OnCreate = FormCreate
  OnHide = FormHide
  OnShow = FormShow
  DesignSize = (
    643
    554)
  PixelsPerInch = 96
  TextHeight = 13
  object lblLatitude: TLabel
    Tag = 1
    Left = 8
    Top = 35
    Width = 43
    Height = 13
    Caption = 'Latitude:'
    Color = clBtnFace
    ParentColor = False
  end
  object lblLongitude: TLabel
    Tag = 1
    Left = 8
    Top = 54
    Width = 51
    Height = 13
    Caption = 'Longitude:'
    Color = clBtnFace
    ParentColor = False
  end
  object lblLocation: TLabel
    Tag = 1
    Left = 8
    Top = 12
    Width = 44
    Height = 13
    Caption = 'Location:'
    Color = clBtnFace
    ParentColor = False
  end
  object valLatitude: TLabel
    Tag = 2
    Left = 89
    Top = 35
    Width = 3
    Height = 13
    Color = clBtnFace
    ParentColor = False
  end
  object valLongitude: TLabel
    Tag = 2
    Left = 89
    Top = 54
    Width = 3
    Height = 13
    Color = clBtnFace
    ParentColor = False
  end
  object cbxLocation: TComboBox
    Tag = 2
    Left = 89
    Top = 8
    Width = 209
    Height = 21
    ItemHeight = 13
    TabOrder = 0
    OnChange = LocationChange
  end
  object PageControl: TPageControl
    Left = 8
    Top = 77
    Width = 630
    Height = 471
    ActivePage = pgSun
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 1
    OnChange = PageControlChange
    object pgSun: TTabSheet
      Caption = 'Sun'
      object lblSunRise: TLabel
        Tag = 10
        Left = 4
        Top = 8
        Width = 42
        Height = 13
        Caption = 'Sun rise:'
        Color = clBtnFace
        ParentColor = False
      end
      object lblSunTransit: TLabel
        Tag = 10
        Left = 4
        Top = 24
        Width = 56
        Height = 13
        Caption = 'Sun transit:'
        Color = clBtnFace
        ParentColor = False
      end
      object lblSunSet: TLabel
        Tag = 10
        Left = 4
        Top = 40
        Width = 40
        Height = 13
        Caption = 'Sun set:'
        Color = clBtnFace
        ParentColor = False
      end
      object valSunRise: TLabel
        Tag = 11
        Left = 200
        Top = 8
        Width = 3
        Height = 13
        Color = clBtnFace
        ParentColor = False
      end
      object valSunTransit: TLabel
        Tag = 11
        Left = 200
        Top = 27
        Width = 3
        Height = 13
        Color = clBtnFace
        ParentColor = False
      end
      object valSunSet: TLabel
        Tag = 11
        Left = 200
        Top = 46
        Width = 3
        Height = 13
        Color = clBtnFace
        ParentColor = False
      end
      object lblPerihel: TLabel
        Tag = 12
        Left = 352
        Top = 24
        Width = 62
        Height = 13
        Caption = 'Next perihel:'
        Color = clBtnFace
        ParentColor = False
      end
      object valPerihel: TLabel
        Tag = 13
        Left = 500
        Top = 27
        Width = 3
        Height = 13
        Color = clBtnFace
        ParentColor = False
      end
      object lblAphel: TLabel
        Tag = 12
        Left = 352
        Top = 8
        Width = 56
        Height = 13
        Caption = 'Next aphel:'
        Color = clBtnFace
        ParentColor = False
      end
      object valAphel: TLabel
        Tag = 13
        Left = 500
        Top = 8
        Width = 3
        Height = 13
        Color = clBtnFace
        ParentColor = False
      end
      object lblSunEclipse: TLabel
        Tag = 10
        Left = 4
        Top = 176
        Width = 82
        Height = 13
        Caption = 'Next sun eclipse:'
        Color = clBtnFace
        ParentColor = False
      end
      object valSunEclipse: TLabel
        Tag = 11
        Left = 200
        Top = 158
        Width = 3
        Height = 13
        Color = clBtnFace
        ParentColor = False
      end
      object typSunEclipse: TLabel
        Tag = 11
        Left = 200
        Top = 161
        Width = 3
        Height = 13
        Color = clBtnFace
        ParentColor = False
      end
      object sarosSunEclipse: TLabel
        Tag = 11
        Left = 200
        Top = 164
        Width = 3
        Height = 13
        Color = clBtnFace
        ParentColor = False
      end
      object lblSpring: TLabel
        Tag = 12
        Left = 352
        Top = 77
        Width = 74
        Height = 13
        Caption = 'March Equinox:'
        Color = clBtnFace
        ParentColor = False
        ParentShowHint = False
        ShowHint = True
      end
      object lblSummer: TLabel
        Tag = 12
        Left = 352
        Top = 96
        Width = 66
        Height = 13
        Caption = 'June Solstice:'
        Color = clBtnFace
        ParentColor = False
        ParentShowHint = False
        ShowHint = True
      end
      object lblAutumn: TLabel
        Tag = 12
        Left = 352
        Top = 116
        Width = 97
        Height = 13
        Caption = 'September Equinox:'
        Color = clBtnFace
        ParentColor = False
        ParentShowHint = False
        ShowHint = True
      end
      object lblWinter: TLabel
        Tag = 12
        Left = 352
        Top = 136
        Width = 91
        Height = 13
        Caption = 'December Solstice:'
        Color = clBtnFace
        ParentColor = False
        ParentShowHint = False
        ShowHint = True
      end
      object valSpring: TLabel
        Tag = 13
        Left = 500
        Top = 77
        Width = 3
        Height = 13
        Color = clBtnFace
        ParentColor = False
      end
      object valSummer: TLabel
        Tag = 13
        Left = 500
        Top = 82
        Width = 3
        Height = 13
        Color = clBtnFace
        ParentColor = False
      end
      object valAutumn: TLabel
        Tag = 13
        Left = 500
        Top = 87
        Width = 3
        Height = 13
        Color = clBtnFace
        ParentColor = False
      end
      object valWinter: TLabel
        Tag = 13
        Left = 500
        Top = 92
        Width = 3
        Height = 13
        Color = clBtnFace
        ParentColor = False
      end
      object lblSunRektaszension: TLabel
        Tag = 10
        Left = 4
        Top = 77
        Width = 73
        Height = 13
        Caption = 'Rektaszension:'
        Color = clBtnFace
        ParentColor = False
      end
      object valSunRektaszension: TLabel
        Tag = 11
        Left = 200
        Top = 77
        Width = 3
        Height = 13
        Color = clBtnFace
        ParentColor = False
      end
      object lblSunDeclination: TLabel
        Tag = 10
        Left = 4
        Top = 96
        Width = 56
        Height = 13
        Caption = 'Deklination:'
        Color = clBtnFace
        ParentColor = False
      end
      object valSunDeclination: TLabel
        Tag = 11
        Left = 200
        Top = 96
        Width = 3
        Height = 13
        Color = clBtnFace
        ParentColor = False
      end
      object valSunZodiac: TLabel
        Tag = 11
        Left = 200
        Top = 136
        Width = 24
        Height = 23
        Caption = '^'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -21
        Font.Name = 'Wingdings'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
      end
      object lblSunZodiac: TLabel
        Tag = 10
        Left = 4
        Top = 123
        Width = 35
        Height = 13
        Caption = 'Zodiac:'
        Color = clBtnFace
        ParentColor = False
      end
      object valSunZodiacname: TLabel
        Tag = 11
        Left = 200
        Top = 123
        Width = 3
        Height = 13
        Color = clBtnFace
        ParentColor = False
      end
    end
    object pgMoon: TTabSheet
      Caption = 'Moon'
      ImageIndex = 1
      object lblMoonRise: TLabel
        Tag = 20
        Left = 4
        Top = 8
        Width = 50
        Height = 13
        Caption = 'Moon rise:'
        Color = clBtnFace
        ParentColor = False
      end
      object lblMoonTransit: TLabel
        Tag = 20
        Left = 4
        Top = 27
        Width = 64
        Height = 13
        Caption = 'Moon transit:'
        Color = clBtnFace
        ParentColor = False
      end
      object lblMoonSet: TLabel
        Tag = 20
        Left = 4
        Top = 46
        Width = 48
        Height = 13
        Caption = 'Moon set:'
        Color = clBtnFace
        ParentColor = False
      end
      object valMoonRise: TLabel
        Tag = 21
        Left = 113
        Top = 8
        Width = 3
        Height = 13
        Color = clBtnFace
        ParentColor = False
      end
      object valMoonTransit: TLabel
        Tag = 21
        Left = 113
        Top = 27
        Width = 3
        Height = 13
        Color = clBtnFace
        ParentColor = False
      end
      object valMoonSet: TLabel
        Tag = 21
        Left = 113
        Top = 46
        Width = 3
        Height = 13
        Color = clBtnFace
        ParentColor = False
      end
      object lblMoonEclipse: TLabel
        Tag = 20
        Left = 4
        Top = 178
        Width = 91
        Height = 13
        Caption = 'Next moon eclipse:'
        Color = clBtnFace
        ParentColor = False
      end
      object valMoonEclipse: TLabel
        Tag = 21
        Left = 113
        Top = 178
        Width = 3
        Height = 13
        Color = clBtnFace
        ParentColor = False
      end
      object typMoonEclipse: TLabel
        Tag = 21
        Left = 113
        Top = 183
        Width = 3
        Height = 13
        Color = clBtnFace
        ParentColor = False
      end
      object lblPerigee: TLabel
        Tag = 22
        Left = 304
        Top = 27
        Width = 46
        Height = 13
        Caption = 'lblPerigee'
        Color = clBtnFace
        ParentColor = False
      end
      object valPerigee: TLabel
        Tag = 23
        Left = 380
        Top = 27
        Width = 3
        Height = 13
        Color = clBtnFace
        ParentColor = False
      end
      object lblApogee: TLabel
        Tag = 22
        Left = 304
        Top = 8
        Width = 47
        Height = 13
        Caption = 'lblApogee'
        Color = clBtnFace
        ParentColor = False
      end
      object valApogee: TLabel
        Tag = 23
        Left = 380
        Top = 8
        Width = 3
        Height = 13
        Color = clBtnFace
        ParentColor = False
      end
      object sarosMoonEclipse: TLabel
        Tag = 21
        Left = 113
        Top = 188
        Width = 3
        Height = 13
        Color = clBtnFace
        ParentColor = False
      end
      object lblMoonRektaszension: TLabel
        Tag = 20
        Left = 4
        Top = 77
        Width = 73
        Height = 13
        Caption = 'Rektaszension:'
        Color = clBtnFace
        ParentColor = False
      end
      object lblMoonDeclination: TLabel
        Tag = 20
        Left = 4
        Top = 96
        Width = 56
        Height = 13
        Caption = 'Deklination:'
        Color = clBtnFace
        ParentColor = False
      end
      object valMoonRektaszension: TLabel
        Tag = 21
        Left = 113
        Top = 77
        Width = 3
        Height = 13
        Color = clBtnFace
        ParentColor = False
      end
      object valMoonDeclination: TLabel
        Tag = 21
        Left = 113
        Top = 96
        Width = 3
        Height = 13
        Color = clBtnFace
        ParentColor = False
      end
      object valMoonZodiac: TLabel
        Tag = 21
        Left = 144
        Top = 139
        Width = 23
        Height = 23
        Caption = 'a'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -21
        Font.Name = 'Wingdings'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
      end
      object lblMoonZodiac: TLabel
        Tag = 20
        Left = 4
        Top = 134
        Width = 31
        Height = 13
        Caption = 'Zodiac'
        Color = clBtnFace
        ParentColor = False
      end
      object valMoonZodiac_name: TLabel
        Tag = 21
        Left = 113
        Top = 134
        Width = 3
        Height = 13
        Color = clBtnFace
        ParentColor = False
      end
    end
    object pgCalendar: TTabSheet
      Caption = 'Calendar'
      ImageIndex = 2
      object lblEaster: TLabel
        Tag = 30
        Left = 4
        Top = 8
        Width = 60
        Height = 13
        Caption = 'Easter date:'
        Color = clBtnFace
        ParentColor = False
        ParentShowHint = False
        ShowHint = True
      end
      object valEaster: TLabel
        Tag = 31
        Left = 141
        Top = 8
        Width = 3
        Height = 13
        Color = clBtnFace
        ParentColor = False
      end
      object lblPesach: TLabel
        Tag = 30
        Left = 4
        Top = 46
        Width = 73
        Height = 13
        Caption = 'Passover date:'
        Color = clBtnFace
        ParentColor = False
        ParentShowHint = False
        ShowHint = True
      end
      object valPesach: TLabel
        Tag = 31
        Left = 141
        Top = 46
        Width = 3
        Height = 13
        Color = clBtnFace
        ParentColor = False
      end
      object lblChinese: TLabel
        Tag = 30
        Left = 4
        Top = 65
        Width = 91
        Height = 13
        Caption = 'Chinese New Year:'
        Color = clBtnFace
        ParentColor = False
        ParentShowHint = False
        ShowHint = True
      end
      object valChinese: TLabel
        Tag = 31
        Left = 141
        Top = 65
        Width = 3
        Height = 13
        Color = clBtnFace
        ParentColor = False
      end
      object lblEasterJulian: TLabel
        Tag = 30
        Left = 4
        Top = 27
        Width = 109
        Height = 13
        Caption = 'Orthodox Easter date:'
        Color = clBtnFace
        ParentColor = False
        ParentShowHint = False
        ShowHint = True
      end
      object valEasterJulian: TLabel
        Tag = 31
        Left = 141
        Top = 27
        Width = 3
        Height = 13
        Color = clBtnFace
        ParentColor = False
      end
    end
  end
  object Timer: TTimer
    Interval = 65535
    OnTimer = LocationChange
    Left = 256
    Top = 32
  end
end
