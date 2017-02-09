object Form1: TForm1
  Left = 377
  Top = 324
  BorderStyle = bsToolWindow
  Caption = 'Hurricane encryption sample'
  ClientHeight = 241
  ClientWidth = 372
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 18
    Height = 13
    Caption = 'Key'
  end
  object Edit3: TEdit
    Left = 8
    Top = 24
    Width = 353
    Height = 21
    TabOrder = 0
    Text = '123456'
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 56
    Width = 361
    Height = 137
    Caption = 'File encryption'
    TabOrder = 1
    object Label2: TLabel
      Left = 8
      Top = 16
      Width = 50
      Height = 13
      Caption = 'Source file'
    end
    object Label3: TLabel
      Left = 8
      Top = 60
      Width = 69
      Height = 13
      Caption = 'Destination file'
    end
    object Edit1: TEdit
      Left = 8
      Top = 32
      Width = 265
      Height = 21
      TabOrder = 0
    end
    object Edit2: TEdit
      Left = 8
      Top = 76
      Width = 265
      Height = 21
      TabOrder = 1
    end
    object Button1: TButton
      Left = 278
      Top = 32
      Width = 75
      Height = 25
      Caption = 'Open'
      TabOrder = 2
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 278
      Top = 72
      Width = 75
      Height = 25
      Caption = 'Save'
      TabOrder = 3
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 8
      Top = 104
      Width = 75
      Height = 25
      Caption = 'Encrypt'
      TabOrder = 4
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 88
      Top = 104
      Width = 75
      Height = 25
      Caption = 'Decrypt'
      TabOrder = 5
      OnClick = Button4Click
    end
  end
  object Button5: TButton
    Left = 8
    Top = 208
    Width = 75
    Height = 25
    Caption = 'About'
    TabOrder = 2
  end
  object Button6: TButton
    Left = 288
    Top = 208
    Width = 75
    Height = 25
    Caption = 'Exit'
    TabOrder = 3
    OnClick = Button6Click
  end
  object OpenDialog1: TOpenDialog
    Left = 288
    Top = 48
  end
  object SaveDialog1: TSaveDialog
    Left = 320
    Top = 48
  end
end
