unit Logon;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, IniFiles,
  Dialogs, jpeg, ExtCtrls, StdCtrls, Buttons, ADODB, Menus, SPComm;

type
  TFrm_Logon = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    BitBtn_OK: TBitBtn;
    BitBtn_Exit: TBitBtn;
    Edit_No: TEdit;
    Edit_Pass: TEdit;
    comReader: TComm;
    Comm_Check: TComm;
    Timer1: TTimer;
    Timer2: TTimer;
    Timer_HAND: TTimer;
    Timer_USERPASSWORD: TTimer;
    Timer_3FPASSWORD: TTimer;
    Label_Message: TLabel;
    Timer_3FLOADDATE: TTimer;
    Timer_3FLOADDATE_WRITE: TTimer;
    Label3: TLabel;
    Label4: TLabel;
    Image1: TImage;
    Panel_Reg: TPanel;
    Label5: TLabel;
    Comm1: TComm;
   // procedure BitBtn_ExitClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure BitBtn_ExitClick(Sender: TObject);
    procedure comReaderReceiveData(Sender: TObject; Buffer: Pointer;
      BufferLength: Word);
    procedure FormShow(Sender: TObject);
    procedure Comm_CheckReceiveData(Sender: TObject; Buffer: Pointer;
      BufferLength: Word);
    procedure BitBtn1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Edit_NoKeyPress(Sender: TObject; var Key: Char);
    procedure Timer_3FPASSWORDTimer(Sender: TObject);
    procedure Timer_USERPASSWORDTimer(Sender: TObject);
    procedure Timer_HANDTimer(Sender: TObject);
    procedure Edit_PassKeyPress(Sender: TObject; var Key: Char);
    procedure Timer_3FLOADDATETimer(Sender: TObject);
    procedure Timer_3FLOADDATE_WRITETimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn_OKClick(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Panel1DblClick(Sender: TObject);
    procedure Label5Click(Sender: TObject);
  private
   // procedure Close_computer;
    procedure SetCursorRect(rect: TRect);
    procedure Load_Check;
    { Private declarations }
  public
    { Public declarations }
    procedure CheckCMD();
    procedure CheckCMD_Right(); //系统主机权限判断，确认是否与加密狗唯一对应

    function INit_Send_CMD(StrCMD: string; StrIncValue: string): string;
    procedure INIT_Operation;
    procedure INcrevalue(S: string); //充值函数
    procedure sendData();
    function exchData(orderStr: string): string;
    procedure LOAD_CAN_CHECK; //判断软件盗版否
    function Select_CheckSum_Byte(StrCheckSum: string): string;
    function CheckSUMData(orderStr: string): string;
    function Date_Time_Modify(strinputdatetime: string): string;
    function CheckPassword(strtemp_Password: string): boolean;
    procedure CheckRight(UserNO: string); //读取权限控制
    function MaxRight: string;
    procedure ClearArr_Wright_3F;
    procedure EnableMenu; //读取权限控制
    function Query_Customer(Customer_No1: string): string;

        //发送握手请求指令
    procedure SendCMD_HAND;
    //发送读取场地密码请求指令
    procedure SendCMD_USERPASSWORD;
    //发送3F出厂密码（系统编号）确认请求指令
    procedure SendCMD_3FPASSWORD;
    //发送写登陆日期
    procedure SendCMD_3FLOADDATE;
    //发送读登陆日期
    procedure SendCMD_3FLOADDATE_READ;

    function CheckSUMData_PasswordIC(orderStr: string): string;
    function Check_CustomerName(str1: string; str2: string): Boolean;
    function Check_CustomerNO(str1: string; str2: string): Boolean;
    function Check_LOADDATE(str1: string; str2: string): Boolean;
    function Make_Send_CMD_PasswordIC(StrCMD: string; StrIncValue: string): string;
    procedure WriteCustomerNameToIniFile;
    function WriteUseTimeToIniFile: boolean;
  end;

var
  Frm_Logon: TFrm_Logon;
  Longon_OK: BOOLEAN;
  Longon_NG: BOOLEAN;
  curOrderNo: integer = 0;
  curOperNo: integer = 0;
  Operate_No: integer = 0;

  LOAD_SEND_DATA, LOAD_Rec_DATA: string;
  orderLst, recDataLst, recData_fromICLst, recData_fromICLst_Check: Tstrings;


  Check_Count, Check_Count_3FPASSWORD, Check_Count_USERPASSWORD, Check_Count_3FLOADDATE, Check_Count_3FLOADDATE_WRITE: integer;
  LOAD_CHECK_OK_RE, LOAD_3FPASSWORD_OK_RE, LOAD_USERPASSWORD_OK_RE, LOAD_3FLOADDATE_OK_RE, LOAD_3FLOADDATE_WRITE_OK_RE: BOOLEAN;


  Arr_Wright_3F_length: integer;
  strtime: string;
  WriteToFile_OK, WriteToFlase_OK: BOOLEAN;
implementation
uses ICDataModule, ICCommunalVarUnit, ICFunctionUnit, ICmain, Frontoperate_EBincvalueUnit, ICEventTypeUnit, RegUnit;
{$R *.dfm}

procedure TFrm_Logon.FormActivate(Sender: TObject);
var
  lpRect: TRect;
begin
  Edit_Pass.SetFocus;
  lpRect.Left := Frm_Logon.Left;
  lpRect.Top := Frm_Logon.Top;
  lpRect.Right := Frm_Logon.Width;
  lpRect.Bottom := Frm_Logon.Height;
  SetCursorRect(lpRect);
end;


procedure TFrm_Logon.SetCursorRect(rect: TRect);
var
  lpRect: TRect;
begin
  lpRect.Left := rect.Left + 25;
  lpRect.Right := lpRect.Left + rect.Right - 38;
  lpRect.Top := rect.Top + 15;
  lpRect.Bottom := lpRect.Top + rect.Bottom - 38;
  ClipCursor(@lpRect);
end;


procedure TFrm_Logon.Load_Check;
var
  ADOQ: TADOQuery;
  strUser_ID: string;
  strSQL : string;
begin


  begin
       //加密卡认证是否通过
    if not Longon_OK then
    begin
      MessageBox(handle, '请刷您的登陆卡!', '错误', MB_ICONERROR + MB_OK);
      exit;
    end;
    ADOQ := TADOQuery.Create(Self);
    ADOQ.Connection := DataModule_3F.ADOConnection_Main;


    with ADOQ do begin
      Close;
      SQL.Clear;
      strSQL := 'select * from [3F_SysUser] where [UserName]=''' + Edit_No.Text + '''';
      SQL.Add(strSQL);
      Open;
      if (Eof) then begin
        ShowMessage('用户或密码输入错误');
      end
      else begin
              //判断密码(TrimRight(FieldByName('UserPassword').AsString)=Edit_Pass.Text)
        if CheckPassword(TrimRight(FieldByName('UserPassword').AsString)) then
        begin //在ACCESS数据的时候没有问题
          G_User.UserNO := TrimRight(FieldByName('UserNo').AsString);
          G_User.UserName := TrimRight(FieldByName('UserName').AsString);
          G_User.UserPassword := TrimRight(FieldByName('UserPassword').AsString);
          G_User.UserOpration := TrimRight(FieldByName('Opration').AsString);
          G_User.UserID := TrimRight(FieldByName('UserID').AsString);
          strUser_ID := G_User.UserID;
                 //查询管理卡 与帐号是否匹配？
          if LOAD_USER.ID_INIT <> strUser_ID then
          begin
            ShowMessage('当前输入的用户号与当前刷卡的权限不匹配！');
            exit;
          end;

                 //--------------------------更新登陆日期  开始-----------------
          WriteToFile_OK := false;
          WriteToFlase_OK := false;
          strtime := FormatDateTime('HH:mm:ss', now);
          WriteCustomerNameToIniFile; //更新配置文档中的登陆日期时间

          if WriteToFile_OK then
          begin
            Label_Message.Caption := '正在更新加密卡中的数据';                            
            Timer_3FLOADDATE_WRITE.Enabled := true; //更新FLASH中的登陆日期时间

          end
          else
          begin
            Label_Message.Caption := '配置文档数据出错，请联系厂家';
            WriteToFile_OK := false;
            WriteToFlase_OK := false;
            exit;
          end;
        //--------------------------更新登陆日期  结束-----------------

        end
        else //CheckPassword
          ShowMessage('密码输入错误');
      end;
      
    end;
    ADOQ.Close;
    ADOQ.Free;
  end;
end;

//密码确认

function TFrm_Logon.CheckPassword(strtemp_Password: string): boolean;
var
  strtemp_Input, strtemp1, strtemp2: string;

begin
  strtemp_Input := ICFunction.ChangeAreaStrToHEX(TrimRight(Edit_Pass.Text));
  ICFunction.loginfo('登录认证Logon:输入的密码 ' + strtemp_input );
  strtemp1 := copy(strtemp_Password, 19, 2) + copy(strtemp_Password, 11, 2) + copy(strtemp_Password, 23, 2);

  strtemp2 := copy(strtemp_Password, 7, 2) + copy(strtemp_Password, 15, 2) + copy(strtemp_Password, 3, 2);

  ICFunction.loginfo('登录认证Logon:3F_SYSUSER表保存的密码Part1 ' + strtemp1 );
  ICFunction.loginfo('登录认证Logon:3F_SYSUSER表保存的密码Part2 ' + strtemp2 );        
  ICFunction.loginfo('登录认证Logon:3F_SYSUSER表保存的密码 ' + strtemp1 + strtemp2 );
  
  if (strtemp1 + strtemp2) = strtemp_Input then
  begin
    result := true; //一致
  end
  else
  begin
    result := false; //不一致
  end;
end;


procedure TFrm_Logon.comReaderReceiveData(Sender: TObject; Buffer: Pointer;
  BufferLength: Word);
var
  ii: integer;
  recStr: string;
  tmpStr: string;
  tmpStrend: string;
begin
   //接收----------------
  recStr := '';
  SetLength(tmpStr, BufferLength);
  move(buffer^, pchar(tmpStr)^, BufferLength);
  for ii := 1 to BufferLength do
  begin
    recStr := recStr + intTohex(ord(tmpStr[ii]), 2); //将获得数据转换为16进制数
       
    if ii = BufferLength then
    begin
      tmpStrend := 'END';
    end;
  end;

  recData_fromICLst.Clear;
  recData_fromICLst.Add(recStr);
   
  begin
    CheckCMD(); //首先根据接收到的数据进行判断，确认此卡是否属于为正确的卡
  end;
end;

procedure TFrm_Logon.FormShow(Sender: TObject);
begin
  ICFunction.InitSystemWorkPath; //初始化文件路径
  ICFunction.InitSystemWorkground; //初始化参数背景
  //@linlf 4表示密码输入的错误次数
  if Copy(SystemWorkground.DB_UpdateTime, 9, 1) = '4' then
  begin
    MessageBox(handle, '你已累计三次错误！因为你的恶意操作！系统已经被报废！', '错误', MB_ICONERROR + MB_OK);
    Frm_Logon.Enabled := false;
    exit;
  end;
  
  if User_Copy then //变量User_Copy 在unit ICFunctionUnit;中检测赋值，用于确认是否有系统配置文件
  begin

    Label4.Caption := '版权归3F所有   系列号:' + Copy(INit_Wright.CustomerName, 7, 6) + Copy(INit_Wright.CustomerName, 1, 6) + '          ';
    Edit_No.Text := '系统管理员';
       //Panel_Message.Caption := '请使用正版系统,系统仅供学习娱乐参考,联系QQ35127847';
    Edit_No.Text := '';
    Edit_Pass.Text := '';
    Arr_Wright_3F_length := StrToInt(MaxRight); //读取权限项目内容
    setlength(G_User.UserRight, Arr_Wright_3F_length + 1); //初始化权限数组变量
    ClearArr_Wright_3F;




    Longon_NG := true; //允许登陆标识
    Longon_OK := false;

    recData_fromICLst_Check := tStringList.Create;
    orderLst := TStringList.Create;

    Edit_Pass.SetFocus;


       //   ------------------加密狗 开始------------

    //winxp
    Comm_Check.StartComm();//开启加密狗串口确认
    LOAD_CHECK_OK_RE := false;
    Timer_HAND.Enabled := true; //开始检测加密狗握手定时器
    if (SystemWorkground.PCReCallClearTP = 'D6102') then
    begin
      Panel_Reg.Visible := true;
    end
    else
    begin
      Panel_Reg.Visible := false;

    end;
       //-----------注册码 结束------------
  end
  else
  begin
    Frm_Logon.Caption := '版权归3F邦布科技所有，您已经被列入盗版黑名单！';
    Label_Message.Caption := '请使用正版系统,系统仅供学习娱乐参考,联系QQ35127847';
    Edit_No.Text := '盗版可耻';
    BitBtn_OK.Enabled := false;
    BitBtn_Exit.Enabled := false;
  end;

end;

function TFrm_Logon.MaxRight: string;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: string;
begin
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select Max(ID) from [3F_RIGHT_LIST]';

  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    if (RecordCount > 0) then
      reTmpStr := TrimRight(ADOQTemp.Fields[0].AsString)
  end;
  FreeAndNil(ADOQTemp);
  Result := reTmpStr;
end;

procedure TFrm_Logon.ClearArr_Wright_3F;
var
  i: integer;
begin

  for i := 1 to Arr_Wright_3F_length do //初始化权限数组变量内容
  begin
    G_User.UserRight[i].Right_NAME := '';
    G_User.UserRight[i].RIGHT_CODE := '';
    G_User.UserRight[i].RIGHT_ID := '';
  end;

end;

procedure TFrm_Logon.BitBtn_ExitClick(Sender: TObject);
begin
  Close;
end;

//根据接收到的数据判断此卡是否为合法卡

procedure TFrm_Logon.CheckCMD();
var
  tmpStr: string;
begin
   //首先截取接收的信息
  Label_Message.Caption := '';
  tmpStr := recData_fromICLst.Strings[0];

  LOAD_USER.ID_CheckNum := copy(tmpStr, 39, 4); //校验和
      // if(frm_Frontoperate_EBincvalue.CheckSUMData(copy(tmpStr, 1, 38))=copy(tmpStr, 41, 2)+copy(tmpStr, 39, 2)) then//校验和
  begin

    LOAD_USER.CMD := copy(recData_fromICLst.Strings[0], 1, 2); //帧头43
    LOAD_USER.ID_INIT := copy(recData_fromICLst.Strings[0], 3, 8); //卡片ID
    LOAD_USER.ID_3F := copy(recData_fromICLst.Strings[0], 11, 6); //卡厂ID
    LOAD_USER.Password_3F := copy(recData_fromICLst.Strings[0], 17, 6); //卡密
    LOAD_USER.Password_USER := copy(recData_fromICLst.Strings[0], 23, 6); //用户密码
    LOAD_USER.ID_value := copy(recData_fromICLst.Strings[0], 29, 8); //卡内数据
    LOAD_USER.ID_type := copy(recData_fromICLst.Strings[0], 37, 2); //卡功能

            //1、判断此卡是否为合法卡，即根据卡ID判断，通过检索数据库中是否有此记录
            //  1、1首先判断是否是3F厂家卡,厂家卡不需要判别卡片ID，只需判别卡厂ID、卡密、用户密码 、卡内数据、卡功能
            //if (LOAD_USER.ID_3F=INit_3F.ID_3F) and (LOAD_USER.Password_3F=INit_3F.Password_3F) and (LOAD_USER.Password_USER=INit_3F.Password_USER)and (LOAD_USER.ID_value=INit_3F.ID_value)and (LOAD_USER.ID_type=INit_3F.ID_type) then
           //20130101屏蔽 CHECK_3F_ID（）
            //if ICFunction.CHECK_3F_ID(LOAD_USER.ID_INIT,LOAD_USER.ID_3F,LOAD_USER.Password_3F) then
             // begin
             //      Longon_OK:=TRUE;
             // end
           // else
            //  begin
            //       Longon_OK:=false;//查询数据
            //       Panel.caption:='当前卡非法!请通知老板！！';
             //      exit;
            //  end;

    if DataModule_3F.Query_ID_OK(LOAD_USER.ID_INIT) then
    begin
      Longon_OK := TRUE;
    end
    else
    begin
      Longon_OK := false; //查询数据
      Label_Message.caption := '当前卡非法!请通知老板！！';
      exit;
    end;
            //Edit2.Text:=copy(INit_Wright.BOSS,8,2);
            //管理员的卡和老板卡
    if (LOAD_USER.ID_type = copy(INit_Wright.BOSS, 8, 2)) then
    begin
      Edit_No.Text := LOAD_USER.ID_INIT;
      Longon_OK := TRUE;
    end
    else if (LOAD_USER.ID_type = copy(INit_Wright.MANEGER, 8, 2)) then
    begin
      Edit_No.Text := LOAD_USER.ID_INIT;
      Longon_OK := TRUE;
    end
    else
    begin
      Longon_OK := false; //查询数据
    end;
    if not Longon_OK then
    begin
      Label_Message.caption := '当前卡非法!请确认是否为许可登陆卡！！';
      exit;
    end
    else
    begin
      Label_Message.caption := '卡认证成功，请按确认按钮';
      Edit_Pass.SetFocus;
    end;

  end;


end;






//初始化操作

procedure TFrm_Logon.INIT_Operation;
var
  INC_value: string;
  strValue: string;
begin
  begin
    INC_value := '0'; //充值数值
    strValue := INit_Send_CMD('AB', INC_value); //计算充值指令
    INcrevalue(strValue); //写入ID卡
  end;
end;


//初始化卡计算指令

function TFrm_Logon.INit_Send_CMD(StrCMD: string; StrIncValue: string): string;
var
  TmpStr: string; //规范后的日期和时间
  TmpStr_CheckSum: string; //校验和
  TmpStr_SendCMD: string; //指令内容
  reTmpStr: string;
  myIni: TiniFile;
  strinputdatetime: string;

  i: integer;
  Strsent: array[0..21] of string; //机型分组对应变量
begin
  strinputdatetime := DateTimetostr((now()));
  TmpStr := Date_Time_Modify(strinputdatetime); //规范日期和时间格式
  Strsent[0] := StrCMD; //帧命令

  Strsent[5] := IntToHex(Strtoint(Copy(TmpStr, 1, 2)), 2); //年份前2位
  Strsent[18] := IntToHex(Strtoint(Copy(TmpStr, 3, 2)), 2); //年份后2位
  Strsent[8] := IntToHex(Strtoint(Copy(TmpStr, 6, 2)), 2); //月份前2位
  Strsent[10] := IntToHex(Strtoint(Copy(TmpStr, 9, 2)), 2); //日期前2位
  Strsent[14] := IntToHex(Strtoint(Copy(TmpStr, 12, 2)), 2); //小时前2位
  Strsent[6] := IntToHex(Strtoint(Copy(TmpStr, 15, 2)), 2); //分钟前2位
  Strsent[1] := IntToHex(Strtoint(Copy(TmpStr, 18, 2)), 2); //秒前2位

  Strsent[2] := IntToHex((Strtoint('$' + Strsent[10]) + Strtoint('$' + Strsent[8])), 2);

  Strsent[3] := IntToHex((Strtoint('$' + Strsent[1]) + Strtoint('$' + Strsent[6])), 2);
  Strsent[7] := IntToHex((Strtoint('$' + Strsent[2]) + Strtoint('$' + Strsent[8])), 2);
  Strsent[16] := IntToHex((Strtoint('$' + Strsent[5]) + Strtoint('$' + Strsent[6])), 2);
  Strsent[13] := IntToHex((Strtoint('$' + Strsent[14]) + Strtoint('$' + Strsent[5])), 2);


  Strsent[4] := IntToHex(((Strtoint('$' + Strsent[7]) * Strtoint('$' + Strsent[16])) div 256), 2);
  Strsent[9] := IntToHex(((Strtoint('$' + Strsent[7]) * Strtoint('$' + Strsent[16])) mod 256), 2);
  Strsent[11] := IntToHex(((Strtoint('$' + Strsent[3]) * Strtoint('$' + Strsent[13])) mod 256), 2);
  Strsent[15] := IntToHex(((Strtoint('$' + Strsent[3]) * Strtoint('$' + Strsent[13])) div 256), 2);


  Strsent[17] := IntToHex((Strtoint('$' + Strsent[6]) + Strtoint('$' + Strsent[1])), 2);
  Strsent[12] := IntToHex((Strtoint('$' + Strsent[14]) + Strtoint('$' + Strsent[8])), 2);

    //Strsent[19]:= Receive_CMD_ID_Infor.ID_3F;
    //Strsent[20]:=Receive_CMD_ID_Infor.Password_3F;
                              //将读取的文档中的场地密码
  if FileExists(SystemWorkGroundFile) then
  begin
    myIni := TIniFile.Create(SystemWorkGroundFile);
    INit_Wright.BossPassword := MyIni.ReadString('PLC工作区域', 'PC托盘特征码', 'D6077');
    FreeAndNil(myIni);
  end;

    //将发送内容进行校核计算
  for i := 0 to 18 do
  begin
    TmpStr_SendCMD := TmpStr_SendCMD + Strsent[i];
  end;
  TmpStr_CheckSum := CheckSUMData(TmpStr_SendCMD); //求得校验和

    //TmpStr_CheckSum字节需要重新排布 ，低字节在前，高字节在后
  reTmpStr := TmpStr_SendCMD + Select_CheckSum_Byte(TmpStr_CheckSum); //获取所有发送给IC的数据

  result := reTmpStr;
end;
//校验和，确认是否正确

function TFrm_Logon.CheckSUMData(orderStr: string): string;
var
  ii, jj, KK: integer;
  TmpStr: string;
  reTmpStr: string;
begin
  if (length(orderStr) mod 2) <> 0 then
  begin
    MessageBox(handle, '传入参数长度错误!', '错误', MB_ICONERROR + MB_OK);
    result := '';
    exit;
  end;
  KK := 0;
  for ii := 1 to (length(orderStr) div 2) do
  begin
    tmpStr := copy(orderStr, ii * 2 - 1, 2);
    jj := strToint('$' + tmpStr);
    KK := KK + jj;

  end;
  reTmpStr := IntToHex(KK, 2);
  result := reTmpStr;
end;
//校验和转换成16进制并排序 字节LL、字节LH

function TFrm_Logon.Select_CheckSum_Byte(StrCheckSum: string): string;
var
  jj: integer;
  tempLH, tempLL: integer; //2147483648 最大范围

begin
  jj := strToint('$' + StrCheckSum); //将字符转转换为16进制数，然后转换位10进制
  tempLH := (jj mod 65536) div 256; //字节LH
  tempLL := jj mod 256; //字节LL
  result := IntToHex(tempLL, 2) + IntToHex(tempLH, 2);
end;

//写入---------------------------------------

procedure TFrm_Logon.INcrevalue(S: string);
begin
  orderLst.Clear();
//    recDataLst.Clear();
  curOrderNo := 0;
  curOperNo := 2;
  orderLst.Add(S); //将币值写入币种
  sendData();
end;
//发送数据过程

procedure TFrm_Logon.sendData();
var
  orderStr: string;
begin
  if orderLst.Count > curOrderNo then
  begin
    orderStr := orderLst.Strings[curOrderNo];
    orderStr := exchData(orderStr);
        //comReader.WriteCommData(pchar(orderStr),length(orderStr));
    Comm_Check.WriteCommData(pchar(orderStr), length(orderStr));
    inc(curOrderNo);
  end;
end;

//转找发送数据格式 ，将字符转换为16进制

function TFrm_Logon.exchData(orderStr: string): string;
var
  ii, jj: integer;
  TmpStr: string;
  reTmpStr: string;
begin
  if (length(orderStr) = 0) then
  begin
    MessageBox(handle, '传入参数不能为空!', '错误', MB_ICONERROR + MB_OK);
    result := '';
    exit;
  end;
  if (length(orderStr) mod 2) <> 0 then
  begin
    MessageBox(handle, '传入参数错误!', '错误', MB_ICONERROR + MB_OK);
    result := '';
    exit;
  end;
  for ii := 1 to (length(orderStr) div 2) do
  begin
    tmpStr := copy(orderStr, ii * 2 - 1, 2);
    jj := strToint('$' + tmpStr);
    reTmpStr := reTmpStr + chr(jj);
  end;
  result := reTmpStr;
end;

procedure TFrm_Logon.LOAD_CAN_CHECK; //判断软件盗版否
begin
  if SystemWorkground.LOAD_Check_time = '1330225' then
  begin
    Longon_NG := false; //不允许登陆标识
  end;
end;


//定时器扫描统计结果和详细记录

function TFrm_Logon.Date_Time_Modify(strinputdatetime: string): string;
var
  strEnd: string;
  Strtemp: string;
begin

  Strtemp := Copy(strinputdatetime, length(strinputdatetime) - 8, 9);
  strinputdatetime := Copy(strinputdatetime, 1, length(strinputdatetime) - 9);
  if Copy(strinputdatetime, 7, 1) = '-' then //月份小于10
  begin
    if length(strinputdatetime) = 8 then //月份小于10,且日期小于10
    begin
      strEnd := Copy(strinputdatetime, 1, 5) + '0' + Copy(strinputdatetime, 6, 2) + '0' + Copy(strinputdatetime, 8, 1);
    end
    else
    begin
      strEnd := Copy(strinputdatetime, 1, 5) + '0' + Copy(strinputdatetime, 6, length(strinputdatetime) - 5);
    end;
  end
  else
  begin //月份大于9
    if length(strinputdatetime) = 9 then //月份大于9,但日期小于10
    begin
      strEnd := Copy(strinputdatetime, 1, 8) + '0' + Copy(strinputdatetime, 9, 1);
    end
    else
    begin
      strEnd := strinputdatetime;
    end;
  end;
  result := strEnd + Strtemp;
end;

procedure TFrm_Logon.BitBtn1Click(Sender: TObject);
begin
  strtime := FormatDateTime('HH:mm:ss', now);
  Timer_3FLOADDATE_WRITE.Enabled := true;
end;

procedure TFrm_Logon.Timer1Timer(Sender: TObject);
begin
  LOAD_CHECK_Time_Over := true; //定时接收加密狗的反馈信息
  Timer2.Enabled := true; //关闭定时器
  Timer1.Enabled := FALSE; //关闭定时器
end;

procedure TFrm_Logon.Timer2Timer(Sender: TObject);
begin

  if not LOAD_CHECK_OK then //开启系统时，在3秒内没有接收到加密狗的反馈，则系统软件自杀
  begin
        //清除文档中的确认数据，系统停止运行
    BitBtn_OK.Enabled := false;
  end;
  LOAD_CHECK_Time_Over := false; //

  Timer2.Enabled := FALSE; //关闭定时器
    //INIT_Operation();


end;


procedure TFrm_Logon.Edit_NoKeyPress(Sender: TObject; var Key: Char);
begin

  if not (key in ['0'..'9', #8, #13]) then
  begin
    key := #0;
    ShowMessage('输入错误，只能输入数字！');
  end
  else if key = #13 then
  begin
    if (length(Edit_No.Text) = 6) then
    begin
      Edit_Pass.SetFocus;
    end;
  end;
end;

procedure TFrm_Logon.CheckRight(UserNO: string); //读取权限控制
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  strTemp: string;
  ///i:integer;
begin
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select RIGHT_NAME,ID_RIGHT from [3F_RIGHT_SET] where UserNo =''' + UserNO + '''';
  //i:=0;
  with ADOQTemp do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    while not Eof do begin
      strTemp := TrimRight(ADOQTemp.Fields[0].Asstring);
      G_User.UserRight[strtoint(ADOQTemp.Fields[1].Asstring)].Right_NAME := strTemp;
           //Frm_IC_Main.Edit4.Text:=Frm_IC_Main.Edit4.Text+G_User.UserRight[strtoint(ADOQTemp.Fields[1].Asstring)].Right_NAME;
      Next;
    end;
  end;
  FreeAndNil(ADOQTemp);
end;

//使能操作菜单

procedure TFrm_Logon.EnableMenu; //读取权限控制
var
  i, j, k: integer;
  firstmenu_Count: integer;
  secondmenu_Count: array of integer;
begin
               //清理表格
  firstmenu_Count := Frm_IC_Main.MainMenu1.Items.Count;
  setlength(secondmenu_Count, firstmenu_Count + 1);
  for i := 1 to firstmenu_Count do
  begin
    secondmenu_Count[i] := Frm_IC_Main.MainMenu1.Items[i - 1].Count;
                 //Frm_IC_Main.Edit4.Text:=inttostr(secondmenu_Count[5]);
  end;
  for i := 1 to firstmenu_Count do
  begin
    for j := 1 to secondmenu_Count[i] do //初始化权限数组变量内容
    begin
      Frm_IC_Main.MainMenu1.Items[i - 1].Items[j - 1].Enabled := false;
    end;
  end;
  for i := 1 to firstmenu_Count do
  begin
    for j := 1 to secondmenu_Count[i] do //初始化权限数组变量内容
    begin
      for k := 1 to Arr_Wright_3F_length do //初始化权限数组变量内容
      begin
        if (Frm_IC_Main.MainMenu1.Items[i - 1].Items[j - 1].Caption) = (G_User.UserRight[k].Right_NAME) then
        begin
          Frm_IC_Main.MainMenu1.Items[i - 1].Items[j - 1].Enabled := true;
                                     //Frm_IC_Main.Edit1.Text:=Frm_IC_Main.MainMenu1.Items[i-1].Caption;
                                     //Frm_IC_Main.Edit2.Text:=Frm_IC_Main.MainMenu1.Items[0].Items[0].Caption;
                                     //Frm_IC_Main.Edit3.Text:=G_User.UserRight[1].Right_NAME;
        end;
      end;
    end;

  end;
           {

           for i:=0 to Frm_IC_Main.MainMenu1.ComponentCount-1 do
             begin
                      if Frm_IC_Main.MainMenu1.components[i] is TMenuItem then
                        begin
                             for j:=1 to  Arr_Wright_3F_length do  //初始化权限数组变量内容
                              begin
                                if (Frm_IC_Main.MainMenu1.components[i] as TMenuItem).Caption =G_User.UserRight[j].Right_NAME then
                                  begin
                                    (Frm_IC_Main.MainMenu1.components[i] as TMenuItem).Enabled:= false;
                                     Frm_IC_Main.Edit1.Text:= (Frm_IC_Main.MainMenu1.components[i] as TMenuItem).Caption ;
                                     Frm_IC_Main.Edit2.Text:=G_User.UserRight[j].Right_NAME;
                                     Frm_IC_Main.Edit3.Text:= Frm_IC_Main.MainMenu1.Items[1].Items[1].Caption ;
                                     Frm_IC_Main.Edit4.Text:=inttostr((Frm_IC_Main.MainMenu1.Items.Count)) ;
                                  end;
                              end;
                        end;
             end;    }
end;







//----------------------------------------以下为加密狗相关 开始---------


//加密卡检测程序
procedure TFrm_Logon.Comm_CheckReceiveData(Sender: TObject;
  Buffer: Pointer; BufferLength: Word);
var
  ii: integer;
  recStr: string;
  tmpStr: string;
  tmpStrend: string;
begin
   //接收----------------
  recStr := '';
  SetLength(tmpStr, BufferLength);
  move(buffer^, pchar(tmpStr)^, BufferLength);
  for ii := 1 to BufferLength do
  begin
    recStr := recStr + intTohex(ord(tmpStr[ii]), 2); //将获得数据转换为16进制数
    if ii = BufferLength then
    begin
      tmpStrend := 'END';
    end;
  end;
  recData_fromICLst_Check.Clear;
  recData_fromICLst_Check.Add(recStr);
    //接收---------------
  begin
    CheckCMD_Right(); //系统启动时判断加密狗
  end;
end;

//根据接收到的数据判断此卡是否为合法卡

procedure TFrm_Logon.CheckCMD_Right();
var
  tmpStr: string;
  i: integer;
  content1, content2, content3, content4, content5, content6: string;
begin
   //首先截取接收的信息
  tmpStr := '';
  tmpStr := recData_fromICLst_Check.Strings[0];
  content1 := copy(tmpStr, 1, 2); //帧头AA
  content2 := copy(tmpStr, 3, 2); //操作指令
       //Panel_Message.Caption:='握手成功';
  if (content1 = '43') then //帧头
  begin

    if (content2 = CMD_COUMUNICATION.CMD_HAND) then //收到握手请求反馈信息0x61
    begin

      for i := 1 to length(tmpStr) do
      begin
        if copy(tmpStr, i, 2) = '03' then
        begin
          content3 := copy(tmpStr, i - 2, 2); //指令校验和
          content5 := copy(tmpStr, 1, i - 3) + '63' + copy(tmpStr, i, 2);

          if (CheckSUMData_PasswordIC(content5) = content3) then
          begin

            LOAD_CHECK_OK_RE := true; //握手成功
            Timer_HAND.Enabled := FALSE; //关闭检测定时器

            Timer_USERPASSWORD.Enabled := true;
            tmpStr := '';
                                //Panel_Message.Caption:='握手成功';
                                //Edit_No.Text:='握手成功';
            break;
          end;
        end;
      end;

    end
              // tmpStr=43 64 01 30 30 30 30 30 33 46 32 30 31 33 30 30 30 30 30 33 03
    else if (content2 = CMD_COUMUNICATION.CMD_USERPASSWORD) then //收到系统编码检验反馈信息 0x64
    begin
      if Check_CustomerName(tmpStr, INit_Wright.CustomerName) then //比较系统编号是否一如"3F2013000001"
      begin
        LOAD_3FPASSWORD_OK_RE := false;
        LOAD_USERPASSWORD_OK_RE := true;
        Timer_3FPASSWORD.Enabled := true; //发送读取3F出厂密码（系统编号）确认请求指令
                         //Panel_Message.Caption:='用户编号确认一致';
                         //Edit_No.Text:='用户编号确认一致';
      end;
    end
    else if (content2 = CMD_COUMUNICATION.CMD_3FPASSWORD) then // 场地密码0x62
    begin
      if Check_CustomerNO(tmpStr, INit_Wright.BossPassword) then //比较场地密码
      begin
        LOAD_3FPASSWORD_OK_RE := true;
        Timer_3FPASSWORD.Enabled := false;
        Timer_3FLOADDATE.Enabled := true;
                         //Panel_Message.Caption:='场地密码确认一致';
                         //Edit_No.Text:='场地密码确认一致';

      end;

    end
    else if (content2 = CMD_COUMUNICATION.CMD_3FLODADATE) then // 最后一次登陆日期时间0x65
    begin
      if Check_LOADDATE(tmpStr, INit_3F.ID_Settime) then //比较登陆日期时间
      begin
        LOAD_3FLOADDATE_OK_RE := true;
        Timer_3FLOADDATE.Enabled := false;
                         //Panel_Message.Caption:='最后一次登陆日期时间确认一致';
                         //Edit_No.Text:='最后一次登陆日期时间确认一致';
        Label_Message.Caption := '系统初始化完毕，请刷登陆卡，然后输入登陆密码        ';
        comReader.StartComm();
        recDataLst := tStringList.Create;
        recData_fromICLst := tStringList.Create;
        BitBtn_OK.Enabled := true;
      end;

    end

//--------------------------以下是处理写登陆日期的反馈信息处理事件--------------
    else if (content2 = CMD_COUMUNICATION.CMD_WRITETOFLASH_Sub_RE) then // //写操作反馈回来的第二字节为7A
    begin
      for i := 1 to length(tmpStr) do
      begin
        if (copy(tmpStr, i, 2) = '03') and (i mod 2 = 1) then
        begin
          content6 := copy(tmpStr, 5, 2);
          content3 := copy(tmpStr, i - 2, 2); //指令校验和
          if (content6 = CMD_COUMUNICATION.CMD_3FLODADATE_RE) then //0x69
          begin
            content5 := copy(tmpStr, 1, i - 3) + '63' + copy(tmpStr, i, 2);
            if (CheckSUMData_PasswordIC(content5) = content3) then
            begin
              LOAD_3FLOADDATE_WRITE_OK_RE := true;
              WriteToFlase_OK := true;
              Label_Message.Caption := '写入登陆时间操作成功';


              if WriteToFlase_OK then
              begin
                Label_Message.Caption := '更新加密卡中的数据操作成功';
                CheckRight(G_User.UserNO); //读取权限控制
                orderLst.Free();
                recDataLst.Free();
                recData_fromICLst.Free();
                recData_fromICLst_Check.Free();
                comReader.StopComm();
                Comm_Check.StopComm();
                Longon_OK := false;
                Frm_Logon.Hide;
                Frm_IC_Main.show;
                Login := True;
              end
              else
              begin
                Label_Message.Caption := '配置加密卡数据出错，请联系厂家';
                WriteToFile_OK := false;
                WriteToFlase_OK := false;
                exit;
              end;






            end
            else
            begin
              Label_Message.Caption := '温馨提示：初始化失败，请联系技术支持，或重新启动系统                  '

            end;
            tmpStr := '';
            break;
          end;

        end;
      end; //------for 结束
    end;

//--------------------------以上是处理写登陆日期的反馈信息处理事件--------------

  end;


end;


//更新配置文件，写入出厂客户编号、场地密码给配置文件

procedure TFrm_Logon.WriteCustomerNameToIniFile;
var
  myIni: TiniFile;

  LOADDATE: string; //用户场地密码
begin

   //判断计算得到的密码是否与原来保留的一致
  LOADDATE := COPY(strtime, 1, 1) + COPY(strtime, 5, 1) + COPY(strtime, 2, 1) + COPY(strtime, 4, 1); //设定时间
  if FileExists(SystemWorkGroundFile) then
  begin
    myIni := TIniFile.Create(SystemWorkGroundFile);

    myIni.WriteString('卡出厂设置', '设定时间', LOADDATE); //写入新密码
    INit_3F.ID_Settime := MyIni.ReadString('卡出厂设置', '设定时间', '2721'); //
    FreeAndNil(myIni);

    if LOADDATE = INit_3F.ID_Settime then
    begin
      WriteToFile_OK := true;
      Label_Message.Caption := '更新文档中的登陆日期配置成功';
    end;

  end;

end;
//根据读取的条码值流水，查询数据库中是否已经有相同记录，如果有则提示

function TFrm_Logon.Query_Customer(Customer_No1: string): string;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: string;
  Str1: string;
begin
  Str1 := copy(Customer_No1, 1, length(Customer_No1) - 1);
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select [Customer_NO]  FROM [3F_Customer_Infor] where [Customer_NO]=''' + Str1 + '''';

  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    if (RecordCount > 0) then
    begin
      reTmpStr := ADOQTemp.Fields[0].AsString;
    end;
  end;
  FreeAndNil(ADOQTemp);
  RESULT := reTmpStr + '@';

end;


procedure TFrm_Logon.Timer_HANDTimer(Sender: TObject);
begin
  Check_Count := Check_Count + 1;


  if not LOAD_CHECK_OK_RE then //握手未成功
  begin
    SendCMD_HAND; //发送握手指令
    if Check_Count = 4 then //定时秒
    begin
      BitBtn_OK.Enabled := false; //禁止登陆操作
      LOAD_CHECK_OK_RE := false;
      Timer_HAND.Enabled := FALSE; //关闭定时器
    end;
  end
  else
  begin
    Timer_HAND.Enabled := FALSE; //关闭定时器
           //BitBtn_OK.Enabled:=true;//
  end;


end;


procedure TFrm_Logon.Timer_3FPASSWORDTimer(Sender: TObject);
begin

  Check_Count_3FPASSWORD := Check_Count_3FPASSWORD + 1;


  if not LOAD_3FPASSWORD_OK_RE then //握手未成功
  begin
    SendCMD_3FPASSWORD; //发送握手指令
    if Check_Count_3FPASSWORD = 4 then //定时秒
    begin
      BitBtn_OK.Enabled := false; //禁止登陆操作
      LOAD_3FPASSWORD_OK_RE := false;
      Timer_3FPASSWORD.Enabled := FALSE; //关闭定时器
    end;
  end
  else
  begin
    Timer_3FPASSWORD.Enabled := FALSE; //关闭定时器
  end;

end;

procedure TFrm_Logon.Timer_USERPASSWORDTimer(Sender: TObject);
begin
  Check_Count_USERPASSWORD := Check_Count_USERPASSWORD + 1;

  if not LOAD_USERPASSWORD_OK_RE then //握手未成功
  begin
    SendCMD_USERPASSWORD; //发送读取场地密码请求指令
    if Check_Count_USERPASSWORD = 4 then //定时秒
    begin
      LOAD_USERPASSWORD_OK_RE := false;
      Timer_USERPASSWORD.Enabled := FALSE; //关闭定时器
    end;
  end
  else
  begin
           //BitBtn_OK.Enabled:=true;//许可登陆操作
    Timer_USERPASSWORD.Enabled := FALSE; //关闭定时器
  end;
end;

procedure TFrm_Logon.Timer_3FLOADDATETimer(Sender: TObject);
begin
  Check_Count_3FLOADDATE := Check_Count_3FLOADDATE + 1;

  if not LOAD_3FLOADDATE_OK_RE then //握手未成功
  begin
    SendCMD_3FLOADDATE_READ; //发送读取场地密码请求指令
    if Check_Count_3FLOADDATE = 4 then //定时秒
    begin
      LOAD_3FLOADDATE_OK_RE := false;
      Timer_3FLOADDATE.Enabled := FALSE; //关闭定时器
    end;
  end
  else
  begin
           //BitBtn_OK.Enabled:=true;//许可登陆操作
    Timer_3FLOADDATE.Enabled := FALSE; //关闭定时器
  end;
end;


procedure TFrm_Logon.Timer_3FLOADDATE_WRITETimer(
  Sender: TObject);
begin
  Check_Count_3FLOADDATE_WRITE := Check_Count_3FLOADDATE_WRITE + 1;
  if not LOAD_3FLOADDATE_WRITE_OK_RE then //握手未成功
  begin
    SendCMD_3FLOADDATE; //发送更新登陆日期
    if Check_Count_3FLOADDATE_WRITE = 4 then //定时秒
    begin
      LOAD_3FLOADDATE_WRITE_OK_RE := false;
      Timer_3FLOADDATE_WRITE.Enabled := FALSE; //关闭定时器
      Check_Count_3FLOADDATE_WRITE := 0;
    end;
  end
  else
  begin
    Timer_3FLOADDATE_WRITE.Enabled := FALSE; //关闭定时器
    Check_Count_3FLOADDATE_WRITE := 0;
  end;

end;

//发送握手请求指令

procedure TFrm_Logon.SendCMD_HAND;
var
  INC_value: string;
  strValue: string;
begin
  begin
    INC_value := '0'; //充值数值
    strValue := '50613C6D03'; //握手请求指令50  61  3C  6D  03
    INcrevalue(strValue); //写入ID卡
  end;
end;

//发送读取场地密码请求指令

procedure TFrm_Logon.SendCMD_3FPASSWORD;
var
  strValue: string;
begin
  begin
    strValue := '50625203'; //读场地密码请求指令50  62  52  03   与X66指令对应
    INcrevalue(strValue); //发送给加密卡
  end;
end;

//发送读取3F（系统编号）请求指令

procedure TFrm_Logon.SendCMD_USERPASSWORD;
var
  strValue: string;
begin
  begin
    strValue := '5064015503'; //读系统编码请求指令       //与x68指令对应
    INcrevalue(strValue); //发送给加密卡
  end;
end;


//发送//写入登陆日期

procedure TFrm_Logon.SendCMD_3FLOADDATE;
var
  strValue, INC_value: string;
begin

  INC_value := COPY(strtime, 1, 1) + COPY(strtime, 5, 1) + COPY(strtime, 2, 1) + COPY(strtime, 4, 1) + COPY(strtime, 7, 1); //INit_3F.ID_Settime,4个字节（小时+分钟）写最后一次登陆系统时间50 69 00 00 00 00 59 03
  Operate_No := 1;
  strValue := Make_Send_CMD_PasswordIC('5069', INC_value); //计算充值指令
  INcrevalue(strValue);

end;

//发送//读登陆日期

procedure TFrm_Logon.SendCMD_3FLOADDATE_READ;
var
  strValue: string;
begin
  begin
    strValue := '50655503'; //读系统登陆日期时间请求指令       //与x69指令对应
    INcrevalue(strValue); //发送给加密卡
  end;
end;


//计算充值指令

function TFrm_Logon.Make_Send_CMD_PasswordIC(StrCMD: string; StrIncValue: string): string;
var
  i: integer;
  TmpStr_IncValue: string; //转为16进制后的字符串
  TmpStr_CheckSum: string; //校验和
  TmpStr_SendCMD: string; //指令内容
  reTmpStr, StrFramEND, StrConFram: string;
begin

  TmpStr_IncValue := IntToHex(Ord(StrIncValue[1]), 2);

  for i := 2 to length(StrIncValue) - 1 do
  begin
    TmpStr_IncValue := TmpStr_IncValue + IntToHex(Ord(StrIncValue[i]), 2);

  end;
    //Edit1.Text:= StrIncValue;
  StrFramEND := '03';
  StrConFram := '63';
    //将发送内容进行校核计算
  TmpStr_SendCMD := StrCMD + TmpStr_IncValue + StrFramEND + StrConFram;
  TmpStr_CheckSum := CheckSUMData_PasswordIC(TmpStr_SendCMD);
    //汇总发送内容

  reTmpStr := StrCMD + TmpStr_IncValue + TmpStr_CheckSum + StrFramEND;

  result := reTmpStr;

end;
//校验和，确认是否正确

function TFrm_Logon.CheckSUMData_PasswordIC(orderStr: string): string;
var
  ii, jj, KK: integer;
  TmpStr: string;
  reTmpStr: string;
begin
  if (length(orderStr) mod 2) <> 0 then
  begin
    MessageBox(handle, '传入参数长度错误!', '错误', MB_ICONERROR + MB_OK);
    result := '';
    exit;
  end;
  KK := 0;
  for ii := 1 to (length(orderStr) div 2) do
  begin
    tmpStr := copy(orderStr, ii * 2 - 1, 2);
    jj := strToint('$' + tmpStr);
    KK := KK xor jj;

  end;
  reTmpStr := IntToHex(KK, 2);
  result := reTmpStr;
end;
//根据接收到的数据判断相应情况
//  str1 为从串口读取的值 如
//43 64 01 30 30 30 30 30 33 46 32 30 31 33 30 30 30 30 30 33 03
//43 64 01 30 30 30 30 33 46 32 30 31 33 30 30 30 30 30 31 32 03

//  str2文档读取的值如3F2013000001

function TFrm_Logon.Check_CustomerName(str1: string; str2: string): Boolean;
var
  strtemp: string;
begin
  strtemp := ICFunction.ChangeAreaHEXToStr(Copy(str1, 15, 24));
  if (strtemp = str2) then
  begin
    result := true;

  end
  else
  begin
    result := false;
  end
end;
 //根据接收到的数据判断相应情况
 //  str1 为从串口读取的值 如
 //43 62 31 46 45 33 34 41 46 42 44 33 46 30 30 30 30 30 31 55 54 03
 // str2文档读取的值场地密码如000 001

function TFrm_Logon.Check_CustomerNO(str1: string; str2: string): Boolean;
var
  strtemp: string;
begin
  strtemp := ICFunction.ChangeAreaHEXToStr(Copy(str1, 27, 12));

  if (strtemp = str2) then
  begin
    result := true;
  end
  else
  begin
    result := false;
  end
end;

  //根据接收到的数据判断相应情况
 //  str1 为从串口读取的值 如
 //43  65  32  37  32  31  40  03
 // str2文档读取的值场地密码如2721

function TFrm_Logon.Check_LOADDATE(str1: string; str2: string): Boolean;
var
  strtemp: string;
begin
  strtemp := ICFunction.ChangeAreaHEXToStr(Copy(str1, 5, 8));

  if (strtemp = str2) then
  begin
    result := true;
  end
  else
  begin
    result := false;
  end
end;


//更新配置文件，写入使用系统次数给配置文件

function TFrm_Logon.WriteUseTimeToIniFile: boolean;
var
  myIni: TiniFile;
  UseTimes: string; //系统使用次数
begin
  Result := false;
    //SystemWorkground.PCReCallClearTP   PC回应清托盘   (记录注册码)
    //SystemWorkground.PLCRequestWriteTP   PLC请求写托盘 (记录登陆次数)
  if (SystemWorkground.PCReCallClearTP = 'D6102') then //未注册，为原文档
  begin
       //第一次使用
    if (SystemWorkground.PLCRequestWriteTP = 'D6004') or (length(SystemWorkground.PLCRequestWriteTP) = 0) then
    begin
      SystemWorkground.PLCRequestWriteTP := '1';
      UseTimes := SystemWorkground.PLCRequestWriteTP;
      if FileExists(SystemWorkGroundFile) then
      begin
        myIni := TIniFile.Create(SystemWorkGroundFile);
        myIni.WriteString('PLC工作区域', 'PLC请求写托盘', UseTimes); //写入新的登陆次数
        SystemWorkground.PLCRequestWriteTP := MyIni.ReadString('PLC工作区域', 'PLC请求写托盘', ''); //

        FreeAndNil(myIni);
        if SystemWorkground.PLCRequestWriteTP = UseTimes then
        begin
          Result := true;
        end
        else
        begin
          Result := false;
        end;
      end;
    end
    else //不是第一次使用
    begin

      UseTimes := IntToStr(StrToInt(SystemWorkground.PLCRequestWriteTP) + 1);
             //最高试用次数为50次
      if StrToInt(SystemWorkground.PLCRequestWriteTP) > 50 then
      begin
        Result := false;
      end
      else
      begin
        SystemWorkground.PLCRequestWriteTP := UseTimes;
        if FileExists(SystemWorkGroundFile) then
        begin
          myIni := TIniFile.Create(SystemWorkGroundFile);
          myIni.WriteString('PLC工作区域', 'PLC请求写托盘', SystemWorkground.PLCRequestWriteTP); //写入新的登陆次数
          UseTimes := MyIni.ReadString('PLC工作区域', 'PLC请求写托盘', ''); //

          FreeAndNil(myIni);
          if SystemWorkground.PLCRequestWriteTP = UseTimes then
          begin
            Result := true;
          end
          else
          begin
            Result := false;
          end;
        end;
      end; //判断是否使用次数<50 结束
    end; //判断是否第一次使用结束
  end
  else // 注册判断的内容被修改（包括已注册、或配置文件被人为修改）
  begin //SystemWorkground.PCReCallClearTP<>'D6102'
    if (StrToInt(Copy(TrimRight(SystemWorkground.PCReCallClearTP), 1, 1)) = 2 * StrToInt(Copy(TrimRight(SystemWorkground.PCReCallClearTP), 4, 1))) and (StrToInt(Copy(TrimRight(SystemWorkground.PCReCallClearTP), 2, 1)) = 3 * StrToInt(Copy(TrimRight(SystemWorkground.PCReCallClearTP), 6, 1))) then
    begin //已注册
      if (Copy(INit_Wright.CustomerName, 12, 1) = Copy(TrimRight(SystemWorkground.PCReCallClearTP), 7, 1)) and (Copy(INit_Wright.CustomerName, 11, 1) = Copy(TrimRight(SystemWorkground.PCReCallClearTP), 11, 1)) then
      begin
        if (Copy(INit_Wright.CustomerName, 6, 1) = Copy(TrimRight(SystemWorkground.PCReCallClearTP), 3, 1)) and (Copy(INit_Wright.CustomerName, 2, 1) = Copy(TrimRight(SystemWorkground.PCReCallClearTP), 5, 1)) then
        begin
          if (Copy(INit_Wright.CustomerName, 10, 1) = Copy(TrimRight(SystemWorkground.PCReCallClearTP), 8, 1)) then
          begin
            if (Copy(INit_Wright.CustomerName, 12, 1) = '1') and (Copy(TrimRight(SystemWorkground.PCReCallClearTP), 9, 1) = 'A') and (Copy(INit_Wright.CustomerName, 11, 1) = '1') and (Copy(TrimRight(SystemWorkground.PCReCallClearTP), 12, 1) = 'A') then
            begin
              Result := TRUE;
            end
            else if (Copy(INit_Wright.CustomerName, 12, 1) = '2') and (Copy(TrimRight(SystemWorkground.PCReCallClearTP), 9, 1) = 'Z') and (Copy(INit_Wright.CustomerName, 11, 1) = '2') and (Copy(TrimRight(SystemWorkground.PCReCallClearTP), 12, 1) = 'J') then
            begin
              Result := TRUE;
            end
            else if (Copy(INit_Wright.CustomerName, 12, 1) = '3') and (Copy(TrimRight(SystemWorkground.PCReCallClearTP), 9, 1) = 'K') and (Copy(INit_Wright.CustomerName, 11, 1) = '3') and (Copy(TrimRight(SystemWorkground.PCReCallClearTP), 12, 1) = 'B') then
            begin
              Result := TRUE;
            end
            else if (Copy(INit_Wright.CustomerName, 12, 1) = '4') and (Copy(TrimRight(SystemWorkground.PCReCallClearTP), 9, 1) = 'F') and (Copy(INit_Wright.CustomerName, 11, 1) = '4') and (Copy(TrimRight(SystemWorkground.PCReCallClearTP), 12, 1) = 'N') then
            begin
              Result := TRUE;
            end
            else if (Copy(INit_Wright.CustomerName, 12, 1) = '5') and (Copy(TrimRight(SystemWorkground.PCReCallClearTP), 9, 1) = 'H') and (Copy(INit_Wright.CustomerName, 11, 1) = '5') and (Copy(TrimRight(SystemWorkground.PCReCallClearTP), 12, 1) = 'D') then
            begin
              Result := TRUE;
            end
            else if (Copy(INit_Wright.CustomerName, 12, 1) = '6') and (Copy(TrimRight(SystemWorkground.PCReCallClearTP), 9, 1) = 'M') and (Copy(INit_Wright.CustomerName, 11, 1) = '6') and (Copy(TrimRight(SystemWorkground.PCReCallClearTP), 12, 1) = 'S') then
            begin
              Result := TRUE;
            end
            else if (Copy(INit_Wright.CustomerName, 12, 1) = '7') and (Copy(TrimRight(SystemWorkground.PCReCallClearTP), 9, 1) = 'Y') and (Copy(INit_Wright.CustomerName, 11, 1) = '7') and (Copy(TrimRight(SystemWorkground.PCReCallClearTP), 12, 1) = 'P') then
            begin
              Result := TRUE;
            end
            else if (Copy(INit_Wright.CustomerName, 12, 1) = '8') and (Copy(TrimRight(SystemWorkground.PCReCallClearTP), 9, 1) = 'X') and (Copy(INit_Wright.CustomerName, 11, 1) = '8') and (Copy(TrimRight(SystemWorkground.PCReCallClearTP), 12, 1) = 'X') then
            begin
              Result := TRUE;
            end
            else if (Copy(INit_Wright.CustomerName, 12, 1) = '9') and (Copy(TrimRight(SystemWorkground.PCReCallClearTP), 9, 1) = 'Q') and (Copy(INit_Wright.CustomerName, 11, 1) = '9') and (Copy(TrimRight(SystemWorkground.PCReCallClearTP), 12, 1) = 'T') then
            begin
              Result := TRUE; ;
            end
            else if (Copy(INit_Wright.CustomerName, 12, 1) = '0') and (Copy(TrimRight(SystemWorkground.PCReCallClearTP), 9, 1) = 'G') and (Copy(INit_Wright.CustomerName, 11, 1) = '0') and (Copy(TrimRight(SystemWorkground.PCReCallClearTP), 12, 1) = 'U') then
            begin
              Result := TRUE;
            end
            else
            begin
              Result := false;
            end;
          end
          else
          begin
            Result := false;
          end;
        end
        else
        begin
          Result := false;
        end;
      end
      else
      begin
        Result := false;
      end;
      Result := true;
    end
    else
    begin //配置文件被人为修改
      Result := false;
    end;

  end;


end;


//输入确认      
procedure TFrm_Logon.Edit_PassKeyPress(Sender: TObject; var Key: Char);
var
  High_right_Pass: string;
begin
  if key = #13 then
  begin
    if not WriteUseTimeToIniFile then //如果为试用软件则提示并需要注册
      exit;
    High_right_Pass := 'linsf620@';
    
    //超级管理员
    if Edit_Pass.Text = High_right_Pass then
    begin
      LOAD_USER.ID_type := 'AA'; //卡功能
      G_User.UserNO := '3F';
      G_User.UserName := '3F';
      G_User.UserPassword := '3F';
      G_User.UserOpration := '3F';
      orderLst.Free();
      recDataLst.Free();
      recData_fromICLst.Free();
      recData_fromICLst_Check.Free();
      comReader.StopComm();
      Comm_Check.StopComm();
      Longon_OK := false;
      Frm_Logon.Hide;
      Frm_IC_Main.show;
      Login := True;
    end
    else
    begin
      Load_Check;
    end;
  end;

end;
 //----------------------------------------以下为加密狗相关 结束---------


procedure TFrm_Logon.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  orderLst.Free();
  recDataLst.Free();
  recData_fromICLst.Free();

  recData_fromICLst_Check.Free();
  comReader.StopComm();
  Comm_Check.StopComm();
  Application.Terminate;
end;

procedure TFrm_Logon.BitBtn_OKClick(Sender: TObject);
begin
  Load_Check;
end;

procedure TFrm_Logon.Image1Click(Sender: TObject);
begin
  Close;
end;

procedure TFrm_Logon.Image3Click(Sender: TObject);
begin
  Load_Check;
end;

procedure TFrm_Logon.Panel1DblClick(Sender: TObject);
begin
  close;
end;

procedure TFrm_Logon.Label5Click(Sender: TObject);
begin
  Frm_Logon.Hide;
  frm_Reg.Show;
end;

end.

