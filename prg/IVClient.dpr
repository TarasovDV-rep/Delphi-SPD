program IVClient;

uses
  Forms,
  Unit_client in 'Unit_client.pas' {Form_client},
  Unit_new_conn in 'Unit_new_conn.pas' {Form_new_conn},
  Unit_dop in 'Unit_dop.pas',
  Unit_new_uzel in 'Unit_new_uzel.pas' {Form_new_uzel};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm_client, Form_client);
  Application.CreateForm(TForm_new_conn, Form_new_conn);
  Application.CreateForm(TForm_new_uzel, Form_new_uzel);
  Application.Run;
end.
