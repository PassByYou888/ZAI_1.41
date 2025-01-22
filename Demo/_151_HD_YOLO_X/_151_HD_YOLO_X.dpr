program _151_HD_YOLO_X;

uses
  System.StartUpCopy,
  FMX.Forms,
  _151_HD_YOLO_X_Frm in '_151_HD_YOLO_X_Frm.pas' {_151_HD_YOLO_X_Form};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(T_151_HD_YOLO_X_Form, _151_HD_YOLO_X_Form);
  Application.Run;
end.
