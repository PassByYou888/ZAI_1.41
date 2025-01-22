program _156_SSL_Trainer;

uses
  Vcl.Forms,
  _156_SSL_Trainer_Frm in '_156_SSL_Trainer_Frm.pas' {_156_SSL_Trainer_Form};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(T_156_SSL_Trainer_Form, _156_SSL_Trainer_Form);
  Application.Run;
end.
