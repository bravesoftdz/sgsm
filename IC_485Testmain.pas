unit IC_485Testmain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, ExtCtrls, StdCtrls, OleCtrls, MSCommLib_TLB,
  Buttons, ComCtrls, SPComm;
type
  Tfrm_IC_485Testmain = class(TForm)
    comReader: TComm;
    DataSource_Newmenber: TDataSource;
    ADOQuery_newmenber: TADOQuery;
    pgcReader: TPageControl;
    tbsConfig: TTabSheet;
    TabSheet1: TTabSheet;
    GroupBox1: TGroupBox;
    Memo_485: TMemo;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Bit_Uptest: TBitBtn;
    Bit_SSRtest: TBitBtn;
    Bit_Downtest: TBitBtn;
    Bit_NetNotest: TBitBtn;
    ComboBox_NetNotest: TComboBox;
    ComboBox_Uptest: TComboBox;
    ComboBox_SSRtest: TComboBox;
    ComboBox_Downtest: TComboBox;
    ComboBox_StationNo: TComboBox;
    Bit_StationNoset: TBitBtn;
    MSComm1: TMSComm;
    tbsSeRe: TTabSheet;
    gbComSendRec: TGroupBox;
    lblExplain: TLabel;
    memComSeRe: TMemo;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    GroupBox3: TGroupBox;
    Label7: TLabel;
    BitBtn1: TBitBtn;
    Edit_Pwd: TEdit;
    ComboBox_ComNo: TComboBox;
    Label6: TLabel;
    BitBtn2: TBitBtn;
    Edit5: TEdit;
    ADOQuery_MacUpdown: TADOQuery;
    Label8: TLabel;
    Label9: TLabel;
    Edit6: TEdit;
    BitBtn3: TBitBtn;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Edit10: TEdit;
    BitBtn4: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure comReaderReceiveData(Sender: TObject; Buffer: Pointer;
      BufferLength: Word);
    procedure BitBtn1Click(Sender: TObject);
    procedure Bit_StationNosetClick(Sender: TObject);
    procedure ComboBox_ComNoChange(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
  private
    { Private declarations }
    function exchData(orderStr: string): string;
    procedure sendData();
    procedure checkOper();
    procedure AnswerOper(); //��Ӧ�����Ϸ֡��·ֲ������¼�
    procedure InitDataBase;
    function Query_TMemberInfo_CardAmount(S1: string): string;
    procedure SendCardAmount(S1: string); //�������ֵ
    function tranfertoHex(S1: string): string; // ������ַ�֮��תΪ16���Ƶ��ַ�
    procedure Send_StationNo(S1: string); //����վ��
    procedure Send_Pwd(S1: string); //���Ϳ�ȷ������
    procedure InitStationNo;
    procedure QueryStationNo(ComNumStr: string);
    procedure UpdateMacStatic_up(S1: string; S2: string); //���¼�¼
    procedure UpdateMacStatic_down(S1: string; S2: string);
    function Query_MacStatic_init_downvalue(S1: string): string;
    function Query_MacStatic_init_upvalue(S1: string): string;

  //  procedure  AddTOMacStatic_up(S1:String;S2:String;S3:String);//д���Ϸּ�¼�����ݱ�MacStatic
    procedure AddTOTMembeDetail_up(S1: string; S2: string; S3: string); //д���Ϸּ�¼�����ݱ�TMembeDetail
  //  procedure  AddTOMacStatic_down(S1:String;S2:String;S3:String);//д���·ּ�¼�����ݱ�MacStatic
    procedure AddTOTMembeDetail_down(S1: string; S2: string; S3: string); //д���·ּ�¼�����ݱ�TMembeDetail

    function Query_MacStatic_init_updownvalue(S1: string): string; //��ѯ�û�̨��Ӧ���Ϸ֡��·ֵ�ֵ;
    function QueryUserNo(S: string): string; //���ݿ�ID�Ų�ѯ�˿���ǰ�����ߵ������Ϣ
    procedure Update_LastRecord(S: string); //���³�ֵ���Ϸ֡��·ֵ����¼�¼��ʶ�ֶ� LastRecord
    function Query_TotalMoneyLastrecord(S: string): string;
  public
    { Public declarations }
  end;

var
  frm_IC_485Testmain: Tfrm_IC_485Testmain;
  curOrderNo: integer = 0;
  curOperNo: integer = 0;
  curScanNo: integer = 0;
  orderLst, recDataLst, recData_fromICLst: Tstrings;
  buffer: array[0..2048] of byte;
implementation
uses SetParameterUnit, ICDataModule, ICCommunalVarUnit, ICEventTypeUnit, ICFunctionUnit;
{$R *.dfm}

//��ʼ�����ݱ�

procedure Tfrm_IC_485Testmain.InitDataBase;
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

  with ADOQuery_MacUpdown do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select * from [TMembeDetail]';
    SQL.Add(strSQL);
    Active := True;
  end;
end;

 //��ʼ���ͺ�վ�ŵ�ַ

procedure Tfrm_IC_485Testmain.InitStationNo;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  nameStr: string;
  i: integer;
begin

  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select distinct [ComNum] from [TChargMacSet]';
  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    ComboBox_ComNo.Items.Clear;
    while not Eof do
    begin
      ComboBox_ComNo.Items.Add(FieldByName('ComNum').AsString);
      Next;
    end;
  end;
  FreeAndNil(ADOQTemp);

end;
//��ѯ�������վ�ŵ�ַ��Ӧ����

procedure Tfrm_IC_485Testmain.QueryStationNo(ComNumStr: string); //��ѯ�������վ�ŵ�ַ
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  nameStr: string;
  valueStr: string;
  i: integer;
begin

  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select distinct [MacID] from [TChargMacSet] where [State]=0 and ComNum=''' + ComNumStr + ''' ';
  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    ComboBox_StationNo.Items.Clear;
    while not Eof do
    begin
      ComboBox_StationNo.Items.Add(TrimRight(FieldByName('MacID').AsString));
      Next;
    end;
  end;
  FreeAndNil(ADOQTemp);
end;

//��ѯ�������վ�ŵ�ַ

procedure Tfrm_IC_485Testmain.ComboBox_ComNoChange(Sender: TObject);
begin
  ComboBox_StationNo.Items.Clear;
  QueryStationNo(ComboBox_ComNo.Text);
end;


procedure Tfrm_IC_485Testmain.FormCreate(Sender: TObject);
begin
  EventObj := EventUnitObj.Create;
  EventObj.LoadEventIni;
  InitDataBase; //���ݿ����

end;



//ת�ҷ������ݸ�ʽ

function Tfrm_IC_485Testmain.exchData(orderStr: string): string;
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

procedure Tfrm_IC_485Testmain.sendData();
var
  orderStr: string;
begin
  if orderLst.Count > curOrderNo then
  begin
    orderStr := orderLst.Strings[curOrderNo];
    memComSeRe.Lines.Add('==>> ' + orderStr);
    orderStr := exchData(orderStr); //���ַ�ת��Ϊ��λ���ܹ�ʶ���16������ֵ
    comReader.WriteCommData(pchar(orderStr), length(orderStr));
    inc(curOrderNo); //����ָ��������ÿ��һ��ָ����Զ���һ��ֱ����ָ��������ͬ
  end;
end;

//��鷵�ص����ݣ�ִ����Ӧ���¼�����Щ���ݶ�����485�����IC��վ

procedure Tfrm_IC_485Testmain.checkOper();
var
  i: integer;
  tmpStr: string;
begin
  case curOperNo of
    20: begin //�����������ֵ����
        for i := 0 to recData_fromICLst.Count - 1 do
          if copy(recData_fromICLst.Strings[i], 9, 2) <> '01' then // д�����ɹ���������
          begin
            memComSeRe.Lines.Add('��̨''' + copy(recData_fromICLst.Strings[0], 5, 4) + '''�Ѿ����յ�PC��������');
            memComSeRe.Lines.Add('');
            recData_fromICLst.Clear;
            exit;
          end;
      end;
    21: begin //����վ���趨����
        for i := 0 to recData_fromICLst.Count - 1 do
          if copy(recData_fromICLst.Strings[i], 9, 2) <> 'A2' then // д�����ɹ���������
          begin
            memComSeRe.Lines.Add('��̨''' + copy(recData_fromICLst.Strings[0], 5, 4) + '''�Ѿ����յ�PC��������');
            memComSeRe.Lines.Add('');
            recData_fromICLst.Clear;
            exit;
          end;
      end;
    22: begin //��������ȷ���趨����
        for i := 0 to recDataLst.Count - 1 do
          if copy(recDataLst.Strings[i], 9, 2) <> 'A4' then // д�����ɹ���������
          begin
            memComSeRe.Lines.Add('��̨''' + copy(recData_fromICLst.Strings[0], 5, 4) + '''�Ѿ����յ�PC��������');
            memComSeRe.Lines.Add('');
            recData_fromICLst.Clear;
            exit;
          end;
      end;



  end;
end;


//��鷵�ص�����

procedure Tfrm_IC_485Testmain.AnswerOper();
var
  i: integer;
  tmpStr: string;
  stationNoStr: string;
  stationNo_ValueStr: string;
  tmpStr_Hex: string;
  tmpStr_Hex_length: string;
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
  if Dingwei[3] = 'A2' then // վ���趨����
  begin
    RevComd := 2;
  end;
  if Dingwei[3] = 'A4' then // ȷ�������趨����
  begin
    RevComd := 4;
  end;
  if Dingwei[3] = 'A5' then //�Ϸֲ���
  begin
    RevComd := 5;
  end;
  if Dingwei[3] = 'A6' then //�·ֲ���
  begin
    RevComd := 6;
  end;
  if Dingwei[3] = 'A7' then //�˱��ź�
  begin
    RevComd := 7;
  end;
   //�ж����ָ�����ж�Ӧ����
  case RevComd of
    1: begin //�������ÿ����
                //����ȡ�ÿ�ID��ѯ��Ӧ���Ļ������ ,���ҷ�����IC������Dingwei[4]

        Edit2.Text := Dingwei[5];
                //��ѯ�õ������ֵ
              //  tmpStr:=Query_TMemberInfo_CardAmount(Dingwei[5]);//��ѯ�õ������ֵ
                 //����ѯ�õ������ֵ ����ַ�ת��Ϊ16�����ַ�
        tmpStr := '500';
               // tmpStr_Hex_length:='0'+IntToStr(length(tmpStr));//���ݳ���
        tmpStr_Hex_length := '06'; //���ݳ���
        Edit3.Text := tmpStr_Hex_length;

        tmpStr_Hex := tranfertoHex(tmpStr); //����
        Edit1.Text := tmpStr_Hex;

        Send_value := 'AA8A' + Dingwei[2] + 'A1' + tmpStr_Hex_length + tmpStr_Hex + '4A';

        Edit4.Text := Send_value;
        SendCardAmount(Send_value); //����A1ָ��
        recData_fromICLst.Clear;
        RevComd := 0;
                //ϵͳ�����¼��Ӧ��̨������־  ����Dingwei[2]
                //Record_MC_Operate
      end;
    2: begin //վ���趨����

        ; //�������ݱ�TChargMacSet
        recData_fromICLst.Clear;
        RevComd := 0;
      end;

    4: begin //ȷ�������趨����
        ;
        recData_fromICLst.Clear;
        RevComd := 0;
      end;

    5: begin //�Ϸֲ���
              // ;  //�����Ϸּ�¼
        stationNoStr := '';
        stationNoStr := '00' + Dingwei[2]; //��̨վ��
        ID_No := Dingwei[5]; //ID����
            //��ѯ��MacStatic��ֵ
            //stationNo_ValueStr:=Query_MacStatic_init_upvalue(stationNoStr);//��ѯ�õ������ֵ;
            //stationNo_ValueStr:=IntToStr(StrToInt(stationNo_ValueStr)+10);  //ע���Ƿ���Ҫת��Ϊ���㣬ͬʱ10Ӧ�ÿ����ñ���
            //UpdateMacStatic_up(stationNoStr,stationNo_ValueStr);

        stationNo_ValueStr := Query_MacStatic_init_updownvalue(stationNoStr); //��ѯ�û�̨��Ӧ���Ϸ֡��·ֵ�ֵ;
           // AddTOMacStatic_up(ID_No,stationNo_Value,StrstationNoStr);//д���Ϸּ�¼�����ݱ�MacStatic
        AddTOTMembeDetail_up(ID_No, stationNo_ValueStr, stationNoStr); //д���Ϸּ�¼�����ݱ�TMembeDetail

        recData_fromICLst.Clear;
        RevComd := 0;
      end;

    6: begin //�·ֲ���(ʹ���˱ҹ����ź�)
             //  ;   //�����·ּ�¼
        stationNoStr := '';
        stationNoStr := '00' + Dingwei[2]; //IC��վ�ţ�Ҳ�ǻ�̨���
        ID_No := Dingwei[5]; //ID����

            //��ѯ��MacStatic��ֵ
            //stationNo_ValueStr:=Query_MacStatic_init_downvalue(stationNoStr);//��ѯ�õ������ֵ;
            //stationNo_ValueStr:=IntToStr(StrToInt(stationNo_ValueStr)+10);  //ע���Ƿ���Ҫת��Ϊ���㣬ͬʱ10Ӧ�ÿ����ñ���
            //UpdateMacStatic_down(stationNoStr,stationNo_ValueStr);

        stationNo_ValueStr := Query_MacStatic_init_updownvalue(stationNoStr); //��ѯ�û�̨��Ӧ���Ϸ֡��·ֵ�ֵ;
            //AddTOMacStatic_down(ID_No,stationNo_Value,StrstationNoStr);//д���Ϸּ�¼�����ݱ�MacStatic
        AddTOTMembeDetail_down(ID_No, stationNo_ValueStr, stationNoStr); //д���Ϸּ�¼�����ݱ�TMembeDetail

        recData_fromICLst.Clear;
        RevComd := 0;
      end;
    7: begin //�˱��ź�
        ; //�����˱��źż�¼
      end;

  end;
end;
//�Ϸֲ���

procedure Tfrm_IC_485Testmain.BitBtn2Click(Sender: TObject);
var
  stationNoStr: string;
  stationNoStr1: string;
  ID_NO: string;
begin
  stationNoStr := '000301'; //��̨���
  ID_NO := 'F9923A3C'; //��ID��
  stationNoStr1 := Query_MacStatic_init_updownvalue(stationNoStr); //��̨��Ӧ�ı���ֵ

     //Update_LastRecord(stationNoStr);//�������¼�¼��ʶ�ֶ�
  AddTOTMembeDetail_up(ID_NO, stationNoStr1, stationNoStr); //�Ϸֲ��� ����PCȡ�߷���

    // Edit5.Text:=QueryUserNo(stationNoStr);
end;
//�·ֲ���

procedure Tfrm_IC_485Testmain.BitBtn3Click(Sender: TObject);
var
  stationNoStr: string;
  stationNoStr1: string;
  ID_NO: string;
begin
  stationNoStr := '000301'; //��̨���
  ID_NO := 'F9923A3C'; //��ID��
  stationNoStr1 := Query_MacStatic_init_updownvalue(stationNoStr); //��̨��Ӧ�ı���ֵ

     //Update_LastRecord(stationNoStr);//�������¼�¼��ʶ�ֶ�
  AddTOTMembeDetail_down(ID_NO, stationNoStr1, stationNoStr); //�·ֲ���,��ICӮȡ����
    // Edit5.Text:=QueryUserNo(stationNoStr);
end;

 //��ѯ��Ӧվ���趨���Ϸ֡��·ֱ���ֵ Edt1

function Tfrm_IC_485Testmain.Query_MacStatic_init_updownvalue(S1: string): string;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: string;
  strIsable: string;
  i: integer;
begin

  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select distinct [Edt1] from [TChargMacSet],[TGameSet] where (TChargMacSet.GameNo=TGameSet.GameNo) and (TChargMacSet.MacID=''' + S1 + ''')';
  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    if (RecordCount > 0) then
    begin
                         //����ѯ�õ���ֵ���͸�IC
      reTmpStr := TrimRight(ADOQTemp.Fields[0].AsString);
    end
    else
      close;
  end;
  FreeAndNil(ADOQTemp);
  result := reTmpStr;
end;

//���ݵ�ǰ��̨�ϴ��Ŀ�ID�ż����˿������ߵ������Ϣ S1ΪID����ID_No��S2Ϊ�Ϸ֡��·ֱ���ֵstationNo_ValueStr

procedure Tfrm_IC_485Testmain.AddTOTMembeDetail_up(S1: string; S2: string; S3: string);
var
  strIDNo, strName, strUserNo, strIncvalue, strGivecore, strOperator, strhavemoney, strinputdatetime: string;

begin
  strUserNo := QueryUserNo(S1); //����ID_No��ѯ�˿��ĵ�ǰ�û����,�����������ֶ�
  Update_LastRecord(strUserNo); //���¼�¼�������û�������ֵ��¼�趨���¼�¼��־λ��Ϊ��0��
  strhavemoney := Query_TotalMoneyLastrecord(strUserNo); //���ݲ�ѯ�õ�����ID����ѯ�˿��ĵ�ǰ�����ߵ����³�ֵ�����֡��Ϸ֡��·ֲ�����¼�е�TotalMoney�ֶ�
 // if StrToInt(strhavemoney)>= StrToInt(S2) then  ���ж�����λIC����
  strhavemoney := IntToStr(StrToInt(strhavemoney) - StrToInt(S2)); //�˻����   //��ѯ�˿������ߵ����³�ֵ�����֡��Ϸ֡��·ּ�¼��TotalMoney  strIncvalue:=S2;             //�Ϸ�ֵ����PC���ݿ���д��IC��Ѻ�ֲ���
  strGivecore := '0'; //�ͷ�ֵ
  strOperator := '000'; //����Ա=��̨IC��վ��ֵ
  strinputdatetime := DateTimetostr((now())); //¼��ʱ�䣬��ȡϵͳʱ��
  with ADOQuery_MacUpdown do begin
    Append;

    FieldByName('CostMoney').AsString := S2; //��ֵ���Ϸ֡��·�
    FieldByName('TickCount').AsString := strGivecore;
    FieldByName('cUserNo').AsString := strOperator; //����Ա
    FieldByName('GetTime').AsString := strinputdatetime; //����ʱ��
    FieldByName('TotalMoney').AsString := strhavemoney; //�ʻ��ܶ�

    FieldByName('IDCardNo').AsString := S1; //ID����
    FieldByName('MemberName').AsString := strUserNo; //�û���
    FieldByName('MemCardNo').AsString := strUserNo; //�û����

    FieldByName('PayType').AsString := '2'; //�Ϸֲ������ͣ�������ֵ0������1���Ϸ�2���·�3��
    FieldByName('MacNo').AsString := 'A' + COPY(S3, 3, 4); //S2��̨��� Ҳ���ǻ�̨IC����վ��
    FieldByName('ExitCoin').AsInteger := 0;
    FieldByName('Compter').AsString := '1';
    FieldByName('LastRecord').AsString := '1';
    try
      Post;
    except
      on e: Exception do ShowMessage(e.Message);
    end;
  end;
  Edit5.Text := IntToStr(StrToInt(Edit5.Text) + 1);
end;

//���ݵ�ǰ��̨�ϴ��Ŀ�ID�ż����˿������ߵ������Ϣ S1ΪID����ID_No��S2Ϊ�Ϸ֡��·ֱ���ֵstationNo_ValueStr

procedure Tfrm_IC_485Testmain.AddTOTMembeDetail_down(S1: string; S2: string; S3: string);
var
  strIDNo, strName, strUserNo, strIncvalue, strGivecore, strOperator, strhavemoney, strinputdatetime: string;

begin
  strUserNo := QueryUserNo(S1); //����ID_No��ѯ�˿��ĵ�ǰ�û����,�����������ֶ�
  Update_LastRecord(strUserNo); //���¼�¼�������û�������ֵ��¼�趨���¼�¼��־λ��Ϊ��0��
  strhavemoney := Query_TotalMoneyLastrecord(strUserNo); //���ݲ�ѯ�õ�����ID����ѯ�˿��ĵ�ǰ�����ߵ����³�ֵ�����֡��Ϸ֡��·ֲ�����¼�е�TotalMoney�ֶ�


  strhavemoney := IntToStr(StrToInt(strhavemoney) + StrToInt(S2)); //�˻����   //��ѯ�˿������ߵ����³�ֵ�����֡��Ϸ֡��·ּ�¼��TotalMoney  strIncvalue:=S2;             //�Ϸ�ֵ����PC���ݿ���д��IC��Ѻ�ֲ���

  strGivecore := '0'; //�ͷ�ֵ
  strOperator := '000'; //����Ա=��̨IC��վ��ֵ
  strinputdatetime := DateTimetostr((now())); //¼��ʱ�䣬��ȡϵͳʱ��
  with ADOQuery_MacUpdown do begin
    Append;

    FieldByName('CostMoney').AsString := S2; //��ֵ���Ϸ֡��·�
    FieldByName('TickCount').AsString := strGivecore;
    FieldByName('cUserNo').AsString := strOperator; //����Ա
    FieldByName('GetTime').AsString := strinputdatetime; //����ʱ��
    FieldByName('TotalMoney').AsString := strhavemoney; //�ʻ��ܶ�

    FieldByName('IDCardNo').AsString := S1; //ID����
    FieldByName('MemberName').AsString := strUserNo; //�û���
    FieldByName('MemCardNo').AsString := strUserNo; //�û����

    FieldByName('PayType').AsString := '3'; //�Ϸֲ������ͣ�������ֵ0������1���Ϸ�2���·�3��
    FieldByName('MacNo').AsString := 'A' + COPY(S3, 3, 4); //S2��̨��� Ҳ���ǻ�̨IC����վ��
    FieldByName('ExitCoin').AsInteger := 0;
    FieldByName('Compter').AsString := '1';
    FieldByName('LastRecord').AsString := '1';
    try
      Post;
    except
      on e: Exception do ShowMessage(e.Message);
    end;
  end;
  Edit6.Text := IntToStr(StrToInt(Edit6.Text) + 1);
end;

 //���ݲ�ѯ�õ�����ID����ѯ�˿��ĵ�ǰ�����߸�����Ϣ

function Tfrm_IC_485Testmain.QueryUserNo(S: string): string;
var
  ADOQ: TADOQuery;
  strSQL, strRet: string;
  strsexOrg: string;
  strCompter: string;
begin
  strCompter := '1'; //Compter='1'��ʾ�˿��ĵ�ǰ������
  ADOQ := TADOQuery.Create(nil);
  strSQL := ' select MemberName from TMemberInfo where (IDCardNo=''' + S + ''') and (Compter=''' + strCompter + ''')';
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Open;
    if (RecordCount > 0) then
    begin
      strRet := ADOQ.Fields[0].AsString;
      Close;
    end
    else
    begin
      ShowMessage('ϵͳ���޴˿�������¼����ȷ�ϴ����Ƿ��Ա������');
      exit;
    end;
  end;
  FreeAndNil(ADOQ);

  Result := strRet;
end;

//���´˿���ֵ���Ϸ֡��·ֵ����¼�¼��ʶ�ֶ� LastRecord

procedure Tfrm_IC_485Testmain.Update_LastRecord(S: string);
var
  ADOQ: TADOQuery;
  strSQL, strRet: string;
  MaxID: string;
  setvalue: string;
begin

//���ݲ�ѯ�õ��ļ�¼MD_ID,���±�ʶ�ֶ�
  // MaxID:='110';
  setvalue := '0';
  strSQL := 'Update TMembeDetail set LastRecord=''' + setvalue + ''' where MD_ID in(select max(MD_ID) from TMembeDetail where MemCardNo=''' + S + ''')';
  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    ADOQ.ExecSQL;
  end;
  FreeAndNil(ADOQ);

end;
 //���ݲ�ѯ�õ�����ID����ѯ�˿��ĵ�ǰ�����ߵ����³�ֵ�����֡��Ϸ֡��·ֲ�����¼�е�TotalMoney�ֶ�

function Tfrm_IC_485Testmain.Query_TotalMoneyLastrecord(S: string): string;
var
  ADOQ: TADOQuery;
  strSQL, strRet: string;
  strsexOrg: string;
  strCompter: string;
begin
  ADOQ := TADOQuery.Create(nil);
  strSQL := ' select TotalMoney from TMembeDetail where MD_ID in(select max(MD_ID) from TMembeDetail where MemCardNo=''' + S + ''')';
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Open;
    if (RecordCount > 0) then
    begin
      strRet := ADOQ.Fields[0].AsString;
      Close;
    end
    else
    begin
      ShowMessage('ϵͳ���޴˿�������¼����ȷ�ϴ����Ƿ��Ա������');
      exit;
    end;
  end;
  FreeAndNil(ADOQ);

  Result := strRet;
end;
 //��ѯ��Ӧվ���·ֵĳ�ʼֵ

function Tfrm_IC_485Testmain.Query_MacStatic_init_downvalue(S1: string): string;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: string;
  strIsable: string;
  i: integer;
begin

  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select distinct [DOWN] from [MacStatic] where MacID=''' + S1 + '''';
  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    if (RecordCount > 0) then
    begin
                         //����ѯ�õ���ֵ���͸�IC
      reTmpStr := TrimRight(ADOQTemp.Fields[0].AsString);
    end
    else
      close;
  end;
  FreeAndNil(ADOQTemp);
  result := reTmpStr;
end;
 //��ѯ��Ӧվ���·ֵĳ�ʼֵ

function Tfrm_IC_485Testmain.Query_MacStatic_init_upvalue(S1: string): string;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: string;
  strIsable: string;
  i: integer;
begin

  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select distinct [UP] from [MacStatic] where MacID=''' + S1 + '''';
  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    if (RecordCount > 0) then
    begin
                         //����ѯ�õ���ֵ���͸�IC
      reTmpStr := TrimRight(ADOQTemp.Fields[0].AsString);
    end
    else
      close;
  end;
  FreeAndNil(ADOQTemp);
  result := reTmpStr;
end;
//���»�̨�ϡ��·ּ�¼��

procedure Tfrm_IC_485Testmain.UpdateMacStatic_up(S1: string; S2: string);
var
  ADOQ: TADOQuery;
  strSQL: string;
begin

  strSQL := 'Update MacStatic set UP=''' + S2 + ''' where MacID=''' + S1 + '''';
  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    ADOQ.ExecSQL;
  end;
  FreeAndNil(ADOQ);

end;
//���»�̨�ϡ��·ּ�¼��

procedure Tfrm_IC_485Testmain.UpdateMacStatic_down(S1: string; S2: string);
var
  ADOQ: TADOQuery;
  strSQL: string;
begin

  strSQL := 'Update MacStatic set DOWN=''' + S2 + ''' where MacID=''' + S1 + '''';
  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    ADOQ.ExecSQL;
  end;
  FreeAndNil(ADOQ);

end;
 //��ѯ��Ӧ���������

function Tfrm_IC_485Testmain.Query_TMemberInfo_CardAmount(S1: string): string;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: string;
  strIsable: string;
  i: integer;
begin
  strIsable := '1'; //��״̬Ϊ"����"
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select distinct [CardAmount] from [TMemberInfo] where IDCardNo=''' + S1 + ''' and IsAble=''' + strIsable + ''''; //��״̬Ϊ������������ֵΪ1
  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    if (RecordCount > 0) then
    begin
                         //����ѯ�õ���ֵ���͸�IC
      memComSeRe.Lines.Add(ADOQTemp.Fields[0].AsString);
      reTmpStr := TrimRight(ADOQTemp.Fields[0].AsString);
    end
    else
      close;
  end;
  FreeAndNil(ADOQTemp);
  result := reTmpStr;
end;


function Tfrm_IC_485Testmain.tranfertoHex(S1: string): string; //
var
  i: integer;
  restrtemp: string;
begin
  restrtemp := '';
  for i := 1 to length(S1) do
  begin
    restrtemp := restrtemp + '0' + copy(S1, i, 1);
  end;
  if length(S1) = 5 then
    restrtemp := '00' + restrtemp;
  if length(S1) = 4 then
    restrtemp := '00' + '00' + restrtemp;
  if length(S1) = 3 then
    restrtemp := '00' + '00' + '00' + restrtemp;
  if length(S1) = 2 then
    restrtemp := '00' + '00' + '00' + '00' + restrtemp;
  if length(S1) = 1 then
    restrtemp := '00' + '00' + '00' + '00' + '00' + restrtemp;
  result := restrtemp;
end;


procedure Tfrm_IC_485Testmain.FormShow(Sender: TObject);
begin
  comReader.StartComm();
  orderLst := TStringList.Create;
  recDataLst := tStringList.Create;
  recData_fromICLst := tStringList.Create;
  memComSeRe.Clear;
  InitStationNo;
  Edit5.Text := '0';
  Edit6.Text := '0';
end;

procedure Tfrm_IC_485Testmain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  orderLst.Free();
  recDataLst.Free();
  recData_fromICLst.Free();
  comReader.StopComm();
end;

//����Ӵ��ڽ��յ�����

procedure Tfrm_IC_485Testmain.comReaderReceiveData(Sender: TObject; Buffer: Pointer;
  BufferLength: Word);
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
    if (intTohex(ord(tmpStr[ii]), 2) = '4A') then
    begin
        //    recData_fromICLst.Add(recStr);             //����һ֡����Ϣת�棬�����ж�ָ�����
                //��Ӧ���յ���ָ������Ϸ��·ֲ�����----------
      //   break;
      tmpStrend := 'END';
    end;

  end;
  memComSeRe.Lines.Add('<<== ' + recStr); //�����յ���Ϣ��ʾ����
  recData_fromICLst.Add(recStr);
     // Dingwei[6] := copy(recData_fromICLst.Strings[0], 13+length_Data, 2);

  if (tmpStrend = 'END') then
  begin
    AnswerOper();
  end;
    //  Dingwei[6] := copy(recData_fromICLst.Strings[0], 13+length_Data, 2);


    //����---------------
  if curOrderNo < orderLst.Count then // �ж�ָ���Ƿ��Ѿ���������ϣ����ָ�����С��ָ���������������
    sendData()
  else begin
    checkOper();
    memComSeRe.Lines.Append('');
  end;
end;


 //�������ֵA1

procedure Tfrm_IC_485Testmain.SendCardAmount(S1: string); //�������ֵ
begin
  orderLst.Clear();
  recDataLst.Clear();
  curOrderNo := 0;
  curOperNo := 20;
  memComSeRe.Lines.Add('�ظ����ֵ��IC');
  orderLst.Add(S1);
   // orderLst.Add('020B0F');
  sendData();
end;



 //����վ�� A2

procedure Tfrm_IC_485Testmain.Bit_StationNosetClick(Sender: TObject);
var
  tmpStr: string;
begin
  tmpStr := ComboBox_StationNo.Text;
  if length(tmpStr) = 6 then
  begin
    tmpStr := 'AA8A' + '3F3F' + 'A2' + '04' + copy(tmpStr, 3, 4) + '4A';
    Send_StationNo(tmpStr);
  end;
end;

procedure Tfrm_IC_485Testmain.Send_StationNo(S1: string); //����վ��
begin
  orderLst.Clear();
  recDataLst.Clear();
  curOrderNo := 0;
  curOperNo := 21;
  memComSeRe.Lines.Add('�趨վ��');
  orderLst.Add(S1);
  sendData();
end;

 //����ȷ������ A4

procedure Tfrm_IC_485Testmain.BitBtn1Click(Sender: TObject);
var
  tmpStr: string;
begin
  tmpStr := Edit_Pwd.Text;
  if length(tmpStr) = 6 then
  begin
    tmpStr := 'AA8A' + '3F3F' + 'A4' + '06' + TrimRight(tmpStr) + '4A';
    Send_Pwd(tmpStr);
  end;
end;

procedure Tfrm_IC_485Testmain.Send_Pwd(S1: string); //���Ϳ�ȷ������
begin
  orderLst.Clear();
  recDataLst.Clear();
  curOrderNo := 0;
  curOperNo := 22;
  memComSeRe.Lines.Add('�趨����');
  orderLst.Add(S1);
  sendData();
end;




procedure Tfrm_IC_485Testmain.BitBtn4Click(Sender: TObject);
begin
  Close;
end;

end.
