object frm_IC_SetParameter_DataBaseInit: Tfrm_IC_SetParameter_DataBaseInit
  Left = 457
  Top = 291
  Width = 322
  Height = 326
  Caption = #20986#21378#37197#32622#21021#22987#21270
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 314
    Height = 292
    Align = alClient
    Caption = 'Panel1'
    TabOrder = 0
    object GroupBox5: TGroupBox
      Left = 1
      Top = 1
      Width = 312
      Height = 290
      Align = alClient
      Caption = #31995#32479#25968#25454#20986#21378#21021#22987#21270
      TabOrder = 0
      object Panel2: TPanel
        Left = 2
        Top = 249
        Width = 308
        Height = 39
        Align = alBottom
        BevelOuter = bvLowered
        TabOrder = 0
        object Bit_Add: TBitBtn
          Left = 8
          Top = 8
          Width = 97
          Height = 25
          Caption = #30830#23450
          TabOrder = 0
          OnClick = Bit_AddClick
        end
        object Bit_Close: TBitBtn
          Left = 208
          Top = 8
          Width = 97
          Height = 25
          Caption = #20851#38381
          TabOrder = 1
          OnClick = Bit_CloseClick
        end
      end
      object Panel3: TPanel
        Left = 2
        Top = 128
        Width = 308
        Height = 121
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 1
        object Label2: TLabel
          Left = 8
          Top = 28
          Width = 60
          Height = 13
          Caption = #23458#25143#32534#21495#65306
        end
        object Label8: TLabel
          Left = 8
          Top = 68
          Width = 60
          Height = 13
          Caption = #20986#21378#23494#30721#65306
        end
        object Comb_Customer_Name: TComboBox
          Left = 72
          Top = 20
          Width = 201
          Height = 21
          ItemHeight = 13
          TabOrder = 0
          Text = #35831#28857#20987#36873#25321
          OnClick = Comb_Customer_NameClick
        end
        object Edit_Customer_NO: TEdit
          Left = 72
          Top = 60
          Width = 201
          Height = 21
          Enabled = False
          TabOrder = 1
        end
        object Panel_Message: TPanel
          Left = 32
          Top = 88
          Width = 217
          Height = 25
          BevelOuter = bvNone
          TabOrder = 2
        end
        object Edit1: TEdit
          Left = 16
          Top = 32
          Width = 33
          Height = 21
          TabOrder = 3
          Text = 'Edit1'
        end
      end
      object Panel4: TPanel
        Left = 2
        Top = 15
        Width = 308
        Height = 113
        Align = alClient
        BevelOuter = bvNone
        Color = clCaptionText
        TabOrder = 2
        object Label1: TLabel
          Left = 8
          Top = 79
          Width = 214
          Height = 16
          Caption = #35831#23433#35013#36830#25509#21152#23494#21345#22312'COM4                       '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label4: TLabel
          Left = 8
          Top = 46
          Width = 300
          Height = 16
          Caption = #21253#25324'   '#21024#38500#27979#35797#25968#25454'   '#21644'  '#37325#26032#37197#32622#25991#26723'!                               '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label5: TLabel
          Left = 7
          Top = 15
          Width = 255
          Height = 16
          Caption = #27880#24847#65306#24744#23558#36827#19981#21487#24674#22797#25805#20316#12290#12290#12290#12290#12290#12290#12290'         '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
      end
    end
  end
  object ADOQuery_newCustomer: TADOQuery
    Parameters = <>
    Left = 241
    Top = 220
  end
  object DataSource_Newmenber: TDataSource
    DataSet = ADOQuery_newCustomer
    Left = 273
    Top = 220
  end
  object Comm_Check: TComm
    CommName = 'COM4'
    BaudRate = 115200
    ParityCheck = False
    Outx_CtsFlow = False
    Outx_DsrFlow = False
    DtrControl = DtrEnable
    DsrSensitivity = False
    TxContinueOnXoff = False
    Outx_XonXoffFlow = False
    Inx_XonXoffFlow = False
    ReplaceWhenParityError = False
    IgnoreNullChar = False
    RtsControl = RtsDisable
    XonLimit = 500
    XoffLimit = 500
    ByteSize = _8
    Parity = None
    StopBits = _1
    XonChar = #17
    XoffChar = #19
    ReplacedChar = #0
    ReadIntervalTimeout = 100
    ReadTotalTimeoutMultiplier = 0
    ReadTotalTimeoutConstant = 0
    WriteTotalTimeoutMultiplier = 0
    WriteTotalTimeoutConstant = 0
    OnReceiveData = Comm_CheckReceiveData
    Left = 265
    Top = 41
  end
  object Timer_HAND: TTimer
    Enabled = False
    Interval = 100
    OnTimer = Timer_HANDTimer
    Left = 128
    Top = 16
  end
  object Timer_USERPASSWORD: TTimer
    Enabled = False
    Interval = 100
    OnTimer = Timer_USERPASSWORDTimer
    Left = 184
    Top = 16
  end
  object Timer_3FPASSWORD: TTimer
    Enabled = False
    Interval = 100
    OnTimer = Timer_3FPASSWORDTimer
    Left = 232
    Top = 16
  end
  object Timer_3FLOADDATE: TTimer
    Enabled = False
    Interval = 100
    OnTimer = Timer_3FLOADDATETimer
    Left = 272
    Top = 16
  end
end
