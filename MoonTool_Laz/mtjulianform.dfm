object frmJulian: TfrmJulian
  Left = 200
  Top = 108
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Set julian date'
  ClientHeight = 155
  ClientWidth = 323
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
  object lblJulian: TLabel
    Left = 16
    Top = 16
    Width = 56
    Height = 13
    Caption = 'Julian Date:'
    Color = clBtnFace
    ParentColor = False
  end
  object edtJulian: TEdit
    Left = 128
    Top = 12
    Width = 185
    Height = 21
    TabOrder = 0
  end
  object grpUTC: TGroupBox
    Left = 16
    Top = 48
    Width = 297
    Height = 57
    Caption = 'Universal time'
    TabOrder = 1
    object lblUTC: TLabel
      Left = 16
      Top = 24
      Width = 3
      Height = 13
      Color = clBtnFace
      ParentColor = False
    end
  end
  object btnNow: TButton
    Left = 14
    Top = 120
    Width = 75
    Height = 25
    Caption = '&Now'
    TabOrder = 2
    OnClick = btnNowClick
  end
  object btnOK: TButton
    Left = 158
    Top = 120
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
  object btnCancel: TButton
    Left = 238
    Top = 120
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
end
