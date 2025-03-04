unit _138_C4_Custom_LargeDB;

interface

uses DateUtils, SysUtils,
  PasAI.Core,
{$IFDEF FPC}
  PasAI.FPC.GenericList,
{$ELSE FPC}
  System.IOUtils,
{$ENDIF FPC}
  PasAI.PascalStrings, PasAI.UPascalStrings, PasAI.UnicodeMixedLib, PasAI.MemoryStream,
  PasAI.Status, PasAI.Cipher, PasAI.ZDB2, PasAI.ListEngine, PasAI.TextDataEngine, PasAI.IOThread, PasAI.HashList.Templet, PasAI.DFE, PasAI.Geometry2D,
  PasAI.Notify, PasAI.ZDB2.Thread.Queue, PasAI.ZDB2.Thread, PasAI.ZDB2.Thread.LargeData, PasAI.MemoryRaster, PasAI.DrawEngine;

{
  ZDB2大数据引擎设计思路:
  把密集数据集中,这样便于阵列和光网载入,
  密集数据,就是一些xml,ini,json,yaml,dfe这类,他们充当数据头,这一部分用集中策略,也就是 TZDB2_Custom_Small_Data
  集中策略可以被阵列高速载入,剩下来的都是计算工作...交给cpu就行了,每秒几百万,1分钟1亿,这样处理数据头,也就解决索引环节了.

  中大数据要走分散存储路线,指定好存储位置就行,中大数据勿用大规模整读整取,大规模阵列技术无法高效遍历pb级数据,tb都够呛,
  另一方面,pb级阵列非常昂贵,需要配上顶级大数据支持体系:ZDB2的block定位技术专门解决预读中大数据头

  更多细节,去阅读大数据标准库, "Z.ZDB2.Thread.LargeData", 该框架依赖栈大概6层, 已详细备注

  本demo含有光栅体系,不可以放在ZNet开源,请关注ZAI,ZR的相关项目
  在母体ZNet中会包含"Z.ZDB2.Thread.LargeData"的标准库.
}

type
  TZDB2_Picture_Info = class(TZDB2_Custom_Small_Data) // 图片信息
  public
    Relate_Preview: Int64;
    Relate_Picture_Body: Int64;
    Width, Height: Integer;
    Picture_Info: U_String;
    constructor Create(); override;
    destructor Destroy; override;
    procedure Do_Remove(); override;
    // 接口小数据有这两个api就行
    function Make_Data_Source: TMS64;
    function Decode_From_ZDB2_Data(Data_Source: TMem64; Update_: Boolean): TMS64; override; // 从ZDB2数据还原
    { 用于解决hdd分散性能问题的扩展数据头技术 }
    { 当数据量很大时，一个数据集包含几十个或数百个小型数据库。在磁盘操作过程中，磁盘预读取将被分块读取，这大大消耗了HDD读取时间 }
    { 扩展数据头是将数千个碎片化的数据库聚集在一起，一次读取所有数据库，从而提高数据库的启动效率。同时，预读取对内存的要求也更高 }
    { 预读技术可以提高绝大多数hdd系统中的数据加载效率 }
    procedure Encode_External_Header_Data(External_Header_Data: TMem64); override;
    procedure Decode_External_Header_Data(External_Header_Data: TMem64); override;
  end;

  TZDB2_Picture_Preview = class(TZDB2_Custom_Medium_Data) // 预览
  public
    Relate_Info: Int64;
    constructor Create(); override;
    destructor Destroy; override;
    procedure Do_Remove(); override;
    // 4个api接口预览光栅
    function Encode_To_ZDB2_Data(Data_Source: TMS64; AutoFree_: Boolean): TMem64; override; // 结构保存ZDB2
    function Decode_From_ZDB2_Data(Data_Source: TMem64; Update_: Boolean): TMS64; override; // 从ZDB2数据还原
    function Make_Data_Source(preview_: TPasAI_Raster): TMS64; // 规范光栅生成
    { 用于解决hdd分散性能问题的扩展数据头技术 }
    { 当数据量很大时，一个数据集包含几十个或数百个小型数据库。在磁盘操作过程中，磁盘预读取将被分块读取，这大大消耗了HDD读取时间 }
    { 扩展数据头是将数千个碎片化的数据库聚集在一起，一次读取所有数据库，从而提高数据库的启动效率。同时，预读取对内存的要求也更高 }
    { 预读技术可以提高绝大多数hdd系统中的数据加载效率 }
    procedure Encode_External_Header_Data(External_Header_Data: TMem64); override;
    procedure Decode_External_Header_Data(External_Header_Data: TMem64); override;
  end;

  TZDB2_Picture_Body = class(TZDB2_Custom_Large_Data) // 图片本体
  public
    Relate_Info: Int64;
    constructor Create(); override;
    destructor Destroy; override;
    procedure Do_Remove(); override;
    // 4个api接口原光栅
    function Encode_To_ZDB2_Data(Data_Source: TMS64; AutoFree_: Boolean): TMem64; override; // 结构保存ZDB2
    function Decode_From_ZDB2_Data(Data_Source: TMem64; Update_: Boolean): TMS64; override; // 从ZDB2数据还原
    function Make_Data_Source(Body_: TPasAI_Raster): TMS64; // 规范光栅生成
    { 用于解决hdd分散性能问题的扩展数据头技术 }
    { 当数据量很大时，一个数据集包含几十个或数百个小型数据库。在磁盘操作过程中，磁盘预读取将被分块读取，这大大消耗了HDD读取时间 }
    { 扩展数据头是将数千个碎片化的数据库聚集在一起，一次读取所有数据库，从而提高数据库的启动效率。同时，预读取对内存的要求也更高 }
    { 预读技术可以提高绝大多数hdd系统中的数据加载效率 }
    procedure Encode_External_Header_Data(External_Header_Data: TMem64); override;
    procedure Decode_External_Header_Data(External_Header_Data: TMem64); override;
  end;

  TZDB2_Picture = class(TZDB2_Large)
  public
    constructor Create();
    destructor Destroy; override;

    procedure Extract_ALL_DB();

    // 这里不论实用性,只讲方法:整个方法思路是一种存储策略
    // TZDB2_Picture_Info: 自定义格式,保存原始图片信息
    // TZDB2_Picture_Preview: 自定义格式,保存预览图片
    // TZDB2_Picture_Body: 自定义格式,保存规范图片
    // 三者为互相关联,以Sequence_ID作为关联识别
    procedure Custom_Mode_Add_Picture_File(f: U_String);
  end;

implementation

constructor TZDB2_Picture_Info.Create;
begin
  inherited Create;
  Relate_Preview := 0;
  Relate_Picture_Body := 0;
  Width := 0;
  Height := 0;
  Picture_Info := '';
end;

destructor TZDB2_Picture_Info.Destroy;
begin
  inherited Destroy;
end;

procedure TZDB2_Picture_Info.Do_Remove;
begin
  Owner_Large_Marshal.S_DB_Sequence_Pool.Delete(Sequence_ID);
  inherited Do_Remove;
end;

function TZDB2_Picture_Info.Make_Data_Source: TMS64;
begin
  Result := TMS64.Create;
  Result.WriteInt64(Relate_Preview);
  Result.WriteInt64(Relate_Picture_Body);
  Result.WriteInt32(Width);
  Result.WriteInt32(Height);
  Result.WriteString(Picture_Info);
  MD5 := Result.ToMD5;
  Result.Position := 0;
end;

function TZDB2_Picture_Info.Decode_From_ZDB2_Data(Data_Source: TMem64; Update_: Boolean): TMS64;
begin
  Result := inherited Decode_From_ZDB2_Data(Data_Source, Update_);
  if Update_ then
    begin
      Relate_Preview := Result.ReadInt64;
      Relate_Picture_Body := Result.ReadInt64;
      Width := Result.ReadInt32;
      Height := Result.ReadUInt32;
      Picture_Info := Result.ReadString;
    end;
end;

procedure TZDB2_Picture_Info.Encode_External_Header_Data(External_Header_Data: TMem64);
begin
  inherited Encode_External_Header_Data(External_Header_Data);
end;

procedure TZDB2_Picture_Info.Decode_External_Header_Data(External_Header_Data: TMem64);
begin
  inherited Decode_External_Header_Data(External_Header_Data);
end;

constructor TZDB2_Picture_Preview.Create;
begin
  inherited Create;
  Relate_Info := 0;
end;

destructor TZDB2_Picture_Preview.Destroy;
begin
  inherited Destroy;
end;

procedure TZDB2_Picture_Preview.Do_Remove;
begin
end;

function TZDB2_Picture_Preview.Encode_To_ZDB2_Data(Data_Source: TMS64; AutoFree_: Boolean): TMem64;
begin
  Result := TMem64.Create;
  Result.Size := 32 + Data_Source.Size;
  Result.Position := 0;
  Result.WriteInt64(Sequence_ID);
  Result.WriteMD5(MD5);
  Result.WriteInt64(Relate_Info);
  Result.WritePtr(Data_Source.Memory, Data_Source.Size);
  if AutoFree_ then
      DisposeObject(Data_Source);
end;

function TZDB2_Picture_Preview.Decode_From_ZDB2_Data(Data_Source: TMem64; Update_: Boolean): TMS64;
begin
  if Update_ then
    begin
      Data_Source.Position := 0;
      Sequence_ID := Data_Source.ReadInt64;
      MD5 := Data_Source.ReadMD5;
      Relate_Info := Data_Source.ReadInt64;
    end
  else
      Data_Source.Position := 32;
  Result := TMS64.Create;
  Result.Mapping(Data_Source.PosAsPtr, Data_Source.Size - Data_Source.Position);
end;

function TZDB2_Picture_Preview.Make_Data_Source(preview_: TPasAI_Raster): TMS64;
var
  tmp: TPasAI_Raster;
begin
  tmp := preview_.FitScaleAsNew(200, 200);
  Result := TMS64.Create;
  tmp.SaveToJpegYCbCrStream(Result, 50);
  DisposeObject(tmp);
  MD5 := Result.ToMD5;
  Result.Position := 0;
end;

procedure TZDB2_Picture_Preview.Encode_External_Header_Data(External_Header_Data: TMem64);
begin
  inherited Encode_External_Header_Data(External_Header_Data);
  External_Header_Data.WriteInt64(Relate_Info);
end;

procedure TZDB2_Picture_Preview.Decode_External_Header_Data(External_Header_Data: TMem64);
begin
  inherited Decode_External_Header_Data(External_Header_Data);
  Relate_Info := External_Header_Data.ReadInt64;
end;

constructor TZDB2_Picture_Body.Create;
begin
  inherited Create;
  Relate_Info := 0;
end;

destructor TZDB2_Picture_Body.Destroy;
begin
  inherited Destroy;
end;

procedure TZDB2_Picture_Body.Do_Remove;
begin
end;

function TZDB2_Picture_Body.Encode_To_ZDB2_Data(Data_Source: TMS64; AutoFree_: Boolean): TMem64;
begin
  Result := TMem64.Create;
  Result.Size := 32 + Data_Source.Size;
  Result.Position := 0;
  Result.WriteInt64(Sequence_ID);
  Result.WriteMD5(MD5);
  Result.WriteInt64(Relate_Info);
  Result.WritePtr(Data_Source.Memory, Data_Source.Size);
  if AutoFree_ then
      DisposeObject(Data_Source);
end;

function TZDB2_Picture_Body.Decode_From_ZDB2_Data(Data_Source: TMem64; Update_: Boolean): TMS64;
begin
  if Update_ then
    begin
      Data_Source.Position := 0;
      Sequence_ID := Data_Source.ReadInt64;
      MD5 := Data_Source.ReadMD5;
      Relate_Info := Data_Source.ReadInt64;
    end
  else
      Data_Source.Position := 32;
  Result := TMS64.Create;
  Result.Mapping(Data_Source.PosAsPtr, Data_Source.Size - Data_Source.Position);
end;

function TZDB2_Picture_Body.Make_Data_Source(Body_: TPasAI_Raster): TMS64;
begin
  Result := TMS64.Create;
  Body_.SaveToJpegYCbCrStream(Result, 80);
  MD5 := Result.ToMD5;
  Result.Position := 0;
end;

procedure TZDB2_Picture_Body.Encode_External_Header_Data(External_Header_Data: TMem64);
begin
  inherited Encode_External_Header_Data(External_Header_Data);
  External_Header_Data.WriteInt64(Relate_Info);
end;

procedure TZDB2_Picture_Body.Decode_External_Header_Data(External_Header_Data: TMem64);
begin
  inherited Decode_External_Header_Data(External_Header_Data);
  Relate_Info := External_Header_Data.ReadInt64;
end;

constructor TZDB2_Picture.Create;
begin
  inherited Create(
    TZDB2_Picture_Info,
    TZDB2_Picture_Preview,
    TZDB2_Picture_Body);
  S_DB_Engine_External_Header_Optimzied_Technology := False;
  M_DB_Engine_External_Header_Optimzied_Technology := True;
  L_DB_Engine_External_Header_Optimzied_Technology := True;
end;

destructor TZDB2_Picture.Destroy;
begin
  inherited Destroy;
end;

procedure TZDB2_Picture.Extract_ALL_DB;
begin
  Extract_S_DB_Full(10);
  Extract_M_DB_Block(10, 0, 0, 32);
  Extract_L_DB_Block(10, 0, 0, 32);
end;

procedure TZDB2_Picture.Custom_Mode_Add_Picture_File(f: U_String);
var
  r: TPasAI_Raster;
  info_: TZDB2_Picture_Info;
  preview_: TZDB2_Picture_Preview;
  Body_: TZDB2_Picture_Body;
begin
  if not TPasAI_Raster.CanLoadFile(f) then
      exit;

  r := nil;
  try
      r := NewPasAI_RasterFromFile(f);
  except
  end;

  if r = nil then
      exit;
  if r.Empty then
    begin
      DisposeObject(r);
      exit;
    end;

  try
    // 预置方式创建数据条目
    info_ := Create_Small_Data as TZDB2_Picture_Info;
    preview_ := Create_Medium_Data as TZDB2_Picture_Preview;
    Body_ := Create_Large_Data as TZDB2_Picture_Body;

    // 生成picture条目信息
    info_.Relate_Preview := preview_.Sequence_ID;
    info_.Relate_Picture_Body := Body_.Sequence_ID;
    info_.Width := r.Width;
    info_.Height := r.Height;
    info_.Picture_Info := umlGetFileName(f);
    info_.Async_Save_And_Free_Data(info_.Encode_To_ZDB2_Data(info_.Make_Data_Source, True));

    // 生成缩略图,并保存
    preview_.Relate_Info := info_.Sequence_ID; // 关联小数据
    preview_.Async_Save_And_Free_Data(preview_.Encode_To_ZDB2_Data(preview_.Make_Data_Source(r), True));

    // 生成规范图片,并保存
    Body_.Relate_Info := info_.Sequence_ID; // 关联小数据
    Body_.Async_Save_And_Free_Data(Body_.Encode_To_ZDB2_Data(Body_.Make_Data_Source(r), True));
  finally
      DisposeObject(r);
  end;
end;

end.
