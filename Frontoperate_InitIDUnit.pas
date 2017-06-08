unit Frontoperate_InitIDUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SPComm, DB, ADODB, Grids, DBGrids, StdCtrls, Buttons, ExtCtrls;

type
  Tfrm_Frontoperate_InitID = class(TForm)
    Panel2: TPanel;
    GroupBox5: TGroupBox;
    Label2: TLabel;
    Panel1: TPanel;
    DBGrid2: TDBGrid;
    DataSource_Init: TDataSource;
    ADOQuery_Init: TADOQuery;
    comReader: TComm;
    GroupBox1: TGroupBox;
    Label9: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Edit_ID: TEdit;
    ID_3F: TEdit;
    ID_Password_3F: TEdit;
    ID_Password_USER: TEdit;
    ID_Value: TEdit;
    ID_CheckSum: TEdit;
    Label7: TLabel;
    Label10: TLabel;
    Label8: TLabel;
    Label6: TLabel;
    BitBtn_INIT: TBitBtn;
    BitBtn12: TBitBtn;
    Label11: TLabel;
    Label12: TLabel;
    ComboBox_Menbertype: TComboBox;
    BitBtn_Update: TBitBtn;
    Edit1: TEdit;
    CheckBox_Update: TCheckBox;
    GroupBox2: TGroupBox;
    Label14: TLabel;
    Label15: TLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    BitBtn18: TBitBtn;
    GroupBox3: TGroupBox;
    Label3: TLabel;
    Edit_PrintNO: TEdit;
    Label1: TLabel;
    Edit_OPResult: TEdit;
    Label13: TLabel;
    Edit14: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Edit10: TEdit;
    Edit11: TEdit;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Edit12: TEdit;
    Label24: TLabel;
    Label25: TLabel;
    Edit13: TEdit;
    BitBtn1: TBitBtn;
    Edit15: TEdit;
    Edit16: TEdit;
    Edit17: TEdit;
    Edit18: TEdit;
    Edit19: TEdit;
    Edit20: TEdit;
    BitBtn2: TBitBtn;
    Edit21: TEdit;
    Customer_Phone: TComboBox;
    CUSTOMER_NO: TComboBox;
    procedure BitBtn18Click(Sender: TObject);
    procedure comReaderReceiveData(Sender: TObject; Buffer: Pointer;
      BufferLength: Word);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

    procedure BitBtn_INITClick(Sender: TObject);
    procedure ComboBox_MenbertypeClick(Sender: TObject);
    procedure BitBtn12Click(Sender: TObject);
    procedure BitBtn_UpdateClick(Sender: TObject);
    procedure CheckBox_UpdateClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Customer_PhoneClick(Sender: TObject);
    procedure CUSTOMER_NOClick(Sender: TObject);
  private
    procedure AnswerOper(); //响应接收上分、下分操作的事件
  public
    { Public declarations }
    function exchData(orderStr: string): string;
    procedure INIT_Operation_Can_Check();
    procedure IncvalueComfir(S: string; S1: string);
    procedure sendData();
    procedure checkOper();
    procedure InitDataBase;
    procedure CheckCMD();
    procedure INcrevalue(S: string); //充值函数
    function CheckSUMData(orderStr: string): string; //校验和
    function Make_Send_CMD(StrCMD: string; StrIncValue: string): string;
    function Select_IncValue_Byte(StrIncValue: string): string;
    function Select_CheckSum_Byte(StrCheckSum: string): string;
    function INit_Send_CMD(StrCMD: string; StrIncValue: string): string;
    function QueryCustomer_No(strphone: string): string;
    procedure init_comboBox_Menbertype;
    procedure INIT_Operation;
    //保存初始化数据到数据库
    procedure Save_INit_Data;
    
      //ID卡身份识别
    function CHECK_3F_ID(StrCheckSum: string; ID_3F: string; Password_3F: string): boolean;
    function SUANFA_ID_3F(StrCheckSum: string): string;
    function SUANFA_Password_3F(StrCheckSum: string): string;
    function Display_ID_TYPE(StrIDtype: string): string;
    procedure Query_for_Update(StrID: string);
    procedure Save_INit_update;
    function Display_ID_TYPE_Value(StrIDtype: string): string;
    function Query_User_infor(StrID: string; Query_Type: string; ID_Type_Input: string): string;
    procedure Query_SUM_Type(StrID: string; Query_Type: string);
    function Query_User_LastBuy(StrID: string; Query_Type: string): string;
    procedure InitCarMC_ID(Str1: string);
    procedure InitCustomerName; //初始化客户下拉框
  end;

var
  frm_Frontoperate_InitID: Tfrm_Frontoperate_InitID;
  curOrderNo: integer = 0;
  curOperNo: integer = 0;
  Operate_No: integer = 0;
  INC_value: string;
  ID_System: string;
  Password3F_System: string;

  orderLst, recDataLst, recData_fromICLst: Tstrings;
  buffer: array[0..2048] of byte;
  INIT_Operation_OK: boolean;
  INIT_Operation_Can: boolean;
implementation
uses ICDataModule, ICtest_Main, ICCommunalVarUnit, ICmain, ICEventTypeUnit, ICFunctionUnit,
  Frontoperate_EBincvalueUnit;

{$R *.dfm}
//关闭按键
procedure Tfrm_Frontoperate_InitID.BitBtn18Click(Sender: TObject);
begin
  Close;
end;

//记录初始化
procedure Tfrm_Frontoperate_InitID.InitDataBase;
var
  strSQL: string;
begin
  with ADOQuery_Init do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
  
    strSQL := 'select top 5 * from [3F_ID_INIT] order by id_inittime desc';
    SQL.Add(strSQL);
    Active := True;
  end;
end;


//转找发送数据格式 ，将字符转换为16进制 
function Tfrm_Frontoperate_InitID.exchData(orderStr: string): string;
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

//发送数据过程

procedure Tfrm_Frontoperate_InitID.sendData();
var
  orderStr: string;
begin
  if orderLst.Count > curOrderNo then
  begin
    orderStr := orderLst.Strings[curOrderNo];
        //memComSeRe.Lines.Add('==>> '+orderStr);
    orderStr := exchData(orderStr);
    comReader.WriteCommData(pchar(orderStr), length(orderStr));
    inc(curOrderNo);
  end;
end;

//检查返回的数据

procedure Tfrm_Frontoperate_InitID.checkOper();
var
  i: integer;
begin
  case curOperNo of
    2: begin //反馈卡余额总值操作
        for i := 0 to recData_fromICLst.Count - 1 do
          if copy(recData_fromICLst.Strings[i], 9, 2) <> '01' then // 写操作成功返回命令
          begin
                       // recData_fromICLst.Clear;
            exit;
          end;
      end;
  end;
end;


//校验和，确认是否正确

function Tfrm_Frontoperate_InitID.CheckSUMData(orderStr: string): string;
var
  ii, jj, KK: integer;
  TmpStr: string;
  reTmpStr: string;
begin
    //if (length(orderStr)<>42) then
    //begin
    //    MessageBox(handle,'传入参数长度不对!','错误',MB_ICONERROR+MB_OK);
    //    result:='';
    //    exit;
   // end;
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
//充值数据转换成16进制并排序 字节LL、字节LH、字节HL、字节HH

function Tfrm_Frontoperate_InitID.Select_IncValue_Byte(StrIncValue: string): string;
var
  tempLH, tempHH, tempHL, tempLL: integer; //2147483648 最大范围
begin
  tempHH := StrToint(StrIncValue) div 16777216; //字节HH
  tempHL := (StrToInt(StrIncValue) mod 16777216) div 65536; //字节HL
  tempLH := (StrToInt(StrIncValue) mod 65536) div 256; //字节LH
  tempLL := StrToInt(StrIncValue) mod 256; //字节LL

  result := IntToHex(tempLL, 2) + IntToHex(tempLH, 2) + IntToHex(tempHL, 2) + IntToHex(tempHH, 2);
end;


//校验和转换成16进制并排序 字节LL、字节LH

function Tfrm_Frontoperate_InitID.Select_CheckSum_Byte(StrCheckSum: string): string;
var
  jj: integer;
  tempLH, tempLL: integer; //2147483648 最大范围

begin
  jj := strToint('$' + StrCheckSum); //将字符转转换为16进制数，然后转换位10进制
  tempLH := (jj mod 65536) div 256; //字节LH
  tempLL := jj mod 256; //字节LL

  result := IntToHex(tempLL, 2) + IntToHex(tempLH, 2);
end;


//计算充值指令

function Tfrm_Frontoperate_InitID.Make_Send_CMD(StrCMD: string; StrIncValue: string): string;
var
  TmpStr_IncValue: string; //充值数字
  TmpStr_CheckSum: string; //校验和
  TmpStr_SendCMD: string; //指令内容
  reTmpStr: string;
begin
   // if (length(StrIncValue) mod 2)<>0 then
  begin
   //     MessageBox(handle,'传入参数长度错误!','错误',MB_ICONERROR+MB_OK);
   //     result:='';
    //    exit;
  end;

  Send_CMD_ID_Infor.CMD := StrCMD; //帧命令
  Send_CMD_ID_Infor.ID_INIT := Receive_CMD_ID_Infor.ID_INIT;
  Send_CMD_ID_Infor.ID_3F := Receive_CMD_ID_Infor.ID_3F;
  Send_CMD_ID_Infor.Password_3F := Receive_CMD_ID_Infor.Password_3F;
  Send_CMD_ID_Infor.Password_USER := Receive_CMD_ID_Infor.Password_USER;
    //TmpStr_IncValue字节需要重新排布 ，如果StrIncValue>65535(FFFF)
   // TmpStr_IncValue:=IntToHex(strToint(StrIncValue),2);//将输入的文本数字转换为16进制
  TmpStr_IncValue := StrIncValue;
  Send_CMD_ID_Infor.ID_value := Select_IncValue_Byte(TmpStr_IncValue);

  Send_CMD_ID_Infor.ID_type := Receive_CMD_ID_Infor.ID_type;
    //汇总发送内容
  TmpStr_SendCMD := Send_CMD_ID_Infor.CMD + Send_CMD_ID_Infor.ID_INIT + Send_CMD_ID_Infor.ID_3F + Send_CMD_ID_Infor.Password_3F + Send_CMD_ID_Infor.Password_USER + Send_CMD_ID_Infor.ID_value + Send_CMD_ID_Infor.ID_type;
    //将发送内容进行校核计算
  TmpStr_CheckSum := CheckSUMData(TmpStr_SendCMD);
    //TmpStr_CheckSum字节需要重新排布 ，低字节在前，高字节在后
  Send_CMD_ID_Infor.ID_CheckNum := Select_CheckSum_Byte(TmpStr_CheckSum);
  Send_CMD_ID_Infor.ID_Settime := Receive_CMD_ID_Infor.ID_Settime;


  reTmpStr := TmpStr_SendCMD + Send_CMD_ID_Infor.ID_CheckNum;

  result := reTmpStr;
end;





//检查返回的数据

procedure Tfrm_Frontoperate_InitID.AnswerOper();
var
  Send_value: string;
  RevComd: integer;
  ID_No: string;
  length_Data: integer;
  Dingwei: array[0..8] of string; //用于转存截取的帧信息
begin
  RevComd := 0;
   //首先截取接收的信息

  Dingwei[1] := copy(recData_fromICLst.Strings[0], 1, 4); //帧头AA8A
  Dingwei[2] := copy(recData_fromICLst.Strings[0], 5, 4); //站号地址
  Dingwei[3] := copy(recData_fromICLst.Strings[0], 9, 2); //命令地址
  Dingwei[4] := copy(recData_fromICLst.Strings[0], 11, 2); //数据长度地址
       //根据数据长度Dingwei[4]截取数据 Dingwei[5]
  length_Data := 2 * ICFunction.Str_HexToInt(Dingwei[4]);
  Dingwei[5] := copy(recData_fromICLst.Strings[0], 13, length_Data); //数据-ID卡号

  Dingwei[6] := copy(recData_fromICLst.Strings[0], 13 + length_Data, 2); //结束符1
  Dingwei[7] := copy(recData_fromICLst.Strings[0], 13 + length_Data + 2, 2); //结束符2

  if Dingwei[3] = 'A1' then //A1表示IC取得了卡ID,或PC要读取IC的卡ID
  begin
    RevComd := 1;
  end;
  if Dingwei[3] = 'B1' then //B1表示IC成功读取了卡值
  begin
    RevComd := 2;
  end;
  if Dingwei[3] = 'B2' then //B2表示IC成功写入卡值
  begin
    RevComd := 3;
  end;
   //判断相关指令后进行对应操作
  case RevComd of
    1: begin //自寻卡成功
        Edit_ID.Text := Dingwei[5];
        recData_fromICLst.Clear;
        RevComd := 0;
                //系统软件记录对应机台操作日志  根据Dingwei[2]
                //Record_MC_Operate
      end;
    2: begin //成功读取卡值
        Edit_ID.Text := Copy(Dingwei[5], 1, 8);
        Edit_PrintNO.Text := Copy(Dingwei[5], 9, 2);
        if (Dingwei[5] = '02') then
          Edit_OPResult.Text := '寻卡、读值失败'
        else
          Edit_OPResult.Text := '寻卡、读值成功';

                //Send_B1();
        recData_fromICLst.Clear;
        RevComd := 0;

                 //回复IC，确认已经收到读取的剩余值
                //系统软件记录对应机台操作日志  根据Dingwei[2]
                //Record_MC_Operate
      end;
    3: begin //成功写入卡值
        if (Dingwei[5] = '02') then
          Edit_OPResult.Text := '写值失败'
        else
          IncvalueComfir(Edit_ID.Text, INC_value); //第一参数为币ID号，第二个位充值额度
        Edit_OPResult.Text := '写值成功';
        recData_fromICLst.Clear;
        RevComd := 0;
                //系统软件记录对应机台操作日志  根据Dingwei[2]
                //Record_MC_Operate
      end;
  end;
end;

//串口监听函数
procedure Tfrm_Frontoperate_InitID.comReaderReceiveData(Sender: TObject;
  Buffer: Pointer; BufferLength: Word);
var
  ii: integer;
  recStr: string;
  tmpStr: string;
  tmpStrend: string;
begin
   //接收----------------
  tmpStrend := 'STR';
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
    //接收---------------
     //if  (tmpStrend='END') then
  begin
    INIT_Operation_Can_Check; 
    if INIT_Operation_Can then
    begin
      CheckCMD(); //首先根据接收到的数据进行判断，确认此卡是否属于为正确的卡
         //AnswerOper();//其次确认是否有需要回复IC的指令
    end;
  end;
    //发送---------------
  if curOrderNo < orderLst.Count then // 判断指令是否已经都发送完毕，如果指令序号小于指令总数则继续发送
    sendData()
  else begin
    checkOper();
  end;

end;


//检查是否让串口起作用(检查是否已经输入客户名称，客户编号)

procedure Tfrm_Frontoperate_InitID.INIT_Operation_Can_Check();
var
  temp1: string;
begin

  INIT_Operation_Can := true;
  temp1 := '请点击选择客户名称';
  if Customer_Phone.Text = temp1 then
    INIT_Operation_Can := false;
  temp1 := '请点击选择客户编号';
  if CUSTOMER_NO.Text = temp1 then
    INIT_Operation_Can := false;
end;

//根据接收到的数据判断此卡是否为合法卡

procedure Tfrm_Frontoperate_InitID.CheckCMD();
var
  i: integer;
  tmpStr: string;
  stationNoStr: string;
  tmpStr_Hex: string;
  tmpStr_Hex_length: string;
  Send_value: string;
  RevComd: integer;
  ID_No: string;
  length_Data: integer;
begin
   //首先截取接收的信息

  ComboBox_Menbertype.Items.Clear;
  init_comboBox_Menbertype; //初始化 ComboBox_Menbertype

  tmpStr := recData_fromICLst.Strings[0];
  Edit1.Text := recData_fromICLst.Strings[0];
  Receive_CMD_ID_Infor.ID_CheckNum := copy(tmpStr, 39, 4); //校验和

      // if (CheckSUMData(copy(tmpStr, 1, 38))=copy(tmpStr, 41, 2)+copy(tmpStr, 39, 2)) then//校验和
  begin
    CMD_CheckSum_OK := true;
    Receive_CMD_ID_Infor.CMD := copy(recData_fromICLst.Strings[0], 1, 2); //帧头43
  end;

  //1、判断此卡是否为已经完成初始化
  if Receive_CMD_ID_Infor.CMD = CMD_COUMUNICATION.CMD_INCValue_RE then
  begin

    if (Customer_Phone.Text <> '') and (CUSTOMER_NO.Text <> '') and (Edit_ID.Text <> '') then
    begin
      if (Operate_No = 1) then //保存当前卡的初始化记录
      begin
        Save_INit_Data;
        Edit_OPResult.Text := '初始化操作、保存成功';
      end
      else if (Operate_No = 2) then //此处即为追加的更新事件
      begin
        Save_INit_update;
        Edit_OPResult.Text := '更新操作、保存成功';
      end;
    end;
  end
  else if Receive_CMD_ID_Infor.CMD = CMD_COUMUNICATION.CMD_READ then
  begin

    Receive_CMD_ID_Infor.ID_INIT := copy(recData_fromICLst.Strings[0], 3, 8); //卡片ID
    Receive_CMD_ID_Infor.ID_3F := copy(recData_fromICLst.Strings[0], 11, 6); //卡厂ID
    Receive_CMD_ID_Infor.Password_3F := copy(recData_fromICLst.Strings[0], 17, 6); //卡密
    Receive_CMD_ID_Infor.Password_USER := copy(recData_fromICLst.Strings[0], 23, 6); //用户密码
    Receive_CMD_ID_Infor.ID_value := copy(recData_fromICLst.Strings[0], 29, 8); //卡内数据
    Receive_CMD_ID_Infor.ID_type := copy(recData_fromICLst.Strings[0], 37, 2); //卡功能

    ICFunction.loginfo('出厂初始化 Receive_CMD_ID_Infor.ID_INIT '+ Receive_CMD_ID_Infor.ID_INIT );
    ICFunction.loginfo('出厂初始化 Receive_CMD_ID_Infor.ID_3F '+ Receive_CMD_ID_Infor.ID_3F );
    ICFunction.loginfo('出厂初始化 Receive_CMD_ID_Infor.Password_3F '+ Receive_CMD_ID_Infor.Password_3F );
    ICFunction.loginfo('出厂初始化 Receive_CMD_ID_Infor.Password_USER '+ Receive_CMD_ID_Infor.Password_USER );
    ICFunction.loginfo('出厂初始化 Receive_CMD_ID_Infor.ID_value '+ Receive_CMD_ID_Infor.ID_value );
    ICFunction.loginfo('出厂初始化 Receive_CMD_ID_Infor.ID_type '+ Receive_CMD_ID_Infor.ID_type );
    
    

                 //1、判断是否曾经初始化过 算法加密/解密，如果是则，执行步骤2 ICFunction.
    if ICFunction.CHECK_3F_ID(Receive_CMD_ID_Infor.ID_INIT, Receive_CMD_ID_Infor.ID_3F, Receive_CMD_ID_Infor.Password_3F) then
    begin
                //2、如果确认完成了初始化，则进一步判断此卡在数据库中是否有记录
      if DataModule_3F.Query_ID_INIT_OK(Receive_CMD_ID_Infor.ID_INIT) then //有记录
      begin
        Edit_ID.Text := Receive_CMD_ID_Infor.ID_INIT; //卡ID
                         //MessageBox(handle,'当前卡已经初始化!请通知老板！随时跟踪此人！','错误',MB_ICONERROR+MB_OK);
        Edit14.Text := '当前卡为' + Display_ID_TYPE(Receive_CMD_ID_Infor.ID_type) + '----初始化成功'; //卡ID

                         //把此卡对应的所有信息查询出来显示，以供修改用
        if (not CheckBox_Update.Checked) then
          Query_for_update(Edit_ID.Text); //查询此卡对应的记录

        Query_SUM_Type(Edit_ID.Text, '1'); //查询此卡对应的用户台账
                              
        ID_Password_USER.Text := INit_Wright.BossPassword;
                         //exit;
      end
      else //无记录
      begin
        Edit_ID.Text := Receive_CMD_ID_Infor.ID_INIT; //卡ID
        ID_System := ICFunction.SUANFA_ID_3F(Edit_ID.Text); //调用计算ID_3F算法
        Password3F_System := ICFunction.SUANFA_Password_3F(Edit_ID.Text); //调用计算Password_3F算法
        if CUSTOMER_NO.Text <> '' then
        begin
          Operate_No := 1;
          INIT_Operation; //调用初始化单击操作事件
        end
        else
        begin
          Edit14.Text := '客户编号不能为空，请将卡取走，填写后再放卡';
          exit;
        end;
                         // exit;
      end;
    end
    else //从未初始化过的卡
    begin
            //追加判断手机号输入框和客户编号输入框是否为空，同时要求ID框必须为空（防止ID重号报警），
            //如果不为空则自动执行初始化操作
      Edit_ID.Text := Receive_CMD_ID_Infor.ID_INIT; //卡ID
      if (Customer_Phone.Text <> '') and (CUSTOMER_NO.Text <> '') and (Edit_ID.Text <> '') then
      begin
        ID_System := ICFunction.SUANFA_ID_3F(Edit_ID.Text); //调用计算ID_3F算法
        Password3F_System := ICFunction.SUANFA_Password_3F(Edit_ID.Text); //调用计算Password_3F算法
        INIT_Operation; //调用初始化单击操作事件
        Operate_No := 1;
      end;

    end;

  end;

end;


//初始化操作

procedure Tfrm_Frontoperate_InitID.INIT_Operation;
var
  INC_value: string;
  strValue: string;
begin
  if Edit_ID.Text = '' then
  begin
    MessageBox(handle, '无卡!请勿乱操作', '错误', MB_ICONERROR + MB_OK);
    exit;
  end;
  if Customer_Phone.Text = '' then
  begin
    MessageBox(handle, '手机号未填写!请勿乱操作', '错误', MB_ICONERROR + MB_OK);
    exit;
  end;

  begin
    INC_value := '0000'; //充值数值
    INC_value := '00000000'; //充值数值
    strValue := INit_Send_CMD(CMD_COUMUNICATION.CMD_INCValue, INC_value); //计算充值指令
    Edit19.Text := strValue;
    INcrevalue(strValue); //写入ID卡
  end;
end;


//初始化卡计算指令

function Tfrm_Frontoperate_InitID.INit_Send_CMD(StrCMD: string; StrIncValue: string): string;
var
  TmpStr_IncValue: string; //充值数字
  TmpStr_CheckSum: string; //校验和
  TmpStr_SendCMD: string; //指令内容
  reTmpStr: string;
begin

  INit_3F.CMD := StrCMD; //帧命令
  INit_3F.ID_INIT := Edit_ID.Text; //币ID

    //Password3F_System 、ID_System这两个变量在输入完毕用户编号回车时执行生成的
  INit_3F.ID_3F := copy(Password3F_System, 5, 2) + copy(ID_System, 1, 2) + copy(Password3F_System, 3, 2);
  ID_3F.Text := INit_3F.ID_3F;
 
  INit_3F.Password_3F := INit_Wright.BossPassword; //直接读取配置文件中的场地密码 (PC托盘特征码)
  ID_Password_3F.Text := INit_3F.Password_3F; //用户场地密码，保存在文档里面

  ID_Password_USER.Text := INit_Wright.BossPassword; //直接读取配置文件中的场地密码  (PC托盘特征码)
  INit_3F.Password_USER := INit_Wright.BossPassword; //用户场地密码，保存在文档里面  (PC托盘特征码)

  TmpStr_IncValue := COPY(INit_3F.ID_3F, 3, 2) + ICFunction.SUANFA_Password_USER_WritetoID(INit_3F.ID_3F, CUSTOMER_NO.Text);
  INit_3F.ID_value := TmpStr_IncValue;


  INit_3F.ID_type := Display_ID_TYPE_Value(ComboBox_Menbertype.Text); //取得卡类型的值
  Edit20.Text := ID_Password_USER.Text;
    //汇总发送内容
  TmpStr_SendCMD := INit_3F.CMD + INit_3F.ID_INIT + INit_3F.ID_3F + INit_3F.Password_3F + ID_Password_USER.Text + INit_3F.ID_value + INit_3F.ID_type;
   //TmpStr_SendCMD:=指令帧头+ 币ID+ 3F出厂ID + 3F出厂密码+   用户场地密码  +   3F出厂初始币值  + 3F出厂初始币类型

    //将发送内容进行校核计算
  TmpStr_CheckSum := CheckSUMData(TmpStr_SendCMD);
    //TmpStr_CheckSum字节需要重新排布 ，低字节在前，高字节在后
  INit_3F.ID_CheckNum := Select_CheckSum_Byte(TmpStr_CheckSum);
  ID_CheckSum.Text := Select_CheckSum_Byte(TmpStr_CheckSum);


   // INit_3F.ID_Settime:=Receive_CMD_ID_Infor.ID_Settime;


  reTmpStr := TmpStr_SendCMD + INit_3F.ID_CheckNum;

  result := reTmpStr;
end;


//写入ID卡----------------------------------------

procedure Tfrm_Frontoperate_InitID.INcrevalue(S: string);
begin
  orderLst.Clear();
  recDataLst.Clear();
  curOrderNo := 0;
  curOperNo := 2;
  Edit1.Text := s;
  orderLst.Add(S); //将币值写入币种
  sendData();
end;


//保存出厂初始化数据到数据库  
procedure Tfrm_Frontoperate_InitID.Save_INit_Data;
var
  strOperator, strinputdatetime: string;
label ExitSub;
begin

  strOperator := G_User.UserNO;
  strinputdatetime := DateTimetostr((now())); //录入时间，读取系统时间


  with ADOQuery_Init do begin
    //Searches the dataset for a specified record and makes that record the current record.
    if (Locate('ID_INIT', INit_3F.ID_INIT, [])) then begin   

      Edit1.Text := 'ID号  ' + INit_3F.ID_INIT + '  的卡初始化信息已完成,请勿恶意操作！';
      goto ExitSub;

    end
    else
    Append;
    FieldByName('ID_INIT').AsString := INit_3F.ID_INIT;
    FieldByName('ID_3F').AsString := INit_3F.ID_3F;
    FieldByName('Password_3F').AsString := INit_3F.Password_3F;
    FieldByName('Password_USER').AsString := INit_3F.Password_USER;
    FieldByName('ID_value').AsString := INit_3F.ID_value;
    FieldByName('ID_type').AsString := INit_3F.ID_type;
    FieldByName('ID_TypeName').AsString := Display_ID_TYPE(INit_3F.ID_type);
    FieldByName('ID_CheckNum').AsString := INit_3F.ID_CheckNum;
    FieldByName('cUserNo').AsString := INit_3F.cUserNo;
    FieldByName('Customer_Name').AsString := Customer_Phone.Text;
    FieldByName('Customer_NO').AsString := Customer_NO.Text;
    FieldByName('ID_Inittime').AsString := strinputdatetime;
    try
      Post;
    except
      on e: Exception do ShowMessage(e.Message);
    end;

  end;

 ExitSub:
  INit_3F.ID_INIT := '';
  INit_3F.ID_3F := '';
  INit_3F.Password_3F := '';
  INit_3F.Password_USER := '';
  INit_3F.ID_value := '';
  INit_3F.ID_type := '';
  INit_3F.ID_CheckNum := '';
  INit_3F.Customer_Name := '';
  INit_3F.Customer_NO := '';
  INit_3F.ID_Settime := '';
  Edit_ID.Text := '';
  Operate_No := 0;
end;



procedure Tfrm_Frontoperate_InitID.FormShow(Sender: TObject);
begin
  comReader.StartComm();
  orderLst := TStringList.Create;
  recDataLst := tStringList.Create;
  recData_fromICLst := tStringList.Create;

  init_comboBox_Menbertype;//初始化电子币功能类型
  InitDataBase; //显示所有电子币初始化结果
  InitCustomerName;//初始化客户名称下拉框
  
  Customer_Phone.Text := '请点击选择客户名称';
  CUSTOMER_NO.Text := '请点击选择客户编号';

  Edit_ID.Text := '';
  ID_3F.Text := '';
  ID_Password_3F.Text := '';
  ID_Password_USER.Text := '';
  ID_Value.Text := '';
  Edit1.Text := '请先选择客户名称，然后选择用户编号，再将卡放在读卡器上方';
end;



procedure Tfrm_Frontoperate_InitID.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: integer;
begin
  orderLst.Free();
  recDataLst.Free();
  recData_fromICLst.Free();
  comReader.StopComm();

  ICFunction.ClearIDinfor; //清除从ID读取的所有信息

end;


//充值保存确认

procedure Tfrm_Frontoperate_InitID.IncvalueComfir(S: string; S1: string);

var
  strIDNo, strName, strUserNo, strIncvalue, strGivecore, strOperator, strhavemoney, strinputdatetime: string;
  i: integer;
label ExitSub;
begin

  strIDNo := Edit_ID.Text;
  strOperator := G_User.UserNO; //操作员
  strinputdatetime := DateTimetostr((now())); //录入时间，读取系统时间

  with ADOQuery_Init do begin
    Append;
    FieldByName('CostMoney').AsString := strIncvalue; //充值
    FieldByName('cUserNo').AsString := strOperator; //操作员
    FieldByName('GetTime').AsString := strinputdatetime; //交易时间
    FieldByName('IDCardNo').AsString := strIDNo; //卡ID
    try
      Post;
    except
      on e: Exception do ShowMessage(e.Message);
    end;
  end;


  ExitSub:
   //情况输入框
  for i := 0 to ComponentCount - 1 do
  begin
    if components[i] is TEdit then
    begin
      (components[i] as TEdit).Clear;
    end
  end;
end;


procedure Tfrm_Frontoperate_InitID.FormCreate(Sender: TObject);
begin

  //   EventObj:=EventUnitObj.Create;
  //   EventObj.LoadEventIni;

end;

//新用户，第一次初始化

procedure Tfrm_Frontoperate_InitID.BitBtn_INITClick(Sender: TObject);
begin
  Operate_No := 1;
  INIT_Operation;

end;

//查找客户编号

function Tfrm_Frontoperate_InitID.QueryCustomer_No(strphone: string): string;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  rtn: string;
begin

  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select distinct[Mobile] from [3F_Customer]';
  with ADOQTemp do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    ComboBox_Menbertype.Items.Clear;
    while not Eof do begin
      rtn := FieldByName('Mobile').AsString;
      Next;
    end;
  end;
  FreeAndNil(ADOQTemp);
  Result := rtn;
end;

procedure Tfrm_Frontoperate_InitID.ComboBox_MenbertypeClick(
  Sender: TObject);
begin
//   INit_3F.ID_type:=Display_ID_TYPE_Value(ComboBox_Menbertype.Text); //取得卡类型的值
   //BitBtn_INIT.setfocus;
end;

procedure Tfrm_Frontoperate_InitID.BitBtn12Click(Sender: TObject);
begin
  Customer_Phone.Text := '';
  CUSTOMER_NO.Text := '';
  Edit_ID.Text := '';
  ID_3F.Text := '';
  ID_Password_3F.Text := '';
  Edit1.Text := '';
  Edit14.Text := '';
end;
  //ID卡身份识别

function Tfrm_Frontoperate_InitID.CHECK_3F_ID(StrCheckSum: string; ID_3F: string; Password_3F: string): boolean;
var
  ID_3F_1: string;
  ID_3F_2: string;
  ID_3F_3: string;
  PWD_3F_1: string;
  PWD_3F_2: string;
  PWD_3F_3: string;
  tempTOTAL1: integer;
  tempTOTAL2: integer;

  Byte1, Byte2, Byte3, Byte4, Byte5, Byte6: integer;
begin
    //StrCheckSum:='2A2542CB';
  ID_3F_1 := copy(ID_3F, 3, 2);
  ID_3F_2 := copy(Password_3F, 3, 2);
  ID_3F_3 := copy(Password_3F, 1, 2);

    //Edit2.Text:=ID_3F_1;
    //Edit3.Text:=ID_3F_2;
    //Edit4.Text:=ID_3F_3;

  PWD_3F_1 := copy(Password_3F, 5, 2);
  PWD_3F_2 := copy(ID_3F, 5, 2);
  PWD_3F_3 := copy(ID_3F, 1, 2);

    //Edit5.Text:=PWD_3F_1;
    //Edit6.Text:=PWD_3F_2;
    //Edit7.Text:=PWD_3F_3;


    //卡厂ID
  tempTOTAL1 := strToint('$' + Copy(StrCheckSum, 1, 2)) + strToint('$' + Copy(StrCheckSum, 3, 2)) + strToint('$' + Copy(StrCheckSum, 5, 2)) * strToint('$' + Copy(StrCheckSum, 7, 2));
    //Edit15.Text:=IntToStr(tempTOTAL1);

  Byte1 := (tempTOTAL1 * tempTOTAL1) mod 16;
  Byte2 := (tempTOTAL1 * tempTOTAL1) div 16;
  Byte3 := tempTOTAL1;

    //Byte2  Byte3  Byte1
    //Edit8.Text:=copy(IntToHex(Byte2,2),length(IntToHex(Byte2,2))-2,2);
    //Edit9.Text:=copy(IntToHex(Byte3,2),length(IntToHex(Byte3,2))-1,2);
    //Edit10.Text:=copy(IntToHex(Byte1,2),length(IntToHex(Byte1,2))-1,2);

  Result := true;
  if (ID_3F_1 <> copy(IntToHex(Byte2, 2), length(IntToHex(Byte2, 2)) - 2, 2)) then
    Result := false; //第一字节
  if (ID_3F_2 <> copy(IntToHex(Byte3, 2), length(IntToHex(Byte3, 2)) - 1, 2)) then
    Result := false; //第二字节
  if (ID_3F_3 <> copy(IntToHex(Byte1, 2), length(IntToHex(Byte1, 2)) - 1, 2)) then
    Result := false; //第三字节


         //卡厂密码
  tempTOTAL2 := strToint('$' + Copy(StrCheckSum, 1, 2)) * strToint('$' + Copy(StrCheckSum, 3, 2)) + strToint('$' + Copy(StrCheckSum, 5, 2));
    // Edit16.Text:=IntToStr(tempTOTAL2);
  Byte4 := (tempTOTAL2 * tempTOTAL2) mod 16;
  Byte5 := (tempTOTAL2 * tempTOTAL2) div 16;
  Byte6 := tempTOTAL2;
    //Edit11.Text:=copy(IntToHex(Byte4,2),length(IntToHex(Byte4,2))-2,2);
    //Edit12.Text:=copy(IntToHex(Byte5,2),length(IntToHex(Byte5,2))-2,2);
    //Edit13.Text:=copy(IntToHex(Byte6,2),length(IntToHex(Byte6,2))-2,2);

  if (PWD_3F_1 <> copy(IntToHex(Byte4, 2), length(IntToHex(Byte4, 2)) - 2, 2)) then
    Result := false; //第一字节
  if (PWD_3F_2 <> copy(IntToHex(Byte5, 2), length(IntToHex(Byte5, 2)) - 2, 2)) then
    Result := false; //第二字节
  if (PWD_3F_3 <> copy(IntToHex(Byte6, 2), length(IntToHex(Byte6, 2)) - 2, 2)) then
    Result := false; //第三字节

end;



//卡厂ID算法

function Tfrm_Frontoperate_InitID.SUANFA_ID_3F(StrCheckSum: string): string;
var
  Byte1, Byte2, Byte3: integer;
  temp, tempTOTAL1, tempTOTAL2, tempTOTAL3: integer; //2147483648 最大范围

begin

  tempTOTAL1 := strToint('$' + Copy(StrCheckSum, 1, 2)) + strToint('$' + Copy(StrCheckSum, 3, 2)) + strToint('$' + Copy(StrCheckSum, 5, 2)) * strToint('$' + Copy(StrCheckSum, 7, 2));
    //Edit17.Text:=IntToStr(tempTOTAL1);
  Byte1 := (tempTOTAL1 * tempTOTAL1) mod 16; // 第二字节
  Byte2 := (tempTOTAL1 * tempTOTAL1) div 16; //第二字节
  Byte3 := tempTOTAL1; //第一字节
    //Byte2  Byte3  Byte1
  result := copy(IntToHex(Byte2, 2), length(IntToHex(Byte2, 2)) - 2, 2) + copy(IntToHex(Byte3, 2), length(IntToHex(Byte3, 2)) - 1, 2) + copy(IntToHex(Byte1, 2), length(IntToHex(Byte1, 2)) - 1, 2);

end;

//场地密码算法 StrCheckSum卡厂ID，strCUSTOMER_NO卡密

function Tfrm_Frontoperate_InitID.SUANFA_Password_3F(StrCheckSum: string): string;
var
  Byte1, Byte2, Byte3: integer;
  temp, tempTOTAL1, tempTOTAL2, tempTOTAL3: integer; //2147483648 最大范围

begin

  tempTOTAL1 := strToint('$' + Copy(StrCheckSum, 1, 2)) * strToint('$' + Copy(StrCheckSum, 3, 2)) + strToint('$' + Copy(StrCheckSum, 5, 2)); //ID_3F输入
    //Edit18.Text:=IntToStr(tempTOTAL1);
  Byte1 := (tempTOTAL1 * tempTOTAL1) mod 16; ; //第一字节
  Byte2 := (tempTOTAL1 * tempTOTAL1) div 16; //第二字节
  Byte3 := tempTOTAL1; //第二字节
     //Byte1  Byte2  Byte3
  result := copy(IntToHex(Byte1, 2), length(IntToHex(Byte1, 2)) - 2, 2) + copy(IntToHex(Byte2, 2), length(IntToHex(Byte2, 2)) - 2, 2) + copy(IntToHex(Byte3, 2), length(IntToHex(Byte3, 2)) - 2, 2);

end;



//根据当前卡ID查询其在库中的相关信息，供更新数据用

procedure Tfrm_Frontoperate_InitID.Query_for_Update(StrID: string);

var
  ADOQ: TADOQuery;
begin
  ADOQ := TADOQuery.Create(Self);
  ADOQ.Connection := DataModule_3F.ADOConnection_Main;

  with ADOQ do begin
    Close;
    SQL.Clear;
    SQL.Add('select top 5 * from [3F_ID_INIT] where [ID_INIT]=''' + StrID + '''  order by id_inittime desc ');
    Open;
    if (not Eof) then
    begin
      if (not CheckBox_Update.Checked) then begin
        Customer_Phone.Text := FieldByName('Customer_Name').AsString;
        CUSTOMER_NO.Text := FieldByName('Customer_NO').AsString;
        ComboBox_Menbertype.Text := Display_ID_TYPE(FieldByName('ID_type').AsString);

        BitBtn_Update.Enabled := false;

      end
      else
      begin
        BitBtn_Update.Enabled := true;
      end;
      //Edit_ID.Text:=FieldByName('ID_INIT').AsString;
      ID_3F.Text := FieldByName('ID_3F').AsString;
      ID_Password_3F.Text := FieldByName('Password_3F').AsString;
      ID_Password_USER.Text := FieldByName('Password_USER').AsString;

      ID_Value.Text := FieldByName('ID_value').AsString;
      ID_CheckSum.Text := FieldByName('ID_CheckNum').AsString;
    end;
  end;
  ADOQ.Close;
  ADOQ.Free;

end;

//卡功能下拉列表实始化
procedure Tfrm_Frontoperate_InitID.init_comboBox_Menbertype;
begin
  ComboBox_Menbertype.Items.Add(copy(INit_Wright.User, 1, 6));
 // ComboBox_Menbertype.Items.Add(copy(INit_Wright.Produecer_3F, 1, 6));
  ComboBox_Menbertype.Items.Add(copy(INit_Wright.BOSS, 1, 6));
  ComboBox_Menbertype.Items.Add(copy(INit_Wright.MANEGER, 1, 6));
 // ComboBox_Menbertype.Items.Add(copy(INit_Wright.QUERY, 1, 6));
  ComboBox_Menbertype.Items.Add(copy(INit_Wright.RECV_CASE, 1, 6));
 // ComboBox_Menbertype.Items.Add(copy(INit_Wright.SETTING, 1, 6));
  ComboBox_Menbertype.Items.Add(copy(INit_Wright.OPERN, 1, 6));
end;


//查找卡的类型名称

function Tfrm_Frontoperate_InitID.Display_ID_TYPE(StrIDtype: string): string;
begin
  if (StrIDtype = copy(INit_Wright.User, 8, 2)) then //卡功能，类型
    result := copy(INit_Wright.User, 1, 6)
  else if (StrIDtype = copy(INit_Wright.Produecer_3F, 8, 2)) then
    result := copy(INit_Wright.Produecer_3F, 1, 6)
  else if (StrIDtype = copy(INit_Wright.BOSS, 8, 2)) then
    result := copy(INit_Wright.BOSS, 1, 6)
  else if (StrIDtype = copy(INit_Wright.MANEGER, 8, 2)) then
    result := copy(INit_Wright.MANEGER, 1, 6)
  else if (StrIDtype = copy(INit_Wright.QUERY, 8, 2)) then
    result := copy(INit_Wright.QUERY, 1, 6)
  else if (StrIDtype = copy(INit_Wright.RECV_CASE, 8, 2)) then
    result := copy(INit_Wright.RECV_CASE, 1, 6)
  else if (StrIDtype = copy(INit_Wright.SETTING, 8, 2)) then
    result := copy(INit_Wright.SETTING, 1, 6)
  else if (StrIDtype = copy(INit_Wright.OPERN, 8, 2)) then
    result := copy(INit_Wright.OPERN, 1, 6);
end;

//查找卡的类型值

function Tfrm_Frontoperate_InitID.Display_ID_TYPE_Value(StrIDtype: string): string;
begin
  if (StrIDtype = copy(INit_Wright.User, 1, 6)) then //卡功能，类型   //用户卡
    result := copy(INit_Wright.User, 8, 2)
 // else if (StrIDtype = copy(INit_Wright.Produecer_3F, 1, 6)) then                                //万能卡
  //  result := copy(INit_Wright.Produecer_3F, 8, 2)
  else if (StrIDtype = copy(INit_Wright.BOSS, 1, 6)) then                                //老板卡
    result := copy(INit_Wright.BOSS, 8, 2)
  else if (StrIDtype = copy(INit_Wright.MANEGER, 1, 6)) then                     //管理卡
    result := copy(INit_Wright.MANEGER, 8, 2)
 // else if (StrIDtype = copy(INit_Wright.QUERY, 1, 6)) then               //查账卡
 //   result := copy(INit_Wright.QUERY, 8, 2)
  else if (StrIDtype = copy(INit_Wright.RECV_CASE, 1, 6)) then   //收银卡
    result := copy(INit_Wright.RECV_CASE, 8, 2)
 // else if (StrIDtype = copy(INit_Wright.SETTING, 1, 6)) then       //设置卡
 //   result := copy(INit_Wright.SETTING, 8, 2)
  else if (StrIDtype = copy(INit_Wright.OPERN, 1, 6)) then //开机卡
    result := copy(INit_Wright.OPERN, 8, 2);

end;


//更新卡信息

procedure Tfrm_Frontoperate_InitID.BitBtn_UpdateClick(Sender: TObject);
begin
  Operate_No := 2;
  ID_System := ICFunction.SUANFA_ID_3F(Edit_ID.Text); //调用计算ID_3F算法
  Password3F_System := ICFunction.SUANFA_Password_3F(Edit_ID.Text); //调用计算Password_3F算法
  INIT_Operation;
end;



//更新初始化数据

procedure Tfrm_Frontoperate_InitID.Save_INit_update;
var
  strOperator, strinputdatetime: string;
label ExitSub;
begin

  strOperator := G_User.UserNO;
  strinputdatetime := DateTimetostr((now())); //录入时间，读取系统时间
  INit_3F.ID_type := Display_ID_TYPE_Value(ComboBox_Menbertype.Text); //取得卡类型的值
  with ADOQuery_Init do
  begin
    if (Locate('ID_INIT', INit_3F.ID_INIT, [])) then begin
      Edit;
                  //Append;
      FieldByName('ID_INIT').AsString := INit_3F.ID_INIT;
      FieldByName('ID_3F').AsString := INit_3F.ID_3F;
      FieldByName('Password_3F').AsString := INit_3F.Password_3F;
      FieldByName('Password_USER').AsString := INit_3F.Password_USER;

      FieldByName('ID_value').AsString := INit_3F.ID_value;
      FieldByName('ID_type').AsString := INit_3F.ID_type;  //here
      FieldByName('ID_TypeName').AsString := ComboBox_Menbertype.text;//here

      FieldByName('ID_CheckNum').AsString := INit_3F.ID_CheckNum;
      FieldByName('cUserNo').AsString := INit_3F.cUserNo;
      FieldByName('Customer_Name').AsString := Customer_Phone.Text;
      FieldByName('Customer_NO').AsString := Customer_NO.Text;

      FieldByName('ID_Inittime').AsString := strinputdatetime;

      try
        Post;
      except
        on e: Exception do ShowMessage(e.Message);
      end;
    end;
  end;
  ExitSub:
  INit_3F.ID_INIT := '';
  INit_3F.ID_3F := '';
  INit_3F.Password_3F := '';
  INit_3F.Password_USER := '';
  INit_3F.ID_value := '';
  INit_3F.ID_type := '';
  INit_3F.ID_CheckNum := '';
  INit_3F.Customer_Name := '';
  INit_3F.Customer_NO := '';
  INit_3F.ID_Settime := '';
  Edit_ID.Text := '';
  Operate_No := 0;
  CheckBox_Update.Checked := FALSE;
end;


//选择此开关将关闭串口，目的是为了可以编辑文本框

procedure Tfrm_Frontoperate_InitID.CheckBox_UpdateClick(Sender: TObject);
begin
  if (not CheckBox_Update.Checked) then begin
    BitBtn_Update.Enabled := false;
  end
  else
  begin
    BitBtn_Update.Enabled := true;
  end;
end;



//根据当前卡ID查询对应用户的台账（包括所有过往记录）

function Tfrm_Frontoperate_InitID.Query_User_LastBuy(StrID: string; Query_Type: string): string;
var
  ADOQ: TADOQuery;
  strSQL, strRet: string;
begin
  strRet := '0';
  if Query_Type = '1' then //根据卡ID查询
    strSQL := 'select Max(ID_Inittime) from [3F_ID_INIT] where Customer_NO in (select distinct(Customer_NO)  from [3F_ID_INIT] where [ID_INIT]=''' + StrID + ''') '
  else if Query_Type = '2' then //根据客户编号查询
    strSQL := 'select COUNT(ID_Type) from [3F_ID_INIT] where Customer_NO in (select distinct(Customer_NO)  from [3F_ID_INIT] where [Customer_NO]=''' + StrID + ''') ';

  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Open;
    if (not eof) then
      strRet := ADOQ.Fields[0].AsString;
    Close;
  end;
  FreeAndNil(ADOQ);
  Result := strRet;
end;

procedure Tfrm_Frontoperate_InitID.BitBtn1Click(Sender: TObject);
begin
  Edit18.Text := ICFunction.SUANFA_Password_USER('5A7DDBD3', '312014');
end;

//初始化客户名称下拉框
procedure Tfrm_Frontoperate_InitID.InitCustomerName;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  nameStr: string;
  i: integer;
begin
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select Customer_Name from [3F_Customer_Infor]  order by ID ASC ';
  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    Customer_Phone.Items.Clear;
    while not Eof do
    begin
      Customer_Phone.Items.Add(FieldByName('Customer_Name').AsString);
      Next;
    end;
  end;
  FreeAndNil(ADOQTemp);
end;

procedure Tfrm_Frontoperate_InitID.Customer_PhoneClick(
  Sender: TObject);
begin
  if length(Trim(Customer_Phone.text)) = 0 then
  begin
    ShowMessage('机台游戏名称不能空');
    exit;
  end
  else
  begin
    InitCarMC_ID(Customer_Phone.text); //查询该客户对应的场地编号
  end;
end;

 //初始化客户场地编号

procedure Tfrm_Frontoperate_InitID.InitCarMC_ID(Str1: string);
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  strSET: string;
begin
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select distinct [Customer_NO] from [3F_Customer_Infor] where Customer_Name=''' + Str1 + '''';
  with ADOQTemp do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    CUSTOMER_NO.Items.Clear;
    while not Eof do begin
      CUSTOMER_NO.Items.Add(FieldByName('Customer_NO').AsString);
      Next;
    end;
  end;
  FreeAndNil(ADOQTemp);

end;

procedure Tfrm_Frontoperate_InitID.CUSTOMER_NOClick(Sender: TObject);
begin       

  if trim(CUSTOMER_NO.Text) = '' then //新增客户
  begin
    ShowMessage('请确认输入的客户编号是否正确！');
    exit;
  end;

  if Edit_ID.Text <> '' then
  begin
    ID_System := ICFunction.SUANFA_ID_3F(Edit_ID.Text);
    Password3F_System := ICFunction.SUANFA_Password_3F(Edit_ID.Text);
    ID_3F.Text := ICFunction.SUANFA_ID_3F(Edit_ID.Text);
    ID_Password_3F.Text := ICFunction.SUANFA_Password_3F(Edit_ID.Text);
    Query_SUM_Type(CUSTOMER_NO.Text, '2'); //根据客户编号，查找相关功能卡数量的信息
    ComboBox_Menbertype.setfocus;
  end
  else
  begin
    ShowMessage('请将卡或电子币放在卡头上方！');
    exit;
  end;
end;

//根据客户编号，查找相关功能卡数量的信息
procedure Tfrm_Frontoperate_InitID.Query_SUM_Type(StrID: string; Query_Type: string);
begin

  Edit2.Text := Customer_Phone.Text;
  Edit3.Text := CUSTOMER_NO.Text;
  Edit4.Text := Query_User_infor(StrID, Query_Type, copy(INit_Wright.Produecer_3F, 8, 2));
  Edit5.Text := Query_User_infor(StrID, Query_Type, copy(INit_Wright.BOSS, 8, 2));
  Edit6.Text := Query_User_infor(StrID, Query_Type, copy(INit_Wright.MANEGER, 8, 2));
  Edit7.Text := Query_User_infor(StrID, Query_Type, copy(INit_Wright.QUERY, 8, 2));
  Edit8.Text := Query_User_infor(StrID, Query_Type, copy(INit_Wright.RECV_CASE, 8, 2));
  Edit9.Text := Query_User_infor(StrID, Query_Type, copy(INit_Wright.SETTING, 8, 2));
  Edit10.Text := Query_User_infor(StrID, Query_Type, copy(INit_Wright.OPERN, 8, 2));
  Edit11.Text := Query_User_infor(StrID, Query_Type, copy(INit_Wright.User, 8, 2));
  Edit12.Text := IntToStr(StrToInt(Edit4.Text) + StrToInt(Edit5.Text) + StrToInt(Edit6.Text) + StrToInt(Edit7.Text) + StrToInt(Edit8.Text) + StrToInt(Edit9.Text) + StrToInt(Edit10.Text) + StrToInt(Edit11.Text));
  Edit13.Text := Query_User_LastBuy(StrID, Query_Type);
end;
//根据当前卡ID查询对应用户的台账（包括所有过往记录）

function Tfrm_Frontoperate_InitID.Query_User_infor(StrID: string; Query_Type: string; ID_Type_Input: string): string;
var
  ADOQ: TADOQuery;
  strSQL, strRet: string;
begin
  strRet := '0';
  if Query_Type = '1' then //根据卡ID查询
    strSQL := 'select COUNT(ID_Type) from [3F_ID_INIT] where Customer_NO in (select distinct(Customer_NO)  from [3F_ID_INIT] where [ID_INIT]=''' + StrID + ''') and ID_type=''' + ID_Type_Input + ''''
  else if Query_Type = '2' then //根据客户编号查询
    strSQL := 'select COUNT(ID_Type) from [3F_ID_INIT] where Customer_NO in (select distinct(Customer_NO)  from [3F_ID_INIT] where [Customer_NO]=''' + StrID + ''') and ID_type=''' + ID_Type_Input + '''';

  ICFunction.loginfo('Query_User_infor  '+ strSQL );

  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Open;
    if (not eof) then
      strRet := ADOQ.Fields[0].AsString;
    Close;
  end;
  FreeAndNil(ADOQ);
  Result := strRet;
end;

end.
