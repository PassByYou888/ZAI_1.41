object _156_SSL_Trainer_Form: T_156_SSL_Trainer_Form
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'SSL Trainer Demo.'
  ClientHeight = 399
  ClientWidth = 862
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Memo: TMemo
    Left = 8
    Top = 8
    Width = 841
    Height = 329
    Lines.Strings = (
      'Barlow Twins: Self-Supervised Learning via Redundancy Reduction'
      #36825#26159#19968#31181#26080#30417#30563#30340#22823#27169#22411#27597#20307','#31616#31216'SSL'
      #24403#27597#20307#35757#32451#23436#25104',SSL'#21487#29992#20110#23454#26102#22270#29255#20998#31867','#23454#26102#22330#26223#35782#21035','#22823#25968#25454#25366#25496
      ''
      'by.qq600585')
    ScrollBars = ssBoth
    TabOrder = 0
    WordWrap = False
  end
  object Training_ImageList_Button: TButton
    Left = 8
    Top = 360
    Width = 137
    Height = 25
    Caption = #35757#32451#27597#20307#22823#27169#22411
    TabOrder = 1
    OnClick = Training_ImageList_ButtonClick
  end
  object stop_Button: TButton
    Left = 152
    Top = 360
    Width = 75
    Height = 25
    Caption = #20572#27490#35757#32451
    TabOrder = 2
    OnClick = stop_ButtonClick
  end
  object Button1: TButton
    Left = 353
    Top = 360
    Width = 120
    Height = 25
    Caption = #22270#29255#25238#21160#30697#38453#27979#35797
    TabOrder = 3
    OnClick = Button1Click
  end
  object jitter_num_Edit: TLabeledEdit
    Left = 479
    Top = 362
    Width = 58
    Height = 21
    EditLabel.Width = 48
    EditLabel.Height = 13
    EditLabel.Caption = #25238#21160#39057#29575
    TabOrder = 4
    Text = '100'
  end
  object model_info_Button: TButton
    Left = 272
    Top = 360
    Width = 75
    Height = 25
    Caption = #27169#22411#20449#24687
    TabOrder = 5
    OnClick = model_info_ButtonClick
  end
  object sysTimer: TTimer
    Interval = 10
    OnTimer = sysTimerTimer
    Left = 424
    Top = 208
  end
  object OpenDialog: TOpenDialog
    Filter = '*.jpg;*.bmp;*.png|*.jpg;*.bmp;*.png'
    Left = 496
    Top = 208
  end
end
