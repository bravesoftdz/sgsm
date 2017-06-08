unit Frontoperate_lostuserUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, Grids, DBGrids, DB, ADODB, SPComm;

type
  Tfrm_Frontoperate_lostuser = class(TForm)
    Panel1: TPanel;
    DBGrid2: TDBGrid;
    Panel2: TPanel;
    comReader: TComm;
    DataSource1: TDataSource;
    ADOQuery_lostuser: TADOQuery;
    Panel3: TPanel;
    GroupBox4: TGroupBox;
    Label1: TLabel;
    Comb_querytype: TComboBox;
    Edit_querycontent: TEdit;
    Bit_Query: TBitBtn;
    GroupBox5: TGroupBox;
    GroupBox3: TGroupBox;
    Label2: TLabel;
    Label8: TLabel;
    Edit_Pwdcomfir: TEdit;
    Memo1: TMemo;
    Bit_Close: TBitBtn;
    Image1: TImage;
    Bit_Update: TBitBtn;
    Label3: TLabel;
    Edit_PrintNO: TEdit;
    Label4: TLabel;
    Edit_Username: TEdit;
    Label5: TLabel;
    Edit_Prepassword: TEdit;
    Label6: TLabel;
    Edit_Certify: TEdit;
    Label7: TLabel;
    Edit_TotalbuyValue: TEdit;
    Label10: TLabel;
    Edit_TotalChangeValue: TEdit;
    Label9: TLabel;
    Edit_ID: TEdit;
    Label12: TLabel;
    rgSexOrg: TRadioGroup;
    Label13: TLabel;
    Edit_Mobile: TEdit;
    Label11: TLabel;
    Comb_menberlevel: TComboBox;
    Label14: TLabel;
    Edit_SaveMoney: TEdit;
    Label16: TLabel;
    procedure Bit_QueryClick(Sender: TObject);
    procedure comReaderReceiveData(Sender: TObject; Buffer: Pointer;
      BufferLength: Word);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Bit_CloseClick(Sender: TObject);
    procedure Bit_UpdateClick(Sender: TObject);
    procedure Edit_PwdcomfirKeyPress(Sender: TObject; var Key: Char);
    procedure Comb_querytypeChange(Sender: TObject);
  private
    { Private declarations }
    function exchData(orderStr: string): string;
    procedure sendData();
    procedure checkOper();
    procedure InitDataBase;
    procedure Getmenberinfo(S1, S2: string);
    procedure Query_ChangeValueInfor(StrID: string);
    procedure Query_INCValueInfor(StrID: string);
    procedure Query_MenberLevInfor(StrLevNum: string);
  public
    { Public declarations }
  end;

var
  frm_Frontoperate_lostuser: Tfrm_Frontoperate_lostuser;
  curOrderNo: integer = 0;
  curOperNo: integer = 0;
  orderLst, recDataLst: Tstrings;
  buffer: array[0..2048] of byte;
implementation
uses ICDataModule, ICtest_Main, ICCommunalVarUnit, ICmain, ICEventTypeUnit;
{$R *.dfm}


procedure Tfrm_Frontoperate_lostuser.InitDataBase;
var
  strSQL: string;
begin

  with ADOQuery_lostuser do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select * from [TMemberInfo] where IsAble=''0''';
    SQL.Add(strSQL);
    Active := True;
  end;

end;


//ת�ҷ������ݸ�ʽ

function Tfrm_Frontoperate_lostuser.exchData(orderStr: string): string;
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

procedure Tfrm_Frontoperate_lostuser.sendData();
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

procedure Tfrm_Frontoperate_lostuser.checkOper();
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

  end;
end;


procedure Tfrm_Frontoperate_lostuser.comReaderReceiveData(Sender: TObject;
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

procedure Tfrm_Frontoperate_lostuser.FormShow(Sender: TObject);
begin
 //   comReader.StartComm();
 //   orderLst:=TStringList.Create;
  //  recDataLst:=tStringList.Create;
  Edit_querycontent.MaxLength := 11;
  Bit_Update.Enabled := false;
  InitDataBase; //��ʾ���ͺ�
end;

procedure Tfrm_Frontoperate_lostuser.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  i: integer;
begin
   // orderLst.Free();
  // recDataLst.Free();
  //  comReader.StopComm();
  for i := 0 to ComponentCount - 1 do
  begin
    if components[i] is TEdit then
    begin
      (components[i] as TEdit).Clear;
    end
  end;
end;

//��ѯ��ʧ��Ա�������Ϣ

procedure Tfrm_Frontoperate_lostuser.Bit_QueryClick(Sender: TObject);
var
  strquerycontent, strquerytype: string;

begin
  strquerytype := Comb_querytype.Text;
  strquerycontent := Edit_querycontent.Text;
  if Comb_querytype.Text = '' then
    ShowMessage('δѡ���ѯ��ʽ����ѡ��')
  else if Edit_querycontent.Text = '' then
    ShowMessage('δ��д��ѯ�����ݣ����ѯ��ʽ����')
  else
    Getmenberinfo(strquerytype, strquerycontent); //��ѯ��������

end;

procedure Tfrm_Frontoperate_lostuser.Getmenberinfo(S1, S2: string);
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: string;
  strsexOrg: string;
begin

  if S1 = '�����û��ֻ���' then
    strSQL := 'select * from [TMemberInfo] where  [Mobile]=''' + S2 + ''''
  else if S1 = '�����û����֤' then
    strSQL := 'select * from [TMemberInfo] where  [DocNumber]=''' + S2 + ''''
  else
  begin
    Edit_Pwdcomfir.text := '�Բ���������������';
    exit;
  end;
  ADOQTemp := TADOQuery.Create(nil);

  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;

    Edit_PrintNO.text := FieldByName('MemCardNo').AsString;
    Edit_Username.text := FieldByName('MemberName').AsString;
    Edit_ID.text := FieldByName('IDCardNo').AsString;
    Edit_Prepassword.text := FieldByName('InfoKey').AsString;
    Edit_Mobile.text := FieldByName('Mobile').AsString;
    Edit_Certify.text := FieldByName('DocNumber').AsString;
    Edit_SaveMoney.text := FieldByName('Deposit').AsString;

    strsexOrg := FieldByName('Sex').AsString;
    if strsexOrg = '1' then
      rgSexOrg.ItemIndex := 0
    else
      rgSexOrg.ItemIndex := 1;

    Query_MenberLevInfor(TrimRight(FieldByName('LevNum').AsString));
    Query_INCValueInfor(TrimRight(FieldByName('IDCardNo').AsString)); //�ܳ�ֵֵ����Դ���ݱ�[TMembeDetail]��
    Query_ChangeValueInfor(TrimRight(FieldByName('IDCardNo').AsString)); //�ܶһ�ֵ����Դ���ݱ�[3F_BARFLOW]��
  end;
  FreeAndNil(ADOQTemp);
end;

 //��ѯ�ȼ�����

procedure Tfrm_Frontoperate_lostuser.Query_MenberLevInfor(StrLevNum: string); //��ѯ�ȼ�����
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: string;
begin
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select LevName from [TLevel] where LevNo=''' + StrLevNum + '''';

  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    Comb_menberlevel.text := FieldByName('LevName').AsString;
  end;
  FreeAndNil(ADOQTemp);
end;
 //��ѯ������ֵ�������

procedure Tfrm_Frontoperate_lostuser.Query_INCValueInfor(StrID: string);
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: string;
  strMaxMD_ID: string;
begin
                 //ȡ�����µ��ּܷ�¼ID
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select Max([MD_ID]) from [TMembeDetail] where IDCardNo=''' + StrID + '''';

  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    strMaxMD_ID := ADOQTemp.Fields[0].AsString;
  end;
  FreeAndNil(ADOQTemp);


                 //ȡ�����µ��ܷ�
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select TotalMoney from [TMembeDetail] where (IDCardNo=''' + StrID + ''') and (MD_ID=''' + strMaxMD_ID + ''')';

  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    Edit_TotalbuyValue.text := FieldByName('TotalMoney').AsString;
  end;
  FreeAndNil(ADOQTemp);
end;

 //��ѯ�����ҽ��������

procedure Tfrm_Frontoperate_lostuser.Query_ChangeValueInfor(StrID: string);
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: string;
  strMaxMD_ID: string;
begin

                 //ȡ�öһ���ֵ
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select Sum([Value_BiLi]) from [3F_BARFLOW] where (IDCardNo=''' + StrID + ''') ';

  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    Edit_TotalChangeValue.text := ADOQTemp.Fields[0].AsString;
  end;
  FreeAndNil(ADOQTemp);
end;

procedure Tfrm_Frontoperate_lostuser.Bit_CloseClick(Sender: TObject);
begin
  Close;
end;

//�����ʧ��Ϣ

procedure Tfrm_Frontoperate_lostuser.Bit_UpdateClick(Sender: TObject);
var
  strlevel: string;
begin
  strlevel := Edit_ID.Text; //��ID

  if (TrimRight(Edit_Pwdcomfir.Text) = TrimRight(Edit_Prepassword.Text)) and (TrimRight(Edit_Pwdcomfir.Text) <> '') then
  begin
    with ADOQuery_lostuser do begin
      if (not Locate('IDCardNo', strlevel, [])) then
        Exit;
      Edit;
      FieldByName('IsAble').AsString := '0';
      Bit_Update.Enabled := False;
      InitDataBase; //��ʾ���ͺ�
      try
        Post;
      except
        on e: Exception do ShowMessage(e.Message);
      end;
    end;
  end
  else
  begin
    ShowMessage('�ͻ�����ȷ�������������������');
  end;


end;





procedure Tfrm_Frontoperate_lostuser.Edit_PwdcomfirKeyPress(
  Sender: TObject; var Key: Char);
var
  strtemp: string;
  strvalue: Double;
begin

  if not (key in ['0'..'9', #8, #13]) then
  begin
    key := #0;
    ShowMessage('�������ֻ���������֣�');
  end
  else if key = #13 then
  begin
    if (TrimRight(Edit_Pwdcomfir.Text) = TrimRight(Edit_Prepassword.Text)) and (TrimRight(Edit_Pwdcomfir.Text) <> '') then
    begin
      Bit_Update.Enabled := True;
    end
    else
    begin

      ShowMessage('������������볤��Ϊ6λ�����룡');
      exit;
    end;
  end;

end;

procedure Tfrm_Frontoperate_lostuser.Comb_querytypeChange(Sender: TObject);
begin
  if trimRight(Comb_querytype.Text) = '�����û��ֻ���' then
    Edit_querycontent.MaxLength := 11
  else if trimRight(Comb_querytype.Text) = '�����û����֤' then
    Edit_querycontent.MaxLength := 18
  else
    Edit_querycontent.MaxLength := 1;
end;

end.
