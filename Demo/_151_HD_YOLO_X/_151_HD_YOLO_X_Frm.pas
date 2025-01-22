unit _151_HD_YOLO_X_Frm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls,

  PasAI.Core, PasAI.PascalStrings, PasAI.UPascalStrings, PasAI.UnicodeMixedLib, PasAI.Geometry2D, PasAI.Geometry3D,
  PasAI.Status, PasAI.Notify, PasAI.DFE,
  PasAI.MemoryRaster, PasAI.DrawEngine, PasAI.DrawEngine.SlowFMX, PasAI.DrawEngine.PictureViewer,
  PasAI.AI, PasAI.AI.Tech2022, PasAI.AI.Common;

type
  T_151_HD_YOLO_X_Form = class(TForm)
    ThreadTimer: TTimer;
    fpsTimer: TTimer;
    Run_YOLO_X_Button: TButton;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; var Handled: Boolean);
    procedure FormPaint(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
    procedure fpsTimerTimer(Sender: TObject);
    procedure Run_YOLO_X_ButtonClick(Sender: TObject);
    procedure ThreadTimerTimer(Sender: TObject);
  private
    procedure DoStatus_backcall(Text_: SystemString; const ID: Integer);
  public
    dIntf: TDrawEngineInterface_FMX;
    viewer: TPictureViewerInterface;
    ai_tech_2022: TPas_AI_TECH_2022;
    yolo_x_hnd: TPas_AI_TECH_2022_YOLO_X_Handle;
    yolo_x_desc: TAI_TECH_2022_DESC;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  _151_HD_YOLO_X_Form: T_151_HD_YOLO_X_Form;

implementation

{$R *.fmx}


procedure T_151_HD_YOLO_X_Form.FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  viewer.TapDown(vec2(X, Y));
end;

procedure T_151_HD_YOLO_X_Form.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
begin
  viewer.TapMove(vec2(X, Y));
end;

procedure T_151_HD_YOLO_X_Form.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  viewer.TapUp(vec2(X, Y));
end;

procedure T_151_HD_YOLO_X_Form.FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; var Handled: Boolean);
begin
  viewer.ScaleCameraFromWheelDelta(WheelDelta);
  Handled := True;
end;

procedure T_151_HD_YOLO_X_Form.FormPaint(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
var
  i: Integer;
  pic: TPictureViewerData;
  r: TRectV2;
begin
  Canvas.Font.Style := [TFontStyle.fsBold];
  viewer.DrawEng := dIntf.SetSurfaceAndGetDrawPool(Canvas, Sender);
  viewer.DrawEng.ViewOptions := [voFPS, voEdge];
  viewer.Render(True, False);
  pic := viewer.First;
  for i := 0 to length(yolo_x_desc) - 1 do
    begin
      r := RectProjection(pic.Raster.BoundsRectV20, pic.ScreenBox, yolo_x_desc[i].r);
      viewer.DrawEng.DrawLabelBox(umlFloatToStr(yolo_x_desc[i].confidence), 12, DEColor(1, 1, 1), r, DEColor(1, 0, 0), 1);
    end;

  viewer.Flush;
end;

procedure T_151_HD_YOLO_X_Form.fpsTimerTimer(Sender: TObject);
begin
  DrawPool.Progress;
  Invalidate;
end;

procedure T_151_HD_YOLO_X_Form.ThreadTimerTimer(Sender: TObject);
begin
  Check_Soft_Thread_Synchronize;
end;

procedure T_151_HD_YOLO_X_Form.DoStatus_backcall(Text_: SystemString; const ID: Integer);
begin
  DrawPool(self).PostScrollText(15, TDrawEngine.RebuildNumColor(Text_, '|color(1,0,0),box(0,1,0)|', '||'), 12, DEColor(1, 1, 1), DEColor(0, 0, 0, 0.5));
end;

constructor T_151_HD_YOLO_X_Form.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AddDoStatusHook(self, DoStatus_backcall);
  CheckAndReadAIConfig();
  Prepare_AI_Engine_TECH_2022();
  dIntf := TDrawEngineInterface_FMX.Create;
  viewer := TPictureViewerInterface.Create(DrawPool(self));
  viewer.ShowBackground := True;
  viewer.DrawEng.Scroll_Text_Direction := stdLB;
  viewer.InputPicture(NewPasAI_RasterFromFile(WhereFileFromConfigure('YOLO_HD_Test.jpg')), True);

  ai_tech_2022 := TPas_AI_TECH_2022.OpenEngine;
  yolo_x_hnd := ai_tech_2022.YOLO_X_Open(WhereFileFromConfigure('YOLO_HD_Test.YOLOX'));
  SetLength(yolo_x_desc, 0);

  DrawPool(self).PostScrollText(1, 'Z-AI的YOLO算法(|color(1,0,0)|改进||)可以用低显存+低内存+低gpu开销支持超分检测,宽高纵列支持范围从 |s:30,box(1,1,0),l:2|400|| 到 |s:30,box(1,1,0),l:2|5000||', 20, DEColor(1, 1, 1), DEColor(0, 0, 0, 0.9)).Forever := True;
  DrawPool(self).PostScrollText(1, '当识别目标图超过5000,将使用线性采样将目标下降到 |s:30,box(1,1,0),l:2|5000|| 识别', 20, DEColor(1, 1, 1), DEColor(0, 0, 0, 0.9)).Forever := True;
  DrawPool(self).PostScrollText(1, '用4G显存也可以跑出|color(0,1,0)|5000*5000||的大图检测,如果使用DNN-Thread每条单线大约|color(0,1,0)|900M||(峰值)', 20, DEColor(1, 1, 1), DEColor(0, 0, 0, 0.9)).Forever := True;
  DrawPool(self).PostScrollText(1, 'Z-AI的YOLO可以支持 |box(0,1,0),l:2|无人机航拍识别||,|box(0,1,0),l:2|大区域识别||,例如|box(0,1,0),l:2|演唱会||,|box(0,1,0),l:2|足球比赛||', 24, DEColor(1, 1, 1), DEColor(0, 0, 0, 0.9)).Forever := True;
  DrawPool(self).PostScrollText(1, 'Z-AI的 YOLO + ZM2.0 是标准搭配,YOLO负责检测,ZM2负责做分类识别,YOLO和ZM2都是推理模型,ZM2略偏记忆', 20, DEColor(1, 1, 1), DEColor(0, 0, 0, 0.9)).Forever := True;
  DrawPool(self).PostScrollText(1, 'Z-AI的ZM2可以支持反推和剪枝,并且ZM2还具备实时建模能力(1级母模型到位以后,1秒完成训练)', 20, DEColor(1, 1, 1), DEColor(0, 0, 0, 0.9)).Forever := True;
  DrawPool(self).PostScrollText(1, 'Z-AI的可以轻松做出满屏框框,给项目交付提供|s:40|神奇支持||.', 20, DEColor(1, 1, 1), DEColor(0, 0, 0, 0.9)).Forever := True;
end;

destructor T_151_HD_YOLO_X_Form.Destroy;
begin
  RemoveDoStatusHook(self);
  DisposeObject(viewer);
  inherited Destroy;
end;

procedure T_151_HD_YOLO_X_Form.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  Hide;
  ai_tech_2022.YOLO_X_Close(yolo_x_hnd);
  DisposeObject(ai_tech_2022);
  CanClose := True;
end;

procedure T_151_HD_YOLO_X_Form.Run_YOLO_X_ButtonClick(Sender: TObject);
begin
  yolo_x_desc := ai_tech_2022.YOLO_X_Process(yolo_x_hnd, viewer.First.Raster, 0.001);
end;

end.
