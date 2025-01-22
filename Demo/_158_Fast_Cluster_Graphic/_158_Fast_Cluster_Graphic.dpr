program _158_Fast_Cluster_Graphic;

uses
  FastMM5,
  System.StartUpCopy,
  FMX.Forms,
  _158_Fast_Cluster_Graphic_Frm in '_158_Fast_Cluster_Graphic_Frm.pas' {_158_Fast_Cluster_Graphic_Form};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(T_158_Fast_Cluster_Graphic_Form, _158_Fast_Cluster_Graphic_Form);
  Application.Run;
end.
