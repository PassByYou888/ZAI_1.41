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
unit PasAI.Agg.Spiral;

{$DEFINE FPC_DELPHI_MODE}
{$I PasAI.Define.inc}
interface
uses
  SysUtils,
  PasAI.Agg.Math,
  PasAI.Agg.Basics,
  PasAI.Agg.VertexSource;

type
  TSpiral = class(TAggVertexSource)
  private
    fx, fy, FR1, FR2, FStep, FStartAngle, FAngle: Double;
    FCurrentRadius, FDa, FDr: Double;
    FStart: Boolean;
  public
    constructor Create(x, y, r1, r2, Step: Double; startAngle: Double = 0);

    procedure Rewind(PathID: Cardinal); override;
    function Vertex(x, y: PDouble): Cardinal; override;
  end;

implementation

{ TSpiral }

constructor TSpiral.Create(x, y, r1, r2, Step: Double; startAngle: Double = 0);
begin
  fx := x;
  fy := y;
  FR1 := r1;
  FR2 := r2;

  FStep := Step;
  FStartAngle := startAngle;
  FAngle := startAngle;

  FDa := Deg2Rad(4.0);
  FDr := FStep / 90.0;
end;

procedure TSpiral.Rewind(PathID: Cardinal);
begin
  FAngle := FStartAngle;
  FCurrentRadius := FR1;
  FStart := True;
end;

function TSpiral.Vertex(x, y: PDouble): Cardinal;
var
  Pnt: TPointDouble;
begin
  if FCurrentRadius > FR2 then
    begin
      Result := CAggPathCmdStop;

      Exit;
    end;

  SinCosScale(FAngle, Pnt.y, Pnt.x, FCurrentRadius);

  x^ := fx + Pnt.x;
  y^ := fy + Pnt.y;

  FCurrentRadius := FCurrentRadius + FDr;
  FAngle := FAngle + FDa;

  if FStart then
    begin
      FStart := False;

      Result := CAggPathCmdMoveTo;
    end
  else
      Result := CAggPathCmdLineTo;
end;

end.
