unit RasterizationFormatFrm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,

  System.IOUtils,

  PasAI.Core, PasAI.PascalStrings, PasAI.UnicodeMixedLib, PasAI.Status, PasAI.DFE, PasAI.Net.PhysicsIO,
  PasAI.TextDataEngine, PasAI.ListEngine, PasAI.DrawEngine, PasAI.MemoryRaster, PasAI.MemoryStream, PasAI.Geometry2D,
  PasAI.AI.Common, PasAI.DrawEngine.SlowFMX, PasAI.MemoryRaster.JPEG.Type_LIB;

type
  TRasterizationFormatForm = class(TForm)
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    Image10: TImage;
    Image11: TImage;
    Image12: TImage;
    Image13: TImage;
    Image14: TImage;
    Image15: TImage;
    Image16: TImage;
    Image17: TImage;
    Image18: TImage;
    Image19: TImage;
    Image20: TImage;
    Image21: TImage;
    Image22: TImage;
    Image23: TImage;
    Image24: TImage;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RasterizationFormatForm: TRasterizationFormatForm;

implementation

{$R *.fmx}


type
  TSaveProc1 = procedure(stream: TCore_Stream) of object;
  TSaveProc2 = procedure(stream: TCore_Stream; Quality: TJpegQuality) of object;

procedure BuildFormat(proc: TSaveProc1; dest: TBitmap; fInfo: SystemString); overload;
const
  test_count = 5;
var
  m64: TMS64;
  nMR: TMPasAI_Raster;
  d: TDrawEngine;
  tk, savetk, loadtk: TTimeTick;
  i: Integer;
begin
  m64 := TMS64.Create;
  tk := GetTimeTick();

  for i := 1 to test_count do
    begin
      m64.Position := 0;
      proc(m64);
    end;
  savetk := GetTimeTick - tk;

  nMR := TMPasAI_Raster.Create;

  tk := GetTimeTick();

  for i := 1 to test_count do
    begin
      m64.Position := 0;
      nMR.LoadFromStream(m64);
    end;
  loadtk := GetTimeTick - tk;

  d := TDrawEngine.Create;
  d.PasAI_Raster_.SetWorkMemory(nMR);
  d.ViewOptions := [];

  d.BeginCaptureShadow(Vec2(1, 1), 0.9);
  d.DrawText(
    PFormat(
    '%s' + #13#10 +
    'save %d ms, load %d ms' + #13#10 +
    'size:%s',
    [fInfo, savetk div test_count, loadtk div test_count, umlSizeToStr(m64.Size).Text]), 24, d.ScreenRect, DEColor(1, 1, 1, 1), False);
  d.EndCaptureShadow;

  d.Flush;
  disposeObject(d);

  TThread.Synchronize(TThread.CurrentThread, procedure
    begin
      MemoryBitmapToBitmap(nMR, dest);
    end);

  disposeObject(m64);
  disposeObject(nMR);
end;

procedure BuildFormat(proc: TSaveProc2; Quality: TJpegQuality; dest: TBitmap; fInfo: SystemString); overload;
const
  test_count = 5;
var
  m64: TMS64;
  nMR: TMPasAI_Raster;
  d: TDrawEngine;
  tk, savetk, loadtk: TTimeTick;
  i: Integer;
begin
  m64 := TMS64.Create;
  tk := GetTimeTick();

  for i := 1 to test_count do
    begin
      m64.Position := 0;
      proc(m64, Quality);
    end;
  savetk := GetTimeTick - tk;

  nMR := TMPasAI_Raster.Create;

  tk := GetTimeTick();

  for i := 1 to test_count do
    begin
      m64.Position := 0;
      nMR.LoadFromStream(m64);
    end;
  loadtk := GetTimeTick - tk;

  d := TDrawEngine.Create;
  d.PasAI_Raster_.SetWorkMemory(nMR);
  d.ViewOptions := [];

  d.BeginCaptureShadow(Vec2(1, 1), 0.9);
  d.DrawText(
    PFormat(
    '%s' + #13#10 +
    'save %d ms, load %d ms' + #13#10 +
    'size:%s',
    [fInfo, savetk div test_count, loadtk div test_count, umlSizeToStr(m64.Size).Text]), 24, d.ScreenRect, DEColor(1, 1, 1, 1), False);
  d.EndCaptureShadow;

  d.Flush;
  disposeObject(d);

  TThread.Synchronize(TThread.CurrentThread, procedure
    begin
      MemoryBitmapToBitmap(nMR, dest);
    end);

  disposeObject(m64);
  disposeObject(nMR);
end;

procedure TRasterizationFormatForm.FormCreate(Sender: TObject);
begin
  TComputeThread.RunP(nil, nil, procedure(Sender: TComputeThread)
    var
      oriMR: TMPasAI_Raster;
    begin
      oriMR := NewPasAI_RasterFromFile(WhereFileFromConfigure('lena.bmp'));

      BuildFormat(oriMR.SaveToBmp24Stream, Image1.Bitmap, 'RGB24');
      BuildFormat(oriMR.SaveToFastYV12Stream, Image2.Bitmap, 'YV12-Loss');
      BuildFormat(oriMR.SaveToFastHalfYUVStream, Image3.Bitmap, 'HalfYUV-Loss');
      BuildFormat(oriMR.SaveToFastQuartYUVStream, Image4.Bitmap, 'quartYUV-Loss');
      BuildFormat(oriMR.SaveToJpegLS3Stream, Image5.Bitmap, 'JpegLS-Loss');
      BuildFormat(oriMR.SaveToPNGStream, Image6.Bitmap, 'PNG');
      BuildFormat(oriMR.SaveToZLibCompressStream, Image7.Bitmap, 'zLIB-RGB');
      BuildFormat(oriMR.SaveToDeflateCompressStream, Image8.Bitmap, 'deflate-RGB');
      BuildFormat(oriMR.SaveToBRRCCompressStream, Image9.Bitmap, 'BRRC-RGB');
      BuildFormat(oriMR.SaveToYV12Stream, Image10.Bitmap, 'zLIB-YV12-Loss');
      BuildFormat(oriMR.SaveToHalfYUVStream, Image11.Bitmap, 'zLIB-HalfYUV-Loss');
      BuildFormat(oriMR.SaveToQuartYUVStream, Image12.Bitmap, 'zLIB-QuartYUV-Loss');
      BuildFormat(oriMR.SaveToBmp32Stream, Image13.Bitmap, 'RGBA32');
      BuildFormat(oriMR.SaveToJpegYCbCrAStream, 90, Image14.Bitmap, 'Jpeg-YCbCrA-Qualily90-Loss');
      BuildFormat(oriMR.SaveToJpegYCbCrStream, 90, Image15.Bitmap, 'Jpeg-YCbCr-Qualily90-Loss');
      BuildFormat(oriMR.SaveToJpegGrayStream, 90, Image16.Bitmap, 'Jpeg-Gray-Qualily90-Loss');
      BuildFormat(oriMR.SaveToJpegGrayAStream, 90, Image17.Bitmap, 'Jpeg-GrayA-Qualily90-Loss');
      BuildFormat(oriMR.SaveToJpegCMYKStream, 90, Image18.Bitmap, 'Jpeg-CMYK-Qualily90-Loss');
      BuildFormat(oriMR.SaveToJpegYCbCrAStream, 50, Image19.Bitmap, 'Jpeg-YCbCrA-Qualily50-Loss');
      BuildFormat(oriMR.SaveToJpegYCbCrStream, 50, Image20.Bitmap, 'Jpeg-YCbCr-Qualily50-Loss');
      BuildFormat(oriMR.SaveToJpegGrayStream, 50, Image21.Bitmap, 'Jpeg-Gray-Qualily50-Loss');
      BuildFormat(oriMR.SaveToJpegGrayAStream, 50, Image22.Bitmap, 'Jpeg-GrayA-Qualily50-Loss');
      BuildFormat(oriMR.SaveToJpegCMYKStream, 50, Image23.Bitmap, 'Jpeg-CMYK-Qualily50-Loss');
      BuildFormat(oriMR.SaveToColor255Stream, Image24.Bitmap, 'Color256-Loss');

      disposeObject(oriMR);
    end);
end;

end.
