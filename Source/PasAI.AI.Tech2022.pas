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
{ * AI Tech-2022 (platform: cuda+mkl64+win64+win32)                            * }
{ ****************************************************************************** }
unit PasAI.AI.Tech2022;

{$DEFINE FPC_DELPHI_MODE}
{$I PasAI.Define.inc}

(* AI engine compatible record packing *)
{$IFDEF FPC}
{$PACKENUM 4}    (* use 4-byte enums *)
{$PACKRECORDS C}
{$ELSE}
{$MINENUMSIZE 4} (* use 4-byte enums *)
{$ENDIF}

interface

uses Types, Variants,
  PasAI.Core,
{$IFDEF FPC}
  PasAI.FPC.GenericList,
{$ELSE FPC}
  System.IOUtils,
{$ENDIF FPC}
  PasAI.PascalStrings, PasAI.UPascalStrings,
  PasAI.MemoryStream, PasAI.UnicodeMixedLib, PasAI.DFE, PasAI.ListEngine, PasAI.TextDataEngine, PasAI.Parsing, PasAI.Expression, PasAI.OpCode,
  PasAI.HashList.Templet,
  PasAI.ZDB, PasAI.ZDB.ObjectData_LIB, PasAI.ZDB.ItemStream_LIB,
  PasAI.DrawEngine, PasAI.Geometry2D, PasAI.Geometry3D, PasAI.MemoryRaster, PasAI.Learn.Type_LIB, PasAI.Learn, PasAI.Learn.KDTree, PasAI.Learn.SIFT,
  PasAI.AI.Common, PasAI.AI.TrainingTask;

{$REGION 'Base_Define'}


type
  TPas_AI_TECH_2022 = class;
  TPas_AI_TECH_2022_DNN_Thread = class;
  TPas_AI_TECH_2022_DNN_Thread_DCGAN = class;
  TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2 = class;
  TPas_AI_TECH_2022_DNN_Thread_YOLO_X = class;
  TPas_AI_TECH_2022_DNN_Thread_SSL = class;
  TPas_AI_TECH_2022_DNN_Thread_Class = class of TPas_AI_TECH_2022_DNN_Thread;
  TPas_AI_TECH_2022_DNN_Thread_Pool = class;
  TPas_AI_TECH_2022_DNN_ThreadPool = TPas_AI_TECH_2022_DNN_Thread_Pool;
  PAI_TECH_2022_Core_API = ^TPas_AI_TECH_2022_Core_API;
  TPas_AI_TECH_2022_RGB_Image_Handle = {$IFDEF DELPHI} type of {$ENDIF DELPHI} Pointer;
  TPas_AI_TECH_2022_Matrix_Image_Handle = {$IFDEF DELPHI} type of {$ENDIF DELPHI} Pointer;
  TPas_AI_TECH_2022_DCGAN_Handle = {$IFDEF DELPHI} type of {$ENDIF DELPHI} Pointer;
  TPas_AI_TECH_2022_ZMetric_V2_Handle = {$IFDEF DELPHI} type of {$ENDIF DELPHI} Pointer;
  TPas_AI_TECH_2022_YOLO_X_Handle = {$IFDEF DELPHI} type of {$ENDIF DELPHI} Pointer;
  TPas_AI_TECH_2022_SSL_Handle = {$IFDEF DELPHI} type of {$ENDIF DELPHI} Pointer;

  C_Bytes = packed record
    Size: Integer;
    Bytes: PByte;
  end;

  P_Bytes = ^C_Bytes;

  TPas_AI_TECH_2022_BGRA_Image_Buffer_ = packed record
    Bits: Pointer;
    Width, Height: Integer;
  end;

  PAI_TECH_2022_BGRA_Image_Buffer_ = ^TPas_AI_TECH_2022_BGRA_Image_Buffer_;
  TPas_AI_TECH_2022_BGRA_Buffer_Handle = PAI_TECH_2022_BGRA_Image_Buffer_;

  TPas_AI_TECH_2022_Image_Handle = packed record
    image: TPas_AI_Image;
  end;

  PAI_TECH_2022_Image_Handle = ^TPas_AI_TECH_2022_Image_Handle;
  PPAI_TECH_2022_Image_Handle = ^PAI_TECH_2022_Image_Handle;
  TAI_TECH_2022_Image_Array = array [0 .. (MaxInt div SizeOf(PAI_TECH_2022_Image_Handle)) - 1] of PAI_TECH_2022_Image_Handle;
  PAI_TECH_2022_Image_Array = ^TAI_TECH_2022_Image_Array;

  TPas_AI_TECH_2022_Raster_Handle = packed record
    Raster: TMPasAI_Raster;
  end;

  PAI_TECH_2022_Raster_Handle = ^TPas_AI_TECH_2022_Raster_Handle;

  TPas_AI_TECH_2022_Detector_Define_Handle = packed record
    Detector_Define: TPas_AI_DetectorDefine;
  end;

  PAI_TECH_2022_Detector_Define_Handle = ^TPas_AI_TECH_2022_Detector_Define_Handle;

  TPas_AI_TECH_2022_Detector_Define_Input = packed record
    Data: PAI_TECH_2022_Detector_Define_Handle;
    Index: Integer;
  end;

  PAI_TECH_2022_Point = ^TAI_TECH_2022_Point;

  TAI_TECH_2022_Point = packed record
    X, Y: Integer;
  end;

  PAI_TECH_2022_Rect = ^TAI_TECH_2022_Rect;

  TAI_TECH_2022_Rect = packed record
    Left, Top, Right, Bottom: Integer;
  end;

  PAI_TECH_2022_Detector_Define_Input = ^TPas_AI_TECH_2022_Detector_Define_Input;
  TPas_AI_TECH_2022_Detector_Define_Input_Array = array [0 .. (MaxInt div SizeOf(PAI_TECH_2022_Detector_Define_Input)) - 1] of PAI_TECH_2022_Detector_Define_Input;
  PAI_TECH_2022_Detector_Define_Input_Array = ^TPas_AI_TECH_2022_Detector_Define_Input_Array;

  TPas_AI_TECH_2022_Raster_Data = packed record
    raster_Hnd: PAI_TECH_2022_Raster_Handle;
    raster_ptr: PRColorArray;
    Width, Height, index: Integer;
  end;

  PAI_TECH_2022_Raster_Data = ^TPas_AI_TECH_2022_Raster_Data;
  TPas_AI_TECH_2022_Raster_Data_Array = array [0 .. (MaxInt div SizeOf(PAI_TECH_2022_Raster_Data)) - 1] of PAI_TECH_2022_Raster_Data;
  PAI_TECH_2022_Raster_Data_Array = ^TPas_AI_TECH_2022_Raster_Data_Array;

  PAI_TECH_2022_YOLO_Rect = ^TPas_AI_TECH_2022_YOLO_Rect;

  TPas_AI_TECH_2022_YOLO_Rect = packed record
    Left, Top, Right, Bottom: Integer;
    confidence: Double;
    Token: PPascalString;
  end;

  PAI_TECH_2022_TrainingControl = ^TPas_AI_TECH_2022_TrainingControl;

  TPas_AI_TECH_2022_YOLO_Rect_Array = array of TPas_AI_TECH_2022_YOLO_Rect;

  TAI_TECH_2022_DESC_ = record
    R: TRectV2;
    confidence: Double;
    Token: U_String;
  end;

  PAI_TECH_2022_DESC_ = ^TAI_TECH_2022_DESC_;

  TAI_TECH_2022_DESC = array of TAI_TECH_2022_DESC_;

  TAI_TECH_2022_DESC_PTR_POOL = TBigList<PAI_TECH_2022_DESC_>;
  TAI_TECH_2022_DESC_POOL = TBigList<TAI_TECH_2022_DESC_>;

  TPas_AI_TECH_2022_TrainingControl = packed record
    pause, stop: Integer;
  end;

  TPas_AI_TECH_2022_DCGAN_Train_Parameter = packed record
    { input }
    imgArry_ptr: PAI_TECH_2022_Raster_Data_Array;
    img_num: Integer;
    train_sync_file, train_output: P_Bytes;
    { train param }
    timeout: UInt64;
    rand_seed: Cardinal;
    max_iterations: Cardinal;
    iteration_sync_step: Cardinal;
    learning_rate: Double;
    mini_batch: Cardinal;
    { progress control }
    control: PAI_TECH_2022_TrainingControl;
    { training result }
    training_average_loss, training_learning_rate: Double;
  end;

  PAI_TECH_2022_DCGAN_Train_Parameter = ^TPas_AI_TECH_2022_DCGAN_Train_Parameter;

  TPas_AI_TECH_2022_ZMetric_V2_Train_Parameter = packed record
    { input }
    Detector_Define: PAI_TECH_2022_Detector_Define_Input_Array;
    img_num: Integer;
    train_sync_file, train_output: P_Bytes;
    { training param }
    timeout: UInt64;
    weight_decay, momentum: Double;
    iterations_without_progress_threshold: Integer;
    min_learning_rate, learning_rate, completed_learning_rate: Double;
    step_mini_batch_target_num, step_mini_batch_jitter_num: Integer;
    auto_flip_left_right: Integer;
    jitter_ss_width, jitter_ss_height, jitter_XY_Offset_Scale, jitter_Rotate, jitter_Scale: Double;
    jitter_inner_fit: Integer;
    jitter_thread_num: Integer;
    Max_Data_Queue: Integer;
    { progress control }
    control: PAI_TECH_2022_TrainingControl;
    { training result }
    training_average_loss, training_learning_rate: Double;
  end;

  PAI_TECH_2022_ZMetric_V2_Train_Parameter = ^TPas_AI_TECH_2022_ZMetric_V2_Train_Parameter;

  TPas_AI_TECH_2022_YOLO_X_Train_Parameter = packed record
    { input }
    training_img: PAI_TECH_2022_Image_Array;
    training_img_num: Integer;
    { training param }
    training_sync_file, training_output: P_Bytes;
    timeout: UInt64;
    { net param }
    iou_ignore_threshold: Double;
    iou_anchor_threshold: Double;
    begin_learning_rate, complete_learning_rate: Double;
    iterations_without_progress_threshold: Integer;
    prepare_unstable_step_num: Integer;
    learning_rate_shrink_factor: Double;
    { These are the anchors computed on user custom dataset, presented in the YOLO-X paper. }
    T8_1_X, T8_1_Y, T8_2_X, T8_2_Y, T8_3_X, T8_3_Y: Integer;
    T16_1_X, T16_1_Y, T16_2_X, T16_2_Y, T16_3_X, T16_3_Y: Integer;
    T32_1_X, T32_1_Y, T32_2_X, T32_2_Y, T32_3_X, T32_3_Y: Integer;
    { cropper param }
    batch_size: Integer;
    max_object_size: Double;
    min_object_size_x: Integer;
    min_object_size_y: Integer;
    max_rotation_degrees: Double;
    translate_amount: Double;
    randomly_flip: Integer;
    background_crops_fraction: Double;
    min_object_coverage: Double;
    alternate_between_cropping: Double;
    training_thread_num: Integer;
    max_training_batch_queue_num: Integer;
    { test param }
    test_img: PAI_TECH_2022_Image_Array;
    test_img_num: Integer;
    test_thread_num: Integer;
    max_test_batch_queue_num: Integer;
    test_steps: Integer;
    { progress control }
    control: PAI_TECH_2022_TrainingControl;
    { training result }
    training_average_loss, training_learning_rate: Double;
  end;

  PPas_AI_TECH_2022_YOLO_X_Train_Parameter = ^TPas_AI_TECH_2022_YOLO_X_Train_Parameter;

  { tech-2022 }
  { Barlow Twins: Self-Supervised Learning via Redundancy Reduction" }
  TPas_AI_TECH_2022_SSL_Train_Parameter = packed record
    { training param }
    images: PAI_TECH_2022_Image_Array;
    img_num: Integer;
    training_sync_file, training_output: P_Bytes;
    timeout: UInt64;

    { trainer }
    iterations_without_progress_threshold: Integer;
    min_learning_rate, learning_rate, completed_learning_rate: Double;
    batch_num, dims: Integer;
    lambda: Double;

    { jitter }
    Max_Data_Queue, jitter_thread_num: Integer;
    scale_size_x, scale_size_y, scale_pos_x, scale_pos_y, XY_Offset_Scale, Rotate, Scale, sampling_size_x, sampling_size_y: Double;
    Fit_Matrix_Box, lock_sampler: Integer;

    { transform frequency }
    left_right_flip, disturb_colors, grayscale: Double;

    { progress control }
    control: PAI_TECH_2022_TrainingControl;
    { training result }
    training_average_loss, training_learning_rate: Double;
  end;

  PPas_AI_TECH_2022_SSL_Train_Parameter = ^TPas_AI_TECH_2022_SSL_Train_Parameter;

{$ENDREGION 'Base_Define'}
{$REGION 'TECH2022_Machine_Processor'}

  TPas_AI_TECH_2022_Machine = class(TCore_Object_Intermediate)
  public
    AI: TPas_AI_TECH_2022;
    constructor Create(OwnerAI: TPas_AI_TECH_2022); virtual;
    destructor Destroy; override;
    procedure MachineProcess(imgList: TPas_AI_ImageList); virtual; abstract;
  end;

  TPas_AI_TECH_2022_Machine_ZMetric_V2 = class(TPas_AI_TECH_2022_Machine)
  public
    ZMetricV2Hnd: TPas_AI_TECH_2022_ZMetric_V2_Handle;
    Learn_: TLearn;
    No_Jitter: Boolean; { direct input mode }
    Jitter_Num: Integer; { jitter mode }
    MinK: TLFloat;
    procedure MachineProcess(imgList: TPas_AI_ImageList); override;
  end;

  TPas_AI_TECH_2022_Machine_YOLO_X = class(TPas_AI_TECH_2022_Machine)
  public
    YOLO_X_Hnd: TPas_AI_TECH_2022_YOLO_X_Handle;
    threshold: Double;
    HD_Auto: Boolean;
    procedure MachineProcess(imgList: TPas_AI_ImageList); override;
  end;

{$ENDREGION 'TECH2022_Machine_Processor'}
{$REGION 'API_PTR'}

  TPas_AI_TECH_2022_Core_API = packed record
    { engine support }
    CUDA, MKL: Integer;

    { prepare image }
    Prepare_RGB_Image: function(const raster_ptr: PRColorArray; const Width, Height: Integer): TPas_AI_TECH_2022_RGB_Image_Handle; stdcall;
    Prepare_Matrix_Image: function(const raster_ptr: PRColorArray; const Width, Height: Integer): TPas_AI_TECH_2022_Matrix_Image_Handle; stdcall;
    Close_RGB_Image: procedure(img: TPas_AI_TECH_2022_RGB_Image_Handle); stdcall;
    Close_Matrix_Image: procedure(img: TPas_AI_TECH_2022_Matrix_Image_Handle); stdcall;

    { image buffer }
    OpenImageBuffer_RGB: function(hnd: TPas_AI_TECH_2022_RGB_Image_Handle): TPas_AI_TECH_2022_BGRA_Buffer_Handle; stdcall;
    OpenImageBuffer_Matrix: function(hnd: TPas_AI_TECH_2022_Matrix_Image_Handle): TPas_AI_TECH_2022_BGRA_Buffer_Handle; stdcall;
    CloseImageBuffer: procedure(hnd: TPas_AI_TECH_2022_BGRA_Buffer_Handle); stdcall;

    { tech-2022 DCGAN }
    DCGAN_Train: function(param: PAI_TECH_2022_DCGAN_Train_Parameter): Integer; stdcall;
    DCGAN_Init: function(train_data: P_Bytes): TPas_AI_TECH_2022_DCGAN_Handle; stdcall;
    DCGAN_Init_Memory: function(memory: Pointer; Size: Integer): TPas_AI_TECH_2022_DCGAN_Handle; stdcall;
    DCGAN_Free: function(hnd: TPas_AI_TECH_2022_DCGAN_Handle): Integer; stdcall;
    DCGAN_Process: function(hnd: TPas_AI_TECH_2022_DCGAN_Handle; rand_seed: Int64; var real_: Single): TPas_AI_TECH_2022_BGRA_Buffer_Handle; stdcall;
    DCGAN_Fast_Process: function(hnd: TPas_AI_TECH_2022_DCGAN_Handle; rand_seed: Int64): TPas_AI_TECH_2022_BGRA_Buffer_Handle; stdcall;
    DCGAN_DebugInfo: procedure(hnd: TPas_AI_TECH_2022_DCGAN_Handle; var p: PPascalString); stdcall;

    { tech-2022 Z-Metric V2.0 }
    ZMetric_V2_Full_GPU_Train: function(param: PAI_TECH_2022_ZMetric_V2_Train_Parameter): Integer; stdcall;
    ZMetric_V2_Init: function(train_data: P_Bytes): TPas_AI_TECH_2022_ZMetric_V2_Handle; stdcall;
    ZMetric_V2_Init_Memory: function(memory: Pointer; Size: Integer): TPas_AI_TECH_2022_ZMetric_V2_Handle; stdcall;
    ZMetric_V2_Free: function(hnd: TPas_AI_TECH_2022_ZMetric_V2_Handle): Integer; stdcall;
    ZMetric_V2_Get_Jitter_Value: procedure(hnd: TPas_AI_TECH_2022_ZMetric_V2_Handle;
      var jitter_ss_width, jitter_ss_height, jitter_XY_Offset_Scale, jitter_Rotate, jitter_Scale: Double;
      var jitter_inner_fit: Integer); stdcall;
    ZMetric_V2_Process: function(hnd: TPas_AI_TECH_2022_ZMetric_V2_Handle; imgArry_ptr: PAI_TECH_2022_Raster_Data_Array; img_num: Integer; output: PDouble): Integer; stdcall;
    ZMetric_V2_DebugInfo: procedure(hnd: TPas_AI_TECH_2022_ZMetric_V2_Handle; var p: PPascalString); stdcall;

    { tech-2022 YOLO-X }
    YOLO_X_Train: function(param: PPas_AI_TECH_2022_YOLO_X_Train_Parameter): Integer; stdcall;
    YOLO_X_Init: function(train_data: P_Bytes): TPas_AI_TECH_2022_YOLO_X_Handle; stdcall;
    YOLO_X_Init_Memory: function(memory: Pointer; Size: Integer): TPas_AI_TECH_2022_YOLO_X_Handle; stdcall;
    YOLO_X_Free: function(hnd: TPas_AI_TECH_2022_YOLO_X_Handle): Integer; stdcall;
    YOLO_X_Process_Image: function(hnd: TPas_AI_TECH_2022_YOLO_X_Handle; const raster_ptr: PRColorArray; const Width, Height: Integer;
      const threshold: Double; const YOLO_X_AI_Rect: PAI_TECH_2022_YOLO_Rect; const max_AI_Rect: Integer): Integer; stdcall;
    YOLO_X_DebugInfo: procedure(hnd: TPas_AI_TECH_2022_YOLO_X_Handle; var p: PPascalString); stdcall;

    { tech-2022 SSL }
    { Barlow Twins: Self-Supervised Learning via Redundancy Reduction }
    SSL_Full_GPU_Train: function(param: PPas_AI_TECH_2022_SSL_Train_Parameter): Integer; stdcall;
    SSL_Init: function(train_data: P_Bytes): TPas_AI_TECH_2022_SSL_Handle; stdcall;
    SSL_Init_Memory: function(memory: Pointer; Size: Integer): TPas_AI_TECH_2022_SSL_Handle; stdcall;
    SSL_Free: function(hnd: TPas_AI_TECH_2022_SSL_Handle): Integer; stdcall;
    SSL_Get_Jitter_Value: procedure(hnd: TPas_AI_TECH_2022_SSL_Handle;
      var scale_size_x, scale_size_y, scale_pos_x, scale_pos_y, XY_Offset_Scale, Rotate, Scale, sampling_size_x, sampling_size_y: Double;
      var Fit_Matrix_Box, lock_sampler, batch_num: Integer); stdcall;
    SSL_Process: function(hnd: TPas_AI_TECH_2022_SSL_Handle; imgArry_ptr: Pointer; img_num: Integer; output: PDouble; output_size: Integer): Integer; stdcall;
    SSL_DebugInfo: procedure(hnd: TPas_AI_TECH_2022_SSL_Handle; var p: PPascalString); stdcall;

    { close ai entry }
    CloseAI: procedure(); stdcall;
    { device api }
    SetComputeDeviceOfProcess: function(device_id: Integer): Integer; stdcall;
    GetComputeDeviceOfProcess: function(): Integer; stdcall;
    GetComputeDeviceNumOfProcess: function(): Integer; stdcall;
    GetComputeDeviceNameOfProcess: function(device_id: Integer): Pointer; stdcall;

    { backcall api }
    API_OnOneStep: procedure(Sender: PAI_TECH_2022_Core_API; one_step_calls: UInt64); stdcall;
    API_OnPause: procedure(); stdcall;
    API_Status_Out: procedure(Sender: PAI_TECH_2022_Core_API; i_char: Integer); stdcall;
    API_GetTimeTick64: function(): UInt64; stdcall;
    API_BuildString: function(p: Pointer; Size: Integer): Pointer; stdcall;
    API_FreeString: procedure(p: Pointer); stdcall;
    API_GetRaster: function(hnd: PAI_TECH_2022_Raster_Handle; var Bits: Pointer; var Width, Height: Integer): Byte; stdcall;
    API_GetImage: function(hnd: PAI_TECH_2022_Image_Handle; var Bits: Pointer; var Width, Height: Integer): Byte; stdcall;
    API_RecycleImage: function(Sender: PAI_TECH_2022_Core_API; hnd: PAI_TECH_2022_Image_Handle): Byte; stdcall;
    API_GetImageLabel: function(hnd: PAI_TECH_2022_Image_Handle; var p: P_Bytes): Byte; stdcall;
    API_FreeImageLabel: procedure(var p: P_Bytes); stdcall;
    API_GetImageLabel_ID: function(hnd: PAI_TECH_2022_Image_Handle): Cardinal; stdcall;
    { AI-TECH2022 jitter support }
    API_Jitter: function(
      Sender: PAI_TECH_2022_Core_API;
      DetDef: PAI_TECH_2022_Detector_Define_Handle;
      SS_Raster_Width, SS_Raster_Height, XY_Offset_Scale_, Rotate_, Scale_: Double; inner_fit_: Integer): PAI_TECH_2022_Raster_Handle; stdcall;
    API_Image_Jitter: function(Sender: PAI_TECH_2022_Core_API; img: PAI_TECH_2022_Image_Handle;
      scale_size_x, scale_size_y, scale_pos_x, scale_pos_y, XY_Offset_Scale, Rotate, Scale, sampling_size_x, sampling_size_y: Double;
      Fit_Matrix_Box, lock_sampler: Integer): PAI_TECH_2022_Raster_Handle; stdcall;
    API_RecycleRaster: function(Sender: PAI_TECH_2022_Core_API; hnd: PAI_TECH_2022_Raster_Handle): Byte; stdcall;
    { AI-TECH2022 detector support }
    API_GetDetectorDefineNum: function(hnd: PAI_TECH_2022_Image_Handle): Integer; stdcall;
    API_GetDetectorDefineImage: function(hnd: PAI_TECH_2022_Image_Handle; detIndex: Integer; var Bits: Pointer; var Width, Height: Integer): Byte; stdcall;
    API_GetDetectorDefineRect: function(hnd: PAI_TECH_2022_Image_Handle; detIndex: Integer; var rect_: TAI_TECH_2022_Rect): Byte; stdcall;
    API_GetDetectorDefineLabel: function(hnd: PAI_TECH_2022_Image_Handle; detIndex: Integer; var p: P_Bytes): Byte; stdcall;
    API_FreeDetectorDefineLabel: procedure(var p: P_Bytes); stdcall;
    API_GetDetectorDefinePartNum: function(hnd: PAI_TECH_2022_Image_Handle; detIndex: Integer): Integer; stdcall;
    API_GetDetectorDefinePart: function(hnd: PAI_TECH_2022_Image_Handle; detIndex, partIndex: Integer; var part_: TAI_TECH_2022_Point): Byte; stdcall;

    { version information }
    (*
      1£¬snapshot
      2£¬alpha
      3£¬beta
      4£¬pre
      5£¬RC(Release Candidate)
      6£¬GA(General Availability)
      7£¬release
      8£¬stable
      9£¬current
      10£¬eval
      11£¬Patch
    *)
    MajorVer, MinorVer, VerMode, VerID: Integer;
    { ComputeDeviceOfTraining (cuda/MKL support) }
    ComputeDeviceOfTraining: array [0 .. 64 - 1] of Integer;
    { thread pool }
    ThNum: Integer;

    { internal }
    LibraryFile: SystemString;
    RasterSerialized: TPasAI_RasterSerialized;
    SerializedTime: TTimeTick;
    Swap_Raster_Pool: TMR_Pool;
    Rand: TRandom;
    Critical: TCritical;
    Enabled_Trainer_Warning: Boolean;

    function GetVersionName: TPascalString;
    function GetVersionTitle: TPascalString;
    function GetVersionInfo: TPascalString;
  end;
{$ENDREGION 'API_PTR'}
{$REGION 'Core'}

  TPas_AI_TECH_2022 = class(TCore_Object_Intermediate)
  protected
    FAI_TECH_2022_Entry: PAI_TECH_2022_Core_API;
    TrainingControl: TPas_AI_TECH_2022_TrainingControl;
    Critical: TCritical;
  public
    { root path }
    RootPath: SystemString;
    { deep neural network training state }
    Last_training_average_loss, Last_training_learning_rate: Double;
  public
    { API entry }
    property API: PAI_TECH_2022_Core_API read FAI_TECH_2022_Entry;

    constructor Create;
    class function OpenEngine(libFile: SystemString): TPas_AI_TECH_2022; overload;
    class function OpenEngine(lib_p: PAI_TECH_2022_Core_API): TPas_AI_TECH_2022; overload;
    class function OpenEngine: TPas_AI_TECH_2022; overload;
    destructor Destroy; override;

    { engine activted }
    function Activted: Boolean;

    { GPU supported }
    function isGPU: Boolean;
    { Intel-MKL supported }
    function isMKL: Boolean;

    { set GPU/MKL compute device for Training }
    procedure SetComputeDeviceOfTraining(const Device_: TLIVec);
    procedure GetComputeDeviceOfTraining(var Device_: TLIVec);
    { set GPU/MKL compute device for process }
    function SetComputeDeviceOfProcess(device_id: Integer): Boolean;
    { get current GPU/MKL compute device for process }
    function GetComputeDeviceOfProcess(): Integer; { current compute device }
    { get GPU/MKL compute device number for process }
    function GetComputeDeviceNumOfProcess(): Integer;
    { get GPU/MKL compute device name for process }
    function GetComputeDeviceNameOfProcess(device_id: Integer): U_String;
    function GetComputeDeviceNames(): U_StringArray; overload;
    procedure GetComputeDeviceNames(output: TCore_Strings); overload;

    { atomic ctrl }
    procedure Lock;
    procedure UnLock;
    function Busy: Boolean;

    { training control }
    procedure Training_Stop;
    procedure Training_Pause;
    procedure Training_Continue;
    function Training_IsPause: Boolean;

    { prepare image }
    function Prepare_RGB_Image(Raster: TMPasAI_Raster): TPas_AI_TECH_2022_RGB_Image_Handle;
    procedure Close_RGB_Image(hnd: TPas_AI_TECH_2022_RGB_Image_Handle);
    function Prepare_Matrix_Image(Raster: TMPasAI_Raster): TPas_AI_TECH_2022_Matrix_Image_Handle;
    procedure Close_Matrix_Image(hnd: TPas_AI_TECH_2022_Matrix_Image_Handle);

    { Build-in RGB to Raster }
    procedure BuildRGBRaster(hnd_RGB: TPas_AI_TECH_2022_RGB_Image_Handle; output: TMPasAI_Raster); overload;
    function BuildRGBRaster(hnd_RGB: TPas_AI_TECH_2022_RGB_Image_Handle): TMPasAI_Raster; overload;
    function BuildRGB_Buffer_Raster(hnd_RGB: TPas_AI_TECH_2022_BGRA_Buffer_Handle): TMPasAI_Raster;

    { Build-in Matrix to Raster }
    procedure BuildMatrixRaster(hnd_Matrix: TPas_AI_TECH_2022_Matrix_Image_Handle; output: TMPasAI_Raster); overload;
    function BuildMatrixRaster(hnd_Matrix: TPas_AI_TECH_2022_Matrix_Image_Handle): TMPasAI_Raster; overload;

{$REGION 'DCGAN'}
    { tech-2022 }
    { Unsupervised Representation Learning with Deep Convolutional Generative Adversarial Networks }
    class function Init_DCGAN_DNN_TrainParam(train_sync_file, train_output: U_String): PAI_TECH_2022_DCGAN_Train_Parameter;
    class procedure Free_DCGAN_DNN_TrainParam(param: PAI_TECH_2022_DCGAN_Train_Parameter);
    function DCGAN_DNN_Train(imgList: TMR_2DArray; param: PAI_TECH_2022_DCGAN_Train_Parameter): Integer; overload;
    function DCGAN_DNN_Train(Snapshot_: Boolean; imgList: TPas_AI_ImageList; param: PAI_TECH_2022_DCGAN_Train_Parameter): Integer; overload;
    function DCGAN_DNN_Train(Snapshot_: Boolean; imgMat: TPas_AI_ImageMatrix; param: PAI_TECH_2022_DCGAN_Train_Parameter): Integer; overload;
    function DCGAN_DNN_Train_Stream(Snapshot_: Boolean; imgList: TPas_AI_ImageList; param: PAI_TECH_2022_DCGAN_Train_Parameter): TMS64; overload;
    function DCGAN_DNN_Train_Stream(Snapshot_: Boolean; imgMat: TPas_AI_ImageMatrix; param: PAI_TECH_2022_DCGAN_Train_Parameter): TMS64; overload;
    function DCGAN_DNN_Open(train_file: SystemString): TPas_AI_TECH_2022_DCGAN_Handle;
    function DCGAN_DNN_Open_Stream(stream: TMS64): TPas_AI_TECH_2022_DCGAN_Handle; overload;
    function DCGAN_DNN_Close(var hnd: TPas_AI_TECH_2022_DCGAN_Handle): Boolean;
    function DCGAN_DNN_Process(hnd: TPas_AI_TECH_2022_DCGAN_Handle; rand_seed: Int64; var real_: Single): TMPasAI_Raster; overload;
    function DCGAN_DNN_Process(hnd: TPas_AI_TECH_2022_DCGAN_Handle; rand_seed: Int64): TMPasAI_Raster; overload;
    function DCGAN_DNN_DebugInfo(hnd: TPas_AI_TECH_2022_DCGAN_Handle): U_String;
{$ENDREGION 'DCGAN'}
{$REGION 'ZM2'}
    { tech-2022 }
    { Z-Metric V2.0 }
    { Z-Metric V2.0 training(gpu), extract dim 16 }
    class function Init_ZMetric_V2_Parameter(train_sync_file, train_output: U_String): PAI_TECH_2022_ZMetric_V2_Train_Parameter;
    class procedure Free_ZMetric_V2_Parameter(param: PAI_TECH_2022_ZMetric_V2_Train_Parameter);
    { Z-Metric V2.0 data prototype }
    function ZMetric_V2_Train(LargeScale_: Boolean; RSeri: TPasAI_RasterSerialized; DetDef_Matrix: TMatrix_Detector_Define; param: PAI_TECH_2022_ZMetric_V2_Train_Parameter): Boolean; overload;
    function ZMetric_V2_Train(imgList: TPas_AI_ImageList; param: PAI_TECH_2022_ZMetric_V2_Train_Parameter): Boolean; overload;
    function ZMetric_V2_Train_Stream(imgList: TPas_AI_ImageList; param: PAI_TECH_2022_ZMetric_V2_Train_Parameter): TMS64; overload;
    function ZMetric_V2_Train(imgMat: TPas_AI_ImageMatrix; param: PAI_TECH_2022_ZMetric_V2_Train_Parameter): Boolean; overload;
    function ZMetric_V2_Train_Stream(imgMat: TPas_AI_ImageMatrix; param: PAI_TECH_2022_ZMetric_V2_Train_Parameter): TMS64; overload;
    { Z-Metric V2.0 training(gpu), extract dim 16, input size is user custom, full resnet jitter, include bias, direct input without XML swap dataset. }
    function ZMetric_V2_Train(LargeScale_: Boolean; RSeri: TPasAI_RasterSerialized; imgMat: TPas_AI_ImageMatrix; param: PAI_TECH_2022_ZMetric_V2_Train_Parameter): Boolean; overload;
    function ZMetric_V2_Train_Stream(LargeScale_: Boolean; RSeri: TPasAI_RasterSerialized; imgMat: TPas_AI_ImageMatrix; param: PAI_TECH_2022_ZMetric_V2_Train_Parameter): TMS64; overload;
    { Z-Metric V2.0 api(gpu), extract dim 16, Learn-API }
    class function Build_ZMetric_V2_Learn(): TLearn;
    class function Process_ZMetric_V2_Token(L_: TLearn; Input_: TLVec; Filter_Min_, Filter_Max_: TLFloat; var MinK_: TLFloat): U_String; overload;
    class function Process_ZMetric_V2_Token(L_: TLearn; Input_: TLVec; var MinK_: TLFloat): U_String; overload;
    class function Fast_Process_ZMetric_V2_Token(L_: TLearn; Input_: TLVec; var MinK_: TLFloat): U_String;
    class function Fast_Process_ZMetric_V2_Jitter_Token(L_: TLearn; Input_: TLMatrix; var MinK_: TLFloat): U_String;
    { Z-Metric V2.0 api(gpu), extract dim 16, input size is user custom, full resnet jitter, include bias }
    function ZMetric_V2_Open(train_file: SystemString): TPas_AI_TECH_2022_ZMetric_V2_Handle;
    function ZMetric_V2_Open_Stream(stream: TMS64): TPas_AI_TECH_2022_ZMetric_V2_Handle; overload;
    function ZMetric_V2_Open_Stream(train_file: SystemString): TPas_AI_TECH_2022_ZMetric_V2_Handle; overload;
    function ZMetric_V2_Close(var hnd: TPas_AI_TECH_2022_ZMetric_V2_Handle): Boolean;
    function ZMetric_V2_Get_Jitter_Value(var hnd: TPas_AI_TECH_2022_ZMetric_V2_Handle;
      var ss_width, ss_height, XY_Offset_Scale, Rotate_, Scale_: Double; var inner_fit: Boolean): Boolean;
    { ZMetric_V2_Process result format }
    { result = -2, error }
    { result = -1, model failed. }
    { result > 0, successed. }
    function ZMetric_V2_Process_No_Jitter(hnd: TPas_AI_TECH_2022_ZMetric_V2_Handle; Raster: TPasAI_Raster; output: PDouble): Integer; overload;
    function ZMetric_V2_Process_No_Jitter(hnd: TPas_AI_TECH_2022_ZMetric_V2_Handle; Raster: TPasAI_Raster): TLVec; overload;
    function ZMetric_V2_Process_No_Jitter(hnd: TPas_AI_TECH_2022_ZMetric_V2_Handle; Raster: TPasAI_Raster; Box: TRectV2; output: PDouble): Integer; overload;
    function ZMetric_V2_Process_No_Jitter(hnd: TPas_AI_TECH_2022_ZMetric_V2_Handle; Raster: TPasAI_Raster; Box: TRectV2): TLVec; overload;
    function ZMetric_V2_Process(hnd: TPas_AI_TECH_2022_ZMetric_V2_Handle; Raster: TPasAI_Raster; Box: TRectV2; Jitter_Num: Integer; output: PDouble): Integer; overload;
    function ZMetric_V2_Process(hnd: TPas_AI_TECH_2022_ZMetric_V2_Handle; Raster: TPasAI_Raster; Box: TRectV2; Jitter_Num: Integer): TLMatrix; overload;
    { Z-Metric V2.0 DNN Thread tech }
    procedure ZMetric_V2_Save_To_Learn_DNN_Thread(Jitter: Boolean; Jitter_Num: Integer; Pool_: TPas_AI_TECH_2022_DNN_Thread_Pool; RSeri: TPasAI_RasterSerialized; imgList: TPas_AI_ImageList; L: TLearn); overload;
    procedure ZMetric_V2_Save_To_Learn_DNN_Thread(Jitter: Boolean; Jitter_Num, ThNum: Integer; ZMetric_V2_stream: TMS64; imgList: TPas_AI_ImageList; L: TLearn); overload;
    procedure ZMetric_V2_Save_To_Learn_DNN_Thread(Jitter: Boolean; Jitter_Num, ThNum: Integer; ZMetric_V2_stream: TMS64; imgMat: TPas_AI_ImageMatrix; L: TLearn); overload;
    procedure ZMetric_V2_Save_To_Learn_DNN_Thread(Jitter: Boolean; Jitter_Num, ThNum: Integer; ZMetric_V2_stream: TMS64; RSeri: TPasAI_RasterSerialized; imgMat: TPas_AI_ImageMatrix; L: TLearn); overload;
{$ENDREGION 'ZM2'}
{$REGION 'YOLO-X'}
    { tech-2022 }
    { YOLO-X }
    class function Init_YOLO_X_Parameter(train_sync_file, train_output: U_String): PPas_AI_TECH_2022_YOLO_X_Train_Parameter;
    class procedure Free_YOLO_X_Parameter(param: PPas_AI_TECH_2022_YOLO_X_Train_Parameter);
    function YOLO_X_DNN_Train(param: PPas_AI_TECH_2022_YOLO_X_Train_Parameter; train_imgList, test_imgList: TPas_AI_ImageList): Integer; overload;
    function YOLO_X_DNN_Train(param: PPas_AI_TECH_2022_YOLO_X_Train_Parameter; train_imgMat, test_imgMat: TPas_AI_ImageMatrix): Integer; overload;
    function YOLO_X_DNN_Train(param: PPas_AI_TECH_2022_YOLO_X_Train_Parameter; RSeri: TPasAI_RasterSerialized; train_imgList, test_imgList: TPas_AI_ImageList): Integer; overload;
    function YOLO_X_DNN_Train(param: PPas_AI_TECH_2022_YOLO_X_Train_Parameter; RSeri: TPasAI_RasterSerialized; train_imgMat, test_imgMat: TPas_AI_ImageMatrix): Integer; overload;
    function YOLO_X_DNN_Train_Stream(param: PPas_AI_TECH_2022_YOLO_X_Train_Parameter; train_imgList, test_imgList: TPas_AI_ImageList): TMS64; overload;
    function YOLO_X_DNN_Train_Stream(param: PPas_AI_TECH_2022_YOLO_X_Train_Parameter; train_imgMat, test_imgMat: TPas_AI_ImageMatrix): TMS64; overload;
    function YOLO_X_DNN_Train_Stream(param: PPas_AI_TECH_2022_YOLO_X_Train_Parameter; RSeri: TPasAI_RasterSerialized; train_imgList, test_imgList: TPas_AI_ImageList): TMS64; overload;
    function YOLO_X_DNN_Train_Stream(param: PPas_AI_TECH_2022_YOLO_X_Train_Parameter; RSeri: TPasAI_RasterSerialized; train_imgMat, test_imgMat: TPas_AI_ImageMatrix): TMS64; overload;
    function YOLO_X_Open(train_file: SystemString): TPas_AI_TECH_2022_YOLO_X_Handle;
    function YOLO_X_Open_Stream(stream: TMS64): TPas_AI_TECH_2022_YOLO_X_Handle; overload;
    function YOLO_X_Open_Stream(train_file: SystemString): TPas_AI_TECH_2022_YOLO_X_Handle; overload;
    function YOLO_X_Close(var hnd: TPas_AI_TECH_2022_YOLO_X_Handle): Boolean;
    function YOLO_X_Process(hnd: TPas_AI_TECH_2022_YOLO_X_Handle; Raster: TMPasAI_Raster; threshold: Double; Filter_YOLO_Desc_: Boolean): TAI_TECH_2022_DESC; overload;
    function YOLO_X_Process(hnd: TPas_AI_TECH_2022_YOLO_X_Handle; Raster: TMPasAI_Raster; threshold: Double): TAI_TECH_2022_DESC; overload;
    function YOLO_X_Process_HD_4X(hnd: TPas_AI_TECH_2022_YOLO_X_Handle; Raster: TMPasAI_Raster; threshold, overlap_supression: Double; bilinear_sampling: Boolean): TAI_TECH_2022_DESC;
    function YOLO_X_Process_HD_16X(hnd: TPas_AI_TECH_2022_YOLO_X_Handle; Raster: TMPasAI_Raster; threshold, overlap_supression: Double; bilinear_sampling: Boolean): TAI_TECH_2022_DESC;
    function YOLO_X_Process_HD_Auto(hnd: TPas_AI_TECH_2022_YOLO_X_Handle; Raster: TMPasAI_Raster; threshold: Double): TAI_TECH_2022_DESC;
    function YOLO_X_DebugInfo(hnd: TPas_AI_TECH_2022_YOLO_X_Handle): U_String;
{$ENDREGION 'YOLO-X'}
{$REGION 'SSL'}
    { tech-2022 }
    { Barlow Twins: Self-Supervised Learning via Redundancy Reduction }
    { SSL training(gpu), extract dim 2048 }
    class function Init_SSL_Parameter(train_sync_file, train_output: U_String): PPas_AI_TECH_2022_SSL_Train_Parameter;
    class procedure Free_SSL_Parameter(param: PPas_AI_TECH_2022_SSL_Train_Parameter);
    function SSL_Train(LargeScale_: Boolean; RSeri: TPasAI_RasterSerialized; images: PAI_TECH_2022_Image_Array; img_num: Integer; param: PPas_AI_TECH_2022_SSL_Train_Parameter): Boolean; overload;
    function SSL_Train(LargeScale_: Boolean; RSeri: TPasAI_RasterSerialized; imgMat: TPas_AI_ImageMatrix; param: PPas_AI_TECH_2022_SSL_Train_Parameter): Boolean; overload;
    function SSL_Train(imgList: TPas_AI_ImageList; param: PPas_AI_TECH_2022_SSL_Train_Parameter): Boolean; overload;
    function SSL_Train_Stream(imgList: TPas_AI_ImageList; param: PPas_AI_TECH_2022_SSL_Train_Parameter): TMS64; overload;
    function SSL_Train_Stream(imgMat: TPas_AI_ImageMatrix; param: PPas_AI_TECH_2022_SSL_Train_Parameter): TMS64; overload;
    function SSL_Train_Stream(LargeScale_: Boolean; RSeri: TPasAI_RasterSerialized; imgMat: TPas_AI_ImageMatrix; param: PPas_AI_TECH_2022_SSL_Train_Parameter): TMS64; overload;
    { SSL Learn-API }
    class function Build_SSL_Learn(): TLearn;
    class function Process_SSL_Token(L_: TLearn; Input_: TLVec; Filter_Min_, Filter_Max_: TLFloat; var MinK_: TLFloat): U_String; overload;
    class function Process_SSL_Token(L_: TLearn; Input_: TLVec; var MinK_: TLFloat): U_String; overload;
    class function Fast_Process_SSL_Token(L_: TLearn; Input_: TLVec; var MinK_: TLFloat): U_String; overload;
    class function Fast_Process_SSL_Token(L_: TLearn; Input_: TLMatrix; var MinK_: TLFloat): U_String; overload;
    class function Fast_Process_SSL_Token(L_: TLearn; Input_: TLMatrix; var MinK_: TLFloat; var C: TCandidate_Distance_): U_String; overload;
    { SSL file api }
    function SSL_Open_Face_Classifier(): TPas_AI_TECH_2022_SSL_Handle;
    function SSL_Open_BBC(): TPas_AI_TECH_2022_SSL_Handle;
    function SSL_Open(train_file: SystemString): TPas_AI_TECH_2022_SSL_Handle;
    function SSL_Open_Stream(stream: TMS64): TPas_AI_TECH_2022_SSL_Handle; overload;
    function SSL_Open_Stream(train_file: SystemString): TPas_AI_TECH_2022_SSL_Handle; overload;
    function SSL_Close(var hnd: TPas_AI_TECH_2022_SSL_Handle): Boolean;
    { return model-jitter-value }
    { exp SSL_Get_Jitter_Value(hnd, scale_size, scale_pos, XY_Offset_Scale, Rotate, Scale, sampling_size, Fit_Matrix_Box, lock_sampler, batch_num); }
    function SSL_Get_Jitter_Value(hnd: TPas_AI_TECH_2022_SSL_Handle;
      var scale_size, scale_pos: TVec2; var XY_Offset_Scale, Rotate, Scale: TGeoFloat; var sampling_size: TVec2;
      var Fit_Matrix_Box, lock_sampler: Boolean; var batch_num: Integer): Boolean;
    { SSL process api }
    function SSL_Process(hnd: TPas_AI_TECH_2022_SSL_Handle; arry: TMR_Array; output: PDouble; output_size: Integer): Integer; overload;
    function SSL_Process(hnd: TPas_AI_TECH_2022_SSL_Handle; img: TMPasAI_Raster; jitter_random: Boolean; Jitter_Num: Integer; var output_sampling: TArrayV2R4): TLMatrix; overload;
    function SSL_Process(hnd: TPas_AI_TECH_2022_SSL_Handle; img: TMPasAI_Raster;
      scale_size, scale_pos: TVec2; XY_Offset_Scale, Rotate, Scale: TGeoFloat; sampling_size: TVec2; Fit_Matrix_Box, lock_sampler: Boolean;
      jitter_random: Boolean; Jitter_Num: Integer; var output_sampling: TArrayV2R4): TLMatrix; overload;
    function SSL_DebugInfo(hnd: TPas_AI_TECH_2022_SSL_Handle): U_String;
    { SSL-DNN Thread tech }
    procedure SSL_Save_To_Learn_DNN_Thread(Jitter_Num: Integer; Pool_: TPas_AI_TECH_2022_DNN_Thread_Pool; RSeri: TPasAI_RasterSerialized; imgList: TPas_AI_ImageList; L: TLearn); overload;
    procedure SSL_Save_To_Learn_DNN_Thread(Jitter_Num: Integer; Pool_: TPas_AI_TECH_2022_DNN_Thread_Pool; RSeri: TPasAI_RasterSerialized; imgMat: TPas_AI_ImageMatrix; L: TLearn); overload;
    procedure SSL_Save_To_Learn_DNN_Thread(Jitter_Num, ThNum: Integer; SSL_stream: TMS64; imgList: TPas_AI_ImageList; L: TLearn); overload;
    procedure SSL_Save_To_Learn_DNN_Thread(Jitter_Num, ThNum: Integer; SSL_stream: TMS64; imgMat: TPas_AI_ImageMatrix; L: TLearn); overload;
    procedure SSL_Save_To_Learn_DNN_Thread(Jitter_Num, ThNum: Integer; SSL_stream: TMS64; RSeri: TPasAI_RasterSerialized; imgMat: TPas_AI_ImageMatrix; L: TLearn); overload;
{$ENDREGION 'SSL'}
  end;
{$ENDREGION 'Core'}
{$REGION 'TAI_TECH_2022_DNN_Thread_Pool'}

  TPas_AI_TECH_2022_DNN_Thread_Trigger = record
    p: Pointer;
    ThEvent: TRun_Thread_M;
    class function Init(p_: Pointer; Event_: TRun_Thread_M): TPas_AI_TECH_2022_DNN_Thread_Trigger; static;
  end;

  { event trigger queue }
  TPas_AI_TECH_2022_DNN_Thread_Event_Trigger_Order = TCriticalOrderPtrStruct<TPas_AI_TECH_2022_DNN_Thread_Trigger>;
  { DNN-Thread Pool }
  TAI_TECH_2022_DNN_Thread_Pool_ = TGenericsList<TPas_AI_TECH_2022_DNN_Thread>;
  TPas_AI_TECH_2022_Global_DNN_ThreadPool = TCritical_BigList<TPas_AI_TECH_2022_DNN_Thread_Pool>;

  TPas_AI_TECH_2022_DNN_Thread_Pool = class(TAI_TECH_2022_DNN_Thread_Pool_)
  private
    FGlobal_Queue_Ptr: TPas_AI_TECH_2022_Global_DNN_ThreadPool.PQueueStruct;
    FName: U_String;
    FCritical: TCritical;
    FNext_DNNThreadID: Integer;
    FQueueOptimized: Boolean;
    FLastRasterList: TMemoryPasAI_RasterList;
    { safe state info tech }
    FStateInfo_Th_Runing: Boolean;
    FStateInfo_Th_Busy: Boolean;
    FStateInfo_Th_Update_Time_Interval: TTimeTick;
    FStateInfo_Th_Output: TAtomString;
    procedure Do_StateInfo_Th(ThSender: TCompute);
    function Do_Check_And_Execute_StateInfo_Th: U_String;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Remove(Obj: TPas_AI_TECH_2022_DNN_Thread);
    procedure Delete(Index: Integer);
    procedure Clear;

    { dnn thread for device }
    procedure BuildDeviceThread(AI_LIB_P: PAI_TECH_2022_Core_API; Device_, ThNum_: Integer; class_: TPas_AI_TECH_2022_DNN_Thread_Class); overload;
    procedure BuildDeviceThread(Device_, ThNum_: Integer; class_: TPas_AI_TECH_2022_DNN_Thread_Class); overload;
    { custom device }
    procedure BuildPerDeviceThread(AI_LIB_P: PAI_TECH_2022_Core_API; Device_: TLIVec; ThNum_: Integer; class_: TPas_AI_TECH_2022_DNN_Thread_Class); overload;
    procedure BuildPerDeviceThread(Device_: TLIVec; ThNum_: Integer; class_: TPas_AI_TECH_2022_DNN_Thread_Class); overload;
    procedure BuildPerDeviceThread(Device_: TLIVec; class_: TPas_AI_TECH_2022_DNN_Thread_Class); overload;
    { per device }
    procedure BuildPerDeviceThread(AI_LIB_P: PAI_TECH_2022_Core_API; ThNum_: Integer; class_: TPas_AI_TECH_2022_DNN_Thread_Class); overload;
    procedure BuildPerDeviceThread(ThNum_: Integer; class_: TPas_AI_TECH_2022_DNN_Thread_Class); overload;
    procedure BuildPerDeviceThread(class_: TPas_AI_TECH_2022_DNN_Thread_Class); overload;
    { performance and state for DNN thread }
    function Next_DNN_Thread: TPas_AI_TECH_2022_DNN_Thread;
    function MinLoad_DNN_Thread: TPas_AI_TECH_2022_DNN_Thread;
    function IDLE_DNN_Thread: TPas_AI_TECH_2022_DNN_Thread;
    function GetMinLoad_DNN_Thread_TaskNum: Integer;
    function GetTaskNum: Integer;
    property TaskNum: Integer read GetTaskNum;
    function Busy: Boolean;
    function PSP: TGeoFloat;
    function MaxPSP: TGeoFloat;
    procedure Wait;
    { safe state info tech }
    property StateInfo_Th_Update_Time_Interval: TTimeTick read FStateInfo_Th_Update_Time_Interval write FStateInfo_Th_Update_Time_Interval;
    procedure Close_StateInfo_Th();
    function StateInfo: U_String; overload;
    function StateInfo(const Separator: Boolean): U_String; overload;
    { raster state }
    procedure EnabledLastProcessRaster(value_: Boolean);
    function LockLastRasterList: TMemoryPasAI_RasterList;
    procedure UnLockLastRasterList;
    property QueueOptimized: Boolean read FQueueOptimized write FQueueOptimized;
    property Name: U_String read FName write FName;
  end;

  { AI parallel for GPU/MKL Platform }
  TPas_AI_TECH_2022_DNN_Thread = class(TCore_Object_Intermediate)
  private
    FID: Integer;
    FAI: TPas_AI_TECH_2022;
    FThread: TCompute;
    FDevice: Integer;
    FThreadPost: TThreadPost;
    FActivted: TAtomBool;
    FDNNThreadRuning: TAtomBool;
    FThreadInfo: SystemString;
    FPSP: TGeoFloat;
    FMaxPSP: TGeoFloat;
    FCPUThreadCritical: Integer;
    FGPUPerformanceCritical: Integer;
    FName: SystemString;
    { event thread }
    FEventThreadNum: Integer;
    FEventQueue: TPas_AI_TECH_2022_DNN_Thread_Event_Trigger_Order;
    { process raster state }
    FEnabledLastProcessRaster: Boolean;
    FLastProcessRasterCritical: TCritical;
    FLastProcessRaster: TPasAI_Raster;
    FCustomObject: TCore_Object;
    FCustomData: Pointer;
    procedure Run_DNN_Thread(Sender: TCompute);
    procedure ThreadFree; virtual;
    procedure DoEventDone(ThSender: TCompute);
    procedure DoRunEvent(p: Pointer; ThEvent: TRun_Thread_M);
    function GetTaskNum: Integer;
    procedure UpdateLastProcessRaster(PasAI_Raster_: TPasAI_Raster);
    procedure UpdateLastProcessMatrixRaster(Matrix_IMG: TPas_AI_TECH_2022_Matrix_Image_Handle);
  public
    constructor Create; virtual;
    destructor Destroy; override;
    class function Build(Owner: TPas_AI_TECH_2022_DNN_Thread_Pool; AI_LIB_P: PAI_TECH_2022_Core_API; Device_: Integer; class_: TPas_AI_TECH_2022_DNN_Thread_Class): TPas_AI_TECH_2022_DNN_Thread; overload;
    class function Build(Owner: TPas_AI_TECH_2022_DNN_Thread_Pool; Device_: Integer; class_: TPas_AI_TECH_2022_DNN_Thread_Class): TPas_AI_TECH_2022_DNN_Thread; overload;
    procedure CheckGPUPerformanceCritical; overload;
    function CheckGPUPerformanceCritical(Tick: TTimeTick): Boolean; overload;
    procedure CheckCPUPerformanceCritical; overload;
    function CheckCPUPerformanceCritical(Tick: TTimeTick): Boolean; overload;
    function Input_Is_Wait: Boolean;
    function Input_Is_IDLE: Boolean;
    function Output_Is_Wait: Boolean;
    function Output_Is_IDLE: Boolean;
    function GetCPUAsyncThreadNum: Integer;
    property TaskNum: Integer read GetTaskNum;
    function Busy: Boolean;
    property Device: Integer read FDevice;
    property ID: Integer read FID;
    property AI: TPas_AI_TECH_2022 read FAI;
    property ThreadInfo: SystemString read FThreadInfo;
    property PSP: TGeoFloat read FPSP;
    property MaxPSP: TGeoFloat read FMaxPSP;
    property CPUThreadCritical: Integer read FCPUThreadCritical write FCPUThreadCritical;
    property GPUPerformanceCritical: Integer read FGPUPerformanceCritical write FGPUPerformanceCritical;
    property Name: SystemString read FName write FName;
    function GetAndLockLastProcessRaster: TPasAI_Raster;
    procedure UnLockLastProcessRaster;
    property CustomObject: TCore_Object read FCustomObject write FCustomObject;
    property CustomData: Pointer read FCustomData write FCustomData;
  end;
{$ENDREGION 'TAI_TECH_2022_DNN_Thread_Pool'}
{$REGION 'TAI_TECH_2022_DNN_Thread_DCGAN'}

  TPas_AI_DNN_Thread_DCGAN_Async_Process_C = procedure(ThSender: TPas_AI_TECH_2022_DNN_Thread_DCGAN; UserData: Pointer; Input_rand_seed: Int64; Output_Raster: TMPasAI_Raster);
  TPas_AI_DNN_Thread_DCGAN_Async_Process_M = procedure(ThSender: TPas_AI_TECH_2022_DNN_Thread_DCGAN; UserData: Pointer; Input_rand_seed: Int64; Output_Raster: TMPasAI_Raster) of object;
{$IFDEF FPC}
  TPas_AI_DNN_Thread_DCGAN_Async_Process_P = procedure(ThSender: TPas_AI_TECH_2022_DNN_Thread_DCGAN; UserData: Pointer; Input_rand_seed: Int64; Output_Raster: TMPasAI_Raster) is nested;
{$ELSE FPC}
  TPas_AI_DNN_Thread_DCGAN_Async_Process_P = reference to procedure(ThSender: TPas_AI_TECH_2022_DNN_Thread_DCGAN; UserData: Pointer; Input_rand_seed: Int64; Output_Raster: TMPasAI_Raster);
{$ENDIF FPC}

  TPas_AI_TECH_2022_DNN_Thread_DCGAN = class(TPas_AI_TECH_2022_DNN_Thread)
  private type
    TCMD_SyncProcess = record
      Done: TAtomBool;
      Input_rand_seed: Int64;
      Output_Raster: TMPasAI_Raster;
    end;

    PCMD_SyncProcess = ^TCMD_SyncProcess;

    TCMD_Async_Process = record
      UserData: Pointer;
      Input_rand_seed: Int64;
      FreeOutput: Boolean;
      OnResult_C: TPas_AI_DNN_Thread_DCGAN_Async_Process_C;
      OnResult_M: TPas_AI_DNN_Thread_DCGAN_Async_Process_M;
      OnResult_P: TPas_AI_DNN_Thread_DCGAN_Async_Process_P;
      Output_Raster: TMPasAI_Raster;
    end;

    PCMD_Async_Process = ^TCMD_Async_Process;
  private
    DCGAN_Hnd: TPas_AI_TECH_2022_DCGAN_Handle;
    procedure ThreadFree; override;
    procedure CMD_Open(Data1: Pointer; Data2: TCore_Object; Data3: Variant);
    procedure CMD_Open_Stream(Data1: Pointer; Data2: TCore_Object; Data3: Variant);
    procedure CMD_SyncProcess(Data: Pointer);
    procedure CMD_Async_Process_Result(ThSender: TCompute);
    procedure CMD_Async_Process(Data: Pointer);
  public
    constructor Create; override;
    procedure Open(train_file: SystemString);
    procedure Open_Stream(stream: TMS64);
    function Process(Input_rand_seed: Int64): TMPasAI_Raster;
    procedure ProcessC(UserData: Pointer; Input_rand_seed: Int64; FreeOutput: Boolean; OnResult: TPas_AI_DNN_Thread_DCGAN_Async_Process_C);
    procedure ProcessM(UserData: Pointer; Input_rand_seed: Int64; FreeOutput: Boolean; OnResult: TPas_AI_DNN_Thread_DCGAN_Async_Process_M);
    procedure ProcessP(UserData: Pointer; Input_rand_seed: Int64; FreeOutput: Boolean; OnResult: TPas_AI_DNN_Thread_DCGAN_Async_Process_P);
  end;
{$ENDREGION 'TAI_TECH_2022_DNN_Thread_DCGAN'}
{$REGION 'TAI_TECH_2022_DNN_Thread_ZMetric_V2'}

  TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2_Async_Process_C = procedure(ThSender: TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2; UserData: Pointer; Input: TMPasAI_Raster; Box: TRectV2; output: TLVec);
  TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2_Async_Process_M = procedure(ThSender: TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2; UserData: Pointer; Input: TMPasAI_Raster; Box: TRectV2; output: TLVec) of object;
  TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2_Async_Process_No_Box_C = procedure(ThSender: TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2; UserData: Pointer; Input: TMPasAI_Raster; output: TLVec);
  TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2_Async_Process_No_Box_M = procedure(ThSender: TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2; UserData: Pointer; Input: TMPasAI_Raster; output: TLVec) of object;
  TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2_Async_Process_Jitter_C = procedure(ThSender: TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2; UserData: Pointer; Input: TMPasAI_Raster; Box: TRectV2; output: TLMatrix);
  TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2_Async_Process_Jitter_M = procedure(ThSender: TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2; UserData: Pointer; Input: TMPasAI_Raster; Box: TRectV2; output: TLMatrix) of object;
{$IFDEF FPC}
  TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2_Async_Process_P = procedure(ThSender: TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2; UserData: Pointer; Input: TMPasAI_Raster; Box: TRectV2; output: TLVec) is nested;
  TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2_Async_Process_No_Box_P = procedure(ThSender: TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2; UserData: Pointer; Input: TMPasAI_Raster; output: TLVec) is nested;
  TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2_Async_Process_Jitter_P = procedure(ThSender: TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2; UserData: Pointer; Input: TMPasAI_Raster; Box: TRectV2; output: TLMatrix) is nested;
{$ELSE FPC}
  TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2_Async_Process_P = reference to procedure(ThSender: TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2; UserData: Pointer; Input: TMPasAI_Raster; Box: TRectV2; output: TLVec);
  TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2_Async_Process_No_Box_P = reference to procedure(ThSender: TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2; UserData: Pointer; Input: TMPasAI_Raster; output: TLVec);
  TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2_Async_Process_Jitter_P = reference to procedure(ThSender: TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2; UserData: Pointer; Input: TMPasAI_Raster; Box: TRectV2; output: TLMatrix);
{$ENDIF FPC}

  TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2 = class(TPas_AI_TECH_2022_DNN_Thread)
  private type
    TCMD_Async_Process_No_Jitter = record
      UserData: Pointer;
      Input: TMPasAI_Raster;
      Box: TRectV2;
      FreeInput: Boolean;
      OnResult_C: TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2_Async_Process_C;
      OnResult_M: TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2_Async_Process_M;
      OnResult_P: TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2_Async_Process_P;
      output: TLVec;
    end;

    TCMD_Async_Process_No_Box = record
      UserData: Pointer;
      Input: TMPasAI_Raster;
      FreeInput: Boolean;
      OnResult_C: TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2_Async_Process_No_Box_C;
      OnResult_M: TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2_Async_Process_No_Box_M;
      OnResult_P: TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2_Async_Process_No_Box_P;
      output: TLVec;
    end;

    TCMD_Async_Process_Jitter = record
      UserData: Pointer;
      Input: TMPasAI_Raster;
      Box: TRectV2;
      Jitter_Num: Integer;
      FreeInput: Boolean;
      OnResult_C: TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2_Async_Process_Jitter_C;
      OnResult_M: TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2_Async_Process_Jitter_M;
      OnResult_P: TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2_Async_Process_Jitter_P;
      output: TLMatrix;
    end;

    PCMD_Async_Process_No_Jitter = ^TCMD_Async_Process_No_Jitter;
    PCMD_Async_Process_No_Box = ^TCMD_Async_Process_No_Box;
    PCMD_Async_Process_Jitter = ^TCMD_Async_Process_Jitter;
  private
    ZMetric_V2_Hnd: TPas_AI_TECH_2022_ZMetric_V2_Handle;
    procedure ThreadFree; override;
    procedure CMD_Open(Data1: Pointer; Data2: TCore_Object; Data3: Variant);
    procedure CMD_Open_Stream(Data1: Pointer; Data2: TCore_Object; Data3: Variant);
    procedure CMD_Async_Process_No_Jitter_Result(ThSender: TCompute);
    procedure CMD_Async_Process_No_Jitter(Data: Pointer);
    procedure CMD_Async_Process_No_Box_Result(ThSender: TCompute);
    procedure CMD_Async_Process_No_Box(Data: Pointer);
    procedure CMD_Async_Process_Jitter_Result(ThSender: TCompute);
    procedure CMD_Async_Process_Jitter(Data: Pointer);
  public
    constructor Create; override;
    procedure Open(train_file: SystemString);
    procedure Open_Stream(stream: TMS64);
    procedure Process_No_Jitter_C(UserData: Pointer; Input: TMPasAI_Raster; Box: TRectV2; FreeInput: Boolean; OnResult: TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2_Async_Process_C);
    procedure Process_No_Jitter_M(UserData: Pointer; Input: TMPasAI_Raster; Box: TRectV2; FreeInput: Boolean; OnResult: TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2_Async_Process_M);
    procedure Process_No_Jitter_P(UserData: Pointer; Input: TMPasAI_Raster; Box: TRectV2; FreeInput: Boolean; OnResult: TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2_Async_Process_P);
    procedure Process_No_Box_C(UserData: Pointer; Input: TMPasAI_Raster; FreeInput: Boolean; OnResult: TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2_Async_Process_No_Box_C);
    procedure Process_No_Box_M(UserData: Pointer; Input: TMPasAI_Raster; FreeInput: Boolean; OnResult: TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2_Async_Process_No_Box_M);
    procedure Process_No_Box_P(UserData: Pointer; Input: TMPasAI_Raster; FreeInput: Boolean; OnResult: TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2_Async_Process_No_Box_P);
    procedure Process_Jitter_C(UserData: Pointer; Input: TMPasAI_Raster; Box: TRectV2; Jitter_Num: Integer; FreeInput: Boolean; OnResult: TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2_Async_Process_Jitter_C);
    procedure Process_Jitter_M(UserData: Pointer; Input: TMPasAI_Raster; Box: TRectV2; Jitter_Num: Integer; FreeInput: Boolean; OnResult: TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2_Async_Process_Jitter_M);
    procedure Process_Jitter_P(UserData: Pointer; Input: TMPasAI_Raster; Box: TRectV2; Jitter_Num: Integer; FreeInput: Boolean; OnResult: TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2_Async_Process_Jitter_P);
  end;
{$ENDREGION 'TAI_TECH_2022_DNN_Thread_ZMetric_V2'}
{$REGION 'TAI_TECH_2022_DNN_Thread_YOLO_X'}

  TPas_AI_TECH_2022_DNN_Thread_YOLO_X_Async_Process_C = procedure(ThSender: TPas_AI_TECH_2022_DNN_Thread_YOLO_X; UserData: Pointer; Input: TMPasAI_Raster; threshold: Double; output: TAI_TECH_2022_DESC);
  TPas_AI_TECH_2022_DNN_Thread_YOLO_X_Async_Process_M = procedure(ThSender: TPas_AI_TECH_2022_DNN_Thread_YOLO_X; UserData: Pointer; Input: TMPasAI_Raster; threshold: Double; output: TAI_TECH_2022_DESC) of object;
  TPas_AI_TECH_2022_DNN_Thread_YOLO_X_Async_Process_HD_C = procedure(ThSender: TPas_AI_TECH_2022_DNN_Thread_YOLO_X; UserData: Pointer; Input: TMPasAI_Raster; threshold, overlap_supression: Double; bilinear_sampling: Boolean; output: TAI_TECH_2022_DESC);
  TPas_AI_TECH_2022_DNN_Thread_YOLO_X_Async_Process_HD_M = procedure(ThSender: TPas_AI_TECH_2022_DNN_Thread_YOLO_X; UserData: Pointer; Input: TMPasAI_Raster; threshold, overlap_supression: Double; bilinear_sampling: Boolean; output: TAI_TECH_2022_DESC) of object;
{$IFDEF FPC}
  TPas_AI_TECH_2022_DNN_Thread_YOLO_X_Async_Process_P = procedure(ThSender: TPas_AI_TECH_2022_DNN_Thread_YOLO_X; UserData: Pointer; Input: TMPasAI_Raster; threshold: Double; output: TAI_TECH_2022_DESC) is nested;
  TPas_AI_TECH_2022_DNN_Thread_YOLO_X_Async_Process_HD_P = procedure(ThSender: TPas_AI_TECH_2022_DNN_Thread_YOLO_X; UserData: Pointer; Input: TMPasAI_Raster; threshold, overlap_supression: Double; bilinear_sampling: Boolean; output: TAI_TECH_2022_DESC) is nested;
{$ELSE FPC}
  TPas_AI_TECH_2022_DNN_Thread_YOLO_X_Async_Process_P = reference to procedure(ThSender: TPas_AI_TECH_2022_DNN_Thread_YOLO_X; UserData: Pointer; Input: TMPasAI_Raster; threshold: Double; output: TAI_TECH_2022_DESC);
  TPas_AI_TECH_2022_DNN_Thread_YOLO_X_Async_Process_HD_P = reference to procedure(ThSender: TPas_AI_TECH_2022_DNN_Thread_YOLO_X; UserData: Pointer; Input: TMPasAI_Raster; threshold, overlap_supression: Double; bilinear_sampling: Boolean; output: TAI_TECH_2022_DESC);
{$ENDIF FPC}

  TPas_AI_TECH_2022_DNN_Thread_YOLO_X = class(TPas_AI_TECH_2022_DNN_Thread)
  private type
    TCMD_Async_Process = record
      UserData: Pointer;
      Input: TMPasAI_Raster;
      threshold: Double;
      FreeInput: Boolean;
      OnResult_C: TPas_AI_TECH_2022_DNN_Thread_YOLO_X_Async_Process_C;
      OnResult_M: TPas_AI_TECH_2022_DNN_Thread_YOLO_X_Async_Process_M;
      OnResult_P: TPas_AI_TECH_2022_DNN_Thread_YOLO_X_Async_Process_P;
      output: TAI_TECH_2022_DESC;
    end;

    PCMD_Async_Process = ^TCMD_Async_Process;

    TCMD_Async_Process_HD_Func = (hd4X, hd16X);

    TCMD_Async_Process_HD = record
      HD_Func: TCMD_Async_Process_HD_Func;
      UserData: Pointer;
      Input: TMPasAI_Raster;
      threshold: Double;
      overlap_supression: Double;
      bilinear_sampling: Boolean;
      FreeInput: Boolean;
      OnResult_C: TPas_AI_TECH_2022_DNN_Thread_YOLO_X_Async_Process_HD_C;
      OnResult_M: TPas_AI_TECH_2022_DNN_Thread_YOLO_X_Async_Process_HD_M;
      OnResult_P: TPas_AI_TECH_2022_DNN_Thread_YOLO_X_Async_Process_HD_P;
      output: TAI_TECH_2022_DESC;
    end;

    PCMD_Async_Process_HD = ^TCMD_Async_Process_HD;
  private
    YOLO_X_Hnd: TPas_AI_TECH_2022_YOLO_X_Handle;
    procedure ThreadFree; override;
    procedure CMD_Open(Data1: Pointer; Data2: TCore_Object; Data3: Variant);
    procedure CMD_Open_Stream(Data1: Pointer; Data2: TCore_Object; Data3: Variant);
    procedure CMD_Async_Process_Result(ThSender: TCompute);
    procedure CMD_Async_Process(Data: Pointer);
    procedure CMD_Async_Process_HD_Result(ThSender: TCompute);
    procedure CMD_Async_Process_HD(Data: Pointer);
  public
    constructor Create; override;
    procedure Open(train_file: SystemString);
    procedure Open_Stream(stream: TMS64);
    procedure Process_C(UserData: Pointer; Input: TMPasAI_Raster; threshold: Double; FreeInput: Boolean; OnResult: TPas_AI_TECH_2022_DNN_Thread_YOLO_X_Async_Process_C);
    procedure Process_M(UserData: Pointer; Input: TMPasAI_Raster; threshold: Double; FreeInput: Boolean; OnResult: TPas_AI_TECH_2022_DNN_Thread_YOLO_X_Async_Process_M);
    procedure Process_P(UserData: Pointer; Input: TMPasAI_Raster; threshold: Double; FreeInput: Boolean; OnResult: TPas_AI_TECH_2022_DNN_Thread_YOLO_X_Async_Process_P);
    procedure Process_HD_4X_C(UserData: Pointer; Input: TMPasAI_Raster; threshold, overlap_supression: Double; bilinear_sampling, FreeInput: Boolean; OnResult: TPas_AI_TECH_2022_DNN_Thread_YOLO_X_Async_Process_HD_C);
    procedure Process_HD_4X_M(UserData: Pointer; Input: TMPasAI_Raster; threshold, overlap_supression: Double; bilinear_sampling, FreeInput: Boolean; OnResult: TPas_AI_TECH_2022_DNN_Thread_YOLO_X_Async_Process_HD_M);
    procedure Process_HD_4X_P(UserData: Pointer; Input: TMPasAI_Raster; threshold, overlap_supression: Double; bilinear_sampling, FreeInput: Boolean; OnResult: TPas_AI_TECH_2022_DNN_Thread_YOLO_X_Async_Process_HD_P);
    procedure Process_HD_16X_C(UserData: Pointer; Input: TMPasAI_Raster; threshold, overlap_supression: Double; bilinear_sampling, FreeInput: Boolean; OnResult: TPas_AI_TECH_2022_DNN_Thread_YOLO_X_Async_Process_HD_C);
    procedure Process_HD_16X_M(UserData: Pointer; Input: TMPasAI_Raster; threshold, overlap_supression: Double; bilinear_sampling, FreeInput: Boolean; OnResult: TPas_AI_TECH_2022_DNN_Thread_YOLO_X_Async_Process_HD_M);
    procedure Process_HD_16X_P(UserData: Pointer; Input: TMPasAI_Raster; threshold, overlap_supression: Double; bilinear_sampling, FreeInput: Boolean; OnResult: TPas_AI_TECH_2022_DNN_Thread_YOLO_X_Async_Process_HD_P);
  end;
{$ENDREGION 'TAI_TECH_2022_DNN_Thread_YOLO_X'}
{$REGION 'TAI_TECH_2022_DNN_Thread_SSL'}

  TPas_AI_TECH_2022_DNN_Thread_SSL_Async_Process_C = procedure(ThSender: TPas_AI_TECH_2022_DNN_Thread_SSL; UserData: Pointer; Input: TMPasAI_Raster; jitter_random: Boolean; Jitter_Num: Integer; output_sampling: TArrayV2R4; output: TLMatrix);
  TPas_AI_TECH_2022_DNN_Thread_SSL_Async_Process_M = procedure(ThSender: TPas_AI_TECH_2022_DNN_Thread_SSL; UserData: Pointer; Input: TMPasAI_Raster; jitter_random: Boolean; Jitter_Num: Integer; output_sampling: TArrayV2R4; output: TLMatrix) of object;
{$IFDEF FPC}
  TPas_AI_TECH_2022_DNN_Thread_SSL_Async_Process_P = procedure(ThSender: TPas_AI_TECH_2022_DNN_Thread_SSL; UserData: Pointer; Input: TMPasAI_Raster; jitter_random: Boolean; Jitter_Num: Integer; output_sampling: TArrayV2R4; output: TLMatrix) is nested;
{$ELSE FPC}
  TPas_AI_TECH_2022_DNN_Thread_SSL_Async_Process_P = reference to procedure(ThSender: TPas_AI_TECH_2022_DNN_Thread_SSL; UserData: Pointer; Input: TMPasAI_Raster; jitter_random: Boolean; Jitter_Num: Integer; output_sampling: TArrayV2R4; output: TLMatrix);
{$ENDIF FPC}

  TPas_AI_TECH_2022_DNN_Thread_SSL = class(TPas_AI_TECH_2022_DNN_Thread)
  private type
    TCMD_Async_Process = record
      UserData: Pointer;
      Input: TMPasAI_Raster;
      jitter_random: Boolean;
      Jitter_Num: Integer;
      FreeInput: Boolean;
      OnResult_C: TPas_AI_TECH_2022_DNN_Thread_SSL_Async_Process_C;
      OnResult_M: TPas_AI_TECH_2022_DNN_Thread_SSL_Async_Process_M;
      OnResult_P: TPas_AI_TECH_2022_DNN_Thread_SSL_Async_Process_P;
      output_sampling: TArrayV2R4;
      output: TLMatrix;
    end;

    PCMD_Async_Process = ^TCMD_Async_Process;

  private
    SSL_Hnd: TPas_AI_TECH_2022_SSL_Handle;
    procedure ThreadFree; override;
    procedure CMD_Open_Face_Classifier();
    procedure CMD_Open_BBC();
    procedure CMD_Open(Data1: Pointer; Data2: TCore_Object; Data3: Variant);
    procedure CMD_Open_Stream(Data1: Pointer; Data2: TCore_Object; Data3: Variant);
    procedure CMD_Async_Process_Result(ThSender: TCompute);
    procedure CMD_Async_Process(Data: Pointer);
  public
    constructor Create; override;
    procedure Open_Face_Classifier;
    procedure Open_BBC;
    procedure Open(train_file: SystemString);
    procedure Open_Stream(stream: TMS64);
    procedure Process_C(UserData: Pointer; Input: TMPasAI_Raster; jitter_random: Boolean; Jitter_Num: Integer; FreeInput: Boolean; OnResult: TPas_AI_TECH_2022_DNN_Thread_SSL_Async_Process_C);
    procedure Process_M(UserData: Pointer; Input: TMPasAI_Raster; jitter_random: Boolean; Jitter_Num: Integer; FreeInput: Boolean; OnResult: TPas_AI_TECH_2022_DNN_Thread_SSL_Async_Process_M);
    procedure Process_P(UserData: Pointer; Input: TMPasAI_Raster; jitter_random: Boolean; Jitter_Num: Integer; FreeInput: Boolean; OnResult: TPas_AI_TECH_2022_DNN_Thread_SSL_Async_Process_P);
  end;
{$ENDREGION 'TAI_TECH_2022_DNN_Thread_SSL'}
{$REGION 'Engine-API'}


function AI_TECH_2022_Alloc_P_Bytes(const buff: U_String): P_Bytes; overload;
function AI_TECH_2022_Alloc_P_Bytes_FromBuff(const buff: TBytes): P_Bytes; overload;
procedure AI_TECH_2022_Free_P_Bytes(const buff: P_Bytes);
function AI_TECH_2022_Get_P_Bytes_String(const buff: P_Bytes): U_String;
function AI_TECH_2022_Point(const V: TVec2): TAI_TECH_2022_Point;
function AI_TECH_2022_RectV2(const V: TAI_TECH_2022_Rect): TRectV2; overload;
function AI_TECH_2022_RectV2(const V: TPas_AI_TECH_2022_YOLO_Rect): TRectV2; overload;
function AI_TECH_2022_RectV2(const V: TAI_TECH_2022_DESC_): TRectV2; overload;

function Check_AI_Engine_TECH_2022(libFile: SystemString): Boolean;
function Load_AI_Engine_TECH_2022(libFile: SystemString): PAI_TECH_2022_Core_API;
function Prepare_AI_Engine_TECH_2022(eng: SystemString): PAI_TECH_2022_Core_API; overload;
function Prepare_AI_Engine_TECH_2022_IsReady: Boolean;
function Prepare_AI_Engine_TECH_2022: PAI_TECH_2022_Core_API; overload;
procedure Close_AI_Engine_TECH_2022;
{$ENDREGION 'Engine-API'}
{$REGION 'Backcall-API'}
procedure API_AI_TECH_2022_OnOneStep(Sender: PAI_TECH_2022_Core_API; one_step_calls: UInt64); stdcall;
procedure API_AI_TECH_2022_OnPause(); stdcall;
procedure API_AI_TECH_2022_StatusIO_Out(Sender: PAI_TECH_2022_Core_API; i_char: Integer); stdcall;
function API_AI_TECH_2022_GetTimeTick64(): UInt64; stdcall;
function API_AI_TECH_2022_BuildString(p: Pointer; Size: Integer): Pointer; stdcall;
procedure API_AI_TECH_2022_FreeString(p: Pointer); stdcall;
function API_AI_TECH_2022_GetRaster(hnd: PAI_TECH_2022_Raster_Handle; var Bits: Pointer; var Width, Height: Integer): Byte; stdcall;
function API_AI_TECH_2022_GetImage(hnd: PAI_TECH_2022_Image_Handle; var Bits: Pointer; var Width, Height: Integer): Byte; stdcall;
function API_AI_TECH_2022_RecycleImage(Sender: PAI_TECH_2022_Core_API; hnd: PAI_TECH_2022_Image_Handle): Byte; stdcall;
function API_AI_TECH_2022_GetImageLabel(hnd: PAI_TECH_2022_Image_Handle; var p: P_Bytes): Byte; stdcall;
procedure API_AI_TECH_2022_FreeImageLabel(var p: P_Bytes); stdcall;
function API_AI_TECH_2022_GetImageLabel_ID(hnd: PAI_TECH_2022_Image_Handle): Cardinal; stdcall;
{ AI-TECH2022 jitter support }
function API_AI_TECH_2022_Jitter(
  Sender: PAI_TECH_2022_Core_API;
  DetDef: PAI_TECH_2022_Detector_Define_Handle;
  SS_Raster_Width, SS_Raster_Height, XY_Offset_Scale_, Rotate_, Scale_: Double; inner_fit_: Integer): PAI_TECH_2022_Raster_Handle; stdcall;
{ AI-TECH2022 image jiter support }
function API_AI_TECH_2022_Image_Jitter(Sender: PAI_TECH_2022_Core_API; img: PAI_TECH_2022_Image_Handle;
  scale_size_x, scale_size_y, scale_pos_x, scale_pos_y, XY_Offset_Scale, Rotate, Scale, sampling_size_x, sampling_size_y: Double;
  Fit_Matrix_Box, lock_sampler: Integer): PAI_TECH_2022_Raster_Handle; stdcall;
{ jitter memory recycle }
function API_AI_TECH_2022_RecycleRaster(Sender: PAI_TECH_2022_Core_API; hnd: PAI_TECH_2022_Raster_Handle): Byte; stdcall;
{ AI-TECH2022 detector support }
function API_AI_TECH_2022_GetDetectorDefineNum(hnd: PAI_TECH_2022_Image_Handle): Integer; stdcall;
function API_AI_TECH_2022_GetDetectorDefineImage(hnd: PAI_TECH_2022_Image_Handle; detIndex: Integer; var Bits: Pointer; var Width, Height: Integer): Byte; stdcall;
function API_AI_TECH_2022_GetDetectorDefineRect(hnd: PAI_TECH_2022_Image_Handle; detIndex: Integer; var rect_: TAI_TECH_2022_Rect): Byte; stdcall;
function API_AI_TECH_2022_GetDetectorDefineLabel(hnd: PAI_TECH_2022_Image_Handle; detIndex: Integer; var p: P_Bytes): Byte; stdcall;
procedure API_AI_TECH_2022_FreeDetectorDefineLabel(var p: P_Bytes); stdcall;
function API_AI_TECH_2022_GetDetectorDefinePartNum(hnd: PAI_TECH_2022_Image_Handle; detIndex: Integer): Integer; stdcall;
function API_AI_TECH_2022_GetDetectorDefinePart(hnd: PAI_TECH_2022_Image_Handle; detIndex, partIndex: Integer; var part_: TAI_TECH_2022_Point): Byte; stdcall;

{ ZM2-Save Learn }
type
  TZMetric_V2_SaveToLearnEngine_DT_UserData_ = record
    L: TLearn;
    DetDef: TPas_AI_DetectorDefine;
  end;

  PZMetric_V2_SaveToLearnEngine_DT_UserData_ = ^TZMetric_V2_SaveToLearnEngine_DT_UserData_;

procedure ZMetric_V2_No_Box_Save_To_Learn_Engine_DNN_Thread_Backcall(ThSender: TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2; UserData: Pointer; Input: TMPasAI_Raster; output: TLVec);
procedure ZMetric_V2_No_Jitter_Save_To_Learn_Engine_DNN_Thread_Backcall(ThSender: TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2; UserData: Pointer; Input: TMPasAI_Raster; Box: TRectV2; output: TLVec);
procedure ZMetric_V2_Jitter_Save_To_Learn_Engine_DNN_Thread_Backcall(ThSender: TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2; UserData: Pointer; Input: TMPasAI_Raster; Box: TRectV2; output: TLMatrix);

{ SSL Learn }
type
  TSSL_SaveToLearnEngine_DT_UserData_ = record
    L: TLearn;
    img: TPas_AI_Image;
  end;

  PSSL_SaveToLearnEngine_DT_UserData_ = ^TSSL_SaveToLearnEngine_DT_UserData_;

procedure SSL_Save_To_Learn_Engine_DNN_Thread_Backcall(ThSender: TPas_AI_TECH_2022_DNN_Thread_SSL; UserData: Pointer; Input: TMPasAI_Raster; jitter_random: Boolean; Jitter_Num: Integer; output_sampling: TArrayV2R4; output: TLMatrix);

{$ENDREGION 'Backcall-API'}
{$REGION 'Trainer-API'}
{ normal training parameter }
function Get_Output_Info(const output_info: SystemString): SystemString;
procedure Build_Normal_Training_Param_DCGAN(output: TCore_Strings; const output_info: SystemString = '');
procedure Build_Normal_Training_Param_ZMetric_V2(output: TCore_Strings; const output_info: SystemString = '');
procedure Build_Normal_Training_Param_YOLO_X(output: TCore_Strings; const output_info: SystemString); overload;
procedure Build_Normal_Training_Param_YOLO_X(output: TCore_Strings; const output_info, T8, T16, T32: SystemString); overload;
procedure Build_Normal_Training_Param_YOLO_X(output: TCore_Strings); overload;
procedure Build_Normal_Training_Param_SSL(output: TCore_Strings; const output_info: SystemString = '');

{ large-scale training parameter }
procedure Build_Large_Scale_Training_Param_ZMetric_V2(output: TCore_Strings);
procedure Build_Large_Scale_Training_Param_YOLO_X(output: TCore_Strings);
procedure Build_Large_Scale_Training_Param_SSL(output: TCore_Strings);

{ check training }
function Is_AI_TECH_2022_Engine_Training_Task(const Task_File, paramFile: SystemString): Boolean;

{ normal training task }
function AI_TECH_2022_RunTrainingTask(Task: TPas_AI_TrainingTask; const AI: TPas_AI_TECH_2022; const paramFile: SystemString): Boolean;

{ large-scale training task }
function AI_TECH_2022_RunLargeScaleTrainingTask(
  ImgMatDatasetFile, RasterSerializedFile, Training_RasterSerializedFile, SyncFile, OutputModel: U_String;
  AI: TPas_AI_TECH_2022; param: THashVariantList): Boolean;

{$ENDREGION 'Trainer-API'}
{$REGION 'Misc-API'}
procedure Filter_YOLO_Desc(var desc: TAI_TECH_2022_DESC);
{$ENDREGION 'Misc-API'}


const
  { core parameter }
  C_DCGAN_Box_Size: Integer = 28;
  C_ZMetric_V2_Dim: Integer = 16;
  C_SSL_Dim: Integer = 2048;

var
  AI_TECH_2022_Global_DNN_ThreadPool: TPas_AI_TECH_2022_Global_DNN_ThreadPool;
  AI_TECH_2022_Large_Scale_Training_Memory_Recycle_Time: TTimeTick;
  AI_TECH_2022_Recycle_Swap_Pool_Time: TTimeTick;
  On_Prepare_AI_Engine_TECH_2022: procedure();
  On_Wait_AI_Init: procedure();
  { build-in SSL for face }
  build_in_SSL_Face_Classifier_memory: Pointer;
  build_in_SSL_Face_Classifier_memory_Siz: Int64;
  { build-in SSL for BBC }
  build_in_SSL_BBC_memory: Pointer;
  build_in_SSL_BBC_memory_Siz: Int64;

implementation

uses PasAI.Status;

type
  TPas_AI_TECH_2022_Entry_Cache_Pool = TString_Big_Hash_Pair_Pool<Pointer>;

var
  AI_TECH_2022_Entry_Cache: TPas_AI_TECH_2022_Entry_Cache_Pool;
  AI_TECH_2022_Status_Critical: TCritical;
  AI_TECH_2022_Status_Buffer: TMS64;

procedure Init_AI_TECH_2022_BuildIn;
begin
  AI_TECH_2022_Status_Critical := TCritical.Create;
  AI_TECH_2022_Entry_Cache := TPas_AI_TECH_2022_Entry_Cache_Pool.Create(128, nil);
  AI_TECH_2022_Status_Buffer := TMS64.CustomCreate(8192);
end;

procedure Free_AI_TECH_2022_BuildIn;
begin
  Close_AI_Engine_TECH_2022;
  DisposeObject(AI_TECH_2022_Entry_Cache);
  DisposeObject(AI_TECH_2022_Status_Buffer);
  DisposeObject(AI_TECH_2022_Status_Critical);
end;

constructor TPas_AI_TECH_2022_Machine.Create(OwnerAI: TPas_AI_TECH_2022);
begin
  inherited Create;
  AI := OwnerAI;
end;

destructor TPas_AI_TECH_2022_Machine.Destroy;
begin
  inherited Destroy;
end;

procedure TPas_AI_TECH_2022_Machine_ZMetric_V2.MachineProcess(imgList: TPas_AI_ImageList);
var
  i, j: Integer;
  img: TPas_AI_Image;
  DetDef: TPas_AI_DetectorDefine;
  R_Vec: TLVec;
  R_Mat: TLMatrix;
  d: TLFloat;
  n: U_String;
begin
  if ZMetricV2Hnd = nil then
      exit;
  if Learn_ = nil then
      exit;

  for i := 0 to imgList.Count - 1 do
    begin
      img := imgList[i];
      for j := 0 to img.DetectorDefineList.Count - 1 do
        begin
          DetDef := img.DetectorDefineList[j];

          if No_Jitter then
            begin
              R_Vec := AI.ZMetric_V2_Process_No_Jitter(ZMetricV2Hnd, DetDef.Owner.Raster, RectV2(DetDef.R));
              n := TPas_AI_TECH_2022.Fast_Process_ZMetric_V2_Token(Learn_, R_Vec, d);
              if d < MinK then
                  DetDef.Token := n;
              SetLength(R_Vec, 0);
            end
          else
            begin
              R_Mat := AI.ZMetric_V2_Process(ZMetricV2Hnd, DetDef.Owner.Raster, RectV2(DetDef.R), Jitter_Num);
              n := TPas_AI_TECH_2022.Fast_Process_ZMetric_V2_Jitter_Token(Learn_, R_Mat, d);
              if d < MinK then
                  DetDef.Token := n;
              SetLength(R_Mat, 0, 0);
            end;

        end;
    end;
end;

procedure TPas_AI_TECH_2022_Machine_YOLO_X.MachineProcess(imgList: TPas_AI_ImageList);
var
  i, j: Integer;
  img: TPas_AI_Image;
  DetDef: TPas_AI_DetectorDefine;
  desc: TAI_TECH_2022_DESC;
begin
  if YOLO_X_Hnd = nil then
      exit;
  for i := 0 to imgList.Count - 1 do
    begin
      img := imgList[i];
      if HD_Auto then
          desc := AI.YOLO_X_Process_HD_Auto(YOLO_X_Hnd, img.Raster, threshold)
      else
          desc := AI.YOLO_X_Process(YOLO_X_Hnd, img.Raster, threshold);

      { remove overlap detector }
      for j := 0 to Length(desc) - 1 do
          img.RemoveDetectorFromRect(desc[j].R);

      { make detector }
      for j := 0 to Length(desc) - 1 do
        begin
          DetDef := TPas_AI_DetectorDefine.Create(img);
          DetDef.R := MakeRect(desc[j].R);
          DetDef.Token := desc[j].Token;
          img.DetectorDefineList.Add(DetDef);
        end;
    end;
end;

function TPas_AI_TECH_2022_Core_API.GetVersionName: TPascalString;
begin
  case VerMode of
    1: Result := 'Snapshot';
    2: Result := 'Alpha';
    3: Result := 'Beta';
    4: Result := 'Pre';
    5: Result := 'RC';
    6: Result := 'GA';
    7: Result := 'Release';
    8: Result := 'Stable';
    9: Result := 'Current';
    10: Result := 'Eval';
    11: Result := 'Patch';
    else Result := '';
  end;
end;

function TPas_AI_TECH_2022_Core_API.GetVersionTitle: TPascalString;
begin
  if VerMode in [7, 8] then
      Result := PFormat('%d.%d %s ' + C_Edition_Update_Info, [MajorVer, MinorVer, GetVersionName().Text])
  else
      Result := PFormat('%d.%d %s %d ' + C_Edition_Update_Info, [MajorVer, MinorVer, GetVersionName().Text, VerID]);
end;

function TPas_AI_TECH_2022_Core_API.GetVersionInfo: TPascalString;
begin
  Result := 'AI Tech-2022 Version: ' + GetVersionTitle().Text + #13#10;
  Result.Append('AI Tech-2022 Engine: %s' + #13#10, [LibraryFile]);
  Result.Append('AI Tech-2022 CUDA: ' + if_(CUDA = 1, 'YES', 'NO') + #13#10);
  Result.Append('AI Tech-2022 Intel-MKL: ' + if_(MKL = 1, 'YES', 'NO'));
end;

constructor TPas_AI_TECH_2022.Create;
begin
  inherited Create;
  FAI_TECH_2022_Entry := nil;
  TrainingControl.pause := 0;
  TrainingControl.stop := 0;
  Critical := TCritical.Create;

  RootPath := GetAITempDirectory();

  Last_training_average_loss := 0;
  Last_training_learning_rate := 0;
end;

class function TPas_AI_TECH_2022.OpenEngine(libFile: SystemString): TPas_AI_TECH_2022;
begin
  Result := TPas_AI_TECH_2022.Create;
  Result.FAI_TECH_2022_Entry := Load_AI_Engine_TECH_2022(libFile);
  if Result.FAI_TECH_2022_Entry = nil then
      Result.FAI_TECH_2022_Entry := Load_AI_Engine_TECH_2022(AI_Engine_Tech2022_Library);
end;

class function TPas_AI_TECH_2022.OpenEngine(lib_p: PAI_TECH_2022_Core_API): TPas_AI_TECH_2022;
begin
  Result := TPas_AI_TECH_2022.Create;
  Result.FAI_TECH_2022_Entry := lib_p;
end;

class function TPas_AI_TECH_2022.OpenEngine: TPas_AI_TECH_2022;
begin
  Result := TPas_AI_TECH_2022.Create;
  Result.FAI_TECH_2022_Entry := Load_AI_Engine_TECH_2022(AI_Engine_Tech2022_Library);
end;

destructor TPas_AI_TECH_2022.Destroy;
begin
  DisposeObject(Critical);
  inherited Destroy;
end;

function TPas_AI_TECH_2022.Activted: Boolean;
begin
  Result := FAI_TECH_2022_Entry <> nil;
end;

function TPas_AI_TECH_2022.isGPU: Boolean;
begin
  Result := (FAI_TECH_2022_Entry <> nil) and (FAI_TECH_2022_Entry^.CUDA = 1);
end;

function TPas_AI_TECH_2022.isMKL: Boolean;
begin
  Result := (FAI_TECH_2022_Entry <> nil) and (FAI_TECH_2022_Entry^.MKL = 1);
end;

procedure TPas_AI_TECH_2022.SetComputeDeviceOfTraining(const Device_: TLIVec);
var
  i: Integer;
begin
  if (FAI_TECH_2022_Entry = nil) then
      exit;
  for i := Low(FAI_TECH_2022_Entry^.ComputeDeviceOfTraining) to High(FAI_TECH_2022_Entry^.ComputeDeviceOfTraining) do
      FAI_TECH_2022_Entry^.ComputeDeviceOfTraining[i] := -1;
  try
    for i := Low(FAI_TECH_2022_Entry^.ComputeDeviceOfTraining) to umlMin(High(Device_), High(FAI_TECH_2022_Entry^.ComputeDeviceOfTraining)) do
      begin
        FAI_TECH_2022_Entry^.ComputeDeviceOfTraining[i] := Device_[i];
        if isGPU then
            DoStatus('Activted GPU Device: %d - "%s"', [Device_[i], GetComputeDeviceNameOfProcess(Device_[i]).Text])
        else
            DoStatus('Activted Compute Device [%d]', [Device_[i]]);
      end;
  except
  end;
end;

procedure TPas_AI_TECH_2022.GetComputeDeviceOfTraining(var Device_: TLIVec);
var
  L: TInt32List;
  i: Integer;
begin
  L := TInt32List.Create;
  for i := Low(FAI_TECH_2022_Entry^.ComputeDeviceOfTraining) to High(FAI_TECH_2022_Entry^.ComputeDeviceOfTraining) do
    if FAI_TECH_2022_Entry^.ComputeDeviceOfTraining[i] >= 0 then
        L.Add(FAI_TECH_2022_Entry^.ComputeDeviceOfTraining[i]);
  SetLength(Device_, L.Count);
  for i := 0 to L.Count - 1 do
      Device_[i] := L[i];
  DisposeObject(L);
end;

function TPas_AI_TECH_2022.SetComputeDeviceOfProcess(device_id: Integer): Boolean;
begin
  Result := False;
  if (FAI_TECH_2022_Entry = nil) then
      exit;
  Result := FAI_TECH_2022_Entry^.SetComputeDeviceOfProcess(device_id) = 0;
  if Result then
    begin
      if isGPU then
          DoStatus('Current GPU Device [%d] - "%s"', [device_id, GetComputeDeviceNameOfProcess(device_id).Text])
      else
          DoStatus('Current Compute Device [%d]', [device_id]);
    end;
end;

function TPas_AI_TECH_2022.GetComputeDeviceOfProcess: Integer;
begin
  Result := -1;
  if (FAI_TECH_2022_Entry = nil) then
      exit;
  Result := FAI_TECH_2022_Entry^.GetComputeDeviceOfProcess();
end;

function TPas_AI_TECH_2022.GetComputeDeviceNumOfProcess: Integer;
begin
  Result := -1;
  if (FAI_TECH_2022_Entry = nil) then
      exit;
  Result := FAI_TECH_2022_Entry^.GetComputeDeviceNumOfProcess();
end;

function TPas_AI_TECH_2022.GetComputeDeviceNameOfProcess(device_id: Integer): U_String;
var
  p: Pointer;
begin
  Result := '';
  if (FAI_TECH_2022_Entry = nil) then
      exit;
  p := FAI_TECH_2022_Entry^.GetComputeDeviceNameOfProcess(device_id);
  if p = nil then
      exit;
  Result := PPascalString(p)^;
  API_AI_TECH_2022_FreeString(p);
end;

function TPas_AI_TECH_2022.GetComputeDeviceNames: U_StringArray;
var
  i, Num: Integer;
begin
  SetLength(Result, 0);
  Num := GetComputeDeviceNumOfProcess;
  if Num > 0 then
    begin
      SetLength(Result, Num);
      for i := 0 to Num - 1 do
          Result[i] := GetComputeDeviceNameOfProcess(i);
    end;
end;

procedure TPas_AI_TECH_2022.GetComputeDeviceNames(output: TCore_Strings);
var
  i, Num: Integer;
begin
  output.Clear;
  Num := GetComputeDeviceNumOfProcess;
  if Num > 0 then
    begin
      for i := 0 to Num - 1 do
          output.Add(GetComputeDeviceNameOfProcess(i));
    end;
end;

procedure TPas_AI_TECH_2022.Lock;
begin
  Critical.Acquire;
end;

procedure TPas_AI_TECH_2022.UnLock;
begin
  Critical.Release;
end;

function TPas_AI_TECH_2022.Busy: Boolean;
begin
  Result := Critical.Busy;
end;

procedure TPas_AI_TECH_2022.Training_Stop;
begin
  TrainingControl.stop := MaxInt;
end;

procedure TPas_AI_TECH_2022.Training_Pause;
begin
  TrainingControl.pause := MaxInt;
end;

procedure TPas_AI_TECH_2022.Training_Continue;
begin
  TrainingControl.pause := 0;
end;

function TPas_AI_TECH_2022.Training_IsPause: Boolean;
begin
  Result := TrainingControl.pause <> 0;
end;

function TPas_AI_TECH_2022.Prepare_RGB_Image(Raster: TMPasAI_Raster): TPas_AI_TECH_2022_RGB_Image_Handle;
begin
  Raster.ReadyBits();
  Result := nil;
  if (FAI_TECH_2022_Entry <> nil) and Assigned(FAI_TECH_2022_Entry^.Prepare_RGB_Image) then
      Result := FAI_TECH_2022_Entry^.Prepare_RGB_Image(Raster.Bits, Raster.Width, Raster.Height);
end;

procedure TPas_AI_TECH_2022.Close_RGB_Image(hnd: TPas_AI_TECH_2022_RGB_Image_Handle);
begin
  if (FAI_TECH_2022_Entry <> nil) and Assigned(FAI_TECH_2022_Entry^.Close_RGB_Image) then
      FAI_TECH_2022_Entry^.Close_RGB_Image(hnd);
end;

function TPas_AI_TECH_2022.Prepare_Matrix_Image(Raster: TMPasAI_Raster): TPas_AI_TECH_2022_Matrix_Image_Handle;
begin
  Raster.ReadyBits();
  Result := nil;
  if (FAI_TECH_2022_Entry <> nil) and Assigned(FAI_TECH_2022_Entry^.Prepare_Matrix_Image) then
      Result := FAI_TECH_2022_Entry^.Prepare_Matrix_Image(Raster.Bits, Raster.Width, Raster.Height);
end;

procedure TPas_AI_TECH_2022.Close_Matrix_Image(hnd: TPas_AI_TECH_2022_Matrix_Image_Handle);
begin
  if (FAI_TECH_2022_Entry <> nil) and Assigned(FAI_TECH_2022_Entry^.Close_Matrix_Image) then
      FAI_TECH_2022_Entry^.Close_Matrix_Image(hnd);
end;

procedure TPas_AI_TECH_2022.BuildRGBRaster(hnd_RGB: TPas_AI_TECH_2022_RGB_Image_Handle; output: TMPasAI_Raster);
var
  hnd: TPas_AI_TECH_2022_BGRA_Buffer_Handle;
begin
  if (FAI_TECH_2022_Entry <> nil) and Assigned(FAI_TECH_2022_Entry^.OpenImageBuffer_RGB) then
    begin
      hnd := FAI_TECH_2022_Entry^.OpenImageBuffer_RGB(hnd_RGB);
      if hnd <> nil then
        begin
          output.SetSize(hnd^.Width, hnd^.Height);
          CopyPtr(hnd^.Bits, output.Bits, (hnd^.Width * hnd^.Height) shl 2);
          FAI_TECH_2022_Entry^.CloseImageBuffer(hnd);
        end;
    end;
end;

function TPas_AI_TECH_2022.BuildRGBRaster(hnd_RGB: TPas_AI_TECH_2022_RGB_Image_Handle): TMPasAI_Raster;
var
  hnd: TPas_AI_TECH_2022_BGRA_Buffer_Handle;
begin
  Result := nil;
  if (FAI_TECH_2022_Entry <> nil) and Assigned(FAI_TECH_2022_Entry^.OpenImageBuffer_RGB) then
    begin
      hnd := FAI_TECH_2022_Entry^.OpenImageBuffer_RGB(hnd_RGB);
      if hnd <> nil then
        begin
          Result := NewPasAI_Raster();
          Result.SetSize(hnd^.Width, hnd^.Height);
          CopyPtr(hnd^.Bits, Result.Bits, (hnd^.Width * hnd^.Height) shl 2);
          FAI_TECH_2022_Entry^.CloseImageBuffer(hnd);
        end;
    end;
end;

function TPas_AI_TECH_2022.BuildRGB_Buffer_Raster(hnd_RGB: TPas_AI_TECH_2022_BGRA_Buffer_Handle): TMPasAI_Raster;
begin
  Result := nil;
  if hnd_RGB <> nil then
    begin
      Result := NewPasAI_Raster();
      Result.SetSize(hnd_RGB^.Width, hnd_RGB^.Height);
      CopyPtr(hnd_RGB^.Bits, Result.Bits, (hnd_RGB^.Width * hnd_RGB^.Height) shl 2);
    end;
end;

procedure TPas_AI_TECH_2022.BuildMatrixRaster(hnd_Matrix: TPas_AI_TECH_2022_Matrix_Image_Handle; output: TMPasAI_Raster);
var
  hnd: TPas_AI_TECH_2022_BGRA_Buffer_Handle;
begin
  if (FAI_TECH_2022_Entry <> nil) and Assigned(FAI_TECH_2022_Entry^.OpenImageBuffer_Matrix) then
    begin
      hnd := FAI_TECH_2022_Entry^.OpenImageBuffer_Matrix(hnd_Matrix);
      if hnd <> nil then
        begin
          output.SetSize(hnd^.Width, hnd^.Height);
          CopyPtr(hnd^.Bits, output.Bits, (hnd^.Width * hnd^.Height) shl 2);
          FAI_TECH_2022_Entry^.CloseImageBuffer(hnd);
        end;
    end;
end;

function TPas_AI_TECH_2022.BuildMatrixRaster(hnd_Matrix: TPas_AI_TECH_2022_Matrix_Image_Handle): TMPasAI_Raster;
var
  hnd: TPas_AI_TECH_2022_BGRA_Buffer_Handle;
begin
  Result := nil;
  if (FAI_TECH_2022_Entry <> nil) and Assigned(FAI_TECH_2022_Entry^.OpenImageBuffer_Matrix) then
    begin
      hnd := FAI_TECH_2022_Entry^.OpenImageBuffer_Matrix(hnd_Matrix);
      if hnd <> nil then
        begin
          Result := NewPasAI_Raster();
          Result.SetSize(hnd^.Width, hnd^.Height);
          CopyPtr(hnd^.Bits, Result.Bits, (hnd^.Width * hnd^.Height) shl 2);
          FAI_TECH_2022_Entry^.CloseImageBuffer(hnd);
        end;
    end;
end;

class function TPas_AI_TECH_2022.Init_DCGAN_DNN_TrainParam(train_sync_file, train_output: U_String): PAI_TECH_2022_DCGAN_Train_Parameter;
begin
  new(Result);
  FillPtrByte(Result, SizeOf(TPas_AI_TECH_2022_DCGAN_Train_Parameter), 0);

  { sync file }
  Result^.train_sync_file := AI_TECH_2022_Alloc_P_Bytes(train_sync_file);

  { output model }
  Result^.train_output := AI_TECH_2022_Alloc_P_Bytes(train_output);

  { param }
  Result^.timeout := C_Tick_Week;
  Result^.rand_seed := TMT19937.Rand32(MaxInt);
  Result^.max_iterations := 50000;
  Result^.iteration_sync_step := 2000;
  Result^.learning_rate := 0.0002;
  Result^.mini_batch := 1000;

  { control }
  Result^.control := nil;

  { result }
  Result^.training_average_loss := 0;
  Result^.training_learning_rate := 0;
end;

class procedure TPas_AI_TECH_2022.Free_DCGAN_DNN_TrainParam(param: PAI_TECH_2022_DCGAN_Train_Parameter);
begin
  AI_TECH_2022_Free_P_Bytes(param^.train_sync_file);
  AI_TECH_2022_Free_P_Bytes(param^.train_output);
  Dispose(param);
end;

function TPas_AI_TECH_2022.DCGAN_DNN_Train(imgList: TMR_2DArray; param: PAI_TECH_2022_DCGAN_Train_Parameter): Integer;
var
  i, j, imgSum, ri: Integer;
  imgArry: TMR_Array;
  rArry: array of TPas_AI_TECH_2022_Raster_Data;
begin
  Result := -1;

  if FAI_TECH_2022_Entry = nil then
      exit;
  if not Assigned(FAI_TECH_2022_Entry^.DCGAN_Train) then
      exit;

  imgSum := 0;
  for i := 0 to Length(imgList) - 1 do
      inc(imgSum, Length(imgList[i]));

  if imgSum = 0 then
      exit;

  { process sequence }
  SetLength(rArry, imgSum);
  ri := 0;
  for i := 0 to Length(imgList) - 1 do
    begin
      imgArry := imgList[i];
      for j := 0 to Length(imgArry) - 1 do
        begin
          new(rArry[ri].raster_Hnd);
          rArry[ri].raster_Hnd^.Raster := imgArry[j];
          rArry[ri].raster_ptr := imgArry[j].Bits;
          rArry[ri].Width := imgArry[j].Width;
          rArry[ri].Height := imgArry[j].Height;
          rArry[ri].Index := i;
          inc(ri);
        end;
    end;

  FAI_TECH_2022_Entry^.RasterSerialized := nil;
  FAI_TECH_2022_Entry^.SerializedTime := GetTimeTick();
  FAI_TECH_2022_Entry^.Swap_Raster_Pool := TMR_Pool.Create(True);

  TrainingControl.pause := 0;
  TrainingControl.stop := 0;
  param^.imgArry_ptr := @rArry[0];
  param^.img_num := Length(rArry);
  param^.control := @TrainingControl;

  { run training }
  try
      Result := FAI_TECH_2022_Entry^.DCGAN_Train(param);
  except
      Result := -1;
  end;
  DisposeObjectAndNil(FAI_TECH_2022_Entry^.Swap_Raster_Pool);
  Last_training_average_loss := param^.training_average_loss;
  Last_training_learning_rate := param^.training_learning_rate;
end;

function TPas_AI_TECH_2022.DCGAN_DNN_Train(Snapshot_: Boolean; imgList: TPas_AI_ImageList; param: PAI_TECH_2022_DCGAN_Train_Parameter): Integer;
var
  imgBuff: TMR_2DArray;
  i, j: Integer;
begin
  Result := -1;
  if FAI_TECH_2022_Entry = nil then
      exit;
  if not Assigned(FAI_TECH_2022_Entry^.DCGAN_Train) then
      exit;

  if Snapshot_ then
    begin
      imgList.ClearDetector;
      imgList.CalibrationNoDetectorDefine('');
      imgBuff := imgList.ExtractDetectorDefineAsSnapshotProjection(C_DCGAN_Box_Size, C_DCGAN_Box_Size);
    end
  else
    begin
      imgList.CalibrationNullToken(umlIntToStr(GetTimeTick()));
      imgBuff := imgList.ExtractDetectorDefineAsPrepareRaster(C_DCGAN_Box_Size, C_DCGAN_Box_Size);
    end;

  if Length(imgBuff) = 0 then
      exit;

  Result := DCGAN_DNN_Train(imgBuff, param);

  for i := 0 to Length(imgBuff) - 1 do
    for j := 0 to Length(imgBuff[i]) - 1 do
        DisposeObject(imgBuff[i, j]);
  SetLength(imgBuff, 0, 0);
end;

function TPas_AI_TECH_2022.DCGAN_DNN_Train(Snapshot_: Boolean; imgMat: TPas_AI_ImageMatrix; param: PAI_TECH_2022_DCGAN_Train_Parameter): Integer;
var
  i, j: Integer;
  imgL: TPas_AI_ImageList;
  DetDef: TPas_AI_DetectorDefine;
  imgBuff: TMR_2DArray;
begin
  Result := -1;
  if FAI_TECH_2022_Entry = nil then
      exit;
  if not Assigned(FAI_TECH_2022_Entry^.DCGAN_Train) then
      exit;

  if Snapshot_ then
    begin
      imgMat.ClearDetector;
      for i := 0 to imgMat.Count - 1 do
        begin
          imgL := imgMat[i];
          imgL.CalibrationNoDetectorDefine(imgL.FileInfo);
          imgL.CalibrationNullToken(imgL.FileInfo);
          for j := 0 to imgL.Count - 1 do
            begin
              DetDef := TPas_AI_DetectorDefine.Create(imgL[j]);
              DetDef.R := imgL[j].Raster.BoundsRect;
              DetDef.Token := imgL.FileInfo;
              imgL[j].DetectorDefineList.Add(DetDef);
            end;
        end;
      imgBuff := imgMat.ExtractDetectorDefineAsSnapshotProjection(C_DCGAN_Box_Size, C_DCGAN_Box_Size);
    end
  else
    begin
      for i := 0 to imgMat.Count - 1 do
        begin
          imgL := imgMat[i];
          imgL.CalibrationNullToken(imgL.FileInfo);
        end;
      imgBuff := imgMat.ExtractDetectorDefineAsPrepareRaster(C_DCGAN_Box_Size, C_DCGAN_Box_Size);
    end;

  if Length(imgBuff) = 0 then
      exit;

  Result := DCGAN_DNN_Train(imgBuff, param);

  for i := 0 to Length(imgBuff) - 1 do
    for j := 0 to Length(imgBuff[i]) - 1 do
        DisposeObject(imgBuff[i, j]);
  SetLength(imgBuff, 0, 0);
end;

function TPas_AI_TECH_2022.DCGAN_DNN_Train_Stream(Snapshot_: Boolean; imgList: TPas_AI_ImageList; param: PAI_TECH_2022_DCGAN_Train_Parameter): TMS64;
var
  fn: U_String;
begin
  Result := nil;

  if DCGAN_DNN_Train(Snapshot_, imgList, param) > 0 then
    begin
      fn := AI_TECH_2022_Get_P_Bytes_String(param^.train_output);
      if umlFileExists(fn) then
        begin
          Result := TMS64.Create;
          Result.LoadFromFile(fn);
          Result.Position := 0;
        end;
    end;
end;

function TPas_AI_TECH_2022.DCGAN_DNN_Train_Stream(Snapshot_: Boolean; imgMat: TPas_AI_ImageMatrix; param: PAI_TECH_2022_DCGAN_Train_Parameter): TMS64;
var
  fn: U_String;
begin
  Result := nil;

  if DCGAN_DNN_Train(Snapshot_, imgMat, param) > 0 then
    begin
      fn := AI_TECH_2022_Get_P_Bytes_String(param^.train_output);
      if umlFileExists(fn) then
        begin
          Result := TMS64.Create;
          Result.LoadFromFile(fn);
          Result.Position := 0;
        end;
    end;
end;

function TPas_AI_TECH_2022.DCGAN_DNN_Open(train_file: SystemString): TPas_AI_TECH_2022_DCGAN_Handle;
var
  train_file_buff: P_Bytes;
begin
  if (FAI_TECH_2022_Entry <> nil) and Assigned(FAI_TECH_2022_Entry^.DCGAN_Init) then
    begin
      train_file_buff := AI_TECH_2022_Alloc_P_Bytes(train_file);
      Result := FAI_TECH_2022_Entry^.DCGAN_Init(train_file_buff);
      AI_TECH_2022_Free_P_Bytes(train_file_buff);
      if Result <> nil then
          DoStatus('Unsupervised Representation Learning with Deep Convolutional Generative Adversarial Networks open: %s', [train_file]);
    end
  else
      Result := nil;
end;

function TPas_AI_TECH_2022.DCGAN_DNN_Open_Stream(stream: TMS64): TPas_AI_TECH_2022_DCGAN_Handle;
begin
  if (FAI_TECH_2022_Entry <> nil) and Assigned(FAI_TECH_2022_Entry^.DCGAN_Init_Memory) then
    begin
      Result := FAI_TECH_2022_Entry^.DCGAN_Init_Memory(stream.memory, stream.Size);
      if Result <> nil then
          DoStatus('Unsupervised Representation Learning with Deep Convolutional Generative Adversarial Networks open memory %s size:%s', [umlPointerToStr(stream.memory).Text, umlSizeToStr(stream.Size).Text]);
    end
  else
      Result := nil;
end;

function TPas_AI_TECH_2022.DCGAN_DNN_Close(var hnd: TPas_AI_TECH_2022_DCGAN_Handle): Boolean;
begin
  if (FAI_TECH_2022_Entry <> nil) and Assigned(FAI_TECH_2022_Entry^.DCGAN_Free) and (hnd <> nil) then
    begin
      Result := FAI_TECH_2022_Entry^.DCGAN_Free(hnd) = 0;
      DoStatus('Unsupervised Representation Learning with Deep Convolutional Generative Adversarial Networks close.', []);
    end
  else
      Result := False;

  hnd := nil;
end;

function TPas_AI_TECH_2022.DCGAN_DNN_Process(hnd: TPas_AI_TECH_2022_DCGAN_Handle; rand_seed: Int64; var real_: Single): TMPasAI_Raster;
var
  rgb_hnd: TPas_AI_TECH_2022_BGRA_Buffer_Handle;
begin
  Result := nil;
  if (FAI_TECH_2022_Entry <> nil) and Assigned(FAI_TECH_2022_Entry^.DCGAN_Process) and (hnd <> nil) then
    begin
      try
        rgb_hnd := FAI_TECH_2022_Entry^.DCGAN_Process(hnd, rand_seed, real_);
        if rgb_hnd <> nil then
          begin
            Result := BuildRGB_Buffer_Raster(rgb_hnd);
            if Assigned(FAI_TECH_2022_Entry^.CloseImageBuffer) then
                FAI_TECH_2022_Entry^.CloseImageBuffer(rgb_hnd);
          end;
      except
      end;
    end;
end;

function TPas_AI_TECH_2022.DCGAN_DNN_Process(hnd: TPas_AI_TECH_2022_DCGAN_Handle; rand_seed: Int64): TMPasAI_Raster;
var
  rgb_hnd: TPas_AI_TECH_2022_BGRA_Buffer_Handle;
begin
  Result := nil;
  if (FAI_TECH_2022_Entry <> nil) and Assigned(FAI_TECH_2022_Entry^.DCGAN_Fast_Process) and (hnd <> nil) then
    begin
      try
        rgb_hnd := FAI_TECH_2022_Entry^.DCGAN_Fast_Process(hnd, rand_seed);
        if rgb_hnd <> nil then
          begin
            Result := BuildRGB_Buffer_Raster(rgb_hnd);
            if Assigned(FAI_TECH_2022_Entry^.CloseImageBuffer) then
                FAI_TECH_2022_Entry^.CloseImageBuffer(rgb_hnd);
          end;
      except
      end;
    end;
end;

function TPas_AI_TECH_2022.DCGAN_DNN_DebugInfo(hnd: TPas_AI_TECH_2022_DCGAN_Handle): U_String;
var
  p: PPascalString;
begin
  Result := '';
  if (FAI_TECH_2022_Entry <> nil) and Assigned(FAI_TECH_2022_Entry^.DCGAN_DebugInfo) and (hnd <> nil) then
    begin
      FAI_TECH_2022_Entry^.DCGAN_DebugInfo(hnd, p);
      Result := p^;
      Dispose(p);
    end;
end;

class function TPas_AI_TECH_2022.Init_ZMetric_V2_Parameter(train_sync_file, train_output: U_String): PAI_TECH_2022_ZMetric_V2_Train_Parameter;
begin
  new(Result);
  FillPtrByte(Result, SizeOf(TPas_AI_TECH_2022_ZMetric_V2_Train_Parameter), 0);

  Result^.Detector_Define := nil;
  Result^.img_num := 0;
  Result^.train_sync_file := AI_TECH_2022_Alloc_P_Bytes(train_sync_file);
  Result^.train_output := AI_TECH_2022_Alloc_P_Bytes(train_output);

  Result^.timeout := C_Tick_Week;
  Result^.weight_decay := 0.0001;
  Result^.momentum := 0.9;
  Result^.iterations_without_progress_threshold := 500;
  Result^.min_learning_rate := 0.0001;
  Result^.learning_rate := 0.1;
  Result^.completed_learning_rate := 0.0001;
  Result^.step_mini_batch_target_num := 5;
  Result^.step_mini_batch_jitter_num := 50;
  Result^.auto_flip_left_right := 1;
  Result^.jitter_ss_width := 150;
  Result^.jitter_ss_height := 150;
  Result^.jitter_XY_Offset_Scale := 0.05;
  Result^.jitter_Rotate := 5;
  Result^.jitter_Scale := 0.1;
  Result^.jitter_inner_fit := 0;
  Result^.jitter_thread_num := 10;
  Result^.Max_Data_Queue := 50;

  Result^.control := nil;
  Result^.training_average_loss := 0;
  Result^.training_learning_rate := 0;
end;

class procedure TPas_AI_TECH_2022.Free_ZMetric_V2_Parameter(param: PAI_TECH_2022_ZMetric_V2_Train_Parameter);
begin
  AI_TECH_2022_Free_P_Bytes(param^.train_sync_file);
  AI_TECH_2022_Free_P_Bytes(param^.train_output);
  Dispose(param);
end;

function TPas_AI_TECH_2022.ZMetric_V2_Train(LargeScale_: Boolean; RSeri: TPasAI_RasterSerialized; DetDef_Matrix: TMatrix_Detector_Define; param: PAI_TECH_2022_ZMetric_V2_Train_Parameter): Boolean;
var
  i, j, imgSum, ri: Integer;
  tmp_Arry: TArray_Detector_Define;
  dArry: array of TPas_AI_TECH_2022_Detector_Define_Input;
begin
  Result := False;

  if FAI_TECH_2022_Entry = nil then
      exit;
  if not Assigned(FAI_TECH_2022_Entry^.ZMetric_V2_Full_GPU_Train) then
      exit;

  imgSum := 0;
  for i := 0 to Length(DetDef_Matrix) - 1 do
      inc(imgSum, Length(DetDef_Matrix[i]));

  if imgSum = 0 then
      exit;

  { process sequence }
  SetLength(dArry, imgSum);
  ri := 0;
  for i := 0 to Length(DetDef_Matrix) - 1 do
    begin
      tmp_Arry := DetDef_Matrix[i];
      for j := 0 to Length(tmp_Arry) - 1 do
        begin
          if LargeScale_ then
              tmp_Arry[j].Owner.SerializedAndRecycleMemory(RSeri);

          new(dArry[ri].Data);
          dArry[ri].Data^.Detector_Define := tmp_Arry[j];
          dArry[ri].Index := i;
          inc(ri);
        end;
    end;

  { set arry }
  param^.Detector_Define := PAI_TECH_2022_Detector_Define_Input_Array(@dArry[0]);
  param^.img_num := Length(dArry);
  param^.control := @TrainingControl;

  { update control }
  TrainingControl.pause := 0;
  TrainingControl.stop := 0;

  { update RasterSerialized }
  if LargeScale_ then
    begin
      RSeri.Clear_History;
      RSeri.Enabled_Read_History := True;
      FAI_TECH_2022_Entry^.RasterSerialized := RSeri;
      RSeri.Enabled_Read_History := True;
    end
  else
      FAI_TECH_2022_Entry^.RasterSerialized := nil;

  FAI_TECH_2022_Entry^.SerializedTime := GetTimeTick();

  { run training }
  try
      Result := FAI_TECH_2022_Entry^.ZMetric_V2_Full_GPU_Train(param) >= 0
  except
      Result := False;
  end;

  if LargeScale_ then
    begin
      RSeri.Clear_History;
      RSeri.Enabled_Read_History := False;
      FAI_TECH_2022_Entry^.RasterSerialized := nil;
    end;

  Last_training_average_loss := param^.training_average_loss;
  Last_training_learning_rate := param^.training_learning_rate;

  { reset arry }
  param^.Detector_Define := nil;
  param^.img_num := 0;

  { free }
  for i := 0 to Length(dArry) - 1 do
      Dispose(dArry[i].Data);
  SetLength(dArry, 0);
end;

function TPas_AI_TECH_2022.ZMetric_V2_Train(imgList: TPas_AI_ImageList; param: PAI_TECH_2022_ZMetric_V2_Train_Parameter): Boolean;
var
  DetDef_Matrix: TMatrix_Detector_Define;
begin
  Result := False;
  if FAI_TECH_2022_Entry = nil then
      exit;
  if not Assigned(FAI_TECH_2022_Entry^.ZMetric_V2_Full_GPU_Train) then
      exit;

  DetDef_Matrix := imgList.ExtractDetectorDefine;
  if Length(DetDef_Matrix) = 0 then
      exit;

  try
      Result := ZMetric_V2_Train(False, nil, DetDef_Matrix, param);
  except
  end;
end;

function TPas_AI_TECH_2022.ZMetric_V2_Train_Stream(imgList: TPas_AI_ImageList; param: PAI_TECH_2022_ZMetric_V2_Train_Parameter): TMS64;
var
  fn: U_String;
begin
  Result := nil;

  if ZMetric_V2_Train(imgList, param) then
    begin
      fn := AI_TECH_2022_Get_P_Bytes_String(param^.train_output);
      if umlFileExists(fn) then
        begin
          Result := TMS64.Create;
          Result.LoadFromFile(fn);
          Result.Position := 0;
        end;
    end;
end;

function TPas_AI_TECH_2022.ZMetric_V2_Train(imgMat: TPas_AI_ImageMatrix; param: PAI_TECH_2022_ZMetric_V2_Train_Parameter): Boolean;
var
  DetDef_Matrix: TMatrix_Detector_Define;
begin
  Result := False;
  if FAI_TECH_2022_Entry = nil then
      exit;
  if not Assigned(FAI_TECH_2022_Entry^.ZMetric_V2_Full_GPU_Train) then
      exit;

  DetDef_Matrix := imgMat.ExtractDetectorDefine;
  if Length(DetDef_Matrix) = 0 then
      exit;

  try
      Result := ZMetric_V2_Train(False, nil, DetDef_Matrix, param);
  except
  end;
end;

function TPas_AI_TECH_2022.ZMetric_V2_Train_Stream(imgMat: TPas_AI_ImageMatrix; param: PAI_TECH_2022_ZMetric_V2_Train_Parameter): TMS64;
var
  fn: U_String;
begin
  Result := nil;

  if ZMetric_V2_Train(imgMat, param) then
    begin
      fn := AI_TECH_2022_Get_P_Bytes_String(param^.train_output);
      if umlFileExists(fn) then
        begin
          Result := TMS64.Create;
          Result.LoadFromFile(fn);
          Result.Position := 0;
        end;
    end;
end;

function TPas_AI_TECH_2022.ZMetric_V2_Train(LargeScale_: Boolean; RSeri: TPasAI_RasterSerialized; imgMat: TPas_AI_ImageMatrix; param: PAI_TECH_2022_ZMetric_V2_Train_Parameter): Boolean;
var
  DetDef_Matrix: TMatrix_Detector_Define;
begin
  Result := False;
  if FAI_TECH_2022_Entry = nil then
      exit;
  if not Assigned(FAI_TECH_2022_Entry^.ZMetric_V2_Full_GPU_Train) then
      exit;

  DetDef_Matrix := imgMat.ExtractDetectorDefine;
  if Length(DetDef_Matrix) = 0 then
      exit;

  try
      Result := ZMetric_V2_Train(LargeScale_, RSeri, DetDef_Matrix, param);
  except
  end;
end;

function TPas_AI_TECH_2022.ZMetric_V2_Train_Stream(LargeScale_: Boolean; RSeri: TPasAI_RasterSerialized; imgMat: TPas_AI_ImageMatrix; param: PAI_TECH_2022_ZMetric_V2_Train_Parameter): TMS64;
var
  fn: U_String;
begin
  Result := nil;

  if ZMetric_V2_Train(LargeScale_, RSeri, imgMat, param) then
    begin
      fn := AI_TECH_2022_Get_P_Bytes_String(param^.train_output);
      if umlFileExists(fn) then
        begin
          Result := TMS64.Create;
          Result.LoadFromFile(fn);
          Result.Position := 0;
        end;
    end;
end;

class function TPas_AI_TECH_2022.Build_ZMetric_V2_Learn: TLearn;
var
  L: TLearn;
begin
  L := TLearn.CreateClassifier(ltKDT, C_ZMetric_V2_Dim);
  Result := L;
end;

class function TPas_AI_TECH_2022.Process_ZMetric_V2_Token(L_: TLearn; Input_: TLVec; Filter_Min_, Filter_Max_: TLFloat; var MinK_: TLFloat): U_String;
var
  hPool: TCandidate_Distance_Hash_Pool;
  pool: TCandidate_Distance_Pool;
begin
  Result := '';
  MinK_ := 0;
  if Length(Input_) <> C_ZMetric_V2_Dim then
      exit;
  hPool := L_.ProcessMaxIndexCandidate_Pool(Input_, Filter_Min_, Filter_Max_);
  pool := hPool.Get_Min_Mean_Pool;
  if pool <> nil then
    begin
      MinK_ := pool.Min_Distance;
      Result := pool.Name;
    end
  else if Length(hPool.buff) > 0 then
    begin
      MinK_ := hPool.buff[0].Distance_;
      Result := hPool.buff[0].Memory_^.Token;
    end;
  DisposeObject(hPool);
end;

class function TPas_AI_TECH_2022.Process_ZMetric_V2_Token(L_: TLearn; Input_: TLVec; var MinK_: TLFloat): U_String;
begin
  Result := TPas_AI_TECH_2022.Process_ZMetric_V2_Token(L_, Input_, 0, 1, MinK_);
end;

class function TPas_AI_TECH_2022.Fast_Process_ZMetric_V2_Token(L_: TLearn; Input_: TLVec; var MinK_: TLFloat): U_String;
var
  Searched_Min_Distance: Double;
  i: TLInt;
begin
  Result := '';
  MinK_ := 0;
  if Length(Input_) <> C_ZMetric_V2_Dim then
      exit;
  i := L_.Fast_Search_Nearest_K(Input_, Searched_Min_Distance);
  if (i >= 0) then
    begin
      Result := L_[i]^.Token;
      MinK_ := Searched_Min_Distance;
    end;
end;

class function TPas_AI_TECH_2022.Fast_Process_ZMetric_V2_Jitter_Token(L_: TLearn; Input_: TLMatrix; var MinK_: TLFloat): U_String;
var
  Pool_: TCandidate_Distance_Hash_Pool;
begin
  Result := '';
  MinK_ := 0;
  Pool_ := L_.Fast_Search_Nearest_K_Candidate(Input_, 0, 0);
  if Pool_ = nil then
      exit;
  with Pool_.Get_Min_Mean_Pool do
    begin
      Result := Name;
      MinK_ := Min_Distance;
    end;
  DisposeObject(Pool_);
end;

function TPas_AI_TECH_2022.ZMetric_V2_Open(train_file: SystemString): TPas_AI_TECH_2022_ZMetric_V2_Handle;
var
  train_file_buff: P_Bytes;
begin
  if (FAI_TECH_2022_Entry <> nil) and Assigned(FAI_TECH_2022_Entry^.ZMetric_V2_Init) then
    begin
      train_file_buff := AI_TECH_2022_Alloc_P_Bytes(train_file);
      Result := FAI_TECH_2022_Entry^.ZMetric_V2_Init(train_file_buff);
      AI_TECH_2022_Free_P_Bytes(train_file_buff);
      if Result <> nil then
          DoStatus('Z-Metric V2.0 open: %s', [train_file]);
    end
  else
      Result := nil;
end;

function TPas_AI_TECH_2022.ZMetric_V2_Open_Stream(stream: TMS64): TPas_AI_TECH_2022_ZMetric_V2_Handle;
begin
  if (FAI_TECH_2022_Entry <> nil) and Assigned(FAI_TECH_2022_Entry^.ZMetric_V2_Init_Memory) then
    begin
      Result := FAI_TECH_2022_Entry^.ZMetric_V2_Init_Memory(stream.memory, stream.Size);
      if Result <> nil then
          DoStatus('Z-Metric V2.0 open memory %s size:%s', [umlPointerToStr(stream.memory).Text, umlSizeToStr(stream.Size).Text]);
    end
  else
      Result := nil;
end;

function TPas_AI_TECH_2022.ZMetric_V2_Open_Stream(train_file: SystemString): TPas_AI_TECH_2022_ZMetric_V2_Handle;
var
  m64: TMS64;
begin
  m64 := TMS64.Create;
  m64.LoadFromFile(train_file);
  Result := ZMetric_V2_Open_Stream(m64);
  DisposeObject(m64);
  if Result <> nil then
      DoStatus('Z-Metric V2.0 open: %s', [train_file]);
end;

function TPas_AI_TECH_2022.ZMetric_V2_Close(var hnd: TPas_AI_TECH_2022_ZMetric_V2_Handle): Boolean;
begin
  if (FAI_TECH_2022_Entry <> nil) and Assigned(FAI_TECH_2022_Entry^.ZMetric_V2_Free) and (hnd <> nil) then
    begin
      Result := FAI_TECH_2022_Entry^.ZMetric_V2_Free(hnd) = 0;
      DoStatus('Z-Metric V2.0 close.', []);
    end
  else
      Result := False;

  hnd := nil;
end;

function TPas_AI_TECH_2022.ZMetric_V2_Get_Jitter_Value(var hnd: TPas_AI_TECH_2022_ZMetric_V2_Handle;
  var ss_width, ss_height, XY_Offset_Scale, Rotate_, Scale_: Double; var inner_fit: Boolean): Boolean;
var
  inner_fit_: Integer;
begin
  if (FAI_TECH_2022_Entry <> nil) and Assigned(FAI_TECH_2022_Entry^.ZMetric_V2_Get_Jitter_Value) and (hnd <> nil) then
    begin
      FAI_TECH_2022_Entry^.ZMetric_V2_Get_Jitter_Value(hnd,
        ss_width, ss_height, XY_Offset_Scale, Rotate_, Scale_, inner_fit_);
      inner_fit := inner_fit_ > 0;
      Result := True;
    end
  else
      Result := False;
end;

function TPas_AI_TECH_2022.ZMetric_V2_Process_No_Jitter(hnd: TPas_AI_TECH_2022_ZMetric_V2_Handle; Raster: TPasAI_Raster; output: PDouble): Integer;
var
  ss_width, ss_height, XY_Offset_Scale, Rotate_, Scale_: Double;
  inner_fit: Boolean;
  rData: TPas_AI_TECH_2022_Raster_Data;
  tmp_raster: TPasAI_Raster;
begin
  Result := -2;
  if not ZMetric_V2_Get_Jitter_Value(hnd, ss_width, ss_height, XY_Offset_Scale, Rotate_, Scale_, inner_fit) then
      exit;
  if (FAI_TECH_2022_Entry = nil) or (not Assigned(FAI_TECH_2022_Entry^.ZMetric_V2_Process)) then
      exit;

  { make rasterization }
  tmp_raster := NewPasAI_Raster();
  tmp_raster.SetSizeF(ss_width, ss_height, RColor(0, 0, 0));
  Raster.ProjectionTo(tmp_raster, MinLoss_Rect(ss_width, ss_height, Raster.BoundsRectV20), tmp_raster.BoundsRectV20, True, 1.0);
  { update buff }
  new(rData.raster_Hnd);
  rData.raster_Hnd^.Raster := tmp_raster;
  rData.raster_ptr := tmp_raster.Bits;
  rData.Width := tmp_raster.Width;
  rData.Height := tmp_raster.Height;
  rData.Index := 0;

  FAI_TECH_2022_Entry^.RasterSerialized := nil;
  FAI_TECH_2022_Entry^.SerializedTime := GetTimeTick();

  try
      Result := FAI_TECH_2022_Entry^.ZMetric_V2_Process(hnd, PAI_TECH_2022_Raster_Data_Array(@rData), 1, output);
  except
      Result := -2;
  end;

  DisposeObject(rData.raster_Hnd^.Raster);
  Dispose(rData.raster_Hnd);
end;

function TPas_AI_TECH_2022.ZMetric_V2_Process_No_Jitter(hnd: TPas_AI_TECH_2022_ZMetric_V2_Handle; Raster: TPasAI_Raster): TLVec;
begin
  SetLength(Result, 1 * C_ZMetric_V2_Dim);
  if ZMetric_V2_Process_No_Jitter(hnd, Raster, @Result[0]) <= 0 then
      SetLength(Result, 0);
end;

function TPas_AI_TECH_2022.ZMetric_V2_Process_No_Jitter(hnd: TPas_AI_TECH_2022_ZMetric_V2_Handle; Raster: TPasAI_Raster; Box: TRectV2; output: PDouble): Integer;
var
  ss_width, ss_height, XY_Offset_Scale, Rotate_, Scale_: Double;
  inner_fit: Boolean;
  rData: TPas_AI_TECH_2022_Raster_Data;
  tmp_raster: TPasAI_Raster;
begin
  Result := -2;
  if not ZMetric_V2_Get_Jitter_Value(hnd, ss_width, ss_height, XY_Offset_Scale, Rotate_, Scale_, inner_fit) then
      exit;
  if (FAI_TECH_2022_Entry = nil) or (not Assigned(FAI_TECH_2022_Entry^.ZMetric_V2_Process)) then
      exit;

  { make rasterization }
  tmp_raster := NewPasAI_Raster();
  tmp_raster.SetSizeF(ss_width, ss_height, RColor(0, 0, 0));
  Raster.ProjectionTo(tmp_raster, MinLoss_Rect(ss_width, ss_height, Box), tmp_raster.BoundsRectV20, True, 1.0);
  { update buff }
  new(rData.raster_Hnd);
  rData.raster_Hnd^.Raster := tmp_raster;
  rData.raster_ptr := tmp_raster.Bits;
  rData.Width := tmp_raster.Width;
  rData.Height := tmp_raster.Height;
  rData.Index := 0;

  FAI_TECH_2022_Entry^.RasterSerialized := nil;
  FAI_TECH_2022_Entry^.SerializedTime := GetTimeTick();

  try
      Result := FAI_TECH_2022_Entry^.ZMetric_V2_Process(hnd, PAI_TECH_2022_Raster_Data_Array(@rData), 1, output);
  except
      Result := -2;
  end;

  DisposeObject(rData.raster_Hnd^.Raster);
  Dispose(rData.raster_Hnd);
end;

function TPas_AI_TECH_2022.ZMetric_V2_Process_No_Jitter(hnd: TPas_AI_TECH_2022_ZMetric_V2_Handle; Raster: TPasAI_Raster; Box: TRectV2): TLVec;
begin
  SetLength(Result, 1 * C_ZMetric_V2_Dim);
  if ZMetric_V2_Process_No_Jitter(hnd, Raster, Box, @Result[0]) <= 0 then
      SetLength(Result, 0);
end;

function TPas_AI_TECH_2022.ZMetric_V2_Process(hnd: TPas_AI_TECH_2022_ZMetric_V2_Handle; Raster: TPasAI_Raster; Box: TRectV2; Jitter_Num: Integer; output: PDouble): Integer;
var
  ss_width, ss_height, XY_Offset_Scale, Rotate_, Scale_: Double;
  inner_fit: Boolean;
  rArry: array of TPas_AI_TECH_2022_Raster_Data;

{$IFDEF FPC}
  procedure Nested_ParallelFor(pass: Integer);
  var
    tmp_box: TRectV2;
    tmp_angle: TGeoFloat;
    tmp_raster: TPasAI_Raster;
  begin
    { make jitter }
    Make_Jitter_Box(FAI_TECH_2022_Entry^.Rand,
      XY_Offset_Scale, Rotate_, Scale_, inner_fit, RectScaleSpace(Box, ss_width, ss_height), tmp_box, tmp_angle);
    tmp_box := MinLoss_Rect(ss_width, ss_height, tmp_box); { standardized scale }
    { make rasterization }
    tmp_raster := NewPasAI_Raster();
    tmp_raster.SetSizeF(ss_width, ss_height, RColor(0, 0, 0));
    Raster.ProjectionTo(tmp_raster, TV2R4.Init(tmp_box, tmp_angle), tmp_raster.BoundsV2Rect40, True, 1.0);
    { update buff }
    new(rArry[pass].raster_Hnd);
    rArry[pass].raster_Hnd^.Raster := tmp_raster;
    rArry[pass].raster_ptr := tmp_raster.Bits;
    rArry[pass].Width := tmp_raster.Width;
    rArry[pass].Height := tmp_raster.Height;
    rArry[pass].Index := pass;
  end;
{$ENDIF FPC}
  procedure Do_Build_Jitter_Data;
  var
    i: Integer;
    tmp_box: TRectV2;
    tmp_angle: TGeoFloat;
    tmp_raster: TPasAI_Raster;
  begin
    for i := 0 to Jitter_Num - 1 do
      begin
        { make jitter }
        Make_Jitter_Box(FAI_TECH_2022_Entry^.Rand,
          XY_Offset_Scale, Rotate_, Scale_, inner_fit, RectScaleSpace(Box, ss_width, ss_height), tmp_box, tmp_angle);
        tmp_box := MinLoss_Rect(ss_width, ss_height, tmp_box); { standardized scale }
        { make rasterization }
        tmp_raster := NewPasAI_Raster();
        tmp_raster.SetSizeF(ss_width, ss_height, RColor(0, 0, 0));
        Raster.ProjectionTo(tmp_raster, TV2R4.Init(tmp_box, tmp_angle), tmp_raster.BoundsV2Rect40, True, 1.0);
        { update buff }
        new(rArry[i].raster_Hnd);
        rArry[i].raster_Hnd^.Raster := tmp_raster;
        rArry[i].raster_ptr := tmp_raster.Bits;
        rArry[i].Width := tmp_raster.Width;
        rArry[i].Height := tmp_raster.Height;
        rArry[i].Index := i;
      end;
  end;

  procedure Do_Done_Free;
  var
    i: Integer;
  begin
    for i := 0 to Length(rArry) - 1 do
      begin
        DisposeObject(rArry[i].raster_Hnd^.Raster);
        Dispose(rArry[i].raster_Hnd);
      end;
  end;

begin
  Result := -2;
  if not ZMetric_V2_Get_Jitter_Value(hnd, ss_width, ss_height, XY_Offset_Scale, Rotate_, Scale_, inner_fit) then
      exit;
  if (FAI_TECH_2022_Entry = nil) or (not Assigned(FAI_TECH_2022_Entry^.ZMetric_V2_Process)) then
      exit;
  if Jitter_Num <= 0 then
      exit;

  SetLength(rArry, Jitter_Num);

  if Jitter_Num > AI_Parallel_Count then
    begin
{$IFDEF FPC}
      ParallelFor(AI_Parallel_Count, True, 0, Jitter_Num - 1, Nested_ParallelFor);
{$ELSE FPC}
      ParallelFor(AI_Parallel_Count, True, 0, Jitter_Num - 1, procedure(pass: Integer)
        var
          tmp_box: TRectV2;
          tmp_angle: TGeoFloat;
          tmp_raster: TPasAI_Raster;
        begin
          { make jitter }
          Make_Jitter_Box(FAI_TECH_2022_Entry^.Rand,
            XY_Offset_Scale, Rotate_, Scale_, inner_fit, RectScaleSpace(Box, ss_width, ss_height), tmp_box, tmp_angle);
          tmp_box := MinLoss_Rect(ss_width, ss_height, tmp_box); { standardized scale }
          { make rasterization }
          tmp_raster := NewPasAI_Raster();
          tmp_raster.SetSizeF(ss_width, ss_height, RColor(0, 0, 0));
          Raster.ProjectionTo(tmp_raster, TV2R4.Init(tmp_box, tmp_angle), tmp_raster.BoundsV2Rect40, True, 1.0);
          { update buff }
          new(rArry[pass].raster_Hnd);
          rArry[pass].raster_Hnd^.Raster := tmp_raster;
          rArry[pass].raster_ptr := tmp_raster.Bits;
          rArry[pass].Width := tmp_raster.Width;
          rArry[pass].Height := tmp_raster.Height;
          rArry[pass].Index := pass;
        end);
{$ENDIF FPC}
    end
  else
    begin
      Do_Build_Jitter_Data();
    end;

  FAI_TECH_2022_Entry^.RasterSerialized := nil;
  FAI_TECH_2022_Entry^.SerializedTime := GetTimeTick();

  try
      Result := FAI_TECH_2022_Entry^.ZMetric_V2_Process(hnd, PAI_TECH_2022_Raster_Data_Array(@rArry[0]), Length(rArry), output);
  except
      Result := -2;
  end;

  Do_Done_Free;
  SetLength(rArry, 0);
end;

function TPas_AI_TECH_2022.ZMetric_V2_Process(hnd: TPas_AI_TECH_2022_ZMetric_V2_Handle; Raster: TPasAI_Raster; Box: TRectV2; Jitter_Num: Integer): TLMatrix;
var
  L: TLVec;
  i: TLInt;
begin
  Result := LMatrix(0, 0);
  if Jitter_Num <= 0 then
      exit;

  SetLength(L, Jitter_Num * C_ZMetric_V2_Dim);
  if ZMetric_V2_Process(hnd, Raster, Box, Jitter_Num, @L[0]) > 0 then
    begin
      Result := LMatrix(Jitter_Num, 0);
      for i := Low(Result) to high(Result) do
          Result[i] := LVecCopy(L, i * C_ZMetric_V2_Dim, C_ZMetric_V2_Dim);
    end;
  SetLength(L, 0);
end;

procedure TPas_AI_TECH_2022.ZMetric_V2_Save_To_Learn_DNN_Thread(Jitter: Boolean; Jitter_Num: Integer; Pool_: TPas_AI_TECH_2022_DNN_Thread_Pool; RSeri: TPasAI_RasterSerialized; imgList: TPas_AI_ImageList; L: TLearn);
var
  i, j: Integer;
  imgData: TPas_AI_Image;
  DetDef: TPas_AI_DetectorDefine;
  p: PZMetric_V2_SaveToLearnEngine_DT_UserData_;
begin
  for i := 0 to imgList.Count - 1 do
    begin
      imgData := imgList[i];
      if RSeri <> nil then
          imgData.UnserializedMemory(RSeri);

      for j := 0 to imgData.DetectorDefineList.Count - 1 do
        begin
          DetDef := imgData.DetectorDefineList[j];
          if DetDef.Token.Len > 0 then
            begin

              if not DetDef.PrepareRaster.Empty then
                begin
                  new(p);
                  p^.L := L;
                  p^.DetDef := DetDef;

                  TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2(Pool_.MinLoad_DNN_Thread).Process_No_Box_C(p,
                    DetDef.PrepareRaster, False, ZMetric_V2_No_Box_Save_To_Learn_Engine_DNN_Thread_Backcall);
                end;

              new(p);
              p^.L := L;
              p^.DetDef := DetDef;
              TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2(Pool_.MinLoad_DNN_Thread).Process_No_Jitter_C(p,
                DetDef.Owner.Raster, RectV2(DetDef.R), False, ZMetric_V2_No_Jitter_Save_To_Learn_Engine_DNN_Thread_Backcall);

              if Jitter and (Jitter_Num > 0) then
                begin
                  new(p);
                  p^.L := L;
                  p^.DetDef := DetDef;
                  TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2(Pool_.MinLoad_DNN_Thread).Process_Jitter_C(p,
                    DetDef.Owner.Raster, RectV2(DetDef.R), Jitter_Num, False, ZMetric_V2_Jitter_Save_To_Learn_Engine_DNN_Thread_Backcall);
                end;
            end;
        end;

      if RSeri <> nil then
        begin
          Pool_.Wait();
          imgData.SerializedAndRecycleMemory(RSeri);
        end;
    end;
end;

procedure TPas_AI_TECH_2022.ZMetric_V2_Save_To_Learn_DNN_Thread(Jitter: Boolean; Jitter_Num, ThNum: Integer; ZMetric_V2_stream: TMS64; imgList: TPas_AI_ImageList; L: TLearn);
var
  Pool_: TPas_AI_TECH_2022_DNN_Thread_Pool;
  i: Integer;
  Device_: TLIVec;
begin
  if L.InSize <> C_ZMetric_V2_Dim then
      RaiseInfo('Learn Engine Insize illegal');
  Pool_ := TPas_AI_TECH_2022_DNN_Thread_Pool.Create;

  GetComputeDeviceOfTraining(Device_);
  for i in Device_ do
      Pool_.BuildDeviceThread(FAI_TECH_2022_Entry, i, ThNum, TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2);
  for i := 0 to Pool_.Count - 1 do
      TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2(Pool_[i]).Open_Stream(ZMetric_V2_stream);

  ZMetric_V2_Save_To_Learn_DNN_Thread(Jitter, Jitter_Num, Pool_, nil, imgList, L);

  Pool_.Wait();
  DisposeObject(Pool_);
end;

procedure TPas_AI_TECH_2022.ZMetric_V2_Save_To_Learn_DNN_Thread(Jitter: Boolean; Jitter_Num, ThNum: Integer; ZMetric_V2_stream: TMS64; imgMat: TPas_AI_ImageMatrix; L: TLearn);
var
  Pool_: TPas_AI_TECH_2022_DNN_Thread_Pool;
  i: Integer;
  Device_: TLIVec;
begin
  if L.InSize <> C_ZMetric_V2_Dim then
      RaiseInfo('Learn Engine Insize illegal');
  Pool_ := TPas_AI_TECH_2022_DNN_Thread_Pool.Create;

  GetComputeDeviceOfTraining(Device_);
  for i in Device_ do
      Pool_.BuildDeviceThread(FAI_TECH_2022_Entry, i, ThNum, TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2);
  for i := 0 to Pool_.Count - 1 do
      TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2(Pool_[i]).Open_Stream(ZMetric_V2_stream);

  for i := 0 to imgMat.Count - 1 do
      ZMetric_V2_Save_To_Learn_DNN_Thread(Jitter, Jitter_Num, Pool_, nil, imgMat[i], L);

  Pool_.Wait();
  DisposeObject(Pool_);
end;

procedure TPas_AI_TECH_2022.ZMetric_V2_Save_To_Learn_DNN_Thread(Jitter: Boolean; Jitter_Num, ThNum: Integer; ZMetric_V2_stream: TMS64; RSeri: TPasAI_RasterSerialized; imgMat: TPas_AI_ImageMatrix; L: TLearn);
var
  Pool_: TPas_AI_TECH_2022_DNN_Thread_Pool;
  i: Integer;
  Device_: TLIVec;
begin
  if L.InSize <> C_ZMetric_V2_Dim then
      RaiseInfo('Learn Engine Insize illegal');
  Pool_ := TPas_AI_TECH_2022_DNN_Thread_Pool.Create;

  GetComputeDeviceOfTraining(Device_);
  for i in Device_ do
      Pool_.BuildDeviceThread(FAI_TECH_2022_Entry, i, ThNum, TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2);
  for i := 0 to Pool_.Count - 1 do
      TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2(Pool_[i]).Open_Stream(ZMetric_V2_stream);

  for i := 0 to imgMat.Count - 1 do
      ZMetric_V2_Save_To_Learn_DNN_Thread(Jitter, Jitter_Num, Pool_, RSeri, imgMat[i], L);

  Pool_.Wait();
  DisposeObject(Pool_);
end;

class function TPas_AI_TECH_2022.Init_YOLO_X_Parameter(train_sync_file, train_output: U_String): PPas_AI_TECH_2022_YOLO_X_Train_Parameter;
begin
  new(Result);
  FillPtrByte(Result, SizeOf(TPas_AI_TECH_2022_YOLO_X_Train_Parameter), 0);

  { input }
  Result^.training_img := nil;
  Result^.training_img_num := 0;
  { training param }
  Result^.training_sync_file := AI_TECH_2022_Alloc_P_Bytes(train_sync_file);
  Result^.training_output := AI_TECH_2022_Alloc_P_Bytes(train_output);
  Result^.timeout := C_Tick_Week;
  { net param }
  Result^.iou_ignore_threshold := 0.7;
  Result^.iou_anchor_threshold := 0.2;
  Result^.begin_learning_rate := 0.001;
  Result^.complete_learning_rate := 0.0000000001;
  Result^.iterations_without_progress_threshold := 10000;
  Result^.prepare_unstable_step_num := 1000;
  Result^.learning_rate_shrink_factor := 0.1;
  { These are the anchors computed on user custom dataset, presented in the YOLO-X paper. }
  Result^.T8_1_X := 10;
  Result^.T8_1_Y := 13;
  Result^.T8_2_X := 16;
  Result^.T8_2_Y := 30;
  Result^.T8_3_X := 33;
  Result^.T8_3_Y := 23;
  Result^.T16_1_X := 30;
  Result^.T16_1_Y := 61;
  Result^.T16_2_X := 62;
  Result^.T16_2_Y := 45;
  Result^.T16_3_X := 59;
  Result^.T16_3_Y := 119;
  Result^.T32_1_X := 116;
  Result^.T32_1_Y := 90;
  Result^.T32_2_X := 156;
  Result^.T32_2_Y := 198;
  Result^.T32_3_X := 373;
  Result^.T32_3_Y := 326;
  { cropper param }
  Result^.batch_size := 8;
  Result^.max_object_size := 0.9;
  Result^.min_object_size_x := 20;
  Result^.min_object_size_y := 20;
  Result^.max_rotation_degrees := 10;
  Result^.translate_amount := 0.5;
  Result^.randomly_flip := 1;
  Result^.background_crops_fraction := 0;
  Result^.min_object_coverage := 0.8;
  Result^.alternate_between_cropping := 0.5;
  Result^.training_thread_num := 10;
  Result^.max_training_batch_queue_num := 1000;
  { test param }
  Result^.test_img := nil;
  Result^.test_img_num := 0;
  Result^.test_thread_num := 2;
  Result^.max_test_batch_queue_num := 100;
  Result^.test_steps := 100;
  { progress control }
  Result^.control := nil;
  { training result }
  Result^.training_average_loss := 0;
  Result^.training_learning_rate := 0;
end;

class procedure TPas_AI_TECH_2022.Free_YOLO_X_Parameter(param: PPas_AI_TECH_2022_YOLO_X_Train_Parameter);
begin
  AI_TECH_2022_Free_P_Bytes(param^.training_sync_file);
  AI_TECH_2022_Free_P_Bytes(param^.training_output);
  Dispose(param);
end;

function TPas_AI_TECH_2022.YOLO_X_DNN_Train(param: PPas_AI_TECH_2022_YOLO_X_Train_Parameter; train_imgList, test_imgList: TPas_AI_ImageList): Integer;
var
  Train_img_arry: array of TPas_AI_TECH_2022_Image_Handle;
  Train_img_arry_Ptr: array of PAI_TECH_2022_Image_Handle;
  Test_img_arry: array of TPas_AI_TECH_2022_Image_Handle;
  Test_img_arry_Ptr: array of PAI_TECH_2022_Image_Handle;
  i: Integer;
begin
  train_imgList.Remove_Null_Detector_Define_Image(True);
  test_imgList.Remove_Null_Detector_Define_Image(True);
  Check_and_Fixed_Test_Dataset(train_imgList, test_imgList);
  Result := -1;

  { prepare training dataset }
  SetLength(Train_img_arry, train_imgList.Count);
  SetLength(Train_img_arry_Ptr, train_imgList.Count);
  for i := 0 to train_imgList.Count - 1 do
    begin
      Train_img_arry[i].image := train_imgList[i];
      Train_img_arry_Ptr[i] := @Train_img_arry[i];
    end;

  { prepare training dataset }
  SetLength(Test_img_arry, test_imgList.Count);
  SetLength(Test_img_arry_Ptr, test_imgList.Count);
  for i := 0 to test_imgList.Count - 1 do
    begin
      Test_img_arry[i].image := test_imgList[i];
      Test_img_arry_Ptr[i] := @Test_img_arry[i];
    end;

  if (FAI_TECH_2022_Entry <> nil) and Assigned(FAI_TECH_2022_Entry^.YOLO_X_Train) then
    begin
      TrainingControl.pause := 0;
      TrainingControl.stop := 0;
      param^.control := @TrainingControl;
      FAI_TECH_2022_Entry^.Enabled_Trainer_Warning := True; { lv2 warning }

      if Length(Train_img_arry_Ptr) > 0 then
          param^.training_img := @Train_img_arry_Ptr[0]
      else
          param^.training_img := nil;
      param^.training_img_num := Length(Train_img_arry_Ptr);

      if Length(Test_img_arry_Ptr) > 0 then
          param^.test_img := @Test_img_arry_Ptr[0]
      else
          param^.test_img := nil;
      param^.test_img_num := Length(Test_img_arry_Ptr);

      try
          Result := FAI_TECH_2022_Entry^.YOLO_X_Train(param);
      except
          Result := -1;
      end;
      Last_training_average_loss := param^.training_average_loss;
      Last_training_learning_rate := param^.training_learning_rate;
    end;

  SetLength(Train_img_arry, 0);
  SetLength(Train_img_arry_Ptr, 0);
  SetLength(Test_img_arry, 0);
  SetLength(Test_img_arry_Ptr, 0);
end;

function TPas_AI_TECH_2022.YOLO_X_DNN_Train(param: PPas_AI_TECH_2022_YOLO_X_Train_Parameter; train_imgMat, test_imgMat: TPas_AI_ImageMatrix): Integer;
var
  Train_imgL, Test_imgL: TAI_Image_List_;
  Train_img_arry: array of TPas_AI_TECH_2022_Image_Handle;
  Train_img_arry_Ptr: array of PAI_TECH_2022_Image_Handle;
  Test_img_arry: array of TPas_AI_TECH_2022_Image_Handle;
  Test_img_arry_Ptr: array of PAI_TECH_2022_Image_Handle;
  i: Integer;
begin
  train_imgMat.Remove_Null_Detector_Define_Image(True);
  test_imgMat.Remove_Null_Detector_Define_Image(True);
  Check_and_Fixed_Test_Dataset(train_imgMat, test_imgMat);
  Result := -1;
  Train_imgL := train_imgMat.ImageList();
  Test_imgL := test_imgMat.ImageList();

  { prepare training dataset }
  SetLength(Train_img_arry, Train_imgL.Count);
  SetLength(Train_img_arry_Ptr, Train_imgL.Count);
  for i := 0 to Train_imgL.Count - 1 do
    begin
      Train_img_arry[i].image := Train_imgL[i];
      Train_img_arry_Ptr[i] := @Train_img_arry[i];
    end;

  { prepare training dataset }
  SetLength(Test_img_arry, Test_imgL.Count);
  SetLength(Test_img_arry_Ptr, Test_imgL.Count);
  for i := 0 to Test_imgL.Count - 1 do
    begin
      Test_img_arry[i].image := Test_imgL[i];
      Test_img_arry_Ptr[i] := @Test_img_arry[i];
    end;

  if (FAI_TECH_2022_Entry <> nil) and Assigned(FAI_TECH_2022_Entry^.YOLO_X_Train) then
    begin
      TrainingControl.pause := 0;
      TrainingControl.stop := 0;
      param^.control := @TrainingControl;
      FAI_TECH_2022_Entry^.Enabled_Trainer_Warning := True; { lv2 warning }

      if Length(Train_img_arry_Ptr) > 0 then
          param^.training_img := @Train_img_arry_Ptr[0]
      else
          param^.training_img := nil;
      param^.training_img_num := Length(Train_img_arry_Ptr);

      if Length(Test_img_arry_Ptr) > 0 then
          param^.test_img := @Test_img_arry_Ptr[0]
      else
          param^.test_img := nil;
      param^.test_img_num := Length(Test_img_arry_Ptr);

      try
          Result := FAI_TECH_2022_Entry^.YOLO_X_Train(param);
      except
          Result := -1;
      end;
      Last_training_average_loss := param^.training_average_loss;
      Last_training_learning_rate := param^.training_learning_rate;
    end;

  SetLength(Train_img_arry, 0);
  SetLength(Train_img_arry_Ptr, 0);
  SetLength(Test_img_arry, 0);
  SetLength(Test_img_arry_Ptr, 0);
  DisposeObject(Train_imgL);
  DisposeObject(Test_imgL);
end;

function TPas_AI_TECH_2022.YOLO_X_DNN_Train(param: PPas_AI_TECH_2022_YOLO_X_Train_Parameter; RSeri: TPasAI_RasterSerialized; train_imgList, test_imgList: TPas_AI_ImageList): Integer;
var
  Train_img_arry: array of TPas_AI_TECH_2022_Image_Handle;
  Train_img_arry_Ptr: array of PAI_TECH_2022_Image_Handle;
  Test_img_arry: array of TPas_AI_TECH_2022_Image_Handle;
  Test_img_arry_Ptr: array of PAI_TECH_2022_Image_Handle;
  i: Integer;
begin
  train_imgList.Remove_Null_Detector_Define_Image(True);
  test_imgList.Remove_Null_Detector_Define_Image(True);
  Check_and_Fixed_Test_Dataset(train_imgList, test_imgList);
  Result := -1;

  { prepare training dataset }
  SetLength(Train_img_arry, train_imgList.Count);
  SetLength(Train_img_arry_Ptr, train_imgList.Count);
  for i := 0 to train_imgList.Count - 1 do
    begin
      Train_img_arry[i].image := train_imgList[i];
      Train_img_arry_Ptr[i] := @Train_img_arry[i];
    end;

  { prepare training dataset }
  SetLength(Test_img_arry, test_imgList.Count);
  SetLength(Test_img_arry_Ptr, test_imgList.Count);
  for i := 0 to test_imgList.Count - 1 do
    begin
      Test_img_arry[i].image := test_imgList[i];
      Test_img_arry_Ptr[i] := @Test_img_arry[i];
    end;

  if (FAI_TECH_2022_Entry <> nil) and Assigned(FAI_TECH_2022_Entry^.YOLO_X_Train) then
    begin
      TrainingControl.pause := 0;
      TrainingControl.stop := 0;
      param^.control := @TrainingControl;
      FAI_TECH_2022_Entry^.Enabled_Trainer_Warning := True; { lv2 warning }

      if Length(Train_img_arry_Ptr) > 0 then
          param^.training_img := @Train_img_arry_Ptr[0]
      else
          param^.training_img := nil;
      param^.training_img_num := Length(Train_img_arry_Ptr);

      if Length(Test_img_arry_Ptr) > 0 then
          param^.test_img := @Test_img_arry_Ptr[0]
      else
          param^.test_img := nil;
      param^.test_img_num := Length(Test_img_arry_Ptr);

      RSeri.Clear_History;
      RSeri.Enabled_Read_History := True;
      FAI_TECH_2022_Entry^.RasterSerialized := RSeri;
      train_imgList.SerializedAndRecycleMemory(RSeri);
      test_imgList.SerializedAndRecycleMemory(RSeri);

      try
          Result := FAI_TECH_2022_Entry^.YOLO_X_Train(param);
      except
          Result := -1;
      end;
      Last_training_average_loss := param^.training_average_loss;
      Last_training_learning_rate := param^.training_learning_rate;

      RSeri.Clear_History;
      RSeri.Enabled_Read_History := False;
      FAI_TECH_2022_Entry^.RasterSerialized := nil;
    end;

  SetLength(Train_img_arry, 0);
  SetLength(Train_img_arry_Ptr, 0);
  SetLength(Test_img_arry, 0);
  SetLength(Test_img_arry_Ptr, 0);
end;

function TPas_AI_TECH_2022.YOLO_X_DNN_Train(param: PPas_AI_TECH_2022_YOLO_X_Train_Parameter; RSeri: TPasAI_RasterSerialized; train_imgMat, test_imgMat: TPas_AI_ImageMatrix): Integer;
var
  Train_imgL, Test_imgL: TAI_Image_List_;
  Train_img_arry: array of TPas_AI_TECH_2022_Image_Handle;
  Train_img_arry_Ptr: array of PAI_TECH_2022_Image_Handle;
  Test_img_arry: array of TPas_AI_TECH_2022_Image_Handle;
  Test_img_arry_Ptr: array of PAI_TECH_2022_Image_Handle;
  i: Integer;
begin
  train_imgMat.Remove_Null_Detector_Define_Image(True);
  test_imgMat.Remove_Null_Detector_Define_Image(True);
  Check_and_Fixed_Test_Dataset(train_imgMat, test_imgMat);
  Result := -1;
  Train_imgL := train_imgMat.ImageList();
  Test_imgL := test_imgMat.ImageList();

  { prepare training dataset }
  SetLength(Train_img_arry, Train_imgL.Count);
  SetLength(Train_img_arry_Ptr, Train_imgL.Count);
  for i := 0 to Train_imgL.Count - 1 do
    begin
      Train_img_arry[i].image := Train_imgL[i];
      Train_img_arry_Ptr[i] := @Train_img_arry[i];
    end;

  { prepare training dataset }
  SetLength(Test_img_arry, Test_imgL.Count);
  SetLength(Test_img_arry_Ptr, Test_imgL.Count);
  for i := 0 to Test_imgL.Count - 1 do
    begin
      Test_img_arry[i].image := Test_imgL[i];
      Test_img_arry_Ptr[i] := @Test_img_arry[i];
    end;

  if (FAI_TECH_2022_Entry <> nil) and Assigned(FAI_TECH_2022_Entry^.YOLO_X_Train) then
    begin
      TrainingControl.pause := 0;
      TrainingControl.stop := 0;
      param^.control := @TrainingControl;
      FAI_TECH_2022_Entry^.Enabled_Trainer_Warning := True; { lv2 warning }

      if Length(Train_img_arry_Ptr) > 0 then
          param^.training_img := @Train_img_arry_Ptr[0]
      else
          param^.training_img := nil;
      param^.training_img_num := Length(Train_img_arry_Ptr);

      if Length(Test_img_arry_Ptr) > 0 then
          param^.test_img := @Test_img_arry_Ptr[0]
      else
          param^.test_img := nil;
      param^.test_img_num := Length(Test_img_arry_Ptr);

      RSeri.Clear_History;
      RSeri.Enabled_Read_History := True;
      FAI_TECH_2022_Entry^.RasterSerialized := RSeri;
      train_imgMat.SerializedAndRecycleMemory(RSeri);
      test_imgMat.SerializedAndRecycleMemory(RSeri);

      try
          Result := FAI_TECH_2022_Entry^.YOLO_X_Train(param);
      except
          Result := -1;
      end;
      Last_training_average_loss := param^.training_average_loss;
      Last_training_learning_rate := param^.training_learning_rate;

      RSeri.Clear_History;
      RSeri.Enabled_Read_History := False;
      FAI_TECH_2022_Entry^.RasterSerialized := nil;
    end;

  SetLength(Train_img_arry, 0);
  SetLength(Train_img_arry_Ptr, 0);
  SetLength(Test_img_arry, 0);
  SetLength(Test_img_arry_Ptr, 0);
  DisposeObject(Train_imgL);
  DisposeObject(Test_imgL);
end;

function TPas_AI_TECH_2022.YOLO_X_DNN_Train_Stream(param: PPas_AI_TECH_2022_YOLO_X_Train_Parameter; train_imgList, test_imgList: TPas_AI_ImageList): TMS64;
var
  fn: U_String;
begin
  Result := nil;
  fn := AI_TECH_2022_Get_P_Bytes_String(param^.training_output);
  if (YOLO_X_DNN_Train(param, train_imgList, test_imgList) > 0) and (umlFileExists(fn)) then
    begin
      Result := TMS64.Create;
      Result.LoadFromFile(fn);
      Result.Position := 0;
    end;
end;

function TPas_AI_TECH_2022.YOLO_X_DNN_Train_Stream(param: PPas_AI_TECH_2022_YOLO_X_Train_Parameter; train_imgMat, test_imgMat: TPas_AI_ImageMatrix): TMS64;
var
  fn: U_String;
begin
  Result := nil;
  fn := AI_TECH_2022_Get_P_Bytes_String(param^.training_output);
  if (YOLO_X_DNN_Train(param, train_imgMat, test_imgMat) > 0) and (umlFileExists(fn)) then
    begin
      Result := TMS64.Create;
      Result.LoadFromFile(fn);
      Result.Position := 0;
    end;
end;

function TPas_AI_TECH_2022.YOLO_X_DNN_Train_Stream(param: PPas_AI_TECH_2022_YOLO_X_Train_Parameter; RSeri: TPasAI_RasterSerialized; train_imgList, test_imgList: TPas_AI_ImageList): TMS64;
var
  fn: U_String;
begin
  Result := nil;
  fn := AI_TECH_2022_Get_P_Bytes_String(param^.training_output);
  if (YOLO_X_DNN_Train(param, RSeri, train_imgList, test_imgList) > 0) and (umlFileExists(fn)) then
    begin
      Result := TMS64.Create;
      Result.LoadFromFile(fn);
      Result.Position := 0;
    end;
end;

function TPas_AI_TECH_2022.YOLO_X_DNN_Train_Stream(param: PPas_AI_TECH_2022_YOLO_X_Train_Parameter; RSeri: TPasAI_RasterSerialized; train_imgMat, test_imgMat: TPas_AI_ImageMatrix): TMS64;
var
  fn: U_String;
begin
  Result := nil;
  fn := AI_TECH_2022_Get_P_Bytes_String(param^.training_output);
  if (YOLO_X_DNN_Train(param, RSeri, train_imgMat, test_imgMat) > 0) and (umlFileExists(fn)) then
    begin
      Result := TMS64.Create;
      Result.LoadFromFile(fn);
      Result.Position := 0;
    end;
end;

function TPas_AI_TECH_2022.YOLO_X_Open(train_file: SystemString): TPas_AI_TECH_2022_YOLO_X_Handle;
var
  train_file_buff: P_Bytes;
begin
  if (FAI_TECH_2022_Entry <> nil) and Assigned(FAI_TECH_2022_Entry^.YOLO_X_Init) then
    begin
      train_file_buff := AI_TECH_2022_Alloc_P_Bytes(train_file);
      Result := FAI_TECH_2022_Entry^.YOLO_X_Init(train_file_buff);
      AI_TECH_2022_Free_P_Bytes(train_file_buff);
      if Result <> nil then
          DoStatus('YOLO-X open: %s', [train_file]);
    end
  else
      Result := nil;
end;

function TPas_AI_TECH_2022.YOLO_X_Open_Stream(stream: TMS64): TPas_AI_TECH_2022_YOLO_X_Handle;
begin
  if (FAI_TECH_2022_Entry <> nil) and Assigned(FAI_TECH_2022_Entry^.YOLO_X_Init_Memory) then
    begin
      Result := FAI_TECH_2022_Entry^.YOLO_X_Init_Memory(stream.memory, stream.Size);
      if Result <> nil then
          DoStatus('YOLO-X open memory %s size:%s', [umlPointerToStr(stream.memory).Text, umlSizeToStr(stream.Size).Text]);
    end
  else
      Result := nil;
end;

function TPas_AI_TECH_2022.YOLO_X_Open_Stream(train_file: SystemString): TPas_AI_TECH_2022_YOLO_X_Handle;
var
  m64: TMS64;
begin
  m64 := TMS64.Create;
  m64.LoadFromFile(train_file);
  Result := YOLO_X_Open_Stream(m64);
  DisposeObject(m64);
  if Result <> nil then
      DoStatus('YOLO-X open: %s', [train_file]);
end;

function TPas_AI_TECH_2022.YOLO_X_Close(var hnd: TPas_AI_TECH_2022_YOLO_X_Handle): Boolean;
begin
  if (FAI_TECH_2022_Entry <> nil) and Assigned(FAI_TECH_2022_Entry^.YOLO_X_Free) then
    begin
      Result := FAI_TECH_2022_Entry^.YOLO_X_Free(hnd) = 0;
      DoStatus('YOLO-X close.', []);
    end
  else
      Result := False;
end;

function TPas_AI_TECH_2022.YOLO_X_Process(hnd: TPas_AI_TECH_2022_YOLO_X_Handle; Raster: TMPasAI_Raster; threshold: Double; Filter_YOLO_Desc_: Boolean): TAI_TECH_2022_DESC;
var
  rect_num: Integer;
  buff: TPas_AI_TECH_2022_YOLO_Rect_Array;
  L: TAI_TECH_2022_DESC_POOL;
  i: Integer;
begin
  SetLength(Result, 0);
  if (FAI_TECH_2022_Entry <> nil) and Assigned(FAI_TECH_2022_Entry^.YOLO_X_Process_Image) then
    begin
      SetLength(buff, 2048);
      rect_num := FAI_TECH_2022_Entry^.YOLO_X_Process_Image(hnd, Raster.Bits, Raster.Width, Raster.Height, threshold, @buff[0], Length(buff));

      if rect_num >= 0 then
        begin
          L := TAI_TECH_2022_DESC_POOL.Create;

          for i := 0 to rect_num - 1 do
            begin
              with L.Add_Null^ do
                begin
                  Data.R := AI_TECH_2022_RectV2(buff[i]);
                  Data.confidence := buff[i].confidence;
                  Data.Token := buff[i].Token^;
                  API_AI_TECH_2022_FreeString(buff[i].Token);
                end;
            end;

          { filter box }
          if L.Num > 0 then
            begin
              with L.Repeat_ do
                repeat
                  if queue^.Data.Token.Same('ignore') { is ignore label }
                  or (not RectInRect(queue^.Data.R, Raster.BoundsRectV20)) then { clip out edge box }
                    L.Push_To_Recycle_Pool(queue);
                until not Next;
              L.Free_Recycle_Pool;

              if L.Num > 0 then
                begin
                  SetLength(Result, L.Num); { finish }
                  with L.Repeat_ do
                    repeat
                      Result[I__] := queue^.Data; { copy box }
                      queue^.Data.Token := '';
                    until not Next;
                end;

              if Filter_YOLO_Desc_ then
                  Filter_YOLO_Desc(Result);
            end;

          DisposeObject(L);
        end;
      SetLength(buff, 0);
    end;
end;

function TPas_AI_TECH_2022.YOLO_X_Process(hnd: TPas_AI_TECH_2022_YOLO_X_Handle; Raster: TMPasAI_Raster; threshold: Double): TAI_TECH_2022_DESC;
begin
  Result := YOLO_X_Process(hnd, Raster, threshold, True);
end;

function TPas_AI_TECH_2022.YOLO_X_Process_HD_4X(hnd: TPas_AI_TECH_2022_YOLO_X_Handle; Raster: TMPasAI_Raster; threshold, overlap_supression: Double; bilinear_sampling: Boolean): TAI_TECH_2022_DESC;
const
  C_YOLO_Core_Size = 416;
var
  fit_r: TRectV2;
  fit_raster: TMPasAI_Raster;
  R_Arry: array [0 .. 5] of TRectV2;
  Raster_Arry: array [0 .. 5] of TMPasAI_Raster;
  DESC_Arry: array [0 .. 5] of TAI_TECH_2022_DESC;
  i, j: Integer;
  L: TAI_TECH_2022_DESC_PTR_POOL;
  Box_Tool: TNearest_Box_Tool;
  p: TAI_TECH_2022_DESC_PTR_POOL.PQueueStruct;
  procedure Transform_Rect_(var R1: TRectV2; const R2: TRectV2);
  begin
    R1 := RoundRectV2(RectProjection(fit_raster.BoundsRectV2, fit_r, RectProjection(RectV2(0, 0, C_YOLO_Core_Size, C_YOLO_Core_Size), R2, R1)));
  end;

begin
  { build 4x projection }
  fit_r := RectFit(RectV2(0, 0, C_YOLO_Core_Size * 2, C_YOLO_Core_Size * 2), Raster.BoundsRectV20, True);
  fit_raster := TMPasAI_Raster.Create;
  fit_raster.SetSizeF(C_YOLO_Core_Size * 2, C_YOLO_Core_Size * 2, RColor(0, 0, 0, $FF));
  fit_raster.Vertex.LocalParallel := False;
  Raster.ProjectionTo(fit_raster, fit_r, fit_raster.BoundsRectV20, bilinear_sampling, 1.0);
  R_Arry[0] := RectV2(0, 0, C_YOLO_Core_Size, C_YOLO_Core_Size);
  R_Arry[1] := RectAdd(R_Arry[0], Vec2(C_YOLO_Core_Size * 0.5, 0));
  R_Arry[2] := RectAdd(R_Arry[0], Vec2(C_YOLO_Core_Size, 0));
  R_Arry[3] := RectAdd(R_Arry[0], Vec2(0, C_YOLO_Core_Size * 0.5));
  R_Arry[4] := RectAdd(R_Arry[0], Vec2(0, C_YOLO_Core_Size));
  R_Arry[5] := RectAdd(R_Arry[0], Vec2(C_YOLO_Core_Size, C_YOLO_Core_Size));
  for i := 0 to 5 do
    begin
      Raster_Arry[i] := TMPasAI_Raster.Create;
      Raster_Arry[i].SetSize(C_YOLO_Core_Size, C_YOLO_Core_Size);
      fit_raster.DrawTo(Raster_Arry[i], 0, 0, RoundRect(R_Arry[i]));
    end;
  { process 4x projection }
  for i := 0 to 5 do
      DESC_Arry[i] := YOLO_X_Process(hnd, Raster_Arry[i], threshold, False);
  { extract projection }
  L := TAI_TECH_2022_DESC_PTR_POOL.Create;
  Box_Tool := TNearest_Box_Tool.Create;
  for i := 0 to 5 do
    for j := 0 to Length(DESC_Arry[i]) - 1 do
      begin
        Transform_Rect_(DESC_Arry[i, j].R, R_Arry[i]);
        if RectInRect(DESC_Arry[i, j].R, Raster.BoundsRectV2) then
          begin
            p := L.Add(@DESC_Arry[i, j]);
            Box_Tool.Add_Box(@p^.Data^.R, p, nil);
          end;
      end;
  Box_Tool.Compute_Nearest_Box(0, 0);
  { IoU overlap supression }
  if Box_Tool.IoU_Tool.Num > 0 then
    with Box_Tool.IoU_Tool.Repeat_ do
      repeat
        if queue^.Data.R1A < queue^.Data.R2A then
          begin
            if queue^.Data.RA / queue^.Data.R1A > overlap_supression then
                L.Push_To_Recycle_Pool(queue^.Data.p1^.UserData);
          end
        else
          begin
            if queue^.Data.RA / queue^.Data.R2A > overlap_supression then
                L.Push_To_Recycle_Pool(queue^.Data.p2^.UserData);
          end;
      until not Next;
  L.Free_Recycle_Pool;
  { extract result }
  SetLength(Result, L.Num);
  if L.Num > 0 then
    with L.Repeat_ do
      repeat
        Result[I__] := queue^.Data^;
        queue^.Data^.Token := '';
      until not Next;
  { free }
  DisposeObject(fit_raster);
  for i := 0 to 5 do
    begin
      DisposeObject(Raster_Arry[i]);
      SetLength(DESC_Arry[i], 0);
    end;
  DisposeObject(L);
  DisposeObject(Box_Tool);
end;

function TPas_AI_TECH_2022.YOLO_X_Process_HD_16X(hnd: TPas_AI_TECH_2022_YOLO_X_Handle; Raster: TMPasAI_Raster; threshold, overlap_supression: Double; bilinear_sampling: Boolean): TAI_TECH_2022_DESC;
const
  C_YOLO_Core_Size = 832;
var
  fit_r: TRectV2;
  fit_raster: TMPasAI_Raster;
  R_Arry: array [0 .. 5] of TRectV2;
  Raster_Arry: array [0 .. 5] of TMPasAI_Raster;
  DESC_Arry: array [0 .. 5] of TAI_TECH_2022_DESC;
  i, j: Integer;
  L: TAI_TECH_2022_DESC_PTR_POOL;
  Box_Tool: TNearest_Box_Tool;
  p: TAI_TECH_2022_DESC_PTR_POOL.PQueueStruct;
  procedure Transform_Rect_(var R1: TRectV2; const R2: TRectV2);
  begin
    R1 := RoundRectV2(RectProjection(fit_raster.BoundsRectV2, fit_r, RectProjection(RectV2(0, 0, C_YOLO_Core_Size, C_YOLO_Core_Size), R2, R1)));
  end;

begin
  { build 4x projection }
  fit_r := RectFit(RectV2(0, 0, C_YOLO_Core_Size * 2, C_YOLO_Core_Size * 2), Raster.BoundsRectV20, True);
  fit_raster := TMPasAI_Raster.Create;
  fit_raster.SetSizeF(C_YOLO_Core_Size * 2, C_YOLO_Core_Size * 2, RColor(0, 0, 0, $FF));
  fit_raster.Vertex.LocalParallel := False;
  Raster.ProjectionTo(fit_raster, fit_r, fit_raster.BoundsRectV20, bilinear_sampling, 1.0);
  R_Arry[0] := RectV2(0, 0, C_YOLO_Core_Size, C_YOLO_Core_Size);
  R_Arry[1] := RectAdd(R_Arry[0], Vec2(C_YOLO_Core_Size * 0.5, 0));
  R_Arry[2] := RectAdd(R_Arry[0], Vec2(C_YOLO_Core_Size, 0));
  R_Arry[3] := RectAdd(R_Arry[0], Vec2(0, C_YOLO_Core_Size * 0.5));
  R_Arry[4] := RectAdd(R_Arry[0], Vec2(0, C_YOLO_Core_Size));
  R_Arry[5] := RectAdd(R_Arry[0], Vec2(C_YOLO_Core_Size, C_YOLO_Core_Size));
  for i := 0 to 5 do
    begin
      Raster_Arry[i] := TMPasAI_Raster.Create;
      Raster_Arry[i].SetSize(C_YOLO_Core_Size, C_YOLO_Core_Size);
      fit_raster.DrawTo(Raster_Arry[i], 0, 0, RoundRect(R_Arry[i]));
    end;
  { process 4x projection }
  for i := 0 to 5 do
      DESC_Arry[i] := YOLO_X_Process_HD_4X(hnd, Raster_Arry[i], threshold, overlap_supression, bilinear_sampling);
  { extract projection }
  L := TAI_TECH_2022_DESC_PTR_POOL.Create;
  Box_Tool := TNearest_Box_Tool.Create;
  for i := 0 to 5 do
    for j := 0 to Length(DESC_Arry[i]) - 1 do
      begin
        Transform_Rect_(DESC_Arry[i, j].R, R_Arry[i]);
        if RectInRect(DESC_Arry[i, j].R, Raster.BoundsRectV2) then
          begin
            p := L.Add(@DESC_Arry[i, j]);
            Box_Tool.Add_Box(@p^.Data^.R, p, nil);
          end;
      end;
  Box_Tool.Compute_Nearest_Box(0, 0);
  { IoU overlap supression }
  if Box_Tool.IoU_Tool.Num > 0 then
    with Box_Tool.IoU_Tool.Repeat_ do
      repeat
        if queue^.Data.R1A < queue^.Data.R2A then
          begin
            if queue^.Data.RA / queue^.Data.R1A > overlap_supression then
                L.Push_To_Recycle_Pool(queue^.Data.p1^.UserData);
          end
        else
          begin
            if queue^.Data.RA / queue^.Data.R2A > overlap_supression then
                L.Push_To_Recycle_Pool(queue^.Data.p2^.UserData);
          end;
      until not Next;
  L.Free_Recycle_Pool;
  { extract result }
  SetLength(Result, L.Num);
  if L.Num > 0 then
    with L.Repeat_ do
      repeat
        Result[I__] := queue^.Data^;
        queue^.Data^.Token := '';
      until not Next;
  { free }
  DisposeObject(fit_raster);
  for i := 0 to 5 do
    begin
      DisposeObject(Raster_Arry[i]);
      SetLength(DESC_Arry[i], 0);
    end;
  DisposeObject(L);
  DisposeObject(Box_Tool);
end;

function TPas_AI_TECH_2022.YOLO_X_Process_HD_Auto(hnd: TPas_AI_TECH_2022_YOLO_X_Handle; Raster: TMPasAI_Raster; threshold: Double): TAI_TECH_2022_DESC;
const
  C_YOLO_Core_Size = 416;
var
  k: Double;
begin
  k := MaxF(Raster.Size2D) / C_YOLO_Core_Size;
  if k > 8 then
      Result := YOLO_X_Process_HD_16X(hnd, Raster, threshold, 0.9, True)
  else if k > 4 then
      Result := YOLO_X_Process_HD_4X(hnd, Raster, threshold, 0.9, True)
  else
      Result := YOLO_X_Process(hnd, Raster, threshold);
end;

function TPas_AI_TECH_2022.YOLO_X_DebugInfo(hnd: TPas_AI_TECH_2022_YOLO_X_Handle): U_String;
var
  p: PPascalString;
begin
  Result := '';
  if (FAI_TECH_2022_Entry <> nil) and Assigned(FAI_TECH_2022_Entry^.YOLO_X_DebugInfo) then
    begin
      FAI_TECH_2022_Entry^.YOLO_X_DebugInfo(hnd, p);
      Result := p^;
      API_AI_TECH_2022_FreeString(p);
    end;
end;

class function TPas_AI_TECH_2022.Init_SSL_Parameter(train_sync_file, train_output: U_String): PPas_AI_TECH_2022_SSL_Train_Parameter;
begin
  new(Result);
  FillPtrByte(Result, SizeOf(TPas_AI_TECH_2022_SSL_Train_Parameter), 0);

  Result^.images := nil;
  Result^.img_num := 0;
  Result^.training_sync_file := AI_TECH_2022_Alloc_P_Bytes(train_sync_file);
  Result^.training_output := AI_TECH_2022_Alloc_P_Bytes(train_output);
  Result^.timeout := C_Tick_Day * 30;

  { trainer }
  Result^.iterations_without_progress_threshold := 1000;
  Result^.min_learning_rate := 0.00001;
  Result^.learning_rate := 0.001;
  Result^.completed_learning_rate := 0.00001;
  Result^.batch_num := 64;
  Result^.dims := 128;
  Result^.lambda := 1.0 / 128;

  { jitter }
  Result^.Max_Data_Queue := 100;
  Result^.jitter_thread_num := 10;
  Result^.scale_size_x := 0.8;
  Result^.scale_size_y := 0.8;
  Result^.scale_pos_x := 0.5;
  Result^.scale_pos_y := 0.5;
  Result^.XY_Offset_Scale := 0.2;
  Result^.Rotate := 20;
  Result^.Scale := 0.1;
  Result^.sampling_size_x := 32;
  Result^.sampling_size_y := 32;
  Result^.Fit_Matrix_Box := 1;
  Result^.lock_sampler := 1;

  { transform frequency }
  Result^.left_right_flip := 0.5;
  Result^.disturb_colors := 0.8;
  Result^.grayscale := 0.2;

  { loop control }
  Result^.control := nil;
  { result }
  Result^.training_average_loss := 0;
  Result^.training_learning_rate := 0;
end;

class procedure TPas_AI_TECH_2022.Free_SSL_Parameter(param: PPas_AI_TECH_2022_SSL_Train_Parameter);
begin
  AI_TECH_2022_Free_P_Bytes(param^.training_sync_file);
  AI_TECH_2022_Free_P_Bytes(param^.training_output);
  Dispose(param);
end;

function TPas_AI_TECH_2022.SSL_Train(LargeScale_: Boolean; RSeri: TPasAI_RasterSerialized; images: PAI_TECH_2022_Image_Array; img_num: Integer; param: PPas_AI_TECH_2022_SSL_Train_Parameter): Boolean;
begin
  Result := False;

  if FAI_TECH_2022_Entry = nil then
      exit;
  if not Assigned(FAI_TECH_2022_Entry^.SSL_Full_GPU_Train) then
      exit;

  { set arry }
  param^.images := images;
  param^.img_num := img_num;
  param^.control := @TrainingControl;

  { update control }
  TrainingControl.pause := 0;
  TrainingControl.stop := 0;

  { update RasterSerialized }
  if LargeScale_ then
    begin
      RSeri.Clear_History;
      RSeri.Enabled_Read_History := True;
      FAI_TECH_2022_Entry^.RasterSerialized := RSeri;
      RSeri.Enabled_Read_History := True;
    end
  else
      FAI_TECH_2022_Entry^.RasterSerialized := nil;

  FAI_TECH_2022_Entry^.SerializedTime := GetTimeTick();

  { run training }
  try
      Result := FAI_TECH_2022_Entry^.SSL_Full_GPU_Train(param) >= 0
  except
      Result := False;
  end;

  if LargeScale_ then
    begin
      RSeri.Clear_History;
      RSeri.Enabled_Read_History := False;
      FAI_TECH_2022_Entry^.RasterSerialized := nil;
    end;

  Last_training_average_loss := param^.training_average_loss;
  Last_training_learning_rate := param^.training_learning_rate;
end;

function TPas_AI_TECH_2022.SSL_Train(LargeScale_: Boolean; RSeri: TPasAI_RasterSerialized; imgMat: TPas_AI_ImageMatrix; param: PPas_AI_TECH_2022_SSL_Train_Parameter): Boolean;
var
  i, j, k, sum_: Integer;
  img_hnd_arry: array of TPas_AI_TECH_2022_Image_Handle;
  img_hnd_ptr_arry: array of PAI_TECH_2022_Image_Handle;
begin
  Result := False;
  sum_ := 0;
  for i := 0 to imgMat.Count - 1 do
      inc(sum_, imgMat[i].Count);

  if sum_ <= 0 then
      exit;

  SetLength(img_hnd_arry, sum_);
  SetLength(img_hnd_ptr_arry, sum_);
  k := 0;
  for i := 0 to imgMat.Count - 1 do
    for j := 0 to imgMat[i].Count - 1 do
      begin
        img_hnd_arry[k].image := imgMat[i][j];
        img_hnd_ptr_arry[k] := @img_hnd_arry[k];
        inc(k);
      end;
  Result := SSL_Train(LargeScale_, RSeri, @img_hnd_ptr_arry[0], sum_, param);
end;

function TPas_AI_TECH_2022.SSL_Train(imgList: TPas_AI_ImageList; param: PPas_AI_TECH_2022_SSL_Train_Parameter): Boolean;
var
  i, k, sum_: Integer;
  img_hnd_arry: array of TPas_AI_TECH_2022_Image_Handle;
  img_hnd_ptr_arry: array of PAI_TECH_2022_Image_Handle;
begin
  Result := False;
  sum_ := imgList.Count;
  if sum_ <= 0 then
      exit;

  SetLength(img_hnd_arry, sum_);
  SetLength(img_hnd_ptr_arry, sum_);
  k := 0;
  for i := 0 to imgList.Count - 1 do
    begin
      img_hnd_arry[k].image := imgList[i];
      img_hnd_ptr_arry[k] := @img_hnd_arry[k];
      inc(k);
    end;
  Result := SSL_Train(False, nil, @img_hnd_ptr_arry[0], sum_, param);
end;

function TPas_AI_TECH_2022.SSL_Train_Stream(imgList: TPas_AI_ImageList; param: PPas_AI_TECH_2022_SSL_Train_Parameter): TMS64;
var
  fn: U_String;
begin
  Result := nil;

  if SSL_Train(imgList, param) then
    begin
      fn := AI_TECH_2022_Get_P_Bytes_String(param^.training_output);
      if umlFileExists(fn) then
        begin
          Result := TMS64.Create;
          Result.LoadFromFile(fn);
          Result.Position := 0;
        end;
    end;
end;

function TPas_AI_TECH_2022.SSL_Train_Stream(imgMat: TPas_AI_ImageMatrix; param: PPas_AI_TECH_2022_SSL_Train_Parameter): TMS64;
var
  fn: U_String;
begin
  Result := nil;

  if SSL_Train(False, nil, imgMat, param) then
    begin
      fn := AI_TECH_2022_Get_P_Bytes_String(param^.training_output);
      if umlFileExists(fn) then
        begin
          Result := TMS64.Create;
          Result.LoadFromFile(fn);
          Result.Position := 0;
        end;
    end;
end;

function TPas_AI_TECH_2022.SSL_Train_Stream(LargeScale_: Boolean; RSeri: TPasAI_RasterSerialized; imgMat: TPas_AI_ImageMatrix; param: PPas_AI_TECH_2022_SSL_Train_Parameter): TMS64;
var
  fn: U_String;
begin
  Result := nil;

  if SSL_Train(LargeScale_, RSeri, imgMat, param) then
    begin
      fn := AI_TECH_2022_Get_P_Bytes_String(param^.training_output);
      if umlFileExists(fn) then
        begin
          Result := TMS64.Create;
          Result.LoadFromFile(fn);
          Result.Position := 0;
        end;
    end;
end;

class function TPas_AI_TECH_2022.Build_SSL_Learn: TLearn;
var
  L: TLearn;
begin
  L := TLearn.CreateClassifier(ltKDT, C_SSL_Dim);
  Result := L;
end;

class function TPas_AI_TECH_2022.Process_SSL_Token(L_: TLearn; Input_: TLVec; Filter_Min_, Filter_Max_: TLFloat; var MinK_: TLFloat): U_String;
var
  hPool: TCandidate_Distance_Hash_Pool;
  pool: TCandidate_Distance_Pool;
begin
  Result := '';
  MinK_ := 0;
  if Length(Input_) <> C_SSL_Dim then
      exit;
  hPool := L_.ProcessMaxIndexCandidate_Pool(Input_, Filter_Min_, Filter_Max_);
  pool := hPool.Get_Min_Mean_Pool;
  if pool <> nil then
    begin
      MinK_ := pool.Min_Distance;
      Result := pool.Name;
    end
  else if Length(hPool.buff) > 0 then
    begin
      MinK_ := hPool.buff[0].Distance_;
      Result := hPool.buff[0].Memory_^.Token;
    end;
  DisposeObject(hPool);
end;

class function TPas_AI_TECH_2022.Process_SSL_Token(L_: TLearn; Input_: TLVec; var MinK_: TLFloat): U_String;
begin
  Result := TPas_AI_TECH_2022.Process_SSL_Token(L_, Input_, 0, 1, MinK_);
end;

class function TPas_AI_TECH_2022.Fast_Process_SSL_Token(L_: TLearn; Input_: TLVec; var MinK_: TLFloat): U_String;
var
  Searched_Min_Distance: Double;
  i: TLInt;
begin
  Result := '';
  MinK_ := 0;
  if Length(Input_) <> C_SSL_Dim then
      exit;
  i := L_.Fast_Search_Nearest_K(Input_, Searched_Min_Distance);
  if (i >= 0) then
    begin
      Result := L_[i]^.Token;
      MinK_ := Searched_Min_Distance;
    end;
end;

class function TPas_AI_TECH_2022.Fast_Process_SSL_Token(L_: TLearn; Input_: TLMatrix; var MinK_: TLFloat): U_String;
var
  Pool_: TCandidate_Distance_Hash_Pool;
begin
  Result := '';
  MinK_ := 0;
  Pool_ := L_.Fast_Search_Nearest_K_Candidate(Input_, 0, 0);
  if Pool_ = nil then
      exit;
  with Pool_.Get_Min_Mean_Pool do
    begin
      Result := Name;
      MinK_ := Min_Distance;
    end;
  DisposeObject(Pool_);
end;

class function TPas_AI_TECH_2022.Fast_Process_SSL_Token(L_: TLearn; Input_: TLMatrix; var MinK_: TLFloat; var C: TCandidate_Distance_): U_String;
var
  Pool_: TCandidate_Distance_Hash_Pool;
begin
  Result := '';
  MinK_ := 0;
  C.Index_ := -1;
  C.Memory_ := nil;
  C.Distance_ := -1;
  Pool_ := L_.Fast_Search_Nearest_K_Candidate(Input_, 0, 0);
  if Pool_ = nil then
      exit;
  with Pool_.Get_Min_Mean_Pool do
    begin
      Result := Name;
      MinK_ := Min_Distance;
      C := Min_Distance_Ptr^;
    end;
  DisposeObject(Pool_);
end;

function TPas_AI_TECH_2022.SSL_Open_Face_Classifier(): TPas_AI_TECH_2022_SSL_Handle;
var
  m64: TMS64;
begin
  On_Wait_AI_Init;
  m64 := TMS64.Create;
  m64.SetPointerWithProtectedMode(build_in_SSL_Face_Classifier_memory, build_in_SSL_Face_Classifier_memory_Siz);
  Result := SSL_Open_Stream(m64);
  DisposeObject(m64);
end;

function TPas_AI_TECH_2022.SSL_Open_BBC(): TPas_AI_TECH_2022_SSL_Handle;
var
  m64: TMS64;
begin
  On_Wait_AI_Init;
  m64 := TMS64.Create;
  m64.SetPointerWithProtectedMode(build_in_SSL_BBC_memory, build_in_SSL_BBC_memory_Siz);
  Result := SSL_Open_Stream(m64);
  DisposeObject(m64);
end;

function TPas_AI_TECH_2022.SSL_Open(train_file: SystemString): TPas_AI_TECH_2022_SSL_Handle;
var
  train_file_buff: P_Bytes;
begin
  if (FAI_TECH_2022_Entry <> nil) and Assigned(FAI_TECH_2022_Entry^.SSL_Init) then
    begin
      train_file_buff := AI_TECH_2022_Alloc_P_Bytes(train_file);
      Result := FAI_TECH_2022_Entry^.SSL_Init(train_file_buff);
      AI_TECH_2022_Free_P_Bytes(train_file_buff);
      if Result <> nil then
          DoStatus('SSL open: %s', [train_file]);
    end
  else
      Result := nil;
end;

function TPas_AI_TECH_2022.SSL_Open_Stream(stream: TMS64): TPas_AI_TECH_2022_SSL_Handle;
begin
  if (FAI_TECH_2022_Entry <> nil) and Assigned(FAI_TECH_2022_Entry^.SSL_Init_Memory) then
    begin
      Result := FAI_TECH_2022_Entry^.SSL_Init_Memory(stream.memory, stream.Size);
      if Result <> nil then
          DoStatus('SSL open memory %s size:%s', [umlPointerToStr(stream.memory).Text, umlSizeToStr(stream.Size).Text]);
    end
  else
      Result := nil;
end;

function TPas_AI_TECH_2022.SSL_Open_Stream(train_file: SystemString): TPas_AI_TECH_2022_SSL_Handle;
var
  m64: TMS64;
begin
  m64 := TMS64.Create;
  m64.LoadFromFile(train_file);
  Result := SSL_Open_Stream(m64);
  DisposeObject(m64);
  if Result <> nil then
      DoStatus('SSL open: %s', [train_file]);
end;

function TPas_AI_TECH_2022.SSL_Close(var hnd: TPas_AI_TECH_2022_SSL_Handle): Boolean;
begin
  if (FAI_TECH_2022_Entry <> nil) and Assigned(FAI_TECH_2022_Entry^.SSL_Free) and (hnd <> nil) then
    begin
      Result := FAI_TECH_2022_Entry^.SSL_Free(hnd) = 0;
      DoStatus('SSL close.', []);
    end
  else
      Result := False;

  hnd := nil;
end;

function TPas_AI_TECH_2022.SSL_Get_Jitter_Value(hnd: TPas_AI_TECH_2022_SSL_Handle;
var scale_size, scale_pos: TVec2; var XY_Offset_Scale, Rotate, Scale: TGeoFloat; var sampling_size: TVec2;
var Fit_Matrix_Box, lock_sampler: Boolean; var batch_num: Integer): Boolean;
var
  tmp_scale_size_x, tmp_scale_size_y, tmp_scale_pos_x, tmp_scale_pos_y, tmp_XY_Offset_Scale, tmp_Rotate, tmp_Scale, tmp_sampling_size_x, tmp_sampling_size_y: Double;
  tmp_Fit_Matrix_Box, tmp_lock_sampler, tmp_batch_num: Integer;
begin
  Result := False;
  if (FAI_TECH_2022_Entry <> nil) and Assigned(FAI_TECH_2022_Entry^.SSL_Get_Jitter_Value) and (hnd <> nil) then
    begin
      { get origin jitter }
      FAI_TECH_2022_Entry^.SSL_Get_Jitter_Value(hnd,
        tmp_scale_size_x, tmp_scale_size_y, tmp_scale_pos_x, tmp_scale_pos_y, tmp_XY_Offset_Scale, tmp_Rotate, tmp_Scale, tmp_sampling_size_x, tmp_sampling_size_y,
        tmp_Fit_Matrix_Box, tmp_lock_sampler, tmp_batch_num);
      { translate }
      scale_size := Vec2(tmp_scale_size_x, tmp_scale_size_y);
      scale_pos := Vec2(tmp_scale_pos_x, tmp_scale_pos_y);
      XY_Offset_Scale := tmp_XY_Offset_Scale;
      Rotate := tmp_Rotate;
      Scale := tmp_Scale;
      sampling_size := Vec2(tmp_sampling_size_x, tmp_sampling_size_y);
      Fit_Matrix_Box := tmp_Fit_Matrix_Box > 0;
      lock_sampler := tmp_lock_sampler > 0;
      batch_num := tmp_batch_num;
      Result := True;
    end;
end;

function TPas_AI_TECH_2022.SSL_Process(hnd: TPas_AI_TECH_2022_SSL_Handle; arry: TMR_Array; output: PDouble; output_size: Integer): Integer;
var
  scale_size, scale_pos: TVec2;
  XY_Offset_Scale, Rotate, Scale: TGeoFloat;
  sampling_size: TVec2;
  Fit_Matrix_Box, lock_sampler: Boolean;
  batch_num: Integer;
  i: Integer;
  raster_hnd_source: array of TPas_AI_TECH_2022_Raster_Handle;
  raster_data_source: array of TPas_AI_TECH_2022_Raster_Data;
  raster_data_source_ptr: array of PAI_TECH_2022_Raster_Data;
begin
  Result := -1;
  if (FAI_TECH_2022_Entry <> nil) and Assigned(FAI_TECH_2022_Entry^.SSL_Get_Jitter_Value) and Assigned(FAI_TECH_2022_Entry^.SSL_Process) and (hnd <> nil) and (Length(arry) > 0) then
    begin
      SSL_Get_Jitter_Value(hnd, scale_size, scale_pos, XY_Offset_Scale, Rotate, Scale, sampling_size, Fit_Matrix_Box, lock_sampler, batch_num);

      SetLength(raster_hnd_source, Length(arry));
      SetLength(raster_data_source, Length(arry));
      SetLength(raster_data_source_ptr, Length(arry));
      for i := 0 to Length(arry) - 1 do
        begin
          if (arry[i].Width <> round(sampling_size[0])) or (arry[i].Height <> round(sampling_size[1])) then
              raster_hnd_source[i].Raster := arry[i].FitScaleAsNew(round(sampling_size[0]), round(sampling_size[1]))
          else
              raster_hnd_source[i].Raster := arry[i];
          raster_data_source[i].raster_Hnd := @raster_hnd_source[i];
          raster_data_source[i].raster_ptr := raster_hnd_source[i].Raster.Bits;
          raster_data_source[i].Width := raster_hnd_source[i].Raster.Width;
          raster_data_source[i].Height := raster_hnd_source[i].Raster.Height;
          raster_data_source[i].Index := i;
          raster_data_source_ptr[i] := @raster_data_source[i];
        end;

      try
          i := FAI_TECH_2022_Entry^.SSL_Process(hnd, raster_data_source_ptr[0], Length(arry), output, output_size);
      except
          i := 0;
      end;
      if i > output_size then
          RaiseInfo('SSL Model error: memory too little.');
      Result := i;

      for i := 0 to Length(arry) - 1 do
        if raster_hnd_source[i].Raster <> arry[i] then
            DisposeObject(raster_hnd_source[i].Raster);
      SetLength(raster_hnd_source, 0);
      SetLength(raster_data_source, 0);
      SetLength(raster_data_source_ptr, 0);
    end;
end;

function TPas_AI_TECH_2022.SSL_Process(hnd: TPas_AI_TECH_2022_SSL_Handle; img: TMPasAI_Raster; jitter_random: Boolean; Jitter_Num: Integer; var output_sampling: TArrayV2R4): TLMatrix;
var
  scale_size, scale_pos: TVec2;
  XY_Offset_Scale, Rotate, Scale: TGeoFloat;
  sampling_size: TVec2;
  Fit_Matrix_Box, lock_sampler: Boolean;
  batch_num: Integer;
  Rand: TMT19937Random;
  i, j: Integer;
  arry: TMR_Array;
  V: TLVec;
begin
  Result := LMatrix(0, 0);
  SetLength(output_sampling, 0);
  if SSL_Get_Jitter_Value(hnd, scale_size, scale_pos, XY_Offset_Scale, Rotate, Scale, sampling_size, Fit_Matrix_Box, lock_sampler, batch_num) then
    begin
      Rand := TMT19937Random.Create;
      if jitter_random then
          Rand.Rndmize
      else
          Rand.seed := 0;

      if Jitter_Num < 1 then
          Jitter_Num := 1;

      try
        SetLength(arry, Jitter_Num);
        SetLength(output_sampling, Jitter_Num);
        arry[0] := img.Build_Fit_Box_Raster(scale_size, scale_pos, sampling_size, Fit_Matrix_Box, lock_sampler, output_sampling[0]);
        for i := 1 to Jitter_Num - 1 do
            arry[i] := img.Build_Jitter_Fit_Box_Raster(Rand, scale_size, scale_pos, XY_Offset_Scale, Rotate, Scale, Fit_Matrix_Box, sampling_size, lock_sampler, output_sampling[i]);
        SetLength(V, Jitter_Num * C_SSL_Dim);
        if SSL_Process(hnd, arry, @V[0], Jitter_Num * C_SSL_Dim) = Jitter_Num * C_SSL_Dim then
          begin
            Result := LMatrix(Jitter_Num, C_SSL_Dim);
            for i := 0 to Jitter_Num - 1 do
              for j := 0 to C_SSL_Dim - 1 do
                  Result[i, j] := V[(i * C_SSL_Dim) + j];
          end;
        SetLength(V, 0);
        for i := 0 to Jitter_Num - 1 do
            DisposeObject(arry[i]);
      finally
          DisposeObject(Rand);
      end;
    end;
end;

function TPas_AI_TECH_2022.SSL_Process(hnd: TPas_AI_TECH_2022_SSL_Handle; img: TMPasAI_Raster;
scale_size, scale_pos: TVec2; XY_Offset_Scale, Rotate, Scale: TGeoFloat; sampling_size: TVec2; Fit_Matrix_Box, lock_sampler: Boolean;
jitter_random: Boolean; Jitter_Num: Integer; var output_sampling: TArrayV2R4): TLMatrix;
var
  Rand: TMT19937Random;
  i, j: Integer;
  arry: TMR_Array;
  V: TLVec;
begin
  Result := LMatrix(0, 0);
  SetLength(output_sampling, 0);
  Rand := TMT19937Random.Create;
  if jitter_random then
      Rand.Rndmize
  else
      Rand.seed := 0;

  if Jitter_Num < 1 then
      Jitter_Num := 1;

  try
    SetLength(arry, Jitter_Num);
    SetLength(output_sampling, Jitter_Num);
    arry[0] := img.Build_Fit_Box_Raster(scale_size, scale_pos, sampling_size, Fit_Matrix_Box, lock_sampler, output_sampling[0]);
    for i := 1 to Jitter_Num - 1 do
        arry[i] := img.Build_Jitter_Fit_Box_Raster(Rand, scale_size, scale_pos, XY_Offset_Scale, Rotate, Scale, Fit_Matrix_Box, sampling_size, lock_sampler, output_sampling[i]);
    SetLength(V, Jitter_Num * C_SSL_Dim);
    if SSL_Process(hnd, arry, @V[0], Jitter_Num * C_SSL_Dim) = Jitter_Num * C_SSL_Dim then
      begin
        Result := LMatrix(Jitter_Num, C_SSL_Dim);
        for i := 0 to Jitter_Num - 1 do
          for j := 0 to C_SSL_Dim - 1 do
              Result[i, j] := V[(i * C_SSL_Dim) + j];
      end;
    SetLength(V, 0);
    for i := 0 to Jitter_Num - 1 do
        DisposeObject(arry[i]);
  finally
      DisposeObject(Rand);
  end;
end;

function TPas_AI_TECH_2022.SSL_DebugInfo(hnd: TPas_AI_TECH_2022_SSL_Handle): U_String;
var
  p: PPascalString;
begin
  Result := '';
  if (FAI_TECH_2022_Entry <> nil) and Assigned(FAI_TECH_2022_Entry^.SSL_DebugInfo) and (hnd <> nil) then
    begin
      FAI_TECH_2022_Entry^.SSL_DebugInfo(hnd, p);
      Result := p^;
      API_AI_TECH_2022_FreeString(p);
    end;
end;

procedure TPas_AI_TECH_2022.SSL_Save_To_Learn_DNN_Thread(Jitter_Num: Integer; Pool_: TPas_AI_TECH_2022_DNN_Thread_Pool; RSeri: TPasAI_RasterSerialized; imgList: TPas_AI_ImageList; L: TLearn);
var
  i: Integer;
  imgData: TPas_AI_Image;
  p: PSSL_SaveToLearnEngine_DT_UserData_;
begin
  for i := 0 to imgList.Count - 1 do
    begin
      imgData := imgList[i];
      if RSeri <> nil then
          imgData.UnserializedMemory(RSeri);

      new(p);
      p^.L := L;
      p^.img := imgData;
      TPas_AI_TECH_2022_DNN_Thread_SSL(Pool_.MinLoad_DNN_Thread).Process_C(p, p^.img.Raster, False, Jitter_Num, False, SSL_Save_To_Learn_Engine_DNN_Thread_Backcall);

      if RSeri <> nil then
        begin
          Pool_.Wait();
          imgData.SerializedAndRecycleMemory(RSeri);
        end;
    end;
end;

procedure TPas_AI_TECH_2022.SSL_Save_To_Learn_DNN_Thread(Jitter_Num: Integer; Pool_: TPas_AI_TECH_2022_DNN_Thread_Pool; RSeri: TPasAI_RasterSerialized; imgMat: TPas_AI_ImageMatrix; L: TLearn);
var
  i: Integer;
begin
  for i := 0 to imgMat.Count - 1 do
      SSL_Save_To_Learn_DNN_Thread(Jitter_Num, Pool_, nil, imgMat[i], L);
  Pool_.Wait();
end;

procedure TPas_AI_TECH_2022.SSL_Save_To_Learn_DNN_Thread(Jitter_Num, ThNum: Integer; SSL_stream: TMS64; imgList: TPas_AI_ImageList; L: TLearn);
var
  Pool_: TPas_AI_TECH_2022_DNN_Thread_Pool;
  i: Integer;
  Device_: TLIVec;
begin
  if L.InSize <> C_SSL_Dim then
      RaiseInfo('Learn Engine Insize illegal');
  Pool_ := TPas_AI_TECH_2022_DNN_Thread_Pool.Create;

  GetComputeDeviceOfTraining(Device_);
  for i in Device_ do
      Pool_.BuildDeviceThread(FAI_TECH_2022_Entry, i, ThNum, TPas_AI_TECH_2022_DNN_Thread_SSL);
  for i := 0 to Pool_.Count - 1 do
      TPas_AI_TECH_2022_DNN_Thread_SSL(Pool_[i]).Open_Stream(SSL_stream);

  SSL_Save_To_Learn_DNN_Thread(Jitter_Num, Pool_, nil, imgList, L);

  Pool_.Wait();
  DisposeObject(Pool_);
end;

procedure TPas_AI_TECH_2022.SSL_Save_To_Learn_DNN_Thread(Jitter_Num, ThNum: Integer; SSL_stream: TMS64; imgMat: TPas_AI_ImageMatrix; L: TLearn);
var
  Pool_: TPas_AI_TECH_2022_DNN_Thread_Pool;
  i: Integer;
  Device_: TLIVec;
begin
  if L.InSize <> C_SSL_Dim then
      RaiseInfo('Learn Engine Insize illegal');
  Pool_ := TPas_AI_TECH_2022_DNN_Thread_Pool.Create;

  GetComputeDeviceOfTraining(Device_);
  for i in Device_ do
      Pool_.BuildDeviceThread(FAI_TECH_2022_Entry, i, ThNum, TPas_AI_TECH_2022_DNN_Thread_SSL);
  for i := 0 to Pool_.Count - 1 do
      TPas_AI_TECH_2022_DNN_Thread_SSL(Pool_[i]).Open_Stream(SSL_stream);

  for i := 0 to imgMat.Count - 1 do
      SSL_Save_To_Learn_DNN_Thread(Jitter_Num, Pool_, nil, imgMat[i], L);

  Pool_.Wait();
  DisposeObject(Pool_);
end;

procedure TPas_AI_TECH_2022.SSL_Save_To_Learn_DNN_Thread(Jitter_Num, ThNum: Integer; SSL_stream: TMS64; RSeri: TPasAI_RasterSerialized; imgMat: TPas_AI_ImageMatrix; L: TLearn);
var
  Pool_: TPas_AI_TECH_2022_DNN_Thread_Pool;
  i: Integer;
  Device_: TLIVec;
begin
  if L.InSize <> C_SSL_Dim then
      RaiseInfo('Learn Engine Insize illegal');
  Pool_ := TPas_AI_TECH_2022_DNN_Thread_Pool.Create;

  GetComputeDeviceOfTraining(Device_);
  for i in Device_ do
      Pool_.BuildDeviceThread(FAI_TECH_2022_Entry, i, ThNum, TPas_AI_TECH_2022_DNN_Thread_SSL);
  for i := 0 to Pool_.Count - 1 do
      TPas_AI_TECH_2022_DNN_Thread_SSL(Pool_[i]).Open_Stream(SSL_stream);

  for i := 0 to imgMat.Count - 1 do
      SSL_Save_To_Learn_DNN_Thread(Jitter_Num, Pool_, RSeri, imgMat[i], L);

  Pool_.Wait();
  DisposeObject(Pool_);
end;

class function TPas_AI_TECH_2022_DNN_Thread_Trigger.Init(p_: Pointer; Event_: TRun_Thread_M): TPas_AI_TECH_2022_DNN_Thread_Trigger;
begin
  Result.p := p_;
  Result.ThEvent := Event_;
end;

procedure TPas_AI_TECH_2022_DNN_Thread_Pool.Do_StateInfo_Th(ThSender: TCompute);
var
  tmp: U_String;
  i: Integer;
begin
  while FStateInfo_Th_Runing do
    begin
      tmp := '';
      FCritical.Lock;
      try
        for i := 0 to Count - 1 do
          with Items[i] do
              tmp.Append('%s %s DNN(%d): %d/%d - %s Event: %d/%d/%d'#13#10,
              [if_(Name = '', ClassName, Name), ThreadInfo, ID, TaskNum, GPUPerformanceCritical, if_(Busy, 'Busy', 'IDLE'), GetCPUAsyncThreadNum(), FEventQueue.Num, CPUThreadCritical]);
      finally
          FCritical.UnLock;
      end;

      tmp.Append('per second avg/max: %d/%d'#13#10, [round(PSP), round(MaxPSP)]);

      FStateInfo_Th_Output.V := tmp.Text;
      TCompute.Sleep(FStateInfo_Th_Update_Time_Interval);
    end;
end;

function TPas_AI_TECH_2022_DNN_Thread_Pool.Do_Check_And_Execute_StateInfo_Th: U_String;
begin
  if FStateInfo_Th_Runing then
    begin
      Result := FStateInfo_Th_Output.V;
    end
  else
    begin
      FStateInfo_Th_Runing := True;
      FStateInfo_Th_Busy := True;
      FStateInfo_Th_Output.V := '';
      TCompute.RunM(nil, nil, Do_StateInfo_Th, @FStateInfo_Th_Busy, nil);
      while FStateInfo_Th_Output.V = '' do
          TCompute.Sleep(100);
      Result := FStateInfo_Th_Output.V;
    end;
end;

constructor TPas_AI_TECH_2022_DNN_Thread_Pool.Create;
begin
  inherited Create;
  FName := '';
  FCritical := TCritical.Create;
  FNext_DNNThreadID := 0;
  FQueueOptimized := True;
  FLastRasterList := TMemoryPasAI_RasterList.Create;
  FLastRasterList.AutoFreePasAI_Raster := False;

  { safe state info tech }
  FStateInfo_Th_Runing := False;
  FStateInfo_Th_Busy := False;
  FStateInfo_Th_Update_Time_Interval := 100;
  FStateInfo_Th_Output := TAtomString.Create('');

  { global pool }
  FGlobal_Queue_Ptr := AI_TECH_2022_Global_DNN_ThreadPool.Add(Self);
end;

destructor TPas_AI_TECH_2022_DNN_Thread_Pool.Destroy;
begin
  { wait }
  FStateInfo_Th_Runing := False;
  Wait;
  Clear;
  { wait }
  while FStateInfo_Th_Busy do
      TCompute.Sleep(100);
  { global pool }
  AI_TECH_2022_Global_DNN_ThreadPool.Remove_P(FGlobal_Queue_Ptr);
  DisposeObject(FLastRasterList);
  DisposeObject(FCritical);
  inherited Destroy;
end;

procedure TPas_AI_TECH_2022_DNN_Thread_Pool.Remove(Obj: TPas_AI_TECH_2022_DNN_Thread);
begin
  FCritical.Acquire;
  try
    DisposeObject(Obj);
    inherited Remove(Obj);
  finally
      FCritical.Release;
  end;
end;

procedure TPas_AI_TECH_2022_DNN_Thread_Pool.Delete(Index: Integer);
begin
  FCritical.Acquire;
  try
    if (index >= 0) and (index < Count) then
      begin
        DisposeObject(Items[index]);
        inherited Delete(index);
      end;
  finally
      FCritical.Release;
  end;
end;

procedure TPas_AI_TECH_2022_DNN_Thread_Pool.Clear;
var
  i: Integer;
begin
  FCritical.Acquire;
  FLastRasterList.Clear;
  try
    for i := 0 to Count - 1 do
        DisposeObject(Items[i]);
    inherited Clear;
  finally
      FCritical.Release;
  end;
end;

procedure TPas_AI_TECH_2022_DNN_Thread_Pool.BuildDeviceThread(AI_LIB_P: PAI_TECH_2022_Core_API; Device_, ThNum_: Integer; class_: TPas_AI_TECH_2022_DNN_Thread_Class);
var
  i: Integer;
begin
  for i := 0 to ThNum_ - 1 do
      TPas_AI_TECH_2022_DNN_Thread.Build(Self, AI_LIB_P, Device_, class_);
end;

procedure TPas_AI_TECH_2022_DNN_Thread_Pool.BuildDeviceThread(Device_, ThNum_: Integer; class_: TPas_AI_TECH_2022_DNN_Thread_Class);
var
  i: Integer;
begin
  for i := 0 to ThNum_ - 1 do
      TPas_AI_TECH_2022_DNN_Thread.Build(Self, Device_, class_);
end;

procedure TPas_AI_TECH_2022_DNN_Thread_Pool.BuildPerDeviceThread(AI_LIB_P: PAI_TECH_2022_Core_API; Device_: TLIVec; ThNum_: Integer; class_: TPas_AI_TECH_2022_DNN_Thread_Class);
var
  num_: Integer;
  AI_: TPas_AI_TECH_2022;
  i, j: Integer;
begin
  if Length(Device_) = 0 then
    begin
      BuildPerDeviceThread(AI_LIB_P, ThNum_, class_);
      exit;
    end;
  num_ := if_(CurrentPlatform = epWin32, 1, ThNum_);
  AI_ := TPas_AI_TECH_2022.OpenEngine(AI_LIB_P);
  for i := 0 to num_ - 1 do
    begin
      if AI_.isGPU then
        begin
          for j in Device_ do
              BuildDeviceThread(AI_LIB_P, j, 1, class_);
        end
      else
          BuildDeviceThread(AI_LIB_P, 0, 1, class_);
    end;
  DisposeObject(AI_);
end;

procedure TPas_AI_TECH_2022_DNN_Thread_Pool.BuildPerDeviceThread(Device_: TLIVec; ThNum_: Integer; class_: TPas_AI_TECH_2022_DNN_Thread_Class);
begin
  BuildPerDeviceThread(Prepare_AI_Engine_TECH_2022(), Device_, ThNum_, class_);
end;

procedure TPas_AI_TECH_2022_DNN_Thread_Pool.BuildPerDeviceThread(Device_: TLIVec; class_: TPas_AI_TECH_2022_DNN_Thread_Class);
begin
  BuildPerDeviceThread(Device_, 1, class_);
end;

procedure TPas_AI_TECH_2022_DNN_Thread_Pool.BuildPerDeviceThread(AI_LIB_P: PAI_TECH_2022_Core_API; ThNum_: Integer; class_: TPas_AI_TECH_2022_DNN_Thread_Class);
var
  num_: Integer;
  AI_: TPas_AI_TECH_2022;
  i, j: Integer;
begin
  num_ := if_(CurrentPlatform = epWin32, 1, ThNum_);
  AI_ := TPas_AI_TECH_2022.OpenEngine(AI_LIB_P);
  for i := 0 to num_ - 1 do
    begin
      if AI_.isGPU then
        begin
          for j := 0 to AI_.GetComputeDeviceNumOfProcess - 1 do
              BuildDeviceThread(AI_LIB_P, j, 1, class_);
        end
      else
          BuildDeviceThread(AI_LIB_P, 0, 1, class_);
    end;
  DisposeObject(AI_);
end;

procedure TPas_AI_TECH_2022_DNN_Thread_Pool.BuildPerDeviceThread(ThNum_: Integer; class_: TPas_AI_TECH_2022_DNN_Thread_Class);
begin
  BuildPerDeviceThread(Prepare_AI_Engine_TECH_2022(), ThNum_, class_);
end;

procedure TPas_AI_TECH_2022_DNN_Thread_Pool.BuildPerDeviceThread(class_: TPas_AI_TECH_2022_DNN_Thread_Class);
begin
  BuildPerDeviceThread(1, class_);
end;

function TPas_AI_TECH_2022_DNN_Thread_Pool.Next_DNN_Thread: TPas_AI_TECH_2022_DNN_Thread;
begin
  if Count = 0 then
      RaiseInfo('DNN FThread pool is empty.');
  FCritical.Acquire;
  try
    if FNext_DNNThreadID >= Count then
        FNext_DNNThreadID := 0;
    Result := Items[FNext_DNNThreadID];
    inc(FNext_DNNThreadID);
  finally
      FCritical.Release;
  end;
end;

function TPas_AI_TECH_2022_DNN_Thread_Pool.MinLoad_DNN_Thread: TPas_AI_TECH_2022_DNN_Thread;
var
  i, id_: Integer;
  th: TPas_AI_TECH_2022_DNN_Thread;
begin
  if Count = 0 then
      RaiseInfo('DNN FThread pool is empty.');
  FCritical.Acquire;
  try
    for i := 0 to Count - 1 do
      if (not Items[i].Busy) then
        begin
          if (FQueueOptimized) and (i < Count - 1) then
              move(i, Count - 1);
          Result := Items[i];
          exit;
        end;

    th := Items[0];
    id_ := 0;
    for i := 1 to Count - 1 do
      if Items[i].TaskNum < th.TaskNum then
        begin
          th := Items[i];
          id_ := i;
        end;
    if (FQueueOptimized) and (id_ < Count - 1) then
        move(id_, Count - 1);
    Result := th;
  finally
      FCritical.Release;
  end;
end;

function TPas_AI_TECH_2022_DNN_Thread_Pool.IDLE_DNN_Thread: TPas_AI_TECH_2022_DNN_Thread;
var
  i: Integer;
begin
  if Count = 0 then
      RaiseInfo('DNN FThread pool is empty.');
  FCritical.Acquire;
  Result := nil;
  try
    for i := 0 to Count - 1 do
      if not Items[i].Busy then
          exit(Items[i]);
  finally
      FCritical.Release;
  end;
end;

function TPas_AI_TECH_2022_DNN_Thread_Pool.GetMinLoad_DNN_Thread_TaskNum: Integer;
var
  th: TPas_AI_TECH_2022_DNN_Thread;
begin
  th := MinLoad_DNN_Thread();
  if th <> nil then
      Result := th.TaskNum
  else
      Result := 0;
end;

function TPas_AI_TECH_2022_DNN_Thread_Pool.GetTaskNum: Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to Count - 1 do
      inc(Result, Items[i].TaskNum);
end;

function TPas_AI_TECH_2022_DNN_Thread_Pool.Busy: Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to Count - 1 do
      Result := Result or Items[i].Busy;
end;

function TPas_AI_TECH_2022_DNN_Thread_Pool.PSP: TGeoFloat;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to Count - 1 do
      Result := Result + Items[i].PSP;
end;

function TPas_AI_TECH_2022_DNN_Thread_Pool.MaxPSP: TGeoFloat;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to Count - 1 do
      Result := Result + Items[i].MaxPSP;
end;

procedure TPas_AI_TECH_2022_DNN_Thread_Pool.Wait;
begin
  while Busy do
      TCompute.Sleep(1);
end;

procedure TPas_AI_TECH_2022_DNN_Thread_Pool.Close_StateInfo_Th;
begin
  FStateInfo_Th_Runing := False;
  while FStateInfo_Th_Busy do
      TCompute.Sleep(100);
  FStateInfo_Th_Output.V := '';
end;

function TPas_AI_TECH_2022_DNN_Thread_Pool.StateInfo: U_String;
begin
  Result := StateInfo(True);
end;

function TPas_AI_TECH_2022_DNN_Thread_Pool.StateInfo(const Separator: Boolean): U_String;
begin
  Result := Do_Check_And_Execute_StateInfo_Th();
  if Separator then
      Result.Append('----'#13#10);
end;

procedure TPas_AI_TECH_2022_DNN_Thread_Pool.EnabledLastProcessRaster(value_: Boolean);
var
  i: Integer;
begin
  FCritical.Acquire;
  try
    FLastRasterList.Clear;
    FLastRasterList.UserToken := '';
    for i := 0 to Count - 1 do
        Items[i].FEnabledLastProcessRaster := value_;
  finally
      FCritical.Release;
  end;
end;

function TPas_AI_TECH_2022_DNN_Thread_Pool.LockLastRasterList: TMemoryPasAI_RasterList;
var
  i: Integer;
  PasAI_Raster_: TPasAI_Raster;
begin
  FCritical.Acquire;
  try
    FLastRasterList.Clear;
    for i := 0 to Count - 1 do
      begin
        PasAI_Raster_ := Items[i].GetAndLockLastProcessRaster;
        FLastRasterList.Add(PasAI_Raster_);
      end;
  finally
      FCritical.Release;
  end;
  FLastRasterList.UserToken := FName;
  Result := FLastRasterList;
end;

procedure TPas_AI_TECH_2022_DNN_Thread_Pool.UnLockLastRasterList;
var
  i: Integer;
begin
  FCritical.Acquire;
  try
    FLastRasterList.Clear;
    FLastRasterList.UserToken := '';
    for i := 0 to Count - 1 do
        Items[i].UnLockLastProcessRaster;
  finally
      FCritical.Release;
  end;
end;

procedure TPas_AI_TECH_2022_DNN_Thread.Run_DNN_Thread(Sender: TCompute);
var
  tk: TTimeTick;
  R, L: NativeInt;
begin
  Sender.Thread_Info := ClassName;

  FThread := Sender;
  FThreadPost.ThreadID := FThread.ThreadID;

  FAI.SetComputeDeviceOfProcess(FDevice);

  if FAI.isGPU then
      FThreadInfo := PFormat('TECH2022 %s GPU[%d] %s thread:%d', [
      if_(FAI.GetComputeDeviceOfProcess = FDevice, 'OK', 'Error'),
      FAI.GetComputeDeviceOfProcess,
      FAI.GetComputeDeviceNameOfProcess(FAI.GetComputeDeviceOfProcess).Text,
      Sender.ThreadID])
  else if FAI.isMKL then
      FThreadInfo := PFormat('TECH2022 %s INTEL-MKL[%d] %s thread:%d', ['OK', 0, 'X86/X64', Sender.ThreadID])
  else
      FThreadInfo := PFormat('TECH2022 %s CPU[%d] %s thread:%d', ['OK', 0, 'X86/X64', Sender.ThreadID]);

  tk := GetTimeTick();
  R := 0;
  while FActivted.V or Busy() do
    begin
      L := FThreadPost.Progress(FThreadPost.ThreadID);
      inc(R, L);
      if GetTimeTick() - tk > 2000 then
        begin
          FPSP := R * 0.5;
          FMaxPSP := umlMax(FPSP, FMaxPSP);
          tk := GetTimeTick();
          R := 0;
        end;

      while FEventQueue.Num > 0 do
        begin
          while (FCPUThreadCritical > 0) and (FEventThreadNum > FCPUThreadCritical) do
              TCompute.Sleep(1);

          if (FCPUThreadCritical <= 0) or (FEventThreadNum < FCPUThreadCritical) then
            begin
              AtomInc(FEventThreadNum);
              TCompute.RunM(FEventQueue.Current^.Data^.p, nil, FEventQueue.Current^.Data^.ThEvent);
              FEventQueue.Next;
              inc(L, 1);
            end;
        end;

      if L <= 0 then
          TCompute.Sleep(1);
    end;

  try
      ThreadFree();
  except
  end;

  FDNNThreadRuning.V := False;
  FThread := nil;
end;

procedure TPas_AI_TECH_2022_DNN_Thread.ThreadFree;
begin

end;

procedure TPas_AI_TECH_2022_DNN_Thread.DoEventDone(ThSender: TCompute);
begin
  AtomDec(FEventThreadNum);
end;

procedure TPas_AI_TECH_2022_DNN_Thread.DoRunEvent(p: Pointer; ThEvent: TRun_Thread_M);
begin
  FEventQueue.Push(TPas_AI_TECH_2022_DNN_Thread_Trigger.Init(p, ThEvent));
end;

function TPas_AI_TECH_2022_DNN_Thread.GetTaskNum: Integer;
begin
  Result := FThreadPost.Count;
end;

procedure TPas_AI_TECH_2022_DNN_Thread.UpdateLastProcessRaster(PasAI_Raster_: TPasAI_Raster);
begin
  if not FEnabledLastProcessRaster then
      exit;
  FLastProcessRasterCritical.Lock;
  FLastProcessRaster.Assign(PasAI_Raster_);
  FLastProcessRaster.UserToken := Name;
  FLastProcessRaster.Update;
  FLastProcessRasterCritical.UnLock;
end;

procedure TPas_AI_TECH_2022_DNN_Thread.UpdateLastProcessMatrixRaster(Matrix_IMG: TPas_AI_TECH_2022_Matrix_Image_Handle);
begin
  if not FEnabledLastProcessRaster then
      exit;
  FLastProcessRasterCritical.Lock;
  FAI.BuildMatrixRaster(Matrix_IMG, FLastProcessRaster);
  FLastProcessRaster.UserToken := Name;
  FLastProcessRaster.Update;
  FLastProcessRasterCritical.UnLock;
end;

constructor TPas_AI_TECH_2022_DNN_Thread.Create;
begin
  inherited Create;
  FID := 0;
  FAI := nil;
  FThread := nil;
  FThreadPost := nil;
  FActivted := nil;
  FDNNThreadRuning := nil;

  FThreadInfo := '';
  FPSP := 0;
  FMaxPSP := 0;
  FCPUThreadCritical := 2;
  FGPUPerformanceCritical := 10;
  FName := '';

  FEventThreadNum := 0;
  FEventQueue := nil;

  FEnabledLastProcessRaster := False;
  FLastProcessRasterCritical := TCritical.Create;
  FLastProcessRaster := NewPasAI_Raster();

  FCustomObject := nil;
  FCustomData := nil;
end;

destructor TPas_AI_TECH_2022_DNN_Thread.Destroy;
begin
  FActivted.V := False;
  while FDNNThreadRuning.V or Busy() do
      TCompute.Sleep(1);

  DisposeObjectAndNil(FEventQueue);
  DisposeObjectAndNil(FLastProcessRasterCritical);
  DisposeObjectAndNil(FLastProcessRaster);
  DisposeObjectAndNil(FActivted);
  DisposeObjectAndNil(FDNNThreadRuning);
  DisposeObjectAndNil(FThreadPost);
  DisposeObjectAndNil(FAI);
  inherited Destroy;
end;

class function TPas_AI_TECH_2022_DNN_Thread.Build(Owner: TPas_AI_TECH_2022_DNN_Thread_Pool; AI_LIB_P: PAI_TECH_2022_Core_API; Device_: Integer; class_: TPas_AI_TECH_2022_DNN_Thread_Class): TPas_AI_TECH_2022_DNN_Thread;
var
  TH_: TPas_AI_TECH_2022_DNN_Thread;
begin
  TH_ := class_.Create;
  with TH_ do
    begin
      FAI := TPas_AI_TECH_2022.OpenEngine(AI_LIB_P);
      FDevice := Device_;
      FThreadPost := TThreadPost.Create(0);
      FThreadPost.OneStep := True;
      FThreadPost.ResetRandomSeed := False;
      FActivted := TAtomBool.Create(True);
      FDNNThreadRuning := TAtomBool.Create(True);
      FEventQueue := TPas_AI_TECH_2022_DNN_Thread_Event_Trigger_Order.Create;
      TCompute.RunM(nil, nil, Run_DNN_Thread);
    end;
  Owner.FCritical.Acquire;
  TH_.FID := Owner.Count;
  Owner.Add(TH_);
  Owner.FCritical.Release;
  Result := TH_;
end;

class function TPas_AI_TECH_2022_DNN_Thread.Build(Owner: TPas_AI_TECH_2022_DNN_Thread_Pool; Device_: Integer; class_: TPas_AI_TECH_2022_DNN_Thread_Class): TPas_AI_TECH_2022_DNN_Thread;
begin
  Result := TPas_AI_TECH_2022_DNN_Thread.Build(Owner, Prepare_AI_Engine_TECH_2022(), Device_, class_);
end;

procedure TPas_AI_TECH_2022_DNN_Thread.CheckGPUPerformanceCritical;
begin
  while (FGPUPerformanceCritical > 0) and (TaskNum >= FGPUPerformanceCritical) do
      TCompute.Sleep(1);
end;

function TPas_AI_TECH_2022_DNN_Thread.CheckGPUPerformanceCritical(Tick: TTimeTick): Boolean;
var
  tmp: TTimeTick;
begin
  tmp := GetTimeTick();
  while (FGPUPerformanceCritical > 0) and (TaskNum >= FGPUPerformanceCritical) and (GetTimeTick - tmp < Tick) do
      TCompute.Sleep(1);
  Result := (FGPUPerformanceCritical = 0) or (TaskNum < FGPUPerformanceCritical);
end;

procedure TPas_AI_TECH_2022_DNN_Thread.CheckCPUPerformanceCritical;
begin
  while (FCPUThreadCritical > 0) and (FEventThreadNum >= FCPUThreadCritical) do
      TCompute.Sleep(1);
end;

function TPas_AI_TECH_2022_DNN_Thread.CheckCPUPerformanceCritical(Tick: TTimeTick): Boolean;
var
  tmp: TTimeTick;
begin
  tmp := GetTimeTick();
  while (FCPUThreadCritical > 0) and (FEventThreadNum >= FCPUThreadCritical) and (GetTimeTick - tmp < Tick) do
      TCompute.Sleep(1);
  Result := (FCPUThreadCritical = 0) or (FEventThreadNum < FCPUThreadCritical);
end;

function TPas_AI_TECH_2022_DNN_Thread.Input_Is_Wait: Boolean;
begin
  Result := (FGPUPerformanceCritical > 0) and (TaskNum >= FGPUPerformanceCritical);
end;

function TPas_AI_TECH_2022_DNN_Thread.Input_Is_IDLE: Boolean;
begin
  Result := not Input_Is_Wait;
end;

function TPas_AI_TECH_2022_DNN_Thread.Output_Is_Wait: Boolean;
begin
  Result := (FCPUThreadCritical > 0) and (FEventThreadNum >= FCPUThreadCritical);
end;

function TPas_AI_TECH_2022_DNN_Thread.Output_Is_IDLE: Boolean;
begin
  Result := not Output_Is_Wait;
end;

function TPas_AI_TECH_2022_DNN_Thread.GetCPUAsyncThreadNum: Integer;
begin
  Result := FEventThreadNum;
end;

function TPas_AI_TECH_2022_DNN_Thread.Busy: Boolean;
begin
  Result := FThreadPost.Busy or (FEventThreadNum > 0) or (FEventQueue.Num > 0);
end;

function TPas_AI_TECH_2022_DNN_Thread.GetAndLockLastProcessRaster: TPasAI_Raster;
begin
  FLastProcessRasterCritical.Lock;
  FLastProcessRaster.UserText := ThreadInfo;
  Result := FLastProcessRaster;
end;

procedure TPas_AI_TECH_2022_DNN_Thread.UnLockLastProcessRaster;
begin
  FLastProcessRasterCritical.UnLock;
end;

procedure TPas_AI_TECH_2022_DNN_Thread_DCGAN.ThreadFree;
begin
  FAI.DCGAN_DNN_Close(DCGAN_Hnd);
end;

procedure TPas_AI_TECH_2022_DNN_Thread_DCGAN.CMD_Open(Data1: Pointer; Data2: TCore_Object; Data3: Variant);
begin
  DCGAN_Hnd := FAI.DCGAN_DNN_Open(VarToStr(Data3));
end;

procedure TPas_AI_TECH_2022_DNN_Thread_DCGAN.CMD_Open_Stream(Data1: Pointer; Data2: TCore_Object; Data3: Variant);
begin
  DCGAN_Hnd := FAI.DCGAN_DNN_Open_Stream(Data2 as TMS64);
end;

procedure TPas_AI_TECH_2022_DNN_Thread_DCGAN.CMD_SyncProcess(Data: Pointer);
var
  p: PCMD_SyncProcess;
begin
  p := Data;
  p^.Output_Raster := FAI.DCGAN_DNN_Process(DCGAN_Hnd, p^.Input_rand_seed);
  UpdateLastProcessRaster(p^.Output_Raster);
  p^.Done.V := True;
end;

procedure TPas_AI_TECH_2022_DNN_Thread_DCGAN.CMD_Async_Process_Result(ThSender: TCompute);
var
  p: PCMD_Async_Process;
begin
  p := ThSender.UserData;
  try
    if Assigned(p^.OnResult_C) then
        p^.OnResult_C(Self, p^.UserData, p^.Input_rand_seed, p^.Output_Raster)
    else if Assigned(p^.OnResult_M) then
        p^.OnResult_M(Self, p^.UserData, p^.Input_rand_seed, p^.Output_Raster)
    else if Assigned(p^.OnResult_P) then
        p^.OnResult_P(Self, p^.UserData, p^.Input_rand_seed, p^.Output_Raster);
  except
  end;
  if p^.FreeOutput then
      DisposeObject(p^.Output_Raster);
  Dispose(p);
  DoEventDone(ThSender);
end;

procedure TPas_AI_TECH_2022_DNN_Thread_DCGAN.CMD_Async_Process(Data: Pointer);
var
  p: PCMD_Async_Process;
begin
  p := Data;
  p^.Output_Raster := FAI.DCGAN_DNN_Process(DCGAN_Hnd, p^.Input_rand_seed);
  UpdateLastProcessRaster(p^.Output_Raster);
  DoRunEvent(p, CMD_Async_Process_Result);
end;

constructor TPas_AI_TECH_2022_DNN_Thread_DCGAN.Create;
begin
  inherited Create;
  DCGAN_Hnd := nil;
end;

procedure TPas_AI_TECH_2022_DNN_Thread_DCGAN.Open(train_file: SystemString);
begin
  if not umlMultipleMatch('*' + C_DCGAN_Ext, train_file) then
    begin
      DoStatus('error model file "%s"', [train_file]);
      exit;
    end;
  FThreadPost.PostM3(nil, nil, train_file, CMD_Open);
end;

procedure TPas_AI_TECH_2022_DNN_Thread_DCGAN.Open_Stream(stream: TMS64);
begin
  FThreadPost.PostM3(nil, stream, NULL, CMD_Open_Stream);
end;

function TPas_AI_TECH_2022_DNN_Thread_DCGAN.Process(Input_rand_seed: Int64): TMPasAI_Raster;
var
  CMD_: TCMD_SyncProcess;
begin
  CheckGPUPerformanceCritical;
  CMD_.Done := TAtomBool.Create(False);
  CMD_.Input_rand_seed := Input_rand_seed;
  FThreadPost.PostM2(@CMD_, CMD_SyncProcess);
  while not CMD_.Done.V do
      TCompute.Sleep(1);
  Result := CMD_.Output_Raster;
  DisposeObject(CMD_.Done);
end;

procedure TPas_AI_TECH_2022_DNN_Thread_DCGAN.ProcessC(UserData: Pointer; Input_rand_seed: Int64; FreeOutput: Boolean; OnResult: TPas_AI_DNN_Thread_DCGAN_Async_Process_C);
var
  p: PCMD_Async_Process;
begin
  CheckGPUPerformanceCritical;
  new(p);
  p^.UserData := UserData;
  p^.Input_rand_seed := Input_rand_seed;
  p^.FreeOutput := FreeOutput;
  p^.OnResult_C := OnResult;
  p^.OnResult_M := nil;
  p^.OnResult_P := nil;
  p^.Output_Raster := nil;
  FThreadPost.PostM2(p, CMD_Async_Process);
end;

procedure TPas_AI_TECH_2022_DNN_Thread_DCGAN.ProcessM(UserData: Pointer; Input_rand_seed: Int64; FreeOutput: Boolean; OnResult: TPas_AI_DNN_Thread_DCGAN_Async_Process_M);
var
  p: PCMD_Async_Process;
begin
  CheckGPUPerformanceCritical;
  new(p);
  p^.UserData := UserData;
  p^.Input_rand_seed := Input_rand_seed;
  p^.FreeOutput := FreeOutput;
  p^.OnResult_C := nil;
  p^.OnResult_M := OnResult;
  p^.OnResult_P := nil;
  p^.Output_Raster := nil;
  FThreadPost.PostM2(p, CMD_Async_Process);
end;

procedure TPas_AI_TECH_2022_DNN_Thread_DCGAN.ProcessP(UserData: Pointer; Input_rand_seed: Int64; FreeOutput: Boolean; OnResult: TPas_AI_DNN_Thread_DCGAN_Async_Process_P);
var
  p: PCMD_Async_Process;
begin
  CheckGPUPerformanceCritical;
  new(p);
  p^.UserData := UserData;
  p^.Input_rand_seed := Input_rand_seed;
  p^.FreeOutput := FreeOutput;
  p^.OnResult_C := nil;
  p^.OnResult_M := nil;
  p^.OnResult_P := OnResult;
  p^.Output_Raster := nil;
  FThreadPost.PostM2(p, CMD_Async_Process);
end;

procedure TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2.ThreadFree;
begin
  FAI.ZMetric_V2_Close(ZMetric_V2_Hnd);
end;

procedure TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2.CMD_Open(Data1: Pointer; Data2: TCore_Object; Data3: Variant);
begin
  ZMetric_V2_Hnd := FAI.ZMetric_V2_Open(VarToStr(Data3));
end;

procedure TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2.CMD_Open_Stream(Data1: Pointer; Data2: TCore_Object; Data3: Variant);
begin
  ZMetric_V2_Hnd := FAI.ZMetric_V2_Open_Stream(Data2 as TMS64);
end;

procedure TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2.CMD_Async_Process_No_Jitter_Result(ThSender: TCompute);
var
  p: PCMD_Async_Process_No_Jitter;
begin
  p := ThSender.UserData;
  try
    if Assigned(p^.OnResult_C) then
        p^.OnResult_C(Self, p^.UserData, p^.Input, p^.Box, p^.output)
    else if Assigned(p^.OnResult_M) then
        p^.OnResult_M(Self, p^.UserData, p^.Input, p^.Box, p^.output)
    else if Assigned(p^.OnResult_P) then
        p^.OnResult_P(Self, p^.UserData, p^.Input, p^.Box, p^.output);
  except
  end;
  if p^.FreeInput then
      DisposeObject(p^.Input);
  SetLength(p^.output, 0);
  Dispose(p);
  DoEventDone(ThSender);
end;

procedure TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2.CMD_Async_Process_No_Jitter(Data: Pointer);
var
  p: PCMD_Async_Process_No_Jitter;
begin
  p := Data;
  p^.output := LVecCopy(FAI.ZMetric_V2_Process_No_Jitter(ZMetric_V2_Hnd, p^.Input, p^.Box));
  UpdateLastProcessRaster(p^.Input);
  DoRunEvent(p, CMD_Async_Process_No_Jitter_Result);
end;

procedure TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2.CMD_Async_Process_No_Box_Result(ThSender: TCompute);
var
  p: PCMD_Async_Process_No_Box;
begin
  p := ThSender.UserData;
  try
    if Assigned(p^.OnResult_C) then
        p^.OnResult_C(Self, p^.UserData, p^.Input, p^.output)
    else if Assigned(p^.OnResult_M) then
        p^.OnResult_M(Self, p^.UserData, p^.Input, p^.output)
    else if Assigned(p^.OnResult_P) then
        p^.OnResult_P(Self, p^.UserData, p^.Input, p^.output);
  except
  end;
  if p^.FreeInput then
      DisposeObject(p^.Input);
  SetLength(p^.output, 0);
  Dispose(p);
  DoEventDone(ThSender);
end;

procedure TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2.CMD_Async_Process_No_Box(Data: Pointer);
var
  p: PCMD_Async_Process_No_Box;
begin
  p := Data;
  p^.output := LVecCopy(FAI.ZMetric_V2_Process_No_Jitter(ZMetric_V2_Hnd, p^.Input));
  UpdateLastProcessRaster(p^.Input);
  DoRunEvent(p, CMD_Async_Process_No_Box_Result);
end;

procedure TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2.CMD_Async_Process_Jitter_Result(ThSender: TCompute);
var
  p: PCMD_Async_Process_Jitter;
begin
  p := ThSender.UserData;
  try
    if Assigned(p^.OnResult_C) then
        p^.OnResult_C(Self, p^.UserData, p^.Input, p^.Box, p^.output)
    else if Assigned(p^.OnResult_M) then
        p^.OnResult_M(Self, p^.UserData, p^.Input, p^.Box, p^.output)
    else if Assigned(p^.OnResult_P) then
        p^.OnResult_P(Self, p^.UserData, p^.Input, p^.Box, p^.output);
  except
  end;
  if p^.FreeInput then
      DisposeObject(p^.Input);
  SetLength(p^.output, 0, 0);
  Dispose(p);
  DoEventDone(ThSender);
end;

procedure TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2.CMD_Async_Process_Jitter(Data: Pointer);
var
  p: PCMD_Async_Process_Jitter;
begin
  p := Data;
  p^.output := LMatrixCopy(FAI.ZMetric_V2_Process(ZMetric_V2_Hnd, p^.Input, p^.Box, p^.Jitter_Num));
  UpdateLastProcessRaster(p^.Input);
  DoRunEvent(p, CMD_Async_Process_Jitter_Result);
end;

constructor TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2.Create;
begin
  inherited Create;
  ZMetric_V2_Hnd := nil;
end;

procedure TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2.Open(train_file: SystemString);
begin
  if not umlMultipleMatch('*' + C_ZMetric_V2_Ext, train_file) then
    begin
      DoStatus('error model file "%s"', [train_file]);
      exit;
    end;
  FThreadPost.PostM3(nil, nil, train_file, CMD_Open);
end;

procedure TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2.Open_Stream(stream: TMS64);
begin
  FThreadPost.PostM3(nil, stream, NULL, CMD_Open_Stream);
end;

procedure TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2.Process_No_Jitter_C(UserData: Pointer; Input: TMPasAI_Raster; Box: TRectV2; FreeInput: Boolean; OnResult: TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2_Async_Process_C);
var
  p: PCMD_Async_Process_No_Jitter;
begin
  CheckGPUPerformanceCritical;
  new(p);
  p^.UserData := UserData;
  p^.Input := Input;
  p^.Box := Box;
  p^.FreeInput := FreeInput;
  p^.OnResult_C := OnResult;
  p^.OnResult_M := nil;
  p^.OnResult_P := nil;
  SetLength(p^.output, 0);
  FThreadPost.PostM2(p, CMD_Async_Process_No_Jitter);
end;

procedure TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2.Process_No_Jitter_M(UserData: Pointer; Input: TMPasAI_Raster; Box: TRectV2; FreeInput: Boolean; OnResult: TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2_Async_Process_M);
var
  p: PCMD_Async_Process_No_Jitter;
begin
  CheckGPUPerformanceCritical;
  new(p);
  p^.UserData := UserData;
  p^.Input := Input;
  p^.Box := Box;
  p^.FreeInput := FreeInput;
  p^.OnResult_C := nil;
  p^.OnResult_M := OnResult;
  p^.OnResult_P := nil;
  SetLength(p^.output, 0);
  FThreadPost.PostM2(p, CMD_Async_Process_No_Jitter);
end;

procedure TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2.Process_No_Jitter_P(UserData: Pointer; Input: TMPasAI_Raster; Box: TRectV2; FreeInput: Boolean; OnResult: TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2_Async_Process_P);
var
  p: PCMD_Async_Process_No_Jitter;
begin
  CheckGPUPerformanceCritical;
  new(p);
  p^.UserData := UserData;
  p^.Input := Input;
  p^.Box := Box;
  p^.FreeInput := FreeInput;
  p^.OnResult_C := nil;
  p^.OnResult_M := nil;
  p^.OnResult_P := OnResult;
  SetLength(p^.output, 0);
  FThreadPost.PostM2(p, CMD_Async_Process_No_Jitter);
end;

procedure TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2.Process_No_Box_C(UserData: Pointer; Input: TMPasAI_Raster; FreeInput: Boolean; OnResult: TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2_Async_Process_No_Box_C);
var
  p: PCMD_Async_Process_No_Box;
begin
  CheckGPUPerformanceCritical;
  new(p);
  p^.UserData := UserData;
  p^.Input := Input;
  p^.FreeInput := FreeInput;
  p^.OnResult_C := OnResult;
  p^.OnResult_M := nil;
  p^.OnResult_P := nil;
  SetLength(p^.output, 0);
  FThreadPost.PostM2(p, CMD_Async_Process_No_Box);
end;

procedure TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2.Process_No_Box_M(UserData: Pointer; Input: TMPasAI_Raster; FreeInput: Boolean; OnResult: TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2_Async_Process_No_Box_M);
var
  p: PCMD_Async_Process_No_Box;
begin
  CheckGPUPerformanceCritical;
  new(p);
  p^.UserData := UserData;
  p^.Input := Input;
  p^.FreeInput := FreeInput;
  p^.OnResult_C := nil;
  p^.OnResult_M := OnResult;
  p^.OnResult_P := nil;
  SetLength(p^.output, 0);
  FThreadPost.PostM2(p, CMD_Async_Process_No_Box);
end;

procedure TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2.Process_No_Box_P(UserData: Pointer; Input: TMPasAI_Raster; FreeInput: Boolean; OnResult: TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2_Async_Process_No_Box_P);
var
  p: PCMD_Async_Process_No_Box;
begin
  CheckGPUPerformanceCritical;
  new(p);
  p^.UserData := UserData;
  p^.Input := Input;
  p^.FreeInput := FreeInput;
  p^.OnResult_C := nil;
  p^.OnResult_M := nil;
  p^.OnResult_P := OnResult;
  SetLength(p^.output, 0);
  FThreadPost.PostM2(p, CMD_Async_Process_No_Box);
end;

procedure TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2.Process_Jitter_C(UserData: Pointer; Input: TMPasAI_Raster; Box: TRectV2; Jitter_Num: Integer; FreeInput: Boolean; OnResult: TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2_Async_Process_Jitter_C);
var
  p: PCMD_Async_Process_Jitter;
begin
  CheckGPUPerformanceCritical;
  new(p);
  p^.UserData := UserData;
  p^.Input := Input;
  p^.Box := Box;
  p^.Jitter_Num := Jitter_Num;
  p^.FreeInput := FreeInput;
  p^.OnResult_C := OnResult;
  p^.OnResult_M := nil;
  p^.OnResult_P := nil;
  SetLength(p^.output, 0, 0);
  FThreadPost.PostM2(p, CMD_Async_Process_Jitter);
end;

procedure TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2.Process_Jitter_M(UserData: Pointer; Input: TMPasAI_Raster; Box: TRectV2; Jitter_Num: Integer; FreeInput: Boolean; OnResult: TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2_Async_Process_Jitter_M);
var
  p: PCMD_Async_Process_Jitter;
begin
  CheckGPUPerformanceCritical;
  new(p);
  p^.UserData := UserData;
  p^.Input := Input;
  p^.Box := Box;
  p^.Jitter_Num := Jitter_Num;
  p^.FreeInput := FreeInput;
  p^.OnResult_C := nil;
  p^.OnResult_M := OnResult;
  p^.OnResult_P := nil;
  SetLength(p^.output, 0, 0);
  FThreadPost.PostM2(p, CMD_Async_Process_Jitter);
end;

procedure TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2.Process_Jitter_P(UserData: Pointer; Input: TMPasAI_Raster; Box: TRectV2; Jitter_Num: Integer; FreeInput: Boolean; OnResult: TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2_Async_Process_Jitter_P);
var
  p: PCMD_Async_Process_Jitter;
begin
  CheckGPUPerformanceCritical;
  new(p);
  p^.UserData := UserData;
  p^.Input := Input;
  p^.Box := Box;
  p^.Jitter_Num := Jitter_Num;
  p^.FreeInput := FreeInput;
  p^.OnResult_C := nil;
  p^.OnResult_M := nil;
  p^.OnResult_P := OnResult;
  SetLength(p^.output, 0, 0);
  FThreadPost.PostM2(p, CMD_Async_Process_Jitter);
end;

procedure TPas_AI_TECH_2022_DNN_Thread_YOLO_X.ThreadFree;
begin
  FAI.YOLO_X_Close(YOLO_X_Hnd);
end;

procedure TPas_AI_TECH_2022_DNN_Thread_YOLO_X.CMD_Open(Data1: Pointer; Data2: TCore_Object; Data3: Variant);
begin
  YOLO_X_Hnd := FAI.YOLO_X_Open(VarToStr(Data3));
end;

procedure TPas_AI_TECH_2022_DNN_Thread_YOLO_X.CMD_Open_Stream(Data1: Pointer; Data2: TCore_Object; Data3: Variant);
begin
  YOLO_X_Hnd := FAI.YOLO_X_Open_Stream(Data2 as TMS64);
end;

procedure TPas_AI_TECH_2022_DNN_Thread_YOLO_X.CMD_Async_Process_Result(ThSender: TCompute);
var
  p: PCMD_Async_Process;
  i: Integer;
begin
  p := ThSender.UserData;
  try
    if Assigned(p^.OnResult_C) then
        p^.OnResult_C(Self, p^.UserData, p^.Input, p^.threshold, p^.output)
    else if Assigned(p^.OnResult_M) then
        p^.OnResult_M(Self, p^.UserData, p^.Input, p^.threshold, p^.output)
    else if Assigned(p^.OnResult_P) then
        p^.OnResult_P(Self, p^.UserData, p^.Input, p^.threshold, p^.output);
  except
  end;
  if p^.FreeInput then
      DisposeObject(p^.Input);
  for i := 0 to Length(p^.output) - 1 do
      p^.output[i].Token := '';
  SetLength(p^.output, 0);
  Dispose(p);
  DoEventDone(ThSender);
end;

procedure TPas_AI_TECH_2022_DNN_Thread_YOLO_X.CMD_Async_Process(Data: Pointer);
var
  p: PCMD_Async_Process;
begin
  p := Data;
  p^.output := FAI.YOLO_X_Process(YOLO_X_Hnd, p^.Input, p^.threshold);
  UpdateLastProcessRaster(p^.Input);
  DoRunEvent(p, CMD_Async_Process_Result);
end;

procedure TPas_AI_TECH_2022_DNN_Thread_YOLO_X.CMD_Async_Process_HD_Result(ThSender: TCompute);
var
  p: PCMD_Async_Process_HD;
  i: Integer;
begin
  p := ThSender.UserData;
  try
    if Assigned(p^.OnResult_C) then
        p^.OnResult_C(Self, p^.UserData, p^.Input, p^.threshold, p^.overlap_supression, p^.bilinear_sampling, p^.output)
    else if Assigned(p^.OnResult_M) then
        p^.OnResult_M(Self, p^.UserData, p^.Input, p^.threshold, p^.overlap_supression, p^.bilinear_sampling, p^.output)
    else if Assigned(p^.OnResult_P) then
        p^.OnResult_P(Self, p^.UserData, p^.Input, p^.threshold, p^.overlap_supression, p^.bilinear_sampling, p^.output);
  except
  end;
  if p^.FreeInput then
      DisposeObject(p^.Input);
  for i := 0 to Length(p^.output) - 1 do
      p^.output[i].Token := '';
  SetLength(p^.output, 0);
  Dispose(p);
  DoEventDone(ThSender);
end;

procedure TPas_AI_TECH_2022_DNN_Thread_YOLO_X.CMD_Async_Process_HD(Data: Pointer);
var
  p: PCMD_Async_Process_HD;
begin
  p := Data;
  case p^.HD_Func of
    hd4X: p^.output := FAI.YOLO_X_Process_HD_4X(YOLO_X_Hnd, p^.Input, p^.threshold, p^.overlap_supression, p^.bilinear_sampling);
    hd16X: p^.output := FAI.YOLO_X_Process_HD_16X(YOLO_X_Hnd, p^.Input, p^.threshold, p^.overlap_supression, p^.bilinear_sampling);
  end;
  UpdateLastProcessRaster(p^.Input);
  DoRunEvent(p, CMD_Async_Process_HD_Result);
end;

constructor TPas_AI_TECH_2022_DNN_Thread_YOLO_X.Create;
begin
  inherited Create;
  YOLO_X_Hnd := nil;
end;

procedure TPas_AI_TECH_2022_DNN_Thread_YOLO_X.Open(train_file: SystemString);
begin
  if not umlMultipleMatch('*' + C_YOLO_X_Ext, train_file) then
    begin
      DoStatus('error model file "%s"', [train_file]);
      exit;
    end;
  FThreadPost.PostM3(nil, nil, train_file, CMD_Open);
end;

procedure TPas_AI_TECH_2022_DNN_Thread_YOLO_X.Open_Stream(stream: TMS64);
begin
  FThreadPost.PostM3(nil, stream, NULL, CMD_Open_Stream);
end;

procedure TPas_AI_TECH_2022_DNN_Thread_YOLO_X.Process_C(UserData: Pointer; Input: TMPasAI_Raster; threshold: Double; FreeInput: Boolean; OnResult: TPas_AI_TECH_2022_DNN_Thread_YOLO_X_Async_Process_C);
var
  p: PCMD_Async_Process;
begin
  CheckGPUPerformanceCritical;
  new(p);
  p^.UserData := UserData;
  p^.Input := Input;
  p^.threshold := threshold;
  p^.FreeInput := FreeInput;
  p^.OnResult_C := OnResult;
  p^.OnResult_M := nil;
  p^.OnResult_P := nil;
  SetLength(p^.output, 0);
  FThreadPost.PostM2(p, CMD_Async_Process);
end;

procedure TPas_AI_TECH_2022_DNN_Thread_YOLO_X.Process_M(UserData: Pointer; Input: TMPasAI_Raster; threshold: Double; FreeInput: Boolean; OnResult: TPas_AI_TECH_2022_DNN_Thread_YOLO_X_Async_Process_M);
var
  p: PCMD_Async_Process;
begin
  CheckGPUPerformanceCritical;
  new(p);
  p^.UserData := UserData;
  p^.Input := Input;
  p^.threshold := threshold;
  p^.FreeInput := FreeInput;
  p^.OnResult_C := nil;
  p^.OnResult_M := OnResult;
  p^.OnResult_P := nil;
  SetLength(p^.output, 0);
  FThreadPost.PostM2(p, CMD_Async_Process);
end;

procedure TPas_AI_TECH_2022_DNN_Thread_YOLO_X.Process_P(UserData: Pointer; Input: TMPasAI_Raster; threshold: Double; FreeInput: Boolean; OnResult: TPas_AI_TECH_2022_DNN_Thread_YOLO_X_Async_Process_P);
var
  p: PCMD_Async_Process;
begin
  CheckGPUPerformanceCritical;
  new(p);
  p^.UserData := UserData;
  p^.Input := Input;
  p^.threshold := threshold;
  p^.FreeInput := FreeInput;
  p^.OnResult_C := nil;
  p^.OnResult_M := nil;
  p^.OnResult_P := OnResult;
  SetLength(p^.output, 0);
  FThreadPost.PostM2(p, CMD_Async_Process);
end;

procedure TPas_AI_TECH_2022_DNN_Thread_YOLO_X.Process_HD_4X_C(UserData: Pointer; Input: TMPasAI_Raster; threshold, overlap_supression: Double; bilinear_sampling, FreeInput: Boolean; OnResult: TPas_AI_TECH_2022_DNN_Thread_YOLO_X_Async_Process_HD_C);
var
  p: PCMD_Async_Process_HD;
begin
  CheckGPUPerformanceCritical;
  new(p);
  p^.HD_Func := hd4X;
  p^.UserData := UserData;
  p^.Input := Input;
  p^.threshold := threshold;
  p^.overlap_supression := overlap_supression;
  p^.bilinear_sampling := bilinear_sampling;
  p^.FreeInput := FreeInput;
  p^.OnResult_C := OnResult;
  p^.OnResult_M := nil;
  p^.OnResult_P := nil;
  SetLength(p^.output, 0);
  FThreadPost.PostM2(p, CMD_Async_Process_HD);
end;

procedure TPas_AI_TECH_2022_DNN_Thread_YOLO_X.Process_HD_4X_M(UserData: Pointer; Input: TMPasAI_Raster; threshold, overlap_supression: Double; bilinear_sampling, FreeInput: Boolean; OnResult: TPas_AI_TECH_2022_DNN_Thread_YOLO_X_Async_Process_HD_M);
var
  p: PCMD_Async_Process_HD;
begin
  CheckGPUPerformanceCritical;
  new(p);
  p^.HD_Func := hd4X;
  p^.UserData := UserData;
  p^.Input := Input;
  p^.threshold := threshold;
  p^.overlap_supression := overlap_supression;
  p^.bilinear_sampling := bilinear_sampling;
  p^.FreeInput := FreeInput;
  p^.OnResult_C := nil;
  p^.OnResult_M := OnResult;
  p^.OnResult_P := nil;
  SetLength(p^.output, 0);
  FThreadPost.PostM2(p, CMD_Async_Process_HD);
end;

procedure TPas_AI_TECH_2022_DNN_Thread_YOLO_X.Process_HD_4X_P(UserData: Pointer; Input: TMPasAI_Raster; threshold, overlap_supression: Double; bilinear_sampling, FreeInput: Boolean; OnResult: TPas_AI_TECH_2022_DNN_Thread_YOLO_X_Async_Process_HD_P);
var
  p: PCMD_Async_Process_HD;
begin
  CheckGPUPerformanceCritical;
  new(p);
  p^.HD_Func := hd4X;
  p^.UserData := UserData;
  p^.Input := Input;
  p^.threshold := threshold;
  p^.overlap_supression := overlap_supression;
  p^.bilinear_sampling := bilinear_sampling;
  p^.FreeInput := FreeInput;
  p^.OnResult_C := nil;
  p^.OnResult_M := nil;
  p^.OnResult_P := OnResult;
  SetLength(p^.output, 0);
  FThreadPost.PostM2(p, CMD_Async_Process_HD);
end;

procedure TPas_AI_TECH_2022_DNN_Thread_YOLO_X.Process_HD_16X_C(UserData: Pointer; Input: TMPasAI_Raster; threshold, overlap_supression: Double; bilinear_sampling, FreeInput: Boolean; OnResult: TPas_AI_TECH_2022_DNN_Thread_YOLO_X_Async_Process_HD_C);
var
  p: PCMD_Async_Process_HD;
begin
  CheckGPUPerformanceCritical;
  new(p);
  p^.HD_Func := hd16X;
  p^.UserData := UserData;
  p^.Input := Input;
  p^.threshold := threshold;
  p^.overlap_supression := overlap_supression;
  p^.bilinear_sampling := bilinear_sampling;
  p^.FreeInput := FreeInput;
  p^.OnResult_C := OnResult;
  p^.OnResult_M := nil;
  p^.OnResult_P := nil;
  SetLength(p^.output, 0);
  FThreadPost.PostM2(p, CMD_Async_Process_HD);
end;

procedure TPas_AI_TECH_2022_DNN_Thread_YOLO_X.Process_HD_16X_M(UserData: Pointer; Input: TMPasAI_Raster; threshold, overlap_supression: Double; bilinear_sampling, FreeInput: Boolean; OnResult: TPas_AI_TECH_2022_DNN_Thread_YOLO_X_Async_Process_HD_M);
var
  p: PCMD_Async_Process_HD;
begin
  CheckGPUPerformanceCritical;
  new(p);
  p^.HD_Func := hd16X;
  p^.UserData := UserData;
  p^.Input := Input;
  p^.threshold := threshold;
  p^.overlap_supression := overlap_supression;
  p^.bilinear_sampling := bilinear_sampling;
  p^.FreeInput := FreeInput;
  p^.OnResult_C := nil;
  p^.OnResult_M := OnResult;
  p^.OnResult_P := nil;
  SetLength(p^.output, 0);
  FThreadPost.PostM2(p, CMD_Async_Process_HD);
end;

procedure TPas_AI_TECH_2022_DNN_Thread_YOLO_X.Process_HD_16X_P(UserData: Pointer; Input: TMPasAI_Raster; threshold, overlap_supression: Double; bilinear_sampling, FreeInput: Boolean; OnResult: TPas_AI_TECH_2022_DNN_Thread_YOLO_X_Async_Process_HD_P);
var
  p: PCMD_Async_Process_HD;
begin
  CheckGPUPerformanceCritical;
  new(p);
  p^.HD_Func := hd16X;
  p^.UserData := UserData;
  p^.Input := Input;
  p^.threshold := threshold;
  p^.overlap_supression := overlap_supression;
  p^.bilinear_sampling := bilinear_sampling;
  p^.FreeInput := FreeInput;
  p^.OnResult_C := nil;
  p^.OnResult_M := nil;
  p^.OnResult_P := OnResult;
  SetLength(p^.output, 0);
  FThreadPost.PostM2(p, CMD_Async_Process_HD);
end;

procedure TPas_AI_TECH_2022_DNN_Thread_SSL.ThreadFree;
begin
  FAI.SSL_Close(SSL_Hnd);
end;

procedure TPas_AI_TECH_2022_DNN_Thread_SSL.CMD_Open_Face_Classifier();
begin
  SSL_Hnd := FAI.SSL_Open_Face_Classifier;
end;

procedure TPas_AI_TECH_2022_DNN_Thread_SSL.CMD_Open_BBC();
begin
  SSL_Hnd := FAI.SSL_Open_BBC;
end;

procedure TPas_AI_TECH_2022_DNN_Thread_SSL.CMD_Open(Data1: Pointer; Data2: TCore_Object; Data3: Variant);
begin
  SSL_Hnd := FAI.SSL_Open(VarToStr(Data3));
end;

procedure TPas_AI_TECH_2022_DNN_Thread_SSL.CMD_Open_Stream(Data1: Pointer; Data2: TCore_Object; Data3: Variant);
begin
  SSL_Hnd := FAI.SSL_Open_Stream(Data2 as TMS64);
end;

procedure TPas_AI_TECH_2022_DNN_Thread_SSL.CMD_Async_Process_Result(ThSender: TCompute);
var
  p: PCMD_Async_Process;
begin
  p := ThSender.UserData;
  try
    if Assigned(p^.OnResult_C) then
        p^.OnResult_C(Self, p^.UserData, p^.Input, p^.jitter_random, p^.Jitter_Num, p^.output_sampling, p^.output)
    else if Assigned(p^.OnResult_M) then
        p^.OnResult_M(Self, p^.UserData, p^.Input, p^.jitter_random, p^.Jitter_Num, p^.output_sampling, p^.output)
    else if Assigned(p^.OnResult_P) then
        p^.OnResult_P(Self, p^.UserData, p^.Input, p^.jitter_random, p^.Jitter_Num, p^.output_sampling, p^.output);
  except
  end;
  if p^.FreeInput then
      DisposeObject(p^.Input);
  SetLength(p^.output, 0);
  Dispose(p);
  DoEventDone(ThSender);
end;

procedure TPas_AI_TECH_2022_DNN_Thread_SSL.CMD_Async_Process(Data: Pointer);
var
  p: PCMD_Async_Process;
begin
  p := Data;
  p^.output := LMatrixCopy(FAI.SSL_Process(SSL_Hnd, p^.Input, p^.jitter_random, p^.Jitter_Num, p^.output_sampling));
  UpdateLastProcessRaster(p^.Input);
  DoRunEvent(p, CMD_Async_Process_Result);
end;

constructor TPas_AI_TECH_2022_DNN_Thread_SSL.Create;
begin
  inherited Create;
  SSL_Hnd := nil;
end;

procedure TPas_AI_TECH_2022_DNN_Thread_SSL.Open_Face_Classifier;
begin
  FThreadPost.PostM1(CMD_Open_Face_Classifier);
end;

procedure TPas_AI_TECH_2022_DNN_Thread_SSL.Open_BBC;
begin
  FThreadPost.PostM1(CMD_Open_BBC);
end;

procedure TPas_AI_TECH_2022_DNN_Thread_SSL.Open(train_file: SystemString);
begin
  if not umlMultipleMatch('*' + C_SSL_Ext, train_file) then
    begin
      DoStatus('error model file "%s"', [train_file]);
      exit;
    end;
  FThreadPost.PostM3(nil, nil, train_file, CMD_Open);
end;

procedure TPas_AI_TECH_2022_DNN_Thread_SSL.Open_Stream(stream: TMS64);
begin
  FThreadPost.PostM3(nil, stream, NULL, CMD_Open_Stream);
end;

procedure TPas_AI_TECH_2022_DNN_Thread_SSL.Process_C(UserData: Pointer; Input: TMPasAI_Raster; jitter_random: Boolean; Jitter_Num: Integer; FreeInput: Boolean; OnResult: TPas_AI_TECH_2022_DNN_Thread_SSL_Async_Process_C);
var
  p: PCMD_Async_Process;
begin
  CheckGPUPerformanceCritical;
  new(p);
  p^.UserData := UserData;
  p^.Input := Input;
  p^.jitter_random := jitter_random;
  p^.Jitter_Num := Jitter_Num;
  p^.FreeInput := FreeInput;
  p^.OnResult_C := OnResult;
  p^.OnResult_M := nil;
  p^.OnResult_P := nil;
  SetLength(p^.output_sampling, 0);
  SetLength(p^.output, 0, 0);
  FThreadPost.PostM2(p, CMD_Async_Process);
end;

procedure TPas_AI_TECH_2022_DNN_Thread_SSL.Process_M(UserData: Pointer; Input: TMPasAI_Raster; jitter_random: Boolean; Jitter_Num: Integer; FreeInput: Boolean; OnResult: TPas_AI_TECH_2022_DNN_Thread_SSL_Async_Process_M);
var
  p: PCMD_Async_Process;
begin
  CheckGPUPerformanceCritical;
  new(p);
  p^.UserData := UserData;
  p^.Input := Input;
  p^.jitter_random := jitter_random;
  p^.Jitter_Num := Jitter_Num;
  p^.FreeInput := FreeInput;
  p^.OnResult_C := nil;
  p^.OnResult_M := OnResult;
  p^.OnResult_P := nil;
  SetLength(p^.output_sampling, 0);
  SetLength(p^.output, 0, 0);
  FThreadPost.PostM2(p, CMD_Async_Process);
end;

procedure TPas_AI_TECH_2022_DNN_Thread_SSL.Process_P(UserData: Pointer; Input: TMPasAI_Raster; jitter_random: Boolean; Jitter_Num: Integer; FreeInput: Boolean; OnResult: TPas_AI_TECH_2022_DNN_Thread_SSL_Async_Process_P);
var
  p: PCMD_Async_Process;
begin
  CheckGPUPerformanceCritical;
  new(p);
  p^.UserData := UserData;
  p^.Input := Input;
  p^.jitter_random := jitter_random;
  p^.Jitter_Num := Jitter_Num;
  p^.FreeInput := FreeInput;
  p^.OnResult_C := nil;
  p^.OnResult_M := nil;
  p^.OnResult_P := OnResult;
  SetLength(p^.output_sampling, 0);
  SetLength(p^.output, 0, 0);
  FThreadPost.PostM2(p, CMD_Async_Process);
end;

function AI_TECH_2022_Alloc_P_Bytes(const buff: U_String): P_Bytes;
begin
  Result := AI_TECH_2022_Alloc_P_Bytes_FromBuff(buff.PlatformBytes);
end;

function AI_TECH_2022_Alloc_P_Bytes_FromBuff(const buff: TBytes): P_Bytes;
begin
  new(Result);
  Result^.Size := Length(buff);
  if Result^.Size > 0 then
    begin
      Result^.Bytes := GetMemory(Result^.Size + 1);
      CopyPtr(@buff[0], Result^.Bytes, Result^.Size);
    end
  else
      Result^.Bytes := nil;
end;

procedure AI_TECH_2022_Free_P_Bytes(const buff: P_Bytes);
begin
  if (buff = nil) then
      exit;
  if (buff^.Size > 0) and (buff^.Bytes <> nil) then
      FreeMemory(buff^.Bytes);
  FillPtrByte(buff, SizeOf(C_Bytes), 0);
  Dispose(buff);
end;

function AI_TECH_2022_Get_P_Bytes_String(const buff: P_Bytes): U_String;
var
  tmp: TBytes;
begin
  SetLength(tmp, buff^.Size);
  if buff^.Size > 0 then
      CopyPtr(buff^.Bytes, @tmp[0], buff^.Size);
  Result.PlatformBytes := tmp;
  SetLength(tmp, 0);
end;

function AI_TECH_2022_Point(const V: TVec2): TAI_TECH_2022_Point;
begin
  Result.X := round(V[0]);
  Result.Y := round(V[1]);
end;

function AI_TECH_2022_RectV2(const V: TAI_TECH_2022_Rect): TRectV2;
begin
  Result[0, 0] := V.Left;
  Result[0, 1] := V.Top;
  Result[1, 0] := V.Right;
  Result[1, 1] := V.Bottom;
end;

function AI_TECH_2022_RectV2(const V: TPas_AI_TECH_2022_YOLO_Rect): TRectV2;
begin
  Result[0, 0] := V.Left;
  Result[0, 1] := V.Top;
  Result[1, 0] := V.Right;
  Result[1, 1] := V.Bottom;
end;

function AI_TECH_2022_RectV2(const V: TAI_TECH_2022_DESC_): TRectV2;
begin
  Result := V.R;
end;

function Check_AI_Engine_TECH_2022(libFile: SystemString): Boolean;
var
  currDir: U_String;
  hnd: HMODULE;
begin
  Result := AI_TECH_2022_Entry_Cache.Exists_Key(libFile);
  if (not Result) and (CurrentPlatform in [epWin64, epWin32]) then
    begin
      currDir := umlGetCurrentPath;
      try
        umlSetCurrentPath(umlGetFilePath(libFile));
        hnd := GetExtLib(libFile);
        Result := hnd <> 0;
      except
      end;
      FreeExtLib(libFile);
      umlSetCurrentPath(currDir);
    end;
end;

function Load_AI_Engine_TECH_2022(libFile: SystemString): PAI_TECH_2022_Core_API;
type
  TProc_init_tech_2022_api_entry = procedure(var AI: TPas_AI_TECH_2022_Core_API); stdcall;
var
  init_tech_2022_api_entry: TProc_init_tech_2022_api_entry;
  AI_TECH_2022_Entry: PAI_TECH_2022_Core_API;
  currDir: U_String;
  i: Integer;
begin
  Result := nil;

  if CurrentPlatform in [epWin64, epWin32] then
    begin
      LockObject(AI_TECH_2022_Entry_Cache);
      try
        AI_TECH_2022_Entry := AI_TECH_2022_Entry_Cache[libFile];
        if AI_TECH_2022_Entry <> nil then
          begin
            Result := AI_TECH_2022_Entry;
          end
        else
          begin
            currDir := umlGetCurrentPath;
            try
              umlSetCurrentPath(umlGetFilePath(libFile));
              init_tech_2022_api_entry := TProc_init_tech_2022_api_entry(GetExtProc(libFile, 'init_tech_2022_api_entry'));
            except
              init_tech_2022_api_entry := nil;
              FreeExtLib(libFile);
            end;
            umlSetCurrentPath(currDir);
            if Assigned(init_tech_2022_api_entry) then
              begin
                new(AI_TECH_2022_Entry);
                FillPtrByte(AI_TECH_2022_Entry, SizeOf(TPas_AI_TECH_2022_Core_API), 0);
                AI_TECH_2022_Entry^.API_OnOneStep := API_AI_TECH_2022_OnOneStep;
                AI_TECH_2022_Entry^.API_OnPause := API_AI_TECH_2022_OnPause;
                AI_TECH_2022_Entry^.API_Status_Out := API_AI_TECH_2022_StatusIO_Out;
                AI_TECH_2022_Entry^.API_GetTimeTick64 := API_AI_TECH_2022_GetTimeTick64;
                AI_TECH_2022_Entry^.API_BuildString := API_AI_TECH_2022_BuildString;
                AI_TECH_2022_Entry^.API_FreeString := API_AI_TECH_2022_FreeString;
                AI_TECH_2022_Entry^.API_GetRaster := API_AI_TECH_2022_GetRaster;
                AI_TECH_2022_Entry^.API_GetImage := API_AI_TECH_2022_GetImage;
                AI_TECH_2022_Entry^.API_RecycleImage := API_AI_TECH_2022_RecycleImage;
                AI_TECH_2022_Entry^.API_GetImageLabel := API_AI_TECH_2022_GetImageLabel;
                AI_TECH_2022_Entry^.API_FreeImageLabel := API_AI_TECH_2022_FreeImageLabel;
                AI_TECH_2022_Entry^.API_GetImageLabel_ID := API_AI_TECH_2022_GetImageLabel_ID;
                AI_TECH_2022_Entry^.API_Jitter := API_AI_TECH_2022_Jitter;
                AI_TECH_2022_Entry^.API_Image_Jitter := API_AI_TECH_2022_Image_Jitter;
                AI_TECH_2022_Entry^.API_RecycleRaster := API_AI_TECH_2022_RecycleRaster;
                AI_TECH_2022_Entry^.API_GetDetectorDefineNum := API_AI_TECH_2022_GetDetectorDefineNum;
                AI_TECH_2022_Entry^.API_GetDetectorDefineImage := API_AI_TECH_2022_GetDetectorDefineImage;
                AI_TECH_2022_Entry^.API_GetDetectorDefineRect := API_AI_TECH_2022_GetDetectorDefineRect;
                AI_TECH_2022_Entry^.API_GetDetectorDefineLabel := API_AI_TECH_2022_GetDetectorDefineLabel;
                AI_TECH_2022_Entry^.API_FreeDetectorDefineLabel := API_AI_TECH_2022_FreeDetectorDefineLabel;
                AI_TECH_2022_Entry^.API_GetDetectorDefinePartNum := API_AI_TECH_2022_GetDetectorDefinePartNum;
                AI_TECH_2022_Entry^.API_GetDetectorDefinePart := API_AI_TECH_2022_GetDetectorDefinePart;

                for i := Low(AI_TECH_2022_Entry^.ComputeDeviceOfTraining) to High(AI_TECH_2022_Entry^.ComputeDeviceOfTraining) do
                    AI_TECH_2022_Entry^.ComputeDeviceOfTraining[i] := -1;
                AI_TECH_2022_Entry^.ComputeDeviceOfTraining[0] := 0;
                AI_TECH_2022_Entry^.ThNum := if_(IsDebuging, 2, AI_Parallel_Count);

                { internal }
                AI_TECH_2022_Entry^.LibraryFile := libFile;
                AI_TECH_2022_Entry^.RasterSerialized := nil;
                AI_TECH_2022_Entry^.SerializedTime := GetTimeTick();
                AI_TECH_2022_Entry^.Swap_Raster_Pool := nil;
                AI_TECH_2022_Entry^.Rand := nil;
                AI_TECH_2022_Entry^.Critical := nil;
                AI_TECH_2022_Entry^.Enabled_Trainer_Warning := True;

                try
                  { init api }
                  init_tech_2022_api_entry(AI_TECH_2022_Entry^);

                  if (AI_TECH_2022_Entry^.MajorVer = 1) and (AI_TECH_2022_Entry^.MinorVer = 41) and (AI_TECH_2022_Entry^.VerMode = 3) and (AI_TECH_2022_Entry^.VerID = 1) then
                    begin
                      AI_TECH_2022_Entry^.Rand := TRandom.Create;
                      AI_TECH_2022_Entry^.Critical := TCritical.Create;
                      AI_TECH_2022_Entry_Cache.Add(libFile, AI_TECH_2022_Entry, False);
                      DoStatus(AI_TECH_2022_Entry^.GetVersionInfo());
                      Result := AI_TECH_2022_Entry;
                    end
                  else
                    begin
                      DoStatus('not supported. AI Tech-2022 engine: %s', [umlGetFileName(libFile).Text]);
                      Dispose(AI_TECH_2022_Entry);
                      FreeExtLib(libFile);
                    end;
                except
                  DoStatus('AI Tech-2022 engine init failed: "%s"', [umlGetFileName(libFile).Text]);
                  Dispose(AI_TECH_2022_Entry);
                  FreeExtLib(libFile);
                end;
              end
            else
              begin
                DoStatus('AI Tech-2022 engine without support this platform: %s', [umlGetFileName(libFile).Text]);
              end;
          end;
      finally
          UnLockObject(AI_TECH_2022_Entry_Cache);
      end;
    end;
end;

function Prepare_AI_Engine_TECH_2022(eng: SystemString): PAI_TECH_2022_Core_API;
begin
  Result := Load_AI_Engine_TECH_2022(eng);
end;

function Prepare_AI_Engine_TECH_2022_IsReady: Boolean;
begin
  LockObject(AI_TECH_2022_Entry_Cache);
  Result := AI_TECH_2022_Entry_Cache.Exists_Key(AI_Engine_Tech2022_Library);
  UnLockObject(AI_TECH_2022_Entry_Cache);
end;

function Prepare_AI_Engine_TECH_2022: PAI_TECH_2022_Core_API;
begin
  Result := Prepare_AI_Engine_TECH_2022(AI_Engine_Tech2022_Library);
  if Assigned(On_Prepare_AI_Engine_TECH_2022) then
      On_Prepare_AI_Engine_TECH_2022();
end;

procedure Close_AI_Engine_TECH_2022;
  procedure Free_ZAI_TECH_2022(AI_TECH_2022_Entry: PAI_TECH_2022_Core_API);
  begin
    try
      if AI_TECH_2022_Entry <> nil then
        begin
          AI_TECH_2022_Entry^.CloseAI();
          DisposeObjectAndNil(AI_TECH_2022_Entry^.Rand);
          DisposeObjectAndNil(AI_TECH_2022_Entry^.Critical);
          Dispose(AI_TECH_2022_Entry);
        end;
    except
    end;
  end;

var
  p: PAI_TECH_2022_Core_API;
begin
  LockObject(AI_TECH_2022_Entry_Cache);
  if AI_TECH_2022_Entry_Cache.Count > 0 then
    begin
      with AI_TECH_2022_Entry_Cache.Repeat_ do
        repeat
          begin
            p := queue^.Data^.Data.Second;
            Free_ZAI_TECH_2022(p);
            FreeExtLib(queue^.Data^.Data.Primary);
          end;
        until not Next;
      AI_TECH_2022_Entry_Cache.Clear;
    end;
  UnLockObject(AI_TECH_2022_Entry_Cache);
end;

procedure API_AI_TECH_2022_OnOneStep(Sender: PAI_TECH_2022_Core_API; one_step_calls: UInt64); stdcall;
var
  recycle_mem: Int64;
begin
  try
    { large-scale support }
    if Sender^.RasterSerialized <> nil then
      if GetTimeTick() - Sender^.SerializedTime > 100 then
        begin
          { cache memory optimize }
          Sender^.RasterSerialized.Critical.Acquire;
          Sender^.RasterSerialized.Read_History_Pool.Free_Recycle_Pool;
          if Sender^.RasterSerialized.Read_History_Pool.Num > 0 then
            with Sender^.RasterSerialized.Read_History_Pool.Repeat_ do
              repeat
                if GetTimeTick() - queue^.Data.ActiveTimeTick() > AI_TECH_2022_Large_Scale_Training_Memory_Recycle_Time then
                  begin
                    inc(recycle_mem, queue^.Data.RecycleMemory()); { recycle }
                    queue^.Data.Serialized_Read_History_Ptr := nil;
                    Sender^.RasterSerialized.Read_History_Pool.Push_To_Recycle_Pool(queue);
                  end
                else
                    break; { optimized }
              until not Next;
          Sender^.RasterSerialized.Read_History_Pool.Free_Recycle_Pool;
          Sender^.RasterSerialized.Critical.Release;
          Sender^.SerializedTime := GetTimeTick();
        end;

    { memory recycle support }
    if Sender^.Swap_Raster_Pool <> nil then
      begin
        Sender^.Swap_Raster_Pool.Lock;
        try
          Sender^.Swap_Raster_Pool.Free_Recycle_Pool;
          if Sender^.Swap_Raster_Pool.Num > 0 then
            with Sender^.Swap_Raster_Pool.Repeat_ do
              repeat
                if GetTimeTick() - queue^.Data.ActiveTimeTick > AI_TECH_2022_Recycle_Swap_Pool_Time then
                    Sender^.Swap_Raster_Pool.Push_To_Recycle_Pool(queue);
              until not Next;
          Sender^.Swap_Raster_Pool.Free_Recycle_Pool;
        except
        end;
        Sender^.Swap_Raster_Pool.UnLock;
      end;
  except
  end;
end;

procedure API_AI_TECH_2022_OnPause(); stdcall;
begin
  TCompute.Sleep(10);
end;

procedure API_AI_TECH_2022_StatusIO_Out(Sender: PAI_TECH_2022_Core_API; i_char: Integer); stdcall;
var
  buff: TBytes;
  log_: TPascalString;
begin
  AI_TECH_2022_Status_Critical.Acquire;
  try
    if (i_char in [10, 13]) then
      begin
        if (AI_TECH_2022_Status_Buffer.Size > 0) then
          begin
            SetLength(buff, AI_TECH_2022_Status_Buffer.Size);
            CopyPtr(AI_TECH_2022_Status_Buffer.memory, @buff[0], AI_TECH_2022_Status_Buffer.Size);
            AI_TECH_2022_Status_Buffer.Clear;
            log_ := umlStringOf(buff).TrimChar(#32#9#13);
            SetLength(buff, 0);
            if Sender^.Enabled_Trainer_Warning or (not umlMultipleMatch(True, 'Warning*', log_)) then
                DoStatus(log_);
            log_ := '';
          end
        else if i_char = 10 then
            DoStatus('');
      end
    else
      begin
        AI_TECH_2022_Status_Buffer.WriteUInt8(i_char);
      end;
  except
  end;
  AI_TECH_2022_Status_Critical.Release;
end;

function API_AI_TECH_2022_GetTimeTick64(): UInt64; stdcall;
begin
  Result := GetTimeTick();
end;

function API_AI_TECH_2022_BuildString(p: Pointer; Size: Integer): Pointer; stdcall;
var
  b: TBytes;
  pp: PPascalString;
begin
  new(pp);
  pp^ := '';
  Result := pp;
  if Size > 0 then
    begin
      SetLength(b, Size);
      CopyPtr(p, @b[0], Size);
      pp^.Bytes := b;
      SetLength(b, 0);
    end;
end;

procedure API_AI_TECH_2022_FreeString(p: Pointer); stdcall;
begin
  Dispose(PPascalString(p));
end;

function API_AI_TECH_2022_GetRaster(hnd: PAI_TECH_2022_Raster_Handle; var Bits: Pointer; var Width, Height: Integer): Byte; stdcall;
begin
  Result := 0;
  Bits := hnd^.Raster.Bits;
  Width := hnd^.Raster.Width;
  Height := hnd^.Raster.Height;
  Result := 1;
end;

function API_AI_TECH_2022_GetImage(hnd: PAI_TECH_2022_Image_Handle; var Bits: Pointer; var Width, Height: Integer): Byte; stdcall;
begin
  Result := 0;
  Bits := hnd^.image.Raster.Bits;
  Width := hnd^.image.Raster.Width;
  Height := hnd^.image.Raster.Height;
  Result := 1;
end;

function API_AI_TECH_2022_RecycleImage(Sender: PAI_TECH_2022_Core_API; hnd: PAI_TECH_2022_Image_Handle): Byte; stdcall;
begin
  Result := 0;
  if Sender^.RasterSerialized <> nil then
    begin
      Sender^.RasterSerialized.Critical.Acquire;
      hnd^.image.RecycleMemory();
      Sender^.RasterSerialized.Critical.Release;
    end
  else
      hnd^.image.RecycleMemory();
end;

function API_AI_TECH_2022_GetImageLabel(hnd: PAI_TECH_2022_Image_Handle; var p: P_Bytes): Byte; stdcall;
begin
  Result := 0;
  if hnd = nil then
      exit;
  { using UTF8 format }
  p := AI_TECH_2022_Alloc_P_Bytes_FromBuff(hnd^.image.Owner.FileInfo.Bytes);
  Result := 1;
end;

procedure API_AI_TECH_2022_FreeImageLabel(var p: P_Bytes); stdcall;
begin
  AI_TECH_2022_Free_P_Bytes(p);
  p := nil;
end;

function API_AI_TECH_2022_GetImageLabel_ID(hnd: PAI_TECH_2022_Image_Handle): Cardinal; stdcall;
begin
  Result := 0;
  if hnd = nil then
      exit;
  Result := hnd^.image.Owner.ID;
end;

function API_AI_TECH_2022_Jitter(
Sender: PAI_TECH_2022_Core_API;
DetDef: PAI_TECH_2022_Detector_Define_Handle;
SS_Raster_Width, SS_Raster_Height, XY_Offset_Scale_, Rotate_, Scale_: Double; inner_fit_: Integer): PAI_TECH_2022_Raster_Handle; stdcall;
var
  p: PAI_TECH_2022_Raster_Handle;
begin
  try
    new(p);
    p^.Raster := DetDef^.Detector_Define.Jitter(Sender^.Rand, SS_Raster_Width, SS_Raster_Height, XY_Offset_Scale_, Rotate_, Scale_, inner_fit_ > 0);
    Result := p;
  except
      Result := nil;
  end;
end;

function API_AI_TECH_2022_Image_Jitter(Sender: PAI_TECH_2022_Core_API; img: PAI_TECH_2022_Image_Handle;
scale_size_x, scale_size_y, scale_pos_x, scale_pos_y, XY_Offset_Scale, Rotate, Scale, sampling_size_x, sampling_size_y: Double;
Fit_Matrix_Box, lock_sampler: Integer): PAI_TECH_2022_Raster_Handle; stdcall;
var
  p: PAI_TECH_2022_Raster_Handle;
begin
  try
    new(p);
    p^.Raster := img^.image.Raster.Build_Jitter_Fit_Box_Raster(Sender^.Rand,
      Vec2(scale_size_x, scale_size_y),
      Vec2(scale_pos_x, scale_pos_y),
      XY_Offset_Scale, Rotate, Scale,
      Fit_Matrix_Box > 0,
      Vec2(sampling_size_x, sampling_size_y),
      lock_sampler > 0);
    Result := p;
  except
      Result := nil;
  end;
end;

function API_AI_TECH_2022_RecycleRaster(Sender: PAI_TECH_2022_Core_API; hnd: PAI_TECH_2022_Raster_Handle): Byte; stdcall;
begin
  Result := 0;
  if hnd = nil then
      exit;
  try
    DisposeObjectAndNil(hnd^.Raster);
    Dispose(hnd);
  except
  end;
  Result := 1;
end;

function API_AI_TECH_2022_GetDetectorDefineNum(hnd: PAI_TECH_2022_Image_Handle): Integer; stdcall;
begin
  Result := hnd^.image.DetectorDefineList.Count;
end;

function API_AI_TECH_2022_GetDetectorDefineImage(hnd: PAI_TECH_2022_Image_Handle; detIndex: Integer; var Bits: Pointer; var Width, Height: Integer): Byte; stdcall;
var
  img: TMPasAI_Raster;
begin
  Result := 0;
  if hnd = nil then
      exit;
  if (detIndex < 0) or (detIndex >= hnd^.image.DetectorDefineList.Count) then
      exit;
  img := hnd^.image.DetectorDefineList[detIndex].PrepareRaster;
  if img.Empty then
      exit;

  Bits := img.Bits;
  Width := img.Width;
  Height := img.Height;
  Result := 1;
end;

function API_AI_TECH_2022_GetDetectorDefineRect(hnd: PAI_TECH_2022_Image_Handle; detIndex: Integer; var rect_: TAI_TECH_2022_Rect): Byte; stdcall;
var
  DetDef: TPas_AI_DetectorDefine;
begin
  Result := 0;
  if hnd = nil then
      exit;
  if (detIndex < 0) or (detIndex >= hnd^.image.DetectorDefineList.Count) then
      exit;
  DetDef := hnd^.image.DetectorDefineList[detIndex];
  rect_.Left := DetDef.R.Left;
  rect_.Top := DetDef.R.Top;
  rect_.Right := DetDef.R.Right;
  rect_.Bottom := DetDef.R.Bottom;
  Result := 1;
end;

function API_AI_TECH_2022_GetDetectorDefineLabel(hnd: PAI_TECH_2022_Image_Handle; detIndex: Integer; var p: P_Bytes): Byte; stdcall;
var
  DetDef: TPas_AI_DetectorDefine;
begin
  Result := 0;
  if hnd = nil then
      exit;
  if (detIndex < 0) or (detIndex >= hnd^.image.DetectorDefineList.Count) then
      exit;
  DetDef := hnd^.image.DetectorDefineList[detIndex];
  { using UTF8 format }
  p := AI_TECH_2022_Alloc_P_Bytes_FromBuff(DetDef.Token.Bytes);
  Result := 1;
end;

procedure API_AI_TECH_2022_FreeDetectorDefineLabel(var p: P_Bytes); stdcall;
begin
  AI_TECH_2022_Free_P_Bytes(p);
  p := nil;
end;

function API_AI_TECH_2022_GetDetectorDefinePartNum(hnd: PAI_TECH_2022_Image_Handle; detIndex: Integer): Integer; stdcall;
var
  DetDef: TPas_AI_DetectorDefine;
begin
  Result := -1;
  if hnd = nil then
      exit;
  if (detIndex < 0) or (detIndex >= hnd^.image.DetectorDefineList.Count) then
      exit;
  DetDef := hnd^.image.DetectorDefineList[detIndex];
  Result := DetDef.Part.Count;
end;

function API_AI_TECH_2022_GetDetectorDefinePart(hnd: PAI_TECH_2022_Image_Handle; detIndex, partIndex: Integer; var part_: TAI_TECH_2022_Point): Byte; stdcall;
var
  DetDef: TPas_AI_DetectorDefine;
begin
  Result := 0;
  if hnd = nil then
      exit;
  if (detIndex < 0) or (detIndex >= hnd^.image.DetectorDefineList.Count) then
      exit;
  DetDef := hnd^.image.DetectorDefineList[detIndex];
  if (partIndex < 0) or (partIndex >= DetDef.Part.Count) then
      exit;

  part_ := AI_TECH_2022_Point(DetDef.Part[partIndex]^);
  Result := 1;
end;

procedure ZMetric_V2_No_Box_Save_To_Learn_Engine_DNN_Thread_Backcall(ThSender: TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2; UserData: Pointer; Input: TMPasAI_Raster; output: TLVec);
var
  p: PZMetric_V2_SaveToLearnEngine_DT_UserData_;
  DetDef: TPas_AI_DetectorDefine;
begin
  p := UserData;
  if Length(output) <> C_ZMetric_V2_Dim then
    begin
      DoStatus('Z-Metric V2.0 vector error!');
      exit;
    end;
  DetDef := p^.DetDef;
  LockObject(p^.L);
  p^.L.AddMemory(output, DetDef.Token,
    PFormat('%d,%d,%d', [p^.DetDef.Owner.Owner.ID, p^.DetDef.Owner.ID, p^.DetDef.Owner.DetectorDefineList.IndexOf(p^.DetDef)]));
  UnLockObject(p^.L);
  Dispose(p);
end;

procedure ZMetric_V2_No_Jitter_Save_To_Learn_Engine_DNN_Thread_Backcall(ThSender: TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2; UserData: Pointer; Input: TMPasAI_Raster; Box: TRectV2; output: TLVec);
var
  p: PZMetric_V2_SaveToLearnEngine_DT_UserData_;
  DetDef: TPas_AI_DetectorDefine;
begin
  p := UserData;
  if Length(output) <> C_ZMetric_V2_Dim then
    begin
      DoStatus('Z-Metric V2.0 vector error!');
      exit;
    end;
  DetDef := p^.DetDef;
  LockObject(p^.L);
  p^.L.AddMemory(output, DetDef.Token,
    PFormat('%d,%d,%d', [p^.DetDef.Owner.Owner.ID, p^.DetDef.Owner.ID, p^.DetDef.Owner.DetectorDefineList.IndexOf(p^.DetDef)]));
  UnLockObject(p^.L);
  Dispose(p);
end;

procedure ZMetric_V2_Jitter_Save_To_Learn_Engine_DNN_Thread_Backcall(ThSender: TPas_AI_TECH_2022_DNN_Thread_ZMetric_V2; UserData: Pointer; Input: TMPasAI_Raster; Box: TRectV2; output: TLMatrix);
var
  p: PZMetric_V2_SaveToLearnEngine_DT_UserData_;
  i: Integer;
  DetDef: TPas_AI_DetectorDefine;
begin
  p := UserData;
  DetDef := p^.DetDef;
  LockObject(p^.L);
  for i := 0 to Length(output) - 1 do
    if Length(output[i]) = C_ZMetric_V2_Dim then
        p^.L.AddMemory(output[i], DetDef.Token,
        PFormat('%d,%d,%d', [p^.DetDef.Owner.Owner.ID, p^.DetDef.Owner.ID, p^.DetDef.Owner.DetectorDefineList.IndexOf(p^.DetDef)]))
    else
        DoStatus('Z-Metric V2.0 vector error!');
  UnLockObject(p^.L);
  Dispose(p);
end;

procedure SSL_Save_To_Learn_Engine_DNN_Thread_Backcall(ThSender: TPas_AI_TECH_2022_DNN_Thread_SSL; UserData: Pointer; Input: TMPasAI_Raster; jitter_random: Boolean; Jitter_Num: Integer; output_sampling: TArrayV2R4; output: TLMatrix);
var
  p: PSSL_SaveToLearnEngine_DT_UserData_;
  i: Integer;
  n: U_String;
begin
  p := UserData;
  LockObject(p^.L);
  for i := 0 to Length(output) - 1 do
    if Length(output[i]) = C_SSL_Dim then
      begin
        if p^.img.Owner.ID >= 0 then
            n := p^.img.Owner.FileInfo
        else
            n := p^.img.FileInfo;
        p^.L.AddMemory(output[i], n, PFormat('%d,%d,%d|%s', [p^.img.Owner.ID, p^.img.ID, -1, VecToStr(output_sampling[i])]));
      end
    else
        DoStatus('SSL Matrix vector error!');
  UnLockObject(p^.L);
  Dispose(p);
end;

function Get_Output_Info(const output_info: SystemString): SystemString;
begin
  if umlTrimSpace(output_info) = '' then
      Result := 'output'
  else
      Result := output_info;
end;

procedure Build_Normal_Training_Param_DCGAN(output: TCore_Strings; const output_info: SystemString = '');
var
  param: THashVariantList;
  DCGAN_param: PAI_TECH_2022_DCGAN_Train_Parameter;
begin
  param := THashVariantList.Create;
  param.SetDefaultValue_Str('ComputeFunc', 'TrainDCGAN');
  param.SetDefaultValue_Str('source', 'input' + PasAI.AI.Common.C_ImageList_Ext);
  param.SetDefaultValue_Str('syncfile', 'output' + C_DCGAN_Ext + '.sync');
  param.SetDefaultValue_Str('output', Get_Output_Info(output_info) + C_DCGAN_Ext);
  param.SetDefaultValue('scale', 1.0);
  param.SetDefaultValue_Str('timeout', 'e"7*24*1000*60*60"');

  DCGAN_param := TPas_AI_TECH_2022.Init_DCGAN_DNN_TrainParam('', '');

  param.SetDefaultValue('rand_seed', DCGAN_param^.rand_seed);
  param.SetDefaultValue('max_iterations', DCGAN_param^.max_iterations);
  param.SetDefaultValue('iteration_sync_step', DCGAN_param^.iteration_sync_step);
  param.SetDefaultValue('learning_rate', DCGAN_param^.learning_rate);
  param.SetDefaultValue('mini_batch', DCGAN_param^.mini_batch);
  param.SetDefaultValue('Snapshot', False);

  TPas_AI_TECH_2022.Free_DCGAN_DNN_TrainParam(DCGAN_param);

  param.ExportAsStrings(output);
  DisposeObject(param);
end;

procedure Build_Normal_Training_Param_ZMetric_V2(output: TCore_Strings; const output_info: SystemString = '');
var
  param: THashVariantList;
  ZMetric_V2_param: PAI_TECH_2022_ZMetric_V2_Train_Parameter;
begin
  param := THashVariantList.Create;
  param.SetDefaultValue_Str('ComputeFunc', 'TrainZMetricV2');
  param.SetDefaultValue_Str('source', 'input' + PasAI.AI.Common.C_ImageList_Ext);
  param.SetDefaultValue_Str('syncfile', 'output' + C_ZMetric_V2_Ext + '.sync');
  param.SetDefaultValue_Str('output', Get_Output_Info(output_info) + C_ZMetric_V2_Ext);
  param.SetDefaultValue('LearnVec', True);
  param.SetDefaultValue_Str('output' + C_Learn_Ext, Get_Output_Info(output_info) + C_Learn_Ext);
  param.SetDefaultValue('scale', 1.0);
  param.SetDefaultValue_Str('timeout', 'e"7*24*1000*60*60"');

  ZMetric_V2_param := TPas_AI_TECH_2022.Init_ZMetric_V2_Parameter('', '');
  param.SetDefaultValue('weight_decay', ZMetric_V2_param^.weight_decay);
  param.SetDefaultValue('momentum', ZMetric_V2_param^.momentum);
  param.SetDefaultValue('iterations_without_progress_threshold', ZMetric_V2_param^.iterations_without_progress_threshold);
  param.SetDefaultValue('min_learning_rate', ZMetric_V2_param^.min_learning_rate);
  param.SetDefaultValue('learning_rate', ZMetric_V2_param^.learning_rate);
  param.SetDefaultValue('completed_learning_rate', ZMetric_V2_param^.completed_learning_rate);
  param.SetDefaultValue('step_mini_batch_target_num', ZMetric_V2_param^.step_mini_batch_target_num);
  param.SetDefaultValue('step_mini_batch_jitter_num', ZMetric_V2_param^.step_mini_batch_jitter_num);
  param.SetDefaultValue('auto_flip_left_right', ZMetric_V2_param^.auto_flip_left_right);
  param.SetDefaultValue('jitter_ss_width', ZMetric_V2_param^.jitter_ss_width);
  param.SetDefaultValue('jitter_ss_height', ZMetric_V2_param^.jitter_ss_height);
  param.SetDefaultValue('jitter_XY_Offset_Scale', ZMetric_V2_param^.jitter_XY_Offset_Scale);
  param.SetDefaultValue('jitter_Rotate', ZMetric_V2_param^.jitter_Rotate);
  param.SetDefaultValue('jitter_Scale', ZMetric_V2_param^.jitter_Scale);
  param.SetDefaultValue('jitter_inner_fit', ZMetric_V2_param^.jitter_inner_fit);
  param.SetDefaultValue('jitter_thread_num', ZMetric_V2_param^.jitter_thread_num);
  param.SetDefaultValue('Max_Data_Queue', ZMetric_V2_param^.Max_Data_Queue);
  TPas_AI_TECH_2022.Free_ZMetric_V2_Parameter(ZMetric_V2_param);

  param.SetDefaultValue('Learn_Jitter', True);
  param.SetDefaultValue('Learn_Jitter_Num', 50);
  param.SetDefaultValue('Learn_Thread_Num', 10);
  param.SetDefaultValue('Learn_Include_Prepare_Raster', True);

  param.ExportAsStrings(output);
  DisposeObject(param);
end;

procedure Build_Normal_Training_Param_YOLO_X(output: TCore_Strings; const output_info: SystemString);
var
  param: THashVariantList;
  YOLO_X_param: PPas_AI_TECH_2022_YOLO_X_Train_Parameter;
begin
  param := THashVariantList.Create;
  param.SetDefaultValue_Str('ComputeFunc', 'YOLOX');
  param.SetDefaultValue_Str('source', 'input' + PasAI.AI.Common.C_ImageList_Ext);
  param.SetDefaultValue_Str('syncfile', 'output' + C_YOLO_X_Ext + '.sync');
  param.SetDefaultValue_Str('output', Get_Output_Info(output_info) + C_YOLO_X_Ext);
  param.SetDefaultValue('scale', 1.0);
  param.SetDefaultValue('NoLabel', False);
  param.SetDefaultValue_Str('timeout', 'e"7*24*1000*60*60"');

  YOLO_X_param := TPas_AI_TECH_2022.Init_YOLO_X_Parameter('', '');

  { net param }
  param.SetDefaultValue('iou_ignore_threshold', YOLO_X_param^.iou_ignore_threshold);
  param.SetDefaultValue('iou_anchor_threshold', YOLO_X_param^.iou_anchor_threshold);
  param.SetDefaultValue('begin_learning_rate', YOLO_X_param^.begin_learning_rate);
  param.SetDefaultValue('complete_learning_rate', YOLO_X_param^.complete_learning_rate);
  param.SetDefaultValue('iterations_without_progress_threshold', YOLO_X_param^.iterations_without_progress_threshold);
  param.SetDefaultValue('prepare_unstable_step_num', YOLO_X_param^.prepare_unstable_step_num);
  param.SetDefaultValue('learning_rate_shrink_factor', YOLO_X_param^.learning_rate_shrink_factor);
  { These are the anchors computed on user custom dataset, presented in the YOLO-X paper. }
  param.SetDefaultValue_Str('T8', PFormat('%d,%d,%d,%d,%d,%d', [YOLO_X_param^.T8_1_X, YOLO_X_param^.T8_1_Y, YOLO_X_param^.T8_2_X, YOLO_X_param^.T8_2_Y, YOLO_X_param^.T8_3_X, YOLO_X_param^.T8_3_Y]));
  param.SetDefaultValue_Str('T16', PFormat('%d,%d,%d,%d,%d,%d', [YOLO_X_param^.T16_1_X, YOLO_X_param^.T16_1_Y, YOLO_X_param^.T16_2_X, YOLO_X_param^.T16_2_Y, YOLO_X_param^.T16_3_X, YOLO_X_param^.T16_3_Y]));
  param.SetDefaultValue_Str('T32', PFormat('%d,%d,%d,%d,%d,%d', [YOLO_X_param^.T32_1_X, YOLO_X_param^.T32_1_Y, YOLO_X_param^.T32_2_X, YOLO_X_param^.T32_2_Y, YOLO_X_param^.T32_3_X, YOLO_X_param^.T32_3_Y]));
  { cropper param }
  param.SetDefaultValue('batch_size', YOLO_X_param^.batch_size);
  param.SetDefaultValue('max_object_size', YOLO_X_param^.max_object_size);
  param.SetDefaultValue('min_object_size_x', YOLO_X_param^.min_object_size_x);
  param.SetDefaultValue('min_object_size_y', YOLO_X_param^.min_object_size_y);
  param.SetDefaultValue('max_rotation_degrees', YOLO_X_param^.max_rotation_degrees);
  param.SetDefaultValue('translate_amount', YOLO_X_param^.translate_amount);
  param.SetDefaultValue('randomly_flip', YOLO_X_param^.randomly_flip);
  param.SetDefaultValue('background_crops_fraction', YOLO_X_param^.background_crops_fraction);
  param.SetDefaultValue('min_object_coverage', YOLO_X_param^.min_object_coverage);
  param.SetDefaultValue('alternate_between_cropping', YOLO_X_param^.alternate_between_cropping);
  param.SetDefaultValue('training_thread_num', YOLO_X_param^.training_thread_num);
  param.SetDefaultValue('max_training_batch_queue_num', YOLO_X_param^.max_training_batch_queue_num);
  { test param }
  param.SetDefaultValue('test_thread_num', YOLO_X_param^.test_thread_num);
  param.SetDefaultValue('max_test_batch_queue_num', YOLO_X_param^.max_test_batch_queue_num);
  param.SetDefaultValue('test_steps', YOLO_X_param^.test_steps);

  TPas_AI_TECH_2022.Free_YOLO_X_Parameter(YOLO_X_param);

  param.ExportAsStrings(output);
  DisposeObject(param);
end;

procedure Build_Normal_Training_Param_YOLO_X(output: TCore_Strings; const output_info, T8, T16, T32: SystemString);
var
  param: THashVariantList;
  YOLO_X_param: PPas_AI_TECH_2022_YOLO_X_Train_Parameter;
begin
  param := THashVariantList.Create;
  param.SetDefaultValue_Str('ComputeFunc', 'YOLOX');
  param.SetDefaultValue_Str('source', 'input' + PasAI.AI.Common.C_ImageList_Ext);
  param.SetDefaultValue_Str('syncfile', 'output' + C_YOLO_X_Ext + '.sync');
  param.SetDefaultValue_Str('output', Get_Output_Info(output_info) + C_YOLO_X_Ext);
  param.SetDefaultValue('scale', 1.0);
  param.SetDefaultValue('NoLabel', False);
  param.SetDefaultValue_Str('timeout', 'e"7*24*1000*60*60"');

  YOLO_X_param := TPas_AI_TECH_2022.Init_YOLO_X_Parameter('', '');

  { net param }
  param.SetDefaultValue('iou_ignore_threshold', YOLO_X_param^.iou_ignore_threshold);
  param.SetDefaultValue('iou_anchor_threshold', YOLO_X_param^.iou_anchor_threshold);
  param.SetDefaultValue('begin_learning_rate', YOLO_X_param^.begin_learning_rate);
  param.SetDefaultValue('complete_learning_rate', YOLO_X_param^.complete_learning_rate);
  param.SetDefaultValue('iterations_without_progress_threshold', YOLO_X_param^.iterations_without_progress_threshold);
  param.SetDefaultValue('prepare_unstable_step_num', YOLO_X_param^.prepare_unstable_step_num);
  param.SetDefaultValue('learning_rate_shrink_factor', YOLO_X_param^.learning_rate_shrink_factor);
  { These are the anchors computed on user custom dataset, presented in the YOLO-X paper. }
  param.SetDefaultValue_Str('T8', T8);
  param.SetDefaultValue_Str('T16', T16);
  param.SetDefaultValue_Str('T32', T32);
  { cropper param }
  param.SetDefaultValue('batch_size', YOLO_X_param^.batch_size);
  param.SetDefaultValue('max_object_size', YOLO_X_param^.max_object_size);
  param.SetDefaultValue('min_object_size_x', YOLO_X_param^.min_object_size_x);
  param.SetDefaultValue('min_object_size_y', YOLO_X_param^.min_object_size_y);
  param.SetDefaultValue('max_rotation_degrees', YOLO_X_param^.max_rotation_degrees);
  param.SetDefaultValue('translate_amount', YOLO_X_param^.translate_amount);
  param.SetDefaultValue('randomly_flip', YOLO_X_param^.randomly_flip);
  param.SetDefaultValue('background_crops_fraction', YOLO_X_param^.background_crops_fraction);
  param.SetDefaultValue('min_object_coverage', YOLO_X_param^.min_object_coverage);
  param.SetDefaultValue('alternate_between_cropping', YOLO_X_param^.alternate_between_cropping);
  param.SetDefaultValue('training_thread_num', YOLO_X_param^.training_thread_num);
  param.SetDefaultValue('max_training_batch_queue_num', YOLO_X_param^.max_training_batch_queue_num);
  { test param }
  param.SetDefaultValue('test_thread_num', YOLO_X_param^.test_thread_num);
  param.SetDefaultValue('max_test_batch_queue_num', YOLO_X_param^.max_test_batch_queue_num);
  param.SetDefaultValue('test_steps', YOLO_X_param^.test_steps);

  TPas_AI_TECH_2022.Free_YOLO_X_Parameter(YOLO_X_param);

  param.ExportAsStrings(output);
  DisposeObject(param);
end;

procedure Build_Normal_Training_Param_YOLO_X(output: TCore_Strings);
begin
  Build_Normal_Training_Param_YOLO_X(output, '');
end;

procedure Build_Normal_Training_Param_SSL(output: TCore_Strings; const output_info: SystemString = '');
var
  param: THashVariantList;
  SSL_param: PPas_AI_TECH_2022_SSL_Train_Parameter;
begin
  param := THashVariantList.Create;
  param.SetDefaultValue_Str('ComputeFunc', 'TrainSSL');
  param.SetDefaultValue_Str('source', 'input' + PasAI.AI.Common.C_ImageList_Ext);
  param.SetDefaultValue_Str('syncfile', 'output' + C_SSL_Ext + '.sync');
  param.SetDefaultValue_Str('output', Get_Output_Info(output_info) + C_SSL_Ext);
  param.SetDefaultValue('LearnVec', True);
  param.SetDefaultValue_Str('output' + C_Learn_Ext, Get_Output_Info(output_info) + C_Learn_Ext);
  param.SetDefaultValue('LearnVec_Jitter_Num', 80);
  param.SetDefaultValue('LearnVec_Thread_Num', 4);
  param.SetDefaultValue('scale', 1.0);
  param.SetDefaultValue_Str('timeout', 'e"30*24*1000*60*60"');

  SSL_param := TPas_AI_TECH_2022.Init_SSL_Parameter('', '');
  { trainer }
  param.SetDefaultValue('iterations_without_progress_threshold', SSL_param^.iterations_without_progress_threshold);
  param.SetDefaultValue('min_learning_rate', SSL_param^.min_learning_rate);
  param.SetDefaultValue('learning_rate', SSL_param^.learning_rate);
  param.SetDefaultValue('completed_learning_rate', SSL_param^.completed_learning_rate);
  param.SetDefaultValue('batch_num', SSL_param^.batch_num);
  param.SetDefaultValue('dims', SSL_param^.dims);
  param.SetDefaultValue_Str('lambda', 'e"1.0/128"');
  { jitter }
  param.SetDefaultValue('Max_Data_Queue', SSL_param^.Max_Data_Queue);
  param.SetDefaultValue('jitter_thread_num', SSL_param^.jitter_thread_num);
  param.SetDefaultValue('scale_size_x', SSL_param^.scale_size_x);
  param.SetDefaultValue('scale_size_y', SSL_param^.scale_size_y);
  param.SetDefaultValue('scale_pos_x', SSL_param^.scale_pos_x);
  param.SetDefaultValue('scale_pos_y', SSL_param^.scale_pos_y);
  param.SetDefaultValue('jitter_XY_Offset_Scale', SSL_param^.XY_Offset_Scale);
  param.SetDefaultValue('jitter_Rotate', SSL_param^.Rotate);
  param.SetDefaultValue('jitter_Scale', SSL_param^.Scale);
  param.SetDefaultValue('sampling_size_x', SSL_param^.sampling_size_x);
  param.SetDefaultValue('sampling_size_y', SSL_param^.sampling_size_y);
  param.SetDefaultValue('Fit_Matrix_Box', SSL_param^.Fit_Matrix_Box);
  param.SetDefaultValue('lock_sampler', SSL_param^.lock_sampler);
  { transform frequency }
  param.SetDefaultValue('left_right_flip', SSL_param^.left_right_flip);
  param.SetDefaultValue('disturb_colors', SSL_param^.disturb_colors);
  param.SetDefaultValue('grayscale', SSL_param^.grayscale);
  TPas_AI_TECH_2022.Free_SSL_Parameter(SSL_param);

  param.ExportAsStrings(output);
  DisposeObject(param);
end;

procedure Build_Large_Scale_Training_Param_ZMetric_V2(output: TCore_Strings);
var
  param: THashVariantList;
  ZMetric_V2_param: PAI_TECH_2022_ZMetric_V2_Train_Parameter;
begin
  param := THashVariantList.Create;
  param.SetDefaultValue_Str('ComputeFunc', 'TrainZMetricV2');
  param.SetDefaultValue('LearnVec', True);
  param.SetDefaultValue_Str('timeout', 'e"7*24*1000*60*60"');

  ZMetric_V2_param := TPas_AI_TECH_2022.Init_ZMetric_V2_Parameter('', '');
  param.SetDefaultValue('weight_decay', ZMetric_V2_param^.weight_decay);
  param.SetDefaultValue('momentum', ZMetric_V2_param^.momentum);
  param.SetDefaultValue('iterations_without_progress_threshold', ZMetric_V2_param^.iterations_without_progress_threshold);
  param.SetDefaultValue('min_learning_rate', ZMetric_V2_param^.min_learning_rate);
  param.SetDefaultValue('learning_rate', ZMetric_V2_param^.learning_rate);
  param.SetDefaultValue('completed_learning_rate', ZMetric_V2_param^.completed_learning_rate);
  param.SetDefaultValue('step_mini_batch_target_num', ZMetric_V2_param^.step_mini_batch_target_num);
  param.SetDefaultValue('step_mini_batch_jitter_num', ZMetric_V2_param^.step_mini_batch_jitter_num);
  param.SetDefaultValue('auto_flip_left_right', ZMetric_V2_param^.auto_flip_left_right);
  param.SetDefaultValue('jitter_ss_width', ZMetric_V2_param^.jitter_ss_width);
  param.SetDefaultValue('jitter_ss_height', ZMetric_V2_param^.jitter_ss_height);
  param.SetDefaultValue('jitter_XY_Offset_Scale', ZMetric_V2_param^.jitter_XY_Offset_Scale);
  param.SetDefaultValue('jitter_Rotate', ZMetric_V2_param^.jitter_Rotate);
  param.SetDefaultValue('jitter_Scale', ZMetric_V2_param^.jitter_Scale);
  param.SetDefaultValue('jitter_inner_fit', ZMetric_V2_param^.jitter_inner_fit);
  param.SetDefaultValue('jitter_thread_num', ZMetric_V2_param^.jitter_thread_num);
  param.SetDefaultValue('Max_Data_Queue', ZMetric_V2_param^.Max_Data_Queue);
  TPas_AI_TECH_2022.Free_ZMetric_V2_Parameter(ZMetric_V2_param);

  param.SetDefaultValue('Learn_Jitter', True);
  param.SetDefaultValue('Learn_Jitter_Num', 50);
  param.SetDefaultValue('Learn_Thread_Num', 10);
  param.SetDefaultValue('Learn_Include_Prepare_Raster', True);

  param.ExportAsStrings(output);
  DisposeObject(param);
end;

procedure Build_Large_Scale_Training_Param_YOLO_X(output: TCore_Strings);
var
  param: THashVariantList;
  YOLO_X_param: PPas_AI_TECH_2022_YOLO_X_Train_Parameter;
begin
  param := THashVariantList.Create;
  param.SetDefaultValue_Str('ComputeFunc', 'YOLOX');
  param.SetDefaultValue('NoLabel', False);
  param.SetDefaultValue_Str('timeout', 'e"7*24*1000*60*60"');

  YOLO_X_param := TPas_AI_TECH_2022.Init_YOLO_X_Parameter('', '');

  { net param }
  param.SetDefaultValue('iou_ignore_threshold', YOLO_X_param^.iou_ignore_threshold);
  param.SetDefaultValue('iou_anchor_threshold', YOLO_X_param^.iou_anchor_threshold);
  param.SetDefaultValue('begin_learning_rate', YOLO_X_param^.begin_learning_rate);
  param.SetDefaultValue('complete_learning_rate', YOLO_X_param^.complete_learning_rate);
  param.SetDefaultValue('iterations_without_progress_threshold', YOLO_X_param^.iterations_without_progress_threshold);
  param.SetDefaultValue('prepare_unstable_step_num', YOLO_X_param^.prepare_unstable_step_num);
  param.SetDefaultValue('learning_rate_shrink_factor', YOLO_X_param^.learning_rate_shrink_factor);
  { These are the anchors computed on user custom dataset, presented in the YOLO-X paper. }
  param.SetDefaultValue_Str('T8', PFormat('%d,%d,%d,%d,%d,%d', [YOLO_X_param^.T8_1_X, YOLO_X_param^.T8_1_Y, YOLO_X_param^.T8_2_X, YOLO_X_param^.T8_2_Y, YOLO_X_param^.T8_3_X, YOLO_X_param^.T8_3_Y]));
  param.SetDefaultValue_Str('T16', PFormat('%d,%d,%d,%d,%d,%d', [YOLO_X_param^.T16_1_X, YOLO_X_param^.T16_1_Y, YOLO_X_param^.T16_2_X, YOLO_X_param^.T16_2_Y, YOLO_X_param^.T16_3_X, YOLO_X_param^.T16_3_Y]));
  param.SetDefaultValue_Str('T32', PFormat('%d,%d,%d,%d,%d,%d', [YOLO_X_param^.T32_1_X, YOLO_X_param^.T32_1_Y, YOLO_X_param^.T32_2_X, YOLO_X_param^.T32_2_Y, YOLO_X_param^.T32_3_X, YOLO_X_param^.T32_3_Y]));
  { cropper param }
  param.SetDefaultValue('batch_size', YOLO_X_param^.batch_size);
  param.SetDefaultValue('max_object_size', YOLO_X_param^.max_object_size);
  param.SetDefaultValue('min_object_size_x', YOLO_X_param^.min_object_size_x);
  param.SetDefaultValue('min_object_size_y', YOLO_X_param^.min_object_size_y);
  param.SetDefaultValue('max_rotation_degrees', YOLO_X_param^.max_rotation_degrees);
  param.SetDefaultValue('translate_amount', YOLO_X_param^.translate_amount);
  param.SetDefaultValue('randomly_flip', YOLO_X_param^.randomly_flip);
  param.SetDefaultValue('background_crops_fraction', YOLO_X_param^.background_crops_fraction);
  param.SetDefaultValue('min_object_coverage', YOLO_X_param^.min_object_coverage);
  param.SetDefaultValue('alternate_between_cropping', YOLO_X_param^.alternate_between_cropping);
  param.SetDefaultValue('training_thread_num', YOLO_X_param^.training_thread_num);
  param.SetDefaultValue('max_training_batch_queue_num', YOLO_X_param^.max_training_batch_queue_num);
  { test param }
  param.SetDefaultValue('test_thread_num', YOLO_X_param^.test_thread_num);
  param.SetDefaultValue('max_test_batch_queue_num', YOLO_X_param^.max_test_batch_queue_num);
  param.SetDefaultValue('test_steps', YOLO_X_param^.test_steps);

  TPas_AI_TECH_2022.Free_YOLO_X_Parameter(YOLO_X_param);

  param.ExportAsStrings(output);
  DisposeObject(param);
end;

procedure Build_Large_Scale_Training_Param_SSL(output: TCore_Strings);
var
  param: THashVariantList;
  SSL_param: PPas_AI_TECH_2022_SSL_Train_Parameter;
begin
  param := THashVariantList.Create;
  param.SetDefaultValue_Str('ComputeFunc', 'TrainSSL');
  param.SetDefaultValue('LearnVec', True);
  param.SetDefaultValue('LearnVec_Jitter_Num', 80);
  param.SetDefaultValue('LearnVec_Thread_Num', 4);
  param.SetDefaultValue_Str('timeout', 'e"30*24*1000*60*60"');

  SSL_param := TPas_AI_TECH_2022.Init_SSL_Parameter('', '');
  { trainer }
  param.SetDefaultValue('iterations_without_progress_threshold', SSL_param^.iterations_without_progress_threshold);
  param.SetDefaultValue('min_learning_rate', SSL_param^.min_learning_rate);
  param.SetDefaultValue('learning_rate', SSL_param^.learning_rate);
  param.SetDefaultValue('completed_learning_rate', SSL_param^.completed_learning_rate);
  param.SetDefaultValue('batch_num', SSL_param^.batch_num);
  param.SetDefaultValue('dims', SSL_param^.dims);
  param.SetDefaultValue_Str('lambda', 'e"1.0/128"');
  { jitter }
  param.SetDefaultValue('Max_Data_Queue', SSL_param^.Max_Data_Queue);
  param.SetDefaultValue('jitter_thread_num', SSL_param^.jitter_thread_num);
  param.SetDefaultValue('scale_size_x', SSL_param^.scale_size_x);
  param.SetDefaultValue('scale_size_y', SSL_param^.scale_size_y);
  param.SetDefaultValue('scale_pos_x', SSL_param^.scale_pos_x);
  param.SetDefaultValue('scale_pos_y', SSL_param^.scale_pos_y);
  param.SetDefaultValue('jitter_XY_Offset_Scale', SSL_param^.XY_Offset_Scale);
  param.SetDefaultValue('jitter_Rotate', SSL_param^.Rotate);
  param.SetDefaultValue('jitter_Scale', SSL_param^.Scale);
  param.SetDefaultValue('sampling_size_x', SSL_param^.sampling_size_x);
  param.SetDefaultValue('sampling_size_y', SSL_param^.sampling_size_y);
  param.SetDefaultValue('Fit_Matrix_Box', SSL_param^.Fit_Matrix_Box);
  param.SetDefaultValue('lock_sampler', SSL_param^.lock_sampler);
  { transform frequency }
  param.SetDefaultValue('left_right_flip', SSL_param^.left_right_flip);
  param.SetDefaultValue('disturb_colors', SSL_param^.disturb_colors);
  param.SetDefaultValue('grayscale', SSL_param^.grayscale);
  TPas_AI_TECH_2022.Free_SSL_Parameter(SSL_param);

  param.ExportAsStrings(output);
  DisposeObject(param);
end;

function Is_AI_TECH_2022_Engine_Training_Task(const Task_File, paramFile: SystemString): Boolean;
var
  Task_: TPas_AI_TrainingTask;
begin
  Task_ := TPas_AI_TrainingTask.OpenFileTask(Task_File, True);
  Result := Task_.Is_AI_TECH_2022_Task(paramFile);
  DisposeObject(Task_);
end;

function AI_TECH_2022_RunTrainingTask(Task: TPas_AI_TrainingTask; const AI: TPas_AI_TECH_2022; const paramFile: SystemString): Boolean;
var
  i, j: Integer;
  startTick: TTimeTick;
  param: THashVariantList;
  ComputeFunc: SystemString;
  param_md5: TMD5;

  { batch free }
  inputfile1, inputfile2: SystemString;
  inputstream1, inputstream2: TMS64;
  inputraster1, inputraster2: TMPasAI_Raster;
  DetDef: TPas_AI_DetectorDefine;
  inputImgList, imgL: TPas_AI_ImageList;
  inputImgMatrix: TPas_AI_ImageMatrix;
  test_imgList: TPas_AI_ImageList;
  test_imgMatrix: TPas_AI_ImageMatrix;
  ResultValues: THashVariantList;

  { manual free }
  outputstream: TMS64;
  local_sync1, local_sync2, sync_file1, sync_file2, output_file: SystemString;
  Scale: TGeoFloat;
  output_learn_file: SystemString;
  LearnEng: TLearn;
  TmpM64: TMS64;
  eVec: TExpressionValueVector;

  { param }
  DCGAN_param: PAI_TECH_2022_DCGAN_Train_Parameter;
  ZMetric_V2_param: PAI_TECH_2022_ZMetric_V2_Train_Parameter;
  YOLO_X_param: PPas_AI_TECH_2022_YOLO_X_Train_Parameter;
  SSL_param: PPas_AI_TECH_2022_SSL_Train_Parameter;
begin
  Result := False;
  if Task = nil then
      exit;
  if not AI.Activted then
      exit;

  Task.LastWriteFileList.Clear;

  param := THashVariantList.Create;
  Task.Read(paramFile, param);
  param_md5 := Task.LastReadMD5;

  if param.Exists('func') then
      ComputeFunc := param['func']
  else if param.Exists('compute') then
      ComputeFunc := param['compute']
  else
      ComputeFunc := param.GetDefaultValue_Str('ComputeFunc', '');

  inputfile1 := '';
  inputfile2 := '';
  inputstream1 := TMS64.Create;
  inputstream2 := TMS64.Create;
  inputraster1 := NewPasAI_Raster();
  inputraster2 := NewPasAI_Raster();
  inputImgList := TPas_AI_ImageList.Create;
  inputImgMatrix := TPas_AI_ImageMatrix.Create;
  test_imgList := TPas_AI_ImageList.Create;
  test_imgMatrix := TPas_AI_ImageMatrix.Create;
  ResultValues := THashVariantList.Create;

  ResultValues['Begin'] := umlDateTimeToStr(umlNow());
  startTick := GetTimeTick();
  try
    if umlMultipleMatch(['TrainDCGAN', 'TrainingDCGAN'], ComputeFunc) then
      begin
{$REGION 'DCGAN'}
        inputfile1 := param.GetDefaultValue_Str('source', '');

        if Task.Exists(inputfile1) then
          begin
            try
              if umlMultipleMatch('*' + C_ImageMatrix_Ext, inputfile1) then
                begin
                  Task.Read(inputfile1, inputImgMatrix);
                  inputImgMatrix.Scale(param.GetDefaultValue('scale', 1.0));
                end
              else
                begin
                  Task.Read(inputfile1, inputImgList);
                  inputImgList.Scale(param.GetDefaultValue('scale', 1.0));
                end;

              { init sync file1. }
              local_sync1 := param.GetDefaultValue_Str('syncfile', 'output' + C_Sync_Ext);
              sync_file1 := umlCombineFileName(AI.RootPath, umlMD5ToStr(umlCombineMD5(param_md5, Task.LastReadMD5)) + C_Sync_Ext);
              umlDeleteFile(sync_file1);
              if Task.Exists(local_sync1) then
                  Task.ReadToFile(local_sync1, sync_file1);
              { init sync file2. }
              local_sync2 := param.GetDefaultValue_Str('syncfile2', 'output' + C_Sync_Ext2);
              sync_file2 := umlCombineFileName(AI.RootPath, umlMD5ToStr(umlCombineMD5(param_md5, Task.LastReadMD5)) + C_Sync_Ext2);
              umlDeleteFile(sync_file2);
              if Task.Exists(local_sync2) then
                  Task.ReadToFile(local_sync2, sync_file2);

              TCore_Thread.Sleep(1);

              output_file := umlCombineFileName(AI.RootPath, umlMD5ToStr(umlCombineMD5(param_md5, Task.LastReadMD5))) + C_DCGAN_Ext;
              DCGAN_param := TPas_AI_TECH_2022.Init_DCGAN_DNN_TrainParam(sync_file1, output_file);

              DCGAN_param^.timeout := param.GetDefaultValue('timeout', DCGAN_param^.timeout);
              DCGAN_param^.rand_seed := param.GetDefaultValue('rand_seed', DCGAN_param^.rand_seed);
              DCGAN_param^.max_iterations := param.GetDefaultValue('max_iterations', DCGAN_param^.max_iterations);
              DCGAN_param^.iteration_sync_step := param.GetDefaultValue('iteration_sync_step', DCGAN_param^.iteration_sync_step);
              DCGAN_param^.learning_rate := param.GetDefaultValue('learning_rate', DCGAN_param^.learning_rate);
              DCGAN_param^.mini_batch := param.GetDefaultValue('mini_batch', DCGAN_param^.mini_batch);

              if umlMultipleMatch('*' + C_ImageMatrix_Ext, inputfile1) then
                  outputstream := AI.DCGAN_DNN_Train_Stream(
                param.GetDefaultValue('Snapshot', False),
                  inputImgMatrix, DCGAN_param)
              else
                  outputstream := AI.DCGAN_DNN_Train_Stream(
                param.GetDefaultValue('Snapshot', False),
                  inputImgList, DCGAN_param);

              TPas_AI_TECH_2022.Free_DCGAN_DNN_TrainParam(DCGAN_param);

              { write sync1 to task }
              if umlFileExists(sync_file1) then
                  Task.WriteFile(local_sync1, sync_file1);
              { write sync2 to task }
              if umlFileExists(sync_file2) then
                  Task.WriteFile(local_sync2, sync_file2);

              if outputstream <> nil then
                begin
                  Task.write(param.GetDefaultValue_Str('output', 'output' + C_DCGAN_Ext), outputstream);
                  DisposeObject(outputstream);
                  ResultValues['Loss'] := AI.Last_training_average_loss;
                  ResultValues['Rate'] := AI.Last_training_learning_rate;
                  ResultValues['TargetRate'] := 0;
                  Result := True;
                end;
            except
            end;
          end;
{$ENDREGION 'DCGAN'}
      end
    else if umlMultipleMatch(['TrainZMetricV2', 'TrainingZMetricV2'], ComputeFunc) then
      begin
{$REGION 'ZMetric_V2'}
        inputfile1 := param.GetDefaultValue_Str('source', '');

        if Task.Exists(inputfile1) then
          begin
            try
              if umlMultipleMatch('*' + C_ImageMatrix_Ext, inputfile1) then
                  Task.Read(inputfile1, inputImgMatrix)
              else
                  Task.Read(inputfile1, inputImgList);

              { init sync file1. }
              local_sync1 := param.GetDefaultValue_Str('syncfile', 'output' + C_Sync_Ext);
              sync_file1 := umlCombineFileName(AI.RootPath, umlMD5ToStr(umlCombineMD5(param_md5, Task.LastReadMD5)) + C_Sync_Ext);
              umlDeleteFile(sync_file1);
              if Task.Exists(local_sync1) then
                  Task.ReadToFile(local_sync1, sync_file1);
              { init sync file2. }
              local_sync2 := param.GetDefaultValue_Str('syncfile2', 'output' + C_Sync_Ext2);
              sync_file2 := umlCombineFileName(AI.RootPath, umlMD5ToStr(umlCombineMD5(param_md5, Task.LastReadMD5)) + C_Sync_Ext2);
              umlDeleteFile(sync_file2);
              if Task.Exists(local_sync2) then
                  Task.ReadToFile(local_sync2, sync_file2);

              output_file := umlCombineFileName(AI.RootPath, umlMD5ToStr(umlCombineMD5(param_md5, Task.LastReadMD5))) + C_ZMetric_V2_Ext;

              ZMetric_V2_param := TPas_AI_TECH_2022.Init_ZMetric_V2_Parameter(sync_file1, output_file);

              ZMetric_V2_param^.timeout := param.GetDefaultValue('timeout', ZMetric_V2_param^.timeout);
              ZMetric_V2_param^.weight_decay := param.GetDefaultValue('weight_decay', ZMetric_V2_param^.weight_decay);
              ZMetric_V2_param^.momentum := param.GetDefaultValue('momentum', ZMetric_V2_param^.momentum);
              ZMetric_V2_param^.iterations_without_progress_threshold := param.GetDefaultValue('iterations_without_progress_threshold', ZMetric_V2_param^.iterations_without_progress_threshold);
              ZMetric_V2_param^.min_learning_rate := param.GetDefaultValue('min_learning_rate', ZMetric_V2_param^.min_learning_rate);
              ZMetric_V2_param^.learning_rate := param.GetDefaultValue('learning_rate', ZMetric_V2_param^.learning_rate);
              ZMetric_V2_param^.completed_learning_rate := param.GetDefaultValue('completed_learning_rate', ZMetric_V2_param^.completed_learning_rate);
              ZMetric_V2_param^.step_mini_batch_target_num := param.GetDefaultValue('step_mini_batch_target_num', ZMetric_V2_param^.step_mini_batch_target_num);
              ZMetric_V2_param^.step_mini_batch_jitter_num := param.GetDefaultValue('step_mini_batch_jitter_num', ZMetric_V2_param^.step_mini_batch_jitter_num);
              ZMetric_V2_param^.auto_flip_left_right := param.GetDefaultValue('auto_flip_left_right', ZMetric_V2_param^.auto_flip_left_right);
              ZMetric_V2_param^.jitter_ss_width := param.GetDefaultValue('jitter_ss_width', ZMetric_V2_param^.jitter_ss_width);
              ZMetric_V2_param^.jitter_ss_height := param.GetDefaultValue('jitter_ss_height', ZMetric_V2_param^.jitter_ss_height);
              ZMetric_V2_param^.jitter_XY_Offset_Scale := param.GetDefaultValue('jitter_XY_Offset_Scale', ZMetric_V2_param^.jitter_XY_Offset_Scale);
              ZMetric_V2_param^.jitter_Rotate := param.GetDefaultValue('jitter_Rotate', ZMetric_V2_param^.jitter_Rotate);
              ZMetric_V2_param^.jitter_Scale := param.GetDefaultValue('jitter_Scale', ZMetric_V2_param^.jitter_Scale);
              ZMetric_V2_param^.jitter_inner_fit := param.GetDefaultValue('jitter_inner_fit', ZMetric_V2_param^.jitter_inner_fit);
              ZMetric_V2_param^.jitter_thread_num := param.GetDefaultValue('jitter_thread_num', ZMetric_V2_param^.jitter_thread_num);
              ZMetric_V2_param^.Max_Data_Queue := param.GetDefaultValue('Max_Data_Queue', ZMetric_V2_param^.Max_Data_Queue);

              if umlMultipleMatch('*' + C_ImageMatrix_Ext, inputfile1) then
                  outputstream := AI.ZMetric_V2_Train_Stream(inputImgMatrix, ZMetric_V2_param)
              else
                  outputstream := AI.ZMetric_V2_Train_Stream(inputImgList, ZMetric_V2_param);

              TPas_AI_TECH_2022.Free_ZMetric_V2_Parameter(ZMetric_V2_param);

              { write sync1 to task }
              if umlFileExists(sync_file1) then
                  Task.WriteFile(local_sync1, sync_file1)
              else
                  DoStatus('warning: no exists %s', [local_sync1]);

              { write sync2 to task }
              if umlFileExists(sync_file2) then
                  Task.WriteFile(local_sync2, sync_file2);

              if outputstream <> nil then
                begin
                  Task.write(param.GetDefaultValue_Str('output', 'output' + C_ZMetric_V2_Ext), outputstream);

                  if (param.GetDefaultValue('LearnVec', True) = True) and (AI.TrainingControl.stop = 0) then
                    begin
                      LearnEng := TPas_AI_TECH_2022.Build_ZMetric_V2_Learn;
                      outputstream.Position := 0;

                      if (param.GetDefaultValue('Learn_Include_Prepare_Raster', True) = False) then
                        begin
                          if umlMultipleMatch('*' + C_ImageMatrix_Ext, inputfile1) then
                              inputImgMatrix.ClearPrepareRaster
                          else
                              inputImgList.ClearPrepareRaster;
                        end;

                      DoStatus('build Z-Metric V2.0 to Learn.KDTree');

                      if umlMultipleMatch('*' + C_ImageMatrix_Ext, inputfile1) then
                          AI.ZMetric_V2_Save_To_Learn_DNN_Thread(
                        param.GetDefaultValue('Learn_Jitter', True),
                          param.GetDefaultValue('Learn_Jitter_Num', 50),
                          param.GetDefaultValue('Learn_Thread_Num', 10),
                          outputstream,
                          inputImgMatrix,
                          LearnEng)
                      else
                          AI.ZMetric_V2_Save_To_Learn_DNN_Thread(
                        param.GetDefaultValue('Learn_Jitter', True),
                          param.GetDefaultValue('Learn_Jitter_Num', 50),
                          param.GetDefaultValue('Learn_Thread_Num', 10),
                          outputstream,
                          inputImgList,
                          LearnEng);

                      DoStatus('process Z-Metric V2.0 to Learn.KDTree done.');

                      TmpM64 := TMS64.Create;
                      LearnEng.SaveToStream(TmpM64);
                      output_learn_file := umlChangeFileExt(param.GetDefaultValue_Str('output', 'output' + C_ZMetric_V2_Ext), C_Learn_Ext);
                      Task.write(param.GetDefaultValue_Str('output' + C_Learn_Ext, output_learn_file), TmpM64);
                      DisposeObject(TmpM64);
                      DisposeObject(LearnEng);
                    end;

                  DisposeObject(outputstream);
                  ResultValues['Loss'] := AI.Last_training_average_loss;
                  ResultValues['Rate'] := AI.Last_training_learning_rate;
                  ResultValues['TargetRate'] := 0;
                  Result := True;
                end;
            except
            end;
          end;
{$ENDREGION 'ZMetric_V2'}
      end
    else if umlMultipleMatch(['YOLOX', 'YOLO-X', 'YOLO'], ComputeFunc) then
      begin
{$REGION 'YOLO_X'}
        inputfile1 := param.GetDefaultValue_Str('source', '');

        if Task.Exists(inputfile1) then
          begin
            try
              if umlMultipleMatch('*' + C_ImageMatrix_Ext, inputfile1) then
                begin
                  Task.Read(inputfile1, inputImgMatrix);
                  inputImgMatrix.Scale(param.GetDefaultValue('scale', 1.0));
                  if param.GetDefaultValue('NoLabel', True) = True then
                      inputImgMatrix.RunScript('True', 'SetLabel(' + #39#39 + ')');
                end
              else
                begin
                  Task.Read(inputfile1, inputImgList);
                  inputImgList.Scale(param.GetDefaultValue('scale', 1.0));
                  if param.GetDefaultValue('NoLabel', True) = True then
                      inputImgList.RunScript('True', 'SetLabel(' + #39#39 + ')');
                end;

              { init sync file1. }
              local_sync1 := param.GetDefaultValue_Str('syncfile', 'output' + C_Sync_Ext);
              sync_file1 := umlCombineFileName(AI.RootPath, umlMD5ToStr(umlCombineMD5(param_md5, Task.LastReadMD5)) + C_Sync_Ext);
              umlDeleteFile(sync_file1);
              if Task.Exists(local_sync1) then
                  Task.ReadToFile(local_sync1, sync_file1);
              { init sync file2. }
              local_sync2 := param.GetDefaultValue_Str('syncfile2', 'output' + C_Sync_Ext2);
              sync_file2 := umlCombineFileName(AI.RootPath, umlMD5ToStr(umlCombineMD5(param_md5, Task.LastReadMD5)) + C_Sync_Ext2);
              umlDeleteFile(sync_file2);
              if Task.Exists(local_sync2) then
                  Task.ReadToFile(local_sync2, sync_file2);

              output_file := umlCombineFileName(AI.RootPath, umlMD5ToStr(umlCombineMD5(param_md5, Task.LastReadMD5))) + C_YOLO_X_Ext;

              YOLO_X_param := TPas_AI_TECH_2022.Init_YOLO_X_Parameter(sync_file1, output_file);

              YOLO_X_param^.timeout := param.GetDefaultValue('timeout', YOLO_X_param^.timeout);
              YOLO_X_param^.iou_ignore_threshold := param.GetDefaultValue('iou_ignore_threshold', YOLO_X_param^.iou_ignore_threshold);
              YOLO_X_param^.iou_anchor_threshold := param.GetDefaultValue('iou_anchor_threshold', YOLO_X_param^.iou_anchor_threshold);
              YOLO_X_param^.begin_learning_rate := param.GetDefaultValue('begin_learning_rate', YOLO_X_param^.begin_learning_rate);
              YOLO_X_param^.complete_learning_rate := param.GetDefaultValue('complete_learning_rate', YOLO_X_param^.complete_learning_rate);
              YOLO_X_param^.iterations_without_progress_threshold := param.GetDefaultValue('iterations_without_progress_threshold', YOLO_X_param^.iterations_without_progress_threshold);
              YOLO_X_param^.prepare_unstable_step_num := param.GetDefaultValue('prepare_unstable_step_num', YOLO_X_param^.prepare_unstable_step_num);
              YOLO_X_param^.learning_rate_shrink_factor := param.GetDefaultValue('learning_rate_shrink_factor', YOLO_X_param^.learning_rate_shrink_factor);
              { These are the anchors computed on user custom dataset, presented in the YOLO-X paper. }
              eVec := EvaluateExpressionVector(param.GetDefaultValue_Str('T8', PFormat('%d,%d,%d,%d,%d,%d', [YOLO_X_param^.T8_1_X, YOLO_X_param^.T8_1_Y, YOLO_X_param^.T8_2_X, YOLO_X_param^.T8_2_Y, YOLO_X_param^.T8_3_X, YOLO_X_param^.T8_3_Y])));
              if Length(eVec) = 6 then
                begin
                  YOLO_X_param^.T8_1_X := eVec[0];
                  YOLO_X_param^.T8_1_Y := eVec[1];
                  YOLO_X_param^.T8_2_X := eVec[2];
                  YOLO_X_param^.T8_2_Y := eVec[3];
                  YOLO_X_param^.T8_3_X := eVec[4];
                  YOLO_X_param^.T8_3_Y := eVec[5];
                end;
              eVec := EvaluateExpressionVector(param.GetDefaultValue_Str('T16', PFormat('%d,%d,%d,%d,%d,%d', [YOLO_X_param^.T16_1_X, YOLO_X_param^.T16_1_Y, YOLO_X_param^.T16_2_X, YOLO_X_param^.T16_2_Y, YOLO_X_param^.T16_3_X, YOLO_X_param^.T16_3_Y])));
              if Length(eVec) = 6 then
                begin
                  YOLO_X_param^.T16_1_X := eVec[0];
                  YOLO_X_param^.T16_1_Y := eVec[1];
                  YOLO_X_param^.T16_2_X := eVec[2];
                  YOLO_X_param^.T16_2_Y := eVec[3];
                  YOLO_X_param^.T16_3_X := eVec[4];
                  YOLO_X_param^.T16_3_Y := eVec[5];
                end;
              eVec := EvaluateExpressionVector(param.GetDefaultValue_Str('T32', PFormat('%d,%d,%d,%d,%d,%d', [YOLO_X_param^.T32_1_X, YOLO_X_param^.T32_1_Y, YOLO_X_param^.T32_2_X, YOLO_X_param^.T32_2_Y, YOLO_X_param^.T32_3_X, YOLO_X_param^.T32_3_Y])));
              if Length(eVec) = 6 then
                begin
                  YOLO_X_param^.T32_1_X := eVec[0];
                  YOLO_X_param^.T32_1_Y := eVec[1];
                  YOLO_X_param^.T32_2_X := eVec[2];
                  YOLO_X_param^.T32_2_Y := eVec[3];
                  YOLO_X_param^.T32_3_X := eVec[4];
                  YOLO_X_param^.T32_3_Y := eVec[5];
                end;
              { cropper param }
              YOLO_X_param^.batch_size := param.GetDefaultValue('batch_size', YOLO_X_param^.batch_size);
              YOLO_X_param^.max_object_size := param.GetDefaultValue('max_object_size', YOLO_X_param^.max_object_size);
              YOLO_X_param^.min_object_size_x := param.GetDefaultValue('min_object_size_x', YOLO_X_param^.min_object_size_x);
              YOLO_X_param^.min_object_size_y := param.GetDefaultValue('min_object_size_y', YOLO_X_param^.min_object_size_y);
              YOLO_X_param^.max_rotation_degrees := param.GetDefaultValue('max_rotation_degrees', YOLO_X_param^.max_rotation_degrees);
              YOLO_X_param^.translate_amount := param.GetDefaultValue('translate_amount', YOLO_X_param^.translate_amount);
              YOLO_X_param^.randomly_flip := param.GetDefaultValue('randomly_flip', YOLO_X_param^.randomly_flip);
              YOLO_X_param^.background_crops_fraction := param.GetDefaultValue('background_crops_fraction', YOLO_X_param^.background_crops_fraction);
              YOLO_X_param^.min_object_coverage := param.GetDefaultValue('min_object_coverage', YOLO_X_param^.min_object_coverage);
              YOLO_X_param^.alternate_between_cropping := param.GetDefaultValue('alternate_between_cropping', YOLO_X_param^.alternate_between_cropping);
              YOLO_X_param^.training_thread_num := param.GetDefaultValue('training_thread_num', YOLO_X_param^.training_thread_num);
              YOLO_X_param^.max_training_batch_queue_num := param.GetDefaultValue('max_training_batch_queue_num', YOLO_X_param^.max_training_batch_queue_num);
              { test param }
              YOLO_X_param^.test_thread_num := param.GetDefaultValue('test_thread_num', YOLO_X_param^.test_thread_num);
              YOLO_X_param^.max_test_batch_queue_num := param.GetDefaultValue('max_test_batch_queue_num', YOLO_X_param^.max_test_batch_queue_num);
              YOLO_X_param^.test_steps := param.GetDefaultValue('test_steps', YOLO_X_param^.test_steps);

              if umlMultipleMatch('*' + C_ImageMatrix_Ext, inputfile1) then
                begin
                  if YOLO_X_param^.test_steps > 0 then
                      inputImgMatrix.RemoveTestAndBuildImageMatrix(test_imgMatrix);
                  outputstream := AI.YOLO_X_DNN_Train_Stream(YOLO_X_param, inputImgMatrix, test_imgMatrix);
                end
              else
                begin
                  if YOLO_X_param^.test_steps > 0 then
                      inputImgList.RemoveTestAndBuildImageList(test_imgList);
                  outputstream := AI.YOLO_X_DNN_Train_Stream(YOLO_X_param, inputImgList, test_imgList);
                end;

              TPas_AI_TECH_2022.Free_YOLO_X_Parameter(YOLO_X_param);

              { write sync1 to task }
              if umlFileExists(sync_file1) then
                  Task.WriteFile(local_sync1, sync_file1)
              else
                  DoStatus('warning: no exists %s', [local_sync1]);

              { write sync2 to task }
              if umlFileExists(sync_file2) then
                  Task.WriteFile(local_sync2, sync_file2);

              if outputstream <> nil then
                begin
                  Task.write(param.GetDefaultValue_Str('output', 'output' + C_YOLO_X_Ext), outputstream);
                  DisposeObject(outputstream);
                  ResultValues['Loss'] := AI.Last_training_average_loss;
                  ResultValues['Rate'] := AI.Last_training_learning_rate;
                  ResultValues['TargetRate'] := 0;
                  Result := True;
                end;
            except
            end;
          end;
{$ENDREGION 'YOLO_X'}
      end
    else if umlMultipleMatch(['TrainSSL', 'TrainingSSL'], ComputeFunc) then
      begin
{$REGION 'SSL'}
        inputfile1 := param.GetDefaultValue_Str('source', '');

        if Task.Exists(inputfile1) then
          begin
            try
              if umlMultipleMatch('*' + C_ImageMatrix_Ext, inputfile1) then
                begin
                  Task.Read(inputfile1, inputImgMatrix);
                  inputImgMatrix.Scale(param.GetDefaultValue('scale', 1.0));
                end
              else
                begin
                  Task.Read(inputfile1, inputImgList);
                  inputImgList.Scale(param.GetDefaultValue('scale', 1.0));
                end;

              { init sync file1. }
              local_sync1 := param.GetDefaultValue_Str('syncfile', 'output' + C_Sync_Ext);
              sync_file1 := umlCombineFileName(AI.RootPath, umlMD5ToStr(umlCombineMD5(param_md5, Task.LastReadMD5)) + C_Sync_Ext);
              umlDeleteFile(sync_file1);
              if Task.Exists(local_sync1) then
                  Task.ReadToFile(local_sync1, sync_file1);
              { init sync file2. }
              local_sync2 := param.GetDefaultValue_Str('syncfile2', 'output' + C_Sync_Ext2);
              sync_file2 := umlCombineFileName(AI.RootPath, umlMD5ToStr(umlCombineMD5(param_md5, Task.LastReadMD5)) + C_Sync_Ext2);
              umlDeleteFile(sync_file2);
              if Task.Exists(local_sync2) then
                  Task.ReadToFile(local_sync2, sync_file2);

              output_file := umlCombineFileName(AI.RootPath, umlMD5ToStr(umlCombineMD5(param_md5, Task.LastReadMD5))) + C_SSL_Ext;

              SSL_param := TPas_AI_TECH_2022.Init_SSL_Parameter(sync_file1, output_file);
              SSL_param^.timeout := param.GetDefaultValue('timeout', SSL_param^.timeout);

              { trainer }
              SSL_param^.iterations_without_progress_threshold := param.GetDefaultValue('iterations_without_progress_threshold', SSL_param^.iterations_without_progress_threshold);
              SSL_param^.min_learning_rate := param.GetDefaultValue('min_learning_rate', SSL_param^.min_learning_rate);
              SSL_param^.learning_rate := param.GetDefaultValue('learning_rate', SSL_param^.learning_rate);
              SSL_param^.completed_learning_rate := param.GetDefaultValue('completed_learning_rate', SSL_param^.completed_learning_rate);
              SSL_param^.batch_num := param.GetDefaultValue('batch_num', SSL_param^.batch_num);
              SSL_param^.dims := param.GetDefaultValue('dims', SSL_param^.dims);
              SSL_param^.lambda := param.GetDefaultValue('lambda', SSL_param^.lambda);
              { jitter }
              SSL_param^.Max_Data_Queue := param.GetDefaultValue('Max_Data_Queue', SSL_param^.Max_Data_Queue);
              SSL_param^.jitter_thread_num := param.GetDefaultValue('jitter_thread_num', SSL_param^.jitter_thread_num);
              SSL_param^.scale_size_x := param.GetDefaultValue('scale_size_x', SSL_param^.scale_size_x);
              SSL_param^.scale_size_y := param.GetDefaultValue('scale_size_y', SSL_param^.scale_size_y);
              SSL_param^.scale_pos_x := param.GetDefaultValue('scale_pos_x', SSL_param^.scale_pos_x);
              SSL_param^.scale_pos_y := param.GetDefaultValue('scale_pos_y', SSL_param^.scale_pos_y);
              SSL_param^.XY_Offset_Scale := param.GetDefaultValue('jitter_XY_Offset_Scale', SSL_param^.XY_Offset_Scale);
              SSL_param^.Rotate := param.GetDefaultValue('jitter_Rotate', SSL_param^.Rotate);
              SSL_param^.Scale := param.GetDefaultValue('jitter_Scale', SSL_param^.Scale);
              SSL_param^.sampling_size_x := param.GetDefaultValue('sampling_size_x', SSL_param^.sampling_size_x);
              SSL_param^.sampling_size_y := param.GetDefaultValue('sampling_size_y', SSL_param^.sampling_size_y);
              SSL_param^.Fit_Matrix_Box := param.GetDefaultValue('Fit_Matrix_Box', SSL_param^.Fit_Matrix_Box);
              SSL_param^.lock_sampler := param.GetDefaultValue('lock_sampler', SSL_param^.lock_sampler);
              { transform frequency }
              SSL_param^.left_right_flip := param.GetDefaultValue('left_right_flip', SSL_param^.left_right_flip);
              SSL_param^.disturb_colors := param.GetDefaultValue('disturb_colors', SSL_param^.disturb_colors);
              SSL_param^.grayscale := param.GetDefaultValue('grayscale', SSL_param^.grayscale);

              if umlMultipleMatch('*' + C_ImageMatrix_Ext, inputfile1) then
                  outputstream := AI.SSL_Train_Stream(inputImgMatrix, SSL_param)
              else
                  outputstream := AI.SSL_Train_Stream(inputImgList, SSL_param);

              TPas_AI_TECH_2022.Free_SSL_Parameter(SSL_param);

              { write sync1 to task }
              if umlFileExists(sync_file1) then
                  Task.WriteFile(local_sync1, sync_file1)
              else
                  DoStatus('warning: no exists %s', [local_sync1]);

              { write sync2 to task }
              if umlFileExists(sync_file2) then
                  Task.WriteFile(local_sync2, sync_file2);

              if outputstream <> nil then
                begin
                  Task.write(param.GetDefaultValue_Str('output', 'output' + C_SSL_Ext), outputstream);

                  if (param.GetDefaultValue('LearnVec', True) = True) and (AI.TrainingControl.stop = 0) then
                    begin
                      LearnEng := TPas_AI_TECH_2022.Build_SSL_Learn;
                      outputstream.Position := 0;

                      DoStatus('build SSL to Learn.KDTree');

                      if umlMultipleMatch('*' + C_ImageMatrix_Ext, inputfile1) then
                          AI.SSL_Save_To_Learn_DNN_Thread(param.GetDefaultValue('LearnVec_Jitter_Num', 80),
                          param.GetDefaultValue('LearnVec_Thread_Num', 4),
                          outputstream,
                          inputImgMatrix,
                          LearnEng)
                      else
                          AI.SSL_Save_To_Learn_DNN_Thread(param.GetDefaultValue('LearnVec_Jitter_Num', 80),
                          param.GetDefaultValue('LearnVec_Thread_Num', 4),
                          outputstream,
                          inputImgList,
                          LearnEng);

                      DoStatus('process SSL to Learn.KDTree done.');

                      TmpM64 := TMS64.Create;
                      LearnEng.SaveToStream(TmpM64);
                      output_learn_file := umlChangeFileExt(param.GetDefaultValue_Str('output', 'output' + C_SSL_Ext), C_Learn_Ext);
                      Task.write(param.GetDefaultValue_Str('output' + C_Learn_Ext, output_learn_file), TmpM64);
                      DisposeObject(TmpM64);
                      DisposeObject(LearnEng);
                    end;

                  DisposeObject(outputstream);
                  ResultValues['Loss'] := AI.Last_training_average_loss;
                  ResultValues['Rate'] := AI.Last_training_learning_rate;
                  ResultValues['TargetRate'] := 0;
                  Result := True;
                end;
            except
            end;
          end;
{$ENDREGION 'SSL'}
      end;
  finally
    ResultValues['Result'] := Result;
    ResultValues['End'] := umlDateTimeToStr(umlNow());
    DoStatus('usage time: %s', [umlTimeTickToStr(GetTimeTick() - startTick).Text]);

    Task.write(param.GetDefaultValue('result', 'result.txt'), ResultValues);
    Task.write(param.GetDefaultValue('log', 'log.txt'), Task.TaskLogStatus);

    if Result then
      begin
        if Task.LastWriteFileList.ExistsValue(paramFile) < 0 then
            Task.LastWriteFileList.Add(paramFile);
        Task.write(param.GetDefaultValue('LastOutput', 'LastOutput.txt'), Task.LastWriteFileList);
      end;
  end;
  DisposeObject(param);
  DisposeObject([inputstream1, inputstream2]);
  DisposeObject([inputraster1, inputraster2]);
  DisposeObject(inputImgList);
  DisposeObject(inputImgMatrix);
  DisposeObject(test_imgList);
  DisposeObject(test_imgMatrix);
  DisposeObject(ResultValues);
  DoStatus('AI_TECH_2022_RunTrainingTask return: %s', [umlBoolToStr(Result).Text]);
end;

function AI_TECH_2022_RunLargeScaleTrainingTask(
ImgMatDatasetFile, RasterSerializedFile, Training_RasterSerializedFile, SyncFile, OutputModel: U_String;
AI: TPas_AI_TECH_2022; param: THashVariantList): Boolean;
var
  ComputeFunc: SystemString;
  train_Img_Matrix: TPas_AI_ImageMatrix;
  test_Img_Matrix: TPas_AI_ImageMatrix;

  { Image Matrix Serialized }
  RSeriStream: TCore_FileStream;
  RSeri: TPasAI_RasterSerialized;

  { Training Matrix Serialized }
  Training_RSeriStream: TCore_FileStream;
  Training_RSeri: TPasAI_RasterSerialized;

  { temp stream }
  m64: TMS64;
  i: Integer;

  { ai build-in param }
  ZMetric_V2_param: PAI_TECH_2022_ZMetric_V2_Train_Parameter;
  YOLO_X_param: PPas_AI_TECH_2022_YOLO_X_Train_Parameter;
  SSL_param: PPas_AI_TECH_2022_SSL_Train_Parameter;

  { data support }
  output_learn_file: SystemString;
  LearnEng: TLearn;
  kd: TKDTree;
  KD_Data: TKDTreeDataList;
  eVec: TExpressionValueVector;
begin
  Result := False;
  if not AI.Activted then
    begin
      DoStatus('AI-Tech2022 engine error.');
      exit;
    end;
  if not umlFileExists(ImgMatDatasetFile) then
    begin
      DoStatus('no exists %s', [ImgMatDatasetFile.Text]);
      exit;
    end;

  DoStatus('init Serialized temp file: %s', [RasterSerializedFile.Text]);
  RSeriStream := TCore_FileStream.Create(RasterSerializedFile, fmCreate);
  RSeri := TPasAI_RasterSerialized.Create(RSeriStream);

  DoStatus('init training serialized temp file: %s', [Training_RasterSerializedFile.Text]);
  Training_RSeriStream := TCore_FileStream.Create(Training_RasterSerializedFile, fmCreate);
  Training_RSeri := TPasAI_RasterSerialized.Create(Training_RSeriStream);

  train_Img_Matrix := TPas_AI_ImageMatrix.Create;
  train_Img_Matrix.LargeScale_LoadFromFile(RSeri, ImgMatDatasetFile);
  test_Img_Matrix := TPas_AI_ImageMatrix.Create;

  if param.Exists('func') then
      ComputeFunc := param['func']
  else if param.Exists('compute') then
      ComputeFunc := param['compute']
  else
      ComputeFunc := param.GetDefaultValue_Str('ComputeFunc', '');

  DoStatus('run large-scale training.');
  if umlMultipleMatch(['TrainZMetricV2', 'TrainingZMetricV2'], ComputeFunc) then
    begin
{$REGION 'ZMetricV2'}
      ZMetric_V2_param := TPas_AI_TECH_2022.Init_ZMetric_V2_Parameter(SyncFile, OutputModel);

      ZMetric_V2_param^.timeout := param.GetDefaultValue('timeout', ZMetric_V2_param^.timeout);
      ZMetric_V2_param^.weight_decay := param.GetDefaultValue('weight_decay', ZMetric_V2_param^.weight_decay);
      ZMetric_V2_param^.momentum := param.GetDefaultValue('momentum', ZMetric_V2_param^.momentum);
      ZMetric_V2_param^.iterations_without_progress_threshold := param.GetDefaultValue('iterations_without_progress_threshold', ZMetric_V2_param^.iterations_without_progress_threshold);
      ZMetric_V2_param^.min_learning_rate := param.GetDefaultValue('min_learning_rate', ZMetric_V2_param^.min_learning_rate);
      ZMetric_V2_param^.learning_rate := param.GetDefaultValue('learning_rate', ZMetric_V2_param^.learning_rate);
      ZMetric_V2_param^.completed_learning_rate := param.GetDefaultValue('completed_learning_rate', ZMetric_V2_param^.completed_learning_rate);
      ZMetric_V2_param^.step_mini_batch_target_num := param.GetDefaultValue('step_mini_batch_target_num', ZMetric_V2_param^.step_mini_batch_target_num);
      ZMetric_V2_param^.step_mini_batch_jitter_num := param.GetDefaultValue('step_mini_batch_jitter_num', ZMetric_V2_param^.step_mini_batch_jitter_num);
      ZMetric_V2_param^.auto_flip_left_right := param.GetDefaultValue('auto_flip_left_right', ZMetric_V2_param^.auto_flip_left_right);
      ZMetric_V2_param^.jitter_ss_width := param.GetDefaultValue('jitter_ss_width', ZMetric_V2_param^.jitter_ss_width);
      ZMetric_V2_param^.jitter_ss_height := param.GetDefaultValue('jitter_ss_height', ZMetric_V2_param^.jitter_ss_height);
      ZMetric_V2_param^.jitter_XY_Offset_Scale := param.GetDefaultValue('jitter_XY_Offset_Scale', ZMetric_V2_param^.jitter_XY_Offset_Scale);
      ZMetric_V2_param^.jitter_Rotate := param.GetDefaultValue('jitter_Rotate', ZMetric_V2_param^.jitter_Rotate);
      ZMetric_V2_param^.jitter_Scale := param.GetDefaultValue('jitter_Scale', ZMetric_V2_param^.jitter_Scale);
      ZMetric_V2_param^.jitter_inner_fit := param.GetDefaultValue('jitter_inner_fit', ZMetric_V2_param^.jitter_inner_fit);
      ZMetric_V2_param^.jitter_thread_num := param.GetDefaultValue('jitter_thread_num', ZMetric_V2_param^.jitter_thread_num);
      ZMetric_V2_param^.Max_Data_Queue := param.GetDefaultValue('Max_Data_Queue', ZMetric_V2_param^.Max_Data_Queue);

      { run training. }
      Result := AI.ZMetric_V2_Train(True, RSeri, train_Img_Matrix, ZMetric_V2_param);
      TPas_AI_TECH_2022.Free_ZMetric_V2_Parameter(ZMetric_V2_param);

      if (Result) and (param.GetDefaultValue('LearnVec', True) = True) and (AI.TrainingControl.stop = 0) then
        begin
          LearnEng := TPas_AI_TECH_2022.Build_ZMetric_V2_Learn;

          try
            if (param.GetDefaultValue('Learn_Include_Prepare_Raster', True) = False) then
              begin
                train_Img_Matrix.ClearPrepareRaster;
              end;

            DoStatus('build Z-Metric V2.0 to Learn.KDTree');

            m64 := TMS64.Create;
            m64.LoadFromFile(OutputModel);
            AI.ZMetric_V2_Save_To_Learn_DNN_Thread(
            param.GetDefaultValue('Learn_Jitter', True),
              param.GetDefaultValue('Learn_Jitter_Num', 50),
              param.GetDefaultValue('Learn_Thread_Num', 10),
              m64,
              RSeri,
              train_Img_Matrix,
              LearnEng);
            DisposeObject(m64);

            DoStatus('process Z-Metric V2.0 to Learn.KDTree done.');

            LearnEng.SaveToFile(umlChangeFileExt(OutputModel, C_Learn_Ext));
          except
          end;

          DisposeObject(LearnEng);
        end;

{$ENDREGION 'ZMetricV2'}
    end
  else if umlMultipleMatch(['YOLOX', 'YOLO-X', 'YOLO'], ComputeFunc) then
    begin
{$REGION 'YOLO_X'}
      if param.GetDefaultValue('NoLabel', True) = True then
          train_Img_Matrix.RunScript('True', 'SetLabel(' + #39#39 + ')');

      YOLO_X_param := TPas_AI_TECH_2022.Init_YOLO_X_Parameter(SyncFile, OutputModel);

      YOLO_X_param^.timeout := param.GetDefaultValue('timeout', YOLO_X_param^.timeout);
      YOLO_X_param^.iou_ignore_threshold := param.GetDefaultValue('iou_ignore_threshold', YOLO_X_param^.iou_ignore_threshold);
      YOLO_X_param^.iou_anchor_threshold := param.GetDefaultValue('iou_anchor_threshold', YOLO_X_param^.iou_anchor_threshold);
      YOLO_X_param^.begin_learning_rate := param.GetDefaultValue('begin_learning_rate', YOLO_X_param^.begin_learning_rate);
      YOLO_X_param^.complete_learning_rate := param.GetDefaultValue('complete_learning_rate', YOLO_X_param^.complete_learning_rate);
      YOLO_X_param^.iterations_without_progress_threshold := param.GetDefaultValue('iterations_without_progress_threshold', YOLO_X_param^.iterations_without_progress_threshold);
      YOLO_X_param^.prepare_unstable_step_num := param.GetDefaultValue('prepare_unstable_step_num', YOLO_X_param^.prepare_unstable_step_num);
      YOLO_X_param^.learning_rate_shrink_factor := param.GetDefaultValue('learning_rate_shrink_factor', YOLO_X_param^.learning_rate_shrink_factor);
      { These are the anchors computed on user custom dataset, presented in the YOLO-X paper. }
      eVec := EvaluateExpressionVector(param.GetDefaultValue_Str('T8', PFormat('%d,%d,%d,%d,%d,%d', [YOLO_X_param^.T8_1_X, YOLO_X_param^.T8_1_Y, YOLO_X_param^.T8_2_X, YOLO_X_param^.T8_2_Y, YOLO_X_param^.T8_3_X, YOLO_X_param^.T8_3_Y])));
      if Length(eVec) = 6 then
        begin
          YOLO_X_param^.T8_1_X := eVec[0];
          YOLO_X_param^.T8_1_Y := eVec[1];
          YOLO_X_param^.T8_2_X := eVec[2];
          YOLO_X_param^.T8_2_Y := eVec[3];
          YOLO_X_param^.T8_3_X := eVec[4];
          YOLO_X_param^.T8_3_Y := eVec[5];
        end;
      eVec := EvaluateExpressionVector(param.GetDefaultValue_Str('T16', PFormat('%d,%d,%d,%d,%d,%d', [YOLO_X_param^.T16_1_X, YOLO_X_param^.T16_1_Y, YOLO_X_param^.T16_2_X, YOLO_X_param^.T16_2_Y, YOLO_X_param^.T16_3_X, YOLO_X_param^.T16_3_Y])));
      if Length(eVec) = 6 then
        begin
          YOLO_X_param^.T16_1_X := eVec[0];
          YOLO_X_param^.T16_1_Y := eVec[1];
          YOLO_X_param^.T16_2_X := eVec[2];
          YOLO_X_param^.T16_2_Y := eVec[3];
          YOLO_X_param^.T16_3_X := eVec[4];
          YOLO_X_param^.T16_3_Y := eVec[5];
        end;
      eVec := EvaluateExpressionVector(param.GetDefaultValue_Str('T32', PFormat('%d,%d,%d,%d,%d,%d', [YOLO_X_param^.T32_1_X, YOLO_X_param^.T32_1_Y, YOLO_X_param^.T32_2_X, YOLO_X_param^.T32_2_Y, YOLO_X_param^.T32_3_X, YOLO_X_param^.T32_3_Y])));
      if Length(eVec) = 6 then
        begin
          YOLO_X_param^.T32_1_X := eVec[0];
          YOLO_X_param^.T32_1_Y := eVec[1];
          YOLO_X_param^.T32_2_X := eVec[2];
          YOLO_X_param^.T32_2_Y := eVec[3];
          YOLO_X_param^.T32_3_X := eVec[4];
          YOLO_X_param^.T32_3_Y := eVec[5];
        end;
      { cropper param }
      YOLO_X_param^.batch_size := param.GetDefaultValue('batch_size', YOLO_X_param^.batch_size);
      YOLO_X_param^.max_object_size := param.GetDefaultValue('max_object_size', YOLO_X_param^.max_object_size);
      YOLO_X_param^.min_object_size_x := param.GetDefaultValue('min_object_size_x', YOLO_X_param^.min_object_size_x);
      YOLO_X_param^.min_object_size_y := param.GetDefaultValue('min_object_size_y', YOLO_X_param^.min_object_size_y);
      YOLO_X_param^.max_rotation_degrees := param.GetDefaultValue('max_rotation_degrees', YOLO_X_param^.max_rotation_degrees);
      YOLO_X_param^.translate_amount := param.GetDefaultValue('translate_amount', YOLO_X_param^.translate_amount);
      YOLO_X_param^.randomly_flip := param.GetDefaultValue('randomly_flip', YOLO_X_param^.randomly_flip);
      YOLO_X_param^.background_crops_fraction := param.GetDefaultValue('background_crops_fraction', YOLO_X_param^.background_crops_fraction);
      YOLO_X_param^.min_object_coverage := param.GetDefaultValue('min_object_coverage', YOLO_X_param^.min_object_coverage);
      YOLO_X_param^.alternate_between_cropping := param.GetDefaultValue('alternate_between_cropping', YOLO_X_param^.alternate_between_cropping);
      YOLO_X_param^.training_thread_num := param.GetDefaultValue('training_thread_num', YOLO_X_param^.training_thread_num);
      YOLO_X_param^.max_training_batch_queue_num := param.GetDefaultValue('max_training_batch_queue_num', YOLO_X_param^.max_training_batch_queue_num);
      { test param }
      YOLO_X_param^.test_thread_num := param.GetDefaultValue('test_thread_num', YOLO_X_param^.test_thread_num);
      YOLO_X_param^.max_test_batch_queue_num := param.GetDefaultValue('max_test_batch_queue_num', YOLO_X_param^.max_test_batch_queue_num);
      YOLO_X_param^.test_steps := param.GetDefaultValue('test_steps', YOLO_X_param^.test_steps);

      { run YOLO-X training }
      if YOLO_X_param^.test_steps > 0 then
          train_Img_Matrix.RemoveTestAndBuildImageMatrix(test_Img_Matrix);
      Result := AI.YOLO_X_DNN_Train(YOLO_X_param, RSeri, train_Img_Matrix, test_Img_Matrix) >= 0;

      TPas_AI_TECH_2022.Free_YOLO_X_Parameter(YOLO_X_param);
{$ENDREGION 'YOLO_X'}
    end
  else if umlMultipleMatch(['TrainSSL', 'TrainingSSL'], ComputeFunc) then
    begin
{$REGION 'SSL'}
      SSL_param := TPas_AI_TECH_2022.Init_SSL_Parameter(SyncFile, OutputModel);

      SSL_param^.timeout := param.GetDefaultValue('timeout', SSL_param^.timeout);
      { trainer }
      SSL_param^.iterations_without_progress_threshold := param.GetDefaultValue('iterations_without_progress_threshold', SSL_param^.iterations_without_progress_threshold);
      SSL_param^.min_learning_rate := param.GetDefaultValue('min_learning_rate', SSL_param^.min_learning_rate);
      SSL_param^.learning_rate := param.GetDefaultValue('learning_rate', SSL_param^.learning_rate);
      SSL_param^.completed_learning_rate := param.GetDefaultValue('completed_learning_rate', SSL_param^.completed_learning_rate);
      SSL_param^.batch_num := param.GetDefaultValue('batch_num', SSL_param^.batch_num);
      SSL_param^.dims := param.GetDefaultValue('dims', SSL_param^.dims);
      SSL_param^.lambda := param.GetDefaultValue('lambda', SSL_param^.lambda);
      { jitter }
      SSL_param^.Max_Data_Queue := param.GetDefaultValue('Max_Data_Queue', SSL_param^.Max_Data_Queue);
      SSL_param^.jitter_thread_num := param.GetDefaultValue('jitter_thread_num', SSL_param^.jitter_thread_num);
      SSL_param^.scale_size_x := param.GetDefaultValue('scale_size_x', SSL_param^.scale_size_x);
      SSL_param^.scale_size_y := param.GetDefaultValue('scale_size_y', SSL_param^.scale_size_y);
      SSL_param^.scale_pos_x := param.GetDefaultValue('scale_pos_x', SSL_param^.scale_pos_x);
      SSL_param^.scale_pos_y := param.GetDefaultValue('scale_pos_y', SSL_param^.scale_pos_y);
      SSL_param^.XY_Offset_Scale := param.GetDefaultValue('jitter_XY_Offset_Scale', SSL_param^.XY_Offset_Scale);
      SSL_param^.Rotate := param.GetDefaultValue('jitter_Rotate', SSL_param^.Rotate);
      SSL_param^.Scale := param.GetDefaultValue('jitter_Scale', SSL_param^.Scale);
      SSL_param^.sampling_size_x := param.GetDefaultValue('sampling_size_x', SSL_param^.sampling_size_x);
      SSL_param^.sampling_size_y := param.GetDefaultValue('sampling_size_y', SSL_param^.sampling_size_y);
      SSL_param^.Fit_Matrix_Box := param.GetDefaultValue('Fit_Matrix_Box', SSL_param^.Fit_Matrix_Box);
      SSL_param^.lock_sampler := param.GetDefaultValue('lock_sampler', SSL_param^.lock_sampler);
      { transform frequency }
      SSL_param^.left_right_flip := param.GetDefaultValue('left_right_flip', SSL_param^.left_right_flip);
      SSL_param^.disturb_colors := param.GetDefaultValue('disturb_colors', SSL_param^.disturb_colors);
      SSL_param^.grayscale := param.GetDefaultValue('grayscale', SSL_param^.grayscale);

      { run training. }
      Result := AI.SSL_Train(True, RSeri, train_Img_Matrix, SSL_param);
      TPas_AI_TECH_2022.Free_SSL_Parameter(SSL_param);

      if (Result) and (param.GetDefaultValue('LearnVec', True) = True) and (AI.TrainingControl.stop = 0) then
        begin
          LearnEng := TPas_AI_TECH_2022.Build_SSL_Learn;

          try
            DoStatus('build SSL to Learn.KDTree');

            m64 := TMS64.Create;
            m64.LoadFromFile(OutputModel);
            AI.SSL_Save_To_Learn_DNN_Thread(
            param.GetDefaultValue('LearnVec_Jitter_Num', 80),
              param.GetDefaultValue('LearnVec_Thread_Num', 4),
              m64,
              RSeri,
              train_Img_Matrix,
              LearnEng);
            DisposeObject(m64);

            DoStatus('process SSL to Learn.KDTree done.');

            LearnEng.SaveToFile(umlChangeFileExt(OutputModel, C_Learn_Ext));
          except
          end;

          DisposeObject(LearnEng);
        end;
{$ENDREGION 'SSL'}
    end
  else
    begin
      DoStatus('AI-Tech2022 Training task failed: no define ComputeFunc.');
    end;

  try
    { free train_Img_Matrix }
    DoStatus('free Image Matrix.');
    DisposeObject(train_Img_Matrix);

    { free test_Img_Matrix }
    DoStatus('free test Image Matrix.');
    DisposeObject(test_Img_Matrix);

    { free Rastermization Serialized }
    DoStatus('free Rastermization Serialized.');
    DisposeObject(RSeri);
    DoStatus('free Rastermization Serialized of stream.');
    DisposeObject(RSeriStream);
    DoStatus('remove Serialized temp file %s', [RasterSerializedFile.Text]);
    umlDeleteFile(RasterSerializedFile);

    { free AI Engine Serialized }
    DoStatus('free training Serialized.');
    DisposeObject(Training_RSeri);
    DoStatus('free training Serialized of stream.');
    DisposeObject(Training_RSeriStream);
    DoStatus('remove training temp file %s', [Training_RasterSerializedFile.Text]);
    umlDeleteFile(Training_RasterSerializedFile);
  except
  end;
  DoStatus('AI_TECH_2022_RunLargeScaleTrainingTask return: %s', [umlBoolToStr(Result).Text]);
end;

procedure Filter_YOLO_Desc(var desc: TAI_TECH_2022_DESC);
var
  L: TAI_TECH_2022_DESC_POOL;
  Box_Tool: TNearest_Box_Tool;
  i: Integer;
  p: TAI_TECH_2022_DESC_POOL.PQueueStruct;
begin
  if Length(desc) <= 1 then
      exit;

  L := TAI_TECH_2022_DESC_POOL.Create;
  Box_Tool := TNearest_Box_Tool.Create;
  for i := 0 to Length(desc) - 1 do
    begin
      p := L.Add(desc[i]);
      Box_Tool.Add_Box(@p^.Data.R, p, nil);
    end;
  Box_Tool.Compute_Nearest_Box(0, 0);
  { IoU overlap supression }
  if Box_Tool.IoU_Tool.Num > 0 then
    with Box_Tool.IoU_Tool.Repeat_ do
      repeat
        if queue^.Data.R1A < queue^.Data.R2A then
          begin
            if queue^.Data.RA / queue^.Data.R1A > 0.8 then
                L.Push_To_Recycle_Pool(queue^.Data.p1^.UserData);
          end
        else
          begin
            if queue^.Data.RA / queue^.Data.R2A > 0.8 then
                L.Push_To_Recycle_Pool(queue^.Data.p2^.UserData);
          end;
      until not Next;
  L.Free_Recycle_Pool;
  { finish }
  SetLength(desc, L.Num);
  if L.Num > 0 then
    with L.Repeat_ do
      repeat
        desc[I__] := queue^.Data;
        queue^.Data.Token := '';
      until not Next;
  { free }
  DisposeObject(L);
  DisposeObject(Box_Tool);
end;

initialization

Init_AI_TECH_2022_BuildIn;
AI_TECH_2022_Global_DNN_ThreadPool := TPas_AI_TECH_2022_Global_DNN_ThreadPool.Create;
AI_TECH_2022_Large_Scale_Training_Memory_Recycle_Time := 5 * C_Tick_Second;
AI_TECH_2022_Recycle_Swap_Pool_Time := 5 * C_Tick_Second;
On_Prepare_AI_Engine_TECH_2022 := nil;

finalization

Free_AI_TECH_2022_BuildIn;
DisposeObjectAndNil(AI_TECH_2022_Global_DNN_ThreadPool);

end.
