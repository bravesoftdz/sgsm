unit Frontoperate_newuserUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Grids, DBGrids, ExtCtrls, Buttons, DB, ADODB,
  SPComm, DateUtils;
type
  Tfrm_Frontoperate_newuser = class(TForm)
    comReader: TComm;
    ADOQuery_newmenber: TADOQuery;
    DataSource_Newmenber: TDataSource;
    DataSource1: TDataSource;
    ADOQuery1: TADOQuery;
    DataSource2: TDataSource;
    ADOQuery2: TADOQuery;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Bit_Close: TBitBtn;
    Panel4: TPanel;
    GroupBox4: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label15: TLabel;
    Label17: TLabel;
    ComboBox_Menbertype: TComboBox;
    Edit_IDNo: TEdit;
    Bit_Query: TBitBtn;
    Edit1: TEdit;
    Edit2: TEdit;
    GroupBox5: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label10: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label16: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label9: TLabel;
    Label12: TLabel;
    Label11: TLabel;
    Edit_ID: TEdit;
    Edit_PrintNO: TEdit;
    Edit_Username: TEdit;
    Comb_Month: TComboBox;
    Comb_Day: TComboBox;
    Edit_Certify: TEdit;
    Edit_SaveMoney: TEdit;
    Edit_Prepassword: TEdit;
    Comb_menberlevel: TComboBox;
    Edit_Mobile: TEdit;
    rgSexOrg: TRadioGroup;
    DataSource3: TDataSource;
    ADOQuery_renewmenberrecord: TADOQuery;
    DBGrid2: TDBGrid;
    Image1: TImage;
    Panel_Message: TPanel;
    Label20: TLabel;
    Label21: TLabel;
    Bit_Add: TBitBtn;
    Label22: TLabel;
    Label23: TLabel;
    Edit3: TEdit;
    Edit4: TEdit;
    procedure comReaderReceiveData(Sender: TObject; Buffer: Pointer;
      BufferLength: Word);
    procedure FormCreate(Sender: TObject);
    procedure Bit_QueryClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Bit_AddClick(Sender: TObject);
    procedure Bit_CloseClick(Sender: TObject);
    procedure Edit_SaveMoneyKeyPress(Sender: TObject; var Key: Char);
    procedure Edit_PrintNOKeyPress(Sender: TObject; var Key: Char);
    procedure Edit_MobileKeyPress(Sender: TObject; var Key: Char);
    procedure Comb_MonthKeyPress(Sender: TObject; var Key: Char);
    procedure Comb_DayKeyPress(Sender: TObject; var Key: Char);
    procedure Edit_CertifyKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    procedure Initmenberlevel;
    procedure Initmenbertype;
    function exchData(orderStr: string): string;
    procedure sendData();
    procedure checkOper();
    procedure CheckCMD();
    procedure InitDataBase;
    function Query_Menbertype(S1: string): string;
    function Querylevel_LevNO(S1: string): string;
    procedure CreatUserNO(StrID: string);
    function CountUserNO: string;
    function OnlyCheck(StrID: string): boolean;
    procedure Query_MenberLevInfor(StrLevNum: string);
    procedure Getmenberinfo(S1, S2: string);
    procedure Mobile_Onlycheck(StrMobile: string);
    procedure Edit_Certify_Onlycheck(StrMobile: string);
  public
    { Public declarations }
  end;

var
  frm_Frontoperate_newuser: Tfrm_Frontoperate_newuser;
  curOrderNo: integer = 0;
  curOperNo: integer = 0;
  orderLst, recDataLst, recData_fromICLst: Tstrings;
  Check_OK: BOOLEAN;
  buffer: array[0..2048] of byte;
implementation

uses ICDataModule, ICtest_Main, ICCommunalVarUnit, ICmain, ICEventTypeUnit, ICFunctionUnit, Frontoperate_EBincvalueUnit;

{$R *.dfm}
//��ʼ���û�����

procedure Tfrm_Frontoperate_newuser.Initmenberlevel;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
begin
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select distinct [LevName] from [TLevel]';
  with ADOQTemp do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    Comb_menberlevel.Items.Clear;
    while not Eof do begin
      Comb_menberlevel.Items.Add(FieldByName('LevName').AsString);
      Next;
    end;
  end;
  FreeAndNil(ADOQTemp);
end;

//��ʼ���ʻ�����

procedure Tfrm_Frontoperate_newuser.Initmenbertype;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
begin

 // ADOQTemp:=TADOQuery.Create(nil);
 // strSQL:= 'select distinct [MemtypeName] from [TMemtype]';
 // with ADOQTemp do begin
  //  Connection := DataModule_3F.ADOConnection_Main;
  //  SQL.Clear;
  //  SQL.Add(strSQL);
  //  Active:=True;
  //  ComboBox_Menbertype.Items.Clear;
  //  while not Eof do begin
  //    ComboBox_Menbertype.Items.Add(FieldByName('MemtypeName').AsString);
  //    Next;
  //    end;
  //  end;
 // FreeAndNil(ADOQTemp);

  ComboBox_Menbertype.Items.Clear;
   //Edit1.Text:= LOAD_USER.ID_type;
   //Edit2.Text:= copy(INit_Wright.BOSS,8,2);
  if (LOAD_USER.ID_type = copy(INit_Wright.Produecer_3F, 8, 2)) then //3FȨ��
  begin
    ComboBox_Menbertype.Items.Add(copy(INit_Wright.User, 1, 6));
    ComboBox_Menbertype.Items.Add(copy(INit_Wright.Produecer_3F, 1, 6));
    ComboBox_Menbertype.Items.Add(copy(INit_Wright.BOSS, 1, 6));
    ComboBox_Menbertype.Items.Add(copy(INit_Wright.MANEGER, 1, 6));
    ComboBox_Menbertype.Items.Add(copy(INit_Wright.QUERY, 1, 6));
    ComboBox_Menbertype.Items.Add(copy(INit_Wright.RECV_CASE, 1, 6));
    ComboBox_Menbertype.Items.Add(copy(INit_Wright.SETTING, 1, 6));
    ComboBox_Menbertype.Items.Add(copy(INit_Wright.OPERN, 1, 6));
  end
  else if (LOAD_USER.ID_type = copy(INit_Wright.BOSS, 8, 2)) then
  begin
    ComboBox_Menbertype.Items.Add(copy(INit_Wright.User, 1, 6));
    ComboBox_Menbertype.Items.Add(copy(INit_Wright.BOSS, 1, 6));
    ComboBox_Menbertype.Items.Add(copy(INit_Wright.MANEGER, 1, 6));
    ComboBox_Menbertype.Items.Add(copy(INit_Wright.QUERY, 1, 6));
    ComboBox_Menbertype.Items.Add(copy(INit_Wright.RECV_CASE, 1, 6));
    ComboBox_Menbertype.Items.Add(copy(INit_Wright.SETTING, 1, 6));
    ComboBox_Menbertype.Items.Add(copy(INit_Wright.OPERN, 1, 6));

  end
  else if (LOAD_USER.ID_type = copy(INit_Wright.MANEGER, 8, 2)) then
  begin
    ComboBox_Menbertype.Items.Add(copy(INit_Wright.User, 1, 6));
    ComboBox_Menbertype.Items.Add(copy(INit_Wright.MANEGER, 1, 6));
    ComboBox_Menbertype.Items.Add(copy(INit_Wright.RECV_CASE, 1, 6));
    ComboBox_Menbertype.Items.Add(copy(INit_Wright.OPERN, 1, 6));

  end
  else if (LOAD_USER.ID_type = copy(INit_Wright.QUERY, 8, 2)) then
  begin
    ComboBox_Menbertype.Items.Clear;
  end
  else if (LOAD_USER.ID_type = copy(INit_Wright.SETTING, 8, 2)) then
  begin
    ComboBox_Menbertype.Items.Clear;
  end
  else if (LOAD_USER.ID_type = copy(INit_Wright.OPERN, 8, 2)) then
  begin
    ComboBox_Menbertype.Items.Clear;
  end;
end;


procedure Tfrm_Frontoperate_newuser.FormCreate(Sender: TObject);
begin

  EventObj := EventUnitObj.Create;
  EventObj.LoadEventIni;

end;

procedure Tfrm_Frontoperate_newuser.InitDataBase;
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

end;


//ת�ҷ������ݸ�ʽ

function Tfrm_Frontoperate_newuser.exchData(orderStr: string): string;
var
  ii, jj: integer;
  TmpStr: string;
  reTmpStr: string;
begin
  if (length(orderStr) = 0) then
  begin
    MessageBox(handle, '�����������Ϊ��!', '����', MB_ICONERROR + MB_OK);
    result := '';
    exit;
  end;
  if (length(orderStr) mod 2) <> 0 then
  begin
    MessageBox(handle, '�����������!', '����', MB_ICONERROR + MB_OK);
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

//�������ݹ���

procedure Tfrm_Frontoperate_newuser.sendData();
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

//��鷵�ص�����

procedure Tfrm_Frontoperate_newuser.checkOper();
var
  i: integer;
  tmpStr: string;
begin
  case curOperNo of
    0: begin
        for i := 0 to recDataLst.Count - 1 do
          if copy(recDataLst.Strings[i], 3, 2) <> '00' then
          begin
                      //  memComSet.Lines.Add('����������ʧ��');
                      //  memComSet.Lines.Add('');
            exit;
          end;
              //  memComSet.Lines.Add('����������ɹ�');
              //  memComSet.Lines.Add('');
      end;
    1: begin
             //   memLowRe.Lines.Add('����: Ѱ��');
        if copy(recDataLst.Strings[0], 3, 2) <> '00' then
                //    memLowRe.Lines.Add('���: Ѱ��ʧ��')
        else begin
                  //  memLowRe.Lines.Add('���: Ѱ���ɹ�');
          if copy(recDataLst.Strings[0], 5, 2) = '04' then
                   //     memLowRe.Lines.Add('�ÿ�ƬΪMifare one')
          else
                   //     memLowRe.Lines.Add('�ÿ�ƬΪ��������');
        end;
              //  memLowRe.Lines.Add('');
      end;
    2: begin
                //memLowRe.Lines.Add('����: ����ͻ');
                //  AND (copy(recDataLst.Strings[0],23,2)='4A')
        if (copy(recDataLst.Strings[0], 9, 2) = 'A1') and (copy(recDataLst.Strings[0], 23, 2) = '4A') then
        begin
          Edit_IDNo.Text := copy(recDataLst.Strings[0], 13, 8); //��ȡ��ID
          Edit_ID.Text := copy(recDataLst.Strings[0], 13, 8);
                   // memLowRe.Lines.Add('���: ����ͻʧ��')
        end
        else begin
                  //  memLowRe.Lines.Add('���: ����ͻ�ɹ�');
          tmpStr := recDataLst.Strings[0];
          tmpStr := copy(tmpStr, 5, length(tmpStr) - 4);

          Edit_IDNo.Text := '����ʧ�ܣ���ȷ�ϴ˿�����٣�'; //��ȡ��ID
                   // memLowRe.Lines.Add('���: '+tmpStr);
        end;
                 // memLowRe.Lines.Add('');

      end;
  end;

end;

//��ȡID����

procedure Tfrm_Frontoperate_newuser.Bit_QueryClick(Sender: TObject);
begin
  orderLst.Clear();
  recDataLst.Clear();
  curOrderNo := 0;
  curOperNo := 2;
  orderLst.Add('AA8A5F5FA101004A');
  sendData();
end;
//���մ��ڷ��ص�����

procedure Tfrm_Frontoperate_newuser.comReaderReceiveData(Sender: TObject; Buffer: Pointer;
  BufferLength: Word);
var
  ii: integer;
  recStr: string;
  tmpStr: string;
  tmpStrend: string;
begin
   //����----------------
  recStr := '';
  SetLength(tmpStr, BufferLength);
  move(buffer^, pchar(tmpStr)^, BufferLength);
  for ii := 1 to BufferLength do
  begin
    recStr := recStr + intTohex(ord(tmpStr[ii]), 2); //���������ת��Ϊ16������
       // if (intTohex(ord(tmpStr[ii]),2)='4A') then
    if ii = BufferLength then
    begin
      tmpStrend := 'END';
    end;
  end;
     // Edit1.Text:=recStr;
  recDataLst.Clear;
  recDataLst.Add(recStr);
    //����---------------
     //if  (tmpStrend='END') then
  begin
    CheckCMD(); //���ȸ��ݽ��յ������ݽ����жϣ�ȷ�ϴ˿��Ƿ�����Ϊ��ȷ�Ŀ�
  end;

end;

//���ݽ��յ��������жϴ˿��Ƿ�Ϊ�Ϸ���

procedure Tfrm_Frontoperate_newuser.CheckCMD();
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
   //���Ƚ�ȡ���յ���Ϣ

  tmpStr := recDataLst.Strings[0];
  Edit1.Text := recDataLst.Strings[0];
  Receive_CMD_ID_Infor.ID_CheckNum := copy(tmpStr, 39, 4); //У���

      // if (CheckSUMData(copy(tmpStr, 1, 38))=copy(tmpStr, 41, 2)+copy(tmpStr, 39, 2)) then//У���
  begin
    CMD_CheckSum_OK := true;
    Receive_CMD_ID_Infor.CMD := copy(recDataLst.Strings[0], 1, 2); //֡ͷ43
  end;

  if Receive_CMD_ID_Infor.CMD = CMD_COUMUNICATION.CMD_READ then
  begin

    Receive_CMD_ID_Infor.ID_INIT := copy(recDataLst.Strings[0], 3, 8); //��ƬID
    Receive_CMD_ID_Infor.ID_3F := copy(recDataLst.Strings[0], 11, 6); //����ID
    Receive_CMD_ID_Infor.Password_3F := copy(recDataLst.Strings[0], 17, 6); //����
    Receive_CMD_ID_Infor.Password_USER := copy(recDataLst.Strings[0], 23, 6); //�û�����
    Receive_CMD_ID_Infor.ID_value := copy(recDataLst.Strings[0], 29, 8); //��������
    Receive_CMD_ID_Infor.ID_type := copy(recDataLst.Strings[0], 37, 2); //������
    Edit4.Text:= '--'+Receive_CMD_ID_Infor.ID_INIT;
    Edit3.Text:= Receive_CMD_ID_Infor.ID_type;
                 //1���ж��Ƿ�������ʼ�������������ִ�в���2 ICFunction.
                // if ICFunction.CHECK_3F_ID(Receive_CMD_ID_Infor.ID_INIT,Receive_CMD_ID_Infor.ID_3F,Receive_CMD_ID_Infor.Password_3F) then
    begin

                //2�����ȷ������˳�ʼ�������һ���жϴ˿��Ƿ����ڴ˿ͻ���
                //��Receive_CMD_ID_Infor.Password_USER=ICFunction.SUANFA_Password_USER(INit_3F.ID_3F,CUSTOMER_NO.Text);

                        //���ϰ��ʼ���ĳ�������Ƚ� �����ұ������û������ܳ�ֵ ,ͬʱ�˿����������ݱ����м�¼
                        //20120923�޸��ж���������Ϊֱ�����ϰ��ʼ���趨�ĳ�������Ƚ�
                          //else if ICFunction.CHECK_Customer_ID_USERINIT(Receive_CMD_ID_Infor.ID_INIT,Receive_CMD_ID_Infor.Password_USER) and  (Receive_CMD_ID_Infor.ID_type=copy(INit_Wright.User,8,2))then

      if (Receive_CMD_ID_Infor.Password_USER = INit_Wright.BossPassword) and (Receive_CMD_ID_Infor.ID_type = copy(INit_Wright.RECV_CASE, 8, 2)) then //����������Ϊ��Ա��

      begin

        if DataModule_3F.Query_User_INIT_OK(Receive_CMD_ID_Infor.ID_INIT) then //�м�¼
        begin

          if OnlyCheck(Receive_CMD_ID_Infor.ID_INIT) then
          begin
            Panel_Message.Caption := '�˿�ID�Ѿ����ڣ���ȷ�Ͽ���Դ��'; //��ID
          end
          else

          begin

            Edit_ID.Text := Receive_CMD_ID_Infor.ID_INIT; //��ID
            Edit_IDNo.Text := Receive_CMD_ID_Infor.ID_INIT; //��ID
            //CreatUserNO(Receive_CMD_ID_Infor.ID_INIT); //����ӡˢ����
            //modified by linlf; it is no need to get the focus;
            //Edit_Username.SetFocus;
            Panel_Message.Caption := '�˿��Ϸ��������������'; //��ID

          end;


        end
        else
        begin

          Edit_ID.Text := ''; //��ID
          Edit_IDNo.Text := ''; //��ID

          Panel_Message.Caption := '�ڴ�ϵͳ�޼�¼����ȷ���Ƿ��Ѿ���ɳ��س�ʼ����'; //��ID
          exit;

        end;


      end
      else
      begin
        Edit_ID.Text := ''; //��ID
        Edit_IDNo.Text := ''; //��ID
        Panel_Message.Caption := '�˿��Ƿ����������'; //��ID
        exit;
      end;

    end;
               //    else //����֤Ϊ�Ƿ���
                //   begin
                //          Edit14.Text:= '�˿��Ƿ�����֪ͨ�����ϰ壡'; //��ID
                 //         exit;
               //    end;

  end;

end;

procedure Tfrm_Frontoperate_newuser.CreatUserNO(StrID: string);
begin

  Edit_PrintNO.text := StrID + CountUserNO;
end;

function Tfrm_Frontoperate_newuser.CountUserNO: string;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: string;
begin
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select Count([MemCardNo]) from [TMemberInfo] ';

  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    reTmpStr := TrimRight(ADOQTemp.Fields[0].AsString);

    if StrToInt(reTmpStr) < 10 then
      reTmpStr := '000' + reTmpStr
    else if (StrToInt(reTmpStr) < 100) and (StrToInt(reTmpStr) > 9) then
      reTmpStr := '00' + reTmpStr
    else if (StrToInt(reTmpStr) < 1000) and (StrToInt(reTmpStr) > 99) then
      reTmpStr := '0' + reTmpStr
    else if (StrToInt(reTmpStr) < 10000) and (StrToInt(reTmpStr) > 999) then
      reTmpStr := reTmpStr;
  end;
  FreeAndNil(ADOQTemp);
  Result := reTmpStr;
end;

function Tfrm_Frontoperate_newuser.OnlyCheck(StrID: string): boolean;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: boolean;
begin
  reTmpStr := false;


  ADOQTemp := TADOQuery.Create(nil);
  //strSQL := 'select Count([MemCardNo]) from [TMemberInfo] where IDCardNo=''' + StrID + '''';
  strSQL := 'select Count([MemCardNo]) from [TMemberInfo] where IDCardNo=''11''';

  with ADOQTemp do
  begin
  {
    Connection := DataModule_3F.ADOConnection_main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;

    if StrToInt(TrimRight(ADOQTemp.Fields[0].AsString)) > 0 then
      reTmpStr := true;
   }
  end;

  
  FreeAndNil(ADOQTemp);

  Result := reTmpStr;

end;


procedure Tfrm_Frontoperate_newuser.FormShow(Sender: TObject);
begin
  comReader.StartComm();
  orderLst := TStringList.Create;
  recDataLst := tStringList.Create;
  InitDataBase; //��ʾ���ͺ�
  Initmenberlevel;
    //Initmenbertype;
  Check_OK := false;
end;

procedure Tfrm_Frontoperate_newuser.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: integer;
begin


  orderLst.Free();
  recDataLst.Free();
  comReader.StopComm();
  ICFunction.ClearIDinfor; //�����ID��ȡ��������Ϣ
  Check_OK := false;
    //������
  for i := 0 to ComponentCount - 1 do
  begin
    if components[i] is TEdit then
    begin
      (components[i] as TEdit).Clear;
    end
  end;
end;


  //��ѯ�ȼ�����

function Tfrm_Frontoperate_newuser.Querylevel_LevNO(S1: string): string;
var
  strSQL: string;
  temp: string;
  temp_levelno: string;
begin

  with ADOQuery1 do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select LevNo from [TLevel] where  LevName=''' + S1 + '''';
    SQL.Add(strSQL);
    Open;
    if (RecordCount > 0) then
      temp_levelno := ADOQuery1.Fields[0].AsString;
    Close;
  end;
  result := temp_levelno;

end;

  //��ѯ�˻����ʹ���

function Tfrm_Frontoperate_newuser.Query_Menbertype(S1: string): string;
var
  strSQL: string;
  temp: string;
  temp_levelno: string;
begin
  with ADOQuery1 do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select MemtypeNo from [TMemtype] where  MemtypeName=''' + S1 + '''';
    SQL.Add(strSQL);
    Open;
    if (RecordCount > 0) then
      temp_levelno := ADOQuery1.Fields[0].AsString;
    Close;
  end;
  result := temp_levelno;

end;
//�½��û�

procedure Tfrm_Frontoperate_newuser.Bit_AddClick(Sender: TObject);
var
  strMenbertype, strinputdatetime, strID, strPrintNO, strUsername, strMobile, strmenberlevel, strMonth, strDay, strOperator, strCertify, strPrepassword: string;
  i, j: integer;
  EditOKStr, pwdStr: string;
  strsexOrg: Boolean;
  strSaveMoney: Currency;
  Strtest: string;
label ExitSub;
begin
  //strMenbertype:=Query_Menbertype(TrimRight(ComboBox_Menbertype.Text));
  strMenbertype := 'A���ʻ�';
  //Strtest:='A���ʻ�';
 // strMenbertype:=Query_Menbertype(Strtest);
  strmenberlevel := Querylevel_LevNO(TrimRight(Comb_menberlevel.Text));

  strPrintNO := Edit_PrintNO.Text;
  strUsername := Edit_Username.Text;
  strMonth := Comb_Month.Text;
  strOperator := G_User.UserNO;
  strDay := Comb_Day.Text;

  strCertify := Edit_Certify.Text;
  strSaveMoney := StrToCurr(Edit_SaveMoney.Text);
  strPrepassword := Edit_Prepassword.Text;
  strMobile := Edit_Mobile.Text;

  strID := Edit_ID.Text;
  EditOKStr := 'ok';
  strinputdatetime := DateTimetostr((now())); //¼��ʱ�䣬��ȡϵͳʱ��
  if rgSexOrg.ItemIndex = 0 then
    strsexOrg := true
  else
    strsexOrg := false;


  if (Edit_ID.Text = '') then //��ID
  begin
    ShowMessage('��ȷ���Ƿ��Ѿ��ɹ�ˢ��');
    EditOKStr := 'NG';
    exit;
  end;
  if length(TrimRight(Edit_Certify.Text)) <> 18 then //��ID
  begin
    ShowMessage('��ȷ�����֤�����Ƿ���ȷ');
    EditOKStr := 'NG';
    exit;
  end;
  if length(TrimRight(Edit_Mobile.Text)) <> 11 then //��ID
  begin
    ShowMessage('��ȷ���ֻ��ų����Ƿ���ȷ');
    EditOKStr := 'NG';
    exit;
  end;
  if (Edit_SaveMoney.Text = '') then //��ID
  begin
    ShowMessage('��ȷ��Ѻ���Ƿ���д');
    EditOKStr := 'NG';
    exit;
  end;
  if length(TrimRight(Edit_Prepassword.Text)) <> 6 then //��ID
  begin
    ShowMessage('��ȷ�����볤���Ƿ���ȷ');
    EditOKStr := 'NG';
    exit;
  end;
  if (Comb_menberlevel.Text = '') then //��ID
  begin
    ShowMessage('��ȷ���Ƿ�ѡ�����û��ȼ�');
    EditOKStr := 'NG';
    exit;
  end;

  if EditOKStr = 'NG' then
    ShowMessage('��Ϣ������')
  else begin
    with ADOQuery_newmenber do begin
      if (Locate('IDCardNo', strID, [])) then begin
        if (MessageDlg('�ֿ���  ' + strID + '  ���û��Ѿ����ڣ�Ҫ������', mtInformation, [mbYes, mbNo], 0) = mrYes) then
          Edit
        else
          goto ExitSub;
      end
      else
        Append;
      FieldByName('MemCardNo').AsString := strPrintNO;
      FieldByName('MemType').AsString := strMenbertype;
      FieldByName('IDCardNo').AsString := strID;
      FieldByName('MemberName').AsString := strUsername;
      FieldByName('Sex').AsBoolean := strsexOrg;
      FieldByName('Birthday').AsString := strMonth + '-' + strDay;
      FieldByName('Mobile').AsString := strMobile;
      FieldByName('DocNumber').AsString := strCertify;
      FieldByName('Deposit').AsCurrency := strSaveMoney;
      FieldByName('LevNum').AsString := strmenberlevel;
      FieldByName('InfoKey').AsString := strPrepassword;
      FieldByName('OpenCardDT').AsString := strinputdatetime;
      FieldByName('EffectiveDT').AsString := copy(strinputdatetime, 1, 2) + IntToStr(StrToInt(copy(strinputdatetime, 3, 2)) + 10) + copy(strinputdatetime, 5, length(strinputdatetime) - 4);

      FieldByName('IsAble').AsString := '1'; //1����������
      FieldByName('TickAmount').AsString := '0';
      FieldByName('cUserNo').AsString := strOperator;

                  //FieldByName('OpenCardDT').AsString :=strinputdatetime;
                 // FieldByName('IsAble').AsString :='����';
                  //FieldByName('TickAmount').AsString :='0';

      try
        Post;
      except
        on e: Exception do ShowMessage(e.Message);
      end;
    end;


    ExitSub:
    Edit_PrintNO.Text := '';
    Edit_Username.Text := '';
    Comb_Month.Text := '';
    Comb_Day.Text := '';
    Edit_Certify.Text := '';
               //Edit_SaveMoney.Text:='';
    Edit_Prepassword.Text := '';
               //Comb_menberlevel.Text:='';
    Edit_Mobile.Text := '';
    Edit_ID.Text := '';
  end;
end;

procedure Tfrm_Frontoperate_newuser.Bit_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure Tfrm_Frontoperate_newuser.Edit_SaveMoneyKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (key in ['0'..'9', #8]) then
  begin
    key := #0;
  end

end;

procedure Tfrm_Frontoperate_newuser.Edit_PrintNOKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (key in ['0'..'9', #8]) then
  begin
    key := #0;
  end
end;


procedure Tfrm_Frontoperate_newuser.Comb_MonthKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (key in ['0'..'9', #8]) then
  begin
    key := #0;
  end
end;

procedure Tfrm_Frontoperate_newuser.Comb_DayKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (key in ['0'..'9', #8]) then
  begin
    key := #0;
  end
end;

procedure Tfrm_Frontoperate_newuser.Edit_MobileKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (key in ['0'..'9', #8]) then
  begin
    key := #0;
  end;
  if (length(trimright(Edit_Mobile.Text)) = 11) and (key = #13) then
  begin
    Mobile_Onlycheck(trimright(Edit_Mobile.Text));
  end;
end;

procedure Tfrm_Frontoperate_newuser.Edit_CertifyKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (key in ['0'..'9', #8, #13]) then
  begin
    key := #0;
  end;
  if (length(trimright(Edit_Certify.Text)) = 18) and (key = #13) then
  begin
    Mobile_Onlycheck(trimright(Edit_Certify.Text));
  end;
end;

procedure Tfrm_Frontoperate_newuser.Mobile_Onlycheck(StrMobile: string);
begin
  Getmenberinfo('�����û��ֻ���', StrMobile);
end;

procedure Tfrm_Frontoperate_newuser.Edit_Certify_Onlycheck(StrMobile: string);
begin
  Getmenberinfo('�����û����֤', StrMobile);
end;

procedure Tfrm_Frontoperate_newuser.Getmenberinfo(S1, S2: string);
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: string;
  strsexOrg: string;
begin

  if S1 = '�����û��ֻ���' then
    strSQL := 'select * from [TMemberInfo] where  [Mobile]=''' + S2 + ''''
  else if S1 = '�����û����֤' then
    strSQL := 'select * from [TMemberInfo] where  [DocNumber]=''' + S2 + ''''
  else
  begin
    exit;
  end;
  ADOQTemp := TADOQuery.Create(nil);

  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    while not Eof do
    begin
      Edit_PrintNO.text := FieldByName('MemCardNo').AsString;
      Edit_Username.text := FieldByName('MemberName').AsString;
      Edit_ID.text := FieldByName('IDCardNo').AsString;
      Edit_Prepassword.text := FieldByName('InfoKey').AsString;
      Edit_Mobile.text := FieldByName('Mobile').AsString;
      Edit_Certify.text := FieldByName('DocNumber').AsString;
      Edit_SaveMoney.text := FieldByName('Deposit').AsString;

      strsexOrg := FieldByName('Sex').AsString;
      if strsexOrg = '1' then
        rgSexOrg.ItemIndex := 0
      else
        rgSexOrg.ItemIndex := 1;

      Query_MenberLevInfor(TrimRight(FieldByName('LevNum').AsString));
    end;
  end;
  FreeAndNil(ADOQTemp);
end;

 //��ѯ�ȼ�����

procedure Tfrm_Frontoperate_newuser.Query_MenberLevInfor(StrLevNum: string); //��ѯ�ȼ�����
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



end.
