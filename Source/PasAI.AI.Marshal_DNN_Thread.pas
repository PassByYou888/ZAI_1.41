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
{ * AI Marshal DNN-Thread                                                      * }
{ ****************************************************************************** }
unit PasAI.AI.Marshal_DNN_Thread;

{$DEFINE FPC_DELPHI_MODE}
{$I PasAI.Define.inc}

interface

uses Types, Variants,
  PasAI.Core,
{$IFDEF FPC}
  PasAI.FPC.GenericList,
{$ELSE FPC}
  System.IOUtils,
{$ENDIF FPC}
  PasAI.PascalStrings, PasAI.UPascalStrings,
  PasAI.MemoryStream, PasAI.UnicodeMixedLib, PasAI.DFE, PasAI.ListEngine, PasAI.TextDataEngine, PasAI.Parsing, PasAI.Notify,
  PasAI.HashList.Templet, PasAI.Line2D.Templet,
  PasAI.ZDB, PasAI.ZDB.ObjectData_LIB, PasAI.ZDB.ItemStream_LIB,
  PasAI.DrawEngine, PasAI.Geometry2D, PasAI.MemoryRaster, PasAI.Learn.Type_LIB, PasAI.Learn, PasAI.Learn.KDTree, PasAI.Learn.SIFT,
  PasAI.AI.Common, PasAI.AI.TrainingTask, PasAI.AI.KeyIO,
  PasAI.Expression, PasAI.OpCode, PasAI.MemoryRaster.MorphologyExpression,
  PasAI.AI, PasAI.AI.Tech2022;

type
  TMarshal_DNN_Thread = class(TCore_Object_Intermediate)
  protected
    FAI_Legacy_Thead: TPas_AI_DNN_Thread_Pool;
    FAI_Tech_2022_Thread: TPas_AI_TECH_2022_DNN_Thread_Pool;
    procedure Do_Init_AI_Engine(); virtual;
    function Get_StateInfo_Th_Update_Time_Interval: TTimeTick;
    procedure Set_StateInfo_Th_Update_Time_Interval(const Value: TTimeTick);
  public
    constructor Create;
    destructor Destroy; override;
    { thread pool }
    property AI_Legacy_Thead: TPas_AI_DNN_Thread_Pool read FAI_Legacy_Thead;
    property AI_Tech_2022_Thread: TPas_AI_TECH_2022_DNN_Thread_Pool read FAI_Tech_2022_Thread;
    { dnn thread for device }
    procedure Legacy_BuildDeviceThread(AI_LIB_P: PAI_Core_API; Device_, ThNum_: Integer; class_: TPas_AI_DNN_Thread_Class); overload;
    procedure Legacy_BuildDeviceThread(Device_, ThNum_: Integer; class_: TPas_AI_DNN_Thread_Class); overload;
    procedure Tech_2022_BuildDeviceThread(AI_LIB_P: PAI_TECH_2022_Core_API; Device_, ThNum_: Integer; class_: TPas_AI_TECH_2022_DNN_Thread_Class); overload;
    procedure Tech_2022_BuildDeviceThread(Device_, ThNum_: Integer; class_: TPas_AI_TECH_2022_DNN_Thread_Class); overload;
    { custom device }
    procedure Legacy_BuildPerDeviceThread(AI_LIB_P: PAI_Core_API; Device_: TLIVec; ThNum_: Integer; class_: TPas_AI_DNN_Thread_Class); overload;
    procedure Legacy_BuildPerDeviceThread(Device_: TLIVec; ThNum_: Integer; class_: TPas_AI_DNN_Thread_Class); overload;
    procedure Legacy_BuildPerDeviceThread(Device_: TLIVec; class_: TPas_AI_DNN_Thread_Class); overload;
    procedure Tech_2022_BuildPerDeviceThread(AI_LIB_P: PAI_TECH_2022_Core_API; Device_: TLIVec; ThNum_: Integer; class_: TPas_AI_TECH_2022_DNN_Thread_Class); overload;
    procedure Tech_2022_BuildPerDeviceThread(Device_: TLIVec; ThNum_: Integer; class_: TPas_AI_TECH_2022_DNN_Thread_Class); overload;
    procedure Tech_2022_BuildPerDeviceThread(Device_: TLIVec; class_: TPas_AI_TECH_2022_DNN_Thread_Class); overload;
    { per device }
    procedure Legacy_BuildPerDeviceThread(AI_LIB_P: PAI_Core_API; ThNum_: Integer; class_: TPas_AI_DNN_Thread_Class); overload;
    procedure Legacy_BuildPerDeviceThread(ThNum_: Integer; class_: TPas_AI_DNN_Thread_Class); overload;
    procedure Legacy_BuildPerDeviceThread(class_: TPas_AI_DNN_Thread_Class); overload;
    procedure Tech_2022_BuildPerDeviceThread(AI_LIB_P: PAI_TECH_2022_Core_API; ThNum_: Integer; class_: TPas_AI_TECH_2022_DNN_Thread_Class); overload;
    procedure Tech_2022_BuildPerDeviceThread(ThNum_: Integer; class_: TPas_AI_TECH_2022_DNN_Thread_Class); overload;
    procedure Tech_2022_BuildPerDeviceThread(class_: TPas_AI_TECH_2022_DNN_Thread_Class); overload;
    { get thread }
    function Legacy_Next_DNN_Thread: TPas_AI_DNN_Thread;
    function Legacy_MinLoad_DNN_Thread: TPas_AI_DNN_Thread;
    function Legacy_IDLE_DNN_Thread: TPas_AI_DNN_Thread;
    function Tech_2022_Next_DNN_Thread: TPas_AI_TECH_2022_DNN_Thread;
    function Tech_2022_MinLoad_DNN_Thread: TPas_AI_TECH_2022_DNN_Thread;
    function Tech_2022_IDLE_DNN_Thread: TPas_AI_TECH_2022_DNN_Thread;
    { performance and state for DNN thread }
    function GetMinLoad_DNN_Thread_TaskNum: Integer;
    function GetTaskNum: Integer;
    property TaskNum: Integer read GetTaskNum;
    function Busy: Boolean;
    function PSP: TGeoFloat;
    function MaxPSP: TGeoFloat;
    procedure Wait(); overload;
    procedure Wait(Max_Task_Queue_Num: Integer); overload;
    { safe state info tech }
    property StateInfo_Th_Update_Time_Interval: TTimeTick read Get_StateInfo_Th_Update_Time_Interval write Set_StateInfo_Th_Update_Time_Interval;
    procedure Close_StateInfo_Th();
    function StateInfo: U_String; overload;
    function StateInfo(const Separator: Boolean): U_String; overload;
  end;

implementation

procedure TMarshal_DNN_Thread.Do_Init_AI_Engine;
begin
  FAI_Legacy_Thead := TPas_AI_DNN_Thread_Pool.Create;
  FAI_Tech_2022_Thread := TPas_AI_TECH_2022_DNN_Thread_Pool.Create;
end;

function TMarshal_DNN_Thread.Get_StateInfo_Th_Update_Time_Interval: TTimeTick;
begin
  Result := (FAI_Legacy_Thead.StateInfo_Th_Update_Time_Interval + FAI_Tech_2022_Thread.StateInfo_Th_Update_Time_Interval) shr 1;
end;

procedure TMarshal_DNN_Thread.Set_StateInfo_Th_Update_Time_Interval(const Value: TTimeTick);
begin
  FAI_Legacy_Thead.StateInfo_Th_Update_Time_Interval := Value;
  FAI_Tech_2022_Thread.StateInfo_Th_Update_Time_Interval := Value;
end;

constructor TMarshal_DNN_Thread.Create;
begin
  inherited Create;
  Do_Init_AI_Engine();
end;

destructor TMarshal_DNN_Thread.Destroy;
begin
  DisposeObjectAndNil(FAI_Legacy_Thead);
  DisposeObjectAndNil(FAI_Tech_2022_Thread);
  inherited Destroy;
end;

procedure TMarshal_DNN_Thread.Legacy_BuildDeviceThread(AI_LIB_P: PAI_Core_API; Device_, ThNum_: Integer; class_: TPas_AI_DNN_Thread_Class);
begin
  FAI_Legacy_Thead.BuildDeviceThread(AI_LIB_P, Device_, ThNum_, class_);
end;

procedure TMarshal_DNN_Thread.Legacy_BuildDeviceThread(Device_, ThNum_: Integer; class_: TPas_AI_DNN_Thread_Class);
begin
  FAI_Legacy_Thead.BuildDeviceThread(Device_, ThNum_, class_);
end;

procedure TMarshal_DNN_Thread.Tech_2022_BuildDeviceThread(AI_LIB_P: PAI_TECH_2022_Core_API; Device_, ThNum_: Integer; class_: TPas_AI_TECH_2022_DNN_Thread_Class);
begin
  FAI_Tech_2022_Thread.BuildDeviceThread(AI_LIB_P, Device_, ThNum_, class_);
end;

procedure TMarshal_DNN_Thread.Tech_2022_BuildDeviceThread(Device_, ThNum_: Integer; class_: TPas_AI_TECH_2022_DNN_Thread_Class);
begin
  FAI_Tech_2022_Thread.BuildDeviceThread(Device_, ThNum_, class_);
end;

procedure TMarshal_DNN_Thread.Legacy_BuildPerDeviceThread(AI_LIB_P: PAI_Core_API; Device_: TLIVec; ThNum_: Integer; class_: TPas_AI_DNN_Thread_Class);
begin
  FAI_Legacy_Thead.BuildPerDeviceThread(AI_LIB_P, Device_, ThNum_, class_);
end;

procedure TMarshal_DNN_Thread.Legacy_BuildPerDeviceThread(Device_: TLIVec; ThNum_: Integer; class_: TPas_AI_DNN_Thread_Class);
begin
  FAI_Legacy_Thead.BuildPerDeviceThread(Device_, ThNum_, class_);
end;

procedure TMarshal_DNN_Thread.Legacy_BuildPerDeviceThread(Device_: TLIVec; class_: TPas_AI_DNN_Thread_Class);
begin
  FAI_Legacy_Thead.BuildPerDeviceThread(Device_, class_);
end;

procedure TMarshal_DNN_Thread.Tech_2022_BuildPerDeviceThread(AI_LIB_P: PAI_TECH_2022_Core_API; Device_: TLIVec; ThNum_: Integer; class_: TPas_AI_TECH_2022_DNN_Thread_Class);
begin
  FAI_Tech_2022_Thread.BuildPerDeviceThread(AI_LIB_P, Device_, ThNum_, class_);
end;

procedure TMarshal_DNN_Thread.Tech_2022_BuildPerDeviceThread(Device_: TLIVec; ThNum_: Integer; class_: TPas_AI_TECH_2022_DNN_Thread_Class);
begin
  FAI_Tech_2022_Thread.BuildPerDeviceThread(Device_, ThNum_, class_);
end;

procedure TMarshal_DNN_Thread.Tech_2022_BuildPerDeviceThread(Device_: TLIVec; class_: TPas_AI_TECH_2022_DNN_Thread_Class);
begin
  FAI_Tech_2022_Thread.BuildPerDeviceThread(Device_, class_);
end;

procedure TMarshal_DNN_Thread.Legacy_BuildPerDeviceThread(AI_LIB_P: PAI_Core_API; ThNum_: Integer; class_: TPas_AI_DNN_Thread_Class);
begin
  FAI_Legacy_Thead.BuildPerDeviceThread(AI_LIB_P, ThNum_, class_);
end;

procedure TMarshal_DNN_Thread.Legacy_BuildPerDeviceThread(ThNum_: Integer; class_: TPas_AI_DNN_Thread_Class);
begin
  FAI_Legacy_Thead.BuildPerDeviceThread(ThNum_, class_);
end;

procedure TMarshal_DNN_Thread.Legacy_BuildPerDeviceThread(class_: TPas_AI_DNN_Thread_Class);
begin
  FAI_Legacy_Thead.BuildPerDeviceThread(class_);
end;

procedure TMarshal_DNN_Thread.Tech_2022_BuildPerDeviceThread(AI_LIB_P: PAI_TECH_2022_Core_API; ThNum_: Integer; class_: TPas_AI_TECH_2022_DNN_Thread_Class);
begin
  FAI_Tech_2022_Thread.BuildPerDeviceThread(AI_LIB_P, ThNum_, class_);
end;

procedure TMarshal_DNN_Thread.Tech_2022_BuildPerDeviceThread(ThNum_: Integer; class_: TPas_AI_TECH_2022_DNN_Thread_Class);
begin
  FAI_Tech_2022_Thread.BuildPerDeviceThread(ThNum_, class_);
end;

procedure TMarshal_DNN_Thread.Tech_2022_BuildPerDeviceThread(class_: TPas_AI_TECH_2022_DNN_Thread_Class);
begin
  FAI_Tech_2022_Thread.BuildPerDeviceThread(class_);
end;

function TMarshal_DNN_Thread.Legacy_Next_DNN_Thread: TPas_AI_DNN_Thread;
begin
  Result := FAI_Legacy_Thead.Next_DNN_Thread;
end;

function TMarshal_DNN_Thread.Legacy_MinLoad_DNN_Thread: TPas_AI_DNN_Thread;
begin
  Result := FAI_Legacy_Thead.MinLoad_DNN_Thread;
end;

function TMarshal_DNN_Thread.Legacy_IDLE_DNN_Thread: TPas_AI_DNN_Thread;
begin
  Result := FAI_Legacy_Thead.IDLE_DNN_Thread;
end;

function TMarshal_DNN_Thread.Tech_2022_Next_DNN_Thread: TPas_AI_TECH_2022_DNN_Thread;
begin
  Result := FAI_Tech_2022_Thread.Next_DNN_Thread;
end;

function TMarshal_DNN_Thread.Tech_2022_MinLoad_DNN_Thread: TPas_AI_TECH_2022_DNN_Thread;
begin
  Result := FAI_Tech_2022_Thread.MinLoad_DNN_Thread;
end;

function TMarshal_DNN_Thread.Tech_2022_IDLE_DNN_Thread: TPas_AI_TECH_2022_DNN_Thread;
begin
  Result := FAI_Tech_2022_Thread.IDLE_DNN_Thread;
end;

function TMarshal_DNN_Thread.GetMinLoad_DNN_Thread_TaskNum: Integer;
begin
  Result := umlMin(FAI_Legacy_Thead.GetMinLoad_DNN_Thread_TaskNum, FAI_Tech_2022_Thread.GetMinLoad_DNN_Thread_TaskNum);
end;

function TMarshal_DNN_Thread.GetTaskNum: Integer;
begin
  Result := FAI_Legacy_Thead.GetTaskNum + FAI_Tech_2022_Thread.GetTaskNum;
end;

function TMarshal_DNN_Thread.Busy: Boolean;
begin
  Result := FAI_Legacy_Thead.Busy or FAI_Tech_2022_Thread.Busy;
end;

function TMarshal_DNN_Thread.PSP: TGeoFloat;
begin
  Result := (FAI_Legacy_Thead.PSP + FAI_Tech_2022_Thread.PSP);
end;

function TMarshal_DNN_Thread.MaxPSP: TGeoFloat;
begin
  Result := (FAI_Legacy_Thead.MaxPSP + FAI_Tech_2022_Thread.MaxPSP);
end;

procedure TMarshal_DNN_Thread.Wait;
begin
  FAI_Legacy_Thead.Wait;
  FAI_Tech_2022_Thread.Wait;
end;

procedure TMarshal_DNN_Thread.Wait(Max_Task_Queue_Num: Integer);
begin
  while FAI_Legacy_Thead.TaskNum + FAI_Tech_2022_Thread.TaskNum > Max_Task_Queue_Num do
      TCompute.Sleep(10);
end;

procedure TMarshal_DNN_Thread.Close_StateInfo_Th;
begin
  FAI_Legacy_Thead.Close_StateInfo_Th;
  FAI_Tech_2022_Thread.Close_StateInfo_Th;
end;

function TMarshal_DNN_Thread.StateInfo: U_String;
begin
  Result := '';
  if FAI_Legacy_Thead.Count > 0 then
      Result.Append('AI-Legacy' + #13#10 + FAI_Legacy_Thead.StateInfo);
  if FAI_Tech_2022_Thread.Count > 0 then
    begin
      if Result <> '' then
          Result.Append(#13#10);
      Result.Append('AI-Tech-2022' + #13#10 + FAI_Tech_2022_Thread.StateInfo);
    end;
end;

function TMarshal_DNN_Thread.StateInfo(const Separator: Boolean): U_String;
begin
  Result := '';
  if FAI_Legacy_Thead.Count > 0 then
      Result.Append('AI-Legacy' + #13#10 + FAI_Legacy_Thead.StateInfo(Separator));
  if FAI_Tech_2022_Thread.Count > 0 then
    begin
      if Result <> '' then
          Result.Append(#13#10);
      Result.Append('AI-Tech-2022' + #13#10 + FAI_Tech_2022_Thread.StateInfo(Separator));
    end;
end;

end.
