unit _155_Image_Sampling_Jitter_Frm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Objects, FMX.StdCtrls, FMX.Edit, FMX.Controls.Presentation, FMX.Layouts,
  PasAI.Core, PasAI.PascalStrings, PasAI.UPascalStrings, PasAI.UnicodeMixedLib,
  PasAI.Geometry2D, PasAI.Geometry3D, PasAI.DrawEngine, PasAI.DrawEngine.SlowFMX, PasAI.MemoryRaster, PasAI.Expression;

type
  T_155_Image_Sampling_Jitter_Form = class(TForm)
    fpsTimer: TTimer;
    rendererTimer: TTimer;
    pb: TPaintBox;
    tool_pb: TPaintBox;
    jitter_sampling_Button: TButton;
    XY_Offset_Scale_Layout: TLayout;
    XY_Offset_Scale_Label: TLabel;
    XY_Offset_Scale_Edit: TEdit;
    Rotate_Layout: TLayout;
    Rotate_Label: TLabel;
    Rotate_Edit: TEdit;
    Scale_Layout: TLayout;
    Scale_Label: TLabel;
    Scale_Edit: TEdit;
    Output_Size_Layout: TLayout;
    Output_Size_Label: TLabel;
    Output_Size_Edit: TEdit;
    Sampling_Scale_Layout: TLayout;
    Sampling_Scale_Label: TLabel;
    Sampling_Scale_Edit: TEdit;
    Lock_Sampler_CheckBox: TCheckBox;
    Sampling_Pos_Layout: TLayout;
    Sampling_Pos_Label: TLabel;
    Sampling_Pos_Edit: TEdit;
    Open_Button: TButton;
    Pic_OpenDialog: TOpenDialog;
    Fit_Box_CheckBox: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure fpsTimerTimer(Sender: TObject);
    procedure rendererTimerTimer(Sender: TObject);
    procedure FormPaint(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
    procedure jitter_sampling_ButtonClick(Sender: TObject);
    procedure Open_ButtonClick(Sender: TObject);
    procedure pbPaint(Sender: TObject; Canvas: TCanvas);
  private
  public
    bk: TPasAI_Raster;
    sour, dest: TMPasAI_Raster;
    sour_box: TV2R4;
    dest_size: TVec2;
    procedure Do_Jitter;
  end;

var
  _155_Image_Sampling_Jitter_Form: T_155_Image_Sampling_Jitter_Form;

implementation

{$R *.fmx}


uses StyleModuleUnit;

procedure T_155_Image_Sampling_Jitter_Form.FormCreate(Sender: TObject);
begin
  bk := NewPasAI_Raster;
  bk.SetSize($FF, $FF);
  FillBlackGrayBackgroundTexture(bk, 32);
  sour := NewPasAI_RasterFromFile('lena.bmp');
  dest := NewPasAI_Raster();
  Do_Jitter();

  DrawPool(self).PostScrollText(1, '全图采样用于无监督DNN模型,例如著名的 "Barlow Twins: Self-Supervised Learning via Redundancy Reduction"', 15, DEColor(1, 1, 1), DEColor(0, 0, 0)).Forever := True;
  DrawPool(self).PostScrollText(1, '在DNN训练流程中,全图抖动采样会执行上亿次', 14, DEColor(1, 1, 1), DEColor(0, 0, 0)).Forever := True;
  DrawPool(self).PostScrollText(1, '全图采样针对全图片采样,图片可以非常大(4k),也可以很小(360p),数据采样结果与图片尺寸无关', 14, DEColor(1, 1, 1), DEColor(0, 0, 0)).Forever := True;
  DrawPool(self).PostScrollText(1, '采样坐标0.5,0.5,表示从中心点采样', 14, DEColor(1, 0.5, 0.5), DEColor(0, 0, 0)).Forever := True;
  DrawPool(self).PostScrollText(1, '采样尺度0.5,0.5,表示采样框宽=0.5*尺寸宽,采样框高=0.5*尺寸高', 14, DEColor(1, 0.5, 0.5), DEColor(0, 0, 0)).Forever := True;
  DrawPool(self).PostScrollText(1, '采样输出尺寸64,64,表示输出64*64的小图,同时64*64也被最小走样机制影响(Min-Loss-Box)', 14, DEColor(1, 1, 1), DEColor(0, 0, 0)).Forever := True;
end;

procedure T_155_Image_Sampling_Jitter_Form.fpsTimerTimer(Sender: TObject);
begin
  DrawPool.Progress;
  CheckThread;
end;

procedure T_155_Image_Sampling_Jitter_Form.rendererTimerTimer(Sender: TObject);
begin
  Invalidate;
end;

procedure T_155_Image_Sampling_Jitter_Form.FormPaint(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
var
  d: TDrawEngine;
  r, r2: TRectV2;
begin
  Canvas.Font.Style := [TFontStyle.fsBold];
  d := TDIntf.DrawEngine_Interface.SetSurfaceAndGetDrawPool(Canvas, Sender);
  d.DrawTile(bk);
  r2 := RectEdge(d.ScreenV2, -40);
  r2[1, 0] := tool_pb.Position.X - 20;
  r := d.FitDrawPicture(sour, sour.BoundsRectV20, r2, 1.0);
  d.DrawBox(r, DEColor(1, 1, 1), 2);
  d.DrawBox(sour_box.Projection(sour.BoundsRectV20, r), DEColor(0, 1, 0), 2);
  d.Flush;
end;

procedure T_155_Image_Sampling_Jitter_Form.jitter_sampling_ButtonClick(Sender: TObject);
begin
  Do_Jitter();
end;

procedure T_155_Image_Sampling_Jitter_Form.pbPaint(Sender: TObject; Canvas: TCanvas);
var
  d: TDrawEngine;
  r: TRectV2;
begin
  d := TDIntf.DrawEngine_Interface.SetSurfaceAndGetDrawPool(Canvas, Sender);
  d.Options := [voEdge];
  d.EdgeSize := 2;
  d.EdgeColor := DEColor(1, 0.5, 0.5, 1);
  r := d.FitDrawPicture(dest, dest.BoundsRectV20, RectEdge(d.ScreenV2, -10), 1.0);
  d.DrawBox(r, DEColor(1, 1, 1), 1);
  d.Flush;
end;

procedure T_155_Image_Sampling_Jitter_Form.Do_Jitter;
begin
  dest_size := StrToVec2(Output_Size_Edit.Text);
  // 生成抖动框+抖动小图
  disposeObject(dest);
  dest := sour.Build_Jitter_Fit_Box_Raster(
    StrToVec2(Sampling_Scale_Edit.Text),
    StrToVec2(Sampling_Pos_Edit.Text),
    EStrToFloat(XY_Offset_Scale_Edit.Text),
    EStrToFloat(Rotate_Edit.Text),
    EStrToFloat(Scale_Edit.Text),
    Fit_Box_CheckBox.IsChecked,
    dest_size,
    Lock_Sampler_CheckBox.IsChecked,
    sour_box);
end;

procedure T_155_Image_Sampling_Jitter_Form.Open_ButtonClick(Sender: TObject);
begin
  if not Pic_OpenDialog.Execute then
      exit;
  sour.LoadFromFile(Pic_OpenDialog.FileName);
  sour.Update;
  Do_Jitter();
end;

end.
