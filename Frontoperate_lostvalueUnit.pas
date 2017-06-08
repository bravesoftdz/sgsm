unit Frontoperate_lostvalueUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, DB, ADODB, ExtCtrls, StdCtrls, Buttons, SPComm, DateUtils;


type
  Tfrm_Frontoperate_lostvalue = class(TForm)
    Panel1: TPanel;
    DBGrid2: TDBGrid;
    Panel2: TPanel;
    GroupBox4: TGroupBox;
    Label1: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Image1: TImage;
    GroupBox5: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label5: TLabel;
    Edit_ID: TEdit;
    Edit_PrintNO: TEdit;
    Edit_Username: TEdit;
    Edit_Certify: TEdit;
    Edit_SaveMoney: TEdit;
    Edit_Prepassword: TEdit;
    Comb_menberlevel: TComboBox;
    Edit_Mobile: TEdit;
    rgSexOrg: TRadioGroup;
    Edit_UserNo: TEdit;
    Edit_Incvalue: TEdit;
    Edit_Pwdcomfir: TEdit;
    Edit_Totalvale: TEdit;
    Bitn_LostvalueComfir: TBitBtn;
    Bitn_Close: TBitBtn;
    BitBtn1: TBitBtn;
    Bit_Valuecomfir: TBitBtn;
    DataSource_Newmenber: TDataSource;
    ADOQuery_newmenber: TADOQuery;
    DataSource_Incvalue: TDataSource;
    ADOQuery_Incvalue: TADOQuery;
    comReader: TComm;
    Label2: TLabel;
    Edit_Givecore: TEdit;
    procedure BitBtn1Click(Sender: TObject);
    procedure Bit_ValuecomfirClick(Sender: TObject);
    procedure Bitn_LostvalueComfirClick(Sender: TObject);
    procedure Bitn_CloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure comReaderReceiveData(Sender: TObject; Buffer: Pointer;
      BufferLength: Word);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    function exchData(orderStr: string): string;
    procedure sendData();
    procedure checkOper();
    procedure InitDataBase;
    procedure Getmenberinfo(S: string);
    procedure GetmenberLostcore(S: string);
  public
    { Public declarations }
  end;

var
  frm_Frontoperate_lostvalue: Tfrm_Frontoperate_lostvalue;
  curOrderNo: integer = 0;
  curOperNo: integer = 0;
  orderLst, recDataLst: Tstrings;
  buffer: array[0..2048] of byte;
implementation
uses ICDataModule, ICtest_Main, ICCommunalVarUnit, ICmain, ICEventTypeUnit;
{$R *.dfm}

procedure Tfrm_Frontoperate_lostvalue.InitDataBase;
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
  with ADOQuery_Incvalue do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select * from [TMembeDetail]';
    SQL.Add(strSQL);
    Active := True;
  end;
end;
//ת�ҷ������ݸ�ʽ

function Tfrm_Frontoperate_lostvalue.exchData(orderStr: string): string;
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

procedure Tfrm_Frontoperate_lostvalue.sendData();
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

procedure Tfrm_Frontoperate_lostvalue.checkOper();
var
  i: integer;
  tmpStr: string;
begin
  case curOperNo of
    0: begin
        for i := 0 to recDataLst.Count - 1 do
          if copy(recDataLst.Strings[i], 3, 2) <> '00' then
          begin
                      //  memComSet.Lines.Add('����������ʧ��');
                      //  memComSet.Lines.Add('');
            exit;
          end;
              //  memComSet.Lines.Add('����������ɹ�');
              //  memComSet.Lines.Add('');
      end;
    1: begin
             //   memLowRe.Lines.Add('����: Ѱ��');
        if copy(recDataLst.Strings[0], 3, 2) <> '00' then
                //    memLowRe.Lines.Add('���: Ѱ��ʧ��')
        else begin
                  //  memLowRe.Lines.Add('���: Ѱ���ɹ�');
          if copy(recDataLst.Strings[0], 5, 2) = '04' then
                   //     memLowRe.Lines.Add('�ÿ�ƬΪMifare one')
          else
                   //     memLowRe.Lines.Add('�ÿ�ƬΪ��������');
        end;
              //  memLowRe.Lines.Add('');
      end;
    2: begin
                //memLowRe.Lines.Add('����: ����ͻ');
                //  AND (copy(recDataLst.Strings[0],23,2)='4A')
        if (copy(recDataLst.Strings[0], 9, 2) = 'A1') and (copy(recDataLst.Strings[0], 23, 2) = '4A') then
        begin
          Edit_ID.Text := copy(recDataLst.Strings[0], 13, 8);
          tmpStr := copy(recDataLst.Strings[0], 13, 8);
                   // Edit_IDNo.Text:=tmpStr;
          Edit_ID.Text := tmpStr;
          Getmenberinfo(tmpStr);
          Bit_Valuecomfir.Enabled := True;
                   // memLowRe.Lines.Add('���: ����ͻʧ��')
        end
        else begin
                  //  memLowRe.Lines.Add('���: ����ͻ�ɹ�');
          tmpStr := recDataLst.Strings[0];
          tmpStr := copy(tmpStr, 5, length(tmpStr) - 4);
                   // memLowRe.Lines.Add('���: '+tmpStr);
        end;
                 // memLowRe.Lines.Add('');

      end;
    3: begin
               // memLowRe.Lines.Add('����: ѡ��');
        if copy(recDataLst.Strings[0], 3, 2) <> '00' then
                  //  memLowRe.Lines.Add('���: ѡ��ʧ��')
        else
                   // memLowRe.Lines.Add('���: ѡ��ɹ�');
             //   memLowRe.Lines.Add('');
      end;
    4: begin
               // memLowRe.Lines.Add('����: ��ֹ');
        if copy(recDataLst.Strings[0], 3, 2) <> '00' then
                 //   memLowRe.Lines.Add('���: ��ֹʧ��')
        else
                  //  memLowRe.Lines.Add('���: ��ֹ�ɹ�');
                //memLowRe.Lines.Add('');
      end;
    5: begin
        for i := 0 to recDataLst.Count - 1 do
          if copy(recDataLst.Strings[i], 3, 2) <> '00' then
          begin
            MessageBox(handle, '��������ʧ��', 'ʧ��', MB_OK);
            exit;
          end;
        MessageBox(handle, '�������سɹ�', '�ɹ�', MB_OK);
      end;
    6: begin
        for i := 0 to 3 do
        begin
          if copy(recDataLst.Strings[i + 4], 3, 2) <> '00' then
          begin
                      //  gbRWSector.Caption:=cbRWSec.Text+'��ȡʧ��';
            exit;
          end;
        end;
             //   edtBlock0.Text:=copy(recDataLst.Strings[4],5,32);
             //   edtBlock1.Text:=copy(recDataLst.Strings[5],5,32);
            //    edtBlock2.Text:=copy(recDataLst.Strings[6],5,32);
             //   edtBlock3.Text:=copy(recDataLst.Strings[7],5,32);
             //   gbRWSector.Caption:=cbRWSec.Text+'��ȡ�ɹ�';
      end;
    7: begin
        for i := 0 to recDataLst.Count - 1 do
          if copy(recDataLst.Strings[i], 3, 2) <> '00' then
          begin
                  //      gbRWSector.Caption:=cbRWSec.Text+'д��ʧ��';
            exit;
          end;
               // gbRWSector.Caption:=cbRWSec.Text+'д��ɹ�';
      end;
    8: begin
        for i := 0 to recDataLst.Count - 1 do
          if copy(recDataLst.Strings[i], 3, 2) <> '00' then
          begin
                   //     MessageBox(handle,'��ֵ��ʼ��ʧ��','ʧ��',MB_OK);
            exit;
          end;
        MessageBox(handle, '��ֵ��ʼ���ɹ�', '�ɹ�', MB_OK);
      end;
    9: begin
        for i := 0 to recDataLst.Count - 1 do
          if copy(recDataLst.Strings[i], 3, 2) <> '00' then
          begin
            MessageBox(handle, '��ֵ��ȡʧ��', 'ʧ��', MB_OK);
            exit;
          end;
               // edtCurValue.Text:=copy(recDataLst.Strings[4],5,8);
        MessageBox(handle, '��ֵ��ȡ�ɹ�', '�ɹ�', MB_OK);
      end;
    10: begin
        for i := 0 to recDataLst.Count - 1 do
          if copy(recDataLst.Strings[i], 3, 2) <> '00' then
          begin
            MessageBox(handle, '��ֵ��ֵʧ��', 'ʧ��', MB_OK);
            exit;
          end;
        MessageBox(handle, '��ֵ��ֵ�ɹ�', '�ɹ�', MB_OK);
      end;
    11: begin
        for i := 0 to recDataLst.Count - 1 do
          if copy(recDataLst.Strings[i], 3, 2) <> '00' then
          begin
            MessageBox(handle, '��ֵ��ֵʧ��', 'ʧ��', MB_OK);
            exit;
          end;
        MessageBox(handle, '��ֵ��ֵ�ɹ�', '�ɹ�', MB_OK);
      end;
    12: begin
        for i := 0 to recDataLst.Count - 1 do
          if copy(recDataLst.Strings[i], 3, 2) <> '00' then
          begin
            MessageBox(handle, '�����޸�ʧ��', 'ʧ��', MB_OK);
            exit;
          end;
        MessageBox(handle, '�����޸ĳɹ�', '�ɹ�', MB_OK);
      end;
  end;
end;

procedure Tfrm_Frontoperate_lostvalue.BitBtn1Click(Sender: TObject);
begin
  orderLst.Clear();
  recDataLst.Clear();
  curOrderNo := 0;
  curOperNo := 2;
    //orderLst.Add('0103');
    //orderLst.Add('020B0F');
  orderLst.Add('AA8A5F5FA101004A');
  sendData();
end;
 //���ݲ�ѯ�õ�����ID����ѯ������Ϣ��Ϊ��ֵ��׼��

procedure Tfrm_Frontoperate_lostvalue.Getmenberinfo(S: string);
var
  ADOQ: TADOQuery;
  strSQL, strRet: string;
  strsexOrg: string;

begin
  strRet := '0';
  strSQL := 'select MemCardNo,MemCardNo,MemberName,Sex,DocNumber,MemType,InfoKey,CardAmount,Mobile from TMemberInfo where [IDCardNo]=''' + S + '''';
  ADOQ := TADOQuery.Create(nil);

  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Open;
    if (not eof) then
    begin

      Edit_PrintNO.Text := ADOQ.Fields[0].AsString;
      Edit_UserNo.Text := ADOQ.Fields[1].AsString;
      Edit_Username.Text := ADOQ.Fields[2].AsString;
      strsexOrg := ADOQ.Fields[3].AsString;
      if strsexOrg = '1' then
        rgSexOrg.ItemIndex := 0
      else
        rgSexOrg.ItemIndex := 1;

      Edit_Certify.Text := ADOQ.Fields[4].AsString;
      Comb_menberlevel.Text := ADOQ.Fields[5].AsString;
      Edit_Prepassword.Text := ADOQ.Fields[6].AsString;
      Edit_SaveMoney.Text := ADOQ.Fields[7].AsString;
      Edit_Mobile.Text := ADOQ.Fields[8].AsString;
      Close;
    end
    else
    begin
      ShowMessage('ϵͳ���޴˿�������¼����ȷ�ϴ����Ƿ��Ա������');
      exit;
    end;
  end;
  FreeAndNil(ADOQ);

 // Result:=strRet;
end;
//�����������ֶ�ȣ���ѯ��Ӧ��¼�����ж��ٷֿ�����

procedure Tfrm_Frontoperate_lostvalue.GetmenberLostcore(S: string);
var
  ADOQ: TADOQuery;
  strSQL, strRet: string;
  strsexOrg: string;
  i: integer;
  totalvaluelost: array[0..2] of double;
begin
  i := 0;
  strSQL := 'select sum(CostMoney) from TMembeDetail where [MemCardNo]=''' + S + ''' group by PayType order by PayType DESC';

  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Open;
    while not eof do //�ۼ��ͷ���������������ȷ�ϻ��ж��ٻ��ֿ��Խ������ֲ���
    begin
      totalvaluelost[i] := ADOQ.Fields[0].AsFloat;
      i := i + 1;
      next;
    end; //while
  end; //with
  close;
  Edit_Givecore.Text := FloatToStr(totalvaluelost[1] - totalvaluelost[0]); //���Խ������ֵĻ�����
  FreeAndNil(ADOQ);
end;

procedure Tfrm_Frontoperate_lostvalue.Bit_ValuecomfirClick(
  Sender: TObject);
begin
  if Edit_Incvalue.Text = '' then
    ShowMessage('��ֵ���Ϊ�գ���������ֵ')
  else begin
//�����û���Ų�ѯȡ�ÿ������ķ�ֵ
    GetmenberLostcore(Edit_UserNo.Text);
    Bit_Valuecomfir.Enabled := False;
    Edit_Pwdcomfir.Enabled := True;
   //Edit_Pwdcomfir.Focused:=True;
    Bitn_LostvalueComfir.Enabled := True;
  end;
end;

//���ֲ���ȷ�ϣ����˲�����¼д�����ݿ��

procedure Tfrm_Frontoperate_lostvalue.Bitn_LostvalueComfirClick(
  Sender: TObject);
var
  strName, strIDNo, strUserNo, strLostvalue, strLostcore, strOperator, strhavemoney, strinputdatetime: string;
  i: integer;
label ExitSub;
begin
  strUserNo := Edit_UserNo.Text; //�û����
  strName := Edit_Username.Text; //�û�����
  strIDNo := Edit_ID.Text; //��ID
  strLostvalue := Edit_Incvalue.Text; //��ֵ

  strOperator := G_User.UserNO; //����Ա
  strhavemoney := Edit_Totalvale.Text; //�˻����
  strinputdatetime := DateTimetostr((now())); //¼��ʱ�䣬��ȡϵͳʱ��

  if Edit_Pwdcomfir.Text <> Edit_Prepassword.Text then
    ShowMessage('�ͻ�����ȷ�������������������')
  else begin
    with ADOQuery_Incvalue do begin

      Bitn_LostvalueComfir.Enabled := False; //�ر��������
      Append;

      FieldByName('MemCardNo').AsString := strUserNo;
      FieldByName('CostMoney').AsString := strLostvalue; //���ֶ�
      FieldByName('TickCount').AsInteger := 0; ; //�ͷ�ֵ
      FieldByName('cUserNo').AsString := strOperator; //����Ա
      FieldByName('GetTime').AsString := strinputdatetime; //����ʱ��
      FieldByName('TotalMoney').AsString := strhavemoney; //�ʻ��ܶ�

      FieldByName('IDCardNo').AsString := strIDNo; //��ֵ����
      FieldByName('MemberName').AsString := strName; //�û���

      FieldByName('PayType').AsString := '1'; //���ֲ���
      FieldByName('MacNo').AsString := 'A0100'; //��̨���
      FieldByName('ExitCoin').AsInteger := 0; //�˱���
      FieldByName('Compter').AsString := '1';
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
end;

procedure Tfrm_Frontoperate_lostvalue.Bitn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure Tfrm_Frontoperate_lostvalue.FormCreate(Sender: TObject);
begin
  EventObj := EventUnitObj.Create;
  EventObj.LoadEventIni;
  InitDataBase; //��ʾ���ͺ�
end;

procedure Tfrm_Frontoperate_lostvalue.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  i: integer;
begin
  orderLst.Free();
  recDataLst.Free();
  comReader.StopComm();
  for i := 0 to ComponentCount - 1 do
  begin
    if components[i] is TEdit then
    begin
      (components[i] as TEdit).Clear;
    end
  end;
end;

procedure Tfrm_Frontoperate_lostvalue.comReaderReceiveData(Sender: TObject;
  Buffer: Pointer; BufferLength: Word);
var
  ii: integer;
  recStr: string;
  tmpStr: string;
begin
  recStr := '';
  SetLength(tmpStr, BufferLength);
  move(buffer^, pchar(tmpStr)^, BufferLength);
  for ii := 1 to BufferLength do
  begin
    recStr := recStr + intTohex(ord(tmpStr[ii]), 2);
  end;
  //  memComSeRe.Lines.Add('<<== '+recStr);
  recDataLst.Add(recStr);
  if curOrderNo < orderLst.Count then
    sendData()
  else begin
    checkOper();
       // memComSeRe.Lines.Append('');
  end;
end;

procedure Tfrm_Frontoperate_lostvalue.FormShow(Sender: TObject);
begin

  comReader.StartComm();
  orderLst := TStringList.Create;
  recDataLst := tStringList.Create;
end;

end.
