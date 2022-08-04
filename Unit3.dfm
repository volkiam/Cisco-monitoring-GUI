object Form3: TForm3
  Left = 192
  Top = 124
  Width = 386
  Height = 675
  Caption = 'OID test'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label3: TLabel
    Left = 16
    Top = 64
    Width = 22
    Height = 13
    Caption = 'OID:'
  end
  object Label1: TLabel
    Left = 8
    Top = 12
    Width = 38
    Height = 13
    Caption = 'Host IP:'
  end
  object Label2: TLabel
    Left = 8
    Top = 35
    Width = 54
    Height = 13
    Caption = 'Community:'
  end
  object Memo1: TMemo
    Left = 16
    Top = 88
    Width = 345
    Height = 521
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object Edit3: TEdit
    Left = 41
    Top = 60
    Width = 240
    Height = 21
    TabOrder = 1
  end
  object Button1: TButton
    Left = 288
    Top = 59
    Width = 65
    Height = 25
    Caption = 'Test oid'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Edit2: TEdit
    Left = 65
    Top = 31
    Width = 136
    Height = 21
    TabOrder = 3
    Text = 'commun'
  end
  object Edit1: TEdit
    Left = 65
    Top = 7
    Width = 136
    Height = 21
    TabOrder = 4
  end
  object CheckBox1: TCheckBox
    Left = 216
    Top = 8
    Width = 97
    Height = 17
    Caption = 'Get first'
    TabOrder = 5
  end
end
