object frm_frontoperate: Tfrm_frontoperate
  Left = 194
  Top = 122
  Width = 770
  Height = 595
  Caption = #26588#21488#25805#20316
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object pnlTitle: TPanel
    Left = 0
    Top = 0
    Width = 762
    Height = 41
    Align = alTop
    Caption = #26588#21488#25805#20316
    TabOrder = 0
  end
  object pgcFrontoperate: TPageControl
    Left = 0
    Top = 41
    Width = 762
    Height = 520
    ActivePage = tbsConfig
    Align = alClient
    MultiLine = True
    TabOrder = 1
    TabPosition = tpBottom
    object tbsConfig: TTabSheet
      Caption = #26032#24314#29992#25143
      ImageIndex = 1
      object GroupBox1: TGroupBox
        Left = 496
        Top = 0
        Width = 257
        Height = 257
        Caption = #25293#25668#29031#29255
        TabOrder = 0
      end
      object GroupBox2: TGroupBox
        Left = 496
        Top = 256
        Width = 257
        Height = 225
        Caption = #29992#25143#29031#29255
        TabOrder = 1
      end
      object GroupBox3: TGroupBox
        Left = 8
        Top = 0
        Width = 481
        Height = 73
        Caption = 'GroupBox3'
        TabOrder = 2
      end
      object GroupBox4: TGroupBox
        Left = 8
        Top = 88
        Width = 481
        Height = 121
        Caption = #26032#21345#26597#35810#21450#21345#31867#22411#26356#25913
        TabOrder = 3
        object Label1: TLabel
          Left = 17
          Top = 33
          Width = 60
          Height = 13
          Caption = #24080#25143#31867#22411#65306
        end
        object Label2: TLabel
          Left = 16
          Top = 80
          Width = 47
          Height = 13
          Caption = #21345'ID'#21495#65306
        end
        object ComboBox1: TComboBox
          Left = 88
          Top = 32
          Width = 201
          Height = 21
          ItemHeight = 13
          TabOrder = 0
          Text = 'ComboBox1'
        end
        object Edit1: TEdit
          Left = 88
          Top = 72
          Width = 201
          Height = 21
          TabOrder = 1
          Text = 'Edit1'
        end
        object BitBtn1: TBitBtn
          Left = 336
          Top = 64
          Width = 129
          Height = 33
          Caption = #26597#35810
          TabOrder = 2
        end
      end
      object GroupBox5: TGroupBox
        Left = 8
        Top = 216
        Width = 481
        Height = 273
        Caption = #29992#25143#22522#26412#36164#26009#24405#20837
        TabOrder = 4
        object Label3: TLabel
          Left = 17
          Top = 33
          Width = 60
          Height = 13
          Caption = #21360#21047#21345#21495#65306
        end
        object Label4: TLabel
          Left = 17
          Top = 65
          Width = 60
          Height = 13
          Caption = #29992#25143#22995#21517#65306
        end
        object Label5: TLabel
          Left = 17
          Top = 105
          Width = 60
          Height = 13
          Caption = #29992#25143#29983#26085#65306
        end
        object Label6: TLabel
          Left = 17
          Top = 137
          Width = 60
          Height = 13
          Caption = #36523#20221#35777#21495#65306
        end
        object Label7: TLabel
          Left = 17
          Top = 169
          Width = 48
          Height = 13
          Caption = #21345#25276#37329#65306
        end
        object Label8: TLabel
          Left = 17
          Top = 201
          Width = 60
          Height = 13
          Caption = #39044#30041#23494#30721#65306
        end
        object Label9: TLabel
          Left = 248
          Top = 32
          Width = 47
          Height = 13
          Caption = #21345'ID'#21495#65306
        end
        object Label10: TLabel
          Left = 145
          Top = 105
          Width = 6
          Height = 13
          Caption = '_'
        end
        object Label11: TLabel
          Left = 249
          Top = 169
          Width = 60
          Height = 13
          Caption = #21360#21047#21345#21495#65306
        end
        object Label12: TLabel
          Left = 248
          Top = 64
          Width = 60
          Height = 13
          Caption = #24615#21035#31867#22411#65306
        end
        object Label13: TLabel
          Left = 248
          Top = 104
          Width = 60
          Height = 13
          Caption = #25163#26426#21495#30721#65306
        end
        object Panel1: TPanel
          Left = 2
          Top = 230
          Width = 477
          Height = 41
          Align = alBottom
          BevelOuter = bvLowered
          TabOrder = 0
          object BitBtn2: TBitBtn
            Left = 88
            Top = 8
            Width = 97
            Height = 25
            Caption = #30830#23450
            TabOrder = 0
          end
          object BitBtn3: TBitBtn
            Left = 280
            Top = 8
            Width = 97
            Height = 25
            Caption = #20851#38381
            TabOrder = 1
          end
        end
        object Edit2: TEdit
          Left = 328
          Top = 32
          Width = 145
          Height = 21
          TabOrder = 1
          Text = 'Edit1'
        end
        object Edit3: TEdit
          Left = 80
          Top = 32
          Width = 145
          Height = 21
          TabOrder = 2
          Text = 'Edit3'
        end
        object Edit4: TEdit
          Left = 80
          Top = 64
          Width = 145
          Height = 21
          TabOrder = 3
          Text = 'Edit4'
        end
        object ComboBox2: TComboBox
          Left = 80
          Top = 104
          Width = 65
          Height = 21
          ItemHeight = 13
          TabOrder = 4
          Text = 'ComboBox2'
        end
        object ComboBox3: TComboBox
          Left = 160
          Top = 104
          Width = 65
          Height = 21
          ItemHeight = 13
          TabOrder = 5
          Text = 'ComboBox3'
        end
        object Edit5: TEdit
          Left = 80
          Top = 136
          Width = 393
          Height = 21
          TabOrder = 6
          Text = 'Edit5'
        end
        object Edit6: TEdit
          Left = 80
          Top = 168
          Width = 145
          Height = 21
          TabOrder = 7
          Text = 'Edit6'
        end
        object Edit7: TEdit
          Left = 80
          Top = 200
          Width = 145
          Height = 21
          TabOrder = 8
          Text = 'Edit7'
        end
        object ComboBox4: TComboBox
          Left = 328
          Top = 168
          Width = 145
          Height = 21
          ItemHeight = 13
          TabOrder = 9
          Text = 'ComboBox4'
        end
        object RadioGroup1: TRadioGroup
          Left = 328
          Top = 56
          Width = 145
          Height = 33
          TabOrder = 10
        end
        object RadioButton1: TRadioButton
          Left = 336
          Top = 64
          Width = 49
          Height = 17
          Caption = #30007
          TabOrder = 11
        end
        object RadioButton2: TRadioButton
          Left = 416
          Top = 64
          Width = 41
          Height = 17
          Caption = #22899
          TabOrder = 12
        end
        object Edit8: TEdit
          Left = 328
          Top = 104
          Width = 145
          Height = 21
          TabOrder = 13
          Text = 'Edit8'
        end
      end
    end
    object tbsLowLevel: TTabSheet
      Caption = #20805#20540
      object Edit9: TEdit
        Left = 176
        Top = 120
        Width = 65
        Height = 21
        TabOrder = 0
        Text = 'Edit9'
      end
    end
    object tbsPassDown: TTabSheet
      Caption = #25913#21345#23494#30721
      ImageIndex = 2
      object gbPasswordDown: TGroupBox
        Left = 8
        Top = 2
        Width = 447
        Height = 223
        Caption = #35831#24405#20837#23494#30721
        TabOrder = 0
        object lblPDSector0: TLabel
          Left = 27
          Top = 23
          Width = 35
          Height = 13
          AutoSize = False
          Caption = #25159#21306'0'
        end
        object lblPDSector1: TLabel
          Left = 27
          Top = 48
          Width = 35
          Height = 13
          AutoSize = False
          Caption = #25159#21306'1'
        end
        object lblPDSector2: TLabel
          Left = 27
          Top = 73
          Width = 35
          Height = 13
          AutoSize = False
          Caption = #25159#21306'2'
        end
        object lblPDSector3: TLabel
          Left = 27
          Top = 98
          Width = 35
          Height = 13
          AutoSize = False
          Caption = #25159#21306'3'
        end
        object lblPDSector4: TLabel
          Left = 27
          Top = 124
          Width = 35
          Height = 13
          AutoSize = False
          Caption = #25159#21306'4'
        end
        object lblPDSector5: TLabel
          Left = 27
          Top = 149
          Width = 35
          Height = 13
          AutoSize = False
          Caption = #25159#21306'5'
        end
        object lblPDSector6: TLabel
          Left = 27
          Top = 174
          Width = 35
          Height = 13
          AutoSize = False
          Caption = #25159#21306'6'
        end
        object lblPDSector7: TLabel
          Left = 27
          Top = 200
          Width = 35
          Height = 13
          AutoSize = False
          Caption = #25159#21306'7'
        end
        object lblPDSector8: TLabel
          Left = 244
          Top = 23
          Width = 35
          Height = 13
          AutoSize = False
          Caption = #25159#21306'8'
        end
        object lblPDSector9: TLabel
          Left = 245
          Top = 48
          Width = 35
          Height = 13
          AutoSize = False
          Caption = #25159#21306'9'
        end
        object lblPDSectorA: TLabel
          Left = 244
          Top = 73
          Width = 35
          Height = 13
          AutoSize = False
          Caption = #25159#21306'A'
        end
        object lblPDSectorB: TLabel
          Left = 244
          Top = 98
          Width = 35
          Height = 13
          AutoSize = False
          Caption = #25159#21306'B'
        end
        object lblPDSectorC: TLabel
          Left = 244
          Top = 124
          Width = 35
          Height = 13
          AutoSize = False
          Caption = #25159#21306'C'
        end
        object lblPDSectorD: TLabel
          Left = 244
          Top = 149
          Width = 35
          Height = 13
          AutoSize = False
          Caption = #25159#21306'D'
        end
        object lblPDSectorE: TLabel
          Left = 244
          Top = 174
          Width = 35
          Height = 13
          AutoSize = False
          Caption = #25159#21306'E'
        end
        object lblPDSectorF: TLabel
          Left = 244
          Top = 200
          Width = 35
          Height = 13
          AutoSize = False
          Caption = #25159#21306'F'
        end
        object edtSecPwd0: TEdit
          Left = 66
          Top = 19
          Width = 138
          Height = 21
          CharCase = ecUpperCase
          MaxLength = 12
          TabOrder = 0
        end
        object edtSecPwd1: TEdit
          Left = 66
          Top = 44
          Width = 138
          Height = 21
          CharCase = ecUpperCase
          MaxLength = 12
          TabOrder = 1
        end
        object edtSecPwd2: TEdit
          Left = 66
          Top = 69
          Width = 138
          Height = 21
          CharCase = ecUpperCase
          MaxLength = 12
          TabOrder = 2
        end
        object edtSecPwd3: TEdit
          Left = 66
          Top = 94
          Width = 138
          Height = 21
          CharCase = ecUpperCase
          MaxLength = 12
          TabOrder = 3
        end
        object edtSecPwd4: TEdit
          Left = 66
          Top = 120
          Width = 138
          Height = 21
          CharCase = ecUpperCase
          MaxLength = 12
          TabOrder = 4
        end
        object edtSecPwd5: TEdit
          Left = 66
          Top = 145
          Width = 138
          Height = 21
          CharCase = ecUpperCase
          MaxLength = 12
          TabOrder = 5
        end
        object edtSecPwd6: TEdit
          Left = 66
          Top = 170
          Width = 138
          Height = 21
          CharCase = ecUpperCase
          MaxLength = 12
          TabOrder = 6
        end
        object edtSecPwd7: TEdit
          Left = 66
          Top = 196
          Width = 138
          Height = 21
          CharCase = ecUpperCase
          MaxLength = 12
          TabOrder = 7
        end
        object edtSecPwd8: TEdit
          Left = 283
          Top = 19
          Width = 138
          Height = 21
          CharCase = ecUpperCase
          MaxLength = 12
          TabOrder = 8
        end
        object edtSecPwd9: TEdit
          Left = 283
          Top = 44
          Width = 138
          Height = 21
          CharCase = ecUpperCase
          MaxLength = 12
          TabOrder = 9
        end
        object edtSecPwd10: TEdit
          Left = 283
          Top = 69
          Width = 138
          Height = 21
          CharCase = ecUpperCase
          MaxLength = 12
          TabOrder = 10
        end
        object edtSecPwd11: TEdit
          Left = 283
          Top = 94
          Width = 138
          Height = 21
          CharCase = ecUpperCase
          MaxLength = 12
          TabOrder = 11
        end
        object edtSecPwd12: TEdit
          Left = 283
          Top = 120
          Width = 138
          Height = 21
          CharCase = ecUpperCase
          MaxLength = 12
          TabOrder = 12
        end
        object edtSecPwd13: TEdit
          Left = 283
          Top = 145
          Width = 138
          Height = 21
          CharCase = ecUpperCase
          MaxLength = 12
          TabOrder = 13
        end
        object edtSecPwd14: TEdit
          Left = 283
          Top = 170
          Width = 138
          Height = 21
          CharCase = ecUpperCase
          MaxLength = 12
          TabOrder = 14
        end
        object edtSecPwd15: TEdit
          Left = 283
          Top = 195
          Width = 138
          Height = 21
          CharCase = ecUpperCase
          MaxLength = 12
          TabOrder = 15
        end
      end
      object rgSePwdOrg: TRadioGroup
        Left = 72
        Top = 225
        Width = 185
        Height = 32
        Caption = #35831#36873#25321#19979#36733#23494#30721#32452
        Columns = 2
        ItemIndex = 0
        Items.Strings = (
          'A'#32452#23494#30721
          'B'#32452#23494#30721)
        TabOrder = 1
      end
      object btnPwdDwn: TButton
        Left = 312
        Top = 232
        Width = 75
        Height = 25
        Caption = #19979#36733
        TabOrder = 2
      end
    end
    object tbsDataOper: TTabSheet
      Caption = #29992#25143#25346#22833
      ImageIndex = 3
      object gbRWSector: TGroupBox
        Left = 13
        Top = 42
        Width = 289
        Height = 169
        Caption = #31532'0'#25159#21306
        TabOrder = 0
        object lblBlock0: TLabel
          Left = 24
          Top = 30
          Width = 20
          Height = 13
          AutoSize = False
          Caption = #22359'0'
        end
        object lblBlock1: TLabel
          Left = 24
          Top = 64
          Width = 20
          Height = 13
          AutoSize = False
          Caption = #22359'1'
        end
        object lblBlock2: TLabel
          Left = 24
          Top = 99
          Width = 20
          Height = 13
          AutoSize = False
          Caption = #22359'2'
        end
        object lblBlock3: TLabel
          Left = 24
          Top = 134
          Width = 20
          Height = 13
          AutoSize = False
          Caption = #22359'3'
        end
        object edtBlock0: TEdit
          Left = 57
          Top = 26
          Width = 207
          Height = 21
          CharCase = ecUpperCase
          MaxLength = 32
          TabOrder = 0
        end
        object edtBlock1: TEdit
          Left = 57
          Top = 60
          Width = 207
          Height = 21
          CharCase = ecUpperCase
          MaxLength = 32
          TabOrder = 1
        end
        object edtBlock2: TEdit
          Left = 57
          Top = 95
          Width = 207
          Height = 21
          CharCase = ecUpperCase
          MaxLength = 32
          TabOrder = 2
        end
        object edtBlock3: TEdit
          Left = 57
          Top = 130
          Width = 207
          Height = 21
          CharCase = ecUpperCase
          ReadOnly = True
          TabOrder = 3
        end
      end
      object gbRWSeSec: TGroupBox
        Left = 319
        Top = 42
        Width = 129
        Height = 71
        Caption = #35831#36873#25321#25159#21306#21495
        TabOrder = 1
        object cbRWSec: TComboBox
          Left = 13
          Top = 29
          Width = 103
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          ItemIndex = 0
          TabOrder = 0
          Text = #31532'0'#25159#21306
          Items.Strings = (
            #31532'0'#25159#21306
            #31532'1'#25159#21306
            #31532'2'#25159#21306
            #31532'3'#25159#21306
            #31532'4'#25159#21306
            #31532'5'#25159#21306
            #31532'6'#25159#21306
            #31532'7'#25159#21306
            #31532'8'#25159#21306
            #31532'9'#25159#21306
            #31532'10'#25159#21306
            #31532'11'#25159#21306
            #31532'12'#25159#21306
            #31532'13'#25159#21306
            #31532'14'#25159#21306
            #31532'15'#25159#21306)
        end
      end
      object btnBlockRd: TButton
        Left = 346
        Top = 145
        Width = 75
        Height = 25
        Caption = #35835#20986
        TabOrder = 2
      end
      object btnBlockWt: TButton
        Left = 346
        Top = 185
        Width = 75
        Height = 25
        Caption = #20889#20837
        TabOrder = 3
      end
    end
    object tbsBlockOper: TTabSheet
      Caption = #23458#25143#34917#21345
      ImageIndex = 4
      object gbReOrWt: TGroupBox
        Left = 25
        Top = 46
        Width = 257
        Height = 121
        Caption = #35835#20889#20869#23481
        TabOrder = 0
        object lblCurValue: TLabel
          Left = 20
          Top = 34
          Width = 36
          Height = 13
          Caption = #24403#21069#20540
        end
        object lblOpeValue: TLabel
          Left = 20
          Top = 74
          Width = 36
          Height = 13
          Caption = #25805#20316#20540
        end
        object edtCurValue: TEdit
          Left = 76
          Top = 30
          Width = 161
          Height = 21
          TabOrder = 0
        end
        object edtOpeValue: TEdit
          Left = 76
          Top = 70
          Width = 161
          Height = 21
          CharCase = ecUpperCase
          MaxLength = 8
          TabOrder = 1
        end
      end
      object gbBkSec: TGroupBox
        Left = 305
        Top = 46
        Width = 130
        Height = 50
        Caption = #25159#21306#21495
        TabOrder = 1
        object cbBSecSe: TComboBox
          Left = 12
          Top = 19
          Width = 106
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          ItemIndex = 0
          TabOrder = 0
          Text = #31532'0'#25159#21306
          Items.Strings = (
            #31532'0'#25159#21306
            #31532'1'#25159#21306
            #31532'2'#25159#21306
            #31532'3'#25159#21306
            #31532'4'#25159#21306
            #31532'5'#25159#21306
            #31532'6'#25159#21306
            #31532'7'#25159#21306
            #31532'8'#25159#21306
            #31532'9'#25159#21306
            #31532'10'#25159#21306
            #31532'11'#25159#21306
            #31532'12'#25159#21306
            #31532'13'#25159#21306
            #31532'14'#25159#21306
            #31532'15'#25159#21306)
        end
      end
      object gbBlokSe: TGroupBox
        Left = 305
        Top = 117
        Width = 130
        Height = 50
        Caption = #22359#21495
        TabOrder = 2
        object cbBSe: TComboBox
          Left = 12
          Top = 19
          Width = 106
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          ItemIndex = 1
          TabOrder = 0
          Text = #31532'1 '#22359
          Items.Strings = (
            #31532'0 '#22359
            #31532'1 '#22359
            #31532'2 '#22359)
        end
      end
      object btnBlockInit: TButton
        Left = 49
        Top = 198
        Width = 75
        Height = 25
        Caption = #21021#22987#21270
        TabOrder = 3
      end
      object btnBlockRead: TButton
        Left = 145
        Top = 198
        Width = 75
        Height = 25
        Caption = #35835#21462
        TabOrder = 4
      end
      object btnBlockAdd: TButton
        Left = 241
        Top = 198
        Width = 75
        Height = 25
        Caption = #21152#20540
        TabOrder = 5
      end
      object btnBlockSub: TButton
        Left = 337
        Top = 198
        Width = 75
        Height = 25
        Caption = #20943#20540
        TabOrder = 6
      end
    end
    object tbsPassCh: TTabSheet
      Caption = #20154#24037#21806#24065
      ImageIndex = 5
      object gbEntryPwd: TGroupBox
        Left = 29
        Top = 18
        Width = 217
        Height = 81
        Caption = #35831#36755#20837#23494#30721
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        object lblPwdA: TLabel
          Left = 20
          Top = 24
          Width = 31
          Height = 13
          Caption = #23494#30721'A'
        end
        object lblPwdB: TLabel
          Left = 20
          Top = 53
          Width = 31
          Height = 13
          Caption = #23494#30721'B'
        end
        object edtPwdA: TEdit
          Left = 60
          Top = 20
          Width = 137
          Height = 21
          CharCase = ecUpperCase
          MaxLength = 12
          TabOrder = 0
        end
        object edtPwdB: TEdit
          Left = 60
          Top = 49
          Width = 137
          Height = 21
          CharCase = ecUpperCase
          MaxLength = 12
          TabOrder = 1
        end
      end
      object gbConBit: TGroupBox
        Left = 29
        Top = 114
        Width = 217
        Height = 135
        Caption = #35831#36755#20837#25511#20214#20301
        TabOrder = 1
        object lblConBit0: TLabel
          Left = 20
          Top = 27
          Width = 30
          Height = 13
          Caption = #31532'0'#22359
        end
        object lblConBit1: TLabel
          Left = 20
          Top = 54
          Width = 30
          Height = 13
          Caption = #31532'1'#22359
        end
        object lblConBit2: TLabel
          Left = 20
          Top = 81
          Width = 30
          Height = 13
          Caption = #31532'2'#22359
        end
        object lblConBit3: TLabel
          Left = 20
          Top = 109
          Width = 30
          Height = 13
          Caption = #31532'3'#22359
        end
        object edtConBit0: TEdit
          Left = 60
          Top = 23
          Width = 137
          Height = 21
          TabOrder = 0
        end
        object edtConBit1: TEdit
          Left = 60
          Top = 50
          Width = 137
          Height = 21
          TabOrder = 1
        end
        object edtConBit2: TEdit
          Left = 60
          Top = 77
          Width = 137
          Height = 21
          TabOrder = 2
        end
        object edtConBit3: TEdit
          Left = 60
          Top = 105
          Width = 137
          Height = 21
          TabOrder = 3
        end
      end
      object gbChPwdSec: TGroupBox
        Left = 300
        Top = 18
        Width = 130
        Height = 50
        Caption = #25159#21306#21495
        TabOrder = 2
        object cbChPwdSec: TComboBox
          Left = 12
          Top = 19
          Width = 106
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          ItemIndex = 0
          TabOrder = 0
          Text = #31532'0'#25159#21306
          Items.Strings = (
            #31532'0'#25159#21306
            #31532'1'#25159#21306
            #31532'2'#25159#21306
            #31532'3'#25159#21306
            #31532'4'#25159#21306
            #31532'5'#25159#21306
            #31532'6'#25159#21306
            #31532'7'#25159#21306
            #31532'8'#25159#21306
            #31532'9'#25159#21306
            #31532'10'#25159#21306
            #31532'11'#25159#21306
            #31532'12'#25159#21306
            #31532'13'#25159#21306
            #31532'14'#25159#21306
            #31532'15'#25159#21306)
        end
      end
      object btnChPwd: TButton
        Left = 321
        Top = 144
        Width = 89
        Height = 25
        Caption = #20462#25913#23494#30721
        TabOrder = 3
      end
      object btnChCon: TButton
        Left = 321
        Top = 201
        Width = 89
        Height = 25
        Caption = #20462#25913#25511#21046#20301
        Enabled = False
        TabOrder = 4
      end
    end
    object tbsSeRe: TTabSheet
      Caption = #29992#25143#36864#21345
      ImageIndex = 6
      object gbComSendRec: TGroupBox
        Left = 14
        Top = 11
        Width = 432
        Height = 241
        Caption = #20018#21475#20449#24687#21457#36865#19982#25509#25910
        TabOrder = 0
        object lblExplain: TLabel
          Left = 147
          Top = 16
          Width = 162
          Height = 13
          Caption = '==>>'#21040#19979#20301#26426'      <<=='#21040#19978#20301#26426
        end
        object memComSeRe: TMemo
          Left = 8
          Top = 40
          Width = 417
          Height = 193
          ScrollBars = ssVertical
          TabOrder = 0
        end
      end
    end
    object TabSheet1: TTabSheet
      Caption = #29992#25143#28040#20998
      ImageIndex = 7
    end
  end
end
