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
{ * memory Rasterization AGG support                                           * }
{ ****************************************************************************** }


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
unit PasAI.Agg.SpanPatternRgba;

{$DEFINE FPC_DELPHI_MODE}
{$I PasAI.Define.inc}
interface
uses
  PasAI.Agg.Basics,
  PasAI.Agg.Color32,
  PasAI.Agg.PixelFormat,
  PasAI.Agg.PixelFormatRgba,
  PasAI.Agg.SpanPattern,
  PasAI.Agg.SpanAllocator,
  PasAI.Agg.RenderingBuffer;

const
  CAggBaseShift = PasAI.Agg.Color32.CAggBaseShift;
  CAggBaseMask  = PasAI.Agg.Color32.CAggBaseMask;

type
  TAggSpanPatternRgba = class(TAggSpanPatternBase)
  private
    FWrapModeX, FWrapModeY: TAggWrapMode;
    FOrder: TAggOrder;
  protected
    procedure SetSourceImage(Src: TAggRenderingBuffer); override;
  public
    constructor Create(Alloc: TAggSpanAllocator; Wx, Wy: TAggWrapMode; Order: TAggOrder); overload;
    constructor Create(Alloc: TAggSpanAllocator; Src: TAggRenderingBuffer; OffsetX, OffsetY: Cardinal; Wx, Wy: TAggWrapMode; Order: TAggOrder); overload;

    function Generate(x, y: Integer; Len: Cardinal): PAggColor; override;
  end;

implementation


{ TAggSpanPatternRgba }

constructor TAggSpanPatternRgba.Create(Alloc: TAggSpanAllocator;
  Wx, Wy: TAggWrapMode; Order: TAggOrder);
begin
  inherited Create(Alloc);

  FOrder := Order;

  FWrapModeX := Wx;
  FWrapModeY := Wy;

  FWrapModeX.Init(1);
  FWrapModeY.Init(1);
end;

constructor TAggSpanPatternRgba.Create(Alloc: TAggSpanAllocator;
  Src: TAggRenderingBuffer; OffsetX, OffsetY: Cardinal;
  Wx, Wy: TAggWrapMode; Order: TAggOrder);
begin
  inherited Create(Alloc, Src, OffsetX, OffsetY, 0);

  FOrder := Order;

  FWrapModeX := Wx;
  FWrapModeY := Wy;

  FWrapModeX.Init(Src.width);
  FWrapModeY.Init(Src.height);
end;

procedure TAggSpanPatternRgba.SetSourceImage(Src: TAggRenderingBuffer);
begin
  inherited SetSourceImage(Src);

  FWrapModeX.Init(Src.width);
  FWrapModeY.Init(Src.height);
end;

function TAggSpanPatternRgba.Generate(x, y: Integer; Len: Cardinal): PAggColor;
var
  Span: PAggColor;
  RowPointer, p: PInt8u;
  SX: Cardinal;
begin
  Span := Allocator.Span;
  SX := FWrapModeX.FuncOperator(OffsetX + x);

  RowPointer := SourceImage.Row(FWrapModeY.FuncOperator(OffsetY + y));

  repeat
    p := PInt8u(PtrComp(RowPointer) + (SX shl 2) * SizeOf(Int8u));

    Span.Rgba8.r := PInt8u(PtrComp(p) + FOrder.r * SizeOf(Int8u))^;
    Span.Rgba8.g := PInt8u(PtrComp(p) + FOrder.g * SizeOf(Int8u))^;
    Span.Rgba8.b := PInt8u(PtrComp(p) + FOrder.b * SizeOf(Int8u))^;
    Span.Rgba8.a := PInt8u(PtrComp(p) + FOrder.a * SizeOf(Int8u))^;

    SX := FWrapModeX.IncOperator;

    inc(PtrComp(Span), SizeOf(TAggColor));
    dec(Len);
  until Len = 0;

  Result := Allocator.Span;
end;

end.
