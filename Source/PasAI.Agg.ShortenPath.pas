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
unit PasAI.Agg.ShortenPath;

{$DEFINE FPC_DELPHI_MODE}
{$I PasAI.Define.inc}
interface
uses
  PasAI.Agg.Basics,
  PasAI.Agg.VertexSequence;

procedure ShortenPath(VertexSequence: TAggVertexSequence; s: Double; closed: Cardinal = 0);

implementation

procedure ShortenPath(VertexSequence: TAggVertexSequence; s: Double;
  closed: Cardinal = 0);
var
  n: Integer;
  d, x, y: Double;
  Prev, Last: PAggVertexDistance;
begin
  if (s > 0.0) and (VertexSequence.Size > 1) then
    begin
      n := VertexSequence.Size - 2;

      while n <> 0 do
        begin
          d := PAggVertexDistance(VertexSequence[n])^.Dist;

          if d > s then
              Break;

          VertexSequence.RemoveLast;

          s := s - d;

          dec(n);
        end;

      if VertexSequence.Size < 2 then
          VertexSequence.RemoveAll

      else
        begin
          n := VertexSequence.Size - 1;

          Prev := VertexSequence[n - 1];
          Last := VertexSequence[n];

          d := (Prev.Dist - s) / Prev.Dist;

          x := Prev.Pos.x + (Last.Pos.x - Prev.Pos.x) * d;
          y := Prev.Pos.y + (Last.Pos.y - Prev.Pos.y) * d;
          Last.Pos := PointDouble(x, y);

          if not VertexSequence.FuncOperatorVertexSequence(Prev, Last) then
              VertexSequence.RemoveLast;

          VertexSequence.Close(Boolean(closed <> 0));
        end;
    end;
end;

end.
