object MainForm: TMainForm
  Left = 365
  Top = 126
  Width = 468
  Height = 357
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Moontool'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = True
  Position = poScreenCenter
  ShowHint = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    452
    298)
  PixelsPerInch = 96
  TextHeight = 13
  object lblJulian: TLabel
    Tag = 1
    Left = 8
    Top = 8
    Width = 56
    Height = 13
    Caption = 'Julian date:'
    Color = clBtnFace
    ParentColor = False
  end
  object valJulian: TLabel
    Tag = 2
    Left = 110
    Top = 8
    Width = 3
    Height = 13
    Color = clBtnFace
    ParentColor = False
  end
  object lblUTC: TLabel
    Tag = 1
    Left = 8
    Top = 25
    Width = 71
    Height = 13
    Caption = 'Universal time:'
    Color = clBtnFace
    ParentColor = False
  end
  object valUTC: TLabel
    Tag = 2
    Left = 110
    Top = 25
    Width = 3
    Height = 13
    Color = clBtnFace
    ParentColor = False
  end
  object lblLocal: TLabel
    Tag = 1
    Left = 8
    Top = 42
    Width = 51
    Height = 13
    Caption = 'Local time:'
    Color = clBtnFace
    ParentColor = False
  end
  object valLocal: TLabel
    Tag = 2
    Left = 110
    Top = 42
    Width = 3
    Height = 13
    Color = clBtnFace
    ParentColor = False
  end
  object lblAgeOfMoon: TLabel
    Tag = 1
    Left = 8
    Top = 73
    Width = 84
    Height = 13
    Caption = 'Age of the moon:'
    Color = clBtnFace
    ParentColor = False
  end
  object valAgeOfMoon: TLabel
    Tag = 2
    Left = 110
    Top = 73
    Width = 3
    Height = 13
    Color = clBtnFace
    ParentColor = False
  end
  object lblPhase: TLabel
    Tag = 1
    Left = 8
    Top = 90
    Width = 62
    Height = 13
    Caption = 'Moon phase:'
    Color = clBtnFace
    ParentColor = False
  end
  object valPhase: TLabel
    Tag = 3
    Left = 110
    Top = 90
    Width = 3
    Height = 13
    Color = clBtnFace
    ParentColor = False
  end
  object lblMoonDistance: TLabel
    Tag = 1
    Left = 8
    Top = 107
    Width = 80
    Height = 13
    Caption = 'Moon'#39's distance:'
    Color = clBtnFace
    ParentColor = False
  end
  object valMoonDistance: TLabel
    Tag = 3
    Left = 110
    Top = 107
    Width = 3
    Height = 13
    Color = clBtnFace
    ParentColor = False
  end
  object lblMoonSubtend: TLabel
    Tag = 1
    Left = 8
    Top = 124
    Width = 77
    Height = 13
    Caption = 'Moon subtends:'
    Color = clBtnFace
    ParentColor = False
  end
  object valMoonSubtend: TLabel
    Tag = 3
    Left = 110
    Top = 124
    Width = 3
    Height = 13
    Color = clBtnFace
    ParentColor = False
  end
  object lblSunDistance: TLabel
    Tag = 1
    Left = 8
    Top = 155
    Width = 72
    Height = 13
    Caption = 'Sun'#39's distance:'
    Color = clBtnFace
    ParentColor = False
  end
  object valSunDistance: TLabel
    Tag = 3
    Left = 110
    Top = 155
    Width = 3
    Height = 13
    Color = clBtnFace
    ParentColor = False
  end
  object lblSunSubtend: TLabel
    Tag = 1
    Left = 8
    Top = 172
    Width = 69
    Height = 13
    Caption = 'Sun subtends:'
    Color = clBtnFace
    ParentColor = False
  end
  object valSunSubtend: TLabel
    Tag = 3
    Left = 110
    Top = 172
    Width = 3
    Height = 13
    Color = clBtnFace
    ParentColor = False
  end
  object lblLastNew: TLabel
    Tag = 1
    Left = 8
    Top = 203
    Width = 76
    Height = 13
    Caption = 'Last new moon:'
    Color = clBtnFace
    ParentColor = False
  end
  object valNewMoon: TLabel
    Tag = 4
    Left = 110
    Top = 203
    Width = 3
    Height = 13
    Color = clBtnFace
    ParentColor = False
  end
  object lblFirstQuart: TLabel
    Tag = 1
    Left = 8
    Top = 220
    Width = 64
    Height = 13
    Caption = 'First quarter:'
    Color = clBtnFace
    ParentColor = False
  end
  object lblfullMoon: TLabel
    Tag = 1
    Left = 8
    Top = 237
    Width = 49
    Height = 13
    Caption = 'Full moon:'
    Color = clBtnFace
    ParentColor = False
  end
  object lblLastQuart: TLabel
    Tag = 1
    Left = 8
    Top = 254
    Width = 63
    Height = 13
    Caption = 'Last quarter:'
    Color = clBtnFace
    ParentColor = False
  end
  object lblNextNewMoon: TLabel
    Tag = 1
    Left = 8
    Top = 271
    Width = 79
    Height = 13
    Caption = 'Next new moon:'
    Color = clBtnFace
    ParentColor = False
  end
  object valFirstQuart: TLabel
    Tag = 4
    Left = 110
    Top = 220
    Width = 3
    Height = 13
    Color = clBtnFace
    ParentColor = False
  end
  object valFullMoon: TLabel
    Tag = 4
    Left = 110
    Top = 237
    Width = 3
    Height = 13
    Color = clBtnFace
    ParentColor = False
  end
  object valLastQuart: TLabel
    Tag = 4
    Left = 110
    Top = 254
    Width = 3
    Height = 13
    Color = clBtnFace
    ParentColor = False
  end
  object valNextNewMoon: TLabel
    Tag = 4
    Left = 110
    Top = 271
    Width = 3
    Height = 13
    Color = clBtnFace
    ParentColor = False
  end
  object lblLastLunation: TLabel
    Tag = 5
    Left = 143
    Top = 203
    Width = 65
    Height = 13
    Caption = 'Last lunation:'
    Color = clBtnFace
    ParentColor = False
  end
  object valLastLunation: TLabel
    Tag = 6
    Left = 246
    Top = 203
    Width = 3
    Height = 13
    Color = clBtnFace
    ParentColor = False
  end
  object lblNextLunation: TLabel
    Tag = 5
    Left = 143
    Top = 271
    Width = 68
    Height = 13
    Caption = 'Next lunation:'
    Color = clBtnFace
    ParentColor = False
  end
  object valNextLunation: TLabel
    Tag = 6
    Left = 246
    Top = 271
    Width = 3
    Height = 13
    Color = clBtnFace
    ParentColor = False
  end
  object Moon: TMoon
    Left = 309
    Top = 8
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
    Anchors = [akTop, akRight]
  end
  object Timer: TTimer
    Enabled = False
    OnTimer = TimerTimer
    Left = 208
  end
  object MainMenu: TMainMenu
    Left = 208
    Top = 56
    object mnuFile: TMenuItem
      Caption = '&File'
      object mnuTray: TMenuItem
        Caption = '&Minimize to Tray'
        HelpContext = 1050
        Visible = False
        OnClick = mnuTrayClick
      end
      object mnuExit: TMenuItem
        Caption = 'E&xit'
        OnClick = mnuExitClick
      end
    end
    object mnuEdit: TMenuItem
      Caption = '&Edit'
      object mnuCopy: TMenuItem
        Caption = '&Copy'
        HelpContext = 1040
        OnClick = mnuCopyClick
      end
    end
    object mnuOptions: TMenuItem
      Caption = '&Options'
      object mnuLanguage: TMenuItem
        Caption = 'Language'
        object mnuLanguageEN: TMenuItem
          Caption = 'en - English'
          OnClick = mnuLanguageClick
        end
        object mnLanguageDE: TMenuItem
          Caption = 'de - Deutsch'
          OnClick = mnuLanguageClick
        end
      end
      object MenuItem1: TMenuItem
        Caption = '-'
      end
      object mnuSpeed: TMenuItem
        Caption = 'Speed'
        object mnuNormalSpeed: TMenuItem
          Tag = 10
          Caption = '&Normal'
          Checked = True
          OnClick = mnuSpeedUpClick
        end
        object mnuFastMode: TMenuItem
          Tag = 11
          Caption = '&Fast'
          OnClick = mnuSpeedUpClick
        end
        object mnuVeryFastMode: TMenuItem
          Tag = 12
          Caption = '&Very fast'
          OnClick = mnuSpeedUpClick
        end
      end
      object mnuStop: TMenuItem
        Caption = '&Stop'
        OnClick = mnuStopClick
      end
      object mnuline1: TMenuItem
        Caption = '-'
      end
      object mnuJulian: TMenuItem
        Caption = '&Julian Date...'
        HelpContext = 1030
        OnClick = mnuJulianClick
      end
      object mnuUTC: TMenuItem
        Caption = '&Universal Time...'
        HelpContext = 1040
        OnClick = mnuUTCClick
      end
      object mnuJewish: TMenuItem
        Caption = 'Je&wish Calendar...'
        HelpContext = 1035
        OnClick = mnuJewishClick
      end
      object mnuLine3: TMenuItem
        Caption = '-'
      end
      object mnuRotate: TMenuItem
        Caption = '&Rotate Moon'
        object mnuRotNorth: TMenuItem
          Caption = '&Northern Hemisphere'
          Checked = True
          OnClick = mnuRotateClick
        end
        object mnuRotSouth: TMenuItem
          Caption = '&Southern Hemisphere'
          OnClick = mnuRotateClick
        end
      end
      object mnuColorizeMoon: TMenuItem
        Caption = '&Colorize Moon'
        OnClick = mnuColorizeMoonClick
      end
      object mnuLine4: TMenuItem
        Caption = '-'
      end
      object mnuLocations: TMenuItem
        Caption = '&Locations...'
        HelpContext = 1038
        OnClick = mnuLocationsClick
      end
      object MenuItem2: TMenuItem
        Caption = '-'
      end
      object mnuMoreData: TMenuItem
        Caption = '&More Data...'
        HelpContext = 1012
        OnClick = mnuMoreDataClick
      end
    end
    object mnuHelp: TMenuItem
      Caption = '&Help'
      object mnuMenuAbout: TMenuItem
        Caption = '&About...'
        OnClick = mnuMenuAboutClick
      end
      object mnuHelpItem: TMenuItem
        Caption = '&Help'
        OnClick = mnuHelpItemClick
      end
      object mnuLine2: TMenuItem
        Caption = '-'
      end
      object mnuHelpTimezones: TMenuItem
        Caption = 'Time zones...'
        HelpContext = 1055
        OnClick = mnuHelpTimezonesClick
      end
    end
  end
end
