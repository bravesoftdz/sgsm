object frm_IC_SetParameter_softparaset: Tfrm_IC_SetParameter_softparaset
  Left = 418
  Top = 185
  Width = 504
  Height = 449
  BorderIcons = []
  Caption = #31995#32479#36719#20214#35774#32622
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
  object pgcMenberfor: TPageControl
    Left = 0
    Top = 0
    Width = 496
    Height = 422
    ActivePage = TabSheet1
    Align = alClient
    MultiLine = True
    TabOrder = 0
    object tbsConfig: TTabSheet
      Caption = #36719#20214#21442#25968#35774#32622
      ImageIndex = 1
      object Panel3: TPanel
        Left = 0
        Top = 343
        Width = 488
        Height = 51
        Align = alBottom
        TabOrder = 0
        object BitBtn17: TBitBtn
          Left = 288
          Top = 8
          Width = 81
          Height = 33
          Caption = #26032#22686
          TabOrder = 0
        end
        object BitBtn20: TBitBtn
          Left = 392
          Top = 8
          Width = 81
          Height = 33
          Caption = #20851#38381
          TabOrder = 1
          OnClick = BitBtn20Click
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 488
        Height = 343
        Align = alClient
        TabOrder = 1
        object Label3: TLabel
          Left = 196
          Top = 21
          Width = 90
          Height = 13
          Caption = #26174#31034#35760#24405#26465#25968'      '
        end
        object Label8: TLabel
          Left = 204
          Top = 85
          Width = 66
          Height = 13
          Caption = #20445#23384#36335#24452'      '
        end
        object Label13: TLabel
          Left = 204
          Top = 117
          Width = 102
          Height = 13
          Caption = #21345#26368#22823#23384#20648#20313#39069'      '
        end
        object Label14: TLabel
          Left = 260
          Top = 149
          Width = 39
          Height = 13
          Caption = #31215#20998'     '
        end
        object Label15: TLabel
          Left = 124
          Top = 213
          Width = 84
          Height = 13
          Caption = #22777#20998#25442#20960#20010#24065'    '
        end
        object CheckBox1: TCheckBox
          Left = 8
          Top = 8
          Width = 185
          Height = 41
          Caption = #21069#21488#25910#38134#26174#31034#21382#21490#35760#24405
          TabOrder = 0
        end
        object CheckBox2: TCheckBox
          Left = 8
          Top = 40
          Width = 185
          Height = 41
          Caption = #24320#21345#26377#25928#26399#24180#38480
          TabOrder = 1
        end
        object CheckBox3: TCheckBox
          Left = 8
          Top = 71
          Width = 185
          Height = 41
          Caption = #21069#21488#25910#38134#25293#29031#22270#29255#23384#21152#23494'   '
          TabOrder = 2
        end
        object Edit1: TEdit
          Left = 272
          Top = 80
          Width = 161
          Height = 21
          Enabled = False
          TabOrder = 3
          Text = 'Edit1'
        end
        object BitBtn1: TBitBtn
          Left = 400
          Top = 77
          Width = 41
          Height = 25
          Caption = #12290#12290#12290
          TabOrder = 4
        end
        object CheckBox4: TCheckBox
          Left = 8
          Top = 103
          Width = 145
          Height = 41
          Caption = #29992#25143#24320#21345#25276#37329#35774#32622'  '
          TabOrder = 5
        end
        object MaskEdit1: TMaskEdit
          Left = 304
          Top = 112
          Width = 129
          Height = 21
          Enabled = False
          TabOrder = 6
          Text = 'MaskEdit1'
        end
        object CheckBox5: TCheckBox
          Left = 8
          Top = 135
          Width = 145
          Height = 41
          Caption = #20805#20540#20817#25442#20998#20540' '
          TabOrder = 7
        end
        object MaskEdit2: TMaskEdit
          Left = 112
          Top = 144
          Width = 89
          Height = 21
          Enabled = False
          TabOrder = 8
          Text = 'MaskEdit1'
        end
        object MaskEdit3: TMaskEdit
          Left = 304
          Top = 144
          Width = 129
          Height = 21
          Enabled = False
          TabOrder = 9
          Text = 'MaskEdit1'
        end
        object CheckBox6: TCheckBox
          Left = 8
          Top = 167
          Width = 145
          Height = 41
          Caption = #24635#20817#29575' '
          TabOrder = 10
        end
        object MaskEdit4: TMaskEdit
          Left = 112
          Top = 175
          Width = 89
          Height = 21
          Enabled = False
          TabOrder = 11
          Text = 'MaskEdit1'
        end
        object CheckBox7: TCheckBox
          Left = 8
          Top = 199
          Width = 105
          Height = 41
          Caption = #36141#20195#24065#31995#25968
          TabOrder = 12
        end
        object CheckBox8: TCheckBox
          Left = 8
          Top = 231
          Width = 121
          Height = 41
          Caption = #40664#35748#24080#25143#31867#22411
          TabOrder = 13
        end
        object CheckBox9: TCheckBox
          Left = 8
          Top = 263
          Width = 105
          Height = 41
          Caption = #36890#20449#24310#26102
          TabOrder = 14
        end
        object CheckBox10: TCheckBox
          Left = 8
          Top = 295
          Width = 105
          Height = 34
          Caption = #20132#29677#25171#21360#25253#34920
          TabOrder = 15
        end
        object ComboBox7: TComboBox
          Left = 132
          Top = 304
          Width = 77
          Height = 21
          Enabled = False
          ItemHeight = 13
          TabOrder = 16
          Text = #19981#25171#21360
          Items.Strings = (
            #19981#25171#21360
            #25171#21360)
        end
        object SpinEdit1: TSpinEdit
          Left = 280
          Top = 16
          Width = 57
          Height = 22
          Enabled = False
          MaxValue = 0
          MinValue = 0
          TabOrder = 17
          Value = 5
        end
        object SpinEdit2: TSpinEdit
          Left = 192
          Top = 48
          Width = 145
          Height = 22
          Enabled = False
          MaxValue = 0
          MinValue = 0
          TabOrder = 18
          Value = 10
        end
        object SpinEdit3: TSpinEdit
          Left = 144
          Top = 112
          Width = 57
          Height = 22
          Enabled = False
          MaxValue = 0
          MinValue = 0
          TabOrder = 19
          Value = 10
        end
        object SpinEdit4: TSpinEdit
          Left = 208
          Top = 208
          Width = 57
          Height = 22
          Enabled = False
          MaxValue = 20
          MinValue = 0
          TabOrder = 20
          Value = 2
        end
        object SpinEdit5: TSpinEdit
          Left = 132
          Top = 272
          Width = 77
          Height = 22
          Enabled = False
          MaxValue = 0
          MinValue = 0
          TabOrder = 21
          Value = 40
        end
      end
    end
    object tbsLowLevel: TTabSheet
      Caption = #23567#31080#25171#21360#26426#35774#32622
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 488
        Height = 394
        Align = alClient
        Caption = 'Panel1'
        TabOrder = 0
        object Panel4: TPanel
          Left = 1
          Top = 1
          Width = 486
          Height = 341
          Align = alClient
          TabOrder = 0
          object Label1: TLabel
            Left = 12
            Top = 77
            Width = 63
            Height = 13
            Caption = #20844#21496#21517#31216'     '
          end
          object Label6: TLabel
            Left = 12
            Top = 109
            Width = 60
            Height = 13
            Caption = #32852#31995#30005#35805'    '
          end
          object Label16: TLabel
            Left = 12
            Top = 141
            Width = 60
            Height = 13
            Caption = #20844#21496#32593#22336'    '
          end
          object Label17: TLabel
            Left = 12
            Top = 181
            Width = 54
            Height = 13
            Caption = #32852#31995#22320#22336'  '
          end
          object GroupBox1: TGroupBox
            Left = 8
            Top = 8
            Width = 225
            Height = 41
            Caption = #36873#25321#23567#31080#25171#21360#26426
            TabOrder = 0
            object ComboBox1: TComboBox
              Left = 8
              Top = 16
              Width = 217
              Height = 21
              ItemHeight = 13
              TabOrder = 0
              Text = 'ComboBox1'
            end
          end
          object Edit2: TEdit
            Left = 80
            Top = 72
            Width = 153
            Height = 21
            TabOrder = 1
            Text = 'Edit2'
          end
          object Edit3: TEdit
            Left = 80
            Top = 104
            Width = 153
            Height = 21
            TabOrder = 2
            Text = 'Edit2'
          end
          object Edit4: TEdit
            Left = 80
            Top = 136
            Width = 153
            Height = 21
            TabOrder = 3
            Text = 'Edit2'
          end
          object Edit5: TEdit
            Left = 80
            Top = 176
            Width = 153
            Height = 21
            TabOrder = 4
            Text = 'Edit2'
          end
          object rgSexOrg: TRadioGroup
            Left = 248
            Top = 9
            Width = 209
            Height = 184
            Caption = #26412#36719#20214#26159#21542#25171#21360
            ItemIndex = 0
            Items.Strings = (
              #20351#29992#25171#21360#26426
              #19981#20351#29992#25171#21360#26426)
            TabOrder = 5
          end
          object BitBtn6: TBitBtn
            Left = 16
            Top = 240
            Width = 177
            Height = 33
            Caption = #21462#24471#40664#35748#25171#21360#26426
            TabOrder = 6
            OnClick = BitBtn6Click
          end
          object ComboBox2: TComboBox
            Left = 16
            Top = 280
            Width = 217
            Height = 21
            ItemHeight = 13
            TabOrder = 7
            Text = 'ComboBox1'
          end
          object BitBtn7: TBitBtn
            Left = 104
            Top = 0
            Width = 113
            Height = 25
            Caption = #35774#32622#40664#35748#25171#21360#26426
            TabOrder = 8
            OnClick = BitBtn7Click
          end
        end
        object Panel7: TPanel
          Left = 1
          Top = 342
          Width = 486
          Height = 51
          Align = alBottom
          TabOrder = 1
          object BitBtn3: TBitBtn
            Left = 288
            Top = 8
            Width = 81
            Height = 33
            Caption = #26032#22686
            TabOrder = 0
          end
          object BitBtn4: TBitBtn
            Left = 392
            Top = 8
            Width = 81
            Height = 33
            Caption = #20851#38381
            TabOrder = 1
            OnClick = BitBtn4Click
          end
        end
      end
    end
    object TabSheet1: TTabSheet
      Caption = #24080#21333#25171#21360#26426#35774#32622
      ImageIndex = 2
      object Panel5: TPanel
        Left = 0
        Top = 0
        Width = 488
        Height = 394
        Align = alClient
        Caption = 'Panel1'
        TabOrder = 0
        object Panel6: TPanel
          Left = 1
          Top = 1
          Width = 486
          Height = 341
          Align = alClient
          TabOrder = 0
          object GroupBox2: TGroupBox
            Left = 8
            Top = 8
            Width = 225
            Height = 209
            Caption = #36873#25321#24080#21333#25171#21360#26426
            TabOrder = 0
            object ListBox1: TListBox
              Left = 16
              Top = 36
              Width = 201
              Height = 161
              ItemHeight = 13
              TabOrder = 0
            end
            object Edit6: TEdit
              Left = 16
              Top = 16
              Width = 201
              Height = 21
              TabOrder = 1
              Text = 'Edit6'
            end
          end
          object RadioGroup1: TRadioGroup
            Left = 248
            Top = 9
            Width = 209
            Height = 208
            Caption = #26412#36719#20214#26159#21542#25171#21360
            ItemIndex = 0
            Items.Strings = (
              #20351#29992#25171#21360#26426
              #19981#20351#29992#25171#21360#26426)
            TabOrder = 1
          end
        end
        object Panel8: TPanel
          Left = 1
          Top = 342
          Width = 486
          Height = 51
          Align = alBottom
          TabOrder = 1
          object BitBtn2: TBitBtn
            Left = 288
            Top = 8
            Width = 81
            Height = 33
            Caption = #26032#22686
            TabOrder = 0
          end
          object BitBtn5: TBitBtn
            Left = 392
            Top = 8
            Width = 81
            Height = 33
            Caption = #20851#38381
            TabOrder = 1
            OnClick = BitBtn5Click
          end
        end
      end
    end
  end
end
