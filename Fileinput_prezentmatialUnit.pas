unit Fileinput_prezentmatialUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, DBGrids, ExtCtrls, DateUtils, DB, ADODB;

type
  Tfrm_Fileinput_prezentmatial = class(TForm)
    Panel1: TPanel;
    DBGrid1: TDBGrid;
    Panel4: TPanel;
    Edit_NO: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Edit_Name: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Edit_Count: TEdit;
    Edit_Tickcount: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    Edit_Picprice: TEdit;
    ComboBox_Unit: TComboBox;
    Label7: TLabel;
    Memo_Remark: TMemo;
    Bit_Add: TBitBtn;
    Bit_Update: TBitBtn;
    Bit_Delete: TBitBtn;
    Bit_Close: TBitBtn;
    DataSource_Giftsinfor: TDataSource;
    ADOQuery_Giftsinfor: TADOQuery;
    procedure FormCreate(Sender: TObject);
    procedure Bit_DeleteClick(Sender: TObject);
    procedure Bit_AddClick(Sender: TObject);
    procedure Bit_CloseClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure Bit_UpdateClick(Sender: TObject);
  private
    { Private declarations }
    procedure InitDataBase;
  public
    { Public declarations }
  end;

var
  frm_Fileinput_prezentmatial: Tfrm_Fileinput_prezentmatial;

implementation
uses ICDataModule, ICCommunalVarUnit, ICmain, ICEventTypeUnit,
  Fileinput_menberforUnit;
{$R *.dfm}

procedure Tfrm_Fileinput_prezentmatial.InitDataBase;
var
  strSQL: string;
begin
    //��Ա�ȼ��ײ�
  with ADOQuery_Giftsinfor do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select * from [TGiftsInfo]';
    SQL.Add(strSQL);
    Active := True;
  end;

end;

//���Ӽ�¼

procedure Tfrm_Fileinput_prezentmatial.Bit_AddClick(Sender: TObject);

var
  str1, str2, str3, str4, str5, str6, str7, strOperator, strtime, strRemark: string;
label ExitSub;
begin
  str1 := Edit_NO.Text;
  str2 := Edit_Name.Text;
  str3 := Edit_Count.Text;
  str4 := Edit_Tickcount.Text;
  str5 := ComboBox_Unit.Text;
  str6 := Edit_Picprice.Text;
  strOperator := G_User.UserNO;
  strtime := DateTimetostr((now()));
  strRemark := Memo_Remark.Text;


  if str1 = '' then
  begin
    ShowMessage('��Ʒ��Ų��ܿ�');
    exit;
  end
  else if str2 = '' then
  begin
    ShowMessage('��Ʒ���Ʋ��ܿ�');
    exit;
  end
  else if str3 = '' then
  begin
    ShowMessage('����������ܿ�');
    exit;
  end
  else if str4 = '' then
  begin
    ShowMessage('�Ҳ�Ʊ�����ܿ�');
    exit;
  end
  else if str5 = '' then
  begin
    ShowMessage('��λ���ܿ�');
    exit;
  end
  else if str6 = '' then
  begin
    ShowMessage('���۲��ܿ�');
    exit;
  end
  else begin
    with ADOQuery_Giftsinfor do begin
      if (Locate('GF_No', str1, [])) then begin
        if (MessageDlg('�Ѿ�����  ' + str1 + '  Ҫ������', mtInformation, [mbYes, mbNo], 0) = mrYes) then
          Edit
        else
          goto ExitSub;
      end
      else
        Append;
      FieldByName('GF_No').AsString := str1;
      FieldByName('GF_Name').AsString := str2;
      FieldByName('GiftsCount').AsString := str3;
      FieldByName('TickCount').AsString := str4;
      FieldByName('Unit').AsString := str5;
      FieldByName('GiftFee').AsString := str6;
      FieldByName('cUserNo').AsString := strOperator;
      FieldByName('GetTime').AsString := strtime;
      FieldByName('Remark').AsString := strRemark;
      try
        Post;
      except
        on e: Exception do ShowMessage(e.Message);
      end;
    end;
    ExitSub:
    Edit_NO.Text := '';
    Edit_Name.Text := '';
    Edit_Count.Text := '';
    Edit_Tickcount.Text := '';
    ComboBox_Unit.Text := '';
    Edit_Picprice.Text := '';
    Memo_Remark.Text := '';
  end;
end;

//�ر�

procedure Tfrm_Fileinput_prezentmatial.Bit_CloseClick(Sender: TObject);
begin
  Close;
end;

//ɾ��

procedure Tfrm_Fileinput_prezentmatial.Bit_DeleteClick(Sender: TObject);
var
  strTemp: string;
begin
  strTemp := ADOQuery_Giftsinfor.FieldByName('GF_No').AsString;
  if (MessageDlg('ȷʵҪɾ����Ʒ���Ϊ' + strTemp + ' ����ؼ�¼��?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
    DBGrid1.DataSource.DataSet.Delete;
end;

//����

procedure Tfrm_Fileinput_prezentmatial.FormCreate(Sender: TObject);
begin
  InitDataBase; //��ʾ���ͺ�
end;

//˫����¼��������²�

procedure Tfrm_Fileinput_prezentmatial.DBGrid1DblClick(Sender: TObject);
begin
  Edit_NO.Enabled := false;
  Edit_Name.Enabled := false;
  Edit_Tickcount.Enabled := false;
  ComboBox_Unit.Enabled := false;
  Edit_Picprice.Enabled := false;
  Memo_Remark.Enabled := false;
  Edit_NO.Text := DBGrid1.DataSource.DataSet.FieldByName('GF_No').AsString;
  Edit_Name.Text := DBGrid1.DataSource.DataSet.FieldByName('GF_Name').AsString;
  Edit_Count.Text := DBGrid1.DataSource.DataSet.FieldByName('GiftsCount').AsString;
  Edit_Tickcount.Text := DBGrid1.DataSource.DataSet.FieldByName('TickCount').AsString;
  ComboBox_Unit.Text := DBGrid1.DataSource.DataSet.FieldByName('Unit').AsString;
  Edit_Picprice.Text := DBGrid1.DataSource.DataSet.FieldByName('GiftFee').AsString;
  Memo_Remark.Text := DBGrid1.DataSource.DataSet.FieldByName('Remark').AsString;
  Bit_Update.Enabled := True;
end;

procedure Tfrm_Fileinput_prezentmatial.Bit_UpdateClick(Sender: TObject);
var
  str1, str2, str3, str4, str5, str6, str7, strOperator, strtime, strRemark: string;
label ExitSub;
begin
  str1 := Edit_NO.Text;
  str2 := Edit_Name.Text;
  str3 := Edit_Count.Text;
  str4 := Edit_Tickcount.Text;
  str5 := ComboBox_Unit.Text;
  str6 := Edit_Picprice.Text;
  strOperator := G_User.UserNO;
  strtime := DateTimetostr((now()));
  strRemark := Memo_Remark.Text;


  if str1 = '' then
  begin
    ShowMessage('��Ʒ��Ų��ܿ�');
    exit;
  end
  else if str2 = '' then
  begin
    ShowMessage('��Ʒ���Ʋ��ܿ�');
    exit;
  end
  else if str3 = '' then
  begin
    ShowMessage('����������ܿ�');
    exit;
  end
  else if str4 = '' then
  begin
    ShowMessage('�Ҳ�Ʊ�����ܿ�');
    exit;
  end
  else if str5 = '' then
  begin
    ShowMessage('��λ���ܿ�');
    exit;
  end
  else if str6 = '' then
  begin
    ShowMessage('���۲��ܿ�');
    exit;
  end
  else if strRemark = '' then
  begin
    ShowMessage('��ע���ܿ�');
    exit;
  end
  else
  begin
    with ADOQuery_Giftsinfor do begin
      if (not Locate('GF_No', str1, [])) then
        Exit;
      Edit;
      FieldByName('GF_No').AsString := str1;
      FieldByName('GF_Name').AsString := str2;
      FieldByName('GiftsCount').AsString := str3;
      FieldByName('TickCount').AsString := str4;
      FieldByName('Unit').AsString := str5;
      FieldByName('GiftFee').AsString := str6;
      FieldByName('cUserNo').AsString := strOperator;
      FieldByName('GetTime').AsString := strtime;
      FieldByName('Remark').AsString := strRemark;
      try
        Post;
      except
        on e: Exception do ShowMessage(e.Message);
      end;
    end;
  end;

  Edit_NO.Text := '';
  Edit_Name.Text := '';
  Edit_Count.Text := '';
  Edit_Tickcount.Text := '';
  ComboBox_Unit.Text := '';
  Edit_Picprice.Text := '';
  Memo_Remark.Text := '';
  Edit_NO.Enabled := True;
  Edit_Name.Enabled := True;
  Edit_Tickcount.Enabled := True;
  ComboBox_Unit.Enabled := True;
  Edit_Picprice.Enabled := True;
  Memo_Remark.Enabled := True;
  Bit_Update.Enabled := false;


end;

end.
