object frm_IC_Report_Menberinfo: Tfrm_IC_Report_Menberinfo
  Left = 296
  Top = 185
  Width = 854
  Height = 500
  BorderIcons = []
  Caption = #29992#25143#20449#24687#25253#34920
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
  object pgcMachinerecord: TPageControl
    Left = 0
    Top = 0
    Width = 846
    Height = 473
    ActivePage = tbsConfig
    Align = alClient
    MultiLine = True
    TabOrder = 0
    TabWidth = 82
    object tbsConfig: TTabSheet
      Caption = #29992#25143#20449#24687#25253#34920
      ImageIndex = 1
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 838
        Height = 89
        Align = alTop
        BorderStyle = bsSingle
        TabOrder = 0
        object Panel9: TPanel
          Left = 1
          Top = 1
          Width = 520
          Height = 83
          Align = alLeft
          BevelOuter = bvLowered
          TabOrder = 0
          object Label2: TLabel
            Left = 313
            Top = 12
            Width = 15
            Height = 13
            Caption = #33267' '
          end
          object Label6: TLabel
            Left = 8
            Top = 8
            Width = 108
            Height = 13
            Caption = #26465#20214#19968#65306#25805#20316#26085#26399'    '
          end
          object Label7: TLabel
            Left = 8
            Top = 32
            Width = 121
            Height = 13
            Caption = #26465#20214#20108#65306#25805#20316#21592' '
          end
          object Label8: TLabel
            Left = 8
            Top = 56
            Width = 72
            Height = 13
            Caption = #26465#20214#22235#65306#20854#20182
          end
          object Label9: TLabel
            Left = 312
            Top = 35
            Width = 84
            Height = 13
            Caption = #26465#20214#19977#65306#21345#29366#24577
          end
          object DateTimePicker_Start_Menberinfo: TDateTimePicker
            Left = 128
            Top = 7
            Width = 86
            Height = 21
            Date = 39996.465388541670000000
            Format = 'yyyy-MM-dd'
            Time = 39996.465388541670000000
            TabOrder = 0
          end
          object DateTimePicker_End_Menberinfo: TDateTimePicker
            Left = 328
            Top = 6
            Width = 81
            Height = 21
            Date = 41080.465738587960000000
            Format = 'yyyy-MM-dd'
            Time = 41080.465738587960000000
            TabOrder = 1
          end
          object ComboBox_Operator_Menberinfo: TComboBox
            Left = 127
            Top = 31
            Width = 89
            Height = 21
            ItemHeight = 13
            TabOrder = 2
            Text = #20840#37096
          end
          object ComboBox_other_Menberinfo: TComboBox
            Left = 127
            Top = 55
            Width = 89
            Height = 21
            ItemHeight = 13
            TabOrder = 3
            Text = #20840#37096
            Items.Strings = (
              #20840#37096
              #29992#25143#32534#21495
              #29992#25143#22995#21517)
          end
          object Edit_other_Menberinfo: TEdit
            Left = 217
            Top = 55
            Width = 145
            Height = 21
            TabOrder = 4
          end
          object TimePicker_Start_Menberinfo: TDateTimePicker
            Left = 216
            Top = 7
            Width = 89
            Height = 19
            Date = 40457.670287175920000000
            Format = 'hh:mm:ss'
            Time = 40457.670287175920000000
            Kind = dtkTime
            TabOrder = 5
          end
          object TimePicker_End_Menberinfo: TDateTimePicker
            Left = 416
            Top = 8
            Width = 89
            Height = 19
            Date = 40457.670287175920000000
            Time = 40457.670287175920000000
            Kind = dtkTime
            TabOrder = 6
          end
          object ComboBox_Cardstate_Menberinfo: TComboBox
            Left = 416
            Top = 31
            Width = 89
            Height = 21
            ItemHeight = 13
            TabOrder = 7
            Text = #20840#37096
          end
        end
        object Panel10: TPanel
          Left = 521
          Top = 1
          Width = 312
          Height = 83
          Align = alClient
          BevelOuter = bvLowered
          TabOrder = 1
          object Bit_Print_Menberinfo: TBitBtn
            Left = 101
            Top = 24
            Width = 89
            Height = 33
            Caption = #25171#21360
            TabOrder = 0
            OnClick = Bit_Print_MenberinfoClick
          end
          object Bit_Close_Menberinfo: TBitBtn
            Left = 197
            Top = 24
            Width = 81
            Height = 33
            Caption = #20851#38381
            TabOrder = 1
            OnClick = Bit_Close_MenberinfoClick
          end
          object Bit_Query_Menberinfo: TBitBtn
            Left = 5
            Top = 24
            Width = 89
            Height = 33
            Caption = #26597#35810
            TabOrder = 2
            OnClick = Bit_Query_MenberinfoClick
          end
        end
      end
      object Panel3: TPanel
        Left = 0
        Top = 89
        Width = 838
        Height = 356
        Align = alClient
        Caption = 'Panel1'
        TabOrder = 1
        object DBGridEh_Menberinfo: TDBGridEh
          Left = 1
          Top = 1
          Width = 836
          Height = 354
          Align = alClient
          DataGrouping.Active = True
          DataGrouping.GroupLevels = <>
          DataSource = DataSource_Menberinfo
          Flat = False
          FooterColor = clWindow
          FooterFont.Charset = DEFAULT_CHARSET
          FooterFont.Color = clWindowText
          FooterFont.Height = -11
          FooterFont.Name = 'MS Sans Serif'
          FooterFont.Style = []
          RowDetailPanel.Color = clBtnFace
          SumList.Active = True
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
          TitleLines = 1
          UseMultiTitle = True
          Columns = <
            item
              Checkboxes = False
              EditButtons = <>
              FieldName = 'MemCardNo'
              Footers = <>
              MaxWidth = 60
              Title.Caption = #29992#25143#32534#21495
              Width = 60
            end
            item
              EditButtons = <>
              FieldName = 'MemberName'
              Footers = <>
              MaxWidth = 64
              Title.Caption = #29992#25143#22995#21517
            end
            item
              EditButtons = <>
              FieldName = 'SexName'
              Footers = <>
              Title.Caption = #24615#21035
              Width = 40
            end
            item
              EditButtons = <>
              FieldName = 'LevName'
              Footers = <>
              Title.Caption = #20250#21592#31561#32423
            end
            item
              EditButtons = <>
              FieldName = 'Score'
              Footers = <>
              Title.Caption = #20250#21592#31215#20998
            end
            item
              EditButtons = <>
              FieldName = 'CardAmount'
              Footers = <>
              Title.Caption = #24080#25143#20313#39069
            end
            item
              EditButtons = <>
              FieldName = 'TickAmount'
              Footers = <>
              Title.Caption = #24425#31080#25968
            end
            item
              EditButtons = <>
              FieldName = 'TotalMoney'
              Footers = <>
              Title.Caption = #24635#20805#20540
            end
            item
              EditButtons = <>
              Footers = <>
              Title.Caption = #24635#28040#20998
            end
            item
              EditButtons = <>
              FieldName = 'Deposit'
              Footers = <>
              Title.Caption = #25276#37329#25910#20837
              Width = 60
            end
            item
              EditButtons = <>
              Footers = <>
              Title.Caption = #36192#36865#20998#25968
            end
            item
              EditButtons = <>
              FieldName = 'IsableName'
              Footers = <>
              Title.Caption = #21345#29366#24577
              Width = 50
            end
            item
              EditButtons = <>
              FieldName = 'OpenCardDT'
              Footers = <>
              Title.Caption = #21457#21345#26102#38388
            end
            item
              EditButtons = <>
              FieldName = 'cUserName'
              Footers = <>
              Title.Caption = #25805#20316#21592#22995#21517
            end>
          object RowDetailData: TRowDetailPanelControlEh
          end
        end
      end
    end
    object Tab_Gamenameinput: TTabSheet
      Caption = #34917#21345#29992#25143#32479#35745
      ImageIndex = 2
      object Panel8: TPanel
        Left = 0
        Top = 0
        Width = 838
        Height = 445
        Align = alClient
        Caption = 'Panel1'
        TabOrder = 0
        object Panel1: TPanel
          Left = 1
          Top = 1
          Width = 836
          Height = 88
          Align = alTop
          Caption = 'Panel1'
          TabOrder = 0
          object Panel4: TPanel
            Left = 1
            Top = 1
            Width = 520
            Height = 86
            Align = alLeft
            BevelOuter = bvLowered
            TabOrder = 0
            object Label1: TLabel
              Left = 313
              Top = 12
              Width = 15
              Height = 13
              Caption = #33267' '
            end
            object Label3: TLabel
              Left = 8
              Top = 8
              Width = 108
              Height = 13
              Caption = #26465#20214#19968#65306#25805#20316#26085#26399'    '
            end
            object Label4: TLabel
              Left = 8
              Top = 32
              Width = 87
              Height = 13
              Caption = #26465#20214#20108#65306#25805#20316#21592' '
            end
            object Label5: TLabel
              Left = 8
              Top = 56
              Width = 72
              Height = 13
              Caption = #26465#20214#19977#65306#20854#20182
            end
            object DateTimePicker_Start_Recard: TDateTimePicker
              Left = 128
              Top = 7
              Width = 86
              Height = 21
              Date = 39996.465388541670000000
              Format = 'yyyy-MM-dd'
              Time = 39996.465388541670000000
              TabOrder = 0
            end
            object DateTimePicker_End_Recard: TDateTimePicker
              Left = 328
              Top = 6
              Width = 81
              Height = 21
              Date = 41080.465738587960000000
              Format = 'yyyy-MM-dd'
              Time = 41080.465738587960000000
              TabOrder = 1
            end
            object ComboBox_Operator_Recard: TComboBox
              Left = 127
              Top = 31
              Width = 89
              Height = 21
              ItemHeight = 0
              TabOrder = 2
              Text = #20840#37096
            end
            object ComboBox_other_Recard: TComboBox
              Left = 127
              Top = 55
              Width = 89
              Height = 21
              ItemHeight = 13
              TabOrder = 3
              Text = #20840#37096
              Items.Strings = (
                #20840#37096
                #29992#25143#32534#21495
                #29992#25143#22995#21517)
            end
            object Edit_other_Recard: TEdit
              Left = 217
              Top = 55
              Width = 145
              Height = 21
              TabOrder = 4
            end
            object TimePicker_Start_Recard: TDateTimePicker
              Left = 216
              Top = 7
              Width = 89
              Height = 19
              Date = 40457.670287175920000000
              Format = 'hh:mm:ss'
              Time = 40457.670287175920000000
              Kind = dtkTime
              TabOrder = 5
            end
            object TimePicker_End_Recard: TDateTimePicker
              Left = 416
              Top = 8
              Width = 89
              Height = 19
              Date = 40457.670287175920000000
              Time = 40457.670287175920000000
              Kind = dtkTime
              TabOrder = 6
            end
          end
          object Panel5: TPanel
            Left = 521
            Top = 1
            Width = 314
            Height = 86
            Align = alClient
            BevelOuter = bvLowered
            TabOrder = 1
            object Bit_Print_Recard: TBitBtn
              Left = 101
              Top = 24
              Width = 89
              Height = 33
              Caption = #25171#21360
              TabOrder = 0
              OnClick = Bit_Print_RecardClick
            end
            object Bit_Close_Recard: TBitBtn
              Left = 197
              Top = 24
              Width = 81
              Height = 33
              Caption = #20851#38381
              TabOrder = 1
              OnClick = Bit_Close_RecardClick
            end
            object Bit_Query_Recard: TBitBtn
              Left = 5
              Top = 24
              Width = 89
              Height = 33
              Caption = #26597#35810
              TabOrder = 2
              OnClick = Bit_Query_RecardClick
            end
          end
        end
        object DBGridEh_Recard: TDBGridEh
          Left = 1
          Top = 89
          Width = 836
          Height = 355
          Align = alClient
          DataGrouping.GroupLevels = <>
          DataSource = DataSource_RecardinfoPrint
          Flat = False
          FooterColor = clWindow
          FooterFont.Charset = DEFAULT_CHARSET
          FooterFont.Color = clWindowText
          FooterFont.Height = -11
          FooterFont.Name = 'MS Sans Serif'
          FooterFont.Style = []
          RowDetailPanel.Color = clBtnFace
          TabOrder = 1
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
          TitleLines = 1
          UseMultiTitle = True
          Columns = <
            item
              Checkboxes = False
              EditButtons = <>
              FieldName = 'OldCardNo'
              Footers = <>
              Title.Caption = #21407#29992#21345#21495
            end
            item
              Checkboxes = False
              EditButtons = <>
              FieldName = 'MemCardNo'
              Footers = <>
              Title.Caption = #29992#25143#32534#21495
              Width = 96
            end
            item
              EditButtons = <>
              FieldName = 'MemberName'
              Footers = <>
              Title.Caption = #29992#25143#22995#21517
            end
            item
              EditButtons = <>
              FieldName = 'SexName'
              Footers = <>
              Title.Caption = #24615#21035
            end
            item
              EditButtons = <>
              FieldName = 'GetTime'
              Footers = <>
              Title.Caption = #34917#21345#26102#38388
              Width = 140
            end
            item
              EditButtons = <>
              FieldName = 'CardAmount'
              Footers = <>
              Title.Caption = #24080#25143#20313#39069
            end
            item
              EditButtons = <>
              FieldName = 'Deposit'
              Footers = <>
              Title.Caption = #25276#37329#25910#20837
            end
            item
              EditButtons = <>
              FieldName = 'Remark'
              Footers = <>
              Title.Caption = #34917#21345#21407#22240
              Width = 200
            end
            item
              EditButtons = <>
              FieldName = 'cUserName'
              Footers = <>
              Title.Caption = #25805#20316#21592#22995#21517
            end>
          object RowDetailData: TRowDetailPanelControlEh
          end
        end
      end
    end
  end
  object RvRenderPrinter_MenberinfoPrint: TRvRenderPrinter
    DisplayName = 'RPRender'
    Left = 102
    Top = 354
  end
  object RvPro_MenberinfoPrint: TRvProject
    Engine = RvSystem_MenberinfoPrint
    ProjectFile = 'Project_Menberinfo.rav'
    Left = 134
    Top = 354
  end
  object RvSystem_MenberinfoPrint: TRvSystem
    TitleSetup = 'Output Options'
    TitleStatus = 'Report Status'
    TitlePreview = 'Report Preview'
    SystemFiler.StatusFormat = 'Generating page %p'
    SystemPreview.ZoomFactor = 100.000000000000000000
    SystemPrinter.ScaleX = 100.000000000000000000
    SystemPrinter.ScaleY = 100.000000000000000000
    SystemPrinter.StatusFormat = 'Printing page %p'
    SystemPrinter.Title = 'ReportPrinter Report'
    SystemPrinter.UnitsFactor = 1.000000000000000000
    Left = 166
    Top = 354
  end
  object RvRenderPreview_MenberinfoPrint: TRvRenderPreview
    DisplayName = 'RPRender'
    ZoomFactor = 100.000000000000000000
    ShadowDepth = 0
    Left = 198
    Top = 354
  end
  object RvDataSetConnection_MenberinfoPrint: TRvDataSetConnection
    RuntimeVisibility = rtDeveloper
    DataSet = ADOQuery_Menberinfo
    Left = 228
    Top = 354
  end
  object DataSource_Menberinfo: TDataSource
    DataSet = ADOQuery_Menberinfo
    Left = 33
    Top = 356
  end
  object ADOQuery_Menberinfo: TADOQuery
    Parameters = <>
    Left = 65
    Top = 356
  end
  object RvPro_RecardinfoPrint: TRvProject
    Engine = RvSystem_RecardinfoPrint
    ProjectFile = 'Project_Recard.rav'
    Left = 142
    Top = 402
  end
  object RvSystem_RecardinfoPrint: TRvSystem
    TitleSetup = 'Output Options'
    TitleStatus = 'Report Status'
    TitlePreview = 'Report Preview'
    SystemFiler.StatusFormat = 'Generating page %p'
    SystemPreview.ZoomFactor = 100.000000000000000000
    SystemPrinter.ScaleX = 100.000000000000000000
    SystemPrinter.ScaleY = 100.000000000000000000
    SystemPrinter.StatusFormat = 'Printing page %p'
    SystemPrinter.Title = 'ReportPrinter Report'
    SystemPrinter.UnitsFactor = 1.000000000000000000
    Left = 174
    Top = 402
  end
  object RvRenderPreview_RecardinfoPrint: TRvRenderPreview
    DisplayName = 'RPRender'
    ZoomFactor = 100.000000000000000000
    ShadowDepth = 0
    Left = 206
    Top = 402
  end
  object RvDataSetConnection_RecardinfoPrint: TRvDataSetConnection
    RuntimeVisibility = rtDeveloper
    DataSet = ADOQuery_RecardinfoPrint
    Left = 236
    Top = 402
  end
  object RvRenderPrinter_RecardinfoPrint: TRvRenderPrinter
    DisplayName = 'RPRender'
    Left = 110
    Top = 402
  end
  object ADOQuery_Coperationinfo: TADOQuery
    Parameters = <>
    Left = 65
    Top = 292
  end
  object DataSource_Coperationinfo: TDataSource
    DataSet = ADOQuery_Coperationinfo
    Left = 33
    Top = 292
  end
  object DataSource_RecardinfoPrint: TDataSource
    DataSet = ADOQuery_RecardinfoPrint
    Left = 41
    Top = 404
  end
  object ADOQuery_RecardinfoPrint: TADOQuery
    Parameters = <>
    Left = 73
    Top = 404
  end
  object RvRenderPrinter_Coperationinfo: TRvRenderPrinter
    DisplayName = 'RPRender'
    Left = 102
    Top = 290
  end
  object RvProject_Coperationinfo: TRvProject
    Engine = RvSystem_Coperationinfo
    ProjectFile = 'Project_Menberinfo.rav'
    Left = 134
    Top = 290
  end
  object RvSystem_Coperationinfo: TRvSystem
    TitleSetup = 'Output Options'
    TitleStatus = 'Report Status'
    TitlePreview = 'Report Preview'
    SystemFiler.StatusFormat = 'Generating page %p'
    SystemPreview.ZoomFactor = 100.000000000000000000
    SystemPrinter.ScaleX = 100.000000000000000000
    SystemPrinter.ScaleY = 100.000000000000000000
    SystemPrinter.StatusFormat = 'Printing page %p'
    SystemPrinter.Title = 'ReportPrinter Report'
    SystemPrinter.UnitsFactor = 1.000000000000000000
    Left = 166
    Top = 290
  end
  object RvRenderPreview_Coperationinfo: TRvRenderPreview
    DisplayName = 'RPRender'
    ZoomFactor = 100.000000000000000000
    ShadowDepth = 0
    Left = 198
    Top = 290
  end
  object RvDataSetConnection_Coperationinfo: TRvDataSetConnection
    RuntimeVisibility = rtDeveloper
    DataSet = ADOQuery_Coperationinfo
    Left = 228
    Top = 290
  end
  object RvNDRWriter1: TRvNDRWriter
    StatusFormat = 'Printing page %p'
    UnitsFactor = 1.000000000000000000
    Title = 'Rave Report'
    Orientation = poPortrait
    ScaleX = 100.000000000000000000
    ScaleY = 100.000000000000000000
    Left = 276
    Top = 225
  end
  object DataSource1: TDataSource
    DataSet = ADOQuery_TIsable
    Left = 33
    Top = 172
  end
  object ADOQuery_TIsable: TADOQuery
    Parameters = <>
    Left = 65
    Top = 172
  end
  object DataSource2: TDataSource
    DataSet = ADOQuery_TOperator
    Left = 33
    Top = 212
  end
  object ADOQuery_TOperator: TADOQuery
    Parameters = <>
    Left = 65
    Top = 212
  end
end
