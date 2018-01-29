object frmEclipses: TfrmEclipses
  Left = 192
  Top = 107
  Width = 588
  Height = 344
  ActiveControl = edFrom
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    572
    305)
  PixelsPerInch = 96
  TextHeight = 13
  object lblFrom: TLabel
    Left = 407
    Top = 10
    Width = 28
    Height = 13
    Anchors = [akTop, akRight]
    Caption = 'From:'
    Color = clBtnFace
    ParentColor = False
  end
  object lblTo: TLabel
    Left = 494
    Top = 10
    Width = 16
    Height = 13
    Anchors = [akTop, akRight]
    Caption = 'To:'
    Color = clBtnFace
    ParentColor = False
  end
  object Grid: TStringGrid
    Left = 8
    Top = 8
    Width = 391
    Height = 288
    Anchors = [akLeft, akTop, akRight, akBottom]
    ColCount = 2
    DefaultRowHeight = 22
    FixedCols = 0
    RowCount = 2
    TabOrder = 0
    ColWidths = (
      193
      194)
  end
  object edFrom: TEdit
    Left = 406
    Top = 28
    Width = 49
    Height = 21
    Anchors = [akTop, akRight]
    TabOrder = 1
    Text = '0'
  end
  object edTo: TEdit
    Left = 494
    Top = 29
    Width = 49
    Height = 21
    Anchors = [akTop, akRight]
    TabOrder = 2
    Text = '0'
  end
  object udFrom: TUpDown
    Left = 455
    Top = 28
    Width = 16
    Height = 21
    Anchors = [akTop, akRight]
    Associate = edFrom
    Min = -4713
    Max = 9999
    TabOrder = 3
    Thousands = False
  end
  object udTo: TUpDown
    Left = 543
    Top = 29
    Width = 16
    Height = 21
    Anchors = [akTop, akRight]
    Associate = edTo
    Min = -4713
    Max = 9999
    TabOrder = 4
    Thousands = False
  end
  object btnSearch: TButton
    Left = 484
    Top = 271
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Search'
    Default = True
    TabOrder = 5
    OnClick = btnSearchClick
  end
  object rbLunarEclipses: TRadioButton
    Left = 408
    Top = 64
    Width = 102
    Height = 19
    Anchors = [akTop, akRight]
    Caption = 'rbLunarEclipses'
    TabOrder = 6
  end
  object rbSolarEclipses: TRadioButton
    Left = 408
    Top = 86
    Width = 98
    Height = 19
    Anchors = [akTop, akRight]
    Caption = 'rbSolarEclipses'
    Checked = True
    TabOrder = 7
    TabStop = True
  end
end
