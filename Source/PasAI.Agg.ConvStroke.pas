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
unit PasAI.Agg.ConvStroke;

{$DEFINE FPC_DELPHI_MODE}
{$I PasAI.Define.inc}
interface
uses
  PasAI.Agg.Basics,
  PasAI.Agg.VertexSource,
  PasAI.Agg.VcgenStroke,
  PasAI.Agg.ConvAdaptorVcgen;

type
  TAggConvStroke = class(TAggConvAdaptorVcgen)
  private
    FGenerator: TAggVcgenStroke;

    procedure SetLineCap(Value: TAggLineCap);
    procedure SetLineJoin(Value: TAggLineJoin);
    procedure SetInnerJoin(Value: TAggInnerJoin);

    function GetLineCap: TAggLineCap;
    function GetLineJoin: TAggLineJoin;
    function GetInnerJoin: TAggInnerJoin;

    procedure SetWidth(Value: Double);
    procedure SetMiterLimit(Value: Double);
    procedure SetMiterLimitTheta(Value: Double);
    procedure SetInnerMiterLimit(Value: Double);
    procedure SetApproximationScale(Value: Double);

    function GetWidth: Double;
    function GetMiterLimit: Double;
    function GetInnerMiterLimit: Double;
    function GetApproximationScale: Double;

    procedure SetShorten(Value: Double);
    function GetShorten: Double;
  public
    constructor Create(VertexSource: TAggCustomVertexSource);
    destructor Destroy; override;

    property LineCap: TAggLineCap read GetLineCap write SetLineCap;
    property LineJoin: TAggLineJoin read GetLineJoin write SetLineJoin;
    property InnerJoin: TAggInnerJoin read GetInnerJoin write SetInnerJoin;

    property width: Double read GetWidth write SetWidth;
    property MiterLimit: Double read GetMiterLimit write SetMiterLimit;
    property InnerMiterLimit: Double read GetInnerMiterLimit write SetInnerMiterLimit;
    property ApproximationScale: Double read GetApproximationScale write SetApproximationScale;

    property Shorten: Double read GetShorten write SetShorten;
  end;

  TAggConvStrokeMath = class(TAggConvAdaptorVcgen)
  private
    FGenerator: TAggVcgenStrokeMath;

    procedure SetLineCap(Value: TAggLineCap);
    procedure SetLineJoin(Value: TAggLineJoin);
    procedure SetInnerJoin(Value: TAggInnerJoin);

    function GetLineCap: TAggLineCap;
    function GetLineJoin: TAggLineJoin;
    function GetInnerJoin: TAggInnerJoin;

    procedure SetWidth(Value: Double);
    procedure SetMiterLimit(Value: Double);
    procedure SetMiterLimitTheta(Value: Double);
    procedure SetInnerMiterLimit(Value: Double);
    procedure SetApproximationScale(Value: Double);

    function GetWidth: Double;
    function GetMiterLimit: Double;
    function GetInnerMiterLimit: Double;
    function GetApproximationScale: Double;

    procedure SetShorten(Value: Double);
    function GetShorten: Double;
  public
    constructor Create(VertexSource: TAggCustomVertexSource);
    destructor Destroy; override;

    property LineCap: TAggLineCap read GetLineCap write SetLineCap;
    property LineJoin: TAggLineJoin read GetLineJoin write SetLineJoin;
    property InnerJoin: TAggInnerJoin read GetInnerJoin write SetInnerJoin;

    property width: Double read GetWidth write SetWidth;
    property MiterLimit: Double read GetMiterLimit write SetMiterLimit;
    property InnerMiterLimit: Double read GetInnerMiterLimit write SetInnerMiterLimit;
    property ApproximationScale: Double read GetApproximationScale write SetApproximationScale;

    property Shorten: Double read GetShorten write SetShorten;
  end;

implementation


{ TAggConvStroke }

constructor TAggConvStroke.Create(VertexSource: TAggCustomVertexSource);
begin
  FGenerator := TAggVcgenStroke.Create;

  inherited Create(VertexSource, FGenerator);
end;

destructor TAggConvStroke.Destroy;
begin
  FGenerator.Free;

  inherited;
end;

procedure TAggConvStroke.SetLineCap(Value: TAggLineCap);
begin
  TAggVcgenStroke(Generator).LineCap := Value;
end;

procedure TAggConvStroke.SetLineJoin(Value: TAggLineJoin);
begin
  TAggVcgenStroke(Generator).LineJoin := Value;
end;

procedure TAggConvStroke.SetInnerJoin(Value: TAggInnerJoin);
begin
  TAggVcgenStroke(Generator).InnerJoin := Value;
end;

function TAggConvStroke.GetLineCap: TAggLineCap;
begin
  Result := TAggVcgenStroke(Generator).LineCap;
end;

function TAggConvStroke.GetLineJoin: TAggLineJoin;
begin
  Result := TAggVcgenStroke(Generator).LineJoin;
end;

function TAggConvStroke.GetInnerJoin: TAggInnerJoin;
begin
  Result := TAggVcgenStroke(Generator).InnerJoin;
end;

procedure TAggConvStroke.SetWidth(Value: Double);
begin
  TAggVcgenStroke(Generator).width := Value;
end;

procedure TAggConvStroke.SetMiterLimit(Value: Double);
begin
  TAggVcgenStroke(Generator).MiterLimit := Value;
end;

procedure TAggConvStroke.SetMiterLimitTheta(Value: Double);
begin
  TAggVcgenStroke(Generator).SetMiterLimitTheta(Value);
end;

procedure TAggConvStroke.SetInnerMiterLimit(Value: Double);
begin
  TAggVcgenStroke(Generator).InnerMiterLimit := Value;
end;

procedure TAggConvStroke.SetApproximationScale(Value: Double);
begin
  TAggVcgenStroke(Generator).ApproximationScale := Value;
end;

function TAggConvStroke.GetWidth: Double;
begin
  Result := TAggVcgenStroke(Generator).width;
end;

function TAggConvStroke.GetMiterLimit: Double;
begin
  Result := TAggVcgenStroke(Generator).MiterLimit;
end;

function TAggConvStroke.GetInnerMiterLimit: Double;
begin
  Result := TAggVcgenStroke(Generator).InnerMiterLimit;
end;

function TAggConvStroke.GetApproximationScale: Double;
begin
  Result := TAggVcgenStroke(Generator).ApproximationScale;
end;

procedure TAggConvStroke.SetShorten(Value: Double);
begin
  TAggVcgenStroke(Generator).Shorten := Value;
end;

function TAggConvStroke.GetShorten: Double;
begin
  Result := TAggVcgenStroke(Generator).Shorten;
end;

{ TAggConvStrokeMath }

constructor TAggConvStrokeMath.Create(VertexSource: TAggCustomVertexSource);
begin
  FGenerator := TAggVcgenStrokeMath.Create;

  inherited Create(VertexSource, FGenerator);
end;

destructor TAggConvStrokeMath.Destroy;
begin
  FGenerator.Free;

  inherited;
end;

procedure TAggConvStrokeMath.SetLineCap(Value: TAggLineCap);
begin
  TAggVcgenStrokeMath(Generator).LineCap := Value;
end;

procedure TAggConvStrokeMath.SetLineJoin(Value: TAggLineJoin);
begin
  TAggVcgenStrokeMath(Generator).LineJoin := Value;
end;

procedure TAggConvStrokeMath.SetInnerJoin(Value: TAggInnerJoin);
begin
  TAggVcgenStrokeMath(Generator).InnerJoin := Value;
end;

function TAggConvStrokeMath.GetLineCap: TAggLineCap;
begin
  Result := TAggVcgenStrokeMath(Generator).LineCap;
end;

function TAggConvStrokeMath.GetLineJoin: TAggLineJoin;
begin
  Result := TAggVcgenStrokeMath(Generator).LineJoin;
end;

function TAggConvStrokeMath.GetInnerJoin: TAggInnerJoin;
begin
  Result := TAggVcgenStrokeMath(Generator).InnerJoin;
end;

procedure TAggConvStrokeMath.SetWidth(Value: Double);
begin
  TAggVcgenStrokeMath(Generator).width := Value;
end;

procedure TAggConvStrokeMath.SetMiterLimit(Value: Double);
begin
  TAggVcgenStrokeMath(Generator).MiterLimit := Value;
end;

procedure TAggConvStrokeMath.SetMiterLimitTheta(Value: Double);
begin
  TAggVcgenStrokeMath(Generator).SetMiterLimitTheta(Value);
end;

procedure TAggConvStrokeMath.SetInnerMiterLimit(Value: Double);
begin
  TAggVcgenStrokeMath(Generator).InnerMiterLimit := Value;
end;

procedure TAggConvStrokeMath.SetApproximationScale(Value: Double);
begin
  TAggVcgenStrokeMath(Generator).ApproximationScale := Value;
end;

function TAggConvStrokeMath.GetWidth: Double;
begin
  Result := TAggVcgenStrokeMath(Generator).width;
end;

function TAggConvStrokeMath.GetMiterLimit: Double;
begin
  Result := TAggVcgenStrokeMath(Generator).MiterLimit;
end;

function TAggConvStrokeMath.GetInnerMiterLimit: Double;
begin
  Result := TAggVcgenStrokeMath(Generator).InnerMiterLimit;
end;

function TAggConvStrokeMath.GetApproximationScale: Double;
begin
  Result := TAggVcgenStrokeMath(Generator).ApproximationScale;
end;

procedure TAggConvStrokeMath.SetShorten(Value: Double);
begin
  TAggVcgenStrokeMath(Generator).Shorten := Value;
end;

function TAggConvStrokeMath.GetShorten: Double;
begin
  Result := TAggVcgenStrokeMath(Generator).Shorten;
end;

end.
