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
{ * machine Learn                                                              * }
{ ****************************************************************************** }
unit PasAI.Learn;

{$DEFINE FPC_DELPHI_MODE}
{$I PasAI.Define.inc}

interface

uses Math, PasAI.Core,
{$IFDEF FPC}
  PasAI.FPC.GenericList,
{$ENDIF FPC}
  PasAI.UnicodeMixedLib, PasAI.PascalStrings, PasAI.UPascalStrings, PasAI.MemoryStream, PasAI.DFE, PasAI.Notify,
  PasAI.Geometry2D, PasAI.Geometry3D, PasAI.ListEngine, PasAI.HashList.Templet,
  PasAI.Learn.KDTree, PasAI.Learn.Type_LIB;

{$REGION 'Class'}


type
  TLearn = class;

  TLearn_BigList = TBig_Object_List<TLearn>;

  TLearnState_C = procedure(const LSender: TLearn; const State: Boolean);
  TLearnState_M = procedure(const LSender: TLearn; const State: Boolean) of object;
{$IFDEF FPC}
  TLearnState_P = procedure(const LSender: TLearn; const State: Boolean) is nested;
{$ELSE FPC}
  TLearnState_P = reference to procedure(const LSender: TLearn; const State: Boolean);
{$ENDIF FPC}
  PLearnMemory = ^TLearnMemory;
  TLearn_Memory_Pool = TGenericsList<PLearnMemory>;

  TLearnMemory = record
    m_in, m_out: TLVec;
    token: TPascalString;
    data: TPascalString;
  end;

  TCandidate_Distance_ = record
    Index_: TLInt;
    Memory_: PLearnMemory;
    Distance_: TLFloat;
  end;

  PCandidate_Distance_ = ^TCandidate_Distance_;
  TCandidate_Distance_Array = array of TCandidate_Distance_;
  TCandidate_Distance_Matrix = array of TCandidate_Distance_Array;

  TCandidate_Distance_Pool_ = TBigList<PCandidate_Distance_>;

  TCandidate_Distance_Pool = class(TCandidate_Distance_Pool_)
  private
    Max_Distance_Cache, Min_Distance_Cache, Sum_Cache: TLFloat;
    procedure Do_Build_Min_Max_Sum_Cache;
  public
    Name: U_String;
    Weight: TLFloat;
    Min_Distance_Ptr, Max_Distance_Ptr: PCandidate_Distance_;
    constructor Create;
    procedure DoFree(var data: PCandidate_Distance_); override;
    procedure DoAdd(var data: PCandidate_Distance_); override;
    function Max_Distance: TLFloat;
    function Min_Distance: TLFloat;
    function Distance_Sum: TLFloat;
    function Distance_Mean: TLFloat;
    function Distance_Weight_Mean: TLFloat;
    function Distance_Regression: TLFloat;
  end;

  TCandidate_Distance_Hash_Pool_Decl = TPascalString_Big_Hash_Pair_Pool<TCandidate_Distance_Pool>;

  TCandidate_Distance_Hash_Pool = class(TCandidate_Distance_Hash_Pool_Decl)
  private
    Memory_Buffer: array of TLearnMemory;
  private
    function Do_Sort_(var Left, Right: TCandidate_Distance_Hash_Pool_Decl.PPair_Pool_Value__): Integer;
    function Do_Inv_Sort_(var Left, Right: TCandidate_Distance_Hash_Pool_Decl.PPair_Pool_Value__): Integer;
    function Do_Sort_Min_Distance_(var Left, Right: TCandidate_Distance_Hash_Pool_Decl.PPair_Pool_Value__): Integer;
    function Do_Sort_Max_Distance_(var Left, Right: TCandidate_Distance_Hash_Pool_Decl.PPair_Pool_Value__): Integer;
  public
    Buff: TCandidate_Distance_Array;
    constructor Create_New_Instance(pool_: TCandidate_Distance_Hash_Pool; free_pool_: Boolean);
    constructor Create(Buff_: TCandidate_Distance_Array; Filter_Min_, Filter_Max_: TLFloat); overload;
    constructor Create(Matrix_: TCandidate_Distance_Matrix; Filter_Min_, Filter_Max_: TLFloat); overload;
    destructor Destroy; override;
    procedure Add_Candidate_Distance_Info(p: PCandidate_Distance_);
    procedure GetKeyList(output: TPascalStringList);
    procedure DoFree(var Key: TPascalString; var Value: TCandidate_Distance_Pool); override;
    procedure MergeFrom(source: TCandidate_Distance_Hash_Pool);
    procedure MergeTo(dest: TCandidate_Distance_Hash_Pool);
    function Get_Min_Mean_Pool(): TCandidate_Distance_Pool;
    function Get_Max_Mean_Pool(): TCandidate_Distance_Pool;
    function Get_Min_Distance_Pool(): TCandidate_Distance_Pool;
    function Get_Max_Distance_Pool(): TCandidate_Distance_Pool;
    procedure Compute_Weight;
    procedure Sort_Mean();
    procedure Inv_Sort_Mean();
    procedure Sort_Min_Distance();
    procedure Sort_Max_Distance();
  end;

  TLearnKDT = record
    K: TKDTree;
  end;

  PLearnKDT = ^TLearnKDT;
  THideLayerDepth = (hld0, hld1, hld2);

  TLearn = class(TCore_InterfacedObject_Intermediate)
  private
    FRandomNumber: Boolean;
    FInSize, FOutSize: TLInt;
    FMemorySource: TLearn_Memory_Pool;
    FTokenCache: THashList;
    FKDToken: TKDTree;
    FLearnType: TLearnType;
    FLearnData: Pointer;
    FClassifier: Boolean;
    FHideLayerDepth: THideLayerDepth;
    FLastTrainMaxInValue, FLastTrainMaxOutValue: TLFloat;
    FInfo: TPascalString;
    FIsTraining: Boolean;
    FTrainingThreadRuning: Boolean;
    FUserData: Pointer;
    FUserObject: TCore_Object;

    procedure KDInput(const IndexFor: NativeInt; var source: TKDTree_Source; const data: Pointer);
    procedure TokenInput(const IndexFor: NativeInt; var source: TKDTree_Source; const data: Pointer);

    procedure FreeLearnData;
    procedure CreateLearnData(const isTrainingTime: Boolean);
  public
    { regression style }
    class function CreateRegression(const lt: TLearnType; const InDataLen, OutDataLen: TLInt): TLearn;
    { regression style of level 1 }
    class function CreateRegression1(const lt: TLearnType; const InDataLen, OutDataLen: TLInt): TLearn;
    { regression style of level 2 }
    class function CreateRegression2(const lt: TLearnType; const InDataLen, OutDataLen: TLInt): TLearn;

    { classifier style }
    class function CreateClassifier(const lt: TLearnType; const InDataLen: TLInt): TLearn;
    { classifier style of level 1 }
    class function CreateClassifier1(const lt: TLearnType; const InDataLen: TLInt): TLearn;
    { classifier style of level 2 }
    class function CreateClassifier2(const lt: TLearnType; const InDataLen: TLInt): TLearn;

    constructor Create; virtual;
    destructor Destroy; override;

    { * random number * }
    property RandomNumber: Boolean read FRandomNumber write FRandomNumber;

    { * clear * }
    procedure Clear;

    { * parameter * }
    function Count: TLInt;
    property InSize: TLInt read FInSize;
    property OutSize: TLInt read FOutSize;
    property LearnType: TLearnType read FLearnType;
    property Info: TPascalString read FInfo;
    property TrainingThreadRuning: Boolean read FTrainingThreadRuning;
    function GetMemorySource(const index: TLInt): PLearnMemory;
    property MemorySource[const index: TLInt]: PLearnMemory read GetMemorySource; default;
    property LastTrainMaxInValue: TLFloat read FLastTrainMaxInValue;
    property LastTrainMaxOutValue: TLFloat read FLastTrainMaxOutValue;

    { * user parameter * }
    property UserData: Pointer read FUserData write FUserData;
    property UserObject: TCore_Object read FUserObject write FUserObject;

    { * sampler * }
    function Search_Same_Memory_In(f_In: TLVec): PLearnMemory;
    function Search_Same_Memory_Out(f_Out: TLVec): PLearnMemory;
    function Search_Min_Memory_In(f_In: TLVec; var K: TLFloat): PLearnMemory;
    function Search_Min_Memory_Out(f_Out: TLVec; var K: TLFloat): PLearnMemory;
    function AddMemory(const f_In, f_Out: TLVec; f_token, f_data: TPascalString): PLearnMemory; overload;
    function AddMemory(const f_In, f_Out: TLVec; f_token: TPascalString): PLearnMemory; overload;
    function AddMemory(const f_In: TLVec; f_token, f_data: TPascalString): PLearnMemory; overload;
    function AddMemory(const f_In: TLVec; f_token: TPascalString): PLearnMemory; overload;
    function AddMemory(const f_In, f_Out: TLVec): PLearnMemory; overload;
    function AddMemory(const s_In, s_Out: TPascalString): PLearnMemory; overload;
    function AddMemory(const s_In, s_Out, s_token: TPascalString): PLearnMemory; overload;
    function AddMemory(const s: TPascalString): PLearnMemory; overload;
    procedure AddSampler(const f_In, f_Out: TLVec); overload;
    procedure AddSampler(const s_In, s_Out: TPascalString); overload;
    procedure AddSampler(const s: TPascalString); overload;
    procedure AddMatrix(const m_in: TLMatrix; const f_Out: TLVec); overload;
    procedure AddMatrix(const m_in: TLMatrix; const f_Out: TLVec; const f_token: TPascalString); overload;

    { * KDTree * }
    procedure AddKDTree(kd: TKDTreeDataList);

    { * normal Training * }
    function Training(const TrainDepth: TLInt): Boolean; overload;
    function Training: Boolean; overload;
    { * Training with thread * }
    procedure Training_MT; overload;
    procedure Training_MT(const TrainDepth: TLInt); overload;
    procedure TrainingC(const TrainDepth: TLInt; const OnResult: TLearnState_C);
    procedure TrainingM(const TrainDepth: TLInt; const OnResult: TLearnState_M);
    procedure TrainingP(const TrainDepth: TLInt; const OnResult: TLearnState_P);

    { wait thread }
    procedure WaitTraining;

    { token }
    function SearchToken(const v: TLVec): TPascalString;
    function SearchOutVecToken(const v: TLVec): TPascalString;
    function FindTokenIndex(const token_: TPascalString): TLInt;
    function FindTokenData(const token_: TPascalString): PLearnMemory;

    { data input/output }
    function Process(const p_in, p_out: PLVec): Boolean; overload;
    function Process(const ProcessIn: PLVec): TPascalString; overload;
    function Process(const ProcessIn: TLVec): TPascalString; overload;
    function Process(const ProcessIn: TPascalString): TPascalString; overload;
    function ProcessToken(const ProcessIn: PLVec): TPascalString; overload;
    function ProcessToken(const ProcessIn: TLVec): TPascalString; overload;

    { result max value }
    function ProcessMax(const ProcessIn: TLVec): TLFloat;
    function ProcessMaxToken(const ProcessIn: TLVec): TPascalString;

    { result max index }
    function ProcessMaxIndex(const ProcessIn: TLVec): TLInt; overload;
    function ProcessMaxIndexToken(const ProcessIn: TLVec): TPascalString; overload;
    function ProcessMaxIndexCandidate(const ProcessIn: TLVec): TLIVec; overload;
    function ProcessMaxIndexCandidate_Arry(const ProcessIn: TLVec): TCandidate_Distance_Array; overload;
    function ProcessMaxIndexCandidate_Arry(const Matrix_: TLMatrix): TCandidate_Distance_Matrix; overload;
    function ProcessMaxIndexCandidate_Arry_ByOptimized(const ProcessIn: TLVec; MinK_: TLFloat): TCandidate_Distance_Array; overload;
    function ProcessMaxIndexCandidate_Arry_ByOptimized(const Matrix_: TLMatrix; MinK_: TLFloat): TCandidate_Distance_Matrix; overload;
    function ProcessMaxIndexCandidate_Arry_ByOptimized(const ProcessIn: TLVec; Filter_Min_, Filter_Max_: TLFloat): TCandidate_Distance_Hash_Pool; overload;
    function ProcessMaxIndexCandidate_Arry_ByOptimized(const Matrix_: TLMatrix; Filter_Min_, Filter_Max_: TLFloat): TCandidate_Distance_Hash_Pool; overload;
    function ProcessMaxIndexCandidate_Pool(const ProcessIn: TLVec; Filter_Min_, Filter_Max_: TLFloat): TCandidate_Distance_Hash_Pool; overload;
    function ProcessMaxIndexCandidate_Pool(const Matrix_: TLMatrix; Filter_Min_, Filter_Max_: TLFloat): TCandidate_Distance_Hash_Pool; overload;

    { result min value }
    function ProcessMin(const ProcessIn: TLVec): TLFloat; overload;
    function ProcessMinToken(const ProcessIn: TLVec): TPascalString; overload;

    { result min index }
    function ProcessMinIndex(const ProcessIn: TLVec): TLInt; overload;
    function ProcessMinIndexToken(const ProcessIn: TLVec): TPascalString; overload;
    function ProcessMinIndexCandidate(const ProcessIn: TLVec): TLIVec; overload;
    function ProcessMinIndexCandidate_Arry(const ProcessIn: TLVec): TCandidate_Distance_Array; overload;
    function ProcessMinIndexCandidate_Arry(const Matrix_: TLMatrix): TCandidate_Distance_Matrix; overload;
    function ProcessMinIndexCandidate_Pool(const ProcessIn: TLVec; Filter_Min_, Filter_Max_: TLFloat): TCandidate_Distance_Hash_Pool; overload;
    function ProcessMinIndexCandidate_Pool(const Matrix_: TLMatrix; Filter_Min_, Filter_Max_: TLFloat): TCandidate_Distance_Hash_Pool; overload;

    { result first value }
    function ProcessFV(const ProcessIn: TLVec): TLFloat; overload;
    function ProcessFV(const ProcessIn: TPascalString): TLFloat; overload;

    { result last value }
    function ProcessLV(const ProcessIn: TLVec): TLFloat; overload;
    function ProcessLV(const ProcessIn: TPascalString): TLFloat; overload;

    { search with Pearson }
    function SearchMemoryPearson(const ProcessIn: TLVec): TLInt; overload;
    procedure SearchMemoryPearson(const ProcessIn: TLVec; out List: TLIVec); overload;

    { search with Spearman }
    function SearchMemorySpearman(const ProcessIn: TLVec): TLInt; overload;
    procedure SearchMemorySpearman(const ProcessIn: TLVec; out List: TLIVec); overload;

    { search with euclidean metric:K }
    function SearchMemoryDistance(const ProcessIn: TLVec): TLInt; overload;
    procedure SearchMemoryDistance(const ProcessIn: TLVec; out List: TLIVec); overload;
    procedure SearchMemoryDistance(const ProcessIn: TLVec; out List: TLIVec; out K_: TLVec); overload;
    procedure SearchMemoryDistance_ByOptimized(const ProcessIn: TLVec; const Mink: TLFloat; out output: TCandidate_Distance_Array); overload;
    procedure SearchMemoryDistance_ByOptimized(const Matrix_: TLMatrix; const Mink: TLFloat; out output: TCandidate_Distance_Matrix); overload;

    { fast serarch Nearest-K, type=ltKDT }
    function Internal_KDTree(): TKDTree;
    function Fast_Search_Nearest_K(const ProcessIn: TLVec): TLInt; overload;
    function Fast_Search_Nearest_K(const ProcessIn: TLVec; var Searched_Min_Distance: Double): TLInt; overload;
    function Fast_Search_Nearest_K(const ProcessIn: TLVec; var Searched_Min_Distance: Double; var Searched_Num: NativeInt): TLInt; overload;
    function Fast_Search_Nearest_K_Candidate(const ProcessIn: TLVec; Filter_Min_, Filter_Max_: TLFloat): TCandidate_Distance_Hash_Pool; overload;
    function Fast_Search_Nearest_K_Candidate(const Matrix_: TLMatrix; Filter_Min_, Filter_Max_: TLFloat): TCandidate_Distance_Hash_Pool; overload;
    function Fast_Search_Nearest_K_Matrix(const Matrix_: TLMatrix): TCandidate_Distance_Array;

    { build input Vector to KDTree }
    function BuildKDTree: TKDTree;
    function BuildKDTree_Cluster(classifierNum_: NativeInt; ResetSeed_: Boolean): TKDTree;

    { build token num analysis }
    function Build_Token_Analysis: TString_Num_Analysis_Tool;

    { fast binary store }
    procedure SaveToDF(df: TDFE);
    procedure LoadFromDF(df: TDFE);

    { store support }
    procedure SaveToStream(stream: TCore_Stream);
    procedure LoadFromStream(stream: TCore_Stream);
    procedure SaveToFile(FileName: TPascalString);
    procedure LoadFromFile(FileName: TPascalString);

    { json support }
    procedure SaveToJsonStream(stream: TCore_Stream);
    procedure LoadFromJsonStream(stream: TCore_Stream);
    procedure SaveToJsonFile(FileName: TPascalString);
    procedure LoadFromJsonFile(FileName: TPascalString);
  end;

  TLearnRandom = class(TMT19937Random)
  public
    property RandReal: TLFloat read RandD;
  end;

{$ENDREGION 'Class'}
{$REGION 'LearnAPI'}


procedure LAdd(var f: TLFloat; const Value: TLFloat); {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
procedure LSub(var f: TLFloat; const Value: TLFloat); {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
procedure LMul(var f: TLFloat; const Value: TLFloat); {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
procedure LDiv(var f: TLFloat; const Value: TLFloat); {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
function LSafeDivF(const s, d: TLFloat): TLFloat; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
procedure LSetVec(var v: TLVec; const VDef: TLFloat); overload;
procedure LSetVec(var v: TLIVec; const VDef: TLInt); overload;
procedure LSetVec(var v: TLBVec; const VDef: Boolean); overload;
procedure LSetMatrix(var M: TLMatrix; const VDef: TLFloat); overload;
procedure LSetMatrix(var M: TLIMatrix; const VDef: TLInt); overload;
procedure LSetMatrix(var M: TLBMatrix; const VDef: Boolean); overload;
function LVecCopy(const v: TLVec): TLVec; overload;
function LVecCopy(const v: TLVec; const index, Count: TLInt): TLVec; overload;
function LVecCopy(const v: TLIVec): TLIVec; overload;
function LVecCopy(const v: TLIVec; const index, Count: TLInt): TLIVec; overload;
function LVecCopy(const v: TLBVec): TLBVec; overload;
function LVecCopy(const v: TLBVec; const index, Count: TLInt): TLBVec; overload;
function LMatrixCopy(const v: TLMatrix): TLMatrix; overload;
function LMatrixCopy(const v: TLIMatrix): TLIMatrix; overload;
function LMatrixCopy(const v: TLBMatrix): TLBMatrix; overload;
function LVecInvert(const v: TLVec): TLVec;
function LIVecInvert(const v: TLIVec): TLIVec;
function LIVec(const s: TPascalString): TLIVec; overload;
function LIVec(const veclen: TLInt; const VDef: TLInt): TLIVec; overload;
function LIVec(const veclen: TLInt): TLIVec; overload;
function LVec(): TLVec; overload;
function LVec(const veclen: TLInt; const VDef: TLFloat): TLVec; overload;
function LVec(const veclen: TLInt): TLVec; overload;
function LVec(const v: TLVec): TPascalString; overload;
function LVec(const M: TLMatrix; const veclen: TLInt): TLVec; overload;
function LVec(const M: TLMatrix): TLVec; overload;
function LVec(const s: TPascalString): TLVec; overload;
function LVec(const s: TPascalString; const veclen: TLInt): TLVec; overload;
function LVec(const v: TLVec; const ShortFloat: Boolean): TPascalString; overload;
function LVec(const M: TLBMatrix; const veclen: TLInt): TLBVec; overload;
function LVec(const M: TLBMatrix): TLBVec; overload;
function LVec(const M: TLIMatrix; const veclen: TLInt): TLIVec; overload;
function LVec(const M: TLIMatrix): TLIVec; overload;
function ExpressionToLVec(const s: TPascalString; const_vl: THashVariantList): TLVec; overload;
function ExpressionToLVec(const s: TPascalString): TLVec; overload;
function ExpLVec(const s: TPascalString; const_vl: THashVariantList): TLVec; overload;
function ExpLVec(const s: TPascalString): TLVec; overload;
function ExpressionToLIVec(const s: TPascalString; const_vl: THashVariantList): TLIVec; overload;
function ExpressionToLIVec(const s: TPascalString): TLIVec; overload;
function ExpLIVec(const s: TPascalString; const_vl: THashVariantList): TLIVec; overload;
function ExpLIVec(const s: TPascalString): TLIVec; overload;
function LSpearmanVec(const M: TLMatrix; const veclen: TLInt): TLVec;
function LAbsMaxVec(const v: TLVec): TLFloat;
function LMaxVec(const v: TLVec): TLFloat; overload;
function LMaxVec(const v: TLIVec): TLInt; overload;
function LMaxVec(const v: TLMatrix): TLFloat; overload;
function LMaxVec(const v: TLIMatrix): TLInt; overload;
function LMinVec(const v: TLVec): TLFloat; overload;
function LMinVec(const v: TLIVec): TLInt; overload;
function LMinVec(const v: TLMatrix): TLFloat; overload;
function LMinVec(const v: TLIMatrix): TLInt; overload;
function LMaxVecIndex(const v: TLVec): TLInt;
function LMinVecIndex(const v: TLVec): TLInt;
function LDistance(const v1, v2: TLVec): TLFloat;
function LMin_Distance(const v1, v2: TLVec): TLFloat; overload;
function LMin_Distance(const v: TLVec; const M: TLMatrix): TLFloat; overload;
function LMin_Distance(const M: TLMatrix; const v: TLVec): TLFloat; overload;
function LMin_Distance(const M1, M2: TLMatrix): TLFloat; overload;
function LHamming(const v1, v2: TLVec): TLInt; overload;
function LHamming(const v1, v2: TLIVec): TLInt; overload;
procedure LClampF(var v: TLFloat; const min_, max_: TLFloat); overload;
procedure LClampI(var v: TLInt; const min_, max_: TLInt); overload;
function LClamp(const v: TLFloat; const min_, max_: TLFloat): TLFloat; overload;
function LClamp(const v: TLInt; const min_, max_: TLInt): TLInt; overload;
function LComplex(X, Y: TLFloat): TLComplex; overload;
function LComplex(f: TLFloat): TLComplex; overload;

{ * sampler support * }
procedure LZoomMatrix(var source, dest: TLMatrix; const DestWidth, DestHeight: TLInt); overload;
procedure LZoomMatrix(var source, dest: TLIMatrix; const DestWidth, DestHeight: TLInt); overload;
procedure LZoomMatrix(var source, dest: TLBMatrix; const DestWidth, DestHeight: TLInt); overload;

{ matrix as stream }
procedure LSaveMatrix(var source: TLMatrix; dest: TCore_Stream); overload;
procedure LLoadMatrix(source: TCore_Stream; var dest: TLMatrix); overload;
procedure LSaveMatrix(var source: TLIMatrix; dest: TCore_Stream); overload;
procedure LLoadMatrix(source: TCore_Stream; var dest: TLIMatrix); overload;
procedure LSaveMatrix(var source: TLBMatrix; dest: TCore_Stream); overload;
procedure LLoadMatrix(source: TCore_Stream; var dest: TLBMatrix); overload;

{ * linear discriminant analysis support * }
function LDA(const M: TLMatrix; const cv: TLVec; const Nclass: TLInt; var sInfo: TPascalString; var output: TLMatrix): Boolean; overload;
function LDA(const M: TLMatrix; const cv: TLVec; const Nclass: TLInt; var sInfo: TPascalString; var output: TLVec): Boolean; overload;
procedure FisherLDAN(const xy: TLMatrix; NPoints: TLInt; NVars: TLInt; NClasses: TLInt; var Info: TLInt; var W: TLMatrix);
procedure FisherLDA(const xy: TLMatrix; NPoints: TLInt; NVars: TLInt; NClasses: TLInt; var Info: TLInt; var W: TLVec);

{ * principal component analysis support * }

(*
  return code:
  * -4, if SVD subroutine haven't converged
  * -1, if wrong parameters has been passed (NPoints<0, NVars<1)
  *  1, if task is solved
*)
function PCA(const Buff: TLMatrix; const NPoints, NVars: TLInt; var v: TLVec; var M: TLMatrix): TLInt; overload;
function PCA(const Buff: TLMatrix; const NPoints, NVars: TLInt; var M: TLMatrix): TLInt; overload;
procedure PCABuildBasis(const X: TLMatrix; NPoints: TLInt; NVars: TLInt; var Info: TLInt; var s2: TLVec; var v: TLMatrix);

{ * k-means++ clusterization support * }
function KMeans(const source: TLMatrix; const NVars, K: TLInt; var KArray: TLMatrix; var kIndex: TLIVec): Boolean;

{ * init Matrix * }
function LMatrix(const L1, l2: TLInt): TLMatrix; overload;
function LBMatrix(const L1, l2: TLInt): TLBMatrix; overload;
function LIMatrix(const L1, l2: TLInt): TLIMatrix; overload;
function ExpressionToLMatrix(W, h: TLInt; const s: TPascalString; const_vl: THashVariantList): TLMatrix; overload;
function ExpressionToLMatrix(W, h: TLInt; const s: TPascalString): TLMatrix; overload;

{ * compute centroid * }
function LMatrix_Centroid(dim: TLInt; M: TLMatrix): TLVec;

{ * compute minimized distance index * }
function Compute_Minimized_Distance_Index_From_LMatrix(v: TLVec; dim: TLInt; M: TLMatrix): TLInt; overload;
function Compute_Minimized_Distance_Index_From_LMatrix(v: TLVec; dim: TLInt; M: TLMatrix; var dist: TLFloat): TLInt; overload;

{ * fast cluster * }
function Auto_Cluster(L: TLearn; var cluster_num: TLInt): TLIVec;
function KMean_Cluster(L: TLearn; cluster_num: TLInt): TLIVec;

{$ENDREGION 'LearnAPI'}
{$REGION 'FloatAPI'}
function AbsReal(X: TLFloat): TLFloat; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
function AbsInt(i: TLInt): TLInt; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
function RandomReal(): TLFloat; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
function RandomInteger(i: TLInt): TLInt; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
function Sign(X: TLFloat): TLInt; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
function AP_Sqr(X: TLFloat): TLFloat; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}

function DynamicArrayCopy(const a: TLIVec): TLIVec; overload;
function DynamicArrayCopy(const a: TLVec): TLVec; overload;
function DynamicArrayCopy(const a: TLComplexVec): TLComplexVec; overload;
function DynamicArrayCopy(const a: TLBVec): TLBVec; overload;

function DynamicArrayCopy(const a: TLIMatrix): TLIMatrix; overload;
function DynamicArrayCopy(const a: TLMatrix): TLMatrix; overload;
function DynamicArrayCopy(const a: TLComplexMatrix): TLComplexMatrix; overload;
function DynamicArrayCopy(const a: TLBMatrix): TLBMatrix; overload;

function AbsComplex(const Z: TLComplex): TLFloat; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
function Conj(const Z: TLComplex): TLComplex; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
function CSqr(const Z: TLComplex): TLComplex; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}

function C_Complex(const X: TLFloat): TLComplex; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
function C_Opposite(const Z: TLComplex): TLComplex; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
function C_Add(const z1: TLComplex; const z2: TLComplex): TLComplex; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
function C_Mul(const z1: TLComplex; const z2: TLComplex): TLComplex; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
function C_AddR(const z1: TLComplex; const r: TLFloat): TLComplex; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
function C_MulR(const z1: TLComplex; const r: TLFloat): TLComplex; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
function C_Sub(const z1: TLComplex; const z2: TLComplex): TLComplex; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
function C_SubR(const z1: TLComplex; const r: TLFloat): TLComplex; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
function C_RSub(const r: TLFloat; const z1: TLComplex): TLComplex; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
function C_Div(const z1: TLComplex; const z2: TLComplex): TLComplex; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
function C_DivR(const z1: TLComplex; const r: TLFloat): TLComplex; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
function C_RDiv(const r: TLFloat; const z2: TLComplex): TLComplex; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
function C_Equal(const z1: TLComplex; const z2: TLComplex): Boolean; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
function C_NotEqual(const z1: TLComplex; const z2: TLComplex): Boolean; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
function C_EqualR(const z1: TLComplex; const r: TLFloat): Boolean; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
function C_NotEqualR(const z1: TLComplex; const r: TLFloat): Boolean; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}

function APVDotProduct(v1: PLFloat; i11, i12: TLInt; v2: PLFloat; i21, i22: TLInt): TLFloat;
procedure APVMove(VDst: PLFloat; i11, i12: TLInt; vSrc: PLFloat; i21, i22: TLInt); overload;
procedure APVMove(VDst: PLFloat; i11, i12: TLInt; vSrc: PLFloat; i21, i22: TLInt; s: TLFloat); overload;
procedure APVMoveNeg(VDst: PLFloat; i11, i12: TLInt; vSrc: PLFloat; i21, i22: TLInt);
procedure APVAdd(VDst: PLFloat; i11, i12: TLInt; vSrc: PLFloat; i21, i22: TLInt); overload;
procedure APVAdd(VDst: PLFloat; i11, i12: TLInt; vSrc: PLFloat; i21, i22: TLInt; s: TLFloat); overload;
procedure APVSub(VDst: PLFloat; i11, i12: TLInt; vSrc: PLFloat; i21, i22: TLInt); overload;
procedure APVSub(VDst: PLFloat; i11, i12: TLInt; vSrc: PLFloat; i21, i22: TLInt; s: TLFloat); overload;
procedure APVMul(VOp: PLFloat; i1, i2: TLInt; s: TLFloat);
procedure APVFillValue(VOp: PLFloat; i1, i2: TLInt; s: TLFloat);

function AP_Float(X: TLFloat): TLFloat; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
function AP_FP_Eq(X: TLFloat; Y: TLFloat): Boolean; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
function AP_FP_NEq(X: TLFloat; Y: TLFloat): Boolean; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
function AP_FP_Less(X: TLFloat; Y: TLFloat): Boolean; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
function AP_FP_Less_Eq(X: TLFloat; Y: TLFloat): Boolean; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
function AP_FP_Greater(X: TLFloat; Y: TLFloat): Boolean; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
function AP_FP_Greater_Eq(X: TLFloat; Y: TLFloat): Boolean; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}

procedure TagSort(var a: TLVec; const N: TLInt; var p1: TLIVec; var p2: TLIVec);
procedure TagSortFastI(var a: TLVec; var b: TLIVec; N: TLInt);
procedure TagSortFastR(var a: TLVec; var b: TLVec; N: TLInt);
procedure TagSortFast(var a: TLVec; const N: TLInt);
procedure TagHeapPushI(var a: TLVec; var b: TLIVec; var N: TLInt; const VA: TLFloat; const VB: TLInt);
procedure TagHeapReplaceTopI(var a: TLVec; var b: TLIVec; const N: TLInt; const VA: TLFloat; const VB: TLInt);
procedure TagHeapPopI(var a: TLVec; var b: TLIVec; var N: TLInt);

(* ************************************************************************
  More precise dot-product. Absolute error of  subroutine  result  is  about
  1 ulp of max(MX,V), where:
  MX = max( |a[i]*b[i]| )
  V  = |(a,b)|

  INPUT PARAMETERS
  A       -   array[0..N-1], vector 1
  B       -   array[0..N-1], vector 2
  N       -   vectors length, N<2^29.
  Temp    -   array[0..N-1], pre-allocated temporary storage

  OUTPUT PARAMETERS
  R       -   (A,B)
  RErr    -   estimate of error. This estimate accounts for both  errors
  during  calculation  of  (A,B)  and  errors  introduced by
  rounding of A and B to fit in TLFloat (about 1 ulp).
  ************************************************************************ *)
procedure XDot(const a: TLVec; const b: TLVec; N: TLInt; var Temp: TLVec; var r: TLFloat; var RErr: TLFloat); {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}

(* ************************************************************************
  Internal subroutine for extra-precise calculation of SUM(w[i]).

  INPUT PARAMETERS:
  W   -   array[0..N-1], values to be added W is modified during calculations.
  MX  -   max(W[i])
  N   -   array size

  OUTPUT PARAMETERS:
  R   -   SUM(w[i])
  RErr-   error estimate for R
  ************************************************************************ *)
procedure XSum(var W: TLVec; mx: TLFloat; N: TLInt; var r: TLFloat; var RErr: TLFloat); {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}

(* ************************************************************************
  Fast Pow
  ************************************************************************ *)
function XFastPow(r: TLFloat; N: TLInt): TLFloat; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}

{$ENDREGION 'FloatAPI'}
{$REGION 'BaseMatrix'}
{ matrix base }
function VectorNorm2(const X: TLVec; const i1, i2: TLInt): TLFloat; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
function VectorIdxAbsMax(const X: TLVec; const i1, i2: TLInt): TLInt; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
function ColumnIdxAbsMax(const X: TLMatrix; const i1, i2, j: TLInt): TLInt; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
function RowIdxAbsMax(const X: TLMatrix; const j1, j2, i: TLInt): TLInt; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}
function UpperHessenberg1Norm(const a: TLMatrix; const i1, i2, j1, j2: TLInt; var Work: TLVec): TLFloat; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}

procedure CopyMatrix(const a: TLMatrix; const IS1, IS2, JS1, JS2: TLInt;
  var b: TLMatrix; const ID1, id2, JD1, JD2: TLInt); {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}

procedure InplaceTranspose(var a: TLMatrix; const i1, i2, j1, j2: TLInt; var Work: TLVec); {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}

procedure CopyAndTranspose(const a: TLMatrix; IS1, IS2, JS1, JS2: TLInt;
  var b: TLMatrix; ID1, id2, JD1, JD2: TLInt); {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}

procedure MatrixVectorMultiply(const a: TLMatrix; const i1, i2, j1, j2: TLInt; const Trans: Boolean;
  const X: TLVec; const IX1, IX2: TLInt; const alpha: TLFloat;
  var Y: TLVec; const IY1, IY2: TLInt; const beta: TLFloat); {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}

function Pythag2(X: TLFloat; Y: TLFloat): TLFloat; {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}

procedure MatrixMatrixMultiply(const a: TLMatrix; const AI1, AI2, AJ1, AJ2: TLInt; const TransA: Boolean;
  const b: TLMatrix; const BI1, BI2, BJ1, BJ2: TLInt; const TransB: Boolean;
  const alpha: TLFloat;
  var c: TLMatrix; const CI1, CI2, CJ1, CJ2: TLInt;
  const beta: TLFloat;
  var Work: TLVec); {$IFDEF INLINE_ASM}inline; {$ENDIF INLINE_ASM}

{ Level 2 and Level 3 BLAS operations }
procedure ABLASSplitLength(const a: TLMatrix; N: TLInt; var n1: TLInt; var n2: TLInt);
procedure ABLASComplexSplitLength(const a: TLComplexMatrix; N: TLInt; var n1: TLInt; var n2: TLInt);
function ABLASBlockSize(const a: TLMatrix): TLInt;
function ABLASComplexBlockSize(const a: TLComplexMatrix): TLInt;
function ABLASMicroBlockSize(): TLInt;
procedure CMatrixTranspose(M: TLInt; N: TLInt; const a: TLComplexMatrix; IA: TLInt; ja: TLInt; var b: TLComplexMatrix; IB: TLInt; JB: TLInt);
procedure RMatrixTranspose(M: TLInt; N: TLInt; const a: TLMatrix; IA: TLInt; ja: TLInt; var b: TLMatrix; IB: TLInt; JB: TLInt);
procedure CMatrixCopy(M: TLInt; N: TLInt; const a: TLComplexMatrix; IA: TLInt; ja: TLInt; var b: TLComplexMatrix; IB: TLInt; JB: TLInt);
procedure RMatrixCopy(M: TLInt; N: TLInt; const a: TLMatrix; IA: TLInt; ja: TLInt; var b: TLMatrix; IB: TLInt; JB: TLInt);
procedure CMatrixRank1(M: TLInt; N: TLInt; var a: TLComplexMatrix; IA: TLInt; ja: TLInt; var U: TLComplexVec; IU: TLInt; var v: TLComplexVec; IV: TLInt);
procedure RMatrixRank1(M: TLInt; N: TLInt; var a: TLMatrix; IA: TLInt; ja: TLInt; var U: TLVec; IU: TLInt; var v: TLVec; IV: TLInt);
procedure CMatrixMV(M: TLInt; N: TLInt; var a: TLComplexMatrix; IA: TLInt; ja: TLInt; OpA: TLInt; var X: TLComplexVec; ix: TLInt; var Y: TLComplexVec; iy: TLInt);
procedure RMatrixMV(M: TLInt; N: TLInt; var a: TLMatrix; IA: TLInt; ja: TLInt; OpA: TLInt; var X: TLVec; ix: TLInt; var Y: TLVec; iy: TLInt);

procedure CMatrixRightTRSM(M: TLInt; N: TLInt;
  const a: TLComplexMatrix; i1: TLInt; j1: TLInt;
  IsUpper: Boolean; IsUnit: Boolean; OpType: TLInt;
  var X: TLComplexMatrix; i2: TLInt; j2: TLInt);

procedure CMatrixLeftTRSM(M: TLInt; N: TLInt;
  const a: TLComplexMatrix; i1: TLInt; j1: TLInt;
  IsUpper: Boolean; IsUnit: Boolean; OpType: TLInt;
  var X: TLComplexMatrix; i2: TLInt; j2: TLInt);

procedure RMatrixRightTRSM(M: TLInt; N: TLInt;
  const a: TLMatrix; i1: TLInt; j1: TLInt; IsUpper: Boolean;
  IsUnit: Boolean; OpType: TLInt; var X: TLMatrix; i2: TLInt; j2: TLInt);

procedure RMatrixLeftTRSM(M: TLInt; N: TLInt;
  const a: TLMatrix; i1: TLInt; j1: TLInt; IsUpper: Boolean;
  IsUnit: Boolean; OpType: TLInt; var X: TLMatrix; i2: TLInt; j2: TLInt);

procedure CMatrixSYRK(N: TLInt; K: TLInt; alpha: TLFloat;
  const a: TLComplexMatrix; IA: TLInt; ja: TLInt; OpTypeA: TLInt;
  beta: TLFloat; var c: TLComplexMatrix; IC: TLInt; JC: TLInt; IsUpper: Boolean);

procedure RMatrixSYRK(N: TLInt; K: TLInt; alpha: TLFloat;
  const a: TLMatrix; IA: TLInt; ja: TLInt; OpTypeA: TLInt;
  beta: TLFloat; var c: TLMatrix; IC: TLInt; JC: TLInt; IsUpper: Boolean);

procedure CMatrixGEMM(M: TLInt; N: TLInt; K: TLInt; alpha: TLComplex;
  const a: TLComplexMatrix; IA: TLInt; ja: TLInt; OpTypeA: TLInt;
  const b: TLComplexMatrix; IB: TLInt; JB: TLInt; OpTypeB: TLInt;
  beta: TLComplex; var c: TLComplexMatrix; IC: TLInt; JC: TLInt);

procedure RMatrixGEMM(M: TLInt; N: TLInt; K: TLInt; alpha: TLFloat;
  const a: TLMatrix; IA: TLInt; ja: TLInt; OpTypeA: TLInt;
  const b: TLMatrix; IB: TLInt; JB: TLInt; OpTypeB: TLInt;
  beta: TLFloat; var c: TLMatrix; IC: TLInt; JC: TLInt);

{ LU and Cholesky decompositions }
procedure RMatrixLU(var a: TLMatrix; M: TLInt; N: TLInt; var Pivots: TLIVec);
procedure CMatrixLU(var a: TLComplexMatrix; M: TLInt; N: TLInt; var Pivots: TLIVec);
function HPDMatrixCholesky(var a: TLComplexMatrix; N: TLInt; IsUpper: Boolean): Boolean;
function SPDMatrixCholesky(var a: TLMatrix; N: TLInt; IsUpper: Boolean): Boolean;
procedure RMatrixLUP(var a: TLMatrix; M: TLInt; N: TLInt; var Pivots: TLIVec);
procedure CMatrixLUP(var a: TLComplexMatrix; M: TLInt; N: TLInt; var Pivots: TLIVec);
procedure RMatrixPLU(var a: TLMatrix; M: TLInt; N: TLInt; var Pivots: TLIVec);
procedure CMatrixPLU(var a: TLComplexMatrix; M: TLInt; N: TLInt; var Pivots: TLIVec);

{ matrix safe }
function RMatrixScaledTRSafeSolve(const a: TLMatrix; SA: TLFloat;
  N: TLInt; var X: TLVec; IsUpper: Boolean; Trans: TLInt;
  IsUnit: Boolean; MaxGrowth: TLFloat): Boolean;

function CMatrixScaledTRSafeSolve(const a: TLComplexMatrix; SA: TLFloat;
  N: TLInt; var X: TLComplexVec; IsUpper: Boolean;
  Trans: TLInt; IsUnit: Boolean; MaxGrowth: TLFloat): Boolean;

{ * Condition number estimate support * }
function RMatrixRCond1(a: TLMatrix; N: TLInt): TLFloat;
function RMatrixRCondInf(a: TLMatrix; N: TLInt): TLFloat;
function SPDMatrixRCond(a: TLMatrix; N: TLInt; IsUpper: Boolean): TLFloat;
function RMatrixTRRCond1(const a: TLMatrix; N: TLInt; IsUpper: Boolean; IsUnit: Boolean): TLFloat;
function RMatrixTRRCondInf(const a: TLMatrix; N: TLInt; IsUpper: Boolean; IsUnit: Boolean): TLFloat;
function HPDMatrixRCond(a: TLComplexMatrix; N: TLInt; IsUpper: Boolean): TLFloat;
function CMatrixRCond1(a: TLComplexMatrix; N: TLInt): TLFloat;
function CMatrixRCondInf(a: TLComplexMatrix; N: TLInt): TLFloat;
function RMatrixLURCond1(const LUA: TLMatrix; N: TLInt): TLFloat;
function RMatrixLURCondInf(const LUA: TLMatrix; N: TLInt): TLFloat;
function SPDMatrixCholeskyRCond(const a: TLMatrix; N: TLInt; IsUpper: Boolean): TLFloat;
function HPDMatrixCholeskyRCond(const a: TLComplexMatrix; N: TLInt; IsUpper: Boolean): TLFloat;
function CMatrixLURCond1(const LUA: TLComplexMatrix; N: TLInt): TLFloat;
function CMatrixLURCondInf(const LUA: TLComplexMatrix; N: TLInt): TLFloat;
function CMatrixTRRCond1(const a: TLComplexMatrix; N: TLInt; IsUpper: Boolean; IsUnit: Boolean): TLFloat;
function CMatrixTRRCondInf(const a: TLComplexMatrix; N: TLInt; IsUpper: Boolean; IsUnit: Boolean): TLFloat;
function RCondThreshold(): TLFloat;

{ Matrix inverse }
procedure RMatrixLUInverse(var a: TLMatrix; const Pivots: TLIVec; N: TLInt; var Info: TLInt; var Rep: TMatInvReport);
procedure RMatrixInverse(var a: TLMatrix; N: TLInt; var Info: TLInt; var Rep: TMatInvReport);
procedure CMatrixLUInverse(var a: TLComplexMatrix; const Pivots: TLIVec; N: TLInt; var Info: TLInt; var Rep: TMatInvReport);
procedure CMatrixInverse(var a: TLComplexMatrix; N: TLInt; var Info: TLInt; var Rep: TMatInvReport);
procedure SPDMatrixCholeskyInverse(var a: TLMatrix; N: TLInt; IsUpper: Boolean; var Info: TLInt; var Rep: TMatInvReport);
procedure SPDMatrixInverse(var a: TLMatrix; N: TLInt; IsUpper: Boolean; var Info: TLInt; var Rep: TMatInvReport);
procedure HPDMatrixCholeskyInverse(var a: TLComplexMatrix; N: TLInt; IsUpper: Boolean; var Info: TLInt; var Rep: TMatInvReport);
procedure HPDMatrixInverse(var a: TLComplexMatrix; N: TLInt; IsUpper: Boolean; var Info: TLInt; var Rep: TMatInvReport);
procedure RMatrixTRInverse(var a: TLMatrix; N: TLInt; IsUpper: Boolean; IsUnit: Boolean; var Info: TLInt; var Rep: TMatInvReport);
procedure CMatrixTRInverse(var a: TLComplexMatrix; N: TLInt; IsUpper: Boolean; IsUnit: Boolean; var Info: TLInt; var Rep: TMatInvReport);

{ matrix rotations }
procedure ApplyRotationsFromTheLeft(IsForward: Boolean; M1: TLInt; M2: TLInt; n1: TLInt; n2: TLInt;
  const c: TLVec; const s: TLVec; var a: TLMatrix; var Work: TLVec);
procedure ApplyRotationsFromTheRight(IsForward: Boolean; M1: TLInt; M2: TLInt; n1: TLInt; n2: TLInt;
  const c: TLVec; const s: TLVec; var a: TLMatrix; var Work: TLVec);
procedure GenerateRotation(f: TLFloat; g: TLFloat; var cs: TLFloat; var sn: TLFloat; var r: TLFloat);

{ Bidiagonal SVD }
function RMatrixBDSVD(var d: TLVec; E: TLVec; N: TLInt; IsUpper: Boolean; IsFractionalAccuracyRequired: Boolean;
  var U: TLMatrix; NRU: TLInt; var c: TLMatrix; NCC: TLInt; var VT: TLMatrix; NCVT: TLInt): Boolean;

function BidiagonalSVDDecomposition(var d: TLVec; E: TLVec; N: TLInt; IsUpper: Boolean; IsFractionalAccuracyRequired: Boolean;
  var U: TLMatrix; NRU: TLInt; var c: TLMatrix; NCC: TLInt; var VT: TLMatrix; NCVT: TLInt): Boolean;

(* ************************************************************************
  Singular value decomposition of a rectangular matrix.

  The algorithm calculates the singular value decomposition of a matrix of
  size MxN: A = U * S * V^T

  The algorithm finds the singular values and, optionally, matrices U and V^T.
  The algorithm can find both first min(M,N) columns of matrix U and rows of
  matrix V^T (singular vectors), and matrices U and V^T wholly (of sizes MxM
  and NxN respectively).

  Take into account that the subroutine does not return matrix V but V^T.

  Input parameters:
  A           -   matrix to be decomposed.
  Array whose indexes range within [0..M-1, 0..N-1].
  M           -   number of rows in matrix A.
  N           -   number of columns in matrix A.
  UNeeded     -   0, 1 or 2. See the description of the parameter U.
  VTNeeded    -   0, 1 or 2. See the description of the parameter VT.

  AdditionalMemory -
  If the parameter:
  * equals 0, the algorithm dont use additional memory (lower requirements, lower performance).
  * equals 1, the algorithm uses additional memory of size min(M,N)*min(M,N) of real numbers. It often speeds up the algorithm.
  * equals 2, the algorithm uses additional memory of size M*min(M,N) of real numbers.
  It allows to get a maximum performance. The recommended value of the parameter is 2.

  Output parameters:
  W           -   contains singular values in descending order.

  U           -   if UNeeded=0, U isn't changed, the left singular vectors are not calculated.
  if Uneeded=1, U contains left singular vectors (first min(M,N) columns of matrix U). Array whose indexes range within [0..M-1, 0..Min(M,N)-1].
  if UNeeded=2, U contains matrix U wholly. Array whose indexes range within [0..M-1, 0..M-1].

  VT          -   if VTNeeded=0, VT isn�?changed, the right singular vectors are not calculated.
  if VTNeeded=1, VT contains right singular vectors (first min(M,N) rows of matrix V^T). Array whose indexes range within [0..min(M,N)-1, 0..N-1].
  if VTNeeded=2, VT contains matrix V^T wholly. Array whose indexes range within [0..N-1, 0..N-1].
  ************************************************************************ *)
function RMatrixSVD(a: TLMatrix; const M, N, UNeeded, VTNeeded, AdditionalMemory: TLInt; var W: TLVec; var U: TLMatrix; var VT: TLMatrix): Boolean;

{ Eigensolvers }
function SMatrixEVD(a: TLMatrix; N: TLInt; ZNeeded: TLInt; IsUpper: Boolean; var d: TLVec; var Z: TLMatrix): Boolean;

function SMatrixEVDR(a: TLMatrix; N: TLInt; ZNeeded: TLInt;
  IsUpper: Boolean; b1: TLFloat; b2: TLFloat; var M: TLInt;
  var W: TLVec; var Z: TLMatrix): Boolean;

function SMatrixEVDI(a: TLMatrix; N: TLInt; ZNeeded: TLInt;
  IsUpper: Boolean; i1: TLInt; i2: TLInt;
  var W: TLVec; var Z: TLMatrix): Boolean;

function HMatrixEVD(a: TLComplexMatrix; N: TLInt; ZNeeded: TLInt; IsUpper: Boolean;
  var d: TLVec; var Z: TLComplexMatrix): Boolean;

function HMatrixEVDR(a: TLComplexMatrix; N: TLInt;
  ZNeeded: TLInt; IsUpper: Boolean; b1: TLFloat; b2: TLFloat;
  var M: TLInt; var W: TLVec; var Z: TLComplexMatrix): Boolean;

function HMatrixEVDI(a: TLComplexMatrix; N: TLInt;
  ZNeeded: TLInt; IsUpper: Boolean; i1: TLInt;
  i2: TLInt; var W: TLVec; var Z: TLComplexMatrix): Boolean;

function SMatrixTDEVD(var d: TLVec; E: TLVec; N: TLInt; ZNeeded: TLInt; var Z: TLMatrix): Boolean;

function SMatrixTDEVDR(var d: TLVec; const E: TLVec;
  N: TLInt; ZNeeded: TLInt; a: TLFloat; b: TLFloat;
  var M: TLInt; var Z: TLMatrix): Boolean;

function SMatrixTDEVDI(var d: TLVec; const E: TLVec;
  N: TLInt; ZNeeded: TLInt; i1: TLInt;
  i2: TLInt; var Z: TLMatrix): Boolean;

function RMatrixEVD(a: TLMatrix; N: TLInt; VNeeded: TLInt;
  var WR: TLVec; var WI: TLVec; var vl: TLMatrix;
  var vr: TLMatrix): Boolean;

function InternalBisectionEigenValues(d: TLVec; E: TLVec;
  N: TLInt; IRANGE: TLInt; IORDER: TLInt;
  vl: TLFloat; VU: TLFloat; IL: TLInt; IU: TLInt;
  ABSTOL: TLFloat; var W: TLVec; var M: TLInt;
  var NSPLIT: TLInt; var IBLOCK: TLIVec;
  var ISPLIT: TLIVec; var ErrorCode: TLInt): Boolean;

procedure InternalDSTEIN(const N: TLInt; const d: TLVec;
  E: TLVec; const M: TLInt; W: TLVec;
  const IBLOCK: TLIVec; const ISPLIT: TLIVec;
  var Z: TLMatrix; var IFAIL: TLIVec; var Info: TLInt);

{ Schur decomposition }
function RMatrixSchur(var a: TLMatrix; N: TLInt; var s: TLMatrix): Boolean;
function UpperHessenbergSchurDecomposition(var h: TLMatrix; N: TLInt; var s: TLMatrix): Boolean;

{$ENDREGION 'BaseMatrix'}
{$REGION 'BaseDistribution'}

{ Normal distribution support }
function NormalDistribution(const X: TLFloat): TLFloat;
function InvNormalDistribution(const y0: TLFloat): TLFloat;

{ statistics base }
function Log1P(const X: TLFloat): TLFloat;
function ExpM1(const X: TLFloat): TLFloat;
function CosM1(const X: TLFloat): TLFloat;
{ Gamma support }
function Gamma(const X: TLFloat): TLFloat;
{ Natural logarithm of gamma function }
function LnGamma(const X: TLFloat; var SgnGam: TLFloat): TLFloat;
{ Incomplete gamma integral }
function IncompleteGamma(const a, X: TLFloat): TLFloat;
{ Complemented incomplete gamma integral }
function IncompleteGammaC(const a, X: TLFloat): TLFloat;
{ Inverse of complemented imcomplete gamma integral }
function InvIncompleteGammaC(const a, y0: TLFloat): TLFloat;

{ Poisson distribution }
function PoissonDistribution(K: TLInt; M: TLFloat): TLFloat;
{ Complemented Poisson distribution }
function PoissonCDistribution(K: TLInt; M: TLFloat): TLFloat;
{ Inverse Poisson distribution }
function InvPoissonDistribution(K: TLInt; Y: TLFloat): TLFloat;

{ Incomplete beta integral support }
function IncompleteBeta(a, b, X: TLFloat): TLFloat;
{ Inverse of imcomplete beta integral }
function InvIncompleteBeta(const a, b, Y: TLFloat): TLFloat;

{ F distribution support }
function FDistribution(const a: TLInt; const b: TLInt; const X: TLFloat): TLFloat;
{ Complemented F distribution }
function FCDistribution(const a: TLInt; const b: TLInt; const X: TLFloat): TLFloat;
{ Inverse of complemented F distribution }
function InvFDistribution(const a: TLInt; const b: TLInt; const Y: TLFloat): TLFloat;
{ Two-sample F-test }
procedure FTest(const X: TLVec; N: TLInt; const Y: TLVec; M: TLInt; var BothTails, LeftTail, RightTail: TLFloat);

{ Binomial distribution support }
function BinomialDistribution(const K, N: TLInt; const p: TLFloat): TLFloat;
{ Complemented binomial distribution }
function BinomialCDistribution(const K, N: TLInt; const p: TLFloat): TLFloat;
{ Inverse binomial distribution }
function InvBinomialDistribution(const K, N: TLInt; const Y: TLFloat): TLFloat;
{ Sign test }
procedure OneSampleSignTest(const X: TLVec; N: TLInt; Median: TLFloat; var BothTails, LeftTail, RightTail: TLFloat);

{ Chi-square distribution support }
function ChiSquareDistribution(const v, X: TLFloat): TLFloat;
{ Complemented Chi-square distribution }
function ChiSquareCDistribution(const v, X: TLFloat): TLFloat;
{ Inverse of complemented Chi-square distribution }
function InvChiSquareDistribution(const v, Y: TLFloat): TLFloat;
{ One-sample chi-square test }
procedure OneSampleVarianceTest(const X: TLVec; N: TLInt; Variance: TLFloat; var BothTails, LeftTail, RightTail: TLFloat);

{ Student's t distribution support }
function StudentTDistribution(const K: TLInt; const t: TLFloat): TLFloat;
{ Functional inverse of Student's t distribution }
function InvStudentTDistribution(const K: TLInt; p: TLFloat): TLFloat;
{ One-sample t-test }
procedure StudentTTest1(const X: TLVec; N: TLInt; Mean: TLFloat; var BothTails, LeftTail, RightTail: TLFloat);
{ Two-sample pooled test }
procedure StudentTTest2(const X: TLVec; N: TLInt; const Y: TLVec; M: TLInt; var BothTails, LeftTail, RightTail: TLFloat);
{ Two-sample unpooled test }
procedure UnequalVarianceTTest(const X: TLVec; N: TLInt; const Y: TLVec; M: TLInt; var BothTails, LeftTail, RightTail: TLFloat);

{ Pearson and Spearman distribution support }
{ Pearson product-moment correlation coefficient }
function PearsonCorrelation(const X, Y: TLVec; const N: TLInt): TLFloat;
{ Spearman's rank correlation coefficient }
function SpearmanRankCorrelation(const X, Y: TLVec; const N: TLInt): TLFloat;
procedure SpearmanRank(var X: TLVec; N: TLInt);
{ Pearson's correlation coefficient significance test }
procedure PearsonCorrelationSignificance(const r: TLFloat; const N: TLInt; var BothTails, LeftTail, RightTail: TLFloat);
{ Spearman's rank correlation coefficient significance test }
procedure SpearmanRankCorrelationSignificance(const r: TLFloat; const N: TLInt; var BothTails, LeftTail, RightTail: TLFloat);

{ Jarque-Bera test }
procedure JarqueBeraTest(const X: TLVec; const N: TLInt; var p: TLFloat);

{ Mann-Whitney U-test }
procedure MannWhitneyUTest(const X: TLVec; N: TLInt; const Y: TLVec; M: TLInt; var BothTails, LeftTail, RightTail: TLFloat);

{ Wilcoxon signed-rank test }
procedure WilcoxonSignedRankTest(const X: TLVec; N: TLInt; E: TLFloat; var BothTails, LeftTail, RightTail: TLFloat);
{$ENDREGION 'BaseDistribution'}
{$REGION 'BaseGauss'}
{
  Computation of nodes and weights for a Gauss quadrature formula

  The algorithm generates the N-point Gauss quadrature formula with weight
  function given by coefficients alpha and beta of a recurrence relation
  which generates a system of orthogonal polynomials:

  P-1(x)   =  0
  P0(x)    =  1
  Pn+1(x)  =  (x-alpha(n))*Pn(x)  -  beta(n)*Pn-1(x)

  and zeroth moment Mu0

  Mu0 = integral(W(x)dx,a,b)
}
procedure GaussQuadratureGenerateRec(const alpha, beta: TLVec; const Mu0: TLFloat; N: TLInt; var Info: TLInt; var X: TLVec; var W: TLVec);
{
  Computation of nodes and weights for a Gauss-Lobatto quadrature formula

  The algorithm generates the N-point Gauss-Lobatto quadrature formula with
  weight function given by coefficients alpha and beta of a recurrence which
  generates a system of orthogonal polynomials.

  P-1(x)   =  0
  P0(x)    =  1
  Pn+1(x)  =  (x-alpha(n))*Pn(x)  -  beta(n)*Pn-1(x)

  and zeroth moment Mu0

  Mu0 = integral(W(x)dx,a,b)
}
procedure GaussQuadratureGenerateGaussLobattoRec(const alpha, beta: TLVec; const Mu0, a, b: TLFloat; N: TLInt; var Info: TLInt; var X: TLVec; var W: TLVec);
{
  Computation of nodes and weights for a Gauss-Radau quadrature formula

  The algorithm generates the N-point Gauss-Radau quadrature formula with
  weight function given by the coefficients alpha and beta of a recurrence
  which generates a system of orthogonal polynomials.

  P-1(x)   =  0
  P0(x)    =  1
  Pn+1(x)  =  (x-alpha(n))*Pn(x)  -  beta(n)*Pn-1(x)

  and zeroth moment Mu0

  Mu0 = integral(W(x)dx,a,b)
}
procedure GaussQuadratureGenerateGaussRadauRec(const alpha, beta: TLVec; const Mu0, a: TLFloat; N: TLInt; var Info: TLInt; var X: TLVec; var W: TLVec);

{ Returns nodes/weights for Gauss-Legendre quadrature on [-1,1] with N nodes }
procedure GaussQuadratureGenerateGaussLegendre(const N: TLInt; var Info: TLInt; var X: TLVec; var W: TLVec);

{ Returns nodes/weights for Gauss-Jacobi quadrature on [-1,1] with weight function W(x)=Power(1-x,Alpha)*Power(1+x,Beta) }
procedure GaussQuadratureGenerateGaussJacobi(const N: TLInt; const alpha, beta: TLFloat; var Info: TLInt; var X: TLVec; var W: TLVec);

{ Returns nodes/weights for Gauss-Laguerre quadrature on (0,+inf) with weight function W(x)=Power(x,Alpha)*Exp(-x) }
procedure GaussQuadratureGenerateGaussLaguerre(const N: TLInt; const alpha: TLFloat; var Info: TLInt; var X: TLVec; var W: TLVec);

{ Returns nodes/weights for Gauss-Hermite quadrature on (-inf,+inf) with weight function W(x)=Exp(-x*x) }
procedure GaussQuadratureGenerateGaussHermite(const N: TLInt; var Info: TLInt; var X: TLVec; var W: TLVec);

{
  Computation of nodes and weights of a Gauss-Kronrod quadrature formula

  The algorithm generates the N-point Gauss-Kronrod quadrature formula  with
  weight function given by coefficients alpha and beta of a recurrence
  relation which generates a system of orthogonal polynomials:

  P-1(x)   =  0
  P0(x)    =  1
  Pn+1(x)  =  (x-alpha(n))*Pn(x)  -  beta(n)*Pn-1(x)

  and zero moment Mu0

  Mu0 = integral(W(x)dx,a,b)
}
procedure GaussKronrodQuadratureGenerateRec(const alpha, beta: TLVec; const Mu0: TLFloat; N: TLInt; var Info: TLInt; var X, WKronrod, WGauss: TLVec);

{
  Returns Gauss and Gauss-Kronrod nodes/weights for Gauss-Legendre quadrature with N points.
  GKQLegendreCalc (calculation) or GKQLegendreTbl (precomputed table) is used depending on machine precision and number of nodes.
}
procedure GaussKronrodQuadratureGenerateGaussLegendre(const N: TLInt; var Info: TLInt; var X, WKronrod, WGauss: TLVec);

{
  Returns Gauss and Gauss-Kronrod nodes/weights for Gauss-Jacobi quadrature on [-1,1] with weight function
  W(x)=Power(1-x,Alpha)*Power(1+x,Beta).
}
procedure GaussKronrodQuadratureGenerateGaussJacobi(const N: TLInt; const alpha, beta: TLFloat; var Info: TLInt; var X, WKronrod, WGauss: TLVec);

{
  Returns Gauss and Gauss-Kronrod nodes for quadrature with N points.
  Reduction to tridiagonal eigenproblem is used.
}
procedure GaussKronrodQuadratureLegendreCalc(const N: TLInt; var Info: TLInt; var X, WKronrod, WGauss: TLVec);

{
  Returns Gauss and Gauss-Kronrod nodes for quadrature with N  points  using pre-calculated table. Nodes/weights were computed with accuracy up to 1.0E-32.
  In standard TLFloat  precision accuracy reduces to something about 2.0E-16 (depending  on your compiler's handling of long floating point constants).
}
procedure GaussKronrodQuadratureLegendreTbl(const N: TLInt; var X, WKronrod, WGauss: TLVec; var Eps: TLFloat);
{$ENDREGION 'BaseGauss'}
{$REGION 'Limited memory BFGS optimizer'}
procedure MinLBFGSCreate(N: TLInt; M: TLInt; const X: TLVec; var State: TMinLBFGSState);
procedure MinLBFGSSetCond(var State: TMinLBFGSState; EpsG: TLFloat; EpsF: TLFloat; EpsX: TLFloat; MAXITS: TLInt);
procedure MinLBFGSSetXRep(var State: TMinLBFGSState; NeedXRep: Boolean);
procedure MinLBFGSSetStpMax(var State: TMinLBFGSState; StpMax: TLFloat);
procedure MinLBFGSCreateX(N: TLInt; M: TLInt; const X: TLVec; Flags: TLInt; var State: TMinLBFGSState);
function MinLBFGSIteration(var State: TMinLBFGSState): Boolean;
procedure MinLBFGSResults(const State: TMinLBFGSState; var X: TLVec; var Rep: TMinLBFGSReport);
procedure MinLBFGSFree(var X: TLVec; var State: TMinLBFGSState);
{$ENDREGION 'Limited memory BFGS optimizer'}
{$REGION 'Improved Levenberg-Marquardt optimizer'}
procedure MinLMCreateFGH(const N: TLInt; const X: TLVec; var State: TMinLMState);
procedure MinLMCreateFGJ(const N: TLInt; const M: TLInt; const X: TLVec; var State: TMinLMState);
procedure MinLMCreateFJ(const N: TLInt; const M: TLInt; const X: TLVec; var State: TMinLMState);
procedure MinLMSetCond(var State: TMinLMState; EpsG: TLFloat; EpsF: TLFloat; EpsX: TLFloat; MAXITS: TLInt);
procedure MinLMSetXRep(var State: TMinLMState; NeedXRep: Boolean);
procedure MinLMSetStpMax(var State: TMinLMState; StpMax: TLFloat);
function MinLMIteration(var State: TMinLMState): Boolean;
procedure MinLMResults(const State: TMinLMState; var X: TLVec; var Rep: TMinLMReport);
{$ENDREGION 'Improved Levenberg-Marquardt optimizer'}
{$REGION 'neural network'}
procedure MLPCreate0(NIn, NOut: TLInt; var Network: TMultiLayerPerceptron);
procedure MLPCreate1(NIn, NHid, NOut: TLInt; var Network: TMultiLayerPerceptron);
procedure MLPCreate2(NIn, NHid1, NHid2, NOut: TLInt; var Network: TMultiLayerPerceptron);

procedure MLPCreateB0(NIn, NOut: TLInt; b, d: TLFloat; var Network: TMultiLayerPerceptron);
procedure MLPCreateB1(NIn, NHid, NOut: TLInt; b, d: TLFloat; var Network: TMultiLayerPerceptron);
procedure MLPCreateB2(NIn, NHid1, NHid2, NOut: TLInt; b, d: TLFloat; var Network: TMultiLayerPerceptron);

procedure MLPCreateR0(NIn, NOut: TLInt; a, b: TLFloat; var Network: TMultiLayerPerceptron);
procedure MLPCreateR1(NIn, NHid, NOut: TLInt; a, b: TLFloat; var Network: TMultiLayerPerceptron);
procedure MLPCreateR2(NIn, NHid1, NHid2, NOut: TLInt; a, b: TLFloat; var Network: TMultiLayerPerceptron);

procedure MLPCreateC0(NIn, NOut: TLInt; var Network: TMultiLayerPerceptron);
procedure MLPCreateC1(NIn, NHid, NOut: TLInt; var Network: TMultiLayerPerceptron);
procedure MLPCreateC2(NIn, NHid1, NHid2, NOut: TLInt; var Network: TMultiLayerPerceptron);

procedure MLPFree(var Network: TMultiLayerPerceptron);
procedure MLPCopy(const Network1: TMultiLayerPerceptron; var Network2: TMultiLayerPerceptron);

procedure MLPSerialize(const Network: TMultiLayerPerceptron; var ResArry: TLVec; var RLen: TLInt);
procedure MLPUNSerialize(const ResArry: TLVec; var Network: TMultiLayerPerceptron);

procedure MLPRandomize(var Network: TMultiLayerPerceptron); overload;
procedure MLPRandomize(var Network: TMultiLayerPerceptron; const Diameter: TLFloat); overload;
procedure MLPRandomize(var Network: TMultiLayerPerceptron; const WBest: TLVec; const Diameter: TLFloat); overload;
procedure MLPRandomizeFull(var Network: TMultiLayerPerceptron);

procedure MLPInitPreprocessor(var Network: TMultiLayerPerceptron; const xy: TLMatrix; SSize: TLInt);
procedure MLPProperties(const Network: TMultiLayerPerceptron; var NIn: TLInt; var NOut: TLInt; var WCount: TLInt);
function MLPIsSoftmax(const Network: TMultiLayerPerceptron): Boolean;

procedure MLPProcess(var Network: TMultiLayerPerceptron; const X: TLVec; var Y: TLVec);

function MLPError(var Network: TMultiLayerPerceptron; const xy: TLMatrix; SSize: TLInt): TLFloat;
function MLPErrorN(var Network: TMultiLayerPerceptron; const xy: TLMatrix; SSize: TLInt): TLFloat;
function MLPClsError(var Network: TMultiLayerPerceptron; const xy: TLMatrix; SSize: TLInt): TLInt;
function MLPRelClsError(var Network: TMultiLayerPerceptron; const xy: TLMatrix; NPoints: TLInt): TLFloat;
function MLPAvgCE(var Network: TMultiLayerPerceptron; const xy: TLMatrix; NPoints: TLInt): TLFloat;
function MLPRMSError(var Network: TMultiLayerPerceptron; const xy: TLMatrix; NPoints: TLInt): TLFloat;
function MLPAvgError(var Network: TMultiLayerPerceptron; const xy: TLMatrix; NPoints: TLInt): TLFloat;
function MLPAvgRelError(var Network: TMultiLayerPerceptron; const xy: TLMatrix; NPoints: TLInt): TLFloat;

procedure MLPGrad(var Network: TMultiLayerPerceptron; const X: TLVec; const DesiredY: TLVec; var E: TLFloat; var Grad: TLVec);
procedure MLPGradN(var Network: TMultiLayerPerceptron; const X: TLVec; const DesiredY: TLVec; var E: TLFloat; var Grad: TLVec);
procedure MLPGradBatch(var Network: TMultiLayerPerceptron; const xy: TLMatrix; SSize: TLInt; var E: TLFloat; var Grad: TLVec);
procedure MLPGradNBatch(var Network: TMultiLayerPerceptron; const xy: TLMatrix; SSize: TLInt; var E: TLFloat; var Grad: TLVec);

procedure MLPHessianNBatch(var Network: TMultiLayerPerceptron; const xy: TLMatrix; SSize: TLInt; var E: TLFloat; var Grad: TLVec; var h: TLMatrix);
procedure MLPHessianBatch(var Network: TMultiLayerPerceptron; const xy: TLMatrix; SSize: TLInt; var E: TLFloat; var Grad: TLVec; var h: TLMatrix);

procedure MLPInternalProcessVector(const StructInfo: TLIVec;
  const Weights: TLVec; const ColumnMeans: TLVec;
  const ColumnSigmas: TLVec; var Neurons: TLVec;
  var DFDNET: TLVec; const X: TLVec; var Y: TLVec);

procedure MLPTrainLM(var Network: TMultiLayerPerceptron; const xy: TLMatrix;
  NPoints: TLInt; Decay: TLFloat; Restarts: TLInt;
  var Info: TLInt; var Rep: TMLPReport);

procedure MLPTrainLM_MT(var Network: TMultiLayerPerceptron; const xy: TLMatrix;
  NPoints: TLInt; Decay: TLFloat; Restarts: TLInt;
  var Info: TLInt; var Rep: TMLPReport);

procedure MLPTrainLBFGS(var Network: TMultiLayerPerceptron;
  const xy: TLMatrix; NPoints: TLInt; Decay: TLFloat;
  Restarts: TLInt; WStep: TLFloat; MAXITS: TLInt;
  var Info: TLInt; var Rep: TMLPReport; IsTerminated: PBoolean;
  out EBest: TLFloat);

procedure MLPTrainLBFGS_MT(var Network: TMultiLayerPerceptron;
  const xy: TLMatrix; NPoints: TLInt; Decay: TLFloat;
  Restarts: TLInt; WStep: TLFloat; MAXITS: TLInt;
  var Info: TLInt; var Rep: TMLPReport);

procedure MLPTrainLBFGS_MT_Mod(var Network: TMultiLayerPerceptron;
  const xy: TLMatrix; NPoints: TLInt; Restarts: TLInt;
  WStep, Diameter: TLFloat; MAXITS: TLInt;
  var Info: TLInt; var Rep: TMLPReport);

procedure MLPTrainMonteCarlo(var Network: TMultiLayerPerceptron; const xy: TLMatrix; NPoints: TLInt;
  const MainRestarts, SubRestarts: TLInt; const MinError: TLFloat;
  Diameter: TLFloat; var Info: TLInt; var Rep: TMLPReport);

procedure MLPKFoldCVLBFGS(const Network: TMultiLayerPerceptron;
  const xy: TLMatrix; NPoints: TLInt; Decay: TLFloat;
  Restarts: TLInt; WStep: TLFloat; MAXITS: TLInt;
  FoldsCount: TLInt; var Info: TLInt; var Rep: TMLPReport;
  var CVRep: TMLPCVReport);

procedure MLPKFoldCVLM(const Network: TMultiLayerPerceptron;
  const xy: TLMatrix; NPoints: TLInt; Decay: TLFloat;
  Restarts: TLInt; FoldsCount: TLInt; var Info: TLInt;
  var Rep: TMLPReport; var CVRep: TMLPCVReport);
{$ENDREGION 'neural network'}
{$REGION 'Neural networks ensemble'}
procedure MLPECreate0(NIn, NOut, EnsembleSize: TLInt; var Ensemble: TMLPEnsemble);
procedure MLPECreate1(NIn, NHid, NOut, EnsembleSize: TLInt; var Ensemble: TMLPEnsemble);
procedure MLPECreate2(NIn, NHid1, NHid2, NOut, EnsembleSize: TLInt; var Ensemble: TMLPEnsemble);

procedure MLPECreateB0(NIn, NOut: TLInt; b, d: TLFloat; EnsembleSize: TLInt; var Ensemble: TMLPEnsemble);
procedure MLPECreateB1(NIn, NHid, NOut: TLInt; b, d: TLFloat; EnsembleSize: TLInt; var Ensemble: TMLPEnsemble);
procedure MLPECreateB2(NIn, NHid1, NHid2, NOut: TLInt; b, d: TLFloat; EnsembleSize: TLInt; var Ensemble: TMLPEnsemble);

procedure MLPECreateR0(NIn, NOut: TLInt; a, b: TLFloat; EnsembleSize: TLInt; var Ensemble: TMLPEnsemble);
procedure MLPECreateR1(NIn, NHid, NOut: TLInt; a, b: TLFloat; EnsembleSize: TLInt; var Ensemble: TMLPEnsemble);
procedure MLPECreateR2(NIn, NHid1, NHid2, NOut: TLInt; a, b: TLFloat; EnsembleSize: TLInt; var Ensemble: TMLPEnsemble);

procedure MLPECreateC0(NIn, NOut, EnsembleSize: TLInt; var Ensemble: TMLPEnsemble);
procedure MLPECreateC1(NIn, NHid, NOut, EnsembleSize: TLInt; var Ensemble: TMLPEnsemble);
procedure MLPECreateC2(NIn, NHid1, NHid2, NOut, EnsembleSize: TLInt; var Ensemble: TMLPEnsemble);

procedure MLPECreateFromNetwork(const Network: TMultiLayerPerceptron; EnsembleSize: TLInt; var Ensemble: TMLPEnsemble);

procedure MLPECopy(const Ensemble1: TMLPEnsemble; var Ensemble2: TMLPEnsemble);
procedure MLPESerialize(var Ensemble: TMLPEnsemble; var ResArry: TLVec; var RLen: TLInt);
procedure MLPEUNSerialize(const ResArry: TLVec; var Ensemble: TMLPEnsemble);

procedure MLPERandomize(var Ensemble: TMLPEnsemble);

procedure MLPEProperties(const Ensemble: TMLPEnsemble; var NIn: TLInt; var NOut: TLInt);

function MLPEIsSoftmax(const Ensemble: TMLPEnsemble): Boolean;

procedure MLPEProcess(var Ensemble: TMLPEnsemble; const X: TLVec; var Y: TLVec);

function MLPERelClsError(var Ensemble: TMLPEnsemble; const xy: TLMatrix; NPoints: TLInt): TLFloat;
function MLPEAvgCE(var Ensemble: TMLPEnsemble; const xy: TLMatrix; NPoints: TLInt): TLFloat;
function MLPERMSError(var Ensemble: TMLPEnsemble; const xy: TLMatrix; NPoints: TLInt): TLFloat;
function MLPEAvgError(var Ensemble: TMLPEnsemble; const xy: TLMatrix; NPoints: TLInt): TLFloat;
function MLPEAvgRelError(var Ensemble: TMLPEnsemble; const xy: TLMatrix; NPoints: TLInt): TLFloat;

procedure MLPEBaggingLM(const MultiThread: Boolean; var Ensemble: TMLPEnsemble; const xy: TLMatrix;
  NPoints: TLInt; Decay: TLFloat; Restarts: TLInt;
  var Info: TLInt; var Rep: TMLPReport; var OOBErrors: TMLPCVReport);

procedure MLPEBaggingLBFGS(const MultiThread: Boolean; var Ensemble: TMLPEnsemble; const xy: TLMatrix;
  NPoints: TLInt; Decay: TLFloat; Restarts: TLInt;
  WStep: TLFloat; MAXITS: TLInt; var Info: TLInt;
  var Rep: TMLPReport; var OOBErrors: TMLPCVReport);
{$ENDREGION 'Neural networks ensemble'}
{$REGION 'Random Decision Forest'}
procedure DFBuildRandomDecisionForest(const xy: TLMatrix; NPoints, NVars, NClasses, NTrees: TLInt; r: TLFloat; var Info: TLInt; var df: TDecisionForest; var Rep: TDFReport);
procedure DFProcess(const df: TDecisionForest; const X: TLVec; var Y: TLVec);
function DFRelClsError(const df: TDecisionForest; const xy: TLMatrix; NPoints: TLInt): TLFloat;
function DFAvgCE(const df: TDecisionForest; const xy: TLMatrix; NPoints: TLInt): TLFloat;
function DFRMSError(const df: TDecisionForest; const xy: TLMatrix; NPoints: TLInt): TLFloat;
function DFAvgError(const df: TDecisionForest; const xy: TLMatrix; NPoints: TLInt): TLFloat;
function DFAvgRelError(const df: TDecisionForest; const xy: TLMatrix; NPoints: TLInt): TLFloat;
procedure DFCopy(const DF1: TDecisionForest; var DF2: TDecisionForest);
procedure DFSerialize(const df: TDecisionForest; var ResArry: TLVec; var RLen: TLInt);
procedure DFUnserialize(const ResArry: TLVec; var df: TDecisionForest);
{$ENDREGION 'Random Decision Forest'}
{$REGION 'LogitModel'}

procedure MNLTrainH(const xy: TLMatrix; NPoints: TLInt; NVars: TLInt; NClasses: TLInt; var Info: TLInt; var LM: TLogitModel; var Rep: TMNLReport);
procedure MNLProcess(var LM: TLogitModel; const X: TLVec; var Y: TLVec);
procedure MNLUnpack(const LM: TLogitModel; var a: TLMatrix; var NVars: TLInt; var NClasses: TLInt);
procedure MNLPack(const a: TLMatrix; NVars: TLInt; NClasses: TLInt; var LM: TLogitModel);
procedure MNLCopy(const LM1: TLogitModel; var LM2: TLogitModel);
procedure MNLSerialize(const LM: TLogitModel; var ResArry: TLVec; var RLen: TLInt);
procedure MNLUnserialize(const ResArry: TLVec; var LM: TLogitModel);
function MNLAvgCE(var LM: TLogitModel; const xy: TLMatrix; NPoints: TLInt): TLFloat;
function MNLRelClsError(var LM: TLogitModel; const xy: TLMatrix; NPoints: TLInt): TLFloat;
function MNLRMSError(var LM: TLogitModel; const xy: TLMatrix; NPoints: TLInt): TLFloat;
function MNLAvgError(var LM: TLogitModel; const xy: TLMatrix; NPoints: TLInt): TLFloat;
function MNLAvgRelError(var LM: TLogitModel; const xy: TLMatrix; SSize: TLInt): TLFloat;
function MNLClsError(var LM: TLogitModel; const xy: TLMatrix; NPoints: TLInt): TLInt;
{$ENDREGION 'LogitModel'}
{$REGION 'fitting'}

{ Least squares fitting }
procedure LSFitLinearW(Y: TLVec; W: TLVec; FMatrix: TLMatrix; N: TLInt; M: TLInt; var Info: TLInt; var c: TLVec; var Rep: TLSFitReport);
procedure LSFitLinearWC(Y: TLVec; W: TLVec; FMatrix: TLMatrix; CMatrix: TLMatrix; N: TLInt; M: TLInt; K: TLInt; var Info: TLInt; var c: TLVec; var Rep: TLSFitReport);
procedure LSFitLinear(Y: TLVec; FMatrix: TLMatrix; N: TLInt; M: TLInt; var Info: TLInt; var c: TLVec; var Rep: TLSFitReport);
procedure LSFitLinearC(Y: TLVec; FMatrix: TLMatrix; CMatrix: TLMatrix; N: TLInt; M: TLInt; K: TLInt; var Info: TLInt; var c: TLVec; var Rep: TLSFitReport);
procedure LSFitNonlinearWFG(X: TLMatrix; Y: TLVec; W: TLVec; c: TLVec; N: TLInt; M: TLInt; K: TLInt; CheapFG: Boolean; var State: TLSFitState);
procedure LSFitNonlinearFG(X: TLMatrix; Y: TLVec; c: TLVec; N: TLInt; M: TLInt; K: TLInt; CheapFG: Boolean; var State: TLSFitState);
procedure LSFitNonlinearWFGH(X: TLMatrix; Y: TLVec; W: TLVec; c: TLVec; N: TLInt; M: TLInt; K: TLInt; var State: TLSFitState);
procedure LSFitNonlinearFGH(X: TLMatrix; Y: TLVec; c: TLVec; N: TLInt; M: TLInt; K: TLInt; var State: TLSFitState);
procedure LSFitNonlinearSetCond(var State: TLSFitState; EpsF: TLFloat; EpsX: TLFloat; MAXITS: TLInt);
procedure LSFitNonlinearSetStpMax(var State: TLSFitState; StpMax: TLFloat);
function LSFitNonlinearIteration(var State: TLSFitState): Boolean;
procedure LSFitNonlinearResults(State: TLSFitState; var Info: TLInt; var c: TLVec; var Rep: TLSFitReport);
procedure LSFitScaleXY(var X, Y: TLVec; N: TLInt; var XC, YC: TLVec; DC: TLIVec; K: TLInt; var XA, XB, SA, SB: TLFloat; var XOriginal, YOriginal: TLVec);

{ Barycentric fitting }
function BarycentricCalc(b: TBarycentricInterpolant; t: TLFloat): TLFloat;
procedure BarycentricDiff1(b: TBarycentricInterpolant; t: TLFloat; var f: TLFloat; var df: TLFloat);
procedure BarycentricDiff2(b: TBarycentricInterpolant; t: TLFloat; var f: TLFloat; var df: TLFloat; var D2F: TLFloat);
procedure BarycentricLinTransX(var b: TBarycentricInterpolant; ca: TLFloat; CB: TLFloat);
procedure BarycentricLinTransY(var b: TBarycentricInterpolant; ca: TLFloat; CB: TLFloat);
procedure BarycentricUnpack(b: TBarycentricInterpolant; var N: TLInt; var X: TLVec; var Y: TLVec; var W: TLVec);
procedure BarycentricSerialize(b: TBarycentricInterpolant; var ResArry: TLVec; var ResLen: TLInt);
procedure BarycentricUnserialize(ResArry: TLVec; var b: TBarycentricInterpolant);
procedure BarycentricCopy(b: TBarycentricInterpolant; var b2: TBarycentricInterpolant);
procedure BarycentricBuildXYW(X, Y, W: TLVec; N: TLInt; var b: TBarycentricInterpolant);
procedure BarycentricBuildFloaterHormann(X, Y: TLVec; N: TLInt; d: TLInt; var b: TBarycentricInterpolant);
procedure BarycentricFitFloaterHormannWC(X, Y, W: TLVec; N: TLInt; XC, YC: TLVec; DC: TLIVec; K, M: TLInt; var Info: TLInt; var b: TBarycentricInterpolant; var Rep: TBarycentricFitReport);
procedure BarycentricFitFloaterHormann(X, Y: TLVec; N: TLInt; M: TLInt; var Info: TLInt; var b: TBarycentricInterpolant; var Rep: TBarycentricFitReport);

{ Polynomial fitting }
procedure PolynomialBuild(X, Y: TLVec; N: TLInt; var p: TBarycentricInterpolant);
procedure PolynomialBuildEqDist(a: TLFloat; b: TLFloat; Y: TLVec; N: TLInt; var p: TBarycentricInterpolant);
procedure PolynomialBuildCheb1(a: TLFloat; b: TLFloat; Y: TLVec; N: TLInt; var p: TBarycentricInterpolant);
procedure PolynomialBuildCheb2(a: TLFloat; b: TLFloat; Y: TLVec; N: TLInt; var p: TBarycentricInterpolant);
function PolynomialCalcEqDist(a: TLFloat; b: TLFloat; f: TLVec; N: TLInt; t: TLFloat): TLFloat;
function PolynomialCalcCheb1(a: TLFloat; b: TLFloat; f: TLVec; N: TLInt; t: TLFloat): TLFloat;
function PolynomialCalcCheb2(a: TLFloat; b: TLFloat; f: TLVec; N: TLInt; t: TLFloat): TLFloat;
procedure PolynomialFit(X, Y: TLVec; N, M: TLInt; var Info: TLInt; var p: TBarycentricInterpolant; var Rep: TPolynomialFitReport);
procedure PolynomialFitWC(X, Y, W: TLVec; N: TLInt; XC, YC: TLVec; DC: TLIVec; K: TLInt; M: TLInt; var Info: TLInt; var p: TBarycentricInterpolant; var Rep: TPolynomialFitReport);

{ Spline1D fitting }
procedure Spline1DBuildLinear(X, Y: TLVec; N: TLInt; var c: TSpline1DInterpolant);
procedure Spline1DBuildCubic(X, Y: TLVec; N: TLInt; BoundLType: TLInt; BoundL: TLFloat; BoundRType: TLInt; BoundR: TLFloat; var c: TSpline1DInterpolant);
procedure Spline1DBuildCatmullRom(X, Y: TLVec; N: TLInt; BoundType: TLInt; Tension: TLFloat; var c: TSpline1DInterpolant);
procedure Spline1DBuildHermite(X, Y: TLVec; d: TLVec; N: TLInt; var c: TSpline1DInterpolant);
procedure Spline1DBuildAkima(X, Y: TLVec; N: TLInt; var c: TSpline1DInterpolant);
procedure Spline1DFitCubicWC(X, Y, W: TLVec; N: TLInt; XC: TLVec; YC: TLVec; DC: TLIVec; K: TLInt; M: TLInt; var Info: TLInt; var s: TSpline1DInterpolant; var Rep: TSpline1DFitReport);
procedure Spline1DFitHermiteWC(X, Y, W: TLVec; N: TLInt; XC: TLVec; YC: TLVec; DC: TLIVec; K: TLInt; M: TLInt; var Info: TLInt; var s: TSpline1DInterpolant; var Rep: TSpline1DFitReport);
procedure Spline1DFitCubic(X, Y: TLVec; N: TLInt; M: TLInt; var Info: TLInt; var s: TSpline1DInterpolant; var Rep: TSpline1DFitReport);
procedure Spline1DFitHermite(X, Y: TLVec; N: TLInt; M: TLInt; var Info: TLInt; var s: TSpline1DInterpolant; var Rep: TSpline1DFitReport);
function Spline1DCalc(c: TSpline1DInterpolant; X: TLFloat): TLFloat;
procedure Spline1DDiff(c: TSpline1DInterpolant; X: TLFloat; var s: TLFloat; var DS: TLFloat; var D2S: TLFloat);
procedure Spline1DCopy(c: TSpline1DInterpolant; var CC: TSpline1DInterpolant);
procedure Spline1DUnpack(c: TSpline1DInterpolant; var N: TLInt; var Tbl: TLMatrix);
procedure Spline1DLinTransX(var c: TSpline1DInterpolant; a: TLFloat; b: TLFloat);
procedure Spline1DLinTransY(var c: TSpline1DInterpolant; a: TLFloat; b: TLFloat);
function Spline1DIntegrate(c: TSpline1DInterpolant; X: TLFloat): TLFloat;

{$ENDREGION 'fitting'}
{$REGION 'Portable high quality random number'}
procedure HQRNDRandomize(var State: THQRNDState);
procedure HQRNDSeed(const s1, s2: TLInt; var State: THQRNDState);
function HQRNDUniformR(var State: THQRNDState): TLFloat;
function HQRNDUniformI(const N: TLInt; var State: THQRNDState): TLInt;
function HQRNDNormal(var State: THQRNDState): TLFloat;
procedure HQRNDUnit2(var State: THQRNDState; var X: TLFloat; var Y: TLFloat);
procedure HQRNDNormal2(var State: THQRNDState; var x1: TLFloat; var x2: TLFloat);
function HQRNDExponential(const LAMBDA: TLFloat; var State: THQRNDState): TLFloat;
{$ENDREGION 'Portable high quality random number'}
{$REGION 'Generation of random matrix'}
procedure RMatrixRndOrthogonal(N: TLInt; var a: TLMatrix);
procedure RMatrixRndCond(N: TLInt; c: TLFloat; var a: TLMatrix);
procedure CMatrixRndOrthogonal(N: TLInt; var a: TLComplexMatrix);
procedure CMatrixRndCond(N: TLInt; c: TLFloat; var a: TLComplexMatrix);
procedure SMatrixRndCond(N: TLInt; c: TLFloat; var a: TLMatrix);
procedure SPDMatrixRndCond(N: TLInt; c: TLFloat; var a: TLMatrix);
procedure HMatrixRndCond(N: TLInt; c: TLFloat; var a: TLComplexMatrix);
procedure HPDMatrixRndCond(N: TLInt; c: TLFloat; var a: TLComplexMatrix);
procedure RMatrixRndOrthogonalFromTheRight(var a: TLMatrix; M: TLInt; N: TLInt);
procedure RMatrixRndOrthogonalFromTheLeft(var a: TLMatrix; M: TLInt; N: TLInt);
procedure CMatrixRndOrthogonalFromTheRight(var a: TLComplexMatrix; M: TLInt; N: TLInt);
procedure CMatrixRndOrthogonalFromTheLeft(var a: TLComplexMatrix; M: TLInt; N: TLInt);
procedure SMatrixRndMultiply(var a: TLMatrix; N: TLInt);
procedure HMatrixRndMultiply(var a: TLComplexMatrix; N: TLInt);
{$ENDREGION 'Generation of random matrix'}
{$REGION 'fft'}
{ generates FFT plan }
procedure FTBaseGenerateComplexFFTPlan(N: TLInt; var Plan: TFTPlan);
procedure FTBaseGenerateRealFFTPlan(N: TLInt; var Plan: TFTPlan);
procedure FTBaseGenerateRealFHTPlan(N: TLInt; var Plan: TFTPlan);
procedure FTBaseExecutePlan(var a: TLVec; AOffset: TLInt; N: TLInt; var Plan: TFTPlan);
procedure FTBaseExecutePlanRec(var a: TLVec; AOffset: TLInt; var Plan: TFTPlan; EntryOffset: TLInt; StackPtr: TLInt);
procedure FTBaseFactorize(N: TLInt; TaskType: TLInt; var n1: TLInt; var n2: TLInt);
function FTBaseIsSmooth(N: TLInt): Boolean;
function FTBaseFindSmooth(N: TLInt): TLInt;
function FTBaseFindSmoothEven(N: TLInt): TLInt;
function FTBaseGetFLOPEstimate(N: TLInt): TLFloat;
{ 1-dimensional TLComplex FFT. }
procedure FFTC1D(var a: TLComplexVec; N: TLInt);
{ 1-dimensional TLComplex inverse FFT. }
procedure FFTC1DInv(var a: TLComplexVec; N: TLInt);
{ 1-dimensional real FFT. }
procedure FFTR1D(const a: TLVec; N: TLInt; var f: TLComplexVec);
{ 1-dimensional real inverse FFT. }
procedure FFTR1DInv(const f: TLComplexVec; N: TLInt; var a: TLVec);
{$ENDREGION 'fft'}
{$REGION 'test'}
procedure LearnTest;
procedure LearnTest_ProcessMaxIndexCandidate;
{$ENDREGION 'test'}

implementation

uses PasAI.Learn.KM, PasAI.Status, PasAI.Parsing, PasAI.Expression, PasAI.OpCode, PasAI.Opti_Distance_D;

{$REGION 'Include'}
{$I PasAI.Learn.base.inc}
{$I PasAI.Learn.blas.inc}
{$I PasAI.Learn.ablas.inc}
{$I PasAI.Learn.trfac.inc}
{$I PasAI.Learn.safesolve.inc}
{$I PasAI.Learn.rcond.inc}
{$I PasAI.Learn.matinv.inc}
{$I PasAI.Learn.linmin.inc}
{$I PasAI.Learn.lbfgs.inc}
{$I PasAI.Learn.rotations.inc}
{$I PasAI.Learn.ortfac.inc}
{$I PasAI.Learn.bdsvd.inc}
{$I PasAI.Learn.svd.inc}
{$I PasAI.Learn.densesolver.inc}
{$I PasAI.Learn.minlm.inc}
{$I PasAI.Learn.trainbase.inc}
{$I PasAI.Learn.train.inc}
{$I PasAI.Learn.trainEnsemble.inc}
{$I PasAI.Learn.schur.inc}
{$I PasAI.Learn.evd.inc}
{$I PasAI.Learn.PCA.inc}
{$I PasAI.Learn.LDA.inc}
{$I PasAI.Learn.forest.inc}
{$I PasAI.Learn.logit.inc}
{$I PasAI.Learn.statistics_normal_distribution.inc}
{$I PasAI.Learn.statistics_base.inc}
{$I PasAI.Learn.statistics_IncompleteBeta.inc}
{$I PasAI.Learn.statistics_fdistribution.inc}
{$I PasAI.Learn.statistics_binomial_distribution.inc}
{$I PasAI.Learn.statistics_chisquare_distribution.inc}
{$I PasAI.Learn.statistics_StudentsT_distribution.inc}
{$I PasAI.Learn.statistics_Pearson_Spearman.inc}
{$I PasAI.Learn.statistics_JarqueBeraTest.inc}
{$I PasAI.Learn.statistics_MannWhitneyUTest.inc}
{$I PasAI.Learn.statistics_Wilcoxon.inc}
{$I PasAI.Learn.gaussintegral.inc}
{$I PasAI.Learn.fitting.inc}
{$I PasAI.Learn.quality_random.inc}
{$I PasAI.Learn.matgen.inc}
{$I PasAI.Learn.fft.inc}
{$I PasAI.Learn.extAPI.inc}
{$I PasAI.Learn.Distance_SIMD.inc}
{$I PasAI.Learn.th.inc}
{$I PasAI.Learn.Class_LIB.inc}
{$I PasAI.Learn.test.inc}
{$ENDREGION 'Include'}


end.
