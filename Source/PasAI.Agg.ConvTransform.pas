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
unit PasAI.Agg.ConvTransform;

{$DEFINE FPC_DELPHI_MODE}
{$I PasAI.Define.inc}
interface
uses
  PasAI.Agg.Basics,
  PasAI.Agg.TransAffine,
  PasAI.Agg.VertexSource;

type
  TAggConvTransform = class(TAggVertexSource)
  private
    FSource: TAggVertexSource;
    FTrans: TAggTransAffine;
  protected
    function GetPathID(index: Cardinal): Cardinal; override;
    function GetPathCount: Cardinal; override;
  public
    constructor Create(Source: TAggVertexSource; tr: TAggTransAffine);

    procedure Rewind(PathID: Cardinal); override;
    function Vertex(x, y: PDouble): Cardinal; override;

    property Source: TAggVertexSource read FSource write FSource;
    property Transformer: TAggTransAffine read FTrans write FTrans;
  end;

implementation


{ TAggConvTransform }

constructor TAggConvTransform.Create(Source: TAggVertexSource; tr: TAggTransAffine);
begin
  inherited Create;

  FSource := Source;
  FTrans := tr;
end;

function TAggConvTransform.GetPathCount: Cardinal;
begin
  Result := FSource.PathCount;
end;

function TAggConvTransform.GetPathID(index: Cardinal): Cardinal;
begin
  Result := FSource.PathID[index];
end;

procedure TAggConvTransform.Rewind(PathID: Cardinal);
begin
  FSource.Rewind(PathID);
end;

function TAggConvTransform.Vertex(x, y: PDouble): Cardinal;
var
  Cmd: Cardinal;
begin
  Cmd := FSource.Vertex(x, y);

  if IsVertex(Cmd) then
      FTrans.Transform(FTrans, x, y);

  Result := Cmd;
end;

end.
