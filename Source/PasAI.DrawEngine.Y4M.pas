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
{ * Z.DrawEngine Yuv for mpeg soft Rasterization                               * }
{ ****************************************************************************** }
unit PasAI.DrawEngine.Y4M;

{$DEFINE FPC_DELPHI_MODE}
{$I PasAI.Define.inc}

interface

uses Math, PasAI.Geometry3D, PasAI.ListEngine, PasAI.PascalStrings, PasAI.UPascalStrings, PasAI.Core, PasAI.DrawEngine, PasAI.UnicodeMixedLib, PasAI.Geometry2D,
  PasAI.MemoryRaster, PasAI.h264.Y4M, PasAI.h264.Image_LIB, PasAI.h264.Types;

type
  TDrawEngine_YUV4MPEG = class(TDrawEngine_Raster)
  private
    FYW: TY4MWriter;
  public
    constructor CreateOnFile(const w, h, psf: uint16_t; const FileName: SystemString); overload;
    constructor CreateOnStream(const w, h, psf: uint16_t; const stream: TCore_Stream); overload;

    destructor Destroy; override;

    procedure Progress(deltaTime: Double);

    procedure Flush; override;
    function FrameCount: uint32_t;
    function Y4MSize: Int64_t;
    function PerSecondFrame: TDEFloat;
  end;

implementation

constructor TDrawEngine_YUV4MPEG.CreateOnFile(const w, h, psf: uint16_t; const FileName: SystemString);
var
  NW, NH: uint16_t;
begin
  inherited Create;
  NW := w - (w mod 2);
  NH := h - (h mod 2);
  FYW := TY4MWriter.CreateOnFile(NW, NH, psf, FileName);
  Memory.SetSize(NW, NH);
end;

constructor TDrawEngine_YUV4MPEG.CreateOnStream(const w, h, psf: uint16_t; const stream: TCore_Stream);
var
  NW, NH: uint16_t;
begin
  inherited Create;
  NW := w - (w mod 2);
  NH := h - (h mod 2);
  FYW := TY4MWriter.CreateOnStream(NW, NH, psf, stream);
  Memory.SetSize(NW, NH);
end;

destructor TDrawEngine_YUV4MPEG.Destroy;
begin
  DisposeObject(FYW);
  inherited Destroy;
end;

procedure TDrawEngine_YUV4MPEG.Progress(deltaTime: Double);
begin
  Engine.Progress(1 / FYW.PerSecondFrame);
end;

procedure TDrawEngine_YUV4MPEG.Flush;
begin
  inherited Flush;
  FYW.WriteFrame(Memory);
  FYW.Flush;
end;

function TDrawEngine_YUV4MPEG.FrameCount: uint32_t;
begin
  Result := FYW.FrameCount;
end;

function TDrawEngine_YUV4MPEG.Y4MSize: Int64_t;
begin
  Result := FYW.Y4MSize;
end;

function TDrawEngine_YUV4MPEG.PerSecondFrame: TDEFloat;
begin
  Result := FYW.PerSecondFrame;
end;

end.
