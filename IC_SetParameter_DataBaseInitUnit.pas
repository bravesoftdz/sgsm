unit IC_SetParameter_DataBaseInitUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, IniFiles,
  Dialogs, DB, ADODB, StdCtrls, Buttons, ExtCtrls, SPComm;

type
  Tfrm_IC_SetParameter_DataBaseInit = class(TForm)
    Panel1: TPanel;
    GroupBox5: TGroupBox;
    Panel2: TPanel;
    Bit_Add: TBitBtn;
    Bit_Close: TBitBtn;
    ADOQuery_newCustomer: TADOQuery;
    DataSource_Newmenber: TDataSource;
    Panel3: TPanel;
    Label2: TLabel;
    Comb_Customer_Name: TComboBox;
    Label8: TLabel;
    Edit_Customer_NO: TEdit;
    Panel4: TPanel;
    Label1: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Comm_Check: TComm;
    Timer_HAND: TTimer;
    Timer_USERPASSWORD: TTimer;
    Timer_3FPASSWORD: TTimer;
    Panel_Message: TPanel;
    Timer_3FLOADDATE: TTimer;
    Edit1: TEdit;
    procedure Bit_AddClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Comm_CheckReceiveData(Sender: TObject; Buffer: Pointer;
      BufferLength: Word);
    procedure Timer_HANDTimer(Sender: TObject);
    procedure Timer_USERPASSWORDTimer(Sender: TObject);
    procedure Timer_3FPASSWORDTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Bit_CloseClick(Sender: TObject);
    procedure Comb_Customer_NameClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure Timer_3FLOADDATETimer(Sender: TObject);
  private
    { Private declarations }

    procedure CheckCMD_Right(); //ϵͳ����Ȩ���жϣ�ȷ���Ƿ�����ܹ�Ψһ��Ӧ
    procedure INcrevalue(S: string); //��ֵ����
    procedure sendData();
        //������������ָ��
    procedure SendCMD_HAND;
    function exchData(orderStr: string): string;
    //���Ͷ�ȡ������������ָ��
    procedure SendCMD_USERPASSWORD;
    procedure SendCMD_3FPASSWORD; //����3F�������루ϵͳ��ţ�ȷ������ָ��
    procedure SendCMD_3FLOADDATE; //д���½����
    function Check_CustomerName(str1: string; str2: string): Boolean;
    function Check_CustomerNO(str1: string; str2: string): Boolean;
    function Make_Send_CMD_PasswordIC(StrCMD: string; StrIncValue: string): string;
    function CheckSUMData_PasswordIC(orderStr: string): string;
    procedure QueryCustomerNo(str1: string);
  public
    { Public declarations }
    procedure InitCombo_MCname; //��ʼ���ͻ����������
    procedure DeleteTestDataFromTable; //ɾ����������
    procedure WriteCustomerNameToIniFile; //д������ͻ���� ����������������ļ�
    procedure WriteCustomerNameToFlash; //д������ͻ���� ��������������ܿ���ͨ������ʵ��

    procedure SaveData_CustomerInfor; //���桢���³�����¼
    function Select_IncValue_Byte(StrIncValue: string): string;
    function Select_CheckSum_Byte(StrCheckSum: string): string;
  end;

var
  frm_IC_SetParameter_DataBaseInit: Tfrm_IC_SetParameter_DataBaseInit;
  CustomerName_check: string; //ϵͳ���
  BossPassword_check: string; //PC����������
  BossPassword_old_check: string; //PC����������
  BossPassword_3F_check: string; //PCд��������
  strtime: string; //�趨ʱ��

  Check_Count, Check_Count_3FPASSWORD, Check_Count_USERPASSWORD, Check_Count_3FLOADDATE: integer;
  orderLst, recDataLst, recData_fromICLst, recData_fromICLst_Check: Tstrings;
  LOAD_CHECK_OK_RE, LOAD_3FPASSWORD_OK_RE, LOAD_USERPASSWORD_OK_RE, LOAD_3FLOADDATE_OK_RE: BOOLEAN;
  WriteToFile_OK, WriteToFlase_OK: BOOLEAN;
implementation

uses ICDataModule, ICCommunalVarUnit, ICmain, ICEventTypeUnit, ICFunctionUnit,
  Logon;

{$R *.dfm}

procedure Tfrm_IC_SetParameter_DataBaseInit.Bit_AddClick(Sender: TObject);

begin
  strtime := FormatDateTime('HH:mm:ss', now);

  if length(Edit_Customer_NO.Text) = 0 then
  begin
    Panel_Message.Caption := '�����������벻��Ϊ�գ�';
    exit;
  end
  else
  begin


    if (MessageDlg('�밲װ���Ӽ��ܿ���ȷ����Ҫ�������ݿ⡢�����ļ���ʼ��������', mtInformation, [mbYes, mbNo], 0) = mrYes) then
    begin

      WriteCustomerNameToIniFile; //д������ͻ���š���������������ĵ�

      if WriteToFile_OK then
      begin
        Edit1.Text:='1111';
        WriteCustomerNameToFlash; //д������ͻ���� ��������������ܿ���ͨ������ʵ��
                         //DeleteTestDataFromTable;//ɾ����������(�ڴ��ڴ����¼���ִ�У��ȴ�д����ܳɹ�����)
                         //SaveData_CustomerInfor; //���桢���³�����¼(�ڴ��ڴ����¼���ִ�У��ȴ�д����ܳɹ�����)
      end;


    end
    else
    begin
      exit;
    end;
  end;


end;
//ɾ����������

procedure Tfrm_IC_SetParameter_DataBaseInit.DeleteTestDataFromTable;
var
  ADOQ: TADOQuery;
  strSQL: string;
begin
//1����������ͻ���[3F_Customer_Infor]

  strSQL := 'delete  from '
    + ' [3F_Customer_Infor] where Customer_Name<>''' + TrimRight(Comb_Customer_Name.Text) + '''';

  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    ADOQ.Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    ADOQ.ExecSQL;
  end;
  FreeAndNil(ADOQ);

//2������������س�ʼ����[USER_ID_INIT]
{
  strSQL:='delete  from '
  +' [USER_ID_INIT]';

  ADOQ:=TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    ADOQ.Active:=false;
    SQL.Clear;
    SQL.Add(strSQL);
    ADOQ.ExecSQL;
    end;
  FreeAndNil(ADOQ);
}
//3�����������Ϸ���Ʊ�[TGameSet]
  strSQL := 'delete  from '
    + ' [TGameSet]';

  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    ADOQ.Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    ADOQ.ExecSQL;
  end;
  FreeAndNil(ADOQ);


 //4�����������Ϸ���Ʊ�[TChargMacSet]
  strSQL := 'delete  from '
    + ' [TChargMacSet]';

  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    ADOQ.Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    ADOQ.ExecSQL;
  end;
  FreeAndNil(ADOQ);

  //5��������������¼��[TClassChangeInfor]
  strSQL := 'delete  from '
    + ' [TClassChangeInfor]';

  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    ADOQ.Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    ADOQ.ExecSQL;
  end;
  FreeAndNil(ADOQ);

    //6�����������ͷID��ʼ����[TCardHead_Init]
  strSQL := 'delete  from '
    + ' [TCardHead_Init]';

  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    ADOQ.Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    ADOQ.ExecSQL;
  end;
  FreeAndNil(ADOQ);

  //7�����������ֵ��¼��[EBdetail]
  strSQL := 'delete  from '
    + ' [EBdetail]';

  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    ADOQ.Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    ADOQ.ExecSQL;
  end;
  FreeAndNil(ADOQ);

    //8���������ɨ��һ���[3F_BARFLOW]
  strSQL := 'delete  from '
    + ' [3F_BARFLOW]';

  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    ADOQ.Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    ADOQ.ExecSQL;
  end;
  FreeAndNil(ADOQ);

  //9���������ɨ��һ���[3F_ID_INIT]
  strSQL := 'delete  from '
    + ' [3F_ID_INIT]';

  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    ADOQ.Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    ADOQ.ExecSQL;
  end;
  FreeAndNil(ADOQ);

  //10����������û���[3F_SysUser]��ֻ�������Ϊ000001

  strSQL := 'delete  from '
    + ' [3F_SysUser] Where UserNo<>''000001''';

  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    ADOQ.Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    ADOQ.ExecSQL;
  end;
  FreeAndNil(ADOQ);

    //11����������û���[3F_RIGHT_SET]��ֻ�������Ϊ000001

  strSQL := 'delete  from '
    + ' [3F_RIGHT_SET] Where UserNo<>''000001''';

  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    ADOQ.Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    ADOQ.ExecSQL;
  end;
  FreeAndNil(ADOQ);

      //12����������û���ֵ��[TMembeDetail]��

  strSQL := 'delete  from '
    + ' [TMembeDetail]';

  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    ADOQ.Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    ADOQ.ExecSQL;
  end;
  FreeAndNil(ADOQ);

        //13����������û�Ա��[TMemberInfo]��

  strSQL := 'delete  from '
    + ' [TMemberInfo]';

  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    ADOQ.Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    ADOQ.ExecSQL;
  end;
  FreeAndNil(ADOQ);


  

  strSQL := 'delete  from  [T_3F_INITIALRECORD]';
  ICFunction.loginfo(' ���ݿ��ʼ��  ' +strSQL);
  DataModule_3F.executesql(strSQL);
  
  

end;

//���������ļ���д������ͻ���š���������������ļ�

procedure Tfrm_IC_SetParameter_DataBaseInit.WriteCustomerNameToIniFile;
var
  myIni: TiniFile;

  System_No: string; //ϵͳ���
  BossPassword: string; //�û���������
  LOADDATE: string; //�û���������
begin

   //�жϼ���õ��������Ƿ���ԭ��������һ��
  System_No := Comb_Customer_Name.Text; //ϵͳ���
  BossPassword := Edit_Customer_NO.Text; //��������
  LOADDATE := COPY(strtime, 1, 1) + COPY(strtime, 5, 1) + COPY(strtime, 2, 1) + COPY(strtime, 4, 1); //�趨ʱ��
  if FileExists(SystemWorkGroundFile) then
  begin
    myIni := TIniFile.Create(SystemWorkGroundFile);

    myIni.WriteString('PLC��������', 'PC�ͻ����', System_No); //д��ͻ����
    myIni.WriteString('PLC��������', 'PCд��������', BossPassword); //д���������תֵ
    myIni.WriteString('PLC��������', 'PC����������', BossPassword); //д��������
    myIni.WriteString('PLC��������', 'PC����������', BossPassword); //д��������
    myIni.WriteString('����������', '�趨ʱ��', LOADDATE); //д��������

    CustomerName_check := MyIni.ReadString('PLC��������', 'PC�ͻ����', 'D60993'); //
    BossPassword_check := MyIni.ReadString('PLC��������', 'PC����������', 'D60993'); //
    BossPassword_old_check := MyIni.ReadString('PLC��������', 'PC����������', 'D60993'); //
    BossPassword_3F_check := MyIni.ReadString('PLC��������', 'PCд��������', 'D60993'); //��ȡ���ʹ�õ����루���������룩

    INit_Wright.BossPassword := BossPassword_3F_check; //����ϵͳʹ�õĳ�������

    FreeAndNil(myIni);

    if CustomerName_check = System_No then
    begin
      if (BossPassword = BossPassword_old_check) and (BossPassword_check = BossPassword_old_check) and (BossPassword_old_check = BossPassword_3F_check) then
      begin
        WriteToFile_OK := true;
        Panel_Message.Caption := 'ȫ��д�������ĵ��ɹ�';
      end
      else
      begin
        Panel_Message.Caption := '��������д�������ĵ�����';
        exit;
      end;
    end
    else
    begin
      Panel_Message.Caption := 'ϵͳ���д�������ĵ�����';
      exit;

    end;

  end;

end;

//���������ļ���д������ͻ���š�������������ܿ�

procedure Tfrm_IC_SetParameter_DataBaseInit.WriteCustomerNameToFlash;
var
  System_No: string; //ϵͳ���
  BossPassword: string; //�û���������
begin
  Timer_HAND.Enabled := true; //��ʼ�����ܹ����ֶ�ʱ��

          //CustomerName_check:= MyIni.ReadString('PLC��������','PC�ͻ����','D60993');//
          //BossPassword_check:= MyIni.ReadString('PLC��������','PC����������','D60993');//
          //BossPassword_old_check:= MyIni.ReadString('PLC��������','PC����������','D60993');//
          //BossPassword_3F_check:= MyIni.ReadString('PLC��������','PCд��������','D60993');//��ȡ���ʹ�õ����루���������룩

end;

//���浱ǰ��¼

procedure Tfrm_IC_SetParameter_DataBaseInit.SaveData_CustomerInfor;
var
  strSQL: string;
  str1: string;
  strTemp: string;
begin
  strTemp := Comb_Customer_Name.Text;
  strSQL := 'select * from [3F_Customer_Infor] where Customer_Name=''' + strTemp + '''';
  with ADOQuery_newCustomer do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := true;
    Edit;
    FieldByName('OUTFactory_Time').AsString := FormatDateTime('yyyy-MM-dd HH:mm:ss', now); //��Ʊʱ�� (��Ҫ����)
    Post;
    Active := False;
  end;
end;

procedure Tfrm_IC_SetParameter_DataBaseInit.FormShow(Sender: TObject);
begin


  CustomerName_check := '';
  BossPassword_check := '';
  BossPassword_old_check := '';
  BossPassword_3F_check := '';

  recData_fromICLst_Check := TStringList.Create;
  orderLst := TStringList.Create;


  InitCombo_MCname; //��ʼ���¿ͻ����������

  Comm_Check.StartComm(); //�������ܹ�����ȷ��



end;

procedure Tfrm_IC_SetParameter_DataBaseInit.InitCombo_MCname; //��ʼ����Ϸ����������
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  nameStr, strtemp: string;
  i: integer;
begin
  Comb_Customer_Name.Items.Clear;
  strtemp := '0';
  ADOQTemp := TADOQuery.Create(nil);
  //strSQL := 'select distinct[Customer_Name] from [3F_Customer_Infor] where OUTFactory_Time=''' + strtemp + '''';
  //modified by linlf 20140317
  strSQL := 'select distinct[Customer_Name] from [3F_Customer_Infor] ';
  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    Comb_Customer_Name.Items.Clear;
    while not Eof do
    begin
      Comb_Customer_Name.Items.Add(FieldByName('Customer_Name').AsString);
      Next;
    end;
  end;
  FreeAndNil(ADOQTemp);
end;

procedure Tfrm_IC_SetParameter_DataBaseInit.Comm_CheckReceiveData(
  Sender: TObject; Buffer: Pointer; BufferLength: Word);
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
    if ii = BufferLength then
    begin
      tmpStrend := 'END';
    end;
  end;
  recData_fromICLst_Check.Clear;
  recData_fromICLst_Check.Add(recStr);
    //����---------------
  begin
    CheckCMD_Right(); //ϵͳ����ʱ�жϼ��ܹ�
  end;
end;
//���ݽ��յ��������жϴ˿��Ƿ�Ϊ�Ϸ���

procedure Tfrm_IC_SetParameter_DataBaseInit.CheckCMD_Right();
var
  tmpStr: string;
  i: integer;
  content1, content2, content3, content4, content5, content6: string;
begin
   //���Ƚ�ȡ���յ���Ϣ
  tmpStr := '';
  tmpStr := recData_fromICLst_Check.Strings[0];
  Edit1.Text:='56666';
  content1 := copy(tmpStr, 1, 2); //֡ͷAA
  content2 := copy(tmpStr, 3, 2); //����ָ��
  if (content1 = '43') then //֡ͷ
  begin
    Edit1.Text:='5555';

    if (content2 = CMD_COUMUNICATION.CMD_HAND) then //�յ�������������Ϣ0x61
    begin
      for i := 1 to length(tmpStr) do
      begin
        if (copy(tmpStr, i, 2) = '03') and (i mod 2 = 1) then
        begin
          content3 := copy(tmpStr, i - 2, 2); //ָ��У���
          content5 := copy(tmpStr, 1, i - 3) + '63' + copy(tmpStr, i, 2);

          if (CheckSUMData_PasswordIC(content5) = content3) then
          begin
            Edit1.Text:='6666';
            LOAD_CHECK_OK_RE := true; //���ֳɹ�
            Timer_HAND.Enabled := FALSE; //�رռ�ⶨʱ��
            Timer_USERPASSWORD.Enabled := true; //����дϵͳ���ָ��
            Panel_Message.Caption := '���ֲ����ɹ�';

            tmpStr := '';
            break;
          end;
        end;
      end; //for ����

    end
    else if (content2 = CMD_COUMUNICATION.CMD_WRITETOFLASH_Sub_RE) then //�յ�д��ϵͳ��ŷ�����Ϣ0x66
    begin
      for i := 1 to length(tmpStr) do
      begin
        if (copy(tmpStr, i, 2) = '03') and (i mod 2 = 1) then
        begin

          content6 := copy(tmpStr, 5, 2);
          content3 := copy(tmpStr, i - 2, 2); //ָ��У���
          if (content6 = CMD_COUMUNICATION.CMD_USERPASSWORD_RE) then //0x68
          begin
            content5 := copy(tmpStr, 1, i - 3) + '63' + copy(tmpStr, i, 2);

            if (CheckSUMData_PasswordIC(content5) = content3) then
            begin
              LOAD_USERPASSWORD_OK_RE := true;
              Timer_USERPASSWORD.Enabled := false;
              Timer_3FPASSWORD.Enabled := true;
              Panel_Message.Caption := 'д��ϵͳ��������ɹ�';
            end;
            tmpStr := '';
            break;
          end
          else if (content6 = CMD_COUMUNICATION.CMD_3FPASSWORD_RE) then //0x66
          begin

            content5 := copy(tmpStr, 1, i - 3) + '63' + copy(tmpStr, i, 2);

            if (CheckSUMData_PasswordIC(content5) = content3) then
            begin
              LOAD_3FPASSWORD_OK_RE := true;
              Timer_3FPASSWORD.Enabled := false;
              Timer_3FLOADDATE.Enabled := true;
              Panel_Message.Caption := 'д�볡����������ɹ�';
               Edit1.Text:='7777';
            end;
            tmpStr := '';
            break;
          end
          else if (content6 = CMD_COUMUNICATION.CMD_3FLODADATE_RE) then //0x69
          begin
            Edit1.Text:='88888';

            content5 := copy(tmpStr, 1, i - 3) + '63' + copy(tmpStr, i, 2);
            if (CheckSUMData_PasswordIC(content5) = content3) then
            begin
              LOAD_3FLOADDATE_OK_RE := true;
              WriteToFlase_OK := true;
              Panel_Message.Caption := 'д���½ʱ������ɹ�';

              if WriteToFile_OK then
              begin
                if WriteToFlase_OK then
                begin

                  SaveData_CustomerInfor; //���桢���³�����¼
                  DeleteTestDataFromTable; //ɾ����������
                  Panel_Message.Caption := '�����������á����ݿ���������ɹ�';
                  WriteToFile_OK := false;
                  WriteToFlase_OK := false;
                end;
              end;

            end;


            tmpStr := '';
            break;


          end;

        end;
      end; //------for ����
    end;

  end;


end;

procedure Tfrm_IC_SetParameter_DataBaseInit.Timer_HANDTimer(Sender: TObject);

begin
  Check_Count := Check_Count + 1;
  if not LOAD_CHECK_OK_RE then //����δ�ɹ�
  begin
    Edit1.Text:='2222';
    SendCMD_HAND; //��������ָ��

    
    if Check_Count = 4 then //��ʱ��
    begin
      LOAD_CHECK_OK_RE := false;
      Timer_HAND.Enabled := FALSE; //�رն�ʱ��
      Check_Count := 0;
    end;
  end
  else
  begin
    Edit1.Text:='3333';
    Timer_HAND.Enabled := FALSE; //�رն�ʱ��
    Check_Count := 0
  end;

end;



procedure Tfrm_IC_SetParameter_DataBaseInit.Timer_USERPASSWORDTimer(Sender: TObject);
begin
  Check_Count_USERPASSWORD := Check_Count_USERPASSWORD + 1;
  if not LOAD_USERPASSWORD_OK_RE then //����δ�ɹ�
  begin
    SendCMD_USERPASSWORD; //���Ͷ�ȡ������������ָ��
    if Check_Count_USERPASSWORD = 4 then //��ʱ��
    begin
      LOAD_USERPASSWORD_OK_RE := false;
      Timer_USERPASSWORD.Enabled := FALSE; //�رն�ʱ��
      Check_Count_USERPASSWORD := 0;
    end;
  end
  else
  begin
    Timer_USERPASSWORD.Enabled := FALSE; //�رն�ʱ��
    Check_Count_USERPASSWORD := 0;
  end;
end;

procedure Tfrm_IC_SetParameter_DataBaseInit.Timer_3FPASSWORDTimer(Sender: TObject);
begin

  Check_Count_3FPASSWORD := Check_Count_3FPASSWORD + 1;
  if not LOAD_3FPASSWORD_OK_RE then //����δ�ɹ�
  begin
    SendCMD_3FPASSWORD; //��������ָ��
    if Check_Count_3FPASSWORD = 4 then //��ʱ��
    begin
      LOAD_3FPASSWORD_OK_RE := false;
      Timer_3FPASSWORD.Enabled := FALSE; //�رն�ʱ��
      Check_Count_3FPASSWORD := 0;
    end;
  end
  else
  begin
    Timer_3FPASSWORD.Enabled := FALSE; //�رն�ʱ��
    Check_Count_3FPASSWORD := 0;
  end;

end;



procedure Tfrm_IC_SetParameter_DataBaseInit.Timer_3FLOADDATETimer(
  Sender: TObject);
begin
  Check_Count_3FLOADDATE := Check_Count_3FLOADDATE + 1;
  if not LOAD_3FLOADDATE_OK_RE then //����δ�ɹ�
  begin
     Edit1.Text:='77778';
     SendCMD_3FLOADDATE; //��������ָ��
    if Check_Count_3FLOADDATE = 4 then //��ʱ��
    begin
      LOAD_3FLOADDATE_OK_RE := false;
      Timer_3FLOADDATE.Enabled := FALSE; //�رն�ʱ��
      Check_Count_3FLOADDATE := 0;
    end;
  end
  else
  begin
    Edit1.Text:='77779';
    Timer_3FLOADDATE.Enabled := FALSE; //�رն�ʱ��
    Check_Count_3FLOADDATE := 0;
  end;

end;



//������������ָ��

procedure Tfrm_IC_SetParameter_DataBaseInit.SendCMD_HAND;
var
  INC_value: string;
  strValue: string;
begin
  begin
    INC_value := '0'; //��ֵ��ֵ
    strValue := '50613C6D03'; //��������ָ��50  61  3C  6D  03
    INcrevalue(strValue); //д��ID��
    Edit1.Text:='4444';
  end;


end;
//����д�루ϵͳ��ţ�����ָ��

procedure Tfrm_IC_SetParameter_DataBaseInit.SendCMD_USERPASSWORD;
var
  strValue, INC_value: string;
begin

  INC_value := '0000' + Comb_Customer_Name.Text + '0'; //ϵͳ���
  Operate_No := 1;
  strValue := Make_Send_CMD_PasswordIC('506801', INC_value); //�����ֵָ��

  INcrevalue(strValue);
end;

//����д�볡����������ָ��

procedure Tfrm_IC_SetParameter_DataBaseInit.SendCMD_3FPASSWORD;
var
  strValue, INC_value: string;
begin
  INC_value := '1FE3C4' + 'AFBD3F' + Edit_Customer_NO.Text + '0'; //��������
  Operate_No := 1;
  strValue := Make_Send_CMD_PasswordIC('5066', INC_value); //�����ֵָ��
  INcrevalue(strValue);
end;

//����//д���½����

procedure Tfrm_IC_SetParameter_DataBaseInit.SendCMD_3FLOADDATE;
var
  strValue, INC_value: string;
begin


  INC_value := COPY(strtime, 1, 1) + COPY(strtime, 5, 1) + COPY(strtime, 2, 1) + COPY(strtime, 4, 1) + COPY(strtime, 7, 1); //INit_3F.ID_Settime,4���ֽڣ�Сʱ+���ӣ�д���һ�ε�½ϵͳʱ��50 69 00 00 00 00 59 03
         //Edit3.Text:= INC_value;
  Operate_No := 1;
  strValue := Make_Send_CMD_PasswordIC('5069', INC_value); //�����ֵָ��
  Edit1.Text:= strValue;
  INcrevalue(strValue);
end;



//�����ֵָ��

function Tfrm_IC_SetParameter_DataBaseInit.Make_Send_CMD_PasswordIC(StrCMD: string; StrIncValue: string): string;
var
  i: integer;
  TmpStr_IncValue: string; //תΪ16���ƺ���ַ���
  TmpStr_CheckSum: string; //У���
  TmpStr_SendCMD: string; //ָ������
  reTmpStr, StrFramEND, StrConFram: string;
begin

  TmpStr_IncValue := IntToHex(Ord(StrIncValue[1]), 2);

  for i := 2 to length(StrIncValue) - 1 do
  begin
    TmpStr_IncValue := TmpStr_IncValue + IntToHex(Ord(StrIncValue[i]), 2);

  end;
    //Edit4.Text:= TmpStr_IncValue;
  StrFramEND := '03';
  StrConFram := '63';
    //���������ݽ���У�˼���
  TmpStr_SendCMD := StrCMD + TmpStr_IncValue + StrFramEND + StrConFram;
  TmpStr_CheckSum := CheckSUMData_PasswordIC(TmpStr_SendCMD);
    //���ܷ�������

  reTmpStr := StrCMD + TmpStr_IncValue + TmpStr_CheckSum + StrFramEND;

  result := reTmpStr;

end;

//У��ͣ�ȷ���Ƿ���ȷ

function Tfrm_IC_SetParameter_DataBaseInit.CheckSUMData_PasswordIC(orderStr: string): string;
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
    KK := KK xor jj;

  end;
  reTmpStr := IntToHex(KK, 2);
  result := reTmpStr;
end;
//д��---------------------------------------

procedure Tfrm_IC_SetParameter_DataBaseInit.INcrevalue(S: string);
begin
  orderLst.Clear();
  curOrderNo := 0;
  curOperNo := 1;
  orderLst.Add(S); //����ֵд�����
  sendData();
end;
//�������ݹ���

procedure Tfrm_IC_SetParameter_DataBaseInit.sendData();
var
  orderStr: string;
begin
  if orderLst.Count > curOrderNo then
  begin
    orderStr := orderLst.Strings[curOrderNo];
    orderStr := exchData(orderStr);
    Comm_Check.WriteCommData(pchar(orderStr), length(orderStr));
    inc(curOrderNo);
  end;
end;



//ת�ҷ������ݸ�ʽ �����ַ�ת��Ϊ16����

function Tfrm_IC_SetParameter_DataBaseInit.exchData(orderStr: string): string;
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


//��ֵ����ת����16���Ʋ����� �ֽ�LL���ֽ�LH���ֽ�HL���ֽ�HH

function Tfrm_IC_SetParameter_DataBaseInit.Select_IncValue_Byte(StrIncValue: string): string;
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

function Tfrm_IC_SetParameter_DataBaseInit.Select_CheckSum_Byte(StrCheckSum: string): string;
var
  jj: integer;
  tempLH, tempLL: integer; //2147483648 ���Χ

begin
  jj := strToint('$' + StrCheckSum); //���ַ�תת��Ϊ16��������Ȼ��ת��λ10����
  tempLH := (jj mod 65536) div 256; //�ֽ�LH
  tempLL := jj mod 256; //�ֽ�LL

  result := IntToHex(tempLL, 2) + IntToHex(tempLH, 2);
end;

//���ݽ��յ��������ж���Ӧ���

function Tfrm_IC_SetParameter_DataBaseInit.Check_CustomerName(str1: string; str2: string): Boolean;
begin

  if (Copy(str1, 5, 6) = str2) then
  begin
    result := true;
  end
  else
  begin
    result := false;
  end
end;
 //���ݽ��յ��������ж���Ӧ���

function Tfrm_IC_SetParameter_DataBaseInit.Check_CustomerNO(str1: string; str2: string): Boolean;
begin

  if (Copy(str1, 5, 11) = str2) then
  begin
    result := true;
  end
  else
  begin
    result := false;
  end
end;

procedure Tfrm_IC_SetParameter_DataBaseInit.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  orderLst.Free();
  recData_fromICLst_Check.Free();
  Comm_Check.StopComm();
end;

procedure Tfrm_IC_SetParameter_DataBaseInit.Bit_CloseClick(
  Sender: TObject);
begin
  close;
end;

procedure Tfrm_IC_SetParameter_DataBaseInit.Comb_Customer_NameClick(
  Sender: TObject);
begin
  if (Comb_Customer_Name.Text = '����ѡ��') then
  begin
    Panel_Message.Caption := '��ѡ�񳡵ر��';
    exit;
  end
  else
  begin
    if (length(Comb_Customer_Name.Text) <> 12) then
    begin
      Panel_Message.Caption := '��������ȷ�ĳ��ر��';
      exit;
    end
    else
    begin
      QueryCustomerNo(Comb_Customer_Name.text);
    end;
  end;

end;


 //��ѯ��ǰ�ͻ��ĵ�ǰ���ع��ж���̨��ͷ

procedure Tfrm_IC_SetParameter_DataBaseInit.QueryCustomerNo(str1: string);
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  strSET: string;
begin
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select Customer_NO from [3F_Customer_Infor] where Customer_Name=''' + str1 + '''';

  with ADOQTemp do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    while not Eof do begin
      Edit_Customer_NO.Text := TrimRight(ADOQTemp.Fields[0].AsString);
      Next;
    end;
  end;
  FreeAndNil(ADOQTemp);
end;

procedure Tfrm_IC_SetParameter_DataBaseInit.BitBtn1Click(Sender: TObject);
var
  strValue, INC_value: string;
begin
  INC_value := '00000' + '3F2013000001'; //ϵͳ���
  Operate_No := 1;
  strValue := Make_Send_CMD_PasswordIC('506801', INC_value); //�����ֵָ��

  INcrevalue(strValue);

end;

procedure Tfrm_IC_SetParameter_DataBaseInit.BitBtn2Click(Sender: TObject);
begin
  Timer_3FPASSWORD.Enabled := true; //����дϵͳ���ָ��
end;

procedure Tfrm_IC_SetParameter_DataBaseInit.BitBtn3Click(Sender: TObject);
begin
  Timer_HAND.Enabled := true;
end;




end.