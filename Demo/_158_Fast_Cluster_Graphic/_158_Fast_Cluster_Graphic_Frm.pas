unit _158_Fast_Cluster_Graphic_Frm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,

  FMX.TabControl, FMX.Surfaces, FMX.Objects,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Edit, FMX.Layouts,

  PasAI.Core, PasAI.MemoryRaster, PasAI.UnicodeMixedLib, PasAI.Geometry2D, PasAI.Expression,
  PasAI.Learn.Type_LIB, PasAI.Learn,
  PasAI.DrawEngine.SlowFMX;

const
  sceneWidth = 800;
  sceneHeight = 800;
  RandomCount = 1500;

type
  T_158_Fast_Cluster_Graphic_Form = class(TForm)
    Layout1: TLayout;
    Button1: TButton;
    LeftImage1: TImage;
    RightImage1: TImage;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    pl1: T2DPointList;

    procedure GenerateData(pl: T2DPointList);
    procedure GenerateView(pl: T2DPointList; bmp: TMPasAI_Raster);
    procedure BuildCluster(pl: T2DPointList; bmp: TMPasAI_Raster);
  end;

var
  _158_Fast_Cluster_Graphic_Form: T_158_Fast_Cluster_Graphic_Form;

implementation

{$R *.fmx}


procedure T_158_Fast_Cluster_Graphic_Form.Button1Click(Sender: TObject);
var
  mr: TMPasAI_Raster;
begin
  mr := TMPasAI_Raster.Create;
  mr.OpenAGG;
  GenerateView(pl1, mr);

  MemoryBitmapToBitmap(mr, LeftImage1.Bitmap);

  BuildCluster(pl1, mr);
  MemoryBitmapToBitmap(mr, RightImage1.Bitmap);
  DisposeObject(mr);
end;

procedure T_158_Fast_Cluster_Graphic_Form.Button2Click(Sender: TObject);
begin
  GenerateData(pl1);
  Button1Click(nil);
end;

procedure T_158_Fast_Cluster_Graphic_Form.FormCreate(Sender: TObject);
begin
  pl1 := T2DPointList.Create;

  GenerateData(pl1);

  Button1Click(nil);
end;

procedure T_158_Fast_Cluster_Graphic_Form.FormDestroy(Sender: TObject);
begin
  DisposeObject([pl1]);
end;

procedure T_158_Fast_Cluster_Graphic_Form.FormResize(Sender: TObject);
begin
  LeftImage1.Width := Width * 0.5 - 10;
  LeftImage1.UpdateEffects;
end;

procedure T_158_Fast_Cluster_Graphic_Form.GenerateData(pl: T2DPointList);
var
  i: Integer;
  pt: T2DPoint;
begin
  pl.Clear;
  MT19937Randomize();
  for i := 0 to RandomCount div 2 - 1 do
    begin
      pt := Make2DPoint(umlRR(20, sceneWidth div 2 - 20), umlRR(20, sceneHeight div 2 - 20));
      pl.add(pt);
    end;
  for i := 0 to RandomCount div 2 - 1 do
    begin
      pt := Make2DPoint(umlRR(sceneWidth div 2 - 20, sceneWidth - 20), umlRR(sceneHeight div 2 - 20, sceneHeight - 20));
      pl.add(pt);
    end;
end;

procedure T_158_Fast_Cluster_Graphic_Form.GenerateView(pl: T2DPointList; bmp: TMPasAI_Raster);
var
  i: Integer;
  pt: T2DPoint;
begin
  bmp.SetSize(sceneWidth, sceneHeight, PasAI_RasterColor($0, $0, $0, $0));
  bmp.Agg.LineWidth := 3;
  for i := 0 to pl.Count - 1 do
    begin
      pt := pl[i]^;
      bmp.FillCircle(pt, 5, PasAI_RasterColor($FF, $0, $0, $FF));
    end;
end;

procedure T_158_Fast_Cluster_Graphic_Form.BuildCluster(pl: T2DPointList; bmp: TMPasAI_Raster);
var
  L: TLearn;
  v: TLVec;
  OutIndex: TLIVec;
  arryPl: array of T2DPointList;
  i, j, k: TLInt;
  pt: T2DPoint;
  ConvexHullPl: T2DPointList;
  M: TLMatrix;
begin
  L := TLearn.CreateClassifier(ltKDT, 2);
  for i := 0 to pl.Count - 1 do
    begin
      v := LVec(2);
      v[0] := pl[i]^[0];
      v[1] := pl[i]^[1];
      L.AddMemory(v, '');
    end;
  OutIndex := Auto_Cluster(L, k);

  SetLength(arryPl, k);
  for i := 0 to k - 1 do
      arryPl[i] := T2DPointList.Create;

  for i := 0 to length(OutIndex) - 1 do
    begin
      pt := pl[i]^;
      arryPl[OutIndex[i]].add(pt);
    end;

  for i := 0 to k - 1 do
    begin
      ConvexHullPl := T2DPointList.Create;
      arryPl[i].ConvexHull(ConvexHullPl);
      bmp.DrawPointListLine(ConvexHullPl, PasAI_RasterColor($0, $0, 0, $FF), True);
      M := LMatrix(arryPl[i].Count, 2);
      for j := 0 to arryPl[i].Count - 1 do
        begin
          M[j, 0] := arryPl[i][j]^[0];
          M[j, 1] := arryPl[i][j]^[1];
        end;
      v := LMatrix_Centroid(2, M);
      bmp.FillEllipse(vec2(v[0], v[1]), 5, 5, RColorF(0, 0, 1, 1));
      DisposeObject(ConvexHullPl);
    end;

  for i := 0 to k - 1 do
      DisposeObject(arryPl[i]);

  SetLength(arryPl, 0);
  SetLength(OutIndex, 0);

end;

end.
