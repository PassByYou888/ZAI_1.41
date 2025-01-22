program _169_Large_List_Draw;

uses
  FastMM5,
  System.StartUpCopy,
  FMX.Forms,
  StyleModuleUnit in '..\_88_DNN_Dog\StyleModuleUnit.pas' {StyleDataModule: TDataModule},
  _169_Large_List_Draw_Frm in '_169_Large_List_Draw_Frm.pas' {_169_Large_List_Draw_Form};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TStyleDataModule, StyleDataModule);
  Application.CreateForm(T_169_Large_List_Draw_Form, _169_Large_List_Draw_Form);
  Application.Run;
end.
