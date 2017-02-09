object Form2: TForm2
  Left = 384
  Top = 184
  BorderStyle = bsToolWindow
  Caption = 'AboutBox'
  ClientHeight = 161
  ClientWidth = 307
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 305
    Height = 121
    Lines.Strings = (
      'The Hurricane algorithm file encryption sample.'
      'Using the Hurricane algorithm implementation v1.0'
      ''
      '(c) by Roman Ganin'
      ''
      'Send comments to'
      'gate@ua.fm')
    TabOrder = 0
  end
  object Button1: TButton
    Left = 112
    Top = 128
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 1
  end
end
