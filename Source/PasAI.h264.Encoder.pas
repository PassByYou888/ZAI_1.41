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
unit PasAI.h264.Encoder;

{$DEFINE FPC_DELPHI_MODE}
{$I PasAI.Define.inc}

interface

uses
  SysUtils, PasAI.h264.Types, PasAI.h264.Common, PasAI.h264.Util, PasAI.h264.Parameters, PasAI.h264.Frame, PasAI.h264.stream, PasAI.h264.Stats, PasAI.h264.Loopfilter,
  PasAI.h264.Intra_pred, PasAI.h264.Motion_comp, PasAI.h264.Motion_est, PasAI.h264.RateControl, PasAI.h264.Image_LIB, PasAI.h264.MB_encoder, PasAI.Core;

type
  TFevh264Encoder = class(TCore_Object_Intermediate)
  private
    h264s: TH264Stream;
    mb_enc: TMacroblockEncoder;
    fenc: TFrame; // currently encoded frame
    Stats: TStreamStats;
    frame_num: int32_t;

    width, height: int32_t;
    key_interval: int32_t; // IDR interval
    last_keyframe_num: int32_t;
    num_ref_frames: int32_t;
    mb_width, mb_height, mb_count: int32_t;

    // encoder configuration
    FParam: TEncodingParameters;
    stats_file: textfile;

    // classes
    frames: TFrameManager;
    RC: TRatecontrol;
    mc: TMotionCompensation;
    me: TMotionEstimator;

    procedure SetISlice;
    procedure SetPSlice;
    function TryEncodeFrame(const img: TPlanarImage): Boolean;
    function SceneCut(const mbrow: int32_t): Boolean;
    procedure GetFrameSSD;
    procedure UpdateStats;
  public
    {
      Create encoder with desired parameters.
      Param_ instance is bound to encoder and shouldn't be modified until the encoder is freed
    }
    constructor Create(var Param_: TEncodingParameters);
    destructor Destroy; override;
    procedure EncodeFrame(const img: TPlanarImage; buffer: uint8_p; out stream_size: uint32_t);
    procedure GetLastFrameSSD(out ssd: array of Int64_t);
    procedure GetLastFrame(out last_frame: TFrame);
  end;

implementation


constructor TFevh264Encoder.Create(var Param_: TEncodingParameters);
begin
  inherited Create;

  FParam := Param_;

  // check&set params
  width := Param_.FrameWidth;
  height := Param_.FrameHeight;
  num_ref_frames := Param_.NumReferenceFrames;
  key_interval := Param_.KeyFrameInterval;

  frame_num := 0;
  last_keyframe_num := 0;
  mb_width := width div 16;
  mb_height := height div 16;
  if (width and $F) > 0 then
      inc(mb_width);
  if (height and $F) > 0 then
      inc(mb_height);
  mb_count := mb_width * mb_height;

  // stream settings
  h264s := TH264Stream.Create(width, height, mb_width, mb_height);
  h264s.qp := Param_.QParam;
  h264s.ChromaQPOffset := Param_.ChromaQParamOffset;
  h264s.KeyInterval := key_interval;
  h264s.NumRefFrames := num_ref_frames;
  if not Param_.LoopFilterEnabled then
      h264s.DisableLoopFilter;

  // allocate frames
  frames := TFrameManager.Create(num_ref_frames, mb_width, mb_height);

  // inter pred
  mc := TMotionCompensation.Create;
  me := TMotionEstimator.Create(width, height, mb_width, mb_height, mc, h264s.GetInterPredCostEvaluator);
  me.subme := Param_.SubpixelMELevel;

  // ratecontrol
  RC := TRatecontrol.Create;
  if Param_.ABRRateControlEnabled then
      RC.Set2pass(Param_.Bitrate, Param_.FrameCount, Param_.FrameRate)
  else
      RC.SetConstQP(Param_.QParam);

  // mb encoder
  case Param_.AnalysisLevel of
    0: mb_enc := TMBEncoderNoAnalyse.Create;
    1: mb_enc := TMBEncoderQuickAnalyse.Create;
    2: mb_enc := TMBEncoderQuickAnalyseSATD.Create;
    else mb_enc := TMBEncoderRateAnalyse.Create;
  end;
  mb_enc.num_ref_frames := num_ref_frames;
  mb_enc.chroma_coding := True;
  mb_enc.mc := mc;
  mb_enc.me := me;
  mb_enc.h264s := h264s;
  mb_enc.ChromaQPOffset := Param_.ChromaQParamOffset;
  mb_enc.chroma_coding := not Param_.IgnoreChroma;
  mb_enc.Loopfilter := Param_.LoopFilterEnabled;

  // stats
  Stats := TStreamStats.Create;
  h264s.SEIString := Param_.ToPascalString;
end;

destructor TFevh264Encoder.Destroy;
begin
  RC.Free;
  frames.Free;
  me.Free;
  mc.Free;
  h264s.Free;
  mb_enc.Free;
  Stats.Free;
  inherited Destroy;
end;

procedure TFevh264Encoder.EncodeFrame(const img: TPlanarImage; buffer: uint8_p; out stream_size: uint32_t);
begin
  frames.GetFree(fenc);
  frame_img2frame_copy(fenc, img);
  fenc.Num := frame_num;

  // set frame params
  if (frame_num = 0) or (frame_num - last_keyframe_num >= key_interval) then
      SetISlice
  else
      SetPSlice;

  // encode frame (or reencode P as I)
  if TryEncodeFrame(img) = False then
    begin
      SetISlice;
      TryEncodeFrame(img);
    end;

  // prepare reference frame for ME
  frame_paint_edges(fenc);
  if FParam.SubpixelMELevel > 0 then
      frame_hpel_interpolate(fenc);

  // convert bitstream to bytestream of NAL units
  h264s.GetSliceBitstream(buffer, stream_size);

  // stats
  RC.Update(frame_num, stream_size * 8, fenc);
  fenc.Stats.size_bytes := stream_size;
  UpdateStats;

  // advance
  frames.InsertRef(fenc);
  inc(frame_num);
end;

procedure TFevh264Encoder.SetISlice;
begin
  fenc.ftype := SLICE_I;
  last_keyframe_num := frame_num;
end;

procedure TFevh264Encoder.SetPSlice;
begin
  fenc.num_ref_frames := Min(num_ref_frames, frame_num - last_keyframe_num);
  fenc.ftype := SLICE_P;
  frames.SetRefs(fenc, frame_num, fenc.num_ref_frames);
  me.NumReferences := fenc.num_ref_frames;
end;

function TFevh264Encoder.TryEncodeFrame(const img: TPlanarImage): Boolean;
var
  x, y: int32_t;
  deblocker: IDeblocker;
  Loopfilter: Boolean;
begin
  Result := True;

  // init slice bitstream
  if img.QParam <> QPARAM_AUTO then
      fenc.qp := img.QParam
  else
      fenc.qp := RC.GetQP(frame_num, fenc.ftype);
  h264s.InitSlice(fenc.ftype, fenc.qp, fenc.num_ref_frames, fenc.bs_buf);

  // frame encoding setup
  fenc.Stats.Clear;
  mb_enc.SetFrame(fenc);
  Loopfilter := FParam.LoopFilterEnabled;
  if Loopfilter then
      deblocker := GetNewDeblocker(fenc, not(FParam.AdaptiveQuant), FParam.FilterThreadEnabled);

  // encode rows
  for y := 0 to (mb_height - 1) do
    begin
      for x := 0 to (mb_width - 1) do
          mb_enc.Encode(x, y);

      if SceneCut(y) then
        begin
          Result := False;
          h264s.AbortSlice;
          Break;
        end;

      if Loopfilter then
          deblocker.MBRowFinished;
    end;

  // finish frame processing. If we don't do any deblocking, SSD is already calculated at the last stage of macroblock encoding
  if Loopfilter then
    begin
      deblocker.FrameFinished;
      deblocker.Free;
      if Result then
          GetFrameSSD;
    end;
end;

function TFevh264Encoder.SceneCut(const mbrow: int32_t): Boolean;
begin
  Result := False;
  if (fenc.ftype = SLICE_P) and (mbrow > mb_height div 2) then
    begin
      if (2 * fenc.Stats.mb_i4_count > mb_count)
        or (4 * int32_t(fenc.Stats.mb_i16_count) > 3 * mb_count)
        or (8 * int32_t(fenc.Stats.mb_i4_count + fenc.Stats.mb_i16_count) > 7 * mb_count)
      then
          Result := True;
    end;
end;

procedure TFevh264Encoder.GetLastFrameSSD(out ssd: array of Int64_t);
begin
  case length(ssd) of
    0:;
    1 .. 2:
      ssd[0] := fenc.Stats.ssd[0];
    else
      begin
        ssd[0] := fenc.Stats.ssd[0];
        ssd[1] := fenc.Stats.ssd[1];
        ssd[2] := fenc.Stats.ssd[2];
      end;
  end;
end;

procedure TFevh264Encoder.GetLastFrame(out last_frame: TFrame);
begin
  last_frame := fenc;
end;

// update stream stats with current frame's stats
procedure TFevh264Encoder.UpdateStats;
begin
  if fenc.ftype = SLICE_I then
      inc(Stats.i_count)
  else
      inc(Stats.p_count);
  Stats.Add(fenc.Stats);
end;

procedure TFevh264Encoder.GetFrameSSD;
var
  x, y: int32_t;
  mb: PMacroblock;
begin
  for y := 0 to (mb_height - 1) do
    begin
      for x := 0 to (mb_width - 1) do
        begin
          mb := @fenc.mbs[y * mb_width + x];
          DSP.pixel_load_16x16(mb^.pixels, mb^.pfdec, fenc.stride);
          DSP.pixel_load_8x8(mb^.pixels_c[0], mb^.pfdec_c[0], fenc.stride_c);
          DSP.pixel_load_8x8(mb^.pixels_c[1], mb^.pfdec_c[1], fenc.stride_c);

          inc(fenc.Stats.ssd[0], DSP.ssd_16x16(mb^.pixels, mb^.pfenc, fenc.stride));
          inc(fenc.Stats.ssd[1], DSP.ssd_8x8(mb^.pixels_c[0], mb^.pfenc_c[0], fenc.stride_c));
          inc(fenc.Stats.ssd[2], DSP.ssd_8x8(mb^.pixels_c[1], mb^.pfenc_c[1], fenc.stride_c));
        end;
    end;
end;

(* ******************************************************************************
  ****************************************************************************** *)

initialization

intra_pred_init;
DSP := TDSP.Create;

finalization

DisposeObject(DSP);

end.
