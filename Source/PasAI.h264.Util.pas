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
unit PasAI.h264.Util;

{$DEFINE FPC_DELPHI_MODE}
{$I PasAI.Define.inc}

interface

uses
  PasAI.h264.Types, Math, PasAI.Core;

function fev_malloc(Size: uint32_t): Pointer;
procedure fev_free(PTR: Pointer);

function Min(const a, b: int32_t): int32_t;
function Max(const a, b: int32_t): int32_t;
function clip3(const a, b, c: int32_t): int32_t; // lower bound, value, upper bound
function Median(const x, y, Z: int32_t): int16_t;
function num2log2(n: int32_t): uint8_t;
procedure swap_ptr(var a, b: Pointer); overload;
procedure swap_ptr(var a, b: uint8_p); overload;

type
  mbcmp_func_t = function(pix1, pix2: uint8_p; stride: int32_t): int32_t;
  mbstat_func_t = function(pix: uint8_p): UInt32;
  pixmove_func_t = procedure(pix1, pix2: uint8_p; stride: int32_t);
  pixoper_func_t = procedure(pix1, pix2: uint8_p; Diff: int16_p);
  pixavg_func_t = procedure(src1, src2, dest: uint8_p; stride: int32_t);
  mc_chroma_func_t = procedure(Src, Dst: uint8_p; const stride: int32_t; coef: uint8_p);

  { TDsp }
  TDSP = class(TCore_Object_Intermediate)
  public
    sad_16x16, sad_8x8, sad_4x4, ssd_16x16, ssd_8x8, satd_4x4, satd_8x8, satd_16x16: mbcmp_func_t;
    var_16x16: mbstat_func_t;
    pixel_load_16x16, pixel_load_8x8, pixel_save_16x16, pixel_save_8x8: pixmove_func_t;
    pixel_add_4x4, pixel_sub_4x4: pixoper_func_t;
    pixel_avg_16x16: pixavg_func_t;
    pixel_loadu_16x16: pixmove_func_t;
    mc_chroma_8x8: mc_chroma_func_t;
    constructor Create;
  end;

var
  DSP: TDSP;

implementation

uses
  PasAI.h264.Pixel_LIB, PasAI.h264.Motion_comp;

(* ******************************************************************************
  evx_malloc, evx_mfree
  memory allocation with address aligned to 16-uint8_t boundaries
  ****************************************************************************** *)
function fev_malloc(Size: uint32_t): Pointer;
const
  alignment = 64;
var
  PTR: Pointer;
begin
  PTR := GetMemory(Size + alignment);
  Result := MemoryAlign(PTR, alignment);
  if Result = PTR then
      inc(uint8_p(Result), alignment);
  (uint8_p(Result) - 1)^ := nativeUInt(Result) - nativeUInt(PTR);
end;

procedure fev_free(PTR: Pointer);
begin
  if PTR = nil then
      Exit;
  dec(uint8_p(PTR), uint8_p(nativeUInt(PTR) - 1)^);
  FreeMemory(PTR);
  PTR := nil;
end;

function Min(const a, b: int32_t): int32_t;
begin
  if a < b then
      Result := a
  else
      Result := b;
end;

function Max(const a, b: int32_t): int32_t;
begin
  if a >= b then
      Result := a
  else
      Result := b;
end;

function clip3(const a, b, c: int32_t): int32_t;
begin
  if b < a then
      Result := a
  else if b > c then
      Result := c
  else
      Result := b;
end;

function Median(const x, y, Z: int32_t): int16_t;
begin
  Result := x + y + Z - Min(x, Min(y, Z)) - Max(x, Max(y, Z));
end;

function num2log2(n: int32_t): uint8_t;
begin
  Result := Ceil(Log2(n));
end;

procedure swap_ptr(var a, b: Pointer);
var
  t: Pointer;
begin
  t := a;
  a := b;
  b := t;
end;

procedure swap_ptr(var a, b: uint8_p);
var
  t: uint8_p;
begin
  t := a;
  a := b;
  b := t;
end;

{ TDsp }

constructor TDSP.Create;
begin
  pixel_init;
  motion_compensate_init;

  sad_16x16 := PasAI.h264.Pixel_LIB.sad_16x16;
  sad_8x8 := PasAI.h264.Pixel_LIB.sad_8x8;
  sad_4x4 := PasAI.h264.Pixel_LIB.sad_4x4;
  satd_16x16 := PasAI.h264.Pixel_LIB.satd_16x16;
  satd_8x8 := PasAI.h264.Pixel_LIB.satd_8x8;
  satd_4x4 := PasAI.h264.Pixel_LIB.satd_4x4;
  ssd_16x16 := PasAI.h264.Pixel_LIB.ssd_16x16;
  ssd_8x8 := PasAI.h264.Pixel_LIB.ssd_8x8;
  var_16x16 := PasAI.h264.Pixel_LIB.var_16x16;

  pixel_loadu_16x16 := PasAI.h264.Pixel_LIB.pixel_loadu_16x16;
  pixel_load_16x16 := PasAI.h264.Pixel_LIB.pixel_load_16x16;
  pixel_load_8x8 := PasAI.h264.Pixel_LIB.pixel_load_8x8;
  pixel_save_16x16 := PasAI.h264.Pixel_LIB.pixel_save_16x16;
  pixel_save_8x8 := PasAI.h264.Pixel_LIB.pixel_save_8x8;
  pixel_add_4x4 := PasAI.h264.Pixel_LIB.pixel_add_4x4;
  pixel_sub_4x4 := PasAI.h264.Pixel_LIB.pixel_sub_4x4;
  pixel_avg_16x16 := PasAI.h264.Pixel_LIB.pixel_avg_16x16;

  mc_chroma_8x8 := PasAI.h264.Motion_comp.mc_chroma_8x8;
end;

end.
