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
{ * AI face Recognition ON Video                                               * }
{ ****************************************************************************** }
unit PasAI.AI.VideoFace.Queue;

{$DEFINE FPC_DELPHI_MODE}
{$I PasAI.Define.inc}

interface

uses PasAI.Core, PasAI.PascalStrings, PasAI.UPascalStrings, PasAI.UnicodeMixedLib, PasAI.Status, PasAI.MemoryStream, PasAI.ListEngine, PasAI.Notify,
{$IFDEF FPC}
  PasAI.FPC.GenericList,
{$ENDIF FPC}
  PasAI.MemoryRaster, PasAI.Geometry2D,
  PasAI.h264, PasAI.FFMPEG, PasAI.FFMPEG.Reader, PasAI.FFMPEG.Writer,
  PasAI.AI, PasAI.AI.Common, PasAI.AI.FFMPEG, PasAI.Learn, PasAI.Learn.Type_LIB;

type
  TFaceRecognitionQueue = class;
  TFaceInputQueue = class;

  PFaceDetectorData = ^TFaceDetectorData;
  PFaceMetricData = ^TFaceMetricData;

  TFaceMetricData = record
    Owner: PFaceDetectorData;
    Raster: TPasAI_Raster;
    Data: TLVec;
    K: TLFloat;
    Token: U_String;
    Done: Boolean;
  end;

  TFaceDetectorData = record
    ID: Integer;
    Raster: TPasAI_Raster;
    MMOD: TMMOD_Desc;
    Metric: array of TFaceMetricData;
    Done: Boolean;
    function IsBusy(): Boolean;
    function FoundToken(Token: PPascalString; IgnoreMaxK: TLFloat): Boolean;
  end;

  TFaceDetectorDataList = TGenericsList<PFaceDetectorData>;
  TFaceMetricDataList = TGenericsList<PFaceMetricData>;

  IOnFaceInputQueue = interface
    procedure DoInput(Sender: TFaceInputQueue; Raster: TPasAI_Raster);
    procedure DoRunDetect(Sender: TFaceInputQueue; pD: PFaceDetectorData);
    procedure DoDetectDone(Sender: TFaceInputQueue; pD: PFaceDetectorData);
    procedure DoRunMetric(Sender: TFaceInputQueue; pM: PFaceMetricData);
    procedure DoMetricDone(Sender: TFaceInputQueue; pM: PFaceMetricData);
    procedure DoDetectAndMetricDone(Sender: TFaceInputQueue; pD: PFaceDetectorData);
    procedure DoQueueDone(Sender: TFaceInputQueue);
    procedure DoCutQueueOnDetection(Sender: TFaceInputQueue; bIndex, eIndex: Integer);
    procedure DoCutQueueOnMaxFrame(Sender: TFaceInputQueue; bIndex, eIndex: Integer);
  end;

  TFaceInputQueue = class(TCore_Object_Intermediate)
  private
    FRunning: Integer;
    FOwner: TFaceRecognitionQueue;
    FQueue: TFaceDetectorDataList;
    FEvent_Critical: TCritical;
    FData_Critical: TCritical;
    FCutNullQueue: Boolean;
    FMaxQueue: Integer;
    FIDSeed: Integer;
    procedure FaceDetector_OnResult(ThSender: TPas_AI_DNN_Thread_MMOD6L; UserData: Pointer; Input: TMPasAI_Raster; output: TMMOD_Desc);
    procedure FaceMetric_OnResult(ThSender: TPas_AI_DNN_Thread_Metric; UserData: Pointer; Input: TMPasAI_Raster; output: TLVec);
    procedure DoDelayCheckBusyAndFree;
  public
    OnInterface: IOnFaceInputQueue;
    property Owner: TFaceRecognitionQueue read FOwner;
    constructor Create(Owner_: TFaceRecognitionQueue);
    destructor Destroy; override;
    function LockQueue: TFaceDetectorDataList;
    procedure UnLockQueue;
    procedure Clean;
    procedure DelayCheckBusyAndFree;
    procedure Input(PasAI_Raster_: TPasAI_Raster; instance_: Boolean);
    procedure InputStream(Reader: TFFMPEG_VideoStreamReader; stream: TCore_Stream; MaxFrame: Integer);
    procedure InputH264Stream(stream: TCore_Stream; MaxFrame: Integer);
    procedure InputMJPEGStream(stream: TCore_Stream; MaxFrame: Integer);
    procedure InputFFMPEGSource(source: TPascalString; MaxFrame: Integer);
    function Busy: Boolean; overload;
    function Busy(bIndex, eIndex: Integer): Boolean; overload;
    function Delete(bIndex, eIndex: Integer): Boolean;
    procedure RemoveNullOutput;
    procedure GetQueueState(IgnoreMaxK: TLFloat; var Detector_Done_Num, Detector_Busy_Num, Metric_Done_Num, Metric_Busy_Num, NullQueue_Num, Invalid_box_Num: Integer; TokenInfo: THashVariantList);
    function AnalysisK(MaxFrame: Integer; IgnoreMaxK: TLFloat; var MaxK, avgK, MinK: TLFloat; var total_num, matched_num: Integer): TPascalString;
    procedure BuildQueueToImageList(Token: TPascalString; IgnoreMaxK: TLFloat; FitWidth_, FitHeight_: Integer; ImgL: TPas_AI_ImageList);
    function Count: Integer;
    procedure SaveQueueAsPasH264Stream(stream: TCore_Stream);
    procedure SaveQueueAsH264Stream(stream: TCore_Stream);
    procedure SaveQueueAsMJPEGStream(stream: TCore_Stream);

    property CutNullQueue: Boolean read FCutNullQueue write FCutNullQueue;
    property MaxQueue: Integer read FMaxQueue write FMaxQueue;
  end;

  TFaceRecognitionQueue = class(TCore_Object_Intermediate)
  private
    FDNN_Face_Detector_Pool: TPas_AI_DNN_Thread_Pool;
    FDNN_Face_Metric_Pool: TPas_AI_DNN_Thread_Pool;
    FParallel: TPas_AI_Parallel;
    FLearn: TLearn;
  public
    constructor Create; overload;
    constructor Create(Det_ThNum, Classifier_ThNum: Integer); overload;
    constructor Create(Device_: TLIVec; Det_ThNum, Classifier_ThNum: Integer); overload;
    destructor Destroy; override;

    procedure OpenMetricFile(MetricModel: U_String);
    procedure OpenMetricStream(MetricModel: TMS64);
    procedure OpenLearnFile(LearnModel: U_String);
    procedure OpenLearnStream(LearnModel: TMS64);

    procedure Wait;

    property DNN_Face_Detector_Pool: TPas_AI_DNN_Thread_Pool read FDNN_Face_Detector_Pool;
    property Parallel: TPas_AI_Parallel read FParallel;
    property DNN_Face_Metric_Pool: TPas_AI_DNN_Thread_Pool read FDNN_Face_Metric_Pool;
    property Learn: TLearn read FLearn;
  end;

implementation

function TFaceDetectorData.IsBusy(): Boolean;
var
  i: Integer;
begin
  Result := True;
  if not Done then
      exit;
  for i := 0 to length(Metric) - 1 do
    if not Metric[i].Done then
        exit;
  Result := False;
end;

function TFaceDetectorData.FoundToken(Token: PPascalString; IgnoreMaxK: TLFloat): Boolean;
var
  i: Integer;
begin
  Result := False;
  if IsBusy() then
      exit;
  for i := 0 to length(Metric) - 1 do
    if Metric[i].Done then
      if Token^.Same(@Metric[i].Token) and (Metric[i].K < IgnoreMaxK) and RectInRect(MMOD[i].r, Raster.BoundsRectV2) then
          exit(True);
end;

procedure TFaceInputQueue.FaceDetector_OnResult(ThSender: TPas_AI_DNN_Thread_MMOD6L; UserData: Pointer; Input: TMPasAI_Raster; output: TMMOD_Desc);
var
  p: PFaceDetectorData;
  AI: TPas_AI;
  fHnd: TFace_Handle;
  i: Integer;
begin
  p := UserData;
  p^.MMOD := output;
  SetLength(p^.Metric, length(p^.MMOD));
  for i := 0 to length(p^.Metric) - 1 do
    begin
      p^.Metric[i].Owner := p;
      p^.Metric[i].Raster := nil;
      SetLength(p^.Metric[i].Data, 0);
      p^.Metric[i].K := 0;
      p^.Metric[i].Token := '';
      p^.Metric[i].Done := False;
    end;

  p^.Done := True;
  AtomDec(FRunning);

  if Assigned(OnInterface) then
    begin
      try
          OnInterface.DoDetectDone(Self, p);
      except
      end;
    end;

  if length(p^.MMOD) > 0 then
    begin
      AI := FOwner.FParallel.GetAndLockAI;
      fHnd := AI.Face_Detector(Input, p^.MMOD, C_Metric_Input_Size);
      for i := 0 to AI.Face_chips_num(fHnd) - 1 do
        begin
          p^.Metric[i].Raster := AI.Face_chips(fHnd, i);
          if Assigned(OnInterface) then
            begin
              try
                  OnInterface.DoRunMetric(Self, @p^.Metric[i]);
              except
              end;
            end;

          AtomInc(FRunning);
          with TPas_AI_DNN_Thread_Metric(FOwner.DNN_Face_Metric_Pool.MinLoad_DNN_Thread) do
              ProcessM(@p^.Metric[i], p^.Metric[i].Raster, False, FaceMetric_OnResult);
        end;
      AI.Face_Close(fHnd);
      FOwner.FParallel.UnLockAI(AI);
    end;

  FEvent_Critical.Lock;
  try
    if FCutNullQueue then
      begin
        FData_Critical.Lock;
        i := FQueue.IndexOf(p);
        FData_Critical.UnLock;
        if i >= 0 then
          begin
            if not Busy(0, i) then
              begin
                if Assigned(OnInterface) then
                  begin
                    try
                        OnInterface.DoCutQueueOnDetection(Self, 0, i);
                    except
                    end;
                  end;
                Delete(0, i);
              end;
          end;
        if Assigned(OnInterface) then
          begin
            try
                OnInterface.DoDetectAndMetricDone(Self, p);
            except
            end;
          end;
      end;

    if not Busy then
      if Assigned(OnInterface) then
        begin
          try
              OnInterface.DoQueueDone(Self);
          except
          end;
        end;
  finally
      FEvent_Critical.UnLock;
  end;
end;

procedure TFaceInputQueue.FaceMetric_OnResult(ThSender: TPas_AI_DNN_Thread_Metric; UserData: Pointer; Input: TMPasAI_Raster; output: TLVec);
var
  i: Integer;
  p: PFaceMetricData;
  num: Integer;
begin
  AtomDec(FRunning);
  p := UserData;
  p^.Data := LVecCopy(output);
  p^.Token := TPas_AI.Process_Metric_Token(FOwner.FLearn, p^.Data, 0, 1, p^.K);

  FEvent_Critical.Lock;
  try
    p^.Done := True;
    if Assigned(OnInterface) then
        OnInterface.DoMetricDone(Self, p);

    if not p^.Owner^.IsBusy then
      begin
        if Assigned(OnInterface) then
          begin
            try
                OnInterface.DoDetectAndMetricDone(Self, p^.Owner);
            except
            end;
          end;
        FData_Critical.Lock;
        num := Count - FMaxQueue;
        FData_Critical.UnLock;
        if num > 0 then
          if not Busy(0, num) then
            begin
              if Assigned(OnInterface) then
                begin
                  try
                      OnInterface.DoCutQueueOnMaxFrame(Self, 0, num);
                  except
                  end;
                end;
              Delete(0, num);
            end;
      end;

    if not Busy then
      if Assigned(OnInterface) then
        begin
          try
              OnInterface.DoQueueDone(Self);
          except
          end;
        end;
  finally
      FEvent_Critical.UnLock;
  end;
end;

procedure TFaceInputQueue.DoDelayCheckBusyAndFree;
begin
  while (FRunning > 0) or (Busy) do
      TCompute.Sleep(10);
  DelayFreeObj(1.0, Self);
end;

constructor TFaceInputQueue.Create(Owner_: TFaceRecognitionQueue);
begin
  inherited Create;
  FRunning := 0;
  FOwner := Owner_;
  FQueue := TFaceDetectorDataList.Create;
  FEvent_Critical := TCritical.Create;
  FData_Critical := TCritical.Create;
  FCutNullQueue := True;
  FMaxQueue := 300;
  FIDSeed := 0;
  OnInterface := nil;
end;

destructor TFaceInputQueue.Destroy;
begin
  Clean;
  disposeObject(FQueue);
  FEvent_Critical.Free;
  FData_Critical.Free;
  inherited Destroy;
end;

function TFaceInputQueue.LockQueue: TFaceDetectorDataList;
begin
  FData_Critical.Lock;
  Result := FQueue;
end;

procedure TFaceInputQueue.UnLockQueue;
begin
  FData_Critical.UnLock;
end;

procedure TFaceInputQueue.Clean;
var
  i, j: Integer;
  pD: PFaceDetectorData;
  pM: PFaceMetricData;
begin
  while Busy do
      TCompute.Sleep(1);

  FData_Critical.Lock;
  for i := 0 to FQueue.Count - 1 do
    begin
      pD := FQueue[i];
      for j := 0 to length(pD^.Metric) - 1 do
        begin
          pM := @pD^.Metric[j];
          disposeObject(pM^.Raster);
          SetLength(pM^.Data, 0);
          pM^.Token := '';
        end;
      disposeObject(pD^.Raster);
      SetLength(pD^.MMOD, 0);
      SetLength(pD^.Metric, 0);
      dispose(pD);
    end;
  FQueue.Clear;
  FData_Critical.UnLock;
  FIDSeed := 0;
end;

procedure TFaceInputQueue.DelayCheckBusyAndFree;
begin
  TCompute.RunM_NP(DoDelayCheckBusyAndFree);
end;

procedure TFaceInputQueue.Input(PasAI_Raster_: TPasAI_Raster; instance_: Boolean);
var
  r: TPasAI_Raster;
  pD: PFaceDetectorData;
begin
  if instance_ then
      r := PasAI_Raster_
  else
      r := PasAI_Raster_.Clone;

  new(pD);
  pD^.ID := FIDSeed;
  AtomInc(FIDSeed);
  pD^.Raster := r;
  SetLength(pD^.MMOD, 0);
  SetLength(pD^.Metric, 0);
  pD^.Done := False;

  FData_Critical.Lock;
  FQueue.Add(pD);
  FData_Critical.UnLock;

  if Assigned(OnInterface) then
      OnInterface.DoInput(Self, r);
  if Assigned(OnInterface) then
      OnInterface.DoRunDetect(Self, pD);

  AtomInc(FRunning);
  with TPas_AI_DNN_Thread_MMOD6L(FOwner.DNN_Face_Detector_Pool.MinLoad_DNN_Thread) do
      ProcessM(pD, r, False, FaceDetector_OnResult);
end;

procedure TFaceInputQueue.InputStream(Reader: TFFMPEG_VideoStreamReader; stream: TCore_Stream; MaxFrame: Integer);
const
  C_Chunk_Buff_Size = 1 * 1024 * 1024;
var
  tempBuff: Pointer;
  chunk: NativeInt;
  L: TMemoryPasAI_RasterList;
  i: Integer;
  curNum: Integer;
begin
  curNum := 0;
  tempBuff := GetMemory(C_Chunk_Buff_Size);
  stream.Position := 0;
  while (stream.Position < stream.Size) do
    begin
      chunk := umlMin(stream.Size - stream.Position, C_Chunk_Buff_Size);
      if chunk <= 0 then
          break;
      stream.Read(tempBuff^, chunk);
      Reader.WriteBuffer(tempBuff, chunk);

      L := Reader.LockVideoPool;
      while L.Count > 0 do
        begin
          Input(L[0], True);
          L.Delete(0);
          inc(curNum);
        end;
      Reader.UnLockVideoPool(True);
      if (MaxFrame > 0) and (curNum > MaxFrame) then
          break;
    end;
  FreeMemory(tempBuff);
end;

procedure TFaceInputQueue.InputH264Stream(stream: TCore_Stream; MaxFrame: Integer);
var
  Reader: TFFMPEG_VideoStreamReader;
begin
  Reader := TFFMPEG_VideoStreamReader.Create;
  Reader.OpenH264Decodec;
  InputStream(Reader, stream, MaxFrame);
  disposeObject(Reader);
end;

procedure TFaceInputQueue.InputMJPEGStream(stream: TCore_Stream; MaxFrame: Integer);
var
  Reader: TFFMPEG_VideoStreamReader;
begin
  Reader := TFFMPEG_VideoStreamReader.Create;
  Reader.OpenMJPEGDecodec;
  InputStream(Reader, stream, MaxFrame);
  disposeObject(Reader);
end;

procedure TFaceInputQueue.InputFFMPEGSource(source: TPascalString; MaxFrame: Integer);
var
  Reader: TFFMPEG_Reader;
  Raster: TPasAI_Raster;
  curNum: Integer;
begin
  Reader := TFFMPEG_Reader.Create(source);
  Raster := NewPasAI_Raster();
  curNum := 0;
  while Reader.ReadFrame(Raster, False) do
    begin
      Input(Raster, False);
      inc(curNum);
      if (MaxFrame > 0) and (curNum > MaxFrame) then
          break;
    end;
  disposeObject(Reader);
  disposeObject(Raster);
end;

function TFaceInputQueue.Busy: Boolean;
begin
  Result := Busy(0, FQueue.Count - 1);
end;

function TFaceInputQueue.Busy(bIndex, eIndex: Integer): Boolean;
var
  i: Integer;
begin
  FData_Critical.Lock;
  Result := False;
  for i := umlMax(0, bIndex) to umlMin(FQueue.Count - 1, eIndex) do
      Result := Result or FQueue[i]^.IsBusy();
  FData_Critical.UnLock;
end;

function TFaceInputQueue.Delete(bIndex, eIndex: Integer): Boolean;
var
  i, j: Integer;
  pD: PFaceDetectorData;
  pM: PFaceMetricData;
begin
  Result := False;
  if not Busy(bIndex, eIndex) then
    begin
      FData_Critical.Lock;
      for i := umlMax(0, bIndex) to umlMin(FQueue.Count - 1, eIndex) do
        begin
          pD := FQueue[bIndex];
          for j := 0 to length(pD^.Metric) - 1 do
            begin
              pM := @pD^.Metric[j];
              disposeObject(pM^.Raster);
              SetLength(pM^.Data, 0);
              pM^.Token := '';
            end;
          disposeObject(pD^.Raster);
          SetLength(pD^.MMOD, 0);
          SetLength(pD^.Metric, 0);
          dispose(pD);
          FQueue.Delete(umlMax(0, bIndex));
        end;
      FData_Critical.UnLock;
      Result := True;
    end;
end;

procedure TFaceInputQueue.RemoveNullOutput;
var
  i, j: Integer;
  pD: PFaceDetectorData;
  pM: PFaceMetricData;
begin
  FData_Critical.Lock;
  i := 0;
  while i < FQueue.Count do
    begin
      pD := FQueue[i];
      if (not pD^.IsBusy) and (length(pD^.MMOD) = 0) then
        begin
          for j := 0 to length(pD^.Metric) - 1 do
            begin
              pM := @pD^.Metric[j];
              disposeObject(pM^.Raster);
              SetLength(pM^.Data, 0);
              pM^.Token := '';
            end;
          disposeObject(pD^.Raster);
          SetLength(pD^.MMOD, 0);
          SetLength(pD^.Metric, 0);
          dispose(pD);
          FQueue.Delete(i);
        end
      else
          inc(i);
    end;
  FData_Critical.UnLock;
end;

procedure TFaceInputQueue.GetQueueState(IgnoreMaxK: TLFloat; var Detector_Done_Num, Detector_Busy_Num, Metric_Done_Num, Metric_Busy_Num, NullQueue_Num, Invalid_box_Num: Integer; TokenInfo: THashVariantList);
var
  i, j: Integer;
  pD: PFaceDetectorData;
  pM: PFaceMetricData;
begin
  Detector_Done_Num := 0;
  Detector_Busy_Num := 0;
  Metric_Done_Num := 0;
  Metric_Busy_Num := 0;
  NullQueue_Num := 0;
  Invalid_box_Num := 0;

  if TokenInfo <> nil then
      TokenInfo.Clear;

  FData_Critical.Lock;
  for i := 0 to FQueue.Count - 1 do
    begin
      pD := FQueue[i];
      if (pD^.Done) then
        begin
          for j := 0 to length(pD^.MMOD) - 1 do
            if RectInRect(pD^.MMOD[j].r, pD^.Raster.BoundsRectV2) then
                inc(Detector_Done_Num)
            else
                inc(Invalid_box_Num);

          if pD^.IsBusy then
              inc(Detector_Busy_Num)
          else if length(pD^.MMOD) = 0 then
              inc(NullQueue_Num);

          for j := 0 to length(pD^.Metric) - 1 do
            begin
              pM := @pD^.Metric[j];
              if pM^.Done then
                begin
                  inc(Metric_Done_Num);
                  if (TokenInfo <> nil) and (pM^.K < IgnoreMaxK) then
                      TokenInfo.IncValue(pM^.Token, 1);
                end
              else
                  inc(Metric_Busy_Num);
            end;
        end;
    end;
  FData_Critical.UnLock;
end;

function TFaceInputQueue.AnalysisK(MaxFrame: Integer; IgnoreMaxK: TLFloat; var MaxK, avgK, MinK: TLFloat; var total_num, matched_num: Integer): TPascalString;
var
  HL: THashObjectList;
  L: TFaceMetricDataList;
  LSUM: TFaceMetricDataList;
  num_: Integer;
  sum_: TLFloat;

  i, j: Integer;
  pD: PFaceDetectorData;
  pM: PFaceMetricData;
begin
  MaxK := 0;
  avgK := 0;
  MinK := 0;
  matched_num := 0;
  total_num := 0;
  Result := '';

  FData_Critical.Lock;

  HL := THashObjectList.CustomCreate(True, 1024);
  LSUM := nil;
  num_ := 0;
  for i := FQueue.Count - 1 downto 0 do
    begin
      pD := FQueue[i];
      if pD^.Done then
        for j := 0 to length(pD^.Metric) - 1 do
          begin
            pM := @pD^.Metric[j];
            if pM^.Done and (pM^.K < IgnoreMaxK) and RectInRect(pD^.MMOD[j].r, pD^.Raster.BoundsRectV2) then
              begin
                if not HL.Exists(pM^.Token) then
                    HL.Add(pM^.Token, TFaceMetricDataList.Create);
                L := TFaceMetricDataList(HL[pM^.Token]);
                L.Add(pM);

                if (LSUM = nil) or ((LSUM <> L) and (LSUM.Count < L.Count)) then
                    LSUM := L;
                inc(total_num);
              end;
            inc(num_);
          end;
      if (MaxFrame > 0) and (num_ > MaxFrame) then
          break;
    end;

  if (LSUM <> nil) and (LSUM.Count > 0) then
    begin
      sum_ := LSUM.First^.K;
      MaxK := sum_;
      MinK := sum_;
      Result := LSUM.First^.Token;
      for i := 1 to LSUM.Count - 1 do
        begin
          pM := LSUM[i];
          if pM^.K > MaxK then
              MaxK := pM^.K;
          if pM^.K < MinK then
              MinK := pM^.K;
          sum_ := sum_ + pM^.K;
        end;
      avgK := LSafeDivF(sum_, LSUM.Count);
      matched_num := LSUM.Count;
    end;

  disposeObject(HL);

  FData_Critical.UnLock;
end;

procedure TFaceInputQueue.BuildQueueToImageList(Token: TPascalString; IgnoreMaxK: TLFloat; FitWidth_, FitHeight_: Integer; ImgL: TPas_AI_ImageList);
var
  i, j: Integer;
  pD: PFaceDetectorData;
  pM: PFaceMetricData;
  img: TPas_AI_Image;
  det: TPas_AI_DetectorDefine;
begin
  FData_Critical.Lock;
  for i := 0 to FQueue.Count - 1 do
    begin
      pD := FQueue[i];
      if pD^.FoundToken(@Token, IgnoreMaxK) then
        begin
          img := TPas_AI_Image.Create(ImgL);
          img.FileInfo := Token;
          ImgL.Add(img);
          img.ResetRaster(pD^.Raster.FitScaleAsNew(FitWidth_, FitHeight_));
          for j := 0 to length(pD^.Metric) - 1 do
            begin
              pM := @pD^.Metric[j];
              if Token.Same(pM^.Token) and (pM^.K < IgnoreMaxK) and RectInRect(pD^.MMOD[j].r, pD^.Raster.BoundsRectV2) then
                begin
                  det := img.DetectorDefineList.AddDetector(RoundRect(RectProjection(pD^.Raster.BoundsRectV2, img.Raster.BoundsRectV2, pD^.MMOD[j].r)), pM^.Token);
                  det.ResetPrepareRaster(pM^.Raster.Clone);
                end;
            end;
        end;
    end;
  FData_Critical.UnLock;
end;

function TFaceInputQueue.Count: Integer;
begin
  Result := FQueue.Count;
end;

procedure TFaceInputQueue.SaveQueueAsPasH264Stream(stream: TCore_Stream);
var
  Writer: TH264Writer;
  i: Integer;
begin
  if FQueue.Count = 0 then
      exit;
  Writer := TH264Writer.Create(FQueue.First^.Raster.Width, FQueue.First^.Raster.Height, FQueue.Count, 30, stream);
  for i := 0 to FQueue.Count - 1 do
      Writer.WriteFrame(FQueue[i]^.Raster);
  Writer.Flush;
  disposeObject(Writer);
end;

procedure TFaceInputQueue.SaveQueueAsH264Stream(stream: TCore_Stream);
var
  Writer: TFFMPEG_Writer;
  i: Integer;
begin
  if FQueue.Count = 0 then
      exit;
  Writer := TFFMPEG_Writer.Create(stream);
  Writer.AutoFreeOutput := False;
  Writer.OpenH264Codec(FQueue.First^.Raster.Width, FQueue.First^.Raster.Height, 30, 1024 * 2048);
  for i := 0 to FQueue.Count - 1 do
      Writer.EncodeRaster(FQueue[i]^.Raster);
  Writer.Flush;
  disposeObject(Writer);
end;

procedure TFaceInputQueue.SaveQueueAsMJPEGStream(stream: TCore_Stream);
var
  Writer: TFFMPEG_Writer;
  i: Integer;
begin
  if FQueue.Count = 0 then
      exit;
  Writer := TFFMPEG_Writer.Create(stream);
  Writer.AutoFreeOutput := False;
  Writer.OpenJPEGCodec(FQueue.First^.Raster.Width, FQueue.First^.Raster.Height, 2, 31);
  for i := 0 to FQueue.Count - 1 do
      Writer.EncodeRaster(FQueue[i]^.Raster);
  Writer.Flush;
  disposeObject(Writer);
end;

constructor TFaceRecognitionQueue.Create;
var
  i: Integer;
begin
  inherited Create;
  CheckAndReadAIConfig();
  PasAI.AI.Prepare_AI_Engine();

  FDNN_Face_Detector_Pool := TPas_AI_DNN_Thread_Pool.Create;
  FDNN_Face_Detector_Pool.BuildPerDeviceThread(2, TPas_AI_DNN_Thread_MMOD6L);
  for i := 0 to FDNN_Face_Detector_Pool.Count - 1 do
      TPas_AI_DNN_Thread_MMOD6L(FDNN_Face_Detector_Pool[i]).Open_Face;

  FDNN_Face_Metric_Pool := TPas_AI_DNN_Thread_Pool.Create;
  FDNN_Face_Metric_Pool.BuildPerDeviceThread(2, TPas_AI_DNN_Thread_Metric);

  FParallel := TPas_AI_Parallel.Create;
  FParallel.Prepare_Parallel(FDNN_Face_Detector_Pool.Count);
  FParallel.Prepare_FaceSP;

  FLearn := TPas_AI.Build_Metric_ResNet_Learn;
end;

constructor TFaceRecognitionQueue.Create(Det_ThNum, Classifier_ThNum: Integer);
var
  i: Integer;
begin
  inherited Create;
  CheckAndReadAIConfig();
  PasAI.AI.Prepare_AI_Engine();

  FDNN_Face_Detector_Pool := TPas_AI_DNN_Thread_Pool.Create;
  FDNN_Face_Detector_Pool.BuildPerDeviceThread(Det_ThNum, TPas_AI_DNN_Thread_MMOD6L);
  for i := 0 to FDNN_Face_Detector_Pool.Count - 1 do
      TPas_AI_DNN_Thread_MMOD6L(FDNN_Face_Detector_Pool[i]).Open_Face;

  FDNN_Face_Metric_Pool := TPas_AI_DNN_Thread_Pool.Create;
  FDNN_Face_Metric_Pool.BuildPerDeviceThread(Classifier_ThNum, TPas_AI_DNN_Thread_Metric);

  FParallel := TPas_AI_Parallel.Create;
  FParallel.Prepare_Parallel(FDNN_Face_Detector_Pool.Count);
  FParallel.Prepare_FaceSP;

  FLearn := TPas_AI.Build_Metric_ResNet_Learn;
end;

constructor TFaceRecognitionQueue.Create(Device_: TLIVec; Det_ThNum, Classifier_ThNum: Integer);
var
  i: Integer;
begin
  inherited Create;
  CheckAndReadAIConfig();
  PasAI.AI.Prepare_AI_Engine();

  FDNN_Face_Detector_Pool := TPas_AI_DNN_Thread_Pool.Create;
  FDNN_Face_Detector_Pool.BuildPerDeviceThread(Device_, Det_ThNum, TPas_AI_DNN_Thread_MMOD6L);
  for i := 0 to FDNN_Face_Detector_Pool.Count - 1 do
      TPas_AI_DNN_Thread_MMOD6L(FDNN_Face_Detector_Pool[i]).Open_Face;

  FDNN_Face_Metric_Pool := TPas_AI_DNN_Thread_Pool.Create;
  FDNN_Face_Metric_Pool.BuildPerDeviceThread(Device_, Classifier_ThNum, TPas_AI_DNN_Thread_Metric);

  FParallel := TPas_AI_Parallel.Create;
  FParallel.Prepare_Parallel(FDNN_Face_Detector_Pool.Count);
  FParallel.Prepare_FaceSP;

  FLearn := TPas_AI.Build_Metric_ResNet_Learn;
end;

destructor TFaceRecognitionQueue.Destroy;
begin
  disposeObject(FDNN_Face_Detector_Pool);
  disposeObject(FDNN_Face_Metric_Pool);
  disposeObject(FParallel);
  disposeObject(FLearn);
  inherited Destroy;
end;

procedure TFaceRecognitionQueue.OpenMetricFile(MetricModel: U_String);
var
  i: Integer;
begin
  for i := 0 to FDNN_Face_Metric_Pool.Count - 1 do
      TPas_AI_DNN_Thread_Metric(FDNN_Face_Metric_Pool[i]).Open(MetricModel);
end;

procedure TFaceRecognitionQueue.OpenMetricStream(MetricModel: TMS64);
var
  i: Integer;
begin
  for i := 0 to FDNN_Face_Metric_Pool.Count - 1 do
      TPas_AI_DNN_Thread_Metric(FDNN_Face_Metric_Pool[i]).Open_Stream(MetricModel);
end;

procedure TFaceRecognitionQueue.OpenLearnFile(LearnModel: U_String);
begin
  FLearn.LoadFromFile(LearnModel);
end;

procedure TFaceRecognitionQueue.OpenLearnStream(LearnModel: TMS64);
begin
  FLearn.LoadFromStream(LearnModel);
end;

procedure TFaceRecognitionQueue.Wait;
begin
  FDNN_Face_Detector_Pool.Wait;
  FDNN_Face_Metric_Pool.Wait;
end;

end.
