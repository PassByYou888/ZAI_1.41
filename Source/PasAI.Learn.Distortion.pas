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
{ * distortion/undistortion solve                                              * }
{ ****************************************************************************** }
unit PasAI.Learn.Distortion;

{$DEFINE FPC_DELPHI_MODE}
{$I PasAI.Define.inc}

interface

uses PasAI.Core,
  PasAI.Status, PasAI.PascalStrings, PasAI.UPascalStrings, PasAI.UnicodeMixedLib, PasAI.Geometry2D, PasAI.Geometry3D,
  PasAI.DFE, PasAI.MemoryRaster, PasAI.Learn, PasAI.Learn.Type_LIB;

// build ones sample picture for Undistortion Calibrate
function BuildDistortionCalibratePicture(const width, height, metric: TLInt): TMPasAI_Raster;
// Least squares fitting by polynomial: model training for undistortion
function BuildDistortionModel_Polynomial(DistortionCoord: TArrayVec2; degree: TLInt; var model: TBarycentricInterpolant): Boolean; overload;
function BuildDistortionModel_Polynomial(DistortionCoord: TArrayVec2; degree: TLInt): TLVec; overload;
// Least squares fitting by polynomial: process for undistortion
function ProcessDistortionRaster_Polynomial(model: TBarycentricInterpolant; axis: TVec2; raster: TMPasAI_Raster; fast: Boolean): TMPasAI_Raster; overload;
function ProcessDistortionRaster_Polynomial(model: TBarycentricInterpolant; axis: TVec2; raster: TMPasAI_Raster): TMPasAI_Raster; overload;
function ProcessDistortionRaster_Polynomial(model: TLVec; axis: TVec2; raster: TMPasAI_Raster; fast: Boolean): TMPasAI_Raster; overload;
function ProcessDistortionRaster_Polynomial(model: TLVec; axis: TVec2; raster: TMPasAI_Raster): TMPasAI_Raster; overload;
// Least squares fitting by polynomial: end-to-end process for undistortion
function ProcessDistortionRaster_Polynomial(DistortionCoord: TArrayVec2; degree: TLInt; raster: TMPasAI_Raster; fast: Boolean): TMPasAI_Raster; overload;
function ProcessDistortionRaster_Polynomial(DistortionCoord: TArrayVec2; degree: TLInt; raster: TMPasAI_Raster): TMPasAI_Raster; overload;

implementation


function BuildDistortionCalibratePicture(const width, height, metric: TLInt): TMPasAI_Raster;
var
  metric_, i: TLInt;
  f, minSiz: TGeoFloat;
  PT: TVec2;
  textsiz: TVec2;
begin
  Result := NewPasAI_Raster();
  Result.SetSize(umlMax(1024, width), umlMax(1024, height));
  metric_ := umlMax(40, metric);
  FillBlackGrayBackgroundTexture(Result, metric_ shr 1, RColorF(1.0, 1.0, 1.0), RColorF(0.98, 0.98, 0.98), RColorF(0.95, 0.95, 0.95));

  Result.OpenAgg;

  PT := Vec2(10, 10);
  textsiz := Result.TextSize(PFormat('Sample size(%d * %d) metric: %d', [Result.width, Result.height, metric_]), 20);
  Result.DrawText(PFormat('Sample size(%d * %d) metric: %d', [Result.width, Result.height, metric_]), round(PT[0]), round(PT[1]), 20, RColorF(0.0, 0.0, 0.0, 0.9));

  Result.Agg.LineWidth := 2.0;
  PT := Vec2(10, PT[1] + textsiz[1]);
  i := 1;
  PT := Vec2(10, PT[1] + 10);
  textsiz := Result.TextSize(PFormat('metric * %d.00', [i, metric_ * i]), 24);
  Result.DrawText(PFormat('metric * %d.00', [i, metric_ * i]), round(PT[0]), round(PT[1]), 24, RColorF(0.0, 0.0, 0.0, 0.9));
  PT := Vec2(10, PT[1] + textsiz[1]);
  Result.LineF(PT, Vec2Add(PT, Vec2(metric_ * i, 0)), RColorF(0.1, 0.1, 0.1, 0.9), True, 10, True);
  for i := 1 to 4 do
    begin
      PT := Vec2(10, PT[1] + 10);
      textsiz := Result.TextSize(PFormat('metric * %f', [pow(2, i), metric_ * pow(2, i)]), 24);
      Result.DrawText(PFormat('metric * %f', [pow(2, i), metric_ * pow(2, i)]), round(PT[0]), round(PT[1]), 24, RColorF(0.0, 0.0, 0.0, 0.9));
      PT := Vec2(10, PT[1] + textsiz[1]);
      Result.LineF(PT, Vec2Add(PT, Vec2(metric_ * pow(2, i), 0)), RColorF(0.1, 0.1, 0.1, 0.9), True, 10, True);
    end;

  minSiz := umlMin(Result.width, Result.height);
  for i := 1 to Trunc(minSiz / metric_ * 0.5) do
    begin
      f := 1.0 - (i / (Trunc(minSiz / metric_)));
      Result.Agg.LineWidth := 4.0 * f;
      Result.DrawCircle(Result.Centroid, i * metric_, RColorF(1 - f, 1 - f, 1 - f, f));

      Result.Agg.LineWidth := 2.0 * f;

      PT := Vec2Add(Result.Centroid, Vec2(i * metric_, 0));
      Result.DrawCrossF(PT, metric_ * 0.2, RColorF(1 - f, 1 - f, 1 - f, f));
      Result.DrawText(PFormat('%d', [i]), round(PT[0]), round(PT[1]), Vec2(0.5, 0.5), -45, 1.0, 12, RColorF(0.5, 0.5, 0.5));

      PT := Vec2Sub(Result.Centroid, Vec2(i * metric_, 0));
      Result.DrawCrossF(PT, metric_ * 0.2, RColorF(1 - f, 1 - f, 1 - f, f));
      Result.DrawText(PFormat('%d', [i]), round(PT[0]), round(PT[1]), Vec2(0.5, 0.5), -45, 1.0, 12, RColorF(0.5, 0.5, 0.5));

      PT := Vec2Add(Result.Centroid, Vec2(0, i * metric_));
      Result.DrawCrossF(PT, metric_ * 0.2, RColorF(1 - f, 1 - f, 1 - f, f));
      Result.DrawText(PFormat('%d', [i]), round(PT[0]), round(PT[1]), Vec2(0.5, 0.5), -45, 1.0, 12, RColorF(0.5, 0.5, 0.5));

      PT := Vec2Sub(Result.Centroid, Vec2(0, i * metric_));
      Result.DrawCrossF(PT, metric_ * 0.2, RColorF(1 - f, 1 - f, 1 - f, f));
      Result.DrawText(PFormat('%d', [i]), round(PT[0]), round(PT[1]), Vec2(0.5, 0.5), -45, 1.0, 12, RColorF(0.5, 0.5, 0.5));

      Result.DrawCircle(Vec2LerpTo(Result.Centroid, Vec2(0, 0), i * metric_), metric_ * 0.1, RColorF(1 - f, 1 - f, 1 - f, f));
      Result.DrawCircle(Vec2LerpTo(Result.Centroid, Vec2(Result.Width0, 0), i * metric_), metric_ * 0.1, RColorF(1 - f, 1 - f, 1 - f, f));
      Result.DrawCircle(Vec2LerpTo(Result.Centroid, Vec2(0, Result.Height0), i * metric_), metric_ * 0.1, RColorF(1 - f, 1 - f, 1 - f, f));
      Result.DrawCircle(Vec2LerpTo(Result.Centroid, Vec2(Result.Width0, Result.Height0), i * metric_), metric_ * 0.1, RColorF(1 - f, 1 - f, 1 - f, f));
    end;
  i := 0;
  f := 1.0;
  Result.Agg.LineWidth := 5.0;
  PT := Result.Centroid;
  Result.DrawCrossF(PT, metric_ * 0.2, RColorF(0, 0, 0, 1.0));
  Result.DrawText(PFormat('%d', [i]), round(PT[0]), round(PT[1]), Vec2(0.5, 0.5), -45, 1.0, 12, RColorF(0.0, 0.0, 0.0));

  Result.CloseAgg;
  Result.CloseVertex;
  Result.CloseFont;
end;

function BuildDistortionModel_Polynomial(DistortionCoord: TArrayVec2; degree: TLInt; var model: TBarycentricInterpolant): Boolean;
var
  L: TV2L;
  d: TGeoFloat;
  i: TLInt;
  formulaVec: TLVec;
  distortionVec: TLVec;
  N, M: TLInt;
  Info: TLInt;
  Rep: TPolynomialFitReport;
begin
  Result := False;
  L := TV2L.Create;
  L.AssignFromArrayV2(DistortionCoord);

  // formula distortion
  d := Vec2Distance(L[0]^, L[1]^);
  N := L.Count;
  M := degree;
  formulaVec := LVec(N, 0);
  distortionVec := LVec(N, 0);
  for i := 1 to L.Count - 1 do
    begin
      formulaVec[i] := i * d;
      distortionVec[i] := Vec2Distance(L[i]^, L[0]^);
    end;

  // Least squares fitting by polynomial
  PolynomialFit(formulaVec, distortionVec, N, M, Info, model, Rep);
  if Info > 0 then
    begin
      Result := True;
      DoStatus('polynomial fitting solved.');
    end
  else
    begin
      DoStatusNoLn;
      DoStatusNoLn('polynomial an error occured: ');
      case Info of
        - 4: DoStatusNoLn('means inconvergence of internal SVD');
        -3: DoStatusNoLn('means inconsistent constraints');
        -1: DoStatusNoLn('means another errors in parameters passed (N<=0, for example)');
      end;
      DoStatusNoLn;
    end;

  disposeObject(L);
end;

function BuildDistortionModel_Polynomial(DistortionCoord: TArrayVec2; degree: TLInt): TLVec;
var
  model: TBarycentricInterpolant;
  RL: TLInt;
begin
  if BuildDistortionModel_Polynomial(DistortionCoord, degree, model) then
      BarycentricSerialize(model, Result, RL)
  else
      Result := LVec(0);
end;

function ProcessDistortionRaster_Polynomial(model: TBarycentricInterpolant; axis: TVec2; raster: TMPasAI_Raster; fast: Boolean): TMPasAI_Raster;
var
  nRaster: TMPasAI_Raster;
{$IFDEF Parallel}
{$IFDEF FPC}
  procedure Nested_ParallelFor(pass: TLInt);
  var
    i: TLInt;
    f: TLFloat;
    d, dx, dy: TGeoFloat;
  begin
    for i := 0 to nRaster.width - 1 do
      begin
        d := Vec2Distance(Vec2(i, pass), axis);
        dx := axis[0];
        dy := axis[1];
        if d <> 0 then
          begin
            f := BarycentricCalc(model, d) / d;
            dx := dx + (i - axis[0]) * f;
            dy := dy + (pass - axis[1]) * f;
          end;
        if fast then
            nRaster.FastPixel[i, pass] := raster.Pixel[round(dx), round(dy)]
        else
            nRaster.FastPixel[i, pass] := raster.PixelLinear[round(dx), round(dy)];
      end;
  end;
{$ENDIF FPC}
{$ELSE Parallel}
  procedure DoFor;
  var
    pass: TLInt;
    i: TLInt;
    f: TLFloat;
    d, dx, dy: TGeoFloat;
  begin
    for pass := 0 to nRaster.height - 1 do
      begin
        for i := 0 to nRaster.width - 1 do
          begin
            d := Vec2Distance(Vec2(i, pass), axis);
            dx := axis[0];
            dy := axis[1];
            if d > 0 then
              begin
                f := BarycentricCalc(model, d) / d;
                dx := dx + (i - axis[0]) * f;
                dy := dy + (pass - axis[1]) * f;
              end;
            if fast then
                nRaster.FastPixel[i, pass] := raster.Pixel[round(dx), round(dy)]
            else
                nRaster.FastPixel[i, pass] := raster.PixelLinear[round(dx), round(dy)];
          end;
      end;
  end;
{$ENDIF Parallel}


begin
  nRaster := NewPasAI_Raster();
  nRaster.SetSize(raster.width, raster.height);

{$IFDEF Parallel}
{$IFDEF FPC}
  FPCParallelFor(Nested_ParallelFor, 0, nRaster.height - 1);
{$ELSE FPC}
  DelphiParallelFor(0, nRaster.height - 1, procedure(pass: TLInt)
    var
      i: TLInt;
      f: TLFloat;
      d, dx, dy: TGeoFloat;
    begin
      for i := 0 to nRaster.width - 1 do
        begin
          d := Vec2Distance(Vec2(i, pass), axis);
          dx := axis[0];
          dy := axis[1];
          if d <> 0 then
            begin
              f := BarycentricCalc(model, d) / d;
              dx := dx + (i - axis[0]) * f;
              dy := dy + (pass - axis[1]) * f;
            end;
          if fast then
              nRaster.FastPixel[i, pass] := raster.Pixel[round(dx), round(dy)]
          else
              nRaster.FastPixel[i, pass] := raster.PixelLinear[round(dx), round(dy)];
        end;
    end);
{$ENDIF FPC}
{$ELSE Parallel}
  DoFor;
{$ENDIF Parallel}
  Result := nRaster;
end;

function ProcessDistortionRaster_Polynomial(model: TBarycentricInterpolant; axis: TVec2; raster: TMPasAI_Raster): TMPasAI_Raster;
begin
  Result := ProcessDistortionRaster_Polynomial(model, axis, raster, False);
end;

function ProcessDistortionRaster_Polynomial(model: TLVec; axis: TVec2; raster: TMPasAI_Raster; fast: Boolean): TMPasAI_Raster;
var
  p: TBarycentricInterpolant;
begin
  Result := nil;
  if length(model) = 0 then
      exit;
  BarycentricUnserialize(model, p);
  Result := ProcessDistortionRaster_Polynomial(p, axis, raster, False);
end;

function ProcessDistortionRaster_Polynomial(model: TLVec; axis: TVec2; raster: TMPasAI_Raster): TMPasAI_Raster;
var
  p: TBarycentricInterpolant;
begin
  Result := nil;
  if length(model) = 0 then
      exit;
  BarycentricUnserialize(model, p);
  Result := ProcessDistortionRaster_Polynomial(p, axis, raster);
end;

function ProcessDistortionRaster_Polynomial(DistortionCoord: TArrayVec2; degree: TLInt; raster: TMPasAI_Raster; fast: Boolean): TMPasAI_Raster;
var
  model: TBarycentricInterpolant;
begin
  Result := nil;
  if BuildDistortionModel_Polynomial(DistortionCoord, degree, model) then
      Result := ProcessDistortionRaster_Polynomial(model, DistortionCoord[0], raster, False);
end;

function ProcessDistortionRaster_Polynomial(DistortionCoord: TArrayVec2; degree: TLInt; raster: TMPasAI_Raster): TMPasAI_Raster;
var
  model: TBarycentricInterpolant;
begin
  Result := nil;
  if BuildDistortionModel_Polynomial(DistortionCoord, degree, model) then
      Result := ProcessDistortionRaster_Polynomial(model, DistortionCoord[0], raster);
end;

end.
