unit frm_SetParameter_CardMCIDINITUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, IniFiles,
  Dialogs, SPComm, DB, ADODB, StdCtrls, Buttons, ExtCtrls, Grids, DBGrids;

type
  Tfrm_SetParameter_CardMC_IDINIT = class(TForm)
    Panel2: TPanel;
    comReader: TComm;
    Panel4: TPanel;
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    Label4: TLabel;
    MC_ID_Set_Count: TEdit;
    Label5: TLabel;
    Panel3: TPanel;
    Label1: TLabel;
    DataSource_CardID_3FInit: TDataSource;
    ADOQuery_CardID_3FInit: TADOQuery;
    ComboBox_CardMC_ID: TComboBox;
    Label2: TLabel;
    Label3: TLabel;
    Edit_CardHead_Count: TEdit;
    Combo_MCname: TComboBox;
    BitBtn18: TBitBtn;
    GroupBox2: TGroupBox;
    DBGrid_CardID_3FInit: TDBGrid;
    BitBtn1: TBitBtn;
    BitBtn_INIT: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure BitBtn18Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Combo_MCnameClick(Sender: TObject);
    procedure ComboBox_CardMC_IDClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure comReaderReceiveData(Sender: TObject; Buffer: Pointer;
      BufferLength: Word);
    procedure BitBtn_INITClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure MC_ID_Set_CountKeyPress(Sender: TObject; var Key: Char);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private declarations }
    procedure InitCarMC_ID(Str1: string);
    procedure QueryCarMC_ID(MC_ID: string);
    procedure InitCombo_MCname; //��ʼ����Ϸ����������
    procedure CountCarMC_ID(str1: string);
    procedure MaxID_NO(str1: string);


    procedure CheckCMD_Right(); //ϵͳ����Ȩ���жϣ�ȷ���Ƿ�����ܹ�Ψһ��Ӧ
    function INit_Send_CMD(StrCMD: string; StrIncValue: string): string;
    procedure INIT_Operation;
    procedure INcrevalue(S: string); //��ֵ����
    procedure sendData();
    function exchData(orderStr: string): string;
    function Select_CheckSum_Byte(StrCheckSum: string): string;
    function CheckSUMData(orderStr: string): string;
    function Date_Time_Modify(strinputdatetime: string): string;
    procedure Save_CardID;
    procedure Save_CardID_M(strtemp:string);
    procedure InitDataBase;
    procedure Query_CardID;
  public
    { Public declarations }
  end;

var
  frm_SetParameter_CardMC_IDINIT: Tfrm_SetParameter_CardMC_IDINIT;
  orderLst, recDataLst, recData_fromICLst: Tstrings;
  send_Data: string;
implementation

uses ICDataModule, ICCommunalVarUnit, ICFunctionUnit, ICmain, Frontoperate_EBincvalueUnit, ICEventTypeUnit;


{$R *.dfm}

procedure Tfrm_SetParameter_CardMC_IDINIT.InitDataBase;
var
  strSQL: string;
begin
  with ADOQuery_CardID_3FInit do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select * from [TCardHead_Init] order by ID Desc';
    SQL.Add(strSQL);
    Active := True;
  end;
end;

procedure Tfrm_SetParameter_CardMC_IDINIT.FormShow(Sender: TObject);
begin

  InitCombo_MCname; //��ʼ���ͻ�����
  recDataLst := tStringList.Create;
  recData_fromICLst := tStringList.Create;
  orderLst := TStringList.Create;
  comReader.StartComm(); //�������ܹ�����ȷ��
  InitDataBase();
end;

procedure Tfrm_SetParameter_CardMC_IDINIT.InitCombo_MCname; //��ʼ����Ϸ����������
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  nameStr: string;
  i: integer;
begin
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select distinct[Customer_Name] from [3F_Customer_Infor] ';
  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    Combo_MCname.Items.Clear;
    while not Eof do
    begin
      Combo_MCname.Items.Add(FieldByName('Customer_Name').AsString);
      Next;
    end;
  end;
  FreeAndNil(ADOQTemp);
end;

procedure Tfrm_SetParameter_CardMC_IDINIT.Combo_MCnameClick(
  Sender: TObject);
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  nameStr: string;
  i: integer;
begin


  if length(Trim(Combo_MCname.Text)) = 0 then
  begin
    ShowMessage('��̨��Ϸ���Ʋ��ܿ�');
    exit;
  end
  else
  begin
    InitCarMC_ID(Combo_MCname.text); //��ѯ�Ѿ����ÿ�ͷID������
  end;
end;

 //��ʼ���ͻ����
procedure Tfrm_SetParameter_CardMC_IDINIT.InitCarMC_ID(Str1: string);
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
    ComboBox_CardMC_ID.Items.Clear;
    ComboBox_CardMC_ID.Text:='';
    while not Eof do begin
      ComboBox_CardMC_ID.Items.Add(FieldByName('Customer_NO').AsString);
      Next;
    end;
  end;
  FreeAndNil(ADOQTemp);

end;


//�ر��˳�

procedure Tfrm_SetParameter_CardMC_IDINIT.BitBtn18Click(Sender: TObject);
begin
  CLOSE;
end;

//��ѯ��ǰ�ͻ��ĵ�ǰ���ع��ж���̨��ͷ
procedure Tfrm_SetParameter_CardMC_IDINIT.CountCarMC_ID(str1: string);
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  strSET: string;
begin
  ADOQTemp := TADOQuery.Create(nil);
  //strSQL := 'select Count(ID) from [TCardHead_Init] where Customer_NO=''' + str1 + '''';
  strSQL := 'select max(ID) from [TCardHead_Init]';

  with ADOQTemp do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    while not Eof do begin
      Edit_CardHead_Count.Text := IntToStr(ADOQTemp.Fields[0].AsInteger);
      Next;
    end;
  end;
  FreeAndNil(ADOQTemp);
end;


//ѡ����Ͽͻ����ƣ�����ͻ����ر��ʱ���¼�
procedure Tfrm_SetParameter_CardMC_IDINIT.ComboBox_CardMC_IDClick(
  Sender: TObject);
begin
  Query_CardID;
end;

procedure Tfrm_SetParameter_CardMC_IDINIT.Query_CardID;
begin

    //���ݿͻ���Ų�ѯ��ǰ�ͻ��Ѿ�ӵ�еĿ�ͷ��
  CountCarMC_ID(ComboBox_CardMC_ID.text);//ComboBox_CardMC_ID.text�ͻ����
  MC_ID_Set_Count.Text := inttostr(Strtoint(Edit_CardHead_Count.Text) + 2);

end;



 //��ѯ��ǰ�ͻ���ǰ���ص����ͷID��   ���ｨ��ʹ��max������count
procedure Tfrm_SetParameter_CardMC_IDINIT.MaxID_NO(str1: string);
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  strSET: string;
begin
  ADOQTemp := TADOQuery.Create(nil);
//  strSQL := 'select Count(ID) from [TCardHead_Init] where Customer_NO=''' + str1 + '''';
  strSQL := 'select max(ID) from [TCardHead_Init] ';

  with ADOQTemp do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    while not Eof do begin
      Edit_CardHead_Count.Text := IntToStr(ADOQTemp.Fields[0].AsInteger);
      Next;
    end;
  end;
  FreeAndNil(ADOQTemp);
end;


procedure Tfrm_SetParameter_CardMC_IDINIT.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  orderLst.Free();
  recDataLst.Free();
  recData_fromICLst.Free();
  comReader.StopComm();
//    ICFunction.ClearIDinfor;//�����ID��ȡ��������Ϣ

end;


 //��ѯ��ǰ��̨�������Ϣ   �������û��
procedure Tfrm_SetParameter_CardMC_IDINIT.QueryCarMC_ID(MC_ID: string);
var
  ADOQTemp: TADOQuery;
  strSQL: string;

begin
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select [TGameSet].GameName from [TChargMacSet],[TGameSet] where ([TChargMacSet].MacNo=''' + MC_ID + ''' ) AND (TChargMacSet.GameNo=TGameSet.GameNo) And (TChargMacSet.GameNo NOT IN(001,002,003,004,005,006,007,008,009))';
  BitBtn_INIT.Enabled := FALSE;
  with ADOQTemp do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    Combo_MCname.Text := '';
    while not Eof do begin
      Combo_MCname.Text := ADOQTemp.Fields[0].AsString;
      BitBtn_INIT.Enabled := True;
      Next;
    end;
  end;
  FreeAndNil(ADOQTemp);
end;


procedure Tfrm_SetParameter_CardMC_IDINIT.FormCreate(Sender: TObject);
begin
//  EventObj:=EventUnitObj.Create;
//  EventObj.LoadEventIni;

end;


//������Ӧ�¼�        
procedure Tfrm_SetParameter_CardMC_IDINIT.comReaderReceiveData(
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
  recData_fromICLst.Clear;
  recData_fromICLst.Add(recStr);
    //����---------------
  begin
    CheckCMD_Right(); //ϵͳ����ʱ�жϼ��ܹ�
  end;

end;


//���ݽ��յ��������жϴ˿��Ƿ�Ϊ�Ϸ���   
procedure Tfrm_SetParameter_CardMC_IDINIT.CheckCMD_Right();
var
  i: integer;
  tmpStr: string;
  stationNoStr: string;
  stationNo_ValueStr: string;
  tmpStr_Hex: string;
  tmpStr_Hex_length: string;
  Send_value: string;
  RevComd: integer;
  CMD1, CMD2, CMD3: string; //¼��ʱ�䣬��ȡϵͳʱ��
  ID_No: string;
  length_Data: integer;
  content1,strtemp01,strtemp02,strtemp03, content2, content3, content4, content5, content6, content7, content8, content9, content10: string;
begin
  RevComd := 0;
  CMD1 := '83';
   //���Ƚ�ȡ���յ���Ϣ
  tmpStr := recData_fromICLst.Strings[0];
  LOAD_USER.ID_CheckNum := copy(tmpStr, 39, 4); //У���
      // if(frm_Frontoperate_EBincvalue.CheckSUMData(copy(tmpStr, 1, 38))=copy(tmpStr, 41, 2)+copy(tmpStr, 39, 2)) then//У���
  begin
    content1 := copy(recData_fromICLst.Strings[0], 1, 2); //֡ͷAA
    content2 := copy(recData_fromICLst.Strings[0], 3, 4); //������У���
    strtemp01:='0100';
    strtemp02:='0000';
    strtemp03:='0001';
          //1�������жϽ��յ�ָ���Ƿ���Ϲ涨
    if (content1 = CMD1) then //����83
    begin
     //�жϽ��յ����������ݱ����Ƿ��Ѿ����ڣ�������򵯳���ʾ��
    if (content2=strtemp03) or (content2=strtemp02) or (content2=strtemp01)then
      begin
       if content2 = send_Data then
        begin

          Save_CardID;
        
          send_Data := '';
          Panel3.Caption := 'д��ɹ��������Ѿ����棡';
        end
        else
        begin
          Panel3.Caption := '��ǰ��ͷIDδ��ʼ��������д�룡';
          BitBtn_INIT.Enabled := true;
        end;
      end
      else if (content2 = DataModule_3F.Query3F_CardHeadID_Only(content2))  then
      begin

        Panel3.Caption := content2+'��ǰ��ͷID��' + DataModule_3F.Query3F_CardHeadID_Customer_Name(content2) + 'ռ�ã�Ϊ��֤Ψһ�ԣ���ֹ��д��';
        BitBtn_INIT.Enabled := false;
        exit;
      end
      else
      begin
        if content2 = send_Data then
        begin

          Save_CardID;
           //linlf@20160702����
         // MC_ID_Set_Count.Text :=  inttostr(Strtoint(MC_ID_Set_Count.Text) + 1);
          ICFunction.loginfo('send_Data:  '+ send_Data);
          send_Data := '';
          Panel3.Caption := 'д��ɹ��������Ѿ����棡';
        end
        else
        begin
          Panel3.Caption := '��ǰ��ͷIDδ��ʼ��������д�룡';
          BitBtn_INIT.Enabled := true;
        end;
      end;
    end
    else //ָ��ͷ����83
    begin
      Panel3.Caption := '��ǰ��ͷ����3F��Ʒ����ȷ�ϣ�';
    end;
  end;


end;

 //���沢д�뿨ͷID

procedure Tfrm_SetParameter_CardMC_IDINIT.BitBtn_INITClick(
  Sender: TObject);
begin
  INIT_Operation; //���ֳɹ�����������ܹ����͸���ָ��
end;


//��ʼ������ 
procedure Tfrm_SetParameter_CardMC_IDINIT.INIT_Operation;
var
  INC_value: string;
  strValue: string;
begin
  begin
    INC_value := '0'; //��ֵ��ֵ
    strValue := INit_Send_CMD('73', INC_value); //�����ֵָ��
         //Edit1.Text:= strValue;//7302007500

    INcrevalue(strValue); //д��ID��
  end;
end;


//��ʼ��������ָ��      
function Tfrm_SetParameter_CardMC_IDINIT.INit_Send_CMD(StrCMD: string; StrIncValue: string): string;
var
  TmpStr: string; //�淶������ں�ʱ��
  TmpStr_CheckSum: string; //У���
  TmpStr_SendCMD: string; //ָ������
  TmpStr_Password_User: string; //ָ������
  reTmpStr: string;
  myIni: TiniFile;
  strinputdatetime: string;

  i: integer;
  Strsent: array[0..21] of string; //���ͷ����Ӧ����
begin
  strinputdatetime := DateTimetostr((now()));
    //TmpStr:=Date_Time_Modify(strinputdatetime);//�淶���ں�ʱ���ʽ
  Strsent[0] := StrCMD; //֡����
  Strsent[2] := IntToHex((Strtoint(MC_ID_Set_Count.Text) div 256), 2);
  Strsent[1] := IntToHex((Strtoint(MC_ID_Set_Count.Text) mod 256), 2);

    //���������ݽ���У�˼���

  TmpStr_SendCMD := Strsent[0] + Strsent[1] + Strsent[2]; //���
  TmpStr_CheckSum := CheckSUMData(TmpStr_SendCMD); //���У���

    //TmpStr_CheckSum�ֽ���Ҫ�����Ų� �����ֽ���ǰ�����ֽ��ں�
  reTmpStr := TmpStr_SendCMD + Select_CheckSum_Byte(TmpStr_CheckSum); //��ȡ���з��͸�IC������

  result := reTmpStr;
end;
//У��ͣ�ȷ���Ƿ���ȷ

function Tfrm_SetParameter_CardMC_IDINIT.CheckSUMData(orderStr: string): string;
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
//У���ת����16���Ʋ����� �ֽ�LL���ֽ�LH

function Tfrm_SetParameter_CardMC_IDINIT.Select_CheckSum_Byte(StrCheckSum: string): string;
var
  jj: integer;
  tempLH, tempLL: integer; //2147483648 ���Χ

begin
  jj := strToint('$' + StrCheckSum); //���ַ�תת��Ϊ16��������Ȼ��ת��λ10����
  tempLH := (jj mod 65536) div 256; //�ֽ�LH
  tempLL := jj mod 256; //�ֽ�LL
  result := IntToHex(tempLL, 2) + IntToHex(tempLH, 2);
end;

//д��---------------------------------------

procedure Tfrm_SetParameter_CardMC_IDINIT.INcrevalue(S: string);
begin
  orderLst.Clear();
  recDataLst.Clear();
  curOrderNo := 0;
  curOperNo := 2;
    //Edit1.Text:=s;
  send_Data := Copy(s, 3, 4);
  orderLst.Add(S); //����ֵд�����
  sendData();
end;
//�������ݹ���

procedure Tfrm_SetParameter_CardMC_IDINIT.sendData();
var
  orderStr: string;
begin
  if orderLst.Count > curOrderNo then
  begin
    orderStr := orderLst.Strings[curOrderNo];
    orderStr := exchData(orderStr);
    comReader.WriteCommData(pchar(orderStr), length(orderStr));
    inc(curOrderNo);
  end;
end;

//ת�ҷ������ݸ�ʽ �����ַ�ת��Ϊ16����

function Tfrm_SetParameter_CardMC_IDINIT.exchData(orderStr: string): string;
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

//��ʱ��ɨ��ͳ�ƽ������ϸ��¼

function Tfrm_SetParameter_CardMC_IDINIT.Date_Time_Modify(strinputdatetime: string): string;
var
  strEnd: string;
  Strtemp: string;
begin

  Strtemp := Copy(strinputdatetime, length(strinputdatetime) - 8, 9);
  strinputdatetime := Copy(strinputdatetime, 1, length(strinputdatetime) - 9);
  if Copy(strinputdatetime, 7, 1) = '-' then //�·�С��10
  begin
    if length(strinputdatetime) = 8 then //�·�С��10,������С��10
    begin
      strEnd := Copy(strinputdatetime, 1, 5) + '0' + Copy(strinputdatetime, 6, 2) + '0' + Copy(strinputdatetime, 8, 1);
    end
    else
    begin
      strEnd := Copy(strinputdatetime, 1, 5) + '0' + Copy(strinputdatetime, 6, length(strinputdatetime) - 5);
    end;
  end
  else
  begin //�·ݴ���9
    if length(strinputdatetime) = 9 then //�·ݴ���9,������С��10
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

procedure Tfrm_SetParameter_CardMC_IDINIT.Save_CardID;
var
  ADOQ: TADOQuery;
  strSQL: string;
begin
  strSQL := 'select * from TCardHead_Init';
  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := true;
    Append;
    FieldByName('Customer_Name').AsString := Combo_MCname.text;
    FieldByName('Customer_NO').AsString := ComboBox_CardMC_ID.text;
    FieldByName('CardHead_ID').AsString := MC_ID_Set_Count.text;
    FieldByName('Customer_Time').AsString := FormatDateTime('yyyy-MM-dd HH:mm:ss', now);
    FieldByName('CardHead_ID_IC').AsString := send_Data;

    Post;
    Active := False;
  end;
  FreeAndNil(ADOQ);
  InitDataBase; //ˢ���б�
  Query_CardID; //���²�ѯ�����Ϣ

end;

procedure Tfrm_SetParameter_CardMC_IDINIT.Save_CardID_M(strtemp:string);
var
  ADOQ: TADOQuery;
  strSQL: string;
  i,imax:integer;
  strMCname,  strCardMC_ID,strStartID:string;
begin
 strMCname:='����ѡ��';
 strCardMC_ID:='����ѡ��';
 strStartID:='0';
 if  (Combo_MCname.Text=strMCname)or (ComboBox_CardMC_ID.Text=strCardMC_ID) then
  begin
    showmessage('��ѡ��ͻ����ƺͱ��');
    exit;
  end
 else if strtemp= strStartID then
  begin
    showmessage('��Ҫ���õĿ�ͷID�Ų���Ϊ0,����>0');
    exit;
  end
 else
  begin
  
  imax:=strtoint(trim(strtemp))-1;
  for i:=1 to imax do
   begin
   if i<10 then
     begin
       send_Data:='000'+inttostr(i);
     end
   else if( i<100) and (i>9) then
     begin
       send_Data:='00'+inttostr(i);
     end
   else if ( i<1000) and (i>99)  then
     begin
       send_Data:='0'+inttostr(i);
     end
   else
     begin
       send_Data:=inttostr(i);
     end;

  strSQL := 'select * from TCardHead_Init';
  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := true;
    Append;
    FieldByName('Customer_Name').AsString := Combo_MCname.text;
    FieldByName('Customer_NO').AsString := ComboBox_CardMC_ID.text;
    FieldByName('CardHead_ID').AsString := MC_ID_Set_Count.text;
    FieldByName('Customer_Time').AsString := FormatDateTime('yyyy-MM-dd HH:mm:ss', now);
    FieldByName('CardHead_ID_IC').AsString := send_Data;
    Post;
    Active := False;
  end;
  FreeAndNil(ADOQ);
   end;//for cycle end
  end;
  InitDataBase; //ˢ���б�
  Query_CardID; //���²�ѯ�����Ϣ

end;
procedure Tfrm_SetParameter_CardMC_IDINIT.BitBtn1Click(Sender: TObject);
begin
  INIT_Operation; //���ֳɹ�����������ܹ����͸���ָ��
end;

procedure Tfrm_SetParameter_CardMC_IDINIT.Label1Click(Sender: TObject);
begin
  MC_ID_Set_Count.Enabled:=true;
end;

procedure Tfrm_SetParameter_CardMC_IDINIT.MC_ID_Set_CountKeyPress(
  Sender: TObject; var Key: Char);
begin
if not (key in ['0'..'9', #8, #13]) then
  begin
    key := #0;
    ShowMessage('�������ֻ���������֣�');
  end;
end;

procedure Tfrm_SetParameter_CardMC_IDINIT.BitBtn3Click(Sender: TObject);
begin
    if (MessageDlg('ȷ����Ҫ��䣿', mtInformation, [mbYes, mbNo], 0) = mrYes) then
    begin
    if (MessageDlg('�ٴ�ȷ����Ҫ������', mtInformation, [mbYes, mbNo], 0) = mrYes) then
    begin
       Save_CardID_M(MC_ID_Set_Count.Text);
    end;
    end;
end;

procedure Tfrm_SetParameter_CardMC_IDINIT.BitBtn2Click(Sender: TObject);
var
  ADOQ: TADOQuery;
  strSQL: string;
begin

if (MessageDlg('ȷ����Ҫɾ��������¼��', mtInformation, [mbYes, mbNo], 0) = mrYes) then
    begin
    if (MessageDlg('�ٴ�ȷ����Ҫɾ����', mtInformation, [mbYes, mbNo], 0) = mrYes) then
    begin


  strSQL := 'delete  from '
    + ' [TCardHead_Init] ';

  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    ADOQ.Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    ADOQ.ExecSQL;
  end;
  FreeAndNil(ADOQ);

  InitDataBase; //ˢ���б�
  Query_CardID; //���²�ѯ�����Ϣ
  end;
  end;
  
end;

end.
