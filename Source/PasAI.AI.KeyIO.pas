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
{ * AI Key IO(platform compatible)                                             * }
{ ****************************************************************************** }
unit PasAI.AI.KeyIO;

{$DEFINE FPC_DELPHI_MODE}
{$I PasAI.Define.inc}

interface

uses SysUtils, Classes,
  DateUtils,
  PasAI.Core,
  PasAI.PascalStrings,
  PasAI.UnicodeMixedLib,
  PasAI.Status,
  PasAI.DFE,
  PasAI.Net.PhysicsIO,
  PasAI.Net;

type
  TPas_AI_Key = array [0 .. 160 - 1] of Byte;

function AIKey(key: TPas_AI_Key): TPas_AI_Key;
procedure AIKeyState(var expire: SystemString;
  var SURF_key, OD_key, SP_key, MetricDNN_key, LMetricDNN_key, MMOD_key, RNIC_key, LRNIC_key, GDCNIC_key, GNIC_key, VideoTracker_key, SS_key,
  Segment_key, Salient_key, CandidateObject_key, Unmixing_key, Poisson_key, CutRaster_key, OCR_key, ZMetric_key: Boolean); overload;
function AIKeyInfo(): SystemString;
function AIGetFreeKey(): SystemString;
function AI_Auth(): Boolean;

implementation


uses PasAI.AI.Common;

const
  C_Key_TimeOut = 20 * C_Tick_Second;

type
  TGetKeyServer_Remote = class(TCore_Object_Intermediate)
  public
    ProductID: U_String;
    UserKey: U_String;
    key: TPas_AI_Key;
    ResultKey: TPas_AI_Key;
    Tunnel: TPhysicsClient;
    expire: SystemString;
    SURF_key, OD_key, SP_key, MetricDNN_key, LMetricDNN_key, MMOD_key, RNIC_key, LRNIC_key, GDCNIC_key, GNIC_key, VideoTracker_key, SS_key,
      Segment_key, Salient_key, CandidateObject_key, Unmixing_key, Poisson_key, CutRaster_key, OCR_key, ZMetric_key: Boolean;
    KeyInfo: SystemString;
    constructor Create;
    destructor Destroy; override;
    procedure QueryAIKey;
    procedure GetKeyState;
    procedure DecodeKeyInfo;
    procedure GetFreeKey;
    function Auth: Boolean;
  end;

constructor TGetKeyServer_Remote.Create;
begin
  inherited Create;
  ProductID := AI_ProductID;
  UserKey := AI_UserKey;
  FillPtrByte(@key[0], SizeOf(TPas_AI_Key), 0);
  FillPtrByte(@ResultKey[0], SizeOf(TPas_AI_Key), 0);
  Tunnel := TPhysicsClient.Create;
  Tunnel.SwitchMaxSecurity;
  Tunnel.QuietMode := True;
  expire := DateToStr(umlNow());
  SURF_key := False;
  OD_key := False;
  SP_key := False;
  MetricDNN_key := False;
  LMetricDNN_key := False;
  MMOD_key := False;
  RNIC_key := False;
  LRNIC_key := False;
  GDCNIC_key := False;
  GNIC_key := False;
  VideoTracker_key := False;
  SS_key := False;
  Segment_key := False;
  Salient_key := False;
  CandidateObject_key := False;
  Unmixing_key := False;
  Poisson_key := False;
  CutRaster_key := False;
  OCR_key := False;
  ZMetric_key := False;
  KeyInfo := '';
end;

destructor TGetKeyServer_Remote.Destroy;
begin
  Tunnel.Disconnect;
  disposeObject(Tunnel);
  inherited Destroy;
end;

procedure TGetKeyServer_Remote.QueryAIKey;
var
  sendDE, ResultDE: TDFE;
  tk: TTimeTick;
begin
  if TCore_Thread.CurrentThread.ThreadID <> Core_Main_Thread_ID then
    begin
{$IFDEF initializationStatus}
      DoStatus('Z-AI Work only for MainThread.');
{$ENDIF initializationStatus}
      exit;
    end;

  sendDE := TDFE.Create;
  ResultDE := TDFE.Create;

  try
    if not Tunnel.RemoteInited then
      begin
        tk := GetTimeTick();

        while not Tunnel.Connect(AI_Key_Server_Host, AI_Key_Server_Port) do
          begin
            Tunnel.Progress;
            TCore_Thread.Sleep(10);
            if GetTimeTick() - tk > 5000 then
              begin
{$IFDEF initializationStatus}
                DoStatus('Unable to connect to license server %s port: %d', [AI_Key_Server_Host.Text, AI_Key_Server_Port]);
{$ENDIF initializationStatus}
                exit;
              end;
          end;
      end;

    sendDE.WriteString(ProductID);
    sendDE.WriteString(UserKey);
    sendDE.write(key[0], SizeOf(TPas_AI_Key));
    Tunnel.WaitSendStreamCmd('QueryUserAndAIKey', sendDE, ResultDE, C_Key_TimeOut);
    if ResultDE.Count > 0 then
      begin
        if ResultDE.Reader.ReadBool() then
            ResultDE.Reader.read(ResultKey[0], SizeOf(TPas_AI_Key))
        else
            DoStatus(ResultDE.Reader.ReadString());
      end;
    Tunnel.Disconnect;
    Tunnel.Progress;
  except
  end;
  disposeObject([sendDE, ResultDE]);
end;

procedure TGetKeyServer_Remote.GetKeyState;
var
  sendDE, ResultDE: TDFE;
  tk: TTimeTick;
begin
  if TCore_Thread.CurrentThread.ThreadID <> Core_Main_Thread_ID then
    begin
{$IFDEF initializationStatus}
      DoStatus('Z-AI Work only for MainThread.');
{$ENDIF initializationStatus}
      exit;
    end;

  sendDE := TDFE.Create;
  ResultDE := TDFE.Create;

  try
    if not Tunnel.RemoteInited then
      begin
        tk := GetTimeTick();

        while not Tunnel.Connect(AI_Key_Server_Host, AI_Key_Server_Port) do
          begin
            Tunnel.Progress;
            TCore_Thread.Sleep(10);
            if GetTimeTick() - tk > 5000 then
              begin
{$IFDEF initializationStatus}
                DoStatus('Unable to connect to license server %s port: %d', [AI_Key_Server_Host.Text, AI_Key_Server_Port]);
{$ENDIF initializationStatus}
                exit;
              end;
          end;
      end;

    sendDE.WriteString(UserKey);
    Tunnel.WaitSendStreamCmd('GetKeyState', sendDE, ResultDE, C_Key_TimeOut);
    if ResultDE.Count > 0 then
      if ResultDE.Reader.ReadBool() then
        begin
          expire := ResultDE.Reader.ReadString();

          SURF_key := ResultDE.Reader.ReadBool();
          OD_key := ResultDE.Reader.ReadBool();
          SP_key := ResultDE.Reader.ReadBool();
          MetricDNN_key := ResultDE.Reader.ReadBool();
          LMetricDNN_key := ResultDE.Reader.ReadBool();
          MMOD_key := ResultDE.Reader.ReadBool();
          RNIC_key := ResultDE.Reader.ReadBool();
          LRNIC_key := ResultDE.Reader.ReadBool();
          GDCNIC_key := ResultDE.Reader.ReadBool();
          GNIC_key := ResultDE.Reader.ReadBool();
          VideoTracker_key := ResultDE.Reader.ReadBool();
          SS_key := ResultDE.Reader.ReadBool();
          Segment_key := ResultDE.Reader.ReadBool();
          Salient_key := ResultDE.Reader.ReadBool();
          CandidateObject_key := ResultDE.Reader.ReadBool();
          Unmixing_key := ResultDE.Reader.ReadBool();
          Poisson_key := ResultDE.Reader.ReadBool();
          CutRaster_key := ResultDE.Reader.ReadBool();
          OCR_key := ResultDE.Reader.ReadBool();
          ZMetric_key := ResultDE.Reader.ReadBool();
        end;
    Tunnel.Disconnect;
    Tunnel.Progress;
  except
  end;
  disposeObject([sendDE, ResultDE]);
end;

procedure TGetKeyServer_Remote.DecodeKeyInfo;
var
  sendDE, ResultDE: TDFE;
  tk: TTimeTick;
begin
  if TCore_Thread.CurrentThread.ThreadID <> Core_Main_Thread_ID then
    begin
{$IFDEF initializationStatus}
      DoStatus('Z-AI Work only for MainThread.');
{$ENDIF initializationStatus}
      exit;
    end;

  sendDE := TDFE.Create;
  ResultDE := TDFE.Create;

  try
    if not Tunnel.RemoteInited then
      begin
        tk := GetTimeTick();

        while not Tunnel.Connect(AI_Key_Server_Host, AI_Key_Server_Port) do
          begin
            Tunnel.Progress;
            TCore_Thread.Sleep(10);
            if GetTimeTick() - tk > 5000 then
              begin
{$IFDEF initializationStatus}
                DoStatus('Unable to connect to license server %s port: %d', [AI_Key_Server_Host.Text, AI_Key_Server_Port]);
{$ENDIF initializationStatus}
                exit;
              end;
          end;
      end;

    sendDE.WriteString(UserKey);
    Tunnel.WaitSendStreamCmd('DecodeKeyInfo', sendDE, ResultDE, C_Key_TimeOut);
    if ResultDE.Count > 0 then
      begin
        if ResultDE.Reader.ReadBool() then
          begin
            KeyInfo := ResultDE.Reader.ReadString();
          end
        else
          begin
            if ResultDE.Reader.NotEnd then
                KeyInfo := 'key error.' + #13#10 + ResultDE.Reader.ReadString()
            else
                KeyInfo := 'key error.';
          end;
      end;

    Tunnel.Disconnect;
    Tunnel.Progress;
  except
  end;
  disposeObject([sendDE, ResultDE]);
end;

procedure TGetKeyServer_Remote.GetFreeKey;
var
  sendDE, ResultDE: TDFE;
  tk: TTimeTick;
begin
  if TCore_Thread.CurrentThread.ThreadID <> Core_Main_Thread_ID then
    begin
{$IFDEF initializationStatus}
      DoStatus('Z-AI Work only for MainThread.');
{$ENDIF initializationStatus}
      exit;
    end;

  sendDE := TDFE.Create;
  ResultDE := TDFE.Create;

  try
    if not Tunnel.RemoteInited then
      begin
        tk := GetTimeTick();

        while not Tunnel.Connect(AI_Key_Server_Host, AI_Key_Server_Port) do
          begin
            Tunnel.Progress;
            TCore_Thread.Sleep(10);
            if GetTimeTick() - tk > 5000 then
              begin
{$IFDEF initializationStatus}
                DoStatus('Unable to connect to license server %s port: %d', [AI_Key_Server_Host.Text, AI_Key_Server_Port]);
{$ENDIF initializationStatus}
                exit;
              end;
          end;
      end;

    Tunnel.WaitSendStreamCmd('GetFreeKey', sendDE, ResultDE, C_Key_TimeOut);
    if ResultDE.Count > 0 then
        KeyInfo := ResultDE.Reader.ReadString();

    Tunnel.Disconnect;
    Tunnel.Progress;
  except
  end;
  disposeObject([sendDE, ResultDE]);
end;

function TGetKeyServer_Remote.Auth: Boolean;
var
  sendDE, ResultDE: TDFE;
  tk: TTimeTick;
begin
  Result := False;
  if TCore_Thread.CurrentThread.ThreadID <> Core_Main_Thread_ID then
    begin
{$IFDEF initializationStatus}
      DoStatus('Z-AI Work only for MainThread.');
{$ENDIF initializationStatus}
      exit;
    end;

  sendDE := TDFE.Create;
  ResultDE := TDFE.Create;

  try
    if not Tunnel.RemoteInited then
      begin
        tk := GetTimeTick();

        while not Tunnel.Connect(AI_Key_Server_Host, AI_Key_Server_Port) do
          begin
            Tunnel.Progress;
            TCore_Thread.Sleep(10);
            if GetTimeTick() - tk > 5000 then
              begin
{$IFDEF initializationStatus}
                DoStatus('Unable to connect to license server %s port: %d', [AI_Key_Server_Host.Text, AI_Key_Server_Port]);
{$ENDIF initializationStatus}
                exit;
              end;
          end;
      end;

    sendDE.WriteString(UserKey);
    Tunnel.WaitSendStreamCmd('Auth', sendDE, ResultDE, C_Key_TimeOut);
    if ResultDE.Count > 0 then
      begin
        Result := ResultDE.Reader.ReadBool();
        KeyInfo := ResultDE.Reader.ReadString();
      end;

    Tunnel.Disconnect;
    Tunnel.Progress;
  except
  end;
  disposeObject([sendDE, ResultDE]);
end;

function AIKey(key: TPas_AI_Key): TPas_AI_Key;
var
  K_Tunnel: TGetKeyServer_Remote;
begin
  K_Tunnel := TGetKeyServer_Remote.Create;
  K_Tunnel.key := key;
  FillPtrByte(@K_Tunnel.ResultKey[0], SizeOf(TPas_AI_Key), 0);
  K_Tunnel.QueryAIKey();
  Result := K_Tunnel.ResultKey;
  disposeObject(K_Tunnel);
end;

procedure AIKeyState(var expire: SystemString;
  var SURF_key, OD_key, SP_key, MetricDNN_key, LMetricDNN_key, MMOD_key, RNIC_key, LRNIC_key, GDCNIC_key, GNIC_key, VideoTracker_key, SS_key,
  Segment_key, Salient_key, CandidateObject_key, Unmixing_key, Poisson_key, CutRaster_key, OCR_key, ZMetric_key: Boolean);
var
  K_Tunnel: TGetKeyServer_Remote;
begin
  K_Tunnel := TGetKeyServer_Remote.Create;
  K_Tunnel.GetKeyState();
  expire := K_Tunnel.expire;
  SURF_key := K_Tunnel.SURF_key;
  OD_key := K_Tunnel.OD_key;
  SP_key := K_Tunnel.SP_key;
  MetricDNN_key := K_Tunnel.MetricDNN_key;
  LMetricDNN_key := K_Tunnel.LMetricDNN_key;
  MMOD_key := K_Tunnel.MMOD_key;
  RNIC_key := K_Tunnel.RNIC_key;
  LRNIC_key := K_Tunnel.LRNIC_key;
  GDCNIC_key := K_Tunnel.GDCNIC_key;
  GNIC_key := K_Tunnel.GNIC_key;
  VideoTracker_key := K_Tunnel.VideoTracker_key;
  SS_key := K_Tunnel.SS_key;
  Segment_key := K_Tunnel.SS_key;
  Salient_key := K_Tunnel.SS_key;
  CandidateObject_key := K_Tunnel.SS_key;
  Unmixing_key := K_Tunnel.SS_key;
  Poisson_key := K_Tunnel.SS_key;
  CutRaster_key := K_Tunnel.SS_key;
  OCR_key := K_Tunnel.SS_key;
  ZMetric_key := K_Tunnel.ZMetric_key;
  disposeObject(K_Tunnel);
end;

function AIKeyInfo(): SystemString;
var
  K_Tunnel: TGetKeyServer_Remote;
begin
  K_Tunnel := TGetKeyServer_Remote.Create;
  K_Tunnel.DecodeKeyInfo();
  Result := K_Tunnel.KeyInfo;
  disposeObject(K_Tunnel);
end;

function AIGetFreeKey(): SystemString;
var
  K_Tunnel: TGetKeyServer_Remote;
begin
  K_Tunnel := TGetKeyServer_Remote.Create;
  K_Tunnel.GetFreeKey();
  Result := K_Tunnel.KeyInfo;
  disposeObject(K_Tunnel);
end;

function AI_Auth(): Boolean;
var
  K_Tunnel: TGetKeyServer_Remote;
begin
  K_Tunnel := TGetKeyServer_Remote.Create;
  Result := K_Tunnel.Auth;
  DoStatus('AI Auth Reponse: ' + K_Tunnel.KeyInfo);
  disposeObject(K_Tunnel);
end;

initialization

finalization

end.
