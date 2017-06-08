unit QC_AE_LineBarscanUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SPComm, DB, ADODB, ExtCtrls, StdCtrls, OleCtrls, MSCommLib_TLB,
  Buttons, Grids, DBGrids, ComCtrls;

type
  Tfrm_QC_AE_LineBarscan = class(TForm)
    DataSource_Bar: TDataSource;
    ADOQuery_Bar: TADOQuery;
    comReader: TComm;
    Panel1: TPanel;
    Panel2: TPanel;
    GroupBox4: TGroupBox;
    Edit_UserPwd: TEdit;
    Label6: TLabel;
    Label9: TLabel;
    Label8: TLabel;
    Edit_ID: TEdit;
    GroupBox1: TGroupBox;
    pgcMachinerecord: TPageControl;
    TabSheet2: TTabSheet;
    Panel7: TPanel;
    Panel3: TPanel;
    GroupBox6: TGroupBox;
    Label3: TLabel;
    Label2: TLabel;
    Label1: TLabel;
    Label4: TLabel;
    Label15: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Image1: TImage;
    Label10: TLabel;
    Edit_BarScan: TEdit;
    Edit_Core: TEdit;
    Edit_CARDID: TEdit;
    Edit_DateTime: TEdit;
    RadioGroup1: TRadioGroup;
    BitBtn2: TBitBtn;
    Edit_FLOW: TEdit;
    BitBtn1: TBitBtn;
    Edit_LastCardID: TEdit;
    Edit_BiLi: TEdit;
    Edit_Total: TEdit;
    GroupBox2: TGroupBox;
    DBGrid2: TDBGrid;
    MSCbarcode: TMSComm;
    Edit_Password: TEdit;
    Tab_Gamenameinput: TTabSheet;
    GroupBox3: TGroupBox;
    Label14: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Image2: TImage;
    Label22: TLabel;
    Edit4: TEdit;
    BitBtn3: TBitBtn;
    Edit_EBID: TEdit;
    Edit_EBValue: TEdit;
    Edit_Tuibi_Total: TEdit;
    GroupBox5: TGroupBox;
    DBGrid1: TDBGrid;
    MSComm1: TMSComm;
    Edit11: TEdit;
    Panel_Infor: TPanel;
    DataSource_Tuibi: TDataSource;
    ADOQuery_Tuibi: TADOQuery;
    CheckBox_Update: TCheckBox;
    CheckBox_Menber: TCheckBox;
    BitBtn4: TBitBtn;
    procedure MSCbarcodeComm(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure comReaderReceiveData(Sender: TObject; Buffer: Pointer;
      BufferLength: Word);
    procedure Edit_UserPwdKeyPress(Sender: TObject; var Key: Char);
    procedure BitBtn4Click(Sender: TObject);
  private
    { Private declarations }
    procedure InitDataBase; //����
    procedure InitDataBase_Tuibi; //�˱�
    procedure SaveData_Bar(StrFlowBar: string; StrCoreBar: string);
    procedure ClearText;
    function Query_GameName(Strs: string): string;
    function Query_MacNo(Strs: string): string;
    function Query_GameNo(Strs: string): string; //��ѯ��̨����
    procedure Query_MenberInfor(StrID: string);
    function Query_Menber_IncRecord(StrID: string): boolean; //���˻�Ա�Ƿ��г�ֵ��¼
    procedure CheckCMD();
    function Query_Menber_IncRecord_by_EBid(StrID: string): boolean;
    procedure Query_EBINCinformation_by_EBid(StrID: string);
    procedure Query_Tuibi_Total(StrID: string);
    procedure Update_Tuibi_Record(S: string);
    procedure ClearTuibiText;
    procedure ClearValue;
    function Make_Send_CMD(StrCMD: string; StrIncValue: string): string;
    procedure INcrevalue(S: string);
    procedure GetInvalidDate;
    function Select_IncValue_Byte(StrIncValue: string): string;
    function Select_CheckSum_Byte(StrCheckSum: string): string;
    function CheckSUMData(orderStr: string): string;
    function exchData(orderStr: string): string;
    function Check_CARDID_INPUT(Strs: string): boolean;
    procedure sendData();
  public
    { Public declarations }
  end;

var
  frm_QC_AE_LineBarscan: Tfrm_QC_AE_LineBarscan;
  curOrderNo: integer = 0;
  curOperNo: integer = 0;
  curScanNo: integer = 0;
  TotalCore: integer = 0;
  Operate_No: integer = 0;
  BAR1_CARDNO, BAR2_CARDNO: string;
  Tuibi_Operate_Enable: string;
  buffer: array[0..2048] of byte;
  BAR_Type1, BAR_Type2: string;
  orderLst, recDataLst, recData_fromICLst: Tstrings;
  User_Pwd_Comfir: boolean;
implementation
uses SetParameterUnit, ICDataModule, ICCommunalVarUnit, ICEventTypeUnit, ICFunctionUnit;
{$R *.dfm}


procedure Tfrm_QC_AE_LineBarscan.InitDataBase;
var
  strSQL: string;
begin
  with ADOQuery_Bar do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select * from [3F_BARFLOW]';
    SQL.Add(strSQL);
    Active := True;
  end;

end;

//

procedure Tfrm_QC_AE_LineBarscan.InitDataBase_Tuibi;
var
  strSQL: string;
begin
  with ADOQuery_Tuibi do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select * from [TMembeDetail] where ID_UserCard_TuiBi_Flag=''1''';
    SQL.Add(strSQL);
    Active := True;
  end;

end;



procedure Tfrm_QC_AE_LineBarscan.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  i: integer;
begin
    //������
  if MSCbarcode.PortOpen then MSCbarcode.PortOpen := false; //�رն˿�
  for i := 0 to ComponentCount - 1 do
  begin
    if components[i] is TEdit then
    begin
      (components[i] as TEdit).Clear;
    end
  end;

  orderLst.Free();
  recDataLst.Free();
  recData_fromICLst.Free();
  comReader.StopComm();
  ICFunction.ClearIDinfor; //�����ID��ȡ��������Ϣ

end;



procedure Tfrm_QC_AE_LineBarscan.FormCreate(Sender: TObject);
begin
   //  EventObj:=EventUnitObj.Create;
  //   EventObj.LoadEventIni;




end;





procedure Tfrm_QC_AE_LineBarscan.MSCbarcodeComm(Sender: TObject);
var
  strTemp: string;
  tempStr: string;
  Dingwei: string; //ȷ��ɨ�������һ������
begin
  if MSCbarcode.CommEvent = comEvReceive then
  begin
    strTemp := MSCbarcode.Input;
    BarCodeValue := BarCodeValue + strTemp;
    strTemp := '';
    if INit_Wright.MenberControl_short = '1' then
    begin

      if not (CheckBox_Menber.Checked) then //û��ѡ��ȡ�����
      begin
        if not (CheckBox_Update.Checked) then //û��ѡ����ϵ����
        begin
          if not User_Pwd_Comfir then //��Ϊδʵ�л�Ա�ƹ������Կ���ɨ�����
          begin
            ShowMessage('����ˢ��Ա�����������Ա�����룡��֤ͨ������ɨ��ҽ�ȯ��');
            BarCodeValue := '';
            exit;
          end;
        end;
      end;
    end;


   // if (copy(tempStr, length(tempStr)-1, 1) =Chr(13))  then
    begin
      tempStr := BarCodeValue;
      Dingwei := copy(tempStr, 1, 1); //��ȡ��һ���ַ��������жϴ�������Ϣ�����������ߵĻ��Ǹ����ߵģ��ֻ��Ǵ�̻�
      Panel_Infor.Caption := '';
        //��ˮ��̨���룬
      if (Dingwei = '9') and (length(tempStr) = 20) then
      begin
        begin
          BAR_Type1 := '9';
          Edit_BarScan.Text := '';
          Edit_BarScan.Text := tempStr;
          BarCodeValue_FLOW := tempStr;
          BarCodeValue := '';
                 //Edit_DateTime.Text:= copy(tempStr, 1,2)+'-'+copy(tempStr, 3,2)+'-'+copy(tempStr, 5,2)+':'+copy(tempStr, 7,2);

                 //Edit_CARDID.Text :=copy(tempStr, 11,3);
                 //Edit_FLOW.Text:= copy(tempStr, 9,2);
          Edit_DateTime.Text := copy(tempStr, 15, 1) + copy(tempStr, 12, 1) + '-' + copy(tempStr, 4, 1) + copy(tempStr, 7, 1) + '   ' + copy(tempStr, 2, 1) + copy(tempStr, 18, 1) + ':' + copy(tempStr, 10, 1) + copy(tempStr, 5, 1);
                 //׷���ж��·ݲ��ܴ���12�����ڲ��ܴ���31��Сʱ���ܴ���24�����Ӳ��ܴ���59
          Edit_CARDID.Text := copy(tempStr, 11, 1) + copy(tempStr, 6, 1) + copy(tempStr, 13, 1);
          BAR1_CARDNO := copy(tempStr, 11, 1) + copy(tempStr, 6, 1) + copy(tempStr, 13, 1);
                 //׷�Ӳ�ѯ���ݱ����Ƿ��д˿�ͷ��¼�����������Ϊ�ǷǷ�
          Edit_FLOW.Text := copy(tempStr, 3, 1) + copy(tempStr, 9, 1) + copy(tempStr, 17, 1) + copy(tempStr, 14, 1) + copy(tempStr, 19, 1) + copy(tempStr, 8, 1) + copy(tempStr, 16, 1);
                 //׷����ˮ��Ψһ�ж�
                 //BarCodeValue_OnlyCheck:=BarCodeValue_OnlyCheck+1;//ΨһУ��OK
        end;
      end
         //�������룬
      else if (Dingwei = '0') and (length(tempStr) = 22) then
      begin
        begin
          BAR_Type2 := '0';
          Edit_BarScan.Text := '';
          BarCodeValue_CORE := tempStr;
                 //Edit_BarScan.Text :=copy(tempStr, 2,12);
                 //BarCodeValue:='';
                 //Edit_Core.Text:=copy(tempStr, 11,3);
          Edit_BarScan.Text := copy(tempStr, 2, 20);
          BarCodeValue := '';

                 //����
          Edit_Core.Text := IntToStr(StrToInt(copy(tempStr, 3, 1) + copy(tempStr, 5, 1) + copy(tempStr, 11, 1) + copy(tempStr, 20, 1) + copy(tempStr, 17, 1) + copy(tempStr, 7, 1) + copy(tempStr, 14, 1)) div 1);
          Edit_BiLi.Text := IntToStr(StrToInt(Edit_Core.Text) div StrToInt(SystemWorkground.ErrorGTState));
                 //׷�ӷ������޵��ж�
          Edit_LastCardID.Text := copy(tempStr, 21, 1) + copy(tempStr, 12, 1) + copy(tempStr, 4, 1) + copy(tempStr, 16, 1) + copy(tempStr, 6, 1) + copy(tempStr, 19, 1) + copy(tempStr, 9, 1) + copy(tempStr, 15, 1) + copy(tempStr, 18, 1) + copy(tempStr, 10, 1);
                 //׷�������ݿ��м����Ƿ��д˱�ID�ļ�¼  ��ǰ����ת��Ϊ16����
          BAR2_CARDNO := copy(tempStr, 2, 1) + copy(tempStr, 13, 1) + copy(tempStr, 8, 1);
                 //׷���� BAR1_CARDNO �Ƚ�
                 //BarCodeValue_OnlyCheck:=BarCodeValue_OnlyCheck+1;//ΨһУ��OK
        end;
      end
         //��ѯ�˱Ҽ�¼����-��ˮ��̨���룬
      else if (Dingwei = '5') and (length(tempStr) = 20) then
      begin
        begin
          BAR_Type1 := '5';
          Edit_BarScan.Text := '';
          Edit_BarScan.Text := tempStr;
          BarCodeValue_FLOW := tempStr;
          BarCodeValue := '';
                 //Edit_DateTime.Text:= copy(tempStr, 1,2)+'-'+copy(tempStr, 3,2)+'-'+copy(tempStr, 5,2)+':'+copy(tempStr, 7,2);

                 //Edit_CARDID.Text :=copy(tempStr, 11,3);
                 //Edit_FLOW.Text:= copy(tempStr, 9,2);
          Edit_DateTime.Text := copy(tempStr, 15, 1) + copy(tempStr, 12, 1) + '-' + copy(tempStr, 4, 1) + copy(tempStr, 7, 1) + '   ' + copy(tempStr, 2, 1) + copy(tempStr, 18, 1) + ':' + copy(tempStr, 10, 1) + copy(tempStr, 5, 1);
                 //׷���ж��·ݲ��ܴ���12�����ڲ��ܴ���31��Сʱ���ܴ���24�����Ӳ��ܴ���59
          Edit_CARDID.Text := copy(tempStr, 11, 1) + copy(tempStr, 6, 1) + copy(tempStr, 13, 1);
          BAR1_CARDNO := copy(tempStr, 11, 1) + copy(tempStr, 6, 1) + copy(tempStr, 13, 1);
                 //׷�Ӳ�ѯ���ݱ����Ƿ��д˿�ͷ��¼�����������Ϊ�ǷǷ�
          Edit_FLOW.Text := copy(tempStr, 3, 1) + copy(tempStr, 9, 1) + copy(tempStr, 17, 1) + copy(tempStr, 14, 1) + copy(tempStr, 19, 1) + copy(tempStr, 8, 1) + copy(tempStr, 16, 1);
                 //׷����ˮ��Ψһ�ж�
                 //BarCodeValue_OnlyCheck:=BarCodeValue_OnlyCheck+1;//ΨһУ��OK
        end;
      end
      else if (Dingwei = '5') and (length(tempStr) = 22) then //��ѯ�˱Ҽ�¼���� -��������
      begin
        begin
          BAR_Type2 := '5';
          Edit_BarScan.Text := '';
          BarCodeValue_CORE := tempStr;
          Edit_BarScan.Text := copy(tempStr, 2, 20);
          BarCodeValue := '';
          Edit_Core.Text := IntToStr(StrToInt(copy(tempStr, 3, 1) + copy(tempStr, 5, 1) + copy(tempStr, 11, 1) + copy(tempStr, 20, 1) + copy(tempStr, 17, 1) + copy(tempStr, 7, 1) + copy(tempStr, 14, 1)) div 10);

                 //׷�ӷ������޵��ж�
          Edit_LastCardID.Text := copy(tempStr, 21, 1) + copy(tempStr, 12, 1) + copy(tempStr, 4, 1) + copy(tempStr, 16, 1) + copy(tempStr, 6, 1) + copy(tempStr, 19, 1) + copy(tempStr, 9, 1) + copy(tempStr, 15, 1) + copy(tempStr, 18, 1) + copy(tempStr, 10, 1);
                 //׷�������ݿ��м����Ƿ��д˱�ID�ļ�¼  ��ǰ����ת��Ϊ16����
          BAR2_CARDNO := copy(tempStr, 2, 1) + copy(tempStr, 13, 1) + copy(tempStr, 8, 1);
                 //׷���� BAR1_CARDNO �Ƚ�
                 //BarCodeValue_OnlyCheck:=BarCodeValue_OnlyCheck+1;//ΨһУ��OK
        end;
      end
         //��ѯͶ�Ҽ�¼����-��ˮ��̨���룬
      else if (Dingwei = '6') and (length(tempStr) = 20) then
      begin
        begin
          BAR_Type1 := '6';
          Edit_BarScan.Text := '';
          Edit_BarScan.Text := tempStr;
          BarCodeValue_FLOW := tempStr;
          BarCodeValue := '';
                 //Edit_DateTime.Text:= copy(tempStr, 1,2)+'-'+copy(tempStr, 3,2)+'-'+copy(tempStr, 5,2)+':'+copy(tempStr, 7,2);

                 //Edit_CARDID.Text :=copy(tempStr, 11,3);
                 //Edit_FLOW.Text:= copy(tempStr, 9,2);
          Edit_DateTime.Text := copy(tempStr, 15, 1) + copy(tempStr, 12, 1) + '-' + copy(tempStr, 4, 1) + copy(tempStr, 7, 1) + '   ' + copy(tempStr, 2, 1) + copy(tempStr, 18, 1) + ':' + copy(tempStr, 10, 1) + copy(tempStr, 5, 1);
                 //׷���ж��·ݲ��ܴ���12�����ڲ��ܴ���31��Сʱ���ܴ���24�����Ӳ��ܴ���59
          Edit_CARDID.Text := copy(tempStr, 11, 1) + copy(tempStr, 6, 1) + copy(tempStr, 13, 1);
          BAR1_CARDNO := copy(tempStr, 11, 1) + copy(tempStr, 6, 1) + copy(tempStr, 13, 1);
                 //׷�Ӳ�ѯ���ݱ����Ƿ��д˿�ͷ��¼�����������Ϊ�ǷǷ�
          Edit_FLOW.Text := copy(tempStr, 3, 1) + copy(tempStr, 9, 1) + copy(tempStr, 17, 1) + copy(tempStr, 14, 1) + copy(tempStr, 19, 1) + copy(tempStr, 8, 1) + copy(tempStr, 16, 1);
                 //׷����ˮ��Ψһ�ж�
                 //BarCodeValue_OnlyCheck:=BarCodeValue_OnlyCheck+1;//ΨһУ��OK
        end;
      end
      else if (Dingwei = '6') and (length(tempStr) = 22) then //��ѯͶ�Ҽ�¼���� -��������
      begin
        begin
          BAR_Type2 := '6';
          Edit_BarScan.Text := '';
          BarCodeValue_CORE := tempStr;
          Edit_BarScan.Text := copy(tempStr, 2, 20);
          BarCodeValue := '';
          Edit_Core.Text := IntToStr(StrToInt(copy(tempStr, 3, 1) + copy(tempStr, 5, 1) + copy(tempStr, 11, 1) + copy(tempStr, 20, 1) + copy(tempStr, 17, 1) + copy(tempStr, 7, 1) + copy(tempStr, 14, 1)) div 10);

                 //׷�ӷ������޵��ж�
          Edit_LastCardID.Text := copy(tempStr, 21, 1) + copy(tempStr, 12, 1) + copy(tempStr, 4, 1) + copy(tempStr, 16, 1) + copy(tempStr, 6, 1) + copy(tempStr, 19, 1) + copy(tempStr, 9, 1) + copy(tempStr, 15, 1) + copy(tempStr, 18, 1) + copy(tempStr, 10, 1);
                 //׷�������ݿ��м����Ƿ��д˱�ID�ļ�¼  ��ǰ����ת��Ϊ16����
          BAR2_CARDNO := copy(tempStr, 2, 1) + copy(tempStr, 13, 1) + copy(tempStr, 8, 1);
                 //׷���� BAR1_CARDNO �Ƚ�
                 //BarCodeValue_OnlyCheck:=BarCodeValue_OnlyCheck+1;//ΨһУ��OK
        end;
      end
         //��ѯ�쳣����ʱͶ��ʣ�����ݼ�¼����-��ˮ��̨���룬
      else if (Dingwei = '7') and (length(tempStr) = 20) then
      begin
        begin
          BAR_Type1 := '7';
          Edit_BarScan.Text := '';
          Edit_BarScan.Text := tempStr;
          BarCodeValue_FLOW := tempStr;
          BarCodeValue := '';
                 //Edit_DateTime.Text:= copy(tempStr, 1,2)+'-'+copy(tempStr, 3,2)+'-'+copy(tempStr, 5,2)+':'+copy(tempStr, 7,2);

                 //Edit_CARDID.Text :=copy(tempStr, 11,3);
                 //Edit_FLOW.Text:= copy(tempStr, 9,2);
          Edit_DateTime.Text := copy(tempStr, 15, 1) + copy(tempStr, 12, 1) + '-' + copy(tempStr, 4, 1) + copy(tempStr, 7, 1) + '   ' + copy(tempStr, 2, 1) + copy(tempStr, 18, 1) + ':' + copy(tempStr, 10, 1) + copy(tempStr, 5, 1);
                 //׷���ж��·ݲ��ܴ���12�����ڲ��ܴ���31��Сʱ���ܴ���24�����Ӳ��ܴ���59
          Edit_CARDID.Text := copy(tempStr, 11, 1) + copy(tempStr, 6, 1) + copy(tempStr, 13, 1);
          BAR1_CARDNO := copy(tempStr, 11, 1) + copy(tempStr, 6, 1) + copy(tempStr, 13, 1);
                 //׷�Ӳ�ѯ���ݱ����Ƿ��д˿�ͷ��¼�����������Ϊ�ǷǷ�
          Edit_FLOW.Text := copy(tempStr, 3, 1) + copy(tempStr, 9, 1) + copy(tempStr, 17, 1) + copy(tempStr, 14, 1) + copy(tempStr, 19, 1) + copy(tempStr, 8, 1) + copy(tempStr, 16, 1);
                 //׷����ˮ��Ψһ�ж�
                 //BarCodeValue_OnlyCheck:=BarCodeValue_OnlyCheck+1;//ΨһУ��OK
        end;
      end
      else if (Dingwei = '7') and (length(tempStr) = 22) then //��ѯ�쳣����ʱͶ��ʣ�����ݼ�¼���� -��������
      begin
        begin
          BAR_Type2 := '7';
          Edit_BarScan.Text := '';
          BarCodeValue_CORE := tempStr;
          Edit_BarScan.Text := copy(tempStr, 2, 20);
          BarCodeValue := '';
          Edit_Core.Text := IntToStr(StrToInt(copy(tempStr, 3, 1) + copy(tempStr, 5, 1) + copy(tempStr, 11, 1) + copy(tempStr, 20, 1) + copy(tempStr, 17, 1) + copy(tempStr, 7, 1) + copy(tempStr, 14, 1)) div 10);

                 //׷�ӷ������޵��ж�
          Edit_LastCardID.Text := copy(tempStr, 21, 1) + copy(tempStr, 12, 1) + copy(tempStr, 4, 1) + copy(tempStr, 16, 1) + copy(tempStr, 6, 1) + copy(tempStr, 19, 1) + copy(tempStr, 9, 1) + copy(tempStr, 15, 1) + copy(tempStr, 18, 1) + copy(tempStr, 10, 1);
                 //׷�������ݿ��м����Ƿ��д˱�ID�ļ�¼  ��ǰ����ת��Ϊ16����
          BAR2_CARDNO := copy(tempStr, 2, 1) + copy(tempStr, 13, 1) + copy(tempStr, 8, 1);
                 //׷���� BAR1_CARDNO �Ƚ�
                 //BarCodeValue_OnlyCheck:=BarCodeValue_OnlyCheck+1;//ΨһУ��OK
        end;
      end;
         //���������¼

 //-----------------------------------------------------------------------------

     //Ψһ���ж�
      if (Edit_BarScan.text <> '') and (Edit_Core.text <> '') and (Edit_CARDID.text <> '') and (Edit_DateTime.text <> '') and (Edit_FLOW.text <> '') then
      begin
      //�ж�ɨ���ǰ������Ŀ�ͷIDֵ�Ƿ�һ��
        if not (BAR1_CARDNO = BAR2_CARDNO) then
        begin
          Panel_Infor.Caption := 'ǰ��ɨ��Ļ�̨ʶ���벻һ�£�';
                 //Panel_Infor_Card.Caption:='ǰ��ɨ��Ļ�̨ʶ���벻һ�£�';
          exit;
        end;

      //���������жϲ�ִ����Ӧ�¼�---�����ϡ��·�����
        if (BAR_Type1 = '9') and (BAR_Type2 = '0') then
        begin
          if (DataModule_3F.Querystr_Flow_Only(BarCodeValue_FLOW) <> 'no_record') and (DataModule_3F.Querystr_Flow_Only(BarCodeValue_FLOW) <> '') then //����м�¼
          begin //��ѯ��ˮ���Ƿ�Ψһ
            ClearText;
            Panel_Infor.Caption := '�������ظ�ʹ�ã���ȷ�ϣ�';
            ShowMessage('�������ظ�ʹ�ã���ȷ�ϣ�');
            exit;
          end
          else
          begin
               //-------����ȡ������ȷ��  ��ʼ-----------------
            if not (CheckBox_Menber.Checked) then //û��ѡ��ȡ�����
            begin //1���ǻ�Ա��⣬���ͨ���󱣴�����
              if (TrimRight(Edit_UserPwd.Text) <> '') and (TrimRight(Edit_UserPwd.Text) = TrimRight(Edit_Password.Text)) then
              begin
                SaveData_Bar(BarCodeValue_FLOW, BarCodeValue_CORE);
                if SaveData_OK_flag then
                begin
                  BarCodeValue_OnlyCheck := 0; //���
                  InitDataBase;
                  SaveData_OK_flag := FALSE;
                  BAR_Type1 := '';
                  BAR_Type2 := '';
                  Panel_Infor.Caption := '���ݱ���ɹ�';
                end;
              end
              else
              begin
                Panel_Infor.Caption := '��Ա����ȷ�ϴ���!';
                ShowMessage('��Ա����ȷ�ϴ���');
                exit;
              end;
            end
            else //2�����ǻ�Ա��⣬ֱ�ӱ�������
            begin
              SaveData_Bar(BarCodeValue_FLOW, BarCodeValue_CORE);
              if SaveData_OK_flag then
              begin
                BarCodeValue_OnlyCheck := 0; //���
                InitDataBase;
                SaveData_OK_flag := FALSE;
                BAR_Type1 := '';
                BAR_Type2 := '';
                Panel_Infor.Caption := '���ݱ���ɹ�';
              end
              else
              begin
                Panel_Infor.Caption := '��ǰ���뿨ͷID��ϵͳ��δע�ᣡ';
              end;
            end;
              //-------����ȡ������ȷ��  ����-----------------
          end; //��¼Ψһ�жϽ���
        end
      //���������жϲ�ִ����Ӧ�¼�---��ѯ�˱Ҽ�¼����
        else if (BAR_Type1 = '5') and (BAR_Type2 = '5') then
        begin
          Panel_Infor.Caption := '����Ϊ��ѯ��ȡ���˱Ҽ�¼��';
        end
      //���������жϲ�ִ����Ӧ�¼�---��ѯͶ�Ҽ�¼����
        else if (BAR_Type1 = '6') and (BAR_Type2 = '6') then
        begin
          Panel_Infor.Caption := '����Ϊ��ѯ��ȡ��Ͷ�Ҽ�¼��';
        end
      //���������жϲ�ִ����Ӧ�¼�---��ѯ�쳣����ʱʣ��δ�Ϸֵļ�¼����
        else if (BAR_Type1 = '7') and (BAR_Type2 = '7') then
        begin
          Panel_Infor.Caption := '����ΪͶ���쳣ʱʣ���δ�Ϸּ�¼��';
        end
        else
        begin
          Panel_Infor.Caption := '�������룬��ȷ�ϣ�';
        end;

      end; //�������Ϊ���жϽ���
    end;
  end;
end;


function Tfrm_QC_AE_LineBarscan.Query_GameName(Strs: string): string; //��ѯ��̨����
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: string;
begin
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select distinct [GameName] from [TGameSet] where GameNo=''' + Strs + '''';
  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    if (RecordCount > 0) then
      reTmpStr := TrimRight(ADOQTemp.Fields[0].AsString)
    else
      exit;
  end;
  FreeAndNil(ADOQTemp);
  Result := reTmpStr;
end;

//ȷ�ϵ�ǰ�����ϵĿ�ͷID�Ƿ��Ѿ�����

function Tfrm_QC_AE_LineBarscan.Check_CARDID_INPUT(Strs: string): boolean; //��ѯ��̨����
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: boolean;
begin
  reTmpStr := false;
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select count([MID]) from [TChargMacSet] where Card_ID_MC=''' + Strs + '''';
  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    if (ADOQTemp.Fields[0].AsInteger) > 0 then
    begin
      reTmpStr := true;
    end;

  end;
  FreeAndNil(ADOQTemp);


  Result := reTmpStr;
end;

//���浱ǰ��¼��������ˮ�š�����ֵ����Ϣ

procedure Tfrm_QC_AE_LineBarscan.SaveData_Bar(StrFlowBar: string; StrCoreBar: string);
var
  strSQL: string;
  str1: string;
begin

  SaveData_OK_flag := false;
  str1 := Query_GameNo(TrimRight(Edit_CARDID.Text));
    //ȷ���Ƿ��Ѿ�¼��Ŀ�ͷID��
  if not Check_CARDID_INPUT(TrimRight(Edit_CARDID.Text)) then
  begin
    ShowMessage('��ǰ����Ŀ�ͷID�ţ��ڴ�ϵͳδע���½��');
    exit;
  end;

  strSQL := 'select * from [3F_BARFLOW] ';
  with ADOQuery_Bar do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := true;
    Append;
    FieldByName('FLOWbar').AsString := StrFlowBar;
    FieldByName('COREbar').AsString := StrCoreBar;
    FieldByName('GameNo').AsString := str1;
    FieldByName('MacNo').AsString := Query_MacNo(Edit_CARDID.Text);
    FieldByName('GameName').AsString := Query_GameName(str1);
    FieldByName('CARDID').AsString := Edit_CARDID.Text; //��ͷID

    FieldByName('Scaner').AsString := G_User.UserName;
    FieldByName('CORE').AsString := TrimRight(Edit_BiLi.Text); //Edit_Core.text;
    if length(TrimRight(Edit_BiLi.Text)) <> 0 then
    begin
      TotalCore := TotalCore + StrToInt(TrimRight(Edit_BiLi.Text));
      Edit_Total.Text := IntToStr(TotalCore);
    end
    else
    begin
      Edit_Total.Text := IntToStr(TotalCore);
    end;

    FieldByName('DATETIME_OPERATE').AsString := FormatDateTime('yyyy-MM-dd HH:mm:ss', now); //��Ʊʱ�� (��Ҫ����)
    FieldByName('DATETIME_SCAN').AsString := FormatDateTime('yyyy-MM-dd HH:mm:ss', now); //ɨ��һ�ʱ��
    FieldByName('COREVALU_Bili').AsString := TrimRight(Edit_BiLi.Text);
    if not (CheckBox_Menber.Checked) then //û��ѡ��ȡ�����
    begin
      FieldByName('IDCardNo').AsString := TrimRight(Edit_ID.Text); //��Ա��ID
    end
    else
    begin
      FieldByName('IDCardNo').AsString := G_User.UserName; //��������Ա��ID
    end;

    FieldByName('Query_Enable').AsString := '1'; //Ĭ��Ϊ�����ѯ

    Post;
    Active := False;
  end;

  if not (CheckBox_Update.Checked) then //û��ѡ����������
  begin
    if (MessageDlg('��Ҫ������?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
    begin
      CheckBox_Update.Checked := true;
    end
    else
    begin
      User_Pwd_Comfir := false; //��λ����ȷ�ϱ�ʶ
      Edit_UserPwd.Text := '';
      Edit_Password.Text := '';
      Edit_ID.Text := '';
      ClearText;
      Close;
    end;
  end;

  SaveData_OK_flag := true; //����������
end;




function Tfrm_QC_AE_LineBarscan.Query_MacNo(Strs: string): string; //��ѯ��̨λ
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: string;
begin
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select distinct [MacNo] from [TChargMacSet] where Card_ID_MC=''' + Strs + '''';
  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    if (RecordCount > 0) then
      reTmpStr := TrimRight(ADOQTemp.Fields[0].AsString)
    else
      exit;
  end;
  FreeAndNil(ADOQTemp);
  Result := reTmpStr;
end;

function Tfrm_QC_AE_LineBarscan.Query_GameNo(Strs: string): string; //��ѯ��̨λ
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: string;
begin
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select distinct [GameNo] from [TChargMacSet] where Card_ID_MC=''' + Strs + '''';
  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    if (RecordCount > 0) then
      reTmpStr := TrimRight(ADOQTemp.Fields[0].AsString)
    else
      exit;
  end;
  FreeAndNil(ADOQTemp);
  Result := reTmpStr;
end;



procedure Tfrm_QC_AE_LineBarscan.ClearText;
begin
  Edit_BarScan.text := '';
  Edit_Core.text := '';
  Edit_CARDID.text := '';
  Edit_DateTime.text := '';
  Edit_FLOW.text := '';
end;

procedure Tfrm_QC_AE_LineBarscan.FormShow(Sender: TObject);
begin
    //Edit1.Text:=FormatDateTime('yyyy-MM-dd HH:mm:ss',now);
  InitDataBase;
  InitDataBase_Tuibi;
 //   MSCbarcode.PortOpen := true;//�򿪶˿�   ,�������Ҫ������IC��ϵͳ��SPCOM��ͻ��ǿ׳�˿ں�
  Edit_ID.Text := '';
  Edit_BarScan.Text := '';
  Edit_UserPwd.Text := '';
  Edit_Core.Text := '';
  Edit_BiLi.Text := '';
  Edit_CARDID.Text := '';
  Edit_DateTime.Text := '';
  Edit_LastCardID.Text := '';
  Edit_FLOW.Text := '';
  Edit_Total.Text := '';
  TotalCore := 0;
  Tuibi_Operate_Enable := '0';
  Edit_Total.Text := IntToStr(TotalCore);

    //Edit_BarScan.SetFocus;
  if MSCbarcode.PortOpen then MSCbarcode.PortOpen := false; //�رն˿�
  //ɨ����debug info
  MSCbarcode.CommPort := 2; //���ö˿�2
    //MSCbarcode.InBufferSize := 256;//���ý��ջ�����Ϊ256���ֽ�
    //MSCbarcode.OutBufferSize := 256;//���÷��ͻ�����Ϊ256���ֽ�
    //MSCbarcode.Settings := '9600,n,8,1';//9600�����ʣ���У�飬8λ����λ��1λֹͣλ
    //MSCbarcode.InputLen := 0;//��ȡ������ȫ������(32���ֽ�)
    //MSCbarcode.InBufferCount := 0;// ������ջ�����
    //MSCbarcode.OutBufferCount:=0;// ������ͻ�����
    //MSCbarcode.RThreshold := 20;//���ý���32���ֽڲ���OnComm �¼�
    //MSCbarcode.InputMode := comInputModeText;//�ı���ʽ
    //MSCbarcode.InputMode := comInputModeBinary;//�����Ʒ�ʽ
  MSCbarcode.PortOpen := true; //�򿪶˿�   ,�������Ҫ������IC��ϵͳ��SPCOM��ͻ��ǿ׳�˿ں�

  CheckBox_Update.Checked := false;
  CheckBox_Update.Enabled := false; //�������ѡ����������
  CheckBox_Menber.Checked := false;

  if INit_Wright.MenberControl_short = '1' then
  begin
    Panel_Infor.Caption := '����ǰ���ˢ��Ա�����������Ա������';

    comReader.StartComm();
    orderLst := TStringList.Create;
    recDataLst := tStringList.Create;
    recData_fromICLst := tStringList.Create;

    Edit_UserPwd.Enabled := false;
    User_Pwd_Comfir := false; //����ȷ��
  end
  else
  begin
    Panel_Infor.Caption := '��ǰϵͳδʵ�л�Ա�ƹ�����ɨ�轱ȯ';
    Edit_UserPwd.Enabled := false;
  end;
  ClearText;
  ClearTuibiText;
end;



 //���´˵��ӱ����³�ֵ�ļ�¼���˱ұ�־λ

procedure Tfrm_QC_AE_LineBarscan.Update_Tuibi_Record(S: string);
var
  ADOQ: TADOQuery;
  strSQL, strRet, strLastRecord, strinputdatetime: string;
  MaxID: string;
  setvalue: string;
begin
  strLastRecord := '1';
  strSQL := 'select MD_ID from TMembeDetail where ID_UserCard=''' + S + ''' and LastRecord=''' + strLastRecord + '''';
  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Open;
    if (not eof) then
      MaxID := TrimRight(ADOQ.Fields[0].AsString);
    Close;
  end;
  FreeAndNil(ADOQ);

  setvalue := '1';
  strinputdatetime := FormatDateTime('yyyy-MM-dd HH:mm:ss', now);
  strSQL := 'Update TMembeDetail set ID_UserCard_TuiBi_Flag=''' + setvalue + ''',TuiBi_Time=''' + strinputdatetime + ''' where MD_ID=''' + MaxID + '''';
  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    ADOQ.ExecSQL;
  end;
  FreeAndNil(ADOQ);

end;

//ȷ���˱�

procedure Tfrm_QC_AE_LineBarscan.BitBtn3Click(Sender: TObject);
begin
  if (Edit_EBID.Text <> '') then
  begin
    Update_Tuibi_Record(TrimRight(Edit_EBID.Text)); //��ʵ�Ǹ��³�ֵ��¼�ж�Ӧ�ĵ��ӱҵ����³�ֵ��¼
    ClearValue; //������е�ֵ
    ClearTuibiText;
    InitDataBase_Tuibi;
  end
  else
  begin
          //���ﲻӦ�ó�Ϊ��Ա����?Ӧ���ǵ��ӱ�
    ShowMessage('��ˢ��Ա��������Ҫ�������');
  end;

end;



procedure Tfrm_QC_AE_LineBarscan.ClearTuibiText;
begin
    //���ӱ�ID
  Edit_EBID.text := '';
    //��ֵʱ��
  Edit4.text := '';
    // ����ֵ
  Edit_EBValue.text := '';
    //�ۼ��˱�
  Edit_Tuibi_Total.text := '';
    //�ظ���
    //modified by linlf 20140310
    //Edit_EBID.text:='';
end;

procedure Tfrm_QC_AE_LineBarscan.BitBtn1Click(Sender: TObject);
begin
  close;
end;

procedure Tfrm_QC_AE_LineBarscan.BitBtn2Click(Sender: TObject);
begin
  if BarCodeValue_OnlyCheck = 2 then
  begin
    SaveData_Bar(BarCodeValue_FLOW, BarCodeValue_CORE);
    if SaveData_OK_flag then
    begin
      BarCodeValue_OnlyCheck := 0; //���
    end;
  end;
end;

//��ѯ��24Сʱ�����޳�ֵ��¼

function Tfrm_QC_AE_LineBarscan.Query_Menber_IncRecord(StrID: string): boolean;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: string;
  strtime_OK, strtemp: string;
  strRet: boolean;
begin
  strtemp := FormatDateTime('yyyy-MM-dd HH:mm:ss', now);
                 //Edit1.Text:=strtemp; //ȡ�ÿ�ʼ����;
                 //strtime_OK:=Copy(strtemp,1,10);  //��ѯ���죬��ĿǰΪֹ�����޳�ֵ��¼
  strtime_OK := ICFunction.GetInvalidDate(strtemp); //ȡ�ÿ�ʼ����;

                 //Edit2.Text:=strtime_OK; //ȡ�ÿ�ʼ����;
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select count(IDCardNo) from [TMembeDetail] where (IDCardNo=''' + StrID + ''') and ((GetTime<''' + strtemp + ''') and (GetTime>''' + strtime_OK + '''))';
  Result := false;
  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Open;
    if (not eof) then
    begin
      if (ADOQTemp.Fields[0].AsInteger > 0) then
      begin
        Result := true;
      end
      else
      begin
        Result := false;
      end;
      Close;
    end;
    FreeAndNil(ADOQTemp);
  end;
end;



//��ѯ��24Сʱ�����޳�ֵ��¼

function Tfrm_QC_AE_LineBarscan.Query_Menber_IncRecord_by_EBid(StrID: string): boolean;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: string;
  strtime_OK, strtemp: string;
  strRet: boolean;
begin
  strtemp := FormatDateTime('yyyy-MM-dd HH:mm:ss', now);

                 //strtime_OK:=Copy(strtemp,1,10);  //��ѯ���죬��ĿǰΪֹ�����޳�ֵ��¼
  strtime_OK := ICFunction.GetInvalidDate(strtemp); //ȡ�ÿ�ʼ����;
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select count(ID_UserCard) from [TMembeDetail] where (ID_UserCard=''' + StrID + ''') and ((GetTime<''' + strtemp + ''') and (GetTime>''' + strtime_OK + '''))';
  Result := false;
  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Open;
    if (not eof) then
    begin
      if (ADOQTemp.Fields[0].AsInteger > 0) then
      begin
        Result := true;
      end
      else
      begin
        Result := false;
      end;
      Close;
    end;
    FreeAndNil(ADOQTemp);
  end;
end;


//��ѯ��24Сʱ�����޳�ֵ��¼

procedure Tfrm_QC_AE_LineBarscan.Query_EBINCinformation_by_EBid(StrID: string);
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: string;
  strtime_OK, strtemp, strLastRecord: string;
  strRet: boolean;
begin
  strLastRecord := '1'; //��ǰ���ӱҵ����³�ֵ��¼��־
  strtemp := FormatDateTime('yyyy-MM-dd HH:mm:ss', now);

                 //strtime_OK:=Copy(strtemp,1,10);  //��ѯ���죬��ĿǰΪֹ�����޳�ֵ��¼
  strtime_OK := ICFunction.GetInvalidDate(strtemp); //ȡ�ÿ�ʼ����;
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select GetTime from [TMembeDetail] where (ID_UserCard=''' + StrID + ''') and ((GetTime<''' + strtemp + ''') and (GetTime>''' + strtime_OK + ''')) and (LastRecord=''' + strLastRecord + ''') ';

  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Open;
    if (not eof) then
    begin
      Edit4.text := ADOQTemp.Fields[0].AsString;
      Close;
    end;
    FreeAndNil(ADOQTemp);
  end;
end;

//��ѯ���е��˱Ҽ�¼

procedure Tfrm_QC_AE_LineBarscan.Query_Tuibi_Total(StrID: string);
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: string;
  strtime_OK, strtemp, strTuibi: string;
  strRet: boolean;
begin
  strTuibi := '1'; //��ǰ���ӱҵ����³�ֵ��¼��־
  strtemp := FormatDateTime('yyyy-MM-dd HH:mm:ss', now);

                 //strtime_OK:=Copy(strtemp,1,10);  //��ѯ���죬��ĿǰΪֹ�����޳�ֵ��¼
  strtime_OK := ICFunction.GetInvalidDate(strtemp); //ȡ�ÿ�ʼ����;
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select sum(TotalMoney) from [TMembeDetail] where (IDCardNo=''' + StrID + ''') and (ID_UserCard_TuiBi_Flag=''' + strTuibi + ''') ';

  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Open;
    if (not eof) then
    begin
      Edit_Tuibi_Total.text := ADOQTemp.Fields[0].AsString;
      Close;
    end;
    FreeAndNil(ADOQTemp);
  end;
end;

procedure Tfrm_QC_AE_LineBarscan.ClearValue;

var
  INC_value: string;
  strValue: string;
  i: integer;
begin

  INC_value := '0'; //��ֵ��ֵ
  Operate_No := 1;
  strValue := Make_Send_CMD(CMD_COUMUNICATION.CMD_INCValue, INC_value); //�����ֵָ��
  INcrevalue(strValue);

end;


//�����ֵָ��

function Tfrm_QC_AE_LineBarscan.Make_Send_CMD(StrCMD: string; StrIncValue: string): string;
var
  ii, jj, KK: integer;
  TmpStr_IncValue: string; //��ֵ����
  TmpStr_CheckSum: string; //У���
  TmpStr_SendCMD: string; //ָ������
  reTmpStr: string;
begin
  Send_CMD_ID_Infor.CMD := StrCMD; //֡����
  Send_CMD_ID_Infor.ID_INIT := Receive_CMD_ID_Infor.ID_INIT;

    //------------20120320׷��д����Ч�� ��ʼ-----------
    //FormatDateTime('yyyy-MM-dd HH:mm:ss',now);
    //Send_CMD_ID_Infor.ID_3F:=Receive_CMD_ID_Infor.ID_3F;
    //Send_CMD_ID_Infor.Password_3F:=Receive_CMD_ID_Infor.Password_3F;
  if iHHSet = 0 then //ʱ������������Ч
  begin
    Send_CMD_ID_Infor.ID_3F := IntToHex(0, 2) + IntToHex(0, 2) + IntToHex(0, 2);
    Send_CMD_ID_Infor.Password_3F := IntToHex(0, 2) + IntToHex(0, 2) + IntToHex(0, 2);
  end
  else //����ʱ������
  begin
    GetInvalidDate;
  end;

    //------------20120320׷��д����Ч�� ����-----------



  Send_CMD_ID_Infor.Password_USER := Receive_CMD_ID_Infor.Password_USER;
    //TmpStr_IncValue�ֽ���Ҫ�����Ų� �����StrIncValue>65535(FFFF)
   // TmpStr_IncValue:=IntToHex(strToint(StrIncValue),2);//��������ı�����ת��Ϊ16����
    //------------20120220׷�Ӵ��ұ���SystemWorkground.ErrorGTState ��ʼ-----------
    //TmpStr_IncValue:= StrIncValue;
  TmpStr_IncValue := IntToStr(StrToInt(StrIncValue) * StrToInt(SystemWorkground.ErrorGTState));
    //------------20120220׷�Ӵ��ұ��� ����-----------
  Send_CMD_ID_Infor.ID_value := Select_IncValue_Byte(TmpStr_IncValue);

    //����������
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


//ȡ����Чʱ������

procedure Tfrm_QC_AE_LineBarscan.GetInvalidDate;
var
  strtemp: string;
  iYear, iMonth, iDate, iHH, iMin: integer;
begin


  strtemp := FormatDateTime('yyyy-MM-dd HH:mm:ss', now);
    //����ǰ
   // strtemp:=Copy(strtemp,1,2)+Copy(strtemp,3,2)+Copy(strtemp,6,2)+Copy(strtemp,9,2)+Copy(strtemp,12,2)+Copy(strtemp,15,2)+Copy(strtemp,20,2);
     //������

  iYear := strToint(Copy(strtemp, 1, 4)); //��
  iMonth := strToint(Copy(strtemp, 6, 2)); //��
  iDate := strToint(Copy(strtemp, 9, 2)); //��
  iHH := strToint(Copy(strtemp, 12, 2)); //Сʱ
  iMin := strToint(Copy(strtemp, 15, 2)); //����

  if (iHHSet > 47) then
  begin
    showmessage('Ϊ�˱������������氲ȫ�����趨����Чʱ��С��48');
    exit;
  end;
  if ((iHH + iHHSet) >= 24) and ((iHH + iHHSet) < 48) then
  begin
    iHH := (iHH + iHHSet) - 24; //ȡ���µ�Сʱ
    if (iYear < 1930) then
    begin
      showmessage('ϵͳʱ�������趨�������뿨ͷ��ʱͬ��');
      exit;
    end;
    if (iMonth = 2) then
    begin
      if ((iYear mod 4) = 0) or ((iYear mod 100) = 0) then //���� 2��Ϊ28��
      begin
        if (iDate = 28) then
        begin
          iDate := 1;
          iMonth := iMonth + 1;
        end
        else
        begin
          iDate := iDate + 1;
        end;
      end
      else //��������  2��Ϊ29��
      begin
        if (iDate = 29) then
        begin
          iDate := 1;
          iMonth := iMonth + 1;
        end
        else
        begin
          iDate := iDate + 1;
        end;
      end;
    end
    else if (iMonth = 1) or (iMonth = 3) or (iMonth = 5) or (iMonth = 7) or (iMonth = 8) or (iMonth = 10) then
    begin
      if (iDate = 31) then
      begin
        iDate := 1;
        iMonth := iMonth + 1;
      end
      else
      begin
        iDate := iDate + 1;
      end;
    end
    else if (iMonth = 12) then
    begin
      if (iDate = 31) then
      begin
        iDate := 1;
        iMonth := 1;
        iYear := iYear + 1;
      end
      else
      begin
        iDate := iDate + 1;
      end;
    end
    else if (iMonth = 4) or (iMonth = 6) or (iMonth = 9) or (iMonth = 11) then
    begin
      if (iDate = 30) then
      begin
        iDate := 1;
        iMonth := iMonth + 1;
      end
      else
      begin
        iDate := iDate + 1;
      end;
    end;
  end
  else if ((iHH + iHHSet) < 24) then
  begin
    iHH := (iHH + iHHSet); //ȡ���µ�Сʱ
  end;

     //ת��Ϊ16���ƺ�
  Send_CMD_ID_Infor.ID_3F := IntToHex(iMonth, 2) + IntToHex(iHH, 2) + IntToHex(strtoint(Copy(strtemp, 3, 2)), 2);
  Send_CMD_ID_Infor.Password_3F := IntToHex(iDate, 2) + IntToHex(iMin, 2) + IntToHex(strtoint(Copy(strtemp, 1, 2)), 2);
    //strtemp:=Copy(strtemp,6,2)+Copy(strtemp,12,2)+Copy(strtemp,3,2)+Copy(strtemp,9,2)+Copy(strtemp,15,2)+Copy(strtemp,1,2);


end;

procedure Tfrm_QC_AE_LineBarscan.comReaderReceiveData(Sender: TObject;
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


end;


 //���ݽ��յ��������жϴ˿��Ƿ�Ϊ�Ϸ���

procedure Tfrm_QC_AE_LineBarscan.CheckCMD();
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
    if (Receive_CMD_ID_Infor.ID_type = copy(INit_Wright.RECV_CASE, 8, 2)) then
    begin
      if DataModule_3F.Query_ID_OK(Receive_CMD_ID_Infor.ID_INIT) then
      begin
                            //��ѯ��ǰ��Ա�����趨����
        Query_MenberInfor(Receive_CMD_ID_Infor.ID_INIT);
                            //��ѯ��ǰ��Ա����24Сʱ�����޳�ֵ��¼ ����ֹ�ǼٵĻ�Ա��
        if Query_Menber_IncRecord(Receive_CMD_ID_Infor.ID_INIT) then
        begin
          Edit_UserPwd.Enabled := true; //������������
          Panel_Infor.Caption := '��֤�ɹ�����������������';
          Edit_ID.Text := Receive_CMD_ID_Infor.ID_INIT;
          Edit_UserPwd.SetFocus;
        end
        else
        begin
          Panel_Infor.Caption := '�˻�Ա�����޳�ֵ��¼����ȷ�ϣ�';
        end;
      end
      else
      begin
        Panel_Infor.Caption := '����ʧ�ܣ���ǰ�������ڱ����أ�';
        exit;
      end;
    end
    else if ((Receive_CMD_ID_Infor.ID_type = copy(INit_Wright.Produecer_3F, 8, 2)) or (Receive_CMD_ID_Infor.ID_type = copy(INit_Wright.BOSS, 8, 2))) then
    begin
      if DataModule_3F.Query_ID_OK(LOAD_USER.ID_INIT) then
      begin
        Tuibi_Operate_Enable := '1';
      end
      else
      begin
        Panel_Infor.Caption := '����ʧ�ܣ���ǰ�������ڱ����أ�';
        exit;
      end;
    end
    else if ((Receive_CMD_ID_Infor.ID_type = copy(INit_Wright.User, 8, 2))) then
    begin

      if not (CheckBox_Menber.Checked) then //û��ѡ��ȡ�����
      begin
        if Tuibi_Operate_Enable = '1' then //�Ѿ��ɹ�ˢ��Ա��
        begin
                            //1����ѯ��ֵ��¼���Ƿ��д˱ң���ֹ�ٵĵ��ӱ�
          if Query_Menber_IncRecord_by_EBid(Receive_CMD_ID_Infor.ID_INIT) then
          begin
                                //��õ��ӱ�ID
            Edit_EBID.Text := Receive_CMD_ID_Infor.ID_INIT;
                                //��õ��ӱұ�ֵ
            Edit_EBValue.Text := ICFunction.Select_ChangeHEX_DECIncValue(Receive_CMD_ID_Infor.ID_value);


                                //��ѯ��ǰ���ӱ����ĳ�ֵ��¼���Ի�ó�ֵʱ��
            Query_EBINCinformation_by_EBid(Receive_CMD_ID_Infor.ID_INIT);
                               //��ѯ��ǰ��Ա�ܵ��˱�ֵ
            Query_Tuibi_Total(TrimRight(Edit_ID.Text));

            Panel_Infor.Caption := '�˵��ӱ��г�ֵ��¼����֤OK��';
          end
          else
          begin
            Panel_Infor.Caption := '�˵��ӱ��޳�ֵ��¼����ȷ�ϣ�';
          end;

        end
        else
        begin
          Panel_Infor.Caption := '����ʧ�ܣ�����ˢ��Ա�����ϰ忨��';
          exit;
        end;
      end
      else //ȡ����Ա���
      begin
                       //1����ѯ��ֵ��¼���Ƿ��д˱ң���ֹ�ٵĵ��ӱ�
        if Query_Menber_IncRecord_by_EBid(Receive_CMD_ID_Infor.ID_INIT) then
        begin
                                //��õ��ӱ�ID
          Edit_EBID.Text := Receive_CMD_ID_Infor.ID_INIT;
                                //��õ��ӱұ�ֵ
          Edit_EBValue.Text := ICFunction.Select_ChangeHEX_DECIncValue(Receive_CMD_ID_Infor.ID_value);


                                //��ѯ��ǰ���ӱ����ĳ�ֵ��¼���Ի�ó�ֵʱ��
          Query_EBINCinformation_by_EBid(Receive_CMD_ID_Infor.ID_INIT);
                               //��ѯ��ǰ��Ա�ܵ��˱�ֵ
          Query_Tuibi_Total(TrimRight(Edit_ID.Text));

          Panel_Infor.Caption := '�˵��ӱ��г�ֵ��¼����֤OK��';
        end
        else
        begin
          Panel_Infor.Caption := '�˵��ӱ��޳�ֵ��¼����ȷ�ϣ�';
        end;
      end;
    end
    else //�������ܿ�AA��Ҳ���ǻ�Ա��
    begin
      Panel_Infor.Caption := '����ʧ�ܣ���ǰ�������ڱ����أ�';
      exit;
    end;
  end;

end;

 //��ѯ��ǰ��Ա���ľ�����

procedure Tfrm_QC_AE_LineBarscan.Query_MenberInfor(StrID: string);
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: string;
  strsexOrg: string;
begin
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select * from [TMemberInfo] where IDCardNo=''' + StrID + '''';

  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;

    Edit_Password.text := TrimRight(FieldByName('InfoKey').AsString); //��ѯ��Ա������

  end;
  FreeAndNil(ADOQTemp);
end;

procedure Tfrm_QC_AE_LineBarscan.Edit_UserPwdKeyPress(Sender: TObject;
  var Key: Char);
begin

  if not (key in ['0'..'9', #8, #13]) then
  begin
    key := #0;
    ShowMessage('�������ֻ���������֣�');
  end
  else if key = #13 then
  begin
    if (Edit_UserPwd.Text <> '') and (TrimRight(Edit_UserPwd.Text) = TrimRight(Edit_Password.Text)) and (length(TrimRight(Edit_UserPwd.Text)) = 6) then
    begin

      User_Pwd_Comfir := true; //����ȷ��
                     //Edit_BarScan.SetFocus;
      Edit_Total.Text := '';
      CheckBox_Update.Enabled := true; //�������ѡ����������
      Tuibi_Operate_Enable := '1';
    end
    else
    begin

      ShowMessage('�������ȷ�������뵱ǰ��Ա����ƥ�䣡');
      Edit_Total.Text := '';
      Tuibi_Operate_Enable := '0';
      Edit_UserPwd.SetFocus;

      exit;
    end;
  end;
end;
 {
procedure Tfrm_QC_AE_LineBarscan.BitBtn4Click(Sender: TObject);
var
  ADOQTemp:TADOQuery;
  strSQL:String;
  reTmpStr:String;
  strtime_OK,strtemp:String;
  strRet:boolean;
begin
                 strtemp:=FormatDateTime('yyyy-MM-dd HH:mm:ss',now);

                 //strtime_OK:=Copy(strtemp,1,10);  //��ѯ���죬��ĿǰΪֹ�����޳�ֵ��¼
                 strtime_OK:=ICFunction.GetInvalidDate(strtemp); //ȡ�ÿ�ʼ����;
                 Edit1.Text:=strtime_OK;
                 Edit2.Text:=strtemp;

end;
 }



 //��ֵ����

procedure Tfrm_QC_AE_LineBarscan.INcrevalue(S: string);
begin
  orderLst.Clear();
  recDataLst.Clear();
  curOrderNo := 0;
  curOperNo := 2;
    //Edit1.Text:=s;
  orderLst.Add(S); //����ֵд�����
  sendData();
end;

//ת�ҷ������ݸ�ʽ

function Tfrm_QC_AE_LineBarscan.exchData(orderStr: string): string;
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

procedure Tfrm_QC_AE_LineBarscan.sendData();
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
//��ֵ����ת����16���Ʋ����� �ֽ�LL���ֽ�LH���ֽ�HL���ֽ�HH

function Tfrm_QC_AE_LineBarscan.Select_IncValue_Byte(StrIncValue: string): string;
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

function Tfrm_QC_AE_LineBarscan.Select_CheckSum_Byte(StrCheckSum: string): string;
var
  jj: integer;
  tempLH, tempLL: integer; //2147483648 ���Χ

begin
  jj := strToint('$' + StrCheckSum); //���ַ�תת��Ϊ16��������Ȼ��ת��λ10����
  tempLH := (jj mod 65536) div 256; //�ֽ�LH
  tempLL := jj mod 256; //�ֽ�LL

  result := IntToHex(tempLL, 2) + IntToHex(tempLH, 2);
end;

//У��ͣ�ȷ���Ƿ���ȷ

function Tfrm_QC_AE_LineBarscan.CheckSUMData(orderStr: string): string;
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

procedure Tfrm_QC_AE_LineBarscan.BitBtn4Click(Sender: TObject);
begin
  Query_Menber_IncRecord('');
end;

end.
