unit RegUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, IniFiles,
  Dialogs, StdCtrls, Buttons;

type
  Tfrm_Reg = class(TForm)
    Label3: TLabel;
    Edit_Reg: TEdit;
    BitBtn_Reg: TBitBtn;
    procedure Edit_RegKeyPress(Sender: TObject; var Key: Char);
    procedure BitBtn_RegClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_Reg: Tfrm_Reg;

implementation
uses ICDataModule, ICCommunalVarUnit, ICFunctionUnit, ICmain, Frontoperate_EBincvalueUnit, ICEventTypeUnit;

{$R *.dfm}

procedure Tfrm_Reg.Edit_RegKeyPress(Sender: TObject; var Key: Char);
begin
  if not (key in ['0'..'9', 'A'..'Z', #8, #13]) then
  begin
    key := #0;
    ShowMessage('�������ֻ���������ֺʹ�д��ĸ��');
  end;
end;

procedure Tfrm_Reg.BitBtn_RegClick(Sender: TObject);
var
  RegTimes, ErrTotalTimes, ErrTimes: string;
  myIni: TiniFile;

begin
  if length(Edit_Reg.Text) <> 12 then
  begin
    showmessage('���ݳ��Ȳ�����12');
    exit;
  end;


  if FileExists(SystemWorkGroundFile) then
  begin

    myIni := TIniFile.Create(SystemWorkGroundFile);

    RegTimes := MyIni.ReadString('PLC��������', 'PC��Ӧ������', ''); //
    ErrTotalTimes := MyIni.ReadString('DB����', '��������ʱ��', ''); //
    ErrTimes := Copy(ErrTotalTimes, 9, 1);
    if Copy(ErrTotalTimes, 9, 1) = '4' then
    begin
      MessageBox(handle, '�����ۼ����δ�����Ϊ��Ķ��������ϵͳ�Ѿ������ϣ�', '����', MB_ICONERROR + MB_OK);
      exit;
    end;
    if RegTimes <> 'D6102' then
    begin
      if (Copy(TrimRight(Edit_Reg.Text), 1, 1) = '0') or (Copy(TrimRight(Edit_Reg.Text), 2, 1) = '0') or (Copy(TrimRight(Edit_Reg.Text), 6, 1) = '0') then
      begin

        if ErrTimes = '1' then
        begin
          myIni.WriteString('DB����', '��������ʱ��', Copy(ErrTotalTimes, 1, 8) + '2'); //д���µĵ�½����

        end
        else if ErrTimes = '2' then
        begin
          myIni.WriteString('DB����', '��������ʱ��', Copy(ErrTotalTimes, 1, 8) + '3'); //д���µĵ�½����

        end
        else if ErrTimes = '3' then
        begin
          myIni.WriteString('DB����', '��������ʱ��', Copy(ErrTotalTimes, 1, 8) + '4'); //д���µĵ�½����

        end;
        MessageBox(handle, '�����ۼ����δ����ϵͳ�޷��ٴ�����,���и���!', '����', MB_ICONERROR + MB_OK);
        Exit;
      end;


      if (Copy(TrimRight(Edit_Reg.Text), 1, 1) = Copy(TrimRight(Edit_Reg.Text), 2, 1)) and (Copy(TrimRight(Edit_Reg.Text), 3, 1) = Copy(TrimRight(Edit_Reg.Text), 2, 1)) and (Copy(TrimRight(Edit_Reg.Text), 4, 1) = Copy(TrimRight(Edit_Reg.Text), 2, 1)) then
      begin
        if ErrTimes = '1' then
        begin
          myIni.WriteString('DB����', '��������ʱ��', Copy(ErrTotalTimes, 1, 8) + '2'); //д���µĵ�½����

        end
        else if ErrTimes = '2' then
        begin
          myIni.WriteString('DB����', '��������ʱ��', Copy(ErrTotalTimes, 1, 8) + '3'); //д���µĵ�½����

        end
        else if ErrTimes = '3' then
        begin
          myIni.WriteString('DB����', '��������ʱ��', Copy(ErrTotalTimes, 1, 8) + '4'); //д���µĵ�½����

        end;
        MessageBox(handle, '�����ۼ����δ����ϵͳ�޷��ٴ�����,���и���!', '����', MB_ICONERROR + MB_OK);
        Exit;
      end;
      if (TrimRight(Edit_Reg.Text) <> RegTimes) and (StrToInt(Copy(TrimRight(Edit_Reg.Text), 1, 1)) = 2 * StrToInt(Copy(TrimRight(Edit_Reg.Text), 4, 1))) and (StrToInt(Copy(TrimRight(Edit_Reg.Text), 2, 1)) = 3 * StrToInt(Copy(TrimRight(Edit_Reg.Text), 6, 1))) then
      begin
        myIni.WriteString('PLC��������', 'PC��Ӧ������', TrimRight(Edit_Reg.Text)); //д���µĵ�½ע�����
        SystemWorkground.PLCRequestWriteTP := 'D6004';
        myIni.WriteString('PLC��������', 'PLC����д����', SystemWorkground.PLCRequestWriteTP); //д���µĵ�½����

      end
      else
      begin
        if StrToInt(RegTimes) < 3 then
        begin
          myIni.WriteString('PLC��������', 'PC��Ӧ������', IntToStr(StrToInt(RegTimes) + 1)); //д���µĵ�½ע�����
          SystemWorkground.PLCRequestWriteTP := 'D6004';
          myIni.WriteString('PLC��������', 'PLC����д����', SystemWorkground.PLCRequestWriteTP); //д���µĵ�½����
        end
        else
        begin
          Edit_Reg.Text := '��ע�ᣡ';
        end;
      end;
    end
    else
    begin
      if (Copy(TrimRight(Edit_Reg.Text), 1, 1) = '0') or (Copy(TrimRight(Edit_Reg.Text), 2, 1) = '0') or (Copy(TrimRight(Edit_Reg.Text), 6, 1) = '0') then
      begin

        if ErrTimes = '1' then
        begin
          myIni.WriteString('DB����', '��������ʱ��', Copy(ErrTotalTimes, 1, 8) + '2'); //д���µĵ�½����

        end
        else if ErrTimes = '2' then
        begin
          myIni.WriteString('DB����', '��������ʱ��', Copy(ErrTotalTimes, 1, 8) + '3'); //д���µĵ�½����

        end
        else if ErrTimes = '3' then
        begin
          myIni.WriteString('DB����', '��������ʱ��', Copy(ErrTotalTimes, 1, 8) + '4'); //д���µĵ�½����

        end;
        MessageBox(handle, '�����ۼ����δ����ϵͳ�޷��ٴ�����,���и���!', '����', MB_ICONERROR + MB_OK);
        Exit;
      end;


      if (Copy(TrimRight(Edit_Reg.Text), 1, 1) = Copy(TrimRight(Edit_Reg.Text), 2, 1)) and (Copy(TrimRight(Edit_Reg.Text), 3, 1) = Copy(TrimRight(Edit_Reg.Text), 2, 1)) and (Copy(TrimRight(Edit_Reg.Text), 4, 1) = Copy(TrimRight(Edit_Reg.Text), 2, 1)) then
      begin
        if ErrTimes = '1' then
        begin
          myIni.WriteString('DB����', '��������ʱ��', Copy(ErrTotalTimes, 1, 8) + '2'); //д���µĵ�½����

        end
        else if ErrTimes = '2' then
        begin
          myIni.WriteString('DB����', '��������ʱ��', Copy(ErrTotalTimes, 1, 8) + '3'); //д���µĵ�½����

        end
        else if ErrTimes = '3' then
        begin
          myIni.WriteString('DB����', '��������ʱ��', Copy(ErrTotalTimes, 1, 8) + '4'); //д���µĵ�½����

        end;
        MessageBox(handle, '�����ۼ����δ����ϵͳ�޷��ٴ�����,���и���!', '����', MB_ICONERROR + MB_OK);
        Exit;
      end;
      if (TrimRight(Edit_Reg.Text) <> RegTimes) and (StrToInt(Copy(TrimRight(Edit_Reg.Text), 1, 1)) = 2 * StrToInt(Copy(TrimRight(Edit_Reg.Text), 4, 1))) and (StrToInt(Copy(TrimRight(Edit_Reg.Text), 2, 1)) = 3 * StrToInt(Copy(TrimRight(Edit_Reg.Text), 6, 1))) then
      begin
        myIni.WriteString('PLC��������', 'PC��Ӧ������', TrimRight(Edit_Reg.Text)); //д���µĵ�½ע�����
        SystemWorkground.PLCRequestWriteTP := 'D6004';
        myIni.WriteString('PLC��������', 'PLC����д����', SystemWorkground.PLCRequestWriteTP); //д���µĵ�½����
      end
    end;

    FreeAndNil(myIni);
  end;

end;



procedure Tfrm_Reg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
end;

end.