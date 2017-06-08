program Prg_IC;

uses
  Forms,
  ICmain in 'ICmain.pas' {Frm_IC_Main},
  ICDataModule in 'ICDataModule.pas' {DataModule_3F: TDataModule},
  ICFunctionUnit in 'ICFunctionUnit.pas',
  ICCommunalConstUnit in 'ICCommunalConstUnit.pas',
  ICCommunalVarUnit in 'ICCommunalVarUnit.pas',
  ICEventTypeUnit in 'ICEventTypeUnit.pas',
  Logon in 'Logon.pas' {Frm_Logon},
  SPComm in 'Spcomm.pas',
  Frame_Top in 'Frame_Top.pas' {fram_top: TFrame},
  FrontoperateUnit in 'FrontoperateUnit.pas' {frm_frontoperate},
  BehindoperateUnit in 'BehindoperateUnit.pas' {frm_Behindoperate},
  SetParameterUnit in 'SetParameterUnit.pas' {frm_SetParameter},
  FileinputUnit in 'FileinputUnit.pas' {frm_Fileinput},
  AculateUnit in 'AculateUnit.pas' {frm_Aculate},
  Frontoperate_newuserUnit in 'Frontoperate_newuserUnit.pas' {frm_Frontoperate_newuser},
  Frontoperate_incvalueUnit in 'Frontoperate_incvalueUnit.pas' {frm_Frontoperate_incvalue},
  Frontoperate_pwdchangeUnit in 'Frontoperate_pwdchangeUnit.pas' {frm_Frontoperate_pwdchange},
  Frontoperate_lostuserUnit in 'Frontoperate_lostuserUnit.pas' {frm_Frontoperate_lostuser},
  Frontoperate_renewuserUnit in 'Frontoperate_renewuserUnit.pas' {frm_Frontoperate_renewuser},
  Frontoperate_lostvalueUnit in 'Frontoperate_lostvalueUnit.pas' {frm_Frontoperate_lostvalue},
  Frontoperate_userbackUnit in 'Frontoperate_userbackUnit.pas' {frm_Frontoperate_userback},
  Frontoperate_saleUnit in 'Frontoperate_saleUnit.pas' {frm_Frontoperate_sale},
  Fileinput_menberforUnit in 'Fileinput_menberforUnit.pas' {frm_Fileinput_menberfor},
  Fileinput_machinerecordUnit in 'Fileinput_machinerecordUnit.pas' {frm_Fileinput_machinerecord},
  Fileinput_machinerstateUnit in 'Fileinput_machinerstateUnit.pas' {frm_Fileinput_machinerstate},
  Fileinput_prezentqueryUnit in 'Fileinput_prezentqueryUnit.pas' {frm_Fileinput_prezentquery},
  Fileinput_prezentmatialUnit in 'Fileinput_prezentmatialUnit.pas' {frm_Fileinput_prezentmatial},
  Fileinput_cardsaleUnit in 'Fileinput_cardsaleUnit.pas' {frm_Fileinput_cardsale},
  Fileinput_menbermatialUnit in 'Fileinput_menbermatialUnit.pas' {frm_Fileinput_menbermatial},
  Fileinput_menbermatialupdateUnit in 'Fileinput_menbermatialupdateUnit.pas' {frm_Fileinput_menbermatialupdate},
  Fileinput_gamenameinputUnit in 'Fileinput_gamenameinputUnit.pas' {frm_Fileinput_gamenameinput},
  Fileinput_machinerecord_gamenameUnit in 'Fileinput_machinerecord_gamenameUnit.pas' {frm_Fileinput_machinerecord_gamename},
  IC_SetParameter_softparasetUnit in 'IC_SetParameter_softparasetUnit.pas' {frm_IC_SetParameter_softparaset},
  IC_SetParameter_operatemaryUnit in 'IC_SetParameter_operatemaryUnit.pas' {frm_IC_SetParameter_operatemary},
  IC_SetParameter_cardsalepwdchangeUnit in 'IC_SetParameter_cardsalepwdchangeUnit.pas' {frm_IC_SetParameter_cardsalepwdchange},
  IC_SetParameter_syspwdmanageUnit in 'IC_SetParameter_syspwdmanageUnit.pas' {frm_IC_SetParameter_syspwdmanage},
  IC_SetParameter_RightmanageUnit in 'IC_SetParameter_RightmanageUnit.pas' {frm_IC_SetParameter_Rightmanage},
  IC_SetParameter_datamentainUnit in 'IC_SetParameter_datamentainUnit.pas' {frm_IC_SetParameter_datamentain},
  IC_Report_ClasschangeUnit in 'IC_Report_ClasschangeUnit.pas' {frm_IC_Report_Classchange},
  IC_Report_SaleUnit in 'IC_Report_SaleUnit.pas' {frm_IC_Report_SaleDetial},
  IC_Report_MenberinfoUnit in 'IC_Report_MenberinfoUnit.pas' {frm_IC_Report_Menberinfo},
  IC_Report_SaletotalUnit in 'IC_Report_SaletotalUnit.pas' {frm_IC_Report_Saletotal},
  IC_Report_FunctionMCUnit in 'IC_Report_FunctionMCUnit.pas' {frm_IC_Report_FunctionMC},
  IC_485Testmain in 'IC_485Testmain.pas' {frm_IC_485Testmain},
  Frontoperate_EBincvalueUnit in 'Frontoperate_EBincvalueUnit.pas' {frm_Frontoperate_EBincvalue},
  QC_AE_LineBarscanUnit in 'QC_AE_LineBarscanUnit.pas' {frm_QC_AE_LineBarscan},
  ICtest_Main in 'ICtest_Main.pas' {frm_ictest_main},
  Frontoperate_InitIDUnit in 'Frontoperate_InitIDUnit.pas' {frm_Frontoperate_InitID},
  IC_SetParameter_BossUnit in 'IC_SetParameter_BossUnit.pas' {frm_SetParameter_Boss},
  IC_SetParameter_BossINITUnit in 'IC_SetParameter_BossINITUnit.pas' {frm_SetParameter_BossINIT},
  IC_SetParameter_BossMaxValueUnit in 'IC_SetParameter_BossMaxValueUnit.pas' {frm_SetParameter_BossMaxValue},
  frm_SetParameter_CardMCIDINITUnit in 'frm_SetParameter_CardMCIDINITUnit.pas' {frm_SetParameter_CardMC_IDINIT},
  Frontoperate_InitCardIDUnit in 'Frontoperate_InitCardIDUnit.pas' {Frontoperate_InitCardID},
  AboutUnit in 'AboutUnit.pas' {Frm_About},
  Frontoperate_newCustomerUnit in 'Frontoperate_newCustomerUnit.pas' {frm_Frontoperate_newCustomer},
  IC_SetParameter_DataBaseInitUnit in 'IC_SetParameter_DataBaseInitUnit.pas' {frm_IC_SetParameter_DataBaseInit},
  IC_SetParameter_BiLiUnit in 'IC_SetParameter_BiLiUnit.pas' {frm_SetParameter_BILI_INIT},
  IC_SetParameter_MaxDateUnit in 'IC_SetParameter_MaxDateUnit.pas' {frm_SetParameter_MaxDate},
  IC_SetParameter_MenberControlUnit in 'IC_SetParameter_MenberControlUnit.pas' {frm_SetParameter_MenberControl_INIT},
  RegUnit in 'RegUnit.pas' {frm_Reg},
  strprocess in 'strprocess.pas',
  DateProcess in 'DateProcess.pas',
  check_detail in 'check_detail.pas' {frm_check_detail};


{$R *.res}

begin
  Application.Initialize;
  Application.Title := '场地管理系统20170608';
  Application.CreateForm(TFrm_Logon, Frm_Logon);
  Application.CreateForm(TDataModule_3F, DataModule_3F);
  Application.CreateForm(TFrm_IC_Main, Frm_IC_Main);
  Application.CreateForm(Tfrm_frontoperate, frm_frontoperate);
  Application.CreateForm(Tfrm_Behindoperate, frm_Behindoperate);
  Application.CreateForm(Tfrm_SetParameter, frm_SetParameter);
  Application.CreateForm(Tfrm_Fileinput, frm_Fileinput);
  Application.CreateForm(Tfrm_Aculate, frm_Aculate);
  Application.CreateForm(Tfrm_Frontoperate_newuser, frm_Frontoperate_newuser);
  Application.CreateForm(Tfrm_Frontoperate_incvalue, frm_Frontoperate_incvalue);
  Application.CreateForm(Tfrm_Frontoperate_pwdchange, frm_Frontoperate_pwdchange);
  Application.CreateForm(Tfrm_Frontoperate_lostuser, frm_Frontoperate_lostuser);
  Application.CreateForm(Tfrm_Frontoperate_renewuser, frm_Frontoperate_renewuser);
  Application.CreateForm(Tfrm_Frontoperate_lostvalue, frm_Frontoperate_lostvalue);
  Application.CreateForm(Tfrm_Frontoperate_userback, frm_Frontoperate_userback);
  Application.CreateForm(Tfrm_Frontoperate_sale, frm_Frontoperate_sale);
  Application.CreateForm(Tfrm_Fileinput_menberfor, frm_Fileinput_menberfor);
  Application.CreateForm(Tfrm_Fileinput_machinerecord, frm_Fileinput_machinerecord);
  Application.CreateForm(Tfrm_Fileinput_machinerstate, frm_Fileinput_machinerstate);
  Application.CreateForm(Tfrm_Fileinput_prezentquery, frm_Fileinput_prezentquery);
  Application.CreateForm(Tfrm_Fileinput_prezentmatial, frm_Fileinput_prezentmatial);
  Application.CreateForm(Tfrm_Fileinput_cardsale, frm_Fileinput_cardsale);
  Application.CreateForm(Tfrm_Fileinput_menbermatial, frm_Fileinput_menbermatial);
  Application.CreateForm(Tfrm_Fileinput_menbermatialupdate, frm_Fileinput_menbermatialupdate);
  Application.CreateForm(Tfrm_Fileinput_gamenameinput, frm_Fileinput_gamenameinput);
  Application.CreateForm(Tfrm_Fileinput_machinerecord_gamename, frm_Fileinput_machinerecord_gamename);
  Application.CreateForm(Tfrm_IC_SetParameter_softparaset, frm_IC_SetParameter_softparaset);
  Application.CreateForm(Tfrm_IC_SetParameter_operatemary, frm_IC_SetParameter_operatemary);
  Application.CreateForm(Tfrm_IC_SetParameter_cardsalepwdchange, frm_IC_SetParameter_cardsalepwdchange);
  Application.CreateForm(Tfrm_IC_SetParameter_syspwdmanage, frm_IC_SetParameter_syspwdmanage);
  Application.CreateForm(Tfrm_IC_SetParameter_Rightmanage, frm_IC_SetParameter_Rightmanage);
  Application.CreateForm(Tfrm_IC_SetParameter_datamentain, frm_IC_SetParameter_datamentain);
  Application.CreateForm(Tfrm_IC_Report_Classchange, frm_IC_Report_Classchange);
  Application.CreateForm(Tfrm_IC_Report_SaleDetial, frm_IC_Report_SaleDetial);
  Application.CreateForm(Tfrm_IC_Report_Menberinfo, frm_IC_Report_Menberinfo);
  Application.CreateForm(Tfrm_IC_Report_Saletotal, frm_IC_Report_Saletotal);
  Application.CreateForm(Tfrm_IC_Report_FunctionMC, frm_IC_Report_FunctionMC);
  Application.CreateForm(Tfrm_IC_485Testmain, frm_IC_485Testmain);
  Application.CreateForm(Tfrm_Frontoperate_EBincvalue, frm_Frontoperate_EBincvalue);
  Application.CreateForm(Tfrm_QC_AE_LineBarscan, frm_QC_AE_LineBarscan);
  Application.CreateForm(Tfrm_ictest_main, frm_ictest_main);
  Application.CreateForm(Tfrm_Frontoperate_InitID, frm_Frontoperate_InitID);
  Application.CreateForm(Tfrm_SetParameter_Boss, frm_SetParameter_Boss);
  Application.CreateForm(Tfrm_SetParameter_BossINIT, frm_SetParameter_BossINIT);
  Application.CreateForm(Tfrm_SetParameter_BossMaxValue, frm_SetParameter_BossMaxValue);
  Application.CreateForm(Tfrm_SetParameter_CardMC_IDINIT, frm_SetParameter_CardMC_IDINIT);
  Application.CreateForm(TFrontoperate_InitCardID, Frontoperate_InitCardID);
  Application.CreateForm(TFrm_About, Frm_About);
  Application.CreateForm(Tfrm_Frontoperate_newCustomer, frm_Frontoperate_newCustomer);
  Application.CreateForm(Tfrm_IC_SetParameter_DataBaseInit, frm_IC_SetParameter_DataBaseInit);
  Application.CreateForm(Tfrm_SetParameter_BILI_INIT, frm_SetParameter_BILI_INIT);
  Application.CreateForm(Tfrm_SetParameter_MaxDate, frm_SetParameter_MaxDate);
  Application.CreateForm(Tfrm_SetParameter_MenberControl_INIT, frm_SetParameter_MenberControl_INIT);
  Application.CreateForm(Tfrm_Reg, frm_Reg);
  Application.CreateForm(Tfrm_check_detail, frm_check_detail);
  Application.Run;
end.

