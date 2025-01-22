{$IFNDEF ICS_INCLUDE_MODE}
unit PasAI.ICS9.OverbyteIcsReg;
  {$DEFINE ICS_COMMON}
{$ENDIF}

{
Feb 15, 2012 Angus - added OverbyteIcsMimeUtils
May 2012 - V8.00 - Arno added FireMonkey cross platform support with POSIX/MacOS
                   also IPv6 support, include files now in sub-directory
Jun 2012 - V8.00 - Angus added SysLog and SNMP components VCL only for now
Jul 2012   V8.02   Angus added TSslHttpAppSrv
Sep 2013   V8.03 - Angus added TSmtpSrv and TSslSmtpSrv
May 2017   V8.45 - Angus added TIcsProxy, TIcsHttpProxy
Apr 2018   V8.54 - Angus added TSslHttpRest, TSimpleWebSrv and TRestOAuth
May 2018   V8.54 - Angus added TSslX509Certs
Oct 2018   V8.58 - New components now installed for FMX and VCL
                   Added subversion to sIcsLongProductName for splash screen
Nov 2019   V8.59 - Version only
Mar 2019   V8.60 - Angus added TIcsMailQueue, TIcsIpStrmLog, TIcsWhoisCli,
                     TIcsTimeServer, TIcsTimeClient, TIcsBlacklist,
                     TIcsFileCopy, TIcsFtpMulti, TIcsHttpMulti.
                   For Delphi 2007 only, added TFtpClientW, TFtpServerW,
                     TIcsFileCopyW, TIcsFtpMultiW and TIcsHttpMultiW.
                   Added Forum and Wiki URLs to About Box.
Apr 2019  V8.61  - Added TDnsQueryHttps, TIcsSms
May 2019  V8.62  - Version only
Oct 2019  V8.63  - Version only
Nov 2019  V8.64  - Version only
Sep 2020  V8.65  - Added TIcsTwitter and TIcsRestEmail
Mar 2021  V8.66 -  Added TIcsInetAlive, OverbyteIcsSslThrdLock gone.
May 2021  V8.67 -  Version only
Oct 2021  V8.68 -  Version only
Mar 2022  V8.69 -  Added TOcspHttp, OverbyteIcsSslHttpOAuth.
Jun 2022  V8.70 -  Version only
Jul 2023  V8.71 -  Added TOAuthBrowser and TSslWebSocketCli
                   Added TIcsMonSocket and TIcsMonPcap
                   Added TIcsMQTTServer and TIcsMQTTClient
                   Added TIcsDomainNameCache and TIcsDomNameCacheHttps
                   Added TIcsNeighbDevices and TIcsIpChanges
Aug 08, 2023 V9.0  Updated version to major release 9.

}


{$I Include\PasAI.ICS9.OverbyteIcsDefs.inc}
{$IFDEF USE_SSL}
    {$I Include\PasAI.ICS9.OverbyteIcsSslDefs.inc}
{$ENDIF}
(*
{$IFDEF BCB}
  { So far no FMX support for C++ Builder, to be removed later }
  {$DEFINE VCL}
  {$IFDEF FMX}
    {$UNDEF FMX}
  {$ENDIF}
{$ENDIF}
*)
{$IFNDEF COMPILER16_UP}
  {$DEFINE VCL}
  {$IFDEF FMX}
    {$UNDEF FMX}
  {$ENDIF}
{$ENDIF}

{$IFDEF VCL}
  {$DEFINE VCL_OR_FMX}
{$ELSE}
  {$IFDEF FMX}
    {$DEFINE VCL_OR_FMX}
  {$ENDIF}
{$ENDIF}

interface

uses
  {$IFDEF FMX}
    FMX.Types,
    PasAI.ICS9.Ics.Fmx.OverbyteIcsWndControl,
    PasAI.ICS9.Ics.Fmx.OverbyteIcsWSocket,
    PasAI.ICS9.Ics.Fmx.OverbyteIcsDnsQuery,
    PasAI.ICS9.Ics.Fmx.OverbyteIcsFtpCli,
    PasAI.ICS9.Ics.Fmx.OverbyteIcsFtpSrv,
    PasAI.ICS9.Ics.Fmx.OverbyteIcsMultipartFtpDownloader,
    PasAI.ICS9.Ics.Fmx.OverbyteIcsHttpProt,
    PasAI.ICS9.Ics.Fmx.OverbyteIcsHttpSrv,
    PasAI.ICS9.Ics.Fmx.OverbyteIcsMultipartHttpDownloader,
    PasAI.ICS9.Ics.Fmx.OverbyteIcsHttpAppServer,
    PasAI.ICS9.Ics.Fmx.OverbyteIcsCharsetComboBox,
    PasAI.ICS9.Ics.Fmx.OverbyteIcsPop3Prot,
    PasAI.ICS9.Ics.Fmx.OverbyteIcsSmtpProt,
    PasAI.ICS9.Ics.Fmx.OverbyteIcsNntpCli,
    PasAI.ICS9.Ics.Fmx.OverbyteIcsFingCli,
    PasAI.ICS9.Ics.Fmx.OverbyteIcsPing,
    {$IFDEF USE_SSL}
      PasAI.ICS9.Ics.Fmx.OverbyteIcsSslSessionCache,
      PasAI.ICS9.Ics.Fmx.OverbyteIcsProxy,
      PasAI.ICS9.Ics.Fmx.OverbyteIcsSslHttpRest,
      PasAI.ICS9.Ics.Fmx.OverbyteIcsSslX509Certs,
      PasAI.ICS9.Ics.Fmx.OverbyteIcsIpStreamLog,
      PasAI.ICS9.Ics.Fmx.OverbyteIcsMailQueue,
      PasAI.ICS9.Ics.Fmx.OverbyteIcsFtpMulti,
      PasAI.ICS9.Ics.Fmx.OverbyteIcsHttpMulti,
      PasAI.ICS9.Ics.Fmx.OverbyteIcsSslHttpOAuth,  { V8.69 }
      PasAI.ICS9.OverbyteIcsOAuthFormFmx,          { V8.71 }
      PasAI.ICS9.Ics.Fmx.OverbyteIcsWebSocketCli,  { V8.71 }
    {$ENDIF}
    PasAI.ICS9.Ics.Fmx.OverByteIcsWSocketE,
    PasAI.ICS9.Ics.Fmx.OverbyteIcsWSocketS,
    PasAI.ICS9.Ics.Fmx.OverbyteIcsWhoisCli,
    PasAI.ICS9.Ics.Fmx.OverbyteIcsSntp,
    PasAI.ICS9.Ics.Fmx.OverbyteIcsBlacklist,
    PasAI.ICS9.Ics.Fmx.OverbyteIcsFileCopy,
  {$ENDIF FMX}
  {$IFDEF VCL}
    Controls,
    PasAI.ICS9.OverbyteIcsWndControl,
    PasAI.ICS9.OverbyteIcsWSocket,
    PasAI.ICS9.OverbyteIcsDnsQuery,
    PasAI.ICS9.OverbyteIcsFtpCli,
    PasAI.ICS9.OverbyteIcsFtpSrv,
    PasAI.ICS9.OverbyteIcsMultipartFtpDownloader,
    PasAI.ICS9.OverbyteIcsHttpProt,
    PasAI.ICS9.OverbyteIcsHttpSrv,
    PasAI.ICS9.OverbyteIcsMultipartHttpDownloader,
    PasAI.ICS9.OverbyteIcsHttpAppServer,
    PasAI.ICS9.OverbyteIcsCharsetComboBox,
    PasAI.ICS9.OverbyteIcsPop3Prot,
    PasAI.ICS9.OverbyteIcsSmtpProt,
    PasAI.ICS9.OverbyteIcsNntpCli,
    PasAI.ICS9.OverbyteIcsFingCli,
    PasAI.ICS9.OverbyteIcsPing,
    {$IFDEF USE_SSL}
      PasAI.ICS9.OverbyteIcsSslSessionCache,
      PasAI.ICS9.OverbyteIcsProxy,
      PasAI.ICS9.OverbyteIcsSslHttpRest,
      PasAI.ICS9.OverbyteIcsSslX509Certs,
      PasAI.ICS9.OverbyteIcsIpStreamLog,
      PasAI.ICS9.OverbyteIcsMailQueue,
      PasAI.ICS9.OverbyteIcsFtpMulti,
      PasAI.ICS9.OverbyteIcsHttpMulti,
      PasAI.ICS9.OverbyteIcsSslHttpOAuth,  { V8.69 }
      {$IFDEF COMPILER11_UP}
        PasAI.ICS9.OverbyteIcsOAuthFormVcl,  { V8.71 }
      {$ENDIF}
      PasAI.ICS9.OverbyteIcsWebSocketCli,  { V8.71 }
      PasAI.ICS9.OverbyteIcsMQTT,          { V8.71 }
    {$ENDIF}
    PasAI.ICS9.OverByteIcsWSocketE,
    PasAI.ICS9.OverbyteIcsWSocketS,
    PasAI.ICS9.OverbyteIcsSysLogClient,
    PasAI.ICS9.OverbyteIcsSysLogServer,
    PasAI.ICS9.OverbyteIcsSnmpCli,
    PasAI.ICS9.OverbyteIcsSmtpSrv,
    PasAI.ICS9.OverbyteIcsWhoisCli,
    PasAI.ICS9.OverbyteIcsSntp,
    PasAI.ICS9.OverbyteIcsBlacklist,
    PasAI.ICS9.OverbyteIcsFileCopy,
    PasAI.ICS9.OverbyteIcsMonCommon,     { V8.71 }
    PasAI.ICS9.OverbyteIcsMonSock,       { V8.71 }
    PasAI.ICS9.OverbyteIcsMonPcap,       { V8.71 }
    PasAI.ICS9.OverbyteIcsMonNdis,       { V8.71 }
    PasAI.ICS9.OverbyteIcsIpHlpApi,      { V8.71 }
   {$IFDEF DELPHI11}
      PasAI.ICS9.OverbyteIcsFtpCliW,
      PasAI.ICS9.OverbyteIcsFtpSrvW,
      PasAI.ICS9.OverbyteIcsFileCopyW,
      PasAI.ICS9.OverbyteIcsFtpMultiW,
      PasAI.ICS9.OverbyteIcsHttpMultiW,
   {$ENDIF}
    // VCL only
    PasAI.ICS9.OverbyteIcsMultiProgressBar,
    PasAI.ICS9.OverbyteIcsEmulVT, PasAI.ICS9.OverbyteIcsTnCnx, PasAI.ICS9.OverbyteIcsTnEmulVT, PasAI.ICS9.OverbyteIcsTnScript,
    {$IFNDEF BCB}
      PasAI.ICS9.OverbyteIcsWSocketTS,
    {$ENDIF}
  {$ENDIF VCL}
  {$IFDEF ICS_COMMON}
    PasAI.ICS9.OverbyteIcsMimeDec,
    PasAI.ICS9.OverbyteIcsMimeUtils,
    PasAI.ICS9.OverbyteIcsTimeList,
    PasAI.ICS9.OverbyteIcsLogger,
    {$IFNDEF BCB}
      PasAI.ICS9.OverbyteIcsCookies,
    {$ENDIF !BCB}
  {$ENDIF}
  {$IFDEF RTL_NAMESPACES}System.SysUtils{$ELSE}SysUtils{$ENDIF},
  {$IFDEF RTL_NAMESPACES}System.Classes{$ELSE}Classes{$ENDIF};

procedure Register;

implementation

uses
{$IFDEF MSWINDOWS}
  {$IFDEF COMPILER10_UP}
    {$IFDEF RTL_NAMESPACES}Winapi.Windows{$ELSE}Windows{$ENDIF},
    ToolsApi,
  {$ENDIF}
  {$IFDEF COMPILER6_UP}
    DesignIntf, DesignEditors;
  {$ELSE}
    DsgnIntf;
  {$ENDIF}
{$ENDIF}

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure Register;
{$IFDEF COMPILER16_UP}
{$IFDEF VCL_OR_FMX}
var
    LClassGroup: TPersistentClass;
{$ENDIF}
{$ENDIF}
begin
{$IFDEF COMPILER16_UP}
  {$IFDEF VCL_OR_FMX}
    {$IFDEF FMX}
      LClassGroup := TFmxObject;
    {$ELSE}
      LClassGroup := TControl;
    {$ENDIF}
    GroupDescendentsWith(TIcsWndControl, LClassGroup);
    GroupDescendentsWith(TDnsQuery, LClassGroup);
    GroupDescendentsWith(TFingerCli, LClassGroup);
  {$ENDIF VCL_OR_FMX}
{$ENDIF COMPILER16_UP}

{$IFDEF VCL_OR_FMX}
    RegisterComponents('Overbyte ICS', [
      TWSocket, TWSocketServer,
      THttpCli, THttpServer, THttpAppSrv, TMultipartHttpDownloader,
      TFtpClient, TFtpServer, TMultipartFtpDownloader,
      TSmtpCli, TSyncSmtpCli, THtmlSmtpCli,
      TPop3Cli, TSyncPop3Cli,
      TNntpCli, THtmlNntpCli,
      TDnsQuery, TFingerCli, TPing,
      TIcsCharsetComboBox,
      {$IFDEF DELPHI11}
        TFtpClientW,    { V8.60 }
        TFtpServerW,    { V8.60 }
        TIcsFileCopyW,  { V8.60 }
      {$ENDIF}
      TIcsBlacklist,     { V8.60 }
      TIcsFileCopy,      { V8.60 }
      TIcsDomainNameCache  { V8.71 }
    ]);
{$ENDIF}
{$IFDEF VCL}
    RegisterComponents('Overbyte ICS', [
      { Not yet ported to FMX }
      TEmulVT, TTnCnx, TTnEmulVT, TTnScript,
      {$IFNDEF BCB}
        TWSocketThrdServer,
      {$ENDIF}
      TMultiProgressBar,
      TSysLogClient,
      TSysLogServer,
      TSnmpCli,
      TSmtpServer,
      TIcsWhoisCli,      { V8.60 }
      TIcsTimeServer,    { V8.60 }
      TIcsTimeClient,    { V8.60 }
      TIcsMonSocket,     { V8.71 }
      TIcsMonPcap,       { V8.71 }
      TIcsIpChanges,     { V8.71 }
      TIcsNeighbDevices  { V8.71 }
    ]);
{$ENDIF VCL}
{$IFDEF ICS_COMMON}
    RegisterComponents('Overbyte ICS', [
      { Components neither depending on the FMX nor on the VCL package }
      TMimeDecode,
      TMimeDecodeEx,
      TMimeDecodeW,
      TMimeTypesList,
   {$IFNDEF BCB}
      TIcsCookies,
   {$ENDIF !BCB}
      TTimeList, TIcsLogger
    ]);
{$ENDIF}

{$IFDEF USE_SSL}
  {$IFDEF COMPILER16_UP}
    {$IFDEF VCL_OR_FMX}
      GroupDescendentsWith(TSslBaseComponent, LClassGroup);
    {$ENDIF VCL_OR_FMX}
  {$ENDIF COMPILER16_UP}

  {$IFDEF VCL_OR_FMX}
    RegisterComponents('Overbyte ICS SSL', [
      TSslWSocket, TSslWSocketServer,
      TSslContext,
      TSslFtpClient, TSslFtpServer,
      TSslHttpCli, TSslHttpServer, TSslHttpAppSrv,
      TSslPop3Cli,
      TSslSmtpCli, TSslHtmlSmtpCli,
      TSslNntpCli,
      TSslAvlSessionCache,
      TIcsProxy,
      TIcsHttpProxy,
      TSslHttpRest,   { V8.54 }
      TSimpleWebSrv,  { V8.54 }
      TRestOAuth,     { V8.54 }
      TSslX509Certs,  { V8.54 }
      TIcsMailQueue,  { V8.60 }
      TIcsIpStrmLog,  { V8.60 }
      TIcsFtpMulti,   { V8.60 }
      TIcsHttpMulti,  { V8.60 }
      TDnsQueryHttps, { V8.61 }
      TIcsSms,        { V8.61 }
      TIcsTwitter,    { V8.65 }
      TIcsRestEmail,  { V8.65 }
      TOcspHttp,      { V8.69 }
      {$IFDEF COMPILER11_UP}
        TOAuthBrowser,       { V8.71 not Delphi 7 }
      {$ENDIF}
      TSslWebSocketCli,      { V8.71 }
      TIcsDomNameCacheHttps, { V8.71 }

      {$IFDEF DELPHI11}
        TSslFtpClientW,  { V8.60 }
        TSslFtpServerW,  { V8.60 }
        TIcsFtpMultiW,   { V8.60 }
        TIcsHttpMultiW,  { V8.60 }
      {$ENDIF}
    {$IFDEF VCL}
      {$IFNDEF BCB}
        TSslWSocketThrdServer,
      {$ENDIF}
        TSslSmtpServer,
        TIcsMQTTServer,      { V8.71 }
        TIcsMQTTClient,      { V8.71 }
    {$ENDIF VCL}
    {$IFNDEF OPENSSL_NO_ENGINE}
      TSslEngine,
    {$ENDIF}
      TIcsInetAlive   { V8.66 }
    ]);
  {$ENDIF VCL_OR_FMX}
{$ENDIF USE_SSL}

{$IFDEF VCL_OR_FMX}
    RegisterPropertyEditor(TypeInfo(AnsiString), TWSocket, 'LineEnd',
      TWSocketLineEndProperty);
{$ENDIF}

{$IFDEF COMPILER10_UP}
  {$IFNDEF COMPILER16_UP}
    {$IFDEF ICS_COMMON}
      ForceDemandLoadState(dlDisable); // Required to show our product icon on splash screen
    {$ENDIF}
  {$ENDIF}
{$ENDIF}

end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFDEF COMPILER10_UP}
{$IFDEF VCL}
{$R OverbyteIcsProductIcon.res}
const
{$IFDEF COMPILER14_UP}
    sIcsSplashImg       = 'ICSPRODUCTICONBLACK';
{$ELSE}
    {$IFDEF COMPILER10}
        sIcsSplashImg   = 'ICSPRODUCTICONBLACK';
    {$ELSE}
        sIcsSplashImg   = 'ICSPRODUCTICON';
    {$ENDIF}
{$ENDIF}
    sIcsLongProductName = 'Internet Component Suite V9.0';
    sIcsFreeware        = 'Freeware';
    sIcsDescription     = sIcsLongProductName + #13#10 +
                          //'Copyright (C) 1996-2023 by François PIETTE'+ #13#10 +
                          // Actually there's source included with different
                          // copyright, so either all or none should be mentioned
                          // here.
                          'https://www.overbyte.eu/' + #13#10 +
                          'Wiki: https://wiki.overbyte.eu/' + #13#10 +
                          'Support: https://en.delphipraxis.net/forum/37-ics-internet-component-suite/' + #13#10 +
                          'svn://svn.overbyte.be/ics/trunk' + #13#10 +
                          'https://svn.overbyte.be/svn/ics/trunk' + #13#10 +
                          'User and password = "ics"';

var
    AboutBoxServices: IOTAAboutBoxServices = nil;
    AboutBoxIndex: Integer = -1;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure PutIcsIconOnSplashScreen;
var
    hImage: HBITMAP;
begin
    if Assigned(SplashScreenServices) then begin
        hImage := LoadBitmap(FindResourceHInstance(HInstance), sIcsSplashImg);
        SplashScreenServices.AddPluginBitmap(sIcsLongProductName, hImage,
                                             FALSE, sIcsFreeware);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure RegisterAboutBox;
begin
    if Supports(BorlandIDEServices, IOTAAboutBoxServices, AboutBoxServices) then begin
        AboutBoxIndex := AboutBoxServices.AddPluginInfo(sIcsLongProductName,
          sIcsDescription, 0, FALSE, sIcsFreeware);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure UnregisterAboutBox;
begin
    if (AboutBoxIndex <> -1) and Assigned(AboutBoxServices) then begin
        AboutBoxServices.RemovePluginInfo(AboutBoxIndex);
        AboutBoxIndex := -1;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}

initialization
    PutIcsIconOnSplashScreen;
    RegisterAboutBox;

finalization
    UnregisterAboutBox;
{$ENDIF VCL}
{$ENDIF COMPILER10_UP}
end.
