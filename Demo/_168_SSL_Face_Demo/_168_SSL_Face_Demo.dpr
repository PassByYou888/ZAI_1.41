program _168_SSL_Face_Demo;

uses
  FastMM5,
  System.StartUpCopy,
  FMX.Forms,
  _168_SSL_Face_Demo_Frm in '_168_SSL_Face_Demo_Frm.pas' {_168_SSL_Face_Demo_Form};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(T_168_SSL_Face_Demo_Form, _168_SSL_Face_Demo_Form);
  Application.Run;
end.
