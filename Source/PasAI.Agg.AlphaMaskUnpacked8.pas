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
{ * memory Rasterization with AGG                                              * }
{ * by QQ 600585@qq.com                                                        * }


(*
  ////////////////////////////////////////////////////////////////////////////////
  //                                                                            //
  //  Anti-Grain Geometry (modernized Pascal fork, aka 'AggPasMod')             //
  //    Maintained by Christian-W. Budde (Christian@pcjv.de)                    //
  //    Copyright (c) 2012-2017                                                 //
  //                                                                            //
  //  Based on:                                                                 //
  //    Pascal port by Milan Marusinec alias Milano (milan@marusinec.sk)        //
  //    Copyright (c) 2005-2006, see http://www.aggpas.org                      //
  //                                                                            //
  //  Original License:                                                         //
  //    Anti-Grain Geometry - Version 2.4 (Public License)                      //
  //    Copyright (C) 2002-2005 Maxim Shemanarev (http://www.antigrain.com)     //
  //    Contact: McSeem@antigrain.com / McSeemAgg@yahoo.com                     //
  //                                                                            //
  //  Permission to copy, use, modify, sell and distribute this software        //
  //  is granted provided this copyright notice appears in all copies.          //
  //  This software is provided "as is" without express or implied              //
  //  warranty, and with no claim as to its suitability for any purpose.        //
  //                                                                            //
  ////////////////////////////////////////////////////////////////////////////////
*)
unit PasAI.Agg.AlphaMaskUnpacked8;

{$DEFINE FPC_DELPHI_MODE}
{$I PasAI.Define.inc}
interface

uses
  PasAI.Agg.Basics,
  PasAI.Agg.RenderingBuffer;

const
  CAggCoverShift = 8;
  CAggCoverNone = 0;
  CAggCoverFull = 255;

type
  TAggFuncMaskCalculate = function(p: PInt8u): Cardinal;

  TAggCustomAlphaMask = class
  public
    procedure Attach(RenderingBuffer: TAggRenderingBuffer); virtual; abstract;

    function MaskFunction: TAggFuncMaskCalculate; virtual; abstract;

    function Pixel(x, y: Integer): Int8u; virtual; abstract;
    function CombinePixel(x, y: Integer; val: Int8u): Int8u; virtual; abstract;

    procedure FillHSpan(x, y: Integer; Dst: PInt8u; NumPixel: Integer); virtual;
      abstract;
    procedure CombineHSpan(x, y: Integer; Dst: PInt8u; NumPixel: Integer);
      virtual; abstract;
    procedure FillVSpan(x, y: Integer; Dst: PInt8u; NumPixel: Integer); virtual;
      abstract;
    procedure CombineVSpan(x, y: Integer; Dst: PInt8u; NumPixel: Integer);
      virtual; abstract;
  end;

  TAggAlphaMaskUnpacked8 = class(TAggCustomAlphaMask)
  private
    Step, Offset: Cardinal;

    FRenderingBuffer: TAggRenderingBuffer;
    FMaskFunction: TAggFuncMaskCalculate;
  public
    constructor Create(MaskF: TAggFuncMaskCalculate; AStep: Cardinal = 1;
      AOffset: Cardinal = 0); overload;
    constructor Create(RenderingBuffer: TAggRenderingBuffer;
      MaskF: TAggFuncMaskCalculate; AStep: Cardinal = 1;
      AOffset: Cardinal = 0); overload;

    procedure Attach(RenderingBuffer: TAggRenderingBuffer); override;

    function MaskFunction: TAggFuncMaskCalculate; override;

    function Pixel(x, y: Integer): Int8u; override;
    function CombinePixel(x, y: Integer; val: Int8u): Int8u; override;

    procedure FillHSpan(x, y: Integer; Dst: PInt8u; NumPixel: Integer); override;
    procedure CombineHSpan(x, y: Integer; Dst: PInt8u; NumPixel: Integer); override;
    procedure FillVSpan(x, y: Integer; Dst: PInt8u; NumPixel: Integer); override;
    procedure CombineVSpan(x, y: Integer; Dst: PInt8u; NumPixel: Integer); override;
  end;

  TAggAlphaMaskGray8 = class(TAggAlphaMaskUnpacked8)
  public
    constructor Create(RenderingBuffer: TAggRenderingBuffer);
  end;

  TAggAlphaMaskRgb24Red = class(TAggAlphaMaskUnpacked8)
  public
    constructor Create(RenderingBuffer: TAggRenderingBuffer);
  end;

  TAggAlphaMaskRgb24Green = class(TAggAlphaMaskUnpacked8)
  public
    constructor Create(RenderingBuffer: TAggRenderingBuffer);
  end;

  TAggAlphaMaskRgb24Blue = class(TAggAlphaMaskUnpacked8)
  public
    constructor Create(RenderingBuffer: TAggRenderingBuffer);
  end;

  TAggAlphaMaskBgr24Red = class(TAggAlphaMaskUnpacked8)
  public
    constructor Create(RenderingBuffer: TAggRenderingBuffer);
  end;

  TAggAlphaMaskBgr24Green = class(TAggAlphaMaskUnpacked8)
  public
    constructor Create(RenderingBuffer: TAggRenderingBuffer);
  end;

  TAggAlphaMaskBgr24Blue = class(TAggAlphaMaskUnpacked8)
  public
    constructor Create(RenderingBuffer: TAggRenderingBuffer);
  end;

  TAggAlphaMaskRgba32Red = class(TAggAlphaMaskUnpacked8)
  public
    constructor Create(RenderingBuffer: TAggRenderingBuffer);
  end;

  TAggAlphaMaskRgba32Green = class(TAggAlphaMaskUnpacked8)
  public
    constructor Create(RenderingBuffer: TAggRenderingBuffer);
  end;

  TAggAlphaMaskRgba32Blue = class(TAggAlphaMaskUnpacked8)
  public
    constructor Create(RenderingBuffer: TAggRenderingBuffer);
  end;

  TAggAlphaMaskRgba32Alpha = class(TAggAlphaMaskUnpacked8)
  public
    constructor Create(RenderingBuffer: TAggRenderingBuffer);
  end;

  TAggAlphaMaskArgb32Red = class(TAggAlphaMaskUnpacked8)
  public
    constructor Create(RenderingBuffer: TAggRenderingBuffer);
  end;

  TAggAlphaMaskArgb32Green = class(TAggAlphaMaskUnpacked8)
  public
    constructor Create(RenderingBuffer: TAggRenderingBuffer);
  end;

  TAggAlphaMaskArgb32Blue = class(TAggAlphaMaskUnpacked8)
  public
    constructor Create(RenderingBuffer: TAggRenderingBuffer);
  end;

  TAggAlphaMaskArgb32Alpha = class(TAggAlphaMaskUnpacked8)
  public
    constructor Create(RenderingBuffer: TAggRenderingBuffer);
  end;

  TAggAlphaMaskBgra32Red = class(TAggAlphaMaskUnpacked8)
  public
    constructor Create(RenderingBuffer: TAggRenderingBuffer);
  end;

  TAggAlphaMaskBgra32Green = class(TAggAlphaMaskUnpacked8)
  public
    constructor Create(RenderingBuffer: TAggRenderingBuffer);
  end;

  TAggAlphaMaskBgra32Blue = class(TAggAlphaMaskUnpacked8)
  public
    constructor Create(RenderingBuffer: TAggRenderingBuffer);
  end;

  TAggAlphaMaskBgra32Alpha = class(TAggAlphaMaskUnpacked8)
  public
    constructor Create(RenderingBuffer: TAggRenderingBuffer);
  end;

  TAggAlphaMaskAbgr32Red = class(TAggAlphaMaskUnpacked8)
  public
    constructor Create(RenderingBuffer: TAggRenderingBuffer);
  end;

  TAggAlphaMaskAbgr32Green = class(TAggAlphaMaskUnpacked8)
  public
    constructor Create(RenderingBuffer: TAggRenderingBuffer);
  end;

  TAggAlphaMaskAbgr32Blue = class(TAggAlphaMaskUnpacked8)
  public
    constructor Create(RenderingBuffer: TAggRenderingBuffer);
  end;

  TAggAlphaMaskAbgr32Alpha = class(TAggAlphaMaskUnpacked8)
  public
    constructor Create(RenderingBuffer: TAggRenderingBuffer);
  end;

  TAggAlphaMaskRgb24Gray = class(TAggAlphaMaskUnpacked8)
  public
    constructor Create(RenderingBuffer: TAggRenderingBuffer);
  end;

  TAggAlphaMaskBgr24Gray = class(TAggAlphaMaskUnpacked8)
  public
    constructor Create(RenderingBuffer: TAggRenderingBuffer);
  end;

  TAggAlphaMaskRgba32Gray = class(TAggAlphaMaskUnpacked8)
  public
    constructor Create(RenderingBuffer: TAggRenderingBuffer);
  end;

  TAggAlphaMaskArgb32Gray = class(TAggAlphaMaskUnpacked8)
  public
    constructor Create(RenderingBuffer: TAggRenderingBuffer);
  end;

  TAggAlphaMaskBgra32Gray = class(TAggAlphaMaskUnpacked8)
  public
    constructor Create(RenderingBuffer: TAggRenderingBuffer);
  end;

  TAggAlphaMaskAbgr32Gray = class(TAggAlphaMaskUnpacked8)
  public
    constructor Create(RenderingBuffer: TAggRenderingBuffer);
  end;

  TAggAlphaMaskNoClipUnpack8 = class(TAggCustomAlphaMask)
  private
    Step, Offset: Cardinal;

    FRenderingBuffer: TAggRenderingBuffer;
    FMaskFunction   : TAggFuncMaskCalculate;
  public
    constructor Create(MaskF: TAggFuncMaskCalculate; AStep: Cardinal = 1;
      AOffset: Cardinal = 0); overload;
    constructor Create(RenderingBuffer: TAggRenderingBuffer; MaskF: TAggFuncMaskCalculate;
      AStep: Cardinal = 1; AOffset: Cardinal = 0); overload;

    procedure Attach(RenderingBuffer: TAggRenderingBuffer); override;

    function MaskFunction: TAggFuncMaskCalculate; override;

    function Pixel(x, y: Integer): Int8u; override;
    function CombinePixel(x, y: Integer; val: Int8u): Int8u; override;

    procedure FillHSpan(x, y: Integer; Dst: PInt8u; NumPixel: Integer); override;
    procedure CombineHSpan(x, y: Integer; Dst: PInt8u; NumPixel: Integer); override;
    procedure FillVSpan(x, y: Integer; Dst: PInt8u; NumPixel: Integer); override;
    procedure CombineVSpan(x, y: Integer; Dst: PInt8u; NumPixel: Integer); override;
  end;

  TAggAlphaMaskNoClipGray8 = class(TAggAlphaMaskNoClipUnpack8)
  public
    constructor Create(RenderingBuffer: TAggRenderingBuffer);
  end;

  TAggAlphaMaskNoClipRgb24Red = class(TAggAlphaMaskNoClipUnpack8)
  public
    constructor Create(RenderingBuffer: TAggRenderingBuffer);
  end;

  TAggAlphaMaskNoClipRgb24Green = class(TAggAlphaMaskNoClipUnpack8)
  public
    constructor Create(RenderingBuffer: TAggRenderingBuffer);
  end;

  TAggAlphaMaskNoClipRgb24Blue = class(TAggAlphaMaskNoClipUnpack8)
  public
    constructor Create(RenderingBuffer: TAggRenderingBuffer);
  end;

  TAggAlphaMaskNoClipBgr24Red = class(TAggAlphaMaskNoClipUnpack8)
  public
    constructor Create(RenderingBuffer: TAggRenderingBuffer);
  end;

  TAggAlphaMaskNoClipBgr24Green = class(TAggAlphaMaskNoClipUnpack8)
  public
    constructor Create(RenderingBuffer: TAggRenderingBuffer);
  end;

  TAggAlphaMaskNoClipBgr24Blue = class(TAggAlphaMaskNoClipUnpack8)
  public
    constructor Create(RenderingBuffer: TAggRenderingBuffer);
  end;

  TAggAlphaMaskNoClipRgba32Red = class(TAggAlphaMaskNoClipUnpack8)
  public
    constructor Create(RenderingBuffer: TAggRenderingBuffer);
  end;

  TAggAlphaMaskNoClipRgba32Green = class(TAggAlphaMaskNoClipUnpack8)
  public
    constructor Create(RenderingBuffer: TAggRenderingBuffer);
  end;

  TAggAlphaMaskNoClipRgba32Blue = class(TAggAlphaMaskNoClipUnpack8)
  public
    constructor Create(RenderingBuffer: TAggRenderingBuffer);
  end;

  TAggAlphaMaskNoClipRgba32Alpha = class(TAggAlphaMaskNoClipUnpack8)
  public
    constructor Create(RenderingBuffer: TAggRenderingBuffer);
  end;

  TAggAlphaMaskNoClipArgb32Red = class(TAggAlphaMaskNoClipUnpack8)
  public
    constructor Create(RenderingBuffer: TAggRenderingBuffer);
  end;

  TAggAlphaMaskNoClipArgb32Green = class(TAggAlphaMaskNoClipUnpack8)
  public
    constructor Create(RenderingBuffer: TAggRenderingBuffer);
  end;

  TAggAlphaMaskNoClipArgb32Blue = class(TAggAlphaMaskNoClipUnpack8)
  public
    constructor Create(RenderingBuffer: TAggRenderingBuffer);
  end;

  TAggAlphaMaskNoClipArgb32Alpha = class(TAggAlphaMaskNoClipUnpack8)
  public
    constructor Create(RenderingBuffer: TAggRenderingBuffer);
  end;

  TAggAlphaMaskNoClipBgra32Red = class(TAggAlphaMaskNoClipUnpack8)
  public
    constructor Create(RenderingBuffer: TAggRenderingBuffer);
  end;

  TAggAlphaMaskNoClipBgra32Green = class(TAggAlphaMaskNoClipUnpack8)
  public
    constructor Create(RenderingBuffer: TAggRenderingBuffer);
  end;

  TAggAlphaMaskNoClipBgra32Blue = class(TAggAlphaMaskNoClipUnpack8)
  public
    constructor Create(RenderingBuffer: TAggRenderingBuffer);
  end;

  TAggAlphaMaskNoClipBgra32Alpha = class(TAggAlphaMaskNoClipUnpack8)
  public
    constructor Create(RenderingBuffer: TAggRenderingBuffer);
  end;

  TAggAlphaMaskNoClipAbgr32Red = class(TAggAlphaMaskNoClipUnpack8)
  public
    constructor Create(RenderingBuffer: TAggRenderingBuffer);
  end;

  TAggAlphaMaskNoClipAbgr32Green = class(TAggAlphaMaskNoClipUnpack8)
  public
    constructor Create(RenderingBuffer: TAggRenderingBuffer);
  end;

  TAggAlphaMaskNoClipAbgr32Blue = class(TAggAlphaMaskNoClipUnpack8)
  public
    constructor Create(RenderingBuffer: TAggRenderingBuffer);
  end;

  TAggAlphaMaskNoClipAbgr32Alpha = class(TAggAlphaMaskNoClipUnpack8)
  public
    constructor Create(RenderingBuffer: TAggRenderingBuffer);
  end;

  TAggAlphaMaskNoClipRgb24Gray = class(TAggAlphaMaskNoClipUnpack8)
  public
    constructor Create(RenderingBuffer: TAggRenderingBuffer);
  end;

  TAggAlphaMaskNoClipBgr24Gray = class(TAggAlphaMaskNoClipUnpack8)
  public
    constructor Create(RenderingBuffer: TAggRenderingBuffer);
  end;

  TAggAlphaMaskNoClipRgba32Gray = class(TAggAlphaMaskNoClipUnpack8)
  public
    constructor Create(RenderingBuffer: TAggRenderingBuffer);
  end;

  TAggAlphaMaskNoClipArgb32Gray = class(TAggAlphaMaskNoClipUnpack8)
  public
    constructor Create(RenderingBuffer: TAggRenderingBuffer);
  end;

  TAggAlphaMaskNoClipBgra32Gray = class(TAggAlphaMaskNoClipUnpack8)
  public
    constructor Create(RenderingBuffer: TAggRenderingBuffer);
  end;

  TAggAlphaMaskNoClipAbgr32Gray = class(TAggAlphaMaskNoClipUnpack8)
  public
    constructor Create(RenderingBuffer: TAggRenderingBuffer);
  end;

function OneComponentMaskUnpacked8(p: PInt8u): Cardinal;
function RgbToGrayMaskUnpacked8_012(p: PInt8u): Cardinal;
function RgbToGrayMaskUnpacked8_210(p: PInt8u): Cardinal;

implementation

function OneComponentMaskUnpacked8;
begin
  Result := p^;
end;

function RgbToGrayMaskUnpacked8_012;
begin
  Result := Int8u(PInt8u(p)^ * 77 +
    PInt8u(PtrComp(p) + SizeOf(Int8u))^ * 150 + PInt8u(PtrComp(p) + 2 *
    SizeOf(Int8u))^ * 29 shr 8);
end;

function RgbToGrayMaskUnpacked8_210;
begin
  Result := Int8u(PInt8u(PtrComp(p) + 2 * SizeOf(Int8u))^ * 77 +
    PInt8u(PtrComp(p) + SizeOf(Int8u))^ * 150 + PInt8u(p)^ * 29 shr 8);
end;


{ TAggAlphaMaskUnpacked8 }

constructor TAggAlphaMaskUnpacked8.Create(MaskF: TAggFuncMaskCalculate; AStep: Cardinal = 1;
  AOffset: Cardinal = 0);
begin
  Step := AStep;
  Offset := AOffset;

  FRenderingBuffer := nil;
  FMaskFunction := MaskF;
end;

constructor TAggAlphaMaskUnpacked8.Create(RenderingBuffer: TAggRenderingBuffer;
  MaskF: TAggFuncMaskCalculate; AStep: Cardinal = 1; AOffset: Cardinal = 0);
begin
  Step := AStep;
  Offset := AOffset;

  FRenderingBuffer := RenderingBuffer;
  FMaskFunction := MaskF;
end;

procedure TAggAlphaMaskUnpacked8.Attach;
begin
  FRenderingBuffer := RenderingBuffer;
end;

function TAggAlphaMaskUnpacked8.MaskFunction;
begin
  Result := @FMaskFunction;
end;

function TAggAlphaMaskUnpacked8.Pixel;
begin
  if (x >= 0) and (y >= 0) and (x < FRenderingBuffer.width) and
    (y < FRenderingBuffer.height) then
    Result := Int8u(FMaskFunction(PInt8u(PtrComp(FRenderingBuffer.Row(y)) +
      (x * Step + Offset) * SizeOf(Int8u))))
  else
    Result := 0;
end;

function TAggAlphaMaskUnpacked8.CombinePixel;
begin
  if (x >= 0) and (y >= 0) and (x < FRenderingBuffer.width) and
    (y < FRenderingBuffer.height) then
    Result := Int8u
      ((CAggCoverFull + val * FMaskFunction(PInt8u(PtrComp(FRenderingBuffer.Row(y))
      + (x * Step + Offset) * SizeOf(Int8u)))) shr CAggCoverShift)
  else
    Result := 0;
end;

procedure TAggAlphaMaskUnpacked8.FillHSpan;
var
  XMax, YMax, Count, Rest: Integer;
  Covers, Mask           : PInt8u;
begin
  XMax := FRenderingBuffer.width - 1;
  YMax := FRenderingBuffer.height - 1;

  Count := NumPixel;
  Covers := Dst;

  if (y < 0) or (y > YMax) then
  begin
    FillChar(Dst^, NumPixel * SizeOf(Int8u), 0);

    Exit;
  end;

  if x < 0 then
  begin
    inc(Count, x);

    if Count <= 0 then
    begin
      FillChar(Dst^, NumPixel * SizeOf(Int8u), 0);

      Exit;
    end;

    FillChar(Covers^, -x * SizeOf(Int8u), 0);

    dec(Covers, x);

    x := 0;
  end;

  if x + Count > XMax then
  begin
    Rest := x + Count - XMax - 1;

    dec(Count, Rest);

    if Count <= 0 then
    begin
      FillChar(Dst^, NumPixel * SizeOf(Int8u), 0);

      Exit;
    end;

    FillChar(PInt8u(PtrComp(Covers) + Count * SizeOf(Int8u))^,
      Rest * SizeOf(Int8u), 0);
  end;

  Mask := PInt8u(PtrComp(FRenderingBuffer.Row(y)) + (x * Step + Offset) *
    SizeOf(Int8u));

  repeat
    Covers^ := Int8u(FMaskFunction(Mask));

    inc(PtrComp(Covers), SizeOf(Int8u));
    inc(PtrComp(Mask), Step * SizeOf(Int8u));
    dec(Count);

  until Count = 0;
end;

procedure TAggAlphaMaskUnpacked8.CombineHSpan;
var
  XMax, YMax, Count, Rest: Integer;
  Covers, Mask           : PInt8u;
begin
  XMax := FRenderingBuffer.width - 1;
  YMax := FRenderingBuffer.height - 1;

  Count := NumPixel;
  Covers := Dst;

  if (y < 0) or (y > YMax) then
  begin
    FillChar(Dst^, NumPixel * SizeOf(Int8u), 0);
    Exit;
  end;

  if x < 0 then
  begin
    inc(Count, x);

    if Count <= 0 then
    begin
      FillChar(Dst^, NumPixel * SizeOf(Int8u), 0);
      Exit;
    end;

    FillChar(Covers^, -x * SizeOf(Int8u), 0);
    dec(PtrComp(Covers), x * SizeOf(Int8u));
    x := 0;
  end;

  if x + Count > XMax then
  begin
    Rest := x + Count - XMax - 1;
    dec(Count, Rest);

    if Count <= 0 then
    begin
      FillChar(Dst^, NumPixel * SizeOf(Int8u), 0);
      Exit;
    end;

    FillChar(PInt8u(PtrComp(Covers) + Count * SizeOf(Int8u))^,
      Rest * SizeOf(Int8u), 0);
  end;

  Mask := PInt8u(PtrComp(FRenderingBuffer.Row(y)) + (x * Step + Offset) *
    SizeOf(Int8u));

  repeat
    Covers^ := Int8u((CAggCoverFull + Covers^ * FMaskFunction(Mask))
      shr CAggCoverShift);

    inc(PtrComp(Covers), SizeOf(Int8u));
    inc(Mask, Step * SizeOf(Int8u));
    dec(Count);

  until Count = 0;
end;

procedure TAggAlphaMaskUnpacked8.FillVSpan;
var
  XMax, YMax, Count, Rest: Integer;

  Covers, Mask: PInt8u;

begin
  XMax := FRenderingBuffer.width - 1;
  YMax := FRenderingBuffer.height - 1;

  Count := NumPixel;
  Covers := Dst;

  if (x < 0) or (x > XMax) then
  begin
    FillChar(Dst^, NumPixel * SizeOf(Int8u), 0);

    Exit;
  end;

  if y < 0 then
  begin
    inc(Count, y);

    if Count <= 0 then
    begin
      FillChar(Dst^, NumPixel * SizeOf(Int8u), 0);

      Exit;
    end;

    FillChar(Covers^, -y * SizeOf(Int8u), 0);
    dec(PtrComp(Covers), y * SizeOf(Int8u));
    y := 0;
  end;

  if y + Count > YMax then
  begin
    Rest := y + Count - YMax - 1;
    dec(Count, Rest);

    if Count <= 0 then
    begin
      FillChar(Dst^, NumPixel * SizeOf(Int8u), 0);
      Exit;
    end;

    FillChar(PInt8u(PtrComp(Covers) + Count * SizeOf(Int8u))^,
      Rest * SizeOf(Int8u), 0);
  end;

  repeat
    Covers^ := Int8u(FMaskFunction(Mask));

    inc(PtrComp(Covers), SizeOf(Int8u));
    inc(PtrComp(Mask), FRenderingBuffer.stride);
    dec(Count);
  until Count = 0;
end;

procedure TAggAlphaMaskUnpacked8.CombineVSpan;
var
  XMax, YMax, Count, Rest: Integer;

  Covers, Mask: PInt8u;

begin
  XMax := FRenderingBuffer.width - 1;
  YMax := FRenderingBuffer.height - 1;

  Count := NumPixel;
  Covers := Dst;

  if (x < 0) or (x > XMax) then
  begin
    FillChar(Dst^, NumPixel * SizeOf(Int8u), 0);
    Exit;
  end;

  if y < 0 then
  begin
    inc(Count, y);

    if Count <= 0 then
    begin
      FillChar(Dst^, NumPixel * SizeOf(Int8u), 0);

      Exit;
    end;

    FillChar(Covers^, -y * SizeOf(Int8u), 0);
    dec(PtrComp(Covers), y * SizeOf(Int8u));
    y := 0;
  end;

  if y + Count > YMax then
  begin
    Rest := y + Count - YMax - 1;
    dec(Count, Rest);

    if Count <= 0 then
    begin
      FillChar(Dst^, NumPixel * SizeOf(Int8u), 0);
      Exit;
    end;

    FillChar(PInt8u(PtrComp(Covers) + Count * SizeOf(Int8u))^,
      Rest * SizeOf(Int8u), 0);
  end;

  Mask := PInt8u(PtrComp(FRenderingBuffer.Row(y)) + (x * Step + Offset) *
    SizeOf(Int8u));
  repeat
    Covers^ := Int8u((CAggCoverFull + Covers^ * FMaskFunction(Mask))
      shr CAggCoverShift);

    inc(PtrComp(Covers), SizeOf(Int8u));
    inc(PtrComp(Mask), FRenderingBuffer.stride);
    dec(Count);
  until Count = 0;
end;


{ TAggAlphaMaskGray8 }

constructor TAggAlphaMaskGray8.Create;
begin
  inherited Create(RenderingBuffer, @OneComponentMaskUnpacked8, 1, 0);
end;


{ TAggAlphaMaskRgb24Red }

constructor TAggAlphaMaskRgb24Red.Create;
begin
  inherited Create(RenderingBuffer, @OneComponentMaskUnpacked8, 3, 0);
end;


{ TAggAlphaMaskRgb24Green }

constructor TAggAlphaMaskRgb24Green.Create;
begin
  inherited Create(RenderingBuffer, @OneComponentMaskUnpacked8, 3, 1);
end;


{ TAggAlphaMaskRgb24Blue }

constructor TAggAlphaMaskRgb24Blue.Create;
begin
  inherited Create(RenderingBuffer, @OneComponentMaskUnpacked8, 3, 2);
end;


{ TAggAlphaMaskBgr24Red }

constructor TAggAlphaMaskBgr24Red.Create;
begin
  inherited Create(RenderingBuffer, @OneComponentMaskUnpacked8, 3, 2);
end;


{ TAggAlphaMaskBgr24Green }

constructor TAggAlphaMaskBgr24Green.Create;
begin
  inherited Create(RenderingBuffer, @OneComponentMaskUnpacked8, 3, 1);
end;


{ TAggAlphaMaskBgr24Blue }

constructor TAggAlphaMaskBgr24Blue.Create;
begin
  inherited Create(RenderingBuffer, @OneComponentMaskUnpacked8, 3, 0);
end;


{ TAggAlphaMaskRgba32Red }

constructor TAggAlphaMaskRgba32Red.Create;
begin
  inherited Create(RenderingBuffer, @OneComponentMaskUnpacked8, 4, 0);
end;


{ TAggAlphaMaskRgba32Green }

constructor TAggAlphaMaskRgba32Green.Create;
begin
  inherited Create(RenderingBuffer, @OneComponentMaskUnpacked8, 4, 1);
end;


{ TAggAlphaMaskRgba32Blue }

constructor TAggAlphaMaskRgba32Blue.Create;
begin
  inherited Create(RenderingBuffer, @OneComponentMaskUnpacked8, 4, 2);
end;


{ TAggAlphaMaskRgba32Alpha }

constructor TAggAlphaMaskRgba32Alpha.Create;
begin
  inherited Create(RenderingBuffer, @OneComponentMaskUnpacked8, 4, 3);
end;


{ TAggAlphaMaskArgb32Red }

constructor TAggAlphaMaskArgb32Red.Create;
begin
  inherited Create(RenderingBuffer, @OneComponentMaskUnpacked8, 4, 1);
end;


{ TAggAlphaMaskArgb32Green }

constructor TAggAlphaMaskArgb32Green.Create;
begin
  inherited Create(RenderingBuffer, @OneComponentMaskUnpacked8, 4, 2);
end;


{ TAggAlphaMaskArgb32Blue }

constructor TAggAlphaMaskArgb32Blue.Create;
begin
  inherited Create(RenderingBuffer, @OneComponentMaskUnpacked8, 4, 3);
end;


{ TAggAlphaMaskArgb32Alpha }

constructor TAggAlphaMaskArgb32Alpha.Create;
begin
  inherited Create(RenderingBuffer, @OneComponentMaskUnpacked8, 4, 0);
end;


{ TAggAlphaMaskBgra32Red }

constructor TAggAlphaMaskBgra32Red.Create;
begin
  inherited Create(RenderingBuffer, @OneComponentMaskUnpacked8, 4, 2);
end;


{ TAggAlphaMaskBgra32Green }

constructor TAggAlphaMaskBgra32Green.Create;
begin
  inherited Create(RenderingBuffer, @OneComponentMaskUnpacked8, 4, 1);
end;


{ TAggAlphaMaskBgra32Blue }

constructor TAggAlphaMaskBgra32Blue.Create;
begin
  inherited Create(RenderingBuffer, @OneComponentMaskUnpacked8, 4, 0);
end;


{ TAggAlphaMaskBgra32Alpha }

constructor TAggAlphaMaskBgra32Alpha.Create;
begin
  inherited Create(RenderingBuffer, @OneComponentMaskUnpacked8, 4, 3);
end;


{ TAggAlphaMaskAbgr32Red }

constructor TAggAlphaMaskAbgr32Red.Create;
begin
  inherited Create(RenderingBuffer, @OneComponentMaskUnpacked8, 4, 3);
end;


{ TAggAlphaMaskAbgr32Green }

constructor TAggAlphaMaskAbgr32Green.Create;
begin
  inherited Create(RenderingBuffer, @OneComponentMaskUnpacked8, 4, 2);
end;


{ TAggAlphaMaskAbgr32Blue }

constructor TAggAlphaMaskAbgr32Blue.Create;
begin
  inherited Create(RenderingBuffer, @OneComponentMaskUnpacked8, 4, 1);
end;


{ TAggAlphaMaskAbgr32Alpha }

constructor TAggAlphaMaskAbgr32Alpha.Create;
begin
  inherited Create(RenderingBuffer, @OneComponentMaskUnpacked8, 4, 0);
end;


{ TAggAlphaMaskRgb24Gray }

constructor TAggAlphaMaskRgb24Gray.Create;
begin
  inherited Create(RenderingBuffer, @RgbToGrayMaskUnpacked8_012, 3, 0);
end;


{ TAggAlphaMaskBgr24Gray }

constructor TAggAlphaMaskBgr24Gray.Create;
begin
  inherited Create(RenderingBuffer, @RgbToGrayMaskUnpacked8_210, 3, 0);
end;


{ TAggAlphaMaskRgba32Gray }

constructor TAggAlphaMaskRgba32Gray.Create;
begin
  inherited Create(RenderingBuffer, @RgbToGrayMaskUnpacked8_012, 4, 0);
end;


{ TAggAlphaMaskArgb32Gray }

constructor TAggAlphaMaskArgb32Gray.Create;
begin
  inherited Create(RenderingBuffer, @RgbToGrayMaskUnpacked8_012, 4, 1);
end;


{ TAggAlphaMaskBgra32Gray }

constructor TAggAlphaMaskBgra32Gray.Create;
begin
  inherited Create(RenderingBuffer, @RgbToGrayMaskUnpacked8_210, 4, 0);
end;


{ TAggAlphaMaskAbgr32Gray }

constructor TAggAlphaMaskAbgr32Gray.Create;
begin
  inherited Create(RenderingBuffer, @RgbToGrayMaskUnpacked8_210, 4, 1);
end;


{ TAggAlphaMaskNoClipUnpack8 }

constructor TAggAlphaMaskNoClipUnpack8.Create(MaskF: TAggFuncMaskCalculate;
  AStep: Cardinal = 1; AOffset: Cardinal = 0);
begin
  Step := AStep;
  Offset := AOffset;

  FRenderingBuffer := nil;
  FMaskFunction := MaskF;
end;

constructor TAggAlphaMaskNoClipUnpack8.Create(RenderingBuffer: TAggRenderingBuffer;
  MaskF: TAggFuncMaskCalculate; AStep: Cardinal = 1; AOffset: Cardinal = 0);
begin
  Step := AStep;
  Offset := AOffset;

  FRenderingBuffer := RenderingBuffer;
  FMaskFunction := MaskF;
end;

procedure TAggAlphaMaskNoClipUnpack8.Attach;
begin
  FRenderingBuffer := RenderingBuffer;
end;

function TAggAlphaMaskNoClipUnpack8.MaskFunction;
begin
  Result := @FMaskFunction;
end;

function TAggAlphaMaskNoClipUnpack8.Pixel;
begin
  Result := Int8u(FMaskFunction(PInt8u(PtrComp(FRenderingBuffer.Row(y)) +
    (x * Step + Offset) * SizeOf(Int8u))));
end;

function TAggAlphaMaskNoClipUnpack8.CombinePixel;
begin
  Result := Int8u((CAggCoverFull + val *
    FMaskFunction(PInt8u(PtrComp(FRenderingBuffer.Row(y)) + (x * Step + Offset)
    * SizeOf(Int8u)))) shr CAggCoverShift);
end;

procedure TAggAlphaMaskNoClipUnpack8.FillHSpan;
var
  Mask: PInt8u;
begin
  Mask := PInt8u(PtrComp(FRenderingBuffer.Row(y)) + (x * Step + Offset) *
    SizeOf(Int8u));

  repeat
    Dst^ := Int8u(FMaskFunction(Mask));

    inc(PtrComp(Dst), SizeOf(Int8u));
    inc(PtrComp(Mask), Step * SizeOf(Int8u));
    dec(NumPixel);

  until NumPixel = 0;
end;

procedure TAggAlphaMaskNoClipUnpack8.CombineHSpan;
var
  Mask: PInt8u;
begin
  Mask := PInt8u(PtrComp(FRenderingBuffer.Row(y)) + (x * Step + Offset) *
    SizeOf(Int8u));

  repeat
    Dst^ := Int8u((CAggCoverFull + Dst^ * FMaskFunction(Mask)) shr CAggCoverShift);

    inc(PtrComp(Dst), SizeOf(Int8u));
    inc(PtrComp(Mask), Step * SizeOf(Int8u));
    dec(NumPixel);

  until NumPixel = 0;
end;

procedure TAggAlphaMaskNoClipUnpack8.FillVSpan;
var
  Mask: PInt8u;
begin
  Mask := PInt8u(PtrComp(FRenderingBuffer.Row(y)) + (x * Step + Offset) *
    SizeOf(Int8u));

  repeat
    Dst^ := Int8u(FMaskFunction(Mask));

    inc(PtrComp(Dst), SizeOf(Int8u));
    inc(PtrComp(Mask), FRenderingBuffer.stride);
    dec(NumPixel);

  until NumPixel = 0;
end;

procedure TAggAlphaMaskNoClipUnpack8.CombineVSpan;
var
  Mask: PInt8u;
begin
  Mask := PInt8u(PtrComp(FRenderingBuffer.Row(y)) + (x * Step + Offset) *
    SizeOf(Int8u));

  repeat
    Dst^ := Int8u((CAggCoverFull + Dst^ * FMaskFunction(Mask)) shr CAggCoverShift);

    inc(PtrComp(Dst), SizeOf(Int8u));
    inc(PtrComp(Mask), FRenderingBuffer.stride);
    dec(NumPixel);

  until NumPixel = 0;
end;


{ TAggAlphaMaskNoClipGray8 }

constructor TAggAlphaMaskNoClipGray8.Create;
begin
  inherited Create(RenderingBuffer, @OneComponentMaskUnpacked8, 1, 0);
end;


{ TAggAlphaMaskNoClipRgb24Red }

constructor TAggAlphaMaskNoClipRgb24Red.Create;
begin
  inherited Create(RenderingBuffer, @OneComponentMaskUnpacked8, 3, 0);
end;


{ TAggAlphaMaskNoClipRgb24Green }

constructor TAggAlphaMaskNoClipRgb24Green.Create;
begin
  inherited Create(RenderingBuffer, @OneComponentMaskUnpacked8, 3, 1);
end;


{ TAggAlphaMaskNoClipRgb24Blue }

constructor TAggAlphaMaskNoClipRgb24Blue.Create;
begin
  inherited Create(RenderingBuffer, @OneComponentMaskUnpacked8, 3, 2);
end;


{ TAggAlphaMaskNoClipBgr24Red }

constructor TAggAlphaMaskNoClipBgr24Red.Create;
begin
  inherited Create(RenderingBuffer, @OneComponentMaskUnpacked8, 3, 2);
end;


{ TAggAlphaMaskNoClipBgr24Green }

constructor TAggAlphaMaskNoClipBgr24Green.Create;
begin
  inherited Create(RenderingBuffer, @OneComponentMaskUnpacked8, 3, 1);
end;


{ TAggAlphaMaskNoClipBgr24Blue }

constructor TAggAlphaMaskNoClipBgr24Blue.Create;
begin
  inherited Create(RenderingBuffer, @OneComponentMaskUnpacked8, 3, 0);
end;


{ TAggAlphaMaskNoClipRgba32Red }

constructor TAggAlphaMaskNoClipRgba32Red.Create;
begin
  inherited Create(RenderingBuffer, @OneComponentMaskUnpacked8, 4, 0);
end;


{ TAggAlphaMaskNoClipRgba32Green }

constructor TAggAlphaMaskNoClipRgba32Green.Create;
begin
  inherited Create(RenderingBuffer, @OneComponentMaskUnpacked8, 4, 1);
end;


{ TAggAlphaMaskNoClipRgba32Blue }

constructor TAggAlphaMaskNoClipRgba32Blue.Create;
begin
  inherited Create(RenderingBuffer, @OneComponentMaskUnpacked8, 4, 2);
end;


{ TAggAlphaMaskNoClipRgba32Alpha }

constructor TAggAlphaMaskNoClipRgba32Alpha.Create;
begin
  inherited Create(RenderingBuffer, @OneComponentMaskUnpacked8, 4, 3);
end;


{ TAggAlphaMaskNoClipArgb32Red }

constructor TAggAlphaMaskNoClipArgb32Red.Create;
begin
  inherited Create(RenderingBuffer, @OneComponentMaskUnpacked8, 4, 1);
end;


{ TAggAlphaMaskNoClipArgb32Green }

constructor TAggAlphaMaskNoClipArgb32Green.Create;
begin
  inherited Create(RenderingBuffer, @OneComponentMaskUnpacked8, 4, 2);
end;


{ TAggAlphaMaskNoClipArgb32Blue }

constructor TAggAlphaMaskNoClipArgb32Blue.Create;
begin
  inherited Create(RenderingBuffer, @OneComponentMaskUnpacked8, 4, 3);
end;


{ TAggAlphaMaskNoClipArgb32Alpha }

constructor TAggAlphaMaskNoClipArgb32Alpha.Create;
begin
  inherited Create(RenderingBuffer, @OneComponentMaskUnpacked8, 4, 0);
end;


{ TAggAlphaMaskNoClipBgra32Red }

constructor TAggAlphaMaskNoClipBgra32Red.Create;
begin
  inherited Create(RenderingBuffer, @OneComponentMaskUnpacked8, 4, 2);
end;


{ TAggAlphaMaskNoClipBgra32Green }

constructor TAggAlphaMaskNoClipBgra32Green.Create;
begin
  inherited Create(RenderingBuffer, @OneComponentMaskUnpacked8, 4, 1);
end;


{ TAggAlphaMaskNoClipBgra32Blue }

constructor TAggAlphaMaskNoClipBgra32Blue.Create;
begin
  inherited Create(RenderingBuffer, @OneComponentMaskUnpacked8, 4, 0);
end;


{ TAggAlphaMaskNoClipBgra32Alpha }

constructor TAggAlphaMaskNoClipBgra32Alpha.Create;
begin
  inherited Create(RenderingBuffer, @OneComponentMaskUnpacked8, 4, 3);
end;


{ TAggAlphaMaskNoClipAbgr32Red }

constructor TAggAlphaMaskNoClipAbgr32Red.Create;
begin
  inherited Create(RenderingBuffer, @OneComponentMaskUnpacked8, 4, 3);
end;


{ TAggAlphaMaskNoClipAbgr32Green }

constructor TAggAlphaMaskNoClipAbgr32Green.Create;
begin
  inherited Create(RenderingBuffer, @OneComponentMaskUnpacked8, 4, 2);
end;


{ TAggAlphaMaskNoClipAbgr32Blue }

constructor TAggAlphaMaskNoClipAbgr32Blue.Create;
begin
  inherited Create(RenderingBuffer, @OneComponentMaskUnpacked8, 4, 1);
end;


{ TAggAlphaMaskNoClipAbgr32Alpha }

constructor TAggAlphaMaskNoClipAbgr32Alpha.Create;
begin
  inherited Create(RenderingBuffer, @OneComponentMaskUnpacked8, 4, 0);
end;


{ TAggAlphaMaskNoClipRgb24Gray }

constructor TAggAlphaMaskNoClipRgb24Gray.Create;
begin
  inherited Create(RenderingBuffer, @RgbToGrayMaskUnpacked8_012, 3, 0);
end;


{ TAggAlphaMaskNoClipBgr24Gray }

constructor TAggAlphaMaskNoClipBgr24Gray.Create;
begin
  inherited Create(RenderingBuffer, @RgbToGrayMaskUnpacked8_210, 3, 0);
end;


{ TAggAlphaMaskNoClipRgba32Gray }

constructor TAggAlphaMaskNoClipRgba32Gray.Create;
begin
  inherited Create(RenderingBuffer, @RgbToGrayMaskUnpacked8_012, 4, 0);
end;


{ TAggAlphaMaskNoClipArgb32Gray }

constructor TAggAlphaMaskNoClipArgb32Gray.Create;
begin
  inherited Create(RenderingBuffer, @RgbToGrayMaskUnpacked8_012, 4, 1);
end;


{ TAggAlphaMaskNoClipBgra32Gray }

constructor TAggAlphaMaskNoClipBgra32Gray.Create;
begin
  inherited Create(RenderingBuffer, @RgbToGrayMaskUnpacked8_210, 4, 0);
end;


{ TAggAlphaMaskNoClipAbgr32Gray }

constructor TAggAlphaMaskNoClipAbgr32Gray.Create;
begin
  inherited Create(RenderingBuffer, @RgbToGrayMaskUnpacked8_210, 4, 1);
end;

end.
