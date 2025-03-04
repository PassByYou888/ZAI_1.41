(*
https://zpascal.net
https://github.com/PassByYou888/ZNet
https://github.com/PassByYou888/zRasterization
https://github.com/PassByYou888/ZSnappy
https://github.com/PassByYou888/Z-AI1.4
https://github.com/PassByYou888/InfiniteIoT
https://github.com/PassByYou888/zMonitor_3rd_Core
https://github.com/PassByYou888/tcmalloc4p
https://github.com/PassByYou888/jemalloc4p
https://github.com/PassByYou888/zCloud
https://github.com/PassByYou888/ZServer4D
https://github.com/PassByYou888/zShell
https://github.com/PassByYou888/ZDB2.0
https://github.com/PassByYou888/zGameWare
https://github.com/PassByYou888/CoreCipher
https://github.com/PassByYou888/zChinese
https://github.com/PassByYou888/zSound
https://github.com/PassByYou888/zExpression
https://github.com/PassByYou888/ZInstaller2.0
https://github.com/PassByYou888/zAI
https://github.com/PassByYou888/NetFileService
https://github.com/PassByYou888/zAnalysis
https://github.com/PassByYou888/PascalString
https://github.com/PassByYou888/zInstaller
https://github.com/PassByYou888/zTranslate
https://github.com/PassByYou888/zVision
https://github.com/PassByYou888/FFMPEG-Header
*)
{ ****************************************************************************** }
{ * h264 encoder                                                               * }
{ ****************************************************************************** }
unit PasAI.h264;

{$DEFINE FPC_DELPHI_MODE}
{$I PasAI.Define.inc}

interface

uses SysUtils, PasAI.Core, PasAI.PascalStrings, PasAI.UPascalStrings, PasAI.UnicodeMixedLib, PasAI.MemoryRaster,
  PasAI.h264.Image_LIB, PasAI.h264.Types, PasAI.h264.Encoder, PasAI.h264.Parameters, PasAI.h264.Y4M;

type
  TH264Writer = class(TCore_Object_Intermediate)
  private
    IOHandle: TIOHnd;
    FFrameCount: uint32_t;
    img: TPlanarImage;
    Param: TEncodingParameters;
    Encoder: TFevh264Encoder;
    buffer: PByte;
  public
    constructor Create(const w, h, totalframe: int32_t; psf: Single; const FileName: TPascalString); overload;
    constructor Create(const w, h, totalframe: int32_t; psf: Single; const stream: TCore_Stream); overload;

    destructor Destroy; override;

    procedure WriteFrame(raster: TMPasAI_Raster);
    procedure WriteY4M(r: TY4MReader);
    procedure Flush;

    property FrameCount: uint32_t read FFrameCount;
    function H264Size: Int64_t;
    function width: uint16_t;
    function height: uint16_t;
    function PerSecondFrame: Single;
  end;

implementation

constructor TH264Writer.Create(const w, h, totalframe: int32_t; psf: Single; const FileName: TPascalString);
begin
  inherited Create;
  umlFileCreate(FileName, IOHandle);
  FFrameCount := 0;
  img := TPlanarImage.Create(w, h);
  Param := TEncodingParameters.Create;
  Param.SetStreamParams(w, h, totalframe, psf);
  Param.AnalysisLevel := 2;
  Encoder := TFevh264Encoder.Create(Param);
  buffer := GetMemory(w * h * 4);
end;

constructor TH264Writer.Create(const w, h, totalframe: int32_t; psf: Single; const stream: TCore_Stream);
begin
  inherited Create;
  umlFileCreateAsStream(stream, IOHandle);
  FFrameCount := 0;
  img := TPlanarImage.Create(w, h);
  Param := TEncodingParameters.Create;
  Param.SetStreamParams(w, h, totalframe, psf);
  Param.AnalysisLevel := 2;
  Encoder := TFevh264Encoder.Create(Param);
  buffer := GetMemory(w * h * 4);
end;

destructor TH264Writer.Destroy;
begin
  FreeMemory(buffer);
  DisposeObject(Param);
  DisposeObject(Encoder);
  DisposeObject(img);
  umlFileClose(IOHandle);
  inherited Destroy;
end;

procedure TH264Writer.WriteFrame(raster: TMPasAI_Raster);
var
  oSiz: uint32_t;
begin
  if FFrameCount >= Param.FrameCount then
      Exit;
  img.LoadFromRaster(raster);
  Encoder.EncodeFrame(img, buffer, oSiz);
  umlFileWrite(IOHandle, oSiz, buffer^);
  inc(FFrameCount);
end;

procedure TH264Writer.WriteY4M(r: TY4MReader);
var
  i: int32_t;
  p_img: TPlanarImage;
  raster: TMPasAI_Raster;
begin
  raster := TMPasAI_Raster.Create;
  r.SeekFirstFrame;
  for i := r.CurrentFrame to r.FrameCount - 1 do
    begin
      p_img := r.ReadFrame;
      p_img.SaveToRaster(raster);
      WriteFrame(raster);
    end;
  DisposeObject(raster);
end;

procedure TH264Writer.Flush;
begin
  umlFileFlushWriteCache(IOHandle);
end;

function TH264Writer.H264Size: Int64_t;
begin
  Result := umlFileSize(IOHandle);
end;

function TH264Writer.width: uint16_t;
begin
  Result := Param.FrameWidth;
end;

function TH264Writer.height: uint16_t;
begin
  Result := Param.FrameHeight;
end;

function TH264Writer.PerSecondFrame: Single;
begin
  Result := Param.FrameRate;
end;

end.
