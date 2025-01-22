program _143_YOLO_X_Training;

uses
  System.StartUpCopy,
  FMX.Forms,
  StyleModuleUnit in '..\_88_DNN_Dog\StyleModuleUnit.pas' {StyleDataModule: TDataModule},
  _143_YOLO_X_Training_Frm in '_143_YOLO_X_Training_Frm.pas' {_143_YOLO_X_Training_Form},
  _143_YOLO_X_Test_Frm in '_143_YOLO_X_Test_Frm.pas' {_143_YOLO_X_Test_Form};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TStyleDataModule, StyleDataModule);
  Application.CreateForm(T_143_YOLO_X_Training_Form, _143_YOLO_X_Training_Form);
  Application.CreateForm(T_143_YOLO_X_Test_Form, _143_YOLO_X_Test_Form);
  Application.Run;
end.
