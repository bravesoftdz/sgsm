unit Frontoperate_renewuserUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, Grids, DBGrids, DB, ADODB, SPComm;

type
  Tfrm_Frontoperate_renewuser = class(TForm)
    Panel1: TPanel;
    DBGrid2: TDBGrid;
    Panel2: TPanel;
    DataSource_renewmenber: TDataSource;
    ADOQuery_renewmenber: TADOQuery;
    comReader: TComm;
    DataSource1: TDataSource;
    ADOQuery_renewmenberrecord: TADOQuery;
    Panel3: TPanel;
    Panel4: TPanel;
    GroupBox4: TGroupBox;
    Label2: TLabel;
    Label8: TLabel;
    Label16: TLabel;
    Edit_newID: TEdit;
    Bitn_ReadNewID: TBitBtn;
    Edit_Prepasswordnew: TEdit;
    Edit_PrintNONew: TEdit;
    GroupBox5: TGroupBox;
    Label6: TLabel;
    Label7: TLabel;
    Label3: TLabel;
    Label9: TLabel;
    Label4: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label11: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label5: TLabel;
    Edit_Certify: TEdit;
    Edit_SaveMoney: TEdit;
    Edit_PrintNO: TEdit;
    Edit_ID: TEdit;
    Edit_Username: TEdit;
    rgSexOrg: TRadioGroup;
    Edit_Mobile: TEdit;
    Comb_menberlevel: TComboBox;
    Edit_HaveMoney: TEdit;
    Edit_UserNo: TEdit;
    Edit_Prepassword: TEdit;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    Comb_querytype: TComboBox;
    Edit_querycontent: TEdit;
    Bit_Query: TBitBtn;
    Bit_Close: TBitBtn;
    Image1: TImage;
    Bit_Update: TBitBtn;
    procedure comReaderReceiveData(Sender: TObject; Buffer: Pointer;
      BufferLength: Word);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Bitn_ReadNewIDClick(Sender: TObject);
    procedure Bit_CloseClick(Sender: TObject);
    procedure Bit_UpdateClick(Sender: TObject);
    procedure Bit_QueryClick(Sender: TObject);
  private
    { Private declarations }
    function exchData(orderStr: string): string;
    procedure sendData();
    procedure checkOper();
    procedure InitDataBase;
    procedure Saveinto3F_Menberrenewuser;
    procedure Getmenberinfo(S1, S2: string);
  public
    { Public declarations }
  end;

var
  frm_Frontoperate_renewuser: Tfrm_Frontoperate_renewuser;
  curOrderNo: integer = 0;
  curOperNo: integer = 0;
  orderLst, recDataLst: Tstrings;
  buffer: array[0..2048] of byte;
implementation
uses ICDataModule, ICtest_Main, ICCommunalVarUnit, ICmain, ICEventTypeUnit;
{$R *.dfm}


procedure Tfrm_Frontoperate_renewuser.InitDataBase;
var
  strSQL: string;
begin
  with ADOQuery_renewmenber do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select * from [3F_Menber]';
    SQL.Add(strSQL);
    Active := True;
  end;


  with ADOQuery_renewmenberrecord do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select * from [3F_Menberrenewuser]';
    SQL.Add(strSQL);
    Active := True;
  end;

end;


//转找发送数据格式

function Tfrm_Frontoperate_renewuser.exchData(orderStr: string): string;
var
  ii, jj: integer;
  TmpStr: string;
  reTmpStr: string;
begin
  if (length(orderStr) = 0) then
  begin
    MessageBox(handle, '传入参数不能为空!', '错误', MB_ICONERROR + MB_OK);
    result := '';
    exit;
  end;
  if (length(orderStr) mod 2) <> 0 then
  begin
    MessageBox(handle, '传入参数错误!', '错误', MB_ICONERROR + MB_OK);
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

//发送数据过程

procedure Tfrm_Frontoperate_renewuser.sendData();
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

//检查返回的数据

procedure Tfrm_Frontoperate_renewuser.checkOper();
var
  i: integer;
  tmpStr: string;
begin
  case curOperNo of
    0: begin
        for i := 0 to recDataLst.Count - 1 do
          if copy(recDataLst.Strings[i], 3, 2) <> '00' then
          begin
                      //  memComSet.Lines.Add('读卡器连结失败');
                      //  memComSet.Lines.Add('');
            exit;
          end;
              //  memComSet.Lines.Add('读卡器连结成功');
              //  memComSet.Lines.Add('');
      end;
    1: begin
             //   memLowRe.Lines.Add('命令: 寻卡');
        if copy(recDataLst.Strings[0], 3, 2) <> '00' then
                //    memLowRe.Lines.Add('结果: 寻卡失败')
        else begin
                  //  memLowRe.Lines.Add('结果: 寻卡成功');
          if copy(recDataLst.Strings[0], 5, 2) = '04' then
                   //     memLowRe.Lines.Add('该卡片为Mifare one')
          else
                   //     memLowRe.Lines.Add('该卡片为其它类型');
        end;
              //  memLowRe.Lines.Add('');
      end;
    2: begin
                //memLowRe.Lines.Add('命令: 防冲突');
                //  AND (copy(recDataLst.Strings[0],23,2)='4A')
        if (copy(recDataLst.Strings[0], 9, 2) = 'A8') and (copy(recDataLst.Strings[0], 23, 2) = '4A') then
        begin
          tmpStr := copy(recDataLst.Strings[0], 13, 8);
          Edit_newID.Text := tmpStr;
                 //   Getmenberinfo(tmpStr);
          Edit_PrintNONew.Enabled := True;
          Edit_Prepasswordnew.Enabled := True;
          Bit_Update.Enabled := True; //保存更新后的记录
                   // memLowRe.Lines.Add('结果: 防冲突失败')
        end
        else begin
                  //  memLowRe.Lines.Add('结果: 防冲突成功');
          tmpStr := recDataLst.Strings[0];
          tmpStr := copy(tmpStr, 5, length(tmpStr) - 4);
                   // memLowRe.Lines.Add('序号: '+tmpStr);
        end;
                 // memLowRe.Lines.Add('');

      end;
    3: begin
               // memLowRe.Lines.Add('命令: 选择');
        if copy(recDataLst.Strings[0], 3, 2) <> '00' then
                  //  memLowRe.Lines.Add('结果: 选择失败')
        else
                   // memLowRe.Lines.Add('结果: 选择成功');
             //   memLowRe.Lines.Add('');
      end;
    4: begin
               // memLowRe.Lines.Add('命令: 终止');
        if copy(recDataLst.Strings[0], 3, 2) <> '00' then
                 //   memLowRe.Lines.Add('结果: 终止失败')
        else
                  //  memLowRe.Lines.Add('结果: 终止成功');
                //memLowRe.Lines.Add('');
      end;
    5: begin
        for i := 0 to recDataLst.Count - 1 do
          if copy(recDataLst.Strings[i], 3, 2) <> '00' then
          begin
            MessageBox(handle, '密码下载失败', '失败', MB_OK);
            exit;
          end;
        MessageBox(handle, '密码下载成功', '成功', MB_OK);
      end;
    6: begin
        for i := 0 to 3 do
        begin
          if copy(recDataLst.Strings[i + 4], 3, 2) <> '00' then
          begin
                      //  gbRWSector.Caption:=cbRWSec.Text+'读取失败';
            exit;
          end;
        end;
             //   edtBlock0.Text:=copy(recDataLst.Strings[4],5,32);
             //   edtBlock1.Text:=copy(recDataLst.Strings[5],5,32);
            //    edtBlock2.Text:=copy(recDataLst.Strings[6],5,32);
             //   edtBlock3.Text:=copy(recDataLst.Strings[7],5,32);
             //   gbRWSector.Caption:=cbRWSec.Text+'读取成功';
      end;
    7: begin
        for i := 0 to recDataLst.Count - 1 do
          if copy(recDataLst.Strings[i], 3, 2) <> '00' then
          begin
                  //      gbRWSector.Caption:=cbRWSec.Text+'写入失败';
            exit;
          end;
               // gbRWSector.Caption:=cbRWSec.Text+'写入成功';
      end;
    8: begin
        for i := 0 to recDataLst.Count - 1 do
          if copy(recDataLst.Strings[i], 3, 2) <> '00' then
          begin
                   //     MessageBox(handle,'块值初始化失败','失败',MB_OK);
            exit;
          end;
        MessageBox(handle, '块值初始化成功', '成功', MB_OK);
      end;
    9: begin
        for i := 0 to recDataLst.Count - 1 do
          if copy(recDataLst.Strings[i], 3, 2) <> '00' then
          begin
            MessageBox(handle, '块值读取失败', '失败', MB_OK);
            exit;
          end;
               // edtCurValue.Text:=copy(recDataLst.Strings[4],5,8);
        MessageBox(handle, '块值读取成功', '成功', MB_OK);
      end;
    10: begin
        for i := 0 to recDataLst.Count - 1 do
          if copy(recDataLst.Strings[i], 3, 2) <> '00' then
          begin
            MessageBox(handle, '块值加值失败', '失败', MB_OK);
            exit;
          end;
        MessageBox(handle, '块值加值成功', '成功', MB_OK);
      end;
    11: begin
        for i := 0 to recDataLst.Count - 1 do
          if copy(recDataLst.Strings[i], 3, 2) <> '00' then
          begin
            MessageBox(handle, '块值减值失败', '失败', MB_OK);
            exit;
          end;
        MessageBox(handle, '块值减值成功', '成功', MB_OK);
      end;
    12: begin
        for i := 0 to recDataLst.Count - 1 do
          if copy(recDataLst.Strings[i], 3, 2) <> '00' then
          begin
            MessageBox(handle, '密码修改失败', '失败', MB_OK);
            exit;
          end;
        MessageBox(handle, '密码修改成功', '成功', MB_OK);
      end;
  end;
end;

procedure Tfrm_Frontoperate_renewuser.comReaderReceiveData(Sender: TObject;
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

procedure Tfrm_Frontoperate_renewuser.FormShow(Sender: TObject);
begin
     //   Initmenberlevel;
     //EventObj:=EventUnitObj.Create;
     //EventObj.LoadEventIni;
 // InitStringGrid;
 // InitWorkParam;                          //初始化PLC事件定义参数
  InitDataBase; //显示出型号
 // InitEdit;                               //清空Edit框
 // InitDuanXH;                             //初始化型号Combox_Type_JH
 // PageControl_Set.ActivePageIndex:=0;
 // InitUser;
  comReader.StartComm();
  orderLst := TStringList.Create;
  recDataLst := tStringList.Create;
end;

procedure Tfrm_Frontoperate_renewuser.FormClose(Sender: TObject;
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
//查询新卡的ID

procedure Tfrm_Frontoperate_renewuser.Bitn_ReadNewIDClick(Sender: TObject);
begin
  orderLst.Clear();
  recDataLst.Clear();
  curOrderNo := 0;
  curOperNo := 2;
    //orderLst.Add('0103');
    //orderLst.Add('020B0F');
  orderLst.Add('AA8A5F5FA801004A');
  sendData();
end;

  //根据查询选择的不同查询方式，查询个人信息，为补卡操作做准备S1查询类型，S2为查询内容

procedure Tfrm_Frontoperate_renewuser.Getmenberinfo(S1, S2: string);
var
  ADOQ: TADOQuery;
  strSQL: string;
  strsexOrg: string;

begin
  if S1 = '根据用户编号' then
    strSQL := 'select 印刷卡号,用户编号,用户姓名,性别类型,身份证号,用户类型,预留密码,卡押金,手机号码,卡ID,账户余额 from 3F_Menber where [用户编号]=''' + S2 + ''''
  else if S1 = '根据用户手机号' then
    strSQL := 'select 印刷卡号,用户编号,用户姓名,性别类型,身份证号,用户类型,预留密码,卡押金,手机号码,卡ID,账户余额 from 3F_Menber where [手机号码]=''' + S2 + ''''
  else if S1 = '根据用户身份证' then
    strSQL := 'select 印刷卡号,用户编号,用户姓名,性别类型,身份证号,用户类型,预留密码,卡押金,手机号码,卡ID,账户余额 from 3F_Menber where [身份证号]=''' + S2 + ''''
  else
    exit;

  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Open;
    if (not eof) then begin
      Edit_PrintNO.Text := ADOQ.Fields[0].AsString; //印刷卡号
      Edit_UserNo.Text := ADOQ.Fields[1].AsString; //用户编号
      Edit_Username.Text := ADOQ.Fields[2].AsString; // 用户姓名
      strsexOrg := ADOQ.Fields[3].AsString; //性别类型
      if strsexOrg = '男' then
        rgSexOrg.ItemIndex := 0
      else
        rgSexOrg.ItemIndex := 1;

      Edit_Certify.Text := ADOQ.Fields[4].AsString; //身份证号
      Comb_menberlevel.Text := ADOQ.Fields[5].AsString; //用户类型
      Edit_Prepassword.Text := ADOQ.Fields[6].AsString; //预留密码
      Edit_SaveMoney.Text := ADOQ.Fields[7].AsString; //卡押金
      Edit_Mobile.Text := ADOQ.Fields[8].AsString; //手机号码
      Edit_ID.Text := ADOQ.Fields[9].AsString; //原卡ID
      Edit_HaveMoney.Text := ADOQ.Fields[10].AsString; //账户余额
      Bitn_ReadNewID.Enabled := True; //允许进行读卡操作
      Close;
    end
    else
      ShowMessage('无此用户');
  end;

  FreeAndNil(ADOQ);

 // Result:=strRet;
end;


procedure Tfrm_Frontoperate_renewuser.Bit_CloseClick(Sender: TObject);
begin
  Close;
end;


//根据获得的新卡ID和前面查询的个人信息，更新系统里面的ID值

procedure Tfrm_Frontoperate_renewuser.Bit_UpdateClick(Sender: TObject);
var
  strPrintNONew, strNewID, strlevel, strPrepasswordnew: string;
begin
  strlevel := Edit_UserNo.Text; //用户编号
  strNewID := Edit_newID.Text; //新卡ID
  strPrepasswordnew := Edit_Prepasswordnew.Text; //新卡预置密码

  if Edit_PrintNONew.Text = '' then
    ShowMessage('客户输入确认密码错误，请重新输入')
  else begin
    strPrintNONew := Edit_PrintNONew.Text; //新卡印刷卡号

    with ADOQuery_renewmenber do begin
      if (not Locate('用户编号', strlevel, [])) then
        Exit;
      Edit;
      FieldByName('卡ID').AsString := strNewID;
      FieldByName('卡状态').AsString := '在用';
      FieldByName('印刷卡号').AsString := strPrintNONew;
      if Edit_Prepasswordnew.Text <> '' then
        FieldByName('预留密码').AsString := Edit_Prepasswordnew.Text;
      try
        Post;
      except
        on e: Exception do ShowMessage(e.Message);
      end;
    end;


    Saveinto3F_Menberrenewuser; //调用保存补卡记录
    Bit_Update.Enabled := False;
    Edit_PrintNONew.Enabled := False;
    Edit_Prepasswordnew.Enabled := False;
  end;
end;

//补卡操作记录写入 3F_Menberrenewuser

procedure Tfrm_Frontoperate_renewuser.Saveinto3F_Menberrenewuser;

var
  strUserNo, strOldID, strNewID, strOperator, strinputdatetime: string;
  i: integer;
 // label ExitSub;
begin

  strUserNo := Edit_UserNo.Text; //用户编号
  strNewID := Edit_newID.Text; //新卡ID
  strOldID := Edit_ID.Text; //旧卡ID
  strOperator := G_User.UserNO; //操作员
  strinputdatetime := DateTimetostr((now())); //录入时间，读取系统时间

  with ADOQuery_renewmenberrecord do begin
    Append;
    FieldByName('用户编号').AsString := strUserNo;
    FieldByName('操作员').AsString := strOperator;
    FieldByName('原卡ID').AsString := strOldID;
    FieldByName('现卡ID').AsString := strNewID;
    FieldByName('补卡时间').AsString := strinputdatetime;
        //  FieldByName('补卡次数').AsString :=FloatToStr(1+StrToFloat(FieldByName('补卡次数').AsString));;

    try
      Post;
    except
      on e: Exception do ShowMessage(e.Message);
    end;
    //     ExitSub:
   //情况输入框
    for i := 0 to ComponentCount - 1 do
    begin
      if components[i] is TEdit then
      begin
        (components[i] as TEdit).Clear;
      end
    end;
  end;
end;






//查询补卡人员的基础资料

procedure Tfrm_Frontoperate_renewuser.Bit_QueryClick(Sender: TObject);
var
  strquerycontent, strquerytype: string;

begin
  strquerytype := Comb_querytype.Text;
  strquerycontent := Edit_querycontent.Text;
  if Comb_querytype.Text = '' then
    ShowMessage('未选择查询方式，请选择')
  else if Edit_querycontent.Text = '' then
    ShowMessage('未填写查询的内容，请查询方式输入')
  else
    Getmenberinfo(strquerytype, strquerycontent); //查询基础资料

end;

end.
