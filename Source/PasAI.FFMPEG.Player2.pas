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
{ * FFMPEG Advance Player V2.0                                                 * }
{ ****************************************************************************** }
unit PasAI.FFMPEG.Player2;

{$DEFINE FPC_DELPHI_MODE}
{$I PasAI.Define.inc}

interface

uses Math,
{$IFDEF FPC}
  PasAI.FPC.GenericList,
{$ENDIF FPC}
  PasAI.Core, PasAI.PascalStrings, PasAI.UPascalStrings, PasAI.UnicodeMixedLib,
  PasAI.MemoryStream, PasAI.MemoryRaster,
  PasAI.Geometry2D,
  PasAI.Status,
  PasAI.FFMPEG, PasAI.Sound.Bass.API;

type
  TFFMPEG_Player_Extract_Tool = class;

  TCodec_Stream_ = record
    CodecContext: PAVCodecContext;
    Codec: PAVCodec;
    StreamIndex: integer;
    Stream: PAVStream;
    SWS_CTX: PSwsContext;
    FrameRGB: PAVFrame;
    FrameRGB_buffer: PByte;
    SWR_CTX: PSwrContext;
    Frame: PAVFrame;
    TB: Double;
    procedure Init;
    procedure Free;
    function IsVideo: Boolean;
    function IsAudio: Boolean;
  end;

  PCodec_Stream_ = ^TCodec_Stream_;
  TCodec_Stream_Pool_Decl = TGenericsList<PCodec_Stream_>;

  TCodec_Stream_Pool = class(TCodec_Stream_Pool_Decl)
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clean;
    procedure BuildCodec(FFormatCtx: PAVFormatContext);
  end;

  TFFMPEG_Player_Video_Transform = class(TCore_Object_Intermediate)
  public
    Trigger: TFFMPEG_Player_Extract_Tool;
    Width, Height: integer;
    Ready: Boolean;
    constructor Create(Trigger_: TFFMPEG_Player_Extract_Tool; Width_, Height_: TGeoFloat);
    destructor Destroy; override;
    procedure Transform(Input: PCodec_Stream_; Output_: TPasAI_Raster; CopyFrame_: Boolean);
  end;

  TFFMPEG_Audio_Transform = class;
  TBASS_Frag_Order_Decl = TOrderStruct<TMem64>;

  TBASS_Frag_Order = class(TBASS_Frag_Order_Decl)
  public
    procedure DoFree(var Data: TMem64); override;
  end;

  TBASS_Proc_Data = record
    Owner: TFFMPEG_Audio_Transform;
    BASS_FRAG_Order: TBASS_Frag_Order;
    Critical: TCritical;
  end;

  PBASS_Proc_Data = ^TBASS_Proc_Data;

  TFFMPEG_Audio_Transform = class(TCore_Object_Intermediate)
  private
    FBuff: TMem64;
    FBassData: TBASS_Proc_Data;
    FBASS_STREAM: HSTREAM;
  public
    Trigger: TFFMPEG_Player_Extract_Tool;
    Ready: Boolean;
    constructor Create(Trigger_: TFFMPEG_Player_Extract_Tool);
    destructor Destroy; override;
    property Buff: TMem64 read FBuff;
    procedure TransformTo(Input: PCodec_Stream_; Output_: TMem64);
    function FlushFrame(Input: PCodec_Stream_): integer; overload;
    procedure Flush(p: PByte; siz: integer); overload;
    procedure Flush(Mem_: TMem64); overload;
    procedure Clear;
    function Prepare: Boolean;
    function Play(restart_: Boolean): Boolean;
    procedure Stop;
    function isStop: Boolean;
    function isPrepare: Boolean;
    function isPlaying: Boolean;
    function isWaiting: Boolean;
  end;

  TRaster_Frag = record
    PTS: Double;
    VideoData: TMPasAI_Raster;
  end;

  TRaster_Frag_Order_Decl = TOrderStruct<TRaster_Frag>;

  TRaster_Frag_Order = class(TRaster_Frag_Order_Decl)
  public
    procedure DoFree(var Data: TRaster_Frag); override;
  end;

  TAudio_Frag = record
    PTS: Double;
    AudioData: TMem64;
  end;

  TAudio_Frag_Order_Decl = TOrderStruct<TAudio_Frag>;

  TAudio_Frag_Order = class(TAudio_Frag_Order_Decl)
  public
    procedure DoFree(var Data: TAudio_Frag); override;
  end;

  TFFMPEG_Player_Sync_Tool = class(TCore_Object_Intermediate)
  protected
    FAudioDelay: Double;
    FSyncAccuracy: Double;
    FVideoTrans: TFFMPEG_Player_Video_Transform;
    FAudioTrans: TFFMPEG_Audio_Transform;
    FRealTimeMode: Boolean;
    FCalibration: Boolean;
    FCalibration_Video_PTS, FCalibration_Audio_PTS: Double;
    FCalibration_Time: TTimeTick;
    FVideo_Codec_Stream, FAudio_Codec_Stream: PCodec_Stream_;
    FSerialized_Tool: TPasAI_RasterSerialized;
    FAuto_Write_Serialized: Boolean;
    procedure SetRealTimeMode(const Value: Boolean);
    procedure Set_Serialized_Tool(const Value: TPasAI_RasterSerialized);
    procedure Set_Auto_Write_Serialized(const Value: Boolean);
  public
    Player: TFFMPEG_Player_Extract_Tool;
    Raster_Frag_Order: TRaster_Frag_Order;
    Audio_Frag_Order: TAudio_Frag_Order;
    Last_Process_Is_Video, Last_Process_Is_Audio: Boolean;
    Process_Video_Num, Process_Audio_Num: Int64;
    constructor Create(Player_: TFFMPEG_Player_Extract_Tool; Width_, Height_: TGeoFloat);
    destructor Destroy; override;
    procedure Process(Input: PCodec_Stream_); overload;
    procedure Set_Codec_Stream(Codec_Stream_: PCodec_Stream_);
    procedure Sync(); overload;
    procedure Sync(AudioDelay_, Accuracy_: Double); overload;
    function Update(raster: TPasAI_Raster): Boolean;
    property RealTimeMode: Boolean read FRealTimeMode write SetRealTimeMode;
    property VideoTrans: TFFMPEG_Player_Video_Transform read FVideoTrans;
    property AudioTrans: TFFMPEG_Audio_Transform read FAudioTrans;
    // rasterization Serialized_Tool.
    property Serialized: TPasAI_RasterSerialized read FSerialized_Tool write Set_Serialized_Tool;
    property Serialized_Tool: TPasAI_RasterSerialized read FSerialized_Tool write Set_Serialized_Tool;
    property Auto_Write_Serialized: Boolean read FAuto_Write_Serialized write Set_Auto_Write_Serialized;
  end;

  TDecode_State = (dsVideo, dsAudio, dsIgnore, dsError);
  TOn_Frame = procedure(Sender: TFFMPEG_Player_Extract_Tool; Codec_Stream_: PCodec_Stream_) of object;
  TVideoStream_Size_Pool = TBigList<TRectV2>;

  TFFMPEG_Player_Extract_Tool = class(TCore_Object_Intermediate)
  private
    FURL: TPascalString;
    FFormatCtx: PAVFormatContext;
    FPacket: PAVPacket;
    FCodec_Stream_Pool: TCodec_Stream_Pool;
  public
    Current_Video, Current_Audio: PCodec_Stream_;
    // state
    Current_VideoStream_Time: Double;
    Current_AudioStream_Time: Double;
    Current_Video_Frame: Int64;
    Current_Audio_Frame: Int64;
    Current_Video_Packet_Num: Int64;
    Current_Audio_Packet_Num: Int64;
    Width, Height: integer;
    Ready: Boolean;
    // param
    Enabled_Video, Enabled_Audio: Boolean;
    OnVideo, OnAudio: TOn_Frame;
    property URL: TPascalString read FURL;

    constructor Create(URL_: TPascalString); overload;
    constructor Create(URL_: TPascalString; RTSP_Used_TCP_: Boolean); overload;
    destructor Destroy; override;
    function OpenURL(URL_: TPascalString; RTSP_Used_TCP_: Boolean): Boolean;
    function ReadAndDecodeFrame(): TDecode_State;
    procedure Close;
    function Get_VideoStream_Fit(Width_, Height_: TGeoFloat): TVideoStream_Size_Pool;

    // video info
    function VideoTotal: Double;
    function CurrentVideoStream_Total_Frame: Int64;
    function CurrentVideoStream_PerSecond_Frame(): Double;
    function CurrentVideoStream_PerSecond_FrameRound(): integer;
    property VideoPSF: Double read CurrentVideoStream_PerSecond_Frame;

    // Audio info
    function AudioTotal: Double;
    function CurrentAudioStream_Total_Frame: Int64;
    function CurrentAudioStream_PerSecond_Frame(): Double;
    function CurrentAudioStream_PerSecond_FrameRound(): integer;
    property AudioPSF: Double read CurrentAudioStream_PerSecond_Frame;
  end;

function DO_BASS_STREAMPROC(Handle: HSTREAM; Buff: Pointer; siz_: DWord; User_: Pointer): DWord; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};

implementation

function DO_BASS_STREAMPROC(Handle: HSTREAM; Buff: Pointer; siz_: DWord; User_: Pointer): DWord; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};
var
  BASS_Data_: PBASS_Proc_Data;
  p: PByte;
  L: DWord;
  m64, tmp: TMem64;
begin
  Result := 0;
  BASS_Data_ := User_;
  p := Buff;
  L := siz_;
  BASS_Data_^.Critical.Lock;
  while BASS_Data_^.BASS_FRAG_Order.Num > 0 do
    begin
      m64 := BASS_Data_^.BASS_FRAG_Order.Current^.Data;
      if m64.Size > L then // little fragment
        begin
          CopyPtr(m64.Memory, p, L);
          inc(p, L);
          inc(Result, L);
          tmp := TMem64.Create;
          tmp.WritePtr(m64.PosAsPtr(L), m64.Size - L);
          tmp.SwapInstance(m64);
          DisposeObject(tmp);
          L := 0;
          break;
        end
      else if m64.Size > 0 then // full fragment
        begin
          CopyPtr(m64.Memory, p, m64.Size);
          inc(p, m64.Size);
          inc(Result, m64.Size);
          dec(L, m64.Size);
          BASS_Data_^.BASS_FRAG_Order.Next;
        end
      else
          BASS_Data_^.BASS_FRAG_Order.Next; // ignore
    end;
  BASS_Data_^.Critical.UnLock;
end;

procedure TCodec_Stream_.Init;
begin
  CodecContext := nil;
  Codec := nil;
  StreamIndex := -1;
  Stream := nil;
  FrameRGB := nil;
  FrameRGB_buffer := nil;
  SWS_CTX := nil;
  SWR_CTX := nil;
  Frame := nil;
  TB := 0;
end;

procedure TCodec_Stream_.Free;
begin
  if CodecContext <> nil then
      avcodec_close(CodecContext);
  if FrameRGB_buffer <> nil then
      av_free(FrameRGB_buffer);
  if FrameRGB <> nil then
      av_free(FrameRGB);
  if SWS_CTX <> nil then
      sws_freeContext(SWS_CTX);
  if SWR_CTX <> nil then
      swr_free(@SWR_CTX);
  if Frame <> nil then
      av_free(Frame);

  CodecContext := nil;
  Codec := nil;
  StreamIndex := -1;
  Stream := nil;
  FrameRGB := nil;
  FrameRGB_buffer := nil;
  SWS_CTX := nil;
  SWR_CTX := nil;
  Frame := nil;
end;

function TCodec_Stream_.IsVideo: Boolean;
begin
  Result := CodecContext^.codec_type = TAVMediaType.AVMEDIA_TYPE_VIDEO;
end;

function TCodec_Stream_.IsAudio: Boolean;
begin
  Result := CodecContext^.codec_type = TAVMediaType.AVMEDIA_TYPE_AUDIO;
end;

constructor TCodec_Stream_Pool.Create;
begin
  inherited Create;
end;

destructor TCodec_Stream_Pool.Destroy;
begin
  Clean;
  inherited Destroy;
end;

procedure TCodec_Stream_Pool.Clean;
var
  i: integer;
begin
  for i := 0 to Count - 1 do
      Items[i]^.Free;
  inherited Clear;
end;

procedure TCodec_Stream_Pool.BuildCodec(FFormatCtx: PAVFormatContext);
var
  i: integer;
  av_st: PPAVStream;
  p: PCodec_Stream_;
  error_: Boolean;
begin
  av_st := FFormatCtx^.streams;
  for i := 0 to FFormatCtx^.nb_streams - 1 do
    begin
      if av_st^^.Codec^.codec_type in [AVMEDIA_TYPE_VIDEO, AVMEDIA_TYPE_AUDIO] then
        begin
          new(p);
          p^.Init;
          p^.StreamIndex := av_st^^.index;
          p^.CodecContext := av_st^^.Codec;
          p^.Stream := av_st^;
          p^.Codec := avcodec_find_decoder(p^.CodecContext^.codec_id);
          error_ := False;
          if p^.Codec <> nil then
            begin
              if avcodec_open2(p^.CodecContext, p^.Codec, nil) < 0 then
                begin
                  DoStatus('Could not open Codec.');
                  error_ := True;
                end;
            end
          else
            begin
              DoStatus('no found Codec.');
              error_ := True;
            end;

          if not error_ then
            begin
              p^.Frame := av_frame_alloc();
              with p^.Stream^.time_base do
                  p^.TB := Num / den;
              Add(p);
            end;
        end;
      inc(av_st);
    end;
end;

constructor TFFMPEG_Player_Video_Transform.Create(Trigger_: TFFMPEG_Player_Extract_Tool; Width_, Height_: TGeoFloat);
var
  i: integer;
  p: PCodec_Stream_;
  R: TRectV2;
begin
  inherited Create;
  Trigger := Trigger_;
  Ready := False;

  if Trigger.Enabled_Video then
    for i := 0 to Trigger.FCodec_Stream_Pool.Count - 1 do
      begin
        p := Trigger.FCodec_Stream_Pool[i];
        if p^.IsVideo then
          begin
            Ready := True;
            if (p^.FrameRGB = nil) and (p^.FrameRGB_buffer = nil) and (p^.SWS_CTX = nil) then
              begin
                if Width_ <= 0 then
                    Width_ := p^.CodecContext^.Width;
                if Height_ <= 0 then
                    Height_ := p^.CodecContext^.Height;

                R := FitRect(p^.CodecContext^.Width, p^.CodecContext^.Height, RectV2(0, 0, Width_, Height_));
                Width := Round(RectWidth(R));
                Height := Round(RectHeight(R));

                p^.FrameRGB := av_frame_alloc();
                p^.FrameRGB_buffer := av_malloc(avpicture_get_size(AV_PIX_FMT_BGRA, Width, Height) * sizeof(Cardinal));
                p^.SWS_CTX := sws_getContext(
                  p^.CodecContext^.Width,
                  p^.CodecContext^.Height,
                  p^.CodecContext^.pix_fmt,
                  Width,
                  Height,
                  AV_PIX_FMT_BGRA,
                  SWS_BILINEAR,
                  nil,
                  nil,
                  nil);
                avpicture_fill(PAVPicture(p^.FrameRGB), p^.FrameRGB_buffer, AV_PIX_FMT_BGRA, Width, Height);
              end;
          end;
      end;
end;

destructor TFFMPEG_Player_Video_Transform.Destroy;
begin
  inherited Destroy;
end;

procedure TFFMPEG_Player_Video_Transform.Transform(Input: PCodec_Stream_; Output_: TPasAI_Raster; CopyFrame_: Boolean);
begin
  if not Ready then
      exit;
  sws_scale(
    Input^.SWS_CTX,
    @Input^.Frame^.Data,
    @Input^.Frame^.linesize,
    0,
    Input^.CodecContext^.Height,
    @Input^.FrameRGB^.Data,
    @Input^.FrameRGB^.linesize);
  if CopyFrame_ then
    begin
      Output_.SetSize(Width, Height);
      CopyPtr(Input^.FrameRGB^.Data[0], Output_.DirectBits, Width * Height * 4);
    end
  else
      Output_.SetWorkMemory(Input^.FrameRGB^.Data[0], Width, Height);
end;

procedure TBASS_Frag_Order.DoFree(var Data: TMem64);
begin
  DisposeObjectAndNil(Data);
end;

constructor TFFMPEG_Audio_Transform.Create(Trigger_: TFFMPEG_Player_Extract_Tool);
var
  i: integer;
  p: PCodec_Stream_;
  R_: integer;
begin
  inherited Create;
  Trigger := Trigger_;
  Ready := False;
  for i := 0 to Trigger.FCodec_Stream_Pool.Count - 1 do
    begin
      p := Trigger.FCodec_Stream_Pool[i];
      if p^.IsAudio then
        begin
          Ready := Trigger.Enabled_Audio;
          if Ready and (p^.SWR_CTX = nil) then
            begin
              p^.SWR_CTX := swr_alloc();
              p^.SWR_CTX := swr_alloc_set_opts(
                p^.SWR_CTX,
                av_get_default_channel_layout(2),
                AV_SAMPLE_FMT_FLT,
                44100,
                av_get_default_channel_layout(p^.CodecContext^.channels),
                p^.CodecContext^.sample_fmt,
                p^.CodecContext^.sample_rate,
                0,
                nil);
              R_ := swr_init(p^.SWR_CTX);
              if R_ < 0 then
                  DoStatus('swr_init: %s', [av_err2str(R_)]);
            end;
        end;
    end;

  FBuff := TMem64.Create;
  FBuff.Size := 44100 * 4 * 2;
  FBassData.Owner := self;
  FBassData.BASS_FRAG_Order := TBASS_Frag_Order.Create;
  FBassData.Critical := TCritical.Create;
  FBASS_STREAM := 0;
  if Trigger.Enabled_Audio then
    begin
      if Bass_Available then
        begin
          if not BASS_Init(-1, 44100, 0, {$IFDEF MSWINDOWS}0{$ELSE}nil{$ENDIF}, nil) then
            begin
              if BASS_ErrorGetCode() = BASS_ERROR_ALREADY then
                  DoStatus('Z.Sound.Bass.API Reinit')
              else
                  DoStatus('Z.Sound.Bass.API init failed (%d)', [BASS_ErrorGetCode]);
            end
          else
            begin
{$IFDEF DEBUG}
              DoStatus('Z.Sound.Bass.API Inited (%d)', [BASS_ErrorGetCode]);
{$ENDIF DEBUG}
            end;
        end
      else
          DoStatus('Z.Sound.Bass.API driver failed.');
    end;
end;

destructor TFFMPEG_Audio_Transform.Destroy;
begin
  if Trigger.Enabled_Audio and Bass_Available then
    if FBASS_STREAM > 0 then
      begin
        if BASS_ChannelStop(FBASS_STREAM) then
          begin
{$IFDEF DEBUG}
            DoStatus('Z.Sound.Bass.API Stop.');
{$ENDIF DEBUG}
          end;
        BASS_StreamFree(FBASS_STREAM);
        FBASS_STREAM := 0;
      end;

  DisposeObjectAndNil(FBuff);
  DisposeObjectAndNil(FBassData.BASS_FRAG_Order);
  DisposeObjectAndNil(FBassData.Critical);
  inherited Destroy;
end;

procedure TFFMPEG_Audio_Transform.TransformTo(Input: PCodec_Stream_; Output_: TMem64);
var
  p: PByte;
begin
  if (Input^.SWR_CTX = nil) or (not Ready) then
      exit;
  p := FBuff.Memory;
  Output_.Size := 4 * 2 * swr_convert(Input^.SWR_CTX, @p, FBuff.Size, @Input^.Frame^.Data, Input^.Frame^.nb_samples);
  CopyPtr(FBuff.Memory, Output_.Memory, Output_.Size);
end;

function TFFMPEG_Audio_Transform.FlushFrame(Input: PCodec_Stream_): integer;
var
  p: PByte;
begin
  Result := 0;
  if (Input^.SWR_CTX = nil) or (not Ready) then
      exit;
  p := FBuff.Memory;
  Result := 4 * 2 * swr_convert(Input^.SWR_CTX, @p, FBuff.Size, @Input^.Frame^.Data, Input^.Frame^.nb_samples);
  Flush(FBuff.Memory, Result);
end;

procedure TFFMPEG_Audio_Transform.Flush(p: PByte; siz: integer);
var
  Mem_: TMem64;
begin
  if not Ready then
      exit;
  Mem_ := TMem64.Create;
  Mem_.WritePtr(p, siz);
  Mem_.Position := 0;
  FBassData.Critical.Lock;
  FBassData.BASS_FRAG_Order.Push(Mem_);
  FBassData.Critical.UnLock;
end;

procedure TFFMPEG_Audio_Transform.Flush(Mem_: TMem64);
var
  tmp: TMem64;
begin
  if not Ready then
      exit;
  tmp := TMem64.Create;
  tmp.SwapInstance(Mem_);
  FBassData.Critical.Lock;
  FBassData.BASS_FRAG_Order.Push(tmp);
  FBassData.Critical.UnLock;
end;

procedure TFFMPEG_Audio_Transform.Clear;
begin
  if not Ready then
      exit;
  FBassData.Critical.Lock;
  FBassData.BASS_FRAG_Order.Clear;
  FBassData.Critical.UnLock;
end;

function TFFMPEG_Audio_Transform.Prepare: Boolean;
begin
  Result := False;
  if not Ready then
      exit;
  if not Bass_Available then
      exit;
  if FBASS_STREAM > 0 then
      exit;

  FBASS_STREAM := BASS_StreamCreate(44100, 2, BASS_SAMPLE_FLOAT, DO_BASS_STREAMPROC, @FBassData);
  Result := FBASS_STREAM > 0;
end;

function TFFMPEG_Audio_Transform.Play(restart_: Boolean): Boolean;
begin
  Result := False;
  if not Ready then
      exit;
  if not Bass_Available then
      exit;
  if (FBASS_STREAM > 0) and (BASS_ChannelIsActive(FBASS_STREAM) = BASS_ACTIVE_STOPPED) then
    begin
      Result := BASS_ChannelPlay(FBASS_STREAM, restart_);
    end;
end;

procedure TFFMPEG_Audio_Transform.Stop;
begin
  if not Ready then
      exit;
  if not Bass_Available then
      exit;
  if (FBASS_STREAM > 0) then
      BASS_ChannelStop(FBASS_STREAM);
  Clear;
end;

function TFFMPEG_Audio_Transform.isStop: Boolean;
begin
  Result := True;
  if not Ready then
      exit;
  if not Bass_Available then
      exit;
  Result := (FBASS_STREAM > 0) and (BASS_ChannelIsActive(FBASS_STREAM) in [BASS_ACTIVE_STOPPED]);
end;

function TFFMPEG_Audio_Transform.isPrepare: Boolean;
begin
  Result := False;
  if not Ready then
      exit;
  if not Bass_Available then
      exit;
  Result := FBASS_STREAM > 0;
end;

function TFFMPEG_Audio_Transform.isPlaying: Boolean;
begin
  Result := False;
  if not Ready then
      exit;
  if not Bass_Available then
      exit;
  Result := (FBASS_STREAM > 0) and (BASS_ChannelIsActive(FBASS_STREAM) in [BASS_ACTIVE_PLAYING, BASS_ACTIVE_STALLED]);
end;

function TFFMPEG_Audio_Transform.isWaiting: Boolean;
begin
  Result := False;
  if not Ready then
      exit;
  if not Bass_Available then
      exit;
  Result := (FBASS_STREAM > 0) and (BASS_ChannelIsActive(FBASS_STREAM) = BASS_ACTIVE_STALLED);
end;

procedure TRaster_Frag_Order.DoFree(var Data: TRaster_Frag);
begin
  DisposeObjectAndNil(Data.VideoData);
end;

procedure TAudio_Frag_Order.DoFree(var Data: TAudio_Frag);
begin
  DisposeObjectAndNil(Data.AudioData);
end;

procedure TFFMPEG_Player_Sync_Tool.SetRealTimeMode(const Value: Boolean);
begin
  FRealTimeMode := Value;
  FAudioTrans.Stop;
  if FRealTimeMode then
    begin
      Raster_Frag_Order.Clear;
      Audio_Frag_Order.Clear;
    end;
end;

procedure TFFMPEG_Player_Sync_Tool.Set_Serialized_Tool(const Value: TPasAI_RasterSerialized);
begin
  FSerialized_Tool := Value;
end;

procedure TFFMPEG_Player_Sync_Tool.Set_Auto_Write_Serialized(const Value: Boolean);
begin
  FAuto_Write_Serialized := Value;
end;

constructor TFFMPEG_Player_Sync_Tool.Create(Player_: TFFMPEG_Player_Extract_Tool; Width_, Height_: TGeoFloat);
begin
  inherited Create;
  Player := Player_;
  FVideo_Codec_Stream := Player.Current_Video;
  FAudio_Codec_Stream := Player.Current_Audio;
  FAudioDelay := 0;
  FSyncAccuracy := 0.1;
  Raster_Frag_Order := TRaster_Frag_Order.Create;
  Audio_Frag_Order := TAudio_Frag_Order.Create;
  FVideoTrans := TFFMPEG_Player_Video_Transform.Create(Player, Width_, Height_);
  FAudioTrans := TFFMPEG_Audio_Transform.Create(Player);
  FAudioTrans.Prepare;
  FRealTimeMode := False;
  FCalibration := False;
  FCalibration_Video_PTS := 0;
  FCalibration_Audio_PTS := 0;
  FCalibration_Time := 0;
  FSerialized_Tool := nil;
  FAuto_Write_Serialized := False;
  Last_Process_Is_Video := False;
  Last_Process_Is_Audio := False;
  Process_Video_Num := 0;
  Process_Audio_Num := 0;
end;

destructor TFFMPEG_Player_Sync_Tool.Destroy;
begin
  DisposeObjectAndNil(FAudioTrans);
  DisposeObjectAndNil(FVideoTrans);
  DisposeObjectAndNil(Audio_Frag_Order);
  DisposeObjectAndNil(Raster_Frag_Order);
  inherited Destroy;
end;

procedure TFFMPEG_Player_Sync_Tool.Process(Input: PCodec_Stream_);
var
  VF: TRaster_Frag;
  AF: TAudio_Frag;
begin
  Last_Process_Is_Video := False;
  Last_Process_Is_Audio := False;

  if FVideoTrans.Ready and Input^.IsVideo and (Input = FVideo_Codec_Stream) then
    begin
      VF.PTS := Input^.Frame^.PTS;
      VF.VideoData := NewPasAI_Raster();
      FVideoTrans.Transform(Input, VF.VideoData, True);
      if FAuto_Write_Serialized and (FSerialized_Tool <> nil) then
          VF.VideoData.SerializedAndRecycleMemory(FSerialized_Tool);
      Raster_Frag_Order.Push(VF);
      Last_Process_Is_Video := True;
      inc(Process_Video_Num);
    end
  else if (not FRealTimeMode) and FAudioTrans.Ready and Input^.IsAudio and (Input = FAudio_Codec_Stream) then
    begin
      AF.PTS := Input^.Frame^.PTS;
      AF.AudioData := TMem64.Create;
      FAudioTrans.TransformTo(Input, AF.AudioData);
      Audio_Frag_Order.Push(AF);
      Last_Process_Is_Audio := True;
      inc(Process_Audio_Num);
    end;
end;

procedure TFFMPEG_Player_Sync_Tool.Set_Codec_Stream(Codec_Stream_: PCodec_Stream_);
begin
  if FVideoTrans.Ready and Codec_Stream_^.IsVideo then
    begin
      if FVideo_Codec_Stream <> Codec_Stream_ then
        begin
          FVideo_Codec_Stream := Codec_Stream_;
          Raster_Frag_Order.Clear;
        end;
    end
  else if FAudioTrans.Ready and Codec_Stream_^.IsAudio then
    begin
      if FAudio_Codec_Stream <> Codec_Stream_ then
        begin
          FAudio_Codec_Stream := Codec_Stream_;
          FAudioTrans.Stop;
          Raster_Frag_Order.Clear;
        end;
    end;
end;

procedure TFFMPEG_Player_Sync_Tool.Sync();
begin
  FAudioTrans.Stop;
  FAudioTrans.Clear;
  FCalibration := False;
end;

procedure TFFMPEG_Player_Sync_Tool.Sync(AudioDelay_, Accuracy_: Double);
begin
  FAudioDelay := AudioDelay_;
  FSyncAccuracy := Accuracy_;
  Sync();
end;

function TFFMPEG_Player_Sync_Tool.Update(raster: TPasAI_Raster): Boolean;
var
  pt: Double; // physics time
  vt: Double; // video pts time
  at: Double; // audio pts time
begin
  Result := False;
  if (not FVideoTrans.Ready) and FAudioTrans.Ready and (Audio_Frag_Order.Num > 0) then
    begin
      FAudioTrans.Clear;
      if not FAudioTrans.isPlaying then
          FAudioTrans.Play(True);
      if (not Player.Enabled_Video) or (Player.Current_Video = nil) then
        while Audio_Frag_Order.Num > 0 do
          begin
            FAudioTrans.Flush(Audio_Frag_Order.Current^.Data.AudioData);
            Audio_Frag_Order.Next;
          end;
      exit;
    end;
  if (FRealTimeMode or (not FAudioTrans.Ready)) and (Raster_Frag_Order.Num > 0) then
    begin
      raster.SwapInstance(Raster_Frag_Order.Current^.Data.VideoData);
      Raster_Frag_Order.Clear;
      Audio_Frag_Order.Clear;
      Result := True;
      exit;
    end;

  while (not FCalibration) and (FVideoTrans.Ready) and (FAudioTrans.Ready) and (Raster_Frag_Order.Num > 0) and (Audio_Frag_Order.Num > 0) do
    begin
      vt := Raster_Frag_Order.Current^.Data.PTS * FVideo_Codec_Stream^.TB;
      at := Audio_Frag_Order.Current^.Data.PTS * FAudio_Codec_Stream^.TB + FAudioDelay;

      if (vt - at) >= FSyncAccuracy then
        begin
          Audio_Frag_Order.Next;
        end
      else if (at - vt) >= FSyncAccuracy then
        begin
          Raster_Frag_Order.Next;
        end
      else
        begin
          FCalibration := True;
          FCalibration_Video_PTS := Raster_Frag_Order.Current^.Data.PTS;
          FCalibration_Audio_PTS := Audio_Frag_Order.Current^.Data.PTS;
          FCalibration_Time := GetTimeTick;
          raster.SwapInstance(Raster_Frag_Order.Current^.Data.VideoData);
          Raster_Frag_Order.Next;
          FAudioTrans.Flush(Audio_Frag_Order.Current^.Data.AudioData);
          Audio_Frag_Order.Next;
          FAudioTrans.Play(True);
          Result := True;
        end;
    end;

  if FCalibration then
    begin
      pt := (GetTimeTick - FCalibration_Time) * 0.001;
      while Audio_Frag_Order.Num > 0 do
        begin
          at := (Audio_Frag_Order.Current^.Data.PTS - FCalibration_Audio_PTS) * FAudio_Codec_Stream^.TB;
          FAudioTrans.Flush(Audio_Frag_Order.Current^.Data.AudioData);
          Audio_Frag_Order.Next;
        end;

      if Raster_Frag_Order.Num > 0 then
        begin
          vt := (Raster_Frag_Order.Current^.Data.PTS - FCalibration_Video_PTS) * FVideo_Codec_Stream^.TB;
          if pt >= vt then
            begin
              raster.SwapInstance(Raster_Frag_Order.Current^.Data.VideoData);
              Raster_Frag_Order.Next;
              Result := True;
            end
        end;
    end;
end;

constructor TFFMPEG_Player_Extract_Tool.Create(URL_: TPascalString);
begin
  Create(URL_, True);
end;

constructor TFFMPEG_Player_Extract_Tool.Create(URL_: TPascalString; RTSP_Used_TCP_: Boolean);
begin
  inherited Create;
  OnVideo := nil;
  OnAudio := nil;
  Enabled_Video := True;
  Enabled_Audio := True;
  FCodec_Stream_Pool := TCodec_Stream_Pool.Create;
  Ready := OpenURL(URL_, RTSP_Used_TCP_);
end;

destructor TFFMPEG_Player_Extract_Tool.Destroy;
begin
  Close;
  DisposeObject(FCodec_Stream_Pool);
  inherited Destroy;
end;

function TFFMPEG_Player_Extract_Tool.OpenURL(URL_: TPascalString; RTSP_Used_TCP_: Boolean): Boolean;
var
  gpu_decodec: PAVCodec;
  AV_Options: PPAVDictionary;
  tmp: Pointer;
  R: integer;
  i: integer;
  p: Pointer;
begin
  Result := False;
  FURL := URL_;

  Current_Video := nil;
  Current_Audio := nil;
  AV_Options := nil;
  FFormatCtx := nil;
  FPacket := nil;
  Width := 0;
  Height := 0;
  FCodec_Stream_Pool.Clean;

  p := URL_.BuildPlatformPChar;

  // Open video URL
  try
    tmp := TPascalString(umlIntToStr(8 * 1024 * 1024)).BuildPlatformPChar;
    av_dict_set(@AV_Options, 'buffer_size', tmp, 0);
    av_dict_set(@AV_Options, 'stimeout', '6000000', 0);
    av_dict_set(@AV_Options, 'max_delay', '50000000', 0);
    av_dict_set(@AV_Options, 'thread_queue_size', '1024', 0);
    if RTSP_Used_TCP_ then
      begin
        av_dict_set(@AV_Options, 'rtsp_flags', '+prefer_tcp', 0);
        av_dict_set(@AV_Options, 'rtsp_transport', '+tcp', 0);
      end
    else
      begin
        av_dict_set(@AV_Options, 'rtsp_transport', 'udp', 0);
        av_dict_set(@AV_Options, 'min_port', '8000', 0);
        av_dict_set(@AV_Options, 'max_port', '20000', 0);
      end;
    TPascalString.FreePlatformPChar(tmp);

    R := avformat_open_input(@FFormatCtx, PAnsiChar(p), nil, @AV_Options);
    if R <> 0 then
      begin
        DoStatus('Could not open URL %s error code: %d', [URL_.Text, R]);
        exit;
      end;

    // Retrieve stream information
    if avformat_find_stream_info(FFormatCtx, nil) < 0 then
      begin
        if FFormatCtx <> nil then
            avformat_close_input(@FFormatCtx);

        DoStatus('Could not find stream information %s', [URL_.Text]);
        exit;
      end;

    if IsConsole then
        av_dump_format(FFormatCtx, 0, PAnsiChar(p), 0);

    FCodec_Stream_Pool.BuildCodec(FFormatCtx);

    for i := 0 to FCodec_Stream_Pool.Count - 1 do
      begin
        if (Current_Video = nil) and (FCodec_Stream_Pool[i]^.IsVideo) then
            Current_Video := FCodec_Stream_Pool[i]
        else if (Current_Audio = nil) and (FCodec_Stream_Pool[i]^.IsAudio) then
            Current_Audio := FCodec_Stream_Pool[i];
        if (Current_Video <> nil) and (Current_Audio <> nil) then
            break;
      end;

    FPacket := av_packet_alloc();
    Current_VideoStream_Time := 0;
    Current_AudioStream_Time := 0;
    Current_Video_Frame := 0;
    Current_Audio_Frame := 0;
    Current_Video_Packet_Num := 0;
    Current_Audio_Packet_Num := 0;
    Result := True;
  finally
      TPascalString.FreePlatformPChar(p);
  end;
end;

function TFFMPEG_Player_Extract_Tool.ReadAndDecodeFrame(): TDecode_State;
var
  p: PCodec_Stream_;
  i: integer;
  error_: Boolean;
  R: integer;
begin
  Result := dsError;
  error_ := False;
  try
    while True do
      begin
        R := av_read_frame(FFormatCtx, FPacket);
        if R < 0 then
          begin
            DoStatus('av_read_frame: %s', [av_err2str(R)]);
            break;
          end;

        p := nil;
        for i := 0 to FCodec_Stream_Pool.Count - 1 do
          if FCodec_Stream_Pool[i]^.StreamIndex = FPacket^.stream_index then
            begin
              p := FCodec_Stream_Pool[i];
              break;
            end;

        if p = nil then
            continue;

        if p^.IsVideo then
          begin
            if Enabled_Video then
                R := avcodec_send_packet(p^.CodecContext, FPacket)
            else
                R := 0;
            inc(Current_Video_Packet_Num);
          end
        else if p^.IsAudio then
          begin
            if Enabled_Audio then
                R := avcodec_send_packet(p^.CodecContext, FPacket)
            else
                R := 0;
            inc(Current_Audio_Packet_Num);
          end
        else
            continue;

        if R < 0 then
          begin
            DoStatus('Error sending a packet for decoding: %s', [av_err2str(R)]);
            continue;
          end;

        error_ := False;
        while True do
          begin
            if p^.IsVideo then
              begin
                if Enabled_Video then
                    R := avcodec_receive_frame(p^.CodecContext, p^.Frame)
                else
                    R := 0;
              end
            else if p^.IsAudio then
              begin
                if Enabled_Audio then
                    R := avcodec_receive_frame(p^.CodecContext, p^.Frame)
                else
                    R := 0;
              end
            else
              begin
                DoStatus('Error straming error: %s', [av_err2str(R)]);
                exit;
              end;

            // success
            if R = 0 then
              begin
                if p^.IsVideo then
                  begin
                    if Enabled_Video then
                      begin
                        inc(Current_Video_Frame);
                        if (FPacket^.PTS > 0) and (av_q2d(p^.Stream^.time_base) > 0) then
                            Current_VideoStream_Time := FPacket^.PTS * av_q2d(p^.Stream^.time_base);
                        try
                          if Assigned(OnVideo) then
                              OnVideo(self, p);
                        except
                        end;
                        Current_Video := p;
                        Width := p^.CodecContext^.Width;
                        Height := p^.CodecContext^.Height;
                        Result := dsVideo;
                      end
                    else
                        Result := dsIgnore;
                  end
                else if p^.IsAudio then
                  begin
                    if Enabled_Audio then
                      begin
                        inc(Current_Audio_Frame);
                        if (FPacket^.PTS > 0) and (av_q2d(p^.Stream^.time_base) > 0) then
                            Current_AudioStream_Time := FPacket^.PTS * av_q2d(p^.Stream^.time_base);

                        try
                          if Assigned(OnAudio) then
                              OnAudio(self, p);
                        except
                        end;
                        Current_Audio := p;
                        Result := dsAudio;
                      end
                    else
                        Result := dsIgnore;
                  end;
                break;
              end;

            // AVERROR(EAGAIN): Output is not available in this state - user must try to send new input
            if R = AVERROR_EAGAIN then
              begin
                av_packet_unref(FPacket);
                Result := ReadAndDecodeFrame();
                exit;
              end;

            // AVERROR_EOF: the decoder has been fully flushed, and there will be no more Output frames
            if R = AVERROR_EOF then
              begin
                if p^.IsVideo then
                    avcodec_flush_buffers(p^.CodecContext)
                else if p^.IsAudio then
                    avcodec_flush_buffers(p^.CodecContext)
                else
                  begin
                    DoStatus('Error straming error.');
                    exit;
                  end;
                continue;
              end;

            // error
            if R < 0 then
              begin
                error_ := True;
                break;
              end;
          end;

        if (not error_) then
          begin
            // done
          end;

        error_ := True;
        av_packet_unref(FPacket);
        break;
      end;
  except
  end;
end;

procedure TFFMPEG_Player_Extract_Tool.Close;
begin
  FCodec_Stream_Pool.Clean;
  if FPacket <> nil then
      av_free_packet(FPacket);

  if FFormatCtx <> nil then
      avformat_close_input(@FFormatCtx);

  FFormatCtx := nil;
  FPacket := nil;
  Width := 0;
  Height := 0;
  Current_VideoStream_Time := 0;
  Current_AudioStream_Time := 0;
  Current_Video_Frame := 0;
  Current_Audio_Frame := 0;
end;

function TFFMPEG_Player_Extract_Tool.Get_VideoStream_Fit(Width_, Height_: TGeoFloat): TVideoStream_Size_Pool;
var
  i: integer;
  p: PCodec_Stream_;
begin
  Result := TVideoStream_Size_Pool.Create;
  for i := 0 to FCodec_Stream_Pool.Count - 1 do
    begin
      p := FCodec_Stream_Pool[i];
      if p^.IsVideo then
        begin
          if Width_ <= 0 then
              Width_ := p^.CodecContext^.Width;
          if Height_ <= 0 then
              Height_ := p^.CodecContext^.Height;

          Result.Add(FitRect(p^.CodecContext^.Width, p^.CodecContext^.Height, RectV2(0, 0, Width_, Height_)));
        end;
    end;
end;

function TFFMPEG_Player_Extract_Tool.VideoTotal: Double;
begin
  Result := umlMax(FFormatCtx^.duration / AV_TIME_BASE, 0);
  if IsNan(Result) then
      Result := 0;
end;

function TFFMPEG_Player_Extract_Tool.CurrentVideoStream_Total_Frame: Int64;
begin
  if Current_Video <> nil then
      Result := umlMax(Current_Video^.Stream^.nb_frames, 0)
  else
      Result := 0;
end;

function TFFMPEG_Player_Extract_Tool.CurrentVideoStream_PerSecond_Frame(): Double;
begin
  if Current_Video <> nil then
    begin
      with Current_Video^.Stream^.r_frame_rate do
          Result := umlMax(Num / den, 0);
      if IsNan(Result) then
          Result := 0;
    end
  else
      Result := 0;
end;

function TFFMPEG_Player_Extract_Tool.CurrentVideoStream_PerSecond_FrameRound(): integer;
begin
  Result := Round(CurrentVideoStream_PerSecond_Frame());
end;

function TFFMPEG_Player_Extract_Tool.AudioTotal: Double;
begin
  Result := umlMax(FFormatCtx^.duration / AV_TIME_BASE, 0);
  if IsNan(Result) then
      Result := 0;
end;

function TFFMPEG_Player_Extract_Tool.CurrentAudioStream_Total_Frame: Int64;
begin
  if Current_Audio <> nil then
      Result := umlMax(Current_Audio^.Stream^.nb_frames, 0)
  else
      Result := 0;
end;

function TFFMPEG_Player_Extract_Tool.CurrentAudioStream_PerSecond_Frame(): Double;
begin
  if Current_Audio <> nil then
    begin
      with Current_Audio^.Stream^.r_frame_rate do
          Result := umlMax(Num / den, 0);
      if IsNan(Result) then
          Result := 0;
    end
  else
      Result := 0;
end;

function TFFMPEG_Player_Extract_Tool.CurrentAudioStream_PerSecond_FrameRound(): integer;
begin
  Result := Round(CurrentAudioStream_PerSecond_Frame());
end;

end.
