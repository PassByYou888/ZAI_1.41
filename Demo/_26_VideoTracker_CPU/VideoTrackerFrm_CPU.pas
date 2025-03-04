unit VideoTrackerFrm_CPU;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Controls.Presentation,
  FMX.StdCtrls, FMX.Objects, FMX.ScrollBox, FMX.Memo, FMX.Layouts, FMX.ExtCtrls,

  System.IOUtils,

  PasAI.Core, PasAI.AI, PasAI.AI.Common, PasAI.DrawEngine.SlowFMX, PasAI.DrawEngine, PasAI.MemoryRaster, PasAI.MemoryStream,
  PasAI.PascalStrings, PasAI.UnicodeMixedLib, PasAI.Geometry2D, PasAI.Geometry3D, PasAI.Cadencer, PasAI.h264.Y4M, PasAI.h264.Image_LIB,
  FMX.Memo.Types;

type
  TForm1 = class(TForm, ICadencerProgressInterface)
    Memo1: TMemo;
    PaintBox1: TPaintBox;
    Timer1: TTimer;
    Tracker_CheckBox: TCheckBox;
    HistogramEqualizeCheckBox: TCheckBox;
    AntialiasCheckBox: TCheckBox;
    SepiaCheckBox: TCheckBox;
    SharpenCheckBox: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject; Canvas: TCanvas);
  private
    procedure CadencerProgress(const deltaTime, newTime: Double);
  public
    drawIntf: TDrawEngineInterface_FMX;
    mpeg_y4m: TY4MReader;
    frame: TDETexture;
    cadencer_eng: TCadencer;
    ai: TPas_AI;
    od_hnd: TOD6L_Handle;
    tracker_hnd: TTracker_Handle;
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}


procedure TForm1.FormCreate(Sender: TObject);
begin
  // 读取zAI的配置
  CheckAndReadAIConfig;
  PasAI.AI.Prepare_AI_Engine();

  // 使用zDrawEngine做外部绘图时(比如游戏，面向paintbox)，都需要一个绘图接口
  // TDrawEngineInterface_FMX是面向FMX的绘图core接口
  // 如果不指定绘图接口，zDrawEngine会默认使用软件光栅绘图(比较慢)
  drawIntf := TDrawEngineInterface_FMX.Create;

  // mpeg yv12视频帧格式
  mpeg_y4m := TY4MReader.CreateOnFile(umlCombineFileName(TPath.GetLibraryPath, 'dog.Y4M'));

  // 当前绘制的视频帧
  frame := TDrawEngine.NewTexture;

  // cadencer引擎
  cadencer_eng := TCadencer.Create;
  cadencer_eng.ProgressInterface := Self;

  // ai引擎
  ai := TPas_AI.OpenEngine();

  // 加载svm-od的检测器(cpu对象检测器)
  od_hnd := ai.OD6L_Open_Stream(umlCombineFileName(TPath.GetLibraryPath, 'dog_video.svm_od'));

  // 初始化追踪器
  tracker_hnd := nil;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  cadencer_eng.Progress;
end;

procedure TForm1.PaintBox1Paint(Sender: TObject; Canvas: TCanvas);
  procedure Raster_DetectAndDraw(mr: TMPasAI_Raster);
  var
    d: TDrawEngine;
    od_desc: TOD_Desc;
    tracker_r: TRectV2;
    k: Double;
  begin
    // 使用dnn-od来检测小狗
    // 这里的参数含义是：最大只检测2个目标对象
    od_desc := ai.OD6L_Process(od_hnd, mr, 2);

    d := TDrawEngine.Create;
    d.ViewOptions := [];

    // drawEngine的输出方式是直接内存映射
    // 这种方式是0像素copy，直接写入到mr的bit内存
    // 我们处理ffmpeg视频流都可以使用drawengine实现立即绘图，因为它不会做任何多余的像素copy
    d.PasAI_Raster_.SetWorkMemory(mr);
    d.SetSize(mr);

    // 判断是否检测到小狗
    if length(od_desc) = 0 then
      begin
        if Tracker_CheckBox.IsChecked then
          if tracker_hnd <> nil then
            begin
              // 如果od没有检测到小狗，并且我们确定追踪器是开启的，开始追踪上一个od成功的框体
              k := ai.Tracker_Update(tracker_hnd, mr, tracker_r);
              // 把tracker追踪器的框体以粉红色画出来
              d.DrawCorner(TV2Rect4.Init(tracker_r, 45), DEColor(1, 0.5, 0.5, 1), 20, 3);

              d.BeginCaptureShadow(vec2(1, 1), 0.9);
              d.DrawText(Format('%f', [k]), 12, tracker_r, DEColor(1, 0.5, 0.5, 1), False);
              d.EndCaptureShadow;
            end;
      end
    else
      begin
        // 如果OD检测出了小狗
        // 我们重开一个追踪器
        // Tracker也是对一个框体进行学习，不过它不像od那样会做很多收敛处理，tracker几乎是实时学习的
        ai.Tracker_Close(tracker_hnd);

        if Tracker_CheckBox.IsChecked then
          begin
            ai.Tracker_Close(tracker_hnd);
            tracker_hnd := ai.Tracker_Open(mr, RectV2(od_desc[0]));
            tracker_r := RectV2(od_desc[0]);
            // 把tracker追踪器的框体以粉红色画出来
            d.DrawCorner(TV2Rect4.Init(tracker_r, 45), DEColor(1, 0.5, 0.5, 1), 20, 3);
          end;

        // 把OD的框体以蓝色画出来
        d.DrawCorner(TV2Rect4.Init(RectV2(od_desc[0]), 0), DEColor(0.5, 0.5, 1, 1), 20, 2);

        d.BeginCaptureShadow(vec2(1, 1), 0.9);
        d.DrawText(Format('%f', [od_desc[0].confidence]), 12, RectV2(od_desc[0]), DEColor(1, 0, 1, 1), False);
        d.EndCaptureShadow;
      end;

    // 执行绘图流指令
    d.Flush;
    disposeObject(d);

    // 这里演示了对视频输出做后期处理的部分方法

    // Sepia是非常漂亮的色彩系，常用于美工风格定义
    if SepiaCheckBox.IsChecked then
        Sepia32(mr, 12);

    // 使用色彩直方图修复yv12丢失的色彩
    // 让图像输出看起来更有电视感觉
    if HistogramEqualizeCheckBox.IsChecked then
        HistogramEqualize(mr);

    // 反锯齿
    if AntialiasCheckBox.IsChecked then
        Antialias32(mr, 1);

    // 锐化
    if SharpenCheckBox.IsChecked then
        Sharpen(mr, False);
  end;

var
  d: TDrawEngine;
begin
  drawIntf.SetSurface(Canvas, Sender);
  d := DrawPool(Sender, drawIntf);
  d.ViewOptions := [voFPS];
  d.FPSFontColor := DEColor(0.5, 0.5, 1, 1);

  mpeg_y4m.ReadFrame();
  YV12ToPasAI_Raster(mpeg_y4m.Image, frame);
  Raster_DetectAndDraw(frame);
  frame.ReleaseGPUMemory;

  d.FitDrawPicture(frame, frame.BoundsRectV2, d.ScreenRect, 1.0);

  if mpeg_y4m.CurrentFrame >= mpeg_y4m.FrameCount then
    begin
      mpeg_y4m.SeekFirstFrame;
      d.LastNewTime := 0;
      ai.Tracker_Close(tracker_hnd);
    end;

  // 执行绘图指令
  d.Flush;
end;

procedure TForm1.CadencerProgress(const deltaTime, newTime: Double);
begin
  CheckThread;
  EnginePool.Progress(deltaTime);
  Invalidate;
end;

end.
