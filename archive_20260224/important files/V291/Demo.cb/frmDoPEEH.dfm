object frm_DoPEEH: Tfrm_DoPEEH
  Left = 436
  Top = 217
  Caption = 'C++Builder DoPE-Demo V%x.%02x'
  ClientHeight = 411
  ClientWidth = 674
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 66
    Top = 5
    Width = 46
    Height = 13
    Caption = 'Time [s]'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 217
    Top = 5
    Width = 76
    Height = 13
    Caption = 'Position [mm]'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 396
    Top = 5
    Width = 50
    Height = 13
    Caption = 'Load [N]'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 544
    Top = 5
    Width = 86
    Height = 13
    Caption = 'Extension [mm]'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 232
    Top = 68
    Width = 33
    Height = 13
    Caption = 'Control'
  end
  object Label6: TLabel
    Left = 232
    Top = 95
    Width = 31
    Height = 13
    Caption = 'Speed'
  end
  object Label7: TLabel
    Left = 232
    Top = 122
    Width = 53
    Height = 13
    Caption = 'Destination'
  end
  object lbl_SpeedDim: TLabel
    Left = 441
    Top = 95
    Width = 3
    Height = 13
  end
  object lbl_DestDim: TLabel
    Left = 441
    Top = 122
    Width = 3
    Height = 13
  end
  object txt_Ext: TStaticText
    Left = 507
    Top = 24
    Width = 160
    Height = 26
    Alignment = taCenter
    AutoSize = False
    BorderStyle = sbsSunken
    Caption = '0.000'
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clLime
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 0
  end
  object txt_Time: TStaticText
    Left = 9
    Top = 24
    Width = 160
    Height = 26
    Alignment = taCenter
    AutoSize = False
    BorderStyle = sbsSunken
    Caption = '0.000'
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clLime
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 1
  end
  object txt_Pos: TStaticText
    Left = 175
    Top = 24
    Width = 160
    Height = 26
    Alignment = taCenter
    AutoSize = False
    BorderStyle = sbsSunken
    Caption = '0.000'
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clLime
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 2
  end
  object txt_Load: TStaticText
    Left = 341
    Top = 24
    Width = 160
    Height = 26
    Alignment = taCenter
    AutoSize = False
    BorderStyle = sbsSunken
    Caption = '0.000'
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clLime
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 3
  end
  object cbo_Ctrl: TComboBox
    Left = 312
    Top = 64
    Width = 121
    Height = 21
    Style = csDropDownList
    TabOrder = 4
    OnChange = cbo_CtrlChange
    Items.Strings = (
      'Position'
      'Load'
      'Extension')
  end
  object txt_Speed: TEdit
    Left = 312
    Top = 91
    Width = 121
    Height = 21
    TabOrder = 5
  end
  object txt_Dest: TEdit
    Left = 312
    Top = 118
    Width = 121
    Height = 21
    TabOrder = 6
  end
  object btn_On: TButton
    Left = 8
    Top = 63
    Width = 40
    Height = 35
    Caption = 'On'
    TabOrder = 7
    OnClick = btn_OnClick
  end
  object btn_Off: TButton
    Left = 8
    Top = 97
    Width = 40
    Height = 35
    Caption = 'Off'
    TabOrder = 8
    OnClick = btn_OffClick
  end
  object btn_Up: TButton
    Left = 65
    Top = 63
    Width = 40
    Height = 35
    Caption = 'Up'
    TabOrder = 9
    OnClick = btn_UpClick
  end
  object btn_Halt: TButton
    Left = 65
    Top = 97
    Width = 40
    Height = 35
    Caption = 'Halt'
    TabOrder = 10
    OnClick = btn_HaltClick
  end
  object btn_Down: TButton
    Left = 65
    Top = 131
    Width = 40
    Height = 35
    Caption = 'Down'
    TabOrder = 11
    OnClick = btn_DownClick
  end
  object btn_Pos: TButton
    Left = 175
    Top = 63
    Width = 40
    Height = 35
    Caption = 'Pos'
    TabOrder = 12
    OnClick = btn_PosClick
  end
  object Memo1: TMemo
    Left = 8
    Top = 192
    Width = 657
    Height = 209
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Style = [fsBold]
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 13
  end
end
