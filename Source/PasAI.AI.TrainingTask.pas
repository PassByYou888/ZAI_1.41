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
{ * ZAI Training task(platform compatible)                                     * }
{ ****************************************************************************** }
unit PasAI.AI.TrainingTask;

{$DEFINE FPC_DELPHI_MODE}
{$I PasAI.Define.inc}

interface

uses Types, SysUtils,
  PasAI.Core,
{$IFDEF FPC}
  PasAI.FPC.GenericList,
{$ENDIF FPC}
  PasAI.PascalStrings, PasAI.UPascalStrings, PasAI.MemoryStream, PasAI.UnicodeMixedLib, PasAI.DFE,
  PasAI.ZDB, PasAI.ZDB.ObjectData_LIB, PasAI.ZDB.ItemStream_LIB,
  PasAI.Status, PasAI.MemoryRaster, PasAI.ListEngine, PasAI.AI.Common;

type
  TPas_AI_TrainingTask = class(TCore_Object_Intermediate)
  private
    procedure On_Save_DoStatus(Text_: SystemString; const ID: Integer);
  public
    DB_Stream: TCore_Stream;
    DB_Engine: TObjectDataManager;
    LastWriteFileList: TPascalStringList;
    LastReadMD5, LastWriteMD5: TMD5;
    TaskLogStatus: TPascalStringList;

    constructor Create;
    class function OpenFileTask(filename: SystemString; OnlyRead_: Boolean): TPas_AI_TrainingTask; overload;
    class function CreateFileTask(filename: SystemString): TPas_AI_TrainingTask; overload;
    class function OpenMemoryTask(filename: SystemString): TPas_AI_TrainingTask; overload;
    class function OpenMemoryTask(stream: TCore_Stream): TPas_AI_TrainingTask; overload;
    class function CreateMemoryTask: TPas_AI_TrainingTask;
    destructor Destroy; override;

    procedure SaveToStream(stream: TCore_Stream);
    procedure SaveToFile(filename: SystemString);

    procedure Write(name: SystemString; m64: TCore_Stream); overload;
    procedure Write(name: SystemString; data: THashVariantList); overload;
    procedure Write(name: SystemString; data: THashStringList); overload;
    procedure Write(name: SystemString; data: TPascalStringList); overload;
    procedure Write(name: SystemString; data: TCore_Strings); overload;
    procedure Write(name: SystemString; data: TSegmentationColorTable); overload;
    procedure Write(name: SystemString; data: TMPasAI_Raster); overload;
    procedure Write(name: SystemString; data: TPas_AI_ImageList); overload;
    procedure Write(name: SystemString; data: TPas_AI_ImageMatrix; SaveImg: Boolean); overload;
    procedure Write(name: SystemString; data: TPas_AI_ImageMatrix; SaveImg: Boolean; RasterFormat_: TPasAI_RasterSaveFormat); overload;
    procedure Write(name: SystemString; RSeri: TPasAI_RasterSerialized; data: TPas_AI_ImageList); overload;
    procedure Write(name: SystemString; RSeri: TPasAI_RasterSerialized; data: TPas_AI_ImageMatrix); overload;
    procedure WriteFile(name: SystemString; fromfile: SystemString); overload;
    procedure WriteFile(fromfile: SystemString); overload;

    procedure Read(name: SystemString; m64: TCore_Stream); overload;
    procedure Read(name: SystemString; data: THashVariantList); overload;
    procedure Read(name: SystemString; data: THashStringList); overload;
    procedure Read(name: SystemString; data: TPascalStringList); overload;
    procedure Read(name: SystemString; data: TCore_Strings); overload;
    procedure Read(name: SystemString; data: TSegmentationColorTable); overload;
    procedure Read(name: SystemString; data: TMPasAI_Raster); overload;
    procedure Read(name: SystemString; data: TPas_AI_ImageList); overload;
    procedure Read(name: SystemString; data: TPas_AI_ImageMatrix); overload;
    procedure Read(name: SystemString; RSeri: TPasAI_RasterSerialized; data: TPas_AI_ImageList); overload;
    procedure Read(name: SystemString; RSeri: TPasAI_RasterSerialized; data: TPas_AI_ImageMatrix); overload;
    procedure ReadToFile(name: SystemString; destfile: SystemString); overload;

    function Exists(name: SystemString): Boolean;
    function Delete(name: SystemString): Boolean;
    procedure GetFileList(L: TPascalStringList);
    function GetFileSize(name: SystemString): Int64;

    procedure CopyTo(LocalName: SystemString; dest: TPas_AI_TrainingTask; destName: SystemString); overload;

    { check file for training before }
    function CheckTrainingBefore(const paramFile: SystemString; var report: SystemString): Boolean;

    { check file for training after }
    function CheckTrainingAfter(const paramFile: SystemString; var report: SystemString): Boolean;
    function IsDepthTraining(const paramFile: SystemString): Boolean;
    function IsNormalTraining(const paramFile: SystemString): Boolean;
    function IsLargeScaleTraining(const paramFile: SystemString): Boolean;
    function GetOutputExt(IsLargeScaleTraining_: Boolean; const paramFile: SystemString; var report, ext: SystemString): Boolean;

    { restore normal training }
    function BuildRestoreTrainingData(const paramFile: SystemString; var report: SystemString; dest: TPas_AI_TrainingTask): Boolean;

    { export training result }
    procedure ExportLastWriteToStream(stream: TMS64);
    procedure ExportLastWriteToFile(filename: SystemString);

    { task is classic engine, include normal/large-scale }
    function Is_AI_Legacy_Engine_Task(const paramFile: SystemString): Boolean; overload;
    { task is TECH2022 engine }
    function Is_AI_TECH_2022_Task(const paramFile: SystemString): Boolean; overload;
  end;

implementation


procedure TPas_AI_TrainingTask.On_Save_DoStatus(Text_: SystemString; const ID: Integer);
begin
  if TaskLogStatus <> nil then
      TaskLogStatus.Add(umlDateTimeToStr(umlNow()) + #9 + Text_);
end;

constructor TPas_AI_TrainingTask.Create;
begin
  inherited Create;
  DB_Stream := nil;
  DB_Engine := nil;
  LastWriteFileList := nil;
  LastReadMD5 := NullMD5;
  LastWriteMD5 := NullMD5;
  TaskLogStatus := nil;
  AddDoStatusHook(Self, On_Save_DoStatus);
end;

class function TPas_AI_TrainingTask.OpenFileTask(filename: SystemString; OnlyRead_: Boolean): TPas_AI_TrainingTask;
begin
  Result := TPas_AI_TrainingTask.Create;
  Result.DB_Stream := TCore_FileStream.Create(filename, if_(OnlyRead_, fmOpenRead or fmShareDenyNone, fmOpenReadWrite));
  Result.DB_Engine := TObjectDataManagerOfCache.CreateAsStream(Result.DB_Stream, filename, DBMarshal.ID, OnlyRead_, False, False);
  Result.LastWriteFileList := TPascalStringList.Create;
  Result.TaskLogStatus := TPascalStringList.Create;
end;

class function TPas_AI_TrainingTask.CreateFileTask(filename: SystemString): TPas_AI_TrainingTask;
begin
  Result := TPas_AI_TrainingTask.Create;
  Result.DB_Stream := TCore_FileStream.Create(filename, fmCreate);
  Result.DB_Engine := TObjectDataManagerOfCache.CreateAsStream(Result.DB_Stream, filename, DBMarshal.ID, False, True, False);
  Result.LastWriteFileList := TPascalStringList.Create;
  Result.TaskLogStatus := TPascalStringList.Create;
end;

class function TPas_AI_TrainingTask.OpenMemoryTask(filename: SystemString): TPas_AI_TrainingTask;
begin
  Result := TPas_AI_TrainingTask.Create;
  Result.DB_Stream := TMS64.CustomCreate($FFFF);
  TMS64(Result.DB_Stream).LoadFromFile(filename);
  Result.DB_Engine := TObjectDataManagerOfCache.CreateAsStream(Result.DB_Stream, filename, DBMarshal.ID, False, False, False);
  Result.LastWriteFileList := TPascalStringList.Create;
  Result.TaskLogStatus := TPascalStringList.Create;
end;

class function TPas_AI_TrainingTask.OpenMemoryTask(stream: TCore_Stream): TPas_AI_TrainingTask;
begin
  Result := TPas_AI_TrainingTask.Create;
  Result.DB_Stream := TMS64.CustomCreate($FFFF);
  TMS64(Result.DB_Stream).LoadFromStream(stream);
  Result.DB_Stream.Position := 0;
  Result.DB_Engine := TObjectDataManagerOfCache.CreateAsStream(Result.DB_Stream, 'Memory', DBMarshal.ID, False, False, False);
  Result.LastWriteFileList := TPascalStringList.Create;
  Result.TaskLogStatus := TPascalStringList.Create;
end;

class function TPas_AI_TrainingTask.CreateMemoryTask: TPas_AI_TrainingTask;
begin
  Result := TPas_AI_TrainingTask.Create;
  Result.DB_Stream := TMS64.CustomCreate($FFFF);
  Result.DB_Engine := TObjectDataManagerOfCache.CreateAsStream($FF, Result.DB_Stream, 'Memory', DBMarshal.ID, False, True, False);
  Result.LastWriteFileList := TPascalStringList.Create;
  Result.TaskLogStatus := TPascalStringList.Create;
end;

destructor TPas_AI_TrainingTask.Destroy;
begin
  DeleteDoStatusHook(Self);
  DisposeObject(DB_Engine);
  DisposeObject(DB_Stream);
  DisposeObject(LastWriteFileList);
  DisposeObject(TaskLogStatus);
  inherited Destroy;
end;

procedure TPas_AI_TrainingTask.SaveToStream(stream: TCore_Stream);
var
  temp_db: TObjectDataManager;
begin
  DB_Engine.UpdateIO;
  temp_db := TObjectDataManagerOfCache.CreateAsStream(DB_Engine.Handle^.FixedStringL, stream, '', DB_Engine.DefaultItemID, False, True, False);
  DB_Engine.CopyTo(temp_db);
  DisposeObject(temp_db);
end;

procedure TPas_AI_TrainingTask.SaveToFile(filename: SystemString);
var
  fs: TCore_FileStream;
begin
  fs := TCore_FileStream.Create(filename, fmCreate);
  SaveToStream(fs);
  DisposeObject(fs);
end;

procedure TPas_AI_TrainingTask.Write(name: SystemString; m64: TCore_Stream);
begin
  if not DB_Engine.ItemWriteFromStream('/', Name, m64) then
      RaiseInfo('training task write item %s failed.', [name]);
  LastWriteMD5 := umlStreamMD5(m64);
  if LastWriteFileList.ExistsValue(name) < 0 then
      LastWriteFileList.Add(name);
end;

procedure TPas_AI_TrainingTask.Write(name: SystemString; data: THashVariantList);
var
  m64: TMS64;
begin
  m64 := TMS64.Create;
  data.SaveToStream(m64);
  Write(Name, m64);
  DisposeObject(m64);
end;

procedure TPas_AI_TrainingTask.Write(name: SystemString; data: THashStringList);
var
  m64: TMS64;
begin
  m64 := TMS64.Create;
  data.SaveToStream(m64);
  Write(Name, m64);
  DisposeObject(m64);
end;

procedure TPas_AI_TrainingTask.Write(name: SystemString; data: TPascalStringList);
var
  m64: TMS64;
begin
  m64 := TMS64.Create;
  data.SaveToStream(m64);
  Write(Name, m64);
  DisposeObject(m64);
end;

procedure TPas_AI_TrainingTask.Write(name: SystemString; data: TCore_Strings);
var
  m64: TMS64;
begin
  m64 := TMS64.Create;
{$IFDEF FPC}
  data.SaveToStream(m64);
{$ELSE FPC}
  data.SaveToStream(m64, TEncoding.UTF8);
{$ENDIF FPC}
  Write(Name, m64);
  DisposeObject(m64);
end;

procedure TPas_AI_TrainingTask.Write(name: SystemString; data: TSegmentationColorTable);
var
  m64: TMS64;
begin
  m64 := TMS64.Create;
  data.SaveToStream(m64);
  Write(Name, m64);
  DisposeObject(m64);
end;

procedure TPas_AI_TrainingTask.Write(name: SystemString; data: TMPasAI_Raster);
var
  m64: TMS64;
begin
  m64 := TMS64.Create;
  data.SaveToBmp24Stream(m64);
  Write(Name, m64);
  DisposeObject(m64);
end;

procedure TPas_AI_TrainingTask.Write(name: SystemString; data: TPas_AI_ImageList);
var
  m64: TMS64;
begin
  m64 := TMS64.Create;
  data.SaveToStream(m64, True, True, TPasAI_RasterSaveFormat.rsJPEG_YCbCr_Qualily80);
  Write(Name, m64);
  DisposeObject(m64);
end;

procedure TPas_AI_TrainingTask.Write(name: SystemString; data: TPas_AI_ImageMatrix; SaveImg: Boolean);
var
  m64: TMS64;
begin
  m64 := TMS64.Create;
  data.SaveToStream(m64, SaveImg, TPasAI_RasterSaveFormat.rsJPEG_YCbCr_Qualily80);
  Write(Name, m64);
  DisposeObject(m64);
end;

procedure TPas_AI_TrainingTask.Write(name: SystemString; data: TPas_AI_ImageMatrix; SaveImg: Boolean; RasterFormat_: TPasAI_RasterSaveFormat);
var
  m64: TMS64;
begin
  m64 := TMS64.Create;
  data.SaveToStream(m64, SaveImg, RasterFormat_);
  Write(Name, m64);
  DisposeObject(m64);
end;

procedure TPas_AI_TrainingTask.Write(name: SystemString; RSeri: TPasAI_RasterSerialized; data: TPas_AI_ImageList);
var
  m64: TMS64;
begin
  data.UnserializedMemory(RSeri);
  m64 := TMS64.Create;
  data.SaveToStream(m64, True, True, TPasAI_RasterSaveFormat.rsJPEG_YCbCr_Qualily80);
  Write(Name, m64);
  DisposeObject(m64);
  data.SerializedAndRecycleMemory(RSeri);
end;

procedure TPas_AI_TrainingTask.Write(name: SystemString; RSeri: TPasAI_RasterSerialized; data: TPas_AI_ImageMatrix);
var
  m64: TMS64;
begin
  m64 := TMS64.Create;
  data.LargeScale_SaveToStream(RSeri, m64, TPasAI_RasterSaveFormat.rsJPEG_YCbCr_Qualily80);
  Write(Name, m64);
  DisposeObject(m64);
  data.SerializedAndRecycleMemory(RSeri);
end;

procedure TPas_AI_TrainingTask.WriteFile(name: SystemString; fromfile: SystemString);
var
  m64: TMS64;
begin
  m64 := TMS64.Create;
  if umlFileExists(fromfile) then
    begin
      try
          m64.LoadFromFile(fromfile);
      except
      end;
    end;
  write(name, m64);
  DisposeObject(m64);
end;

procedure TPas_AI_TrainingTask.WriteFile(fromfile: SystemString);
begin
  WriteFile(umlGetFileName(fromfile), fromfile);
end;

procedure TPas_AI_TrainingTask.Read(name: SystemString; m64: TCore_Stream);
begin
  if not DB_Engine.ItemReadToStream('/', name, m64) then
      RaiseInfo('training task read item %s failed.', [name]);
  LastReadMD5 := umlStreamMD5(m64);
  m64.Position := 0;
end;

procedure TPas_AI_TrainingTask.Read(name: SystemString; data: THashVariantList);
var
  m64: TMS64;
begin
  data.Clear;
  if not Exists(name) then
      exit;
  m64 := TMS64.Create;
  read(name, m64);
  data.LoadFromStream(m64);
  DisposeObject(m64);
end;

procedure TPas_AI_TrainingTask.Read(name: SystemString; data: THashStringList);
var
  m64: TMS64;
begin
  data.Clear;
  if not Exists(name) then
      exit;
  m64 := TMS64.Create;
  read(name, m64);
  data.LoadFromStream(m64);
  DisposeObject(m64);
end;

procedure TPas_AI_TrainingTask.Read(name: SystemString; data: TPascalStringList);
var
  m64: TMS64;
begin
  data.Clear;
  if not Exists(name) then
      exit;
  m64 := TMS64.Create;
  read(name, m64);
  data.LoadFromStream(m64);
  DisposeObject(m64);
end;

procedure TPas_AI_TrainingTask.Read(name: SystemString; data: TCore_Strings);
var
  m64: TMS64;
begin
  data.Clear;
  if not Exists(name) then
      exit;
  m64 := TMS64.Create;
  read(name, m64);
{$IFDEF FPC}
  data.LoadFromStream(m64);
{$ELSE FPC}
  data.LoadFromStream(m64, TEncoding.UTF8);
{$ENDIF FPC}
  DisposeObject(m64);
end;

procedure TPas_AI_TrainingTask.Read(name: SystemString; data: TSegmentationColorTable);
var
  m64: TMS64;
begin
  data.Clear;
  if not Exists(name) then
      exit;
  m64 := TMS64.Create;
  read(name, m64);
  data.LoadFromStream(m64);
  DisposeObject(m64);
end;

procedure TPas_AI_TrainingTask.Read(name: SystemString; data: TMPasAI_Raster);
var
  m64: TMS64;
begin
  data.Reset;
  if not Exists(name) then
      exit;
  m64 := TMS64.Create;
  read(name, m64);
  data.LoadFromStream(m64);
  DisposeObject(m64);
end;

procedure TPas_AI_TrainingTask.Read(name: SystemString; data: TPas_AI_ImageList);
var
  m64: TMS64;
begin
  data.Clear;
  if not Exists(name) then
      exit;
  m64 := TMS64.Create;
  read(name, m64);
  data.LoadFromStream(m64);
  DisposeObject(m64);
end;

procedure TPas_AI_TrainingTask.Read(name: SystemString; data: TPas_AI_ImageMatrix);
var
  m64: TMS64;
begin
  data.Clear;
  if not Exists(name) then
      exit;
  m64 := TMS64.Create;
  read(name, m64);
  data.LoadFromStream(m64);
  DisposeObject(m64);
end;

procedure TPas_AI_TrainingTask.Read(name: SystemString; RSeri: TPasAI_RasterSerialized; data: TPas_AI_ImageList);
var
  m64: TMS64;
begin
  data.Clear;
  if not Exists(name) then
      exit;
  m64 := TMS64.Create;
  read(name, m64);
  data.LoadFromStream(m64);
  DisposeObject(m64);
  data.SerializedAndRecycleMemory(RSeri);
end;

procedure TPas_AI_TrainingTask.Read(name: SystemString; RSeri: TPasAI_RasterSerialized; data: TPas_AI_ImageMatrix);
var
  m64: TMS64;
begin
  data.Clear;
  if not Exists(name) then
      exit;
  m64 := TMS64.Create;
  read(name, m64);
  data.LargeScale_LoadFromStream(RSeri, m64);
  DisposeObject(m64);
end;

procedure TPas_AI_TrainingTask.ReadToFile(name: SystemString; destfile: SystemString);
var
  m64: TMS64;
begin
  if not Exists(name) then
      exit;
  m64 := TMS64.Create;
  read(name, m64);
  try
      m64.SaveToFile(destfile);
  except
  end;
  DisposeObject(m64);
end;

function TPas_AI_TrainingTask.Exists(name: SystemString): Boolean;
begin
  Result := DB_Engine.ItemExists('/', name);
end;

function TPas_AI_TrainingTask.Delete(name: SystemString): Boolean;
begin
  Result := DB_Engine.ItemDelete('/', name);
  LastWriteFileList.DeleteString(name);
end;

procedure TPas_AI_TrainingTask.GetFileList(L: TPascalStringList);
var
  sr: TItemSearch;
begin
  L.Clear;
  if DB_Engine.ItemFindFirst('/', '*', sr) then
    begin
      repeat
          L.Add(sr.name);
      until not DB_Engine.ItemFindNext(sr);
    end;
end;

function TPas_AI_TrainingTask.GetFileSize(name: SystemString): Int64;
begin
  Result := DB_Engine.GetItemSize('/', name);
end;

procedure TPas_AI_TrainingTask.CopyTo(LocalName: SystemString; dest: TPas_AI_TrainingTask; destName: SystemString);
var
  m64: TMS64;
begin
  m64 := TMS64.Create;
  read(LocalName, m64);
  m64.Position := 0;
  dest.Write(destName, m64);
  DisposeObject(m64);
end;

function TPas_AI_TrainingTask.CheckTrainingBefore(const paramFile: SystemString; var report: SystemString): Boolean;
var
  param: THashVariantList;
  ComputeFunc: U_String;
  inputfile1, inputfile2: SystemString;
  ext: SystemString;
begin
  Result := False;
  if not Exists(paramFile) then
    begin
      report := PFormat('error param file: %s', [paramFile]);
      exit;
    end;

  if not IsNormalTraining(paramFile) then
    begin
      Result := GetOutputExt(True, paramFile, report, ext);
      exit;
    end;

  param := THashVariantList.Create;

  Read(paramFile, param);

  if param.Exists('func') then
      ComputeFunc := param['func']
  else if param.Exists('compute') then
      ComputeFunc := param['compute']
  else
      ComputeFunc := param.GetDefaultValue_Str('ComputeFunc', '');

  ComputeFunc := ComputeFunc.TrimChar(#32#9);

  if umlMultipleMatch(['surf', 'fastsurf'], ComputeFunc) then
    begin
      inputfile1 := param.GetDefaultValue_Str('source', '');
      inputfile2 := param.GetDefaultValue('dest', '');
      Result := Exists(inputfile1) and Exists(inputfile2);
      if not Result then
          report := PFormat('error training source: %s', [inputfile1])
    end
  else if umlMultipleMatch(['TrainOD', 'TrainingOD', 'TrainObjectDetector', 'TrainOD6L', 'TrainingOD6L', 'TrainObjectDetector6L'], ComputeFunc) then
    begin
      inputfile1 := param.GetDefaultValue_Str('source', '');
      Result := Exists(inputfile1);
      if not Result then
          report := PFormat('error training source: %s', [inputfile1])
    end
  else if umlMultipleMatch(['TrainOD3L', 'TrainingOD3L', 'TrainObjectDetector3L'], ComputeFunc) then
    begin
      inputfile1 := param.GetDefaultValue_Str('source', '');
      Result := Exists(inputfile1);
      if not Result then
          report := PFormat('error training source: %s', [inputfile1])
    end
  else if umlMultipleMatch(['TrainOD_Marshal', 'TrainingOD_Marshal', 'TrainObjectDetectorMarshal', 'TrainOD6L_Marshal', 'TrainingOD6L_Marshal', 'TrainObjectDetector6LMarshal'], ComputeFunc) then
    begin
      inputfile1 := param.GetDefaultValue_Str('source', '');
      Result := Exists(inputfile1);
      if not Result then
          report := PFormat('error training source: %s', [inputfile1])
    end
  else if umlMultipleMatch(['TrainSP', 'TrainingSP', 'TrainShapePredictor'], ComputeFunc) then
    begin
      inputfile1 := param.GetDefaultValue_Str('source', '');
      Result := Exists(inputfile1);
      if not Result then
          report := PFormat('error training source: %s', [inputfile1])
    end
  else if umlMultipleMatch(['TrainMRN', 'TrainingMRN', 'TrainMetricResNet'], ComputeFunc) then
    begin
      inputfile1 := param.GetDefaultValue_Str('source', '');
      Result := Exists(inputfile1);
      if not Result then
          report := PFormat('error training source: %s', [inputfile1])
    end
  else if umlMultipleMatch(['TrainLMRN', 'TrainingLMRN', 'TrainLMetricResNet'], ComputeFunc) then
    begin
      inputfile1 := param.GetDefaultValue_Str('source', '');
      Result := Exists(inputfile1);
      if not Result then
          report := PFormat('error training source: %s', [inputfile1])
    end
  else if umlMultipleMatch(['TrainMMOD', 'TrainingMMOD', 'TrainMaxMarginDNNObjectDetector', 'TrainMMOD6L', 'TrainingMMOD6L', 'TrainMaxMarginDNNObjectDetector6L'], ComputeFunc) then
    begin
      inputfile1 := param.GetDefaultValue_Str('source', '');
      Result := Exists(inputfile1);
      if not Result then
          report := PFormat('error training source: %s', [inputfile1])
    end
  else if umlMultipleMatch(['TrainMMOD3L', 'TrainingMMOD3L', 'TrainMaxMarginDNNObjectDetector3L'], ComputeFunc) then
    begin
      inputfile1 := param.GetDefaultValue_Str('source', '');
      Result := Exists(inputfile1);
      if not Result then
          report := PFormat('error training source: %s', [inputfile1])
    end
  else if umlMultipleMatch(['TrainRNIC', 'TrainingRNIC', 'TrainResNetImageClassifier'], ComputeFunc) then
    begin
      inputfile1 := param.GetDefaultValue_Str('source', '');
      Result := Exists(inputfile1);
      if not Result then
          report := PFormat('error training source: %s', [inputfile1])
    end
  else if umlMultipleMatch(['TrainLRNIC', 'TrainingLRNIC', 'TrainLResNetImageClassifier'], ComputeFunc) then
    begin
      inputfile1 := param.GetDefaultValue_Str('source', '');
      Result := Exists(inputfile1);
      if not Result then
          report := PFormat('error training source: %s', [inputfile1])
    end
  else if umlMultipleMatch(['TrainGDCNIC', 'TrainingGDCNIC'], ComputeFunc) then
    begin
      inputfile1 := param.GetDefaultValue_Str('source', '');
      Result := Exists(inputfile1);
      if not Result then
          report := PFormat('error training source: %s', [inputfile1])
    end
  else if umlMultipleMatch(['TrainGNIC', 'TrainingGNIC'], ComputeFunc) then
    begin
      inputfile1 := param.GetDefaultValue_Str('source', '');
      Result := Exists(inputfile1);
      if not Result then
          report := PFormat('error training source: %s', [inputfile1])
    end
  else if umlMultipleMatch(['TrainSS', 'TrainingSS'], ComputeFunc) then
    begin
      inputfile1 := param.GetDefaultValue_Str('source', '');
      Result := Exists(inputfile1);
      if not Result then
          report := PFormat('error training source: %s', [inputfile1])
    end
  else if umlMultipleMatch(['TrainZMetric', 'TrainingZMetric'], ComputeFunc) then
    begin
      inputfile1 := param.GetDefaultValue_Str('source', '');
      Result := Exists(inputfile1);
      if not Result then
          report := PFormat('error training source: %s', [inputfile1])
    end
  else if umlMultipleMatch(['TrainDCGAN', 'TrainingDCGAN'], ComputeFunc) then
    begin
      inputfile1 := param.GetDefaultValue_Str('source', '');
      Result := Exists(inputfile1);
      if not Result then
          report := PFormat('error training source: %s', [inputfile1])
    end
  else if umlMultipleMatch(['TrainZMetricV2', 'TrainingZMetricV2'], ComputeFunc) then
    begin
      inputfile1 := param.GetDefaultValue_Str('source', '');
      Result := Exists(inputfile1);
      if not Result then
          report := PFormat('error training source: %s', [inputfile1])
    end
  else if umlMultipleMatch(['YOLOX', 'YOLO-X', 'YOLO'], ComputeFunc) then
    begin
      inputfile1 := param.GetDefaultValue_Str('source', '');
      Result := Exists(inputfile1);
      if not Result then
          report := PFormat('error training source: %s', [inputfile1])
    end
  else if umlMultipleMatch(['TrainSSL', 'TrainingSSL'], ComputeFunc) then
    begin
      inputfile1 := param.GetDefaultValue_Str('source', '');
      Result := Exists(inputfile1);
      if not Result then
          report := PFormat('error training source: %s', [inputfile1])
    end
  else
    begin
      report := 'illegal ComputeFunc.';
    end;

  DisposeObject(param);

  if Result then
      report := 'solve.';
end;

function TPas_AI_TrainingTask.CheckTrainingAfter(const paramFile: SystemString; var report: SystemString): Boolean;
var
  param: THashVariantList;
  ResultValues: THashVariantList;
  ComputeFunc: U_String;
  outputfile: SystemString;
  ext: SystemString;
begin
  Result := False;
  if not Exists(paramFile) then
    begin
      report := PFormat('error param file: %s', [paramFile]);
      exit;
    end;

  if not IsNormalTraining(paramFile) then
    begin
      Result := GetOutputExt(True, paramFile, report, ext) and Exists('*' + ext);
      exit;
    end;

  param := THashVariantList.Create;
  Read(paramFile, param);

  outputfile := param.GetDefaultValue('Result', 'Result.txt');
  if not Exists(outputfile) then
    begin
      report := PFormat('error result file: %s', [outputfile]);
      DisposeObject(param);
      exit;
    end;

  ResultValues := THashVariantList.Create;
  Read(outputfile, ResultValues);

  if param.Exists('func') then
      ComputeFunc := param['func']
  else if param.Exists('compute') then
      ComputeFunc := param['compute']
  else
      ComputeFunc := param.GetDefaultValue_Str('ComputeFunc', '');

  ComputeFunc := ComputeFunc.TrimChar(#32#9);

  if ResultValues.GetDefaultValue('Result', False) = False then
    begin
      report := 'Training Result Error.';
    end
  else if umlMultipleMatch(['surf', 'fastsurf'], ComputeFunc) then
    begin
      outputfile := param.GetDefaultValue_Str('output', 'output.bmp');
      Result := Exists(outputfile);
      if not Result then
          report := PFormat('error training output: %s', [outputfile]);
    end
  else if umlMultipleMatch(['TrainOD', 'TrainingOD', 'TrainObjectDetector', 'TrainOD6L', 'TrainingOD6L', 'TrainObjectDetector6L'], ComputeFunc) then
    begin
      outputfile := param.GetDefaultValue_Str('output', 'output' + C_OD6L_Ext);
      Result := Exists(outputfile);
      if not Result then
          report := PFormat('error training output: %s', [outputfile]);
    end
  else if umlMultipleMatch(['TrainOD3L', 'TrainingOD3L', 'TrainObjectDetector3L'], ComputeFunc) then
    begin
      outputfile := param.GetDefaultValue_Str('output', 'output' + C_OD3L_Ext);
      Result := Exists(outputfile);
      if not Result then
          report := PFormat('error training output: %s', [outputfile]);
    end
  else if umlMultipleMatch(['TrainOD_Marshal', 'TrainingOD_Marshal', 'TrainObjectDetectorMarshal', 'TrainOD6L_Marshal', 'TrainingOD6L_Marshal', 'TrainObjectDetector6LMarshal'], ComputeFunc) then
    begin
      outputfile := param.GetDefaultValue_Str('output', 'output' + C_OD6L_Marshal_Ext);
      Result := Exists(outputfile);
      if not Result then
          report := PFormat('error training output: %s', [outputfile]);
    end
  else if umlMultipleMatch(['TrainSP', 'TrainingSP', 'TrainShapePredictor'], ComputeFunc) then
    begin
      outputfile := param.GetDefaultValue_Str('output', 'output' + C_SP_Ext);
      Result := Exists(outputfile);
      if not Result then
          report := PFormat('error training output: %s', [outputfile]);
    end
  else if umlMultipleMatch(['TrainMRN', 'TrainingMRN', 'TrainMetricResNet'], ComputeFunc) then
    begin
      outputfile := param.GetDefaultValue_Str('syncfile', 'output' + C_Metric_Ext + C_Sync_Ext);
      if not Exists(outputfile) then
          DoStatus('warning: no found trainer "%s" sync file: %s', [DB_Engine.ObjectName, outputfile]);

      outputfile := param.GetDefaultValue_Str('output', 'output' + C_Metric_Ext);
      Result := Exists(outputfile);
      if not Result then
          report := PFormat('error training output: %s', [outputfile]);
    end
  else if umlMultipleMatch(['TrainLMRN', 'TrainingLMRN', 'TrainLMetricResNet'], ComputeFunc) then
    begin
      outputfile := param.GetDefaultValue_Str('syncfile', 'output' + C_LMetric_Ext + C_Sync_Ext);
      if not Exists(outputfile) then
          DoStatus('warning: no found trainer "%s" sync file: %s', [DB_Engine.ObjectName, outputfile]);

      outputfile := param.GetDefaultValue_Str('output', 'output' + C_LMetric_Ext);
      Result := Exists(outputfile);
      if not Result then
          report := PFormat('error training output: %s', [outputfile]);
    end
  else if umlMultipleMatch(['TrainMMOD', 'TrainingMMOD', 'TrainMaxMarginDNNObjectDetector', 'TrainMMOD6L', 'TrainingMMOD6L', 'TrainMaxMarginDNNObjectDetector6L'], ComputeFunc) then
    begin
      outputfile := param.GetDefaultValue_Str('syncfile', 'output' + C_MMOD6L_Ext + C_Sync_Ext);
      if not Exists(outputfile) then
          DoStatus('warning: no found trainer "%s" sync file: %s', [DB_Engine.ObjectName, outputfile]);

      outputfile := param.GetDefaultValue_Str('output', 'output' + C_MMOD6L_Ext);
      Result := Exists(outputfile);
      if not Result then
          report := PFormat('error training output: %s', [outputfile]);
    end
  else if umlMultipleMatch(['TrainMMOD3L', 'TrainingMMOD3L', 'TrainMaxMarginDNNObjectDetector3L'], ComputeFunc) then
    begin
      outputfile := param.GetDefaultValue_Str('syncfile', 'output' + C_MMOD3L_Ext + C_Sync_Ext);
      if not Exists(outputfile) then
          DoStatus('warning: no found trainer "%s" sync file: %s', [DB_Engine.ObjectName, outputfile]);

      outputfile := param.GetDefaultValue_Str('output', 'output' + C_MMOD3L_Ext);
      Result := Exists(outputfile);
      if not Result then
          report := PFormat('error training output: %s', [outputfile]);
    end
  else if umlMultipleMatch(['TrainRNIC', 'TrainingRNIC', 'TrainResNetImageClassifier'], ComputeFunc) then
    begin
      outputfile := param.GetDefaultValue_Str('syncfile', 'output' + C_RNIC_Ext + C_Sync_Ext);
      if not Exists(outputfile) then
          DoStatus('warning: no found trainer "%s" sync file: %s', [DB_Engine.ObjectName, outputfile]);

      outputfile := param.GetDefaultValue_Str('output', 'output' + C_RNIC_Ext);
      Result := Exists(outputfile);
      if not Result then
          report := PFormat('error training output: %s', [outputfile]);
    end
  else if umlMultipleMatch(['TrainLRNIC', 'TrainingLRNIC', 'TrainLResNetImageClassifier'], ComputeFunc) then
    begin
      outputfile := param.GetDefaultValue_Str('syncfile', 'output' + C_LRNIC_Ext + C_Sync_Ext);
      if not Exists(outputfile) then
          DoStatus('warning: no found trainer "%s" sync file: %s', [DB_Engine.ObjectName, outputfile]);

      outputfile := param.GetDefaultValue_Str('output', 'output' + C_LRNIC_Ext);
      Result := Exists(outputfile);
      if not Result then
          report := PFormat('error training output: %s', [outputfile]);
    end
  else if umlMultipleMatch(['TrainGDCNIC', 'TrainingGDCNIC'], ComputeFunc) then
    begin
      outputfile := param.GetDefaultValue_Str('syncfile', 'output' + C_GDCNIC_Ext + C_Sync_Ext);
      if not Exists(outputfile) then
          DoStatus('warning: no found trainer "%s" sync file: %s', [DB_Engine.ObjectName, outputfile]);

      outputfile := param.GetDefaultValue_Str('output', 'output' + C_GDCNIC_Ext);
      Result := Exists(outputfile);
      if not Result then
          report := PFormat('error training output: %s', [outputfile]);
    end
  else if umlMultipleMatch(['TrainGNIC', 'TrainingGNIC'], ComputeFunc) then
    begin
      outputfile := param.GetDefaultValue_Str('syncfile', 'output' + C_GNIC_Ext + C_Sync_Ext);
      if not Exists(outputfile) then
          DoStatus('warning: no found trainer "%s" sync file: %s', [DB_Engine.ObjectName, outputfile]);

      outputfile := param.GetDefaultValue_Str('output', 'output' + C_GNIC_Ext);
      Result := Exists(outputfile);
      if not Result then
          report := PFormat('error training output: %s', [outputfile]);
    end
  else if umlMultipleMatch(['TrainSS', 'TrainingSS'], ComputeFunc) then
    begin
      outputfile := param.GetDefaultValue_Str('syncfile', 'output' + C_SS_Ext + C_Sync_Ext);
      if not Exists(outputfile) then
          DoStatus('warning: no found trainer "%s" sync file: %s', [DB_Engine.ObjectName, outputfile]);

      outputfile := param.GetDefaultValue_Str('output', 'output' + C_SS_Ext);
      Result := Exists(outputfile);
      if not Result then
          report := PFormat('error training output: %s', [outputfile]);
    end
  else if umlMultipleMatch(['TrainZMetric', 'TrainingZMetric'], ComputeFunc) then
    begin
      outputfile := param.GetDefaultValue_Str('syncfile', 'output' + C_ZMetric_Ext + C_Sync_Ext);
      if not Exists(outputfile) then
          DoStatus('warning: no found trainer "%s" sync file: %s', [DB_Engine.ObjectName, outputfile]);

      outputfile := param.GetDefaultValue_Str('output', 'output' + C_ZMetric_Ext);
      Result := Exists(outputfile);
      if not Result then
          report := PFormat('error training output: %s', [outputfile]);
    end
  else if umlMultipleMatch(['TrainDCGAN', 'TrainingDCGAN'], ComputeFunc) then
    begin
      outputfile := param.GetDefaultValue_Str('syncfile', 'output' + C_DCGAN_Ext + C_Sync_Ext);
      if not Exists(outputfile) then
          DoStatus('warning: no found trainer "%s" sync file: %s', [DB_Engine.ObjectName, outputfile]);

      outputfile := param.GetDefaultValue_Str('output', 'output' + C_DCGAN_Ext);
      Result := Exists(outputfile);
      if not Result then
          report := PFormat('error training output: %s', [outputfile]);
    end
  else if umlMultipleMatch(['TrainZMetricV2', 'TrainingZMetricV2'], ComputeFunc) then
    begin
      outputfile := param.GetDefaultValue_Str('syncfile', 'output' + C_ZMetric_V2_Ext + C_Sync_Ext);
      if not Exists(outputfile) then
          DoStatus('warning: no found trainer "%s" sync file: %s', [DB_Engine.ObjectName, outputfile]);

      outputfile := param.GetDefaultValue_Str('output', 'output' + C_ZMetric_V2_Ext);
      Result := Exists(outputfile);
      if not Result then
          report := PFormat('error training output: %s', [outputfile]);
    end
  else if umlMultipleMatch(['YOLOX', 'YOLO-X', 'YOLO'], ComputeFunc) then
    begin
      outputfile := param.GetDefaultValue_Str('syncfile', 'output' + C_YOLO_X_Ext + C_Sync_Ext);
      if not Exists(outputfile) then
          DoStatus('warning: no found trainer "%s" sync file: %s', [DB_Engine.ObjectName, outputfile]);

      outputfile := param.GetDefaultValue_Str('output', 'output' + C_YOLO_X_Ext);
      Result := Exists(outputfile);
      if not Result then
          report := PFormat('error training output: %s', [outputfile]);
    end
  else if umlMultipleMatch(['TrainSSL', 'TrainingSSL'], ComputeFunc) then
    begin
      outputfile := param.GetDefaultValue_Str('syncfile', 'output' + C_SSL_Ext + C_Sync_Ext);
      if not Exists(outputfile) then
          DoStatus('warning: no found trainer "%s" sync file: %s', [DB_Engine.ObjectName, outputfile]);

      outputfile := param.GetDefaultValue_Str('output', 'output' + C_SSL_Ext);
      Result := Exists(outputfile);
      if not Result then
          report := PFormat('error training output: %s', [outputfile]);
    end
  else
    begin
      report := 'illegal ComputeFunc.';
    end;

  DisposeObject([param, ResultValues]);
  if Result then
      report := 'solve.';
end;

function TPas_AI_TrainingTask.IsDepthTraining(const paramFile: SystemString): Boolean;
var
  param: THashVariantList;
  ComputeFunc: U_String;
begin
  Result := False;
  if not Exists(paramFile) then
      exit;

  param := THashVariantList.Create;
  Read(paramFile, param);

  if param.Exists('func') then
      ComputeFunc := param['func']
  else if param.Exists('compute') then
      ComputeFunc := param['compute']
  else
      ComputeFunc := param.GetDefaultValue_Str('ComputeFunc', '');

  ComputeFunc := ComputeFunc.TrimChar(#32#9);

  if umlMultipleMatch(['TrainMRN', 'TrainingMRN', 'TrainMetricResNet'], ComputeFunc) then
    begin
      Result := True;
    end
  else if umlMultipleMatch(['TrainLMRN', 'TrainingLMRN', 'TrainLMetricResNet'], ComputeFunc) then
    begin
      Result := True;
    end
  else if umlMultipleMatch(['TrainMMOD', 'TrainingMMOD', 'TrainMaxMarginDNNObjectDetector', 'TrainMMOD6L', 'TrainingMMOD6L', 'TrainMaxMarginDNNObjectDetector6L'], ComputeFunc) then
    begin
      Result := True;
    end
  else if umlMultipleMatch(['TrainMMOD3L', 'TrainingMMOD3L', 'TrainMaxMarginDNNObjectDetector3L'], ComputeFunc) then
    begin
      Result := True;
    end
  else if umlMultipleMatch(['TrainRNIC', 'TrainingRNIC', 'TrainResNetImageClassifier'], ComputeFunc) then
    begin
      Result := True;
    end
  else if umlMultipleMatch(['TrainLRNIC', 'TrainingLRNIC', 'TrainLResNetImageClassifier'], ComputeFunc) then
    begin
      Result := True;
    end
  else if umlMultipleMatch(['TrainGDCNIC', 'TrainingGDCNIC'], ComputeFunc) then
    begin
      Result := True;
    end
  else if umlMultipleMatch(['TrainGNIC', 'TrainingGNIC'], ComputeFunc) then
    begin
      Result := True;
    end
  else if umlMultipleMatch(['TrainSS', 'TrainingSS'], ComputeFunc) then
    begin
      Result := True;
    end
  else if umlMultipleMatch(['TrainZMetric', 'TrainingZMetric'], ComputeFunc) then
    begin
      Result := True;
    end
  else if umlMultipleMatch(['TrainDCGAN', 'TrainingDCGAN'], ComputeFunc) then
    begin
      Result := True;
    end
  else if umlMultipleMatch(['TrainZMetricV2', 'TrainingZMetricV2'], ComputeFunc) then
    begin
      Result := True;
    end
  else if umlMultipleMatch(['YOLOX', 'YOLO-X', 'YOLO'], ComputeFunc) then
    begin
      Result := True;
    end
  else if umlMultipleMatch(['TrainSSL', 'TrainingSSL'], ComputeFunc) then
    begin
      Result := True;
    end;

  DisposeObject(param);
end;

function TPas_AI_TrainingTask.IsNormalTraining(const paramFile: SystemString): Boolean;
var
  param: THashVariantList;
  ComputeFunc: U_String;
  outputfile: SystemString;
begin
  Result := False;
  if not Exists(paramFile) then
    begin
      exit;
    end;

  param := THashVariantList.Create;
  Read(paramFile, param);

  Result := param.Exists('source');

  DisposeObject(param);
end;

function TPas_AI_TrainingTask.IsLargeScaleTraining(const paramFile: SystemString): Boolean;
var
  report, ext: SystemString;
begin
  Result := (IsDepthTraining(paramFile)) and (not IsNormalTraining(paramFile)) and GetOutputExt(True, paramFile, report, ext);
end;

function TPas_AI_TrainingTask.GetOutputExt(IsLargeScaleTraining_: Boolean; const paramFile: SystemString; var report, ext: SystemString): Boolean;
var
  param: THashVariantList;
  ComputeFunc: U_String;
  outputfile: SystemString;
begin
  Result := False;
  if not Exists(paramFile) then
    begin
      report := PFormat('error param file: %s', [paramFile]);
      exit;
    end;

  param := THashVariantList.Create;
  Read(paramFile, param);

  if param.Exists('func') then
      ComputeFunc := param['func']
  else if param.Exists('compute') then
      ComputeFunc := param['compute']
  else
      ComputeFunc := param.GetDefaultValue_Str('ComputeFunc', '');

  ComputeFunc := ComputeFunc.TrimChar(#32#9);

  if (not IsLargeScaleTraining_) and (umlMultipleMatch(['surf', 'fastsurf'], ComputeFunc)) then
    begin
      ext := '.bmp';
      Result := True;
    end
  else if (not IsLargeScaleTraining_) and (umlMultipleMatch(['TrainOD', 'TrainingOD', 'TrainObjectDetector', 'TrainOD6L', 'TrainingOD6L', 'TrainObjectDetector6L'], ComputeFunc)) then
    begin
      ext := C_OD6L_Ext;
      Result := True;
    end
  else if (not IsLargeScaleTraining_) and (umlMultipleMatch(['TrainOD3L', 'TrainingOD3L', 'TrainObjectDetector3L'], ComputeFunc)) then
    begin
      ext := C_OD3L_Ext;
      Result := True;
    end
  else if (not IsLargeScaleTraining_) and (umlMultipleMatch(['TrainOD_Marshal', 'TrainingOD_Marshal', 'TrainObjectDetectorMarshal', 'TrainOD6L_Marshal', 'TrainingOD6L_Marshal', 'TrainObjectDetector6LMarshal'], ComputeFunc)) then
    begin
      ext := C_OD6L_Marshal_Ext;
      Result := True;
    end
  else if (not IsLargeScaleTraining_) and (umlMultipleMatch(['TrainSP', 'TrainingSP', 'TrainShapePredictor'], ComputeFunc)) then
    begin
      ext := C_SP_Ext;
      Result := True;
    end
  else if umlMultipleMatch(['TrainMRN', 'TrainingMRN', 'TrainMetricResNet'], ComputeFunc) then
    begin
      ext := C_Metric_Ext;
      Result := True;
    end
  else if umlMultipleMatch(['TrainLMRN', 'TrainingLMRN', 'TrainLMetricResNet'], ComputeFunc) then
    begin
      ext := C_LMetric_Ext;
      Result := True;
    end
  else if umlMultipleMatch(['TrainMMOD', 'TrainingMMOD', 'TrainMaxMarginDNNObjectDetector', 'TrainMMOD6L', 'TrainingMMOD6L', 'TrainMaxMarginDNNObjectDetector6L'], ComputeFunc) then
    begin
      ext := C_MMOD6L_Ext;
      Result := True;
    end
  else if umlMultipleMatch(['TrainMMOD3L', 'TrainingMMOD3L', 'TrainMaxMarginDNNObjectDetector3L'], ComputeFunc) then
    begin
      ext := C_MMOD3L_Ext;
      Result := True;
    end
  else if umlMultipleMatch(['TrainRNIC', 'TrainingRNIC', 'TrainResNetImageClassifier'], ComputeFunc) then
    begin
      ext := C_RNIC_Ext;
      Result := True;
    end
  else if umlMultipleMatch(['TrainLRNIC', 'TrainingLRNIC', 'TrainLResNetImageClassifier'], ComputeFunc) then
    begin
      ext := C_LRNIC_Ext;
      Result := True;
    end
  else if umlMultipleMatch(['TrainGDCNIC', 'TrainingGDCNIC'], ComputeFunc) then
    begin
      ext := C_GDCNIC_Ext;
      Result := True;
    end
  else if umlMultipleMatch(['TrainGNIC', 'TrainingGNIC'], ComputeFunc) then
    begin
      ext := C_GNIC_Ext;
      Result := True;
    end
  else if umlMultipleMatch(['TrainSS', 'TrainingSS'], ComputeFunc) then
    begin
      ext := C_SS_Ext;
      Result := True;
    end
  else if umlMultipleMatch(['TrainZMetric', 'TrainingZMetric'], ComputeFunc) then
    begin
      ext := C_ZMetric_Ext;
      Result := True;
    end
  else if umlMultipleMatch(['TrainDCGAN', 'TrainingDCGAN'], ComputeFunc) then
    begin
      ext := C_DCGAN_Ext;
      Result := True;
    end
  else if umlMultipleMatch(['TrainZMetricV2', 'TrainingZMetricV2'], ComputeFunc) then
    begin
      ext := C_ZMetric_V2_Ext;
      Result := True;
    end
  else if umlMultipleMatch(['YOLOX', 'YOLO-X', 'YOLO'], ComputeFunc) then
    begin
      ext := C_YOLO_X_Ext;
      Result := True;
    end
  else if umlMultipleMatch(['TrainSSL', 'TrainingSSL'], ComputeFunc) then
    begin
      ext := C_SSL_Ext;
      Result := True;
    end
  else
    begin
      report := 'illegal ComputeFunc.';
    end;

  DisposeObject(param);
  if Result then
      report := 'solve.'
  else
      report := 'error.';
end;

function TPas_AI_TrainingTask.BuildRestoreTrainingData(const paramFile: SystemString; var report: SystemString; dest: TPas_AI_TrainingTask): Boolean;
var
  param: THashVariantList;
  ComputeFunc: U_String;
  inputfile1, inputfile2, inputSyncFile1, inputSyncFile2: SystemString;
  outputfile1: SystemString;

  m1, m2: TMS64;
begin
  Result := IsNormalTraining(paramFile);
  if not Result then
      exit;
  Result := CheckTrainingBefore(paramFile, report);
  if not Result then
      exit;

  Result := False;
  param := THashVariantList.Create;
  Read(paramFile, param);

  if param.Exists('func') then
      ComputeFunc := param['func']
  else if param.Exists('compute') then
      ComputeFunc := param['compute']
  else
      ComputeFunc := param.GetDefaultValue_Str('ComputeFunc', '');

  ComputeFunc := ComputeFunc.TrimChar(#32#9);

  try
    if umlMultipleMatch(['surf', 'fastsurf'], ComputeFunc) then
      begin
        inputfile1 := param.GetDefaultValue_Str('source', '');
        inputfile2 := param.GetDefaultValue_Str('dest', '');
        outputfile1 := param.GetDefaultValue_Str('output', 'output.bmp');
        CopyTo(paramFile, dest, paramFile);
        CopyTo(inputfile1, dest, inputfile1);
        CopyTo(inputfile2, dest, inputfile2);
        Result := True;
      end
    else if umlMultipleMatch(['TrainOD', 'TrainingOD', 'TrainObjectDetector', 'TrainOD6L', 'TrainingOD6L', 'TrainObjectDetector6L'], ComputeFunc) then
      begin
        inputfile1 := param.GetDefaultValue_Str('source', '');
        outputfile1 := param.GetDefaultValue_Str('output', 'output' + C_OD6L_Ext);
        CopyTo(paramFile, dest, paramFile);
        CopyTo(inputfile1, dest, inputfile1);
        Result := True;
      end
    else if umlMultipleMatch(['TrainOD3L', 'TrainingOD3L', 'TrainObjectDetector3L'], ComputeFunc) then
      begin
        inputfile1 := param.GetDefaultValue_Str('source', '');
        outputfile1 := param.GetDefaultValue_Str('output', 'output' + C_OD3L_Ext);
        CopyTo(paramFile, dest, paramFile);
        CopyTo(inputfile1, dest, inputfile1);
        Result := True;
      end
    else if umlMultipleMatch(['TrainOD_Marshal', 'TrainingOD_Marshal', 'TrainObjectDetectorMarshal', 'TrainOD6L_Marshal', 'TrainingOD6L_Marshal', 'TrainObjectDetector6LMarshal'], ComputeFunc) then
      begin
        inputfile1 := param.GetDefaultValue_Str('source', '');
        outputfile1 := param.GetDefaultValue_Str('output', 'output' + C_OD6L_Marshal_Ext);
        CopyTo(paramFile, dest, paramFile);
        CopyTo(inputfile1, dest, inputfile1);
        Result := True;
      end
    else if umlMultipleMatch(['TrainSP', 'TrainingSP', 'TrainShapePredictor'], ComputeFunc) then
      begin
        inputfile1 := param.GetDefaultValue_Str('source', '');
        outputfile1 := param.GetDefaultValue_Str('output', 'output' + C_SP_Ext);
        CopyTo(paramFile, dest, paramFile);
        CopyTo(inputfile1, dest, inputfile1);
        Result := True;
      end
    else if umlMultipleMatch(['TrainMRN', 'TrainingMRN', 'TrainMetricResNet'], ComputeFunc) then
      begin
        { paramfile. }
        CopyTo(paramFile, dest, paramFile);
        { inputfile from on source value }
        inputfile1 := param.GetDefaultValue_Str('source', '');
        CopyTo(inputfile1, dest, inputfile1);
        { outputfile from on output value }
        outputfile1 := param.GetDefaultValue_Str('output', 'output' + C_Metric_Ext);
        if Exists(outputfile1) then
            CopyTo(outputfile1, dest, outputfile1);
        { syncfile }
        inputSyncFile1 := param.GetDefaultValue_Str('syncfile', 'output' + C_Sync_Ext);
        inputSyncFile2 := param.GetDefaultValue_Str('syncfile2', 'output' + C_Sync_Ext2);
        if Exists(inputSyncFile1) then
            CopyTo(inputSyncFile1, dest, inputSyncFile1);
        if Exists(inputSyncFile2) then
            CopyTo(inputSyncFile2, dest, inputSyncFile2);
        Result := True;
      end
    else if umlMultipleMatch(['TrainLMRN', 'TrainingLMRN', 'TrainLMetricResNet'], ComputeFunc) then
      begin
        { paramfile. }
        CopyTo(paramFile, dest, paramFile);
        { inputfile from on source value }
        inputfile1 := param.GetDefaultValue_Str('source', '');
        CopyTo(inputfile1, dest, inputfile1);
        { outputfile from on output value }
        outputfile1 := param.GetDefaultValue_Str('output', 'output' + C_LMetric_Ext);
        if Exists(outputfile1) then
            CopyTo(outputfile1, dest, outputfile1);
        { syncfile }
        inputSyncFile1 := param.GetDefaultValue_Str('syncfile', 'output' + C_Sync_Ext);
        inputSyncFile2 := param.GetDefaultValue_Str('syncfile2', 'output' + C_Sync_Ext2);
        if Exists(inputSyncFile1) then
            CopyTo(inputSyncFile1, dest, inputSyncFile1);
        if Exists(inputSyncFile2) then
            CopyTo(inputSyncFile2, dest, inputSyncFile2);
        Result := True;
      end
    else if umlMultipleMatch(['TrainMMOD', 'TrainingMMOD', 'TrainMaxMarginDNNObjectDetector', 'TrainMMOD6L', 'TrainingMMOD6L', 'TrainMaxMarginDNNObjectDetector6L'], ComputeFunc) then
      begin
        { paramfile. }
        CopyTo(paramFile, dest, paramFile);
        { inputfile from on source value }
        inputfile1 := param.GetDefaultValue_Str('source', '');
        CopyTo(inputfile1, dest, inputfile1);
        { outputfile from on output value }
        outputfile1 := param.GetDefaultValue_Str('output', 'output' + C_MMOD6L_Ext);
        if Exists(outputfile1) then
            CopyTo(outputfile1, dest, outputfile1);
        { syncfile }
        inputSyncFile1 := param.GetDefaultValue_Str('syncfile', 'output' + C_Sync_Ext);
        inputSyncFile2 := param.GetDefaultValue_Str('syncfile2', 'output' + C_Sync_Ext2);
        if Exists(inputSyncFile1) then
            CopyTo(inputSyncFile1, dest, inputSyncFile1);
        if Exists(inputSyncFile2) then
            CopyTo(inputSyncFile2, dest, inputSyncFile2);
        Result := True;
      end
    else if umlMultipleMatch(['TrainMMOD3L', 'TrainingMMOD3L', 'TrainMaxMarginDNNObjectDetector3L'], ComputeFunc) then
      begin
        { paramfile. }
        CopyTo(paramFile, dest, paramFile);
        { inputfile from on source value }
        inputfile1 := param.GetDefaultValue_Str('source', '');
        CopyTo(inputfile1, dest, inputfile1);
        { outputfile from on output value }
        outputfile1 := param.GetDefaultValue_Str('output', 'output' + C_MMOD3L_Ext);
        if Exists(outputfile1) then
            CopyTo(outputfile1, dest, outputfile1);
        { syncfile }
        inputSyncFile1 := param.GetDefaultValue_Str('syncfile', 'output' + C_Sync_Ext);
        inputSyncFile2 := param.GetDefaultValue_Str('syncfile2', 'output' + C_Sync_Ext2);
        if Exists(inputSyncFile1) then
            CopyTo(inputSyncFile1, dest, inputSyncFile1);
        if Exists(inputSyncFile2) then
            CopyTo(inputSyncFile2, dest, inputSyncFile2);
        Result := True;
      end
    else if umlMultipleMatch(['TrainRNIC', 'TrainingRNIC', 'TrainResNetImageClassifier'], ComputeFunc) then
      begin
        { paramfile. }
        CopyTo(paramFile, dest, paramFile);
        { inputfile from on source value }
        inputfile1 := param.GetDefaultValue_Str('source', '');
        CopyTo(inputfile1, dest, inputfile1);
        { outputfile from on output value }
        outputfile1 := param.GetDefaultValue_Str('output', 'output' + C_RNIC_Ext);
        if Exists(outputfile1) then
            CopyTo(outputfile1, dest, outputfile1);
        { syncfile }
        inputSyncFile1 := param.GetDefaultValue_Str('syncfile', 'output' + C_Sync_Ext);
        inputSyncFile2 := param.GetDefaultValue_Str('syncfile2', 'output' + C_Sync_Ext2);
        if Exists(inputSyncFile1) then
            CopyTo(inputSyncFile1, dest, inputSyncFile1);
        if Exists(inputSyncFile2) then
            CopyTo(inputSyncFile2, dest, inputSyncFile2);
        Result := True;
      end
    else if umlMultipleMatch(['TrainLRNIC', 'TrainingLRNIC', 'TrainLResNetImageClassifier'], ComputeFunc) then
      begin
        { paramfile. }
        CopyTo(paramFile, dest, paramFile);
        { inputfile from on source value }
        inputfile1 := param.GetDefaultValue_Str('source', '');
        CopyTo(inputfile1, dest, inputfile1);
        { outputfile from on output value }
        outputfile1 := param.GetDefaultValue_Str('output', 'output' + C_LRNIC_Ext);
        if Exists(outputfile1) then
            CopyTo(outputfile1, dest, outputfile1);
        { syncfile }
        inputSyncFile1 := param.GetDefaultValue_Str('syncfile', 'output' + C_Sync_Ext);
        inputSyncFile2 := param.GetDefaultValue_Str('syncfile2', 'output' + C_Sync_Ext2);
        if Exists(inputSyncFile1) then
            CopyTo(inputSyncFile1, dest, inputSyncFile1);
        if Exists(inputSyncFile2) then
            CopyTo(inputSyncFile2, dest, inputSyncFile2);
        Result := True;
      end
    else if umlMultipleMatch(['TrainGDCNIC', 'TrainingGDCNIC'], ComputeFunc) then
      begin
        { paramfile. }
        CopyTo(paramFile, dest, paramFile);
        { inputfile from on source value }
        inputfile1 := param.GetDefaultValue_Str('source', '');
        CopyTo(inputfile1, dest, inputfile1);
        { outputfile from on output value }
        outputfile1 := param.GetDefaultValue_Str('output', 'output' + C_GDCNIC_Ext);
        if Exists(outputfile1) then
            CopyTo(outputfile1, dest, outputfile1);
        { syncfile }
        inputSyncFile1 := param.GetDefaultValue_Str('syncfile', 'output' + C_Sync_Ext);
        inputSyncFile2 := param.GetDefaultValue_Str('syncfile2', 'output' + C_Sync_Ext2);
        if Exists(inputSyncFile1) then
            CopyTo(inputSyncFile1, dest, inputSyncFile1);
        if Exists(inputSyncFile2) then
            CopyTo(inputSyncFile2, dest, inputSyncFile2);
        Result := True;
      end
    else if umlMultipleMatch(['TrainGNIC', 'TrainingGNIC'], ComputeFunc) then
      begin
        { paramfile. }
        CopyTo(paramFile, dest, paramFile);
        { inputfile from on source value }
        inputfile1 := param.GetDefaultValue_Str('source', '');
        CopyTo(inputfile1, dest, inputfile1);
        { outputfile from on output value }
        outputfile1 := param.GetDefaultValue_Str('output', 'output' + C_GNIC_Ext);
        if Exists(outputfile1) then
            CopyTo(outputfile1, dest, outputfile1);
        { syncfile }
        inputSyncFile1 := param.GetDefaultValue_Str('syncfile', 'output' + C_Sync_Ext);
        inputSyncFile2 := param.GetDefaultValue_Str('syncfile2', 'output' + C_Sync_Ext2);
        if Exists(inputSyncFile1) then
            CopyTo(inputSyncFile1, dest, inputSyncFile1);
        if Exists(inputSyncFile2) then
            CopyTo(inputSyncFile2, dest, inputSyncFile2);
        Result := True;
      end
    else if umlMultipleMatch(['TrainSS', 'TrainingSS'], ComputeFunc) then
      begin
        { paramfile. }
        CopyTo(paramFile, dest, paramFile);
        { inputfile from on source value }
        inputfile1 := param.GetDefaultValue_Str('source', '');
        CopyTo(inputfile1, dest, inputfile1);
        { outputfile from on output value }
        outputfile1 := param.GetDefaultValue_Str('output', 'output' + C_SS_Ext);
        if Exists(outputfile1) then
            CopyTo(outputfile1, dest, outputfile1);
        { syncfile }
        inputSyncFile1 := param.GetDefaultValue_Str('syncfile', 'output' + C_Sync_Ext);
        inputSyncFile2 := param.GetDefaultValue_Str('syncfile2', 'output' + C_Sync_Ext2);
        if Exists(inputSyncFile1) then
            CopyTo(inputSyncFile1, dest, inputSyncFile1);
        if Exists(inputSyncFile2) then
            CopyTo(inputSyncFile2, dest, inputSyncFile2);
        Result := True;
      end
    else if umlMultipleMatch(['TrainZMetric', 'TrainingZMetric'], ComputeFunc) then
      begin
        { paramfile. }
        CopyTo(paramFile, dest, paramFile);
        { inputfile from on source value }
        inputfile1 := param.GetDefaultValue_Str('source', '');
        CopyTo(inputfile1, dest, inputfile1);
        { outputfile from on output value }
        outputfile1 := param.GetDefaultValue_Str('output', 'output' + C_ZMetric_Ext);
        if Exists(outputfile1) then
            CopyTo(outputfile1, dest, outputfile1);
        { syncfile }
        inputSyncFile1 := param.GetDefaultValue_Str('syncfile', 'output' + C_Sync_Ext);
        inputSyncFile2 := param.GetDefaultValue_Str('syncfile2', 'output' + C_Sync_Ext2);
        if Exists(inputSyncFile1) then
            CopyTo(inputSyncFile1, dest, inputSyncFile1);
        if Exists(inputSyncFile2) then
            CopyTo(inputSyncFile2, dest, inputSyncFile2);
        Result := True;
      end
    else if umlMultipleMatch(['TrainDCGAN', 'TrainingDCGAN'], ComputeFunc) then
      begin
        { paramfile. }
        CopyTo(paramFile, dest, paramFile);
        { inputfile from on source value }
        inputfile1 := param.GetDefaultValue_Str('source', '');
        CopyTo(inputfile1, dest, inputfile1);
        { outputfile from on output value }
        outputfile1 := param.GetDefaultValue_Str('output', 'output' + C_DCGAN_Ext);
        if Exists(outputfile1) then
            CopyTo(outputfile1, dest, outputfile1);
        { syncfile }
        inputSyncFile1 := param.GetDefaultValue_Str('syncfile', 'output' + C_Sync_Ext);
        inputSyncFile2 := param.GetDefaultValue_Str('syncfile2', 'output' + C_Sync_Ext2);
        if Exists(inputSyncFile1) then
            CopyTo(inputSyncFile1, dest, inputSyncFile1);
        if Exists(inputSyncFile2) then
            CopyTo(inputSyncFile2, dest, inputSyncFile2);
        Result := True;
      end
    else if umlMultipleMatch(['TrainZMetricV2', 'TrainingZMetricV2'], ComputeFunc) then
      begin
        { paramfile. }
        CopyTo(paramFile, dest, paramFile);
        { inputfile from on source value }
        inputfile1 := param.GetDefaultValue_Str('source', '');
        CopyTo(inputfile1, dest, inputfile1);
        { outputfile from on output value }
        outputfile1 := param.GetDefaultValue_Str('output', 'output' + C_ZMetric_V2_Ext);
        if Exists(outputfile1) then
            CopyTo(outputfile1, dest, outputfile1);
        { syncfile }
        inputSyncFile1 := param.GetDefaultValue_Str('syncfile', 'output' + C_Sync_Ext);
        inputSyncFile2 := param.GetDefaultValue_Str('syncfile2', 'output' + C_Sync_Ext2);
        if Exists(inputSyncFile1) then
            CopyTo(inputSyncFile1, dest, inputSyncFile1);
        if Exists(inputSyncFile2) then
            CopyTo(inputSyncFile2, dest, inputSyncFile2);
        Result := True;
      end
    else if umlMultipleMatch(['YOLOX', 'YOLO-X', 'YOLO'], ComputeFunc) then
      begin
        { paramfile. }
        CopyTo(paramFile, dest, paramFile);
        { inputfile from on source value }
        inputfile1 := param.GetDefaultValue_Str('source', '');
        CopyTo(inputfile1, dest, inputfile1);
        { outputfile from on output value }
        outputfile1 := param.GetDefaultValue_Str('output', 'output' + C_YOLO_X_Ext);
        if Exists(outputfile1) then
            CopyTo(outputfile1, dest, outputfile1);
        { syncfile }
        inputSyncFile1 := param.GetDefaultValue_Str('syncfile', 'output' + C_Sync_Ext);
        inputSyncFile2 := param.GetDefaultValue_Str('syncfile2', 'output' + C_Sync_Ext2);
        if Exists(inputSyncFile1) then
            CopyTo(inputSyncFile1, dest, inputSyncFile1);
        if Exists(inputSyncFile2) then
            CopyTo(inputSyncFile2, dest, inputSyncFile2);
        Result := True;
      end
  else if umlMultipleMatch(['TrainSSL', 'TrainingSSL'], ComputeFunc) then
      begin
        { paramfile. }
        CopyTo(paramFile, dest, paramFile);
        { inputfile from on source value }
        inputfile1 := param.GetDefaultValue_Str('source', '');
        CopyTo(inputfile1, dest, inputfile1);
        { outputfile from on output value }
        outputfile1 := param.GetDefaultValue_Str('output', 'output' + C_SSL_Ext);
        if Exists(outputfile1) then
            CopyTo(outputfile1, dest, outputfile1);
        { syncfile }
        inputSyncFile1 := param.GetDefaultValue_Str('syncfile', 'output' + C_Sync_Ext);
        inputSyncFile2 := param.GetDefaultValue_Str('syncfile2', 'output' + C_Sync_Ext2);
        if Exists(inputSyncFile1) then
            CopyTo(inputSyncFile1, dest, inputSyncFile1);
        if Exists(inputSyncFile2) then
            CopyTo(inputSyncFile2, dest, inputSyncFile2);
        Result := True;
      end
    else
      begin
        report := 'illegal ComputeFunc.';
      end;
  except
    Result := False;
    report := 'error.';
  end;

  DisposeObject(param);
  if Result then
      report := 'solve.';
end;

procedure TPas_AI_TrainingTask.ExportLastWriteToStream(stream: TMS64);
var
  dest_db: TObjectDataManager;
  i: Integer;
  m64: TMS64;
begin
  dest_db := TObjectDataManager.CreateAsStream(stream, '', DBMarshal.ID, False, True, False);

  for i := 0 to LastWriteFileList.Count - 1 do
    begin
      m64 := TMS64.CustomCreate($FFFF);
      DB_Engine.ItemReadToStream('/', LastWriteFileList[i], m64);
      m64.Position := 0;
      dest_db.ItemWriteFromStream('/', LastWriteFileList[i], m64);
      DisposeObject(m64);
    end;

  DisposeObject(dest_db);
end;

procedure TPas_AI_TrainingTask.ExportLastWriteToFile(filename: SystemString);
var
  m64: TMS64;
begin
  m64 := TMS64.CustomCreate($FFFF);
  ExportLastWriteToStream(m64);
  m64.SaveToFile(filename);
  DisposeObject(m64);
end;

function TPas_AI_TrainingTask.Is_AI_Legacy_Engine_Task(const paramFile: SystemString): Boolean;
var
  param: THashVariantList;
  ComputeFunc: SystemString;
begin
  Result := False;

  param := THashVariantList.Create;
  Read(paramFile, param);

  if param.Exists('func') then
      ComputeFunc := param['func']
  else if param.Exists('compute') then
      ComputeFunc := param['compute']
  else
      ComputeFunc := param.GetDefaultValue_Str('ComputeFunc', '');

  if umlMultipleMatch(['surf', 'fastsurf'], ComputeFunc) then
    begin
      Result := True;
    end
  else if umlMultipleMatch(['TrainOD', 'TrainingOD', 'TrainObjectDetector', 'TrainOD6L', 'TrainingOD6L', 'TrainObjectDetector6L'], ComputeFunc) then
    begin
      Result := True;
    end
  else if umlMultipleMatch(['TrainOD3L', 'TrainingOD3L', 'TrainObjectDetector3L'], ComputeFunc) then
    begin
      Result := True;
    end
  else if umlMultipleMatch(['TrainOD_Marshal', 'TrainingOD_Marshal', 'TrainObjectDetectorMarshal', 'TrainOD6L_Marshal', 'TrainingOD6L_Marshal', 'TrainObjectDetector6LMarshal'], ComputeFunc) then
    begin
      Result := True;
    end
  else if umlMultipleMatch(['TrainSP', 'TrainingSP', 'TrainShapePredictor'], ComputeFunc) then
    begin
      Result := True;
    end
  else if umlMultipleMatch(['TrainMRN', 'TrainingMRN', 'TrainMetricResNet'], ComputeFunc) then
    begin
      Result := True;
    end
  else if umlMultipleMatch(['TrainLMRN', 'TrainingLMRN', 'TrainLMetricResNet'], ComputeFunc) then
    begin
      Result := True;
    end
  else if umlMultipleMatch(['TrainMMOD', 'TrainingMMOD', 'TrainMaxMarginDNNObjectDetector', 'TrainMMOD6L', 'TrainingMMOD6L', 'TrainMaxMarginDNNObjectDetector6L'], ComputeFunc) then
    begin
      Result := True;
    end
  else if umlMultipleMatch(['TrainMMOD3L', 'TrainingMMOD3L', 'TrainMaxMarginDNNObjectDetector3L'], ComputeFunc) then
    begin
      Result := True;
    end
  else if umlMultipleMatch(['TrainRNIC', 'TrainingRNIC', 'TrainResNetImageClassifier'], ComputeFunc) then
    begin
      Result := True;
    end
  else if umlMultipleMatch(['TrainLRNIC', 'TrainingLRNIC', 'TrainLResNetImageClassifier'], ComputeFunc) then
    begin
      Result := True;
    end
  else if umlMultipleMatch(['TrainGDCNIC', 'TrainingGDCNIC'], ComputeFunc) then
    begin
      Result := True;
    end
  else if umlMultipleMatch(['TrainGNIC', 'TrainingGNIC'], ComputeFunc) then
    begin
      Result := True;
    end
  else if umlMultipleMatch(['TrainSS', 'TrainingSS'], ComputeFunc) then
    begin
      Result := True;
    end
  else if umlMultipleMatch(['TrainZMetric', 'TrainingZMetric'], ComputeFunc) then
    begin
      Result := True;
    end;
  DisposeObject(param);
end;

function TPas_AI_TrainingTask.Is_AI_TECH_2022_Task(const paramFile: SystemString): Boolean;
var
  param: THashVariantList;
  ComputeFunc: SystemString;
begin
  Result := False;

  param := THashVariantList.Create;
  Read(paramFile, param);

  if param.Exists('func') then
      ComputeFunc := param['func']
  else if param.Exists('compute') then
      ComputeFunc := param['compute']
  else
      ComputeFunc := param.GetDefaultValue_Str('ComputeFunc', '');

  if umlMultipleMatch(['TrainDCGAN', 'TrainingDCGAN'], ComputeFunc) then
    begin
      Result := True;
    end
  else if umlMultipleMatch(['TrainZMetricV2', 'TrainingZMetricV2'], ComputeFunc) then
    begin
      Result := True;
    end
  else if umlMultipleMatch(['YOLOX', 'YOLO-X', 'YOLO'], ComputeFunc) then
    begin
      Result := True;
    end
  else if umlMultipleMatch(['TrainSSL', 'TrainingSSL'], ComputeFunc) then
    begin
      Result := True;
    end;
  DisposeObject(param);
end;

end.
