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
{ * FFMPEG Data marshal v1.0                                                   * }
{ ****************************************************************************** }
unit PasAI.FFMPEG.DataMarshal;

{$DEFINE FPC_DELPHI_MODE}
{$I PasAI.Define.inc}

interface

uses SysUtils, DateUtils,
  PasAI.Core,
{$IFDEF FPC}
  PasAI.FPC.GenericList,
{$ENDIF FPC}
  PasAI.PascalStrings, PasAI.UPascalStrings, PasAI.UnicodeMixedLib, PasAI.Geometry2D,
  PasAI.MemoryStream, PasAI.HashList.Templet, PasAI.DFE,
  PasAI.Status, PasAI.Cipher, PasAI.ZDB2, PasAI.ListEngine, PasAI.TextDataEngine, PasAI.Notify, PasAI.IOThread,
  PasAI.HashMinutes.Templet, PasAI.HashHours.Templet,
  PasAI.ZDB2.Thread.Queue, PasAI.ZDB2.Thread;

type
  TZDB2_FFMPEG_Data_Marshal = class;

  TZDB2_FFMPEG_Data_Head = class(TCore_Object_Intermediate)
  public
    Source: U_String; // source alias
    clip: U_String; // online and play state
    PSF: Double; // per second frame
    Begin_Frame_ID, End_Frame_ID: Int64; // frame id
    Begin_Time, End_Time: TDateTime; // time range
    constructor Create;
    destructor Destroy; override;
    procedure Reset();
    procedure Assign(source_: TZDB2_FFMPEG_Data_Head);
    procedure Encode(m64: TMS64); overload;
    procedure Encode(m64: TMem64); overload;
    procedure Decode(m64: TMS64); overload;
    procedure Decode(m64: TMem64); overload;
    function Get_Time_Tick_Long: TTimeTick;
    function Frame_ID_As_Time(ID: Int64): TDateTime;
    function Get_Task_Time_Stamp: Int64; // return TRV2_Data.Task_Time_Stamp
  end;

  TZDB2_FFMPEG_Data_Head_List = TBigList<TZDB2_FFMPEG_Data_Head>;

  TZDB2_FFMPEG_Data = class(TZDB2_Th_Engine_Data)
  private
    FSequence_ID: Int64;
    FH264_Data_Position: Int64;
  public
    Owner_FFMPEG_Data_Marshal: TZDB2_FFMPEG_Data_Marshal;
    Head: TZDB2_FFMPEG_Data_Head;
    property Sequence_ID: Int64 read FSequence_ID;
    property H264_Data_Position: Int64 read FH264_Data_Position;
    constructor Create; override;
    destructor Destroy; override;
    procedure Do_Remove(); override;
    function Sync_Get_H264_Head_And_Data(): TMS64;
    { Extended Data Header Technology for Solving the Decentralized performance Problem of hdd }
    { When the data volume is large, a dataset contains dozens or hundreds of small databases. During disk operation, disk pre reads will be read in blocks, which greatly consumes HDD read time }
    { Expanding the data header is to gather thousands of fragmented databases and read them all at once, thereby improving the startup efficiency of the database. At the same time, pre reading also requires higher memory requirements }
    { Pre reading technology can improve data loading efficiency in the vast majority of hdd systems }
    procedure Encode_External_Header_Data(External_Header_Data: TMem64); virtual;
    procedure Decode_External_Header_Data(External_Header_Data: TMem64); virtual;
  end;

  TZDB2_FFMPEG_Data_Sequence_ID_Pool = TCritical_Big_Hash_Pair_Pool<Int64, TZDB2_FFMPEG_Data>;

  TFFMPEG_Data_Analysis_Struct = record
  public
    Num: NativeInt;
    FirstTime, LastTime: TDateTime;
    Size: Int64;
    class function Null_(): TFFMPEG_Data_Analysis_Struct; static;
  end;

  TFFMPEG_Data_Analysis_Hash_Pool_Decl = TString_Big_Hash_Pair_Pool<TFFMPEG_Data_Analysis_Struct>;

  TFFMPEG_Data_Analysis_Hash_Pool = class(TFFMPEG_Data_Analysis_Hash_Pool_Decl)
  public
    procedure IncValue(Key_: SystemString; Value_: Integer); overload;
    procedure IncValue_Size(Key_: SystemString; Value_: Integer; Size: Int64);
    procedure IncValue(Key_: SystemString; Value_: Integer; FirstTime, LastTime: TDateTime; Size: Int64); overload;
    procedure IncValue(Source: TFFMPEG_Data_Analysis_Hash_Pool); overload;
    procedure GetKeyList(output: TPascalStringList); overload;
    procedure GetKeyList(output: TCore_Strings); overload;
    function GetKeyArry: U_StringArray;
    procedure Get_Key_Num_List(output: THashVariantList);
    procedure Get_Key_Num_And_Time_List(output: THashStringList);
    procedure Get_Key_Num_And_Time_And_Size_List(output: THashStringList);
  end;

  TZDB2_FFMPEG_Data_Query_Result_Decl = TCritical_BigList<TZDB2_FFMPEG_Data>;

  TZDB2_FFMPEG_Data_Query_Result = class(TZDB2_FFMPEG_Data_Query_Result_Decl)
  private
    FInstance_protected: Boolean;
    function Do_Sort_By_Source_Clip_Time(var L, R: TZDB2_FFMPEG_Data): Integer;
    function Do_Sort_By_Source_Time(var L, R: TZDB2_FFMPEG_Data): Integer;
    function Do_Sort_By_Time(var L, R: TZDB2_FFMPEG_Data): Integer;
  public
    Source_Analysis, clip_Analysis: TFFMPEG_Data_Analysis_Hash_Pool;
    property Instance_protected: Boolean read FInstance_protected write FInstance_protected;
    constructor Create;
    destructor Destroy; override;
    procedure DoFree(var Data: TZDB2_FFMPEG_Data); override;
    procedure DoAdd(var Data: TZDB2_FFMPEG_Data); override;
    procedure Sort_By_Source_Clip_Time();
    procedure Sort_By_Source_Time();
    procedure Sort_By_Time();
    function Extract_Source(Source: U_String; removed_: Boolean): TZDB2_FFMPEG_Data_Query_Result;
    function Extract_clip(clip: U_String; removed_: Boolean): TZDB2_FFMPEG_Data_Query_Result;
  end;

  TZDB2_FFMPEG_Data_Query_Result_Clip_Tool_Decl = TCritical_BigList<TZDB2_FFMPEG_Data_Query_Result>;

  TZDB2_FFMPEG_Data_Query_Result_Clip_Tool = class(TZDB2_FFMPEG_Data_Query_Result_Clip_Tool_Decl)
  public
    procedure DoFree(var Data: TZDB2_FFMPEG_Data_Query_Result); override;
    procedure Extract_Source(Source: TZDB2_FFMPEG_Data_Query_Result);
    procedure Extract_clip(Source: TZDB2_FFMPEG_Data_Query_Result);
    procedure Remove_From_Time(First_Time_Minute_Span: Double);
  end;

  TZDB2_FFMPEG_Engine_Marshal__ = class(TZDB2_Th_Engine_Marshal)
  public
    Owner_FFMPEG_Data_Marshal__: TZDB2_FFMPEG_Data_Marshal;
    // large-data external-header support
    procedure Prepare_Flush_External_Header(Th_Engine_: TZDB2_Th_Engine; var Sequence_Table: TZDB2_BlockHandle; Flush_Instance_Pool: TZDB2_Th_Engine_Data_Instance_Pool; External_Header_Data_: TMem64); override;
    procedure Do_Extract_Th_Eng(ThSender: TCompute); virtual;
    procedure Extract_External_Header(var Extract_Done: Boolean); virtual;
  end;

  TZDB2_FFMPEG_Data_Time_Optimize_Tool = TMinutes_Buffer_Pool<TZDB2_FFMPEG_Data>;

  TZDB2_FFMPEG_Data_Marshal = class(TCore_Object_Intermediate)
  private
    FCurrent_Sequence_ID: Int64;
    Update_Analysis_Data_Is_Busy: Boolean;
    procedure Do_Th_Data_Loaded(Sender: TZDB2_Th_Engine_Data; IO_: TMS64);
    procedure Do_Th_Block_Loaded(Sender: TZDB2_Th_Engine_Data; IO_: TMem64);
    function Do_Sort_By_Sequence_ID(var L, R: TZDB2_Th_Engine_Data): Integer;
  public
    Critical: TCritical;
    ZDB2_Eng: TZDB2_FFMPEG_Engine_Marshal__;
    Sequence_ID_Pool: TZDB2_FFMPEG_Data_Sequence_ID_Pool;
    Source_Analysis, clip_Analysis: TFFMPEG_Data_Analysis_Hash_Pool;
    Time_Search_Optimize: TZDB2_FFMPEG_Data_Time_Optimize_Tool;
    constructor Create;
    destructor Destroy; override;
    // build memory db
    function BuildMemory(): TZDB2_Th_Engine;
    // if encrypt=true defualt password 'DTC40@ZSERVER'
    function BuildOrOpen(FileName_: U_String; OnlyRead_, Encrypt_: Boolean): TZDB2_Th_Engine; overload;
    // if encrypt=true defualt password 'DTC40@ZSERVER'
    function BuildOrOpen(FileName_: U_String; OnlyRead_, Encrypt_: Boolean; cfg: THashStringList): TZDB2_Th_Engine; overload;
    function Begin_Custom_Build: TZDB2_Th_Engine;
    function End_Custom_Build(Eng_: TZDB2_Th_Engine): Boolean;
    // extract data
    procedure Extract_Video_Data_Pool(Full_Data_Load_: Boolean; ThNum_: Integer);
    // add data
    function Add_Video_Data(
      Source, clip: U_String;
      PSF: Double; // per second frame
      Begin_Frame_ID, End_Frame_ID: Int64; // frame id
      Begin_Time, End_Time: TDateTime; // time range
      const body: TMS64): TZDB2_FFMPEG_Data; overload;
    // pack format: 0=head 1=h264
    function Add_Video_Data(pack_: TMS64): TZDB2_FFMPEG_Data; overload;
    // query
    function Query_Video_Data_Full_Matched(Instance_protected: Boolean;
      Source: U_String; Begin_Time, End_Time: TDateTime): TZDB2_FFMPEG_Data_Query_Result; // query range time
    function Query_Video_Data(Instance_protected: Boolean;
      Source, clip: U_String; Begin_Time, End_Time: TDateTime): TZDB2_FFMPEG_Data_Query_Result; overload; // query range time
    function Query_Video_Data(Instance_protected: Boolean;
      Source, clip: U_String; Time_: TDateTime): TZDB2_FFMPEG_Data_Query_Result; overload; // query single time
    // update analysis data
    procedure Do_Update_Analysis_Data();
    procedure Update_Analysis_Data();
    // clear all
    procedure Clear(Delete_Data_: Boolean);
    // check recycle pool
    procedure Check_Recycle_Pool;
    // progress
    function Progress: Boolean;
    // backup
    procedure Backup(Reserve_: Word);
    procedure Backup_If_No_Exists();
    // flush
    procedure Flush; overload;
    procedure Flush(WaitQueue_: Boolean); overload;
    function Flush_Is_Busy: Boolean;
    // fragment number
    function Num: NativeInt;
    // recompute totalfragment number
    function Total: NativeInt;
    // database space state
    function Database_Size: Int64;
    function Database_Physics_Size: Int64;
    // RemoveDatabaseOnDestroy
    function GetRemoveDatabaseOnDestroy: Boolean;
    procedure SetRemoveDatabaseOnDestroy(const Value: Boolean);
    property RemoveDatabaseOnDestroy: Boolean read GetRemoveDatabaseOnDestroy write SetRemoveDatabaseOnDestroy;
    // wait queue
    procedure Wait();
  end;

implementation

constructor TZDB2_FFMPEG_Data_Head.Create;
begin
  inherited Create;
  Reset();
end;

destructor TZDB2_FFMPEG_Data_Head.Destroy;
begin
  Source := '';
  clip := '';
  inherited Destroy;
end;

procedure TZDB2_FFMPEG_Data_Head.Reset;
begin
  Source := '';
  clip := '';
  PSF := 0;
  Begin_Frame_ID := 0;
  End_Frame_ID := 0;
  Begin_Time := 0;
  End_Time := 0;
end;

procedure TZDB2_FFMPEG_Data_Head.Assign(source_: TZDB2_FFMPEG_Data_Head);
begin
  Source := source_.Source;
  clip := source_.clip;
  PSF := source_.PSF;
  Begin_Frame_ID := source_.Begin_Frame_ID;
  End_Frame_ID := source_.End_Frame_ID;
  Begin_Time := source_.Begin_Time;
  End_Time := source_.End_Time;
end;

procedure TZDB2_FFMPEG_Data_Head.Encode(m64: TMS64);
begin
  m64.WriteString(Source);
  m64.WriteString(clip);
  m64.WriteDouble(PSF);
  m64.WriteInt64(Begin_Frame_ID);
  m64.WriteInt64(End_Frame_ID);
  m64.WriteDouble(Begin_Time);
  m64.WriteDouble(End_Time);
end;

procedure TZDB2_FFMPEG_Data_Head.Encode(m64: TMem64);
begin
  m64.WriteString(Source);
  m64.WriteString(clip);
  m64.WriteDouble(PSF);
  m64.WriteInt64(Begin_Frame_ID);
  m64.WriteInt64(End_Frame_ID);
  m64.WriteDouble(Begin_Time);
  m64.WriteDouble(End_Time);
end;

procedure TZDB2_FFMPEG_Data_Head.Decode(m64: TMS64);
begin
  Source := m64.ReadString;
  clip := m64.ReadString;
  PSF := m64.ReadDouble;
  Begin_Frame_ID := m64.ReadInt64;
  End_Frame_ID := m64.ReadInt64;
  Begin_Time := m64.ReadDouble;
  End_Time := m64.ReadDouble;
end;

procedure TZDB2_FFMPEG_Data_Head.Decode(m64: TMem64);
begin
  Source := m64.ReadString;
  clip := m64.ReadString;
  PSF := m64.ReadDouble;
  Begin_Frame_ID := m64.ReadInt64;
  End_Frame_ID := m64.ReadInt64;
  Begin_Time := m64.ReadDouble;
  End_Time := m64.ReadDouble;
end;

function TZDB2_FFMPEG_Data_Head.Get_Time_Tick_Long: TTimeTick;
begin
  Result := Round(MilliSecondSpan(Begin_Time, End_Time));
end;

function TZDB2_FFMPEG_Data_Head.Frame_ID_As_Time(ID: Int64): TDateTime;
begin
  Result := IncMilliSecond(Begin_Time, Round((ID - Begin_Frame_ID) / PSF * 1000));
end;

function TZDB2_FFMPEG_Data_Head.Get_Task_Time_Stamp: Int64;
begin
  if clip.Exists('-') then
      Result := umlStrToInt64(umlGetLastStr(clip, '-'))
  else
      Result := 0;
end;

constructor TZDB2_FFMPEG_Data.Create;
begin
  inherited Create;
  FSequence_ID := 0;
  Owner_FFMPEG_Data_Marshal := nil;
  Head := TZDB2_FFMPEG_Data_Head.Create;
  FH264_Data_Position := 0;
end;

destructor TZDB2_FFMPEG_Data.Destroy;
begin
  if Owner_FFMPEG_Data_Marshal <> nil then
    begin
      Owner_FFMPEG_Data_Marshal.Critical.Lock;
      Owner_FFMPEG_Data_Marshal.Sequence_ID_Pool.Delete(FSequence_ID);
      Owner_FFMPEG_Data_Marshal.Source_Analysis.IncValue(Head.Source, -1);
      Owner_FFMPEG_Data_Marshal.clip_Analysis.IncValue(Head.clip, -1);
      Owner_FFMPEG_Data_Marshal.Time_Search_Optimize.Remove_Span(self);
      Owner_FFMPEG_Data_Marshal.Critical.UnLock;
      Owner_FFMPEG_Data_Marshal := nil;
    end;
  DisposeObject(Head);
  inherited Destroy;
end;

procedure TZDB2_FFMPEG_Data.Do_Remove;
begin
  if Owner_FFMPEG_Data_Marshal <> nil then
    begin
      Owner_FFMPEG_Data_Marshal.Critical.Lock;
      Owner_FFMPEG_Data_Marshal.Source_Analysis.IncValue_Size(Head.Source, 0, -DataSize);
      Owner_FFMPEG_Data_Marshal.clip_Analysis.IncValue_Size(Head.clip, 0, -DataSize);
      Owner_FFMPEG_Data_Marshal.Critical.UnLock;
    end;
end;

function TZDB2_FFMPEG_Data.Sync_Get_H264_Head_And_Data: TMS64;
var
  tmp: TMS64;
begin
  Result := nil;
  tmp := TMS64.Create;
  if Load_Data(tmp) then
    begin
      Result := TMS64.Create;
      Result.WritePtr(tmp.PosAsPtr(8), tmp.Size - 8);;
      Result.Position := 0;
    end;
  DisposeObject(tmp);
end;

procedure TZDB2_FFMPEG_Data.Encode_External_Header_Data(External_Header_Data: TMem64);
begin
  External_Header_Data.WriteInt64(FSequence_ID);
  External_Header_Data.WriteInt64(FH264_Data_Position);
  Head.Encode(External_Header_Data);
end;

procedure TZDB2_FFMPEG_Data.Decode_External_Header_Data(External_Header_Data: TMem64);
begin
  FSequence_ID := External_Header_Data.ReadInt64;
  FH264_Data_Position := External_Header_Data.ReadInt64;
  Head.Decode(External_Header_Data);
  Do_Ready;
end;

class function TFFMPEG_Data_Analysis_Struct.Null_: TFFMPEG_Data_Analysis_Struct;
begin
  Result.Num := 0;
  Result.FirstTime := 0;
  Result.LastTime := 0;
  Result.Size := 0;
end;

procedure TFFMPEG_Data_Analysis_Hash_Pool.IncValue(Key_: SystemString; Value_: Integer);
var
  p: TFFMPEG_Data_Analysis_Hash_Pool_Decl.PValue;
begin
  p := Get_Value_Ptr(Key_);
  if p^.Num = 0 then
    begin
      p^.FirstTime := umlNow();
      p^.LastTime := p^.FirstTime;
    end;
  Inc(p^.Num, Value_);
end;

procedure TFFMPEG_Data_Analysis_Hash_Pool.IncValue_Size(Key_: SystemString; Value_: Integer; Size: Int64);
var
  p: TFFMPEG_Data_Analysis_Hash_Pool_Decl.PValue;
begin
  p := Get_Value_Ptr(Key_);
  Inc(p^.Num, Value_);
  Inc(p^.Size, Size);
end;

procedure TFFMPEG_Data_Analysis_Hash_Pool.IncValue(Key_: SystemString; Value_: Integer; FirstTime, LastTime: TDateTime; Size: Int64);
var
  p: TFFMPEG_Data_Analysis_Hash_Pool_Decl.PValue;
begin
  p := Get_Value_Ptr(Key_);
  if (p^.Num = 0) or (CompareDateTime(FirstTime, p^.FirstTime) < 0) then
      p^.FirstTime := FirstTime;
  if (p^.Num = 0) or (CompareDateTime(LastTime, p^.LastTime) > 0) then
      p^.LastTime := LastTime;
  Inc(p^.Num, Value_);
  Inc(p^.Size, Size);
end;

procedure TFFMPEG_Data_Analysis_Hash_Pool.IncValue(Source: TFFMPEG_Data_Analysis_Hash_Pool);
var
  __repeat__: TFFMPEG_Data_Analysis_Hash_Pool_Decl.TRepeat___;
begin
  if Source.Num <= 0 then
      exit;
  __repeat__ := Source.Repeat_;
  repeat
      IncValue(__repeat__.Queue^.Data^.Data.Primary,
      __repeat__.Queue^.Data^.Data.Second.Num,
      __repeat__.Queue^.Data^.Data.Second.FirstTime,
      __repeat__.Queue^.Data^.Data.Second.LastTime,
      __repeat__.Queue^.Data^.Data.Second.Size
      );
  until not __repeat__.Next;
end;

procedure TFFMPEG_Data_Analysis_Hash_Pool.GetKeyList(output: TPascalStringList);
var
  __repeat__: TFFMPEG_Data_Analysis_Hash_Pool_Decl.TRepeat___;
begin
  if Num <= 0 then
      exit;
  __repeat__ := Repeat_;
  repeat
      output.Add(__repeat__.Queue^.Data^.Data.Primary);
  until not __repeat__.Next;
end;

procedure TFFMPEG_Data_Analysis_Hash_Pool.GetKeyList(output: TCore_Strings);
var
  __repeat__: TFFMPEG_Data_Analysis_Hash_Pool_Decl.TRepeat___;
begin
  if Num <= 0 then
      exit;
  __repeat__ := Repeat_;
  repeat
      output.Add(__repeat__.Queue^.Data^.Data.Primary);
  until not __repeat__.Next;
end;

function TFFMPEG_Data_Analysis_Hash_Pool.GetKeyArry: U_StringArray;
var
  __repeat__: TFFMPEG_Data_Analysis_Hash_Pool_Decl.TRepeat___;
begin
  SetLength(Result, Num);
  if Num <= 0 then
      exit;
  __repeat__ := Repeat_;
  repeat
      Result[__repeat__.I__] := __repeat__.Queue^.Data^.Data.Primary;
  until not __repeat__.Next;
end;

procedure TFFMPEG_Data_Analysis_Hash_Pool.Get_Key_Num_List(output: THashVariantList);
var
  __repeat__: TFFMPEG_Data_Analysis_Hash_Pool_Decl.TRepeat___;
begin
  if Num <= 0 then
      exit;
  __repeat__ := Repeat_;
  repeat
      output.Add(__repeat__.Queue^.Data^.Data.Primary, __repeat__.Queue^.Data^.Data.Second.Num);
  until not __repeat__.Next;
end;

procedure TFFMPEG_Data_Analysis_Hash_Pool.Get_Key_Num_And_Time_List(output: THashStringList);
var
  __repeat__: TFFMPEG_Data_Analysis_Hash_Pool_Decl.TRepeat___;
begin
  if Num <= 0 then
      exit;
  __repeat__ := Repeat_;
  repeat
      output.Add(__repeat__.Queue^.Data^.Data.Primary,
      PFormat('%d,%s', [__repeat__.Queue^.Data^.Data.Second.Num,
          umlDateTimeToStr(__repeat__.Queue^.Data^.Data.Second.LastTime).Text]));
  until not __repeat__.Next;
end;

procedure TFFMPEG_Data_Analysis_Hash_Pool.Get_Key_Num_And_Time_And_Size_List(output: THashStringList);
var
  __repeat__: TFFMPEG_Data_Analysis_Hash_Pool_Decl.TRepeat___;
begin
  if Num <= 0 then
      exit;
  __repeat__ := Repeat_;
  repeat
      output.Add(__repeat__.Queue^.Data^.Data.Primary,
      PFormat('%d,%s,%s,%d', [__repeat__.Queue^.Data^.Data.Second.Num,
          umlDateTimeToStr(__repeat__.Queue^.Data^.Data.Second.FirstTime).Text,
          umlDateTimeToStr(__repeat__.Queue^.Data^.Data.Second.LastTime).Text,
          __repeat__.Queue^.Data^.Data.Second.Size]));
  until not __repeat__.Next;
end;

function TZDB2_FFMPEG_Data_Query_Result.Do_Sort_By_Source_Clip_Time(var L, R: TZDB2_FFMPEG_Data): Integer;
begin
  Result := umlCompareText(L.Head.Source, R.Head.Source);
  if Result = 0 then
    begin
      Result := umlCompareText(L.Head.clip, R.Head.clip);
      if Result = 0 then
          Result := CompareDateTime(L.Head.Begin_Time, R.Head.Begin_Time);
    end;
end;

function TZDB2_FFMPEG_Data_Query_Result.Do_Sort_By_Source_Time(var L, R: TZDB2_FFMPEG_Data): Integer;
begin
  Result := umlCompareText(L.Head.Source, R.Head.Source);
  if Result = 0 then
      Result := CompareDateTime(L.Head.Begin_Time, R.Head.Begin_Time);
end;

function TZDB2_FFMPEG_Data_Query_Result.Do_Sort_By_Time(var L, R: TZDB2_FFMPEG_Data): Integer;
begin
  Result := CompareDateTime(L.Head.Begin_Time, R.Head.Begin_Time);
end;

constructor TZDB2_FFMPEG_Data_Query_Result.Create;
begin
  inherited Create;
  FInstance_protected := False;
  Source_Analysis := TFFMPEG_Data_Analysis_Hash_Pool.Create($FF, TFFMPEG_Data_Analysis_Struct.Null_);
  clip_Analysis := TFFMPEG_Data_Analysis_Hash_Pool.Create($FF, TFFMPEG_Data_Analysis_Struct.Null_);
end;

destructor TZDB2_FFMPEG_Data_Query_Result.Destroy;
begin
  Clear;
  DisposeObjectAndNil(Source_Analysis);
  DisposeObjectAndNil(clip_Analysis);
  inherited Destroy;
end;

procedure TZDB2_FFMPEG_Data_Query_Result.DoFree(var Data: TZDB2_FFMPEG_Data);
begin
  if Data <> nil then
    begin
      if Source_Analysis <> nil then
          Source_Analysis.IncValue(Data.Head.Source, -1);
      if clip_Analysis <> nil then
          clip_Analysis.IncValue(Data.Head.clip, -1);
      if FInstance_protected then
        begin
          Data.Update_Instance_As_Free;
          Data := nil;
        end;
    end;
  inherited DoFree(Data);
end;

procedure TZDB2_FFMPEG_Data_Query_Result.DoAdd(var Data: TZDB2_FFMPEG_Data);
begin
  if Data <> nil then
    begin
      if Source_Analysis <> nil then
          Source_Analysis.IncValue(Data.Head.Source, 1);
      if clip_Analysis <> nil then
          clip_Analysis.IncValue(Data.Head.clip, 1);
      if FInstance_protected then
          Data.Update_Instance_As_Busy;
    end;
  inherited DoAdd(Data);
end;

procedure TZDB2_FFMPEG_Data_Query_Result.Sort_By_Source_Clip_Time;
begin
  Sort_M(Do_Sort_By_Source_Clip_Time);
end;

procedure TZDB2_FFMPEG_Data_Query_Result.Sort_By_Source_Time;
begin
  Sort_M(Do_Sort_By_Source_Time);
end;

procedure TZDB2_FFMPEG_Data_Query_Result.Sort_By_Time;
begin
  Sort_M(Do_Sort_By_Time);
end;

function TZDB2_FFMPEG_Data_Query_Result.Extract_Source(Source: U_String; removed_: Boolean): TZDB2_FFMPEG_Data_Query_Result;
begin
  Result := TZDB2_FFMPEG_Data_Query_Result.Create;
  Result.FInstance_protected := FInstance_protected;
  if Num > 0 then
    begin
      with Repeat_ do
        repeat
          if Source.Same(@Queue^.Data.Head.Source) then
            begin
              Result.Add(Queue^.Data);
              if removed_ then
                  Push_To_Recycle_Pool(Queue);
            end;
        until not Next;
      Free_Recycle_Pool;
    end;
end;

function TZDB2_FFMPEG_Data_Query_Result.Extract_clip(clip: U_String; removed_: Boolean): TZDB2_FFMPEG_Data_Query_Result;
begin
  Result := TZDB2_FFMPEG_Data_Query_Result.Create;
  Result.FInstance_protected := FInstance_protected;
  if Num > 0 then
    begin
      with Repeat_ do
        repeat
          if clip.Same(@Queue^.Data.Head.clip) then
            begin
              Result.Add(Queue^.Data);
              if removed_ then
                  Push_To_Recycle_Pool(Queue);
            end;
        until not Next;
      Free_Recycle_Pool;
    end;
end;

procedure TZDB2_FFMPEG_Data_Query_Result_Clip_Tool.DoFree(var Data: TZDB2_FFMPEG_Data_Query_Result);
begin
  DisposeObjectAndNil(Data);
  inherited DoFree(Data);
end;

procedure TZDB2_FFMPEG_Data_Query_Result_Clip_Tool.Extract_Source(Source: TZDB2_FFMPEG_Data_Query_Result);
begin
  Clear;
  if Source.Source_Analysis.Num > 0 then
    with Source.Source_Analysis.Repeat_ do
      repeat
          self.Add(Source.Extract_Source(Queue^.Data^.Data.Primary, True));
      until not Next;
end;

procedure TZDB2_FFMPEG_Data_Query_Result_Clip_Tool.Extract_clip(Source: TZDB2_FFMPEG_Data_Query_Result);

  procedure do_exctract_tmp_frag_clip_and_free(tmp: TZDB2_FFMPEG_Data_Query_Result);
  begin
    if tmp.clip_Analysis.Num > 0 then
      begin
        with tmp.clip_Analysis.Repeat_ do
          repeat
              Add(tmp.Extract_clip(Queue^.Data^.Data.Primary, True));
          until not Next;
      end;
    DisposeObject(tmp);
  end;

begin
  Clear;
  if Source.Source_Analysis.Num > 0 then
    with Source.Source_Analysis.Repeat_ do
      repeat
          do_exctract_tmp_frag_clip_and_free(Source.Extract_Source(Queue^.Data^.Data.Primary, True));
      until not Next;
end;

procedure TZDB2_FFMPEG_Data_Query_Result_Clip_Tool.Remove_From_Time(First_Time_Minute_Span: Double);

  procedure Do_Check_Time(tmp: TZDB2_FFMPEG_Data_Query_Result);
  begin
    if tmp.Num > 0 then
      begin
        tmp.Sort_By_Time;
        with tmp.Repeat_ do
          repeat
            if Queue <> tmp.First then
              begin
                if MinuteSpan(tmp.First^.Data.Head.Begin_Time, Queue^.Data.Head.End_Time) > First_Time_Minute_Span then
                    tmp.Push_To_Recycle_Pool(Queue);
              end;
          until not Next;
        tmp.Free_Recycle_Pool;
      end;
  end;

begin
  if Num > 0 then
    with Repeat_ do
      repeat
          Do_Check_Time(Queue^.Data);
      until not Next;
end;

procedure TZDB2_FFMPEG_Engine_Marshal__.Prepare_Flush_External_Header(Th_Engine_: TZDB2_Th_Engine; var Sequence_Table: TZDB2_BlockHandle; Flush_Instance_Pool: TZDB2_Th_Engine_Data_Instance_Pool; External_Header_Data_: TMem64);
var
  tmp: TMem64;
begin
  if Flush_Instance_Pool.Num <= 0 then
      exit;

  External_Header_Data_.Clear;
  External_Header_Data_.WriteInt64(Flush_Instance_Pool.Num);
  with Flush_Instance_Pool.Repeat_ do
    repeat
      External_Header_Data_.WriteInt32(Queue^.Data.ID);
      tmp := TMem64.CustomCreate(1536);
      TZDB2_FFMPEG_Data(Queue^.Data).Encode_External_Header_Data(tmp);
      External_Header_Data_.WriteInt32(tmp.Size);
      External_Header_Data_.WritePtr(tmp.Memory, tmp.Size);
      DisposeObject(tmp);
    until not Next;
end;

procedure TZDB2_FFMPEG_Engine_Marshal__.Do_Extract_Th_Eng(ThSender: TCompute);
var
  Eng_: TZDB2_Th_Engine;
  Error_Num: PInt64;
  num_: Int64;
  ID_: Integer;
  siz_: Integer;
  Inst_: TZDB2_FFMPEG_Data;
  tmp: TMem64;
begin
  Eng_ := ThSender.UserObject as TZDB2_Th_Engine;
  Error_Num := ThSender.UserData;

  Eng_.External_Header_Data.Position := 0;
  num_ := Eng_.External_Header_Data.ReadInt64;

  while num_ > 0 do
    begin
      ID_ := Eng_.External_Header_Data.ReadInt32;
      Inst_ := TZDB2_FFMPEG_Data(Eng_.Th_Engine_ID_Data_Pool[ID_]);
      if Inst_ = nil then
        begin
          AtomInc(Error_Num^);
          break;
        end;
      try
        Inst_.Owner_FFMPEG_Data_Marshal := Owner_FFMPEG_Data_Marshal__;
        siz_ := Eng_.External_Header_Data.ReadInt32;
        tmp := TMem64.Create;
        tmp.Mapping(Eng_.External_Header_Data.PosAsPtr, siz_);
        Inst_.Decode_External_Header_Data(tmp);
        DisposeObject(tmp);
        Eng_.External_Header_Data.Position := Eng_.External_Header_Data.Position + siz_;
      except
        AtomInc(Error_Num^);
        break;
      end;
      dec(num_);
    end;
end;

procedure TZDB2_FFMPEG_Engine_Marshal__.Extract_External_Header(var Extract_Done: Boolean);
var
  Error_Num: Int64;

  function Check_External_Header: NativeInt;
  begin
    { external-header optimize tech }
    Result := 0;
    if Engine_Pool.Num > 0 then
      with Engine_Pool.Repeat_ do
        repeat
          if Queue^.Data.External_Header_Data.Size >= 8 then
              Inc(Result);
        until not Next;
  end;

var
  Signal_: TBool_Signal_Array;
begin
  Extract_Done := False;
  Error_Num := 0;
  if Check_External_Header <> Engine_Pool.Num then
      exit;
  if Engine_Pool.Num > 0 then
    begin
      SetLength(Signal_, Engine_Pool.Num);
      with Engine_Pool.Repeat_ do
        repeat
            TCompute.RunM(@Error_Num, Queue^.Data, Do_Extract_Th_Eng, @Signal_[I__], nil);
        until not Next;
      Wait_All_Signal(Signal_, False);
    end;
  Extract_Done := Error_Num = 0;
end;

procedure TZDB2_FFMPEG_Data_Marshal.Do_Th_Data_Loaded(Sender: TZDB2_Th_Engine_Data; IO_: TMS64);
var
  obj_: TZDB2_FFMPEG_Data;
begin
  obj_ := Sender as TZDB2_FFMPEG_Data;
  obj_.Owner_FFMPEG_Data_Marshal := self;

  IO_.Position := 0;
  obj_.FSequence_ID := IO_.ReadInt64; // sequence id
  obj_.Head.Decode(IO_); // head info
  obj_.FH264_Data_Position := IO_.Position; // data body
end;

procedure TZDB2_FFMPEG_Data_Marshal.Do_Th_Block_Loaded(Sender: TZDB2_Th_Engine_Data; IO_: TMem64);
var
  obj_: TZDB2_FFMPEG_Data;
begin
  obj_ := Sender as TZDB2_FFMPEG_Data;
  obj_.Owner_FFMPEG_Data_Marshal := self;

  IO_.Position := 0;
  obj_.FSequence_ID := IO_.ReadInt64; // sequence id
  obj_.Head.Decode(IO_); // head info
  obj_.FH264_Data_Position := IO_.Position; // data body
end;

function TZDB2_FFMPEG_Data_Marshal.Do_Sort_By_Sequence_ID(var L, R: TZDB2_Th_Engine_Data): Integer;
begin
  Result := CompareInt64(TZDB2_FFMPEG_Data(L).FSequence_ID, TZDB2_FFMPEG_Data(R).FSequence_ID);
end;

constructor TZDB2_FFMPEG_Data_Marshal.Create;
begin
  inherited Create;
  FCurrent_Sequence_ID := 1;
  Update_Analysis_Data_Is_Busy := False;
  Critical := TCritical.Create;
  ZDB2_Eng := TZDB2_FFMPEG_Engine_Marshal__.Create(self);
  ZDB2_Eng.Current_Data_Class := TZDB2_FFMPEG_Data;
  ZDB2_Eng.Owner_FFMPEG_Data_Marshal__ := self;
  Sequence_ID_Pool := TZDB2_FFMPEG_Data_Sequence_ID_Pool.Create($FFFF, nil);
  Source_Analysis := TFFMPEG_Data_Analysis_Hash_Pool.Create($FFFF, TFFMPEG_Data_Analysis_Struct.Null_);
  clip_Analysis := TFFMPEG_Data_Analysis_Hash_Pool.Create(1024 * 1024, TFFMPEG_Data_Analysis_Struct.Null_);
  Time_Search_Optimize := TZDB2_FFMPEG_Data_Time_Optimize_Tool.Create($FFFF);
  Time_Search_Optimize.Level_2_Hash_Size := 1024;
end;

destructor TZDB2_FFMPEG_Data_Marshal.Destroy;
begin
  Sequence_ID_Pool.Clear;
  DisposeObject(ZDB2_Eng);
  DisposeObject(Sequence_ID_Pool);
  DisposeObject(Source_Analysis);
  DisposeObject(clip_Analysis);
  DisposeObject(Time_Search_Optimize);
  DisposeObject(Critical);
  inherited Destroy;
end;

function TZDB2_FFMPEG_Data_Marshal.BuildMemory(): TZDB2_Th_Engine;
begin
  Result := TZDB2_Th_Engine.Create(ZDB2_Eng);
  Result.Cache_Mode := smBigData;
  Result.Database_File := '';
  Result.OnlyRead := False;
  Result.Cipher_Security := TCipherSecurity.csNone;
  Result.Build(ZDB2_Eng.Current_Data_Class);
end;

function TZDB2_FFMPEG_Data_Marshal.BuildOrOpen(FileName_: U_String; OnlyRead_, Encrypt_: Boolean): TZDB2_Th_Engine;
begin
  Result := TZDB2_Th_Engine.Create(ZDB2_Eng);
  Result.Cache_Mode := smNormal;
  Result.Database_File := FileName_;
  Result.OnlyRead := OnlyRead_;

  if Encrypt_ then
      Result.Cipher_Security := TCipherSecurity.csRijndael
  else
      Result.Cipher_Security := TCipherSecurity.csNone;

  Result.Build(ZDB2_Eng.Current_Data_Class);
  if not Result.Ready then
    begin
      DisposeObjectAndNil(Result);
      Result := BuildMemory();
    end;
end;

function TZDB2_FFMPEG_Data_Marshal.BuildOrOpen(FileName_: U_String; OnlyRead_, Encrypt_: Boolean; cfg: THashStringList): TZDB2_Th_Engine;
begin
  Result := TZDB2_Th_Engine.Create(ZDB2_Eng);
  Result.Cache_Mode := smNormal;
  Result.Database_File := FileName_;
  Result.OnlyRead := OnlyRead_;
  if cfg <> nil then
      Result.ReadConfig(FileName_, cfg);

  if Encrypt_ then
      Result.Cipher_Security := TCipherSecurity.csRijndael
  else
      Result.Cipher_Security := TCipherSecurity.csNone;

  Result.Build(ZDB2_Eng.Current_Data_Class);
  if not Result.Ready then
    begin
      DisposeObjectAndNil(Result);
      Result := BuildMemory();
    end;
end;

function TZDB2_FFMPEG_Data_Marshal.Begin_Custom_Build: TZDB2_Th_Engine;
begin
  Result := TZDB2_Th_Engine.Create(ZDB2_Eng);
end;

function TZDB2_FFMPEG_Data_Marshal.End_Custom_Build(Eng_: TZDB2_Th_Engine): Boolean;
begin
  Eng_.Build(ZDB2_Eng.Current_Data_Class);
  Result := Eng_.Ready;
end;

procedure TZDB2_FFMPEG_Data_Marshal.Extract_Video_Data_Pool(Full_Data_Load_: Boolean; ThNum_: Integer);
var
  Extract_Done: Boolean;
  __repeat__: TFFMPEG_Data_Analysis_Hash_Pool_Decl.TRepeat___;
begin
  Extract_Done := False;
  ZDB2_Eng.Extract_External_Header(Extract_Done); { external-header optimize tech }
  if not Extract_Done then
    begin
      if Full_Data_Load_ then
          ZDB2_Eng.Parallel_Load_M(ThNum_, Do_Th_Data_Loaded, nil)
      else
          ZDB2_Eng.Parallel_Block_Load_M(ThNum_, 0, 0, 2000, Do_Th_Block_Loaded, nil);
    end;

  FCurrent_Sequence_ID := 1;
  Sequence_ID_Pool.Clear;
  Time_Search_Optimize.Clear;
  if ZDB2_Eng.Data_Marshal.Num > 0 then
    begin
      Critical.Lock;
      // compute analysis
      with ZDB2_Eng.Data_Marshal.Repeat_ do
        repeat
          Sequence_ID_Pool.Add(TZDB2_FFMPEG_Data(Queue^.Data).FSequence_ID, TZDB2_FFMPEG_Data(Queue^.Data), False);
          Source_Analysis.IncValue(TZDB2_FFMPEG_Data(Queue^.Data).Head.Source, 1, TZDB2_FFMPEG_Data(Queue^.Data).Head.Begin_Time, TZDB2_FFMPEG_Data(Queue^.Data).Head.End_Time, TZDB2_FFMPEG_Data(Queue^.Data).DataSize);
          clip_Analysis.IncValue(TZDB2_FFMPEG_Data(Queue^.Data).Head.clip, 1, TZDB2_FFMPEG_Data(Queue^.Data).Head.Begin_Time, TZDB2_FFMPEG_Data(Queue^.Data).Head.End_Time, TZDB2_FFMPEG_Data(Queue^.Data).DataSize);
          // search optimize
          Time_Search_Optimize.Add_Span(TZDB2_FFMPEG_Data(Queue^.Data).Head.Begin_Time, TZDB2_FFMPEG_Data(Queue^.Data).Head.End_Time, TZDB2_FFMPEG_Data(Queue^.Data));
        until not Next;
      ZDB2_Eng.Sort_M(Do_Sort_By_Sequence_ID);
      FCurrent_Sequence_ID := TZDB2_FFMPEG_Data(ZDB2_Eng.Data_Marshal.Last^.Data).FSequence_ID + 1;
      Critical.UnLock;

      if Source_Analysis.Num > 0 then
        begin
          __repeat__ := Source_Analysis.Repeat_;
          repeat
              DoStatus('source:"%s" fragment analysis:%d last time %s', [
                __repeat__.Queue^.Data^.Data.Primary,
                __repeat__.Queue^.Data^.Data.Second.Num,
                DateTimeToStr(__repeat__.Queue^.Data^.Data.Second.LastTime)]);
          until not __repeat__.Next;
        end;

      DoStatus('finish compute analysis and rebuild sequence, total num:%d, classifier/clip:%d/%d, last sequence id:%d',
        [ZDB2_Eng.Data_Marshal.Num, Source_Analysis.Num, clip_Analysis.Num, FCurrent_Sequence_ID]);
    end;
end;

function TZDB2_FFMPEG_Data_Marshal.Add_Video_Data(
  Source, clip: U_String;
  PSF: Double; // per second frame
  Begin_Frame_ID, End_Frame_ID: Int64; // frame id
  Begin_Time, End_Time: TDateTime; // time range
  const body: TMS64): TZDB2_FFMPEG_Data;
var
  tmp: TMS64;
begin
  Critical.Lock;
  Result := ZDB2_Eng.Add_Data_To_Minimize_Size_Engine as TZDB2_FFMPEG_Data;
  if Result <> nil then
    begin
      Result.Owner_FFMPEG_Data_Marshal := self;
      // update sequence id
      Result.FSequence_ID := FCurrent_Sequence_ID;
      Inc(FCurrent_Sequence_ID);

      // extract video info
      Result.Head.Source := Source;
      Result.Head.clip := clip;
      Result.Head.PSF := PSF;
      Result.Head.Begin_Frame_ID := Begin_Frame_ID;
      Result.Head.End_Frame_ID := End_Frame_ID;
      Result.Head.Begin_Time := Begin_Time;
      Result.Head.End_Time := End_Time;

      // rebuild sequence memory
      tmp := TMS64.Create;
      tmp.WriteInt64(Result.FSequence_ID);
      Result.Head.Encode(tmp);
      Result.FH264_Data_Position := tmp.Position; // update data postion
      Result.Async_Save_And_Free_Combine_Memory([tmp, body]);

      // update sequence-id pool
      Sequence_ID_Pool.Add(Result.FSequence_ID, Result, False);

      // compute time analysis
      Source_Analysis.IncValue(Result.Head.Source, 1, Result.Head.Begin_Time, Result.Head.End_Time, Result.DataSize);
      clip_Analysis.IncValue(Result.Head.clip, 1, Result.Head.Begin_Time, Result.Head.End_Time, Result.DataSize);
      // search optimize
      Time_Search_Optimize.Add_Span(Result.Head.Begin_Time, Result.Head.End_Time, Result);
    end;
  Critical.UnLock;
end;

function TZDB2_FFMPEG_Data_Marshal.Add_Video_Data(pack_: TMS64): TZDB2_FFMPEG_Data;
var
  tmp: TMS64;
begin
  Critical.Lock;
  Result := ZDB2_Eng.Add_Data_To_Minimize_Size_Engine as TZDB2_FFMPEG_Data;
  if Result <> nil then
    begin
      Result.Owner_FFMPEG_Data_Marshal := self;
      // update sequence id
      Result.FSequence_ID := FCurrent_Sequence_ID;
      Inc(FCurrent_Sequence_ID);

      // extract video info
      pack_.Position := 0;
      Result.Head.Decode(pack_);
      Result.FH264_Data_Position := 8 + pack_.Position; // fixed by.qq600585, 2023-5-3

      // rebuild sequence memory
      tmp := TMS64.Create;
      tmp.WriteInt64(Result.FSequence_ID);
      Result.Async_Save_And_Free_Combine_Memory([tmp, pack_]);

      // update sequence-id pool
      Sequence_ID_Pool.Add(Result.FSequence_ID, Result, False);

      // compute time analysis
      Source_Analysis.IncValue(Result.Head.Source, 1, Result.Head.Begin_Time, Result.Head.End_Time, Result.DataSize);
      clip_Analysis.IncValue(Result.Head.clip, 1, Result.Head.Begin_Time, Result.Head.End_Time, Result.DataSize);
      // search optimize
      Time_Search_Optimize.Add_Span(Result.Head.Begin_Time, Result.Head.End_Time, Result);
    end;
  Critical.UnLock;
end;

function TZDB2_FFMPEG_Data_Marshal.Query_Video_Data_Full_Matched(Instance_protected: Boolean;
  Source: U_String; Begin_Time, End_Time: TDateTime): TZDB2_FFMPEG_Data_Query_Result;
var
  R: TZDB2_FFMPEG_Data_Query_Result;
  L: TZDB2_FFMPEG_Data_Time_Optimize_Tool.TTime_List;
begin
  R := TZDB2_FFMPEG_Data_Query_Result.Create;
  R.FInstance_protected := Instance_protected;

  ZDB2_Eng.Begin_Loop;
  try
    L := Time_Search_Optimize.Search_Span(Begin_Time, End_Time);
    if L.Num > 0 then
      with L.Repeat_ do
        repeat
          if Queue^.Data.Can_Load and Queue^.Data.First_Operation_Ready then
            if DateTimeInRange(Queue^.Data.Head.Begin_Time, Begin_Time, End_Time, True) or
              DateTimeInRange(Queue^.Data.Head.End_Time, Begin_Time, End_Time, True) then
              if Source.Same(Queue^.Data.Head.Source) then
                  R.Add(Queue^.Data);
        until (not Next);
    DisposeObject(L);
  except
  end;
  ZDB2_Eng.End_Loop;
  R.Sort_By_Source_Clip_Time();
  Result := R;
end;

function TZDB2_FFMPEG_Data_Marshal.Query_Video_Data(Instance_protected: Boolean;
  Source, clip: U_String; Begin_Time, End_Time: TDateTime): TZDB2_FFMPEG_Data_Query_Result;
var
  R: TZDB2_FFMPEG_Data_Query_Result;
  L: TZDB2_FFMPEG_Data_Time_Optimize_Tool.TTime_List;
begin
  R := TZDB2_FFMPEG_Data_Query_Result.Create;
  R.FInstance_protected := Instance_protected;

  ZDB2_Eng.Begin_Loop;
  try
    L := Time_Search_Optimize.Search_Span(Begin_Time, End_Time);
    if L.Num > 0 then
      with L.Repeat_ do
        repeat
          if Queue^.Data.Can_Load and Queue^.Data.First_Operation_Ready then
            if DateTimeInRange(Queue^.Data.Head.Begin_Time, Begin_Time, End_Time, True) or
              DateTimeInRange(Queue^.Data.Head.End_Time, Begin_Time, End_Time, True) then
              if umlMultipleMatch(Source, Queue^.Data.Head.Source) and umlMultipleMatch(clip, Queue^.Data.Head.clip) then
                  R.Add(Queue^.Data);
        until (not Next);
    DisposeObject(L);
  except
  end;
  ZDB2_Eng.End_Loop;
  R.Sort_By_Source_Clip_Time();
  Result := R;
end;

function TZDB2_FFMPEG_Data_Marshal.Query_Video_Data(Instance_protected: Boolean;
  Source, clip: U_String; Time_: TDateTime): TZDB2_FFMPEG_Data_Query_Result;
var
  R: TZDB2_FFMPEG_Data_Query_Result;
  L: TZDB2_FFMPEG_Data_Time_Optimize_Tool.TTime_List;
begin
  R := TZDB2_FFMPEG_Data_Query_Result.Create;
  R.FInstance_protected := Instance_protected;

  ZDB2_Eng.Begin_Loop;
  try
    L := Time_Search_Optimize.Search_Span(Time_);
    if L.Num > 0 then
      with L.Repeat_ do
        repeat
          if Queue^.Data.Can_Load and Queue^.Data.First_Operation_Ready
          then
            if DateTimeInRange(Time_, Queue^.Data.Head.Begin_Time, Queue^.Data.Head.End_Time, True) then
              if umlMultipleMatch(Source, Queue^.Data.Head.Source) and umlMultipleMatch(clip, Queue^.Data.Head.clip) then
                  R.Add(Queue^.Data);
        until (not Next);
    DisposeObject(L);
  except
  end;
  ZDB2_Eng.End_Loop;
  R.Sort_By_Source_Clip_Time();
  Result := R;
end;

procedure TZDB2_FFMPEG_Data_Marshal.Do_Update_Analysis_Data;
var
  Source_Analysis__: TFFMPEG_Data_Analysis_Hash_Pool;
  clip_Analysis__: TFFMPEG_Data_Analysis_Hash_Pool;
{$IFDEF FPC}
  procedure fpc_progress_(Sender: TZDB2_Th_Engine_Data; Index: Int64; var Aborted: Boolean);
  begin
    Source_Analysis__.IncValue(TZDB2_FFMPEG_Data(Sender).Head.Source, 1, TZDB2_FFMPEG_Data(Sender).Head.Begin_Time, TZDB2_FFMPEG_Data(Sender).Head.End_Time, TZDB2_FFMPEG_Data(Sender).DataSize);
    clip_Analysis__.IncValue(TZDB2_FFMPEG_Data(Sender).Head.clip, 1, TZDB2_FFMPEG_Data(Sender).Head.Begin_Time, TZDB2_FFMPEG_Data(Sender).Head.End_Time, TZDB2_FFMPEG_Data(Sender).DataSize);
  end;
  procedure fpc_sync_();
  begin
    Critical.Lock;
    DisposeObjectAndNil(Source_Analysis);
    DisposeObjectAndNil(clip_Analysis);
    Source_Analysis := Source_Analysis__;
    clip_Analysis := clip_Analysis__;
    Critical.UnLock;
  end;
{$ENDIF FPC}


begin
  Source_Analysis__ := TFFMPEG_Data_Analysis_Hash_Pool.Create($FFFF, TFFMPEG_Data_Analysis_Struct.Null_);
  clip_Analysis__ := TFFMPEG_Data_Analysis_Hash_Pool.Create(1024 * 1024, TFFMPEG_Data_Analysis_Struct.Null_);

{$IFDEF FPC}
  ZDB2_Eng.Parallel_For_P(False, 0, fpc_progress_);
  TCompute.Sync(fpc_sync_);
{$ELSE FPC}
  ZDB2_Eng.Parallel_For_P(False, 0, procedure(Sender: TZDB2_Th_Engine_Data; Index: Int64; var Aborted: Boolean)
    begin
      Source_Analysis__.IncValue(TZDB2_FFMPEG_Data(Sender).Head.Source, 1, TZDB2_FFMPEG_Data(Sender).Head.Begin_Time, TZDB2_FFMPEG_Data(Sender).Head.End_Time, TZDB2_FFMPEG_Data(Sender).DataSize);
      clip_Analysis__.IncValue(TZDB2_FFMPEG_Data(Sender).Head.clip, 1, TZDB2_FFMPEG_Data(Sender).Head.Begin_Time, TZDB2_FFMPEG_Data(Sender).Head.End_Time, TZDB2_FFMPEG_Data(Sender).DataSize);
    end);
  TCompute.Sync(procedure
    begin
      Critical.Lock;
      DisposeObjectAndNil(Source_Analysis);
      DisposeObjectAndNil(clip_Analysis);
      Source_Analysis := Source_Analysis__;
      clip_Analysis := clip_Analysis__;
      Critical.UnLock;
    end);
{$ENDIF FPC}
  Update_Analysis_Data_Is_Busy := False;
end;

procedure TZDB2_FFMPEG_Data_Marshal.Update_Analysis_Data;
begin
  if Update_Analysis_Data_Is_Busy then
      exit;
  TCompute.RunM_NP(Do_Update_Analysis_Data);
end;

procedure TZDB2_FFMPEG_Data_Marshal.Clear(Delete_Data_: Boolean);
begin
  if ZDB2_Eng.Data_Marshal.Num <= 0 then
      exit;

  if Delete_Data_ then
    begin
      ZDB2_Eng.Wait_Busy_task();
      with ZDB2_Eng.Data_Marshal.Repeat_ do
        repeat
            Queue^.Data.Remove(True);
        until not Next;
      ZDB2_Eng.Wait_Busy_task();
    end
  else
    begin
      ZDB2_Eng.Clear;
    end;
end;

procedure TZDB2_FFMPEG_Data_Marshal.Check_Recycle_Pool;
begin
  ZDB2_Eng.Check_Recycle_Pool;
end;

function TZDB2_FFMPEG_Data_Marshal.Progress: Boolean;
begin
  Result := ZDB2_Eng.Progress;
end;

procedure TZDB2_FFMPEG_Data_Marshal.Backup(Reserve_: Word);
begin
  ZDB2_Eng.Backup(Reserve_);
end;

procedure TZDB2_FFMPEG_Data_Marshal.Backup_If_No_Exists;
begin
  ZDB2_Eng.Backup_If_No_Exists();
end;

procedure TZDB2_FFMPEG_Data_Marshal.Flush;
begin
  ZDB2_Eng.Flush;
end;

procedure TZDB2_FFMPEG_Data_Marshal.Flush(WaitQueue_: Boolean);
begin
  ZDB2_Eng.Flush(WaitQueue_);
end;

function TZDB2_FFMPEG_Data_Marshal.Flush_Is_Busy: Boolean;
begin
  Result := ZDB2_Eng.Flush_Is_Busy;
end;

function TZDB2_FFMPEG_Data_Marshal.Num: NativeInt;
begin
  Result := ZDB2_Eng.Data_Marshal.Num;
end;

function TZDB2_FFMPEG_Data_Marshal.Total: NativeInt;
begin
  Result := ZDB2_Eng.Total;
end;

function TZDB2_FFMPEG_Data_Marshal.Database_Size: Int64;
begin
  Result := ZDB2_Eng.Database_Size;
end;

function TZDB2_FFMPEG_Data_Marshal.Database_Physics_Size: Int64;
begin
  Result := ZDB2_Eng.Database_Physics_Size;
end;

function TZDB2_FFMPEG_Data_Marshal.GetRemoveDatabaseOnDestroy: Boolean;
begin
  Result := ZDB2_Eng.RemoveDatabaseOnDestroy;
end;

procedure TZDB2_FFMPEG_Data_Marshal.SetRemoveDatabaseOnDestroy(const Value: Boolean);
begin
  ZDB2_Eng.RemoveDatabaseOnDestroy := Value;
end;

procedure TZDB2_FFMPEG_Data_Marshal.Wait;
begin
  ZDB2_Eng.Wait_Busy_task;
end;

end.
