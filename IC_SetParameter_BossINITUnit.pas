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
    procedure INcrevalue(S: string); //��ֵ����
    function CheckSUMData(orderStr: string): string; //У���
    function Select_IncValue_Byte(StrIncValue: string): string;
    function Select_CheckSum_Byte(StrCheckSum: string): string;
    function INit_Send_CMD(StrCMD: string; StrIncValue: string): string;
    function QueryCustomer_No(strphone: string): string;
    procedure INitIDType;
    procedure INIT_Operation;
    //�����ʼ������
    procedure Save_INit_Data;
      //ID�����ʶ��
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


//ת�ҷ������ݸ�ʽ �����ַ�ת��Ϊ16����

function Tfrm_SetParameter_BossINIT.exchData(orderStr: string): string;
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

//У��ͣ�ȷ���Ƿ���ȷ

function Tfrm_SetParameter_BossINIT.CheckSUMData(orderStr: string): string;
var
  ii, jj, KK: integer;
  TmpStr: string;
  reTmpStr: string;
begin
  if (length(orderStr) mod 2) <> 0 then
  begin
    MessageBox(handle, '����������ȴ���!', '����', MB_ICONERROR + MB_OK);
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
//��ֵ����ת����16���Ʋ����� �ֽ�LL���ֽ�LH���ֽ�HL���ֽ�HH

function Tfrm_SetParameter_BossINIT.Select_IncValue_Byte(StrIncValue: string): string;
var
  tempLH, tempHH, tempHL, tempLL: integer; //2147483648 ���Χ
begin
  tempHH := StrToint(StrIncValue) div 16777216; //�ֽ�HH
  tempHL := (StrToInt(StrIncValue) mod 16777216) div 65536; //�ֽ�HL
  tempLH := (StrToInt(StrIncValue) mod 65536) div 256; //�ֽ�LH
  tempLL := StrToInt(StrIncValue) mod 256; //�ֽ�LL

  result := IntToHex(tempLL, 2) + IntToHex(tempLH, 2) + IntToHex(tempHL, 2) + IntToHex(tempHH, 2);
end;


//У���ת����16���Ʋ����� �ֽ�LL���ֽ�LH

function Tfrm_SetParameter_BossINIT.Select_CheckSum_Byte(StrCheckSum: string): string;
var
  jj: integer;
  tempLH, tempLL: integer; //2147483648 ���Χ

begin
  jj := strToint('$' + StrCheckSum); //���ַ�תת��Ϊ16��������Ȼ��ת��λ10����
  tempLH := (jj mod 65536) div 256; //�ֽ�LH
  tempLL := jj mod 256; //�ֽ�LL

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
   //����----------------
  tmpStrend := 'STR';
  recStr := '';
  SetLength(tmpStr, BufferLength);
  move(buffer^, pchar(tmpStr)^, BufferLength);
  for ii := 1 to BufferLength do
  begin
    recStr := recStr + intTohex(ord(tmpStr[ii]), 2); //���������ת��Ϊ16������
    if ii = BufferLength then
    begin
      tmpStrend := 'END';
    end;
  end;

  recData_fromICLst.Clear;
  recData_fromICLst.Add(recStr);
    //����---------------
  begin
    CheckCMD(); //���ȸ��ݽ��յ������ݽ����жϣ�ȷ�ϴ˿��Ƿ�����Ϊ��ȷ�Ŀ�
  end;
  
end;

//���ݽ��յ��������жϴ˿��Ƿ�Ϊ�Ϸ���

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
   //���Ƚ�ȡ���յ���Ϣ

  ComboBox_Menbertype.Items.Clear;
  INitIDType; //��ʼ�� ComboBox_Menbertype
  IDtypetemp := 'A5';
  tmpStr := recData_fromICLst.Strings[0];
       //Edit1.Text:= recData_fromICLst.Strings[0];
  Receive_CMD_ID_Infor.ID_CheckNum := copy(tmpStr, 39, 4); //У���

      // if (CheckSUMData(copy(tmpStr, 1, 38))=copy(tmpStr, 41, 2)+copy(tmpStr, 39, 2)) then//У���
  begin
    CMD_CheckSum_OK := true;
    Receive_CMD_ID_Infor.CMD := copy(recData_fromICLst.Strings[0], 1, 2); //֡ͷ43
  end;
                 //1���жϴ˿��Ƿ�Ϊ�Ѿ���ɳ�ʼ��
  if Receive_CMD_ID_Infor.CMD = CMD_COUMUNICATION.CMD_INCValue_RE then
  begin

                  // if  (Customer_Phone.Text<>'') and (CUSTOMER_NO.Text<>'') and (Edit_ID.Text<>'') then
    begin
      if (Operate_No = 1) then //���浱ǰ���ĳ�ʼ����¼
      begin
        //�����¼
        Save_INit_Data;
        Edit_OPResult.Text := '��ʼ������������ɹ�';
      end;
    end;
  end
  else if Receive_CMD_ID_Infor.CMD = CMD_COUMUNICATION.CMD_READ then
  begin

    Receive_CMD_ID_Infor.ID_INIT := copy(recData_fromICLst.Strings[0], 3, 8); //��ƬID
    Receive_CMD_ID_Infor.ID_3F := copy(recData_fromICLst.Strings[0], 11, 6); //����ID
    Receive_CMD_ID_Infor.Password_3F := copy(recData_fromICLst.Strings[0], 17, 6); //����
    Receive_CMD_ID_Infor.Password_USER := copy(recData_fromICLst.Strings[0], 23, 6); //�û�����
    Receive_CMD_ID_Infor.ID_value := copy(recData_fromICLst.Strings[0], 29, 8); //��������
    Receive_CMD_ID_Infor.ID_type := copy(recData_fromICLst.Strings[0], 37, 2); //������

    ICFunction.loginfo('���س�ʼ�� Receive_CMD_ID_Infor.ID_INIT '+ Receive_CMD_ID_Infor.ID_INIT );
    ICFunction.loginfo('���س�ʼ�� Receive_CMD_ID_Infor.ID_3F '+ Receive_CMD_ID_Infor.ID_3F );
    ICFunction.loginfo('���س�ʼ�� Receive_CMD_ID_Infor.Password_3F '+ Receive_CMD_ID_Infor.Password_3F );
    ICFunction.loginfo('���س�ʼ�� Receive_CMD_ID_Infor.Password_USER '+ Receive_CMD_ID_Infor.Password_USER );
    ICFunction.loginfo('���س�ʼ�� Receive_CMD_ID_Infor.ID_value '+ Receive_CMD_ID_Infor.ID_value );
    ICFunction.loginfo('���س�ʼ�� Receive_CMD_ID_Infor.ID_type '+ Receive_CMD_ID_Infor.ID_type );
   
    begin    
      if Receive_CMD_ID_Infor.Password_USER = INit_Wright.BossPassword_old then
      begin
        Edit_ID.Text := Receive_CMD_ID_Infor.ID_INIT; //��ID
        Operate_No := 1;
        INIT_Operation; //����д��ID����
        Edit14.Text := '�˿��Ϸ�������ɳ��س�ʼ����'; //��ID
      end

                       //������3F��ʼ���ĳ�������Ƚ�
                       //20120923�޸��ж���������Ϊֱ����3F�����趨�ĳ�������Ƚ�
                       //if ICFunction.CHECK_Customer_ID_3FINIT(Receive_CMD_ID_Infor.ID_INIT,Receive_CMD_ID_Infor.Password_USER) then
      else if Receive_CMD_ID_Infor.Password_USER = INit_Wright.BossPassword_3F then
      begin
        Edit_ID.Text := Receive_CMD_ID_Infor.ID_INIT; //��ID
        Operate_No := 1;
        INIT_Operation; //����д��ID����
        Edit14.Text := '�˿��Ϸ����Ѿ���ɳ�����ʼ����'; //��ID
      end

      else if Receive_CMD_ID_Infor.Password_USER = INit_Wright.BossPassword then
      begin
        Edit_ID.Text := Receive_CMD_ID_Infor.ID_INIT; //��ID
        Edit14.Text := '�˿��Ϸ����Ѿ���ɳ��س�ʼ����'; //��ID
      end
      else if Receive_CMD_ID_Infor.ID_type = IDtypetemp then
      begin
        Edit_ID.Text := Receive_CMD_ID_Infor.ID_INIT; //��ID
        Operate_No := 1;
        INIT_Operation; //����д��ID����
        Edit14.Text := '�˿��Ϸ����Ѿ���ɳ�����ʼ����'; //��ID
      end
      else
      begin
        Edit14.Text := '�˿��Ƿ������Ǳ�ϵͳ���׿���'; //��ID

        exit;
      end;

    end;
              // else //����֤Ϊ�Ƿ���
    begin
                  //        Edit14.Text:= '�˿��Ƿ�����֪ͨ�����ϰ壡'; //��ID
                  //        exit;
    end;

  end;

end;


//��ʼ������

procedure Tfrm_SetParameter_BossINIT.INIT_Operation;
var
  INC_value: string;
  strValue: string;
begin
  begin
    INC_value := Receive_CMD_ID_Infor.ID_value; //��ֵ��ֵ
    //add by linlf���س�ʼ��ʱ�����ӱҵ�ֵ��ʼ��Ϊ0
    INC_value := '00000000'; //��ֵ��ֵ
    //showmessage(INC_VALUE);
    strValue := INit_Send_CMD(CMD_COUMUNICATION.CMD_INCValue, INC_value); //�����ֵָ��
    INcrevalue(strValue); //д��ID��
  end;
end;


//��ʼ��������ָ��

function Tfrm_SetParameter_BossINIT.INit_Send_CMD(StrCMD: string; StrIncValue: string): string;
var
  TmpStr_IncValue: string; //��ֵ����
  TmpStr_CheckSum: string; //У���
  TmpStr_SendCMD: string; //ָ������
  TmpStr_Password_User: string; //ָ������
  reTmpStr: string;
  myIni: TiniFile;
begin

  INit_3F.CMD := StrCMD; //֡����
  INit_3F.ID_INIT := Edit_ID.Text;

  INit_3F.ID_3F := Receive_CMD_ID_Infor.ID_3F;
  INit_3F.Password_3F := Receive_CMD_ID_Infor.Password_3F;

                              //����ȡ���ĵ��еĳ�������
  if FileExists(SystemWorkGroundFile) then
  begin
    myIni := TIniFile.Create(SystemWorkGroundFile);
    INit_Wright.BossPassword := MyIni.ReadString('PLC��������', 'PC����������', 'D6077');
    FreeAndNil(myIni);
  end;
   //20120923�޸ģ������û�������㷨����Ϊֱ�Ӷ�ȡ�����ļ��е��û�����
   // TmpStr_Password_User:=ICFunction.SUANFA_Password_USER_WritetoID(Edit_ID.Text,INit_Wright.BossPassword);
   // INit_3F.Password_USER:=TmpStr_Password_User; //�û�����
  TmpStr_Password_User := INit_Wright.BossPassword; //�û�����
  INit_3F.Password_USER := INit_Wright.BossPassword; //�û�����


  INit_3F.ID_value := StrIncValue;
  INit_3F.ID_type := Receive_CMD_ID_Infor.ID_type; //ȡ�ÿ����͵�ֵ


    //���ܷ�������
  TmpStr_SendCMD := INit_3F.CMD + INit_3F.ID_INIT + INit_3F.ID_3F + INit_3F.Password_3F + INit_3F.Password_USER + INit_3F.ID_value + INit_3F.ID_type;

    //���������ݽ���У�˼���
  TmpStr_CheckSum := CheckSUMData(TmpStr_SendCMD);
    //TmpStr_CheckSum�ֽ���Ҫ�����Ų� �����ֽ���ǰ�����ֽ��ں�
  INit_3F.ID_CheckNum := Select_CheckSum_Byte(TmpStr_CheckSum);


  ID_3F.Text := INit_3F.ID_3F;
  ID_Password_3F.Text := INit_3F.Password_3F;
  ID_Password_3F.Text := INit_3F.Password_USER;
  ID_CheckSum.Text := INit_3F.ID_CheckNum;
  ID_Value.Text := INit_3F.ID_value; //����

  reTmpStr := TmpStr_SendCMD + INit_3F.ID_CheckNum;

  result := reTmpStr;
end;


//д��ID��----------------------------------------

procedure Tfrm_SetParameter_BossINIT.INcrevalue(S: string);
begin
  orderLst.Clear();
  recDataLst.Clear();
  curOrderNo := 0;
  curOperNo := 2;
    //Edit1.Text:=s;
  Edit1.Text := '111111111111111111111111111111111111111';
  orderLst.Add(S); //����ֵд�����
  sendData();
end;


//�����ʼ������

procedure Tfrm_SetParameter_BossINIT.Save_INit_Data;
var
  strOperator, strinputdatetime: string;
label ExitSub;
begin

  strOperator := G_User.UserNO;
  strinputdatetime := DateTimetostr((now())); //¼��ʱ�䣬��ȡϵͳʱ��


  with ADOQuery_BOSSInit do begin
    if (Locate('ID_INIT', INit_3F.ID_INIT, [])) then
    begin
                //  if(MessageDlg('ID��  '+INit_3F.ID_INIT+'  �Ŀ���ʼ����Ϣ�Ѿ����ڣ�Ҫ������',mtInformation,[mbYes,mbNo],0)=mrYes) then
      Edit;
      Edit14.Text := '���س�ʼ���ɹ��������ظ�����';
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
    INit_Wright.BossPassword_old := MyIni.ReadString('PLC��������', 'PC����������', '������');
    INit_Wright.BossPassword := MyIni.ReadString('PLC��������', 'PC����������', '������'); //��ȡ���º������
    FreeAndNil(myIni);
  end;

  if LOAD_USER.ID_type = Copy(INit_Wright.Produecer_3F, 8, 2) then //�ϰ忨���Լ����˲�����ť
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

  ICFunction.ClearIDinfor; //�����ID��ȡ��������Ϣ

end;


//��ֵ����ȷ��
 //δʹ��
procedure Tfrm_SetParameter_BossINIT.IncvalueComfir(S: string; S1: string);

var
  strIDNo, strName, strUserNo, strIncvalue, strGivecore, strOperator, strhavemoney, strinputdatetime: string;
  i: integer;
label ExitSub;
begin

  strIDNo := Edit_ID.Text;
  strOperator := G_User.UserNO; //����Ա
  strinputdatetime := DateTimetostr((now())); //¼��ʱ�䣬��ȡϵͳʱ��

  with ADOQuery_BOSSInit do begin
    Append;
    FieldByName('CostMoney').AsString := strIncvalue; //��ֵ
    FieldByName('cUserNo').AsString := strOperator; //����Ա
    FieldByName('GetTime').AsString := strinputdatetime; //����ʱ��
    FieldByName('IDCardNo').AsString := strIDNo; //��ID
    try
      Post;
    except
      on e: Exception do ShowMessage(e.Message);
    end;
  end;


  ExitSub:
   //��������
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
  InitDataBase; //��ʾ���ͺ�
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
    ShowMessage('�������ֻ���������ֺ��ַ���');
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
      ShowMessage('�������ֻ���������ֺ��ַ���');
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
    ShowMessage('�������ֻ���������ֺ��ַ���');
  end
  else if key = #13 then
  begin
    if length(Customer_Phone.Text) = 11 then
    begin
             //�������ݿ����Ƿ�����˵绰����ƥ����û��������ѯ���Ӧ�Ŀͻ����
      CUSTOMER_NO.Text := QueryCustomer_No(Customer_Phone.Text);
      if trim(CUSTOMER_NO.Text) = '' then
      begin
        CUSTOMER_NO.Text := Copy(Customer_Phone.Text, 6, 6); //��ȡ�ֻ��ŵĺ�6λΪ�ͻ����
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

//���ҿͻ����

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
  //ID�����ʶ��

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


    //����ID
  tempTOTAL1 := strToint('$' + Copy(StrCheckSum, 1, 2)) + strToint('$' + Copy(StrCheckSum, 3, 2)) + strToint('$' + Copy(StrCheckSum, 5, 2)) * strToint('$' + Copy(StrCheckSum, 7, 2));
    //Edit15.Text:=IntToStr(tempTOTAL1);

  Byte1 := (tempTOTAL1 * tempTOTAL1) mod 16;
  Byte2 := (tempTOTAL1 * tempTOTAL1) div 16;
  Byte3 := tempTOTAL1;


  Result := true;
  if (ID_3F_1 <> copy(IntToHex(Byte2, 2), length(IntToHex(Byte2, 2)) - 2, 2)) then
    Result := false; //��һ�ֽ�
  if (ID_3F_2 <> copy(IntToHex(Byte3, 2), length(IntToHex(Byte3, 2)) - 1, 2)) then
    Result := false; //�ڶ��ֽ�
  if (ID_3F_3 <> copy(IntToHex(Byte1, 2), length(IntToHex(Byte1, 2)) - 1, 2)) then
    Result := false; //�����ֽ�


         //��������
  tempTOTAL2 := strToint('$' + Copy(StrCheckSum, 1, 2)) * strToint('$' + Copy(StrCheckSum, 3, 2)) + strToint('$' + Copy(StrCheckSum, 5, 2));
    // Edit16.Text:=IntToStr(tempTOTAL2);
  Byte4 := (tempTOTAL2 * tempTOTAL2) mod 16;
  Byte5 := (tempTOTAL2 * tempTOTAL2) div 16;
  Byte6 := tempTOTAL2;
  if (PWD_3F_1 <> copy(IntToHex(Byte4, 2), length(IntToHex(Byte4, 2)) - 2, 2)) then
    Result := false; //��һ�ֽ�
  if (PWD_3F_2 <> copy(IntToHex(Byte5, 2), length(IntToHex(Byte5, 2)) - 2, 2)) then
    Result := false; //�ڶ��ֽ�
  if (PWD_3F_3 <> copy(IntToHex(Byte6, 2), length(IntToHex(Byte6, 2)) - 2, 2)) then
    Result := false; //�����ֽ�

end;



//����ID�㷨

function Tfrm_SetParameter_BossINIT.SUANFA_ID_3F(StrCheckSum: string): string;
var
  Byte1, Byte2, Byte3: integer;
  temp, tempTOTAL1, tempTOTAL2, tempTOTAL3: integer; //2147483648 ���Χ

begin

  tempTOTAL1 := strToint('$' + Copy(StrCheckSum, 1, 2)) + strToint('$' + Copy(StrCheckSum, 3, 2)) + strToint('$' + Copy(StrCheckSum, 5, 2)) * strToint('$' + Copy(StrCheckSum, 7, 2));
    //Edit17.Text:=IntToStr(tempTOTAL1);
  Byte1 := (tempTOTAL1 * tempTOTAL1) mod 16; // �ڶ��ֽ�
  Byte2 := (tempTOTAL1 * tempTOTAL1) div 16; //�ڶ��ֽ�
  Byte3 := tempTOTAL1; //��һ�ֽ�
    //Byte2  Byte3  Byte1
  result := copy(IntToHex(Byte2, 2), length(IntToHex(Byte2, 2)) - 2, 2) + copy(IntToHex(Byte3, 2), length(IntToHex(Byte3, 2)) - 1, 2) + copy(IntToHex(Byte1, 2), length(IntToHex(Byte1, 2)) - 1, 2);

end;

//���������㷨 StrCheckSum����ID��strCUSTOMER_NO����

function Tfrm_SetParameter_BossINIT.SUANFA_Password_3F(StrCheckSum: string): string;
var
  Byte1, Byte2, Byte3: integer;
  temp, tempTOTAL1, tempTOTAL2, tempTOTAL3: integer; //2147483648 ���Χ

begin

  tempTOTAL1 := strToint('$' + Copy(StrCheckSum, 1, 2)) * strToint('$' + Copy(StrCheckSum, 3, 2)) + strToint('$' + Copy(StrCheckSum, 5, 2)); //ID_3F����
    //Edit18.Text:=IntToStr(tempTOTAL1);
  Byte1 := (tempTOTAL1 * tempTOTAL1) mod 16; ; //��һ�ֽ�
  Byte2 := (tempTOTAL1 * tempTOTAL1) div 16; //�ڶ��ֽ�
  Byte3 := tempTOTAL1; //�ڶ��ֽ�
     //Byte1  Byte2  Byte3
  result := copy(IntToHex(Byte1, 2), length(IntToHex(Byte1, 2)) - 2, 2) + copy(IntToHex(Byte2, 2), length(IntToHex(Byte2, 2)) - 2, 2) + copy(IntToHex(Byte3, 2), length(IntToHex(Byte3, 2)) - 2, 2);

end;

                                         //��ʼ��������ָ��

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


//���ҿ�����������

function Tfrm_SetParameter_BossINIT.Display_ID_TYPE(StrIDtype: string): string;
begin
  if (StrIDtype = copy(INit_Wright.User, 8, 2)) then //�����ܣ�����
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

//���ҿ�������ֵ

function Tfrm_SetParameter_BossINIT.Display_ID_TYPE_Value(StrIDtype: string): string;
begin
  if (StrIDtype = copy(INit_Wright.User, 1, 6)) then //�����ܣ�����
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


//���¿���Ϣ

procedure Tfrm_SetParameter_BossINIT.BitBtn_UpdateClick(Sender: TObject);
begin
  Operate_No := 2;
  ID_System := ICFunction.SUANFA_ID_3F(Edit_ID.Text); //���ü���ID_3F�㷨
  Password3F_System := ICFunction.SUANFA_Password_3F(Edit_ID.Text); //���ü���Password_3F�㷨
  INIT_Operation;


end;

procedure Tfrm_SetParameter_BossINIT.Query_SUM_Type(StrID: string; Query_Type: string);
begin
  if (LOAD_USER.ID_type = Copy(INit_Wright.BOSS, 8, 2)) or (LOAD_USER.ID_type = Copy(INit_Wright.Produecer_3F, 8, 2)) then //�ϰ忨���Լ����˲�����ť
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
    Edit13.Text := Query_User_LastBuy(StrID, Query_Type); //���һ�γ�ʼ��ʱ��
  end
  else if LOAD_USER.ID_type = Copy(INit_Wright.MANEGER, 8, 2) then //3F�����Լ����˲�����ť
  begin
    Edit11.Text := Query_User_infor(StrID, Query_Type, copy(INit_Wright.User, 8, 2));
    Edit12.Text := IntToStr(StrToInt(Edit11.Text));
    Edit13.Text := Query_User_LastBuy(StrID, Query_Type); //���һ�γ�ʼ��ʱ��
  end;


end;
//���ݵ�ǰ��ID��ѯ��Ӧ�û���̨�ˣ��������й�����¼��

function Tfrm_SetParameter_BossINIT.Query_User_infor(StrID: string; Query_Type: string; ID_Type_Input: string): string;
var
  ADOQ: TADOQuery;
  strSQL, strRet: string;
begin
  strRet := '0';
  if Query_Type = '1' then //���ݿ�ID��ѯ
    strSQL := 'select COUNT(ID_Type) from [USER_ID_INIT] where Customer_NO in (select distinct(Customer_NO)  from [3F_ID_INIT] where [ID_INIT]=''' + StrID + ''') and ID_type=''' + ID_Type_Input + ''''
  else if Query_Type = '2' then //���ݿͻ���Ų�ѯ
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


//���ݵ�ǰ��ID��ѯ��Ӧ�û���̨�ˣ��������й�����¼��

function Tfrm_SetParameter_BossINIT.Query_User_LastBuy(StrID: string; Query_Type: string): string;
var
  ADOQ: TADOQuery;
  strSQL, strRet: string;
begin
  strRet := '0';
  if Query_Type = '1' then //���ݿ�ID��ѯ
    strSQL := 'select Max(ID_Inittime) from [USER_ID_INIT] where Customer_NO in (select distinct(Customer_NO)  from [3F_ID_INIT] where [ID_INIT]=''' + StrID + ''') '
  else if Query_Type = '2' then //���ݿͻ���Ų�ѯ
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
