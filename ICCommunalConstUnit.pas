unit ICCommunalConstUnit;

interface
uses Graphics;

const
  Title = '�����������';
  UpdateTime = '20100801';
  Ver = 'V1.0.00';

  Unit_All = 1;
  Unit_Input = 2;
  Unit_Output = 3;

  IMeasure_First = 1; //��Ȧ��ѡ
  IMeasure_Second = 2; //��Ȧ����
  OMeasure = 3; //��Ȧ����

  MaxMeasureBuffer = 1024; //�ݴ��������Ļ�����

  OKNG_Normal = 0;
  OKNG_OK = 1;
  OKNG_NG = 2;

  WorkStatus_Parameter = 10;
  WorkStatus_DeviceTest = 20;
  WorkStatus_Recorder = 30;
  WorkStatus_Working = 40;
  WorkStatus_Ready = 50;

  WorkStatus_DeviceSetting = 0; //�豸������������
  WorkStatus_MeasureSetting = 1; //����������������
  WorkStatus_PLCEventSetting = 2; //PLCͨѶ�¼�����
  WorkStatus_StandardSetting = 3; //������׼����
  WorkStatus_ProgramSetting = 4; //������������

  EventMsgNumber = 16;
implementation

end.
