unit IC_SetParameter_syspwdmanageUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  Tfrm_IC_SetParameter_syspwdmanage = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Edit1: TEdit;
    Label4: TLabel;
    Edit3: TEdit;
    Label5: TLabel;
    Edit4: TEdit;
    Label6: TLabel;
    procedure BitBtn3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_IC_SetParameter_syspwdmanage: Tfrm_IC_SetParameter_syspwdmanage;

implementation

{$R *.dfm}

procedure Tfrm_IC_SetParameter_syspwdmanage.BitBtn3Click(Sender: TObject);
begin
  Close;
end;

end.
