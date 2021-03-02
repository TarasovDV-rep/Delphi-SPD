unit Unit_new_conn;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TForm_new_conn = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    e_name: TEdit;
    e_ip: TEdit;
    GroupBox3: TGroupBox;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_new_conn: TForm_new_conn;
  

implementation

uses Unit_dop;

{$R *.dfm}

procedure TForm_new_conn.BitBtn1Click(Sender: TObject);
var
    uzel1,uzel2,uzel3,name,ip : String;
begin

      uzel1 := t.FieldByName('uzel1').AsString;
      uzel2 := t.FieldByName('uzel2').AsString;
      uzel3 := t.FieldByName('uzel3').AsString;
      name := t.FieldByName('name').AsString;
      ip := t.FieldByName('ip').AsString;

      if BitBtn1.Caption='��������' then
      begin
       //�����������
       t.Edit;
       t.FieldByName('uzel1').AsString := uzel1;
       t.FieldByName('uzel2').AsString := uzel2;
       t.FieldByName('uzel3').AsString := uzel3;
       t.FieldByName('name').AsString := e_name.Text;
       t.FieldByName('ip').AsString := e_ip.Text;

       if im<>'' then  t.FieldByName('image').AsString := im;

       t.Post;

       Close;
      end;

      if BitBtn1.Caption='��������' then
      begin
       //��������
       if not(t.Lookup('name',e_name.Text,'name')=e_name.Text) then
       begin
        t.Append;
        t.Edit;
        t.FieldByName('uzel1').AsString := uzel1;
        t.FieldByName('uzel2').AsString := uzel2;
        t.FieldByName('uzel3').AsString := uzel3;
        t.FieldByName('name').AsString := e_name.Text;
        t.FieldByName('ip').AsString := e_ip.Text;

        if im<>'' then  t.FieldByName('image').AsString := im;

        t.Post;

        Close;
       end
       else
       begin
        MessageBox(handle,'����� ���������� ��� ����������!','',0);
       end;

      end;



end;

procedure TForm_new_conn.BitBtn2Click(Sender: TObject);
begin
      Close;
end;

procedure TForm_new_conn.FormShow(Sender: TObject);
var
    uzel1,uzel2,uzel3,name,ip : String;
begin
      e_name.SetFocus;

      uzel1 := t.FieldByName('uzel1').AsString;
      uzel2 := t.FieldByName('uzel2').AsString;
      uzel3 := t.FieldByName('uzel3').AsString;
      name := t.FieldByName('name').AsString;
      ip := t.FieldByName('ip').AsString;

      im := '';

      //e_name.Text := name;
      //e_ip.Text := ip;

end;

procedure TForm_new_conn.SpeedButton1Click(Sender: TObject);
begin
      im := '0';
      BitBtn1Click(nil);


end;

procedure TForm_new_conn.SpeedButton2Click(Sender: TObject);
begin
      im := '1';
      BitBtn1Click(nil);

end;

procedure TForm_new_conn.SpeedButton3Click(Sender: TObject);
begin
      im := '2';
      BitBtn1Click(nil);

end;

procedure TForm_new_conn.SpeedButton4Click(Sender: TObject);
begin
      im := '12';
      BitBtn1Click(nil);

end;

end.
