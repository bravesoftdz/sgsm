object frm_Fileinput_prezentmatial: Tfrm_Fileinput_prezentmatial
  Left = 199
  Top = 148
  Width = 952
  Height = 500
  BorderIcons = []
  Caption = '3F'#20339#26519#31185#25216'-'#36164#26009#24405#20837'-'#31036#21697#36164#26009
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
    Width = 944
    Height = 409
    Align = alClient
    Caption = 'Panel1'
    TabOrder = 0
    object DBGrid1: TDBGrid
      Left = 1
      Top = 1
      Width = 942
      Height = 407
      Hint = #21452#20987#35760#24405#21487#36827#34892#20837#24211#25805#20316
      Align = alClient
      DataSource = DataSource_Giftsinfor
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      OnDblClick = DBGrid1DblClick
      Columns = <
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'ID'
          Title.Alignment = taCenter
          Title.Caption = #24207#21495
          Width = 50
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'GF_No'
          Title.Alignment = taCenter
          Title.Caption = #31036#21697#32534#21495
          Width = 80
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'GF_Name'
          Title.Alignment = taCenter
          Title.Caption = #31036#21697#21517#31216
          Width = 80
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'GiftsCount'
          Title.Alignment = taCenter
          Title.Caption = #20837#24211#25968#37327
          Width = 100
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'TickCount'
          Title.Caption = #20817#24425#31080#25968
          Width = 120
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Unit'
          Title.Caption = #21333#20301
          Width = 60
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'GiftFee'
          Title.Caption = #21333#20215
          Width = 80
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'cUserNo'
          Title.Caption = #25805#20316#21592#22995#21517
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'GetTime'
          Title.Caption = #20837#24211#26102#38388
          Width = 120
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Remark'
          Title.Caption = #22791#27880
          Width = 80
          Visible = True
        end>
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 0
    Width = 944
    Height = 57
    Align = alTop
    BorderStyle = bsSingle
    TabOrder = 1
    object Label1: TLabel
      Left = 5
      Top = 11
      Width = 54
      Height = 13
      Caption = #31036#21697#32534#21495'  '
    end
    object Label2: TLabel
      Left = 5
      Top = 35
      Width = 54
      Height = 13
      Caption = #31036#21697#21517#31216'  '
    end
    object Label3: TLabel
      Left = 157
      Top = 11
      Width = 54
      Height = 13
      Caption = #20837#24211#25968#37327'  '
    end
    object Label4: TLabel
      Left = 157
      Top = 32
      Width = 54
      Height = 13
      Caption = #20817#24425#31080#25968'  '
    end
    object Label5: TLabel
      Left = 301
      Top = 32
      Width = 30
      Height = 13
      Caption = #21333#20215'  '
    end
    object Label6: TLabel
      Left = 301
      Top = 11
      Width = 30
      Height = 13
      Caption = #21333#20301'  '
    end
    object Label7: TLabel
      Left = 413
      Top = 11
      Width = 27
      Height = 13
      Caption = #22791#27880' '
    end
    object Edit_NO: TEdit
      Left = 64
      Top = 8
      Width = 81
      Height = 21
      TabOrder = 0
      Text = 'Edit_NO'
    end
    object Edit_Name: TEdit
      Left = 64
      Top = 32
      Width = 81
      Height = 21
      TabOrder = 1
      Text = 'Edit1'
    end
    object Edit_Count: TEdit
      Left = 216
      Top = 8
      Width = 81
      Height = 21
      TabOrder = 2
      Text = 'Edit1'
    end
    object Edit_Tickcount: TEdit
      Left = 216
      Top = 31
      Width = 81
      Height = 21
      TabOrder = 3
      Text = 'Edit1'
    end
    object Edit_Picprice: TEdit
      Left = 328
      Top = 30
      Width = 81
      Height = 21
      TabOrder = 4
      Text = 'Edit1'
    end
    object ComboBox_Unit: TComboBox
      Left = 328
      Top = 8
      Width = 81
      Height = 21
      ItemHeight = 13
      TabOrder = 5
      Text = #20010
      Items.Strings = (
        #20010
        #22871
        #30418
        #24352)
    end
    object Memo_Remark: TMemo
      Left = 448
      Top = 8
      Width = 121
      Height = 41
      Lines.Strings = (
        'Memo_Remark')
      TabOrder = 6
    end
    object Bit_Add: TBitBtn
      Left = 576
      Top = 12
      Width = 81
      Height = 33
      Caption = #28155#21152
      TabOrder = 7
      OnClick = Bit_AddClick
    end
    object Bit_Update: TBitBtn
      Left = 664
      Top = 12
      Width = 81
      Height = 33
      Caption = ' '#20837#24211
      TabOrder = 8
      OnClick = Bit_UpdateClick
    end
    object Bit_Delete: TBitBtn
      Left = 752
      Top = 12
      Width = 81
      Height = 33
      Caption = #21024#38500
      TabOrder = 9
      OnClick = Bit_DeleteClick
    end
    object Bit_Close: TBitBtn
      Left = 840
      Top = 12
      Width = 81
      Height = 33
      Caption = #20851#38381
      TabOrder = 10
      OnClick = Bit_CloseClick
    end
  end
  object DataSource_Giftsinfor: TDataSource
    DataSet = ADOQuery_Giftsinfor
    Left = 721
    Top = 156
  end
  object ADOQuery_Giftsinfor: TADOQuery
    Parameters = <>
    Left = 761
    Top = 156
  end
end
