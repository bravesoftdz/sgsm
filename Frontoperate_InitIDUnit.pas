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
    procedure AnswerOper(); //��Ӧ�����Ϸ֡��·ֲ������¼�
  public
    { Public declarations }
    function exchData(orderStr: string): string;
    procedure INIT_Operation_Can_Check();
    procedure IncvalueComfir(S: string; S1: string);
    procedure sendData();
    procedure checkOper();
    procedure InitDataBase;
    procedure CheckCMD();
    procedure INcrevalue(S: string); //��ֵ����
    function CheckSUMData(orderStr: string): string; //У���
    function Make_Send_CMD(StrCMD: string; StrIncValue: string): string;
    function Select_IncValue_Byte(StrIncValue: string): string;
    function Select_CheckSum_Byte(StrCheckSum: string): string;
    function INit_Send_CMD(StrCMD: string; StrIncValue: string): string;
    function QueryCustomer_No(strphone: string): string;
    procedure init_comboBox_Menbertype;
    procedure INIT_Operation;
    //�����ʼ�����ݵ����ݿ�
    procedure Save_INit_Data;
    
      //ID�����ʶ��
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
    procedure InitCustomerName; //��ʼ���ͻ�������
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
//�رհ���
procedure Tfrm_Frontoperate_InitID.BitBtn18Click(Sender: TObject);
begin
  Close;
end;

//��¼��ʼ��
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


//ת�ҷ������ݸ�ʽ �����ַ�ת��Ϊ16���� 
function Tfrm_Frontoperate_InitID.exchData(orderStr: string): string;
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

//��鷵�ص�����

procedure Tfrm_Frontoperate_InitID.checkOper();
var
  i: integer;
begin
  case curOperNo of
    2: begin //�����������ֵ����
        for i := 0 to recData_fromICLst.Count - 1 do
          if copy(recData_fromICLst.Strings[i], 9, 2) <> '01' then // д�����ɹ���������
          begin
                       // recData_fromICLst.Clear;
            exit;
          end;
      end;
  end;
end;


//У��ͣ�ȷ���Ƿ���ȷ

function Tfrm_Frontoperate_InitID.CheckSUMData(orderStr: string): string;
var
  ii, jj, KK: integer;
  TmpStr: string;
  reTmpStr: string;
begin
    //if (length(orderStr)<>42) then
    //begin
    //    MessageBox(handle,'����������Ȳ���!','����',MB_ICONERROR+MB_OK);
    //    result:='';
    //    exit;
   // end;
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

function Tfrm_Frontoperate_InitID.Select_IncValue_Byte(StrIncValue: string): string;
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

function Tfrm_Frontoperate_InitID.Select_CheckSum_Byte(StrCheckSum: string): string;
var
  jj: integer;
  tempLH, tempLL: integer; //2147483648 ���Χ

begin
  jj := strToint('$' + StrCheckSum); //���ַ�תת��Ϊ16��������Ȼ��ת��λ10����
  tempLH := (jj mod 65536) div 256; //�ֽ�LH
  tempLL := jj mod 256; //�ֽ�LL

  result := IntToHex(tempLL, 2) + IntToHex(tempLH, 2);
end;


//�����ֵָ��

function Tfrm_Frontoperate_InitID.Make_Send_CMD(StrCMD: string; StrIncValue: string): string;
var
  TmpStr_IncValue: string; //��ֵ����
  TmpStr_CheckSum: string; //У���
  TmpStr_SendCMD: string; //ָ������
  reTmpStr: string;
begin
   // if (length(StrIncValue) mod 2)<>0 then
  begin
   //     MessageBox(handle,'����������ȴ���!','����',MB_ICONERROR+MB_OK);
   //     result:='';
    //    exit;
  end;

  Send_CMD_ID_Infor.CMD := StrCMD; //֡����
  Send_CMD_ID_Infor.ID_INIT := Receive_CMD_ID_Infor.ID_INIT;
  Send_CMD_ID_Infor.ID_3F := Receive_CMD_ID_Infor.ID_3F;
  Send_CMD_ID_Infor.Password_3F := Receive_CMD_ID_Infor.Password_3F;
  Send_CMD_ID_Infor.Password_USER := Receive_CMD_ID_Infor.Password_USER;
    //TmpStr_IncValue�ֽ���Ҫ�����Ų� �����StrIncValue>65535(FFFF)
   // TmpStr_IncValue:=IntToHex(strToint(StrIncValue),2);//��������ı�����ת��Ϊ16����
  TmpStr_IncValue := StrIncValue;
  Send_CMD_ID_Infor.ID_value := Select_IncValue_Byte(TmpStr_IncValue);

  Send_CMD_ID_Infor.ID_type := Receive_CMD_ID_Infor.ID_type;
    //���ܷ�������
  TmpStr_SendCMD := Send_CMD_ID_Infor.CMD + Send_CMD_ID_Infor.ID_INIT + Send_CMD_ID_Infor.ID_3F + Send_CMD_ID_Infor.Password_3F + Send_CMD_ID_Infor.Password_USER + Send_CMD_ID_Infor.ID_value + Send_CMD_ID_Infor.ID_type;
    //���������ݽ���У�˼���
  TmpStr_CheckSum := CheckSUMData(TmpStr_SendCMD);
    //TmpStr_CheckSum�ֽ���Ҫ�����Ų� �����ֽ���ǰ�����ֽ��ں�
  Send_CMD_ID_Infor.ID_CheckNum := Select_CheckSum_Byte(TmpStr_CheckSum);
  Send_CMD_ID_Infor.ID_Settime := Receive_CMD_ID_Infor.ID_Settime;


  reTmpStr := TmpStr_SendCMD + Send_CMD_ID_Infor.ID_CheckNum;

  result := reTmpStr;
end;





//��鷵�ص�����

procedure Tfrm_Frontoperate_InitID.AnswerOper();
var
  Send_value: string;
  RevComd: integer;
  ID_No: string;
  length_Data: integer;
  Dingwei: array[0..8] of string; //����ת���ȡ��֡��Ϣ
begin
  RevComd := 0;
   //���Ƚ�ȡ���յ���Ϣ

  Dingwei[1] := copy(recData_fromICLst.Strings[0], 1, 4); //֡ͷAA8A
  Dingwei[2] := copy(recData_fromICLst.Strings[0], 5, 4); //վ�ŵ�ַ
  Dingwei[3] := copy(recData_fromICLst.Strings[0], 9, 2); //�����ַ
  Dingwei[4] := copy(recData_fromICLst.Strings[0], 11, 2); //���ݳ��ȵ�ַ
       //�������ݳ���Dingwei[4]��ȡ���� Dingwei[5]
  length_Data := 2 * ICFunction.Str_HexToInt(Dingwei[4]);
  Dingwei[5] := copy(recData_fromICLst.Strings[0], 13, length_Data); //����-ID����

  Dingwei[6] := copy(recData_fromICLst.Strings[0], 13 + length_Data, 2); //������1
  Dingwei[7] := copy(recData_fromICLst.Strings[0], 13 + length_Data + 2, 2); //������2

  if Dingwei[3] = 'A1' then //A1��ʾICȡ���˿�ID,��PCҪ��ȡIC�Ŀ�ID
  begin
    RevComd := 1;
  end;
  if Dingwei[3] = 'B1' then //B1��ʾIC�ɹ���ȡ�˿�ֵ
  begin
    RevComd := 2;
  end;
  if Dingwei[3] = 'B2' then //B2��ʾIC�ɹ�д�뿨ֵ
  begin
    RevComd := 3;
  end;
   //�ж����ָ�����ж�Ӧ����
  case RevComd of
    1: begin //��Ѱ���ɹ�
        Edit_ID.Text := Dingwei[5];
        recData_fromICLst.Clear;
        RevComd := 0;
                //ϵͳ�����¼��Ӧ��̨������־  ����Dingwei[2]
                //Record_MC_Operate
      end;
    2: begin //�ɹ���ȡ��ֵ
        Edit_ID.Text := Copy(Dingwei[5], 1, 8);
        Edit_PrintNO.Text := Copy(Dingwei[5], 9, 2);
        if (Dingwei[5] = '02') then
          Edit_OPResult.Text := 'Ѱ������ֵʧ��'
        else
          Edit_OPResult.Text := 'Ѱ������ֵ�ɹ�';

                //Send_B1();
        recData_fromICLst.Clear;
        RevComd := 0;

                 //�ظ�IC��ȷ���Ѿ��յ���ȡ��ʣ��ֵ
                //ϵͳ�����¼��Ӧ��̨������־  ����Dingwei[2]
                //Record_MC_Operate
      end;
    3: begin //�ɹ�д�뿨ֵ
        if (Dingwei[5] = '02') then
          Edit_OPResult.Text := 'дֵʧ��'
        else
          IncvalueComfir(Edit_ID.Text, INC_value); //��һ����Ϊ��ID�ţ��ڶ���λ��ֵ���
        Edit_OPResult.Text := 'дֵ�ɹ�';
        recData_fromICLst.Clear;
        RevComd := 0;
                //ϵͳ�����¼��Ӧ��̨������־  ����Dingwei[2]
                //Record_MC_Operate
      end;
  end;
end;

//���ڼ�������
procedure Tfrm_Frontoperate_InitID.comReaderReceiveData(Sender: TObject;
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
     //if  (tmpStrend='END') then
  begin
    INIT_Operation_Can_Check; 
    if INIT_Operation_Can then
    begin
      CheckCMD(); //���ȸ��ݽ��յ������ݽ����жϣ�ȷ�ϴ˿��Ƿ�����Ϊ��ȷ�Ŀ�
         //AnswerOper();//���ȷ���Ƿ�����Ҫ�ظ�IC��ָ��
    end;
  end;
    //����---------------
  if curOrderNo < orderLst.Count then // �ж�ָ���Ƿ��Ѿ���������ϣ����ָ�����С��ָ���������������
    sendData()
  else begin
    checkOper();
  end;

end;


//����Ƿ��ô���������(����Ƿ��Ѿ�����ͻ����ƣ��ͻ����)

procedure Tfrm_Frontoperate_InitID.INIT_Operation_Can_Check();
var
  temp1: string;
begin

  INIT_Operation_Can := true;
  temp1 := '����ѡ��ͻ�����';
  if Customer_Phone.Text = temp1 then
    INIT_Operation_Can := false;
  temp1 := '����ѡ��ͻ����';
  if CUSTOMER_NO.Text = temp1 then
    INIT_Operation_Can := false;
end;

//���ݽ��յ��������жϴ˿��Ƿ�Ϊ�Ϸ���

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
   //���Ƚ�ȡ���յ���Ϣ

  ComboBox_Menbertype.Items.Clear;
  init_comboBox_Menbertype; //��ʼ�� ComboBox_Menbertype

  tmpStr := recData_fromICLst.Strings[0];
  Edit1.Text := recData_fromICLst.Strings[0];
  Receive_CMD_ID_Infor.ID_CheckNum := copy(tmpStr, 39, 4); //У���

      // if (CheckSUMData(copy(tmpStr, 1, 38))=copy(tmpStr, 41, 2)+copy(tmpStr, 39, 2)) then//У���
  begin
    CMD_CheckSum_OK := true;
    Receive_CMD_ID_Infor.CMD := copy(recData_fromICLst.Strings[0], 1, 2); //֡ͷ43
  end;

  //1���жϴ˿��Ƿ�Ϊ�Ѿ���ɳ�ʼ��
  if Receive_CMD_ID_Infor.CMD = CMD_COUMUNICATION.CMD_INCValue_RE then
  begin

    if (Customer_Phone.Text <> '') and (CUSTOMER_NO.Text <> '') and (Edit_ID.Text <> '') then
    begin
      if (Operate_No = 1) then //���浱ǰ���ĳ�ʼ����¼
      begin
        Save_INit_Data;
        Edit_OPResult.Text := '��ʼ������������ɹ�';
      end
      else if (Operate_No = 2) then //�˴���Ϊ׷�ӵĸ����¼�
      begin
        Save_INit_update;
        Edit_OPResult.Text := '���²���������ɹ�';
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

    ICFunction.loginfo('������ʼ�� Receive_CMD_ID_Infor.ID_INIT '+ Receive_CMD_ID_Infor.ID_INIT );
    ICFunction.loginfo('������ʼ�� Receive_CMD_ID_Infor.ID_3F '+ Receive_CMD_ID_Infor.ID_3F );
    ICFunction.loginfo('������ʼ�� Receive_CMD_ID_Infor.Password_3F '+ Receive_CMD_ID_Infor.Password_3F );
    ICFunction.loginfo('������ʼ�� Receive_CMD_ID_Infor.Password_USER '+ Receive_CMD_ID_Infor.Password_USER );
    ICFunction.loginfo('������ʼ�� Receive_CMD_ID_Infor.ID_value '+ Receive_CMD_ID_Infor.ID_value );
    ICFunction.loginfo('������ʼ�� Receive_CMD_ID_Infor.ID_type '+ Receive_CMD_ID_Infor.ID_type );
    
    

                 //1���ж��Ƿ�������ʼ���� �㷨����/���ܣ��������ִ�в���2 ICFunction.
    if ICFunction.CHECK_3F_ID(Receive_CMD_ID_Infor.ID_INIT, Receive_CMD_ID_Infor.ID_3F, Receive_CMD_ID_Infor.Password_3F) then
    begin
                //2�����ȷ������˳�ʼ�������һ���жϴ˿������ݿ����Ƿ��м�¼
      if DataModule_3F.Query_ID_INIT_OK(Receive_CMD_ID_Infor.ID_INIT) then //�м�¼
      begin
        Edit_ID.Text := Receive_CMD_ID_Infor.ID_INIT; //��ID
                         //MessageBox(handle,'��ǰ���Ѿ���ʼ��!��֪ͨ�ϰ壡��ʱ���ٴ��ˣ�','����',MB_ICONERROR+MB_OK);
        Edit14.Text := '��ǰ��Ϊ' + Display_ID_TYPE(Receive_CMD_ID_Infor.ID_type) + '----��ʼ���ɹ�'; //��ID

                         //�Ѵ˿���Ӧ��������Ϣ��ѯ������ʾ���Թ��޸���
        if (not CheckBox_Update.Checked) then
          Query_for_update(Edit_ID.Text); //��ѯ�˿���Ӧ�ļ�¼

        Query_SUM_Type(Edit_ID.Text, '1'); //��ѯ�˿���Ӧ���û�̨��
                              
        ID_Password_USER.Text := INit_Wright.BossPassword;
                         //exit;
      end
      else //�޼�¼
      begin
        Edit_ID.Text := Receive_CMD_ID_Infor.ID_INIT; //��ID
        ID_System := ICFunction.SUANFA_ID_3F(Edit_ID.Text); //���ü���ID_3F�㷨
        Password3F_System := ICFunction.SUANFA_Password_3F(Edit_ID.Text); //���ü���Password_3F�㷨
        if CUSTOMER_NO.Text <> '' then
        begin
          Operate_No := 1;
          INIT_Operation; //���ó�ʼ�����������¼�
        end
        else
        begin
          Edit14.Text := '�ͻ���Ų���Ϊ�գ��뽫��ȡ�ߣ���д���ٷſ�';
          exit;
        end;
                         // exit;
      end;
    end
    else //��δ��ʼ�����Ŀ�
    begin
            //׷���ж��ֻ��������Ϳͻ����������Ƿ�Ϊ�գ�ͬʱҪ��ID�����Ϊ�գ���ֹID�غű�������
            //�����Ϊ�����Զ�ִ�г�ʼ������
      Edit_ID.Text := Receive_CMD_ID_Infor.ID_INIT; //��ID
      if (Customer_Phone.Text <> '') and (CUSTOMER_NO.Text <> '') and (Edit_ID.Text <> '') then
      begin
        ID_System := ICFunction.SUANFA_ID_3F(Edit_ID.Text); //���ü���ID_3F�㷨
        Password3F_System := ICFunction.SUANFA_Password_3F(Edit_ID.Text); //���ü���Password_3F�㷨
        INIT_Operation; //���ó�ʼ�����������¼�
        Operate_No := 1;
      end;

    end;

  end;

end;


//��ʼ������

procedure Tfrm_Frontoperate_InitID.INIT_Operation;
var
  INC_value: string;
  strValue: string;
begin
  if Edit_ID.Text = '' then
  begin
    MessageBox(handle, '�޿�!�����Ҳ���', '����', MB_ICONERROR + MB_OK);
    exit;
  end;
  if Customer_Phone.Text = '' then
  begin
    MessageBox(handle, '�ֻ���δ��д!�����Ҳ���', '����', MB_ICONERROR + MB_OK);
    exit;
  end;

  begin
    INC_value := '0000'; //��ֵ��ֵ
    INC_value := '00000000'; //��ֵ��ֵ
    strValue := INit_Send_CMD(CMD_COUMUNICATION.CMD_INCValue, INC_value); //�����ֵָ��
    Edit19.Text := strValue;
    INcrevalue(strValue); //д��ID��
  end;
end;


//��ʼ��������ָ��

function Tfrm_Frontoperate_InitID.INit_Send_CMD(StrCMD: string; StrIncValue: string): string;
var
  TmpStr_IncValue: string; //��ֵ����
  TmpStr_CheckSum: string; //У���
  TmpStr_SendCMD: string; //ָ������
  reTmpStr: string;
begin

  INit_3F.CMD := StrCMD; //֡����
  INit_3F.ID_INIT := Edit_ID.Text; //��ID

    //Password3F_System ��ID_System��������������������û���Żس�ʱִ�����ɵ�
  INit_3F.ID_3F := copy(Password3F_System, 5, 2) + copy(ID_System, 1, 2) + copy(Password3F_System, 3, 2);
  ID_3F.Text := INit_3F.ID_3F;
 
  INit_3F.Password_3F := INit_Wright.BossPassword; //ֱ�Ӷ�ȡ�����ļ��еĳ������� (PC����������)
  ID_Password_3F.Text := INit_3F.Password_3F; //�û��������룬�������ĵ�����

  ID_Password_USER.Text := INit_Wright.BossPassword; //ֱ�Ӷ�ȡ�����ļ��еĳ�������  (PC����������)
  INit_3F.Password_USER := INit_Wright.BossPassword; //�û��������룬�������ĵ�����  (PC����������)

  TmpStr_IncValue := COPY(INit_3F.ID_3F, 3, 2) + ICFunction.SUANFA_Password_USER_WritetoID(INit_3F.ID_3F, CUSTOMER_NO.Text);
  INit_3F.ID_value := TmpStr_IncValue;


  INit_3F.ID_type := Display_ID_TYPE_Value(ComboBox_Menbertype.Text); //ȡ�ÿ����͵�ֵ
  Edit20.Text := ID_Password_USER.Text;
    //���ܷ�������
  TmpStr_SendCMD := INit_3F.CMD + INit_3F.ID_INIT + INit_3F.ID_3F + INit_3F.Password_3F + ID_Password_USER.Text + INit_3F.ID_value + INit_3F.ID_type;
   //TmpStr_SendCMD:=ָ��֡ͷ+ ��ID+ 3F����ID + 3F��������+   �û���������  +   3F������ʼ��ֵ  + 3F������ʼ������

    //���������ݽ���У�˼���
  TmpStr_CheckSum := CheckSUMData(TmpStr_SendCMD);
    //TmpStr_CheckSum�ֽ���Ҫ�����Ų� �����ֽ���ǰ�����ֽ��ں�
  INit_3F.ID_CheckNum := Select_CheckSum_Byte(TmpStr_CheckSum);
  ID_CheckSum.Text := Select_CheckSum_Byte(TmpStr_CheckSum);


   // INit_3F.ID_Settime:=Receive_CMD_ID_Infor.ID_Settime;


  reTmpStr := TmpStr_SendCMD + INit_3F.ID_CheckNum;

  result := reTmpStr;
end;


//д��ID��----------------------------------------

procedure Tfrm_Frontoperate_InitID.INcrevalue(S: string);
begin
  orderLst.Clear();
  recDataLst.Clear();
  curOrderNo := 0;
  curOperNo := 2;
  Edit1.Text := s;
  orderLst.Add(S); //����ֵд�����
  sendData();
end;


//���������ʼ�����ݵ����ݿ�  
procedure Tfrm_Frontoperate_InitID.Save_INit_Data;
var
  strOperator, strinputdatetime: string;
label ExitSub;
begin

  strOperator := G_User.UserNO;
  strinputdatetime := DateTimetostr((now())); //¼��ʱ�䣬��ȡϵͳʱ��


  with ADOQuery_Init do begin
    //Searches the dataset for a specified record and makes that record the current record.
    if (Locate('ID_INIT', INit_3F.ID_INIT, [])) then begin   

      Edit1.Text := 'ID��  ' + INit_3F.ID_INIT + '  �Ŀ���ʼ����Ϣ�����,������������';
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

  init_comboBox_Menbertype;//��ʼ�����ӱҹ�������
  InitDataBase; //��ʾ���е��ӱҳ�ʼ�����
  InitCustomerName;//��ʼ���ͻ�����������
  
  Customer_Phone.Text := '����ѡ��ͻ�����';
  CUSTOMER_NO.Text := '����ѡ��ͻ����';

  Edit_ID.Text := '';
  ID_3F.Text := '';
  ID_Password_3F.Text := '';
  ID_Password_USER.Text := '';
  ID_Value.Text := '';
  Edit1.Text := '����ѡ��ͻ����ƣ�Ȼ��ѡ���û���ţ��ٽ������ڶ������Ϸ�';
end;



procedure Tfrm_Frontoperate_InitID.FormClose(Sender: TObject; var Action: TCloseAction);
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

procedure Tfrm_Frontoperate_InitID.IncvalueComfir(S: string; S1: string);

var
  strIDNo, strName, strUserNo, strIncvalue, strGivecore, strOperator, strhavemoney, strinputdatetime: string;
  i: integer;
label ExitSub;
begin

  strIDNo := Edit_ID.Text;
  strOperator := G_User.UserNO; //����Ա
  strinputdatetime := DateTimetostr((now())); //¼��ʱ�䣬��ȡϵͳʱ��

  with ADOQuery_Init do begin
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


procedure Tfrm_Frontoperate_InitID.FormCreate(Sender: TObject);
begin

  //   EventObj:=EventUnitObj.Create;
  //   EventObj.LoadEventIni;

end;

//���û�����һ�γ�ʼ��

procedure Tfrm_Frontoperate_InitID.BitBtn_INITClick(Sender: TObject);
begin
  Operate_No := 1;
  INIT_Operation;

end;

//���ҿͻ����

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
//   INit_3F.ID_type:=Display_ID_TYPE_Value(ComboBox_Menbertype.Text); //ȡ�ÿ����͵�ֵ
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
  //ID�����ʶ��

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


    //����ID
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
    //Edit11.Text:=copy(IntToHex(Byte4,2),length(IntToHex(Byte4,2))-2,2);
    //Edit12.Text:=copy(IntToHex(Byte5,2),length(IntToHex(Byte5,2))-2,2);
    //Edit13.Text:=copy(IntToHex(Byte6,2),length(IntToHex(Byte6,2))-2,2);

  if (PWD_3F_1 <> copy(IntToHex(Byte4, 2), length(IntToHex(Byte4, 2)) - 2, 2)) then
    Result := false; //��һ�ֽ�
  if (PWD_3F_2 <> copy(IntToHex(Byte5, 2), length(IntToHex(Byte5, 2)) - 2, 2)) then
    Result := false; //�ڶ��ֽ�
  if (PWD_3F_3 <> copy(IntToHex(Byte6, 2), length(IntToHex(Byte6, 2)) - 2, 2)) then
    Result := false; //�����ֽ�

end;



//����ID�㷨

function Tfrm_Frontoperate_InitID.SUANFA_ID_3F(StrCheckSum: string): string;
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

function Tfrm_Frontoperate_InitID.SUANFA_Password_3F(StrCheckSum: string): string;
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



//���ݵ�ǰ��ID��ѯ���ڿ��е������Ϣ��������������

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

//�����������б�ʵʼ��
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


//���ҿ�����������

function Tfrm_Frontoperate_InitID.Display_ID_TYPE(StrIDtype: string): string;
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

function Tfrm_Frontoperate_InitID.Display_ID_TYPE_Value(StrIDtype: string): string;
begin
  if (StrIDtype = copy(INit_Wright.User, 1, 6)) then //�����ܣ�����   //�û���
    result := copy(INit_Wright.User, 8, 2)
 // else if (StrIDtype = copy(INit_Wright.Produecer_3F, 1, 6)) then                                //���ܿ�
  //  result := copy(INit_Wright.Produecer_3F, 8, 2)
  else if (StrIDtype = copy(INit_Wright.BOSS, 1, 6)) then                                //�ϰ忨
    result := copy(INit_Wright.BOSS, 8, 2)
  else if (StrIDtype = copy(INit_Wright.MANEGER, 1, 6)) then                     //����
    result := copy(INit_Wright.MANEGER, 8, 2)
 // else if (StrIDtype = copy(INit_Wright.QUERY, 1, 6)) then               //���˿�
 //   result := copy(INit_Wright.QUERY, 8, 2)
  else if (StrIDtype = copy(INit_Wright.RECV_CASE, 1, 6)) then   //������
    result := copy(INit_Wright.RECV_CASE, 8, 2)
 // else if (StrIDtype = copy(INit_Wright.SETTING, 1, 6)) then       //���ÿ�
 //   result := copy(INit_Wright.SETTING, 8, 2)
  else if (StrIDtype = copy(INit_Wright.OPERN, 1, 6)) then //������
    result := copy(INit_Wright.OPERN, 8, 2);

end;


//���¿���Ϣ

procedure Tfrm_Frontoperate_InitID.BitBtn_UpdateClick(Sender: TObject);
begin
  Operate_No := 2;
  ID_System := ICFunction.SUANFA_ID_3F(Edit_ID.Text); //���ü���ID_3F�㷨
  Password3F_System := ICFunction.SUANFA_Password_3F(Edit_ID.Text); //���ü���Password_3F�㷨
  INIT_Operation;
end;



//���³�ʼ������

procedure Tfrm_Frontoperate_InitID.Save_INit_update;
var
  strOperator, strinputdatetime: string;
label ExitSub;
begin

  strOperator := G_User.UserNO;
  strinputdatetime := DateTimetostr((now())); //¼��ʱ�䣬��ȡϵͳʱ��
  INit_3F.ID_type := Display_ID_TYPE_Value(ComboBox_Menbertype.Text); //ȡ�ÿ����͵�ֵ
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


//ѡ��˿��ؽ��رմ��ڣ�Ŀ����Ϊ�˿��Ա༭�ı���

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



//���ݵ�ǰ��ID��ѯ��Ӧ�û���̨�ˣ��������й�����¼��

function Tfrm_Frontoperate_InitID.Query_User_LastBuy(StrID: string; Query_Type: string): string;
var
  ADOQ: TADOQuery;
  strSQL, strRet: string;
begin
  strRet := '0';
  if Query_Type = '1' then //���ݿ�ID��ѯ
    strSQL := 'select Max(ID_Inittime) from [3F_ID_INIT] where Customer_NO in (select distinct(Customer_NO)  from [3F_ID_INIT] where [ID_INIT]=''' + StrID + ''') '
  else if Query_Type = '2' then //���ݿͻ���Ų�ѯ
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

//��ʼ���ͻ�����������
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
    ShowMessage('��̨��Ϸ���Ʋ��ܿ�');
    exit;
  end
  else
  begin
    InitCarMC_ID(Customer_Phone.text); //��ѯ�ÿͻ���Ӧ�ĳ��ر��
  end;
end;

 //��ʼ���ͻ����ر��

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

  if trim(CUSTOMER_NO.Text) = '' then //�����ͻ�
  begin
    ShowMessage('��ȷ������Ŀͻ�����Ƿ���ȷ��');
    exit;
  end;

  if Edit_ID.Text <> '' then
  begin
    ID_System := ICFunction.SUANFA_ID_3F(Edit_ID.Text);
    Password3F_System := ICFunction.SUANFA_Password_3F(Edit_ID.Text);
    ID_3F.Text := ICFunction.SUANFA_ID_3F(Edit_ID.Text);
    ID_Password_3F.Text := ICFunction.SUANFA_Password_3F(Edit_ID.Text);
    Query_SUM_Type(CUSTOMER_NO.Text, '2'); //���ݿͻ���ţ�������ع��ܿ���������Ϣ
    ComboBox_Menbertype.setfocus;
  end
  else
  begin
    ShowMessage('�뽫������ӱҷ��ڿ�ͷ�Ϸ���');
    exit;
  end;
end;

//���ݿͻ���ţ�������ع��ܿ���������Ϣ
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
//���ݵ�ǰ��ID��ѯ��Ӧ�û���̨�ˣ��������й�����¼��

function Tfrm_Frontoperate_InitID.Query_User_infor(StrID: string; Query_Type: string; ID_Type_Input: string): string;
var
  ADOQ: TADOQuery;
  strSQL, strRet: string;
begin
  strRet := '0';
  if Query_Type = '1' then //���ݿ�ID��ѯ
    strSQL := 'select COUNT(ID_Type) from [3F_ID_INIT] where Customer_NO in (select distinct(Customer_NO)  from [3F_ID_INIT] where [ID_INIT]=''' + StrID + ''') and ID_type=''' + ID_Type_Input + ''''
  else if Query_Type = '2' then //���ݿͻ���Ų�ѯ
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
