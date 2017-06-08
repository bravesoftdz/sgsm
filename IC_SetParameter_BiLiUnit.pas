unit IC_SetParameter_BiLiUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, DBGrids, IniFiles, ExtCtrls, SPComm;

type
  Tfrm_SetParameter_BILI_INIT = class(TForm)
    Panel2: TPanel;
    Panel1: TPanel;
    comReader: TComm;
    Panel4: TPanel;
    BitBtn1: TBitBtn;
    Image1: TImage;
    Image2: TImage;
    Edit_BiLi: TEdit;
    BitBtn_BiLiSetComfir: TBitBtn;
    edit_exchangerate: TEdit;
    Lableexchangerate: TLabel;
    Label1: TLabel;
    procedure BitBtn_BiLiSetComfirClick(Sender: TObject);
    procedure Edit_BiLiKeyPress(Sender: TObject; var Key: Char);
    procedure comReaderReceiveData(Sender: TObject; Buffer: Pointer;
      BufferLength: Word);
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure CheckCMD();
  end;

var
  frm_SetParameter_BILI_INIT: Tfrm_SetParameter_BILI_INIT;
  orderLst, recDataLst, recData_fromICLst: Tstrings;
implementation
uses ICCommunalVarUnit, ICFunctionUnit, ICDataModule, strprocess;
{$R *.dfm}

procedure Tfrm_SetParameter_BILI_INIT.BitBtn_BiLiSetComfirClick(Sender: TObject);
var
  myIni: TiniFile;
  Edit_old_BiLi_check: string;
  Edit_comfir_BiLi_check: string;
begin




    //����Ҫ��ȡ��ֵ������ֵINit_Wright.MaxValue
  if FileExists(SystemWorkGroundFile) then
  begin
    myIni := TIniFile.Create(SystemWorkGroundFile);
    INit_Wright.MaxValue := MyIni.ReadString('PLC��������', 'PC����', '500'); //��ȡ���º�ı�ֵ����
    Edit_old_BiLi_check := MyIni.ReadString('PLC��������', 'PLC���屨�ϱ�־', 'D6010');
    //edit_exchangerate.Text :=  MyIni.ReadString('PLC��������', 'exchangerate','1');
    FreeAndNil(myIni);
  end;
    //�����㷨��������ľ��������õ��㷨ֵ Edit_old_password_check
  if Edit_BiLi.Text = '' then
  begin
    MessageBox(handle, '��������ұ���ֵ��', '����', MB_ICONERROR + MB_OK);
    exit;
  end;


  begin
            // ShowMessage('�����ֵ̫�󣬳���500���ܴ���'+INit_Wright.MaxValue+'�����������룡');
            // exit;
  end;
  if FileExists(SystemWorkGroundFile) then
  begin
    myIni := TIniFile.Create(SystemWorkGroundFile);
    Edit_comfir_BiLi_check := Edit_BiLi.Text; //�����������ֵ

    myIni.WriteString('PLC��������', 'PLC���屨�ϱ�־', Edit_comfir_BiLi_check); //д���ļ�

    if not IsNumberic(edit_exchangerate.Text) then
    begin
          ShowMessage('������󣬲�Ʊ�һ���ֻ���������֣�');
//          exit
    end;
    myIni.WriteString('PLC��������', 'exchangerate', edit_exchangerate.Text); //д���ļ�

    SystemWorkground.ErrorGTState := MyIni.ReadString('PLC��������', 'PLC���屨�ϱ�־', 'D6010');
    FreeAndNil(myIni);
  end;
  if SystemWorkground.ErrorGTState = Edit_comfir_BiLi_check then
  begin
    //Edit_BiLi.Text := '';
    BitBtn_BiLiSetComfir.Enabled := false;
    MessageBox(handle, '�޸Ĵ��ұ��������ɹ���', '�ɹ�', MB_OK);
    exit;
  end
  else
  begin
    SystemWorkground.ErrorGTState := Edit_old_BiLi_check;
    MessageBox(handle, '�޸Ĵ��ұ�������ʧ�ܣ�', 'ʧ��', MB_ICONERROR + MB_OK);
    exit;
  end;

  
end;

procedure Tfrm_SetParameter_BILI_INIT.Edit_BiLiKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (key in ['0'..'9', #8, #13]) then
  begin
    key := #0;
    ShowMessage('�������ֻ���������֣�');
  end
  else if key = #13 then
  begin
    if length(Edit_BiLi.Text) > 0 then
    begin
      BitBtn_BiLiSetComfir.Enabled := true;
    end
    else
    begin
      BitBtn_BiLiSetComfir.Enabled := false;
    end;
  end;
end;

procedure Tfrm_SetParameter_BILI_INIT.comReaderReceiveData(Sender: TObject;
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
    {
    if curOrderNo<orderLst.Count then    // �ж�ָ���Ƿ��Ѿ���������ϣ����ָ�����С��ָ���������������
        sendData()
    else begin
        checkOper();
    end;
    }


end;
 //���ݽ��յ��������жϴ˿��Ƿ�Ϊ�Ϸ���

procedure Tfrm_SetParameter_BILI_INIT.CheckCMD();
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
                 //if ICFunction.CHECK_3F_ID(Receive_CMD_ID_Infor.ID_INIT,Receive_CMD_ID_Infor.ID_3F,Receive_CMD_ID_Infor.Password_3F) and ( (Receive_CMD_ID_Infor.ID_type=copy(INit_Wright.Produecer_3F,8,2))or (Receive_CMD_ID_Infor.ID_type=copy(INit_Wright.BOSS,8,2)) ) then
    if DataModule_3F.Query_ID_OK(Receive_CMD_ID_Infor.ID_INIT) then
    begin
      if (Receive_CMD_ID_Infor.ID_type = copy(INit_Wright.BOSS, 8, 2)) or (Receive_CMD_ID_Infor.ID_type = copy(INit_Wright.MANEGER, 8, 2)) then
      begin
        begin
          Edit_BiLi.Enabled := true; //����޸ı���ֵ����
          edit_exchangerate.Enabled := true;
          
          BitBtn_BiLiSetComfir.Enabled := true; //����޸ı���ֵ����
          Edit_BiLi.Text := SystemWorkground.ErrorGTState;
          edit_exchangerate.Text := SystemWorkground.exchangerate;

        end;

      end
      else //�������ܿ�AA��Ҳ�����ϰ忨BB
      begin
                          //Label6.Caption:='����Ȩ�ޣ�';
        Edit_BiLi.Text := '����Ȩ�ޣ�';
        exit;
      end;
    end
    else //�������ܿ�AA��Ҳ�����ϰ忨BB
    begin
                          //Label6.Caption:='����Ȩ�ޣ�';
      Edit_BiLi.Text := '����Ȩ�ޣ�';
      exit;
    end;
  end;

end;


procedure Tfrm_SetParameter_BILI_INIT.FormShow(Sender: TObject);
begin

  ICFunction.InitSystemWorkground;
  Edit_BiLi.Text := '��ˢȨ�޿�';
  Edit_BiLi.Enabled := false; //����޸ı���ֵ����

  edit_exchangerate.Enabled :=false;          

  BitBtn_BiLiSetComfir.Enabled := false; //����޸ı���ֵ����
  comReader.StartComm();
  recDataLst := tStringList.Create;
  recData_fromICLst := tStringList.Create;
  orderLst := TStringList.Create;
end;

procedure Tfrm_SetParameter_BILI_INIT.BitBtn1Click(Sender: TObject);
begin
  close;
end;

procedure Tfrm_SetParameter_BILI_INIT.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  orderLst.Free();
  recDataLst.Free();
  recData_fromICLst.Free();

  comReader.StopComm();
end;

end.
