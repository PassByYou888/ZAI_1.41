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
{ * sound engine                                                               * }
{ ****************************************************************************** }
unit PasAI.Sound;

{$DEFINE FPC_DELPHI_MODE}
{$I PasAI.Define.inc}

interface

uses
{$IFDEF FPC}
  PasAI.FPC.GenericList,
{$ELSE FPC}
  System.IOUtils,
{$ENDIF FPC}
  PasAI.Core, PasAI.MemoryStream, PasAI.UnicodeMixedLib, PasAI.Cadencer, PasAI.ZDB, PasAI.ZDB.HashField_LIB, PasAI.PascalStrings, PasAI.UPascalStrings, PasAI.ListEngine;

type
  TzSound = class(TCore_InterfacedObject_Intermediate, ICadencerProgressInterface)
  protected
    FCadEng: TCadencer;
    FSearchDB: TCore_Object;
    FTempPath: SystemString;
    FCacheFileList: THashVariantList;
    FLastPlaySoundFilename: SystemString;

    procedure DoPrepareMusic(FileName: SystemString); virtual; abstract;
    procedure DoPlayMusic(FileName: SystemString); virtual; abstract;
    procedure DoStopMusic; virtual; abstract;

    procedure DoPrepareAmbient(FileName: SystemString); virtual; abstract;
    procedure DoPlayAmbient(FileName: SystemString); virtual; abstract;
    procedure DoStopAmbient; virtual; abstract;

    procedure DoPrepareSound(FileName: SystemString); virtual; abstract;
    procedure DoPlaySound(FileName: SystemString); virtual; abstract;
    procedure DoStopSound(FileName: SystemString); virtual; abstract;

    procedure DoStopAll; virtual; abstract;

    function DoIsPlaying(FileName: SystemString): Boolean; virtual; abstract;

    function SaveSoundAsLocalFile(FileName: SystemString): SystemString; virtual;
    function SoundReadyOk(FileName: SystemString): Boolean; virtual;
  protected
    // ICadencerProgressInterface
    procedure CadencerProgress(const deltaTime, newTime: Double); virtual;
  public
    constructor Create(TempPath_: SystemString); virtual;
    destructor Destroy; override;

    procedure PrepareMusic(FileName: SystemString);
    procedure PlayMusic(FileName: SystemString);
    procedure StopMusic;

    procedure PrepareAmbient(FileName: SystemString);
    procedure PlayAmbient(FileName: SystemString);
    procedure StopAmbient;

    procedure PrepareSound(FileName: SystemString);
    procedure PlaySound(FileName: SystemString);
    procedure StopSound(FileName: SystemString);

    procedure StopAll;

    procedure Progress(deltaTime: Double); overload; virtual;
    procedure Progress(); overload;

    property SearchDB: TCore_Object read FSearchDB write FSearchDB;
    property LastPlaySoundFilename: SystemString read FLastPlaySoundFilename;
  end;

  TSoundEngineClass = class of TzSound;

  // sound engine
function SoundEngine: TzSound;

var
  DefaultSoundEngineClass: TSoundEngineClass;

implementation

uses PasAI.MediaCenter;

var
  SoundEngine__: TzSound;

  // sound engine
function SoundEngine: TzSound;
begin
  if SoundEngine__ = nil then
    begin
{$IFDEF FPC}
      SoundEngine__ := DefaultSoundEngineClass.Create(umlCurrentPath);
{$ELSE}
      SoundEngine__ := DefaultSoundEngineClass.Create(TPath.GetTempPath);
{$ENDIF}
      SoundEngine__.SearchDB := SoundLibrary;
    end;
  Result := SoundEngine__;
end;

function TzSound.SaveSoundAsLocalFile(FileName: SystemString): SystemString;
begin
  Result := FileName;
end;

function TzSound.SoundReadyOk(FileName: SystemString): Boolean;
begin
  Result := False;
end;

procedure TzSound.CadencerProgress(const deltaTime, newTime: Double);
begin
  Progress(deltaTime);
end;

constructor TzSound.Create(TempPath_: SystemString);
begin
  inherited Create;
  FCadEng := TCadencer.Create;
  FCadEng.ProgressInterface := Self;
  FSearchDB := nil;
  FTempPath := TempPath_;
  FCacheFileList := THashVariantList.Create;
  FLastPlaySoundFilename := '';
end;

destructor TzSound.Destroy;
begin
  DisposeObject(FCacheFileList);
  DisposeObject(FCadEng);
  inherited Destroy;
end;

procedure TzSound.PrepareMusic(FileName: SystemString);
begin
  try
    if SoundReadyOk(FileName) then
        DoPrepareMusic(FileName)
    else
        DoPrepareMusic(SaveSoundAsLocalFile(FileName));
  except
  end;
end;

procedure TzSound.PlayMusic(FileName: SystemString);
begin
  try
    if SoundReadyOk(FileName) then
        DoPlayMusic(FileName)
    else
        DoPlayMusic(SaveSoundAsLocalFile(FileName));
  except
  end;
end;

procedure TzSound.StopMusic;
begin
  try
      DoStopMusic;
  except
  end;
end;

procedure TzSound.PrepareAmbient(FileName: SystemString);
begin
  try
    if SoundReadyOk(FileName) then
        DoPrepareAmbient(FileName)
    else
        DoPrepareAmbient(SaveSoundAsLocalFile(FileName));
  except
  end;
end;

procedure TzSound.PlayAmbient(FileName: SystemString);
begin
  try
    if SoundReadyOk(FileName) then
        DoPlayAmbient(FileName)
    else
        DoPlayAmbient(SaveSoundAsLocalFile(FileName));
  except
  end;
end;

procedure TzSound.StopAmbient;
begin
  try
      DoStopAmbient
  except
  end;
end;

procedure TzSound.PrepareSound(FileName: SystemString);
begin
  try
    if SoundReadyOk(FileName) then
        DoPrepareSound(FileName)
    else
        DoPrepareSound(SaveSoundAsLocalFile(FileName));
  except
  end;
end;

procedure TzSound.PlaySound(FileName: SystemString);
begin
  try
    FLastPlaySoundFilename := FileName;
    if SoundReadyOk(FileName) then
      begin
        DoPlaySound(FileName);
      end
    else
        DoPlaySound(SaveSoundAsLocalFile(FileName));
  except
  end;
end;

procedure TzSound.StopSound(FileName: SystemString);
begin
  try
    if FCacheFileList.Exists(FileName) then
        DoStopSound(FCacheFileList[FileName])
    else if SoundReadyOk(FileName) then
        DoStopSound(FileName);
  except
  end;
end;

procedure TzSound.StopAll;
begin
  try
      DoStopAll;
  except
  end;
end;

procedure TzSound.Progress(deltaTime: Double);
begin
end;

procedure TzSound.Progress;
begin
  FCadEng.Progress;
end;

initialization

DefaultSoundEngineClass := TzSound;
SoundEngine__ := nil;

finalization

if SoundEngine__ <> nil then
  begin
    DisposeObject(SoundEngine__);
    SoundEngine__ := nil;
  end;

end.
