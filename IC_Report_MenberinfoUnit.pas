unit IC_Report_MenberinfoUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBGridEhGrouping, GridsEh, DBGridEh, Grids, DBGrids, StdCtrls,
  Buttons, ComCtrls, ExtCtrls, DB, ADODB, RpCon, RpConDS, RpRenderPreview,
  RpBase, RpSystem, RpRave, RpDefine, RpRender, RpRenderCanvas,
  RpRenderPrinter, RpFiler;

type
  Tfrm_IC_Report_Menberinfo = class(TForm)
    pgcMachinerecord: TPageControl;
    tbsConfig: TTabSheet;
    Panel2: TPanel;
    Panel9: TPanel;
    Label2: TLabel;
    DateTimePicker_Start_Menberinfo: TDateTimePicker;
    DateTimePicker_End_Menberinfo: TDateTimePicker;
    ComboBox_Operator_Menberinfo: TComboBox;
    ComboBox_other_Menberinfo: TComboBox;
    Edit_other_Menberinfo: TEdit;
    TimePicker_Start_Menberinfo: TDateTimePicker;
    TimePicker_End_Menberinfo: TDateTimePicker;
    Panel10: TPanel;
    Bit_Print_Menberinfo: TBitBtn;
    Bit_Close_Menberinfo: TBitBtn;
    Bit_Query_Menberinfo: TBitBtn;
    Panel3: TPanel;
    Tab_Gamenameinput: TTabSheet;
    Panel8: TPanel;
    Panel1: TPanel;
    Panel4: TPanel;
    Label1: TLabel;
    DateTimePicker_Start_Recard: TDateTimePicker;
    DateTimePicker_End_Recard: TDateTimePicker;
    ComboBox_Operator_Recard: TComboBox;
    ComboBox_other_Recard: TComboBox;
    Edit_other_Recard: TEdit;
    TimePicker_Start_Recard: TDateTimePicker;
    TimePicker_End_Recard: TDateTimePicker;
    Panel5: TPanel;
    Bit_Print_Recard: TBitBtn;
    Bit_Close_Recard: TBitBtn;
    Bit_Query_Recard: TBitBtn;
    DBGridEh_Recard: TDBGridEh;
    RvRenderPrinter_MenberinfoPrint: TRvRenderPrinter;
    RvPro_MenberinfoPrint: TRvProject;
    RvSystem_MenberinfoPrint: TRvSystem;
    RvRenderPreview_MenberinfoPrint: TRvRenderPreview;
    RvDataSetConnection_MenberinfoPrint: TRvDataSetConnection;
    DataSource_Menberinfo: TDataSource;
    ADOQuery_Menberinfo: TADOQuery;
    DBGridEh_Menberinfo: TDBGridEh;
    RvPro_RecardinfoPrint: TRvProject;
    RvSystem_RecardinfoPrint: TRvSystem;
    RvRenderPreview_RecardinfoPrint: TRvRenderPreview;
    RvDataSetConnection_RecardinfoPrint: TRvDataSetConnection;
    RvRenderPrinter_RecardinfoPrint: TRvRenderPrinter;
    ADOQuery_Coperationinfo: TADOQuery;
    DataSource_Coperationinfo: TDataSource;
    DataSource_RecardinfoPrint: TDataSource;
    ADOQuery_RecardinfoPrint: TADOQuery;
    RvRenderPrinter_Coperationinfo: TRvRenderPrinter;
    RvProject_Coperationinfo: TRvProject;
    RvSystem_Coperationinfo: TRvSystem;
    RvRenderPreview_Coperationinfo: TRvRenderPreview;
    RvDataSetConnection_Coperationinfo: TRvDataSetConnection;
    RvNDRWriter1: TRvNDRWriter;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    ComboBox_Cardstate_Menberinfo: TComboBox;
    Label9: TLabel;
    DataSource1: TDataSource;
    ADOQuery_TIsable: TADOQuery;
    DataSource2: TDataSource;
    ADOQuery_TOperator: TADOQuery;
    procedure FormCreate(Sender: TObject);
    procedure Bit_Print_MenberinfoClick(Sender: TObject);
    procedure Bit_Close_MenberinfoClick(Sender: TObject);
    procedure Bit_Close_RecardClick(Sender: TObject);
    procedure Bit_Query_MenberinfoClick(Sender: TObject);
    procedure Bit_Query_RecardClick(Sender: TObject);
    procedure Bit_Print_RecardClick(Sender: TObject);
  private
    { Private declarations }
    procedure InitDataBase;
    function SetWhere: string;
    function Query_Cardstate(S1: string): string;
    function Query_Operater(S1: string): string;
  public
    { Public declarations }
  end;

var
  frm_IC_Report_Menberinfo: Tfrm_IC_Report_Menberinfo;

implementation
uses ICDataModule, ICCommunalVarUnit, ICmain, ICEventTypeUnit;
{$R *.dfm}

procedure Tfrm_IC_Report_Menberinfo.InitDataBase;
var
  strSQL: string;
begin
  //��ѯ��˾�趨��Ϣ
  with ADOQuery_Coperationinfo do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select * from [TReg]';
    SQL.Add(strSQL);
    Active := True;
  end;

  //��ѯ����Ա�趨��Ϣ

  with ADOQuery_TOperator do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select * from [TOperator]';
    SQL.Add(strSQL);
    Active := True;
    ComboBox_Operator_Menberinfo.Items.Clear;
    ComboBox_Operator_Recard.Items.Clear;
    ComboBox_Operator_Menberinfo.Items.Add('ȫ��');
    ComboBox_Operator_Recard.Items.Add('ȫ��');
    while not Eof do begin
      ComboBox_Operator_Menberinfo.Items.Add(TrimRight(FieldByName('cUserName').AsString));
      ComboBox_Operator_Recard.Items.Add(TrimRight(FieldByName('cUserName').AsString));

      Next;
    end;
  end;

  //��ѯ��״̬�趨��Ϣ
  with ADOQuery_TIsable do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select * from [TIsable]';
    SQL.Add(strSQL);
    Active := True;
    ComboBox_Cardstate_Menberinfo.Items.Clear;
    ComboBox_Cardstate_Menberinfo.Items.Add('ȫ��');
    while not Eof do begin
      ComboBox_Cardstate_Menberinfo.Items.Add(TrimRight(FieldByName('IsableName').AsString));
      Next;
    end;
  end;

end;


procedure Tfrm_IC_Report_Menberinfo.FormCreate(Sender: TObject);
begin
  InitDataBase;
end;

procedure Tfrm_IC_Report_Menberinfo.Bit_Print_MenberinfoClick(
  Sender: TObject);
begin
 //     RvPro_MenberinfoPrintprojman.findreport(report_name).print=getPrint('СƱ��ӡ')
 //     RvNDRWriter1.pri
  RvPro_MenberinfoPrint.Execute; //���� RvPro_MenberinfoPrint.ExecuteReport('Report1');
end;

procedure Tfrm_IC_Report_Menberinfo.Bit_Close_MenberinfoClick(
  Sender: TObject);
begin
  close;
end;

procedure Tfrm_IC_Report_Menberinfo.Bit_Close_RecardClick(Sender: TObject);
begin
  close;
end;

//��ѯ�û�����ؼ�¼��������Ϣ����ֵ�����ּ�¼�ȣ�

procedure Tfrm_IC_Report_Menberinfo.Bit_Query_MenberinfoClick(
  Sender: TObject);
var
  strSQL: string;
  LastRecord: string;
  strWhere: string;
  strStartDate, strEndDate, strIsable, strcUserNo: string;
begin

  LastRecord := '1'; //���¼�¼��־λ

  strWhere := '';



  strWhere := strWhere + 'select TMemberInfo.*,[TotalMoney],[TickCount],[LevName],[IsableName],[SexName],[cUserName]';
  strWhere := strWhere + 'from TMemberInfo,TMembeDetail,TSex,TIsable,TLevel,TOperator ';
  strWhere := strWhere + 'where TMembeDetail.MemCardNo=TMemberInfo.MemCardNo ';
  strWhere := strWhere + 'and TMemberInfo.Sex=TSex.SexNO ';
  strWhere := strWhere + 'and TMemberInfo.IsAble=TIsable.IsableNO ';
  strWhere := strWhere + 'and TMemberInfo.LevNum= TLevel.LevNo ';
  strWhere := strWhere + 'and TMemberInfo.cUserNo= TOperator.cUserNo ';
  strWhere := strWhere + 'and TMembeDetail.LastRecord=''' + LastRecord + ''' ';


        //����һ
  strStartDate := FormatDateTime('yyyy-MM-dd', DateTimePicker_Start_Menberinfo.Date) + ' ' + FormatDateTime('hh:mm:ss', TimePicker_Start_Menberinfo.Time);
  strEndDate := FormatDateTime('yyyy-MM-dd', DateTimePicker_End_Menberinfo.Date) + ' ' + FormatDateTime('hh:mm:ss', TimePicker_End_Menberinfo.Time);


  strWhere := strWhere + 'and (TMemberInfo.OpenCardDT>=''' + strStartDate
    + ''' and TMemberInfo.OpenCardDT<=''' + strEndDate + ''')';

      //������
  if ComboBox_Operator_Menberinfo.Text <> 'ȫ��' then
  begin
    strcUserNo := Query_Operater('''+TrimRight(ComboBox_Operator_Menberinfo.Text)+''');
    strWhere := strWhere + ' and TMemberInfo.cUserNo=''' + strcUserNo + '''';
  end;

     //������
  if ComboBox_Cardstate_Menberinfo.Text <> 'ȫ��' then
  begin
    strIsable := Query_Cardstate('''+TrimRight(ComboBox_Cardstate_Menberinfo.Text)+''');
    strWhere := strWhere + ' and TMemberInfo.Isable=''' + strIsable + '''';
  end;

    //������
  if ComboBox_other_Menberinfo.Text <> 'ȫ��' then
  begin
    strWhere := strWhere + 'and (TMemberInfo.MemberName=''' + Edit_other_Menberinfo.Text + '''';
    strWhere := strWhere + ' or ';
    strWhere := strWhere + ' TMemberInfo.MemCardNo=''' + Edit_other_Menberinfo.Text + ''')';
  end;

  strSQL := '' + strWhere + '';

  with ADOQuery_Menberinfo do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;

  end;
end;

 //��ѯ��״̬����

function Tfrm_IC_Report_Menberinfo.Query_Cardstate(S1: string): string;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  temp: string;
  temp_levelno: string;
begin

  ADOQTemp := TADOQuery.Create(nil);
  with ADOQTemp do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select IsableNO from [TIsable] where  IsableName=''' + S1 + '''';
    SQL.Add(strSQL);
    Open;
    if (RecordCount > 0) then
      temp_levelno := ADOQTemp.Fields[0].AsString;
    Close;
  end;
  FreeAndNil(ADOQTemp);
  result := temp_levelno;

end;


 //��ѯ����Ա����

function Tfrm_IC_Report_Menberinfo.Query_Operater(S1: string): string;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  temp: string;
  temp_levelno: string;
begin

  ADOQTemp := TADOQuery.Create(nil);
  with ADOQTemp do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select cUserNo from [TOperator] where  cUserName=''' + S1 + '''';
    SQL.Add(strSQL);
    Open;
    if (RecordCount > 0) then
      temp_levelno := ADOQTemp.Fields[0].AsString;
    Close;
  end;
  FreeAndNil(ADOQTemp);
  result := temp_levelno;
end;

//�����û����

function Tfrm_IC_Report_Menberinfo.SetWhere: string;
var
  strWhere: string;
  strIsable: string; //��״̬
  strStartDate, strEndDate: string;

begin
  strWhere := '';
  strWhere := strWhere + 'AND TMemberInfo.Sex=TSex.SexNO ';
  strWhere := strWhere + 'AND TMemberInfo.IsAble=TIsable.IsableNO ';
  strWhere := strWhere + 'AND TMemberInfo.LevNum= TLevel.LevNo ';
  strWhere := strWhere + 'AND TMemberInfo.IsAble=TIsable.IsableNO ';
  strWhere := ' where ' + strWhere;

  Result := strWhere;
end;



procedure Tfrm_IC_Report_Menberinfo.Bit_Query_RecardClick(Sender: TObject);
var
  strSQL: string;
  LastRecord: string;
  strWhere: string;
  strStartDate, strEndDate, strIsable, strcUserNo: string;
begin

  LastRecord := '1'; //���¼�¼��־λ

  strWhere := '';

  strWhere := strWhere + 'select TMemberInfo.*,[IsableName],[SexName],[cUserName],[OldCardNo],[GetTime]';
  strWhere := strWhere + 'from TMemberInfo,TSex,TIsable,TOperator,TReCard ';
  strWhere := strWhere + 'where TReCard.OldCardNo=TMemberInfo.IDCardNo ';
  strWhere := strWhere + 'and TMemberInfo.Sex=TSex.SexNO ';
  strWhere := strWhere + 'and TMemberInfo.IsAble=TIsable.IsableNO ';
  strWhere := strWhere + 'and TMemberInfo.cUserNo= TOperator.cUserNo ';

    //����һ
  strStartDate := FormatDateTime('yyyy-MM-dd', DateTimePicker_Start_Recard.Date) + ' ' + FormatDateTime('hh:mm:ss', TimePicker_Start_Recard.Time);
  strEndDate := FormatDateTime('yyyy-MM-dd', DateTimePicker_End_Recard.Date) + ' ' + FormatDateTime('hh:mm:ss', TimePicker_End_Recard.Time);


  strWhere := strWhere + 'and (TMemberInfo.OpenCardDT>=''' + strStartDate
    + ''' and TMemberInfo.OpenCardDT<=''' + strEndDate + ''')';

      //������
  if ComboBox_Operator_Menberinfo.Text <> 'ȫ��' then
  begin
    strcUserNo := Query_Operater('''+TrimRight(ComboBox_Operator_Recard.Text)+''');
    strWhere := strWhere + ' and TMemberInfo.cUserNo=''' + strcUserNo + '''';
  end;

    //������
  if ComboBox_other_Menberinfo.Text <> 'ȫ��' then
  begin
    strWhere := strWhere + 'and (TMemberInfo.MemberName=''' + Edit_other_Recard.Text + '''';
    strWhere := strWhere + ' or ';
    strWhere := strWhere + ' TMemberInfo.MemCardNo=''' + Edit_other_Recard.Text + ''')';
  end;

  strSQL := '' + strWhere + '';

  with ADOQuery_RecardinfoPrint do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;

  end;
end;

procedure Tfrm_IC_Report_Menberinfo.Bit_Print_RecardClick(Sender: TObject);
begin
  RvPro_RecardinfoPrint.Execute;
end;

end.
