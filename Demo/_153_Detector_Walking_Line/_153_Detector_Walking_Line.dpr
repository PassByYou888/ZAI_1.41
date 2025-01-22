program _153_Detector_Walking_Line;

uses
  System.StartUpCopy,
  FMX.Forms,
  StyleModuleUnit in '..\_88_DNN_Dog\StyleModuleUnit.pas' {StyleDataModule: TDataModule},
  _153_Detector_Walking_Line_Frm in '_153_Detector_Walking_Line_Frm.pas' {_153_Detector_Walking_Line_Form};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(T_153_Detector_Walking_Line_Form, _153_Detector_Walking_Line_Form);
  Application.Run;
end.
