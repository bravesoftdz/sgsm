unit RegUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, IniFiles,
  Dialogs, StdCtrls, Buttons;

type
  Tfrm_Reg = class(TForm)
    Label3: TLabel;
    Edit_Reg: TEdit;
    BitBtn_Reg: TBitBtn;
    procedure Edit_RegKeyPress(Sender: TObject; var Key: Char);
    procedure BitBtn_RegClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_Reg: Tfrm_Reg;

implementation
uses ICDataModule, ICCommunalVarUnit, ICFunctionUnit, ICmain, Frontoperate_EBincvalueUnit, ICEventTypeUnit;

{$R *.dfm}

procedure Tfrm_Reg.Edit_RegKeyPress(Sender: TObject; var Key: Char);
begin
  if not (key in ['0'..'9', 'A'..'Z', #8, #13]) then
  begin
    key := #0;
    ShowMessage('输入错误，只能输入数字和大写字母！');
  end;
end;

procedure Tfrm_Reg.BitBtn_RegClick(Sender: TObject);
var
  RegTimes, ErrTotalTimes, ErrTimes: string;
  myIni: TiniFile;

begin
  if length(Edit_Reg.Text) <> 12 then
  begin
    showmessage('数据长度不等于12');
    exit;
  end;


  if FileExists(SystemWorkGroundFile) then
  begin

    myIni := TIniFile.Create(SystemWorkGroundFile);

    RegTimes := MyIni.ReadString('PLC工作区域', 'PC回应清托盘', ''); //
    ErrTotalTimes := MyIni.ReadString('DB设置', '数据清理时间', ''); //
    ErrTimes := Copy(ErrTotalTimes, 9, 1);
    if Copy(ErrTotalTimes, 9, 1) = '4' then
    begin
      MessageBox(handle, '你已累计三次错误！因为你的恶意操作！系统已经被报废！', '错误', MB_ICONERROR + MB_OK);
      exit;
    end;
    if RegTimes <> 'D6102' then
    begin
      if (Copy(TrimRight(Edit_Reg.Text), 1, 1) = '0') or (Copy(TrimRight(Edit_Reg.Text), 2, 1) = '0') or (Copy(TrimRight(Edit_Reg.Text), 6, 1) = '0') then
      begin

        if ErrTimes = '1' then
        begin
          myIni.WriteString('DB设置', '数据清理时间', Copy(ErrTotalTimes, 1, 8) + '2'); //写入新的登陆次数

        end
        else if ErrTimes = '2' then
        begin
          myIni.WriteString('DB设置', '数据清理时间', Copy(ErrTotalTimes, 1, 8) + '3'); //写入新的登陆次数

        end
        else if ErrTimes = '3' then
        begin
          myIni.WriteString('DB设置', '数据清理时间', Copy(ErrTotalTimes, 1, 8) + '4'); //写入新的登陆次数

        end;
        MessageBox(handle, '错误！累计三次错误后，系统无法再次启动,自行负责!', '错误', MB_ICONERROR + MB_OK);
        Exit;
      end;


      if (Copy(TrimRight(Edit_Reg.Text), 1, 1) = Copy(TrimRight(Edit_Reg.Text), 2, 1)) and (Copy(TrimRight(Edit_Reg.Text), 3, 1) = Copy(TrimRight(Edit_Reg.Text), 2, 1)) and (Copy(TrimRight(Edit_Reg.Text), 4, 1) = Copy(TrimRight(Edit_Reg.Text), 2, 1)) then
      begin
        if ErrTimes = '1' then
        begin
          myIni.WriteString('DB设置', '数据清理时间', Copy(ErrTotalTimes, 1, 8) + '2'); //写入新的登陆次数

        end
        else if ErrTimes = '2' then
        begin
          myIni.WriteString('DB设置', '数据清理时间', Copy(ErrTotalTimes, 1, 8) + '3'); //写入新的登陆次数

        end
        else if ErrTimes = '3' then
        begin
          myIni.WriteString('DB设置', '数据清理时间', Copy(ErrTotalTimes, 1, 8) + '4'); //写入新的登陆次数

        end;
        MessageBox(handle, '错误！累计三次错误后，系统无法再次启动,自行负责!', '错误', MB_ICONERROR + MB_OK);
        Exit;
      end;
      if (TrimRight(Edit_Reg.Text) <> RegTimes) and (StrToInt(Copy(TrimRight(Edit_Reg.Text), 1, 1)) = 2 * StrToInt(Copy(TrimRight(Edit_Reg.Text), 4, 1))) and (StrToInt(Copy(TrimRight(Edit_Reg.Text), 2, 1)) = 3 * StrToInt(Copy(TrimRight(Edit_Reg.Text), 6, 1))) then
      begin
        myIni.WriteString('PLC工作区域', 'PC回应清托盘', TrimRight(Edit_Reg.Text)); //写入新的登陆注册次数
        SystemWorkground.PLCRequestWriteTP := 'D6004';
        myIni.WriteString('PLC工作区域', 'PLC请求写托盘', SystemWorkground.PLCRequestWriteTP); //写入新的登陆次数

      end
      else
      begin
        if StrToInt(RegTimes) < 3 then
        begin
          myIni.WriteString('PLC工作区域', 'PC回应清托盘', IntToStr(StrToInt(RegTimes) + 1)); //写入新的登陆注册次数
          SystemWorkground.PLCRequestWriteTP := 'D6004';
          myIni.WriteString('PLC工作区域', 'PLC请求写托盘', SystemWorkground.PLCRequestWriteTP); //写入新的登陆次数
        end
        else
        begin
          Edit_Reg.Text := '请注册！';
        end;
      end;
    end
    else
    begin
      if (Copy(TrimRight(Edit_Reg.Text), 1, 1) = '0') or (Copy(TrimRight(Edit_Reg.Text), 2, 1) = '0') or (Copy(TrimRight(Edit_Reg.Text), 6, 1) = '0') then
      begin

        if ErrTimes = '1' then
        begin
          myIni.WriteString('DB设置', '数据清理时间', Copy(ErrTotalTimes, 1, 8) + '2'); //写入新的登陆次数

        end
        else if ErrTimes = '2' then
        begin
          myIni.WriteString('DB设置', '数据清理时间', Copy(ErrTotalTimes, 1, 8) + '3'); //写入新的登陆次数

        end
        else if ErrTimes = '3' then
        begin
          myIni.WriteString('DB设置', '数据清理时间', Copy(ErrTotalTimes, 1, 8) + '4'); //写入新的登陆次数

        end;
        MessageBox(handle, '错误！累计三次错误后，系统无法再次启动,自行负责!', '错误', MB_ICONERROR + MB_OK);
        Exit;
      end;


      if (Copy(TrimRight(Edit_Reg.Text), 1, 1) = Copy(TrimRight(Edit_Reg.Text), 2, 1)) and (Copy(TrimRight(Edit_Reg.Text), 3, 1) = Copy(TrimRight(Edit_Reg.Text), 2, 1)) and (Copy(TrimRight(Edit_Reg.Text), 4, 1) = Copy(TrimRight(Edit_Reg.Text), 2, 1)) then
      begin
        if ErrTimes = '1' then
        begin
          myIni.WriteString('DB设置', '数据清理时间', Copy(ErrTotalTimes, 1, 8) + '2'); //写入新的登陆次数

        end
        else if ErrTimes = '2' then
        begin
          myIni.WriteString('DB设置', '数据清理时间', Copy(ErrTotalTimes, 1, 8) + '3'); //写入新的登陆次数

        end
        else if ErrTimes = '3' then
        begin
          myIni.WriteString('DB设置', '数据清理时间', Copy(ErrTotalTimes, 1, 8) + '4'); //写入新的登陆次数

        end;
        MessageBox(handle, '错误！累计三次错误后，系统无法再次启动,自行负责!', '错误', MB_ICONERROR + MB_OK);
        Exit;
      end;
      if (TrimRight(Edit_Reg.Text) <> RegTimes) and (StrToInt(Copy(TrimRight(Edit_Reg.Text), 1, 1)) = 2 * StrToInt(Copy(TrimRight(Edit_Reg.Text), 4, 1))) and (StrToInt(Copy(TrimRight(Edit_Reg.Text), 2, 1)) = 3 * StrToInt(Copy(TrimRight(Edit_Reg.Text), 6, 1))) then
      begin
        myIni.WriteString('PLC工作区域', 'PC回应清托盘', TrimRight(Edit_Reg.Text)); //写入新的登陆注册次数
        SystemWorkground.PLCRequestWriteTP := 'D6004';
        myIni.WriteString('PLC工作区域', 'PLC请求写托盘', SystemWorkground.PLCRequestWriteTP); //写入新的登陆次数
      end
    end;

    FreeAndNil(myIni);
  end;

end;



procedure Tfrm_Reg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
end;

end.
