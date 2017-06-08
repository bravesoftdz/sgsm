{*
1.RequestFDJType
  ���ܣ�ʵ��PLC��Ҫ����ʱ��������д�����.
  ʵ�֣�D6000=1:PLC��Ҫ����
        ��PLCд����ͺ�,��D6100=1
        �ж�D6000=2(�ǲ���Ϊ2),���D6000=2,����D6100=0(ֻ��һ��)
        ���ʹ������:D6021-D6045
2.RequestClearBoard
  ���ܣ��������������Ϣ
  ʵ�֣�D6002=1:PLC�ж����̵�λ��Ҫ�����
        ������óɹ�D6102=1��ʧ��D6102=2.
        D6002=0����D6102=0(ֻ��һ��).
3.ClearBoard
  ���ܣ����������Ϣ
4.RequestWriteBoard
  ���ܣ�����������д����Ϣ
  ʵ�֣�D6004=1:PLC��Ҫ������д����Ϣ.
        д����óɹ�D6104=1,ʧ��D6104=2.
        D6004=0����D6104=0(ֻ��һ��).
5.WriteBoard
  ���ܣ�д��������Ϣ.
6.WriteFDJType
  ����: д��������Ϣ. 
*}
unit ICWorkThreadUnit;

interface
uses  Classes,SysUtils,Dialogs,Controls,ADODB,Forms,StrUtils;
type
  TWorkThread=Class(TThread)
  ADOQ:TADOQuery;

  private
    FDJTypeState:integer;
    ClearState:integer;
    WriteState:integer;
    WriteErrGTFlag:integer;
    GetFDJType:Boolean;//�ǲ������󷢶���
    GetClearBoard:Boolean;//�ǲ���������
    GetWriteBoard:Boolean;//�ǲ���д������
    bExistsErrGT:Boolean;       //�����Ǵ��ڴ������

    FDJLS:String;//��ǰ����������ˮ��
    SaveDXH,SaveRQ:String;//�������ݿ�Ķ��ͺ�

    bHaveJH:Boolean;   //�мƻ�


    procedure RequestFDJType;    //����������  ��Դ��PLC
    procedure RequestClearBoard;  // ���ID������ ��Դ��PLC
    function ClearBoard:Boolean;   //�𸴡����ID�����󡱣��ظ�PLC
    procedure RequestWriteBoard;  //дID������ ��Դ��PLC
    function WriteBoard:Boolean;  //�𸴡�дID�����󡱣��ظ�PLC
    function WriteFDJType:Boolean;  //�𸴡����������󡱣��ظ�PLC
    procedure ReadFDJType;        //��ȡ�������ͺţ���ȡ��������������ɨ����ɺ�����ݣ���дID��
    procedure WriteData(AddressName,strValue:String); //дID��
    function WriteErrorFDJType: Boolean;  //д����������

  protected
    procedure Execute; override;          //ִ��

  public
    Constructor Create(Owner:TComponent);   //�½��߳�
    Destructor Destroy; override;           //�ر��ͷ��߳�
    
  private
    Function UpdateData:Boolean;          //��������
    procedure FindErrorFDJ;//��ѯ�ǲ����б��Ϸ�����,�оʹ������ݿ�
    Function SendToShangLiao:Boolean;//�����̴���ķ�����,True�ǲ���,PLC���պ�����Faslse
    procedure WriteNoJiHua;   //֪ͨPLC�޼ƻ�
    procedure WriteHaveJiHua;   //֪ͨPLC�мƻ�
    function GetWeek:String;
    Function ChangeAreaToStr(arr:Array of integer;Len:integer):String;
  end;

var
  WorkThread:TWorkThread;

implementation

  uses  PS_mainUnit,ICPLCCommunicationUnit,ICDataModule,ICCommunalVarUnit,
  ICFunctionUnit;

  { TWorkThread }

//�½��߳�
constructor TWorkThread.Create(Owner: TComponent);
begin
  inherited Create(True);
  ADOQ:=TADOQuery.Create(nil);
end;

//�ر��ͷ��߳�
destructor TWorkThread.Destroy;
begin
  FreeAndNil(ADOQ);
  inherited;
end;

//�߳̿�ʼ
procedure TWorkThread.Execute;
//var
//  aa:array of integer;
begin
  inherited;
  FDJTypeState:=0;
  ClearState:=0;
  WriteState:=0;
  WriteErrGTFlag:=0;
  bHaveJH:=True;
  
  ReadFDJType;    //��ȡ�������ͺ� ����ȡ����ɨ����ɺ�����ݣ�����д��ID��
  {
  SetLength(aa,4);
  aa[0]:=19786;
  aa[1]:=12345;
  aa[2]:=120;
  aa[3]:=100;
  SaveDXH:=ChangeAreaToStr(aa,4);
  }//�����Ǻõ�

  while( (not Terminated) and (not IsExit) )do begin
    if(Frm_PS_Main.IsWorkState) then begin       //�����������ж�ȡPLC������״̬����
      //�˶��ڼ�������
      {
      if(DataModule_Main.GetJHCount='') then
        RequestFDJType
      else begin

        end;
      }
      RequestFDJType;     //���PLC���Զ�����״̬�����ȡPLC�ġ��������ͺ������ź�
      if(Terminated) then break;
      RequestClearBoard;   //���PLC���Զ�����״̬�����ȡPLC�ġ����ID�������ź�
      if(Terminated) then break;
      RequestWriteBoard;     //���PLC���Զ�����״̬�����ȡPLC�ġ�дID�������ź�
      if(Terminated) then break;
      FindErrorFDJ;     //���PLC���Զ�����״̬�����ȡPLC�ġ����������������ź�
      if(Terminated) then break;
      //�˶��ڼ�������
      Sleep(100);
      end
    else begin
      Sleep(800);
      end;

    end;
  if(ADOQ.Active) then
    ADOQ.Active := False;
  Frm_PS_Main.EndThread;   //�����������а�PC������״̬ ֪ͨPLC
  FreeAndNil(WorkThread);  //�ͷ��߳�
end;

//--------------------�����ǹ������̲���


//���ID��
function TWorkThread.ClearBoard:Boolean;
Var
  Ret:Boolean;
  strTemp:String;
  iCount:Integer;
begin
  Ret:=True;
  strTemp:=SystemWorkground.ClearStr;
  Frm_PS_Main.WriteID(strTemp,'r');   //������������дID������
  //�жϵ�*����
  iCount:=0;
  while(Pos('*',SystemWorkground.ReadidValue)<1) do begin
    Application.ProcessMessages;
    Sleep(300);
    Inc(iCount);
    if(iCount>SystemWorkground.ClearTPCS) then begin
      Ret:=False;
      Break;
      end;
    end;
  if(Ret) then begin
    ICFunction.DeleteChr(SystemWorkground.ReadidValue);    //����ַ����е�#0�����з��ţ�Cr��
    //�жϵ�*����

    if(Pos('WT00',SystemWorkground.ReadidValue)>0) then//'RD0010'
      Ret:=True
    else
      Ret:=False;
    end;

  SystemWorkground.ReadidValue:='';
  {
  Frm_PS_Main.ReadID('');     //�����������ж�ID������

  //�жϵ�*����
  while(Pos('*',SystemWorkground.ReadIDValue)<1) do begin
    Application.ProcessMessages;
    Sleep(300);
    end;
  ICFunction.DeleteChr(SystemWorkground.ReadIDValue);
  //�жϵ�*����
  iLen:=Length(SystemWorkground.ReadIDValue);
  strV:=Copy(SystemWorkground.ReadIDValue,7,iLen-8);
  if(strV=strTemp) then
    Ret:=true
  else
    Ret:=False;
  }

  Result:=Ret;
end;

procedure TWorkThread.RequestClearBoard;
var
  UnitName,UnitWriteName:String;
  PLCData,PLCWriteData:Array of integer;
begin
  UnitName:=SystemWorkground.PLCRequestClearTP ;//'D6002'; PLC����������
  UnitWriteName:=SystemWorkground.PCReCallClearTP;//'D6102'; PC��Ӧ������
  SetLength(PLCData,1);
  SetLength(PLCWriteData,1);
  if (not ICPLCCommunication.ReadDataFromPLC(UnitName,PLCData)) then begin
    if(MessageDlg('��ȡʧ�ܣ���������ι������ֹ��˳�����?',mtInformation,[mbYes,mbNo],0)=mrYes) then begin
      Terminate;
      end;
    end;
  if( (PLCData[0]=1) and (ClearState<>1) ) then begin  //(ClearState=0)
    Frm_PS_Main.AddState('->�յ���շ���������');
    GetClearBoard:=false;
    ClearState:=1;

    if(ClearBoard)then begin     //���� ClearBoard  �����ﶨ��
      Frm_PS_Main.AddState('<-��շ���������ɹ�');
      PLCWriteData[0]:=1;
      end
    else begin
      Frm_PS_Main.AddState('<-��շ���������ʧ��');
      PLCWriteData[0]:=2;
      end;

    ICPLCCommunication.WriteDataToPLC(UnitWriteName,PLCWriteData);  //PC��Ӧ������
    end
  //else if( (PLCData[0]=0) and (ClearState<>0)) then begin   //
  //  ClearState:=0;
  //  PLCWriteData[0]:=0;
  //  ICPLCCommunication.WriteDataToPLC(UnitWriteName,PLCWriteData);
  //  end
  else if (PLCData[0]<>1) then begin
    ClearState:=PLCData[0];
    ClearState:=0;
    end;
  if( (PLCData[0]=0) and (not GetClearBoard) ) then begin
    GetClearBoard:=true;
    Frm_PS_Main.AddState('�ȴ�������');

    ClearState:=0;
    PLCWriteData[0]:=0;
    ICPLCCommunication.WriteDataToPLC(UnitWriteName,PLCWriteData);
    end;
end;

//��ȡPLC�������ͺ�����
procedure TWorkThread.RequestFDJType;
var
  UnitName,UnitWriteName:String;
  PLCData,PLCWriteData:Array of integer;
  bSucceed:Boolean;
  
begin
  UnitName:=SystemWorkground.PLCRequestFDJ;//'D6000'; PLC���󷢶���
  UnitWriteName:=SystemWorkground.PCReCallRequestFDJ;//'D6100';  PC��Ӧ���󷢶���
  SetLength(PLCData,1);
  SetLength(PLCWriteData,1);
  if (not ICPLCCommunication.ReadDataFromPLC(UnitName,PLCData)) then begin
    if(MessageDlg('��ȡʧ�ܣ���������ι������ֹ��˳�����?',mtInformation,[mbYes,mbNo],0)=mrYes) then begin
      Terminate;
      Exit;
      end;
    end;
  if( (PLCData[0]=1) and (FDJTypeState<>1) ) then begin  //(FDJTypeState=0)
    Frm_PS_Main.AddState('->�յ�д�뷢��������');

    if(SendToShangLiao) then begin//SendToShangLiao����������ѯ�Ƿ����쳣���ݱ����Ƿ��С��ȴ����ļ�¼
      bSucceed:=WriteErrorFDJType;
      Frm_PS_Main.AddState('--׼��д���ϻ���');
      end
    else begin
      Frm_PS_Main.AddState('--׼��д��ƻ�����');
      bSucceed:=WriteFDJType;
      end;

    if(bSucceed) then begin//д�뷢�����ͺ�
    //if(WriteFDJType)then begin//д�뷢�����ͺ�,���ܴ����ͺ�ʱ�õ�
      FDJTypeState:=1;
      PLCWriteData[0]:=1;
      if( ICPLCCommunication.WriteDataToPLC(UnitWriteName,PLCWriteData) ) then begin //д��ɹ���1������2
        Frm_PS_Main.AddState('<-д�뷢��������ɹ�');
        end
      else begin
        FDJTypeState:=0;
        Frm_PS_Main.AddState('<-д�뷢������PLCʧ��');
        end;

      end
    else begin////WriteFDJType��Else
      PLCWriteData[0]:=2;
      ICPLCCommunication.WriteDataToPLC(UnitWriteName,PLCWriteData);
      Frm_PS_Main.AddState('<-д�뷢������PLCʧ��');
      end;
    end
  else if(  (PLCData[0]=2) and (FDJTypeState<>2) ) then begin  //and (FDJTypeState=1)
    FDJTypeState:=2;//0
    GetFDJType:=false;
    end
  else if ( (PLCData[0]=0)  ) then begin //�������ݿ�  //and (FDJTypeState<>1)
    //if( (FDJTypeState=2)  ) then//ֻ�д�2��Ϊ��ʱ�ű������ݲ��Ҹ�����ʾ//or (FDJTypeState=1)
    if( (not bExistsErrGT) and ((FDJTypeState=2)) ) then//����ĸ��岻�ٴ���
      bHaveJH:=UpdateData;
    if(bExistsErrGT) then begin
      DataModule_3F.UpdateErrorGT;
      bExistsErrGT:=False;
      end;
    //////////�ж��ǲ����мƻ����ϸ���
    if( (DataModule_3F.GetErrorGT ='') and (not bHaveJH) ) then begin
      WriteNoJiHua;
      //Frm_GQMain.EndThread;//����ƻ�Ϊ��Ҳ���ܽ�������Ϊ���һ��Ҫ��ɹ���
      end;

    FDJTypeState:=0;
    PLCWriteData[0]:=0;
    ICPLCCommunication.WriteDataToPLC(UnitWriteName,PLCWriteData);
    end
  else begin//�����������������ʱ��������ʲôֵдʲôֵ
    //PLCWriteData:=PLCData[0];
    //ICPLCCommunication.WriteDataToPLC(UnitWriteName,PLCWriteData);
    //FDJTypeState:=PLCData[0];
    end;
  if( ((PLCData[0]=0) or (PLCData[0]=2)) and (not GetFDJType) ) then begin
    Frm_PS_Main.AddState('�ȴ����󷢶����ͺ�');
    GetFDJType:=True;
    end;

end;

//��ȡPLCд����ID����  ��ɨ����Ϻ�
procedure TWorkThread.RequestWriteBoard;
var
  UnitName,UnitWriteName:String;
  PLCData,PLCWriteData:Array of integer;
begin
  UnitName:=SystemWorkground.PLCRequestWriteTP;//'D6004';
  UnitWriteName:=SystemWorkground.PCReCallWriteTP;//'D6104';
  SetLength(PLCData,1);
  SetLength(PLCWriteData,1);
  
  if (not ICPLCCommunication.ReadDataFromPLC(UnitName,PLCData)) then begin
    if(MessageDlg('��ȡʧ�ܣ���������ι������ֹ��˳�����?',mtInformation,[mbYes,mbNo],0)=mrYes) then begin
      Terminate;
      Exit;
      end;
    end;
  if( (PLCData[0]=1) and (WriteState<>1) ) then begin//(WriteState=0)
    Frm_PS_Main.AddState('->�յ�д����ָ��');
    WriteState:=1;
    GetWriteBoard:=False;
    if(WriteBoard)then begin  //�ж�д����ID�Ƿ�ɹ����
      Frm_PS_Main.AddState('<-д���̳ɹ�');
      PLCWriteData[0]:=1;
      //������
      //DataModule_3F.SaveWriteDI(SaveDxh,FDJLS,SaveRQ);
      DataModule_3F.SaveCurRecord(SaveDXH,FDJLS);//д����ˮ�������Ա���ѯʹ��
      //������
      end
    else begin
      Frm_PS_Main.AddState('<-д����ʧ��');
      PLCWriteData[0]:=2;
      end;
    ICPLCCommunication.WriteDataToPLC(UnitWriteName,PLCWriteData);
    end
  //else if( (PLCData[0]=0) and (WriteState<>0) ) then begin
  //  WriteState:=0;
  //  PLCWriteData[0]:=0;
  //  ICPLCCommunication.WriteDataToPLC(UnitWriteName,PLCWriteData);
    //ԭ���ڴ����Ƽ�¼
  //  end
  else if( PLCData[0]<>1 ) then begin
    WriteState:=PLCData[0];
    WriteState:=0;
    end;
  if( (PLCData[0]=0) and (not GetWriteBoard) ) then begin
    GetWriteBoard:=True;
    Frm_PS_Main.AddState('�ȴ�д����');

    WriteState:=0;
    PLCWriteData[0]:=0;
    ICPLCCommunication.WriteDataToPLC(UnitWriteName,PLCWriteData);
    end;
end;

//���ݶ�ȡPLC��д����ID���󣬽�ɨ����ϵĹ��������Ϣ��д��ID��
function TWorkThread.WriteBoard:Boolean;
Var
  Ret:Boolean;
  UnitWriteName:String;
  PLCWriteData:Array of integer;
  strFDJ_DXH,strFDJ_XH,strFDJ_XH2,strFDJ_LS,strDate:String;
  i,iFor,iCount:integer; //iRet,
  strTemp:String;
  strV:String;
Label ExitSub;
begin
  Ret:=True;
  
  SetLength(PLCWriteData,1);
  UnitWriteName:=SystemWorkground.PCReadFanHao;
  PLCWriteData[0]:=0;
  strV:=IntToStr(0)+IntToStr(0);
  if(Trim(ADOQ.FieldByName('״̬').AsString)='���') then begin
    Ret:=False;
    goto ExitSub;
    end;

  //�������ͺ�
  strFDJ_DXH:='';
  SetLength(PLCWriteData,2);
  iFor:=2;
  strV:=IntToStr(0)+IntToStr(0);
  ICPLCCommunication.ReadDataFromPLC(UnitWriteName,PLCWriteData);
  strFDJ_DXH := ChangeAreaToStr(PLCWriteData,iFor);
  {
  for i:=1 to iFor do begin
    if(PLCWriteData[i-1]=0)then continue;
    strTemp:=IntToHex(PLCWriteData[i-1],2);
    iRet:=HexToBin(PChar(strTemp),PChar(strV),2);
    if(iRet>1) then
      strFDJ_DXH:=strFDJ_DXH+strV[2]+strV[1]
    else
      strFDJ_DXH:=strFDJ_DXH+strV[1];
    end;
  }


  SaveDXH:=strFDJ_DXH;
  //��������
  UnitWriteName:=SystemWorkground.PCReadFDJ;
  strFDJ_XH:='';
  iFor:=4;
  SetLength(PLCWriteData,(iFor));
  strV:=IntToStr(0)+IntToStr(0);
  ICPLCCommunication.ReadDataFromPLC(UnitWriteName,PLCWriteData);
  strFDJ_XH:= ChangeAreaToStr(PLCWriteData,iFor);
  {
  for i:=1 to iFor do begin
    if(PLCWriteData[i-1]=0)then continue;
    strTemp:=IntToHex(PLCWriteData[i-1],2);
    iRet:=HexToBin(PChar(strTemp),PChar(strV),2);
    if(iRet>1) then
      strFDJ_XH:=strFDJ_XH+strV[2]+strV[1]
    else
      strFDJ_XH:=strFDJ_XH+strV[1];
    end;
  }
  //�����������ͺ�
  UnitWriteName:=SystemWorkground.PCReadTZ;
  strFDJ_XH2:='';
  iFor:=4;
  SetLength(PLCWriteData,(iFor));
  ICPLCCommunication.ReadDataFromPLC(UnitWriteName,PLCWriteData);
  strFDJ_XH2:= ChangeAreaToStr(PLCWriteData,iFor);
  {
  for i:=1 to iFor do begin
    if(PLCWriteData[i-1]=0)then continue;
    strTemp:=IntToHex(PLCWriteData[i-1],2);
    iRet:=HexToBin(PChar(strTemp),PChar(strV),2);
    if(iRet>1) then
      strFDJ_XH2:=strFDJ_XH2+strV[2]+strV[1]
    else
      strFDJ_XH2:=strFDJ_XH2+strV[1];
    end;
  }
  //������ˮ��
  UnitWriteName:=SystemWorkground.PCReadLS;
  strFDJ_LS:='';
  iFor:=4;
  SetLength(PLCWriteData,(iFor));
  ICPLCCommunication.ReadDataFromPLC(UnitWriteName,PLCWriteData);
  strFDJ_LS:= ChangeAreaToStr(PLCWriteData,iFor);
  {
  for i:=1 to iFor do begin
    strTemp:=IntToHex(PLCWriteData[i-1],2);
    iRet:=HexToBin(PChar(strTemp),PChar(strV),2);
    if(iRet>1) then
      strFDJ_LS:=strFDJ_LS+strV[2]+strV[1]
    else
      strFDJ_LS:=strFDJ_LS+strV[1];
    end;
  }
  if(Length(strFDJ_LS)>7) then
    strFDJ_LS:=LeftStr(strFDJ_LS,7);
  //FDJLS:=strFDJ_LS;//ȡ����������ˮ���Ա�����JNYH_��ˮ������  ����
  strFDJ_LS:=Trim(strFDJ_LS);
  FDJLS:=CurYear+strFDJ_LS;
  //����������
  UnitWriteName:=SystemWorkground.PCReadYear;
  strDate:='';
  iFor:=6;
  SetLength(PLCWriteData,(iFor));
  ICPLCCommunication.ReadDataFromPLC(UnitWriteName,PLCWriteData);
  for i:=1 to iFor do begin
    strTemp:=IntToStr(PLCWriteData[i-1]);
    if(i>1) then begin
      if(Length(strTemp)<2) then begin
        strTemp:= '00'+strTemp;
        strTemp:=RightStr(strTemp,2);
        end;
      end;
    strDate:=strDate+strTemp;
    end;
  SaveRQ:=strDate;
  //strV:=strDate+strFDJ_XH+strFDJ_LS;//091130ǰ
  //strV:=strDate+GetWeek+strFDJ_XH+' '+strFDJ_LS; //20100304ǰ
  strV:=strDate+GetWeek+strFDJ_XH+' '+CurYear+strFDJ_LS; //
  Frm_PS_Main.WriteID(strV,'w');

  //�жϵ�*����
  iCount:=0;
  while(Pos('*',SystemWorkground.WriteidValue)<1) do begin
    Application.ProcessMessages;
    Sleep(300);
    Inc(iCount);
    if(iCount>SystemWorkground.WriteTPCS) then begin
      Ret:=False;
      Break;
      end;
    end;
  if(Ret) then begin
    ICFunction.DeleteChr(SystemWorkground.WriteidValue);
    //�жϵ�*����

    if(Pos('WT00',SystemWorkground.WriteidValue)>0) then
      Ret:=True
    else
      Ret:=False;
    end;
  SystemWorkground.WriteidValue:='';
ExitSub:
  Result:=Ret;
end;


//����PLC�ķ���������PC��PLCд�뵱ǰ�����ƻ��������Ϣ�����š��ϵ��ŵ�
function TWorkThread.WriteFDJType: Boolean;
Var
  Ret:Boolean;
  UnitWriteName:String;
  PLCWriteData:Array of integer;
  strFDJ_DXH,strFDJ_XH,strFDJ_LD,strFDJ_XH2:String;  
Label ExitSub;
begin
  UnitWriteName:=SystemWorkground.PCWriteLD;//'D6021';  PCд�뷬��
  if(ADOQ.RecordCount=0) then begin
    Ret:=False;
    goto ExitSub;
    end;
  if(Trim(ADOQ.FieldByName('״̬').AsString)='���') then begin
    Ret:=False;
    goto ExitSub;
    end;

  strFDJ_DXH:= ADOQ.FieldByName('���ͺ�').AsString;
  strFDJ_XH:= ADOQ.FieldByName('�ͺ�').AsString;
  strFDJ_XH2:= ADOQ.FieldByName('�ͺ�2').AsString;
  strFDJ_LD:= ADOQ.FieldByName('�ϵ���').AsString;

  //strFDJ_LD:='4';//������
  //д���ϵ���
  SetLength(PLCWriteData,1);
  try
    PLCWriteData[0]:=StrToInt(Trim(strFDJ_LD));
  Except
    ShowMessage('�ϵ����ô���');
    end;
  ICPLCCommunication.WriteDataToPLC(UnitWriteName,PLCWriteData);

  //д����ͺ�
  UnitWriteName:=SystemWorkground.PCWriteFanHao;
  WriteData(UnitWriteName,strFDJ_DXH);

  //д���ͺ�
  UnitWriteName:=SystemWorkground.PCWriteType;
  WriteData(UnitWriteName,strFDJ_XH);

  //д������ƥ�����ͺ�
  UnitWriteName:=SystemWorkground.PCWriteTZ;
  WriteData(UnitWriteName,strFDJ_XH2);

  Ret:=True;
ExitSub:
  Result:=Ret;
end;



//��ѯ���ݿ��������ƻ�������ĵ�ǰ�ƻ���Ϣ ,������������ʾ
procedure TWorkThread.ReadFDJType;
var
  strSQL:String;
  PLCWriteData:Array of integer;
begin
  ProType:='';
  with ADOQ do begin
    Close;
    strSQL:='select [���ͺ�],[�ͺ�],[�ͺ�2],[�ϵ���],[״̬],[���������] '
      +' from [JNYH_����] where ( ([״̬] is null) or ([״̬]<>''���'') ) order by [���������]';
    ADOQ.Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Open;
    First;
    if(not Eof) then begin
      Frm_PS_Main.Panel_Cur.Caption := '��ǰ�ͺ�:'+FieldByName('���ͺ�').AsString;
      Frm_PS_Main.Panel_CurNum.Caption:= '��ǰ�ƻ�:'+FieldByName('���������').AsString;
      Frm_PS_Main.SetXH(FieldByName('�ͺ�').AsString);
      Frm_PS_Main.SetXH2(FieldByName('�ͺ�2').AsString);

      //Frm_PS_Main.Panel_Cur.Caption := '��ǰ�ͺ�:'+ProType;
      //ProType:= FieldByName('���ͺ�').AsString;

      SetLength(PLCWriteData,1);
      PLCWriteData[0]:=1;
      ICPLCCommunication.WriteDataToPLC(SystemWorkground.HaveJH,PLCWriteData);

      Next;
      if(not Eof) then begin
        Frm_PS_Main.Panel_Next.Caption := '��һ�ͺ�:'+FieldByName('���ͺ�').AsString;
        Prior;
        end
      else
        Frm_PS_Main.Panel_Next.Caption := '��һ�ͺ�:�޼ƻ�';
      end
    else begin
      Frm_PS_Main.Panel_Cur.Caption := '��ǰ�ͺ�:�޼ƻ�';
      bHaveJH:=False;
      SetLength(PLCWriteData,1);
      PLCWriteData[0]:=2;
      ICPLCCommunication.WriteDataToPLC(SystemWorkground.HaveJH,PLCWriteData);
      Frm_PS_Main.Panel_Next.Caption := '��һ�ͺ�:�޼ƻ�';
      Frm_PS_Main.EndThread;
      end;
    end;
end;

// д���ݵ�PLC�ĺ���
procedure TWorkThread.WriteData(AddressName,strValue:String);
Var
  PLCWriteData:Array of Integer;
  strTemp:String;
  iFor,i:integer;
begin
  SetLength(PLCWriteData,Length(strValue));
  iFor:= (Length(strValue)+1) Div 2;
  For i:=0 to iFor-1 do begin
    strTemp:=IntToHex(Ord(strValue[i*2+2]),2)+IntToHex(Ord(strValue[i*2+1]),2);
    PLCWriteData[i]:=StrToInt('$'+strTemp);
    end;
  ICPLCCommunication.WriteDataToPLC(AddressName,PLCWriteData);
end;

//�������ݿ��е�����
Function TWorkThread.UpdateData:Boolean;
var
  //PLCWriteData:array of integer;
  bRet:Boolean;
begin
  bRet:=True;
  ADOQ.Edit;
  ADOQ.FieldByName('״̬').AsString := '���';
  ADOQ.Post;
  DataModule_3F.SaveCurJHSL(ADOQ.FieldByName('���ͺ�').AsString);
  if(not ADOQ.Eof) then begin//д�뵱ǰ�ƻ���ʲô
    ADOQ.Next;
    if(not ADOQ.Eof) then begin
      ProType:= ADOQ.FieldByName('���ͺ�').AsString;
     Frm_PS_Main.Panel_Cur.Caption := '��ǰ�ͺ�:'+ProType;
     Frm_PS_Main.Panel_CurNum.Caption:= '��ǰ�ƻ�:'+ADOQ.FieldByName('���������').AsString;
     Frm_PS_Main.SetXH(ADOQ.FieldByName('�ͺ�').AsString);
     Frm_PS_Main.SetXH2(ADOQ.FieldByName('�ͺ�2').AsString);
      end
    else begin
      ProType:='�޼ƻ�';
      Frm_PS_Main.Panel_Cur.Caption:='��ǰ�ͺ�:'+ProType;
      bRet:=False;
      //SetLength(PLCWriteData,1);
      //PLCWriteData[0]:=2;
      //ICPLCCommunication.WriteDataToPLC(SystemWorkground.HaveJH,PLCWriteData);
      //Frm_PS_Main.EndThread;

      Frm_PS_Main.AddState('<-��ǰ�ƻ�����');
      end;
    end
  else begin
    ProType:='�޼ƻ�';
    Frm_PS_Main.Panel_Cur.Caption:='��ǰ�ͺ�:'+ProType;
    bRet:=False;
    //SetLength(PLCWriteData,1);
    //PLCWriteData[0]:=2;
    //ICPLCCommunication.WriteDataToPLC(SystemWorkground.HaveJH,PLCWriteData);
    //Frm_PS_Main.EndThread;
      
    Frm_PS_Main.AddState('<-��ǰ�ƻ�����');
    end;

  //д����һ����¼
  if(not ADOQ.Eof) then begin
    ADOQ.Next;
    if(not ADOQ.Eof) then begin
      Frm_PS_Main.Panel_Next.Caption := '��һ�ͺ�:'+ADOQ.FieldByName('���ͺ�').AsString;
      ADOQ.Prior;
      end
    else begin
      Frm_PS_Main.Panel_Next.Caption := '��һ�ͺ�:�޼ƻ�';
      end;

    end
  else begin
    Frm_PS_Main.Panel_Next.Caption := '��һ�ͺ�:�޼ƻ�';
    end;
  Result:=bRet;
end;



//��ȡPLC�д���쳣��־λ����Ϣ �����Ӧ�ķ������ͺ�
procedure TWorkThread.FindErrorFDJ;
var
  PLCWriteData:Array of integer;
  strDXH:String;
begin
  SetLength(PLCWriteData,1);
  PLCWriteData[0]:=0;
      // ErrorGTState:String;            //��ϸ���ı�־ D6010
  ICPLCCommunication.ReadDataFromPLC(SystemWorkground.ErrorGTState,PLCWriteData);

  if( (PLCWriteData[0]=1) and (WriteErrGTFlag=0) ) then begin//��ʾ���쳣����
    WriteErrGTFlag:=1;
    SetLength(PLCWriteData,2);


    // ErrorGT     :String;            //��ϸ���ķ���D6301

    ICPLCCommunication.ReadDataFromPLC(SystemWorkground.ErrorGT,PLCWriteData);

    strDXH:=ChangeAreaToStr(PLCWriteData,2);//��������
    DataModule_3F.SaveErrorGT(strDXH);  //�������쳣�ķ������ͺŽ��쳣���ݱ���

    PLCWriteData[0]:=1;
    ICPLCCommunication.WriteDataToPLC(SystemWorkground.PCErrorGTFlag,PLCWriteData);
    Frm_PS_Main.AddState('->�յ���ϻ���');
    WriteHaveJiHua;//�յ���Ѹ����Ҫ�����мƻ�����
    end
  else if ( (PLCWriteData[0]=0) and (WriteErrGTFlag=1) ) then begin 
    PLCWriteData[0]:=0;
    WriteErrGTFlag:=0;
        // PCErrorGTFlag:String;           //��ϸ�����ձ�־ D6110
    ICPLCCommunication.WriteDataToPLC(SystemWorkground.PCErrorGTFlag,PLCWriteData);
    end;

end;

function TWorkThread.ChangeAreaToStr(arr: array of integer;Len:integer): String;
var
  strTemp,strV,strV2:String;
  i,iRet:integer;
begin
  strV2:=IntToStr(0)+IntToStr(0);
  for i:=1 to Len do begin
    if(arr[i-1]=0)then continue;
    strTemp:=IntToHex(arr[i-1],2);
    iRet:=HexToBin(PChar(strTemp),PChar(strV2),2);
    if(iRet>1) then
      strV:=strV+strV2[2]+strV2[1]
    else
      strV:=strV+strV2[1];
    end;
  Result := strV;
end;


//������쳣�����Ƿ��С��ȴ����ļ�¼
Function TWorkThread.SendToShangLiao:Boolean;
var
  bRet:Boolean;
begin
  bRet:=False;
  bExistsErrGT:=False;
  if(DataModule_3F.GetErrorGT <>'') then begin  //���쳣���ݱ��в�ѯ���ȴ����ļ�¼
    bRet:=True;
    bExistsErrGT:=True;
    end;
  Result := bRet;
end;

//���쳣���ݱ��еġ��ȴ�����¼��Ϣд��PLC���������Ӧ���ϵ��ŵ�
function TWorkThread.WriteErrorFDJType: Boolean;
Var
  Ret:Boolean;
  UnitWriteName,strSQL:String;
  PLCWriteData:Array of integer;
  strFDJ_DXH,strFDJ_XH,strFDJ_LD,strFDJ_XH2:String;
  ADOQErr:TADOQuery;
Label ExitSub;
begin
  ADOQErr:=TADOQuery.Create(nil);
  ADOQErr.Connection := DataModule_3F.ADOConnection_Main;
  strSQL:='select [���ͺ�],[���״̬],[����] from '
    +' JNYH_�쳣���� where ���״̬=''�ȴ�''  order by id asc';

  ADOQErr.SQL.Add(strSQL );
  ADOQErr.Active := True;
  
  //ȡ�����󷢶����ͺ�

  UnitWriteName:=SystemWorkground.PCWriteLD;//'D6021';
  if(ADOQErr.RecordCount=0) then begin
    Ret:=False;
    goto ExitSub;
    end;
  if(Trim(ADOQErr.FieldByName('���״̬').AsString)='���') then begin
    Ret:=False;
    goto ExitSub;
    end;
  strFDJ_DXH:= ADOQErr.FieldByName('���ͺ�').AsString;
  strSQL:='select [���ͺ�],[�ͺ�],[�ͺ�2],[�ϵ���] from '
    +' JNYH_�ͺŶ��� where [���ͺ�]='''+strFDJ_DXH+'''  order by id asc';

  ADOQErr.SQL.Clear;
  ADOQErr.Active := False;
  ADOQErr.SQL.Add(strSQL );
  ADOQErr.Active := True;


  strFDJ_XH:= ADOQErr.FieldByName('�ͺ�').AsString;
  strFDJ_XH2:= ADOQErr.FieldByName('�ͺ�2').AsString;
  strFDJ_LD:= ADOQErr.FieldByName('�ϵ���').AsString;

  //strFDJ_LD:='4';//������
  //д���ϵ���
  SetLength(PLCWriteData,1);
  try
    PLCWriteData[0]:=StrToInt(Trim(strFDJ_LD));
  Except
    ShowMessage('�ϵ����ô���');
    end;
  ICPLCCommunication.WriteDataToPLC(UnitWriteName,PLCWriteData);

  //д����ͺ�
  UnitWriteName:=SystemWorkground.PCWriteFanHao;
  WriteData(UnitWriteName,strFDJ_DXH);

  //д���ͺ�
  UnitWriteName:=SystemWorkground.PCWriteType;
  WriteData(UnitWriteName,strFDJ_XH);

  //д������ƥ�����ͺ�
  UnitWriteName:=SystemWorkground.PCWriteTZ;
  WriteData(UnitWriteName,strFDJ_XH2);

  Ret:=True;
ExitSub:
  FreeAndNil(ADOQErr);
  Result:=Ret;
end;


procedure TWorkThread.WriteNoJiHua;
var
  PLCWriteData:Array of Integer;
begin
  SetLength(PLCWriteData,1);
  PLCWriteData[0]:=2;
  ICPLCCommunication.WriteDataToPLC(SystemWorkground.HaveJH,PLCWriteData);
end;

procedure TWorkThread.WriteHaveJiHua;
var
  PLCWriteData:Array of Integer;
begin
  SetLength(PLCWriteData,1);
  PLCWriteData[0]:=1;
  ICPLCCommunication.WriteDataToPLC(SystemWorkground.HaveJH,PLCWriteData);
end;

function TWorkThread.GetWeek: String;
var
  days: array[1..7] of string;
begin
  days[1] := '00';
  days[2] := '01';
  days[3] := '02';
  days[4] := '03';
  days[5] := '04';
  days[6] := '05';
  days[7] := '06';
  Result:=days[DayOfWeek(Now)];
end;
end.
 