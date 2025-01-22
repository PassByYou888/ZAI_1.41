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
{ * AI Tech-2022 tracker helper                                                * }
{ ****************************************************************************** }
unit PasAI.AI.Tech2022.Tracker;

{$DEFINE FPC_DELPHI_MODE}
{$I PasAI.Define.inc}

interface

uses Types, Variants,
  PasAI.Core,
  PasAI.PascalStrings, PasAI.UPascalStrings,
  PasAI.MemoryStream, PasAI.UnicodeMixedLib, PasAI.DFE, PasAI.ListEngine, PasAI.TextDataEngine, PasAI.Parsing, PasAI.Notify,
  PasAI.MemoryRaster,
  PasAI.AI.Common, PasAI.AI, PasAI.AI.Tech2022;

type
  TAI_Tracker_Helper_ = class helper for TPas_AI
  public
    { video tracker(cpu) from Matrix, multi tracker from TAI_TECH_2022_DESC }
    function Tracker_Open_Matrix_Multi(parallel_: Boolean; mat_hnd: TMatrix_Image_Handle; const YOLO_Desc: TAI_TECH_2022_DESC): TTracker_Handle_Array; overload;
    function Tracker_Open_Matrix_Multi(parallel_: Boolean; ThNum: Integer; mat_hnd: TMatrix_Image_Handle; const YOLO_Desc: TAI_TECH_2022_DESC): TTracker_Handle_Array; overload;
    procedure Tracker_Update_Matrix_Multi(parallel_: Boolean; hnd: TTracker_Handle_Array; mat_hnd: TMatrix_Image_Handle; var YOLO_Desc: TAI_TECH_2022_DESC); overload;
    procedure Tracker_Update_Matrix_Multi(parallel_: Boolean; ThNum: Integer; hnd: TTracker_Handle_Array; mat_hnd: TMatrix_Image_Handle; var YOLO_Desc: TAI_TECH_2022_DESC); overload;
    { video tracker(cpu) from RGB, multi tracker from TAI_TECH_2022_DESC }
    function Tracker_Open_RGB_Multi(parallel_: Boolean; RGB_Hnd: TRGB_Image_Handle; const YOLO_Desc: TAI_TECH_2022_DESC): TTracker_Handle_Array; overload;
    function Tracker_Open_RGB_Multi(parallel_: Boolean; ThNum: Integer; RGB_Hnd: TRGB_Image_Handle; const YOLO_Desc: TAI_TECH_2022_DESC): TTracker_Handle_Array; overload;
    procedure Tracker_Update_RGB_Multi(parallel_: Boolean; hnd: TTracker_Handle_Array; RGB_Hnd: TRGB_Image_Handle; var YOLO_Desc: TAI_TECH_2022_DESC); overload;
    procedure Tracker_Update_RGB_Multi(parallel_: Boolean; ThNum: Integer; hnd: TTracker_Handle_Array; RGB_Hnd: TRGB_Image_Handle; var YOLO_Desc: TAI_TECH_2022_DESC); overload;
    { video tracker(cpu) from raster, multi tracker from TAI_TECH_2022_DESC }
    function Tracker_Open_Multi(parallel_: Boolean; Raster: TMPasAI_Raster; const YOLO_Desc: TAI_TECH_2022_DESC): TTracker_Handle_Array; overload;
    function Tracker_Open_Multi(parallel_: Boolean; ThNum: Integer; Raster: TMPasAI_Raster; const YOLO_Desc: TAI_TECH_2022_DESC): TTracker_Handle_Array; overload;
    procedure Tracker_Update_Multi(parallel_: Boolean; hnd: TTracker_Handle_Array; Raster: TMPasAI_Raster; var YOLO_Desc: TAI_TECH_2022_DESC); overload;
    procedure Tracker_Update_Multi(parallel_: Boolean; ThNum: Integer; hnd: TTracker_Handle_Array; Raster: TMPasAI_Raster; var YOLO_Desc: TAI_TECH_2022_DESC); overload;
  end;

implementation

function TAI_Tracker_Helper_.Tracker_Open_Matrix_Multi(parallel_: Boolean; mat_hnd: TMatrix_Image_Handle; const YOLO_Desc: TAI_TECH_2022_DESC): TTracker_Handle_Array;
var
  buff: TTracker_Handle_Array;

{$IFDEF FPC}
  procedure Nested_ParallelFor(pass: Integer);
  begin
    buff[pass] := Tracker_Open_Matrix(mat_hnd, YOLO_Desc[pass].R);
  end;
{$ENDIF FPC}


begin
  SetLength(buff, Length(YOLO_Desc));
{$IFDEF FPC}
  FPCParallelFor(AI_Parallel_Count, parallel_, 0, Length(YOLO_Desc) - 1, Nested_ParallelFor);
{$ELSE FPC}
  DelphiParallelFor(AI_Parallel_Count, parallel_, 0, Length(YOLO_Desc) - 1, procedure(pass: Integer)
    begin
      buff[pass] := Tracker_Open_Matrix(mat_hnd, YOLO_Desc[pass].R);
    end);
{$ENDIF FPC}
  Result := buff;
end;

function TAI_Tracker_Helper_.Tracker_Open_Matrix_Multi(parallel_: Boolean; ThNum: Integer; mat_hnd: TMatrix_Image_Handle; const YOLO_Desc: TAI_TECH_2022_DESC): TTracker_Handle_Array;
var
  buff: TTracker_Handle_Array;

{$IFDEF FPC}
  procedure Nested_ParallelFor(pass: Integer);
  begin
    buff[pass] := Tracker_Open_Matrix(mat_hnd, YOLO_Desc[pass].R);
  end;
{$ENDIF FPC}


begin
  SetLength(buff, Length(YOLO_Desc));
{$IFDEF FPC}
  FPCParallelFor(ThNum, parallel_, 0, Length(YOLO_Desc) - 1, Nested_ParallelFor);
{$ELSE FPC}
  DelphiParallelFor(ThNum, parallel_, 0, Length(YOLO_Desc) - 1, procedure(pass: Integer)
    begin
      buff[pass] := Tracker_Open_Matrix(mat_hnd, YOLO_Desc[pass].R);
    end);
{$ENDIF FPC}
  Result := buff;
end;

procedure TAI_Tracker_Helper_.Tracker_Update_Matrix_Multi(parallel_: Boolean; hnd: TTracker_Handle_Array; mat_hnd: TMatrix_Image_Handle; var YOLO_Desc: TAI_TECH_2022_DESC);
var
  buff: TAI_TECH_2022_DESC;
{$IFDEF FPC}
  procedure Nested_ParallelFor(pass: Integer);
  begin
    buff[pass].confidence := Tracker_Update_Matrix(hnd[pass], mat_hnd, buff[pass].R);
  end;
{$ENDIF FPC}


begin
  SetLength(buff, Length(hnd));

{$IFDEF FPC}
  FPCParallelFor(AI_Parallel_Count, parallel_, 0, Length(hnd) - 1, Nested_ParallelFor);
{$ELSE FPC}
  DelphiParallelFor(AI_Parallel_Count, parallel_, 0, Length(hnd) - 1, procedure(pass: Integer)
    begin
      buff[pass].confidence := Tracker_Update_Matrix(hnd[pass], mat_hnd, buff[pass].R);
    end);
{$ENDIF FPC}
  YOLO_Desc := buff;
end;

procedure TAI_Tracker_Helper_.Tracker_Update_Matrix_Multi(parallel_: Boolean; ThNum: Integer; hnd: TTracker_Handle_Array; mat_hnd: TMatrix_Image_Handle; var YOLO_Desc: TAI_TECH_2022_DESC);
var
  buff: TAI_TECH_2022_DESC;
{$IFDEF FPC}
  procedure Nested_ParallelFor(pass: Integer);
  begin
    buff[pass].confidence := Tracker_Update_Matrix(hnd[pass], mat_hnd, buff[pass].R);
  end;
{$ENDIF FPC}


begin
  SetLength(buff, Length(hnd));

{$IFDEF FPC}
  FPCParallelFor(ThNum, parallel_, 0, Length(hnd) - 1, Nested_ParallelFor);
{$ELSE FPC}
  DelphiParallelFor(ThNum, parallel_, 0, Length(hnd) - 1, procedure(pass: Integer)
    begin
      buff[pass].confidence := Tracker_Update_Matrix(hnd[pass], mat_hnd, buff[pass].R);
    end);
{$ENDIF FPC}
  YOLO_Desc := buff;
end;

function TAI_Tracker_Helper_.Tracker_Open_RGB_Multi(parallel_: Boolean; RGB_Hnd: TRGB_Image_Handle; const YOLO_Desc: TAI_TECH_2022_DESC): TTracker_Handle_Array;
var
  buff: TTracker_Handle_Array;

{$IFDEF FPC}
  procedure Nested_ParallelFor(pass: Integer);
  begin
    buff[pass] := Tracker_Open_RGB(RGB_Hnd, YOLO_Desc[pass].R);
  end;
{$ENDIF FPC}


begin
  SetLength(buff, Length(YOLO_Desc));
{$IFDEF FPC}
  FPCParallelFor(AI_Parallel_Count, parallel_, 0, Length(YOLO_Desc) - 1, Nested_ParallelFor);
{$ELSE FPC}
  DelphiParallelFor(AI_Parallel_Count, parallel_, 0, Length(YOLO_Desc) - 1, procedure(pass: Integer)
    begin
      buff[pass] := Tracker_Open_RGB(RGB_Hnd, YOLO_Desc[pass].R);
    end);
{$ENDIF FPC}
  Result := buff;
end;

function TAI_Tracker_Helper_.Tracker_Open_RGB_Multi(parallel_: Boolean; ThNum: Integer; RGB_Hnd: TRGB_Image_Handle; const YOLO_Desc: TAI_TECH_2022_DESC): TTracker_Handle_Array;
var
  buff: TTracker_Handle_Array;

{$IFDEF FPC}
  procedure Nested_ParallelFor(pass: Integer);
  begin
    buff[pass] := Tracker_Open_RGB(RGB_Hnd, YOLO_Desc[pass].R);
  end;
{$ENDIF FPC}


begin
  SetLength(buff, Length(YOLO_Desc));
{$IFDEF FPC}
  FPCParallelFor(ThNum, parallel_, 0, Length(YOLO_Desc) - 1, Nested_ParallelFor);
{$ELSE FPC}
  DelphiParallelFor(ThNum, parallel_, 0, Length(YOLO_Desc) - 1, procedure(pass: Integer)
    begin
      buff[pass] := Tracker_Open_RGB(RGB_Hnd, YOLO_Desc[pass].R);
    end);
{$ENDIF FPC}
  Result := buff;
end;

procedure TAI_Tracker_Helper_.Tracker_Update_RGB_Multi(parallel_: Boolean; hnd: TTracker_Handle_Array; RGB_Hnd: TRGB_Image_Handle; var YOLO_Desc: TAI_TECH_2022_DESC);
var
  buff: TAI_TECH_2022_DESC;
{$IFDEF FPC}
  procedure Nested_ParallelFor(pass: Integer);
  begin
    buff[pass].confidence := Tracker_Update_RGB(hnd[pass], RGB_Hnd, buff[pass].R);
  end;
{$ENDIF FPC}


begin
  SetLength(buff, Length(hnd));

{$IFDEF FPC}
  FPCParallelFor(AI_Parallel_Count, parallel_, 0, Length(hnd) - 1, Nested_ParallelFor);
{$ELSE FPC}
  DelphiParallelFor(AI_Parallel_Count, parallel_, 0, Length(hnd) - 1, procedure(pass: Integer)
    begin
      buff[pass].confidence := Tracker_Update_RGB(hnd[pass], RGB_Hnd, buff[pass].R);
    end);
{$ENDIF FPC}
  YOLO_Desc := buff;
end;

procedure TAI_Tracker_Helper_.Tracker_Update_RGB_Multi(parallel_: Boolean; ThNum: Integer; hnd: TTracker_Handle_Array; RGB_Hnd: TRGB_Image_Handle; var YOLO_Desc: TAI_TECH_2022_DESC);
var
  buff: TAI_TECH_2022_DESC;
{$IFDEF FPC}
  procedure Nested_ParallelFor(pass: Integer);
  begin
    buff[pass].confidence := Tracker_Update_RGB(hnd[pass], RGB_Hnd, buff[pass].R);
  end;
{$ENDIF FPC}


begin
  SetLength(buff, Length(hnd));

{$IFDEF FPC}
  FPCParallelFor(ThNum, parallel_, 0, Length(hnd) - 1, Nested_ParallelFor);
{$ELSE FPC}
  DelphiParallelFor(ThNum, parallel_, 0, Length(hnd) - 1, procedure(pass: Integer)
    begin
      buff[pass].confidence := Tracker_Update_RGB(hnd[pass], RGB_Hnd, buff[pass].R);
    end);
{$ENDIF FPC}
  YOLO_Desc := buff;
end;

function TAI_Tracker_Helper_.Tracker_Open_Multi(parallel_: Boolean; Raster: TMPasAI_Raster; const YOLO_Desc: TAI_TECH_2022_DESC): TTracker_Handle_Array;
var
  RGB_Hnd: TRGB_Image_Handle;
begin
  SetLength(Result, 0);
  if (FAI_EntryAPI = nil) then
      exit;

  RGB_Hnd := Prepare_RGB_Image(Raster);
  if RGB_Hnd = nil then
      exit;
  Result := Tracker_Open_RGB_Multi(parallel_, RGB_Hnd, YOLO_Desc);
  Close_RGB_Image(RGB_Hnd);
end;

function TAI_Tracker_Helper_.Tracker_Open_Multi(parallel_: Boolean; ThNum: Integer; Raster: TMPasAI_Raster; const YOLO_Desc: TAI_TECH_2022_DESC): TTracker_Handle_Array;
var
  RGB_Hnd: TRGB_Image_Handle;
begin
  SetLength(Result, 0);
  if (FAI_EntryAPI = nil) then
      exit;

  RGB_Hnd := Prepare_RGB_Image(Raster);
  if RGB_Hnd = nil then
      exit;
  Result := Tracker_Open_RGB_Multi(parallel_, ThNum, RGB_Hnd, YOLO_Desc);
  Close_RGB_Image(RGB_Hnd);
end;

procedure TAI_Tracker_Helper_.Tracker_Update_Multi(parallel_: Boolean; hnd: TTracker_Handle_Array; Raster: TMPasAI_Raster; var YOLO_Desc: TAI_TECH_2022_DESC);
var
  RGB_Hnd: TRGB_Image_Handle;
begin
  if (FAI_EntryAPI = nil) then
      exit;

  RGB_Hnd := Prepare_RGB_Image(Raster);
  if RGB_Hnd = nil then
      exit;
  Tracker_Update_RGB_Multi(parallel_, hnd, RGB_Hnd, YOLO_Desc);
  Close_RGB_Image(RGB_Hnd);
end;

procedure TAI_Tracker_Helper_.Tracker_Update_Multi(parallel_: Boolean; ThNum: Integer; hnd: TTracker_Handle_Array; Raster: TMPasAI_Raster; var YOLO_Desc: TAI_TECH_2022_DESC);
var
  RGB_Hnd: TRGB_Image_Handle;
begin
  if (FAI_EntryAPI = nil) then
      exit;

  RGB_Hnd := Prepare_RGB_Image(Raster);
  if RGB_Hnd = nil then
      exit;
  Tracker_Update_RGB_Multi(parallel_, ThNum, hnd, RGB_Hnd, YOLO_Desc);
  Close_RGB_Image(RGB_Hnd);
end;

end.
