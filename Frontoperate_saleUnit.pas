unit Frontoperate_saleUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, SPComm, Grids, DBGrids;

type
  Tfrm_Frontoperate_sale = class(TForm)
    comReader: TComm;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    BitBtn3: TBitBtn;
    BitBtn2: TBitBtn;
    Panel4: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Panel5: TPanel;
    Edit_ThisTimeValue: TEdit;
    Edit_TotalInvValue: TEdit;
    Edit_TotalChangeValue: TEdit;
    Edit_ID: TEdit;
    Edit_ThisTimeEB: TEdit;
    CheckBox_Update: TCheckBox;
    DBGrid2: TDBGrid;
    Label7: TLabel;
    Edit1: TEdit;
    Label8: TLabel;
    Edit2: TEdit;
    Label9: TLabel;
    Edit3: TEdit;
    Image1: TImage;
    procedure BitBtn3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_Frontoperate_sale: Tfrm_Frontoperate_sale;

implementation

{$R *.dfm}

procedure Tfrm_Frontoperate_sale.BitBtn3Click(Sender: TObject);
begin
  Close;
end;

end.
