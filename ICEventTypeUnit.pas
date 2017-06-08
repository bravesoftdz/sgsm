unit ICEventTypeUnit;

interface

uses IniFiles, SysUtils, Classes;

type
  PLC_UnitType = record //PLC��Ԫ����
    Name: string; //����
    Command: string; //����
    Address: string; //��ַ
    Size: integer; //����
    Value: array of integer; //��Ԫֵ��������Length��ͬ��
    Style: string; //���ԣ����롢�����
  end;

  PLC_EventType = record //�¼�����
    Name: string; //�¼�����
    UnitMsg: PLC_UnitType; //�¼������������һ��
    Have: Boolean; //�Ƿ�ִ��
  end;

  EventSystemType = record
    PLC_Type: integer; //PLC�ͺ�
    PLC_Unit: array of PLC_UnitType; //��PLCͨѶ�õĵ�Ԫ����
    PLC_EventIn: array of PLC_EventType; //PLC�¼�
    PLC_EventOut: array of PLC_EventType;
  end;

  EventUnitObj = class
    function TransStringToFloat(S: string): Real;
    function TransStringToInteger(S: string): Integer;

  public
    PLCCommandList: TStrings; //���ظ������

       //�������������ڴ˰汾�����δʹ��
    procedure LoadEventIni;
    procedure GetUnitMessageForName(var Eu: PLC_UnitType; UName: string);
    function GetUnitMessage(UMsg: string): PLC_UnitType;

  end;

var
  EventSystem: EventSystemType;
  EventObj: EventUnitObj;

implementation

uses ICCommunalVarUnit, ICFunctionUnit;

function EventUnitObj.GetUnitMessage(UMsg: string): PLC_UnitType;
var
  k: integer;
  rtn: PLC_UnitType;
begin
  //��Ԫ����
  k := Pos(',', UMsg);
  rtn.Name := Copy(UMsg, 1, k - 1);

  //ָ��
  UMsg := Copy(UMsg, k + 1, Length(UMsg) - 1);
  k := Pos(',', UMsg);
  rtn.Command := Copy(UMsg, 1, k - 1);

  //��Ԫ��ַ
  UMsg := Copy(UMsg, k + 1, Length(UMsg) - 1);
  k := Pos(',', UMsg);
  rtn.Address := Copy(UMsg, 1, k - 1);

  //��Ԫ����
  UMsg := Copy(UMsg, k + 1, Length(UMsg) - 1);
  k := Pos(',', UMsg);
  rtn.Size := TransStringToInteger(Copy(UMsg, 1, k - 1));

  //��Ԫֵ
  Setlength(rtn.Value, rtn.Size); //˵����ֵ�ܴ���ٸ�ֵ��Value�Ǹ�����

  //��Ԫ����
  rtn.Style := Copy(UMsg, k + 1, Length(UMsg) - 1);


  Result := rtn;
end;


procedure EventUnitObj.GetUnitMessageForName(var Eu: PLC_UnitType;
  UName: string);
var
  i: integer;
begin
  for i := 0 to Length(EventSystem.PLC_Unit) - 1 do begin
    if EventSystem.PLC_Unit[i].Name = UName then begin
      Eu.Name := EventSystem.PLC_Unit[i].Name;
      Eu.Command := EventSystem.PLC_Unit[i].Command;
      Eu.Address := EventSystem.PLC_Unit[i].Address;
      Eu.Size := EventSystem.PLC_Unit[i].Size;
      Eu.Style := EventSystem.PLC_Unit[i].Style;
      break;
    end;
  end;
end;

procedure EventUnitObj.LoadEventIni;
var
  myIni: TIniFile;
  i, Tot, j, k: integer;
  S: string;
begin

  if FileExists(SystemWorkGroundFile) then begin
    MyIni := TiniFile.Create(SystemWorkGroundFile);

    Tot := MyIni.ReadInteger('PLC��Ԫ', '����', 0);
    SetLength(EventSystem.PLC_Unit, Tot);
    for i := 0 to Tot - 1 do begin
      S := MyIni.ReadString('PLC��Ԫ', '��Ԫ' + FormatCurr('#0', i + 1), ',,');
      EventSystem.PLC_Unit[i] := GetUnitMessage(S);

    end;

    Tot := MyIni.ReadInteger('PLC�����¼�', '����', 0);
    SetLength(EventSystem.PLC_EventIn, Tot);
    for i := 0 to Tot - 1 do begin
      S := MyIni.ReadString('PLC�����¼�', '�¼�' + FormatCurr('#0', i + 1), ';;');
      //ȡ�¼�����
      j := Pos(';', S);
      EventSystem.PLC_EventIn[i].Name := Copy(S, 1, j - 1);
      S := Copy(S, j + 1, Length(S) - j);
      //ȡ�¼���Ϣ
      j := Pos(';', S);
      EventObj.GetUnitMessageForName(EventSystem.PLC_EventIn[i].UnitMsg, Copy(S, 1, j - 1));
      Setlength(EventSystem.PLC_EventIn[i].UnitMsg.Value, EventSystem.PLC_EventIn[i].UnitMsg.Size);
      //�¼�ȡֵ
      S := Copy(S, j + 1, Length(S) - j);
      for k := 0 to Length(EventSystem.PLC_EventIn[i].UnitMsg.Value) - 1 do begin
        j := Pos(',', S);
        if j > 0 then begin

          EventSystem.PLC_EventIn[i].UnitMsg.Value[k] := ICFunction.TransStringToInteger(Copy(S, 1, j - 1));
          S := Copy(S, j + 1, Length(S) - j);
        end
        else
          EventSystem.PLC_EventIn[i].UnitMsg.Value[k] := 0;
      end;

      EventSystem.PLC_EventIn[i].Have := False;
    end;

    Tot := MyIni.ReadInteger('PLC����¼�', '����', 0);
    SetLength(EventSystem.PLC_EventOut, Tot);
    for i := 0 to Tot - 1 do begin
      S := MyIni.ReadString('PLC����¼�', '�¼�' + FormatCurr('#0', i + 1), ';;');
      //ȡ�¼�����
      j := Pos(';', S);
      EventSystem.PLC_EventOut[i].Name := Copy(S, 1, j - 1);
      S := Copy(S, j + 1, Length(S) - j);
      //ȡ�¼���Ϣ
      j := Pos(';', S);
      EventObj.GetUnitMessageForName(EventSystem.PLC_EventOut[i].UnitMsg, Copy(S, 1, j - 1));
      Setlength(EventSystem.PLC_EventOut[i].UnitMsg.Value, EventSystem.PLC_EventOut[i].UnitMsg.Size);
      //�¼�ȡֵ
      S := Copy(S, j + 1, Length(S) - j);
      for k := 0 to Length(EventSystem.PLC_EventOut[i].UnitMsg.Value) - 1 do begin
        j := Pos(',', S);
        if j > 0 then begin
          EventSystem.PLC_EventOut[i].UnitMsg.Value[k] := ICFunction.TransStringToInteger(Copy(S, 1, j - 1));
          S := Copy(S, j + 1, Length(S) - j);
        end
        else
          EventSystem.PLC_EventOut[i].UnitMsg.Value[k] := 0;
      end;
      //�¼�״̬��ʼ��
      EventSystem.PLC_EventOut[i].Have := False;
    end;
    {
    Tot := MyIni.ReadInteger('��ʼ���¼�','����',0);
    Setlength(EventSystem.InitEventOut,Tot);
    for i := 0 to Tot-1 do begin
      S := MyIni.ReadString('��ʼ���¼�','�¼�'+FormatCurr('#0',i+1),'');
      SystemWorkground.InitEventOut[i] :=S;
      end;

    }
    PLCCommandList := TStringList.Create;
    Tot := MyIni.ReadInteger('PLC����', '����', 0);
    for i := 0 to Tot - 1 do begin
      S := MyIni.ReadString('PLC����', '����' + FormatCurr('#0', i + 1), '');
      PLCCommandList.Add(S);
    end;

  end;
  FreeAndNil(myIni);
end;





function EventUnitObj.TransStringToFloat(S: string): Real;
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

function EventUnitObj.TransStringToInteger(S: string): Integer;
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

end.
