program _145_VeryEasyC4Project;

{$APPTYPE CONSOLE}

{$R *.res}


uses
  System.SysUtils,
  PasAI.Core, PasAI.PascalStrings, PasAI.UPascalStrings, PasAI.UnicodeMixedLib, PasAI.DFE, PasAI.Parsing, PasAI.Expression, PasAI.OpCode,
  PasAI.Net, PasAI.Net.C4, PasAI.Net.C4_Console_APP;

type
  TMY_Serv = class(TC40_Base_NoAuth_Service);
  TMY_Cli = class(TC40_Base_NoAuth_Client);

begin
  RegisterC40('MY_Serv', TMY_Serv, TMY_Cli);
  if C40_Extract_CmdLine(TTextStyle.tsC, [
      'Service("0.0.0.0","127.0.0.1", 9000, "MY_Serv")', 'Client("127.0.0.1", 9000, "MY_Serv")']) then
      C40_Execute_Main_Loop;
  C40Clean;
end.
