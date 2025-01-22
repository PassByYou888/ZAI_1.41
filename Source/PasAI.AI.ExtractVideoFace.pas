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
{ * AI extract face in Video                                                   * }
{ ****************************************************************************** }
unit PasAI.AI.ExtractVideoFace;

{$DEFINE FPC_DELPHI_MODE}
{$I PasAI.Define.inc}

interface

uses PasAI.Core, PasAI.PascalStrings, PasAI.UPascalStrings, PasAI.UnicodeMixedLib, PasAI.Status, PasAI.MemoryStream, PasAI.ListEngine,
  PasAI.MemoryRaster, PasAI.Geometry2D,
  PasAI.FFMPEG, PasAI.FFMPEG.Reader,
  PasAI.AI, PasAI.AI.Common, PasAI.AI.FFMPEG;

type
  PDNN_Face_Input_ = ^TDNN_Face_Input_;

  TDNN_Face_Input_ = record
    FaceToken: U_String;
    OutImgL: TPas_AI_ImageList;
  end;

  TPas_AI_ExtractFaceMode = (efmCentre, efmAny);

  TPas_AI_ExtractFaceInVideo = class(TCore_Object_Intermediate)
  private
    FDNN_Pool: TPas_AI_DNN_Thread_Pool;
    FParallel: TPas_AI_Parallel;
    FExtractFaceSize: Integer;
    FExtractPictureWidth, FExtractPictureHeight: Integer;
    FExtractFaceMode: TPas_AI_ExtractFaceMode;
    procedure FaceDetector_OnResult(ThSender: TPas_AI_DNN_Thread_MMOD6L; UserData: Pointer; Input: TMPasAI_Raster; output: TMMOD_Desc);
  public
    constructor CreateCustom(perDeviceThNum: Integer);
    constructor Create;
    destructor Destroy; override;

    procedure ExtractFaceFromFile(inputFile, FaceToken: U_String; MaxFrame: Integer; OutImgL: TPas_AI_ImageList);
    procedure ExtractFaceFromReaderStream(Reader: TFFMPEG_VideoStreamReader; InputStream: TCore_Stream; FaceToken: U_String; MaxFrame: Integer; OutImgL: TPas_AI_ImageList);
    procedure ExtractFaceFromH264Stream(InputStream: TCore_Stream; FaceToken: U_String; MaxFrame: Integer; OutImgL: TPas_AI_ImageList);
    procedure ExtractFaceFromMJPEGStream(InputStream: TCore_Stream; FaceToken: U_String; MaxFrame: Integer; OutImgL: TPas_AI_ImageList);

    property ExtractFaceSize: Integer read FExtractFaceSize write FExtractFaceSize;
    property ExtractPictureWidth: Integer read FExtractPictureWidth write FExtractPictureWidth;
    property ExtractPictureHeight: Integer read FExtractPictureHeight write FExtractPictureHeight;
    property ExtractFaceMode: TPas_AI_ExtractFaceMode read FExtractFaceMode write FExtractFaceMode;
  end;

implementation

procedure TPas_AI_ExtractFaceInVideo.FaceDetector_OnResult(ThSender: TPas_AI_DNN_Thread_MMOD6L; UserData: Pointer; Input: TMPasAI_Raster; output: TMMOD_Desc);
var
  p: PDNN_Face_Input_;
  AI: TPas_AI;
  fHnd: TFace_Handle;
  i, j: Integer;
  cent: Integer;
  img: TPas_AI_Image;
  det: TPas_AI_DetectorDefine;
  sour_r: TRectV2;
  sour_sp: TArrayVec2;
begin
  p := UserData;
  AI := FParallel.GetAndLockAI;
  fHnd := AI.Face_Detector(Input, output, FExtractFaceSize);
  FParallel.UnLockAI(AI);

  case FExtractFaceMode of
    efmCentre:
      begin
        cent := AI.Face_GetCentreRectIndex(Input, fHnd);
        if (cent >= 0) and RectInRect(output[cent].R, Input.BoundsRectV2) then
          begin
            Input.LocalParallel := False;
            img := TPas_AI_Image.Create(p^.OutImgL);
            img.ResetRaster(Input.NonlinearFitScaleAsNew(FExtractPictureWidth, FExtractPictureHeight));
            img.FileInfo := p^.FaceToken;
            sour_r := RectProjection(Input.BoundsRectV2, img.Raster.BoundsRectV2, output[cent].R);
            det := img.DetectorDefineList.AddDetector(Rect2Rect(sour_r), p^.FaceToken);
            det.ResetPrepareRaster(AI.Face_chips(fHnd, cent));

            // projection shape vertex
            sour_sp := AI.Face_ShapeV2(fHnd, cent);
            for j := 0 to length(sour_sp) - 1 do
                det.Part.Add(RectProjection(Input.BoundsRectV2, img.Raster.BoundsRectV2, sour_sp[j]));

            // done
            LockObject(p^.OutImgL);
            p^.OutImgL.Add(img);
            UnLockObject(p^.OutImgL);
          end;
      end;
    efmAny:
      begin
        Input.LocalParallel := False;
        img := TPas_AI_Image.Create(p^.OutImgL);
        img.ResetRaster(Input.NonlinearFitScaleAsNew(FExtractPictureWidth, FExtractPictureHeight));
        img.FileInfo := p^.FaceToken;

        for i := 0 to AI.Face_chips_num(fHnd) - 1 do
          if RectInRect(output[i].R, Input.BoundsRectV2) then
            begin
              sour_r := RectProjection(Input.BoundsRectV2, img.Raster.BoundsRectV2, output[i].R);
              det := img.DetectorDefineList.AddDetector(Rect2Rect(sour_r), p^.FaceToken);
              det.ResetPrepareRaster(AI.Face_chips(fHnd, i));

              // projection shape vertex
              sour_sp := AI.Face_ShapeV2(fHnd, i);
              for j := 0 to length(sour_sp) - 1 do
                  det.Part.Add(RectProjection(Input.BoundsRectV2, img.Raster.BoundsRectV2, sour_sp[j]));
            end;

        if img.DetectorDefineList.Count > 0 then
          begin
            // done
            LockObject(p^.OutImgL);
            p^.OutImgL.Add(img);
            UnLockObject(p^.OutImgL);
          end
        else
            DisposeObject(img);
      end;
  end;
  AI.Face_Close(fHnd);
  Dispose(p);
end;

constructor TPas_AI_ExtractFaceInVideo.CreateCustom(perDeviceThNum: Integer);
var
  i: Integer;
begin
  inherited Create;
  CheckAndReadAIConfig();
  PasAI.AI.Prepare_AI_Engine();
  FDNN_Pool := TPas_AI_DNN_Thread_Pool.Create;
  FDNN_Pool.BuildPerDeviceThread(perDeviceThNum, TPas_AI_DNN_Thread_MMOD6L);
  for i := 0 to FDNN_Pool.Count - 1 do
      TPas_AI_DNN_Thread_MMOD6L(FDNN_Pool[i]).Open_Face;
  FParallel := TPas_AI_Parallel.Create;
  FParallel.Prepare_Parallel(FDNN_Pool.Count);
  FParallel.Prepare_FaceSP;
  FExtractFaceSize := C_Metric_Input_Size;
  FExtractPictureWidth := 300;
  FExtractPictureHeight := 300;
  FExtractFaceMode := efmAny;
  DoStatus();
  FDNN_Pool.Wait;
end;

constructor TPas_AI_ExtractFaceInVideo.Create;
begin
  CreateCustom(2);
end;

destructor TPas_AI_ExtractFaceInVideo.Destroy;
begin
  DisposeObject(FDNN_Pool);
  DisposeObject(FParallel);
  inherited Destroy;
end;

procedure TPas_AI_ExtractFaceInVideo.ExtractFaceFromFile(inputFile, FaceToken: U_String; MaxFrame: Integer; OutImgL: TPas_AI_ImageList);
var
  Reader: TFFMPEG_Reader;
  Raster: TPasAI_Raster;
  th: TPas_AI_DNN_Thread_MMOD6L;
  p: PDNN_Face_Input_;
  oriNum, curNum: Integer;
begin
  try
      Reader := TFFMPEG_Reader.Create(inputFile, False);
  except
      exit;
  end;
  Raster := NewPasAI_Raster();

  oriNum := OutImgL.Count;

  while Reader.ReadFrame(Raster, False) do
    begin
      while FDNN_Pool.TaskNum > FDNN_Pool.Count do
          TCompute.Sleep(1);
      th := TPas_AI_DNN_Thread_MMOD6L(FDNN_Pool.MinLoad_DNN_Thread());
      new(p);
      p^.FaceToken := FaceToken;
      p^.OutImgL := OutImgL;
      th.ProcessM(p, Raster.Clone, True, FaceDetector_OnResult);

      if MaxFrame > 0 then
        begin
          LockObject(OutImgL);
          curNum := OutImgL.Count;
          UnLockObject(OutImgL);
          if curNum - oriNum > MaxFrame then
              break;
        end;
    end;

  DisposeObject(Reader);
  DisposeObject(Raster);
  FDNN_Pool.Wait;
  OutImgL.RemoveOutEdgeDetectorDefine(True, True);
end;

procedure TPas_AI_ExtractFaceInVideo.ExtractFaceFromReaderStream(Reader: TFFMPEG_VideoStreamReader; InputStream: TCore_Stream; FaceToken: U_String; MaxFrame: Integer; OutImgL: TPas_AI_ImageList);
const
  C_Chunk_Buff_Size = 1 * 1024 * 1024;
var
  tempBuff: Pointer;
  chunk: NativeInt;
  L: TMemoryPasAI_RasterList;
  i: Integer;
  p: PDNN_Face_Input_;
  oriNum, curNum: Integer;
begin
  tempBuff := GetMemory(C_Chunk_Buff_Size);
  InputStream.Position := 0;
  oriNum := OutImgL.Count;
  while (InputStream.Position < InputStream.Size) do
    begin
      chunk := umlMin(InputStream.Size - InputStream.Position, C_Chunk_Buff_Size);
      if chunk <= 0 then
          break;
      InputStream.Read(tempBuff^, chunk);
      Reader.WriteBuffer(tempBuff, chunk);

      while FDNN_Pool.TaskNum > FDNN_Pool.Count do
          TCompute.Sleep(1);

      L := Reader.LockVideoPool;
      while L.Count > 0 do
        begin
          new(p);
          p^.FaceToken := FaceToken;
          p^.OutImgL := OutImgL;
          with TPas_AI_DNN_Thread_MMOD6L(FDNN_Pool.MinLoad_DNN_Thread()) do
              ProcessM(p, L.First, True, FaceDetector_OnResult);
          L.Delete(0);
        end;
      Reader.UnLockVideoPool(True);

      if MaxFrame > 0 then
        begin
          LockObject(OutImgL);
          curNum := OutImgL.Count;
          UnLockObject(OutImgL);
          if curNum - oriNum > MaxFrame then
              break;
        end;
    end;
  FreeMemory(tempBuff);
  FDNN_Pool.Wait;
  OutImgL.RemoveOutEdgeDetectorDefine(True, True);
end;

procedure TPas_AI_ExtractFaceInVideo.ExtractFaceFromH264Stream(InputStream: TCore_Stream; FaceToken: U_String; MaxFrame: Integer; OutImgL: TPas_AI_ImageList);
var
  Reader: TFFMPEG_VideoStreamReader;
begin
  Reader := TFFMPEG_VideoStreamReader.Create;
  Reader.OpenH264Decodec;
  ExtractFaceFromReaderStream(Reader, InputStream, FaceToken, MaxFrame, OutImgL);
  DisposeObject(Reader);
end;

procedure TPas_AI_ExtractFaceInVideo.ExtractFaceFromMJPEGStream(InputStream: TCore_Stream; FaceToken: U_String; MaxFrame: Integer; OutImgL: TPas_AI_ImageList);
var
  Reader: TFFMPEG_VideoStreamReader;
begin
  Reader := TFFMPEG_VideoStreamReader.Create;
  Reader.OpenMJPEGDecodec;
  ExtractFaceFromReaderStream(Reader, InputStream, FaceToken, MaxFrame, OutImgL);
  DisposeObject(Reader);
end;

end.
