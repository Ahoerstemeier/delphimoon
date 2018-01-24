object frmJewish: TfrmJewish
  Left = 229
  Top = 113
  ActiveControl = edtYear
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Jewish date'
  ClientHeight = 283
  ClientWidth = 296
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object grpGregorian: TGroupBox
    Left = 8
    Top = 8
    Width = 281
    Height = 81
    Caption = 'Christian date'
    TabOrder = 0
    object lblYear: TLabel
      Left = 8
      Top = 24
      Width = 57
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = 'Year'
      Color = clBtnFace
      ParentColor = False
    end
    object lblMonth: TLabel
      Left = 72
      Top = 24
      Width = 129
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = 'Month'
      Color = clBtnFace
      ParentColor = False
    end
    object lblDay: TLabel
      Left = 208
      Top = 24
      Width = 57
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = 'Day'
      Color = clBtnFace
      ParentColor = False
    end
    object edtYear: TEdit
      Left = 16
      Top = 40
      Width = 41
      Height = 21
      TabOrder = 0
      Text = '2000'
      OnChange = christianChange
    end
    object cbxMonth: TComboBox
      Left = 72
      Top = 40
      Width = 129
      Height = 21
      Style = csDropDownList
      TabOrder = 1
      OnChange = christianChange
    end
    object edtDay: TEdit
      Left = 216
      Top = 40
      Width = 41
      Height = 21
      TabOrder = 2
      Text = '1'
      OnChange = christianChange
    end
  end
  object grpJulian: TGroupBox
    Left = 8
    Top = 184
    Width = 281
    Height = 57
    Caption = 'Julian date'
    TabOrder = 2
    object lblJulian: TLabel
      Left = 24
      Top = 24
      Width = 53
      Height = 13
      Caption = 'Julian Date'
      Color = clBtnFace
      ParentColor = False
    end
  end
  object btnNow: TButton
    Left = 6
    Top = 248
    Width = 75
    Height = 25
    Caption = '&Now'
    TabOrder = 3
    OnClick = btnNowClick
  end
  object btnOK: TButton
    Left = 134
    Top = 248
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 4
  end
  object btnCancel: TButton
    Left = 214
    Top = 248
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 5
  end
  object grpJewish: TGroupBox
    Left = 8
    Top = 95
    Width = 281
    Height = 81
    Caption = 'Jewish date'
    TabOrder = 1
    object lblYearJewish: TLabel
      Left = 8
      Top = 24
      Width = 57
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = 'Year'
      Color = clBtnFace
      ParentColor = False
    end
    object lblMonthJewish: TLabel
      Left = 72
      Top = 24
      Width = 129
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = 'Month'
      Color = clBtnFace
      ParentColor = False
    end
    object lblDayJewish: TLabel
      Left = 208
      Top = 24
      Width = 57
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = 'Day'
      Color = clBtnFace
      ParentColor = False
    end
    object edtYearJewish: TEdit
      Left = 16
      Top = 40
      Width = 41
      Height = 21
      TabOrder = 0
      Text = '2000'
      OnChange = jewishChange
    end
    object cbxMonthJewish: TComboBox
      Left = 72
      Top = 40
      Width = 129
      Height = 21
      Style = csDropDownList
      TabOrder = 1
      OnChange = jewishChange
    end
    object edtDayJewish: TEdit
      Left = 216
      Top = 40
      Width = 41
      Height = 21
      TabOrder = 2
      Text = '1'
      OnChange = jewishChange
    end
  end
end
