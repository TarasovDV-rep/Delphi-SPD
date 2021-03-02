unit Unit_client;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,db,shellapi,
  Dialogs, ComCtrls, ToolWin, ExtCtrls, ImgList, kbmMemTable, GridsEh, DBGridEh,Unit_new_conn,Unit_new_uzel,
  Menus,Unit_dop, StdCtrls,winsock,vclzip,DateUtils;

type
  TForm_client = class(TForm)
    ToolBar1: TToolBar;
    Panel1: TPanel;
    ToolButton1: TToolButton;
    ImageList1: TImageList;
    Splitter1: TSplitter;
    Panel2: TPanel;
    gr: TDBGridEh;
    ToolButton3: TToolButton;
    ToolButton5: TToolButton;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    ToolButton6: TToolButton;
    ToolButton8: TToolButton;
    ToolButton10: TToolButton;
    ToolButton13: TToolButton;
    ToolButton15: TToolButton;
    ToolButton16: TToolButton;
    ToolButton11: TToolButton;
    ToolButton2: TToolButton;
    ToolButton4: TToolButton;
    ToolButton7: TToolButton;
    ToolButton9: TToolButton;
    ToolButton12: TToolButton;
    Panel3: TPanel;
    tv: TTreeView;
    GroupBox1: TGroupBox;
    poisk_uzel: TEdit;
    GroupBox2: TGroupBox;
    poisk_soed: TEdit;
    ToolButton14: TToolButton;
    ToolButton17: TToolButton;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    Button1: TButton;
    im_e: TEdit;
    GroupBox5: TGroupBox;
    ip_e: TEdit;
    ToolButton18: TToolButton;
    ToolButton19: TToolButton;
    ToolButton20: TToolButton;
    procedure ToolButton19Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure im_eEnter(Sender: TObject);
    procedure ip_eEnter(Sender: TObject);
    procedure ToolButton14Click(Sender: TObject);
    procedure poisk_soedChange(Sender: TObject);
    procedure poisk_soedEnter(Sender: TObject);
    procedure poisk_uzelEnter(Sender: TObject);
    procedure poisk_uzelChange(Sender: TObject);
    procedure grEnter(Sender: TObject);
    procedure tvEnter(Sender: TObject);
    procedure ToolButton12Click(Sender: TObject);
    procedure ToolButton9Click(Sender: TObject);
    procedure ToolButton7Click(Sender: TObject);
    procedure ToolButton4Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure grTitleClick(Column: TColumnEh);
    procedure ToolButton11Click(Sender: TObject);
    procedure ToolButton15Click(Sender: TObject);
    procedure ToolButton16Click(Sender: TObject);
    procedure ToolButton10Click(Sender: TObject);
    procedure ToolButton8Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ToolButton5Click(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure grDblClick(Sender: TObject);
    procedure tvClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_client: TForm_client;
  uge_ishem : Boolean;

implementation

{$R *.dfm}


function GetIPFromHost(const HostName: string): string;
type
  TaPInAddr = array[0..10] of PInAddr;
  PaPInAddr = ^TaPInAddr;
var
  phe: PHostEnt; 
  pptr: PaPInAddr;
  i: Integer;
  GInitData: TWSAData; 
begin
  WSAStartup($101, GInitData);
  Result := '';
  phe := GetHostByName(PChar(HostName));
  if phe = nil then Exit;
  pPtr := PaPInAddr(phe^.h_addr_list); 
  i := 0; 
  while pPtr^[i] <> nil do 
  begin 
    Result := inet_ntoa(pptr^[i]^); 
    Inc(i); 
  end; 
  WSACleanup; 
end;

function IPAddrToName(IPAddr : string): string;
var
  SockAddrIn: TSockAddrIn;
  HostEnt: PHostEnt;
  WSAData: TWSAData;
begin
  WSAStartup($101, WSAData);
  SockAddrIn.sin_addr.s_addr:= inet_addr(PChar(IPAddr));
  HostEnt:= gethostbyaddr(@SockAddrIn.sin_addr.S_addr, 4, AF_INET);
  if HostEnt <> nil then
    result := StrPas(Hostent^.h_name)
  else
    result:='';
end;


function ZamSym(str,substr,repl:String):String;
var
i : Integer;
wrstr1 : String;             
begin
      wrstr1 := str;
      while Pos(substr,wrstr1) <> 0 do
      begin
       i := Pos(substr,wrstr1);
       Delete(wrstr1,Pos(substr,wrstr1),Length(substr));
       Insert(repl,wrstr1,i);
      end;

      Result := wrstr1;
end;

function Vib_elm_str(stroka,razdel :string; nomer :integer; flag :boolean;pst:string='?' ):string ;
var
    wrstr,r,elm : String;
    pos1 : Integer;
begin
      r := razdel;           
      wrstr := stroka;

      if wrstr <> '' then
      begin

      //������� ����������� ��������� ��� 1-�?(flag = True)
      if flag then wrstr := ZamSym(wrstr,razdel+razdel,razdel);
      wrstr := wrstr+r;
      //���� �� ����������� ������ - ���� ���, �� 1-� �������

      if Pos(r,wrstr) <> 0 then
      begin
       //����. ���� - ����
       pos1 := 1;
       while pos1 < nomer do
       begin
        if Copy(wrstr,1,Length(r)) = r then
        begin
         //������ �������
         Delete(wrstr,1,Length(r));
        end
        else
        begin
         Delete(wrstr,1,Pos(r,wrstr)-1+Length(r));
        end;
        pos1 := pos1+1;
       end;
       if Copy(wrstr,1,Length(r)) = r then
       begin
        //������ �������
        Result := pst;
       end
       else
       begin
        Result := Copy(wrstr,1,Pos(r,wrstr)-1);
       end;
      end
      else
      begin
       //1-� �������
       Result := wrstr;
      end;
      end
      else
      begin
       Result := pst;
      end;
end;
function Kol_elm_str(stroka,razdel :string; flag :boolean ):integer ;
var
kol,n_pos :integer;
str :string;
begin
  str:=stroka;
  kol:=0;
  while str<>'' do
  begin
    n_pos:=pos(razdel,str);
    if n_pos<>0 then
    begin
      str:=copy(str,n_pos+Length(razdel),Length(str)-n_pos);
      kol:=kol+1;
    end
    else
    begin
      str:='';
      Break;
    end;
    while (copy(str,1,Length(razdel))=razdel) and flag do
    begin
      if Length(str)>1 then
        str:=copy(str,2,Length(str)-1)
      else
      begin
        str:='';
        Break;
      end;
    end;
  end;
  Kol_elm_str:=kol+1;
end;


//�������� �������
//typ_pol:String='!ftString!' -> ����� ��� ���� ��������� ����� ����� ������� ���� �����
//ftString
//
function CreateMemoryTable(strkt2pp,strtext:String;filtrvisible_pole:String='';
         filtrvisible_pole_zn:String='';edinstv_pole:String='';typ_pol:String='!ftString!';
         index_pol:String=''):TkbmMemTable;
var
    MemoryD:TkbmMemTable;
    i,j : integer;
    pole,dlpol,wrstr,str1,wr : String;
    dann : TStringList;
    del : Boolean;
begin
      dann := TStringList.Create;
      dann.Clear;
      dann.Text := strtext;

      wrstr := strkt2pp;
      //������� �������
      MemoryD := TkbmMemTable.Create(NIL);

//      MemoryD := TRxMemoryData.Create(NIL);
      //������� ���������
      for i:=1 to Kol_elm_str(wrstr,',',True) do
      begin
       str1 :=  Vib_elm_str(wrstr,',',i,True);
       pole :=  Vib_elm_str(str1,':',1,True);
       dlpol := Vib_elm_str(str1,':',2,True);
       if typ_pol = '!ftString!' then
       begin
        //��� ���� ���������
        MemoryD.FieldDefs.Add(pole,ftString,StrToInt(dlpol)); //,True);
       end
       else
       begin

        //�� �����
        if Vib_elm_str(typ_pol,',',i,True) = 'ftString' then
        begin
         MemoryD.FieldDefs.Add(pole,ftString,StrToInt(dlpol));
        end;
        if Vib_elm_str(typ_pol,',',i,True) = 'ftInteger' then
        begin
         MemoryD.FieldDefs.Add(pole,ftInteger,0);
        end;
        if Vib_elm_str(typ_pol,',',i,True) = 'ftBoolean' then
        begin
         MemoryD.FieldDefs.Add(pole,ftBoolean,0);
        end;
        if Vib_elm_str(typ_pol,',',i,True) = 'ftFloat' then
        begin
         MemoryD.FieldDefs.Add(pole,ftFloat,0);
        end;
        if Vib_elm_str(typ_pol,',',i,True) = 'ftDate' then
        begin
         MemoryD.FieldDefs.Add(pole,ftDate,0);
        end;
        if Vib_elm_str(typ_pol,',',i,True) = 'ftTime' then
        begin
         MemoryD.FieldDefs.Add(pole,ftTime,0);
        end;
        if Vib_elm_str(typ_pol,',',i,True) = 'ftDateTime' then
        begin
         MemoryD.FieldDefs.Add(pole,ftDateTime,0);
        end;

       end;
      end;

      //�������, ���� ����
      if index_pol <> '' then
      begin
       for j := 1 to Kol_Elm_Str(index_pol,',',False) do
       begin
        wr := Vib_Elm_Str(index_pol,',',j,False);
        if Vib_Elm_Str(wr,':',2,False) = 'IxDescending' then
        begin
         MemoryD.IndexDefs.Add(Vib_Elm_Str(wr,':',1,False),Vib_Elm_Str(wr,':',1,False),[IxDescending]);
        end
        else
        begin
         MemoryD.IndexDefs.Add(Vib_Elm_Str(wr,':',1,False),Vib_Elm_Str(wr,':',1,False),[]);
        end;
       end;
      end;
      //��������� �������
//      MemoryD.AfterDelete.Filter := 'put = 02';
//      MemoryD.Filtered := True;
      MemoryD.Open;//.FieldList.Strings[0];
      for j := 0 to dann.Count-1 do
      begin
       MemoryD.Append;
       MemoryD.Edit;
       for i:=1 to Kol_elm_str(wrstr,',',True) do
       begin
        str1 :=  Vib_elm_str(wrstr,',',i,True);
        pole :=  Vib_elm_str(str1,':',1,True);


        MemoryD.FieldByName(pole).AsString := Vib_elm_str(dann.Strings[j],' ',i,True);


       end;
       MemoryD.Post;
      end;

      //���� ������ ����, �� ������ ��������
      if filtrvisible_pole <> '' then
      begin
       MemoryD.First;
       while not MemoryD.Eof do
       begin
        del := True;
        for i := 1 to Kol_elm_str(filtrvisible_pole_zn,',',True) do
        begin
         if MemoryD.FieldByName(filtrvisible_pole).AsString = Vib_elm_str(filtrvisible_pole_zn,',',i,True) then
         begin
          del := False;
         end;
        end;
        if del then
        begin
         MemoryD.Delete;
        end
        else
        begin
        MemoryD.Next;
        end;
       end;
      end;

      // ���� ������� ���� 'edinstv_pole' �� ������ ��� ������������� ������
      if edinstv_pole <> '' then
      begin
       dann.Clear;
       MemoryD.First;
       dann.Add(MemoryD.FieldByName(edinstv_pole).AsString);
       MemoryD.Next;
       for j := 1 to MemoryD.RecordCount-1 do
       begin
        del := False;
        for i := 0 to dann.Count-1 do
        begin
         if MemoryD.FieldByName(edinstv_pole).AsString = dann.Strings[i] then
         begin
          del  := True;
         end;
        end;
        if del then
        begin
         MemoryD.Delete;
        end
        else
        begin
         dann.Add(MemoryD.FieldByName(edinstv_pole).AsString);
         MemoryD.Next;
        end;
       end;
      end;


      Result := MemoryD;
end;

//�������� �� ����������� ��������������
//������ � �����
function ValidStrToInt(str : String;dop : String = ''): Boolean;
var
    i,j : Integer;
    s : String;
    prv : Boolean;
begin
      Result := False;
      if str <> '' then
      begin
       s := '0123456789'+dop;
       Result := True;
       i := 1;
       while (i <= Length(str)) and (Result) do
       begin
        j := 1;
        prv := False;
        while (j <= Length(s)) and (not prv) do
        begin
         if str[i] = s[j] then  prv := True;
         j := j+1;
        end;
        if not prv then Result := False;
        i := i+1;
       end;
      end;

end;

function LeftPadChS(Str,Dop:String;kols:Integer):String;
begin
      while Length(Str) < kols do
      begin
       Str := Dop+Str;
      end;
      Result := Str;
end;

function RightPadChS(Str,Dop:String;kols:Integer):String;
begin
      while Length(Str) < kols do
      begin
       Str := Str+Dop;
      end;
      Result := Str;
end;

procedure SaveTekJrn(SysSoob : String;dop:String='';kolarh:integer=7);
var
    str,dd,mm,gggg,schas,min,sec,imfile,arhname:String;
    ms : TStringList;
    d1,d2,d3,t1,t2,t3,t4 : Word;
//    ff : TextFile;
    zip : TVCLZip;
    f,f1 : TSearchRec;
    i : integer;
    tab : TkbmMemTable;
begin


     ms := TStringList.Create;
     tab := CreateMemoryTable('imf:255,dt:30','','','','','ftString,ftDateTime','dt');

     try
      tab.IndexName := 'dt';

      // �������� ������� �������� JRN � arh
      if not DirectoryExists(ExtractFilePath(Application.ExeName)+'JRN')  then
             ForceDirectories(ExtractFilePath(Application.ExeName)+'JRN');
      if not DirectoryExists(ExtractFilePath(Application.ExeName)+'JRN\arh')  then
             ForceDirectories(ExtractFilePath(Application.ExeName)+'JRN\arh');


      // �������� ������� �������� �����
      DecodeDate(Now,d1,d2,d3);
      DecodeTime(Now,t1,t2,t3,t4);
      gggg := LeftPadChS(IntToStr(d1),'0',4);
      mm := LeftPadChS(IntToStr(d2),'0',2);
      dd := LeftPadChS(IntToStr(d3),'0',2);
      schas := LeftPadChS(IntToStr(t1),'0',3);
      min := IntToStr(t2);
      imfile := ExtractFilePath(Application.ExeName)+'JRN\'+gggg+mm+dd+schas+'.jrn';//+min;
      //���� 1-� ���  �� ������������ ���, ��� ���� ������� � jrn\mes_arh
      if HourOf(Now) = 1 then
      begin
       //��� ������ - ���+���+����
       arhname := IntToStr(YearOf(Now)) + IntToStr(MonthOf(Now))+
                  IntToStr(DayOf(Now))+'.zip';
       zip := TVCLZip.Create(Application);
       //���� ����� ����� ���� �� �� ���� - ���!
       if not FileExists(ExtractFilePath(Application.ExeName)+'jrn\arh\'+arhname) then
       begin
        if FindFirst(ExtractFilePath(Application.ExeName)+'jrn\*.*',0,f) = 0 then
        begin
         //���� ����� ��������
         zip.FilesList.Add(ExtractFilePath(Application.ExeName)+'jrn\'+f.Name);
         while FindNext(f) = 0 do
         begin
          zip.FilesList.Add(ExtractFilePath(Application.ExeName)+'jrn\'+f.Name);
         end;
         FindClose(f);
        end;
        zip.ZipName := ExtractFilePath(Application.ExeName)+'jrn\arh\'+arhname;

        try
         zip.Zip;
        except
        end;
        //������ ��, ��� ��������������
        for i := 0 to zip.FilesList.Count-1 do
        begin
         DeleteFile(zip.FilesList.Strings[i]);
        end;
       end;
       zip.Free;
      end;

      //�������� ���-�� ������� - ������ �������
      if FindFirst(ExtractFilePath(Application.ExeName)+'jrn\arh\*.zip',0,f1) = 0 then
      begin
       //�������� �������
       tab.Append;
       tab.Edit;
       tab.FieldByName('imf').AsString := ExtractFilePath(Application.ExeName)+'jrn\arh\'+f1.Name;
       tab.FieldByName('dt').AsDateTime := FileDateToDateTime(f1.Time);
       tab.Post;
       while FindNext(f1) = 0 do
       begin
        tab.Append;
        tab.Edit;
        tab.FieldByName('imf').AsString := ExtractFilePath(Application.ExeName)+'jrn\arh\'+f1.Name;
        tab.FieldByName('dt').AsDateTime := FileDateToDateTime(f1.Time);
        tab.Post;
       end;
      end;
      //������ ������ ������
      tab.Last;
      while not tab.Bof do
      begin
       if tab.RecordCount-tab.RecNo>kolarh then
       begin
        DeleteFile(tab.FieldByName('imf').AsString);
       end;
       tab.Prior;
      end;


//      AssignFile(ff,imfile);
      if FileExists(imfile) then
      begin
       ms.LoadFromFile(imfile);
//       Rewrite(ff);
//       CloseFile(ff);
      end;
       ms.Add(DateTimeToStr(Now)+' -> '+ #13+#10+SysSoob);
       if dop <> '' then ms.Add('"'+dop+'"');
       ms.SaveToFile(imfile);
//      //������� ��� ����������
//      Append(ff);
//      Writeln(ff,DateTimeToStr(Now)+' -> '+ #13+#10+SysSoob);
//      CloseFile(ff);

     except
     // SaveTekJrn('��. ��� ������:'+SysSoob);
     end;

     ms.Free;
     tab.Free;

end;



procedure TForm_client.Button1Click(Sender: TObject);
begin
      if (ip_e.Text='') and (im_e.Text<>'') then
      begin
       ip_e.Text := GetIPFromHost(im_e.Text);
      end
      else
      begin
       im_e.Text := IPAddrToName(ip_e.Text);
      end;
end;

procedure TForm_client.FormClose(Sender: TObject; var Action: TCloseAction);
var
    ms : TStringList;
    wr : String;
begin

      ms := TStringList.Create;

      //��� �������� ����� ������� � ��������� ���� � �������
      wr := IntToStr(Left)+'[|]'+IntToStr(Top)+'[|]'+IntToStr(Width)+'[|]'+IntToStr(Height)+'[|]'+
            IntToStr(gr.Columns[3].Width)+'[|]'+IntToStr(gr.Columns[4].Width);

      //������� ������ ����
      t.Filtered := False;
      t.First;

      ms.Add(wr);

      while not t.Eof do
      begin
       wr := t.FieldByName('uzel1').AsString+'[|]'+
             t.FieldByName('uzel2').AsString+'[|]'+
             t.FieldByName('uzel3').AsString+'[|]'+
             t.FieldByName('name').AsString +'[|]'+
             t.FieldByName('ip').AsString+'[|]'+
             t.FieldByName('image').AsString;


       ms.Add(wr);
       t.Next;
      end;
      ms.SaveToFile(ExtractFilePath(Application.ExeName)+'IVClient.ini');


      ms.Free;

end;

procedure TForm_client.FormShow(Sender: TObject);
var
    ms : TSTringList;
    i,j,k,l : integer;
    wr,wr1,wr2,wr3,name,ip,ss : String;
    pr : Boolean;
begin
      ms := TSTringList.Create;
      ds := TDataSource.Create(nil);
      t := CreateMemoryTable('uzel1:30,uzel2:30,uzel3:30,name:80,ip:30,image:2','','','','','!ftString!','name,ip,uzel1,uzel2');

      //����� ����� ����
      tv.Items.Add(nil,'���...');

      //gr.TitleImages := ImageList1;
      SaveTekJrn(DateTimeToStr(now)+' : ����� ���������.');

      //���� ������ ����?
      if not FileExists(ExtractFilePath(Application.ExeName)+'IVClient.ini') then
      begin
       //���� - ����� �������
       SaveTekJrn(DateTimeToStr(now)+' : ������ ���-����� ���� ���� ���� �� �������.');
       if FileExists(ExtractFilePath(Application.ExeName)+'RClient.ini') then
       begin
        //���� �1
        ms.LoadFromFile(ExtractFilePath(Application.ExeName)+'RClient.ini');
        //�� connections
        l := 0;
        while Pos(LowerCase('[connections]'),LowerCase(ms.Strings[l]))=0 do
        begin
         l := l+1;
        end;

        for i := l to ms.Count - 1 do
        begin
         if Pos('Item',ms.Strings[i])<>0  then
         begin
          //������� ���� �1 =���� ��� ��� ������ ����
          wr := Vib_elm_str(ms.Strings[i],'=',2,True);
          ss := Vib_elm_str(wr,'|',1,True);
          wr1 := Vib_elm_str(ss,'\',1,True);
          wr2 := Vib_elm_str(ss,'\',2,True);
          wr3 := Vib_elm_str(ss,'\',3,True);
          name := Vib_elm_str(wr,'|',2,True);
          ip := Vib_elm_str(wr,'|',3,True);
          ip := Vib_elm_str(ip,'/',2,True);
          t.Append;
          t.Edit;
          t.FieldByName('uzel1').AsString := wr1;
          t.FieldByName('uzel2').AsString := wr2;
          t.FieldByName('uzel3').AsString := wr3;
          t.FieldByName('name').AsString := name;
          t.FieldByName('ip').AsString := ip;

          t.Post;

          pr := True;
          for j := 0 to tv.Items.Count - 1 do
          begin
           if (wr1+'..'=tv.Items.Item[j].Text) or (wr1='?') then pr := False;
          end;
          if pr then tv.Items.AddChild(tv.Items.Item[0],wr1+'..');//tv.Items.Add(nil,wr1);
         end;
        end;
        ms.Clear;
        //���� �2
        ms.LoadFromFile(ExtractFilePath(Application.ExeName)+'RClient.ini');
        for i := 0 to ms.Count - 1 do
        begin
         if Pos('Item',ms.Strings[i])<>0  then
         begin
          //������� ���� �2 =���� ��� ��� ������ ����
          wr := Vib_elm_str(ms.Strings[i],'=',2,True);
          wr := Vib_elm_str(wr,'|',1,True);
          wr1 := Vib_elm_str(wr,'\',1,True,'');
          wr := Vib_elm_str(wr,'\',2,True,'');
          if wr<>'' then
          begin
           //���� 2-� ����
           //���� ������ ����
           for j := 0 to tv.Items.Count - 1 do
           begin
            if wr1+'..'=tv.Items.Item[j].Text then
            begin
             //������� ������� ���� ������ ��� ����
             pr := True;
             for k := 0 to tv.Items.Count - 1 do
             begin
              if (wr+'....'=tv.Items.Item[k].Text) or (wr='?') then pr := False;
             end;
             if pr then tv.Items.AddChild(tv.Items.Item[j],wr+'....');
            end;
           end;

          end;
         end;
        end;
        ms.Clear;

        //t := CreateMemoryTable('uzel1:30;uzel2:30;uzel3:30;name:45;ip:30','');


       end
       else
       begin
        MessageBox(handle,'��� ini ������ ������!','!',0);
        SaveTekJrn(DateTimeToStr(now)+' : ��� ini ������ ������!');
       end;
      end
      else
      begin
       //��������� ���� ������
       ms.LoadFromFile(ExtractFilePath(Application.ExeName)+'IVClient.ini');
       SaveTekJrn(DateTimeToStr(now)+' : ��������� ���� ������.');
       //������� �� � ��������

       //wr := IntToStr(Left)+'[|]'+IntToStr(Top)+'[|]'+IntToStr(Width)+'[|]'+IntToStr(Height)+'[|]'+
       //     IntToStr(gr.Columns[3].Width)+'[|]'+IntToStr(gr.Columns[4].Width);
       if ValidStrToInt(Vib_elm_str(ms.Strings[i],'[|]',1,False,'100')) then
          Left := StrToInt(Vib_elm_str(ms.Strings[i],'[|]',1,False,'100'));
       if ValidStrToInt(Vib_elm_str(ms.Strings[i],'[|]',2,False,'100')) then
          Top := StrToInt(Vib_elm_str(ms.Strings[i],'[|]',2,False,'100'));
       if ValidStrToInt(Vib_elm_str(ms.Strings[i],'[|]',3,False,'300')) then
          Width := StrToInt(Vib_elm_str(ms.Strings[i],'[|]',3,False,'300'));
       if ValidStrToInt(Vib_elm_str(ms.Strings[i],'[|]',4,False,'300')) then
          Height := StrToInt(Vib_elm_str(ms.Strings[i],'[|]',4,False,'300'));
       if ValidStrToInt(Vib_elm_str(ms.Strings[i],'[|]',5,False,'100')) then
          gr.Columns[3].Width := StrToInt(Vib_elm_str(ms.Strings[i],'[|]',5,False,'100'));
       if ValidStrToInt(Vib_elm_str(ms.Strings[i],'[|]',6,False,'100')) then
          gr.Columns[4].Width := StrToInt(Vib_elm_str(ms.Strings[i],'[|]',6,False,'100'));


       for i := 1 to ms.Count - 1 do
       begin

        t.Append;
        t.Edit;
        t.FieldByName('uzel1').AsString := Vib_elm_str(ms.Strings[i],'[|]',1,False,'');
        t.FieldByName('uzel2').AsString := Vib_elm_str(ms.Strings[i],'[|]',2,False,'');
        t.FieldByName('uzel3').AsString := Vib_elm_str(ms.Strings[i],'[|]',3,False,'');
        t.FieldByName('name').AsString := Vib_elm_str(ms.Strings[i],'[|]',4,False,'');
        t.FieldByName('ip').AsString := Vib_elm_str(ms.Strings[i],'[|]',5,False,'');
        t.FieldByName('image').AsString := Vib_elm_str(ms.Strings[i],'[|]',6,False,'');
        if Trim(t.FieldByName('image').AsString)='' then  t.FieldByName('image').AsString := '0';
        
        t.Post;

       end;

       t.AddIndex('osn','uzel1;uzel2',[]);
       t.IndexName := 'osn';

       t.First;
       while not t.Eof do
       begin
        //������� ���� �1 =���� ��� ��� ������ ����

        wr1 := t.FieldByName('uzel1').AsString;
        wr2 := t.FieldByName('uzel2').AsString;
        wr3 := t.FieldByName('uzel3').AsString;
        name := t.FieldByName('name').AsString;
        ip := t.FieldByName('ip').AsString;

        pr := True;
        for j := 0 to tv.Items.Count - 1 do
        begin
         if (wr1+'..'=tv.Items.Item[j].Text) or (wr1='?') then pr := False;
        end;
        if pr then tv.Items.AddChild(tv.Items.Item[0],wr1+'..');//tv.Items.Add(nil,wr1);

        t.Next;

       end;
       //���� �2
       t.First;
       while not t.Eof do
       begin
        //������� ���� �2 =���� ��� ��� ������ ����
        //wr := Vib_elm_str(ms.Strings[i],'=',2,True);
        //wr := Vib_elm_str(wr,'|',1,True);
        wr1 := t.FieldByName('uzel1').AsString;// Vib_elm_str(wr,'\',1,True,'');
        wr := t.FieldByName('uzel2').AsString;//Vib_elm_str(wr,'\',2,True,'');
        if wr<>'' then
        begin
         //���� 2-� ����
         //���� ������ ����
         for j := 0 to tv.Items.Count - 1 do
         begin
          if wr1+'..'=tv.Items.Item[j].Text then
          begin
           //������� ������� ���� ������ ��� ����
           pr := True;
           for k := 0 to tv.Items.Count - 1 do
           begin
            if (wr+'....'=tv.Items.Item[k].Text) or (wr='?') then pr := False;
           end;
           if pr then tv.Items.AddChild(tv.Items.Item[j],wr+'....');
          end;
         end;

        end;

        t.Next;
       end;





      end;

      gr.DataSource := ds;
      ds.DataSet := t;

      tv.Items[0].Expanded := True;
      t.Filtered := False;
      t.Filter := 'uzel1=''?''';
      t.Filtered := True;


      ms.Free;
end;

procedure TForm_client.grDblClick(Sender: TObject);
var
start,param : String;
begin

      if t.FieldByName('image').AsString='0' then ToolButton1Click(nil);
      if t.FieldByName('image').AsString='1' then ToolButton3Click(nil);
      if t.FieldByName('image').AsString='2' then ToolButton5Click(nil);
      if t.FieldByName('image').AsString='3' then ToolButton14Click(nil);



end;

procedure TForm_client.grEnter(Sender: TObject);
begin
//
     ToolButton10.Enabled := False;
     ToolButton15.Enabled := False;
     ToolButton12.Enabled := False;
     ToolButton8.Enabled := True;
     ToolButton16.Enabled := True;
     ToolButton11.Enabled := True;
end;

procedure TForm_client.grTitleClick(Column: TColumnEh);
begin
      if column.FieldName='name' then
      begin
       t.IndexName := 'name';
       //column.Font.Color := clRed;
       gr.Columns[3].Font.Color := clGreen;
       gr.Columns[4].Font.Color := clWindowText;
      end;
      if column.FieldName='ip' then
      begin
       t.IndexName := 'ip';
       gr.Columns[4].Font.Color := clGreen;
       gr.Columns[3].Font.Color := clWindowText;
      end;
end;

procedure TForm_client.im_eEnter(Sender: TObject);
begin
      ip_e.Text := '';
end;

procedure TForm_client.ip_eEnter(Sender: TObject);
begin
      im_e.Text := '';
end;

procedure TForm_client.N2Click(Sender: TObject);
begin
      Close;
end;

procedure TForm_client.N3Click(Sender: TObject);
begin
      MessageBox(handle,'��������� ������������� ��� ������ �'#13#10'Windows 7 Professional ��� ����.','',0);
end;

procedure TForm_client.poisk_soedChange(Sender: TObject);
var
   n,n_start : String;
   nashli : Boolean;
begin
      if not uge_ishem then
      begin
       uge_ishem := True;
      //���� ����������
      n_start := t.FieldByName('name').AsString;
      nashli := False;

      t.Filtered := False;
      t.First;
      while not t.Eof do
      begin
       if Pos(AnsiLowerCase(poisk_soed.Text),AnsiLowerCase(t.FieldByName('name').AsString))<>0 then
       begin
        nashli := True;
        n := t.FieldByName('name').AsString;
        //�����
        if Trim(t.FieldByName('uzel2').AsString)<>'' then
        begin
         poisk_uzel.Text := t.FieldByName('uzel2').AsString;
         //poisk_uzel.OnChange(nil);
         //poisk_uzel.Text := '';
        end
        else
        begin
         poisk_uzel.Text := t.FieldByName('uzel1').AsString;
         //poisk_uzel.OnChange(nil);
         //poisk_uzel.Text := '';
        end;

        t.First;
        t.Locate('name',n,[]);
        break;

       end;
       t.Next;
      end;

      if not nashli then
      begin
       t.Filtered := True;
       t.First;
       t.Locate('name',n_start,[]);

      end;

      //t.Filtered := True;

      end;
      uge_ishem := False;
end;

procedure TForm_client.poisk_soedEnter(Sender: TObject);
begin
      poisk_soed.Text := '';
end;

procedure TForm_client.poisk_uzelChange(Sender: TObject);
var
    i : integer;
begin

      //���� ����
      
      if Length(poisk_uzel.Text)>=1 then
      begin
       for i := 0 to tv.Items.Count - 1 do
       begin
        if Pos(AnsiLowerCase(poisk_uzel.Text),AnsiLowerCase(tv.Items.Item[i].Text))<>0 then
        begin
         //�����

         tv.Items.Item[i].Focused := True;
         tv.Items.Item[i].Selected := True;
         tv.OnClick(nil);
        end;

       end;

      end;


end;

procedure TForm_client.poisk_uzelEnter(Sender: TObject);
begin
      poisk_uzel.Text := '';
end;

procedure TForm_client.ToolButton10Click(Sender: TObject);
label fin;
var
    wr1 : String;
begin
      name_new_usel := '';

      Form_new_uzel.Left := Left+200;
      Form_new_uzel.Top := Top+200;
      Form_new_uzel.ShowModal;

      //�������� - ����� ����� ���� ��� ����..
      t.Filtered := False;
      if t.Locate('uzel1',name_new_usel,[]) then
      begin
       MessageBox(handle,'����� ���� ��� ����������!','!',0);
       goto fin;
      end;
      if t.Locate('uzel2',name_new_usel,[]) then
      begin
       MessageBox(handle,'����� ���� ��� ����������!','!',0);
       goto fin;
      end;
      

      if name_new_usel<>'' then
      begin
       if tv.Selected.Text='���...' then
       begin
        //name_new_usel := name_new_usel;
        t.Filter := 'uzel1='+''''+name_new_usel+'''';

        tv.Items.AddChild(tv.Selected,name_new_usel+'..').Selected := True;
        t.Filtered := False;
        t.Append;
        t.Edit;
        t.FieldByName('uzel1').AsString := name_new_usel;
        t.FieldByName('name').AsString := '���';
        t.FieldByName('ip').AsString := '��';
        t.Post;
        t.Filtered := True;

       end
       else
       begin
        if not (Copy(tv.Selected.Text, Length(tv.Selected.Text)-3,4)='....') then
        begin
         wr1 := Copy(tv.Selected.Text,1,Length(tv.Selected.Text)-2);
         t.Filter := 'uzel2='+''''+name_new_usel+'''';
         tv.Items.AddChild(tv.Selected,name_new_usel+'....').Selected := True;
         t.Filtered := False;
         t.Append;
         t.Edit;
         t.FieldByName('uzel1').AsString := wr1;
         t.FieldByName('uzel2').AsString := name_new_usel;
         t.FieldByName('name').AsString := '���';
         t.FieldByName('ip').AsString := '��';
         t.Post;
         t.Filtered := True;
        end
        else
        begin
         MessageBox(handle,'��������� ����� �����������!','!',0);
        end;

       end;


      end;

fin:

end;

procedure TForm_client.ToolButton11Click(Sender: TObject);
begin
      Form_new_conn.Left := Left+200;
      Form_new_conn.Top := Top+200;
      Form_new_conn.BitBtn1.Caption := '��������' ;
      Form_new_conn.Caption := '�������������� ����������';
      Form_new_conn.e_name.Text := t.FieldByName('name').AsString;
      Form_new_conn.e_ip.Text := t.FieldByName('ip').AsString;
      Form_new_conn.ShowModal;


      if im<>'' then
      begin
       //����� ��������� ����������
       if im = '0' then ToolButton1Click(nil);
       if im = '1' then ToolButton3Click(nil);
       if im = '2' then ToolButton5Click(nil);
       if im = '12' then ToolButton14Click(nil);
      end;




end;

procedure TForm_client.ToolButton12Click(Sender: TObject);
begin



      if tv.Selected.Text<>'���...' then
      begin

       name_new_usel := '';

       Form_new_uzel.Left := Left+200;
       Form_new_uzel.Top := Top+200;
       Form_new_uzel.e_name.Text := ZamSym(tv.Selected.Text,'..','');
       Form_new_uzel.ShowModal;

       if (name_new_usel<>'') then
       begin
        name_new_usel := ZamSym(name_new_usel,'.','');
        if Copy(tv.Selected.Text, Length(tv.Selected.Text)-3,4)='....' then
        begin
         tv.Selected.Text := name_new_usel+'....';

         gr.DataSource.DataSet.First;
         while not gr.DataSource.DataSet.Eof do
         begin

          gr.DataSource.DataSet.Edit;
          gr.DataSource.DataSet.FieldByName('uzel2').AsString := name_new_usel;
          gr.DataSource.DataSet.Post;
          gr.DataSource.DataSet.Next;
         end;
         gr.DataSource.DataSet.First;
         //t.Filtered := True;
        end
        else
        begin
         gr.DataSource.DataSet.Filtered := False;

         gr.DataSource.DataSet.First;
         while not gr.DataSource.DataSet.Eof do
         begin
          if gr.DataSource.DataSet.FieldByName('uzel1').AsString=ZamSym(tv.Selected.Text,'..','') then
          begin
           gr.DataSource.DataSet.Edit;
           gr.DataSource.DataSet.FieldByName('uzel1').AsString := name_new_usel;
           gr.DataSource.DataSet.Post;

          end;
          gr.DataSource.DataSet.Next;
         end;
        end;

        //t.Filtered := True;
        gr.DataSource.DataSet.First;
        tv.Selected.Text := name_new_usel+'..';
        tv.OnClick(nil);
       end;
      end;

      gr.DataSource.DataSet.First;



end;

procedure TForm_client.ToolButton14Click(Sender: TObject);
var
start,param : String;
begin
      start := 'mstsc.exe';
      param := '-admin -v  '+t.FieldByName('ip').AsString;

      ShellExecute(handle,'open',PChar(start),PChar(param),nil,SW_SHOW);
      t.Edit;
      t.FieldByName('image').AsString := '12';
      t.Post;

      SaveTekJrn(DateTimeToStr(now)+' : '+start+' '+param);

end;

procedure TForm_client.ToolButton15Click(Sender: TObject);
var
b1 : Boolean;
b2 : Boolean;
wr : String;
begin

      if tv.Selected.Text='���...' then
      begin
       t.Filtered := False;
       t.Filter := 'uzel1=''?''';
       t.Filtered := True;
      end
      else
      begin
       if Copy(tv.Selected.Text, Length(tv.Selected.Text)-3,4)='....' then
       begin
        wr := Copy(tv.Selected.Text,1,Length(tv.Selected.Text)-4);
        t.Filtered := False;
        t.Filter := 'uzel2='+''''+wr+'''';
        t.Filtered := True;
       end
       else
       begin
        if Copy(tv.Selected.Text, Length(tv.Selected.Text)-1,2)='..' then
        begin
        wr := Copy(tv.Selected.Text,1,Length(tv.Selected.Text)-2);
        t.Filtered := False;
        t.Filter := 'uzel1='+''''+wr+'''';
        t.Filtered := True;
        t.First;
       end;

       end;

      end;

      while not t.Eof do
      begin
       t.Delete;
      end;
      tv.Selected.Delete;

      tvClick(nil);

end;

procedure TForm_client.ToolButton16Click(Sender: TObject);
begin
      t.Delete;
end;

procedure TForm_client.ToolButton19Click(Sender: TObject);
var
start,param : String;
begin
      //compmgmt.msc /computer=\\10.99.129.16
      start := 'compmgmt.msc';//+t.FieldByName('ip').AsString;
      param := '/computer=\\'+t.FieldByName('ip').AsString;
      ShellExecute(handle,'open',PChar(start),PChar(param),nil,SW_SHOW);
      SaveTekJrn(DateTimeToStr(now)+' : '+start+' '+param);
end;

procedure TForm_client.ToolButton1Click(Sender: TObject);
var
start,param : String;
begin
      start := ExtractFilePath(Application.ExeName)+'rc.exe';
      param := '1 '+t.FieldByName('ip').AsString;

      ShellExecute(handle,'open',PChar(start),PChar(param),nil,SW_SHOW);
      t.Edit;
      t.FieldByName('image').AsString := '0';
      t.Post;

      SaveTekJrn(DateTimeToStr(now)+' : '+start+' '+param);
end;

procedure TForm_client.ToolButton2Click(Sender: TObject);
var
start,param : String;
begin
      start := '\\'+t.FieldByName('ip').AsString+'\c$';
      ShellExecute(handle,'open',PChar(start),nil,nil,SW_SHOW);

      SaveTekJrn(DateTimeToStr(now)+' : '+start);
end;

procedure TForm_client.ToolButton3Click(Sender: TObject);
var
start,param : String;
begin
      start := 'msra.exe';
      param := '/offerra  '+t.FieldByName('ip').AsString;

      ShellExecute(handle,'open',PChar(start),PChar(param),nil,SW_SHOW);
      t.Edit;
      t.FieldByName('image').AsString := '1';
      t.Post;

      SaveTekJrn(DateTimeToStr(now)+' : '+start+' '+param);
end;

procedure TForm_client.ToolButton4Click(Sender: TObject);
var
start,param : String;
begin
      start := '\\'+t.FieldByName('ip').AsString+'\d$';
      ShellExecute(handle,'open',PChar(start),nil,nil,SW_SHOW);

      SaveTekJrn(DateTimeToStr(now)+' : '+start);

end;

procedure TForm_client.ToolButton5Click(Sender: TObject);
var
start,param : String;
begin
      start := 'mstsc.exe';
      param := '-v  '+t.FieldByName('ip').AsString;

      ShellExecute(handle,'open',PChar(start),PChar(param),nil,SW_SHOW);
      t.Edit;
      t.FieldByName('image').AsString := '2';
      t.Post;


      SaveTekJrn(DateTimeToStr(now)+' : '+start+' '+param);
end;

procedure TForm_client.ToolButton7Click(Sender: TObject);
var
start,param : String;
begin
      start := '\\'+t.FieldByName('ip').AsString+'\e$';
      ShellExecute(handle,'open',PChar(start),nil,nil,SW_SHOW);

      SaveTekJrn(DateTimeToStr(now)+' : '+start);

end;

procedure TForm_client.ToolButton8Click(Sender: TObject);
begin
      Form_new_conn.Left := Left+200;
      Form_new_conn.Top := Top+200;
      Form_new_conn.BitBtn1.Caption := '��������' ;
      Form_new_conn.Caption := '���������� ������ ����������';
      Form_new_conn.e_name.Text := '';
      Form_new_conn.e_ip.Text := '';
      Form_new_conn.ShowModal;

      if im<>'' then
      begin
       t.Locate('ip',Form_new_conn.e_ip.Text,[]);
       //����� ��������� ����������
       if im = '0' then ToolButton1Click(nil);
       if im = '1' then ToolButton3Click(nil);
       if im = '2' then ToolButton5Click(nil);
       if im = '12' then ToolButton14Click(nil);

      end;


end;

procedure TForm_client.ToolButton9Click(Sender: TObject);
{const
  Fn = '111';
var
  F : File;
  S,s1, FileName : String;
  Len : Integer;
  FS : TFileStream;
  Buffer : PChar;
  i : integer;
}

begin
      MessageBox(handle,PChar(IPAddrToName('10.97.47.38')),'',0);
      MessageBox(handle,PChar(GetIPFromHost('ivc-tarasovdv3')),'',0);


{  //�����������, ���� ����� � ��� �� �����, ��� ����������� ���������.
  FileName := ExtractFilePath(ParamStr(0)) + Fn;
  AssignFile(F, FileName);
  Reset(F, 1);
  
  Len := FileSize(F);
  SetLength(S, Len);
  BlockRead(F, Pointer(S)^, Len);
  
  CloseFile(F);

  for i := 0 to Length(s) do
  begin
   if s[i]=chr($10) then s[i]:='�'; if s[i]=chr($30) then s[i]:='�';
   if s[i]=chr($11) then s[i]:='�'; if s[i]=chr($31) then s[i]:='�';
   if s[i]=chr($12) then s[i]:='�'; if s[i]=chr($32) then s[i]:='�';
   if s[i]=chr($13) then s[i]:='�'; if s[i]=chr($33) then s[i]:='�';
   if s[i]=chr($14) then s[i]:='�'; if s[i]=chr($34) then s[i]:='�';
   if s[i]=chr($15) then s[i]:='�'; if s[i]=chr($35) then s[i]:='�';
   if s[i]=chr($01) then s[i]:='�'; if s[i]=chr($51) then s[i]:='�';
   if s[i]=chr($16) then s[i]:='�'; if s[i]=chr($36) then s[i]:='�';
   if s[i]=chr($17) then s[i]:='�'; if s[i]=chr($37) then s[i]:='�';
   if s[i]=chr($18) then s[i]:='�'; if s[i]=chr($38) then s[i]:='�';
   if s[i]=chr($19) then s[i]:='�'; if s[i]=chr($39) then s[i]:='�';
   if s[i]=chr($1A) then s[i]:='�'; if s[i]=chr($3A) then s[i]:='�';
   if s[i]=chr($1B) then s[i]:='�'; if s[i]=chr($3B) then s[i]:='�';
   if s[i]=chr($1C) then s[i]:='�'; if s[i]=chr($3C) then s[i]:='�';
   if s[i]=chr($1D) then s[i]:='�'; if s[i]=chr($3D) then s[i]:='�';
   if s[i]=chr($1E) then s[i]:='�'; if s[i]=chr($3E) then s[i]:='�';
   if s[i]=chr($1F) then s[i]:='�'; if s[i]=chr($3F) then s[i]:='�';
   if s[i]=chr($20) then s[i]:='�'; if s[i]=chr($40) then s[i]:='�';
   if s[i]=chr($21) then s[i]:='�'; if s[i]=chr($41) then s[i]:='�';
   if s[i]=chr($22) then s[i]:='�'; if s[i]=chr($42) then s[i]:='�';
   if s[i]=chr($23) then s[i]:='�'; if s[i]=chr($43) then s[i]:='�';
   if s[i]=chr($24) then s[i]:='�'; if s[i]=chr($44) then s[i]:='�';
   if s[i]=chr($25) then s[i]:='�'; if s[i]=chr($45) then s[i]:='�';
   if s[i]=chr($26) then s[i]:='�'; if s[i]=chr($46) then s[i]:='�';
   if s[i]=chr($27) then s[i]:='�'; if s[i]=chr($47) then s[i]:='�';
   if s[i]=chr($28) then s[i]:='�'; if s[i]=chr($48) then s[i]:='�';
   if s[i]=chr($29) then s[i]:='�'; if s[i]=chr($49) then s[i]:='�';
   if s[i]=chr($2A) then s[i]:='�'; if s[i]=chr($4A) then s[i]:='�';
   if s[i]=chr($2B) then s[i]:='�'; if s[i]=chr($4B) then s[i]:='�';
   if s[i]=chr($2C) then s[i]:='�'; if s[i]=chr($4C) then s[i]:='�';
   if s[i]=chr($2D) then s[i]:='�'; if s[i]=chr($4D) then s[i]:='�';
   if s[i]=chr($2E) then s[i]:='�'; if s[i]=chr($4E) then s[i]:='�';
   if s[i]=chr($2F) then s[i]:='�'; if s[i]=chr($4F) then s[i]:='�';

   //if s[i]=chr($00) then s[i]:=' '; if s[i]=chr($04) then s[i]:=' ';


  end;


      //s1 := ZamSym(s,#00,'');
      //s1 := ZamSym(s,#04,'');


  AssignFile(f,'d:\222');
  Rewrite(f,SizeOf(Char));
  if Length(s)>0 then
    BlockWrite(f,s[1],Length(s));
  CloseFile(f);
}
end;




procedure TForm_client.tvClick(Sender: TObject);
var
b1 : Boolean;
b2 : Boolean;
wr : String;
begin
      if Copy(tv.Selected.Text, Length(tv.Selected.Text)-1,2)='..' then
      begin
       wr := Copy(tv.Selected.Text,1,Length(tv.Selected.Text)-2);
       t.Filtered := False;
       t.Filter := 'uzel1='+''''+wr+''' and uzel2=''''';
       t.Filtered := True;
      end;

      if Copy(tv.Selected.Text, Length(tv.Selected.Text)-3,4)='....' then
      begin
       wr := Copy(tv.Selected.Text,1,Length(tv.Selected.Text)-4);
       t.Filtered := False;
       t.Filter := 'uzel2='+''''+wr+'''';
       t.Filtered := True;
      end;

      if tv.Selected.Text='���...' then
      begin
       t.Filtered := False;
       t.Filter := 'uzel1=''?''';
       t.Filtered := True;
      end;

end;

procedure TForm_client.tvEnter(Sender: TObject);
begin
//
     ToolButton10.Enabled := True;
     ToolButton15.Enabled := True;
     ToolButton12.Enabled := True;
     ToolButton8.Enabled := False;
     ToolButton16.Enabled := False;
     ToolButton11.Enabled := False;
end;

end.
