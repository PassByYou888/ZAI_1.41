program _155_Image_Sampling_Jitter;

uses
  System.StartUpCopy,
  FMX.Forms,
  StyleModuleUnit in '..\_88_DNN_Dog\StyleModuleUnit.pas' {StyleDataModule: TDataModule},
  _155_Image_Sampling_Jitter_Frm in '_155_Image_Sampling_Jitter_Frm.pas' {_155_Image_Sampling_Jitter_Form};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TStyleDataModule, StyleDataModule);
  Application.CreateForm(T_155_Image_Sampling_Jitter_Form, _155_Image_Sampling_Jitter_Form);
  Application.Run;
end.
