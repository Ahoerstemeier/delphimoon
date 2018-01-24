object frmMoreData: TfrmMoreData
  Left = 363
  Top = 118
  Width = 659
  Height = 428
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'More Data'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  OnCreate = FormCreate
  OnHide = FormHide
  OnShow = FormShow
  DesignSize = (
    643
    389)
  PixelsPerInch = 96
  TextHeight = 13
  object lblLatitude: TLabel
    Tag = 1
    Left = 8
    Top = 35
    Width = 41
    Height = 13
    Caption = 'Latitude:'
    Color = clBtnFace
    ParentColor = False
  end
  object lblLongitude: TLabel
    Tag = 1
    Left = 8
    Top = 54
    Width = 50
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
    Height = 306
    ActivePage = pgMoon
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 1
    OnChange = PageControlChange
    object pgSun: TTabSheet
      Caption = 'Sun'
      object lblSunRise: TLabel
        Tag = 3
        Left = 4
        Top = 8
        Width = 41
        Height = 13
        Caption = 'Sun rise:'
        Color = clBtnFace
        ParentColor = False
      end
      object lblSunTransit: TLabel
        Tag = 3
        Left = 4
        Top = 27
        Width = 53
        Height = 13
        Caption = 'Sun transit:'
        Color = clBtnFace
        ParentColor = False
      end
      object lblSunSet: TLabel
        Tag = 3
        Left = 4
        Top = 46
        Width = 39
        Height = 13
        Caption = 'Sun set:'
        Color = clBtnFace
        ParentColor = False
      end
      object valSunRise: TLabel
        Tag = 4
        Left = 100
        Top = 8
        Width = 3
        Height = 13
        Color = clBtnFace
        ParentColor = False
      end
      object valSunTransit: TLabel
        Tag = 4
        Left = 100
        Top = 27
        Width = 3
        Height = 13
        Color = clBtnFace
        ParentColor = False
      end
      object valSunSet: TLabel
        Tag = 4
        Left = 100
        Top = 46
        Width = 3
        Height = 13
        Color = clBtnFace
        ParentColor = False
      end
      object lblPerihel: TLabel
        Tag = 5
        Left = 125
        Top = 27
        Width = 59
        Height = 13
        Caption = 'Next perihel:'
        Color = clBtnFace
        ParentColor = False
      end
      object valPerihel: TLabel
        Tag = 6
        Left = 238
        Top = 27
        Width = 3
        Height = 13
        Color = clBtnFace
        ParentColor = False
      end
      object lblAphel: TLabel
        Tag = 5
        Left = 125
        Top = 8
        Width = 54
        Height = 13
        Caption = 'Next aphel:'
        Color = clBtnFace
        ParentColor = False
      end
      object valAphel: TLabel
        Tag = 6
        Left = 238
        Top = 8
        Width = 3
        Height = 13
        Color = clBtnFace
        ParentColor = False
      end
      object lblSunEclipse: TLabel
        Tag = 3
        Left = 4
        Top = 158
        Width = 81
        Height = 13
        Caption = 'Next sun eclipse:'
        Color = clBtnFace
        ParentColor = False
      end
      object valSunEclipse: TLabel
        Tag = 4
        Left = 100
        Top = 158
        Width = 3
        Height = 13
        Color = clBtnFace
        ParentColor = False
      end
      object typSunEclipse: TLabel
        Tag = 4
        Left = 100
        Top = 161
        Width = 3
        Height = 13
        Color = clBtnFace
        ParentColor = False
      end
      object sarosSunEclipse: TLabel
        Tag = 4
        Left = 100
        Top = 164
        Width = 3
        Height = 13
        Color = clBtnFace
        ParentColor = False
      end
      object lblSpring: TLabel
        Tag = 5
        Left = 272
        Top = 56
        Width = 74
        Height = 13
        Caption = 'March Equinox:'
        Color = clBtnFace
        ParentColor = False
        ParentShowHint = False
        ShowHint = True
      end
      object lblSummer: TLabel
        Tag = 5
        Left = 312
        Top = 77
        Width = 66
        Height = 13
        Caption = 'June Solstice:'
        Color = clBtnFace
        ParentColor = False
        ParentShowHint = False
        ShowHint = True
      end
      object lblAutumn: TLabel
        Tag = 5
        Left = 296
        Top = 104
        Width = 95
        Height = 13
        Caption = 'September Equinox:'
        Color = clBtnFace
        ParentColor = False
        ParentShowHint = False
        ShowHint = True
      end
      object lblWinter: TLabel
        Tag = 5
        Left = 312
        Top = 127
        Width = 92
        Height = 13
        Caption = 'December Solstice:'
        Color = clBtnFace
        ParentColor = False
        ParentShowHint = False
        ShowHint = True
      end
      object valSpring: TLabel
        Tag = 6
        Left = 238
        Top = 77
        Width = 3
        Height = 13
        Color = clBtnFace
        ParentColor = False
      end
      object valSummer: TLabel
        Tag = 6
        Left = 238
        Top = 82
        Width = 3
        Height = 13
        Color = clBtnFace
        ParentColor = False
      end
      object valAutumn: TLabel
        Tag = 6
        Left = 238
        Top = 87
        Width = 3
        Height = 13
        Color = clBtnFace
        ParentColor = False
      end
      object valWinter: TLabel
        Tag = 6
        Left = 238
        Top = 92
        Width = 3
        Height = 13
        Color = clBtnFace
        ParentColor = False
      end
      object lblSunRektaszension: TLabel
        Tag = 3
        Left = 4
        Top = 77
        Width = 73
        Height = 13
        Caption = 'Rektaszension:'
        Color = clBtnFace
        ParentColor = False
      end
      object valSunRektaszension: TLabel
        Tag = 4
        Left = 100
        Top = 77
        Width = 3
        Height = 13
        Color = clBtnFace
        ParentColor = False
      end
      object lblSunDeclination: TLabel
        Tag = 3
        Left = 4
        Top = 96
        Width = 56
        Height = 13
        Caption = 'Deklination:'
        Color = clBtnFace
        ParentColor = False
      end
      object valSunDeclination: TLabel
        Tag = 4
        Left = 100
        Top = 96
        Width = 3
        Height = 13
        Color = clBtnFace
        ParentColor = False
      end
      object valSunZodiac: TLabel
        Tag = 4
        Left = 100
        Top = 127
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
        Left = 4
        Top = 123
        Width = 36
        Height = 13
        Caption = 'Zodiac:'
        Color = clBtnFace
        ParentColor = False
      end
      object valSunZodiacname: TLabel
        Left = 100
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
        Tag = 3
        Left = 4
        Top = 8
        Width = 49
        Height = 13
        Caption = 'Moon rise:'
        Color = clBtnFace
        ParentColor = False
      end
      object lblMoonTransit: TLabel
        Tag = 3
        Left = 4
        Top = 27
        Width = 61
        Height = 13
        Caption = 'Moon transit:'
        Color = clBtnFace
        ParentColor = False
      end
      object lblMoonSet: TLabel
        Tag = 3
        Left = 4
        Top = 46
        Width = 47
        Height = 13
        Caption = 'Moon set:'
        Color = clBtnFace
        ParentColor = False
      end
      object valMoonRise: TLabel
        Tag = 4
        Left = 113
        Top = 8
        Width = 3
        Height = 13
        Color = clBtnFace
        ParentColor = False
      end
      object valMoonTransit: TLabel
        Tag = 4
        Left = 113
        Top = 27
        Width = 3
        Height = 13
        Color = clBtnFace
        ParentColor = False
      end
      object valMoonSet: TLabel
        Tag = 4
        Left = 113
        Top = 46
        Width = 3
        Height = 13
        Color = clBtnFace
        ParentColor = False
      end
      object lblMoonEclipse: TLabel
        Tag = 3
        Left = 4
        Top = 178
        Width = 90
        Height = 13
        Caption = 'Next moon eclipse:'
        Color = clBtnFace
        ParentColor = False
      end
      object valMoonEclipse: TLabel
        Tag = 4
        Left = 113
        Top = 178
        Width = 3
        Height = 13
        Color = clBtnFace
        ParentColor = False
      end
      object typMoonEclipse: TLabel
        Tag = 4
        Left = 113
        Top = 183
        Width = 3
        Height = 13
        Color = clBtnFace
        ParentColor = False
      end
      object lblPerigee: TLabel
        Tag = 5
        Left = 138
        Top = 27
        Width = 46
        Height = 13
        Caption = 'lblPerigee'
        Color = clBtnFace
        ParentColor = False
      end
      object valPerigee: TLabel
        Tag = 6
        Left = 198
        Top = 27
        Width = 3
        Height = 13
        Color = clBtnFace
        ParentColor = False
      end
      object lblApogee: TLabel
        Tag = 5
        Left = 138
        Top = 8
        Width = 47
        Height = 13
        Caption = 'lblApogee'
        Color = clBtnFace
        ParentColor = False
      end
      object valApogee: TLabel
        Tag = 6
        Left = 198
        Top = 8
        Width = 3
        Height = 13
        Color = clBtnFace
        ParentColor = False
      end
      object sarosMoonEclipse: TLabel
        Tag = 4
        Left = 113
        Top = 188
        Width = 3
        Height = 13
        Color = clBtnFace
        ParentColor = False
      end
      object lblMoonRektaszension: TLabel
        Tag = 3
        Left = 4
        Top = 77
        Width = 73
        Height = 13
        Caption = 'Rektaszension:'
        Color = clBtnFace
        ParentColor = False
      end
      object lblMoonDeclination: TLabel
        Tag = 3
        Left = 4
        Top = 96
        Width = 56
        Height = 13
        Caption = 'Deklination:'
        Color = clBtnFace
        ParentColor = False
      end
      object valMoonRektaszension: TLabel
        Tag = 4
        Left = 113
        Top = 77
        Width = 3
        Height = 13
        Color = clBtnFace
        ParentColor = False
      end
      object valMoonDeclination: TLabel
        Tag = 4
        Left = 113
        Top = 96
        Width = 3
        Height = 13
        Color = clBtnFace
        ParentColor = False
      end
      object valMoonZodiac: TLabel
        Tag = 4
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
        Left = 4
        Top = 134
        Width = 33
        Height = 13
        Caption = 'Zodiac'
        Color = clBtnFace
        ParentColor = False
      end
      object valMoonZodiac_name: TLabel
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
        Tag = 3
        Left = 4
        Top = 8
        Width = 57
        Height = 13
        Caption = 'Easter date:'
        Color = clBtnFace
        ParentColor = False
        ParentShowHint = False
        ShowHint = True
      end
      object valEaster: TLabel
        Tag = 4
        Left = 141
        Top = 8
        Width = 3
        Height = 13
        Color = clBtnFace
        ParentColor = False
      end
      object lblPesach: TLabel
        Tag = 3
        Left = 4
        Top = 46
        Width = 71
        Height = 13
        Caption = 'Passover date:'
        Color = clBtnFace
        ParentColor = False
        ParentShowHint = False
        ShowHint = True
      end
      object valPesach: TLabel
        Tag = 4
        Left = 141
        Top = 46
        Width = 3
        Height = 13
        Color = clBtnFace
        ParentColor = False
      end
      object lblChinese: TLabel
        Tag = 3
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
        Tag = 4
        Left = 141
        Top = 65
        Width = 3
        Height = 13
        Color = clBtnFace
        ParentColor = False
      end
      object lblEasterJulian: TLabel
        Tag = 3
        Left = 4
        Top = 27
        Width = 103
        Height = 13
        Caption = 'Orthodox Easter date:'
        Color = clBtnFace
        ParentColor = False
        ParentShowHint = False
        ShowHint = True
      end
      object valEasterJulian: TLabel
        Tag = 4
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
