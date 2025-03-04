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
{ * cloud 4.0 File System 1.0                                                  * }
{ ****************************************************************************** }
unit PasAI.Net.C4_FS;

{$DEFINE FPC_DELPHI_MODE}
{$I PasAI.Define.inc}

interface

uses
{$IFDEF FPC}
  PasAI.FPC.GenericList,
{$ELSE FPC}
  System.IOUtils,
{$ENDIF FPC}
  PasAI.Core, PasAI.PascalStrings, PasAI.UPascalStrings, PasAI.Status, PasAI.UnicodeMixedLib, PasAI.ListEngine,
  PasAI.Geometry2D, PasAI.DFE, PasAI.Json, PasAI.Expression, PasAI.OpCode,
  PasAI.Notify, PasAI.Cipher, PasAI.MemoryStream,
  PasAI.FragmentBuffer, // solve for discontinuous space
  PasAI.ZDB2, PasAI.ZDB2.MS64, PasAI.HashList.Templet,
  PasAI.Net, PasAI.Net.PhysicsIO, PasAI.Net.DoubleTunnelIO.NoAuth, PasAI.Net.C4;

type
  TC40_FS_Service = class;

  TFS_Service_File_Data = class(TCore_Object_Intermediate)
  public
    Owner: TC40_FS_Service;
    Stream: TZDB2_MS64;
    FileName: U_String;
    FileTime: TDateTime;
    FileMD5: TMD5;
    FileSize: Int64;
    constructor Create(Owner_: TC40_FS_Service; Stream_: TZDB2_MS64);
    destructor Destroy; override;
  end;

  TFS_Service_File_Data_Pool = TGeneric_String_Object_Hash<TFS_Service_File_Data>;

  TC40_FS_Service = class(TC40_Base_NoAuth_Service)
  protected
    // command
    procedure cmd_FS_PostFile(Sender: TPeerIO; InData: PByte; DataSize: NativeInt);
    procedure cmd_FS_GetFile(Sender: TPeerIO; InData: TDFE);
    procedure cmd_FS_GetFileMD5(Sender: TPeerIO; InData, OutData: TDFE);
    procedure cmd_FS_RemoveFile(Sender: TPeerIO; InData: TDFE);
    // admin
    procedure cmd_FS_Size(Sender: TPeerIO; InData, OutData: TDFE);
    procedure cmd_FS_Search(Sender: TPeerIO; InData, OutData: TDFE);
  private
    FIOHnd: TIOHnd;
  protected
    // console command
    procedure CC_Compress_And_Reload(var OP_Param: TOpParam);
  public
    // ZDB2 Core
    ZDB2RecycleMemoryTimeOut: TTimeTick;
    ZDB2DeltaSpace: Int64;
    ZDB2BlockSize: Word;
    ZDB2EnabledCipher: Boolean;
    ZDB2CipherName: U_String;
    ZDB2Password: U_String;
    ZDB2Cipher: TZDB2_Cipher;
    C40_FS_FileName: U_String;
    FileHashPool: TFS_Service_File_Data_Pool;
    FileDatabase: TZDB2_List_MS64;

    constructor Create(PhysicsService_: TC40_PhysicsService; ServiceTyp, Param_: U_String); override;
    destructor Destroy; override;
    procedure SafeCheck; override;
    procedure Progress; override;
  end;

  TC40_FS_Client = class;

{$REGION 'bridge_define'}

  TFS_Client_CacheData = class(TCore_Object_Intermediate)
    Owner: TC40_FS_Client;
    Stream: TZDB2_MS64;
    LastAccess: TTimeTick;
    constructor Create(Owner_: TC40_FS_Client);
    destructor Destroy; override;
  end;

  TFS_Client_CacheHashPool = TGeneric_String_Object_Hash<TFS_Client_CacheData>;

  TON_FS_PostFile_DoneC = procedure(Sender: TC40_FS_Client; info_: U_String);
  TON_FS_PostFile_DoneM = procedure(Sender: TC40_FS_Client; info_: U_String) of object;
{$IFDEF FPC}
  TON_FS_PostFile_DoneP = procedure(Sender: TC40_FS_Client; info_: U_String) is nested;
{$ELSE FPC}
  TON_FS_PostFile_DoneP = reference to procedure(Sender: TC40_FS_Client; info_: U_String);
{$ENDIF FPC}

  TFS_Temp_Post_File_Tunnel = class(TCore_Object_Intermediate)
  public
    p2pClient: TZNet_WithP2PVM_Client;
    Client: TC40_FS_Client;
    File_Name: U_String;
    Stream: TMS64;
    OnResultC: TON_FS_PostFile_DoneC;
    OnResultM: TON_FS_PostFile_DoneM;
    OnResultP: TON_FS_PostFile_DoneP;

    constructor Create;
    destructor Destroy; override;
    procedure DoP2PVM_CloneConnectAndPostFile(Sender: TZNet_WithP2PVM_Client);
    procedure cmd_PostDone(Sender: TPeerIO; InData: SystemString);
  end;

  TON_FS_GetFile_DoneC = procedure(Sender: TC40_FS_Client; Stream: TMS64; info_: U_String; Successed: Boolean);
  TON_FS_GetFile_DoneM = procedure(Sender: TC40_FS_Client; Stream: TMS64; info_: U_String; Successed: Boolean) of object;
{$IFDEF FPC}
  TON_FS_GetFile_DoneP = procedure(Sender: TC40_FS_Client; Stream: TMS64; info_: U_String; Successed: Boolean) is nested;
{$ELSE FPC}
  TON_FS_GetFile_DoneP = reference to procedure(Sender: TC40_FS_Client; Stream: TMS64; info_: U_String; Successed: Boolean);
{$ENDIF FPC}

  TFS_Temp_Get_File_Tunnel = class(TCore_Object_Intermediate)
  public
    p2pClient: TZNet_WithP2PVM_Client;
    Client: TC40_FS_Client;
    File_Name: U_String;
    OnResultC: TON_FS_GetFile_DoneC;
    OnResultM: TON_FS_GetFile_DoneM;
    OnResultP: TON_FS_GetFile_DoneP;

    constructor Create;
    destructor Destroy; override;
    procedure cmd_Save(Sender: TPeerIO; InData: PByte; DataSize: NativeInt);
    procedure cmd_Error(Sender: TPeerIO; InData: SystemString);
    procedure DoP2PVM_CloneConnectAndGetFile(Sender: TZNet_WithP2PVM_Client);
  end;

  TFS_Temp_GetFileMD5C = procedure(Sender: TC40_FS_Client; State_: Boolean; info_: SystemString; MD5_: TMD5);
  TFS_Temp_GetFileMD5M = procedure(Sender: TC40_FS_Client; State_: Boolean; info_: SystemString; MD5_: TMD5) of object;
{$IFDEF FPC}
  TFS_Temp_GetFileMD5P = procedure(Sender: TC40_FS_Client; State_: Boolean; info_: SystemString; MD5_: TMD5) is nested;
{$ELSE FPC}
  TFS_Temp_GetFileMD5P = reference to procedure(Sender: TC40_FS_Client; State_: Boolean; info_: SystemString; MD5_: TMD5);
{$ENDIF FPC}

  TFS_Temp_GetFileMD5 = class(TOnResult_Bridge)
  public
    Client: TC40_FS_Client;
    OnResultC: TFS_Temp_GetFileMD5C;
    OnResultM: TFS_Temp_GetFileMD5M;
    OnResultP: TFS_Temp_GetFileMD5P;
    constructor Create;
    procedure DoStreamParamEvent(Sender: TPeerIO; Param1: Pointer; Param2: TObject; SendData, Result_: TDFE); override;
    procedure DoStreamFailedEvent(Sender: TPeerIO; Param1: Pointer; Param2: TObject; SendData: TDFE); override;
  end;

  TFS_Temp_GetFileMD5_Cache = class(TCore_Object_Intermediate)
  public
    Client: TC40_FS_Client;
    File_Name: U_String;
    OnResultC: TON_FS_GetFile_DoneC;
    OnResultM: TON_FS_GetFile_DoneM;
    OnResultP: TON_FS_GetFile_DoneP;

    constructor Create;
    destructor Destroy; override;
    procedure Do_FS_GetFileMD5(Sender: TC40_FS_Client; State_: Boolean; info_: SystemString; MD5_: TMD5);
  end;

  TFS_FileSizeInfo = record
    FileName: SystemString;
    Size: Int64;
  end;

  TFS_FileSizeInfo_Array = array of TFS_FileSizeInfo;

  TFS_Temp_SizeC = procedure(Sender: TC40_FS_Client; arry: TFS_FileSizeInfo_Array);
  TFS_Temp_SizeM = procedure(Sender: TC40_FS_Client; arry: TFS_FileSizeInfo_Array) of object;
{$IFDEF FPC}
  TFS_Temp_SizeP = procedure(Sender: TC40_FS_Client; arry: TFS_FileSizeInfo_Array) is nested;
{$ELSE FPC}
  TFS_Temp_SizeP = reference to procedure(Sender: TC40_FS_Client; arry: TFS_FileSizeInfo_Array);
{$ENDIF FPC}

  TFS_Temp_Size = class(TOnResult_Bridge)
  public
    Client: TC40_FS_Client;
    OnResultC: TFS_Temp_SizeC;
    OnResultM: TFS_Temp_SizeM;
    OnResultP: TFS_Temp_SizeP;
    constructor Create;
    procedure DoStreamParamEvent(Sender: TPeerIO; Param1: Pointer; Param2: TObject; SendData, Result_: TDFE); override;
    procedure DoStreamFailedEvent(Sender: TPeerIO; Param1: Pointer; Param2: TObject; SendData: TDFE); override;
  end;

  TFS_FileInfo = record
    FileName: SystemString;
    FileTime: TDateTime;
    Size: Int64;
    MD5: TMD5;
  end;

  TFS_FileInfo_Array = array of TFS_FileInfo;

  TFS_Temp_SearchC = procedure(Sender: TC40_FS_Client; arry: TFS_FileInfo_Array);
  TFS_Temp_SearchM = procedure(Sender: TC40_FS_Client; arry: TFS_FileInfo_Array) of object;
{$IFDEF FPC}
  TFS_Temp_SearchP = procedure(Sender: TC40_FS_Client; arry: TFS_FileInfo_Array) is nested;
{$ELSE FPC}
  TFS_Temp_SearchP = reference to procedure(Sender: TC40_FS_Client; arry: TFS_FileInfo_Array);
{$ENDIF FPC}

  TFS_Temp_Search = class(TOnResult_Bridge)
  public
    Client: TC40_FS_Client;
    OnResultC: TFS_Temp_SearchC;
    OnResultM: TFS_Temp_SearchM;
    OnResultP: TFS_Temp_SearchP;
    constructor Create;
    procedure DoStreamParamEvent(Sender: TPeerIO; Param1: Pointer; Param2: TObject; SendData, Result_: TDFE); override;
    procedure DoStreamFailedEvent(Sender: TPeerIO; Param1: Pointer; Param2: TObject; SendData: TDFE); override;
  end;

{$ENDREGION 'bridge_define'}

  TC40_FS_Client = class(TC40_Base_NoAuth_Client)
  protected
    FMaxFileSize: Cardinal;
    FRemoveCacheList: TPascalStringList;
    procedure Do_DT_P2PVM_NoAuth_Custom_Client_TunnelLink(Sender: TDT_P2PVM_NoAuth_Custom_Client); override;
    procedure Do_Progress_FileCachePool(const Name_: PSystemString; Obj_: TFS_Client_CacheData);
  public
    C40_FS_Cache_FileName: U_String;
    ZDB2RecycleMemoryTimeOut: TTimeTick;
    ZDB2DeltaSpace: Int64;
    ZDB2BlockSize: Word;
    ZDB2EnabledCipher: Boolean;
    ZDB2CipherName: U_String;
    ZDB2Password: U_String;
    ZDB2Cipher: TZDB2_Cipher;
    Cache_File_Life: Int64;
    FileCacheHashPool: TFS_Client_CacheHashPool;
    Cache_Database: TZDB2_List_MS64;
    property MaxFileSize: Cardinal read FMaxFileSize;

    constructor Create(PhysicsTunnel_: TC40_PhysicsTunnel; source_: TC40_Info; Param_: U_String); override;
    destructor Destroy; override;
    procedure SafeCheck; override;
    procedure Progress; override;
    procedure RemoveCache(File_Name: U_String); overload;
    procedure RemoveCache(arry: U_StringArray); overload;
    // upload
    procedure FS_PostFile(File_Name: U_String; Stream: TCore_Stream; doneFree: Boolean);
    procedure FS_PostFile_C(File_Name: U_String; Stream: TCore_Stream; doneFree: Boolean; OnResult: TON_FS_PostFile_DoneC);
    procedure FS_PostFile_M(File_Name: U_String; Stream: TCore_Stream; doneFree: Boolean; OnResult: TON_FS_PostFile_DoneM);
    procedure FS_PostFile_P(File_Name: U_String; Stream: TCore_Stream; doneFree: Boolean; OnResult: TON_FS_PostFile_DoneP);
    // download
    procedure FS_GetFile_C(UsedCache_: Boolean; File_Name: U_String; OnResult: TON_FS_GetFile_DoneC);
    procedure FS_GetFile_M(UsedCache_: Boolean; File_Name: U_String; OnResult: TON_FS_GetFile_DoneM);
    procedure FS_GetFile_P(UsedCache_: Boolean; File_Name: U_String; OnResult: TON_FS_GetFile_DoneP);
    // md5
    procedure FS_GetFileMD5C(File_Name: U_String; OnResult: TFS_Temp_GetFileMD5C);
    procedure FS_GetFileMD5M(File_Name: U_String; OnResult: TFS_Temp_GetFileMD5M);
    procedure FS_GetFileMD5P(File_Name: U_String; OnResult: TFS_Temp_GetFileMD5P);
    // remove
    procedure FS_RemoveFile(File_Name: U_String); overload;
    procedure FS_RemoveFile(arry: U_StringArray); overload;
    // admin
    procedure FS_SizeC(FileNames: U_StringArray; OnResult: TFS_Temp_SizeC);
    procedure FS_SizeM(FileNames: U_StringArray; OnResult: TFS_Temp_SizeM);
    procedure FS_SizeP(FileNames: U_StringArray; OnResult: TFS_Temp_SizeP);
    procedure FS_SearchC(filter: U_String; MaxNum: Integer; OnResult: TFS_Temp_SearchC);
    procedure FS_SearchM(filter: U_String; MaxNum: Integer; OnResult: TFS_Temp_SearchM);
    procedure FS_SearchP(filter: U_String; MaxNum: Integer; OnResult: TFS_Temp_SearchP);
  end;

  TC40_FS_Client_List = TGenericsList<TC40_FS_Client>;

implementation

constructor TFS_Service_File_Data.Create(Owner_: TC40_FS_Service; Stream_: TZDB2_MS64);
begin
  inherited Create;
  Owner := Owner_;
  Stream := Stream_;
  FileName := '';
  FileTime := umlNow;
  FileMD5 := NullMD5;
  FileSize := 0;
end;

destructor TFS_Service_File_Data.Destroy;
begin
  FileName := '';
  if (Owner.FileDatabase <> nil) and (Stream <> nil) then
      Owner.FileDatabase.Remove(Stream, True);
  inherited Destroy;
end;

procedure TC40_FS_Service.cmd_FS_PostFile(Sender: TPeerIO; InData: PByte; DataSize: NativeInt);
var
  fd: TFS_Service_File_Data;
begin
  fd := TFS_Service_File_Data.Create(self, FileDatabase.NewData);
  fd.Stream.Data.WritePtr(InData, DataSize);
  fd.Stream.Data.Position := 0;
  fd.FileName := fd.Stream.Data.ReadString;
  fd.FileTime := fd.Stream.Data.ReadDouble;
  fd.FileMD5 := umlMD5(fd.Stream.Data.PosAsPtr, fd.Stream.Data.Size - fd.Stream.Data.Position);
  fd.FileSize := fd.Stream.Data.Size - fd.Stream.Data.Position;
  fd.Stream.Save;
  FileHashPool.Add(fd.FileName, fd);
  Sender.SendDirectConsoleCmd('PostDone', fd.FileName);
end;

procedure TC40_FS_Service.cmd_FS_GetFile(Sender: TPeerIO; InData: TDFE);
var
  File_Name: U_String;
  IO_ID: Cardinal;
  IO_: TPeerIO;
  fd: TFS_Service_File_Data;
begin
  File_Name := InData.R.ReadString;
  IO_ID := InData.R.ReadCardinal;
  IO_ := DTNoAuthService.RecvTunnel[IO_ID];
  if IO_ = nil then
      exit;
  fd := FileHashPool[File_Name];
  if fd = nil then
      IO_.SendDirectConsoleCmd('Error', PFormat('no found "%s"', [File_Name.Text]))
  else
    begin
      IO_.SendCompleteBuffer('Save', fd.Stream.Data.Clone, True);
      fd.Stream.Save;
    end;
end;

procedure TC40_FS_Service.cmd_FS_GetFileMD5(Sender: TPeerIO; InData, OutData: TDFE);
var
  File_Name: U_String;
  fd: TFS_Service_File_Data;
begin
  File_Name := InData.R.ReadString;
  fd := FileHashPool[File_Name];
  if fd = nil then
    begin
      OutData.WriteBool(False);
      OutData.WriteString('no found "%s"', [File_Name.Text]);
      OutData.WriteMD5(NullMD5);
    end
  else
    begin
      OutData.WriteBool(True);
      OutData.WriteString(fd.FileName);
      OutData.WriteMD5(fd.FileMD5);
    end;
end;

procedure TC40_FS_Service.cmd_FS_RemoveFile(Sender: TPeerIO; InData: TDFE);
var
  fn: U_String;
  fd: TFS_Service_File_Data;
begin
  while InData.R.NotEnd do
    begin
      fn := InData.R.ReadString;
      fd := FileHashPool[fn];
      if fd <> nil then
        begin
          fd.Stream.Remove;
          fd.Stream := nil;
          FileHashPool.Delete(fn);
        end;
    end;
end;

procedure TC40_FS_Service.cmd_FS_Size(Sender: TPeerIO; InData, OutData: TDFE);
var
  fd: TFS_Service_File_Data;
begin
  while InData.R.NotEnd do
    begin
      fd := FileHashPool[InData.R.ReadString];
      if fd = nil then
          OutData.WriteInt64(-1)
      else
          OutData.WriteInt64(fd.FileSize);
    end;
end;

procedure TC40_FS_Service.cmd_FS_Search(Sender: TPeerIO; InData, OutData: TDFE);
var
  filter_: U_String;
  MaxNum: Integer;
{$IFDEF FPC}
  procedure fpc_progress_(const Name_: PSystemString; Obj_: TFS_Service_File_Data);
  begin
    if (OutData.Count shr 2) > MaxNum then
        exit;
    if umlSearchMatch(filter_, Name_^) then
      begin
        OutData.WriteString(Obj_.FileName);
        OutData.WriteDouble(Obj_.FileTime);
        OutData.WriteInt64(Obj_.FileSize);
        OutData.WriteMD5(Obj_.FileMD5);
      end;
  end;
{$ENDIF FPC}


begin
  filter_ := InData.R.ReadString;
  MaxNum := InData.R.ReadInteger;

{$IFDEF FPC}
  FileHashPool.ProgressP(fpc_progress_);
{$ELSE FPC}
  FileHashPool.ProgressP(procedure(const Name_: PSystemString; Obj_: TFS_Service_File_Data)
    begin
      if (OutData.Count shr 2) > MaxNum then
          exit;
      if umlSearchMatch(filter_, Name_^) then
        begin
          OutData.WriteString(Obj_.FileName);
          OutData.WriteDouble(Obj_.FileTime);
          OutData.WriteInt64(Obj_.FileSize);
          OutData.WriteMD5(Obj_.FileMD5);
        end;
    end);
{$ENDIF FPC}

end;

procedure TC40_FS_Service.CC_Compress_And_Reload(var OP_Param: TOpParam);
var
  New_F: U_String;
  FS: TCore_FileStream;
begin
  New_F := Get_New_ZDB2_Extract_FileName(C40_FS_FileName);
  FS := TCore_FileStream.Create(New_F, fmCreate);
  FileDatabase.ExtractTo(FS);
  DisposeObject(FS);
end;

constructor TC40_FS_Service.Create(PhysicsService_: TC40_PhysicsService; ServiceTyp, Param_: U_String);
var
  FS: TCore_Stream;
  fd: TFS_Service_File_Data;
begin
  inherited Create(PhysicsService_, ServiceTyp, Param_);
  // max complete buffer 2M
  DTNoAuthService.RecvTunnel.MaxCompleteBufferSize := EStrToInt64(ParamList.GetDefaultValue('MaxBuffer', '2*1024*1024'), 2 * 1024 * 1024);
  DTNoAuthService.RecvTunnel.CompleteBufferCompressed := False;
  DTNoAuthService.RecvTunnel.RegisterCompleteBuffer('FS_PostFile').OnExecute := cmd_FS_PostFile;
  DTNoAuthService.RecvTunnel.RegisterDirectStream('FS_GetFile').OnExecute := cmd_FS_GetFile;
  DTNoAuthService.RecvTunnel.RegisterStream('FS_GetFileMD5').OnExecute := cmd_FS_GetFileMD5;
  DTNoAuthService.RecvTunnel.RegisterDirectStream('FS_RemoveFile').OnExecute := cmd_FS_RemoveFile;
  DTNoAuthService.RecvTunnel.RegisterStream('FS_Size').OnExecute := cmd_FS_Size;
  DTNoAuthService.RecvTunnel.RegisterStream('FS_Search').OnExecute := cmd_FS_Search;
  // instance
  ServiceInfo.OnlyInstance := True;
  UpdateToGlobalDispatch;
  ParamList.SetDefaultValue('OnlyInstance', if_(ServiceInfo.OnlyInstance, 'True', 'False'));

  ZDB2RecycleMemoryTimeOut := EStrToInt64(ParamList.GetDefaultValue('RecycleMemory', '5*1000'), 5 * 1000);
  ZDB2DeltaSpace := EStrToInt64(ParamList.GetDefaultValue('DeltaSpace', '128*1024*1024'), 128 * 1024 * 1024);
  ZDB2BlockSize := EStrToInt(ParamList.GetDefaultValue('BlockSize', '1536'), 1536);
  ZDB2EnabledCipher := EStrToBool(ParamList.GetDefaultValue('EnabledCipher', 'False'), False);
  ZDB2CipherName := ParamList.GetDefaultValue('Cipher', TCipher.CCipherSecurityName[TCipherSecurity.csNone]);
  ZDB2Password := ParamList.GetDefaultValue('Password', PasAI.Net.C4.C40_Password);

  if ZDB2EnabledCipher then
      ZDB2Cipher := TZDB2_Cipher.Create(ZDB2CipherName, ZDB2Password, 1, True, True)
  else
      ZDB2Cipher := nil;
  C40_FS_FileName := umlCombineFileName(DTNoAuthService.PublicFileDirectory, Get_DB_FileName_Config(PFormat('DTC40_%s.Space', [ServiceInfo.ServiceTyp.Text])));
  Check_And_Replace_ZDB2_Extract_FileName(C40_FS_FileName);

  FileHashPool := TFS_Service_File_Data_Pool.Create(True,
    EStrToInt64(ParamList.GetDefaultValue('File_HashPool', '4*1024*1024'), 4 * 1024 * 1024),
    nil);
  FileHashPool.IgnoreCase := True;

  if EStrToBool(ParamList.GetDefaultValue('ForeverSave', 'True'), True) and umlFileExists(C40_FS_FileName) then
    begin
{$IFDEF C4_Safe_Flush}
      FS := TSafe_Flush_Stream.Create(C40_FS_FileName, False, True);
{$ELSE C4_Safe_Flush}
      FS := TCore_FileStream.Create(C40_FS_FileName, fmOpenReadWrite);
{$ENDIF C4_Safe_Flush}
    end
  else
    begin
{$IFDEF C4_Safe_Flush}
      FS := TSafe_Flush_Stream.Create(C40_FS_FileName, True, True);
{$ELSE C4_Safe_Flush}
      FS := TCore_FileStream.Create(C40_FS_FileName, fmCreate);
{$ENDIF C4_Safe_Flush}
    end;

  FileDatabase := TZDB2_List_MS64.Create(
  TZDB2_MS64,
    nil,
    ZDB2RecycleMemoryTimeOut,
    FS,
    False,
    ZDB2DeltaSpace,
    ZDB2BlockSize,
    ZDB2Cipher);
  FileDatabase.AutoFreeStream := True;

  if FileDatabase.Count > 0 then
    with FileDatabase.Repeat_ do
      repeat
        fd := TFS_Service_File_Data.Create(self, Queue^.Data);
        fd.Stream.Data.Position := 0;
        fd.FileName := fd.Stream.Data.ReadString;
        fd.FileTime := fd.Stream.Data.ReadDouble;
        fd.FileMD5 := umlMD5(fd.Stream.Data.PosAsPtr, fd.Stream.Data.Size - fd.Stream.Data.Position);
        fd.FileSize := fd.Stream.Data.Size - fd.Stream.Data.Position;
        fd.Stream.RecycleMemory;
        FileHashPool.Add(fd.FileName, fd);
      until not Next;

  Register_ConsoleCommand('Compress_And_Reload', 'Compress file system and reload.').OnEvent_M := CC_Compress_And_Reload;
end;

destructor TC40_FS_Service.Destroy;
{$IFDEF FPC}
  procedure fpc_progress_(const Name_: PSystemString; Obj_: TFS_Service_File_Data);
  begin
    Obj_.Stream := nil;
  end;
{$ENDIF FPC}


begin
{$IFDEF FPC}
  FileHashPool.ProgressP(fpc_progress_);
{$ELSE FPC}
  FileHashPool.ProgressP(procedure(const Name_: PSystemString; Obj_: TFS_Service_File_Data)
    begin
      Obj_.Stream := nil;
    end);
{$ENDIF FPC}
  DisposeObjectAndNil(FileHashPool);
  DisposeObjectAndNil(FileDatabase);
  DisposeObjectAndNil(ZDB2Cipher);
  inherited Destroy;
end;

procedure TC40_FS_Service.SafeCheck;
begin
  inherited SafeCheck;
  FileDatabase.Flush;
end;

procedure TC40_FS_Service.Progress;
begin
  inherited Progress;
  FileDatabase.Progress;
end;

constructor TFS_Client_CacheData.Create(Owner_: TC40_FS_Client);
begin
  inherited Create;
  Owner := Owner_;
  Stream := Owner.Cache_Database.NewData;
  LastAccess := GetTimeTick();
end;

destructor TFS_Client_CacheData.Destroy;
begin
  Owner.Cache_Database.Remove(Stream, True);
  inherited Destroy;
end;

constructor TFS_Temp_Post_File_Tunnel.Create;
begin
  inherited Create;
  p2pClient := nil;
  Client := nil;
  File_Name := '';
  Stream := TMS64.Create;
  OnResultC := nil;
  OnResultM := nil;
  OnResultP := nil;
end;

destructor TFS_Temp_Post_File_Tunnel.Destroy;
begin
  DisposeObject(Stream);
  inherited Destroy;
end;

procedure TFS_Temp_Post_File_Tunnel.DoP2PVM_CloneConnectAndPostFile(Sender: TZNet_WithP2PVM_Client);
var
  tmp_File_Name_: U_String;
  tmp_Time_: TDateTime;
  Cache: TFS_Client_CacheData;
begin
  Stream.Position := 0;
  tmp_File_Name_ := Stream.ReadString;
  tmp_Time_ := Stream.ReadDouble;
  Cache := TFS_Client_CacheData.Create(Client);
  Client.FileCacheHashPool.Add(tmp_File_Name_, Cache);
  Sender.Print('build cache "%s"', [File_Name.Text]);
  Cache.Stream.Data.WritePtr(Stream.PosAsPtr, Stream.Size - Stream.Position);
  Cache.Stream.Save;
  Cache.LastAccess := GetTimeTick();
  Sender.Print('update cache "%s"', [File_Name.Text]);

  p2pClient := Sender;
  p2pClient.RegisterDirectConsole('PostDone').OnExecute := cmd_PostDone;
  Sender.SendCompleteBuffer('FS_PostFile', Stream.Memory, Stream.Size, True);
  Stream.DiscardMemory;
end;

procedure TFS_Temp_Post_File_Tunnel.cmd_PostDone(Sender: TPeerIO; InData: SystemString);
begin
  try
    if Assigned(OnResultC) then
        OnResultC(Client, InData)
    else if Assigned(OnResultM) then
        OnResultM(Client, InData)
    else if Assigned(OnResultP) then
        OnResultP(Client, InData);
  except
  end;
  p2pClient.P2PVM_Clone_NextProgressDoFreeSelf := True;
end;

constructor TFS_Temp_Get_File_Tunnel.Create;
begin
  inherited Create;
  p2pClient := nil;
  Client := nil;
  File_Name := '';
  OnResultC := nil;
  OnResultM := nil;
  OnResultP := nil;
end;

destructor TFS_Temp_Get_File_Tunnel.Destroy;
begin
  inherited Destroy;
end;

procedure TFS_Temp_Get_File_Tunnel.cmd_Save(Sender: TPeerIO; InData: PByte; DataSize: NativeInt);
var
  tmp1, tmp2: TMS64;
  tmp_File_Name_: U_String;
  tmp_Time_: TDateTime;
  Cache: TFS_Client_CacheData;
begin
  tmp1 := TMS64.Create;
  tmp1.Mapping(InData, DataSize);
  tmp_File_Name_ := tmp1.ReadString;
  tmp_Time_ := tmp1.ReadDouble;
  tmp2 := TMS64.Create;
  tmp2.Mapping(tmp1.PosAsPtr, tmp1.Size - tmp1.Position);

  Cache := TFS_Client_CacheData.Create(Client);
  Client.FileCacheHashPool.Add(tmp_File_Name_, Cache);
  Sender.Print('build cache "%s"', [tmp_File_Name_.Text]);
  Cache.Stream.Data.LoadFromStream(tmp2);
  Cache.Stream.Save;
  Cache.LastAccess := GetTimeTick();
  Sender.Print('update cache "%s"', [tmp_File_Name_.Text]);

  try
    if Assigned(OnResultC) then
        OnResultC(Client, tmp2, tmp_File_Name_, True)
    else if Assigned(OnResultM) then
        OnResultM(Client, tmp2, tmp_File_Name_, True)
    else if Assigned(OnResultP) then
        OnResultP(Client, tmp2, tmp_File_Name_, True);
  except
  end;

  DisposeObject(tmp1);
  DisposeObject(tmp2);

  p2pClient.P2PVM_Clone_NextProgressDoFreeSelf := True;
end;

procedure TFS_Temp_Get_File_Tunnel.cmd_Error(Sender: TPeerIO; InData: SystemString);
begin
  try
    if Assigned(OnResultC) then
        OnResultC(Client, nil, InData, False)
    else if Assigned(OnResultM) then
        OnResultM(Client, nil, InData, False)
    else if Assigned(OnResultP) then
        OnResultP(Client, nil, InData, False);
  except
  end;

  p2pClient.P2PVM_Clone_NextProgressDoFreeSelf := True;
end;

procedure TFS_Temp_Get_File_Tunnel.DoP2PVM_CloneConnectAndGetFile(Sender: TZNet_WithP2PVM_Client);
var
  d: TDFE;
begin
  p2pClient := Sender;
  Sender.RegisterCompleteBuffer('Save').OnExecute := cmd_Save;
  Sender.RegisterDirectConsole('Error').OnExecute := cmd_Error;
  d := TDFE.Create;
  d.WriteString(File_Name);
  d.WriteCardinal(Sender.ClientIO.id);
  Client.DTNoAuthClient.SendTunnel.SendDirectStreamCmd('FS_GetFile', d);
  DisposeObject(d);
end;

constructor TFS_Temp_GetFileMD5.Create;
begin
  inherited Create;
  Client := nil;
  OnResultC := nil;
  OnResultM := nil;
  OnResultP := nil;
end;

procedure TFS_Temp_GetFileMD5.DoStreamParamEvent(Sender: TPeerIO; Param1: Pointer; Param2: TObject; SendData, Result_: TDFE);
var
  State_: Boolean;
  info_: SystemString;
  MD5: TMD5;
begin
  State_ := False;
  info_ := 'error';
  MD5 := NullMD5;
  if Result_.Count >= 2 then
    begin
      State_ := Result_.R.ReadBool;
      info_ := Result_.R.ReadString;
      MD5 := Result_.R.ReadMD5;
    end;

  try
    if Assigned(OnResultC) then
        OnResultC(Client, State_, info_, MD5)
    else if Assigned(OnResultM) then
        OnResultM(Client, State_, info_, MD5)
    else if Assigned(OnResultP) then
        OnResultP(Client, State_, info_, MD5);
  except
  end;
  DelayFreeObject(1.0, self);
end;

procedure TFS_Temp_GetFileMD5.DoStreamFailedEvent(Sender: TPeerIO; Param1: Pointer; Param2: TObject; SendData: TDFE);
var
  State_: Boolean;
  info_: SystemString;
  MD5: TMD5;
begin
  State_ := False;
  info_ := 'error.';
  MD5 := NullMD5;

  try
    if Assigned(OnResultC) then
        OnResultC(Client, State_, info_, MD5)
    else if Assigned(OnResultM) then
        OnResultM(Client, State_, info_, MD5)
    else if Assigned(OnResultP) then
        OnResultP(Client, State_, info_, MD5);
  except
  end;
  DelayFreeObject(1.0, self);
end;

constructor TFS_Temp_GetFileMD5_Cache.Create;
begin
  inherited Create;
  Client := nil;
  File_Name := '';
  OnResultC := nil;
  OnResultM := nil;
  OnResultP := nil;
end;

destructor TFS_Temp_GetFileMD5_Cache.Destroy;
begin
  File_Name := '';
  inherited Destroy;
end;

procedure TFS_Temp_GetFileMD5_Cache.Do_FS_GetFileMD5(Sender: TC40_FS_Client; State_: Boolean; info_: SystemString; MD5_: TMD5);
var
  Cache: TFS_Client_CacheData;
  tmp: TFS_Temp_Get_File_Tunnel;
begin
  if not State_ then
    begin
      try
        if Assigned(OnResultC) then
            OnResultC(Client, nil, File_Name, False)
        else if Assigned(OnResultM) then
            OnResultM(Client, nil, File_Name, False)
        else if Assigned(OnResultP) then
            OnResultP(Client, nil, File_Name, False);
      except
      end;
      Client.DTNoAuth.ProgressEngine.PostDelayFreeObject(1.0, self, nil);
      exit;
    end;

  Cache := Client.FileCacheHashPool[File_Name];
  if (Cache <> nil) then
    begin
      if umlMD5Compare(umlStreamMD5(Cache.Stream.Data), MD5_) then
        begin
          Cache.LastAccess := GetTimeTick();
          Sender.DTNoAuth.RecvTunnel.Print('get file "%s" from cache', [File_Name.Text]);
          try
            Cache.Stream.Data.Position := 0;
            if Assigned(OnResultC) then
                OnResultC(Client, Cache.Stream.Data, File_Name, True)
            else if Assigned(OnResultM) then
                OnResultM(Client, Cache.Stream.Data, File_Name, True)
            else if Assigned(OnResultP) then
                OnResultP(Client, Cache.Stream.Data, File_Name, True);
          except
          end;
          Client.DTNoAuth.ProgressEngine.PostDelayFreeObject(1.0, self, nil);
          exit;
        end;
    end;

  tmp := TFS_Temp_Get_File_Tunnel.Create;
  tmp.Client := Client;
  tmp.File_Name := File_Name;
  tmp.OnResultC := OnResultC;
  tmp.OnResultM := OnResultM;
  tmp.OnResultP := OnResultP;
  Client.Client.SendTunnel.CloneConnectM(tmp.DoP2PVM_CloneConnectAndGetFile);
  Client.DTNoAuth.ProgressEngine.PostDelayFreeObject(1.0, self, nil);
end;

constructor TFS_Temp_Size.Create;
begin
  inherited Create;
  Client := nil;
  OnResultC := nil;
  OnResultM := nil;
  OnResultP := nil;
end;

procedure TFS_Temp_Size.DoStreamParamEvent(Sender: TPeerIO; Param1: Pointer; Param2: TObject; SendData, Result_: TDFE);
var
  arry: TFS_FileSizeInfo_Array;
  i: Integer;
begin
  SendData.R.Index := 0;
  SetLength(arry, Result_.Count);
  i := 0;
  while Result_.R.NotEnd do
    begin
      arry[i].FileName := SendData.R.ReadString;
      arry[i].Size := Result_.R.ReadInt64;
      inc(i);
    end;

  try
    if Assigned(OnResultC) then
        OnResultC(Client, arry)
    else if Assigned(OnResultM) then
        OnResultM(Client, arry)
    else if Assigned(OnResultP) then
        OnResultP(Client, arry);
  except
  end;
  DelayFreeObject(1.0, self);
end;

procedure TFS_Temp_Size.DoStreamFailedEvent(Sender: TPeerIO; Param1: Pointer; Param2: TObject; SendData: TDFE);
var
  arry: TFS_FileSizeInfo_Array;
begin
  SetLength(arry, 0);

  try
    if Assigned(OnResultC) then
        OnResultC(Client, arry)
    else if Assigned(OnResultM) then
        OnResultM(Client, arry)
    else if Assigned(OnResultP) then
        OnResultP(Client, arry);
  except
  end;
  DelayFreeObject(1.0, self);
end;

constructor TFS_Temp_Search.Create;
begin
  inherited Create;
  Client := nil;
  OnResultC := nil;
  OnResultM := nil;
  OnResultP := nil;
end;

procedure TFS_Temp_Search.DoStreamParamEvent(Sender: TPeerIO; Param1: Pointer; Param2: TObject; SendData, Result_: TDFE);
var
  arry: TFS_FileInfo_Array;
  i: Integer;
begin
  SetLength(arry, Result_.Count shr 2);
  i := 0;
  while Result_.R.NotEnd do
    begin
      arry[i].FileName := Result_.R.ReadString;
      arry[i].FileTime := Result_.R.ReadDouble;
      arry[i].Size := Result_.R.ReadInt64;
      arry[i].MD5 := Result_.R.ReadMD5;
      inc(i);
    end;

  try
    if Assigned(OnResultC) then
        OnResultC(Client, arry)
    else if Assigned(OnResultM) then
        OnResultM(Client, arry)
    else if Assigned(OnResultP) then
        OnResultP(Client, arry);
  except
  end;
  DelayFreeObject(1.0, self);
end;

procedure TFS_Temp_Search.DoStreamFailedEvent(Sender: TPeerIO; Param1: Pointer; Param2: TObject; SendData: TDFE);
var
  arry: TFS_FileInfo_Array;
begin
  SetLength(arry, 0);

  try
    if Assigned(OnResultC) then
        OnResultC(Client, arry)
    else if Assigned(OnResultM) then
        OnResultM(Client, arry)
    else if Assigned(OnResultP) then
        OnResultP(Client, arry);
  except
  end;
  DelayFreeObject(1.0, self);
end;

procedure TC40_FS_Client.Do_DT_P2PVM_NoAuth_Custom_Client_TunnelLink(Sender: TDT_P2PVM_NoAuth_Custom_Client);
begin
  inherited Do_DT_P2PVM_NoAuth_Custom_Client_TunnelLink(Sender);
  FMaxFileSize := DTNoAuth.SendTunnel.ServerState^.MaxCompleteBufferSize;
end;

procedure TC40_FS_Client.Do_Progress_FileCachePool(const Name_: PSystemString; Obj_: TFS_Client_CacheData);
begin
  if GetTimeTick() - Obj_.LastAccess > Cache_File_Life then
      FRemoveCacheList.Add(Name_^);
end;

constructor TC40_FS_Client.Create(PhysicsTunnel_: TC40_PhysicsTunnel; source_: TC40_Info; Param_: U_String);
var
  i: Integer;
begin
  inherited Create(PhysicsTunnel_, source_, Param_);
  C40_FS_Cache_FileName := umlCombineFileName({$IFDEF FPC}C40_RootPath{$ELSE FPC}TPath.GetTempPath{$ENDIF FPC},
    PFormat('DTC40_FS_Cache_%s_%s.tmp', [source_.ServiceTyp.Text, umlMD5ToStr(source_.Hash).Text]));
  i := 1;
  while umlFileExists(C40_FS_Cache_FileName) do
    begin
      C40_FS_Cache_FileName := umlCombineFileName({$IFDEF FPC}C40_RootPath{$ELSE FPC}TPath.GetTempPath{$ENDIF FPC},
        PFormat('DTC40_FS_Cache_%s_%s(%d).tmp', [source_.ServiceTyp.Text, umlMD5ToStr(source_.Hash).Text, i]));
      inc(i);
    end;

  ZDB2RecycleMemoryTimeOut := EStrToInt64(ParamList.GetDefaultValue('RecycleMemory', '5*1000'), 5 * 1000);
  ZDB2DeltaSpace := EStrToInt64(ParamList.GetDefaultValue('DeltaSpace', '128*1024*1024'), 128 * 1024 * 1024);
  ZDB2BlockSize := EStrToInt(ParamList.GetDefaultValue('BlockSize', '1536'), 1536);
  ZDB2EnabledCipher := EStrToBool(ParamList.GetDefaultValue('EnabledCipher', 'False'), False);
  ZDB2CipherName := ParamList.GetDefaultValue('Cipher', TCipher.CCipherSecurityName[TCipherSecurity.csNone]);
  ZDB2Password := ParamList.GetDefaultValue('Password', PasAI.Net.C4.C40_Password);
  Cache_File_Life := EStrToInt64(ParamList.GetDefaultValue('CacheLife', '10*60*1000'), 10 * 60 * 1000);

  if ZDB2EnabledCipher then
      ZDB2Cipher := TZDB2_Cipher.Create(ZDB2CipherName, ZDB2Password, 1, True, True)
  else
      ZDB2Cipher := nil;

  FileCacheHashPool := TFS_Client_CacheHashPool.Create(True,
    EStrToInt64(ParamList.GetDefaultValue('File_HashPool', '4*1024*1024'), 4 * 1024 * 1024),
    nil);

  Cache_Database := TZDB2_List_MS64.Create(
  TZDB2_MS64,
    nil,
    ZDB2RecycleMemoryTimeOut,
    TCore_FileStream.Create(C40_FS_Cache_FileName, fmCreate),
    False,
    ZDB2DeltaSpace,
    ZDB2BlockSize,
    ZDB2Cipher);
  Cache_Database.CoreSpace.Mode := smBigData;
  Cache_Database.AutoFreeStream := True;

  FMaxFileSize := 0;
  FRemoveCacheList := TPascalStringList.Create;
end;

destructor TC40_FS_Client.Destroy;
begin
  DisposeObject(FileCacheHashPool);
  DisposeObject(Cache_Database);
  umlDeleteFile(C40_FS_Cache_FileName);
  DisposeObject(FRemoveCacheList);
  DisposeObjectAndNil(ZDB2Cipher);
  inherited Destroy;
end;

procedure TC40_FS_Client.SafeCheck;
var
  i: Integer;
begin
  inherited SafeCheck;
  FRemoveCacheList.Clear;
  FileCacheHashPool.ProgressM(Do_Progress_FileCachePool);
  if FRemoveCacheList.Count > 0 then
    begin
      for i := 0 to FRemoveCacheList.Count - 1 do
          FileCacheHashPool.Delete(FRemoveCacheList[i]);
      FRemoveCacheList.Clear;
    end;
  Cache_Database.Flush;
end;

procedure TC40_FS_Client.Progress;
begin
  inherited Progress;
  Cache_Database.Progress;
end;

procedure TC40_FS_Client.RemoveCache(File_Name: U_String);
begin
  FileCacheHashPool.Delete(File_Name);
end;

procedure TC40_FS_Client.RemoveCache(arry: U_StringArray);
var
  i: Integer;
begin
  for i := low(arry) to high(arry) do
      FileCacheHashPool.Delete(arry[i]);
end;

procedure TC40_FS_Client.FS_PostFile(File_Name: U_String; Stream: TCore_Stream; doneFree: Boolean);
var
  tmp: TFS_Temp_Post_File_Tunnel;
begin
  if Stream.Size = 0 then
    begin
      if doneFree then
          DisposeObject(Stream);
      exit;
    end;
  tmp := TFS_Temp_Post_File_Tunnel.Create;
  tmp.Client := self;
  tmp.File_Name := File_Name;
  tmp.Stream.WriteString(File_Name);
  tmp.Stream.WriteDouble(umlNow);
  Stream.Position := 0;
  tmp.Stream.CopyFrom(Stream, Stream.Size);
  Client.SendTunnel.CloneConnectM(tmp.DoP2PVM_CloneConnectAndPostFile);
  if doneFree then
      DisposeObject(Stream);
end;

procedure TC40_FS_Client.FS_PostFile_C(File_Name: U_String; Stream: TCore_Stream; doneFree: Boolean; OnResult: TON_FS_PostFile_DoneC);
var
  tmp: TFS_Temp_Post_File_Tunnel;
begin
  if Stream.Size = 0 then
    begin
      if doneFree then
          DisposeObject(Stream);
      exit;
    end;
  tmp := TFS_Temp_Post_File_Tunnel.Create;
  tmp.Client := self;
  tmp.File_Name := File_Name;
  tmp.OnResultC := OnResult;
  tmp.Stream.WriteString(File_Name);
  tmp.Stream.WriteDouble(umlNow);
  Stream.Position := 0;
  tmp.Stream.CopyFrom(Stream, Stream.Size);
  Client.SendTunnel.CloneConnectM(tmp.DoP2PVM_CloneConnectAndPostFile);
  if doneFree then
      DisposeObject(Stream);
end;

procedure TC40_FS_Client.FS_PostFile_M(File_Name: U_String; Stream: TCore_Stream; doneFree: Boolean; OnResult: TON_FS_PostFile_DoneM);
var
  tmp: TFS_Temp_Post_File_Tunnel;
begin
  if Stream.Size = 0 then
    begin
      if doneFree then
          DisposeObject(Stream);
      exit;
    end;
  tmp := TFS_Temp_Post_File_Tunnel.Create;
  tmp.Client := self;
  tmp.File_Name := File_Name;
  tmp.OnResultM := OnResult;
  tmp.Stream.WriteString(File_Name);
  tmp.Stream.WriteDouble(umlNow);
  Stream.Position := 0;
  tmp.Stream.CopyFrom(Stream, Stream.Size);
  Client.SendTunnel.CloneConnectM(tmp.DoP2PVM_CloneConnectAndPostFile);
  if doneFree then
      DisposeObject(Stream);
end;

procedure TC40_FS_Client.FS_PostFile_P(File_Name: U_String; Stream: TCore_Stream; doneFree: Boolean; OnResult: TON_FS_PostFile_DoneP);
var
  tmp: TFS_Temp_Post_File_Tunnel;
begin
  if Stream.Size = 0 then
    begin
      if doneFree then
          DisposeObject(Stream);
      exit;
    end;
  tmp := TFS_Temp_Post_File_Tunnel.Create;
  tmp.Client := self;
  tmp.File_Name := File_Name;
  tmp.OnResultP := OnResult;
  tmp.Stream.WriteString(File_Name);
  tmp.Stream.WriteDouble(umlNow);
  Stream.Position := 0;
  tmp.Stream.CopyFrom(Stream, Stream.Size);
  Client.SendTunnel.CloneConnectM(tmp.DoP2PVM_CloneConnectAndPostFile);
  if doneFree then
      DisposeObject(Stream);
end;

procedure TC40_FS_Client.FS_GetFile_C(UsedCache_: Boolean; File_Name: U_String; OnResult: TON_FS_GetFile_DoneC);
var
  tmp_cache_: TFS_Temp_GetFileMD5_Cache;
  tmp: TFS_Temp_Get_File_Tunnel;
begin
  if UsedCache_ and FileCacheHashPool.Exists(File_Name) then
    begin
      tmp_cache_ := TFS_Temp_GetFileMD5_Cache.Create;
      tmp_cache_.Client := self;
      tmp_cache_.File_Name := File_Name;
      tmp_cache_.OnResultC := OnResult;
      FS_GetFileMD5M(File_Name, tmp_cache_.Do_FS_GetFileMD5);
    end
  else
    begin
      tmp := TFS_Temp_Get_File_Tunnel.Create;
      tmp.Client := self;
      tmp.File_Name := File_Name;
      tmp.OnResultC := OnResult;
      Client.SendTunnel.CloneConnectM(tmp.DoP2PVM_CloneConnectAndGetFile);
    end;
end;

procedure TC40_FS_Client.FS_GetFile_M(UsedCache_: Boolean; File_Name: U_String; OnResult: TON_FS_GetFile_DoneM);
var
  tmp_cache_: TFS_Temp_GetFileMD5_Cache;
  tmp: TFS_Temp_Get_File_Tunnel;
begin
  if UsedCache_ and FileCacheHashPool.Exists(File_Name) then
    begin
      tmp_cache_ := TFS_Temp_GetFileMD5_Cache.Create;
      tmp_cache_.Client := self;
      tmp_cache_.File_Name := File_Name;
      tmp_cache_.OnResultM := OnResult;
      FS_GetFileMD5M(File_Name, tmp_cache_.Do_FS_GetFileMD5);
    end
  else
    begin
      tmp := TFS_Temp_Get_File_Tunnel.Create;
      tmp.Client := self;
      tmp.File_Name := File_Name;
      tmp.OnResultM := OnResult;
      Client.SendTunnel.CloneConnectM(tmp.DoP2PVM_CloneConnectAndGetFile);
    end;
end;

procedure TC40_FS_Client.FS_GetFile_P(UsedCache_: Boolean; File_Name: U_String; OnResult: TON_FS_GetFile_DoneP);
var
  tmp_cache_: TFS_Temp_GetFileMD5_Cache;
  tmp: TFS_Temp_Get_File_Tunnel;
begin
  if UsedCache_ and FileCacheHashPool.Exists(File_Name) then
    begin
      tmp_cache_ := TFS_Temp_GetFileMD5_Cache.Create;
      tmp_cache_.Client := self;
      tmp_cache_.File_Name := File_Name;
      tmp_cache_.OnResultP := OnResult;
      FS_GetFileMD5M(File_Name, tmp_cache_.Do_FS_GetFileMD5);
    end
  else
    begin
      tmp := TFS_Temp_Get_File_Tunnel.Create;
      tmp.Client := self;
      tmp.File_Name := File_Name;
      tmp.OnResultP := OnResult;
      Client.SendTunnel.CloneConnectM(tmp.DoP2PVM_CloneConnectAndGetFile);
    end;
end;

procedure TC40_FS_Client.FS_GetFileMD5C(File_Name: U_String; OnResult: TFS_Temp_GetFileMD5C);
var
  tmp: TFS_Temp_GetFileMD5;
  d: TDFE;
begin
  tmp := TFS_Temp_GetFileMD5.Create;
  tmp.Client := self;
  tmp.OnResultC := OnResult;
  d := TDFE.Create;
  d.WriteString(File_Name);
  DTNoAuthClient.SendTunnel.SendStreamCmdM('FS_GetFileMD5', d, nil, nil,
    tmp.DoStreamParamEvent, tmp.DoStreamFailedEvent);
  DisposeObject(d);
end;

procedure TC40_FS_Client.FS_GetFileMD5M(File_Name: U_String; OnResult: TFS_Temp_GetFileMD5M);
var
  tmp: TFS_Temp_GetFileMD5;
  d: TDFE;
begin
  tmp := TFS_Temp_GetFileMD5.Create;
  tmp.Client := self;
  tmp.OnResultM := OnResult;
  d := TDFE.Create;
  d.WriteString(File_Name);
  DTNoAuthClient.SendTunnel.SendStreamCmdM('FS_GetFileMD5', d, nil, nil,
    tmp.DoStreamParamEvent, tmp.DoStreamFailedEvent);
  DisposeObject(d);
end;

procedure TC40_FS_Client.FS_GetFileMD5P(File_Name: U_String; OnResult: TFS_Temp_GetFileMD5P);
var
  tmp: TFS_Temp_GetFileMD5;
  d: TDFE;
begin
  tmp := TFS_Temp_GetFileMD5.Create;
  tmp.Client := self;
  tmp.OnResultP := OnResult;
  d := TDFE.Create;
  d.WriteString(File_Name);
  DTNoAuthClient.SendTunnel.SendStreamCmdM('FS_GetFileMD5', d, nil, nil,
    tmp.DoStreamParamEvent, tmp.DoStreamFailedEvent);
  DisposeObject(d);
end;

procedure TC40_FS_Client.FS_RemoveFile(File_Name: U_String);
var
  d: TDFE;
begin
  FileCacheHashPool.Delete(File_Name);
  d := TDFE.Create;
  d.WriteString(File_Name);
  DTNoAuthClient.SendTunnel.SendDirectStreamCmd('FS_RemoveFile', d);
  DisposeObject(d);
end;

procedure TC40_FS_Client.FS_RemoveFile(arry: U_StringArray);
var
  d: TDFE;
  i: Integer;
begin
  d := TDFE.Create;
  for i := low(arry) to high(arry) do
    begin
      FileCacheHashPool.Delete(arry[i]);
      d.WriteString(arry[i]);
    end;
  DTNoAuthClient.SendTunnel.SendDirectStreamCmd('FS_RemoveFile', d);
  DisposeObject(d);
end;

procedure TC40_FS_Client.FS_SizeC(FileNames: U_StringArray; OnResult: TFS_Temp_SizeC);
var
  tmp: TFS_Temp_Size;
  d: TDFE;
  i: Integer;
begin
  tmp := TFS_Temp_Size.Create;
  tmp.Client := self;
  tmp.OnResultC := OnResult;
  d := TDFE.Create;
  for i := 0 to length(FileNames) - 1 do
      d.WriteString(FileNames[i]);
  DTNoAuthClient.SendTunnel.SendStreamCmdM('FS_Size', d, nil, nil,
    tmp.DoStreamParamEvent, tmp.DoStreamFailedEvent);
  DisposeObject(d);
end;

procedure TC40_FS_Client.FS_SizeM(FileNames: U_StringArray; OnResult: TFS_Temp_SizeM);
var
  tmp: TFS_Temp_Size;
  d: TDFE;
  i: Integer;
begin
  tmp := TFS_Temp_Size.Create;
  tmp.Client := self;
  tmp.OnResultM := OnResult;
  d := TDFE.Create;
  for i := 0 to length(FileNames) - 1 do
      d.WriteString(FileNames[i]);
  DTNoAuthClient.SendTunnel.SendStreamCmdM('FS_Size', d, nil, nil,
    tmp.DoStreamParamEvent, tmp.DoStreamFailedEvent);
  DisposeObject(d);
end;

procedure TC40_FS_Client.FS_SizeP(FileNames: U_StringArray; OnResult: TFS_Temp_SizeP);
var
  tmp: TFS_Temp_Size;
  d: TDFE;
  i: Integer;
begin
  tmp := TFS_Temp_Size.Create;
  tmp.Client := self;
  tmp.OnResultP := OnResult;
  d := TDFE.Create;
  for i := 0 to length(FileNames) - 1 do
      d.WriteString(FileNames[i]);
  DTNoAuthClient.SendTunnel.SendStreamCmdM('FS_Size', d, nil, nil,
    tmp.DoStreamParamEvent, tmp.DoStreamFailedEvent);
  DisposeObject(d);
end;

procedure TC40_FS_Client.FS_SearchC(filter: U_String; MaxNum: Integer; OnResult: TFS_Temp_SearchC);
var
  tmp: TFS_Temp_Search;
  d: TDFE;
  i: Integer;
begin
  tmp := TFS_Temp_Search.Create;
  tmp.Client := self;
  tmp.OnResultC := OnResult;
  d := TDFE.Create;
  d.WriteString(filter);
  d.WriteInteger(MaxNum);
  DTNoAuthClient.SendTunnel.SendStreamCmdM('FS_Search', d, nil, nil,
    tmp.DoStreamParamEvent, tmp.DoStreamFailedEvent);
  DisposeObject(d);
end;

procedure TC40_FS_Client.FS_SearchM(filter: U_String; MaxNum: Integer; OnResult: TFS_Temp_SearchM);
var
  tmp: TFS_Temp_Search;
  d: TDFE;
  i: Integer;
begin
  tmp := TFS_Temp_Search.Create;
  tmp.Client := self;
  tmp.OnResultM := OnResult;
  d := TDFE.Create;
  d.WriteString(filter);
  d.WriteInteger(MaxNum);
  DTNoAuthClient.SendTunnel.SendStreamCmdM('FS_Search', d, nil, nil,
    tmp.DoStreamParamEvent, tmp.DoStreamFailedEvent);
  DisposeObject(d);
end;

procedure TC40_FS_Client.FS_SearchP(filter: U_String; MaxNum: Integer; OnResult: TFS_Temp_SearchP);
var
  tmp: TFS_Temp_Search;
  d: TDFE;
  i: Integer;
begin
  tmp := TFS_Temp_Search.Create;
  tmp.Client := self;
  tmp.OnResultP := OnResult;
  d := TDFE.Create;
  d.WriteString(filter);
  d.WriteInteger(MaxNum);
  DTNoAuthClient.SendTunnel.SendStreamCmdM('FS_Search', d, nil, nil,
    tmp.DoStreamParamEvent, tmp.DoStreamFailedEvent);
  DisposeObject(d);
end;

initialization

RegisterC40('FS', TC40_FS_Service, TC40_FS_Client);

end.
