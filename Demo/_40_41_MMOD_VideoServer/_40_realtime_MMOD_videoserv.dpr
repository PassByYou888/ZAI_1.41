program _40_realtime_MMOD_videoserv;

{$APPTYPE CONSOLE}

{$R *.res}


uses
  System.SysUtils,
  PasAI.Core,
  PasAI.Status,
  PasAI.Net.PhysicsIO,
  PasAI.AI,
  PasAI.AI.Common,
  zAI_RealTime_MMOD_VideoServer in 'zAI_RealTime_MMOD_VideoServer.pas',
  zAI_RealTime_MMOD_VideoClient in 'zAI_RealTime_MMOD_VideoClient.pas';

procedure RunServ;
var
  rt_video_serv: TRealTime_MMOD_VideoServer;
begin
  rt_video_serv := TRealTime_MMOD_VideoServer.Create(TPhysicsServer.Create, TPhysicsServer.Create);

  if rt_video_serv.RecvTunnel.StartService('0.0.0.0', 7867)
    and
    rt_video_serv.SendTunnel.StartService('0.0.0.0', 7866) then
    begin
      DoStatus('listen service for realtime OD video. recv:7867, send:7866');
      while true do
        begin
          rt_video_serv.Progress;
          if rt_video_serv.TotalLinkCount > 0 then
              PasAI.Core.CheckThreadSynchronize(1)
          else
              PasAI.Core.CheckThreadSynchronize(100)
        end;
    end;
end;

begin
  CheckAndReadAIConfig;
  if PasAI.AI.Prepare_AI_Engine() = nil then
      raiseInfo('init ai engine failed.');
  RunServ;

end.
