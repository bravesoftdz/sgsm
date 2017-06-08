unit ICDataModule;

interface

uses
  SysUtils, Classes, DB, ADODB, Dialogs, ICFunctionUnit, ICCommunalVarUnit,
  Windows, Messages, Variants, Graphics, Controls, Forms,
   StdCtrls, ExtCtrls, Spin, Mask, Buttons, ComCtrls; //FileCtrl;//ShellCtrls;

type
  TDataModule_3F = class(TDataModule)
    ADOConnection_Main: TADOConnection;
    ADOConnection1: TADOConnection;
    ADOQuery1: TADOQuery;
    ADOConnection2: TADOConnection;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure DeleteSCWC(xh: string); //ɾ����ǰ����ɼƻ���Ŀ
    procedure SaveCurJHSL(xh: string); //���浱ǰ������ɵ��������Ӽƻ���-1����ɼ�����ɴ���1
    function GetJHCount: string; //����ܵļƻ���
    procedure SaveCurRecord(dxh, lsh: string); //��¼��ǰ��������������ˮ�š�������ʱ��
    procedure SaveErrorGT(dxh: string); //�����쳣����
    procedure SaveWriteDI(dxh, lsh, rq: string); //Ŀǰ����    //�������д�����̺�ļ�¼
    function GetErrorGT: string; //��ô�������
    procedure UpdateErrorGT; //���´���Ļ����
    function QuerystrStationNO(IPStr: string): string; //��ѯIP��վ��
    function Query_ID_OK(LoadID_Infor: string): Boolean;
    function Query_ID_INIT_OK(ID_INIT: string): Boolean;
    function Querystr_Flow_Only(StrFLOW: string): string;
    function Querystr_Core_Only(StrFLOW: string): string;
    function Querystr_CardHeadID_Only(StrCardID: string): string; //��������ƥ�俨ͷID
    function Query3F_CardHeadID_Only(StrCardID: string): string; //3F�������ÿ�ͷID
    function Query3F_CardHeadID_Customer_Name(StrCardID: string): string;
    function Query_User_INIT_OK(ID_INIT: string): Boolean; //���س�ʼ��

    function Query_UserNo(StrUserNo: string): string;
    function Query_MenberNo(StrMemberName: string): string;
    procedure executesql(strsql: string);

  end;

var
  DataModule_3F: TDataModule_3F;
implementation

{$R *.dfm}

 //winxp �������ݿ����ӣ�����ʼ������Դ���ӳ� SQLServer20000

procedure TDataModule_3F.DataModuleCreate(Sender: TObject);
var
  CNameBuffer: PChar;
  fl_loaded: Boolean;
  CLen: ^DWord;
  ComputerName: string;
begin
  ICFunction.InitSystemWorkPath;
  ICFunction.InitSystemWorkground;

  try
    ADOConnection_Main.Connected := False;
    ADOConnection_Main.LoginPrompt := False;

    ADOConnection2.Connected := False;
    ADOConnection2.LoginPrompt := False;


    GetMem(CNameBuffer, 255);
    New(CLen);
    CLen^ := 255;
    fl_loaded := GetComputerName(CNameBuffer, CLen^);
    if fl_loaded then
      ComputerName := StrPas(CNameBuffer) //��ȡ���������SQL Server���ݿ��������
    else
      ComputerName := 'Unkown';  
    if SystemWorkground.DatabaseConnectType = '1' then
    begin

      ADOConnection_Main.ConnectionString := 'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info = False ;Initial Catalog=JLML;Data Source=' + computername;
   
    end
    else if SystemWorkground.DatabaseConnectType = '0' then
    begin
      computername := SystemWorkground.IPAddress; //ʹ��IP��ַ����     
      ADOConnection_Main.ConnectionString := 'Provider=SQLOLEDB.1;Password=2712425;Persist Security Info=False;User ID=SA;Initial Catalog=JLML;Data Source=' + computername;


    end;



    //�������ַ��������¶��Ǳ����
    ADOConnection_Main.Connected := True;
    FreeMem(CNameBuffer, 255);
    Dispose(CLen);


  except
  end;
 //------------

end;


 //�������ݿ����ӣ�����ʼ������Դ���ӳ� SQLServer20005
  {
procedure TDataModule_3F.DataModuleCreate(Sender: TObject);
var
  CNameBuffer: PChar;
  fl_loaded: Boolean;
  CLen: ^DWord;
  ComputerName: string;
  
begin
   GetMem(CNameBuffer, 255);
    New(CLen);
    CLen^ := 255;
    fl_loaded := GetComputerName(CNameBuffer, CLen^);
    if fl_loaded then
      ComputerName := StrPas(CNameBuffer) //��ȡ���������SQL Server���ݿ��������
    else
      ComputerName := 'Unkown';
       
 with ADOConnection_Main do
    begin  
      Connected := False;
      LoginPrompt :=False;
      ConnectionString  := 'Provider=SQLOLEDB.1;Persist Security Info=False;User ID=sa;Initial Catalog=JLML;password =sa;Data Source='+ComputerName + '\SQLEXPRESS';
      try
       ConnectionTimeout := 3;//���ӳ�ʱ�ȴ�ʱ��
       CommandTimeout := 30 ;//ִ�����ʱʱ��  
       Connected:=True;   //����
      except
        ShowMessage('not connected');
        raise;  
        Exit;
      end;  
    end;
end;
}




 //����ܵļƻ���

function TDataModule_3F.GetJHCount: string;
var
  ADOQ: TADOQuery;
  strSQL, strRet: string;
begin
  strRet := '0';
  strSQL := 'select max(���������) from [JNYH_����]';
  ADOQ := TADOQuery.Create(nil);

  with ADOQ do begin
    Connection := ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Open;
    if (not eof) then
      strRet := ADOQ.Fields[0].AsString;
    Close;
  end;
  FreeAndNil(ADOQ);

  Result := strRet;
end;

//���浱ǰ������ɵ��������Ӽƻ���-1����ɼ�����ɴ���1

procedure TDataModule_3F.SaveCurJHSL(xh: string);
var
  ADOQ: TADOQuery;
  strSQL: string;
begin
  strSQL := 'select [���ͺ�],[�ƻ�����],[�����������],[�ܹ��������] from '
    + ' JNYH_�����ƻ� where [���ͺ�]=''' + xh + '''';
  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := ADOConnection_Main;
    Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := true;

    if (RecordCount > 0) then begin

      Edit;
      FieldByName('�ƻ�����').AsInteger := FieldByName('�ƻ�����').AsInteger - 1;
      FieldByName('�����������').AsInteger := FieldByName('�����������').AsInteger + 1;
      FieldByName('�ܹ��������').AsInteger := FieldByName('�ܹ��������').AsInteger + 1;
      Post;
    end
    else begin
      ShowMessage('���ݿ���û�� ' + xh + ' ��¼��ά��');
    end;
    Active := False;
  end;
  FreeAndNil(ADOQ);
end;

procedure TDataModule_3F.DeleteSCWC(xh: string);
var
  ADOQ: TADOQuery;
  strSQL: string;
begin
  strSQL := 'delete  from '
    + ' JNYH_���� where [״̬]=''���''';

  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := ADOConnection_Main;
    ADOQ.Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    ADOQ.ExecSQL;
  end;
  FreeAndNil(ADOQ);
end;
//��¼��ǰ��������������ˮ�š�������ʱ��

procedure TDataModule_3F.SaveCurRecord(dxh, lsh: string);
var
  ADOQ: TADOQuery;
  strSQL: string;
begin
  strSQL := 'select [���ͺ�],[��ˮ��],[����] from '
    + ' JNYH_��ˮ������  ';

  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := ADOConnection_Main;
    Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := true;

    Append;
    FieldByName('���ͺ�').AsString := dxh;
    FieldByName('��ˮ��').AsString := lsh;
    FieldByName('����').AsString := FormatDateTime('yyyy-MM-dd HH:mm:ss', now);
    Post;
    Active := False;
  end;
  FreeAndNil(ADOQ);
end;


//Ŀǰ����    //�������д�����̺�ļ�¼

procedure TDataModule_3F.SaveWriteDI(dxh, lsh, rq: string);
var
  ADOQ: TADOQuery;
  strSQL: string;
begin
  strSQL := 'select [���ͺ�],[��ˮ��],[����] from '
    + ' JNYH_д������ ';
  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := ADOConnection_Main;
    Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := true;

    if (RecordCount > 0) then begin
      Append;
      FieldByName('���ͺ�').AsString := dxh;
      FieldByName('��ˮ��').AsString := lsh;
      FieldByName('����').AsString := rq; //FormatDateTime('yyyy-MM-dd HH:mm:ss',now);
      Post;
    end;
    Active := False;
  end;
  FreeAndNil(ADOQ);
end;

//�����쳣����

procedure TDataModule_3F.SaveErrorGT(dxh: string);
var
  ADOQ: TADOQuery;
  strSQL: string;
begin
  strSQL := 'select [���ͺ�],[���״̬],[����] from '
    + ' JNYH_�쳣����  ';

  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := ADOConnection_Main;
    Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := true;

    Append;
    FieldByName('���ͺ�').AsString := dxh;
    FieldByName('���״̬').AsString := '�ȴ�';
    FieldByName('����').AsString := FormatDateTime('yyyy-MM-dd HH:mm:ss', now);
    Post;
    Active := False;
  end;
  FreeAndNil(ADOQ);
end;


//��ô�������

function TDataModule_3F.GetErrorGT: string;
var
  ADOQ: TADOQuery;
  strSQL, strTemp: string;
begin
  strSQL := 'select [���ͺ�],[���״̬],[����] from '
    + ' JNYH_�쳣���� where ���״̬=''�ȴ�''  order by id asc';
  strTemp := '';
  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := ADOConnection_Main;
    Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := true;

    if (RecordCount > 0) then begin
      //Edit;
      //FieldByName('���״̬').AsString:='���';
      //Post;
      strTemp := FieldByName('���ͺ�').AsString;
    end;
    Active := False;
  end;
  FreeAndNil(ADOQ);
  Result := strTemp;
end;


//���´���Ļ����

procedure TDataModule_3F.UpdateErrorGT;
var
  ADOQ: TADOQuery;
  strSQL, strTemp: string;
begin
  strSQL := 'select [���ͺ�],[���״̬],[����] from '
    + ' JNYH_�쳣���� where ���״̬=''�ȴ�''  order by id asc';
  strTemp := '';
  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := ADOConnection_Main;
    Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := true;

    if (RecordCount > 0) then begin
      Edit;
      FieldByName('���״̬').AsString := '���';
      Post;
      strTemp := FieldByName('���ͺ�').AsString;
    end;
    Active := False;
  end;
  FreeAndNil(ADOQ);
end;

function TDataModule_3F.QuerystrStationNO(IPStr: string): string;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: string;
begin
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select distinct [Station_NO] from [3F_IP_ADD] where IP_Addr=''' + IPStr + '''';
  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    if (RecordCount > 0) then
      reTmpStr := IntToStr(StrToInt(TrimRight(ADOQTemp.Fields[0].AsString)))
    else
      exit;
  end;
  FreeAndNil(ADOQTemp);
  Result := reTmpStr;
end;


//��½ȷ����ݡ��Ϸ���

function TDataModule_3F.Query_ID_OK(LoadID_Infor: string): Boolean;
var
  ADOQ: TADOQuery;
begin
  ADOQ := TADOQuery.Create(Self);
  ADOQ.Connection := DataModule_3F.ADOConnection_Main;

  with ADOQ do begin
    Close;
    SQL.Clear;
    SQL.Add('select * from USER_ID_INIT where ID_INIT=''' + LoadID_Infor + '''');
    Open;
    if (Eof) then
      result := false
    else
      result := true;
  end;
  ADOQ.Close;
  ADOQ.Free;
end;

//ȷ�ϵ�ǰ���Ƿ��Ѿ�����˳�ʼ��

function TDataModule_3F.Query_ID_INIT_OK(ID_INIT: string): Boolean;
var
  ADOQ: TADOQuery;
begin
  ADOQ := TADOQuery.Create(Self);
  ADOQ.Connection := DataModule_3F.ADOConnection_Main;

  with ADOQ do begin
    Close;
    SQL.Clear;
    SQL.Add('select * from [3F_ID_INIT] where ID_INIT=''' + ID_INIT + '''');
    Open;
    if (Eof) then
      result := false
    else
      result := true;
  end;
  ADOQ.Close;
  ADOQ.Free;
end;

 //ȷ�ϵ�ǰ���Ƿ��Ѿ�����˳��س�ʼ��

function TDataModule_3F.Query_User_INIT_OK(ID_INIT: string): Boolean;
var
  ADOQ: TADOQuery;
begin
  ADOQ := TADOQuery.Create(Self);
  ADOQ.Connection := DataModule_3F.ADOConnection_Main;

  with ADOQ do begin
    Close;
    SQL.Clear;
   //20130101�޸�
    SQL.Add('select * from [USER_ID_INIT] where ID_INIT=''' + ID_INIT + '''');
    Open;
    if (Eof) then
      result := false
    else
      result := true;
  end;
  ADOQ.Close;
  ADOQ.Free;
end;

//���ݶ�ȡ������ֵ��ˮ����ѯ���ݿ����Ƿ��Ѿ�����ͬ��¼�����������ʾ

function TDataModule_3F.Querystr_Flow_Only(StrFLOW: string): string;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: string;
begin
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select [FLOWbar] from [3F_BARFLOW] where FLOWbar=''' + StrFLOW + '''';

  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    if (RecordCount > 0) then
      reTmpStr := TrimRight(ADOQTemp.Fields[0].AsString)
    else
    begin
      Result := 'no_record';
                        //exit;
    end;
  end;
  FreeAndNil(ADOQTemp);
  Result := reTmpStr;
end;
//���ݶ�ȡ������ֵ���֣���ѯ���ݿ����Ƿ��Ѿ�����ͬ��¼�����������ʾ

function TDataModule_3F.Querystr_Core_Only(StrFLOW: string): string;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: string;
begin
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select [COREBar] from [3F_BARFLOW] where COREBar=''' + StrFLOW + '''';
  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    if (RecordCount > 0) then
      reTmpStr := TrimRight(ADOQTemp.Fields[0].AsString)
    else
    begin
      Result := 'no_record';
                        //exit;
    end;
  end;
  FreeAndNil(ADOQTemp);
  Result := reTmpStr;
end;



//���ݶ�ȡ������ֵ��ˮ����ѯ���ݿ����Ƿ��Ѿ�����ͬ��¼�����������ʾ

function TDataModule_3F.Querystr_CardHeadID_Only(StrCardID: string): string;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: string;
begin
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select [Card_ID_MC] from [TChargMacSet] where Card_ID_MC=''' + StrCardID + '''';

  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    if (RecordCount > 0) then
      reTmpStr := TrimRight(ADOQTemp.Fields[0].AsString)
    else
    begin
      Result := 'no_record';
                        //exit;
    end;
  end;
  FreeAndNil(ADOQTemp);
  Result := reTmpStr;
end;

//���ݶ�ȡ������ֵ��ˮ����ѯ���ݿ����Ƿ��Ѿ�����ͬ��¼�����������ʾ

function TDataModule_3F.Query3F_CardHeadID_Only(StrCardID: string): string;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: string;
begin
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select [CardHead_ID_IC] from [TCardHead_Init] where CardHead_ID_IC=''' + StrCardID + '''';

  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    if (RecordCount > 0) then
      reTmpStr := TrimRight(ADOQTemp.Fields[0].AsString)
    else
    begin
      Result := 'no_record';
                        //exit;
    end;
  end;
  FreeAndNil(ADOQTemp);
  Result := reTmpStr;
end;

//���ݶ�ȡ������ֵ��ˮ����ѯ���ݿ����Ƿ��Ѿ�����ͬ��¼�����������ʾ

function TDataModule_3F.Query3F_CardHeadID_Customer_Name(StrCardID: string): string;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: string;
begin
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select [Customer_Name],[Customer_NO] from [TCardHead_Init] where CardHead_ID_IC=''' + StrCardID + '''';

  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    if (RecordCount > 0) then
      reTmpStr := '�ͻ�' + TrimRight(ADOQTemp.Fields[0].AsString) + '��' + TrimRight(ADOQTemp.Fields[1].AsString) + '����'
    else
    begin
      Result := 'no_record';
                        //exit;
    end;
  end;
  FreeAndNil(ADOQTemp);
  Result := reTmpStr;
end;

function TDataModule_3F.Query_MenberNo(StrMemberName: string): string;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  strWhere: string;

begin
  ADOQTemp := TADOQuery.Create(nil);
  strWhere := 'select IDCardNo from [TMemberInfo] where MemberName=''' + StrMemberName + '''';

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

function TDataModule_3F.Query_UserNo(StrUserNo: string): string;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
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


procedure TDataModule_3F.executesql(strsql: string);
{
Author: 553
Func:����ִ��DML���
param1:DML Sql���
Date: 20140305
}
begin
  with ADOQuery1 do
  begin
    connection := ADOConnection1;
    Close; //�ر�ADOQuery1���Ա��ڽ���SQL������
    SQL.Clear; //���SQL���
    SQL.Add(strsql); //����µ�SQL
    //debug info
    //showmessage(strsql);
    Prepared;
    ExecSQL; //execsqlִ��DML���

  end;

end;





end.
