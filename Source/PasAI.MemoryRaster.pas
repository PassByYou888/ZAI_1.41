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
{ * memory Rasterization                                                       * }
{ ****************************************************************************** }
unit PasAI.MemoryRaster;

{$DEFINE FPC_DELPHI_MODE}
{$I PasAI.Define.inc}

interface

uses Types, Math, Variants, TypInfo,
  PasAI.Core, PasAI.MemoryStream, PasAI.Geometry2D, PasAI.Geometry3D,
  PasAI.PascalStrings, PasAI.UPascalStrings, PasAI.UnicodeMixedLib,
{$IFDEF FPC}
  PasAI.FPC.GenericList,
{$ELSE FPC}
  System.IOUtils,
{$ENDIF FPC}
  PasAI.ListEngine, PasAI.HashList.Templet, PasAI.Line2D.Templet,
  PasAI.Agg.Basics, PasAI.Agg, PasAI.Agg.Color32,
  PasAI.JLS.Codec, PasAI.MemoryRaster.JPEG.Type_LIB, PasAI.MemoryRaster.JPEG.Image_LIB,
  PasAI.ZDB2;

type
{$REGION 'base define'}
  TRColor = TAggPackedRgba8;
  PRColor = ^TRColor;

  TPasAI_RasterColor = TRColor;
  PPasAI_RasterColor = PRColor;

  TRGBA = TRColor;
  PRGBA = PRColor;

  TBGRA = TRColor;
  PBGRA = PRColor;

  TRColorArray = array [0 .. MaxInt div SizeOf(TPasAI_RasterColor) - 1] of TPasAI_RasterColor;
  PRColorArray = ^TRColorArray;

  TPasAI_RasterColorArray = TRColorArray;
  PPasAI_RasterColorArray = PRColorArray;

  TBGR = array [0 .. 2] of Byte;
  PBGR = ^TBGR;
  TRGB = TBGR;
  PRGB = PBGR;

  TBGRArray = array [0 .. MaxInt div SizeOf(TRGB) - 1] of TBGR;
  PBGRArray = ^TBGRArray;
  TRGBArray = TBGRArray;
  PRGBArray = PBGRArray;

  TBGRAColorEntry = packed record
    case Byte of
      0: (B, G, R, A: Byte);
      1: (BGRA: TPasAI_RasterColor);
      2: (buff: array [0 .. 3] of Byte);
      3: (BGR: TBGR; BGR_Alpha: Byte);
  end;

  TRColorEntry = TBGRAColorEntry;

  TBGR_Entry = packed record
    case Byte of
      0: (B, G, R: Byte);
      1: (BGR: TBGR);
      2: (buff: array [0 .. 2] of Byte);
  end;

  PBGR_Entry = ^TBGR_Entry;

  TRGB_Entry = TBGR_Entry;
  PRGB_Entry = PBGR_Entry;

  TYIQ = record
  private
    function GetRGB: TRColor;
    procedure SetRGB(const Value: TRColor);
    function GetRGBA(A: Byte): TRColor;
    procedure SetRGBA(A: Byte; const Value: TRColor);
  public
    Y, I, Q: TGeoFloat;
    property RGB: TRColor read GetRGB write SetRGB;
    property RGBA[A: Byte]: TRColor read GetRGBA write SetRGBA;
  end;

  THSI = record
  private
    function GetRGB: TRColor;
    procedure SetRGB(const Value: TRColor);
    function GetRGBA(A: Byte): TRColor;
    procedure SetRGBA(A: Byte; const Value: TRColor);
  public
    H, S, I: TGeoFloat;
    property RGB: TRColor read GetRGB write SetRGB;
    property RGBA[A: Byte]: TRColor read GetRGBA write SetRGBA;
  end;

  TCMYK = record
  private
    function GetRGB: TRColor;
    procedure SetRGB(const Value: TRColor);
    function GetRGBA(A: Byte): TRColor;
    procedure SetRGBA(A: Byte; const Value: TRColor);
  public
    C, M, Y, K: TGeoFloat;
    property RGB: TRColor read GetRGB write SetRGB;
    property RGBA[A: Byte]: TRColor read GetRGBA write SetRGBA;
  end;

  PRColorEntry = ^TRColorEntry;
  PHSI = ^THSI;
  PYIQ = ^TYIQ;
  PCMYK = ^TCMYK;

  TPasAI_RasterColorEntry = TRColorEntry;
  PPasAI_RasterColorEntry = PRColorEntry;

  TRColorEntryArray = array [0 .. MaxInt div SizeOf(TRColorEntry) - 1] of TRColorEntry;
  PRColorEntryArray = ^TRColorEntryArray;

  TPasAI_RasterColorEntryArray = TRColorEntryArray;
  PPasAI_RasterColorEntryArray = PRColorEntryArray;

  TArrayOfRColorEntry = array of TRColorEntry;
  TArrayOfPasAI_RasterColorEntry = TArrayOfRColorEntry;

  TDrawMode = (dmOpaque, dmBlend, dmTransparent);
  TCombineMode = (cmBlend, cmMerge);

  TBytePasAI_Raster = array of array of Byte;
  PBytePasAI_Raster = ^TBytePasAI_Raster;
  TWordPasAI_Raster = array of array of Word;
  PWordPasAI_Raster = ^TWordPasAI_Raster;
  TByteBuffer = array [0 .. MaxInt - 1] of Byte;
  PByteBuffer = ^TByteBuffer;
  TWordBuffer = array [0 .. MaxInt div SizeOf(Word) - 1] of Word;
  PWordBuffer = ^TWordBuffer;

  TMPasAI_Raster = class;
  TMemoryPasAI_Raster_AggImage = class;
  TMemoryPasAI_Raster_Agg2D = class;
  TPasAI_RasterVertex = class;
  TFontPasAI_Raster = class;
  TPasAI_RasterSerialized = class;
  TMorphomaticsValue = TGeoFloat;
  PMorphomaticsValue = ^TMorphomaticsValue;
  TMorphomatics = class;
  TMorphologyBinaryzation = class;
  TMorphologyClassify = Cardinal;
  TOnGetPixelSegClassify = procedure(X, Y: Integer; Color: TRColor; var Classify: TMorphologyClassify) of Object;
  TOnGetMorphomaticsSegClassify = procedure(X, Y: Integer; Morph: TMorphomaticsValue; var Classify: TMorphologyClassify) of Object;
  TMorphologySegmentation = class;
  TMorphologyRCLines = class;

  TMorphologyPixel = (
    mpGrayscale,
    mpYIQ_Y, mpYIQ_I, mpYIQ_Q,
    mpHSI_H, mpHSI_S, mpHSI_I,
    mpCMYK_C, mpCMYK_M, mpCMYK_Y, mpCMYK_K,
    mpR, mpG, mpB, mpA,
    { approximate color }
    mpApproximateBlack,
    mpApproximateWhite,
    mpCyan,
    mpMagenta,
    mpYellow
    );
  TMorphPixel = TMorphologyPixel;
  TMorphPix = TMorphologyPixel;
  TMPix = TMorphologyPixel;

  TMorphologyPixelInfo = array [TMorphologyPixel] of SystemString;

  { short define }
  TPasAI_Raster = TMPasAI_Raster;
  TMorphMath = TMorphomatics;
  TMMath = TMorphomatics;
  TMorphBin = TMorphologyBinaryzation;
  TMBin = TMorphologyBinaryzation;
  TMorphSeg = TMorphologySegmentation;
  TMSeg = TMorphologySegmentation;
  TMorphRCLines = TMorphologyRCLines;
  TMRCLines = TMorphologyRCLines;
  TMRCL = TMorphologyRCLines;

  { rasterization save format. }
  TPasAI_RasterSaveFormat = (
    rsRGBA, rsRGB,
    rsYV12, rsHalfYUV, rsQuartYUV, rsFastYV12, rsFastHalfYUV, rsFastQuartYUV,
    rsJPEG_YCbCrA_Qualily90, rsJPEG_YCbCr_Qualily90, rsJPEG_Gray_Qualily90, rsJPEG_GrayA_Qualily90,
    rsJPEG_YCbCrA_Qualily80, rsJPEG_YCbCr_Qualily80, rsJPEG_Gray_Qualily80, rsJPEG_GrayA_Qualily80,
    rsJPEG_YCbCrA_Qualily70, rsJPEG_YCbCr_Qualily70, rsJPEG_Gray_Qualily70, rsJPEG_GrayA_Qualily70,
    rsJPEG_YCbCrA_Qualily60, rsJPEG_YCbCr_Qualily60, rsJPEG_Gray_Qualily60, rsJPEG_GrayA_Qualily60,
    rsJPEG_YCbCrA_Qualily50, rsJPEG_YCbCr_Qualily50, rsJPEG_Gray_Qualily50, rsJPEG_GrayA_Qualily50,
    rsJPEG_CMYK_Qualily90, rsJPEG_CMYK_Qualily80, rsJPEG_CMYK_Qualily70, rsJPEG_CMYK_Qualily60, rsJPEG_CMYK_Qualily50,
    rsJPEG_YCbCrA_Qualily100, rsJPEG_YCbCr_Qualily100, rsJPEG_Gray_Qualily100, rsJPEG_GrayA_Qualily100, rsJPEG_CMYK_Qualily100,
    rsGrayscale, rsColor255, rsPNG
    );

  TOnGetPasAI_Raster_Memory = procedure(Sender: TMPasAI_Raster) of object;

  TRColors_Decl = TGenericsList<TRColor>;
  TRColors = TRColors_Decl;
  TPasAI_RasterColors = TRColors;

  THoughLine = record
    Count, index: Integer;
    Alpha, Distance: TGeoFloat;
  end;

  THoughLineArry = array of THoughLine;

{$ENDREGION 'base define'}
{$REGION 'memory Rasterization'}
  TMemoryPasAI_RasterClass = class of TMPasAI_Raster;

  TMR_Array = array of TMPasAI_Raster;
  TPasAI_RasterArray = TMR_Array;
  TMR_Matrix = array of TMR_Array;
  TMR_2DArray = TMR_Matrix;
  TMR_2D_Matrix = class;

  TMR_Pool = TBig_Object_List<TMPasAI_Raster>;
  TMR_Critical_Pool = TCritical_Big_Object_List<TMPasAI_Raster>;
  TMR_CPool = TMR_Critical_Pool;

  TSerialized_History_Pool = TCritical_BigList<TMPasAI_Raster>;

  TMPasAI_Raster = class(TCore_Object_Intermediate)
  private
    FIsChanged: Boolean;
    FDrawEngineMap: TCore_Object;

    FSerialized_Read_History_Ptr: TSerialized_History_Pool.PQueueStruct;
    FSerialized_Write_History_Ptr: TSerialized_History_Pool.PQueueStruct;
    FSerialized_Engine: TPasAI_RasterSerialized;
    FSerialized_ID: Integer;
    FSerialized_Size: Int64;
    FActivted: Boolean;
    FActiveTimeTick: TTimeTick;

    FFreeBits: Boolean;
    FBits: PRColorArray;
    FWidth, FHeight: Integer;
    FDrawMode: TDrawMode;
    FCombineMode: TCombineMode;

    FVertex: TPasAI_RasterVertex;
    FFont: TFontPasAI_Raster;

    FAggNeed: Boolean;
    FAggImage: TMemoryPasAI_Raster_AggImage;
    FAgg: TMemoryPasAI_Raster_Agg2D;

    FMasterAlpha: Cardinal;
    FOuterColor: TRColor;

    FUserObject: TCore_Object;
    FUserData: Pointer;
    FUserFloat: Double;
    FUserText: SystemString;
    FUserToken: SystemString;
    FUserVariant: Variant;
    FUserInt: Int64;
    FUserID: Integer;

    FExtra: TPascalString_Hash_Pool;

    function GetExtra: TPascalString_Hash_Pool;
    function GetVertex: TPasAI_RasterVertex;

    function GetFont: TFontPasAI_Raster;
    procedure SetFont(f: TFontPasAI_Raster); overload;

    function GetAggImage: TMemoryPasAI_Raster_AggImage;
    function GetAgg: TMemoryPasAI_Raster_Agg2D;

    function GetBits: PRColorArray;

    function GetPixel(const X, Y: Integer): TRColor;
    procedure SetPixel(const X, Y: Integer; const Value: TRColor);

    function GetFastPixel(const X, Y: Integer): TRColor;
    procedure SetFastPixel(const X, Y: Integer; const Value: TRColor);

    function GetPixelBGRA(const X, Y: Integer): TRColor;
    procedure SetPixelBGRA(const X, Y: Integer; const Value: TRColor);

    function GetPixelPtr(const X, Y: Integer): PRColor;
    function GetFastPixelPtr(const X, Y: Integer): PRColor;

    function GetScanLine(Y: Integer): PRColorArray;
    function GetWidth0: TGeoFloat;
    function GetHeight0: TGeoFloat;
    function GetWidth0i: Integer;
    function GetHeight0i: Integer;

    function GetPixelRed(const X, Y: Integer): Byte;
    procedure SetPixelRed(const X, Y: Integer; const Value: Byte);

    function GetPixelGreen(const X, Y: Integer): Byte;
    procedure SetPixelGreen(const X, Y: Integer; const Value: Byte);

    function GetPixelBlue(const X, Y: Integer): Byte;
    procedure SetPixelBlue(const X, Y: Integer; const Value: Byte);

    function GetPixelAlpha(const X, Y: Integer): Byte;
    procedure SetPixelAlpha(const X, Y: Integer; const Value: Byte);

    function GetGray(const X, Y: Integer): Byte;
    procedure SetGray(const X, Y: Integer; const Value: Byte);

    function GetGrayS(const X, Y: Integer): TGeoFloat;
    procedure SetGrayS(const X, Y: Integer; const Value: TGeoFloat);

    function GetGrayD(const X, Y: Integer): Double;
    procedure SetGrayD(const X, Y: Integer; const Value: Double);

    function GetPixelF(const X, Y: TGeoFloat): TRColor;
    procedure SetPixelF(const X, Y: TGeoFloat; const Value: TRColor);

    function GetPixelVec(const v2: TVec2): TRColor;
    procedure SetPixelVec(const v2: TVec2; const Value: TRColor);

    function GetPixelLinearMetric(const X, Y: TGeoFloat): TRColor;
    function GetPixelLinear(const X, Y: Integer): TRColor;

    function GetPixelYIQ(const X, Y: Integer): TYIQ;
    procedure SetPixelYIQ(const X, Y: Integer; const Value: TYIQ);
    function GetPixelHSI(const X, Y: Integer): THSI;
    procedure SetPixelHSI(const X, Y: Integer; const Value: THSI);
    function GetPixelCMYK(const X, Y: Integer): TCMYK;
    procedure SetPixelCMYK(const X, Y: Integer; const Value: TCMYK);
  public
    { global: parallel }
    class var Parallel: Boolean;
  public
    { local: parallel }
    LocalParallel: Boolean;

    constructor Create; virtual;
    destructor Destroy; override;

    property IsChanged: Boolean read FIsChanged write FIsChanged;
    procedure DoChange(); virtual;

    function ActiveTimeTick: TTimeTick;

    { serialized recycle memory }
    property Serialized_Read_History_Ptr: TSerialized_History_Pool.PQueueStruct read FSerialized_Read_History_Ptr write FSerialized_Read_History_Ptr;
    property Serialized_Write_History_Ptr: TSerialized_History_Pool.PQueueStruct read FSerialized_Write_History_Ptr write FSerialized_Write_History_Ptr;
    property Serialized_Engine: TPasAI_RasterSerialized read FSerialized_Engine;
    property Serialized_Size: Int64 read FSerialized_Size;
    function SerializedAndRecycleMemory(RSeri: TPasAI_RasterSerialized): Int64; overload;
    function SerializedAndRecycleMemory(): Int64; overload;
    function UnserializedMemory(RSeri: TPasAI_RasterSerialized): Int64; overload;
    function UnserializedMemory(): Int64; overload;
    function Is_Serialized(): Boolean;
    function Get_Serialized_Size(RSeri: TPasAI_RasterSerialized): Int64; overload;
    function Get_Serialized_Size(): Int64; overload;
    function RecycleMemory(): Int64;
    procedure ReadyBits;
    procedure ResetSerialized;
    procedure Safe_ResetSerialized;

    { memory map }
    procedure SetWorkMemory(Forever: Boolean; WorkMemory: Pointer; NewWidth, NewHeight: Integer); overload;
    procedure SetWorkMemory(WorkMemory: Pointer; NewWidth, NewHeight: Integer); overload;
    procedure SetWorkMemory(Forever: Boolean; raster: TMPasAI_Raster); overload;
    procedure SetWorkMemory(raster: TMPasAI_Raster); overload;
    function IsMemoryMap: Boolean;
    function IsMapFrom(raster: TMPasAI_Raster): Boolean;

    { triangle vertex map }
    procedure OpenVertex;
    procedure CloseVertex;
    property Vertex: TPasAI_RasterVertex read GetVertex;

    { font rasterization support }
    procedure OpenFont;
    procedure CloseFont;
    property Font: TFontPasAI_Raster read GetFont write SetFont;

    { agg rasterization }
    property AggImage: TMemoryPasAI_Raster_AggImage read GetAggImage;
    property Agg: TMemoryPasAI_Raster_Agg2D read GetAgg;
    procedure OpenAgg;
    procedure CloseAgg;
    procedure FreeAgg;
    function AggActivted: Boolean;

    { general }
    procedure NoUsage; virtual;
    procedure Update;
    procedure DiscardMemory;
    procedure SwapInstance(dest: TMPasAI_Raster; Swap_Serialized_: Boolean); overload;
    procedure SwapInstance(dest: TMPasAI_Raster); overload;
    function BitsSame(sour: TMPasAI_Raster): Boolean;
    procedure Reset; virtual;
    function Clone: TMPasAI_Raster; virtual;
    function CreateMapping: TMPasAI_Raster; virtual;
    procedure Assign(sour: TMPasAI_Raster); overload; virtual;
    procedure Assign(sour: TMorphologyBinaryzation); overload; virtual;
    procedure Assign(sour: TMorphomatics); overload; virtual;
    procedure Clear; overload;
    procedure Clear(FillColor_: TRColor); overload; virtual;
    function MemorySize: Integer;
    function GetMD5: TMD5; virtual;
    function GetCRC32: Cardinal; virtual;
    function Get_Gradient_L16_MD5: TMD5; virtual;
    procedure SetSize(NewWidth, NewHeight: Integer); overload; virtual;
    procedure SetSize(NewWidth, NewHeight: Integer; const ClearColor: TRColor); overload; virtual;
    procedure SetSizeF(NewWidth, NewHeight: TGeoFloat; const ClearColor: TRColor); overload;
    procedure SetSizeF(NewWidth, NewHeight: TGeoFloat); overload;
    procedure SetSizeV(SizV: TVec2); overload;
    procedure SetSizeV(SizV: TVec2; const ClearColor: TRColor); overload;
    procedure SetSizeR(R: TRectV2; const ClearColor: TRColor); overload;
    procedure SetSizeR(R: TRectV2); overload;
    procedure SetSizeR(R: TRect; const ClearColor: TRColor); overload;
    procedure SetSizeR(R: TRect); overload;
    function SizeOfPoint: TPoint;
    function SizeOf2DPoint: TVec2;
    function Size2D: TVec2;
    function Size0: TVec2;
    function Empty: Boolean;
    property IsEmpty: Boolean read Empty;
    function BoundsRect: TRect;
    function BoundsRect0: TRect;
    function BoundsRectV2: TRectV2;
    function BoundsRectV20: TRectV2;
    function BoundsV2Rect4: TV2Rect4;
    function BoundsV2Rect40: TV2Rect4;
    function Centroid: TVec2;
    function Centre: TVec2;
    function InHere(const X, Y: Integer): Boolean;

    { pixel operation }
    procedure FlipHorz;
    procedure FlipVert;
    procedure Rotate90;
    procedure Rotate180;
    procedure Rotate270;
    function Rotate(dest: TMPasAI_Raster; Angle: TGeoFloat; Edge: Integer): TV2R4; overload;
    function Rotate(Angle: TGeoFloat; Edge: Integer; BackgroundColor: TRColor): TV2R4; overload;
    function Rotate(dest: TMPasAI_Raster; Axis: TVec2; Angle: TGeoFloat; Edge: Integer): TV2R4; overload;
    function Rotate(Axis: TVec2; Angle: TGeoFloat; Edge: Integer; BackgroundColor: TRColor): TV2R4; overload;
    procedure CalibrateRotate_LineDistance(BackgroundColor: TRColor);
    procedure CalibrateRotate_LineMatched(BackgroundColor: TRColor);
    procedure CalibrateRotate_AVG(BackgroundColor: TRColor);
    procedure CalibrateRotate(BackgroundColor: TRColor); overload;
    procedure CalibrateRotate; overload;
    procedure NonlinearZoomLine(const Source, dest: TMPasAI_Raster; const pass: Integer);
    procedure NonlinearZoomFrom(const Source: TMPasAI_Raster; const NewWidth, NewHeight: Integer);
    procedure NonlinearZoom(const NewWidth, NewHeight: Integer);
    procedure ZoomLine(const Source, dest: TMPasAI_Raster; const pass: Integer);
    procedure ZoomFrom(const Source: TMPasAI_Raster; const NewWidth, NewHeight: Integer); overload;
    procedure ZoomFrom(const Source: TMPasAI_Raster; const f: TGeoFloat); overload;
    procedure Zoom(const NewWidth, NewHeight: Integer);
    procedure FastBlurZoomFrom(const Source: TMPasAI_Raster; const NewWidth, NewHeight: Integer);
    procedure FastBlurZoom(const NewWidth, NewHeight: Integer);
    procedure GaussianBlurZoomFrom(const Source: TMPasAI_Raster; const NewWidth, NewHeight: Integer);
    procedure GaussianBlurZoom(const NewWidth, NewHeight: Integer);
    procedure GrayscaleBlurZoomFrom(const Source: TMPasAI_Raster; const NewWidth, NewHeight: Integer);
    procedure GrayscaleBlurZoom(const NewWidth, NewHeight: Integer);
    procedure Scale(K: TGeoFloat);
    procedure FastBlurScale(K: TGeoFloat);
    procedure GaussianBlurScale(K: TGeoFloat);
    procedure NonlinearScale(K: TGeoFloat);
    procedure FastBlur_FitScale(NewWidth, NewHeight: TGeoFloat);
    procedure GaussianBlur_FitScale(NewWidth, NewHeight: TGeoFloat);
    procedure FitScale(NewWidth, NewHeight: TGeoFloat); overload;
    procedure FitScale(R: TRectV2); overload;
    procedure FitScaleTo(NewWidth, NewHeight: TGeoFloat; Output: TMPasAI_Raster);
    function FitScaleAsNew(NewWidth, NewHeight: TGeoFloat): TMPasAI_Raster; overload;
    function FitScaleAsNew(R: TRectV2): TMPasAI_Raster; overload;
    function NonlinearFitScaleAsNew(NewWidth, NewHeight: TGeoFloat): TMPasAI_Raster; overload;
    function NonlinearFitScaleAsNew(R: TRectV2): TMPasAI_Raster; overload;
    procedure InnerFitScale(Scale_X, Scale_Y: TGeoFloat); overload;
    procedure InnerFitScale(Scale_: TVec2); overload;
    procedure InnerFitScaleTo(Scale_X, Scale_Y: TGeoFloat; Output: TMPasAI_Raster);
    function InnerFitScaleAsNew(Scale_X, Scale_Y: TGeoFloat): TMPasAI_Raster; overload;
    procedure InnerFitScaleAndFitResizeTo(Scale_X, Scale_Y, NewWidth, NewHeight: TGeoFloat; Output: TMPasAI_Raster);
    function InnerFitScaleAndFitResizeAsNew(Scale_X, Scale_Y, NewWidth, NewHeight: TGeoFloat): TMPasAI_Raster;
    procedure SigmaGaussian(const SIGMA: TGeoFloat; const SigmaGaussianKernelFactor: Integer); overload;
    procedure SigmaGaussian(const SIGMA: TGeoFloat); overload;
    procedure SigmaGaussian(parallel_: Boolean; const SIGMA: TGeoFloat; const SigmaGaussianKernelFactor: Integer); overload;
    procedure SigmaGaussian(parallel_: Boolean; const SIGMA: TGeoFloat); overload;
    function FormatAsBGRA: TMPasAI_Raster;
    procedure FormatBGRA;
    function BuildRGB(cSwapBR: Boolean): PRGBArray;
    procedure InputRGB(var buff; W, H: Integer; cSwapBR: Boolean);
    procedure OutputRGB(var buff; cSwapBR: Boolean);
    function FastEncryptGrayscale(): PByteBuffer;
    function EncryptGrayscale(): PByteBuffer;
    function EncryptColor255(): PByteBuffer;
    function EncryptColor65535(): PWordBuffer;
    procedure DecryptGrayscale(Width_, Height_: Integer; buffer: PByteBuffer);
    procedure DecryptColor255(Width_, Height_: Integer; buffer: PByteBuffer);
    procedure DecryptColor65535(Width_, Height_: Integer; buffer: PWordBuffer);
    procedure ColorReplace(const old_c, new_c: TRColor);
    procedure ColorTransparent(c_: TRColor);
    procedure ColorBlend(C: TRColor);
    procedure FastGrayscale;
    procedure Grayscale;
    procedure Grayscale_Gradient(level: Byte);
    procedure Gradient(level: Byte);
    procedure ExtractGray(var Output: TBytePasAI_Raster);
    procedure ExtractRed(var Output: TBytePasAI_Raster);
    procedure ExtractGreen(var Output: TBytePasAI_Raster);
    procedure ExtractBlue(var Output: TBytePasAI_Raster);
    procedure ExtractAlpha(var Output: TBytePasAI_Raster);
    function ComputeArea_MinLoss_ScaleSpace_NoEdge_Clip(clipArea: TRectV2; SS_width, SS_height: TGeoFloat): TRectV2;
    function ComputeAreaScaleSpace_NoEdge_Clip(clipArea: TRectV2; SS_width, SS_height: TGeoFloat): TRectV2;
    function ComputeAreaScaleSpace(clipArea: TRectV2; SS_width, SS_height: TGeoFloat): TRectV2; overload;
    function ComputeAreaScaleSpace(clipArea: TRect; SS_width, SS_height: Integer): TRect; overload;
    // min-loss
    function BuildAreaOffset_MinLoss_ScaleSpace(clipArea: TRectV2; SS_width, SS_height: Integer): TMPasAI_Raster; overload;
    function BuildAreaOffset_MinLoss_ScaleSpace(clipArea: TRect; SS_width, SS_height: Integer): TMPasAI_Raster; overload;
    function BuildAreaOffset_MinLoss_ScaleSpace(clipArea: TRectV2; SS_width, SS_height: Integer; var Real_Area: TRectV2): TMPasAI_Raster; overload;
    // area-ss
    function BuildAreaOffsetScaleSpace(clipArea: TRectV2; SS_width, SS_height: Integer): TMPasAI_Raster; overload;
    function BuildAreaOffsetScaleSpace(clipArea: TRect; SS_width, SS_height: Integer): TMPasAI_Raster; overload;
    // copy
    function BuildAreaCopyAs(clipArea: TRectV2): TMPasAI_Raster; overload;
    function BuildAreaCopyAs(clipArea: TRect): TMPasAI_Raster; overload;
    // jitter
    function Build_Jitter_Fit_Box_Raster(rand: TMT19937Random; scale_size, scale_pos: TVec2; XY_Offset_Scale_, Rotate_, Scale_: TGeoFloat; Fit_Matrix_Box_: Boolean; output_Size: TVec2; lock_sampler: Boolean; var sampling_box: TV2R4): TMPasAI_Raster; overload;
    function Build_Jitter_Fit_Box_Raster(rand: TMT19937Random; scale_size, scale_pos: TVec2; XY_Offset_Scale_, Rotate_, Scale_: TGeoFloat; Fit_Matrix_Box_: Boolean; output_Size: TVec2; lock_sampler: Boolean): TMPasAI_Raster; overload;
    function Build_Jitter_Fit_Box_Raster(scale_size, scale_pos: TVec2; XY_Offset_Scale_, Rotate_, Scale_: TGeoFloat; Fit_Matrix_Box_: Boolean; output_Size: TVec2; lock_sampler: Boolean; var sampling_box: TV2R4): TMPasAI_Raster; overload;
    function Build_Jitter_Fit_Box_Raster(scale_size, scale_pos: TVec2; XY_Offset_Scale_, Rotate_, Scale_: TGeoFloat; Fit_Matrix_Box_: Boolean; output_Size: TVec2; lock_sampler: Boolean): TMPasAI_Raster; overload;
    // fit
    function Build_Fit_Box_Raster(scale_size, scale_pos: TVec2; output_Size: TVec2; Fit_Matrix_Box_, lock_sampler: Boolean; var sampling_box: TV2R4): TMPasAI_Raster; overload;
    function Build_Fit_Box_Raster(scale_size, scale_pos: TVec2; output_Size: TVec2; Fit_Matrix_Box_, lock_sampler: Boolean): TMPasAI_Raster; overload;
    // fast-copy
    function FastAreaCopyAs(X1, Y1, X2, Y2: TGeoInt): TMPasAI_Raster;
    procedure FastAreaCopyFrom(Source: TMPasAI_Raster; DestX, DestY: Integer);
    // misc
    function ExistsColor(C: TRColor): Boolean;
    function FindFirstColor(C: TRColor): TPoint;
    function FindLastColor(C: TRColor): TPoint;
    function FindNearColor(C: TRColor; PT: TVec2): TPoint;
    function ColorBoundsRectV2(C: TRColor): TRectV2;
    function ColorBoundsRect(C: TRColor): TRect;
    function ConvexHull(C: TRColor): TV2L;
    function NoneColorBoundsRectV2(C: TRColor): TRectV2;
    function NoneColorBoundsRect(C: TRColor): TRect;
    procedure BlendColor(bk: TRColor);
    procedure BlendBlack();
    procedure Black();

    { shape support }
    procedure Line(X1, Y1, X2, Y2: Integer; Color: TRColor; L: Boolean); virtual; { L = draw closed pixel }
    procedure LineF(X1, Y1, X2, Y2: TGeoFloat; Color: TRColor; L: Boolean); overload; { L = draw closed pixel }
    procedure LineF(p1, p2: TVec2; Color: TRColor; L: Boolean); overload; { L = draw closed pixel }
    procedure LineF(p1, p2: TVec2; Color: TRColor; L: Boolean; LineDist: TGeoFloat; Cross: Boolean); overload; { L = draw closed pixel }
    procedure FillRect(X1, Y1, X2, Y2: Integer; Color: TRColor); overload;
    procedure FillRect(Dstx, Dsty, LineDist: Integer; Color: TRColor); overload;
    procedure FillRect(Dst: TVec2; LineDist: Integer; Color: TRColor); overload;
    procedure FillRect(R: TRect; Color: TRColor); overload;
    procedure FillRect(R: TRectV2; Color: TRColor); overload;
    procedure FillRect(R: TRectV2; Angle: TGeoFloat; Color: TRColor); overload;
    procedure DrawRect(R: TRect; Color: TRColor); overload;
    procedure DrawRect(R: TRectV2; Color: TRColor); overload;
    procedure DrawRect(R: TV2Rect4; Color: TRColor); overload;
    procedure DrawRect(R: TRectV2; Angle: TGeoFloat; Color: TRColor); overload;
    procedure DrawTriangle(tri: TTriangle; Transform: Boolean; Color: TRColor; Cross: Boolean);
    procedure DrawFlatCross(Dst: TVec2; LineDist: TGeoFloat; Color: TRColor);
    procedure DrawCross(Dstx, Dsty, LineDist: Integer; Color: TRColor); overload;
    procedure DrawCrossF(Dstx, Dsty, LineDist: TGeoFloat; Color: TRColor); overload;
    procedure DrawCrossF(Dst: TVec2; LineDist: TGeoFloat; Color: TRColor); overload;
    procedure DrawCrossF(Polygon: TV2L; LineDist: TGeoFloat; Color: TRColor); overload;
    procedure DrawPointListLine(pl: TV2L; Color: TRColor; wasClose: Boolean);
    procedure DrawCircle(CC: TVec2; R: TGeoFloat; Color: TRColor);
    procedure FillCircle(CC: TVec2; R: TGeoFloat; Color: TRColor);
    procedure DrawEllipse(CC: TVec2; xRadius, yRadius: TGeoFloat; Color: TRColor); overload;
    procedure DrawEllipse(R: TRectV2; Color: TRColor); overload;
    procedure FillEllipse(CC: TVec2; xRadius, yRadius: TGeoFloat; Color: TRColor); overload;
    procedure FillEllipse(R: TRectV2; Color: TRColor); overload;
    procedure FillTriangle(t1, t2, t3: TVec2; Color: TRColor); overload;
    procedure FillTriangle(t1, t2, t3: TPoint; Color: TRColor); overload;
    procedure FillTriangle(t1, t2, t3: TPointf; Color: TRColor); overload;

    { polygon }
    procedure FillPolygon(PolygonBuff: TArrayVec2; Color: TRColor); overload;
    procedure DrawPolygon(PolygonBuff: TArrayVec2; Color: TRColor); overload;
    procedure FillPolygon(Polygon: T2DPolygon; Color: TRColor); overload;
    procedure DrawPolygon(Polygon: T2DPolygon; Color: TRColor); overload;
    procedure FillPolygon(Polygon: T2DPolygonGraph; Color: TRColor); overload;
    procedure DrawPolygon(Polygon: T2DPolygonGraph; Color: TRColor); overload;
    procedure DrawPolygon(Polygon: T2DPolygonGraph; SurroundColor, CollapseColor: TRColor); overload;
    procedure DrawPolygonCross(Polygon: T2DPolygonGraph; LineDist: TGeoFloat; SurroundColor, CollapseColor: TRColor);
    procedure DrawPolygonLine(Polygon: TLines; Color: TRColor; wasClose: Boolean); overload;
    procedure DrawPolygon(Polygon: TDeflectionPolygon; ExpandDist: TGeoFloat; Color: TRColor); overload;

    { pixel border }
    function PixelAtNoneBGBorder(const X, Y: Integer; const BGColor, BorderColor: TRColor; const halfBorderSize: Integer; var detectColor: TRColor): Boolean; overload;
    function PixelAtNoneBGBorder(const X, Y: Integer; const BGColor: TRColor; const halfBorderSize: Integer; var detectColor: TRColor): Boolean; overload;
    procedure FillNoneBGColorBorder(parallel_: Boolean; BGColor, BorderColor: TRColor; BorderSize: Integer); overload;
    procedure FillNoneBGColorBorder(BGColor, BorderColor: TRColor; BorderSize: Integer); overload;
    procedure FillNoneBGColorAlphaBorder(parallel_: Boolean; BGColor, BorderColor: TRColor; BorderSize: Integer; Output: TMPasAI_Raster); overload;
    procedure FillNoneBGColorAlphaBorder(BGColor, BorderColor: TRColor; BorderSize: Integer; Output: TMPasAI_Raster); overload;
    procedure FillNoneBGColorAlphaBorder(BGColor, BorderColor: TRColor; BorderSize: Integer); overload;

    { rasterization text support }
    function TextSize(Text: SystemString; siz: TGeoFloat): TVec2;
    procedure DrawText(Text: SystemString; X, Y: TGeoFloat; RotateVec: TVec2; Angle, Alpha, siz: TGeoFloat; TextColor: TRColor); overload;
    procedure DrawText(Text: SystemString; X, Y: TGeoFloat; siz: TGeoFloat; TextColor: TRColor); overload;
    procedure DrawText(Text: SystemString; X, Y: TGeoFloat; RotateVec: TVec2; Angle, Alpha, siz: TGeoFloat; TextColor: TRColor; var DrawCoordinate: TArrayV2R4); overload;
    procedure DrawText(Text: SystemString; X, Y: TGeoFloat; siz: TGeoFloat; TextColor: TRColor; var DrawCoordinate: TArrayV2R4); overload;
    function ComputeDrawTextCoordinate(Text: SystemString; X, Y: TGeoFloat; RotateVec: TVec2; Angle, siz: TGeoFloat; var DrawCoordinate, BoundBoxCoordinate: TArrayV2R4): TVec2;
    { compute text bounds size }
    function ComputeTextSize(Text: SystemString; RotateVec: TVec2; Angle, siz: TGeoFloat): TVec2;
    { compute text ConvexHull }
    function ComputeTextConvexHull(Text: SystemString; X, Y: TGeoFloat; RotateVec: TVec2; Angle, siz: TGeoFloat): TArrayVec2;

    { DrawEngine support }
    function GetDrawEngineMap: TCore_Object;
    property DrawEngineMap: TCore_Object read GetDrawEngineMap;

    { Projection: hardware simulator }
    procedure ProjectionTo(Dst: TMPasAI_Raster; const sourRect, DestRect: TV2Rect4; const bilinear_sampling: Boolean; const Alpha: TGeoFloat); overload;
    procedure ProjectionTo(Dst: TMPasAI_Raster; const sourRect, DestRect: TRectV2; const bilinear_sampling: Boolean; const Alpha: TGeoFloat); overload;
    procedure Projection(const DestRect: TV2Rect4; const Color: TRColor); overload;
    procedure Projection(sour: TMPasAI_Raster; const sourRect, DestRect: TV2Rect4; const bilinear_sampling: Boolean; const Alpha: TGeoFloat); overload;
    procedure Projection(sour: TMPasAI_Raster; const sourRect, DestRect: TRectV2; const bilinear_sampling: Boolean; const Alpha: TGeoFloat); overload;

    { Projection polygon sampler }
    procedure ProjectionPolygonTo(const sour_Polygon: TV2L; Dst: TMPasAI_Raster; DestRect: TRectV2; const bilinear_sampling: Boolean; const Alpha: TGeoFloat); overload;
    procedure ProjectionPolygonTo(const sour_Polygon: T2DPolygonGraph; Dst: TMPasAI_Raster; DestRect: TRectV2; const bilinear_sampling: Boolean; const Alpha: TGeoFloat); overload;

    { blend draw }
    procedure Draw(Src: TMPasAI_Raster); overload;
    procedure Draw(Dstx, Dsty: Integer; Src: TMPasAI_Raster); overload;
    procedure Draw(Dstx, Dsty: Integer; const SrcRect: TRect; Src: TMPasAI_Raster); overload;
    procedure DrawTo(Dst: TMPasAI_Raster); overload;
    procedure DrawTo(Dst: TMPasAI_Raster; Dstx, Dsty: Integer; const SrcRect: TRect); overload;
    procedure DrawTo(Dst: TMPasAI_Raster; Dstx, Dsty: Integer); overload;
    procedure DrawTo(Dst: TMPasAI_Raster; DstPt: TVec2); overload;

    { Morphology }
    function BuildMorphologySegmentation(OnGetPixelSegClassify: TOnGetPixelSegClassify): TMorphologySegmentation; overload;
    function BuildMorphologySegmentation(): TMorphologySegmentation; overload;
    procedure BuildMorphomaticsTo(MorphPix_: TMorphologyPixel; output_: TMorphomatics);
    function BuildMorphomatics(MorphPix_: TMorphologyPixel): TMorphomatics;
    procedure BuildApproximateMorphomaticsTo(ApproximateColor_: TRColor; output_: TMorphomatics);
    function BuildApproximateMorphomatics(ApproximateColor_: TRColor): TMorphomatics;
    procedure DrawMorphomatics(MorphPix_: TMorphologyPixel; Morph: TMorphomatics); overload;
    procedure DrawMorphomatics(Morph: TMorphomatics); overload;
    procedure DrawBinaryzation(Morph: TMorphologyBinaryzation); overload;
    procedure DrawBinaryzation(MorphPix_: TMorphologyPixel; Morph: TMorphologyBinaryzation); overload;
    function BuildHistogram(MorphPix_: TMorphologyPixel; Height_: Integer; hColor: TRColor): TMPasAI_Raster;

    { load stream format }
    class function CanLoadStream(stream: TCore_Stream): Boolean; virtual;
    procedure LoadFromBmpStream(stream: TCore_Stream);
    procedure LoadFromStream(stream: TCore_Stream); virtual;

    { save stream format }
    procedure SaveToStream(stream: TCore_Stream; PasAI_RasterSave_: TPasAI_RasterSaveFormat); overload; { selected format }
    procedure SaveToStream(stream: TCore_Stream); overload; virtual; { published,32bit bitmap }
    procedure SaveToBmp32Stream(stream: TCore_Stream); { published,32bit bitmap,include alpha }
    procedure SaveToBmp24Stream(stream: TCore_Stream); { published,24bit bitmap,no alpha }
    procedure SaveToZLibCompressStream(stream: TCore_Stream); { custom,32bit include alpha }
    procedure SaveToDeflateCompressStream(stream: TCore_Stream); { custom,32bit include alpha }
    procedure SaveToBRRCCompressStream(stream: TCore_Stream); { custom,32bit include alpha }
    procedure SaveToJpegLS1Stream(stream: TCore_Stream); { published,jls8bit }
    procedure SaveToJpegLS3Stream(stream: TCore_Stream); { published,jls24bit }
    procedure SaveToYV12Stream(stream: TCore_Stream); { custom,no alpha }
    procedure SaveToFastYV12Stream(stream: TCore_Stream); { custom,no alpha }
    procedure SaveToHalfYUVStream(stream: TCore_Stream); { custom,no alpha }
    procedure SaveToFastHalfYUVStream(stream: TCore_Stream); { custom,no alpha }
    procedure SaveToQuartYUVStream(stream: TCore_Stream); { custom,no alpha }
    procedure SaveToFastQuartYUVStream(stream: TCore_Stream); { custom,no alpha }
    procedure SaveToJpegYCbCrAStream(stream: TCore_Stream; Quality: TJpegQuality); { custom,32bit YCbCrA }
    procedure SaveToJpegYCbCrStream(stream: TCore_Stream; Quality: TJpegQuality); { published,24bit YCbCr }
    procedure SaveToJpegCMYKStream(stream: TCore_Stream; Quality: TJpegQuality); { custom,24bit CMYK }
    procedure SaveToJpegGrayStream(stream: TCore_Stream; Quality: TJpegQuality); { published,8bit grayscale }
    procedure SaveToJpegGrayAStream(stream: TCore_Stream; Quality: TJpegQuality); { custom,16bit grayscale+alpha }
    procedure SaveToGrayscaleStream(stream: TCore_Stream); { custom grayscale,no alpha }
    procedure SaveToColor255Stream(stream: TCore_Stream); { custom color 255,no alpha }
    procedure SaveToColor65535Stream(stream: TCore_Stream); { custom color 65535,no alpha }
    { png support }
    procedure SaveToPNGStream(stream: TCore_Stream); { published, Portable Network Graphic, automated detect and save as gray,rgb24,rgba32 format }

    { load file format }
    class function CanLoadFile(fn: SystemString): Boolean;
    procedure LoadFromFile(fn: SystemString); virtual;

    { save file format }
    procedure SaveToBmp32File(fn: SystemString); { published,32bit bitmap,include alpha }
    procedure SaveToBmp24File(fn: SystemString); { published,24bit bitmap,no alpha }
    procedure SaveToFile(fn: SystemString); { save format from ext name .jpg .jpeg .png .bmp .yv12 .jls .hyuv .qyuv .zlib_bmp .deflate_bmp .BRRC_bmp .gray .grayscale .255 .256 .64K }
    procedure SaveToZLibCompressFile(fn: SystemString); { custom,32bit include alpha }
    procedure SaveToDeflateCompressFile(fn: SystemString); { custom,32bit include alpha }
    procedure SaveToBRRCCompressFile(fn: SystemString); { custom,32bit include alpha }
    procedure SaveToJpegLS1File(fn: SystemString); { published,jls8bit }
    procedure SaveToJpegLS3File(fn: SystemString); { published,jls24bit }
    procedure SaveToYV12File(fn: SystemString); { custom,no alpha }
    procedure SaveToFastYV12File(fn: SystemString); { custom,no alpha }
    procedure SaveToHalfYUVFile(fn: SystemString); { custom,no alpha }
    procedure SaveToFastHalfYUVFile(fn: SystemString); { custom,no alpha }
    procedure SaveToQuartYUVFile(fn: SystemString); { custom,no alpha }
    procedure SaveToFastQuartYUVFile(fn: SystemString); { custom,no alpha }
    procedure SaveToJpegYCbCrAFile(fn: SystemString; Quality: TJpegQuality); { custom,32bit YCbCrA }
    procedure SaveToJpegYCbCrFile(fn: SystemString; Quality: TJpegQuality); { published,24bit YCbCr }
    procedure SaveToJpegCMYKFile(fn: SystemString; Quality: TJpegQuality); { custom,24bit CMYK }
    procedure SaveToJpegGrayFile(fn: SystemString; Quality: TJpegQuality); { published,8bit grayscale }
    procedure SaveToJpegGrayAFile(fn: SystemString; Quality: TJpegQuality); { custom,8bit grayscale + 8bit alpha }
    procedure SaveToGrayscaleFile(fn: SystemString); { custom grapscale,no alpha }
    procedure SaveToColor255File(fn: SystemString); { custom color 255,no alpha }
    procedure SaveToColor65535File(fn: SystemString); { custom color 65535,no alpha }
    { published, Portable Network Graphic, automated detect and save as gray,rgb24,rgba32 format }
    procedure SaveToPNGFile(fn: SystemString);

    { Rasterization pixel }
    property Pixel[const X, Y: Integer]: TRColor read GetPixel write SetPixel; default;
    property FastPixel[const X, Y: Integer]: TRColor read GetFastPixel write SetFastPixel;
    property PixelFast[const X, Y: Integer]: TRColor read GetFastPixel write SetFastPixel;
    property DirectPixel[const X, Y: Integer]: TRColor read GetFastPixel write SetFastPixel;
    property PixelDirect[const X, Y: Integer]: TRColor read GetFastPixel write SetFastPixel;
    property PixelBGRA[const X, Y: Integer]: TRColor read GetPixelBGRA write SetPixelBGRA;
    property PixelPtr[const X, Y: Integer]: PRColor read GetPixelPtr;
    property FastPixelPtr[const X, Y: Integer]: PRColor read GetFastPixelPtr;
    property PixelRed[const X, Y: Integer]: Byte read GetPixelRed write SetPixelRed;
    property PixelGreen[const X, Y: Integer]: Byte read GetPixelGreen write SetPixelGreen;
    property PixelBlue[const X, Y: Integer]: Byte read GetPixelBlue write SetPixelBlue;
    property PixelAlpha[const X, Y: Integer]: Byte read GetPixelAlpha write SetPixelAlpha;
    property PixelGray[const X, Y: Integer]: Byte read GetGray write SetGray;
    property PixelGrayS[const X, Y: Integer]: TGeoFloat read GetGrayS write SetGrayS;
    property PixelGrayD[const X, Y: Integer]: Double read GetGrayD write SetGrayD;
    property PixelF[const X, Y: TGeoFloat]: TRColor read GetPixelF write SetPixelF;
    property PixelVec[const v2: TVec2]: TRColor read GetPixelVec write SetPixelVec;
    property PixelLinearMetric[const X, Y: TGeoFloat]: TRColor read GetPixelLinearMetric;
    property PixelLinear[const X, Y: Integer]: TRColor read GetPixelLinear;
    property PixelYIQ[const X, Y: Integer]: TYIQ read GetPixelYIQ write SetPixelYIQ;
    property PixelHSI[const X, Y: Integer]: THSI read GetPixelHSI write SetPixelHSI;
    property PixelCMYK[const X, Y: Integer]: TCMYK read GetPixelCMYK write SetPixelCMYK;
    property ScanLine[Y: Integer]: PRColorArray read GetScanLine;
    property Bits: PRColorArray read GetBits;
    property DirectBits: PRColorArray read FBits;
    property FastBits: PRColorArray read FBits;
    property Width: Integer read FWidth;
    property Height: Integer read FHeight;
    property Width0: TGeoFloat read GetWidth0;
    property Height0: TGeoFloat read GetHeight0;
    property Width0i: Integer read GetWidth0i;
    property Height0i: Integer read GetHeight0i;

    { blend options }
    property DrawMode: TDrawMode read FDrawMode write FDrawMode default dmOpaque;
    property CombineMode: TCombineMode read FCombineMode write FCombineMode default cmBlend;
    property MasterAlpha: Cardinal read FMasterAlpha write FMasterAlpha;
    property OuterColor: TRColor read FOuterColor write FOuterColor;

    { user define }
    property UserObject: TCore_Object read FUserObject write FUserObject;
    property UserData: Pointer read FUserData write FUserData;
    property UserFloat: Double read FUserFloat write FUserFloat;
    property UserText: SystemString read FUserText write FUserText;
    property UserToken: SystemString read FUserToken write FUserToken;
    property UserVariant: Variant read FUserVariant write FUserVariant;
    property UserInt: Int64 read FUserInt write FUserInt;
    property UserID: Integer read FUserID write FUserID;
    property Extra: TPascalString_Hash_Pool read GetExtra;
  end;

  TMR_List___ = TGenericsList<TMPasAI_Raster>;

  TMR_List = class(TMR_List___)
  private
    FCritical: TCritical;
  public
    AutoFreePasAI_Raster: Boolean;
    UserToken: U_String;
    constructor Create; overload;
    constructor Create(AutoFreePasAI_Raster_: Boolean); overload;
    destructor Destroy; override;
    procedure Lock;
    procedure UnLock;
    procedure Remove(obj: TMPasAI_Raster);
    procedure Delete(index: Integer);
    procedure Clear;
    procedure AddPasAI_RasterList(L_: TMR_List);
    procedure AddPasAI_Raster2DMatrix(M_: TMR_2D_Matrix);

    function BuildArray: TMR_Array;
    procedure Clean;
  end;

  TMemoryPasAI_RasterList = TMR_List;

  TMR_List_Hash_Pool___ = TString_Big_Hash_Pair_Pool<TMR_List>;

  TMR_List_Hash_Pool = class(TMR_List_Hash_Pool___)
  public
    AutoFreePasAI_Raster: Boolean;
    constructor Create; overload;
    constructor Create(AutoFreePasAI_Raster_: Boolean); overload;
    procedure DoFree(var Key: SystemString; var Value: TMR_List); override;
    function Compare_Value(const Value_1, Value_2: TMR_List): Boolean; override;
    procedure GetNameList(L_: TPascalStringList);
  end;

  TMR_2D_Matrix___ = TGenericsList<TMR_List>;

  TMR_2D_Matrix = class(TMR_2D_Matrix___)
  private
    FCritical: TCritical;
  public
    AutoFree_MR_List: Boolean;
    constructor Create; overload;
    constructor Create(AutoFree_MR_List_: Boolean); overload;
    destructor Destroy; override;
    procedure Lock;
    procedure UnLock;
    procedure Remove(obj: TMR_List);
    procedure Delete(index: Integer);
    procedure Clear;
    procedure AddPasAI_Raster2DMatrix(M_: TMR_2D_Matrix);

    function BuildArray: TMR_2DArray;
    procedure Clean;
  end;

  TPasAI_RasterList = TMR_List;
  TPasAI_Raster2DMatrix = TMR_2D_Matrix;
  TMemoryPasAI_Raster2DMatrix = TMR_2D_Matrix;

  TBytePasAI_RasterList_Decl = TGenericsList<TBytePasAI_Raster>;

  TBytePasAI_RasterList = class(TBytePasAI_RasterList_Decl)
  public
    procedure SaveToStream(stream: TCore_Stream);
    procedure LoadFromStream(stream: TCore_Stream);
  end;

{$ENDREGION 'memory Rasterization'}
{$REGION 'Serialized_ZDB2'}

  TRasterSerialized_Instance_Pool = TCritical_BigList<TPasAI_RasterSerialized>;

  TRasterSerialized_Pixel_Model = (rspmBGR, rspmBGRA);

  TPasAI_RasterSerialized = class(TCore_Object_Intermediate)
  protected
    FInstance_Queue_Ptr: TRasterSerialized_Instance_Pool.PQueueStruct;
    FIOHnd: TIOHnd;
    FZDB2: TZDB2_Core_Space;
    FZDB2_Block: Word; // default $FFFF
    FZDB2_Delta: Int64; // default 500 * 1024 * 1024
    FCritical: TCritical;
    FPixel_Model: TRasterSerialized_Pixel_Model; // default rspmBGRA;
    FWrite_History_Pool, FRead_History_Pool: TSerialized_History_Pool;
    FEnabled_Write_History, FEnabled_Read_History: Boolean; // default is false
    FSerialized_File: U_String;
    FRemove_Serialized_File_On_Destroy: Boolean; // default is False
    procedure Do_NoSpace(Trigger: TZDB2_Core_Space; Siz_: Int64; var retry: Boolean);
    function Get_AutoFreeStream: Boolean;
    procedure Set_AutoFreeStream(const Value: Boolean);
  public
    constructor Create(stream_: TCore_Stream);
    constructor Create_To_File(FileName_: U_String);
    constructor Create_To_Directory(Directory_, File_Prefix_: U_String);
    destructor Destroy; override;

    function Write(R: TMPasAI_Raster): Int64;
    function Read(R: TMPasAI_Raster): Int64;
    function Get_Raster_Size(R: TMPasAI_Raster): Int64;
    procedure Remove(R: TMPasAI_Raster);
    procedure Clear_History;
    procedure Format_Space;

    property Pixel_Model: TRasterSerialized_Pixel_Model read FPixel_Model write FPixel_Model; // default rspmBGRA;
    property ZDB2_Block: Word read FZDB2_Block write FZDB2_Block; // default $FFFF
    property ZDB2_Delta: Int64 read FZDB2_Delta write FZDB2_Delta; // default 500 * 1024 * 1024
    property AutoFreeStream: Boolean read Get_AutoFreeStream write Set_AutoFreeStream;
    property Remove_Serialized_File_On_Destroy: Boolean read FRemove_Serialized_File_On_Destroy write FRemove_Serialized_File_On_Destroy; // default is False
    property Critical: TCritical read FCritical;
    procedure Lock;
    procedure UnLock;
    function StreamSize: Int64;
    property StreamFile: U_String read FSerialized_File;

    property Write_History_Pool: TSerialized_History_Pool read FWrite_History_Pool;
    property Read_History_Pool: TSerialized_History_Pool read FRead_History_Pool;
    property Enabled_Write_History: Boolean read FEnabled_Write_History write FEnabled_Write_History;
    property Enabled_Read_History: Boolean read FEnabled_Read_History write FEnabled_Read_History;
  end;

{$ENDREGION 'Serialized_ZDB2'}
{$REGION 'TSequenceMemoryRaster'}

  TSequenceMemoryPasAI_Raster = class(TPasAI_Raster)
  protected
    FTotal: Integer;
    FColumn: Integer;
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure Clear(FillColor_: TRColor); override;
    procedure SetSize(NewWidth, NewHeight: Integer; const ClearColor: TRColor); override;

    procedure Reset; override;
    procedure Assign(sour: TMPasAI_Raster); override;

    class function CanLoadStream(stream: TCore_Stream): Boolean; override;
    procedure LoadFromStream(stream: TCore_Stream); override;
    procedure SaveToStream(stream: TCore_Stream); override;
    procedure SaveToSequenceStream(stream: TCore_Stream);

    property Total: Integer read FTotal write FTotal;
    property Column: Integer read FColumn write FColumn;

    function SequenceFrameRect(index: Integer): TRect;
    procedure ExportSequenceFrame(index: Integer; Output: TMPasAI_Raster);
    procedure ReverseSequence(Output: TSequenceMemoryPasAI_Raster);
    procedure GradientSequence(Output: TSequenceMemoryPasAI_Raster);
    function FrameWidth: Integer;
    function FrameHeight: Integer;
    function FrameRect2D: TRectV2;
    function FrameRect: TRect;
  end;

  TSequenceMemoryPasAI_RasterClass = class of TSequenceMemoryPasAI_Raster;

{$ENDREGION 'TSequenceMemoryRaster'}
{$REGION 'AGG'}

  TMemoryPasAI_Raster_AggImage = class(TAgg2DImage)
  public
    constructor Create(raster: TMPasAI_Raster); overload;
    procedure Attach(raster: TMPasAI_Raster); overload;
  end;

  TMemoryPasAI_Raster_Agg2D = class(TAgg2D)
  private
    function GetImageBlendColor: TRColor;
    procedure SetImageBlendColor(const Value: TRColor);
    function GetFillColor: TRColor;
    procedure SetFillColor(const Value: TRColor);
    function GetLineColor: TRColor;
    procedure SetLineColor(const Value: TRColor);
  public
    procedure Attach(raster: TMPasAI_Raster); overload;

    procedure FillLinearGradient(X1, Y1, X2, Y2: Double; c1, c2: TRColor; Profile: Double);
    procedure LineLinearGradient(X1, Y1, X2, Y2: Double; c1, c2: TRColor; Profile: Double);

    procedure FillRadialGradient(X, Y, R: Double; c1, c2: TRColor; Profile: Double); overload;
    procedure LineRadialGradient(X, Y, R: Double; c1, c2: TRColor; Profile: Double); overload;

    procedure FillRadialGradient(X, Y, R: Double; c1, c2, c3: TRColor); overload;
    procedure LineRadialGradient(X, Y, R: Double; c1, c2, c3: TRColor); overload;

    property ImageBlendColor: TRColor read GetImageBlendColor write SetImageBlendColor;
    property FillColor: TRColor read GetFillColor write SetFillColor;
    property LineColor: TRColor read GetLineColor write SetLineColor;
  end;

{$ENDREGION 'AGG'}
{$REGION 'Rasterization Vertex'}

  TPasAI_RasterVertex = class(TCore_Object_Intermediate)
  private type
    { Setup interpolation constants for linearly varying vaues }
    TBilerpConsts = packed record
      A, B, C: Double;
    end;

    { fragment mode }
    TFragmentSampling = (fsSolid, fsNearest, fsLinear);
    TNearestWriteBuffer = array of Byte;
    TSamplerBlend = procedure(const Sender: TPasAI_RasterVertex; const f, M: TRColor; var B: TRColor);
    TComputeSamplerColor = function(const Sender: TPasAI_RasterVertex; const Sampler: TMPasAI_Raster; const X, Y: TGeoFloat): TRColor;
  private
    { rasterization nearest templet }
    FNearestWriteBuffer: TNearestWriteBuffer;
    FNearestWriterID: Byte;
    FCurrentUpdate: ShortInt;
    { sampler shader }
    ComputeNearest: TComputeSamplerColor;
    ComputeLinear: TComputeSamplerColor;
    ComputeBlend: TSamplerBlend;

    { fill triangle }
    procedure PasAI_Raster_Triangle(const FS: TFragmentSampling; const sc: TRColor; const tex: TMPasAI_Raster; const SamplerTri, RenderTri: TTriangle);
    { fragment }
    procedure FillFragment(const FS: TFragmentSampling; const sc: TRColor; const tex: TMPasAI_Raster;
      const bitDst, j, start_x, frag_count: Int64; var attr_v, attr_u: TBilerpConsts);
    { nearest state buffer }
    procedure NewWriterBuffer;
    { internal }
    procedure internal_Draw(const RenderTri: TTriangle; const Sampler: TRColor); overload;
    procedure internal_Draw(const SamplerTri, RenderTri: TTriangle; const Sampler: TMPasAI_Raster; const bilinear_sampling: Boolean); overload;
    procedure internal_Draw(const SamplerTri, RenderTri: TTriangle; const Sampler: TMPasAI_Raster; const bilinear_sampling: Boolean; const Alpha: TGeoFloat); overload;
  public
    { global: draw triangle edge }
    class var DebugTriangle: Boolean;
    class var DebugTriangleColor: TRColor;
    { global: parallel vertex }
    class var Parallel: Boolean;
    class var ParallelHeightTrigger, ParallelWidthTrigger: Int64;
  public
    LockSamplerCoord: Boolean;
    { local: parallel vertex }
    LocalParallel: Boolean;
    { render window }
    Window: TMPasAI_Raster;
    WindowSize: Int64;
    { user define }
    UserData: Pointer;

    constructor Create(raster: TMPasAI_Raster);
    destructor Destroy; override;

    property NearestWriterID: Byte read FNearestWriterID;
    property NearestWriteBuffer: TNearestWriteBuffer read FNearestWriteBuffer;
    function BeginUpdate: Byte;
    procedure EndUpdate;

    (*
      input absolute coordiantes
    *)
    procedure DrawTriangle(const v1, v2, v3: TVec2; const Sampler: TRColor); overload;
    procedure DrawTriangle(const RenderTri: TTriangle; const Sampler: TRColor); overload;
    procedure DrawTriangle(const SamplerTri, RenderTri: TTriangle; const Sampler: TMPasAI_Raster; const bilinear_sampling: Boolean); overload;
    procedure DrawTriangle(const SamplerTri, RenderTri: TTriangle; const Sampler: TMPasAI_Raster; const bilinear_sampling: Boolean; const Alpha: TGeoFloat); overload;

    (*
      SamVec: (TV2Rect4) sampler Absolute coordiantes
      RenVec: (TV2Rect4) renderer Absolute coordiantes
      Sampler: MemoryRaster or Solid color
      bilinear_sampling: used Linear sampling
    *)
    procedure DrawRect(const RenVec: TV2Rect4; const Sampler: TRColor); overload;
    procedure DrawRect(const SamVec, RenVec: TV2Rect4; const Sampler: TMPasAI_Raster; const bilinear_sampling: Boolean; const Alpha: TGeoFloat); overload;

    (*
      SamVec: (TRectV2) sampler Absolute coordiantes
      RenVec: (TRectV2) renderer Absolute coordiantes
      RenAngle: (TGeoFloat) renderer rotation
      Sampler: MemoryRaster or Solid color
      bilinear_sampling: used Linear sampling
    *)
    procedure DrawRect(const RenVec: TRectV2; const Sampler: TRColor); overload;
    procedure DrawRect(const SamVec, RenVec: TRectV2; const Sampler: TMPasAI_Raster; const bilinear_sampling: Boolean; const Alpha: TGeoFloat); overload;
    procedure DrawRect(const RenVec: TRectV2; const RenAngle: TGeoFloat; const Sampler: TRColor); overload;
    procedure DrawRect(const SamVec, RenVec: TRectV2; const RenAngle: TGeoFloat; const Sampler: TMPasAI_Raster; const bilinear_sampling: Boolean; const Alpha: TGeoFloat); overload;

    (*
      SamVec: (TV2Rect4) sampler Absolute coordiantes
      RenVec: (TRectV2) renderer Absolute coordiantes
      RenAngle: (TGeoFloat) renderer rotation
      Sampler: MemoryRaster or Solid color
      bilinear_sampling: used Linear sampling
    *)
    procedure DrawRect(const SamVec: TV2Rect4; const RenVec: TRectV2; const RenAngle: TGeoFloat; const Sampler: TMPasAI_Raster; const bilinear_sampling: Boolean; const Alpha: TGeoFloat); overload;

    (*
      SamVec: (TVec2List) sampler Absolute coordiantes
      RenVec: (TVec2List) renderer Absolute coordiantes
      cen: Centroid coordinate
      Sampler: MemoryRaster or Solid color
      bilinear_sampling: used Linear sampling
    *)
    procedure FillPoly(const RenVec: TV2L; const cen: TVec2; const Sampler: TRColor); overload;
    procedure FillPoly(const RenVec: TV2L; const Sampler: TRColor); overload;
    procedure FillPoly(const SamVec, RenVec: TV2L; const SamCen, RenCen: TVec2; const Sampler: TMPasAI_Raster; const bilinear_sampling: Boolean; const Alpha: TGeoFloat); overload;
    procedure FillPoly(const SamVec, RenVec: TV2L; const Sampler: TMPasAI_Raster; const bilinear_sampling: Boolean; const Alpha: TGeoFloat); overload;
  end;

{$ENDREGION 'Rasterization Vertex'}
{$REGION 'TFontRaster'}

  TFontPasAI_RasterList = TGenericsList<TFontPasAI_Raster>;

  TFontPasAI_Raster = class(TCore_Object_Intermediate)
  public type
    PFontCharDefine = ^TFontCharDefine;

    TFontCharDefine = packed record
      Activted: Boolean;
      X, Y: Word;
      W, H: Byte;
    end;

    TFontTable = array [0 .. MaxInt div SizeOf(TFontCharDefine) - 1] of TFontCharDefine;
    PFontTable = ^TFontTable;

    TFontBitPasAI_Raster = array [0 .. MaxInt - 1] of Byte;
    PFontBitPasAI_Raster = ^TFontBitPasAI_Raster;

    TFontDrawState = record
      Owner: TFontPasAI_Raster;
      DestColor: TRColor;
    end;

    PFontDrawState = ^TFontDrawState;

    TCharacterBoundBox = record
      Cache: Boolean;
      Box: TRect;
    end;

    TCharacterBoundBoxCache = array [0 .. MaxInt div SizeOf(TCharacterBoundBox) - 1] of TCharacterBoundBox;
    PCharacterBoundBoxCache = ^TCharacterBoundBoxCache;

{$IFDEF FPC}
    TFontPasAI_RasterString = TUPascalString;
    TFontPasAI_RasterChar = USystemChar;
    TFontPasAI_RasterArrayString = TUArrayPascalString;
{$ELSE FPC}
    TFontPasAI_RasterString = TPascalString;
    TFontPasAI_RasterChar = SystemChar;
    TFontPasAI_RasterArrayString = TArrayPascalString;
{$ENDIF FPC}

    TFontTextInfo = record
      Font: TFontPasAI_Raster;
      Text: TFontPasAI_RasterString;
      Box, PhysicsBox: TArrayV2R4;
    end;

    TFontTextInfos = array of TFontTextInfo;
  public const
    C_WordDefine: TFontCharDefine = (Activted: False; X: 0; Y: 0; W: 0; H: 0);
    C_MAXWORD = $FFFF;
  protected
    FOnlyInstance: Boolean;
    FFontTable: PFontTable;
    FCritical: TCritical;
    FCharacterBoundBoxCache: PCharacterBoundBoxCache;
    FFragPasAI_Raster: TMR_Array;
    FBitPasAI_Raster: PFontBitPasAI_Raster;
    FFontSize: Integer;
    FActivtedWord: Integer;
    FWidth: Integer;
    FHeight: Integer;
    FFontInfo: TFontPasAI_RasterString;
  public
    X_Spacing, Y_Spacing: Integer;
    property FontInfo: TFontPasAI_RasterString read FFontInfo;

    constructor Create; overload;
    constructor Create(ShareFont: TFontPasAI_Raster); overload;
    destructor Destroy; override;

    { generate font }
    function FragPasAI_RasterIsNull(C: TFontPasAI_RasterChar): Boolean;
    procedure Add(C: TFontPasAI_RasterChar; raster: TMPasAI_Raster);
    procedure Remove(C: TFontPasAI_RasterChar);
    procedure Clear;
    procedure ClearFragPasAI_Raster;

    { build font }
    procedure Build(fontInfo_: TFontPasAI_RasterString; fontSiz: Integer; Status_: Boolean);

    { compute font }
    function ValidChar(C: TFontPasAI_RasterChar): Boolean;
    function GetBox(C: TFontPasAI_RasterChar): TRect;
    function ComputeBoundBox(C: TFontPasAI_RasterChar): TRect;
    function IsVisibled(C: TFontPasAI_RasterChar): Boolean;
    property Visibled[C: TFontPasAI_RasterChar]: Boolean read IsVisibled;
    property FontSize: Integer read FFontSize;
    property ActivtedWord: Integer read FActivtedWord;
    property Width: Integer read FWidth;
    property Height: Integer read FHeight;
    property BitPasAI_Raster: PFontBitPasAI_Raster read FBitPasAI_Raster;

    { store }
    procedure Assign(Source: TFontPasAI_Raster);
    procedure LoadFromStream(stream: TCore_Stream);
    procedure SaveToStream(stream: TCore_Stream);
    procedure LoadFromFile(filename: TPascalString);
    procedure SaveToFile(filename: TPascalString);

    { build font }
    function BuildPasAI_Raster(partitionLine: Boolean): TMPasAI_Raster;
    function BuildMorphomatics(): TMorphomatics;
    procedure ExportPasAI_Raster(stream: TCore_Stream; partitionLine: Boolean); overload;
    procedure ExportPasAI_Raster(filename: TPascalString; partitionLine: Boolean); overload;

    { draw font }
    function CharSize(const C: TFontPasAI_RasterChar): TPoint;
    function TextSize(const S: TFontPasAI_RasterString; charVec2List: TV2L): TVec2; overload;
    function TextSize(const S: TFontPasAI_RasterString): TVec2; overload;
    function TextWidth(const S: TFontPasAI_RasterString): Word;
    function TextHeight(const S: TFontPasAI_RasterString): Word;

    { compute coordinate }
    function ComputeDrawBoundBox(Text: TFontPasAI_RasterString; dstVec, Axis: TVec2; Angle, Scale: TGeoFloat; var DrawCoordinate, BoundBoxCoordinate: TArrayV2R4): TVec2; overload;
    function ComputeDrawBoundBox(Text: TFontPasAI_RasterString; dstVec, Axis: TVec2; Angle, Scale: TGeoFloat; var DrawCoordinate: TArrayV2R4): TVec2; overload;
    function ComputeDrawCoordinate(Text: TFontPasAI_RasterString; X, Y: TGeoFloat; RotateVec: TVec2; Angle, siz: TGeoFloat; var DrawCoordinate, BoundBoxCoordinate: TArrayV2R4): TVec2; overload;
    function ComputeDrawCoordinate(Text: TFontPasAI_RasterString; X, Y: TGeoFloat; RotateVec: TVec2; Angle, siz: TGeoFloat; var DrawCoordinate: TArrayV2R4): TVec2; overload;

    { draw }
    procedure DrawBit(fontRect: TRect; Dst: TMPasAI_Raster; DstRect: TV2Rect4; dstColor: TRColor; bilinear_sampling: Boolean; Alpha: TGeoFloat);
    function Draw(Text: TFontPasAI_RasterString; Dst: TMPasAI_Raster; dstVec: TVec2; dstColor: TRColor; bilinear_sampling: Boolean; Alpha: TGeoFloat; Axis: TVec2; Angle, Scale: TGeoFloat; var DrawCoordinate: TArrayV2R4): TVec2; overload;
    function Draw(Text: TFontPasAI_RasterString; Dst: TMPasAI_Raster; dstVec: TVec2; dstColor: TRColor; bilinear_sampling: Boolean; Alpha: TGeoFloat; Axis: TVec2; Angle, Scale: TGeoFloat): TVec2; overload;
    procedure Draw(Text: TFontPasAI_RasterString; Dst: TMPasAI_Raster; dstVec: TVec2; dstColor: TRColor); overload;

    { build text raster }
    function BuildText(Text: TFontPasAI_RasterString; RotateVec: TVec2; Angle, Alpha, siz: TGeoFloat; TextColor: TRColor; var DrawCoordinate, BoundBoxCoordinate: TArrayV2R4): TMPasAI_Raster; overload;
    function BuildText(Edge: Integer; Text: TFontPasAI_RasterString; RotateVec: TVec2; Angle, Alpha, siz: TGeoFloat; TextColor: TRColor; var DrawCoordinate, BoundBoxCoordinate: TArrayV2R4): TMPasAI_Raster; overload;
    function BuildEffectText(Edge: Integer; Text: TFontPasAI_RasterString; RotateVec: TVec2; Angle, Alpha, siz: TGeoFloat; TextColor: TRColor): TMPasAI_Raster;
    function BuildEffectText_Edge(Text: TFontPasAI_RasterString; RotateVec: TVec2; Angle, Alpha, siz: TGeoFloat; TextColor, EdgeColor: TRColor): TMPasAI_Raster;

    { build array text from random font }
    class function BuildTextPasAI_Raster(Random_: TRandom; PhysicsBox_: Boolean; X_Spacing_, Y_Spacing_: Integer; Margin_: TGeoFloat;
      Fonts: TFontPasAI_RasterList; FontSize_, Angle_: TGeoFloat; Text_: TFontPasAI_RasterArrayString; var OutputInfo: TFontTextInfos): TMPasAI_Raster; overload;
    { build single text from random font }
    class function BuildTextPasAI_Raster(Random_: TRandom; PhysicsBox_: Boolean; X_Spacing_, Y_Spacing_: Integer; Margin_: TGeoFloat;
      Fonts: TFontPasAI_RasterList; FontSize_, Angle_: TGeoFloat; Text_: TFontPasAI_RasterString; var OutputInfo: TFontTextInfos): TMPasAI_Raster; overload;
    { build fixed text }
    class function BuildTextPasAI_Raster(PhysicsBox_: Boolean; X_Spacing_, Y_Spacing_: Integer; Margin_: TGeoFloat;
      Fonts: TFontPasAI_RasterList; FontSize_, Angle_: TGeoFloat; Text_: TFontPasAI_RasterString; color_: TRColor; var OutputInfo: TFontTextInfos): TMPasAI_Raster; overload;

    { compute text bounds size }
    function ComputeTextSize(Text: TFontPasAI_RasterString; RotateVec: TVec2; Angle, siz: TGeoFloat): TVec2;
    { compute text ConvexHull }
    function ComputeTextConvexHull(Text: TFontPasAI_RasterString; X, Y: TGeoFloat; RotateVec: TVec2; Angle, siz: TGeoFloat): TArrayVec2;

    { advance draw }
    procedure DrawText(Text: TFontPasAI_RasterString; Dst: TMPasAI_Raster; X, Y: TGeoFloat; RotateVec: TVec2; Angle, Alpha, siz: TGeoFloat; TextColor: TRColor); overload;
    procedure DrawText(Text: TFontPasAI_RasterString; Dst: TMPasAI_Raster; X, Y: TGeoFloat; siz: TGeoFloat; TextColor: TRColor); overload;
    procedure DrawText(Text: TFontPasAI_RasterString; Dst: TMPasAI_Raster; X, Y: TGeoFloat; RotateVec: TVec2; Angle, Alpha, siz: TGeoFloat; TextColor: TRColor; var DrawCoordinate: TArrayV2R4); overload;
    procedure DrawText(Text: TFontPasAI_RasterString; Dst: TMPasAI_Raster; X, Y: TGeoFloat; siz: TGeoFloat; TextColor: TRColor; var DrawCoordinate: TArrayV2R4); overload;
  end;

  TFontRasterPool_ = TCritical_String_Big_Hash_Pair_Pool<TFontPasAI_Raster>;

  TFontRasterPool = class(TFontRasterPool_)
  public
    AutoFree: Boolean;
    constructor Create(AutoFree_: Boolean);
    procedure DoFree(var Key: SystemString; var Value: TFontPasAI_Raster); override;
    function Get_Font_List(Key_Filter: SystemString): TFontPasAI_RasterList;
  end;

{$ENDREGION 'TFontRaster'}
{$REGION 'Morphomatics'}

  TMorphomaticsVector = array of TMorphomaticsValue;
  TMorphomaticsMatrix = array of TMorphomaticsVector;

  TMorphomaticsBits = array [0 .. MaxInt div SizeOf(TMorphomaticsValue) - 1] of TMorphomaticsValue;
  PMorphomaticsBits = ^TMorphomaticsBits;

  THistogramData = array [0 .. $FF] of Integer;

  TMorphFilter = (mfAverage, mfWeightedAVG, mfGeometricMean, mfMedian, mfMax, mfMin, mfMiddlePoint, mfTruncatedAVG, mfPrevitt, mfSobel, mfSharr, mfLaplace);

  TMorphomaticsDraw = TLine_2D_Templet<TMorphomaticsValue>;

  TMorphomaticsList_Decl = TGenericsList<TMorphomatics>;

  TMorphomaticsList = class(TMorphomaticsList_Decl)
  public
    procedure Clean;
  end;

  TMorphMathList = TMorphomaticsList;
  TMorphomaticsPool = TMorphomaticsList;
  TMorphMathPool = TMorphomaticsList;

  TMorphomatics = class(TCore_Object_Intermediate)
  private
    FBits: PMorphomaticsBits;
    FWidth, FHeight: Integer;
    function GetPixel(const X, Y: Integer): TMorphomaticsValue;
    procedure SetPixel(const X, Y: Integer; const Value: TMorphomaticsValue);
    function GetPixelPtr(const X, Y: Integer): PMorphomaticsValue;
    function GetScanLine(const Y: Integer): PMorphomaticsBits;
    function FindMedian(const N: Integer; arry: TMorphomaticsVector): TMorphomaticsValue;
    procedure FastSort(var arry: TMorphomaticsVector);
  public
    { global: parallel Morphomatics }
    class var Parallel: Boolean;
  public
    { local: parallel Morphomatics }
    LocalParallel: Boolean;

    constructor Create;
    destructor Destroy; override;

    procedure FreeBits;
    procedure SetSize(Width_, Height_: Integer); overload;
    procedure SetSize(Width_, Height_: Integer; Value: TMorphomaticsValue); overload;
    procedure SetSizeF(const Width_, Height_: TGeoFloat); overload;
    procedure SetSizeF(const Width_, Height_: TGeoFloat; const Value: TMorphomaticsValue); overload;
    procedure SetSizeR(const R: TRectV2); overload;
    procedure SetSizeR(const R: TRectV2; const Value: TMorphomaticsValue); overload;
    procedure FillValue(Value: TMorphomaticsValue);
    procedure FillRandomValue();
    procedure FillValueFromPolygon(Polygon: TV2L; InsideValue, OutsideValue: TMorphomaticsValue);

    function Clone: TMorphomatics;
    procedure Assign(sour: TMorphomatics);
    procedure SaveToStream(stream: TCore_Stream);
    procedure LoadFromStream(stream: TCore_Stream);
    procedure SwapData(dest: TMorphomatics);
    procedure Scale(K: TGeoFloat);
    procedure FitScale(NewWidth, NewHeight: TGeoFloat);
    function FitScaleAsNew(NewWidth, NewHeight: TGeoFloat): TMorphomatics;
    procedure DrawTo(MorphPix_: TMorphologyPixel; dest: TMPasAI_Raster); overload;
    procedure DrawTo(dest: TMPasAI_Raster); overload;
    function BuildViewer(MorphPix_: TMorphologyPixel): TMPasAI_Raster; overload;
    function BuildViewer(): TMPasAI_Raster; overload;
    procedure BuildViewerFile(MorphPix_: TMorphologyPixel; FileName_: SystemString); overload;
    procedure BuildViewerFile(FileName_: SystemString); overload;
    procedure GetHistogramData(var H: THistogramData);
    procedure BuildHistogramTo(Height_: Integer; hColor: TRColor; output_: TMPasAI_Raster);
    function BuildHistogram(Height_: Integer; hColor: TRColor): TMPasAI_Raster;
    procedure DrawLine(const X1, Y1, X2, Y2: Integer; const PixelValue_: TMorphomaticsValue; const L: Boolean);
    procedure FillBox(const X1, Y1, X2, Y2: Integer; const PixelValue_: TMorphomaticsValue);
    function BuildHoughLine(const MaxAngle_, AlphaStep_, Treshold_: TGeoFloat; const BestLinesCount_: Integer): THoughLineArry;
    procedure ProjectionTo(SourMorph_, DestMorph_: TMorphologyPixel; Dst: TMorphomatics; sourRect, DestRect: TV2Rect4; bilinear_sampling: Boolean; Alpha: TGeoFloat); overload;
    procedure ProjectionTo(SourMorph_, DestMorph_: TMorphologyPixel; Dst: TMorphomatics; sourRect, DestRect: TRectV2; bilinear_sampling: Boolean; Alpha: TGeoFloat); overload;
    procedure Projection(SourMorph_, DestMorph_: TMorphologyPixel; DestRect: TV2Rect4; PixelValue_: TMorphomaticsValue); overload;
    procedure ProjectionTo(Dst: TMorphomatics; sourRect, DestRect: TV2Rect4; bilinear_sampling: Boolean; Alpha: TGeoFloat); overload;
    procedure ProjectionTo(Dst: TMorphomatics; sourRect, DestRect: TRectV2; bilinear_sampling: Boolean; Alpha: TGeoFloat); overload;
    procedure Projection(DestRect: TV2Rect4; PixelValue_: TMorphomaticsValue); overload;

    function Width0: Integer;
    function Height0: Integer;
    function SizeOfPoint: TPoint;
    function SizeOf2DPoint: TVec2;
    function Size2D: TVec2;
    function Size0: TVec2;
    function BoundsRect: TRect;
    function BoundsRect0: TRect;
    function BoundsRectV2: TRectV2;
    function BoundsRectV20: TRectV2;
    function BoundsV2Rect4: TV2Rect4;
    function BoundsV2Rect40: TV2Rect4;
    function Centroid: TVec2;
    function Centre: TVec2;
    function InHere(const X, Y: Integer): Boolean;
    property Width: Integer read FWidth;
    property Height: Integer read FHeight;
    property Pixel[const X, Y: Integer]: TMorphomaticsValue read GetPixel write SetPixel; default;
    property PixelPtr[const X, Y: Integer]: PMorphomaticsValue read GetPixelPtr;
    property ScanLine[const Y: Integer]: PMorphomaticsBits read GetScanLine;
    property Bits: PMorphomaticsBits read FBits;

    { filter }
    procedure SigmaGaussian(const SIGMA: TGeoFloat; const SigmaGaussianKernelFactor: Integer);
    procedure Average(BoxW, BoxH: Integer);
    procedure WeightedAVG(BoxW, BoxH: Integer);
    procedure GeometricMean(BoxW, BoxH: Integer);
    procedure Median(BoxW, BoxH: Integer);
    procedure Maximum(BoxW, BoxH: Integer);
    procedure Minimum(BoxW, BoxH: Integer);
    procedure MiddlePoint(BoxW, BoxH: Integer);
    procedure TruncatedAVG(BoxW, BoxH, d: Integer);
    procedure Previtt(AdditiveToOriginal: Boolean);
    procedure Sobel(AdditiveToOriginal: Boolean);
    procedure Sharr(AdditiveToOriginal: Boolean);
    procedure Laplace(AdditiveToOriginal: Boolean);
    procedure ProcessFilter(filter: TMorphFilter);

    { classic morphomatics transform }
    procedure Linear(K, B: TMorphomaticsValue);
    procedure Logarithms(C: TMorphomaticsValue);
    procedure Gamma(C, Gamma: TMorphomaticsValue);
    procedure HistogramEqualization();
    procedure Contrast(K: TMorphomaticsValue);
    procedure Gradient(level: Byte);
    procedure Clamp(MinV, MaxV: TMorphomaticsValue);
    procedure Invert;

    { symbol transform }
    procedure ADD_(Morph: TMorphomatics); overload;
    procedure SUB_(Morph: TMorphomatics); overload;
    procedure MUL_(Morph: TMorphomatics); overload;
    procedure DIV_(Morph: TMorphomatics); overload;

    { phototype transform }
    procedure ADD_(f: TMorphomaticsValue); overload;
    procedure SUB_(f: TMorphomaticsValue); overload;
    procedure MUL_(f: TMorphomaticsValue); overload;
    procedure DIV_(f: TMorphomaticsValue); overload;

    { Binaryzation symbol transform }
    procedure ADD_(bin: TMorphologyBinaryzation; K: TMorphomaticsValue); overload;
    procedure SUB_(bin: TMorphologyBinaryzation; K: TMorphomaticsValue); overload;
    procedure MUL_(bin: TMorphologyBinaryzation; K: TMorphomaticsValue); overload;
    procedure DIV_(bin: TMorphologyBinaryzation; K: TMorphomaticsValue); overload;

    { grayscale morphology operation }
    procedure Dilatation(ConvolutionKernel: TMorphologyBinaryzation; Output: TMorphomatics); overload;
    procedure Erosion(ConvolutionKernel: TMorphologyBinaryzation; Output: TMorphomatics); overload;
    procedure Opening(ConvolutionKernel: TMorphologyBinaryzation; Output: TMorphomatics); overload;
    procedure Closing(ConvolutionKernel: TMorphologyBinaryzation; Output: TMorphomatics); overload;
    procedure OpeningAndClosing(ConvolutionKernel: TMorphologyBinaryzation; Output: TMorphomatics); overload;
    procedure ClosingAndOpening(ConvolutionKernel: TMorphologyBinaryzation; Output: TMorphomatics); overload;

    procedure Dilatation(ConvolutionKernel: TMorphologyBinaryzation); overload;
    procedure Erosion(ConvolutionKernel: TMorphologyBinaryzation); overload;
    procedure Opening(ConvolutionKernel: TMorphologyBinaryzation); overload;
    procedure Closing(ConvolutionKernel: TMorphologyBinaryzation); overload;
    procedure OpeningAndClosing(ConvolutionKernel: TMorphologyBinaryzation); overload;
    procedure ClosingAndOpening(ConvolutionKernel: TMorphologyBinaryzation); overload;

    { quick morphology operation }
    procedure Dilatation(const ConvolutionSizeX, ConvolutionSizeY: Integer; Output: TMorphomatics); overload;
    procedure Erosion(const ConvolutionSizeX, ConvolutionSizeY: Integer; Output: TMorphomatics); overload;
    procedure Opening(const ConvolutionSizeX, ConvolutionSizeY: Integer; Output: TMorphomatics); overload;
    procedure Closing(const ConvolutionSizeX, ConvolutionSizeY: Integer; Output: TMorphomatics); overload;
    procedure OpeningAndClosing(const ConvolutionSizeX, ConvolutionSizeY: Integer; Output: TMorphomatics); overload;
    procedure ClosingAndOpening(const ConvolutionSizeX, ConvolutionSizeY: Integer; Output: TMorphomatics); overload;

    procedure Dilatation(const ConvolutionSizeX, ConvolutionSizeY: Integer); overload;
    procedure Erosion(const ConvolutionSizeX, ConvolutionSizeY: Integer); overload;
    procedure Opening(const ConvolutionSizeX, ConvolutionSizeY: Integer); overload;
    procedure Closing(const ConvolutionSizeX, ConvolutionSizeY: Integer); overload;
    procedure OpeningAndClosing(const ConvolutionSizeX, ConvolutionSizeY: Integer); overload;
    procedure ClosingAndOpening(const ConvolutionSizeX, ConvolutionSizeY: Integer); overload;

    { Morphology Binaryzation }
    function Binarization(Thresold: TMorphomaticsValue): TMorphologyBinaryzation;
    function Binarization_InRange(Min_, Max_: TMorphomaticsValue): TMorphologyBinaryzation;
    function Binarization_Bernsen(R: Integer; ContrastThresold: TMorphomaticsValue): TMorphologyBinaryzation;
    function Binarization_FloydSteinbergDithering: TMorphologyBinaryzation;
    {
      Thresholding using Otsu's method (which chooses the threshold to minimize the intraclass variance of the black and white pixels!).
      Functions returns calculated threshold level value [0..255].
      If BinarizeImage is True then the Image is automatically converted to binary using computed threshold level.
    }
    function Binarization_OTSU: TMorphologyBinaryzation;

    class procedure Test();
  end;
{$ENDREGION 'Morphomatics'}
{$REGION 'Binaryzation'}

  TBinaryzationValue = Boolean;
  PBinaryzationValue = ^TBinaryzationValue;

  TBinaryzationBits = array [0 .. MaxInt div SizeOf(TBinaryzationValue) - 1] of TBinaryzationValue;
  PBinaryzationBits = ^TBinaryzationBits;

  TBinaryzationOperation = (boNone,
    boDilatation, boErosion, boOpening, boClosing, boOpeningAndClosing, boClosingAndOpening,
    boOR, boAND, boXOR);

  TMorphologyBinaryzationDraw_ = TLine_2D_Templet<TBinaryzationValue>;
  TMorphologyBinaryzationDraw = class(TMorphologyBinaryzationDraw_);

  TMorphologyBinaryzationLineHitAnalysis_ = TLine_2D_Templet<TBinaryzationValue>;

  TMorphologyBinaryzationLineHitAnalysis = class(TMorphologyBinaryzationLineHitAnalysis_)
  private
    FPixelSum: NativeInt;
    FPixelValue: TBinaryzationValue;
  public
    function AnalysisBox(const X1, Y1, X2, Y2: NativeInt; const PixelValue_: TBinaryzationValue): NativeInt;
    function AnalysisLine(const X1, Y1, X2, Y2: NativeInt; const PixelValue_: TBinaryzationValue): NativeInt;
    procedure Process(const vp: TMorphologyBinaryzationLineHitAnalysis_.PT_; const v: TBinaryzationValue); override;
  end;

  TMorphologyBinaryzation_Decl = TGenericsList<TMorphologyBinaryzation>;

  TMorphologyBinaryzationList = class(TMorphomaticsList_Decl)
  public
    procedure Clean;
  end;

  TMorphBinList = TMorphologyBinaryzationList;
  TMorphologyBinaryzationPool = TMorphologyBinaryzationList;
  TMorphBinPool = TMorphologyBinaryzationList;

  TMorphologyBinaryzation = class(TCore_Object_Intermediate)
  private
    FBits: PBinaryzationBits;
    FWidth, FHeight: Integer;
    function GetPixel(const X, Y: Integer): TBinaryzationValue;
    procedure SetPixel(const X, Y: Integer; const Value: TBinaryzationValue);
  public
    { global: parallel Binaryzation }
    class var Parallel: Boolean;
  public
    { local: parallel Binaryzation }
    LocalParallel: Boolean;

    constructor Create;
    destructor Destroy; override;

    procedure FreeBits;
    procedure SetSize(const Width_, Height_: Integer); overload;
    procedure SetSize(const Width_, Height_: Integer; const Value: TBinaryzationValue); overload;
    procedure SetSizeF(const Width_, Height_: TGeoFloat); overload;
    procedure SetSizeF(const Width_, Height_: TGeoFloat; const Value: TBinaryzationValue); overload;
    procedure SetSizeR(const R: TRectV2); overload;
    procedure SetSizeR(const R: TRectV2; const Value: TBinaryzationValue); overload;
    procedure SetConvolutionSize(const Width_, Height_: Integer; const Value: TBinaryzationValue);
    procedure FillValue(Value: TBinaryzationValue);
    procedure FillRandomValue();
    procedure FillValueFromPolygon(Polygon: TV2L; InsideValue, OutsideValue: TBinaryzationValue);
    function ValueSum(Value: TBinaryzationValue): Integer;
    procedure DrawLine(const X1, Y1, X2, Y2: Integer; const PixelValue_: TBinaryzationValue; const L: Boolean);
    procedure FillBox(const X1, Y1, X2, Y2: Integer; const PixelValue_: TBinaryzationValue);
    function LineHitSum(const X1, Y1, X2, Y2: Integer; const PixelValue_: TBinaryzationValue; const L: Boolean): Integer;
    function BoxHitSum(const X1, Y1, X2, Y2: Integer; const PixelValue_: TBinaryzationValue): Integer; overload;
    function BoxHitSum(const R: TRect; const PixelValue_: TBinaryzationValue): Integer; overload;
    function BoxHitSum(const R: TRectV2; const PixelValue_: TBinaryzationValue): Integer; overload;
    function BuildHoughLine(const MaxAngle_, AlphaStep_: TGeoFloat; const BestLinesCount_: Integer): THoughLineArry;
    procedure ProjectionTo(SourMorph_, DestMorph_: TMorphologyPixel; Dst: TMorphologyBinaryzation; sourRect, DestRect: TV2Rect4; bilinear_sampling: Boolean; Alpha: TGeoFloat); overload;
    procedure ProjectionTo(SourMorph_, DestMorph_: TMorphologyPixel; Dst: TMorphologyBinaryzation; sourRect, DestRect: TRectV2; bilinear_sampling: Boolean; Alpha: TGeoFloat); overload;
    procedure Projection(SourMorph_, DestMorph_: TMorphologyPixel; DestRect: TV2Rect4; Value: TBinaryzationValue); overload;
    procedure ProjectionTo(Dst: TMorphologyBinaryzation; sourRect, DestRect: TV2Rect4; bilinear_sampling: Boolean; Alpha: TGeoFloat); overload;
    procedure ProjectionTo(Dst: TMorphologyBinaryzation; sourRect, DestRect: TRectV2; bilinear_sampling: Boolean; Alpha: TGeoFloat); overload;
    procedure Projection(DestRect: TV2Rect4; Value: TBinaryzationValue); overload;
    procedure IfThenSet(IfValue: TBinaryzationValue; dest: TMPasAI_Raster; destValue: TRColor);

    function Clone: TMorphologyBinaryzation;
    procedure Assign(sour: TMorphologyBinaryzation);
    procedure SaveToStream(stream: TCore_Stream);
    procedure LoadFromStream(stream: TCore_Stream);
    procedure SwapData(dest: TMorphologyBinaryzation);
    procedure Invert;
    function BuildMorphologySegmentation(): TMorphologySegmentation;
    function BuildMorphomatics(): TMorphomatics;
    procedure DrawTo(raster: TMPasAI_Raster); overload;
    procedure DrawTo(MorphPix_: TMorphologyPixel; raster: TMPasAI_Raster); overload;
    function BuildViewer(): TMPasAI_Raster; overload;
    function BuildViewer(MorphPix_: TMorphologyPixel): TMPasAI_Raster; overload;
    procedure BuildViewerFile(FileName_: SystemString); overload;
    procedure BuildViewerFile(MorphPix_: TMorphologyPixel; FileName_: SystemString); overload;
    function ConvexHull(): TV2L;
    function BoundsRectV2(const Value: TBinaryzationValue; var Sum_: Integer): TRectV2; overload;
    function BoundsRectV2(const Value: TBinaryzationValue): TRectV2; overload;
    function BoundsRect(const Value: TBinaryzationValue; var Sum_: Integer): TRect; overload;
    function BoundsRect(const Value: TBinaryzationValue): TRect; overload;
    function Width0: Integer;
    function Height0: Integer;
    function SizeOfPoint: TPoint;
    function SizeOf2DPoint: TVec2;
    function Size2D: TVec2;
    function Size0: TVec2;
    function BoundsRect: TRect; overload;
    function BoundsRect0: TRect;
    function BoundsRectV2: TRectV2; overload;
    function BoundsRectV20: TRectV2;
    function BoundsV2Rect4: TV2Rect4;
    function BoundsV2Rect40: TV2Rect4;
    function Centroid: TVec2;
    function Centre: TVec2;
    function InHere(const X, Y: Integer): Boolean;
    property Width: Integer read FWidth;
    property Height: Integer read FHeight;
    property Pixel[const X, Y: Integer]: TBinaryzationValue read GetPixel write SetPixel; default;
    property Bits: PBinaryzationBits read FBits;

    { convolution operation }
    procedure Dilatation(ConvolutionKernel, Output: TMorphologyBinaryzation); overload;
    procedure Erosion(ConvolutionKernel, Output: TMorphologyBinaryzation); overload;
    procedure Opening(ConvolutionKernel, Output: TMorphologyBinaryzation); overload;
    procedure Closing(ConvolutionKernel, Output: TMorphologyBinaryzation); overload;
    procedure OpeningAndClosing(ConvolutionKernel, Output: TMorphologyBinaryzation); overload;
    procedure ClosingAndOpening(ConvolutionKernel, Output: TMorphologyBinaryzation); overload;
    procedure Skeleton(ConvolutionKernel, Output: TMorphologyBinaryzation); overload;

    procedure Dilatation(ConvolutionKernel: TMorphologyBinaryzation); overload;
    procedure Erosion(ConvolutionKernel: TMorphologyBinaryzation); overload;
    procedure Opening(ConvolutionKernel: TMorphologyBinaryzation); overload;
    procedure Closing(ConvolutionKernel: TMorphologyBinaryzation); overload;
    procedure OpeningAndClosing(ConvolutionKernel: TMorphologyBinaryzation); overload;
    procedure ClosingAndOpening(ConvolutionKernel: TMorphologyBinaryzation); overload;
    procedure Skeleton(ConvolutionKernel: TMorphologyBinaryzation); overload;

    { quick morphology operation }
    procedure Dilatation(const ConvolutionSizeX, ConvolutionSizeY: Integer; Output: TMorphologyBinaryzation); overload;
    procedure Erosion(const ConvolutionSizeX, ConvolutionSizeY: Integer; Output: TMorphologyBinaryzation); overload;
    procedure Opening(const ConvolutionSizeX, ConvolutionSizeY: Integer; Output: TMorphologyBinaryzation); overload;
    procedure Closing(const ConvolutionSizeX, ConvolutionSizeY: Integer; Output: TMorphologyBinaryzation); overload;
    procedure OpeningAndClosing(const ConvolutionSizeX, ConvolutionSizeY: Integer; Output: TMorphologyBinaryzation); overload;
    procedure ClosingAndOpening(const ConvolutionSizeX, ConvolutionSizeY: Integer; Output: TMorphologyBinaryzation); overload;
    procedure Skeleton(const ConvolutionSizeX, ConvolutionSizeY: Integer; Output: TMorphologyBinaryzation); overload;
    procedure Dilatation(const ConvolutionSizeX, ConvolutionSizeY: Integer); overload;
    procedure Erosion(const ConvolutionSizeX, ConvolutionSizeY: Integer); overload;
    procedure Opening(const ConvolutionSizeX, ConvolutionSizeY: Integer); overload;
    procedure Closing(const ConvolutionSizeX, ConvolutionSizeY: Integer); overload;
    procedure OpeningAndClosing(const ConvolutionSizeX, ConvolutionSizeY: Integer); overload;
    procedure ClosingAndOpening(const ConvolutionSizeX, ConvolutionSizeY: Integer); overload;
    procedure Skeleton(const ConvolutionSizeX, ConvolutionSizeY: Integer); overload;

    { this Transformation is a symbol operation, not a convolution }
    procedure OR_(Source, Output: TMorphologyBinaryzation); overload;
    procedure AND_(Source, Output: TMorphologyBinaryzation); overload;
    procedure XOR_(Source, Output: TMorphologyBinaryzation); overload;
    procedure OR_(Source: TMorphologyBinaryzation); overload;
    procedure AND_(Source: TMorphologyBinaryzation); overload;
    procedure XOR_(Source: TMorphologyBinaryzation); overload;

    procedure Process(Operation_: TBinaryzationOperation; Data: TMorphologyBinaryzation);

    procedure Print;

    class procedure Test();
  end;
{$ENDREGION 'Binaryzation'}
{$REGION 'Segmentation'}

  PMorphologySegData = ^TMorphologySegData;

  TMorphologyGeoData = record
    X, Y: Integer;
    segPtr: PMorphologySegData;
  end;

  PMorphologyGeoData = ^TMorphologyGeoData;

  TSegmentationGeometry_Decl = TGenericsList<PMorphologyGeoData>;

  TSegmentationGeometry = class(TSegmentationGeometry_Decl)
  public
    constructor Create;
    destructor Destroy; override;
    procedure InsertGeo(index: Integer; X, Y: Integer; segPtr: PMorphologySegData);
    procedure AddGeo(X, Y: Integer; segPtr: PMorphologySegData);
    procedure Remove(p: PMorphologyGeoData);
    procedure Delete(index: TGeoInt);
    procedure Clear;
  end;

  TMorphologySegData = record
    Y, L, R: Integer; { (L,Y) (R,Y) }
    LTop: PMorphologySegData; { connection to left top }
    RTop: PMorphologySegData; { connection to right top }
    LBot: PMorphologySegData; { connection to left bottom }
    RBot: PMorphologySegData; { connection to right bottom }
    Left: PMorphologySegData; { connection to left }
    Right: PMorphologySegData; { connection to right }
    GroupID: Integer; { Morphology group ID }
    Classify: TMorphologyClassify; { classify }
    LGeometry, RGeometry: TSegmentationGeometry; { internal geometry }
    index: Integer; { container index from TMorphologyPool_Decl }
  end;

  TMorphologyPool_Decl = TGenericsList<PMorphologySegData>;

  TMorphologyPool = class(TMorphologyPool_Decl)
  private
    FBoundsCached: Boolean;
    FBoundsCache: TRectV2;
    FPixelSumCache: Integer;
    FClassify: TMorphologyClassify;
    FGroupID: Integer;
  public
    Owner: TMorphologySegmentation;
    constructor Create;
    procedure AddSeg(const buff: array of PMorphologySegData);
    procedure SortY;
    function BoundsRectV2(Cache: Boolean): TRectV2; overload;
    function BoundsRectV2: TRectV2; overload;
    function BoundsRect: TRect;
    function Centre: TVec2;
    function Left: Integer;
    function Top: Integer;
    function Width: Integer;
    function Height: Integer;
    function PixelSum: Integer;
    function Area: Integer;
    function BuildBinaryzation(): TMorphologyBinaryzation;
    procedure FillToBinaryzation(morphBin_: TMorphologyBinaryzation);
    procedure DrawTo(dest: TMPasAI_Raster; DataColor: TRColor);
    procedure ProjectionTo(Source, dest: TMPasAI_Raster);
    function Projection(Source: TMPasAI_Raster): TMPasAI_Raster;
    function BuildDatamap(backColor, DataColor: TRColor): TMPasAI_Raster;
    function BuildClipDatamap(backColor, DataColor: TRColor): TMPasAI_Raster;
    function BuildClipMap(Source: TMPasAI_Raster; backColor: TRColor): TMPasAI_Raster;
    function BuildVertex(): T2DPolygon;
    function BuildConvexHull(): T2DPolygon;
    function BuildLines(Reduction: TGeoFloat): TLinesList;
    function IsGroup(const X, Y: Integer): Boolean;
    function IsEdge(const X, Y: Integer): Boolean;
    function ScanEdge(const Y, L, R: Integer): Boolean;
    function BuildGeometry(Reduction: TGeoFloat): T2DPolygonGraph;
    function BuildConvolutionGeometry(Reduction: TGeoFloat; Operation_: TBinaryzationOperation; ConvolutionKernel: TMorphologyBinaryzation): T2DPolygonGraph; overload;
    function BuildConvolutionGeometry(Reduction: TGeoFloat): T2DPolygonGraph; overload;
    property Classify: TMorphologyClassify read FClassify;
    property GroupID: Integer read FGroupID;
  end;

  TMorphologyPoolList = TGenericsList<TMorphologyPool>;

  TMorphologySegMap = array of array of PMorphologySegData;
  TMorphologySegClassifyMap = array of array of TMorphologyClassify;

  TConvolutionKernelProc = procedure(ConvolutionKernel: TMorphologyBinaryzation) of object;

  TMorphologySegmentation = class(TCore_Object_Intermediate)
  private
    FWidth, FHeight: Integer;
    FSegMap: TMorphologySegMap;
    FSource: TMorphologyPool_Decl;
    FMorphologyPoolList: TMorphologyPoolList;
    FOnGetPixelSegClassify: TOnGetPixelSegClassify;
    FOnGetMorphomaticsSegClassify: TOnGetMorphomaticsSegClassify;

    function NewMorphologySegData(X, Y: Integer; Classify: TMorphologyClassify): PMorphologySegData;
    function FindPool(p: PMorphologySegData): TMorphologyPool;
    function GetOrCreatePool(p: PMorphologySegData): TMorphologyPool;
    procedure AddToGroup(p: PMorphologySegData);

    function GetPools(X, Y: Integer): TMorphologyPool;
    function GetItems(index: Integer): TMorphologyPool;
    procedure ResetSource;
    procedure PrepareMap(Width_, Height_: Integer);
    procedure InternalFillMap(var classifyMap_: TMorphologySegClassifyMap; Width_, Height_: Integer);
    procedure ExtractSegLinkToGroup();
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear();

    { pixel segmentation }
    property OnGetPixelSegClassify: TOnGetPixelSegClassify read FOnGetPixelSegClassify write FOnGetPixelSegClassify;
    function DoGetPixelSegClassify(X, Y: Integer; Color: TRColor): TMorphologyClassify; virtual;
    procedure BuildSegmentation(raster: TMPasAI_Raster); overload;

    { advanced pixel segmentation }
    procedure BuildSegmentation(raster: TMPasAI_Raster;
      ConvolutionOperations: array of TBinaryzationOperation; ConvWidth, ConvHeight, MaxClassifyCount, MinGranularity: Integer); overload;

    { morphomatics segmentation }
    property OnGetMorphomaticsSegClassify: TOnGetMorphomaticsSegClassify read FOnGetMorphomaticsSegClassify write FOnGetMorphomaticsSegClassify;
    function DoGetMorphomaticsSegClassify(X, Y: Integer; Morph: TMorphomaticsValue): TMorphologyClassify; virtual;
    procedure BuildSegmentation(Morph: TMorphomatics); overload;

    { binaryzation segmentation }
    procedure BuildSegmentation(Binaryzation: TMorphologyBinaryzation); overload;

    { build morphology segmentation map }
    procedure BuildSegmentation(var classifyMap_: TMorphologySegClassifyMap; Width_, Height_: Integer); overload;
    function GetClassifyMap: TMorphologySegClassifyMap;

    { build morphology segmentation link }
    procedure UpdateMorphologyPool();

    { merge all overlop boundbox of Segmentation }
    procedure MergeOverlapSegmentation();

    { remove noise }
    function RemoveNoise(PixelNoiseThreshold: Integer): Boolean;

    { data support }
    function Clone: TMorphologySegmentation;
    procedure Assign(sour: TMorphologySegmentation);
    procedure SaveToStream(stream: TCore_Stream);
    procedure LoadFromStream(stream: TCore_Stream);

    function BuildBinaryzation(): TMorphologyBinaryzation;
    function Projection(Source: TMPasAI_Raster): TMPasAI_Raster;
    function BuildViewer(): TMPasAI_Raster;

    function Count: Integer;
    property PoolCount: Integer read Count;
    property Items[index: Integer]: TMorphologyPool read GetItems; default;
    property Pools[X, Y: Integer]: TMorphologyPool read GetPools;
    property Width: Integer read FWidth;
    property Height: Integer read FHeight;
    function Width0: Integer;
    function Height0: Integer;
    function SizeOfPoint: TPoint;
    function SizeOf2DPoint: TVec2;
    function Size2D: TVec2;
    function Size0: TVec2;
    function BoundsRect: TRect; overload;
    function BoundsRect0: TRect;
    function BoundsRectV2: TRectV2; overload;
    function BoundsRectV20: TRectV2;
    function BoundsV2Rect4: TV2Rect4;
    function BoundsV2Rect40: TV2Rect4;
    function Centroid: TVec2;
    function Centre: TVec2;
    function InHere(const X, Y: Integer): Boolean;

    { test operation }
    class procedure Test(inputfile, outputfile: SystemString);
  end;

{$ENDREGION 'Segmentation'}
{$REGION 'RCLines Detector'}

  TMorphologyRCLineStyle = (lsRow, lsCol);

  TMorphologyRCLine = record
    Bp, Ep: TPoint;
    Style: TMorphologyRCLineStyle;
  end;

  PMorphologyRCLine = ^TMorphologyRCLine;

  TMorphologyRCLineList_Decl = TGenericsList<PMorphologyRCLine>;

  TMorphologyRCLines = class(TMorphologyRCLineList_Decl)
  public
    constructor Create;
    class function BuildLines(map: TMorphologyBinaryzation; MinLineLength: Integer): TMorphologyRCLines;
    class function BuildIntersectSegment(map: TMorphologyBinaryzation; MinLineLength: Integer): TMorphologyRCLines;
    destructor Destroy; override;
    procedure AddRCLine(Bx, By, Ex, Ey: Integer; Style: TMorphologyRCLineStyle);
    function SumLine(Style: TMorphologyRCLineStyle): Integer;
    function BuildFormulaBox(): TRectV2List;

    procedure Remove(p1, p2, p3, p4: PMorphologyRCLine); overload;
    procedure Remove(p: PMorphologyRCLine); overload;
    procedure Delete(index: Integer);
    procedure Clear;
  end;

{$ENDREGION 'RCLines Detector'}
{$REGION 'RasterAPI'}


function New_Custom_Raster(W, H: Integer; ClearColor: TRColor): TMPasAI_Raster;

function Wait_SystemFont_Init: TFontPasAI_Raster;

procedure Raster_Global_Parallel(parallel_: Boolean);

function ClampInt(const Value, IMin, IMax: Integer): Integer;
function ClampByte3(const Value, IMin, IMax: Byte): Byte;

function ClampByte(const Value: Cardinal): Byte; overload;
function ClampByte(const Value: Integer): Byte; overload;
function ClampByte(const Value: UInt64): Byte; overload;
function ClampByte(const Value: Int64): Byte; overload;
function RoundAsByte(const Value: Double): Byte;

procedure DisposePasAI_RasterArray(var arry: TMR_Array);

procedure BlendBlock(Dst: TMPasAI_Raster; DstRect: TRect; Src: TMPasAI_Raster; Srcx, Srcy: Integer; CombineOp: TDrawMode);
procedure BlockTransfer(Dst: TMPasAI_Raster; Dstx: Integer; Dsty: Integer; DstClip: TRect; Src: TMPasAI_Raster; SrcRect: TRect; CombineOp: TDrawMode);

procedure FillPasAI_RasterColor(BitPtr: Pointer; Count: Cardinal; Value: TPasAI_RasterColor);
procedure CopyPasAI_RasterColor(const Source; var dest; Count: Cardinal);
function RandomPasAI_RasterColor(rand: TRandom; const A_, Min_, Max_: Byte): TRColor; overload;
function RandomPasAI_RasterColor(const A_, Min_, Max_: Byte): TRColor; overload;
function RandomPasAI_RasterColor(const A: Byte): TRColor; overload;
function RandomPasAI_RasterColor(): TRColor; overload;
function RandomPasAI_RasterColorF(const minR, maxR, minG, maxG, minB, maxB, minA, maxA: TGeoFloat): TRColor; overload;
function RandomPasAI_RasterColorF(rand: TRandom; minR, maxR, minG, maxG, minB, maxB, minA, maxA: TGeoFloat): TRColor; overload;
function PasAI_RasterColor(const v: TVec4): TRColor; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}overload;
function PasAI_RasterColor(const R, G, B, A: Byte): TPasAI_RasterColor; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}overload;
function PasAI_RasterColor(const R, G, B: Byte): TPasAI_RasterColor; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}overload;
function PasAI_RasterColorInv(const C: TPasAI_RasterColor): TPasAI_RasterColor;
function PasAI_RasterAlphaColor(const C: TPasAI_RasterColor; const A: Byte): TPasAI_RasterColor;
function PasAI_RasterAlphaColorF(const C: TPasAI_RasterColor; const A: TGeoFloat): TPasAI_RasterColor;
function PasAI_RasterColorF(const R, G, B, A: TGeoFloat): TPasAI_RasterColor; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}overload;
function PasAI_RasterColorF(const R, G, B: TGeoFloat): TPasAI_RasterColor; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}overload;
procedure PasAI_RasterColor2F(const C: TPasAI_RasterColor; var R, G, B, A: TGeoFloat); {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}overload;
procedure PasAI_RasterColor2F(const C: TPasAI_RasterColor; var R, G, B: TGeoFloat); {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}overload;
function PasAI_RasterColor2Vec4(const C: TPasAI_RasterColor): TVec4;
function PasAI_RasterColor2Vector4(const C: TPasAI_RasterColor): TVector4;
function PasAI_RasterColor2Vec3(const C: TPasAI_RasterColor): TVec3;
function PasAI_RasterColor2Vector3(const C: TPasAI_RasterColor): TVector3;
function RasterColor2FastGray(const C: TPasAI_RasterColor): Byte; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
function PasAI_RasterColor2Gray(const C: TPasAI_RasterColor): Byte; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
function PasAI_RasterColor2GrayS(const C: TPasAI_RasterColor): TGeoFloat; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
function PasAI_RasterColor2GrayD(const C: TPasAI_RasterColor): Double; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
function SetPasAI_RasterColorAlpha(const C: TPasAI_RasterColor; const A: Byte): TRColor; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}

procedure FillRColor(BitPtr: Pointer; Count: Cardinal; Value: TRColor);
procedure CopyRColor(const Source; var dest; Count: Cardinal);
function RandomRColor(rand: TRandom; const A_, Min_, Max_: Byte): TRColor; overload;
function RandomRColor(const A_, Min_, Max_: Byte): TRColor; overload;
function RandomRColor(const A: Byte): TRColor; overload;
function RandomRColor(): TRColor; overload;
function RandomRColorF(const minR, maxR, minG, maxG, minB, maxB, minA, maxA: TGeoFloat): TRColor; overload;
function RandomRColorF(rand: TRandom; minR, maxR, minG, maxG, minB, maxB, minA, maxA: TGeoFloat): TRColor; overload;
function RColor(const S: U_String): TRColor; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}overload;
function RColor(const v: TVec4): TRColor; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}overload;
function RColor(const R, G, B, A: Byte): TRColor; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}overload;
function RColor(const R, G, B: Byte): TRColor; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}overload;
function RColorInv(const C: TRColor): TRColor;
function RAlphaColor(const C: TPasAI_RasterColor; const A: Byte): TPasAI_RasterColor;
function RAlphaColorF(const C: TPasAI_RasterColor; const A: TGeoFloat): TPasAI_RasterColor;
function RColorF(const R, G, B, A: TGeoFloat): TRColor; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}overload;
function RColorF(const R, G, B: TGeoFloat): TRColor; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}overload;
procedure RColor2F(const C: TRColor; var R, G, B, A: TGeoFloat); {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}overload;
procedure RColor2F(const C: TRColor; var R, G, B: TGeoFloat); {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}overload;
function RColor2Vec4(const C: TRColor): TVec4;
function RColor2Vector4(const C: TRColor): TVector4;
function RColor2Vec3(const C: TRColor): TVec3;
function RColor2Vector3(const C: TRColor): TVector3;
function RColor2FastGray(const C: TPasAI_RasterColor): Byte; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
function RColor2Gray(const C: TRColor): Byte; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
function RColor2GrayS(const C: TRColor): TGeoFloat; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
function RColor2GrayD(const C: TRColor): Double; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
function SetRColorAlpha(const C: TPasAI_RasterColor; const A: Byte): TRColor; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}

function RColorDistanceMax(c1, c2: TRColor): Byte; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
function RColorDistanceSum(c1, c2: TRColor): Integer; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
function RColorDistance(c1, c2: TRColor): TGeoFloat; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
function RColorDistanceByte(c1, c2: TRColor): Byte; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
function RColorGradient(C: TRColor; level: Byte): TRColor; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
function RColorGrayGradient(C: TRColor; level: Byte): Byte; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}

function RGBA2BGRA(const sour: TRColor): TRColor; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
function BGRA2RGBA(const sour: TRColor): TRColor; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
function RGBA2RGB(const sour: TRColor): TRGB; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
function RGBA2BGR(const sour: TRColor): TRGB; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
function RGB2BGR(const sour: TRGB): TRGB; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
function BGR2RGB(const sour: TRGB): TRGB; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
function RGB2RGBA(const sour: TRGB): TRColor; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}

procedure SwapBR(var sour: TRGB); {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}overload;
procedure SwapBR(var sour: TRColor); {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}overload;

function MaxRGBComponent(sour: TRColor): Byte; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
function MaxRGBIndex(sour: TRColor): Byte; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
function MinRGBComponent(sour: TRColor): Byte; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
function MinRGBIndex(sour: TRColor): Byte; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}

function RColorToApproximateMorph(Color, ApproximateColor_: TRColor): TMorphomaticsValue; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
function RColorToMorph(Color: TRColor; MorphPix: TMorphologyPixel): TMorphomaticsValue; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
procedure MorphToRColor(MorphPix: TMorphologyPixel; Value: TMorphomaticsValue; var Color: TRColor); {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}

procedure FillColorTable(const RBits, GBits, BBits: Byte; const DestCount: Integer; dest: PRColorArray);
function FindColorIndex(Color: TRColor; const DestCount: Integer; dest: PRColorArray): Integer;
function FindColor255Index(Color: TRColor): Integer;
function FindColor65535Index(Color: TRColor): Integer;

function AggColor(const Value: TRColor): TAggColorRgba8; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}overload;
function AggColor(const R, G, B: TGeoFloat; const A: TGeoFloat = 1.0): TAggColorRgba8; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}overload;
function AggColor(const Value: TAggColorRgba8): TRColor; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}overload;

function ComputeSize(const MAX_Width, MAX_Height: Integer; var Width, Height: Integer): TGeoFloat;

function Compute_Diff_Area(sour, dest: TMPasAI_Raster; var Box: TRect): Boolean;

type
  TDiff_Area_Head = packed record
    full: Boolean;
    W, H, X1, Y1, X2, Y2: Word;
  end;

procedure Build_NULL_Diff_Data(dest: TMPasAI_Raster; Output: TMS64);
function Build_Diff_Data(sour, dest: TMPasAI_Raster; Output: TMS64): Boolean;
procedure Extract_Diff_Data(sour: TMS64; dest: TMPasAI_Raster);

procedure FastBlur(Source, dest: TMPasAI_Raster; radius: Double; const Bounds: TRect); overload;
procedure FastBlur(Source: TMPasAI_Raster; radius: Double; const Bounds: TRect); overload;
procedure GaussianBlur(Source, dest: TMPasAI_Raster; radius: Double; const Bounds: TRect); overload;
procedure GaussianBlur(Source: TMPasAI_Raster; radius: Double; const Bounds: TRect); overload;
procedure GrayscaleBlur(Source, dest: TMPasAI_Raster; radius: Double; const Bounds: TRect); overload;
procedure GrayscaleBlur(Source: TMPasAI_Raster; radius: Double; const Bounds: TRect); overload;

procedure Antialias32(const DestMR: TMPasAI_Raster; AXOrigin, AYOrigin, AXFinal, AYFinal: Integer); overload;
procedure Antialias32(const DestMR: TMPasAI_Raster; const Amount_: Integer); overload;
procedure Antialias32(const DestMR: TMPasAI_Raster); overload;
procedure HistogramEqualize(const mr: TMPasAI_Raster); overload;
procedure HistogramEqualize(const mr1, mr2: TMPasAI_Raster); overload;
procedure RemoveRedEyes(const mr: TMPasAI_Raster);
procedure Sepia32(const mr: TMPasAI_Raster; const Depth: Byte);
procedure Sharpen(const DestMR: TMPasAI_Raster; const SharpenMore: Boolean);
procedure AddColorNoise32(const Source: TMPasAI_Raster; const Amount_: Integer);
procedure AddMonoNoise32(const Source: TMPasAI_Raster; const Amount_: Integer);

type
  TDiagonalDirection = (ddLeftDiag, ddRightDiag);
procedure Diagonal(const Source, dest: TMPasAI_Raster; const backColor: TRColor; const Amount: Integer; const DiagDirection: TDiagonalDirection);

procedure GrayscaleToAlpha(Src: TMPasAI_Raster);
procedure AlphaToGrayscale(Src: TMPasAI_Raster);
procedure IntensityToAlpha(Src: TMPasAI_Raster);
procedure ReversalAlpha(Src: TMPasAI_Raster);
procedure RGBToGrayscale(Src: TMPasAI_Raster);

procedure FillBlackGrayBackgroundTexture(bk: TMPasAI_Raster; block_size: Integer; bkColor, color1, color2: TRColor); overload;
procedure FillBlackGrayBackgroundTexture(bk: TMPasAI_Raster; block_size: Integer); overload;

procedure ColorToTransparent(SrcColor: TRColor; Src, Dst: TMPasAI_Raster);

function BuildSequenceFrame(bmp32List: TCore_ListForObj; Column: Integer; Transparent: Boolean): TSequenceMemoryPasAI_Raster;
function GetSequenceFrameRect(bmp: TMPasAI_Raster; Total, Column, index: Integer): TRect;
procedure GetSequenceFrameOutput(bmp: TMPasAI_Raster; Total, Column, index: Integer; Output: TMPasAI_Raster);

function AnalysisColors(mr: TMPasAI_Raster; ignoreColors: TRColors; MaxCount: Integer): TRColors;

function BlendReg(f, B: TRColor): TRColor; register;
procedure BlendMem(f: TRColor; var B: TRColor); register;
function BlendRegEx(f, B, M: TRColor): TRColor; register;
procedure BlendMemEx(const f: TRColor; var B: TRColor; M: TRColor); register;
procedure BlendLine(Src, Dst: PRColor; Count: Integer); register;
procedure BlendLineEx(Src, Dst: PRColor; Count: Integer; M: TRColor); register;
function CombineReg(X, Y, W: TRColor): TRColor; register;
procedure CombineMem(X: TRColor; var Y: TRColor; W: TRColor); register;
procedure CombineLine(Src, Dst: PRColor; Count: Integer; W: TRColor); register;
function MergeReg(f, B: TRColor): TRColor; register;
function MergeRegEx(f, B, M: TRColor): TRColor; register;
procedure MergeMem(f: TRColor; var B: TRColor); register;
procedure MergeMemEx(f: TRColor; var B: TRColor; M: TRColor); register;
procedure MergeLine(Src, Dst: PRColor; Count: Integer); register;
procedure MergeLineEx(Src, Dst: PRColor; Count: Integer; M: TRColor); register;

{
  JPEG-LS Codec
  This code is based on http://www.stat.columbia.edu/~jakulin/jpeg-ls/mirror.htm
  Converted from C to Pascal. 2017

  fixed by 600585@qq.com, v2.3
  2018-5
}
procedure jls_PasAI_RasterToRaw3(APasAI_Raster: TMPasAI_Raster; RawStream: TCore_Stream);
procedure jls_PasAI_RasterToRaw1(APasAI_Raster: TMPasAI_Raster; RawStream: TCore_Stream);
procedure jls_GrayPasAI_RasterToRaw1(const APasAI_Raster: PBytePasAI_Raster; RawStream: TCore_Stream);
function EncodeJpegLSPasAI_RasterToStream3(APasAI_Raster: TMPasAI_Raster; const stream: TCore_Stream): Boolean;
function EncodeJpegLSPasAI_RasterToStream1(APasAI_Raster: TMPasAI_Raster; const stream: TCore_Stream): Boolean; overload;
function DecodeJpegLSPasAI_RasterFromStream(const stream: TCore_Stream; APasAI_Raster: TMPasAI_Raster): Boolean;
function EncodeJpegLSGrayPasAI_RasterToStream(const APasAI_Raster: PBytePasAI_Raster; const stream: TCore_Stream): Boolean; overload;
function DecodeJpegLSGrayPasAI_RasterFromStream(const stream: TCore_Stream; var APasAI_Raster: TBytePasAI_Raster): Boolean;

{
  document rotation detected
  by 600585@qq.com

  2018-8
}
{ Calculates rotation angle for given 8bit grayscale image.
  Useful for finding skew of scanned documents etc.
  Uses Hough transform internally.
  MaxAngle is maximal (abs. value) expected skew angle in degrees (to speed things up)
  and Threshold (0..255) is used to classify pixel as black (text) or white (background).
  Area of interest rectangle can be defined to restrict the detection to
  work only in defined part of image (useful when the document has text only in
  smaller area of page and non-text features outside the area confuse the rotation detector).
  Various calculations stats can be retrieved by passing Stats parameter.
}
function BuildPasAI_RasterHoughLine(const MaxAngle_, AlphaStep_: TGeoFloat; const BestLinesCount_: Integer; PasAI_Raster_: TMPasAI_Raster): THoughLineArry;
function BuildMorphHoughLine(const MaxAngle_, AlphaStep_, Treshold_: TGeoFloat; const BestLinesCount_: Integer; morph_: TMorphMath): THoughLineArry;
function BuildBinHoughLine(const MaxAngle_, AlphaStep_: TGeoFloat; const BestLinesCount_: Integer; bin_: TMorphBin): THoughLineArry;
function DocumentRotationDetected_MaxMatched(var BestLines: THoughLineArry): TGeoFloat;
function DocumentRotationDetected_MaxDistance(var BestLines: THoughLineArry): TGeoFloat;
function DocumentRotationDetected_AVG(var BestLines: THoughLineArry): TGeoFloat;

{
  YV12
}
procedure YV12ToPasAI_Raster_(sour: TCore_Stream; dest: TMPasAI_Raster);
procedure PasAI_Raster_ToYV12(Compressed: Boolean; sour: TMPasAI_Raster; dest: TCore_Stream);

{
  Half YV12
}
procedure HalfYUVToPasAI_Raster_(sour: TCore_Stream; dest: TMPasAI_Raster);
procedure PasAI_Raster_ToHalfYUV(Compressed: Boolean; sour: TMPasAI_Raster; dest: TCore_Stream);

{
  quart YV12
}
procedure QuartYUVToPasAI_Raster_(sour: TCore_Stream; dest: TMPasAI_Raster);
procedure PasAI_Raster_ToQuartYUV(Compressed: Boolean; sour: TMPasAI_Raster; dest: TCore_Stream);

{
  byte raster
}
procedure SaveBytePasAI_RasterToStream(raster: TBytePasAI_Raster; stream: TCore_Stream);
procedure LoadBytePasAI_RasterFromStream(var raster: TBytePasAI_Raster; stream: TCore_Stream);

{
  word raster
}
procedure SaveWordPasAI_RasterToStream(raster: TWordPasAI_Raster; stream: TCore_Stream);
procedure LoadWordPasAI_RasterFromStream(var raster: TWordPasAI_Raster; stream: TCore_Stream);

{
  MorphologySegmentation: fill in Vacancy
}
procedure ClassifyMapFillVacancy(Width, Height: Integer; var classifyMap: TMorphologySegClassifyMap);

{
  MorphologySegmentation: rebuild classifyMap
}
procedure ClassifyMapConvolution(Width, Height: Integer; var classifyMap: TMorphologySegClassifyMap; Classify: TMorphologyClassify;
  Operation_: TBinaryzationOperation; ConvolutionKernel: TMorphologyBinaryzation); overload;
procedure ClassifyMapConvolution(Width, Height: Integer; var classifyMap: TMorphologySegClassifyMap;
  Operations: array of TBinaryzationOperation; ConvolutionKernel: TMorphologyBinaryzation; MaxClassifyCount, MinGranularity: Integer); overload;

function BinaryzationOperation_To_Str(Operation_: TBinaryzationOperation): U_String;
function Str_To_BinaryzationOperation(Value_: U_String): TBinaryzationOperation;

{
  rastermization performance test.
}

procedure TestPasAI_RasterSavePerformance(inputfile: SystemString);

{$ENDREGION 'RasterAPI'}
{$REGION 'Constant'}


const
  CMorphologyPixelInfo: TMorphologyPixelInfo =
    (
    'Grayscale',
    'Luminance',
    'In-phase',
    'Quadrature-phase',
    'Hue',
    'Saturation',
    'Intensity',
    'Cyan',
    'Magenta',
    'Yellow',
    'Black',
    'Red',
    'Green',
    'Blue',
    'Alpha',
    'Black',
    'White',
    'Cyan',
    'Magenta',
    'mpYellow'
    );

  { Some predefined color constants }
  rcBlack32 = TRColor($FF000000);
  rcDimGray32 = TRColor($FF3F3F3F);
  rcGray32 = TRColor($FF7F7F7F);
  rcLightGray32 = TRColor($FFBFBFBF);
  rcWhite32 = TRColor($FFFFFFFF);
  rcMaroon32 = TRColor($FF7F0000);
  rcGreen32 = TRColor($FF007F00);
  rcOlive32 = TRColor($FF7F7F00);
  rcNavy32 = TRColor($FF00007F);
  rcPurple32 = TRColor($FF7F007F);
  rcTeal32 = TRColor($FF007F7F);
  rcRed32 = TRColor($FFFF0000);
  rcLime32 = TRColor($FF00FF00);
  rcYellow32 = TRColor($FFFFFF00);
  rcBlue32 = TRColor($FF0000FF);
  rcFuchsia32 = TRColor($FFFF00FF);
  rcAqua32 = TRColor($FF00FFFF);
  rcAliceBlue32 = TRColor($FFF0F8FF);
  rcAntiqueWhite32 = TRColor($FFFAEBD7);
  rcAquamarine32 = TRColor($FF7FFFD4);
  rcAzure32 = TRColor($FFF0FFFF);
  rcBeige32 = TRColor($FFF5F5DC);
  rcBisque32 = TRColor($FFFFE4C4);
  rcBlancheDalmond32 = TRColor($FFFFEBCD);
  rcBlueViolet32 = TRColor($FF8A2BE2);
  rcBrown32 = TRColor($FFA52A2A);
  rcBurlyWood32 = TRColor($FFDEB887);
  rcCadetblue32 = TRColor($FF5F9EA0);
  rcChartReuse32 = TRColor($FF7FFF00);
  rcChocolate32 = TRColor($FFD2691E);
  rcCoral32 = TRColor($FFFF7F50);
  rcCornFlowerBlue32 = TRColor($FF6495ED);
  rcCornSilk32 = TRColor($FFFFF8DC);
  rcCrimson32 = TRColor($FFDC143C);
  rcDarkBlue32 = TRColor($FF00008B);
  rcDarkCyan32 = TRColor($FF008B8B);
  rcDarkGoldenRod32 = TRColor($FFB8860B);
  rcDarkGray32 = TRColor($FFA9A9A9);
  rcDarkGreen32 = TRColor($FF006400);
  rcDarkGrey32 = TRColor($FFA9A9A9);
  rcDarkKhaki32 = TRColor($FFBDB76B);
  rcDarkMagenta32 = TRColor($FF8B008B);
  rcDarkOliveGreen32 = TRColor($FF556B2F);
  rcDarkOrange32 = TRColor($FFFF8C00);
  rcDarkOrchid32 = TRColor($FF9932CC);
  rcDarkRed32 = TRColor($FF8B0000);
  rcDarkSalmon32 = TRColor($FFE9967A);
  rcDarkSeaGreen32 = TRColor($FF8FBC8F);
  rcDarkSlateBlue32 = TRColor($FF483D8B);
  rcDarkSlateGray32 = TRColor($FF2F4F4F);
  rcDarkSlateGrey32 = TRColor($FF2F4F4F);
  rcDarkTurquoise32 = TRColor($FF00CED1);
  rcDarkViolet32 = TRColor($FF9400D3);
  rcDeepPink32 = TRColor($FFFF1493);
  rcDeepSkyBlue32 = TRColor($FF00BFFF);
  rcDodgerBlue32 = TRColor($FF1E90FF);
  rcFireBrick32 = TRColor($FFB22222);
  rcFloralWhite32 = TRColor($FFFFFAF0);
  rcGainsBoro32 = TRColor($FFDCDCDC);
  rcGhostWhite32 = TRColor($FFF8F8FF);
  rcGold32 = TRColor($FFFFD700);
  rcGoldenRod32 = TRColor($FFDAA520);
  rcGreenYellow32 = TRColor($FFADFF2F);
  rcGrey32 = TRColor($FF808080);
  rcHoneyDew32 = TRColor($FFF0FFF0);
  rcHotPink32 = TRColor($FFFF69B4);
  rcIndianRed32 = TRColor($FFCD5C5C);
  rcIndigo32 = TRColor($FF4B0082);
  rcIvory32 = TRColor($FFFFFFF0);
  rcKhaki32 = TRColor($FFF0E68C);
  rcLavender32 = TRColor($FFE6E6FA);
  rcLavenderBlush32 = TRColor($FFFFF0F5);
  rcLawnGreen32 = TRColor($FF7CFC00);
  rcLemonChiffon32 = TRColor($FFFFFACD);
  rcLightBlue32 = TRColor($FFADD8E6);
  rcLightCoral32 = TRColor($FFF08080);
  rcLightCyan32 = TRColor($FFE0FFFF);
  rcLightGoldenRodYellow32 = TRColor($FFFAFAD2);
  rcLightGreen32 = TRColor($FF90EE90);
  rcLightGrey32 = TRColor($FFD3D3D3);
  rcLightPink32 = TRColor($FFFFB6C1);
  rcLightSalmon32 = TRColor($FFFFA07A);
  rcLightSeagreen32 = TRColor($FF20B2AA);
  rcLightSkyblue32 = TRColor($FF87CEFA);
  rcLightSlategray32 = TRColor($FF778899);
  rcLightSlategrey32 = TRColor($FF778899);
  rcLightSteelblue32 = TRColor($FFB0C4DE);
  rcLightYellow32 = TRColor($FFFFFFE0);
  rcLtGray32 = TRColor($FFC0C0C0);
  rcMedGray32 = TRColor($FFA0A0A4);
  rcDkGray32 = TRColor($FF808080);
  rcMoneyGreen32 = TRColor($FFC0DCC0);
  rcLegacySkyBlue32 = TRColor($FFA6CAF0);
  rcCream32 = TRColor($FFFFFBF0);
  rcLimeGreen32 = TRColor($FF32CD32);
  rcLinen32 = TRColor($FFFAF0E6);
  rcMediumAquamarine32 = TRColor($FF66CDAA);
  rcMediumBlue32 = TRColor($FF0000CD);
  rcMediumOrchid32 = TRColor($FFBA55D3);
  rcMediumPurple32 = TRColor($FF9370DB);
  rcMediumSeaGreen32 = TRColor($FF3CB371);
  rcMediumSlateBlue32 = TRColor($FF7B68EE);
  rcMediumSpringGreen32 = TRColor($FF00FA9A);
  rcMediumTurquoise32 = TRColor($FF48D1CC);
  rcMediumVioletRed32 = TRColor($FFC71585);
  rcMidnightBlue32 = TRColor($FF191970);
  rcMintCream32 = TRColor($FFF5FFFA);
  rcMistyRose32 = TRColor($FFFFE4E1);
  rcMoccasin32 = TRColor($FFFFE4B5);
  rcNavajoWhite32 = TRColor($FFFFDEAD);
  rcOldLace32 = TRColor($FFFDF5E6);
  rcOliveDrab32 = TRColor($FF6B8E23);
  rcOrange32 = TRColor($FFFFA500);
  rcOrangeRed32 = TRColor($FFFF4500);
  rcOrchid32 = TRColor($FFDA70D6);
  rcPaleGoldenRod32 = TRColor($FFEEE8AA);
  rcPaleGreen32 = TRColor($FF98FB98);
  rcPaleTurquoise32 = TRColor($FFAFEEEE);
  rcPaleVioletred32 = TRColor($FFDB7093);
  rcPapayaWhip32 = TRColor($FFFFEFD5);
  rcPeachPuff32 = TRColor($FFFFDAB9);
  rcPeru32 = TRColor($FFCD853F);
  rcPlum32 = TRColor($FFDDA0DD);
  rcPowderBlue32 = TRColor($FFB0E0E6);
  rcRosyBrown32 = TRColor($FFBC8F8F);
  rcRoyalBlue32 = TRColor($FF4169E1);
  rcSaddleBrown32 = TRColor($FF8B4513);
  rcSalmon32 = TRColor($FFFA8072);
  rcSandyBrown32 = TRColor($FFF4A460);
  rcSeaGreen32 = TRColor($FF2E8B57);
  rcSeaShell32 = TRColor($FFFFF5EE);
  rcSienna32 = TRColor($FFA0522D);
  rcSilver32 = TRColor($FFC0C0C0);
  rcSkyblue32 = TRColor($FF87CEEB);
  rcSlateBlue32 = TRColor($FF6A5ACD);
  rcSlateGray32 = TRColor($FF708090);
  rcSlateGrey32 = TRColor($FF708090);
  rcSnow32 = TRColor($FFFFFAFA);
  rcSpringgreen32 = TRColor($FF00FF7F);
  rcSteelblue32 = TRColor($FF4682B4);
  rcTan32 = TRColor($FFD2B48C);
  rcThistle32 = TRColor($FFD8BFD8);
  rcTomato32 = TRColor($FFFF6347);
  rcTurquoise32 = TRColor($FF40E0D0);
  rcViolet32 = TRColor($FFEE82EE);
  rcWheat32 = TRColor($FFF5DEB3);
  rcWhitesmoke32 = TRColor($FFF5F5F5);
  rcYellowgreen32 = TRColor($FF9ACD32);
  rcTrWhite32 = TRColor($7FFFFFFF);
  rcTrGray32 = TRColor($7F7F7F7F);
  rcTrBlack32 = TRColor($7F000000);
  rcTrRed32 = TRColor($7FFF0000);
  rcTrGreen32 = TRColor($7F00FF00);
  rcTrBlue32 = TRColor($7F0000FF);
{$ENDREGION 'Constant'}
{$REGION 'Var'}


var
  NewPasAI_Raster: function: TMPasAI_Raster;
  NewPasAI_RasterFromFile: function(const fn: string): TMPasAI_Raster;
  NewPasAI_RasterFromStream: function(const stream: TCore_Stream): TMPasAI_Raster;
  SavePasAI_Raster: procedure(mr: TMPasAI_Raster; const fn: string);

  {
    Morphology Convolution Kernel
  }
  Bin3x3, Bin5x5, Bin7x7, Bin9x9, Bin11x11, Bin13x13, Bin15x15, Bin17x17, Bin19x19, Bin21x21, Bin23x23, Bin25x25, Bin51x51, Bin99x99: TMorphologyBinaryzation;

  {
    Rastermization Serialized instance Pool
  }
  RasterSerialized_Instance_Pool: TRasterSerialized_Instance_Pool;

  {
    Color Table
  }
  Color255: array [Byte] of TRColor;
  Color64K: array [Word] of TRColor;

  {
    Fill BlackGray Background color
  }
  FBGB_bkColor, FBGB_color1, FBGB_color2: TRColor;

{$ENDREGION 'Var'}

implementation

uses PasAI.h264.Common, PasAI.Compress, PasAI.Status, PasAI.DFE, PasAI.MemoryRaster.JPEG, PasAI.Raster.PNG, PasAI.Expression, PasAI.OpCode, PasAI.DrawEngine;

{$REGION 'InternalDefines'}


type
  TLUT8 = array [Byte] of Byte;
  TLogicalOperator = (loXOR, loAND, loOR);

  TByteArray = array [0 .. MaxInt div SizeOf(Byte) - 1] of Byte;
  PByteArray = ^TByteArray;

  TBmpHeader = packed record
    bfType: Word;
    bfSize: Integer;
    bfReserved1: Word;
    bfReserved2: Word;
    bfOffBits: Integer;
    biSize: Integer;
    biWidth: Integer;
    biHeight: Integer;
    biPlanes: Word;
    biBitCount: Word;
    biCompression: Integer;
    biSizeImage: Integer;
    biXPelsPerMeter: Integer;
    biYPelsPerMeter: Integer;
    biClrUsed: Integer;
    biClrImportant: Integer;
  end;

  TYV12Head = packed record
    Version: Byte;
    Compessed: Byte;
    Width: Integer;
    Height: Integer;
  end;

  TBlendLine = procedure(Src, Dst: PRColor; Count: Integer);
  TBlendLineEx = procedure(Src, Dst: PRColor; Count: Integer; M: TRColor);

  TPasAI_RasterSerializedHeader = packed record
    Width, Height: Integer;
    siz: Int64;
    UsedAGG: Boolean;
    Pixel: TRasterSerialized_Pixel_Model;
  end;

  TAtomFontPasAI_Raster = TAtomVar<TFontPasAI_Raster>;

const
  ZERO_RECT: TRect = (Left: 0; Top: 0; Right: 0; Bottom: 0);

var
  RcTable: array [Byte, Byte] of Byte;
  DivTable: array [Byte, Byte] of Byte;
  SystemFont: TAtomFontPasAI_Raster;

{$ENDREGION 'InternalDefines'}

function IntersectRect_(out Dst: TRect; const r1, r2: TRect): Boolean; forward;
procedure OffsetRect_(var R: TRect; dx, dy: Integer); forward;
function IsRectEmpty_(const R: TRect): Boolean; forward;

{$I PasAI.MemoryRaster.SigmaGaussian.inc}
{$I PasAI.MemoryRaster.RasterClass.inc}
{$I PasAI.MemoryRaster.Agg.inc}
{$I PasAI.MemoryRaster.API.inc}
{$I PasAI.MemoryRaster.SequenceClass.inc}
{$I PasAI.MemoryRaster.Vertex.inc}
{$I PasAI.MemoryRaster.Font.inc}
{$I PasAI.MemoryRaster.Morphomatics.inc}
{$I PasAI.MemoryRaster.MorphologyBinaryzation.inc}
{$I PasAI.MemoryRaster.MorphologySegmentation.inc}
{$I PasAI.MemoryRaster.MorphologyRCLines.inc}

{$REGION 'Intf'}


function NewPasAI_Raster_: TMPasAI_Raster;
begin
  Result := TMPasAI_Raster.Create;
end;

function NewPasAI_RasterFromFile_(const fn: string): TMPasAI_Raster;
begin
  Result := NewPasAI_Raster();
  Result.LoadFromFile(fn);
end;

function NewPasAI_RasterFromStream_(const stream: TCore_Stream): TMPasAI_Raster;
var
  m64: TMS64;
begin
  Result := NewPasAI_Raster();

  stream.Position := 0;
  m64 := TMS64.Create;
  if stream is TMS64 then
      m64.SetPointerWithProtectedMode(TMS64(stream).Memory, TMS64(stream).Size)
  else
      m64.CopyFrom(stream, stream.Size);
  m64.Position := 0;

  try
      Result.LoadFromStream(m64);
  except
      Result.Reset();
  end;

  disposeObject(m64);
end;

procedure SavePasAI_Raster_(mr: TMPasAI_Raster; const fn: string);
begin
  mr.SaveToFile(fn);
end;

function New_Custom_Raster(W, H: Integer; ClearColor: TRColor): TMPasAI_Raster;
begin
  Result := NewPasAI_Raster();
  Result.SetSize(W, H, ClearColor);
end;

{$ENDREGION 'Intf'}


initialization

TMPasAI_Raster.Parallel := {$IFDEF MemoryRaster_Parallel}True{$ELSE MemoryRaster_Parallel}False{$ENDIF MemoryRaster_Parallel};
TPasAI_RasterVertex.DebugTriangle := False;
TPasAI_RasterVertex.DebugTriangleColor := RColor($FF, $7F, $7F, $7F);
TPasAI_RasterVertex.Parallel := {$IFDEF Vertex_Parallel}True{$ELSE Vertex_Parallel}False{$ENDIF Vertex_Parallel};
TPasAI_RasterVertex.ParallelHeightTrigger := 300;
TPasAI_RasterVertex.ParallelWidthTrigger := 300;
TMorphomatics.Parallel := {$IFDEF Morphomatics_Parallel}True{$ELSE Morphomatics_Parallel}False{$ENDIF Morphomatics_Parallel};
TMorphologyBinaryzation.Parallel := {$IFDEF MorphologyBinaryzation_Parallel}True{$ELSE MorphologyBinaryzation_Parallel}False{$ENDIF MorphologyBinaryzation_Parallel};

NewPasAI_Raster := NewPasAI_Raster_;
NewPasAI_RasterFromFile := NewPasAI_RasterFromFile_;
NewPasAI_RasterFromStream := NewPasAI_RasterFromStream_;
SavePasAI_Raster := SavePasAI_Raster_;

MakeMergeTables;
Init_DefaultFont;
InitBinaryzationPreset;
RasterSerialized_Instance_Pool := TRasterSerialized_Instance_Pool.Create;

FillColorTable(3, 3, 2, $FF, @Color255);
FillColorTable(6, 5, 5, $FFFF, @Color64K);

FBGB_bkColor := RColor(28, 28, 28);
FBGB_color1 := RColor(33, 33, 33);
FBGB_color2 := RColor(38, 38, 38);

finalization

disposeObject(RasterSerialized_Instance_Pool);
Free_DefaultFont;
FreeBinaryzationPreset;

end.
