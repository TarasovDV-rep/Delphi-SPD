unit Unit_new_uzel;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TForm_new_uzel = class(TForm)
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Panel2: TPanel;
    GroupBox2: TGroupBox;
    e_name: TEdit;
    procedure e_nameKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_new_uzel: TForm_new_uzel;

implementation

uses Unit_dop;

{$R *.dfm}

procedure TForm_new_uzel.BitBtn1Click(Sender: TObject);
begin
      name_new_usel := e_name.Text;
      Close;
end;

procedure TForm_new_uzel.BitBtn2Click(Sender: TObject);
begin
      name_new_usel := '';
      Close;
end;

procedure TForm_new_uzel.e_nameKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if key=13 then  BitBtn1Click(nil);
    
end;

procedure TForm_new_uzel.FormShow(Sender: TObject);
begin
      e_name.SetFocus;
end;

end.
