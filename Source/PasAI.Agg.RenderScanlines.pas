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
unit PasAI.Agg.RenderScanlines;

{$DEFINE FPC_DELPHI_MODE}
{$I PasAI.Define.inc}
interface
uses
  PasAI.Agg.Basics,
  PasAI.Agg.Color32,
  PasAI.Agg.RasterizerScanLine,
  PasAI.Agg.Scanline,
  PasAI.Agg.RendererScanLine,
  PasAI.Agg.VertexSource;

procedure RenderScanLines(Ras: TAggRasterizerScanLine; SL: TAggCustomScanLine; Ren: TAggCustomRendererScanLine);
procedure RenderAllPaths(Ras: TAggRasterizerScanLine; SL: TAggCustomScanLine; r: TAggCustomRendererScanLineSolid; Vs: TAggVertexSource; cs: PAggColor; PathID: PCardinal; PathCount: Cardinal);

implementation

procedure RenderScanLines(Ras: TAggRasterizerScanLine; SL: TAggCustomScanLine;
  Ren: TAggCustomRendererScanLine);
var
  SlEm: TAggEmbeddedScanLine;
begin
  if Ras.RewindScanLines then
    begin
      SL.Reset(Ras.MinimumX, Ras.MaximumX);
      Ren.Prepare(Cardinal(Ras.MaximumX - Ras.MinimumX + 2));

      { if Sl.IsEmbedded then
        while Ras.SweepScanLineEm(Sl) do
        Ren.Render(Sl)
        else }
      if SL is TAggEmbeddedScanLine then
        begin
          SlEm := SL as TAggEmbeddedScanLine;
          while Ras.SweepScanLine(SlEm) do
              Ren.Render(SlEm)
        end
      else
        while Ras.SweepScanLine(SL) do
            Ren.Render(SL);
    end;
end;

procedure RenderAllPaths(Ras: TAggRasterizerScanLine; SL: TAggCustomScanLine;
  r: TAggCustomRendererScanLineSolid; Vs: TAggVertexSource; cs: PAggColor;
  PathID: PCardinal; PathCount: Cardinal);
var
  i: Cardinal;
begin
  i := 0;

  while i < PathCount do
    begin
      Ras.Reset;
      Ras.AddPath(Vs, PathID^);
      r.SetColor(cs);

      RenderScanLines(Ras, SL, r);

      inc(PtrComp(cs), SizeOf(TAggColor));
      inc(PtrComp(PathID), SizeOf(Cardinal));
      inc(i);
    end;
end;

end.
