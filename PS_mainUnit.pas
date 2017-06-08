unit PS_mainUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Buttons, OleCtrls, MSCommLib_TLB,
  ACTCOMLKLib_TLB;

type
  TFrm_PS_Main = class(TForm)
    Panel2: TPanel;
    Panel17: TPanel;
    Panel16: TPanel;
    PageControl1: TPageControl;
    TabSheet2: TTabSheet;
    M_Behindoperate_Startwork: TBitBtn;
    M_Behindoperate_MCtest: TBitBtn;
    M_Behindoperate_SetPara: TBitBtn;
    M_Behindoperate_softexit: TBitBtn;
    Panel1: TPanel;
    Image1: TImage;
    Label_Title3: TLabel;
    Label_Title2: TLabel;
    Label_Title1: TLabel;
    Panel18: TPanel;
    Panel_Client: TPanel;
    Panel_Cur: TPanel;
    Panel_Next: TPanel;
    Panel_JHNum: TPanel;
    Panel_CurNum: TPanel;
    MsComm_Read: TMSComm;
    M_Behindoperate_Recordquery: TBitBtn;
    Timer1: TTimer;
    Timer_Init: TTimer;
    Panel_PCStatus: TPanel;
    Panel_PLCStatus: TPanel;
    Panel_PLCWorkStatus: TPanel;
    Panel_PartName: TPanel;
    Panel_None3: TPanel;
    ListBox_Event: TListBox;
    ActQJ71C241: TActQJ71C24;
    Mscomm_Write: TMSComm;
    Panel_None4: TPanel;
    Panel_None5: TPanel;
    procedure M_Behindoperate_SetParaClick(Sender: TObject);
    procedure M_Behindoperate_softexitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure M_Behindoperate_RecordqueryClick(Sender: TObject);
    procedure M_Behindoperate_StartworkClick(Sender: TObject);
    procedure M_Behindoperate_MCtestClick(Sender: TObject);
    procedure MsComm_ReadComm(Sender: TObject);
    procedure Mscomm_WriteComm(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer_InitTimer(Sender: TObject);
  private
    { Private declarations }
    procedure InitMsComm; //��ʼ��ͨ�Ŷ˿ڣ�����RFID��д
    procedure InitPanel;  //��ʼ�������Ϣ
    procedure WaitSleep(iSleep:integer); //�ȴ�
    procedure StartThread;    //��ʼ�߳�
    procedure SetWorkState(state:String);//���ù���״̬

    Procedure StartWork;  //��ʼ����
    //procedure SetEquipment(bColor:Boolean);
    procedure WriteHaveJiHua;    //д�ƻ�
  public
    { Public declarations }
    procedure WriteID(strv:String;r_w:String);  //дID
    procedure ReadID(strv:String;r_w:String);   //��ID

    procedure AddState(state:String);      //�������Ϣд������
    procedure SetXH(xh:String);//�����ͺ�
    procedure SetXH2(xh2:String);//����������
    procedure EndThread;           //�����߳�
    Function IsWorkState:Boolean;     //��ȡPLC������״̬�����߳��л����
  end;

var
  Frm_PS_Main: TFrm_PS_Main;

implementation

uses IR_EGtypeIncUnit,PS_MCtestUnit,PS_RecordUnit
,ICPLCCommunicationUnit,ICWorkThreadUnit
  ,ICCommunalVarUnit,ICDataModule,Logon;

{$R *.dfm}                
//ϵͳ����
procedure TFrm_PS_Main.M_Behindoperate_SetParaClick(Sender: TObject);
VAR
  iInterval:Cardinal;
  //iCount:integer;
  //strCount:String;
begin
  iInterval:=Timer1.Interval; //��¼��ǰ��TIMENER1�Ķ�ʱ�趨ֵ
  Timer1.Interval := 0;  //��ʱ�����趨��ʱֵΪ0

  InitPanel;   //��ʼ��
  EndThread;
  frm_PS_SetParame.Top := Panel_Client.Top+32;
  frm_PS_SetParame.Left:=Panel_Client.Left;
  frm_PS_SetParame.Height := Panel_Client.Height;
  frm_PS_SetParame.ShowModal;

  //���º�Ҫ���ǲ����мƻ�����������д��PLC���Ա�PLC���,�����ʱ��ã�����д���PLCҪ�����Щ��ʼ��������
  WriteHaveJiHua;

  Timer1.Interval := iInterval;
end;

procedure TFrm_PS_Main.M_Behindoperate_softexitClick(Sender: TObject);
begin
   close;
end;

procedure TFrm_PS_Main.FormCreate(Sender: TObject);
begin
  IsExit:=False;
  Timer_init.Enabled := True;
end;

procedure TFrm_PS_Main.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  IsExit:=True;
  While(WorkThread<>nil) do begin
    WorkThread.Terminate;
    Application.ProcessMessages;
    Sleep(100);
    end;
  try
    ICPLCCommunication.ClosePLC;
  Except
    End;
//  Application.Terminate;   ��ص������߳�
end;

procedure TFrm_PS_Main.M_Behindoperate_RecordqueryClick(Sender: TObject);
VAR
  iInterval:Cardinal;
begin
  iInterval:=Timer1.Interval;
  Timer1.Interval := 0;

  EndThread;
  frm_PS_Record.Top := Panel_Client.Top+32;
  frm_PS_Record.Left:=Panel_Client.Left;
  frm_PS_Record.Height := Panel_Client.Height;
  frm_PS_Record.ShowModal;

  Timer1.Interval:=iInterval;
end;

procedure TFrm_PS_Main.M_Behindoperate_StartworkClick(Sender: TObject);
begin
  //Timer1.Enabled := False;
  StartWork;
end;

procedure TFrm_PS_Main.M_Behindoperate_MCtestClick(Sender: TObject);
VAR
  iInterval:Cardinal;
begin
  iInterval:=Timer1.Interval;
  Timer1.Interval := 0;

  EndThread;
  frm_PS_MCtest.Top := Panel_Client.Top+32;
  frm_PS_MCtest.Left:=Panel_Client.Left;
  frm_PS_MCtest.Height := Panel_Client.Height;
  frm_PS_MCtest.ShowModal;

  Timer1.Interval := iInterval;
end;

//��RFIDͨ�Ŵ���
procedure TFrm_PS_Main.InitMsComm;
begin
  if(Mscomm_Read.PortOpen) then
    MsComm_Read.PortOpen := False;
    MsComm_Read.CommPort := SystemWorkground.ReadID.Port;
    MsComm_Read.Settings := SystemWorkground.ReadID.Setting;
  try
    MsComm_Read.PortOpen := True;
  Except
  End;

  if(Mscomm_Write.PortOpen) then
    Mscomm_Write.PortOpen := False;
    Mscomm_Write.CommPort := SystemWorkground.WriteID.Port;
    Mscomm_Write.Settings := SystemWorkground.WriteID.Setting;
  try
    Mscomm_Write.PortOpen := True;
  Except
  End;
end;
//���Ӷ�ID���Ĵ���
procedure TFrm_PS_Main.MsComm_ReadComm(Sender: TObject);
var
  strTemp:String;
begin
  if MSComm_Read.CommEvent = comEvReceive then begin
    strTemp:= MsComm_Read.Input;
    while(strTemp<>'') do begin
      SystemWorkground.ReadIDValue:=SystemWorkground.ReadIDValue+strTemp;
      WaitSleep(300);
      strTemp:=MsComm_Read.Input;
      end;
    //ShowMessage(SystemWorkground.ReadIDValue);    
    end;
end;
//����дID���Ĵ���
procedure TFrm_PS_Main.Mscomm_WriteComm(Sender: TObject);
var
  strTemp:String;
begin
  if MSComm_Write.CommEvent = comEvReceive then begin
    strTemp:= MSComm_Write.Input;
    while(strTemp<>'') do begin
      SystemWorkground.WriteidValue:=SystemWorkground.ReadIDValue+strTemp;
      WaitSleep(300);
      strTemp:=MSComm_Write.Input;
      end;
    //ShowMessage(SystemWorkground.WriteidValue);
    end;
end;


procedure TFrm_PS_Main.WaitSleep(iSleep:integer);
var
  iCount,iStep:integer;
begin
  iCount := 0;
  iStep:=100;
  while (iCount<iSleep) do begin
    Application.ProcessMessages;
    Sleep(iStep);
    iCount:=iCount+iStep;
    end;
end;


procedure TFrm_PS_Main.ReadID(strv: String;r_w:String);
var
  strTemp:String;
  iStart:integer;
begin
  strTemp:='0000'+IntToHex(SystemWorkground.ReadID.IDLength,2);//ת���ɳ���
  iStart:=Length(strTemp);
  strTemp:=Copy(strTemp,iStart-3,4);
  strTemp:='RDSTA1'+SystemWorkground.ReadID.Area+strTemp+'*'+Chr(13);

  //MsComm_Read.Output := strTemp;
  if(LowerCase(r_w)='r') then
    MsComm_read.Output := strTemp
  else
    MsComm_Write.Output := strTemp
end;


procedure TFrm_PS_Main.WriteID(strv: String;r_w:String);
var
  strTemp:String;
begin
  strTemp:='WTSTA1'+SystemWorkground.WriteID.Area+strv+'*'+Chr(13);
  if(LowerCase(r_w)='r') then
    MsComm_read.Output := strTemp
  else
    MsComm_Write.Output := strTemp
end;


procedure TFrm_PS_Main.InitPanel;
begin
  panel_cur.Caption := '��ǰ�ͺţ�';
  panel_Next.Caption := '��һ�ͺţ�';
  panel_curNum.Caption := '';

  ProType:='';
end;

procedure TFrm_PS_Main.StartThread;
begin
  //090720Ϊ�˱�֤���¼ƻ�����������ʾ
  Panel_JHNum.Caption := '�ƻ�������'+DataModule_3F.GetJHCount;
  DataModule_3F.DeleteSCWC('');//ɾ����ɵļƻ�
  //090720Ϊ�˱�֤���¼ƻ�����������ʾ
  
  if(WorkThread<>nil) then begin
    FreeAndNil(WorkThread);
    end;
  WorkThread:=TWorkThread.Create(Owner);
  WorkThread.Priority := tpNormal;
  WorkThread.Resume;
end;


procedure TFrm_PS_Main.AddState(state: String);
begin
  if(ListBox_Event.Items.Count>7) then begin
     ListBox_Event.Items.Delete(0);
    end;
  ListBox_Event.Items.Add(state);
  ListBox_Event.Selected[ListBox_Event.Items.Count-1]:=true;
end;


procedure TFrm_PS_Main.EndThread;
var
  PLCData:Array of Integer;
begin
  SetLength(PLCData,1);
  PLCData[0]:=2;
  ICPLCCommunication.WriteDataToPLC(SystemworkGround.PCRun,PLCData);
  //StartWork//���ϻ���
  //�����Ǹռ�
  if(WorkThread<>nil) then
    WorkThread.Terminate;
  M_Behindoperate_Startwork.Caption:='��ʼ����';
  SetWorkState('ֹͣ״̬');

  Panel_PCStatus.Color:=clRed;


  M_Behindoperate_SetPara.Enabled := True;
  M_Behindoperate_Recordquery.Enabled := True;
  if(G_User.UserOpration='����Ա') then
       M_Behindoperate_MCtest.Enabled := True;
end;


procedure TFrm_PS_Main.SetWorkState(state: String);
begin
  Panel_PLCWorkStatus.Caption:=state;
end;

procedure TFrm_PS_Main.SetXH(xh: String);
begin
  Panel_PartName.Caption := xh;
end;

procedure TFrm_PS_Main.SetXH2(xh2: String);
begin
  Panel_None3.Caption:=xh2;
end;


procedure TFrm_PS_Main.Timer1Timer(Sender: TObject);
var
  bRet:Boolean;
begin
  Timer1.Enabled := False;
  //StartWork;//�������ֺ�ȥ���˲���
//{//�����ֵ�
  bRet:=False;
 //�������ֺ�ſ��˲���
  if(not bOpen) then begin
    ICPLCCommunication.InitPLC;
    end;
  if(not bOpen) then begin
    Panel_PLCStatus.Color:=clRed;
    M_Behindoperate_Startwork.Enabled := False;
    bRet:=True;
    end
  else begin
    if(IsWorkState) then begin //�����ʼ����
      Panel_PLCStatus.Color:=clGreen;
      M_Behindoperate_Startwork.Enabled := True;
      StartWork;
      end
    else begin//���PLCδ��ʼ����
      EndThread;
      bRet:=True;
      end;
    end;

  Timer1.Enabled := bRet;
//}//�����ֵ�

end;


//��ʼ����
procedure TFrm_PS_Main.StartWork;
var
  PLCData:Array of integer;
begin
  SetLength(PLCData,1);
  if(M_Behindoperate_Startwork.Caption='��ʼ����') then begin
    M_Behindoperate_Startwork.Caption:='ֹͣ����';
    SetWorkState('����״̬');
    Panel_PCStatus.Color:=clGreen;

    M_Behindoperate_SetPara.Enabled := False;
    M_Behindoperate_Recordquery.Enabled := false;
    M_Behindoperate_MCtest.Enabled := False;
    PLCData[0]:=0;
    ICPLCCommunication.WriteDataToPLC(SystemworkGround.PCReCallRequestFDJ,PLCData);
    PLCData[0]:=1;
    ICPLCCommunication.WriteDataToPLC(SystemworkGround.PCRun,PLCData);
    if(IsWorkState) then
      StartThread;
    end
  else begin
    EndThread;
    end;
end;



//��ȡPLC�Ƿ����Զ�����״̬
function TFrm_PS_Main.IsWorkState: Boolean;
var
  bRet:Boolean;
  PLCData:Array of integer;
begin
  SetLength(PLCData,1);
  bRet:=ICPLCCommunication.ReadDataFromPLC(SystemworkGround.PLCRun,PLCData);
  if(bRet) then begin
    if(PLCData[0]=1) then begin
      bRet:=True;
      Panel_PLCStatus.Color:=clGreen;
      end
    else begin
      Panel_PLCStatus.Color:=clRed;
      EndThread;//090807�ӿ��ǲ���Ӱ���߳�
      bRet:=False;
      end;
    end
  else  begin
    if(MessageDlg('��ȡʧ�ܣ���������ι�����'+#13+#10+'��ȷ����PLC�����Ƿ���ȷ��',mtInformation,[mbYes,mbNo],0)=mrYes) then begin
      Close;
      end;
    end;
  Result:=bRet;
end;


{*
procedure TFrm_GQMain.SetEquipment(bColor: Boolean);
begin
  if(bColor) then
    Frame_Right_Main.Panel_PLCStatus.Color:=clGreen
  else
    Frame_Right_Main.Panel_PLCStatus.Color:=clRed;
end;
*}





procedure TFrm_PS_Main.Timer_InitTimer(Sender: TObject);
begin
  if(not Login) then Exit;
  Timer_Init.Enabled:=False;
  Timer_Init.Interval := 0;
  
  Timer1.Enabled := False;
  ICPLCCommunication.InitPLC;
  //InitMsComm;
  if(bOpen) then
    Panel_PLCStatus.Color:=clGreen;
  Panel_JHNum.Caption := '�ƻ�������'+DataModule_3F.GetJHCount;
  DataModule_3F.DeleteSCWC('');//ɾ����ɵļƻ�
  InitPanel;
  Timer1.Enabled := True;
end;


procedure TFrm_PS_Main.WriteHaveJiHua;
var
  PLCWriteData:Array of Integer;
  iCount:integer;
  strCount:String;
begin
  iCount:=0;
  try
    strCount:= DataModule_3F.GetJHCount; //���ú�������ܵļƻ���
    if(strCount<>'') then
      iCount:=StrToInt(DataModule_3F.GetJHCount);
  Except
    iCount:=0;
    End;
  SetLength(PLCWriteData,1);
  if(iCount>0) then begin
    PLCWriteData[0]:=1; //�мƻ�����PLCֵΪ1
    Panel_JHNum.Caption := '�ƻ�������'+DataModule_3F.GetJHCount;
    end
  else begin
    PLCWriteData[0]:=2;//�޼ƻ�����PLCֵΪ2
    Panel_JHNum.Caption:='';
    end;
  ICPLCCommunication.WriteDataToPLC(SystemWorkground.HaveJH,PLCWriteData);
end;

end.
