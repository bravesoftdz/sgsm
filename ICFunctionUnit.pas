unit ICFunctionUnit;

interface
uses Forms, Windows, SysUtils, Registry, Classes, Math, IniFiles, StdCtrls, StrUtils;

type
  TICFunction = class
    procedure InitSystemWorkPath;
    procedure InitSystemWorkground;

    function TransStringToFloat(S: string): Real;
    function TransStringToInteger(S: string): Integer;
    function TranslateMeasureDataToValue(Chal: TPoint; V: Real): Real;

    procedure SaveSystemGroundMessageTerm(TermName, FieldName, Value: string);
    function IsCheckOverTime(ST: TLargeInteger; CK: integer): Boolean;
    procedure DelayForHeighFreq(WT: integer);
    function CheckTextIsNumber(S: string): Boolean;
    //procedure GetUnitMessageForName(var Eu:PLC_UnitType; UName: string);
    function ValIsNumber(Strv: string): Boolean;
    procedure SaveSystemParameterTerm(Term, SubTerm, Value: string);
    procedure AddShowItemToMemo(Memo: TMemo; strItem: string);
    procedure DeleteChr(strv: string);
    function BintoInt(Value: string): LongInt;
  //  function AscToDec(strValue: String): Array of integer ;
    function IntToBin(Value: LongInt; Size: Integer): string;
    function Str_IntToBin(Int: LongInt; Size: Integer): string;
    function Str_HexToInt(Hex: string): integer;
    function Str_StrToChar(Str: string): Char;
    procedure ClearIDinfor;
    function SUANFA_ID_3F(StrCheckSum: string): string;
    function SUANFA_Password_3F(StrCheckSum: string): string;
    procedure INITCONT;
    function CHECK_3F_ID(StrCheckSum: string; ID_3F: string; Password_3F: string): boolean;
    function SUANFA_Password_USER(StrCheckSum: string; Str_Boss: string): string;
    function SUANFA_Password_USER_WritetoID(StrCheckSum: string; Str_Boss: string): string;
    function CHECK_Customer_ID_USERINIT(StrCheckSum: string; BossPassword_3F: string): boolean;
    function CHECK_Customer_ID_3FINIT(StrCheckSum: string; BossPassword_3F: string): boolean;
    function CHECK_3F_ID_BossInit(StrCheckSum: string; ID_3F: string; Password_3F: string): boolean;
    function ChangeAreaStrToHEX(arr: string): string;
    function ChangeAreaToStr(arr: array of integer; Len: integer): string;
    function ChangeAreaHEXToStr(orderStr: string): string;
    function GetInvalidDate(StrDate: string): string;
    function GetInvalidDate_after(strDate: string): string;
    function Select_IncValue_Byte(StrIncValue: string): string;
    function Select_ChangeHEX_DECIncValue(StrIncValue: string): string;
    procedure loginfo(strTemp:string);
  private
    //function GetUnitMessage(UMsg: string): PLC_UnitType;
    function GetSysPath(var PathStr: string): Boolean;

    { Private declarations }
  public
    { Public declarations }

  end;

var
  ICFunction: TICFunction;


implementation

uses ICCommunalConstUnit, ICCommunalVarUnit, Frontoperate_InitIDUnit;



procedure TICFunction.InitSystemWorkPath;
var
  a: array[0..100] of char;
begin
  if not GetSysPath(SystemPath) then
    GetDir(0, SystemPath); { 0 = Current drive }
  if SystemPath[Length(SystemPath)] = '\' then
    SystemPath := Copy(SystemPath, 1, Length(SystemPath) - 1);

  SystemMainPath := SystemPath;
  if SystemPath[Length(SystemPath)] <> '\' then
    SystemMainPath := SystemMainPath + '\';

  //����·������
 // SystemWorkGroundFile := SystemMainPath + 'C:\WINDOWS\System\System64.Ini';
//  ProgramPath := SystemMainPath + 'Program\';
 // ProgramIsTestFile := SystemMainPath + 'System\LLC.JNYH';

    //����·������
  //Winxp
  SystemWorkGroundFile := 'C:\WINDOWS\system32\wbem\System64.Ini';
  //SystemWorkGroundFile := 'C:\System64.Ini';
  ProgramPath := SystemMainPath + 'Program\';
  ProgramIsTestFile := SystemMainPath + 'LLC.JNYH';

  GetSystemDirectory(a, sizeof(a));
  PasswordFile := StrPas(a) + '\WindowsLLC.sys';
end;

procedure TICFunction.SaveSystemGroundMessageTerm(TermName, FieldName: string; Value: string);
var
  MyIni: TIniFile;
begin
  MyIni := TiniFile.Create(SystemWorkGroundFile);

  MyIni.WriteString(TermName, FieldName, Value);

  MyIni.UpdateFile;
  MyIni.Free;
end;

function TICFunction.GetSysPath(var PathStr: string): Boolean;
var
  RegFile: TRegIniFile;
begin
  Result := false;
  RegFile := TRegIniFile.Create;
  Regfile.RootKey := HKEY_LOCAL_MACHINE;
  if RegFile.KeyExists('\Software\JNYH_LPT') then begin
    PathStr := RegFile.ReadString('\Software\JNYH_LPT', 'InstallPath', 'c:\JNYH_LPT');
    ChDir(PathStr);
    Result := true;
  end;
end;

procedure TICFunction.InitSystemWorkground;
var
  MyIni: TIniFile;
  iStart, i: Integer;
  strTemp: string;
  strCopyone: string;
begin
  strTemp := '';
  if FileExists(SystemWorkGroundFile) then begin
    MyIni := TiniFile.Create(SystemWorkGroundFile);

    SystemWorkground.DB_Provider := MyIni.ReadString('DB����', '����', '');
    SystemWorkground.DB_DatabaseName := MyIni.ReadString('DB����', '���ݿ�', '');
    SystemWorkground.DB_Path := MyIni.ReadString('DB����', '���λ��', '');
    SystemWorkground.DatabaseConnectType := MyIni.ReadString('DB����', '��������', ''); //1Ϊ�������� 0ΪԶ������
    SystemWorkground.IPAddress := MyIni.ReadString('DB����', 'IP��ַ', ''); //��̨IP
    if SystemWorkground.DB_Path = '' then SystemWorkground.DB_Path := SystemMainPath + 'System';
    SystemWorkground.DB_StoreTime := MyIni.ReadInteger('DB����', '���ݱ���ʱ��', 30);
    SystemWorkground.DB_UpdateTime := MyIni.ReadString('DB����', '��������ʱ��', '2006-1-1');

    SystemWorkground.PLC_CommSet.Port := MyIni.ReadInteger('PLC��������', '�˿�', 1);

    SystemWorkground.PLC_CommSet.Setting := MyIni.ReadString('PLC��������', '����', '9600,N,8,1');

    SystemWorkground.ReadID.Port := MyIni.ReadInteger('��������', '�˿�', 2);
    SystemWorkground.ReadID.Setting := MyIni.ReadString('��������', '����', '9600,N,8,1');
    SystemWorkground.ReadID.Area := '0000' + MyIni.ReadString('��������', '����', '0000');
    iStart := Length(SystemWorkground.ReadID.Area);
    SystemWorkground.ReadID.Area := Copy(SystemWorkground.ReadID.Area, iStart - 3, 4);
    SystemWorkground.ReadID.IDLength := MyIni.ReadInteger('��������', '����', 60);
    SystemWorkground.ClearTPCS := MyIni.ReadInteger('��������', '������', 1);
    SystemWorkground.WriteTPCS := MyIni.ReadInteger('��������', 'д����', 1);

    SystemWorkground.WriteID.Port := MyIni.ReadInteger('д������', '�˿�', 2);
    SystemWorkground.WriteID.Setting := MyIni.ReadString('д������', '����', '9600,N,8,1');
    SystemWorkground.WriteID.Area := MyIni.ReadString('д������', '����', '0000');
    iStart := Length(SystemWorkground.WriteID.Area);
    SystemWorkground.WriteID.Area := Copy(SystemWorkground.WriteID.Area, iStart - 3, 4);
    SystemWorkground.WriteID.IDLength := MyIni.ReadInteger('д������', '����', 60);

    //����PLC�Ľ�������

    SystemWorkground.PLCRequestFDJ := MyIni.ReadString('PLC��������', 'PLC���󷢶���', 'D6000');
    SystemWorkground.PCReCallRequestFDJ := MyIni.ReadString('PLC��������', 'PC��Ӧ���󷢶���', 'D6100');
    SystemWorkground.PLCRequestClearTP := MyIni.ReadString('PLC��������', 'PLC����������', 'D6002');
    SystemWorkground.PCReCallClearTP := MyIni.ReadString('PLC��������', 'PC��Ӧ������', 'D6102');
    SystemWorkground.PLCRequestWriteTP := MyIni.ReadString('PLC��������', 'PLC����д����', 'D6004');
    SystemWorkground.PCReCallWriteTP := MyIni.ReadString('PLC��������', 'PC��Ӧд����', 'D6104');

    SystemWorkground.PCWriteLD := MyIni.ReadString('PLC��������', 'PCд���ϵ���', 'D6020');
    SystemWorkground.PCReadFanHao := MyIni.ReadString('PLC��������', 'PC��������', 'D6250');
    SystemWorkground.PCWriteFanHao := MyIni.ReadString('PLC��������', 'PCд�뷬��', 'D6021');
    SystemWorkground.PCWriteType := MyIni.ReadString('PLC��������', 'PCд�����', 'D6025');
    SystemWorkground.PCWriteTZ := MyIni.ReadString('PLC��������', 'PCд��������', 'D6040');
    SystemWorkground.PCReadFDJ := MyIni.ReadString('PLC��������', 'PC��������', 'D6254');
    SystemWorkground.PCReadTZ := MyIni.ReadString('PLC��������', 'PC����������', 'D6270');
    SystemWorkground.PCReadLS := MyIni.ReadString('PLC��������', 'PC������ˮ', 'D6276');
    SystemWorkground.PCReadYear := MyIni.ReadString('PLC��������', 'PC������', 'D6283');

    SystemWorkground.PCRun := MyIni.ReadString('PLC��������', 'PC����', 'D6106');
    SystemWorkground.PLCRun := MyIni.ReadString('PLC��������', 'PLC����', 'D6006');
    SystemWorkground.HaveJH := MyIni.ReadString('PLC��������', '�мƻ�', 'D6108'); //2�޼ƻ���1�мƻ�
    SystemWorkground.LOAD_Check_time := MyIni.ReadString('����������', 'ͨ���趨����', 'aaaa');


    SystemWorkground.ErrorGTState := MyIni.ReadString('PLC��������', 'PLC���屨�ϱ�־', 'D6010');


    SystemWorkground.PCErrorGTFlag := MyIni.ReadString('PLC��������', 'PC���ձ��ϱ�־', 'D6110');
    SystemWorkground.exchangerate := MyIni.ReadString('PLC��������', 'exchangerate','1');
    //---------������----------
    strTemp := FormatDateTime('YYYY', Now);
    CurYear := MyIni.ReadString('YearStyle', strTemp, 'A');


       //---------3F����ǰ����----------
    INit_3F.ID_INIT := MyIni.ReadString('����������', '��ƬID', '');
    INit_3F.ID_3F := MyIni.ReadString('����������', '����ID', '');
    INit_3F.Password_3F := MyIni.ReadString('����������', '���ؿ���', '');
    INit_3F.Password_USER := MyIni.ReadString('����������', '�û�����', '');
    INit_3F.ID_value := MyIni.ReadString('����������', '��������', '');
    INit_3F.ID_type := MyIni.ReadString('����������', '������', '');
    INit_3F.ID_CheckNum := MyIni.ReadString('����������', 'У���', '');
    INit_3F.ID_Settime := MyIni.ReadString('����������', '�趨ʱ��', '');
    INit_3F.Name_USER := MyIni.ReadString('PLC��������', '����','SG3F');
    
       //---------3F����ǰ����----------
       {
    INit_Wright.Produecer_3F:= MyIni.ReadString('Ȩ������','1','');
    INit_Wright.BOSS:= MyIni.ReadString('Ȩ������','2','');
    INit_Wright.MANEGER:= MyIni.ReadString('Ȩ������','3','');
    INit_Wright.QUERY:= MyIni.ReadString('Ȩ������','4','');
    INit_Wright.RECV_CASE:= MyIni.ReadString('Ȩ������','5','');
    INit_Wright.SETTING:= MyIni.ReadString('Ȩ������','6','');
    INit_Wright.OPERN:= MyIni.ReadString('Ȩ������','7','');
    INit_Wright.User:= MyIni.ReadString('Ȩ������','8','');
      }

     //--------------RFID �����Ϳ�ʼ------------

    INit_Wright.Produecer_3F := '���ܿ�,AA';
    INit_Wright.BOSS := '�ϰ忨,BB';
    INit_Wright.MANEGER := '����,4A';
    INit_Wright.QUERY := '���ʿ�,5E';
    INit_Wright.RECV_CASE := '������,CA';
    INit_Wright.SETTING := '�趨��,72';
    INit_Wright.OPERN := '������,DD';
    INit_Wright.User := '�û���,A5';

    //--------------RFID �����ͽ���------------
    

    INit_Wright.MenberControl_long := MyIni.ReadString('PLC��������', 'PCϵͳ����', 'ϵͳ��Ա�ƹ����趨'); //D6021�����һ���ַ�Ϊ�趨ֵ��1Ϊ���ã�0������
    INit_Wright.MenberControl_short := Copy(INit_Wright.MenberControl_long, 5, 1); //D6021�����һ���ַ�Ϊ�趨ֵ��1Ϊ���ã�0������

    INit_Wright.CustomerName := MyIni.ReadString('PLC��������', 'PC�ͻ����', '�ͻ����');
    INit_Wright.BossPassword := MyIni.ReadString('PLC��������', 'PC����������', '������');
    INit_Wright.BossPassword_old := MyIni.ReadString('PLC��������', 'PC����������', '������');
    INit_Wright.BossPassword_3F := MyIni.ReadString('PLC��������', 'PCд��������', '���ݿͻ���ż���3F������ʼ��');

    INit_Wright.MaxValue := MyIni.ReadString('PLC��������', 'PC����', '500');
    iHHSet := StrToInt(Copy(MyIni.ReadString('����������', '�趨����', '152419'), 3, 2));
    strCopyone:=Copy(INit_Wright.BossPassword,1,1);
    {
    if (strCopyone='0') or (strCopyone='1') or (strCopyone='2') or (strCopyone='0') or
     if not (strCopyone in ['0'..'9',#8, #13])
     }
    BarCodeFirstFrame[0]:=Copy(INit_Wright.BossPassword,1,2);
    BarCodeFirstFrame[1]:=Copy(INit_Wright.BossPassword,3,2);

    BarCodeFirstFrame[2]:='35';
    BarCodeFirstFrame[3]:='36';
    BarCodeFirstFrame[4]:='37';

    
     //--------------RFID ��ʼ------------
     //дָ���ͷ
    CMD_COUMUNICATION.CMD_INCValue := '51';
    CMD_COUMUNICATION.CMD_INCValue_RE := '53';
    CMD_COUMUNICATION.CMD_READ := '43';

  //--------------RFID ��ʼ------------


  //--------------���ܿ� ��½��ʼ------------
    CMD_COUMUNICATION.CMD_HAND := '61'; //����
    CMD_COUMUNICATION.CMD_USERPASSWORD := '64'; //����������
    CMD_COUMUNICATION.CMD_3FPASSWORD := '62'; //��ϵͳ���
    CMD_COUMUNICATION.CMD_3FLODADATE := '65'; //�����һ�ε�½ʱ��
  //--------------���ܿ� ��½����------------
  //--------------���ܿ� ������ʼ����ʼ------------
    CMD_COUMUNICATION.CMD_HAND_RE := '61'; //����
    CMD_COUMUNICATION.CMD_USERPASSWORD_RE := '68'; // дϵͳ���
    CMD_COUMUNICATION.CMD_3FPASSWORD_RE := '66'; //   д��������
    CMD_COUMUNICATION.CMD_WRITETOFLASH_Sub_RE := '7A'; //д��������
    CMD_COUMUNICATION.CMD_3FLODADATE_RE := '69'; //д���һ�ε�½ʱ��
  //--------------���ܿ� ������ʼ������------------

    User_Copy := TRUE;
  end
  else
  begin
    User_Copy := FALSE;
  end;

  SystemWorkGround.ClearStr := '';
  for i := 1 to SystemWorkground.ReadID.IDLength do begin
    SystemWorkGround.ClearStr := SystemWorkGround.ClearStr + '0';
  end;
end;

//���ַ���ת��Ϊ�����ܹ����͵�16�����ַ�������Ҫ���͡�123�����ֽ�Ϊ��1����2����3����
//��Ӧ16����ת��Ϊ��31����32����33�����ۺ�Ϊ��313233����

function TICFunction.ChangeAreaStrToHEX(arr: string): string;
var
  strTemp: string;
  reTmpStr: string;
  i: integer;
begin
  for i := 1 to Length(arr) do
  begin
    strTemp := IntToHex(Ord(arr[i]), 2);
    reTmpStr := reTmpStr + strTemp;
  end;
  Result := reTmpStr;
end;

function TICFunction.TransStringToFloat(S: string): Real;
var
  rtn: Real;
begin
  if S = '' then
    rtn := 0
  else begin
    try
      rtn := StrToFloat(S);
    except
      rtn := 0;
    end;
  end;

  Result := rtn;
end;

function TICFunction.TranslateMeasureDataToValue(Chal: TPoint; V: Real): Real;
var
  rtn: Real;
begin
  rtn := 0;
{
  case Chal.X of
    1 : rtn := (V * SystemWorkground.OMeasure[Chal.Y].TransValue - SystemWorkground.OMeasure[Chal.Y].WorkBase) + SystemWorkground.OMeasure[Chal.Y].StandardValue;
    2 : rtn := (V * SystemWorkground.IMeasure_Second[Chal.Y].TransValue - SystemWorkground.IMeasure_Second[Chal.Y].WorkBase) + SystemWorkground.IMeasure_Second[Chal.Y].StandardValue;
    3 : rtn := (V * SystemWorkground.IMeasure_First[Chal.Y].TransValue - SystemWorkground.IMeasure_First[Chal.Y].WorkBase) + SystemWorkground.IMeasure_First[Chal.Y].StandardValue;
    end;
}
  Result := rtn;
end;

function TICFunction.TransStringToInteger(S: string): Integer;
var
  rtn: Integer;
begin
  if S = '' then
    rtn := 0
  else begin
    try
      rtn := StrToInt(S);
    except
      rtn := 0;
    end;
  end;

  Result := rtn;
end;

function TICFunction.CheckTextIsNumber(S: string): Boolean;
var
  i: integer;
  rtn: Boolean;
begin
  rtn := True;
  for i := 1 to Length(S) do begin
    if ((S[i] < '0') or (S[i] > '9')) and (S[i] <> '.') and (S[i] <> '-') then begin
      rtn := False;
      break;
    end;
  end;

  Result := rtn;
end;

//CK=�ȴ�ʱ�� ����

function TICFunction.IsCheckOverTime(ST: TLargeInteger; CK: integer): Boolean;
var
  CurrentTime: TLargeInteger;
  Counter: Real;
begin
  QueryPerFormanceCounter(CurrentTime);
  Counter := (CurrentTime - ST) / WorkTimeFreq * 1000;

  Result := (Counter > CK);
end;

procedure TICFunction.DelayForHeighFreq(WT: integer);
var
  TrigStopWorkTimeStart: TLargeInteger;
  WorkTimeCurrent: TLargeInteger;
  WorkTaskValue: Real;
begin
  //��������߾��ȼ�����
  WorkTimeFreq := 100;
  QueryPerFormanceCounter(TrigStopWorkTimeStart);
  QueryPerFormanceCounter(WorkTimeCurrent);
  WorkTaskValue := (WorkTimeCurrent - TrigStopWorkTimeStart) / WorkTimeFreq;

  while WorkTaskValue <= WT do begin
    if (EndApplication) then break;
    QueryPerFormanceCounter(WorkTimeCurrent);
    WorkTaskValue := (WorkTimeCurrent - TrigStopWorkTimeStart) / WorkTimeFreq * 1000;
    Application.ProcessMessages;
  end;
end;





function TICFunction.ValIsNumber(Strv: string): Boolean;
var
  i, iAddPos, iDecPos, iDotCount, iAddCount, iDecCount: integer;
  BRet: Boolean;
begin
  BRet := True;
  iAddPos := 0;
  iDecPos := 0;
  iDotCount := 0;
  iAddCount := 0;
  iDecCount := 0;
  for i := 1 to Length(Strv) do begin
    if not (Strv[i] in ['0'..'9', '-', '+', '.']) then begin
      BRet := False;
      break;
    end;
    if (Strv[i] = '-') then begin
      iDecCount := iDecCount + 1;
      iDecPos := i;
    end;
    if (Strv[i] = '+') then begin
      iAddCount := iAddCount + 1;
      iAddPos := i;
    end;
    if (Strv[i] = '.') then begin
      iDotCount := iDotCount + 1;
    end;
  end;
  if ((iAddCount > 1) or (iDecCount > 1) or (iDotCount > 1) or (iAddPos > 1) or (iDecPos > 1)) then begin
    BRet := False;
  end;
  Result := BRet;
end;

procedure TICFunction.SaveSystemParameterTerm(Term, SubTerm, Value: string);
var
  MyIni: TIniFile;
begin
  MyIni := TiniFile.Create(SystemWorkGroundFile);
  MyIni.WriteString(Term, SubTerm, Value);

  MyIni.UpdateFile;
  MyIni.Free;
end;



procedure TICFunction.AddShowItemToMemo(Memo: TMemo; strItem: string);
begin
  if (Memo.Lines.Count > 7) then begin
    Memo.Lines.Delete(0);
  end;
  Memo.Lines.Add(strItem + '  ���');
end;

//����ַ����е�#0

procedure TICFunction.DeleteChr(strv: string);
var
  iStart: integer;

begin
  iStart := Pos(Chr(0), strv);
  while (iStart > 0) do begin
    Delete(strv, iStart, 1);
    iStart := Pos(Chr(0), strv);
  end;
end;


function TICFunction.BintoInt(Value: string): LongInt;
var
  i, Size: Integer;
begin
  Result := 0;
  Size := Length(Value);
  for i := Size downto 1 do
  begin
    if Copy(Value, i, 1) = '1' then
      Result := Result + (1 shl (Size - i));
  end;
end;


//ʮ���� to ������

function TICFunction.IntToBin(Value: LongInt; Size: Integer): string;
var
  i: Integer;
begin
  Result := '';
  for i := Size - 1 downto 0 do begin
    if Value and (1 shl i) <> 0 then begin
      Result := Result + '0';
    end else begin
      Result := Result + '1';
    end;
  end;
end;

//��һ��ʮ��������ת���ɶ�����ֵ ����˵����Int:��ת��������ֵ
//Size:ת����Ŀ�ȣ�4λ 8λ �����

function TICFunction.Str_IntToBin(Int: LongInt; Size: Integer): string;
var
  i: Integer;
begin
  if Size < 1 then Exit;
  for i := Size downto 1 do
  begin
    if Int and (1 shl (Size - i)) <> 0 then
      Result := '1' + Result
    else
      Result := '0' + Result;
  end;
end;

//��һ��ʮ�����Ƶ�ֵת�������� ����˵����Hex:��ת����ʮ������ֵ

function TICFunction.Str_HexToInt(Hex: string): integer;
var
  HexDigital: set of char;
  i: integer;
  Digital: string;
begin
  Result := 0;
  HexDigital := ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0', 'A', 'B',
    'C', 'D', 'E', 'F', 'a', 'b', 'c', 'd', 'e', 'f'];
  if Length(Hex) = 0 then Exit;
  for i := 1 to Length(Hex) do
  begin
    Digital := Copy(Hex, i, 1);
    if (i = 1) and (digital = '$') then Continue;
    if not (Str_StrToChar(Digital) in HexDigital) then Exit;
  end;
  Digital := Copy(Hex, 1, 1);
  if Digital <> '$' then Hex := '$' + Hex;
  Result := StrToInt(Hex);
end;

//�������ַ��Ĵ�ת�����ַ� ����˵����Str:��ת���Ĵ�

function TICFunction.Str_StrToChar(Str: string): Char;
begin
  Result := #0;
  if Length(Str) = 0 then exit;
  if Length(Str) > 1 then exit;
  Result := Str[1];
end;


//�����ID����ȡ�������Ϣ

procedure TICFunction.ClearIDinfor;
begin

  Receive_CMD_ID_Infor.CMD := '';
  Receive_CMD_ID_Infor.ID_INIT := '';
  Receive_CMD_ID_Infor.ID_3F := '';
  Receive_CMD_ID_Infor.Password_3F := '';
  Receive_CMD_ID_Infor.Password_USER := '';
  Receive_CMD_ID_Infor.ID_value := '';
  Receive_CMD_ID_Infor.ID_type := '';
  Receive_CMD_ID_Infor.ID_CheckNum := '';
  Receive_CMD_ID_Infor.ID_Settime := '';
end;



//����ID�㷨 
function TICFunction.SUANFA_ID_3F(StrCheckSum: string): string;
var
  Byte1, Byte2, Byte3: integer;
  temp, tempTOTAL1, tempTOTAL2, tempTOTAL3: integer; //2147483648 ���Χ

begin

  tempTOTAL1 := strToint('$' + Copy(StrCheckSum, 1, 2)) + strToint('$' + Copy(StrCheckSum, 3, 2)) + strToint('$' + Copy(StrCheckSum, 5, 2)) * strToint('$' + Copy(StrCheckSum, 7, 2));

  Byte1 := (tempTOTAL1 * tempTOTAL1) mod 16; // �ڶ��ֽ�
  Byte2 := (tempTOTAL1 * tempTOTAL1) div 16; //�ڶ��ֽ�
  Byte3 := tempTOTAL1; //��һ�ֽ�
  result := copy(IntToHex(Byte2, 2), length(IntToHex(Byte2, 2)) - 1, 2) + copy(IntToHex(Byte3, 2), length(IntToHex(Byte3, 2)) - 1, 2) + copy(IntToHex(Byte1, 2), length(IntToHex(Byte1, 2)) - 1, 2);

end;

//���������㷨 StrCheckSum����ID��strCUSTOMER_NO���� 
function TICFunction.SUANFA_Password_3F(StrCheckSum: string): string;
var
  Byte1, Byte2, Byte3: integer;
  temp, tempTOTAL1, tempTOTAL2, tempTOTAL3: integer; //2147483648 ���Χ

begin



  tempTOTAL1 := strToint('$' + Copy(StrCheckSum, 1, 2)) * strToint('$' + Copy(StrCheckSum, 3, 2)) + strToint('$' + Copy(StrCheckSum, 5, 2)); //ID_3F����

  Byte1 := (tempTOTAL1 * tempTOTAL1) mod 16; ; //��һ�ֽ�
  Byte2 := (tempTOTAL1 * tempTOTAL1) div 16; //�ڶ��ֽ�
  Byte3 := tempTOTAL1; //�ڶ��ֽ� 
  result := copy(IntToHex(Byte1, 2), length(IntToHex(Byte1, 2)) - 1, 2) + copy(IntToHex(Byte2, 2), length(IntToHex(Byte2, 2)) - 1, 2) + copy(IntToHex(Byte3, 2), length(IntToHex(Byte3, 2)) - 1, 2);

end;


  //ID�����ʶ��

function TICFunction.CHECK_3F_ID(StrCheckSum: string; ID_3F: string; Password_3F: string): boolean;
var
  ID_3F_1: string;
  ID_3F_2: string;
  ID_3F_3: string;
  PWD_3F_1: string;
  PWD_3F_2: string;
  PWD_3F_3: string;
  tempTOTAL1: integer;
  tempTOTAL2: integer;

  Byte1, Byte2, Byte3, Byte4, Byte5, Byte6: integer;
begin

       //StrCheckSum:='2A2542CB';
  ID_3F_1 := copy(ID_3F, 3, 2);
  ID_3F_2 := copy(Password_3F, 3, 2);
  ID_3F_3 := copy(Password_3F, 1, 2);


  PWD_3F_1 := copy(Password_3F, 5, 2);
  PWD_3F_2 := copy(ID_3F, 5, 2);
  PWD_3F_3 := copy(ID_3F, 1, 2);


    //����ID
  tempTOTAL1 := strToint('$' + Copy(StrCheckSum, 1, 2)) + strToint('$' + Copy(StrCheckSum, 3, 2)) + strToint('$' + Copy(StrCheckSum, 5, 2)) * strToint('$' + Copy(StrCheckSum, 7, 2));
  Byte1 := (tempTOTAL1 * tempTOTAL1) mod 16;
  Byte2 := (tempTOTAL1 * tempTOTAL1) div 16;
  Byte3 := tempTOTAL1;

    //Byte2  Byte3  Byte1

  Result := true;
//    if (ID_3F_1<>copy(IntToHex(Byte2,2),length(IntToHex(Byte2,2))-2,2))then
//20121103�޸�
  if (ID_3F_1 <> copy(IntToHex(Byte2, 2), length(IntToHex(Byte2, 2)) - 1, 2)) then
    Result := false; //��һ�ֽ�
  if (ID_3F_2 <> copy(IntToHex(Byte3, 2), length(IntToHex(Byte3, 2)) - 1, 2)) then
    Result := false; //�ڶ��ֽ�
  if (ID_3F_3 <> copy(IntToHex(Byte1, 2), length(IntToHex(Byte1, 2)) - 1, 2)) then
    Result := false; //�����ֽ�


         //��������
  tempTOTAL2 := strToint('$' + Copy(StrCheckSum, 1, 2)) * strToint('$' + Copy(StrCheckSum, 3, 2)) + strToint('$' + Copy(StrCheckSum, 5, 2));
  Byte4 := (tempTOTAL2 * tempTOTAL2) mod 16;
  Byte5 := (tempTOTAL2 * tempTOTAL2) div 16;
  Byte6 := tempTOTAL2;


end;


  //�ڳ��س�ʼ������ʱ���ã���Ҫ����֤ ����ID����������

function TICFunction.CHECK_3F_ID_BossInit(StrCheckSum: string; ID_3F: string; Password_3F: string): boolean;
var
  ID_3F_1: string;
  ID_3F_2: string;
  ID_3F_3: string;
  PWD_3F_1: string;
  PWD_3F_2: string;
  PWD_3F_3: string;
  tempTOTAL1: integer;
  tempTOTAL2: integer;

  Byte1, Byte2, Byte3, Byte4, Byte5, Byte6: integer;
begin

       //StrCheckSum:='2A2542CB';
  ID_3F_1 := copy(ID_3F, 3, 2);
  ID_3F_2 := copy(Password_3F, 3, 2);
  ID_3F_3 := copy(Password_3F, 1, 2);


  PWD_3F_1 := copy(Password_3F, 5, 2);
  PWD_3F_2 := copy(ID_3F, 5, 2);
  PWD_3F_3 := copy(ID_3F, 1, 2);


    //����ID
  tempTOTAL1 := strToint('$' + Copy(StrCheckSum, 1, 2)) + strToint('$' + Copy(StrCheckSum, 3, 2)) + strToint('$' + Copy(StrCheckSum, 5, 2)) * strToint('$' + Copy(StrCheckSum, 7, 2));
  Byte1 := (tempTOTAL1 * tempTOTAL1) mod 16;
  Byte2 := (tempTOTAL1 * tempTOTAL1) div 16;
  Byte3 := tempTOTAL1;

    //Byte2  Byte3  Byte1

  Result := true;
 //   if (ID_3F_1<>copy(IntToHex(Byte2,2),length(IntToHex(Byte2,2))-2,2))then
//20121103�޸�
  if (ID_3F_1 <> copy(IntToHex(Byte2, 2), length(IntToHex(Byte2, 2)) - 1, 2)) then
    Result := false; //��һ�ֽ�
  if (ID_3F_2 <> copy(IntToHex(Byte3, 2), length(IntToHex(Byte3, 2)) - 1, 2)) then
    Result := false; //�ڶ��ֽ�
  if (ID_3F_3 <> copy(IntToHex(Byte1, 2), length(IntToHex(Byte1, 2)) - 1, 2)) then
    Result := false; //�����ֽ�


         //��������
  tempTOTAL2 := strToint('$' + Copy(StrCheckSum, 1, 2)) * strToint('$' + Copy(StrCheckSum, 3, 2)) + strToint('$' + Copy(StrCheckSum, 5, 2));
  Byte4 := (tempTOTAL2 * tempTOTAL2) mod 16;
  Byte5 := (tempTOTAL2 * tempTOTAL2) div 16;
  Byte6 := tempTOTAL2;


//    if (PWD_3F_1<>copy(IntToHex(Byte4,2),length(IntToHex(Byte4,2))-2,2))then
//         Result := false; //��һ�ֽ�
//    if (PWD_3F_2<>copy(IntToHex(Byte5,2),length(IntToHex(Byte5,2))-2,2))then
//         Result := false; //�ڶ��ֽ�
//    if (PWD_3F_3<>copy(IntToHex(Byte6,2),length(IntToHex(Byte6,2))-2,2))then
//         Result := false;//�����ֽ�
//20121103�޸�
  if (PWD_3F_1 <> copy(IntToHex(Byte4, 2), length(IntToHex(Byte4, 2)) - 1, 2)) then
    Result := false; //��һ�ֽ�
  if (PWD_3F_2 <> copy(IntToHex(Byte5, 2), length(IntToHex(Byte5, 2)) - 1, 2)) then
    Result := false; //�ڶ��ֽ�
  if (PWD_3F_3 <> copy(IntToHex(Byte6, 2), length(IntToHex(Byte6, 2)) - 1, 2)) then
    Result := false; //�����ֽ�
end;

  //ID�����ʶ��

procedure TICFunction.INITCONT;
begin
  strtemp1 := '3F';
  strtemp2 := 'F3';
  strtemp3 := '0A';
  strtemp4 := '0D';
  strtemp5 := '07';
end;
//���´˺�����3F������ʼ��ʱ���ã����ɳ��س�ʼ����
// �ڴ������ĳ������룬���ϰ��õ�3F������г��س�ʼ��ǰ��Ҫʶ�����ݣ�Ҳ���ǽ���
//�����뺯��Ϊfunction TICFunction.CHECK_Customer_ID_3FINIT(StrCheckSum: string;BossPassword_3F: string):boolean;��
// INit_Wright.BossPassword:= MyIni.ReadString('PLC��������','PC����������','D60993');
//���������㷨(�����ϰ��ڳ��������趨������������룬
//ת��Ϊ�洢��myIni.WriteString('PLC��������','PC����������',INit_Wright.BossPassword);)

function TICFunction.SUANFA_Password_USER(StrCheckSum: string; Str_Boss: string): string;
var
  Byte1, Byte2, Byte3: integer;
  temp, tempTOTAL1, tempTOTAL2, tempTOTAL3: integer; //2147483648 ���Χ
begin
    //tempTOTAL1:=strToint('$'+Copy(Str_Boss,3,2))*strToint('$'+Copy(StrCheckSum,5,2))+strToint('$'+Copy(Str_Boss,5,2))*strToint('$'+Copy(StrCheckSum,1,2))+strToint('$'+Copy(Str_Boss,1,2))*strToint('$'+Copy(StrCheckSum,7,2));
  tempTOTAL1 := strToint('$' + Copy(Str_Boss, 3, 2)) + strToint('$' + Copy(Str_Boss, 1, 2)) * strToint('$' + Copy(StrCheckSum, 1, 2)) + strToint('$' + Copy(Str_Boss, 1, 2)) * strToint('$' + Copy(StrCheckSum, 5, 2));

  Byte1 := (tempTOTAL1 * tempTOTAL1) mod 16; // �ڶ��ֽ�
  Byte2 := (tempTOTAL1 * tempTOTAL1) div 16; //�ڶ��ֽ�
  Byte3 := tempTOTAL1; //��һ�ֽ�
    //Byte2  Byte3  Byte1
  result := copy(IntToHex(Byte3, 2), length(IntToHex(Byte3, 2)) - 2, 2) + copy(IntToHex(Byte1, 2), length(IntToHex(Byte1, 2)) - 1, 2) + copy(IntToHex(Byte2, 2), length(IntToHex(Byte2, 2)) - 1, 2);

end;

//���´˺������ϰ���г��������ʼ��ʱ���ã�
//���뺯��function TICFunction.CHECK_Customer_ID_USERINIT(StrCheckSum: string;BossPassword_3F: string):boolean;
//ICFunction.SUANFA_Password_USER(INit_3F.ID_3F,CUSTOMER_NO);
// INit_Wright.BossPassword_3F:= MyIni.ReadString('PLC��������','PCд��������','312014');
//���� PCд��������=312014���˹�д���ļ���

//���������㷨(�ϰ���������SUANFA_Password_USER()�������ɵĳ������룬����д��ID���ĳ�������)

function TICFunction.SUANFA_Password_USER_WritetoID(StrCheckSum: string; Str_Boss: string): string;
var
  Byte1, Byte2, Byte3: integer;
  temp, tempTOTAL1, tempTOTAL2, tempTOTAL3: integer; //2147483648 ���Χ
begin
  //  tempTOTAL1:=strToint('$'+Copy(Str_Boss,5,2))*strToint('$'+Copy(StrCheckSum,3,2))+strToint('$'+Copy(Str_Boss,3,2))*strToint('$'+Copy(StrCheckSum,1,2))+strToint('$'+Copy(Str_Boss,1,2))*strToint('$'+Copy(StrCheckSum,7,2));
  tempTOTAL1 := strToint('$' + Copy(Str_Boss, 1, 2)) + strToint('$' + Copy(Str_Boss, 3, 2)) * strToint('$' + Copy(StrCheckSum, 1, 2)) + strToint('$' + Copy(Str_Boss, 1, 2)) * strToint('$' + Copy(StrCheckSum, 3, 2));

  Byte1 := (tempTOTAL1 * tempTOTAL1) mod 16; // �ڶ��ֽ�
  Byte2 := (tempTOTAL1 * tempTOTAL1) div 16; //�ڶ��ֽ�
  Byte3 := tempTOTAL1; //��һ�ֽ�
    //Byte2  Byte3  Byte1
  result := copy(IntToHex(Byte3, 2), length(IntToHex(Byte3, 2)) - 2, 2) + copy(IntToHex(Byte1, 2), length(IntToHex(Byte1, 2)) - 1, 2) + copy(IntToHex(Byte2, 2), length(IntToHex(Byte2, 2)) - 1, 2);
end;

//CHECK_Customer_ID(Receive_CMD_ID_Infor.ID_INIT,INit_Wright.BossPassword)
//�ϰ��õ��µ�3F������ʼ����ϵĿ����״ν���ID����������ʶ��,��3F�����ʼ���ĳ�������Ƚ�

function TICFunction.CHECK_Customer_ID_3FINIT(StrCheckSum: string; BossPassword_3F: string): boolean;
var
  BossPassword_3F_1: string;
  BossPassword_3F_2: string;
  BossPassword_3F_3: string;
  tempTOTAL1: integer;
  CUSTOMER_NO: string;

  Byte1, Byte2, Byte3, Byte4, Byte5, Byte6: integer;
begin
    //BossPassword_3F��3F������ʼ��ʱ�趨��BossPassword_USER��������
  BossPassword_3F_1 := copy(BossPassword_3F, 1, 2);
  BossPassword_3F_2 := copy(BossPassword_3F, 3, 2);
  BossPassword_3F_3 := copy(BossPassword_3F, 5, 2);

    //���� INit_Wright.BossPassword_3F:= MyIni.ReadString('PLC��������','PCд��������','312014');
    //��ֵ�����ĵ�SystemWorkGround.ini���˹�����Ŀͻ����
  CUSTOMER_NO := INit_Wright.BossPassword_3F;

    //����ID
  tempTOTAL1 := strToint('$' + Copy(CUSTOMER_NO, 3, 2)) + strToint('$' + Copy(CUSTOMER_NO, 1, 2)) * strToint('$' + Copy(StrCheckSum, 1, 2)) + strToint('$' + Copy(CUSTOMER_NO, 1, 2)) * strToint('$' + Copy(StrCheckSum, 5, 2));
  Byte1 := (tempTOTAL1 * tempTOTAL1) mod 16; // �ڶ��ֽ�
  Byte2 := (tempTOTAL1 * tempTOTAL1) div 16; //�ڶ��ֽ�
  Byte3 := tempTOTAL1; //��һ�ֽ�

    //Byte2  Byte3  Byte1
  Result := true;
  if (BossPassword_3F_1 <> copy(IntToHex(Byte3, 2), length(IntToHex(Byte3, 2)) - 2, 2)) then
    Result := false; //��һ�ֽ�
  if (BossPassword_3F_2 <> copy(IntToHex(Byte1, 2), length(IntToHex(Byte1, 2)) - 1, 2)) then
    Result := false; //�ڶ��ֽ�
  if (BossPassword_3F_3 <> copy(IntToHex(Byte2, 2), length(IntToHex(Byte2, 2)) - 1, 2)) then
    Result := false; //�����ֽ�
end;

//�ϰ��õ��µ�3F������ʼ����ϵĿ����״ν���ID����������ʶ��,��3F�����ʼ���ĳ�������Ƚ�

function TICFunction.CHECK_Customer_ID_USERINIT(StrCheckSum: string; BossPassword_3F: string): boolean;
var
  BossPassword_3F_1: string;
  BossPassword_3F_2: string;
  BossPassword_3F_3: string;
  tempTOTAL1: integer;
  CUSTOMER_NO: string;

  Byte1, Byte2, Byte3, Byte4, Byte5, Byte6: integer;
begin
    //BossPassword_3F��3F������ʼ��ʱ�趨��BossPassword_USER��������
  BossPassword_3F_1 := copy(BossPassword_3F, 1, 2);
  BossPassword_3F_2 := copy(BossPassword_3F, 3, 2);
  BossPassword_3F_3 := copy(BossPassword_3F, 5, 2);

    //���� INit_Wright.BossPassword_3F:= MyIni.ReadString('PLC��������','PC����������','312014');
    //��ֵ�����ĵ�SystemWorkGround.ini���˹�����Ŀͻ����
  CUSTOMER_NO := INit_Wright.BossPassword_old;

    //����ID
  tempTOTAL1 := strToint('$' + Copy(CUSTOMER_NO, 1, 2)) + strToint('$' + Copy(CUSTOMER_NO, 3, 2)) * strToint('$' + Copy(StrCheckSum, 1, 2)) + strToint('$' + Copy(CUSTOMER_NO, 1, 2)) * strToint('$' + Copy(StrCheckSum, 3, 2));

  Byte1 := (tempTOTAL1 * tempTOTAL1) mod 16; // �ڶ��ֽ�
  Byte2 := (tempTOTAL1 * tempTOTAL1) div 16; //�ڶ��ֽ�
  Byte3 := tempTOTAL1; //��һ�ֽ�

    //Byte2  Byte3  Byte1
  Result := true;
  if (BossPassword_3F_1 <> copy(IntToHex(Byte3, 2), length(IntToHex(Byte3, 2)) - 2, 2)) then
    Result := false; //��һ�ֽ�
  if (BossPassword_3F_2 <> copy(IntToHex(Byte1, 2), length(IntToHex(Byte1, 2)) - 1, 2)) then
    Result := false; //�ڶ��ֽ�
  if (BossPassword_3F_3 <> copy(IntToHex(Byte2, 2), length(IntToHex(Byte2, 2)) - 1, 2)) then
    Result := false; //�����ֽ�
end;

//���Ӵ��ڻ�ȡ��16������ʽ�ַ���ת��ΪASII���ַ���

function TICFunction.ChangeAreaHEXToStr(orderStr: string): string;
var
  ii, jj: integer;
  reTmpStr, tmpStr: string;
  arr: array of integer;
begin
  //Ҫ���������ַ�����ȡ����Ӵ��ڻ�ȡ�ġ�3031�������ȡΪ��30����31����

  reTmpStr := '';
  SetLength(arr, 1); //�趨���鳤��Ϊ1
  for ii := 1 to (length(orderStr) div 2) do
  begin
    tmpStr := copy(orderStr, ii * 2 - 1, 2);
    jj := strToint('$' + tmpStr);
    arr[0] := jj;
    reTmpStr := reTmpStr + ChangeAreaToStr(arr, 1); //����10��������ת��ΪASII���ַ�������
  end;

  result := reTmpStr;
end;

//�����������е�����ת��ΪASII��

function TICFunction.ChangeAreaToStr(arr: array of integer; Len: integer): string;
var
  strTemp, strV, strV2: string;
  i, iRet: integer;
begin
  strV2 := IntToStr(0) + IntToStr(0);
  for i := 1 to Len do begin
    if (arr[i - 1] = 0) then continue;
    strTemp := IntToHex(arr[i - 1], 2);
    iRet := HexToBin(PChar(strTemp), PChar(strV2), 2);
    if (iRet > 1) then
      strV := strV + strV2[2] + strV2[1]
    else
      strV := strV + strV2[1];
  end;
  Result := strV;
end;


//ȡ������ʱ���ǰһ������

function TICFunction.GetInvalidDate(StrDate: string): string;
var
  strtemp: string;
  iYear, iMonth, iDate, iHH, iMin, iSecond, iHHSet_temp: integer;
  jYear, jMonth, jDate, jHH, jMin, jSecond, jHHSet_temp: string;
begin

  iHHSet_temp := 24;
  strtemp := StrDate;
  iYear := strToint(Copy(strtemp, 1, 4)); //��
  iMonth := strToint(Copy(strtemp, 6, 2)); //��
  iDate := strToint(Copy(strtemp, 9, 2)); //��
  iHH := strToint(Copy(strtemp, 12, 2)); //Сʱ
  iMin := strToint(Copy(strtemp, 15, 2)); //����
  iSecond := strToint(Copy(strtemp, 18, 2)); //��

  if (iHHSet_temp > 47) then
  begin
             // showmessage('Ϊ�˱������������氲ȫ�����趨����Чʱ��С��48');
    exit;
  end;
  if ((iHH + iHHSet_temp) >= 24) and ((iHH + iHHSet_temp) < 48) then
  begin
        //iHH:=(iHH+iHHSet_temp)-24;//ȡ���µ�Сʱ
    if (iYear < 1930) then
    begin
              //showmessage('ϵͳʱ�������趨�������뿨ͷ��ʱͬ��');
      exit;
    end;
    if (iMonth = 3) then
    begin
      if ((iYear mod 4) = 0) or ((iYear mod 100) = 0) then //���� 2��Ϊ28��
      begin
        if (iDate = 1) then
        begin
          iDate := 28;
          iMonth := iMonth - 1;
        end
        else
        begin
          iDate := iDate - 1;
        end;
      end
      else //��������  2��Ϊ29��
      begin
        if (iDate = 1) then
        begin
          iDate := 29;
          iMonth := iMonth - 1;
        end
        else
        begin
          iDate := iDate - 1;
        end;
      end;
    end
    else if (iMonth = 12) or (iMonth = 5) or (iMonth = 7) or (iMonth = 8) or (iMonth = 10) then
    begin
      if (iDate = 1) then
      begin
        iDate := 30;
        iMonth := iMonth - 1;
      end
      else
      begin
        iDate := iDate - 1;
      end;
    end

    else if (iMonth = 1) then
    begin
      if (iDate = 1) then
      begin
        iDate := 31;
        iMonth := 12;
        iYear := iYear - 1;
      end
      else
      begin
        iDate := iDate - 1;
      end;
    end
    else if (iMonth = 2) then
    begin
      if (iDate = 1) then
      begin
        iDate := 31;
        iMonth := 1;
      end
      else
      begin
        iDate := iDate - 1;
      end;
    end
    else if (iMonth = 4) or (iMonth = 6) or (iMonth = 9) or (iMonth = 11) then
    begin
      if (iDate = 1) then
      begin
        iDate := 31;
        iMonth := iMonth - 1;
      end
      else
      begin
        iDate := iDate - 1;
      end;
    end;
  end;

  if iMonth < 10 then
    jMonth := '0' + inttostr(iMonth)
  else
    jMonth := inttostr(iMonth);

  if iDate < 10 then
    jDate := '0' + inttostr(iDate)
  else
    jDate := inttostr(iDate);

  if iHH < 10 then
    jHH := '0' + inttostr(iHH)
  else
    jHH := inttostr(iHH);


  if iMin < 10 then
    jMin := '0' + inttostr(iMin)
  else
    jMin := inttostr(iMin);

  if iSecond < 10 then
    jSecond := '0' + inttostr(iSecond)
  else
    jSecond := inttostr(iSecond);

  Result := inttostr(iYear) + '-' + jMonth + '-' + jDate + ' ' + jHH + ':' + jMin + ':' + jSecond;

end;


//��ֵ����ת����16���Ʋ����� �ֽ�LL���ֽ�LH���ֽ�HL���ֽ�HH

function TICFunction.Select_IncValue_Byte(StrIncValue: string): string;
var
  tempLH, tempHH, tempHL, tempLL: integer; //2147483648 ���Χ
begin
  tempHH := StrToint(StrIncValue) div 16777216; //�ֽ�HH
  tempHL := (StrToInt(StrIncValue) mod 16777216) div 65536; //�ֽ�HL
  tempLH := (StrToInt(StrIncValue) mod 65536) div 256; //�ֽ�LH
  tempLL := StrToInt(StrIncValue) mod 256; //�ֽ�LL

  result := IntToHex(tempLL, 2) + IntToHex(tempLH, 2) + IntToHex(tempHL, 2) + IntToHex(tempHH, 2);
end;


//��16���Ʋ����� �ֽ�LL���ֽ�LH���ֽ�HL���ֽ�HH�õ��ַ���ת��ԭΪ��ֵ����

function TICFunction.Select_ChangeHEX_DECIncValue(StrIncValue: string): string;
var
  tempLH, tempHH, tempHL, tempLL, tempTotal: integer; //2147483648 ���Χ
begin
  tempHH := strToint('$' + Copy(StrIncValue, 7, 2)); //�ֽ�HH
  tempHL := strToint('$' + Copy(StrIncValue, 5, 2)); //�ֽ�HL
  tempLH := strToint('$' + Copy(StrIncValue, 3, 2)); //�ֽ�LH
  tempLL := strToint('$' + Copy(StrIncValue, 1, 2)); //�ֽ�LL

  tempTotal := tempHH * 16777216 + tempHL * 65536 + tempLH * 256 + tempLL;
  result := IntToStr(tempTotal);
end;


//ȡ����Чʱ������ ��һ�����

function TICFunction.GetInvalidDate_after(strDate: string): string;
var
  strtemp: string;
  iYear, iMonth, iDate, iHH, iMin, iSecond: integer;
  iHHSet_temp: integer;
begin


  strtemp := strDate;
  iYear := strToint(Copy(strtemp, 1, 4)); //��
  iMonth := strToint(Copy(strtemp, 6, 2)); //��
  iDate := strToint(Copy(strtemp, 9, 2)); //��
  iHH := strToint(Copy(strtemp, 12, 2)); //Сʱ
  iMin := strToint(Copy(strtemp, 15, 2)); //����
  iSecond := strToint(Copy(strtemp, 18, 2)); //��
  iHHSet_temp := 24;

  if ((iHH + iHHSet_temp) >= 24) and ((iHH + iHHSet_temp) < 48) then
  begin
    iHH := (iHH + iHHSet_temp) - 24; //ȡ���µ�Сʱ
    if (iYear < 1930) then
    begin
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
  else if ((iHH + iHHSet_temp) < 24) then
  begin
    iHH := (iHH + iHHSet_temp); //ȡ���µ�Сʱ
  end;

  Result := inttostr(iYear) + '-' + inttostr(iMonth) + '-' + inttostr(iDate) + ' ' + inttostr(iHH) + ':' + inttostr(iMin) + ':' + inttostr(iSecond);

end;

Procedure TICFunction.loginfo(strTemp:string);
Var
    F : Textfile;
    strmessage,FileName: string;
Begin

 //��������Ҫע�͵���־����
		{
    FileName := 'C:\3F_log.log' ;
     if fileExists(FileName) then
      begin
        AssignFile(F,FileName);
        Append(F);
      end
     else
      begin
        AssignFile(F,FileName);
        ReWrite(F);
      end;
    strmessage := formatdatetime('yyyy-mm-dd hh:nn:ss',now())+ '  '+ strTemp;
    Writeln(F, strmessage);
    Closefile(F); 
}
 
End;  



end.
