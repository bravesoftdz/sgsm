unit Frontoperate_incvalueUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, DB, ADODB, ExtCtrls, StdCtrls, Buttons, SPComm, DateUtils;

type
  Tfrm_Frontoperate_incvalue = class(TForm)
    Panel1: TPanel;
    DataSource_Incvalue: TDataSource;
    ADOQuery_Incvalue: TADOQuery;
    DBGrid2: TDBGrid;
    Panel2: TPanel;
    ADOQuery_newmenber: TADOQuery;
    DataSource_Newmenber: TDataSource;
    comReader: TComm;
    Panel3: TPanel;
    Panel4: TPanel;
    GroupBox5: TGroupBox;
    Label3: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Edit_ID: TEdit;
    Edit_PrintNO: TEdit;
    Edit_SaveMoney: TEdit;
    Edit_Prepassword: TEdit; //存储来自DB层返回的密码
    Comb_menberlevel: TComboBox;
    Edit_Mobile: TEdit;
    rgSexOrg: TRadioGroup;
    GroupBox4: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Edit_Givecore: TEdit;
    Edit_Incvalue: TEdit;
    Edit_Totalvale: TEdit;
    Edit_Pwdcomfir: TEdit;
    Bitn_Close: TBitBtn;
    Image1: TImage;
    Bitn_IncvalueComfir: TBitBtn;
    Label20: TLabel;
    Panel_Message: TPanel;
    Edit_TotalbuyValue: TEdit;
    Label5: TLabel;
    Label10: TLabel;
    Edit_TotalChangeValue: TEdit;
    Label16: TLabel;
    Label17: TLabel;
    CheckBox_Update: TCheckBox;
    Panel_infor: TPanel;
    Edit_Old_Value: TEdit;
    Labnumber: TLabel;
    edit_number: TEdit;
    Label18: TLabel;
    Label19: TLabel;
    Label21: TLabel;
    Edit_money: TEdit;
    Lab_money: TLabel;

    procedure FormCreate(Sender: TObject);
    procedure comReaderReceiveData(Sender: TObject; Buffer: Pointer;
      BufferLength: Word);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Bitn_CloseClick(Sender: TObject);
    procedure Bit_ValuecomfirClick(Sender: TObject);
    procedure Bitn_IncvalueComfirClick(Sender: TObject);
    procedure Edit_IncvalueKeyPress(Sender: TObject; var Key: Char);
    procedure Edit_PwdcomfirKeyPress(Sender: TObject; var Key: Char);
    procedure CheckBox_UpdateClick(Sender: TObject);
  private
    { Private declarations }
    function exchData(orderStr: string): string;
    procedure sendData();
    procedure checkOper();
    procedure InitDataBase;
    procedure Getmenberinfo(S: string);
    procedure GetmenberGivecore(S: string);
    procedure Update_LastRecord(S: string);
    procedure CheckCMD();
    procedure Query_MenberInfor(StrID: string);

    procedure Query_MenberLevInfor(StrLevNum: string);
    function Query_Menber_INIT_OK(StrID: string): boolean;
    procedure Query_INCValueInfor(StrID: string); //总充值值
    procedure Query_ChangeValueInfor(StrID: string); //总兑换值
    procedure ClearText;
    procedure Save_INCValue_Data; //保存充值记录
    procedure INIT_Operation; //充值操作，写数据个卡
    procedure GetInvalidDate;
    function Select_IncValue_Byte(StrIncValue: string): string;
    function Select_CheckSum_Byte(StrCheckSum: string): string;
    function CheckSUMData(orderStr: string): string;

    function Make_Send_CMD(StrCMD: string; StrIncValue: string): string;
    procedure INcrevalue(S: string);
    procedure Update_LastRecord_UserCard(S: string); //更新最新记录标志
    procedure Update_LastRecord_Value(S: string); //更新充值额
    function Query_LastRecord(S: string): boolean;
    function Query_idusercard_valid(S: string): boolean;
    function checkMemberUserAndPassowrd: boolean;

    procedure prc_user_card_operation();
  public
    { Public declarations }

  end;

var
  frm_Frontoperate_incvalue: Tfrm_Frontoperate_incvalue;
  curOrderNo: integer = 0;
  curOperNo: integer = 0;
  Operate_No: integer = 0;   //什么作用?
  orderLst, recDataLst: Tstrings;
  ID_UserCard_Text: string;
  IncValue_Enable: boolean;
  buffer: array[0..2048] of byte;

implementation
uses ICDataModule, ICtest_Main, ICCommunalVarUnit, ICmain, ICEventTypeUnit, ICFunctionUnit,dateProcess;
{$R *.dfm}


//数据展示
procedure Tfrm_Frontoperate_incvalue.InitDataBase;
var
  strSQL: string;
begin
  with ADOQuery_newmenber do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select * from [TMemberInfo]';
    SQL.Add(strSQL);
    Active := True;
  end;
  with ADOQuery_Incvalue do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;

    strSQL := 'select top 5 * from [TMembeDetail] order by GetTime desc';

    
    SQL.Add(strSQL);
    Active := True;
  end;
end;


//转找发送数据格式 
function Tfrm_Frontoperate_incvalue.exchData(orderStr: string): string;
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

procedure Tfrm_Frontoperate_incvalue.sendData();
var
  orderStr: string;
begin
  if orderLst.Count > curOrderNo then
  begin
    orderStr := orderLst.Strings[curOrderNo];
    orderStr := exchData(orderStr);
    comReader.WriteCommData(pchar(orderStr), length(orderStr)); //真正写到卡头
    inc(curOrderNo);
  end;
end;

//检查返回的数据

procedure Tfrm_Frontoperate_incvalue.checkOper();
var
  i: integer;
begin
  case curOperNo of
    2: begin //反馈卡余额总值操作
        for i := 0 to recDataLst.Count - 1 do
          if copy(recDataLst.Strings[i], 9, 2) <> '01' then // 写操作成功返回命令
          begin
                       // recDataLst.Clear;
            exit;
          end;
      end;
  end;
end;

procedure Tfrm_Frontoperate_incvalue.FormCreate(Sender: TObject);
begin
  EventObj := EventUnitObj.Create;
  EventObj.LoadEventIni;

end;

//串口接受处理数据
procedure Tfrm_Frontoperate_incvalue.comReaderReceiveData(Sender: TObject;
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

  recDataLst.Clear;
  recDataLst.Add(recStr);

  CheckCMD(); //首先根据接收到的数据进行判断，确认此卡是否属于为正确的卡


end;

//根据接收到的数据判断此卡是否为合法卡

procedure Tfrm_Frontoperate_incvalue.CheckCMD();
var
  tmpStr: string;
  tmpStr_Hex_length: string;
  Send_value: string;
  RevComd: integer;
  ID_No: string;
  length_Data: integer;
begin
  tmpStr := recDataLst.Strings[0];
  Receive_CMD_ID_Infor.CMD := copy(recDataLst.Strings[0], 1, 2); //帧头43

  if Receive_CMD_ID_Infor.CMD = CMD_COUMUNICATION.CMD_INCValue_RE then //收到卡头写入电子币充值成功的返回 53
  begin  
      if (Operate_No = 1) then //保存当前卡的初始化记录
      begin
      if Receive_CMD_ID_Infor.ID_type = copy(INit_Wright.User, 8, 2) then
       begin
        Save_INCValue_Data; //保存充值记录
      end;
        Panel_Message.Caption := '充值操作、保存充值记录成功';
        InitDataBase;
      end;

  end
  else if Receive_CMD_ID_Infor.CMD = CMD_COUMUNICATION.CMD_READ then
  begin
    ICFunction.loginfo('start checkcmd card ');
    Receive_CMD_ID_Infor.ID_INIT := copy(recDataLst.Strings[0], 3, 8); //卡片ID
    Receive_CMD_ID_Infor.ID_3F := copy(recDataLst.Strings[0], 11, 6); //卡厂ID
    Receive_CMD_ID_Infor.Password_3F := copy(recDataLst.Strings[0], 17, 6); //卡密
    Receive_CMD_ID_Infor.Password_USER := copy(recDataLst.Strings[0], 23, 6); //用户密码
    Receive_CMD_ID_Infor.ID_value := copy(recDataLst.Strings[0], 29, 8); //卡内数据
    Receive_CMD_ID_Infor.ID_type := copy(recDataLst.Strings[0], 37, 2); //卡功能

    ICFunction.loginfo('Receive_CMD_ID_Infor.ID_type: ' + Receive_CMD_ID_Infor.ID_type);
    ICFunction.loginfo('Receive_CMD_ID_Infor.Password_USER: ' + Receive_CMD_ID_Infor.Password_USER);
    ICFunction.loginfo('INit_Wright.BossPassword: ' + INit_Wright.BossPassword);

        if DataModule_3F.Query_User_INIT_OK(Receive_CMD_ID_Infor.ID_INIT)=false then //有记录
        begin
            ClearText;
            Panel_Message.Caption := '在此系统无记录，请确认是否已经完成场地初始化！'; //卡ID
            exit;                                       
        end;
         //会员卡
        if Receive_CMD_ID_Infor.ID_type = copy(INit_Wright.RECV_CASE, 8, 2) then //查找会员数据表中是否有记录
        begin
              if Query_Menber_INIT_OK(Receive_CMD_ID_Infor.ID_INIT) then
              begin
                Query_MenberInfor(Receive_CMD_ID_Infor.ID_INIT); //生成印刷卡号
                Edit_Incvalue.Enabled := true;
                Edit_Incvalue.SetFocus;
                Panel_Message.Caption := '此会员卡合法，请将电子币安放于充值卡头上方！'; //卡ID
                Edit_ID.Text := Receive_CMD_ID_Infor.ID_INIT;
              end 
            else
              begin
                ClearText;
                Panel_Message.Caption := '无此会员信息！'; //卡ID 
              end;
        end;
           //用户卡
        if Receive_CMD_ID_Infor.ID_type = copy(INit_Wright.User, 8, 2) then
        begin
              ICFunction.loginfo('start prc_user_card_operation ');
              prc_user_card_operation;
        end;

        //开机卡
        if Receive_CMD_ID_Infor.ID_type = copy(INit_Wright.OPERN, 8, 2) then
        begin
          if IncValue_Enable then
            begin
              Panel_Message.Caption := '此用户币合法（开机卡），请继续操作！'; //卡ID
            end
            else
            begin
              Panel_Message.Caption := '请刷会员卡，然后再将电子币安放于充值卡头上方！'; //卡ID
            end;
        end;


  end


end;



//用户卡操作
procedure Tfrm_Frontoperate_incvalue.prc_user_card_operation();
begin
  if true then
           begin

              if (CheckBox_Update.Checked) then
              begin

                if (Edit_Incvalue.Text = '') then
                begin
                  Panel_Message.Caption := '请输入连续充值额，只能输入数字！';
                  exit;
                end
                else
                begin
                  Operate_No := 1;
                  if checkMemberUserAndPassowrd then
                    INIT_Operation //调用连续充值写入ID函数
                   else
                      begin
                        Panel_Message.Caption := '请输入正确密码！';
                        exit;
                      end;
                end;

              end;
              Panel_Message.Caption := '此用户币合法，请继续操作！'; //卡ID
              ID_UserCard_Text := Receive_CMD_ID_Infor.ID_INIT; //用户币ID
              Edit_Old_Value.Text := ICFunction.Select_ChangeHEX_DECIncValue(Receive_CMD_ID_Infor.ID_value);

            end  //IncValue_Enable
          else
            begin
             Panel_Message.Caption := '请刷会员卡，然后再将电子币安放于充值卡头上方！'; //卡ID
            end;//end IncValue_Enable

end;//end prc_user_card_operation


//保存初始化数据
//写充值记录
procedure Tfrm_Frontoperate_incvalue.Save_INCValue_Data;
var
  strIDNo, strName, strUserNo, strIncvalue, strGivecore, strOperator, strhavemoney, strinputdatetime, strexpiretime,strsql: string;
  i: integer;
label ExitSub;
begin
  //如果用户币上的值不为0，则只是刷新此币的币值和充值时间

  if Edit_Old_Value.Text <> '0' then
  begin
      //1查询当前币在充值表中是否有最新的充值记录，即
    if Query_LastRecord(ID_UserCard_Text) and query_idusercard_valid(ID_UserCard_Text)  then
    begin
      Update_LastRecord_Value(ID_UserCard_Text); //ID_UserCard_Text为电子币ID，根据此更新电子币充值记录
      exit;
      
    end
  
  end;

  strUserNo := Edit_PrintNO.Text; //用户编号

 //1、更新记录，将该用户过往充值记录设定最新记录标志位设为‘0’
  //Update_LastRecord(strUserNo);
   //1、更新记录，将该用户币过往充值记录设定最新记录标志位设为‘0’
  Update_LastRecord_UserCard(ID_UserCard_Text); //ID_UserCard_Text为电子币ID，根据此更新电子币充值记录


  strIncvalue := Edit_Incvalue.Text; //充值
  strGivecore := Edit_Givecore.Text; //送分值
  strOperator := G_User.UserNO; //操作员
  //strhavemoney:=Edit_Totalvale.Text;     //账户余额
  strhavemoney := Edit_Incvalue.Text; //账户余额

  strinputdatetime := FormatDateTime('yyyy-MM-dd HH:mm:ss', now); //录入时间，读取系统时间
  //debug info
  //showmessage('有效期' + inttostr(iHHSet));
  strexpiretime :=  FormatDateTime('yyyy-MM-dd HH:mm:ss', addhrs(now,iHHSet));

  
  strIDNo := TrimRight(Edit_ID.Text); //卡ID

  if Edit_Pwdcomfir.Text <> Edit_Prepassword.Text then
    ShowMessage('客户输入确认密码错误，请重新输入')
  else begin
    with ADOQuery_Incvalue do begin

        Connection := DataModule_3F.ADOConnection_Main;
        Active := false;
        SQL.Clear;
        strSQL := 'select * from [TMembeDetail] order by GetTime desc';
        SQL.Add(strSQL);
        Active := True;
    

      Bitn_IncvalueComfir.Enabled := False; //关闭输入许可
      Append;
      ShortDateFormat := 'yyyy-MM-dd'; //指定格式即可
      DateSeparator := '-';

      FieldByName('MemCardNo').AsString := strUserNo;
      FieldByName('CostMoney').AsString := strIncvalue; //充值
      FieldByName('TickCount').AsString := strGivecore;
      FieldByName('cUserNo').AsString := strOperator; //操作员
      FieldByName('GetTime').AsString := strinputdatetime; //交易时间
      FieldByName('TotalMoney').AsString := strhavemoney; //帐户总额

      FieldByName('IDCardNo').AsString := strIDNo; //充值操作
      FieldByName('MemberName').AsString := strName; //用户名

      FieldByName('PayType').AsString := '0'; //充值操作
      FieldByName('MacNo').AsString := 'A0100'; //机台编号
      FieldByName('ExitCoin').AsInteger := 0;
      FieldByName('Compter').AsString := '1';
      FieldByName('LastRecord').AsString := '1';
      FieldByName('TickCount').AsString := '0';
      FieldByName('ID_UserCard_TuiBi_Flag').AsString := '0'; //退币标识
      FieldByName('ID_UserCard').AsString := ID_UserCard_Text; //电子币ID
      //add by linlf 20140330   
       FieldByName('expiretime').AsString := strexpiretime; //失效时间
      try
        Post;
      except
        on e: Exception do ShowMessage(e.Message);
      end;
      //added by linlf 用于统计每一次充值，以每一次打开充值窗口为统计口径
      edit_number.Text := inttostr(strtoint(edit_number.Text)+1);
      edit_money.Text  :=  inttostr(strtoint(edit_money.Text)  + strtoint(Edit_Incvalue.Text)  );
      
    end;


    ExitSub:
   //连续充值输入框
    if not (CheckBox_Update.Checked) then
    begin
      ClearText;
      IncValue_Enable := false; //保存记录完毕后，关闭充值操作许可
      Bitn_IncvalueComfir.Enabled := false;

    end
    else
    begin
      //ClearText_ContiueIncValue;
      Bitn_IncvalueComfir.Enabled := true;
      Query_INCValueInfor(strIDNo); //总充值值（来源数据表[TMembeDetail]）
      Query_ChangeValueInfor(strIDNo); //总兑换值（来源数据表[3F_BARFLOW]）
      IncValue_Enable := true; //保存记录完毕后，关闭充值操作许可
    end;

    Edit_Incvalue.Enabled := false;
    Edit_Pwdcomfir.Enabled := false;
    Operate_No := 0;

    ID_UserCard_Text := '';


  end;



end;


 //更新此客户最新充值、消分操作的记录标志位

procedure Tfrm_Frontoperate_incvalue.Update_LastRecord(S: string);
var
  ADOQ: TADOQuery;
  strSQL, strRet: string;
  MaxID: string;
  setvalue: string;
begin
  strSQL := 'select max(MD_ID) from TMembeDetail where MemCardNo=''' + S + '''';
  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Open;
    if (not eof) then
      MaxID := TrimRight(ADOQ.Fields[0].AsString);
    Close;
  end;
  FreeAndNil(ADOQ);

  setvalue := '0';
  strSQL := 'Update TMembeDetail set LastRecord=''' + setvalue + ''' where MD_ID=''' + MaxID + '''';
  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    ADOQ.ExecSQL;
  end;
  FreeAndNil(ADOQ);

end;

 //更新此用户币最新充值、消分操作的记录标志位

procedure Tfrm_Frontoperate_incvalue.Update_LastRecord_UserCard(S: string);
var
  ADOQ: TADOQuery;
  strSQL, strRet: string;
  MaxID: string;
  setvalue: string;
begin
  strSQL := 'select max(MD_ID) from TMembeDetail where ID_UserCard=''' + S + '''';
  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Open;
    if (not eof) then
      MaxID := TrimRight(ADOQ.Fields[0].AsString);
    Close;
  end;
  FreeAndNil(ADOQ);

  setvalue := '0';
  strSQL := 'Update TMembeDetail set LastRecord=''' + setvalue + ''' where MD_ID=''' + MaxID + '''';
  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    ADOQ.ExecSQL;
  end;
  FreeAndNil(ADOQ);

end;

//查询当前币是否有最新的充值记录，如果没有则可能是假币，提示是否真的要继续充值

function Tfrm_Frontoperate_incvalue.Query_LastRecord(S: string): boolean;
var
  ADOQ: TADOQuery;
  strSQL, strRet: string;
  MaxID: integer;
  setvalue, settime: string;
begin


  Result := false;

  strSQL := 'select count(MD_ID) from TMembeDetail where (ID_UserCard=''' + S + ''') and LastRecord=''1''   ';
  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Open;
    if (not eof) then
      MaxID := StrToInt(TrimRight(ADOQ.Fields[0].AsString)); ;

    Close;
  end;
  FreeAndNil(ADOQ);

  if MaxID = 0 then
    Result := false
  else
    Result := true;


end;

function Tfrm_Frontoperate_incvalue.Query_idusercard_valid(S: string): boolean;
var
  ADOQ: TADOQuery;
  strSQL, strRet: string;
  MaxID: integer;
  setvalue, settime: string;
  strdatetime :string;
begin


  Result := false;
  strdatetime := formatdatetime('yyyy-mm-dd hh:mm:ss', now() ) ;
  strSQL := ' select count(MD_ID) from TMembeDetail where (ID_UserCard= '''
         + S + ''') and LastRecord=''1''  and expiretime > '''
         + strdatetime + '''';
  //showmessage(strSQL);
  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Open;
    if (not eof) then
      MaxID := StrToInt(TrimRight(ADOQ.Fields[0].AsString)); ;

    Close;
  end;
  FreeAndNil(ADOQ);

  if MaxID = 0 then
    Result := false
  else
    Result := true;


end;

 //更新此用户币最新充值、消分操作的记录标志位

procedure Tfrm_Frontoperate_incvalue.Update_LastRecord_Value(S: string);
var
  ADOQ: TADOQuery;
  strSQL, strRet: string;
  MaxID: string;
  setvalue, settime, setflag,strexpiretime: string;
begin
  strSQL := 'select max(MD_ID) from TMembeDetail where (ID_UserCard=''' + S + ''') ';
  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Open;
    if (not eof) then
      MaxID := TrimRight(ADOQ.Fields[0].AsString);
    Close;
  end;
  FreeAndNil(ADOQ);
  setflag := '0';
  settime := FormatDateTime('yyyy-MM-dd HH:mm:ss', now);
  strexpiretime :=  FormatDateTime('yyyy-MM-dd HH:mm:ss', addhrs(now,iHHSet));
  
  setvalue := TrimRight(Edit_Incvalue.text);
  strSQL := 'Update TMembeDetail set TotalMoney=''' + setvalue
            + ''',GetTime=''' + settime + ''',CostMoney='''
            + setvalue + ''' ,expiretime=''' + strexpiretime + ''' where (MD_ID=''' + MaxID + ''') and (ID_UserCard_TuiBi_Flag=''' + setflag + ''')';
  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    ADOQ.ExecSQL;
  end;
  FreeAndNil(ADOQ);

end;

procedure Tfrm_Frontoperate_incvalue.ClearText;
begin
  Edit_ID.Text := ''; //卡ID
  Edit_PrintNO.Text := '';

  Edit_Prepassword.Text := '';

  Edit_TotalbuyValue.Text := '';
  Edit_TotalChangeValue.Text := '';
  Edit_Mobile.Text := '';
  Comb_menberlevel.Text := '';
  Edit_SaveMoney.Enabled := false;
  Edit_Incvalue.Enabled := false;
  Edit_Incvalue.Text := '';
  Edit_Pwdcomfir.Enabled := false;
  Edit_Pwdcomfir.Text := '';
  Bitn_IncvalueComfir.Enabled := false;
end;



function Tfrm_Frontoperate_incvalue.Query_Menber_INIT_OK(StrID: string): boolean;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: boolean;
begin
  reTmpStr := false;
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select Count([MemCardNo]) from [TMemberInfo] where IDCardNo=''' + StrID + ''' ';

  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;

    if StrToInt(TrimRight(ADOQTemp.Fields[0].AsString)) > 0 then
      reTmpStr := true;

  end;
  FreeAndNil(ADOQTemp);

  Result := reTmpStr;
end;


function Tfrm_Frontoperate_incvalue.checkMemberUserAndPassowrd : boolean;
var
  ADOQTemp: TADOQuery;
  strSQL,StrID,password: string;
  reTmpStr: boolean;
begin
  StrID := Edit_ID.text;
  password := Edit_Pwdcomfir.text;

  reTmpStr := false;
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select Count([MemCardNo]) from [TMemberInfo]  where IDCardNo=''' + StrID + '''  and   InfoKey = ''' + password + '''';

  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;

    if StrToInt(TrimRight(ADOQTemp.Fields[0].AsString)) > 0 then
      reTmpStr := true;

  end;
  FreeAndNil(ADOQTemp);

  Result := reTmpStr;
end;


procedure Tfrm_Frontoperate_incvalue.Query_MenberInfor(StrID: string);
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: string;
  strsexOrg: string;
begin
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select * from [TMemberInfo] where IDCardNo=''' + StrID + '''';

  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;

    Edit_PrintNO.text := FieldByName('MemCardNo').AsString;

    Edit_ID.text := FieldByName('IDCardNo').AsString;
    Edit_Prepassword.text := FieldByName('InfoKey').AsString;
    Edit_Mobile.text := FieldByName('Mobile').AsString;

    Edit_SaveMoney.text := FieldByName('Deposit').AsString;

    strsexOrg := FieldByName('Sex').AsString;
    if strsexOrg = '1' then
      rgSexOrg.ItemIndex := 0
    else
      rgSexOrg.ItemIndex := 1;

    Query_MenberLevInfor(TrimRight(FieldByName('LevNum').AsString));
    Query_INCValueInfor(StrID); //总充值值（来源数据表[TMembeDetail]）
    Query_ChangeValueInfor(StrID); //总兑换值（来源数据表[3F_BARFLOW]）
  end;
  FreeAndNil(ADOQTemp);
end;
 //查询等级资料

procedure Tfrm_Frontoperate_incvalue.Query_MenberLevInfor(StrLevNum: string); //查询等级资料
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: string;
begin
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select LevName from [TLevel] where LevNo=''' + StrLevNum + '''';

  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    Comb_menberlevel.text := FieldByName('LevName').AsString;
  end;
  FreeAndNil(ADOQTemp);
end;

 //查询过往充值交易情况
 
procedure Tfrm_Frontoperate_incvalue.Query_INCValueInfor(StrID: string);
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: string;
  strMaxMD_ID: string;
begin
                 //取得最新的总分记录ID
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select Max([MD_ID]) from [TMembeDetail] where IDCardNo=''' + StrID + '''';

  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    strMaxMD_ID := ADOQTemp.Fields[0].AsString;
  end;
  FreeAndNil(ADOQTemp);


                 //取得最新的总分
  ADOQTemp := TADOQuery.Create(nil);
                 //strSQL:= 'select TotalMoney from [TMembeDetail] where (IDCardNo='''+StrID+''') and (MD_ID='''+strMaxMD_ID+''')';

  strSQL := 'select sum(TotalMoney) from [TMembeDetail] where (IDCardNo=''' + StrID + ''')';

  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    Edit_TotalbuyValue.text := ADOQTemp.Fields[0].AsString;
  end;
  FreeAndNil(ADOQTemp);
end;

 //查询过往兑奖交易情况

procedure Tfrm_Frontoperate_incvalue.Query_ChangeValueInfor(StrID: string);
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: string;
  strMaxMD_ID: string;
begin

                 //取得兑换总值
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select Sum([COREVALU_Bili]) from [3F_BARFLOW] where (IDCardNo=''' + StrID + ''') ';

  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    Edit_TotalChangeValue.text := ADOQTemp.Fields[0].AsString;
  end;
  FreeAndNil(ADOQTemp);
end;

procedure Tfrm_Frontoperate_incvalue.FormShow(Sender: TObject);
begin
  ICFunction.InitSystemWorkPath; //初始化文件路径
  ICFunction.InitSystemWorkground; //初始化参数背景
  Panel_infor.Caption := '因您设定的代币比例为1 ：' + SystemWorkground.ErrorGTState + ',所以只能输入小于' + IntToStr(StrToInt(INit_Wright.MaxValue) div StrToInt(SystemWorkground.ErrorGTState)) + '的数值！';
  IncValue_Enable := false;
  comReader.StartComm();
  orderLst := TStringList.Create;
  recDataLst := tStringList.Create;
  InitDataBase; //显示出型号
  Edit_Old_Value.Text := '0';
  Bitn_IncvalueComfir.Enabled := false;
  CheckBox_Update.Checked := false;

  edit_number.Text := '0';
  edit_money.Text  := '0';

 //盐城版本要求关闭
  Label10.Visible := false;
  Edit_TotalChangeValue.Visible := false;
  Edit_TotalbuyValue.Visible := false;
  Label7.Visible := false;
  edit_number.Visible := false;
  Labnumber.Visible := false;

  edit_incvalue.Enabled :=false;
  edit_pwdcomfir.Enabled :=false;
    
end;

procedure Tfrm_Frontoperate_incvalue.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: integer;
begin
  orderLst.Free();
  recDataLst.Free();
  comReader.StopComm();

  CheckBox_Update.Enabled := False;


  for i := 0 to ComponentCount - 1 do
  begin
    if components[i] is TEdit then
    begin
      (components[i] as TEdit).Clear;
    end
  end;
end;


//根据查询得到卡的ID，查询个人信息，为充值做准备

procedure Tfrm_Frontoperate_incvalue.Getmenberinfo(S: string);
var
  ADOQ: TADOQuery;
  strSQL, strRet: string;
  strsexOrg: string;

begin
  strRet := '0';
  strSQL := 'select MemCardNo,MemCardNo,MemberName,Sex,DocNumber,MemType,InfoKey,CardAmount,Mobile from TMemberInfo where [IDCardNo]=''' + S + '''';
  ADOQ := TADOQuery.Create(nil);

  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Open;
    if (RecordCount > 0) then
    begin
      Edit_PrintNO.Text := ADOQ.Fields[0].AsString;
      //Edit_UserNo.Text:=ADOQ.Fields[1].AsString;

      strsexOrg := ADOQ.Fields[3].AsString;
      if strsexOrg = '1' then
        rgSexOrg.ItemIndex := 0
      else
        rgSexOrg.ItemIndex := 1;


      Comb_menberlevel.Text := ADOQ.Fields[5].AsString;
      Edit_Prepassword.Text := ADOQ.Fields[6].AsString;
      Edit_SaveMoney.Text := ADOQ.Fields[7].AsString;
      Edit_Mobile.Text := ADOQ.Fields[8].AsString;
      Close;
    end
    else
    begin
      ShowMessage('系统中无此卡开户记录，请确认此人是否会员！！！');
      exit;
    end;
  end;
  FreeAndNil(ADOQ);

end;


procedure Tfrm_Frontoperate_incvalue.Bitn_CloseClick(Sender: TObject);
begin
  Close;
end;


//充值值额及赠分套餐确认

procedure Tfrm_Frontoperate_incvalue.Bit_ValuecomfirClick(Sender: TObject);
begin
  if (Edit_Incvalue.Text = '') or (StrToInt(TrimRight(Edit_Incvalue.Text)) mod 10 <> 0) then
    ShowMessage('充值额不能为空，请输入10的倍数数值')
  else begin
//查询取得对应充值额度的送分套餐
  // GetmenberGivecore(Edit_Incvalue.Text);
//   Bit_Valuecomfir.Enabled:=False;
    Edit_Pwdcomfir.Enabled := True;
//Edit_Pwdcomfir.Focused:=True;
    Bitn_IncvalueComfir.Enabled := True;
  end;
end;




//充值保存确认
procedure Tfrm_Frontoperate_incvalue.Bitn_IncvalueComfirClick(
  Sender: TObject);

var
  INC_value: string;
  strValue: string;
  i: integer;
begin
     // Save_INCValue_Data; //
  if Edit_Incvalue.Text = '' then
  begin
    MessageBox(handle, '充值额不能为0!', '错误', MB_ICONERROR + MB_OK);
    exit;
  end;

  if checkMemberUserAndPassowrd then
  begin
    INC_value := TrimRight(Edit_Incvalue.Text); //充值数值
    Operate_No := 1;
    strValue := Make_Send_CMD(CMD_COUMUNICATION.CMD_INCValue, INC_value); //计算充值指令
    INcrevalue(strValue); //写入电子币,什么时候写入数据库? 收到卡头返回的正确写入电子币后

  end;

end;


procedure Tfrm_Frontoperate_incvalue.Edit_IncvalueKeyPress(Sender: TObject;
  var Key: Char);
var
  strtemp: string;
  strvalue: Double;
begin

  if not (key in ['0'..'9', #8, #13]) then
  begin
    key := #0;
    ShowMessage('输入错误，只能输入数字！');
  end
  else if key = #13 then
  begin
        
    if (StrToInt(Edit_Incvalue.Text) * StrToInt(SystemWorkground.ErrorGTState)) > (StrToInt(INit_Wright.MaxValue)) then
    begin
      strtemp := IntToStr(StrToInt(INit_Wright.MaxValue) div StrToInt(SystemWorkground.ErrorGTState));
      ShowMessage('输入错误，因为您设定的用户币保护上限值为' + INit_Wright.MaxValue + ',只能输入小于' + strtemp + '的数值！');
      exit;
    end;

    if (Edit_Incvalue.Text = '') or ((StrToInt(Edit_Incvalue.Text) mod 10) <> 0) then
    begin
      ShowMessage('输入错误，请输入10的倍数数值！');
      exit;
    end
    else
    begin

      if (length(TrimRight(Edit_TotalbuyValue.Text)) <> 0) and (length(TrimRight(Edit_TotalChangeValue.Text)) <> 0) then
      begin
        strvalue := (StrToFloat(Edit_TotalbuyValue.Text) - StrToFloat(Edit_TotalChangeValue.Text));
      end
      else if (length(TrimRight(Edit_TotalbuyValue.Text)) <> 0) and (length(TrimRight(Edit_TotalChangeValue.Text)) = 0) then
      begin
        strvalue := (StrToFloat(Edit_TotalbuyValue.Text));
      end
      else if (length(TrimRight(Edit_TotalbuyValue.Text)) = 0) and (length(TrimRight(Edit_TotalChangeValue.Text)) <> 0) then
      begin
                          //strvalue:=0-(StrToFloat(Edit_TotalbuyValue.Text));
        strvalue := 0;
      end
      else if (length(TrimRight(Edit_TotalbuyValue.Text)) = 0) and (length(TrimRight(Edit_TotalChangeValue.Text)) = 0) then
      begin
        strvalue := 0;
      end;


      if Edit_TotalbuyValue.Text = '' then
        Edit_Totalvale.Text := FloatToStr(StrToFloat(Edit_Incvalue.Text))
      else
        Edit_Totalvale.Text := FloatToStr(StrToFloat(Edit_Incvalue.Text) + StrToFloat(Edit_TotalbuyValue.Text));

      Edit_Pwdcomfir.Enabled := True;
      Edit_Pwdcomfir.SetFocus;
    end;
  end;

end;


 //根据输入充值额度，查询对应的送分套餐

procedure Tfrm_Frontoperate_incvalue.GetmenberGivecore(S: string);
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: string;
  strMaxMD_ID: string;
begin

                 //取得兑换总值
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select [送积分值] from [3F_MenberGivecore] where ([送分充值上限]>=''' + S + ''') and ([送分充值下限]<''' + S + ''')';

  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    Edit_Givecore.Text := ADOQTemp.Fields[0].AsString;
  end;
  FreeAndNil(ADOQTemp);
end;

procedure Tfrm_Frontoperate_incvalue.Edit_PwdcomfirKeyPress(
  Sender: TObject; var Key: Char);
var
  strtemp: string;
  strvalue: Double;
begin

  if not (key in ['0'..'9', #8, #13]) then
  begin
    key := #0;
    ShowMessage('输入错误，只能输入数字！');
  end
  else if key = #13 then
  begin
    if (Edit_Pwdcomfir.Text <> '') and (TrimRight(Edit_Pwdcomfir.Text) = TrimRight(Edit_Prepassword.Text)) then
    begin
      Bitn_IncvalueComfir.Enabled := True;
      CheckBox_Update.Enabled := True;
      IncValue_Enable :=True;
    end
    else
    begin
      //会员密码验证不通过.
      ShowMessage('输入错误，请输入长度为6位的密码！');
      Bitn_IncvalueComfir.Enabled := False;
      CheckBox_Update.Enabled := False;
      IncValue_Enable :=False;
      exit;
    end;
  end;

end;


//初始化操作

procedure Tfrm_Frontoperate_incvalue.INIT_Operation;
var
  INC_value: string;
  strValue: string;
begin
  begin
    INC_value := Edit_Incvalue.Text; //充值数值
    strValue := Make_Send_CMD(CMD_COUMUNICATION.CMD_INCValue, INC_value); //计算充值指令
    INcrevalue(strValue); //把充值指令写入ID卡
  end;
end;
//充值函数

//写入电子币
procedure Tfrm_Frontoperate_incvalue.INcrevalue(S: string);
begin
  orderLst.Clear();
  recDataLst.Clear();
  curOrderNo := 0;
  curOperNo := 2;

  orderLst.Add(S); //将充值指令写入缓冲
  sendData();
end;

//计算充值指令
function Tfrm_Frontoperate_incvalue.Make_Send_CMD(StrCMD: string; StrIncValue: string): string;
var
  ii, jj, KK: integer;
  TmpStr_IncValue: string; //充值数字
  TmpStr_CheckSum: string; //校验和
  TmpStr_SendCMD: string; //指令内容
  reTmpStr: string;
begin
  Send_CMD_ID_Infor.CMD := StrCMD; //帧命令头部51
  Send_CMD_ID_Infor.ID_INIT := Receive_CMD_ID_Infor.ID_INIT;

    //------------20120320追加写币有效期 开始-----------
    //FormatDateTime('yyyy-MM-dd HH:mm:ss',now);
    //Send_CMD_ID_Infor.ID_3F:=Receive_CMD_ID_Infor.ID_3F;
    //Send_CMD_ID_Infor.Password_3F:=Receive_CMD_ID_Infor.Password_3F;

  if iHHSet = 0 then //时间限制设置无效
  begin
    Send_CMD_ID_Infor.ID_3F := IntToHex(0, 2) + IntToHex(0, 2) + IntToHex(0, 2);
    Send_CMD_ID_Infor.Password_3F := IntToHex(0, 2) + IntToHex(0, 2) + IntToHex(0, 2);
  end
  else //起用时间设置
  begin
    GetInvalidDate;
  end;

    //------------20120320追加写币有效期 结束-----------



  Send_CMD_ID_Infor.Password_USER := Receive_CMD_ID_Infor.Password_USER;

//  SystemWorkground.ErrorGTState代币比例
  TmpStr_IncValue := IntToStr(StrToInt(StrIncValue) * StrToInt(SystemWorkground.ErrorGTState));

  Send_CMD_ID_Infor.ID_value := Select_IncValue_Byte(TmpStr_IncValue);

    //卡功能类型
  Send_CMD_ID_Infor.ID_type := Receive_CMD_ID_Infor.ID_type;
    //汇总发送内容
  TmpStr_SendCMD := Send_CMD_ID_Infor.CMD + Send_CMD_ID_Infor.ID_INIT + Send_CMD_ID_Infor.ID_3F + Send_CMD_ID_Infor.Password_3F
                    + Send_CMD_ID_Infor.Password_USER + Send_CMD_ID_Infor.ID_value + Send_CMD_ID_Infor.ID_type;
    //将发送内容进行校核计算
  TmpStr_CheckSum := CheckSUMData(TmpStr_SendCMD);
    //TmpStr_CheckSum字节需要重新排布 ，低字节在前，高字节在后
  Send_CMD_ID_Infor.ID_CheckNum := Select_CheckSum_Byte(TmpStr_CheckSum);
  Send_CMD_ID_Infor.ID_Settime := Receive_CMD_ID_Infor.ID_Settime;
  //ID_settime没有发送

  reTmpStr := TmpStr_SendCMD + Send_CMD_ID_Infor.ID_CheckNum;

  result := reTmpStr;

end;

//取得电子币的到期时间 expiretime
procedure Tfrm_Frontoperate_incvalue.GetInvalidDate;
var
  strtemp: string;
  iYear, iMonth, iDate, iHH, iMin: integer;
begin


  strtemp := FormatDateTime('yyyy-MM-dd HH:mm:ss', now);
    //调整前
   // strtemp:=Copy(strtemp,1,2)+Copy(strtemp,3,2)+Copy(strtemp,6,2)+Copy(strtemp,9,2)+Copy(strtemp,12,2)+Copy(strtemp,15,2)+Copy(strtemp,20,2);
     //调整后

  iYear := strToint(Copy(strtemp, 1, 4)); //年
  iMonth := strToint(Copy(strtemp, 6, 2)); //月
  iDate := strToint(Copy(strtemp, 9, 2)); //日
  iHH := strToint(Copy(strtemp, 12, 2)); //小时
  iMin := strToint(Copy(strtemp, 15, 2)); //分钟

  if (iHHSet > 47) then
  begin
    showmessage('为了保护您场地利益安全，请设定币有效时间小于48');
    exit;
  end;
   //因为iHH：0~24，故iHHSet也就是0~24小时 ，所以 (iHH+iHHSet)就为0~48小时
   //首先其分 (iHH+iHHSet)就为24~48小时 即为1天有效
  if ((iHH + iHHSet) >= 24) and ((iHH + iHHSet) < 48) then
  begin
    iHH := (iHH + iHHSet) - 24; //取得新的小时
    if (iYear < 1930) then
    begin
      showmessage('系统时间的年份设定错误，请与卡头对时同步');
      exit;
    end;
    if (iMonth = 2) then
    begin
      if ((iYear mod 4) = 0) or ((iYear mod 100) = 0) then //闰年 2月为28日
      begin
        if (iDate = 28) then
        begin
          iDate := 1;
          iMonth := iMonth + 1;
        end
        else
        begin
          iDate := iDate + 1;
        end;
      end
      else //不是闰年  2月为29日
      begin
        if (iDate = 29) then
        begin
          iDate := 1;
          iMonth := iMonth + 1;
        end
        else
        begin
          iDate := iDate + 1;
        end;
      end;
    end
    else if (iMonth = 1) or (iMonth = 3) or (iMonth = 5) or (iMonth = 7) or (iMonth = 8) or (iMonth = 10) then
    begin
      if (iDate = 31) then
      begin
        iDate := 1;
        iMonth := iMonth + 1;
      end
      else
      begin
        iDate := iDate + 1;
      end;
    end
    else if (iMonth = 12) then
    begin
      if (iDate = 31) then
      begin
        iDate := 1;
        iMonth := 1;
        iYear := iYear + 1;
      end
      else
      begin
        iDate := iDate + 1;
      end;
    end
    else if (iMonth = 4) or (iMonth = 6) or (iMonth = 9) or (iMonth = 11) then
    begin
      if (iDate = 30) then
      begin
        iDate := 1;
        iMonth := iMonth + 1;
      end
      else
      begin
        iDate := iDate + 1;
      end;
    end;
  end
   //其次，其分 (iHH+iHHSet)就为0~24小时 即为小于1天有效
  else if ((iHH + iHHSet) < 24) then
  begin
    iHH := (iHH + iHHSet); //取得新的小时
  end;

     //转换为16进制后
     //strtemp=now   Copy(strtemp, 3, 2)=

  Send_CMD_ID_Infor.ID_3F := IntToHex(iMonth, 2) + IntToHex(iHH, 2) + IntToHex(strtoint(Copy(strtemp, 3, 2)), 2);
  Send_CMD_ID_Infor.Password_3F := IntToHex(iDate, 2) + IntToHex(iMin, 2) + IntToHex(strtoint(Copy(strtemp, 1, 2)), 2);

   //strtemp:=Copy(strtemp,6,2)+Copy(strtemp,12,2)+Copy(strtemp,3,2)+Copy(strtemp,9,2)+Copy(strtemp,15,2)+Copy(strtemp,1,2);
    //Edit9.Text:=strtemp;
    //Edit8.Text:=Send_CMD_ID_Infor.ID_3F+',,,'+Send_CMD_ID_Infor.Password_3F;
    //

end;

//校验和，确认是否正确

function Tfrm_Frontoperate_incvalue.CheckSUMData(orderStr: string): string;
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

function Tfrm_Frontoperate_incvalue.Select_IncValue_Byte(StrIncValue: string): string;
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

function Tfrm_Frontoperate_incvalue.Select_CheckSum_Byte(StrCheckSum: string): string;
var
  jj: integer;
  tempLH, tempLL: integer; //2147483648 最大范围

begin
  jj := strToint('$' + StrCheckSum); //将字符转转换为16进制数，然后转换位10进制
  tempLH := (jj mod 65536) div 256; //字节LH
  tempLL := jj mod 256; //字节LL

  result := IntToHex(tempLL, 2) + IntToHex(tempLH, 2);
end;

procedure Tfrm_Frontoperate_incvalue.CheckBox_UpdateClick(Sender: TObject);
begin
 {   if(CheckBox_Update.Checked) then
       begin
         Bitn_IncvalueComfir.Enabled:=false;
       end
    else
       begin
         Bitn_IncvalueComfir.Enabled:=true;
       end;
       }
end;

end.

