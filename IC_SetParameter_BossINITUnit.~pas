unit IC_SetParameter_BossINITUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, IniFiles,
  Dialogs, SPComm, DB, ADODB, Grids, DBGrids, StdCtrls, Buttons, ExtCtrls;

type
  Tfrm_SetParameter_BossINIT = class(TForm)
    Panel2: TPanel;
    GroupBox5: TGroupBox;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    Label3: TLabel;
    Label1: TLabel;
    Edit_PrintNO: TEdit;
    Edit_OPResult: TEdit;
    DataSource_BOSSInit: TDataSource;
    ADOQuery_BOSSInit: TADOQuery;
    comReader: TComm;
    Panel3: TPanel;
    CheckBox_Update: TCheckBox;
    Label7: TLabel;
    ID_CheckSum: TEdit;
    ID_Value: TEdit;
    Label10: TLabel;
    ComboBox_Menbertype: TComboBox;
    ID_Password_USER: TEdit;
    ID_Password_3F: TEdit;
    ID_3F: TEdit;
    Edit_ID: TEdit;
    CUSTOMER_NO: TEdit;
    Customer_Phone: TEdit;
    Label11: TLabel;
    Label12: TLabel;
    Label9: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    Panel5: TPanel;
    Panel6: TPanel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Edit13: TEdit;
    Edit12: TEdit;
    Edit11: TEdit;
    Panel7: TPanel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Edit4: TEdit;
    Edit3: TEdit;
    Edit2: TEdit;
    Panel8: TPanel;
    Label17: TLabel;
    Edit5: TEdit;
    Edit6: TEdit;
    Label18: TLabel;
    Label19: TLabel;
    Edit7: TEdit;
    Edit8: TEdit;
    Label20: TLabel;
    Label21: TLabel;
    Edit9: TEdit;
    Edit10: TEdit;
    Label22: TLabel;
    Panel4: TPanel;
    BitBtn18: TBitBtn;
    BitBtn12: TBitBtn;
    BitBtn_INIT: TBitBtn;
    Edit15: TEdit;
    Edit16: TEdit;
    Edit17: TEdit;
    Edit18: TEdit;
    Edit19: TEdit;
    Edit20: TEdit;
    Panel1: TPanel;
    Image1: TImage;
    Edit1: TEdit;
    Edit14: TEdit;
    BitBtn1: TBitBtn;
    procedure BitBtn18Click(Sender: TObject);
    procedure comReaderReceiveData(Sender: TObject; Buffer: Pointer;
      BufferLength: Word);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn_INITClick(Sender: TObject);
    procedure CUSTOMER_NOKeyPress(Sender: TObject; var Key: Char);
    procedure Customer_PhoneKeyPress(Sender: TObject; var Key: Char);
    procedure BitBtn12Click(Sender: TObject);
    procedure BitBtn_UpdateClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
    function exchData(orderStr: string): string;

    procedure IncvalueComfir(S: string; S1: string);
    procedure sendData();
    procedure InitDataBase;
    procedure CheckCMD();
    procedure INcrevalue(S: string); //充值函数
    function CheckSUMData(orderStr: string): string; //校验和
    function Select_IncValue_Byte(StrIncValue: string): string;
    function Select_CheckSum_Byte(StrCheckSum: string): string;
    function INit_Send_CMD(StrCMD: string; StrIncValue: string): string;
    function QueryCustomer_No(strphone: string): string;
    procedure INitIDType;
    procedure INIT_Operation;
    //保存初始化数据
    procedure Save_INit_Data;
      //ID卡身份识别
    function CHECK_3F_ID(StrCheckSum: string; ID_3F: string; Password_3F: string): boolean;
    function SUANFA_ID_3F(StrCheckSum: string): string;
    function SUANFA_Password_3F(StrCheckSum: string): string;
    function Display_ID_TYPE(StrIDtype: string): string;
    function Display_ID_TYPE_Value(StrIDtype: string): string;
    function Query_User_infor(StrID: string; Query_Type: string; ID_Type_Input: string): string;
    procedure Query_SUM_Type(StrID: string; Query_Type: string);
    function Query_User_LastBuy(StrID: string; Query_Type: string): string;

  end;

var
  frm_SetParameter_BossINIT: Tfrm_SetParameter_BossINIT;
  curOrderNo: integer = 0;
  curOperNo: integer = 0;
  Operate_No: integer = 0;
  INC_value: string;
  ID_System: string;
  Password3F_System: string;

  orderLst, recDataLst, recData_fromICLst: Tstrings;
  buffer: array[0..2048] of byte;
  INIT_Operation_OK: boolean;
implementation
uses ICDataModule, ICtest_Main, ICCommunalVarUnit, ICmain, ICEventTypeUnit, ICFunctionUnit;
{$R *.dfm}

procedure Tfrm_SetParameter_BossINIT.BitBtn18Click(Sender: TObject);
begin
  Close;
end;

procedure Tfrm_SetParameter_BossINIT.InitDataBase;
var
  strSQL: string;
begin
  with ADOQuery_BOSSInit do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select * from [USER_ID_INIT]';
    SQL.Add(strSQL);
    Active := True;
  end;
end;


//转找发送数据格式 ，将字符转换为16进制

function Tfrm_SetParameter_BossINIT.exchData(orderStr: string): string;
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

procedure Tfrm_SetParameter_BossINIT.sendData();
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

//校验和，确认是否正确

function Tfrm_SetParameter_BossINIT.CheckSUMData(orderStr: string): string;
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
//充值数据转换成16进制并排序 字节LL、字节LH、字节HL、字节HH

function Tfrm_SetParameter_BossINIT.Select_IncValue_Byte(StrIncValue: string): string;
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

function Tfrm_SetParameter_BossINIT.Select_CheckSum_Byte(StrCheckSum: string): string;
var
  jj: integer;
  tempLH, tempLL: integer; //2147483648 最大范围

begin
  jj := strToint('$' + StrCheckSum); //将字符转转换为16进制数，然后转换位10进制
  tempLH := (jj mod 65536) div 256; //字节LH
  tempLL := jj mod 256; //字节LL

  result := IntToHex(tempLL, 2) + IntToHex(tempLH, 2);
end;



procedure Tfrm_SetParameter_BossINIT.comReaderReceiveData(Sender: TObject;
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
  begin
    CheckCMD(); //首先根据接收到的数据进行判断，确认此卡是否属于为正确的卡
  end;
  
end;

//根据接收到的数据判断此卡是否为合法卡

procedure Tfrm_SetParameter_BossINIT.CheckCMD();
var
  i: integer;
  tmpStr: string;
  stationNoStr: string;
  tmpStr_Hex: string;
  tmpStr_Hex_length, IDtypetemp: string;
  Send_value: string;
  RevComd: integer;
  ID_No: string;
  length_Data: integer;
begin
   //首先截取接收的信息

  ComboBox_Menbertype.Items.Clear;
  INitIDType; //初始化 ComboBox_Menbertype
  IDtypetemp := 'A5';
  tmpStr := recData_fromICLst.Strings[0];
       //Edit1.Text:= recData_fromICLst.Strings[0];
  Receive_CMD_ID_Infor.ID_CheckNum := copy(tmpStr, 39, 4); //校验和

      // if (CheckSUMData(copy(tmpStr, 1, 38))=copy(tmpStr, 41, 2)+copy(tmpStr, 39, 2)) then//校验和
  begin
    CMD_CheckSum_OK := true;
    Receive_CMD_ID_Infor.CMD := copy(recData_fromICLst.Strings[0], 1, 2); //帧头43
  end;
                 //1、判断此卡是否为已经完成初始化
  if Receive_CMD_ID_Infor.CMD = CMD_COUMUNICATION.CMD_INCValue_RE then
  begin

                  // if  (Customer_Phone.Text<>'') and (CUSTOMER_NO.Text<>'') and (Edit_ID.Text<>'') then
    begin
      if (Operate_No = 1) then //保存当前卡的初始化记录
      begin
        //保存记录
        Save_INit_Data;
        Edit_OPResult.Text := '初始化操作、保存成功';
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

    ICFunction.loginfo('场地初始化 Receive_CMD_ID_Infor.ID_INIT '+ Receive_CMD_ID_Infor.ID_INIT );
    ICFunction.loginfo('场地初始化 Receive_CMD_ID_Infor.ID_3F '+ Receive_CMD_ID_Infor.ID_3F );
    ICFunction.loginfo('场地初始化 Receive_CMD_ID_Infor.Password_3F '+ Receive_CMD_ID_Infor.Password_3F );
    ICFunction.loginfo('场地初始化 Receive_CMD_ID_Infor.Password_USER '+ Receive_CMD_ID_Infor.Password_USER );
    ICFunction.loginfo('场地初始化 Receive_CMD_ID_Infor.ID_value '+ Receive_CMD_ID_Infor.ID_value );
    ICFunction.loginfo('场地初始化 Receive_CMD_ID_Infor.ID_type '+ Receive_CMD_ID_Infor.ID_type );
   
    begin    
      if Receive_CMD_ID_Infor.Password_USER = INit_Wright.BossPassword_old then
      begin
        Edit_ID.Text := Receive_CMD_ID_Infor.ID_INIT; //卡ID
        Operate_No := 1;
        INIT_Operation; //调用写入ID函数
        Edit14.Text := '此卡合法，已完成场地初始化！'; //卡ID
      end

                       //首先与3F初始化的场地密码比较
                       //20120923修改判断条件，改为直接与3F出厂设定的场地密码比较
                       //if ICFunction.CHECK_Customer_ID_3FINIT(Receive_CMD_ID_Infor.ID_INIT,Receive_CMD_ID_Infor.Password_USER) then
      else if Receive_CMD_ID_Infor.Password_USER = INit_Wright.BossPassword_3F then
      begin
        Edit_ID.Text := Receive_CMD_ID_Infor.ID_INIT; //卡ID
        Operate_No := 1;
        INIT_Operation; //调用写入ID函数
        Edit14.Text := '此卡合法，已经完成出厂初始化！'; //卡ID
      end

      else if Receive_CMD_ID_Infor.Password_USER = INit_Wright.BossPassword then
      begin
        Edit_ID.Text := Receive_CMD_ID_Infor.ID_INIT; //卡ID
        Edit14.Text := '此卡合法，已经完成场地初始化！'; //卡ID
      end
      else if Receive_CMD_ID_Infor.ID_type = IDtypetemp then
      begin
        Edit_ID.Text := Receive_CMD_ID_Infor.ID_INIT; //卡ID
        Operate_No := 1;
        INIT_Operation; //调用写入ID函数
        Edit14.Text := '此卡合法，已经完成出厂初始化！'; //卡ID
      end
      else
      begin
        Edit14.Text := '此卡非法，不是本系统配套卡！'; //卡ID

        exit;
      end;

    end;
              // else //卡认证为非法卡
    begin
                  //        Edit14.Text:= '此卡非法，请通知您的老板！'; //卡ID
                  //        exit;
    end;

  end;

end;


//初始化操作

procedure Tfrm_SetParameter_BossINIT.INIT_Operation;
var
  INC_value: string;
  strValue: string;
begin
  begin
    INC_value := Receive_CMD_ID_Infor.ID_value; //充值数值
    //add by linlf场地初始化时，电子币的值初始化为0
    INC_value := '00000000'; //充值数值
    //showmessage(INC_VALUE);
    strValue := INit_Send_CMD(CMD_COUMUNICATION.CMD_INCValue, INC_value); //计算充值指令
    INcrevalue(strValue); //写入ID卡
  end;
end;


//初始化卡计算指令

function Tfrm_SetParameter_BossINIT.INit_Send_CMD(StrCMD: string; StrIncValue: string): string;
var
  TmpStr_IncValue: string; //充值数字
  TmpStr_CheckSum: string; //校验和
  TmpStr_SendCMD: string; //指令内容
  TmpStr_Password_User: string; //指令内容
  reTmpStr: string;
  myIni: TiniFile;
begin

  INit_3F.CMD := StrCMD; //帧命令
  INit_3F.ID_INIT := Edit_ID.Text;

  INit_3F.ID_3F := Receive_CMD_ID_Infor.ID_3F;
  INit_3F.Password_3F := Receive_CMD_ID_Infor.Password_3F;

                              //将读取的文档中的场地密码
  if FileExists(SystemWorkGroundFile) then
  begin
    myIni := TIniFile.Create(SystemWorkGroundFile);
    INit_Wright.BossPassword := MyIni.ReadString('PLC工作区域', 'PC托盘特征码', 'D6077');
    FreeAndNil(myIni);
  end;
   //20120923修改，屏蔽用户密码的算法，改为直接读取配置文件中的用户密码
   // TmpStr_Password_User:=ICFunction.SUANFA_Password_USER_WritetoID(Edit_ID.Text,INit_Wright.BossPassword);
   // INit_3F.Password_USER:=TmpStr_Password_User; //用户密码
  TmpStr_Password_User := INit_Wright.BossPassword; //用户密码
  INit_3F.Password_USER := INit_Wright.BossPassword; //用户密码


  INit_3F.ID_value := StrIncValue;
  INit_3F.ID_type := Receive_CMD_ID_Infor.ID_type; //取得卡类型的值


    //汇总发送内容
  TmpStr_SendCMD := INit_3F.CMD + INit_3F.ID_INIT + INit_3F.ID_3F + INit_3F.Password_3F + INit_3F.Password_USER + INit_3F.ID_value + INit_3F.ID_type;

    //将发送内容进行校核计算
  TmpStr_CheckSum := CheckSUMData(TmpStr_SendCMD);
    //TmpStr_CheckSum字节需要重新排布 ，低字节在前，高字节在后
  INit_3F.ID_CheckNum := Select_CheckSum_Byte(TmpStr_CheckSum);


  ID_3F.Text := INit_3F.ID_3F;
  ID_Password_3F.Text := INit_3F.Password_3F;
  ID_Password_3F.Text := INit_3F.Password_USER;
  ID_CheckSum.Text := INit_3F.ID_CheckNum;
  ID_Value.Text := INit_3F.ID_value; //数据

  reTmpStr := TmpStr_SendCMD + INit_3F.ID_CheckNum;

  result := reTmpStr;
end;


//写入ID卡----------------------------------------

procedure Tfrm_SetParameter_BossINIT.INcrevalue(S: string);
begin
  orderLst.Clear();
  recDataLst.Clear();
  curOrderNo := 0;
  curOperNo := 2;
    //Edit1.Text:=s;
  Edit1.Text := '111111111111111111111111111111111111111';
  orderLst.Add(S); //将币值写入币种
  sendData();
end;


//保存初始化数据

procedure Tfrm_SetParameter_BossINIT.Save_INit_Data;
var
  strOperator, strinputdatetime: string;
label ExitSub;
begin

  strOperator := G_User.UserNO;
  strinputdatetime := DateTimetostr((now())); //录入时间，读取系统时间


  with ADOQuery_BOSSInit do begin
    if (Locate('ID_INIT', INit_3F.ID_INIT, [])) then
    begin
                //  if(MessageDlg('ID号  '+INit_3F.ID_INIT+'  的卡初始化信息已经存在，要更新吗？',mtInformation,[mbYes,mbNo],0)=mrYes) then
      Edit;
      Edit14.Text := '场地初始化成功，请勿重复操作';
                //  else
                //       goto ExitSub;
    end
    else
      Append;
    Edit14.Text := '';
                 // FieldByName('MemCardNo').AsString :=Send_CMD_ID_Infor.CMD;
    FieldByName('ID_INIT').AsString := INit_3F.ID_INIT;
                  //FieldByName('ID_3F').AsString :=INit_3F.ID_3F;
                  //FieldByName('Password_3F').AsString :=INit_3F.Password_3F;
                  //FieldByName('Password_USER').AsString :=INit_3F.Password_USER;

                  //FieldByName('ID_value').AsString :=INit_3F.ID_value;
                  //FieldByName('ID_type').AsString :=INit_3F.ID_type;
                  //FieldByName('ID_TypeName').AsString :=Display_ID_TYPE(INit_3F.ID_type);
                  //FieldByName('ID_CheckNum').AsString :=INit_3F.ID_CheckNum;

                  //FieldByName('Customer_Name').AsString :=Customer_Phone.Text;
                  //FieldByName('Customer_NO').AsString :=Customer_NO.Text;

    FieldByName('cUserNo').AsString := LOAD_USER.ID_INIT;
                  //FieldByName('ID_CheckNum').AsString :=IntToHex(strToint('$'+Copy(LOAD_USER.ID_INIT,1,3))*strToint('$'+Copy(INit_3F.ID_INIT,3,4)),2)+IntToHex(strToint('$'+Copy(LOAD_USER.ID_INIT,3,2))*strToint('$'+Copy(INit_3F.ID_INIT,3,2)),2)+INit_3F.Customer_NO+IntToHex(strToint('$'+Copy(INit_3F.ID_3F,1,4))*strToint('$'+Copy(INit_3F.ID_INIT,1,3)),2)+INit_3F.Customer_NO+INit_3F.ID_INIT+INit_3F.ID_3F+INit_3F.Password_3F+IntToHex(strToint('$'+Copy(INit_3F.ID_3F,1,3))*strToint('$'+Copy(INit_3F.ID_INIT,2,3)),2);
                 //FieldByName('ID_Inittime').AsString :=strinputdatetime;
    FieldByName('ID_Inittime').AsString := FormatDateTime('yyyy-MM-dd HH:mm:ss', now);

                 // FieldByName('OpenCardDT').AsString :=strinputdatetime;
                 // FieldByName('EffectiveDT').AsString := copy(strinputdatetime,1,2)+IntToStr(StrToInt(copy(strinputdatetime,3,2))+10)+copy(strinputdatetime,5,length(strinputdatetime)-4);
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



procedure Tfrm_SetParameter_BossINIT.FormShow(Sender: TObject);
var
  myIni: TiniFile;
begin
  comReader.StartComm();
  orderLst := TStringList.Create;
  recDataLst := tStringList.Create;
  recData_fromICLst := tStringList.Create;
  INitIDType;
  if FileExists(SystemWorkGroundFile) then
  begin
    myIni := TIniFile.Create(SystemWorkGroundFile);
    INit_Wright.BossPassword_old := MyIni.ReadString('PLC工作区域', 'PC读出特征码', '旧密码');
    INit_Wright.BossPassword := MyIni.ReadString('PLC工作区域', 'PC托盘特征码', '新密码'); //读取更新后的密码
    FreeAndNil(myIni);
  end;

  if LOAD_USER.ID_type = Copy(INit_Wright.Produecer_3F, 8, 2) then //老板卡可以见到此操作按钮
  begin
    GroupBox1.Visible := true;
    GroupBox2.Visible := true;
    Panel7.Visible := true;
  end
  else if LOAD_USER.ID_type = Copy(INit_Wright.BOSS, 8, 2) then
  begin
    GroupBox1.Visible := false;
    GroupBox2.Visible := true;
    Panel7.Visible := false;
  end
  else
  begin
    GroupBox1.Visible := false;
    GroupBox2.Visible := false;
  end;


end;



procedure Tfrm_SetParameter_BossINIT.FormClose(Sender: TObject; var Action: TCloseAction);
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
 //未使用
procedure Tfrm_SetParameter_BossINIT.IncvalueComfir(S: string; S1: string);

var
  strIDNo, strName, strUserNo, strIncvalue, strGivecore, strOperator, strhavemoney, strinputdatetime: string;
  i: integer;
label ExitSub;
begin

  strIDNo := Edit_ID.Text;
  strOperator := G_User.UserNO; //操作员
  strinputdatetime := DateTimetostr((now())); //录入时间，读取系统时间

  with ADOQuery_BOSSInit do begin
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




procedure Tfrm_SetParameter_BossINIT.FormCreate(Sender: TObject);
begin

  EventObj := EventUnitObj.Create;
  EventObj.LoadEventIni;
  InitDataBase; //显示出型号
end;

procedure Tfrm_SetParameter_BossINIT.BitBtn_INITClick(Sender: TObject);
begin
  Operate_No := 1;
  INIT_Operation;

end;


procedure Tfrm_SetParameter_BossINIT.CUSTOMER_NOKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (key in ['0'..'9', #8, #13]) then
  begin
    key := #0;
    ShowMessage('输入错误，只能输入数字和字符！');
  end
  else if key = #13 then
  begin
    if Edit_ID.Text <> '' then
    begin
      ID_System := ICFunction.SUANFA_ID_3F(Edit_ID.Text);
      Password3F_System := ICFunction.SUANFA_Password_3F(Edit_ID.Text);
      ComboBox_Menbertype.setfocus;
    end
    else
    begin
      ShowMessage('输入错误，只能输入数字和字符！');
      exit;
    end;
  end;
     //Query_SUM_Type(CUSTOMER_NO.Text,'2');

end;

procedure Tfrm_SetParameter_BossINIT.Customer_PhoneKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (key in ['0'..'9', #8, #13]) then
  begin
    key := #0;
    ShowMessage('输入错误，只能输入数字和字符！');
  end
  else if key = #13 then
  begin
    if length(Customer_Phone.Text) = 11 then
    begin
             //检索数据库中是否有与此电话号码匹配的用户，有则查询其对应的客户编号
      CUSTOMER_NO.Text := QueryCustomer_No(Customer_Phone.Text);
      if trim(CUSTOMER_NO.Text) = '' then
      begin
        CUSTOMER_NO.Text := Copy(Customer_Phone.Text, 6, 6); //截取手机号的后6位为客户编号
        CUSTOMER_NO.setfocus;
      end
      else
      begin
        ID_3F.Text := ICFunction.SUANFA_ID_3F(Edit_ID.Text);
        ID_Password_3F.Text := ICFunction.SUANFA_Password_3F(Edit_ID.Text);
        ComboBox_Menbertype.setfocus;
      end;
    end;
  end;

end;

//查找客户编号

function Tfrm_SetParameter_BossINIT.QueryCustomer_No(strphone: string): string;
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

procedure Tfrm_SetParameter_BossINIT.BitBtn12Click(Sender: TObject);
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

function Tfrm_SetParameter_BossINIT.CHECK_3F_ID(StrCheckSum: string; ID_3F: string; Password_3F: string): boolean;
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
  ID_3F_1 := copy(ID_3F, 3, 2);
  ID_3F_2 := copy(Password_3F, 3, 2);
  ID_3F_3 := copy(Password_3F, 1, 2);

  PWD_3F_1 := copy(Password_3F, 5, 2);
  PWD_3F_2 := copy(ID_3F, 5, 2);
  PWD_3F_3 := copy(ID_3F, 1, 2);


    //卡厂ID
  tempTOTAL1 := strToint('$' + Copy(StrCheckSum, 1, 2)) + strToint('$' + Copy(StrCheckSum, 3, 2)) + strToint('$' + Copy(StrCheckSum, 5, 2)) * strToint('$' + Copy(StrCheckSum, 7, 2));
    //Edit15.Text:=IntToStr(tempTOTAL1);

  Byte1 := (tempTOTAL1 * tempTOTAL1) mod 16;
  Byte2 := (tempTOTAL1 * tempTOTAL1) div 16;
  Byte3 := tempTOTAL1;


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
  if (PWD_3F_1 <> copy(IntToHex(Byte4, 2), length(IntToHex(Byte4, 2)) - 2, 2)) then
    Result := false; //第一字节
  if (PWD_3F_2 <> copy(IntToHex(Byte5, 2), length(IntToHex(Byte5, 2)) - 2, 2)) then
    Result := false; //第二字节
  if (PWD_3F_3 <> copy(IntToHex(Byte6, 2), length(IntToHex(Byte6, 2)) - 2, 2)) then
    Result := false; //第三字节

end;



//卡厂ID算法

function Tfrm_SetParameter_BossINIT.SUANFA_ID_3F(StrCheckSum: string): string;
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

function Tfrm_SetParameter_BossINIT.SUANFA_Password_3F(StrCheckSum: string): string;
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

                                         //初始化卡计算指令

procedure Tfrm_SetParameter_BossINIT.INitIDType;
begin
  ComboBox_Menbertype.Items.Add(copy(INit_Wright.User, 1, 6));
  ComboBox_Menbertype.Items.Add(copy(INit_Wright.Produecer_3F, 1, 6));
  ComboBox_Menbertype.Items.Add(copy(INit_Wright.BOSS, 1, 6));
  ComboBox_Menbertype.Items.Add(copy(INit_Wright.MANEGER, 1, 6));
  ComboBox_Menbertype.Items.Add(copy(INit_Wright.QUERY, 1, 6));
  ComboBox_Menbertype.Items.Add(copy(INit_Wright.RECV_CASE, 1, 6));
  ComboBox_Menbertype.Items.Add(copy(INit_Wright.SETTING, 1, 6));
  ComboBox_Menbertype.Items.Add(copy(INit_Wright.OPERN, 1, 6));
end;


//查找卡的类型名称

function Tfrm_SetParameter_BossINIT.Display_ID_TYPE(StrIDtype: string): string;
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

function Tfrm_SetParameter_BossINIT.Display_ID_TYPE_Value(StrIDtype: string): string;
begin
  if (StrIDtype = copy(INit_Wright.User, 1, 6)) then //卡功能，类型
    result := copy(INit_Wright.User, 8, 2)
  else if (StrIDtype = copy(INit_Wright.Produecer_3F, 1, 6)) then
    result := copy(INit_Wright.Produecer_3F, 8, 2)
  else if (StrIDtype = copy(INit_Wright.BOSS, 1, 6)) then
    result := copy(INit_Wright.BOSS, 8, 2)
  else if (StrIDtype = copy(INit_Wright.MANEGER, 1, 6)) then
    result := copy(INit_Wright.MANEGER, 8, 2)
  else if (StrIDtype = copy(INit_Wright.QUERY, 1, 6)) then
    result := copy(INit_Wright.QUERY, 8, 2)
  else if (StrIDtype = copy(INit_Wright.RECV_CASE, 1, 6)) then
    result := copy(INit_Wright.RECV_CASE, 8, 2)
  else if (StrIDtype = copy(INit_Wright.SETTING, 1, 6)) then
    result := copy(INit_Wright.SETTING, 8, 2)
  else if (StrIDtype = copy(INit_Wright.OPERN, 1, 6)) then
    result := copy(INit_Wright.OPERN, 8, 2);

end;


//更新卡信息

procedure Tfrm_SetParameter_BossINIT.BitBtn_UpdateClick(Sender: TObject);
begin
  Operate_No := 2;
  ID_System := ICFunction.SUANFA_ID_3F(Edit_ID.Text); //调用计算ID_3F算法
  Password3F_System := ICFunction.SUANFA_Password_3F(Edit_ID.Text); //调用计算Password_3F算法
  INIT_Operation;


end;

procedure Tfrm_SetParameter_BossINIT.Query_SUM_Type(StrID: string; Query_Type: string);
begin
  if (LOAD_USER.ID_type = Copy(INit_Wright.BOSS, 8, 2)) or (LOAD_USER.ID_type = Copy(INit_Wright.Produecer_3F, 8, 2)) then //老板卡可以见到此操作按钮
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
    Edit13.Text := Query_User_LastBuy(StrID, Query_Type); //最后一次初始化时间
  end
  else if LOAD_USER.ID_type = Copy(INit_Wright.MANEGER, 8, 2) then //3F卡可以见到此操作按钮
  begin
    Edit11.Text := Query_User_infor(StrID, Query_Type, copy(INit_Wright.User, 8, 2));
    Edit12.Text := IntToStr(StrToInt(Edit11.Text));
    Edit13.Text := Query_User_LastBuy(StrID, Query_Type); //最后一次初始化时间
  end;


end;
//根据当前卡ID查询对应用户的台账（包括所有过往记录）

function Tfrm_SetParameter_BossINIT.Query_User_infor(StrID: string; Query_Type: string; ID_Type_Input: string): string;
var
  ADOQ: TADOQuery;
  strSQL, strRet: string;
begin
  strRet := '0';
  if Query_Type = '1' then //根据卡ID查询
    strSQL := 'select COUNT(ID_Type) from [USER_ID_INIT] where Customer_NO in (select distinct(Customer_NO)  from [3F_ID_INIT] where [ID_INIT]=''' + StrID + ''') and ID_type=''' + ID_Type_Input + ''''
  else if Query_Type = '2' then //根据客户编号查询
    strSQL := 'select COUNT(ID_Type) from [USER_ID_INIT] where Customer_NO in (select distinct(Customer_NO)  from [3F_ID_INIT] where [Customer_NO]=''' + StrID + ''') and ID_type=''' + ID_Type_Input + '''';

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


//根据当前卡ID查询对应用户的台账（包括所有过往记录）

function Tfrm_SetParameter_BossINIT.Query_User_LastBuy(StrID: string; Query_Type: string): string;
var
  ADOQ: TADOQuery;
  strSQL, strRet: string;
begin
  strRet := '0';
  if Query_Type = '1' then //根据卡ID查询
    strSQL := 'select Max(ID_Inittime) from [USER_ID_INIT] where Customer_NO in (select distinct(Customer_NO)  from [3F_ID_INIT] where [ID_INIT]=''' + StrID + ''') '
  else if Query_Type = '2' then //根据客户编号查询
    strSQL := 'select COUNT(ID_Type) from [USER_ID_INIT] where Customer_NO in (select distinct(Customer_NO)  from [3F_ID_INIT] where [Customer_NO]=''' + StrID + ''') ';

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



procedure Tfrm_SetParameter_BossINIT.BitBtn1Click(Sender: TObject);
begin
  //WriteCustomerNameToIniFile;
end;


end.
