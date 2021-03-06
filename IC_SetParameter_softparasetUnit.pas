unit IC_SetParameter_softparasetUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, Grids, DBGrids, ComCtrls, Mask,
  Spin, FileCtrl, ShellCtrls, Printers, RpDevice;

type
  Tfrm_IC_SetParameter_softparaset = class(TForm)
    pgcMenberfor: TPageControl;
    tbsConfig: TTabSheet;
    Panel3: TPanel;
    tbsLowLevel: TTabSheet;
    Panel1: TPanel;
    TabSheet1: TTabSheet;
    Panel5: TPanel;
    Panel2: TPanel;
    CheckBox1: TCheckBox;
    Label3: TLabel;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    Label8: TLabel;
    Edit1: TEdit;
    BitBtn1: TBitBtn;
    CheckBox4: TCheckBox;
    Label13: TLabel;
    MaskEdit1: TMaskEdit;
    CheckBox5: TCheckBox;
    MaskEdit2: TMaskEdit;
    Label14: TLabel;
    MaskEdit3: TMaskEdit;
    CheckBox6: TCheckBox;
    MaskEdit4: TMaskEdit;
    CheckBox7: TCheckBox;
    Label15: TLabel;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    CheckBox10: TCheckBox;
    ComboBox7: TComboBox;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    SpinEdit3: TSpinEdit;
    SpinEdit4: TSpinEdit;
    SpinEdit5: TSpinEdit;
    BitBtn17: TBitBtn;
    BitBtn20: TBitBtn;
    Panel4: TPanel;
    Label1: TLabel;
    Panel7: TPanel;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    GroupBox1: TGroupBox;
    ComboBox1: TComboBox;
    Edit2: TEdit;
    Label6: TLabel;
    Edit3: TEdit;
    Label16: TLabel;
    Edit4: TEdit;
    Label17: TLabel;
    Edit5: TEdit;
    rgSexOrg: TRadioGroup;
    Panel6: TPanel;
    GroupBox2: TGroupBox;
    RadioGroup1: TRadioGroup;
    Panel8: TPanel;
    BitBtn2: TBitBtn;
    BitBtn5: TBitBtn;
    ListBox1: TListBox;
    Edit6: TEdit;
    BitBtn6: TBitBtn;
    ComboBox2: TComboBox;
    BitBtn7: TBitBtn;
    procedure BitBtn6Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure BitBtn20Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
  private
    { Private declarations }
    procedure SetPrinter(PrinterIndex: Integer; Force: boolean = False); overload;
  public
    { Public declarations }

  end;

var
  frm_IC_SetParameter_softparaset: Tfrm_IC_SetParameter_softparaset;

implementation

{$R *.dfm}

procedure Tfrm_IC_SetParameter_softparaset.BitBtn6Click(Sender: TObject);
var
  AppName: array[0..256] of Char; //节名称字符串
  KeyName: array[0..256] of Char; //键名称字符串
  DefaultString: array[0..256] of Char; //在键名没找到时默认返回的字串
  ReturnedString: array[0..256] of Char; //在键名找到时返回的字串
begin
  AppName := 'Windows'; //节名称
  KeyName := 'device'; //键名称
  GetProfileString(AppName, KeyName, DefaultString, ReturnedString, Sizeof(ReturnedString));
  ComboBox2.Text := ReturnedString; //显示结果
  ComboBox2.Items := Printer.Printers;
end;

procedure Tfrm_IC_SetParameter_softparaset.FormCreate(Sender: TObject);
begin
  { tell printer to go to the default by setting
    the PrinterIndex value to -1 }
  Printer.PrinterIndex := -1;

  { make our combobox non-editable }
  ComboBox1.Style := csDropDownList;

  { set our combobox items to the printer printers }
  ComboBox1.Items := Printer.Printers;

  { set combobox to view the default printer
    according to printer printerindex as set above }
  ComboBox1.ItemIndex := Printer.PrinterIndex;
end;

procedure Tfrm_IC_SetParameter_softparaset.BitBtn7Click(Sender: TObject);
var
  MyHandle: THandle;
  MyDevice,
    MyDriver,
    MyPort: array[0..255] of Char;
begin
{ set printer to the selected according to the
    combobox itemendex }
  Printer.PrinterIndex := ComboBox1.ItemIndex;

  { get our printer properties }
  Printer.GetPrinter(MyDevice,
    MyDriver,
    MyPort,
    MyHandle);

  { create string of exactly what WriteProfileString()
    wants to see by concat each of the above received
    character arrays }
  StrCat(MyDevice, ',');
  StrCat(MyDevice, MyDriver);
  StrCat(MyDevice, ',');
  StrCat(MyDevice, MyPort);

  { copy our new default printer into our windows ini file
    to the [WINDOWS] section under DEVICE= }
  WriteProfileString('WINDOWS',
    'DEVICE',
    MyDevice);


  { tell all applications that the windows ini file has
    changed, this will cause them all to recheck default
    printer }
  SendMessage(HWND_BROADCAST,
    WM_WININICHANGE,
    0,
    LongInt(pChar('windows')));


  SetPrinter(ComboBox1.ItemIndex, true);

end;

//专门针对报表打印的打印机选择

procedure Tfrm_IC_SetParameter_softparaset.SetPrinter(PrinterIndex: Integer; Force: boolean);
begin
  if RPDev <> nil then
  begin
    try
      RPDev.DeviceIndex := PrinterIndex;
      RPDev.ResetHandle(Force);
    except
    end;
  end;
end;

procedure Tfrm_IC_SetParameter_softparaset.BitBtn20Click(Sender: TObject);
begin
  Close;
end;

procedure Tfrm_IC_SetParameter_softparaset.BitBtn4Click(Sender: TObject);
begin
  Close;
end;

procedure Tfrm_IC_SetParameter_softparaset.BitBtn5Click(Sender: TObject);
begin
  Close;
end;

end.
