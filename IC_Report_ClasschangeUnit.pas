unit IC_Report_ClasschangeUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, Buttons, ExtCtrls, ComCtrls, RpDefine,
  RpRender, RpRenderCanvas, RpRenderPrinter, RpRave, RpBase, RpSystem,
  RpRenderPreview, DBGridEhGrouping, GridsEh, DBGridEh, DB, ADODB, RpCon,
  RpConDS, RpConBDE, SPComm;

type
  Tfrm_IC_Report_Classchange = class(TForm)
    RvRenderPrinter1: TRvRenderPrinter;
    RvProject1: TRvProject;
    RvSystem1: TRvSystem;
    RvRenderPreview1: TRvRenderPreview;
    DataSource_Recrod: TDataSource;
    ADOQuery_Recrod: TADOQuery;
    DataSource_QueryRecord: TDataSource;
    ADOQuery_QueryRecord: TADOQuery;
    RvDataSetConnection1: TRvDataSetConnection;
    Panel8: TPanel;
    Panel2: TPanel;
    pgcMachinerecord: TPageControl;
    TabSheet2: TTabSheet;
    Tab_Gamenameinput: TTabSheet;
    Panel3: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    DBGridEh3: TDBGridEh;
    Panel1: TPanel;
    Panel5: TPanel;
    Panel4: TPanel;
    Label1: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Combo_Send: TComboBox;
    Panel9: TPanel;
    Panel10: TPanel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Combo_OP: TComboBox;
    ComboBox4: TComboBox;
    Panel12: TPanel;
    BitBtn4: TBitBtn;
    BitBtn6: TBitBtn;
    Edit_Sendmenber: TEdit;
    Edit_Acount: TEdit;
    Label11: TLabel;
    Label10: TLabel;
    Label12: TLabel;
    Edit_Recemenber: TEdit;
    BitBtn7: TBitBtn;
    Edit_ReceFromBoss: TEdit;
    Label13: TLabel;
    Edit_Have: TEdit;
    Label14: TLabel;
    comReader: TComm;
    Edit_ID: TEdit;
    DBGridEh_QueryRecord: TDBGridEh;
    DateTimePicker_Start_Menberinfo: TDateTimePicker;
    Label9: TLabel;
    DateTimePicker_End_Menberinfo: TDateTimePicker;
    TimePicker_End_Menberinfo: TDateTimePicker;
    TimePicker_Start_Menberinfo: TDateTimePicker;
    BitBtn2: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn1: TBitBtn;
    BitBtn3: TBitBtn;
    Edit1: TEdit;
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure Edit_AcountKeyPress(Sender: TObject; var Key: Char);
    procedure Edit_ReceFromBossKeyPress(Sender: TObject; var Key: Char);
    procedure Edit_HaveKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure comReaderReceiveData(Sender: TObject; Buffer: Pointer;
      BufferLength: Word);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
  private
    { Private declarations }
    procedure InitDataBase;
    procedure SaveData_CardID;
    procedure InitCombo_OP;
    procedure CheckCMD();
    procedure ClearText;
    function Query_UserNo(StrUserNo: string): string;
  public
    { Public declarations }
  end;

var
  frm_IC_Report_Classchange: Tfrm_IC_Report_Classchange;
  orderLst, recDataLst, recData_fromICLst: Tstrings;
implementation
uses ICDataModule, ICCommunalVarUnit, ICFunctionUnit, ICmain, ICEventTypeUnit, Fileinput_machinerecord_gamenameUnit, Fileinput_gamenameinputUnit,
  Fileinput_menbermatialupdateUnit;
{$R *.dfm}

procedure Tfrm_IC_Report_Classchange.InitDataBase;
var
  strSQL: string;
  comname: string;
begin

  with ADOQuery_Recrod do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    comname := '4';
    strSQL := 'select * from [TClassChangeInfor] order by ID DESC';
    SQL.Add(strSQL);
    Active := True;
  end;

end;

procedure Tfrm_IC_Report_Classchange.InitCombo_OP; //��ʼ����Ϸ����������
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  nameStr: string;
  i: integer;
begin
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select distinct[UserNo] from [3F_SysUser]   order by UserNo ASC ';
  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    Combo_OP.Items.Clear;
    Combo_OP.Items.Add('ȫ��');
    while not Eof do
    begin
      Combo_OP.Items.Add(FieldByName('UserNo').AsString);
      Next;
    end;
  end;
  FreeAndNil(ADOQTemp);
end;


procedure Tfrm_IC_Report_Classchange.BitBtn5Click(Sender: TObject);
begin
//RvProject1.Execute ; //���� RvProject1.ExecuteReport('Report1');
  Edit_Recemenber.Text := '';
  Edit_Recemenber.Text := Edit_ID.Text;
end;

procedure Tfrm_IC_Report_Classchange.BitBtn1Click(Sender: TObject);
begin
      //���������¼
     //Ψһ���ж�
  if (length(Trim(Edit_Sendmenber.Text)) = 0) then
  begin
    ShowMessage('��������Ϣ���ܿ�');
    exit;
  end;

  if (length(Trim(Edit_Recemenber.Text)) = 0) then
  begin
    ShowMessage('�Ӱ�����Ϣ���ܿ�');
    exit;
  end;
  if (length(Trim(Edit_ReceFromBoss.Text)) = 0) then
  begin
    ShowMessage('������ȡ��ֵ����Ϊ�գ�����0ʱ����������0');
    exit;
  end;
  if (length(Trim(Edit_Have.Text)) = 0) then
  begin
    ShowMessage('�������Ϊ�գ�����0ʱ����������0');
    exit;
  end;
  if (length(Trim(Edit_Acount.Text)) = 0) then
  begin
    ShowMessage('��ת����Ϊ�գ�����0ʱ����������0');
    exit;
  end;
  if (Edit_Sendmenber.Text = Edit_Recemenber.Text) then
  begin

    ShowMessage('�����˺ͽӰ��˲�����ͬ');
    Edit_Recemenber.Text := '';
    exit;
  end;

  SaveData_CardID; //���潻���¼
  ClearText;
end;




//���浱ǰ��¼��������ˮ�š�����ֵ����Ϣ

procedure Tfrm_IC_Report_Classchange.SaveData_CardID;
var
  ADOQ: TADOQuery;
  strSQL, strTemp: string;
begin

  //SaveData_OK_flag_CardID:=FALSE; //����������

  strSQL := 'select * from [TClassChangeInfor]';
  strTemp := '';
  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := true;

    Append;
    FieldByName('SendMenber').AsString := Edit_Sendmenber.Text;
    FieldByName('ReceMenber').AsString := Edit_Recemenber.Text;
    FieldByName('Get_Acount').AsString := Edit_ReceFromBoss.Text;
    FieldByName('Have_Acount').AsString := Edit_Have.Text;
    FieldByName('Send_Acount').AsString := Edit_Acount.Text;
    FieldByName('Send_Rece').AsString := Combo_Send.Text;
    FieldByName('Send_Time').AsString := FormatDateTime('yyyy-MM-dd HH:mm:ss', now);
    Post;
    Active := False;
  end;
  FreeAndNil(ADOQ);
  InitDataBase;
  //SaveData_OK_flag_CardID:=true; //����������
end;

procedure Tfrm_IC_Report_Classchange.BitBtn7Click(Sender: TObject);
begin
  close;
end;

procedure Tfrm_IC_Report_Classchange.Edit_AcountKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (key in ['0'..'9', #8, #13]) then
  begin
    key := #0;
    ShowMessage('�������ֻ���������֣�');
  end;

end;

procedure Tfrm_IC_Report_Classchange.Edit_ReceFromBossKeyPress(
  Sender: TObject; var Key: Char);
begin
  if not (key in ['0'..'9', #8, #13]) then
  begin
    key := #0;
    ShowMessage('�������ֻ���������֣�');
  end;

end;

procedure Tfrm_IC_Report_Classchange.Edit_HaveKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (key in ['0'..'9', #8, #13]) then
  begin
    key := #0;
    ShowMessage('�������ֻ���������֣�');
  end;

end;

procedure Tfrm_IC_Report_Classchange.FormShow(Sender: TObject);
begin

  comReader.StartComm();
  orderLst := TStringList.Create;
  recDataLst := tStringList.Create;
  recData_fromICLst := tStringList.Create;


  DateTimePicker_Start_Menberinfo.Date := StrToDate(copy(FormatDateTime('yyyy-MM-dd HH:mm:ss', now), 1, 10));
  DateTimePicker_End_Menberinfo.Date := StrToDate(copy(FormatDateTime('yyyy-MM-dd HH:mm:ss', now), 1, 10));
  TimePicker_Start_Menberinfo.Time := StrToTime(copy(FormatDateTime('yyyy-MM-dd HH:mm:ss', now), 12, 8));
  TimePicker_End_Menberinfo.Time := StrToTime(copy(FormatDateTime('yyyy-MM-dd HH:mm:ss', now), 12, 8));

  InitDataBase;
  InitCombo_OP;
  ClearText;
end;

procedure Tfrm_IC_Report_Classchange.ClearText;
begin
  Edit_Sendmenber.Text := '';
  Edit_Recemenber.Text := '';
  Edit_ReceFromBoss.Text := '0';
  Edit_Have.Text := '0';
  Edit_Acount.Text := '0';
end;

procedure Tfrm_IC_Report_Classchange.comReaderReceiveData(Sender: TObject;
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
       // if  (intTohex(ord(tmpStr[ii]),2)='4A') then
    if ii = BufferLength then
    begin
      tmpStrend := 'END';
    end;
  end;
     // Edit1.Text:=recStr;
  recData_fromICLst.Clear;
  recData_fromICLst.Add(recStr);
    //����---------------
     //if  (tmpStrend='END') then
  begin
    CheckCMD(); //���ȸ��ݽ��յ������ݽ����жϣ�ȷ�ϴ˿��Ƿ�����Ϊ��ȷ�Ŀ�
         //AnswerOper();//���ȷ���Ƿ�����Ҫ�ظ�IC��ָ��
  end;
    //����---------------
  //  if curOrderNo<orderLst.Count then    // �ж�ָ���Ƿ��Ѿ���������ϣ����ָ�����С��ָ���������������
  //      sendData()
  //  else begin
  //      checkOper();
  //  end;
end;
 //���ݽ��յ��������жϴ˿��Ƿ�Ϊ�Ϸ���

procedure Tfrm_IC_Report_Classchange.CheckCMD();
var
  tmpStr: string;
  ID_INIT: string;
  ID_3F: string;
  Password_3F: string;
  Password_USER: string;
  RevComd: string;
  ID_type: string;
begin
   //���Ƚ�ȡ���յ���Ϣ
  tmpStr := recData_fromICLst.Strings[0];
  Receive_CMD_ID_Infor.ID_CheckNum := copy(tmpStr, 39, 4); //У���
      // if (CheckSUMData(copy(tmpStr, 1, 38))=copy(tmpStr, 41, 2)+copy(tmpStr, 39, 2)) then//У���
  begin
    CMD_CheckSum_OK := true;
    RevComd := copy(recData_fromICLst.Strings[0], 1, 2); //֡ͷ43
  end;
                 //1���жϴ˿��Ƿ�Ϊ�Ѿ���ɳ�ʼ��
  if RevComd = CMD_COUMUNICATION.CMD_READ then
  begin

    ID_INIT := copy(recData_fromICLst.Strings[0], 3, 8); //��ƬID
    ID_3F := copy(recData_fromICLst.Strings[0], 11, 6); //����ID
    Password_3F := copy(recData_fromICLst.Strings[0], 17, 6); //����
    Password_USER := copy(recData_fromICLst.Strings[0], 23, 6); //�û�����
    ID_type := copy(recData_fromICLst.Strings[0], 37, 2); //������

                 //1���ж��Ƿ�������ʼ������ֻ��3F��ʼ�����Ŀ�������Ϊ���ܿ�AA �� �ϰ忨BB�������Ա�Ĳ��ܲ���
                 //if ICFunction.CHECK_3F_ID(ID_INIT,ID_3F,Password_3F) and ( (ID_type=copy(INit_Wright.Produecer_3F,8,2))or (ID_type=copy(INit_Wright.BOSS,8,2)) or (ID_type=copy(INit_Wright.MANEGER,8,2)) ) then
                 //20130116�޸�
    if ((ID_type = copy(INit_Wright.Produecer_3F, 8, 2)) or (ID_type = copy(INit_Wright.BOSS, 8, 2)) or (ID_type = copy(INit_Wright.MANEGER, 8, 2))) then

    begin
      Edit_ID.Text := '';
      Edit_ID.Text := ID_INIT;
      Label11.Caption := 'ע�⣺�����ȡǰ�뽫���������ڿ�ͷ�Ϸ�                   ';
    end
    else //�������ܿ�AA��Ҳ�����ϰ忨BB ��Ҳ���ǹ�����Ա
    begin
      Label11.Caption := '�Բ��𣡵�ǰ���޽������Ȩ��';
      Edit_ID.Text := '';
      exit;
    end;
  end;

end;

procedure Tfrm_IC_Report_Classchange.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  orderLst.Free();
  recDataLst.Free();
  recData_fromICLst.Free();
  comReader.StopComm();
end;

procedure Tfrm_IC_Report_Classchange.BitBtn2Click(Sender: TObject);
begin
  Edit_Sendmenber.Text := '';
  Edit_Sendmenber.Text := Edit_ID.Text;

end;

procedure Tfrm_IC_Report_Classchange.BitBtn6Click(Sender: TObject);
begin
  close;
end;

procedure Tfrm_IC_Report_Classchange.BitBtn3Click(Sender: TObject);
var
  strSQL: string;
  LastRecord: string;
  strWhere: string;

  strStartDate, strEndDate, strIsable, strcUserNo: string;
begin
  LastRecord := '1'; //���¼�¼��־λ

  strWhere := '';

  strWhere := strWhere + 'select *';
  strWhere := strWhere + 'from TClassChangeInfor ';
  strWhere := strWhere + 'where  ';

        //����һ
  strStartDate := FormatDateTime('yyyy-MM-dd', DateTimePicker_Start_Menberinfo.Date) + ' ' + FormatDateTime('hh:mm:ss', TimePicker_Start_Menberinfo.Time);
  strEndDate := FormatDateTime('yyyy-MM-dd', DateTimePicker_End_Menberinfo.Date) + ' ' + FormatDateTime('hh:mm:ss', TimePicker_End_Menberinfo.Time);


  strWhere := strWhere + ' (Send_Time>=''' + strStartDate + ''' and Send_Time<=''' + strEndDate + ''')';

      //������
  if Combo_OP.Text <> 'ȫ��' then
  begin
      //strcUserNo:=Query_Operater('''+TrimRight(ComboBox_Operator_Menberinfo.Text)+''');
    strcUserNo := Query_UserNo(TrimRight(Combo_OP.Text));
    Edit1.Text := strcUserNo;
    strWhere := strWhere + ' and SendMenber=''' + strcUserNo + '''';
  end;

     //������
  if ComboBox4.Text <> 'ȫ��' then
  begin
      //strIsable:=Query_Cardstate('''+TrimRight(ComboBox_Cardstate_Menberinfo.Text)+''');

    strWhere := strWhere + ' and Send_Rece=''' + ComboBox4.Text + '''';
  end;

  strSQL := '' + strWhere + '';

  with ADOQuery_QueryRecord do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;

  end;
end;


function Tfrm_IC_Report_Classchange.Query_UserNo(StrUserNo: string): string;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: string;
  strWhere: string;

begin
  ADOQTemp := TADOQuery.Create(nil);
  strWhere := 'select UserID from[3F_SysUser] where UserNo=''' + StrUserNo + '''';

  strSQL := '' + strWhere + '';
  Result := '';
  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    Result := ADOQTemp.Fields[0].AsString;
  end;
  FreeAndNil(ADOQTemp);

end;

procedure Tfrm_IC_Report_Classchange.BitBtn4Click(Sender: TObject);
begin
  RvProject1.Execute; //���� RvPro_MenberinfoPrint.ExecuteReport('Report1');
end;

end.
