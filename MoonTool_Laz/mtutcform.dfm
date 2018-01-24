object frmUTC: TfrmUTC
  Left = 286
  Top = 143
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Set universal time'
  ClientHeight = 263
  ClientWidth = 299
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
  object grpUTC: TGroupBox
    Left = 8
    Top = 8
    Width = 281
    Height = 136
    Caption = 'Universal time'
    TabOrder = 0
    object lblYear: TLabel
      Left = 18
      Top = 24
      Width = 22
      Height = 13
      Alignment = taCenter
      Caption = 'Year'
      Color = clBtnFace
      ParentColor = False
    end
    object lblMonth: TLabel
      Left = 114
      Top = 24
      Width = 30
      Height = 13
      Alignment = taCenter
      Caption = 'Month'
      Color = clBtnFace
      ParentColor = False
    end
    object lblDay: TLabel
      Left = 218
      Top = 24
      Width = 19
      Height = 13
      Alignment = taCenter
      Caption = 'Day'
      Color = clBtnFace
      ParentColor = False
    end
    object lblHour: TLabel
      Left = 18
      Top = 80
      Width = 23
      Height = 13
      Alignment = taCenter
      Caption = 'Hour'
      Color = clBtnFace
      ParentColor = False
    end
    object lblSec: TLabel
      Left = 218
      Top = 80
      Width = 37
      Height = 13
      Alignment = taCenter
      Caption = 'Second'
      Color = clBtnFace
      ParentColor = False
    end
    object lblMin: TLabel
      Left = 117
      Top = 80
      Width = 32
      Height = 13
      Alignment = taCenter
      Caption = 'Minute'
      Color = clBtnFace
      ParentColor = False
    end
    object edtYear: TEdit
      Left = 18
      Top = 40
      Width = 41
      Height = 21
      TabOrder = 0
      Text = '2000'
      OnChange = anyChange
    end
    object cbxMonth: TComboBox
      Left = 74
      Top = 40
      Width = 129
      Height = 21
      Style = csDropDownList
      TabOrder = 1
      OnChange = anyChange
    end
    object edtDay: TEdit
      Left = 218
      Top = 40
      Width = 41
      Height = 21
      TabOrder = 2
      Text = '1'
      OnChange = anyChange
    end
    object edtHour: TEdit
      Left = 18
      Top = 96
      Width = 41
      Height = 21
      TabOrder = 3
      Text = '0'
      OnChange = anyChange
    end
    object edtMin: TEdit
      Left = 114
      Top = 96
      Width = 41
      Height = 21
      TabOrder = 4
      Text = '0'
      OnChange = anyChange
    end
    object edtSec: TEdit
      Left = 218
      Top = 96
      Width = 41
      Height = 21
      TabOrder = 5
      Text = '0'
      OnChange = anyChange
    end
  end
  object grpJulian: TGroupBox
    Left = 8
    Top = 160
    Width = 281
    Height = 56
    Caption = 'Julian date'
    TabOrder = 1
    object lblJulian: TLabel
      Left = 22
      Top = 24
      Width = 53
      Height = 13
      Caption = 'Julian Date'
      Color = clBtnFace
      ParentColor = False
    end
  end
  object btnNow: TButton
    Left = 8
    Top = 232
    Width = 75
    Height = 25
    Caption = '&Now'
    TabOrder = 2
    OnClick = btnNowClick
  end
  object btnOK: TButton
    Left = 136
    Top = 232
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
  object btnCancel: TButton
    Left = 216
    Top = 232
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
end
