object Form1: TForm1
  Left = 333
  Top = 161
  AutoScroll = False
  Caption = 'Cisco monitor'
  ClientHeight = 658
  ClientWidth = 1182
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
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
  object Edit2: TEdit
    Left = 65
    Top = 31
    Width = 136
    Height = 21
    TabOrder = 0
    Text = 'commun'
  end
  object Button2: TButton
    Left = 272
    Top = 56
    Width = 75
    Height = 25
    Caption = 'Start'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Memo2: TMemo
    Left = 8
    Top = 88
    Width = 345
    Height = 569
    ScrollBars = ssBoth
    TabOrder = 2
  end
  object Button3: TButton
    Left = 160
    Top = 56
    Width = 75
    Height = 25
    Caption = 'Refresh'
    TabOrder = 3
    OnClick = Button3Click
  end
  object ComboBox1: TComboBox
    Left = 64
    Top = 3
    Width = 289
    Height = 21
    ItemHeight = 13
    TabOrder = 4
    OnChange = ComboBox1Change
    Items.Strings = (
      '10.0.29.5 - '#1055#1083#1077#1093'10,  ('#1089#1090#1077#1082' '#1080#1079' 7 )'
      '10.0.29.81 - '#1055#1083#1077#1093'10, 210 '#1082#1072#1073
      '10.0.29.95 - 20 '#1083#1077#1090' '#1054#1082#1090#1103#1073#1088#1103', 115'
      '10.0.29.79 - 20 '#1083#1077#1090' '#1054#1082#1090#1103#1073#1088#1103', 115, ('#1089#1090#1077#1082' '#1080#1079' 2)'
      '10.0.29.97 - '#1044#1086#1084#1086#1089#1090#1088#1086#1080#1090#1077#1083#1077#1081', 30, '
      '10.0.29.63 - '#1044#1086#1084#1086#1089#1090#1088#1086#1080#1090#1077#1083#1077#1081', 30, '#1084#1091#1085#1079#1072#1082' ('#1089#1090#1077#1082' '#1080#1079' 2)'
      '10.0.29.64 - '#1044#1086#1084#1086#1089#1090#1088#1086#1080#1090#1077#1083#1077#1081', 30, '#1057#1086#1074' '#1091#1087#1088#1072#1074#1072
      '10.0.29.87 - '#1044#1086#1084#1086#1089#1090#1088#1086#1080#1090#1077#1083#1077#1081', 30, '#1057#1086#1074' '#1091#1087#1088#1072#1074#1072
      '10.0.29.96 - '#1044#1086#1084#1086#1089#1090#1088#1086#1080#1090#1077#1083#1077#1081', 30, 1-'#1081' '#1101#1090#1072#1078
      '10.0.29.78 - '#1051#1077#1085#1080#1085#1089#1082#1080#1081' '#1087#1088#1086#1089#1087'-'#1102', 93, '#1087#1077#1088#1074#1072#1103
      '10.0.29.94 - '#1051#1077#1085#1080#1085#1089#1082#1080#1081' '#1087#1088#1086#1089#1087'-'#1102', 93, '#1074#1090#1086#1088#1072#1103
      '')
  end
  object Timer2: TTimer
    Enabled = False
    OnTimer = Timer2Timer
    Left = 296
    Top = 24
  end
  object MainMenu1: TMainMenu
    Left = 200
    Top = 16
    object Menu1: TMenuItem
      Caption = 'Menu'
      object OIDtest1: TMenuItem
        Caption = 'OID test'
        OnClick = OIDtest1Click
      end
      object Graphicsview1: TMenuItem
        Caption = 'Graphics view'
        OnClick = Graphicsview1Click
      end
      object VLAN1: TMenuItem
        Caption = 'VLAN '#1090#1088#1072#1092#1092#1080#1082
        OnClick = VLAN1Click
      end
      object Exit1: TMenuItem
        Caption = 'Exit'
        OnClick = Exit1Click
      end
    end
  end
  object Timer1: TabfThreadTimer
    Interval = 60000
    OnTimer = Timer1Timer
    Left = 360
    Top = 8
  end
  object Timer3: TabfThreadTimer
    Interval = 5000
    OnTimer = Timer3Timer
    Left = 368
    Top = 72
  end
end
