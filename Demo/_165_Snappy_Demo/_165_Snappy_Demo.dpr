program _165_Snappy_Demo;

uses
  FastMM5,
  Vcl.Forms,
  _165_Snappy_Demo_Frm in '_165_Snappy_Demo_Frm.pas' {_165_Snappy_Demo_Form};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(T_165_Snappy_Demo_Form, _165_Snappy_Demo_Form);
  Application.Run;
end.
