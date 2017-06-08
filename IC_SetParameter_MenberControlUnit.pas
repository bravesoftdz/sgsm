unit IC_SetParameter_MenberControlUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, IniFiles,
  Dialogs, SPComm, StdCtrls, Buttons, ExtCtrls;

type
  Tfrm_SetParameter_MenberControl_INIT = class(TForm)
    Panel2: TPanel;
    Panel1: TPanel;
    Image2: TImage;
    Panel4: TPanel;
    Image1: TImage;
    BitBtn3: TBitBtn;
    BitBtn_ChangBossPassword: TBitBtn;
    comReader: TComm;
    CheckBox_Update: TCheckBox;
    procedure BitBtn_ChangBossPasswordClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure comReaderReceiveData(Sender: TObject; Buffer: Pointer;
      BufferLength: Word);
  private
    { Private declarations }
  public
    { Public declarations }
    function exchData(orderStr: string): string;
    procedure sendData();
    procedure checkOper();
    procedure CheckCMD();
  end;

var
  frm_SetParameter_MenberControl_INIT: Tfrm_SetParameter_MenberControl_INIT;

  orderLst, recDataLst, recData_fromICLst: Tstrings;
implementation
uses ICDataModule, ICCommunalVarUnit, ICFunctionUnit, ICmain, Frontoperate_EBincvalueUnit, ICEventTypeUnit;
{$R *.dfm}
//ת�ҷ������ݸ�ʽ �����ַ�ת��Ϊ16����

function Tfrm_SetParameter_MenberControl_INIT.exchData(orderStr: string): string;
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

procedure Tfrm_SetParameter_MenberControl_INIT.sendData();
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

procedure Tfrm_SetParameter_MenberControl_INIT.checkOper();
var
  i: integer;
  tmpStr: string;
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


//�����趨�ĳ�������

procedure Tfrm_SetParameter_MenberControl_INIT.BitBtn_ChangBossPasswordClick(Sender: TObject);
var
  myIni: TiniFile;
  MenberControl_short_New: string;
  MenberControl_Enable: string;
  strtemp: string;
begin

  if CheckBox_Update.Checked then
  begin
        //ʵ�л�Ա������
    MenberControl_Enable := '1';
    INit_Wright.MenberControl_long := Copy(INit_Wright.MenberControl_long, 1, 4) + MenberControl_Enable;
  end
  else
  begin
    MenberControl_Enable := '0';
    INit_Wright.MenberControl_long := Copy(INit_Wright.MenberControl_long, 1, 4) + MenberControl_Enable;
  end;

  if FileExists(SystemWorkGroundFile) then
  begin
    myIni := TIniFile.Create(SystemWorkGroundFile);
    myIni.WriteString('PLC��������', 'PCϵͳ����', INit_Wright.MenberControl_long); //д���ļ�
    MenberControl_short_New := Copy(INit_Wright.MenberControl_long, 5, 1); //D6021�����һ���ַ�Ϊ�趨ֵ��1Ϊ���ã�0������
    FreeAndNil(myIni);
  end;


  if MenberControl_Enable = MenberControl_short_New then
  begin
    INit_Wright.MenberControl_short := MenberControl_short_New;
    if MenberControl_Enable = '1' then
    begin
      MessageBox(handle, ' ��ǰϵͳ��  ��  ʵ�л�Ա�ƹ���', '�ɹ�', MB_OK);
    end
    else
    begin
      MessageBox(handle, ' ��ǰϵͳ��  ����  ʵ�л�Ա�ƹ���', '�ɹ�', MB_OK);
    end;

    BitBtn_ChangBossPassword.Enabled := false; //����޸��������
    CheckBox_Update.Enabled := false;
    //exit;
  end
  else
  begin
    INit_Wright.MenberControl_long := Copy(INit_Wright.MenberControl_long, 1, 4) + INit_Wright.MenberControl_short;
    myIni.WriteString('PLC��������', 'PCϵͳ����', INit_Wright.MenberControl_long); //д���ļ�
    MessageBox(handle, '��ǰϵͳ��  ���� ʵ�л�Ա�ƹ���', 'ʧ��', MB_ICONERROR + MB_OK);
   // exit;
  end;
  close;
end;

procedure Tfrm_SetParameter_MenberControl_INIT.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  orderLst.Free();
  recDataLst.Free();
  recData_fromICLst.Free();
  comReader.StopComm();
  ICFunction.ClearIDinfor; //�����ID��ȡ��������Ϣ


end;

procedure Tfrm_SetParameter_MenberControl_INIT.FormShow(Sender: TObject);
begin
  ICFunction.InitSystemWorkPath; //��ʼ���ļ�·��
  ICFunction.InitSystemWorkground; //��ʼ����������

  comReader.StartComm();
  orderLst := TStringList.Create;
  recDataLst := tStringList.Create;
  recData_fromICLst := tStringList.Create;
    //Edit1.Text:=INit_Wright.MenberControl_long;
  CheckBox_Update.Enabled := false;
  BitBtn_ChangBossPassword.Enabled := false;
  if INit_Wright.MenberControl_short = '1' then

    CheckBox_Update.Checked := true
  else
    CheckBox_Update.Checked := false;
end;

procedure Tfrm_SetParameter_MenberControl_INIT.comReaderReceiveData(Sender: TObject; Buffer: Pointer;
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
  if curOrderNo < orderLst.Count then // �ж�ָ���Ƿ��Ѿ���������ϣ����ָ�����С��ָ���������������
    sendData()
  else begin
    checkOper();
  end;

end;
 //���ݽ��յ��������жϴ˿��Ƿ�Ϊ�Ϸ���

procedure Tfrm_SetParameter_MenberControl_INIT.CheckCMD();
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
  tmpStr := recData_fromICLst.Strings[0];

  Receive_CMD_ID_Infor.ID_CheckNum := copy(tmpStr, 39, 4); //У���

      // if (CheckSUMData(copy(tmpStr, 1, 38))=copy(tmpStr, 41, 2)+copy(tmpStr, 39, 2)) then//У���
  begin
    CMD_CheckSum_OK := true;
    Receive_CMD_ID_Infor.CMD := copy(recData_fromICLst.Strings[0], 1, 2); //֡ͷ43
  end;
                 //1���жϴ˿��Ƿ�Ϊ�Ѿ���ɳ�ʼ��
  if Receive_CMD_ID_Infor.CMD = CMD_COUMUNICATION.CMD_READ then
  begin

    Receive_CMD_ID_Infor.ID_INIT := copy(recData_fromICLst.Strings[0], 3, 8); //��ƬID
    Receive_CMD_ID_Infor.ID_3F := copy(recData_fromICLst.Strings[0], 11, 6); //����ID
    Receive_CMD_ID_Infor.Password_3F := copy(recData_fromICLst.Strings[0], 17, 6); //����
    Receive_CMD_ID_Infor.Password_USER := copy(recData_fromICLst.Strings[0], 23, 6); //�û�����
    Receive_CMD_ID_Infor.ID_value := copy(recData_fromICLst.Strings[0], 29, 8); //��������
    Receive_CMD_ID_Infor.ID_type := copy(recData_fromICLst.Strings[0], 37, 2); //������

                 //1���ж��Ƿ�������ʼ������ֻ��3F��ʼ�����Ŀ�������Ϊ���ܿ�AA �� �ϰ忨BB�Ĳ��ܲ���
               //  if ICFunction.CHECK_3F_ID(Receive_CMD_ID_Infor.ID_INIT,Receive_CMD_ID_Infor.ID_3F,Receive_CMD_ID_Infor.Password_3F) and ( (Receive_CMD_ID_Infor.ID_type=copy(INit_Wright.Produecer_3F,8,2))or (Receive_CMD_ID_Infor.ID_type=copy(INit_Wright.BOSS,8,2)) ) then
    if ((Receive_CMD_ID_Infor.ID_type = copy(INit_Wright.Produecer_3F, 8, 2)) or (Receive_CMD_ID_Infor.ID_type = copy(INit_Wright.BOSS, 8, 2))) then

    begin
      BitBtn_ChangBossPassword.Enabled := true; //����޸��������
      CheckBox_Update.Enabled := true;
    end
    else //�������ܿ�AA��Ҳ�����ϰ忨BB
    begin
      ShowMessage('����ʧ�ܣ�����Ȩ�ޣ�');
      exit;
    end;
  end;

end;


procedure Tfrm_SetParameter_MenberControl_INIT.BitBtn3Click(Sender: TObject);
begin
  Close;
end;




end.
