unit Frontoperate_EBincUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, Grids, DBGrids, StdCtrls, Buttons, ExtCtrls,
  OleCtrls, MSCommLib_TLB, SPComm;

type
  Tfrm_EBInc = class(TForm)
    Panel2: TPanel;
    GroupBox5: TGroupBox;
    Label3: TLabel;
    Label9: TLabel;
    Label1: TLabel;
    Edit_ID: TEdit;
    Edit_PrintNO: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    BitBtn8: TBitBtn;
    BitBtn9: TBitBtn;
    BitBtn10: TBitBtn;
    BitBtn11: TBitBtn;
    BitBtn12: TBitBtn;
    BitBtn13: TBitBtn;
    BitBtn14: TBitBtn;
    BitBtn15: TBitBtn;
    BitBtn16: TBitBtn;
    BitBtn17: TBitBtn;
    BitBtn18: TBitBtn;
    Edit_OPResult: TEdit;
    BitBtn19: TBitBtn;
    Panel1: TPanel;
    DBGrid2: TDBGrid;
    DataSource_Incvalue: TDataSource;
    ADOQuery_Incvalue: TADOQuery;
    DataSource_Newmenber: TDataSource;
    ADOQuery_newmenber: TADOQuery;
    Edit1: TEdit;
    comReader: TComm;
    procedure comReaderReceiveData(Sender: TObject; Buffer: Pointer;
      BufferLength: Word);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_EBInc: Tfrm_EBInc;

implementation
uses ICDataModule,ICCommunalVarUnit, ICEventTypeUnit,ICFunctionUnit;

{$R *.dfm}

procedure Tfrm_EBInc.comReaderReceiveData(Sender: TObject; Buffer: Pointer;
  BufferLength: Word);
var
    ii : integer;
    recStr : string;
    tmpStr : string;
    tmpStrend : string;
begin
   //����----------------
    tmpStrend:= 'STR';
    recStr:='';
    SetLength(tmpStr, BufferLength);
    move(buffer^,pchar(tmpStr)^,BufferLength);
   
    for ii:=1 to BufferLength do
    begin
        recStr:=recStr+intTohex(ord(tmpStr[ii]),2); //���������ת��Ϊ16������

      //  if  (intTohex(ord(tmpStr[ii]),2)='4A') then
      //  begin
      //     tmpStrend:= 'END';
      //  end;
    end;
    Edit1.Text:=recStr;
      //recData_fromICLst.Add(recStr);
    // if  (tmpStrend='END') then
   //  begin
    //     AnswerOper();
    // end;
    //����---------------
   // if curOrderNo<orderLst.Count then    // �ж�ָ���Ƿ��Ѿ���������ϣ����ָ�����С��ָ���������������
   //     sendData()
   // else begin
   //     checkOper();
   // end;

end;

procedure Tfrm_EBInc.FormShow(Sender: TObject);
begin
    comReader.StartComm();
end;

procedure Tfrm_EBInc.FormClose(Sender: TObject; var Action: TCloseAction);
begin
comReader.StopComm();
end;

procedure Tfrm_EBInc.BitBtn1Click(Sender: TObject);
begin
  Edit1.Text:='';
end;

end.
