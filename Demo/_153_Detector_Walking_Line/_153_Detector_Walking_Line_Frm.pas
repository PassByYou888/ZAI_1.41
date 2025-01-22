unit _153_Detector_Walking_Line_Frm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls,

  PasAI.Core, PasAI.PascalStrings, PasAI.UPascalStrings, PasAI.UnicodeMixedLib, PasAI.Geometry2D, PasAI.Geometry3D,
  PasAI.Status, PasAI.Notify, PasAI.DFE,
  PasAI.MemoryRaster, PasAI.DrawEngine, PasAI.DrawEngine.SlowFMX,
  PasAI.DrawEngine.PictureViewer,
  PasAI.FFMPEG, PasAI.FFMPEG.Reader,
  PasAI.AI.Common, PasAI.AI, PasAI.AI.Tech2022;

type
  T_153_Detector_Walking_Line_Form = class(TForm)
    fpsTimer: TTimer;
    ThreadTimer: TTimer;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; var Handled: Boolean);
    procedure FormPaint(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
    procedure fpsTimerTimer(Sender: TObject);
    procedure ThreadTimerTimer(Sender: TObject);
  private
    procedure DoStatus_backcall(Text_: SystemString; const ID: Integer);
  public
    dIntf: TDrawEngineInterface_FMX;
    viewer: TPictureViewerInterface;
    Play_Activted, Play_Running: Boolean;
    Critical: TCritical;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Do_Play;
  end;

var
  _153_Detector_Walking_Line_Form: T_153_Detector_Walking_Line_Form;

implementation

{$R *.fmx}


uses StyleModuleUnit;

procedure T_153_Detector_Walking_Line_Form.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := True;
end;

procedure T_153_Detector_Walking_Line_Form.FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  viewer.TapDown(vec2(X, Y));
end;

procedure T_153_Detector_Walking_Line_Form.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
begin
  viewer.TapMove(vec2(X, Y));
end;

procedure T_153_Detector_Walking_Line_Form.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  viewer.TapUp(vec2(X, Y));
end;

procedure T_153_Detector_Walking_Line_Form.FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; var Handled: Boolean);
begin
  viewer.ScaleCameraFromWheelDelta(WheelDelta);
  Handled := True;
end;

procedure T_153_Detector_Walking_Line_Form.FormPaint(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
begin
  Canvas.Font.Style := [TFontStyle.fsBold];
  viewer.DrawEng := dIntf.SetSurfaceAndGetDrawPool(Canvas, Sender);
  viewer.DrawEng.ViewOptions := [voFPS, voEdge];
  Critical.Lock;
  viewer.Render(True, True);
  Critical.UnLock;
end;

procedure T_153_Detector_Walking_Line_Form.fpsTimerTimer(Sender: TObject);
begin
  DrawPool.Progress;
  Invalidate;
end;

procedure T_153_Detector_Walking_Line_Form.ThreadTimerTimer(Sender: TObject);
begin
  Check_Soft_Thread_Synchronize;
end;

procedure T_153_Detector_Walking_Line_Form.DoStatus_backcall(Text_: SystemString; const ID: Integer);
begin
  DrawPool(self).PostScrollText(15, TDrawEngine.RebuildNumColor(Text_, '|color(1,0,0),box(0,1,0)|', '||'), 12, DEColor(1, 1, 1), DEColor(0, 0, 0, 0.5));
end;

constructor T_153_Detector_Walking_Line_Form.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AddDoStatusHook(self, DoStatus_backcall);
  PasAI.FFMPEG.Load_ffmpeg;
  CheckAndReadAIConfig();
  Prepare_AI_Engine_TECH_2022();
  dIntf := TDrawEngineInterface_FMX.Create;
  viewer := TPictureViewerInterface.Create(DrawPool(self));
  viewer.ShowBackground := True;
  viewer.DrawEng.Scroll_Text_Direction := stdLB;
  viewer.PictureViewerStyle := pvsLeft2Right;
  viewer.AutoFit := True;
  viewer.InputPicture(New_Custom_Raster(1000, 1000, RColor(0, 0, 0, $FF)), True);

  Play_Activted := True;
  Play_Running := False;
  Critical := TCritical.Create;

  TCompute.RunM_NP(Do_Play, @Play_Running, nil);

  DrawPool(self).PostScrollText(1, '检测器运动目标分析是一种统计方法', 20, DEColor(1, 1, 1), DEColor(0, 0, 0, 0.9)).Forever := True;
end;

destructor T_153_Detector_Walking_Line_Form.Destroy;
begin
  Play_Activted := False;
  while Play_Running do
      TCompute.Sleep(100);
  RemoveDoStatusHook(self);
  DisposeObject(viewer);
  DisposeObject(Critical);
  inherited Destroy;
end;

procedure T_153_Detector_Walking_Line_Form.Do_Play;
var
  r: TFFMPEG_Reader;
  primary: TMPasAI_Raster;
  AI_2022: TPas_AI_TECH_2022;
  YOLO: TPas_AI_TECH_2022_YOLO_X_Handle;
  desc: TAI_TECH_2022_DESC;
  L: TV2L;
  i: Integer;
  d: TDrawEngine;
begin
  primary := TMPasAI_Raster.Create;
  L := TV2L.Create;
  AI_2022 := TPas_AI_TECH_2022.OpenEngine;
  YOLO := AI_2022.YOLO_X_Open_Stream(WhereFileFromConfigure('Detector_Walking_Line.YOLOX'));
  while Play_Activted do
    begin
      r := TFFMPEG_Reader.Create(WhereFileFromConfigure('Detector_Walking_Line.mp4'));
      r.ResetFit(viewer.First.Raster.Width, viewer.First.Raster.Height);
      L.Clear;
      while Play_Activted and r.ReadFrame(primary, True) do
        begin
          desc := AI_2022.YOLO_X_Process(YOLO, primary, 0.001);
          Critical.Lock;
          if length(desc) > 0 then
            begin
              d := primary.DrawEngine;
              for i := 0 to length(desc) - 1 do
                begin
                  d.DrawBox(desc[i].r, DEColor(1, 1, 1, 1), 3);
                  L.Add(RectCentre(desc[i].r));
                end;
              if L.Count > 0 then
                begin
                  L.Reduction(1.0);
                  d.DrawPL(False, L, False, DEColor(1, 1, 1), 2);
                  d.DrawEllipse(L.Last^, 5, DEColor(1, 1, 1), 1);
                end;
              d.Flush;
            end;
          viewer.First.Raster.SwapInstance(primary);
          viewer.First.Raster.Update;
          Critical.UnLock;
        end;
    end;
  DisposeObject(L);
  DisposeObject(primary);
  AI_2022.YOLO_X_Close(YOLO);
  DisposeObject(AI_2022);
end;

end.
