unit DNN_OD2_Frm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Controls.Presentation,
  FMX.StdCtrls, FMX.Objects, FMX.ScrollBox, FMX.Memo, FMX.Layouts, FMX.ExtCtrls,

  System.IOUtils,

  PasAI.Core, PasAI.AI, PasAI.AI.Common, PasAI.DrawEngine.SlowFMX, PasAI.DrawEngine, PasAI.MemoryRaster, PasAI.MemoryStream,
  PasAI.Status,
  PasAI.PascalStrings, PasAI.UnicodeMixedLib, PasAI.Geometry2D, PasAI.Geometry3D, PasAI.Cadencer, PasAI.FFMPEG, PasAI.FFMPEG.Reader,
  FMX.Memo.Types;

type
  TForm1 = class(TForm, ICadencerProgressInterface)
    Memo1: TMemo;
    PaintBox1: TPaintBox;
    Timer1: TTimer;
    HistogramEqualizeCheckBox: TCheckBox;
    AntialiasCheckBox: TCheckBox;
    SepiaCheckBox: TCheckBox;
    SharpenCheckBox: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject; Canvas: TCanvas);
  private
    procedure CadencerProgress(const deltaTime, newTime: Double);
    procedure DoStatusMethod(Text_: SystemString; const ID: Integer);
  public
    drawIntf: TDrawEngineInterface_FMX;
    mpeg_r: TFFMPEG_Reader;
    frame: TDETexture;
    cadencer_eng: TCadencer;
    ai: TPas_AI;
    mmod_hnd: TMMOD6L_Handle;
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}


procedure TForm1.DoStatusMethod(Text_: SystemString; const ID: Integer);
begin
  Memo1.Lines.Add(Text_);
  Memo1.GoToTextEnd;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  AddDoStatusHook(Self, DoStatusMethod);
  // 读取zAI的配置
  CheckAndReadAIConfig;
  PasAI.AI.Prepare_AI_Engine();

  // 使用zDrawEngine做外部绘图时(比如游戏，面向paintbox)，都需要一个绘图接口
  // TDrawEngineInterface_FMX是面向FMX的绘图core接口
  // 如果不指定绘图接口，zDrawEngine会默认使用软件光栅绘图(比较慢)
  drawIntf := TDrawEngineInterface_FMX.Create;

  // mp4视频帧格式
  mpeg_r := TFFMPEG_Reader.Create(umlCombineFileName(TPath.GetLibraryPath, 'market2.mp4'));

  // 当前绘制的视频帧
  frame := TDrawEngine.NewTexture;

  // cadencer引擎
  cadencer_eng := TCadencer.Create;
  cadencer_eng.ProgressInterface := Self;

  // ai引擎
  ai := TPas_AI.OpenEngine();

  // 加载dnn-od的检测器
  mmod_hnd := ai.MMOD6L_DNN_Open_Stream(umlCombineFileName(TPath.GetLibraryPath, 'RealTime_MMOD.svm_dnn_od'));
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  cadencer_eng.Progress;
end;

procedure TForm1.PaintBox1Paint(Sender: TObject; Canvas: TCanvas);
  procedure Raster_DetectAndDraw(mr: TMPasAI_Raster);
  begin
    ai.DrawMMOD(mmod_hnd, mr, DEColor(0.5, 0.5, 1, 1), 10);

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

  d.FillBox(d.ScreenRect, DEColor(0, 0, 0));

  while not mpeg_r.ReadFrame(frame, True) do
    begin
      mpeg_r.Seek(0);
      d.LastNewTime := 0;
    end;
  Raster_DetectAndDraw(frame);
  d.FitDrawPicture(frame, frame.BoundsRectV2, d.ScreenRect, 1.0);

  // 执行绘图指令
  d.Flush;
  frame.ReleaseGPUMemory;
end;

procedure TForm1.CadencerProgress(const deltaTime, newTime: Double);
begin
  CheckThread;
  EnginePool.Progress(deltaTime);
  Invalidate;
end;

end.
