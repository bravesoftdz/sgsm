object frm_Fileinput_prezentquery: Tfrm_Fileinput_prezentquery
  Left = 276
  Top = 245
  Width = 861
  Height = 500
  BorderIcons = []
  Caption = '3F'#20339#26519#31185#25216'-'#36164#26009#24405#20837'-'#31036#21697#20986#24211#31649#29702
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
  object Panel1: TPanel
    Left = 0
    Top = 57
    Width = 853
    Height = 409
    Align = alClient
    Caption = 'Panel1'
    TabOrder = 0
    object DBGrid2: TDBGrid
      Left = 1
      Top = 1
      Width = 851
      Height = 407
      Align = alClient
      DataSource = DataSource_Gift
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      Columns = <
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'UserNo'
          Title.Alignment = taCenter
          Title.Caption = #24207#21495
          Width = 50
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'UserName'
          Title.Alignment = taCenter
          Title.Caption = #31036#21697#32534#21495
          Width = 80
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'UserPassword'
          Title.Alignment = taCenter
          Title.Caption = #31036#21697#21517#31216
          Width = 80
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'Opration'
          Title.Alignment = taCenter
          Title.Caption = #24211#23384#24635#25968
          Width = 100
          Visible = True
        end
        item
          Expanded = False
          Title.Caption = #20986#24211#24635#25968
          Width = 120
          Visible = True
        end
        item
          Expanded = False
          Title.Caption = #21333#20301
          Width = 60
          Visible = True
        end
        item
          Expanded = False
          Title.Caption = #21333#20215
          Width = 150
          Visible = True
        end
        item
          Expanded = False
          Title.Caption = #25805#20316#21592#22995#21517
          Visible = True
        end
        item
          Expanded = False
          Title.Caption = #22791#27880
          Width = 120
          Visible = True
        end>
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 0
    Width = 853
    Height = 57
    Align = alTop
    BorderStyle = bsSingle
    TabOrder = 1
    object BitBtn7: TBitBtn
      Left = 664
      Top = 8
      Width = 81
      Height = 33
      Caption = #25171#21360
      TabOrder = 0
    end
    object BitBtn8: TBitBtn
      Left = 768
      Top = 8
      Width = 81
      Height = 33
      Caption = #20851#38381
      TabOrder = 1
      OnClick = BitBtn8Click
    end
    object ComboBox_Operator: TComboBox
      Left = 136
      Top = 5
      Width = 105
      Height = 21
      Enabled = False
      ItemHeight = 13
      TabOrder = 2
      Text = #20840#37096
    end
    object ComboBox_Other: TComboBox
      Left = 136
      Top = 28
      Width = 105
      Height = 21
      Enabled = False
      ItemHeight = 13
      TabOrder = 3
      Text = #20840#37096
      Items.Strings = (
        #31036#21697#32534#21495
        #31036#21697#21517#31216)
    end
    object Edit_Other: TEdit
      Left = 248
      Top = 28
      Width = 161
      Height = 21
      Enabled = False
      TabOrder = 4
    end
    object Bit_Query: TBitBtn
      Left = 549
      Top = 7
      Width = 89
      Height = 33
      Caption = #26597#35810
      TabOrder = 5
    end
    object CheckBox_Date: TCheckBox
      Left = 8
      Top = 8
      Width = 121
      Height = 17
      Caption = #20197#25805#20316#21592#26597#35810
      TabOrder = 6
      OnClick = CheckBox_DateClick
    end
    object CheckBox_Other: TCheckBox
      Left = 8
      Top = 31
      Width = 105
      Height = 17
      Caption = #20197#20854#20182#26597#35810
      TabOrder = 7
      OnClick = CheckBox_OtherClick
    end
  end
  object DataSource_Gift: TDataSource
    DataSet = ADOQuery_Gift
    Left = 24
    Top = 268
  end
  object ADOQuery_Gift: TADOQuery
    Parameters = <>
    Left = 65
    Top = 268
  end
  object DataSource_Operator: TDataSource
    DataSet = ADOQuery_Operator
    Left = 280
    Top = 268
  end
  object ADOQuery_Operator: TADOQuery
    Parameters = <>
    Left = 321
    Top = 268
  end
end
