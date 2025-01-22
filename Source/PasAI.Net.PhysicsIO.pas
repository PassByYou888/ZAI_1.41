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
{ * PhysicsIO interface, written by QQ 600585@qq.com                           * }
{ ****************************************************************************** }
unit PasAI.Net.PhysicsIO;

{$DEFINE FPC_DELPHI_MODE}
{$I PasAI.Define.inc}

interface

uses
{$IFDEF FPC}
  PasAI.Net.Server.Synapse, PasAI.Net.Client.Synapse,
{$ELSE FPC}

{$IFDEF PhysicsIO_On_ICS}
  PasAI.Net.Server.ICS, PasAI.Net.Client.ICS,
{$ENDIF PhysicsIO_On_ICS}
{$IFDEF PhysicsIO_On_ICS9}
  PasAI.Net.Server.ICS9, PasAI.Net.Client.ICS9,
{$ENDIF PhysicsIO_On_ICS9}
{$IFDEF PhysicsIO_On_CrossSocket}
  PasAI.Net.Server.CrossSocket, PasAI.Net.Client.CrossSocket,
{$ENDIF PhysicsIO_On_CrossSocket}
{$IFDEF PhysicsIO_On_DIOCP}
  PasAI.Net.Server.DIOCP, PasAI.Net.Client.DIOCP,
{$ENDIF PhysicsIO_On_DIOCP}
{$IFDEF PhysicsIO_On_Indy}
  PasAI.Net.Server.Indy, PasAI.Net.Client.Indy,
{$ENDIF PhysicsIO_On_Indy}
{$IFDEF PhysicsIO_On_Synapse}
  PasAI.Net.Server.Synapse, PasAI.Net.Client.Synapse,
{$ENDIF PhysicsIO_On_Synapse}

{$ENDIF FPC}
  PasAI.Core;

type
{$IFDEF FPC}
  TPhysicsServer = TZNet_Server_Synapse;
  TPhysicsClient = TZNet_Client_Synapse;
{$ELSE FPC}
{$IFDEF PhysicsIO_On_ICS}
  TPhysicsServer = TZNet_Server_ICS;
  TPhysicsClient = TZNet_Client_ICS;
{$ENDIF PhysicsIO_On_ICS}
{$IFDEF PhysicsIO_On_ICS9}
  TPhysicsServer = TZNet_Server_ICS9;
  TPhysicsClient = TZNet_Client_ICS9;
{$ENDIF PhysicsIO_On_ICS9}
{$IFDEF PhysicsIO_On_CrossSocket}
  TPhysicsServer = TZNet_Server_CrossSocket;
  TPhysicsClient = TZNet_Client_CrossSocket;
{$ENDIF PhysicsIO_On_CrossSocket}
{$IFDEF PhysicsIO_On_DIOCP}
  TPhysicsServer = TZNet_Server_DIOCP;
  TPhysicsClient = TZNet_Client_DIOCP;
{$ENDIF PhysicsIO_On_DIOCP}
{$IFDEF PhysicsIO_On_Indy}
  TPhysicsServer = TZNet_Server_Indy;
  TPhysicsClient = TZNet_Client_Indy;
{$ENDIF PhysicsIO_On_Indy}
{$IFDEF PhysicsIO_On_Synapse}
  TPhysicsServer = TZNet_Server_Synapse;
  TPhysicsClient = TZNet_Client_Synapse;
{$ENDIF PhysicsIO_On_Synapse}
{$ENDIF FPC}
  TPhysicsService = TPhysicsServer;
  TZService = TPhysicsServer;
  TPhysicsTunnel = TPhysicsClient;
  TZClient = TPhysicsClient;
  TZTunnel = TPhysicsClient;

implementation

end.
